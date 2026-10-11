"""EXT-DEST live resolver probe (post_u1_build_plan EXT-DEST (1); REVIEW_LOG R39): find an EXTERIOR errand destination in
Whiterun's own worldspace, so the rejoin / speaking tests (B-1 REJOIN_WAIT branch, B-3, B-23..B-28, TM-8) can be re-based
on an end spot where F1 stays loaded. One launch, T0, harness on.

Per candidate phrase: reload T0, StartTask(F1, GoToLocation, phrase, speed 1, wait 1), read IntelEngine.log for the
resolver's strategy line (FindTravelTarget: 'Strategy N SUCCESS: ...' -> which strategy and the marker/door position),
wait for 'arrived at' (<= 300 s), then Probe F1: cell, loaded, distance to the player, and whether she teleported
inside (cell is an interior: the watcher's cell field). Cancel the task after each phrase.
Output: test_runs/EXT_DEST_<stamp>.txt, one row per phrase: strategy | arrived | arrival cell | interior? | loaded |
dPlayer. Counts and FormIDs only. Run only with the game closed (it launches it); never during another arm.
Usage: ext_dest_probe.py [phrase;phrase;...]"""
import os, re, sys, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import block, game
from runner import Run

OUT = "C:/nolvus-research/test_runs/"
IELOG = "C:/Users/sharp/Documents/My Games/Skyrim Special Edition/SKSE/IntelEngine.log"
F1 = 0x000E1BA9
WHITERUN_WS = "0x1A26F"
# Candidate BGSLocation names inside the city (world markers outdoors, INFERRED) + controls.
PHRASES = ["Plains District", "Wind District", "Cloud District", "Whiterun Plains District", "Gildergreen",
           "Whiterun Stables", "Whiterun", "the Bannered Mare"]
LOG = []


def say(m):
    line = "%s %s" % (time.strftime("%H:%M:%S"), m)
    print(line, flush=True)
    LOG.append(line)


def probe(ctl, fid):
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl("Probe", [fid], sync=False)
    m = t.wait(r"\[IEB-TEST\] probe [^\n]*", 20)
    if not m:
        return {}
    d = dict(re.findall(r"(\w+)=(\S+)", m.group(0)))
    return d


def one(ctl, phrase):
    if not game.load(ctl, "T0", None):
        return dict(phrase=phrase, err="load failed")
    if not block.ie_test_settings(ctl):          # RV-123 (3): SkipProbe read-back
        return dict(phrase=phrase, err="IE test settings not verified")
    ie = game.Tail(IELOG)
    pap = game.Tail(game.LOGS["papyrus"])
    ctl.ctl("StartTask", [F1, "GoToLocation", phrase, "1", "1"])
    take = pap.wait(r"(?i)\[IEB\] (TAKE|REFUSE|NOT_FOLLOWER)[^\n]*Jenassa[^\n]*", 30)
    strat = ie.wait(r"Strategy [0-9a-z]+ SUCCESS: [^\n]*|resolution failed[^\n]*|Not found[^\n]*", 30)
    arr = pap.wait(r"IntelEngine: Jenassa arrived at[^\n]*", 300)
    time.sleep(5)
    p = probe(ctl, F1)
    row = dict(phrase=phrase, decision=(take.group(1) if take else "none"),
               strategy=(re.sub(r"\(.*", "", strat.group(0)).strip()[:60] if strat else "no strategy line"),
               arrived=bool(arr), cell=p.get("cell", "?"), loaded=p.get("loaded", "?"), dPlayer=p.get("dPlayer", "?"),
               ws=p.get("ws", "?"))
    try:
        ctl.ctl("Cancel", [F1])
    except Exception:
        pass
    return row


def main():
    if game.procs():
        sys.exit("ABORT: game or MO2 running")
    phrases = sys.argv[1].split(";") if len(sys.argv) > 1 else PHRASES
    run_id = "EXT_DEST_%s" % time.strftime("%Y%m%d-%H%M%S")
    game.set_archive(run_id)
    if not game.harness_mode() and not game.set_harness_mode(True, say):
        sys.exit("ABORT: harness mode could not be set on (Harness.yaml read-back)")
    if not game.launch(say, voices=False):
        sys.exit("ABORT: launch failed")
    ctl = Run("EXTDEST")
    rows = []
    for ph in phrases:
        try:
            row = one(ctl, ph)
        except Exception as e:
            row = dict(phrase=ph, err=repr(e))
        say("ROW %s" % row)
        rows.append(row)
        if "SkyrimSE.exe" not in game.procs():
            say("GAME GONE: stopping")
            break
    game.archive_logs("end")
    game.close(None, timeout=60, force=True)
    open(OUT + run_id + ".txt", "w", encoding="utf-8").write("\n".join(LOG) + "\n")
    say("EXT DEST DONE")


if __name__ == "__main__":
    main()
