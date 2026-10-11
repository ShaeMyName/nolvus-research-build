"""S3bp diagnosis (2026-10-11, REVIEW_LOG RV-137 / RV-137-diag). F1 (Jenassa) logged ESS_SKIP why=story_alias and
QR showed her in a scene (scene=1, t1=1, busy=1) for 6 min after a T0 load. v2: polls F1, F2 (Uthgerd, the other NFF
follower) and one non-follower (Fralia) with TestCtl.QR every 30 s for 6 min, and logs TestCtl.SceneProbe for each at
the start and the end: scene FormID, owning quest FormID + plugin, story-list membership, open objective, plus every
alias held. Numbers and plugin names only; no quest or scene names are read. Verdict (RV-137-diag (3)): a quest owned by
our plugins / SkyrimNet / IE / SA = our bug (blocks the A path); vanilla ambient = the scene branch needs a filter."""
import re, sys, time
import post_crash_pipeline as P
from tests_misc import ctl_line, s32, fid_any_rx

ACTORS = [("F1", 0x000E1BA9), ("F2", 0x00091918), ("Fralia", 0x0001A684),
          ("Mila", 0x0001A676), ("Carlotta", 0x0001A675)]   # RV-171 (3): Mila leaves her mother since 10-11
MODE = "v2" if "--v1" not in sys.argv else "v1"


def scenep(ctl, tag, fid):
    t = P.game.Tail(P.game.LOGS["papyrus"])
    ctl.ctl("SceneProbe", [s32(fid)], sync=False)
    end = t.wait(r"\[IEB-TEST\] SCENEP_END (%s) aliases=\d+" % fid_any_rx(fid), 20)
    txt = t.read() if end else ""
    lines = re.findall(r"\[IEB-TEST\] (SCENEP(?:_ALIAS)? [^\n]*)", (end.string if end else "") + txt)
    for ln in lines[:12]:
        P.say("  DIAG %s %s" % (tag, ln[:200]))
    if not end:
        P.say("  DIAG %s no SCENEP_END (SceneProbe installed?)" % tag)


def pkgp(ctl, tag):
    """RV-171 (3): Mila's and Carlotta's running package (U3MarasProbe pkg=), position and package-override count."""
    for k, f in (("Mila", 0x0001A676), ("Carlotta", 0x0001A675)):
        m = ctl_line(ctl, "U3MarasProbe", [s32(f)], r"\[IEB-TEST\] U3MARASPROBE (%s) ([^\n]*)" % fid_any_rx(f), 15)
        pk = re.search(r"pkg=(\S+)", m.group(2)).group(1) if m else "no line"
        q = ctl_line(ctl, "RefPos", [s32(f)], r"\[IEB-TEST\] REFPOS (%s) ([^\n]*)" % fid_any_rx(f), 15)
        P.say("  DIAG %s %s pkg=%s pos=%s" % (tag, k, pk, q.group(2) if q else "none"))


def chk(ctl, t):
    rows = {k: [] for k, _ in ACTORS}
    ctl.tool("execute_console_command", {"command": "set gamehour to 10"})   # RV-171 (3a): daytime, mother and daughter together
    time.sleep(20)
    pkgp(ctl, "pkg@start")
    for k, f in ACTORS:
        scenep(ctl, k + "@start", f)
    t0 = time.time()
    while time.time() - t0 < 360:
        for k, f in ACTORS:
            m = ctl_line(ctl, "QR", [s32(f)], r"\[IEB-TEST\] QR (%s) (t1=\S+ t2=\S+ busy=\S+ scene=\S+ tm=\S+)" % fid_any_rx(f), 15)
            rows[k].append(m.group(2) if m else "no QR line")
        P.say("  DIAG %3ds %s" % (time.time() - t0, " | ".join("%s %s" % (k, rows[k][-1]) for k, _ in ACTORS)))
        time.sleep(30)
    pkgp(ctl, "pkg@end")
    for k, f in ACTORS:
        scenep(ctl, k + "@end", f)
    text = t.read()
    for ln in re.findall(r"\[IEB\] ESS_\w+ actor=[^\n]*", text)[:10]:
        P.say("  DIAG ess-line %s" % ln[:160])
    return [(True, "%s: in a scene on every poll: %s" % (k, all("scene=1" in r for r in rows[k]))) for k, _ in ACTORS]


if __name__ == "__main__":
    P.smoke("DIAG_S3bp_" + MODE, chk)
