"""REVIEW_LOG RV-69-dec / RV-77 / RV-132: live test of the Relationships head start for the priestess at Azura's shrine
(ref 0x00028AD1) on T0 (throwaway; harness ON, one launch, one T0 reload). Graded on the numbers TestCtl.HeadStartOp
logs (points, bank, latch, LUC_Active); snrom.log IEB_HEADSTART lines are read after the game closes (the log can lag
by minutes) and graded only for the adult control (lines name the actor), else supporting evidence.
Every state write is read back before a verdict depends on it (RV-123 (3)); a failed read-back makes the case
INCONCLUSIVE, never PASS. Console writes go through tests_misc.con (hex-ref prefix -> target_form_id). Relationships
calls go through tests_misc.rel (SNRom_Quest / SNRom_Bridge, the path SkyrimNet's actions use: RomanceBeginSpark.yaml
questEditorId SNRom_Quest, scriptName SNRom_Bridge, executionFunctionName BeginSpark). Adults only: the priestess and
Uthgerd (0x00091918); no child is touched. IsChild is not live-testable (the FormID check rejects first).

Part 1, fresh T0 (routes whose state HeadStartOp reset cannot undo; BeginSpark first, before any in-session
enrolment can author her orientation, which RomanceOk/CanBegin read):
  route_beginspark      CurrentFollowerFaction added (IsFollowing, RELB:749-750; read back by Probe cff), then
                        rel BeginSpark: +25 with the x2 bonus (50), then the floor -> 999, never 1049 (RV-77-close).
  route_autoenroll      rel AutoEnroll starts the follower waiting period (RELB:869-884), the game clock is run past
                        enrollmentDelayHours 2.0 under Accelerate (read back by CrashCtx days), then the Bridge's own
                        CheckPendingEnrollments -> AutoEnroll -> EnrollNow -> floor 999. MARAS-unregistered first, so
                        the sweep's M4' catch-up cannot be the route.
  route_courtship_maras MarasSet 0 = MARAS.RegisterCandidate -> maras_status_changed "candidate"
                        (NPCRelationshipManager.cpp:119,145) -> OnMarasStatusChanged -> IEB_EnrollOnCourtship
                        (RELB:4846) -> floor 999. MARAS state persists in its co-save, so T0 is reloaded after.
Part 2, after the reload (HeadStartOp reset between cases): A by hand + B x2/x1, 1970+20 truncation, 1990+20 cap
(extra 0, the base banked), latch on re-enrol (by hand and by the courtship function), M4' function called directly,
LUC_Active 0 (no floor, no bonus; restored with a read-back), adult control Uthgerd (numbers + no IEB_HEADSTART line).
Usage: hs_live.py (game and MO2 closed). Prints numbers only."""
import os, re, sys, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import game
from runner import Run
from fidnorm import fid_any_rx
from tests_misc import con, rel, ah

OUT = "C:/nolvus-research/test_runs/"
SNROM = ("C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/SkyrimNet Test - Output/SKSE/Plugins/"
         "SkyrimNet Relationships/logs/snrom.log")
P, U, PLAYER = 0x00028AD1, 0x00091918, 0x00000014   # the priestess; Uthgerd (adult control); the player
CFF = 0x0005C84E                                    # CurrentFollowerFaction (Skyrim.esm), RELB:749
U_NAME = "Uthgerd"                                  # snrom Diag lines carry the display name (prv_check.py:46)
LOG, VERDICT, CONTROL_RAN = [], [], []
PART1 = ["route_beginspark_floor_after_plus25", "route_autoenroll_floor", "route_courtship_maras_event_floor"]
PART2 = ["A_byhand_floor", "B_positive_x2", "B_negative_x1", "B_truncation_1970_plus_20", "B_cap_1990_plus_20_banked",
         "latch_reenrol_no_second_floor", "A_courtship_direct_floor", "luc_off_no_floor_no_bonus",
         "control_uthgerd_numbers", "control_uthgerd_no_headstart_lines"]


def say(m):
    line = "%s %s" % (time.strftime("%H:%M:%S"), m)
    print(line, flush=True)
    LOG.append(line)


def verdict(name, ok, detail=""):
    VERDICT.append("%s %s %s" % (name, "PASS" if ok else ("INCONCLUSIVE" if ok is None else "FAIL"), detail))
    say("VERDICT " + VERDICT[-1])


def op(ctl, fid, name, n=0):
    """One HeadStartOp. 'probe' matches no op branch (IEB_TestCtl.psc:871-893), so it only logs the numbers."""
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl("HeadStartOp", [fid, name, n], sync=False)
    m = t.wait(r"(?i)\[IEB-TEST\] HSOP [^\r\n]*", 60)
    line = m.group(0) if m else ""
    say("%s %s %d: %s" % (hex(fid), name, n, line[line.find("HSOP"):] if line else "no HSOP line"))
    d = dict(re.findall(r"(\w+)=(-?\d+)", line))
    return {k: int(v) for k, v in d.items()} if line else None


SETUP_WANT = {"luc": lambda r, n: r["luc"] == n, "setpts": lambda r, n: r["pts"] == n,
              "unenroll": lambda r, n: r["enrolled"] == 0,
              "reset": lambda r, n: r["enrolled"] == 0 and r["bank"] == 0 and r["latch"] == 0}
#   reset's pts is not asserted: PointsOf reads Romantasy's number until the import (SNRom_Bridge.psc:1314-1326)


def setup(ctl, fid, name, n=0):
    """RV-123 (3): a setup op, read back from its own HSOP line before a verdict depends on it. None = read-back failed."""
    r = op(ctl, fid, name, n)
    if not (r and SETUP_WANT[name](r, n)):
        verdict("setup_%s_%s_%d" % (hex(fid), name, n), None, "read-back %s" % r)
        return None
    return r


def line(ctl, fn, args, pat, timeout=20):
    """A TestCtl probe whose own log line is the answer (unsynchronised call, then wait for pat)."""
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl(fn, args, sync=False)
    return t.wait(pat, timeout)


def follow_flags(ctl, fid):
    """TestCtl.Probe (IEB_Watcher.Line): (tm, cff) = IsPlayerTeammate, CurrentFollowerFaction rank (< 0 = not in it)."""
    m = line(ctl, "Probe", [fid], r"(?i)\[IEB-TEST\] probe [^\r\n]*?%s[^\r\n]*" % fid_any_rx(fid), 15)
    if not m:
        say("%s probe: no line" % hex(fid))
        return None
    tm, cff = re.search(r"\btm=(-?\d+)", m.group(0)), re.search(r"\bcff=(-?\d+)", m.group(0))
    out = (int(tm.group(1)) if tm else None, int(cff.group(1)) if cff else None)
    say("%s follow flags tm=%s cff=%s" % (hex(fid), out[0], out[1]))
    return out


def maras_st(ctl, fid):
    """TestCtl.GateProbe: MARAS status enum (-1 unregistered, 0 candidate)."""
    m = line(ctl, "GateProbe", [fid], r"(?i)\[IEB-TEST\] GATE %s st=(-?\d+)" % fid_any_rx(fid), 15)
    say("%s MARAS st=%s" % (hex(fid), m.group(1) if m else "no GATE line"))
    return int(m.group(1)) if m else None


def su_get(ctl, fid, key, dflt):
    m = line(ctl, "SUGetInt", [fid, key, dflt], r"(?i)\[IEB-TEST\] SU %s %s get=(-?\d+)" % (fid_any_rx(fid), key), 15)
    say("%s %s=%s" % (hex(fid), key, m.group(1) if m else "no SU line"))
    return int(m.group(1)) if m else None


def game_days(ctl):
    """TestCtl.CrashCtx: GameDaysPassed (the clock Utility.GetCurrentGameTime reads; INFERRED same value)."""
    m = line(ctl, "CrashCtx", [P], r"(?i)\[IEB-TEST\] CRASHCTX hour=\S+ days=(-?[\d.]+)", 15)
    return float(m.group(1)) if m else None


def accelerate(ctl, ts):
    """Accelerate, after AssertTimescale shows the clock at its recorded play value (RecordTimescale if none is
    recorded yet; never if the clock is already off it). True only on the 'accelerated' line."""
    m = line(ctl, "AssertTimescale", [], r"ASSERT (PASS|FAIL) TIMESCALE[^\r\n]*", 15)
    say("timescale before: %s" % (m.group(0) if m else "no line"))
    if not m:
        return False
    if m.group(1) == "FAIL":
        if "recorded -1" not in m.group(0):
            return False
        if not line(ctl, "RecordTimescale", [], r"TIMESCALE recorded \S+", 15):
            return False
    m = line(ctl, "Accelerate", [float(ts)], r"TIMESCALE accelerated to \S+|ASSERT FAIL TIMESCALE[^\r\n]*", 15)
    say("accelerate: %s" % (m.group(0) if m else "no line"))
    return bool(m) and "accelerated" in m.group(0)


def restore_ts(ctl):
    m = line(ctl, "RestoreTimescale", [], r"ASSERT (PASS|FAIL) TIMESCALE[^\r\n]*", 20)
    say("timescale restore: %s" % (m.group(0) if m else "no line"))
    return bool(m) and m.group(1) == "PASS"


def wait_enrolled(ctl, fid, timeout):
    """Poll until enrolled; then one more read 3 s later, so the graded numbers come after the enrolling call's floor."""
    end = time.time() + timeout
    r = op(ctl, fid, "probe")
    while not (r and r["enrolled"] == 1) and time.time() < end:
        time.sleep(4)
        r = op(ctl, fid, "probe")
    if r and r["enrolled"] == 1:
        time.sleep(3)
        r = op(ctl, fid, "probe")
    return r


def fresh_priestess(ctl):
    """Every case starts here: LUC_Active 1 and the priestess unenrolled with no points, bank or latch (read back)."""
    a, b = setup(ctl, P, "luc", 1), setup(ctl, P, "reset")
    return bool(a and b and b["luc"] == 1)


def cff_on(ctl):
    """Make IsFollowing true for her without a follower framework: CurrentFollowerFaction rank 0 (console addfac on
    her via target_form_id), read back on her; the player's own rank is read before and after (RV-123 pollution)."""
    pl0 = follow_flags(ctl, PLAYER)
    con(ctl, "%08X.addfac %08X 0" % (P, CFF))
    time.sleep(2)
    f, pl1 = follow_flags(ctl, P), follow_flags(ctl, PLAYER)
    if not (f and f[1] is not None and f[1] >= 0):
        return False, "cff read-back %s" % (f,)
    if not (pl0 and pl1 and pl0[1] == pl1[1]):
        return False, "player cff changed %s -> %s" % (pl0, pl1)
    return True, "cff=%d" % f[1]


# ============================================================================ part 1 (fresh T0)

def case_beginspark(ctl):
    name = "route_beginspark_floor_after_plus25"
    if not fresh_priestess(ctl):
        return verdict(name, None, "setup read-back failed")
    ok, why = cff_on(ctl)
    if not ok:
        return verdict(name, None, "setup: " + why)
    known, orient = su_get(ctl, P, "SNRom_OrientationKnown", 0), su_get(ctl, P, "SNRom_Orientation", 3)
    rel(ctl, "BeginSpark", [ah(P), "harness head-start test"])
    r = wait_enrolled(ctl, P, 30)
    if not (r and r["enrolled"] == 1):
        return verdict(name, None, "BeginSpark declined (CanBegin: IsFollowing %s, RomanceOk inputs orientKnown=%s "
                       "orient=%s); probe needed: a CanBegin/RomanceOk read (none installed)" % (why, known, orient))
    if r["pts"] == 1049:
        return verdict(name, False, "floor ran before the +25: %s" % r)
    verdict(name, r["pts"] == 999 and r["latch"] == 1 and r["bank"] == 0, str(r))


def case_autoenroll(ctl):
    """Body below; CurrentFollowerFaction always comes off again (read back), so the courtship case that follows cannot
    be enrolled by a pending AutoEnroll instead of the MARAS event."""
    try:
        autoenroll_body(ctl)
    finally:
        con(ctl, "%08X.removefac %08X" % (P, CFF))
        time.sleep(2)
        f = follow_flags(ctl, P)
        if not (f and f[1] is not None and f[1] < 0):
            verdict("setup_cff_removed", None, "read-back %s" % (f,))


def autoenroll_body(ctl):
    name = "route_autoenroll_floor"
    if not fresh_priestess(ctl):
        return verdict(name, None, "setup read-back failed")
    f = follow_flags(ctl, P)
    if not (f and f[1] is not None and f[1] >= 0):
        ok, why = cff_on(ctl)
        if not ok:
            return verdict(name, None, "setup: " + why)
    st = maras_st(ctl, P)
    if st != -1:
        return verdict(name, None, "MARAS st=%s: the sweep's M4' catch-up could enrol her instead" % st)
    d0 = game_days(ctl)
    rel(ctl, "AutoEnroll", [ah(P)])          # first sight: stamps SNRom_FirstSeenFollowing, joins the pending list
    time.sleep(3)
    r = op(ctl, P, "probe")
    if not r:
        return verdict(name, None, "no HSOP read after the first AutoEnroll")
    path = "first AutoEnroll (stamp already old)" if r["enrolled"] == 1 else None
    if not path:
        if d0 is None or not accelerate(ctl, 1000.0):
            restore_ts(ctl)
            return verdict(name, None, "game clock not readable or Accelerate not confirmed")
        try:
            d1, end = d0, time.time() + 90
            while time.time() < end and (d1 is None or d1 - d0 < 2.25 / 24):
                time.sleep(3)
                d1 = game_days(ctl)
        finally:
            restored = restore_ts(ctl)
        say("game clock advanced %.3f h" % ((d1 - d0) * 24 if d1 is not None else -1))
        if not restored:
            verdict("timescale_restored", False, "RestoreTimescale did not assert PASS")
        if d1 is None or d1 - d0 < 2.0 / 24:
            return verdict(name, None, "the waiting period did not elapse on the game clock (%s -> %s)" % (d0, d1))
        r = op(ctl, P, "probe")
        path = "Bridge tick (CheckPendingEnrollments)" if r and r["enrolled"] == 1 else None
        if not path:
            rel(ctl, "CheckPendingEnrollments", [])
            r = wait_enrolled(ctl, P, 20)
            path = "CheckPendingEnrollments" if r and r["enrolled"] == 1 else None
        if not path:
            rel(ctl, "AutoEnroll", [ah(P)])
            r = wait_enrolled(ctl, P, 20)
            path = "second AutoEnroll" if r and r["enrolled"] == 1 else None
    else:
        r = wait_enrolled(ctl, P, 5)
    if not (r and r["enrolled"] == 1):
        return verdict(name, None, "not enrolled after the waiting period: %s" % r)
    verdict(name, r["pts"] == 999 and r["latch"] == 1 and r["bank"] == 0, "via %s: %s" % (path, r))


def case_courtship_event(ctl):
    name = "route_courtship_maras_event_floor"
    if not fresh_priestess(ctl):
        return verdict(name, None, "setup read-back failed")
    f = follow_flags(ctl, P)
    if not (f and f[0] == 0 and f[1] is not None and f[1] < 0):
        return verdict(name, None, "she still reads as following (tm, cff = %s): AutoEnroll could be the route" % (f,))
    st = maras_st(ctl, P)
    if st != -1:
        return verdict(name, None, "already MARAS-registered (st=%s): RegisterCandidate refuses; engaged/married would "
                       "start MARAS's wedding flow" % st)
    m = line(ctl, "MarasSet", [P, 0], r"(?i)\[IEB-TEST\] T0M_SET %s want=0 ok=(\d) st=(-?\d+)" % fid_any_rx(P), 20)
    say("MarasSet 0: %s" % (m.group(0)[m.group(0).find("T0M_SET"):] if m else "no T0M_SET line"))
    if not (m and m.group(1) == "1" and m.group(2) == "0" and maras_st(ctl, P) == 0):
        return verdict(name, None, "candidate registration not read back")
    r = wait_enrolled(ctl, P, 30)
    if not (r and r["enrolled"] == 1):
        return verdict(name, False, "candidate event did not enrol her within 30 s: %s" % r)
    verdict(name, r["pts"] == 999 and r["latch"] == 1 and r["bank"] == 0, str(r))


# ============================================================================ part 2 (after the T0 reload)

def case_byhand_bonus(ctl):
    if not fresh_priestess(ctl):
        for n in ("A_byhand_floor", "B_positive_x2", "B_negative_x1"):
            verdict(n, None, "setup read-back failed")
        return
    r = op(ctl, P, "byhand")
    verdict("A_byhand_floor", r and r["enrolled"] == 1 and r["pts"] == 999 and r["latch"] == 1, str(r))
    r0 = r["pts"] if r else 0
    r = op(ctl, P, "moment", 20)
    verdict("B_positive_x2", r and r["pts"] - r0 == 40, "delta %s" % (r and r["pts"] - r0))
    r0 = r["pts"] if r else 0
    r = op(ctl, P, "moment", -20)
    verdict("B_negative_x1", r and r["pts"] - r0 == -20, "delta %s" % (r and r["pts"] - r0))


def case_near_cap(ctl, name, start, want_pts, want_bank):
    """Enrolled by hand (floor), points set to `start`, then a +20 moment: the extra stops at
    UNANSWERED_MAX - points - award. 1970: extra 9 -> 1999, bank 0. 1990: extra 0, the 20 crosses 1999, so
    HoldShortOfLover banks exactly the base 20 (RELB:1983); bank 20 + extra would show if the extra were > 0."""
    if not fresh_priestess(ctl):
        return verdict(name, None, "setup read-back failed")
    r = op(ctl, P, "byhand")
    if not (r and r["enrolled"] == 1 and r["latch"] == 1) or not setup(ctl, P, "setpts", start):
        return verdict(name, None, "setup read-back failed: %s" % r)
    r = op(ctl, P, "moment", 20)
    verdict(name, r and r["pts"] == want_pts and r["bank"] == want_bank and r["latch"] == 1, str(r))


def case_latch(ctl):
    name = "latch_reenrol_no_second_floor"
    if not fresh_priestess(ctl):
        return verdict(name, None, "setup read-back failed")
    r = op(ctl, P, "byhand")
    if not (r and r["pts"] == 999 and r["latch"] == 1):
        return verdict(name, None, "first enrolment gave no floor: %s" % r)
    # 500, not 100: above the first-meeting seed caps (NO_RECORD 200, TODAY_OR_YESTERDAY 499), so a seed top-up landing
    # mid-case cannot move it, while a second floor would still lift it to 999
    u = setup(ctl, P, "unenroll")
    if not (u and u["latch"] == 1) or not setup(ctl, P, "setpts", 500):
        return verdict(name, None, "unenrol/setpts read-back failed (latch kept? %s)" % u)
    r1 = op(ctl, P, "byhand")
    u = setup(ctl, P, "unenroll")
    if not (u and u["latch"] == 1 and u["pts"] == 500):
        return verdict(name, None, "second unenrol read-back failed: %s" % u)
    r2 = op(ctl, P, "courtship")
    ok = all(x and x["enrolled"] == 1 and x["pts"] == 500 and x["latch"] == 1 for x in (r1, r2))
    verdict(name, ok, "by hand %s; courtship %s" % (r1 and r1["pts"], r2 and r2["pts"]))


def case_courtship_direct(ctl):
    name = "A_courtship_direct_floor"
    if not fresh_priestess(ctl):
        return verdict(name, None, "setup read-back failed")
    r = op(ctl, P, "courtship")
    verdict(name, r and r["enrolled"] == 1 and r["pts"] == 999 and r["latch"] == 1, str(r))


def case_luc_off(ctl):
    name = "luc_off_no_floor_no_bonus"
    try:
        if not (setup(ctl, P, "luc", 0) and setup(ctl, P, "reset")):
            return verdict(name, None, "setup read-back failed")
        r = op(ctl, P, "byhand")
        ok = r and r["enrolled"] == 1 and r["pts"] < 999 and r["latch"] == 0 and r["luc"] == 0
        r0 = r["pts"] if r else 0
        r = op(ctl, P, "moment", 20)
        verdict(name, ok and r and r["pts"] - r0 == 20 and r["bank"] == 0 and r["latch"] == 0,
                "after enrol pts %s; moment delta %s" % (r0, r and r["pts"] - r0))
    finally:
        r = op(ctl, P, "luc", 1)
        if not (r and r["luc"] == 1):
            verdict("luc_restored", False, "LUC_Active read-back %s" % r)


def case_control(ctl):
    name = "control_uthgerd_numbers"
    if not (setup(ctl, U, "luc", 1) and setup(ctl, U, "reset")):
        return verdict(name, None, "setup read-back failed")
    r = op(ctl, U, "byhand")
    ok = r and r["enrolled"] == 1 and r["pts"] < 999 and r["latch"] == 0
    r0 = r["pts"] if r else 0
    r = op(ctl, U, "moment", 20)
    CONTROL_RAN.append(bool(r))
    verdict(name, ok and r and r["pts"] - r0 == 20 and r["latch"] == 0 and r["bank"] == 0,
            "after enrol pts %s; moment delta %s" % (r0, r and r["pts"] - r0))


def run_case(fn, ctl, *a):
    try:
        fn(ctl, *a)
    except Exception as e:
        say("ERROR %s: %s" % (fn.__name__, e))
        verdict(fn.__name__, None, "harness error %s" % e)


def main():
    if game.procs():
        sys.exit("ABORT: game or MO2 running")
    run_id = "HS_live_%s" % time.strftime("%Y%m%d-%H%M%S")
    game.set_archive(run_id)
    snrom0 = os.path.getsize(SNROM) if os.path.exists(SNROM) else 0
    started = reloaded = False
    try:
        if not game.harness_mode() and not game.set_harness_mode(True, say):
            raise RuntimeError("harness mode could not be set on (Harness.yaml read-back)")
        if not game.launch(say, voices=False):
            raise RuntimeError("launch refused or failed")
        ctl = Run("HS_CONTROL")
        if not game.load(ctl, "T0", None):
            raise RuntimeError("T0 load failed")
        started = True
        r = op(ctl, P, "probe")
        say("T0 as loaded: LUC_Active=%s" % (r and r["luc"]))
        run_case(case_beginspark, ctl)
        run_case(case_autoenroll, ctl)
        run_case(case_courtship_event, ctl)
        if not game.load(ctl, "T0", None):
            raise RuntimeError("T0 reload failed")
        reloaded = True
        run_case(case_byhand_bonus, ctl)
        run_case(case_near_cap, ctl, "B_truncation_1970_plus_20", 1970, 1999, 0)
        run_case(case_near_cap, ctl, "B_cap_1990_plus_20_banked", 1990, 1990, 20)
        run_case(case_latch, ctl)
        run_case(case_courtship_direct, ctl)
        run_case(case_luc_off, ctl)
        run_case(case_control, ctl)
        game.archive_logs("end")
    except Exception as e:
        say("ERROR %s" % e)
        verdict("run", False, str(e))
        if not reloaded:
            for n in ([] if started else PART1) + PART2:
                verdict(n, None, "not run: %s" % e)
    finally:
        game.close(None, timeout=60, force=True)
    try:
        with open(SNROM, encoding="utf-8", errors="replace") as f:
            f.seek(snrom0)
            hs = [l.strip() for l in f if "IEB_HEADSTART" in l]
        say("snrom.log IEB_HEADSTART lines: %d" % len(hs))
        for l in hs:
            say("  " + re.sub(r"IEB_HEADSTART (\w+) .*? (delta|award)=", r"IEB_HEADSTART \1 \2=", l))
        if reloaded:
            # Graded only if the control's enrol + moment ran, and the same log slice holds the priestess's own
            # head-start lines (the logger recorded them), so a silent log cannot read as a PASS.
            n = sum(1 for l in hs if re.search(r"IEB_HEADSTART \w+ %s" % U_NAME, l))
            pos = len(hs) - n
            if not (CONTROL_RAN and all(CONTROL_RAN)) or pos == 0:
                verdict("control_uthgerd_no_headstart_lines", None, "vacuous: control ran %s, other lines %d"
                        % (CONTROL_RAN, pos))
            else:
                verdict("control_uthgerd_no_headstart_lines", n == 0, "%d line(s) name the control; %d other" % (n, pos))
    except OSError as e:
        say("snrom.log not read: %s" % e)
        if reloaded:
            verdict("control_uthgerd_no_headstart_lines", None, "snrom.log not read")
    lf = game.log_findings()
    say("log findings: %s" % lf)
    say("SUMMARY " + " | ".join(VERDICT))
    open(OUT + run_id + ".txt", "w", encoding="utf-8").write("\n".join(LOG) + "\n")
    say("HS DONE")


if __name__ == "__main__":
    main()
