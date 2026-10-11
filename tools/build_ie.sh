#!/usr/bin/env bash
# Compile IntelEngine scripts (patch B and later IE hunks). Same flags as BLD-1 / phase 0.
# Usage: build_ie.sh patched|baseline [script ...]
#   patched : sources build/src/intelengine (import order: patched src -> sdk/ie_roundtrip/src (= 3.5.1) -> sdk), out bin/patched
#   baseline: unpatched pinned 3.5.1 (repos/IntelEngine-Native-Gerk @36f02f4 Source/Scripts == sdk/ie_roundtrip/src), out bin/ie_baseline351
S='C:\nolvus-research\sdk'; CAP=/c/nolvus-research/tools/caprica-dl/x/Caprica.exe
FLAGS=(-g skyrim --allow-unknown-events 1 --skyrim-allow-unknown-events-on-non-native-class 1 --allow-local-use-before-decl 0 --ignorecwd -q -f "$S\TESV_Papyrus_Flags.flg")
IMP="$S\stubs;$S\vanilla_fixes;$S\skse;$S\papyrusutil;$S\po3;$S\skyrimnet;$S\vanilla_psc"
UP='C:\nolvus-research\repos\IntelEngine-Native-Gerk\Source\Scripts'
RT="$S\ie_roundtrip\src"
mode=$1; shift
case "$mode" in
  patched)  SRC='C:\nolvus-research\build\src\intelengine\Source\Scripts'; OUT='C:\nolvus-research\build\bin\patched'; INC="$SRC;$RT;$IMP";;
  baseline) SRC="$UP"; OUT='C:\nolvus-research\build\bin\ie_baseline351'; INC="$UP;$IMP";;
  *) echo "usage: build_ie.sh patched|baseline [script ...]"; exit 2;;
esac
mkdir -p "$(cygpath -u "$OUT")"
cd "$(cygpath -u "$SRC")"
list=("$@"); [ ${#list[@]} -eq 0 ] && list=(IntelEngine_Core IntelEngine_StoryEngine IntelEngine_Battle IntelEngine_Travel IntelEngine_NPCTasks)
rc=0
for f in "${list[@]}"; do
  "$CAP" "${FLAGS[@]}" -o "$OUT" -i "$INC" $f.psc 2>&1 | grep -vE "^Importing|^Imported|W7000|W1004"
  e=${PIPESTATUS[0]}; [ $e -ne 0 ] && rc=1
  echo "== $f exit $e"
done
# REVIEW_LOG RV-72 (a): post-build gate, fails on any array-vs-None compare in our pex (all our output folders)
B=/c/nolvus-research/build/bin
out=$(python /c/nolvus-research/build/tools/array_none_gate.py --baseline $B/patched=$B/ie_baseline351 --baseline $B/rel_patched=$B/rel_baseline $B/eb $B/harness $B/patched $B/rel_patched $B/luc $B/sc); g=$?
echo "$out" | tail -12
[ $g -ne 0 ] && { echo 'ARRAY_NONE_GATE FAIL: build rejected'; exit 1; }
exit $rc
