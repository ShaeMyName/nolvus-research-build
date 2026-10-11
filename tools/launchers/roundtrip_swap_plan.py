"""Round-trip test for the shared-SKSE swap (BRIDGE_SPEC_V2.md 16.7 step 8c; REVIEW_LOG RV-135 (6)).
AUTHORED OFFLINE; the real launches have NOT been run.  Run by the builder after promotion (profile "Lucienne" exists,
swap_launch.py --init done).  The pieces that need no game (plan, pre, check, refuse, unmark, status) are exercised in the
sandbox by selftest_swap.py's S10; the game-driving `run` command is not exercised offline.

Idea: a profile's session leaves a MARK (one comment line appended to the live IntelEngine.ini while the game runs).
Pass = after each step the mark is in that profile's store only, every file hash is as expected, the live files are the
rest profile's (SkyrimNet Test) copies, and the marker says CLEAN.

    python roundtrip_swap_plan.py plan              print the plan (no side effects)
    python roundtrip_swap_plan.py pre               preconditions + snapshot (writes test_runs\\swap_roundtrip\\state.json)
    python roundtrip_swap_plan.py run 1             launch step 1 .. 5 end to end (needs harness game.py), then check
    python roundtrip_swap_plan.py refuse            tamper -> launcher must refuse (no game launched) -> --reset-live
    python roundtrip_swap_plan.py unmark            remove the marks from both stores (back to the pre-test hashes)
  manual pieces:  during N | mark N | check N [--rc N] | kill-game
Add  --swap-args '<json list>'  to pass sandbox paths on to swap_launch (selftest only).
"""
import argparse
import datetime
import glob
import io
import json
import os
import subprocess
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import swap_launch as S   # noqa: E402

RT_DIR = os.environ.get("IEB_RT_DIR") or os.path.join(S.RESEARCH, "test_runs", "swap_roundtrip")
STATE = os.path.join(RT_DIR, "state.json")
MARK_PREFIX = "; roundtrip-mark rt-"
NOWIN = getattr(subprocess, "CREATE_NO_WINDOW", 0)
NEWCON = getattr(subprocess, "CREATE_NEW_CONSOLE", 0)

# step -> (profile, kind).  kinds: normal | kill_game | kill_launcher
STEPS = {
    1: (S.TEST_PROFILE, "normal"),        # test launcher, normal exit
    2: (S.LUC_PROFILE, "normal"),         # Lucienne launcher, normal exit
    3: (S.TEST_PROFILE, "kill_game"),     # test launcher, then taskkill /F /IM SkyrimSE.exe mid-session
    4: (S.LUC_PROFILE, "normal"),         # Lucienne launcher, normal exit
    5: (S.LUC_PROFILE, "kill_launcher"),  # extra: the launcher process is killed mid-session, then --recover
}
# marks expected in (test store, Lucienne store) AFTER each step: proves persistence and isolation
EXPECT_MARKS = {1: ({1}, set()), 2: ({1}, {2}), 3: ({1, 3}, {2}), 4: ({1, 3}, {2, 4}), 5: ({1, 3}, {2, 4, 5})}


class Out:
    def __init__(self):
        self.fails = 0

    def ok(self, cond, text):
        print(("PASS  " if cond else "FAIL  ") + text, flush=True)
        if not cond:
            self.fails += 1
        return cond

    def info(self, text):
        print("INFO  " + text, flush=True)


def marks(directory):
    p = os.path.join(directory, "IntelEngine.ini")
    if not os.path.isfile(p):
        return set()
    out = set()
    for line in io.open(p, encoding="utf-8", errors="replace"):
        if line.startswith(MARK_PREFIX):
            out.add(int(line[len(MARK_PREFIX):].strip()))
    return out


def snap(c):
    return {"test": S.hashes(S.store_dir(c, S.TEST_PROFILE)), "luc": S.hashes(S.store_dir(c, S.LUC_PROFILE)),
            "live": S.hashes(c.skse), "taken": datetime.datetime.now().isoformat(timespec="seconds")}


def load_state():
    return json.load(io.open(STATE, encoding="utf-8")) if os.path.isfile(STATE) else None


def save_state(st):
    os.makedirs(RT_DIR, exist_ok=True)
    io.open(STATE, "w", encoding="utf-8", newline="\n").write(json.dumps(st, indent=2) + "\n")


def stray_files(c):
    out = []
    for d in (c.skse, S.store_dir(c, S.TEST_PROFILE), S.store_dir(c, S.LUC_PROFILE)):
        out += glob.glob(os.path.join(d, "*.swaptmp"))
    return out


def common_state_checks(c, o):
    m = S.read_kv(c.marker)
    o.ok(m is not None and m.get("state") == "CLEAN" and m.get("owner") == c.rest,
         "marker CLEAN, owner '%s' (got %s)" % (c.rest, None if m is None else (m.get("state"), m.get("owner"))))
    o.ok(not S.running(c), "no game / MO2 / loader process running (%s)" % (S.running(c) or "none"))
    o.ok(not os.path.exists(c.lock), "no swap lock left behind")
    o.ok(not stray_files(c), "no .swaptmp leftovers")
    for prof in (S.TEST_PROFILE, S.LUC_PROFILE):
        pr = S.store_problems(c, prof)
        o.ok(not pr, "store of '%s' matches its manifest%s" % (prof, "" if not pr else ": " + "; ".join(pr)))
    live, ts = S.hashes(c.skse), S.hashes(S.store_dir(c, S.TEST_PROFILE))
    o.ok(live == ts, "live files are byte-identical to the test store (rest state)%s" % ("" if live == ts else ": " + "; ".join(S.diff(live, ts))))
    if m:
        o.ok(S.marker_hashes(m) == live, "marker hashes equal the live hashes")


def cmd_pre(c, args):
    o = Out()
    common_state_checks(c, o)
    luc, tst = S.hashes(S.store_dir(c, S.LUC_PROFILE)), S.hashes(S.store_dir(c, S.TEST_PROFILE))
    o.ok(luc != tst, "the two stores differ (otherwise a wrong swap would be invisible): %s" % ", ".join(S.diff(luc, tst)))
    o.ok(not marks(S.store_dir(c, S.LUC_PROFILE)) and not marks(S.store_dir(c, S.TEST_PROFILE)) and not marks(c.skse),
         "no roundtrip marks present yet (run `unmark` first if a previous test left some)")
    st = snap(c)
    st["orig"] = {"test": st["test"], "luc": st["luc"]}
    st["steps_done"] = []
    if o.fails == 0:
        save_state(st)
        o.info("snapshot written: %s" % STATE)
    return 1 if o.fails else 0


def need_state():
    st = load_state()
    if st is None:
        raise SystemExit("no snapshot: run `pre` first")
    return st


def cmd_during(c, step, wait=1500):
    """While the game of step N runs: swap-in happened and the files are the profile's. Waits for IN_USE and the game."""
    st, o = need_state(), Out()
    prof, _ = STEPS[step]
    t0 = time.time()
    while time.time() - t0 < wait:
        m = S.read_kv(c.marker) or {}
        if m.get("state") == "IN_USE" and c.game_exe in S.running(c):
            break
        time.sleep(3)
    m = S.read_kv(c.marker) or {}
    o.ok(m.get("state") == "IN_USE" and m.get("owner") == prof, "marker IN_USE, owner '%s' (got %s/%s)" % (prof, m.get("state"), m.get("owner")))
    o.ok(c.game_exe in S.running(c), "%s is running" % c.game_exe)
    own = S.hashes(S.store_dir(c, prof))
    live = S.hashes(c.skse)
    # nothing has been marked yet; the game may already have rewritten a file, so the SA files are reported, not failed
    o.ok(live["IntelEngine.ini"] == own["IntelEngine.ini"], "live IntelEngine.ini == '%s' store copy (swapped in)" % prof)
    for n in S.FILES[:2]:
        if live[n] == own[n]:
            o.ok(True, "live %s == '%s' store copy (swapped in)" % (n, prof))
        else:
            o.info("live %s already differs from the store (written by the game since launch)" % n)
    other = "luc" if prof == S.TEST_PROFILE else "test"
    o.ok(S.hashes(S.store_dir(c, S.LUC_PROFILE if other == "luc" else S.TEST_PROFILE)) == st[other],
         "the other profile's store is untouched (hashes equal the snapshot)")
    return 1 if o.fails else 0


def cmd_mark(c, step):
    m = S.read_kv(c.marker) or {}
    if m.get("state") != "IN_USE" or c.game_exe not in S.running(c):
        raise SystemExit("refusing to mark: marker is not IN_USE or the game is not running")
    p = os.path.join(c.skse, "IntelEngine.ini")
    with open(p, "ab") as f:
        f.write(("%s%d\n" % (MARK_PREFIX, step)).encode())
    print("marked live IntelEngine.ini with rt-%d (%s)" % (step, S.short(S.sha(p))))
    return 0


def latest_swap_log(c, tag):
    fs = sorted(glob.glob(os.path.join(c.logs, "swap_*_%s.log" % tag)))
    return fs[-1] if fs else None


def cmd_check(c, step, rc):
    st, o = need_state(), Out()
    prof, kind = STEPS[step]
    print("--- check after step %d: %s launcher, %s ---" % (step, prof, kind))
    if kind != "kill_launcher":
        o.ok(rc == 0, "launcher exit code 0 (got %s)" % rc)
    common_state_checks(c, o)
    own_key, other_key = ("test", "luc") if prof == S.TEST_PROFILE else ("luc", "test")
    own_dir = S.store_dir(c, S.TEST_PROFILE if prof == S.TEST_PROFILE else S.LUC_PROFILE)
    other_dir = S.store_dir(c, S.LUC_PROFILE if prof == S.TEST_PROFILE else S.TEST_PROFILE)
    # hashes before and after
    after_other = S.hashes(other_dir)
    o.ok(after_other == st[other_key], "other profile's store byte-identical to before (%s)" % ("same" if after_other == st[other_key] else "; ".join(S.diff(st[other_key], after_other))))
    after_own = S.hashes(own_dir)
    before_own = st[own_key]
    o.ok(after_own["IntelEngine.ini"] != before_own["IntelEngine.ini"], "'%s' store IntelEngine.ini changed (mark copied back)" % prof)
    for n in S.FILES[:2]:
        if after_own[n] == before_own[n]:
            o.ok(True, "'%s' store %s unchanged by the session" % (prof, n))
        else:
            o.info("'%s' store %s CHANGED during the session (game-written; accepted as the new baseline): %s -> %s"
                   % (prof, n, S.short(before_own[n]), S.short(after_own[n])))
    # exact content check: the old ini plus exactly the one mark line
    with open(os.path.join(S.store_dir(c, prof), "IntelEngine.ini"), "rb") as f:
        new = f.read()
    exp_line = ("%s%d\n" % (MARK_PREFIX, step)).encode()
    o.ok(new.endswith(exp_line), "'%s' store IntelEngine.ini ends with this step's mark line" % prof)
    tm, lm = EXPECT_MARKS[step]
    gt, gl = marks(S.store_dir(c, S.TEST_PROFILE)), marks(S.store_dir(c, S.LUC_PROFILE))
    o.ok(gt == tm, "marks in the TEST store = %s (got %s)" % (sorted(tm), sorted(gt)))
    o.ok(gl == lm, "marks in LUCIENNE's store = %s (got %s)" % (sorted(lm), sorted(gl)))
    o.ok(marks(c.skse) == gt, "live files carry only the test store's marks %s (no Lucienne mark leaked into the rest state)" % sorted(gt))
    # logs
    tag = "recover" if kind == "kill_launcher" else "launch"
    lg = latest_swap_log(c, tag)
    if lg:
        txt = io.open(lg, encoding="utf-8", errors="replace").read()
        for needle in (["GAME exited", "COPY-BACK done", "MARKER state=CLEAN"] if kind != "kill_launcher" else ["COPY-BACK done", "recovered"]):
            o.ok(needle in txt, "swap log has '%s' (%s)" % (needle, os.path.basename(lg)))
    else:
        o.ok(False, "a swap log exists for this step (tag %s)" % tag)
    if o.fails == 0:
        n = snap(c)
        st.update({"test": n["test"], "luc": n["luc"], "live": n["live"]})
        st["steps_done"].append(step)
        save_state(st)
        o.info("step %d PASS; snapshot advanced" % step)
    else:
        o.info("step %d FAIL; snapshot NOT advanced" % step)
    return 1 if o.fails else 0


def swap_cmd(c, swap_args, *extra):
    return [sys.executable, "-u", os.path.join(HERE, "swap_launch.py")] + list(swap_args) + list(extra)


def cmd_refuse(c, swap_args):
    """Extra test, no game launch: a deliberately modified shared file must be refused at spec (b)."""
    o = Out()
    common_state_checks(c, o)
    p = os.path.join(c.skse, "IntelEngine.ini")
    before = S.hashes(c.skse)
    with open(p, "ab") as f:
        f.write(b"; roundtrip-tamper\n")
    tampered = S.hashes(c.skse)
    r = subprocess.run(swap_cmd(c, swap_args, "--profile", "Lucienne", "--unattended", "--no-tts"), capture_output=True, text=True)
    o.ok(r.returncode == 2, "launcher refused (exit 2, got %s)" % r.returncode)
    o.ok("do not match the marker" in (r.stdout or ""), "the refusal names the hash mismatch")
    o.ok(not S.running(c), "no game or MO2 was started")
    o.ok(S.hashes(c.skse) == tampered, "refusal changed nothing (live hashes equal the tampered ones)")
    o.ok((S.read_kv(c.marker) or {}).get("state") == "CLEAN", "marker still CLEAN")
    r = subprocess.run(swap_cmd(c, swap_args, "--reset-live"), capture_output=True, text=True)
    o.ok(r.returncode == 0, "--reset-live exit 0 (got %s)" % r.returncode)
    o.ok(S.hashes(c.skse) == before, "live files back to the owner's store copy (hashes equal the pre-tamper ones)")
    return 1 if o.fails else 0


def cmd_unmark(c):
    """Remove the roundtrip marks from both stores so Lucienne's store is byte-identical to its pre-test state."""
    st, o = need_state(), Out()
    if S.running(c):
        raise SystemExit("game/MO2 running")
    S.open_log(c, "unmark")
    S.acquire_lock(c)
    try:
        for prof in (S.TEST_PROFILE, S.LUC_PROFILE):
            d = S.store_dir(c, prof)
            p = os.path.join(d, "IntelEngine.ini")
            lines = io.open(p, "rb").read().split(b"\n")
            keep = [ln for ln in lines if not ln.startswith(MARK_PREFIX.encode())]
            io.open(p, "wb").write(b"\n".join(keep))
            S.write_manifest(c, prof, S.hashes(d), "roundtrip marks removed")
        ts = S.store_dir(c, S.TEST_PROFILE)
        S.put_all(c, ts, c.skse, S.hashes(ts), "unmark-live")
        S.write_marker(c, "CLEAN", c.rest, S.hashes(c.skse))
    finally:
        S.release_lock(c)
    now = {"test": S.hashes(S.store_dir(c, S.TEST_PROFILE)), "luc": S.hashes(S.store_dir(c, S.LUC_PROFILE))}
    o.ok(now["luc"] == st["orig"]["luc"], "Lucienne's store byte-identical to its pre-test hashes")
    o.ok(now["test"]["IntelEngine.ini"] == st["orig"]["test"]["IntelEngine.ini"], "test store IntelEngine.ini byte-identical to its pre-test hash")
    for n in S.FILES[:2]:
        if now["test"][n] != st["orig"]["test"][n]:
            o.info("test store %s differs from the pre-test hash (the test game rewrote it; fine)" % n)
    common_state_checks(c, o)
    return 1 if o.fails else 0


# ---------------------------------------------------------------- the game-driving part (NOT exercised offline)
def kill_game(c):
    r = subprocess.run(["taskkill", "/F", "/IM", c.game_exe], capture_output=True, text=True, creationflags=NOWIN)
    print("taskkill /F /IM %s -> %s" % (c.game_exe, (r.stdout or r.stderr).strip()))


def graceful_exit(c):
    """Normal exit: the harness's console 'qqq' (game.close); falls back to a window-close request (taskkill without /F)."""
    sys.path.insert(0, os.path.join(S.RESEARCH, "build", "tools", "harness"))
    try:
        import game
        if game.close(None, timeout=180):
            return True
    except Exception as e:      # MCP not answering at the main menu, or harness import trouble
        print("game.close unavailable (%s); asking the window to close" % e)
    subprocess.run(["taskkill", "/IM", c.game_exe], capture_output=True, creationflags=NOWIN)
    t0 = time.time()
    while time.time() - t0 < 120 and c.game_exe in S.running(c):
        time.sleep(3)
    return c.game_exe not in S.running(c)


def cmd_run(c, step, swap_args):
    prof, kind = STEPS[step]
    st = load_state()
    if step == 1 and (st is None or st.get("steps_done")):
        print("step 1: taking a fresh snapshot first")
        if cmd_pre(c, None):
            return 1
    elif st is None or (step - 1 not in st.get("steps_done", []) and step != 1):
        raise SystemExit("steps must run in order; done so far: %s" % (st or {}).get("steps_done"))
    sys.path.insert(0, os.path.join(S.RESEARCH, "build", "tools", "harness"))
    import game
    if not game.memory_ready(print, why="round-trip step %d" % step):    # RV-73 gates, as every harness launch
        return 1
    print("=== step %d: launch via swap_launch.py --profile '%s' (%s) ===" % (step, prof, kind))
    w = subprocess.Popen(swap_cmd(c, swap_args, "--profile", prof, "--unattended", "--no-tts"), creationflags=NEWCON)
    if cmd_during(c, step):
        print("during-checks failed; ending the game and stopping")
        kill_game(c)
        w.wait(timeout=600)
        return 1
    t0 = time.time()
    while time.time() - t0 < 420 and not game.mcp_up():      # let the main menu come up (normal exit needs MCP)
        time.sleep(5)
    cmd_mark(c, step)
    if kind == "normal":
        graceful_exit(c)
    elif kind == "kill_game":
        time.sleep(5)
        kill_game(c)
    else:   # kill_launcher: end the swap launcher's own process (not its children), then let the game exit normally
        pid = int(io.open(c.lock).read().split()[0])
        subprocess.run(["taskkill", "/F", "/PID", str(pid)], capture_output=True, creationflags=NOWIN)
        print("killed launcher pid %d; marker now %s" % (pid, (S.read_kv(c.marker) or {}).get("state")))
        graceful_exit(c)
        time.sleep(5)
    try:
        rc = w.wait(timeout=600)
    except subprocess.TimeoutExpired:
        rc = None
    if kind == "kill_launcher":
        r = subprocess.run(swap_cmd(c, swap_args, "--profile", prof, "--recover"), capture_output=True, text=True)
        print(r.stdout[-1500:])
        rc = r.returncode
        if rc != 0:
            return 1
    return cmd_check(c, step, rc)


def cmd_plan():
    print(__doc__)
    print("Steps (each is one launch; ~4-5 min each: launch 254-285 s + a short exit; no save is loaded, main menu only):")
    for n, (prof, kind) in STEPS.items():
        print("  %d. %-15s %-14s expected marks after: test=%s lucienne=%s" % (n, prof, kind, sorted(EXPECT_MARKS[n][0]), sorted(EXPECT_MARKS[n][1])))
    print("  +  refuse (no launch): tamper a shared file, the launcher must refuse; --reset-live repairs it")
    print("  +  unmark: remove the marks; Lucienne's store back to its exact pre-test hashes")
    return 0


def main():
    ap = argparse.ArgumentParser(description="round-trip test for swap_launch.py")
    ap.add_argument("cmd", choices=["plan", "pre", "run", "during", "mark", "check", "kill-game", "refuse", "unmark", "status"])
    ap.add_argument("step", nargs="?", type=int)
    ap.add_argument("--rc", type=int, default=0)
    ap.add_argument("--swap-args", default="[]", help="JSON list of extra swap_launch.py arguments (sandbox paths; selftest only)")
    a = ap.parse_args()
    sa = json.loads(a.swap_args)
    c = S.cfg_from_args(sa)
    if a.cmd == "plan":
        return cmd_plan()
    if a.cmd in ("run", "during", "mark", "check") and a.step not in STEPS:
        ap.error("step 1..5 required")
    return {"pre": lambda: cmd_pre(c, a), "run": lambda: cmd_run(c, a.step, sa), "during": lambda: cmd_during(c, a.step),
            "mark": lambda: cmd_mark(c, a.step), "check": lambda: cmd_check(c, a.step, a.rc), "kill-game": lambda: kill_game(c) or 0,
            "refuse": lambda: cmd_refuse(c, sa), "unmark": lambda: cmd_unmark(c),
            "status": lambda: subprocess.call(swap_cmd(c, sa, "--status"))}[a.cmd]()


if __name__ == "__main__":
    sys.exit(main())
