"""U2 scene/dialogue block, part 2: situational whisper (WH, spec §11.9) and the private-scene flag (PV, §11.13.3/§11.13.6).
Written 2026-10-11 (REVIEW_LOG RV-86: U2 test code ready before U1 ends). Setup: T0, Whiterun market by day.

Places (console `coc <CellEditorID>`): WhiterunBreezehome (interior, player-house Location: rule i), WhiterunBanneredMare (the
inn: busy common room; "rented room" is made by IEB_TestCtl.OwnNearestFurniture, which owns the nearest furniture to the player,
rule ii). Every place switch is self-checked (cell and worldspace differ from the market's) and every NPC placement is
distance-checked (CombatProbe dPlayer; NEARNPC counts from IEB_TestCtl.CountNearNPCs, which mirrors IEB_SceneMain.CountOthers).

Whisper state is read from the config (ConfigProbe: maxDistance == whisperMaxDistance means on), never from the script's own
StorageUtil intent. Scene mode comes from IEB_TestCtl.SceneOn (the StorageUtil keys StartScene writes, no crosshair); the real
IEB_SceneMain tick then runs PrivacyCheck/SceneUpkeep, so the flag arrives after one 5 s tick plus two 2 s checks, not at once
as with the real key (INFERRED equivalent otherwise).

Timing: whisper is evaluated every 5 s tick (5-6 s in scene mode), toggling after 2 consecutive checks (about 10-12 s); the private
flag every 2 s in scene mode, private after 2 clear checks, witnessed on the first finding.
COUNTS ONLY: no event, prompt or reply text is logged; a nonce token is searched in History with contains()."""
import re, time
from datetime import datetime
import game
import sn_harness as SH
from block import test, checkpoint, settle_probe
from tests_misc import PLAYER, F1, CARLOTTA, FRALIA, YSOLDA, WR_GUARDS, con, ctl_line, hx, inc, su_get
from tests_u2 import (radius, market, uuids, place, bring_back, los, hist_hits, force_line, harness_ready, nonce,
                      witness_wait, _LAST_WITNESS)

MARE = "WhiterunBanneredMare"
HOME = "WhiterunBreezehome"
HOUSECARL = FRALIA          # stands in for the housecarl (an adult townsperson; INFERRED fine, the rule counts any ActorTypeNPC)
NEWCOMER = YSOLDA
BANDIT = 0x0003DECB         # LvlBanditMelee1H (tests_b.BANDIT)
SENTINEL = -7000.0          # ConfigProbe's lookup-failed defaults are -7001..-7004
TICK_S = 5.0
HYST_S = 2 * TICK_S         # two checks
ON_WAIT_S = 50              # whisper turns on after 2 checks (about 10-12 s) plus load/location settle
RX_WH = re.compile(r"\[(\d\d/\d\d/\d{4}) - (\d\d:\d\d:\d\d)([AP]M)\] \[IEB-SC\] WHISPER (True|False)\b(?! manual)", re.I)


# ---------------------------------------------------------------------------- helpers

def ptail():
    return game.Tail(game.LOGS["papyrus"])


def cfg(r):
    """{'on', 'max', 'normal', 'whisper'} from ConfigProbe, or None (INCONCLUSIVE logged on a missing line or a sentinel)."""
    m = ctl_line(r, "ConfigProbe", [], r"(?i)\[IEB-TEST\] CONFIGPROBE max=(-?[\d.]+) normal=(-?[\d.]+) whisper=(-?[\d.]+)", 15)
    if not m:
        inc(r, "ConfigProbe gave no line")
        return None
    mx, nm, wh = (float(m.group(i)) for i in (1, 2, 3))
    if min(mx, nm, wh) <= SENTINEL:
        inc(r, "config lookup failed (a sentinel came back: max=%s normal=%s whisper=%s)" % (mx, nm, wh))
        return None
    return {"on": abs(mx - wh) < 0.5, "max": mx, "normal": nm, "whisper": wh}


def wait_whisper(r, want, timeout=ON_WAIT_S, step=4.0):
    """Poll the real config until whisper == want. Returns (reached, seconds, last cfg or None)."""
    t0 = time.time()
    c = None
    while True:
        c = cfg(r)
        if c is None:
            return False, time.time() - t0, None
        if c["on"] == want:
            return True, time.time() - t0, c
        if time.time() - t0 >= timeout:
            return False, time.time() - t0, c
        time.sleep(step)


def where(r):
    m = ctl_line(r, "PlayerWhere", [], r"\[IEB-TEST\] PLAYERPOS cell=(\S+) ws=(\S+) x=(-?[\d.]+) y=(-?[\d.]+) z=(-?[\d.]+)", 15)
    if not m:
        return None
    return {"cell": m.group(1), "ws": m.group(2), "x": float(m.group(3)), "y": float(m.group(4)), "z": float(m.group(5))}


def enter(r, cell_id, w0):
    """coc into an interior; self-check that the cell and the worldspace both changed from the market's (w0). The new
    position dict or None (INCONCLUSIVE)."""
    con(r, "coc %s" % cell_id)
    time.sleep(10)
    w1 = where(r)
    if not w1 or not w0:
        inc(r, "no PLAYERPOS before/after coc %s" % cell_id)
        return None
    if w1["cell"] == w0["cell"] or w1["ws"] == w0["ws"]:
        inc(r, "coc %s did not reach an interior (cell %s -> %s, worldspace %s -> %s)" % (cell_id, w0["cell"], w1["cell"], w0["ws"], w1["ws"]))
        return None
    return w1


def near(r, radius, excl=0):
    """Live, enabled NPCs within radius (not the player, not a scene partner, not `excl`): int or None (INCONCLUSIVE)."""
    m = ctl_line(r, "CountNearNPCs", [float(radius), int(excl)], r"\[IEB-TEST\] NEARNPC n=(\d+) r=%d\b" % int(radius), 15)
    if not m:
        inc(r, "CountNearNPCs gave no line")
        return None
    return int(m.group(1))


def dist(r, fid):
    m = ctl_line(r, "CombatProbe", [fid], r"\[IEB-TEST\] CombatProbe .*? combat=(\d).*? dPlayer=(\d+)", 10)
    return int(m.group(2)) if m else None


def own_room(r):
    """INFERRED stand-in for renting: own the nearest furniture within 500 u (rule ii). dict(ref, d, x, y, z) or None."""
    m = ctl_line(r, "OwnNearestFurniture", [500.0], r"\[IEB-TEST\] OWNFURN (?:none|(\S+) d=(\d+) pos=(-?\d+),(-?\d+),(-?\d+))", 15)
    if not m or not m.group(1):
        inc(r, "no furniture within 500 u to own (%s)" % (m.group(0) if m else "no line"))
        return None
    return {"ref": m.group(1), "d": int(m.group(2)), "x": float(m.group(3)), "y": float(m.group(4)), "z": float(m.group(5))}


def scene_on(r, fid=F1):
    m = ctl_line(r, "SceneOn", [fid], r"\[IEB-TEST\] SCENE (?:on partner=|refused)", 10)
    if not m or "refused" in m.group(0):
        inc(r, "SceneOn did not start (%s)" % (m.group(0) if m else "no line"))
        return False
    return True


def scene_off(r):
    ctl_line(r, "SceneOff", [], r"\[IEB-TEST\] SCENE off", 10)


def flag(r):
    return su_get(r, "", "IEB_ScenePrivate", fid=PLAYER)


def unit_place(r, fid, dx, dy, dz, want_lo, want_hi, what):
    """PlaceRel at the player, then check the 3D distance is within [want_lo, want_hi]. Distance or None (INCONCLUSIVE)."""
    place(r, fid, dx, dy, dz)
    time.sleep(2)
    d = dist(r, fid)
    if d is None or not (want_lo <= d <= want_hi):
        inc(r, "%s placed at %s u, wanted %d-%d" % (what, d, want_lo, want_hi))
        return None
    return d


def back_to_market(r, fids):
    """Cleanup: scene state off, the player to the market, placed NPCs back to the player."""
    try:
        scene_off(r)
    finally:
        market(r)
        for f in fids:
            bring_back(r, f)


def hysteresis_events(text):
    """[(datetime, bool)] of automatic whisper toggles from a Papyrus log excerpt."""
    out = []
    for m in RX_WH.finditer(text):
        try:
            t = datetime.strptime(m.group(1) + " " + m.group(2) + m.group(3), "%m/%d/%Y %I:%M:%S%p")
        except ValueError:
            continue
        out.append((t, m.group(4).lower() == "true"))
    return out


def private_violations(text):
    """Walk the [IEB-SC] lines in order, tracking the flag; count (c) 'scene' WITNESS lines fired while the flag was 1,
    the number of 1 -> 0 flips, and whether the scene ended. Returns dict of counts."""
    state, bad, flips, fired, ended = 0, 0, 0, 0, 0
    for m in re.finditer(r"\[IEB-SC\] (PRIVATE 0->1|PRIVATE 1->0|SCENE_ON|SCENE_OFF|PARTNER_LEFT|WITNESS scene rc=-?\d+)", text):
        k = m.group(1)
        if k == "PRIVATE 0->1":
            state = 1
        elif k == "PRIVATE 1->0":
            state = 0
            flips += 1
        elif k in ("SCENE_ON",):
            state = 0
        elif k in ("SCENE_OFF", "PARTNER_LEFT"):
            state = 0
            ended += 1
        elif k.startswith("WITNESS scene"):
            fired += 1
            bad += 1 if state == 1 else 0
    return {"while_private": bad, "fired": fired, "flips": flips, "ended": ended}


def move_away(r, w_player, furn, min_d=520.0):
    """Teleport the player (PlayerPlace, same cell) to the first offset that is > min_d from the owned furniture and not
    fallen; returns the new position dict or None. Self-checked through PLAYERPOS."""
    for dx, dy in ((700, 0), (-700, 0), (0, 700), (0, -700), (900, 0), (-900, 0), (0, 900), (0, -900)):
        x, y, z = w_player["x"] + dx, w_player["y"] + dy, w_player["z"] + 20.0
        if ((x - furn["x"]) ** 2 + (y - furn["y"]) ** 2) ** 0.5 <= min_d:
            continue
        ctl_line(r, "PlayerPlace", [x, y, z], r"\[IEB-TEST\] PLAYERPOS ", 15)
        w = where(r)
        if w and w["cell"] == w_player["cell"] and abs(w["z"] - w_player["z"]) < 200 and \
                ((w["x"] - furn["x"]) ** 2 + (w["y"] - furn["y"]) ** 2) ** 0.5 > min_d:
            return w
        ctl_line(r, "PlayerPlace", [w_player["x"], w_player["y"], w_player["z"]], r"\[IEB-TEST\] PLAYERPOS ", 15)
    inc(r, "no usable spot more than %d u from the owned furniture in the same cell" % min_d)
    return None


def inn_with_partner(r, rent=True, partner=True):
    """Shared setup for the inn tests: market, uuids, coc Mare, F1 at 100 u, optionally an owned (rented) furniture and
    whisper settled ON. Returns ctx dict or None. Caller must clean up (back_to_market) in `finally`."""
    market(r)
    pu, fu, nu = uuids(r, PLAYER, F1, NEWCOMER)
    if not (pu and fu):
        inc(r, "player or F1 has no uuid")
        return None
    w0 = where(r)
    w1 = enter(r, MARE, w0)
    if not w1:
        return None
    ctx = {"pu": pu, "fu": fu, "nu": nu, "w0": w0, "w1": w1, "furn": None}
    if partner:
        bring_back(r, F1)
        if unit_place(r, F1, 100, 0, 0, 40, 160, "F1 (partner)") is None:
            return None
    if rent:
        ctx["furn"] = own_room(r)
        if not ctx["furn"]:
            return None
        ok, secs, c = wait_whisper(r, True)
        if not ok:
            inc(r, "whisper did not turn on in the 'rented room' within %d s (WH-3 covers the rule itself)" % ON_WAIT_S)
            return None
        ctx["cfg"] = c
    return ctx


# ---------------------------------------------------------------------------- WH: situational whisper (§11.9)

@test("WH-1", "WH", reload=True)
def wh1(r):
    """Read state (config name 'game', dotted path: INFERRED by the spec). The hotkey stands in for IEB_TestCtl.Whisper
    (TriggerToggleWhisperMode, INFERRED same as the key). Mechanical part: the three GetConfigFloat reads are real (no sentinel),
    off => maxDistance == normalMaxDistance, on => maxDistance == whisperMaxDistance, and WHISPERSET agrees. NOT automatable: that
    the on-screen notification text matches the values (logged as a note, no INCONCLUSIVE: the config name is what WH-1 confirms)."""
    market(r)
    c0 = cfg(r)
    if not c0:
        return
    r.check(not c0["on"] and c0["max"] == c0["normal"], "baseline in the market: whisper off, maxDistance == normalMaxDistance (%s)" % c0)
    checkpoint(r)
    m = ctl_line(r, "Whisper", [1], r"\[IEB-TEST\] WHISPERSET want=1 maxDistance=(-?[\d.]+) whisperMax=(-?[\d.]+)", 15)
    c1 = cfg(r)
    if not m or not c1:
        return
    r.check(abs(float(m.group(1)) - float(m.group(2))) < 0.5, "WHISPERSET: maxDistance == whisperMaxDistance after toggle on")
    r.check(c1["on"] and c1["max"] == c1["whisper"], "ConfigProbe: on => maxDistance == whisperMaxDistance (%s)" % c1["max"])
    ctl_line(r, "Whisper", [0], r"\[IEB-TEST\] WHISPERSET want=0", 15)
    c2 = cfg(r)
    if c2:
        r.check(not c2["on"] and c2["max"] == c2["normal"], "after toggle off: maxDistance back to normalMaxDistance (%s)" % c2["max"])
    r.log("  NOTE: notification text vs values not machine-readable; left for a look in-game (not counted)")


@test("WH-2", "WH", reload=True)
def wh2(r):
    """Whisper on in a 'rented room' (INFERRED: OwnNearestFurniture stands in for the rental), save IEB_WH2 through
    TestCtl.SaveNamed (game.save), load it again: after about 3 s the log has WHISPER_RESTORE source=auto on=True and the
    config shows whisper on (SkyrimNet reset it to off on load: spec §11.9)."""
    if True:
        ctx = inn_with_partner(r, rent=True, partner=False)
        if not ctx:
            return
        checkpoint(r)
        if not game.save(r, "IEB_WH2"):
            return inc(r, "save IEB_WH2 did not complete; not loading it")
        time.sleep(5)
        t = ptail()
        if not game.load(r, "IEB_WH2", settle_probe(r)):
            return r.check(False, "load IEB_WH2")
        m = t.wait(r"(?i)\[IEB-SC\] WHISPER_RESTORE source=(\S+) on=(\w+)", 30)
        r.check(bool(m), "WHISPER_RESTORE logged after the load")
        if m:
            r.check(m.group(1) == "auto" and m.group(2).lower() == "true",
                    "WHISPER_RESTORE source=auto on=True (%s)" % m.group(0).split("] ", 1)[-1])
        c = cfg(r)
        if c:
            r.check(c["on"], "config: whisper on after the restore")


@test("WH-3", "WH", reload=True)
def wh3(r):
    """Rule (ii): in the Bannered Mare, public (crowd within the live radius, no owned furniture): off. Own the nearest furniture
    (INFERRED stand-in for renting): on within ~2 checks. Move > 500 u from it, still in the cell (the 'common room', crowd
    still within the live radius): off again."""
    fids = []
    try:
        market(r)
        w0 = where(r)
        w1 = enter(r, MARE, w0)
        if not w1:
            return
        crowd = near(r, radius(r))
        if crowd is None:
            return
        if crowd < 1:
            return inc(r, "no NPC within the live radius in the inn: rule (iii) would hold, baseline not 'public'")
        ok, secs, c = wait_whisper(r, False, timeout=40)
        if not ok:
            return inc(r, "baseline whisper not off in the public inn (%s)" % (c,))
        checkpoint(r)
        t = ptail()
        furn = own_room(r)
        if not furn:
            return
        ok, secs, c = wait_whisper(r, True)
        r.check(ok, "owned furniture %d u away: whisper on (after %d s)" % (furn["d"], secs))
        r.check(not ok or secs <= 2 * HYST_S + 5, "turned on within about 2 checks (%d s)" % secs)
        if not ok:
            return
        wnow = where(r)
        w2 = move_away(r, wnow, furn) if wnow else None
        if not w2:
            return
        crowd2 = near(r, radius(r))
        if crowd2 is None:
            return
        if crowd2 < 1:
            return inc(r, "no NPC within the live radius at the common-room spot: rule (iii) would hold")
        ok, secs, c = wait_whisper(r, False)
        r.check(ok, "more than 500 u from the owned furniture, crowd in range: whisper off (after %d s)" % secs)
        ev = hysteresis_events(t.read())
        r.log("  automatic toggles logged: %s" % [("on" if v else "off") for _, v in ev])
        r.check([v for _, v in ev][:2] == [True, False], "log shows exactly the on then off toggles in order")
    finally:
        back_to_market(r, fids)


def _home_case(r, tid, scene):
    """WH-4 and PV-4 share this. Rule (i): Breezehome (Location with the player-house keyword; INFERRED the keyword is on the
    location record, owned or not). A 'housecarl' (Fralia) is placed 300 u from the player (INFERRED: 'another room' is not
    machine-checkable; the point is outside the 200 u radius while inside the radius, so rule iii alone cannot explain 'on'). F1 is the
    speaker, 100 u away. scene=False: whisper turns on and a forced line with a nonce does not reach the housecarl's History
    (F1's own History is the positive control). scene=True: whisper is on first, then SceneOn(F1); the flag is 1 and the nonce
    line is again absent from the housecarl's History."""
    fids = [F1, HOUSECARL]
    try:
        if not harness_ready(r):
            return
        market(r)
        pu, fu, hu = uuids(r, PLAYER, F1, HOUSECARL)
        if not (pu and fu and hu):
            return inc(r, "%s: player, F1 or housecarl has no uuid" % tid)
        w0 = where(r)
        t = ptail()
        w1 = enter(r, HOME, w0)
        if not w1:
            return
        bring_back(r, F1)
        if unit_place(r, F1, 100, 0, 0, 40, 160, "F1") is None:
            return
        place(r, HOUSECARL, 300, 0, 0)
        time.sleep(2)
        d = dist(r, HOUSECARL)
        if d is None or not (250 <= d <= 350):
            return inc(r, "%s: housecarl at %s u, wanted 250-350 (outside 200, inside 800)" % (tid, d))
        lo = los(r, hu, pu)
        r.log("  %s: housecarl %d u away, line of sight to the player: %s (counts only)" % (tid, d, lo))
        n800 = near(r, radius(r), F1)
        if n800 is None:
            return
        if n800 < 1:
            return inc(r, "%s: the housecarl is not counted within the live radius (rule iii precondition)" % tid)
        if scene:
            ok, secs, c = wait_whisper(r, True)
            if not ok:
                return inc(r, "PV-4: whisper not on in the owned home within %d s (WH-4 covers it)" % ON_WAIT_S)
            if near(r, 200, F1) != 0:
                return inc(r, "PV-4: someone else within 200 u of the player")
        checkpoint(r)
        if not scene:
            ok, secs, c = wait_whisper(r, True)
            r.check(ok, "WH-4: whisper on in the owned home, housecarl at %d u (after %d s)" % (d, secs))
            if not ok:
                return
            r.check(c["max"] == c["whisper"] and c["whisper"] < d, "radius %.0f u is below the housecarl's %d u" % (c["max"], d))
        else:
            tn = ptail()
            if not scene_on(r):
                return
            m = tn.wait(r"\[IEB-SC\] PRIVATE 0->1", 25)
            fl = flag(r)
            r.check(bool(m) and fl == 1, "PV-4: IEB_ScenePrivate = 1 with the housecarl at %d u, outside the %.0f u radius (flag %s)" % (d, c["max"], fl))
            if fl != 1:
                return
        tok = nonce("h")
        if not force_line(r, fu, "*smiles at you* %s" % tok, pu):
            return
        time.sleep(3)
        nf, nh = hist_hits(r, fu, tok), hist_hits(r, hu, tok)
        r.log("  %s: nonce line hits (counts only): F1=%s housecarl=%s" % (tid, nf, nh))
        if not nf:
            return inc(r, "%s: control failed, the forced line is not in F1's own History" % tid)
        r.check(nh == 0, "%s: the housecarl's History lacks the line (%s)" % (tid, nh))
    finally:
        back_to_market(r, fids)


@test("WH-4", "WH", reload=True)
def wh4(r):
    """Owned home (rule i), housecarl 300 u away: whisper on, and the housecarl's History lacks a forced line. Shares its
    setup with PV-4 (_home_case). INFERRED: the player-house keyword is on the Breezehome Location record; 'another room' is
    only approximated by distance."""
    _home_case(r, "WH-4", scene=False)


@test("WH-5", "WH", reload=True)
def wh5(r):
    """Spec-literal: EXTERIOR, partner only: whisper on; then a guard 400 u away: off within ~10 s. The code
    (IEB_SceneMain.PrivatePlace) returns False for any exterior cell, so this is expected to FAIL on the first check if the
    market ever had nobody within the live radius: a spec/code discrepancy to report, not a harness bug. In a normal market the
    precondition (nobody else within the live radius) fails and the test is INCONCLUSIVE. Guard ref: first of WR_GUARDS."""
    fids = [F1] + WR_GUARDS[:1]
    try:
        market(r)
        bring_back(r, F1)
        n = near(r, radius(r), F1)
        if n is None:
            return
        if n > 0:
            return inc(r, "market has %d NPC(s) within the live radius besides the partner: no 'partner only' exterior here" % n)
        checkpoint(r)
        ok, secs, c = wait_whisper(r, True)
        r.check(ok, "exterior, partner only: whisper on (spec; the code requires an interior) after %d s" % secs)
        if not ok:
            return
        t = ptail()
        place(r, WR_GUARDS[0], 400, 0, 0)
        t0 = time.time()
        ok, secs, c = wait_whisper(r, False, timeout=40, step=2.0)
        r.check(ok and time.time() - t0 <= HYST_S + 8, "a guard within the live radius: whisper off within about 10 s (%d s)" % secs)
    finally:
        for f in fids:
            bring_back(r, f)


@test("WH-6", "WH", reload=True)
def wh6(r):
    """Manual override in public: TestCtl.Whisper(1) stands in for the hotkey (INFERRED same path: an outside toggle). The
    script logs 'manual override detected' within a tick or two and does not toggle back for 25 s; the next location change
    (coc to the inn's public common room) logs 'manual override ended', and auto then takes whisper off (crowd in range)."""
    try:
        market(r)
        c0 = cfg(r)
        if not c0:
            return
        if c0["on"]:
            return inc(r, "whisper already on in the market at start")
        w0 = where(r)
        checkpoint(r)
        t = ptail()
        ctl_line(r, "Whisper", [1], r"\[IEB-TEST\] WHISPERSET want=1", 15)
        m = t.wait(r"(?i)\[IEB-SC\] WHISPER manual override detected \(on=true\)", 20)
        r.check(bool(m), "manual override detected and logged")
        if not m:
            return
        time.sleep(25)
        c1 = cfg(r)
        auto = [v for _, v in hysteresis_events(t.read())]
        r.check(bool(c1) and c1["on"] and not auto, "not fought for 25 s: still on, no automatic toggle logged (%d)" % len(auto))
        w1 = enter(r, MARE, w0)
        if not w1:
            return
        m2 = t.wait(r"\[IEB-SC\] WHISPER manual override ended \(location change\)", 15)
        r.check(bool(m2), "override ended at the location change")
        crowd = near(r, radius(r))
        if crowd is None:
            return
        if crowd < 1:
            return inc(r, "no NPC within the live radius in the inn: auto would keep it on (rule iii)")
        ok, secs, c = wait_whisper(r, False)
        r.check(ok, "auto resumed: whisper off in the public inn after %d s" % secs)
    finally:
        back_to_market(r, [])


@test("WH-7", "WH", reload=True)
def wh7(r):
    """Combat in a private room: Breezehome (rule i), whisper on; spawn a hostile (SpawnHostile) next to the player; once
    the player is in combat (CombatProbe on the player), the log has 'WHISPER False (immediate)' and the config shows off.
    The hostile is removed in `finally`."""
    spawned = False
    try:
        market(r)
        w0 = where(r)
        w1 = enter(r, HOME, w0)
        if not w1:
            return
        ok, secs, c = wait_whisper(r, True)
        if not ok:
            return inc(r, "whisper not on in the owned home first (WH-4 covers it)")
        checkpoint(r)
        t = ptail()
        ctl_line(r, "SpawnHostile", [BANDIT], r"\[IEB-TEST\] SpawnHostile \S+ ref=(\S+)", 15)
        spawned = True
        combat = False
        end = time.time() + 40
        while time.time() < end and not combat:
            m = ctl_line(r, "CombatProbe", [PLAYER], r"\[IEB-TEST\] CombatProbe .*? combat=(\d)", 10)
            combat = bool(m and m.group(1) == "1")
            if not combat:
                time.sleep(2)
        if not combat:
            return inc(r, "the player never entered combat within 40 s")
        m = t.wait(r"(?i)\[IEB-SC\] WHISPER false \(immediate\)", 15)
        r.check(bool(m), "WHISPER False (immediate) logged after combat started")
        c = cfg(r)
        r.check(bool(c) and not c["on"], "config: whisper off during combat")
    finally:
        if spawned:
            ctl_line(r, "Despawn", [], r"\[IEB-TEST\] Despawn", 10)
        back_to_market(r, [])


@test("WH-8", "WH", reload=True)
def wh8(r):
    """30 minutes in the busy inn, REAL duration (1800 s). Stimulus so the check is not vacuous: one owned furniture (INFERRED
    rental stand-in); the player sits > 500 u from it (public, whisper off) and every ~25 s makes a short visit inside 500 u and
    returns (PlayerPlace there and back, about 4-6 s). The visit is about one tick long, so the 2-check hysteresis should
    mostly swallow it. Passes if: every automatic toggle is at least 8 s after the previous (2 checks, 1 s log stamps),
    toggles <= visits, and the end state is the public one (off). Toggle times come from the Papyrus log stamps (1 s)."""
    DUR_S, EVERY_S = 1800, 25
    try:
        ctx = inn_with_partner(r, rent=True, partner=False)
        if not ctx:
            return
        furn = ctx["furn"]
        p_in = where(r)
        p_out = move_away(r, p_in, furn) if p_in else None
        if not p_out:
            return
        crowd = near(r, radius(r))
        if crowd is None:
            return
        if crowd < 1:
            return inc(r, "no NPC within the live radius at the far spot: rule (iii) would hold")
        ok, secs, c = wait_whisper(r, False)
        if not ok:
            return inc(r, "baseline whisper not off at the far spot (%s)" % (c,))
        checkpoint(r)
        t = ptail()
        t0, visits, nxt = time.time(), 0, time.time() + EVERY_S
        while time.time() - t0 < DUR_S:
            if time.time() >= nxt:
                ctl_line(r, "PlayerPlace", [p_in["x"], p_in["y"], p_in["z"] + 20.0], r"\[IEB-TEST\] PLAYERPOS ", 15)
                ctl_line(r, "PlayerPlace", [p_out["x"], p_out["y"], p_out["z"] + 20.0], r"\[IEB-TEST\] PLAYERPOS ", 15)
                visits += 1
                nxt = time.time() + EVERY_S
            time.sleep(2)
        time.sleep(2 * HYST_S)
        ev = hysteresis_events(t.read())
        gaps = [(ev[i][0] - ev[i - 1][0]).total_seconds() for i in range(1, len(ev))]
        r.log("  30 min: %d visits, %d automatic toggles, gaps (s): %s" % (visits, len(ev), [int(g) for g in gaps][:20]))
        r.check(all(g >= 8 for g in gaps), "no toggle within 8 s of the previous (hysteresis; min gap %s s)" % (int(min(gaps)) if gaps else "n/a"))
        r.check(len(ev) <= visits, "toggles (%d) do not exceed the stimuli (%d visits)" % (len(ev), visits))
        c = cfg(r)
        r.check(bool(c) and not c["on"], "ends in the public state (off)")
    finally:
        back_to_market(r, [])


# ---------------------------------------------------------------------------- PV: the private-scene flag (§11.13.3)

@test("PV-1", "PV", reload=True)
def pv1(r):
    """Private: 'rented room' (INFERRED stand-in), whisper on, only the partner within 200 u. SceneOn(F1); IEB_ScenePrivate becomes
    1: 'PRIVATE 0->1' within 10 s (the harness SceneOn lacks StartScene's immediate set: first tick up to 5 s, then 2 checks of
    2 s). The asterisk-text part needs a judge."""
    try:
        ctx = inn_with_partner(r, rent=True, partner=True)
        if not ctx:
            return
        n200 = near(r, 200, F1)
        if n200 is None:
            return
        if n200 != 0:
            return inc(r, "%d other NPC(s) within 200 u of the player: not 'partner only'" % n200)
        checkpoint(r)
        t = ptail()
        t0 = time.time()
        if not scene_on(r):
            return
        m = t.wait(r"\[IEB-SC\] PRIVATE 0->1", 20, poll=0.5)
        dt = time.time() - t0
        fl = flag(r)
        r.check(bool(m) and fl == 1, "IEB_ScenePrivate = 1 (flag %s) after %.1f s" % (fl, dt))
        r.check(bool(m) and dt <= 10.0, "within 10 s of SceneOn (5 s tick + 2 checks)")
        r.log("  JUDGE: private asterisk text may hold the partner's sensations and never the player's feelings; flag=1 held, 0 lines inspected here")
        inc(r, "judgement part left for the reviewer")
    finally:
        back_to_market(r, [F1])


@test("PV-2", "PV", reload=True)
def pv2(r):
    """Witnessed: the inn common room (no owned furniture, whisper off, crowd within the live radius). SceneOn(F1); for 25 s (3+ checks,
    where a clear area would have turned it private) the flag stays 0 and no 'PRIVATE 0->1' is logged. Control: NEARNPC > 0 at
    scene start. The camera-neutral wording needs a judge."""
    try:
        ctx = inn_with_partner(r, rent=False, partner=True)
        if not ctx:
            return
        ok, secs, c = wait_whisper(r, False, timeout=40)
        if not ok:
            return inc(r, "whisper not off in the public inn")
        crowd = near(r, c["max"], F1)
        if crowd is None:
            return
        if crowd < 1:
            return inc(r, "nobody else within the %.0f u radius: the scene would be private, not witnessed" % c["max"])
        checkpoint(r)
        t = ptail()
        if not scene_on(r):
            return
        time.sleep(25)
        fl = flag(r)
        priv = re.findall(r"\[IEB-SC\] PRIVATE 0->1", t.read())
        r.check(fl == 0 and not priv, "flag 0 for 25 s with %d other NPC(s) in range (flag %s, 0->1 lines %d)" % (crowd, fl, len(priv)))
        r.log("  JUDGE: witnessed asterisk text must be camera-neutral (no sensation or feeling words); flag=0 held, 0 lines inspected here")
        inc(r, "judgement part left for the reviewer")
    finally:
        back_to_market(r, [F1])


@test("PV-3", "PV", reload=True)
def pv3(r):
    """Arrival during PV-1: private (flag 1), a nonce line is spoken (partner to player), then a newcomer is placed at 120 u.
    Checks: 'PRIVATE 1->0' within ~6 s of the placement (2 s tick + controller latency; spec: about 2 s), flag 0, exactly one
    'WITNESS scene' line at the flip (the 60 s floor honoured: harness waits it out first), and the newcomer's History lacks the
    earlier nonce. The residual window (a line registered between the radius crossing and the flip) cannot be forced
    deterministically: not tested; reported as 0 lines (the nonce line is spoken before the arrival)."""
    fids = [F1, NEWCOMER]
    try:
        if not harness_ready(r):
            return
        ctx = inn_with_partner(r, rent=True, partner=True)
        if not ctx:
            return
        if not ctx["nu"]:
            return inc(r, "newcomer has no uuid")
        if unit_place(r, NEWCOMER, 600, 0, 0, 450, 750, "newcomer (far)") is None:
            return
        if near(r, 200, F1) != 0:
            return inc(r, "someone within 200 u before the scene")
        tn = ptail()
        witness_wait()
        checkpoint(r)
        if not scene_on(r):
            return
        if not tn.wait(r"\[IEB-SC\] PRIVATE 0->1", 25):
            return inc(r, "the scene never became private (PV-1 covers it)")
        tok = nonce("a")
        if not force_line(r, ctx["fu"], "*turns to you* %s" % tok, ctx["pu"]):
            return
        time.sleep(2)
        witness_wait()
        t = ptail()
        t0 = time.time()
        place(r, NEWCOMER, 120, 0, 0)
        m = t.wait(r"\[IEB-SC\] PRIVATE 1->0", 15, poll=0.5)
        dt = time.time() - t0
        r.check(bool(m), "IEB_ScenePrivate flipped 1 -> 0 after the arrival (%.1f s incl. controller latency)" % dt)
        r.check(bool(m) and dt <= 6.0, "within ~6 s of the placement (spec: about 2 s plus latency)")
        if not m:
            return
        time.sleep(3)
        txt = t.read()
        fired = len(re.findall(r"\[IEB-SC\] WITNESS scene rc=-?\d+", txt))
        skipped = len(re.findall(r"WITNESS skipped by the 60 s floor \(scene\)", txt))
        _LAST_WITNESS["t"] = time.time()
        r.log("  at the flip: (c) fired=%d, skipped by floor=%d" % (fired, skipped))
        if skipped:
            inc(r, "the 60 s floor swallowed the (c) event")
        else:
            r.check(fired == 1, "exactly one ieb_witness (c) at the flip (%d)" % fired)
        r.check(flag(r) == 0, "flag reads 0")
        nn, nf = hist_hits(r, ctx["nu"], tok), hist_hits(r, ctx["fu"], tok)
        if not nf:
            return inc(r, "control failed: the nonce line is not in the partner's own History")
        r.check(nn == 0, "the newcomer's History holds no line registered before the flip (%s)" % nn)
        r.log("  residual window: 0 lines (not forced; see docstring)")
    finally:
        back_to_market(r, fids)


@test("PV-4", "PV", reload=True)
def pv4(r):
    """Home (rule i), housecarl 300 u away, whisper on, SceneOn: flag 1 (the housecarl is outside the 200 u radius) and the
    housecarl's History lacks the scene line. Same setup as WH-4 (_home_case)."""
    _home_case(r, "PV-4", scene=True)


@test("PV-5", "PV", reload=True)
def pv5(r):
    """A private scene for 12 real minutes (720 s): no 'WITNESS scene' (trigger c) line is logged while the flag is 1. The
    Papyrus log is walked in order (PRIVATE 0->1 / 1->0, SCENE_ON/OFF, WITNESS scene). INCONCLUSIVE if the scene ended early, the
    flag was not 1 for at least 90 % of the samples, or the log shows a flip (then the test did not run as 'private throughout')."""
    DUR_S = 720
    try:
        ctx = inn_with_partner(r, rent=True, partner=True)
        if not ctx:
            return
        if near(r, 200, F1) != 0:
            return inc(r, "someone within 200 u before the scene")
        witness_wait()
        checkpoint(r)
        t = ptail()
        if not scene_on(r):
            return
        if not t.wait(r"\[IEB-SC\] PRIVATE 0->1", 25):
            return inc(r, "the scene never became private")
        t0, ones, samples, early = time.time(), 0, 0, False
        while time.time() - t0 < DUR_S:
            time.sleep(30)
            samples += 1
            ones += 1 if flag(r) == 1 else 0
            if re.search(r"\[IEB-SC\] (?:SCENE_OFF|PARTNER_LEFT)", t.read()):
                early = True
                break
        res = private_violations(t.read())
        r.log("  %d s, flag samples %d/%d at 1, log walk: %s" % (time.time() - t0, ones, samples, res))
        if early:
            return inc(r, "the scene ended before 12 minutes (%s)" % res)
        if res["flips"]:
            return inc(r, "the flag flipped during the run (%d); not private throughout" % res["flips"])
        if samples == 0 or ones < 0.9 * samples:
            return inc(r, "flag was 1 in only %d of %d samples" % (ones, samples))
        r.check(res["while_private"] == 0 and res["fired"] == 0, "no (c) event while the flag was 1 (%d fired)" % res["fired"])
    finally:
        back_to_market(r, [F1])
