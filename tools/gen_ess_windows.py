"""Essential-followers window table builder (design essential_followers_design.md §5, §7.2). Offline, read-only on gamedata/.

PRIVATE DATA: every quest, actor, stage and mode comes from the private record at runtime
(investigation/round10/essential_followers_SPOILERS.md, sections A, B, D, E). This script holds no story literals and
prints counts only (no EditorIDs, names, stages or forms). --diag adds per-row reason codes keyed by row number only.

Outputs (never committed: build/private_out/ is gitignored):
  build/private_out/ErrandBridge/ess_windows.json        the table read by IEB_EssLib.LoadWindows
  build/private_out/ErrandBridge/ess_windows_rows0.json  test variant, rows = 0 ("no windows", for E-* tests)

Schema (IEB_EssLib.psc header + LoadWindows): int "rows" = N (0..64); formList "w_quest", "w_base"; intList "w_any",
"w_mode", "w_lo", "w_hi"; all lists N long. Open while the quest runs and w_lo <= GetStage() < w_hi (w_hi < 0 = no upper
bound). Form strings are PapyrusUtil's "0x<lowercase hex local id>|<Plugin>" (quest_integrity_builder.form_string, Q-9).

Encoding rules (from the record's §D and §E):
  - §D gives each row's (from, to): "N -> M" / "N -> M or K" (closing stages collapsed to the lowest, since the bridge
    compares the current stage) / "N -> stop" (w_hi -1) / "start -> M" (w_lo 0) / "<id>, N, null ..." (w_hi -1).
  - §E gives the mode: "ACTIVE REMOVAL" = 1 (suspend), "stay out" = 0.
  - Any-follower rows (§B): w_any 1, w_base = the row's quest form (LoadWindows needs a form in every slot).
  - Rows whose quest or actor base does not resolve in the load order are left out and counted by §A tag.
"""
import json, os, re, struct, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import quest_integrity_builder as qib  # noqa: E402  (walk / body_of / subrecs / header / form_string / plugin_path)

PRIVATE = "C:/nolvus-research/investigation/round10/essential_followers_SPOILERS.md"
OUTDIR = "C:/nolvus-research/build/private_out/ErrandBridge/"
OUT = OUTDIR + "ess_windows.json"
OUT0 = OUTDIR + "ess_windows_rows0.json"
MAX_ROWS = 64
DIAG = "--diag" in sys.argv


def diag(msg):
    if DIAG:
        print("  [diag]", msg)


# ----------------------------------------------------------------------------------------------- private record parsing

def sections(text):
    out, cur = {}, None
    for line in text.splitlines():
        m = re.match(r"^## ([A-Z])\.", line)
        if m:
            cur = m.group(1)
            out[cur] = []
        elif cur:
            out[cur].append(line)
    return out


def table(lines):
    """Markdown table rows (header and separator dropped) as lists of stripped cells."""
    rows = [l for l in lines if l.strip().startswith("|")]
    cells = [[c.strip() for c in l.strip().strip("|").split("|")] for l in rows]
    return [c for c in cells[2:] if c]


def words(s, minlen=4):
    return [w.lower() for w in re.findall(r"[A-Za-z0-9_]+", s) if len(w) >= minlen]


def score(label_tokens, row_tokens):
    n = 0
    for t in label_tokens:
        if any(r.startswith(t) or t.startswith(r) for r in row_tokens):
            n += 1
    return n


def best_match(label_tokens, candidates):
    """Index of the candidate with the strictly highest score > 0, else None."""
    sc = [score(label_tokens, c) for c in candidates]
    top = max(sc) if sc else 0
    if top <= 0 or sc.count(top) != 1:
        return None
    return sc.index(top)


def parse_record():
    text = open(PRIVATE, encoding="utf-8").read()
    sec = sections(text)
    for k in "ABDE":
        assert k in sec, "private record: section %s missing" % k

    rows = []   # dict(sec, num, tag, name, actor_cell, quest_edid, quest_cell, edids?, any)
    last_quest = None
    for c in table(sec["A"]):
        assert len(c) >= 7, "section A: row with %d cells" % len(c)
        num, actor, quest, tagcell = c[0], c[1], c[2], c[-1]
        m = re.match(r"^\s*([A-Za-z0-9_]+)", quest)
        qedid = m.group(1) if m else ""
        if quest.strip().lower() == "same" and last_quest:
            qedid, quest = last_quest
        last_quest = (qedid, quest)
        tag = (re.match(r"\s*([A-Z]+)", tagcell) or re.match(r"(.*)", "UNKNOWN")).group(1)
        name = actor.split("(")[0].strip()
        rng = re.match(r"^(\d+)\s*-\s*(\d+)$", num)
        count = int(rng.group(2)) - int(rng.group(1)) + 1 if rng else 1
        if count > 1:
            # group row: N actor EditorIDs written as "<Prefix><Name1> / <Name2> / ..." in the parenthesis
            inner = actor[actor.find("(") + 1:]
            first_seg = re.split(r"[;,)]", inner)[0]
            parts = [p.strip() for p in first_seg.split("/") if p.strip()]
            edids = []
            if parts:
                pm = re.match(r"^(.*?)([A-Z][a-z]+)$", parts[0])
                prefix = pm.group(1) if pm else ""
                edids = [parts[0]] + [prefix + p for p in parts[1:]]
            for k in range(count):
                rows.append(dict(sec="A", num="%s.%d" % (num, k + 1), tag=tag, name=name, actor_cell=actor,
                                 quest_edid=qedid, quest_cell=quest, any=False,
                                 group_edid=edids[k] if len(edids) == count else None, group=True))
        else:
            rows.append(dict(sec="A", num=num, tag=tag, name=name, actor_cell=actor, quest_edid=qedid,
                             quest_cell=quest, any=False, group_edid=None, group=False))
    for c in table(sec["B"]):
        quest = c[0]
        m = re.match(r"^\s*([A-Za-z0-9_]+)", quest)
        rows.append(dict(sec="B", num="B", tag="B", name="", actor_cell="", quest_edid=m.group(1) if m else "",
                         quest_cell=quest, any=True, group_edid=None, group=False))

    # §D windows: "<label> (<spec>)" items after the first colon of the "Rows from" sentence
    dtext = " ".join(l.strip() for l in sec["D"])
    i = dtext.find("Rows from")
    assert i >= 0, "section D: 'Rows from' sentence missing"
    dtext = dtext[dtext.find(":", i) + 1:]
    j = dtext.find("Counts only")
    if j >= 0:
        dtext = dtext[:j]
    ditems = [(lab.strip(" ,."), spec) for lab, spec in re.findall(r"([^(),]+)\(([^()]*)\)", dtext)]

    # §E modes
    eitems = []
    for c in table(sec["E"]):
        act = c[-1]
        if "ACTIVE REMOVAL" in act:
            mode = 1
        elif "stay out" in act.lower():
            mode = 0
        else:
            mode = None
        eitems.append((c[0], mode))
    return rows, ditems, eitems


def parse_spec(spec):
    """(lo, hi, flags) from a §D spec. flags: 'collapsed' (several closing stages), 'extra' (condition not encodable)."""
    flags = set()
    if "->" in spec:
        lo_s, hi_s = spec.split("->", 1)
        lo_i = re.findall(r"\b\d+\b", lo_s)
        if lo_i:
            lo = int(lo_i[0])
        elif "start" in lo_s.lower():
            lo = 0
        else:
            raise ValueError("lo")
        hi_i = [int(x) for x in re.findall(r"\b\d+\b", hi_s)]
        if hi_i:
            hi = min(hi_i)
            if len(hi_i) > 1:
                flags.add("collapsed")
        elif "stop" in hi_s.lower():
            hi = -1
        else:
            raise ValueError("hi")
    else:
        parts = [p.strip() for p in spec.split(",")]
        parts = [p for p in parts if not re.match(r"^0x[0-9A-Fa-f]+$", p)]
        if len(parts) < 2 or not re.match(r"^\d+$", parts[0]):
            raise ValueError("tuple")
        lo = int(parts[0])
        hp = parts[1]
        if hp.lower().startswith("null"):
            hi = -1
            if "+" in hp:
                flags.add("extra")
        else:
            hi_i = [int(x) for x in re.findall(r"\b\d+\b", hp)]
            if not hi_i:
                raise ValueError("hi")
            hi = min(hi_i)
            if len(hi_i) > 1:
                flags.add("collapsed")
    return lo, hi, flags


# ----------------------------------------------------------------------------------------------- plugin data

def acronym(stem):
    return "".join(w[0] for w in re.findall(r"[A-Za-z0-9]+", stem)).lower()


def plugin_for_hint(hint, order):
    h = hint.strip().strip(":").strip().lower()
    if not h:
        return None
    for n in order:
        if n.lower() == h:
            return n
    for n in order:
        if os.path.splitext(n)[0].lower() == h:
            return n
    hits = [n for n in order if acronym(os.path.splitext(n)[0]) == h and len(h) >= 3]
    return hits[0] if len(hits) == 1 else None


def scan(order):
    """Winning QUST and NPC_ records by (origin_lower, local24): EDID, alias actor refs."""
    quests, npcs, light = {}, {}, set()
    for name in order:
        buf = open(qib.plugin_path(name), "rb").read()
        start, masters, hflags = qib.header(buf)
        mlist = [m.lower() for m in masters]
        if hflags & 0x200 or name.lower().endswith(".esl"):
            light.add(name.lower())

        def resolve(fid, _m=mlist, _self=name.lower()):
            idx = fid >> 24
            return (_m[idx] if idx < len(_m) else _self, fid & 0xFFFFFF)

        for typ, flags, fid, off, size in qib.walk(buf, start, len(buf), {b"QUST", b"NPC_"}):
            if typ not in (b"QUST", b"NPC_"):
                continue
            body = qib.body_of(buf, off, size, flags)
            edid, unique, forced, in_ref = "", set(), set(), False
            for t, v in qib.subrecs(body):
                if t == b"EDID":
                    edid = v.rstrip(b"\0").decode("latin1")
                    if typ == b"NPC_":
                        break
                elif t == b"ALST":
                    in_ref = True
                elif t in (b"ALLS", b"ALED"):
                    in_ref = False
                elif in_ref and t == b"ALUA" and len(v) >= 4:
                    unique.add(resolve(struct.unpack_from("<I", v)[0]))
                elif in_ref and t == b"ALFR" and len(v) >= 4:
                    forced.add(resolve(struct.unpack_from("<I", v)[0]))
            key = resolve(fid)
            if typ == b"QUST":
                quests[key] = dict(edid=edid, unique=unique, forced=forced)
            else:
                npcs[key] = edid
    return quests, npcs, light


def achr_bases(order, refs):
    out = {}
    if not refs:
        return out
    for name in order:
        buf = open(qib.plugin_path(name), "rb").read()
        start, masters, _ = qib.header(buf)
        mlist = [m.lower() for m in masters]
        for typ, flags, fid, off, size in qib.walk(buf, start, len(buf), {b"CELL", b"WRLD"}):
            if typ != b"ACHR":
                continue
            idx = fid >> 24
            key = (mlist[idx] if idx < len(mlist) else name.lower(), fid & 0xFFFFFF)
            if key not in refs:
                continue
            for t, v in qib.subrecs(qib.body_of(buf, off, size, flags)):
                if t == b"NAME":
                    b = struct.unpack("<I", v)[0]
                    bi = b >> 24
                    out[key] = (mlist[bi] if bi < len(mlist) else name.lower(), b & 0xFFFFFF)
                    break
    return out


def same_local(key_local, given, origin, light):
    mask = 0xFFF if origin in light else 0xFFFFFF
    return (key_local & mask) == (given & mask) or (key_local & mask) == (given & 0xFFFFFF & mask)


def hex_hints(cell):
    """[(hint_text, int_id, is_template)] for each 0x.. in the cell."""
    out = []
    for m in re.finditer(r"0x([0-9A-Fa-f]+)", cell):
        before = cell[:m.start()]
        cut = max(before.rfind(ch) for ch in "(,;/")
        hint = before[cut + 1:].strip().rstrip(":").strip()
        out.append((hint, int(m.group(1), 16), "template" in before.lower()))
    return out


# ----------------------------------------------------------------------------------------------- main

def main():
    rows, ditems, eitems = parse_record()
    order = [l.strip() for l in open(qib.ACTIVE + "_loadorder.txt", encoding="utf-8") if l.strip()]
    case = {n.lower(): n for n in order}
    quests, npcs, light = scan(order)
    q_by_edid, n_by_edid = {}, {}
    for k, q in quests.items():
        q_by_edid.setdefault(q["edid"].lower(), []).append(k)
    for k, e in npcs.items():
        n_by_edid.setdefault(e.lower(), []).append(k)

    def fs(key):
        return qib.form_string(case.get(key[0], key[0]), key[1] & (0xFFF if key[0] in light else 0xFFFFFF))

    notes = {"prefix_masked": 0, "collapsed": 0, "extra": 0, "alias_linked": 0, "name_resolved": 0}

    # ---- windows (§D) and modes (§E) per row
    row_tokens = []
    for r in rows:
        t = [r["quest_edid"].lower()] if r["quest_edid"] else []
        t += words(r["name"]) if r["name"] else []
        row_tokens.append(t)
    d_used, e_used = set(), set()
    d_tok = [words(lab) for lab, _ in ditems]
    e_tok = [words(case_) for case_, _ in eitems]
    for i, r in enumerate(rows):
        di = best_match(row_tokens[i], d_tok)
        ei = best_match(row_tokens[i], e_tok)
        r["lo"] = r["hi"] = r["mode"] = None
        if di is not None:
            d_used.add(di)
            try:
                r["lo"], r["hi"], fl = parse_spec(ditems[di][1])
                r["flags"] = fl
            except ValueError as ex:
                diag("row %s: window spec unparsed (%s)" % (r["num"], ex))
        if ei is not None:
            e_used.add(ei)
            r["mode"] = eitems[ei][1]
        if di is None or ei is None:
            diag("row %s: no unique match in %s" % (r["num"], "D" if di is None else "E"))
    assert len(d_used) == len(ditems), "section D: %d of %d items matched no row" % (len(ditems) - len(d_used), len(ditems))
    assert len(e_used) == len(eitems), "section E: %d of %d cases matched no row" % (len(eitems) - len(e_used), len(eitems))

    # ---- resolve quests
    for r in rows:
        r["qkey"], r["why"] = None, None
        cands = q_by_edid.get(r["quest_edid"].lower(), []) if r["quest_edid"] else []
        if len(cands) != 1:
            r["why"] = "quest_edid_%s" % ("missing" if not cands else "ambiguous")
            continue
        key = cands[0]
        hh = [h for h in hex_hints(r["quest_cell"]) if not h[2]]
        if hh:
            hint, given, _ = hh[0]
            p = plugin_for_hint(hint, order)
            if p is None or p.lower() != key[0]:
                r["why"] = "quest_plugin_mismatch"
                continue
            if not same_local(key[1], given, key[0], light):
                r["why"] = "quest_id_mismatch"
                continue
            if given > 0xFFFFFF:
                notes["prefix_masked"] += 1
        r["qkey"] = key

    # ---- alias-referenced actor bases of the row quests (for name-only rows and the alias-link count)
    refs = set()
    for r in rows:
        if r["qkey"]:
            refs |= quests[r["qkey"]]["forced"]
    achr = achr_bases(order, refs)

    def alias_bases(qkey):
        q = quests[qkey]
        b = set(q["unique"]) | {achr[x] for x in q["forced"] if x in achr}
        return {x for x in b if x in npcs}

    # ---- resolve actor bases
    for r in rows:
        r["bkey"] = None
        if r["why"]:
            continue
        if r["any"]:
            r["bkey"] = r["qkey"]
            continue
        if r["group"]:
            ed = r["group_edid"]
            cands = n_by_edid.get(ed.lower(), []) if ed else []
            if len(cands) != 1:
                r["why"] = "actor_edid_%s" % ("missing" if not cands else "ambiguous")
            else:
                r["bkey"] = cands[0]
            continue
        hh = [h for h in hex_hints(r["actor_cell"]) if not h[2]]
        if hh:
            hint, given, _ = hh[0]
            p = plugin_for_hint(hint, order)
            if p is None:
                r["why"] = "actor_plugin_unknown"
                continue
            mask = 0xFFF if p.lower() in light else 0xFFFFFF
            key = (p.lower(), given & mask)
            hits = [k for k in npcs if k[0] == key[0] and same_local(k[1], given, k[0], light)] if key not in npcs else [key]
            if len(hits) != 1:
                r["why"] = "actor_id_missing"
                continue
            key = hits[0]
            # any EditorID named in the cell must be this record's
            inner = r["actor_cell"][r["actor_cell"].find("(") + 1:] if "(" in r["actor_cell"] else ""
            named = [t for t in re.findall(r"[A-Za-z_][A-Za-z0-9_]{5,}", inner) if t.lower() in n_by_edid]
            if any(t.lower() != npcs[key].lower() for t in named):
                r["why"] = "actor_edid_conflict"
                continue
            r["bkey"] = key
        else:
            # name only: an NPC_ base held by one of the quest's aliases whose EditorID contains the actor name
            nm = words(r["name"], 3)
            cands = [b for b in alias_bases(r["qkey"]) if nm and all(w in npcs[b].lower() for w in nm[:1])]
            if len(cands) != 1:
                r["why"] = "actor_name_%s" % ("missing" if not cands else "ambiguous")
                continue
            r["bkey"] = cands[0]
            notes["name_resolved"] += 1
        if r["bkey"] in alias_bases(r["qkey"]):
            notes["alias_linked"] += 1

    # ---- window/mode sanity per row
    for r in rows:
        if r["why"]:
            continue
        if r["lo"] is None or r["mode"] not in (0, 1):
            r["why"] = "window_or_mode_unparsed"
        elif not (r["hi"] < 0 or r["lo"] < r["hi"]):
            r["why"] = "window_empty"

    ok = [r for r in rows if not r["why"]]
    bad = [r for r in rows if r["why"]]
    for r in bad:
        diag("row %s unresolved: %s" % (r["num"], r["why"]))
    for r in ok:
        notes["collapsed"] += 1 if "collapsed" in r.get("flags", ()) else 0
        notes["extra"] += 1 if "extra" in r.get("flags", ()) else 0
    assert len(ok) <= MAX_ROWS, "rows %d > %d" % (len(ok), MAX_ROWS)

    def build(rs):
        return {
            "int": {"rows": len(rs)},
            "formList": {"w_quest": [fs(r["qkey"]) for r in rs], "w_base": [fs(r["bkey"]) for r in rs]},
            "intList": {"w_any": [1 if r["any"] else 0 for r in rs], "w_mode": [r["mode"] for r in rs],
                        "w_lo": [r["lo"] for r in rs], "w_hi": [r["hi"] for r in rs]},
        }

    os.makedirs(OUTDIR, exist_ok=True)
    for path, rs in ((OUT, ok), (OUT0, [])):
        with open(path, "w", encoding="utf-8", newline="\n") as fh:
            json.dump(build(rs), fh, indent=1)

    # ---- self-check: re-read both files
    known = {fs(k): k for k in list(quests) + list(npcs)}
    lo_order = {n.lower() for n in order}
    for path, want in ((OUT, len(ok)), (OUT0, 0)):
        j = json.load(open(path, encoding="utf-8"))
        n = j["int"]["rows"]
        assert n == want and 0 <= n <= MAX_ROWS, "%s: rows" % path
        for lst in ("w_quest", "w_base"):
            assert len(j["formList"][lst]) == n, "%s: %s length" % (path, lst)
        for lst in ("w_any", "w_mode", "w_lo", "w_hi"):
            assert len(j["intList"][lst]) == n, "%s: %s length" % (path, lst)
            assert all(isinstance(v, int) for v in j["intList"][lst]), "%s: %s not int" % (path, lst)
        for lst in ("w_quest", "w_base"):
            for s in j["formList"][lst]:
                m = re.fullmatch(r"0x([0-9a-f]+)\|(.+\.(?:esp|esm|esl))", s)
                assert m, "%s: form string format" % path
                assert m.group(2).lower() in lo_order, "%s: plugin not in load order" % path
                lim = 0xFFF if m.group(2).lower() in light else 0xFFFFFF
                assert int(m.group(1), 16) <= lim, "%s: local id width" % path
                assert s in known, "%s: form string does not resolve" % path
        for k in range(n):
            q = known[j["formList"]["w_quest"][k]]
            assert q in quests, "%s: w_quest not a quest" % path
            if j["intList"]["w_any"][k] == 0:
                assert known[j["formList"]["w_base"][k]] in npcs, "%s: w_base not an actor base" % path
            assert j["intList"]["w_any"][k] in (0, 1) and j["intList"]["w_mode"][k] in (0, 1), "%s: flag" % path
            lo, hi = j["intList"]["w_lo"][k], j["intList"]["w_hi"][k]
            assert lo >= 0 and (hi < 0 or lo < hi), "%s: window bounds" % path

    by_tag = {}
    for r in bad:
        by_tag[r["tag"]] = by_tag.get(r["tag"], 0) + 1
    print("record rows: A %d, B %d (total %d)" % (sum(r["sec"] == "A" for r in rows),
                                                  sum(r["sec"] == "B" for r in rows), len(rows)))
    print("rows written: %d | any-follower: %d | mode 0: %d, mode 1: %d" % (
        len(ok), sum(r["any"] for r in ok), sum(r["mode"] == 0 for r in ok), sum(r["mode"] == 1 for r in ok)))
    print("unresolved: %d %s" % (len(bad), dict(sorted(by_tag.items()))))
    print("notes: quest ids with a load-index prefix masked %d | closing stages collapsed %d | extra conditions not "
          "encodable %d | actors resolved by name via quest alias %d | actor bases alias-linked to their quest %d"
          % (notes["prefix_masked"], notes["collapsed"], notes["extra"], notes["name_resolved"], notes["alias_linked"]))
    print("self-check: OK (%s rows=%d, %s rows=0)" % (os.path.basename(OUT), len(ok), os.path.basename(OUT0)))


if __name__ == "__main__":
    main()
