"""Run an external tool (Champollion, Caprica) inside a Windows Job object with a hard memory ceiling and a timeout.
2026-10-11 08:46-08:48: one Champollion run grew to 45 GB in ~90 s while the game held 24 GB; commit hit 94% and Windows
bugchecked (MEMORY.DMP 08:48:50). With the job limit the tool gets an allocation failure (and dies) at the ceiling instead
of taking the machine down; the job is closed with KILL_ON_JOB_CLOSE, so nothing it started survives either.
Usage: from champ_guard import run; run([exe, args...], max_mb=4096, timeout=120) -> (returncode, reason)
reason: "ok" | "timeout" | "memory" (exit while at/over the ceiling) | "error: ..." """
import ctypes, os, subprocess, time
from ctypes import wintypes

LOG = "C:/nolvus-research/test_runs/champ_guard.log"     # REVIEW_LOG RV-102 (2): every call: argv, input sizes, peak
MIN_AVAIL_GB = 6.0                                        # RV-102 (4): build checks wait for this much free RAM


class MEMORYSTATUSEX(ctypes.Structure):
    _fields_ = [("dwLength", wintypes.DWORD), ("dwMemoryLoad", wintypes.DWORD), ("ullTotalPhys", ctypes.c_ulonglong),
                ("ullAvailPhys", ctypes.c_ulonglong), ("ullTotalPageFile", ctypes.c_ulonglong),
                ("ullAvailPageFile", ctypes.c_ulonglong), ("ullTotalVirtual", ctypes.c_ulonglong),
                ("ullAvailVirtual", ctypes.c_ulonglong), ("ullAvailExtendedVirtual", ctypes.c_ulonglong)]


def avail_gb():
    m = MEMORYSTATUSEX()
    m.dwLength = ctypes.sizeof(m)
    ctypes.windll.kernel32.GlobalMemoryStatusEx(ctypes.byref(m))
    return m.ullAvailPhys / 1024.0 ** 3


def _log(line):
    try:
        with open(LOG, "a", encoding="utf-8") as f:
            f.write("%s %s\n" % (time.strftime("%Y-%m-%d %H:%M:%S"), line))
    except OSError:
        pass

JOB_OBJECT_LIMIT_PROCESS_MEMORY = 0x00000100
JOB_OBJECT_LIMIT_JOB_MEMORY = 0x00000200
JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE = 0x00002000
JobObjectExtendedLimitInformation = 9
CREATE_NO_WINDOW = 0x08000000
CREATE_SUSPENDED = 0x00000004


class IO_COUNTERS(ctypes.Structure):
    _fields_ = [(n, ctypes.c_ulonglong) for n in ("ReadOperationCount", "WriteOperationCount", "OtherOperationCount",
                                                    "ReadTransferCount", "WriteTransferCount", "OtherTransferCount")]


class BASIC(ctypes.Structure):
    _fields_ = [("PerProcessUserTimeLimit", ctypes.c_longlong), ("PerJobUserTimeLimit", ctypes.c_longlong),
                ("LimitFlags", wintypes.DWORD), ("MinimumWorkingSetSize", ctypes.c_size_t),
                ("MaximumWorkingSetSize", ctypes.c_size_t), ("ActiveProcessLimit", wintypes.DWORD),
                ("Affinity", ctypes.c_size_t), ("PriorityClass", wintypes.DWORD), ("SchedulingClass", wintypes.DWORD)]


class EXTENDED(ctypes.Structure):
    _fields_ = [("BasicLimitInformation", BASIC), ("IoInfo", IO_COUNTERS), ("ProcessMemoryLimit", ctypes.c_size_t),
                ("JobMemoryLimit", ctypes.c_size_t), ("PeakProcessMemoryUsed", ctypes.c_size_t),
                ("PeakJobMemoryUsed", ctypes.c_size_t)]


k32 = ctypes.WinDLL("kernel32", use_last_error=True)
k32.CreateJobObjectW.restype = wintypes.HANDLE
k32.OpenProcess.restype = wintypes.HANDLE
k32.OpenThread.restype = wintypes.HANDLE
k32.GetCurrentProcess.restype = wintypes.HANDLE
k32.AssignProcessToJobObject.argtypes = [wintypes.HANDLE, wintypes.HANDLE]
k32.SetInformationJobObject.argtypes = [wintypes.HANDLE, ctypes.c_int, ctypes.c_void_p, wintypes.DWORD]
k32.QueryInformationJobObject.argtypes = [wintypes.HANDLE, ctypes.c_int, ctypes.c_void_p, wintypes.DWORD, ctypes.c_void_p]
k32.CloseHandle.argtypes = [wintypes.HANDLE]


def _job(max_mb):
    h = k32.CreateJobObjectW(None, None)
    if not h:
        raise OSError("CreateJobObject failed %d" % ctypes.get_last_error())
    info = EXTENDED()
    info.BasicLimitInformation.LimitFlags = (JOB_OBJECT_LIMIT_PROCESS_MEMORY | JOB_OBJECT_LIMIT_JOB_MEMORY |
                                             JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE)
    info.ProcessMemoryLimit = max_mb * 1024 * 1024
    info.JobMemoryLimit = max_mb * 1024 * 1024
    if not k32.SetInformationJobObject(h, JobObjectExtendedLimitInformation, ctypes.byref(info), ctypes.sizeof(info)):
        raise OSError("SetInformationJobObject failed %d" % ctypes.get_last_error())
    return h


def _peak_mb(job):
    info = EXTENDED()
    if k32.QueryInformationJobObject(job, JobObjectExtendedLimitInformation, ctypes.byref(info), ctypes.sizeof(info), None):
        return info.PeakJobMemoryUsed // (1024 * 1024)
    return -1


def run(cmd, max_mb=4096, timeout=120, cwd=None, inherit=False, min_avail_gb=None):
    """Start cmd suspended, put it in a memory-capped job, resume it, wait up to timeout. Never raises on the tool's own
    failure; returns (returncode or None, reason)."""
    waited = 0
    need = MIN_AVAIL_GB if min_avail_gb is None else min_avail_gb
    while avail_gb() < need and waited < 600:                # RV-102 (4): never start a tool into low memory
        time.sleep(5)
        waited += 5
    if avail_gb() < need:
        _log("REFUSED %s: available %.1f GB < %.1f GB after 600 s" % (cmd, avail_gb(), need))
        return None, "error: low memory (%.1f GB available)" % avail_gb()
    sizes = [os.path.getsize(a) for a in cmd[1:] if isinstance(a, str) and os.path.isfile(a)]
    job = _job(max_mb)
    t0 = time.time()
    res = (None, "error: not started")
    try:
        out = subprocess.PIPE if inherit else subprocess.DEVNULL       # inherit: the output is relayed after the run
        p = subprocess.Popen(cmd, cwd=cwd, stdout=out, stderr=subprocess.STDOUT if inherit else out,
                             creationflags=CREATE_NO_WINDOW | CREATE_SUSPENDED)
        hp = k32.OpenProcess(0x1F0FFF, False, p.pid)
        if not hp or not k32.AssignProcessToJobObject(job, hp):
            p.kill()
            return None, "error: AssignProcessToJobObject %d" % ctypes.get_last_error()
        k32.CloseHandle(hp)
        _resume(p.pid)
        try:
            if inherit:
                data, _ = p.communicate(timeout=timeout)
                import sys as _s
                _s.stdout.write(data.decode("utf-8", "replace"))
                _s.stdout.flush()
            rc = p.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            p.kill()
            res = (None, "timeout")
            return res
        peak = _peak_mb(job)
        if peak >= max_mb - 16 or (rc != 0 and peak >= max_mb // 2):
            res = (rc, "memory")
        elif rc not in (0, None) and rc > 255:
            res = (rc, "crashed")         # e.g. 0xC0000005: Champollion's decompiler on IEB_TestCtl.pex (2026-10-11)
        else:
            res = (rc, "ok")
        return res
    finally:
        _log("%s rc=%s peak=%dMB cap=%dMB %.1fs in=%s argv=%s" % (res[1], res[0], _peak_mb(job), max_mb, time.time() - t0,
                                                                   sizes, cmd))
        k32.CloseHandle(job)          # KILL_ON_JOB_CLOSE: anything still in the job dies here


def _resume(pid):
    """Resume every thread of a CREATE_SUSPENDED process (Toolhelp snapshot)."""
    class THREADENTRY32(ctypes.Structure):
        _fields_ = [("dwSize", wintypes.DWORD), ("cntUsage", wintypes.DWORD), ("th32ThreadID", wintypes.DWORD),
                    ("th32OwnerProcessID", wintypes.DWORD), ("tpBasePri", ctypes.c_long), ("tpDeltaPri", ctypes.c_long),
                    ("dwFlags", wintypes.DWORD)]
    k32.CreateToolhelp32Snapshot.restype = wintypes.HANDLE
    snap = k32.CreateToolhelp32Snapshot(0x00000004, 0)
    te = THREADENTRY32()
    te.dwSize = ctypes.sizeof(te)
    ok = k32.Thread32First(snap, ctypes.byref(te))
    while ok:
        if te.th32OwnerProcessID == pid:
            th = k32.OpenThread(0x0002, False, te.th32ThreadID)
            if th:
                k32.ResumeThread(th)
                k32.CloseHandle(th)
        ok = k32.Thread32Next(snap, ctypes.byref(te))
    k32.CloseHandle(snap)


_SELF_JOB = []


def limit_self(max_mb=4096):
    """RV-102 (3): put THIS Python process (and anything it starts) under a memory-capped job: for our binary parsers
    (espio users). The job handle is kept for the life of the process."""
    if _SELF_JOB:
        return
    try:
        job = _job(max_mb)
        if k32.AssignProcessToJobObject(job, k32.GetCurrentProcess()):
            _SELF_JOB.append(job)
    except OSError:
        pass


if __name__ == "__main__":
    # CLI for shell scripts (Caprica in build_*.sh): champ_guard.py [--max-mb N] [--timeout S] [--min-avail G] -- cmd ...
    import sys
    a = sys.argv[1:]
    opts = {"--max-mb": "4096", "--timeout": "300", "--min-avail": "3"}
    while a and a[0] != "--":
        opts[a[0]] = a[1]
        a = a[2:]
    rc, why = run(a[1:], max_mb=int(opts["--max-mb"]), timeout=int(opts["--timeout"]), inherit=True,
                  min_avail_gb=float(opts["--min-avail"]))
    if why != "ok":
        sys.stderr.write("champ_guard: %s (%s)\n" % (why, a[1] if len(a) > 1 else "?"))
        sys.exit(99)
    sys.exit(rc or 0)
