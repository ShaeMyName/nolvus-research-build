"""REVIEW_LOG RV-180 (1) / RV-181: find the exact blocker at the Whiterun trap point (22720, -5265, -2963).
T0, clock 11:30: Carlotta (0x1A675) runs her marketplace package (anchor REFR 0x2BE20 at the stall).
Round = set Carlotta on the trap, evp, wait 60 s, freed if she moved > 400 u.
1. control; 2. ISOLATION: disable one candidate, round, re-enable it (RV-181); 3. if none frees her alone: CUMULATIVE
(all Dawn of Skyrim refs, + Spaghetti's pen, + the Whiterun Has Walls pieces); 4. confirm the winner on a second
trapped actor (Mila, 0x1A676). Refs addressed by plugin + local ID (TestCtl RefFileProbe/RefFileEnable). Never saved."""
import math, re, sys, time
sys.path.insert(0, r"C:\nolvus-research\build\tools\harness")
sys.path.insert(0, r"C:\nolvus-research\build\tools")
import game
from runner import Run
from tests_misc import ctl_line, s32, fid_any_rx, con

TRAP = (22720.0, -5265.0, -2963.0)
DOS, SPA, WHW, SKY = "Dawn of Skyrim.esp", "Spaghetti's Cities - AIO.esp", "Whiterun Has Walls.esp", "Skyrim.esm"
DOS_REFS = [("fence WRFenceStr01", DOS, 0x0F1E84), ("hay HayMoundL01", DOS, 0x0F1E82), ("hay HayMound02", DOS, 0x0F1E83),
            ("nest", DOS, 0x0F1E87), ("nest", DOS, 0x0F1E86), ("nest", DOS, 0x0F1E85),
            ("chicken", DOS, 0x0F1E88), ("chicken", DOS, 0x0F1E89)]
SPA_REFS = [("Spaghetti pen %03X" % i, SPA, i) for i in range(0x840, 0x848)]
WALL_REFS = [("wall piece (WHW-moved) %06X" % i, SKY, i) for i in (0x089F49, 0x089F4A, 0x089F4B)]


def reff(r, plugin, local, fn="RefFileProbe", extra=()):
    m = ctl_line(r, fn, [int(local), plugin] + list(extra), r"\[IEB-TEST\] REFF [^\n]*", 15)
    return m.group(0) if m else "no REFF line"


def apos(r, f):
    q = ctl_line(r, "RefPos", [s32(f)], r"\[IEB-TEST\] REFPOS (%s) ([^\n]*)" % fid_any_rx(f), 15)
    m = re.search(r"x=(\S+) y=(\S+) z=(\S+)", q.group(2)) if q else None
    return tuple(float(v) for v in m.groups()) if m else None


def round_(r, label, who=0x1A675):
    for ax, v in zip("xyz", TRAP):
        con(r, "%08X.setpos %s %s" % (who, ax, v))
    con(r, "%08X.evp" % who)
    time.sleep(60)
    p = apos(r, who)
    moved = round(math.dist(p, TRAP)) if p else None
    freed = moved is not None and moved > 400
    print("ROUND %-34s actor %08X moved %s u -> %s" % (label, who, moved, "FREED" if freed else "stuck"), flush=True)
    return freed


def setall(r, refs, enable):
    for label, pl, loc in refs:
        print("  %s %s: %s" % ("ENABLE" if enable else "DISABLE", label, reff(r, pl, loc, "RefFileEnable", [enable])), flush=True)


def main():
    if game.procs():
        sys.exit("FAIL game or MO2 running")
    if not game.launch(print, voices=False):
        sys.exit("FAIL launch")
    r = Run("MILA_BLOCK2")
    if not game.load(r, "T0", quick=True):
        print("FAIL T0 load")
        game.close(None, timeout=60, force=True)
        return
    time.sleep(20)
    con(r, "set gamehour to 11.5")
    time.sleep(5)
    for label, pl, loc in DOS_REFS + SPA_REFS[:1] + WALL_REFS:
        print("PROBE %s: %s" % (label, reff(r, pl, loc)), flush=True)
    winner = None
    if round_(r, "control (nothing disabled)"):
        print("RESULT control already free: the trap does not reproduce", flush=True)
    else:
        for item in DOS_REFS + WALL_REFS:                 # isolation (RV-181)
            setall(r, [item], False)
            if round_(r, "only " + item[0]):
                winner = [item]
            setall(r, [item], True)
            if winner:
                break
        if not winner:                                    # cumulative
            for label, group in (("all Dawn of Skyrim", DOS_REFS), ("+ Spaghetti pen", SPA_REFS), ("+ Whiterun walls", WALL_REFS)):
                setall(r, group, False)
                if round_(r, "cumulative " + label):
                    winner = group
                    break
        print("RESULT winner=%s" % ([w[0] for w in winner] if winner else None), flush=True)
        if winner:                                        # second trapped actor (RV-181)
            print("RESULT second actor (Mila) with the winner disabled: %s" %
                  ("FREED" if round_(r, "Mila, winner disabled", who=0x1A676) else "stuck"), flush=True)
    game.close(None, timeout=60, force=True)
    print("MILA_BLOCK2 DONE", flush=True)


if __name__ == "__main__":
    main()
