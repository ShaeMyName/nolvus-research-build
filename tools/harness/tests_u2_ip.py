"""U2 block, part 6: intimacy profiles IP (spec §11.13.4 table, BRIDGE_SPEC_V2.md:2637-2643). Started 2026-10-11.
MECHANICS ONLY (standing rule): call counts by prompt-template name, string LENGTHS (TestCtl.SUStrLen), heading presence
as a boolean computed in memory; no profile, prompt or disposition text is ever logged, printed or stored.

The feature is off by default (IEB_IntimacyEnabled on the player, SNRom_Bridge.psc:8972-8975); each test switches it on
with a StorageUtil write in the test profile and every test reloads T0 afterwards (reload=True).
Relationships: quest SNRom_Quest / script SNRom_Bridge (tests_misc.rel). Adult subject: Ysolda (REL-2's recruit; a
reload separates the families). Child subject (IP-2): Braith via tests_misc.ensure_child_enrolled (CS-11 route).
IP-6 (MARAS candidate on an un-enrolled adult, M4'): needs the MARAS candidate status route -> U3 (T0-M), stub."""
import json, os, re, time
import game
from block import test, checkpoint
from tests_misc import (PLAYER, YSOLDA, CHILD, F1, con, ctl_line, inc, rel, ah, su_set, su_get, who, tail, render,
                        ensure_child_enrolled, s32, near_player)
from fidnorm import fid_any_rx
from tests_u2 import uuids, market, place, bring_back

SNROM_DISP = "C:/Nolvus/Instances/Nolvus Awakening/MODS/overwrite/SKSE/Plugins/SkyrimNet Relationships/logs/dispositions.jsonl"
HEADING = "## Your intimacy profile"


def intimacy_on(r, on=True):
    """IEB_IntimacyEnabled on the player, read back Papyrus-side (SUGetInt; SU's set= is only an echo). RV-123 (3).
    True, or INCONCLUSIVE logged and False."""
    su_set(r, PLAYER, "IEB_IntimacyEnabled", 1 if on else 0)
    return su_is(r, PLAYER, "IEB_IntimacyEnabled", 1 if on else 0)


def su_is(r, fid, key, want):
    """RV-123 (3) read-back of a SUSetInt: SUGetInt (Papyrus) must give `want`. True, or INCONCLUSIVE logged and False."""
    v = su_get(r, None, key, fid=fid)
    if v != want:
        inc(r, "read-back SUSetInt %08X %s=%d: read %s (RV-123 (3))" % (fid, key, want, v))
        return False
    return True


def prompt_counts(text):
    """{template: n} for SendCustomPromptToLLM lines in a SkyrimNet.log window (names only)."""
    out = {}
    for m in re.finditer(r"PromptTemplate='([A-Za-z0-9_]+)'", text):
        out[m.group(1)] = out.get(m.group(1), 0) + 1
    return out


def mirror_len(r, fid):
    m = ctl_line(r, "SUStrLen", [s32(fid), "IEB_IntimacyProfile"], r"\[IEB-TEST\] SUSTRLEN \S+ IEB_IntimacyProfile len=(-?\d+)")
    return int(m.group(1)) if m else None


def has_heading(r, uuid, target=None):
    """True/False: the speaker's own dialogue_response render contains the profile heading (boolean only)."""
    out = render(r, uuid, template="dialogue_response", target=target)
    return None if out is None else (HEADING in out)


def enroll_adult(r, fid, timeout=300):
    """EnrollByHand + wait for the snrom 'Disposition authored' line. Returns (uuid, name, sn tail) or None."""
    u, name, child = who(r, fid)
    if not u or child:
        inc(r, "adult subject %08X not loaded" % fid)
        return None
    st, sn = tail("snrom"), tail("skyrimnet")
    rel(r, "EnrollByHand", [ah(fid)])
    if not st.wait(r"Enrolled by hand: %s\b" % re.escape(name), 60):
        inc(r, "no 'Enrolled by hand' line for %s" % name)
        return None
    if not st.wait(r"Disposition authored for %s\b" % re.escape(name), timeout):
        inc(r, "no 'Disposition authored' line for %s in %d s" % (name, timeout))
        return None
    return u, name, sn, st


@test("IP-1", "IP", reload=True)
def ip1(r):
    """Enroll an adult, romance-applicable NPC with the feature on: exactly one disposition call, then exactly one
    ieb_intimacy_author call; snrom 'Intimacy profile stored for <name> (length N)' (N reported); the mirror string
    IEB_IntimacyProfile is non-empty (length only). The durable 'Intimacy' store field is checked through the mirror
    restore in IP-5. 2 LLM calls."""
    if not market(r):
        return
    con(r, "%08X.moveto player" % YSOLDA)
    time.sleep(3)
    if not near_player(r, YSOLDA, "Ysolda moveto player"):
        return
    checkpoint(r, "2 LLM calls")
    if not intimacy_on(r):
        return
    e = enroll_adult(r, YSOLDA)
    if not e:
        return
    u, name, sn, st = e
    m = st.wait(r"Intimacy profile (stored|not stored|requested) for %s[^\n]*" % re.escape(name), 300)
    m2 = st.wait(r"Intimacy profile (stored|not stored) for %s[^\n]*" % re.escape(name), 300) if m and m.group(1) == "requested" else m
    c = prompt_counts(sn.read())
    r.log("  prompt calls by template (counts): %s" % {k: v for k, v in c.items() if "author" in k or "intimacy" in k})
    r.check(c.get("snrom_author_disposition", 0) == 1, "exactly one disposition call (%d)" % c.get("snrom_author_disposition", 0))
    r.check(c.get("ieb_intimacy_author", 0) == 1, "exactly one ieb_intimacy_author call (%d)" % c.get("ieb_intimacy_author", 0))
    stored = bool(m2) and m2.group(1) == "stored"
    ln = re.search(r"length (\d+)", m2.group(0)) if m2 else None
    r.check(stored, "profile stored (length %s)" % (ln.group(1) if ln else "?"))
    ml = mirror_len(r, YSOLDA)
    r.check(ml is not None and ml > 0, "mirror string present (length %s)" % ml)


@test("IP-2", "IP", reload=True)
def ip2(r):
    """A child enrolled (CS-11 route) with the feature on: NO ieb_intimacy_author call, no mirror string. Pass/fail only."""
    checkpoint(r, "1 LLM call (the child's own disposition)")
    if not intimacy_on(r):
        return
    sn = tail("skyrimnet")
    u, name = ensure_child_enrolled(r)
    if not u:
        return
    time.sleep(30)
    c = prompt_counts(sn.read())
    r.check(c.get("ieb_intimacy_author", 0) == 0, "no intimacy authoring call for a child")
    ml = mirror_len(r, CHILD)
    r.check(ml in (0, None, -1), "no mirror string on the child")


@test("IP-3", "IP", reload=True)
def ip3(r):
    """Intimacy NEVER (SNRom_PhysMinTier < 0) on an enrolled, authored adult: even forced and re-queued, no profile call.
    Setup: enroll Ysolda with the feature OFF (no profile), then set PhysMinTier -1 + IEB_ForceIntimacyAuthor 1, switch the
    feature on and call IEB_QueueIntimacy directly. 1 LLM call (disposition)."""
    if not market(r):
        return
    con(r, "%08X.moveto player" % YSOLDA)
    time.sleep(3)
    if not near_player(r, YSOLDA, "Ysolda moveto player"):
        return
    checkpoint(r, "1 LLM call")
    if not intimacy_on(r, False):
        return
    e = enroll_adult(r, YSOLDA)
    if not e:
        return
    u, name, sn, st = e
    su_set(r, YSOLDA, "SNRom_PhysMinTier", -1)
    su_set(r, YSOLDA, "IEB_ForceIntimacyAuthor", 1)
    if not (su_is(r, YSOLDA, "SNRom_PhysMinTier", -1) and su_is(r, YSOLDA, "IEB_ForceIntimacyAuthor", 1)):
        return
    if not intimacy_on(r, True):
        return
    sn.mark()
    rel(r, "IEB_QueueIntimacy", [ah(YSOLDA)])
    time.sleep(40)
    c = prompt_counts(sn.read())
    r.check(c.get("ieb_intimacy_author", 0) == 0, "intimacy NEVER: no profile call (%d)" % c.get("ieb_intimacy_author", 0))


@test("IP-4", "IP", reload=True)
def ip4(r):
    """Heading search only: after IP-1-style authoring, the profile heading is in Ysolda's OWN dialogue_response with scene
    mode on and her as partner; absent with scene mode off (Friend or below); absent from a bystander's (F1) prompt.
    The 'romantic Lover' half needs the Lover rank -> recorded as not covered here. 2 LLM calls."""
    if not market(r):
        return
    con(r, "%08X.moveto player" % YSOLDA)
    time.sleep(3)
    if not near_player(r, YSOLDA, "Ysolda moveto player"):
        return
    checkpoint(r, "2 LLM calls")
    if not intimacy_on(r):
        return
    e = enroll_adult(r, YSOLDA)
    if not e:
        return
    u, name, sn, st = e
    if not st.wait(r"Intimacy profile stored for %s" % re.escape(name), 300):
        return inc(r, "no stored profile to look for")
    fu, pu = uuids(r, F1, PLAYER)
    off = has_heading(r, u, pu)
    ctl_line(r, "SceneOn", [YSOLDA], r"\[IEB-TEST\] SCENE on partner=")
    try:
        # RV-123 (3): SCENE on only echoes the partner; read the keys SceneOn writes back Papyrus-side
        if not (su_is(r, YSOLDA, "IEB_IsScenePartner", 1) and su_is(r, PLAYER, "IEB_SceneMode", 1)):
            return
        time.sleep(6)
        on = has_heading(r, u, pu)
        by = has_heading(r, fu, pu) if fu else None
    finally:
        ctl_line(r, "SceneOff", [], r"\[IEB-TEST\] SCENE off")
    r.check(on is True, "heading present in her own prompt with scene mode on (partner)")
    r.check(off is False, "heading absent with scene mode off (not Lover)")
    r.check(by is False, "heading absent from a bystander's prompt")
    r.log("  Lover-rank case: not covered here (needs the Lover rank; S-C / U3)")


@test("IP-5", "IP", reload=True)
def ip5(r):
    """Save, reload: the mirror string is restored after load (length > 0, IEB_IntimacyOnLoad), and again after a second
    reload with harness mode's automatic Delete History (the durable store keeps the field). 2 LLM calls (authoring)."""
    if not market(r):
        return
    con(r, "%08X.moveto player" % YSOLDA)
    time.sleep(3)
    if not near_player(r, YSOLDA, "Ysolda moveto player"):
        return
    checkpoint(r, "2 LLM calls + 2 reloads")
    if not intimacy_on(r):
        return
    e = enroll_adult(r, YSOLDA)
    if not e:
        return
    u, name, sn, st = e
    if not st.wait(r"Intimacy profile stored for %s" % re.escape(name), 300):
        return inc(r, "no stored profile")
    if not game.save(r, "IEB_IP5"):
        return inc(r, "SaveNamed IEB_IP5 failed")
    for n in (1, 2):
        if not game.load(r, "IEB_IP5", None):
            return inc(r, "load %d of IEB_IP5 failed" % n)
        time.sleep(15)
        ml = mirror_len(r, YSOLDA)
        r.check(ml is not None and ml > 0, "after load %d: mirror restored (length %s)" % (n, ml))


@test("IP-7", "IP", reload=True)
def ip7(r):
    """Logs: dispositions.jsonl holds no profile text (no row carries an intimacy field) and our snrom line for the profile
    carries a length, not text (line shorter than 200 chars). Reads only field NAMES and line lengths."""
    checkpoint(r)
    rows = bad = 0
    if os.path.exists(SNROM_DISP):
        for line in open(SNROM_DISP, encoding="utf-8", errors="replace"):
            try:
                d = json.loads(line)
            except ValueError:
                continue
            rows += 1
            if any("intimacy" in str(k).lower() for k in (d.keys() if isinstance(d, dict) else [])):
                bad += 1
    else:
        return inc(r, "dispositions.jsonl not found in the overwrite (no enrolment yet this profile?)")
    r.log("  dispositions.jsonl rows: %d, rows with an intimacy field: %d" % (rows, bad))
    r.check(bad == 0, "no intimacy field in dispositions.jsonl")
    st = tail("snrom")
    st.pos = 0
    lines = [l for l in st.read().splitlines() if "Intimacy profile stored for" in l]
    r.check(all(len(l) < 200 for l in lines), "snrom profile lines carry a length only (%d lines, max %d chars)" %
            (len(lines), max([len(l) for l in lines] or [0])))


@test("IP-6", "IP")
def ip6(r):
    """MARAS 'candidate' on an un-enrolled adult (M4'): needs the MARAS status route -> U3 (T0-M)."""
    checkpoint(r)
    inc(r, "needs the MARAS candidate route (U3, T0-M)")
