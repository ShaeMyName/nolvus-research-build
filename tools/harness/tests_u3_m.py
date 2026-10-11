"""U3 block, part 2: tests on save T0-M (marriage, rank sync, RDO blacklist, the MA-2 boxes) and the ENT-4 watch.
Step8_time_plan.md §3.5 :257-280, §5 U3 row :380; spec rows BRIDGE_SPEC_V2.md MA-1..MA-7 :2345-2351, RS-1..RS-10
:2924-2933, DA-9 DIALOGUE_OVERLAY/README.md:77, K-M3 investigation/round6/kinship_maras.md:128, ENT-4 TASK_C.md:428.
Written 2026-10-11, not yet run. House style: tests_u2.py / tests_misc.py; helpers in tests_u3.py.

Cast: tests_u3.T0M (build_t0m.py fills it); a None entry = INCONCLUSIVE. Counts, FormIDs and booleans only: no MARAS.log
line, dialogue or reply text, quest name or message-box text is logged (box plugin and button count only).
Acceleration (DECISIONS:423 D3, TASK_C.md:424-428): x100 only for MA-4/MA-5 (one 24-game-hour window) and ENT-4
(4-5 game days); RestoreTimescale + ASSERT PASS TIMESCALE at teardown (tests_tm_l.Accelerated). Nothing else here
accelerates.
MA-2: the boxes ARE the pass. They are detected through the harness ui-state (sn_harness.ui_state) and SkyrimNet's
MessageBox hook line; dismiss_ui is never called. A box left open is cleared by the block's reload of T0-M.
Child safety: no child is touched here (MarasSet is used on adult cast members only; U3GiftRank / U3ExecAction
refuse a child in Papyrus too)."""
import json, re, time
import sn_harness as SH
from block import test, checkpoint
from tests_misc import (F2, con, ctl_line, inc, s32, who, rank, rval, iv, tail, su_get, su_set, su_unset, _set_pts,
                        _ranksync, DEST_NEAR, near_player)
from tests_tm_l import Accelerated
from tests_u2 import harness_ready
from tests_u3 import (T0M, SANDBOX_EDID, cast, status_is, maras_probe, maras_debug, maras_promote, gift_rank, maras_counts,
                      maras_tail, probe_raw, pkg_hex, pkg_edid, errand_arm, screenshot)

ENT4 = {"save": "T0-ENT4",   # made in S-A after Shae appoints the steward (time plan :289); blocks_def's U3E save
        "steward": None}     # the NFF follower appointed as SA steward and told to wait (NFF Wait)
ENT4_MIN_DAYS, ENT4_MAX_DAYS, ENT4_WALL_MAX_S = 4.0, 5.0, 95 * 60
MA45_HOURS, MA45_WALL_MAX_S = 24.0, 25 * 60


def to_spouse(r, fid):
    """Player beside the actor (her cell loads); MCP uuid then resolves. RV-123 (3): read back by distance; False =
    INCONCLUSIVE already logged."""
    con(r, "player.moveto %08X" % fid)
    time.sleep(10)
    return near_player(r, fid, "player.moveto", maxd=1000)


def clock(r):
    """(game hour, days passed) from TestCtl.CrashCtx (GameHour / GameDaysPassed, TestCtl:178-192)."""
    m = ctl_line(r, "CrashCtx", [0x14], r"\[IEB-TEST\] CRASHCTX hour=(\S+) days=(\S+)", 15)
    try:
        return (float(m.group(1)), float(m.group(2))) if m else (None, None)
    except ValueError:
        return None, None


def sched_of(line):
    m = re.search(r"\bschedIdx=(-?\d+)/(-?\d+)/(-?\d+)", line or "")
    return tuple(int(x) for x in m.groups()) if m else None


def flag(line, key):
    m = re.search(r"\b%s=(\S+)" % key, line or "")
    return m.group(1) if m else None


def is_one(v):
    try:
        return float(v) == 1.0
    except (TypeError, ValueError):
        return False


# ============================================================================ MA-3 (= K-M2 allowed half)

@test("MA-3", "MA", save="T0-M", reload=True)
def ma3(r):
    """Housed spouse (spouse2), not following, player-requested GoToLocation (TestCtl.StartTask, as the player's AI
    request would start it): the errand completes (arrival line, IE_Travel:642) and MARAS.log shows the package
    allowed by plugin ('allowing plugin-whitelisted ... on actor', PackageOverrideService.cpp:428, VERIFIED) under our
    AllowedPlugins=...,IntelEngine.esp (rule 1). Also K-M2's 'allowed' half (merged). INFERRED: (1) StartTask = the
    player-requested path for this check; (2) arrival within 240 s from Breezehome to DEST_NEAR."""
    sp = cast(r, "spouse2")
    if sp is None:
        return
    mp = maras_probe(r, sp)
    if not mp or not status_is(mp, "married") or iv(mp, "housed", -2) < 0 or iv(mp, "tm") != 0:
        return inc(r, "spouse2 is not a housed, non-following MARAS spouse (%s)"
                   % ({k: mp.get(k) for k in ("status", "housed", "tm")} if mp else "no probe"))
    if not maras_debug(r):
        return
    checkpoint(r)
    a = errand_arm(r, sp, mp.get("name", ""), timeout=240)
    r.log("  MA-3: started %s, arrived %s after %d s, MARAS allow-plugin %d, suppress %d"
          % (a["started"], a["arrived"], a["secs"], a["counts"]["allow_plugin"], a["counts"]["suppress"]))
    if not a["started"]:
        return inc(r, "the errand never got an IE slot")
    r.check(a["arrived"], "the errand completes (arrival)")
    r.check(a["counts"]["allow_plugin"] >= 1, "MARAS.log: the package allowed by plugin (%d)" % a["counts"]["allow_plugin"])


# ============================================================================ MA-4 + MA-5: one accelerated 24-game-hour window

_MA45 = {}


def _ma45_window(r):
    """Both spouses watched in ONE x100 window of 24 game hours (time plan idea 12; D3 x100: 1 game hour = 36 real s,
    SA's 30 s tick still lands in each hour, INFERRED). Probe both every 15 real s; MARAS.log tailed over the window.
    Results cached for whichever of MA-4 / MA-5 runs second."""
    if _MA45:
        return _MA45
    s1, s2 = T0M.get("spouse1"), T0M.get("spouse2")
    p1 = maras_probe(r, s1) if s1 else None
    p2 = maras_probe(r, s2) if s2 else None
    d1, l1 = probe_raw(r, s1) if s1 else (None, "")
    d2, l2 = probe_raw(r, s2) if s2 else (None, "")
    _MA45["pre"] = dict(p1=p1, p2=p2, l1=l1, l2=l2, c2=(d2 or {}).get("cellhex"))
    if not maras_debug(r):
        _MA45["error"] = "MARAS Debug log level not set"
        return _MA45
    h0, dd0 = clock(r)
    if h0 is None:
        _MA45["error"] = "no CRASHCTX clock line"
        return _MA45
    t_mar = maras_tail()
    s1rows, s2rows = [], []
    t0 = time.time()
    with Accelerated(r, 100.0) as acc:
        if not acc.ok:
            _MA45["error"] = "Accelerate(100) refused"
            return _MA45
        while time.time() - t0 < MA45_WALL_MAX_S:
            hr, dd = clock(r)
            if hr is None:
                time.sleep(5)
                continue
            gh = (dd - dd0) * 24.0
            for fid, rows in ((s1, s1rows), (s2, s2rows)):
                if fid:
                    d, line = probe_raw(r, fid)
                    if d:
                        rows.append(dict(gh=gh, abs=dd * 24.0, pkg=pkg_hex(d), edid=pkg_edid(d), sched=sched_of(line),
                                         cell=d.get("cellhex"), loaded=d.get("loaded")))
            if gh >= MA45_HOURS:
                break
            time.sleep(15)
    text = t_mar.read()
    _MA45.update(s1=s1rows, s2=s2rows, gh=(s1rows or s2rows or [{"gh": 0}])[-1]["gh"],
                 c1=maras_counts(text, s1) if s1 else None, c2=maras_counts(text, s2) if s2 else None,
                 post1=maras_probe(r, s1) if s1 else None, post2=maras_probe(r, s2) if s2 else None)
    r.log("  MA-4/5 window: %.1f game hours in %d s, samples %d / %d" % (_MA45["gh"], time.time() - t0, len(s1rows),
                                                                       len(s2rows)))
    return _MA45


def _transitions(rows):
    """Package changes of one actor: list of (prev row, row)."""
    return [(a, b) for a, b in zip(rows, rows[1:]) if a["pkg"] != b["pkg"] or a["sched"] != b["sched"]]


@test("MA-4", "MA", save="T0-M")
def ma4(r):
    """Spouse1 (released from the MARAS house via 'manage spouse', SA home + work posts), watched 24 game hours at x100:
    (1) home/work switches on the hour per SA: >= 2 package/schedule-alias changes, each with a whole game hour inside
    its sampling interval; (2) no MARAS PackageStartHook line for her (Debug level on; spouse2's lines in the same window
    are the positive control); (3) not in MARAS's housed faction before and after (TT_MARAS.esp 0x6C).
    INFERRED: (1) SA's switch shows as a package or schedIdx change in Watcher.Line; (2) 'on the hour' is only checkable
    to the 25-game-minute sampling step; (3) x100 does not change SA's schedule logic (D3 rationale)."""
    s1 = cast(r, "spouse1")
    if s1 is None:
        return
    mp = maras_probe(r, s1)
    d, line = probe_raw(r, s1)
    if not mp or not status_is(mp, "married"):
        return inc(r, "spouse1 is not a MARAS spouse (%s)" % (mp.get("st") if mp else "no probe"))
    if iv(mp, "housed", -2) >= 0:
        return inc(r, "spouse1 is still in MARAS's housed faction (not released)")
    if flag(line, "saHome") != "1" or flag(line, "saWork") != "1":
        return inc(r, "spouse1 has no SA home + work posts (saHome %s saWork %s)" % (flag(line, "saHome"), flag(line, "saWork")))
    checkpoint(r, "24 game hours at x100 (~15 min), shared with MA-5")
    w = _ma45_window(r)
    if w.get("error"):
        return inc(r, "window: %s" % w["error"])
    rows = w["s1"]
    if w["gh"] < MA45_HOURS - 0.5:
        inc(r, "the window covered only %.1f game hours" % w["gh"])
    tr = _transitions(rows)
    on_hour = [b for a, b in tr if int(a["abs"]) != int(b["abs"])]     # a whole game hour lies in (a, b]
    r.log("  spouse1: %d samples, %d package/schedule changes, %d with a whole hour inside the interval; packages %s"
          % (len(rows), len(tr), len(on_hour), sorted({x["pkg"] for x in rows})))
    r.check(len(tr) >= 2, "home/work switches seen (%d changes in 24 game hours)" % len(tr))
    r.check(len(tr) >= 1 and len(on_hour) == len(tr), "every switch falls on a whole game hour (to the sampling step)")
    c1, c2 = w.get("c1") or {}, w.get("c2") or {}
    if not c2.get("any"):
        inc(r, "no MARAS hook line for spouse2 either: Debug logging not proven, the 'no line' check is vacuous")
    else:
        r.check(c1.get("any", 0) == 0, "no MARAS PackageStartHook line for spouse1 (%d; spouse2 control %d)"
                % (c1.get("any", 0), c2["any"]))
    post = w.get("post1") or {}
    r.check(iv(post, "housed", -2) < 0, "spouse1 not in MARAS's housed faction after the window")


@test("MA-5", "MA", save="T0-M", reload=True)
def ma5(r):
    """Spouse2 stays housed, unposted, not following over the same 24 game hours: (1) in TTM_SpouseHomeSandbox in >= 90 %
    of the samples and always in the house cell; (2) MARAS.log shows other packages redirected to the sandbox
    ('suppressing ... redirecting', :465) at least once; (3) vendor/store/greeting lines: their condition (the housed
    faction, TT_MARAS FACT conditions, spec :2237) holds throughout; the lines themselves need the dialogue menu (S-B).
    INFERRED: 90 % tolerance for package re-evaluation moments. reload=True: the window moved the clock 24 h."""
    s2 = cast(r, "spouse2")
    if s2 is None:
        return
    mp = maras_probe(r, s2)
    d, line = probe_raw(r, s2)
    if not mp or not status_is(mp, "married") or iv(mp, "housed", -2) < 0 or iv(mp, "tm") != 0:
        return inc(r, "spouse2 is not a housed, non-following MARAS spouse")
    if flag(line, "saHome") == "1" or flag(line, "saWork") == "1":
        return inc(r, "spouse2 has an SA post (should be unposted)")
    checkpoint(r, "uses MA-4's 24-game-hour window (or runs it)")
    w = _ma45_window(r)
    if w.get("error"):
        return inc(r, "window: %s" % w["error"])
    rows = w["s2"]
    if not rows:
        return inc(r, "no samples for spouse2")
    sb = sum(1 for x in rows if x["edid"] == SANDBOX_EDID)
    cells = {x["cell"] for x in rows}
    r.log("  spouse2: %d samples, %d in the home sandbox, cells %d, packages %s" % (len(rows), sb, len(cells),
                                                                                 sorted({x["pkg"] for x in rows})))
    r.check(sb >= 0.9 * len(rows), "stays in TTM_SpouseHomeSandbox (%d of %d samples)" % (sb, len(rows)))
    r.check(cells == {w["pre"].get("c2")}, "stays in the house cell")
    c2 = w.get("c2") or {}
    r.check(c2.get("suppress", 0) >= 1, "MARAS.log: other packages redirected to the sandbox (%d)" % c2.get("suppress", 0))
    post = w.get("post2") or {}
    r.check(iv(post, "housed", -2) >= 0, "housed faction (the vendor/store condition) kept after the window")
    r.log("  NOTE vendor/store/greeting lines in her menu: dialogue-menu check, S-B")


# ============================================================================ MA-6 (lend MA-4's spouse)

@test("MA-6", "MA", save="T0-M", reload=True)
def ma6(r):
    """Spouse1 (SA-posted) lent for a player IntelEngine errand: (1) 'LEND actor=' in the bridge log; (2) the errand
    completes (arrival); (3) after Cancel: LEND_RESTORE, an SA schedule alias is refilled (schedIdx not -1/-1/-1);
    (4) she walks back: no jump > 1500 u between 2 s samples while she returns (no teleport); (5) I1-I10:
    TestCtl.Check -> true (Watcher.CheckInvariants against the Snapshot taken before). INFERRED: 1500 u per 2 s is
    above walking/running speed and below any teleport; she stays loaded near the player (the player waits at her
    post)."""
    s1 = cast(r, "spouse1")
    if s1 is None:
        return
    mp = maras_probe(r, s1)
    d, line = probe_raw(r, s1)
    if not mp or not d or flag(line, "saHome") != "1":
        return inc(r, "spouse1 not SA-posted or not found")
    name = mp.get("name", "")
    if not to_spouse(r, s1):
        return
    t0 = tail("papyrus")
    if not ctl_line(r, "Snapshot", [s32(s1)], r"\[IEB-TEST\] snapshot [^\n]*", 20):
        return inc(r, "read-back: no Snapshot line for spouse1 (I1-I10 baseline not confirmed; RV-123 (3))")
    if not ctl_line(r, "ExpectLend", [s32(s1)], r"\[IEB-TEST\] ExpectLend[^\n]*", 10):
        return inc(r, "read-back: no ExpectLend line for spouse1 (EBT_WasLent not confirmed; RV-123 (3))")
    checkpoint(r)
    r.ctl("StartTask", [s32(s1), "GoToLocation", DEST_NEAR, "", ""])
    m = t0.wait(r"(?i)\[IEB\] (LEND|TAKE|TAKE_SKIP|REFUSE) actor=%s\b[^\n]*" % re.escape(name), 30)
    try:
        if not m or m.group(1).upper() != "LEND":
            return inc(r, "spouse1 not lent (%s)" % (m.group(1) if m else "no bridge decision"))
        r.check(True, "LEND step in the bridge log")
        arr = t0.wait(r"IntelEngine: %s arrived at " % re.escape(name), 240)
        r.check(bool(arr), "the errand completes (arrival)")
    finally:
        t1 = tail("papyrus")
        r.ctl("Cancel", [s32(s1)])
        rs = t1.wait(r"(?i)\[IEB\] LEND_RESTORE(?:_SKIP)? actor=%s\b" % re.escape(name), 40)
    r.check(bool(rs), "LEND_RESTORE after the cancel")
    path, jumps, refilled = [], 0, False
    end = time.time() + 120
    while time.time() < end:
        dd, ll = probe_raw(r, s1)
        if dd:
            sc = sched_of(ll)
            refilled = refilled or (sc is not None and sc != (-1, -1, -1))
            try:
                xyz = tuple(float(v) for v in dd.get("pos", "").split(","))
                if path and len(xyz) == 3 and sum((a - b) ** 2 for a, b in zip(xyz, path[-1])) ** 0.5 > 1500:
                    jumps += 1
                if len(xyz) == 3:
                    path.append(xyz)
            except ValueError:
                pass
        time.sleep(2)
    r.log("  walk-back samples %d, jumps > 1500 u: %d" % (len(path), jumps))
    r.check(refilled, "SA schedule alias refilled")
    if len(path) < 10:
        inc(r, "too few loaded samples to judge the walk back (%d)" % len(path))
    else:
        r.check(jumps == 0, "walks back to the post (no teleport)")
    m = ctl_line(r, "Check", [s32(s1)], r"\[IEB-TEST\] Check [^\n]*-> (\w+)", 15)
    r.check(bool(m) and m.group(1).lower() == "true", "I1-I10 (TestCtl.Check)")


# ============================================================================ K-M3

@test("K-M3", "K", save="T0-M", reload=True)
def km3(r):
    """Held NFF-follower spouse on an errand (kinship_maras.md:128): MARAS.log 'is a follower, skipping sandbox
    override' for her (:323, Debug level); the errand runs normally (bridge TAKE, arrival); after the recall she is
    released (bridge RELEASE*/REJOIN* line) and keeps following (tm=1). INFERRED: 'returns home after release' for a
    following spouse means back with the player (she is a follower, not housed)."""
    fs = cast(r, "follower_spouse")
    if fs is None:
        return
    mp = maras_probe(r, fs)
    if not mp or not status_is(mp, "married") or iv(mp, "tm") != 1:
        return inc(r, "follower_spouse is not a married NFF follower (%s)" % ({k: mp.get(k) for k in ("status", "tm")}
                                                                              if mp else "no probe"))
    name = mp.get("name", "")
    if not maras_debug(r):
        return
    con(r, "%08X.moveto player" % fs)
    time.sleep(4)
    if not near_player(r, fs, "moveto player"):
        return
    checkpoint(r)
    t_pap, t_mar = tail("papyrus"), maras_tail()
    r.ctl("StartTask", [s32(fs), "GoToLocation", DEST_NEAR, "", ""])
    m = t_pap.wait(r"(?i)\[IEB\] TAKE actor=%s\b" % re.escape(name), 90)
    try:
        if not m:
            return inc(r, "no bridge TAKE for the follower spouse")
        arr = t_pap.wait(r"IntelEngine: %s arrived at " % re.escape(name), 240)
        r.check(bool(arr), "errand normal (arrival)")
        c = maras_counts(t_mar.read(), fs)
        r.check(c["follower_skip"] >= 1, "MARAS: 'is a follower, skipping sandbox override' (%d)" % c["follower_skip"])
        r.check(c["suppress"] == 0, "MARAS never redirected her package (%d)" % c["suppress"])
    finally:
        t1 = tail("papyrus")
        r.ctl("Recall", [s32(fs), 0])
        rel_m = t1.wait(r"(?i)\[IEB\] (RELEASE\w*|REJOIN_DONE|REJOIN_TO_WAIT) actor=%s\b" % re.escape(name), 120)
    r.check(bool(rel_m), "released after the recall")
    p = maras_probe(r, fs)
    r.check(bool(p) and iv(p, "tm") == 1, "following again after the release (tm=%s)" % (p and p.get("tm")))


# ============================================================================ RS on T0-M (spec §11.14.6)

def _rs_spouse(r, key, need_enrolled=False):
    """(fid, name) of a married MARAS spouse from the cast, optionally enrolled in Relationships; else None."""
    fid = cast(r, key)
    if fid is None:
        return None
    mp = maras_probe(r, fid)
    if not mp or not status_is(mp, "married"):
        inc(r, "%s is not a MARAS spouse (%s)" % (key, mp.get("st") if mp else "no probe"))
        return None
    if need_enrolled and iv(rank(r, fid) or {}, "tier", -1) < 0:
        inc(r, "%s is not enrolled in Relationships (SNRom_Bond tier < 0)" % key)
        return None
    return fid, mp.get("name", "")


def _apply(r, fid, n=1):
    for _ in range(n):
        ctl_line(r, "RankApply", [s32(fid)], r"\[IEB-TEST\] RANKAPPLY", 15)


def _setrank(r, fid, v):
    """SetRank (its SETRANK line only echoes the value), read back by RankProbe (RV-123 (3)). False = INCONCLUSIVE."""
    ctl_line(r, "SetRank", [s32(fid), int(v)], r"\[IEB-TEST\] SETRANK", 15)
    k = rank(r, fid)
    if not k or iv(k, "r") != int(v):
        inc(r, "read-back: SetRank %d on %08X reads rank %s (RV-123 (3))" % (int(v), fid, k and k.get("r")))
        return False
    return True


def _gift(r, fid, v):
    """U3GiftRank write, asserted on the rank it reads back (RV-123 (3)). False = INCONCLUSIVE."""
    g = gift_rank(r, fid, v)
    if g != int(v):
        inc(r, "read-back: RDO gift counter on %08X reads %s, want %d (RV-123 (3))" % (fid, g, int(v)))
        return False
    return True


def _su_is(r, fid, key, v, what):
    """StorageUtil int read back through SUGetInt (su_set's 'set=' only echoes; unset reads -99). False = INCONCLUSIVE."""
    got = su_get(r, None, key, fid=fid)
    if got != v:
        inc(r, "read-back %s: %s on %08X reads %s, want %s (RV-123 (3))" % (what, key, fid, got, v))
        return False
    return True


@test("RS-2", "RS", save="T0-M", reload=True)
def rs2(r):
    """MARAS marriage (made in T0-M setup): rank 4; console-equivalent SetRank 3; the next sweep step (RankApply =
    IEB_RankSync.SweepStep's per-actor pass) -> back to 4 with 'RANKSYNC ... to=4 why=raise' (IEB_RankSync.Apply :128-157,
    married target 4). The spouse line (PlayerMarriedFaction INFO) needs the dialogue menu: S-B. INFERRED: TestCtl
    SetRank = console setrelationshiprank."""
    sp = _rs_spouse(r, "spouse1")
    if not sp:
        return
    fid, name = sp
    k0 = rank(r, fid)
    r.check(bool(k0) and iv(k0, "r") == 4, "rank 4 at marriage (%s)" % (k0 and k0.get("r")))
    checkpoint(r)
    if not _setrank(r, fid, 3):
        return
    t = tail("papyrus")
    _apply(r, fid)
    hits = _ranksync(t.read(), name)
    k1 = rank(r, fid)
    r.check(any(h["t"] == "4" and h["why"] == "raise" for h in hits) and bool(k1) and iv(k1, "r") == 4,
            "back to 4 after the sweep, why=raise (%s)" % (k1 and k1.get("r")))
    r.log("  NOTE spouse greeting (PlayerMarriedFaction INFO): dialogue-menu check, S-B")


@test("RS-5", "RS", save="T0-M", reload=True, forced=True)
def rs5(r):
    """SA brawl with an enrolled Friend (F2): while SA's saved value exists (SeverCombat_OriginalRelationship, set by
    SA_Combat.psc:459-462) the sync writes nothing ('why=skip:sa_brawl', IEB_RankSync.Apply :102-104); after SA restores
    it (key removed, SA_Combat.psc:767), the sync resumes ('why=raise'). FORCED STATE: the installed SeverActions has no
    Brawl action (no brawl.yaml; AttackTarget is a real, lethal fight), so the saved value is written with SUSetInt and
    the fight's lowered rank is SetRank 0 (no hostility). INFERRED equivalence to a real brawl for the rank sync."""
    u, name, _ = who(r, F2)
    if not name:
        return inc(r, "F2 not loaded")
    if iv(rank(r, F2) or {}, "tier", -1) < 0:
        return inc(r, "F2 not enrolled")
    _set_pts(r, F2, 1100)
    ctl_line(r, "SetRank", [s32(F2), 1], r"\[IEB-TEST\] SETRANK", 15)     # read back with the apply at k0 below
    _apply(r, F2)
    k0 = rank(r, F2)
    if not k0 or iv(k0, "tier") != 2 or iv(k0, "r") != 1:
        return inc(r, "setup: want Friend tier, rank 1 (tier %s rank %s)" % (k0 and k0.get("tier"), k0 and k0.get("r")))
    checkpoint(r)
    try:
        su_set(r, F2, "SeverCombat_OriginalRelationship", 1)
        if not _su_is(r, F2, "SeverCombat_OriginalRelationship", 1, "su_set") or not _setrank(r, F2, 0):
            return
        t = tail("papyrus")
        _apply(r, F2, 2)
        hits = _ranksync(t.read(), name)
        k1 = rank(r, F2)
        r.check(any(h["why"] == "skip:sa_brawl" for h in hits), "during the brawl: 'why=skip:sa_brawl'")
        r.check(bool(k1) and iv(k1, "r") == 0 and not any(h["why"] == "raise" for h in hits),
                "no write while the saved value exists (rank stays 0)")
    finally:
        su_unset(r, F2, "SeverCombat_OriginalRelationship")
    if not _su_is(r, F2, "SeverCombat_OriginalRelationship", -99, "su_unset"):
        return
    t = tail("papyrus")
    _apply(r, F2)
    hits = _ranksync(t.read(), name)
    k2 = rank(r, F2)
    r.check(any(h["t"] == "1" and h["why"] == "raise" for h in hits) and bool(k2) and iv(k2, "r") == 1,
            "after SA's restore the sync resumes (raise to 1)")


@test("RS-8d", "RS", save="T0-M", reload=True)
def rs8d(r):
    """RS-8 (d) (the T0 part (a)-(c),(e) ran in U1): a MARAS spouse whose Relationships tier drops stays at rank 4
    (married target 4 floors the drop, IEB_RankSync.Apply :128-131/:157-167). Spouse1 raised to a high tier, synced,
    then her points dropped to Stranger (ApplyDepth -> SyncBondRank -> Apply). Needs spouse1 enrolled."""
    sp = _rs_spouse(r, "spouse1", need_enrolled=True)
    if not sp:
        return
    fid, name = sp
    kp = _set_pts(r, fid, 2100)
    if not kp or iv(kp, "pts") != 2100:
        return inc(r, "read-back: spouse1 points %s, want 2100 (RV-123 (3))" % (kp and kp.get("pts")))
    _apply(r, fid)
    k0 = rank(r, fid)
    if not k0 or iv(k0, "r") != 4:
        return inc(r, "setup: spouse1 not at rank 4 (%s)" % (k0 and k0.get("r")))
    checkpoint(r)
    t = tail("papyrus")
    _set_pts(r, fid, 100)
    _apply(r, fid)
    hits = _ranksync(t.read(), name)
    k1 = rank(r, fid)
    r.log("  tier %s -> %s" % (k0.get("tier"), k1 and k1.get("tier")))
    if not k1 or iv(k1, "tier") >= iv(k0, "tier"):
        return inc(r, "the tier did not drop")
    r.check(iv(k1, "r") == 4 and not any(h["why"] == "drop" for h in hits), "(d) spouse stays at rank 4 after the drop")


@test("RS-10be", "RS", save="T0-M", reload=True, forced=True)
def rs10be(r):
    """Spouse gift undo (spec RS-10 :2933), parts (b)-(e); (a) is the hand-pressed gift offers (S-B, D4).
    (b) spouse1 after (a): IEB_GiftUndone = 1 (written here: forced, (a) runs later in S-B), counter 5, rank -1, three
    sweeps -> stays -1, 'why=skip:negative', no gift_undo. (c) spouse2 with counter < 5 (set 2): -1, a sweep -> stays -1.
    (e) spouse2 whose counter reached 5 before the wedding: keys of a never-synced spouse (IEB_GiftUndone,
    IEB_RankSyncTier/Rom unset), counter 5, rank 4 -> first sync stamps IEB_GiftUndone = 1 without writing; then -1 and
    a sweep -> stays -1. (d) a divorced ex with counter 5 and rank -2: spouse2 promoted to 'divorced' by MARAS natives
    (forced; no box on the native path, TTM_ServiceSkyrimNet.psc:146 promotes after the box), a sweep -> stays -2,
    'why=skip:maras' (IEB_RankSync.Apply :107-111). Counter = RDO faction 0xED7778 (Apply :136), set by U3GiftRank.
    INFERRED: native promotion = a real divorce for MarasStatus(); the forced keys = the states the spec describes."""
    s1 = _rs_spouse(r, "spouse1")
    s2 = _rs_spouse(r, "spouse2")
    if not (s1 and s2):
        return
    if gift_rank(r, s1[0]) is None:
        return inc(r, "RDO gift-counter faction not readable (U3GiftRank)")
    checkpoint(r)
    # (b)
    fid, name = s1
    su_set(r, fid, "IEB_GiftUndone", 1)
    if not _su_is(r, fid, "IEB_GiftUndone", 1, "(b) su_set") or not _gift(r, fid, 5) or not _setrank(r, fid, -1):
        return
    t = tail("papyrus")
    _apply(r, fid, 3)
    hits = _ranksync(t.read(), name)
    k = rank(r, fid)
    r.check(bool(k) and iv(k, "r") == -1 and any(h["why"] == "skip:negative" for h in hits)
            and not any(h["why"] == "gift_undo" for h in hits), "(b) stays -1 over three sweeps, skip:negative")
    # (c)
    fid, name = s2
    if not _gift(r, fid, 2) or not _setrank(r, fid, -1):
        return
    t = tail("papyrus")
    _apply(r, fid)
    hits = _ranksync(t.read(), name)
    k = rank(r, fid)
    r.check(bool(k) and iv(k, "r") == -1 and not any(h["why"] == "gift_undo" for h in hits),
            "(c) second spouse with counter < 5 stays -1")
    # (e)
    for key in ("IEB_GiftUndone", "IEB_RankSyncTier", "IEB_RankSyncRom"):
        su_unset(r, fid, key)
        if not _su_is(r, fid, key, -99, "(e) su_unset"):
            return
    if not _gift(r, fid, 5) or not _setrank(r, fid, 4):
        return
    t = tail("papyrus")
    _apply(r, fid)
    hits = _ranksync(t.read(), name)
    stamped = su_get(r, None, "IEB_GiftUndone", fid=fid)
    k = rank(r, fid)
    r.check(stamped == 1 and bool(k) and iv(k, "r") == 4 and not any(h.get("f") for h in hits),
            "(e) first sync stamps IEB_GiftUndone without writing (stamp %s)" % stamped)
    if not _setrank(r, fid, -1):
        return
    t = tail("papyrus")
    _apply(r, fid)
    k = rank(r, fid)
    r.check(bool(k) and iv(k, "r") == -1 and not any(h["why"] == "gift_undo" for h in _ranksync(t.read(), name)),
            "(e) the later -1 stays")
    # (d) last: it changes spouse2's MARAS status (the block reloads T0-M after this test)
    p = maras_promote(r, fid, "divorced")
    if not status_is(p, "divorced"):
        return inc(r, "(d) MARAS native divorce did not take (%s)" % (p.get("st") if p else "no probe"))
    if not _gift(r, fid, 5) or not _setrank(r, fid, -2):
        return
    t = tail("papyrus")
    _apply(r, fid)
    hits = _ranksync(t.read(), name)
    k = rank(r, fid)
    r.check(bool(k) and iv(k, "r") == -2 and any(h["why"] == "skip:maras" for h in hits),
            "(d) divorced ex stays -2, why=skip:maras")


# ============================================================================ DA-9 (DIALOGUE_OVERLAY/README.md:77)

def _say(r, uuid, text):
    SH.inject_player_input(text, uuid)
    SH.await_idle(90)
    time.sleep(3)


@test("DA-9", "DA", save="T0-M", reload=True)
def da9(r):
    """RDO blacklist, script-name keys (S-33). (1) SkyrimNet.log '[DialogueActionsLibrary] ... N blacklist entr(ies)'
    with N >= 10 (our list has 10). (2) At the housed spouse (spouse2) in the house, 'Could you sell me something?' ->
    no '[TIF-EXEC]'/'TriggerDialogueLine' line naming RDO_StartSpouseStore and she is not added to JobMerchantFaction
    (rank stays < 0). (3) At an RDO friend, 'Come with me.' -> no RDO_DefaultRecruit fired, she does not become a
    teammate. (4) 'Can I give you something?' -> no gift menu opens (SkyrimNet.log "Menu 'GiftMenu' is opening" = 0).
    LLM calls: 3. INFERRED: (a) the blacklist count is summed over all layers; (b) the TIF-EXEC line carries the
    fragment's script name when it fires one; (c) the gift menu's name is 'GiftMenu'. If a script-name key fails, the
    YAML's quest fallback applies (README)."""
    if not harness_ready(r):
        return
    sn = tail("skyrimnet")
    sn.pos = 0
    cnt = [int(x) for x in re.findall(r"\[DialogueActionsLibrary\][^\n]*?(\d+) blacklist entr\(ies\)", sn.read())]
    sp = cast(r, "spouse2")
    if sp is None:
        return
    mp = maras_probe(r, sp)
    if not mp or not status_is(mp, "married") or iv(mp, "housed", -2) < 0:
        return inc(r, "spouse2 is not a housed MARAS spouse")
    if not to_spouse(r, sp):
        return
    su, _, _ = who(r, sp)
    if not su:
        return inc(r, "spouse2 not loaded beside the player")
    merch0 = iv({"v": rval(r, su, 'get_faction_rank(actorUUID, "JobMerchantFaction")')}, "v")
    if merch0 >= 0:
        return inc(r, "spouse2 is already in JobMerchantFaction (no discriminating check)")
    checkpoint(r, "3 LLM calls")
    r.check(bool(cnt) and max(cnt) >= 10, "blacklist count line present and >= 10 (%s)" % (max(cnt) if cnt else "none"))
    t = tail("skyrimnet")
    _say(r, su, "Could you sell me something?")
    txt = t.read()
    r.check("RDO_StartSpouseStore" not in txt, "no RDO_StartSpouseStore line fired at the spouse")
    r.log("  TriggerDialogueLine firings during the store request (count): %d"
          % len(re.findall(r"TriggerDialogueLine firing", txt)))
    merch1 = iv({"v": rval(r, su, 'get_faction_rank(actorUUID, "JobMerchantFaction")')}, "v")
    r.check(merch1 < 0, "spouse not added to JobMerchantFaction (%d)" % merch1)
    fr = cast(r, "rdo_friend")
    if fr is None:
        return
    con(r, "player.moveto %08X" % fr)
    time.sleep(10)
    if not near_player(r, fr, "player.moveto", maxd=1000):
        return
    fu, _, _ = who(r, fr)
    if not fu:
        return inc(r, "rdo_friend not loaded")
    tm0 = (maras_probe(r, fr) or {}).get("tm")
    t = tail("skyrimnet")
    _say(r, fu, "Come with me.")
    txt = t.read()
    r.check("RDO_DefaultRecruit" not in txt, "no RDO_DefaultRecruit fired")
    tm1 = (maras_probe(r, fr) or {}).get("tm")
    r.check(tm0 == "0" and tm1 == "0", "the friend did not become a teammate (tm %s -> %s)" % (tm0, tm1))
    t = tail("skyrimnet")
    _say(r, fu, "Can I give you something?")
    r.check(not re.search(r"Menu 'GiftMenu' is opening", t.read()), "no gift menu opened")


# ============================================================================ MA-2: the boxes ARE the pass

def _box(r):
    """(open?, how) from the harness ui-state (field names INFERRED: any 'box' entry that is not empty, or a menu entry
    naming MessageBoxMenu). Only key names and booleans are logged, never box text."""
    try:
        st = SH.ui_state()
    except SH.HarnessError as e:
        return None, "ui-state failed: %s" % e
    if not isinstance(st, dict):
        return None, "ui-state not a dict"
    box = st.get("box")
    menus = json.dumps(st.get("menus", st.get("menu_open", "")))
    is_open = bool(box) or "MessageBoxMenu" in menus
    return is_open, "keys=%s box=%s msgboxmenu=%s" % (sorted(st.keys()), bool(box), "MessageBoxMenu" in menus)


def _box_hook(text):
    """SkyrimNet's MessageBox hook line ("MessageBox event: '...' (buttons: N, plugin: P)", SkyrimNet DLL strings
    :55074, VERIFIED): (count, [(buttons, plugin)]). The quoted text is never kept."""
    hits = re.findall(r"MessageBox event: '.*?' \(buttons: (\d+), plugin: ([^)\n]*)\)", text)
    return len(hits), hits


def _provoke(r, key, line, action):
    """MA-2 body: the actor must have the MARAS status the action needs; no box open before. Route 1 (AI): one provoking
    player line (1 LLM call), poll the ui-state 90 s. Route 2 (forced, only if no box): U3ExecAction runs the same MARAS
    action function (SkyrimNetApi.ExecuteAction, b25 SkyrimNetApi.psc:54-55), poll 30 s. PASS = a box seen (screenshot
    for Shae). The box is never dismissed; the block's reload of T0-M clears it."""
    fid = cast(r, key)
    if fid is None:
        return
    if not harness_ready(r):
        return
    want = "engaged" if action == "CancelWeddingEngagement" else "married"
    mp = maras_probe(r, fid)
    if not mp or not status_is(mp, want):
        return inc(r, "%s is not MARAS-%s" % (key, want))
    if not to_spouse(r, fid):
        return
    u, _, _ = who(r, fid)
    if not u:
        return inc(r, "%s not loaded beside the player" % key)
    o, how = _box(r)
    if o is None or o:
        return inc(r, "ui-state not usable or a box is already open before the provoke (%s)" % how)
    checkpoint(r, "1 LLM call, then the forced route if no box")
    sn = tail("skyrimnet")
    route = "AI"
    SH.inject_player_input(line, u)
    seen, end = False, time.time() + 90
    while time.time() < end and not seen:
        o, how = _box(r)
        seen = bool(o)
        time.sleep(2)
    if not seen:
        route = "forced"
        m = ctl_line(r, "U3ExecAction", [s32(fid), action], r"(?i)\[IEB-TEST\] U3EXEC [^\n]*", 15)
        if not m or "refused" in m.group(0).lower():
            return inc(r, "no box from the AI line and the forced route did not run (%s)" % (m.group(0) if m else "no line"))
        end = time.time() + 30
        while time.time() < end and not seen:
            o, how = _box(r)
            seen = bool(o)
            time.sleep(2)
    n, hits = _box_hook(sn.read())
    shot = screenshot("MA2_%s" % action) if seen else None
    r.log("  route %s; ui-state %s; hook boxes %d %s; screenshot %s" % (route, how, n, [(b, p) for b, p in hits], shot))
    r.check(seen, "the confirmation box appears (%s route) and is left open" % route)
    if route == "forced":
        r.log("  NOTE the AI did not pick %s from the line; the box came from the action function itself" % action)


@test("MA-2a", "MA", save="T0-M", reload=True)
def ma2a(r):
    """AI-initiated breakup of the engagement (MARAS action CancelWeddingEngagement -> TTM_Utils.ShowAIConfirmationMessage
    before the status change, TTM_ServiceSkyrimNet.psc:120-126, VERIFIED): the confirmation box appears. INFERRED: the
    harness ui-state names an open MessageBoxMenu; loading T0-M with the box open works (else block.py relaunches)."""
    _provoke(r, "engaged", "I can't marry you. I'm calling off our engagement, it's over between us.",
             "CancelWeddingEngagement")     # checkpoint(r) inside, after its preconditions


@test("MA-2b", "MA", save="T0-M", reload=True)
def ma2b(r):
    """AI-initiated divorce (MARAS action InitiateDivorce -> ShowAIConfirmationMessage('ConfirmDivorce'),
    TTM_ServiceSkyrimNet.psc:140-146, VERIFIED): the confirmation box appears. Last T0-M test: a box left open is cleared
    by the block's close. INFERRED as MA-2a."""
    _provoke(r, "spouse1", "I want a divorce. We're finished, I never want to see you again.",
             "InitiateDivorce")             # checkpoint(r) inside, after its preconditions


# ============================================================================ ENT-4 (TASK_C.md:428; S-3 play rule)

@test("ENT-4", "ENT", save="T0-ENT4")
def ent4(r):
    """A parked NFF follower appointed SA steward (S-A: SA menu appointment + NFF Wait, saved as T0-ENT4): over 4-5 game
    days at x100 (D3) a steward visit fires (Watcher stewardVisit 0 -> 1, IEB_SALib.StewardVisit :41-47) and after the
    last visit he is back at his wait spot (within 500 u of the start) and still told to wait (WFP 1). Records the
    farthest distance from the wait spot during visits (does he leave it). Probe every 20 real s (~33 game min).
    INFERRED: (1) the pass mark (no spec row; TASK_C's table names the question, S-3 names the risk); (2) a visit fires
    within 5 game days ('about twice a game week', spec :262); (3) the player standing at the wait spot does not change
    the visit logic. No visit in the window = INCONCLUSIVE. reload=False (last test of its block)."""
    st = ENT4.get("steward")
    if st is None:
        return inc(r, "ENT4['steward'] is not set (the steward appointed in S-A)")
    m = ctl_line(r, "U3StewardProbe", [s32(st)], r"(?i)\[IEB-TEST\] U3STEWARD (\S+) (.*)", 15)
    sd = dict(re.findall(r"(\w+)=(\S*)", m.group(2))) if m else {}
    if sd.get("hold") != "1" or not is_one(sd.get("wfp")):
        return inc(r, "steward precondition: appointed %s, waiting %s" % (sd.get("hold"), sd.get("wfp")))
    d0, _ = probe_raw(r, st)
    try:
        home = tuple(float(v) for v in (d0 or {}).get("pos", "").split(","))
    except ValueError:
        home = ()
    if len(home) != 3:
        return inc(r, "the steward is not loaded at his wait spot")
    h0, dd0 = clock(r)
    if h0 is None:
        return inc(r, "no CRASHCTX clock line")
    checkpoint(r, "4-5 game days at x100 (~60-75 min)")
    visits, in_visit, far, rows = 0, False, 0.0, 0
    t0 = time.time()
    with Accelerated(r, 100.0) as acc:
        if not acc.ok:
            return inc(r, "Accelerate(100) refused")
        while time.time() - t0 < ENT4_WALL_MAX_S:
            hr, dd = clock(r)
            if hr is None:
                time.sleep(5)
                continue
            days = dd - dd0
            d, line = probe_raw(r, st)
            if d:
                rows += 1
                v = flag(line, "stewardVisit") == "1"
                if v and not in_visit:
                    visits += 1
                in_visit = v
                try:
                    xyz = tuple(float(x) for x in d.get("pos", "").split(","))
                    if len(xyz) == 3 and v:
                        far = max(far, sum((a - b) ** 2 for a, b in zip(xyz, home)) ** 0.5)
                except ValueError:
                    pass
            if days >= ENT4_MAX_DAYS or (days >= ENT4_MIN_DAYS and visits >= 1 and not in_visit):
                break
            time.sleep(20)
    _, ddn = clock(r)
    r.log("  ENT-4: %.2f game days in %d s, %d samples, visits %d, farthest from the wait spot during a visit %d u"
          % ((ddn or dd0) - dd0, time.time() - t0, rows, visits, far))
    if visits == 0:
        return inc(r, "no steward visit fired in the window")
    time.sleep(30)
    dn, ln = probe_raw(r, st)
    try:
        xyz = tuple(float(x) for x in (dn or {}).get("pos", "").split(","))
    except ValueError:
        xyz = ()
    if len(xyz) != 3:
        return inc(r, "the steward is not loaded at the end (where is he?)")
    dist = sum((a - b) ** 2 for a, b in zip(xyz, home)) ** 0.5
    r.check(dist <= 500, "back at the wait spot after the visits (%d u)" % dist)
    r.check(is_one(flag(ln, "wfp")), "still told to wait (wfp=%s)" % flag(ln, "wfp"))
