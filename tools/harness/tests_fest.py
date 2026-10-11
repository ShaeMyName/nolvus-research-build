"""Festival nights (REVIEW_LOG RV-121-dec; design investigation/round10/festival_nights.md, apply_patch_f.py group
"festival", layer shae.festival from gen_layer_festival.py). Written 2026-10-11, NOT yet run, NOT registered in
blocks_def (proposed placement in the build report).

What is under test (patched Relationships):
- the night window (18:00-06:00, after midnight = the previous day) and the five keys (festival_nights.json);
- RV-121-dec rule 1: a scene is judged at its START (SNRom_PlayerAlias watch -> SNRom_Bridge.IEB_FestivalJudge) and
  does not flip mid-scene, either way;
- rule 2: after 06:00 no new festival scene, except the morning after with the SAME NPC until 12:00
  (IEB_FestivalPartnerDay), cleared at noon;
- the switch IEB_FestivalEnabled (player, default 0): off = no change and nothing written;
- a child: refused, nothing written; an orc below tier 2 in Lucienne's game (LUC_Active): refused.

Routes: date by console ("set gamemonth/gameday/gamehour to N", global sets run fine on the player), each write read
back at once through the template's native get_global_value (RV-123 (3)), and the Papyrus side through the read-only
probe SNRom_Bridge.IEB_FestivalProbe (a quest function on SNRom_Quest: "[IEB-FEST] PROBE" line, also returned). Scenes
through IEB_TestCtl.SceneOn / SceneOff (the StorageUtil keys IEB_SceneMain writes; SceneOn refuses a child, P2).
StorageUtil writes through IEB_TestCtl.SUSetInt, each read back with SUGetInt.
GameMonth is 0-based: Sun's Dawn = 1, so Heart's Day (16 Sun's Dawn) = key 116.

Hard rules: results are flags, numbers and FormIDs. The prompt checks match our OWN layer headings / placeholder
phrases (shae.festival), never log rendered text. Every test reloads T0. A child is never made a scene partner, never
given a romance key (the child test only reads and tries the refusing SceneOn wrapper). Needs installed: the patched
Relationships pex (group festival), the shae.festival layer with SKSE/Plugins/ErrandBridge/festival_nights.json."""
import re, time
from block import test, checkpoint
from tests_misc import F1, F2, CHILD, PLAYER, con, ctl_line, inc, iv, tail, su_set, su_unset, su_get, parse_kv
from tests_misc import rel, ah, who, rval, render, romance, rank, near_player, _set_pts, hx, retval

GHORZA = 0x00019906      # VERIFIED Skyrim.esm ACHR (persistent) of NPC_ GhorzaGraBagol 0x1339A, RNAM OrcRace 0x13747
                         # (gamedata/Skyrim.esm scan 2026-10-11). Only READ (probe); never moved or written.
HEARTS = 116             # 16 Sun's Dawn: GameMonth 1, GameDay 16
WATCH = 8                # s: the player-alias watch polls every 5 s with the switch on
CUSTOM_HEAD = "## The Festival"        # 0340 heading (shae.festival)
NIGHT_HEAD = "## Tonight"              # 0336 phase 0 heading
MORNING_HEAD = "## This Morning"       # 0336 phase 2 heading


# ---------------------------------------------------------------------------- reads
def probe(r, fid):
    """SNRom_Bridge.IEB_FestivalProbe -> dict (on, m, d, h, night, ctx, festMin, phys, scene, pday, inScene, child, orc,
    luc, tier, minT, excl) or None. scene/pday -99 = unset. Read-only on the Papyrus side."""
    t = tail("papyrus")
    res = rel(r, "IEB_FestivalProbe", [ah(fid)])
    v = retval(res)
    want = str(fid & 0xFFFFFFFF)
    if isinstance(v, str) and ("id=%s " % want) in v:
        return parse_kv(v)
    m = t.wait(r"(?i)\[IEB-FEST\] PROBE (id=%s .*)" % want, timeout=15)
    if not m:
        r.log("  probe %s: no [IEB-FEST] PROBE line (patched Relationships pex installed?)" % hx(fid))
        return None
    d = parse_kv(m.group(1))
    r.log("  probe %s: on=%s m=%s d=%s h=%s night=%s ctx=%s festMin=%s phys=%s scene=%s pday=%s inScene=%s"
          % (hx(fid), d.get("on"), d.get("m"), d.get("d"), d.get("h"), d.get("night"), d.get("ctx"), d.get("festMin"),
             d.get("phys"), d.get("scene"), d.get("pday"), d.get("inScene")))
    return d


def phys(p):
    return bool(p) and str(p.get("phys", "")).lower() == "true"


def gval(r, pu, name):
    v = rval(r, pu, 'get_global_value("%s")' % name)
    try:
        return float(v)
    except (TypeError, ValueError):
        return None


def set_global(r, pu, name, value):
    """RV-123 (3): one console write, read back natively before going on. True or INCONCLUSIVE + False."""
    con(r, "set %s to %s" % (name, value))
    got = gval(r, pu, name)
    if got is None or abs(got - float(value)) > 0.05:
        inc(r, "read-back set %s to %s: got %s" % (name, value, got))
        return False
    return True


def clock(r, pu, month, day, hour):
    """Month 0-based. Day before hour, so the hour write never lands on a stale day. Papyrus agrees (probe)."""
    if not (set_global(r, pu, "GameMonth", month) and set_global(r, pu, "GameDay", day) and set_global(r, pu, "GameHour", hour)):
        return False
    p = probe(r, PLAYER)
    if not p or iv(p, "m") != month or iv(p, "d") != day or abs(float(p.get("h", -1)) - hour) > 0.1:
        inc(r, "Papyrus read-back of the date: %s (want m=%d d=%d h=%s)" % (p and (p.get("m"), p.get("d"), p.get("h")), month, day, hour))
        return False
    return True


def su_write(r, fid, uuid, key, val):
    """SUSetInt + SUGetInt read-back (RV-123 (3))."""
    su_set(r, fid, key, val)
    got = su_get(r, uuid, key, -99, fid=fid)
    if got != val:
        inc(r, "read-back %s %s: %s, want %s" % (hx(fid), key, got, val))
        return False
    return True


def switch(r, pu, on):
    return su_write(r, PLAYER, pu, "IEB_FestivalEnabled", 1 if on else 0)


def scene_on(r, fid, uuid):
    if not ctl_line(r, "SceneOn", [fid], r"\[IEB-TEST\] SCENE (on partner=|refused child)"):
        inc(r, "SceneOn gave no line")
        return False
    if su_get(r, uuid, "IEB_IsScenePartner", 0, fid=fid) != 1:
        inc(r, "read-back SceneOn: %s IEB_IsScenePartner is not 1" % hx(fid))
        return False
    time.sleep(WATCH)
    return True


def scene_off(r, uuid, fid):
    ctl_line(r, "SceneOff", [], r"\[IEB-TEST\] SCENE off")
    ok = su_get(r, uuid, "IEB_IsScenePartner", -99, fid=fid) == -99
    if not ok:
        inc(r, "read-back SceneOff: %s still a scene partner" % hx(fid))
    time.sleep(WATCH)
    return ok


def casual_tier0(r, fid, label):
    """An enrolled ADULT made CASUAL (SNRom_PhysMinTier 2), exclusivity ACCEPTING (25), 0 points (Stranger), no banked
    points or attraction bypass, next to the player: the normal rule closes the gate (Friend needed), a festival night
    opens it from Stranger ("met that night", D3). Returns the uuid or None (INCONCLUSIVE)."""
    u, _, child = who(r, fid)
    if not u:
        inc(r, "%s not loaded" % label)
        return None
    if child is not False:
        inc(r, "%s: child=%s, refused (no romance state on a child)" % (label, child))
        return None
    k = rank(r, fid)
    if not k or iv(k, "tier") < 0:
        inc(r, "%s not enrolled in Relationships" % label)
        return None
    for key, val in (("SNRom_PhysMinTier", 2), ("SNRom_Exclusivity", 25), ("SNRom_BankedPoints", 0),
                     ("SNRom_PhysAttrBypass", 0)):
        if not su_write(r, fid, u, key, val):
            return None
    k = _set_pts(r, fid, 0)
    if not k or iv(k, "pts") != 0:
        inc(r, "read-back: %s points %s, want 0 (RV-123 (3))" % (label, k and k.get("pts")))
        return None
    con(r, "%08X.moveto player" % fid)
    if not near_player(r, fid, "%s moveto player" % label):
        return None
    return u


def setup(r, both=False):
    """Player uuid, F1 (and F2) prepared, switch ON, LUC_Active 0, witness events off. None on any failed read-back."""
    pu, _, _ = who(r, PLAYER)
    if not pu:
        inc(r, "player uuid unreadable")
        return None
    f1 = casual_tier0(r, F1, "F1")
    if not f1:
        return None
    f2 = casual_tier0(r, F2, "F2") if both else None
    if both and not f2:
        return None
    if su_get(r, pu, "LUC_Active", 0, fid=PLAYER) != 0:
        inc(r, "LUC_Active is set in T0: the orc rule would be live")
        return None
    if not switch(r, pu, True):
        return None
    if not set_global(r, pu, "IEB_WitnessEnabled", 0):     # no ieb_witness events while scenes toggle
        return None
    return pu, f1, f2


def festival_installed(r, pu):
    """Precondition: on Heart's Day 20:00 the probe sees night=116 (else festival_nights.json or the pex is missing)."""
    if not clock(r, pu, 1, 16, 20.0):
        return False
    p = probe(r, PLAYER)
    if not p or iv(p, "night") != HEARTS:
        inc(r, "Heart's Day 20:00 reads night=%s: festival_nights.json (shae.festival) or the patched pex not installed"
            % (p and p.get("night")))
        return False
    return True


# ---------------------------------------------------------------------------- tests
@test("FEST-0", "FEST", reload=True)
def fest0(r):
    """Calendar calibration (design 8, live 1): the native template reads of GameMonth/GameDay/GameHour equal the
    Papyrus reads (0x36/0x37/0x38) after console writes, and GameMonth is the 0-based value written (Sun's Dawn = 1)."""
    pu, _, _ = who(r, PLAYER)
    if not pu:
        return inc(r, "player uuid unreadable")
    checkpoint(r)
    if not clock(r, pu, 1, 16, 20.0):
        return
    r.check(True, "template and Papyrus agree on month 1 / day 16 / 20:00 (read-backs above)")
    p = probe(r, PLAYER)
    r.check(bool(p) and iv(p, "on") == 0, "switch default OFF in T0 (on=%s)" % (p and p.get("on")))


@test("FEST-1", "FEST", reload=True)
def fest1(r):
    """Window (D1/D2): F1 CASUAL/ACCEPTING at Stranger. Heart's Day 20:00 open ("met that night", festMin 0); the same
    day 12:00 closed; 03:00 next day open (after midnight = the previous day); 07:00 next day closed (no mark); an
    ordinary night (20 Sun's Dawn 20:00) closed."""
    s = setup(r)
    if not s:
        return
    pu, f1, _ = s
    if not festival_installed(r, pu):
        return
    checkpoint(r)
    p = probe(r, F1)
    r.check(phys(p) and iv(p, "festMin") == 0 and iv(p, "ctx") == HEARTS * 10,
            "16 Sun's Dawn 20:00: open from Stranger (phys=%s festMin=%s ctx=%s)" % (p and p.get("phys"), p and p.get("festMin"), p and p.get("ctx")))
    for (d, h, want, what) in ((16, 12.0, False, "16th 12:00 (festival day, not night)"),
                               (17, 3.0, True, "17th 03:00 (after midnight = Heart's Day night)"),
                               (17, 7.0, False, "17th 07:00 (night over, no morning-after mark)"),
                               (20, 20.0, False, "20th 20:00 (ordinary night)")):
        if not clock(r, pu, 1, d, h):
            return
        p = probe(r, F1)
        r.check(bool(p) and phys(p) == want, "%s: phys=%s, want %s" % (what, p and p.get("phys"), want))
    r.check(bool(p) and iv(p, "scene") == -99 and iv(p, "pday") == -99, "no scene, nothing written on F1 (scene=%s pday=%s)"
            % (p and p.get("scene"), p and p.get("pday")))


@test("FEST-2", "FEST", reload=True)
def fest2(r):
    """Rule 1: a scene that STARTS inside the window (17th 05:30) is judged festival at its start and keeps the gate
    open past 06:00 and past noon while it runs; F2 (not in a scene) is closed at 06:30. After SceneOff the flag is
    cleared and F1 is closed again (13:00, no festival)."""
    s = setup(r, both=True)
    if not s:
        return
    pu, f1, f2 = s
    if not festival_installed(r, pu) or not clock(r, pu, 1, 17, 5.5):
        return
    checkpoint(r)
    try:
        if not scene_on(r, F1, f1):
            return
        p = probe(r, F1)
        r.check(bool(p) and iv(p, "scene") == HEARTS and iv(p, "pday") % 10000 == HEARTS and iv(p, "inScene") == 1,
                "05:30 scene start judged festival (scene=%s pday=%s inScene=%s)" % (p and p.get("scene"), p and p.get("pday"), p and p.get("inScene")))
        if not clock(r, pu, 1, 17, 6.5):
            return
        time.sleep(WATCH)
        p, q = probe(r, F1), probe(r, F2)
        r.check(phys(p), "06:30, scene still running: F1 open (phys=%s ctx=%s)" % (p and p.get("phys"), p and p.get("ctx")))
        r.check(bool(q) and not phys(q), "06:30: F2, no scene and no mark, closed (phys=%s)" % (q and q.get("phys")))
        if not clock(r, pu, 1, 17, 13.0):
            return
        time.sleep(WATCH)
        p = probe(r, F1)
        r.check(phys(p) and iv(p, "ctx") == HEARTS * 10 + 1 and iv(p, "scene") == HEARTS,
                "13:00, scene still running: open, phase 1 'carried over' (phys=%s ctx=%s scene=%s)" % (p and p.get("phys"), p and p.get("ctx"), p and p.get("scene")))
        r.check(bool(p) and iv(p, "pday") == -99, "13:00: the morning-after mark lapsed at noon (pday=%s)" % (p and p.get("pday")))
    finally:
        off = scene_off(r, f1, F1)
    if off:
        p = probe(r, F1)
        r.check(bool(p) and iv(p, "scene") == -99 and not phys(p), "after SceneOff: flag cleared, closed (scene=%s phys=%s)"
                % (p and p.get("scene"), p and p.get("phys")))


@test("FEST-3", "FEST", reload=True)
def fest3(r):
    """Rule 1, the other direction: a scene that starts BEFORE the window (16th 17:30) is judged NOT festival (-1) and
    stays closed at 19:00 while it runs; F2 (no scene) is open at 19:00; after SceneOff F1 opens (festival night)."""
    s = setup(r, both=True)
    if not s:
        return
    pu, f1, f2 = s
    if not festival_installed(r, pu) or not clock(r, pu, 1, 16, 17.5):
        return
    checkpoint(r)
    try:
        if not scene_on(r, F1, f1):
            return
        p = probe(r, F1)
        r.check(bool(p) and iv(p, "scene") == -1 and iv(p, "pday") == -99, "17:30 start judged not festival (scene=%s pday=%s)"
                % (p and p.get("scene"), p and p.get("pday")))
        if not clock(r, pu, 1, 16, 19.0):
            return
        time.sleep(WATCH)
        p, q = probe(r, F1), probe(r, F2)
        r.check(bool(p) and not phys(p) and iv(p, "ctx") == 0, "19:00 in that scene: F1 stays closed (phys=%s ctx=%s)"
                % (p and p.get("phys"), p and p.get("ctx")))
        r.check(phys(q), "19:00: F2 (no scene) open (phys=%s)" % (q and q.get("phys")))
    finally:
        off = scene_off(r, f1, F1)
    if off:
        p = probe(r, F1)
        r.check(phys(p) and iv(p, "scene") == -99, "after SceneOff on the festival night: F1 open (phys=%s scene=%s)"
                % (p and p.get("phys"), p and p.get("scene")))


@test("FEST-4", "FEST", reload=True)
def fest4(r):
    """Rule 2: F1 shares a festival scene on Heart's Day 20:00 (pair marked). Next morning 07:00: F1 open (phase 2),
    F2 closed; a NEW scene with F2 is judged not festival, a new scene with F1 is judged festival. At 12:30 the mark is
    cleared and F1 is closed."""
    s = setup(r, both=True)
    if not s:
        return
    pu, f1, f2 = s
    if not festival_installed(r, pu):
        return
    checkpoint(r)
    if not scene_on(r, F1, f1):
        return
    p = probe(r, F1)
    marked = bool(p) and iv(p, "scene") == HEARTS and iv(p, "pday") % 10000 == HEARTS
    r.check(marked, "20:00 festival scene marks F1 (scene=%s pday=%s)" % (p and p.get("scene"), p and p.get("pday")))
    if not scene_off(r, f1, F1) or not clock(r, pu, 1, 17, 7.0):
        return
    time.sleep(WATCH)
    p, q = probe(r, F1), probe(r, F2)
    r.check(phys(p) and iv(p, "ctx") == HEARTS * 10 + 2, "07:00 morning after: F1 open, phase 2 (phys=%s ctx=%s)"
            % (p and p.get("phys"), p and p.get("ctx")))
    r.check(bool(q) and not phys(q) and iv(q, "ctx") == 0, "07:00: F2 (other NPC) closed (phys=%s ctx=%s)"
            % (q and q.get("phys"), q and q.get("ctx")))
    try:
        if scene_on(r, F2, f2):
            q = probe(r, F2)
            r.check(bool(q) and iv(q, "scene") == -1 and not phys(q) and iv(q, "pday") == -99,
                    "07:00 NEW scene with F2: judged not festival, closed, unmarked (scene=%s phys=%s pday=%s)"
                    % (q and q.get("scene"), q and q.get("phys"), q and q.get("pday")))
    finally:
        scene_off(r, f2, F2)
    if not clock(r, pu, 1, 17, 7.5):
        return
    try:
        if scene_on(r, F1, f1):
            p = probe(r, F1)
            r.check(phys(p) and iv(p, "scene") == HEARTS, "07:30 morning-after scene with F1: judged festival (scene=%s phys=%s)"
                    % (p and p.get("scene"), p and p.get("phys")))
    finally:
        scene_off(r, f1, F1)
    if not clock(r, pu, 1, 17, 12.5):
        return
    time.sleep(WATCH)
    p = probe(r, F1)
    r.check(bool(p) and iv(p, "pday") == -99 and not phys(p), "12:30: mark cleared at noon, F1 closed (pday=%s phys=%s)"
            % (p and p.get("pday"), p and p.get("phys")))


@test("FEST-5", "FEST", reload=True)
def fest5(r):
    """Switch off = no change: IEB_FestivalEnabled 0 on Heart's Day 20:00: F1 closed exactly as on an ordinary night,
    a scene writes nothing (no IEB_FestScene, no mark), the context reads 0."""
    s = setup(r)
    if not s:
        return
    pu, f1, _ = s
    if not festival_installed(r, pu):
        return
    if not switch(r, pu, False):
        return
    checkpoint(r)
    p = probe(r, F1)
    r.check(bool(p) and iv(p, "on") == 0 and iv(p, "ctx") == 0 and iv(p, "festMin") == -1 and not phys(p),
            "switch off, festival night: no festival (on=%s ctx=%s festMin=%s phys=%s)"
            % (p and p.get("on"), p and p.get("ctx"), p and p.get("festMin"), p and p.get("phys")))
    try:
        if scene_on(r, F1, f1):
            p = probe(r, F1)
            r.check(bool(p) and iv(p, "scene") == -99 and iv(p, "pday") == -99 and not phys(p),
                    "switch off, scene: nothing written, closed (scene=%s pday=%s phys=%s)"
                    % (p and p.get("scene"), p and p.get("pday"), p and p.get("phys")))
    finally:
        scene_off(r, f1, F1)
    a = su_get(r, pu, "IEB_FestivalAnnounced", -99, fid=PLAYER)
    r.check(a == -99, "switch off: no festival announcement latch on the player (%s)" % a)


@test("FEST-6", "FEST", reload=True)
def fest6(r):
    """Child (C1-C7 unchanged): on Heart's Day 20:00 with the switch ON, the child control reads festMin -1 and phys
    false; the SceneOn wrapper refuses the child (P2) and, after the watch interval, no festival key exists on the
    child. Reads and a refusing wrapper only; no romance key is written to a child."""
    pu, _, _ = who(r, PLAYER)
    cu, _, child = who(r, CHILD)
    if not pu or not cu:
        return inc(r, "player or child control not loaded")
    if child is not True:
        return inc(r, "child control 0x%s does not read IsChild" % hx(CHILD))
    if not switch(r, pu, True) or not festival_installed(r, pu):
        return
    checkpoint(r)
    p = probe(r, CHILD)
    r.check(bool(p) and iv(p, "child") == 1 and iv(p, "festMin") == -1 and not phys(p),
            "child, festival night: festMin -1, closed (child=%s festMin=%s phys=%s)" % (p and p.get("child"), p and p.get("festMin"), p and p.get("phys")))
    m = ctl_line(r, "SceneOn", [CHILD], r"\[IEB-TEST\] SCENE (on partner=|refused child)")
    r.check(bool(m) and "refused" in m.group(0), "SceneOn refuses the child (%s)" % (m and m.group(1)))
    time.sleep(WATCH)
    for key in ("IEB_FestScene", "IEB_FestivalPartnerDay", "IEB_IsScenePartner"):
        v = su_get(r, cu, key, -99, fid=CHILD)
        r.check(v == -99, "child: %s unset (%s)" % (key, v))
    rom = romance(r, cu)
    if rom is not None and rom.get("enrolled"):
        r.check(int(rom.get("festival", -1)) == -1, "child get_romance festival = -1 (%s)" % rom.get("festival"))


@test("FEST-7", "FEST", reload=True)
def fest7(r):
    """Orc rule (D7): Ghorza gra-Bagol (orc, never enrolled = below tier 2) on Heart's Day 20:00. Control with
    LUC_Active 0: the festival rule applies (festMin >= 0). With LUC_Active 1 (Lucienne's game): refused (festMin -1).
    The orc is only read; LUC_Active is unset again (read back) in a finally."""
    pu, _, _ = who(r, PLAYER)
    if not pu:
        return inc(r, "player uuid unreadable")
    if not switch(r, pu, True) or not festival_installed(r, pu):
        return
    p0 = probe(r, GHORZA)
    if not p0 or iv(p0, "orc") != 1 or iv(p0, "child") != 0:
        return inc(r, "0x%s does not read as an adult orc (orc=%s child=%s)" % (hx(GHORZA), p0 and p0.get("orc"), p0 and p0.get("child")))
    if iv(p0, "luc") != 0:
        return inc(r, "LUC_Active already set in T0")
    checkpoint(r)
    r.check(iv(p0, "festMin") >= 0, "LUC_Active 0: the orc gets the festival rule (festMin=%s)" % p0.get("festMin"))
    try:
        if not su_write(r, PLAYER, pu, "LUC_Active", 1):
            return
        p = probe(r, GHORZA)
        r.check(bool(p) and iv(p, "luc") == 1 and iv(p, "festMin") == -1 and not phys(p),
                "LUC_Active 1, orc below tier 2: refused (luc=%s tier=%s festMin=%s phys=%s)"
                % (p and p.get("luc"), p and p.get("tier"), p and p.get("festMin"), p and p.get("phys")))
        r.check(bool(p) and iv(p, "scene") == -99 and iv(p, "pday") == -99, "nothing written on the orc")
    finally:
        su_unset(r, PLAYER, "LUC_Active")
        if su_get(r, pu, "LUC_Active", 0, fid=PLAYER) != 0:
            inc(r, "read-back: LUC_Active not cleared (T0 reload follows)")


@test("FEST-8", "FEST", reload=True)
def fest8(r):
    """Templates live (verify-templates-live rule): F1's character_bio render carries the 0340 custom heading on
    Heart's Day (20:00 and 12:00, the day rule) and the 0336 'Tonight' heading at 20:00 only; neither on an ordinary
    night, neither for the child, neither with the switch off. Headings of our own layer only; text never logged.
    0336 rides on get_romance (cached decorator): a missing heading after 3 tries with festKey unread is INCONCLUSIVE."""
    s = setup(r)
    if not s:
        return
    pu, f1, _ = s
    cu, _, child = who(r, CHILD)
    if not festival_installed(r, pu):
        return
    checkpoint(r)

    def bio(uuid):
        for _ in range(3):
            out = render(r, uuid, '{{ render_subcomponent("character_bio", "full") }}{# %d #}' % time.time_ns())
            if out:
                return out
            time.sleep(2)
        return None

    def heads(uuid):
        b = bio(uuid)
        return None if b is None else (CUSTOM_HEAD in b, NIGHT_HEAD in b, MORNING_HEAD in b)

    for (d, h, want_c, want_n, what) in ((16, 20.0, True, True, "Heart's Day 20:00"), (16, 12.0, True, False, "Heart's Day 12:00"),
                                        (20, 20.0, False, False, "20 Sun's Dawn 20:00")):
        if not clock(r, pu, 1, d, h):
            return
        hs = heads(f1)
        if hs is None:
            inc(r, "%s: character_bio render failed" % what)
            continue
        r.check(hs[0] == want_c, "%s: 0340 custom heading %s (want %s)" % (what, hs[0], want_c))
        if hs[1] != want_n and want_n:
            rom = romance(r, f1)
            if rom is None or "festKey" not in rom:
                inc(r, "%s: 0336 heading absent and get_romance unread (cache miss / old pex)" % what)
                continue
        r.check(hs[1] == want_n, "%s: 0336 'Tonight' heading %s (want %s)" % (what, hs[1], want_n))
    if cu and child is True and clock(r, pu, 1, 16, 20.0):
        hs = heads(cu)
        r.check(hs is not None and not hs[0] and not hs[1] and not hs[2], "child, Heart's Day 20:00: no festival heading (%s)" % (hs,))
    if switch(r, pu, False):
        hs = heads(f1)
        r.check(hs is not None and not any(hs), "switch off: no festival heading for F1 (%s)" % (hs,))


@test("FEST-9", "FEST", reload=True)
def fest9(r):
    """GameMaster event (D9): on Heart's Day 19:00 the fast assessment tick (0.5-2 game hours) latches
    IEB_FestivalAnnounced on the player = the night's stamp (one persistent event per night). Waits up to 8 real
    minutes; a second tick does not re-latch a different value."""
    pu, _, _ = who(r, PLAYER)
    if not pu:
        return inc(r, "player uuid unreadable")
    if not switch(r, pu, True) or not festival_installed(r, pu) or not clock(r, pu, 1, 16, 19.0):
        return
    checkpoint(r)
    deadline, a = time.time() + 480, -99
    while time.time() < deadline:
        a = su_get(r, pu, "IEB_FestivalAnnounced", -99, fid=PLAYER)
        if a is not None and a > 0:
            break
        time.sleep(20)
    r.check(a is not None and a % 10000 == HEARTS, "IEB_FestivalAnnounced latched to the Heart's Day stamp (%s)" % a)
