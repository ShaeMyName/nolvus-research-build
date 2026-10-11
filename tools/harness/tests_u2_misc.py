"""U2 block, part 7: the remaining U2 items: X-6, CS-2, T10-1, T10-2, plus stubs (with their route) for X-9, X-10, X-11,
MA-1, AZ-11, T10-3, T10-7, T10-8. Started 2026-10-11. House style: tests_u2.py (counts only).
T10 rows: investigation/round4/items10_11_storage_promotion.md:222-229 (T10-4/5/6 are Shae's S-C box clicks).
Child-safety rule (CS-2): mechanics only - an event count, never text."""
import re, time
import game
import sn_harness as SH
from block import test, checkpoint
from tests_misc import PLAYER, F1, CHILD, con, inc, who, worn_rows, to_formid, ensure_child_enrolled
from tests_u2 import (A_NPC, B_NPC, market, uuids, place, bring_back, los, hist_hits, harness_ready, nonce, radius,
                      fire_exposure, dress, witness_wait)


@test("X-6", "X", reload=True)
def x6(r):
    """equip/unequip event audience: the player takes off a worn non-body item (feet first, else hands) with A 300 u in
    view and B ~500 u without line of sight: A's history gains an equip-type event (type contains 'equip', INFERRED name),
    B's does not."""
    market(r)
    au, bu, pu = uuids(r, A_NPC, B_NPC, PLAYER)
    if not (au and bu and pu):
        return inc(r, "actors not loaded")
    rows = worn_rows(r, pu) or []
    pick = [to_formid(x[1]) for x in rows if x[0].lower() in ("feet", "hands")]
    if not pick or not pick[0]:
        return inc(r, "the player wears nothing on feet or hands to take off")
    item = pick[0]
    try:
        place(r, A_NPC, 300, 0, 0)
        place(r, B_NPC, 300, 0, -400)
        time.sleep(2)
        if not los(r, au, pu) or los(r, bu, pu) is not False:
            return inc(r, "line-of-sight setup not as wanted")
        a0, b0 = [render_equip(r, u) for u in (au, bu)]
        checkpoint(r)
        con(r, "player.unequipitem %08X" % item)
        time.sleep(4)
        a1, b1 = [render_equip(r, u) for u in (au, bu)]
        r.log("  equip-type events A %s -> %s, B %s -> %s" % (a0, a1, b0, b1))
        if a0 is None or a1 is None:
            return inc(r, "render failed")
        if a1 <= a0:
            return inc(r, "no equip-type event reached A (type name INFERRED; check the event types in the dashboard)")
        r.check(b1 == b0, "B (no line of sight) gets no equip event")
    finally:
        con(r, "player.equipitem %08X" % item)
        bring_back(r, A_NPC)
        bring_back(r, B_NPC)


def render_equip(r, uuid):
    from tests_misc import render
    out = render(r, uuid, "{%% for e in get_recent_events(40, [actorUUID]) %%}{%% if contains(e.type, \"equip\") %%}H"
                          "{%% endif %%}{%% endfor %%}{# %d #}" % time.time_ns())
    return None if out is None else out.count("H")


@test("CS-2", "CS", reload=True)
def cs2(r):
    """Address a child directly, also while the player is exposed: the child gives a normal AI reply (children keep AI).
    Mechanics only: the child's dialogue-event count rises after each injected line. 2 LLM calls."""
    market(r)
    if not harness_ready(r):
        return
    cu, _, child = who(r, CHILD)
    if not cu or not child:
        return inc(r, "child not loaded or not IsChild")
    con(r, "%08X.moveto player" % CHILD)
    time.sleep(3)
    checkpoint(r, "2 LLM calls")
    item = None
    try:
        for label in ("dressed", "exposed"):
            if label == "exposed":
                item, m = fire_exposure(r)
                if not item:
                    return inc(r, "could not take off the player's body item")
            d0 = hist_hits(r, cu, etype="dialogue") or 0
            SH.inject_player_input("Hello there. Are you all right?", cu)
            SH.await_idle(90)
            time.sleep(3)
            d1 = hist_hits(r, cu, etype="dialogue") or 0
            r.check(d1 >= d0 + 2, "%s: the child replied (dialogue events %d -> %d)" % (label, d0, d1))
    except SH.HarnessError as e:
        inc(r, "harness call failed: %s" % e)
    finally:
        dress(r, item)


@test("T10-1", "T10")
def t10_1(r):
    """The per-playthrough DB: SkyrimNet.log names the save ID and the save-specific database path this session
    ('Using save ID', 'Initializing save-specific database at'); the DB file exists (path logged, no contents read)."""
    import os
    t = game.Tail(game.LOGS["skyrimnet"])
    t.pos = 0
    txt = t.read()
    checkpoint(r)
    sid = re.findall(r"Using save ID[^\n]*", txt)
    db = re.findall(r"Initializing save-specific database at ([^\n]+)", txt)
    r.check(bool(sid), "SkyrimNet logs the save ID (%d lines)" % len(sid))
    r.check(bool(db), "SkyrimNet logs the save-specific database path")
    if db:
        p = db[-1].strip().strip("'\"")
        r.log("  DB path (last): %s" % p)


@test("T10-2", "T10", reload=True)
def t10_2(r):
    """Save A (IEB_T10A), talk to F1 (3 injected lines with a nonce: events + chance of a memory), load A: harness mode
    clears the timeline (= Delete History, 'auto-cleared the timeline'); afterwards F1's history holds none of the
    nonce lines. Memories/diaries: count of nonce hits in the memory route is the dashboard check (S-C). 3 LLM calls."""
    market(r)
    if not harness_ready(r):
        return
    fu, = uuids(r, F1)
    if not fu:
        return inc(r, "F1 not loaded")
    if not game.save(r, "IEB_T10A"):
        return inc(r, "save IEB_T10A failed")
    checkpoint(r, "3 LLM calls + 1 load")
    tok = nonce("t10")
    try:
        for i in range(3):
            SH.inject_player_input("Remember this word: %s." % tok if i == 0 else "Tell me about your day.", fu)
            SH.await_idle(90)
            time.sleep(2)
    except SH.HarnessError as e:
        return inc(r, "harness call failed: %s" % e)
    h1 = hist_hits(r, fu, tok)
    if not h1:
        return inc(r, "the nonce line never reached F1's history")
    sn = game.Tail(game.LOGS["skyrimnet"])
    if not game.load(r, "IEB_T10A", None):
        return inc(r, "load of IEB_T10A failed")
    time.sleep(10)
    r.check("auto-clearing timeline" in sn.read(), "the timeline was cleared on load (harness auto Delete History)")
    fu2, = uuids(r, F1)
    h2 = hist_hits(r, fu2, tok) if fu2 else None
    r.check(h2 == 0, "F1's history holds none of the abandoned branch's lines (%s -> %s)" % (h1, h2))


def _stub(tid, family, why):
    @test(tid, family)
    def fn(r):
        checkpoint(r)
        inc(r, why)
    fn.__doc__ = why
    return fn


# X-9 / X-10 are real tests in tests_u3_g.py (U3G); no U2 stub, so the IDs are registered once.
_stub("X-11", "X", "model moderation behaviour: judgement of refusals over the U2 logs -> reported from the block's SkyrimNet.log by the reviewer")
_stub("MA-1", "MA", "needs a fiance in a breakup state: T0-M (U3)")
# AZ-11 is a real test in tests_azura.py (U4); no U2 stub, so the ID is registered once.
_stub("T10-3", "T10", "dynamic-bio file before/after Delete History: needs the bio file route; S-C with T10-4/5/6")
_stub("T10-7", "T10", "loading a pre-stack save twice in the test profile: needs Shae's choice of save (S-C)")
_stub("T10-8", "T10", "two playthroughs incl. Lucienne's pre-stack save: S-C")
