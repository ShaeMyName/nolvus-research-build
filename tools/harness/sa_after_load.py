"""Sitting A: everything a fresh load resets, set again and read back (run after Shae clears the Timeline box).
Keys 71/72/73, SeverActions EnableEnterpriseDebug, IntelEngine skip-follower off (Confirm* untouched for TM-9), clock 10:00,
Jenassa straight ahead. Prints OK/FAIL per line."""
import os, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
import game
from runner import Run
from block import IE_ACTIONS
from tests_misc import con, global_val, qprop, ctl_line

KEYS = [("IEB_SceneKey", 0x801, "SceneControls.esp", 71), ("LUC_PrayerKey", 0x800, "Lucienne.esl", 72),
        ("LUC_AmenKey", 0x801, "Lucienne.esl", 73)]


def main():
    r = Run("SA_AFTER_LOAD")
    for name, local, plugin, val in KEYS:
        con(r, "set %s to %d" % (name, val))
        print("%s %d:" % (name, val), "OK" if global_val(r, local, plugin) == val else "FAIL")
    con(r, "setpqv SeverActions EnableEnterpriseDebug 1")
    print("EnableEnterpriseDebug:", qprop(r, "SeverActions", "SeverActions_MCM", "EnableEnterpriseDebug"))
    for a in IE_ACTIONS:
        r.tool("execute_quest_function", {"quest_editor_id": "IntelEngine", "script_name": "IntelEngine_Core",
               "function_name": "OnDashboardSetting", "arguments": ["IntelEngine_DashboardSetting", "skipFollower" + a, 0.0, None]})
    for _ in range(8):
        t = game.Tail(game.LOGS["papyrus"])
        r.ctl("SkipProbe")
        m = t.wait(r"\[IEB-TEST\] SkipProbe (.*)", timeout=20)
        if m and "=1" not in m.group(1).split(" saved=")[0]:
            print("skip-follower off: OK", m.group(1))
            break
        time.sleep(6)
    else:
        print("skip-follower off: FAIL")
    con(r, "set gamehour to 10")
    print("GameHour:", global_val(r, 0x38, "Skyrim.esm"))
    m = ctl_line(r, "FacePlace", [0xE1BA9, 200.0], r"\[IEB-TEST\] (FF_FACE .*)", 15)
    print("Jenassa:", m.group(1) if m else "FAIL")


if __name__ == "__main__":
    main()
