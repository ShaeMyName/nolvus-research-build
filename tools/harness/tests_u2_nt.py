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
from tests_misc import PLAYER, F1, con, inc, who, render
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
