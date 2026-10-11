"""U3 block, part 3 (GameMaster ON, its own sub-block U3G): X-9 / X-10 with and without our layer file 0210, and RE-2
(silenceChancePercent 50 -> 80 -> 50). Spec rows BRIDGE_SPEC_V2.md X-9/X-10 :1891-1892, spec :1782 (RE-2),
investigation/round3/s5_emote_text.md §8 R-2 (= RE-2); time plan :215, :380; REVIEW_LOG RV-91 / RV-91-corr.
Written 2026-10-11, not yet run. Both need GameMaster on (block.GM_TESTS has X-9 and RE-2; DECISIONS:413 puts U3 at GM off,
so they cannot share the GM-off sub-blocks).

0210 swap (RV-91: allowed; our own file in our own mod "SkyrimNet - Scene Text"): with the game AND MO2 closed the file
is renamed to '<name>.u3off' (backup copy first), the game relaunched, the Content Library rescanned (MCP
reload_content: "Rescans the whole content library", SkyrimNet DLL strings :54061-54063, VERIFIED; its log line
"ReloadAllContent: rescanning the content tree..." :50384, VERIFIED as a string, INFERRED to be logged on this path);
then a render check proves the state: the count of 0210's own heading line (MARKER below) in a system_head render of an
NPC who sees the exposed player must be 0 without the file and >= 1 with it. Restore = rename back, sha256 asserted,
relaunch, rescan, render count >= 1 again. The file's text is never printed; only the marker count leaves the render.

RE-2's write (dialogue.speakerSelector.silenceChancePercent in the TEST SkyrimNet.yaml) is NOT approved yet (FOR_SHAE,
RV-91-corr): RE2_WRITE_APPROVED = False keeps the test a stub. The swap procedure below is modelled on
game.set_gamemaster (game closed, backup, write, assert, restore, assert, log)."""
import os, re, shutil, statistics, time
import game
import sn_harness as SH
from block import test, checkpoint
from tests_misc import PLAYER, F1, con, inc, render, tool_props, tail
from tests_u2 import A_NPC, B_NPC, C_NPC, market, uuids, place, bring_back, harness_ready, fire_exposure, dress, body_item
from tests_u3 import MODS, BACKUP_DIR, RestoreFailed, wait_closed, relaunch, back_to, sha, NAGuard

SCENE_TEXT_LAYER = MODS + "SkyrimNet - Scene Text/SKSE/Plugins/SkyrimNet/external/shae.scene-text/"
FILE_0210 = SCENE_TEXT_LAYER + "prompts/submodules/system_head/0210_ieb_visible_attire.prompt"
OFF_0210 = FILE_0210 + ".u3off"
MARKER = "## Visible Attire"     # 0210's own heading line (shae.scene-text 0210:10); no story text, never followed
                                 # by the rendered names in any log
X_LINES = ["What do you make of the market today?", "Anything worth buying around here?",
           "Should we head on soon, do you think?"]
X_WINDOW_S = 45                  # extra listening after each line (bystander reactions)
_X = {}                          # X-9 / X-10 share one run per 0210 state


# ---------------------------------------------------------------------------- helpers
def rescan(r):
    """MCP reload_content (rescans the whole content library). (ok, why). Parameter name taken from tools/list; every
    accepted value reloads everything (DLL string :54063), so 'all' is passed when the tool has one parameter."""
    t = tail("skyrimnet")
    props = sorted(tool_props(r, "reload_content"))
    args = {props[0]: "all"} if len(props) == 1 else {}
    res = r.tool("reload_content", args)
    if isinstance(res, dict) and res.get("error"):
        return False, "reload_content error: %s" % str(res.get("error"))[:120]
    m = t.wait(r"ReloadAllContent: rescanning the content tree", 45)
    time.sleep(5)
    return bool(m), "reload_content sent (params %s); rescan line %s" % (props, "seen" if m else "NOT seen")


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


_SPEAKER_KEYS = ("speaker_uuid", "speakerUuid", "speakerUUID", "speaker", "actor_uuid", "actorUuid", "originator_uuid")


def _norm(v):
    return str(v).lower().replace("0x", "").replace("{", "").replace("}", "").strip()


def speaker_of(item):
    """(field name, normalised speaker uuid) of one utterance item; field names INFERRED (first match in _SPEAKER_KEYS)."""
    if not isinstance(item, dict):
        return None, None
    for k in _SPEAKER_KEYS:
        if k in item and isinstance(item[k], (str, int)) and re.fullmatch(r"[0-9a-f]{1,16}", _norm(item[k])):
            return k, _norm(item[k])        # an id, not a display name
    return None, None


def marker_count(r, speaker_uuid, target_uuid):
    """How many 0210 heading lines a system_head render of the speaker holds (the speaker must see the exposed player;
    the target is not the player, so 0210 lists the player). None if the render failed. The render is never logged."""
    out = render(r, speaker_uuid, '{{ render_subcomponent("system_head", "full") }}{# %d #}' % time.time_ns(),
                 target=target_uuid)
    if out is None:
        return None
    return sum(1 for line in out.splitlines() if line.strip() == MARKER)


def x_arm(r, label):
    """One 0210 state: market crowd (A, B, C at 300-500 u in view), the player's body item removed (one ieb_witness
    exposure, the 'exposure by console'), the marker render count, then 3 player lines to F1 (3 LLM calls):
    latency = seconds from inject to the first new non-player utterance (polled every 0.5 s); bystander lines = new
    utterances whose speaker is neither the player nor F1, over the 3 lines + X_WINDOW_S each. Dressed again after.
    Returns a dict of counts or None (INCONCLUSIVE logged)."""
    market(r)
    if not harness_ready(r):
        return None
    fu, au, bu, cu, pu = uuids(r, F1, A_NPC, B_NPC, C_NPC, PLAYER)
    if not (fu and au and pu):
        inc(r, "%s: F1, the first bystander or the player not loaded" % label)
        return None
    item = None
    placed = []
    try:
        for fid, off in ((A_NPC, (300, 0, 0)), (B_NPC, (0, 350, 0)), (C_NPC, (-400, 0, 0))):
            place(r, fid, *off)
            placed.append(fid)
        con(r, "%08X.moveto player" % F1)
        time.sleep(3)
        if not body_item(r, pu):
            inc(r, "%s: the player wears no body item to remove" % label)
            return None
        item, m = fire_exposure(r)
        if not item:
            inc(r, "%s: exposure did not happen" % label)
            return None
        time.sleep(3)
        mk = marker_count(r, au, fu)
        lat, by, items, fields = [], 0, 0, set()
        nf, np_ = fu.lower().replace("0x", ""), pu.lower().replace("0x", "")
        for line in X_LINES:
            u0 = utt_items() or []
            t0 = time.time()
            SH.inject_player_input(line, fu)
            first = None
            while time.time() - t0 < 60 and first is None:
                cur = utt_items() or []
                for it in cur[len(u0):]:
                    k, s = speaker_of(it)
                    if k is None or s != np_:
                        first = time.time() - t0
                        break
                time.sleep(0.5)
            try:
                SH.await_idle(90)
            except SH.HarnessError:
                pass
            time.sleep(X_WINDOW_S)
            cur = utt_items() or []
            for it in cur[len(u0):]:
                k, s = speaker_of(it)
                items += 1
                if k:
                    fields.add(k)
                    if s not in (nf, np_):
                        by += 1
            if first is not None:
                lat.append(first)
        out = dict(marker=mk, lat=lat, bystander=by if fields else None, items=items, field=sorted(fields))
        r.log("  %s: marker %s, latencies %s s, utterances %d, bystander lines %s (speaker field %s)"
              % (label, mk, [round(x, 1) for x in lat], items, out["bystander"], out["field"] or "none found"))
        return out
    finally:
        dress(r, item)
        for fid in placed:
            bring_back(r, fid)


def _rename(r, src, dst, tag):
    os.makedirs(BACKUP_DIR, exist_ok=True)
    shutil.copy2(src, BACKUP_DIR + "%s_%s_%s" % (tag, time.strftime("%Y%m%d-%H%M%S"), os.path.basename(src)))
    os.replace(src, dst)
    ok = os.path.exists(dst) and not os.path.exists(src)
    r.log("  SWAP %s: %s renamed (%s)" % (tag, os.path.basename(src), "verified" if ok else "FAILED"))
    return ok


def _x_run(r):
    """Both 0210 states + the restore, once per process (X-9 and X-10 read the same data)."""
    if _X:
        return _X
    want = sha(FILE_0210)
    na = NAGuard(r)
    moved = False
    try:
        ok, why = rescan(r)
        if not ok:
            _X["error"] = "precondition: Content Library rescan not confirmed in the 'with' launch (%s)" % why
            return _X
        _X["with"] = x_arm(r, "with 0210")
        if not _X["with"]:
            _X["error"] = "the 'with 0210' arm did not run"
            return _X
        if not wait_closed(r):
            _X["error"] = "the game did not close for the rename"
            return _X
        moved = _rename(r, FILE_0210, OFF_0210, "X9")
        if not moved:
            _X["error"] = "rename failed"
            return _X
        if not relaunch(r, "T0", "without 0210"):
            _X["error"] = "launch without 0210 failed"
            return _X
        ok, why = rescan(r)
        if not ok:
            _X["error"] = "precondition: Content Library rescan not confirmed after the rename (%s)" % why
            return _X
        _X["without"] = x_arm(r, "without 0210")
    finally:
        if moved:
            if not wait_closed(r):
                raise RestoreFailed("X-9: game/MO2 did not close for the 0210 restore")
            os.replace(OFF_0210, FILE_0210)
            good = sha(FILE_0210) == want and not os.path.exists(OFF_0210)
            r.log("  RESTORE X9: 0210 %s" % ("verified (sha256 equal)" if good else "FAILED"))
            if not good:
                raise RestoreFailed("X-9: 0210 not restored")
            na.check()
        if back_to(r, "T0") and moved:
            ok, why = rescan(r)
            _X["rescan_after"] = ok
            fu, au, pu = uuids(r, F1, A_NPC, PLAYER)
            mk = None
            if fu and au and pu:
                market(r)
                place(r, A_NPC, 300, 0, 0)
                item, _m = fire_exposure(r)
                time.sleep(3)
                mk = marker_count(r, au, fu)
                dress(r, item)
                bring_back(r, A_NPC)
            _X["restored_marker"] = mk
    return _X


@test("X-9", "X")
def x9(r):
    """How often bystanders speak while the player is exposed, with and without 0210 (spec :1891). Per state (x_arm):
    one exposure in the market crowd + 3 player lines to F1; bystander utterances counted. The without-arm is valid
    only if the render proves 0210 absent (marker 0) after rename + relaunch + rescan; the with-arm only if present
    (>= 1); restore proven by marker >= 1 again. No pass mark in the spec: PASS = both states measured and proven.
    INFERRED: (1) utterance items carry the speaker's uuid in one of _SPEAKER_KEYS (else the count is INCONCLUSIVE);
    (2) a '.prompt.u3off' file is not loaded as a submodule (the render check decides); (3) uuids from MCP and from
    the harness utterances compare after lower-casing and dropping '0x'. LLM calls: 6 plus the bystanders' own. Shares
    the run with X-10 (and with WE-2's exposure-in-crowd, time plan §4). Restart test: reload=False (ends on a fresh
    T0 load with 0210 restored)."""
    if not os.path.exists(FILE_0210):
        return inc(r, "0210 not found in the Scene Text layer (or still renamed from an earlier run)")
    if os.path.exists(OFF_0210):
        return inc(r, "a '.u3off' copy already exists: an earlier run did not restore; check by hand")
    if not harness_ready(r):
        return
    fu, au, pu = uuids(r, F1, A_NPC, PLAYER)
    if not (fu and au and pu):
        return inc(r, "F1, bystander A or the player not loaded")
    checkpoint(r, "2 states x 3 LLM lines, 2 relaunches")
    x = _x_run(r)
    if x.get("error"):
        return inc(r, x["error"])
    w, wo = x.get("with"), x.get("without")
    if not w or not wo:
        return inc(r, "an arm did not run")
    if not w["marker"]:
        return inc(r, "with-arm render shows no 0210 marker (%s): the presence check is not discriminating" % w["marker"])
    if wo["marker"] != 0:
        return inc(r, "0210 still rendered after rename + rescan (%s): the without-arm would be vacuous" % wo["marker"])
    r.check(x.get("restored_marker") is not None and x["restored_marker"] >= 1,
            "0210 rendered again after the restore (marker %s)" % x.get("restored_marker"))
    if w["bystander"] is None or wo["bystander"] is None:
        return inc(r, "utterance items carry no speaker field: bystander lines not countable (fields %s / %s)"
                   % (w["field"], wo["field"]))
    r.log("  bystander lines while exposed: with 0210 %d, without %d" % (w["bystander"], wo["bystander"]))
    r.check(True, "bystander lines measured in both 0210 states (trend only; no pass mark in the spec)")


@test("X-10", "X")
def x10(r):
    """Latency cost of 0210 in a crowd (spec :1892): median seconds from the player's line to the first NPC utterance,
    with vs without 0210, from X-9's run (3 lines per state). INFERRED: time-to-first-utterance is the latency proxy
    (SkyrimNet.log prints no per-request timing line). No pass mark: PASS = measured in both proven states."""
    checkpoint(r, "uses X-9's run")
    x = _X
    if not x:
        return inc(r, "X-9 did not run in this process (X-10 reads its data)")
    if x.get("error"):
        return inc(r, x["error"])
    w, wo = x.get("with") or {}, x.get("without") or {}
    if not w.get("marker") or wo.get("marker") != 0:
        return inc(r, "0210 states not proven by the render check")
    if len(w.get("lat", [])) < 2 or len(wo.get("lat", [])) < 2:
        return inc(r, "fewer than 2 latencies per state (%s / %s)" % (len(w.get("lat", [])), len(wo.get("lat", []))))
    a, b = statistics.median(w["lat"]), statistics.median(wo["lat"])
    r.log("  median time to first utterance: with 0210 %.1f s, without %.1f s, cost %+.1f s" % (a, b, a - b))
    r.check(True, "latency measured in both 0210 states")


# ============================================================================ RE-2 (R-2): silenceChancePercent 50 -> 80 -> 50

RE2_WRITE_APPROVED = True       # Shae 2026-10-11 (REVIEW_LOG RV-109-upd (1)): TEST-config write for RE-2 only
RE2_BASE, RE2_HIGH = 50, 80
_SIL_RX = re.compile(rb"(\ndialogue:\r?\n(?:  [^\r\n]*\r?\n)*?  speakerSelector:\r?\n(?:    [^\r\n]*\r?\n)*?"
                     rb"    silenceChancePercent: )(\d+)(\r?\n)")
RE2_LINES = ["Evening. Busy night?", "What's good to drink here?", "Any news from the road?", "Who's that over there?",
             "Have you heard any rumours lately?", "Is the stew any good tonight?", "How long have you run this place?",
             "Any trouble in town?", "Do you get many travellers?", "I'll take a room later, maybe."]


def silence():
    """The live silenceChancePercent of the test SkyrimNet.yaml (dialogue.speakerSelector), or None."""
    m = _SIL_RX.findall(open(game.SKYRIMNET_YAML, "rb").read())
    return int(m[0][1]) if len(m) == 1 else None


def set_silence(value, log=print, wait=180):
    """Write dialogue.speakerSelector.silenceChancePercent in the TEST profile's SkyrimNet.yaml, as game.set_gamemaster
    does for gamemaster.enabled: the game and MO2 must be closed (waits up to `wait` s, else refuses), the key must
    occur exactly once, a backup is taken first, the value is asserted after the write. Bytes outside the number are
    untouched (LF or CRLF kept)."""
    if not RE2_WRITE_APPROVED:
        log("SILENCE refused: RE2_WRITE_APPROVED is False (awaiting Shae)")
        return False
    t0 = time.time()
    while game.procs() and time.time() - t0 < wait:
        time.sleep(3)
    if game.procs():
        log("SILENCE refused: %s still running" % sorted(game.procs()))
        return False
    b = open(game.SKYRIMNET_YAML, "rb").read()
    if len(_SIL_RX.findall(b)) != 1:
        log("SILENCE refused: silenceChancePercent not found exactly once under dialogue.speakerSelector")
        return False
    os.makedirs(BACKUP_DIR, exist_ok=True)
    shutil.copy2(game.SKYRIMNET_YAML, BACKUP_DIR + "RE2_%s_SkyrimNet.yaml" % time.strftime("%Y%m%d-%H%M%S"))
    b2 = _SIL_RX.sub(lambda m: m.group(1) + str(int(value)).encode() + m.group(3), b)
    if b2 != b:
        with open(game.SKYRIMNET_YAML, "wb") as f:
            f.write(b2)
    ok = silence() == int(value)
    log("SILENCE silenceChancePercent %d (%s)" % (value, "verified" if ok else "WRITE FAILED"))
    return ok


def re2_arm(r, label):
    """Ten lines to the innkeeper in the Bannered Mare (10 LLM calls): (bystander utterances, cooldown log lines,
    innkeeper replies). Counts only. Innkeeper and bystanders resolved by name with QScan as DA-3 does."""
    from tests_u2_da import find_npc
    if not harness_ready(r):
        return None
    fid, u = find_npc(r, "Hulda", "WhiterunBanneredMare")
    if not u:
        inc(r, "%s: innkeeper not found" % label)
        return None
    pu, = uuids(r, PLAYER)
    con(r, "player.moveto %08X" % fid)
    time.sleep(4)
    sn = tail("skyrimnet")
    u0 = utt_items() or []
    for line in RE2_LINES:
        SH.inject_player_input(line, u)
        try:
            SH.await_idle(90)
        except SH.HarnessError:
            pass
        time.sleep(8)
    time.sleep(30)
    new = (utt_items() or [])[len(u0):]
    nu, np_ = u.lower().replace("0x", ""), (pu or "").lower().replace("0x", "")
    keyed = [speaker_of(it) for it in new]
    if not any(k for k, _ in keyed):
        inc(r, "%s: utterance items carry no speaker field" % label)
        return None
    by = sum(1 for k, s in keyed if k and s not in (nu, np_))
    cool = len(re.findall(r"(?i)cooldown", sn.read()))
    r.log("  %s: utterances %d, bystander lines %d, cooldown log lines %d" % (label, len(new), by, cool))
    return dict(bystander=by, cooldown=cool, items=len(new))


@test("RE-2", "RE")     # restart test: reload=False (ends on a fresh T0 load at 50)
def re2(r):
    """silenceChancePercent 50 vs 80, ten scene lines in an inn (s5_emote_text.md §8 R-2; spec :1782): count unsolicited
    bystander lines; note cooldown log lines. Pass: fewer at 80, still non-zero. Procedure: 50 arm in this launch ->
    close -> backup -> write 80 -> assert -> relaunch T0 -> 80 arm -> close -> restore 50 -> assert -> log -> relaunch T0.
    LLM calls: 20 player lines plus the bystanders' own (fewer at 80). STUB until RE2_WRITE_APPROVED (FOR_SHAE).
    INFERRED: the speaker field of utterance items (see speaker_of); 'cooldown' log lines are a count, not a cause."""
    if not RE2_WRITE_APPROVED:
        checkpoint(r)
        return inc(r, "awaiting Shae's approval (FOR_SHAE)")
    cur = silence()
    if cur != RE2_BASE:
        return inc(r, "silenceChancePercent is %s, not the play value %d" % (cur, RE2_BASE))
    checkpoint(r, "2 x 10 LLM lines, 2 relaunches")
    lo = re2_arm(r, "silence %d" % RE2_BASE)
    if not lo:
        return
    wrote = False
    try:
        if not wait_closed(r):
            return inc(r, "the game did not close for the config write")
        wrote = True
        if not set_silence(RE2_HIGH, r.log):
            return inc(r, "could not write silenceChancePercent %d" % RE2_HIGH)
        if not relaunch(r, "T0", "silenceChancePercent %d" % RE2_HIGH):
            return inc(r, "launch at %d failed" % RE2_HIGH)
        hi = re2_arm(r, "silence %d" % RE2_HIGH)
        if not hi:
            return
        r.check(hi["bystander"] < lo["bystander"], "fewer bystander lines at %d (%d) than at %d (%d)"
                % (RE2_HIGH, hi["bystander"], RE2_BASE, lo["bystander"]))
        r.check(hi["bystander"] > 0, "still non-zero at %d (%d)" % (RE2_HIGH, hi["bystander"]))
    finally:
        if wrote:
            if not wait_closed(r) or not set_silence(RE2_BASE, r.log) or silence() != RE2_BASE:
                raise RestoreFailed("RE-2: silenceChancePercent not restored to %d" % RE2_BASE)
            r.log("  RESTORE RE2: silenceChancePercent %d verified" % RE2_BASE)
        back_to(r, "T0")
