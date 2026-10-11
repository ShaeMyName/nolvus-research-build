"""DM calls per real hour from SkyrimNet logs (REVIEW_LOG RV-68 (1): the IE §0-§2 install, 2026-10-10 21:25, must not add
LLM calls; compare DM calls/hour before vs after). Counts only: template names and timestamps, never prompt text.

Counts `Papyrus::SendCustomPromptToLLM called: PromptTemplate='intel_*dm*'` lines (IntelEngine's story / NPC / political
DM) and, for context, every custom prompt. Rate = count / session span (first to last log timestamp), per file.
Usage: dm_rate.py <log> [<log> ...]   (rotated names SkyrimNet.<UTC stamp>.log; archived copies in test_runs/*/raw)"""
import re, sys
from datetime import datetime

TS = re.compile(r"^\[(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)\.\d+\]")
CALL = re.compile(r"SendCustomPromptToLLM called: PromptTemplate='([A-Za-z0-9_]+)'")


def rate(path):
    first = last = None
    dm, allc, per = 0, 0, {}
    with open(path, "rb") as f:
        for raw in f:
            line = raw.decode("utf-8", "replace")
            m = TS.match(line)
            if not m:
                continue
            t = datetime.strptime(m.group(1), "%Y-%m-%d %H:%M:%S")
            first = first or t
            last = t
            c = CALL.search(line)
            if c:
                allc += 1
                name = c.group(1)
                if name.startswith("intel_") and "dm" in name:
                    dm += 1
                    per[name] = per.get(name, 0) + 1
    hours = (last - first).total_seconds() / 3600.0 if first and last else 0.0
    return dict(file=path.replace("\\", "/").split("/")[-1], start=str(first), hours=round(hours, 2), dm=dm,
                dm_per_h=round(dm / hours, 2) if hours > 0.05 else None, custom=allc, by_template=per)


if __name__ == "__main__":
    for p in sys.argv[1:]:
        print(rate(p))
