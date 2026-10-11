"""Run an external tool (Champollion, Caprica) inside a Windows Job object with a hard memory ceiling and a timeout.
2026-10-11 08:46-08:48: one Champollion run grew to 45 GB in ~90 s while the game held 24 GB; commit hit 94% and Windows
bugchecked (MEMORY.DMP 08:48:50). With the job limit the tool gets an allocation failure (and dies) at the ceiling instead
of taking the machine down; the job is closed with KILL_ON_JOB_CLOSE, so nothing it started survives either.
Usage: from champ_guard import run; run([exe, args...], max_mb=4096, timeout=120) -> (returncode, reason)
reason: "ok" | "timeout" | "memory" (exit while at/over the ceiling) | "error: ..." """
import ctypes, subprocess, time
from ctypes import wintypes

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


def run(cmd, max_mb=4096, timeout=120, cwd=None):
    """Start cmd suspended, put it in a memory-capped job, resume it, wait up to timeout. Never raises on the tool's own
    failure; returns (returncode or None, reason)."""
    job = _job(max_mb)
    try:
        p = subprocess.Popen(cmd, cwd=cwd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                             creationflags=CREATE_NO_WINDOW | CREATE_SUSPENDED)
        hp = k32.OpenProcess(0x1F0FFF, False, p.pid)
        if not hp or not k32.AssignProcessToJobObject(job, hp):
            p.kill()
            return None, "error: AssignProcessToJobObject %d" % ctypes.get_last_error()
        k32.CloseHandle(hp)
        _resume(p.pid)
        try:
            rc = p.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            p.kill()
            return None, "timeout"
        peak = _peak_mb(job)
        if peak >= max_mb - 16:
            return rc, "memory"
        return rc, "ok"
    finally:
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


if __name__ == "__main__":
    import sys
    print(run(sys.argv[1:], max_mb=int(__import__("os").environ.get("CHAMP_MAX_MB", "4096"))))
