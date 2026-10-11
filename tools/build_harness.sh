#!/usr/bin/env bash
# Compile harness E (TASK_C step 6): IEB_Watcher, IEB_TestCtl, IEB_SoakProbe. Same flags as BLD-1; imports as
# build_sc_full.sh plus the full Errand Bridge sources (IEB_Main, libs, IEB_CFData). Usage: build_harness.sh [script ...]
S='C:\nolvus-research\sdk'; CAP=/c/nolvus-research/tools/caprica-dl/x/Caprica.exe
FLAGS=(-g skyrim --allow-unknown-events 1 --skyrim-allow-unknown-events-on-non-native-class 1 --allow-local-use-before-decl 0 --ignorecwd -q -f "$S\TESV_Papyrus_Flags.flg")
PO3="$S\po3"
IMP="$S\stubs;$S\vanilla_fixes;$S\skse;$S\papyrusutil;$S\po3;$S\skyrimnet;$S\vanilla_psc"
H='C:\nolvus-research\build\src\harness\Source\Scripts'
EB='C:\nolvus-research\build\src\errandbridge\Source\Scripts'
ST='C:\nolvus-research\build\stubs'
REL='C:\nolvus-research\build\src\relationships\src\scripts'
SA='C:\Nolvus\Instances\Nolvus Awakening\MODS\mods\SeverActions\Source\Scripts'
RELV='C:\nolvus-research\repos\SkyrimNet-Relationships\src\scripts'
MAR='C:\nolvus-research\repos\maras\Scripts\Source'
IE='C:\nolvus-research\build\src\intelengine\Source\Scripts;C:\nolvus-research\sdk\ie_roundtrip\src'
OUT='C:\nolvus-research\build\bin\harness'
mkdir -p "$(cygpath -u "$OUT")"
cd /c/nolvus-research/build/src/harness/Source/Scripts
list=("$@"); [ ${#list[@]} -eq 0 ] && list=(IEB_Watcher IEB_TestCtl IEB_SoakProbe IEB_PkgWatch)
for f in "${list[@]}"; do
  python C:/nolvus-research/build/tools/champ_guard.py --max-mb 4096 --timeout 300 --min-avail 3 -- "$CAP" "${FLAGS[@]}" -o "$OUT" -i "$H;$EB;$ST;$REL;$SA;$PO3;$RELV;$MAR;$IE;$IMP" $f.psc 2>&1 | grep -vE "^Importing|^Imported|W7000|W1004"
  echo "== $f exit ${PIPESTATUS[0]}"
done
# REVIEW_LOG RV-72 (a): post-build gate, fails on any array-vs-None compare in our pex (all our output folders)
B=/c/nolvus-research/build/bin
out=$(python /c/nolvus-research/build/tools/array_none_gate.py --baseline $B/patched=$B/ie_baseline351 --baseline $B/rel_patched=$B/rel_baseline $B/eb $B/harness $B/patched $B/rel_patched $B/luc $B/sc); g=$?
echo "$out" | tail -12
[ $g -ne 0 ] && { echo 'ARRAY_NONE_GATE FAIL: build rejected'; exit 1; }
