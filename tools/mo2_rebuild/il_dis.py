"""Read-only mini IL disassembler: decodes a byte range of a .NET PE linearly, resolving ldstr / call / field tokens.
Usage: python -I il_dis.py <pe> <start-hex> <end-hex>"""
import struct
import sys

p, start, end = sys.argv[1], int(sys.argv[2], 16), int(sys.argv[3], 16)
b = open(p, "rb").read()
pe = struct.unpack_from("<I", b, 0x3C)[0]
nsec = struct.unpack_from("<H", b, pe + 6)[0]
optsz = struct.unpack_from("<H", b, pe + 20)[0]
opt = pe + 24
magic = struct.unpack_from("<H", b, opt)[0]
ddir = opt + (96 if magic == 0x10B else 112)
cli_rva = struct.unpack_from("<I", b, ddir + 14 * 8)[0]
secs = []
for i in range(nsec):
    vs, va, rs, ro = struct.unpack_from("<IIII", b, opt + optsz + i * 40 + 8)
    secs.append((va, max(vs, rs), ro))


def off(rva):
    for va, sz, ro in secs:
        if va <= rva < va + sz:
            return rva - va + ro
    raise ValueError(rva)


cli = off(cli_rva)
md = off(struct.unpack_from("<I", b, cli + 8)[0])
vlen = struct.unpack_from("<I", b, md + 12)[0]
q = md + 16 + vlen + 2
n = struct.unpack_from("<H", b, q)[0]
q += 2
st = {}
for _ in range(n):
    o, sz = struct.unpack_from("<II", b, q)
    q += 8
    e = b.index(b"\0", q)
    st[b[q:e].decode()] = (md + o, sz)
    q = (e + 4) & ~3
tb = st.get("#~") or st["#-"]
t0 = tb[0]
hs = b[t0 + 6]
valid = struct.unpack_from("<Q", b, t0 + 8)[0]
q = t0 + 24
rows = {}
for t in range(64):
    if valid >> t & 1:
        rows[t] = struct.unpack_from("<I", b, q)[0]
        q += 4
SI = 4 if hs & 1 else 2
GI = 4 if hs & 2 else 2
BI = 4 if hs & 4 else 2


def ti(t):
    return 4 if rows.get(t, 0) > 0xFFFF else 2


def ci(tags, bits):
    m = max(rows.get(t, 0) for t in tags if t is not None)
    return 4 if m >= (1 << (16 - bits)) else 2


TDOR = ci([2, 1, 0x1B], 2)
HC = ci([4, 8, 0x17], 2)
HCA = ci([6, 4, 1, 2, 8, 9, 10, 0, 0x0E, 0x17, 0x14, 0x11, 0x1A, 0x1B, 0x20, 0x23, 0x26, 0x27, 0x28, 0x2A, 0x2C, 0x2B], 5)
HFM = ci([4, 8], 1)
HDS = ci([2, 6, 0x20], 2)
MRP = ci([2, 1, 0x1A, 6, 0x1B], 3)
HS = ci([0x14, 0x17], 1)
MDO = ci([6, 0x0A], 1)
MF = ci([4, 6], 1)
IMPL = ci([0x26, 0x23, 0x27], 2)
CAT = ci([None, None, 6, 0x0A, None], 3)
RS = ci([0, 0x1A, 0x23, 1], 2)
TOMD = ci([2, 6], 1)
size = {
    0x00: 2 + SI + GI * 3, 0x01: RS + SI * 2, 0x02: 4 + SI * 2 + TDOR + ti(4) + ti(6), 0x03: ti(4),
    0x04: 2 + SI + BI, 0x05: ti(6), 0x06: 4 + 2 + 2 + SI + BI + ti(8), 0x07: ti(8), 0x08: 2 + 2 + SI,
    0x09: ti(2) + TDOR, 0x0A: MRP + SI + BI, 0x0B: 2 + HC + BI, 0x0C: HCA + CAT + BI, 0x0D: HFM + BI,
    0x0E: 2 + HDS + BI, 0x0F: 2 + 4 + ti(2), 0x10: 4 + ti(4), 0x11: BI, 0x12: ti(2) + ti(0x14), 0x13: ti(0x14),
    0x14: 2 + SI + TDOR, 0x15: ti(2) + ti(0x17), 0x16: ti(0x17), 0x17: 2 + SI + BI, 0x18: 2 + ti(6) + HS,
    0x19: ti(2) + MDO * 2, 0x1A: SI, 0x1B: BI, 0x1C: 2 + MF + SI + ti(0x1A), 0x1D: 4 + ti(4),
}
base = {}
q2 = q
for t in sorted(rows):
    if t not in size:
        break
    base[t] = q2
    q2 += size[t] * rows[t]
strs = st["#Strings"][0]


def sname(i):
    e = b.index(b"\0", strs + i)
    return b[strs + i:e].decode("utf-8", "replace")


def rd(o, w):
    return struct.unpack_from("<I" if w == 4 else "<H", b, o)[0]


def typename(tdor):
    tag, idx = tdor & 3, tdor >> 2
    if tag == 1:
        r = base[1] + (idx - 1) * size[1]
        return sname(rd(r + RS, SI))
    if tag == 0:
        r = base[2] + (idx - 1) * size[2]
        return sname(rd(r + 4, SI))
    return "spec"


def tok(tk):
    t, i = tk >> 24, tk & 0xFFFFFF
    try:
        if t == 0x0A:
            r = base[0x0A] + (i - 1) * size[0x0A]
            cls = rd(r, MRP)
            par = typename(((cls >> 3) << 2) | {0: 0, 1: 1, 4: 2}.get(cls & 7, 3)) if cls & 7 in (0, 1, 4) else "?"
            return "%s::%s" % (par, sname(rd(r + MRP, SI)))
        if t == 0x06:
            r = base[0x06] + (i - 1) * size[0x06]
            return "M:" + sname(rd(r + 8, SI))
        if t == 0x04:
            r = base[0x04] + (i - 1) * size[0x04]
            return "F:" + sname(rd(r + 2, SI))
        if t in (0x01, 0x02):
            return "T:" + typename((i << 2) | (1 if t == 1 else 0))
        if t == 0x70:
            o = st["#US"][0] + i
            c = b[o]
            if c & 0x80 == 0:
                L, o = c, o + 1
            else:
                L, o = ((c & 0x3F) << 8) | b[o + 1], o + 2
            return repr(b[o:o + L - 1].decode("utf-16-le", "replace"))
    except Exception as e:
        return "tok%08X(%s)" % (tk, type(e).__name__)
    return "tok%08X" % tk


ONE = {0x00: "nop", 0x02: "ldarg.0", 0x03: "ldarg.1", 0x04: "ldarg.2", 0x05: "ldarg.3", 0x06: "ldloc.0", 0x07: "ldloc.1",
       0x08: "ldloc.2", 0x09: "ldloc.3", 0x0A: "stloc.0", 0x0B: "stloc.1", 0x0C: "stloc.2", 0x0D: "stloc.3", 0x14: "ldnull",
       0x15: "ldc.m1", 0x16: "ldc.0", 0x17: "ldc.1", 0x18: "ldc.2", 0x19: "ldc.3", 0x1A: "ldc.4", 0x1B: "ldc.5",
       0x1C: "ldc.6", 0x1D: "ldc.7", 0x1E: "ldc.8", 0x25: "dup", 0x26: "pop", 0x2A: "ret", 0x58: "add", 0x69: "conv.i4",
       0x8E: "ldlen", 0x9A: "ldelem.ref", 0xA2: "stelem.ref", 0xDC: "endfinally", 0x9D: "stelem.i2", 0x9E: "stelem.i4"}
B1 = {0x0E: "ldarg.s", 0x11: "ldloc.s", 0x12: "ldloca.s", 0x13: "stloc.s", 0x1F: "ldc.s", 0x2B: "br.s", 0x2C: "brfalse.s",
      0x2D: "brtrue.s", 0xDE: "leave.s", 0x0F: "ldarga.s", 0x10: "starg.s"}
B4 = {0x20: "ldc.i4", 0x28: "call", 0x38: "br", 0x39: "brfalse", 0x3A: "brtrue", 0x6F: "callvirt", 0x72: "ldstr",
      0x73: "newobj", 0x7B: "ldfld", 0x7C: "ldflda", 0x7D: "stfld", 0x7E: "ldsfld", 0x7F: "ldsflda", 0x80: "stsfld",
      0x8D: "newarr", 0x8C: "box", 0x74: "castclass", 0x75: "isinst", 0xD0: "ldtoken", 0xDD: "leave"}
i = start
while i < end:
    o = b[i]
    if o in ONE:
        print("%06X %s" % (i, ONE[o]))
        i += 1
    elif o in B1:
        print("%06X %s %d" % (i, B1[o], b[i + 1]))
        i += 2
    elif o in B4:
        tk = struct.unpack_from("<I", b, i + 1)[0]
        arg = tok(tk) if o not in (0x20, 0x38, 0x39, 0x3A, 0xDD) else str(tk)
        print("%06X %s %s" % (i, B4[o], arg))
        i += 5
    elif o == 0xFE:
        o2 = b[i + 1]
        if o2 in (0x06, 0x07, 0x15, 0x16, 0x1C):
            print("%06X FE%02X %s" % (i, o2, tok(struct.unpack_from("<I", b, i + 2)[0])))
            i += 6
        elif o2 in (0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E):
            print("%06X FE%02X %d" % (i, o2, struct.unpack_from("<H", b, i + 2)[0]))
            i += 4
        else:
            print("%06X FE%02X" % (i, o2))
            i += 2
    else:
        print("%06X ?? %02X" % (i, o))
        i += 1
