"""RV-207 follow-up: predicted runtime FormIDs (load_index.py's 'masters first' order) of the first NEW record in each
named plugin, for FormModProbe. Prints hex FormIDs + plugin name only (no record names). Read-only."""
import struct, sys, zlib
sys.argv, names = [sys.argv[0]], sys.argv[1:]
import io, contextlib
with contextlib.redirect_stdout(io.StringIO()):
    import load_index as L


def first_new(path):
    b = open(path, "rb").read()
    hsize = struct.unpack_from("<I", b, 4)[0]
    hdr = b[24:24 + hsize]
    masters, i = 0, 0
    while i < len(hdr):
        t, sz = hdr[i:i + 4], struct.unpack_from("<H", hdr, i + 4)[0]
        if t == b"MAST":
            masters += 1
        i += 6 + sz
    pos = 24 + hsize
    stack = [len(b)]
    while pos < len(b):
        typ = b[pos:pos + 4]
        size = struct.unpack_from("<I", b, pos + 4)[0]
        if typ == b"GRUP":
            pos += 24
            continue
        fid = struct.unpack_from("<I", b, pos + 12)[0]
        if (fid >> 24) >= masters:
            return fid & 0xFFFFFF, typ.decode()
        pos += 24 + size
    return None, None


info = dict(L.info)
seq = [x for x in L.info if L.is_master(*x)] + [x for x in L.info if not L.is_master(*x)]
full, light, idx = 0, 0, {}
for p, fl in seq:
    if L.is_light(p, fl):
        idx[p.lower()] = ("light", light)
        light += 1
    else:
        idx[p.lower()] = ("full", full)
        full += 1
for n in names:
    k, i = idx.get(n.lower(), (None, None))
    path = L.where.get(n.lower())
    if k is None or not path:
        print("%s: not active/found" % n)
        continue
    local, typ = first_new(path)
    if local is None:
        print("%s: no new record" % n)
        continue
    fid = (0xFE000000 | (i << 12) | (local & 0xFFF)) if k == "light" else ((i << 24) | local)
    print("%08X %s %s index=%s" % (fid, typ, n, ("FE%03X" % i) if k == "light" else "%02X" % i))
