"""IntelEngine patch tests (RV-68, 2026-10-10; not in any block yet: add "IE-R1" to a block order and "tests_ie" to its
module list once the harness pex carrying HoldIEAlias / ReleaseIEAlias is installed).

IE-R1: a slot refusal AFTER DismissFollowerForTask ran, in drop mode (IEB_DropTeammate = 1), must undo the dismiss:
teammate flag restored, Intel_WasFollower unset (the bridge's Classify reads it). Code under test (patched build):
  IE_Travel:242-251 / IE_Tasks:453-458 (and the 3 other NPCTasks sites): DismissFollowerForTask, then TryAllocateSlot, on
  refusal Core.UndoDismissOnRefusal (IE_Core ~1172). Log strings: IE_Core TryAllocateSlot 'SLOT_REFUSED slot=N reason=held
  ... requester=<name>', UndoDismissOnRefusal 'SLOT_REFUSED_UNDO: restored teammate flag for <name>'.
Forcing the refusal: TestCtl.HoldIEAlias(G) puts G in the first free IE agent alias (the slot Reserve picks next).
Labels: VERIFIED = read in source; INFERRED = not run.
"""
import re
import time
from block import test, checkpoint
import tests_tm_l as T


def refusal_report(pap, name):
    """Parse the Papyrus log text for one actor's refusal. Pure function (selftest covers it). Returns dict:
    dismissed (drop-mode 'Dismissed follower: <name>'), kept ('Kept follower as teammate' = keep mode, test invalid),
    refused (SLOT_REFUSED ... requester=<name>), restored (SLOT_REFUSED_UNDO ... <name>), door (DOOR_LEFT_UNLOCKED <name>)."""
    n = re.escape(name)
    return {
        "dismissed": bool(re.search(r"IntelEngine: Dismissed follower: %s\b" % n, pap)),
        "kept": bool(re.search(r"IntelEngine: Kept follower as teammate for task: %s\b" % n, pap)),
        "refused": bool(re.search(r"SLOT_REFUSED slot=\d+ reason=held [^\n]*requester=%s requesterId=" % n, pap)),
        "restored": bool(re.search(r"SLOT_REFUSED_UNDO: restored teammate flag for %s\b" % n, pap)),
        "door": bool(re.search(r"DOOR_LEFT_UNLOCKED %s\b" % n, pap)),
    }


@test("IE-R1", "IE", reload=True)
def ie_r1(r):
    """Drop-mode refusal: F1 (follower, teammate) is told to travel while the next free IE slot's alias holds G.
    Pass: SLOT_REFUSED for F1; 'Dismissed follower' (drop mode really ran); SLOT_REFUSED_UNDO; F1 a teammate again;
    Intel_WasFollower on F1 = 0; no TAKE/LEND for F1 (the bridge saw no task)."""
    F, H_ = T.F1, T.G
    nmF = T.nm(F)
    m = T.ctl_wait(r, "SetDropTeammate", [1], r"\[IEB-TEST\] DropTeammate was=(\d+) now=(\d+)", 10)
    slot = None
    try:
        if not m or m.group(2) != "1":
            return T.inconclusive(r, "SetDropTeammate wrapper missing or did not set 1")
        f = T.probe(r, F)
        if not f or f.get("tm") != 1:
            return T.inconclusive(r, "F1 is not a teammate (tm=%s)" % (f and f.get("tm")))
        T.snapshot(r, F)
        h = T.ctl_wait(r, "HoldIEAlias", [H_], r"\[IEB-TEST\] HoldIEAlias(?: slot=(\d+) holder=|: ([^\n]*))", 10)
        if not h or h.group(1) is None:
            return T.inconclusive(r, "HoldIEAlias wrapper missing or no free slot (%s)" % (h and h.group(2)))
        slot = int(h.group(1))
        checkpoint(r)
        t = T.tail("papyrus")
        r.ctl("StartTask", [F, "GoToLocation", T.DEST_NEAR[0], "", ""])
        ref = t.wait(r"SLOT_REFUSED slot=%d reason=held [^\n]*requester=%s requesterId=" % (slot, re.escape(nmF)), timeout=15)
        if not ref:
            return T.inconclusive(r, "no SLOT_REFUSED for F1 in 15 s (destination unresolved, IE confirmation box, or the "
                                     "patched IE pex is not installed)")
        time.sleep(3)
        pap = t.read()
        rep = refusal_report(pap, nmF)
        r.check(rep["refused"], "SLOT_REFUSED logged for F1 (held slot %d)" % slot)
        r.check(rep["dismissed"] and not rep["kept"], "drop mode ran: 'Dismissed follower' and no 'Kept follower'")
        r.check(rep["restored"], "refusal path restored the teammate flag (SLOT_REFUSED_UNDO)")
        f2 = T.probe(r, F)
        r.check(bool(f2) and f2.get("tm") == 1, "F1 is a teammate again (tm=%s)" % (f2 and f2.get("tm")))
        w = T.ctl_wait(r, "SUGetInt", [F, "Intel_WasFollower", 0],
                       r"\[IEB-TEST\] SU (?:%s|none) Intel_WasFollower get=(\S+)" % T.fid_rx(F), 10)
        r.check(bool(w) and w.group(1) == "0", "Intel_WasFollower unset on F1 (get=%s)" % (w and w.group(1)))
        r.check(not re.search(r"(?i)\[IEB\] (TAKE|LEND) actor=%s\b" % re.escape(nmF), pap),
                "the bridge saw no task for F1")
    finally:
        if slot is not None:
            T.ctl_wait(r, "ReleaseIEAlias", [slot], r"\[IEB-TEST\] ReleaseIEAlias", 10)
        m2 = T.ctl_wait(r, "SetDropTeammate", [0], r"\[IEB-TEST\] DropTeammate was=(\d+) now=(\d+)", 10)
        r.check(bool(m2) and m2.group(2) == "0", "IEB_DropTeammate restored to 0")
        T.check_inv(r, F)
