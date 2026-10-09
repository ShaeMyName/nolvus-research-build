"""Generate IEB_CFData.psc (Mode 4 custom-follower registry as plain Papyrus) and the shipped registry JSON from the
verified draft build/data/custom_followers.draft.json (spec §6.5).

[CHANGED in build] The spec reads custom_followers.json at runtime; here the verified registry is compiled into
Papyrus instead (faster, readable, reviewable as a diff). The JSON stays the single source and ships alongside for
reference. Corrections applied on top of the draft (step3_api_facts.md):
  - SeverActionsNative.Native_WasEverFollower does not exist there; the RDO followers' 'SA has rostered them' term
    uses SA's roster test SeverActionsNativeExt.Native_GetIsFollower (exact for 'rostered')."""
import json, os

SRC = "C:/nolvus-research/build/data/custom_followers.draft.json"
OUT_JSON = "C:/nolvus-research/build/data/custom_followers.json"
OUT_PSC = "C:/nolvus-research/build/src/errandbridge/Source/Scripts/IEB_CFData.psc"

d = json.load(open(SRC, encoding="utf-8"))


def fix(o):
    if isinstance(o, dict):
        if o.get("kind") == "native_call" and o.get("api") == "SeverActionsNative.Native_WasEverFollower":
            o["api"] = "SeverActionsNativeExt.Native_GetIsFollower"
            o["fixed"] = "was SeverActionsNative.Native_WasEverFollower (no such function there); roster test is exact"
        for v in o.values():
            fix(v)
    elif isinstance(o, list):
        for x in o:
            fix(x)


fix(d)
# Test hook (spec §15.3.1, harness E): while ErrandBridgeTest.esp's IEB_TestCFRefuse (0x800) is 1, every registry entry
# refuses. IEB_CFLib.Glob returns -99999 when the plugin is absent, so the term is always false in Lucienne's profile.
TEST_TERM = {"kind": "global_eq", "label": "harness IEB_TestCFRefuse", "plugin": "ErrandBridgeTest.esp",
             "form": "0x000800", "value": 1, "reason": "cf_test_refuse"}
if not any(t.get("reason") == "cf_test_refuse" for t in d["common_refuse"]):
    d["common_refuse"].append(TEST_TERM)
json.dump(d, open(OUT_JSON, "w", encoding="utf-8", newline="\n"), indent=1)


def hx(s):
    return "0x%08X" % int(s, 16)


def q(s):
    return '"' + s + '"'


def subj(t):
    return "Game.GetPlayer()" if t.get("subject") == "player" else "a"


def expr(t):
    """Papyrus Bool expression for one term (with its optional 'and' list), or an 'any' group."""
    if "kind" not in t:
        if "any" in t:
            return "(" + " || ".join(expr(x) for x in t["any"]) + ")"
        if "and" in t:
            return "(" + " && ".join(expr(x) for x in t["and"]) + ")"
        raise ValueError("term without kind: %r" % t)
    k = t["kind"]
    P = q(t.get("plugin", ""))
    if k == "teammate":
        e = "a.IsPlayerTeammate()"
    elif k == "wfp_eq":
        e = "a.GetActorValue(\"WaitingForPlayer\") == %s" % float(t["value"])
    elif k == "wfp_ne":
        e = "a.GetActorValue(\"WaitingForPlayer\") != %s" % float(t["value"])
    elif k == "global_eq":
        e = "IEB_CFLib.Glob(%s, %s) == %s" % (hx(t["form"]), P, float(t["value"]))
    elif k == "global_ne":
        e = "IEB_CFLib.Glob(%s, %s) != %s" % (hx(t["form"]), P, float(t["value"]))
    elif k == "global_in":
        e = "(" + " || ".join("IEB_CFLib.Glob(%s, %s) == %s" % (hx(t["form"]), P, float(v)) for v in t["values"]) + ")"
    elif k == "in_faction":
        e = "IEB_CFLib.InFac(a, %s, %s)" % (hx(t["form"]), P)
    elif k == "not_in_faction":
        e = "!IEB_CFLib.InFac(a, %s, %s)" % (hx(t["form"]), P)
    elif k == "faction_rank_ne":
        e = "IEB_CFLib.FacRank(a, %s, %s) != %d" % (hx(t["form"]), P, t["value"])
    elif k == "faction_rank_gt":
        e = "IEB_CFLib.FacRank(a, %s, %s) > %d" % (hx(t["form"]), P, t["value"])
    elif k == "alias_holds":
        e = "IEB_CFLib.AliasHolds(a, %s, %s, %d)" % (hx(t["quest"]), P, t["alias"])
    elif k == "quest_running":
        e = "IEB_CFLib.QRun(%s, %s)" % (hx(t["quest"]), P)
    elif k == "quest_stage_in":
        e = "IEB_CFLib.StageIn(%s, %s, \"|%s|\")" % (hx(t["quest"]), P, "|".join(str(s) for s in t["stages"]))
        if t.get("running"):
            e = "(IEB_CFLib.QRun(%s, %s) && %s)" % (hx(t["quest"]), P, e)
    elif k == "quest_stage_range":
        mx = t["max"] if t.get("max") is not None else 99999
        e = "IEB_CFLib.StageRange(%s, %s, %d, %d)" % (hx(t["quest"]), P, t["min"], mx)
        if t.get("running"):
            e = "(IEB_CFLib.QRun(%s, %s) && %s)" % (hx(t["quest"]), P, e)
    elif k == "quest_stage_not_done":
        e = "!IEB_CFLib.StageDone(%s, %s, %d)" % (hx(t["quest"]), P, t["stage"])
    elif k == "in_cell":
        e = "IEB_CFLib.InCell(%s, %s, %s)" % (subj(t), hx(t["form"]), P)
    elif k == "in_location":
        e = "IEB_CFLib.InLoc(%s, %s, %s)" % (subj(t), hx(t["form"]), P)
    elif k == "scene_playing":
        e = "IEB_CFLib.ScenePlaying(%s, %s)" % (hx(t["form"]), P)
    elif k == "script_bool":
        assert t["script"] == "DLC1_NPCMentalModelScript" and t["quest"].lower() in ("0x002b6e",), t
        e = "IEB_CFLib.SeranaBool(%s) == %s" % (q(t["property"]), "True" if t["value"] else "False")
    elif k == "current_scene":
        e = "a.GetCurrentScene() != None"
    elif k == "on_mount":
        e = "a.IsOnMount()"
    elif k == "in_combat":
        e = "a.IsInCombat()"
    elif k == "nff_seated":
        e = "IEB_NFFLib.Seated(a)"
    elif k == "native_call":
        api = t["api"]
        if api == "MARAS.GetTenantHouse":
            e = "(IEB_CFLib.MarasOn() && MARAS.GetTenantHouse(a) != None)"
        elif api == "MARAS.IsNPCStatus":
            e = "(IEB_CFLib.MarasOn() && MARAS.IsNPCStatus(a, %s))" % q(t["args"][1])
        elif api == "SeverActionsNativeExt.Native_GetIsFollower":
            e = "(IEB_SALib.Present() && SeverActionsNativeExt.Native_GetIsFollower(a))"
        else:
            raise ValueError("unmapped native_call " + api)
    else:
        raise ValueError("unknown kind " + k)
    if "and" in t:
        e = "(" + e + " && " + " && ".join(expr(x) for x in t["and"]) + ")"
    if "any" in t:
        e = "(" + e + " && (" + " || ".join(expr(x) for x in t["any"]) + "))"
    return e


def reason(t, default):
    return t.get("reason") or default


npcs = d["npcs"]
L = []
A = L.append
A("Scriptname IEB_CFData Hidden")
A("{GENERATED by build/tools/gen_cfdata.py from build/data/custom_followers.json (verified registry, spec §6.5).")
A(" Do not edit by hand. Mode 4 custom-framework followers: identity, recruited test, refuse terms, park kind.}")
A("")
A("Int Function Count() Global")
A("    Return %d" % len(npcs))
A("EndFunction")
A("")
A("Int Function IndexOf(Actor a) Global")
A("    {Registry index by base actor (robust when a placed ref is not persistent), or -1.}")
A("    If a == None")
A("        Return -1")
A("    EndIf")
A("    ActorBase b = a.GetActorBase()")
for i, n in enumerate(npcs):
    A("    If Game.IsPluginInstalled(%s) && b == Game.GetFormFromFile(%s, %s)" % (q(n["plugin"]), hx(n["base"]), q(n["plugin"])))
    A("        Return %d   ; %s" % (i, n["name"]))
    A("    EndIf")
A("    Return -1")
A("EndFunction")
A("")
A("String Function Name(Int i) Global")
for i, n in enumerate(npcs):
    A("    %s i == %d" % ("If" if i == 0 else "ElseIf", i))
    A("        Return %s" % q(n["name"]))
A("    EndIf")
A("    Return \"\"")
A("EndFunction")
A("")
A("String Function ParkKind(Int i) Global")
for i, n in enumerate(npcs):
    A("    %s i == %d" % ("If" if i == 0 else "ElseIf", i))
    A("        Return %s" % q(n["park"]))
A("    EndIf")
A("    Return \"none\"")
A("EndFunction")
A("")
A("GlobalVariable Function GWait(Int i) Global")
A("    {The follower's own wait global for park = wfp+global, else None.}")
for i, n in enumerate(npcs):
    g = n.get("gwait")
    if g:
        A("    If i == %d" % i)
        A("        Return Game.GetFormFromFile(%s, %s) as GlobalVariable" % (hx(g["form"]), q(g["plugin"])))
        A("    EndIf")
A("    Return None")
A("EndFunction")
A("")
A("Bool Function Recruited(Int i, Actor a) Global")
for i, n in enumerate(npcs):
    A("    %s i == %d   ; %s" % ("If" if i == 0 else "ElseIf", i, n["name"]))
    A("        Return " + " && ".join(expr(t) for t in n["recruited"]))
A("    EndIf")
A("    Return False")
A("EndFunction")
A("")
A("String Function RefuseReason(Int i, Actor a) Global")
A("    {First matching refuse term's reason, else \"\". Common terms first, then the follower's own.}")
for t in d["common_refuse"]:
    A("    If %s" % expr(t))
    A("        Return %s" % q(reason(t, "cf_common")))
    A("    EndIf")
for i, n in enumerate(npcs):
    A("    %s i == %d   ; %s" % ("If" if i == 0 else "ElseIf", i, n["name"]))
    for t in n["refuse"]:
        A("        If %s" % expr(t))
        A("            Return %s" % q(reason(t, "cf_" + n["name"].lower())))
        A("        EndIf")
A("    EndIf")
A("    Return \"\"")
A("EndFunction")
open(OUT_PSC, "w", encoding="utf-8", newline="\n").write("\n".join(L) + "\n")
print("IEB_CFData.psc: %d followers, %d lines; registry JSON written" % (len(npcs), len(L)))
