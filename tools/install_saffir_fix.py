"""REVIEW_LOG RV-195 / RV-196 trigger (crash 2026-10-12 08:04:19 names Saffir + 0xCF001957): TEST-only install of
build/out/IEB_SaffirPackageFix.esp (ESL-flagged .esp, RV-214b: never a .esl file, which loads in the master block) into a new mod folder "IEB Saffir Package Fix (TEST)", enabled in the TEST profile's
modlist.txt and placed LAST in its plugins.txt + loadorder.txt. Backups of the three lists first; byte-safe line endings;
read-back. MO2 and the game must be closed. Never touches the "Nolvus Awakening" profile. Usage: install_saffir_fix.py [--dry]"""
import hashlib, os, shutil, subprocess, sys, time

SRC = "C:/nolvus-research/build/out/IEB_SaffirPackageFix.esp"
MOD = "IEB Saffir Package Fix (TEST)"
ESL = "IEB_SaffirPackageFix.esp"
DEST = "C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/%s/%s" % (MOD, ESL)
PROF = "C:/Nolvus/Instances/Nolvus Awakening/MODS/profiles/SkyrimNet Test/"
BACKUP = "C:/nolvus-research/backups/saffir_fix_%s/" % time.strftime("%Y%m%d-%H%M%S")
DRY = "--dry" in sys.argv


def h(p):
    return hashlib.sha256(open(p, "rb").read()).hexdigest()


def lines_of(p):
    b = open(p, "rb").read()
    nl = b"\r\n" if b"\r\n" in b else b"\n"
    trail = b.endswith(nl)
    ls = b.split(nl)
    if trail:
        ls = ls[:-1]
    return b, nl, trail, ls


def main():
    out = subprocess.run(["tasklist"], capture_output=True, text=True).stdout.lower()
    run = [n for n in ("modorganizer.exe", "skyrimse.exe", "skse64_loader.exe") if n in out]
    if run:
        sys.exit("ABORT: running: %s (MO2 and the game must be closed)" % run)
    plan = {
        "modlist.txt": lambda ls: ls if ("+" + MOD).encode() in ls else
        ls[:1 if ls and ls[0].startswith(b"#") else 0] + [("+" + MOD).encode()] + ls[1 if ls and ls[0].startswith(b"#") else 0:],
        "plugins.txt": lambda ls: ls if ("*" + ESL).encode() in ls else ls + [("*" + ESL).encode()],
        "loadorder.txt": lambda ls: ls if ESL.encode() in ls else ls + [ESL.encode()],
    }
    new = {}
    for f, fn in plan.items():
        b, nl, trail, ls = lines_of(PROF + f)
        nls = fn(list(ls))
        new[f] = (b, nl.join(nls) + (nl if trail else b""), len(nls) - len(ls))
        print("%s: +%d line(s), %s, %s" % (f, len(nls) - len(ls), "CRLF" if nl == b"\r\n" else "LF",
                                           "final newline" if trail else "no final newline"))
    if DRY:
        print("DRY: nothing written")
        return
    os.makedirs(BACKUP, exist_ok=True)
    for f in plan:
        shutil.copy2(PROF + f, BACKUP + "SkyrimNet_Test_" + f)
        assert h(PROF + f) == h(BACKUP + "SkyrimNet_Test_" + f)
    os.makedirs(os.path.dirname(DEST), exist_ok=False)
    shutil.copy2(SRC, DEST)
    assert h(DEST) == h(SRC), "ESL hash mismatch"
    for f, (old, data, n) in new.items():
        if n:
            open(PROF + f, "wb").write(data)
        assert open(PROF + f, "rb").read() == data, "read-back mismatch " + f
    print("INSTALLED %s (sha256 %s) into %s; lists backed up in %s" % (ESL, h(DEST)[:16], MOD, BACKUP))
    for f in plan:
        b, nl, trail, ls = lines_of(PROF + f)
        pos = [i for i, l in enumerate(ls) if ESL.encode() in l or MOD.encode() in l]
        print("  read-back %s: %d lines, entry at line %s of %d, CRLF=%s" % (f, len(ls), [p + 1 for p in pos], len(ls),
                                                                           nl == b"\r\n"))


if __name__ == "__main__":
    main()
