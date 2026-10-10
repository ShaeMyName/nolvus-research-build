"""Step-8 block driver (TASK_C step 8; time plan §5): one machine for U1-U4, the CF runs and the soak.
  block.py <BLOCK> [--only ID,ID] [--from ID] [--no-launch] [--keep-open] [--list]
Launches the test profile if needed (D2), loads the block's save, runs `smoke`, then each test in order. Every test is a
Run (its own result file and timings.csv row). Tests flagged reload=True leave the save dirty (kills, churn): the
driver reloads the block save after them. After each family, check_logs.py runs over that family's window (I5/I7/I8).
A summary goes to test_runs/<BLOCK>_<stamp>.md. Results from forced-state saves are marked "forced state"."""
import importlib, os, re, subprocess, sys, time
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.dirname(__file__))
import game
from runner import Run, OUT
sys.modules.setdefault("block", sys.modules[__name__])   # run as a script: test modules' `from block import test` must hit this module

TESTS = {}      # id -> dict(fn, family, save, reload, forced)


def test(tid, family, save="T0", reload=False, forced=False):
    def deco(fn):
        TESTS[tid] = dict(fn=fn, family=family, save=save, reload=reload, forced=forced)
        return fn
    return deco


BLOCKS = {}     # name -> dict(save, order: [ids], modules: [module names], est: {family: minutes})


def block(name, save, modules, order, est=None, fixed=None, harness=False, voices=True, relaunch_gb=20.0):
    """voices=False only for text/state blocks; the soak must run with voices (real-play config, SK-7 memory is the
    point: Shae 2026-10-10), enforced here. relaunch_gb: relaunch between tests when the game's private memory passes
    this (test blocks only; the soak never relaunches mid-run)."""
    if name.upper().startswith("SOAK") and not voices:
        raise ValueError("the soak must run with the voice server on (Shae 2026-10-10)")
    """est: unpadded estimate in minutes per family (time plan), spread evenly over that family's tests;
    fixed: {test id: minutes} for known long tests (B-20). Used only for the live ETA."""
    BLOCKS[name] = dict(save=save, modules=modules, order=order, est=est or {}, fixed=fixed or {}, harness=harness,
                        voices=voices, relaunch_gb=None if name.upper().startswith("SOAK") else relaunch_gb)


def test_estimates(b, order):
    fixed, est = b["fixed"], {}
    for fam, mins in b["est"].items():
        ids = [t for t in order if TESTS[t]["family"] in fam.split("/") and t not in fixed]
        for t in ids:
            est[t] = mins * 60.0 / max(1, len(ids))
    for t in order:
        est.setdefault(t, fixed.get(t, 2.0) * 60.0)
    return est


def progress(i, n, tid, verdict, secs, done_est, done_real, remaining_est, started):
    """One PROGRESS line per test (the session watches these for live ETA pushes, Shae 2026-10-10). The ETA includes
    the overhead between tests (reloads, relaunches) at the rate measured so far (reviewer 2026-10-10)."""
    ratio = done_real / done_est if done_est else 1.0
    elapsed = time.time() - started
    overhead = max(0.0, elapsed - done_real) / max(i, 1) * (n - i)
    eta = remaining_est * ratio + overhead
    print("PROGRESS %d/%d %s %s %ds | elapsed %.0f min | pace x%.2f of estimate | overhead %.0f s/test | game %.1f GB | "
          "ETA %.0f min (done ~%s)"
          % (i, n, tid, verdict, secs, elapsed / 60, ratio, max(0.0, elapsed - done_real) / max(i, 1),
             game.game_private_gb(), eta / 60, time.strftime("%H:%M", time.localtime(time.time() + eta))), flush=True)


IE_ACTIONS = ("GoToLocation", "DeliverMessage", "FetchPerson", "EscortTarget", "SearchForActor", "ScheduleFetch",
              "ScheduleDelivery", "ScheduleMeeting")


def ie_test_settings(ctl):
    """After every load: IntelEngine as the spec's automated-run setup (§15.0) needs it, set through IntelEngine's own
    dashboard handler (IntelEngine_Core.OnDashboardSetting :2073): all 8 SkipFollower* off (IntelEngine's default; T0
    carried them ON from an earlier dashboard session, U1 start 2026-10-10) and all 8 Confirm* 0 (automated runs only;
    Lucienne's game keeps IntelEngine's defaults). Verified by IEB_TestCtl.SkipProbe."""
    for a in IE_ACTIONS:
        for key, val in (("skipFollower" + a, 0.0), ("confirm" + a, 0.0)):
            ctl.tool("execute_quest_function", {"quest_editor_id": "IntelEngine", "script_name": "IntelEngine_Core",
                                                "function_name": "OnDashboardSetting",
                                                "arguments": ["IntelEngine_DashboardSetting", key, val, None]})
    ok, last = False, "no probe line"
    for _ in range(8):          # the handler runs in Papyrus, which lags in this load order: re-read until all off
        t = game.Tail(game.LOGS["papyrus"])
        ctl.ctl("SkipProbe")
        m = t.wait(r"\[IEB-TEST\] SkipProbe (.*)", timeout=20)
        if m:
            last = m.group(1)
            if "=1" not in last.split(" saved=")[0]:
                ok = True
                time.sleep(10)  # the last Confirm* call was queued after the last skip; SkipProbe doesn't read Confirm*
                break
        time.sleep(8)
    ctl.log("IE test settings: skip-follower off, confirm 0 -> %s (%s)" % ("verified" if ok else "NOT VERIFIED", last))
    return ok


def load_block_save(ctl, b):
    if not game.load(ctl, b["save"], settle_probe(ctl)):
        return False
    return ie_test_settings(ctl)


def settle_probe(r):
    """Actions-ready probe on T0: F1 (Jenassa) has any eligible action. (SitOrLayDown on Carlotta needs furniture in
    range, so it can stay false all day: U1 start 2026-10-10.)"""
    return ("__any__", lambda: r.uuid(0xE1BA9)[0])


def run_block(name, only=None, start=None, launch=True, keep_open=False):
    b = BLOCKS[name]
    for m in b["modules"]:
        importlib.import_module(m)
    order = [t for t in b["order"] if (not only or t in only)]
    if start:
        order = order[order.index(start):]
    missing = [t for t in order if t not in TESTS]
    stamp = time.strftime("%Y%m%d-%H%M%S")
    summary = ["# %s %s" % (name, stamp), "", "| Test | Verdict | Seconds | Note |", "|---|---|---|---|"]
    if missing:
        print("NOT IMPLEMENTED (skipped): %s" % ", ".join(missing))
        summary.append("| %s | NOT IMPLEMENTED | | skipped |" % ", ".join(missing))
        order = [t for t in order if t in TESTS]
    if game.harness_mode() != b["harness"]:
        if "SkyrimSE.exe" in game.procs():
            print("BLOCK ABORT %s: harness mode must be %s; close the game first" % (name, b["harness"]), flush=True)
            return 1
        if not game.set_harness_mode(b["harness"]):
            print("BLOCK ABORT %s: could not set harness mode" % name, flush=True)
            return 1
    print("HARNESS mode %s for %s" % ("on" if game.harness_mode() else "off", name), flush=True)
    if "SkyrimSE.exe" not in game.procs():
        if not launch or not game.launch(print, voices=b["voices"]):
            print("BLOCK ABORT %s: game did not launch" % name, flush=True)
            return 1
    ctl = Run("%s_CONTROL" % name)              # MCP session only once the game answers
    if not load_block_save(ctl, b):
        ctl.save()
        return 1
    import runner
    if runner.smoke([]):
        ctl.log("ABORT: smoke failed")
        print("BLOCK ABORT %s: smoke failed" % name, flush=True)
        ctl.save()
        return 1
    fam, fam_start, results = None, time.strftime("%Y-%m-%d %H:%M:%S"), []
    est = test_estimates(b, order)
    crashes = 0
    started, done_est, done_real = time.time(), 0.0, 0.0
    for i, tid in enumerate(order, 1):
        meta = TESTS[tid]
        if fam and meta["family"] != fam:
            family_logs(ctl, fam, fam_start, summary)
            fam_start = time.strftime("%Y-%m-%d %H:%M:%S")
        fam = meta["family"]
        try:
            r = Run(tid)
        except Exception as e:          # MCP gone: the game died between tests
            r = None
        if r is None or "SkyrimSE.exe" not in game.procs():
            ctl = recover(ctl, name, b, "before " + tid, summary)
            if ctl is None:
                return 1
            crashes += 1
            r = Run(tid)
        r.forced = meta["forced"]
        if game.LAST_NUDGE:     # reviewer 2026-10-10: the settle nudge adds one real F1 reply to SkyrimNet history
            r.log("NOTE %s: the last load's settle nudge added one F1 narration to SkyrimNet history (%s)"
                  % (tid, game.LAST_NUDGE))
        r.tails = {k: game.Tail(p) for k, p in game.LOGS.items()}
        t0 = time.time()
        try:
            meta["fn"](r)
        except Exception as e:          # a harness bug fails the test, not the block
            r.inconclusive += 1
            r.log("INCONCLUSIVE %s harness error: %r" % (tid, e))
        crashed = "SkyrimSE.exe" not in game.procs()
        if not crashed:     # Shae 2026-10-10: show it if our own code flips IntelEngine's switches mid-run
            try:
                pt = game.Tail(game.LOGS["papyrus"])
                r.ctl("SkipProbe")
                pm = pt.wait(r"\[IEB-TEST\] SkipProbe (.*)", timeout=20)
                state = pm.group(1) if pm else "no probe line"
                flipped = pm is not None and "=1" in state.split(" saved=")[0]
                r.log("%s IE skip-follower switches at test end: %s" % ("WARN" if flipped else "NOTE", state))
                if flipped:
                    summary.append("| %s | IE skip switches ON at test end | | %s |" % (tid, state))
            except Exception as e:
                r.log("NOTE IE switch probe failed: %r" % (e,))
        if crashed:
            r.inconclusive += 1
            r.log("INCONCLUSIVE %s: the game crashed during the test (see the newest SKSE crash-*.log)" % tid)
        if r.forced:
            r.log("NOTE %s: forced state (weaker evidence than natural play)" % tid)
        wtext = r.tails["watch"].read()
        gap = held_gap(wtext)
        if gap:     # reviewer 2026-10-10: the 30 s sampling bug must never come back silently
            r.inconclusive += 1
            r.log("INCONCLUSIVE %s: watcher interval regressed (%s)" % (tid, gap))
        inv = [l for l in wtext.splitlines() if re.search(r"ASSERT FAIL I\d", l)]
        for l in inv:
            r.check(False, "watcher invariant: " + l.strip())
        verdict = r.save()
        summary.append("| %s | %s | %d | %s |" % (tid, verdict, time.time() - t0, "forced state" if r.forced else ""))
        results.append((tid, verdict))
        done_est += est[tid]
        done_real += time.time() - t0
        progress(i, len(order), tid, verdict, time.time() - t0, done_est, done_real,
                 sum(est[t] for t in order[i:]), started)
        if inv:     # TASK_C: a failing invariant stops its block; leave the game in place for inspection
            summary.append("| HALT | invariant failed in %s | | game left running |" % tid)
            open(OUT + "%s_%s.md" % (name, stamp), "w", encoding="utf-8").write("\n".join(summary) + "\n")
            ctl.log("HALT after %s: watcher invariant failed; game left running" % tid)
            print("BLOCK HALT %s after %s" % (name, tid), flush=True)
            ctl.save()
            return 1
        if crashed:
            crashes += 1
            if crashes > MAX_CRASHES:
                print("BLOCK ABORT %s: %d game crashes" % (name, crashes), flush=True)
                ctl.log("ABORT: %d game crashes" % crashes)
                open(OUT + "%s_%s.md" % (name, stamp), "w", encoding="utf-8").write("\n".join(summary) + "\n")
                return 1
            ctl = recover(ctl, name, b, "in " + tid, summary)
            if ctl is None:
                return 1
        elif b["relaunch_gb"] and game.game_private_gb() > b["relaunch_gb"]:
            gb = game.game_private_gb()
            print("BLOCK RELAUNCH %s after %s: game at %.1f GB" % (name, tid, gb), flush=True)
            summary.append("| relaunch | game at %.1f GB after %s | | |" % (gb, tid))
            game.close(ctl)
            time.sleep(15)
            if not game.launch(print, voices=b["voices"]):
                print("BLOCK ABORT %s: relaunch failed" % name, flush=True)
                return 1
            ctl = Run("%s_CONTROL" % name)
            if not load_block_save(ctl, b):
                print("BLOCK ABORT %s: reload after relaunch failed" % name, flush=True)
                return 1
        elif meta["reload"]:
            load_block_save(ctl, b)
    if fam:
        family_logs(ctl, fam, fam_start, summary)
    if not keep_open:
        game.close(ctl)
        if b["harness"]:        # D1: asserted off after each block
            ok = game.set_harness_mode(False, ctl.log)
            summary.append("| harness mode off after the block | %s | | |" % ("verified" if ok else "FAILED"))
    p = OUT + "%s_%s.md" % (name, stamp)
    open(p, "w", encoding="utf-8").write("\n".join(summary) + "\n")
    ctl.log("summary %s" % p)
    print("BLOCK DONE %s %d/%d not ALL PASS; %.0f min" % (name, sum(1 for _, v in results if v != "ALL PASS"),
                                                         len(results), (time.time() - started) / 60), flush=True)
    ctl.save()
    return sum(1 for _, v in results if v != "ALL PASS")


def held_gap(text, limit=4.5):
    """Largest gap between consecutive watcher ticks while any actor is held (iebHeld 1/2), if above `limit` s."""
    ticks = []
    for l in text.splitlines():
        m = re.search(r"\brt=([0-9.]+) gt=", l)
        if not m or "BURST" in l or "probe" in l or "snapshot" in l:
            continue
        t = float(m.group(1))
        held = re.search(r"\biebHeld=[12]\b", l) is not None
        if ticks and t - ticks[-1][0] <= 1.5:
            ticks[-1] = (ticks[-1][0], ticks[-1][1] or held)
        else:
            ticks.append((t, held))
    worst = 0.0
    for (a, ha), (b, hb) in zip(ticks, ticks[1:]):
        if ha and hb and a <= b:
            worst = max(worst, b - a)
    return ("%.1f s between ticks while held" % worst) if worst > limit else ""


MAX_CRASHES = 3


def recover(ctl, name, b, where, summary):
    """The game died: note it, relaunch, reload the block save, return a fresh control Run (None if that fails)."""
    print("BLOCK CRASH %s %s: relaunching" % (name, where), flush=True)
    summary.append("| CRASH | game crashed %s | | relaunched |" % where)
    game.close(None, timeout=30)
    time.sleep(10)
    if not game.launch(print, voices=b["voices"]):
        print("BLOCK ABORT %s: relaunch after a crash failed" % name, flush=True)
        return None
    ctl = Run("%s_CONTROL" % name)
    if not load_block_save(ctl, b):
        print("BLOCK ABORT %s: reload after a crash failed" % name, flush=True)
        return None
    return ctl


def family_logs(ctl, fam, since, summary):
    res = subprocess.run([sys.executable, os.path.join(os.path.dirname(__file__), "check_logs.py"), "--since", since],
                         capture_output=True, text=True)
    fails = [l for l in res.stdout.splitlines() if l.startswith("ASSERT FAIL")]
    ctl.log("check_logs %s since %s: %s" % (fam, since, "PASS" if res.returncode == 0 else "%d FAIL" % len(fails)))
    for l in fails:
        ctl.log("  " + l)
    summary.append("| check_logs %s | %s | | I5/I7/I8 |" % (fam, "PASS" if res.returncode == 0 else "%d FAIL" % len(fails)))


def main(a):
    import blocks_def  # noqa: F401  (registers BLOCKS)
    if not a or a[0] == "--list":
        for n, b in BLOCKS.items():
            for m in b["modules"]:
                importlib.import_module(m)
            done = [t for t in b["order"] if t in TESTS]
            print("%s (save %s): %d tests, %d implemented" % (n, b["save"], len(b["order"]), len(done)))
            print("  missing: %s" % ", ".join(t for t in b["order"] if t not in TESTS))
        return 0
    opt = lambda k: a[a.index(k) + 1] if k in a else None
    only = set(opt("--only").split(",")) if opt("--only") else None
    return run_block(a[0], only, opt("--from"), "--no-launch" not in a, "--keep-open" in a)


if __name__ == "__main__":
    try:
        rc = main(sys.argv[1:])
    except BaseException as e:      # reviewer 2026-10-10: an unattended block always ends with DONE, ABORT or HALT
        print("BLOCK ABORT %s: %s %r" % (sys.argv[1] if len(sys.argv) > 1 else "?", type(e).__name__, e), flush=True)
        raise
    sys.exit(1 if rc else 0)
