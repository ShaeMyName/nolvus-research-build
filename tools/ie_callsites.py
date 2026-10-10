"""BLD-2 / step-0 call-site comparison for Papyrus .pex (Champollion 1.3.2 -a assembly).
Usage: ie_callsites.py <A.pex> <B.pex> [--label A B] [--asm-out DIR]
Prints: function list differences (name, params, return, per state), object variables / properties differences,
and per-function call-site counts (callmethod / callstatic / callparent callee, lowercased) that differ.
Exit 0 always; 'IDENTICAL' printed when nothing differs."""
import os, re, subprocess, sys, tempfile, collections

CH = "C:/nolvus-research/tools/champollion-dl/Champollion.exe"


def disasm(pex, outdir=None):
    d = outdir or tempfile.mkdtemp()
    os.makedirs(d, exist_ok=True)
    sub = tempfile.mkdtemp(dir=d)
    subprocess.run([CH, "-a", sub, "-p", sub, pex], capture_output=True)
    asm = os.path.join(sub, os.path.splitext(os.path.basename(pex))[0] + ".pas")
    return open(asm, encoding="utf-8", errors="replace").read().splitlines()


def parse(lines):
    funcs = {}            # (state, name) -> (params tuple, return type)
    calls = collections.defaultdict(collections.Counter)   # (state,name) -> Counter(callee)
    seq = collections.defaultdict(list)
    variables, props = set(), set()
    state = None
    cur = None
    in_params = False
    params = []
    ret = None
    for ln in lines:
        s = ln.strip()
        m = re.match(r"\.state\s*(\S*)", s)
        if m and not s.startswith(".stateTable"):
            state = m.group(1) or "<auto>"
            continue
        m = re.match(r"\.variable\s+(\S+)\s+(\S+)", s)
        if m and cur is None:
            variables.add((m.group(1).lower(), m.group(2).lower()))
            continue
        m = re.match(r"\.property\s+(\S+)\s+(\S+)", s)
        if m and cur is None:
            props.add((m.group(1).lower(), m.group(2).lower()))
            continue
        m = re.match(r"\.function\s+(\S+)", s)
        if m:
            if state is None:   # property accessor functions: skip, covered by props
                cur = ("<prop>", m.group(1))
            else:
                cur = (state, m.group(1))
            params, ret = [], None
            continue
        if cur is None:
            continue
        if s.startswith(".return"):
            ret = s.split()[1].lower() if len(s.split()) > 1 else ""
        elif s.startswith(".paramTable"):
            in_params = True
        elif s.startswith(".endParamTable"):
            in_params = False
        elif in_params and s.startswith(".param"):
            p = s.split()
            params.append(p[2].lower() if len(p) > 2 else "")
        elif s.startswith(".endFunction"):
            if cur[0] != "<prop>":
                funcs[(cur[0], cur[1].lower())] = (tuple(params), ret)
            cur = None
        else:
            m = re.match(r"(callmethod|callstatic|callparent)\s+(\S+)(?:\s+(\S+))?", s)
            if m and cur[0] != "<prop>":
                op, a, b = m.groups()
                callee = (a + "." + b) if op == "callstatic" else a
                key = (cur[0], cur[1].lower())
                calls[key][callee.lower()] += 1
                seq[key].append(callee.lower())
    return dict(funcs=funcs, calls=calls, seq=seq, variables=variables, props=props)


def compare(pa, pb, la="A", lb="B"):
    A, B = parse(disasm(pa)), parse(disasm(pb))
    out, diff = [], False
    fa, fb = set(A["funcs"]), set(B["funcs"])
    out.append("functions: %s %d, %s %d" % (la, len(fa), lb, len(fb)))
    for k in sorted(fa - fb):
        out.append("  FUNC only in %s: %s.%s%s" % (la, k[0], k[1], A["funcs"][k])); diff = True
    for k in sorted(fb - fa):
        out.append("  FUNC only in %s: %s.%s%s" % (lb, k[0], k[1], B["funcs"][k])); diff = True
    for k in sorted(fa & fb):
        if A["funcs"][k] != B["funcs"][k]:
            out.append("  SIGNATURE %s.%s: %s -> %s" % (k[0], k[1], A["funcs"][k], B["funcs"][k])); diff = True
    for nm in ("props", "variables"):
        sa, sb = A[nm], B[nm]
        if sa != sb:
            diff = True
            for x in sorted(sa - sb):
                out.append("  %s only in %s: %s" % (nm.upper(), la, x))
            for x in sorted(sb - sa):
                out.append("  %s only in %s: %s" % (nm.upper(), lb, x))
    ta = sum(sum(c.values()) for c in A["calls"].values())
    tb = sum(sum(c.values()) for c in B["calls"].values())
    out.append("call sites: %s %d, %s %d" % (la, ta, lb, tb))
    for k in sorted(set(A["calls"]) | set(B["calls"])):
        ca, cb = A["calls"].get(k, collections.Counter()), B["calls"].get(k, collections.Counter())
        for callee in sorted(set(ca) | set(cb)):
            if ca[callee] != cb[callee]:
                fn = k[1] if k[0] == "<auto>" else k[0] + "." + k[1]
                out.append("  %-34s %-44s %3d -> %d" % (fn, callee, ca[callee], cb[callee])); diff = True
    # order check: same multiset per function but different order
    for k in sorted(set(A["seq"]) & set(B["seq"])):
        if A["calls"][k] == B["calls"][k] and A["seq"][k] != B["seq"][k]:
            out.append("  ORDER differs in %s.%s (same counts)" % k); diff = True
    out.append("IDENTICAL" if not diff else "DIFFERENT")
    return "\n".join(out), diff


if __name__ == "__main__":
    a, b = sys.argv[1], sys.argv[2]
    la, lb = "A", "B"
    if "--label" in sys.argv:
        i = sys.argv.index("--label"); la, lb = sys.argv[i + 1], sys.argv[i + 2]
    print(compare(a, b, la, lb)[0])
