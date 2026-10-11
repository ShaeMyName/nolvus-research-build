"""Game control and log tails for the step-8 blocks and the soak (one machine, TASK_C step 8; D2 2026-10-09: Claude
launches and closes the test game, test profile only). Never touches Lucienne's profile; launching goes through
play_test_profile.ps1 -Unattended (aborts instead of asking when free commit is low)."""
import glob, os, re, shutil, subprocess, time
NOWIN = subprocess.CREATE_NO_WINDOW   # no console flash from status checks (Shae 2026-10-11)
from mcp_client import MCP

DOCS = os.path.expanduser("~/Documents/My Games/Skyrim Special Edition/")
LOGS = {
    "papyrus": DOCS + "Logs/Script/Papyrus.0.log",
    "watch": DOCS + "Logs/Script/User/ErrandBridgeWatch.0.log",
    "skyrimnet": DOCS + "SKSE/SkyrimNet.log",
    "sa": DOCS + "SKSE/SeverActionsNative.log",
}
LAUNCHER = "C:/nolvus-research/tts-engines/patches/turbo_slim/play_test_profile.ps1"
SAVES = "C:/Nolvus/Instances/Nolvus Awakening/MODS/profiles/SkyrimNet Test/saves/"
HARNESS_YAML = ("C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/SkyrimNet Config - Test/SKSE/Plugins/SkyrimNet/config/"
                "Harness.yaml")     # test config only; writes approved for the soak and the step-8 blocks (D1, extended to U1)


LAST_NUDGE = ""         # set when the last load's settle needed the F1 narration nudge (noted in every test record after it)
POST_LOAD_AVAIL = 99.0  # available RAM (GB) right after the last load settled (relaunch guard in block.py)


def harness_mode():
    return open(HARNESS_YAML, encoding="utf-8").read().strip().replace(" ", "") == "enabled:true"


def set_harness_mode(on, log=print, wait=180):
    """Write Harness.yaml (file has no line terminator; written the same way). MO2 and the game must be closed:
    waits up to `wait` s for them to exit, else refuses."""
    t0 = time.time()
    while procs() and time.time() - t0 < wait:
        time.sleep(3)
    if procs():
        log("HARNESS refused: %s still running" % sorted(procs()))
        return False
    with open(HARNESS_YAML, "w", encoding="utf-8", newline="") as f:
        f.write("enabled: %s" % ("true" if on else "false"))
    ok = harness_mode() == on
    log("HARNESS mode %s (%s)" % ("on" if on else "off", "verified" if ok else "WRITE FAILED"))
    return ok


# GameMaster switch (Shae 2026-10-10, "Yeah, 1 and 2"): off for test blocks that don't test it, on for blocks that do and
# restored on after every block. Lives in SkyrimNet.yaml of "SkyrimNet Config - Test", the test profile's config mod
# (disabled in the Nolvus Awakening profile's modlist, so Lucienne's profile never loads it). CRLF file: edited bytewise.
SKYRIMNET_YAML = os.path.dirname(HARNESS_YAML) + "/SkyrimNet.yaml"
_GM_RX = re.compile(rb"(\ngamemaster:\r?\n  enabled: )(true|false)(\r?\n)")


def gamemaster():
    m = _GM_RX.search(open(SKYRIMNET_YAML, "rb").read())
    return None if m is None else m.group(2) == b"true"


def set_gamemaster(on, log=print, wait=180):
    """Write gamemaster.enabled in the test profile's SkyrimNet.yaml. The game and MO2 must be closed (as Harness.yaml)."""
    t0 = time.time()
    while procs() and time.time() - t0 < wait:
        time.sleep(3)
    if procs():
        log("GAMEMASTER refused: %s still running" % sorted(procs()))
        return False
    b = open(SKYRIMNET_YAML, "rb").read()
    if len(_GM_RX.findall(b)) != 1:
        log("GAMEMASTER refused: gamemaster.enabled not found exactly once in %s" % SKYRIMNET_YAML)
        return False
    b2 = _GM_RX.sub(lambda m: m.group(1) + (b"true" if on else b"false") + m.group(3), b)
    if b2 != b:
        with open(SKYRIMNET_YAML, "wb") as f:
            f.write(b2)
    ok = gamemaster() == on
    log("GAMEMASTER %s (%s)" % ("on" if on else "off", "verified" if ok else "WRITE FAILED"))
    return ok


# Reviewer 2026-10-10: MO2 writes the profile's lists and its ini on exit; after a forced close never relaunch on a
# possibly half-written modlist. The three lists are compared byte-for-byte with a snapshot taken at block start;
# ModOrganizer.ini changes on every normal exit (window geometry, recent paths), so it is only checked as non-empty
# and still holding its [General] section.
PROFILE_DIR = "C:/Nolvus/Instances/Nolvus Awakening/MODS/profiles/SkyrimNet Test/"
MO2_INI = "C:/Nolvus/Instances/Nolvus Awakening/MO2/ModOrganizer.ini"
PROFILE_LISTS = ("modlist.txt", "plugins.txt", "loadorder.txt")
PROFILE_SNAPSHOT = {}


def profile_snapshot():
    import hashlib
    PROFILE_SNAPSHOT.clear()
    for n in PROFILE_LISTS:
        PROFILE_SNAPSHOT[n] = hashlib.sha256(open(PROFILE_DIR + n, "rb").read()).hexdigest()
    return dict(PROFILE_SNAPSHOT)


def profile_intact(log=print):
    """True when the three profile lists match the block-start snapshot and ModOrganizer.ini looks whole."""
    import hashlib
    bad = [n for n in PROFILE_LISTS if PROFILE_SNAPSHOT.get(n) and
           hashlib.sha256(open(PROFILE_DIR + n, "rb").read()).hexdigest() != PROFILE_SNAPSHOT[n]]
    ini = open(MO2_INI, "rb").read() if os.path.exists(MO2_INI) else b""
    ini_ok = len(ini) > 100 and b"[General]" in ini
    log("PROFILE check: lists %s; ModOrganizer.ini %s" % ("unchanged" if not bad else "CHANGED: " + ", ".join(bad),
                                                          "ok" if ini_ok else "DAMAGED"))
    return not bad and ini_ok


def skyrimnet_log_advancing(seconds=10):
    p = LOGS["skyrimnet"]
    a = os.path.getsize(p) if os.path.exists(p) else 0
    time.sleep(seconds)
    b = os.path.getsize(p) if os.path.exists(p) else 0
    return b != a


def mcp_stall_check(log=print, tries=3, gap=20):
    """Reviewer 2026-10-10: before treating 'MCP unreachable' as a crash, check the game is alive and SkyrimNet.log is
    still advancing, and try a fresh MCP session `tries` times over ~60 s. Returns True if MCP came back. Logs
    MCP_STALL with its duration either way."""
    t0 = time.time()
    alive = "SkyrimSE.exe" in procs()
    advancing = alive and skyrimnet_log_advancing(5)
    for i in range(tries):
        if mcp_up():
            log("MCP_STALL recovered after %d s (attempt %d; game alive=%s, SkyrimNet.log advancing=%s)"
                % (time.time() - t0, i + 1, alive, advancing))
            return True
        time.sleep(gap)
    log("MCP_STALL not recovered after %d s (game alive=%s, SkyrimNet.log advancing=%s)"
        % (time.time() - t0, "SkyrimSE.exe" in procs(), advancing))
    return False


def procs():
    out = subprocess.run(["tasklist"], capture_output=True, creationflags=NOWIN, text=True).stdout
    # REVIEW_LOG RV-73: skse64_loader too (a launch in progress before SkyrimSE.exe appears)
    return {n for n in ("SkyrimSE.exe", "ModOrganizer.exe", "skse64_loader.exe") if n in out}


MIN_AVAIL_GB, MAX_COMMIT_PCT = 8.0, 70.0    # REVIEW_LOG RV-73 pre-launch gate
MAX_NONPAGED_MB = 2560.0                    # REVIEW_LOG RV-73 pool gate (idle 1.38 GB on 2026-10-10 23:35)
POOLGATE_FLAG = "C:/nolvus-research/test_runs/POOLGATE_TRIPPED"


def nonpaged_mb():
    out = subprocess.run(["powershell", "-NoProfile", "-Command",
                          "[int]((Get-CimInstance Win32_PerfFormattedData_PerfOS_Memory).PoolNonpagedBytes/1MB)"],
                         capture_output=True, creationflags=NOWIN, text=True).stdout.strip()
    return float(out) if out.isdigit() else 99999.0


def commit_pct():
    """System commit charge as a % of the commit limit (Win32_OperatingSystem virtual memory)."""
    out = subprocess.run(["powershell", "-NoProfile", "-Command",
                          "$o=Get-CimInstance Win32_OperatingSystem; "
                          "[int](100*($o.TotalVirtualMemorySize-$o.FreeVirtualMemory)/$o.TotalVirtualMemorySize)"],
                         capture_output=True, creationflags=NOWIN, text=True).stdout.strip()
    return float(out) if out.isdigit() else 100.0


def memory_ready(log=print, timeout=600, why="launch"):
    """REVIEW_LOG RV-73 (Windows bugcheck 0xA5 / insufficient resources at 23:22, 20 s after a relaunch): before a
    launch, no game/MO2/loader process, Available >= 8 GB and commit <= 70 %; otherwise wait (logged) up to timeout."""
    t0 = time.time()
    if os.path.exists(POOLGATE_FLAG):
        log("POOLGATE: %s exists (the sampler stopped a run on pool growth); no launch until the reviewer clears it"
            % POOLGATE_FLAG)
        return False
    while True:
        p, av, cp, np_ = procs(), available_ram_gb(), commit_pct(), nonpaged_mb()
        if np_ > MAX_NONPAGED_MB:
            log("POOLGATE refused before %s: nonpaged pool %d MB > %d MB; leave the machine idle (REVIEW_LOG RV-73)"
                % (why, np_, MAX_NONPAGED_MB))
            return False
        if not p and av >= MIN_AVAIL_GB and cp <= MAX_COMMIT_PCT:
            log("MEMGATE ok before %s after %d s: Available %.1f GB, commit %d%%, nonpaged %d MB"
                % (why, time.time() - t0, av, cp, np_))
            return True
        if time.time() - t0 >= timeout:
            log("MEMGATE FAILED before %s after %d s: running %s, Available %.1f GB, commit %d%%"
                % (why, timeout, sorted(p), av, cp))
            return False
        log("MEMGATE waiting before %s: running %s, Available %.1f GB, commit %d%%" % (why, sorted(p), av, cp))
        time.sleep(15)


class Tail:
    """Reads one log from a mark onwards; survives the game rotating the file on launch (size drops -> from 0)."""

    def __init__(self, path):
        self.path, self.pos = path, 0
        self.mark()

    def size(self):
        return os.path.getsize(self.path) if os.path.exists(self.path) else 0

    def mark(self):
        self.pos = self.size()

    def read(self):
        n = self.size()
        if n < self.pos:
            self.pos = 0
        if not os.path.exists(self.path):
            return ""
        with open(self.path, "rb") as f:
            f.seek(self.pos)
            return f.read().decode("utf-8", "replace")

    def wait(self, pattern, timeout=30, poll=1.0):
        end = time.time() + timeout
        rx = re.compile(pattern)
        while True:
            m = rx.search(self.read())
            if m or time.time() >= end:
                return m
            time.sleep(poll)


def mcp_up(timeout=5):
    try:
        MCP().request("tools/list", {}, timeout=timeout)
        return True
    except Exception:
        return False


def game_private_gb():
    """SkyrimSE private bytes in GB (0 if not running). Grows with each in-session reload: 12.5 GB after launch ->
    23 GB after ~10 reloads of T0 (2026-10-10), which with the voice server exhausted the 31 GB machine."""
    out = subprocess.run(["powershell", "-NoProfile", "-Command",
                          "(Get-Process SkyrimSE -ErrorAction SilentlyContinue | Measure-Object PrivateMemorySize64 -Sum).Sum"],
                         capture_output=True, creationflags=NOWIN, text=True).stdout.strip()
    return int(out) / 2 ** 30 if out.isdigit() else 0.0


def available_ram_gb():
    """Windows' "Available MBytes" (free + standby) in GB, the counter behind Shae's rule (2026-10-10): relaunch when
    total physical memory in use gets dangerously close to the machine's 31 GB."""
    out = subprocess.run(["powershell", "-NoProfile", "-Command",
                          "(Get-CimInstance Win32_PerfFormattedData_PerfOS_Memory).AvailableMBytes"],
                         capture_output=True, creationflags=NOWIN, text=True).stdout.strip()
    return int(out) / 1024.0 if out.isdigit() else 99.0


ARCHIVE = [None, 0.0]       # [test_runs/<run>/raw/, run start] once set_archive() is called


def set_archive(run):
    """REVIEW_LOG RV-70-upd (2): keep the raw logs of every block and probe run (Papyrus rotates after 4 launches and
    test_runs kept verdicts only, so a regression could not be told from old behaviour)."""
    ARCHIVE[0] = "C:/nolvus-research/test_runs/%s/raw/" % run
    ARCHIVE[1] = time.time()
    os.makedirs(ARCHIVE[0], exist_ok=True)


def archive_logs(tag):
    """Copy the current game session's raw logs (Papyrus.0, the user script logs, SkyrimNet.log, SA native) and every
    timestamped SkyrimNet session log written since the run started. Call before each launch and at the end."""
    if not ARCHIVE[0]:
        return 0
    stamp = time.strftime("%H%M%S")
    n = 0
    srcs = [DOCS + "Logs/Script/Papyrus.0.log"] + glob.glob(DOCS + "Logs/Script/User/*.0.log") + \
        [LOGS["skyrimnet"], LOGS["sa"]]
    for p in srcs:
        if os.path.exists(p) and os.path.getmtime(p) >= ARCHIVE[1]:
            shutil.copy2(p, ARCHIVE[0] + "%s_%s_%s" % (stamp, tag, os.path.basename(p)))
            n += 1
    for p in glob.glob(DOCS + "SKSE/SkyrimNet.*.log"):
        d = ARCHIVE[0] + os.path.basename(p)
        if os.path.getmtime(p) >= ARCHIVE[1] and not os.path.exists(d):
            shutil.copy2(p, d)
            n += 1
    return n


def openrouter_findings():
    """REVIEW_LOG RV-108: OpenRouter warnings/errors per variant per hour of play over this run's archived SkyrimNet
    logs. Each OpenRouterInterface warning/error is attributed to the latest 'Using variant' / 'Processing template with
    variant' line on the same thread id. Counts only. Returns {"hours": h, "by": {(level, class, variant): n}}."""
    import collections
    by, hours = collections.Counter(), 0.0
    if not ARCHIVE[0]:
        return {"hours": 0.0, "by": by}
    best = {}                      # one copy per session: the largest file per first line (as log_findings does)
    for p in glob.glob(ARCHIVE[0] + "*SkyrimNet*.log"):
        try:
            with open(p, encoding="utf-8", errors="replace") as fh:
                head = fh.readline()
        except OSError:
            continue
        if head not in best or os.path.getsize(p) > os.path.getsize(best[head]):
            best[head] = p
    for p in best.values():
        last, first, end = {}, None, None
        for line in open(p, encoding="utf-8", errors="replace"):
            m = re.match(r"^\[(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)[^]]*\] \[(\d+)\]", line)
            if not m:
                continue
            first = first or m.group(1)
            end = m.group(1)
            v = re.search(r"Using variant '([^']+)' for text generation|Processing template with variant '([^']+)'", line)
            if v:
                last[m.group(2)] = v.group(1) or v.group(2)
            e = re.search(r"\[(warning|error)\] \[OpenRouterInterface\.cpp", line)
            if e:
                low = line.lower()
                cls = "timeout" if "timeout" in low or "timed out" in low else "retry" if "retry" in low else \
                    "empty" if "empty" in low else "other"
                by[(e.group(1), cls, last.get(m.group(2), "?"))] += 1
        if first and end:
            fmt = "%Y-%m-%d %H:%M:%S"
            hours += max(0.0, (time.mktime(time.strptime(end, fmt)) - time.mktime(time.strptime(first, fmt))) / 3600.0)
    return {"hours": hours, "by": by}


def log_findings():
    """REVIEW_LOG RV-76 (3)/(5): over every game session archived in this run (one Papyrus.0.log per session, the
    largest copy of each, keyed by its first line), count blank-key IEB_LOADKEYS, TASKTYPE_RESTORED and array
    errors whose stack names our scripts or IntelEngine. Any count above 0 is a finding. Returns a dict."""
    if not ARCHIVE[0]:
        return {}
    best = {}
    for p in glob.glob(ARCHIVE[0] + "*Papyrus.0.log"):
        with open(p, encoding="utf-8", errors="replace") as f:
            head = f.readline()
        if head not in best or os.path.getsize(p) > os.path.getsize(best[head]):
            best[head] = p
    # RV-76-upd: a blank key with fac=False is a teardown in progress at save (legitimate) -> information only;
    # blank_key_loadkeys counts fac=TRUE blanks (the finding)
    c = {"sessions": len(best), "blank_key_loadkeys": 0, "blank_key_teardown_info": 0, "tasktype_restored": 0,
         "array_errors": 0}
    err = re.compile(r"Error: (?:Cannot cast from None|[^\r\n]*non-array|[^\r\n]*None array)[^\r\n]*((?:\r?\n[^\r\n]*){0,4})")
    for p in best.values():
        text = open(p, encoding="utf-8", errors="replace").read()
        restored = text.count("TASKTYPE_RESTORED")
        # REVIEW_LOG RV-99 (1): a pending single update carried in the save can run the restore BEFORE Maintenance's
        # scan, so the scan then shows the key already back. Every restore is itself a blank-key-on-load event: count it.
        scan_blank = len(re.findall(r"(?i)IEB_LOADKEYS [^\r\n]* key= fac=TRUE", text))
        c["blank_key_loadkeys"] += max(scan_blank, restored)
        c["blank_key_teardown_info"] += len(re.findall(r"(?i)IEB_LOADKEYS [^\r\n]* key= fac=FALSE", text))
        c["tasktype_restored"] += restored
        c["array_errors"] += sum(1 for m in err.finditer(text) if re.search(r"IntelEngine_|IEB_", m.group(0)))
    return c


SAMPLER = os.path.join(os.path.dirname(__file__), "mem_sampler.py")


SAMPLER_HB = "C:/nolvus-research/test_runs/mem_sampler.hb"


def sampler_alive(max_age=30.0):
    """REVIEW_LOG RV-180 (2): the memory guard's heartbeat (written every 5 s) is fresh."""
    try:
        return time.time() - os.path.getmtime(SAMPLER_HB) <= max_age
    except OSError:
        return False


def start_sampler():
    """REVIEW_LOG RV-73 (3): one detached 30 s memory sampler per machine session (pid file guards duplicates)."""
    pidf = "C:/nolvus-research/test_runs/mem_sampler.pid"
    try:
        pid = int(open(pidf).read().strip())
        if str(pid) in subprocess.run(["tasklist", "/FI", "PID eq %d" % pid], capture_output=True, creationflags=NOWIN, text=True).stdout:
            return
    except Exception:
        pass
    # REVIEW_LOG RV-102 follow-up (1): a sampler started by hand has no pid file entry: look for any running one first
    try:
        out = subprocess.run(["powershell", "-NoProfile", "-Command",
                              "(Get-CimInstance Win32_Process -Filter \"Name='python.exe'\" | Where-Object CommandLine -like "
                              "'*mem_sampler*').ProcessId"], capture_output=True, creationflags=NOWIN, text=True,
                             timeout=30).stdout.split()
        if out:
            open(pidf, "w").write(out[0])
            return
    except Exception:
        pass
    p = subprocess.Popen(["python", "-u", SAMPLER], creationflags=0x00000008 | 0x00000200,     # DETACHED, NEW_GROUP
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    open(pidf, "w").write(str(p.pid))


def launch(log=print, timeout=20 * 60, voices=True):
    """Start the test profile unattended (voices=False adds -NoTTS: text/state blocks only; the soak and real play
    always run with voices, Shae 2026-10-10); return when MCP answers. False on any failure."""
    start_sampler()
    for _ in range(12):                       # REVIEW_LOG RV-180 (2): never launch without a live memory guard
        if sampler_alive():
            break
        time.sleep(2.5)
    else:
        log("LAUNCH refused: the memory guard (mem_sampler) has no fresh heartbeat")
        return False
    running = procs()
    if running:
        log("LAUNCH refused: already running %s" % sorted(running))
        return False
    archive_logs("prelaunch")     # the previous session's logs rotate away on this launch
    start_sampler()
    if not memory_ready(log):
        log("LAUNCH refused: memory gate (REVIEW_LOG RV-73)")
        return False
    subprocess.Popen(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-WindowStyle", "Hidden",
                      "-File", LAUNCHER, "-Unattended"] + ([] if voices else ["-NoTTS"]),
                     creationflags=getattr(subprocess, "CREATE_NEW_CONSOLE", 0))
    log("LAUNCH started (%s)" % ("with voices" if voices else "no voices"))
    t0 = time.time()
    while time.time() - t0 < timeout:
        if "SkyrimSE.exe" in procs() and mcp_up():
            log("LAUNCH ok after %d s (MCP answers; game %.1f GB private)" % (time.time() - t0, game_private_gb()))
            return True
        time.sleep(10)
    log("LAUNCH failed: no MCP answer within %d s (running: %s)" % (timeout, sorted(procs())))
    return False


def load(run, save, settle_probe=None, timeout=8 * 60, quick=False):
    """Console-load a save, wait for SkyrimNet's PostLoadGame, then settle. settle_probe: (action, uuid-callable) whose
    eligibility must turn True (SeverActions' checks read ineligible for ~2 min after a load, CS-23 2026-10-09);
    without one, a fixed 120 s. quick=True (RV-151: tests_ff reloads T0 mid-test, no SkyrimNet action involved): return as soon as
    the game is in and unpaused, with no eligibility warm-up or settle wait."""
    ess = SAVES + save + ".ess"
    if not os.path.exists(ess) or os.path.exists(ess + ".tmp"):
        # U1 run 15 B-3: loading a save whose write had failed (only IEB_B3.ess.tmp on disk) crashed the game.
        run.log("LOAD %s: refused, save incomplete (ess=%s tmp=%s)" % (save, os.path.exists(ess), os.path.exists(ess + ".tmp")))
        return False
    sn = Tail(LOGS["skyrimnet"])
    t0 = time.time()
    # Right after launch MCP answers a few seconds before the main menu accepts a console load (run 2026-10-10 11:20:
    # the command was ignored). Resend only on a positive "not started" signal: no PreLoadGame AND Papyrus never froze
    # its VM since the send (a load in progress freezes it first). Anything else that started means wait, never resend.
    for attempt in range(6):
        pap = Tail(LOGS["papyrus"])
        run.tool("execute_console_command", {"command": "load %s" % save})
        if sn.wait(r"PreLoadGame event received for save: %s\.ess" % re.escape(save), timeout=60):
            break
        if re.search(r"VM is freezing|PreLoadGame|PostLoadGame", pap.read() + sn.read()):
            run.log("LOAD %s: no PreLoadGame after 60 s but a load/save started; not resending" % save)
            break
        run.log("LOAD %s: not started after 60 s (no VM freeze, no load event; attempt %d), resending" % (save, attempt + 1))
    m = sn.wait(r"PreLoadGame event received for save: %s\.ess[\s\S]*PostLoadGame event received" % re.escape(save),
                timeout=timeout)
    if not m:
        run.log("LOAD %s: no PostLoadGame within %d s" % (save, timeout))
        return False
    run.log("LOAD %s: in game after %d s (game %.1f GB private)" % (save, time.time() - t0, game_private_gb()))
    # A modal box (SkyrimNet's Timeline Mismatch without harness mode, a crash notice...) freezes Papyrus and makes
    # SkyrimNet report the game paused: 0 eligible actions for everyone (shakedown 2026-10-10). Wait it out briefly.
    pu = run.tool("get_player_info", {}).get("uuid")
    pu = ("%X" % pu) if isinstance(pu, int) else pu
    for _ in range(18):
        p = run.tool("render_template", {"actor_uuid": pu, "content": "{{ isTimePaused }}"}).get("renderedContent")
        if p == "false":
            break
        time.sleep(5)
    else:
        run.log("LOAD %s: SkyrimNet still reports the game paused after 90 s (a modal box is open?)" % save)
        return False
    global POST_LOAD_AVAIL
    if "auto-clearing timeline" in sn.read():
        run.log("LOAD %s: harness mode auto-cleared the timeline (= Delete History)" % save)
    # SkyrimNet evaluates action eligibility only once something makes it build a prompt (usually the GameMaster's
    # first lull trigger ~120 s after unpause; once ~9.5 min). Until "Completed eligibility pre-warming" every actor
    # has 0 eligible actions (notices_research.md, 2026-10-10). Wait for it; after 45 s nudge it with one narration
    # by F1 (IEB_TestCtl.Narrate = DirectNarration), which builds a prompt.
    global LAST_NUDGE
    LAST_NUDGE = ""
    if quick:
        POST_LOAD_AVAIL = available_ram_gb()
        run.log("LOAD %s: quick, no settle wait (game %.1f GB; %.1f GB RAM available)" % (save, game_private_gb(), POST_LOAD_AVAIL))
        return True
    warm = r"Completed eligibility pre-warming"
    if not sn.wait(warm, timeout=45):
        LAST_NUDGE = time.strftime("%H:%M:%S")
        run.tool("execute_quest_function", {"quest_editor_id": "IEB_TestQuest", "script_name": "IEB_TestCtl",
                                             "function_name": "Narrate", "arguments": [0xE1BA9]})
        run.log("SETTLE: no eligibility warm-up after 45 s; nudged with one F1 narration")
        if not sn.wait(warm, timeout=120):
            run.log("SETTLE: SkyrimNet never warmed eligibility (tests that need actions will say so)")
    else:
        run.log("SETTLE: SkyrimNet warmed eligibility after %d s (game %.1f GB)" % (time.time() - t0, game_private_gb()))
    if settle_probe:
        action, uuid_of = settle_probe
        for _ in range(12):
            u = uuid_of()
            if action == "__any__":
                r = run.tool("get_eligible_actions", {"actor_uuid": u}) if u else {}
                ok = isinstance(r, dict) and (r.get("eligibleCount") or 0) > 0
            else:
                r = run.tool("check_action_eligibility", {"action_name": action, "actor_uuid": u}) if u else {}
                ok = isinstance(r, dict) and (r.get("isEligible") or r.get("eligible"))
            if ok:
                POST_LOAD_AVAIL = available_ram_gb()
                run.log("SETTLE ok after %d s (%s eligible; game %.1f GB; %.1f GB RAM available)"
                        % (time.time() - t0, action, game_private_gb(), POST_LOAD_AVAIL))
                return True
            time.sleep(10)
        run.log("SETTLE probe not eligible within 2 min after warm-up; continuing (tests that need SA will say so)")
        POST_LOAD_AVAIL = available_ram_gb()
        return True
    time.sleep(120)
    run.log("SETTLE fixed 120 s")
    return True



# Set when a console save fails: Papyrus' VM stays frozen until the next load (U1 run 15, IEB_B3 and IEB_B3b_pre),
# so block.py reloads the block save before the next test. Cleared by block.py.
SAVE_FAILED = False

def save_thread(text, name):
    """R29: the SkyrimNet thread that ran the console save, and whether the engine's SaveGame event came on that same
    thread (U1 run 15: both failed saves ran on the MCP worker thread, not the main thread)."""
    m = re.search(r"\] \[(\d+)\] \[info\] \[ConsoleCommandManager[^\]]*\] ConsoleCommandManager: Executing console "
                  r"command 'save %s'" % re.escape(name), text)
    if not m:
        return "thread unknown (no 'Executing console command' line)"
    ev = re.search(r"\] \[(\d+)\] \[info\] \[SkyrimMain[^\]]*\] SkyrimNet: SaveGame event received", text[m.end():])
    return "command thread %s; SaveGame event %s" % (m.group(1), ("on thread %s" % ev.group(1)) if ev else "none")


SAVE_ROUTE = "papyrus"     # REVIEW_LOG R29: Papyrus Game.SaveGame (IEB_TestCtl.SaveNamed) first; "console" = the old route


def save(run, name, timeout=90, route=None):
    """Console save that is only trusted once it has really finished (U1 run 15 B-3, 2026-10-10: 'save IEB_B3' over MCP
    logged "Unknown exception executing console command", left IEB_B3.ess.tmp at 0 bytes, and the test's load of the
    missing save 10 s later crashed the game). Waits for SkyrimNet's "SaveGame event received", then for <name>.ess to
    exist with no .tmp beside it and a size stable over 2 s. Returns True only then; never load a save this returned
    False for."""
    sn = Tail(LOGS["skyrimnet"])
    ess, tmp = SAVES + name + ".ess", SAVES + name + ".ess.tmp"
    before = os.path.getmtime(ess) if os.path.exists(ess) else 0
    route = route or SAVE_ROUTE
    mem = "Available %.1f GB, game %.1f GB private" % (available_ram_gb(), game_private_gb())
    if route == "papyrus":
        # REVIEW_LOG R29: the MCP console save failed 3/3 on 2026-10-10 with harness mode on; Game.SaveGame through
        # Papyrus worked (run 18 L-9's KillAndSave). Completion is still judged only on the .ess file below.
        run.log("SAVE %s: sent via Papyrus SaveNamed (%s)" % (name, mem))
        run.ctl("SaveNamed", [name], sync=False)
    else:
        run.log("SAVE %s: sent via MCP console (%s)" % (name, mem))
        run.tool("execute_console_command", {"command": "save %s" % name})
    if not sn.wait(r"SaveGame event received", timeout=30):
        run.log("SAVE %s: no SaveGame event within 30 s" % name)
    t0, last = time.time(), -1
    while time.time() - t0 < timeout:
        if os.path.exists(ess) and not os.path.exists(tmp) and os.path.getmtime(ess) > before:
            size = os.path.getsize(ess)
            if size > 0 and size == last:
                run.log("SAVE %s: %s" % (name, save_thread(sn.read(), name)))
                run.log(("SAVE %s: OK via " + route + ", complete (%d bytes) after %d s (at send: %s)")
                        % (name, size, time.time() - t0, mem))
                return True
            last = size
        time.sleep(2)
    global SAVE_FAILED
    SAVE_FAILED = True
    run.log("SAVE %s: %s" % (name, save_thread(sn.read(), name)))
    err = re.search(r"Unknown exception executing console command", sn.read())
    run.log(("SAVE %s: FAILED via " + route + ", not complete after %d s (ess=%s tmp=%s%s; at send: %s; now: Available %.1f GB, "
            "game %.1f GB private)") % (name, timeout, os.path.exists(ess), os.path.exists(tmp),
                                        ", SkyrimNet 'Unknown exception'" if err else "", mem, available_ram_gb(),
                                        game_private_gb()))
    return False

def close(run=None, timeout=120, force=False):
    """Close the game from the console (no save is made). Waits for the process to exit; the launcher then stops the
    TTS server itself."""
    if "SkyrimSE.exe" not in procs():
        return True
    try:
        MCP().request("tools/call", {"name": "execute_console_command", "arguments": {"command": "qqq"}}, timeout=10)
    except Exception:
        pass
    t0 = time.time()
    while time.time() - t0 < timeout:
        if "SkyrimSE.exe" not in procs():
            (run.log if run else print)("CLOSE ok after %d s" % (time.time() - t0))
            # REVIEW_LOG RV-73: "window gone" is not enough; wait for MO2/loader to exit and memory to recover
            memory_ready(run.log if run else print, timeout=300, why="next step (post-close)")
            return True
        time.sleep(3)
    (run.log if run else print)("CLOSE: game still running after %d s" % timeout)
    if force:   # a hung game ignores qqq (U1 run 15: hung load after a failed console save); the test profile only
        subprocess.run(["taskkill", "/F", "/IM", "SkyrimSE.exe"], capture_output=True, creationflags=NOWIN)
        time.sleep(5)
        gone = "SkyrimSE.exe" not in procs()
        (run.log if run else print)("CLOSE: force-killed SkyrimSE.exe (%s)" % ("gone" if gone else "STILL RUNNING"))
        forced_mo2 = [False]
        # U1 run 18: after a force-kill MO2 (started by our launcher) stays open, so the relaunch was refused. Ask it to
        # close (WM_CLOSE, no /F), wait, and force it only if it ignores that.
        if gone and "ModOrganizer.exe" in procs():
            subprocess.run(["taskkill", "/IM", "ModOrganizer.exe"], capture_output=True, creationflags=NOWIN)
            t1 = time.time()
            while "ModOrganizer.exe" in procs() and time.time() - t1 < 30:
                time.sleep(2)
            if "ModOrganizer.exe" in procs():
                subprocess.run(["taskkill", "/F", "/IM", "ModOrganizer.exe"], capture_output=True, creationflags=NOWIN)
                forced_mo2[0] = True
                time.sleep(3)
            (run.log if run else print)("CLOSE: ModOrganizer.exe %s" % ("closed" if "ModOrganizer.exe" not in procs()
                                                                     else "STILL RUNNING"))
        if gone and not procs() and forced_mo2[0] and not profile_intact(run.log if run else print):
            (run.log if run else print)("CLOSE: MO2 was force-closed and the profile changed; NOT relaunching")
            return False
        return gone and not procs()
    return False
