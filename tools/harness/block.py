"""Step-8 block driver (TASK_C step 8; time plan §5): one machine for U1-U4, the CF runs and the soak.
  block.py <BLOCK> [--only ID,ID] [--from ID] [--no-launch] [--keep-open] [--list] [--setup-only]
Launches the test profile if needed (D2), loads the block's save, runs `smoke`, then each test in order. Every test is a
Run (its own result file and timings.csv row). Tests flagged reload=True leave the save dirty (kills, churn): the
driver reloads the block save after them. After each family, check_logs.py runs over that family's window (I5/I7/I8).
A summary goes to test_runs/<BLOCK>_<stamp>.md. Results from forced-state saves are marked "forced state".

--setup-only (post_u1_build_plan.md "Setup-only pass", Shae 2026-10-10): every test runs its OWN code up to its
checkpoint(r) call, which sits after its setup and precondition checks and before its first main action (StartTask,
Dispatch, kill, Accelerate, LLM wait), and stops there. One source: the real run executes the same lines (checkpoint
is a no-op then). Reloads, relaunches, family log checks run as in the real block. Summary: one SETUP OK / SETUP FAIL
(reason) line per test in test_runs/<BLOCK>_setup_<stamp>.md."""
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


# ---------------------------------------------------------------- setup-only pass (one source for both modes)
class SetupReached(BaseException):
    """Raised by checkpoint() in setup-only mode. A BaseException, so a test's own `except Exception` never swallows
    it, while every `finally:` and `with` exit between the checkpoint and the run loop still runs (the test's own
    cleanup undoes what its setup started)."""


def checkpoint(r, note=""):
    """End of the test's setup + precondition checks, right before its first main action. Real run: no-op.
    Setup-only run: stop the test here (SETUP OK unless a precondition or check before it failed). `note` is shown
    in the summary (e.g. a setup step that is left to the real test)."""
    if getattr(r, "setup_only", False):
        r.setup_reached = True
        r.setup_note = note
        r.log("SETUP checkpoint reached%s" % (": " + note if note else ""))
        raise SetupReached()


def setup_skip(r):
    """For a loop whose every pass has its own setup and precondition: `if setup_skip(r): continue` right before the
    pass's main action. Real run: False (no-op). Setup-only run: marks the checkpoint reached and returns True, so the
    next pass's setup runs too; the test then needs a checkpoint(r) after the loop."""
    if getattr(r, "setup_only", False):
        r.setup_reached = True
        r.log("SETUP checkpoint reached (loop pass)")
        return True
    return False


def call_test(fn, r):
    """Run one test function as the block does. SetupReached ends a setup-only test normally; any other exception is a
    harness error (INCONCLUSIVE), never a block abort."""
    try:
        fn(r)
    except SetupReached:
        pass
    except Exception as e:
        r.inconclusive += 1
        r.log("INCONCLUSIVE %s harness error: %r" % (r.name, e))


def setup_verdict(r):
    """(verdict, reason) of one setup-only run: SETUP FAIL with the first INCONCLUSIVE/FAIL line (a precondition miss,
    an unconfirmed controller call, a failed check or cleanup check), SETUP FAIL if the test returned before its
    checkpoint, else SETUP OK (reason = the checkpoint note and any WARN line)."""
    bad = [l.strip() for l in r.lines if l.startswith(("INCONCLUSIVE", "FAIL"))]
    if bad:
        return "SETUP FAIL", bad[0]
    if r.fails or r.inconclusive:
        return "SETUP FAIL", "%d FAIL, %d INCONCLUSIVE" % (r.fails, r.inconclusive)
    if not getattr(r, "setup_reached", False):
        return "SETUP FAIL", "the test returned before its setup checkpoint"
    notes = [getattr(r, "setup_note", "")] + [l.strip() for l in r.lines if "WARN" in l][:2]
    return "SETUP OK", "; ".join(x for x in notes if x)


def setup_line(tid, verdict, reason):
    """The one stdout line per test: 'SETUP OK <id>' / 'SETUP OK <id> (note)' / 'SETUP FAIL <id> (reason)'."""
    return "%s %s%s" % (verdict, tid, " (%s)" % reason[:200] if reason else "")


def setup_row(tid, verdict, reason, secs):
    """The summary row: | id | SETUP OK / SETUP FAIL (reason) | seconds | |."""
    cell = "%s (%s)" % (verdict, reason[:200].replace("|", "/")) if reason else verdict
    return "| %s | %s | %d | |" % (tid, cell, secs)


# Tests that need GameMaster on (Shae 2026-10-10: if unsure, keep it on). A block with gamemaster=False refuses to start
# if it contains one. Filled from investigation/round10/gamemaster_tests.md.
GM_TESTS = {"GM-HOUR", "RE-5", "TT-9", "AZ-4", "AZ-6", "TT-14", "AZ-12", "AZ-9", "RE-2", "RE-3", "RE-4", "X-9", "NT-2",
            "ENT-9", "WE-6", "SK-11", "SK-8", "OR-2", "OR-4", "OR-5", "FEEL-CHECK"}   # GM-HOUR / FEEL-CHECK: S-C and soak ids
GM_STATE = [None]
BLOCKS = {}     # name -> dict(save, order: [ids], modules: [module names], est: {family: minutes})


def block(name, save, modules, order, est=None, fixed=None, harness=False, voices=True, relaunch_avail_gb=3.0,
          gamemaster=True, launch_min_avail_gb=None):
    """voices=False only for text/state blocks; the soak must run with voices (real-play config, SK-7 memory is the
    point: Shae 2026-10-10), enforced here. relaunch_avail_gb: relaunch between tests when Windows' available physical
    memory drops below this [CHANGED 2026-10-10, Shae: total system memory near 31 GB is the concern, not the game's own
    size; one T0 load alone is ~23 GB private]. 3 GB rather than the reviewer's 2 GB: Claude Code's memory-pressure
    reaper stopped the runner at ~2.1 GB free. Test blocks only; the soak never relaunches mid-run."""
    if name.upper().startswith("SOAK") and not voices:
        raise ValueError("the soak must run with the voice server on (Shae 2026-10-10)")
    """est: unpadded estimate in minutes per family (time plan), spread evenly over that family's tests;
    fixed: {test id: minutes} for known long tests (B-20). Used only for the live ETA."""
    BLOCKS[name] = dict(save=save, modules=modules, order=order, est=est or {}, fixed=fixed or {}, harness=harness, gamemaster=gamemaster,
                        voices=voices, launch_min_avail_gb=launch_min_avail_gb,
                        relaunch_avail_gb=None if name.upper().startswith("SOAK") else relaunch_avail_gb)


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
    print("PROGRESS %d/%d %s %s %ds | elapsed %.0f min | pace x%.2f of estimate | overhead %.0f s/test | game %.1f GB, "
          "%.1f GB RAM available | "
          "ETA %.0f min (done ~%s)"
          % (i, n, tid, verdict, secs, elapsed / 60, ratio, max(0.0, elapsed - done_real) / max(i, 1),
             game.game_private_gb(), game.available_ram_gb(), eta / 60,
             time.strftime("%H:%M", time.localtime(time.time() + eta))), flush=True)


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
    phase("LOAD")
    if not game.load(ctl, b["save"], settle_probe(ctl)):
        return False
    return ie_test_settings(ctl)


def settle_probe(r):
    """Actions-ready probe on T0: F1 (Jenassa) has any eligible action. (SitOrLayDown on Carlotta needs furniture in
    range, so it can stay false all day: U1 start 2026-10-10.)"""
    return ("__any__", lambda: r.uuid(0xE1BA9)[0])


# REVIEW_LOG RV-87 (2): in setup-only mode reload only after the tests whose SETUP dirties the save (DECISIONS:411
# "between groups", 30-45 min target). A test that later fails setup in a real block is added to SETUP_RELOAD_EXTRA
# (one ID per line) and reloads in the setup pass from then on. Others report "SETUP OK (no reload)".
SETUP_RELOAD = {"B-6b", "B-6d", "X-1", "X-3", "X-7", "L-6", "K-2", "RS-4", "RS-8", "REL-2"}
SETUP_RELOAD_EXTRA = "C:/nolvus-research/test_runs/setup_reload_extra.txt"


def setup_reloads():
    extra = set()
    try:
        extra = {l.strip() for l in open(SETUP_RELOAD_EXTRA, encoding="utf-8") if l.strip() and not l.startswith("#")}
    except OSError:
        pass
    return SETUP_RELOAD | extra


SETUP_EST_S = 45.0     # setup-only ETA per test (base/moveto/probe/settle); the pace factor corrects it


def run_block(name, only=None, start=None, launch=True, keep_open=False, setup_only=False):
    b = BLOCKS[name]
    for m in b["modules"]:
        importlib.import_module(m)
    order = [t for t in b["order"] if (not only or t in only)]
    if start:
        order = order[order.index(start):]
    missing = [t for t in order if t not in TESTS]
    stamp = time.strftime("%Y%m%d-%H%M%S")
    if setup_only:      # own summary/archive names: a setup pass never reads as a real block result
        stamp = "setup_" + stamp
    ok_word = "SETUP OK" if setup_only else "ALL PASS"
    summary = ["# %s %s%s" % (name, stamp, " (SETUP-ONLY: setup + precondition per test, no main action)" if setup_only
                              else ""), "", "| Test | Verdict | Seconds | Note |", "|---|---|---|---|"]
    game.set_archive("%s_%s" % (name, stamp))
    if missing:
        print("NOT IMPLEMENTED (skipped): %s" % ", ".join(missing))
        summary.append("| %s | NOT IMPLEMENTED | | skipped |" % ", ".join(missing))
        order = [t for t in order if t in TESTS]
    start_heartbeat(name)          # before the launch: a resumed block is covered from its first second
    game.profile_snapshot()        # reviewer: compared after any forced MO2 close, before a relaunch
    phase("LAUNCH")
    if game.harness_mode() != b["harness"]:
        if "SkyrimSE.exe" in game.procs():
            print("BLOCK ABORT %s: harness mode must be %s; close the game first" % (name, b["harness"]), flush=True)
            return 1
        if not game.set_harness_mode(b["harness"]):
            print("BLOCK ABORT %s: could not set harness mode" % name, flush=True)
            return 1
    print("HARNESS mode %s for %s" % ("on" if game.harness_mode() else "off", name), flush=True)
    # GameMaster per block (Shae 2026-10-10): off only when the block has no GameMaster-dependent test.
    gm_need = [t for t in order if t in GM_TESTS]
    if not b["gamemaster"] and gm_need:
        print("BLOCK ABORT %s: GameMaster off but these tests need it: %s" % (name, ", ".join(gm_need)), flush=True)
        return 1
    if game.gamemaster() != b["gamemaster"]:
        if "SkyrimSE.exe" in game.procs():
            print("BLOCK ABORT %s: GameMaster must be %s; close the game first" % (name, b["gamemaster"]), flush=True)
            return 1
        if not game.set_gamemaster(b["gamemaster"]):
            print("BLOCK ABORT %s: could not set GameMaster" % name, flush=True)
            return 1
    GM_STATE[0] = game.gamemaster()
    print("GAMEMASTER %s for %s" % ("on" if GM_STATE[0] else "off", name), flush=True)
    summary.append("| GameMaster | %s for the block | | |" % ("on" if GM_STATE[0] else "off"))
    if "SkyrimSE.exe" not in game.procs():
        need = b.get("launch_min_avail_gb")
        if need and game.available_ram_gb() < need:       # REVIEW_LOG RV-90 (5): voice server only with headroom
            print("BLOCK ABORT %s: %.1f GB available < %.0f GB required to start (voices=%s)" %
                  (name, game.available_ram_gb(), need, b["voices"]), flush=True)
            return 1
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
    est = {t: SETUP_EST_S for t in order} if setup_only else test_estimates(b, order)
    setup_set = setup_reloads() if setup_only else set()
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
        if r is None and "SkyrimSE.exe" in game.procs() and game.mcp_stall_check(print):
            summary.append("| MCP_STALL | before %s, recovered without a relaunch | | |" % tid)
            try:
                r = Run(tid)
            except Exception:
                r = None
        if r is None or "SkyrimSE.exe" not in game.procs():
            ctl = recover(ctl, name, b, "before " + tid, summary)
            if ctl is None:
                return 1
            crashes += 1
            r = Run(tid)
        r.forced = meta["forced"]
        r.setup_only = setup_only
        if game.LAST_NUDGE:     # reviewer 2026-10-10: the settle nudge adds one real F1 reply to SkyrimNet history
            r.log("NOTE %s: the last load's settle nudge added one F1 narration to SkyrimNet history (%s)"
                  % (tid, game.LAST_NUDGE))
        r.tails = {k: game.Tail(p) for k, p in game.LOGS.items()}
        r.log("NOTE %s: GameMaster %s" % (tid, "on" if GM_STATE[0] else "off"))
        phase(tid)
        r.log("NOTE %s: RAM available at start %.1f GB (game %.1f GB private)" % (tid, game.available_ram_gb(),
                                                                                game.game_private_gb()))
        t0 = time.time()
        call_test(meta["fn"], r)        # a harness bug fails the test, not the block; SetupReached ends a setup-only test
        crashed = "SkyrimSE.exe" not in game.procs()
        if not crashed:
            # REVIEW_LOG RV-87 (1): crash context after every test (game hour, days, Saffir's package/3D: the actor in
            # both 2026-10-10/11 crash logs, signature SkyrimSE+067496C / AI Overhaul pkg 0xCF001957). Fire and forget:
            # the line lands in Papyrus.0.log, which is archived with any crash.
            try:
                ctl.ctl("CrashCtx", [0x0001A66C], sync=False)
            except Exception:
                pass
        else:
            try:
                pap = open(game.LOGS["papyrus"], "rb").read().decode("utf-8", "replace")
            except OSError:
                pap = ""
            last = re.findall(r"CRASHCTX [^\r\n]*", pap)
            r.log("NOTE %s: last crash context before the crash: %s" % (tid, last[-1] if last else "none in Papyrus.0.log"))
        # Reviewer 2026-10-10 (U1 run 16, 14:50): a guard defeated the test player and Shadow of Skyrim jailed and stripped
        # her; every later test ran on that state. Any defeat/bleedout makes this test INCONCLUSIVE and forces a relaunch.
        defeat = player_defeated(r.tails["papyrus"].read(), r.tails["skyrimnet"].read())
        # Reviewer 2026-10-10: timeout-driven FAIL/INCONCLUSIVE under memory pressure is classified separately.
        r.log("NOTE %s: RAM available at end %.1f GB%s" % (tid, game.available_ram_gb(),
              " (UNDER MEMORY PRESSURE: < 3 GB)" if game.available_ram_gb() < 3.0 else ""))
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
        if defeat and not crashed:
            r.inconclusive += 1
            r.log("INCONCLUSIVE %s: the player was defeated during the test (%s); relaunching" % (tid, defeat))
            summary.append("| %s | PLAYER DEFEATED (%s) | | relaunched |" % (tid, defeat))
        if r.forced:
            r.log("NOTE %s: forced state (weaker evidence than natural play)" % tid)
        wtext = r.tails["watch"].read()
        gap = held_gap(wtext)
        if gap:     # reviewer 2026-10-10: the 30 s sampling bug must never come back silently
            r.inconclusive += 1
            r.log("INCONCLUSIVE %s: watcher interval regressed (%s)" % (tid, gap))
        trans = len(re.findall(r"I3 TRANSIENT", wtext))
        if trans:   # reviewer 2026-10-10: transients are counted per test and per block
            r.log("NOTE %s: %d I3 TRANSIENT reading(s) (cleared on the 1 s re-read)" % (tid, trans))
            TRANSIENTS["I3"] = TRANSIENTS.get("I3", 0) + trans
        inv = [l for l in wtext.splitlines() if re.search(r"ASSERT FAIL I\d", l)]
        for l in inv:
            r.check(False, "watcher invariant: " + l.strip())
        verdict = r.save()
        skip_reload = setup_only and meta["reload"] and tid not in setup_set
        if setup_only:
            verdict, why = setup_verdict(r)
            if skip_reload:
                why = "no reload" + ("; " + why if why else "")
            print(setup_line(tid, verdict, why), flush=True)
            summary.append(setup_row(tid, verdict, why, time.time() - t0))
        else:
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
        elif b["relaunch_avail_gb"] and game.available_ram_gb() < b["relaunch_avail_gb"] and                 game.POST_LOAD_AVAIL - game.available_ram_gb() < RELAUNCH_MIN_DROP_GB:
            # Low, but not because the game grew since its load: a relaunch can't help (a fresh load lands at the same
            # level), so warn instead of relaunch-looping (2026-10-10: 4.1 GB available at idle T0, no voices).
            print("BLOCK MEMORY WARN %s after %s: %.1f GB RAM available, %.1f GB below the post-load level; no relaunch"
                  % (name, tid, game.available_ram_gb(), game.POST_LOAD_AVAIL - game.available_ram_gb()), flush=True)
        elif b["relaunch_avail_gb"] and game.available_ram_gb() < b["relaunch_avail_gb"]:
            av, gb = game.available_ram_gb(), game.game_private_gb()
            print("BLOCK RELAUNCH %s after %s: %.1f GB RAM available (game %.1f GB private)" % (name, tid, av, gb),
                  flush=True)
            summary.append("| relaunch | %.1f GB RAM available after %s (game %.1f GB) | | |" % (av, tid, gb))
            phase("RELAUNCH")
            game.close(ctl)
            time.sleep(15)
            if not game.launch(print, voices=b["voices"]):
                print("BLOCK ABORT %s: relaunch failed" % name, flush=True)
                return 1
            ctl = Run("%s_CONTROL" % name)
            if not load_block_save(ctl, b):
                print("BLOCK ABORT %s: reload after relaunch failed" % name, flush=True)
                return 1
        elif defeat:
            DEFEATS[0] += 1
            if DEFEATS[0] >= 2:     # reviewer: two defeats = a test or the harness provokes guards; stop and trace
                summary.append("| HALT | second player defeat in the block (%s) | | game left running |" % tid)
                open(OUT + "%s_%s.md" % (name, stamp), "w", encoding="utf-8").write("\n".join(summary) + "\n")
                ctl.log("HALT after %s: second player defeat in the block; game left running" % tid)
                print("BLOCK HALT %s after %s: second player defeat" % (name, tid), flush=True)
                ctl.save()
                return 1
            ctl = recover(ctl, name, b, "after a player defeat in " + tid, summary, why="PLAYER DEFEATED")
            if ctl is None:
                return 1
        elif game.SAVE_FAILED:
            # A failed console save leaves Papyrus' VM frozen, and a load after it hangs (U1 run 15: IEB_B3b_pre failed
            # 13:54:14; 'load T0' at 13:56:23 never reached PostLoadGame in 480 s). Relaunch instead of reloading.
            game.SAVE_FAILED = False
            ctl = recover(ctl, name, b, "after a failed console save in " + tid, summary, why="SAVE FAILED")
            if ctl is None:
                return 1
        elif meta["reload"] and not skip_reload:
            if not load_block_save(ctl, b):     # never run the next test on a game that didn't load
                ctl = recover(ctl, name, b, "after a failed reload in " + tid, summary, why="RELOAD FAILED")
                if ctl is None:
                    return 1
    if fam:
        family_logs(ctl, fam, fam_start, summary)
    if not keep_open:
        phase("CLOSE")
        game.close(ctl)
        if not b["gamemaster"]:     # Shae 2026-10-10: restored on after the block (soak and real config untouched)
            okg = game.set_gamemaster(True, ctl.log)
            summary.append("| GameMaster restored on after the block | %s | | |" % ("verified" if okg else "FAILED"))
        if b["harness"]:        # D1: asserted off after each block
            ok = game.set_harness_mode(False, ctl.log)
            summary.append("| harness mode off after the block | %s | | |" % ("verified" if ok else "FAILED"))
    summary.append("| watcher transients | %s | | re-read cleared within 1 s |"
                   % (", ".join("%s=%d" % kv for kv in sorted(TRANSIENTS.items())) or "none"))
    narch = game.archive_logs("end")
    lf = game.log_findings()      # REVIEW_LOG RV-76 (3)/(5): any count above 0 is a finding
    summary.append("| IE key/array findings (%d session(s)) | %s | | blank-key LOADKEYS fac=TRUE=%d TASKTYPE_RESTORED=%d array errors=%d (info: teardown-at-save blanks fac=False=%d) |"
                   % (lf.get("sessions", 0), "FINDING" if any(lf.get(k) for k in ("blank_key_loadkeys",
                      "tasktype_restored", "array_errors")) else "none", lf.get("blank_key_loadkeys", 0),
                      lf.get("tasktype_restored", 0), lf.get("array_errors", 0),
                      lf.get("blank_key_teardown_info", 0)))
    p = OUT + "%s_%s.md" % (name, stamp)
    open(p, "w", encoding="utf-8").write("\n".join(summary) + "\n")
    ctl.log("summary %s" % p)
    ctl.log("raw logs archived: %d file(s) in %s" % (narch, game.ARCHIVE[0]))
    print("BLOCK DONE %s %d/%d not %s; %.0f min" % (name, sum(1 for _, v in results if v != ok_word),
                                                   len(results), ok_word, (time.time() - started) / 60), flush=True)
    ctl.save()
    return sum(1 for _, v in results if v != ok_word)


def held_gap(text, limit=6.0):   # 6 s = 2x nominal; observed max 4.5 s on T0 after the fix (reviewer 2026-10-10)
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


HEARTBEAT = {"test": "", "file": "", "since": 0.0, "stuck_said": ""}
TRANSIENTS = {}     # invariant -> count of watcher TRANSIENT readings in this block


def phase(p):
    """Current phase for the heartbeat: LAUNCH / LOAD / SETTLE / <test id> / RELAUNCH / CLOSE (reviewer 2026-10-10)."""
    if HEARTBEAT["test"] != p:
        HEARTBEAT["test"], HEARTBEAT["since"] = p, time.time()


def start_heartbeat(name):
    """A runner killed from outside prints nothing, so a daemon thread writes test_runs/<BLOCK>_heartbeat.txt every 30 s
    (epoch, time, phase, seconds in phase) from block start, before the launch; the session's Monitor alarms when it is
    older than 3 min. A phase that sits more than 10 min prints PHASE STUCK once (a live but stuck runner)."""
    import threading
    HEARTBEAT["file"] = OUT + "%s_heartbeat.txt" % name
    HEARTBEAT["since"] = time.time()

    def beat():
        while True:
            dur = time.time() - HEARTBEAT["since"]
            try:
                with open(HEARTBEAT["file"], "w", encoding="utf-8") as f:
                    f.write("%d %s %s %ds\n" % (time.time(), time.strftime("%H:%M:%S"), HEARTBEAT["test"], dur))
            except OSError:
                pass
            if dur > 600 and HEARTBEAT["stuck_said"] != HEARTBEAT["test"]:
                HEARTBEAT["stuck_said"] = HEARTBEAT["test"]
                print("PHASE STUCK %s: %s for %d s" % (name, HEARTBEAT["test"], dur), flush=True)
            time.sleep(30)
    threading.Thread(target=beat, daemon=True).start()


MAX_CRASHES = 3
RELAUNCH_MIN_DROP_GB = 1.5      # relaunch only when available RAM also fell this much since the last load


DEFEAT_RX = [(re.compile(r"\[SOS\] (?:Defeat|Cause of Death|BlackOut)"), "Shadow of Skyrim defeat"),
             (re.compile(r"Enter bleedout event: '(?:Prisoner|Lucienne)'"), "player bleedout"),
             # earliest signals (player_defeat_jail.md): a guard arrest greeting opened the Dialogue Menu at 14:48:41 and it
             # stayed open 71 s under the harness; B-11's player.moveto then closed it, which counted as resisting arrest.
             # The harness never opens a dialogue menu itself, so any open one means the game wants the player.
             (re.compile(r"Menu 'Dialogue Menu' is opening"), "a dialogue menu opened (guard arrest?)"),
             (re.compile(r"Whiterun Guard: You have committed crimes|\(Dialogue\) [^:]*Guard: [^(]*(?:committed crimes|pay with your blood|bounty)"),
              "guard arrest dialogue"),
             # early signal (U1 run 16: 14:49:54, 12 s before the bleedout): a guard in combat with the player
             (re.compile(r"Combat event: '[^']*Guard' combat state changed to 'Combat' with target '(?:Prisoner|Lucienne)'"),
              "guard in combat with the player")]


DEFEATS = [0]

def player_defeated(papyrus_text, skyrimnet_text):
    """Player defeat/bleedout during a test (T0's player is named "Prisoner"). Shadow of Skyrim's own lines are the
    authoritative signal; SkyrimNet's bleedout event is the early one."""
    for rx, what in DEFEAT_RX:
        m = rx.search(papyrus_text) or rx.search(skyrimnet_text)
        if m:
            return "%s: %s" % (what, m.group(0))
    return None


def recover(ctl, name, b, where, summary, why="CRASH"):
    """The game died or can't be trusted (why: CRASH, SAVE FAILED, RELOAD FAILED): note it, relaunch, reload the block
    save, return a fresh control Run (None if that fails)."""
    print("BLOCK %s %s %s: relaunching" % (why, name, where), flush=True)
    summary.append("| %s | %s | | relaunched |" % (why, where))
    if not game.close(None, timeout=30, force=True):
        print("BLOCK ABORT %s: the game would not close" % name, flush=True)
        return None
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
    return run_block(a[0], only, opt("--from"), "--no-launch" not in a, "--keep-open" in a, "--setup-only" in a)


def restore_gamemaster():
    """Reviewer 2026-10-10: GameMaster goes back ON however the block ended (DONE, ABORT, HALT, exception). Needs the game
    closed; a HALT leaves it running, so then say so loudly. A killed runner can't restore: every GM-on block and the soak
    set and assert it ON at their own start."""
    if game.gamemaster() is not False:
        return
    if game.procs():
        print("GAMEMASTER STILL OFF: the game/MO2 is running (HALT?); the next GM-on block or the soak sets it on", flush=True)
        try:    # reviewer: also in the block summary, so a manual session after a HALT sees it
            import glob
            name = sys.argv[1] if len(sys.argv) > 1 else ""
            mds = sorted(glob.glob(OUT + "%s_*.md" % name), key=os.path.getmtime)
            if mds:
                with open(mds[-1], "a", encoding="utf-8") as f:
                    f.write("| GAMEMASTER STILL OFF | game/MO2 left running; set gamemaster.enabled back to true before any manual session | | |\n")
        except Exception:
            pass
        return
    game.set_gamemaster(True, lambda m: print(m, flush=True), wait=0)


if __name__ == "__main__":
    try:
        rc = main(sys.argv[1:])
    except BaseException as e:      # reviewer 2026-10-10: an unattended block always ends with DONE, ABORT or HALT
        print("BLOCK ABORT %s: %s %r" % (sys.argv[1] if len(sys.argv) > 1 else "?", type(e).__name__, e), flush=True)
        raise
    finally:
        try:
            restore_gamemaster()
        except Exception as e:
            print("GAMEMASTER restore failed: %r" % (e,), flush=True)
    sys.exit(1 if rc else 0)
