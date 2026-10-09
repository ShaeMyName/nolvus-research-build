#!/usr/bin/env bash
# Compile the full SceneControls scripts (TASK_C step 5c). Same Caprica flags as BLD-1. Imports as build_eb.sh, since
# IEB_SceneMain calls the patched SNRom_Bridge (CONSUMING_MIN, IEB_QueueIntimacy). The sdk po3 headers go BEFORE
# Relationships' vendored, partial PO3_SKSEFunctions.psc (it lacks FindAllReferencesOfFormType). Usage: build_sc_full.sh [outdir]
S='C:\nolvus-research\sdk'; CAP=/c/nolvus-research/tools/caprica-dl/x/Caprica.exe
FLAGS=(-g skyrim --allow-unknown-events 1 --skyrim-allow-unknown-events-on-non-native-class 1 --allow-local-use-before-decl 0 --ignorecwd -q -f "$S\TESV_Papyrus_Flags.flg")
PO3="$S\po3"
IMP="$S\stubs;$S\vanilla_fixes;$S\skse;$S\papyrusutil;$S\po3;$S\skyrimnet;$S\vanilla_psc"
SC='C:\nolvus-research\build\src\scenecontrols\Source\Scripts'
ST='C:\nolvus-research\build\stubs'
REL='C:\nolvus-research\build\src\relationships\src\scripts'
SA='C:\Nolvus\Instances\Nolvus Awakening\MODS\mods\SeverActions\Source\Scripts'
RELV='C:\nolvus-research\repos\SkyrimNet-Relationships\src\scripts'
MAR='C:\nolvus-research\repos\maras\Scripts\Source'
EB='C:\nolvus-research\build\src\errandbridge\Source\Scripts'
IE='C:\nolvus-research\build\src\intelengine\Source\Scripts;C:\nolvus-research\sdk\ie_roundtrip\src'
OUT="${1:-C:\nolvus-research\build\bin\sc}"
mkdir -p "$(cygpath -u "$OUT")"
cd /c/nolvus-research/build/src/scenecontrols/Source/Scripts
for f in IEB_SceneMain IEB_BeastFormHook IEB_SceneActions; do
  "$CAP" "${FLAGS[@]}" -o "$OUT" -i "$SC;$ST;$REL;$SA;$PO3;$RELV;$MAR;$EB;$IE;$IMP" $f.psc 2>&1 | grep -vE "^Importing|^Imported|W7000|W1004"
  echo "== $f exit ${PIPESTATUS[0]}"
done
