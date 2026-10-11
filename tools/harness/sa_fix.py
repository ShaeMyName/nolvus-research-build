"""Sitting A builder fixtures over MCP (sitting_SA_sheet.md "Builder setup"). The game must be in T0 with the Timeline
Mismatch box cleared. Every write is read back; prints OK/FAIL per line.
  verify : cast positions (step 7 of the pre-handover list) + Papyrus array-error count since the launch
  keys   : IEB_SceneKey 71 (Numpad 7), LUC_PrayerKey 72 (Numpad 8), LUC_AmenKey 73 (Numpad 9), read back
  keys0  : all three back to 0, read back (close-out)"""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
import game
from runner import Run
from tests_misc import con, global_val, ref_pos

CAST = [("Jenassa", 0xE1BA9), ("Uthgerd", 0x91918), ("Brenuin", 0x2C90F), ("Anoriath", 0x1A680),
        ("Belethor", 0x1A672), ("Carlotta", 0x1A675), ("Braith", 0x1A66B), ("Ysolda", 0x1A69A)]
KEYS = [("IEB_SceneKey", 0x801, "SceneControls.esp", 71), ("LUC_PrayerKey", 0x800, "Lucienne.esl", 72),
        ("LUC_AmenKey", 0x801, "Lucienne.esl", 73)]


def main():
    r = Run("SA_FIX")
    ok = True
    what = sys.argv[1:2]
    if what == ["verify"]:
        for name, fid in CAST:
            p = ref_pos(r, fid)
            print("%-9s %08X %s" % (name, fid, p))
        pap = open(game.LOGS["papyrus"], encoding="utf-8", errors="replace").read()
        print("Papyrus array errors since launch:", len(re.findall(r"(?i)array index .* out of range|Cannot access an element of a None array", pap)))
    elif what in (["keys"], ["keys0"]):
        for name, local, plugin, val in KEYS:
            v = 0 if what == ["keys0"] else val
            con(r, "set %s to %d" % (name, v))
            back = global_val(r, local, plugin)
            good = back is not None and int(back) == v
            ok &= good
            print("%s = %d: %s (read back %s)" % (name, v, "OK" if good else "FAIL", back))
    else:
        sys.exit(__doc__)
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
