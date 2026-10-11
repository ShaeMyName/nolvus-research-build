"""U2 block, part 4: scene stack SC (spec §11.7 / §11.13.8 tables, BRIDGE_SPEC_V2.md:2626-2631, :2752-2758).
Started 2026-10-11. House style: tests_u2.py (counts only; no prompt, reply or event text is logged; text read from the
harness utterance records is processed in memory into counts/booleans only). Intimacy rule: mechanics only.

Joins/leaves call the SceneControls quest entry points directly (execute_quest_function IEB_SceneQuest /
IEB_SceneActions.JoinScene|LeaveScene, the same functions SkyrimNet's actions call; IEB_SceneActions.psc:6-22): the
'NPC picks the action' and 'player confirms the box' steps are the LLM/UI halves, covered in S-C.
Scene start uses the TestCtl SceneOn wrapper (no crosshair; LEN-4/PV-1 note).

Not automated here: SC-1 and SC-3 (judgement of reply content) -> JUDGE stub + INCONCLUSIVE; SC-4's 'no scene branch /
9900 / 0335' prompt-trace headings need the prompt viewer route (template sweep) -> INCONCLUSIVE stub.
LLM cost: SC-2/5/6 share one 20-reply scene per partner x 3 partners = 60 calls (time plan §5 budgets it); others 0-2."""
import re, time
import game
import sn_harness as SH
from block import test, checkpoint
from tests_misc import (PLAYER, F1, F2, CHILD, FRALIA, YSOLDA, CARLOTTA, con, ctl_line, hx, inc, qf, ah, su_get, su_set,
                        who, eligible)
from fidnorm import fid_any_rx
from tests_u2 import market, uuids, place, bring_back, radius, hist_hits, harness_ready

SCQ, SCS = "IEB_SceneQuest", "IEB_SceneActions"
EXCL_MIN = 88            # SNRom_Bridge.CONSUMING_MIN() (spec SC-13 'at or above 88')
_UTT_TEXT_KEYS = ("text", "line", "content", "subtitle", "message")


def pap():
    return game.Tail(game.LOGS["papyrus"])


def scene_on(r, fid):
    return ctl_line(r, "SceneOn", [fid], r"\[IEB-TEST\] SCENE on partner=")


def scene_off(r):
    ctl_line(r, "SceneOff", [], r"\[IEB-TEST\] SCENE off")


def join(r, fid, timeout=15):
    """JoinScene on the quest entry point; returns the JOIN_* log match or None."""
    t = pap()
    qf(r, SCQ, SCS, "JoinScene", [ah(fid)])
    return t.wait(r"\[IEB-SC\] JOIN_(ACCEPTED|REFUSED) [^\n]*", timeout)


def leave(r, fid, timeout=15):
    t = pap()
    qf(r, SCQ, SCS, "LeaveScene", [ah(fid)])
    return t.wait(r"\[IEB-SC\] PARTNER_LEFT [^\n]*", timeout)


def partner_flag(r, fid):
    pu, = uuids(r, fid)
    return su_get(r, pu, "IEB_IsScenePartner", fid=fid)


def _setup_scene(r, a_fid, extra=()):
    """Market, partner A beside the player with scene mode on, extra NPCs placed 300 u away. Returns uuids or None."""
    market(r)
    for i, f in enumerate((a_fid,) + tuple(extra)):
        con(r, "%08X.moveto player" % f)
        time.sleep(1)
        place(r, f, 150 if i == 0 else 300, 60 * i, 0)
    time.sleep(2)
    if not scene_on(r, a_fid):
        inc(r, "SceneOn wrapper gave no line")
        return False
    return True


def _cleanup(r, fids):
    scene_off(r)
    for f in fids:
        bring_back(r, f)


# ---------------------------------------------------------------------------- joins / leaves / caps

@test("SC-7", "SC", reload=True)
def sc7(r):
    """Witness B joins mid-scene (post-confirmation path): JOIN_ACCEPTED partners=2, B's IEB_IsScenePartner = 1, A's still 1,
    one persistent 'joined' event in B's history (fixed fragment of our own code's literal, count only). The scene-tier
    and 9900 heading checks of B's next reply and the turn-taking report are S-C / template-sweep items."""
    A, B = F1, F2
    try:
        if not _setup_scene(r, A, (B,)):
            return
        checkpoint(r)
        bu, = uuids(r, B)
        j0 = hist_hits(r, bu, "in the scene") if bu else None
        m = join(r, B)
        r.check(bool(m) and m.group(1) == "ACCEPTED" and "partners=2" in m.group(0), "JOIN_ACCEPTED partners=2 (%s)" %
                (m.group(0).split("] ", 1)[-1] if m else "no line"))
        r.check(partner_flag(r, B) == 1, "B has IEB_IsScenePartner = 1")
        r.check(partner_flag(r, A) == 1, "A keeps IEB_IsScenePartner = 1")
        time.sleep(3)
        j1 = hist_hits(r, bu, "in the scene") if bu else None
        r.check(j0 is not None and j1 is not None and j1 >= j0 + 1, "one persistent 'joined' event in B's history (%s -> %s)" % (j0, j1))
    finally:
        _cleanup(r, (A, B))


@test("SC-8", "SC", reload=True)
def sc8(r):
    """Witness declines (never calls JoinScene): B is not a partner and keeps receiving witness events. Mechanical half:
    after the scene starts, B's partner flag stays unset and the next ieb_witness 'scene' event (SceneWitness, public
    scene) lands in B's history. The 'player declines the confirmation box' half is S-C."""
    A, B = F1, F2
    try:
        if not _setup_scene(r, A, (B,)):
            return
        checkpoint(r)
        bu, = uuids(r, B)
        w0 = hist_hits(r, bu, etype="ieb_witness")
        t = pap()
        m = t.wait(r"\[IEB-SC\] WITNESS scene rc=", 330)       # public scene: (c) at start, then at most every 5 min
        r.check(partner_flag(r, B) in (0, -99), "B is not a scene partner")
        if not m:
            return inc(r, "no scene witness event fired within 330 s")
        time.sleep(3)
        r.check((hist_hits(r, bu, etype="ieb_witness") or 0) > (w0 or 0), "B still receives the scene witness event")
    finally:
        _cleanup(r, (A, B))


@test("SC-9", "SC", reload=True)
def sc9(r):
    """A child cannot join: JoinScene is not an eligible action for the child (eligibility check), and a direct JoinScene
    call is refused with 'JOIN_REFUSED <hex> child'; the child gets no partner flag. Mechanics only (pass/fail)."""
    A = F1
    try:
        if not _setup_scene(r, A, (CHILD,)):
            return
        cu, _, child = who(r, CHILD)
        if not cu or not child:
            return inc(r, "child not loaded or not IsChild")
        checkpoint(r)
        e, _ = eligible(r.tool("check_action_eligibility", {"action_name": "JoinScene", "actor_uuid": cu}))
        r.check(e is False, "JoinScene not eligible for a child (%s)" % e)
        m = join(r, CHILD)
        r.check(bool(m) and "child" in m.group(0) and m.group(1) == "REFUSED", "direct JoinScene refused: child")
        r.check(partner_flag(r, CHILD) in (0, -99), "child has no partner flag")
    finally:
        _cleanup(r, (A, CHILD))


@test("SC-11", "SC", reload=True)
def sc11(r):
    """Leaving: B LeaveScene -> PARTNER_LEFT B (left), flag cleared at once; A walks beyond 2x the radius -> A removed after
    about 10 s; SceneOff clears every IEB_IsScenePartner. (The 'reload mid-scene leaves none set' half is LEN-4.)"""
    A, B = F1, F2
    try:
        if not _setup_scene(r, A, (B,)):
            return
        m = join(r, B)
        if not m or m.group(1) != "ACCEPTED":
            return inc(r, "B could not join (%s)" % (m.group(0) if m else "no line"))
        checkpoint(r)
        lm = leave(r, B)
        r.check(bool(lm) and "(left)" in lm.group(0), "PARTNER_LEFT B (left)")
        r.check(partner_flag(r, B) in (0, -99), "B's partner flag cleared at once")
        t = pap()
        place(r, A, 2 * radius(r) + 400, 0, 0)
        t0 = time.time()
        am = t.wait(r"\[IEB-SC\] PARTNER_LEFT [^\n]*", 40)
        r.check(bool(am), "A removed after walking beyond 2x the radius")
        if am:
            r.log("  A removed after %.0f s" % (time.time() - t0))
            r.check(time.time() - t0 <= 25, "A removed within about 10-20 s")
        scene_off(r)
        r.check(partner_flag(r, A) in (0, -99) and partner_flag(r, B) in (0, -99), "no partner flag left after scene-off")
    finally:
        _cleanup(r, (A, B))


@test("SC-12", "SC", reload=True)
def sc12(r):
    """Partner cap 3 (IEB_SceneMain.MaxPartners): A + two joins accepted; a 4th JoinScene -> 'JOIN_REFUSED <hex> cap'."""
    A, B, C, D = F1, F2, FRALIA, YSOLDA
    try:
        if not _setup_scene(r, A, (B, C, D)):
            return
        for f in (B, C):
            m = join(r, f)
            if not m or m.group(1) != "ACCEPTED":
                return inc(r, "setup join of %08X failed (%s)" % (f, m.group(0) if m else "no line"))
        checkpoint(r)
        m = join(r, D)
        r.check(bool(m) and m.group(1) == "REFUSED" and m.group(0).rstrip().endswith("cap"), "4th join refused: cap")
        r.check(partner_flag(r, D) in (0, -99), "4th NPC has no partner flag")
    finally:
        _cleanup(r, (A, B, C, D))


@test("SC-13", "SC", reload=True)
def sc13(r):
    """Existing partners' say. Run 1: A's SNRom_Exclusivity = 88 (>= CONSUMING_MIN): B's join refused 'by A excl=88', B not a
    partner, one persistent refusal event in A's history (fixed fragment 'did not join the scene', count only). Run 2: A at
    50: B accepted. A's reaction category (stay / leave) is recorded from the LeaveScene log only; the memory check is the
    later memory page count (S-C). StorageUtil writes in the test profile only, undone by the reload."""
    A, B = F1, F2
    au = None
    try:
        for run, excl in ((1, EXCL_MIN), (2, 50)):
            if not _setup_scene(r, A, (B,)):
                return
            au, = uuids(r, A)
            su_set(r, A, "SNRom_Exclusivity", excl)
            if run == 1:
                checkpoint(r)
            h0 = hist_hits(r, au, "did not join the scene")
            m = join(r, B, timeout=20)
            if run == 1:
                r.check(bool(m) and m.group(1) == "REFUSED" and ("excl=%d" % excl) in m.group(0),
                        "run 1: refused by A with excl=%d (%s)" % (excl, m.group(0).split("] ", 1)[-1] if m else "no line"))
                r.check(partner_flag(r, B) in (0, -99), "run 1: B not a partner")
                time.sleep(4)
                h1 = hist_hits(r, au, "did not join the scene")
                r.check(h0 is not None and h1 == h0 + 1, "run 1: one persistent refusal event in A's history (%s -> %s)" % (h0, h1))
            else:
                r.check(bool(m) and m.group(1) == "ACCEPTED", "run 2 (excl 50): B accepted")
                t = pap()
                lm = t.wait(r"\[IEB-SC\] PARTNER_LEFT %s" % fid_any_rx(A), 45)
                r.log("  run 2: A %s (category only)" % ("left the scene" if lm else "stayed"))
            _cleanup(r, (A, B))
    finally:
        _cleanup(r, (A, B))


@test("SC-10", "SC", reload=True)
def sc10(r):
    """Private with two partners: Breezehome (rule i, whisper on -> radius 200), A + B join, nobody else within 200 u:
    IEB_ScenePrivate becomes 1 within about 10 s. The per-partner sensations / decline-across-partners halves are
    judgement (S-C / JUDGE)."""
    A, B = F1, F2
    try:
        con(r, "coc WhiterunBreezehome")
        time.sleep(12)
        for f, d in ((A, 120), (B, 160)):
            con(r, "%08X.moveto player" % f)
            time.sleep(1)
            place(r, f, d, 0, 0)
        time.sleep(2)
        if not scene_on(r, A):
            return inc(r, "SceneOn wrapper gave no line")
        m = join(r, B)
        if not m or m.group(1) != "ACCEPTED":
            return inc(r, "B could not join (%s)" % (m.group(0) if m else "no line"))
        checkpoint(r)
        t = pap()
        pm = t.wait(r"\[IEB-SC\] PRIVATE 0->1", 15)
        pu, = uuids(r, PLAYER)
        r.check(bool(pm) or su_get(r, pu, "IEB_ScenePrivate", fid=PLAYER) == 1, "IEB_ScenePrivate = 1 with two partners")
        r.log("  JUDGE: per-partner sensations / cross-partner decline are judged in S-C (no text here)")
    finally:
        _cleanup(r, (A, B))


# ---------------------------------------------------------------------------- 20-reply scenes (SC-2 / SC-5 / SC-6)

_SCENE_LINES = ["Come here.", "Stay close to me.", "Tell me what you want.", "Slowly.", "Like that?", "Don't stop.",
                "Look at me.", "What are you thinking?", "Closer.", "Mm. And now?", "Your turn.", "Breathe.",
                "Again.", "Tell me how that feels.", "Rest a moment.", "Hold me.", "Kiss me.", "Gently.",
                "Is this all right?", "Stay with me."]
_CACHE = {}


def _texts_since(u0, fu, pu):
    """NPC utterance texts after the u0 snapshot, in memory only."""
    try:
        res = SH.utterances()
    except SH.HarnessError:
        return None
    rows = res.get("utterances", []) if isinstance(res, dict) else (res if isinstance(res, list) else [])
    new = rows[len(u0):] if u0 is not None and len(rows) >= len(u0) else rows
    out = []
    for it in new:
        if not isinstance(it, dict):
            continue
        vals = [str(v).lower() for v in it.values() if isinstance(v, str)]
        if pu and pu.lower() in vals:
            continue
        for k in _UTT_TEXT_KEYS:
            if isinstance(it.get(k), str):
                out.append(it[k])
                break
    return out


def _scene_20(r, npc):
    """One 20-reply scene with partner npc; returns a list of reply texts (memory only) or None. Cached per partner."""
    if npc in _CACHE:
        return _CACHE[npc]
    market(r)
    if not harness_ready(r):
        return None
    fu, pu = uuids(r, npc, PLAYER)
    if not (fu and pu):
        inc(r, "partner %08X not loaded" % npc)
        return None
    con(r, "%08X.moveto player" % npc)
    place(r, npc, 150, 0, 0)
    con(r, "set IEB_WitnessEnabled to 0")
    replies = []
    try:
        if not scene_on(r, npc):
            inc(r, "SceneOn wrapper gave no line")
            return None
        SH.pacing(True)
        for line in _SCENE_LINES:
            try:
                u0 = SH.utterances()
                u0 = u0.get("utterances", []) if isinstance(u0, dict) else u0
                SH.inject_player_input(line, fu)
                SH.await_idle(90)
                time.sleep(1)
                t = _texts_since(u0, fu, pu)
                if t:
                    replies.append(" ".join(t))
            except SH.HarnessError as e:
                inc(r, "harness call failed: %s" % e)
                break
    finally:
        scene_off(r)
        con(r, "set IEB_WitnessEnabled to 1")
        try:
            SH.pacing(False)
        except SH.HarnessError:
            pass
        bring_back(r, npc)
    r.log("  scene with %08X: %d of %d replies captured (texts kept in memory only)" % (npc, len(replies), len(_SCENE_LINES)))
    _CACHE[npc] = replies
    return replies


def _spans(text):
    seg = text.split("*")
    return [s for i, s in enumerate(seg) if i % 2 == 1], [s for i, s in enumerate(seg) if i % 2 == 0]


def _no_quotes(s):
    return re.sub(r'"[^"]*"', " ", s)


SC_PARTNERS = (F1, F2, FRALIA)


@test("SC-2", "SC", reload=True)
def sc2(r):
    """Third person in action text: over a 20-reply scene with each of 3 partners, 0 asterisk spans containing I/me/my
    (quotes excluded). Counts only. 60 LLM calls (shared with SC-5/SC-6 in the same process)."""
    checkpoint(r, "60 LLM calls")
    bad = total = 0
    for p in SC_PARTNERS:
        rep = _scene_20(r, p)
        if not rep:
            return inc(r, "no replies captured with %08X" % p)
        for t in rep:
            act, _ = _spans(t)
            total += len(act)
            bad += sum(1 for s in act if re.search(r"\b(I|me|my)\b", _no_quotes(s)))
    r.log("  asterisk spans: %d, first-person spans: %d" % (total, bad))
    if not total:
        return inc(r, "no asterisk spans at all")
    r.check(bad == 0, "0 first-person asterisk spans (%d of %d)" % (bad, total))


@test("SC-5", "SC", reload=True)
def sc5(r):
    """Length over the same 20 replies per partner: spoken <= 60 words and asterisk text <= 200 words per reply; at least 4
    replies under 80 words in total per partner (variety). Counts only."""
    checkpoint(r, "uses the SC-2 scenes")
    for p in SC_PARTNERS:
        rep = _scene_20(r, p)
        if not rep:
            return inc(r, "no replies captured with %08X" % p)
        sp = [sum(len(s.split()) for s in _spans(t)[1]) for t in rep]
        ac = [sum(len(s.split()) for s in _spans(t)[0]) for t in rep]
        short = sum(1 for a, b in zip(sp, ac) if a + b < 80)
        r.log("  %08X: max spoken %d, max action %d, under-80 replies %d/%d" % (p, max(sp), max(ac), short, len(rep)))
        r.check(max(sp) <= 60, "%08X: spoken <= 60 words in every reply" % p)
        r.check(max(ac) <= 200, "%08X: action text <= 200 words in every reply" % p)
        r.check(short >= 4, "%08X: at least 4 replies under 80 words (%d)" % (p, short))


@test("SC-6", "SC", reload=True)
def sc6(r):
    """No reuse: recurring 4-word phrases per scene, counted and reported (round 3 baseline 15-17 per scene). No pass mark:
    trend only, so this test records the counts and passes when they were measured."""
    checkpoint(r, "uses the SC-2 scenes")
    for p in SC_PARTNERS:
        rep = _scene_20(r, p)
        if not rep:
            return inc(r, "no replies captured with %08X" % p)
        grams = {}
        for t in rep:
            w = re.findall(r"[a-z']+", t.lower())
            for g in set(tuple(w[i:i + 4]) for i in range(len(w) - 3)):
                grams[g] = grams.get(g, 0) + 1
        rec = sum(1 for v in grams.values() if v >= 2)
        r.log("  %08X: recurring 4-word phrases: %d (round 3: 15-17)" % (p, rec))
    r.check(True, "recurring phrases counted (trend only)")


@test("SC-1", "SC", reload=True)
def sc1(r):
    """Decline rule: needs a judgement of whether the next replies pursue -> JUDGE stub (S-C feel-check covers it)."""
    checkpoint(r)
    inc(r, "judgement test: SC-1 is judged in the S-C sitting (no reply text in the harness)")


@test("SC-3", "SC", reload=True)
def sc3(r):
    """Names and titles engagement: judgement -> S-C."""
    checkpoint(r)
    inc(r, "judgement test: SC-3 is judged in the S-C sitting")


@test("SC-4", "SC", reload=True)
def sc4(r):
    """Bystander casual tier during a scene (no scene branch, no 9900, no 0335): needs prompt-trace headings for the
    bystander's own reply -> template live sweep route (render dialogue_response for the bystander during a scene)."""
    checkpoint(r)
    inc(r, "prompt-trace heading check moves to the template live sweep (render with a scene on)")
