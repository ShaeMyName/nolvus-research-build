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
check(block.player_defeated("", "[2026-10-10 14:48:41.703] [13932] [info] [MenuEventHandler.cpp:259] Menu 'Dialogue Menu' is opening"), "defeat: dialogue menu opened")
check(block.player_defeated("", "[2026-10-10 14:48:41.622] [30312] [info] [TopicInfoEventHandler.cpp:358] (Dialogue) Whiterun Guard: You have committed crimes against Skyrim and her people."), "defeat: guard arrest greeting")
check(not block.player_defeated("", "(Background Dialogue) Carlotta Valentia: That's close enough."), "defeat: background dialogue is not an arrest")

# ---------------------------------------------------------------- FormID normalisation (REVIEW_LOG R48, 2026-10-10)
# One FE (light-plugin) actor and one low Skyrim.esm actor, every printed form, through every host-side parser.
# Real line shapes from Papyrus.0.log / ErrandBridgeWatch.0.log of 2026-10-10 ("UUID 0xE1BA9 Jenassa",
# "CampMember 0xFE499A4B ...", "rt=... gt=... Jenassa 0xE1BA9 cell=0x1A27A::0 ...", "SpawnHostile 0x23ABE ref=0xFF002244").
import io, os, re, tempfile, contextlib
import fidnorm, game, tests_misc, tests_tm_l, burst_b22, check_logs
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "soak"))
import collector

FE, LOW = 0xFE499A4B, 0x000E1BA9
ACTORS = {FE: ("Bandit Chief", ["0xFE499A4B", "0xfe499a4b", "FE499A4B", "-28730805", "4266236491"]),
          LOW: ("Jenassa", ["0xE1BA9", "0x000E1BA9", "000E1BA9", "e1ba9", "924585"])}
OTHER = {FE: (0xFE499A4C, "0xFE499A4C"), LOW: (0x001E1BA9, "0x1E1BA9")}   # negative controls: adjacent / superset id

# fid_norm itself
for v, want in (("0xFE499A4B", FE), ("FE499A4B", FE), ("fe499a4b", FE), ("-28730805", FE), ("4266236491", FE),
                (-28730805, FE), (4266236491, FE), ("000E1BA9", LOW), ("0xE1BA9", LOW), ("E1BA9", LOW), ("924585", LOW),
                (LOW, LOW), ("0xFF002244", 0xFF002244), ("00091918", 0x91918)):
    check(fidnorm.fid_norm(v) == want, "fid_norm(%r) == 0x%08X" % (v, want))
for v in ("", "None", "0xG1", "123456789012", None, True, "1.5"):
    check(fidnorm.fid_norm(v) is None, "fid_norm(%r) is None (not a FormID)" % (v,))
check(fidnorm.fid_s32(FE) == -28730805 and fidnorm.fid_s32(LOW) == LOW, "fid_s32: FE -> signed, low unchanged")
check(fidnorm.fid_hex8(-28730805) == "FE499A4B" and fidnorm.fid_hex8(LOW) == "000E1BA9", "fid_hex8 of signed/unsigned")
check(not re.search(fidnorm.fid_any_rx(0x14), "dPlayer=20 dDest=20 ovr=20"), "fid_any_rx: player 0x14 does not match a plain 20")
check(not re.search(fidnorm.fid_any_rx(LOW), "rt=924585.5 gt=1.924585"), "fid_any_rx: decimal form needs a whole token")


def wline(nm, tok, held="0", combat="1"):
    return ("[10/10/2026 - 04:00:40PM] rt=3425.029053 gt=2.389551 %s %s cell=0x1A27A::0 loaded=1 pos=24320,-8154,-3393 "
            "dPlayer=248 dDest=NA tm=1 wfp=0.000000 nffSeat=2 cff=0 pkg=0xD247147B:nwsFollowerFollowPKG ovr=0 ieSlot=-1 "
            "slotCount=0 ieTask= ieRes= ieWasF=0 iebHeld=%s iebLent=0 iebGate=0 iebMode=0 iebRecall=0 saHome=0 "
            "musterAlias=-1 cfEntry=-1 combat=%s dead=0" % (nm, tok, held, combat))


class FakeTail:
    def __init__(self, text):
        self.text = text

    def read(self):
        return self.text

    def wait(self, pattern, timeout=30, poll=1.0):
        return re.search(pattern, self.text)


class FakeRun:
    name, inconclusive, fails = "SELFTEST", 0, 0

    def __init__(self):
        self.lines, self.calls = [], []

    def log(self, s):
        self.lines.append(s)

    def ctl(self, fn, args=None, **k):
        self.calls.append((fn, args))
        return {}

    def tool(self, *a, **k):
        return {}


@contextlib.contextmanager
def papyrus(text):
    """Every parser's log tail reads `text` (tests_b.fresh, tests_misc.tail, tests_tm_l.tail, game.Tail)."""
    saved = (tests_b.fresh, tests_misc.tail, tests_tm_l.tail, game.Tail)
    tests_b.fresh = lambda kind="papyrus": FakeTail(text)
    tests_misc.tail = tests_tm_l.tail = lambda key: FakeTail(text)
    game.Tail = lambda path: FakeTail(text)
    try:
        yield
    finally:
        tests_b.fresh, tests_misc.tail, tests_tm_l.tail, game.Tail = saved


for fid, (nm, toks) in ACTORS.items():
    ofid, otok = OTHER[fid]
    for tok in toks:
        for arg in sorted({fid, fidnorm.fid_s32(fid)}):        # callers may hold the id signed or unsigned
            tag = "0x%08X printed %s, asked as %d" % (fid, tok, arg)
            w = wline(nm, tok)
            # watcher sample lines (ErrandBridgeWatch)
            check(len(tests_b.wsamples(w, arg)) == 1, "watcher tests_b.wsamples: %s" % tag)
            check(len(tests_tm_l.actor_lines(w, arg)) == 1, "watcher tests_tm_l.actor_lines: %s" % tag)
            check(len(tests_misc.watch_all(None, arg, w)) == 1, "watcher tests_misc.watch_all: %s" % tag)
            # probe line
            pl = "[10/10/2026 - 03:08:05PM] [IEB-TEST] probe " + w.split("] ", 1)[1] + " iebKeys=False saSandbox=False"
            with papyrus(pl):
                p = tests_b.probe(FakeRun(), arg)
                check(p is not None and p.get("combat") == "1", "probe tests_b.probe: %s" % tag)
                p = tests_tm_l.probe(FakeRun(), arg)
                check(p is not None and p.get("combat") == 1, "probe tests_tm_l.probe: %s" % tag)
            # snapshot line
            sl = "[10/10/2026 - 03:08:08PM] [IEB-TEST] snapshot " + w.split("] ", 1)[1]
            with papyrus(sl):
                r = FakeRun()
                tests_b.snap(r, arg)
                check(not any("WARN" in x for x in r.lines), "snapshot tests_b.snap: %s" % tag)
                r = FakeRun()
                tests_misc.snapshot_sync(r, arg)
                check(not any("WARN" in x for x in r.lines), "snapshot tests_misc.snapshot_sync: %s" % tag)
            # burst lines (ErrandBridgeWatch, IEB_TestCtl.psc:251-257)
            bl = ["[10/10/2026 - 04:01:00PM] BURST START %s %s t=100.5 waitbox=0xD2471234 waitboxpt=None" % (nm, tok),
                  "[10/10/2026 - 04:01:00PM] BURST 100.6 0xD247147B wfp=0.000000 pos=24320.1,-8154.2,-3393.0",
                  "[10/10/2026 - 04:01:00PM] BURST 100.7 0xD247147B wfp=0.000000 pos=24330.1,-8154.2,-3393.0",
                  "[10/10/2026 - 04:01:01PM] BURST END %s samples=2 t=100.8" % nm]
            head, smp = burst_b22.last_burst(bl, arg)
            check(head is not None and len(smp) == 2 and burst_b22.burst_fid(head) == fid, "burst burst_b22.last_burst: %s" % tag)
            # ctl lines keyed by id: UUID, QR, RANK, SU (IEB_TestCtl.psc:153, 894, 988, 964)
            ul = "[10/10/2026 - 03:05:17PM] [IEB-TEST] UUID %s %s = 61D9F2B793030A8C child=False" % (tok, nm)
            with papyrus(ul):
                u, n, ch = tests_misc.who(FakeRun(), arg)
                check(u == "61D9F2B793030A8C" and n == nm and ch is False, "UUID tests_misc.who: %s" % tag)
            ql = "[10/10/2026 - 03:05:17PM] [IEB-TEST] QR %s t1=1 story=1 open=0 name=%s" % (tok, nm)
            with papyrus(ql):
                d = tests_misc.qr(FakeRun(), arg)
                check(d is not None and d.get("t1") == "1", "QR tests_misc.qr: %s" % tag)
            rl = "[10/10/2026 - 03:05:17PM] [IEB-TEST] RANK %s r=1 tier=2 track=0 pts=10 child=0" % tok
            with papyrus(rl):
                d = tests_misc.rank(FakeRun(), arg)
                check(d is not None and d.get("tier") == "2", "RANK tests_misc.rank: %s" % tag)
            with papyrus("[IEB-TEST] SU %s SNRom_AskPending set=0" % tok):
                check(tests_misc.su_set(FakeRun(), arg, "SNRom_AskPending", 0) is not None, "SU tests_misc.su_set: %s" % tag)
        # id-printing lines parsed back to an id (QSCAN / QALIAS / CampMember / SPAWN / SpawnHostile): fid_norm
        check(fidnorm.fid_norm(tok) == fid, "id token %s -> fid_norm == 0x%08X" % (tok, fid))
    with papyrus("[IEB-TEST] QSCAN %s t1=0 story=0 name=%s\n[IEB-TEST] QSCAN END n=1" % (toks[0], nm)):
        s = tests_misc.qscan(FakeRun())
        check(len(s) == 1 and s[0]["fid"] == fid, "QSCAN tests_misc.qscan: 0x%08X parsed from %s" % (fid, toks[0]))
    # [IEB] lines carry the display name, never an id (IEB_Main.psc Log calls, e.g. :251, :320, :418)
    il = "[10/10/2026 - 03:20:00PM] [IEB] REFUSE actor=%s reason=war_band" % nm
    ev = tests_b.ieb_events(il, nm)
    check(ev == [("REFUSE", "reason=war_band")], "[IEB] tests_b.ieb_events by name: %s (0x%08X)" % (nm, fid))
    check(not tests_b.ieb_events(il, "Uthgerd the Unbroken"), "[IEB] negative: another name does not match %s" % nm)
    # check_logs I5 (name-keyed; stdout captured so only PASS/FAIL lines print here)
    base = check_logs.fails
    with contextlib.redirect_stdout(io.StringIO()):
        n = check_logs.i5(["[10/10/2026 - 03:19:59PM] IntelEngine: Allocated slot 3 to %s for GoToLocation" % nm, il])
    check(n == 1 and check_logs.fails == base, "check_logs.i5: %s's allocation and decision paired" % nm)
    with contextlib.redirect_stdout(io.StringIO()):
        check_logs.i5(["[10/10/2026 - 03:19:59PM] IntelEngine: Allocated slot 3 to %s for GoToLocation" % nm,
                       "[10/10/2026 - 03:20:00PM] [IEB] REFUSE actor=Someone Else reason=war_band"])
    check(check_logs.fails == base + 1, "check_logs.i5 negative: another actor's decision leaves %s undecided" % nm)
    check_logs.fails = base
    # collector (counts only, no actor matching): FE / low actor lines are counted
    with tempfile.TemporaryDirectory() as td:
        pp, ww = os.path.join(td, "Papyrus.0.log"), os.path.join(td, "Watch.0.log")
        open(pp, "w", encoding="utf-8").write("[10/10/2026 - 03:20:00PM] [IEB] TEAMMATE_WAS_OFF actor=%s\n" % nm)
        open(ww, "w", encoding="utf-8").write("[10/10/2026 - 03:20:00PM] ASSERT FAIL I3 %s %s: x\n" % (nm, toks[0]))
        saved = collector.PAPYRUS, collector.WATCH
        collector.PAPYRUS, collector.WATCH = pp, ww
        try:
            check(collector.bridge_counts() == (1, 0, 1), "collector.bridge_counts: %s (0x%08X) lines counted" % (nm, fid))
        finally:
            collector.PAPYRUS, collector.WATCH = saved
    # negative controls: another id in the same line shapes is not this actor
    w = wline(nm, otok)
    check(not tests_b.wsamples(w, fid) and not tests_tm_l.actor_lines(w, fid) and not tests_misc.watch_all(None, fid, w),
          "watcher negative: 0x%08X line does not match 0x%08X" % (ofid, fid))
    check(tests_b.wsamples(w, ofid) and tests_tm_l.actor_lines(w, ofid), "watcher negative control's own id matches (0x%08X)" % ofid)
    with papyrus("[IEB-TEST] probe " + w.split("] ", 1)[1]):
        check(tests_b.probe(FakeRun(), fid) is None and tests_tm_l.probe(FakeRun(), fid) is None,
              "probe negative: 0x%08X line does not match 0x%08X" % (ofid, fid))
    with papyrus("[IEB-TEST] snapshot " + w.split("] ", 1)[1]):
        r = FakeRun()
        tests_misc.snapshot_sync(r, fid)
        check(any("WARN" in x for x in r.lines), "snapshot negative: 0x%08X line does not confirm 0x%08X" % (ofid, fid))
    head, _ = burst_b22.last_burst(["BURST START %s %s t=1 waitbox=None waitboxpt=None" % (nm, otok)], fid)
    check(head is None, "burst negative: 0x%08X burst is not 0x%08X's" % (ofid, fid))
    with papyrus("[IEB-TEST] UUID %s %s = 61D9F2B793030A8C child=False" % (otok, nm)):
        check(tests_misc.who(FakeRun(), fid)[1] is None, "UUID negative: 0x%08X line does not answer 0x%08X" % (ofid, fid))
    with papyrus("[IEB-TEST] QR %s t1=1 name=%s" % (otok, nm)):
        check(tests_misc.qr(FakeRun(), fid) is None, "QR negative: 0x%08X line does not answer 0x%08X" % (ofid, fid))
# runner.Run.uuid (UUID line, IEB_TestCtl.psc:153): now keyed by the id
with tempfile.TemporaryDirectory() as td:
    saved = runner.PAPYRUS
    runner.PAPYRUS = os.path.join(td, "Papyrus.0.log")
    open(runner.PAPYRUS, "w").close()
    try:
        for fid, (nm, toks) in ACTORS.items():
            for tok, want in [(t, True) for t in toks] + [(OTHER[fid][1], False)]:
                fr = runner.Run.__new__(runner.Run)
                fr.ctl = lambda fn, args=None, **k: {}
                text = "[10/10/2026 - 03:05:17PM] [IEB-TEST] UUID %s %s = 61D9F2B793030A8C child=False" % (tok, nm)
                fr.logline = lambda pattern, size, timeout=15, text=text: re.search(pattern, text)
                for arg in sorted({fid, fidnorm.fid_s32(fid)}):
                    u, info = fr.uuid(arg)
                    check((u == "61D9F2B793030A8C" and info == (nm, False)) if want else u == "",
                          "UUID runner.Run.uuid: 0x%08X asked as %d, line prints %s -> %s" % (fid, arg, tok, "match" if want else "no match"))
    finally:
        runner.PAPYRUS = saved
import check_logs as _cl
_res = []
_cl.out = lambda cond, inv, msg: _res.append((bool(cond), inv, msg))
_cl.i5(["[x] IntelEngine: Allocated slot 0 to Brenuin for Travel", "[x] [IEB] LEND actor=Brenuin kind=7",
        "[x] [IEB] LEND_RESTORE actor=Brenuin kind=7 why=task_end", "[x] Reverting game...",
        "[x] [IEB] LEND_RESTORE actor=Brenuin kind=7 why=task_end"])
check(all(c for c, i, m in _res if "terminals" in m), "I5: one terminal per timeline across a load passes")
_res.clear()
_cl.i5(["[x] IntelEngine: Allocated slot 0 to Brenuin for Travel", "[x] [IEB] LEND actor=Brenuin kind=7",
        "[x] [IEB] LEND_RESTORE actor=Brenuin kind=7 why=task_end", "[x] [IEB] LEND_RESTORE actor=Brenuin kind=7 why=task_end"])
check(any(not c for c, i, m in _res if "terminals" in m), "I5: two terminals in one timeline still fails")
_res.clear()
_cl.i5(["[x] IntelEngine: Allocated slot 0 to Jenassa for Travel", "[x] [IEB] TAKE actor=Jenassa mode=1",
        "[x] [IEB] RELEASE_FOLLOW actor=Jenassa", "[x] Reverting game..."])
check(all(c for c, i, m in _res if "terminals" in m), "I5: a task finished before a reload to another save passes (run 18 D-2)")
_res.clear()
_cl.i5(["[x] IntelEngine: Allocated slot 0 to Jenassa for Travel", "[x] [IEB] TAKE actor=Jenassa mode=1",
        "[x] Reverting game...", "[x] [IEB] RELEASE_FOLLOW actor=Jenassa"])
check(all(c for c, i, m in _res if "terminals" in m), "I5: a task held open in the save, ended after the load, passes")
# RV-68 (IE refusal undo): the drop-mode refusal matcher, and every Dismiss -> TryAllocateSlot refusal path undoes the dismiss.
import tests_ie
_ok = ("[x] IntelEngine: Dismissed follower: Jenassa\n[x] IntelEngine: SLOT_REFUSED slot=0 reason=held holder=Anoriath holderId=108160 "
       "requester=Jenassa requesterId=924585 type=travel\n[x] IntelEngine: SLOT_REFUSED_UNDO: restored teammate flag for Jenassa\n")
_r = tests_ie.refusal_report(_ok, "Jenassa")
check(_r["dismissed"] and _r["refused"] and _r["restored"] and not _r["kept"], "IE-R1: drop-mode refusal + undo lines match")
_r = tests_ie.refusal_report(_ok.replace("SLOT_REFUSED_UNDO", "X"), "Jenassa")
check(_r["refused"] and not _r["restored"], "IE-R1: a refusal without the undo line is not a restore")
_r = tests_ie.refusal_report(_ok, "Uthgerd")
check(not (_r["dismissed"] or _r["refused"] or _r["restored"]), "IE-R1: another actor's lines are ignored")
_src = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "src", "intelengine", "Source", "Scripts")
for _f in ("IntelEngine_Travel.psc", "IntelEngine_NPCTasks.psc"):
    _t = open(os.path.join(_src, _f), "rb").read().decode("utf-8").replace("\r\n", "\n").split("\n")
    _n = _u = 0
    for _i, _l in enumerate(_t):
        if "Core.DismissFollowerForTask(" in _l and not _l.strip().startswith(";"):
            _n += 1
            _blk = _t[_i + 1:_i + 14]
            _k = next((j for j, x in enumerate(_blk) if "TryAllocateSlot" in x), None)
            if _k is not None and "UndoDismissOnRefusal" in _blk[_k + 1]:
                _u += 1
    check(_n > 0 and _n == _u, "RV-68: %s: each DismissFollowerForTask (%d) is followed by a TryAllocateSlot that undoes it on refusal (%d)" % (_f, _n, _u))

# ---------------------------------------------------------------- setup-only pass (block.py --setup-only)
class SetupRun(FakeRun):
    """FakeRun with the Run fields block.call_test / setup_verdict / the test bodies use."""
    def __init__(self, setup_only=True, name="SELFTEST"):
        FakeRun.__init__(self)
        self.name, self.fails, self.inconclusive, self.setup_only = name, 0, 0, setup_only

    def check(self, cond, what):
        if not cond:
            self.fails += 1
        self.log("%s %s %s" % ("PASS" if cond else "FAIL", self.name, what))

    def uuid(self, fid):
        return "", None


def _t_ok(r):
    try:
        r.log("setup")
        block.checkpoint(r)
        r.log("MAIN ACTION")
    except Exception:           # a test's own broad except must not swallow the checkpoint
        r.log("SWALLOWED")
    finally:
        r.log("cleanup ran")


def _t_need_miss(r):
    if not tests_b.need(r, False, "no position for F1 at A"):
        return
    block.checkpoint(r)
    r.log("MAIN ACTION")


def _t_no_checkpoint(r):
    r.log("setup only, then returns")


def _t_loop(r):
    for i in (1, 2):
        r.log("setup %d" % i)
        if block.setup_skip(r):
            continue
        r.log("MAIN %d" % i)
    block.checkpoint(r)
    r.log("AFTER LOOP")


r = SetupRun()
block.call_test(_t_ok, r)
v, why = block.setup_verdict(r)
check(r.lines == ["setup", "SETUP checkpoint reached", "cleanup ran"] and v == "SETUP OK",
      "setup-only: checkpoint stops before the main action, the test's finally still runs, not swallowed by except (%s)" % r.lines)
r = SetupRun(setup_only=False)
block.call_test(_t_ok, r)
check(r.lines == ["setup", "MAIN ACTION", "cleanup ran"], "real run: checkpoint is a no-op, same code path (%s)" % r.lines)
r = SetupRun(name="B-21")
block.call_test(_t_need_miss, r)
v, why = block.setup_verdict(r)
check(v == "SETUP FAIL" and "no position for F1 at A" in why and "MAIN ACTION" not in r.lines,
      "setup-only: a need() miss is SETUP FAIL with its reason (%s: %s)" % (v, why))
r = SetupRun()
block.call_test(_t_no_checkpoint, r)
check(block.setup_verdict(r)[0] == "SETUP FAIL", "setup-only: returning without a checkpoint or reason is SETUP FAIL")
def _t_boom(r):
    raise ValueError("boom")


r = SetupRun()
block.call_test(_t_boom, r)
v, why = block.setup_verdict(r)
check(v == "SETUP FAIL" and "harness error" in why, "setup-only: a harness exception is SETUP FAIL (%s)" % why)
r = SetupRun()
block.call_test(_t_loop, r)
check(r.lines == ["setup 1", "SETUP checkpoint reached (loop pass)", "setup 2", "SETUP checkpoint reached (loop pass)",
                  "SETUP checkpoint reached"] and block.setup_verdict(r)[0] == "SETUP OK",
      "setup-only: setup_skip runs every loop pass's setup, no pass's main (%s)" % r.lines)
r = SetupRun(setup_only=False)
block.call_test(_t_loop, r)
check(r.lines == ["setup 1", "MAIN 1", "setup 2", "MAIN 2", "AFTER LOOP"], "real run: setup_skip is a no-op")
r = SetupRun()
r.log("  WARN snapshot line for 000E1BA9 not seen within 20 s")
block.call_test(lambda r: block.checkpoint(r, "left to the real test"), r)
v, why = block.setup_verdict(r)
check(v == "SETUP OK" and "left to the real test" in why and "WARN snapshot" in why, "setup-only: note and WARN lines reach the summary")
# summary format: one line per test
check(block.setup_line("B-1", "SETUP OK", "") == "SETUP OK B-1", "summary: stdout line 'SETUP OK <id>'")
check(block.setup_line("B-21", "SETUP FAIL", "INCONCLUSIVE B-21 precondition: x") == "SETUP FAIL B-21 (INCONCLUSIVE B-21 precondition: x)",
      "summary: stdout line 'SETUP FAIL <id> (reason)'")
check(block.setup_row("B-21", "SETUP FAIL", "a|b", 12.7) == "| B-21 | SETUP FAIL (a/b) | 12 | |", "summary: md row, reason in the verdict cell, '|' escaped")
check(block.setup_row("B-1", "SETUP OK", "", 3) == "| B-1 | SETUP OK | 3 | |", "summary: md row for SETUP OK")

# Real test bodies in setup-only mode (stubbed game): no main action, and the test's own finally/cleanup runs.
_probe = ("[10/10/2026 - 03:08:05PM] [IEB-TEST] probe " + wline("Jenassa", "0xE1BA9").split("] ", 1)[1].replace("combat=1", "combat=0")
          + "\n[10/10/2026 - 03:08:08PM] [IEB-TEST] snapshot " + wline("Jenassa", "0xE1BA9").split("] ", 1)[1]
          + "\n[10/10/2026 - 03:08:09PM] [IEB-TEST] NFFStaleFac 0xE1BA9 in=1")
import time as _time
_sleep = _time.sleep
_time.sleep = lambda s: None
try:
    with papyrus(_probe):
        r = SetupRun(name="B-1")
        block.call_test(block.TESTS["B-1"]["fn"], r)
        fns = [c[0] for c in r.calls]
        check(block.setup_verdict(r)[0] == "SETUP OK" and "StartTask" not in fns and "NFFFollow" in fns,
              "B-1 setup-only: SETUP OK, no StartTask, its finally's tidy() ran (calls %s)" % fns)
        r = SetupRun(name="B-6c")
        block.call_test(block.TESTS["B-6c"]["fn"], r)
        check(block.setup_verdict(r)[0] == "SETUP OK" and ("NFFStaleFac", [tests_b.F1, 0]) in r.calls
              and not any(c[0] == "StartTask" for c in r.calls),
              "B-6c setup-only: no StartTask; its finally removed the stale faction again (NFFStaleFac F1 0)")
finally:
    _time.sleep = _sleep

# Wiring: every implemented test reaches a checkpoint in its own code or through a shared setup helper that has one.
import inspect
_helpers = re.compile(r"checkpoint\(r|setup_skip\(r|\b(?:rejoin_setup|in_rejoin|dismiss_case)\(r|(?<![\w.])lend\(r")
for _m in ("tests_tm_l", "tests_misc", "tests_ie"):
    __import__(_m)
_nocp = [t for t, d in block.TESTS.items() if not _helpers.search(inspect.getsource(d["fn"]))]
check(not _nocp, "setup-only wiring: every registered test has a checkpoint (missing: %s)" % _nocp)
for _h in (tests_b.rejoin_setup, tests_b.in_rejoin, tests_b.dismiss_case, tests_tm_l.lend):
    check("checkpoint(r)" in inspect.getsource(_h), "setup-only wiring: shared setup %s has a checkpoint" % _h.__name__)
sys.exit(0 if ok else 1)
