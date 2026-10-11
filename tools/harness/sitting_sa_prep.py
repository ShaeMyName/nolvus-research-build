"""Sitting A config (REVIEW_LOG RV-148/RV-152/RV-157). Game and MO2 must be closed.
  prep    : harness mode OFF, GameMaster OFF, SkyrimNet Hotkey.yaml toggleWhisperMode -1 -> 113 (F2; Shae approved the TEST
            write, RV-152 (1)): backup first, byte-safe (CRLF kept), read back.
  restore : toggleWhisperMode back to the backed-up value (read back), GameMaster ON (read back). Harness mode is left as the
            next block sets it.
Each step prints OK/FAIL; exit 1 on any FAIL."""
import os, re, shutil, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
import game

HOTKEY = ("C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/SkyrimNet Config - Test/SKSE/Plugins/SkyrimNet/config/"
          "Hotkey.yaml")
BACKUP = "C:/nolvus-research/backups/Hotkey.yaml.pre_sittingA_%s" % time.strftime("%Y%m%d-%H%M%S")
KEY_RX = re.compile(rb"(?m)^(toggleWhisperMode:[ \t]*)(-?\d+)(\r?)$")


def whisper():
    m = KEY_RX.findall(open(HOTKEY, "rb").read())
    return int(m[0][1]) if len(m) == 1 else None


def set_whisper(v):
    b = open(HOTKEY, "rb").read()
    if len(KEY_RX.findall(b)) != 1:
        return False
    b2 = KEY_RX.sub(lambda m: m.group(1) + str(int(v)).encode() + m.group(3), b)
    with open(HOTKEY, "wb") as f:
        f.write(b2)
    return whisper() == int(v)


def main():
    if game.procs():
        sys.exit("FAIL game or MO2 running: %s" % sorted(game.procs()))
    ok = True
    if sys.argv[1:] == ["prep"]:
        ok &= bool(game.set_harness_mode(False, print)) and not game.harness_mode()
        print("harness mode OFF:", "OK" if not game.harness_mode() else "FAIL")
        ok &= bool(game.set_gamemaster(False, print)) and not game.gamemaster()
        print("GameMaster OFF:", "OK" if not game.gamemaster() else "FAIL")
        cur = whisper()
        shutil.copy2(HOTKEY, BACKUP)
        print("Hotkey.yaml backup:", BACKUP, "toggleWhisperMode was", cur)
        w = set_whisper(113)
        ok &= w
        print("toggleWhisperMode 113 (F2):", "OK read back %s" % whisper() if w else "FAIL")
    elif sys.argv[1:2] == ["restore"]:
        prev = int(sys.argv[2]) if len(sys.argv) > 2 else -1
        w = set_whisper(prev)
        ok &= w
        print("toggleWhisperMode restored to %d:" % prev, "OK" if w else "FAIL")
        ok &= bool(game.set_gamemaster(True, print)) and bool(game.gamemaster())
        print("GameMaster ON:", "OK" if game.gamemaster() else "FAIL")
    else:
        sys.exit(__doc__)
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
