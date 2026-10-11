#!/usr/bin/env bash
# Compile the SceneControls shell (TASK_C step 5a). Same Caprica flags as BLD-1. Usage: build_sc.sh [outdir]
S='C:\nolvus-research\sdk'; CAP=/c/nolvus-research/tools/caprica-dl/x/Caprica.exe
FLAGS=(-g skyrim --allow-unknown-events 1 --skyrim-allow-unknown-events-on-non-native-class 1 --allow-local-use-before-decl 0 --ignorecwd -q -f "$S\TESV_Papyrus_Flags.flg")
IMP="$S\stubs;$S\vanilla_fixes;$S\skse;$S\papyrusutil;$S\po3;$S\skyrimnet;$S\vanilla_psc"
SRC='C:\nolvus-research\build\src\scenecontrols_shell'
ST='C:\nolvus-research\build\stubs'
OUT="${1:-C:\nolvus-research\build\bin\sc_shell}"
mkdir -p "$(cygpath -u "$OUT")"
cd /c/nolvus-research/build/src/scenecontrols_shell
for f in IEB_SceneMain IEB_BeastFormHook IEB_SceneActions; do
  python C:/nolvus-research/build/tools/champ_guard.py --max-mb 4096 --timeout 300 --min-avail 3 -- "$CAP" "${FLAGS[@]}" -o "$OUT" -i "$SRC;$ST;$IMP" $f.psc 2>&1 | grep -vE "^Importing|^Imported|W7000|W1004"
  rc=${PIPESTATUS[0]}; echo "== $f exit $rc"
  [ $rc -ne 0 ] && { echo "COMPILE FAIL: $f (build rejected; the old pex would stay in place)"; exit 1; }
done
# REVIEW_LOG RV-72 (a): post-build gate, fails on any array-vs-None compare in our pex (all our output folders)
B=/c/nolvus-research/build/bin
out=$(python /c/nolvus-research/build/tools/array_none_gate.py --baseline $B/patched=$B/ie_baseline351 --baseline $B/rel_patched=$B/rel_baseline $B/eb $B/harness $B/patched $B/rel_patched $B/luc $B/sc); g=$?
echo "$out" | tail -12
[ $g -ne 0 ] && { echo 'ARRAY_NONE_GATE FAIL: build rejected'; exit 1; }
