"""U2 block, part 7: the remaining U2 items: X-6, CS-2, T10-1, T10-2, plus stubs (with their route) for X-9, X-10, X-11,
MA-1, AZ-11, T10-3, T10-7, T10-8. Started 2026-10-11. House style: tests_u2.py (counts only).
T10 rows: investigation/round4/items10_11_storage_promotion.md:222-229 (T10-4/5/6 are Shae's S-C box clicks).
Child-safety rule (CS-2): mechanics only - an event count, never text."""
import re, time
import game
import sn_harness as SH
from block import test, checkpoint
from tests_misc import PLAYER, F1, CHILD, con, inc, who, worn_rows, to_formid, ensure_child_enrolled, near_player
from tests_u2 import (A_NPC, B_NPC, C_NPC, market, uuids, place, bring_back, los, hist_hits, harness_ready, nonce, radius,
                      fire_exposure, dress, witness_wait)


# X-6 (REVIEW_LOG RV-160 (2)). The equip/unequip event DOES exist, under the type id 'equip', but the old assertion could never pass:
#  - VERIFIED live (SkyrimNet.log, test_runs/CRASH_repro_20261011-071807/raw/074232_R1_SkyrimNet.log): "EventSchemaRegistry:
#    Registered schema for event type 'equip'" (07:18:35, EventSchemaRegistry.cpp:35); per equip "[EquipEventHandler.cpp:65] Equip event:
#    '<name>' equipped|unequipped '<item>'" (info), and "SceneContextBuilder: Registered short-lived event 'actor_equip_..' of type 'equip'
#    with TTL 45000ms" (debug, SceneContextBuilder.cpp:335, :5537 of that file). The id is a short string kept inline in the DLL, which is
#    why the strings dump has no 'equip' line; the dump has the handler (:55158-55171), the schema title 'Equipment change' (:56845) and
#    the field list (item, action, item_id, item_editor_id).
#  - But the test profile sets it ephemeral: SkyrimNet Config - Test/.../config/Events.yaml:106-114 (event_type: equip, persistent: false,
#    shortLivedEnabled: true, allowNPCReaction: false). An ephemeral event is NOT stored in the database, so it is never in
#    get_recent_events (the old render_equip counted that list), and it is a scene-wide short-lived event (component_recent_events.prompt
#    reads scene.short_lived_events; one list for the scene, not one per observer).
#  - The handler's only skip reasons in the DLL strings are "Actor '{}' is too far away" and "not 3D loaded" (:55170-55171, seen live in the
#    same log, debug): a distance gate, no line-of-sight gate (INFERRED from the absence of any other skip string).
#  - Whether the PLAYER's own equips raise the event is unobserved (the logs hold NPC lines only), so the equipper here is an NPC.
# So the spec intent "audience: near, and behind a wall" is tested as what can be observed: an NPC unequips one worn non-body item at
# A (300 u, in view), at B (~500 u behind terrain) and at C (live radius + 400 u). Observable per case: the handler's log line,
# the short-lived 'equip' event in the scene render (get_short_lived_events_by_type, DLL strings :43670-43680), and the history (must stay
# empty: ephemeral). The wall cannot be a pass/fail case (no such gate), so B is a RECORD.
def short_equip(r, uuid):
    """Scene-wide count of live short-lived events of type 'equip' (decorator name and array result VERIFIED as DLL strings :43670-43680;
    first live render). None if the render failed."""
    from tests_misc import rval
    v = rval(r, uuid, 'length(get_short_lived_events_by_type("equip"))')
    try:
        return int(v)
    except (TypeError, ValueError):
        return None


def npc_item(r, uuid):
    """FormID of one worn non-body, non-weapon item of the NPC (feet/hands first), or None."""
    rows = worn_rows(r, uuid) or []
    ok = [x for x in rows if x[0].lower() != "torso" and not x[0].lower().startswith(("right", "left"))]
    pick = [x for x in ok if x[0].lower() in ("feet", "hands")] or ok
    return to_formid(pick[0][1]) if pick and pick[0][1] else None


def unequip_watch(r, fid, name, item):
    """NPC.unequipitem (console, target_form_id: RV-123), then the handler's log line for that NPC within 10 s.
    ('processed' | 'too_far' | 'not_3d' | None, log text since the unequip)."""
    t = game.Tail(game.LOGS["skyrimnet"])
    con(r, "%08X.unequipitem %08X" % (fid, item))
    nm = re.escape(name)
    m = t.wait(r"Equip event: '%s' unequipped|Equip event: Actor '%s' is too far away|Equip event: Actor '%s' is not 3D loaded" % (nm, nm, nm), 10)
    time.sleep(1)
    txt = t.read()
    if not m:
        return None, txt
    return ("processed" if "unequipped" in m.group(0) else "too_far" if "too far" in m.group(0) else "not_3d"), txt


@test("X-6", "X", reload=True)
def x6(r):
    """'equip' event audience (see the comment block above for what is VERIFIED). An NPC takes off one worn non-body item at A (300 u, in
    view), B (~500 u, no line of sight) and C (live radius + 400 u, in view); each item is put back in finally.
    A: PASS = SkyrimNet logs the handler's 'Equip event: <A> unequipped'; the short-lived 'equip' count in the scene render rises by >= 1;
    no 'equip' row appears in A's or B's history (ephemeral per Events.yaml). B: RECORD only (no line-of-sight gate exists to assert).
    C: PASS = the handler logs 'is too far away' and registers no short-lived event; a processed C is INCONCLUSIVE (the distance gate is
    wider than the live radius + 400; recorded). No LLM calls."""
    import tests_u2
    if not market(r):
        return
    au, bu, cu, pu = uuids(r, A_NPC, B_NPC, C_NPC, PLAYER)
    if not (au and bu and cu and pu):
        return inc(r, "actors not loaded")
    names = {k: who(r, f)[1] for k, f in (("A", A_NPC), ("B", B_NPC), ("C", C_NPC))}
    if not all(names.values()):
        return inc(r, "an NPC display name is unknown (UUIDOf): the handler's log line is matched by name")
    cases = [("A", A_NPC, au, (300, 0, 0)), ("B", B_NPC, bu, (300, 0, -400)), ("C", C_NPC, cu, (tests_u2.far(r), 0, 0))]
    items, placed, off = {}, [], []
    try:
        for key, fid, u, off_xyz in cases:
            if not place(r, fid, *off_xyz):                 # RV-123 (3): place() reads the distance back
                return
            placed.append(fid)
        time.sleep(2)
        if not los(r, au, pu):
            return inc(r, "A was placed without line of sight")
        if los(r, bu, pu) is not False:
            return inc(r, "B's line-of-sight setup is not as wanted (still in view)")
        for key, fid, u, off_xyz in cases:
            items[key] = npc_item(r, u)
            if not items[key]:
                return inc(r, "%s wears no non-body item to take off (worn_rows slot keys INFERRED; the player-side 'feet'/'hands' guess is TP-07)" % key)
        hist0 = {k: hist_hits(r, u, etype="equip") for k, _, u, _ in cases[:2]}
        sl0 = short_equip(r, au)
        checkpoint(r)
        out = {}
        for key, fid, u, off_xyz in cases:
            off.append((fid, items[key]))
            kind, txt = unequip_watch(r, fid, names[key], items[key])
            wr = worn_rows(r, u)                             # RV-123 (3): the item is off
            gone = wr is not None and items[key] not in [to_formid(x[1]) for x in wr]
            slv = short_equip(r, au)
            out[key] = dict(kind=kind, gone=gone, sl=slv, sl0=sl0,
                            reg=bool(re.search(r"Registered short-lived event '[^']*' of type 'equip'", txt)))
            r.log("  equip event %s (%d u): handler %s, item off %s, short-lived 'equip' count %s -> %s, registration line %s (counts only)"
                  % (key, int(sum(c * c for c in off_xyz) ** 0.5), kind, gone, sl0, slv, out[key]["reg"]))
            sl0 = slv
        a, b, c = out["A"], out["B"], out["C"]
        if not a["gone"]:
            return inc(r, "A: unequipitem read-back: the item is still worn")
        if a["kind"] is None:
            inc(r, "A: no 'Equip event' line within 10 s (name as UUIDOf prints it, or the info line is not logged)")
        else:
            r.check(a["kind"] == "processed", "A (300 u, in view): the handler processed the NPC's unequip (%s)" % a["kind"])
        if a["sl"] is None or a["sl0"] is None:
            inc(r, "A: the short-lived events render failed (get_short_lived_events_by_type; first live use)")
        else:
            r.check(a["sl"] >= a["sl0"] + 1, "A: the scene render counts a new short-lived 'equip' event (%s -> %s)" % (a["sl0"], a["sl"]))
        for k, u in (("A", au), ("B", bu)):
            h1 = hist_hits(r, u, etype="equip")
            r.check(h1 is not None and h1 == hist0[k], "%s: no 'equip' row in the history (ephemeral: Events.yaml equip persistent false) (%s -> %s)" % (k, hist0[k], h1))
        r.log("  RECORD B (~500 u, no line of sight): handler %s, registration line %s (no line-of-sight gate in the handler strings: INFERRED)"
              % (b["kind"], b["reg"]))
        if c["kind"] == "too_far":
            r.check(not c["reg"], "C (radius + 400 u): the handler skipped it ('is too far away') and registered no short-lived event")
        elif c["kind"] is None:
            inc(r, "C: no 'Equip event' line within 10 s")
        else:
            inc(r, "C at live radius + 400 u was %s: the handler's distance gate is wider than the live radius (RECORD)" % c["kind"])
    finally:
        for fid, item in off:
            con(r, "%08X.equipitem %08X" % (fid, item))
        for fid in placed:
            bring_back(r, fid, readback=False)


@test("CS-2", "CS", reload=True)
def cs2(r):
    """Address a child directly, also while the player is exposed: the child gives a normal AI reply (children keep AI).
    Mechanics only: the child's dialogue-event count rises after each injected line. 2 LLM calls."""
    if not market(r):
        return
    if not harness_ready(r):
        return
    cu, _, child = who(r, CHILD)
    if not cu or not child:
        return inc(r, "child not loaded or not IsChild")
    con(r, "%08X.moveto player" % CHILD)
    time.sleep(3)
    if not near_player(r, CHILD, "moveto player"):                       # RV-123 (3)
        return
    checkpoint(r, "2 LLM calls")
    item = None
    try:
        for label in ("dressed", "exposed"):
            if label == "exposed":
                item, m = fire_exposure(r)
                if not item:
                    return inc(r, "could not take off the player's body item")
                if m is False:                  # RV-123 (3): fire_exposure read the torso slot back (INCONCLUSIVE logged)
                    return
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
    if not market(r):
        return
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
