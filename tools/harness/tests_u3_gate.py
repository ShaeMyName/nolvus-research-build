"""U3M add-on: the RV-98 marriage gate (REVIEW_LOG RV-98 / RV-109, Shae "A both ways": prevent + backstop + amulet gate).
Patched SNRom_Bridge.psc: MaintainProposalGate (M3 joins the keyword gate; IEB_AmuletGate), OnMarasStatusChanged's
ENGAGED branch -> IEB_BackToCandidate (apply_patch_f.py group rv98). Written 2026-10-11, not yet run.

Cast: F1 (T0-M's single control, an adult enrolled companion; t0m_builder.md:16), and tests_u3.T0M["engaged"] as the
OTHER engaged partner whose MARAS state must not be touched by the backstop (ResetMarriageQuests skips an NPC that is not
the marriage quest's LoveInterest, TTM_ServiceMarriageQuest.psc:49-56). Every test reloads T0-M.
Counts, FormIDs and flags only (IEB_TestCtl.GateProbe); snrom.log lines are matched by fixed phrases, never printed.
Child safety: every test refuses an actor whose probe says child=1 before any write.
The paused-chat slip (AI eligibility fails open while paused, SNRom_Bridge.psc MaintainProposalGate doc) needs a live
AI acceptance: not automated here; GATE-2/GATE-3 drive the same OnMarasStatusChanged path the slip ends in."""
import re, time
from block import test, checkpoint
from tests_misc import F1, FRALIA, con, ctl_line, inc, s32, rank, iv, tail, su_set, parse_kv, fid_any_rx, _set_pts
from tests_u3 import T0M, cast, maras_probe, maras_promote, status_is

CONSUMING_MIN = 88      # SNRom_Bridge.psc CONSUMING_MIN() (Return 88)
SPOUSE_MIN = 2500       # SNRom_Bridge.psc SPOUSE_MIN()


def gate(r, fid):
    """IEB_TestCtl.GateProbe -> dict(st, pts, kw, pmf, pmfRm, excl, other, child) or None."""
    m = ctl_line(r, "GateProbe", [s32(fid)], r"(?i)\[IEB-TEST\] GATE (%s) (.*)" % fid_any_rx(fid), 15)
    return parse_kv(m.group(2)) if m else None


def _adult_enrolled(r, fid, label):
    g = gate(r, fid)
    if not g:
        inc(r, "%s: no GATE line (is the new IEB_TestCtl pex installed?)" % label)
        return None
    if iv(g, "child") != 0:
        inc(r, "%s: child=1, refused (no romance state on a child)" % label)
        return None
    if iv(rank(r, fid) or {}, "tier") < 0:
        inc(r, "%s: not enrolled in Relationships" % label)
        return None
    return g


def _candidate(r, fid):
    mp = maras_probe(r, fid)
    if mp and iv(mp, "st", -1) < 0:
        mp = maras_promote(r, fid, "candidate")
    return mp if mp and status_is(mp, "candidate") else None


def _pts(r, fid, target):
    """Points to `target` through ApplyDepth (-> Ledger -> MaintainProposalGate). A no-op delta does not run the
    ledger, so a value already at target is nudged by 1 first."""
    k = rank(r, fid)
    if k and iv(k, "pts") == target:
        _set_pts(r, fid, target + 1)
    _set_pts(r, fid, target)
    time.sleep(2)
    return gate(r, fid)


@test("GATE-1", "GATE", save="T0-M", reload=True)
def gate1(r):
    """Amulet path (RV-98 (a)): below SPOUSE_MIN the NPC leaves PotentialMarriageFaction (Skyrim.esm 0x19809, what the
    vanilla Amulet-of-Mara proposal INFOs require) with IEB_PMFRemoved=1 and the TTM_IgnoreProposal keyword; at or above
    it the membership comes back, the marker is unset and the keyword goes. Pass: both halves."""
    if not _adult_enrolled(r, F1, "F1"):
        return
    if not _candidate(r, F1):
        return inc(r, "F1 could not be made a MARAS candidate")
    checkpoint(r)
    t = tail("snrom")
    lo = _pts(r, F1, 1100)
    r.check(bool(lo) and iv(lo, "kw") == 1, "below %d: TTM_IgnoreProposal on the ref (kw=%s)" % (SPOUSE_MIN, lo and lo.get("kw")))
    r.check(bool(lo) and iv(lo, "pmf") == -2, "below: out of PotentialMarriageFaction (pmf=%s)" % (lo and lo.get("pmf")))
    r.check(bool(lo) and iv(lo, "pmfRm") == 1, "below: IEB_PMFRemoved=1 (%s)" % (lo and lo.get("pmfRm")))
    hi = _pts(r, F1, SPOUSE_MIN + 100)
    r.check(bool(hi) and iv(hi, "kw") == 0, "at/above %d: keyword removed (kw=%s)" % (SPOUSE_MIN, hi and hi.get("kw")))
    r.check(bool(hi) and iv(hi, "pmf") >= 0, "above: back in PotentialMarriageFaction (pmf=%s)" % (hi and hi.get("pmf")))
    r.check(bool(hi) and iv(hi, "pmfRm") == 0, "above: IEB_PMFRemoved unset (%s)" % (hi and hi.get("pmfRm")))
    txt = t.read()
    r.check("Amulet gate closed for" in txt and "Amulet gate OPEN for" in txt, "snrom.log: one closed + one OPEN line")


AMULET = 0x000C891B     # Skyrim.esm Amulet of Mara (the proposal INFOs' GetEquipped, run on the player)


@test("GATE-1b", "GATE", save="T0-M", reload=True)
def gate1b(r):
    """RV-117: a NEVER-enrolled marriageable adult (Fralia, given PotentialMarriageFaction at rank 1 by console - an
    adult only, T0-M reloads after) is taken out of the faction while the player WEARS the amulet (SNRom_PlayerAlias
    watch -> IEB_AmuletSweep), and put back AT RANK 1 (not AddToFaction's 0) when it comes off."""
    g0 = gate(r, FRALIA)
    if not g0:
        return inc(r, "Fralia: no GATE line")
    if iv(g0, "child") != 0:
        return inc(r, "Fralia: child=1, refused")
    if iv(rank(r, FRALIA) or {}, "tier") >= 0:
        return inc(r, "Fralia is enrolled in T0-M; this test needs a never-enrolled actor")
    con(r, "%08X.moveto player" % FRALIA)
    con(r, "%08X.addfac 00019809 1" % FRALIA)
    time.sleep(3)
    g1 = gate(r, FRALIA)
    if not g1 or iv(g1, "pmf") != 1:
        return inc(r, "setup: Fralia not in PotentialMarriageFaction at rank 1 (pmf=%s)" % (g1 and g1.get("pmf")))
    checkpoint(r)
    t = tail("snrom")
    con(r, "player.additem %08X 1" % AMULET)
    con(r, "player.equipitem %08X" % AMULET)
    time.sleep(8)
    on = gate(r, FRALIA)
    r.check(bool(on) and iv(on, "pmf") == -2 and iv(on, "pmfRm") == 1,
            "amulet worn: never-enrolled Fralia out of PotentialMarriageFaction (pmf=%s pmfRm=%s)"
            % (on and on.get("pmf"), on and on.get("pmfRm")))
    con(r, "player.unequipitem %08X" % AMULET)
    time.sleep(5)
    off = gate(r, FRALIA)
    r.check(bool(off) and iv(off, "pmf") == 1, "amulet off: back in the faction AT RANK 1 (pmf=%s)" % (off and off.get("pmf")))
    r.check(bool(off) and iv(off, "pmfRm") == 0, "amulet off: IEB_PMFRemoved cleared (%s)" % (off and off.get("pmfRm")))
    txt = t.read()
    r.check("restored at rank 1" in txt, "snrom.log: 'restored at rank 1'")


def veng(r, fid):
    """IEB_TestCtl.VengProbe -> dict(rmStage, rmRun, li, wedRun, asked, maras) or None."""
    m = ctl_line(r, "VengProbe", [s32(fid)], r"(?i)\[IEB-TEST\] VENGPROBE (%s) (.*)" % fid_any_rx(fid), 15)
    return parse_kv(m.group(2)) if m else None


@test("GATE-4", "GATE", save="T0-M", reload=True)
def gate4(r):
    """RV-119 (2), patch c2: an engagement MARAS did not make (TestCtl.VanillaEngage = what a proposal INFO fragment
    does: MarriageAskedFaction, RelationshipMarriage LoveInterest, SetStage 20) on a never-enrolled adult (Fralia) is
    UNDONE: 'Vanilla-path engagement UNDONE' in snrom.log, RelationshipMarriage back below 20 with no LoveInterest,
    Fralia out of MarriageAskedFaction, MARAS status untouched. Then the SAME again, to confirm the stage event fires on a
    repeated SetStage(20) (quest DNAM 0x19, INFERRED allow-repeated-stages)."""
    g0 = gate(r, FRALIA)
    if not g0:
        return inc(r, "Fralia: no GATE line")
    if iv(g0, "child") != 0:
        return inc(r, "Fralia: child=1, refused")
    if iv(rank(r, FRALIA) or {}, "tier") >= 0:
        return inc(r, "Fralia is enrolled in T0-M; this test needs a never-enrolled actor")
    v0 = veng(r, FRALIA)
    if not v0:
        return inc(r, "no VENGPROBE line (new IEB_TestCtl installed?)")
    if iv(v0, "rmStage") >= 20:
        return inc(r, "RelationshipMarriage already at stage %s in T0-M" % v0.get("rmStage"))
    m0 = v0.get("maras")
    checkpoint(r)
    for n in (1, 2):
        t = tail("snrom")
        ctl_line(r, "VanillaEngage", [s32(FRALIA)], r"(?i)\[IEB-TEST\] VENG \S+ set", 15)
        deadline, txt = time.time() + 30, ""
        while time.time() < deadline and "Vanilla-path engagement UNDONE for" not in txt:
            time.sleep(2)
            txt += t.read()
        r.check("Vanilla-path engagement UNDONE for" in txt, "round %d: snrom.log 'Vanilla-path engagement UNDONE'" % n)
        time.sleep(2)
        v = veng(r, FRALIA)
        r.check(bool(v) and iv(v, "rmStage") < 20, "round %d: RelationshipMarriage back below 20 (stage %s)"
                % (n, v and v.get("rmStage")))
        r.check(bool(v) and v.get("li") in ("None", "none", "0x00000000", None) or (v and "none" in str(v.get("li")).lower()),
                "round %d: no LoveInterest (li=%s)" % (n, v and v.get("li")))
        r.check(bool(v) and iv(v, "asked") == -2, "round %d: out of MarriageAskedFaction (asked=%s)" % (n, v and v.get("asked")))
        r.check(bool(v) and v.get("maras") == m0, "round %d: MARAS status untouched (%s -> %s)" % (n, m0, v and v.get("maras")))


def _backstop(r, why, setup):
    """Shared GATE-2/3 body: F1 a candidate set up by `setup`, the other engaged partner checked before/after, then
    MARAS promotes F1 to engaged (TestCtl.MarasSet, the native the dialogue/AI paths call) and the backstop must put F1
    back to candidate with an INFO line, leaving the other engagement alone."""
    if not _adult_enrolled(r, F1, "F1"):
        return
    other = cast(r, "engaged")
    if other is None:
        return
    om = maras_probe(r, other)
    if not om or not status_is(om, "engaged"):
        return inc(r, "T0-M's engaged partner is not engaged (%s)" % (om and om.get("st")))
    if not _candidate(r, F1):
        return inc(r, "F1 could not be made a MARAS candidate")
    if not setup():
        return
    checkpoint(r)
    t = tail("snrom")
    maras_promote(r, F1, "engaged")
    deadline, txt = time.time() + 60, ""
    while time.time() < deadline:
        txt += t.read()
        if "Engagement backstop (%s)" % why in txt:
            break
        time.sleep(3)
    hit = re.search(r"Engagement backstop \(%s\)(?::| FAILED| skipped)" % why, txt)
    if not hit:
        try:
            import sn_harness as SH
            ui = SH.ui_state()
        except Exception as e:
            ui = type(e).__name__
        return inc(r, "no 'Engagement backstop (%s)' line in 60 s (a MARAS box open pauses Utility.Wait? ui=%s)"
                   % (why, ui if isinstance(ui, str) else "see ui-state"))
    r.check("Engagement backstop (%s) FAILED" % why not in txt, "backstop did not log FAILED")
    r.check("re-registered as candidate" in txt, "backstop INFO: re-registered as candidate")
    g = gate(r, F1)
    r.check(bool(g) and iv(g, "st") == 0, "F1 MARAS status candidate after (st=%s)" % (g and g.get("st")))
    om2 = maras_probe(r, other)
    r.check(bool(om2) and status_is(om2, "engaged"), "the other engaged partner is still engaged (st=%s)"
            % (om2 and om2.get("st")))


@test("GATE-2", "GATE", save="T0-M", reload=True)
def gate2(r):
    """Backstop on points (RV-98 (b')): F1 below SPOUSE_MIN engaged by MARAS -> UnregisterNPC, ResetMarriageQuests,
    RegisterCandidate -> candidate; T0-M's other engaged partner untouched."""
    def setup():
        g = _pts(r, F1, 1100)
        if not g or iv(g, "pts") >= SPOUSE_MIN:
            inc(r, "setup: F1 points not below %d (%s)" % (SPOUSE_MIN, g and g.get("pts")))
            return False
        return True
    _backstop(r, "points", setup)


@test("GATE-3", "GATE", save="T0-M", reload=True)
def gate3(r):
    """Backstop on exclusivity (RV-98 (a)+(b')): F1 at/above SPOUSE_MIN with SNRom_Exclusivity >= CONSUMING_MIN and
    other partners (T0-M's spouses): the gate stays CLOSED (M3 joins it), and a MARAS engagement is reverted with the
    'exclusivity' reason."""
    def setup():
        if not su_set(r, F1, "SNRom_Exclusivity", CONSUMING_MIN + 5):
            inc(r, "setup: SNRom_Exclusivity write refused")
            return False
        g = _pts(r, F1, SPOUSE_MIN + 100)
        if not g or iv(g, "other") < 1:
            inc(r, "setup: OtherPartners(F1) is %s, need >= 1 (T0-M spouses not counted yet?)" % (g and g.get("other")))
            return False
        r.check(iv(g, "kw") == 1, "M3: gate stays closed at %s pts with exclusivity %s and %s other partner(s) (kw=%s)"
                % (g.get("pts"), g.get("excl"), g.get("other"), g.get("kw")))
        return True
    _backstop(r, "exclusivity", setup)
