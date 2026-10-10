"""Game control and log tails for the step-8 blocks and the soak (one machine, TASK_C step 8; D2 2026-10-09: Claude
launches and closes the test game, test profile only). Never touches Lucienne's profile; launching goes through
play_test_profile.ps1 -Unattended (aborts instead of asking when free commit is low)."""
import os, re, subprocess, time
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


def procs():
    out = subprocess.run(["tasklist"], capture_output=True, text=True).stdout
    return {n for n in ("SkyrimSE.exe", "ModOrganizer.exe") if n in out}


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
                         capture_output=True, text=True).stdout.strip()
    return int(out) / 2 ** 30 if out.isdigit() else 0.0


def available_ram_gb():
    """Windows' "Available MBytes" (free + standby) in GB, the counter behind Shae's rule (2026-10-10): relaunch when
    total physical memory in use gets dangerously close to the machine's 31 GB."""
    out = subprocess.run(["powershell", "-NoProfile", "-Command",
                          "(Get-CimInstance Win32_PerfFormattedData_PerfOS_Memory).AvailableMBytes"],
                         capture_output=True, text=True).stdout.strip()
    return int(out) / 1024.0 if out.isdigit() else 99.0


def launch(log=print, timeout=20 * 60, voices=True):
    """Start the test profile unattended (voices=False adds -NoTTS: text/state blocks only; the soak and real play
    always run with voices, Shae 2026-10-10); return when MCP answers. False on any failure."""
    running = procs()
    if running:
        log("LAUNCH refused: already running %s" % sorted(running))
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


def load(run, save, settle_probe=None, timeout=8 * 60):
    """Console-load a save, wait for SkyrimNet's PostLoadGame, then settle. settle_probe: (action, uuid-callable) whose
    eligibility must turn True (SeverActions' checks read ineligible for ~2 min after a load, CS-23 2026-10-09);
    without one, a fixed 120 s."""
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

def save(run, name, timeout=90):
    """Console save that is only trusted once it has really finished (U1 run 15 B-3, 2026-10-10: 'save IEB_B3' over MCP
    logged "Unknown exception executing console command", left IEB_B3.ess.tmp at 0 bytes, and the test's load of the
    missing save 10 s later crashed the game). Waits for SkyrimNet's "SaveGame event received", then for <name>.ess to
    exist with no .tmp beside it and a size stable over 2 s. Returns True only then; never load a save this returned
    False for."""
    sn = Tail(LOGS["skyrimnet"])
    ess, tmp = SAVES + name + ".ess", SAVES + name + ".ess.tmp"
    before = os.path.getmtime(ess) if os.path.exists(ess) else 0
    # Route: SkyrimNet MCP execute_console_command (the only harness save route; real play saves from the menu).
    mem = "Available %.1f GB, game %.1f GB private" % (available_ram_gb(), game_private_gb())
    run.log("SAVE %s: sent via MCP console (%s)" % (name, mem))
    run.tool("execute_console_command", {"command": "save %s" % name})
    if not sn.wait(r"SaveGame event received", timeout=30):
        run.log("SAVE %s: no SaveGame event within 30 s" % name)
    t0, last = time.time(), -1
    while time.time() - t0 < timeout:
        if os.path.exists(ess) and not os.path.exists(tmp) and os.path.getmtime(ess) > before:
            size = os.path.getsize(ess)
            if size > 0 and size == last:
                run.log("SAVE %s: OK via MCP console, complete (%d bytes) after %d s (at send: %s)"
                        % (name, size, time.time() - t0, mem))
                return True
            last = size
        time.sleep(2)
    global SAVE_FAILED
    SAVE_FAILED = True
    err = re.search(r"Unknown exception executing console command", sn.read())
    run.log("SAVE %s: FAILED via MCP console, not complete after %d s (ess=%s tmp=%s%s; at send: %s; now: Available %.1f GB, "
            "game %.1f GB private)" % (name, timeout, os.path.exists(ess), os.path.exists(tmp),
                                        ", SkyrimNet 'Unknown exception'" if err else "", mem, available_ram_gb(),
                                        game_private_gb()))
    return False

def close(run=None, timeout=120):
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
            return True
        time.sleep(3)
    (run.log if run else print)("CLOSE: game still running after %d s" % timeout)
    return False
