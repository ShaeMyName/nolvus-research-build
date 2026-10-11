"""REVIEW_LOG RV-70 follow-ups (harness ON, unattended). Writes nothing but throwaway logs.
 1. Fresh T0: SlotsProbe right after the load + every IEB_FASTTICK reason line since the load (is T0 clean? (c))
 2. Load IEB_R29_c3 (mid-errand save): HeldProbe right after the load and after IE's arrival; then the first RV-70 test,
    a dismissal in the waiting phase after a load (NFFDismiss) -> expect NFF_DISMISSED and a RELEASE line.
 3. Fresh T0, no load in between: errand to Dragonsreach, HeldProbe after arrival (load bug vs general (a)).
Usage: rv70_probe.py [steps, e.g. 2 or 1,3]   (the game must be closed)"""
import os, re, sys, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import block, game
from runner import Run

OUT = "C:/nolvus-research/test_runs/"
F1 = 0x000E1BA9
LOG = []


def say(m):
    line = "%s %s" % (time.strftime("%H:%M:%S"), m)
    print(line, flush=True)
    LOG.append(line)


def fresh(save):
    if game.procs():
        game.close(None, timeout=60, force=True)
    for _ in range(30):
        if not game.procs():
            break
        time.sleep(2)
    if not game.harness_mode() and not game.set_harness_mode(True, say):
        say("ABORT: harness mode could not be set on (Harness.yaml read-back)")
        sys.exit(1)
    if not game.launch(say, voices=False):
        say("ABORT: launch failed")
        sys.exit(1)
    ctl = Run("RV70_CONTROL")
    pap = game.Tail(game.LOGS["papyrus"])
    ok = game.load(ctl, save, None)
    say("LOAD %s: %s" % (save, "OK" if ok else "FAILED"))
    return ctl, pap, ok


def probe(ctl, fn, args, pat, label, timeout=20):
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl(fn, args, sync=False)
    m = t.wait(r"\[IEB-TEST\] %s[^\r\n]*" % pat, timeout)
    say("%s: %s" % (label, m.group(0) if m else "no %s line" % pat))
    return m.group(0) if m else ""


def fast_lines(text):
    return [l.strip()[:200] for l in text.splitlines() if "IEB_FASTTICK" in l]


def wait_arrival(t, timeout=600):
    m = t.wait(r"IntelEngine: Jenassa arrived at[^\r\n]*", timeout)
    say("arrival: %s" % (m.group(0) if m else "none within %d s" % timeout))
    return bool(m)


def main(only=None):
    game.set_archive("RV70_probe_%s" % time.strftime("%Y%m%d-%H%M%S"))
    steps = sys.argv[1].split(",") if len(sys.argv) > 1 else ["1", "2", "3"]
    # 1. T0 clean?
    ctl, pap, ok = fresh("T0") if "1" in steps else (None, None, False)
    if ok:
        probe(ctl, "SlotsProbe", [], "SLOTSPROBE", "T0 slots after load")
        for l in fast_lines(pap.read()):
            say("T0 " + l)
    # 2. mid-errand save: state after load, after arrival; dismissal in the waiting phase
    ctl, pap, ok = fresh("IEB_R29_c3") if "2" in steps else (None, None, False)
    if ok:
        probe(ctl, "HeldProbe", [F1], "HELDPROBE", "c3 right after load")
        text = pap.read()
        for l in fast_lines(text):
            say("c3 " + l)
        t = game.Tail(game.LOGS["papyrus"])
        if not block.ie_test_settings(ctl):      # RV-123 (3): SkipProbe read-back
            say("c3 IE test settings NOT VERIFIED: the c3 results below are INCONCLUSIVE")
        # 23:03 run: she had already arrived during the settle (22:49), so waiting for a new arrival line timed out
        if "Jenassa arrived at" in text + pap.read() or wait_arrival(t):
            time.sleep(5)
            probe(ctl, "HeldProbe", [F1], "HELDPROBE", "c3 after arrival")
            t2 = game.Tail(game.LOGS["papyrus"])
            ctl.ctl("NFFDismiss", [F1], sync=False)
            m = t2.wait(r"\[IEB\] NFF_DISMISSED actor=Jenassa[^\r\n]*", 30)
            say("waiting-phase dismissal after load: %s" % (m.group(0) if m else "NO NFF_DISMISSED in 30 s"))
            r = t2.wait(r"\[IEB\] (RELEASE\w*|DEFER\w*|CMD_FOLLOW)[^\r\n]*Jenassa[^\r\n]*", 90)
            say("  then: %s" % (r.group(0) if r else "no RELEASE/DEFER/CMD_FOLLOW line in 90 s"))
            probe(ctl, "HeldProbe", [F1], "HELDPROBE", "c3 after dismissal")
    # 3. same errand without a load in between
    ctl, pap, ok = fresh("T0") if "3" in steps else (None, None, False)
    if ok:
        if not block.ie_test_settings(ctl):      # RV-123 (3): SkipProbe read-back
            say("no-load IE test settings NOT VERIFIED: the no-load results below are INCONCLUSIVE")
        t = game.Tail(game.LOGS["papyrus"])
        ctl.ctl("StartTask", [F1, "GoToLocation", "Dragonsreach", "1", "1"])
        take = t.wait(r"(?i)\[IEB\] TAKE actor=Jenassa", 30)
        say("no-load errand: %s" % ("TAKE seen" if take else "NO TAKE (case invalid)"))
        if take:
            probe(ctl, "HeldProbe", [F1], "HELDPROBE", "no-load while travelling")
            if wait_arrival(t):
                time.sleep(5)
                probe(ctl, "HeldProbe", [F1], "HELDPROBE", "no-load after arrival")
        text = pap.read()
        for l in fast_lines(text):
            say("no-load " + l)
        arr = [l.strip()[:160] for l in text.splitlines() if "Jenassa arrived at" in l]
        say("no-load arrival lines (RV-70 (b) duplicates): %d" % len(arr))
        for l in arr:
            say("  " + l)
    game.archive_logs("end")
    game.close(None, timeout=60, force=True)
    open(OUT + "RV70_probe_%s.txt" % time.strftime("%Y%m%d-%H%M%S"), "w", encoding="utf-8").write("\n".join(LOG) + "\n")
    say("RV70 DONE")


if __name__ == "__main__":
    main()
