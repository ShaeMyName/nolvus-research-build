"""luc_preview: a private console chat with Jenassa (adult follower, Skyrim.esm 000E1BA9 / base 000B9982),
using the same prompt pieces and OpenRouter routing the test install uses for scene text.

Shae plays Lucienne. Everything the app writes goes to ONE folder (default C:\\Users\\sharp\\Documents\\LucPreview).
Nothing is written into C:\\nolvus-research. The API key is read only from the environment variable
LUC_PREVIEW_OR_KEY at the moment of the HTTP call; it is never printed, logged, stored or put in an exception.

Run:  python -B luc_preview.py            (run_preview.bat does this)
Test: LUC_PREVIEW_STUB=1 returns canned text and makes no HTTP call at all (key not needed).
      LUC_PREVIEW_HOME=<dir> moves the private folder (used by the offline tests).
Stdlib only.
"""
import json
import os
import re
import sys
import time
import urllib.error
import urllib.request

# ---------------------------------------------------------------- paths (read-only sources)
MODS = "C:/Nolvus/Instances/Nolvus Awakening/MODS/mods"
SN = "SKSE/Plugins/SkyrimNet"
BASE_PROMPTS = f"{MODS}/SkyrimNet/{SN}/library/skyrimnet.base/prompts"
SCENE_TEXT = f"{MODS}/SkyrimNet - Scene Text/{SN}/external/shae.scene-text/prompts"
AUTHOR_PROMPT = (f"{MODS}/SkyrimNet - Privacy Overrides/{SN}/external/shae.privacy-overrides/prompts/"
                 "ieb_intimacy_author.prompt")
JENASSA_BIO = f"{BASE_PROMPTS}/characters/jenassa_BA9.prompt"
OPENROUTER_YAML = f"{MODS}/SkyrimNet Config - Test/{SN}/config/OpenRouter.yaml"
LUC_BIO = "C:/nolvus-research/lucienne/staging/lucienne_player_bio.prompt"

HOME = os.environ.get("LUC_PREVIEW_HOME") or "C:/Users/sharp/Documents/LucPreview"
STUB = os.environ.get("LUC_PREVIEW_STUB") == "1"
KEY_VAR = "LUC_PREVIEW_OR_KEY"
KEY_MESSAGE = 'setx LUC_PREVIEW_OR_KEY "<your OpenRouter key>"'

JENASSA_FORMID = 0x000E1BA9
ALLOWED_QUANT = ["fp8", "fp16", "bf16", "fp32"]      # fp8 or better; never fp4 (Shae, 2026-10-07)
HISTORY_MAX = 60                                      # messages sent per call (transcript keeps all)
MAX_CALLS = 400                                       # runaway guard per session, not a budget
DISPOSITION_PROMPT = (f"{MODS}/SkyrimNet Relationships/{SN}/external/deadohiosky48.relationships/prompts/"
                      "snrom_author_disposition.prompt")
BOND_PROMPT = (f"{MODS}/SkyrimNet Relationships/{SN}/external/deadohiosky48.relationships/prompts/submodules/"
               "character_bio/0330_relationships_bond.prompt")
MEMORY_PROMPT = f"{BASE_PROMPTS}/submodules/character_bio/7100_memories.prompt"
EVENT_HISTORY_PROMPT = f"{BASE_PROMPTS}/components/event_history.prompt"
ASKED_NAME = "Jenassa"
NOW = 1_000_000_000          # synthetic gameTimeNumeric (seconds); only differences matter


def say(s=""):
    print(s, flush=True)


def paths():
    return {
        "home": HOME,
        "profile": f"{HOME}/_PRIVATE_profile_jenassa.md",
        "disposition": f"{HOME}/disposition.json",
        "disp_hash": f"{HOME}/disposition.sha256",
        "disp_prompt": f"{HOME}/_PRIVATE_last_disposition_prompt.txt",
        "setup": f"{HOME}/scene_setup.txt",
        "prompt": f"{HOME}/_PRIVATE_last_system_prompt.txt",
        "author": f"{HOME}/_PRIVATE_last_profile_prompt.txt",
        "transcripts": f"{HOME}/transcripts",
    }


# Files holding the intimacy profile or a rendered prompt. Shae must not open them (DECISIONS.md:13, REVIEW_LOG RV-172),
# and nothing in this app prints their text to the console.
LEGACY_PRIVATE = ("profile_jenassa.md", "last_system_prompt.txt", "last_profile_prompt.txt", "last_disposition_prompt.txt")


def migrate_private_names():
    """Rename old-named profile/prompt files to the _PRIVATE_ names. Never reads them."""
    for old in LEGACY_PRIVATE:
        op, np_ = f"{HOME}/{old}", f"{HOME}/_PRIVATE_{old}"
        if os.path.exists(op):
            if os.path.exists(np_):
                np_ += ".old_" + time.strftime("%Y%m%d-%H%M%S")
            os.replace(op, np_)


def read(path):
    with open(path, encoding="utf-8") as f:
        return f.read()


def write_private(path, text):
    """Every write in the app goes through here and must land inside HOME."""
    ap = os.path.abspath(path)
    if not (ap == os.path.abspath(HOME) or ap.startswith(os.path.abspath(HOME) + os.sep)):
        raise RuntimeError("refusing to write outside the private folder")
    os.makedirs(os.path.dirname(ap), exist_ok=True)
    with open(ap, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


# ---------------------------------------------------------------- OpenRouter config (line-filtered)
WANTED_SCALARS = ("model_name", "model", "endpoint", "provider_sorting", "sort", "reasoning", "temperature",
                  "max_tokens")
LIST_KEYS = ("quantizations", "order", "only", "ignore")


def load_routing():
    """Read ONLY the default (dialogue/scene-text) settings of the TEST profile's OpenRouter.yaml.
    Scene text is the dialogue record: the config has no scene-specific variant and the Relationships
    authoring variant 'ieb_intimacy_author' is not configured, so both use the top-level settings
    (the template header says 'Pro 0813 on the dialogue record'). Parsing stops at 'variants:'. Any line
    containing 'key' (any case) is skipped before it is looked at; only the keys above are kept."""
    cfg = {"model": None, "endpoint": "https://openrouter.ai/api/v1/chat/completions", "sort": None,
           "quantizations": [], "order": [], "only": [], "ignore": [], "reasoning": False,
           "temperature": 0.7, "max_tokens": 4096}
    cur_list = None
    in_root = False
    for line in read(OPENROUTER_YAML).splitlines():
        if "key" in line.lower():
            continue
        if line.startswith("openrouter:"):
            in_root = True
            continue
        if in_root and line and not line.startswith(" "):
            break
        if not in_root:
            continue
        s = line.strip()
        if s.startswith("variants:"):
            break
        m = re.match(r"^- +(.+?)\s*$", s)
        if m and cur_list:
            cfg[cur_list].append(m.group(1).strip("\"'"))
            continue
        m = re.match(r"^([A-Za-z_]+):\s*(.*?)\s*$", s)
        if not m:
            continue
        k, v = m.group(1), m.group(2).strip("\"'")
        cur_list = k if (k in LIST_KEYS and v == "") else None
        if k in ("model_name", "model") and v and not cfg["model"]:
            cfg["model"] = v
        elif k == "endpoint" and v.startswith("https://openrouter.ai/"):
            cfg["endpoint"] = v
        elif k in ("provider_sorting", "sort") and v and v != "~" and not cfg["sort"]:
            cfg["sort"] = v
        elif k == "reasoning" and v.lower() in ("true", "false") and not cfg.get("_r"):
            cfg["reasoning"] = v.lower() == "true"
            cfg["_r"] = 1
        elif k == "temperature" and cfg.get("_t") is None:
            try:
                cfg["temperature"] = float(v)
                cfg["_t"] = 1
            except ValueError:
                pass
        elif k == "max_tokens" and cfg.get("_m") is None:
            try:
                cfg["max_tokens"] = int(v)
                cfg["_m"] = 1
            except ValueError:
                pass
    cfg.pop("_t", None)
    cfg.pop("_m", None)
    cfg.pop("_r", None)
    warn = []
    listed = [q.lower() for q in cfg["quantizations"]]
    kept = [q for q in listed if q in ALLOWED_QUANT]
    dropped = [q for q in listed if q not in ALLOWED_QUANT]
    if dropped:
        warn.append("config listed quantization(s) below fp8 (%s): dropped" % ", ".join(dropped))
    if not kept:
        kept = list(ALLOWED_QUANT)
        if not listed:
            warn.append("config sets no quantizations allowlist: using fp8+ (%s)" % ", ".join(kept))
    cfg["quantizations"] = kept
    cfg["warnings"] = warn
    if not cfg["model"]:
        raise RuntimeError("no model found in OpenRouter.yaml")
    if not cfg["sort"]:
        cfg["sort"] = "latency"
        warn.append("config sets no sort: using latency")
    return cfg


def provider_object(cfg):
    p = {"sort": cfg["sort"], "quantizations": cfg["quantizations"], "allow_fallbacks": True}
    if cfg["order"]:
        p["order"] = cfg["order"]
    if cfg["only"]:
        p["only"] = cfg["only"]
    if cfg["ignore"]:
        p["ignore"] = cfg["ignore"]
    return p


# ---------------------------------------------------------------- minimal Jinja-like renderer
class Undef:
    """Anything the renderer cannot resolve: falsy, empty, callable, attribute-able. Recorded."""
    seen = set()

    def __init__(self, name=""):
        self.name = name
        if name:
            Undef.seen.add(name)

    def __bool__(self): return False
    def __str__(self): return ""
    def __call__(self, *a, **k): return Undef(self.name + "()")
    def __getattr__(self, n):
        if n.startswith("__"):
            raise AttributeError(n)
        return Undef(self.name + "." + n)
    def __getitem__(self, i): return Undef(self.name + "[]")
    def __iter__(self): return iter(())
    def __len__(self): return 0


class AD(dict):
    def __getattr__(self, n):
        if n.startswith("__"):
            raise AttributeError(n)
        return self[n] if n in self else Undef("." + n)


def wrap(o):
    if isinstance(o, dict):
        return AD({k: wrap(v) for k, v in o.items()})
    if isinstance(o, list):
        return [wrap(v) for v in o]
    return o


class Scope(dict):
    def __missing__(self, k):
        return Undef(k)


TOKEN = re.compile(r"(\{#.*?#\}|\{%.*?%\}|\{\{.*?\}\})", re.S)
STRLIT = re.compile(r"\"[^\"]*\"|'[^']*'")
UNSUPPORTED = set()


def pyexpr(e):
    parts, last = [], 0
    for m in STRLIT.finditer(e):
        parts.append(re.sub(r"\btrue\b", "True", re.sub(r"\bfalse\b", "False",
                     re.sub(r"\bnone\b", "None", e[last:m.start()]))))
        parts.append(m.group(0))
        last = m.end()
    parts.append(re.sub(r"\btrue\b", "True", re.sub(r"\bfalse\b", "False", re.sub(r"\bnone\b", "None", e[last:]))))
    return "".join(parts).strip()


def ev(expr, scope):
    try:
        return eval(pyexpr(expr), {"__builtins__": {}}, scope)
    except Exception as e:
        UNSUPPORTED.add("expr[%s]: %s" % (expr.strip()[:60], type(e).__name__))
        return Undef()


def _body(stack_entry):
    kind, node = stack_entry
    if kind == "root":
        return node
    if kind == "if":
        return node[2] if node[2] is not None else node[1][-1][1]
    return node[3]


def parse2(src):
    """Proper nesting: re-implementation of parse() that always appends to the active body."""
    root = []
    stack = [("root", root)]
    for tok in TOKEN.split(src):
        if not tok or tok.startswith("{#"):
            continue
        cur = _body(stack[-1])
        if tok.startswith("{{"):
            cur.append(("out", tok[2:-2].strip("- ")))
        elif tok.startswith("{%"):
            body = tok[2:-2].strip("- ").strip()
            word = body.split(None, 1)[0] if body else ""
            rest = body[len(word):].strip()
            if body.startswith("else if"):
                word, rest = "elif", body[7:].strip()
            if word == "if":
                node = ["if", [[rest, []]], None]
                cur.append(node)
                stack.append(("if", node))
            elif word == "elif":
                stack[-1][1][1].append([rest, []])
            elif word == "else":
                stack[-1][1][2] = []
            elif word in ("endif", "endfor"):
                stack.pop()
            elif word == "set":
                name, _, val = rest.partition("=")
                cur.append(("set", name.strip(), val.strip()))
            elif word == "for":
                m = re.match(r"(\w+)\s+in\s+(.+)", rest)
                node = ["for", m.group(1) if m else "_", m.group(2) if m else "[]", []]
                cur.append(node)
                stack.append(("for", node))
            else:
                UNSUPPORTED.add("tag[%s] stripped" % word)
        else:
            cur.append(("text", tok))
    return root


def run(nodes, scope, out):
    for n in nodes:
        if n[0] == "text":
            out.append(n[1])
        elif n[0] == "out":
            out.append(str(ev(n[1], scope)))
        elif n[0] == "set":
            scope[n[1]] = ev(n[2], scope)
        elif n[0] == "if":
            for cond, body in n[1]:
                if ev(cond, scope):
                    run(body, scope, out)
                    break
            else:
                if n[2] is not None:
                    run(n[2], scope, out)
        elif n[0] == "for":
            for i, item in enumerate(ev(n[2], scope) or []):
                scope[n[1]] = item
                scope["loop"] = AD({"index": i + 1, "index0": i})
                run(n[3], scope, out)


def tidy(text):
    text = "\n".join(l.strip() for l in text.replace("\r\n", "\n").split("\n"))
    return re.sub(r"\n{3,}", "\n\n", text).strip("\n")


def render(src, scope):
    out = []
    run(parse2(src), scope, out)
    return tidy("".join(out))


# ---------------------------------------------------------------- the world the templates see
def bio_blocks(text):
    return {m.group(1): m.group(2).strip() for m in re.finditer(r"\{% block (\w+) %\}(.*?)\{% endblock %\}", text, re.S)}


def make_world(profile_text="", scn=None, d=None):
    jen = bio_blocks(read(JENASSA_BIO))
    luc = bio_blocks(read(LUC_BIO))
    base = {"isChild": False, "isVirtual": False, "isVirtualPrivate": False, "isInCombat": False, "isFemale": True,
            "gender": "female", "race": "Dunmer", "subjectivePronoun": "she", "possessivePronoun": "her",
            "objectivePronoun": "her", "universalTranslatorSpeechPattern": ""}
    people = wrap({"jenassa": dict(base, UUID="jenassa", name="Jenassa"),
                   "player": dict(base, UUID="player", name="Lucienne")})
    blocks = {"jenassa": jen, "player": luc}
    store = {("player", "IEB_SceneMode"): 1, ("jenassa", "IEB_IsScenePartner"): 1,
             ("player", "IEB_ScenePrivate"): 1, ("jenassa", "IEB_IntimacyProfile"): profile_text}

    def decnpc(u): return people.get(str(u), Undef("decnpc"))

    def rcp(mode, u):
        b = blocks.get(str(u), {})
        if mode.startswith("bio_"):
            t = b.get(mode[4:], "")
            return (t + "\n") if t else ""
        if mode == "speech_style":
            t = b.get("speech_style", "")
            return ("## Speech Profile of %s\n%s\n" % (people[str(u)].name, t)) if t else ""
        return ""

    def papyrus_util(fn, form, key, default=0):
        return store.get((str(form), key), default)

    tier = scn["tier"] if scn else 0
    memories, events = [], []
    rom = AD({})
    if scn:
        for m in scn["memories"]:
            memories.append(AD({"isOwn": True, "originName": "Jenassa", "memory": AD({
                "content": m["text"], "emotion": m["emotion"], "importance_score": m["importance"],
                "game_time": NOW - m["age"], "season": "unknown", "tags": ""})}))
        n = len(scn["events"])
        for i, e in enumerate(scn["events"]):
            who = {"jenassa": "jenassa", "lucienne": "player"}.get(e["who"])
            events.append(AD({"type": "dialogue" if who else "direct_narration", "originatingActor": who or "player",
                              "targetActor": ("player" if who == "jenassa" else "jenassa") if who else "",
                              "location": scn["location"], "gameTime": NOW - (n - i) * 45,
                              "gameTimeStr": scn["time"], "text": e["text"], "data": AD({"speaker": ""})}))
    if d is not None:
        rom = AD({"enrolled": True, "sparked": 1, "romanceOk": 1 if not romance_foreclosed(d) else 0,
                  "romanceNA": 3 if romance_foreclosed(d) else 0, "stance": 1, "physMinTier": d["min_tier"],
                  "why": d["disp_why"], "limit": d["disp_limit"], "exclusivity": d["excl"], "otherPartners": 0,
                  "address": "", "orientation": d["disp_orientation"],
                  "toNext": max(0, 500 * (tier + 1) - (scn["points"] if scn else 0))})

    scope = Scope()
    scope.update({
        "render_mode": "full", "actorUUID": "jenassa", "npc": people["jenassa"], "player": people["player"],
        "responseTarget": AD({"type": "player", "UUID": "player"}),
        "decnpc": decnpc, "render_character_profile": rcp, "papyrus_util": papyrus_util,
        "is_narration_enabled": lambda: True, "is_player": lambda u: str(u) == "player",
        "get_linked_identities": lambda u: [], "exists": lambda n: n in ("npc", "responseTarget"),
        "existsIn": lambda o, k: isinstance(o, dict) and k in o,
        "get_faction_rank": lambda *a: tier, "formid_to_uuid": lambda f: "jenassa",
        "has_line_of_sight": lambda *a: True, "actor_has_keyword": lambda *a: True,
        "get_worn_equipment": lambda u: AD({"torso": "clothing"}), "get_nearby_npc_list": lambda u: [],
        "length": len, "join": lambda l, s: s.join(l), "append": lambda l, x: list(l) + [x],
        "contains": lambda a, b: b in a, "lower": lambda x: str(x).lower(),
        "default": lambda a, b: b if (isinstance(a, Undef) or a is None) else a,
        "is_plugin_loaded": lambda n: n == "SNRom_Integration.esl", "get_romance": lambda u: rom,
        "romance_physical_ok": lambda u: "true" if (d is not None and 0 <= d["min_tier"] <= tier
                                                    and not romance_foreclosed(d)) else "false",
        "get_relevant_memories": lambda *a: memories, "season": "unknown", "gameTimeNumeric": NOW,
        "get_recent_events": lambda *a: events, "get_event_history_count": lambda *a: 50,
        "format_event": lambda e, mode: e.text, "get_name": lambda u: people[str(u)].name if str(u) in people else "",
        "isValidActor": lambda u: str(u) in people, "get_location": lambda u: scn["location"] if scn else "",
        "location": scn["location"] if scn else "",
        "render_subcomponent": lambda name, mode: render_sub(name, mode, scope),
    })
    return scope, blocks


def render_sub(name, mode, scope):
    """Render a submodule directory the way SkyrimNet does: all files in name order (layer files override a
    base file of the same name). Only the 'guidelines' directory is rendered this way by this app."""
    files = {}
    for root in (f"{BASE_PROMPTS}/submodules/{name}", f"{SCENE_TEXT}/submodules/{name}"):
        if os.path.isdir(root):
            for f in os.listdir(root):
                if f.endswith(".prompt"):
                    files[f] = os.path.join(root, f)
    sub = Scope(scope)
    sub["render_mode"] = mode
    return "\n".join(render(read(files[f]), sub) for f in sorted(files))


def render_file(path, scope):
    return render(read(path), scope)


# ---------------------------------------------------------------- prompt assembly
# ---------------------------------------------------------------- scenario (synthetic game state)
DEFAULT_SCENE = """# Jenassa preview scenario. Edit freely; /scene writes a fresh one. Lines starting with # are ignored.
# Keep it free of quest or story content. Memory lines: age | emotion | importance 1-10 | text.
# RECENT_EVENTS lines: "Jenassa: ...", "Lucienne: ..." (spoken) or "* ..." (narration). They go into the chat history.
LOCATION: The Bannered Mare, Upstairs Room, Whiterun, Hold: Whiterun
TIME: 11:48 PM, Fredas, 21st of Last Seed, 4E 201
DAYPART: night
WEATHER: Heavy rain
NEARBY:
SCENE:
- Lucienne and Jenassa are alone in a rented upstairs room; the door is bolted
- Jenassa is sitting on a Chair
ACTIONS:
- **Lucienne** opened Door (happened a while ago)
- **Jenassa** sat down on Chair (happened moments ago)
BOND_TIER: 4
BOND_POINTS: 2150
MEMORIES:
- 6 weeks ago | wary | 6 | Lucienne hired me at the Drunken Huntsman for 500 gold. Blade and shadow, silence and death: my arts for her coin.
- 3 weeks ago | fierce | 8 | In a barrow full of draugr a blade came down at my back and Lucienne stepped between us and took it on her shield. I had not expected that.
- 12 days ago | quiet | 7 | At a campfire on the road she asked me about Morrowind, and I told her more than I tell most. She listened without once looking away.
- 2 days ago | satisfied | 6 | We cleared another barrow together and came back to Whiterun with more coin than either of us had counted on.
RECENT_EVENTS:
* Rain hammers the shutters of the rented room. Whiterun is quiet below.
Jenassa: Dry at last. That barrow's damp will be in my bones for a week.
Lucienne: Then sit, and let me see to it.
"""

CANNED_SCENE = DEFAULT_SCENE.replace("The Bannered Mare, Upstairs Room, Whiterun, Hold: Whiterun",
                                     "A road-side camp east of Whiterun, Hold: Whiterun").replace("Heavy rain", "Clear and cold") \
    .replace("(stub scenario)", "")

SCENE_FIELDS = ("LOCATION", "TIME", "DAYPART", "WEATHER", "NEARBY", "SCENE", "ACTIONS", "BOND_TIER", "BOND_POINTS",
                "MEMORIES", "RECENT_EVENTS")
AGE_UNITS = {"hour": 3600, "day": 86400, "week": 7 * 86400, "month": 30 * 86400, "minute": 60}


def parse_scenario(text):
    """scene_setup.txt -> dict. Raises ValueError when LOCATION/TIME/WEATHER or the memories are missing."""
    f, cur = {k: [] for k in SCENE_FIELDS}, None
    for raw in text.splitlines():
        line = raw.rstrip()
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        m = re.match(r"^([A-Z_]+):\s*(.*)$", line)
        if m and m.group(1) in SCENE_FIELDS:
            cur = m.group(1)
            if m.group(2):
                f[cur].append(m.group(2).strip())
        elif cur:
            f[cur].append(line[2:].strip() if line.startswith("- ") else line.strip())
    one = lambda k: f[k][0] if f[k] else ""
    if not (one("LOCATION") and one("TIME") and one("WEATHER")):
        raise ValueError("LOCATION, TIME and WEATHER are required")
    mem = []
    for ln in f["MEMORIES"]:
        parts = [x.strip() for x in ln.split("|", 3)]
        if len(parts) != 4:
            continue
        am = re.match(r"(\d+)\s*(minute|hour|day|week|month)s?\s*ago", parts[0])
        age = int(am.group(1)) * AGE_UNITS[am.group(2)] if am else 86400
        mem.append({"age": age, "emotion": parts[1], "importance": _clamp(parts[2], 1, 10, 5), "text": parts[3]})
    if not mem:
        raise ValueError("at least one memory line (age | emotion | importance | text) is required")
    ev_ = []
    for ln in f["RECENT_EVENTS"]:
        m = re.match(r"^(Jenassa|Lucienne):\s*(.+)$", ln)
        if m:
            ev_.append({"who": m.group(1).lower(), "text": m.group(2).strip()})
        else:
            ev_.append({"who": "", "text": ln.lstrip("* ").strip()})
    return {"location": one("LOCATION"), "time": one("TIME"), "daypart": one("DAYPART") or "night",
            "weather": one("WEATHER"), "nearby": f["NEARBY"], "scene": f["SCENE"], "actions": f["ACTIONS"],
            "tier": _clamp(one("BOND_TIER") or "4", 0, 6, 4), "points": _clamp(one("BOND_POINTS") or "2150", 0, 99999, 2150),
            "memories": mem, "events": ev_}


INDOOR_WORDS = ("room", "inn", "house", "tavern", "cellar", "cabin", "hall", "keep", "shrine hostel", "interior")


def time_of_day_line(scn):
    """The bullet under '## Current Time'. Thresholds and wording: scene_context.prompt:36-44 (SkyrimNet base),
    keyed on gameTimeJson.hour, which here is read from the scenario TIME text (e.g. '11:48 PM'). When the hour
    cannot be read, the DAYPART word picks the nearest bullet (own mapping, no source)."""
    m = re.match(r"\s*(\d{1,2}):\d{2}\s*([AaPp][Mm])", scn["time"])
    if m:
        h = int(m.group(1)) % 12 + (12 if m.group(2).lower() == "pm" else 0)
    else:       # own wording, no source: DAYPART word -> an hour
        h = {"morning": 8, "afternoon": 14, "evening": 19}.get(scn["daypart"].lower(), 23)
    if h >= 22 or h <= 5:
        return "- It's currently late at night - most people would be sleeping"      # scene_context.prompt:37
    if 6 <= h <= 11:
        return "- It's currently morning time"                                       # :39
    if 12 <= h <= 17:
        return "- It's currently afternoon"                                          # :41
    return "- It's currently evening."                                               # :43


def weather_block(scn):
    """'## Current Weather' per scene_context.prompt:47-59. The game reads isRaining/isSnowing/windSpeed from the
    weather record; here they are read from the WEATHER words of the scenario. is_indoors is guessed from the
    location name (INDOOR_WORDS: own guess, no source). Wording of both sentences and the italic lines is the template's."""
    w, loc = scn["weather"], scn["location"].lower()
    low = w.lower()
    indoors = any(re.search(r"\b%s\b" % x, loc) for x in INDOOR_WORDS) and "camp" not in loc
    rain, snow = "rain" in low or "storm" in low, "snow" in low or "blizzard" in low
    out = "**Weather**: " + ("You are indoors and sheltered from the weather. Outside, it is " if indoors else "") + w
    out += " (Raining)" if rain else (" (Snowing)" if snow else "")
    pre = "Outside, " if indoors else ""
    if rain and snow:
        out += "\n*%sA harsh storm is raging with both rain and snow*" % pre
    elif rain:
        out += "\n*%sRain is falling, making outdoor activities unpleasant*" % pre
    elif snow:
        out += "\n*%sSnow is falling, creating a winter atmosphere*" % pre
    elif "wind" in low:
        out += "\n*%sStrong winds are blowing*" % pre
    return "## Current Weather\n" + out


def scene_context_block(scn):
    """get_scene_context(npc, target, "full") is a native (C++) decorator (DLL strings: 'get_scene_context',
    'components\\context\\scene_context_'). It renders the layout components/context/scene_context_full.prompt with the
    block bodies of components/context/scene_context.prompt, so the section order is that of scene_context_full.prompt
    (:3-22): Scene Information (location, time), weather, Nearby People, Recent Events (only when there are short-lived
    events), Scene Summary. The scenario text is the game state the blocks would read; headings and sentences are the
    templates'. Built here, not rendered."""
    out = ["## Scene Information\n"                                                       # scene_context_full.prompt:3-4
           "## Current Location\nThe scene is taking place in **%s**" % scn["location"],  # scene_context.prompt:30-31
           "## Current Time\n**Time**: %s\n\n%s" % (scn["time"], time_of_day_line(scn)),   # :33-44
           weather_block(scn)]
    near = [x for x in scn["nearby"] if x.lower() not in ("none", "no one", "nobody")]
    out.append("## Nearby People\n" + ("\n".join("%d. %s" % (i + 1, x) for i, x in enumerate(near))   # :15-23
                                       if near else "No one else is nearby."))                      # :25
    if scn["actions"]:                                                                    # scene_context_full.prompt:14-18
        # component_recent_events.prompt:12 prefixes "- "; the event text is the DLL's recent_events format
        # '**{{ actor }}** ... ({{ time_desc }})'; time_desc words ('happened moments ago') are the DLL's.
        out.append("## Recent Events\n" + "\n".join(
            "- " + a.lstrip("- ") + ("" if "(" in a else " (happened moments ago)") for a in scn["actions"]))
    if scn["scene"]:       # npcStateSummary block, component_npc_state_summary.prompt: "- {{ npc.name }} is ..." lines
        out.append("## Scene Summary\n" + "\n".join("- " + x.lstrip("- ") for x in scn["scene"]))
    return "\n\n".join(out)


def physical_activity(name, scn):
    """'## Physical Activity' (character_bio/0050_physical_activity.prompt:12-33). The furniture case (:23-24) is read
    from a scenario SCENE line of the form '<name> is sitting on a Chair' / 'lying down in a Bed'; otherwise the
    template's default standing line (:32)."""
    for x in scn["scene"]:
        m = re.match(r"^%s is (?:sitting (?:on|at|upon)|lying down in) (?:an? |the )?(?:edge of (?:an? |the )?)?(.+?)\s*$"
                     % re.escape(name), x.lstrip("- "))
        if m:
            return "## Physical Activity\n- %s is currently using a %s." % (name, m.group(1))
    return "## Physical Activity\n- %s is currently standing, able to move normally." % name


def history_prefix(scope):
    """The synthetic recent events, rendered by the REAL components/event_history template into chat messages."""
    text = render(read(EVENT_HISTORY_PROMPT), scope)
    msgs = []
    for m in re.finditer(r"\[ (user|assistant) \]\n(.*?)\n?\[ end \1 \]", text, re.S):
        body = "\n".join(l.strip() for l in m.group(2).splitlines() if l.strip())
        if body:
            msgs.append({"role": m.group(1), "content": body})
    return merge_roles(msgs)


def merge_roles(msgs):
    out = []
    for m in msgs:
        if out and out[-1]["role"] == m["role"]:
            out[-1] = {"role": m["role"], "content": out[-1]["content"] + "\n" + m["content"]}
        else:
            out.append(dict(m))
    return out


# ---------------------------------------------------------------- prompt assembly
def build_system(profile, scn, d, luc_full=False):
    """Returns (system, prefix_messages, final_instructions)."""
    scope, blocks = make_world(profile, scn, d)
    j = blocks["jenassa"]
    # Section order = the numbered files of submodules/system_head (rendered by render_subcomponent("system_head", "full")
    # in dialogue_response.prompt:3), after the opening line of dialogue_response.prompt:2:
    #   0010_instructions, 0010_setting, 0020_format_rules, 0100_actor_bios (speaker profile, then the addressed person's),
    #   0200_scene_context (native get_scene_context), [0150 telepathy, 0210 visible attire, 0250 omnisight, 0260 traveling
    #   party: all print nothing in this scenario, see their conditions], 0400_speech_style_bio.
    sections = []
    sections.append("You are Jenassa, a female Dunmer in Skyrim. You are speaking to Lucienne, a female Dunmer.")  # dialogue_response.prompt:2
    sections.append(render_file(f"{BASE_PROMPTS}/submodules/system_head/0010_instructions.prompt", scope))
    sections.append(render_file(f"{BASE_PROMPTS}/submodules/system_head/0010_setting.prompt", scope))
    sections.append(render_file(f"{SCENE_TEXT}/submodules/system_head/0020_format_rules.prompt", scope))
    # character bio, in the numbered order of submodules/character_bio (0010 header .. 7100 memories)
    bio = ["## Jenassa's Character Profile (THIS IS WHO YOU ARE ROLEPLAYING AS)",             # 0010_header.prompt:3
           # 0010_header.prompt:18-19 (gender, race), :44 health, :79 energy (the healthy / rested cases). The Magic
           # line (:47-66) is not printed for her: her magicka is not known to this app.
           "- Gender: female\n- Race: Dunmer\n- Health: Healthy and uninjured\n- Energy: Energetic and ready for action",
           physical_activity("Jenassa", scn),                                                # 0050_physical_activity.prompt
           "## Jenassa - Character Summary\n" + j.get("summary", ""),                        # 0100_summary.prompt:9
           # 0175_severactions_follower.prompt:15-20 (SeverActions mod, character_bio). Its feelings / combat / behaviour
           # sub-sections are not rendered (they read SeverActions state this app does not have).
           "## Your Role as Companion\n\nYou are currently traveling with Lucienne as their companion.",
           "## Background\n" + j.get("background", ""),
           "## Personality & Psychology\n" + j.get("personality", ""),
           "### Interject Summary (Things that Jenassa thinks are interesting and will respond to).\n"
           + j.get("interject_summary", ""),
           "## Goals & Aspirations\n" + j.get("aspirations", ""),
           render_file(BOND_PROMPT, scope),                                                  # 0330 (Relationships mod)
           render_file(f"{SCENE_TEXT}/submodules/character_bio/0335_ieb_intimacy_profile.prompt", scope),
           "## Appearance & Physical State\n" + j.get("appearance", ""),
           "## Skills & Combat\n" + j.get("skills", ""),
           # 0600_relationships.prompt:8, 15-17 (follower branch)
           "## Relationships\n" + j.get("relationships", "") + "\n### Travel History with Lucienne\n"
           "- Jenassa is a member of Lucienne's party, and is currently actively traveling in the group.",
           "## Occupation\n" + j.get("occupation", ""),
           "## Long Term Memories and Plot Progression\n" + render_file(MEMORY_PROMPT, scope)]
    sections.append("\n\n".join(b for b in bio if b.strip()))
    lb = blocks["player"]
    # dialogue_target render mode (0010_header.prompt:4-15 heading, :16-19 gender/race, :44 health, :63 magic (player always
    # gets the line), :79 energy; 0050 physical activity; 0100 summary; 0400 appearance). Worn equipment (0410) and the
    # 0412 visible-attire fact are not printed: no equipment is modelled and the torso slot counts as covered.
    luc = ["## Lucienne's Character Profile (THIS IS WHO YOU'RE TALKING TO)",
           "- Gender: female\n- Race: Dunmer\n- Health: Healthy and uninjured\n- Magic: Full of magical energy\n"
           "- Energy: Energetic and ready for action",
           physical_activity("Lucienne", scn),
           "## Lucienne - Character Summary\n" + lb.get("summary", ""),
           "## Appearance & Physical State\n" + lb.get("appearance", "")]
    if luc_full:   # LUC_PREVIEW_LUC_FULL=1: also her private blocks (Jenassa would NOT see these in game)
        for k, h in (("background", "Background"), ("personality", "Personality & Psychology"),
                     ("aspirations", "Goals & Aspirations"), ("relationships", "Relationships"),
                     ("occupation", "Occupation"), ("skills", "Skills & Combat")):
            if lb.get(k):
                luc.append("## %s\n%s" % (h, lb[k]))
    sections.append("\n\n".join(luc))
    sections.append(scene_context_block(scn))        # 0200_scene_context.prompt -> native get_scene_context(..., "full")
    sections.append(render_file(f"{BASE_PROMPTS}/submodules/system_head/0400_speech_style_bio.prompt", scope))
    system = "\n\n".join(x for x in sections if x.strip())
    finals = [render_file(f"{BASE_PROMPTS}/submodules/user_final_instructions/0500_response_format.prompt", scope),
              render_file(f"{SCENE_TEXT}/submodules/user_final_instructions/0760_visible_actions.prompt", scope),
              render_file(f"{SCENE_TEXT}/submodules/user_final_instructions/9900_ieb_scene_pov.prompt", scope)]
    final = "\n\n".join(f for f in finals if f.strip()) + "\n\nRespond in character now."
    return system, history_prefix(scope), final


def generate_scene(cfg, p, current_text):
    """/scene: one call. Returns the validated scenario text."""
    try:
        prev = parse_scenario(current_text)["location"]
    except ValueError:
        prev = ""
    sysmsg = (
        "You write scenario files for a private, adult fantasy roleplay preview set in Skyrim. The fixed cast is Jenassa "
        "(an adult Dunmer mercenary, hired follower) and Lucienne (an adult Dunmer mage, the player). Output ONLY a scenario "
        "file in exactly the layout of the example, with no commentary and no code fences.\n\nRULES\n"
        "- Invent a fresh, plausible, ordinary setting (an inn room, a camp on the road, a rented house, a quiet corner of a "
        "fort, a shrine hostel). Pick a different place, time of night or day, and weather from the previous one.\n"
        "- Jenassa and Lucienne are alone and in private. Nobody else is in the room or within earshot (NEARBY stays empty or "
        "lists only distant background people).\n"
        "- BOND_TIER stays 4 (Lover); BOND_POINTS stays between 2000 and 2400.\n"
        "- Write 3 or 4 shared MEMORIES (age | emotion | importance | text, in Jenassa's first-person voice): the hire; a fight "
        "where one covered the other; a quiet talk at a campfire; optionally one more everyday moment.\n"
        "- RECENT_EVENTS: 2 to 4 lines, ending on a beat that leaves Lucienne to speak next.\n"
        "- ABSOLUTELY NO quest content: no named quests, quest stages, factions' questlines, prophecies, story events, named "
        "plot characters or plot twists. Only travel, weather, inns, wilderness, ordinary fights, coin and conversation.\n"
        "- Keep the comment lines at the top.\n\nEXAMPLE LAYOUT (change the content, keep the layout)\n" + DEFAULT_SCENE)
    usermsg = "Write a new scenario now." + (" Previous location (do not reuse): %s." % prev if prev else "")
    for attempt in (1, 2):
        text = chat_call(cfg, [{"role": "system", "content": sysmsg}, {"role": "user", "content": usermsg}], max_tokens=1500)
        text = re.sub(r"^```\w*\n|\n```\s*$", "", text.strip())
        try:
            parse_scenario(text)
            return text.strip() + "\n"
        except ValueError as e:
            last = e
    raise ApiFailure("scenario not usable (%s)" % last)


def build_author_messages(disp):
    scope, _ = make_world("")
    scope.update({"npc_name": "Jenassa", "npc_formid": JENASSA_FORMID})
    scope.update({k: disp[k] for k in ("disp_orientation", "disp_intimacy", "disp_ardor", "disp_exclusivity",
                                       "disp_why", "disp_limit")})
    text = read(AUTHOR_PROMPT)
    # split on the [ system ] / [ user ] markers BEFORE rendering, so the header comment is dropped cleanly
    parts = re.split(r"^\[ (system|user) \]\s*$", text, flags=re.M)
    msgs = []
    for i in range(1, len(parts), 2):
        msgs.append({"role": parts[i], "content": render(parts[i + 1], scope)})
    return msgs


# ---------------------------------------------------------------- model call
CANNED_REPLIES = [
    "Jenassa studies you a moment. \"You talk like you expect to be answered.\" *She sets her blade aside, unhurried.*",
    "\"Good. I dislike being asked twice.\" *Her hand finds your wrist and stays there.*",
    "\"Then show me.\" *She watches your mouth, not your eyes.*",
]
CANNED_PROFILE = (
    "1. Body and appearance\nLean, ash-grey, scarred across the ribs; stubbornly tidy.\n\n"
    "2. Preferences and kinks\nPrefers to be met as an equal; likes being pinned only when she chose it.\n\n"
    "3. Limits\nHard: ownership talk. Soft: affection shown before others.\n\n"
    "4. Behaviour and pacing in intimate scenes\nSlow, watchful, decisive once she has decided; leads when unsure.\n\n"
    "5. How she talks during intimacy\nLow, dry, economical. \"Stay where you are.\" \"Again, but slower.\"\n"
    "(stub text for offline tests)")
CANNED_DISPOSITION = (
    "NAME: Jenassa\nSEXUAL_ORIENTATION: ATTRACTED_TO_BOTH\nSEXUAL_ORIENTATION_BASIS: UNKNOWN\nINTIMACY: ROMANTIC\n"
    "ARDOR: MEASURED\nEXCLUSIVITY: CONVENTIONAL\n"
    "WHY: She gives loyalty slowly and the rest only after it has been tested in blood.\n"
    "LIMIT: She will not be bought or ordered, and walks the moment she is treated as hired steel in bed.")
_calls = {"n": 0}


class ApiFailure(Exception):
    pass


def chat_call(cfg, messages, max_tokens=None):
    _calls["n"] += 1
    if _calls["n"] > MAX_CALLS:
        raise ApiFailure("call limit for this session reached")
    if STUB:
        if messages and "scenario files for a private" in messages[0]["content"]:
            return CANNED_SCENE
        if messages and "matters of the heart" in messages[0]["content"]:
            return os.environ.get("LUC_PREVIEW_STUB_DISP") or CANNED_DISPOSITION
        is_profile = bool(messages) and messages[0]["role"] == "system" and "private character notes" in messages[0]["content"]
        if is_profile:
            return CANNED_PROFILE
        return CANNED_REPLIES[(_calls["n"] - 1) % len(CANNED_REPLIES)]
    key = os.environ.get(KEY_VAR)
    if not key:
        raise ApiFailure("missing key")
    body = {"model": cfg["model"], "messages": messages, "temperature": cfg["temperature"],
            "max_tokens": max_tokens or cfg["max_tokens"], "provider": provider_object(cfg),
            "reasoning": {"enabled": bool(cfg["reasoning"])}}
    data = json.dumps(body).encode("utf-8")
    last = "error"
    for attempt in (1, 2):
        req = urllib.request.Request(cfg["endpoint"], data=data, method="POST", headers={
            "Content-Type": "application/json", "Authorization": "Bearer " + key,
            "X-Title": "luc_preview"})
        try:
            with urllib.request.urlopen(req, timeout=120) as r:
                j = json.loads(r.read().decode("utf-8"))
            text = j["choices"][0]["message"]["content"]
            if not isinstance(text, str) or not text.strip():
                raise ApiFailure("empty reply")
            return re.sub(r"<think>.*?</think>", "", text, flags=re.S).strip()
        except urllib.error.HTTPError as e:           # type + status code only, never the message/headers
            last = "HTTPError %s" % e.code
            if e.code in (429, 500, 502, 503, 504) and attempt == 1:
                time.sleep(3)
                continue
            raise ApiFailure(last) from None
        except ApiFailure:
            raise
        except Exception as e:                        # exception TYPE only
            last = type(e).__name__
            if attempt == 1 and last in ("URLError", "TimeoutError", "timeout", "ConnectionError"):
                time.sleep(3)
                continue
            raise ApiFailure(last) from None
    raise ApiFailure(last)


# ---------------------------------------------------------------- profile
# --- the game's own parsing rules, ported from SNRom_Decorators.psc / SNRom_Bridge.psc (read-only source) ---
def _trim(t):
    return t.strip(" ")


def _unquote(v):                                   # SNRom_Decorators.Unquote
    v = _trim(v)
    if v.endswith(","):
        v = _trim(v[:-1])
    if len(v) >= 2 and ((v[0] == '"' and v[-1] == '"') or (v[0] == "'" and v[-1] == "'")):
        v = _trim(v[1:-1])
    return v


def field_value(resp, key):                        # SNRom_Decorators.FieldValue: first match, case-sensitive
    at, skip = resp.find(key), len(key)
    if at < 0:
        bare = key[:-1]
        for alt in (bare + "':", bare + '":'):
            at, skip = resp.find(alt), len(alt)
            if at >= 0:
                break
    if at < 0:
        return ""
    rest = resp[at + skip:]
    nl = rest.find("\n")
    return _unquote(rest[:nl] if nl >= 0 else rest)


def _clamp(text, lo, hi, fallback):                # ClampInt: digits only, else the fallback
    t = _trim(text)
    if not t or not all(48 <= ord(c) <= 57 for c in t):
        return fallback
    return max(lo, min(hi, int(t)))


def basis_to_int(w):
    w = _trim(w).upper()
    return 2 if w == "STATED" else 1 if w == "IMPLIED" else 0


def orientation_to_int(w):
    w = _trim(w).upper()
    if w in ("ATTRACTED_TO_MEN", "MEN"):
        return 1
    if w in ("ATTRACTED_TO_WOMEN", "WOMEN"):
        return 2
    if w in ("ATTRACTED_TO_BOTH", "ANY", "BOTH"):
        return 3
    if w in ("ATTRACTED_TO_NEITHER", "NONE", "NEITHER"):
        return 0
    return 3


def intimacy_to_mintier(w):
    return {"NEVER": -1, "GUARDED": 5, "ROMANTIC": 4, "CASUAL": 2}.get(_trim(w).upper(), 4)


def ardor_to_int(w):
    w = _trim(w).upper()
    names = ["RESERVED", "MEASURED", "WARM", "OPEN", "INTENSE"]
    return names.index(w) if w in names else _clamp(w, 0, 4, 2)


def exclusivity_to_int(w):
    w = _trim(w).upper()
    m = {"UNTROUBLED": 0, "ACCEPTING": 25, "TOLERANT": 25, "CONVENTIONAL": 50, "POSSESSIVE": 75, "CONSUMING": 100}
    return m[w] if w in m else _clamp(w, 0, 100, 50)


def _name_core(n):                                 # NameCore: upper-case, non-letters stripped from both ends
    return re.sub(r"^[^A-Z]+|[^A-Z]+$", "", n.upper())


def intimacy_word(min_tier):                       # IntimacyWordFromTier
    return "NEVER" if min_tier < 0 else "GUARDED" if min_tier >= 5 else "ROMANTIC" if min_tier == 4 else "CASUAL"


def ardor_word(a):                                 # ArdorWord (the text the intimacy-author prompt is given)
    return ("reserved and undemonstrative" if a <= 0 else "measured, showing little" if a == 1 else
            "warm but not effusive" if a == 2 else "open about what she feels" if a == 3 else
            "intense and unmistakable")


def derive(rec):
    """Numbers the game would store, from the words in disposition.json (the same mappers ApplyCharacter uses)."""
    d = {"orient": orientation_to_int(rec.get("orientation", "")), "basis": basis_to_int(rec.get("basis", "")),
         "min_tier": intimacy_to_mintier(rec.get("intimacy", "")), "ardor": ardor_to_int(str(rec.get("ardor", ""))),
         "excl": exclusivity_to_int(str(rec.get("exclusivity", "")))}
    d["bypass"] = 1 if _trim(rec.get("intimacy", "")).upper() == "CASUAL" else 0
    # SNRom_Decorators.OrientationWord: "" unless the basis is STATED
    d["disp_orientation"] = "" if d["basis"] < 2 else {1: "men", 2: "women", 0: "no one"}.get(d["orient"], "both men and women")
    d["disp_intimacy"] = intimacy_word(d["min_tier"])
    d["disp_ardor"] = ardor_word(d["ardor"])
    d["disp_exclusivity"] = d["excl"]
    d["disp_why"] = rec.get("why", "")
    d["disp_limit"] = rec.get("limit", "")
    return d


def romance_foreclosed(d):
    """RomanceApplicability (adult, unmarried, player is female): only a STATED orientation that excludes her."""
    if d["basis"] < 2:
        return False
    return d["orient"] in (0, 1)


def parse_disposition(resp):
    """DispositionAuthored + ApplyCharacter + ApplyProse for an adult. Raises ApiFailure on echo mismatch or a
    reply that died before EXCLUSIVITY (the game discards both and falls back to an archetype)."""
    echoed = _name_core(field_value(resp, "NAME:"))
    if echoed and echoed != _name_core(ASKED_NAME):
        raise ApiFailure("model answered as someone else (echo mismatch)")
    if field_value(resp, "EXCLUSIVITY:") == "":
        raise ApiFailure("reply was cut off before EXCLUSIVITY")
    return {"orientation": field_value(resp, "SEXUAL_ORIENTATION:"), "basis": field_value(resp, "SEXUAL_ORIENTATION_BASIS:"),
            "intimacy": field_value(resp, "INTIMACY:"), "ardor": field_value(resp, "ARDOR:"),
            "exclusivity": field_value(resp, "EXCLUSIVITY:"), "why": field_value(resp, "WHY:"),
            "limit": field_value(resp, "LIMIT:")}


def build_disposition_messages():
    """The real snrom_author_disposition template, rendered with what the preview knows. Context as the game sends
    it (SNRom_Bridge.AuthorDisposition): npc_name, npc_formid, npc_married/engaged/candidate = 0, circle = "" (nobody
    else is travelling in this preview), npc_bio = the one-line stub used only when the profile renders empty."""
    scope, _ = make_world("")
    scope.update({"npc_name": ASKED_NAME, "npc_formid": JENASSA_FORMID, "npc_married": 0, "npc_engaged": 0,
                  "npc_candidate": 0, "circle": "", "npc_bio": "Dunmer, Female. Known to the Dragonborn.",
                  "is_plugin_loaded": lambda n: False})
    text = read(DISPOSITION_PROMPT)
    parts = re.split(r"^\[ (system|user) \]\s*$", text, flags=re.M)
    return [{"role": parts[i], "content": render(parts[i + 1], scope)} for i in range(1, len(parts), 2)]


def _sha(path):
    import hashlib
    with open(path, "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def roll_disposition(cfg, p):
    """One authoring run: render, call (up to 3 tries), parse, write disposition.json + its hash."""
    msgs = build_disposition_messages()
    write_private(p["disp_prompt"], "\n\n".join("[ %s ]\n%s" % (m["role"], m["content"]) for m in msgs))
    last = None
    for attempt in (1, 2, 3):
        say("Rolling Jenassa's disposition (call %d)..." % attempt)
        try:
            reply = chat_call(cfg, msgs, max_tokens=1200)
            rec = parse_disposition(reply)
            break
        except ApiFailure as e:
            last = e
            say("  not usable: %s" % e)
    else:
        raise ApiFailure("disposition not authored (%s)" % last)
    rec["_about"] = ("Rolled with the Relationships mod's snrom_author_disposition prompt. Edit the words freely: an edited "
                     "file is kept and never re-rolled; /disposition re-rolls (your edited copy is backed up). Words: "
                     "orientation ATTRACTED_TO_MEN|WOMEN|BOTH|NEITHER; basis STATED|IMPLIED|UNKNOWN; intimacy "
                     "NEVER|GUARDED|ROMANTIC|CASUAL; ardor RESERVED|MEASURED|WARM|OPEN|INTENSE; exclusivity "
                     "UNTROUBLED|ACCEPTING|CONVENTIONAL|POSSESSIVE|CONSUMING (or 0-100).")
    rec["_generated"] = {"when": time.strftime("%Y-%m-%d %H:%M:%S"), "model": cfg["model"], "raw_reply": reply}
    write_private(p["disposition"], json.dumps(rec, indent=2, ensure_ascii=False) + "\n")
    write_private(p["disp_hash"], _sha(p["disposition"]) + "\n")
    return rec


def disposition_summary(rec):
    d = derive(rec)
    return ("orientation=%s basis=%s intimacy=%s (min tier %d) ardor=%s (%d) exclusivity=%s (%d)" % (
        rec.get("orientation") or "-", rec.get("basis") or "-", rec.get("intimacy") or "-", d["min_tier"],
        rec.get("ardor") or "-", d["ardor"], rec.get("exclusivity") or "-", d["excl"]))


def ensure_disposition(cfg, p, force=False):
    """Returns the record in use, or None. An existing file is REUSED whether Shae edited it or not; only a missing
    or unreadable file, or /disposition (force), rolls."""
    exists = os.path.exists(p["disposition"])
    if exists and not force:
        try:
            rec = json.loads(read(p["disposition"]))
            if not isinstance(rec, dict):
                raise ValueError
            stored = read(p["disp_hash"]).strip() if os.path.exists(p["disp_hash"]) else ""
            edited = stored != _sha(p["disposition"])
            say("Using saved disposition (%s). %s" % ("edited by you" if edited else "as rolled", disposition_summary(rec)))
            return rec
        except (ValueError, OSError):
            bad = p["disposition"] + ".unreadable_" + time.strftime("%Y%m%d-%H%M%S")
            os.replace(p["disposition"], bad)
            say("disposition.json could not be read; kept as %s and rolling a new one." % os.path.basename(bad))
    elif exists and force:
        stored = read(p["disp_hash"]).strip() if os.path.exists(p["disp_hash"]) else ""
        if stored != _sha(p["disposition"]):
            bak = p["disposition"] + ".edited_" + time.strftime("%Y%m%d-%H%M%S")
            os.replace(p["disposition"], bak)
            say("Your edited disposition was backed up as %s." % os.path.basename(bak))
    try:
        rec = roll_disposition(cfg, p)
    except ApiFailure as e:
        say("Could not roll the disposition (%s). Try /disposition." % e)
        return None
    say("Disposition: " + disposition_summary(rec))
    if rec.get("why"):
        say("  why: " + rec["why"])
    if rec.get("limit"):
        say("  limit: " + rec["limit"])
    return rec


def author_profile(cfg, p, rec):
    """The intimacy profile, only when the game would write one: adult, romance not foreclosed, not NEVER."""
    d = derive(rec)
    if d["min_tier"] < 0:
        raise ApiFailure("her intimacy is NEVER, so the game writes no profile; edit disposition.json or /disposition")
    if romance_foreclosed(d):
        raise ApiFailure("her stated orientation excludes Lucienne, so the game writes no profile; "
                         "edit disposition.json or /disposition")
    msgs = build_author_messages(d)
    write_private(p["author"], "\n\n".join("[ %s ]\n%s" % (m["role"], m["content"]) for m in msgs))
    say("Authoring Jenassa's intimacy profile (one call)...")
    text = chat_call(cfg, msgs, max_tokens=2500)
    if len(text) < 200:
        raise ApiFailure("profile too short (%d chars); not stored" % len(text))
    write_private(p["profile"], text.strip() + "\n")
    say("Profile rewritten (%d characters). Not shown." % len(text.strip()))
    return text.strip()


# ---------------------------------------------------------------- chat
class Chat:
    def __init__(self, cfg, p, profile, rec, scn_text):
        self.cfg, self.p, self.profile, self.rec = cfg, p, profile, rec
        self.hist = []          # [{"role","content"}...]
        self.new_transcript()
        self.rebuild(scn_text=scn_text)

    def new_transcript(self):
        self.started = time.strftime("%Y%m%d-%H%M%S")
        self.path = f"{self.p['transcripts']}/transcript_{self.started}.md"

    def rebuild(self, profile=None, rec=None, scn_text=None):
        if profile is not None:
            self.profile = profile
        if rec is not None:
            self.rec = rec
        if scn_text is not None:
            self.scn_text = scn_text
        self.scn = parse_scenario(self.scn_text)
        d = derive(self.rec if self.rec is not None else {})
        self.system, self.prefix, self.final = build_system(self.profile, self.scn, d,
                                                            os.environ.get("LUC_PREVIEW_LUC_FULL") == "1")
        write_private(self.p["prompt"], self.system + "\n\n[ earlier events, as chat messages ]\n"
                      + "\n".join("%s: %s" % (m["role"], m["content"]) for m in self.prefix)
                      + "\n\n[ final instructions, appended to the last user message ]\n" + self.final + "\n")

    def messages(self):
        h = [dict(m) for m in self.hist[-HISTORY_MAX:]]
        if h and h[0]["role"] == "assistant" and not self.prefix:
            h = h[1:]
        if h and h[-1]["role"] == "user":
            h[-1]["content"] = h[-1]["content"] + "\n\n" + self.final
        return [{"role": "system", "content": self.system}] + merge_roles(self.prefix + h)

    def reply(self):
        text = chat_call(self.cfg, self.messages())
        self.hist.append({"role": "assistant", "content": text})
        return text

    def save(self):
        lines = ["# Jenassa preview transcript", "", "Started %s. Model %s, sort %s, quantizations %s." % (
            self.started, self.cfg["model"], self.cfg["sort"], ",".join(self.cfg["quantizations"])),
            "Scene: %s, %s, %s." % (self.scn["location"], self.scn["time"], self.scn["weather"]), ""]
        for m in self.hist:
            who = "Lucienne" if m["role"] == "user" else "Jenassa"
            lines += ["**%s:** %s" % (who, m["content"]), ""]
        write_private(self.path, "\n".join(lines))
        return self.path


HELP = ("/regen    regenerate Jenassa's last reply\n/undo     drop the last exchange (yours and hers)\n"
        "/save     write the transcript now (it also saves after every reply)\n"
        "/scene    write a fresh scenario (one call) into scene_setup.txt and start a new chat\n"
        "/disposition  re-roll Jenassa's disposition (orientation, intimacy, ardor, exclusivity, why, limit)\n"
        "/profile  author Jenassa's intimacy profile again from the current disposition (one call)\n"
        "/help     this list\n/exit     save and quit")


def load_scene_file(p):
    """Reads scene_setup.txt, creating the default when missing. A file that does not parse (for example the one-line
    file an earlier version wrote) is kept as .old and replaced by the default."""
    if os.path.exists(p["setup"]):
        text = read(p["setup"])
        try:
            parse_scenario(text)
            return text
        except ValueError:
            os.replace(p["setup"], p["setup"] + ".old_" + time.strftime("%Y%m%d-%H%M%S"))
            say("scene_setup.txt did not parse; kept as .old and wrote the default scenario.")
    write_private(p["setup"], DEFAULT_SCENE)
    return DEFAULT_SCENE


def main(argv=None):
    for s in (sys.stdout, sys.stderr):
        try:
            s.reconfigure(encoding="utf-8")
        except Exception:
            pass
    if not STUB and not os.environ.get(KEY_VAR):
        say("The OpenRouter key is not set. In a terminal, run this once:")
        say(KEY_MESSAGE)
        say("Then open a NEW terminal window (the old one will not see it) and start the preview again.")
        return 2
    p = paths()
    os.makedirs(p["transcripts"], exist_ok=True)
    migrate_private_names()
    cfg = load_routing()
    say("Jenassa preview. Model %s, sort %s, quantizations %s%s." % (
        cfg["model"], cfg["sort"], "/".join(cfg["quantizations"]), "  [STUB: no real calls]" if STUB else ""))
    for w in cfg["warnings"]:
        say("note: " + w)
    scn_text = load_scene_file(p)
    rec = ensure_disposition(cfg, p)
    profile = read(p["profile"]).strip() if os.path.exists(p["profile"]) else ""
    if not profile:
        if rec is None:
            say("No profile yet: it needs the disposition first (/disposition, then /profile). Starting without one.")
        else:
            try:
                profile = author_profile(cfg, p, rec)
            except ApiFailure as e:
                say("Could not author the profile (%s). Starting without one; /profile tries again." % e)
    else:
        say("Using saved profile (/profile re-authors it from the current disposition).")
    chat = Chat(cfg, p, profile, rec, scn_text)
    say("Scene: %s | %s | %s (edit scene_setup.txt or use /scene)" % (chat.scn["location"], chat.scn["time"],
                                                                      chat.scn["weather"]))
    say("Files go to " + HOME)
    say("You are Lucienne. Type to talk to Jenassa. /help for commands.\n")
    while True:
        try:
            line = input("Lucienne> ").strip()
        except (EOFError, KeyboardInterrupt):
            line = "/exit"
        if not line:
            continue
        if line.startswith("/"):
            cmd = line.split()[0].lower()
            if cmd == "/exit":
                if chat.hist:
                    say("Transcript: " + chat.save())
                return 0
            if cmd == "/help":
                say(HELP)
            elif cmd == "/save":
                say("Transcript: " + chat.save())
            elif cmd == "/undo":
                if len(chat.hist) >= 2:
                    del chat.hist[-2:]
                    chat.save()
                    say("Dropped the last exchange.")
                elif chat.hist:
                    chat.hist.clear()
                    say("Dropped the last line.")
                else:
                    say("Nothing to undo.")
            elif cmd == "/regen":
                if len(chat.hist) >= 2 and chat.hist[-1]["role"] == "assistant":
                    old = chat.hist.pop()
                    try:
                        say("\nJenassa> " + chat.reply() + "\n")
                        chat.save()
                    except ApiFailure as e:
                        chat.hist.append(old)
                        say("No reply (%s); the previous reply is kept." % e)
                else:
                    say("Nothing to regenerate yet.")
            elif cmd == "/scene":
                try:
                    new = generate_scene(cfg, p, read(p["setup"]) if os.path.exists(p["setup"]) else "")
                    if chat.hist:
                        say("Transcript: " + chat.save())
                    if os.path.exists(p["setup"]):
                        write_private(p["setup"] + ".prev", read(p["setup"]))
                    write_private(p["setup"], new)
                    chat.hist.clear()
                    chat.new_transcript()
                    chat.rebuild(scn_text=new)
                    say("New scenario (saved to scene_setup.txt; the old one is scene_setup.txt.prev). Fresh chat:\n")
                    say(new)
                except ApiFailure as e:
                    say("Scenario not changed (%s)." % e)
            elif cmd == "/disposition":
                rec = ensure_disposition(cfg, p, force=True)
                if rec is not None:
                    chat.rebuild(rec=rec)
                    if os.path.exists(p["profile"]):
                        say("The saved profile was written from the old disposition; run /profile to rewrite it.")
                    else:
                        try:
                            chat.rebuild(profile=author_profile(cfg, p, rec), rec=rec)
                            say("Profile written and in use from the next reply.")
                        except ApiFailure as e:
                            say("No profile (%s)." % e)
            elif cmd == "/profile":
                try:
                    rec = ensure_disposition(cfg, p)
                    if rec is None:
                        raise ApiFailure("no disposition")
                    chat.rebuild(profile=author_profile(cfg, p, rec), rec=rec)
                    say("New profile is in use from the next reply.")
                except ApiFailure as e:
                    say("Profile not changed (%s)." % e)
            else:
                say("Unknown command. /help lists them.")
            continue
        chat.hist.append({"role": "user", "content": line})
        try:
            say("\nJenassa> " + chat.reply() + "\n")
            chat.save()
        except ApiFailure as e:
            chat.hist.pop()
            say("No reply (%s). Your line was not kept; try again." % e)


def safe_main():
    """Last-resort guard: an unexpected error prints only its type, never a traceback or message that could
    carry profile or prompt text."""
    try:
        return main()
    except SystemExit:
        raise
    except BaseException as e:
        print("The preview stopped on an unexpected %s." % type(e).__name__, flush=True)
        return 1


if __name__ == "__main__":
    sys.exit(safe_main())
