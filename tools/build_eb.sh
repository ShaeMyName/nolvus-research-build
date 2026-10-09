#!/usr/bin/env bash
# Compile the Errand Bridge scripts (TASK_C step 3). Same Caprica flags as BLD-1. Usage: build_eb.sh [script ...]
S='C:\nolvus-research\sdk'; CAP=/c/nolvus-research/tools/caprica-dl/x/Caprica.exe
FLAGS=(-g skyrim --allow-unknown-events 1 --skyrim-allow-unknown-events-on-non-native-class 1 --allow-local-use-before-decl 0 --ignorecwd -q -f "$S\TESV_Papyrus_Flags.flg")
IMP="$S\stubs;$S\vanilla_fixes;$S\skse;$S\papyrusutil;$S\po3;$S\skyrimnet;$S\vanilla_psc"
EB='C:\nolvus-research\build\src\errandbridge\Source\Scripts'
DEP='C:\nolvus-research\build\src\relationships\src\scripts;C:\nolvus-research\repos\SkyrimNet-Relationships\src\scripts;C:\nolvus-research\repos\maras\Scripts\Source;C:\nolvus-research\build\src\intelengine\Source\Scripts;C:\nolvus-research\sdk\ie_roundtrip\src;C:\nolvus-research\nff\psc;C:\nolvus-research\build\stubs'
SA='C:\Nolvus\Instances\Nolvus Awakening\MODS\mods\SeverActions\Source\Scripts'
cd /c/nolvus-research/build/src/errandbridge/Source/Scripts
list=("$@"); [ ${#list[@]} -eq 0 ] && list=(IEB_Main IEB_PlayerAlias IEB_NFFLib IEB_SALib IEB_RankSync)
for f in "${list[@]}"; do
  "$CAP" "${FLAGS[@]}" -o 'C:\nolvus-research\build\bin\eb' -i "$EB;$DEP;$IMP;$SA" $f.psc 2>&1 | grep -vE "^Importing|^Imported|W7000|W1004"
  echo "== $f exit ${PIPESTATUS[0]}"
done
