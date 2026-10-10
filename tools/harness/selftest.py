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
sys.exit(0 if ok else 1)
