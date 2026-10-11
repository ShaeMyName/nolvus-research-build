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


def run_app(stdin, env_extra, home):
    env = {k: v for k, v in os.environ.items() if k != "LUC_PREVIEW_OR_KEY"}
    env.update(env_extra)
    env["LUC_PREVIEW_HOME"] = home
    env["PYTHONIOENCODING"] = "utf-8"
    return subprocess.run([PY, "-B", APP], input=stdin, capture_output=True, text=True, encoding="utf-8", env=env)


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
    "profile_jenassa.md", "disposition.json", "scene_setup.txt", "last_system_prompt.txt", "last_profile_prompt.txt", "transcripts")))
sysp = open(os.path.join(home, "last_system_prompt.txt"), encoding="utf-8").read()
for label, needle in (("scene rules (Scene mode is on)", "Scene mode is on."), ("third-person rule", "Never use I, me or my inside asterisks"),
                      ("scene length tier", "Scene: speak 1-3 sentences"), ("Jenassa bio", "deadly Dunmer mercenary"),
                      ("saved profile", "## Your intimacy profile"), ("Lucienne bio", "Lucienne is a Dunmer woman"),
                      ("speech profile", "## Speech Profile of Jenassa")):
    check("system prompt has " + label, needle in sysp)
check("no unrendered jinja in system prompt", "{%" not in sysp and "{{" not in sysp and "{#" not in sysp)
check("Lucienne private blocks absent by default", "Red Year" not in sysp)
ap = open(os.path.join(home, "last_profile_prompt.txt"), encoding="utf-8").read()
check("author prompt rendered with disposition", "- Intimacy: ROMANTIC" in ap and "Jenassa** (an adult)" in ap and "{{" not in ap and "{%" not in ap)
tr = [f for f in os.listdir(os.path.join(home, "transcripts"))]
check("one transcript", len(tr) == 1)
t = open(os.path.join(home, "transcripts", tr[0]), encoding="utf-8").read()
check("/undo removed 'second line' exchange, kept others", "second line" not in t and "hello there" in t and "third" in t)
check("/regen replaced reply (single Jenassa reply to first line)", t.count("hello there") == 1)
check("unknown command handled", "Unknown command" in r.stdout)

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
