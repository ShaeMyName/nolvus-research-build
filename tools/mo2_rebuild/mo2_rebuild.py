"""RV-208 prep only: rebuild ModOrganizer.ini the way the Nolvus installer writes it (Vcc.Nolvus.Package.dll,
CreateModOrganizerIni + 9 x AddExecutable, decoded from the IL). Writes ONLY into C:/nolvus-research/backups/mo2_rebuild/.
Never touches C:/Nolvus."""
import os
import re
import struct

DLL = "C:/Nolvus/Vcc.Nolvus.Package.dll"
OUT = "C:/nolvus-research/backups/mo2_rebuild/"
INST = r"C:\Nolvus\Instances\Nolvus Awakening"          # InstancesData.xml <InstallPath>
STOCK = INST + r"\STOCK GAME"                              # InstancesData.xml <StockGame>
NAME = "Nolvus Awakening"                                  # InstancesData.xml <Name>

# --- the template, read byte-exact from the DLL's #US heap (the ldstr at IL 0x43FE)
b = open(DLL, "rb").read()
tk = struct.unpack_from("<I", b, 0x43FF)[0]
assert b[0x43FE] == 0x72 and tk >> 24 == 0x70
pe = struct.unpack_from("<I", b, 0x3C)[0]
nsec = struct.unpack_from("<H", b, pe + 6)[0]
optsz = struct.unpack_from("<H", b, pe + 20)[0]
opt = pe + 24
ddir = opt + (96 if struct.unpack_from("<H", b, opt)[0] == 0x10B else 112)
secs = [struct.unpack_from("<IIII", b, opt + optsz + i * 40 + 8) for i in range(nsec)]


def off(rva):
    for vs, va, rs, ro in secs:
        if va <= rva < va + max(vs, rs):
            return rva - va + ro


md = off(struct.unpack_from("<I", b, off(struct.unpack_from("<I", b, ddir + 14 * 8)[0]) + 8)[0])
vlen = struct.unpack_from("<I", b, md + 12)[0]
q = md + 16 + vlen + 2
n = struct.unpack_from("<H", b, q)[0]
q += 2
us = None
for _ in range(n):
    o, sz = struct.unpack_from("<II", b, q)
    q += 8
    e = b.index(b"\0", q)
    if b[q:e] == b"#US":
        us = md + o
    q = (e + 4) & ~3
o = us + (tk & 0xFFFFFF)
c = b[o]
L, o = (((c & 0x3F) << 8) | b[o + 1], o + 2) if c & 0xC0 == 0x80 else ((((c & 0x1F) << 24) | (b[o + 1] << 16) | (b[o + 2] << 8) | b[o + 3]), o + 4)
tpl = b[o:o + L - 1].decode("utf-16-le")
assert tpl.startswith("[General]\r\ngameName=Skyrim Special Edition") and tpl.endswith("[pluginBlacklist]\r\nsize=0")

# String.Format(tpl, Name, StockGame.Replace("\\", "\\\\"), (InstallDir + "\\MODS").Replace("\\", "/"))
ini = tpl.replace("{0}", NAME).replace("{1}", STOCK.replace("\\", "\\\\")).replace("{2}", (INST + "\\MODS").replace("\\", "/"))
assert "{" not in re.sub(r"@ByteArray\([^)]*\)|@Variant\([^)]*\)", "", ini)


def esc(p):
    return p.replace("\\", "\\\\")


def fwd(p):
    return p.replace("\\", "/")


# AddExecutable(mo2dir, arguments, binary, hide, ownicon, title, toolbar, workingDirectory), call order = index 1..9
MO2 = INST + r"\MO2"
SSE = INST + r"\TOOLS\SSE Edit"
NEM = INST + r"\MODS\mods\Nemesis Unlimited Behavior Engine\Nemesis_Engine"
BS = INST + r"\MODS\mods\BodySlide and Outfit Studio\CalienteTools\BodySlide"
EXES = [
    ('\\"' + esc(STOCK) + '\\"', fwd(MO2 + r"\NolvusLauncher.exe"), False, True, "Nolvus", True, fwd(MO2)),
    ("", fwd(STOCK + r"\skse64_loader.exe"), True, True, "SKSE", False, fwd(STOCK)),
    ("", fwd(STOCK + r"\SkyrimSE.exe"), True, True, "Skyrim Special Edition", False, fwd(STOCK)),
    ("", fwd(STOCK + r"\SkyrimSELauncher.exe"), True, True, "Skyrim Special Edition Launcher", False, fwd(STOCK)),
    ('\\"' + esc(STOCK) + '\\\\Data\\"', fwd(MO2 + r"\explorer++\Explorer++.exe"), True, True, "Explore Virtual Folder", False,
     fwd(MO2 + r"\explorer++")),
    ("", fwd(NEM + r"\Nemesis Unlimited Behavior Engine.exe"), False, True, "Nemesis Unlimited Behavior Engine", True, fwd(NEM)),
    ('-D:\\"' + esc(STOCK + r"\Data") + '\\" -c:\\"' + esc(INST) + '\\\\TOOLS\\\\SSE Edit\\\\Cache\\\\\\"',
     fwd(SSE + r"\SSEEdit.exe"), False, True, "xEdit", True, fwd(SSE)),
    ('-DontCache -D:\\"' + esc(STOCK + r"\Data") + '\\"', fwd(SSE + r"\SSEEditQuickAutoClean.exe"), False, True, "xEdit Cleaning",
     False, fwd(SSE)),
    ("", fwd(BS + r"\BodySlide x64.exe"), False, True, "Body Slide", True, fwd(BS)),
]
lines = ["", "[customExecutables]", "size=%d" % len(EXES)]
for i, (args, binary, hide, ownicon, title, toolbar, wd) in enumerate(EXES, 1):
    lines += ["%d\\arguments=%s" % (i, args), "%d\\binary=%s" % (i, binary), "%d\\hide=%s" % (i, str(hide).lower()),
              "%d\\ownicon=%s" % (i, str(ownicon).lower()), "%d\\steamAppID=" % i, "%d\\title=%s" % (i, title),
              "%d\\toolbar=%s" % (i, str(toolbar).lower()), "%d\\workingDirectory=%s" % (i, wd)]
ini += "\r\n".join(lines) + "\r\n"
os.makedirs(OUT, exist_ok=True)
open(OUT + "ModOrganizer.ini.rebuilt", "w", encoding="utf-8", newline="").write(ini)
missing = [e[1] for e in EXES if not os.path.exists(e[1])] + [p for p in (STOCK, INST + r"\MODS") if not os.path.isdir(p)]
print("bytes", len(ini.encode("utf-8")), "executables", len(EXES), "missing paths", missing)
