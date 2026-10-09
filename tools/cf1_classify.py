"""CF-1 offline, part 2: classify each TIF fragment from build/out/cf1/topics.json the way SkyrimNet's
PexFragmentAnalyzer does (it scans fragment pex for call names; SNDLL:L38781-38800). The follower-category call names
are SNDLL's list up to 'setdoingfavor' (INFERRED grouping; the category label is SNDLL:L42654).
Source lookup: loose pex in the active mods (MO2 priority), else decompiled psc from round 9, else vanilla psc.
Writes build/out/cf1/classified.json; prints counts only."""
import json, os, re

INST = "C:/Nolvus/Instances/Nolvus Awakening/MODS/"
PROFILE = INST + "profiles/SkyrimNet Test/modlist.txt"
R9 = "C:/nolvus-research/investigation/round9/custom_followers/psc/"
VAN = "C:/nolvus-research/sdk/vanilla_psc/"
OUT = "C:/nolvus-research/build/out/cf1/"
FOLLOWER = ["setfollower", "followerwait", "followerfollow", "dismissfollower", "setanimal", "animalwait",
            "animalfollow", "dismissanimal", "followplayer", "setplayerteammate", "rehire", "payhireling",
            "promotetofriendescort", "setdoingfavor"]

pex = {}
mods = [l.strip()[1:] for l in open(PROFILE, encoding="utf-8-sig") if l.startswith("+")]
for m in mods:                                   # top of modlist = highest priority: first hit wins
    d = INST + "mods/" + m + "/Scripts/"
    if not os.path.isdir(d):
        d = INST + "mods/" + m + "/scripts/"
        if not os.path.isdir(d):
            continue
    for f in os.listdir(d):
        if f.lower().endswith(".pex"):
            pex.setdefault(f[:-4].lower(), d + f)
psc = {}
for root, _, files in os.walk(R9):
    for f in files:
        if f.lower().endswith(".psc"):
            psc.setdefault(f[:-4].lower(), os.path.join(root, f))
for f in os.listdir(VAN):
    if f.lower().endswith(".psc"):
        psc.setdefault(f[:-4].lower(), VAN + f)


def calls(name):
    k = name.lower()
    if k in pex:
        b = open(pex[k], "rb").read().lower()
        return "pex", [n for n in FOLLOWER if n.encode() in b]
    if k in psc:
        t = open(psc[k], encoding="utf-8", errors="replace").read().lower()
        return "psc", [n for n in FOLLOWER if re.search(r"\b" + n + r"\s*\(", t)]
    return None, []


rows = json.load(open(OUT + "topics.json", encoding="utf-8"))
res, miss = [], 0
for r in rows:
    for i in r["infos"]:
        if not i["tif"]:
            continue
        src, hit = calls(i["tif"])
        miss += src is None
        res.append({"npc": r["npc"], "role": r["role"], "dial": r["dial"], "quest": r["quest"], "info": i["info"],
                    "plugin": i["plugin"], "tif": i["tif"], "src": src, "follower_calls": hit,
                    "category_covers": bool(hit)})
json.dump(res, open(OUT + "classified.json", "w", encoding="utf-8"), indent=1)
print("TIF infos %d; source found %d (pex %d, psc %d), missing %d; category covers %d, misses %d" % (
    len(res), len(res) - miss, sum(x["src"] == "pex" for x in res), sum(x["src"] == "psc" for x in res), miss,
    sum(x["category_covers"] for x in res), sum(not x["category_covers"] for x in res)))
by = {}
for x in res:
    k = (x["npc"], x["role"])
    c = by.setdefault(k, [0, 0, 0])
    c[0] += 1; c[1] += x["category_covers"]; c[2] += x["src"] is None
for k, c in by.items():
    print("%-8s %-12s TIFs %3d  covered %3d  no-source %d" % (k[0], k[1], c[0], c[1], c[2]))
