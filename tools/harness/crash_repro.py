"""REVIEW_LOG RV-79 (3): crash-series repro (harness ON, one launch per arm, 15 min idle watch each, no dismissal).
 R1: load IEB_RV72_mid (mid-errand save), wait for Jenassa's arrival (or that she has arrived), then 15 min idle.
 R2: load T0, no errand, same spot, 15 min idle (location control).
 R3: load T0, fresh errand to Dragonsreach (no load in between), arrival, then 15 min idle (no-load control).
Every load's IEB_LOADKEYS lines (with the f7ddfff sibling fields) are copied into the result (RV-79 (2): blank key
+ crash correlation). An arm stops at its first crash (game gone / MCP refused): the crash log name, time since
load and time since arrival are recorded, and the next arm starts after the memory gate.
Usage: crash_repro.py [arms, e.g. R1 or R1,R2,R3]   (game and MO2 closed; not run until Shae decides the reaper)"""
import glob, os, re, sys, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import block, game
from runner import Run

OUT = "C:/nolvus-research/test_runs/"
CRASHES = "C:/Users/sharp/Documents/My Games/Skyrim Special Edition/SKSE/"
F1 = 0x000E1BA9
WATCH = 15 * 60
LOG = []


def say(m):
    line = "%s %s" % (time.strftime("%H:%M:%S"), m)
    print(line, flush=True)
    LOG.append(line)


def crash_files():
    return set(glob.glob(CRASHES + "crash-*.log"))


def idle(label, t_load, t_arr, before):
    """Watch for WATCH s; True if the game survived."""
    t0 = time.time()
    while time.time() - t0 < WATCH:
        time.sleep(15)
        if "SkyrimSE.exe" not in game.procs():
            new = sorted(crash_files() - before)
            say("%s CRASH after %d s idle; %d s since load%s; crash log %s"
                % (label, time.time() - t0, time.time() - t_load,
                   ("; %d s since arrival" % (time.time() - t_arr)) if t_arr else "",
                   os.path.basename(new[-1]) if new else "none"))
            return False
    say("%s survived %d s idle" % (label, WATCH))
    return True


def arm(name):
    before = crash_files()
    if game.procs():
        game.close(None, timeout=60, force=True)
    if not game.harness_mode():
        game.set_harness_mode(True, say)
    if not game.launch(say, voices=False):
        say("%s ABORT: launch refused or failed" % name)
        return None
    ctl = Run("CR_" + name)
    pap = game.Tail(game.LOGS["papyrus"])
    save = "IEB_RV72_mid" if name == "R1" else "T0"
    ok = game.load(ctl, save, None)
    t_load = time.time()
    say("%s LOAD %s: %s" % (name, save, "OK" if ok else "FAILED"))
    if not ok:
        return None
    text = pap.read()
    for l in text.splitlines():
        if "IEB_LOADKEYS" in l or "TASKTYPE_RESTORED" in l:
            say("  " + l.strip()[:300])
    t_arr = None
    if name in ("R1", "R3"):
        block.ie_test_settings(ctl)
        t = game.Tail(game.LOGS["papyrus"])
        if name == "R3":
            ctl.ctl("StartTask", [F1, "GoToLocation", "Dragonsreach", "1", "1"])
            if not t.wait(r"(?i)\[IEB\] TAKE actor=Jenassa", 30):
                say("R3 INCONCLUSIVE: no TAKE")
                return None
        if "Jenassa arrived at" in text or t.wait(r"IntelEngine: Jenassa arrived at[^\r\n]*", 900):
            t_arr = time.time()
            say("%s arrival seen; waiting phase starts" % name)
        else:
            say("%s INCONCLUSIVE: no arrival in 900 s" % name)
            return None
    survived = idle(name, t_load, t_arr, before)
    if survived:
        game.archive_logs(name)
        game.close(None, timeout=60, force=True)
    else:
        game.archive_logs(name + "_crashed")
    return survived


def main():
    if game.procs():
        sys.exit("ABORT: game or MO2 running")
    run_id = "CRASH_repro_%s" % time.strftime("%Y%m%d-%H%M%S")
    game.set_archive(run_id)
    arms = sys.argv[1].split(",") if len(sys.argv) > 1 else ["R1", "R2", "R3"]
    res = {}
    for a in arms:
        try:
            res[a] = arm(a)
        except Exception as e:
            say("%s ERROR %s" % (a, e))
            res[a] = None
        if game.procs():
            game.close(None, timeout=60, force=True)
        if os.path.exists(game.POOLGATE_FLAG):
            say("POOLGATE TRIPPED: stopping")
            break
    say("log findings: %s" % game.log_findings())
    say("SUMMARY " + " | ".join("%s %s" % (k, {True: "survived", False: "CRASHED", None: "INCONCLUSIVE"}[v])
                                for k, v in res.items()))
    open(OUT + run_id + ".txt", "w", encoding="utf-8").write("\n".join(LOG) + "\n")
    say("CRASH REPRO DONE")


if __name__ == "__main__":
    main()
