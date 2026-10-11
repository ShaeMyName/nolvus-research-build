"""U3 block "restarts + watches", part 1: shared helpers and the restart tests (step8_time_plan.md §5 U3 row :380, §3.5
:257-280; spec rows BRIDGE_SPEC_V2.md D-3 :3460, Q-10 :1537, CS-27 :2180, EN-4 :2355, MA-7 :2351; K-M2
investigation/round6/kinship_maras.md:127). Written 2026-10-11, not yet run. House style: tests_u2.py / tests_misc.py.

HOW A RESTART TEST IS BUILT (and why it is a test, not its own block): block.py launches the game and loads ONE save per
block, and its run loop treats "game not running after a test" as a crash. A patch off/on pair needs two launches with
different configs inside one result, so each restart test drives game.close / game.launch itself:
  precondition checks (current launch) -> checkpoint(r) -> [arm in the current launch, if it is the normal config]
  -> close (game + MO2 gone) -> backup -> write -> assert -> launch -> load -> arm -> close -> restore -> assert
  -> launch -> load the block save.
The test always ENDS with the normal config restored and the block save loaded, so block.py's crash/defeat/IE checks
after it hold. block.py's control Run (`ctl`) keeps its old MCP session after such a test; it is only used for
fire-and-forget calls, logging and a fresh relaunch, EXCEPT for the reload of reload=True tests. So every restart test is
reload=False and the restart groups sit in their OWN small blocks (U3R, U3MR) where no reload=True test follows them.
A restore that cannot be asserted raises RestoreFailed (a BaseException): the block aborts instead of running on a
changed config.

Writes (all with the game AND MO2 closed, each backed up to backups/u3_swaps/ first and asserted after the restore):
  - profiles/SkyrimNet Test/modlist.txt only ('+'/'-' of one named line). The "Nolvus Awakening" profile is never
    written; its modlist is hashed before and after every swap and a change is a FAIL.
  - Q-10's quest_integrity.json swap (our own patch-B mod): gated by Q10_SWAP_APPROVED (not on the approved write list).
Counts only in logs: no MARAS.log line, quest text, quest EditorID or JSON content is ever printed. NPC display names
are read for regex use only.

New IEB_TestCtl functions used here (inserted before PlayerPlace, runner.CTL_DONE entries added): U3MarasProbe,
U3MarasLog, U3GiftRank, U3ExecAction, U3StewardProbe. Reused from the T0-M builder: MarasSet (MARAS natives)."""
import hashlib, json, os, re, shutil, time
import game
from mcp_client import MCP
from block import test, checkpoint, settle_probe, ie_test_settings, phase
from fidnorm import fid_any_rx, fid_hex8
from tests_misc import (F1, YSOLDA, CARLOTTA, DEST_NEAR, ctl_line, inc, s32, who, rval, parse_kv, iv, tail, qr, errand,
                        recall, watch_last, snapshot_sync, KV)

# ---------------------------------------------------------------------------- configuration
VOICES = False          # U3 blocks are text/state blocks (DECISIONS:410); must match blocks_def
MODS = "C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/"
MODLIST = game.PROFILE_DIR + "modlist.txt"                       # the TEST profile (allowed write)
NA_MODLIST = "C:/Nolvus/Instances/Nolvus Awakening/MODS/profiles/Nolvus Awakening/modlist.txt"   # hashed, never written
BACKUP_DIR = "C:/nolvus-research/backups/u3_swaps/"
SHOTS = "C:/nolvus-research/test_runs/U3_shots/"
MARAS_LOG = game.DOCS + "SKSE/MARAS.log"        # MARAS plugin.cpp:55-67 (SKSE log dir, 'MARAS.log'); VERIFIED on disk
PATCH_B = "IE NoWipe + Dispatch Guard"           # patch B (IntelEngine scripts + quest_integrity.json); modlist.txt:12
REL_PATCH = "SkyrimNet Relationships - Private Patch"   # our Relationships patch (SNRom_Bridge/Decorators pex); :16
MARAS_CONFIG = "MARAS Config"                    # our PackageOverrides.ini (AllowedPlugins + IntelEngine.esp,
                                                 # QuestPriority=256, QuestWhitelist lines); modlist.txt:10
QI_JSON = MODS + PATCH_B + "/SKSE/Plugins/ErrandBridge/quest_integrity.json"   # IntelEngine_StoryEngine.psc:5295
SANDBOX_EDID = "TTM_SpouseHomeSandbox"           # MARAS home sandbox (TT_MARAS.esp PACK 0x6A, spec §11.12.1 :2236)

# D-3: the spec says "Disable patch B (baseline Caprica build)". No Caprica-baseline MO2 mod is installed (MODS\mods has
# none; build/bin/baseline holds 3 loose pex only) and creating one is a write outside the approved list. So D-3 runs
# on STOCK IntelEngine scripts (patch B's mod unticked). Set this to an installed mod name to swap it in instead.
D3_BASELINE_MOD = None
# Q-10 writes in our own patch-B mod folder (rename/misspell quest_integrity.json). Not on the C:\Nolvus write list
# (REVIEW_LOG RV-91-corr): stays a stub until Shae/the reviewer approve it, same reasoning as the 0210 rename.
Q10_SWAP_APPROVED = False
# CS-27 needs (1) SNRom_Sparked = 1 written on an enrolled CHILD (the harness's own SUSetInt guard refuses that key on a
# child by design) and (2) a session of STOCK Relationships (no child gates: R10 adult prompts possible) with that child
# enrolled. Both are child-safety calls for Shae, so CS-27 is a stub; no code path writes either.
CS27_SETUP_APPROVED = False

# T0-M cast (step8_time_plan.md:369). build_t0m.py fills these in; a None entry makes the tests that need it
# INCONCLUSIVE. Reference FormIDs (ints).
T0M = {
    "spouse1": None,          # RDO-dialogue NPC, married; released from the MARAS house + SA home/work posts (MA-4/MA-6)
    "spouse2": None,          # married, housed by MARAS (Breezehome), unposted, not following (MA-3/5/7, K-M2, DA-9)
    "engaged": None,          # MARAS engaged NPC (MA-2a)
    "lydia": None,            # housecarl
    "follower_spouse": None,  # a spouse who is also an NFF follower (K-M3); None if T0-M has none
    "rdo_friend": None,       # a friend whose RDO recruit/gift lines are in her menu (DA-9 parts 3-4)
}
EN4_CANDIDATES = (YSOLDA, CARLOTTA)   # EN-4's fresh fiancé: first loaded adult with no MARAS status, not enrolled
EN4_SAVE = "IEB_EN4_pre"              # throwaway save in the test profile (IEB_* convention)


class RestoreFailed(BaseException):
    """A config restore could not be asserted: abort the block (call_test only catches Exception)."""


def sha(path):
    return hashlib.sha256(open(path, "rb").read()).hexdigest() if os.path.exists(path) else None


# ---------------------------------------------------------------------------- game close / relaunch
def wait_closed(r, timeout=180):
    """Close the game if it runs, then wait until SkyrimSE, MO2 and the loader are all gone."""
    if "SkyrimSE.exe" in game.procs():
        game.close(r)
    t0 = time.time()
    while game.procs() and time.time() - t0 < timeout:
        time.sleep(3)
    if game.procs():
        r.log("  CLOSE: still running %s after %d s" % (sorted(game.procs()), timeout))
        return False
    return True


def relaunch(r, save, why):
    """Launch the test profile (no voices), load `save`, settle, apply the IE test settings, refresh r's MCP session.
    The game must already be closed (wait_closed)."""
    phase("%s RELAUNCH" % r.name)      # heartbeat: a long relaunch inside a test is not a stuck phase
    r.log("  RELAUNCH for %s: %s" % (save, why))
    if game.procs() and not wait_closed(r):
        return False
    if not game.launch(r.log, voices=VOICES):
        r.log("  RELAUNCH: launch failed")
        return False
    try:
        r.c = MCP()
    except Exception as e:      # noqa: BLE001
        r.log("  RELAUNCH: MCP session failed: %r" % (e,))
        return False
    if not game.load(r, save, settle_probe(r)):
        r.log("  RELAUNCH: load %s failed" % save)
        return False
    ie_test_settings(r)
    phase(r.name)
    return True


def back_to(r, save):
    """End state of every restart test: normal config, `save` loaded. Every restore closes the game first
    (restore_bytes), so a game that is still running already runs the normal config: a plain load is enough then;
    otherwise launch. Logged, never raises."""
    if "SkyrimSE.exe" in game.procs():
        ok = game.load(r, save, settle_probe(r))
        if ok:
            ie_test_settings(r)
    else:
        ok = relaunch(r, save, "back to the block save with the normal config")
    if not ok:
        r.log("  WARN could not reload %s after the restore; block.py's crash path will relaunch" % save)
    return ok


def session_text(key="papyrus"):
    """The whole current-session log (Papyrus.0.log rotates on every launch)."""
    p = game.LOGS[key]
    return open(p, "rb").read().decode("utf-8", "replace") if os.path.exists(p) else ""


# ---------------------------------------------------------------------------- config swaps (game + MO2 closed)
def _backup(path, tag):
    os.makedirs(BACKUP_DIR, exist_ok=True)
    dst = BACKUP_DIR + "%s_%s_%s" % (tag, time.strftime("%Y%m%d-%H%M%S"), os.path.basename(path))
    shutil.copy2(path, dst)
    return dst


def _line_rx(name):
    return re.compile(rb"(?m)^([+-])" + re.escape(name.encode("utf-8")) + rb"(\r?)$")


def modlist_state(name):
    """'+' / '-' for a mod line of the TEST profile's modlist, or None if it is not there exactly once."""
    b = open(MODLIST, "rb").read()
    found = _line_rx(name).findall(b)
    return found[0][0].decode() if len(found) == 1 else None


def modlist_set(r, changes, tag):
    """changes = {mod name: True (enabled) / False}. Game and MO2 must be closed. Backs the file up, rewrites only the
    '+'/'-' of each named line, asserts the result, re-snapshots the profile (game.profile_snapshot, so a forced MO2
    close later compares against this state). Returns the original bytes (for restore_bytes) or None."""
    if "/profiles/SkyrimNet Test/" not in MODLIST.replace("\\", "/"):
        raise RestoreFailed("modlist path is not the SkyrimNet Test profile: %s" % MODLIST)
    if game.procs():
        r.log("  SWAP refused: %s still running" % sorted(game.procs()))
        return None
    orig = open(MODLIST, "rb").read()
    new = orig
    for name, on in changes.items():
        rx = _line_rx(name)
        if len(rx.findall(new)) != 1:
            r.log("  SWAP refused: '%s' not exactly once in the test modlist" % name)
            return None
        new = rx.sub(lambda m: (b"+" if on else b"-") + name.encode("utf-8") + m.group(2), new)
    bk = _backup(MODLIST, tag)
    with open(MODLIST, "wb") as f:
        f.write(new)
    ok = all(modlist_state(n) == ("+" if on else "-") for n, on in changes.items())
    r.log("  SWAP %s: modlist %s (backup %s) -> %s" % (tag, ", ".join("%s %s" % ("on" if on else "off", n) for n, on in
                                                                     changes.items()), os.path.basename(bk),
                                                     "verified" if ok else "WRITE FAILED"))
    game.profile_snapshot()
    if not ok:
        restore_bytes(r, MODLIST, orig, tag)
        return None
    return orig


def restore_bytes(r, path, orig, tag):
    """Write the original bytes back (game + MO2 closed) and assert them byte for byte; RestoreFailed otherwise."""
    if not wait_closed(r):
        raise RestoreFailed("%s: cannot restore %s, the game/MO2 did not close" % (tag, os.path.basename(path)))
    with open(path, "wb") as f:
        f.write(orig)
    ok = open(path, "rb").read() == orig
    r.log("  RESTORE %s: %s %s" % (tag, os.path.basename(path), "verified (byte-identical)" if ok else "FAILED"))
    if path == MODLIST:
        game.profile_snapshot()
    if not ok:
        raise RestoreFailed("%s: %s not restored" % (tag, path))
    return True


class NAGuard:
    """Hash of the "Nolvus Awakening" profile's modlist before a swap; after it must be unchanged (never written)."""

    def __init__(self, r):
        self.r, self.h = r, sha(NA_MODLIST)

    def check(self):
        same = sha(NA_MODLIST) == self.h
        self.r.check(same, "Nolvus Awakening profile modlist unchanged (hash)")
        return same


# ---------------------------------------------------------------------------- MARAS / cast helpers
def cast(r, key):
    fid = T0M.get(key)
    if fid is None:
        inc(r, "T0-M cast entry '%s' is not set (build_t0m.py fills tests_u3.T0M)" % key)
    return fid


def maras_probe(r, fid):
    """U3MarasProbe: status / housed-faction rank / tenant house / teammate / package / name (name for regex only)."""
    m = ctl_line(r, "U3MarasProbe", [s32(fid)], r"(?i)\[IEB-TEST\] U3MARASPROBE (\S+) (.*)", 15)
    if not m or m.group(1).lower() == "none":
        return None
    return parse_kv(m.group(2))


def maras_debug(r):
    """MARAS log level Debug (MARAS.SetLogLevel(1), MARAS.psc:352; levels LoggingService.cpp:49-70). Its hook lines are
    DEBUG (PackageOverrideService.cpp:323-465), so without this every 'no line' check is vacuous."""
    m = ctl_line(r, "U3MarasLog", [1], r"(?i)\[IEB-TEST\] U3MARASLOG level=(-?\d+)", 15)
    ok = bool(m) and m.group(1) == "1"
    if not ok:
        inc(r, "MARAS log level could not be set to Debug (%s)" % (m.group(0) if m else "no line"))
    return ok


MARAS_ENUM = {"candidate": 0, "engaged": 1, "married": 2, "divorced": 3, "jilted": 4}   # IEB_TestCtl.MarasSet doc;
                                                                                          # -1 = not registered


def status_is(mp, name):
    """MARAS status of a U3MarasProbe dict: the enum (st=) first, the name as a fallback."""
    if not mp:
        return False
    if "st" in mp:
        return iv(mp, "st", -9) == MARAS_ENUM.get(name, -9)
    return mp.get("status", "").lower() == name


def maras_promote(r, fid, status):
    """MARAS status change through the T0-M builder's TestCtl.MarasSet (MARAS natives RegisterCandidate /
    PromoteNPCToStatusByEnum, the call the dialogue fragments make: TTM_DialogueManagerMisc.psc:14-23 per its doc).
    Registers an unregistered actor as a candidate first. Returns the U3MarasProbe dict after, or None."""
    mp = maras_probe(r, fid)
    if not mp:
        return None
    if iv(mp, "st", -1) < 0 and status != "candidate":
        ctl_line(r, "MarasSet", [s32(fid), 0], r"\[IEB-TEST\] T0M_SET [^\n]*", 20)
    ctl_line(r, "MarasSet", [s32(fid), MARAS_ENUM[status]], r"\[IEB-TEST\] T0M_SET [^\n]*", 20)
    time.sleep(2)
    return maras_probe(r, fid)


def gift_rank(r, fid, value=-99):
    """RDO gift counter (faction 0xED7778 in Relationship Dialogue Overhaul.esp, read by IEB_RankSync.Apply:136): set it
    to `value` (>= 0) or only read it (-99). Returns the rank read back, or None."""
    m = ctl_line(r, "U3GiftRank", [s32(fid), int(value)], r"(?i)\[IEB-TEST\] U3GIFT (\S+) rank=(-?\d+)", 15)
    return int(m.group(2)) if m else None


# MARAS hook lines (PackageOverrideService.cpp, VERIFIED format strings :323-465). Actor ids print as {:08X}.
def maras_counts(text, fid):
    """Counts of MARAS PackageStartHook lines for one actor, plus the package FormIDs they name. Never the lines."""
    a = fid_hex8(fid)
    pk = r"'[^'\n]*' \(([0-9A-F]{8})\)"
    rx = {
        "suppress": r"PackageStartHook: suppressing %s on actor %s\b" % (pk, a),
        "allow_quest": r"PackageStartHook: allowing %s on actor %s \(quest whitelist" % (pk, a),
        "allow_prio": r"PackageStartHook: allowing %s on actor %s, quest priority" % (pk, a),
        "allow_plugin": r"PackageStartHook: allowing plugin-whitelisted %s on actor %s\b" % (pk, a),
        "allow_wl": r"PackageStartHook: allowing whitelisted %s on actor %s\b" % (pk, a),
    }
    out = {k: re.findall(v, text) for k, v in rx.items()}
    c = {k: len(v) for k, v in out.items()}
    c["pkgs"] = {k: sorted(set(v)) for k, v in out.items() if v}
    c["follower_skip"] = len(re.findall(r"PackageStartHook: actor %s is a follower, skipping sandbox override" % a, text))
    c["any"] = len(re.findall(r"PackageStartHook:[^\n]*\b%s\b" % a, text))
    return c


def maras_tail():
    return game.Tail(MARAS_LOG)


def probe_raw(r, fid, timeout=10):
    """IEB_TestCtl.Probe (Watcher.Line + keys): (dict of the k=v fields, the raw line). pkg is '<hex>:<EditorID>'."""
    m = ctl_line(r, "Probe", [s32(fid)], r"\[IEB-TEST\] probe [^\n]*%s cell=[^\n]*" % fid_any_rx(fid), timeout)
    if not m:
        return None, ""
    line = m.group(0)
    d = dict(KV.findall(line))
    mc = re.search(r"\bcell=(\S+?):", line)
    d["cellhex"] = mc.group(1) if mc else "None"
    return d, line


def pkg_hex(d):
    return (d or {}).get("pkg", "None").split(":")[0]


def pkg_edid(d):
    p = (d or {}).get("pkg", "None")
    return p.split(":", 1)[1] if ":" in p else ""


def screenshot(tag):
    """Full-screen capture for Shae (MA-2 boxes, Q-10 notice): path or None. PIL as r29_save_cells.py:88-95."""
    try:
        from PIL import ImageGrab
        os.makedirs(SHOTS, exist_ok=True)
        f = SHOTS + "%s_%s.png" % (tag, time.strftime("%H%M%S"))
        ImageGrab.grab().save(f)
        return f
    except Exception:   # noqa: BLE001
        return None


def errand_arm(r, fid, name, timeout):
    """One player-requested GoToLocation for a non-follower (TestCtl.StartTask, DEST_NEAR), watched for `timeout` s:
    arrival line (IE_Travel:642 'IntelEngine: <name> arrived at', VERIFIED) + MARAS hook counts for the actor; then the
    task is cancelled (TestCtl.Cancel). Returns a dict of counts/booleans only."""
    t_pap, t_mar = tail("papyrus"), maras_tail()
    t0 = time.time()
    r.ctl("StartTask", [s32(fid), "GoToLocation", DEST_NEAR, "", ""])
    q = None
    for _ in range(6):
        q = qr(r, fid)
        if q and iv(q, "slot") >= 0:
            break
        time.sleep(3)
    started = bool(q) and iv(q, "slot") >= 0
    arrived = t_pap.wait(r"IntelEngine: %s arrived at " % re.escape(name), timeout=timeout) if started else None
    pk, _ = probe_raw(r, fid)
    c = maras_counts(t_mar.read(), fid)
    secs = time.time() - t0
    r.ctl("Cancel", [s32(fid)])
    time.sleep(3)
    return dict(started=started, arrived=bool(arrived), secs=int(secs), counts=c, pkg_end=pkg_hex(pk),
                sandbox_end=pkg_edid(pk) == SANDBOX_EDID)


# ============================================================================ D-3 (spec §15.3 :3460)

@test("D-3", "D")
def d3(r):
    """Patch B disabled, repeat D-1: F1 held on an errand, Dispatch(F1, story). Pass: the bridge's DISPATCH_CONFLICT for
    F1 (IEB_Main.DispatchConflict :428-439, VERIFIED log text), F1 holds no IE slot afterwards ('both slots cancelled'),
    and the watcher's slotCount for F1 is back to <= 1 within 2 ticks (I1; ticks ~3 s, held_gap note in block.py).
    INFERRED: (1) stock IntelEngine (patch B's mod unticked, see D3_BASELINE_MOD) stands in for the Caprica baseline;
    (2) the TAKE still happens without patch B's TaskStarted event (the bridge's tick scan finds the agent alias);
    (3) 2 ticks = 10 s of wall time. Restart: one patch-off launch + the restore launch. reload=False (ends on a fresh
    T0 load)."""
    u, name, _ = who(r, F1)
    if not name:
        return inc(r, "F1 not loaded")
    if modlist_state(PATCH_B) != "+":
        return inc(r, "patch B's mod is not enabled exactly once in the test modlist (state %s)" % modlist_state(PATCH_B))
    if D3_BASELINE_MOD and modlist_state(D3_BASELINE_MOD) != "-":
        return inc(r, "baseline mod '%s' not present (disabled) exactly once" % D3_BASELINE_MOD)
    na = NAGuard(r)
    checkpoint(r, "patch B off launch + restore launch")
    changes = {PATCH_B: False}
    if D3_BASELINE_MOD:
        changes[D3_BASELINE_MOD] = True
    orig = None
    try:
        if not wait_closed(r):
            return inc(r, "the game did not close for the swap")
        orig = modlist_set(r, changes, "D3")
        if orig is None:
            return inc(r, "modlist swap refused")
        if not relaunch(r, "T0", "patch B off"):
            return inc(r, "patch-off launch/load failed")
        u, name, _ = who(r, F1)
        if not name:
            return inc(r, "F1 not loaded in the patch-off session")
        snapshot_sync(r, F1)
        if not errand(r, F1, name, DEST_NEAR):
            return inc(r, "no TAKE for F1 within 90 s without patch B")
        try:
            t = tail("papyrus")
            r.ctl("Dispatch", [F1, "story"])
            m = t.wait(r"\[IEB\] DISPATCH_CONFLICT actor=%s\b" % re.escape(name), timeout=60)
            r.check(bool(m), "bridge DISPATCH_CONFLICT for F1 without patch B")
            r.check(not re.search(r"Story DM: %s is busy or with the player - dispatch refused" % re.escape(name),
                                  t.read()), "no patch-B refusal line (patch B really off)")
            time.sleep(10)
            q = qr(r, F1)
            r.check(q is not None and iv(q, "slot") < 0, "both slots cancelled: F1 holds no IE slot (slot=%s)"
                    % (q and q.get("slot")))
            w = watch_last(r, F1)
            r.check(w is not None and iv(w, "slotCount", 9) <= 1, "I1: watcher slotCount <= 1 within 2 ticks (%s)"
                    % (w and w.get("slotCount")))
        finally:
            recall(r, F1, name)
    finally:
        if orig is not None:
            restore_bytes(r, MODLIST, orig, "D3")
            na.check()
        back_to(r, "T0")


# ============================================================================ EN-4 (spec :2355) and CS-27 (:2180)

@test("EN-4", "EN")
def en4(r):
    """A MARAS fiancé made BEFORE our Relationships patch is enrolled on the next sweep after the patch is back
    (patch M4' IEB_MarasCatchUp, SNRom_Bridge.psc:8796-; 'Enrolled on MARAS courtship:' :8790, VERIFIED; at most 2 per
    sweep, budget = 2 VERIFIED there). Steps: patch-off launch on T0 -> a loaded adult with no MARAS status is made
    engaged by MARAS natives (TestCtl.MarasSet: RegisterCandidate + PromoteNPCToStatusByEnum) -> save IEB_EN4_pre -> patch on ->
    load IEB_EN4_pre -> snrom.log enrollment line for her within 5 min, SNRom_Bond rank >= 0.
    INFERRED: (1) native promotion = the dialogue engagement for this purpose (same INFERRED equivalence as T0-M);
    (2) a sweep runs within 5 min of the load; (3) '<= 2 per sweep' is checked only as 'at most 2 courtship enrolments in
    total after the load' (sweep boundaries are not logged). Child safety: the patch-off session runs for minutes with
    no conversation and GameMaster off (U3); no child is touched. reload=False (ends on a fresh T0 load)."""
    if modlist_state(REL_PATCH) != "+":
        return inc(r, "Relationships patch not enabled exactly once in the test modlist")
    cand = None
    for fid in EN4_CANDIDATES:
        u, name, child = who(r, fid)
        if not u or child:
            continue
        mp = maras_probe(r, fid)
        tier = iv({"v": rval(r, u, 'get_faction_rank(actorUUID, "SNRom_Bond")')}, "v")
        if mp and iv(mp, "st", 0) == -1 and tier < 0:
            cand = (fid, name)
            break
    if not cand:
        return inc(r, "no loaded adult without MARAS status and not enrolled among the EN-4 candidates")
    fid, name = cand
    na = NAGuard(r)
    checkpoint(r, "patch-off launch, MARAS engagement, save, patch-on launch")
    orig = None
    try:
        if not wait_closed(r):
            return inc(r, "the game did not close for the swap")
        orig = modlist_set(r, {REL_PATCH: False}, "EN4")
        if orig is None:
            return inc(r, "modlist swap refused")
        if not relaunch(r, "T0", "Relationships patch off"):
            return inc(r, "patch-off launch/load failed")
        p = maras_promote(r, fid, "engaged")
        r.log("  pre-patch engagement: status enum %s" % (p.get("st") if p else "no probe"))
        if not status_is(p, "engaged"):
            return inc(r, "MARAS native engagement did not take in the patch-off session")
        time.sleep(5)
        u, _, _ = who(r, fid)
        if iv({"v": rval(r, u, 'get_faction_rank(actorUUID, "SNRom_Bond")')}, "v") >= 0:
            return inc(r, "stock Relationships enrolled the fiancé itself: no pre-patch state to test")
        if not game.save(r, EN4_SAVE):
            return inc(r, "pre-patch save failed")
        restore_bytes(r, MODLIST, orig, "EN4")
        orig = None
        na.check()
        st = tail("snrom")
        if not relaunch(r, EN4_SAVE, "Relationships patch on, the pre-patch fiancé save"):
            return inc(r, "patch-on launch/load of the pre-patch save failed")
        m = st.wait(r"Enrolled on MARAS courtship:[^\n]*%s" % re.escape(name), timeout=300)
        n = len(re.findall(r"Enrolled on MARAS courtship:", st.read()))
        r.check(bool(m), "fiancé enrolled on a sweep after the load ('Enrolled on MARAS courtship:')")
        u, _, _ = who(r, fid)
        tier = iv({"v": rval(r, u, 'get_faction_rank(actorUUID, "SNRom_Bond")')}, "v") if u else -9
        r.check(tier >= 0, "SNRom_Bond rank >= 0 after the sweep (%d)" % tier)
        r.log("  courtship enrolments after the load: %d" % n)
        if n <= 2:
            r.check(True, "at most 2 courtship enrolments after the load (%d)" % n)
        else:
            inc(r, "%d courtship enrolments: more than one sweep ran, the per-sweep cap is not readable" % n)
    finally:
        if orig is not None:
            restore_bytes(r, MODLIST, orig, "EN4")
            na.check()
        back_to(r, "T0")


@test("CS-27", "CS")
def cs27(r):
    """Save with a sparked child (pre-patch), load with the patch: the child sweep un-sparks, locks intimacy, keeps the
    enrolment (SNRom_Bridge.psc:8738-8757 'Child sweep: un-sparked ...', VERIFIED). STUB: building the pre-patch state
    needs SNRom_Sparked = 1 written on an enrolled child (IEB_TestCtl.SUSetInt refuses that key on a child by design) and
    a stock-Relationships session with the child enrolled (no child gates). Both are child-safety calls for Shae."""
    checkpoint(r)
    if not CS27_SETUP_APPROVED:
        return inc(r, "child-safety ruling needed (FOR_SHAE): the pre-patch sparked-child state can't be built without "
                      "writing SNRom_Sparked on a child and running stock Relationships with the child enrolled")
    inc(r, "CS27_SETUP_APPROVED is set but no setup route is written yet")


# ============================================================================ Q-10 (spec :1537)

def _qi_lines(text):
    return (len(re.findall(r"\[IEB\] quest_integrity OK:", text)),
            len(re.findall(r"\[IEB\] WARN quest_integrity:", text)),
            len(re.findall(r"\[IEB\] WARN quest_integrity: [^\n]*story_quests resolved 0 of", text)),
            len(re.findall(r"\[IEB\] WARN quest_integrity: file missing", text)))


@test("Q-10", "Q")
def q10(r):
    """Self-check failure path (IntelEngine_StoryEngine.IEB_QISelfCheck :5337-5361, run from Core.Maintenance on every
    load :217-220, VERIFIED): (a) real JSON (this launch): an OK line, no WARN; (b) JSON removed: WARN 'file missing';
    (c) misspelt list key ('story_quests' -> 'story_qeusts'): WARN 'story_quests resolved 0 of'; then the original
    bytes are restored (sha256 asserted) and (d) an OK line again. Each WARN load also gets a screenshot for Shae (the
    on-screen notification, Debug.Notification right after the WARN trace :5356-5357; the WARN line is the automated
    proof). INFERRED: JsonUtil re-reads the file on a fresh launch (cache is per session). The JSON is never printed.
    Gated: Q10_SWAP_APPROVED (writes in our own patch-B mod folder are not on the approved write list)."""
    ok_n, warn_n, _, _ = _qi_lines(session_text())
    if not os.path.exists(QI_JSON):
        return inc(r, "quest_integrity.json not found in patch B's mod")
    raw = open(QI_JSON, "rb").read()
    try:
        doc = json.loads(raw)
        lists = doc["formList"]
        if "story_quests" not in lists:
            raise KeyError("story_quests")
    except (ValueError, KeyError, TypeError):
        return inc(r, "quest_integrity.json has no formList 'story_quests' to misspell")
    lists["story_qeusts"] = lists.pop("story_quests")       # JsonUtil layout: {"formList": {...}, "int": {...}, ...}
    misspelt = json.dumps(doc).encode("utf-8")
    if not Q10_SWAP_APPROVED:
        checkpoint(r)
        r.check(ok_n >= 1 and warn_n == 0, "(a) real JSON: quest_integrity OK line, no WARN (this session)")
        return inc(r, "(b)-(d) need the quest_integrity.json swap, awaiting approval (not on the C:\\Nolvus write list)")
    want = sha(QI_JSON)
    na = NAGuard(r)
    checkpoint(r, "two broken-JSON launches + the restore launch")
    r.check(ok_n >= 1 and warn_n == 0, "(a) real JSON: quest_integrity OK line, no WARN (this session)")
    off = QI_JSON + ".u3off"
    touched = False
    try:
        if not wait_closed(r):
            return inc(r, "the game did not close for the swap")
        _backup(QI_JSON, "Q10")
        touched = True
        os.replace(QI_JSON, off)
        r.log("  SWAP Q10: JSON moved aside (%s)" % ("verified" if not os.path.exists(QI_JSON) else "FAILED"))
        if os.path.exists(QI_JSON) or not relaunch(r, "T0", "JSON removed"):
            return inc(r, "(b) launch without the JSON failed")
        _, _, _, miss = _qi_lines(session_text())
        r.check(miss >= 1, "(b) JSON removed: WARN 'file missing' on the load")
        r.log("  (b) screenshot: %s" % screenshot("Q10_missing"))
        if not wait_closed(r):
            return inc(r, "the game did not close for the second swap")
        with open(QI_JSON, "wb") as f:
            f.write(misspelt)
        r.log("  SWAP Q10: misspelt list key written (%s)" % ("verified" if sha(QI_JSON) != want else "FAILED"))
        if not relaunch(r, "T0", "misspelt JSON"):
            return inc(r, "(c) launch with the misspelt JSON failed")
        _, _, zero, _ = _qi_lines(session_text())
        r.check(zero >= 1, "(c) misspelt list: WARN 'story_quests resolved 0 of' on the load")
        r.log("  (c) screenshot: %s" % screenshot("Q10_misspelt"))
    finally:
        if touched:
            if not wait_closed(r):
                raise RestoreFailed("Q-10: game/MO2 did not close for the JSON restore")
            with open(QI_JSON, "wb") as f:
                f.write(raw)
            if os.path.exists(off):
                os.remove(off)
            good = sha(QI_JSON) == want
            r.log("  RESTORE Q10: quest_integrity.json %s" % ("verified (sha256 equal)" if good else "FAILED"))
            if not good:
                raise RestoreFailed("Q-10: quest_integrity.json not restored")
            na.check()
        if back_to(r, "T0") and touched:
            ok_n, warn_n, _, _ = _qi_lines(session_text())
            r.check(ok_n >= 1 and warn_n == 0, "(d) restored JSON: OK line again, no WARN")


# ============================================================================ MA-7 + K-M2 stall (one MARAS-config-off launch)

_OFF = {}       # MA-7 / K-M2 share one launch with "MARAS Config" unticked


def _ma7_arm(r, sp, label):
    """QPFill the housed spouse into the synthetic story quest's alias (ErrandBridgeTest.esp 0x820, TestCtl.QPFill),
    read MARAS's hook lines and the live package, clear the alias, read again. Counts and FormIDs only."""
    t_mar = maras_tail()
    m = ctl_line(r, "QPFill", [s32(sp)], r"\[IEB-TEST\] QPFill [^\n]*pkg=(\S+)", 15)
    time.sleep(10)
    p_fill, _ = probe_raw(r, sp)
    c = maras_counts(t_mar.read(), sp)
    t_mar.mark()
    ctl_line(r, "QPClear", [], r"\[IEB-TEST\] QPClear [^\n]*", 15)
    time.sleep(8)
    p_clear, _ = probe_raw(r, sp)
    out = dict(filled=bool(m), counts=c, pkg_fill=pkg_hex(p_fill), sandbox_fill=pkg_edid(p_fill) == SANDBOX_EDID,
               pkg_clear=pkg_hex(p_clear), sandbox_clear=pkg_edid(p_clear) == SANDBOX_EDID)
    r.log("  MA-7 %s: fill pkg %s (sandbox %s), clear pkg %s (sandbox %s), MARAS lines: suppress %d, allow-quest %d, "
          "packages %s" % (label, out["pkg_fill"], out["sandbox_fill"], out["pkg_clear"], out["sandbox_clear"],
                           c["suppress"], c["allow_quest"], c["pkgs"]))
    return out


def _maras_preconditions(r):
    """(spouse2 fid, name) when spouse2 is married, housed, not following and loaded; else None (INCONCLUSIVE)."""
    sp = cast(r, "spouse2")
    if sp is None:
        return None
    mp = maras_probe(r, sp)
    if not mp:
        inc(r, "spouse2 not found by U3MarasProbe")
        return None
    if not status_is(mp, "married") or iv(mp, "housed", -2) < 0 or iv(mp, "tm") != 0:
        inc(r, "spouse2 is not a housed, non-following MARAS spouse (status %s housed %s tm %s)"
            % (mp.get("st"), mp.get("housed"), mp.get("tm")))
        return None
    if modlist_state(MARAS_CONFIG) != "+":
        inc(r, "'MARAS Config' not enabled exactly once in the test modlist")
        return None
    return sp, mp.get("name", "")


def _maras_off_session(r, sp, name):
    """One launch with 'MARAS Config' unticked: MARAS then reads its shipped PackageOverrides.ini (MARAS mod,
    PackageOverrides.ini:50-52: AllowedPlugins=nwsFollowerFramework.esp, '; QuestPriority=61' commented, no
    QuestWhitelist; VERIFIED). That is MA-7's 'QuestPriority commented out' config AND K-M2's 'without IntelEngine.esp'
    config at once. Runs MA-7's off arm, then K-M2's stall arm; always restores, asserts and reloads T0-M."""
    if _OFF:
        return _OFF
    na = NAGuard(r)
    orig = None
    try:
        if not wait_closed(r):
            _OFF["error"] = "the game did not close for the swap"
            return _OFF
        orig = modlist_set(r, {MARAS_CONFIG: False}, "MA7")
        if orig is None:
            _OFF["error"] = "modlist swap refused"
            return _OFF
        if not relaunch(r, "T0-M", "MARAS Config off (shipped PackageOverrides.ini)"):
            _OFF["error"] = "MARAS-config-off launch/load failed"
            return _OFF
        if not maras_debug(r):
            _OFF["error"] = "MARAS Debug log level not set in the off session"
            return _OFF
        _OFF["ma7"] = _ma7_arm(r, sp, "off")
        _OFF["km2"] = errand_arm(r, sp, name, timeout=150)
        k = _OFF["km2"]
        r.log("  K-M2 stall arm: started %s, arrived %s in %d s, MARAS suppress %d, allow-plugin %d, sandbox at end %s"
              % (k["started"], k["arrived"], k["secs"], k["counts"]["suppress"], k["counts"]["allow_plugin"],
                 k["sandbox_end"]))
    finally:
        if orig is not None:
            restore_bytes(r, MODLIST, orig, "MA7")
            na.check()
        back_to(r, "T0-M")
    return _OFF


@test("MA-7", "MA", save="T0-M")
def ma7(r):
    """Quest packages on a housed spouse (spec :2351, §11.12.1 rule 8). The housed, non-following spouse2 is force-filled
    into the synthetic story quest's alias (QPFill; its EditorID is in our QuestWhitelist). ON (S-26 config, this
    launch): MARAS allows the package via the quest whitelist ('allowing ... (quest whitelist', :451) and the alias
    package runs (current package is not the sandbox). OFF ('MARAS Config' unticked = QuestPriority commented out):
    'suppressing ... on actor' (:457/:465) and the current package is TTM_SpouseHomeSandbox. Alias cleared: back to
    the sandbox in both. MARAS log level set to Debug (U3MarasLog) in each session. FormIDs and counts only.
    INFERRED: (1) unticking 'MARAS Config' is the 'QuestPriority commented out' config (it also drops our
    AllowedPlugins/QuestWhitelist lines: shipped INI); (2) 10 s after QPFill the hook has seen the package start.
    Restart: the off launch + the restore launch (shared with K-M2). reload=False (ends on a fresh T0-M load)."""
    pre = _maras_preconditions(r)
    if not pre:
        return
    sp, name = pre
    checkpoint(r, "MA-7 on arm, then the MARAS-config-off launch shared with K-M2")
    if not maras_debug(r):
        return
    on = _ma7_arm(r, sp, "on")
    r.check(on["filled"], "on: QPFill ran")
    r.check(on["counts"]["allow_quest"] >= 1, "on: MARAS allows the alias package via the quest whitelist (%d)"
            % on["counts"]["allow_quest"])
    r.check(not on["sandbox_fill"], "on: the alias package runs (current %s is not the home sandbox)" % on["pkg_fill"])
    r.check(on["sandbox_clear"], "on: alias cleared -> back to TTM_SpouseHomeSandbox (%s)" % on["pkg_clear"])
    off = _maras_off_session(r, sp, name)
    if off.get("error") or "ma7" not in off:
        return inc(r, "off arm: %s" % off.get("error", "not run"))
    o = off["ma7"]
    r.check(o["counts"]["suppress"] >= 1, "off: MARAS suppresses the package and redirects (%d)" % o["counts"]["suppress"])
    r.check(o["sandbox_fill"], "off: the spouse's current package is TTM_SpouseHomeSandbox (%s)" % o["pkg_fill"])
    r.check(o["sandbox_clear"], "off: alias cleared -> still the home sandbox (%s)" % o["pkg_clear"])


@test("K-M2", "K", save="T0-M")
def km2(r):
    """K-M2 'stall' half (kinship_maras.md:127; optional, documents the conflict): without IntelEngine.esp in
    AllowedPlugins (shipped MARAS INI, 'MARAS Config' unticked) a player-requested GoToLocation on the housed,
    non-following spouse2 stalls in MARAS's sandbox: MARAS 'suppressing ... redirecting' lines for her, no arrival in
    150 s. Shares MA-7's off launch (runs it if MA-7 did not). The 'allowed' half is MA-3 (merged, time plan §4).
    INFERRED: 150 s is enough for the errand to have arrived if it were not suppressed (Breezehome -> the Drunken
    Huntsman, a short walk; MA-3 measures the allowed time). reload=False."""
    pre = _maras_preconditions(r)
    if not pre:
        return
    sp, name = pre
    checkpoint(r, "uses MA-7's MARAS-config-off launch (or runs it)")
    off = _maras_off_session(r, sp, name)
    if off.get("error") or "km2" not in off:
        return inc(r, "stall arm: %s" % off.get("error", "not run"))
    k = off["km2"]
    if not k["started"]:
        return inc(r, "the errand never got an IE slot in the off session")
    r.check(k["counts"]["suppress"] >= 1, "IntelEngine's package suppressed and redirected to the sandbox (%d)"
            % k["counts"]["suppress"])
    r.check(not k["arrived"], "the errand stalls: no arrival in 150 s")
    r.log("  allowed half: see MA-3 (merged)")
