"""Runtime load index with Skyrim.ccc Creation Club plugins (present files only) after the DLCs, masters first.
Validate Dawn of Skyrim.esp == 0x61 (game). Read-only."""
import os, struct, sys
INST = "C:/Nolvus/Instances/Nolvus Awakening/"
PROF = INST + "MODS/profiles/SkyrimNet Test/"
mods = [l[1:].strip() for l in open(PROF + "modlist.txt", encoding="utf-8", errors="replace") if l.startswith("+")]
where = {}
for m in reversed(mods):
    d = INST + "MODS/mods/" + m
    if os.path.isdir(d):
        for f in os.listdir(d):
            if f.lower().endswith((".esp", ".esm", ".esl")):
                where[f.lower()] = d + "/" + f
for f in os.listdir(INST + "STOCK GAME/Data"):
    if f.lower().endswith((".esp", ".esm", ".esl")) and f.lower() not in where:
        where[f.lower()] = INST + "STOCK GAME/Data/" + f
implicit = ["Skyrim.esm", "Update.esm", "Dawnguard.esm", "HearthFires.esm", "Dragonborn.esm"]
ccc = [l.strip() for l in open(INST + "STOCK GAME/Skyrim.ccc", encoding="utf-8", errors="replace") if l.strip()]
ccc = [c for c in ccc if c.lower() in where]
act = {l[1:].strip().lower() for l in open(PROF + "plugins.txt", encoding="utf-8", errors="replace") if l.startswith("*")}
lo = [l.strip() for l in open(PROF + "loadorder.txt", encoding="utf-8", errors="replace") if l.strip() and not l.startswith("#")]
seen, order = set(), []
for p in implicit + ccc + [x for x in lo if x.lower() in act]:
    if p.lower() not in seen:
        seen.add(p.lower())
        order.append(p)


def flags(p):
    path = where.get(p.lower())
    if not path:
        return None
    with open(path, "rb") as fh:
        h = fh.read(24)
    return struct.unpack_from("<I", h, 8)[0] if len(h) == 24 else 0


info = [(p, flags(p)) for p in order]
is_master = lambda p, fl: p.lower().endswith((".esm", ".esl")) or (fl or 0) & 0x1
is_light = lambda p, fl: p.lower().endswith(".esl") or (fl or 0) & 0x200
for label, seq in (("as listed", info), ("masters first", [x for x in info if is_master(*x)] + [x for x in info if not is_master(*x)])):
    full, light, table = 0, 0, {}
    for p, fl in seq:
        if is_light(p, fl):
            table[p] = "FE%03X" % light
            light += 1
        else:
            table[p] = "%02X" % full
            full += 1
    print(label, "-> Dawn of Skyrim.esp", table.get("Dawn of Skyrim.esp"), "(game 61); CF =",
          [p for p, i in table.items() if i == "CF"], "; CC present:", len(ccc))
