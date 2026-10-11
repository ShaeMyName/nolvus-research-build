"""U1 tests, families TM and L (TASK_C step 8; drafted 2026-10-10, not yet run).

TM: investigation/round3/s10_teammate_flag.md §4.3 (spec BRIDGE_SPEC_V2.md row "TM-1 ... TM-13", line ~3466).
    Implemented here: TM-1, TM-2, TM-4, TM-5, TM-8, TM-10, TM-11, TM-12, TM-13. (TM-3 -> CF block; TM-6/7/9 -> S-A.)
L:  BRIDGE_SPEC_V2.md §15.3 rows L-1 ... L-10 (lines ~3439-3448). Implemented here: L-1, L-2, L-3, L-4, L-6, L-7, L-9,
    L-10. (L-5, L-8 -> S-A.)
Routes per test: investigation/round10/step8_time_plan.md §3 (lines 127-144).

New IEB_TestCtl wrappers this module calls (proposed in the report; not in IEB_TestCtl.psc yet):
    DoorUse(door)  SneakRun(formId, seconds, sneak)  NFFCombatAware(value)  SpawnHostile(base)  Despawn()
    SetDropTeammate(value)  Probe(formId)  ExpectLend(formId)  Speak(formId, thought)  CampMuster(chief, on)
    KillAndSave(formId, save)
Until they exist, the tests that need them end INCONCLUSIVE (their log line never appears).

Output discipline (Shae's rules): PASS/FAIL lines, FormIDs, counts, request ids. Request-log checks print booleans only,
never prompt text. No quest, journal or dialogue text is printed.

Labels in comments: VERIFIED = read in source/data (file:line); INFERRED = not read, reasoned.
Path prefixes: IEB_Main = build/src/errandbridge/Source/Scripts/IEB_Main.psc; IEB_SALib likewise; TestCtl / Watcher =
build/src/harness/Source/Scripts/IEB_TestCtl.psc / IEB_Watcher.psc; IE_Core / IE_SE = build/src/intelengine/Source/
Scripts/IntelEngine_Core.psc / IntelEngine_StoryEngine.psc (patched build); IE_Travel / IE_Tasks = repos/IntelEngine-Gerk/
Source/Scripts/IntelEngine_Travel.psc / IntelEngine_NPCTasks.psc (3.5.1 5b69e41); SA = C:/Nolvus/.../mods/SeverActions/
Source/Scripts/; FM = SA SeverActions_FollowerManager.psc; ENT = SA SeverActions_Enterprises.psc.
"""
import os, re, time
import game
from block import test, settle_probe
from fidnorm import fid_norm, fid_any_rx, fid_hex8   # one FormID normaliser (REVIEW_LOG R48)

# ---------------------------------------------------------------- cast (AGENT_BRIEF.md T0 table; Skyrim.esm refs)
PLAYER = 0x14
PLAYER_NAME = "Prisoner"
F1, F2, H, G, CARLOTTA = 0x000E1BA9, 0x00091918, 0x0002C90F, 0x0001A680, 0x0001A675
NAMES = {F1: "Jenassa", F2: "Uthgerd", H: "Brenuin", G: "Anoriath", CARLOTTA: "Carlotta Valentia", PLAYER: PLAYER_NAME}
CHIEF = 0x0003F7AC                      # C: Valtheim Towers chief ref (brief)
WOLF = 0x00023ABE                       # NPC_ EncWolf, VERIFIED gamedata/Skyrim.esm (esp_dump NPC_, 2026-10-10)

# Load doors: REFR + XTEL pairs read from gamedata/Skyrim.esm (scratch scan of every REFR with XTEL, 2026-10-10). VERIFIED.
# Exterior refs sit in WhiterunWorld's persistent cell 0x1A270; positions (x, y) given for orientation.
DOOR_BELETHOR_EXT, DOOR_BELETHOR_INT, CELL_BELETHOR = 0x0001A6F5, 0x00016607, 0x000165B3   # ext (24208,-8212)
DOOR_ARCADIA_EXT, DOOR_ARCADIA_INT, CELL_ARCADIA = 0x0001A6F3, 0x000165C9, 0x000165B6      # ext (24939,-8409)
DOOR_MARE_EXT, DOOR_MARE_INT, CELL_MARE = 0x0001A6F4, 0x00016072, 0x0001605E               # ext (25726,-7631)
HOME_REF = CARLOTTA       # "market": Carlotta's stall (she is the settle probe, so she is loaded there by day)
# [CHANGED 2026-10-10, U1 run 17 TM-8: the player ended up clipped inside a wall] A moveto onto a DOOR ref puts the
# player at the door's own position, inside the door frame. AWAY_REF is now the Whiterun map marker (GATE, 0x000162CE,
# (19855,-7423); map markers sit on the navmesh), 5,874 u from the Bannered Mare door, same worldspace, still > N.
AWAY_REF = 0x000162CE     # was 0x0001A6F7, the Drunken Huntsman exterior door (21716,-6742): ~4100 u from the Mare door, same
                          # worldspace. > N = 0.75 x 2560 = 1920 (IEB_RejoinWarpFactor default, gen_errandbridge.py:23;
                          # NFF warp range default 2560, IEB_NFFLib.psc:87), so RejoinTest is false while F stays loaded.

# GoToLocation destination names. "Bannered Mare" and "Riverwood" are the v1 test names (BRIDGE_INVESTIGATION.md
# §5.5 tests 1, 5); "Jorrvaskr" is INFERRED to resolve (IntelEngine's native name resolution, IE_Travel:223). Lists are
# tried in order until the bridge logs a decision (no decision within 10 s = the name did not resolve, INFERRED).
DEST_NEAR = ["Bannered Mare"]                   # ends INSIDE: IE walks to the door, then teleports through (VERIFIED U1 run 16, 14:34:06)
DEST_WALK = ["Jorrvaskr", "Riverwood"]          # >= 30 s of walking in view of the market
DEST_TM1 = ["Jorrvaskr", "Bannered Mare"]       # "2 cells away" (Jorrvaskr ~5000 u from the market)

REQLOG = ("C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/SkyrimNet Test - Output/SKSE/Plugins/SkyrimNet/logs/"
          "openrouter_input.log")   # VERIFIED path on disk 2026-10-10; INSTALL_LOG.md:222; time plan R2 (line 61)

_TM1_WINDOW = {}     # TM-1 leaves its Papyrus and SA-log windows here for TM-12


# ---------------------------------------------------------------- small helpers

def tail(key):
    return game.Tail(REQLOG if key == "req" else game.LOGS[key])


def hexarg(fid):
    return "0x" + fid_hex8(fid)


def fid_rx(fid):
    """FormID in any printed form (fidnorm.fid_any_rx): PO3 IntToString(id, true) '0xE1BA9' / '0xFE499A4B' (VERIFIED
    Papyrus.0.log 2026-10-10), SA {:08X}, signed / unsigned decimal; whole token. Signed or unsigned fid accepted."""
    return fid_any_rx(fid)


def nm(fid):
    n = fid_norm(fid)
    return NAMES.get(n, NAMES.get(fid, "%08X" % n))


def inconclusive(r, why):
    r.inconclusive += 1
    r.log("INCONCLUSIVE %s %s" % (r.name, why))


def console(r, cmd):
    return r.tool("execute_console_command", {"command": cmd})


# Door refs: never a player.moveto target (lands inside the door frame / wall).
DOOR_REFS = {0x0001A6F7, DOOR_ARCADIA_EXT, DOOR_ARCADIA_INT, DOOR_MARE_EXT, DOOR_MARE_INT, DOOR_BELETHOR_EXT, DOOR_BELETHOR_INT}


def moveto(r, ref, settle=6):
    if ref in DOOR_REFS:
        raise ValueError("harness: player.moveto onto a door ref %08X puts the player inside the wall" % ref)
    console(r, "player.moveto %08X" % ref)
    time.sleep(settle)


def ctl_wait(r, fn, args, pattern, timeout=15):
    """IEB_TestCtl calls over MCP are asynchronous (INFERRED; Kinship README per t0_setup_research.md:279): wait on the
    Papyrus log line the call writes."""
    t = tail("papyrus")
    r.ctl(fn, args)
    return t.wait(pattern, timeout=timeout)


def sa_call(r, script, fn, args):
    """SeverActions quest functions over MCP: quest 'SeverActions' (0xD62) carries every SA script, VERIFIED VMAD of the
    installed SeverActions.esp (vmad_props.py, 2026-10-10). Actor args as hex strings (AGENT_BRIEF.md:38)."""
    return r.tool("execute_quest_function", {"quest_editor_id": "SeverActions", "script_name": script,
                                             "function_name": fn, "arguments": args})


FIELDS = {
    "rt": r"\brt=([\d.]+)", "tm": r"\btm=([01])", "wfp": r"\bwfp=(-?[\d.]+)", "pkg": r"\bpkg=(\S+)",
    "ovr": r"\bovr=(-?\d+)", "dDest": r"\bdDest=(\S+)", "dPlayer": r"\bdPlayer=(\S+)", "pos": r"\bpos=(\S+)",
    "loaded": r"\bloaded=([01])", "ieSlot": r"\bieSlot=(-?\d+)", "iebHeld": r"\biebHeld=(\d+)",
    "iebLent": r"\biebLent=(\d+)", "iebGate": r"\biebGate=(\d+)", "guardIdx": r"\bguardIdx=(-?\d+)",
    "musterAlias": r"\bmusterAlias=(-?\d+)", "combat": r"\bcombat=([01])", "dead": r"\bdead=([01])",
    "iebKeys": r"\biebKeys=(\w+)", "saSandbox": r"\bsaSandbox=(\w+)", "seat": r"\bnffSeat=(-?\d+)",
}


def parse_line(line):
    """One IEB_Watcher.Line (Watcher:85-146) as a dict. VERIFIED field names and order."""
    d = {}
    for k, rx in FIELDS.items():
        m = re.search(rx, line)
        if m:
            d[k] = m.group(1)
    m = re.search(r"\bcell=(\S+?):.*?:([01]) loaded=", line)
    d["cell"], d["interior"] = (m.group(1), m.group(2) == "1") if m else ("None", None)
    m = re.search(r"\bschedIdx=(-?\d+)/(-?\d+)/(-?\d+)", line)
    d["sched"] = tuple(int(x) for x in m.groups()) if m else None
    for k in ("tm", "loaded", "ieSlot", "iebHeld", "iebLent", "iebGate", "guardIdx", "musterAlias", "combat", "dead",
              "ovr", "seat"):
        if k in d:
            d[k] = int(d[k])
    for k in ("wfp", "rt"):
        if k in d:
            d[k] = float(d[k])
    for k in ("dDest", "dPlayer"):
        try:
            d[k + "_n"] = float(d.get(k, "x"))
        except ValueError:
            d[k + "_n"] = None
    try:
        d["xyz"] = tuple(float(v) for v in d.get("pos", "").split(","))
        if len(d["xyz"]) != 3:
            d["xyz"] = None
    except ValueError:
        d["xyz"] = None
    for k in ("iebKeys", "saSandbox"):
        if k in d:
            d[k] = d[k].lower() == "true"
    return d


def actor_lines(text, fid):
    """Watcher / probe lines for one actor ("<name> <hex> cell=", Watcher:118-119). Matched on the id token right before
    " cell=" only (R48): a name missing from NAMES (an FE camp member, a spawned ref) or a short one ("Uthgerd" vs the
    display name "Uthgerd the Unbroken") no longer makes every line miss."""
    rx = re.compile(r" %s cell=" % fid_rx(fid), re.I)
    return [parse_line(l) for l in text.splitlines() if rx.search(l)]


def probe(r, fid, timeout=10):
    """Probe wrapper (proposed): '[IEB-TEST] probe <Watcher.Line> iebKeys=<b> saSandbox=<b>'."""
    m = ctl_wait(r, "Probe", [fid], r"\[IEB-TEST\] probe [^\n]* %s cell=[^\n]*" % fid_rx(fid), timeout)
    return parse_line(m.group(0)) if m else None


def decision(t, fid, timeout=10):
    """The bridge's decision for a take (IEB_Main:251, 257, 278, 293, 320): TAKE / TAKE_SKIP / LEND / REFUSE."""
    return t.wait(r"(?i)\[IEB\] (TAKE|TAKE_SKIP|LEND|REFUSE) actor=%s\b[^\n]*" % re.escape(nm(fid)), timeout=timeout)


def start_errand(r, fid, dests, timeout=10):
    """GoToLocation through TestCtl.StartTask (TestCtl:49-87; speed 1, waitForPlayer 0 = self-motivated, so the end is a
    3 game-hour linger deadline, IE_Travel:612-623, 38). Returns (dest, decision line) or (None, None)."""
    for dest in dests:
        t = tail("papyrus")
        r.ctl("StartTask", [fid, "GoToLocation", dest, "", ""])
        m = decision(t, fid, timeout)
        if m:
            r.log("  errand %s -> %s: %s" % (nm(fid), dest, m.group(0).split("[IEB] ")[-1]))
            return dest, m.group(0)
        r.log("  errand %s -> %s: no bridge decision in %d s (name unresolved, or an IE confirmation box?)"
              % (nm(fid), dest, timeout))
    return None, None


def wait_arrival(t, fid, timeout):
    """IE_Travel:642 / :647: 'IntelEngine: <name> arrived at <dest> (self-motivated|waiting)' (DebugMsg always traces,
    IE_Core:1798-1799). VERIFIED."""
    return t.wait(r"IntelEngine: %s arrived at " % re.escape(nm(fid)), timeout=timeout)


def release_f(r, fid, timeout=40):
    """Recall(F, 0) = CancelCurrentTask stayHere 0 (TestCtl:135-143 -> IEB_Main.CancelOrRecall:754-797)."""
    t = tail("papyrus")
    r.ctl("Recall", [fid, 0])
    m = t.wait(r"(?i)\[IEB\] (RELEASE_FOLLOW|RELEASE_STAY|RELEASE_SEATLOST|RELEASE_DEAD|RELEASE|REJOIN_DONE|"
               r"REJOIN_TO_WAIT|REJOIN_CANCELLED) actor=%s\b[^\n]*" % re.escape(nm(fid)), timeout=timeout)
    if not m:
        m = t.wait(r"(?i)\[IEB\] RECALL_REQ actor=%s\b[^\n]*" % re.escape(nm(fid)), timeout=1)
    r.log("  release %s: %s" % (nm(fid), m.group(0).split("[IEB] ")[-1] if m else "no release line"))
    return m


def restore_lend(r, fid, timeout=40):
    """Cancel the lent NPC's slot (TestCtl.Cancel:127-133) and wait for LEND_RESTORE (IEB_Main:474-489)."""
    t = tail("papyrus")
    r.ctl("Cancel", [fid])
    m = t.wait(r"(?i)\[IEB\] LEND_RESTORE(?:_SKIP)? actor=%s\b[^\n]*" % re.escape(nm(fid)), timeout=timeout)
    r.log("  restore %s: %s" % (nm(fid), m.group(0).split("[IEB] ")[-1] if m else "no LEND_RESTORE"))
    return m


def check_inv(r, fid, what="invariants (TestCtl.Check)"):
    """TestCtl.Check:157-162 -> Watcher.CheckInvariants:222-282 (I1-I4 against the Snapshot baseline)."""
    m = ctl_wait(r, "Check", [fid], r"\[IEB-TEST\] Check %s -> (\w+)" % re.escape(nm(fid)), 15)
    r.check(bool(m) and m.group(1).lower() == "true", "%s %s" % (nm(fid), what))


class Accelerated:
    """Accelerate(1000) for a GAME-clock timeout only (Shae's D3 rule; AGENT_BRIEF.md:47-49): always restored on exit,
    then ASSERT PASS TIMESCALE required (TestCtl:339-371)."""

    def __init__(self, r, ts=1000.0):
        self.r, self.ts, self.ok = r, ts, False

    def __enter__(self):
        m = ctl_wait(self.r, "Accelerate", [self.ts], r"TIMESCALE accelerated to|ASSERT FAIL TIMESCALE[^\n]*", 10)
        self.ok = bool(m) and m.group(0).startswith("TIMESCALE")
        if not self.ok:
            self.r.log("  Accelerate refused or silent: %s" % (m.group(0) if m else "no log line"))
        return self

    def __exit__(self, *exc):
        m = ctl_wait(self.r, "RestoreTimescale", [], r"ASSERT (PASS|FAIL) TIMESCALE", 15)
        self.r.check(bool(m) and m.group(1) == "PASS", "timescale restored to the recorded value")
        return False


def timeout_at_dest(r, fid, arrive_timeout=180):
    """Drive a self-motivated GoToLocation to its plain-ClearSlot exit: wait for arrival at normal speed, then accelerate
    only for the 3 game-hour linger deadline (IE_Travel:621-623 SELF_MOTIVATED_LINGER_HOURS = 3.0 :38) -> OnWaitTimeout
    -> ClearSlot(slot, false) (IE_Travel:923-970; 'IntelEngine: <name>: Wait timeout at', :928). VERIFIED code path;
    at 1000x the 3 h take ~11 real s. The player must be > 1000 u away and not in the NPC's cell, or the linger path
    (ClearSlotRestoreFollower) runs instead (IE_Travel:673-694)."""
    pap = r.tails["papyrus"]
    if not wait_arrival(pap, fid, arrive_timeout):
        return None
    t = tail("papyrus")
    with Accelerated(r) as acc:
        if not acc.ok:
            return None
        m = t.wait(r"IntelEngine: %s: Wait timeout at " % re.escape(nm(fid)), timeout=90)
    return m


def req_blocks(text):
    """openrouter_input.log request blocks: '[ts] [tag] <Generate|GenerateStreaming> request [req_id]:' then the JSON
    with raw content lines (VERIFIED sample investigation/round10/logs/openrouter_input.log:1, 174)."""
    hs = list(re.finditer(r"^\[[^\]]+\] \[([a-z_]*)\] \w+ request \[(req_[0-9a-f_]+)\]:", text, re.M))
    for i, h in enumerate(hs):
        yield h.group(1), h.group(2), text[h.end():hs[i + 1].start() if i + 1 < len(hs) else len(text)]


def snapshot(r, fid):
    ctl_wait(r, "Snapshot", [fid], r"\[IEB-TEST\] snapshot [^\n]*%s" % re.escape(nm(fid)), 10)


# ================================================================ TM (S-10 teammate kept)

@test("TM-1", "TM")
def tm1(r):
    """GoToLocation ~2 cells away; the player goes the other way. Pass: F's flag stays 1; F arrives; 'Kept follower as
    teammate' and no 'Dismissed follower' (IE_Core:1069-1075, VERIFIED patched build)."""
    nmF = nm(F1)
    snapshot(r, F1)
    w = tail("watch")
    sa = tail("sa")
    dest, d = start_errand(r, F1, DEST_TM1)
    try:
        if not d:
            return inconclusive(r, "no TAKE for F1")
        r.check(d.startswith("[IEB] TAKE") and "mode=1" in d, "F1 taken and parked (TAKE mode=1)")
        if dest != DEST_TM1[0]:
            r.log("NOTE TM-1: fell back to %s (closer than 2 cells)" % dest)
        moveto(r, AWAY_REF)        # INFERRED: moveto stands in for "the player walks the other way" (time plan:127)
        arrived = wait_arrival(r.tails["papyrus"], F1, 240)
        samples = actor_lines(w.read(), F1)
        held = [s for s in samples if s.get("iebHeld") == 1]
        r.check(len(held) >= 3 and all(s.get("tm") == 1 for s in held),
                "teammate flag 1 in every watcher sample while held (%d samples, %d with tm=0)"
                % (len(held), sum(1 for s in held if s.get("tm") != 1)))
        r.check(bool(arrived), "F1 arrived (IntelEngine 'arrived at')")
        pap = r.tails["papyrus"].read()
        r.check(bool(re.search(r"IntelEngine: Kept follower as teammate for task: %s\b" % nmF, pap)),
                "Papyrus: 'Kept follower as teammate for task' for F1")
        r.check(not re.search(r"IntelEngine: Dismissed follower: %s\b" % nmF, pap), "Papyrus: no 'Dismissed follower' for F1")
    finally:
        release_f(r, F1)
        _TM1_WINDOW.update(papyrus=r.tails["papyrus"].read(), sa=sa.read(), done=True)
        moveto(r, HOME_REF, 10)
        check_inv(r, F1)


@test("H-1", "H")
def h1(r):
    """Harness mod-event smoke (consumer proof (c), first in U1): the IEB_TestDoor and IEB_TestSneak events must arrive.
    A miss here is a FAIL (TM-2 / L-2 / TM-4 keep INCONCLUSIVE for later misses). DoorUse out of and back into
    Arcadia's (the exact door's line, dest != None), then SneakRun(F1, 5 s, sneak 0): START..END with >= 3 rt rows."""
    moveto(r, HOME_REF, 10)
    for door in (DOOR_ARCADIA_EXT, DOOR_ARCADIA_INT):
        m = ctl_wait(r, "DoorUse", [door], r"(?i)\[IEB-TEST\] DoorUse(?: %s dest=(?P<dest>\S+) destCell=\S+|: [^\n]*)"
                     % fid_rx(door), 15)
        r.check(bool(m) and bool(m.group("dest")) and m.group("dest").lower() != "none",
                "IEB_TestDoor arrived for door %08X (%s)" % (door, m.group(0).strip() if m else "no DoorUse line"))
        time.sleep(8)
    moveto(r, HOME_REF, 10)
    s = ctl_wait(r, "SneakRun", [F1, 5.0, 0],
                 r"(?i)\[IEB-TEST\] SNEAK START[\s\S]*?\[IEB-TEST\] SNEAK END[^\n]*|\[IEB-TEST\] SneakRun: [^\n]*", 30)
    rows = len(re.findall(r"(?i)SNEAK rt=", s.group(0))) if s else 0
    r.check(bool(s) and re.search(r"(?i)SNEAK END", s.group(0)) is not None and rows >= 3,
            "IEB_TestSneak arrived: SNEAK START..END with %d rt rows (%s)" % (rows, "seen" if s else "no line"))


@test("TM-2", "TM")
def tm2(r):
    """Start a task; within 3 s the player goes through a load door; repeat with F between the door and its
    destination. Pass: F does not appear in the interior. Door use = DoorUse wrapper (door.Activate(player); INFERRED
    equal to a key press, time plan:66, 128)."""
    runs = [
        # (label, player position first, exterior door, interior door back, interior cell)
        ("run 1: F beside the player at the market, door elsewhere", None, DOOR_ARCADIA_EXT, DOOR_ARCADIA_INT, CELL_ARCADIA),
        # F starts at Belethor's door and walks away from it toward the Bannered Mare (east): F between the door and
        # F's destination. Interpretation, see the report.
        ("run 2: F at the door, walking away from it", DOOR_BELETHOR_EXT, DOOR_BELETHOR_EXT, DOOR_BELETHOR_INT,
         CELL_BELETHOR),
    ]
    for label, first, door_ext, door_int, cell in runs:
        r.log("TM-2 %s" % label)
        moveto(r, first if first else HOME_REF, 10)      # F1 (following, WFP 0) catches up meanwhile
        snapshot(r, F1)
        pap, w = tail("papyrus"), tail("watch")
        try:
            t0 = time.time()
            r.ctl("StartTask", [F1, "GoToLocation", DEST_NEAR[0], "", ""])
            time.sleep(1.5)
            r.ctl("DoorUse", [door_ext])
            r.log("  DoorUse sent %.1f s after StartTask" % (time.time() - t0))
            d = decision(pap, F1, 10)
            used = pap.wait(r"\[IEB-TEST\] DoorUse %s[^\n]*" % fid_rx(door_ext), timeout=10)
            if not d or not d.group(0).startswith("[IEB] TAKE"):
                inconclusive(r, "%s: no TAKE for F1 (%s)" % (label, d.group(0) if d else "none"))
                continue
            if not used:
                inconclusive(r, "%s: DoorUse wrapper did not run" % label)
                continue
            time.sleep(15)
            pl = probe(r, PLAYER)
            if not pl or not re.search(fid_rx(cell), pl.get("cell", ""), re.I):
                inconclusive(r, "%s: the player is not in interior %08X (cell=%s)" % (label, cell, pl and pl.get("cell")))
                continue
            f = probe(r, F1)
            lines = actor_lines(w.read(), F1) + ([f] if f else [])
            inside = [s for s in lines if re.search(fid_rx(cell), s.get("cell", ""), re.I)]
            r.check(bool(lines) and not inside, "%s: F1 never in interior %08X (%d samples)" % (label, cell, len(lines)))
            r.check(bool(f) and f.get("ieSlot", -1) >= 0 and f.get("wfp") == 1.0,
                    "%s: F1 still on the errand and parked (slot %s, wfp %s)" % (label, f and f.get("ieSlot"), f and f.get("wfp")))
        finally:
            back = ctl_wait(r, "DoorUse", [door_int], r"(?i)\[IEB-TEST\] DoorUse %s dest=[^\n]*" % fid_rx(door_int), 10)
            if not back:
                r.log("  WARN %s: return DoorUse line not seen; moving the player out" % label)
                moveto(r, HOME_REF, 10)
            time.sleep(10)
            release_f(r, F1)
    moveto(r, HOME_REF, 10)
    check_inv(r, F1)


@test("TM-4", "TM")
def tm4(r):
    """F walking away and visible; the player sneaks for 20 s. Pass: F does not sneak, or the speed loss is noted.
    SneakRun wrapper: Actor.StartSneaking (VERIFIED sdk/skse/Actor.psc:710), Actor.IsSneaking (:415)."""
    snapshot(r, F1)
    dest, d = start_errand(r, F1, DEST_WALK)
    try:
        if not d or not d.startswith("[IEB] TAKE"):
            return inconclusive(r, "no TAKE for F1")
        time.sleep(3)
        windows = {}
        for secs, sneak in ((10.0, 0), (20.0, 1)):
            m = ctl_wait(r, "SneakRun", [F1, secs, sneak], r"(?i)\[IEB-TEST\] SNEAK START[\s\S]*?\[IEB-TEST\] SNEAK END[^\n]*",
                         secs + 20)
            if not m:
                return inconclusive(r, "SneakRun (sneak=%d) produced no SNEAK START..END" % sneak)
            windows[sneak] = [(float(a), int(b), int(c), tuple(float(v) for v in p.split(",")), int(lo)) for a, b, c, p, lo in
                              re.findall(r"SNEAK rt=([\d.]+) pl=([01]) npc=([01]) pos=(\S+) loaded=([01])", m.group(0))]

        def speed(rows):
            rows = [x for x in rows if x[4] == 1]
            if len(rows) < 3:
                return None
            dist = sum(((b[3][0] - a[3][0]) ** 2 + (b[3][1] - a[3][1]) ** 2) ** 0.5 for a, b in zip(rows, rows[1:]))
            return dist / max(rows[-1][0] - rows[0][0], 0.1)

        base, snk = speed(windows[0]), speed(windows[1])
        pl_share = sum(x[1] for x in windows[1]) / max(len(windows[1]), 1)
        npc_sneak = sum(x[2] for x in windows[1])
        r.log("  baseline speed %s u/s; sneaking-window speed %s u/s; player sneaking in %.0f%% of samples; F sneaking in %d"
              % (base and round(base), snk and round(snk), 100 * pl_share, npc_sneak))
        if pl_share < 0.8:
            return inconclusive(r, "the player did not sneak (StartSneaking ineffective?)")
        if not base or base < 30:
            return inconclusive(r, "F1 was not walking in view during the baseline")
        if npc_sneak == 0:
            r.check(True, "F1 did not sneak while the player sneaked")
        else:
            r.check(snk is not None, "F1 mirrored the sneak in %d samples; speed loss noted: %.0f%% of baseline"
                    % (npc_sneak, 100 * (snk or 0) / base))
            r.log("NOTE TM-4: sneak mirroring applies to an errand-runner (s10 E4/F4): record for the spec")
    finally:
        release_f(r, F1)
        moveto(r, HOME_REF, 10)
        check_inv(r, F1)


@test("TM-5", "TM")
def tm5(r):
    """Hostile spawned near the player while F departs; once with NFF Combat Aware off, once on (time plan:131).
    Pass: F resumes travel after combat; no 'failed to depart' (IE_Tasks:2413, 2421). Records whether F joined the fight
    in each run (combat aware off -> any assist is the engine's teammate assist, s10 E2)."""
    m = ctl_wait(r, "NFFCombatAware", [-1], r"\[IEB-TEST\] NFFCombatAware was=(-?\d+) now=(-?\d+)", 10)
    if not m:
        return inconclusive(r, "NFFCombatAware wrapper missing")
    original = int(m.group(1))
    try:
        for aware in (0, 1):
            ctl_wait(r, "NFFCombatAware", [aware], r"\[IEB-TEST\] NFFCombatAware was=", 10)
            moveto(r, HOME_REF, 10)
            snapshot(r, F1)
            w, pap = tail("watch"), tail("papyrus")
            try:
                dest, d = start_errand(r, F1, DEST_WALK)
                if not d or not d.startswith("[IEB] TAKE"):
                    inconclusive(r, "combat aware %d: no TAKE for F1" % aware)
                    continue
                # "while F is departing": the wolf goes in right after the take. EncWolf INFERRED hostile to the player.
                sp = ctl_wait(r, "SpawnHostile", [WOLF], r"\[IEB-TEST\] SpawnHostile [^\n]*ref=(\S+)", 10)
                if not sp:
                    inconclusive(r, "SpawnHostile wrapper missing")
                    continue
                for _ in range(6):                # 30 s of fighting (guards, the player, maybe F); then Despawn
                    time.sleep(5)
                    probe(r, F1)
                ctl_wait(r, "Despawn", [], r"\[IEB-TEST\] Despawn", 10)
                fought = any(s.get("combat") == 1 for s in actor_lines(w.read(), F1))
                r.log("  combat aware %d: F1 %s the fight%s" % (aware, "joined" if fought else "stayed out of",
                      " (NFF assist off: the engine's teammate assist, s10 E2)" if fought and aware == 0 else ""))
                arrived = wait_arrival(pap, F1, 150)
                after = [s for s in actor_lines(w.read(), F1) if s.get("dDest_n") is not None]
                closing = len(after) >= 2 and after[0]["dDest_n"] - after[-1]["dDest_n"] > 300
                r.check(bool(arrived) or closing, "combat aware %d: F1 resumed travel after combat (%s)"
                        % (aware, "arrived" if arrived else "dDest closing" if closing else "no progress"))
                r.check(not re.search(r"IntelEngine: %s failed to depart" % nm(F1), pap.read()),
                        "combat aware %d: no 'failed to depart'" % aware)
            finally:
                ctl_wait(r, "Despawn", [], r"\[IEB-TEST\] Despawn", 5)     # idempotent (no-op without a spawn)
                release_f(r, F1)
    finally:
        ctl_wait(r, "NFFCombatAware", [original], r"\[IEB-TEST\] NFFCombatAware was=", 10)
        moveto(r, HOME_REF, 10)
        check_inv(r, F1)


@test("TM-8", "TM", reload=True)   # x1000 window: reload T0 after (run 18 L-4 time drift)
def tm8(r):
    """F's prompts mid-errand and in the rejoin phase (time plan R2: grep openrouter_input.log, never print text).
    Pass: 0600 'member ... traveling in the group' (base 0600_relationships.prompt:17, rendered when is_follower) and
    0802 'not at ... side right now' (Held 1) / 'finished an errand' (Held 2) in the same request
    (build/layers/errandbridge/.../0802_ieb_errand.prompt); 0600 'never been a member' absent.
    Not automated: "F's lines do not claim to be with the player" (needs reading the reply; request ids are logged
    for Claude's review)."""
    nmF, P = nm(F1), PLAYER_NAME
    M = {"head0802": "### Where %s Is Right Now" % nmF,
         "held1": "%s is still a member of %s's party, but is not at %s's side right now" % (nmF, P, P),
         "held2": "%s has finished an errand for %s" % (nmF, P),
         "on0600": "%s is a member of %s's party, and is currently actively traveling in the group." % (nmF, P),
         "never0600": "%s has never been a member of %s's party" % (nmF, P)}

    def phase(label, want):
        req = tail("req")
        hits = []
        for thought in (1, 0):        # thought first (any distance); DirectNarration as the fallback (INFERRED)
            ctl_wait(r, "Speak", [F1, thought], r"\[IEB-TEST\] Speak %s thought=%d rc=" % (nmF, thought), 10)
            end = time.time() + 90
            while time.time() < end:
                time.sleep(5)
                hits = [(tag, rid, b) for tag, rid, b in req_blocks(req.read()) if M["head0802"] in b]
                if hits:
                    break
            if hits:
                break
        if not hits:
            return inconclusive(r, "%s: no request carrying F1's 0802 block within 90 s (thought cooldown? far actor?)" % label)
        r.log("  %s: %d request(s) with F1's 0802 heading: %s" % (label, len(hits), ", ".join("%s[%s]" % (rid, tag) for tag, rid, _ in hits)))
        r.check(all(M[want] in b for _, _, b in hits), "%s: 0802 says the %s line" % (label, want))
        r.check(all(M["on0600"] in b for _, _, b in hits), "%s: 0600 says member, traveling in the group" % label)
        r.check(not any(M["never0600"] in b for _, _, b in hits), "%s: 0600 'never been a member' absent" % label)

    snapshot(r, F1)
    dest, d = start_errand(r, F1, DEST_NEAR)
    try:
        if not d or not d.startswith("[IEB] TAKE"):
            return inconclusive(r, "no TAKE for F1")
        phase("mid-errand (Held 1)", "held1")
        moveto(r, AWAY_REF)
        if not timeout_at_dest(r, F1):
            return inconclusive(r, "F1 never reached its errand's timeout (arrival or Accelerate)")
        rj = r.tails["papyrus"].wait(r"(?i)\[IEB\] (REJOIN_WAIT|RELEASE_FOLLOW|RELEASE_STAY|RELEASE) actor=%s\b" % nmF, 20)
        ctl_wait(r, "Rejoin", [F1], r"\[IEB-TEST\] Rejoin [^\n]*", 10)
        if not rj or rj.group(1) != "REJOIN_WAIT":
            return inconclusive(r, "no rejoin phase (%s); see the Rejoin line for dist and N" % (rj.group(1) if rj else "no release"))
        phase("rejoin (Held 2)", "held2")
    finally:
        release_f(r, F1)
        moveto(r, HOME_REF, 10)
        check_inv(r, F1)


@test("TM-10", "TM", reload=True)
def tm10(r):
    """A plain-ClearSlot exit (T3 wait timeout under Accelerate(1000), time plan:136). Pass: F is still a teammate; no
    TEAMMATE_WAS_OFF (IEB_Main:409-411)."""
    nmF = nm(F1)
    snapshot(r, F1)
    dest, d = start_errand(r, F1, DEST_NEAR)
    try:
        if not d or not d.startswith("[IEB] TAKE"):
            return inconclusive(r, "no TAKE for F1")
        moveto(r, AWAY_REF)
        if not timeout_at_dest(r, F1):
            return inconclusive(r, "no plain-ClearSlot exit observed (arrival or Accelerate failed)")
        rel = r.tails["papyrus"].wait(r"(?i)\[IEB\] (REJOIN_WAIT|RELEASE_FOLLOW|RELEASE_STAY|RELEASE) actor=%s\b" % nmF, 20)
        r.check(bool(rel), "bridge released F1 after the plain exit (%s)" % (rel.group(1) if rel else "none"))
        f = probe(r, F1)
        r.check(bool(f) and f.get("tm") == 1, "F1 is a teammate after the plain ClearSlot exit (tm=%s)" % (f and f.get("tm")))
        r.check(not re.search(r"(?i)\[IEB\] TEAMMATE_WAS_OFF actor=%s\b" % nmF, r.tails["papyrus"].read()),
                "no TEAMMATE_WAS_OFF for F1")
    finally:
        release_f(r, F1)
        moveto(r, HOME_REF, 10)
        check_inv(r, F1)


@test("TM-11", "TM", reload=True)
def tm11(r):
    """A Dungeon Master rescue naming F, and one naming a lent NPC (H). Calls IntelEngine_StoryEngine.HandleQuestDispatch
    directly over MCP with a fixed rescue JSON (no LLM): the victim checks run before any quest state is written
    (IE_SE:3056-3126, VERIFIED). Pass, as built: F -> "victim 'Jenassa' is the player's teammate" (IE_SE:3109-3112);
    H (lent, in a slot) -> "victim 'Brenuin' is committed to a quest" (IE_SE:3114-3117 via IEB_StoryBlocked ->
    IEB_DispatchBlocked :5172-5185). The spec row expects one "teammate or busy" text (s10 §4.1); the build kept two
    messages (report).
    Failsafe: questLocation is a name that should not resolve, so if a victim guard fails the call stops at
    'quest location ... could not be resolved' (IE_SE:3180-3183), before QuestActive = true (:3273) - that line is the
    FAIL signal. INFERRED that the native resolver does not fuzzy-match it; reload=True as a second safety."""
    courier = hexarg(CARLOTTA)        # any loaded non-Jarl NPC; INFERRED that MCP drops an unloaded Actor argument
    nowhere = "IEB_NoSuchPlace_TM11"

    def rescue(victim):
        js = ('{"storyType":"quest","questSubType":"rescue","victimName":"%s","questLocation":"%s",'
              '"enemyType":"bandit"}' % (victim, nowhere))
        t = tail("papyrus")
        r.tool("execute_quest_function", {"quest_editor_id": "IntelEngine", "script_name": "IntelEngine_StoryEngine",
                                          "function_name": "HandleQuestDispatch", "arguments": [courier, "", js]})
        m = t.wait(r"IntelEngine: Story DM: (?:quest/rescue rejected -- victim '%s'[^\n]*|quest rejected -- one already "
                   r"active|quest location '%s'[^\n]*)" % (re.escape(victim), nowhere), timeout=15)
        if m and nowhere in m.group(0):
            r.log("  rescue naming %s passed the victim checks (stopped only at the unresolvable location)" % victim)
        return m

    f = probe(r, F1)
    if not f or f.get("tm") != 1:
        return inconclusive(r, "F1 is not a teammate (tm=%s)" % (f and f.get("tm")))
    m = rescue(nm(F1))
    if m and "one already active" in m.group(0):
        return inconclusive(r, "a Story DM quest is already active in this save")
    r.check(bool(m) and ("victim '%s'" % nm(F1)) in m.group(0) and "teammate" in m.group(0),
            "rescue naming F1 rejected as teammate")
    snapshot(r, H)
    dest, d = start_errand(r, H, DEST_NEAR)
    try:
        if not d or not d.startswith("[IEB] LEND"):
            return inconclusive(r, "H not lent (%s); the busy guard would not be exercised" % (d or "no decision"))
        m = rescue(nm(H))
        r.check(bool(m) and ("victim '%s'" % nm(H)) in m.group(0) and ("committed to a quest" in m.group(0)
                                                                    or "busy" in m.group(0)),
                "rescue naming lent H rejected as busy")
        r.check(not re.search(r"Story DM: quest location '%s'" % nowhere, r.tails["papyrus"].read()),
                "no rescue got past the victim checks")
    finally:
        restore_lend(r, H)


@test("TM-12", "TM")
def tm12(r):
    """SA log during TM-1: no TeammateRemoved and no 'Vanilla dismiss candidate' for F. Strings VERIFIED:
    FM:1495 (always traced), FM:1524 (debugMode only), SA DLL 'TeammateMonitor: Teammate removed - FormID {:08X}' and
    'TeammateMonitor: removal candidate {:08X}' (tools/severactions_dll_strings.txt:20922-20934)."""
    win = _TM1_WINDOW
    if not win.get("done"):
        r.log("  TM-1 window not available (TM-1 not run in this block): running a short errand")
        snapshot(r, F1)
        sa = tail("sa")
        dest, d = start_errand(r, F1, DEST_NEAR)
        try:
            if not d:
                return inconclusive(r, "no TAKE for F1")
            time.sleep(30)          # SA's removal fires after ~5 s (FM:1479-1531); 30 s covers the long confirmation
        finally:
            release_f(r, F1)
        win = {"papyrus": r.tails["papyrus"].read(), "sa": sa.read()}
        check_inv(r, F1)
    nmF = nm(F1)
    r.check(not re.search(r"TeammateRemoved on track-only follower %s\b" % nmF, win["papyrus"]),
            "Papyrus: no SA TeammateRemoved for F1")
    r.check(not re.search(r"Vanilla dismiss candidate: %s\b" % nmF, win["papyrus"]),
            "Papyrus: no 'Vanilla dismiss candidate' for F1 (logged only with SA debugMode, INFERRED off)")
    r.check(not re.search(r"TeammateMonitor: (?:Teammate removed - FormID|removal candidate) %s" % fid_rx(F1), win["sa"], re.I),
            "SeverActionsNative.log: no TeammateMonitor removal for F1")


@test("TM-13", "TM", reload=True)
def tm13(r):
    """IEB_DropTeammate = 1 (global StorageUtil, IE_Core:1070), repeat TM-1/TM-10. Pass: stock behaviour returns -
    'Dismissed follower' at the take, flag off during the errand, and at the plain-ClearSlot exit the bridge puts the
    flag back with TEAMMATE_WAS_OFF (IEB_Main:409-411). Always restores IEB_DropTeammate = 0."""
    nmF = nm(F1)
    m = ctl_wait(r, "SetDropTeammate", [1], r"\[IEB-TEST\] DropTeammate was=(\d+) now=(\d+)", 10)
    try:
        if not m or m.group(2) != "1":
            return inconclusive(r, "SetDropTeammate wrapper missing or did not set 1")
        snapshot(r, F1)
        w = tail("watch")
        dest, d = start_errand(r, F1, DEST_NEAR)
        if not d or not d.startswith("[IEB] TAKE"):
            return inconclusive(r, "no TAKE for F1")
        time.sleep(10)
        pap = r.tails["papyrus"].read()
        r.check(bool(re.search(r"IntelEngine: Dismissed follower: %s\b" % nmF, pap)), "A/B: 'Dismissed follower' at the take")
        r.check(not re.search(r"IntelEngine: Kept follower as teammate for task: %s\b" % nmF, pap), "A/B: no 'Kept follower'")
        held = [s for s in actor_lines(w.read(), F1) if s.get("iebHeld") == 1]
        r.check(bool(held) and all(s.get("tm") == 0 for s in held), "A/B: flag off while held (%d samples)" % len(held))
        moveto(r, AWAY_REF)
        if not timeout_at_dest(r, F1):
            return inconclusive(r, "no plain-ClearSlot exit observed")
        r.check(bool(r.tails["papyrus"].wait(r"(?i)\[IEB\] TEAMMATE_WAS_OFF actor=%s\b" % nmF, 20)),
                "A/B: bridge restored the flag with TEAMMATE_WAS_OFF")
        f = probe(r, F1)
        r.check(bool(f) and f.get("tm") == 1, "F1 a teammate again after release")
    finally:
        m2 = ctl_wait(r, "SetDropTeammate", [0], r"\[IEB-TEST\] DropTeammate was=(\d+) now=(\d+)", 10)
        r.check(bool(m2) and m2.group(2) == "0", "IEB_DropTeammate restored to 0")
        release_f(r, F1)
        moveto(r, HOME_REF, 10)
        check_inv(r, F1)


# ================================================================ L (lend, §6.3 / §7.3)

def lend(r, fid, dests=DEST_NEAR):
    """Snapshot + ExpectLend (so Check runs I4 for a bridge lend: Watcher:260 reads EBT_WasLent, set only by TestCtl.Lend
    today) + errand. Returns (decision line, kind) ; kind = IEB_SA_Kind bitmask (IEB_SALib:76-115: 1 home, 2 work,
    4 relax, 8 guard, 16 track-only home, 32 retainer, 64 steward, 128 sleeping)."""
    snapshot(r, fid)
    ctl_wait(r, "ExpectLend", [fid], r"\[IEB-TEST\] ExpectLend", 10)
    dest, d = start_errand(r, fid, dests)
    m = re.search(r"(?i)\[IEB\] LEND actor=\S.*? kind=(\d+)", d or "")
    return d, int(m.group(1)) if m else None


def sample_moves(r, fid, seconds=30, step=2):
    """Probe every `step` s; returns the loaded samples."""
    out, end = [], time.time() + seconds
    while time.time() < end:
        p = probe(r, fid)
        if p:
            out.append((time.time(), p))
        time.sleep(step)
    return out


@test("L-1", "L")
def l1(r):
    """H at Work hours: GoToLocation via TestCtl. Pass: LEND with the work bit; WFP 1; the errand proceeds.
    'The card shows told to wait' is the SA PrismaUI card: not automatable; the sever_follow_state decorator is logged
    as a proxy (INFERRED)."""
    d, kind = lend(r, H)
    try:
        if not d or not d.startswith("[IEB] LEND"):
            return inconclusive(r, "H not lent (%s)" % (d or "no decision"))
        r.check(kind is not None and kind & 2 == 2, "LEND kind=%s has the work bit (2); spec says 'kind=work'" % kind)
        p = probe(r, H)
        r.check(bool(p) and p.get("wfp") == 1.0, "H WFP 1 (wfp=%s)" % (p and p.get("wfp")))
        u, _ = r.uuid(H)
        if u:
            st = r.tool("render_template", {"actor_uuid": u, "content": "{{ sever_follow_state(actorUUID) }}"})
            r.log("  MANUAL card check (not automated); sever_follow_state=%r" % str(st.get("renderedContent", st))[:40])
        w = tail("watch")
        arrived = wait_arrival(r.tails["papyrus"], H, 60)
        dd = [s["dDest_n"] for s in actor_lines(w.read(), H) if s.get("dDest_n") is not None]
        r.check(bool(arrived) or (len(dd) >= 2 and dd[0] - dd[-1] > 200),
                "the errand proceeds (%s)" % ("arrived" if arrived else "dDest %s -> %s" % (dd[:1], dd[-1:])))
    finally:
        restore_lend(r, H)


@test("L-2", "L")
def l2(r):
    """L-1, then the player walks through 2 load doors near H. Pass: no AI reset on H; WFP stays 1.
    EscalatedReEvaluate (SA SeverActionsNative.psc:946-956) logs nothing itself; every SA call site sets WFP 2 just
    before it (FM:1686-1689 sched path, 1717-1723 legacy path, 1753-1756 HomeFallback) and two of them log 'CellLoad:
    Re-evaluated home sandbox for <name>' (FM:1724) / 'HomeFallback: re-asserted ...' (FM:1757), debugMode only. So the checks are: WFP 1 in every sample and on return, no
    schedule alias re-filled, no such debug line."""
    d, kind = lend(r, H)
    w = tail("watch")
    try:
        if not d or not d.startswith("[IEB] LEND"):
            return inconclusive(r, "H not lent (%s)" % (d or "no decision"))
        for door in (DOOR_BELETHOR_EXT, DOOR_BELETHOR_INT):
            m = ctl_wait(r, "DoorUse", [door], r"\[IEB-TEST\] DoorUse %s[^\n]*" % fid_rx(door), 10)
            if not m:
                return inconclusive(r, "DoorUse wrapper did not run")
            time.sleep(10)
        time.sleep(5)       # SA's TESCellFullyLoaded handler (FM:1660) after the return to the exterior
        p = probe(r, H)
        samples = actor_lines(w.read(), H) + ([p] if p else [])
        r.check(bool(samples) and all(s.get("wfp") == 1.0 for s in samples),
                "H WFP 1 in all %d samples across the doors" % len(samples))
        r.check(bool(p) and p.get("sched") == (-1, -1, -1), "no schedule alias re-filled on H (schedIdx=%s)" % ((p and p.get("sched")),))
        r.check(not re.search(r"(Re-evaluated home sandbox for|re-asserted dropped home override for|stripped stray "
                              r"schedule aliases from active follower) %s\b" % nm(H), r.tails["papyrus"].read()),
                "no SA cell-load AI reset line for H")
    finally:
        restore_lend(r, H)
        moveto(r, HOME_REF, 8)


@test("L-3", "L", reload=True)   # x1000 window: reload T0 after (run 18 L-4 time drift)
def l3(r):
    """L-1 to completion. Pass: LEND_RESTORE; I4 within 30 s; H walks back (no teleport)."""
    d, kind = lend(r, H)
    try:
        if not d or not d.startswith("[IEB] LEND"):
            return inconclusive(r, "H not lent (%s)" % (d or "no decision"))
        moveto(r, AWAY_REF)
        if not timeout_at_dest(r, H):
            return inconclusive(r, "H's errand never reached its end")
        rs = r.tails["papyrus"].wait(r"(?i)\[IEB\] LEND_RESTORE actor=%s kind=\d+ why=(\S+)" % nm(H), 20)
        r.check(bool(rs), "LEND_RESTORE (why=%s)" % (rs.group(1) if rs else "-"))
        s = sample_moves(r, H, 30, 2)
        pts = [(t, p) for t, p in s if p.get("loaded") == 1 and p.get("xyz") and p.get("interior") is False]
        jumps = [((b[1]["xyz"][0] - a[1]["xyz"][0]) ** 2 + (b[1]["xyz"][1] - a[1]["xyz"][1]) ** 2) ** 0.5
                 for a, b in zip(pts, pts[1:]) if b[0] - a[0] <= 6]
        moved = (((pts[-1][1]["xyz"][0] - pts[0][1]["xyz"][0]) ** 2 + (pts[-1][1]["xyz"][1] - pts[0][1]["xyz"][1]) ** 2)
                 ** 0.5) if len(pts) >= 2 else 0
        r.log("  %d loaded exterior samples; max step %s u; net move %d u" % (len(pts), jumps and int(max(jumps)), moved))
        if len(pts) < 5 or not jumps:
            inconclusive(r, "too few loaded samples of H to judge walking vs teleport")
        else:
            r.check(max(jumps) < 1000, "no teleport (max step between samples %d u < 1000)" % max(jumps))
            if moved < 150:
                inconclusive(r, "H did not move back within 30 s (net %d u)" % moved)
        check_inv(r, H, "I4 after restore (>= 30 s)")
    finally:
        if not r.tails["papyrus"].wait(r"(?i)\[IEB\] LEND_RESTORE(?:_SKIP)? actor=%s\b" % nm(H), 1):
            restore_lend(r, H)
        moveto(r, HOME_REF, 8)


@test("L-4", "L", reload=True)   # x1000 window: reload T0 after (run 18 L-4 time drift)
def l4(r):
    """G on shift: errand. Pass: LEND with the guard bit (8); no 110 re-added (ReinforceSchedWorkGuard returns at WFP 1,
    FM:6344-6345, so it is silent: checked as G's current package never being SeverActions_GuardBodyguard 0x165677,
    FM:4686-4695); the errand completes; restore re-seats the guard alias (guardIdx >= 0)."""
    # U1 run 18: L-4 ran at game time 17:20 on day 3 (gt=3.72): TM-10/TM-13's x1000 windows had pushed the clock past
    # Anoriath's 08:00-17:00 guard post, so he was lent as work+retainer (kind=34) and every guard check FAILED. They now
    # reload T0 after themselves; L-4 also checks the precondition (guard alias seated) before lending.
    p0 = probe(r, G)
    if not p0 or p0.get("guardIdx", -1) < 0:
        return inconclusive(r, "G not on his guard post before the lend (guardIdx=%s; game time past 17:00?)"
                            % ((p0 or {}).get("guardIdx"),))
    d, kind = lend(r, G)
    w = tail("watch")
    try:
        if not d or not d.startswith("[IEB] LEND"):
            return inconclusive(r, "G not lent (%s); is Anoriath on shift (08-17)?" % (d or "no decision"))
        r.check(kind is not None and kind & 8 == 8, "LEND kind=%s has the guard bit (8)" % kind)
        moveto(r, AWAY_REF)
        done = timeout_at_dest(r, G)
        r.check(bool(done), "G's errand completed (arrival, then the linger deadline)")
        lines = actor_lines(w.read(), G)
        r.check(bool(lines) and not any(re.search(r"165677\b", s.get("pkg", ""), re.I) for s in lines),
                "G never on the guard package (110) during the errand (%d samples)" % len(lines))
        rs = r.tails["papyrus"].wait(r"(?i)\[IEB\] LEND_RESTORE actor=%s\b[^\n]*" % nm(G), 20)
        r.check(bool(rs), "LEND_RESTORE for G")
        seat = None
        for _ in range(12):
            p = probe(r, G)
            if p and p.get("guardIdx", -1) >= 0:
                seat = p["guardIdx"]
                break
            time.sleep(5)
        r.check(seat is not None, "restore re-seated G's guard alias (guardIdx=%s)" % seat)
        check_inv(r, G, "I4 after restore")
    finally:
        if not r.tails["papyrus"].wait(r"(?i)\[IEB\] LEND_RESTORE(?:_SKIP)? actor=%s\b" % nm(G), 1):
            restore_lend(r, G)
        moveto(r, HOME_REF, 8)


@test("L-6", "L", reload=True)
def l6(r):
    """Muster C; errand on a member. Pass: REFUSE reason=war_band (IEB_SALib:60-62); ieb_errand_refused registered
    (IEB_Main:318-319).
    Reaching a member (Valtheim is far): F1/F2 told to wait through SA's own CompanionWait (NFF-held -> NFF's wait,
    FM:8796-8809); the player moves to the chief (time plan line 7.2 of t0_setup_research.md: moveto a boss ref is
    safe, INFERRED for Valtheim); the CampMuster wrapper musters with the chief resolved by FormID (the same calls as
    SA MusterCamp, ENT:622-637); members within 4000 u fall in at once (ENT:1186-1190); one loaded non-chief member
    gets the errand. Near the player, so SkyrimNet does not skip the event as too far (SkyrimNet DLL string
    'RegisterEventImpl: Actor {} is beyond 2* the interaction distance. Skipping event.', strings:35352).
    reload=True: muster, teammate flags and positions are left as they are."""
    for f in (F1, F2):
        sa_call(r, "SeverActions_FollowerManager", "CompanionWait", [hexarg(f)])     # FM:8755
    time.sleep(3)
    moveto(r, CHIEF, 20)
    for _ in range(6):
        u, _info = r.uuid(CHIEF)
        if u:
            break
        time.sleep(10)
    else:
        return inconclusive(r, "chief %08X not loaded after the move" % CHIEF)
    t = tail("papyrus")
    r.ctl("CampMuster", [CHIEF, 1])
    m = t.wait(r"\[IEB-TEST\] CampMuster camp=(\d+) on=1 ok=(\w+) members=(\d+)", 30)
    try:
        if not m or m.group(2).lower() != "true":
            return inconclusive(r, "muster failed or wrapper missing (%s)" % (m.group(0) if m else "no line"))
        time.sleep(2)
        mem = re.findall(r"\[IEB-TEST\] CampMember (\S+) (.+?) loaded=(\w+) muster=(-?\d+)", t.read())
        pick = [(fid_norm(h), n) for h, n, lo, mu in mem if lo.lower() == "true" and int(mu) >= 0 and fid_norm(h) != CHIEF]
        r.log("  camp %s: %d members logged, %d loaded and seated" % (m.group(1), len(mem), len(pick)))
        if not pick:
            return inconclusive(r, "no loaded mustered member besides the chief")
        fid, name = pick[0]
        NAMES[fid] = name
        sn = tail("skyrimnet")
        dest, d = start_errand(r, fid, ["Riverwood"], timeout=15)
        if not d:
            return inconclusive(r, "no bridge decision for member %08X" % fid)
        r.check("REFUSE" in d and "reason=war_band" in d, "member %08X: REFUSE reason=war_band" % fid)
        if "TAKE" in d:
            r.log("NOTE L-6: a mustered member that is not SA-posted is classified Mode 2 (IEB_Main:229-253: the war_band "
                  "check runs only inside the IsPosted branch)")
        # consumer_proof_list.md: "RegisterEvent called" also appears when SkyrimNet then drops the event as too far away;
        # only "Successfully registered event" proves it reached history (case-sensitive consumer: exact case).
        ev = sn.wait(r"Successfully registered event 'ieb_errand_refused'", 20)
        if not ev and re.search(r"(?i)Successfully registered event 'ieb_errand_refused'", sn.read()):
            r.check(False, "FOLDED ieb_errand_refused (registered under another case)")
        r.check(bool(ev), "ieb_errand_refused event registered (SkyrimNet.log 'Successfully registered event')")
        far = re.search(r"(?i)ieb_errand_refused.*interaction distance|interaction distance.*ieb_errand_refused", sn.read())
        r.check(not far, "ieb_errand_refused not skipped as too far (%s)" % (far.group(0)[:120] if far else "none"))
    finally:
        ctl_wait(r, "CampMuster", [CHIEF, 0], r"\[IEB-TEST\] CampMuster camp=\d+ on=0", 30)


@test("L-7", "L", reload=True)
def l7(r):
    """Errand on an NPC in SA's wait sandbox. Pass: REFUSE reason=sa_wait (IEB_SALib:63-65: WFP 1 and
    Native_GetSandboxing). H is put in the wait sandbox by SA's own CompanionWait (FM:8755 -> SandboxHeld, Follow.psc:
    1898-1950: override, WFP 1, SetSandboxFlag true :1934 -> Native_SetSandboxing :420-423). INFERRED: for an unled
    NPC in Tracking mode CompanionWait takes the SandboxHeld branch (FM:8824-8865, _UnledInTracking). The YAML gate
    (followers only) does not apply to a direct call. reload=True: SA's wait teardown for a posted NPC is INFERRED."""
    sa_call(r, "SeverActions_FollowerManager", "CompanionWait", [hexarg(H)])
    p = None
    for _ in range(6):
        time.sleep(3)
        p = probe(r, H)
        if p and p.get("wfp") == 1.0 and p.get("saSandbox"):
            break
    try:
        if not p or p.get("wfp") != 1.0 or not p.get("saSandbox"):
            return inconclusive(r, "H not in SA's wait sandbox (wfp=%s sandbox=%s)" % (p and p.get("wfp"), p and p.get("saSandbox")))
        dest, d = start_errand(r, H, DEST_NEAR)
        r.check(bool(d) and "REFUSE" in d and "reason=sa_wait" in d, "REFUSE reason=sa_wait (%s)" % (d or "no decision"))
    finally:
        sa_call(r, "SeverActions_Follow", "StopSandbox", [hexarg(H)])                     # Follow.psc:1958
        sa_call(r, "SeverActions_FollowerManager", "RefillSchedAliasesAfterStop", [hexarg(H)])   # FM:6893


@test("L-10", "L", reload=True)   # x1000 window: reload T0 after (run 18 L-4 time drift)
def l10(r):
    """Mid-lend save/load (H alive). Pass: hold persists (WFP 1, no schedule alias); the errand completes; LEND_RESTORE.
    Reconcile re-asserts a lent NPC still in its slot (IEB_Main:658-666)."""
    d, kind = lend(r, H)
    try:
        if not d or not d.startswith("[IEB] LEND"):
            return inconclusive(r, "H not lent (%s)" % (d or "no decision"))
        time.sleep(5)
        if not game.save(r, "IEB_L10"):
            return inconclusive(r, "save IEB_L10 did not complete; not loading it")
        time.sleep(8)
        if not os.path.exists(game.SAVES + "IEB_L10.ess"):
            r.log("  NOTE: IEB_L10.ess not seen in %s (save path INFERRED); trying the load anyway" % game.SAVES)
        if not game.load(r, "IEB_L10", settle_probe(r)):
            return inconclusive(r, "load IEB_L10 failed")
        time.sleep(20)                                   # both reconciles (+5 s, +15 s; IEB_Main:99-106)
        p = probe(r, H)
        r.check(bool(p) and p.get("iebLent") == 1 and p.get("ieSlot", -1) >= 0, "after load: H still lent and in its slot")
        r.check(bool(p) and p.get("wfp") == 1.0, "after load: H WFP 1 (wfp=%s)" % (p and p.get("wfp")))
        r.check(bool(p) and p.get("sched") == (-1, -1, -1), "after load: no schedule alias (schedIdx=%s)" % ((p and p.get("sched")),))
        moveto(r, AWAY_REF)
        if not timeout_at_dest(r, H):
            return inconclusive(r, "H's errand never reached its end after the load")
        rs = r.tails["papyrus"].wait(r"(?i)\[IEB\] LEND_RESTORE actor=%s\b[^\n]*" % nm(H), 20)
        r.check(bool(rs), "LEND_RESTORE after the errand")
        time.sleep(30)
        check_inv(r, H, "I4 after restore")
    finally:
        if not r.tails["papyrus"].wait(r"(?i)\[IEB\] LEND_RESTORE(?:_SKIP)? actor=%s\b" % nm(H), 1):
            restore_lend(r, H)
        moveto(r, HOME_REF, 8)


@test("L-9", "L", reload=True)
def l9(r):
    """Mid-lend: kill H and save, reload (R24: IntelEngine's co-save drops a dead slot at load). Pass: LEND_RESTORE by
    reconcile (no slot; IEB_Main:658-660) or the orphan sweep (:704-705); no IEB keys.
    The kill and the save are made in one Papyrus call (KillAndSave wrapper; SKSE Game.SaveGame, sdk/skse/Game.psc:314)
    because the bridge's 1 s tick restores a dead lent NPC itself (IEB_Main:362-365) and would otherwise win the race.
    Run last in L; the block reloads T0 after it."""
    d, kind = lend(r, H)
    if not d or not d.startswith("[IEB] LEND"):
        return inconclusive(r, "H not lent (%s)" % (d or "no decision"))
    time.sleep(5)
    m = ctl_wait(r, "KillAndSave", [H, "IEB_L9"], r"\[IEB-TEST\] KillAndSave %s dead=(\w+) lent=(\d+) save=IEB_L9" % nm(H), 15)
    if not m:
        return inconclusive(r, "KillAndSave wrapper missing")
    if m.group(2) != "1":
        return inconclusive(r, "H was no longer lent at the save (lent=%s)" % m.group(2))
    time.sleep(8)
    if not game.load(r, "IEB_L9", settle_probe(r)):
        return inconclusive(r, "load IEB_L9 failed")
    m2 = None
    end = time.time() + 40
    while time.time() < end and not m2:
        txt = r.tails["papyrus"].read()
        cut = txt.rfind("[IEB] SETUP")                                   # IEB_Main:49, once per load
        m2 = re.search(r"(?i)\[IEB\] LEND_RESTORE actor=%s kind=\d+ why=(reconcile|orphan)" % nm(H), txt[cut if cut >= 0 else 0:])
        time.sleep(3)
    r.check(bool(m2), "after load: LEND_RESTORE by %s" % (m2.group(1) if m2 else "nothing"))
    p = probe(r, H)
    r.check(bool(p) and p.get("dead") == 1 and p.get("iebKeys") is False,
            "H dead with no IEB keys (dead=%s iebKeys=%s)" % (p and p.get("dead"), p and p.get("iebKeys")))
