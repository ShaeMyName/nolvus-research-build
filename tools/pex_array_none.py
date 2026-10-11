"""REVIEW_LOG RV-72 (a) fallback: a pure-Python (stdlib only) reader for Skyrim SE compiled Papyrus (.pex) that finds the
same array-vs-None compares as array_none_gate.py, for the pex that Champollion cannot decompile (IntelEngine_Battle.pex
crashes it with 0xC0000005, patched and stock 3.5.1 alike, 2026-10-11).
Format: UESP "Compiled Script File Format" (Skyrim: big-endian, magic 0xFA57C0DE, version 3.x, game id 1); no structs,
property groups or struct orders (those are Fallout 4 only, little-endian, and refused here).
Detection mirrors array_none_gate.hits() exactly, per function, with the type of an identifier looked up in the
function's params and locals (::temp locals included), then in the object's variables:
  cast    <array-typed dest> None                   (`arr == None` / `arr != None` compile to this, plus a cmp_eq)
  cmp_eq  <dest> <a> <b>  with one of a/b None (value type 0) and the other an array-typed identifier
  (`!=` is the same cmp_eq followed by `not`; it is reported on the cmp_eq and marked "!=" in the text)
Keys are (state, function) exactly as the gate builds them from Champollion's -a output: the empty state is "<auto>";
property get/set functions have state None and function "get"/"set".
Usage: pex_array_none.py [--dump] file.pex ...
  prints  HIT <pex> <object> <state>.<function> src:<line> ins:<n>  <instruction>   per finding, then a summary line.
  --dump  prints every object/function with params, locals and instructions (for checking the reader against
          Champollion -a output). Exit 0 = parsed (hits or not), 2 = a pex did not parse."""
import os, struct, sys, collections

OPS = [  # (name, fixed arg count, has varargs)
    ("nop", 0, 0), ("iadd", 3, 0), ("fadd", 3, 0), ("isub", 3, 0), ("fsub", 3, 0), ("imul", 3, 0), ("fmul", 3, 0),
    ("idiv", 3, 0), ("fdiv", 3, 0), ("imod", 3, 0), ("not", 2, 0), ("ineg", 2, 0), ("fneg", 2, 0), ("assign", 2, 0),
    ("cast", 2, 0), ("cmp_eq", 3, 0), ("cmp_lt", 3, 0), ("cmp_le", 3, 0), ("cmp_gt", 3, 0), ("cmp_ge", 3, 0),
    ("jmp", 1, 0), ("jmpt", 2, 0), ("jmpf", 2, 0), ("callmethod", 3, 1), ("callparent", 2, 1), ("callstatic", 3, 1),
    ("return", 1, 0), ("strcat", 3, 0), ("propget", 3, 0), ("propset", 3, 0), ("array_create", 2, 0),
    ("array_length", 2, 0), ("array_getelement", 3, 0), ("array_setelement", 3, 0), ("array_findelement", 4, 0),
    ("array_rfindelement", 4, 0)]
NONE, IDENT, STR, INT, FLOAT, BOOL = range(6)


class ParseError(Exception):
    pass


class Reader:
    def __init__(self, data):
        self.d, self.p = data, 0

    def take(self, fmt):
        n = struct.calcsize(fmt)
        if self.p + n > len(self.d):
            raise ParseError("truncated at byte %d (need %d more)" % (self.p, n))
        v = struct.unpack_from(fmt, self.d, self.p)
        self.p += n
        return v[0] if len(v) == 1 else v

    def u8(self):
        return self.take(">B")

    def u16(self):
        return self.take(">H")

    def u32(self):
        return self.take(">I")

    def wstr(self):
        n = self.u16()
        if self.p + n > len(self.d):
            raise ParseError("truncated string at byte %d" % self.p)
        s = self.d[self.p:self.p + n].decode("cp1252", "replace")
        self.p += n
        return s


class Pex:
    def __init__(self, path):
        self.path = path
        with open(path, "rb") as f:
            r = Reader(f.read())
        self.r = r
        magic = r.u32()
        if magic != 0xFA57C0DE:
            raise ParseError("bad magic 0x%08X (not a big-endian Skyrim pex)" % magic)
        self.major, self.minor, self.game = r.u8(), r.u8(), r.u16()
        if self.major != 3 or self.game != 1:
            raise ParseError("unsupported version %d.%d game %d (Skyrim is 3.x game 1)" % (self.major, self.minor, self.game))
        r.take(">Q")
        self.source, self.user, self.machine = r.wstr(), r.wstr(), r.wstr()
        self.strings = [r.wstr() for _ in range(r.u16())]
        self.debug = {}          # (object, state, function, type) -> [source line per instruction]
        if r.u8():
            r.take(">Q")
            for _ in range(r.u16()):
                obj, st, fn, ty = self.s(), self.s(), self.s(), r.u8()
                self.debug[(obj.lower(), st.lower(), fn.lower(), ty)] = [r.u16() for _ in range(r.u16())]
        self.userflags = [(self.s(), r.u8()) for _ in range(r.u16())]
        self.objects = [self.read_object() for _ in range(r.u16())]
        if r.p != len(r.d):
            raise ParseError("%d trailing bytes after the object table" % (len(r.d) - r.p))

    def s(self):
        i = self.r.u16()
        if i >= len(self.strings):
            raise ParseError("string index %d out of range (%d strings) at byte %d" % (i, len(self.strings), self.r.p))
        return self.strings[i]

    def value(self):
        t = self.r.u8()
        if t == NONE:
            return (NONE, None)
        if t in (IDENT, STR):
            return (t, self.s())
        if t == INT:
            return (t, self.r.take(">i"))
        if t == FLOAT:
            return (t, self.r.take(">f"))
        if t == BOOL:
            return (t, self.r.u8())
        raise ParseError("bad value type %d at byte %d" % (t, self.r.p - 1))

    def read_object(self):
        r = self.r
        o = {"name": self.s()}
        size = r.u32()
        start = r.p
        o["parent"], o["doc"], o["flags"], o["autostate"] = self.s(), self.s(), r.u32(), self.s()
        o["variables"] = [(self.s(), self.s(), r.u32(), self.value()) for _ in range(r.u16())]
        o["properties"], o["functions"] = [], []      # functions: (state, name, function dict)
        for _ in range(r.u16()):
            name, ty, _doc, _uf, fl = self.s(), self.s(), self.s(), r.u32(), r.u8()
            o["properties"].append((name, ty, fl))
            if fl & 4:
                self.s()                                     # auto var name
            else:
                if fl & 1:
                    o["functions"].append((None, "get", self.read_function(), name, 1))
                if fl & 2:
                    o["functions"].append((None, "set", self.read_function(), name, 2))
        for _ in range(r.u16()):
            st = self.s()
            for _ in range(r.u16()):
                fn = self.s()
                o["functions"].append((st, fn, self.read_function(), None, 0))
        # the object size field is not reliable across compilers: every pex here (Caprica and the stock 3.5.1 build) has
        # it little-endian and excluding itself (verified 2026-10-11 on all 50 pex in build/bin); UESP describes it
        # big-endian, including itself. Accept any of those readings and refuse anything else (= misparse).
        le = struct.unpack("<I", struct.pack(">I", size))[0]
        if r.p - start not in (size, size - 4, le, le - 4):
            raise ParseError("object %s: read %d bytes, header says %d" % (o["name"], r.p - start, size))
        return o

    def read_function(self):
        r = self.r
        f = {"ret": self.s(), "doc": self.s(), "userflags": r.u32(), "flags": r.u8()}
        f["params"] = [(self.s(), self.s()) for _ in range(r.u16())]
        f["locals"] = [(self.s(), self.s()) for _ in range(r.u16())]
        code = []
        for _ in range(r.u16()):
            op = r.u8()
            if op >= len(OPS):
                raise ParseError("bad opcode %d at byte %d" % (op, r.p - 1))
            name, n, var = OPS[op]
            args = [self.value() for _ in range(n)]
            if var:
                cnt = self.value()
                if cnt[0] != INT or cnt[1] < 0:
                    raise ParseError("bad vararg count %r at byte %d" % (cnt, r.p))
                args += [self.value() for _ in range(cnt[1])]
            code.append((name, args))
        f["code"] = code
        return f


def text(v):
    t, x = v
    if t == NONE:
        return "None"
    if t == STR:
        return '"%s"' % x.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n").replace("\t", "\\t")
    if t == BOOL:
        return "True" if x else "False"
    return str(x)


def hits(path):
    """{(state, function): [(instruction no, source line, text)]}, same keys and shape as array_none_gate.hits()."""
    out = collections.defaultdict(list)
    pex = Pex(path)
    for o in pex.objects:
        objtypes = {n.lower(): t.lower() for n, t, _f, _v in o["variables"]}
        for st, fn, f, prop, ftype in o["functions"]:
            types = {n.lower(): t.lower() for n, t in f["params"] + f["locals"]}
            ty = lambda v: types.get(v[1].lower(), objtypes.get(v[1].lower(), "")) if v[0] == IDENT else ""
            key = (None if prop else (st or "<auto>"), fn)
            dbg = pex.debug.get((o["name"].lower(), st.lower() if st else "", (prop or fn).lower(), ftype), [])
            code = f["code"]
            for i, (op, a) in enumerate(code):
                hit = False
                if op == "cast" and a[1][0] == NONE and ty(a[0]).endswith("[]"):
                    hit = True
                elif op == "cmp_eq" and NONE in (a[1][0], a[2][0]) and any(ty(v).endswith("[]") for v in a[1:3]):
                    hit = True
                if not hit:
                    continue
                s = "%s %s" % (op, " ".join(text(v) for v in a))
                if op == "cmp_eq" and i + 1 < len(code) and code[i + 1][0] == "not" and code[i + 1][1][1] == a[0]:
                    s += "  (!=)"
                where = o["name"] + ("" if not prop else " property " + prop)
                out[key].append((i, str(dbg[i]) if i < len(dbg) else "?", s, where))
    return out


def dump(path):
    pex = Pex(path)
    for o in pex.objects:
        print(".object %s %s" % (o["name"], o["parent"]))
        for n, t, _f, v in o["variables"]:
            print("  .variable %s %s = %s" % (n, t, text(v)))
        for st, fn, f, prop, _ty in o["functions"]:
            print("  .function %s %s%s" % ("<auto>" if st == "" else st, fn, (" (property %s)" % prop) if prop else ""))
            for n, t in f["params"]:
                print("    .param %s %s" % (n, t))
            for n, t in f["locals"]:
                print("    .local %s %s" % (n, t))
            for op, a in f["code"]:
                print("    %s %s" % (op, " ".join(text(v) for v in a)))


def main(argv):
    do_dump = "--dump" in argv
    files = [a for a in argv if a != "--dump"]
    bad = n = 0
    for p in files:
        try:
            if do_dump:
                dump(p)
                continue
            h = hits(p)
        except (ParseError, OSError, struct.error) as e:
            print("PARSE_FAIL %s: %s" % (os.path.basename(p), e))
            bad += 1
            continue
        for (st, fn), lst in sorted(h.items(), key=lambda kv: (str(kv[0][0]), kv[0][1])):
            for i, src, s, where in lst:
                print("HIT %s %s %s.%s src:%s ins:%d  %s" % (os.path.basename(p), where, st, fn, src, i, s))
                n += 1
    if not do_dump:
        print("PEX_ARRAY_NONE %s: %d pex, %d hits, %d unparsed" % ("FAIL" if bad else "OK", len(files), n, bad))
    return 2 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
