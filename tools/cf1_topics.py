"""CF-1 offline (TASK_C step 4, component C): for each registry topic (custom followers' own follow/wait/dismiss/recruit
DIALs), find every INFO under it across the active load order (winning override per INFO), its owning quest and its TIF
fragment script. Writes build/out/cf1/topics.json (EditorIDs stay in the file; the console prints counts only).
Only the top-level DIAL group of each plugin is parsed."""
import json, os, struct, sys, zlib
sys.path.insert(0, os.path.dirname(__file__))
import espio

ACT = "C:/nolvus-research/gamedata/active/"
REG = "C:/nolvus-research/build/data/custom_followers.json"
OUT = "C:/nolvus-research/build/out/cf1/"


def header(buf):
    rec, o = espio.parse_record(buf, 0, False)
    masters = [s.raw[:-1].decode("cp1252") for s in rec.subs if s.sig == "MAST"]
    return rec, masters, o


def norm(fid, masters, me, light):
    i = fid >> 24
    if i < len(masters):
        return masters[i].lower(), fid & 0xFFFFFF
    return me.lower(), (fid & 0xFFF) if light else (fid & 0xFFFFFF)


def edid(rec):
    for s in rec.subs:
        if s.sig == "EDID":
            return s.raw[:-1].decode("cp1252", "replace")
    return ""


def info_tif(rec):
    for s in rec.subs:
        if s.sig == "VMAD":
            b = s.raw
            r = espio.Reader(b)
            ver, fmt = r.i16(), r.i16()
            espio._scripts_dec(r, ver, fmt)
            scripts = []
            if not r.done():
                r.i8()
                flags = r.u8()
                fn = r.wstr()
                return fn
            return ""
    return ""


def main():
    reg = json.load(open(REG, encoding="utf-8"))
    want = {}
    for n in reg["npcs"]:
        for t in n.get("topics") or []:
            want[(t["plugin"].lower(), int(t["form"], 16))] = (n["name"], t["role"])
    order = [l.strip() for l in open(ACT + "_loadorder.txt", encoding="utf-8") if l.strip()]
    dials = {}       # key -> {quest, edid, plugin}
    infos = {}       # (dialkey, infokey) -> {plugin(last wins), tif, quest_override}
    for pl in order:
        p = ACT + pl
        if not os.path.exists(p):
            p = ACT + "../" + pl                 # base masters live in gamedata/
            if not os.path.exists(p):
                print("MISSING plugin " + pl)
                continue
        buf = open(p, "rb").read()
        hrec, masters, o = header(buf)
        light = bool(hrec.flags & 0x200)
        while o < len(buf):
            size = struct.unpack_from("<I", buf, o + 4)[0]
            if buf[o + 8:o + 12] == b"DIAL":
                g, _ = espio.parse_group(buf, o, False)
                cur = None
                for c in g.children:
                    if isinstance(c, espio.Record) and c.sig == "DIAL":
                        cur = norm(c.formid, masters, pl, light)
                        if cur in want:
                            q = next((s for s in c.subs if s.sig == "QNAM"), None)
                            qk = norm(struct.unpack("<I", q.raw)[0], masters, pl, light) if q else None
                            dials.setdefault(cur, {})
                            dials[cur].update({"quest": qk, "edid": edid(c), "last": pl})
                    elif isinstance(c, espio.Group) and c.gtype == 7 and cur in want:
                        for r in c.children:
                            if isinstance(r, espio.Record) and r.sig == "INFO":
                                ik = norm(r.formid, masters, pl, light)
                                infos[(cur, ik)] = {"plugin": pl, "tif": info_tif(r), "deleted": bool(r.flags & 0x20)}
            o += size
    os.makedirs(OUT, exist_ok=True)
    rows = []
    for k, (name, role) in want.items():
        d = dials.get(k)
        its = [{"info": "%s|0x%06X" % (ik[0], ik[1]), **v} for (dk, ik), v in infos.items() if dk == k]
        rows.append({"npc": name, "role": role, "dial": "%s|0x%06X" % k, "found": d is not None,
                     "quest": ("%s|0x%06X" % d["quest"]) if d and d["quest"] else None,
                     "dial_edid": d["edid"] if d else None, "infos": its})
    json.dump(rows, open(OUT + "topics.json", "w", encoding="utf-8"), indent=1)
    print("topics wanted %d, found %d, infos %d, with TIF %d" % (
        len(want), sum(r["found"] for r in rows), sum(len(r["infos"]) for r in rows),
        sum(1 for r in rows for i in r["infos"] if i["tif"])))


if __name__ == "__main__":
    main()
