"""Offline positive/negative controls for harness matchers (no game needed): python selftest.py"""
import sys
sys.path.insert(0, "..")
import tests_b

ok = True


def check(cond, what):
    global ok
    ok &= bool(cond)
    print(("PASS " if cond else "FAIL ") + what)


# B-16 (reviewer 2026-10-10): the move matcher must match a real move line, not only reject skips.
skip = "[14:18:53.847] [38748] [I] CellCatchup: skip Jenassa (000E1BA9) \u2014 WaitingForPlayer AV"
move = "[14:20:00.000] [38748] [I] CellCatchup: Moved 000E1BA9 (Jenassa) to player cell"
resume = "[14:20:00.000] [38748] [I] CellCatchup: 000E1BA9 (Jenassa) resumed follow (same cell)"
other = "[14:20:00.000] [38748] [I] CellCatchup: Moved 0001A675 (Carlotta Valentia) to player cell"
s, m = tests_b.sa_catchup_split("\n".join([skip]), "Jenassa")
check(len(s) == 1 and not m, "B-16: live wfp skip line is a skip, not a move")
s, m = tests_b.sa_catchup_split("\n".join([skip, move]), "Jenassa")
check(m == [move], "B-16: SA 'Moved ... to player cell' (DLL format) counts as a move")
s, m = tests_b.sa_catchup_split(resume, "Jenassa")
check(m == [resume], "B-16: SA 'resumed follow (same cell)' counts as a non-skip")
s, m = tests_b.sa_catchup_split(other, "Jenassa")
check(not s and not m, "B-16: another actor's move is ignored")
import runner
check(runner.CTL_FAILED.search("[IEB-TEST] DoorUse: ModEvent.Create failed"), "ctl: DoorUse create-failed line is a failure")
check(runner.CTL_FAILED.search("[IEB-TEST] DoorUse: no door"), "ctl: DoorUse no-door line is a failure")
check(not runner.CTL_FAILED.search("[IEB-TEST] DoorUse door=0x1A2B3C sent"), "ctl: a normal DoorUse line is not a failure")
import block
check(block.player_defeated("[10/10/2026 - 02:50:08PM] [SOS] Defeat Music: [MusicType <_MUSDefeatGeneric>]", ""), "defeat: SoS defeat line")
check(block.player_defeated("", "[2026-10-10 14:50:06.201] [14272] [info] [EnterBleedoutEventHandler.cpp:41] Enter bleedout event: 'Prisoner'"), "defeat: player bleedout")
check(not block.player_defeated("", "Enter bleedout event: 'Whiterun Guard'"), "defeat: an NPC's bleedout is not a player defeat")
check(block.player_defeated("", "[2026-10-10 14:49:54.210] [48460] [info] [CombatEventHandler.cpp:57] Combat event: 'Whiterun Guard' combat state changed to 'Combat' with target 'Prisoner'"), "defeat: guard combat on the player (early)")
check(not block.player_defeated("", "Combat event: 'Whiterun Guard' combat state changed to 'Combat' with target 'Bandit'"), "defeat: guard vs a bandit is not a player signal")
sys.exit(0 if ok else 1)
