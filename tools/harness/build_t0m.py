"""Build the T0-M test save (step 8 setup; time plan idea 13, investigation/round10/step8_time_plan.md:369-371, 437).
Route and citations: investigation/round10/t0m_builder.md.

T0-M = T0 plus: Breezehome bought (HousePurchase 0xA7B33 stage 10), the Whiterun housecarl (0xA2C9E stage 25,
ref 0xA2C94), polygamy on (TT_MARAS global 0x6), spouse 1 = F2 Uthgerd 0x91918 (married, stays F2: K-M3), spouse 2 =
Ysolda 0x1A69A (married, housed in Breezehome by MARAS, not a follower, not SA-posted), engaged = Athis 0x1A6D6.
F1 Jenassa 0xE1BA9 stays single (control). Status changes go through MARAS's own natives (IEB_TestCtl.MarasSet ->
MARAS.PromoteNPCToStatusByEnum), housing through IEB_TestCtl.MarasHouse (MARAS's MoveSpouseToHouse steps).

launch -> load T0 -> each step + its read-back (IEB_TestCtl.MarasProbe / MarasWorld) -> save "T0-M_build" -> reload
it -> re-verify everything -> save "T0-M" -> close. Any miss aborts with a reason and closes the game WITHOUT saving
T0-M. MARAS.log is only counted, never printed. Output: numbers and FormIDs only (no names, no quest text).

Usage: build_t0m.py [--overwrite]      (game and MO2 closed; needs the IEB_TestCtl pex with the Maras* functions)
"""
import os, re, sys, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import game
from tests_misc import con_args
from runner import Run, OUT
from fidnorm import fid_any_rx, fid_s32, fid_hex8

SAVE_FROM, SAVE_TMP, SAVE_TO = "T0", "T0-M_build", "T0-M"
F1 = 0x000E1BA9          # Jenassa: not touched (control)
SPOUSE1 = 0x00091918     # Uthgerd = F2 (ref; base 0x918E2 is in PotentialMarriageFaction, Skyrim.esm)
SPOUSE2 = 0x0001A69A     # Ysolda (ref of base 0x13BAB, tests_misc.py:31)
FIANCE = 0x0001A6D6      # Athis (ref of base 0x1A6D5, PotentialMarriageFaction)
HOUSECARL = 0x000A2C94   # ref of HousecarlWhiterun 0xA2C8E (initially disabled in Skyrim.esm)
BZ_DOOR = 0x0001A6F9     # Breezehome exterior door (HousePurchase alias WhiterunDoor, forced ref)
BZ_LOC = 0x0001F86F      # WhiterunBreezehomeLocation (carries LocTypePlayerHouse 0xFC1A3)
BZ_CELL = 0x000165A8     # WhiterunBreezehome (HousePurchase property WhiterunHouse)
PLAYER_FACTION = 0x00000DB1
JARL = 0x0001A677        # Whiterun Jarl ref (base 0x13BBD BalgruuftheGreater, Skyrim.esm ACHR)
QG_FACTION = 0x000A2CA2  # Favor253QuestGiverFaction: the 0xA2C9E QuestGiver alias needs it (USSEP QUST alias CTDA)
OUTSIDE = (0x0001B743, 0x0001B74F)   # Riverwood guard refs (Imperial01 / SonsOfSkyrim01): RiverwoodLocation 0x13163,
                                     # not a LocTypeDwelling; one of the two sets is enabled per civil-war state
RIVERWOOD_LOC = 0x00013163
TRY_QUEST_START = False   # 2026-10-11 runs 1-4: the quest never started (moveto) and the gate walk ran the game out of
                          # RAM (29.7 GB, guard close); RV-116 (7): enable the housecarl ref directly
WR_GATE_OUT = 0x0001B1F1  # Whiterun main gate, Tamriel side (load door, XTEL -> 0x1B1F3 in WhiterunWorld 0x1A26F)
HP_PRICE = 25000         # HPWhiterun 0xF728B, winner Nolvus Awakening Economy Patch.esp
MARAS_LOG = game.DOCS + "SKSE/MARAS.log"
LOG = []
RUN = [None]


class Abort(Exception):
    pass


def say(m):
    line = "%s %s" % (time.strftime("%H:%M:%S"), m)
    print(line, flush=True)
    LOG.append(line)


def kv(s):
    return dict(re.findall(r"(\w+)=(\S+)", s))


def call(fn, args, rx, timeout=30):
    """IEB_TestCtl call, then the first matching [IEB-TEST] line after it (case-insensitive: Papyrus case-folds)."""
    t = game.Tail(game.LOGS["papyrus"])
    RUN[0].ctl(fn, args, sync=False)
    return t.wait(r"(?i)\[IEB-TEST\] " + rx, timeout)


def world():
    m = call("MarasWorld", [], r"T0M_WORLD ([^\r\n]*)")
    if not m:
        raise Abort("no T0M_WORLD line (is the new IEB_TestCtl pex installed?)")
    return kv(m.group(1))


def probe(fid):
    m = call("MarasProbe", [fid_s32(fid)], r"T0M_PROBE (?:%s) ([^\r\n]*)" % fid_any_rx(fid))
    if not m:
        raise Abort("no T0M_PROBE line for %s" % fid_hex8(fid))
    return kv(m.group(1))


def iv(d, k):
    try:
        return int(float(d.get(k, "")))
    except ValueError:
        return None


def is_fid(val, fid):
    return bool(val) and re.search(fid_any_rx(fid), val) is not None


def need(ok, why):
    if not ok:
        raise Abort(why)


def con(cmd):
    from tests_misc import con_args
    RUN[0].tool("execute_console_command", con_args(cmd))


def step(n, name, detail):
    say("STEP %s %s: OK %s" % (n, name, detail))


def set_status(fid, status, settle):
    m = call("MarasSet", [fid_s32(fid), status], r"T0M_SET (?:%s) ([^\r\n]*)" % fid_any_rx(fid))
    need(m is not None, "no T0M_SET line for %s -> %d" % (fid_hex8(fid), status))
    d = kv(m.group(1))
    need(iv(d, "ok") == 1, "MARAS refused %s -> status %d (%s)" % (fid_hex8(fid), status, m.group(1)))
    time.sleep(settle)       # maras_status_changed is handled async (TTM_MainController.psc:87-106, SNRom_Bridge)
    return d


# ---------------------------------------------------------------- read-back rules (one place, used 3 times)

def check_spouse(fid, housed):
    p = probe(fid)
    tag = fid_hex8(fid)
    need(iv(p, "st") == 2, "%s MARAS status %s, want 2 (married)" % (tag, p.get("st")))
    need(iv(p, "r") == 4, "%s rank to player %s, want 4 (TTM_ServiceRelationships.psc:51)" % (tag, p.get("r")))
    need(iv(p, "trk") == 2, "%s TTM_TrackedNpcs rank %s, want 2" % (tag, p.get("trk")))
    for k in ("pmf", "pf", "bed"):
        need(iv(p, k) is not None and iv(p, k) >= 0, "%s not in married faction %s (%s)" % (tag, k, p.get(k)))
    for k in ("ask", "crt"):
        # rank -1 = removed (engine RemoveFromFaction on a runtime-added faction leaves rank -1; IsInFaction False:
        # MARAS ActorUtils.h:11-21); -2 = never a member. Both are "not in the faction" (run 6 aborted on -1).
        need(iv(p, k) is not None and iv(p, k) < 0, "%s still in engagement faction %s (%s)" % (tag, k, p.get(k)))
    if housed:
        need(iv(p, "housed") is not None and iv(p, "housed") >= 0, "%s not in TTM_SpouseHoused (%s)" % (tag, p.get("housed")))
        need(is_fid(p.get("house"), BZ_LOC), "%s tenant house %s, want %s" % (tag, p.get("house"), fid_hex8(BZ_LOC)))
        need(iv(p, "tm") == 0, "%s housed spouse is a teammate" % tag)
    else:
        need(iv(p, "housed") is not None and iv(p, "housed") < 0, "%s unexpectedly housed (%s)" % (tag, p.get("housed")))
    if iv(p, "rings") in (None, 0):
        say("  WARN %s holds no matrimony ring (only the engaged->married route gives one, "
            "TTM_ServiceMarriageQuest.psc:118-133)" % tag)
    return p


def check_fiance(fid):
    p = probe(fid)
    tag = fid_hex8(fid)
    need(iv(p, "st") == 1, "%s MARAS status %s, want 1 (engaged); a revert to 0 = the Relationships gate "
                            "(SNRom_Bridge OnMarasStatusChanged) undid it" % (tag, p.get("st")))
    need(iv(p, "r") == 3, "%s rank to player %s, want 3 (TTM_ServiceRelationships.psc:36)" % (tag, p.get("r")))
    need(iv(p, "trk") == 1, "%s TTM_TrackedNpcs rank %s, want 1" % (tag, p.get("trk")))
    for k in ("ask", "crt"):
        need(iv(p, k) is not None and iv(p, k) >= 0, "%s not in engagement faction %s (%s)" % (tag, k, p.get(k)))
    need(iv(p, "pmf") is not None and iv(p, "pmf") < 0, "%s already in PlayerMarriedFaction" % tag)
    need(iv(p, "lia") == 1, "%s does not fill LoveInterest of 0x74793 (StartEngagement, "
                            "TTM_ServiceMarriageQuest.psc:19-37)" % tag)
    return p


def check_world(base):
    w = world()
    need(iv(w, "poly") == 1, "polygamy global %s, want 1" % w.get("poly"))
    need(iv(w, "nMar") == base["nMar"] + 2, "MARAS married count %s, want %d" % (w.get("nMar"), base["nMar"] + 2))
    need(iv(w, "nEng") == base["nEng"] + 1, "MARAS engaged count %s, want %d" % (w.get("nEng"), base["nEng"] + 1))
    # hpVar 1 = bought, 2 = bought and entered (vanilla whiterundooraliasscript.psc:16-17 sets 2 on the first entry, which
    # step 5's DoorUse does); run 7 aborted on == 1
    need((iv(w, "hpVar") or 0) >= 1 and (iv(w, "key") or 0) >= 1 and is_fid(w.get("own"), PLAYER_FACTION),
         "house purchase state lost (hpVar=%s key=%s own=%s)" % (w.get("hpVar"), w.get("key"), w.get("own")))
    need(iv(w, "f25") == 1 and iv(w, "hcDis") == 0, "housecarl state lost (f25=%s hcDis=%s)" % (w.get("f25"), w.get("hcDis")))
    need(w.get("bzMarker") not in (None, "None"), "Breezehome has no MARAS house marker")
    return w


def verify_all(base, label):
    w = check_world(base)
    s1 = check_spouse(SPOUSE1, housed=False)
    s2 = check_spouse(SPOUSE2, housed=True)
    fi = check_fiance(FIANCE)
    f1 = probe(F1)
    need(iv(f1, "st") == base["f1st"], "F1 MARAS status changed (%s -> %s)" % (base["f1st"], f1.get("st")))
    say("VERIFY %s: OK world[%s] s1[st=%s r=%s tm=%s] s2[st=%s housed=%s house=%s] fiance[st=%s r=%s lia=%s] f1[st=%s]"
        % (label, " ".join("%s=%s" % (k, w.get(k)) for k in ("poly", "nMar", "nEng", "houses", "hpVar", "f25", "plPmf")),
           s1.get("st"), s1.get("r"), s1.get("tm"), s2.get("st"), s2.get("housed"), s2.get("house"),
           fi.get("st"), fi.get("r"), fi.get("lia"), f1.get("st")))


def where():
    m = call("PlayerWhere", [], r"PLAYERPOS cell=(\S+) ws=(\S+) x=(-?[\d.]+) y=(-?[\d.]+) z=(-?[\d.]+)")
    return list(m.groups()) if m else None


def maras_log_counts(start):
    """Counts only (CLAUDE rules: MARAS.log is never printed)."""
    if not os.path.exists(MARAS_LOG):
        return "MARAS.log missing"
    with open(MARAS_LOG, "rb") as f:
        f.seek(start if os.path.getsize(MARAS_LOG) >= start else 0)
        t = f.read().decode("utf-8", "replace")
    pats = {"status_events": r"Sent maras_status_changed", "set_status": r"Set status for NPC",
            "registered": r"Auto-registered NPC", "warn": r"\[warn", "error": r"\[error"}
    return " ".join("%s=%d" % (k, len(re.findall(p, t, re.I))) for k, p in pats.items())


# ---------------------------------------------------------------- the build

def build():
    run = RUN[0]
    say("STEP 0 load %s" % SAVE_FROM)
    need(game.load(run, SAVE_FROM, None), "load %s failed" % SAVE_FROM)
    mlog0 = os.path.getsize(MARAS_LOG) if os.path.exists(MARAS_LOG) else 0

    # 1. preconditions
    w0 = world()
    need(iv(w0, "hadWed") == 0, "PlayerHadWedding set: MARAS would open a modal box on engagement "
                                "(TTM_ServiceRelationships.psc:20-22)")
    need(iv(w0, "skipWed") == 0, "SkipWedding set: an engagement would become a marriage at once "
                                 "(TTM_ServiceRelationships.psc:26-31)")
    need(not (iv(w0, "mqRun") == 1 and (iv(w0, "mqStage") or 0) >= 20),
         "0x74793 running at stage %s (>= 20: StartEngagement would refuse, TTM_ServiceMarriageQuest.psc:24-27)"
         % w0.get("mqStage"))
    for fid in (SPOUSE1, SPOUSE2, FIANCE):
        p = probe(fid)
        need(iv(p, "st") in (-1, 0), "%s already has MARAS status %s in %s" % (fid_hex8(fid), p.get("st"), SAVE_FROM))
        need(iv(p, "dis") == 0, "%s is disabled" % fid_hex8(fid))
    f1 = probe(F1)
    base = {"nMar": iv(w0, "nMar"), "nEng": iv(w0, "nEng"), "f1st": iv(f1, "st"), "gold": iv(w0, "gold")}
    pos = where()
    need(pos is not None, "no PLAYERPOS line")
    step(1, "preconditions", "nMar=%s nEng=%s nAll=%s houses=%s hpVar=%s f25=%s ws=%s"
         % (w0.get("nMar"), w0.get("nEng"), w0.get("nAll"), w0.get("houses"), w0.get("hpVar"), w0.get("f25"), pos[1]))

    # 2. polygamy: the MCM toggle is this global (TTM_MCM_SettingsPage.psc:110-111, TTM_Utils.psc:16-24)
    con("set TTM_EnablePolygamyToggle to 1")
    time.sleep(2)
    w = world()
    need(iv(w, "poly") == 1, "polygamy global %s after set" % w.get("poly"))
    step(2, "polygamy", "poly=1")

    # 3. Breezehome: HousePurchase stage 10, log entry 0 (GetInCurrentLoc WhiterunLocation) -> Fragment_0 ->
    #    HousePurchaseScript.PurchaseHouse (gold, key, guide, cell owner) + WhiterunHouseVar = 1
    if iv(w, "hpVar") == 1:
        step(3, "house", "already owned in %s (hpVar=1)" % SAVE_FROM)
    else:
        con("player.additem 0000000F %d" % HP_PRICE)
        time.sleep(1)
        wg = world()        # RV-123 (3): read the gold back before the purchase depends on it
        need(base["gold"] is not None and (iv(wg, "gold") or 0) >= base["gold"] + HP_PRICE,
             "player.additem gold: gold %s, want >= %s + %d" % (wg.get("gold"), base["gold"], HP_PRICE))
        con("setstage 000A7B33 10")
        w = None
        for _ in range(10):
            time.sleep(2)
            w = world()
            if iv(w, "hpVar") == 1:
                break
        need(iv(w, "hpVar") == 1, "WhiterunHouseVar %s after setstage (log entry 0 needs the player in WhiterunLocation; "
                                  "player loc=%s)" % (w.get("hpVar"), w.get("loc")))
        need((iv(w, "key") or 0) >= 1, "no Breezehome key 0x93B08 (key=%s)" % w.get("key"))
        need(is_fid(w.get("own"), PLAYER_FACTION), "Breezehome cell owner %s, want PlayerFaction" % w.get("own"))
        if iv(w, "gold") != base["gold"]:
            say("  WARN gold %s -> %s (price differs from %d?)" % (base["gold"], w.get("gold"), HP_PRICE))
        step(3, "house", "hpVar=1 key=%s own=%s gold %s->%s" % (w.get("key"), w.get("own"), base["gold"], w.get("gold")))

    # 4. housecarl: 0xA2C9E stage 25 -> Fragment_12 (enables PlayerHousecarl, gives the reward, sets 200)
    if iv(w, "f25") == 1 and iv(w, "hcDis") == 0:
        step(4, "housecarl", "already done in %s" % SAVE_FROM)
    else:
        # 2026-10-11 run 1 ABORTed here: 0xA2C9E is a Change Location story-manager quest (ENAM CLOC; alias Location
        # filled From Event L2, USSEP override; SMQN 0xC0609: L2 == WhiterunLocation 0x18A56; parent SMBN 0xB2440: L2 has
        # LocTypeHabitation, L1 lacks LocTypeDwelling), so a console setstage cannot start it (no event data), and its
        # QuestGiver alias also needs the Jarl in Favor253QuestGiverFaction (normally added by the favour system).
        # Recreate that: faction on the Jarl, the player out to Riverwood (not a Dwelling) and back into WhiterunLocation
        # (the CLOC event that starts the quest), then the stage. INFERRED: a console moveto fires the CLOC event.
        def stage25(tries):
            con("setstage 000A2C9E 25")
            for _ in range(tries):
                time.sleep(2)
                ww = world()
                if iv(ww, "f25") == 1 and iv(ww, "hcDis") == 0:
                    return ww
            return ww
        if not TRY_QUEST_START:
            w = {"f25": "0"}            # RV-116 (7): straight to the direct enable below
        else:
            con("%08X.addfac %08X 0" % (JARL, QG_FACTION))
            time.sleep(2)
            out = None
            for ref in OUTSIDE:
                con("player.moveto %08X" % ref)
                time.sleep(12)
                w = world()
                if is_fid(w.get("loc"), RIVERWOOD_LOC):
                    out = ref
                    break
                say("  moveto %08X: loc=%s, not RiverwoodLocation" % (ref, w.get("loc")))
            need(out is not None, "could not reach RiverwoodLocation for the location-change start (loc=%s)" % w.get("loc"))
            con("player.moveto %08X" % BZ_DOOR)
            time.sleep(15)
            wb = world()    # RV-123 (3): the moveto read back (left RiverwoodLocation) before the stage depends on it
            need(not is_fid(wb.get("loc"), RIVERWOOD_LOC), "player.moveto %08X: still in RiverwoodLocation (loc=%s)"
                 % (BZ_DOOR, wb.get("loc")))
            w = stage25(10)
            if iv(w, "f25") != 1:
                # REVIEW_LOG RV-114 (3): if a console moveto does not fire the location event, walk in through the gate
                say("  moveto re-entry did not start the quest; walking in through the Whiterun gate (DoorUse %08X)"
                    % WR_GATE_OUT)
                p0 = where()
                con("player.moveto %08X" % WR_GATE_OUT)
                time.sleep(12)
                p1 = where()    # RV-123 (3): the moveto read back (cell changed or moved > 300 u) before DoorUse
                need(p0 is not None and p1 is not None and (p1[0] != p0[0] or abs(float(p1[2]) - float(p0[2]))
                                                            + abs(float(p1[3]) - float(p0[3])) > 300),
                     "player.moveto %08X: player did not move (%s -> %s)" % (WR_GATE_OUT, p0, p1))
                call("DoorUse", [WR_GATE_OUT], r"DoorUse[^\r\n]*", 30)
                time.sleep(20)
                w = stage25(10)
            if iv(w, "f25") != 1:
                # Diagnostics for the reviewer (numbers only): does the console return output over MCP (INFERRED), and
                # what are the Jarl's JobJarlFaction (0x50920, rank -1 in every NPC_ override) / questgiver faction ranks
                for cmd in ("%08X.getfactionrank 00050920" % JARL, "%08X.getfactionrank %08X" % (JARL, QG_FACTION),
                            "%08X.getdisabled" % JARL, "%08X.getdead" % JARL):
                    try:
                        res = RUN[0].tool("execute_console_command", con_args(cmd))
                    except Exception as e:
                        res = type(e).__name__
                    say("  DIAG %s -> %s" % (cmd, str(res)[:160]))
        if iv(w, "f25") != 1:
            # REVIEW_LOG RV-116 (7): the formal quest is dropped from T0-M; the housecarl ref is enabled directly.
            # T0M_WORLD keeps f25=0 / f200=0 (recorded in the build log); tests needing the quest's PlayerHousecarl
            # alias say so by ID (see t0m_builder.md).
            say("  housecarl quest did not start (loc=%s); RV-116 (7): enabling the housecarl ref directly" % w.get("loc"))
            # run 5: "<ref>.enable" left it disabled (no enable parent: ACHR flags 0x800/0xC00 only). Log the MCP response of
            # each form and fall back to prid + enable (INFERRED: the console may not take a bare hex ref prefix over MCP)
            # RV-123: only the target_form_id form reaches the ref (con_args); prid + bare command runs on the player
            for cmds in (["%08X.enable" % HOUSECARL],):
                for c in cmds:
                    try:
                        res = RUN[0].tool("execute_console_command", con_args(c))
                    except Exception as e:
                        res = type(e).__name__
                    say("  CONSOLE %s -> %s" % (c, str(res)[:200]))
                for _ in range(5):
                    time.sleep(2)
                    w = world()
                    if iv(w, "hcDis") == 0:
                        break
                if iv(w, "hcDis") == 0:
                    say("  housecarl enabled by: %s" % " ; ".join(cmds))
                    break
            need(iv(w, "hcDis") == 0, "housecarl 0x%08X still disabled after enable" % HOUSECARL)
            step(4, "housecarl", "DIRECT (quest not started) f25=%s f200=%s hcDis=0" % (w.get("f25"), w.get("f200")))
        else:
            need(iv(w, "hcDis") == 0, "housecarl 0xA2C94 still disabled")
            step(4, "housecarl", "f25=1 f200=%s hcDis=0" % w.get("f200"))

    # 5. MARAS registers the house when the player enters a LocTypePlayerHouse location (TTM_PlayerScript.psc:65-71,
    #    TTM_ServicePlayerHouse.psc:17-28). Enter through the front door (fallback coc), wait for the marker.
    if w.get("bzMarker") in (None, "None"):
        call("DoorUse", [BZ_DOOR], r"DoorUse[^\r\n]*", 30)
        for i in range(30):
            time.sleep(3)
            w = world()
            if w.get("bzMarker") not in (None, "None"):
                break
            if i == 10 and not is_fid(w.get("cell"), BZ_CELL):
                say("  door route did not reach the house (cell=%s); coc fallback" % w.get("cell"))
                con("coc WhiterunBreezehome")
        need(w.get("bzMarker") not in (None, "None"), "MARAS never registered Breezehome (cell=%s loc=%s houses=%s)"
             % (w.get("cell"), w.get("loc"), w.get("houses")))
    step(5, "house registered with MARAS", "houses=%s marker=%s" % (w.get("houses"), w.get("bzMarker")))

    # 6. spouse 1 (F2): engaged -> married (MARAS's own order; married runs SkipWedding's ring + quest reset)
    set_status(SPOUSE1, 1, 10)
    pe = probe(SPOUSE1)
    say("  spouse 1 after engaged: st=%s r=%s lia=%s" % (pe.get("st"), pe.get("r"), pe.get("lia")))
    set_status(SPOUSE1, 2, 10)
    p = check_spouse(SPOUSE1, housed=False)
    step(6, "spouse 1 married", "st=2 r=4 pmf=%s pf=%s bed=%s rings=%s tm=%s" % (p.get("pmf"), p.get("pf"), p.get("bed"),
                                                                             p.get("rings"), p.get("tm")))

    # 7. spouse 2: engaged -> married -> housed in Breezehome
    set_status(SPOUSE2, 1, 10)
    pe = probe(SPOUSE2)
    say("  spouse 2 after engaged: st=%s r=%s lia=%s" % (pe.get("st"), pe.get("r"), pe.get("lia")))
    set_status(SPOUSE2, 2, 10)
    check_spouse(SPOUSE2, housed=False)
    m = call("MarasHouse", [fid_s32(SPOUSE2), fid_s32(BZ_LOC)], r"T0M_HOUSE (?:%s) ([^\r\n]*)" % fid_any_rx(SPOUSE2))
    need(m is not None and iv(kv(m.group(1)), "ok") == 1, "MarasHouse failed: %s" % (m.group(1) if m else "no line"))
    time.sleep(3)
    p = check_spouse(SPOUSE2, housed=True)
    step(7, "spouse 2 married + housed", "st=2 housed=%s house=%s tm=%s" % (p.get("housed"), p.get("house"), p.get("tm")))

    # 8. the engaged NPC (last: StartEngagement needs 0x74793 below stage 20, reset by the marriages above)
    set_status(FIANCE, 1, 15)
    p = check_fiance(FIANCE)
    step(8, "engaged", "st=1 r=3 ask=%s crt=%s lia=1" % (p.get("ask"), p.get("crt")))

    # 9. back to the T0 spot (exterior worldspace), as T0's tests expect
    w = world()
    if is_fid(w.get("cell"), BZ_CELL):
        call("DoorUse", [0], r"DoorUse[^\r\n]*", 30)
        time.sleep(15)
        here = where()
        if not here or here[1] != pos[1]:
            con("player.moveto %s" % fid_hex8(BZ_DOOR))
            time.sleep(15)
    if pos[1] not in ("None", "0x00000000"):
        call("PlayerPlace", [float(pos[2]), float(pos[3]), float(pos[4])], r"PLAYERPOS[^\r\n]*", 30)
    here = where()
    need(here is not None and here[1] == pos[1] and abs(float(here[2]) - float(pos[2])) < 300
         and abs(float(here[3]) - float(pos[3])) < 300, "player not back at the T0 spot (T0 %s, now %s)" % (pos, here))
    step(9, "player back at the T0 spot", "ws=%s" % here[1])

    # 10. settle, then the full read-back (catches async reverts)
    time.sleep(20)
    verify_all(base, "before save")
    say("  MARAS.log counts since load: %s" % maras_log_counts(mlog0))
    step(10, "full read-back", "")

    # 11. save a build copy, reload it, verify again: T0-M is only written from a verified reload
    need(game.save(run, SAVE_TMP), "save %s failed" % SAVE_TMP)
    need(game.load(run, SAVE_TMP, None), "reload %s failed" % SAVE_TMP)
    verify_all(base, "after reload")
    step(11, "persisted across save/load", SAVE_TMP)
    need(game.save(run, SAVE_TO), "save %s failed" % SAVE_TO)
    step(12, "saved", SAVE_TO)
    return True


def main():
    if game.procs():
        sys.exit("ABORT: game or MO2 running")
    if not os.path.exists(game.SAVES + SAVE_FROM + ".ess"):
        sys.exit("ABORT: %s.ess not found" % SAVE_FROM)
    if os.path.exists(game.SAVES + SAVE_TO + ".ess") and "--overwrite" not in sys.argv:
        sys.exit("ABORT: %s.ess exists (pass --overwrite to rebuild it)" % SAVE_TO)
    run_id = "T0M_build_%s" % time.strftime("%Y%m%d-%H%M%S")
    game.set_archive(run_id)
    ok = False
    try:
        if not game.harness_mode():
            need(game.set_harness_mode(True, say), "harness mode could not be set on (Harness.yaml read-back)")
        if not game.launch(say, voices=False):
            raise Abort("launch refused or failed")
        RUN[0] = Run("T0M_BUILD")
        ok = build()
    except Abort as e:
        say("ABORT: %s (T0-M NOT saved)" % e)
    except Exception as e:
        say("ERROR: %r (T0-M NOT saved)" % e)
    finally:
        if game.procs():
            game.close(None, timeout=120, force=True)
        game.archive_logs("t0m_build")
        if RUN[0] is not None:
            RUN[0].lines.extend(LOG)
            RUN[0].fails += 0 if ok else 1
            RUN[0].save()
        os.makedirs(OUT, exist_ok=True)
        open(OUT + run_id + ".txt", "w", encoding="utf-8").write("\n".join(LOG) + "\n")
        say("T0-M BUILD %s" % ("DONE" if ok else "FAILED"))
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
