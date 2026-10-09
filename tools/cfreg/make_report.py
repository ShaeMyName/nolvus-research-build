import json, os, sys
here = os.path.dirname(os.path.abspath(__file__))
reg = json.load(open(sys.argv[1], encoding="utf-8"))
chk = json.load(open(os.path.join(here, "checks.json"), encoding="utf-8"))["checks"]
lo = [l.strip() for l in open(r"C:\nolvus-research\gamedata\active\_loadorder.txt", encoding="utf-8") if l.strip()]
pos = {n.lower(): i + 1 for i, n in enumerate(lo)}

# EditorIDs that name story content, places tied to quests, or dialogue lines: withheld (spoiler rule)
WITHHELD = {"HLIOArkngHolding", "HLIOCidhnaForceGreet", "HLIOCidhnaForceGreetV2", "HLIOTODDismiss",
            "AK69KatanaBountyHunt", "AK69TRLCompleted", "DLC1VQ05PostMove", "InigofollowerDialoguejustdontshoot"}

def ed(r):
    if r["found"] not in ("GLOB", "FACT", "NPC_", "DIAL"):
        return "—"
    e = r.get("edid")
    if not e:
        return "(none)"
    return "(withheld: names story content)" if e in WITHHELD else "`%s`" % e

L = []
L.append("# Custom-follower registry draft: FormID verification (round 10, 2026-10-09)")
L.append("")
L.append("Checks `build/data/custom_followers.draft.json` (spec §6.5 Mode 4 registry, with the [CORRECTED 2026-10-08] stage windows) against the plugin copies in `gamedata/active/` and `gamedata/` (base masters).")
L.append("")
L.append("- **Spoiler-safe.** Quests and scenes are named only by the neutral labels of the round 9 reports. EditorIDs are shown only for GLOB, FACT, NPC_ and DIAL records, and a few of those are withheld because they name story content or a dialogue line.")
L.append("- **Method.** Every FormID is the file-local low 24 bits. It is resolved as the stated plugin's **own** record (top byte = number of masters), the way `GetFormFromFile` resolves it; the record type is compared with the type the term needs. Parser: `build/tools/espio.py` (`parse_record`/`parse_subs`) over a lazy group walk. Extra checks: the ACHR's `NAME` equals the base and its persistent flag (0x400); the alias index exists in the quest (`ALST`/`ALLS`); every stage in a `quest_stage_in` list is a defined stage (`INDX`), and each stage range contains at least one defined stage; Serana's controller quest carries `DLC1_NPCMentalModelScript` in its VMAD.")
L.append("- **Load order.** Each plugin was checked against `gamedata/active/_loadorder.txt` (%d entries). Positions: %s." % (
    len(lo), ", ".join("`%s` %d" % (p, pos.get(p.lower(), 0)) for p in
                       ["Skyrim.esm", "Dawnguard.esm", "Inigo.esp", "Lucien.esp", "HLIORemi.esp", "HLIIRemiLOTD.esp", "Katana.esp",
                        "018Auri.esp", "Relationship Dialogue Overhaul.esp", "TT_MARAS.esp", "SeverActions.esp", "nwsFollowerFramework.esp"])))
L.append("- **Topics.** Where the reports list only the follow/wait/dismiss INFO, the DIAL is the INFO's parent topic group in the plugin (marked *derived* in the JSON `source`).")
L.append("- VERIFIED = read in the plugin copy. INFERRED = reasoning.")
L.append("")

n_rows = len(chk)
n_bad = sum(1 for r in chk if not r["ok"])
L.append("## Summary")
L.append("")
L.append("| NPC | verified | FormID checks | problems |")
L.append("|---|---|---|---|")
for n in reg["npcs"]:
    rows = [r for r in chk if r["npc"] == n["name"]]
    L.append("| %s | %s | %d | %s |" % (n["name"], "yes" if n["verified"] else "**no**", len(rows),
                                     "; ".join(n["problems"]) if n["problems"] else "none"))
crow = [r for r in chk if r["npc"] == "(common)"]
L.append("| *(common refuse)* | %s | %d | %s |" % ("yes" if reg["common_refuse_verified"] else "**no**", len(crow),
                                                   "; ".join(reg["common_refuse_problems"]) or "none"))
L.append("")
L.append("Total: %d FormID checks (%d distinct plugin+FormID pairs), %d not ok. Every record type matched its term; the two failures are the persistence check on two RDO refs (below)." % (
    n_rows, len({(r["plugin"], r["form"]) for r in chk}), n_bad))
L.append("")

for n in reg["npcs"] + [{"name": "(common)"}]:
    rows = [r for r in chk if r["npc"] == n["name"]]
    title = "Common refuse terms" if n["name"] == "(common)" else "%s (`%s`)" % (n["name"], n["plugin"])
    L.append("## %s" % title)
    L.append("")
    if n["name"] != "(common)":
        L.append("park `%s`%s; ref `%s`." % (n["park"], (", G-WAIT `%s`" % n["gwait"]["form"]) if n.get("gwait") else "", n["ref"]))
        for note in n.get("notes", []):
            L.append("- %s" % note)
        L.append("")
    L.append("| FormID | plugin | kind | expected type | found type | EditorID | ok | note |")
    L.append("|---|---|---|---|---|---|---|---|")
    seen = set()
    for r in rows:
        key = (r["plugin"], r["form"], r["kind"])
        if key in seen:
            continue
        seen.add(key)
        L.append("| `%s` | %s | %s | %s | %s | %s | %s | %s |" % (r["form"], r["plugin"], r["kind"], r["expected"], r["found"],
                                                          ed(r), "yes" if r["ok"] else "**NO**", r["note"].strip() or ""))
    L.append("")

L.append("## Problems and ambiguities")
L.append("")
L.append("1. **Gelebor ref `Dawnguard.esm 0x00A878` and Valerica ref `0x003B8E` are not persistent.** Both are ACHRs whose NAME is the right base, but they sit in temporary cell-children groups (type 9) with record flag 0x400 clear (Gelebor's carries 0x800, initially disabled). No plugin in the active order overrides either record. `RDO_followers_windows.md` calls them \"persistent refs\"; that is not what the plugin says. `GetFormFromFile` on them can return None while their cell is not loaded, so the bridge should identify these two by base (or by the RDO alias) rather than by ref. VERIFIED. Left as written in the JSON (`verified: false`).")
L.append("2. **Auri `ref`** is not given in the spec or the reports. The draft uses the only ACHR of her base in `018Auri.esp`, `0x3139C8` (persistent). VERIFIED.")
L.append("3. **Serana's C1 bools** (`IsWillingToWait`, `LockedIn`, `SimpleFollow`, `TurnOffComeWithMe`, `IsWaiting`, `QuestLineCompleted`) are not set in the quest's VMAD, so the plugin cannot confirm them. All eight bools used are declared `bool Property … Auto Conditional` in `sdk/vanilla_psc` and in the USSEP source, so a cast-and-read works. VERIFIED (source).")
L.append("4. **SA `double_managed` faction** has no FormID in the spec or reports. The draft resolves `SeverActions_FollowerFaction` by EditorID in `SeverActions.esp` (`0x0EB708`, FACT). The `Native_WasEverFollower` branch is a DLL call, not a FormID. The report marks the whole term INFERRED.")
L.append("5. **Remiel's wait and \"follow me again\" INFOs share one DIAL** (`0x02E119`), so that topic carries role `wait+follow`. VERIFIED.")
L.append("6. **Inigo's relax topic** is not in the list: the reports name its script but not its INFO or DIAL.")
L.append("7. **Stage tests without `running`.** As in the spec, Lucien P1/P2/P3, Remiel P2, Katana/Megara/Shale Q3 and Auri P1 are plain `GetStage` tests. Lucien P1-P3 and Auri P1 are start-game quests, and every range is bounded, so a stopped quest can only refuse if it stopped inside a window. INFERRED, harmless.")
L.append("")
open(sys.argv[2], "w", encoding="utf-8", newline="\n").write("\n".join(L) + "\n")
print("rows", n_rows, "bad", n_bad)
