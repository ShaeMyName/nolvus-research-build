"""Q-9 check (TASK_C step 1). Prints counts and pass/fail only: never MARAS.log lines, EditorIDs or quest text.
Reads: Papyrus.0.log [IEB] lines, overwrite qi_probe.json, build/out quest_integrity.json, MARAS.log (pattern only)."""
import json, re

DOC = "C:/Users/sharp/Documents/My Games/Skyrim Special Edition/"
PROBE = "C:/Nolvus/Instances/Nolvus Awakening/MODS/overwrite/SKSE/Plugins/ErrandBridge/qi_probe.json"
QI = "C:/nolvus-research/build/out/ErrandBridge/quest_integrity.json"

# 1. MARAS: last PackageOverrideService "loaded" line -> numbers only
maras = open(DOC + "SKSE/MARAS.log", encoding="utf-8", errors="replace").read()
m = None
for m in re.finditer(r"PackageOverrideService: loaded (\d+) whitelist pattern\(s\), (\d+) allowed plugin\(s\), (\d+) quest whitelist pattern\(s\), quest priority threshold (\w+)", maras):
    pass
if m:
    wl, ap, qw, thr = m.groups()
    print("MARAS: whitelist %s, allowed plugins %s, quest whitelist %s, threshold %s ->" % (wl, ap, qw, thr),
          "PASS" if (qw == "694" and thr == "256") else "FAIL (expected 694 / 256)")
else:
    print("MARAS: no PackageOverrideService loaded line found")

# 2. Papyrus [IEB] lines (our own trace text only)
pap = open(DOC + "Logs/Script/Papyrus.0.log", encoding="utf-8", errors="replace").read().splitlines()
ieb = [l for l in pap if "[IEB] " in l]
print("Papyrus [IEB] lines: %d" % len(ieb))
for l in ieb[-12:]:
    print("  " + l[l.index("[IEB]"):][:200])

# 3. Probe spelling vs builder spelling for the same forms
qi = json.load(open(QI, encoding="utf-8"))
ids, plugs, lists = qi["intList"]["probe_ids"], qi["stringList"]["probe_plugins"], qi["stringList"]["probe_lists"]
try:
    pr = json.load(open(PROBE, encoding="utf-8"))
    written = pr.get("formList", {}).get("probe", [])
except FileNotFoundError:
    written = None
print("probe file:", "missing" if written is None else "%d entries" % len(written))
if written is not None:
    ok = 0
    for i, (fid, pl, lst) in enumerate(zip(ids, plugs, lists)):
        mine = "0x%x|%s" % (fid, pl)
        theirs = written[i] if i < len(written) else None
        same = theirs == mine
        in_list = mine in qi["formList"][lst]
        ok += same
        # show spelling shape only: plugin names are load-order facts, not spoilers
        print("  probe %d (%s): builder %r | PapyrusUtil %r | same: %s | builder entry in list: %s" % (i, lst, mine, theirs, same, in_list))
    print("Q-9 spelling:", "PASS" if ok == len(ids) else "FAIL (%d of %d match)" % (ok, len(ids)))
