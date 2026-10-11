"""Post-U1 install (REVIEW_LOG RV-66-close, RV-67-upd4): copies only build outputs that differ from what is installed in
the four Task C mod folders below, after backing each replaced file up, verifies every copy by hash and updates
build/out/install_step7.json (sha256[:16], same keys and format). MO2 and the game must be closed. Never touches the
"Nolvus Awakening" profile, STOCK GAME, or any third-party mod's files. Usage: install_post_u1.py [--dry]"""
import hashlib, json, os, shutil, subprocess, sys, time

B = "C:/nolvus-research/build/"
MODS = "C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/"
MANIFEST = B + "out/install_step7.json"
BACKUP = "C:/nolvus-research/backups/install_post_u1_%s/" % time.strftime("%Y%m%d-%H%M%S")
SETS = [("Errand Bridge", "bin/eb/"), ("IE NoWipe + Dispatch Guard", "bin/patched/"),
        ("SkyrimNet Relationships - Private Patch", "bin/rel_patched/"), ("Errand Bridge - Test Harness", "bin/harness/")]
LAYERS = [("Lucienne - Private (TEST STUB)", "layers/lucienne-test/")]
DRY = "--dry" in sys.argv


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
            if not os.path.exists(d) or h(s) != h(d):
                todo.append((s, d, key))
    for mod, src in LAYERS:     # SkyrimNet layer trees, mirrored file by file (same paths as install_step7.py)
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
    text = json.dumps(man, indent=1, ensure_ascii=False)          # install_step7.py format: no final newline
    open(MANIFEST, "wb").write((text.replace("\n", "\r\n") if crlf else text).encode("utf-8"))
    bad = [k for k, v in man.items() if os.path.exists(MODS + k) and h(MODS + k) != v]
    print("INSTALLED %d file(s); backup %s; manifest entries not matching the installed file: %s"
          % (len(todo), BACKUP, bad or "none"))


if __name__ == "__main__":
    main()
