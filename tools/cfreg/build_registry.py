"""Build + verify the Mode 4 custom-follower registry draft (spec §6.5). Read-only on plugin copies.
Writes nothing itself except the JSON passed via --out and a raw verification dump (json) for the report."""
import json, os, struct, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pidx

SK, DG = "Skyrim.esm", "Dawnguard.esm"
INI, LUC, REM, REML, KAT, AUR = "Inigo.esp", "Lucien.esp", "HLIORemi.esp", "HLIIRemiLOTD.esp", "Katana.esp", "018Auri.esp"
RDO, MAR, NFF, SA = "Relationship Dialogue Overhaul.esp", "TT_MARAS.esp", "nwsFollowerFramework.esp", "SeverActions.esp"

DFF = (SK, 0x05C84C)    # DismissedFollowerFaction
CFF = (SK, 0x05C84E)    # CurrentFollowerFaction


def h(x): return "0x%06X" % x

# ------------------------------------------------------------------ term constructors

def T(kind, label=None, **kw):
    d = {"kind": kind}
    if label: d["label"] = label
    for k, v in kw.items():
        if k in ("form", "quest") and isinstance(v, int):
            v = h(v)
        d[k] = v
    return d

def glob_eq(pl, f, v, label=None): return T("global_eq", label, plugin=pl, form=f, value=v)
def glob_ne(pl, f, v, label=None): return T("global_ne", label, plugin=pl, form=f, value=v)
def glob_in(pl, f, vs, label=None): return T("global_in", label, plugin=pl, form=f, values=vs)
def in_fac(pl, f, label=None): return T("in_faction", label, plugin=pl, form=f)
def not_in_fac(pl, f, label=None): return T("not_in_faction", label, plugin=pl, form=f)
def alias_holds(pl, q, a, label=None): return T("alias_holds", label, plugin=pl, quest=q, alias=a)
def q_running(pl, q, label=None): return T("quest_running", label, plugin=pl, quest=q)
def q_stage_in(pl, q, st, label=None, running=False):
    return T("quest_stage_in", label, plugin=pl, quest=q, stages=st, **({"running": True} if running else {}))
def q_range(pl, q, lo, hi, label=None, running=False):
    return T("quest_stage_range", label, plugin=pl, quest=q, min=lo, max=hi, **({"running": True} if running else {}))
def sbool(pl, q, prop, val, label=None):
    return T("script_bool", label, plugin=pl, quest=q, script="DLC1_NPCMentalModelScript", property=prop, value=val)
def AND(term, *more): term = dict(term); term["and"] = list(more); return term
def ANY(label, *terms, reason=None):
    d = {"label": label}
    if reason: d["reason"] = reason
    d["any"] = list(terms); return d
def R(reason, term):
    term = dict(term); term["reason"] = reason; return term


def topic(pl, f, role, source="report"): return {"plugin": pl, "form": h(f), "role": role, "source": source}

# INFOs whose parent DIAL is derived from the plugin (reports give the INFO only)
DERIVE = []   # (npc, plugin, info_local, role)

# ------------------------------------------------------------------ registry (spec §6.5 as corrected 2026-10-08)

common_refuse = [
    ANY("MARAS housed tenant", in_fac(MAR, 0x00006C, "MARAS housed faction"),
        T("native_call", "MARAS tenant house set", api="MARAS.GetTenantHouse", args=["actor"], test="not_none"),
        reason="cf_maras_housed"),
    R("cf_scene", T("current_scene", "in a scene")),
    R("cf_mounted", T("on_mount", "on a mount")),
    R("cf_combat", T("in_combat", "in combat")),
    R("cf_dismissed", in_fac(DFF[0], DFF[1], "DismissedFollowerFaction")),
]

sa_double = ANY("SA roster (double_managed)",
                in_fac(SA, None, "SA follower faction"),       # FormID resolved below by EditorID lookup
                AND(T("native_call", "SA ever-follower", api="SeverActionsNative.Native_WasEverFollower",
                      args=["actor"], test="true"),
                    not_in_fac(DFF[0], DFF[1], "not dismissed")),
                reason="double_managed")

npcs = {}

npcs["Inigo"] = dict(
    plugin=INI, base=0x000D62, ref=0x008AE9,
    recruited=[T("teammate", "teammate flag"), T("wfp_eq", "following (WFP 0)", value=0)],
    park="none",
    refuse=[R("cf_inigo_summon", T("faction_rank_ne", "summon faction", plugin=INI, form=0x0A0957, value=1)),
            R("cf_inigo_ride", T("faction_rank_gt", "ride-with-player faction", plugin=INI, form=0x04EA5F, value=0))],
    topics=[topic(INI, 0x04EA51, "follow"), topic(INI, 0x00184D, "follow"), topic(INI, 0x04EA58, "wait"),
            topic(INI, 0x04EA4B, "dismiss"), topic(INI, 0x04EFC8, "recruit"), topic(INI, 0x009B3C, "recruit")],
)

npcs["Lucien"] = dict(
    plugin=LUC, base=0x005900, ref=0x00591F,
    recruited=[in_fac(CFF[0], CFF[1], "CurrentFollowerFaction"), glob_eq(LUC, 0x4A2D8B, 1, "recruited global"),
               not_in_fac(DFF[0], DFF[1], "not DismissedFollowerFaction")],
    park="wfp",
    refuse=[R("cf_lucien_p1", q_stage_in(LUC, 0x2B13ED, [92, 95, 100, 113, 115, 360], "P1 hold stages")),
            R("cf_lucien_p1", q_range(LUC, 0x2B13ED, 700, 799, "P1 window 700-799")),
            ANY("L1 location", T("in_location", "actor in L1", plugin=LUC, form=0x2B1404, subject="actor"),
                T("in_location", "player in L1", plugin=LUC, form=0x2B1404, subject="player"), reason="cf_lucien_l1"),
            R("cf_lucien_p2", AND(q_range(LUC, 0x62424C, 1, None, "P2 started"),
                                  T("quest_stage_not_done", "P2 stage 210 not done", plugin=LUC, quest=0x62424C, stage=210))),
            R("cf_lucien_p3", q_range(LUC, 0x1171E9, 10, 14, "P3 window 10-14"))],
    topics=[topic(LUC, 0x00592E, "follow"), topic(LUC, 0x00592B, "wait")],
)
DERIVE += [("Lucien", LUC, 0x005925, "dismiss"), ("Lucien", LUC, 0x005926, "dismiss"), ("Lucien", LUC, 0x00FB4F, "recruit")]

npcs["Remiel"] = dict(
    plugin=REM, base=0x005900, ref=0x033226, addon=REML,
    recruited=[alias_holds(REM, 0x014C11, 0, "follower quest alias 0"), glob_eq(REM, 0x014C10, 1, "recruited global")],
    park="wfp",
    refuse=[R("cf_remiel_stationed", in_fac(REM, 0x1AA1F8, "stationed: relax faction")),
            R("cf_remiel_stationed", in_fac(REM, 0x4D0119, "stationed: home faction")),
            R("cf_remiel_stationed", in_fac(REML, 0x000815, "stationed: LOTD home faction")),
            R("cf_remiel_stationed", glob_in(REML, 0x000A38, [1, 2], "stationed: LOTD stay global")),
            R("cf_remiel_stationed", glob_eq(REML, 0x000A39, 1, "stationed: LOTD stay global 2")),
            R("cf_remiel_stationed", glob_eq(REML, 0x000A3A, 1, "stationed: LOTD stay global 3")),
            R("cf_remiel_stationed", glob_eq(REML, 0x000BFA, 1, "stationed: LOTD stay global 4")),
            R("cf_remiel_stationed", glob_eq(REM, 0x763FEE, 1, "stationed: hold global")),
            R("cf_remiel_stationed", glob_eq(REM, 0x9318A7, 1, "stationed: force-greet global 1")),
            R("cf_remiel_stationed", glob_eq(REM, 0x940BF0, 1, "stationed: force-greet global 2")),
            R("cf_remiel_stationed", glob_eq(REM, 0x903F7F, 1, "stationed: P4 global")),
            R("cf_remiel_p1", q_range(REM, 0x46FA55, 170, 219, "P1 window 170-219", running=True)),
            R("cf_remiel_p2", q_stage_in(REM, 0x76E49B, [10, 20], "P2 stages 10/20"))],
    topics=[],
)
DERIVE += [("Remiel", REM, 0x02E11A, "wait"), ("Remiel", REM, 0x43CEBE, "wait"), ("Remiel", REM, 0x02E11B, "follow"),
           ("Remiel", REM, 0x02E124, "dismiss"), ("Remiel", REM, 0x43CEB6, "dismiss"), ("Remiel", REM, 0x43CEB7, "dismiss"),
           ("Remiel", REM, 0x43CEB8, "dismiss"), ("Remiel", REM, 0x1308EB, "recruit")]

Q2, Q3 = 0x8BB420, 0x8BB421
q2_term = lambda: R("cf_q2", AND(q_running(KAT, Q2, "Q2 running"), glob_eq(KAT, 0x0A5EEC, 0, "Q2 done global == 0")))
cell_term = lambda: R("cf_mod_cell", T("in_cell", "mod interior cell", plugin=KAT, form=0x84BAFB, subject="actor"))

npcs["Katana"] = dict(
    plugin=KAT, base=0x005900, ref=0x005902,
    recruited=[glob_eq(KAT, 0x617D76, 1, "recruited global"), not_in_fac(DFF[0], DFF[1], "not DismissedFollowerFaction")],
    park="wfp+global", gwait={"plugin": KAT, "form": h(0x63127E)},
    refuse=[ANY("P1 whole", q_running(KAT, 0x8CDE76, "D1 running"),
                AND(q_running(KAT, 0x8E1B19, "P1 running"), glob_eq(KAT, 0x422E21, 0, "P1 done global == 0")),
                reason="cf_katana_p1"),
            ANY("roam mode", glob_eq(KAT, 0x4D41D2, 1, "roam global"), q_running(KAT, 0x10E543, "roam helper quest running"),
                reason="cf_katana_roam"),
            ANY("Q7 away", glob_eq(KAT, 0xF13CD7, 1, "Q7 active global"),
                q_stage_in(KAT, 0xF13CD8, [10, 20], "Q7 stages 10/20", running=True), reason="cf_katana_q7"),
            R("cf_q3", q_range(KAT, Q3, 40, 189, "Q3 window 40-189")),
            q2_term(), cell_term()],
    topics=[],
)
DERIVE += [("Katana", KAT, 0x62C17A, "wait"), ("Katana", KAT, 0x5EF558, "follow"), ("Katana", KAT, 0x5EA44F, "dismiss"),
           ("Katana", KAT, 0x5EF553, "recruit")]

npcs["Megara"] = dict(
    plugin=KAT, base=0x8E6C1E, ref=0x8EBD22,
    recruited=[glob_eq(KAT, 0x1C34FC, 1, "recruited global")],
    park="wfp+global", gwait={"plugin": KAT, "form": h(0x1C85FD)},
    refuse=[ANY("Q3 window", q_stage_in(KAT, Q3, [20], "Q3 stage 20"), q_range(KAT, Q3, 40, 189, "Q3 window 40-189"),
                reason="cf_q3"),
            q2_term(), cell_term()],
    topics=[],
)
DERIVE += [("Megara", KAT, 0x1C8609, "wait"), ("Megara", KAT, 0x1C8603, "follow"), ("Megara", KAT, 0x1C860C, "dismiss"),
           ("Megara", KAT, 0x1C8600, "recruit")]

npcs["Shale"] = dict(
    plugin=KAT, base=0x8283EB, ref=0x8376F9,
    recruited=[glob_eq(KAT, 0xCC4B3D, 1, "recruited global")],
    park="wfp+global", gwait={"plugin": KAT, "form": h(0x0B520C)},
    refuse=[R("cf_q3", q_range(KAT, Q3, 40, 189, "Q3 window 40-189")), q2_term(), cell_term()],
    topics=[],
)
DERIVE += [("Shale", KAT, 0x22BEF0, "wait"), ("Shale", KAT, 0x22BEDE, "follow"), ("Shale", KAT, 0x22BEE6, "dismiss"),
           ("Shale", KAT, 0x22BED8, "recruit")]

npcs["Auri"] = dict(
    plugin=AUR, base=0x000D63, ref=None,
    recruited=[alias_holds(AUR, 0x508FC2, 0, "controller alias 0"), glob_eq(AUR, 0x508FC3, 1, "recruited global")],
    park="wfp",
    refuse=[R("cf_auri_p1", q_stage_in(AUR, 0x03E4B1, [60], "P1 stage 60")),
            R("cf_auri_p1", T("scene_playing", "P1 travel scene", plugin=AUR, form=0x0528E1))],
    topics=[topic(AUR, 0x50E0C6, "recruit"), topic(AUR, 0x50E0C8, "follow+wait"), topic(AUR, 0x50E0CA, "rest"),
            topic(AUR, 0x50E0D0, "dismiss")],
)

npcs["Gelebor"] = dict(
    plugin=DG, base=0x00A877, ref=0x00A878, recruiter=RDO,
    recruited=[alias_holds(RDO, 0x69CFA7, 0, "RDO follower alias 0"), T("teammate", "teammate flag")],
    park="wfp",
    refuse=[R("cf_gelebor_q7", q_running(DG, 0x002853, "DG8 running (defensive)")), sa_double],
    topics=[], topic_quests=[{"plugin": RDO, "quest": h(0x69CFA7), "note": "whole quest blacklisted (S-33)"}],
)
npcs["Isran"] = dict(
    plugin=DG, base=0x00336A, ref=0x003478, recruiter=RDO,
    recruited=[alias_holds(RDO, 0x69CFA8, 0, "RDO follower alias 0"), T("teammate", "teammate flag")],
    park="wfp",
    refuse=[R("cf_isran_q1", q_range(DG, 0x00D06C, 0, 179, "DG1 running, stage < 180 (defensive)", running=True)),
            R("cf_isran_q2", q_running(DG, 0x002F65, "DG2 running (defensive)")),
            R("cf_isran_q3", q_running(DG, 0x0098CB, "DG3 running (defensive)")),
            R("cf_isran_q4", q_running(DG, 0x004E24, "DG4 running (defensive)")),
            R("cf_isran_q8", q_running(DG, 0x007C25, "DG10 running (defensive)")),
            R("cf_isran_r10", q_running(DG, 0x019938, "DG14 running (defensive)")),
            sa_double],
    topics=[], topic_quests=[{"plugin": RDO, "quest": h(0x69CFA8), "note": "whole quest blacklisted (S-33)"}],
)
npcs["Valerica"] = dict(
    plugin=DG, base=0x003B8B, ref=0x003B8E, recruiter=RDO,
    recruited=[alias_holds(RDO, 0x02E152, 0, "RDO follower alias 0"), T("teammate", "teammate flag")],
    park="wfp",
    refuse=[R("cf_valerica_q5", q_running(DG, 0x002850, "DG6 running (defensive)")),
            R("cf_valerica_move", glob_ne(DG, 0x015A22, 2, "G1 != 2 (defensive)")),
            sa_double],
    topics=[], topic_quests=[{"plugin": RDO, "quest": h(0x02E152), "note": "whole quest blacklisted (S-33)"}],
)

C1 = 0x002B6E
npcs["Serana"] = dict(
    plugin=DG, base=0x002B6C, ref=0x002B74,
    recruited=[sbool(DG, C1, "IsFollowing", True, "C1 following"), sbool(DG, C1, "IsDismissed", False, "C1 not dismissed"),
               T("teammate", "teammate flag")],
    park="wfp",
    refuse=[R("cf_serana_unwilling", sbool(DG, C1, "IsWillingToWait", False, "C1 unwilling to wait")),
            R("cf_serana_locked", sbool(DG, C1, "LockedIn", True, "C1 locked in")),
            R("cf_serana_simple", sbool(DG, C1, "SimpleFollow", True, "C1 simple follow")),
            R("cf_serana_nocome", sbool(DG, C1, "TurnOffComeWithMe", True, "C1 follow topic off")),
            ANY("own wait", sbool(DG, C1, "IsWaiting", True, "C1 waiting"), T("wfp_ne", "WFP != 0", value=0),
                reason="cf_serana_waiting"),
            R("cf_serana_questline", sbool(DG, C1, "QuestLineCompleted", False, "questline incomplete (S-35 a)")),
            R("cf_serana_qc", q_range(DG, 0x005044, 0, 99, "Q-C running, stage < 100", running=True)),
            R("cf_wedding_pending", AND(q_running(SK, 0x07404E, "vanilla wedding quest running"),
                                        T("native_call", "MARAS status engaged", api="MARAS.IsNPCStatus",
                                          args=["actor", "engaged"], test="true")))],
    test_vectors_only=[
        q_running(DG, 0x002F65, "Q-S2 running"), q_running(DG, 0x00284F, "Q-S4 running"),
        q_running(DG, 0x002850, "Q-S5 running"), q_running(DG, 0x002852, "Q-S6 running"),
        q_running(DG, 0x002853, "Q-S7 running"), q_running(DG, 0x007C25, "Q-S8 running"),
        q_range(DG, 0x004C3D, 80, None, "Q-S3a running, stage >= 80", running=True),
        q_range(DG, 0x0098CB, 80, None, "Q-S3b running, stage >= 80", running=True),
        q_running(DG, 0x00352A, "Q-S1 running (defensive)"), q_running(DG, 0x006BDA, "Q-T running (defensive)"),
        q_stage_in(DG, 0x004E24, [70], "Q-H stage 70 (defensive)", running=True)],
    topics=[topic(DG, 0x01508C, "follow"), topic(DG, 0x01508D, "wait"), topic(DG, 0x01508B, "dismiss"),
            topic(NFF, 0x016EAF, "nff_import"), topic(NFF, 0x11FFAC, "nff_export")],
    topic_quests=[{"plugin": DG, "quest": h(C1), "note": "whole controller quest blacklisted (spec 6.5)"}],
)

# ------------------------------------------------------------------ verification

loadorder = [l.strip() for l in open(os.path.join(pidx.GD, "active", "_loadorder.txt"), encoding="utf-8") if l.strip()]
lo_set = {l.lower() for l in loadorder}

EXPECT = {"global_eq": "GLOB", "global_ne": "GLOB", "global_in": "GLOB", "in_faction": "FACT", "not_in_faction": "FACT",
          "faction_rank_ne": "FACT", "faction_rank_gt": "FACT", "alias_holds": "QUST", "quest_running": "QUST",
          "quest_stage_in": "QUST", "quest_stage_range": "QUST", "quest_stage_not_done": "QUST", "script_bool": "QUST",
          "in_location": "LCTN", "in_cell": "CELL", "scene_playing": "SCEN"}
SHOW_EDID = {"GLOB", "FACT", "NPC_", "DIAL"}

checks = []   # rows for the report


def stages_of(rec):
    out = []
    for s in rec.subs:
        if s.sig == "INDX" and len(s.raw) >= 2:
            out.append(struct.unpack("<H", s.raw[:2])[0])
    return sorted(set(out))


def alias_ids(rec):
    return [struct.unpack("<I", s.raw[:4])[0] for s in rec.subs if s.sig in ("ALST", "ALLS")]


def alias_forced_refs(rec):
    """map alias id -> ALFR (forced ref) if any"""
    out, cur = {}, None
    for s in rec.subs:
        if s.sig in ("ALST", "ALLS"):
            cur = struct.unpack("<I", s.raw[:4])[0]
        elif s.sig == "ALFR" and cur is not None:
            out[cur] = struct.unpack("<I", s.raw[:4])[0]
    return out


def vmad_scripts(rec):
    import espio
    for s in rec.subs:
        if s.sig == "VMAD":
            try:
                v = espio.vmad_dec(s.raw, "QUST")
                return [(sc["name"], [p["name"] for p in sc["props"]]) for sc in v["scripts"]]
            except Exception as e:
                return [("<vmad decode error %s>" % e, [])]
    return []


def check(npc, plugin, local, kind, expected, problems, extra=None):
    row = {"npc": npc, "plugin": plugin, "form": h(local), "kind": kind, "expected": expected,
           "found": None, "edid": None, "ok": False, "note": ""}
    if plugin.lower() not in lo_set:
        row["note"] = "plugin not in _loadorder.txt"
        problems.append("%s %s: plugin %s not in active load order" % (kind, h(local), plugin))
    try:
        p = pidx.get(plugin)
    except FileNotFoundError:
        row["note"] += " plugin copy missing"
        problems.append("%s %s: no plugin copy for %s" % (kind, h(local), plugin))
        checks.append(row); return None, row
    rec, owner = p.lookup_local(local)
    if rec is None:
        row["found"] = "missing"
        problems.append("%s %s (%s): no record" % (kind, h(local), plugin))
        checks.append(row); return None, row
    row["found"] = rec.sig
    if owner != "own":
        row["note"] += " resolves only as %s" % owner
        problems.append("%s %s (%s): not the plugin's own form (%s)" % (kind, h(local), plugin, owner))
    if rec.sig in SHOW_EDID:
        row["edid"] = pidx.edid(rec)
    row["_edid_private"] = pidx.edid(rec)
    row["ok"] = (rec.sig == expected) and owner == "own"
    if rec.sig != expected:
        problems.append("%s %s (%s): expected %s, found %s" % (kind, h(local), plugin, expected, rec.sig))
    checks.append(row)
    return rec, row


def walk_term(npc, t, problems):
    if "any" in t:
        for x in t["any"]:
            walk_term(npc, x, problems)
        return
    k = t.get("kind")
    exp = EXPECT.get(k)
    if exp:
        fld = "quest" if "quest" in t else "form"
        if t[fld] is None:
            return
        local = int(t[fld], 16)
        rec, row = check(npc, t["plugin"], local, k, exp, problems)
        if rec is not None and rec.sig == "QUST":
            st = stages_of(rec)
            if k == "quest_stage_in":
                miss = [s for s in t["stages"] if s not in st]
                if miss:
                    problems.append("%s %s: stages %s not defined in %s's record" % (k, t["quest"], miss, t["plugin"]))
                    row["note"] += " stages %s undefined" % miss
            if k == "quest_stage_range":
                lo, hi = t["min"], t["max"] if t["max"] is not None else 10 ** 6
                inside = [s for s in st if lo <= s <= hi]
                row["note"] += " defined stages in window: %s" % (inside if len(inside) <= 12 else "%d stages" % len(inside))
                if not inside:
                    problems.append("%s %s: no defined stage in %s..%s" % (k, t["quest"], t["min"], t["max"]))
            if k == "quest_stage_not_done" and t["stage"] not in st:
                problems.append("%s %s: stage %s not defined" % (k, t["quest"], t["stage"]))
            if k == "alias_holds":
                ids = alias_ids(rec)
                fr = alias_forced_refs(rec)
                row["note"] += " alias ids %s" % ids[:8]
                if t["alias"] not in ids:
                    problems.append("alias_holds %s: alias %d not in quest" % (t["quest"], t["alias"]))
                    row["ok"] = False
                if t["alias"] in fr:
                    row["note"] += " alias %d forced ref %08X" % (t["alias"], fr[t["alias"]])
            if k == "script_bool":
                scr = vmad_scripts(rec)
                names = [s[0].lower() for s in scr]
                if t["script"].lower() not in names:
                    problems.append("script_bool %s: script %s not attached (%s)" % (t["quest"], t["script"], names))
                    row["ok"] = False
                else:
                    props = [p for s in scr if s[0].lower() == t["script"].lower() for p in s[1]]
                    row["note"] += " script attached; '%s' %s in VMAD" % (
                        t["property"], "set" if t["property"] in props else "not set (auto-property default)") + "; declared 'bool Property ... Auto Conditional' in sdk/vanilla_psc and USSEP source"
    for x in t.get("and", []):
        walk_term(npc, x, problems)


# resolve SA follower faction by EditorID (spec gives no FormID)
sa_fac = None
sap = pidx.get(SA)
for fid, off in sap.by_sig("FACT"):
    r = sap.record(fid)
    if (pidx.edid(r) or "").lower() == "severactions_followerfaction":
        sa_fac = fid & 0xFFFFFF
sa_double["any"][0]["form"] = h(sa_fac) if sa_fac is not None else None
sa_double["any"][0]["note"] = "FormID resolved by EditorID lookup in SeverActions.esp (spec/report give no FormID)"

out_npcs = []
for name, e in npcs.items():
    problems, notes = [], []
    pl = e["plugin"]
    if pl.lower() not in lo_set:
        problems.append("plugin %s not in load order" % pl)
    for extra_pl in [e.get("addon"), e.get("recruiter")]:
        if extra_pl and extra_pl.lower() not in lo_set:
            problems.append("plugin %s not in load order" % extra_pl)
    # base
    brec, _ = check(name, pl, e["base"], "base", "NPC_", problems)
    # ref
    p = pidx.get(pl)
    base_full = p.full_id(e["base"])
    ref_hits = []
    for plug in [pl] + ([e["addon"]] if e.get("addon") else []):
        q = pidx.get(plug)
        # base as seen from q
        bidx = q.masters.index(pl) if pl in q.masters else (q.self_index if plug == pl else None)
        if bidx is None: continue
        bf = (bidx << 24) | e["base"]
        for fid, off in q.by_sig("ACHR"):
            r = q.record(fid)
            nm = pidx.sub_u32(r, "NAME")
            if nm and nm[0] == bf:
                ref_hits.append((plug, fid, bool(r.flags & 0x400)))
    if e["ref"] is None:
        own = [x for x in ref_hits if x[0] == pl and (x[1] >> 24) == p.self_index]
        if len(own) == 1:
            e["ref"] = own[0][1] & 0xFFFFFF
            notes.append("ref not given in spec/reports; found the single ACHR of the base in %s (persistent=%s)" % (pl, own[0][2]))
        else:
            problems.append("ref not given and %d candidate ACHRs found" % len(own))
    if e["ref"] is not None:
        rrec, rrow = check(name, pl, e["ref"], "ref", "ACHR", problems)
        if rrec is not None and rrec.sig == "ACHR":
            nm = pidx.sub_u32(rrec, "NAME")
            if not nm or nm[0] != base_full:
                problems.append("ref %s NAME %s != base %08X" % (h(e["ref"]), ["%08X" % x for x in nm], base_full))
                rrow["ok"] = False
                rrow["note"] += " NAME mismatch"
            else:
                rrow["note"] += " NAME == base; persistent=%s" % bool(rrec.flags & 0x400)
                if not (rrec.flags & 0x400):
                    problems.append("ref %s is not flagged persistent" % h(e["ref"]))
                    rrow["ok"] = False
                    rrow["note"] += " (not persistent: temporary cell child)"
    others = [x for x in ref_hits if not (x[0] == pl and (x[1] & 0xFFFFFF) == (e["ref"] or -1))]
    if others:
        notes.append("other ACHRs of this base: %s" % ["%s %08X" % (a, b) for a, b, c in others])
    if e.get("gwait"):
        check(name, e["gwait"]["plugin"], int(e["gwait"]["form"], 16), "gwait", "GLOB", problems)
    for t in e["recruited"]:
        walk_term(name, t, problems)
    for t in e["refuse"]:
        walk_term(name, t, problems)
    for t in e.get("test_vectors_only", []):
        walk_term(name, t, problems)
    for tq in e.get("topic_quests", []):
        check(name, tq["plugin"], int(tq["quest"], 16), "topic_quest", "QUST", problems)
    # derived topics
    for (n2, plug, info, role) in DERIVE:
        if n2 != name: continue
        q = pidx.get(plug)
        irec, owner = q.lookup_local(info)
        if irec is None or irec.sig != "INFO":
            problems.append("topic derivation: INFO %s not found in %s (found %s)" % (h(info), plug, irec.sig if irec else None))
            continue
        tp = irec.parent_topic
        tplug = q.masters[tp >> 24] if (tp >> 24) < q.self_index else plug
        tloc = tp & 0xFFFFFF
        ex = [x for x in e["topics"] if x["plugin"] == tplug and x["form"] == h(tloc)]
        if ex:
            x = ex[0]
            if role not in x["role"].split("+"):
                x["role"] += "+" + role
            if h(info) not in x["source"]:
                x["source"] += ", %s" % h(info)
        else:
            e["topics"].append({"plugin": tplug, "form": h(tloc), "role": role, "source": "derived: parent DIAL of INFO %s" % h(info)})
    for tpc in e["topics"]:
        check(name, tpc["plugin"], int(tpc["form"], 16), "topic", "DIAL", problems)
    ent = {"name": name, "plugin": pl}
    for k in ("addon", "recruiter"):
        if e.get(k): ent[k] = e[k]
    ent["base"] = h(e["base"]); ent["ref"] = h(e["ref"]) if e["ref"] is not None else None
    ent["recruited"] = e["recruited"]; ent["park"] = e["park"]
    if e.get("gwait"): ent["gwait"] = e["gwait"]
    ent["refuse"] = e["refuse"]
    if e.get("test_vectors_only"):
        ent["test_vectors_only"] = {"note": "spec 6.5: per-quest windows kept only as CF-21 test vectors; NOT used for refusal",
                                    "terms": e["test_vectors_only"]}
    ent["topics"] = e["topics"]
    if e.get("topic_quests"): ent["topic_quests"] = e["topic_quests"]
    ent["verified"] = not problems
    ent["problems"] = problems
    if notes: ent["notes"] = notes
    out_npcs.append(ent)

cproblems = []
for t in common_refuse:
    walk_term("(common)", t, cproblems)

registry = {
    "schema": "errandbridge.custom_followers/draft-1",
    "generated": "2026-10-09",
    "source": "BRIDGE_SPEC_V2.md 6.5 (APPROVED S-34, S-35; stage windows CORRECTED 2026-10-08) + investigation/round9 reports",
    "formid_convention": "file-local low 24 bits; resolve with Game.GetFormFromFile(id, plugin)",
    "semantics": {
        "recruited": "list AND-combined; {'any': [...]} = OR",
        "refuse": "list OR-combined (any true -> refuse, reason = term.reason); a term's 'and' list must also hold; checked at take AND every upkeep tick (CF_REFUSE_MIDTASK)",
        "per_npc_refuse_plus_common": "effective refuse = common_refuse OR npc.refuse",
        "quest_stage_range": "min/max inclusive; max null = unbounded; 'running': true also requires IsRunning()",
        "quest_stage_in": "GetStage() in stages; 'running': true also requires IsRunning()",
        "faction_rank_ne/gt": "GetFactionRank on the actor",
        "wfp": "actor value WaitingForPlayer",
        "script_bool": "cast the quest to the named script and read the bool property",
        "native_call": "DLL/Papyrus API call, not a FormID test",
        "park": "wfp: WFP=1 | wfp+global: gwait=1 then WFP=1 | none",
    },
    "classify": {
        "double_managed_nff": {"kind": "nff_seated", "label": "row 1a: registry NPC also NFF-seated", "reason": "double_managed"},
        "off_switch": {"global": "IEB_CFEnabled (bridge's own plugin)", "reason": "cf_disabled"},
    },
    "common_refuse": common_refuse,
    "common_refuse_verified": not cproblems,
    "common_refuse_problems": cproblems,
    "npcs": out_npcs,
}

if __name__ == "__main__":
    out = sys.argv[1]
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with open(out, "w", encoding="utf-8", newline="\n") as f:
        json.dump(registry, f, indent=2, ensure_ascii=False)
        f.write("\n")
    with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "checks.json"), "w", encoding="utf-8") as f:
        json.dump({"checks": checks, "loadorder_n": len(loadorder)}, f, indent=1)
    tot = sum(len(n["problems"]) for n in out_npcs) + len(cproblems)
    print("npcs", len(out_npcs), "checks", len(checks), "problems", tot)
    for n in out_npcs:
        print(n["name"], n["verified"], n["problems"], n.get("notes"))
    print("common", cproblems)
