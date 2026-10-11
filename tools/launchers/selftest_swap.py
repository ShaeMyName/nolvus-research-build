"""Offline self-test of swap_launch.py in a SANDBOX (a temp folder; nothing under C:\\Nolvus, no game, no MO2).

A copy of ping.exe named IEBFakeGame.exe plays SkyrimSE.exe; fake_launch.py starts it detached and returns at once
(like a moshortcut launch that returns early).  Covers: normal exit, killed game process, killed launcher, hash-mismatch
refusal, store guard, died mid-swap / mid-copy-back / mid-restore, and a game that never appears.
Rest state (REVIEW_LOG RV-140): HER files are live at rest; a test launch swaps the test copies in and her files back after
the game exits; a cut-off earlier run is warned about and auto-recovered by the next launch; --init snapshots the test
files before overwriting them; the .bat wrappers use the absolute python path; the round-trip script's DB-inventory and
MCP proofs (with negative controls).
RV-150: her IntelEngine.ini gets DebugLevel=2 at --init (byte-safe, CRLF/BOM kept; --verify-mode 3; no key: untouched),
--adopt-live shows a key-level diff before it backs up and adopts, --assert-rest (marker CLEAN, owner Lucienne, live == her
store) and block.py's end-of-block call to it (only when the marker exists; FINDING row on failure).

    python selftest_swap.py            (about 3-4 minutes; prints PASS/FAIL per check, exit 0 only if all pass)
"""
import hashlib
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
    def __init__(self, ini=None):
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
        if ini is not None:
            open(os.path.join(self.skse, FILES[2]), "wb").write(ini)
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
    boxes = []
    b = Box()
    print("sandbox:", b.root)
    try:
        # S0 init (refuses until MO2 has made the profile folders)
        p = b.run(["--init", "--baseline-dir", b.base])
        check(p.returncode == 2 and not os.path.exists(b.store(LUC)), "S0 init refused while the profile folder is missing; nothing created")
        os.makedirs(os.path.join(b.profiles, LUC))
        os.makedirs(os.path.join(b.profiles, TEST))
        pre_live = {n: b.read(b.skse, n) for n in FILES}        # the test settings, as they are before init overwrites them
        pre_hash = {n: hashlib.sha256(pre_live[n]).hexdigest() for n in FILES}
        p = b.run(["--init", "--baseline-dir", b.base])
        check(p.returncode == 0, "S0 init rc 0")
        if p.returncode:
            print(p.out[-1500:])
        check(b.marker().get("state") == "CLEAN" and b.marker().get("owner") == LUC, "S0 marker CLEAN owner Lucienne (rest state)")
        check(all(b.read(b.store(TEST), n) == pre_live[n] for n in FILES), "S0 TEST store = the live files as they were BEFORE the overwrite")
        man = json.load(open(os.path.join(b.store(TEST), "manifest.json"), encoding="utf-8"))["files"]
        check(man == pre_hash, "S0 TEST store manifest records the pre-overwrite hashes")
        check(b.read(b.store(LUC), FILES[0]) == b.read(b.base, FILES[0]) and b.read(b.store(LUC), FILES[1]) == b.read(b.base, FILES[1]),
              "S0 Lucienne store SA files == baseline")
        check(b.read(b.skse, FILES[0]) == b.read(b.base, FILES[0]) and b.read(b.skse, FILES[1]) == b.read(b.base, FILES[1]),
              "S0 8b assert as written: live SA files == baseline (zero diff)")
        check(b.same(b.skse, b.store(LUC)), "S0 live == Lucienne store (rest state)")
        check(b.read(b.store(LUC), FILES[2]) == pre_live[FILES[2]].replace(b"DebugLevel=3", b"DebugLevel=2"),
              "S0 her IntelEngine.ini = the live copy with only DebugLevel=3 -> 2 (RV-150 (a))")
        check(b.read(b.store(TEST), FILES[2]) == pre_live[FILES[2]] and b"DebugLevel=3" in b.read(b.store(TEST), FILES[2]),
              "S0 the TEST store's ini keeps DebugLevel=3")
        check("DebugLevel 3 -> 2" in p.out, "S0 init logs the DebugLevel change")
        check(not b.same(b.skse, b.store(TEST)), "S0 live no longer holds the test settings")
        p = b.run(["--status"])
        check(p.returncode == 0 and "STATUS OK" in p.out and "rest state" in p.out, "S0 status OK")
        p = b.run(["--assert-rest"])
        check(p.returncode == 0 and "ASSERT-REST OK" in p.out, "S0 --assert-rest passes in the rest state (rc 0)")

        # S1 Lucienne, normal exit (the game runs ~12 s so the in-session checks can happen)
        p = b.run(["--profile", LUC], secs=12, wait=False)
        check(b.wait_state("IN_USE"), "S1 marker IN_USE during the session")
        check(b.marker().get("owner") == LUC, "S1 marker owner Lucienne during the session")
        check(b.same(b.store(LUC), b.skse), "S1 live == Lucienne store during the session")
        q = b.run(["--assert-rest"])
        check(q.returncode == 6 and "ASSERT-REST FAILED" in q.out and "IN_USE" in q.out, "S1 --assert-rest fails (rc 6, loud) while the marker is IN_USE")
        b.mark("mark-S1-luc")
        out, _ = p.communicate(timeout=120)
        check(p.returncode == 0, "S1 rc 0")
        check(b.marker().get("state") == "CLEAN" and b.marker().get("owner") == LUC, "S1 marker CLEAN owner Lucienne after")
        check(b.has(b.store(LUC), "mark-S1-luc"), "S1 copy-back: Lucienne store has her mark")
        check(not b.has(b.store(TEST), "mark-S1-luc"), "S1 isolation: test store has no Lucienne mark")
        check(b.same(b.skse, b.store(LUC)) and b.has(b.skse, "mark-S1-luc"), "S1 her files stay live in place after her session")
        check(not os.path.exists(os.path.join(b.skse, "_ieb_swap.lock")), "S1 lock released")

        # S2 test profile, game process killed mid-session
        p = b.run(["--profile", "test"], secs=60, wait=False)
        check(b.wait_state("IN_USE"), "S2 IN_USE")
        check(b.marker().get("owner") == TEST and b.same(b.store(TEST), b.skse) and not b.has(b.skse, "mark-S1-luc"),
              "S2 during a test session the live files are the TEST copies")
        q = b.run(["--assert-rest"])
        check(q.returncode == 6 and "owner is 'SkyrimNet Test'" in q.out and "differ from Lucienne's store" in q.out,
              "S2 --assert-rest fails while the TEST copies are live (owner and hashes named)")
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
        check(b.marker().get("state") == "CLEAN" and b.marker().get("owner") == LUC, "S2 marker CLEAN owner Lucienne")
        check(b.same(b.skse, b.store(LUC)) and not b.has(b.skse, "mark-S2-test"), "S2 after the test session HER files are live again (no test mark)")
        check(b.has(b.store(LUC), "mark-S1-luc"), "S2 Lucienne store still has S1 mark (persisted)")
        q = b.run(["--assert-rest"])
        check(q.returncode == 0, "S2 --assert-rest passes again after the test session")

        # S3 killed launcher on her session: the wrapper dies when the game is up; the game goes on
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
        check(b.marker().get("state") == "CLEAN" and b.same(b.skse, b.store(LUC)), "S3 CLEAN and live == her store")

        # S3b console closed during a TEST session (RV-140 (11)): the NEXT launch warns and auto-runs --recover first
        p = b.run(["--profile", TEST], secs=40, env={"IEB_SWAP_DIE_AT": "game_up"})
        check(p.returncode == 99 and b.marker().get("state") == "IN_USE" and b.marker().get("owner") == TEST,
              "S3b test launcher died mid-session, marker IN_USE owner test")
        check(b.same(b.skse, b.store(TEST)), "S3b the live files are the test copies at this moment (the known gap until the next launcher run)")
        b.kill_game()
        time.sleep(1)
        q = b.run(["--assert-rest"])
        check(q.returncode == 6 and "IN_USE" in q.out and "console was probably closed" in q.out,
              "S3b --assert-rest catches the console-close gap (rc 6, names the cause)")
        b.mark("mark-S3b-test")
        b.kill_game()
        time.sleep(1)
        p = b.run(["--profile", LUC], secs=6)
        check(p.returncode == 0, "S3b next launch (her profile) rc 0")
        if p.returncode:
            print(p.out[-2000:])
        check("WARNING" in p.out and "Running --recover now" in p.out, "S3b startup warning printed")
        check("recovered: marker CLEAN" in p.out and p.out.index("WARNING") < p.out.index("STEP 4 backup"),
              "S3b auto --recover ran before the backup/swap steps of the launch")
        check(b.has(b.store(TEST), "mark-S3b-test") and not b.has(b.store(LUC), "mark-S3b-test"), "S3b the test session was copied back to the TEST store only")
        check(b.marker().get("state") == "CLEAN" and b.same(b.skse, b.store(LUC)) and not b.has(b.skse, "mark-S3b-test"),
              "S3b CLEAN, her files live, no test mark in them")

        # S4 hash mismatch refusal (a file edited outside the launchers) and --reset-live
        b.mark("tamper")
        q = b.run(["--assert-rest"])
        check(q.returncode == 6 and "marker state" not in q.out and "IntelEngine.ini" in q.out, "S4 --assert-rest fails on a live file that differs from her store")
        before = {n: b.read(b.skse, n) for n in FILES}
        p = b.run(["--profile", LUC], secs=6)
        check(p.returncode == 2 and "do not match the marker" in p.out, "S4 refused on a modified shared file")
        check(not b.game_up() and all(b.read(b.skse, n) == before[n] for n in FILES), "S4 nothing launched, nothing changed")
        p = b.run(["--reset-live"])
        check(p.returncode == 0 and b.same(b.skse, b.store(LUC)) and not b.has(b.skse, "tamper"), "S4 --reset-live restores her copy")

        # S4b --adopt-live: a bypass launch of HER profile changed a shared file; keep it
        b.mark("bypass-luc")
        p = b.run(["--profile", LUC], secs=6)
        check(p.returncode == 2 and "--adopt-live" in p.out, "S4b refused, and the message offers --adopt-live")
        p = b.run(["--adopt-live"])
        check("KEY-LEVEL DIFF" in p.out and "no key-level differences" in p.out and p.out.index("KEY-LEVEL DIFF") < p.out.index("BACKUP adopt-live"),
              "S4b --adopt-live shows the key-level diff (comment-only change: none) before the backup")
        check(p.returncode == 0 and b.has(b.store(LUC), "bypass-luc") and b.same(b.skse, b.store(LUC)) and b.marker().get("state") == "CLEAN",
              "S4b --adopt-live made the live change her store copy")
        check(not b.has(b.store(TEST), "bypass-luc"), "S4b test store untouched")
        p = b.run(["--status"])
        check(p.returncode == 0, "S4b status OK after adopting")

        # S4c --adopt-live with real key changes: the diff names them, in both JSON and INI, before the backup; guards kept
        wb = lambda n, data: open(os.path.join(b.skse, n), "wb").write(data)
        wb(FILES[0], b'{"baseline": false, "added": {"x": 1}}\n')
        wb(FILES[1], b"{}\n")
        ini = b.read(b.skse, FILES[2]).replace(b"DebugLevel=2", b"DebugLevel=4").replace(b"SkyrimNetDbPath=\n", b"NewKey=1\n")
        wb(FILES[2], ini)
        mk = os.path.join(b.skse, "_ieb_owner.txt")
        orig_mk = open(mk, "rb").read()
        open(mk, "wb").write(orig_mk.replace(b"state=CLEAN", b"state=IN_USE"))
        stbefore = {n: b.read(b.store(LUC), n) for n in FILES}
        p = b.run(["--adopt-live"])
        check(p.returncode == 2 and "KEY-LEVEL" not in p.out and all(b.read(b.store(LUC), n) == stbefore[n] for n in FILES),
              "S4c guard kept: --adopt-live refused when the marker is not CLEAN (no diff shown, store untouched)")
        open(mk, "wb").write(orig_mk)
        p = b.run(["--adopt-live"])
        o = p.out
        check(p.returncode == 0, "S4c --adopt-live rc 0")
        for want in ("~ baseline: true -> false", "+ added.x: 1   (only in live)", "- bio: \"baseline\"   (only in her store copy)",
                     "~ [General] DebugLevel: 2 -> 4", "+ [General] NewKey: 1   (only in live)", "- [General] SkyrimNetDbPath:"):
            check(want in o, "S4c key-level diff line: " + want)
        check("KEY-LEVEL DIFF" in o and o.index("KEY-LEVEL DIFF") < o.index("BACKUP adopt-live") < o.index("COPY-BACK"),
              "S4c order: diff, then backup, then adopt")
        check(b.same(b.skse, b.store(LUC)) and b"DebugLevel=4" in b.read(b.store(LUC), FILES[2]) and b.marker().get("state") == "CLEAN",
              "S4c the live changes are now her store copy")

        # S5 Lucienne store guard
        with open(os.path.join(b.store(LUC), FILES[2]), "ab") as f:
            f.write(b"; test data leaked into her store\n")
        p = b.run(["--profile", LUC], secs=6)
        check(p.returncode == 2 and "differs from the copy taken back" in p.out, "S5 refused: her store differs from the last copy-back")
        p = b.run(["--status"])
        check(p.returncode == 1 and "NEEDS ATTENTION" in p.out, "S5 --status flags the damaged store")
        with open(os.path.join(b.store(LUC), FILES[2]), "rb") as f:
            raw = f.read()
        with open(os.path.join(b.store(LUC), FILES[2]), "wb") as f:
            f.write(raw.replace(b"; test data leaked into her store\n", b""))
        check(b.same(b.skse, b.store(LUC)) and b.marker().get("state") == "CLEAN", "S5 nothing changed; repaired")

        # S6 died while copying the stored files in (a TEST launch: its files differ from the live ones)
        p = b.run(["--profile", TEST], secs=6, env={"IEB_SWAP_DIE_AT": "after_first_copy_swap-in"})
        check(p.returncode == 99 and b.marker().get("state") == "SWAPPING", "S6 died mid swap-in, marker SWAPPING")
        if p.returncode != 99:
            print(p.out[-1500:])
        check(not b.same(b.skse, b.store(LUC)), "S6 live files are a mixture")
        p = b.run(["--profile", LUC, "--recover"])
        check(p.returncode == 0 and b.same(b.skse, b.store(LUC)) and b.marker().get("state") == "CLEAN" and b.marker().get("owner") == LUC,
              "S6 --recover undid the swap (her files live again)")

        # S7 died during copy-back, S8 died during restore (a test game ran and exited)
        for tag, hook in (("S7", "in_copyback"), ("S8", "in_restore")):
            p = b.run(["--profile", TEST], secs=5, wait=False, env={"IEB_SWAP_DIE_AT": hook})
            check(b.wait_state("IN_USE"), tag + " IN_USE")
            b.mark("mark-%s-test" % tag)
            out, _ = p.communicate(timeout=120)
            check(p.returncode == 99, tag + " died at " + hook)
            p = b.run(["--profile", TEST, "--recover"])
            check(p.returncode == 0 and b.has(b.store(TEST), "mark-%s-test" % tag), tag + " --recover finished the copy-back")
            check(b.same(b.skse, b.store(LUC)) and b.marker().get("owner") == LUC and b.marker().get("state") == "CLEAN",
                  tag + " live == her store, marker CLEAN owner Lucienne")
            check(not b.has(b.store(LUC), "mark-%s-test" % tag) and not b.has(b.skse, "mark-%s-test" % tag), tag + " isolation")

        # S8b a half-finished reset-live must not be declared clean by --recover (live is a mixture, owner = rest profile)
        # (covered by restore_rest never skipping; exercised here through a RESTORING marker with a damaged live file)
        with open(os.path.join(b.skse, FILES[2]), "ab") as f:
            f.write(b"; half-written\n")
        mk = os.path.join(b.skse, "_ieb_owner.txt")
        txt = open(mk, encoding="utf-8").read().replace("state=CLEAN", "state=RESTORING")
        open(mk, "w", encoding="utf-8", newline="\n").write(txt)
        p = b.run(["--profile", LUC, "--recover"])
        check(p.returncode == 0 and b.same(b.skse, b.store(LUC)) and not b.has(b.skse, "half-written") and b.marker().get("state") == "CLEAN",
              "S8b recovery from RESTORING with owner = Lucienne rebuilds the live files from her store")

        # S9 the game never appears (a test launch)
        p = b.run(["--profile", TEST], secs=0)
        check(p.returncode == 3, "S9 rc 3 when no game appeared")
        check(b.same(b.skse, b.store(LUC)) and b.marker().get("state") == "CLEAN" and b.marker().get("owner") == LUC,
              "S9 files and marker back to rest state (her files)")

        # S10 the round-trip script's own logic (pre / during / mark / check / refuse / unmark) against the sandbox
        rt = os.path.join(HERE, "roundtrip_swap_plan.py")
        sa = json.dumps(["--skse-dir", b.skse, "--profiles-root", b.profiles, "--backups-dir", b.backups, "--logs-dir", b.logs,
                         "--game-exe", FAKE, "--mo2-exe", "IEBFakeMO2.exe", "--loader-exe", "IEBFakeLoader.exe"])
        env = dict(os.environ, IEB_RT_DIR=os.path.join(b.root, "rt"))
        dbdir = os.path.join(b.root, "mods", "SkyrimNet Test - Output", "SKSE", "Plugins", "SkyrimNet", "data")
        os.makedirs(dbdir)
        open(os.path.join(dbdir, "SkyrimNet-111-222.db"), "wb").write(b"x")      # an existing (test) playthrough DB

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
        # negative control (a): a new playthrough DB appearing during a launch must FAIL the check (RV-140 (9a))
        newdb = os.path.join(dbdir, "SkyrimNet-333-444.db")
        open(newdb, "wb").write(b"y")
        rc, out = rtc("check", 1, "--rc", 0)
        check(rc != 0 and "FAIL  SkyrimNet playthrough DB files" in out, "S10 negative control: a new playthrough DB fails the check")
        os.remove(newdb)
        rc, out = rtc("check", 1, "--rc", 0)
        check("PASS  SkyrimNet playthrough DB files" in out, "S10 DB inventory proof passes again when nothing new exists")
        # MCP proof judge (RV-140 (9b))
        import roundtrip_swap_plan as RT
        check(RT.judge_tools({"result": {"tools": [{"name": "x"}]}})[0] and not RT.judge_tools({"result": {"tools": []}})[0]
              and not RT.judge_tools({"error": {"code": -1}})[0] and not RT.judge_tools(None)[0], "S10 tools/list judge: ok only for a non-empty list")
        # negative control (b): a recorded failed MCP proof fails the check
        stp = os.path.join(b.root, "rt", "state.json")
        stj = json.load(open(stp, encoding="utf-8"))
        stj["mcp"] = {"1": {"ok": False, "text": "tools/list failed", "profile": TEST}}
        json.dump(stj, open(stp, "w", encoding="utf-8"))
        rc, out = rtc("check", 1, "--rc", 0)
        check("FAIL  MCP answered" in out, "S10 negative control: a failed MCP proof fails the check")
        stj["mcp"] = {}
        json.dump(stj, open(stp, "w", encoding="utf-8"))
        # negative control: a leak the check must catch (a test mark placed in her live files)
        b.mark("x")
        rc, out = rtc("check", 1, "--rc", 0)
        check(rc != 0, "S10 negative control: check 1 FAILS on a wrong state")
        subprocess.run([sys.executable, SWAP, "--skse-dir", b.skse, "--profiles-root", b.profiles, "--backups-dir", b.backups,
                        "--logs-dir", b.logs, "--game-exe", FAKE, "--mo2-exe", "IEBFakeMO2.exe", "--loader-exe", "IEBFakeLoader.exe",
                        "--reset-live"], capture_output=True)

        p = b.run(["--status"])
        check(p.returncode == 0, "final status OK")

        # S10b block.py end-of-block --assert-rest (RV-150 (c))
        sys.path.insert(0, os.path.join(HERE, "..", "harness"))
        sys.path.insert(0, os.path.join(HERE, ".."))
        import block as BK
        mkp = os.path.join(b.skse, "_ieb_owner.txt")
        sw = ["--skse-dir", b.skse, "--profiles-root", b.profiles]
        sm = []
        check(BK.assert_rest_end(sm, marker=os.path.join(b.root, "no_such_marker.txt"), swap_args=sw, wait=0) is None and sm == [],
              "S10b no marker file: block.py does nothing, adds no summary row (today's runs unaffected)")
        check(BK.assert_rest_end(sm, marker=mkp, swap_args=sw, wait=0) is True and len(sm) == 1 and "| ok |" in sm[0],
              "S10b marker exists and rest state holds: summary row ok")
        b.mark("block-leak")
        sm = []
        r1 = BK.assert_rest_end(sm, marker=mkp, swap_args=sw, wait=0)
        check(r1 is False and len(sm) == 1 and "FINDING" in sm[0] and "ASSERT-REST FAILED" in sm[0],
              "S10b rest state broken: FINDING row in the block summary")
        import threading
        threading.Timer(3.0, lambda: subprocess.run([sys.executable, SWAP, "--skse-dir", b.skse, "--profiles-root", b.profiles,
                        "--backups-dir", b.backups, "--logs-dir", b.logs, "--game-exe", FAKE, "--mo2-exe", "IEBFakeMO2.exe",
                        "--loader-exe", "IEBFakeLoader.exe", "--reset-live"], capture_output=True)).start()
        sm = []
        check(BK.assert_rest_end(sm, marker=mkp, swap_args=sw, wait=40, gap=1) is True and "| ok |" in sm[0],
              "S10b a launcher copy-back that finishes during the wait is not a finding (retry loop)")
        check("assert_rest_end(summary)" in open(os.path.join(HERE, "..", "harness", "block.py"), encoding="utf-8").read(),
              "S10b block.py calls assert_rest_end at the end of a block")

        # S10c block.py HALT / ABORT exit (RV-150-impl): once the game is closed, --recover then --assert-rest, result in the summary
        bsrc = open(os.path.join(HERE, "..", "harness", "block.py"), encoding="utf-8").read()
        check('STOP_CTX["done"] = True\n    print("BLOCK DONE' in bsrc and "stop_restore_main()" in bsrc.split('if __name__ == "__main__":')[1]
              and "STOP_CTX.update(summary=summary" in bsrc,
              "S10c block.py arms the stop exit at block start, disarms it at the normal end, and runs it from the script's finally")
        sw2 = sw + ["--backups-dir", b.backups, "--logs-dir", b.logs, "--game-exe", FAKE, "--mo2-exe", "IEBFakeMO2.exe",
                    "--loader-exe", "IEBFakeLoader.exe", "--lock-wait", "3"]
        sm = []
        check(BK.stop_restore(sm, "HALT", marker=os.path.join(b.root, "no_such_marker.txt"), swap_args=sw2, wait=0) is None and sm == [],
              "S10c no marker file: the HALT/ABORT exit does nothing, adds no summary row")
        real_procs, real_close = BK.game.procs, BK.game.close
        state = {"up": True, "closed": 0}
        BK.game.procs = lambda: {"SkyrimSE.exe"} if state["up"] else set()
        def fake_close(run=None, timeout=120, force=False):
            state["closed"] += 1
            state["up"] = False
            return True
        BK.game.close = fake_close
        try:
            p = b.run(["--profile", TEST], secs=40, env={"IEB_SWAP_DIE_AT": "game_up"})
            check(p.returncode == 99 and b.marker().get("state") == "IN_USE" and b.marker().get("owner") == TEST,
                  "S10c setup: a test session whose launcher console died, marker IN_USE owner test")
            b.kill_game()
            time.sleep(1)
            b.mark("mark-S10c-test")
            sm = []
            r2 = BK.stop_restore(sm, "HALT", marker=mkp, swap_args=sw2, wait=0)
            check(r2 is False and state["closed"] == 0 and len(sm) == 1 and "FINDING" in sm[0]
                  and "her settings NOT restored, run --recover before playing" in sm[0] and b.marker().get("state") == "IN_USE",
                  "S10c HALT with the game still running: not closed, FINDING row 'her settings NOT restored, run --recover before playing'")
            sm = []
            r3 = BK.stop_restore(sm, "ABORT", marker=mkp, swap_args=sw2, wait=0, may_close=True)
            check(state["closed"] == 1 and r3 is True and len(sm) == 2 and "recovered" in sm[0] and "| ok |" in sm[1],
                  "S10c ABORT of the block's own game: closed through game.close, then --recover, then --assert-rest, both in the summary")
            check(b.marker().get("state") == "CLEAN" and b.marker().get("owner") == LUC and b.same(b.skse, b.store(LUC))
                  and b.has(b.store(TEST), "mark-S10c-test") and not b.has(b.skse, "mark-S10c-test"),
                  "S10c after it: CLEAN, her files live, the test session copied back to the TEST store only")
            sm = []
            check(BK.stop_restore(sm, "HALT", marker=mkp, swap_args=sw2, wait=0) is True and len(sm) == 2 and "| ok |" in sm[1],
                  "S10c game already closed and rest state holding: recover is a no-op, assert ok")
            b.mark("block-leak2")
            sm = []
            r4 = BK.stop_restore(sm, "ABORT", marker=mkp, swap_args=sw2, wait=0)
            check(r4 is False and any("FINDING" in l and "her settings NOT restored" in l for l in sm),
                  "S10c --recover cannot fix it: FINDING row 'her settings NOT restored'")
            subprocess.run([sys.executable, SWAP, "--skse-dir", b.skse, "--profiles-root", b.profiles, "--backups-dir", b.backups,
                            "--logs-dir", b.logs, "--game-exe", FAKE, "--mo2-exe", "IEBFakeMO2.exe", "--loader-exe", "IEBFakeLoader.exe",
                            "--reset-live"], capture_output=True)
            # the script-level exit writes the rows into the summary file (appended when the path already wrote it)
            mdp = os.path.join(b.root, "FF_stop.md")
            open(mdp, "w").write("| HALT | invariant failed |\n")
            BK.STOP_CTX.update(summary=["| HALT | invariant failed |"], path=mdp, done=False, owned=False)
            real_sr = BK.stop_restore
            BK.stop_restore = lambda summary, why, **kw: real_sr(summary, why, marker=mkp, swap_args=sw2, wait=0, **kw)
            try:
                state["up"] = False
                BK.stop_restore_main()
            finally:
                BK.stop_restore = real_sr
            txt2 = open(mdp, encoding="utf-8").read()
            check("swap restore after HALT" in txt2 and "| ok |" in txt2 and txt2.startswith("| HALT |") and BK.STOP_CTX["done"],
                  "S10c stop_restore_main appends the restore rows to the block summary and disarms")
            BK.stop_restore_main()
            check(open(mdp, encoding="utf-8").read() == txt2, "S10c a block that ended normally (done) leaves the summary alone")
        finally:
            BK.game.procs, BK.game.close = real_procs, real_close
            BK.STOP_CTX.update(summary=None, done=True)

        # S11 the .bat wrappers (RV-140 (12)): absolute python path, checked at start with a clear error
        bat = os.path.join(HERE, "Play_Lucienne.bat")
        txt = open(bat, encoding="utf-8").read()
        PYABS = r"C:\Python314\python.exe"
        check(('set "PY=%s"' % PYABS) in txt and "python -u" not in txt.replace("%PY%", ""), "S11 Play_Lucienne.bat uses the absolute python path")
        check(os.path.isfile(PYABS), "S11 %s exists on this machine" % PYABS)
        r = subprocess.run(["cmd", "/c", bat, "--status", "--skse-dir", b.skse, "--profiles-root", b.profiles], input="\n",
                           capture_output=True, text=True, timeout=60)
        check(r.returncode == 0 and "STATUS OK" in r.stdout, "S11 Play_Lucienne.bat runs swap_launch.py (--status) through the absolute path")
        nosuch = r"C:\NoSuchPython\python.exe"
        bad = os.path.join(b.root, "bad.bat")
        open(bad, "w", newline="\r\n").write(txt.replace(PYABS, nosuch).replace("%~dp0", HERE + "\\"))
        r = subprocess.run(["cmd", "/c", bad], input="\n", capture_output=True, text=True, timeout=60)
        check(r.returncode == 9 and ("Python was not found at " + nosuch) in r.stdout, "S11 a missing python gives a clear error (exit 9)")

        # S12 --init and her IntelEngine.ini DebugLevel (RV-150 (a)): byte-safe, --verify-mode, no key
        def init_box(ini, extra=()):
            bx = Box(ini)
            boxes.append(bx)
            for prof in (LUC, TEST):
                os.makedirs(os.path.join(bx.profiles, prof))
            q = bx.run(["--assert-rest"])
            check(q.returncode == 6 and "marker" in q.out and "missing" in q.out, "S12 --assert-rest fails before --init (no marker)")
            return bx, bx.run(["--init", "--baseline-dir", bx.base] + list(extra))
        orig = b"\xef\xbb\xbf[General]\r\n; comment DebugLevel=9\r\ndebuglevel = 3 ; keep\r\nSkyrimNetDbPath=\r\n[Other]\r\nFuzzy=1"
        bx, q = init_box(orig)
        want = orig.replace(b"debuglevel = 3 ; keep", b"debuglevel = 2 ; keep")
        check(q.returncode == 0 and bx.read(bx.store(LUC), FILES[2]) == want,
              "S12 CRLF + BOM ini: only the DebugLevel value byte changed (comment, case, spacing, trailing comment, no final newline kept)")
        check(bx.read(bx.store(TEST), FILES[2]) == orig and bx.read(bx.skse, FILES[2]) == want, "S12 TEST store keeps the original; live = her copy")
        man = json.load(open(os.path.join(bx.store(LUC), "manifest.json"), encoding="utf-8"))["files"]
        check(man[FILES[2]] == hashlib.sha256(want).hexdigest(), "S12 her manifest records the patched ini's hash")
        q = bx.run(["--assert-rest"])
        check(q.returncode == 0, "S12 --assert-rest passes after init")
        bx, q = init_box(b"[General]\nDebugLevel=0\n", ["--verify-mode"])
        check(q.returncode == 0 and bx.read(bx.store(LUC), FILES[2]) == b"[General]\nDebugLevel=3\n" and "(--verify-mode)" in q.out,
              "S12 --init --verify-mode writes DebugLevel=3")
        bx, q = init_box(b"[General]\nFoo=1\n")
        check(q.returncode == 0 and bx.read(bx.store(LUC), FILES[2]) == b"[General]\nFoo=1\n" and "no DebugLevel key" in q.out,
              "S12 no DebugLevel key: ini left byte-identical, logged")
    finally:
        b.kill_game()
        shutil.rmtree(b.root, ignore_errors=True)
        for bx in boxes:
            shutil.rmtree(bx.root, ignore_errors=True)
    print("\nRESULT: %s" % ("ALL PASS" if not fails else "%d FAILED: %s" % (len(fails), "; ".join(fails))))
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
