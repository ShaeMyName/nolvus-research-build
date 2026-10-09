#!/usr/bin/env bash
# Compile Lucienne.esl's scripts (TASK_C step 5b). Same Caprica flags as BLD-1. Usage: build_luc.sh [outdir]
S='C:\nolvus-research\sdk'; CAP=/c/nolvus-research/tools/caprica-dl/x/Caprica.exe
FLAGS=(-g skyrim --allow-unknown-events 1 --skyrim-allow-unknown-events-on-non-native-class 1 --allow-local-use-before-decl 0 --ignorecwd -q -f "$S\TESV_Papyrus_Flags.flg")
IMP="$S\stubs;$S\vanilla_fixes;$S\skse;$S\papyrusutil;$S\po3;$S\skyrimnet;$S\vanilla_psc"
SRC='C:\nolvus-research\build\src\lucienne\Source\Scripts'
ST='C:\nolvus-research\build\stubs'
OUT="${1:-C:\nolvus-research\build\bin\luc}"
mkdir -p "$(cygpath -u "$OUT")"
cd /c/nolvus-research/build/src/lucienne/Source/Scripts
for f in LUC_Main LUC_PlayerAliasScript; do
  "$CAP" "${FLAGS[@]}" -o "$OUT" -i "$SRC;$ST;$IMP" $f.psc 2>&1 | grep -vE "^Importing|^Imported|W7000|W1004"
  echo "== $f exit ${PIPESTATUS[0]}"
done
