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

TESTS = {}      # id -> dict(fn, family, save, reload, forced)


def test(tid, family, save="T0", reload=False, forced=False):
    def deco(fn):
        TESTS[tid] = dict(fn=fn, family=family, save=save, reload=reload, forced=forced)
        return fn
    return deco


BLOCKS = {}     # name -> dict(save, order: [ids], modules: [module names], est: {family: minutes})


def block(name, save, modules, order, est=None, fixed=None):
    """est: unpadded estimate in minutes per family (time plan), spread evenly over that family's tests;
    fixed: {test id: minutes} for known long tests (B-20). Used only for the live ETA."""
    BLOCKS[name] = dict(save=save, modules=modules, order=order, est=est or {}, fixed=fixed or {})


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
    """One PROGRESS line per test (the session watches these for live ETA pushes, Shae 2026-10-10)."""
    ratio = done_real / done_est if done_est else 1.0
    eta = remaining_est * ratio
    print("PROGRESS %d/%d %s %s %ds | elapsed %.0f min | pace x%.2f of estimate | ETA %.0f min (done ~%s)"
          % (i, n, tid, verdict, secs, (time.time() - started) / 60, ratio, eta / 60,
             time.strftime("%H:%M", time.localtime(time.time() + eta))), flush=True)


def settle_probe(r):
    """SeverActions-ready probe on T0: Carlotta (adult, market by day) eligible for SitOrLayDown."""
    return ("SitOrLayDown", lambda: r.uuid(0x1A675)[0])


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
    ctl = Run("%s_CONTROL" % name)
    if "SkyrimSE.exe" not in game.procs():
        if not launch or not game.launch(ctl.log):
            ctl.log("ABORT: game not running")
            print("BLOCK ABORT %s: game did not launch" % name, flush=True)
            ctl.save()
            return 1
        ctl = Run("%s_CONTROL" % name)          # fresh MCP session after launch
    if not game.load(ctl, b["save"], settle_probe(ctl)):
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
    started, done_est, done_real = time.time(), 0.0, 0.0
    for i, tid in enumerate(order, 1):
        meta = TESTS[tid]
        if fam and meta["family"] != fam:
            family_logs(ctl, fam, fam_start, summary)
            fam_start = time.strftime("%Y-%m-%d %H:%M:%S")
        fam = meta["family"]
        r = Run(tid)
        r.forced = meta["forced"]
        r.tails = {k: game.Tail(p) for k, p in game.LOGS.items()}
        t0 = time.time()
        try:
            meta["fn"](r)
        except Exception as e:          # a harness bug fails the test, not the block
            r.inconclusive += 1
            r.log("INCONCLUSIVE %s harness error: %r" % (tid, e))
        if r.forced:
            r.log("NOTE %s: forced state (weaker evidence than natural play)" % tid)
        inv = [l for l in r.tails["watch"].read().splitlines() if re.search(r"ASSERT FAIL I\d", l)]
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
        if meta["reload"]:
            game.load(ctl, b["save"], settle_probe(ctl))
    if fam:
        family_logs(ctl, fam, fam_start, summary)
    if not keep_open:
        game.close(ctl)
    p = OUT + "%s_%s.md" % (name, stamp)
    open(p, "w", encoding="utf-8").write("\n".join(summary) + "\n")
    ctl.log("summary %s" % p)
    print("BLOCK DONE %s %d/%d not ALL PASS; %.0f min" % (name, sum(1 for _, v in results if v != "ALL PASS"),
                                                         len(results), (time.time() - started) / 60), flush=True)
    ctl.save()
    return sum(1 for _, v in results if v != "ALL PASS")


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
    sys.exit(1 if main(sys.argv[1:]) else 0)
