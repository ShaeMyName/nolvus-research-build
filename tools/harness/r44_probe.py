"""REVIEW_LOG R44 (bounty origin): re-run B-5 (x1000 window) with a crime-gold ticker beside it.
T0 carries no bounty (R44 update: CrimeProbe on a fresh T0 = 0/0); run 16's arrest bounty arose inside a x1000 window.
This runs U1's B-5 alone through the normal block driver (launch, T0, harness on) while a second MCP session calls
TestCtl.CrimeProbe every TICK_S real seconds. Afterwards it reports the first CRIMEPROBE line with non-zero gold, and the
Papyrus/SkyrimNet lines in the 20 s before it that mention crime, assault, theft, trespass, arrest or a guard (event
kinds and actor FormIDs only). Counts and FormIDs only; no dialogue text.
Usage: r44_probe.py [test id, default B-5]   (game and MO2 closed)"""
import os, re, sys, threading, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import block, blocks_def, game
from runner import Run

OUT = "C:/nolvus-research/test_runs/"
TICK_S = 10
STOP = threading.Event()
CRIME_RX = re.compile(r"CRIMEPROBE whiterun=(-?\d+) violent=(-?\d+) curFaction=(\S+) curGold=(-?\d+)")
CTX_RX = re.compile(r"(?i)crime|assault|theft|steal|trespass|arrest|bounty|guard")
TS_RX = re.compile(r"^\[(\d\d/\d\d/\d{4} - \d\d:\d\d:\d\d[AP]M)\]")


def ticker():
    ctl = None
    while not STOP.is_set():
        try:
            if "SkyrimSE.exe" in game.procs() and game.mcp_up(3):
                ctl = ctl or Run("R44_TICK")
                ctl.ctl("CrimeProbe", [], sync=False)
        except Exception:
            ctl = None
        STOP.wait(TICK_S)


def main():
    if game.procs():
        sys.exit("ABORT: game or MO2 running")
    tid = sys.argv[1] if len(sys.argv) > 1 else "B-5"
    stamp = time.strftime("%Y%m%d-%H%M%S")
    th = threading.Thread(target=ticker, daemon=True)
    th.start()
    try:
        rc = block.run_block("U1", only=[tid])
    finally:
        STOP.set()
    pap = open(game.LOGS["papyrus"], "rb").read().decode("utf-8", "replace").splitlines()
    first = None
    for i, l in enumerate(pap):
        m = CRIME_RX.search(l)
        if m and (int(m.group(1)) > 0 or int(m.group(2)) > 0 or int(m.group(4)) > 0):
            first = i
            break
    rep = ["# R44 probe %s (%s, rc=%s)" % (stamp, tid, rc), ""]
    n = sum(1 for l in pap if CRIME_RX.search(l))
    rep.append("CRIMEPROBE lines: %d (every %d s)" % (n, TICK_S))
    if first is None:
        rep.append("No crime gold at any tick: no bounty arose in this run.")
    else:
        rep.append("First non-zero: %s" % CRIME_RX.search(pap[first]).group(0))
        ctx = [l for l in pap[max(0, first - 400):first] if CTX_RX.search(l)]
        rep.append("Context lines before it mentioning crime/guard words: %d (kinds only):" % len(ctx))
        kinds = {}
        for l in ctx:
            k = CTX_RX.search(l).group(0).lower()
            kinds[k] = kinds.get(k, 0) + 1
        rep.append("  %s" % kinds)
    open(OUT + "R44_probe_%s.md" % stamp, "w", encoding="utf-8").write("\n".join(rep) + "\n")
    print("\n".join(rep))


if __name__ == "__main__":
    main()
