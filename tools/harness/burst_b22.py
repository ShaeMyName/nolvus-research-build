"""B-22 (spec §15.3, §2.1): read the last watcher burst (IEB_TestCtl.Burst) from the ErrandBridgeWatch user log and
check every NFF wait-box interval: it lasts < 0.5 s, and the actor does not head back toward the take position (the
first sample) during it or in the second after it. Reads only.
Usage: burst_b22.py [log path]   Prints ASSERT PASS|FAIL lines; exit code 1 on any FAIL or on no burst found."""
import math, os, re, sys

LOG = os.path.expanduser("~/Documents/My Games/Skyrim Special Edition/Logs/Script/User/ErrandBridgeWatch.0.log")
BACK_TOLERANCE = 64.0      # game units closer to the take position that count as "heading back"
MAX_WAIT = 0.5             # seconds

START = re.compile(r"BURST START (.+?) (\S+) t=(\S+) waitbox=(\S+) waitboxpt=(\S+)")
SAMPLE = re.compile(r"BURST (\d+\.?\d*) (\S+) wfp=(\S+) pos=(\S+),(\S+),(\S+)")


def last_burst(lines):
    s = max((i for i, l in enumerate(lines) if "BURST START" in l), default=None)
    if s is None:
        return None, []
    m = START.search(lines[s])
    out = []
    for l in lines[s + 1:]:
        if "BURST END" in l or "BURST START" in l:
            break
        x = SAMPLE.search(l)
        if x:
            out.append((float(x.group(1)), x.group(2), float(x.group(3)),
                        (float(x.group(4)), float(x.group(5)), float(x.group(6)))))
    return m, out


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else LOG
    lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
    head, smp = last_burst(lines)
    if head is None or not smp:
        print("ASSERT FAIL B-22 no burst found in %s" % path)
        return 1
    who, waits = head.group(1), {head.group(4).upper(), head.group(5).upper()} - {"NONE"}
    gaps = [b[0] - a[0] for a, b in zip(smp, smp[1:])]
    print("burst %s: %d samples over %.1f s, median step %.2f s, wait-box packages %s"
          % (who, len(smp), smp[-1][0] - smp[0][0], sorted(gaps)[len(gaps) // 2] if gaps else 0, sorted(waits)))
    take = smp[0][3]
    dist = lambda p: math.dist(p[:2], take[:2])
    fails, intervals, i = 0, 0, 0
    while i < len(smp):
        if smp[i][1].upper() not in waits:
            i += 1
            continue
        j = i
        while j + 1 < len(smp) and smp[j + 1][1].upper() in waits:
            j += 1
        intervals += 1
        end_t = smp[j + 1][0] if j + 1 < len(smp) else smp[j][0]
        dur = end_t - smp[i][0]
        ok_dur = dur < MAX_WAIT
        d0 = dist(smp[i][3])
        window = [s for s in smp[i:] if s[0] <= end_t + 1.0]
        closest = min(dist(s[3]) for s in window)
        ok_back = d0 - closest <= BACK_TOLERANCE
        for ok, why in ((ok_dur, "lasted %.2f s (limit %.1f)" % (dur, MAX_WAIT)),
                        (ok_back, "moved %.0f units back toward the take position" % (d0 - closest))):
            print("ASSERT %s B-22 %s wait-box interval at t=%.2f: %s" % ("PASS" if ok else "FAIL", who, smp[i][0], why))
            fails += not ok
        i = j + 1
    print("SUMMARY intervals=%d fails=%d%s" % (intervals, fails,
          "" if intervals else " (no wait-box interval sampled: PASS if the burst covered the IE transitions)"))
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
