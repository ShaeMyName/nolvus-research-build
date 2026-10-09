"""Skyrim SE plugin reader/writer for the TASK_C shells (ErrandBridge.esp, SceneControls.esp, Lucienne.esl,
ErrandBridgeTest.esp). No CK, no .NET.

Model: Plugin -> header Record + top-level Groups -> Records -> Subrecords. Every subrecord the shells AUTHOR has a
typed codec (decode to Python values, encode back). Everything else is kept as raw bytes. roundtrip.py proves the
codecs on real plugins: decode every authored subrecord, re-encode it, and re-emit the whole file byte-identically.
"""
import struct, zlib

# ---------------------------------------------------------------- primitives

class Reader:
    def __init__(self, b):
        self.b, self.o = b, 0

    def take(self, n):
        v = self.b[self.o:self.o + n]
        if len(v) != n:
            raise ValueError("short read")
        self.o += n
        return v

    def u8(self): return self.take(1)[0]
    def i8(self): return struct.unpack("<b", self.take(1))[0]
    def u16(self): return struct.unpack("<H", self.take(2))[0]
    def i16(self): return struct.unpack("<h", self.take(2))[0]
    def u32(self): return struct.unpack("<I", self.take(4))[0]
    def i32(self): return struct.unpack("<i", self.take(4))[0]
    def f32(self): return struct.unpack("<f", self.take(4))[0]
    def f32raw(self): return self.take(4)          # floats kept as raw 4 bytes: exact round trip, NaN-safe
    def wstr(self): return self.take(self.u16()).decode("cp1252")
    def done(self): return self.o == len(self.b)


class Writer:
    def __init__(self):
        self.parts = []

    def raw(self, b): self.parts.append(bytes(b)); return self
    def u8(self, v): return self.raw(struct.pack("<B", v))
    def i8(self, v): return self.raw(struct.pack("<b", v))
    def u16(self, v): return self.raw(struct.pack("<H", v))
    def i16(self, v): return self.raw(struct.pack("<h", v))
    def u32(self, v): return self.raw(struct.pack("<I", v))
    def i32(self, v): return self.raw(struct.pack("<i", v))
    def f32(self, v): return self.raw(v if isinstance(v, (bytes, bytearray)) else struct.pack("<f", v))
    def wstr(self, s):
        b = s.encode("cp1252")
        return self.u16(len(b)).raw(b)
    def bytes(self): return b"".join(self.parts)


def f32bytes(v):
    return v if isinstance(v, (bytes, bytearray)) else struct.pack("<f", v)

# ---------------------------------------------------------------- VMAD (Papyrus script attachments)

def _obj_dec(r, fmt):
    if fmt == 2:
        unused, alias, fid = r.u16(), r.i16(), r.u32()
    else:
        fid, alias, unused = r.u32(), r.i16(), r.u16()
    return {"form": fid, "alias": alias, "unused": unused}


def _obj_enc(w, o, fmt):
    if fmt == 2:
        w.u16(o.get("unused", 0)).i16(o.get("alias", -1)).u32(o["form"])
    else:
        w.u32(o["form"]).i16(o.get("alias", -1)).u16(o.get("unused", 0))


def _val_dec(r, t, fmt):
    if t == 1: return _obj_dec(r, fmt)
    if t == 2: return r.wstr()
    if t == 3: return r.i32()
    if t == 4: return r.f32raw()
    if t == 5: return r.u8()
    if t in (11, 12, 13, 14, 15):
        return [_val_dec(r, t - 10, fmt) for _ in range(r.u32())]
    raise ValueError("unknown property type %d" % t)


def _val_enc(w, t, v, fmt):
    if t == 1: _obj_enc(w, v, fmt)
    elif t == 2: w.wstr(v)
    elif t == 3: w.i32(v)
    elif t == 4: w.f32(v)
    elif t == 5: w.u8(v)
    elif t in (11, 12, 13, 14, 15):
        w.u32(len(v))
        for x in v:
            _val_enc(w, t - 10, x, fmt)
    else:
        raise ValueError("unknown property type %d" % t)


def _scripts_dec(r, ver, fmt):
    out = []
    for _ in range(r.u16()):
        s = {"name": r.wstr(), "status": r.u8() if ver >= 4 else 0, "props": []}
        for _ in range(r.u16()):
            name = r.wstr()
            t = r.u8()
            st = r.u8() if ver >= 4 else 1
            s["props"].append({"name": name, "type": t, "status": st, "value": _val_dec(r, t, fmt)})
        out.append(s)
    return out


def _scripts_enc(w, scripts, ver, fmt):
    w.u16(len(scripts))
    for s in scripts:
        w.wstr(s["name"])
        if ver >= 4:
            w.u8(s.get("status", 0))
        w.u16(len(s["props"]))
        for p in s["props"]:
            w.wstr(p["name"]).u8(p["type"])
            if ver >= 4:
                w.u8(p.get("status", 1))
            _val_enc(w, p["type"], p["value"], fmt)


def vmad_dec(b, rectype):
    r = Reader(b)
    v = {"version": r.i16(), "objFormat": r.i16()}
    v["scripts"] = _scripts_dec(r, v["version"], v["objFormat"])
    if rectype == "QUST" and not r.done():
        q = {"unk": r.i8(), "fragments": []}
        n = r.u16()
        q["fileName"] = r.wstr()
        for _ in range(n):
            q["fragments"].append({"index": r.u16(), "unk1": r.i16(), "logEntry": r.i32(), "unk2": r.i8(),
                                   "scriptName": r.wstr(), "fragmentName": r.wstr()})
        q["aliases"] = []
        for _ in range(r.u16()):
            a = {"object": _obj_dec(r, v["objFormat"]), "version": r.i16(), "objFormat": r.i16()}
            a["scripts"] = _scripts_dec(r, a["version"], a["objFormat"])
            q["aliases"].append(a)
        v["quest"] = q
    if not r.done():
        v["tail"] = r.take(len(b) - r.o)       # fragment data of record types the shells never author
    return v


def vmad_enc(v, rectype):
    w = Writer().i16(v["version"]).i16(v["objFormat"])
    _scripts_enc(w, v["scripts"], v["version"], v["objFormat"])
    q = v.get("quest")
    if q is not None:
        w.i8(q.get("unk", 2)).u16(len(q["fragments"])).wstr(q.get("fileName", ""))
        for f in q["fragments"]:
            w.u16(f["index"]).i16(f.get("unk1", 0)).i32(f.get("logEntry", 0)).i8(f.get("unk2", 1))
            w.wstr(f["scriptName"]).wstr(f["fragmentName"])
        w.u16(len(q["aliases"]))
        for a in q["aliases"]:
            _obj_enc(w, a["object"], v["objFormat"])
            w.i16(a.get("version", v["version"])).i16(a.get("objFormat", v["objFormat"]))
            _scripts_enc(w, a["scripts"], a.get("version", v["version"]), a.get("objFormat", v["objFormat"]))
    if "tail" in v:
        w.raw(v["tail"])
    return w.bytes()

# ---------------------------------------------------------------- per-subrecord codecs (authored fields only)

def zstr_dec(b):
    if not b.endswith(b"\0") or b"\0" in b[:-1]:
        raise ValueError("not a clean zstring")
    return b[:-1].decode("cp1252")


def zstr_enc(s): return s.encode("cp1252") + b"\0"


def u32_dec(b):
    if len(b) != 4: raise ValueError("u32 size %d" % len(b))
    return struct.unpack("<I", b)[0]


def u32_enc(v): return struct.pack("<I", v)


def empty_dec(b):
    if b: raise ValueError("expected empty")
    return None


def empty_enc(v): return b""


def struct_codec(fmt, names):
    size = struct.calcsize(fmt)

    def dec(b):
        if len(b) != size: raise ValueError("%s size %d != %d" % (fmt, len(b), size))
        return dict(zip(names, struct.unpack(fmt, b)))

    def enc(v): return struct.pack(fmt, *[v[n] for n in names])
    return dec, enc


def raw4_dec(b):
    if len(b) != 4: raise ValueError("float size %d" % len(b))
    return b


def raw4_enc(v): return f32bytes(v)


HEDR = struct_codec("<4sII", ["version", "numRecords", "nextObjectId"])           # version kept as raw float bytes
DATA_MAST = struct_codec("<Q", ["size"])
QUST_DNAM = struct_codec("<HBBIB3s", ["flags", "priority", "formVersion", "unknown", "type", "pad"])
OBND = struct_codec("<6h", ["x1", "y1", "z1", "x2", "y2", "z2"])
SPIT = struct_codec("<III4sII4s4sI", ["cost", "flags", "type", "chargeTime", "castType", "delivery",
                                      "castDuration", "range", "halfCostPerk"])
EFIT = struct_codec("<4sII", ["magnitude", "area", "duration"])
CTDA = struct_codec("<B3s4sHHIIIIi", ["op", "pad", "comp", "func", "pad2", "p1", "p2", "runOn", "ref", "p3"])

# FULL / DESC: lstring id in localized plugins, zstring otherwise (decided by the TES4 flag at parse time)
def lstr_dec_factory(localized):
    return (u32_dec if localized else zstr_dec), (u32_enc if localized else zstr_enc)


def codecs_for(rectype, localized):
    full = lstr_dec_factory(localized)
    common = {"EDID": (zstr_dec, zstr_enc)}
    if rectype == "TES4":
        return {"HEDR": HEDR, "CNAM": (zstr_dec, zstr_enc), "SNAM": (zstr_dec, zstr_enc),
                "MAST": (zstr_dec, zstr_enc), "DATA": DATA_MAST, "INTV": (u32_dec, u32_enc)}
    if rectype == "GLOB":
        return dict(common, FNAM=struct_codec("<B", ["kind"]), FLTV=(raw4_dec, raw4_enc))
    if rectype == "FLST":
        return dict(common, LNAM=(u32_dec, u32_enc))
    if rectype == "SPEL":
        return dict(common, OBND=OBND, FULL=full, ETYP=(u32_dec, u32_enc), DESC=full, SPIT=SPIT,
                    EFID=(u32_dec, u32_enc), EFIT=EFIT, CTDA=CTDA)
    if rectype == "QUST":
        return dict(common, VMAD=(lambda b: vmad_dec(b, "QUST"), lambda v: vmad_enc(v, "QUST")), FULL=full,
                    DNAM=QUST_DNAM, ANAM=(u32_dec, u32_enc), NEXT=(empty_dec, empty_enc),
                    ALST=(u32_dec, u32_enc), ALLS=(u32_dec, u32_enc), ALID=(zstr_dec, zstr_enc),
                    ALFR=(u32_dec, u32_enc), ALUA=(u32_dec, u32_enc), ALED=(empty_dec, empty_enc),
                    ALPC=(u32_dec, u32_enc), CTDA=CTDA)
    return common

# ---------------------------------------------------------------- containers

class Sub:
    __slots__ = ("sig", "raw", "value", "typed")

    def __init__(self, sig, raw=None, value=None, typed=False):
        self.sig, self.raw, self.value, self.typed = sig, raw, value, typed


class Record:
    def __init__(self, sig, flags=0, formid=0, vc1=0, vc2=0, version=44, unk=0, subs=None):
        self.sig, self.flags, self.formid = sig, flags, formid
        self.vc1, self.vc2, self.version, self.unk = vc1, vc2, version, unk
        self.subs = subs or []
        self.compressed_payload = None   # original compressed bytes, re-emitted as-is (body proven separately)


class Group:
    def __init__(self, label, gtype, vc1=0, vc2=0, version=0, unk=0, children=None):
        self.label, self.gtype = label, gtype
        self.vc1, self.vc2, self.version, self.unk = vc1, vc2, version, unk
        self.children = children or []


class Plugin:
    def __init__(self, header, groups):
        self.header, self.groups = header, groups

# ---------------------------------------------------------------- parse

def parse_subs(body):
    out, o, big = [], 0, None
    while o < len(body):
        sig = body[o:o + 4].decode("latin1")
        size = struct.unpack_from("<H", body, o + 4)[0]
        if sig == "XXXX":
            big = struct.unpack_from("<I", body, o + 6)[0]
            o += 6 + size
            continue
        if big is not None:
            size, big = big, None
        out.append(Sub(sig, raw=body[o + 6:o + 6 + size]))
        o += 6 + size
    return out


def parse_record(buf, o, localized, stats=None):
    sig = buf[o:o + 4].decode("latin1")
    size, flags, formid, vc1, vc2, version, unk = struct.unpack_from("<IIIHHHH", buf, o + 4)
    body = buf[o + 24:o + 24 + size]
    rec = Record(sig, flags, formid, vc1, vc2, version, unk)
    if flags & 0x40000:
        rec.compressed_payload = body
        body = zlib.decompress(body[4:])
    rec.subs = parse_subs(body)
    rec._body = body
    return rec, o + 24 + size


def parse_group(buf, o, localized):
    size = struct.unpack_from("<I", buf, o + 4)[0]
    label = buf[o + 8:o + 12]
    gtype, vc1, vc2, version, unk = struct.unpack_from("<iHHHH", buf, o + 12)
    g = Group(label, gtype, vc1, vc2, version, unk)
    p, end = o + 24, o + size
    while p < end:
        if buf[p:p + 4] == b"GRUP":
            child, p = parse_group(buf, p, localized)
        else:
            child, p = parse_record(buf, p, localized)
        g.children.append(child)
    return g, end


def parse(buf):
    header, o = parse_record(buf, 0, False)
    localized = bool(header.flags & 0x80)
    groups = []
    while o < len(buf):
        g, o = parse_group(buf, o, localized)
        groups.append(g)
    p = Plugin(header, groups)
    p.localized = localized
    return p

# ---------------------------------------------------------------- typed decode / encode

def decode_record(rec, localized, strict=True):
    """Decode every subrecord that has a codec for this record type. Returns the number decoded."""
    cod = codecs_for(rec.sig, localized)
    n = 0
    for s in rec.subs:
        if s.sig in cod and not s.typed:
            s.value = cod[s.sig][0](s.raw)
            s.typed = True
            n += 1
    return n


def encode_sub(rec_sig, s, localized):
    if s.typed:
        return codecs_for(rec_sig, localized)[s.sig][1](s.value)
    return s.raw


def emit_subs(rec, localized):
    out = []
    for s in rec.subs:
        data = encode_sub(rec.sig, s, localized)
        if len(data) > 0xFFFF:
            out.append(b"XXXX" + struct.pack("<HI", 4, len(data)))
            out.append(s.sig.encode("latin1") + struct.pack("<H", 0) + data)
        else:
            out.append(s.sig.encode("latin1") + struct.pack("<H", len(data)) + data)
    return b"".join(out)


def emit_record(rec, localized):
    body = emit_subs(rec, localized)
    if rec.flags & 0x40000:
        if rec.compressed_payload is None:
            raise ValueError("authoring compressed records is not supported")
        payload = rec.compressed_payload
    else:
        payload = body
    return (rec.sig.encode("latin1") + struct.pack("<IIIHHHH", len(payload), rec.flags, rec.formid,
                                                   rec.vc1, rec.vc2, rec.version, rec.unk) + payload), body


def emit_group(g, localized):
    parts = []
    for c in g.children:
        parts.append(emit_group(c, localized) if isinstance(c, Group) else emit_record(c, localized)[0])
    inner = b"".join(parts)
    return (b"GRUP" + struct.pack("<I", 24 + len(inner)) + g.label +
            struct.pack("<iHHHH", g.gtype, g.vc1, g.vc2, g.version, g.unk) + inner)


def emit(p):
    return emit_record(p.header, False)[0] + b"".join(emit_group(g, p.localized) for g in p.groups)


def count_records_and_groups(p):
    """HEDR numRecords as the engine/CK count it: every record and every group except the TES4 header."""
    def walk(g):
        n = 1
        for c in g.children:
            n += walk(c) if isinstance(c, Group) else 1
        return n
    return sum(walk(g) for g in p.groups)
