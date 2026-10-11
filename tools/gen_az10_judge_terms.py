"""Private judge data for the Azura family (U4; tests_azura.py). Offline, read-only on gamedata/ copies.

Outputs (both under build/private_out/, which build/.gitignore keeps out of git; this script PRINTS COUNTS ONLY and
holds no story literal: every name comes from plugin data, every quest from its record type or from the layer file):
  private_out/az10_judge_terms.json  AZ-10 judge: names of future story content. A probe reply FAILs on any whole-word,
                                     case-insensitive hit.
      tiers.core   quest / NPC / place names of quests typed Main (1), DLC01 (10) and DLC02 (11): the spec §11.15.8
                   scope ("no named future events, people or places from the main quest, Dawnguard or Dragonborn");
      tiers.wider  the same from every other quest type quest_integrity_builder.py classes as story (STORY_TYPES).
      Only quests whose record originates in a base master (every .esm in gamedata/, i.e. the base game and its DLC).
  private_out/az11_targets.json      AZ-11: for each quest named in the Lucienne layer's Dialogue Actions blacklist
                                     (dialogue_actions/luc_blacklists.yaml of the TEST layer), the quest form, every
                                     INFO of its topics, and the quest's most frequent speaker (CTDA GetIsID count over
                                     those INFOs) with one placed reference of it. Plugin + local ID only; no names.

Names: plugins of the base game are localized (FULL = a string ID; no .STRINGS files in gamedata/), so a name comes
from the winning NON-localized override in the load order (gamedata/active/_loadorder.txt), else from the EditorID
(CamelCase split, code prefixes like 'MQ101'/'DLC1' and record suffixes like 'Location' dropped). Dropped as noise:
terms under 4 characters, with digits, all-generic words (role nouns such as guard, soldier; GENERIC below), one-word
terms that occur in lower case in English prompt prose (repos/**/*.prompt: a common word, not a name), places
with a city/town/hold/settlement keyword (geography the player already knows), and the speaker's own identity names
(the physical NPC of the Dusk identity link, read from the layer's identity/dusk_link.yaml, and the Dusk name itself).
Usage: gen_az10_judge_terms.py   (no arguments; ~2 min over the load order)"""
import glob, json, os, re, struct, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from quest_integrity_builder import walk, body_of, subrecs, header, plugin_path, STORY_TYPES, G, ACTIVE

OUT_DIR = "C:/nolvus-research/build/private_out/"
LAYER = ("C:/nolvus-research/build/layers/lucienne-test/SKSE/Plugins/SkyrimNet/external/shae.lucienne/")
CORE_TYPES = {1, 10, 11}
GETISID = 72
LOC_GEO_KW = {"loctypecity", "loctypetown", "loctypehold", "loctypesettlement"}
# Role / creature / common nouns: a term made only of these words is not a name. Generic English, no story content.
GENERIC = set("""
the of and a an at in on to for with from by my your her his their our its
guard guards soldier soldiers bandit bandits courier farmer hunter thief thieves prisoner prisoners jarl steward
housecarl captain commander general legate lieutenant officer sergeant spirit ghost ghosts skeleton draugr boy girl
man men woman women child children merchant innkeeper stranger assassin necromancer witch giant bear spider horse
dog cat wolf wolves dragon dragons vampire vampires werewolf priest priestess monk scholar mage wizard worker miner
servant cook guest citizen beggar elder lord lady king queen prince princess emperor chief leader master apprentice
student teacher father mother brother sister son daughter husband wife friend enemy traveler traveller pilgrim
dead corpse body unknown old young new great high low black white red blue dark light shadow fire ice frost storm
dawn dusk night day moon moons star stars sun sky world land north south east west road path way home house hall
temple shrine tower cave mine camp fort keep ruins ruin tomb barrow castle city town village farm inn tavern
voice voices god gods daedra daedric prince statue altar book books note letter journal key ring amulet sword
""".split())
SUFFIXES = re.compile(r"(?:Location|Loc|Exterior|Interior|Ref|REF|Actor|NPC|Base|Dummy|Template|Unique|Boss|Dead|"
                      r"Corpse|Ghost|Copy|Alias|Marker|Quest|Scene|Player|Clone|Dupe|Old|New|Temp|Test)+$")
CODE_PREFIX = re.compile(r"^(?:DLC\d+|[A-Z]{1,5}\d+[A-Za-z]?\d*)")


CORPUS = "C:/nolvus-research/repos/**/*.prompt"     # English instruction prose (SkyrimNet & mod prompt templates)


def common_words():
    """Words that occur in lower case in English prompt prose: a one-word term equal to one is a common word, not a
    name (case-insensitive matching would fire on ordinary speech)."""
    out = set()
    for p in glob.glob(CORPUS, recursive=True):
        try:
            out |= set(re.findall(r"\b[a-z]{3,}\b", open(p, encoding="utf-8", errors="replace").read()))
        except OSError:
            pass
    return out


def say(*a):
    print(*a, flush=True)


def edid_name(e):
    """A display-name guess from an EditorID; '' when nothing name-like is left."""
    e = CODE_PREFIX.sub("", e or "")
    e = re.sub(r"\d+", "", e)
    e = SUFFIXES.sub("", e)
    words = re.findall(r"[A-Z][a-z']+", e)
    if not words or "".join(words) != re.sub(r"[^A-Za-z']", "", e):
        return ""           # lower-case runs, acronyms, underscores: not a clean name
    return " ".join(words)


def strip_titles(name):
    """'<Title> Name the Epithet' -> 'Name the Epithet' and 'Name'; generic leading titles only."""
    w = name.split()
    while len(w) > 1 and w[0].lower() in GENERIC:
        w = w[1:]
    out = {" ".join(w)}
    if "the" in [x.lower() for x in w[1:]]:
        i = [x.lower() for x in w].index("the", 1)
        out.add(" ".join(w[:i]))
    return out


def keep(term):
    t = term.strip().strip("'")
    if len(t) < 4 or re.search(r"\d", t) or not re.match(r"[A-Z]", t):
        return False
    words = [re.sub(r"'s$", "", x).lower() for x in re.findall(r"[A-Za-z']+", t)]
    return bool(words) and not all(x in GENERIC or len(x) < 3 for x in words)


def fulltext(v):
    return v.rstrip(b"\0").decode("utf-8", "replace").strip()


def main():
    t0 = time.time()
    order = [l.strip() for l in open(ACTIVE + "_loadorder.txt", encoding="utf-8") if l.strip()]
    masters_root = {n.lower() for n in os.listdir(G) if n.lower().endswith(".esm")}
    origins = {n.lower() for n in order if n.lower() in masters_root}
    case = {n.lower(): n for n in order}
    blk = open(LAYER + "dialogue_actions/luc_blacklists.yaml", encoding="utf-8").read()
    black = re.findall(r"^\s*-\s*(\S+)\s*$", blk.split("blacklist:", 1)[1], re.M)
    link = re.search(r'identityB:\s*"npc:([^:]+):0x([0-9A-Fa-f]+)"', open(LAYER + "identity/dusk_link.yaml",
                                                                         encoding="utf-8").read())
    self_key = (link.group(1).lower(), int(link.group(2), 16) & 0xFFFFFF) if link else None
    ve = re.search(r"(?m)^\s*(?:entityName|displayName|name):\s*\"?([^\"\n]+)", open(
        LAYER + "entities/dusk.entity.yaml", encoding="utf-8").read())
    ve_name = ve.group(1).strip() if ve else ""

    quests, q_full = {}, {}                 # key -> parsed; key -> FULL (non-localized override)
    npc_full, npc_edid = {}, {}
    loc_full, loc_edid, loc_kw = {}, {}, {}
    kw_edid = {}
    black_keys = {}                         # quest key -> blacklist EditorID (kept in memory only)
    light = set()
    nplug = 0
    for name in order:
        p = plugin_path(name)
        if not os.path.exists(p):
            continue
        buf = open(p, "rb").read()
        nplug += 1
        start, masters, hflags = header(buf)
        localized = bool(hflags & 0x80)
        if hflags & 0x200 or name.lower().endswith(".esl"):
            light.add(name.lower())
        mlist = [m.lower() for m in masters]

        def resolve(fid, _m=mlist, _self=name.lower()):
            i = fid >> 24
            return (_m[i] if i < len(_m) else _self, fid & 0xFFFFFF)

        for typ, flags, fid, off, size in walk(buf, start, len(buf), {b"QUST", b"NPC_", b"LCTN", b"KYWD"}):
            key = resolve(fid)
            if typ == b"KYWD" and key[0] in origins:
                for t, v in subrecs(body_of(buf, off, size, flags)):
                    if t == b"EDID":
                        kw_edid[key] = fulltext(v).lower()
                continue
            if typ == b"QUST":
                body = body_of(buf, off, size, flags)
                q = {"edid": "", "type": None, "npcs": set(), "refs": set(), "locs": set()}
                kind, full = None, None
                for t, v in subrecs(body):
                    if t == b"EDID":
                        q["edid"] = fulltext(v)
                    elif t == b"FULL" and kind is None and not localized:
                        full = fulltext(v)
                    elif t == b"DNAM" and len(v) > 8:
                        q["type"] = v[8]
                    elif t == b"ALST":
                        kind = "ref"
                    elif t == b"ALLS":
                        kind = "loc"
                    elif t == b"ALED":
                        kind = None
                    elif kind == "ref" and t == b"ALUA":
                        q["npcs"].add(resolve(struct.unpack("<I", v)[0]))
                    elif kind == "ref" and t == b"ALFR":
                        q["refs"].add(resolve(struct.unpack("<I", v)[0]))
                    elif kind == "ref" and t == b"CTDA" and len(v) >= 16 and struct.unpack_from("<H", v, 8)[0] == GETISID:
                        q["npcs"].add(resolve(struct.unpack_from("<I", v, 12)[0]))
                    elif kind == "loc" and t == b"ALFL":
                        q["locs"].add(resolve(struct.unpack("<I", v)[0]))
                if q["edid"] in black:
                    black_keys[key] = q["edid"]
                if key[0] in origins:
                    quests[key] = q
                    if full:
                        q_full[key] = full
                continue
            if key[0] not in origins:
                continue
            body = body_of(buf, off, size, flags)
            edid, full, kws = "", None, set()
            for t, v in subrecs(body):
                if t == b"EDID":
                    edid = fulltext(v)
                elif t == b"FULL" and not localized:
                    full = fulltext(v)
                elif t == b"KWDA":
                    kws = {resolve(x) for x in struct.unpack("<%dI" % (len(v) // 4), v)}
            if typ == b"NPC_":
                npc_edid[key] = edid or npc_edid.get(key, "")
                if full:
                    npc_full[key] = full
            else:
                loc_edid[key] = edid or loc_edid.get(key, "")
                if full:
                    loc_full[key] = full
                if kws:
                    loc_kw[key] = kws

    story = {k: q for k, q in quests.items() if q["type"] in STORY_TYPES}
    # forced refs -> base NPC (ACHR in the origin masters' cell groups)
    refs = {r for q in story.values() for r in q["refs"]}
    achr = {}
    for name in [n for n in order if n.lower() in origins]:
        buf = open(plugin_path(name), "rb").read()
        start, masters, _ = header(buf)
        mlist = [m.lower() for m in masters]
        for typ, flags, fid, off, size in walk(buf, start, len(buf), {b"CELL", b"WRLD"}):
            if typ != b"ACHR":
                continue
            i = fid >> 24
            key = (mlist[i] if i < len(mlist) else name.lower(), fid & 0xFFFFFF)
            if key in refs:
                for t, v in subrecs(body_of(buf, off, size, flags)):
                    if t == b"NAME":
                        b = struct.unpack("<I", v)[0]
                        bi = b >> 24
                        achr[key] = (mlist[bi] if bi < len(mlist) else name.lower(), b & 0xFFFFFF)
                        break

    self_names = set()
    if self_key:
        for n in (npc_full.get(self_key, ""), edid_name(npc_edid.get(self_key, ""))):
            self_names |= {x.lower() for x in strip_titles(n)} if n else set()
    if ve_name:
        self_names.add(ve_name.lower())

    stats = {"plugins_read": nplug, "origin_masters": len(origins), "story_quests": len(story)}
    tiers = {"core": set(), "wider": set()}
    src = {"quest_full": 0, "npc_full": 0, "npc_edid": 0, "loc_full": 0, "loc_edid": 0}
    dropped = {"generic": 0, "geography": 0, "self": 0, "common_word": 0}
    common = common_words()
    for k, q in story.items():
        tier = "core" if q["type"] in CORE_TYPES else "wider"
        cands = []
        if k in q_full:
            cands.append(("quest_full", q_full[k]))
        npcs = set(q["npcs"]) | {achr[r] for r in q["refs"] if r in achr}
        for n in npcs:
            if n in npc_full:
                cands += [("npc_full", x) for x in strip_titles(npc_full[n])]
            elif npc_edid.get(n):
                e = edid_name(npc_edid[n])
                if e:
                    cands += [("npc_edid", x) for x in strip_titles(e)]
        for l in q["locs"]:
            kw = {kw_edid.get(x, "") for x in loc_kw.get(l, set())}
            nm = loc_full.get(l) or edid_name(loc_edid.get(l, ""))
            if not nm:
                continue
            if kw & LOC_GEO_KW:
                dropped["geography"] += 1
                continue
            cands.append(("loc_full" if l in loc_full else "loc_edid", nm))
        for s, c in cands:
            c = c.strip()
            if c.lower() in self_names:
                dropped["self"] += 1
            elif not keep(c):
                dropped["generic"] += 1
            elif " " not in c and re.sub(r"'s$", "", c.lower()) in common:
                dropped["common_word"] += 1
            else:
                tiers[tier].add(c)
                src[s] += 1
    tiers["wider"] -= tiers["core"]
    out = {"version": 1, "generated": time.strftime("%Y-%m-%d %H:%M:%S"),
           "match": "whole word, case-insensitive", "tiers": {k: sorted(v, key=str.lower) for k, v in tiers.items()}}
    os.makedirs(OUT_DIR, exist_ok=True)
    with open(OUT_DIR + "az10_judge_terms.json", "w", encoding="utf-8", newline="\n") as fh:
        json.dump(out, fh, indent=1, ensure_ascii=False)

    # ---------------------------------------------------------------- AZ-11 targets (blacklisted quests)
    bkeys = set(black_keys)
    infos, speakers = {k: set() for k in bkeys}, {k: {} for k in bkeys}
    borig = {k[0] for k in bkeys}
    for name in order:
        p = plugin_path(name)
        if not os.path.exists(p):
            continue
        buf = open(p, "rb").read()
        start, masters, _ = header(buf)
        mlist = [m.lower() for m in masters]
        if not (borig & (set(mlist) | {name.lower()})):
            continue                        # a plugin can only reference its masters' forms

        def resolve(fid, _m=mlist, _self=name.lower()):
            i = fid >> 24
            return (_m[i] if i < len(_m) else _self, fid & 0xFFFFFF)

        cur = None
        for typ, flags, fid, off, size in walk(buf, start, len(buf), {b"DIAL"}):
            if typ == b"DIAL":
                cur = None
                for t, v in subrecs(body_of(buf, off, size, flags)):
                    if t == b"QNAM":
                        qk = resolve(struct.unpack("<I", v)[0])
                        cur = qk if qk in bkeys else None
            elif typ == b"INFO" and cur is not None:
                infos[cur].add(resolve(fid))
                for t, v in subrecs(body_of(buf, off, size, flags)):
                    if t == b"CTDA" and len(v) >= 16 and struct.unpack_from("<H", v, 8)[0] == GETISID:
                        n = resolve(struct.unpack_from("<I", v, 12)[0])
                        if n != ("skyrim.esm", 0x7):
                            speakers[cur][n] = speakers[cur].get(n, 0) + 1
    tops = {k: max(s.items(), key=lambda kv: kv[1])[0] for k, s in speakers.items() if s}
    want = set(tops.values())
    placed = {}
    for name in order:
        if not want - set(placed):
            break
        p = plugin_path(name)
        if not os.path.exists(p):
            continue
        buf = open(p, "rb").read()
        start, masters, _ = header(buf)
        mlist = [m.lower() for m in masters]
        if not ({n[0] for n in want} & (set(mlist) | {name.lower()})):
            continue
        for typ, flags, fid, off, size in walk(buf, start, len(buf), {b"CELL", b"WRLD"}):
            if typ != b"ACHR":
                continue
            for t, v in subrecs(body_of(buf, off, size, flags)):
                if t == b"NAME":
                    b = struct.unpack("<I", v)[0]
                    bi = b >> 24
                    base = (mlist[bi] if bi < len(mlist) else name.lower(), b & 0xFFFFFF)
                    if base in want and base not in placed:
                        i = fid >> 24
                        placed[base] = (mlist[i] if i < len(mlist) else name.lower(), fid & 0xFFFFFF)
                    break

    def fs(k):
        return {"plugin": case.get(k[0], k[0]), "local": k[1] & (0xFFF if k[0] in light else 0xFFFFFF)}

    t11 = {"version": 1, "generated": out["generated"], "quests": [], "speakers": []}
    for k in sorted(bkeys):
        by_plugin = {}
        for i in infos[k]:
            f = fs(i)
            by_plugin.setdefault(f["plugin"], []).append(f["local"])
        t11["quests"].append({"quest": fs(k), "infos": {p: sorted(v) for p, v in by_plugin.items()}})
    for base in sorted(want):
        if base in placed:
            t11["speakers"].append({"npc": fs(base), "ref": fs(placed[base])})
    with open(OUT_DIR + "az11_targets.json", "w", encoding="utf-8", newline="\n") as fh:
        json.dump(t11, fh, indent=1)

    say("plugins read: %d (origin masters %d) | story quests from origin masters: %d (core types %d, wider %d)"
        % (nplug, len(origins), len(story), sum(1 for q in story.values() if q["type"] in CORE_TYPES),
           sum(1 for q in story.values() if q["type"] not in CORE_TYPES)))
    say("names by source: " + ", ".join("%s %d" % kv for kv in sorted(src.items())))
    say("dropped: " + ", ".join("%s %d" % kv for kv in sorted(dropped.items())))
    say("AZ-10 judge terms: core %d, wider %d -> %saz10_judge_terms.json"
        % (len(out["tiers"]["core"]), len(out["tiers"]["wider"]), OUT_DIR))
    say("AZ-11: blacklist entries %d, quests found %d, INFOs %d, speakers with a placed ref %d of %d -> %saz11_targets.json"
        % (len(black), len(bkeys), sum(len(v) for v in infos.values()), len(t11["speakers"]), len(want), OUT_DIR))
    say("done in %d s" % (time.time() - t0))


if __name__ == "__main__":
    main()
