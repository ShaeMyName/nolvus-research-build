"""Quest-integrity list builder (spec §10.2.1; TASK_C step 1). Offline, read-only on gamedata/ copies.

Outputs (counts only are printed; never EditorIDs, names or the files):
  build/out/ErrandBridge/quest_integrity.json   story_quests, reserved_npcs, exempt_plugins (PapyrusUtil form strings)
  build/out/PackageOverrides.ini                MARAS config: shipped file + S-26 keys (§11.12.1 rule 8)
  build/redacted/PackageOverrides.ini           the same with QuestWhitelist lines replaced by one count comment (for git)

Load order: gamedata/active/_loadorder.txt (written by sync_active.py). Base masters are read from gamedata/.
Usage: quest_integrity_builder.py [--probe] [--extra-quest EDID ...]
  --probe        test builds only: write_probe = 1, so the patched StoryEngine has PapyrusUtil write the probe forms
                 itself (test Q-9). Lucienne's build never sets it.
  --extra-quest  step 6 adds the synthetic test quest.
"""
import json, os, re, struct, sys, zlib

G = "C:/nolvus-research/gamedata/"
ACTIVE = G + "active/"
OUT = "C:/nolvus-research/build/out/"
RED = "C:/nolvus-research/build/redacted/"
MARAS_SHIPPED = "C:/nolvus-research/build/upstream/maras-0.11.0/SKSE/Plugins/PackageOverrides.ini"

STORY_TYPES = {1, 2, 3, 4, 5, 7, 8, 9, 10, 11}          # QUST/DNAM byte 8; not None (0), not Misc (6)
EXEMPT = ["IntelEngine.esp", "ErrandBridge.esp", "SceneControls.esp", "nwsFollowerFramework.esp",
          "SeverActions.esp", "SkyrimNet.esp", "TT_MARAS.esp"]
GETISID = 72                                              # condition_functions_se1597.json
SERANA_PATTERN = "DLC1Serana*"
SERANA_EXPECT = ("dawnguard.esm", 0x005044)


def form_string(plugin, local_id):
    """PapyrusUtil JsonUtil form string. INFERRED from PapyrusUtil.dll literals ("0x", "|");
    exact match against a FormListAdd-written list is test Q-9 (in game)."""
    return "0x%X|%s" % (local_id, plugin)


def plugin_path(name):
    p = ACTIVE + name
    return p if os.path.exists(p) else G + name


def walk(buf, off, end, want_top, depth=0, top=None):
    """Yield (type, flags, formid, off, size) for records under the wanted top-level groups."""
    while off < end:
        typ = buf[off:off + 4]
        size = struct.unpack_from("<I", buf, off + 4)[0]
        if typ == b"GRUP":
            label = buf[off + 8:off + 12]
            gtype = struct.unpack_from("<i", buf, off + 12)[0]
            t = label if depth == 0 and gtype == 0 else top
            if depth > 0 or (gtype == 0 and label in want_top):
                yield from walk(buf, off + 24, off + size, want_top, depth + 1, t)
            off += size
        else:
            flags, fid = struct.unpack_from("<II", buf, off + 8)
            yield typ, flags, fid, off, size
            off += 24 + size


def body_of(buf, off, size, flags):
    b = buf[off + 24:off + 24 + size]
    return zlib.decompress(b[4:]) if flags & 0x40000 else b


def subrecs(body):
    o, big = 0, None
    while o + 6 <= len(body):
        t = body[o:o + 4]
        s = struct.unpack_from("<H", body, o + 4)[0]
        if t == b"XXXX":
            big = struct.unpack_from("<I", body, o + 6)[0]
            o += 6 + s
            continue
        if big is not None:
            s, big = big, None
        yield t, body[o + 6:o + 6 + s]
        o += 6 + s


def header(buf):
    hsize = struct.unpack_from("<I", buf, 4)[0]
    flags = struct.unpack_from("<I", buf, 8)[0]
    masters = [v.rstrip(b"\0").decode("latin1") for t, v in subrecs(buf[24:24 + hsize]) if t == b"MAST"]
    return 24 + hsize, masters, flags


def main():
    extra = sys.argv[sys.argv.index("--extra-quest") + 1:] if "--extra-quest" in sys.argv else []
    probe = "--probe" in sys.argv
    light = set()
    order = [l.strip() for l in open(ACTIVE + "_loadorder.txt", encoding="utf-8") if l.strip()]
    exempt_l = {e.lower() for e in EXEMPT}

    quests = {}      # (origin_lower, local) -> dict(edid, type, origin, aliases, ...)   winning override
    refs_needed = set()
    for name in order:
        buf = open(plugin_path(name), "rb").read()
        start, masters, hflags = header(buf)
        mlist = [m.lower() for m in masters]
        if hflags & 0x200 or name.lower().endswith(".esl"):
            light.add(name.lower())

        def resolve(fid, _m=mlist, _self=name.lower(), _orig=masters, _name=name):
            idx = fid >> 24
            return (_m[idx], fid & 0xFFFFFF) if idx < len(_m) else (_self, fid & 0xFFFFFF)

        def origin_name(fid, _orig=masters, _name=name):
            idx = fid >> 24
            return _orig[idx] if idx < len(_orig) else _name

        for typ, flags, fid, off, size in walk(buf, start, len(buf), {b"QUST"}):
            if typ != b"QUST":
                continue
            body = body_of(buf, off, size, flags)
            q = {"edid": "", "type": None, "unique": set(), "forced": set(), "isid": set()}
            in_ref_alias = False
            for t, v in subrecs(body):
                if t == b"EDID":
                    q["edid"] = v.rstrip(b"\0").decode("latin1")
                elif t == b"DNAM" and len(v) > 8:
                    q["type"] = v[8]
                elif t == b"ALST":
                    in_ref_alias = True
                elif t in (b"ALLS", b"ALED"):
                    in_ref_alias = False
                elif in_ref_alias and t == b"ALUA":
                    q["unique"].add(resolve(struct.unpack("<I", v)[0]))
                elif in_ref_alias and t == b"ALFR":
                    r = resolve(struct.unpack("<I", v)[0])
                    q["forced"].add(r)
                elif in_ref_alias and t == b"CTDA" and len(v) >= 16:
                    func = struct.unpack_from("<H", v, 8)[0]
                    if func == GETISID:
                        q["isid"].add(resolve(struct.unpack_from("<I", v, 12)[0]))
            key = resolve(fid)
            q["origin"] = origin_name(fid)
            q["local"] = fid & 0xFFFFFF
            quests[key] = q   # later plugins override earlier: last in load order wins

    story = {k: q for k, q in quests.items() if q["type"] in STORY_TYPES and q["origin"].lower() not in exempt_l}
    for q in story.values():
        refs_needed |= q["forced"]

    # Pass 2: placed actor refs (ACHR) named by forced-reference aliases -> their base NPC (winning override).
    achr_base = {}
    npc_forms = set()
    for name in order:
        buf = open(plugin_path(name), "rb").read()
        start, masters, _ = header(buf)
        mlist = [m.lower() for m in masters]
        for typ, flags, fid, off, size in walk(buf, start, len(buf), {b"CELL", b"WRLD", b"NPC_"}):
            idx = fid >> 24
            key = (mlist[idx] if idx < len(mlist) else name.lower(), fid & 0xFFFFFF)
            if typ == b"NPC_":
                npc_forms.add(key)
            elif typ == b"ACHR" and key in refs_needed:
                body = body_of(buf, off, size, flags)
                for t, v in subrecs(body):
                    if t == b"NAME":
                        b = struct.unpack("<I", v)[0]
                        bi = b >> 24
                        achr_base[key] = (mlist[bi] if bi < len(mlist) else name.lower(), b & 0xFFFFFF)
                        break

    reserved = set()
    for q in story.values():
        reserved |= q["unique"] | q["isid"]
        reserved |= {achr_base[r] for r in q["forced"] if r in achr_base}
    reserved = {r for r in reserved if r in npc_forms}   # GetIsID may name non-NPC forms; keep NPC bases only

    case = {n.lower(): n for n in order}
    out = {
        "formList": {
            "story_quests": sorted(form_string(case.get(k[0], k[0]), k[1] & (0xFFF if k[0] in light else 0xFFFFFF)) for k in story),
            "reserved_npcs": sorted(form_string(case.get(k[0], k[0]), k[1] & (0xFFF if k[0] in light else 0xFFFFFF)) for k in reserved),
        },
        "stringList": {"exempt_plugins": EXEMPT},
        "int": {"story_quests_count": len(story), "reserved_npcs_count": len(reserved),
                "exempt_plugins_count": len(EXEMPT), "write_probe": 1 if probe else 0},
    }
    # Q-9 probe forms: one per kind of origin, so every spelling case is covered
    picks = []
    for lst, keys in (("story_quests", story), ("reserved_npcs", reserved)):
        for kind, pred in (("base master", lambda k: k[0] == "skyrim.esm"),
                           ("full plugin", lambda k: k[0] not in light and k[0].endswith(".esp")),
                           ("light plugin", lambda k: k[0] in light)):
            cand = sorted(k for k in keys if pred(k))
            if cand:
                picks.append((lst, kind, cand[0]))
    out["intList"] = {"probe_ids": [k[1] & (0xFFF if k[0] in light else 0xFFFFFF) for _, _, k in picks]}
    out["stringList"]["probe_plugins"] = [case.get(k[0], k[0]) for _, _, k in picks]
    out["stringList"]["probe_lists"] = [l for l, _, _ in picks]
    os.makedirs(OUT + "ErrandBridge", exist_ok=True)
    with open(OUT + "ErrandBridge/quest_integrity.json", "w", encoding="utf-8", newline="\n") as fh:
        json.dump(out, fh, indent=1)

    # MARAS PackageOverrides.ini (S-26)
    edids = []
    empty = 0
    for q in sorted(story.values(), key=lambda q: (q["origin"].lower(), q["local"])):
        if q["edid"]:
            edids.append(q["edid"])
        else:
            empty += 1
    edids += extra
    seen, uniq = set(), []
    for e in edids:
        if e.lower() not in seen:
            seen.add(e.lower())
            uniq.append(e)
    bad = [e for e in uniq if re.search(r"[\s*?,;]", e)]
    assert not bad, "%d EditorIDs contain whitespace or * ? , ;" % len(bad)

    serana_rx = re.compile("^" + re.escape(SERANA_PATTERN.lower()).replace(r"\*", ".*") + "$")
    serana_hits = sorted({k for k, q in quests.items() if serana_rx.match(q["edid"].lower())})
    serana_ok = serana_hits == [SERANA_EXPECT]

    shipped = open(MARAS_SHIPPED, "rb").read().decode("utf-8")
    lines = shipped.split("\r\n")
    i = lines.index("[PackageOverrides]")
    head = lines[:i + 1]
    keys = ["Whitelist=SkyrimNet*",
            "AllowedPlugins=nwsFollowerFramework.esp,IntelEngine.esp",
            "QuestPriority=256"] + ["QuestWhitelist=" + e for e in uniq] + ["QuestWhitelist=" + SERANA_PATTERN]
    text = "\r\n".join(head + keys) + "\r\n"
    with open(OUT + "PackageOverrides.ini", "wb") as fh:
        fh.write(text.encode("utf-8"))
    os.makedirs(RED, exist_ok=True)
    red = "\r\n".join(head + keys[:3] + ["; [redacted] %d QuestWhitelist lines (story_quests EditorIDs%s) + QuestWhitelist=%s"
                                         % (len(uniq), " + %d extra" % len(extra) if extra else "", SERANA_PATTERN)]) + "\r\n"
    with open(RED + "PackageOverrides.ini", "wb") as fh:
        fh.write(red.encode("utf-8"))

    # Verify by re-reading
    back = open(OUT + "PackageOverrides.ini", "rb").read().decode("utf-8").split("\r\n")
    sec = back[back.index("[PackageOverrides]") + 1:]
    qw = [l for l in sec if l.startswith("QuestWhitelist=")]
    single = all(re.fullmatch(r"QuestWhitelist=[^\s*?,;]+", l) for l in qw[:-1]) and qw[-1] == "QuestWhitelist=" + SERANA_PATTERN
    inline = any(";" in l or "#" in l for l in sec if l)
    jb = json.load(open(OUT + "ErrandBridge/quest_integrity.json", encoding="utf-8"))

    types = {}
    for q in quests.values():
        types[q["type"]] = types.get(q["type"], 0) + 1
    print("plugins read:", len(order))
    print("quests (winning records):", len(quests), "| by type:", dict(sorted((str(k), v) for k, v in types.items())))
    print("story_quests:", len(jb["formList"]["story_quests"]), "(exempt-plugin story quests dropped:",
          sum(1 for q in quests.values() if q["type"] in STORY_TYPES and q["origin"].lower() in exempt_l), ")")
    print("reserved_npcs:", len(jb["formList"]["reserved_npcs"]),
          "| from unique-actor:", len({r for q in story.values() for r in q["unique"]} & npc_forms),
          "| forced-ref resolved:", sum(1 for r in refs_needed if r in achr_base), "of", len(refs_needed),
          "| GetIsID:", len({r for q in story.values() for r in q["isid"]} & npc_forms))
    print("exempt_plugins:", len(jb["stringList"]["exempt_plugins"]), "| light plugins in load order:", len(light))
    print("probe forms:", len(picks), [(l, k) for l, k, _ in picks], "| write_probe:", jb["int"]["write_probe"])
    print("MARAS: QuestWhitelist lines:", len(qw), "= story EditorIDs", len(uniq) - len(extra), "+ extra", len(extra),
          "+ Serana 1 | empty EditorIDs skipped:", empty)
    print("MARAS checks: count ok:", len(qw) == len(uniq) + 1, "| single-token lines:", single,
          "| no inline comments:", not inline, "| DLC1Serana* matches only Dawnguard.esm 0x005044:", serana_ok,
          "(%d match)" % len(serana_hits))


if __name__ == "__main__":
    main()
