"""B-31 crash repro arms (REVIEW_LOG RV-205, refocused after crash #10 2026-10-12 11:29:01: B-31 crashed 8 s after
`coc WhiterunBanneredMare`, before F1 was brought, seated or sent; 3/3 U1 runs; signature SkyrimSE+0B479E8, fn
61420/60941; stack Uthgerd = F2 + The Bannered Mare). Each arm starts from the block save at the market, does ONE entry
into the inn, then idles 60 s with marker lines (wall clock, to line up with a crash log). A crash = the block's crash
path (INCONCLUSIVE "game crashed" + relaunch); surviving = PASS "survived". Score crashes by spec §15.4 (RV-205 (6)).
  B-31a1/a2  coc WhiterunBanneredMare, both followers following (B-31's exact entry)
  B-31w1/w2  natural walk-in: the player at the Mare's front door outside, DoorUse 0x1A6F4, followers following
  B-31d1/d2  F2 (Uthgerd) told to wait at the market first (NFFWait, read back), then the coc
Diagnostic only: no bridge errand, no sit, no API cost (RV-205: no Shae decision)."""
import time
from block import test
from tests_misc import con, player_pos, player_moved
from tests_b import F2, MARKET, mark, player_to, num, probe
from tests_tm_l import ctl_wait

DOOR_MARE_EXT = 0x0001A6F4      # tests_tm_l.py:42, ext (25726,-7631)
IDLE_S = 60


def _idle(r, label):
    mark(r, "idle %d s after %s" % (IDLE_S, label))
    for k in range(IDLE_S // 10):
        time.sleep(10)
        p = player_pos(r) or {}
        mark(r, "alive +%ds cell=%s" % ((k + 1) * 10, p.get("cell")))
    r.check(True, "survived %d s after %s" % (IDLE_S, label))


def _coc(r, label):
    w0 = player_pos(r)
    mark(r, "coc WhiterunBanneredMare (%s)" % label)
    con(r, "coc WhiterunBanneredMare")
    time.sleep(5)
    if not player_moved(r, w0, "coc WhiterunBanneredMare"):
        return False
    return True


def _arm_coc(r):
    player_to(r, MARKET)
    mark(r, "at market, followers following")
    if _coc(r, "followers following"):
        _idle(r, "coc")


def _arm_walk(r):
    player_to(r, DOOR_MARE_EXT)
    mark(r, "at the Mare front door (outside)")
    time.sleep(5)
    mark(r, "DoorUse 0x1A6F4")
    m = ctl_wait(r, "DoorUse", [DOOR_MARE_EXT], r"(?i)\[IEB-TEST\] DoorUse(?: \S+ dest=\S+ destCell=\S+|: [^\n]*)", 20)
    if m is None or "DoorUse:" in m.group(0):
        r.inconclusive += 1
        r.log("INCONCLUSIVE %s precondition: DoorUse did not fire (%s)" % (r.name, m.group(0) if m else "no line"))
        return
    time.sleep(8)
    _idle(r, "walk-in through the front door")


def _arm_f2_out(r):
    player_to(r, MARKET)
    r.ctl("NFFWait", [F2])
    time.sleep(3)
    pw = probe(r, F2) or {}
    if num(pw.get("wfp")) != 1.0:
        r.inconclusive += 1
        r.log("INCONCLUSIVE %s precondition: F2 not waiting after NFFWait (wfp=%s)" % (r.name, pw.get("wfp")))
        return
    mark(r, "F2 waiting at the market (wfp=1)")
    if _coc(r, "F2 left outside"):
        _idle(r, "coc with F2 outside")


for _tid, _fn in (("B-31a1", _arm_coc), ("B-31a2", _arm_coc), ("B-31w1", _arm_walk), ("B-31w2", _arm_walk),
                  ("B-31d1", _arm_f2_out), ("B-31d2", _arm_f2_out)):
    test(_tid, "B31R", reload=True)(lambda r, _f=_fn: _f(r))
