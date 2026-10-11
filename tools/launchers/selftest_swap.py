"""Offline self-test of swap_launch.py in a SANDBOX (a temp folder; nothing under C:\\Nolvus, no game, no MO2).

A copy of ping.exe named IEBFakeGame.exe plays SkyrimSE.exe; fake_launch.py starts it detached and returns at once
(like a moshortcut launch that returns early).  Covers: normal exit, killed game process, killed launcher, hash-mismatch
refusal, store guard, died mid-swap / mid-copy-back / mid-restore, and a game that never appears.

    python selftest_swap.py            (about 2-3 minutes; prints PASS/FAIL per check, exit 0 only if all pass)
"""
import io
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time

HERE = os.path.dirname(os.path.abspath(__file__))
SWAP = os.path.join(HERE, "swap_launch.py")
FILES = ["SeverActions_Settings.json", "SeverActions_BioBlocks.json", "IntelEngine.ini"]
TEST, LUC = "SkyrimNet Test", "Lucienne"
FAKE = "IEBFakeGame.exe"
fails = []


def check(ok, what):
    print(("PASS  " if ok else "FAIL  ") + what, flush=True)
    if not ok:
        fails.append(what)


class Box:
    def __init__(self):
        self.root = tempfile.mkdtemp(prefix="swaptest_")
        j = lambda *a: os.path.join(self.root, *a)
        self.skse, self.profiles, self.backups, self.logs, self.base = j("SKSE"), j("profiles"), j("backups"), j("logs"), j("baseline")
        for d in (self.skse, self.profiles, self.backups, self.logs, self.base):
            os.makedirs(d)
        shutil.copyfile(os.path.join(os.environ["SystemRoot"], "System32", "ping.exe"), j(FAKE))
        self.fake = j(FAKE)
        w = lambda p, t: open(p, "w", newline="\n").write(t)
        w(os.path.join(self.skse, FILES[0]), '{"testSettings": true}\n')
        w(os.path.join(self.skse, FILES[1]), '{"bio": "test"}\n')
        w(os.path.join(self.skse, FILES[2]), "[General]\nDebugLevel=3\nSkyrimNetDbPath=\n")
        w(os.path.join(self.base, FILES[0]), '{"baseline": true}\n')
        w(os.path.join(self.base, FILES[1]), '{"bio": "baseline"}\n')
        import hashlib
        sums = ""
        for n in FILES[:2]:
            sums += "%s *%s\n" % (hashlib.sha256(open(os.path.join(self.base, n), "rb").read()).hexdigest(), n)
        w(os.path.join(self.base, "SHA256SUMS"), sums)

    def args(self, secs, extra=()):
        launch = json.dumps([sys.executable, os.path.join(HERE, "fake_launch.py"), self.fake, str(secs)])
        return [sys.executable, "-u", SWAP, "--skse-dir", self.skse, "--profiles-root", self.profiles, "--backups-dir", self.backups,
                "--logs-dir", self.logs, "--game-exe", FAKE, "--mo2-exe", "IEBFakeMO2.exe", "--loader-exe", "IEBFakeLoader.exe",
                "--poll", "1", "--settle", "2", "--appear-timeout", "30", "--no-game-grace", "4", "--lock-wait", "3",
                "--unattended", "--launch-cmd-json", launch] + list(extra)

    def run(self, extra, secs=6, env=None, wait=True):
        e = dict(os.environ)
        e.update(env or {})
        p = subprocess.Popen(self.args(secs, extra), env=e, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        if wait:
            out, _ = p.communicate(timeout=240)
            p.out = out
        return p

    def marker(self):
        d = {}
        pth = os.path.join(self.skse, "_ieb_owner.txt")
        if os.path.isfile(pth):
            for line in io.open(pth, encoding="utf-8"):
                if "=" in line and not line.startswith("#"):
                    k, v = line.rstrip("\n").split("=", 1)
                    d[k] = v
        return d

    def wait_state(self, state, t=60):
        t0 = time.time()
        while time.time() - t0 < t:
            if self.marker().get("state") == state:
                return True
            time.sleep(0.5)
        return False

    def read(self, d, n):
        p = os.path.join(d, n)
        return open(p, "rb").read() if os.path.isfile(p) else None

    def store(self, prof):
        return os.path.join(self.profiles, prof, "shared_skse")

    def same(self, a, b):
        return all(self.read(a, n) == self.read(b, n) for n in FILES)

    def mark(self, text):
        with open(os.path.join(self.skse, FILES[2]), "a", newline="\n") as f:
            f.write("; %s\n" % text)

    def has(self, d, text):
        b = self.read(d, FILES[2])
        return b is not None and text.encode() in b

    def kill_game(self):
        subprocess.run(["taskkill", "/F", "/IM", FAKE], capture_output=True)

    def game_up(self):
        return FAKE.lower() in subprocess.run(["tasklist"], capture_output=True, text=True).stdout.lower()


def main():
    b = Box()
    print("sandbox:", b.root)
    try:
        # S0 init (refuses until MO2 has made the profile folders)
        p = b.run(["--init", "--baseline-dir", b.base])
        check(p.returncode == 2 and not os.path.exists(b.store(LUC)), "S0 init refused while the profile folder is missing; nothing created")
        os.makedirs(os.path.join(b.profiles, LUC))
        os.makedirs(os.path.join(b.profiles, TEST))
        p = b.run(["--init", "--baseline-dir", b.base])
        check(p.returncode == 0, "S0 init rc 0")
        check(b.marker().get("state") == "CLEAN" and b.marker().get("owner") == TEST, "S0 marker CLEAN owner test")
        check(b.same(b.skse, b.store(TEST)), "S0 live == test store")
        check(b.read(b.store(LUC), FILES[0]) == b.read(b.base, FILES[0]), "S0 Lucienne store SA settings == baseline (8b assert)")
        p = b.run(["--status"])
        check(p.returncode == 0 and "STATUS OK" in p.out, "S0 status OK")

        # S1 Lucienne, normal exit (the game runs ~12 s so the in-session checks can happen)
        p = b.run(["--profile", LUC], secs=12, wait=False)
        check(b.wait_state("IN_USE"), "S1 marker IN_USE during the session")
        check(b.marker().get("owner") == LUC, "S1 marker owner Lucienne during the session")
        check(b.same(b.store(LUC), b.skse), "S1 live == Lucienne store during the session (swapped in)")
        b.mark("mark-S1-luc")
        out, _ = p.communicate(timeout=120)
        check(p.returncode == 0, "S1 rc 0")
        check(b.marker().get("state") == "CLEAN" and b.marker().get("owner") == TEST, "S1 marker CLEAN owner test after")
        check(b.has(b.store(LUC), "mark-S1-luc"), "S1 copy-back: Lucienne store has her mark")
        check(not b.has(b.store(TEST), "mark-S1-luc"), "S1 isolation: test store has no Lucienne mark")
        check(b.same(b.skse, b.store(TEST)), "S1 live == test store after (rest state)")
        check(not b.has(b.skse, "mark-S1-luc"), "S1 live has no Lucienne mark after")
        check(not os.path.exists(os.path.join(b.skse, "_ieb_swap.lock")), "S1 lock released")

        # S2 test profile, game process killed mid-session
        p = b.run(["--profile", "test"], secs=60, wait=False)
        check(b.wait_state("IN_USE"), "S2 IN_USE")
        t0 = time.time()
        while not b.game_up() and time.time() - t0 < 30:
            time.sleep(1)
        b.mark("mark-S2-test")
        time.sleep(4)            # let the launcher's poll see the game first (a real game lives for minutes)
        b.kill_game()
        out, _ = p.communicate(timeout=120)
        check(p.returncode == 0, "S2 rc 0 after a killed game")
        if p.returncode != 0:
            print(out[-1500:])
        check(b.has(b.store(TEST), "mark-S2-test"), "S2 copy-back ran after the kill: test store has the mark")
        check(not b.has(b.store(LUC), "mark-S2-test"), "S2 Lucienne store has no test mark")
        check(b.marker().get("state") == "CLEAN" and b.marker().get("owner") == TEST, "S2 marker CLEAN owner test")
        check(b.has(b.store(LUC), "mark-S1-luc"), "S2 Lucienne store still has S1 mark (persisted)")

        # S3 killed launcher: the wrapper dies when the game is up; the game goes on
        p = b.run(["--profile", LUC], secs=40, env={"IEB_SWAP_DIE_AT": "game_up"})
        check(p.returncode == 99, "S3 launcher died (hook)")
        check(b.marker().get("state") == "IN_USE", "S3 marker left IN_USE")
        check(os.path.exists(os.path.join(b.skse, "_ieb_swap.lock")), "S3 stale lock left behind")
        p = b.run(["--profile", TEST])
        check(p.returncode == 2 and ("running" in p.out), "S3 a new launch is refused while the game runs")
        b.mark("mark-S3-luc")
        p = b.run(["--profile", LUC, "--recover"])
        check(p.returncode == 2, "S3 --recover refused while the game is still running")
        b.kill_game()
        time.sleep(1)
        p = b.run(["--profile", LUC, "--recover"])
        check(p.returncode == 0, "S3 --recover rc 0 after the game is gone")
        check(b.has(b.store(LUC), "mark-S3-luc"), "S3 recovery copied her files back")
        check(not b.has(b.store(TEST), "mark-S3-luc"), "S3 isolation after recovery")
        check(b.marker().get("state") == "CLEAN" and b.same(b.skse, b.store(TEST)), "S3 CLEAN and live == test store")

        # S4 hash mismatch refusal (a file edited outside the launchers) and --reset-live
        b.mark("tamper")
        before = {n: b.read(b.skse, n) for n in FILES}
        p = b.run(["--profile", LUC], secs=6)
        check(p.returncode == 2 and "do not match the marker" in p.out, "S4 refused on a modified shared file")
        check(not b.game_up() and all(b.read(b.skse, n) == before[n] for n in FILES), "S4 nothing launched, nothing changed")
        p = b.run(["--reset-live"])
        check(p.returncode == 0 and b.same(b.skse, b.store(TEST)) and not b.has(b.skse, "tamper"), "S4 --reset-live restores the owner's copy")

        # S5 Lucienne store guard
        with open(os.path.join(b.store(LUC), FILES[2]), "ab") as f:
            f.write(b"; test data leaked into her store\n")
        p = b.run(["--profile", LUC], secs=6)
        check(p.returncode == 2 and "differs from the copy taken back" in p.out, "S5 refused: her store differs from the last copy-back")
        check(b.same(b.skse, b.store(TEST)) and b.marker().get("state") == "CLEAN", "S5 nothing changed")
        with open(os.path.join(b.store(LUC), FILES[2]), "rb") as f:
            raw = f.read()
        with open(os.path.join(b.store(LUC), FILES[2]), "wb") as f:
            f.write(raw.replace(b"; test data leaked into her store\n", b""))

        # S6 died while copying the stored files in
        p = b.run(["--profile", LUC], secs=6, env={"IEB_SWAP_DIE_AT": "after_first_copy_swap-in"})
        check(p.returncode == 99 and b.marker().get("state") == "SWAPPING", "S6 died mid swap-in, marker SWAPPING")
        if p.returncode != 99:
            print(p.out[-1500:])
        check(not b.same(b.skse, b.store(TEST)), "S6 live files are a mixture")
        p = b.run(["--profile", LUC, "--recover"])
        check(p.returncode == 0 and b.same(b.skse, b.store(TEST)) and b.marker().get("state") == "CLEAN" and b.marker().get("owner") == TEST,
              "S6 --recover undid the swap")

        # S7 died during copy-back, S8 died during restore (the game ran and exited)
        for tag, hook in (("S7", "in_copyback"), ("S8", "in_restore")):
            p = b.run(["--profile", LUC], secs=5, wait=False, env={"IEB_SWAP_DIE_AT": hook})
            check(b.wait_state("IN_USE"), tag + " IN_USE")
            b.mark("mark-%s-luc" % tag)
            out, _ = p.communicate(timeout=120)
            check(p.returncode == 99, tag + " died at " + hook)
            p = b.run(["--profile", LUC, "--recover"])
            check(p.returncode == 0 and b.has(b.store(LUC), "mark-%s-luc" % tag), tag + " --recover finished the copy-back")
            check(b.same(b.skse, b.store(TEST)) and b.marker().get("owner") == TEST and b.marker().get("state") == "CLEAN",
                  tag + " live == test store, marker CLEAN")
            check(not b.has(b.store(TEST), "mark-%s-luc" % tag), tag + " isolation")

        # S9 the game never appears
        p = b.run(["--profile", LUC], secs=0)
        check(p.returncode == 3, "S9 rc 3 when no game appeared")
        check(b.same(b.skse, b.store(TEST)) and b.marker().get("state") == "CLEAN", "S9 files and marker back to rest state")

        # S10 the round-trip script's own logic (pre / during / mark / check / refuse / unmark) against the sandbox
        rt = os.path.join(HERE, "roundtrip_swap_plan.py")
        sa = json.dumps(["--skse-dir", b.skse, "--profiles-root", b.profiles, "--backups-dir", b.backups, "--logs-dir", b.logs,
                         "--game-exe", FAKE, "--mo2-exe", "IEBFakeMO2.exe", "--loader-exe", "IEBFakeLoader.exe"])
        env = dict(os.environ, IEB_RT_DIR=os.path.join(b.root, "rt"))

        def rtc(*a):
            r = subprocess.run([sys.executable, rt, "--swap-args", sa] + [str(x) for x in a], capture_output=True, text=True, env=env)
            return r.returncode, r.stdout
        rc, out = rtc("pre")
        check(rc == 0, "S10 pre passes")
        if rc:
            print(out)
        for step, prof, kind in ((1, TEST, "normal"), (2, LUC, "normal"), (3, TEST, "kill"), (4, LUC, "normal"), (5, LUC, "launcher")):
            hook = {"IEB_SWAP_DIE_AT": "game_up"} if kind == "launcher" else None
            p = b.run(["--profile", prof], secs=60 if kind != "normal" else 14, wait=False, env=hook)
            rc, out = rtc("during", step)
            check(rc == 0, "S10 step %d during-checks" % step)
            if rc:
                print(out)
            time.sleep(3)
            rc, out = rtc("mark", step)
            check(rc == 0, "S10 step %d mark" % step)
            if kind == "kill":
                time.sleep(2)
                b.kill_game()
            if kind == "launcher":
                p.communicate(timeout=60)
                b.kill_game()
                time.sleep(1)
                r = b.run(["--profile", prof, "--recover"])
                check(r.returncode == 0, "S10 step 5 recover")
                prc = 0
            else:
                p.communicate(timeout=120)
                prc = p.returncode
            rc, out = rtc("check", step, "--rc", prc)
            check(rc == 0, "S10 step %d check passes" % step)
            if rc:
                print(out)
        rc, out = rtc("refuse")
        check(rc == 0, "S10 refuse-test passes")
        if rc:
            print(out)
        rc, out = rtc("unmark")
        check(rc == 0, "S10 unmark restores the pre-test hashes")
        if rc:
            print(out)
        # negative control: a leak the check must catch (test mark placed in Lucienne's store)
        b.mark("x")
        rc, out = rtc("check", 1, "--rc", 0)
        check(rc != 0, "S10 negative control: check 1 FAILS on a wrong state")
        subprocess.run([sys.executable, SWAP, "--skse-dir", b.skse, "--profiles-root", b.profiles, "--backups-dir", b.backups,
                        "--logs-dir", b.logs, "--game-exe", FAKE, "--mo2-exe", "IEBFakeMO2.exe", "--loader-exe", "IEBFakeLoader.exe",
                        "--reset-live"], capture_output=True)

        p = b.run(["--status"])
        check(p.returncode == 0, "final status OK")
    finally:
        b.kill_game()
        shutil.rmtree(b.root, ignore_errors=True)
    print("\nRESULT: %s" % ("ALL PASS" if not fails else "%d FAILED: %s" % (len(fails), "; ".join(fails))))
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
