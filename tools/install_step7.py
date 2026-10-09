"""TASK_C step 7: one install of everything into the test profile "SkyrimNet Test" (MO2 closed). Copies build outputs
into MO2 mod folders, edits modlist/plugins/loadorder byte-safely (CRLF), verifies every copy by hash, and writes
build/out/install_step7.json. Never touches the "Nolvus Awakening" profile, STOCK GAME, or any third-party mod's files.
Usage: install_step7.py [--dry]"""
import hashlib, json, os, shutil, subprocess, sys, time

B = "C:/nolvus-research/build/"
INST = "C:/Nolvus/Instances/Nolvus Awakening/MODS/"
MODS = INST + "mods/"
PROF = INST + "profiles/SkyrimNet Test/"
DRY = "--dry" in sys.argv
EXT = "SKSE/Plugins/SkyrimNet/external/"

# (mod folder, [(source, destination relative to the mod)])
def layer(src_dir, layer_id):
    root = B + "layers/" + src_dir + "/" + EXT + layer_id + "/"
    out = []
    for d, _, files in os.walk(root):
        for f in files:
            full = os.path.join(d, f).replace("\\", "/")
            out.append((full, EXT + layer_id + "/" + full[len(root):]))
    return out

PLAN = [
    ("Errand Bridge", [(B + "out/ErrandBridge.esp", "ErrandBridge.esp")] +
     [(B + "bin/eb/" + f, "Scripts/" + f) for f in sorted(os.listdir(B + "bin/eb"))] +
     layer("errandbridge", "ieb.errandbridge") +
     [(B + "data/custom_followers.json", "SKSE/Plugins/ErrandBridge/custom_followers.json")]),
    ("IE NoWipe + Dispatch Guard", [(B + "bin/patched/" + f, "Scripts/" + f) for f in sorted(os.listdir(B + "bin/patched"))] +
     [(B + "out/ErrandBridge/quest_integrity.json", "SKSE/Plugins/ErrandBridge/quest_integrity.json")]),
    ("SceneControls", [(B + "out/SceneControls.esp", "SceneControls.esp"),
                       (B + "bin/sc_bld4_full/IEB_SceneMain.pex", "Scripts/IEB_SceneMain.pex"),      # BLD-4 variant for the sitting
                       (B + "bin/sc/IEB_BeastFormHook.pex", "Scripts/IEB_BeastFormHook.pex"),
                       (B + "bin/sc/IEB_SceneActions.pex", "Scripts/IEB_SceneActions.pex")]),
    ("Lucienne - Private (TEST STUB)", [(B + "out/Lucienne.esl", "Lucienne.esl")] +
     [(B + "bin/luc/" + f, "Scripts/" + f) for f in sorted(os.listdir(B + "bin/luc"))] +
     layer("lucienne-test", "shae.lucienne")),
    ("SkyrimNet Relationships - Private Patch", [(B + "bin/rel_patched/" + f, "Scripts/" + f) for f in sorted(os.listdir(B + "bin/rel_patched"))]),
    ("SkyrimNet - Dialogue Actions Conduct", layer("dialogue-actions", "shae.dialogue-actions")),
    ("SkyrimNet - Privacy Overrides", layer("privacy-overrides", "shae.privacy-overrides")),
    ("SkyrimNet - Scene Text", layer("scene-text", "shae.scene-text")),
    ("SkyrimNet - Child Safety", layer("child-safety", "shae.child-safety")),
    ("SkyrimNet - Discretion", layer("discretion", "shae.discretion")),
    ("SkyrimNet - Marriage", layer("marriage", "shae.marriage")),
    ("Errand Bridge - Test Harness", [(B + "out/ErrandBridgeTest.esp", "ErrandBridgeTest.esp")] +
     [(B + "bin/harness/" + f, "Scripts/" + f) for f in sorted(os.listdir(B + "bin/harness"))]),
    ("MARAS Config", [(B + "out/PackageOverrides.ini", "SKSE/Plugins/PackageOverrides.ini")]),
]
EXISTING = {"Errand Bridge", "IE NoWipe + Dispatch Guard", "SceneControls", "Lucienne - Private (TEST STUB)", "MARAS Config"}
NEW_MODS = [m for m, _ in PLAN if m not in EXISTING]       # inserted after the Lucienne stub, in this order (top = highest)


def sha(p):
    return hashlib.sha256(open(p, "rb").read()).hexdigest()


def running():
    out = subprocess.run(["tasklist"], capture_output=True, text=True).stdout.lower()
    return [n for n in ("modorganizer.exe", "skyrimse.exe", "skse64_loader.exe") if n in out]


def edit_list(name, fn):
    p = PROF + name
    b = open(p, "rb").read()
    assert b"\r\n" in b, name + " is not CRLF"
    lines = fn(b.split(b"\r\n"))
    if not DRY:
        open(p, "wb").write(b"\r\n".join(lines))


def main():
    r = running()
    if r:
        sys.exit("ABORT: running: " + ", ".join(r))
    ml = open(PROF + "modlist.txt", "rb").read().split(b"\r\n")
    assert b"-Azura Test Stubs (test only)" in ml, "Azura Test Stubs must be disabled before install"
    for m, files in PLAN:
        for src, _ in files:
            assert os.path.exists(src), src
    if not DRY:
        ts = time.strftime("%Y%m%d-%H%M%S")
        for f in ("modlist.txt", "plugins.txt", "loadorder.txt"):
            shutil.copy(PROF + f, "C:/nolvus-research/backups/SkyrimNet_Test_%s_%s" % (f, ts))
        pk = MODS + "MARAS Config/SKSE/Plugins/PackageOverrides.ini"
        shutil.copy(pk, "C:/nolvus-research/backups/MARAS_Config_PackageOverrides.ini_%s" % ts)
    manifest = {}
    for m, files in PLAN:
        for src, rel in files:
            dst = MODS + m + "/" + rel
            if not DRY:
                os.makedirs(os.path.dirname(dst), exist_ok=True)
                shutil.copy2(src, dst)
                assert sha(src) == sha(dst), dst
            manifest[m + "/" + rel] = sha(src)[:16]

    def ins_mods(L):
        i = L.index(b"+Lucienne - Private (TEST STUB)")
        add = [b"+" + m.encode() for m in NEW_MODS if b"+" + m.encode() not in L]
        return L[:i + 1] + add + L[i + 1:]
    edit_list("modlist.txt", ins_mods)
    edit_list("plugins.txt", lambda L: L if b"*ErrandBridgeTest.esp" in L else
              L[:L.index(b"*Lucienne.esl") + 1] + [b"*ErrandBridgeTest.esp"] + L[L.index(b"*Lucienne.esl") + 1:])
    edit_list("loadorder.txt", lambda L: L if b"ErrandBridgeTest.esp" in L else
              L[:L.index(b"Lucienne.esl") + 1] + [b"ErrandBridgeTest.esp"] + L[L.index(b"Lucienne.esl") + 1:])
    if not DRY:
        json.dump(manifest, open(B + "out/install_step7.json", "w"), indent=1)
    print("%s: %d files into %d mods (%d new: %s)" % ("DRY" if DRY else "INSTALLED", len(manifest), len(PLAN),
                                                     len(NEW_MODS), ", ".join(NEW_MODS)))


main()
