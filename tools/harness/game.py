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


def launch(log=print, timeout=20 * 60):
    """Start the test profile (TTS server + game) unattended; return when MCP answers. False on any failure."""
    running = procs()
    if running:
        log("LAUNCH refused: already running %s" % sorted(running))
        return False
    subprocess.Popen(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-WindowStyle", "Hidden",
                      "-File", LAUNCHER, "-Unattended"], creationflags=getattr(subprocess, "CREATE_NEW_CONSOLE", 0))
    t0 = time.time()
    while time.time() - t0 < timeout:
        if "SkyrimSE.exe" in procs() and mcp_up():
            log("LAUNCH ok after %d s (MCP answers)" % (time.time() - t0))
            return True
        time.sleep(10)
    log("LAUNCH failed: no MCP answer within %d s (running: %s)" % (timeout, sorted(procs())))
    return False


def load(run, save, settle_probe=None, timeout=8 * 60):
    """Console-load a save, wait for SkyrimNet's PostLoadGame, then settle. settle_probe: (action, uuid-callable) whose
    eligibility must turn True (SeverActions' checks read ineligible for ~2 min after a load, CS-23 2026-10-09);
    without one, a fixed 120 s."""
    sn = Tail(LOGS["skyrimnet"])
    t0 = time.time()
    # Right after launch MCP answers a few seconds before the main menu accepts a console load (run 2026-10-10 11:20:
    # the command was ignored). Resend until the load starts.
    for attempt in range(6):
        run.tool("execute_console_command", {"command": "load %s" % save})
        if sn.wait(r"PreLoadGame event received for save: %s\.ess" % re.escape(save), timeout=60):
            break
        run.log("LOAD %s: not started after 60 s (attempt %d), resending" % (save, attempt + 1))
    m = sn.wait(r"PreLoadGame event received for save: %s\.ess[\s\S]*PostLoadGame event received" % re.escape(save),
                timeout=timeout)
    if not m:
        run.log("LOAD %s: no PostLoadGame within %d s" % (save, timeout))
        return False
    run.log("LOAD %s: in game after %d s" % (save, time.time() - t0))
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
    if "auto-clearing timeline" in sn.read():
        run.log("LOAD %s: harness mode auto-cleared the timeline (= Delete History)" % save)
    if settle_probe:
        action, uuid_of = settle_probe
        for _ in range(36):
            u = uuid_of()
            r = run.tool("check_action_eligibility", {"action_name": action, "actor_uuid": u}) if u else {}
            if isinstance(r, dict) and (r.get("isEligible") or r.get("eligible")):
                run.log("SETTLE ok after %d s (%s eligible)" % (time.time() - t0, action))
                return True
            time.sleep(10)
        run.log("SETTLE probe never turned eligible within 6 min; continuing (tests that need SA will say so)")
        return True
    time.sleep(120)
    run.log("SETTLE fixed 120 s")
    return True


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
