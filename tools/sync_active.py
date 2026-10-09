"""Refresh gamedata/active/ from the test profile's load order (read-only on C:/Nolvus).

Resolves each active plugin the way MO2's VFS does: the highest-priority enabled mod
(bottom of modlist.txt's left pane = top of the file) that has it at its root, else STOCK GAME/Data.
Copies only missing or changed files; writes gamedata/active/_loadorder.txt (base masters + plugins.txt order).
Prints counts only."""
import hashlib, os, shutil, sys

INST = "C:/Nolvus/Instances/Nolvus Awakening/"
PROFILE = sys.argv[1] if len(sys.argv) > 1 else "SkyrimNet Test"
OUT = "C:/nolvus-research/gamedata/active/"
BASE = ["Skyrim.esm", "Update.esm", "Dawnguard.esm", "HearthFires.esm", "Dragonborn.esm"]


def lines(p):
    return [l.rstrip("\r\n") for l in open(p, encoding="utf-8-sig")]


prof = INST + "MODS/profiles/" + PROFILE + "/"
mods = [l[1:] for l in lines(prof + "modlist.txt") if l.startswith("+")]  # top of file = highest priority
active = [l[1:] for l in lines(prof + "plugins.txt") if l.startswith("*")]

roots = {}  # lower-case plugin name -> path, first (highest-priority) mod wins
for m in mods:
    d = INST + "MODS/mods/" + m + "/"
    if not os.path.isdir(d):
        continue
    for f in os.listdir(d):
        if f.lower().endswith((".esp", ".esm", ".esl")):
            roots.setdefault(f.lower(), d + f)
data = INST + "STOCK GAME/Data/"
for f in os.listdir(data):
    if f.lower().endswith((".esp", ".esm", ".esl")):
        roots.setdefault(f.lower(), data + f)


def sha(p):
    h = hashlib.sha256()
    with open(p, "rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


have = {f.lower(): f for f in os.listdir(OUT) if not f.startswith("_")}
copied = same = 0
missing = []
for p in active:
    src = roots.get(p.lower())
    if not src:
        missing.append(p)
        continue
    old = have.pop(p.lower(), None)
    if old and os.path.getsize(OUT + old) == os.path.getsize(src) and sha(OUT + old) == sha(src):
        if old != p:
            os.replace(OUT + old, OUT + p)  # case fix only
        same += 1
        continue
    if old:
        os.remove(OUT + old)
    shutil.copyfile(src, OUT + p)
    copied += 1
stale = sorted(have.values())
for f in stale:
    os.remove(OUT + f)
with open(OUT + "_loadorder.txt", "w", encoding="utf-8", newline="\n") as fh:
    fh.write("\n".join(BASE + active) + "\n")
print("active plugins:", len(active), "| unchanged:", same, "| copied (new or changed):", copied,
      "| removed (no longer active):", len(stale), "| unresolved:", len(missing))
for m in missing:
    print("UNRESOLVED", m)
