"""Lazy plugin index on top of espio: walks group/record headers, decodes a record only on demand."""
import os, struct, sys, zlib
sys.path.insert(0, r"C:\nolvus-research\build\tools")
import espio

GD = r"C:\nolvus-research\gamedata"


def plugin_path(name):
    for d in (os.path.join(GD, "active"), GD):
        p = os.path.join(d, name)
        if os.path.isfile(p):
            return p
    return None


class PIndex:
    def __init__(self, name):
        self.name = name
        self.path = plugin_path(name)
        if not self.path:
            raise FileNotFoundError(name)
        with open(self.path, "rb") as f:
            self.buf = f.read()
        hdr, o = espio.parse_record(self.buf, 0, False)
        self.header = hdr
        self.localized = bool(hdr.flags & 0x80)
        self.esl = bool(hdr.flags & 0x200)
        self.masters = [espio.zstr_dec(s.raw) for s in hdr.subs if s.sig == "MAST"]
        self.self_index = len(self.masters)
        self.recs = {}          # formid -> list of (sig, offset, parent_topic)
        self._walk(o, len(self.buf), None)

    def _walk(self, o, end, topic):
        buf = self.buf
        while o < end:
            sig = buf[o:o + 4]
            if sig == b"GRUP":
                size = struct.unpack_from("<I", buf, o + 4)[0]
                label = struct.unpack_from("<I", buf, o + 8)[0]
                gtype = struct.unpack_from("<i", buf, o + 12)[0]
                self._walk(o + 24, o + size, label if gtype == 7 else topic)
                o += size
            else:
                size, flags, formid = struct.unpack_from("<III", buf, o + 4)
                self.recs.setdefault(formid, []).append((sig.decode("latin1"), o, topic))
                o += 24 + size

    def full_id(self, local):
        return (self.self_index << 24) | (local & 0xFFFFFF)

    def record(self, formid):
        hits = self.recs.get(formid)
        if not hits:
            return None
        sig, off, topic = hits[0]
        rec, _ = espio.parse_record(self.buf, off, self.localized)
        rec.parent_topic = topic
        return rec

    def lookup_local(self, local):
        """Resolve a file-local (low 24 bit) id the way GetFormFromFile does: the plugin's own record.
        Returns (record or None, owner) where owner says whether it's the plugin's own form."""
        fid = self.full_id(local)
        r = self.record(fid)
        if r is not None:
            return r, "own"
        # fall back: an override of a master record with these low bits
        for mi in range(self.self_index):
            r = self.record((mi << 24) | (local & 0xFFFFFF))
            if r is not None:
                return r, "override_of:" + self.masters[mi]
        return None, None

    def by_sig(self, sig):
        for fid, hits in self.recs.items():
            for s, off, topic in hits:
                if s == sig:
                    yield fid, off


def edid(rec):
    for s in rec.subs:
        if s.sig == "EDID":
            try:
                return espio.zstr_dec(s.raw)
            except Exception:
                return s.raw.rstrip(b"\0").decode("cp1252", "replace")
    return None


def sub_u32(rec, sig):
    return [struct.unpack("<I", s.raw[:4])[0] for s in rec.subs if s.sig == sig and len(s.raw) >= 4]


_cache = {}


def get(name):
    if name not in _cache:
        _cache[name] = PIndex(name)
    return _cache[name]
