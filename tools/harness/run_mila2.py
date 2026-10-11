"""REVIEW_LOG RV-178: Mila (0x1A676) stalls at ~(22720, -5265, -2963) on her marketplace package.
(b) T0 + recycleactor on Mila (coc from the main menu does not start a game over MCP), clock 10:42,
    poll Mila's package and distance to the marketplace anchor REFR 0x2BE20 for ~2.3 game hours.
(a) adult on the same route: Carlotta (same house, same anchor) is set down at Mila's stall point and re-evaluates;
    poll her distance to the anchor for ~1 game hour.
Prints MILA2 / ADULT rows; closes the game at the end."""
import math, re, sys, time
sys.path.insert(0, r"C:\nolvus-research\build\tools\harness")
sys.path.insert(0, r"C:\nolvus-research\build\tools")
import game
from runner import Run
from tests_misc import ctl_line, s32, fid_any_rx, con

MARKET = (24385.0, -7088.0, -3401.0)
STUCK = (22720.0, -5265.0, -2963.0)


def row(r, f):
    m = ctl_line(r, "U3MarasProbe", [s32(f)], r"\[IEB-TEST\] U3MARASPROBE (%s) ([^\n]*)" % fid_any_rx(f), 15)
    q = ctl_line(r, "RefPos", [s32(f)], r"\[IEB-TEST\] REFPOS (%s) ([^\n]*)" % fid_any_rx(f), 15)
    pk = re.search(r"pkg=(\S+)", m.group(2)).group(1) if m else "?"
    pos = q.group(2) if q else ""
    xyz = re.search(r"x=(\S+) y=(\S+) z=(\S+)", pos)
    d = round(math.dist([float(v) for v in xyz.groups()], MARKET)) if xyz and "ws=None" not in pos else None
    return "pkg=%s cell=%s pos=%s dMarket=%s" % (pk, (re.search(r"cell=(\S+)", pos) or [0, "?"])[1],
                                                  "%s,%s,%s" % xyz.groups() if xyz else "?", d)


def hour(r):
    g = ctl_line(r, "GlobalProbe", [0x38, "Skyrim.esm"], r"\[IEB-TEST\] GLOBAL \S+ (?:v=(\S+)|none)", 15)
    return g.group(1)[:5] if g and g.group(1) else "?"


def main():
    if game.procs():
        sys.exit("FAIL game or MO2 running")
    if not game.memory_ready(print, why="Mila fresh-game check"):
        sys.exit("FAIL memory gate")
    if not game.launch(print, voices=False):
        sys.exit("FAIL launch")
    r = Run("MILA2")
    # RV-178 (b) as attempted: `coc` from the main menu over MCP never started a game (18:08, command logged, no load,
    # the MCP call hung). Fallback: T0, then recycleactor on Mila (her actor state rebuilt from the base record, the
    # closest to a fresh game that MCP can do; the navmesh is plugin data and the same either way).
    if not game.load(r, "T0", quick=True):
        print("FAIL T0 load")
        game.close(None, timeout=60, force=True)
        return
    time.sleep(20)
    con(r, "set gamehour to 10.7")
    con(r, "0001A676.recycleactor")
    time.sleep(10)
    print("MILA2 recycled; hour=%s | Mila %s" % (hour(r), row(r, 0x1A676)), flush=True)
    t0 = time.time()
    while time.time() - t0 < 420:
        print("MILA2 %3ds hour=%s | Mila %s | Carlotta %s" % (time.time() - t0, hour(r), row(r, 0x1A676), row(r, 0x1A675)), flush=True)
        time.sleep(30)
    # (a) the adult on the same route
    for ax, v in zip("xyz", STUCK):
        con(r, "0001A675.setpos %s %s" % (ax, v))
    con(r, "0001A675.evp")
    t0 = time.time()
    while time.time() - t0 < 200:
        print("ADULT %3ds hour=%s | Carlotta %s" % (time.time() - t0, hour(r), row(r, 0x1A675)), flush=True)
        time.sleep(25)
    game.close(None, timeout=60, force=True)
    print("MILA2 DONE")


if __name__ == "__main__":
    main()
