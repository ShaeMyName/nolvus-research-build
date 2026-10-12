"""REVIEW_LOG RV-214 post-install gates (TEST only): launch (no voices), load T0, then
  FormModProbe 0x00013B98 -> last= must be IEB_SaffirPackageFix.esp (our record wins; its PKID list, read offline, has
  no AI Overhaul 0x001957) and FormModProbe 0xCF001957 (expect AI Overhaul.esp), plus the RV-207 index read of the
  ESL-flagged .esp ids given on the command line. Close. Prints GATE PASS/FAIL. FormIDs only."""
import os, re, sys, time
import game
from runner import Run

IDS = [0x00013B98, 0xCF001957] + [int(x, 16) for x in sys.argv[1:]]


def main():
    if not game.launch(print, voices=False):      # Run() connects to MCP on creation: launch first
        print("GATE FAIL: launch")
        return 1
    ok, r = False, None
    try:
        r = Run("SAFFIR_GATE")
        if not game.load(r, "T0", quick=True):
            print("GATE FAIL: load T0")
            return 1
        pap = game.LOGS["papyrus"]
        size = os.path.getsize(pap)
        for fid in IDS:
            r.ctl("FormModProbe", [fid], sync=False)
            time.sleep(1.5)
        time.sleep(6)
        with open(pap, encoding="utf-8", errors="replace") as f:
            f.seek(size)
            lines = [l.strip() for l in f if "FORMMOD" in l.upper()]
        for l in lines:
            print("  " + l)
        win = next((l for l in lines if re.search(r"FORMMOD (0x)?0*13B98\b", l, re.I)), "")
        aio = next((l for l in lines if re.search(r"FORMMOD (0x)?CF001957\b", l, re.I)), "")
        ok = "last=IEB_SaffirPackageFix.esp" in win
        print("GATE %s: Saffir NPC_ winner %s; 0xCF001957 %s" % ("PASS" if ok else "FAIL", win.split("last=")[-1] if win
              else "no line", ("mod=" + aio.split("mod=")[-1]) if aio else "no line"))
    finally:
        game.close(r, timeout=120, force=True)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
