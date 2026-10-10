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
    {IntelEngine's Director dispatch (IE Core OnDashboardExecuteAction, 3.5.1 :2406-2455): GoToLocation (destination, speed,
     waitForPlayer), FetchPerson / SearchForActor (targetName, speed), DeliverMessage (targetName, msgContent, meetLocation),
     EscortTarget (targetName, destination, shouldWait).
     [CHANGED in build 2026-10-10] IE's own event carries the actor as a Float FormID, exact only up to 0xFFFFFF, so mod, DLC
     and ESL actors could resolve to the wrong form. The task now goes out as our own async mod event carrying the Actor
     itself (OnIEBStartTask below), which makes the same IE calls the Director handler makes.}
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
    If IEB_IELib.IEQuest() == None
        Log("IntelEngine quest missing")
        Return
    EndIf
    RegisterForModEvent("IEB_TestStartTask", "OnIEBStartTask")
    Int h = ModEvent.Create("IEB_TestStartTask")
    If h == 0
        Log("StartTask: ModEvent.Create failed")
        Return
    EndIf
    ModEvent.PushString(h, j)
    ModEvent.PushForm(h, a)
    ModEvent.Send(h)
    Log("StartTask " + asAction + " " + a.GetDisplayName() + " " + j)
EndFunction

Event OnIEBStartTask(String asJson, Form akNpc)
    {Same calls as IE Core OnDashboardExecuteAction (3.5.1 :2406-2455), with the Actor passed exactly.}
    Actor npc = akNpc as Actor
    IntelEngine_Core core = IEB_IELib.IEQuest() as IntelEngine_Core
    If npc == None || npc.IsDead() || core == None
        Log("StartTask: invalid or dead actor, or no IE Core")
        Return
    EndIf
    String act = IntelEngine.StoryResponseGetField(asJson, "actionName")
    If act == "GoToLocation"
        core.Travel.GoToLocation(npc, IntelEngine.StoryResponseGetField(asJson, "destination"), IntelEngine.StoryResponseGetField(asJson, "speed") as Int, IntelEngine.StoryResponseGetField(asJson, "waitForPlayer") as Int, false)
    ElseIf act == "FetchPerson"
        String fr = IntelEngine.StoryResponseGetField(asJson, "failReason")
        If fr == ""
            fr = "none"
        EndIf
        core.NPCTasks.FetchNPC(npc, IntelEngine.StoryResponseGetField(asJson, "targetName"), fr)
    ElseIf act == "SearchForActor"
        core.NPCTasks.SearchForActor(npc, IntelEngine.StoryResponseGetField(asJson, "targetName"), IntelEngine.StoryResponseGetField(asJson, "speed") as Int)
    ElseIf act == "DeliverMessage"
        String ml = IntelEngine.StoryResponseGetField(asJson, "meetLocation")
        If ml == ""
            ml = "none"
        EndIf
        core.NPCTasks.DeliverMessage(npc, IntelEngine.StoryResponseGetField(asJson, "targetName"), IntelEngine.StoryResponseGetField(asJson, "msgContent"), ml, "none")
    ElseIf act == "EscortTarget"
        String dst = IntelEngine.StoryResponseGetField(asJson, "destination")
        If dst == ""
            dst = "home"
        EndIf
        core.NPCTasks.EscortTarget(npc, IntelEngine.StoryResponseGetField(asJson, "targetName"), dst, IntelEngine.StoryResponseGetField(asJson, "shouldWait") as Int)
    Else
        Log("StartTask: unknown action " + act)
        Return
    EndIf
    Log("StartTask dispatched " + act + " " + npc.GetDisplayName() + " " + PO3_SKSEFunctions.IntToString(npc.GetFormID(), True))
EndEvent

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
        Log("UUID " + PO3_SKSEFunctions.IntToString(aiFormId, True) + " none")   ; not loaded: an answer, not silence
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

Function Burst(Int aiFormId, Float afSeconds)
    {Watcher burst mode for B-22 (spec §15.3, §2.1): samples one actor every 0.1 s real time for afSeconds (max 300) and
     writes "BURST <realtime> <pkg> wfp=<WFP> pos=<x>,<y>,<z>" lines to the ErrandBridgeWatch user log, plus BURST START /
     BURST END. Runs on its own thread (mod event), so the MCP call returns at once. The host maps package FormIDs to
     EditorIDs (nwsFollowerWaitBox) and measures intervals from the logged real times; Papyrus may sample slower than
     0.1 s under load, which the real-time stamps show.}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    RegisterForModEvent("IEB_TestBurst", "OnIEBBurst")
    Int h = ModEvent.Create("IEB_TestBurst")
    If h == 0
        Log("Burst: ModEvent.Create failed")
        Return
    EndIf
    ModEvent.PushForm(h, a)
    ModEvent.PushFloat(h, afSeconds)
    ModEvent.Send(h)
    Log("Burst requested " + a.GetDisplayName() + " " + afSeconds + " s")
EndFunction

Event OnIEBBurst(Form akActor, Float afSeconds)
    Actor a = akActor as Actor
    If a == None
        Return
    EndIf
    If afSeconds > 300.0
        afSeconds = 300.0
    EndIf
    IEB_Watcher w = Watcher()
    Float t0 = Utility.GetCurrentRealTime()
    Float stop = t0 + afSeconds
    Int n = 0
    ; NFF wait-box packages (nwsFollowerFramework.esp local IDs, read from the plugin 2026-10-10): the host matches these.
    Form wb = Game.GetFormFromFile(0x025CAD, "nwsFollowerFramework.esp")       ; nwsFollowerWaitBox
    Form wbpt = Game.GetFormFromFile(0x1F2701, "nwsFollowerFramework.esp")     ; nwsFollowerWaitBoxPT
    w.W("BURST START " + a.GetDisplayName() + " " + w.Hex(a) + " t=" + t0 + " waitbox=" + w.Hex(wb) + " waitboxpt=" + w.Hex(wbpt))
    While Utility.GetCurrentRealTime() < stop
        w.W("BURST " + Utility.GetCurrentRealTime() + " " + w.Hex(a.GetCurrentPackage()) + " wfp=" + a.GetActorValue("WaitingForPlayer") + " pos=" + a.GetPositionX() + "," + a.GetPositionY() + "," + a.GetPositionZ())
        n += 1
        Utility.WaitMenuMode(0.1)
    EndWhile
    w.W("BURST END " + a.GetDisplayName() + " samples=" + n + " t=" + Utility.GetCurrentRealTime())
EndEvent

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

; ============================================================================ step-8 U1 wrappers (2026-10-10)
; Drafted by three helper agents against verified sources (their file:line notes are in the docstrings), merged
; and reviewed by Claude. Test profile only.

; --- B family
; ============================================================================ step-8 U1 family B wrappers (tests_b.py)


Function NFFWait(Int aiFormId)
    {NFF "wait here", the bridge's own sync call (IEB_NFFLib.Wait -> FollowerWaitHere(a, 0, 0)).}
    Actor a = A(aiFormId)
    If a != None
        IEB_NFFLib.Wait(a)
        Log("NFFWait " + a.GetDisplayName() + " wfp=" + a.GetActorValue("WaitingForPlayer"))
    EndIf
EndFunction

Function NFFFollow(Int aiFormId)
    {NFF "follow me", the bridge's own sync call (IEB_NFFLib.Follow -> FollowerFollowMe(a, 0)).}
    Actor a = A(aiFormId)
    If a != None
        IEB_NFFLib.Follow(a)
        Log("NFFFollow " + a.GetDisplayName() + " wfp=" + a.GetActorValue("WaitingForPlayer"))
    EndIf
EndFunction

Function NFFDismiss(Int aiFormId)
    {B-6: NFF's own dismissal. RemoveFollower(a, 0, 0) routes import / guard / plain followers like NFF's follower menu
     (nwsFollowerControllerScript.psc:430-446; menu: nwsFollowerUILIBScript.psc:235-241 -> RemoveAction(a, 0, 1)).}
    Actor a = A(aiFormId)
    nwsFollowerControllerScript c = IEB_NFFLib.Ctl()
    If a == None || c == None
        Log("NFFDismiss: no actor or no NFF controller")
        Return
    EndIf
    c.RemoveFollower(a, 0, 0)
    Log("NFFDismiss " + a.GetDisplayName() + " seated=" + IEB_NFFLib.Seated(a))
EndFunction

Function MoveRel(Int aiFormId, Int aiTargetFormId, Float afDX, Float afDY, Float afDZ)
    {B-21: aiFormId.MoveTo(aiTargetFormId, dx, dy, dz) - the spec's "F1.moveto player 3000 0 0". 0x14 = the player.}
    ObjectReference r = Game.GetForm(aiFormId) as ObjectReference
    ObjectReference t = Game.GetForm(aiTargetFormId) as ObjectReference
    If r == None || t == None
        Log("MoveRel: missing ref")
        Return
    EndIf
    r.MoveTo(t, afDX, afDY, afDZ, False)
    Log("MoveRel " + Watcher().Hex(r) + " pos=" + (r.GetPositionX() as Int) + "," + (r.GetPositionY() as Int) + "," + (r.GetPositionZ() as Int))
EndFunction

Function StepPlayer(Int aiFormId, Float afStep)
    {B-24: one stepped "walk" of the player along the actor-player line (afStep > 0 away, < 0 toward; never past the
     actor). Z eases toward the actor's Z when approaching, +64 so the player drops onto the ground. Stepping is not
     walking (INFERRED equivalent for the bridge's distance tests).}
    Actor a = A(aiFormId)
    Actor pl = Game.GetPlayer()
    If a == None
        Return
    EndIf
    Float dx = pl.GetPositionX() - a.GetPositionX()
    Float dy = pl.GetPositionY() - a.GetPositionY()
    Float d = Math.sqrt(dx * dx + dy * dy)
    If d < 1.0
        dx = Math.sin(pl.GetAngleZ())
        dy = Math.cos(pl.GetAngleZ())
        d = 1.0
    EndIf
    Float k = afStep / d
    If k < -1.0 + 128.0 / d
        k = -1.0 + 128.0 / d
    EndIf
    Float dz = 64.0
    If k < 0.0
        dz += (a.GetPositionZ() - pl.GetPositionZ()) * (0.0 - k)
    EndIf
    pl.MoveTo(pl, dx * k, dy * k, dz, False)
    Utility.Wait(0.5)
    Float z = a.GetPositionZ() - pl.GetPositionZ()
    If z < 0.0
        z = -z
    EndIf
    Log("StepPlayer " + a.GetDisplayName() + " dist=" + a.GetDistance(pl) + " dZ=" + z + " sameSpace=" + Watcher().SameSpace(a, pl) + " loaded=" + a.Is3DLoaded())
EndFunction

Function FastTravelTo(Int aiRefFormId)
    {B-16: Game.FastTravel (sdk/skse/Game.psc:42) to a map marker, e.g. WhiterunStablesMapMarker 0x72879.}
    ObjectReference dest = Game.GetForm(aiRefFormId) as ObjectReference
    If dest == None
        Log("FastTravelTo: no ref")
        Return
    EndIf
    Log("FastTravelTo " + Watcher().Hex(dest))
    Game.FastTravel(dest)
EndFunction

Function Narrate(Int aiFormId)
    {B-27/B-28: make the actor speak to the player. Empty content = a short-lived event with an immediate response,
     nothing persisted (SkyrimNetApi.psc:196-208, b25).}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    Int rc = SkyrimNetApi.DirectNarration("", a, Game.GetPlayer())
    Log("Narrate " + a.GetDisplayName() + " rc=" + rc)
EndFunction

Function SitNearest(Int aiFormId, Float afRadius)
    {B-31: SA's AI action SitOrLayDown through SkyrimNet (ExecuteAction runs it irrespective of cooldowns or
     eligibility, SkyrimNetApi.psc:54-55) on the nearest chair, bench or stool with a free place for the actor
     (SeverActionsNativeExt2.Furniture_SeatFor, SeverActionsNativeExt2.psc:1263). FURN form type 40 (INFERRED from the
     SE FormType order). The argument goes under the YAML name and the Papyrus parameter name (mapping INFERRED).}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    ObjectReference[] refs = PO3_SKSEFunctions.FindAllReferencesOfFormType(a, 40, afRadius)
    ObjectReference best = None
    Float bestD = 1000000.0
    Int i = 0
    While i < refs.Length
        ObjectReference f = refs[i]
        If f != None && !f.IsDisabled()
            String n = f.GetBaseObject().GetName()
            If StringUtil.Find(n, "Chair") >= 0 || StringUtil.Find(n, "Bench") >= 0 || StringUtil.Find(n, "Stool") >= 0
                If SeverActionsNativeExt2.Furniture_SeatFor(a, f, 0.0) != None && a.GetDistance(f) < bestD
                    best = f
                    bestD = a.GetDistance(f)
                EndIf
            EndIf
        EndIf
        i += 1
    EndWhile
    If best == None
        Log("SitNearest " + a.GetDisplayName() + " furn=None dist=0 rc=-1")
        Return
    EndIf
    StorageUtil.SetFormValue(a, "EBT_Furn", best)
    String id = PO3_SKSEFunctions.IntToString(best.GetFormID(), True)
    Int rc = SkyrimNetApi.ExecuteAction("SitOrLayDown", a, "{\"furniture\":\"" + id + "\",\"furnitureFormId\":\"" + id + "\"}")
    Log("SitNearest " + a.GetDisplayName() + " furn=" + id + " dist=" + bestD + " rc=" + rc)
EndFunction

Function FurnState(Int aiFormId)
    {B-31: sit state (0 none, 2 wants to sit, 3 sitting, 4 wants to stand: sdk/skse/Actor.psc:285-291), SA's
     FurnitureLib.IsUsing (SeverActions_FurnitureLib.psc:129), distance to the SitNearest furniture.}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    ObjectReference f = StorageUtil.GetFormValue(a, "EBT_Furn") as ObjectReference
    String d = "NA"
    If f != None && a.GetParentCell() == f.GetParentCell()
        d = (a.GetDistance(f) as Int) as String
    EndIf
    Log("FurnState " + a.GetDisplayName() + " sit=" + a.GetSitState() + " using=" + SeverActions_FurnitureLib.IsUsing(a) + " furn=" + Watcher().Hex(f) + " dFurn=" + d + " pkg=" + Watcher().Hex(a.GetCurrentPackage()))
EndFunction

Function SkipProbe()
    {B-14: IntelEngine's 8 SkipFollower* values (the ones IEB_IELib.SaveAndSetSkipFollower sets).}
    IntelEngine_StoryEngine se = IEB_IELib.IEQuest() as IntelEngine_StoryEngine
    If se == None
        Log("SkipProbe: no StoryEngine")
        Return
    EndIf
    Log("SkipProbe goto=" + (se.SkipFollowerGoToLocation as Int) + " deliver=" + (se.SkipFollowerDeliverMessage as Int) + \
        " fetch=" + (se.SkipFollowerFetchPerson as Int) + " escort=" + (se.SkipFollowerEscortTarget as Int) + \
        " search=" + (se.SkipFollowerSearchForActor as Int) + " sfetch=" + (se.SkipFollowerScheduleFetch as Int) + \
        " sdeliver=" + (se.SkipFollowerScheduleDelivery as Int) + " smeet=" + (se.SkipFollowerScheduleMeeting as Int) + \
        " saved=" + StorageUtil.HasIntValue(None, "IEB_PrevSkip_GoToLocation"))
EndFunction

Function ScheduleMeeting(Int aiFormId, String asDest, String asWhen)
    {B-15: IntelEngine_Schedule.ScheduleMeeting(npc, destination, timeCondition) (Gerk Schedule.psc:121).}
    Actor a = A(aiFormId)
    IntelEngine_Core core = IEB_IELib.IEQuest() as IntelEngine_Core
    If a == None || core == None || core.Schedule == None
        Log("ScheduleMeeting: no actor or no IE Schedule")
        Return
    EndIf
    Bool ok = core.Schedule.ScheduleMeeting(a, asDest, asWhen)
    Log("ScheduleMeeting " + a.GetDisplayName() + " dest=" + asDest + " when=" + asWhen + " ok=" + ok)
EndFunction

Function SetIEWaitHours(Float afHours)
    {B-13: IntelEngine's default wait hours = its MCM value, a StorageUtil float on the player
     (Gerk Core.psc:1667-1689). afHours < 0 unsets it (IE default 48). Logs the previous value for the restore.}
    Actor pl = Game.GetPlayer()
    String prev = "none"
    If StorageUtil.HasFloatValue(pl, "Intel_MCM_DefaultWaitHours")
        prev = StorageUtil.GetFloatValue(pl, "Intel_MCM_DefaultWaitHours") as String
    EndIf
    If afHours < 0.0
        StorageUtil.UnsetFloatValue(pl, "Intel_MCM_DefaultWaitHours")
    Else
        StorageUtil.SetFloatValue(pl, "Intel_MCM_DefaultWaitHours", afHours)
    EndIf
    Log("IEWaitHours prev=" + prev + " now=" + afHours)
EndFunction

Function AddTestOverride(Int aiFormId)
    {B-19: a harmless known override, DefaultSandboxCurrentLocation256 (Skyrim.esm 0x0956B8, spec :3408), priority 1.}
    Actor a = A(aiFormId)
    Package p = Game.GetFormFromFile(0x0956B8, "Skyrim.esm") as Package
    If a == None || p == None
        Return
    EndIf
    ActorUtil.AddPackageOverride(a, p, 1, 0)
    a.EvaluatePackage()
    Log("AddTestOverride " + a.GetDisplayName() + " ovr=" + ActorUtil.CountPackageOverride(a))
EndFunction

Function RemoveTestOverride(Int aiFormId)
    Actor a = A(aiFormId)
    Package p = Game.GetFormFromFile(0x0956B8, "Skyrim.esm") as Package
    If a == None || p == None
        Return
    EndIf
    ActorUtil.RemovePackageOverride(a, p)
    a.EvaluatePackage()
    Log("RemoveTestOverride " + a.GetDisplayName() + " ovr=" + ActorUtil.CountPackageOverride(a))
EndFunction

; --- TM / L families
Function DoorUse(Int aiDoorFormId)
    {TM-2/L-2: player uses a load door; 0 = nearest load door within 3000 u. Async.}
    RegisterForModEvent("IEB_TestDoor", "OnIEBDoor")
    Int h = ModEvent.Create("IEB_TestDoor")
    If h == 0
        Log("DoorUse: ModEvent.Create failed")
        Return
    EndIf
    ModEvent.PushInt(h, aiDoorFormId)
    ModEvent.Send(h)
EndFunction

Event OnIEBDoor(Int aiDoorFormId)
    Actor pl = Game.GetPlayer()
    ObjectReference d = None
    If aiDoorFormId != 0
        d = Game.GetForm(aiDoorFormId) as ObjectReference
    Else
        ObjectReference[] refs = PO3_SKSEFunctions.FindAllReferencesOfFormType(pl, 29, 3000.0)
        Float best = 3001.0
        Int i = 0
        While i < refs.Length
            If refs[i] != None && PO3_SKSEFunctions.IsLoadDoor(refs[i]) && pl.GetDistance(refs[i]) < best
                best = pl.GetDistance(refs[i])
                d = refs[i]
            EndIf
            i += 1
        EndWhile
    EndIf
    If d == None
        Log("DoorUse: no door")
        Return
    EndIf
    ObjectReference dest = PO3_SKSEFunctions.GetDoorDestination(d)
    String ds = "None"
    String dc = "None"
    If dest != None
        ds = PO3_SKSEFunctions.IntToString(dest.GetFormID(), True)
        If dest.GetParentCell() != None
            dc = PO3_SKSEFunctions.IntToString(dest.GetParentCell().GetFormID(), True)
        EndIf
    EndIf
    Log("DoorUse " + PO3_SKSEFunctions.IntToString(d.GetFormID(), True) + " dest=" + ds + " destCell=" + dc)
    d.Activate(pl, False)
EndEvent

Function SneakRun(Int aiFormId, Float afSeconds, Int aiSneak)
    {TM-4: optional player sneak; samples player/actor sneak + actor pos every 0.5 s. Async.}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    RegisterForModEvent("IEB_TestSneak", "OnIEBSneak")
    Int h = ModEvent.Create("IEB_TestSneak")
    If h == 0
        Log("SneakRun: ModEvent.Create failed")
        Return
    EndIf
    ModEvent.PushForm(h, a)
    ModEvent.PushFloat(h, afSeconds)
    ModEvent.PushInt(h, aiSneak)
    ModEvent.Send(h)
EndFunction

Event OnIEBSneak(Form akActor, Float afSeconds, Int aiSneak)
    Actor a = akActor as Actor
    Actor pl = Game.GetPlayer()
    If a == None
        Return
    EndIf
    If afSeconds > 60.0
        afSeconds = 60.0
    EndIf
    If aiSneak == 1 && !pl.IsSneaking()
        pl.StartSneaking()
    EndIf
    Log("SNEAK START " + a.GetDisplayName() + " sneak=" + aiSneak)
    Float stop = Utility.GetCurrentRealTime() + afSeconds
    While Utility.GetCurrentRealTime() < stop
        Log("SNEAK rt=" + Utility.GetCurrentRealTime() + " pl=" + (pl.IsSneaking() as Int) + " npc=" + (a.IsSneaking() as Int) + \
            " pos=" + a.GetPositionX() + "," + a.GetPositionY() + "," + a.GetPositionZ() + " loaded=" + (a.Is3DLoaded() as Int))
        Utility.Wait(0.5)
    EndWhile
    If pl.IsSneaking()
        Input.TapKey(Input.GetMappedKey("Sneak"))
    EndIf
    Utility.Wait(0.5)
    Log("SNEAK END " + a.GetDisplayName() + " plSneaking=" + (pl.IsSneaking() as Int))
EndEvent

Function NFFCombatAware(Int aiValue)
    {TM-5: NFF Combat Aware; -1 = read only. MCM toggle only flips this property (nwsFollowerMCMExScript.psc:826-833).}
    nwsFollowerControllerScript c = IEB_NFFLib.Ctl()
    If c == None
        Log("NFFCombatAware: no NFF controller")
        Return
    EndIf
    Int was = c.nwsCombatAware
    If aiValue == 0 || aiValue == 1
        c.nwsCombatAware = aiValue
    EndIf
    Log("NFFCombatAware was=" + was + " now=" + c.nwsCombatAware)
EndFunction

Function SpawnHostile(Int aiBaseFormId)
    Form b = Game.GetForm(aiBaseFormId)
    If b == None
        Log("SpawnHostile: no base form")
        Return
    EndIf
    ObjectReference s = Game.GetPlayer().PlaceAtMe(b, 1, False, False)
    StorageUtil.SetFormValue(None, "EBT_Spawned", s)
    Log("SpawnHostile " + PO3_SKSEFunctions.IntToString(aiBaseFormId, True) + " ref=" + PO3_SKSEFunctions.IntToString(s.GetFormID(), True))
EndFunction

Function Despawn()
    ObjectReference s = StorageUtil.GetFormValue(None, "EBT_Spawned") as ObjectReference
    If s == None
        Log("Despawn none")
        Return
    EndIf
    Actor sa = s as Actor
    If sa != None && !sa.IsDead()
        sa.Kill(None)
    EndIf
    s.Disable(False)
    s.Delete()
    StorageUtil.UnsetFormValue(None, "EBT_Spawned")
    Log("Despawn " + PO3_SKSEFunctions.IntToString(s.GetFormID(), True))
EndFunction

Function SetDropTeammate(Int aiValue)
    {TM-13: global StorageUtil IEB_DropTeammate (patched IntelEngine_Core.psc:1070). -1 = read only.}
    Int was = StorageUtil.GetIntValue(None, "IEB_DropTeammate", 0)
    If aiValue == 0
        StorageUtil.UnsetIntValue(None, "IEB_DropTeammate")
    ElseIf aiValue == 1
        StorageUtil.SetIntValue(None, "IEB_DropTeammate", 1)
    EndIf
    Log("DropTeammate was=" + was + " now=" + StorageUtil.GetIntValue(None, "IEB_DropTeammate", 0))
EndFunction

Function Probe(Int aiFormId)
    {Watcher line for one actor without touching the Snapshot baseline; + IEB keys left, SA sandbox flag.}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    String sb = "NA"
    If IEB_SALib.Present()
        sb = SeverActionsNativeExt.Native_GetSandboxing(a) as String
    EndIf
    Log("probe " + Watcher().Line(a) + " iebKeys=" + Watcher().HasIEBKeys(a) + " saSandbox=" + sb)
EndFunction

Function ExpectLend(Int aiFormId)
    {Bridge lend: let Check run the I4 checks (Watcher.CheckInvariants reads EBT_WasLent, today set only by Lend).}
    Actor a = A(aiFormId)
    If a != None
        StorageUtil.SetIntValue(a, "EBT_WasLent", 1)
        Log("ExpectLend " + a.GetDisplayName())
    EndIf
EndFunction

Function Speak(Int aiFormId, Int aiThought)
    {TM-8: 1 = GenerateNPCThought (any distance, cooldowns apply); 0 = DirectNarration("", actor, player).}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    Int rc = 0
    If aiThought == 1
        rc = SkyrimNetApi.GenerateNPCThought(a, "A quiet moment passes.")
    Else
        rc = SkyrimNetApi.DirectNarration("", a, Game.GetPlayer())
    EndIf
    Log("Speak " + a.GetDisplayName() + " thought=" + aiThought + " rc=" + rc)
EndFunction

Function CampMuster(Int aiChiefFormId, Int aiOn)
    {L-6: SA MusterCamp / SendCampHome (Enterprises.psc:622-652) with the chief resolved by FormID.}
    Actor chief = A(aiChiefFormId)
    SeverActions_Enterprises ent = Game.GetFormFromFile(0x000D62, "SeverActions.esp") as SeverActions_Enterprises
    If chief == None || ent == None
        Log("CampMuster: no chief or no Enterprises script")
        Return
    EndIf
    Int camp = SeverActionsNativeExt2.Camp_CampIdOf(chief)
    If camp == 0
        Log("CampMuster: chief has no camp")
        Return
    EndIf
    Bool ok = SeverActionsNativeExt2.Camp_SetMustered(camp, aiOn == 1)
    If aiOn == 1
        If ok
            ent.MusterCampById(camp)
        EndIf
    Else
        ent.SendCampHomeById(camp)
    EndIf
    Actor[] m = SeverActionsNativeExt2.Camp_GetMembers(camp)
    Log("CampMuster camp=" + camp + " on=" + aiOn + " ok=" + ok + " members=" + m.Length + " roster=" + SeverActionsNativeExt2.Camp_RosterCount(camp))
    Int i = 0
    While i < m.Length
        If m[i] != None
            Log("CampMember " + PO3_SKSEFunctions.IntToString(m[i].GetFormID(), True) + " " + m[i].GetDisplayName() + \
                " loaded=" + m[i].Is3DLoaded() + " muster=" + StorageUtil.GetIntValue(m[i], "SeverCamp_MusterAlias", -1))
        EndIf
        i += 1
    EndWhile
EndFunction

Function KillAndSave(Int aiFormId, String asSave)
    {L-9 / R24: kill and save in one call so the save holds a dead NPC the bridge still lists as lent.}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    a.Kill(None)
    Game.SaveGame(asSave)
    Log("KillAndSave " + a.GetDisplayName() + " dead=" + a.IsDead() + " lent=" + StorageUtil.GetIntValue(a, "IEB_Lent", 0) + " save=" + asSave)
EndFunction

; --- D / Q / REL / CS / RS / K / X
; ============================================================================ step-8 U1 additions (tests_misc.py, 2026-10-10)

String Function QRFields(Actor a)
    {Guard inputs for one actor: the patch-B functions themselves (IntelEngine_StoryEngine IEB_QuestReserved,
     IEB_DispatchBlocked), plus essential/protected/crime faction/slot.}
    IntelEngine_StoryEngine se = IEB_IELib.IEQuest() as IntelEngine_StoryEngine
    ActorBase b = a.GetActorBase()
    String s = "t1=" + (se.IEB_QuestReserved(a, 1) as Int) + " t2=" + (se.IEB_QuestReserved(a, 2) as Int)
    s += " busy=" + (se.IEB_DispatchBlocked(a) as Int) + " scene=" + ((a.GetCurrentScene() != None) as Int)
    s += " tm=" + (a.IsPlayerTeammate() as Int) + " child=" + (a.IsChild() as Int)
    s += " ess=" + (a.IsEssential() as Int) + " baseEss=" + (b.IsEssential() as Int) + " prot=" + (b.IsProtected() as Int)
    s += " crime=" + Watcher().Hex(a.GetCrimeFaction()) + " slot=" + IEB_IELib.SlotOf(a)
    Return s
EndFunction

String Function QClass(Actor a)
    {Counts of a's running, non-exempt alias quests by class, in IEB_QuestReserved's order: story (in story_quests),
     open (displayed incomplete objective), dlgwi (EditorID Dialogue* / WI*), favorbq (Favor* / BQ*), other.
     EditorIDs are classified, never logged.}
    IntelEngine_StoryEngine se = IEB_IELib.IEQuest() as IntelEngine_StoryEngine
    String qf = se.IEB_QIFile()
    Int story = 0
    Int open = 0
    Int dlgwi = 0
    Int favorbq = 0
    Int other = 0
    Int exempt = 0
    Int k = a.GetNumReferenceAliases()
    Int j = 0
    While j < k
        ReferenceAlias ra = a.GetNthReferenceAlias(j)
        Quest q = None
        If ra != None
            q = ra.GetOwningQuest()
        EndIf
        If q != None && (q.IsRunning() || q.IsStarting())
            String ed = PO3_SKSEFunctions.GetFormEditorID(q)
            If se.IEB_ExemptQuest(q)
                exempt += 1
            ElseIf JsonUtil.FormListHas(qf, "story_quests", q)
                story += 1
            ElseIf se.IEB_HasOpenObjective(q)
                open += 1
            ElseIf StringUtil.Find(ed, "Dialogue") == 0 || (StringUtil.Find(ed, "WI") == 0 && StringUtil.AsOrd(StringUtil.Substring(ed, 1, 1)) == 73)
                dlgwi += 1
            ElseIf StringUtil.Find(ed, "Favor") == 0 || StringUtil.Find(ed, "BQ") == 0
                favorbq += 1
            Else
                other += 1
            EndIf
        EndIf
        j += 1
    EndWhile
    Return "story=" + story + " open=" + open + " dlgwi=" + dlgwi + " favorbq=" + favorbq + " other=" + other + " exempt=" + exempt
EndFunction

Function QR(Int aiFormId)
    Actor a = A(aiFormId)
    If a == None || IEB_IELib.IEQuest() == None
        Return
    EndIf
    Log("QR " + Watcher().Hex(a) + " " + QRFields(a) + " " + QClass(a) + " name=" + a.GetDisplayName())
EndFunction

Function QScan(Float afRadius)
    {Q-1 and the Q tests' candidate pick: every loaded NPC within afRadius of the player (max 60).}
    Actor pl = Game.GetPlayer()
    If IEB_IELib.IEQuest() == None
        Log("QSCAN END n=0 (no IntelEngine)")
        Return
    EndIf
    Actor[] near = MiscUtil.ScanCellNPCs(pl, afRadius, None, True)
    Int n = 0
    Int i = 0
    While i < near.Length && n < 60
        Actor a = near[i]
        If a != None && a != pl
            Log("QSCAN " + Watcher().Hex(a) + " " + QRFields(a) + " " + QClass(a) + " name=" + a.GetDisplayName())
            n += 1
        EndIf
        i += 1
    EndWhile
    Log("QSCAN END n=" + n)
EndFunction

Function QAlias(Int aiQuestFormId)
    {Q-2: one quest by numbers only: running, completed, stage, displayed/completed objective indices, and the
     FormID of each reference alias's actor.}
    Quest q = Game.GetForm(aiQuestFormId) as Quest
    If q == None
        Log("QALIAS none")
        Return
    EndIf
    String qh = Watcher().Hex(q)
    Int[] objs = PO3_SKSEFunctions.GetAllQuestObjectives(q)
    String shown = ""
    String done = ""
    Int i = 0
    While i < objs.Length
        If q.IsObjectiveDisplayed(objs[i])
            shown += objs[i] + ","
        EndIf
        If q.IsObjectiveCompleted(objs[i])
            done += objs[i] + ","
        EndIf
        i += 1
    EndWhile
    Int n = q.GetNumAliases()
    Log("QALIAS " + qh + " running=" + (q.IsRunning() as Int) + " completed=" + (q.IsCompleted() as Int) + " stage=" + q.GetCurrentStageID() + " aliases=" + n + " objShown=" + shown + " objDone=" + done)
    i = 0
    While i < n
        ReferenceAlias ra = q.GetNthAlias(i) as ReferenceAlias
        If ra != None
            Log("QALIAS " + qh + " alias=" + i + " actor=" + Watcher().Hex(ra.GetActorReference()))
        EndIf
        i += 1
    EndWhile
EndFunction

Function SUSetInt(Int aiFormId, String asKey, Int aiValue)
    {Test-only StorageUtil int write (CS-22, REL-1, RS-8). Child guard: never makes a child a scene partner or a
     romance participant (refuses those keys on an IsChild actor).}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    If a.IsChild() && (asKey == "IEB_IsScenePartner" || asKey == "IEB_SceneMode" || asKey == "SNRom_Sparked" || asKey == "SNRom_AskPending" || asKey == "SNRom_PlayerStance" || asKey == "SNRom_BankedPoints" || asKey == "SNRom_SeedRomantic")
        Log("SU REFUSED child " + Watcher().Hex(a) + " " + asKey)
        Return
    EndIf
    StorageUtil.SetIntValue(a, asKey, aiValue)
    Log("SU " + Watcher().Hex(a) + " " + asKey + " set=" + aiValue)
EndFunction

Function SUGetInt(Int aiFormId, String asKey, Int aiDefault)
    {R55 (child_lock_failure.md): read a StorageUtil int on the actor Papyrus-side, so the host never trusts a cached
     template render. Logs the value it read.}
    Actor a = A(aiFormId)
    If a == None
        Log("SU none " + asKey + " get=none")
        Return
    EndIf
    Log("SU " + Watcher().Hex(a) + " " + asKey + " get=" + StorageUtil.GetIntValue(a, asKey, aiDefault))
EndFunction

Function SUUnset(Int aiFormId, String asKey)
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    StorageUtil.UnsetIntValue(a, asKey)
    StorageUtil.UnsetFloatValue(a, asKey)
    Log("SU " + Watcher().Hex(a) + " " + asKey + " unset")
EndFunction

Function RankProbe(Int aiFormId)
    {RS tests: vanilla rank to the player, SNRom_Bond tier, track and the stored sync keys (IEB_RankSync.psc:122-176).}
    Actor a = A(aiFormId)
    If a == None
        Return
    EndIf
    Faction bond = IEB_RankSync.BondFaction()
    Int tier = -2
    If bond != None
        tier = a.GetFactionRank(bond)
    EndIf
    Log("RANK " + Watcher().Hex(a) + " r=" + a.GetRelationshipRank(Game.GetPlayer()) + " tier=" + tier + " track=" + StorageUtil.GetIntValue(a, "IEB_RomTrack", -1) + " syncTier=" + StorageUtil.GetIntValue(a, "IEB_RankSyncTier", -1) + " syncRom=" + StorageUtil.GetIntValue(a, "IEB_RankSyncRom", -1) + " hasSync=" + (StorageUtil.HasIntValue(a, "IEB_RankSyncTier") as Int) + " pts=" + SNRom_Bridge.PointsOf(a) + " child=" + (a.IsChild() as Int))
EndFunction

Function SetRank(Int aiFormId, Int aiRank)
    Actor a = A(aiFormId)
    If a != None
        a.SetRelationshipRank(Game.GetPlayer(), aiRank)
        Log("SETRANK " + Watcher().Hex(a) + " r=" + aiRank)
    EndIf
EndFunction

Function RankApply(Int aiFormId)
    {One sync pass for one actor, as IEB_RankSync.SweepStep does it (RefreshTrack, then Apply; IEB_RankSync.psc:209-211).}
    Actor a = A(aiFormId)
    If a != None
        IEB_RankSync.RefreshTrack(a)
        IEB_RankSync.Apply(a)
        Log("RANKAPPLY " + Watcher().Hex(a))
    EndIf
EndFunction

Function SceneOn(Int aiFormId)
    {CS-12: scene mode on with an ADULT partner: the StorageUtil keys IEB_SceneMain.StartScene writes
     (IEB_SceneMain.psc:265-270, 313-317), without the crosshair. Refuses a child (P2).}
    Actor a = A(aiFormId)
    Actor pl = Game.GetPlayer()
    If a == None
        Return
    EndIf
    If a.IsChild()
        Log("SCENE refused child " + Watcher().Hex(a))
        Return
    EndIf
    StorageUtil.FormListClear(pl, "IEB_ScenePartners")
    StorageUtil.SetIntValue(pl, "IEB_SceneMode", 1)
    StorageUtil.FormListAdd(pl, "IEB_ScenePartners", a, False)
    StorageUtil.SetIntValue(a, "IEB_IsScenePartner", 1)
    Log("SCENE on partner=" + Watcher().Hex(a))
EndFunction

Function SceneOff()
    {The keys IEB_SceneMain.EndScene clears (IEB_SceneMain.psc:289-303).}
    Actor pl = Game.GetPlayer()
    Int n = StorageUtil.FormListCount(pl, "IEB_ScenePartners")
    Int i = 0
    While i < n
        Form f = StorageUtil.FormListGet(pl, "IEB_ScenePartners", i)
        If f != None
            StorageUtil.UnsetIntValue(f, "IEB_IsScenePartner")
            StorageUtil.UnsetIntValue(f, "IEB_AwayTicks")
        EndIf
        i += 1
    EndWhile
    StorageUtil.FormListClear(pl, "IEB_ScenePartners")
    StorageUtil.SetIntValue(pl, "IEB_SceneMode", 0)
    StorageUtil.SetIntValue(pl, "IEB_ScenePrivate", 0)
    Log("SCENE off")
EndFunction

Function PlaceRel(Int aiFormId, Int aiRefFormId, Float afDX, Float afDY, Float afDZ)
    {Move an actor to an offset from a reference (X-7 line-of-sight case; also usable for B-21).}
    Actor a = A(aiFormId)
    ObjectReference t = Game.GetForm(aiRefFormId) as ObjectReference
    If a == None || t == None
        Return
    EndIf
    a.MoveTo(t, afDX, afDY, afDZ, False)
    Log("PLACE " + Watcher().Hex(a) + " at " + Watcher().Hex(t) + " d=" + afDX + "," + afDY + "," + afDZ)
EndFunction

Int Function Spawn(Int aiBaseFormId, Float afDist)
    {X-8: place one actor from a base record, then move it afDist units from the player on X.}
    Actor pl = Game.GetPlayer()
    Form b = Game.GetForm(aiBaseFormId)
    If b == None
        Log("SPAWN none")
        Return 0
    EndIf
    ObjectReference r = pl.PlaceAtMe(b, 1, False, False)
    If r == None
        Log("SPAWN none")
        Return 0
    EndIf
    r.MoveTo(pl, afDist, 0.0, 0.0, False)
    Log("SPAWN base=" + Watcher().Hex(b) + " ref=" + Watcher().Hex(r))
    Return r.GetFormID()
EndFunction

Function ConfigProbe()
    {R31: does SkyrimNet's config lookup survive Papyrus case folding? IEB_SceneMain reads GetConfigFloat("game", ...);
     the vanilla Game script puts "Game" in the string pool first, so "game" likely reaches SkyrimNet as "Game". Each read
     uses a distinct sentinel default: a sentinel in the line = the lookup failed. Expected from SkyrimNet.yaml
     (interaction:): maxDistance 1600, normalMaxDistance 1600, whisperMaxDistance 200 (unless whisper mode changed it).}
    Float m = SkyrimNetApi.GetConfigFloat("game", "interaction.maxDistance", -7001.0)
    Float n = SkyrimNetApi.GetConfigFloat("game", "interaction.normalMaxDistance", -7002.0)
    Float w = SkyrimNetApi.GetConfigFloat("game", "interaction.whisperMaxDistance", -7003.0)
    Float x = SkyrimNetApi.GetConfigFloat("SkyrimNet", "interaction.maxDistance", -7004.0)
    Log("CONFIGPROBE max=" + m + " normal=" + n + " whisper=" + w + " skyrimnet=" + x)
EndFunction

Function DespawnRef(Int aiRefFormId)
    ObjectReference r = Game.GetForm(aiRefFormId) as ObjectReference
    If r != None
        r.Disable(False)
        r.Delete()
        Log("DESPAWNREF " + Watcher().Hex(r))   ; not "DESPAWN ": folds to Despawn()'s "Despawn " at runtime
    EndIf
EndFunction

Function CombatProbe(Int aiFormId)
    {B-4 (reviewer 2026-10-10): combat state of one actor: in combat, its combat target, Aggression and Confidence,
     dead, current package. Works for spawned refs (signed Int FormIDs).}
    Actor a = Game.GetForm(aiFormId) as Actor
    If a == None
        Log("CombatProbe none " + PO3_SKSEFunctions.IntToString(aiFormId, True))
        Return
    EndIf
    Actor t = a.GetCombatTarget()
    String tn = "None"
    If t != None
        tn = t.GetDisplayName() + " " + Watcher().Hex(t)
    EndIf
    Log("CombatProbe " + a.GetDisplayName() + " " + Watcher().Hex(a) + " combat=" + (a.IsInCombat() as Int) + " target=" + tn + \
        " aggression=" + a.GetActorValue("Aggression") + " confidence=" + a.GetActorValue("Confidence") + " dead=" + (a.IsDead() as Int) + \
        " dPlayer=" + (a.GetDistance(Game.GetPlayer()) as Int) + " pkg=" + Watcher().Hex(a.GetCurrentPackage()))
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
