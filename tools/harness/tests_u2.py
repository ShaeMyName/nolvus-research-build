"""U2 scene/dialogue block, part 1: harness smoke, perception scope (W, spec §11.4) and the ieb_witness emitter (WE, §11.8).
Started 2026-10-11 (REVIEW_LOG RV-86: U2 test code must be ready before U1 ends). Setup: T0, Whiterun market by day.

Route R5 (SkyrimNet /harness API, sn_harness.py) for forced lines; history checks by render_template over
get_recent_events (usage VERIFIED in our own layer templates, consumer_proof_list.md), COUNTS ONLY: a nonce token in the
forced line is searched with contains(); no event or reply text is ever logged.
Line of sight: has_line_of_sight(a, b) (tests_misc._attire_probe); "behind a wall" = the X-7 placement under the
terrain at in-range distance, self-checked (LOS still true -> INCONCLUSIVE, never a vacuous PASS).
ieb_witness has a 60 s real-time floor (IEB_SceneMain.FireWitness): WE tests wait it out before each fire.
Not yet implemented here: WE-2/WE-3 (the per-event 'Allow NPC Reaction' toggle: route not settled), WE-5, WE-6, WE-9,
W-4, W-5 (soak)."""
import re, time
import game
import sn_harness as SH
from block import test, checkpoint
from fidnorm import fid_any_rx
from tests_misc import (PLAYER, F1, F2, CARLOTTA, FRALIA, YSOLDA, con, ctl_line, hx, inc, render, rval, truthy, who,
                        worn_rows, to_formid, su_get, near_player, body_flag)

A_NPC, B_NPC, C_NPC = FRALIA, YSOLDA, CARLOTTA      # bystanders (market townsfolk, adults, not on errands)
SC_PLUGIN = "SceneControls.esp"
MINIMAL_LIST = 0x810                                # IEB_MinimalBody (gen_scenecontrols.py:32), seeded at runtime
WITNESS_FLOOR_S = 61.0
_LAST_WITNESS = {"t": 0.0}


# ---------------------------------------------------------------------------- helpers

def nonce(tag):
    return "zq%s%d" % (tag, time.time_ns() % 10 ** 7)


def hist_hits(r, uuid, needle=None, etype=None, n=40):
    """How many of the actor's last n events contain `needle` (in format_event compact) and/or have type `etype`.
    One letter per hit; never the event text. None if the render failed."""
    cond = []
    if needle:
        cond.append('contains(format_event(e, "compact"), "%s")' % needle)
    if etype:
        cond.append('e.type == "%s"' % etype)
    out = render(r, uuid, "{%% for e in get_recent_events(%d, [actorUUID]) %%}{%% if %s %%}H{%% endif %%}{%% endfor %%}{# %d #}"
                 % (n, " and ".join(cond) or "true", time.time_ns()))
    return None if out is None else out.count("H")


def los(r, a_uuid, b_uuid):
    v = render(r, a_uuid, "{{ has_line_of_sight(npc.UUID, responseTarget.UUID) }}{# %d #}" % time.time_ns(), target=b_uuid)
    return None if v is None else truthy(v.strip())


def radius(r):
    """The live normal awareness radius (TestCtl.ConfigProbe). The test config uses 1600, SkyrimNet 25.1's default
    (Shae 2026-10-07, DECISIONS:136), not the spec text's 800. Falls back to 1600 if the probe line is missing."""
    m = ctl_line(r, "ConfigProbe", [], r"\[IEB-TEST\] CONFIGPROBE max=(\S+) normal=(\S+)")
    try:
        return float(m.group(2)) if m else 1600.0
    except ValueError:
        return 1600.0


def far(r):
    """A distance just outside the live awareness radius (radius + 400 u)."""
    return radius(r) + 400.0


def place(r, fid, dx, dy, dz):
    """PlaceRel onto the player, read back (RV-123 (3)): the PLACE line only echoes the offsets, so the actor's distance
    to the player (tests_u2_wh.dist, CombatProbe dPlayer) must be within max(250, 15 %) of |offset|. Returns the PLACE
    match, or None (INCONCLUSIVE logged)."""
    from tests_u2_wh import dist
    m = ctl_line(r, "PlaceRel", [fid, PLAYER, float(dx), float(dy), float(dz)], r"\[IEB-TEST\] PLACE")
    want = (float(dx) ** 2 + float(dy) ** 2 + float(dz) ** 2) ** 0.5
    d = dist(r, fid)
    if d is None or abs(d - want) > max(250.0, 0.15 * want):
        inc(r, "read-back PlaceRel %s: %s u from the player (want ~%d; RV-123 (3))"
            % (hx(fid), "no CombatProbe line" if d is None else d, want))
        return None
    return m


def bring_back(r, fid, readback=True):
    """'<ref>.moveto player', read back by distance (RV-123 (3)) unless readback=False (a cleanup in a reload=True test,
    where nothing after it depends on the move). True/False."""
    con(r, "%08X.moveto player" % fid)
    return near_player(r, fid, "bring_back") if readback else True


def market(r):
    """player.moveto Carlotta (market), read back by distance (RV-123 (3); 1500 u: she may walk off her stall during
    the 8 s settle). True, or INCONCLUSIVE logged and False."""
    con(r, "player.moveto %08X" % CARLOTTA)
    time.sleep(8)
    return near_player(r, CARLOTTA, "market (player.moveto Carlotta)", maxd=1500)


def set_whisper(r, on):
    """TestCtl.Whisper, read back from its own WHISPERSET line (maxDistance re-read after the toggle; whisper mode on
    <=> maxDistance == whisperMax). True, or INCONCLUSIVE logged and False (RV-123 (3))."""
    m = ctl_line(r, "Whisper", [int(on)], r"\[IEB-TEST\] WHISPERSET want=\S+ maxDistance=(\S+) whisperMax=(\S+)")
    try:
        is_on = float(m.group(1)) == float(m.group(2)) if m else None
    except ValueError:
        is_on = None
    if is_on is None or is_on != bool(on):
        inc(r, "read-back Whisper(%d): %s (RV-123 (3))" % (int(on), m.group(0) if m else "no WHISPERSET line"))
        return False
    return True


def uuids(r, *fids):
    out = []
    for f in fids:
        u, _, _ = who(r, f)
        out.append(u)
    return out


def harness_ready(r):
    """U2 needs the /harness API (R5): INCONCLUSIVE precondition if it does not answer."""
    p = SH.probe()
    ok = p.get("status", "").startswith("ok")
    if not ok:
        inc(r, "SkyrimNet /harness API not reachable (%s)" % p.get("status"))
    return ok


def force_line(r, speaker_uuid, text, target_uuid=None):
    """One forced NPC line (harness speak, kind npc), then wait for SkyrimNet to go idle. True on success."""
    try:
        SH.speak(speaker_uuid, text, "npc", target_uuid)
        SH.await_idle(60)
        return True
    except SH.HarnessError as e:
        inc(r, "harness speak failed: %s" % e)
        return False


def witness_wait():
    left = WITNESS_FLOOR_S - (time.time() - _LAST_WITNESS["t"])
    if left > 0:
        time.sleep(left)


def body_item(r, puuid):
    rows = worn_rows(r, puuid) or []
    body = [to_formid(x[1]) for x in rows if x[0].lower() == "torso"]
    return body[0] if body and body[0] else None


def fire_exposure(r):
    """Strip the player's body item (transition COVERED -> EXPOSED fires (a) once, 1 s debounce). Returns
    (the stripped form or None, the WITNESS log match or None)."""
    pu, = uuids(r, PLAYER)
    item = body_item(r, pu)
    if not item:
        return None, None
    witness_wait()
    t = game.Tail(game.LOGS["papyrus"])
    con(r, "player.unequipitem %08X" % item)
    m = t.wait(r"(?i)\[IEB-SC\] WITNESS (exposure) rc=(-?\d+)", 10)
    if m:
        _LAST_WITNESS["t"] = time.time()
    if body_flag(r, pu) != 0:       # RV-123 (3) read-back: the torso slot is empty (nonce render, tests_misc.body_flag)
        inc(r, "read-back player.unequipitem %08X: the player still wears a body garment (RV-123 (3))" % item)
        return item, False
    return item, m


def dress(r, item):
    if item:
        con(r, "player.equipitem %08X" % item)
        time.sleep(2)


# ---------------------------------------------------------------------------- harness smoke

@test("H-2", "H")
def h2(r):
    """U2 harness smoke: the /harness API answers (status, ui-state, utterances), and pacing bypass applies. Without it
    every R5 test is INCONCLUSIVE, so a miss here is a FAIL."""
    p = SH.probe()
    for k, v in p.items():
        r.check(v.startswith("ok"), "/harness %s answers (%s)" % (k, v[:120]))
    checkpoint(r)
    try:
        SH.pacing(True)
        ok = True
    except SH.HarnessError as e:
        ok = False
        r.log("  pacing bypass: %s" % e)
    r.check(ok, "/harness overrides pacing_governor=bypass accepted")


# ---------------------------------------------------------------------------- W: perception scope (§11.4)

def _w_scene(r, label, a_off=None, b_off=None, c_off=None, whisper=False):
    """Shared W body: place A (in view), B (no LOS), C (far) as asked; F1 says a hug line with a nonce to the player;
    return {name: hits} for the placed NPCs plus F1's own history as the positive control."""
    if not market(r):
        return None
    if not harness_ready(r):
        return None
    fu, au, bu, cu, pu = uuids(r, F1, A_NPC, B_NPC, C_NPC, PLAYER)
    if not (fu and pu):
        inc(r, "%s: F1 or the player has no uuid" % label)
        return None
    placed = []
    try:
        for fid, off, uu, want_los in ((A_NPC, a_off, au, True), (B_NPC, b_off, bu, False), (C_NPC, c_off, cu, True)):
            if off is None:
                continue
            if not uu:
                inc(r, "%s: %08X not loaded" % (label, fid))
                return None
            placed.append(fid)
            if not place(r, fid, *off):
                return None
        time.sleep(2)
        for fid, off, uu, want_los in ((A_NPC, a_off, au, True), (B_NPC, b_off, bu, False), (C_NPC, c_off, cu, True)):
            if off is None:
                continue
            l = los(r, uu, pu)
            if l is None or l != want_los:
                inc(r, "%s: line-of-sight setup for %08X gave %s (wanted %s)" % (label, fid, l, want_los))
                return None
        if whisper and not set_whisper(r, 1):
            return None
        checkpoint(r)
        tok = nonce("w")
        if not force_line(r, fu, "*gives %s a brief hug* %s" % ("you", tok), pu):
            return None
        time.sleep(3)
        out = {"F1": hist_hits(r, fu, tok)}
        for name, fid, off, uu in (("A", A_NPC, a_off, au), ("B", B_NPC, b_off, bu), ("C", C_NPC, c_off, cu)):
            if off is not None:
                out[name] = hist_hits(r, uu, tok)
        r.log("  %s history hits (counts only): %s" % (label, out))
        return out
    finally:
        if whisper:
            set_whisper(r, 0)      # SkyrimNet config: a reload may not undo it (INFERRED), so read back
        for fid in placed:
            bring_back(r, fid, readback=False)      # every _w_scene caller is reload=True


@test("W-1", "W", reload=True)
def w1(r):
    """Hug text with A at 300 u in view and B at ~500 u without line of sight: A included, B not."""
    h = _w_scene(r, "W-1", a_off=(300, 0, 0), b_off=(300, 0, -400))
    if h is None:
        return
    if not h.get("F1"):
        return inc(r, "the forced line is not in the speaker's own history (event not stored)")
    r.check((h.get("A") or 0) >= 1, "A (300 u, in view) has the line (%s)" % h.get("A"))
    r.check(h.get("B") == 0, "B (no line of sight) does not (%s)" % h.get("B"))


@test("W-2", "W", reload=True)
def w2(r):
    """Repeat with C just outside the live awareness radius (radius + 400 u; 1600 in the test config, DECISIONS:136),
    in view: C not included; A at 300 u as the control."""
    h = _w_scene(r, "W-2", a_off=(300, 0, 0), c_off=(far(r), 0, 0))
    if h is None:
        return
    if not h.get("A"):
        return inc(r, "control A (300 u) did not get the line")
    r.check(h.get("C") == 0, "C (beyond the radius, in view) does not have the line (%s)" % h.get("C"))


@test("W-3", "W", reload=True)
def w3(r):
    """Whisper mode at 300 u: A not included (200 u radius); the speaker's own history as the control."""
    h = _w_scene(r, "W-3", a_off=(300, 0, 0), whisper=True)
    if h is None:
        return
    if not h.get("F1"):
        return inc(r, "the forced line is not in the speaker's own history")
    r.check(h.get("A") == 0, "A (300 u) does not have the whispered line (%s)" % h.get("A"))


@test("W-4", "W", reload=True)
def w4(r):
    """Status events after the Relationships patch (consumer proof: IEB_SNRomStatus -> trigger ieb_snrom_status_private).
    F1 sends the same mod event the patched Relationships sends from the NPC (TestCtl.SNRomStatusEvent, a nonce in the
    text); a bystander 300 u in view. Pass: SkyrimNet logs the event reaching the trigger; F1 gains an npc_thought-type
    event; the bystander gains NO event carrying the nonce (no persistent public event). 1 LLM call (the thought)."""
    if not market(r):
        return
    if not harness_ready(r):
        return
    fu, au, pu = uuids(r, F1, A_NPC, PLAYER)
    if not (fu and au):
        return inc(r, "actors not loaded")
    try:
        if not place(r, A_NPC, 300, 0, 0):
            return
        time.sleep(2)
        if not los(r, au, pu):
            return inc(r, "bystander placed without line of sight")
        t0 = hist_hits(r, fu, etype="npc_thought")
        checkpoint(r, "1 LLM call")
        tok = nonce("w4")
        sn = game.Tail(game.LOGS["skyrimnet"])
        ctl_line(r, "SNRomStatusEvent", [F1, "Jenassa and the player shared a quiet moment %s." % tok],
                 r"\[IEB-TEST\] SNROMSTATUS sent")
        SH.await_idle(90)
        time.sleep(5)
        txt = sn.read()
        r.check(bool(re.search(r"IEB_SNRomStatus", txt)), "SkyrimNet saw the IEB_SNRomStatus mod event")
        t1 = hist_hits(r, fu, etype="npc_thought")
        r.check(t0 is not None and t1 is not None and t1 >= t0 + 1, "F1 gained an npc_thought (%s -> %s)" % (t0, t1))
        r.check(hist_hits(r, au, tok) == 0, "the bystander has no event carrying the status text")
    except SH.HarnessError as e:
        inc(r, "harness call failed: %s" % e)
    finally:
        bring_back(r, A_NPC, readback=False)


# ---------------------------------------------------------------------------- WE: the ieb_witness emitter (§11.8)

@test("WE-1", "WE", reload=True)
def we1(r):
    """The ieb_witness schema registered at load; one exposure in the market: one WITNESS line (rc >= 0), and the event
    is in the history of an NPC 300 u in view, not of one beyond the live awareness radius."""
    sn = game.Tail(game.LOGS["skyrimnet"])
    sn.pos = 0
    r.check(re.search(r"Successfully registered schema for event type 'ieb_witness'", sn.read()) is not None,
            "SkyrimNet: schema registered for 'ieb_witness' (this session)")
    if not market(r):
        return
    au, cu, pu = uuids(r, A_NPC, C_NPC, PLAYER)
    if not (au and cu and pu):
        return inc(r, "bystanders or player not loaded")
    item = None
    try:
        if not place(r, A_NPC, 300, 0, 0) or not place(r, C_NPC, far(r), 0, 0):
            return
        time.sleep(2)
        if not los(r, au, pu) or not los(r, cu, pu):
            return inc(r, "bystanders placed without line of sight")
        a0, c0 = hist_hits(r, au, etype="ieb_witness"), hist_hits(r, cu, etype="ieb_witness")
        if not body_item(r, pu):
            return inc(r, "the player wears no body item to remove")
        checkpoint(r)
        item, m = fire_exposure(r)
        if m is False:
            return                  # unequip not read back (INCONCLUSIVE logged)
        r.check(bool(m) and int(m.group(2)) >= 0, "one WITNESS exposure line, rc >= 0 (%s)" % (m.group(0) if m else "none"))
        time.sleep(3)
        a1, c1 = hist_hits(r, au, etype="ieb_witness"), hist_hits(r, cu, etype="ieb_witness")
        r.check(a0 is not None and a1 == a0 + 1, "A (300 u, in view): ieb_witness +1 (%s -> %s)" % (a0, a1))
        r.check(c0 is not None and c1 == c0, "C (beyond the radius): no new ieb_witness (%s -> %s)" % (c0, c1))
    finally:
        dress(r, item)
        bring_back(r, A_NPC, readback=False)
        bring_back(r, C_NPC, readback=False)


@test("WE-4", "WE", reload=True)
def we4(r):
    """Exposure with the bystanders behind a wall (no LOS, ~500 u) and beyond the live radius: neither gets the event; F1 beside
    the player is the positive control."""
    if not market(r):
        return
    fu, bu, cu, pu = uuids(r, F1, B_NPC, C_NPC, PLAYER)
    if not (fu and bu and cu and pu):
        return inc(r, "actors not loaded")
    item = None
    try:
        if not place(r, B_NPC, 300, 0, -400) or not place(r, C_NPC, far(r), 0, 0):
            return
        time.sleep(2)
        if los(r, bu, pu) is not False:
            return inc(r, "B's no-line-of-sight placement still has line of sight")
        counts0 = [hist_hits(r, u, etype="ieb_witness") for u in (fu, bu, cu)]
        if not body_item(r, pu):
            return inc(r, "the player wears no body item to remove")
        checkpoint(r)
        item, m = fire_exposure(r)
        if m is False:
            return                  # unequip not read back (INCONCLUSIVE logged)
        if not m:
            return inc(r, "no WITNESS line fired")
        time.sleep(3)
        counts1 = [hist_hits(r, u, etype="ieb_witness") for u in (fu, bu, cu)]
        r.log("  ieb_witness counts before/after (F1, B, C): %s -> %s" % (counts0, counts1))
        if counts1[0] is None or counts0[0] is None or counts1[0] != counts0[0] + 1:
            return inc(r, "control F1 did not get the event")
        r.check(counts1[1] == counts0[1], "B (no line of sight): no event")
        r.check(counts1[2] == counts0[2], "C (beyond the radius): no event")
    finally:
        dress(r, item)
        bring_back(r, B_NPC, readback=False)
        bring_back(r, C_NPC, readback=False)


@test("WE-7", "WE", reload=True)
def we7(r):
    """Equip a Divine Elegance piece (IEB_MinimalBody[0]): state MINIMAL, exactly one event (state 'wearing only
    smallclothes' is checked by the stored state value, not the text)."""
    if not market(r):
        return
    pu, = uuids(r, PLAYER)
    orig = body_item(r, pu)
    if not orig:
        return inc(r, "the player wears no body item")
    if su_get(r, pu, "IEB_ExposureState", fid=PLAYER) not in (0, -99):
        return inc(r, "exposure state not COVERED at start")
    checkpoint(r)
    witness_wait()
    t = game.Tail(game.LOGS["papyrus"])
    try:
        m = ctl_line(r, "EquipFromList", [MINIMAL_LIST, SC_PLUGIN, 0], r"\[IEB-TEST\] (?:EQUIPLIST \S+ size=(\d+) worn=(\w+)|EquipFromList: .*)")
        if not m or not m.group(1):
            return inc(r, "EquipFromList failed (%s)" % (m.group(0) if m else "no line"))
        if (m.group(2) or "").upper() != "TRUE":    # RV-123 (3): EQUIPLIST worn= is IsEquipped read after the equip
            return inc(r, "read-back EquipFromList: worn=%s (RV-123 (3))" % m.group(2))
        time.sleep(4)
        _LAST_WITNESS["t"] = time.time()
        fired = re.findall(r"(?i)\[IEB-SC\] WITNESS exposure rc=", t.read())
        r.check(len(fired) == 1, "exactly one WITNESS exposure line (%d)" % len(fired))
        st = su_get(r, pu, "IEB_ExposureState", fid=PLAYER)
        r.check(st == 1, "IEB_ExposureState = 1 (MINIMAL) (%s)" % st)
    finally:
        dress(r, orig)


@test("WE-8", "WE")
def we8(r):
    """Outfit swap (unequip then re-equip within 0.3 s): no event (1 s debounce); state stays COVERED."""
    if not market(r):
        return
    pu, = uuids(r, PLAYER)
    if not body_item(r, pu):
        return inc(r, "the player wears no body item")
    checkpoint(r)
    witness_wait()
    t = game.Tail(game.LOGS["papyrus"])
    m = ctl_line(r, "BodySwap", [], r"\[IEB-TEST\] BODYSWAP (\S+)(?: worn=(\w+))?")
    if not m or m.group(1) == "none":
        return inc(r, "BodySwap did not run (%s)" % (m.group(0) if m else "no line"))
    if (m.group(2) or "").upper() != "TRUE":        # RV-123 (3): BODYSWAP worn= is IsEquipped read after the re-equip
        return inc(r, "read-back BodySwap: body item not worn again (worn=%s; RV-123 (3))" % m.group(2))
    time.sleep(5)
    fired = re.findall(r"(?i)\[IEB-SC\] WITNESS exposure", t.read())
    r.check(not fired, "no WITNESS line after a 0.3 s swap (%d)" % len(fired))
    r.check(su_get(r, pu, "IEB_ExposureState", fid=PLAYER) in (0, -99), "exposure state still COVERED")
