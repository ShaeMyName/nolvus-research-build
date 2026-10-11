"""Meta variant Flash vs Pro: PASSIVE, UNMATCHED comparison (REVIEW_LOG RV-63, RV-107). The active replay is not possible
without reading the request log raw (RV-105: count-only), so this compares failure, fallback and outcome RATES of the
meta-driven speaker selection from SkyrimNet.log only, per stratum, before vs after the switch. Quality is judged in the
S-C feel check (DECISIONS:418), not here.

Switch time: the run record OpenRouter.yaml.pre_meta_flash_20261010-183933 (meta_flash.py's backup) = 2026-10-10 18:39:33.
Strata: the archive folder's run family (U1 / RV72_live / CRASH_repro / PRV_check / R29 / RV70_probe / other); GameMaster
and harness mode per family come from the block definitions where known (U1: GM off, harness on), else "unknown".
Never one pooled rate. Counts and per-hour rates only; no log text is printed.
Usage: flash_vs_pro.py   (reads test_runs/*/raw/*SkyrimNet*.log and test_runs/R29_logs/*.log)"""
import glob, os, re, sys
from datetime import datetime

SWITCH = datetime(2026, 10, 10, 18, 39, 33)
TS = re.compile(r"^\[(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)\.\d+\]")
PAT = {
    "llm_selected": r"LLM selected speaker \S",
    "llm_no_selection": r"LLM returned no speaker selection",
    "single_speaker": r"Single eligible speaker",
    "no_eligible": r"No eligible speakers for event",
    "null_speaker": r"Target selection returned valid type \(.*\) but null speaker",
    "player_target_llm": r"Attempting target selection using LLM",
    "variant_fallback": r"Specified variant '[^']*' not found, falling back",
    "stuck_flag": r"Response generation flag stuck for >60s",
    "openrouter_warn": r"\[warning\] \[OpenRouterInterface\.cpp",
    "openrouter_error": r"\[error\] \[OpenRouterInterface\.cpp",
}
RX = {k: re.compile(v) for k, v in PAT.items()}
STRATUM_INFO = {"U1": "GM off, harness on", "RV72_live": "GM on, harness on", "CRASH_repro": "GM on, harness on",
                "PRV_check": "GM on, harness on", "R29": "mixed (cells with harness on/off)", "RV70_probe": "GM on, harness on"}


def stratum(path):
    p = path.replace("\\", "/")
    for k in ("U1", "RV72_live", "CRASH_repro", "PRV_check", "RV70_probe", "R29"):
        if "/" + k in p:
            return k
    return "other"


def scan(path):
    first = last = None
    c = {k: 0 for k in PAT}
    with open(path, "rb") as f:
        for raw in f:
            line = raw.decode("utf-8", "replace")
            m = TS.match(line)
            if m:
                t = datetime.strptime(m.group(1), "%Y-%m-%d %H:%M:%S")
                first = first or t
                last = t
            for k, rx in RX.items():
                if rx.search(line):
                    c[k] += 1
    return first, last, c


def main():
    files = sorted(set(glob.glob("C:/nolvus-research/test_runs/*/raw/*SkyrimNet*.log") +
                       glob.glob("C:/nolvus-research/test_runs/R29_logs/*.log")))
    agg = {}
    for p in files:
        first, last, c = scan(p)
        if not first:
            continue
        era = "pro" if first < SWITCH else "flash"
        key = (stratum(p), era)
        a = agg.setdefault(key, {"files": 0, "hours": 0.0, **{k: 0 for k in PAT}})
        a["files"] += 1
        a["hours"] += max(0.0, (last - first).total_seconds() / 3600.0)
        for k, v in c.items():
            a[k] += v
    print("# Flash vs Pro meta: passive, unmatched (switch %s; per stratum, never pooled)" % SWITCH)
    for (s, era), a in sorted(agg.items()):
        h = a["hours"] or 1e-9
        rates = " ".join("%s=%d(%.1f/h)" % (k, a[k], a[k] / h) for k in PAT if a[k])
        print("%-12s %-5s files=%d hours=%.2f [%s] %s" % (s, era, a["files"], a["hours"], STRATUM_INFO.get(s, "unknown"), rates))
        sel = a["llm_selected"] + a["llm_no_selection"]
        if sel:
            print("%-12s %-5s   selector: LLM picks %d, no-selection %d (%.0f%% no-selection)" %
                  (s, era, a["llm_selected"], a["llm_no_selection"], 100.0 * a["llm_no_selection"] / sel))


if __name__ == "__main__":
    main()
