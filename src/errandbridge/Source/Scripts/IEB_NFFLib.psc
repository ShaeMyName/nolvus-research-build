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
