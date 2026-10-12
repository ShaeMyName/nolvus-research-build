"""Read-only: list ldstr operands (file order) with the small opcodes between them, in a .NET DLL.
Usage: python -I il_ldstr.py <dll> <anchor-substring> <before> <after>"""
import struct
import sys

p, anchor, nb, na = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
b = open(p, "rb").read()
pe = struct.unpack_from("<I", b, 0x3C)[0]
nsec = struct.unpack_from("<H", b, pe + 6)[0]
optsz = struct.unpack_from("<H", b, pe + 20)[0]
opt = pe + 24
magic = struct.unpack_from("<H", b, opt)[0]
ddir = opt + (96 if magic == 0x10B else 112)
cli_rva = struct.unpack_from("<I", b, ddir + 14 * 8)[0]
secs = []
so = opt + optsz
for i in range(nsec):
    vs, va, rs, ro = struct.unpack_from("<IIII", b, so + i * 40 + 8)
    secs.append((va, max(vs, rs), ro))


def off(rva):
    for va, sz, ro in secs:
        if va <= rva < va + sz:
            return rva - va + ro
    raise ValueError(rva)


cli = off(cli_rva)
md_rva = struct.unpack_from("<I", b, cli + 8)[0]
md = off(md_rva)
vlen = struct.unpack_from("<I", b, md + 12)[0]
q = md + 16 + vlen + 2
nstreams = struct.unpack_from("<H", b, q)[0]
q += 2
us = None
for _ in range(nstreams):
    o, sz = struct.unpack_from("<II", b, q)
    q += 8
    e = b.index(b"\0", q)
    name = b[q:e].decode()
    q = (e + 4) & ~3
    if name == "#US":
        us = (md + o, sz)


def usstr(idx):
    if idx >= us[1]:
        return None
    o = us[0] + idx
    c = b[o]
    if c & 0x80 == 0:
        n, o = c, o + 1
    elif c & 0xC0 == 0x80:
        n, o = ((c & 0x3F) << 8) | b[o + 1], o + 2
    else:
        n, o = ((c & 0x1F) << 24) | (b[o + 1] << 16) | (b[o + 2] << 8) | b[o + 3], o + 4
    if n == 0:
        return ""
    return b[o:o + n - 1].decode("utf-16-le", "replace")


SMALL = {0x14: "ldnull", 0x15: "ldc.-1", 0x16: "ldc.0", 0x17: "ldc.1", 0x18: "ldc.2", 0x19: "ldc.3", 0x1A: "ldc.4",
         0x1B: "ldc.5", 0x1C: "ldc.6", 0x1D: "ldc.7", 0x1E: "ldc.8"}
ev = []
text = [s for s in secs if s[2] < len(b)]
i = 0
while i < len(b) - 5:
    if b[i] == 0x72 and b[i + 4] == 0x70:
        idx = b[i + 1] | (b[i + 2] << 8) | (b[i + 3] << 16)
        s = usstr(idx)
        if s is not None and idx > 0:
            mids = []
            j = i - 1
            while j > i - 24 and j >= 0:
                if b[j] in SMALL:
                    mids.append(SMALL[b[j]])
                j -= 1
            ev.append((i, s, list(reversed(mids))[-3:]))
            i += 5
            continue
    i += 1
hits = [k for k, e in enumerate(ev) if anchor in e[1]]
for h in hits[:3]:
    print("==== anchor at event", h)
    for k in range(max(0, h - nb), min(len(ev), h + na)):
        o, s, mids = ev[k]
        print("%08X %-24s %r" % (o, " ".join(mids), s[:160]))
