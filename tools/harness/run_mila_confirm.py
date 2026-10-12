"""REVIEW_LOG RV-181 confirm: the blocker run's second-actor round ran with the fence RE-ENABLED (script bug: the winner
was re-enabled before the confirm), so it was a Mila control (stuck), not a confirmation. Here, one launch:
fence disabled -> Mila round (expect FREED) -> Carlotta round (expect FREED, repeat) -> fence enabled -> Carlotta round
(expect stuck). Never saved."""
import sys, time
sys.path.insert(0, r"C:\nolvus-research\build\tools\harness")
sys.path.insert(0, r"C:\nolvus-research\build\tools")
import game
from runner import Run
from tests_misc import con
import run_mila_blocker as B

FENCE = ("fence WRFenceStr01", B.DOS, 0x0F1E84)


def main():
    if game.procs():
        sys.exit("FAIL game or MO2 running")
    if not game.launch(print, voices=False):
        sys.exit("FAIL launch")
    r = Run("MILA_CONFIRM")
    if not game.load(r, "T0", quick=True):
        print("FAIL T0 load")
        game.close(None, timeout=60, force=True)
        return
    time.sleep(20)
    con(r, "set gamehour to 11.5")
    time.sleep(5)
    B.setall(r, [FENCE], False)
    a = B.round_(r, "fence off: Mila", who=0x1A676)
    b = B.round_(r, "fence off: Carlotta (repeat)")
    B.setall(r, [FENCE], True)
    c = B.round_(r, "fence back on: Carlotta")
    print("CONFIRM mila_freed=%s carlotta_freed=%s carlotta_stuck_with_fence=%s -> %s" %
          (a, b, not c, "CONFIRMED" if a and b and not c else "NOT CONFIRMED"), flush=True)
    game.close(None, timeout=60, force=True)
    print("MILA_CONFIRM DONE", flush=True)


if __name__ == "__main__":
    main()
