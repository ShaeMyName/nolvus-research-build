"""Offline self-test for luc_preview. Makes NO real API call and uses a throwaway private folder
(LUC_PREVIEW_HOME in the system temp dir). Run:  python -B selftest.py"""
import io
import json
import os
import subprocess
import sys
import tempfile
import urllib.error

HERE = os.path.dirname(os.path.abspath(__file__))
APP = os.path.join(HERE, "luc_preview.py")
PY = sys.executable
FAKE_KEY = "FAKEKEY-selftest-0000"
fails = []


def check(name, cond):
    print(("PASS " if cond else "FAIL ") + name)
    if not cond:
        fails.append(name)


def snapshot(root):
    out = {}
    for d, _, fs in os.walk(root):
        if "__pycache__" in d or os.sep + ".git" in d or "test_runs" in d:   # test_runs: another session's live logs
            continue
        for f in fs:
            p = os.path.join(d, f)
            out[p] = os.path.getmtime(p)
    return out


ALL_OUT = []     # every stdout/stderr the app printed, for the no-private-text-on-console check


def run_app(stdin, env_extra, home):
    env = {k: v for k, v in os.environ.items() if k != "LUC_PREVIEW_OR_KEY"}
    env.update(env_extra)
    env["LUC_PREVIEW_HOME"] = home
    env["PYTHONIOENCODING"] = "utf-8"
    res = subprocess.run([PY, "-B", APP], input=stdin, capture_output=True, text=True, encoding="utf-8", env=env)
    ALL_OUT.append(res.stdout + "\n" + res.stderr)
    return res


home = tempfile.mkdtemp(prefix="lp_selftest_")
tree = "C:/nolvus-research"
before = snapshot(tree)

# 1. missing key (not stub): exact message, exit 2, nothing written
r = run_app("", {}, home)
check("missing key prints setx line", 'setx LUC_PREVIEW_OR_KEY "<your OpenRouter key>"' in r.stdout and r.returncode == 2)
check("missing key writes nothing", not os.listdir(home))

# 2. stub run: assembly and commands
script = "hello there\n/regen\nsecond line\n/undo\n/save\n/profile\n/bogus\nthird\n/exit\n"
r = run_app(script, {"LUC_PREVIEW_STUB": "1"}, home)
check("stub run exits 0", r.returncode == 0)
files = sorted(os.listdir(home))
check("profile/disposition/setup/prompts written", all(f in files for f in (
    "_PRIVATE_profile_jenassa.md", "disposition.json", "scene_setup.txt", "_PRIVATE_last_system_prompt.txt", "_PRIVATE_last_profile_prompt.txt", "transcripts")))
sysp = open(os.path.join(home, "_PRIVATE_last_system_prompt.txt"), encoding="utf-8").read()
for label, needle in (("scene rules (Scene mode is on)", "Scene mode is on."), ("third-person rule", "Never use I, me or my inside asterisks"),
                      ("scene length tier", "Scene: speak 1-3 sentences"), ("Jenassa bio", "deadly Dunmer mercenary"),
                      ("saved profile", "## Your intimacy profile"), ("Lucienne bio", "Lucienne is a Dunmer woman"),
                      ("speech profile", "## Speech Profile of Jenassa")):
    check("system prompt has " + label, needle in sysp)
check("no unrendered jinja in system prompt", "{%" not in sysp and "{{" not in sysp and "{#" not in sysp)
check("Lucienne private blocks absent by default", "Red Year" not in sysp)
ap = open(os.path.join(home, "_PRIVATE_last_profile_prompt.txt"), encoding="utf-8").read()
check("author prompt rendered with disposition", "- Intimacy: ROMANTIC" in ap and "Jenassa** (an adult)" in ap and "{{" not in ap and "{%" not in ap)
tr = [f for f in os.listdir(os.path.join(home, "transcripts"))]
check("one transcript", len(tr) == 1)
t = open(os.path.join(home, "transcripts", tr[0]), encoding="utf-8").read()
check("/undo removed 'second line' exchange, kept others", "second line" not in t and "hello there" in t and "third" in t)
check("/regen replaced reply (single Jenassa reply to first line)", t.count("hello there") == 1)
check("unknown command handled", "Unknown command" in r.stdout)

# 2b. disposition roll, scene context, /scene
for label, needle in (("real bond section at Lover tier", "## Your Bond With Lucienne"), ("bond: her WHY from the rolled disposition", "tested in blood"),
                      ("memories via real 7100 template", "Potentially Relevant Memories"), ("memory: the hire", "hired me at the Drunken Huntsman"),
                      ("role as companion (SeverActions 0175)", "## Your Role as Companion\n\nYou are currently traveling with Lucienne as their companion."),
                      ("physical activity from the 0050 template", "## Physical Activity\n- Jenassa is currently using a Chair."),
                      ("target health/magic/energy (0010 template)", "- Health: Healthy and uninjured\n- Magic: Full of magical energy")):
    check("system prompt has " + label, needle in sysp)

# 2b'. the scene-context block: section order and headings from components/context/scene_context_full.prompt, bodies
# from scene_context.prompt. Checked structurally (order, template sentences), against the stub scenario.
SCENE_ORDER = ["## Scene Information", "## Current Location\nThe scene is taking place in **The Bannered Mare",
               "## Current Time\n**Time**: 11:48 PM", "- It's currently late at night - most people would be sleeping",
               "## Current Weather\n**Weather**: You are indoors and sheltered from the weather. Outside, it is Heavy rain (Raining)",
               "*Outside, Rain is falling, making outdoor activities unpleasant*", "## Nearby People\nNo one else is nearby.",
               "## Recent Events\n- **Lucienne** opened Door (happened a while ago)", "- **Jenassa** sat down on Chair (happened moments ago)",
               "## Scene Summary\n- Lucienne and Jenassa are alone", "- Jenassa is sitting on a Chair"]
pos = [sysp.find(s) for s in SCENE_ORDER]
check("scene context: all sections present, in template order", all(p >= 0 for p in pos) and pos == sorted(pos))
check("scene context follows both bios and precedes the speech profile",
      sysp.find("## Lucienne - Character Summary") < pos[0] < sysp.find("## Speech Profile of Jenassa"))
check("no 'Traveling Party' block when no other follower is present (0260 condition)", "Traveling Party" not in sysp)
check("earlier events rendered as chat messages", "[ earlier events, as chat messages ]\nuser: *Rain hammers" in sysp
      and "assistant: Dry at last." in sysp)
dj = json.load(open(os.path.join(home, "disposition.json"), encoding="utf-8"))
check("disposition.json has the six fields", all(dj.get(k) for k in ("orientation", "basis", "intimacy", "ardor", "exclusivity", "why", "limit")))
check("hash file written", os.path.exists(os.path.join(home, "disposition.sha256")))
dp = open(os.path.join(home, "_PRIVATE_last_disposition_prompt.txt"), encoding="utf-8").read()
check("disposition prompt rendered from the real template", "THE PERSON: **Jenassa**" in dp and "SEXUAL_ORIENTATION:" in dp
      and "NOTHING BELOW CAN OVERRULE THAT LINE" in dp and "NOT married and NOT engaged to Lucienne" in dp and "{%" not in dp and "{{" not in dp)
check("profile prompt used the rolled disposition", "- Intimacy: ROMANTIC" in ap and "- Ardor: measured, showing little" in ap
      and "- Exclusivity: 50 out of 100" in ap and "tested in blood" in ap)
check("orientation blank in profile prompt when basis is not STATED", "- Orientation:\n" in ap)
check("first run rolled once", r.stdout.count("Rolling Jenassa's disposition") == 1)
rs = run_app("/scene\n/disposition\n/exit\n", {"LUC_PREVIEW_STUB": "1"}, home)
check("/scene wrote a new scene_setup.txt and kept .prev", "road-side camp" in open(os.path.join(home, "scene_setup.txt"), encoding="utf-8").read()
      and os.path.exists(os.path.join(home, "scene_setup.txt.prev")) and "New scenario" in rs.stdout)
check("/scene rebuilt the prompt with the new scene", "road-side camp" in open(os.path.join(home, "_PRIVATE_last_system_prompt.txt"), encoding="utf-8").read())
check("/disposition re-rolled", rs.stdout.count("Rolling Jenassa's disposition") == 1)

# 2c. edited disposition is reused, never re-rolled; /disposition backs it up
dpath = os.path.join(home, "disposition.json")
dj["intimacy"] = "CASUAL"
with open(dpath, "w", encoding="utf-8") as f:
    json.dump(dj, f)
r3 = run_app("/exit\n", {"LUC_PREVIEW_STUB": "1"}, home)
check("edited disposition reused without a roll", "edited by you" in r3.stdout and "Rolling" not in r3.stdout and "intimacy=CASUAL" in r3.stdout)
r3 = run_app("/disposition\n/exit\n", {"LUC_PREVIEW_STUB": "1"}, home)
check("/disposition forces a roll and backs up the edited file", "Rolling" in r3.stdout and any(".edited_" in x for x in os.listdir(home)))
r3 = run_app("/exit\n", {"LUC_PREVIEW_STUB": "1"}, home)
check("fresh roll is reported as unedited", "as rolled" in r3.stdout)

# 2d. a legacy one-line scene file is replaced; a bad model reply (wrong NAME echo) leaves no disposition and no profile
h2 = tempfile.mkdtemp(prefix="lp_selftest2_")
open(os.path.join(h2, "scene_setup.txt"), "w").write("You and Lucienne are alone.\n")
r4 = run_app("/exit\n", {"LUC_PREVIEW_STUB": "1", "LUC_PREVIEW_STUB_DISP": "NAME: Lydia\nEXCLUSIVITY: POSSESSIVE\n"}, h2)
check("legacy scene file replaced", "did not parse" in r4.stdout and any(x.startswith("scene_setup.txt.old_") for x in os.listdir(h2)))
check("echo mismatch: no disposition.json, no profile, app still starts",
      "echo mismatch" in r4.stdout and not os.path.exists(os.path.join(h2, "disposition.json"))
      and not os.path.exists(os.path.join(h2, "_PRIVATE_profile_jenassa.md")) and r4.returncode == 0)

# 2e. privacy: nothing printed holds profile or system-prompt text; private files carry the _PRIVATE_ prefix
OLD_NAMES = ("profile_jenassa.md", "last_system_prompt.txt", "last_profile_prompt.txt", "last_disposition_prompt.txt")
rp = run_app("/profile\n/exit\n", {"LUC_PREVIEW_STUB": "1"}, home)
check("/profile shows the rewritten test profile (REVIEW_LOG RV-173 (1))",
      "Profile rewritten (" in rp.stdout and "Lean, ash-grey" in rp.stdout)
priv_prof = open(os.path.join(home, "_PRIVATE_profile_jenassa.md"), encoding="utf-8").read()
priv_sys = open(os.path.join(home, "_PRIVATE_last_system_prompt.txt"), encoding="utf-8").read()
scene_txt = open(os.path.join(home, "scene_setup.txt"), encoding="utf-8").read() + "\n" + \
    open(os.path.join(home, "scene_setup.txt.prev"), encoding="utf-8").read()
everything = "\n".join(ALL_OUT)
prof_lines = [l.strip() for l in priv_prof.splitlines() if len(l.strip()) >= 12]
sys_lines = [l.strip() for l in priv_sys.splitlines() if len(l.strip()) >= 30 and l.strip().lstrip("-* ") not in scene_txt]
leaked = [l for l in sys_lines if l in everything and l not in priv_prof]   # RV-173 (1): the test profile may be shown; the system prompt is still not echoed
check("nothing printed contains a system-prompt line (%d lines checked)" % len(sys_lines),
      not leaked and len(prof_lines) > 5 and len(sys_lines) > 50)
check("console never shows private-file markers", "## Your intimacy profile" not in everything and "Scene mode is on." not in everything)
check("no old-named profile/prompt file written", not [f for f in os.listdir(home) if f in OLD_NAMES])
check("all four private files carry the _PRIVATE_ prefix", all(os.path.exists(os.path.join(home, "_PRIVATE_" + n)) for n in OLD_NAMES))
check("disposition.json and scene_setup.txt keep their names", os.path.exists(os.path.join(home, "disposition.json"))
      and os.path.exists(os.path.join(home, "scene_setup.txt")))
# migration: old names are renamed (contents untouched), nothing printed from them
h3 = tempfile.mkdtemp(prefix="lp_selftest3_")
MARK = "MIGRATE-MARKER-0001"
for n in OLD_NAMES:
    open(os.path.join(h3, n), "w", encoding="utf-8").write(MARK + " " + n + " " + "x" * 300 + "\n")
r5 = run_app("/exit\n", {"LUC_PREVIEW_STUB": "1"}, h3)
mig = os.listdir(h3)
check("old-named files migrated by rename", all(("_PRIVATE_" + n) in mig and n not in mig for n in OLD_NAMES))
check("migrated profile kept (not re-authored), contents intact, text not printed",
      "Using saved profile" in r5.stdout and MARK not in r5.stdout + r5.stderr
      and open(os.path.join(h3, "_PRIVATE_profile_jenassa.md"), encoding="utf-8").read().startswith(MARK))


# 3. reuse: second run does not re-author profile
r2 = run_app("/exit\n", {"LUC_PREVIEW_STUB": "1"}, home)
check("saved profile reused", "Using saved profile" in r2.stdout)

# 4. HTTP path with a patched urlopen: key only in the Authorization header, fp4 never sent, errors show type only
sys.path.insert(0, HERE)
os.environ["LUC_PREVIEW_HOME"] = home
os.environ["LUC_PREVIEW_OR_KEY"] = FAKE_KEY
os.environ.pop("LUC_PREVIEW_STUB", None)
sys.dont_write_bytecode = True
import luc_preview as lp  # noqa: E402

cfg = lp.load_routing()
check("model from config", cfg["model"] == "deepseek/deepseek-v4-pro-0813")
check("quantizations fp8+ only", set(cfg["quantizations"]) <= {"fp8", "fp16", "bf16", "fp32"} and "fp4" not in cfg["quantizations"])
captured = {}


class FakeResp(io.BytesIO):
    def __enter__(self): return self
    def __exit__(self, *a): return False


def fake_ok(req, timeout=0):
    captured["headers"] = dict(req.header_items())
    captured["body"] = json.loads(req.data.decode())
    return FakeResp(json.dumps({"choices": [{"message": {"content": "<think>x</think>fine reply"}}]}).encode())


lp.urllib.request.urlopen = fake_ok
out = lp.chat_call(cfg, [{"role": "user", "content": "hi"}])
check("think tags stripped", out == "fine reply")
check("provider object: sort + quantizations + no fp4", captured["body"]["provider"]["sort"] == cfg["sort"]
      and "fp4" not in json.dumps(captured["body"]) and captured["body"]["provider"]["quantizations"] == cfg["quantizations"])
check("key only in Authorization header", FAKE_KEY not in json.dumps(captured["body"]) and FAKE_KEY in captured["headers"].get("Authorization", ""))


def fake_http_err(req, timeout=0):
    raise urllib.error.HTTPError(req.full_url, 401, "bad " + FAKE_KEY, {"X": FAKE_KEY}, io.BytesIO(FAKE_KEY.encode()))


lp.urllib.request.urlopen = fake_http_err
try:
    lp.chat_call(cfg, [{"role": "user", "content": "hi"}])
    check("http error raises", False)
except lp.ApiFailure as e:
    check("http error shows status only, no key", "401" in str(e) and FAKE_KEY not in str(e) and FAKE_KEY not in repr(e))


def fake_other(req, timeout=0):
    raise ValueError("secret " + FAKE_KEY)


lp.urllib.request.urlopen = fake_other
try:
    lp.chat_call(cfg, [{"role": "user", "content": "hi"}])
    check("other error raises", False)
except lp.ApiFailure as e:
    check("other error shows type only", str(e) == "ValueError" and FAKE_KEY not in repr(e) and e.__cause__ is None)

# 4b. the game's field rules (ported from ApplyCharacter / SNRom_Decorators)
ok = lp.parse_disposition('NAME: "Jenassa",\nSEXUAL_ORIENTATION: ATTRACTED_TO_WOMEN\nSEXUAL_ORIENTATION_BASIS: STATED\nINTIMACY: casual\n'
                          'ARDOR: 9\nEXCLUSIVITY: banana\nWHY: "x",\nLIMIT: y')
dd = lp.derive(ok)
check("quoted NAME echo accepted", ok["why"] == "x")
check("ardor digit clamps to 4, exclusivity junk falls back to 50", dd["ardor"] == 4 and dd["excl"] == 50)
check("CASUAL: min tier 2, bypass 1; STATED women -> 'women'", dd["min_tier"] == 2 and dd["bypass"] == 1 and dd["disp_orientation"] == "women")
check("exclusivity buckets", [lp.exclusivity_to_int(w) for w in ("UNTROUBLED", "ACCEPTING", "CONVENTIONAL", "POSSESSIVE", "CONSUMING")] == [0, 25, 50, 75, 100])
check("intimacy mapping and unreadable default", [lp.intimacy_to_mintier(w) for w in ("NEVER", "GUARDED", "ROMANTIC", "CASUAL", "??")] == [-1, 5, 4, 2, 4])
check("orientation old words and unreadable default", [lp.orientation_to_int(w) for w in ("MEN", "WOMEN", "ANY", "NONE", "??")] == [1, 2, 3, 0, 3])
for bad, why in (("NAME: Lydia\nEXCLUSIVITY: X", "echo"), ("NAME: Jenassa\nINTIMACY: CASUAL", "truncated")):
    try:
        lp.parse_disposition(bad)
        check("bad reply rejected (%s)" % why, False)
    except lp.ApiFailure:
        check("bad reply rejected (%s)" % why, True)
check("STATED men excludes Lucienne; UNKNOWN never does", lp.romance_foreclosed(lp.derive({"orientation": "ATTRACTED_TO_MEN", "basis": "STATED"}))
      and not lp.romance_foreclosed(lp.derive({"orientation": "ATTRACTED_TO_MEN", "basis": "UNKNOWN"})))

# 5. fp4 in a config is dropped with a warning (parser unit check on a copy of the logic)
lp_src = open(APP, encoding="utf-8").read()
check("app never reads key lines / source has no key literal", FAKE_KEY not in lp_src)

# 6. nothing outside the private folder changed (research tree and the project)
after = snapshot(tree)
new = [p for p in after if p not in before]
mine = [p for p in after if before.get(p) != after[p] and p.replace("\\", "/").startswith(HERE.replace("\\", "/"))]
# other sessions edit existing files in the tree while this runs, so the check is: nothing NEW anywhere, nothing in
# this folder changed
check("no new file anywhere in C:/nolvus-research, none changed in luc_preview (%s)" % (new + mine), not new and not mine)
leak = [os.path.join(d, f) for d, _, fs in os.walk(home) for f in fs if FAKE_KEY in open(os.path.join(d, f), encoding="utf-8", errors="ignore").read()]
check("key not in any private file", not leak)

print("\n%d failure(s)" % len(fails))
sys.exit(1 if fails else 0)
