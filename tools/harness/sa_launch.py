"""Sitting A launch (sitting_SA_table.md "What Claude does before saying ready", steps 2, 5, 6, 7). Run after
sitting_sa_prep.py prep. Launches WITH voices through the swap launcher, loads T0 and stops at the Timeline Mismatch box
(harness mode is OFF, so nothing auto-clears it; Shae clicks Delete History). Prints OK/FAIL per check."""
import os, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
import game
from runner import Run


def main():
    if game.procs():
        sys.exit("FAIL game or MO2 running: %s" % sorted(game.procs()))
    print("harness mode off:", "OK" if not game.harness_mode() else "FAIL")
    print("GameMaster off:", "OK" if not game.gamemaster() else "FAIL")
    game.profile_snapshot()
    if not game.memory_ready(print, why="Sitting A launch"):
        sys.exit("FAIL memory gate")
    print("RAM available %.1f GB" % game.available_ram_gb())
    voices = "--no-voices" not in sys.argv   # Shae 2026-10-11 15:05: voiced sitting does not fit in 32 GB; no voices until the RAM upgrade
    if not game.launch(print, voices=voices):
        sys.exit("FAIL launch")
    r = Run("SA_LAUNCH")
    save = next((x.split("=", 1)[1] for x in sys.argv if x.startswith("--save=")), "T0")
    ok = game.load(r, save, quick=True)
    print("load %s:" % save, "in game" if ok else "loaded but paused (Timeline Mismatch box expected; Shae clicks Delete History)")


if __name__ == "__main__":
    main()
