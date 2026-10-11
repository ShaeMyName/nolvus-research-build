"""Per-profile swap launcher for the shared SKSE files (BRIDGE_SPEC_V2.md section 16.7 step 8c; REVIEW_LOG RV-135 (6)).

Authored offline 2026-10-11. Nothing here has been run against the real game.  It WRITES under C:\\Nolvus
(profiles\\<Profile>\\shared_skse\\) and under Documents\\My Games\\Skyrim Special Edition\\SKSE\\ when run for real;
the spec approves that for promotion.

WHY: Documents\\My Games\\Skyrim Special Edition\\SKSE\\ is outside MO2's virtual file system, so every profile reads
and writes the same SeverActions_Settings.json, SeverActions_BioBlocks.json and IntelEngine.ini.  Each profile
("Lucienne", "SkyrimNet Test") keeps its own copy in a store; this launcher swaps them in before the game starts and
copies them back after SkyrimSE.exe exits (normal exit, crash or kill).

USAGE (through Play_Lucienne.bat / Play_SkyrimNet_Test.bat / swap_launch.ps1):
    python swap_launch.py --profile Lucienne [--unattended] [--no-tts]       launch (the default command)
    python swap_launch.py --profile Lucienne --recover                       a run died mid-swap
    python swap_launch.py --status                                           read-only health report
    python swap_launch.py --init                                             one-time promotion setup (both stores + marker)
    python swap_launch.py --reset-live                                       resolve a refused hash mismatch

Exit codes: 0 ok | 2 refused before touching anything | 3 launch problem (files restored) | 4 copy-back or restore failed
(marker left in a non-CLEAN state: run --recover) | 5 internal error.

MODEL
  * Rest state: after every session the live files are the REST profile's ("SkyrimNet Test") copies, so a stray launch
    from MO2's own window finds test files, never a stale copy of hers.  (Spec 3822 leaves them in place; this is the
    task's step (f) "restore the TEST copies".  Change with --rest-profile; see play_lucienne_8c.md open question 1.)
  * Marker SKSE\\_ieb_owner.txt: state CLEAN | SWAPPING | IN_USE | COPYBACK | RESTORING, the owner, and the SHA-256 the
    live files should have.  Written atomically before each phase, so a dead launcher is diagnosable and --recover
    can finish the phase it died in (every phase is idempotent).
  * Lock SKSE\\_ieb_swap.lock (pid): one launcher at a time; a stale lock (dead pid) is cleared with a log line.
  * Store: profiles\\<Profile>\\shared_skse\\{the 3 files, manifest.json}.  manifest.json holds the hashes taken at the
    last copy-back; the pre-launch guard refuses if the store no longer matches it (spec 3823, applied to both profiles).
  * Backups: every launch first copies the live files and the store about to be swapped in to
    C:\\nolvus-research\\backups\\shared_skse_swap\\<stamp>_<profile>\\ (newest 40 kept).
"""
import argparse
import csv
import datetime
import hashlib
import io
import json
import os
import shutil
import subprocess
import sys
import time

# ---------------------------------------------------------------- configuration
FILES = ["SeverActions_Settings.json", "SeverActions_BioBlocks.json", "IntelEngine.ini"]   # spec 3819 (8c)
ABSENT = "ABSENT"
TEST_PROFILE = "SkyrimNet Test"
LUC_PROFILE = "Lucienne"
INSTANCE = r"C:\Nolvus\Instances\Nolvus Awakening"
DEFAULT_SKSE = os.path.join(os.path.expanduser("~"), "Documents", "My Games", "Skyrim Special Edition", "SKSE")
DEFAULT_PROFILES = os.path.join(INSTANCE, "MODS", "profiles")
RESEARCH = r"C:\nolvus-research"
DEFAULT_PLAY_PS1 = os.path.join(RESEARCH, "tts-engines", "patches", "turbo_slim", "play_test_profile.ps1")
DEFAULT_BACKUPS = os.path.join(RESEARCH, "backups", "shared_skse_swap")
DEFAULT_LOGS = os.path.join(RESEARCH, "test_runs", "swap_logs")
DEFAULT_BASELINE = os.path.join(RESEARCH, "backups", "lucienne_baseline_sa_20261009-191902")
MARKER_NAME = "_ieb_owner.txt"
LOCK_NAME = "_ieb_swap.lock"
KEEP_BACKUPS = 40
NOWIN = getattr(subprocess, "CREATE_NO_WINDOW", 0)
NEWCON = getattr(subprocess, "CREATE_NEW_CONSOLE", 0)
EXIT_REFUSED, EXIT_LAUNCH, EXIT_COPYBACK, EXIT_INTERNAL = 2, 3, 4, 5


class Refused(Exception):
    """A pre-check failed; nothing was changed."""


class Failed(Exception):
    """A phase failed after the marker left CLEAN; --recover is needed."""


class Cfg:
    pass


def make_cfg(a):
    c = Cfg()
    c.skse = a.skse_dir or DEFAULT_SKSE
    c.profiles = a.profiles_root or DEFAULT_PROFILES
    c.backups = a.backups_dir or DEFAULT_BACKUPS
    c.logs = a.logs_dir or DEFAULT_LOGS
    c.play_ps1 = a.play_ps1 or DEFAULT_PLAY_PS1
    c.game_exe = a.game_exe
    c.mo2_exe = a.mo2_exe
    c.loader_exe = a.loader_exe
    c.poll = a.poll
    c.settle = a.settle
    c.appear_timeout = a.appear_timeout
    c.lock_wait = a.lock_wait
    c.no_game_grace = a.no_game_grace
    c.launch_cmd = json.loads(a.launch_cmd_json) if a.launch_cmd_json else None
    c.unattended = a.unattended
    c.no_tts = a.no_tts
    c.rest = canon_profile(a.rest_profile)
    c.marker = os.path.join(c.skse, MARKER_NAME)
    c.lock = os.path.join(c.skse, LOCK_NAME)
    c.profile = canon_profile(a.profile) if a.profile else None
    c.logfile = None
    return c


def canon_profile(p):
    if p is None:
        return None
    k = p.strip().lower()
    if k in ("lucienne",):
        return LUC_PROFILE
    if k in ("test", "skyrimnet test", "skyrimnet_test"):
        return TEST_PROFILE
    raise SystemExit("unknown profile %r (use Lucienne or 'SkyrimNet Test')" % p)


def store_dir(c, profile):
    return os.path.join(c.profiles, profile, "shared_skse")


# ---------------------------------------------------------------- logging (task step g)
def log(c, msg):
    line = "[%s] %s" % (datetime.datetime.now().strftime("%H:%M:%S"), msg)
    print(line, flush=True)
    if c.logfile:
        try:
            with open(c.logfile, "a", encoding="utf-8") as f:
                f.write(line + "\n")
        except OSError:
            pass


def open_log(c, tag):
    os.makedirs(c.logs, exist_ok=True)
    stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    c.stamp = stamp
    c.logfile = os.path.join(c.logs, "swap_%s_%s_%s.log" % (stamp, (c.profile or "any").replace(" ", "_"), tag))


def die_at(point):
    """Test hook only (selftest_swap.py): IEB_SWAP_DIE_AT=<point> ends the process hard, like a killed launcher."""
    if os.environ.get("IEB_SWAP_DIE_AT") == point:
        print("TEST HOOK: dying at %s" % point, flush=True)
        os._exit(99)


# ---------------------------------------------------------------- files, hashes
def sha(path):
    if not os.path.isfile(path):
        return ABSENT
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def hashes(d):
    return {f: sha(os.path.join(d, f)) for f in FILES}


def short(h):
    return h if h == ABSENT else h[:10]


def retry(fn, what, tries=10, gap=1.5):
    last = None
    for _ in range(tries):
        try:
            return fn()
        except OSError as e:     # a file can stay locked for a moment after the game exits
            last = e
            time.sleep(gap)
    raise Failed("%s failed after %d tries: %s" % (what, tries, last))


def put_file(src_dir, dst_dir, name, want):
    """Make dst_dir/name equal src_dir/name (want = its hash, or ABSENT -> remove). Atomic replace, verified."""
    src, dst = os.path.join(src_dir, name), os.path.join(dst_dir, name)
    if want == ABSENT:
        if os.path.exists(dst):
            retry(lambda: os.remove(dst), "remove %s" % dst)
        return
    tmp = dst + ".swaptmp"
    def go():
        shutil.copyfile(src, tmp)
        os.replace(tmp, dst)
    retry(go, "copy %s -> %s" % (src, dst))
    if sha(dst) != want:
        raise Failed("verify failed after copying %s (expected %s, got %s)" % (name, short(want), short(sha(dst))))


def put_all(c, src_dir, dst_dir, want, label):
    os.makedirs(dst_dir, exist_ok=True)
    for n in FILES:
        put_file(src_dir, dst_dir, n, want[n])
        log(c, "  %s %s: %s %s" % (label, n, short(want[n]), "(absent: removed)" if want[n] == ABSENT else "ok"))
        if n == FILES[0]:
            die_at("after_first_copy_" + label)


def write_atomic(path, text):
    tmp = path + ".swaptmp"
    with open(tmp, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
    retry(lambda: os.replace(tmp, path), "write %s" % path)


# ---------------------------------------------------------------- marker, manifest, lock
def read_kv(path):
    if not os.path.isfile(path):
        return None
    d = {}
    for line in io.open(path, encoding="utf-8"):
        line = line.rstrip("\r\n")
        if line.startswith("#") or "=" not in line:
            continue
        k, v = line.split("=", 1)
        d[k] = v
    return d


def write_marker(c, state, owner, hs, **extra):
    d = {"schema": "1", "state": state, "owner": owner,
         "updated": datetime.datetime.now().isoformat(timespec="seconds"), "launcher_pid": str(os.getpid())}
    d.update({k: str(v) for k, v in extra.items()})
    lines = ["# IEB shared-SKSE owner marker (swap_launch.py). state CLEAN = the live files are owner's and hashes match.",
             "# Do not edit by hand; use swap_launch.py --recover / --reset-live."]
    lines += ["%s=%s" % (k, v) for k, v in d.items()]
    lines += ["sha256.%s=%s" % (n, hs[n]) for n in FILES]
    write_atomic(c.marker, "\n".join(lines) + "\n")
    log(c, "MARKER state=%s owner=%s" % (state, owner))


def marker_hashes(m):
    return {n: m.get("sha256." + n, ABSENT) for n in FILES}


def diff(a, b):
    return ["%s (%s vs %s)" % (n, short(a[n]), short(b[n])) for n in FILES if a[n] != b[n]]


def write_manifest(c, profile, hs, note):
    d = store_dir(c, profile)
    os.makedirs(d, exist_ok=True)
    m = {"profile": profile, "updated": datetime.datetime.now().isoformat(timespec="seconds"), "note": note,
         "files": hs}
    write_atomic(os.path.join(d, "manifest.json"), json.dumps(m, indent=2) + "\n")


def read_manifest(c, profile):
    p = os.path.join(store_dir(c, profile), "manifest.json")
    if not os.path.isfile(p):
        return None
    return json.load(io.open(p, encoding="utf-8"))


def store_problems(c, profile):
    m = read_manifest(c, profile)
    if m is None:
        return ["no manifest for '%s' (run --init)" % profile]
    return diff(m["files"], hashes(store_dir(c, profile)))


# ---------------------------------------------------------------- processes
def tasklist(image=None, pid=None):
    cmd = ["tasklist", "/FO", "CSV", "/NH"]
    if image:
        cmd += ["/FI", "IMAGENAME eq %s" % image]
    if pid:
        cmd += ["/FI", "PID eq %d" % pid]
    out = subprocess.run(cmd, capture_output=True, text=True, creationflags=NOWIN).stdout
    rows = [r for r in csv.reader(io.StringIO(out)) if len(r) >= 2 and r[1].isdigit()]
    return [(r[0], int(r[1])) for r in rows]


def running(c):
    """Names of game-related processes up (same set as harness game.procs, RV-73, plus the configured names)."""
    names = {c.game_exe.lower(): c.game_exe, c.mo2_exe.lower(): c.mo2_exe, c.loader_exe.lower(): c.loader_exe}
    out = {}
    for img, pid in tasklist():
        if img.lower() in names:
            out.setdefault(names[img.lower()], []).append(pid)
    return out


def pid_alive(pid):
    return bool(tasklist(pid=pid))


def acquire_lock(c):
    deadline = time.time() + c.lock_wait
    while True:
        try:
            fd = os.open(c.lock, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
            os.write(fd, ("%d\n%s\n" % (os.getpid(), datetime.datetime.now().isoformat(timespec="seconds"))).encode())
            os.close(fd)
            return
        except FileExistsError:
            pass
        try:
            pid = int(io.open(c.lock, encoding="utf-8").read().split()[0])
        except (OSError, ValueError, IndexError):
            pid = 0
        if pid and pid != os.getpid() and pid_alive(pid):
            if time.time() >= deadline:
                raise Refused("another swap launcher (pid %d) holds %s; wait for it, or end that process" % (pid, c.lock))
            log(c, "LOCK held by live launcher pid %d; waiting" % pid)
            time.sleep(max(c.poll, 2))
            continue
        log(c, "LOCK stale (pid %s is gone): removing %s" % (pid or "?", c.lock))
        try:
            os.remove(c.lock)
        except OSError:
            time.sleep(1)


def release_lock(c):
    try:
        os.remove(c.lock)
    except OSError:
        pass


# ---------------------------------------------------------------- backups
def make_backup(c, tag, profile):
    # a unique folder per call (two backups in the same second must never share one: --recover reads the first)
    base, k = "%s_%s" % (c.stamp, profile.replace(" ", "_")), 0
    while True:
        name = base if not k else "%s_%d" % (base, k)
        root = os.path.join(c.backups, name)
        if not os.path.exists(root):
            break
        k += 1
    live = os.path.join(root, "live_before")
    os.makedirs(live)
    for n in FILES:
        s = os.path.join(c.skse, n)
        if os.path.isfile(s):
            shutil.copyfile(s, os.path.join(live, n))
    st = os.path.join(root, "store_%s" % profile.replace(" ", "_"))
    if os.path.isdir(store_dir(c, profile)):
        shutil.copytree(store_dir(c, profile), st, dirs_exist_ok=True)
    json.dump({"tag": tag, "live_before": hashes(c.skse)}, io.open(os.path.join(root, "backup.json"), "w", encoding="utf-8"))
    log(c, "BACKUP %s: live files + %s store -> %s" % (tag, profile, root))
    return name


def prune_backups(c):
    try:
        ds = sorted(d for d in os.listdir(c.backups) if os.path.isdir(os.path.join(c.backups, d)) and "_" in d)
        for d in ds[:-KEEP_BACKUPS]:
            if d[:8].isdigit():
                shutil.rmtree(os.path.join(c.backups, d), ignore_errors=True)
    except OSError:
        pass


# ---------------------------------------------------------------- phases
def copy_back(c, profile):
    """Live files -> profile's store, manifest rewritten. Idempotent."""
    live = hashes(c.skse)
    log(c, "COPY-BACK: live files -> store of '%s' (%s)" % (profile, store_dir(c, profile)))
    put_all(c, c.skse, store_dir(c, profile), live, "copy-back")
    write_manifest(c, profile, live, "copy-back")
    log(c, "COPY-BACK done; manifest written")
    return live


def restore_rest(c, profile):
    """Put the REST profile's store copies into the live folder (skipped when profile is the rest profile)."""
    if profile == c.rest:
        log(c, "RESTORE: '%s' is the rest profile; live files already are its copy" % profile)
        return hashes(c.skse)
    p = store_problems(c, c.rest)
    if p:
        raise Failed("rest profile store '%s' does not match its manifest: %s" % (c.rest, "; ".join(p)))
    m = read_manifest(c, c.rest)["files"]
    log(c, "RESTORE: '%s' store -> live files" % c.rest)
    put_all(c, store_dir(c, c.rest), c.skse, m, "restore")
    return m


def finish(c, profile):
    """COPYBACK -> RESTORING -> CLEAN. Safe to call again after a death in any of these phases."""
    write_marker(c, "COPYBACK", profile, hashes(c.skse), session=c.stamp)
    die_at("in_copyback")
    copy_back(c, profile)
    write_marker(c, "RESTORING", profile, read_manifest(c, profile)["files"], session=c.stamp, restore_to=c.rest)
    die_at("in_restore")
    final = restore_rest(c, profile)
    write_marker(c, "CLEAN", c.rest, final, session=c.stamp)


# ---------------------------------------------------------------- the game
def build_launch_cmd(c):
    if c.launch_cmd:
        return c.launch_cmd, 0
    cmd = ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass"]
    if c.unattended:
        cmd += ["-WindowStyle", "Hidden"]
    cmd += ["-File", c.play_ps1, "-Profile", c.profile]
    if c.unattended:
        cmd.append("-Unattended")
    if c.no_tts:
        cmd.append("-NoTTS")
    return cmd, (NEWCON if c.unattended else 0)


def wait_for_game(c, child):
    """Step (e): wait for SkyrimSE.exe to appear, then until it is gone for c.settle seconds. Returns True if a game ran."""
    t0 = time.time()
    seen, grace_since = None, None
    extended = False
    limit = c.appear_timeout
    while seen is None:
        time.sleep(c.poll)
        r = running(c)
        if c.game_exe in r:
            seen = r[c.game_exe][0]
            break
        if child.poll() is not None and not r:
            # the launch command is gone and no game/MO2/loader process exists: allow a grace period, then give up
            grace_since = grace_since or time.time()
            if time.time() - grace_since > c.no_game_grace:
                log(c, "LAUNCH: the launch command ended (exit %s) and no game process ever appeared" % child.returncode)
                return False
        else:
            grace_since = None
        if time.time() - t0 > limit:
            if r and not extended:
                extended = True
                limit += 600
                log(c, "LAUNCH: %s up but no %s after %d s; waiting 10 more min" % (sorted(r), c.game_exe, c.appear_timeout))
                continue
            log(c, "LAUNCH: no %s within %d s (running: %s)" % (c.game_exe, int(time.time() - t0), sorted(r)))
            return False
    log(c, "GAME up: %s pid %d after %d s; waiting on the process (not on %s)" % (c.game_exe, seen, time.time() - t0, c.mo2_exe))
    die_at("game_up")
    gone_since = None
    last_note = time.time()
    while True:
        try:
            time.sleep(c.poll)
            r = running(c)
            game_or_loader = [n for n in (c.game_exe, c.loader_exe) if n in r]
            if game_or_loader:
                gone_since = None
                if time.time() - last_note > 600:
                    last_note = time.time()
                    log(c, "GAME still running (%s)" % ", ".join("%s %s" % (n, r[n]) for n in game_or_loader))
            else:
                gone_since = gone_since or time.time()
                if time.time() - gone_since >= c.settle:
                    log(c, "GAME exited (%s gone for %d s; normal exit, crash or kill all end here)" % (c.game_exe, c.settle))
                    return True
        except KeyboardInterrupt:
            log(c, "INTERRUPT ignored while the game runs: copy-back needs the game to exit first. Close the game.")


# ---------------------------------------------------------------- commands
def precheck_processes(c):
    r = running(c)
    if r:
        raise Refused("%s running (%s). Close the game and MO2 first (a running MO2 would also launch its own current profile)."
                      % ("/".join(sorted(r)), "; ".join("%s pid %s" % (n, p) for n, p in r.items())))


def undo_swap(c, prev_owner, backup_name):
    """Died or failed while copying the stored files in: the game never started. Put back the live files taken at STEP 4."""
    prev = prev_owner or c.rest
    src = os.path.join(c.backups, backup_name, "live_before")
    info = json.load(io.open(os.path.join(os.path.dirname(src), "backup.json"), encoding="utf-8"))["live_before"]
    log(c, "UNDO-SWAP: restoring the pre-swap live files (owner before: '%s') from %s" % (prev, src))
    put_all(c, src, c.skse, info, "undo-swap")
    write_marker(c, "CLEAN", prev, info, recovered_from="SWAPPING")


def cmd_launch(c):
    open_log(c, "launch")
    log(c, "=== swap launch: profile '%s' (rest profile '%s'; unattended=%s no_tts=%s)" % (c.profile, c.rest, c.unattended, c.no_tts))
    log(c, "STEP 1 check no game/MO2 running")
    precheck_processes(c)
    log(c, "STEP 2 lock")
    acquire_lock(c)
    locked = True
    phase = "pre"      # pre -> swapping -> in_use
    prev_owner, bname = None, None
    code = 0
    try:
        log(c, "STEP 3 marker and hash check (spec b)")
        m = read_kv(c.marker)
        if m is None:
            raise Refused("no owner marker %s: run swap_launch.py --init once (promotion setup)" % c.marker)
        if m.get("state") != "CLEAN":
            raise Refused("marker state is %s (owner '%s', %s): a previous run died mid-swap. Run: swap_launch.py --profile \"%s\" --recover"
                          % (m.get("state"), m.get("owner"), m.get("updated"), c.profile))
        live = hashes(c.skse)
        bad = diff(marker_hashes(m), live)
        if bad:
            raise Refused("the shared files do not match the marker (owner '%s'): %s. Someone started the game outside a launcher "
                          "or a tool edited them. Not guessing the owner. To discard the live version and put the owner's store "
                          "copy back (live is backed up first): swap_launch.py --reset-live" % (m.get("owner"), "; ".join(bad)))
        log(c, "  marker owner '%s', live hashes match" % m.get("owner"))
        p = store_problems(c, c.profile)
        if p:
            raise Refused("store of '%s' differs from the copy taken back after its last session: %s. Not launching "
                          "(catches test data before a save can read it; spec 3823)." % (c.profile, "; ".join(p)))
        p2 = store_problems(c, c.rest)
        if p2:
            raise Refused("rest profile store '%s' differs from its manifest: %s" % (c.rest, "; ".join(p2)))
        log(c, "  store of '%s' matches its manifest" % c.profile)
        prune_backups(c)

        log(c, "STEP 4 backup (spec/task b)")
        bname = make_backup(c, "pre-swap", c.profile)
        prev_owner = m.get("owner")

        log(c, "STEP 5 swap in '%s' copies (spec c)" % c.profile)
        want = read_manifest(c, c.profile)["files"]
        write_marker(c, "SWAPPING", c.profile, want, prev_owner=prev_owner, backup=bname, session=c.stamp)
        phase = "swapping"
        put_all(c, store_dir(c, c.profile), c.skse, want, "swap-in")
        write_marker(c, "IN_USE", c.profile, want, prev_owner=prev_owner, backup=bname, session=c.stamp)
        phase = "in_use"
        die_at("after_in_use")

        log(c, "STEP 6 launch through MO2 on profile '%s' (spec d)" % c.profile)
        cmd, flags = build_launch_cmd(c)
        log(c, "  command: %s" % " ".join(cmd))
        child = subprocess.Popen(cmd, creationflags=flags)
        die_at("after_launch")
        ran = wait_for_game(c, child)
        if not ran:
            code = EXIT_LAUNCH
        log(c, "STEP 7 copy back and restore (spec e; runs whatever the exit was)")
        finish(c, c.profile)
        phase = "done"
        release_lock(c)
        locked = False
        try:
            rc = child.wait(timeout=180)
            log(c, "launch command finished with exit code %s" % rc)
            if code == EXIT_LAUNCH and rc not in (0, None):
                log(c, "  (the launch command failed; nothing is left swapped)")
        except subprocess.TimeoutExpired:
            log(c, "launch command still running 180 s after the game exited (TTS shutdown?); not waiting longer")
        log(c, "=== done: marker CLEAN, owner '%s'. Log: %s" % (c.rest, c.logfile))
        return code
    except Refused:
        raise
    except BaseException as e:
        log(c, "ERROR %s: %s" % (type(e).__name__, e))
        if phase == "swapping":
            try:
                undo_swap(c, prev_owner, bname)
                return EXIT_LAUNCH
            except BaseException as e2:
                log(c, "undo of the half-done swap FAILED: %s. Run swap_launch.py --profile \"%s\" --recover" % (e2, c.profile))
                return EXIT_COPYBACK
        if phase == "in_use":
            # finally-style guarantee: the launcher's own error must not skip the copy-back
            r = running(c)
            if c.game_exe in r or c.loader_exe in r:
                log(c, "The game is still running; copy-back NOT done. Close it, then run swap_launch.py --profile \"%s\" --recover" % c.profile)
                return EXIT_COPYBACK
            try:
                log(c, "game not running: running the copy-back now")
                finish(c, c.profile)
                return EXIT_LAUNCH
            except BaseException as e2:
                log(c, "copy-back FAILED: %s. Run swap_launch.py --profile \"%s\" --recover" % (e2, c.profile))
                return EXIT_COPYBACK
        return EXIT_INTERNAL
    finally:
        if locked:
            release_lock(c)


def cmd_recover(c):
    open_log(c, "recover")
    log(c, "=== recover (previous run died mid-swap)")
    precheck_processes(c)
    acquire_lock(c)
    try:
        m = read_kv(c.marker)
        if m is None:
            raise Refused("no marker; nothing to recover (use --init for first setup)")
        st, owner = m.get("state"), m.get("owner")
        log(c, "marker: state=%s owner='%s' updated=%s prev_owner='%s'" % (st, owner, m.get("updated"), m.get("prev_owner")))
        if st == "CLEAN":
            bad = diff(marker_hashes(m), hashes(c.skse))
            log(c, "state is CLEAN: nothing to finish. Live files %s the marker%s." % (("differ from" if bad else "match"), (": " + "; ".join(bad)) if bad else ""))
            return 1 if bad else 0
        make_backup(c, "recover-%s" % st, owner)
        if st == "SWAPPING":
            # died while copying the stored files in: the game never started. Put back the live files taken at STEP 4.
            undo_swap(c, m.get("prev_owner"), m.get("backup"))
        elif st in ("IN_USE", "COPYBACK"):
            log(c, "%s: the game for '%s' ran (or may have) with its files in place; finishing its copy-back" % (st, owner))
            finish(c, owner)
        elif st == "RESTORING":
            log(c, "RESTORING: copy-back for '%s' was complete; redoing the restore of '%s'" % (owner, m.get("restore_to") or c.rest))
            final = restore_rest(c, owner)
            write_marker(c, "CLEAN", c.rest, final, recovered_from="RESTORING")
        else:
            raise Refused("unknown marker state %r" % st)
        log(c, "=== recovered: marker CLEAN")
        return 0
    finally:
        release_lock(c)


def cmd_reset_live(c):
    open_log(c, "reset-live")
    log(c, "=== reset-live: discard the live files and put the marker owner's store copy back")
    precheck_processes(c)
    acquire_lock(c)
    try:
        m = read_kv(c.marker)
        if m is None or m.get("state") != "CLEAN":
            raise Refused("marker missing or not CLEAN; use --recover")
        owner = m.get("owner")
        p = store_problems(c, owner)
        if p:
            raise Refused("store of '%s' does not match its manifest (%s); fix by hand" % (owner, "; ".join(p)))
        make_backup(c, "reset-live", owner)
        want = read_manifest(c, owner)["files"]
        write_marker(c, "RESTORING", owner, want, restore_to=owner)
        put_all(c, store_dir(c, owner), c.skse, want, "reset")
        write_marker(c, "CLEAN", owner, want)
        log(c, "=== done: live files are '%s' store copies again (the replaced live files are in the backup above)" % owner)
        return 0
    finally:
        release_lock(c)


def cmd_status(c):
    c.logfile = None
    ok = True
    m = read_kv(c.marker)
    print("SKSE folder : %s" % c.skse)
    if m is None:
        print("marker      : MISSING (run --init)")
        ok = False
    else:
        print("marker      : state=%s owner='%s' updated=%s" % (m.get("state"), m.get("owner"), m.get("updated")))
        bad = diff(marker_hashes(m), hashes(c.skse))
        print("live vs marker: %s" % ("match" if not bad else "DIFFER (expected only while IN_USE): " + "; ".join(bad)))
        ok = ok and m.get("state") == "CLEAN" and not bad
    for prof in (LUC_PROFILE, TEST_PROFILE):
        p = store_problems(c, prof)
        print("store %-15s: %s  [%s]" % (prof, "matches manifest" if not p else "PROBLEM: " + "; ".join(p), store_dir(c, prof)))
        ok = ok and not p
    if os.path.exists(c.lock):
        print("lock        : %s present" % c.lock)
        ok = False
    r = running(c)
    print("processes   : %s" % (r or "none of game/MO2/loader"))
    print("STATUS " + ("OK" if ok else "NEEDS ATTENTION"))
    return 0 if ok else 1


def cmd_init(c, baseline, luc_ini, force):
    """One-time promotion setup (spec 8b + 8c). The test store takes the CURRENT live files (the test settings, taken before
    8b's restore); Lucienne's store takes the 8b baseline SA files plus her IntelEngine.ini."""
    c.profile = c.profile or LUC_PROFILE
    open_log(c, "init")
    log(c, "=== init: stores and marker")
    precheck_processes(c)
    acquire_lock(c)
    try:
        if (read_kv(c.marker) or os.path.isdir(store_dir(c, TEST_PROFILE)) or os.path.isdir(store_dir(c, LUC_PROFILE))) and not force:
            raise Refused("a marker or store already exists; use --force to rebuild (existing stores are backed up first)")
        for prof in (TEST_PROFILE, LUC_PROFILE):     # never create a profile folder: MO2's "copy profile" would then clash
            if not os.path.isdir(os.path.join(c.profiles, prof)):
                raise Refused("MO2 profile folder %s does not exist yet: create the profile in MO2 first (spec 16.7 step 5)"
                              % os.path.join(c.profiles, prof))
        sums = os.path.join(baseline, "SHA256SUMS")
        want = {}
        for line in io.open(sums, encoding="utf-8"):
            if line.strip():
                h, n = line.strip().split(" *", 1)
                want[n] = h
        for n in ("SeverActions_Settings.json", "SeverActions_BioBlocks.json"):
            if sha(os.path.join(baseline, n)) != want.get(n):
                raise Refused("baseline %s fails its SHA256SUMS entry (8b assert)" % n)
        log(c, "8b assert: baseline SA files match SHA256SUMS in %s" % baseline)
        luc_ini = luc_ini or os.path.join(c.skse, "IntelEngine.ini")
        if not os.path.isfile(luc_ini):
            raise Refused("her IntelEngine.ini source %s does not exist" % luc_ini)
        c.stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
        make_backup(c, "init", TEST_PROFILE)
        if os.path.isdir(store_dir(c, LUC_PROFILE)):
            make_backup(c, "init-luc", LUC_PROFILE)
        # test store = live files as they are now
        live = hashes(c.skse)
        os.makedirs(store_dir(c, TEST_PROFILE), exist_ok=True)
        put_all(c, c.skse, store_dir(c, TEST_PROFILE), live, "init-test")
        write_manifest(c, TEST_PROFILE, live, "init from live files")
        # Lucienne's store = baseline SA files + her ini
        ld = store_dir(c, LUC_PROFILE)
        os.makedirs(ld, exist_ok=True)
        lh = {}
        for n in FILES:
            src = luc_ini if n == "IntelEngine.ini" else os.path.join(baseline, n)
            shutil.copyfile(src, os.path.join(ld, n))
            lh[n] = sha(os.path.join(ld, n))
            log(c, "  init-luc %s: %s (from %s)" % (n, short(lh[n]), src))
        write_manifest(c, LUC_PROFILE, lh, "init from 8b baseline + her IntelEngine.ini")
        for n in ("SeverActions_Settings.json", "SeverActions_BioBlocks.json"):
            assert lh[n] == want[n], n
        log(c, "8b assert: Lucienne's store SA files are byte-identical to the baseline")
        write_marker(c, "CLEAN", c.rest, live, session="init")
        log(c, "=== init done. Live files = '%s' store copies; marker CLEAN owner '%s'." % (c.rest, c.rest))
        return 0
    finally:
        release_lock(c)


def build_parser():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--profile", help="Lucienne | 'SkyrimNet Test' | test")
    ap.add_argument("--rest-profile", default=TEST_PROFILE)
    ap.add_argument("--unattended", action="store_true")
    ap.add_argument("--no-tts", action="store_true")
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--recover", action="store_true")
    g.add_argument("--status", action="store_true")
    g.add_argument("--init", action="store_true")
    g.add_argument("--reset-live", action="store_true")
    ap.add_argument("--force", action="store_true")
    ap.add_argument("--baseline-dir", default=DEFAULT_BASELINE)
    ap.add_argument("--luc-ini", help="her IntelEngine.ini (default: the current live one)")
    # paths and timing; the defaults are the real ones, the overrides exist for selftest_swap.py's sandbox
    ap.add_argument("--skse-dir"); ap.add_argument("--profiles-root"); ap.add_argument("--backups-dir"); ap.add_argument("--logs-dir")
    ap.add_argument("--play-ps1")
    ap.add_argument("--game-exe", default="SkyrimSE.exe"); ap.add_argument("--mo2-exe", default="ModOrganizer.exe")
    ap.add_argument("--loader-exe", default="skse64_loader.exe")
    ap.add_argument("--poll", type=float, default=5.0)
    ap.add_argument("--settle", type=float, default=15.0, help="seconds the game must stay gone before copy-back")
    ap.add_argument("--appear-timeout", type=float, default=16 * 60)
    ap.add_argument("--no-game-grace", type=float, default=45.0, help="seconds to wait after the launch command ends with no game process")
    ap.add_argument("--lock-wait", type=float, default=240.0, help="wait this long for a lock held by a live launcher")
    ap.add_argument("--launch-cmd-json", help="sandbox only: JSON list replacing the play_test_profile.ps1 command")
    return ap


def cfg_from_args(argv):
    """Build a Cfg from command-line style arguments (roundtrip_swap_plan.py uses the same paths and names)."""
    return make_cfg(build_parser().parse_args(list(argv)))


def main(argv=None):
    ap = build_parser()
    a = ap.parse_args(argv)
    c = make_cfg(a)
    try:
        if a.status:
            return cmd_status(c)
        if a.init:
            return cmd_init(c, a.baseline_dir, a.luc_ini, a.force)
        if a.reset_live:
            return cmd_reset_live(c)
        if not c.profile:
            ap.error("--profile is required")
        return cmd_recover(c) if a.recover else cmd_launch(c)
    except Refused as e:
        log(c, "REFUSED: %s" % e)
        return EXIT_REFUSED
    except Failed as e:
        log(c, "FAILED: %s" % e)
        return EXIT_COPYBACK


if __name__ == "__main__":
    sys.exit(main())
