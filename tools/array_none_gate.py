"""REVIEW_LOG RV-72 (a): post-build gate. Fails on any array-vs-None comparison in our compiled Papyrus.
In the Skyrim VM `arr == None` / `arr != None` intermittently fails ("Cannot cast from None to Int[]") and corrupts
the temps of the expression; the safe form is `If arr` / `If !arr` (cast to Bool).
Signature in Champollion -a assembly: `cast ::tempN None` where ::tempN is an array-typed local, or a cmp_eq whose
operands are an array-typed variable and None.
Usage: array_none_gate.py [--baseline DIR=BASEDIR ...] DIR|file.pex ...
  A hit is FAIL unless --baseline gives the stock pex of the same name and the same function there has at least as many
  hits (stock upstream pattern, reported as UPSTREAM, not ours). Exit 1 on any FAIL."""
import os, re, sys, tempfile, subprocess, collections

import os as _os, sys as _sys
_sys.path.insert(0, _os.path.dirname(_os.path.abspath(__file__)))
CH = "C:/nolvus-research/tools/champollion-dl/Champollion.exe"
import champ_guard   # Job object: hard memory ceiling + timeout (2026-10-11 08:48 bugcheck)
CHAMP_MAX_MB, CHAMP_TIMEOUT = 3072, 120



def asm(pex):
    d = tempfile.mkdtemp()
    _rc, _why = champ_guard.run([CH, "-a", d, "-p", d, pex], max_mb=CHAMP_MAX_MB, timeout=CHAMP_TIMEOUT)   # 2026-10-11 bugcheck guard
    if _why != "ok":
        raise RuntimeError("Champollion %s on %s (capped at %d MB, %d s)" % (_why, pex, CHAMP_MAX_MB, CHAMP_TIMEOUT))
    p = os.path.join(d, os.path.splitext(os.path.basename(pex))[0] + ".pas")
    # REVIEW_LOG RV-74 (2): an empty or garbled decompile must fail, never pass silently
    lines = open(p, encoding="utf-8", errors="replace").read().splitlines() if os.path.exists(p) else []
    if not any(l.strip().startswith(".function ") for l in lines):
        raise DecompileError(pex)
    return lines


class DecompileError(Exception):
    pass


def hits(pex):
    """{(state, function): [(asm line no, source line, text)]}"""
    out = collections.defaultdict(list)
    objtypes, state, func, types, src = {}, None, None, {}, "?"
    for n, ln in enumerate(asm(pex), 1):
        s = ln.strip()
        m = re.match(r"\.state\s*(\S*)$", s)
        if m:
            state = m.group(1) or "<auto>"
            continue
        m = re.match(r"\.(variable|local|param)\s+(\S+)\s+(\S+)", s)
        if m:
            (objtypes if (m.group(1) == "variable" and func is None) else types)[m.group(2).lower()] = m.group(3).lower()
            continue
        m = re.match(r"\.function\s+(\S+)", s)
        if m:
            func, types = m.group(1), {}
            continue
        if s.startswith(".endFunction"):
            func = None
            continue
        m = re.match(r"; line (\d+)", s)
        if m:
            src = m.group(1)
            continue
        if func is None:
            continue
        ty = lambda v: types.get(v.lower(), objtypes.get(v.lower(), ""))
        m = re.match(r"cast\s+(\S+)\s+None\b", s)
        if m and ty(m.group(1)).endswith("[]"):
            out[(state, func)].append((n, src, s))
            continue
        m = re.match(r"cmp_(eq|ne)\s+\S+\s+(\S+)\s+(\S+)", s)
        if m and "None" in (m.group(2), m.group(3)) and any(ty(v).endswith("[]") for v in (m.group(2), m.group(3))):
            out[(state, func)].append((n, src, s))
    return out


def main(argv):
    base, targets = {}, []
    i = 0
    while i < len(argv):
        if argv[i] == "--baseline":
            d, b = argv[i + 1].split("=", 1)
            base[os.path.normcase(os.path.abspath(d))] = b
            i += 2
        else:
            targets.append(argv[i])
            i += 1
    pexes = []
    for t in targets:
        if t.lower().endswith(".pex"):
            pexes.append(t)
        else:
            pexes += [os.path.join(t, f) for f in sorted(os.listdir(t)) if f.lower().endswith(".pex")]
    fail = up = 0
    for p in pexes:
        try:
            h = hits(p)
        except DecompileError:
            print("FAIL %s: no decompiled .function (empty or garbled Champollion output)" % os.path.basename(p))
            fail += 1
            continue
        if not h:
            continue
        bdir = base.get(os.path.normcase(os.path.abspath(os.path.dirname(p))))
        bp = os.path.join(bdir, os.path.basename(p)) if bdir else None
        try:
            bh = hits(bp) if bp and os.path.exists(bp) else {}
        except DecompileError:
            print("FAIL %s: baseline did not decompile; stock hits cannot be excused" % os.path.basename(bp))
            fail += 1
            bh = {}
        for k, lst in sorted(h.items()):
            stock = len(bh.get(k, [])) >= len(lst)
            for n, src, s in lst:
                print("%s %s %s.%s src:%s asm:%d  %s" % ("UPSTREAM" if stock else "FAIL", os.path.basename(p), k[0], k[1],
                                                       src, n, s))
            if stock:
                up += len(lst)
            else:
                fail += len(lst)
    print("ARRAY_NONE_GATE %s: %d pex, %d ours, %d stock upstream" % ("FAIL" if fail else "PASS", len(pexes), fail, up))
    return 1 if fail else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
