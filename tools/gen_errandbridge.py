"""Generate ErrandBridge.esp (spec §16.4; TASK_C step 3 / list A3). FROZEN record set: FormIDs, EditorIDs, script
attachments and property lists below must never change once Lucienne's save exists (freeze rule). Values of the
globals are defaults only (the save keeps its own).

Layout mirrors a proven small plugin (SNRom_Integration.esl): start-game quest, one Unique-Actor Player alias.
Writes build/out/ErrandBridge.esp, then re-parses it and checks the round trip."""
import os, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import espio as E

OUT = "C:/nolvus-research/build/out/ErrandBridge.esp"
SELF = 0x01000000          # masters: [Skyrim.esm] -> own records use index 1
PLAYER_REF = 0x00000014    # Skyrim.esm PlayerRef
PLAYER_BASE = 0x00000007   # Skyrim.esm Player (unique actor)

# (local id, EditorID, kind 's'/'f', default)   -- FROZEN
GLOBALS = [
    (0x800, "IEB_Enabled", "s", 1),
    (0x801, "IEB_PollSeconds", "f", 1.0),
    (0x802, "IEB_LogLevel", "s", 2),
    (0x803, "IEB_ParkRefreshHours", "s", 24),
    (0x804, "IEB_LogToFile", "s", 0),
    (0x805, "IEB_RejoinWarpFactor", "f", 0.75),
    (0x806, "IEB_LendEnabled", "s", 1),
    (0x807, "IEB_LendStoryPolicy", "s", 1),
    (0x808, "IEB_CFEnabled", "s", 1),
    (0x809, "IEB_CFPauseCatchup", "s", 0),
    (0x80A, "IEB_Spare01", "s", 0),
    (0x80B, "IEB_Spare02", "s", 0),
]
QUEST_ID, QUEST_EDID = 0x810, "IEB_MainQuest"
MAIN_SCRIPT, ALIAS_SCRIPT = "IEB_Main", "IEB_PlayerAlias"


def sub(sig, value): return E.Sub(sig, value=value, typed=True)


def raw(sig, b): return E.Sub(sig, raw=b)


def glob(lid, edid, kind, val):
    return E.Record("GLOB", formid=SELF | lid, subs=[
        sub("EDID", edid), sub("FNAM", {"kind": ord(kind)}), sub("FLTV", struct.pack("<f", float(val)))])


def prop_obj(name, formid):
    return {"name": name, "type": 1, "status": 1, "value": {"form": formid, "alias": -1, "unused": 0}}


def quest():
    props = [prop_obj(edid, SELF | lid) for lid, edid, _, _ in GLOBALS] + [prop_obj("PlayerRef", PLAYER_REF)]
    vmad = {"version": 5, "objFormat": 2,
            "scripts": [{"name": MAIN_SCRIPT, "status": 0, "props": props}],
            "quest": {"unk": 2, "fragments": [], "fileName": "",
                      "aliases": [{"object": {"form": SELF | QUEST_ID, "alias": 0, "unused": 0},
                                   "version": 5, "objFormat": 2,
                                   "scripts": [{"name": ALIAS_SCRIPT, "status": 0, "props": []}]}]}}
    return E.Record("QUST", formid=SELF | QUEST_ID, subs=[
        sub("EDID", QUEST_EDID),
        sub("VMAD", vmad),
        sub("DNAM", {"flags": 0x11, "priority": 0, "formVersion": 255, "unknown": 0, "type": 0, "pad": b"\0\0\0"}),
        sub("NEXT", None),
        sub("ANAM", 1),
        sub("ALST", 0), sub("ALID", "PlayerAlias"), raw("FNAM", b"\0\0\0\0"),
        sub("ALUA", PLAYER_BASE), raw("VTCK", b"\0\0\0\0"), sub("ALED", None),
    ])


def build():
    globs = [glob(*g) for g in GLOBALS]
    groups = [E.Group(b"GLOB", 0, children=globs), E.Group(b"QUST", 0, children=[quest()])]
    header = E.Record("TES4", flags=0x200, formid=0, subs=[
        sub("HEDR", {"version": struct.pack("<f", 1.71), "numRecords": 0, "nextObjectId": 0}),
        sub("CNAM", "shae"),
        sub("SNAM", "Errand Bridge (private): IntelEngine x NFF x SeverActions. Frozen record set; scripts carry the logic."),
        sub("MAST", "Skyrim.esm"), sub("DATA", {"size": 0}),
        sub("INTV", 1),
    ])
    p = E.Plugin(header, groups)
    p.localized = False
    hedr = header.subs[0].value
    hedr["numRecords"] = E.count_records_and_groups(p)
    hedr["nextObjectId"] = max([g[0] for g in GLOBALS] + [QUEST_ID]) + 1
    return p


if __name__ == "__main__":
    p = build()
    data = E.emit(p)
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    open(OUT, "wb").write(data)
    # verify: re-parse, typed-decode, re-emit identical; ESL ids in range; counts
    q = E.parse(data)
    for g in q.groups:
        for r in g.children:
            E.decode_record(r, False)
    E.decode_record(q.header, False)
    assert E.emit(q) == data, "re-emit differs"
    ids = [r.formid for g in q.groups for r in g.children]
    assert all(0x800 <= (i & 0xFFFFFF) <= 0xFFF and (i >> 24) == 1 for i in ids), "ESL id out of range"
    v = [s.value for g in q.groups for r in g.children if r.sig == "QUST" for s in r.subs if s.sig == "VMAD"][0]
    print("ErrandBridge.esp: %d bytes, ESL flag %s, records %d (HEDR %d), globals %d, quest script %s with %d properties, alias script %s"
          % (len(data), bool(q.header.flags & 0x200), len(ids), q.header.subs[0].value["numRecords"], len(GLOBALS),
             v["scripts"][0]["name"], len(v["scripts"][0]["props"]), v["quest"]["aliases"][0]["scripts"][0]["name"]))
