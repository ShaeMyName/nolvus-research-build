"""Sandbox stand-in for play_test_profile.ps1 (selftest_swap.py only): starts the fake game detached and returns at once,
like a moshortcut launch that returns early. argv: <fake game exe> <seconds it runs; 0 = never start>."""
import subprocess
import sys
exe, secs = sys.argv[1], int(sys.argv[2])
if secs > 0:
    subprocess.Popen([exe, "-n", str(secs + 1), "127.0.0.1"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                     creationflags=0x00000008 | 0x00000200)
