"""Generate SceneControls.esp (spec §16.4; TASK_C step 5a / list A3). FROZEN record set: FormIDs, EditorIDs, script
attachments and property lists below must never change once Lucienne's save exists (freeze rule). Values of the
globals are defaults only (the save keeps its own).

Same writer and layout as ErrandBridge.esp, except that the logic script lives on the player alias (spec §11.8:
"IEB_SceneMain ... on a player alias"), next to IEB_BeastFormHook (§16.4). The quest itself carries no script.
[CHANGED in build 2026-10-09] The FormLists IEB_MinimalBody / IEB_Smallclothes ship EMPTY: their seed items live in
other mods (Divine Elegance, Queen Marika's Dress, DX Druid Armor, Necrolock; R3 item 5 §3), which would become masters
of a frozen plugin. Step 5c's body fills them at runtime with GetFormFromFile + AddForm.
Writes build/out/SceneControls.esp, then re-parses it and checks the round trip."""
import os, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import espio as E

OUT = "C:/nolvus-research/build/out/SceneControls.esp"
SELF = 0x01000000          # masters: [Skyrim.esm] -> own records use index 1
PLAYER_REF = 0x00000014    # Skyrim.esm PlayerRef
PLAYER_BASE = 0x00000007   # Skyrim.esm Player (unique actor)

# (local id, EditorID, kind 's'/'f', default)   -- FROZEN
GLOBALS = [
    (0x800, "IEB_SceneEnabled", "s", 1),     # kill switch for the whole SceneControls logic
    (0x801, "IEB_SceneKey", "s", 0),         # DX scan code of the scene key (§11.7); 0 = unbound, set in game
    (0x802, "IEB_NarratorKey", "s", 0),      # optional narrator key (§11.3); 0 = unbound
    (0x803, "IEB_WhisperKey", "s", 0),       # optional whisper override cycle key (§11.9); 0 = unbound
    (0x804, "IEB_WhisperAuto", "s", 1),      # whisper situation rule on/off (§11.9)
    (0x805, "IEB_WitnessEnabled", "s", 1),   # ieb_witness emitter on/off (§11.8)
    (0x806, "IEB_SceneSpare01", "s", 0),
    (0x807, "IEB_SceneSpare02", "s", 0),
]
FLISTS = [(0x810, "IEB_MinimalBody"), (0x811, "IEB_Smallclothes")]
QUEST_ID, QUEST_EDID = 0x820, "IEB_SceneQuest"
MAIN_SCRIPT, HOOK_SCRIPT = "IEB_SceneMain", "IEB_BeastFormHook"


def sub(sig, value): return E.Sub(sig, value=value, typed=True)


def raw(sig, b): return E.Sub(sig, raw=b)


def glob(lid, edid, kind, val):
    return E.Record("GLOB", formid=SELF | lid, subs=[
        sub("EDID", edid), sub("FNAM", {"kind": ord(kind)}), sub("FLTV", struct.pack("<f", float(val)))])


def prop_obj(name, formid):
    return {"name": name, "type": 1, "status": 1, "value": {"form": formid, "alias": -1, "unused": 0}}


def flst(lid, edid):
    return E.Record("FLST", formid=SELF | lid, subs=[sub("EDID", edid)])


def quest():
    props = ([prop_obj(edid, SELF | lid) for lid, edid, _, _ in GLOBALS]
             + [prop_obj(edid, SELF | lid) for lid, edid in FLISTS] + [prop_obj("PlayerRef", PLAYER_REF)])
    vmad = {"version": 5, "objFormat": 2,
            "scripts": [],
            "quest": {"unk": 2, "fragments": [], "fileName": "",
                      "aliases": [{"object": {"form": SELF | QUEST_ID, "alias": 0, "unused": 0},
                                   "version": 5, "objFormat": 2,
                                   "scripts": [{"name": MAIN_SCRIPT, "status": 0, "props": props},
                                               {"name": HOOK_SCRIPT, "status": 0, "props": []}]}]}}
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
    groups = [E.Group(b"GLOB", 0, children=globs), E.Group(b"FLST", 0, children=[flst(*f) for f in FLISTS]),
              E.Group(b"QUST", 0, children=[quest()])]
    header = E.Record("TES4", flags=0x200, formid=0, subs=[
        sub("HEDR", {"version": struct.pack("<f", 1.71), "numRecords": 0, "nextObjectId": 0}),
        sub("CNAM", "shae"),
        sub("SNAM", "SceneControls (private): scene key, witness events, whisper rule, beast-form hook. Frozen record set; scripts carry the logic."),
        sub("MAST", "Skyrim.esm"), sub("DATA", {"size": 0}),
        sub("INTV", 1),
    ])
    p = E.Plugin(header, groups)
    p.localized = False
    hedr = header.subs[0].value
    hedr["numRecords"] = E.count_records_and_groups(p)
    hedr["nextObjectId"] = max([g[0] for g in GLOBALS] + [f[0] for f in FLISTS] + [QUEST_ID]) + 1
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
    al = v["quest"]["aliases"][0]["scripts"]
    print("SceneControls.esp: %d bytes, ESL flag %s, records %d (HEDR %d), globals %d, formlists %d, quest scripts %d, alias scripts %s"
          % (len(data), bool(q.header.flags & 0x200), len(ids), q.header.subs[0].value["numRecords"], len(GLOBALS),
             len(FLISTS), len(v["scripts"]), ", ".join("%s (%d props)" % (a["name"], len(a["props"])) for a in al)))
