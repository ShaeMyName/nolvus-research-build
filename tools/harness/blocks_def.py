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
    "WE-1", "WE-4", "WE-7", "WE-8", "W-1", "W-2", "W-3", "W-4",
    # in-line actions and reaction counts
    "E-4", "E-5", "E-7", "E-8", "RE-3",
    # dialogue actions (inn, Arcadia's)
    "DA-1", "DA-3", "DA-4", "DA-5", "DA-6", "DA-8", "DA-2", "DA-7",
    # situational whisper + private flag (one room, one house); long watches last in the group
    "WH-1", "WH-3", "WH-4", "PV-4", "WH-5a", "WH-5b", "WH-6", "WH-7", "PV-1", "PV-2", "PV-3", "WH-2", "PV-5", "WH-8",
    # length tiers and discretion
    "LEN-1", "LEN-2", "LEN-3", "LEN-5", "LEN-6", "LEN-8", "SEC-3", "SEC-1", "SEC-2", "SEC-4",
    # scene stack: joins/leaves first, the three 20-reply scenes last (60 LLM calls)
    "SC-7", "SC-8", "SC-9", "SC-11", "SC-12", "SC-13", "SC-10", "SC-1", "SC-3", "SC-4", "SC-2", "SC-5", "SC-6",
    # notices (the per-decision audit runs after every test anyway)
    "NT-1", "NT-2", "NT-4",
    # equip-event audience, child addressed, storage
    "X-6", "CS-2", "T10-1", "X-11", "MA-1", "T10-3", "T10-7", "T10-8",
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

# U3 "restarts + watches" (time plan §5 :380), written 2026-10-11 (tests_u3*.py). One time-plan block, five sub-blocks,
# run in U3_SEQUENCE order:
#  - a restart test closes/relaunches the game itself and ends on its block save with the normal config; block.py's
#    control session is stale after it, which is harmless only while no reload=True test follows in the same block, so
#    the restart groups (U3R, U3MR) are their own blocks, every test in them reload=False;
#  - block.py loads one save per block: T0 (U3R, U3G), T0-M (U3MR, U3M), T0-ENT4 (U3E, made in S-A);
#  - GameMaster off for U3 (DECISIONS:413), except U3G: X-9 and RE-2 are in block.GM_TESTS (X-9/X-10/RE-2 moved here
#    from U2 for their relaunches: REVIEW_LOG RV-91);
#  - harness=True everywhere: DA-9/MA-2/X-9/RE-2 need the /harness API, and every T0/T0-M reload needs the Timeline
#    Mismatch auto-clear (the D1 extension reason for U1). D1 does not name U3 yet: Shae to confirm (FOR_SHAE);
#  - acceleration: x100 only for MA-4+MA-5 (one 24-game-hour window) and ENT-4 (D3, TASK_C.md:424-428).
# E-1 is dropped (DECISIONS:423 D5). Stubs: CS-27 (child-safety ruling), Q-10 (b)-(d) (Q10_SWAP_APPROVED),
# RE-2 (RE2_WRITE_APPROVED); see the module docstrings.
U3_SEQUENCE = ["U3R", "U3MR", "U3M", "U3G", "U3E"]
block("U3R", "T0", ["tests_u3"], ["D-3", "EN-4", "CS-27", "Q-10"],
      fixed={"D-3": 14, "EN-4": 20, "CS-27": 1, "Q-10": 2}, harness=True, voices=False, gamemaster=False)
block("U3MR", "T0-M", ["tests_u3"], ["MA-7", "K-M2"],
      fixed={"MA-7": 15, "K-M2": 1}, harness=True, voices=False, gamemaster=False)
block("U3M", "T0-M", ["tests_u3", "tests_u3_m", "tests_u3_gate"], [
    "GATE-1", "GATE-1b", "GATE-2", "GATE-3", "GATE-4",        # RV-98 gate (tests_u3_gate.py); each reloads T0-M
    "MA-3", "MA-4", "MA-5",              # MA-4/MA-5: one x100 window of 24 game hours; reload after MA-5
    "MA-6", "K-M3",
    "RS-2", "RS-5", "RS-8d", "RS-10be",
    "DA-9",
    "MA-2a", "MA-2b",                    # the boxes are the pass, never dismissed: last, each followed by a reload
], fixed={"MA-3": 5, "MA-4": 17, "MA-5": 1, "MA-6": 8, "K-M3": 6, "RS-2": 2, "RS-5": 3, "RS-8d": 3, "RS-10be": 4,
          "DA-9": 5, "MA-2a": 4, "MA-2b": 4,
          "GATE-1": 3, "GATE-1b": 3, "GATE-2": 3, "GATE-3": 3, "GATE-4": 3}, harness=True, voices=False, gamemaster=False)
# U3G runs with GameMaster ON (X-9 and RE-2 are GameMaster-dependent): allowed under DECISIONS:412(2), REVIEW_LOG RV-100 (2)
block("U3G", "T0", ["tests_u3", "tests_u3_g"], ["X-9", "X-10", "RE-2"],
      fixed={"X-9": 30, "X-10": 1, "RE-2": 1}, harness=True, voices=False, gamemaster=True)
block("U3E", "T0-ENT4", ["tests_u3", "tests_u3_m"], ["ENT-4"],
      fixed={"ENT-4": 70}, harness=True, voices=False, gamemaster=False)

# Block E: essential followers (investigation/round10/essential_followers_tests.md; tests_ess.py, written 2026-10-11).
# The order is grouped by window table (ess_windows.json), and a table install needs the game and MO2 closed, so block E is
# run group by group by `python tests_ess.py run` (one `block.py E --only <group ids>` process per group, the table
# installed in between, original state restored at the end); `tests_ess.py plan` prints the groups. Every test also checks
# the installed table (INCONCLUSIVE on a mismatch), so a plain `block.py E` cannot give a false PASS. GROUPS (table):
#   EMPTY rows0 (everything else, kills last) | SYNTH0 (E-RA) | SYNTH1 (E-WIN-SYNTH) | SYNTH1A (E-WIN-SYNTHa) | NONE (E-TBL) | BAD (E-TBLb)
# E-CF needs the spoiler-free CF save and the private cast: it is also its own block E_CF (CF_SAVE placeholder). GM off: no
# GameMaster test; harness on for the Timeline Mismatch auto-clear on every T0 reload.
block("E", "T0", ["tests_ess"], [
    "E-NFF", "E-NFF2", "E-IMP", "E-IMP-ND", "E-IMP-F", "E-SA1", "E-SA2", "E-SAOPT1", "E-SAOPT2",
    "E-CASUAL-ENROLLED", "E-CASUAL-PLAIN", "E-CHILD", "E-RDO", "E-SHR", "E-DIS1", "E-DIS2", "E-OPT",
    "E-IE1", "E-IE2", "E-IE3", "E-SPAR", "E-REQ", "E-CF", "E-WIN", "E-K1", "E-K2", "E-K3",      # EMPTY
    "E-RA",                                                                                      # SYNTH0
    "E-WIN-SYNTH",                                                                               # SYNTH1
    "E-WIN-SYNTHa",                                                                              # SYNTH1A
    "E-TBL",                                                                                     # NONE
    "E-TBLb",                                                                                    # BAD
], est={"E": 110}, fixed={"E-IMP": 3, "E-IMP-F": 5, "E-SA2": 4, "E-SAOPT1": 5, "E-DIS1": 4, "E-DIS2": 5, "E-OPT": 5,
                          "E-CASUAL-ENROLLED": 6, "E-K3": 3, "E-TBL": 6, "E-TBLb": 6, "E-RDO": 1, "E-WIN": 1, "E-CF": 1},
      harness=True, voices=False, gamemaster=False)
block("E_CF", "T0-CF", ["tests_ess"], ["E-CF"], fixed={"E-CF": 45}, harness=True, voices=False, gamemaster=False)

# U4 "Azura" (time plan §3.7 and §5 :381; tests_azura.py, written 2026-10-11). SHAE AWAY FROM THE SCREEN AND THE SOUND for
# the whole of U4 (AZ-10: her answers must never reach Shae; the overlay shows them even without voices). Save T0; every
# test sets LUC_Active itself (console request, undone by each T0 reload). harness=True (D1 names U4), voices=False (no
# voice server: AZ-13's voice half is INCONCLUSIVE by design). GameMaster OFF for U4 (DECISIONS:414); AZ-6 and the stubs
# of AZ-4/AZ-9/AZ-12 are in block.GM_TESTS, so they run in U4G with GameMaster ON (DECISIONS:412(2), as U3G).
# AZ-10's judge terms and AZ-11's targets: build/private_out/ (gitignored), made by build/tools/gen_az10_judge_terms.py.
# AZ-11 runs here. U2's order still lists the tests_u2_misc stub ("written with the U4 group"); drop it from U2 once
# the reviewer agrees (a U2 process never imports tests_azura, so the two registrations never meet in one run).
U4_SEQUENCE = ["U4", "U4G"]
block("U4", "T0", ["tests_azura"], [
    "AZ-5", "AZ-7",                      # renders (Dusk on, no prayer), no reload
    "AZ-3",                              # save/load reset
    "AZ-13",                             # one prayer thought; voice half INCONCLUSIVE (no voices)
    "AZ-8",                              # 3 prayers, journal + digest, rollback load
    "AZ-10",                             # 10 spoiler probes, pass/fail per probe only
    "AZ-11",                             # blacklisted-quest dialogue (travels far): last before the stubs
    "AZ-1", "AZ-2",                      # stubs: Shae's S sittings
], fixed={"AZ-5": 3, "AZ-7": 4, "AZ-3": 6, "AZ-13": 4, "AZ-8": 14, "AZ-10": 22, "AZ-11": 15, "AZ-1": 1, "AZ-2": 1},
   harness=True, voices=False, gamemaster=False)
block("U4G", "T0", ["tests_azura"], ["AZ-6", "AZ-4", "AZ-9", "AZ-12"],
      fixed={"AZ-6": 6, "AZ-4": 1, "AZ-9": 1, "AZ-12": 1}, harness=True, voices=False, gamemaster=True)
# FF: friendly-fire coverage (REVIEW_LOG RV-142; tests_ff.py, aa0d40c). NFF No Player Damage to Teammates OFF vs ON.
block("FF", "T0", ["tests_ff"], ["FF-0", "FF-1", "FF-2", "FF-3", "FF-4"], est={"FF": 35}, harness=True, voices=False,
      gamemaster=False)
