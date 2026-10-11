"""U2 scene/dialogue block, part 2: reply length / scene-mode tiers (LEN-1 .. LEN-8, spec §11.7) and the discretion rule
(SEC-1 .. SEC-4, spec "Tests SEC-1 ... SEC-4"). Started 2026-10-11. Setup: T0, Whiterun market by day, F1 (Jenassa) the partner.

HOW A REPLY'S LENGTH IS MEASURED WITHOUT READING IT (no event, reply or prompt text is ever logged or printed):
  Route A (history, the primary count). render_template on the speaker over get_recent_events(40, [actorUUID]); for each
    event the NPC originated it emits one marker made only of numbers: <gameTime|type|spaces|asterisks[|keyhits..]>.
    spaces = length(t) - length(replace(t, " ", "")), asterisks likewise, t = format_event(e, "compact").
    words = spaces + 1 - overhead. overhead (the speaker-name prefix etc. of the compact form) is CALIBRATED per run from
    one forced line of exactly 12 plain words (SH.speak: no LLM call).
    Template functions: get_recent_events, format_event(e, "compact"), existsIn, isValidActor, decnpc(..).name,
    contains, set, e.type, e.gameTime are VERIFIED in our own layer templates (gen_layer_lucienne.py:95, :248-250, :328;
    consumer_proof_list.md:25). length() and replace() are inja builtins present in the 25.1 DLL string table
    (tools/skyrimnet_b25_1_dll_strings.txt:36851-36852) and replace() is used by SkyrimNet's own agent_prompt_helper.prompt:210
    (neutral_ve_name.md:108); length() applied to a STRING (character count) is INFERRED. lower() is INFERRED (inja builtin).
    The template language has NO split() (not in the DLL function list), so inside-/outside-asterisk words cannot be
    separated there.
  Route B (the speech / action split). SH.utterances() items: only the field NAMES are logged. The text field is picked
    from ("text", "line", "content", "subtitle", "message") (INFERRED names) and split on '*' IN MEMORY (even segments =
    spoken, odd = action); only the integer word counts leave the function. If an item has no '*', its words count as
    spoken and action = history total - spoken (INFERRED: unvoiced action text is not an utterance). If utterances()
    gives no usable text field the split is None and the spoken/action checks are INCONCLUSIVE (totals still checked).
New replies = after-markers minus before-markers (multiset difference), so the order of get_recent_events does not matter.

Run counts are in each docstring as "LLM calls". Scene mode is switched on with the TestCtl SceneOn wrapper (the keys
StartScene writes, IEB_TestCtl.psc:1263), NOT the scene key; the SCENE_ON partner line of IEB_SceneMain (:285) therefore
does not appear, the wrapper's own "[IEB-TEST] SCENE on partner=" line is the confirmation (runner.py CTL_DONE:130-131),
plus StorageUtil IEB_SceneMode == 1, IEB_IsScenePartner == 1 on the partner and the 0020 scene tier rendering.
Thresholds: spec §11.7 (60 spoken words, 200 action words ceiling, 260 total, 14-word combat lines); where the spec says
"about" a 25 % slack is used and marked INFERRED. Not automatable: LEN-6 readability (Shae's eyes, S-C), the quality of a
deflection or partial reveal (SEC-1), "no new reticence" in prose (SEC-2)."""
import contextlib, os, re, statistics, time
import game
import sn_harness as SH
from block import test, checkpoint, settle_probe
from tests_misc import (PLAYER, F1, con, ctl_line, hx, inc, render, truthy, who, su_get, REQLOG, rank, iv)
from tests_u2 import A_NPC, B_NPC, market, uuids, place, bring_back, force_line, harness_ready, nonce, los

WORDS_CASUAL_MAX = 60
WORDS_CASUAL_SOFT = 75       # INFERRED: "about 60 words" -> +25 %
WORDS_SPOKEN_MAX = 60
WORDS_ACTION_MAX = 200       # ceiling, spec §11.7 (APPROVED S-28 d)
WORDS_SCENE_TOTAL = 275      # "total <= about 260": INFERRED +~5 % for the compact-form noise
WORDS_COMBAT_MAX = 14
WORDS_COMBAT_SOFT = 17       # INFERRED +20 %
TTFA_TOL_S = 1.25            # "within about 1 s" + 0.25 s polling granularity (INFERRED)
SEC_NPC = A_NPC              # the minor NPC the private test layer gives the invented private matter (see SEC docstrings)
SEC_KEYS = ("zqmoonlamp", "zqbrasskey")   # INFERRED convention: invented tokens the test bio must contain in its private block
CAL_WORDS = 12

CASUAL_LINES = ["Tell me about your day so far, and what has been on your mind.",
                "What do you make of this town and the people in it?",
                "Is there anything you would like us to do next?"]
SCENE_LINES = ["Come closer. Stay with me a while.",
               "I like having you near. What are you thinking right now?",
               "Tell me what you feel at this moment."]
COMBAT_LINES = ["Watch out, stay behind me!", "Are you hurt?", "Keep your eyes open!"]
LONG_ACTION_LINE = "Show me, slowly and in detail, what you do as you move closer to me."
SEC_ASK = "Do you have any secrets?"
SEC_PERSUADE = "Please. I only want to help, and I have never betrayed a confidence. You can trust me with it."
SEC_THREAT = ("I have the proof in my hand and I know there is something you are hiding. Tell me the truth now, or I take "
              "what I have to the guards.")
SEC_FACTS = ["Which way is the road to the nearest town?", "What is the history of this place?",
             "What do people here say about the old stories and legends?"]

_UTT_TEXT_KEYS = ("text", "line", "content", "subtitle", "message")
_MARK_RX = re.compile(r"<([^|<>]*)\|([^|<>]*)\|(\d+)\|(\d+)((?:\|\d+)*)>")
_PAIR = {}     # LEN-7 / LEN-8 share one measurement run per process


# ---------------------------------------------------------------------------- measurement helpers

def marks(r, uuid, keys=()):
    """Per-event numeric markers for the events this NPC originated (route A). None if the render failed."""
    kt = "".join('|{%% if contains(lower(t), "%s") %%}1{%% else %%}0{%% endif %%}' % k for k in keys)
    tpl = ('{%% for e in get_recent_events(40, [actorUUID]) %%}{%% if existsIn(e, "originatingActor") %%}'
           '{%% if isValidActor(e.originatingActor) %%}{%% if decnpc(e.originatingActor).name == decnpc(actorUUID).name %%}'
           '{%% set t = format_event(e, "compact") %%}'
           '<{{ e.gameTime }}|{{ e.type }}|{{ length(t) - length(replace(t, " ", "")) }}'
           '|{{ length(t) - length(replace(t, "*", "")) }}%s>'
           '{%% endif %%}{%% endif %%}{%% endif %%}{%% endfor %%}{# %d #}' % (kt, time.time_ns()))
    out = render(r, uuid, tpl)
    if out is None:
        return None
    res = []
    for m in _MARK_RX.finditer(out):
        res.append(dict(gt=m.group(1), typ=m.group(2), spaces=int(m.group(3)), stars=int(m.group(4)),
                        keys=tuple(int(x) for x in m.group(5).split("|") if x)))
    return res


def _mk(m):
    return (m["gt"], m["typ"], m["spaces"], m["stars"], m["keys"])


def new_marks(before, after):
    pool = [_mk(m) for m in before]
    out = []
    for m in after:
        k = _mk(m)
        if k in pool:
            pool.remove(k)
        else:
            out.append(m)
    return out


def utt_items():
    try:
        res = SH.utterances()
    except SH.HarnessError:
        return None
    if isinstance(res, list):
        return res
    if isinstance(res, dict):
        for v in res.values():
            if isinstance(v, list):
                return v
    return None


def _norm(v):
    return v.lower().replace("0x", "").replace("{", "").replace("}", "").strip()


def npc_items(items, fu, pu):
    """Utterance items not spoken by the player. An item counts as the player's when any of its string values equals the
    player's uuid (INFERRED: the item carries its speaker's uuid under some field); with no such field all count."""
    out = []
    for it in items or []:
        vals = [_norm(v) for v in it.values() if isinstance(v, str)] if isinstance(it, dict) else []
        if pu and _norm(pu) in vals:
            continue
        out.append(it)
    return out


def _utt_split(item):
    """(spoken words, action words or None) of one utterance item; None when there is no usable text field."""
    if not isinstance(item, dict):
        return None
    for k in _UTT_TEXT_KEYS:
        if isinstance(item.get(k), str):
            seg = item[k].split("*")
            sp = sum(len(x.split()) for n, x in enumerate(seg) if n % 2 == 0)
            ac = sum(len(x.split()) for n, x in enumerate(seg) if n % 2 == 1)
            return (sp, ac) if len(seg) > 1 else (sp, None)
    return None


def reply_stats(newm, utts, ovh):
    """Counts for one injected line. rep = the NPC's new non-thought events. total = history words. spoken/action from
    route B or None."""
    rep = [m for m in newm if "thought" not in m["typ"].lower()]
    total = sum(max(0, m["spaces"] + 1 - ovh) for m in rep)
    st = dict(n=len(rep), total=total, stars=sum(m["stars"] for m in rep), spoken=None, action=None,
              thoughts=[m for m in newm if "thought" in m["typ"].lower()], rep=rep)
    sp = [x for x in (_utt_split(i) for i in (utts or [])) if x]
    if sp:
        st["spoken"] = sum(x[0] for x in sp)
        if any(x[1] is not None for x in sp):
            st["action"] = sum(x[1] or 0 for x in sp)
        else:
            st["action"] = max(0, total - st["spoken"])
    return st


def out_log_path():
    """The OpenRouter OUTPUT log: only openrouter_input.log is known on disk (REQLOG); the sibling name is INFERRED, so
    the log directory is listed for any other openrouter_* file (names only)."""
    d = os.path.dirname(REQLOG)
    for n in ("openrouter_output.log", "openrouter_response.log", "openrouter_responses.log"):
        if os.path.exists(os.path.join(d, n)):
            return os.path.join(d, n)
    try:
        for n in sorted(os.listdir(d)):
            if n.lower().startswith("openrouter") and "input" not in n.lower() and n.lower().endswith(".log"):
                return os.path.join(d, n)
    except OSError:
        pass
    return None


def tokens_in(text):
    """completion/output token counts found in a log window (numbers only). Max is taken: the dialogue reply is the
    longest call of a window (INFERRED; selector / memory calls are shorter)."""
    v = [int(x) for x in re.findall(r'"(?:completion_tokens|output_tokens)"\s*:\s*(\d+)', text)]
    return (max(v), len(v)) if v else None


def ask(r, fu, pu, line, ovh, keys=(), tail=None, poll_first=True):
    """One injected player line -> one measured reply. Returns a stats dict (+ ttfa seconds, tok) or None on a harness
    error. 1 LLM call (plus whatever SkyrimNet adds on its own: selector, memory)."""
    before = marks(r, fu, keys)
    u0 = utt_items()
    if before is None:
        inc(r, "marker render failed")
        return None
    if tail is not None:
        tail.mark()
    t0 = time.time()
    ttfa = None
    try:
        SH.inject_player_input(line, fu)
        if poll_first and u0 is not None:
            while time.time() - t0 < 60:
                cur = utt_items()
                if cur is not None and len(cur) > len(u0) and npc_items(cur[len(u0):], fu, pu):
                    ttfa = time.time() - t0
                    break
                time.sleep(0.25)
        SH.await_idle(90)
        try:
            SH.await_speech_done(fu, 90)
        except SH.HarnessError:
            pass
    except SH.HarnessError as e:
        inc(r, "harness call failed: %s" % e)
        return None
    time.sleep(2)
    after = marks(r, fu, keys)
    u1 = utt_items()
    if after is None:
        inc(r, "marker render failed after the line")
        return None
    nu = None
    if u0 is not None and u1 is not None and len(u1) >= len(u0):
        nu = u1[len(u0):]
    st = reply_stats(new_marks(before, after), npc_items(nu, fu, pu), ovh)
    st["ttfa"] = ttfa
    st["tok"] = tokens_in(tail.read()) if tail is not None else None
    nn = npc_items(nu, fu, pu)
    st["utt_keys"] = sorted(nn[0].keys()) if nn and isinstance(nn[0], dict) else None
    st["opens_action"] = None
    if nn:
        for k in _UTT_TEXT_KEYS:
            if isinstance(nn[0], dict) and isinstance(nn[0].get(k), str):
                st["opens_action"] = nn[0][k].lstrip().startswith("*")
                break
    return st


def calibrate(r, fu, pu):
    """Overhead spaces of the compact form: one forced 12-word line without asterisks (no LLM call)."""
    before = marks(r, fu)
    if before is None:
        return None
    words = [nonce("c")] + ["alpha", "bravo", "charlie", "delta", "echo", "foxtrot", "golf", "hotel", "india", "juliet",
                            "kilo"]
    if not force_line(r, fu, " ".join(words), pu):
        return None
    time.sleep(3)
    after = marks(r, fu)
    if after is None:
        return None
    new = new_marks(before, after)
    if len(new) != 1:
        inc(r, "calibration line produced %d new history events (wanted 1): the length route cannot be trusted" % len(new))
        return None
    return max(0, new[0]["spaces"] - (CAL_WORDS - 1))


def scene_live(r, fu, pu, partner_fid):
    """Self-check that scene mode is on and the 0020 scene tier renders for the partner."""
    ok = su_get(r, pu, "IEB_SceneMode", fid=PLAYER) == 1 and su_get(r, fu, "IEB_IsScenePartner", 0, fid=partner_fid) == 1
    head = render(r, fu, '{{ render_subcomponent("system_head", "full") }}{# %d #}' % time.time_ns())
    return ok and head is not None and "Scene: speak" in head


@contextlib.contextmanager
def sess(r, scene=False, npc=F1, calib=True):
    """Common setup. Yields dict(fu, pu, ovh) or None (INCONCLUSIVE already recorded). The test calls checkpoint(r) first
    thing inside the with. Undo in finally: SceneOff + witness flag back on if the scene was started, partner back
    beside the player, pacing back to normal."""
    if not market(r):                                   # RV-123 (3): market() reads the player's spot back
        yield None
        return
    scene_started = False
    placed = False
    pace = False
    try:
        if not harness_ready(r):
            yield None
            return
        fu, pu = uuids(r, npc, PLAYER)
        if not (fu and pu):
            inc(r, "partner %08X or the player has no uuid (not loaded)" % npc)
            yield None
            return
        ok = place(r, npc, 150, 0, 0)                   # RV-123 (3): place() reads the distance back
        placed = True
        if not ok:
            yield None
            return
        time.sleep(2)
        if los(r, fu, pu) is not True:
            inc(r, "partner is not near and in view of the player")
            yield None
            return
        try:
            SH.pacing(True)
            pace = True
        except SH.HarnessError as e:
            inc(r, "pacing bypass refused: %s" % e)
            yield None
            return
        if scene:
            con(r, "set IEB_WitnessEnabled to 0")
            scene_started = True
            if not ctl_line(r, "SceneOn", [npc], r"\[IEB-TEST\] SCENE on partner="):
                inc(r, "SceneOn wrapper gave no line")
                yield None
                return
            if not scene_live(r, fu, pu, npc):
                inc(r, "scene mode not live (flags or the 0020 scene tier missing)")
                yield None
                return
        else:
            if su_get(r, pu, "IEB_SceneMode", fid=PLAYER) not in (0, -99):
                inc(r, "scene mode is on at start")
                yield None
                return
        ovh = 0
        if calib:
            ovh = calibrate(r, fu, pu)
            if ovh is None:
                inc(r, "calibration failed")
                yield None
                return
        r.log("  overhead spaces per event (calibrated): %d" % ovh)
        yield dict(fu=fu, pu=pu, ovh=ovh, npc=npc)
    finally:
        if scene_started:
            ctl_line(r, "SceneOff", [], r"\[IEB-TEST\] SCENE off")
            con(r, "set IEB_WitnessEnabled to 1")
        if placed:
            bring_back(r, npc, readback=False)
        if pace:
            try:
                SH.pacing(False)
            except SH.HarnessError:
                pass


def run_lines(r, s, lines, keys=(), tail_path=None):
    out = []
    for ln in lines:
        tl = game.Tail(tail_path) if tail_path else None
        st = ask(r, s["fu"], s["pu"], ln, s["ovh"], keys=keys, tail=tl)
        if st is None:
            return out
        out.append(st)
        r.log("  reply: events=%d words=%d asterisks=%d spoken=%s action=%s%s" % (
            st["n"], st["total"], st["stars"], st["spoken"], st["action"],
            (" ttfa=%.2fs" % st["ttfa"]) if st["ttfa"] is not None else ""))
    if out and out[0].get("utt_keys"):
        r.log("  utterance fields (names only): %s" % out[0]["utt_keys"])
    return out


def measured(r, res):
    ok = [x for x in res if x["n"] > 0]
    if not ok:
        inc(r, "zero replies measured (no new NPC event in the history after %d line(s))" % len(res))
    return ok


# ---------------------------------------------------------------------------- LEN

@test("LEN-1", "LEN", reload=True)
def len1(r):
    """Scene mode off, 3 casual lines to F1: each reply <= about 60 words (history word count; > 75 = FAIL, 60-75 logged;
    75 = 60 + 25 % is INFERRED for 'about'). LLM calls: 3 (+ 0 calibration). Zero replies measured = INCONCLUSIVE."""
    with sess(r) as s:
        if s is None:
            return
        checkpoint(r)
        ok = measured(r, run_lines(r, s, CASUAL_LINES))
        for i, x in enumerate(ok):
            r.check(x["total"] <= WORDS_CASUAL_SOFT, "reply %d: %d words (<= %d; spec 60)" % (i + 1, x["total"], WORDS_CASUAL_SOFT))
        if ok and any(WORDS_CASUAL_MAX < x["total"] <= WORDS_CASUAL_SOFT for x in ok):
            r.log("  NOTE a reply is between 60 and 75 words (inside the INFERRED slack)")


@test("LEN-2", "LEN", reload=True)
def len2(r):
    """Scene mode on (SceneOn wrapper, F1 partner, nobody else near), 3 lines: spoken <= 60 words, action text <= 200
    words (ceiling), total <= 275 (spec 'about 260', INFERRED slack). Spoken/action come from utterances() (route B,
    INFERRED text field); without them only the total is checked and the test is INCONCLUSIVE. Records how many
    replies carry action text (asterisks >= 2); no check, the spec says only that they may all do. Private scene:
    nobody else is placed near (the privacy flag itself is not asserted). LLM calls: 3."""
    with sess(r, scene=True) as s:
        if s is None:
            return
        checkpoint(r)
        ok = measured(r, run_lines(r, s, SCENE_LINES))
        for i, x in enumerate(ok):
            r.check(x["total"] <= WORDS_SCENE_TOTAL, "reply %d: total %d words (<= %d)" % (i + 1, x["total"], WORDS_SCENE_TOTAL))
            if x["spoken"] is not None:
                r.check(x["spoken"] <= WORDS_SPOKEN_MAX, "reply %d: spoken %d words (<= 60)" % (i + 1, x["spoken"]))
                r.check(x["action"] <= WORDS_ACTION_MAX, "reply %d: action %d words (<= 200)" % (i + 1, x["action"]))
        if ok and any(x["spoken"] is None for x in ok):
            inc(r, "spoken/action split unavailable (utterances() gave no usable text field): totals checked only")
        r.log("  replies with action text (asterisk pairs): %d of %d" % (sum(1 for x in ok if x["stars"] >= 2), len(ok)))


@test("LEN-3", "LEN", reload=True)
def len3(r):
    """Scene mode on (wrapper), then a bystander (A_NPC) is made hostile (console startcombat, INFERRED to put the player
    in combat). Waits <= 30 s for the SceneMain tick's '[IEB-SC] SCENE_OFF (combat)' (IEB_SceneMain.psc:185-187, 309);
    no line = INCONCLUSIVE (combat never reached the player). Then flag IEB_SceneMode = 0 and the partner flag cleared,
    and 3 combat lines to F1: each reply <= 14 words (17 = +20 % INFERRED slack; > 14 logged). Undo: stopcombat on the
    attacker, scene off, attacker back. LLM calls: 3."""
    with sess(r, scene=True) as s:
        if s is None:
            return
        au, = uuids(r, A_NPC)
        if not au:
            return inc(r, "attacker not loaded")
        checkpoint(r)
        t = game.Tail(game.LOGS["papyrus"])
        try:
            if not place(r, A_NPC, 400, 0, 0):                         # RV-123 (3): place() reads back
                return
            con(r, "%s.startcombat player" % hx(A_NPC))
            time.sleep(2)
            cb = ctl_line(r, "CombatProbe", [A_NPC], r"\[IEB-TEST\] CombatProbe .*? combat=(\d)", 10)
            if not cb or cb.group(1) != "1":                            # RV-123 (3): startcombat read back
                return inc(r, "startcombat read-back: attacker combat=%s" % (cb.group(1) if cb else "no CombatProbe line"))
            m = t.wait(r"\[IEB-SC\] SCENE_OFF \(combat\)", 30, poll=1.0)
            if not m:
                return inc(r, "no SCENE_OFF (combat) within 30 s (player not in combat, or the tick did not run)")
            r.check(su_get(r, s["pu"], "IEB_SceneMode", fid=PLAYER) == 0, "scene flag cleared (IEB_SceneMode = 0)")
            r.check(su_get(r, s["fu"], "IEB_IsScenePartner", 0, fid=F1) == 0, "partner flag cleared")
            ok = measured(r, run_lines(r, s, COMBAT_LINES))
            for i, x in enumerate(ok):
                r.check(x["total"] <= WORDS_COMBAT_SOFT, "combat reply %d: %d words (<= %d; spec 14)" % (i + 1, x["total"], WORDS_COMBAT_SOFT))
            if any(x["total"] > WORDS_COMBAT_MAX for x in ok):
                r.log("  NOTE a combat reply exceeds 14 words (inside the INFERRED slack if <= 17)")
        finally:
            con(r, "%s.stopcombat" % hx(A_NPC))
            con(r, "%s.stopcombatalarm" % hx(A_NPC))
            bring_back(r, A_NPC, readback=False)


@test("LEN-4", "LEN", reload=True)
def len4(r):
    """Scene mode on (wrapper), save (game.save, name IEB_LEN4, left on disk), load it. After the load: IEB_SceneMode = 0,
    the partner flag cleared, and '[IEB-SC] SCENE_OFF (auto_load)' seen (IEB_SceneMain.Startup -> EndScene("auto_load"),
    :74-84; the line needs the wrapper's keys to survive in the co-save, INFERRED, so a missing line with the flags
    cleared is only INCONCLUSIVE). The whisper re-evaluation half is WH-2's. A failed save = INCONCLUSIVE (never load an
    incomplete save). LLM calls: 0."""
    with sess(r, scene=True, calib=False) as s:
        if s is None:
            return
        checkpoint(r)
        if not game.save(r, "IEB_LEN4"):
            return inc(r, "save IEB_LEN4 did not complete; not loading it")
        t = game.Tail(game.LOGS["papyrus"])
        if not game.load(r, "IEB_LEN4", settle_probe(r)):
            return r.check(False, "load IEB_LEN4 failed")
        m = t.wait(r"\[IEB-SC\] SCENE_OFF \(auto_load\)", 20, poll=1.0)
        fu, pu = uuids(r, F1, PLAYER)
        mode = su_get(r, pu, "IEB_SceneMode", fid=PLAYER)
        part = su_get(r, fu, "IEB_IsScenePartner", 0, fid=F1)
        r.check(mode == 0, "IEB_SceneMode = 0 after the load (%s)" % mode)
        r.check(part == 0, "partner flag cleared after the load (%s)" % part)
        if not m:
            inc(r, "no SCENE_OFF (auto_load) line (the flags may simply not have survived the save; WH-2 covers whisper)")


@test("LEN-5", "LEN", reload=True)
def len5(r):
    """Interrupt a long scene reply. Control: one uninterrupted scene reply (words W0). Then a second line; as soon as its
    first utterance appears (utterances() count rises, INFERRED = speech started) +1.5 s, a third player line interrupts
    (INFERRED to cut the speech). The stored history of the interrupted reply must be shorter than W0 (only meaningful
    when W0 >= 40, else INCONCLUSIVE) and the interruption must have happened before the reply was fully spoken
    (speech started and a new event followed). Records, as counts only, whether action text (asterisks) survived in the
    stored event: the spec's open question 'how is unvoiced action text treated' is answered by that log line, read by
    Shae. LLM calls: 3 (control, interrupted, interrupter)."""
    with sess(r, scene=True) as s:
        if s is None:
            return
        checkpoint(r)
        ctl = measured(r, run_lines(r, s, [LONG_ACTION_LINE]))
        if not ctl:
            return
        w0 = ctl[0]["total"]
        fu, pu = s["fu"], s["pu"]
        before = marks(r, fu)
        u0 = utt_items()
        if before is None or u0 is None:
            return inc(r, "markers or utterances unavailable")
        t0 = time.time()
        try:
            SH.inject_player_input(LONG_ACTION_LINE, fu)
            started = False
            while time.time() - t0 < 60:
                cur = utt_items()
                if cur is not None and len(cur) > len(u0) and npc_items(cur[len(u0):], fu, pu):
                    started = True
                    break
                time.sleep(0.25)
            if not started:
                return inc(r, "the reply never started speaking within 60 s")
            time.sleep(1.5)
            SH.inject_player_input("Wait, stop. Hold on a moment.", fu)
            SH.await_idle(90)
        except SH.HarnessError as e:
            return inc(r, "harness call failed: %s" % e)
        time.sleep(2)
        after = marks(r, fu)
        if after is None:
            return inc(r, "marker render failed")
        new = [m for m in new_marks(before, after) if "thought" not in m["typ"].lower()]
        if len(new) < 2:
            return inc(r, "fewer than 2 new NPC events (%d): the interrupted reply or the follow-up is not in history" % len(new))
        first = new[0]
        w1 = max(0, first["spaces"] + 1 - s["ovh"])
        r.log("  control reply %d words; interrupted reply stored %d words, asterisks in it %d" % (w0, w1, first["stars"]))
        if w0 < 40:
            return inc(r, "control reply too short (%d words) to show a shortening" % w0)
        r.check(w1 < w0, "stored interrupted reply (%d words) is shorter than the uninterrupted one (%d)" % (w1, w0))
        r.log("  RECORD action text kept in the interrupted event: %s (Shae reads this for the spec note)" % (first["stars"] >= 2))


@test("LEN-6", "LEN", reload=True)
def len6(r):
    """Stub for the Shae-eyes test (S-C): one scene reply asked to be a long action; measures the action text length only
    (words, route A/B) and records that it exceeds 0 (else INCONCLUSIVE: nothing to read). The on-screen subtitle time
    and the chat panel are judged by Shae: ends with an inc(). LLM calls: 1."""
    with sess(r, scene=True) as s:
        if s is None:
            return
        checkpoint(r)
        ok = measured(r, run_lines(r, s, [LONG_ACTION_LINE]))
        if not ok:
            return
        x = ok[0]
        act = x["action"] if x["action"] is not None else None
        r.log("  action text: %s words (spec ceiling 200), asterisks %d" % (act, x["stars"]))
        if x["stars"] < 2 and not act:
            return inc(r, "the reply carried no action text; nothing for Shae to read")
        if act is not None:
            r.check(act <= WORDS_ACTION_MAX, "action text %d words (<= 200)" % act)
        inc(r, "readability is Shae's check (S-C)")


def _pair(r, cp):
    """Casual vs scene, 3 replies each, same NPC: words, time to first audio, output tokens. Cached for LEN-7 / LEN-8.
    LLM calls: 6 for the first caller, 0 for the second. Returns dict or None (INCONCLUSIVE recorded)."""
    if _PAIR.get("done"):
        return _PAIR["done"]
    path = out_log_path()
    out = {"casual": [], "scene": [], "log": path}
    for cond in ("casual", "scene"):
        with sess(r, scene=(cond == "scene")) as s:
            if s is None:
                return None
            if cond == "casual":
                cp()
            out[cond] = run_lines(r, s, CASUAL_LINES if cond == "casual" else SCENE_LINES, tail_path=path)
    _PAIR["done"] = out
    return out


@test("LEN-7", "LEN", reload=True)
def len7(r):
    """Time to first audio, scene vs casual, same NPC (F1). Proxy (INFERRED): seconds from the injected line until a NEW
    utterance appears in utterances() (polled every 0.25 s); the harness has no first-audio timestamp, only
    await speech-done (the END of speech). Replies that open with action text (first utterance text starts with '*';
    unknown if no text field) are excluded: the spec's claim is for replies that open with speech. Medians of the
    kept samples must be within 1.0 s (+0.25 s granularity) of each other; < 2 kept samples per condition =
    INCONCLUSIVE. LLM calls: 6 (shared with LEN-8 when both run in one process)."""
    p = _pair(r, lambda: checkpoint(r))
    if p is None:
        return
    med = {}
    for cond in ("casual", "scene"):
        kept = [x["ttfa"] for x in p[cond] if x["ttfa"] is not None and not x["opens_action"]]
        r.log("  %s: %d replies, %d with a first-audio time that open with speech: %s" % (
            cond, len(p[cond]), len(kept), ["%.2f" % k for k in kept]))
        if len(kept) < 2:
            return inc(r, "%s: fewer than 2 usable first-audio samples" % cond)
        med[cond] = statistics.median(kept)
    d = abs(med["scene"] - med["casual"])
    r.check(d <= TTFA_TOL_S, "median time to first audio: casual %.2f s, scene %.2f s, difference %.2f s (<= %.2f)" % (
        med["casual"], med["scene"], d, TTFA_TOL_S))


@test("LEN-8", "LEN", reload=True)
def len8(r):
    """Output tokens per reply, scene vs casual (3 each). Source: completion/output token counts in the OpenRouter log
    window of each reply (max of the window, INFERRED). Only openrouter_input.log is known on disk; the output log's name
    is INFERRED (out_log_path() looks for it). If none is found, tokens are ESTIMATED as 1.33 x history words (INFERRED)
    and the test is INCONCLUSIVE. The spec has no pass line (it expects about +160 tokens in scene): this records the
    means and the delta, and checks only that every reply was measured. LLM calls: 6 (shared with LEN-7)."""
    p = _pair(r, lambda: checkpoint(r))
    if p is None:
        return
    if not p["casual"] or not p["scene"] or any(x["n"] == 0 for x in p["casual"] + p["scene"]):
        return inc(r, "zero or partial replies measured")
    mean = {}
    for cond in ("casual", "scene"):
        toks = [x["tok"][0] for x in p[cond] if x["tok"]]
        words = [x["total"] for x in p[cond]]
        r.log("  %s: tokens per reply %s; history words %s" % (cond, toks, words))
        if len(toks) != len(p[cond]):
            r.log("  %s: ESTIMATE from words x 1.33 = %.0f tokens (no output-token log)" % (cond, 1.33 * statistics.mean(words)))
            mean = None
            continue
        if mean is not None:
            mean[cond] = statistics.mean(toks)
    if not mean:
        return inc(r, "no output-token log found (out log: %s)" % (p["log"] and os.path.basename(p["log"])))
    r.check(True, "token counts for all 6 replies")
    r.log("  RECORD mean output tokens: casual %.0f, scene %.0f, delta %.0f (spec estimate about +160)" % (
        mean["casual"], mean["scene"], mean["scene"] - mean["casual"]))


# ---------------------------------------------------------------------------- SEC

def _sec_ready(r, s):
    """The test layer's bio carries the invented token(s) and the discretion rule renders. Else INCONCLUSIVE (the private
    layer shae.discretion / the test bio are not installed). 0 LLM calls."""
    flags = render(r, s["fu"], "".join('{%% if contains(lower(render_subcomponent("character_bio", "full")), "%s") %%}1{%% else %%}0{%% endif %%}' % k
                                       for k in SEC_KEYS) + "{# %d #}" % time.time_ns())
    if flags is None or "1" not in flags:
        inc(r, "the test bio token(s) are not in the NPC's bio (private test layer not installed or not rescanned)")
        return False
    dr = render(r, s["fu"], template="dialogue_response", target=s["pu"])
    if dr is None or "## Discretion" not in dr:
        inc(r, "'## Discretion' not in the NPC's dialogue_response (layer shae.discretion missing)")
        return False
    return True


def _leaks(res):
    """Key hits per reply: (spoken events, thought events)."""
    out = []
    for x in res:
        sp = sum(sum(m["keys"]) for m in x["rep"])
        th = sum(sum(m["keys"]) for m in x["thoughts"])
        out.append((sp, th))
    return out


@test("SEC-1", "SEC", reload=True)
def sec1(r):
    """Needs a PRIVATE test layer (not built here): a bio for SEC_NPC (Fralia, minor NPC) with an invented harmless private
    matter that contains the invented tokens SEC_KEYS (INFERRED convention) in its private block, plus the 0705
    discretion rule. Three stages, one line each: (1) stranger asks 'any secrets?'; (2) after
    'setrelationshiprank player 2' + a persuasion line; (3) a threat with 'proof'. Counts only invented-token hits in
    the new events (case-insensitive contains in the template). Checks: stage 1 has 0 hits (a hit = leak to a
    stranger = FAIL); stage 3 >= 1 hit, else INCONCLUSIVE (a reveal may be paraphrased, Shae reads it). Stage 2 is
    recorded. The quality of 'deflection / partial reveal / reveal' is Shae's reading (not automatable). LLM calls: 3."""
    with sess(r, npc=SEC_NPC) as s:
        if s is None:
            return
        if not _sec_ready(r, s):
            return
        checkpoint(r)
        h = []
        try:
            for stage, line, pre in ((1, SEC_ASK, None), (2, SEC_PERSUADE, "%s.setrelationshiprank player 2" % hx(SEC_NPC)),
                                     (3, SEC_THREAT, None)):
                if pre:
                    con(r, pre)
                    rk = iv(rank(r, SEC_NPC) or {}, "r")                # RV-123 (3): RankProbe r= after the console write
                    if rk != 2:
                        return inc(r, "stage %d: setrelationshiprank read-back r=%s, wanted 2" % (stage, rk))
                res = run_lines(r, s, [line], keys=SEC_KEYS)
                if not measured(r, res):
                    return
                h.append(_leaks(res)[0][0])
        finally:
            con(r, "%s.setrelationshiprank player 0" % hx(SEC_NPC))
        r.log("  invented-token hits per stage (counts only): %s" % h)
        r.check(h[0] == 0, "stage 1 (stranger): no private-matter token in the reply (%d)" % h[0])
        if h[2] == 0:
            inc(r, "stage 3 produced no token (a paraphrased reveal or a refusal: Shae reads it)")
        else:
            r.check(True, "stage 3 (threat with proof): private matter surfaces (%d)" % h[2])
        inc(r, "deflection / partial / full quality is Shae's reading")


@test("SEC-2", "SEC", reload=True)
def sec2(r):
    """Same NPC, 3 ordinary questions (directions, local history, lore): each reply has >= 8 words (INFERRED threshold
    for a 'full answer') and leaks no private token. 'No new reticence' compared with the layer off is not automated
    (Shae reads, S). LLM calls: 3."""
    with sess(r, npc=SEC_NPC) as s:
        if s is None:
            return
        if not _sec_ready(r, s):
            return
        checkpoint(r)
        ok = measured(r, run_lines(r, s, SEC_FACTS, keys=SEC_KEYS))
        for i, x in enumerate(ok):
            r.check(x["total"] >= 8, "answer %d has %d words (>= 8)" % (i + 1, x["total"]))
            r.check(sum(sum(m["keys"]) for m in x["rep"]) == 0, "answer %d leaks no private token" % (i + 1))
        if ok:
            inc(r, "'no new reticence' wording is Shae's reading")


@test("SEC-3", "SEC", reload=True)
def sec3(r):
    """Prompt render check, no LLM call: '## Discretion' is in dialogue_response for an NPC->player render and an NPC->NPC
    render (B_NPC target), absent from player_dialogue (actor = player) and npc_thoughts (INFERRED template names).
    A missing rule in dialogue_response or a template that fails to render = INCONCLUSIVE (absence elsewhere would be
    vacuous). Text is searched in memory only."""
    if not market(r):
        return
    if not harness_ready(r):
        return
    fu, bu, pu = uuids(r, SEC_NPC, B_NPC, PLAYER)
    if not (fu and bu and pu):
        return inc(r, "actors not loaded")
    checkpoint(r)
    npc_pl = render(r, fu, template="dialogue_response", target=pu)
    npc_npc = render(r, fu, template="dialogue_response", target=bu)
    plr = render(r, pu, template="player_dialogue", target=fu)
    tho = render(r, fu, template="npc_thoughts")
    if npc_pl is None or "## Discretion" not in npc_pl:
        return inc(r, "rule absent from dialogue_response (layer shae.discretion not installed / template name)")
    r.check(npc_npc is not None and "## Discretion" in npc_npc, "NPC->NPC dialogue_response carries '## Discretion'")
    for name, out in (("player_dialogue", plr), ("npc_thoughts", tho)):
        if not out:
            inc(r, "%s did not render (template name INFERRED)" % name)
        else:
            r.check("## Discretion" not in out, "%s does not carry '## Discretion'" % name)


@test("SEC-4", "SEC", reload=True)
def sec4(r):
    """Inline thoughts on (precondition: dialogue_response contains 'internal_thought', INFERRED marker; the setting is not
    switched here): one 'any secrets?' line. The spoken events must hold no private token (FAIL otherwise); tokens in
    thought-type events (type contains 'thought', INFERRED) are only recorded ('may appear'). No thought event stored =
    INCONCLUSIVE for the thought half. LLM calls: 1."""
    with sess(r, npc=SEC_NPC) as s:
        if s is None:
            return
        if not _sec_ready(r, s):
            return
        dr = render(r, s["fu"], template="dialogue_response", target=s["pu"])
        if dr is None or "internal_thought" not in dr:
            return inc(r, "inline thoughts do not look enabled ('internal_thought' absent from dialogue_response)")
        checkpoint(r)
        ok = measured(r, run_lines(r, s, [SEC_ASK], keys=SEC_KEYS))
        if not ok:
            return
        sp, th = _leaks(ok)[0]
        r.check(sp == 0, "spoken line holds no private token (%d)" % sp)
        if not ok[0]["thoughts"]:
            inc(r, "no thought event stored; the thought half cannot be shown")
        else:
            r.log("  RECORD private-token hits in thought events: %d" % th)
