"""CF-1 offline, part 3: every INFO in the load order whose TIF script is one of the registry topics' TIF names.
A script-name blacklist key blocks all of them, so any use outside the registry topics is reported (counts only)."""
import json, os, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import espio
from cf1_topics import header, norm, info_tif, ACT
res = json.load(open("C:/nolvus-research/build/out/cf1/classified.json", encoding="utf-8"))
names = {x["tif"].lower() for x in res}
mine = {(x["info"].lower()) for x in res}
outside = {}
for pl in [l.strip() for l in open(ACT + "_loadorder.txt", encoding="utf-8") if l.strip()]:
    p = ACT + pl if os.path.exists(ACT + pl) else ACT + "../" + pl
    if not os.path.exists(p):
        continue
    buf = open(p, "rb").read()
    hrec, masters, o = header(buf)
    light = bool(hrec.flags & 0x200)
    while o < len(buf):
        size = struct.unpack_from("<I", buf, o + 4)[0]
        if buf[o + 8:o + 12] == b"DIAL":
            g, _ = espio.parse_group(buf, o, False)
            for c in g.children:
                if isinstance(c, espio.Group):
                    for r in c.children:
                        if isinstance(r, espio.Record) and r.sig == "INFO":
                            t = info_tif(r).lower()
                            if t in names:
                                ik = "%s|0x%06X" % norm(r.formid, masters, pl, light)
                                if ik.lower() not in mine:
                                    outside.setdefault(t, set()).add(ik)
        o += size
json.dump({k: sorted(v) for k, v in outside.items()}, open("C:/nolvus-research/build/out/cf1/reuse.json", "w"), indent=1)
print("TIF names %d; used outside the registry topics: %d names, %d INFOs" % (len(names), len(outside), sum(len(v) for v in outside.values())))
