#!/usr/bin/env bash
# Compile the patched and the unpatched Relationships scripts (TASK_C step 2). Same Caprica flags as BLD-1.
# Import order: own sources first; dependency headers next; sdk; SeverActions' shipped sources last (gap-filler only).
S='C:\nolvus-research\sdk'; CAP=/c/nolvus-research/tools/caprica-dl/x/Caprica.exe
FLAGS=(-g skyrim --allow-unknown-events 1 --skyrim-allow-unknown-events-on-non-native-class 1 --allow-local-use-before-decl 0 --ignorecwd -q -f "$S\TESV_Papyrus_Flags.flg")
IMP="$S\stubs;$S\vanilla_fixes;$S\skse;$S\papyrusutil;$S\po3;$S\skyrimnet;$S\vanilla_psc"
DEP='C:\nolvus-research\repos\SkyrimNet-Relationships\src\scripts;C:\nolvus-research\repos\maras\Scripts\Source;C:\nolvus-research\build\stubs'
SA='C:\Nolvus\Instances\Nolvus Awakening\MODS\mods\SeverActions\Source\Scripts'
build() { # $1 src dir (posix)  $2 src dir (win)  $3 out (win)
  for f in SNRom_Decorators SNRom_Bridge; do
    (cd "$1" && python C:/nolvus-research/build/tools/champ_guard.py --max-mb 4096 --timeout 300 --min-avail 3 -- "$CAP" "${FLAGS[@]}" -o "$3" -i "$2;$DEP;$IMP;$SA" $f.psc 2>&1 | grep -vE "^Importing|^Imported|W7000" ) ; echo "== $f -> $3"
  done
}
build /c/nolvus-research/build/src/relationships/src/scripts 'C:\nolvus-research\build\src\relationships\src\scripts' 'C:\nolvus-research\build\bin\rel_patched'
build /c/nolvus-research/build/upstream/relationships-2.0.1/src/scripts 'C:\nolvus-research\build\upstream\relationships-2.0.1\src\scripts' 'C:\nolvus-research\build\bin\rel_baseline'
# REVIEW_LOG RV-72 (a): post-build gate, fails on any array-vs-None compare in our pex (all our output folders)
B=/c/nolvus-research/build/bin
out=$(python /c/nolvus-research/build/tools/array_none_gate.py --baseline $B/patched=$B/ie_baseline351 --baseline $B/rel_patched=$B/rel_baseline $B/eb $B/harness $B/patched $B/rel_patched $B/luc $B/sc); g=$?
echo "$out" | tail -12
[ $g -ne 0 ] && { echo 'ARRAY_NONE_GATE FAIL: build rejected'; exit 1; }
