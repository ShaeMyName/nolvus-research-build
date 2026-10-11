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
DEFAULT_SETUP = ("You and Lucienne are alone together in a private room at night. Nobody else can see or hear "
                 "you.")
# Jenassa's authored disposition is held in the game's save; the preview cannot read it. These values are
# derived from her SkyrimNet bio (calculating, loyal once earned, "possible romantic interest if treated as an
# equal") and are written to disposition.json in the private folder so Shae can edit them.
DEFAULT_DISPOSITION = {
    "disp_orientation": "both men and women",
    "disp_intimacy": "ROMANTIC",
    "disp_ardor": "measured, showing little",
    "disp_exclusivity": 70,
    "disp_why": ("Cold exterior, deep loyalty once earned: she gives her body only to someone who has proved "
                 "an equal in combat and judgement."),
    "disp_limit": "She will not be handled as a possession or ordered into bed; she walks away from weakness.",
}


def say(s=""):
    print(s, flush=True)


def paths():
    return {
        "home": HOME,
        "profile": f"{HOME}/profile_jenassa.md",
        "disposition": f"{HOME}/disposition.json",
        "setup": f"{HOME}/scene_setup.txt",
        "prompt": f"{HOME}/last_system_prompt.txt",
        "author": f"{HOME}/last_profile_prompt.txt",
        "transcripts": f"{HOME}/transcripts",
    }


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
            for item in ev(n[2], scope) or []:
                scope[n[1]] = item
                run(n[3], scope, out)


def tidy(text):
    text = "\n".join(l.rstrip() for l in text.replace("\r\n", "\n").split("\n"))
    return re.sub(r"\n{3,}", "\n\n", text).strip("\n")


def render(src, scope):
    out = []
    run(parse2(src), scope, out)
    return tidy("".join(out))


# ---------------------------------------------------------------- the world the templates see
def bio_blocks(text):
    return {m.group(1): m.group(2).strip() for m in re.finditer(r"\{% block (\w+) %\}(.*?)\{% endblock %\}", text, re.S)}


def make_world(profile_text=""):
    jen = bio_blocks(read(JENASSA_BIO))
    luc = bio_blocks(read(LUC_BIO))
    people = {
        "jenassa": {"UUID": "jenassa", "name": "Jenassa", "gender": "female", "race": "Dunmer", "isChild": False,
                    "isVirtual": False, "isInCombat": False, "subjectivePronoun": "she",
                    "possessivePronoun": "her", "objectivePronoun": "her", "universalTranslatorSpeechPattern": ""},
        "player": {"UUID": "player", "name": "Lucienne", "gender": "female", "race": "Dunmer", "isChild": False,
                   "isVirtual": False, "isInCombat": False, "subjectivePronoun": "she",
                   "possessivePronoun": "her", "objectivePronoun": "her", "universalTranslatorSpeechPattern": ""},
    }
    people = wrap(people)
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

    scope = Scope()
    scope.update({
        "render_mode": "full", "actorUUID": "jenassa", "npc": people["jenassa"], "player": people["player"],
        "responseTarget": AD({"type": "player", "UUID": "player"}),
        "decnpc": decnpc, "render_character_profile": rcp, "papyrus_util": papyrus_util,
        "is_narration_enabled": lambda: True, "is_player": lambda u: str(u) == "player",
        "get_linked_identities": lambda u: [], "exists": lambda n: n in ("npc", "responseTarget"),
        "existsIn": lambda o, k: isinstance(o, dict) and k in o,
        "get_faction_rank": lambda *a: 0, "formid_to_uuid": lambda f: "jenassa",
        "has_line_of_sight": lambda *a: True, "actor_has_keyword": lambda *a: True,
        "get_worn_equipment": lambda u: AD({"torso": "clothing"}), "get_nearby_npc_list": lambda u: [],
        "length": len, "join": lambda l, s: s.join(l), "append": lambda l, x: list(l) + [x],
        "contains": lambda a, b: b in a,
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
def build_system(profile, setup, luc_full=False):
    scope, blocks = make_world(profile)
    j = blocks["jenassa"]
    sections = []
    sections.append("You are Jenassa, a female Dunmer in Skyrim. You are speaking to Lucienne, a female Dunmer.")
    for f in ("system_head/0010_instructions.prompt",):
        sections.append(render_file(f"{BASE_PROMPTS}/submodules/{f}", scope))
    sections.append(render_file(f"{BASE_PROMPTS}/submodules/system_head/0010_setting.prompt", scope))
    sections.append(render_file(f"{SCENE_TEXT}/submodules/system_head/0020_format_rules.prompt", scope))
    # character bio, in the numbered order of submodules/character_bio (0010 header .. 0700 occupation)
    bio = ["## Jenassa's Character Profile (THIS IS WHO YOU ARE ROLEPLAYING AS)",
           "- Gender: female\n- Race: Dunmer\n- Health: Healthy and uninjured\n- Energy: Energetic and ready for action",
           "## Jenassa - Character Summary\n" + j.get("summary", ""),
           "## Background\n" + j.get("background", ""),
           "## Personality & Psychology\n" + j.get("personality", ""),
           "### Interject Summary (Things that Jenassa thinks are interesting and will respond to).\n"
           + j.get("interject_summary", ""),
           "## Goals & Aspirations\n" + j.get("aspirations", ""),
           render_file(f"{SCENE_TEXT}/submodules/character_bio/0335_ieb_intimacy_profile.prompt", scope),
           "## Appearance & Physical State\n" + j.get("appearance", ""),
           "## Skills & Combat\n" + j.get("skills", ""),
           "## Relationships\n" + j.get("relationships", ""),
           "## Occupation\n" + j.get("occupation", "")]
    sections.append("\n\n".join(b for b in bio if b.strip()))
    # Lucienne as Jenassa sees her (render_mode dialogue_target: header, stats, summary, appearance).
    lb = blocks["player"]
    luc = ["## Lucienne's Character Profile (THIS IS WHO YOU'RE TALKING TO)", "- Gender: female\n- Race: Dunmer",
           "## Lucienne - Character Summary\n" + lb.get("summary", ""),
           "## Appearance & Physical State\n" + lb.get("appearance", "")]
    if luc_full:   # LUC_PREVIEW_LUC_FULL=1: also her private blocks (Jenassa would NOT see these in game)
        for k, h in (("background", "Background"), ("personality", "Personality & Psychology"),
                     ("aspirations", "Goals & Aspirations"), ("relationships", "Relationships"),
                     ("occupation", "Occupation"), ("skills", "Skills & Combat")):
            if lb.get(k):
                luc.append("## %s\n%s" % (h, lb[k]))
    sections.append("\n\n".join(luc))
    sections.append("## Current situation\n" + setup.strip())
    sections.append(render_file(f"{BASE_PROMPTS}/submodules/system_head/0400_speech_style_bio.prompt", scope))
    system = "\n\n".join(s for s in sections if s.strip())
    # user_final_instructions: in the game these ride in the last user message of every request.
    finals = [render_file(f"{BASE_PROMPTS}/submodules/user_final_instructions/0500_response_format.prompt", scope),
              render_file(f"{SCENE_TEXT}/submodules/user_final_instructions/0760_visible_actions.prompt", scope),
              render_file(f"{SCENE_TEXT}/submodules/user_final_instructions/9900_ieb_scene_pov.prompt", scope)]
    final = "\n\n".join(f for f in finals if f.strip()) + "\n\nRespond in character now."
    return system, final


def build_author_messages(disp):
    scope, _ = make_world("")
    scope.update({"npc_name": "Jenassa", "npc_formid": JENASSA_FORMID})
    scope.update({k: disp[k] for k in DEFAULT_DISPOSITION})
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
_calls = {"n": 0}


class ApiFailure(Exception):
    pass


def chat_call(cfg, messages, max_tokens=None):
    _calls["n"] += 1
    if _calls["n"] > MAX_CALLS:
        raise ApiFailure("call limit for this session reached")
    if STUB:
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
def load_disposition(p):
    if not os.path.exists(p["disposition"]):
        write_private(p["disposition"], json.dumps(DEFAULT_DISPOSITION, indent=2))
    d = dict(DEFAULT_DISPOSITION)
    try:
        d.update(json.loads(read(p["disposition"])))
    except Exception:
        say("disposition.json could not be read; using the built-in values.")
    return d


def author_profile(cfg, p):
    disp = load_disposition(p)
    msgs = build_author_messages(disp)
    write_private(p["author"], "\n\n".join("[ %s ]\n%s" % (m["role"], m["content"]) for m in msgs))
    say("Authoring Jenassa's intimacy profile (one call)...")
    text = chat_call(cfg, msgs, max_tokens=2500)
    if len(text) < 200:
        raise ApiFailure("profile too short (%d chars); not stored" % len(text))
    write_private(p["profile"], text.strip() + "\n")
    say("Profile saved: " + p["profile"])
    return text.strip()


# ---------------------------------------------------------------- chat
class Chat:
    def __init__(self, cfg, p, profile, setup):
        self.cfg, self.p, self.profile, self.setup = cfg, p, profile, setup
        self.hist = []          # [{"role","content"}...]
        self.started = time.strftime("%Y%m%d-%H%M%S")
        self.path = f"{p['transcripts']}/transcript_{self.started}.md"
        self.system, self.final = build_system(profile, setup, os.environ.get("LUC_PREVIEW_LUC_FULL") == "1")
        write_private(p["prompt"], self.system + "\n\n[ final instructions, appended to the last user message ]\n"
                      + self.final + "\n")

    def messages(self):
        h = [dict(m) for m in self.hist[-HISTORY_MAX:]]
        if h and h[0]["role"] == "assistant":
            h = h[1:]
        if h and h[-1]["role"] == "user":
            h[-1]["content"] = h[-1]["content"] + "\n\n" + self.final
        return [{"role": "system", "content": self.system}] + h

    def reply(self):
        text = chat_call(self.cfg, self.messages())
        self.hist.append({"role": "assistant", "content": text})
        return text

    def save(self):
        lines = ["# Jenassa preview transcript", "", "Started %s. Model %s, sort %s, quantizations %s." % (
            self.started, self.cfg["model"], self.cfg["sort"], ",".join(self.cfg["quantizations"])), ""]
        for m in self.hist:
            who = "Lucienne" if m["role"] == "user" else "Jenassa"
            lines += ["**%s:** %s" % (who, m["content"]), ""]
        write_private(self.path, "\n".join(lines))
        return self.path


HELP = ("/regen    regenerate Jenassa's last reply\n/undo     drop the last exchange (yours and hers)\n"
        "/save     write the transcript now (it also saves after every reply)\n"
        "/profile  author Jenassa's intimacy profile again (replaces the saved one; one call)\n"
        "/help     this list\n/exit     save and quit")


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
    cfg = load_routing()
    say("Jenassa preview. Model %s, sort %s, quantizations %s%s." % (
        cfg["model"], cfg["sort"], "/".join(cfg["quantizations"]), "  [STUB: no real calls]" if STUB else ""))
    for w in cfg["warnings"]:
        say("note: " + w)
    if not os.path.exists(p["setup"]):
        write_private(p["setup"], DEFAULT_SETUP + "\n")
    profile = read(p["profile"]).strip() if os.path.exists(p["profile"]) else ""
    if not profile:
        try:
            profile = author_profile(cfg, p)
        except ApiFailure as e:
            say("Could not author the profile (%s). Try again with /profile after fixing that; "
                "starting without a profile." % e)
    else:
        say("Using saved profile (/profile re-authors it).")
    chat = Chat(cfg, p, profile, read(p["setup"]).strip() or DEFAULT_SETUP)
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
            elif cmd == "/profile":
                try:
                    chat.profile = author_profile(cfg, p)
                    chat.system, chat.final = build_system(chat.profile, chat.setup,
                                                           os.environ.get("LUC_PREVIEW_LUC_FULL") == "1")
                    write_private(p["prompt"], chat.system + "\n\n[ final instructions, appended to the last user "
                                  "message ]\n" + chat.final + "\n")
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


if __name__ == "__main__":
    sys.exit(main())
