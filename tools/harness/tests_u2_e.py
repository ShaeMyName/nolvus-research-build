"""U2 block, part 2: in-line actions (E, R3 s5_emote_text.md §8 / spec §11.5) and reaction counts (RE).
Started 2026-10-11. House style and helpers: tests_u2.py (counts only; a nonce in every forced line; LOS self-checked).
Text is processed in Python only to compute booleans/counts; nothing of it is logged.

Not automated here (and why):
- E-1: needs subtitlesOnly OFF (config edit with the game closed) -> U3 restart group.
- E-6: overlay + interrupt hotkey mid-line -> S (Shae) or a later harness 'purge' variant.
- E-9: N/A by design (Piper narrator kept). E-10: N/A (time plan §3.4).
- RE-1, RE-4, RE-6: stance variety needs a judgement of reply text -> JUDGE stub (counts only) + INCONCLUSIVE.
- RE-2: silenceChancePercent 50 vs 80 needs a config change with the game closed -> U3. NOTE: the test config has
  silenceChancePercent 50, the spec §11.5 setting is 75 (config drift, reported to the reviewer).
- RE-5: soak (R7)."""
import re, time
import game
import sn_harness as SH
from block import test, checkpoint
from tests_misc import PLAYER, F1, F2, con, ctl_line, inc, who
from tests_u2 import (A_NPC, B_NPC, C_NPC, nonce, hist_hits, los, place, bring_back, market, uuids, harness_ready,
                      force_line, _w_scene)


def _utterance_for(uid):
    """The harness utterance record for an utterance id (dict) or None. Fields used by name only."""
    try:
        res = SH.utterances()
    except SH.HarnessError:
        return None
    rows = res.get("utterances", []) if isinstance(res, dict) else []
    for u in rows:
        if isinstance(u, dict) and str(u.get("utterance_id", u.get("id", ""))) == str(uid):
            return u
    return None


@test("E-2", "E", reload=True)
def e2(r):
    """subtitlesOnly on: a forced F1 line '*<action>* <spoken>' -> the action part is not voiced. Checked on the harness
    utterance record: the played/voiced text (field names INFERRED: played_text*, text) lacks the action token while
    the spoken token is present. Booleans only. 0 LLM calls (forced line)."""
    market(r)
    if not harness_ready(r):
        return
    fu, pu = uuids(r, F1, PLAYER)
    if not fu:
        return inc(r, "F1 not loaded")
    checkpoint(r)
    act, say = nonce("act"), nonce("say")
    try:
        res = SH.speak(fu, "*%s* %s" % (act, say), "npc", pu)
        SH.await_idle(60)
    except SH.HarnessError as e:
        return inc(r, "harness speak failed: %s" % e)
    uid = res.get("utterance_id") if isinstance(res, dict) else None
    u = _utterance_for(uid) if uid else None
    if not u:
        return inc(r, "no utterance record for the forced line (id %s; fields INFERRED)" % uid)
    voiced = " ".join(str(v) for k, v in u.items() if "played" in k or k in ("tts_text", "spoken_text"))
    r.log("  utterance fields: %s" % sorted(u.keys()))
    if not voiced:
        return inc(r, "utterance record has no played/voiced text field (fields INFERRED)")
    r.check(say in voiced, "the spoken part was voiced")
    r.check(act not in voiced, "the asterisk action part was NOT voiced (subtitlesOnly)")
    r.check((hist_hits(r, fu, act) or 0) >= 1, "the action part is kept in history (shown, not spoken)")


@test("E-4", "E", reload=True)
def e4(r):
    """Hug text from F1 with B at 300 u in view, C at ~500 u without LOS, D at 1000 u: only B gets it.
    (Same machinery as W-1/W-2; A_NPC plays B, B_NPC plays C, C_NPC plays D.) 0 LLM calls."""
    h = _w_scene(r, "E-4", a_off=(300, 0, 0), b_off=(300, 0, -400), c_off=(1000, 0, 0))
    if h is None:
        return
    if not h.get("A"):
        return inc(r, "control (300 u, in view) did not get the line")
    r.check(h.get("B") == 0, "no line of sight: not included (%s)" % h.get("B"))
    r.check(h.get("C") == 0, "1000 u: not included (%s)" % h.get("C"))


@test("E-5", "E", reload=True)
def e5(r):
    """Whisper hotkey vs the chat '^' modifier, audience of the NPC REPLY: player whispers to F1 with A at 300 u.
    Hotkey (TestCtl.Whisper 1): A gets neither line. '^' prefix without the hotkey: A gets F1's reply (expected,
    INFERRED: '^' covers only the player's own message). 2 LLM calls."""
    market(r)
    if not harness_ready(r):
        return
    fu, au, pu = uuids(r, F1, A_NPC, PLAYER)
    if not (fu and au):
        return inc(r, "actors not loaded")
    try:
        place(r, A_NPC, 300, 0, 0)
        time.sleep(2)
        if not los(r, au, pu):
            return inc(r, "A placed without line of sight")
        checkpoint(r)
        res = {}
        for mode in ("hotkey", "caret"):
            tok = nonce("e5")
            f0 = hist_hits(r, fu, etype="dialogue")
            a0 = hist_hits(r, au, etype="dialogue")
            if mode == "hotkey":
                ctl_line(r, "Whisper", [1], r"\[IEB-TEST\] WHISPERSET")
                SH.inject_player_input("Quietly, %s: stay close." % tok, fu)
            else:
                ctl_line(r, "Whisper", [0], r"\[IEB-TEST\] WHISPERSET")
                SH.inject_player_input("^Quietly, %s: stay close." % tok, fu)
            SH.await_idle(90)
            time.sleep(3)
            res[mode] = dict(player_line_A=hist_hits(r, au, tok), f1_new=(hist_hits(r, fu, etype="dialogue") or 0) - (f0 or 0),
                             a_new=(hist_hits(r, au, etype="dialogue") or 0) - (a0 or 0))
        r.log("  E-5 counts: %s" % res)
        hk, ca = res["hotkey"], res["caret"]
        r.check(hk["player_line_A"] == 0, "hotkey: A does not get the player's whispered line")
        if hk["f1_new"] < 2:
            inc(r, "hotkey: F1's reply not seen in her history (cannot judge the reply audience)")
        else:
            r.check(hk["a_new"] == 0, "hotkey: A gets no dialogue rows (player line + F1 reply) (%d)" % hk["a_new"])
        r.log("  caret: A got the player line %s, A dialogue rows +%d (recorded; '^' scope is INFERRED)" %
              (ca["player_line_A"], ca["a_new"]))
    except SH.HarnessError as e:
        inc(r, "harness call failed: %s" % e)
    finally:
        ctl_line(r, "Whisper", [0], r"\[IEB-TEST\] WHISPERSET")
        bring_back(r, A_NPC)


@test("E-7", "E", reload=True)
def e7(r):
    """The player types '*I hug her*' in Say mode (harness inject): a bystander at 300 u in view has the line in history
    (the player's own asterisk text follows the same audience). Player-TTS of the asterisk part is S (Shae's ear).
    1 LLM call (F1's reply)."""
    market(r)
    if not harness_ready(r):
        return
    fu, au, pu = uuids(r, F1, A_NPC, PLAYER)
    if not (fu and au):
        return inc(r, "actors not loaded")
    try:
        place(r, A_NPC, 300, 0, 0)
        time.sleep(2)
        if not los(r, au, pu):
            return inc(r, "A placed without line of sight")
        checkpoint(r)
        tok = nonce("e7")
        SH.inject_player_input("*I hug her* %s" % tok, fu)
        SH.await_idle(90)
        time.sleep(3)
        r.check((hist_hits(r, au, tok) or 0) >= 1, "bystander history has the player's asterisk line")
        r.check((hist_hits(r, fu, tok) or 0) >= 1, "the target's history has it")
    except SH.HarnessError as e:
        inc(r, "harness inject failed: %s" % e)
    finally:
        bring_back(r, A_NPC)


@test("E-8", "E", reload=True)
def e8(r):
    """'!' vs '#' prefixes with the same text to F1 (INFERRED SkyrimNet chat semantics: '!' forces one reply, '#' none):
    count F1 dialogue rows added and whether the text persists in history. Up to 1 LLM call."""
    market(r)
    if not harness_ready(r):
        return
    fu, = uuids(r, F1)
    if not fu:
        return inc(r, "F1 not loaded")
    checkpoint(r)
    out = {}
    try:
        for pre in ("!", "#"):
            tok = nonce("e8")
            d0 = hist_hits(r, fu, etype="dialogue") or 0
            SH.inject_player_input("%sThe road was long today %s." % (pre, tok), fu)
            SH.await_idle(90)
            time.sleep(3)
            out[pre] = dict(rows=(hist_hits(r, fu, etype="dialogue") or 0) - d0, kept=hist_hits(r, fu, tok))
    except SH.HarnessError as e:
        return inc(r, "harness inject failed: %s" % e)
    r.log("  E-8 counts: %s" % out)
    r.check(out["!"]["rows"] >= 1, "'!': at least one new dialogue row (a forced reply)")
    r.check(out["#"]["rows"] <= out["!"]["rows"], "'#': no more replies than '!'")


@test("RE-3", "RE", reload=True)
def re3(r):
    """Only one bystander in range (F1 with the player in an empty interior, Breezehome; INFERRED nobody else there at T0,
    self-checked by QScan within 800 u): five unsolicited
    player lines (no target) -> how many does F1 answer? Records the count; FAIL only if she answers all 5 with the
    spec's 75% silence. 5 LLM calls at most."""
    if not harness_ready(r):
        return
    con(r, "coc WhiterunBreezehome")   # an interior nobody else is in at T0 (INFERRED; self-checked below by QScan)
    time.sleep(12)
    con(r, "%08X.moveto player" % F1)
    time.sleep(5)
    fu, = uuids(r, F1)
    if not fu:
        return inc(r, "F1 not loaded")
    m = ctl_line(r, "QScan", [800.0], r"\[IEB-TEST\] QSCAN END n=(\d+)", 60)
    if not m or int(m.group(1)) > 1:
        return inc(r, "more than one NPC within 800 u (QScan n=%s)" % (m.group(1) if m else "?"))
    checkpoint(r)
    d0 = hist_hits(r, fu, etype="dialogue") or 0
    try:
        for i in range(5):
            SH.inject_player_input("%s" % ["Quiet out here.", "The wind is up.", "Long road ahead.",
                                           "Clouds over the mountain.", "Smells like rain."][i])
            SH.await_idle(90)
            time.sleep(2)
    except SH.HarnessError as e:
        return inc(r, "harness inject failed: %s" % e)
    replies = (hist_hits(r, fu, etype="dialogue") or 0) - d0 - 5
    r.log("  RE-3: F1 answered %d of 5 unsolicited lines (single eligible speaker)" % replies)
    r.check(replies < 5, "the single bystander does not answer every line (%d/5)" % replies)
