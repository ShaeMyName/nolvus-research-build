"""DM calls per real hour from SkyrimNet logs (REVIEW_LOG RV-68 (1): the IE §0-§2 install, 2026-10-10 21:25, must not add
LLM calls; compare DM calls/hour before vs after). Counts only: template names and timestamps, never prompt text.

Counts `Papyrus::SendCustomPromptToLLM called: PromptTemplate='intel_*dm*'` lines (IntelEngine's story / NPC / political
DM) and, for context, every custom prompt. Rate = count / session span (first to last log timestamp), per file.
Usage: dm_rate.py <log>[=<game hours>] ...   (rotated names SkyrimNet.<UTC stamp>.log; archived copies in test_runs/*/raw)
RV-88 (2): both rates are reported: per real hour (the cost to Shae) and per game hour (DM dispatch is game-time gated);
the game hours of a session come from its CRASHCTX lines (hour/days) and are passed after "=".
Threshold: a real-hour rate above ~1.5x the pre-install rate goes to Shae as an API-cost item.
REVIEW_LOG RV-108 (1): 'dm' counts LOGICAL requests (one SendCustomPromptToLLM line each); OpenRouter retries, timeouts
and empty replies on the DM variants are counted separately (attributed by thread to the latest variant line), since they
may inflate the observed rate and may still be billed."""
import re, sys
from datetime import datetime

TS = re.compile(r"^\[(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)\.\d+\] \[(\d+)\]")
VAR = re.compile(r"Using variant '([^']+)' for text generation|Processing template with variant '([^']+)'")
ORE = re.compile(r"\[(warning|error)\] \[OpenRouterInterface\.cpp")
CALL = re.compile(r"SendCustomPromptToLLM called: PromptTemplate='([A-Za-z0-9_]+)'")


def rate(path, game_h=None):
    first = last = None
    dm, allc, per = 0, 0, {}
    lastv, extra = {}, {}
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
            v = VAR.search(line)
            if v:
                lastv[m.group(2)] = v.group(1) or v.group(2)
            e = ORE.search(line)
            if e:
                var = lastv.get(m.group(2), "?")
                if var.startswith("intel_") and "dm" in var:
                    low = line.lower()
                    cls = "timeout" if ("timeout" in low or "timed out" in low) else "retry" if "retry" in low else \
                        "empty" if "empty" in low else "other"
                    extra[cls] = extra.get(cls, 0) + 1
            if c:
                allc += 1
                name = c.group(1)
                if name.startswith("intel_") and "dm" in name:
                    dm += 1
                    per[name] = per.get(name, 0) + 1
    hours = (last - first).total_seconds() / 3600.0 if first and last else 0.0
    return dict(file=path.replace("\\", "/").split("/")[-1], start=str(first), hours=round(hours, 2), dm=dm,
                dm_per_h=round(dm / hours, 2) if hours > 0.05 else None,
                dm_per_game_h=round(dm / game_h, 2) if game_h else None, custom=allc, by_template=per,
                dm_openrouter_extra=extra)


if __name__ == "__main__":
    for a in sys.argv[1:]:
        p, _, g = a.partition("=")
        print(rate(p, float(g) if g else None))
