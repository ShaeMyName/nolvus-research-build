"""Block definitions (step 8 time plan §5, re-tier 2026-10-09). Moved out of U1: B-29 -> U2 (needs harness mode, D1 scopes
it to U2/U4/CF); REL-1 -> U2 (a modal question box would pause the game and stall U1; harness dismiss-ui there); B-17, B-30, TM-6, TM-7, TM-9, L-5, L-8 -> S-A (Shae); TM-3 -> CF block; EX-5/EX-6 -> U3 (need T0-M); D-4 -> soak (SK-10)."""
from block import block

block("U1", "T0", ["tests_b", "tests_tm_l", "tests_misc", "tests_ie"], [
    # harness smoke first (consumer proof (c)): the test mod events must arrive
    "H-1",
    # B, plain errands
    "B-1", "B-2", "B-4", "B-7", "B-10", "B-12", "B-14", "B-19", "B-21", "B-3", "B-3b", "B-6", "B-6b", "B-6c", "B-6d", "B-9", "B-16", "B-18",
    "B-22", "B-27", "B-28", "B-31",
    # IE patch (RV-68): drop-mode refusal undo; reload=True, before B-8
    "IE-R1",
    # B-8 kills F: last before a reload
    "B-8",
    "TM-1", "TM-2", "TM-4", "TM-5", "TM-8", "TM-10", "TM-11", "TM-12", "TM-13",
    "L-2", "L-1", "L-3", "L-4", "L-6", "L-7", "L-10", "L-9",
    "D-1", "D-2",
    "Q-1", "Q-2", "Q-3", "Q-4", "Q-5", "Q-6", "Q-7", "Q-8",
    "REL-2", "REL-3",
    "CS-20", "CS-21", "CS-22", "RS-1", "RS-4", "RS-6", "RS-8",
    "K-1", "K-2", "K-3", "X-1", "X-2", "X-3", "X-4", "X-7", "X-8", "CS-12",
    # B, time-accelerated (game-clock timeouts, x1000). Moved to the end 2026-10-10 (reviewer): Whiterun guards attacked the
    # player and Uthgerd 2 s after the first player.moveto following B-5's x1000 window (U1 run 16, 14:49:54), with no hit,
    # crime or combat line before it; until the cause is traced these run after everything else.
    "B-5", "B-11", "B-13", "B-15", "B-23", "B-24", "B-25", "B-26",
    # churns saves: always last
    "B-20",
], est={"B": 80, "TM/L": 72, "D/Q/REL/CS/RS/K/X/EX": 72}, fixed={"B-20": 70},
   harness=True, voices=False, gamemaster=False)  # GM off (Shae 2026-10-10): no GM test in U1 (gamemaster_tests.md)   # no voices: text/state block (Shae 2026-10-10); D1 extended to U1 (Shae 2026-10-10): auto-clears the Timeline Mismatch box on every reload
# Unpadded estimates (time plan §5, re-tier §5): B ~2.5 h incl. B-20's 70 min; TM/L ~1.2 h; the rest ~1.2 h
# (D-4's 29 min moved to the soak). Used only for the live ETA; the pace factor corrects them as tests finish.

block("U2", "T0", ["tests_u2", "tests_u2_e", "tests_u2_wh", "tests_u2_len", "tests_u2_sc", "tests_u2_da", "tests_u2_ip", "tests_u2_misc", "tests_u2_nt"], [
    # harness API smoke first: every R5 test needs it
    "H-2",
    # witness emitter + perception scope (market)
    "WE-1", "WE-4", "WE-7", "WE-8", "W-1", "W-2", "W-3",
    # in-line actions and reaction counts
    "E-4", "E-5", "E-7", "E-8", "RE-3",
    # dialogue actions (inn, Arcadia's)
    "DA-1", "DA-3", "DA-4", "DA-5", "DA-6", "DA-8", "DA-2", "DA-7", "DA-9",
    # situational whisper + private flag (one room, one house); long watches last in the group
    "WH-1", "WH-3", "WH-4", "PV-4", "WH-5a", "WH-5b", "WH-6", "WH-7", "PV-1", "PV-2", "PV-3", "WH-2", "PV-5", "WH-8",
    # length tiers and discretion
    "LEN-1", "LEN-2", "LEN-3", "LEN-5", "LEN-6", "LEN-8", "SEC-3", "SEC-1", "SEC-2", "SEC-4",
    # scene stack: joins/leaves first, the three 20-reply scenes last (60 LLM calls)
    "SC-7", "SC-8", "SC-9", "SC-11", "SC-12", "SC-13", "SC-10", "SC-1", "SC-3", "SC-4", "SC-2", "SC-5", "SC-6",
    # notices (the per-decision audit runs after every test anyway)
    "NT-1", "NT-2",
    # equip-event audience, child addressed, storage
    "X-6", "CS-2", "T10-1", "X-9", "X-10", "X-11", "MA-1", "AZ-11", "T10-3", "T10-7", "T10-8",
    # intimacy profiles (mechanics only; feature switched on per test, T0 reload after each)
    "IP-7", "IP-1", "IP-2", "IP-3", "IP-4", "IP-6",
    # saves/reloads last before the block's end
    "IP-5", "T10-2", "LEN-4",
], est={"W/WE/E/RE": 45, "DA": 30, "WH/PV": 75, "LEN/SEC": 60, "SC": 70, "IP": 40, "H": 2},
   harness=True, voices=False, gamemaster=True)  # GameMaster stays on (several U2 checks are reaction-based; Shae 2026-10-10 'if unsure, keep it on')
# REVIEW_LOG RV-90 (5): the two voice-dependent tests run in a short voiced sub-block after U2, started only with
# >= 12 GB available (the voice server pushed the 31 GB machine to the edge on 10-10); memory gates stay on.
block("U2V", "T0", ["tests_u2", "tests_u2_e", "tests_u2_len"], ["H-2", "E-2", "LEN-7"],
      est={"H": 2, "E": 5, "LEN": 10}, harness=True, voices=True, gamemaster=True, launch_min_avail_gb=12.0)
# U2 written 2026-10-11 (RV-86): every U2 ID of the time plan has a test or a stub with its route.
