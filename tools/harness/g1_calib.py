"""G1 seat-window calibration (REVIEW_LOG RV-66-upd: the 3 s seat window is unmeasured; window = max(3 s, 3 x p95 of the
WFP -> decision gap)). Runs U1's B-6 family (NFF dismiss mid-errand; B-6b/B-6c/B-6d cover keep mode, stale faction and
the guard dismiss) N times through the normal block driver, then reads every '[IEB] ... gap=<ms>ms win=<s>s' line the
bridge logged (IEB_Main G1 decision, :675-699) from the archived Papyrus logs of those runs and reports n, median, p95,
max and the proposed window. Counts and milliseconds only.
Usage: g1_calib.py [N=10] [ids=B-6,B-6b,B-6c,B-6d]   (game and MO2 closed)"""
import glob, os, re, statistics, sys, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import block, blocks_def, game

OUT = "C:/nolvus-research/test_runs/"
GAP = re.compile(r"\[IEB\] [^\n]*?gap=(\d+)ms win=(\d+)s")


def main():
    if game.procs():
        sys.exit("ABORT: game or MO2 running")
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 10
    ids = sys.argv[2].split(",") if len(sys.argv) > 2 else ["B-6", "B-6b", "B-6c", "B-6d"]
    stamp = time.strftime("%Y%m%d-%H%M%S")
    t0 = time.time()
    for i in range(n):
        if os.path.exists(game.POOLGATE_FLAG):
            print("POOLGATE TRIPPED: stopping after %d rounds" % i, flush=True)
            break
        print("G1 CALIB round %d/%d" % (i + 1, n), flush=True)
        block.run_block("U1", only=ids, keep_open=(i < n - 1))
    gaps, wins = [], []
    for p in glob.glob(OUT + "*/raw/*Papyrus.0*.log"):
        if os.path.getmtime(p) < t0:
            continue
        for m in GAP.finditer(open(p, encoding="utf-8", errors="replace").read()):
            gaps.append(int(m.group(1)))
            wins.append(int(m.group(2)))
    rep = ["# G1 calibration %s (%d rounds of %s)" % (stamp, n, ",".join(ids)), ""]
    if len(gaps) < 5:
        rep.append("INCONCLUSIVE: only %d gap samples" % len(gaps))
    else:
        g = sorted(gaps)
        p95 = g[min(len(g) - 1, int(round(0.95 * (len(g) - 1))))]
        rep += ["samples: %d" % len(g), "median: %d ms" % statistics.median(g), "p95: %d ms" % p95, "max: %d ms" % g[-1],
                "windows seen: %s" % sorted(set(wins)),
                "proposed window = max(3 s, 3 x p95) = %.1f s" % max(3.0, 3 * p95 / 1000.0)]
    open(OUT + "G1_calib_%s.md" % stamp, "w", encoding="utf-8").write("\n".join(rep) + "\n")
    print("\n".join(rep))


if __name__ == "__main__":
    main()
