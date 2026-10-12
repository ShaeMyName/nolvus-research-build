#!/usr/bin/env bash
# Overnight queue 2026-10-11 (REVIEW_LOG RV-182 / RV-189): U2SMOKE -> U1 fixture re-check (setup-only, 9 IDs) -> U1 re-run
# (A subset, 40 IDs). Each block in its own log; the queue goes on to the next block whatever the previous verdict
# (a block ABORT is logged and the next block still starts; the memory guard and POOLGATE still stop launches).
cd /c/nolvus-research/build/tools/harness || exit 1
T=/c/nolvus-research/test_runs
echo "QUEUE start $(date +%T)"
python -u block.py U2SMOKE > $T/block_U2SMOKE_console.log 2>&1
echo "QUEUE U2SMOKE rc=$? $(date +%T)"
python -u block.py U1 --only B-18,L-4,Q-1,Q-3,Q-7,X-1,X-3,X-7,X-8 --setup-only > $T/block_U1fix_setup_console.log 2>&1
echo "QUEUE U1fix rc=$? $(date +%T)"
python -u block.py U1 --only $(cat $T/U1A_ids.txt) > $T/block_U1A_console.log 2>&1
echo "QUEUE U1A rc=$? $(date +%T)"
echo "QUEUE DONE $(date +%T)"
