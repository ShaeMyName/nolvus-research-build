"""REVIEW_LOG RV-79 (3): crash-series repro (harness ON, one launch per arm, 15 min idle watch each, no dismissal).
 R1: load IEB_RV72_mid (mid-errand save), wait for Jenassa's arrival (or that she has arrived), then 15 min idle.
 R2: load T0, no errand, same spot, 15 min idle (location control).
 R3: load T0, fresh errand to Dragonsreach (no load in between), arrival, then 15 min idle (no-load control).
Every load's IEB_LOADKEYS lines (with the f7ddfff sibling fields) are copied into the result (RV-79 (2): blank key
+ crash correlation). An arm stops at its first crash (game gone / MCP refused): the crash log name, time since
load and time since arrival are recorded, and the next arm starts after the memory gate.
RV-82: every arm logs CRASHCTX (game hour, days passed, Saffir's package + 3D) at start and every ~60 s;
R2/R3 set R1's game hour (+-0.25 h) as well as its spot, else INCONCLUSIVE.
REVIEW_LOG RV-90: R2 is the "location+hour control, crash actor absent" (Saffir indoors in R2, in the player's cell in
R1 and both crashes). R2P (R2'): load IEB_RV72_mid like R1 (same world/Saffir state, spot and hour), cancel Jenassa's
errand at once, 15 min idle: the errand-free control in the crash actor's presence. Replaces the optional R1 repeats.
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


POSF = OUT + "crash_repro_R1_pos.txt"
HOURF = OUT + "crash_repro_R1_hour.txt"
SAFFIR = 0x0001A66C   # RV-82: the actor processed in both crash logs (AI Overhaul package 0xCF001957)
CTX_RX = r"(?i)CRASHCTX hour=(-?[\d.]+) days=(-?[\d.]+)[^\r\n]*"


def ctx(ctl, label, op="CrashCtx", args=None):
    """RV-82: game hour + days passed + Saffir's package / 3D state; returns the hour or None."""
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl(op, args if args is not None else [SAFFIR], sync=False)
    m = t.wait(CTX_RX, 30)
    say("%s: %s" % (label, m.group(0) if m else "no CRASHCTX line"))
    return float(m.group(1)) if m else None


def where(ctl, label):
    """[cell, ws, x, y, z] from TestCtl.PlayerWhere, or None."""
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl("PlayerWhere", [], sync=False)
    m = t.wait(r"(?i)PLAYERPOS cell=(\S+) ws=(\S+) x=(-?[\d.]+) y=(-?[\d.]+) z=(-?[\d.]+)", 30)
    say("%s: %s" % (label, m.group(0) if m else "no PLAYERPOS line"))
    return list(m.groups()) if m else None


def crash_files():
    return set(glob.glob(CRASHES + "crash-*.log"))


def idle(label, t_load, t_arr, before, ctl=None):
    """Watch for WATCH s; True if the game survived. CRASHCTX every ~60 s (RV-82)."""
    t0, last = time.time(), 0.0
    while time.time() - t0 < WATCH:
        time.sleep(15)
        if "SkyrimSE.exe" in game.procs() and ctl and time.time() - last >= 60:
            last = time.time()
            try:
                ctx(ctl, "%s idle +%ds" % (label, time.time() - t0))
            except Exception as e:
                say("%s ctx failed: %s" % (label, e))
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
    save = "IEB_RV72_mid" if name in ("R1", "R2P") else "T0"
    ok = game.load(ctl, save, None)
    t_load = time.time()
    say("%s LOAD %s: %s" % (name, save, "OK" if ok else "FAILED"))
    if not ok:
        return None
    # RV-79-upd: R2/R3 stand where R1 stands (same cell/spot); every arm logs the player's cell and position
    pos = where(ctl, name + " start")
    if name == "R1" and pos:
        open(POSF, "w").write(" ".join(pos))
    elif name in ("R2", "R3"):
        if not os.path.exists(POSF):
            say("%s INCONCLUSIVE: no R1 position recorded (%s)" % (name, POSF))
            return None
        x, y, z = open(POSF).read().split()[2:5]
        ctl.ctl("PlayerPlace", [float(x), float(y), float(z)], sync=False)
        time.sleep(10)
        pos2 = where(ctl, name + " placed")
        r1 = open(POSF).read().split()
        if not pos2 or pos2[0] != r1[0] or abs(float(pos2[2]) - float(x)) > 300 or abs(float(pos2[3]) - float(y)) > 300:
            say("%s INCONCLUSIVE: player not at R1's spot (R1 %s, now %s)" % (name, r1, pos2))
            return None
    if name == "R1":
        h = ctx(ctl, "R1 start")
        if h is not None:
            open(HOURF, "w").write("%.4f" % h)
    else:
        if not os.path.exists(HOURF):
            say("%s INCONCLUSIVE: no R1 hour recorded (%s)" % (name, HOURF))
            return None
        want = float(open(HOURF).read())
        h = ctx(ctl, name + " hour set", "SetHour", [want, SAFFIR])
        if h is None or abs(h - want) > 0.25:
            say("%s INCONCLUSIVE: game hour %s, R1 had %.2f" % (name, h, want))
            return None
    text = pap.read()
    for l in text.splitlines():
        if "IEB_LOADKEYS" in l or "TASKTYPE_RESTORED" in l:
            say("  " + l.strip()[:300])
    if name == "R2P":
        # REVIEW_LOG RV-90 (1): same world and Saffir state as R1 (same save, same spot, same hour), errand ended at once
        t = game.Tail(game.LOGS["papyrus"])
        ctl.ctl("Cancel", [F1], sync=False)
        m = t.wait(r"(?i)\[IEB\] RELEASE_[A-Z]+ actor=Jenassa[^\n]*", 60)
        say("R2P errand cancelled at once: %s" % (m.group(0)[:120] if m else "no RELEASE line in 60 s"))
        if not m:
            say("R2P INCONCLUSIVE: the errand did not end")
            return None
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
    survived = idle(name, t_load, t_arr, before, ctl)
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
    if "R1" in arms:                      # a fresh R1 sets the spot and hour the controls must match
        for f in (POSF, HOURF):
            if os.path.exists(f):
                os.remove(f)
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
