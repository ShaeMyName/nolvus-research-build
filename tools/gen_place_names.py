"""Offline place-name table for the IntelEngine destination guard (spec §17b, REVIEW_LOG R42-plan / RV-210).

Reads the load order (gamedata/active/_loadorder.txt, the same source as quest_integrity_builder.py) and writes
build/private_out/ErrandBridge/place_names.json, a PapyrusUtil JsonUtil file:
  formList "m:<name>"  marker refs that name resolves to (LCTN world-location marker MNAM, or a map marker REFR)
  formList "l:<name>"  the matching location per entry (LCTN; for a map-marker-only entry the marker itself, which the
                       Papyrus side casts to Location -> None and then reads the marker's own location)
  int      "count", "maxwords", "lctn", "mapmarkers", "skipped_*"
<name> = the in-game display name, lowercased, punctuation except ' and - dropped, a leading "the" dropped. Names made
only of generic place nouns / articles / semantic words (GENERIC) are left out: those phrases keep going to
IntelEngine's own matcher plus the §17b locality check.
Spoiler rule (R42-plan (6)): the table is data only, like the quest list. This tool prints counts only, never names;
the output lives in private_out/ (gitignored).
Names of localized plugins come from their .STRINGS tables (the base game's from STOCK GAME/Data/Skyrim - Interface.bsa,
Creation Club ones from their own BSAs, mods' from loose Strings/ folders), extracted read-only to C:/nolvus-research/
private_strings/. A localized record whose string is not found keeps the name of the previous override, else is skipped.
Usage: gen_place_names.py   (no arguments)"""
import glob, json, os, re, struct, subprocess, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from quest_integrity_builder import walk, body_of, subrecs, header, plugin_path, form_string, ACTIVE

OUT = "C:/nolvus-research/build/private_out/ErrandBridge/place_names.json"
STR_DIR = "C:/nolvus-research/private_strings/"
STOCK_DATA = "C:/Nolvus/Instances/Nolvus Awakening/STOCK GAME/Data/"
MODS = "C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/"
BSA_EXTRACT = "C:/nolvus-research/tools/scripts/bsa_extract.py"
GENERIC = set("""
the a an of at in on to by and near by
market marketplace stables stable inn tavern gate gates temple shop store square docks dock mine farm camp tower college
meadery keep fort city town village hold house home room hall cave river lake sea road bridge outside inside upstairs
downstairs back front here there tree well smithy forge mill lumber barracks jail prison palace castle courtyard garden
gardens shrine chapel cemetery graveyard hut cabin shack ruins ruin tomb barrow mountain hill pass bay coast beach shore
woods wood forest field fields plains marsh swamp lighthouse estate manor lodge outpost watchtower wall walls district
quarter bathhouse bath warehouse store storeroom cellar basement attic kitchen bedroom tent wagon ship boat
""".split())


def norm(name):
    s = name.lower().replace("\u2019", "'")
    s = re.sub(r"[^a-z0-9' \-]", " ", s)
    s = re.sub(r"\s+", " ", s).strip()
    if s.startswith("the "):
        s = s[4:]
    return s


def keep(key):
    w = key.split()
    return len(key) >= 4 and not key.isdigit() and not all(x in GENERIC for x in w)


# ---------------------------------------------------------------- strings
def read_strings(path):
    b = open(path, "rb").read()
    n, size = struct.unpack_from("<II", b, 0)
    base = 8 + n * 8
    out = {}
    for i in range(n):
        sid, off = struct.unpack_from("<II", b, 8 + i * 8)
        e = b.index(b"\0", base + off)
        out[sid] = b[base + off:e].decode("utf-8", "replace")
    return out


def strings_for(plugin):
    """The english .strings table of a localized plugin, or None. Extracts from a BSA once (read-only on it)."""
    stem = os.path.splitext(plugin)[0].lower()
    want = "%s_english.strings" % stem
    for p in glob.glob(STR_DIR + "**/*.strings", recursive=True):
        if os.path.basename(p).lower() == want:
            return read_strings(p)
    for bsa in (STOCK_DATA + stem + ".bsa", ACTIVE + stem + ".bsa"):
        if os.path.exists(bsa):
            subprocess.run([sys.executable, "-I", BSA_EXTRACT, bsa, STR_DIR + stem, "strings\\"], capture_output=True)
            for p in glob.glob(STR_DIR + stem + "/**/*.strings", recursive=True):
                if os.path.basename(p).lower() == want:
                    return read_strings(p)
    for p in glob.glob(MODS + "*/[Ss]trings/*.[Ss][Tt][Rr][Ii][Nn][Gg][Ss]"):
        if os.path.basename(p).lower() == want:
            return read_strings(p)
    return None


# ---------------------------------------------------------------- scan
def main():
    t0 = time.time()
    lo = [l.strip() for l in open(ACTIVE + "_loadorder.txt", encoding="utf-8") if l.strip() and not l.startswith("#")]
    base_tbl = {}
    for f in ("skyrim", "update", "dawnguard", "hearthfires", "dragonborn"):
        p = STR_DIR + "strings/%s_english.strings" % f
        base_tbl[f + ".esm"] = read_strings(p) if os.path.exists(p) else None
    loc = {}       # (defplugin, local) -> dict(name, marker)
    mm = {}        # (defplugin, local) -> name           map-marker REFRs
    stats = {"plugins": 0, "localized_no_strings": 0, "skipped_unnamed": 0, "skipped_deleted": 0}
    for plugin in lo:
        path = plugin_path(plugin)
        if not os.path.exists(path):
            continue
        buf = open(path, "rb").read()
        hend, masters, flags = header(buf)
        localized = bool(flags & 0x80)
        tbl = None
        if localized:
            tbl = base_tbl.get(plugin.lower()) if plugin.lower() in base_tbl else strings_for(plugin)
            if tbl is None:
                stats["localized_no_strings"] += 1
        stats["plugins"] += 1

        def key_of(fid):
            idx = fid >> 24
            return (masters[idx] if idx < len(masters) else plugin, fid & 0xFFFFFF)

        def full_name(body):
            for t, v in subrecs(body):
                if t == b"FULL":
                    if localized:
                        sid = struct.unpack_from("<I", v)[0] if len(v) >= 4 else 0
                        return (tbl or {}).get(sid)
                    return v.rstrip(b"\0").decode("cp1252", "replace")
            return None

        for typ, rflags, fid, off, size in walk(buf, hend, len(buf), {b"LCTN", b"WRLD", b"CELL"}):
            if typ not in (b"LCTN", b"REFR"):
                continue
            k = key_of(fid)
            if rflags & 0x20:                                   # deleted
                loc.pop(k, None) if typ == b"LCTN" else mm.pop(k, None)
                stats["skipped_deleted"] += 1
                continue
            if typ == b"REFR":
                raw = buf[off + 24:off + 24 + size]
                if b"XMRK" not in raw and not (rflags & 0x40000):
                    if k in mm:                                 # an override that dropped the marker data
                        mm.pop(k)
                    continue
                body = body_of(buf, off, size, rflags)
                if b"XMRK" not in body:
                    mm.pop(k, None)
                    continue
                if rflags & 0x800:                              # initially disabled
                    mm.pop(k, None)
                    continue
                nm = full_name(body)
                if nm:
                    mm[k] = nm
                elif k not in mm:
                    stats["skipped_unnamed"] += 1
                continue
            body = body_of(buf, off, size, rflags)
            nm = full_name(body)
            marker = None
            for t, v in subrecs(body):
                if t == b"MNAM" and len(v) >= 4:
                    mf = struct.unpack_from("<I", v)[0]
                    marker = key_of(mf) if mf else None
            prev = loc.get(k, {})
            loc[k] = {"name": nm or prev.get("name"), "marker": marker or prev.get("marker")}
    table, nl, nm_ = {}, 0, 0
    for k, v in loc.items():
        if not v["name"] or not v["marker"]:
            continue
        key = norm(v["name"])
        if not keep(key):
            continue
        table.setdefault(key, []).append((form_string(*v["marker"]), form_string(*k)))
        nl += 1
    for k, name in mm.items():
        key = norm(name)
        if not keep(key):
            continue
        ms = form_string(*k)
        if any(m == ms for m, _ in table.get(key, [])):
            continue
        table.setdefault(key, []).append((ms, ms))
        nm_ += 1
    out = {"formList": {}, "int": {"count": len(table), "lctn": nl, "mapmarkers": nm_,
                                   "maxwords": max((len(k.split()) for k in table), default=0)}}
    for key, ents in table.items():
        out["formList"]["m:" + key] = [m for m, _ in ents]
        out["formList"]["l:" + key] = [l for _, l in ents]
    for s, n in stats.items():
        out["int"][s] = n
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    json.dump(out, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=0)
    dup = sum(1 for e in table.values() if len(e) > 1)
    print("place_names: %d names (%d from locations, %d from map markers; %d names with more than one place), maxwords %d"
          % (len(table), nl, nm_, dup, out["int"]["maxwords"]))
    print("plugins %d, localized without strings %d, unnamed markers %d, deleted %d; %.0f s -> %s"
          % (stats["plugins"], stats["localized_no_strings"], stats["skipped_unnamed"], stats["skipped_deleted"],
             time.time() - t0, OUT))


if __name__ == "__main__":
    main()
