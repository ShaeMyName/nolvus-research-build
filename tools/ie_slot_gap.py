"""Measure IntelEngine Find->Allocate gaps per caller from Papyrus logs (slot-race expiry, post_u1_build_plan §2).
Papyrus timestamps have 1 s resolution, so every gap is +-1 s. Markers (the last log line the caller writes before or
right after FindFreeAgentSlot, same actor where the line names it):
  travel        Travel.GoToLocation    'Resolving: ' (ResolveDestination, first call after Find) -> 'Allocated slot'
  npc_social    StoryEngine:956        'NPC DM [' (before the visibility branch -> DispatchNPCSocial -> Find)
  story         StoryEngine:1712       'Story DM [' (DM path), and '[IntelEngine] StoryEngine: DM response' (LLM reply)
  fetch_npc / deliver_message / search_for_actor / escort_target / assassination: counted if present.
Counts and gaps only; no log text printed. Usage: ie_slot_gap.py <Papyrus.N.log> ..."""
import re, sys, datetime, collections

TS = re.compile(r"^\[(\d+/\d+/\d+) - (\d+:\d+:\d+)(AM|PM)\]\s?(.*)")
AL = re.compile(r"IntelEngine: Allocated slot (\d) to (.+) for (\S+)")
MARK = {"travel": ["IntelEngine: Resolving: "], "npc_social": ["IntelEngine: NPC DM ["],
        "story": ["IntelEngine: Story DM [", "[IntelEngine] StoryEngine: DM response"]}


def t(m):
    return datetime.datetime.strptime("%s %s%s" % m.groups()[:3], "%m/%d/%Y %I:%M:%S%p")


gaps = collections.defaultdict(list)
for f in sys.argv[1:]:
    rows = []
    for ln in open(f, encoding="utf-8", errors="replace"):
        m = TS.match(ln.rstrip("\n"))
        if m:
            rows.append((t(m), m.group(4)))
    for i, (ti, msg) in enumerate(rows):
        a = AL.search(msg)
        if not a:
            continue
        kind = a.group(3).lower()
        for mk in MARK.get(kind, []):
            k = i - 1
            while k >= 0 and (ti - rows[k][0]).total_seconds() <= 600:
                if rows[k][1].startswith(mk):
                    gaps[(kind, mk)].append((ti - rows[k][0]).total_seconds())
                    break
                k -= 1
        if kind not in MARK:
            gaps[(kind, "(no marker)")].append(None)
for (kind, mk), g in sorted(gaps.items()):
    vals = [x for x in g if x is not None]
    print("%-18s %-45s n=%-3d max=%s s  all=%s" % (kind, mk.strip(), len(g), max(vals) if vals else "-",
                                                   sorted(vals)))
