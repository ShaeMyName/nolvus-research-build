"""Generate Lucienne.esl (spec §11.15.12; TASK_C step 5b / list A3). FROZEN record set: FormIDs, EditorIDs, script
attachments and property lists below must never change once Lucienne's save exists (freeze rule). Values of the
globals are defaults only (the save keeps its own). Same writer as ErrandBridge.esp / SceneControls.esp.
[CHANGED in build 2026-10-09, Shae] + global LUC_ActivateRequest (manual LUC_Active setter; vanilla Skyrim has no cqf),
bound on LUC_Main and LUC_PlayerAliasScript. The ability copies the layout of vanilla WerewolfImmunity (Skyrim.esm
0x0F5BA0: SPIT ability / constant / self, ETYP 0x013F44) with AbResistDisease 0x0E40D3 at magnitude 200 (round 8 §5);
neutral name, since Active Effects shows it. Writes build/out/Lucienne.esl and checks the round trip."""
import os, struct, sys
sys.path.insert(0, os.path.dirname(__file__))
import espio as E

OUT = "C:/nolvus-research/build/out/Lucienne.esl"
SELF = 0x01000000          # masters: [Skyrim.esm] -> own records use index 1
PLAYER_REF = 0x00000014    # Skyrim.esm PlayerRef
PLAYER_BASE = 0x00000007   # Skyrim.esm Player (unique actor)

# (local id, EditorID, kind 's'/'f', default)   -- FROZEN
GLOBALS = [
    (0x800, "LUC_PrayerKey", "s", 0),        # DX scan code, set by Shae in game; 0 = unbound
    (0x801, "LUC_AmenKey", "s", 0),          # DX scan code ending a prayer; 0 = long-press of the prayer key ends it
    (0x802, "LUC_PrayerEnabled", "s", 1),    # kill switch
    (0x803, "LUC_DigestEvery", "s", 5),
    (0x804, "LUC_JournalMax", "s", 10),
    (0x805, "LUC_Spare01", "s", 0),
    (0x806, "LUC_Spare02", "s", 0),
    (0x807, "LUC_ActivateRequest", "s", 0),  # console: set LUC_ActivateRequest to 1 -> LUC_Active (never automatic)
]
SPELL_ID, SPELL_EDID = 0x810, "LUC_DiseaseImmunityAb"
SPELL_NAME, SPELL_DESC = "Hardy Constitution", "Immune to disease."
AB_RESIST_DISEASE = 0x000E40D3
QUEST_ID, QUEST_EDID = 0x820, "LUC_MainQuest"
MAIN_SCRIPT, ALIAS_SCRIPT = "LUC_Main", "LUC_PlayerAliasScript"
ALIAS_PROPS = ["LUC_PrayerKey", "LUC_AmenKey", "LUC_PrayerEnabled", "LUC_ActivateRequest"]


def sub(sig, value): return E.Sub(sig, value=value, typed=True)


def raw(sig, b): return E.Sub(sig, raw=b)


def glob(lid, edid, kind, val):
    return E.Record("GLOB", formid=SELF | lid, subs=[
        sub("EDID", edid), sub("FNAM", {"kind": ord(kind)}), sub("FLTV", struct.pack("<f", float(val)))])


def prop_obj(name, formid):
    return {"name": name, "type": 1, "status": 1, "value": {"form": formid, "alias": -1, "unused": 0}}


def spell():
    return E.Record("SPEL", formid=SELF | SPELL_ID, subs=[
        sub("EDID", SPELL_EDID),
        raw("OBND", bytes(12)),
        sub("FULL", SPELL_NAME),
        raw("ETYP", struct.pack("<I", 0x00013F44)),
        sub("DESC", SPELL_DESC),
        raw("SPIT", bytes.fromhex("000000000000000004000000000000000000000000000000000000000000000000000000")),
        raw("EFID", struct.pack("<I", AB_RESIST_DISEASE)),
        raw("EFIT", struct.pack("<fII", 200.0, 0, 0)),
    ])


def quest():
    gid = {edid: SELF | lid for lid, edid, _, _ in GLOBALS}
    main_props = [prop_obj(edid, gid[edid]) for _, edid, _, _ in GLOBALS] + [prop_obj("PlayerRef", PLAYER_REF)]
    alias_props = [prop_obj(n, gid[n]) for n in ALIAS_PROPS] + [prop_obj("PlayerRef", PLAYER_REF)]
    vmad = {"version": 5, "objFormat": 2,
            "scripts": [{"name": MAIN_SCRIPT, "status": 0, "props": main_props}],
            "quest": {"unk": 2, "fragments": [], "fileName": "",
                      "aliases": [{"object": {"form": SELF | QUEST_ID, "alias": 0, "unused": 0},
                                   "version": 5, "objFormat": 2,
                                   "scripts": [{"name": ALIAS_SCRIPT, "status": 0, "props": alias_props}]}]}}
    return E.Record("QUST", formid=SELF | QUEST_ID, subs=[
        sub("EDID", QUEST_EDID),
        sub("VMAD", vmad),
        sub("DNAM", {"flags": 0x11, "priority": 0, "formVersion": 255, "unknown": 0, "type": 0, "pad": bytes(3)}),
        sub("NEXT", None),
        sub("ANAM", 1),
        sub("ALST", 0), sub("ALID", "LUC_PlayerAlias"), raw("FNAM", bytes(4)),
        sub("ALUA", PLAYER_BASE), raw("VTCK", bytes(4)), sub("ALED", None),
    ])


def build():
    globs = [glob(*g) for g in GLOBALS]
    groups = [E.Group(b"GLOB", 0, children=globs), E.Group(b"SPEL", 0, children=[spell()]),
              E.Group(b"QUST", 0, children=[quest()])]
    header = E.Record("TES4", flags=0x200, formid=0, subs=[
        sub("HEDR", {"version": struct.pack("<f", 1.71), "numRecords": 0, "nextObjectId": 0}),
        sub("CNAM", "shae"),
        sub("SNAM", "Lucienne (private, her playthrough only): prayer channel, journal, disease ability. Frozen record set; scripts carry the logic."),
        sub("MAST", "Skyrim.esm"), sub("DATA", {"size": 0}),
        sub("INTV", 1),
    ])
    p = E.Plugin(header, groups)
    p.localized = False
    hedr = header.subs[0].value
    hedr["numRecords"] = E.count_records_and_groups(p)
    hedr["nextObjectId"] = max([g[0] for g in GLOBALS] + [SPELL_ID, QUEST_ID]) + 1
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
    print("Lucienne.esl: %d bytes, ESL flag %s, records %d (HEDR %d), globals %d, spell 1, quest script %s (%d props), alias scripts %s"
          % (len(data), bool(q.header.flags & 0x200), len(ids), q.header.subs[0].value["numRecords"], len(GLOBALS),
             v["scripts"][0]["name"], len(v["scripts"][0]["props"]), ", ".join("%s (%d props)" % (a["name"], len(a["props"])) for a in al)))
