#!/usr/bin/env bash
# Compile the Errand Bridge scripts (TASK_C step 3). Same Caprica flags as BLD-1. Usage: build_eb.sh [script ...]
# Import order: own sources; compile-only stubs (NFF controller header, OCR, IEB_BLD4Probe); patched Relationships;
# SeverActions' shipped sources (BEFORE Relationships' vendored, older SeverActionsNativeExt2 header); Relationships'
# vendored headers (full PapyrusExtender header first: RELV vendors a 28-line PO3_SKSEFunctions subset); MARAS; IntelEngine (patched first); then the sdk.
S='C:\nolvus-research\sdk'; CAP=/c/nolvus-research/tools/caprica-dl/x/Caprica.exe
FLAGS=(-g skyrim --allow-unknown-events 1 --skyrim-allow-unknown-events-on-non-native-class 1 --allow-local-use-before-decl 0 --ignorecwd -q -f "$S\TESV_Papyrus_Flags.flg")
IMP="$S\stubs;$S\vanilla_fixes;$S\skse;$S\papyrusutil;$S\po3;$S\skyrimnet;$S\vanilla_psc"
EB='C:\nolvus-research\build\src\errandbridge\Source\Scripts'
ST='C:\nolvus-research\build\stubs'
REL='C:\nolvus-research\build\src\relationships\src\scripts'
SA='C:\Nolvus\Instances\Nolvus Awakening\MODS\mods\SeverActions\Source\Scripts'
RELV='C:\nolvus-research\repos\SkyrimNet-Relationships\src\scripts'
MAR='C:\nolvus-research\repos\maras\Scripts\Source'
IE='C:\nolvus-research\build\src\intelengine\Source\Scripts;C:\nolvus-research\sdk\ie_roundtrip\src'
cd /c/nolvus-research/build/src/errandbridge/Source/Scripts
list=("$@"); [ ${#list[@]} -eq 0 ] && list=(IEB_RankSync IEB_IELib IEB_NFFLib IEB_SALib IEB_CFData IEB_CFLib IEB_EssLib IEB_Notice IEB_Main IEB_PlayerAlias)
for f in "${list[@]}"; do
  "$CAP" "${FLAGS[@]}" -o 'C:\nolvus-research\build\bin\eb' -i "$EB;$ST;$REL;$SA;$S\po3;$RELV;$MAR;$IE;$IMP" $f.psc 2>&1 | grep -vE "^Importing|^Imported|W7000|W1004"
  echo "== $f exit ${PIPESTATUS[0]}"
done
# REVIEW_LOG RV-72 (a): post-build gate, fails on any array-vs-None compare in our pex (all our output folders)
B=/c/nolvus-research/build/bin
out=$(python /c/nolvus-research/build/tools/array_none_gate.py --baseline $B/patched=$B/ie_baseline351 --baseline $B/rel_patched=$B/rel_baseline $B/eb $B/harness $B/patched $B/rel_patched $B/luc $B/sc); g=$?
echo "$out" | tail -12
[ $g -ne 0 ] && { echo 'ARRAY_NONE_GATE FAIL: build rejected'; exit 1; }
