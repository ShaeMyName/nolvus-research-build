"""Block definitions (step 8 time plan §5, re-tier 2026-10-09). Moved out of U1: B-29 -> U2 (needs harness mode, D1 scopes
it to U2/U4/CF); B-17, B-30, TM-6, TM-7, TM-9, L-5, L-8 -> S-A (Shae); TM-3 -> CF block; D-4 -> soak (SK-10)."""
from block import block

block("U1", "T0", ["tests_b", "tests_tm_l", "tests_misc"], [
    # B, plain errands
    "B-1", "B-2", "B-4", "B-7", "B-10", "B-12", "B-14", "B-19", "B-21", "B-3", "B-3b", "B-6", "B-9", "B-16", "B-18",
    "B-22", "B-27", "B-28", "B-31",
    # B, time-accelerated (game-clock timeouts, x1000)
    "B-5", "B-11", "B-13", "B-15", "B-23", "B-24", "B-25", "B-26",
    # B-8 kills F: last before a reload
    "B-8",
    "TM-1", "TM-2", "TM-4", "TM-5", "TM-8", "TM-10", "TM-11", "TM-12", "TM-13",
    "L-2", "L-1", "L-3", "L-4", "L-6", "L-7", "L-10", "L-9",
    "D-1", "D-2",
    "Q-1", "Q-2", "Q-3", "Q-4", "Q-5", "Q-6", "Q-7", "Q-8",
    "REL-1", "REL-2", "REL-3",
    "CS-20", "CS-21", "CS-22", "RS-1", "RS-4", "RS-6", "RS-8",
    "K-1", "K-2", "K-3", "X-1", "X-2", "X-3", "X-4", "X-7", "X-8", "CS-12", "EX-5", "EX-6",
    # churns saves: always last
    "B-20",
])
