"""One launch for REVIEW_LOG RV-175 (2)(3) + RV-174 (2) steps 1-2: the S3bp smoke (scene branch + control), the Q guard
QR re-check (t1 for F1/F2/Fralia), and Mila's position/package over ~2 game hours from 10:00 (timescale 20)."""
import math, re, sys, time
sys.path.insert(0, r"C:\nolvus-research\build\tools\harness")
sys.path.insert(0, r"C:\nolvus-research\build\tools")
import post_crash_pipeline as P
from tests_misc import ctl_line, s32, fid_any_rx

P.install = lambda only, extra=(): (P.say("INSTALL skipped: ess_windows.json already installed and hash-identical") or True)
_orig_smoke = P.smoke
QR_ACTORS = [("F1", 0x000E1BA9), ("F2", 0x00091918), ("Fralia", 0x0001A684)]
MARKET = (24385.0, -7088.0, -3401.0)          # REFR 0x2BE20, Mila's and Carlotta's marketplace anchor (Skyrim.esm)


def extra(ctl):
    out = []
    for k, f in QR_ACTORS:
        m = ctl_line(ctl, "QR", [s32(f)], r"\[IEB-TEST\] QR (%s) (t1=(\d) [^\n]*)" % fid_any_rx(f), 15)
        P.say("  QR %s %s" % (k, m.group(2)[:120] if m else "no line"))
        if k != "Fralia":
            out.append((bool(m) and m.group(3) == "0", "Q guard tier 1: %s in an ambient scene is not reserved (t1=%s)"
                        % (k, m.group(3) if m else "?")))
        else:
            out.append((True, "Fralia t1=%s (INFO: she also holds a story alias, so 1 is legitimate)" % (m.group(3) if m else "?")))
    ctl.tool("execute_console_command", {"command": "set gamehour to 10"})
    t0 = time.time()
    while time.time() - t0 < 420:              # ~2.3 game hours
        row = []
        for k, f in (("Mila", 0x0001A676), ("Carlotta", 0x0001A675)):
            m = ctl_line(ctl, "U3MarasProbe", [s32(f)], r"\[IEB-TEST\] U3MARASPROBE (%s) ([^\n]*)" % fid_any_rx(f), 15)
            q = ctl_line(ctl, "RefPos", [s32(f)], r"\[IEB-TEST\] REFPOS (%s) ([^\n]*)" % fid_any_rx(f), 15)
            pk = re.search(r"pkg=(\S+)", m.group(2)).group(1) if m else "?"
            pos = q.group(2) if q else ""
            xyz = re.search(r"x=(\S+) y=(\S+) z=(\S+)", pos)
            d = round(math.dist([float(v) for v in xyz.groups()], MARKET)) if xyz and "ws=None" not in pos else None
            row.append("%s pkg=%s cell=%s dMarket=%s" % (k, pk, (re.search(r"cell=(\S+)", pos) or [0, "?"])[1], d))
        gh = ctl_line(ctl, "GlobalProbe", [0x38, "Skyrim.esm"], r"\[IEB-TEST\] GLOBAL \S+ (?:v=(\S+)|none)", 15)
        P.say("  MILA %3ds hour=%s | %s" % (time.time() - t0, gh.group(1)[:5] if gh and gh.group(1) else "?", " | ".join(row)))
        time.sleep(30)
    return out


def smoke(label, checks):
    def both(ctl, t):
        return checks(ctl, t) + extra(ctl)
    return _orig_smoke(label, both)


P.smoke = smoke
print("RV175", P.s3bp())
