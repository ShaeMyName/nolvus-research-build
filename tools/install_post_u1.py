"""Post-U1 install (REVIEW_LOG RV-66-close, RV-67-upd4): copies only build outputs that differ from what is installed in
the four Task C mod folders below, after backing each replaced file up, verifies every copy by hash and updates
build/out/install_step7.json (sha256[:16], same keys and format). MO2 and the game must be closed. Never touches the
"Nolvus Awakening" profile, STOCK GAME, or any third-party mod's files. Usage: install_post_u1.py [--dry] [--only=x,y]
--only names pex/ESP files, or 'layer:<mod folder>' for a layer tree (e.g. --only=layer:SkyrimNet Test - SEC Bio).
A new test-only layer mod (NEW_TEST_MODS) is created and enabled in the TEST profile's modlist.txt only."""
import hashlib, json, os, shutil, subprocess, sys, time

B = "C:/nolvus-research/build/"
MODS = "C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/"
MANIFEST = B + "out/install_step7.json"
BACKUP = "C:/nolvus-research/backups/install_post_u1_%s/" % time.strftime("%Y%m%d-%H%M%S")
SETS = [("Errand Bridge", "bin/eb/"), ("IE NoWipe + Dispatch Guard", "bin/patched/"),
        ("SkyrimNet Relationships - Private Patch", "bin/rel_patched/"), ("Errand Bridge - Test Harness", "bin/harness/")]
LAYERS = [("Lucienne - Private (TEST STUB)", "layers/lucienne-test/"), ("SkyrimNet Test - SEC Bio", "layers/sectest/")]
# single files at a mod's root (2026-10-11: the regenerated test-harness plugin, B-22 package-watch quest 0x840)
FILES = [("Errand Bridge - Test Harness", "out/ErrandBridgeTest.esp", "ErrandBridgeTest.esp")]
# new test-only mod folders this tool may create, added to the TEST profile's modlist (never Nolvus Awakening)
NEW_TEST_MODS = {"SkyrimNet Test - SEC Bio"}
PROFILE_MODLIST = "C:/Nolvus/Instances/Nolvus Awakening/MODS/profiles/SkyrimNet Test/modlist.txt"
MODLIST_AFTER = "+Lucienne - Private (TEST STUB)"
DRY = "--dry" in sys.argv
# REVIEW_LOG RV-78: --only=a.pex,b.pex installs just those files (one change at a time between live runs)
ONLY = next((x.split("=", 1)[1].split(",") for x in sys.argv if x.startswith("--only=")), None)


def h(p):
    return hashlib.sha256(open(p, "rb").read()).hexdigest()[:16]


def running():
    out = subprocess.run(["tasklist"], capture_output=True, text=True).stdout.lower()
    return [n for n in ("modorganizer.exe", "skyrimse.exe", "skse64_loader.exe") if n in out]


def main():
    if running():
        sys.exit("ABORT: running: %s (MO2 and the game must be closed)" % running())
    raw = open(MANIFEST, "rb").read()
    crlf = b"\r\n" in raw
    man = json.loads(raw.decode("utf-8"))
    todo = []
    for mod, src in SETS:
        if not os.path.isdir(MODS + mod):
            sys.exit("ABORT: mod folder missing: " + mod)
        for f in sorted(os.listdir(B + src)):
            s, d, key = B + src + f, MODS + mod + "/Scripts/" + f, mod + "/Scripts/" + f
            if (not os.path.exists(d) or h(s) != h(d)) and (ONLY is None or f in ONLY):
                todo.append((s, d, key))
    for mod, src, name in FILES:
        s, d, key = B + src, MODS + mod + "/" + name, mod + "/" + name
        if (not os.path.exists(d) or h(s) != h(d)) and (ONLY is None or name in ONLY):
            todo.append((s, d, key))
    new_mods = []
    for mod, src in LAYERS:     # SkyrimNet layer trees, mirrored file by file (same paths as install_step7.py)
        if ONLY is not None and ("layer:" + mod) not in ONLY:
            continue
        if not os.path.isdir(MODS + mod):
            if mod not in NEW_TEST_MODS:
                sys.exit("ABORT: mod folder missing: " + mod)
            new_mods.append(mod)
        root = B + src
        for dp, _, files in os.walk(root):
            for f in files:
                s = os.path.join(dp, f).replace("\\", "/")
                rel = s[len(root):]
                d, key = MODS + mod + "/" + rel, mod + "/" + rel
                if not os.path.exists(d) or h(s) != h(d):
                    todo.append((s, d, key))
    for s, d, key in todo:
        print("%s %s -> %s (was %s)" % ("WOULD COPY" if DRY else "COPY", key, h(s), h(d) if os.path.exists(d) else "new"))
    if DRY or not todo:
        print("%d file(s)%s" % (len(todo), " (dry run)" if DRY else ""))
        return
    for s, d, key in todo:
        if os.path.exists(d):
            os.makedirs(os.path.dirname(BACKUP + key), exist_ok=True)
            shutil.copy2(d, BACKUP + key)
        os.makedirs(os.path.dirname(d), exist_ok=True)
        shutil.copy2(s, d)
        if h(d) != h(s):
            sys.exit("ABORT: hash mismatch after copy: " + key)
        man[key] = h(d)
    for mod in new_mods:        # enable the new test-only mod in the TEST profile (backup first; byte-safe line endings)
        ml = open(PROFILE_MODLIST, "rb").read()
        nl = b"\r\n" if b"\r\n" in ml else b"\n"
        lines = ml.split(nl)
        entry = ("+" + mod).encode("utf-8")
        if entry not in lines:
            os.makedirs(BACKUP, exist_ok=True)
            open(BACKUP + "SkyrimNet_Test_modlist.txt", "wb").write(ml)
            i = lines.index(MODLIST_AFTER.encode("utf-8")) + 1 if MODLIST_AFTER.encode("utf-8") in lines else 1
            lines.insert(i, entry)
            open(PROFILE_MODLIST, "wb").write(nl.join(lines))
            print("MODLIST +%s (TEST profile; backup in %s)" % (mod, BACKUP))
    text = json.dumps(man, indent=1, ensure_ascii=False)          # install_step7.py format: no final newline
    open(MANIFEST, "wb").write((text.replace("\n", "\r\n") if crlf else text).encode("utf-8"))
    bad = [k for k, v in man.items() if os.path.exists(MODS + k) and h(MODS + k) != v]
    print("INSTALLED %d file(s); backup %s; manifest entries not matching the installed file: %s"
          % (len(todo), BACKUP, bad or "none"))
    # REVIEW_LOG RV-102 follow-up (2): the array gate over every INSTALLED pex, Champollion under its cap; a decompile
    # failure FAILs and names the pex (Champollion choked on one of our own Caprica outputs on 2026-10-10)
    dirs = [MODS + m + "/Scripts" for m, _ in SETS if os.path.isdir(MODS + m + "/Scripts")]
    g = subprocess.run([sys.executable, B + "tools/array_none_gate.py"] + dirs, capture_output=True, text=True)
    tail = (g.stdout + g.stderr).strip().splitlines()[-6:]
    for l in tail:
        print("  gate| " + l)
    if g.returncode != 0:
        sys.exit("INSTALLED-PEX GATE FAILED (see above): a decompile failure or an array-vs-None compare in what is installed")
    print("INSTALLED-PEX GATE PASS")


if __name__ == "__main__":
    main()
