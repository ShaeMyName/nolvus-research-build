Scriptname IEB_NFFLib Hidden
{Errand Bridge: every NFF call lives here (spec §3.1). Global library, never attached. Facts: step3_api_facts.md §B
 (controller 0x434F; seats = DialogueFollower 0x0750BA alias IDs 0 and 2..11; nwsAllowWarp 0x01BDFF;
 nwsWarpRange 0x068AE0). Only the silent, synchronous forms are used: FollowerWaitHere(a,0,0), FollowerFollowMe(a,0).}

Bool Function NFFPresent() Global
    Return Game.GetModByName("nwsFollowerFramework.esp") != 255
EndFunction

nwsFollowerControllerScript Function Ctl() Global
    If !NFFPresent()
        Return None
    EndIf
    Return Game.GetFormFromFile(0x0000434F, "nwsFollowerFramework.esp") as nwsFollowerControllerScript
EndFunction

Bool Function Seated(Actor a) Global
    If a == None || !NFFPresent()
        Return False
    EndIf
    Quest df = Game.GetFormFromFile(0x000750BA, "Skyrim.esm") as Quest
    If df == None
        Return False
    EndIf
    Int i = 0
    While i <= 11
        If i != 1
            ReferenceAlias ra = df.GetAlias(i) as ReferenceAlias
            If ra != None && ra.GetActorReference() == a
                Return True
            EndIf
        EndIf
        i += 1
    EndWhile
    Return False
EndFunction

Actor[] Function SeatedActors() Global
    Actor[] out = new Actor[11]
    If !NFFPresent()
        Return out
    EndIf
    Quest df = Game.GetFormFromFile(0x000750BA, "Skyrim.esm") as Quest
    Int n = 0
    Int i = 0
    While df != None && i <= 11
        If i != 1
            ReferenceAlias ra = df.GetAlias(i) as ReferenceAlias
            If ra != None
                out[n] = ra.GetActorReference()
            EndIf
            n += 1
        EndIf
        i += 1
    EndWhile
    Return out
EndFunction

Function Wait(Actor a) Global
    nwsFollowerControllerScript c = Ctl()
    If c != None && a != None
        c.FollowerWaitHere(a, 0, 0)
    EndIf
EndFunction

Function Follow(Actor a) Global
    nwsFollowerControllerScript c = Ctl()
    If c != None && a != None
        c.FollowerFollowMe(a, 0)
    EndIf
EndFunction

Bool Function AllowWarp() Global
    GlobalVariable g = None
    If NFFPresent()
        g = Game.GetFormFromFile(0x0001BDFF, "nwsFollowerFramework.esp") as GlobalVariable
    EndIf
    If g == None
        Return True                 ; plugin default 1
    EndIf
    Return g.GetValueInt() == 1
EndFunction

Float Function WarpRange() Global
    GlobalVariable g = None
    If NFFPresent()
        g = Game.GetFormFromFile(0x00068AE0, "nwsFollowerFramework.esp") as GlobalVariable
    EndIf
    If g == None
        Return 2560.0               ; plugin default
    EndIf
    Return g.GetValue()
EndFunction

Bool Function Sparring(Actor a) Global
    nwsFollowerControllerScript c = Ctl()
    If c == None || c.nwsFF_SparFac == None
        Return False
    EndIf
    Return a.GetFactionRank(c.nwsFF_SparFac) >= 0
EndFunction

; ---- REVIEW_LOG R32: NFF's dismissal signal (nwsFollowerControllerScript.RemoveAction :560-568 sets these BEFORE WFP=0)

Faction Function DismissedFac() Global
    {NFF's own DismissedFac (controller.varScript.DismissedFac). Fallback: vanilla DismissedFollowerFaction 0x05C84C.
     0x05C84C is what nwsFollowerFramework.esp's VMAD stores for nwsFollowerVariableScript.DismissedFac (QUST 0x23CBC0,
     master Skyrim.esm; read with build/tools/espio.py, REVIEW_LOG RV-66).}
    nwsFollowerControllerScript c = Ctl()
    If c != None
        nwsFollowerVariableScript v = c.varScript
        If v != None && v.DismissedFac != None
            Return v.DismissedFac
        EndIf
    EndIf
    Return Game.GetFormFromFile(0x0005C84C, "Skyrim.esm") as Faction
EndFunction

Int Function DismissedFacSource() Global
    {Which form DismissedFac() resolves to: 1 = NFF's varScript property, 2 = the 0x05C84C fallback, 0 = none.
     Logged once per load by IEB_Main.Setup (a 2 is a WARN).}
    nwsFollowerControllerScript c = Ctl()
    If c != None
        nwsFollowerVariableScript v = c.varScript
        If v != None && v.DismissedFac != None
            Return 1
        EndIf
    EndIf
    If (Game.GetFormFromFile(0x0005C84C, "Skyrim.esm") as Faction) != None
        Return 2
    EndIf
    Return 0
EndFunction

Bool Function InDismissedFac(Actor a) Global
    Faction f = DismissedFac()
    Return a != None && f != None && a.IsInFaction(f)
EndFunction

Bool Function IsAnimal(Actor a) Global
    {NFF's own animal test (RemoveAction :560): ActorTypeAnimal or ActorTypeDwarven. Animals get Variable04=0 on
     dismissal instead of DismissedFac.}
    nwsFollowerControllerScript c = Ctl()
    If a == None || c == None
        Return False
    EndIf
    nwsFollowerVariableScript v = c.varScript
    If v == None
        Return False
    EndIf
    Return (v.ActorTypeAnimal != None && a.HasKeyword(v.ActorTypeAnimal)) || (v.ActorTypeDwarven != None && a.HasKeyword(v.ActorTypeDwarven))
EndFunction

; ---- Essential followers (essential_followers_design.md §1.1, §7.3, §7.4). Factions on controller.varScript
; (nwsFollowerVariableScript.psc:148, :157, :158); the toggle is nwsFollowerControllerScript.psc:1991 ->
; nwsFollowerControllerExScript.psc:461-485.

Faction Function EssFac() Global
    nwsFollowerControllerScript c = Ctl()
    If c == None || c.varScript == None
        Return None
    EndIf
    Return c.varScript.nwsFF_EssFac
EndFunction

Bool Function InEssFac(Actor a) Global
    Faction f = EssFac()
    Return a != None && f != None && a.IsInFaction(f)
EndFunction

Bool Function EssentialOn(Actor a) Global
    {NFF's own toggle, ON direction only. It is a toggle (ExScript :552-563 turns it OFF for a member), so it is called
     only when the actor is NOT in nwsFF_EssFac and the base is NOT essential. Returns False when nothing was called.}
    nwsFollowerControllerScript c = Ctl()
    If a == None || c == None || EssFac() == None || InEssFac(a) || a.GetActorBase().IsEssential()
        Return False
    EndIf
    c.ToggleEssential(a, 0)
    Return True
EndFunction

Bool Function IsImport(Actor a) Global
    nwsFollowerControllerScript c = Ctl()
    Return a != None && c != None && c.varScript != None && c.varScript.nwsFF_ImportFac != None && a.IsInFaction(c.varScript.nwsFF_ImportFac)
EndFunction

Bool Function ImportSetDone(Actor a) Global
    {nwsFF_ImportSetFac: added at the start of SetImportLight (ExScript :584).}
    nwsFollowerControllerScript c = Ctl()
    Return a != None && c != None && c.varScript != None && c.varScript.nwsFF_ImportSetFac != None && a.IsInFaction(c.varScript.nwsFF_ImportSetFac)
EndFunction
