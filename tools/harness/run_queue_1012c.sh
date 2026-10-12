#!/usr/bin/env bash
# Queue 4, 2026-10-12 morning (after the Saffir fix + TestCtl GF window; U1 minus B-6,B-16 which passed). Was: night queue 01:3x, after the disk-full recovery: U1A remainder (incl. the 5 DISK-TAINTED IDs and the
# RV-210 resolver regression set B-1,B-4,TM-2,TM-4,D-1,REL-2), NT-4, RES-1, then U3-A
# (U3R Q-10; U3M GATE-1..4 on T0-M) and the U4 render/state tests. Each block logs separately; a block ABORT does not stop
# the queue (the launch guards still do: memory heartbeat, POOLGATE, free space).
cd /c/nolvus-research/build/tools/harness || exit 1
T=/c/nolvus-research/test_runs
echo "QUEUE4 start $(date +%T)"
python -u block.py U1 --only $(cat $T/U1A_rest2_ids.txt) > $T/block_U1A3_console.log 2>&1
echo "QUEUE4 U1A-rest rc=$? $(date +%T)"
python -u block.py U2SMOKE --only NT-4 > $T/block_U2_NT4_console.log 2>&1   # UPSTREAM_BUGS #18 fix (schedtasks)
echo "QUEUE4 U2-NT4 rc=$? $(date +%T)"
python -u block.py U2 --only RES-1 > $T/block_U2_RES1_console.log 2>&1   # §17b guard probes (RV-210); RES-2 waits for the TTS-on U2-A (RV-199)
echo "QUEUE4 U2-RES1 rc=$? $(date +%T)"
python -u block.py U3R --only Q-10 > $T/block_U3R_Q10_console.log 2>&1
echo "QUEUE4 U3R-Q10 rc=$? $(date +%T)"
python -u block.py U3M --only GATE-1,GATE-1b,GATE-2,GATE-3,GATE-4 > $T/block_U3M_GATE_console.log 2>&1
echo "QUEUE4 U3M-GATE rc=$? $(date +%T)"
python -u block.py U4 --only AZ-5,AZ-7,AZ-3 > $T/block_U4_render_console.log 2>&1
echo "QUEUE4 U4-render rc=$? $(date +%T)"
echo "QUEUE4 DONE $(date +%T)"
