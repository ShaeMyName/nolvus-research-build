"""Round-trip proof for espio (Shae's check before any shell is generated).

For each real plugin: parse; typed-decode every subrecord the shells author (TES4, GLOB, FLST, SPEL, QUST incl.
VMAD with quest and alias scripts); re-encode each from its typed value and compare with the original bytes; then
re-emit the whole file and compare byte for byte. Compressed records: the decompressed body is re-emitted from the
typed subrecords and compared; the file keeps the original compressed payload (the shells are never compressed).
Also checks HEDR numRecords against the computed count. Prints counts and failures only."""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
import espio

AUTHORED = {"TES4", "GLOB", "FLST", "SPEL", "QUST"}


def walk(groups):
    for g in groups:
        for c in g.children:
            if isinstance(c, espio.Group):
                yield from walk([c])
            else:
                yield c


def run(path):
    buf = open(path, "rb").read()
    p = espio.parse(buf)
    stats = {}
    fails = []
    recs = [p.header] + list(walk(p.groups))
    for rec in recs:
        if rec.sig not in AUTHORED:
            continue
        loc = p.localized and rec.sig != "TES4"
        try:
            n = espio.decode_record(rec, loc)
        except Exception as e:
            fails.append("%s %08X decode: %s" % (rec.sig, rec.formid, e))
            continue
        st = stats.setdefault(rec.sig, {"records": 0, "typed_subs": 0, "vmad": 0, "alias_scripts": 0, "props": 0})
        st["records"] += 1
        st["typed_subs"] += n
        for s in rec.subs:
            if not s.typed:
                continue
            again = espio.codecs_for(rec.sig, loc)[s.sig][1](s.value)
            if again != s.raw:
                fails.append("%s %08X sub %s re-encode differs (%d vs %d bytes)" % (rec.sig, rec.formid, s.sig, len(again), len(s.raw)))
            if s.sig == "VMAD":
                st["vmad"] += 1
                st["props"] += sum(len(x["props"]) for x in s.value["scripts"])
                q = s.value.get("quest")
                if q:
                    st["alias_scripts"] += sum(len(a["scripts"]) for a in q["aliases"])
                if "tail" in s.value:
                    fails.append("%s %08X VMAD has an undecoded tail" % (rec.sig, rec.formid))
        if rec.flags & 0x40000:
            body = espio.emit_subs(rec, loc)
            if body != rec._body:
                fails.append("%s %08X compressed body differs" % (rec.sig, rec.formid))
    out = espio.emit(p)
    hedr = [s for s in p.header.subs if s.sig == "HEDR"][0].value
    counted = espio.count_records_and_groups(p)
    print("%-40s %s | file identical: %s | HEDR numRecords %d, counted %d%s" % (
        os.path.basename(path), " ".join("%s:%d/%d%s" % (k, v["records"], v["typed_subs"],
            (" vmad=%d props=%d aliasScripts=%d" % (v["vmad"], v["props"], v["alias_scripts"])) if v["vmad"] else "")
            for k, v in sorted(stats.items())),
        out == buf, hedr["numRecords"], counted, "" if hedr["numRecords"] == counted else " (differs)"))
    for f in fails[:10]:
        print("   FAIL", f)
    if len(fails) > 10:
        print("   ... %d more failures" % (len(fails) - 10))
    return out == buf and not fails


if __name__ == "__main__":
    ok = all([run(a) for a in sys.argv[1:]])
    print("ROUND TRIP:", "PASS" if ok else "FAIL")
