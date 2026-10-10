"""Step-8 U1 family B: the errand-core tests B-1 ... B-28 and B-31 (B-17, B-29, B-30 run elsewhere). Drafted
2026-10-10 for block U1 (save T0); nothing here has run against the game yet.

Sources: v1 tests 1-20 = BRIDGE_INVESTIGATION.md §5.5 (:847-873), with the v2 changes in BRIDGE_SPEC_V2.md §15.3
(:3414-3424); B-21 ... B-31 = spec §15.3 rows (:3428-3438); eligibility matrix = spec §12 (:3247-3260); routes =
investigation/round10/step8_time_plan.md §3.1 (:111-126).

Bridge log lines (all VERIFIED in build/src/errandbridge/Source/Scripts/IEB_Main.psc, written to Papyrus.0.log as
"[IEB] <KW> actor=<display name> ..." by Log() :801-807): TAKE :190/:251/:278, LEND :293, REFUSE :320, RELEASE_DEAD
:390, RELEASE_SEATLOST :396, RELEASE (mode 2) :418, RELEASE_STAY :425, RELEASE_FOLLOW :429, REJOIN_WAIT :432,
LEND_RESTORE :488, CMD_FOLLOW :559, REPARK :574 (level 2), REJOIN_CANCELLED :583-593, REJOIN_TO_WAIT :598/:788,
REJOIN_DONE :605 (no reason field) / :793 (reason=recalled) / :146 (reason=disable), RECONCILE :650 (level 2),
RECALL_REQ :769-783, ENABLE :131, DISABLE :155. IEB_LogLevel defaults to 2 (build/tools/gen_errandbridge.py:20), so
the level-2 lines are logged (INFERRED that T0 kept the default).

IntelEngine lines (VERIFIED repos/IntelEngine-Gerk/Source/Scripts, DebugMsg = Debug.Trace("IntelEngine: " + msg),
Core.psc:1788-1789): "Allocated slot S to NAME for TYPE" Core.psc:608, "Clearing slot S: NAME" :623, "NAME arrived at
DEST" Travel.psc:579, "Recovered travel package for NAME" Travel.psc:145, "Skipping GoToLocation for follower NAME"
Core.psc:1096. Timeouts are game time: travel force-arrive after 7 h (Travel.psc:30, :359-394); the wait at the
destination is the MCM default 48 h (Core.psc:1688-1689) unless changed; the meeting timeout 5 h (Travel.psc:619).

Destinations: "The Bannered Mare", "Dragonsreach", "the marketplace" are IntelEngine's own examples of valid names
(but "the marketplace" resolves to Windhelm from Whiterun: ie_destination_resolver.md; not used)
(VERIFIED IntelEngine actions/schedulemeeting.yaml:38-40); GoToLocation resolves them with the same
IntelEngine.ResolveAnyDestination (Travel.psc:305; Schedule.psc:160). "Riverwood" (a town) is INFERRED to resolve.

Places (VERIFIED in gamedata/Skyrim.esm, persistent refs, group type 8, flag 0x400; positions from the REFR DATA):
  WhiterunMarketCenter 0x847A9 (24762,-7501,-3315) in WhiterunWorld 0x1A26F
  WhiterunMapMarkerREF 0x162CE (19855,-7423,-3583): about 4900 u west of the market, inside the gate, same worldspace
  WhiterunStablesMapMarker 0x72879: outside the city (Tamriel worldspace)
  LvlBanditMelee1H NPC_ 0x3DECB (B-4)
Player movement is by console moveto to these refs, or by the StepPlayer wrapper in about 500 u steps (B-24). Moving
the player in jumps is not walking; the tests judge F1's reaction, so jumps are INFERRED to be equivalent
(step8_time_plan.md :112).

Proposed IEB_TestCtl wrappers this module calls (not built yet; Papyrus in the agent report): Probe, NFFWait,
NFFFollow, NFFDismiss, MoveRel, StepPlayer, FastTravelTo, Narrate, SitNearest, FurnState, SkipProbe, ScheduleMeeting,
SetIEWaitHours, AddTestOverride, RemoveTestOverride. A missing wrapper shows up as INCONCLUSIVE (precondition).
Never prints prompt text: B-27/B-28 report marker presence only."""
import math, os, random, re, subprocess, sys, time
from contextlib import contextmanager
from datetime import datetime

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, ".."))
import game
from block import test, settle_probe
from runner import eligible

# ---------------------------------------------------------------- T0 cast and places (AGENT_BRIEF.md T0 table)
PLAYER = 0x14
F1 = 0x000E1BA9            # Jenassa (also E)
F2 = 0x00091918            # Uthgerd
H = 0x0002C90F             # Brenuin: SA Home/Work/Relax
PROT = 0x0001A675          # Carlotta Valentia: adult non-follower (Anoriath guards her)
DEFAULT_NAMES = {F1: "Jenassa", F2: "Uthgerd the Unbroken", H: "Brenuin", PROT: "Carlotta Valentia"}
JENASSA_BASE = 0x000B9982  # HirelingJenassa (investigation/round10/t0_setup_research.md :91)
MARKET = 0x000847A9
GATE = 0x000162CE
STABLES = 0x00072879
BANDIT = 0x0003DECB
DEST_NEAR = "The Bannered Mare"
DEST_MARKET = DEST_NEAR   # [CHANGED 2026-10-10] was "the marketplace", which IntelEngine resolves to Windhelm (a real-play
#   resolver finding: investigation/round10/ie_destination_resolver.md). "The Bannered Mare" resolves to the inn's exterior
#   door (25918,-6863), about 6200 u from the gate; IntelEngine may take the NPC through the door ("reached door,
#   teleporting through"), and its linger then walks her toward the player.
DEST_UP = "Dragonsreach"
DEST_FAR = "Riverwood"

# The request log (R2, step8_time_plan.md :61). VERIFIED path 2026-10-10 (find under the output mod).
REQLOG = ("C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/SkyrimNet Test - Output/SKSE/Plugins/SkyrimNet/logs/"
          "openrouter_input.log")

DECIDE = ("TAKE", "TAKE_SKIP", "LEND", "REFUSE")
REL_KW = ("RELEASE", "RELEASE_STAY", "RELEASE_FOLLOW", "RELEASE_SEATLOST", "RELEASE_DEAD", "REJOIN_WAIT")
REJOIN_EXIT = ("REJOIN_DONE", "REJOIN_TO_WAIT", "REJOIN_CANCELLED")
N_DEFAULT = 1920.0         # spec §7.2 :1108 (0.75 x 2560)

# ---------------------------------------------------------------- small helpers


def hexid(fid):
    return "%08X" % fid


def hexrx(fid):
    """PO3 IntToString(id, true) is INFERRED to print 0x-prefixed hex; match with or without leading zeros."""
    return r"(?i:0x0*%X)\b" % fid


def num(v):
    try:
        return float(v)
    except (TypeError, ValueError):
        return None


def dist2(a, b):
    return math.dist(a[:2], b[:2]) if a and b else None


def fresh(kind="papyrus"):
    return game.Tail(game.LOGS[kind])


def con(r, cmd):
    """Console over MCP. Output is not relied on (AGENT_BRIEF: INFERRED that MCP returns it); checks use the logs."""
    res = r.tool("execute_console_command", {"command": cmd})
    if isinstance(res, dict) and res.get("error"):
        r.log("  console %r -> error %s" % (cmd, res["error"]))
    return res


def ctl_line(r, fn, args, pattern, timeout=15):
    """Call an IEB_TestCtl function and wait for its [IEB-TEST] line (written after the call)."""
    t = fresh()
    r.ctl(fn, args)
    return t.wait(pattern, timeout)


def need(r, cond, why):
    if not cond:
        r.inconclusive += 1
        r.log("INCONCLUSIVE %s precondition: %s" % (r.name, why))
    return bool(cond)


def until(fn, timeout, every=3.0):
    end = time.time() + timeout
    while True:
        v = fn()
        if v or time.time() >= end:
            return v
        time.sleep(every)


# ---------------------------------------------------------------- watcher lines (IEB_Watcher.Line, IEB_Watcher.psc:85-146)
KEYS = ("rt", "gt", "cell", "loaded", "dPlayer", "dDest", "tm", "wfp", "nffSeat", "cff", "pkg", "ovr", "ieSlot",
        "slotCount", "ieTask", "iebHeld", "iebLent", "iebGate", "iebMode", "iebRecall", "combat", "dead")


def parse_line(l):
    d = dict(re.findall(r"(?<![\w.])(%s)=(\S*)" % "|".join(KEYS), l))
    m = re.search(r"\bpos=(-?\d+),(-?\d+),(-?\d+)", l)
    d["xyz"] = tuple(float(x) for x in m.groups()) if m else None
    m = re.search(r"\bgt=\S+ (.+?) 0x[0-9A-Fa-f]+ cell=", l)
    d["name"] = m.group(1) if m else None
    d["cellid"] = d.get("cell", "").split(":")[0]
    return d


def probe(r, fid, timeout=10):
    """Proposed wrapper Probe(formId): logs "[IEB-TEST] probe <IEB_Watcher.Line(a)>" without touching the Snapshot
    baseline. Works for unloaded actors (positions then read stale=1)."""
    m = ctl_line(r, "Probe", [fid], r"\[IEB-TEST\] probe (.*%s.*)" % hexrx(fid), timeout)
    return parse_line(m.group(1)) if m else None


def wsamples(text, fid):
    """The watcher's 3 s lines for one actor (not BURST / ASSERT lines)."""
    rx = re.compile(hexrx(fid))
    return [parse_line(l) for l in text.splitlines()
            if " dPlayer=" in l and "BURST" not in l and "ASSERT" not in l and rx.search(l)]


def warps(samples, near=900.0, speed=450.0, jump=1500.0, short=4.5):
    """NFF warp signature while held (iebHeld 1/2): the actor lands within `near` of the player after either a jump of
    more than `jump` u between samples at most `short` s apart, or a speed above `speed` u/s (a warp is instant; a jog
    is ~170 u/s), or after being unloaded (NFF warps to just behind the player, spec §7.2 :1098, :1119). Reviewer
    2026-10-10: at the fixed 3 s sampling a warp from just past nwsWarpRange (2560) to ~200 u is ~790 u/s, so the earlier
    800 u/s threshold would miss it. Sample gaps > `short` s inside a held window are caught by block.py
    (INCONCLUSIVE "watcher interval regressed"). Thresholds INFERRED. Only call this over windows in which the PLAYER
    did not teleport."""
    out, prev = [], None
    for s in samples:
        dp = num(s.get("dPlayer"))
        if prev is not None and s.get("iebHeld") in ("1", "2") and dp is not None and dp < near:
            dt = (num(s.get("rt")) or 0) - (num(prev.get("rt")) or 0)
            d = dist2(s["xyz"], prev["xyz"]) if s["xyz"] and prev["xyz"] else None
            if d is not None and dt > 0 and ((d > jump and dt <= short) or d / dt > speed):
                out.append("jump %.0f u in %.0f s (%.0f u/s) to dPlayer %.0f at gt=%s" % (d, dt, d / dt, dp, s.get("gt")))
            elif prev.get("loaded") == "0" and s.get("loaded") == "1":
                out.append("unloaded -> loaded at dPlayer %.0f at gt=%s" % (dp, s.get("gt")))
        prev = s
    return out


def name(r, fid):
    cache = r.__dict__.setdefault("_b_names", {})
    if fid not in cache:
        p = probe(r, fid)
        cache[fid] = (p or {}).get("name") or DEFAULT_NAMES.get(fid, hexid(fid))
    return cache[fid]


# ---------------------------------------------------------------- bridge log lines


def ieb_rx(kws, nm):
    return r"(?m)\[IEB\] (%s) actor=%s(?=[ \r]|$)(.*)$" % ("|".join(kws), re.escape(nm))


def wait_ieb(tail, kws, nm, timeout):
    m = tail.wait(ieb_rx(kws, nm), timeout)
    return (m.group(1), m.group(2).strip()) if m else None


def ieb_events(text, nm):
    return [(m.group(1), m.group(2).strip()) for m in re.finditer(ieb_rx(("[A-Z_]+",), nm), text)]


def arrived_rx(nm):
    return r"IntelEngine: %s arrived at" % re.escape(nm)


def ieb_errors(text):
    """Papyrus errors raised in IEB_ scripts (same rule as check_logs.py i5, BLD-4 probe excluded)."""
    lines, n = text.splitlines(), 0
    for i, l in enumerate(lines):
        if "error:" in l.lower() and "ieb_bld4probe" not in l.lower():
            frames = " ".join(x for x in lines[i + 1:i + 6] if x.startswith("\t"))
            if re.search(r"\bIEB_\w*\.", l + " " + frames):
                n += 1
    return n


# ---------------------------------------------------------------- game-side steps


def watch_on(r):
    con(r, "set IEB_TestWatch to 1")       # GLOB 0x801 ErrandBridgeTest.esp (VERIFIED EditorID in the plugin)


def player_to(r, ref, wait=4.0):
    con(r, "player.moveto %s" % hexid(ref))
    time.sleep(wait)


def bring(r, *fids):
    for f in fids:
        con(r, "%s.moveto player" % hexid(f))
    time.sleep(3)


def base(r, *fids, where=MARKET):
    """Common start: watcher on, the player at `where`, the NFF followers (F1, F2) next to the player. Non-followers
    (H, Carlotta) are never moved: their SA schedule / guard duty stays as in T0. Returns the names."""
    watch_on(r)
    player_to(r, where)
    bring(r, *[f for f in fids if f in (F1, F2)])
    return [name(r, f) for f in fids]


def snap(r, *fids, wfp=0.0):
    """Snapshot baseline (I2/I4) and the WFP that Check should find afterwards (T0: F1/F2 following = 0, INFERRED).
    [CHANGED 2026-10-10] Waits for each "[IEB-TEST] snapshot" line: MCP returns before Papyrus runs the call, and in
    U1 run 14 B-10 the Snapshot ran 2 s AFTER the errand had started, so the baseline held IntelEngine's travel
    package and the clean end state failed I2."""
    for f in fids:
        t = fresh()
        r.ctl("Snapshot", [f])
        if not t.wait(r"\[IEB-TEST\] snapshot .*%s" % hexrx(f), 20):
            r.log("  WARN snapshot line for %08X not seen within 20 s" % f)
        if wfp is not None:
            r.ctl("ExpectWFP", [f, float(wfp)])


def check_inv(r, fid, what="invariants after the errand (IEB_TestCtl.Check)"):
    m = ctl_line(r, "Check", [fid], r"\[IEB-TEST\] Check (.+?) -> (\w+)", 15)
    r.check(bool(m) and m.group(2).upper() == "TRUE", "%s: %s" % (what, m.group(2) if m else "no Check line"))


def go(r, fid, dest, tail, speed="1", wfp="1", timeout=25):
    """GoToLocation through IEB_TestCtl.StartTask (IE Director path, IEB_TestCtl.psc:49-125); returns the bridge's
    decision (kw, rest) or None. `tail` must be marked before the call."""
    r.ctl("StartTask", [fid, "GoToLocation", dest, speed, wfp])
    return wait_ieb(tail, DECIDE, name(r, fid), timeout)


def took(r, ev, who):
    return need(r, ev is not None and ev[0] == "TAKE", "no TAKE for %s (bridge decision: %s)" % (who, ev))


def tidy(r, *fids):
    """Teardown between tests: cancel any IE slot, leave the rejoin phase, put NFF followers back to following next to
    the player. Non-followers only get their task cancelled."""
    for fid in fids:
        try:
            p = probe(r, fid)
            if not p or p.get("dead") == "1":
                continue
            if p.get("ieSlot", "-1") not in ("-1", ""):
                r.ctl("Cancel", [fid])
                time.sleep(4)
                p = probe(r, fid) or p
            if p.get("iebHeld") == "2":
                r.ctl("Recall", [fid, 0])
                time.sleep(3)
            elif p.get("iebHeld") == "1" or p.get("iebLent") == "1":
                time.sleep(5)
            p = probe(r, fid) or p
            if p.get("nffSeat", "-1") not in ("-1", ""):
                r.ctl("NFFFollow", [fid])
                con(r, "%s.moveto player" % hexid(fid))
        except Exception as e:      # teardown must not hide the test verdict
            r.log("  tidy %s: %r" % (hexid(fid), e))


@contextmanager
def accelerated(r, ts=1000.0):
    """Game-clock timeouts only (Shae's D3 rule; DECISIONS.md:393). Always restores and asserts the play timescale."""
    t = fresh()
    r.ctl("Accelerate", [float(ts)])
    m = t.wait(r"TIMESCALE accelerated to|ASSERT FAIL TIMESCALE", 15)
    ok = bool(m) and "accelerated" in m.group(0)
    if not ok:
        r.log("  Accelerate(%s) not confirmed: %s" % (ts, m.group(0) if m else "no line"))
    try:
        yield ok
    finally:
        restore_ts(r)


def restore_ts(r):
    m = ctl_line(r, "RestoreTimescale", [], r"ASSERT (PASS|FAIL) TIMESCALE", 20)
    r.check(bool(m) and m.group(1) == "PASS", "teardown: timescale restored to the recorded play value")


def rejoin_info(r, fid=F1):
    """IEB_TestCtl.Rejoin (psc :260-278): loaded, sameSpace, dist, dZ, N, allowWarp."""
    m = ctl_line(r, "Rejoin", [fid], r"\[IEB-TEST\] Rejoin .*? loaded=(\w+) sameSpace=(\w+) dist=(\S+) dZ=(\S+) "
                                     r"N=(\S+) allowWarp=(\w+)", 10)
    if not m:
        return None
    return dict(loaded=m.group(1).upper() == "TRUE", same=m.group(2).upper() == "TRUE", dist=num(m.group(3)),
                dz=num(m.group(4)), N=num(m.group(5)) or N_DEFAULT, warp=m.group(6).upper() == "TRUE")


def far_from_player(r, fid, d, timeout):
    def f():
        p = probe(r, fid)
        dp = num((p or {}).get("dPlayer"))
        return p if dp is not None and dp > d else None
    return until(f, timeout)


VISIT_S = 40     # [CHANGED 2026-10-10, reviewer-approved] was 10 s. IntelEngine's shared quest timer makes its travel loop
#   tick every ~30 s (upstream defect, investigation/round10/ie_timer_collision.md), so a 10 s visit can fall between two
#   CheckWaiting ticks and never register (B-1 run 11 FAIL, recorded). 40 s = one tick + margin. After the IE timer fix,
#   B-1 re-runs with BOTH 10 s (the real-play check) and 40 s.


def finish_by_visit(r, fid, tail, leave_to=GATE, timeout=90, visit=None):
    """v1 test 1's ending: the player walks to the waiting follower, stays `visit` s (default VISIT_S), then goes 1000+ u
    away (moveto, INFERRED equivalent). Logs IntelEngine's heartbeat ticks around the visit."""
    visit = VISIT_S if visit is None else visit
    pt = fresh()
    player_to(r, fid, wait=visit)       # IE CheckWaiting: player < 1000 u -> arrival handling (Travel.psc:717-728)
    ticks = [l[1:23] for l in pt.read().splitlines() if "Story: StartScheduler" in l]
    r.log("  visit %d s; IntelEngine ticks during it: %s" % (visit, ticks or "none"))
    player_to(r, leave_to)
    return wait_ieb(tail, REL_KW, name(r, fid), timeout)


# ---------------------------------------------------------------- request log (R2) for B-27 / B-28
HDR = re.compile(r"(?m)^\[\d{4}-\d\d-\d\d [\d:.]+\] \[([^\]]*)\] (\w+) request \[[^\]]+\]:")


def requests(text):
    hs = list(HDR.finditer(text))
    for i, h in enumerate(hs):
        yield h.group(1), h.group(2), text[h.end(): hs[i + 1].start() if i + 1 < len(hs) else len(text)]


def th_window(body, nm):
    """The 0600 'Travel History with' section if it names nm (0600 renders it only in full/thoughts/transform mode,
    i.e. for the speaker's bio: INFERRED that this identifies the speaker's dialogue_response request)."""
    i = body.find("### Travel History with")
    while i >= 0:
        j = body.find("###", i + 5)
        w = body[i: j if j > 0 else i + 800]
        if nm in w:
            return w
        i = body.find("### Travel History with", i + 5)
    return None


def wait_request(tail, nm, timeout=90):
    """The first request after the tail mark whose Travel History section names nm. Returns its body (never logged)."""
    def f():
        for tag, kind, body in requests(tail.read()):
            if th_window(body, nm) is not None:
                return True
        return None
    if not until(f, timeout):
        return None
    time.sleep(3)                       # let the record finish writing
    for tag, kind, body in requests(tail.read()):
        if th_window(body, nm) is not None:
            return body
    return None


def th_branch(body, nm):
    """Which 0600 line rendered (SkyrimNet base 0600_relationships.prompt:15-24): marker names only."""
    w = th_window(body, nm) or ""
    if "has never been a member of" in w:
        return "never"
    if "has been a member of" in w:
        return "has_been"
    if "is a member of" in w:
        return "member"
    return "none"


def narrate(r, fid):
    """Proposed wrapper Narrate(formId): SkyrimNetApi.DirectNarration("", actor, player): ephemeral event, immediate
    response, nothing persisted (VERIFIED doc, repos/SkyrimNet-GamePlugin-b25/Source/Scripts/SkyrimNetApi.psc:196-208)."""
    return ctl_line(r, "Narrate", [fid], r"\[IEB-TEST\] Narrate .* rc=(-?\d+)", 10)


# ---------------------------------------------------------------- shared flows


def rejoin_setup(r, label):
    """B-23's flow, also the precondition of B-24/B-25/B-26: the errand ends far away by IntelEngine's game-time wait
    timeout. Player and F1 at the gate; F1 sent to DEST_MARKET (the Bannered Mare, about 6200 u); the player stays,
    so F1 arrives with the player > 1000 u away and waits (Travel.psc:612-647); Accelerate(1000) runs the 48 h wait out
    (about 3 real min; OnWaitTimeout -> ClearSlotRestoreFollower); the bridge then sees F1 loaded, same space, beyond N
    -> REJOIN_WAIT (spec §7.1 :1085). Returns dict(end, spot, take_tail) or None (INCONCLUSIVE logged)."""
    nm = base(r, F1, where=GATE)[0]
    snap(r, F1)
    t = fresh()
    ww = fresh("watch")
    if not took(r, go(r, F1, DEST_MARKET, t), nm):
        return None
    arr = t.wait(arrived_rx(nm), 180)
    if not need(r, arr, "%s: F1 did not arrive at %s within 180 s" % (label, DEST_MARKET)):
        return None
    held = wsamples(ww.read(), F1)
    jumps = warps(held)
    r.check(not jumps, "%s: no NFF warp while F1 walked off (%s)" % (label, "; ".join(jumps) or "none"))
    time.sleep(3)
    spot = probe(r, F1) or {}
    ri = rejoin_info(r) or {}
    r.log("  %s: end spot dPlayer=%s loaded=%s N=%s" % (label, spot.get("dPlayer"), spot.get("loaded"), ri.get("N")))
    if not need(r, spot.get("loaded") == "1" and (num(spot.get("dPlayer")) or 0) > (ri.get("N") or N_DEFAULT),
                "%s: F1 must be loaded and beyond N at the end spot (loaded=%s dPlayer=%s)"
                % (label, spot.get("loaded"), spot.get("dPlayer"))):
        return None
    end = None
    with accelerated(r) as ok:
        if need(r, ok, "%s: Accelerate(1000) refused or not confirmed" % label):
            end = wait_ieb(t, REL_KW, nm, 420)
    return dict(end=end, spot=spot, tail=t)


def in_rejoin(r, label):
    """Continue from the previous test's rejoin phase if F1 is still in it (B-23 -> B-24), else rebuild it."""
    p = probe(r, F1) or {}
    if p.get("iebHeld") == "2":
        r.log("  %s: continuing from the rejoin phase left by the previous test" % label)
        return True
    tidy(r, F1)
    res = rejoin_setup(r, label)
    if res is None:
        return False
    return need(r, res["end"] is not None and res["end"][0] == "REJOIN_WAIT",
                "%s: rejoin phase not reached (errand ended with %s)" % (label, res["end"]))


def run_burst(r, label):
    res = subprocess.run([sys.executable, os.path.join(HERE, "burst_b22.py"), game.LOGS["watch"]],
                         capture_output=True, text=True, timeout=120)
    asserts = 0
    for l in res.stdout.splitlines():
        if l.startswith("ASSERT"):
            asserts += 1
            r.check(l.startswith("ASSERT PASS"), "%s burst: %s" % (label, l.split(" ", 2)[-1]))
        elif l.strip():
            r.log("  %s burst: %s" % (label, l))
    if not asserts and res.returncode:
        r.check(False, "%s burst: burst_b22.py exit %d %s" % (label, res.returncode, res.stderr.strip()[:200]))


# ================================================================ B-1 ... B-20 (v1 §5.5)


@test("B-1", "B")
def b1(r):
    """v1 test 1, happy path travel; v2: the end of a remote errand passes through REJOIN_WAIT (spec :3418).
    Route: from the gate to DEST_MARKET (the Bannered Mare; IntelEngine targets its exterior door), so F1 can stay
    loaded and the v2 REJOIN_WAIT branch can occur; the player then comes back within N of F1's actual position.
    The visit lasts VISIT_S (40 s): the original 10 s visit FAILS because of IntelEngine's ~30 s shared tick (upstream
    defect, ie_timer_collision.md; run 11 recorded FAIL). After the IE timer fix, re-run with 10 s and 40 s."""
    try:
        nm = base(r, F1, where=GATE)[0]
        snap(r, F1)
        t = fresh()
        ww = fresh("watch")
        ev = go(r, F1, DEST_MARKET, t)
        if not took(r, ev, nm):
            return
        r.check(ev[1].startswith("mode=1"), "TAKE is an NFF park (mode=1): %s" % ev[1])
        arr = t.wait(arrived_rx(nm), 180)
        held = wsamples(ww.read(), F1)
        dmax = max([num(s.get("dPlayer")) or 0 for s in held] or [0])
        r.check(dmax > 2560, "dPlayer grew beyond 2560 while held (max %.0f)" % dmax)
        jumps = warps(held)
        r.check(not jumps, "no NFF warp, no jump back (%s)" % ("; ".join(jumps) or "none"))
        if not need(r, arr, "F1 did not arrive within 180 s"):
            return
        end = finish_by_visit(r, F1, t)
        r.check(end is not None, "errand ended after the player visited and left (IE T1): %s" % (end,))
        r.check(end is not None and end[0] == "REJOIN_WAIT", "v2: the end passes through REJOIN_WAIT (got %s)" % (end,))
        if end and end[0] == "REJOIN_WAIT":
            # Reviewer item 1 (2026-10-10): F1 is not where the errand ended (IntelEngine's linger "approach first"
            # walks her toward the player, Travel.psc:1347-1358), so "came back" = within N of her ACTUAL position.
            # Log the §7.2 inputs before and after, and every bridge line in the window.
            ri0 = rejoin_info(r) or {}
            r.log("  rejoin inputs before: %s" % ri0)
            tr = fresh()
            r.ctl("MoveRel", [PLAYER, F1, 600.0, 0.0, 0.0])     # the player comes back within N (600 u from F1)
            time.sleep(2)
            ri1 = rejoin_info(r) or {}
            r.log("  rejoin inputs after the player came back: %s" % ri1)
            d = wait_ieb(tr, REJOIN_EXIT, nm, 30)
            for l in tr.read().splitlines():
                if "[IEB]" in l and nm in l:
                    r.log("  bridge: " + l.strip()[:200])
            r.check(d is not None and d[0] == "REJOIN_DONE", "REJOIN_DONE when the player came back within N (%s)" % (d,))
        time.sleep(5)
        check_inv(r, F1)
        p = probe(r, F1) or {}
        r.check(p.get("tm") == "1" and p.get("iebHeld") == "0", "teammate on, no hold (tm=%s iebHeld=%s)"
                % (p.get("tm"), p.get("iebHeld")))
    finally:
        tidy(r, F1)
        player_to(r, MARKET)


@test("B-2", "B")
def b2(r):
    """v1 test 2, happy path fetch: FetchPerson "Adrianne" (v1 name; INFERRED that IE matches Adrianne Avenicci)."""
    try:
        nm = base(r, F1)[0]
        snap(r, F1)
        t = fresh()
        r.ctl("StartTask", [F1, "FetchPerson", "Adrianne", "", ""])
        if not took(r, wait_ieb(t, DECIDE, nm, 25), nm):
            return
        end = wait_ieb(t, REL_KW, nm, 300)
        if not need(r, end, "fetch did not finish within 300 s (play timescale)"):
            return
        r.log("  fetch ended with %s; IE lines: allocated=%d cleared=%d" % (
            end, len(re.findall(r"Allocated slot \d+ to", t.read())), len(re.findall(r"Clearing slot \d+:", t.read()))))
        r.check(end[0] in ("RELEASE_FOLLOW", "REJOIN_WAIT"), "TAKE ... N1 -> release (%s)" % end[0])
        if end[0] == "REJOIN_WAIT":
            tr = fresh()
            player_to(r, F1)
            d = wait_ieb(tr, REJOIN_EXIT, nm, 30)
            r.check(d is not None and d[0] == "REJOIN_DONE", "REJOIN_DONE when the player came near (%s)" % (d,))
        time.sleep(5)
        check_inv(r, F1)
    finally:
        tidy(r, F1)
        player_to(r, MARKET)


@test("B-3", "B", reload=True)
def b3(r):
    """v1 test 3: test 1 until dPlayer > 3000; save; load -> LOAD/RECONCILE keeps the hold (wfp 1); IE re-applies
    travel ("Recovered travel package"); the task completes; release. Leaves the game on save IEB_B3 (reload=True)."""
    try:
        nm = base(r, F1, where=GATE)[0]
        snap(r, F1)
        t = fresh()
        if not took(r, go(r, F1, DEST_MARKET, t), nm):
            return
        p = far_from_player(r, F1, 3000, 120)
        if not need(r, p, "dPlayer never exceeded 3000 within 120 s"):
            return
        arrived_before = bool(re.search(arrived_rx(nm), t.read()))
        con(r, "save IEB_B3")
        time.sleep(10)
        tl = fresh()
        if not need(r, game.load(r, "IEB_B3", settle_probe(r)), "load IEB_B3 failed"):
            return
        time.sleep(20)                          # second reconcile at about +15 ticks (IEB_Main.psc:99-106)
        txt = tl.read()
        r.check(bool(re.search(r"\[IEB\] SETUP", txt)) and bool(re.search(r"\[IEB\] RECONCILE", txt)),
                "LOAD -> RECONCILE logged (level-2 lines SETUP, RECONCILE)")
        r.check(not ieb_events(txt, nm) or all(k in ("REPARK",) for k, _ in ieb_events(txt, nm)),
                "reconcile kept the hold (no release line: %s)" % ieb_events(txt, nm))
        if arrived_before:
            r.log("  F1 had already arrived before the save: no travel package to recover (state 2)")
        else:
            r.check(bool(re.search(r"IntelEngine: Recovered travel package for %s" % re.escape(nm), txt)),
                    "IntelEngine re-applied travel after the load")
        p = probe(r, F1) or {}
        r.check(p.get("iebHeld") == "1" and num(p.get("wfp")) == 1.0, "still held after the load (iebHeld=%s wfp=%s)"
                % (p.get("iebHeld"), p.get("wfp")))
        if not arrived_before and not need(r, tl.wait(arrived_rx(nm), 180), "F1 did not arrive after the load"):
            return
        end = finish_by_visit(r, F1, tl)
        r.check(end is not None, "task completed and released: %s" % (end,))
        if end and end[0] == "REJOIN_WAIT":
            tr = fresh()
            player_to(r, MARKET)
            d = wait_ieb(tr, REJOIN_EXIT, nm, 30)
            r.check(d is not None and d[0] == "REJOIN_DONE", "REJOIN_DONE (%s)" % (d,))
        time.sleep(5)
        check_inv(r, F1)
    finally:
        tidy(r, F1)


@test("B-3b", "B", reload=True)
def b3b(r):
    """v1 test 3b: load a save made before the errand while the errand runs -> no slot, no hold; invariants pass."""
    try:
        nm = base(r, F1)[0]
        snap(r, F1)
        con(r, "save IEB_B3b_pre")
        time.sleep(10)
        t = fresh()
        if not took(r, go(r, F1, DEST_UP, t), nm):
            return
        time.sleep(5)
        tl = fresh()
        if not need(r, game.load(r, "IEB_B3b_pre", settle_probe(r)), "load IEB_B3b_pre failed"):
            return
        time.sleep(20)
        p = probe(r, F1) or {}
        r.check(p.get("ieSlot") == "-1", "IntelEngine has no slot for F1 (ieSlot=%s)" % p.get("ieSlot"))
        r.check(p.get("iebHeld") == "0" and p.get("iebGate") == "0", "no hold (iebHeld=%s iebGate=%s)"
                % (p.get("iebHeld"), p.get("iebGate")))
        evs = [e for e in ieb_events(tl.read(), nm)]
        r.check(not evs, "reconcile did nothing to F1 (%s)" % evs)
        check_inv(r, F1)
    finally:
        tidy(r, F1)


@test("B-4", "B", reload=True)
def b4(r):
    """v1 test 4: a hostile near F's route (LvlBanditMelee1H placed at F1, console placeatme; the corpse and any guard
    aggro are why the save is reloaded after)."""
    try:
        nm = base(r, F1)[0]
        snap(r, F1)
        t = fresh()
        if not took(r, go(r, F1, DEST_UP, t), nm):
            return
        time.sleep(4)
        ww = fresh("watch")
        # Reviewer 2026-10-10: spawn through SpawnHostile so the bandit's ref is known, and log both sides' combat
        # state; if F1 never fights, the PRECONDITION failed (INCONCLUSIVE), unless a real check fails.
        pt = fresh()
        r.ctl("SpawnHostile", [BANDIT])
        m = pt.wait(r"\[IEB-TEST\] SpawnHostile \S+ ref=(\S+)", 15)
        bref = int(m.group(1), 16) if m else None
        if bref is not None and bref >= 2 ** 31:
            bref -= 2 ** 32                     # Papyrus Int is signed; spawned refs are 0xFF......
        if bref is not None:
            r.ctl("MoveRel", [bref, F1, 200.0, 0.0, 0.0])     # next to F1 on her route, as v1's placeatme at F did
        seen = None
        t_end = time.time() + 60
        while time.time() < t_end and not seen:
            for fid, who in ((bref, "bandit"), (F1, "F1")):
                if fid:
                    cm = ctl_line(r, "CombatProbe", [fid], r"\[IEB-TEST\] CombatProbe (.*)", 10)
                    r.log("  %s: %s" % (who, cm.group(1) if cm else "no CombatProbe line (wrapper missing?)"))
            seen = any(s.get("combat") == "1" for s in wsamples(ww.read(), F1))
            time.sleep(5)
        if seen:
            r.check(True, "F1 fought (combat=1 in the watcher: NFF combat AI participates)")
        else:
            r.inconclusive += 1
            r.log("INCONCLUSIVE B-4 precondition: F1 never entered combat within 60 s (see the bandit/F1 CombatProbe "
                  "lines: target, aggression, dead)")
        arr = t.wait(arrived_rx(nm), 240)
        smp = wsamples(ww.read(), F1)
        r.check(all(s.get("iebHeld") == "1" for s in smp), "still held through the fight (%d samples)" % len(smp))
        r.check(not [e for e in ieb_events(t.read(), nm) if e[0] in REL_KW], "no release during the fight")
        r.check(bool(arr), "IntelEngine continued after combat (arrival at %s)" % DEST_UP)
        tc = fresh()
        r.ctl("Cancel", [F1])
        end = wait_ieb(tc, REL_KW, nm, 30)
        r.check(end is not None, "release at the end (%s)" % (end,))
    finally:
        tidy(r, F1)


@test("B-5", "B")
def b5(r):
    """v1 test 5 (+v2 :3418): GoToLocation Riverwood, player stays; F unloads; no NFF warp; IE off-screen arrival; the
    48 h wait times out under Accelerate(1000); release with the teammate restored.
    NOTE (spec conflict): §15.3 says the end passes through REJOIN_WAIT, but §7.1/§7.2 U1 (:1084, :1098; IEB_Main.psc
    :444-448) release an UNLOADED follower with warp on straight to RELEASE_FOLLOW. Both are accepted; the kind is logged."""
    try:
        nm = base(r, F1)[0]
        snap(r, F1)
        t = fresh()
        ww = fresh("watch")
        if not took(r, go(r, F1, DEST_FAR, t), nm):
            return
        unl = until(lambda: any(s.get("loaded") == "0" for s in wsamples(ww.read(), F1)), 150)
        r.check(bool(unl), "F1 unloaded on the way (loaded=0, stale=1)")
        end = None
        with accelerated(r) as ok:
            if need(r, ok, "Accelerate(1000) not confirmed"):
                end = wait_ieb(t, REL_KW, nm, 480)
        txt = t.read()
        off = re.search(r"IntelEngine: %s (reached destination cell \(off-screen\)|arrived at)" % re.escape(nm), txt)
        r.check(bool(off) or "Travel timeout" in txt, "IntelEngine off-screen arrival (%s)"
                % (off.group(1) if off else "timeout force-arrive" if "Travel timeout" in txt else "none"))
        held = [s for s in wsamples(ww.read(), F1)]
        jumps = warps(held)
        r.check(not jumps, "no NFF warp while held (%s)" % ("; ".join(jumps) or "none"))
        if not need(r, end, "no release within 480 s at x1000"):
            return
        r.log("  release kind %s (U1 predicts RELEASE_FOLLOW for an unloaded follower with warp on)" % end[0])
        r.check(end[0] in ("REJOIN_WAIT", "RELEASE_FOLLOW"), "timeout T3 -> release (%s)" % end[0])
        time.sleep(15)
        p = probe(r, F1) or {}
        r.check(p.get("tm") == "1", "teammate restored after the timeout (tm=%s; stock leaves it off)" % p.get("tm"))
    finally:
        tidy(r, F1)


@test("B-6", "B", reload=True)
def b6(r):
    """v1 test 6: dismiss F mid-task through NFF (proposed wrapper NFFDismiss = NFF's own RemoveFollower(a, 0, 0);
    INFERRED equivalent to the MCM/menu dismiss, nwsFollowerUILIBScript.psc:235-241). The errand is then ended by
    Cancel (B-5 covers the timeout end; INFERRED same Release path). F1 stays dismissed: reload after."""
    try:
        nm = base(r, F1)[0]
        snap(r, F1)
        t = fresh()
        ww = fresh("watch")
        if not took(r, go(r, F1, DEST_FAR, t), nm):
            return
        until(lambda: any(s.get("loaded") == "0" for s in wsamples(ww.read(), F1)), 90)
        td = fresh()
        m = ctl_line(r, "NFFDismiss", [F1], r"\[IEB-TEST\] NFFDismiss .* seated=(\w+)", 15)
        if not need(r, m, "NFFDismiss wrapper missing or silent"):
            return
        time.sleep(5)
        p = probe(r, F1) or {}
        r.check(p.get("nffSeat") == "-1", "NFF seat cleared by the dismissal (nffSeat=%s)" % p.get("nffSeat"))
        r.ctl("Cancel", [F1])
        end = wait_ieb(td, REL_KW, nm, 30)
        r.check(end is not None and end[0] == "RELEASE_SEATLOST", "RELEASE_SEATLOST (%s)" % (end,))
        time.sleep(10)
        p = probe(r, F1) or {}
        r.check(p.get("nffSeat") == "-1", "F1 not re-recruited (nffSeat=%s)" % p.get("nffSeat"))
        r.check(p.get("tm") == "0", "teammate stays off after the NFF dismissal (tm=%s)" % p.get("tm"))
        later = [e for e in ieb_events(td.read(), nm) if e[0] in ("RELEASE_FOLLOW", "RELEASE_STAY", "REJOIN_WAIT")]
        r.check(not later, "no follow/wait from the bridge after the seat was lost (%s)" % later)
    finally:
        r.ctl("Cancel", [F1])


@test("B-7", "B")
def b7(r):
    """v1 test 7: F1 and F2 tasked back to back -> two TAKEs, two releases; both seats unchanged (Check I2)."""
    try:
        n1, n2 = base(r, F1, F2)
        snap(r, F1, F2)
        t = fresh()
        r.ctl("StartTask", [F1, "GoToLocation", DEST_NEAR, "1", "1"])
        r.ctl("StartTask", [F2, "GoToLocation", DEST_NEAR, "1", "1"])
        e1, e2 = wait_ieb(t, DECIDE, n1, 30), wait_ieb(t, DECIDE, n2, 30)
        r.check(e1 is not None and e1[0] == "TAKE", "TAKE F1 (%s)" % (e1,))
        r.check(e2 is not None and e2[0] == "TAKE", "TAKE F2 (%s)" % (e2,))
        time.sleep(15)
        r.ctl("Cancel", [F1])
        r.ctl("Cancel", [F2])
        x1, x2 = wait_ieb(t, REL_KW, n1, 30), wait_ieb(t, REL_KW, n2, 30)
        r.check(x1 is not None, "release F1 (%s)" % (x1,))
        r.check(x2 is not None, "release F2 (%s)" % (x2,))
        for f, x in ((F1, x1), (F2, x2)):
            if x and x[0] == "REJOIN_WAIT":
                r.ctl("Recall", [f, 0])
        time.sleep(6)
        check_inv(r, F1, "F1 seat and state unchanged (Check)")
        check_inv(r, F2, "F2 seat and state unchanged (Check)")
    finally:
        tidy(r, F1, F2)


@test("B-8", "B", reload=True)
def b8(r):
    """v1 test 8: F.kill during travel -> RELEASE_DEAD; NFF FollowerDeath ran (seat cleared, INFERRED marker); nothing
    from the bridge after death. Essential flag cleared first by console (INFERRED needed for a hireling)."""
    nm = base(r, F1)[0]
    snap(r, F1)
    t = fresh()
    if not took(r, go(r, F1, DEST_UP, t), nm):
        return
    time.sleep(5)
    con(r, "setessential %s 0" % hexid(JENASSA_BASE))
    con(r, "%s.kill" % hexid(F1))
    time.sleep(3)
    p = probe(r, F1) or {}
    if not need(r, p.get("dead") == "1", "console kill did not kill F1 (dead=%s; essential/protected?)" % p.get("dead")):
        return
    end = wait_ieb(t, REL_KW + ("REJOIN_CANCELLED",), nm, 30)
    r.check(end is not None and end[0] == "RELEASE_DEAD", "RELEASE_DEAD (%s)" % (end,))
    time.sleep(10)
    p = probe(r, F1) or {}
    r.check(p.get("nffSeat") == "-1", "NFF FollowerDeath cleared the seat (nffSeat=%s)" % p.get("nffSeat"))
    txt = t.read()
    i = txt.find("RELEASE_DEAD actor=%s" % nm)
    after = ieb_events(txt[i:], nm)[1:] if i >= 0 else []
    r.check(not after, "no bridge action on F1 after death (%s)" % after)


@test("B-9", "B")
def b9(r):
    """v1 test 9 / v2 CMD_FOLLOW: NFF "follow me" mid-task (proposed wrapper NFFFollow = FollowerFollowMe(a, 0), the
    bridge's own sync call, IEB_NFFLib.psc:68-73) -> CMD_FOLLOW -> IE cancel (C2) -> RELEASE_FOLLOW."""
    try:
        nm = base(r, F1)[0]
        snap(r, F1)
        t = fresh()
        if not took(r, go(r, F1, DEST_UP, t), nm):
            return
        time.sleep(6)
        r.ctl("NFFFollow", [F1])
        c = wait_ieb(t, ("CMD_FOLLOW",), nm, 15)
        r.check(c is not None, "CMD_FOLLOW")
        end = wait_ieb(t, REL_KW, nm, 20)
        r.check(end is not None and end[0] == "RELEASE_FOLLOW", "RELEASE_FOLLOW (%s)" % (end,))
        time.sleep(5)
        check_inv(r, F1)
    finally:
        tidy(r, F1)


@test("B-10", "B")
def b10(r):
    """v1 test 10 / v2: CancelCurrentTask stayHere 1 (IEB_TestCtl.Recall(F, 1) = IEB_Main.CancelOrRecall) mid-travel ->
    RELEASE_STAY with wfp 1 at the current spot."""
    try:
        nm = base(r, F1)[0]
        snap(r, F1)
        t = fresh()
        if not took(r, go(r, F1, DEST_UP, t), nm):
            return
        time.sleep(8)
        r.ctl("Recall", [F1, 1])
        q = wait_ieb(t, ("RECALL_REQ",), nm, 10)
        r.check(q is not None and "stay=1" in q[1], "RECALL_REQ stay=1 (%s)" % (q,))
        end = wait_ieb(t, REL_KW, nm, 20)
        r.check(end is not None and end[0] == "RELEASE_STAY", "RELEASE_STAY (%s)" % (end,))
        # "the current spot" = where she is at the release (spec): measured after RELEASE_STAY, not before the recall
        # (she jogs ~3 s / ~750 u while the recall goes through: U1 run 14).
        p0 = probe(r, F1) or {}
        time.sleep(10)
        p1 = probe(r, F1) or {}
        r.check(num(p1.get("wfp")) == 1.0 and p1.get("iebHeld") == "0", "waiting, no hold (wfp=%s iebHeld=%s)"
                % (p1.get("wfp"), p1.get("iebHeld")))
        d = dist2(p0.get("xyz"), p1.get("xyz"))
        r.check(d is not None and d < 768, "waits at the release spot (moved %s u in the 10 s after RELEASE_STAY; limit 768 INFERRED)"
                % ("%.0f" % d if d is not None else "?"))
        r.ctl("ExpectWFP", [F1, 1.0])
        check_inv(r, F1)
    finally:
        tidy(r, F1)


@test("B-11", "B")
def b11(r):
    """v1 test 11 (stock R1): GoTo A then GoTo B; B times out (game time, x1000) -> one continuous hold (debounce),
    release with the teammate on (stock leaves it off)."""
    try:
        nm = base(r, F1)[0]
        snap(r, F1)
        t = fresh()
        if not took(r, go(r, F1, DEST_UP, t), nm):
            return
        time.sleep(4)
        r.ctl("StartTask", [F1, "GoToLocation", DEST_NEAR, "1", "1"])
        two = until(lambda: len(re.findall(r"Allocated slot \d+ to %s for" % re.escape(nm), t.read())) >= 2, 20, 2)
        if not need(r, two, "the re-task (GoTo B) was not allocated"):
            return
        end = None
        with accelerated(r) as ok:
            if need(r, ok, "Accelerate(1000) not confirmed"):
                end = wait_ieb(t, REL_KW, nm, 480)
        evs = ieb_events(t.read(), nm)
        takes = [e for e in evs if e[0] == "TAKE"]
        r.check(len(takes) == 1, "one continuous hold: exactly one TAKE (%s)" % takes)
        rel = [e for e in evs if e[0] in REL_KW]
        r.check(len(rel) == 1, "exactly one release, at B's timeout (%s)" % rel)
        if not need(r, end, "B did not time out within 480 s at x1000"):
            return
        time.sleep(10)
        p = probe(r, F1) or {}
        r.check(p.get("tm") == "1", "teammate on after B's timeout (tm=%s)" % p.get("tm"))
    finally:
        tidy(r, F1)


@test("B-12", "B")
def b12(r):
    """v1 test 12 (stock R2): on a task, FetchPerson "NoSuchName" -> release within 2 ticks; teammate on."""
    try:
        nm = base(r, F1)[0]
        snap(r, F1)
        t = fresh()
        if not took(r, go(r, F1, DEST_UP, t), nm):
            return
        time.sleep(5)
        t2 = fresh()
        t0 = time.time()
        r.ctl("StartTask", [F1, "FetchPerson", "NoSuchName", "", ""])
        end = wait_ieb(t2, REL_KW, nm, 20)
        dt = time.time() - t0
        r.check(end is not None, "release after the failed re-task (%s, %.1f s)" % (end, dt))
        # 2 ticks = 2 s at IEB_PollSeconds 1.0 (gen_errandbridge.py:19); 10 s allows for IE's validation and log flush
        r.check(end is not None and dt <= 10, "within about 2 ticks (%.1f s; limit 10 s INFERRED)" % dt)
        time.sleep(4)
        p = probe(r, F1) or {}
        r.check(p.get("tm") == "1", "teammate on (tm=%s)" % p.get("tm"))
    finally:
        tidy(r, F1)


@test("B-13", "B", reload=True)
def b13(r):
    """v1 test 13: far GoToLocation with IE wait hours 168, Accelerate(1000) for 4 game days (about 6 real min) ->
    REPARK (v1 "REFRESH") at least every 24 game h (IEB_ParkRefreshHours 24); no NFF auto-dismiss. IE's wait hours are
    its MCM value, a StorageUtil float on the player (Core.psc:1667-1689), set by the proposed SetIEWaitHours wrapper
    before the task (Travel.psc:244-251 reads it at task start). Reload after: 4 game days pass."""
    m = None
    try:
        nm = base(r, F1)[0]
        snap(r, F1)
        m = ctl_line(r, "SetIEWaitHours", [168.0], r"IEWaitHours prev=(\S+)", 10)
        if not need(r, m, "SetIEWaitHours wrapper missing"):
            return
        t = fresh()
        if not took(r, go(r, F1, DEST_FAR, t), nm):
            return
        g0 = num((probe(r, F1) or {}).get("gt"))
        if not need(r, g0, "no game time from Probe"):
            return
        with accelerated(r) as ok:
            if need(r, ok, "Accelerate(1000) not confirmed"):
                until(lambda: (num((probe(r, F1) or {}).get("gt")) or 0) >= g0 + 4.0
                      or bool([e for e in ieb_events(t.read(), nm) if e[0] in REL_KW]), 720, 15)
        g1 = num((probe(r, F1) or {}).get("gt")) or g0
        r.log("  game days elapsed %.2f" % (g1 - g0))
        stamps = []
        for mm in re.finditer(r"(?m)^\[(\d\d/\d\d/\d{4}) - (\d\d:\d\d:\d\d)(AM|PM)\] \[IEB\] REPARK actor=%s(?=[ \r]|$)"
                              % re.escape(nm), t.read()):
            stamps.append(datetime.strptime(mm.group(1) + " " + mm.group(2) + mm.group(3), "%m/%d/%Y %I:%M:%S%p"))
        # real seconds -> game hours at timescale 1000 (INFERRED steady): h = s * 1000 / 3600
        gaps = [(b - a).total_seconds() * 1000.0 / 3600.0 for a, b in zip(stamps, stamps[1:])]
        r.log("  REPARK count %d, gaps (game h) %s" % (len(stamps), ["%.1f" % g for g in gaps]))
        r.check(g1 - g0 >= 3.9, "ran about 4 game days (%.2f)" % (g1 - g0))
        r.check(len(stamps) >= 3, "REPARK lines over 4 days (%d)" % len(stamps))
        r.check(not gaps or max(gaps) <= 26.0, "REPARK at least every 24 game h (max gap %.1f h incl. tick slack)"
                % (max(gaps) if gaps else 0))
        p = probe(r, F1) or {}
        r.check(p.get("nffSeat") not in ("-1", None) and p.get("iebHeld") == "1",
                "no NFF auto-dismiss; still held (nffSeat=%s iebHeld=%s)" % (p.get("nffSeat"), p.get("iebHeld")))
        rel = [e for e in ieb_events(t.read(), nm) if e[0] in REL_KW]
        r.check(not rel, "no release during the 4 days (%s)" % rel)
    finally:
        if m:
            prev = num(m.group(1))
            r.ctl("SetIEWaitHours", [prev if prev is not None else -1.0])
        tidy(r, F1)


@test("B-14", "B")
def b14(r):
    """v1 test 14 / v2 "also restores lends": `set IEB_Enabled to 0` mid-task -> DISABLE; held F1 released
    (Recall 1 -> RELEASE_FOLLOW, IEB_Main.psc:147-149); lent H restored (LEND_RESTORE why=disable, :140-142);
    IE SkipFollower* all true (IEB_IELib.psc:89-115; proposed SkipProbe wrapper); a new GoToLocation on F1 is silently
    refused (IE Core.psc:1075-1097 "Skipping GoToLocation for follower"); toggling back restores the old values."""
    sk0 = None
    try:
        nm, hn = base(r, F1, H)
        snap(r, F1)
        r.ctl("Snapshot", [H])
        sk0 = skip_probe(r)
        if not need(r, sk0, "SkipProbe wrapper missing"):
            return
        t = fresh()
        if not took(r, go(r, F1, DEST_UP, t), nm):
            return
        hl = go(r, H, DEST_NEAR, t)
        lend_ok = hl is not None and hl[0] == "LEND"
        r.log("  H decision %s (the lend part needs H on his Work shift)" % (hl,))
        if not lend_ok:
            r.inconclusive += 1
            r.log("INCONCLUSIVE B-14 lend part: H was not lent (%s)" % (hl,))
        td = fresh()
        con(r, "set IEB_Enabled to 0")
        d = td.wait(r"\[IEB\] DISABLE", 20)
        r.check(bool(d), "DISABLE")
        x = wait_ieb(td, REL_KW, nm, 5)
        r.check(x is not None and x[0] == "RELEASE_FOLLOW", "held F1 released (%s)" % (x,))
        if lend_ok:
            lr = wait_ieb(td, ("LEND_RESTORE", "LEND_RESTORE_SKIP"), hn, 5)
            r.check(lr is not None and lr[0] == "LEND_RESTORE" and "why=disable" in lr[1], "lend restored (%s)" % (lr,))
        sk1 = skip_probe(r) or {}
        r.check(sk1 and all(sk1[k] == 1 for k in SKIP_KEYS), "IntelEngine SkipFollower* all true (%s)" % sk1)
        tn = fresh()
        r.ctl("Cancel", [F1])
        time.sleep(4)
        r.ctl("StartTask", [F1, "GoToLocation", DEST_NEAR, "1", "1"])
        time.sleep(10)
        txt = tn.read()
        r.check(not re.search(r"Allocated slot \d+ to %s for" % re.escape(nm), txt), "new GoToLocation not allocated")
        r.check(bool(re.search(r"IntelEngine: Skipping GoToLocation for follower %s" % re.escape(nm), txt)),
                "refused silently by IE's skip-follower check")
    finally:
        te = fresh()
        con(r, "set IEB_Enabled to 1")
        e = te.wait(r"\[IEB\] ENABLE", 30)
        r.check(bool(e), "ENABLE after toggling back")
        if sk0:
            sk2 = skip_probe(r) or {}
            r.check(all(sk2.get(k) == sk0[k] for k in SKIP_KEYS), "SkipFollower* restored (%s -> %s)" % (sk0, sk2))
        tidy(r, F1, H)


SKIP_KEYS = ("goto", "deliver", "fetch", "escort", "search", "sfetch", "sdeliver", "smeet")


def skip_probe(r):
    m = ctl_line(r, "SkipProbe", [], r"\[IEB-TEST\] SkipProbe (.*)", 10)
    if not m:
        return None
    d = dict(re.findall(r"(\w+)=(-?\d+)", m.group(1)))
    return {k: int(d[k]) for k in SKIP_KEYS if k in d} if all(k in d for k in SKIP_KEYS) else None


@test("B-15", "B")
def b15(r):
    """v1 test 15: ScheduleMeeting for F1 (proposed wrapper -> IntelEngine_Schedule.ScheduleMeeting, Gerk
    Schedule.psc:121), clock at x1000 -> dispatch -> TAKE (scheduled travel skips IE's confirm/skip path,
    Travel.psc:197-206) -> F1 waits inside the Bannered Mare -> meeting timeout (meeting + 5 h, Travel.psc:614-620) ->
    release (F1 unloaded in the interior: U1 -> RELEASE_FOLLOW expected)."""
    try:
        nm = base(r, F1)[0]
        snap(r, F1)
        t = fresh()
        m = ctl_line(r, "ScheduleMeeting", [F1, DEST_NEAR, "in 2 hours"], r"\[IEB-TEST\] ScheduleMeeting .* ok=(\w+)", 30)
        if not need(r, m and m.group(1).upper() == "TRUE", "ScheduleMeeting wrapper missing or refused (%s)"
                    % (m.group(1) if m else "no line")):
            return
        end = tk = None
        with accelerated(r) as ok:
            if need(r, ok, "Accelerate(1000) not confirmed"):
                tk = wait_ieb(t, DECIDE, nm, 180)
                if tk is not None and tk[0] == "TAKE":
                    end = wait_ieb(t, REL_KW, nm, 360)
        r.check(tk is not None and tk[0] == "TAKE", "scheduled dispatch -> TAKE (%s)" % (tk,))
        r.check(end is not None, "release at the end of the meeting (%s)" % (end,))
        time.sleep(10)
        p = probe(r, F1) or {}
        r.check(p.get("tm") == "1" and p.get("iebHeld") in ("0", "2"), "teammate on after (tm=%s iebHeld=%s)"
                % (p.get("tm"), p.get("iebHeld")))
    finally:
        tidy(r, F1)


@test("B-16", "B", reload=True)
def b16(r):
    """v1 test 16: the player fast-travels away during test 5 (proposed wrapper FastTravelTo = Game.FastTravel,
    sdk/skse/Game.psc:42; INFERRED equal to a map fast travel) -> no SA CellCatchup move of F1 (wfp=1 skip, INFERRED),
    no NFF warp. Destination WhiterunStablesMapMarker. Reload after (time and place changed)."""
    nm = base(r, F1)[0]
    snap(r, F1)
    t = fresh()
    ww = fresh("watch")
    if not took(r, go(r, F1, DEST_FAR, t), nm):
        return
    until(lambda: any(s.get("loaded") == "0" for s in wsamples(ww.read(), F1)), 120)
    p0 = probe(r, F1) or {}
    sa = fresh("sa")
    m = ctl_line(r, "FastTravelTo", [STABLES], r"\[IEB-TEST\] FastTravelTo", 15)
    if not need(r, m, "FastTravelTo wrapper missing"):
        return
    time.sleep(30)
    for i in range(2):
        p = probe(r, F1) or {}
        dp = num(p.get("dPlayer"))
        r.check(p.get("iebHeld") == "1" and num(p.get("wfp")) == 1.0, "check %d: still held, wfp 1 (iebHeld=%s wfp=%s)"
                % (i + 1, p.get("iebHeld"), p.get("wfp")))
        r.check(dp is None or dp > 2560, "check %d: F1 not brought to the player (dPlayer=%s, cell %s -> %s)"
                % (i + 1, p.get("dPlayer"), p0.get("cellid"), p.get("cellid")))
        time.sleep(20)
    # SA's catch-up log format is not verified: any SeverActionsNative line naming F1 with "catch" counts (INFERRED)
    hits = [l for l in sa.read().splitlines() if nm in l and re.search(r"(?i)catch", l)]
    r.check(not hits, "no SA CellCatchup move of F1 (%d SA lines)" % len(hits))
    r.ctl("Cancel", [F1])


@test("B-18", "B")
def b18(r):
    """v1 test 18 / v2 matrix §12 (:3247-3260): check_action_eligibility over the states reachable on T0. S1-S4 and S7
    on F1, S5 on Carlotta (non-follower, not posted: INFERRED), S6 on H (lent while on his Work shift). True/False cells
    are checked; "stock" cells without a definite mark are recorded; S7 "stock" = the S1 result."""
    T, Fa = True, False
    matrix = {  # S1 S2 S3 S4 S5 S6 S7
        "CancelCurrentTask": [Fa, Fa, T, T, T, T, Fa],     # S7: pass-through only while on a task; F1 idle -> no
        "WaitForPlayerHere": [T, T, Fa, Fa, Fa, Fa, "S1"],  # S2 INFERRED ✔ (spec :3250)
        "ResumeFollowing": [T, T, Fa, Fa, Fa, Fa, "S1"],
        "SetCompanion": [Fa, Fa, Fa, Fa, None, Fa, "S1"],
        "StartFollowing": [Fa, Fa, Fa, Fa, None, Fa, "S1"],
        "DismissFollower": [T, T, T, T, Fa, Fa, "S1"],
    }
    rows = {}

    def row(state, u):
        idx = int(state[1]) - 1
        got = {}
        for act, exp in matrix.items():
            e = exp[idx]
            if e == "S1":
                e = rows.get("S1", {}).get(act)
            g, detail = eligible(r.tool("check_action_eligibility", {"action_name": act, "actor_uuid": u}))
            got[act] = g
            if e is None:
                r.log("  RECORD %s %s eligible=%s (stock)" % (state, act, g))
            else:
                r.check(g is e, "%s %s eligible=%s (matrix expects %s)" % (state, act, g, e))
        rows[state] = got

    try:
        nm, pn, hn = base(r, F1, PROT, H)
        uf, up, uh = r.uuid(F1)[0], r.uuid(PROT)[0], r.uuid(H)[0]
        if not need(r, uf and up and uh, "UUIDs not resolved (F1=%s Carlotta=%s H=%s)" % (bool(uf), bool(up), bool(uh))):
            return
        ready = until(lambda: eligible(r.tool("check_action_eligibility",
                                              {"action_name": "SitOrLayDown", "actor_uuid": up}))[0] is True, 300, 10)
        if not need(r, ready, "SeverActions never settled (Carlotta SitOrLayDown not eligible in 5 min)"):
            return
        row("S1", uf)
        r.ctl("NFFWait", [F1])
        time.sleep(3)
        row("S2", uf)
        r.ctl("NFFFollow", [F1])
        time.sleep(3)
        t = fresh()
        if took(r, go(r, F1, DEST_UP, t), nm):
            time.sleep(3)
            row("S3", uf)
            if far_from_player(r, F1, N_DEFAULT + 380, 90):
                tc = fresh()
                r.ctl("Cancel", [F1])
                x = wait_ieb(tc, REL_KW, nm, 20)
                if x is not None and x[0] == "REJOIN_WAIT":
                    time.sleep(2)
                    row("S4", uf)
                else:
                    r.inconclusive += 1
                    r.log("INCONCLUSIVE B-18 S4: release was %s, not REJOIN_WAIT" % (x,))
            else:
                r.inconclusive += 1
                r.log("INCONCLUSIVE B-18 S4: F1 never got beyond N")
            tidy(r, F1)
        t = fresh()
        r.ctl("StartTask", [PROT, "GoToLocation", DEST_NEAR, "1", "0"])
        if t.wait(r"IntelEngine: Allocated slot \d+ to %s for" % re.escape(pn), 25):
            dec = wait_ieb(t, DECIDE, pn, 5)
            r.log("  S5 bridge decision for %s: %s (expected none or TAKE_SKIP)" % (pn, dec))
            time.sleep(2)
            row("S5", up)
        else:
            r.inconclusive += 1
            r.log("INCONCLUSIVE B-18 S5: no IE slot for %s" % pn)
        tidy(r, PROT)
        t = fresh()
        hl = go(r, H, DEST_NEAR, t)
        if hl is not None and hl[0] == "LEND":
            time.sleep(2)
            row("S6", uh)
        else:
            r.inconclusive += 1
            r.log("INCONCLUSIVE B-18 S6: H was not lent (%s)" % (hl,))
        tidy(r, H)
        td = fresh()
        con(r, "set IEB_Enabled to 0")
        if td.wait(r"\[IEB\] DISABLE", 20):
            time.sleep(2)
            row("S7", uf)
        else:
            r.inconclusive += 1
            r.log("INCONCLUSIVE B-18 S7: no DISABLE line")
    finally:
        te = fresh()
        con(r, "set IEB_Enabled to 1")
        te.wait(r"\[IEB\] ENABLE", 30)
        tidy(r, F1, PROT, H)


@test("B-19", "B")
def b19(r):
    """v1 test 19 / v2 "applies always (patch present)": a non-follower with a known harmless override (proposed
    AddTestOverride: DefaultSandboxCurrentLocation256 Skyrim.esm 0x0956B8, the package spec :3408 already uses) is
    tasked; after the task the override count is back to that baseline (patched Core keeps non-IE overrides,
    build/src/intelengine IntelEngine_Core.psc:1061 RemoveIntelPackages instead of the blanket clear)."""
    added = False
    try:
        pn = base(r, PROT)[0]
        b0 = num((probe(r, PROT) or {}).get("ovr"))
        m = ctl_line(r, "AddTestOverride", [PROT], r"\[IEB-TEST\] AddTestOverride .* ovr=(\d+)", 10)
        if not need(r, m and b0 is not None, "AddTestOverride wrapper missing or no baseline"):
            return
        added = True
        b1_ = int(m.group(1))
        r.check(b1_ == b0 + 1, "test override added (ovr %d -> %d)" % (b0, b1_))
        t = fresh()
        r.ctl("StartTask", [PROT, "GoToLocation", DEST_NEAR, "1", "0"])
        if not need(r, t.wait(r"IntelEngine: Allocated slot \d+ to %s for" % re.escape(pn), 25), "no IE slot for %s" % pn):
            return
        dec = wait_ieb(t, DECIDE, pn, 5)
        r.log("  bridge decision %s" % (dec,))
        time.sleep(10)
        r.ctl("Cancel", [PROT])
        r.check(bool(t.wait(r"IntelEngine: Clearing slot \d+: %s" % re.escape(pn), 20)), "task ended (slot cleared)")
        if dec is not None and dec[0] == "LEND":
            wait_ieb(t, ("LEND_RESTORE", "LEND_RESTORE_SKIP"), pn, 20)
        time.sleep(5)
        b2_ = num((probe(r, PROT) or {}).get("ovr"))
        r.check(b2_ == b1_, "override count back to the baseline after the task (%s, baseline %d)" % (b2_, b1_))
    finally:
        if added:
            r.ctl("RemoveTestOverride", [PROT])
            time.sleep(2)
            b3_ = num((probe(r, PROT) or {}).get("ovr"))
            r.log("  after RemoveTestOverride ovr=%s" % b3_)
        tidy(r, PROT)


def quiesce(r, fid, timeout):
    def f():
        p = probe(r, fid)
        if p and p.get("iebHeld") == "0" and p.get("ieSlot") == "-1" and p.get("iebLent", "0") == "0":
            return p
        if p and p.get("iebHeld") == "2":
            r.ctl("Recall", [fid, 0])
        return None
    return until(f, timeout, 2)


@test("B-20", "B", reload=True)
def b20(r):
    """v1 test 20 (races): 50 loops of a short task (SearchForActor on an adjacent NPC, Carlotta), cancelled at a random
    0-5 s by IE's dashboard cancel or CancelCurrentTask stay 0; every 10th loop `save IEB_B20_<n>` + `load`. Play
    timescale (Shae's D3 rule: accumulation watch). Pass: zero ASSERT FAIL, no IEB_ Papyrus error, NFF seat stable.
    Test-only saves are left in the profile's saves folder (nothing deleted)."""
    if not need(r, ctl_line(r, "AssertTimescale", [], r"ASSERT PASS TIMESCALE", 15), "timescale is not the play value"):
        return
    nm, pn = base(r, F1, PROT)
    seat0 = (probe(r, F1) or {}).get("nffSeat")
    if not need(r, seat0 not in (None, "-1"), "F1 not seated"):
        return
    seed = int(time.time())
    rnd = random.Random(seed)
    r.log("  seed %d" % seed)
    moved, unsettled, takes = [], 0, 0
    for i in range(1, 51):
        t = fresh()
        r.ctl("StartTask", [F1, "SearchForActor", pn, "1", ""])
        time.sleep(rnd.uniform(0.0, 5.0))
        how = rnd.choice(("Cancel", "Recall0"))
        if how == "Cancel":
            r.ctl("Cancel", [F1])
        else:
            r.ctl("Recall", [F1, 0])
        p = quiesce(r, F1, 45)
        if not p:
            r.ctl("Cancel", [F1])
            p = quiesce(r, F1, 30)
        if not p:
            unsettled += 1
            r.log("  loop %d (%s): F1 did not settle" % (i, how))
            p = probe(r, F1) or {}
        evs = ieb_events(t.read(), nm)
        takes += sum(1 for e in evs if e[0] == "TAKE")
        if p.get("nffSeat") != seat0:
            moved.append((i, p.get("nffSeat")))
        r.log("  loop %d %s: %s" % (i, how, " ".join(k for k, _ in evs) or "no bridge line"))
        if i % 10 == 0:
            save = "IEB_B20_%d" % i
            con(r, "save %s" % save)
            time.sleep(10)
            if not game.load(r, save, settle_probe(r)):
                r.check(False, "load %s" % save)
                break
            bring(r, F1)
    r.log("  TAKEs seen %d over 50 loops" % takes)
    r.check(not moved, "NFF seat stable (moved: %s)" % moved)
    r.check(unsettled == 0, "every loop settled (unsettled %d)" % unsettled)
    fails = [l for l in r.tails["watch"].read().splitlines() if "ASSERT FAIL" in l]
    r.check(not fails, "zero watcher ASSERT FAIL (%d)" % len(fails))
    errs = ieb_errors(r.tails["papyrus"].read())
    r.check(errs == 0, "no Papyrus error from IEB_ scripts (%d)" % errs)


# ================================================================ B-21 ... B-31 (spec §15.3)


@test("B-21", "B")
def b21(r):
    """FollowerWaitHere F1 at A (proposed NFFWait wrapper); F1 moved 3000 u (proposed MoveRel wrapper = the spec's
    "F1.moveto player 3000 0 0"); watch 60 s: F1 sandboxes near the new spot; distance to A never drops by > 1024 u."""
    try:
        base(r, F1)
        r.ctl("NFFWait", [F1])
        time.sleep(4)
        pa = (probe(r, F1) or {}).get("xyz")
        if not need(r, pa, "no position for F1 at A"):
            return
        m = ctl_line(r, "MoveRel", [F1, PLAYER, 3000.0, 0.0, 0.0], r"\[IEB-TEST\] MoveRel", 10)
        if not need(r, m, "MoveRel wrapper missing"):
            return
        time.sleep(4)
        p1 = (probe(r, F1) or {}).get("xyz")
        if not need(r, p1, "no position after the move"):
            return
        d0 = dist2(p1, pa)
        # The watcher ticks every ~28 s in this load order (measured 2026-10-10 shakedown, also with the game focused),
        # so the 60 s watch uses the burst sampler (IEB_TestCtl.Burst: package/position only) instead.
        ww = fresh("watch")
        r.ctl("Burst", [F1, 60.0])
        time.sleep(66)
        smp = [{"xyz": tuple(float(v) for v in m.group(1, 2, 3))}
               for m in re.finditer(r"BURST \S+ \S+ wfp=\S+ pos=(\S+),(\S+),(\S+)", ww.read())]
        if not need(r, len(smp) >= 10, "too few burst samples (%d)" % len(smp)):
            return
        dmin = min(dist2(s["xyz"], pa) for s in smp)
        r.log("  d(A) start %.0f, min %.0f over %d samples" % (d0, dmin, len(smp)))
        r.check(dmin >= d0 - 1024, "distance to A never decreased by more than 1024 u (start %.0f, min %.0f)" % (d0, dmin))
        dl = dist2(smp[-1]["xyz"], p1)
        r.check(dl <= 1024, "F1 sandboxes near the new spot (%.0f u from it after 60 s)" % dl)
    finally:
        r.ctl("NFFFollow", [F1])
        bring(r, F1)


@test("B-22", "B")
def b22(r):
    """Watcher burst (IEB_TestCtl.Burst, 0.1 s) around the take and the release; burst_b22.py judges each
    nwsFollowerWaitBox interval (< 0.5 s, no heading back to the take position). The release is cancelled early so it
    ends in RELEASE_FOLLOW: a REJOIN_WAIT park is a by-design wait-box interval (§7.2) that this check does not cover."""
    try:
        nm = base(r, F1)[0]
        wb = fresh("watch")
        r.ctl("Burst", [F1, 30.0])
        if not need(r, wb.wait(r"BURST START", 15), "no BURST START"):
            return
        time.sleep(1.5)
        t = fresh()
        if not took(r, go(r, F1, DEST_UP, t), nm):
            return
        if not need(r, wb.wait(r"BURST END", 45), "first burst did not end"):
            return
        run_burst(r, "take")
        wb2 = fresh("watch")
        r.ctl("Burst", [F1, 20.0])
        if not need(r, wb2.wait(r"BURST START", 15), "no second BURST START"):
            return
        time.sleep(1.0)
        tc = fresh()
        r.ctl("Cancel", [F1])
        x = wait_ieb(tc, REL_KW, nm, 20)
        r.log("  release %s" % (x,))
        if not need(r, wb2.wait(r"BURST END", 35), "second burst did not end"):
            return
        if x is not None and x[0] == "REJOIN_WAIT":
            r.inconclusive += 1
            r.log("INCONCLUSIVE B-22 release burst: release went to REJOIN_WAIT (by-design park), not judged")
        else:
            run_burst(r, "release")
    finally:
        tidy(r, F1)


@test("B-23", "B")
def b23(r):
    """Errand ends far away by the game-time wait timeout (x1000), player about 4900 u away and F1 loaded ->
    REJOIN_WAIT; teammate on; F1 stays within 1024 u of the end spot; no NFF warp. Leaves F1 in the rejoin phase for
    B-24 (no teardown unless the test failed early)."""
    res = rejoin_setup(r, "B-23")
    if res is None:
        tidy(r, F1)
        return
    nm = name(r, F1)
    end = res["end"]
    r.check(end is not None and end[0] == "REJOIN_WAIT", "REJOIN_WAIT (%s)" % (end,))
    if not end or end[0] != "REJOIN_WAIT":
        tidy(r, F1)
        return
    time.sleep(2)
    p = probe(r, F1) or {}
    r.check(p.get("tm") == "1" and num(p.get("wfp")) == 1.0 and p.get("iebHeld") == "2",
            "rejoin phase: teammate on, wfp 1, iebHeld 2 (tm=%s wfp=%s iebHeld=%s)"
            % (p.get("tm"), p.get("wfp"), p.get("iebHeld")))
    spot = p.get("xyz") or res["spot"].get("xyz")
    ww = fresh("watch")
    tq = fresh()
    time.sleep(30)                      # play timescale again (restored in rejoin_setup's finally)
    smp = [s for s in wsamples(ww.read(), F1) if s["xyz"]]
    far = [round(dist2(s["xyz"], spot)) for s in smp if dist2(s["xyz"], spot) > 1024]
    r.check(smp and not far, "F1 stays within 1024 u of the end spot (%d samples, outside: %s)" % (len(smp), far))
    r.check(not warps(smp), "no NFF warp (%s)" % "; ".join(warps(smp)))
    ex = [e for e in ieb_events(tq.read(), nm) if e[0] in REJOIN_EXIT]
    r.check(not ex, "still parked: no rejoin exit while the player stays away (%s)" % ex)


@test("B-24", "B")
def b24(r):
    """Continue B-23: the player walks toward F1 (proposed StepPlayer wrapper, 500 u steps; INFERRED equivalent to
    walking) -> REJOIN_DONE once distance <= N (1920) and |dZ| <= N/2; F1 walks to the player; no teleport.
    NOTE: the spec names "REJOIN_DONE reason=near"; IEB_Main.psc:605 logs REJOIN_DONE without a reason field."""
    try:
        if not in_rejoin(r, "B-24"):
            return
        nm = name(r, F1)
        ri = rejoin_info(r) or {}
        n = ri.get("N") or N_DEFAULT
        t = fresh()
        steps, ev = [], None
        for i in range(25):
            m = ctl_line(r, "StepPlayer", [F1, -500.0], r"\[IEB-TEST\] StepPlayer .* dist=(\S+) dZ=(\S+)", 10)
            if not need(r, m, "StepPlayer wrapper missing or silent"):
                return
            steps.append((num(m.group(1)), num(m.group(2))))
            ev = wait_ieb(t, REJOIN_EXIT, nm, 2.5)
            if ev or (steps[-1][0] or 0) < 300:
                break
        r.log("  steps (dist, dZ): %s" % ["%.0f/%.0f" % s for s in steps])
        r.check(ev is not None and ev[0] == "REJOIN_DONE", "REJOIN_DONE while approaching (%s)" % (ev,))
        if ev:
            r.log("  REJOIN_DONE fields: '%s' (spec: reason=near)" % ev[1])
            d, dz = steps[-1]
            first_in = next((k for k, s in enumerate(steps) if s[0] <= n and s[1] <= n / 2), None)
            r.check(d <= n + 50 and dz <= n / 2 + 50, "rejoined within N=%.0f (dist %.0f, dZ %.0f)" % (n, d, dz))
            # the line is polled 2.5 s after each step (about 2 ticks), so it belongs to the last or the previous step
            r.check(first_in is not None and first_in >= len(steps) - 2,
                    "not before the player was within N (first step inside N: %s of %d)" % (first_in, len(steps)))
        prev, jumps, close = None, [], None
        for _ in range(30):             # 1 s probes: walking, not a jump (900 u in about 1 s = teleport, INFERRED)
            p = probe(r, F1) or {}
            if prev and p.get("xyz") and prev.get("xyz") and dist2(p["xyz"], prev["xyz"]) > 900:
                jumps.append(round(dist2(p["xyz"], prev["xyz"])))
            dp = num(p.get("dPlayer"))
            if dp is not None and dp < 600:
                close = dp
                break
            prev = p
            time.sleep(1)
        r.check(close is not None, "F1 walked to the player (dPlayer %s)" % close)
        r.check(not jumps, "no teleport (jumps %s)" % jumps)
    finally:
        tidy(r, F1)
        player_to(r, MARKET)


@test("B-25", "B")
def b25(r):
    """Continue B-23: the player leaves until F1 unloads (console moveto to WhiterunStablesMapMarker, another
    worldspace; time plan :112) -> REJOIN_DONE (spec: reason=unloaded; the code logs no reason); F1 appears behind the
    player within about 10 s (NFF warp)."""
    try:
        if not in_rejoin(r, "B-25"):
            return
        nm = name(r, F1)
        t = fresh()
        player_to(r, STABLES, wait=2)
        ev = wait_ieb(t, REJOIN_EXIT, nm, 30)
        r.check(ev is not None and ev[0] == "REJOIN_DONE", "REJOIN_DONE after F1 unloaded (%s)" % (ev,))
        if ev:
            r.log("  REJOIN_DONE fields: '%s' (spec: reason=unloaded)" % ev[1])
        t0 = time.time()

        def near():
            dp = num((probe(r, F1) or {}).get("dPlayer"))
            return dp if dp is not None and dp < 1500 else None
        d = until(near, 20, 2)
        r.check(d is not None, "F1 warped to the player within about 10 s (dPlayer %s after %.0f s)"
                % (d, time.time() - t0))
    finally:
        player_to(r, GATE)
        player_to(r, MARKET)
        tidy(r, F1)


@test("B-26", "B")
def b26(r):
    """B-23 with NFF warp disabled (console `set nwsAllowWarp to 0`: GLOB 0x01BDFF, EditorID VERIFIED in
    nff/esp/nwsFollowerFramework.esp; time plan :122). INFERRED equal to the MCM toggle, which also restarts NFF's
    sandbox loop and re-evaluates followers (nwsFollowerMCMExScript.psc:875-878, nwsFollowerMCMScript.psc:559-565).
    On unload: REJOIN_TO_WAIT; F1 waits at the spot (a plain NFF wait)."""
    w0 = (rejoin_info(r) or {}).get("warp")
    try:
        con(r, "set nwsAllowWarp to 0")
        if not need(r, (rejoin_info(r) or {}).get("warp") is False, "nwsAllowWarp did not read 0"):
            return
        if not in_rejoin(r, "B-26"):
            return
        nm = name(r, F1)
        before = probe(r, F1) or {}
        t = fresh()
        player_to(r, STABLES, wait=2)
        ev = wait_ieb(t, REJOIN_EXIT, nm, 30)
        r.check(ev is not None and ev[0] == "REJOIN_TO_WAIT", "REJOIN_TO_WAIT on unload (%s)" % (ev,))
        time.sleep(5)
        p = probe(r, F1) or {}
        r.check(num(p.get("wfp")) == 1.0 and p.get("iebHeld") == "0" and p.get("nffSeat") not in ("-1", None),
                "plain NFF wait: wfp 1, no bridge keys, still seated (wfp=%s iebHeld=%s nffSeat=%s)"
                % (p.get("wfp"), p.get("iebHeld"), p.get("nffSeat")))
        time.sleep(15)
        p2 = probe(r, F1) or {}
        r.check(p2.get("cellid") == before.get("cellid") and num(p2.get("wfp")) == 1.0,
                "F1 waits at the spot (cell %s -> %s, wfp %s)" % (before.get("cellid"), p2.get("cellid"), p2.get("wfp")))
    finally:
        con(r, "set nwsAllowWarp to %d" % (0 if w0 is False else 1))      # plugin default 1 (IEB_NFFLib.psc:82)
        r.check((rejoin_info(r) or {}).get("warp") is not False or w0 is False, "teardown: NFF warp setting restored")
        player_to(r, GATE)
        player_to(r, MARKET)
        tidy(r, F1)


@test("B-27", "B")
def b27(r):
    """F1's dialogue_response prompt (request log R2 instead of the trace viewer, time plan :61/:123), made to speak by
    the proposed Narrate wrapper. During the errand: 0600 Travel History is not "never been a member"; IntelEngine's
    "### Current Task" (0801_intel_task_awareness.prompt:32/39) is present; the errand line = the bridge's 0802 held
    line (INFERRED reading of "Travel History shows the errand line"). Rejoin phase: the 0802 "finished an errand ...
    waiting here" block (0802_ieb_errand.prompt:11). Markers only; no prompt text is printed or stored."""
    try:
        nm = base(r, F1, where=GATE)[0]
        snap(r, F1)
        t = fresh()
        if not took(r, go(r, F1, DEST_MARKET, t), nm):
            return
        time.sleep(2)
        rq = game.Tail(REQLOG)
        if not need(r, narrate(r, F1), "Narrate wrapper missing"):
            return
        body = wait_request(rq, nm, 120)
        if not need(r, body, "no request with F1's Travel History within 120 s (F1 did not speak?)"):
            return
        br = th_branch(body, nm)
        r.log("  held: Travel History branch=%s" % br)
        r.check(br != "never", "held: 'never been a member' absent (branch %s)" % br)
        r.check("### Current Task" in body, "held: IntelEngine '### Current Task' present")
        r.check(("### Where %s Is Right Now" % nm) in body and "is away on an errand for" in body,
                "held: the bridge's errand line (0802, Held == 1) present")
        if not need(r, far_from_player(r, F1, N_DEFAULT + 300, 120), "F1 never got beyond N for the rejoin phase"):
            return
        tc = fresh()
        r.ctl("Cancel", [F1])
        x = wait_ieb(tc, REL_KW, nm, 20)
        if not need(r, x is not None and x[0] == "REJOIN_WAIT", "rejoin phase not reached (%s)" % (x,)):
            return
        time.sleep(2)
        rq2 = game.Tail(REQLOG)
        narrate(r, F1)
        body2 = wait_request(rq2, nm, 120)
        if not need(r, body2, "no rejoin-phase request from F1 within 120 s (too far to speak?)"):
            return
        r.check("has finished an errand for" in body2 and "is waiting here to rejoin the group" in body2,
                "rejoin: 0802 'finished an errand ... waiting here' block present")
        r.log("  rejoin: Travel History branch=%s" % th_branch(body2, nm))
    finally:
        tidy(r, F1)
        player_to(r, MARKET)


@test("B-28", "B")
def b28(r):
    """Same trace: record whether SA's 0175 "currently traveling with" (0175_severactions_follower.prompt:20) appears
    next to the 0802 Held == 1 line, and sever_follow_state (noted only, not a failure)."""
    try:
        nm = base(r, F1, where=GATE)[0]
        t = fresh()
        if not took(r, go(r, F1, DEST_MARKET, t), nm):
            return
        time.sleep(2)
        u = r.uuid(F1)[0]
        if u:
            rt = r.tool("render_template", {"actor_uuid": u, "content": "{{ sever_follow_state(actorUUID) }}|"
                                            "{{ is_follower(actorUUID) }}|{{ is_sever_follower(actorUUID) }}"})
            r.log("  RECORD sever_follow_state|is_follower|is_sever_follower = %s" % (rt.get("renderedContent") or rt)[:120])
        rq = game.Tail(REQLOG)
        if not need(r, narrate(r, F1), "Narrate wrapper missing"):
            return
        body = wait_request(rq, nm, 120)
        if not need(r, body, "no request with F1's Travel History within 120 s"):
            return
        sa175 = "You are currently traveling with" in body
        held = "is away on an errand for" in body
        r.log("  RECORD SA 0175 'currently traveling with' present=%s; 0802 Held==1 line present=%s" % (sa175, held))
        r.check(True, "trace recorded")
    finally:
        tidy(r, F1)
        player_to(r, MARKET)


@test("B-31", "B")
def b31(r):
    """F1 seated by SA's AI action SitOrLayDown (proposed SitNearest wrapper: SkyrimNetApi.ExecuteAction, b25
    SkyrimNetApi.psc:55, on the nearest free chair/bench in the Bannered Mare), then sent on an errand: F1 stands and
    leaves within one package evaluation (IE 90/100 beats SA's 80, SeverActions_FurnitureLib.psc:98; INFERRED); errand
    completes; afterwards F1 does not walk back to that furniture (IsUsing false, or SA's auto-stand cleanup ran:
    recorded). F1's release with the player inside and F1 outside is U1 -> RELEASE_FOLLOW, so the rejoin-phase half of
    the row is not observed on this route."""
    try:
        watch_on(r)
        con(r, "coc WhiterunBanneredMare")          # cell EditorID VERIFIED (t0_setup_research.md :82)
        time.sleep(20)
        bring(r, F1)
        nm = name(r, F1)
        time.sleep(3)
        m = ctl_line(r, "SitNearest", [F1, 1500.0], r"\[IEB-TEST\] SitNearest .* furn=(\S+) .* rc=(-?\d+)", 15)
        if not need(r, m and m.group(2) == "0", "SitNearest wrapper missing, no furniture, or ExecuteAction failed (%s)"
                    % (m.group(0) if m else "no line")):
            return

        def fstate():
            mm = ctl_line(r, "FurnState", [F1], r"\[IEB-TEST\] FurnState .* sit=(\d+) using=(\w+) furn=(\S+) dFurn=(\S+)", 8)
            return dict(sit=int(mm.group(1)), using=mm.group(2).upper() == "TRUE", dfurn=num(mm.group(4))) if mm else None
        seated = until(lambda: (lambda s: s if s and s["sit"] == 3 else None)(fstate()), 40, 2)
        if not need(r, seated, "F1 never sat (GetSitState 3)"):
            return
        t = fresh()
        p0 = probe(r, F1) or {}
        t0 = time.time()
        if not took(r, go(r, F1, DEST_MARKET, t), nm):
            return
        stood = until(lambda: (lambda s: s if s and s["sit"] == 0 else None)(fstate()), 20, 1)
        r.check(stood is not None, "F1 stood up after the TAKE (%.0f s)" % (time.time() - t0))

        def left():
            p = probe(r, F1) or {}
            d = dist2(p.get("xyz"), p0.get("xyz"))
            return p if (d is not None and d > 200) or p.get("cellid") != p0.get("cellid") else None
        r.check(until(left, 30, 2) is not None, "F1 left the furniture on the errand")
        if not need(r, t.wait(arrived_rx(nm), 180), "F1 did not arrive at %s" % DEST_MARKET):
            return
        player_to(r, F1, wait=10)
        con(r, "coc WhiterunBanneredMare")
        end = wait_ieb(t, REL_KW, nm, 90)
        r.check(end is not None, "errand completed and released (%s)" % (end,))
        time.sleep(8)
        s = fstate() or {}
        cleanup = re.findall(r"\[SeverActions_FurnitureLib\] %s (stopping furniture use)" % re.escape(nm), t.read())
        r.log("  RECORD after %s: IsUsing=%s, SA stop/cleanup lines=%d" % (end and end[0], s.get("using"), len(cleanup)))
        r.check(s.get("using") is False or bool(cleanup), "IsUsing false or SA's auto-stand cleanup ran")
        sits, dmin = [], None
        for _ in range(10):
            s = fstate() or {}
            sits.append(s.get("sit"))
            if s.get("dfurn") is not None:
                dmin = s["dfurn"] if dmin is None else min(dmin, s["dfurn"])
            time.sleep(3)
        r.check(all(x == 0 for x in sits if x is not None), "F1 did not sit again (sit states %s)" % sits)
        r.check(dmin is None or dmin > 150, "F1 did not walk back to that furniture (closest %s u)" % dmin)
    finally:
        player_to(r, MARKET)
        tidy(r, F1)
