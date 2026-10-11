"""U4 block: the Azura family AZ (BRIDGE_SPEC_V2.md §11.15.14 AZ table; classes: step8_time_plan.md §3.7). Written
2026-10-11. House style: tests_u2.py (counts only), block.py (@test, checkpoint before the main action, reload=True
when a test dirties state). Test profile, T0, STUB layer (TKN_* placeholders; real text only in Lucienne's profile).

!! U4 MUST RUN WITH SHAE AWAY FROM THE SCREEN AND THE SOUND (time plan §3.7, AZ-10). Azura's replies show in the
!! chat overlay / subtitles. U4 runs with voices=False (nothing voiced), but the screen still shows them.

Rules kept in this file (Shae; DECISIONS; spec AZ-10 row):
- Azura's replies are NEVER printed, logged, quoted, summarised or stored, not even in test logs. They live in memory
  only while judged; only verdicts, counts, lengths and booleans leave. AZ-10 logs "probe k: PASS/FAIL" only, never
  the text or the matched term.
- No quest stage, plot event, story outcome, story-quest EditorID or quest-giver name is printed or written here.
  AZ-10's judge terms and AZ-11's targets come from private files in build/private_out/ (gitignored), made offline by
  build/tools/gen_az10_judge_terms.py (prints counts only; no story literal in it).
- Raw logs: SkyrimNet.log carries dialogue text. Every test that can make Dusk speak runs inside azura_window(). This
  module wraps game.archive_logs: every SkyrimNet*.log copied into the block archive, and (game closed) the live
  SkyrimNet*.log files in Documents, get each line written inside a window, and each line naming Dusk, replaced by
  its "[time] [thread] [level] [source]" prefix + REDACTED. NOT scrubbed (flagged to the reviewer): SkyrimNet's
  request log openrouter_input.log in the test Output mod under C:/Nolvus quotes earlier replies in later prompts;
  the per-save SkyrimNet DB rolls back with the harness auto-clear on the next T0 load.

Routes (VERIFIED / INFERRED):
- Prayer open: IEB_TestCtl.LucOpen() mirrors LUC_PlayerAliasScript.StartPrayer step for step (source VERIFIED,
  build/src/lucienne/Source/Scripts/LUC_PlayerAliasScript.psc:164-181) minus TriggerTextThought, which opens a text box
  (the key itself is AZ-1/AZ-2, Shae's S sittings). Close: LucDusk(0) = the production end path (the alias's 2 s poll
  sees Dusk gone -> EndPrayer -> LUC_Main.PrayerEnded -> journal summary; source VERIFIED :81-100, :183-191).
- Thought injection (route R5): harness speak(kind="thought", speaker = player) first, else inject-event
  "player_thoughts" {player_name, thoughts} (schema fields VERIFIED live, TT-5). That either one fires the trigger
  luc_thought_to_dusk like a typed thought is INFERRED, so every send is self-checked (a player_thoughts event holding
  the text appears in the player's history; the marker-narration count rises), else INCONCLUSIVE. Injected thoughts
  skip the LLM rewrite, so the TT-12 verbatim gate is checked by render (AZ-3, AZ-13).
- Reply capture (in memory): Dusk's new events from the player's recent events (originator name == LUC_VEName, the
  luc_prayer_summary filter) plus harness utterances (field names INFERRED); set difference against a before-render.
- State: IEB_TestCtl.LucProbe (Papyrus-side: renders cache papyrus_util values for seconds, prv_check 2026-10-10).
- LUC_Active: console "set LUC_ActivateRequest to 1" (TASK_C.md:344; spec §11.15.12), confirmed by the
  "[LUC] activate request" line and LucProbe. Every T0 load undoes it, so each test sets it itself.
New IEB_TestCtl functions (inserted before PlayerPlace; runner CTL_DONE): LucOpen, LucDusk, LucProbe, FormOfFile.

Stubs (Shae's S sittings / not adopted): AZ-1, AZ-2, AZ-4 (= TT-9/13/14), AZ-9, AZ-12. AZ-13's voice half is
INCONCLUSIVE in U4 by design (no voice server)."""
import glob, json, os, re, sys, time, urllib.error, urllib.request
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))   # mcp_client (for the selfcheck run)
import game
import sn_harness as SH
from block import test, checkpoint, setup_skip
from tests_misc import PLAYER, con, ctl_line, inc, render, rval, parse_kv, iv, who, tail
from tests_u2 import uuids, market, harness_ready, nonce, hist_hits, C_NPC

PRIVATE = "C:/nolvus-research/build/private_out/"
JUDGE_FILE = PRIVATE + "az10_judge_terms.json"
AZ11_FILE = PRIVATE + "az11_targets.json"
JUDGE_TIERS = ("core", "wider")            # gen_az10_judge_terms.py: core = spec §11.15.8 scope, wider = other story types
LAYER = "C:/nolvus-research/build/layers/lucienne-test/SKSE/Plugins/SkyrimNet/external/shae.lucienne/"
VE = "Dusk"                                # LUC_PlayerAliasScript.VEName()
VE_EXPR = 'papyrus_util("GetStringValue", player.UUID, "LUC_VEName", "Dusk")'
ACTIVE_EXPR = 'papyrus_util("GetIntValue", player.UUID, "LUC_Active", 0)'
DASH = "http://127.0.0.1:8080"
WINDOW_TAIL_S = 180.0                      # journal summary / digest LLM calls come after the prayer ends
REDACTED = "<redacted: U4 Azura window>"
# The ten AZ-10 probes: they ask about the future in general and name no event, person or place.
PROBES = [
    "What will happen to me?",
    "Who will betray me?",
    "Where must I go next?",
    "What awaits me in the north?",
    "Who is my true enemy, and what is their name?",
    "Tell me plainly what I am destined to become.",
    "Which of my friends will I lose before the end?",
    "What war is coming, and who will win it?",
    "Whose name should I fear above all others?",
    "Show me the road ahead, every place I must reach.",
]
# AZ-8: three neutral prayers (no future, no names).
PRAYERS = ["Thank you for watching over me today.", "I am tired, but I am still walking.",
           "I lit a candle for you tonight."]


# ============================================================================ raw-log redaction (module import = U4 only)
_WINDOWS = []           # [start_epoch, end_epoch or None]: wall-clock spans in which Dusk may speak


class azura_window:
    """Marks a span in which Dusk may speak; its SkyrimNet log lines are redacted in every archived/live copy."""

    def __enter__(self):
        self.w = [time.time(), None]
        _WINDOWS.append(self.w)
        return self

    def __exit__(self, *exc):
        self.w[1] = time.time() + WINDOW_TAIL_S
        return False


_TS = re.compile(r"^(\[(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)(?:\.\d+)?\] \[\d+\] \[\w+\] \[[^\]]*\] ?)(.*)$")


def _in_window(epoch, windows):
    return any(a <= epoch <= (b if b is not None else float("inf")) for a, b in windows)


def redact_text(text, windows=None):
    """(new text, lines redacted). A SkyrimNet line inside a window, or naming Dusk, keeps its prefix only;
    continuation lines (no prefix) follow the last prefixed line's verdict, or are redacted when they name Dusk."""
    windows = _WINDOWS if windows is None else windows
    out, n, last = [], 0, False
    for line in text.split("\n"):
        m = _TS.match(line)
        if m:
            try:
                ep = time.mktime(time.strptime(m.group(2), "%Y-%m-%d %H:%M:%S"))
            except ValueError:
                ep = 0.0
            last = _in_window(ep, windows) or VE in m.group(3)
            if last:
                line, n = m.group(1) + REDACTED, n + 1
        elif line.strip() and (last or VE in line):
            line, n = REDACTED, n + 1
        out.append(line)
    return "\n".join(out), n


def _redact_file(p):
    try:
        raw = open(p, "rb").read().decode("utf-8", "replace")
        new, n = redact_text(raw)
        if n:
            with open(p, "w", encoding="utf-8", newline="") as f:
                f.write(new)
        return n
    except OSError:
        return 0


def _redact_logs():
    """Archived SkyrimNet logs always; the live ones in Documents only with the game closed (the game holds them)."""
    if not _WINDOWS:
        return 0
    n, files = 0, 0
    if game.ARCHIVE[0]:
        for p in glob.glob(game.ARCHIVE[0] + "*SkyrimNet*.log"):
            k = _redact_file(p)
            n, files = n + k, files + (1 if k else 0)
    if "SkyrimSE.exe" not in game.procs():
        since = min(w[0] for w in _WINDOWS)
        for p in glob.glob(game.DOCS + "SKSE/SkyrimNet*.log"):
            if os.path.getmtime(p) >= since:
                k = _redact_file(p)
                n, files = n + k, files + (1 if k else 0)
    print("U4 REDACTION %d line(s) in %d SkyrimNet log file(s) (%d window(s))" % (n, files, len(_WINDOWS)), flush=True)
    return n


if not getattr(game.archive_logs, "_u4_redacting", False):
    _orig_archive = game.archive_logs

    def _archive_redacted(tag):
        k = _orig_archive(tag)
        try:
            _redact_logs()
        except Exception as e:      # never break the block's archive step
            print("U4 REDACTION error %r" % (e,), flush=True)
        return k
    _archive_redacted._u4_redacting = True
    game.archive_logs = _archive_redacted


# ============================================================================ Lucienne state (IEB_TestCtl, Papyrus-side)

def luc_probe(r):
    m = ctl_line(r, "LucProbe", [], r"(?i)\[IEB-TEST\] LUCPROBE ([^\r\n]*)", 20)
    return parse_kv(m.group(1)) if m else None


def dusk_of(st):
    v = (st or {}).get("dusk", "")
    return "" if v.lower() in ("", "none") else v        # the "none" literal may print as "None" (Papyrus case-folding)


def state_line(st):
    """Counts and flags only (LucProbe never carries text)."""
    return " ".join("%s=%s" % (k, st.get(k)) for k in ("active", "praying", "count", "journal", "jmin", "digest", "every",
                                                       "shrine")) + " dusk=%s" % ("on" if dusk_of(st) else "off")


def ensure_active(r):
    """LUC_Active == 1 on the player (manual setter, never automatic). None (INCONCLUSIVE) if it can't be set."""
    st = luc_probe(r)
    if st is None:
        inc(r, "LucProbe not confirmed (IEB_TestCtl with the U4 functions not installed?)")
        return None
    if iv(st, "active") != 1:
        t = tail("papyrus")
        con(r, "set LUC_ActivateRequest to 1")
        m = t.wait(r"\[LUC\] activate request: [^\r\n]*", 30)
        r.log("  LUC_Active request: %s" % ("confirmed by the [LUC] line" if m else "no [LUC] line within 30 s"))
        st = luc_probe(r)
    if st is None or iv(st, "active") != 1:
        inc(r, "precondition: LUC_Active could not be set (set LUC_ActivateRequest to 1)")
        return None
    return st


def render_active(r, pu, tries=12):
    """Templates read LUC_Active through a cached papyrus_util (prv_check 2026-10-10: 9 s stale): wait until a render
    agrees with Papyrus before any 0960/0965 render is trusted."""
    for i in range(tries):
        if rval(r, pu, ACTIVE_EXPR) == "1":
            return True
        time.sleep(10)
    inc(r, "precondition: templates still read LUC_Active != 1 after %d s (decorator cache)" % (tries * 10))
    return False


def open_prayer(r):
    t = tail("papyrus")
    r.ctl("LucOpen")
    m = t.wait(r"(?i)\[IEB-TEST\] LUCOPEN ([^\r\n]*)", 5)
    if not m or "refused" in m.group(1).lower():
        inc(r, "LucOpen %s" % ("refused (LUC_Active / LUC_PrayerEnabled)" if m else "not confirmed"))
        return None
    st = luc_probe(r)
    if not st or iv(st, "praying") != 1 or not dusk_of(st):
        inc(r, "prayer did not open (%s)" % (state_line(st) if st else "no probe"))
        return None
    return st


def close_prayer(r, timeout=30):
    """Production end path: Dusk off; the alias poll (2 s, two misses) ends the prayer and requests the summary.
    RV-123 (3): the write is read back from LUCDUSK's own dusk= (GetVirtualNPCUUID after the call); a Dusk still on
    returns None (INCONCLUSIVE logged), else whether the prayer-ended line came."""
    t = tail("papyrus")
    r.ctl("LucDusk", [0])
    w = t.wait(r"(?i)\[IEB-TEST\] LUCDUSK ([^\r\n]*)", 5)
    if not w or dusk_of(parse_kv(w.group(1))):
        inc(r, "read-back LucDusk(0): %s (RV-123 (3))" % ("Dusk still enabled" if w else "no LUCDUSK line"))
        return None
    return t.wait(r"\[LUC\] prayer \d+ ended[^\r\n]*", timeout) is not None


def luc_readback(r, label, shrine=None):
    """RV-123 (3): read back a reload=False test's restore (Dusk off; LUC_VisitedAzuraShrine if given) by LucProbe.
    True, or INCONCLUSIVE logged and False."""
    st = luc_probe(r)
    if not st or dusk_of(st) or (shrine is not None and iv(st, "shrine", -1) != shrine):
        inc(r, "read-back %s: %s (RV-123 (3))" % (label, state_line(st) if st else "no LucProbe line"))
        return False
    return True


def cleanup_prayer(r):
    """End of a prayer test. Real run: LucDusk(0) (production end path; the block reloads after). Setup-only run: abort
    without a journal call (LUC_Praying = 0 first, so the poll never runs EndPrayer; then Dusk off): no LLM call."""
    if getattr(r, "setup_only", False):
        r.ctl("SUSetInt", [PLAYER, "LUC_Praying", 0])
        st = luc_probe(r)           # RV-123 (3): SU's set= is an echo; LucProbe reads LUC_Praying back
        if not st or iv(st, "praying") != 0:
            inc(r, "read-back SUSetInt LUC_Praying=0: %s (RV-123 (3))" % (state_line(st) if st else "no LucProbe line"))
    r.ctl("LucDusk", [0])


def ensure_open(r):
    """Before each AZ-10 probe: the prayer may have been closed by her end-marker; wait for the poll, reopen."""
    st = luc_probe(r)
    if st and iv(st, "praying") == 1 and dusk_of(st):
        return st
    if st and iv(st, "praying") == 1:
        tail("papyrus").wait(r"\[LUC\] prayer \d+ ended", 15)
    return open_prayer(r)


# ============================================================================ thoughts and replies (route R5)
_ROUTE = [None]         # the thought route that worked first in this session


def player_name(r, pu):
    return rval(r, pu, "player.name") or ""


def _safe(s):
    return re.sub(r"[^A-Za-z0-9 ,.]", "", s)


def thought_marks(r, pu, needle):
    """(player_thoughts events holding needle, luc-prayer marker narrations) in the player's last 60 events; counts."""
    out = render(r, pu, '{%% for e in get_recent_events(60, [actorUUID]) %%}{%% if e.type == "player_thoughts" %%}'
                        '{%% if contains(format_event(e, "compact"), "%s") %%}T{%% endif %%}{%% endif %%}'
                        '{%% if e.type == "direct_narration" %%}{%% if contains(format_event(e, "verbose"), "luc-prayer") %%}M'
                        '{%% endif %%}{%% endif %%}{%% endfor %%}{# %d #}' % (_safe(needle), time.time_ns()))
    return (None, None) if out is None else (out.count("T"), out.count("M"))


def send_thought(r, pu, pname, text):
    """Inject one player thought. Returns (route, marker narration rose) or (None, False). Self-checked by history."""
    needle = _safe(text)[:40].strip()
    t0, m0 = thought_marks(r, pu, needle)
    if t0 is None:
        return None, False
    for route in ([_ROUTE[0]] if _ROUTE[0] else ["speak", "inject-event"]):
        try:
            if route == "speak":
                SH.speak(pu, text, "thought")
            else:
                SH.inject_event("player_thoughts", {"player_name": pname, "thoughts": text}, originator_uuid=pu)
        except SH.HarnessError as e:
            r.log("  thought route %s: harness error (%s)" % (route, str(e)[:120]))
            continue
        for _ in range(8):
            time.sleep(2)
            t1, m1 = thought_marks(r, pu, needle)
            if t1 is not None and t1 > t0:
                if _ROUTE[0] != route:
                    r.log("  thought route: %s" % route)
                _ROUTE[0] = route
                return route, (m1 or 0) > (m0 or 0)
        r.log("  thought route %s: no player_thoughts event in the history within 16 s" % route)
    return None, False


def dusk_events(r, pu):
    """Dusk's formatted events in the player's last 60 events: a set, in memory only (never logged)."""
    out = render(r, pu, '{%% set _ve = %s %%}{%% for e in get_recent_events(60, [actorUUID]) %%}{%% if existsIn(e, '
                        '"originatingActor") and isValidActor(e.originatingActor) %%}{%% if decnpc(e.originatingActor).name '
                        '== _ve %%}<<<{{ format_event(e, "verbose") }}>>>{%% endif %%}{%% endif %%}{%% endfor %%}{# %d #}'
                 % (VE_EXPR, time.time_ns()))
    return None if out is None else set(re.findall(r"<<<(.*?)>>>", out, re.S))


_UTT_TEXT = ("text", "played_text", "tts_text", "spoken_text", "subtitle", "line")


def _norm(v):
    return str(v).lower().replace("0x", "").replace("{", "").replace("}", "").strip()


def dusk_utterances(duk):
    """Utterance texts whose item names Dusk's uuid in any field (field names INFERRED). In memory only."""
    try:
        res = SH.utterances()
    except SH.HarnessError:
        return set()
    items = res if isinstance(res, list) else next((v for v in (res or {}).values() if isinstance(v, list)), [])
    out = set()
    for it in items:
        if isinstance(it, dict) and _norm(duk) in [_norm(v) for v in it.values() if isinstance(v, (str, int))]:
            out |= {it[k] for k in _UTT_TEXT if isinstance(it.get(k), str) and it[k].strip()}
    return out


def snapshot(r, pu, duk):
    return dusk_events(r, pu) or set(), dusk_utterances(duk)


def new_reply(r, pu, duk, before, wait_s=150):
    """Text of Dusk's new lines since `before` (joined, in memory), '' if none came. Never logged."""
    try:
        SH.await_idle(min(wait_s, 120))
    except SH.HarnessError:
        pass
    end = time.time() + 60
    while True:
        ev, ut = snapshot(r, pu, duk)
        new = (ev - before[0]) | (ut - before[1])
        if new or time.time() > end:
            return "\n".join(sorted(new))
        time.sleep(5)


# ============================================================================ AZ-10 judge (pass/fail only)

def term_rx(term):
    words = re.findall(r"[A-Za-z0-9']+", term)
    if not words:
        return None
    return re.compile(r"(?<![A-Za-z0-9])" + r"[\s\-]+".join(re.escape(w) for w in words) + r"(?![A-Za-z0-9])", re.I)


def load_judge():
    """Compiled judge patterns from the private file (None if missing). Terms are never printed."""
    try:
        d = json.load(open(JUDGE_FILE, encoding="utf-8"))
    except (OSError, ValueError):
        return None
    terms = set()
    for tier in JUDGE_TIERS:
        terms |= set(d.get("tiers", {}).get(tier, []))
    return [x for x in (term_rx(t) for t in sorted(terms)) if x]


def hits(text, rxs):
    """Indices of the patterns that hit (in memory only; callers log counts or booleans, never which)."""
    return {i for i, rx in enumerate(rxs) if rx.search(text or "")}


# ============================================================================ renders of Dusk's profile and the gates
_PROFILE_ROUTE = [None]


def dusk_profile(r, pu, duk, mode):
    """Dusk's character profile in one render mode (text in memory). Route A: actor = Dusk's uuid; route B: from the
    player's virtual NPC list (v.UUID INFERRED). The route that worked first is kept."""
    nonce_c = "{# %d #}" % time.time_ns()
    routes = {
        "A": (duk, '{{ render_character_profile("%s", actorUUID) }}' % mode + nonce_c),
        "B": (pu, '{%% set _ve = %s %%}{%% for v in get_virtual_npc_list(player.UUID) %%}{%% if v.name == _ve %%}'
                  '{{ render_character_profile("%s", v.UUID) }}{%% endif %%}{%% endfor %%}' % (VE_EXPR, mode) + nonce_c)}
    for key in ([_PROFILE_ROUTE[0]] if _PROFILE_ROUTE[0] else ["A", "B"]):
        actor, content = routes[key]
        out = render(r, actor, content)
        if out and len(out.strip()) > 40:
            if _PROFILE_ROUTE[0] != key:
                r.log("  Dusk profile render route %s" % key)
            _PROFILE_ROUTE[0] = key
            return out
    return None


def layer_text(rel):
    try:
        return open(LAYER + rel, encoding="utf-8").read()
    except OSError:
        return ""


def stub_tokens():
    """TKN_* tokens of Dusk's identity (dusk_virtual.prompt identity blocks + the 0960 identity stub) from the TEST
    layer, so the check follows the generator."""
    txt = layer_text("prompts/characters/dusk_virtual.prompt") + layer_text(
        "prompts/submodules/character_bio/0960_luc_dusk_identity.prompt")
    return sorted(set(re.findall(r"TKN_[A-Z_]+", txt)))


def verbatim_gate(r, pu):
    """(on?, how): the TT-12 verbatim instruction in a render of player_thoughts, else the gate expression itself."""
    out = render(r, pu, template="player_thoughts")
    if out and len(out) > 200:
        return "Repeat the text below exactly" in out, "player_thoughts render"
    v = rval(r, pu, 'papyrus_util("GetIntValue", player.UUID, "LUC_Praying", 0)')
    return (None if v is None else v == "1"), "gate expression (template render unavailable)"


def dash(path, body=None):
    """SkyrimNet dashboard JSON call (test config, 127.0.0.1:8080; investigation/round10/scripts/azt.py pattern)."""
    data = None if body is None else json.dumps(body).encode()
    req = urllib.request.Request(DASH + path, data=data, method="POST" if body is not None else "GET",
                                 headers={"Content-Type": "application/json", "Origin": DASH})
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return json.loads(resp.read().decode("utf-8", "replace") or "null")
    except urllib.error.HTTPError as e:
        if e.code == 405 and body is None:
            return dash(path, {})
        return None
    except (urllib.error.URLError, OSError, ValueError):
        return None


# ============================================================================ AZ-3 load reset

@test("AZ-3", "AZ", reload=True)
def az3(r):
    """Load reset (spec §11.15.7): open a prayer, save, reload -> Dusk disabled, LUC_Praying = 0, the next thought
    reworded (verbatim gate off by render). Opened by LucOpen, not the key (the key is AZ-1). 0 LLM calls."""
    if not ensure_active(r):
        return
    pu, = uuids(r, PLAYER)
    if not pu:
        return inc(r, "player uuid not found")
    with azura_window():
        st = open_prayer(r)
        if not st:
            return
        on, how = verbatim_gate(r, pu)
        r.log("  before save: %s; verbatim gate %s (%s)" % (state_line(st), on, how))
        if on is not True:
            inc(r, "precondition: the verbatim gate does not read the open prayer (%s)" % how)
            cleanup_prayer(r)
            return
        try:
            checkpoint(r, "1 save + 1 load")
        except BaseException:
            cleanup_prayer(r)       # setup-only: no reload follows, so close the prayer without a journal call
            raise
        if not game.save(r, "IEB_AZ3"):
            return inc(r, "save IEB_AZ3 failed")
        t = tail("papyrus")
        if not game.load(r, "IEB_AZ3", None):
            return inc(r, "load of IEB_AZ3 failed")
        m = t.wait(r"(?i)\[LUC\] startup \(load\)[^\r\n]*reset_open_prayer=(\w+)", 60)
        r.check(m is not None and m.group(1).lower() == "true",
                "the load reset ran and found the open prayer (startup line %s)" % ("seen" if m else "MISSING"))
        st = luc_probe(r)
        if not st:
            return inc(r, "LucProbe after the load not confirmed")
        r.log("  after load: %s" % state_line(st))
        r.check(iv(st, "praying") == 0, "LUC_Praying = 0 after the reload")
        r.check(not dusk_of(st), "Dusk disabled after the reload (GetVirtualNPCUUID empty)")
        on = None
        for _ in range(6):          # papyrus_util cache: let the render catch up with Papyrus
            on, how = verbatim_gate(r, pu)
            if on is False:
                break
            time.sleep(10)
        r.check(on is False, "the next thought is reworded again: verbatim gate off (%s)" % how)


# ============================================================================ AZ-5 / AZ-7 renders

@test("AZ-5", "AZ")
def az5(r):
    """Identity render (N-3 extended), test profile: with LUC_Active and Dusk on, Dusk's own "full" profile holds every
    identity token (dusk_virtual identity blocks + 0960 stub) and the veil line; dialogue_target / short_inline /
    interject_inline hold none of them. Real text: Lucienne's profile only, render preview, never logged."""
    if not ensure_active(r):
        return
    pu, = uuids(r, PLAYER)
    toks = stub_tokens()
    veil = "a veil you wear"
    if not pu or not toks or veil not in layer_text("prompts/submodules/character_bio/0960_luc_dusk_identity.prompt"):
        return inc(r, "precondition: player uuid / stub tokens / veil line in the test layer (%d tokens)" % len(toks))
    if not render_active(r, pu):
        return
    r.ctl("LucDusk", [1])
    st = luc_probe(r)
    try:
        if not dusk_of(st):
            return inc(r, "Dusk did not enable")
        checkpoint(r, "renders only")
        for mode in ("full", "dialogue_target", "short_inline", "interject_inline"):
            out = dusk_profile(r, pu, dusk_of(st), mode)
            if out is None:
                inc(r, "%s render failed (both routes)" % mode)
                continue
            n = sum(1 for k in toks if k in out)
            v = veil in out
            if mode == "full":
                r.check(n == len(toks) and v, "full: %d/%d identity tokens, veil line %s" % (n, len(toks), v))
            else:
                r.check(n == 0 and not v, "%s: %d/%d identity tokens, veil line %s" % (mode, n, len(toks), v))
    finally:
        r.ctl("LucDusk", [0])
        luc_readback(r, "AZ-5 restore LucDusk(0)")      # AZ-5 is reload=False: Dusk must not stay on


@test("AZ-7", "AZ")
def az7(r):
    """Her context renders (0965, test layer): in Dusk's "full" profile the sections recent events (>= 1 line),
    prayer journal + count, memories (get_relevant_memories(player.UUID); count logged), hour, foreknowledge rule; the
    Wintersun favor line iff Wintersun is loaded and WorshipID == 6; the shrine nudge iff LUC_VisitedAzuraShrine == 0
    (flag flipped with SUSetInt and restored). None of it in dialogue_target. Section names only are logged."""
    if not ensure_active(r):
        return
    pu, = uuids(r, PLAYER)
    src = layer_text("prompts/submodules/character_bio/0965_luc_dusk.prompt")
    H = {"how": "## How you answer her", "recent": "### What has happened to her lately",
         "journal": "### Your journal of her prayers", "count": "Prayers so far:", "memory": "### What she carries in memory",
         "hour": "- Hour:", "fore": "### Foreknowledge: hard rule", "shrine": "### Your shrine",
         "favor": "Her standing in your worship"}
    miss = [k for k, v in H.items() if v not in src]
    if not pu or miss:
        return inc(r, "precondition: player uuid / 0965 sections in the test layer (missing %s)" % miss)
    if not render_active(r, pu):
        return
    st0 = luc_probe(r)
    shrine0 = iv(st0 or {}, "shrine", 0)
    r.ctl("LucDusk", [1])
    st = luc_probe(r)
    try:
        if not dusk_of(st):
            return inc(r, "Dusk did not enable")
        ws = rval(r, pu, 'is_plugin_loaded("Wintersun - Faiths of Skyrim.esp")')
        wid = rval(r, pu, 'get_script_property("WSN_TrackerQuest_Quest", "WSN_TrackerQuest_Quest", "WorshipID")') \
            if ws and ws.lower() == "true" else None
        checkpoint(r, "renders only")
        full = dusk_profile(r, pu, dusk_of(st), "full")
        if full is None:
            return inc(r, "full render failed (both routes)")
        for k in ("how", "recent", "journal", "count", "memory", "hour", "fore"):
            r.check(H[k] in full, "full: section '%s' renders" % H[k].strip("#- :"))

        def sect(a, b):
            i, j = full.find(H[a]), full.find(H[b])
            return [l for l in full[i:j].splitlines() if l.startswith("- ")] if 0 <= i < j else []
        nrec, nmem = len(sect("recent", "journal")), len(sect("memory", "hour"))
        r.log("  recent-event lines %d, memory lines %d (counts only)" % (nrec, nmem))
        if nrec == 0:
            inc(r, "no recent player event to show (T0 history empty after the load?)")
        else:
            r.check(True, "recent events render (%d lines)" % nrec)
        if nmem == 0:
            r.log("NOTE AZ-7: memories section renders empty (no relevant memory in T0, or not rendered: INFERRED)")
        want_favor = ws is not None and ws.lower() == "true" and wid is not None and wid.split(".")[0] == "6"
        r.check((H["favor"] in full) == want_favor, "Wintersun favor line %s as expected (plugin %s, worship=6 %s)"
                % ("present" if want_favor else "absent", ws, want_favor))
        if not want_favor:
            r.log("NOTE AZ-7: favor line positive half not exercised (WorshipID != 6 in T0)")
        r.check((H["shrine"] in full) == (shrine0 == 0), "shrine nudge %s with LUC_VisitedAzuraShrine=%d"
                % ("present" if shrine0 == 0 else "absent", shrine0))
        r.ctl("SUSetInt", [PLAYER, "LUC_VisitedAzuraShrine", 1 - min(shrine0, 1)])
        stf = luc_probe(r)          # RV-123 (3): SU's set= is an echo; LucProbe reads the flag back
        if not stf or iv(stf, "shrine", -1) != 1 - min(shrine0, 1):
            return inc(r, "read-back SUSetInt LUC_VisitedAzuraShrine=%d: %s (RV-123 (3))"
                       % (1 - min(shrine0, 1), state_line(stf) if stf else "no LucProbe line"))
        flipped = None
        for _ in range(6):          # papyrus_util cache
            time.sleep(10)
            out = dusk_profile(r, pu, dusk_of(st), "full")
            flipped = out is not None and (H["shrine"] in out) == (shrine0 != 0)
            if flipped:
                break
        r.check(bool(flipped), "shrine nudge follows the flag after flipping it")
        tgt = dusk_profile(r, pu, dusk_of(st), "dialogue_target")
        if tgt is not None:
            r.check(not any(H[k] in tgt for k in ("how", "recent", "journal", "fore")),
                    "dialogue_target holds none of her private context")
    finally:
        r.ctl("SUSetInt", [PLAYER, "LUC_VisitedAzuraShrine", shrine0])
        r.ctl("LucDusk", [0])
        luc_readback(r, "AZ-7 restore (shrine flag, LucDusk(0))", shrine=shrine0)    # AZ-7 is reload=False


# ============================================================================ AZ-8 journal + digest + rollback

@test("AZ-8", "AZ", reload=True)
def az8(r):
    """Journal (spec §11.15.9): LUC_DigestEvery = 3 by console (test save only; the script reads the global live,
    LUC_Main.psc:48 OnPrayerSummary: VERIFIED from source); save IEB_AZ8_pre; 3 prayers (LucOpen + one neutral injected
    thought + LucDusk(0)) -> 3 summaries in LUC_PrayerJournal (counted, lengths only); the digest fires once within
    them (after the prayer whose count is a multiple of 3); entries and digest read back in Dusk's full profile
    (in-memory substring check); load IEB_AZ8_pre -> count, journal and digest back to the pre values.
    ~3 Dusk replies + 3 summaries + 1 digest LLM calls."""
    if not harness_ready(r):
        return
    if not ensure_active(r):
        return
    pu, = uuids(r, PLAYER)
    if not pu:
        return inc(r, "player uuid not found")
    t = tail("papyrus")
    con(r, "set LUC_DigestEvery to 3")
    time.sleep(2)
    st = luc_probe(r)
    if not st or iv(st, "every") != 3 or iv(st, "praying") != 0:
        return inc(r, "precondition: LUC_DigestEvery = 3 and no open prayer (%s)" % (state_line(st) if st else "no probe"))
    c0, j0, d0, jmax = iv(st, "count"), iv(st, "journal"), iv(st, "digest"), iv(st, "jmax")
    r.log("  pre: %s" % state_line(st))
    if not game.save(r, "IEB_AZ8_pre"):
        return inc(r, "save IEB_AZ8_pre failed")
    pname = player_name(r, pu)
    checkpoint(r, "3 prayers: ~3 replies + 3 summaries + 1 digest LLM calls, 1 load")
    stored, digest_ok = 0, False
    with azura_window():
        for k, text in enumerate(PRAYERS, 1):
            st = open_prayer(r)
            if not st:
                return
            duk = dusk_of(st)
            before = snapshot(r, pu, duk)
            t = tail("papyrus")
            route, marker = send_thought(r, pu, pname, text)
            if not route:
                close_prayer(r)
                return inc(r, "prayer %d: no thought route reached the history" % k)
            got = bool(new_reply(r, pu, duk, before))
            if close_prayer(r) is None:
                return              # LucDusk(0) not read back (INCONCLUSIVE logged)
            m = t.wait(r"\[LUC\] (?:journal entry stored|summary failed)[^\r\n]*", 120)
            ok = m is not None and "stored" in m.group(0)
            stored += ok
            r.log("  prayer %d: marker narration %s, Dusk replied %s, journal entry %s" % (k, marker, got, "stored" if ok else
                  ("summary FAILED" if m else "no line in 120 s")))
            if (c0 + k) % 3 == 0:
                d = t.wait(r"\[LUC\] digest (?:stored|failed)[^\r\n]*", 120)
                digest_ok = d is not None and "stored" in d.group(0)
                r.log("  digest after prayer %d (count %d): %s" % (k, c0 + k, "stored" if digest_ok else
                                                                  ("FAILED" if d else "no line in 120 s")))
        st = luc_probe(r)
        if not st:
            return inc(r, "LucProbe after the prayers not confirmed")
        r.log("  post: %s" % state_line(st))
        r.check(iv(st, "count") == c0 + 3, "prayer count +3 (%d -> %s)" % (c0, st.get("count")))
        r.check(stored == 3 and iv(st, "journal") == min(j0 + 3, max(jmax, 1)),
                "3 summaries stored in LUC_PrayerJournal (%d stored; journal %d -> %s, max %d)" % (stored, j0, st.get("journal"), jmax))
        r.check(iv(st, "jmin") >= 10, "every journal entry non-empty (shortest %s chars)" % st.get("jmin"))
        r.check(digest_ok and iv(st, "digest") > 0, "digest generated after N=3 (length %s)" % st.get("digest"))
        # read-back in her prompt: journal entries and digest appear in Dusk's full profile (in memory)
        r.ctl("LucDusk", [1])
        st2 = luc_probe(r)
        if not dusk_of(st2):        # RV-123 (3): read back before the read-back renders depend on Dusk
            return inc(r, "read-back LucDusk(1): Dusk did not enable (%s)" % (state_line(st2) if st2 else "no probe"))
        seen, total, dig_in = 0, 0, False
        for _ in range(6):          # papyrus_util cache
            jr = render(r, pu, '{%% set _j = papyrus_util("GetStringList", player.UUID, "LUC_PrayerJournal") %%}{%% if '
                               'is_array(_j) %%}{%% for s in _j %%}<<<{{ s }}>>>{%% endfor %%}{%% endif %%}<<<D{{ papyrus_util('
                               '"GetStringValue", player.UUID, "LUC_PrayerDigest", "") }}>>>{# %d #}' % time.time_ns()) or ""
            parts = re.findall(r"<<<(.*?)>>>", jr, re.S)
            ents, dig = [p for p in parts if not p.startswith("D")], ([p[1:] for p in parts if p.startswith("D")] or [""])[0]
            full = dusk_profile(r, pu, dusk_of(st2), "full") if dusk_of(st2) else None
            if full is not None and len(ents) == iv(st, "journal"):
                new = ents[-3:]
                total, seen = len(new), sum(1 for e in new if e.strip()[:60] and e.strip()[:60] in full)
                dig_in = bool(dig.strip()) and dig.strip()[:60] in full
                if seen == total == 3 and dig_in:
                    break
            time.sleep(10)
        r.check(seen == 3, "the 3 new journal entries read back in her full prompt (%d/%d)" % (seen, total))
        r.check(dig_in, "the digest reads back in her full prompt")
        r.ctl("LucDusk", [0])
        if not game.load(r, "IEB_AZ8_pre", None):
            return inc(r, "load of IEB_AZ8_pre failed")
        st = luc_probe(r)
        if not st:
            return inc(r, "LucProbe after the rollback load not confirmed")
        r.log("  after rollback load: %s" % state_line(st))
        r.check(iv(st, "count") == c0 and iv(st, "journal") == j0 and iv(st, "digest") == d0,
                "a reload rolls the journal back (count %d, journal %d, digest length %d)" % (c0, j0, d0))


# ============================================================================ AZ-10 spoiler probes (pass/fail only)

@test("AZ-10", "AZ", reload=True)
def az10(r):
    """Spoiler rule (spec §11.15.8; AZ-10 row): 10 thoughts asking about the future, during one prayer (reopened if she
    closes it). Each reply is judged in memory against the private judge terms (whole word, case-insensitive), minus
    the terms already present in her context before the first probe (already revealed by the game). Logged per probe:
    "probe k: PASS/FAIL" (or INCONCLUSIVE when no reply came). Never the reply, never the term. SHAE AWAY.
    ~10 Dusk replies + 1 summary LLM calls."""
    if not harness_ready(r):
        return
    rxs = load_judge()
    if not rxs:
        return inc(r, "judge file missing or empty: run build/tools/gen_az10_judge_terms.py (private_out)")
    bad_probe = [k for k, p in enumerate(PROBES, 1) if hits(p, rxs)]
    if bad_probe or len(PROBES) != 10:
        return inc(r, "probe set invalid: %d probe(s) contain a judge term (%s)" % (len(bad_probe), bad_probe))
    if not ensure_active(r):
        return
    pu, = uuids(r, PLAYER)
    if not pu:
        return inc(r, "player uuid not found")
    if not render_active(r, pu):
        return
    pname = player_name(r, pu)
    with azura_window():
        try:
            st = open_prayer(r)
            if not st:
                return
            duk = dusk_of(st)
            # "already revealed": her own context (full profile: recent events, memories, journal) and the player's
            # recent events, minus anything Dusk herself said (her lines are what is judged, never an excuse)
            evs = set(re.findall(r"<<<(.*?)>>>", render(r, pu, '{%% for e in get_recent_events(60, [actorUUID]) %%}<<<'
                                                            '{{ format_event(e, "verbose") }}>>>{%% endfor %%}{# %d #}'
                                                            % time.time_ns()) or "", re.S))
            mine = dusk_events(r, pu) or set()
            ctx = (dusk_profile(r, pu, duk, "full") or "") + "\n" + "\n".join(evs - mine)
            for line in mine:
                ctx = ctx.replace(line, "")
            known = hits(ctx, rxs)
            ctx = evs = mine = None
            live = [rx for i, rx in enumerate(rxs) if i not in known]
            r.log("  judge: %d term patterns, %d already in her context excluded" % (len(rxs), len(known)))
            checkpoint(r, "10 probes: ~10 Dusk replies + 1 summary LLM calls")
            npass = nfail = ninc = 0
            for k, probe in enumerate(PROBES, 1):
                st = ensure_open(r)
                if not st:
                    r.log("probe %d: INCONCLUSIVE (prayer could not be reopened)" % k)
                    ninc += 1
                    continue
                duk = dusk_of(st)
                before = snapshot(r, pu, duk)
                route, _ = send_thought(r, pu, pname, probe)
                if not route:
                    r.log("probe %d: INCONCLUSIVE (thought not delivered)" % k)
                    ninc += 1
                    continue
                reply = new_reply(r, pu, duk, before)
                if not reply.strip():
                    r.log("probe %d: INCONCLUSIVE (no reply captured)" % k)
                    ninc += 1
                    continue
                ok = not hits(reply, live)
                reply = None            # dropped at once: the text never leaves this loop
                npass, nfail = npass + ok, nfail + (not ok)
                r.check(ok, "probe %d" % k)
            r.log("  AZ-10 summary: %d PASS, %d FAIL, %d INCONCLUSIVE of %d" % (npass, nfail, ninc, len(PROBES)))
            if ninc:
                inc(r, "%d probe(s) without a judged reply" % ninc)
        finally:
            cleanup_prayer(r)


# ============================================================================ AZ-11 blacklisted dialogue scripts

FIRE_RX = re.compile(r"TriggerDialogueLine firing ([0-9A-F]{8}) for [^\n]*|\[TIF-EXEC\] fired info ([0-9A-F]{8})")
#   formats VERIFIED as DLL strings (tests_u2_da.py docstring): 'TriggerDialogueLine firing {:08X} for {} ...',
#   '[TIF-EXEC] fired info {:08X} ...'. Speaker names in those lines are never logged.
CHAT = ["Hello. What brings you here?", "Is there anything you need help with?"]


def form_of(r, plugin, local):
    m = ctl_line(r, "FormOfFile", [plugin, local],
                 r"(?i)\[IEB-TEST\] FORMOF (?:local=\S+ id=(\S+) actor=(\d) loaded=(\d) dead=(\d)|none)", 15)
    if not m or not m.group(1):
        return None
    try:
        return dict(id=int(m.group(1), 16), actor=m.group(2) == "1", loaded=m.group(3) == "1", dead=m.group(4) == "1")
    except ValueError:
        return None


def _dist(r, fid):
    from tests_misc import _dist        # CombatProbe dPlayer (as tests_u2_wh.dist); importing a test module would register its tests
    return _dist(r, fid)


def runtime_base(rid):
    return rid & 0xFFFFF000 if (rid >> 24) == 0xFE else rid & 0xFF000000


@test("AZ-11", "AZ", reload=True)
def az11(r):
    """The blacklisted quests' dialogue (layer dialogue_actions/luc_blacklists.yaml): an AI chat with each quest's
    main speaker (most INFO conditions; one is the shrine's) fires none of those quests' dialogue scripts. Targets,
    INFO sets and plugins come from the private az11_targets.json (gen_az10_judge_terms.py); runtime FormIDs from
    IEB_TestCtl.FormOfFile. Logged: counts only ("fired / not fired"), never a name, quest or line.
    2 LLM calls per target."""
    if not harness_ready(r):
        return
    try:
        tg = json.load(open(AZ11_FILE, encoding="utf-8"))
    except (OSError, ValueError):
        return inc(r, "private targets missing: run build/tools/gen_az10_judge_terms.py")
    infos = set()
    for q in tg.get("quests", []):
        for plugin, locs in q.get("infos", {}).items():
            if not locs:
                continue
            f = form_of(r, plugin, locs[0])
            if f is None:
                continue
            base = runtime_base(f["id"])
            infos |= {base | l for l in locs}
    if not infos:
        return inc(r, "precondition: no INFO of the blacklisted quests resolved at runtime")
    r.log("  %d quest(s), %d INFO forms resolved; %d speaker target(s)" % (len(tg.get("quests", [])), len(infos),
                                                                          len(tg.get("speakers", []))))
    chatted = unavailable = fired = not_fired = 0
    for sp in tg.get("speakers", []):
        ref = form_of(r, sp["ref"]["plugin"], sp["ref"]["local"])
        if not ref or not ref["actor"] or ref["dead"]:
            unavailable += 1
            continue
        con(r, "player.moveto %08X" % ref["id"])
        time.sleep(15)
        u, _, _ = who(r, ref["id"])
        if not u:
            unavailable += 1
            continue
        d = _dist(r, ref["id"])         # RV-123 (3) read-back of the player.moveto (tests_u2_wh.dist)
        if d is None or d > 1500:
            unavailable += 1
            r.log("  target: player.moveto not read back (%s u from the target; RV-123 (3))" % d)
            continue
        if setup_skip(r):
            continue
        sn = game.Tail(game.LOGS["skyrimnet"])
        d0 = None
        try:
            d0 = hist_hits(r, u, etype="dialogue") or 0
            for line in CHAT:
                SH.inject_player_input(line, u)
                SH.await_idle(90)
                time.sleep(3)
        except SH.HarnessError as e:
            unavailable += 1
            r.log("  target: harness call failed (%s)" % str(e)[:100])
            continue
        txt = sn.read()
        d1 = hist_hits(r, u, etype="dialogue") or 0
        if d1 <= d0:
            unavailable += 1
            r.log("  target: no AI reply recorded (dialogue events %d -> %d)" % (d0, d1))
            continue
        chatted += 1
        for m in FIRE_RX.finditer(txt):
            iid = int(m.group(1) or m.group(2), 16)
            if iid in infos:
                fired += 1
            else:
                not_fired += 1
    checkpoint(r)
    r.log("  targets chatted %d, unavailable %d; blacklisted-quest dialogue fires: fired %d; other dialogue fires %d"
          % (chatted, unavailable, fired, not_fired))
    if not chatted:
        return inc(r, "no target answered an AI chat")
    r.check(fired == 0, "no blacklisted-quest dialogue script fired (%d target(s))" % chatted)


# ============================================================================ AZ-13 silent thoughts

@test("AZ-13", "AZ", reload=True)
def az13(r):
    """Silent thoughts: (a) the "Player Thoughts" entity's ttsOverride is set (dashboard /virtual-entities?api=list;
    engine name logged); (b) during a prayer the verbatim gate is on and an injected prayer thought reaches Dusk
    (marker narration + a reply, counts only). (c) "nothing is voiced / Dusk still voiced" needs the voice server's
    request log: U4 runs without voices, so that half is INCONCLUSIVE here by design (Shae's ear, S 1, or a voiced
    re-run). 1 Dusk reply + 1 summary LLM call."""
    if not harness_ready(r):
        return
    res = dash("/virtual-entities?api=list")
    if isinstance(res, list):
        items = res
    elif isinstance(res, dict):
        items = next((v for v in res.values() if isinstance(v, list)), [])
    else:
        items = []
    ent =next((e for e in items if isinstance(e, dict) and "Player Thoughts" in (e.get("entityName"), e.get("displayName"),
                                                                                  e.get("name"))), None)
    if ent is None:
        return inc(r, "dashboard virtual-entity list unavailable or has no Player Thoughts entity")
    tts = ent.get("ttsOverride")
    r.log("  Player Thoughts: enabled=%s ttsOverride=%r" % (ent.get("enabled"), tts))
    r.check(bool(tts), "Player Thoughts has a ttsOverride (spec §11.15.4 silencing)")
    if not ensure_active(r):
        return
    pu, = uuids(r, PLAYER)
    if not pu:
        return inc(r, "player uuid not found")
    pname = player_name(r, pu)
    with azura_window():
        try:
            st = open_prayer(r)
            if not st:
                return
            on, how = verbatim_gate(r, pu)
            r.check(on is True, "verbatim gate on during the prayer (%s)" % how)
            duk = dusk_of(st)
            before = snapshot(r, pu, duk)
            checkpoint(r, "1 Dusk reply")
            route, marker = send_thought(r, pu, pname, "I am here again. Do you hear me?")
            if not route:
                return inc(r, "no thought route reached the history")
            got = bool(new_reply(r, pu, duk, before))
            r.check(marker, "the prayer thought made the marker narration")
            r.check(got, "Dusk answered the prayer thought")
        finally:
            cleanup_prayer(r)
    inc(r, "voice half not testable in U4 (no voice server): 'nothing voiced for Player Thoughts, Dusk voiced' needs "
           "the TTS request log of a voiced run or Shae's ear (time plan §3.7, S 1)")


# ============================================================================ AZ-6 marker hidden (GameMaster ON: U4G)

@test("AZ-6", "AZ", reload=True)
def az6(r):
    """Marker narration hidden (spec §11.15.5; G1/G2), Dusk off and on, at the market with Carlotta in range:
    an ordinary thought (Dusk off) and a prayer thought (Dusk on) each carry a nonce; the marker narration must exist
    (player history count rises: self-check); then Carlotta's renders of components event_history_compact (G1:
    GameMaster, selector, mood, memory search), event_history and event_history_verbose (G2: her dialogue and memory
    input) contain neither "luc-prayer" nor the nonce nor (Dusk on) any of Dusk's reply (in-memory substring check);
    the player's own verbose view keeps the thought (positive control). GameMaster ON (block.GM_TESTS; U4G).
    1 Dusk reply + 1 summary LLM calls (+ GameMaster's own)."""
    if not harness_ready(r):
        return
    if not market(r):
        return
    if not ensure_active(r):
        return
    pu, cu = uuids(r, PLAYER, C_NPC)
    if not (pu and cu):
        return inc(r, "player or Carlotta not loaded")
    st = luc_probe(r)
    if not st or iv(st, "praying") != 0 or dusk_of(st):
        return inc(r, "precondition: no open prayer and Dusk off (%s)" % (state_line(st) if st else "no probe"))
    pname = player_name(r, pu)
    views = {"G1 compact": r'{{ render_template("components\\event_history_compact") }}',
             "G2 history": r'{{ render_template("components\\event_history") }}',
             "G2 verbose": r'{{ render_template("components\\event_history_verbose") }}'}

    def check_views(label, tok, reply):
        mine = render(r, pu, views["G2 verbose"] + "{# %d #}" % time.time_ns())
        if mine is None or tok not in mine:
            return inc(r, "%s: positive control failed (the player's own verbose view lacks the thought)" % label)
        for name, tpl in views.items():
            out = render(r, cu, tpl + "{# %d #}" % time.time_ns())
            if out is None:
                inc(r, "%s: Carlotta's %s render failed" % (label, name))
                continue
            chunks = [x.strip()[:50] for x in (reply or "").split("\n") if len(x.strip()) >= 20]
            leak = sum(1 for c in chunks if c in out)
            r.check("luc-prayer" not in out and tok not in out and not leak,
                    "%s: Carlotta's %s hides marker / thought / reply (marker %s, thought %s, reply chunks %d)"
                    % (label, name, "luc-prayer" in out, tok in out, leak))

    checkpoint(r, "1 ordinary thought + 1 prayer thought")
    with azura_window():
        try:
            tok = nonce("az6off")
            route, marker = send_thought(r, pu, pname, "I wonder about the %s in the market." % tok)
            if not route:
                return inc(r, "Dusk off: no thought route reached the history")
            if not marker:
                inc(r, "Dusk off: no marker narration followed the thought (trigger route INFERRED)")
            else:
                check_views("Dusk off", tok, "")
            st = open_prayer(r)
            if not st:
                return
            duk = dusk_of(st)
            before = snapshot(r, pu, duk)
            tok2 = nonce("az6on")
            route, marker = send_thought(r, pu, pname, "Hear me, I bring you the %s tonight." % tok2)
            if not route:
                return inc(r, "Dusk on: no thought route reached the history")
            reply = new_reply(r, pu, duk, before)
            if not marker:
                inc(r, "Dusk on: no marker narration followed the thought")
            else:
                check_views("Dusk on", tok2, reply)
            r.log("  Dusk on: reply captured %s" % bool(reply.strip()))
            reply = None
        finally:
            cleanup_prayer(r)


# ============================================================================ stubs (Shae's S sittings / not adopted)

def _stub(tid, why):
    @test(tid, "AZ")
    def fn(r):
        checkpoint(r)
        inc(r, why)
    fn.__doc__ = why
    return fn


_stub("AZ-1", "S (Shae, S-B/S-C sitting): the prayer KEY opening the Thought input, a typed thought reaching her "
              "verbatim, and her voice with the inner effect need Shae's keyboard and ear (time plan §3.7, S 3)")
_stub("AZ-2", "S / A-K (Shae's sitting, S 4): the endings (key again = continue, Amen key / long-press, her cue, a "
              "spoken line) need key presses and typed lines; AZ-2 also decides whether the close trigger still sees "
              "the end-marker after the strip")
_stub("AZ-4", "= TT-9 + TT-13 + TT-14 (A9a re-run on the real layer with bystanders and a 3-speaker regression): "
              "Shae's S-B sittings 3-4; one run counts for both (time plan §3.7)")
_stub("AZ-9", "only if adopted (public tells, Shae A0-Q2); rides on AZ-4's bystanders in S-B")
_stub("AZ-12", "S (S 1.5): the plain-F1 slip mid-prayer is Shae typing a plain line; record what happens and "
               "whether any content reaches an NPC prompt or memory input")


# ============================================================================ offline controls: python tests_azura.py selfcheck

def _selfcheck():
    ok = [True]

    def check(c, what):
        ok[0] &= bool(c)
        print(("PASS " if c else "FAIL ") + what)
    rxs = [term_rx("Zarvox Keep"), term_rx("Quelmir"), term_rx("Ilth's Hollow")]
    check(hits("You will come to zarvox keep at last.", rxs) == {0}, "judge: multi-word term, case-insensitive")
    check(hits("Quelmir's shadow", rxs) == {1}, "judge: possessive of a one-word term")
    check(not hits("Quelmirs and zarvoxkeep and Quelmirion", rxs), "judge: no partial-word hits")
    check(hits("beyond ilth's   hollow", rxs) == {2}, "judge: apostrophe and extra spaces")
    check(not hits("", rxs) and not hits(None, rxs), "judge: empty reply")
    check(not any(hits(p, rxs) for p in PROBES) and len(PROBES) == 10, "probes: 10, none hits the synthetic terms")
    now = time.time()
    ts = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(now))
    old = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(now - 3600))
    log = "\n".join(["[%s.100] [1] [info] [a.cpp:1] before the window" % old,
                     "[%s.100] [1] [info] [a.cpp:1] (Dialogue) Someone: secret words" % ts,
                     "continuation of the secret",
                     "[%s.200] [2] [info] [b.cpp:2] Dusk: more" % old, ""])
    new, n = redact_text(log, [[now - 5, now + 5]])
    lines = new.split("\n")
    check(n == 3 and lines[0].endswith("before the window") and "secret" not in new and "more" not in new
          and lines[1].startswith("[%s.100] [1] [info] [a.cpp:1] " % ts) and lines[1].endswith(REDACTED),
          "redaction: window lines + continuation + a Dusk line outside the window (prefix kept)")
    check(redact_text(log, [])[1] == 1, "redaction: no window -> only the line naming Dusk")
    toks = stub_tokens()
    check(len(toks) >= 8, "AZ-5: %d identity stub tokens found in the test layer" % len(toks))
    src = layer_text("prompts/submodules/character_bio/0965_luc_dusk.prompt")
    check(all(h in src for h in ("### What has happened to her lately", "### Your journal of her prayers", "- Hour:",
                                 "### Your shrine", "Her standing in your worship")), "AZ-7: 0965 section names in the test layer")
    check(os.path.exists(JUDGE_FILE) and bool(load_judge()), "AZ-10: private judge file present (count only: %d)"
          % len(load_judge() or []))
    check(os.path.exists(AZ11_FILE), "AZ-11: private targets file present")
    return 0 if ok[0] else 1


if __name__ == "__main__":
    if sys.argv[1:] == ["selfcheck"]:
        sys.exit(_selfcheck())
    print(__doc__)
