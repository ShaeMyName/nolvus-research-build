"""U2 block, part 8: on-screen notices NT (spec §17a; RV-61: each notice must match the logged bridge decision for that
actor). The per-decision audit runs after EVERY test in every block (block.notice_audit), so NT-1's "fires at its moment
with the exact text" is checked wherever N3-N7 occur (U1 refusals, rejoins, conflicts). Here: NT-1's toggle half (and a
forced N3), NT-2 (N1 once per load, probe never eligible, not in any action list). NT-3 (late box, harness mode OFF) is
an S-C item; NT-4 (scheduled fetch/delivery single box) waits for its IE patch; N8 (steward visit) needs an SA steward
and is counted in the soak."""
import re, time
import game
from block import test, checkpoint
from runner import eligible
from tests_misc import PLAYER, F1, con, inc, who, render, qr, iv
from tests_tm_l import H, DEST_NEAR, sa_call, hexarg, probe, start_errand

NOTICE_RX = r"\[IEB\] NOTICE (N\d) (shown|suppressed) text=([^\n]*)"


def pap():
    return game.Tail(game.LOGS["papyrus"])


def sa_wait_setup(r):
    """L-7's route to a guaranteed bridge REFUSE (reason=sa_wait): H in SeverActions' wait sandbox (tests_tm_l.l7)."""
    sa_call(r, "SeverActions_FollowerManager", "CompanionWait", [hexarg(H)])
    for _ in range(6):
        time.sleep(3)
        p = probe(r, H)
        if p and p.get("wfp") == 1.0 and p.get("saSandbox"):
            return True
    return False


def sa_wait_teardown(r):
    sa_call(r, "SeverActions_Follow", "StopSandbox", [hexarg(H)])
    sa_call(r, "SeverActions_FollowerManager", "RefillSchedAliasesAfterStop", [hexarg(H)])


def force_refuse(r):
    """One errand for H while in SA's wait sandbox -> [IEB] REFUSE reason=sa_wait. Returns the REFUSE line or None."""
    t = pap()
    start_errand(r, H, DEST_NEAR)
    return t.wait(r"\[IEB\] REFUSE actor=[^\n]*", 30)


@test("NT-1", "NT", reload=True)
def nt1(r):
    """Toggle: with IEB_Spare01 = 1 a forced refusal logs 'NOTICE N3 suppressed' (no notification); with 0 it logs
    'shown' with the exact text '<Name> can't go right now.'. 0 LLM calls."""
    if not sa_wait_setup(r):
        sa_wait_teardown(r)
        return inc(r, "H not in SA's wait sandbox (L-7 setup)")
    checkpoint(r)
    out = {}
    try:
        for val in (1, 0):
            con(r, "set IEB_Spare01 to %d" % val)
            time.sleep(1)
            t = pap()
            m = force_refuse(r)
            if not m:
                return inc(r, "no REFUSE could be forced (spare=%d)" % val)
            n = t.wait(NOTICE_RX, 10)
            out[val] = n
            name = re.search(r"actor=(.+?)(?: reason=|$)", m.group(0)).group(1).strip()
            r.check(bool(n) and n.group(1) == "N3" and n.group(2) == ("suppressed" if val else "shown"),
                    "spare=%d: N3 %s" % (val, "suppressed" if val else "shown"))
            if n:
                r.check(n.group(3).strip().lower() == ("%s can't go right now." % name).lower(), "spare=%d: exact N3 text" % val)
            time.sleep(5)
    finally:
        con(r, "set IEB_Spare01 to 0")
        sa_wait_teardown(r)


@test("NT-2", "NT", reload=True)
def nt2(r):
    """N1 'AI actions ready.' fires once per load, at the moment check_action_eligibility first turns true (3 loads):
    the AI_READY line comes before, or within 10 s of, the first true eligibility poll; the probe action IEB_ReadyProbe
    is ineligible for every polled actor; and no NPC's rendered action list mentions it (boolean only)."""
    checkpoint(r, "3 loads")
    fu, _, _ = who(r, F1)
    for n in range(3):
        t = pap()
        if not game.load(r, "T0", None):
            return inc(r, "load %d failed" % (n + 1))
        t0 = time.time()
        first_true = None
        while time.time() - t0 < 600:
            e, _ = eligible(r.tool("check_action_eligibility", {"action_name": "SitOrLayDown", "actor_uuid": fu}))
            if e is True:
                first_true = time.time()
                break
            time.sleep(5)
        txt = t.read()
        shown = re.findall(r"\[IEB\] NOTICE N1 shown", txt)
        r.check(len(shown) == 1, "load %d: N1 shown exactly once (%d)" % (n + 1, len(shown)))
        if first_true is None:
            inc(r, "load %d: eligibility never turned true in 600 s" % (n + 1))
        pe, _ = eligible(r.tool("check_action_eligibility", {"action_name": "IEB_ReadyProbe", "actor_uuid": fu}))
        r.check(pe is not True, "load %d: IEB_ReadyProbe not eligible for F1" % (n + 1))
    out = render(r, fu, "{{ render_template(\"components\\\\actions_list\") }}{# %d #}" % time.time_ns())
    if out is None:
        inc(r, "action-list render failed (template name INFERRED)")
    else:
        r.check("IEB_ReadyProbe" not in out, "the probe is in no rendered action list")


@test("NT-4", "NT", reload=True)
def nt4(r):
    """A follower's scheduled fetch and scheduled delivery each show IntelEngine's confirmation box exactly once (IE patch
    nt4): confirm modes set to 1 (followers) for the scheduling and the run-time actions; schedule 'in 1 hour' (time
    condition format INFERRED); the scheduling box is answered with button 0 (INFERRED = Allow) through the harness;
    then game time jumps 1.2 h (SetHour) and the task fires with NO second box (ui-state) and the IEB_SCHED_CONFIRMED log
    line. Confirm modes back to 0 in finally (ie_test_settings' values)."""
    import sn_harness as SH
    from block import IE_ACTIONS

    def setting(key, val):
        r.tool("execute_quest_function", {"quest_editor_id": "IntelEngine", "script_name": "IntelEngine_Core",
                                          "function_name": "OnDashboardSetting",
                                          "arguments": ["IntelEngine_DashboardSetting", key, float(val), None]})

    def box_open():
        try:
            st = SH.ui_state()
        except SH.HarnessError:
            return None
        return "MessageBoxMenu" in str(st)

    checkpoint(r, "game time +2.4 h")
    try:
        for kind, sched_key, run_key, call in (
                ("fetch", "confirmScheduleFetch", "confirmFetchPerson", ["ScheduleFetch", [F1, "Carlotta Valentia", "in 1 hour"]]),
                ("deliver", "confirmScheduleDelivery", "confirmDeliverMessage",
                 ["ScheduleDelivery", [F1, "Carlotta Valentia", "The road is clear.", "in 1 hour"]])):
            setting(sched_key, 1)
            setting(run_key, 1)
            time.sleep(5)
            t = pap()
            r.ctl(call[0], call[1], sync=False)
            first = None
            for _ in range(20):
                time.sleep(1)
                if box_open():
                    first = True
                    break
            if not first:
                inc(r, "%s: no scheduling box appeared (confirm mode or route INFERRED)" % kind)
                continue
            SH.dismiss_ui(button=0)
            time.sleep(3)
            m = t.wait(r"\[IEB-TEST\] %s [^\n]*ok=(\w+)" % call[0], 15)
            if not m or m.group(1).upper() != "TRUE":
                inc(r, "%s: scheduling not accepted (%s)" % (kind, m.group(0) if m else "no line"))
                continue
            h = re.search(r"hour=(-?[\d.]+)", (ctl_hour(r) or ""))
            hour = float(h.group(1)) if h else 12.0
            t2 = pap()
            r.ctl("SetHour", [min(hour + 1.2, 23.5), 0x0001A66C], sync=False)
            # RV-123 (3): SetHour logs CRASHCTX hour= after the write (IEB_TestCtl.SetHour -> CrashCtx): read it back
            hb = t2.wait(r"CRASHCTX hour=(-?[\d.]+)", 20)
            if not hb or abs(float(hb.group(1)) - min(hour + 1.2, 23.5)) > 0.25:
                inc(r, "%s: SetHour read-back %s, wanted %.2f" % (kind, hb.group(1) if hb else "no CRASHCTX line",
                                                                   min(hour + 1.2, 23.5)))
                continue
            fired = t2.wait(r"IEB_SCHED_CONFIRMED skip second box: %s" % kind, 120)
            second = any(box_open() for _ in range(10) if not time.sleep(1))
            r.check(bool(fired), "%s: the scheduled task fired without a second box (IEB_SCHED_CONFIRMED)" % kind)
            r.check(not second, "%s: no second confirmation box at run time" % kind)
            if kind != "fetch" or not fired:
                continue
            # RV-93-close (b): the mark is not saved into a mid-task save (read after save + load)
            if game.save(r, "IEB_NT4"):
                if game.load(r, "IEB_NT4", None):
                    m2 = ctl_line_su(r, F1, "IEB_SchedConfirmed")
                    r.check(m2 in (None, 0, -99), "IEB_SchedConfirmed unset after a mid-task save/load (%s)" % m2)
                else:
                    inc(r, "load of IEB_NT4 failed")
            else:
                inc(r, "save IEB_NT4 failed")
            r.ctl("Cancel", [F1])
            time.sleep(5)
            q = qr(r, F1)                       # RV-123 (3): the cancel freed F1's IE slot before the leak check
            if not q or iv(q, "slot") >= 0:
                inc(r, "Cancel read-back: F1 IE slot %s (want none)" % (q.get("slot") if q else "no QR line"))
                continue
            # RV-93-close (a): a NON-scheduled fetch for the same actor right after still shows its box (no leaked mark)
            r.ctl("StartTask", [F1, "FetchPerson", "Carlotta Valentia", "1", ""], sync=False)
            leak_box = False
            for _ in range(20):
                time.sleep(1)
                if box_open():
                    leak_box = True
                    break
            r.check(leak_box, "a non-scheduled fetch right after still shows its confirmation box")
            if leak_box:
                SH.dismiss_ui(button=1)          # INFERRED = Deny: the test fetch is not wanted
                time.sleep(2)
    finally:
        for a in IE_ACTIONS:
            setting("confirm" + a, 0)


def ctl_hour(r):
    t = pap()
    r.ctl("CrashCtx", [0x0001A66C], sync=False)
    m = t.wait(r"CRASHCTX [^\n]*", 20)
    return m.group(0) if m else None


def ctl_line_su(r, fid, key):
    from tests_misc import ctl_line, s32
    from fidnorm import fid_any_rx
    m = ctl_line(r, "SUGetInt", [s32(fid), key, -99], r"\[IEB-TEST\] SU (?:%s|none) %s get=(\S+)" % (fid_any_rx(fid), re.escape(key)), 10)
    try:
        return int(m.group(1)) if m else None
    except ValueError:
        return None
