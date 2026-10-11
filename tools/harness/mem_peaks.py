"""Per-game-session memory peaks from test_runs/mem_sampler.log (REVIEW_LOG RV-120-dec: the soak report shows per-load
private-memory peaks, e.g. 23.6 -> 29.7 GB, for Shae's RAM decision). A session runs from "POOL session start" to
"POOL session end". Per session: start/end time, peak game private GB, minimum available GB, peak commit %, nonpaged
pool before/peak/after, and any guard trips inside it. Usage: mem_peaks.py [--since "YYYY-MM-DD HH:MM"] [--csv]"""
import re, sys

LOG = "C:/nolvus-research/test_runs/mem_sampler.log"
ROW = re.compile(r"^(\S+ \S+) avail=([\d.]+)GB commit=[\d.]+/[\d.]+GB\((\d+)%\).*?nonpaged=([\d,]+)MB game=([\d.]+GB|-)")
START = re.compile(r"^(\S+ \S+) POOL session start")
END = re.compile(r"^(\S+ \S+) POOL session end: before (\d+) MB, peak (\d+) MB, after close (\d+) MB")
TRIP = re.compile(r"^(\S+ \S+) (AVAILABLE TRIP|POOLGATE TRIPPED|RUNAWAY|KILL)[^\n]*")


def sessions(since=None):
    out, cur = [], None
    for line in open(LOG, encoding="utf-8", errors="replace"):
        ts = line[:19]
        if since and ts < since:
            continue
        m = START.match(line)
        if m:
            cur = dict(start=m.group(1), end=None, game_peak=0.0, avail_min=99.0, commit_peak=0, trips=[], pool=None)
            continue
        if cur is None:
            continue
        m = ROW.match(line)
        if m:
            cur["avail_min"] = min(cur["avail_min"], float(m.group(2)))
            cur["commit_peak"] = max(cur["commit_peak"], int(m.group(3)))
            if m.group(5) != "-":
                cur["game_peak"] = max(cur["game_peak"], float(m.group(5)[:-2]))
            continue
        m = TRIP.match(line)
        if m:
            cur["trips"].append(m.group(2))
            continue
        m = END.match(line)
        if m:
            cur["end"] = m.group(1)
            cur["pool"] = (int(m.group(2)), int(m.group(3)), int(m.group(4)))
            out.append(cur)
            cur = None
    if cur:
        out.append(cur)
    return out


def main():
    since = sys.argv[sys.argv.index("--since") + 1] if "--since" in sys.argv else None
    rows = sessions(since)
    if "--csv" in sys.argv:
        print("start,end,game_peak_gb,avail_min_gb,commit_peak_pct,pool_before_mb,pool_peak_mb,pool_after_mb,trips")
        for s in rows:
            p = s["pool"] or ("", "", "")
            print("%s,%s,%.1f,%.1f,%d,%s,%s,%s,%s" % (s["start"], s["end"] or "", s["game_peak"], s["avail_min"],
                                                       s["commit_peak"], p[0], p[1], p[2], "|".join(s["trips"])))
        return
    for s in rows:
        p = s["pool"]
        print("%s -> %s  game peak %5.1f GB  avail min %4.1f GB  commit peak %2d%%  pool %s%s" % (
            s["start"], (s["end"] or "running")[11:], s["game_peak"], s["avail_min"], s["commit_peak"],
            "%d/%d/%d MB" % p if p else "-", ("  TRIPS: " + ", ".join(s["trips"])) if s["trips"] else ""))


if __name__ == "__main__":
    main()
