#!/usr/bin/env bash
# Night queue part 2 (REVIEW_LOG quiet hours, 2026-10-11): waits for run_queue_1011.sh's "QUEUE DONE", then
# U3-A (U3R Q-10 with the approved swap; U3M GATE-1..4 on T0-M; Papyrus-side), then U4 render/state tests only
# (AZ-5, AZ-7, AZ-3). The prayer/LLM Azura tests (AZ-13, AZ-8, AZ-10, AZ-11) and U4G go to tomorrow's TTS-on blocks
# (eligibility warm-up starvation without TTS, REVIEW_LOG RV-199).
cd /c/nolvus-research/build/tools/harness || exit 1
T=/c/nolvus-research/test_runs
until grep -q "QUEUE DONE" $T/queue_1011.log 2>/dev/null; do sleep 30; done
echo "QUEUE2 start $(date +%T)"
python -u block.py U3R --only Q-10 > $T/block_U3R_Q10_console.log 2>&1
echo "QUEUE2 U3R-Q10 rc=$? $(date +%T)"
python -u block.py U3M --only GATE-1,GATE-1b,GATE-2,GATE-3,GATE-4 > $T/block_U3M_GATE_console.log 2>&1
echo "QUEUE2 U3M-GATE rc=$? $(date +%T)"
python -u block.py U4 --only AZ-5,AZ-7,AZ-3 > $T/block_U4_render_console.log 2>&1
echo "QUEUE2 U4-render rc=$? $(date +%T)"
echo "QUEUE2 DONE $(date +%T)"
