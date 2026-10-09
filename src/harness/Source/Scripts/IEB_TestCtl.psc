Scriptname IEB_TestCtl extends Quest
{Errand Bridge test harness: the controller (spec §15.2, §15.3.1; v1 §5.3). TEST PROFILE ONLY. Member functions on
 IEB_TestQuest, callable over HTTP POST /debug?api=execute-quest-function or MCP execute_quest_function. Actors are
 passed as FormIDs (Int). Results go to the Papyrus log with the prefix [IEB-TEST].}

Actor Function A(Int aiFormId)
    Actor a = Game.GetForm(aiFormId) as Actor
    If a == None
        Log("no actor for " + PO3_SKSEFunctions.IntToString(aiFormId, True))
    EndIf
    Return a
EndFunction

IEB_Watcher Function Watcher()
    Return (Self as Quest) as IEB_Watcher
EndFunction

; ============================================================================ v1 §5.3

Function Snapshot(Int aiFormId)
    {Records the baseline for §14 (I2, I4).}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    StorageUtil.SetIntValue(a, "EBT_Snap", 1)
    StorageUtil.SetFloatValue(a, "EBT_WFP", a.GetActorValue("WaitingForPlayer"))
    StorageUtil.SetIntValue(a, "EBT_Seat", Watcher().SeatOf(a))
    StorageUtil.SetIntValue(a, "EBT_Ovr", ActorUtil.CountPackageOverride(a))
    StorageUtil.SetIntValue(a, "EBT_PreGate", StorageUtil.GetIntValue(a, "IEB_Gate", 0))
    If IEB_SALib.Present()
        StorageUtil.SetStringValue(a, "EBT_Home", SeverActionsNative.Native_GetHome(a))
        StorageUtil.SetFormValue(a, "EBT_Work", SeverActionsNative.Native_GetWorkLoc(a))
        StorageUtil.SetFormValue(a, "EBT_Play", SeverActionsNative.Native_GetPlayLoc(a))
        StorageUtil.SetIntValue(a, "EBT_HadSched", IEB_SALib.AnySchedAlias(a) as Int)
    EndIf
    StorageUtil.UnsetFloatValue(a, "EBT_ExpectWFP")
    Log("snapshot " + Watcher().Line(a))
EndFunction

Function ExpectWFP(Int aiFormId, Float afWFP)
    {I2: the WFP the player's last explicit wait/follow command (or the §7.1 result) should leave.}
    Actor a = A(aiFormId)
    If a != None
        StorageUtil.SetFloatValue(a, "EBT_ExpectWFP", afWFP)
    EndIf
EndFunction

Function StartTask(Int aiFormId, String asAction, String a1, String a2, String a3)
    {IntelEngine's Director path (IE Core OnDashboardExecuteAction): GoToLocation (destination, speed, waitForPlayer),
     FetchPerson / SearchForActor (targetName, speed), DeliverMessage (targetName, msgContent, meetLocation),
     EscortTarget (targetName, destination, shouldWait).}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    String j = "{\"actionName\":\"" + asAction + "\""
    If asAction == "GoToLocation"
        j += ",\"destination\":\"" + a1 + "\",\"speed\":\"" + Def(a2, "1") + "\",\"waitForPlayer\":\"" + Def(a3, "0") + "\""
    ElseIf asAction == "FetchPerson"
        j += ",\"targetName\":\"" + a1 + "\",\"failReason\":\"" + Def(a2, "none") + "\""
    ElseIf asAction == "SearchForActor"
        j += ",\"targetName\":\"" + a1 + "\",\"speed\":\"" + Def(a2, "1") + "\""
    ElseIf asAction == "DeliverMessage"
        j += ",\"targetName\":\"" + a1 + "\",\"msgContent\":\"" + Def(a2, "Test message.") + "\",\"meetLocation\":\"" + a3 + "\""
    ElseIf asAction == "EscortTarget"
        j += ",\"targetName\":\"" + a1 + "\",\"destination\":\"" + a2 + "\",\"shouldWait\":\"" + Def(a3, "0") + "\""
    EndIf
    j += "}"
    Quest ie = IEB_IELib.IEQuest()
    If ie == None
        Log("IntelEngine quest missing")
        Return
    EndIf
    ie.SendModEvent("IntelEngine_DashboardExecuteAction", j, aiFormId as Float)
    Log("StartTask " + asAction + " " + a.GetDisplayName() + " " + j)
EndFunction

Function Cancel(Int aiFormId)
    Actor a = A(aiFormId)
    If a != None
        IEB_IELib.CancelSlotOf(a)
        Log("Cancel " + a.GetDisplayName())
    EndIf
EndFunction

Function Recall(Int aiFormId, Int aiStay)
    {The CancelCurrentTask route: IEB_Main.CancelOrRecall (stayHere 1 = stay, 0 = come back).}
    Actor a = A(aiFormId)
    IEB_Main m = Game.GetFormFromFile(0x810, "ErrandBridge.esp") as IEB_Main
    If a != None && m != None
        m.CancelOrRecall(a, aiStay)
        Log("Recall " + a.GetDisplayName() + " stay=" + aiStay)
    EndIf
EndFunction

String Function UUIDOf(Int aiFormId)
    {SkyrimNet's entity UUID (uppercase hex) for a loaded actor, for MCP tools such as check_action_eligibility, which
     do not accept FormIDs. Logged as "[IEB-TEST] UUID <formid> <name> = <uuid>"; "" if the actor is not loaded.}
    Actor a = A(aiFormId)
    If a == None
        Return ""
    EndIf
    String u = SkyrimNetApi.GetEntityUUID(a)
    Log("UUID " + PO3_SKSEFunctions.IntToString(aiFormId, True) + " " + a.GetDisplayName() + " = " + u + " child=" + a.IsChild())
    Return u
EndFunction

Function Check(Int aiFormId)
    Actor a = A(aiFormId)
    If a != None
        Log("Check " + a.GetDisplayName() + " -> " + Watcher().CheckInvariants(a))
    EndIf
EndFunction

; ============================================================================ §15.2 additions

Function Lend(Int aiFormId)
    {Manual SA suspend (L tests): IEB_SALib.Suspend, as the bridge's lend does (§6.3), recorded so Restore can undo it.}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    StorageUtil.SetIntValue(a, "EBT_WasLent", 1)
    StorageUtil.SetFloatValue(a, "EBT_LendPrevWFP", a.GetActorValue("WaitingForPlayer"))
    Int kind = IEB_SALib.Suspend(a)
    Log("Lend " + a.GetDisplayName() + " kind=" + kind)
EndFunction

Function Restore(Int aiFormId)
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    IEB_SALib.Restore(a, StorageUtil.GetFloatValue(a, "EBT_LendPrevWFP", 0.0))
    Log("Restore " + a.GetDisplayName())
EndFunction

Function Dispatch(Int aiFormId, String asKind)
    {Exercises patch B without the LLM: "story" -> DispatchToTarget(npc, player, "test", "story");
     anything else -> DispatchNPCSocial(npc, <second follower or player>, "test", "npc_gossip").}
    Actor a = A(aiFormId)
    IntelEngine_StoryEngine se = IEB_IELib.IEQuest() as IntelEngine_StoryEngine
    If a == None || se == None
        Return
    EndIf
    StorageUtil.SetIntValue(a, "EBT_PreGate", StorageUtil.GetIntValue(a, "IEB_Gate", 0))
    If asKind == "story"
        se.DispatchToTarget(a, Game.GetPlayer(), "test", "story")
    Else
        Actor other = Game.GetPlayer()
        Actor[] seats = IEB_NFFLib.SeatedActors()
        Int i = 0
        While i < seats.Length
            If seats[i] != None && seats[i] != a
                other = seats[i]
                i = seats.Length
            EndIf
            i += 1
        EndWhile
        se.DispatchNPCSocial(a, other, "test", "npc_gossip")
    EndIf
    Log("Dispatch " + asKind + " " + a.GetDisplayName())
EndFunction

Function Rejoin(Int aiFormId)
    {Prints the rejoin test's inputs (§7.2): distance, |dZ|, same space, loaded, N = IEB_RejoinWarpFactor x NFF warp range.}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    Actor pl = Game.GetPlayer()
    GlobalVariable f = Game.GetFormFromFile(0x805, "ErrandBridge.esp") as GlobalVariable
    Float n = 0.0
    If f != None
        n = f.GetValue() * IEB_NFFLib.WarpRange()
    EndIf
    Float dz = a.GetPositionZ() - pl.GetPositionZ()
    If dz < 0.0
        dz = -dz
    EndIf
    Log("Rejoin " + a.GetDisplayName() + " loaded=" + a.Is3DLoaded() + " sameSpace=" + Watcher().SameSpace(a, pl) + \
        " dist=" + a.GetDistance(pl) + " dZ=" + dz + " N=" + n + " allowWarp=" + IEB_NFFLib.AllowWarp())
EndFunction

Function QPFill(Int aiFormId)
    {MA-7: force the actor into the synthetic story quest's alias (package DefaultSandboxCurrentLocation256).}
    Actor a = A(aiFormId)
    Quest q = Game.GetFormFromFile(0x820, "ErrandBridgeTest.esp") as Quest
    If a == None || q == None
        Return
    EndIf
    (q.GetAlias(0) as ReferenceAlias).ForceRefTo(a)
    a.EvaluatePackage()
    Log("QPFill " + a.GetDisplayName() + " pkg=" + Watcher().Hex(a.GetCurrentPackage()))
EndFunction

Function QPClear()
    Quest q = Game.GetFormFromFile(0x820, "ErrandBridgeTest.esp") as Quest
    If q == None
        Return
    EndIf
    ReferenceAlias ra = q.GetAlias(0) as ReferenceAlias
    Actor a = ra.GetActorReference()
    ra.Clear()
    If a != None
        a.EvaluatePackage()
        Log("QPClear " + a.GetDisplayName() + " pkg=" + Watcher().Hex(a.GetCurrentPackage()))
    EndIf
EndFunction

Function CFProbe(Int aiFormId)
    {§15.3.1: the registry entry and the live value of its recruited, park and refuse terms.}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    Int cf = IEB_CFData.IndexOf(a)
    If cf < 0
        Log("CFProbe " + a.GetDisplayName() + ": no registry entry")
        Return
    EndIf
    String g = "None"
    GlobalVariable gw = IEB_CFData.GWait(cf)
    If gw != None
        g = gw.GetValue() as String
    EndIf
    Log("CFProbe " + a.GetDisplayName() + " entry=" + cf + " name=" + IEB_CFData.Name(cf) + " recruited=" + IEB_CFData.Recruited(cf, a) + \
        " park=" + IEB_CFData.ParkKind(cf) + " gwait=" + g + " refuse=\"" + IEB_CFData.RefuseReason(cf, a) + "\"" + \
        " testRefuse=" + TestCFRefuse() + " tm=" + a.IsPlayerTeammate() + " wfp=" + a.GetActorValue("WaitingForPlayer") + \
        " nffSeat=" + Watcher().SeatOf(a) + " saRoster=" + IEB_SALib.IsSAFollower(a))
EndFunction

; ============================================================================ timescale (Shae, 2026-10-09)
; Normal tests and the soak run at the timescale recorded at the step 7 first launch, never accelerated. Only timer
; tests whose timer runs on GAME time (B-23, D-4, v1 edge 13) may raise it, and each restores and asserts it at teardown.

Function RecordTimescale()
    {Step 7 first launch: store the current (play) timescale as the reference.}
    Float v = TS().GetValue()
    StorageUtil.SetFloatValue(None, "EBT_PlayTimescale", v)
    Log("TIMESCALE recorded " + v)
EndFunction

Function Accelerate(Float afTimescale)
    {For a game-time timer test only. Refused while the soak probe is on (the soak save is never accelerated).}
    GlobalVariable soak = Game.GetFormFromFile(0x802, "ErrandBridgeTest.esp") as GlobalVariable
    If soak != None && soak.GetValue() >= 1.0
        Log("ASSERT FAIL TIMESCALE: Accelerate refused, soak probe is on")
        Return
    EndIf
    If !StorageUtil.HasFloatValue(None, "EBT_PlayTimescale")
        Log("ASSERT FAIL TIMESCALE: no recorded play timescale (run RecordTimescale first)")
        Return
    EndIf
    TS().SetValue(afTimescale)
    Log("TIMESCALE accelerated to " + afTimescale)
EndFunction

Function RestoreTimescale()
    {Teardown of every accelerated test: restore the recorded value, then assert it.}
    Float want = StorageUtil.GetFloatValue(None, "EBT_PlayTimescale", -1.0)
    If want > 0.0
        TS().SetValue(want)
    EndIf
    AssertTimescale()
EndFunction

Function AssertTimescale()
    Float want = StorageUtil.GetFloatValue(None, "EBT_PlayTimescale", -1.0)
    Float got = TS().GetValue()
    If want > 0.0 && got == want
        Log("ASSERT PASS TIMESCALE " + got)
    Else
        Log("ASSERT FAIL TIMESCALE got " + got + " recorded " + want)
    EndIf
EndFunction

GlobalVariable Function TS()
    Return Game.GetFormFromFile(0x0000003A, "Skyrim.esm") as GlobalVariable
EndFunction

Int Function TestCFRefuse()
    GlobalVariable g = Game.GetFormFromFile(0x800, "ErrandBridgeTest.esp") as GlobalVariable
    If g == None
        Return 0
    EndIf
    Return g.GetValueInt()
EndFunction

String Function Def(String s, String d)
    If s == ""
        Return d
    EndIf
    Return s
EndFunction

Function Log(String asMsg)
    Debug.Trace("[IEB-TEST] " + asMsg)
EndFunction
