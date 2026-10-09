"""Freeze-rule guard (spec §16.4): every script attached in a frozen shell must declare EXACTLY the properties the
shell's VMAD binds (names and order-insensitive set), no more and no fewer. Reads the shell plugin with espio and
the compiled .pex via Champollion's assembly. Usage: freeze_check.py <shell.esp> <pex dir>"""
import os, re, subprocess, sys, tempfile
sys.path.insert(0, os.path.dirname(__file__))
import espio as E

CH = "C:/nolvus-research/tools/champollion-dl/Champollion.exe"


def vmad_bindings(path):
    p = E.parse(open(path, "rb").read())
    out = {}
    for g in p.groups:
        for r in g.children:
            if isinstance(r, E.Group) or r.sig != "QUST":
                continue
            E.decode_record(r, False)
            for s in r.subs:
                if s.sig != "VMAD":
                    continue
                for sc in s.value["scripts"]:
                    out[sc["name"]] = {pr["name"] for pr in sc["props"]}
                for a in s.value.get("quest", {}).get("aliases", []):
                    for sc in a["scripts"]:
                        out[sc["name"]] = {pr["name"] for pr in sc["props"]}
    return out


def pex_properties(pex):
    d = tempfile.mkdtemp()
    subprocess.run([CH, "-a", d, "-p", d, pex], capture_output=True)
    asm = os.path.join(d, os.path.splitext(os.path.basename(pex))[0] + ".pas")
    props = set()
    for line in open(asm, encoding="utf-8", errors="replace"):
        m = re.match(r"\s*\.property\s+(\S+)\s", line)
        if m:
            props.add(m.group(1))
    return props


def main(shell, pexdir):
    ok = True
    for script, bound in sorted(vmad_bindings(shell).items()):
        pex = os.path.join(pexdir, script + ".pex")
        if not os.path.exists(pex):
            print("FAIL %s: no compiled script" % script)
            ok = False
            continue
        declared = pex_properties(pex)
        if {x.lower() for x in declared} != {x.lower() for x in bound}:
            print("FAIL %s: declared %s, shell binds %s" % (script, sorted(declared), sorted(bound)))
            ok = False
        else:
            print("ok   %s: %d properties, identical to the shell" % (script, len(bound)))
    print("FREEZE CHECK:", "PASS" if ok else "FAIL")
    return ok


if __name__ == "__main__":
    sys.exit(0 if main(sys.argv[1], sys.argv[2]) else 1)
