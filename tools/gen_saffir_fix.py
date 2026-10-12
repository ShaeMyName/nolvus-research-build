"""Build IEB_SaffirPackageFix.esl (REVIEW_LOG RV-194-dec; crash_table.md watch item: 3 Saffir-context crashes).
Override ESL: Saffir's winning NPC_ record (Skyrim.esm 0x013B98, last override in the TEST load order) copied byte for byte,
minus the one PKID entry for AI Overhaul.esp:0x001957 (AIOWRSaffirRandom11x3). Masters = the winner's masters in order + the
winner itself, so every FormID in the copied record keeps its meaning without remapping. No new forms (valid ESL).
Writes build/out/IEB_SaffirPackageFix.esl and re-parses it. Read-only on C:\\Nolvus. Usage: gen_saffir_fix.py"""
import struct, sys, zlib

WIN_DIR = "C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/Nolvus Awakening Combat Scaling Overhaul - Milk Drinker/"
WIN = "Nolvus Awakening Combat Scaling Overhaul - Enemy Level Mult.esp"
OUT = "C:/nolvus-research/build/out/IEB_SaffirPackageFix.esl"
SAFFIR = ("Skyrim.esm", 0x013B98)
DROP = ("AI Overhaul.esp", 0x001957)


def subrecords(data):
    i, out = 0, []
    while i < len(data):
        t = data[i:i + 4]
        n = struct.unpack_from("<H", data, i + 4)[0]
        out.append((t, data[i + 6:i + 6 + n]))
        i += 6 + n
    return out


def masters_of(b):
    size = struct.unpack_from("<I", b, 4)[0]
    return [d.rstrip(b"\0").decode("utf-8", "replace") for t, d in subrecords(b[24:24 + size]) if t == b"MAST"], 24 + size


def find_record(b, rtype, fid):
    i = masters_of(b)[1]
    while i < len(b) - 24:
        t = b[i:i + 4]
        size, flags, f = struct.unpack_from("<III", b, i + 4)
        if t == b"GRUP":
            i += 24
            continue
        if t == rtype and f == fid:
            return i, size, flags
        i += 24 + size
    return None


def main():
    b = open(WIN_DIR + WIN, "rb").read()
    mast, _ = masters_of(b)
    lower = [m.lower() for m in mast]
    sidx = lower.index(SAFFIR[0].lower())
    didx = lower.index(DROP[0].lower())
    fid = (sidx << 24) | SAFFIR[1]
    drop = (didx << 24) | DROP[1]
    hit = find_record(b, b"NPC_", fid)
    if not hit:
        sys.exit("FAIL: Saffir NPC_ %08X not found in %s" % (fid, WIN))
    off, size, flags = hit
    raw = b[off + 24:off + 24 + size]
    data = zlib.decompress(raw[4:]) if flags & 0x40000 else raw
    subs = subrecords(data)
    pk = [struct.unpack_from("<I", d)[0] for t, d in subs if t == b"PKID"]
    print("winner PKID list:", ["%08X" % x for x in pk], "| drop %08X" % drop)
    if pk.count(drop) != 1:
        sys.exit("FAIL: the AI Overhaul package is not exactly once in the list")
    new = b"".join(t + struct.pack("<H", len(d)) + d for t, d in subs if not (t == b"PKID" and struct.unpack_from("<I", d)[0] == drop))
    rec_hdr = bytearray(b[off:off + 24])
    struct.pack_into("<I", rec_hdr, 4, len(new))
    struct.pack_into("<I", rec_hdr, 8, flags & ~0x40000)          # stored uncompressed
    rec = bytes(rec_hdr) + new
    grup = b"GRUP" + struct.pack("<I", 24 + len(rec)) + b"NPC_" + struct.pack("<IHHHH", 0, 0, 0, 0, 0) + rec
    # TES4 header: ESL flag 0x200; HEDR 1.71, 2 (GRUP + record), next object id 0x800
    hedr = struct.pack("<fII", 1.71, 2, 0x800)        # numRecords counts the GRUP too
    body = b"HEDR" + struct.pack("<H", 12) + hedr
    cnam = b"IEB (REVIEW_LOG RV-194-dec)\0"
    body += b"CNAM" + struct.pack("<H", len(cnam)) + cnam
    snam = b"Drops AI Overhaul's AIOWRSaffirRandom11x3 from Saffir's package list (crash watch item).\0"
    body += b"SNAM" + struct.pack("<H", len(snam)) + snam
    for m in mast + [WIN]:
        mm = m.encode("utf-8") + b"\0"
        body += b"MAST" + struct.pack("<H", len(mm)) + mm + b"DATA" + struct.pack("<H", 8) + b"\0" * 8
    tes4 = b"TES4" + struct.pack("<III", len(body), 0x200, 0) + struct.pack("<HHHH", 0, 0, 44, 0) + body
    out = tes4 + grup
    open(OUT, "wb").write(out)
    # re-parse
    chk = open(OUT, "rb").read()
    m2, _ = masters_of(chk)
    h2 = find_record(chk, b"NPC_", fid)
    d2 = chk[h2[0] + 24:h2[0] + 24 + h2[1]]
    pk2 = [struct.unpack_from("<I", d)[0] for t, d in subrecords(d2) if t == b"PKID"]
    print("written %s (%d bytes), ESL flag=%s, masters=%d (last=%s), Saffir PKID now:" % (OUT, len(chk),
          bool(struct.unpack_from("<I", chk, 8)[0] & 0x200), len(m2), m2[-1]), ["%08X" % x for x in pk2])
    print("OK" if pk2 == [x for x in pk if x != drop] else "FAIL: list mismatch")


if __name__ == "__main__":
    main()
