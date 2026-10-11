"""REVIEW_LOG RV-69-dec / RV-77: live test of the Relationships head start for the priestess at Azura's shrine
(ref 0x00028AD1) on T0 (throwaway; harness ON, one launch). Graded on the numbers TestCtl.HeadStartOp logs (points,
bank, latch); snrom.log IEB_HEADSTART lines are copied at the end as supporting evidence (it can lag by minutes).
Routes: by hand, M4' courtship, BeginSpark (AutoEnroll is code-read only: it needs her as a follower; every route
calls EnrollNow, VERIFIED RELB:868/958 + patch F). IsChild is not live-testable (the FormID check rejects first).
Usage: hs_live.py (game and MO2 closed). Prints numbers only."""
import os, re, sys, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import game
from runner import Run

OUT = "C:/nolvus-research/test_runs/"
SNROM = ("C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/SkyrimNet Test - Output/SKSE/Plugins/"
         "SkyrimNet Relationships/logs/snrom.log")
P, U = 0x00028AD1, 0x00091918          # the priestess; Uthgerd (adult control)
LOG, VERDICT = [], []


def say(m):
    line = "%s %s" % (time.strftime("%H:%M:%S"), m)
    print(line, flush=True)
    LOG.append(line)


def verdict(name, ok, detail=""):
    VERDICT.append("%s %s %s" % (name, "PASS" if ok else ("INCONCLUSIVE" if ok is None else "FAIL"), detail))
    say("VERDICT " + VERDICT[-1])


def op(ctl, fid, name, n=0):
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl("HeadStartOp", [fid, name, n], sync=False)
    m = t.wait(r"(?i)\[IEB-TEST\] HSOP [^\r\n]*", 60)
    line = m.group(0) if m else ""
    say("%s %s %d: %s" % (hex(fid), name, n, line[line.find("HSOP"):] if line else "no HSOP line"))
    d = dict(re.findall(r"(\w+)=(-?\d+)", line))
    return {k: int(v) for k, v in d.items()} if line else None


SETUP_WANT = {"luc": lambda r, n: r["luc"] == n, "setpts": lambda r, n: r["pts"] == n,
              "unenroll": lambda r, n: r["enrolled"] == 0,
              "reset": lambda r, n: r["enrolled"] == 0 and r["bank"] == 0 and r["latch"] == 0}
#   reset's pts is not asserted: PointsOf reads Romantasy's number until the import (SNRom_Bridge.psc:1314-1326)


def setup(ctl, fid, name, n=0):
    """RV-123 (3): a setup op, read back from its own HSOP line before a verdict depends on it."""
    r = op(ctl, fid, name, n)
    if not (r and SETUP_WANT[name](r, n)):
        verdict("setup_%s_%s_%d" % (hex(fid), name, n), None, "read-back %s" % r)
    return r


def main():
    if game.procs():
        sys.exit("ABORT: game or MO2 running")
    run_id = "HS_live_%s" % time.strftime("%Y%m%d-%H%M%S")
    game.set_archive(run_id)
    snrom0 = os.path.getsize(SNROM) if os.path.exists(SNROM) else 0
    try:
        if not game.harness_mode() and not game.set_harness_mode(True, say):
            raise RuntimeError("harness mode could not be set on (Harness.yaml read-back)")
        if not game.launch(say, voices=False):
            raise RuntimeError("launch refused or failed")
        ctl = Run("HS_CONTROL")
        if not game.load(ctl, "T0", None):
            raise RuntimeError("T0 load failed")
        setup(ctl, P, "luc", 1)
        setup(ctl, P, "reset")
        # A by hand + B
        r = op(ctl, P, "byhand")
        verdict("A_byhand_floor", r and r["enrolled"] == 1 and r["pts"] == 999 and r["latch"] == 1, str(r))
        r0 = r["pts"] if r else 0
        r = op(ctl, P, "moment", 20)
        verdict("B_positive_x2", r and r["pts"] - r0 == 40, "delta %s" % (r and r["pts"] - r0))
        r0 = r["pts"] if r else 0
        r = op(ctl, P, "moment", -20)
        verdict("B_negative_x1", r and r["pts"] - r0 == -20, "delta %s" % (r and r["pts"] - r0))
        setup(ctl, P, "setpts", 1970)
        r = op(ctl, P, "moment", 20)
        verdict("B_truncation_1970_plus_20", r and r["pts"] == 1999 and r["bank"] == 0, str(r))
        # latch: unenrol (latch kept), drop to 100, enrol again -> no second floor
        setup(ctl, P, "unenroll")
        setup(ctl, P, "setpts", 100)
        r = op(ctl, P, "byhand")
        verdict("A_latch_reenrol", r and r["enrolled"] == 1 and r["pts"] == 100 and r["latch"] == 1, str(r))
        # M4' courtship route
        setup(ctl, P, "reset")
        r = op(ctl, P, "courtship")
        verdict("A_courtship_floor", r and r["enrolled"] == 1 and r["pts"] == 999 and r["latch"] == 1, str(r))
        # BeginSpark route: +25 (+25 bonus) then the floor -> 999, never 1049
        setup(ctl, P, "reset")
        r = op(ctl, P, "beginspark")
        if r and r["enrolled"] == 0:
            verdict("A_beginspark_floor", None, "BeginSpark declined (CanBegin gate): %s" % r)
        else:
            verdict("A_beginspark_floor", r and r["pts"] == 999 and r["latch"] == 1, str(r))
        # LUC_Active off: no head start
        setup(ctl, P, "luc", 0)
        setup(ctl, P, "reset")
        r = op(ctl, P, "byhand")
        ok = r and r["enrolled"] == 1 and r["pts"] < 999 and r["latch"] == 0
        r0 = r["pts"] if r else 0
        r = op(ctl, P, "moment", 20)
        verdict("luc_off_no_headstart", ok and r and r["pts"] - r0 == 20, "after enrol pts %s; moment delta %s"
                % (r0, r and r["pts"] - r0))
        # adult control actor with LUC on: nothing
        setup(ctl, U, "luc", 1)
        setup(ctl, U, "reset")
        r = op(ctl, U, "byhand")
        ok = r and r["enrolled"] == 1 and r["pts"] < 999 and r["latch"] == 0
        r0 = r["pts"] if r else 0
        r = op(ctl, U, "moment", 20)
        verdict("control_actor_unaffected", ok and r and r["pts"] - r0 == 20, "after enrol pts %s; moment delta %s"
                % (r0, r and r["pts"] - r0))
        game.archive_logs("end")
    except Exception as e:
        say("ERROR %s" % e)
        verdict("run", False, str(e))
    finally:
        game.close(None, timeout=60, force=True)
    try:
        with open(SNROM, encoding="utf-8", errors="replace") as f:
            f.seek(snrom0)
            hs = [l.strip() for l in f if "IEB_HEADSTART" in l]
        say("snrom.log IEB_HEADSTART lines: %d" % len(hs))
        for l in hs:
            say("  " + re.sub(r"IEB_HEADSTART (\w+) .*? (delta|award)=", r"IEB_HEADSTART \1 \2=", l))
    except OSError as e:
        say("snrom.log not read: %s" % e)
    lf = game.log_findings()
    say("log findings: %s" % lf)
    say("SUMMARY " + " | ".join(VERDICT))
    open(OUT + run_id + ".txt", "w", encoding="utf-8").write("\n".join(LOG) + "\n")
    say("HS DONE")


if __name__ == "__main__":
    main()
