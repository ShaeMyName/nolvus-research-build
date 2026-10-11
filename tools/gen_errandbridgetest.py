"""Generate ErrandBridgeTest.esp (TASK_C step 6, harness E; spec §15.1-§15.4, §15.3.1; v1 §5.2-§5.4). TEST PROFILE ONLY:
never in Lucienne's profile, so the freeze rule does not apply (records may change between test runs).
  GLOB 0x800 IEB_TestCFRefuse (0)  every registry entry gets one extra refuse term while 1 (CF tests)
  GLOB 0x801 IEB_TestWatch    (1)  watcher on
  GLOB 0x802 IEB_TestSoakProbe(0)  soak probe CSV on (only during the soak)
  QUST 0x810 IEB_TestQuest         start game; scripts IEB_Watcher, IEB_TestCtl (no properties: forms are looked up with
                                   GetFormFromFile)
  QUST 0x830 IEB_TestSoakQuest     start game; script IEB_SoakProbe. [CHANGED 2026-10-10] Its own quest: Papyrus keeps one
                                   update registration per form, so on IEB_TestQuest the probe's 30 s re-arm overwrote
                                   the watcher's 3 s loop (the watcher ticked every ~30 s).
  QUST 0x820 IEB_TestStoryQuest    synthetic story quest (S-26, MA-7): type 8 (Side Quest, a §10.2.1 story type), start
                                   game, one optional reference alias "TestActor" (empty; filled by IEB_TestCtl.QPFill)
                                   carrying one package. [CHANGED in build 2026-10-09] The package is vanilla
                                   DefaultSandboxCurrentLocation256 (Skyrim.esm 0x0956B8), a harmless sandbox where the
                                   actor stands, recognisable by FormID, instead of a new PACK at a test marker: the
                                   plugin writer has no proven PACK record.
  QUST 0x840 IEB_TestPkgQuest      [ADDED 2026-10-11, REVIEW_LOG R36-upd (c)] start game; one optional, EMPTY reference
                                   alias "PkgWatch" with NO package, carrying script IEB_PkgWatch (OnPackageStart/Change/End
                                   -> [IEB-TEST] PKGEVT lines); filled by IEB_TestCtl.PkgWatch, cleared by PkgUnwatch.
Writes build/out/ErrandBridgeTest.esp and checks the round trip."""
import os, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import espio as E

OUT = "C:/nolvus-research/build/out/ErrandBridgeTest.esp"
SELF = 0x01000000
PLAYER_BASE = 0x00000007
SANDBOX_PKG = 0x000956B8
GLOBALS = [(0x800, "IEB_TestCFRefuse", "s", 0), (0x801, "IEB_TestWatch", "s", 1), (0x802, "IEB_TestSoakProbe", "s", 0)]
TEST_Q, STORY_Q, SOAK_Q, PKG_Q = 0x810, 0x820, 0x830, 0x840
TEST_SCRIPTS = ["IEB_Watcher", "IEB_TestCtl"]
SOAK_SCRIPTS = ["IEB_SoakProbe"]
ALIAS_FLAGS = 0x00010202     # Optional | Allow Reserved | Allow Cleared


def sub(sig, value): return E.Sub(sig, value=value, typed=True)


def raw(sig, b): return E.Sub(sig, raw=b)


def glob(lid, edid, kind, val):
    return E.Record("GLOB", formid=SELF | lid, subs=[
        sub("EDID", edid), sub("FNAM", {"kind": ord(kind)}), sub("FLTV", struct.pack("<f", float(val)))])


def dnam(qtype):
    return sub("DNAM", {"flags": 0x11, "priority": 0, "formVersion": 255, "unknown": 0, "type": qtype, "pad": bytes(3)})


def script_quest(lid, edid, scripts):
    vmad = {"version": 5, "objFormat": 2,
            "scripts": [{"name": n, "status": 0, "props": []} for n in scripts],
            "quest": {"unk": 2, "fragments": [], "fileName": "", "aliases": []}}
    return E.Record("QUST", formid=SELF | lid, subs=[sub("EDID", edid), sub("VMAD", vmad), dnam(0),
                                                       sub("NEXT", None), sub("ANAM", 0)])


def test_quest():
    return script_quest(TEST_Q, "IEB_TestQuest", TEST_SCRIPTS)


def soak_quest():
    return script_quest(SOAK_Q, "IEB_TestSoakQuest", SOAK_SCRIPTS)


def story_quest():
    return E.Record("QUST", formid=SELF | STORY_Q, subs=[
        sub("EDID", "IEB_TestStoryQuest"), dnam(8), sub("NEXT", None), sub("ANAM", 1),
        sub("ALST", 0), sub("ALID", "TestActor"), raw("FNAM", struct.pack("<I", ALIAS_FLAGS)),
        sub("ALPC", SANDBOX_PKG), raw("VTCK", bytes(4)), sub("ALED", None)])


def pkg_quest():
    vmad = {"version": 5, "objFormat": 2, "scripts": [],
            "quest": {"unk": 2, "fragments": [], "fileName": "",
                      "aliases": [{"object": {"form": SELF | PKG_Q, "alias": 0, "unused": 0}, "version": 5, "objFormat": 2,
                                   "scripts": [{"name": "IEB_PkgWatch", "status": 0, "props": []}]}]}}
    return E.Record("QUST", formid=SELF | PKG_Q, subs=[
        sub("EDID", "IEB_TestPkgQuest"), sub("VMAD", vmad), dnam(0), sub("NEXT", None), sub("ANAM", 1),
        sub("ALST", 0), sub("ALID", "PkgWatch"), raw("FNAM", struct.pack("<I", ALIAS_FLAGS)),
        raw("VTCK", bytes(4)), sub("ALED", None)])


def build():
    groups = [E.Group(b"GLOB", 0, children=[glob(*g) for g in GLOBALS]),
              E.Group(b"QUST", 0, children=[test_quest(), story_quest(), soak_quest(), pkg_quest()])]
    header = E.Record("TES4", flags=0x200, formid=0, subs=[
        sub("HEDR", {"version": struct.pack("<f", 1.71), "numRecords": 0, "nextObjectId": 0}),
        sub("CNAM", "shae"),
        sub("SNAM", "Errand Bridge test harness: watcher, controller, soak probe, synthetic story quest. TEST PROFILE ONLY."),
        sub("MAST", "Skyrim.esm"), sub("DATA", {"size": 0}), sub("INTV", 1)])
    p = E.Plugin(header, groups)
    p.localized = False
    h = header.subs[0].value
    h["numRecords"] = E.count_records_and_groups(p)
    h["nextObjectId"] = PKG_Q + 1
    return p


if __name__ == "__main__":
    data = E.emit(build())
    open(OUT, "wb").write(data)
    q = E.parse(data)
    for g in q.groups:
        for r in g.children:
            E.decode_record(r, False)
    E.decode_record(q.header, False)
    assert E.emit(q) == data, "re-emit differs"
    ids = [r.formid for g in q.groups for r in g.children]
    assert all(0x800 <= (i & 0xFFFFFF) <= 0xFFF for i in ids)
    print("ErrandBridgeTest.esp: %d bytes, ESL %s, records %d, globals %d, quests 4 (pkg-watch alias IEB_PkgWatch; test scripts %s; soak %s; story quest "
          "type 8, alias TestActor + package 0x%06X)" % (len(data), bool(q.header.flags & 0x200), len(ids), len(GLOBALS),
                                                         ", ".join(TEST_SCRIPTS), ", ".join(SOAK_SCRIPTS), SANDBOX_PKG))
