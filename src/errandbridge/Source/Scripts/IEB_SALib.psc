Scriptname IEB_SALib Hidden
{Errand Bridge: every SeverActions call lives here, presence-guarded (spec §3.1, §6.3, §7.3). Global library, never
 attached. Facts: step3_api_facts.md §A (FM = SeverActions_FollowerManager on SeverActions.esp 0xD62; schedule and
 guard alias indexes and the jail test are on SeverActionsNativeExt; SeverCamp_MusterAlias default must be -1).}

Bool Function Present() Global
    Return Game.GetModByName("SeverActions.esp") != 255
EndFunction

SeverActions_FollowerManager Function FM() Global
    Return Game.GetFormFromFile(0x000D62, "SeverActions.esp") as SeverActions_FollowerManager
EndFunction

Keyword Function WorkAnchorKW() Global
    Return Game.GetFormFromFile(0x00165675, "SeverActions.esp") as Keyword
EndFunction

Bool Function IsSAFollower(Actor a) Global
    Return Present() && SeverActionsNativeExt.Native_GetIsFollower(a)
EndFunction

Bool Function AnySchedAlias(Actor a) Global
    Return SeverActionsNativeExt.Native_GetSchedAliasIndex(a, 0) >= 0 || SeverActionsNativeExt.Native_GetSchedAliasIndex(a, 1) >= 0 || \
           SeverActionsNativeExt.Native_GetSchedAliasIndex(a, 2) >= 0
EndFunction

Bool Function IsPosted(Actor a) Global
    {§6.3 detection.}
    If !Present() || SeverActionsNativeExt.Native_GetIsFollower(a)
        Return False
    EndIf
    If SeverActionsNative.Native_GetHome(a) != "" || SeverActionsNative.Native_GetWorkLoc(a) != None || SeverActionsNative.Native_GetPlayLoc(a) != None
        Return True
    EndIf
    If AnySchedAlias(a) || SeverActionsNativeExt.Native_GetGuardAliasIndex(a) >= 0
        Return True
    EndIf
    Return SeverActionsNativeExt2.Venture_IsActiveRetainer(a)
EndFunction

Bool Function StewardVisit(Actor a) Global
    If SeverActionsNativeExt2.Steward_HoldNameOf(a) == ""
        Return False
    EndIf
    Keyword kw = WorkAnchorKW()
    Return (kw != None && (a.GetLinkedRef(kw) as Actor) != None) || SeverActionsNativeExt2.Travel_GetPhaseByActor(a) > 0
EndFunction

Bool Function OnDutyEmployee(Actor a) Global
    {Guard-duty retainer or steward (S-2 policy 1).}
    Return SeverActionsNativeExt.Native_GetGuardAliasIndex(a) >= 0 || (SeverActionsNative.Native_GetWorkLoc(a) as Actor) != None || \
           SeverActionsNativeExt2.Steward_HoldNameOf(a) != ""
EndFunction

String Function RefuseReason(Actor a, Int aiOrigin, Int aiPolicy) Global
    {§6.3 refuse checks; "" = lend.}
    If StewardVisit(a)
        Return "steward_visit"
    EndIf
    If StorageUtil.GetIntValue(a, "SeverCamp_MusterAlias", -1) >= 0
        Return "war_band"
    EndIf
    If a.GetActorValue("WaitingForPlayer") == 1.0 && SeverActionsNativeExt.Native_GetSandboxing(a)
        Return "sa_wait"
    EndIf
    If SeverActionsNativeExt2.Sched_HoldYield(a) > 0 || SeverActionsNativeExt2.Travel_GetPhaseByActor(a) > 0 || \
       SeverActionsNativeExt.Native_Jailed_IsJailed(a) || SeverActionsNativeExt2.Native_ArrestSession_IsGuardOnTask(a)
        Return "sa_busy"
    EndIf
    If aiOrigin == 2 && (aiPolicy >= 2 || (aiPolicy >= 1 && OnDutyEmployee(a)))
        Return "on_duty_story"
    EndIf
    Return ""
EndFunction

Int Function Suspend(Actor a) Global
    {§6.3 suspend, in one tick, in this order (R15). Returns the IEB_SA_Kind bitmask.}
    Int kind = 0
    If SeverActionsNative.Native_GetHome(a) != "" || SeverActionsNativeExt.Native_GetSchedAliasIndex(a, 0) >= 0
        kind += 1
    EndIf
    If SeverActionsNativeExt.Native_GetSchedAliasIndex(a, 1) >= 0 || SeverActionsNative.Native_GetWorkLoc(a) != None
        kind += 2
    EndIf
    If SeverActionsNativeExt.Native_GetSchedAliasIndex(a, 2) >= 0 || SeverActionsNative.Native_GetPlayLoc(a) != None
        kind += 4
    EndIf
    If SeverActionsNativeExt.Native_GetGuardAliasIndex(a) >= 0
        kind += 8
    EndIf
    If SeverActionsNative.Native_GetHome(a) != "" && !AnySchedAlias(a)
        kind += 16                   ; homed but not alias-held: track-only assist (INFERRED classification)
    EndIf
    If SeverActionsNativeExt2.Venture_IsActiveRetainer(a)
        kind += 32
    EndIf
    If SeverActionsNativeExt2.Steward_HoldNameOf(a) != ""
        kind += 64
    EndIf
    Bool sleeping = StorageUtil.GetIntValue(a, "SeverActions_HomeSleeping", 0) == 1
    If sleeping
        kind += 128
    EndIf
    a.SetActorValue("WaitingForPlayer", 1.0)                 ; SCHED_HOLD_WAITING from now on (FM:5953-5958)
    SeverActions_FollowerManager fm = FM()
    If fm != None
        fm.EmptySchedAliasesForFollow(a)                     ; aliases, guard alias + 110, V2 assists (FM:6863-6891)
    Else
        a.SendModEvent("SeverActions_SchedYield")            ; fallback (FM:731, 1774-1781)
    EndIf
    If sleeping
        SeverActions_FurnitureLib.Stop(a)
    EndIf
    Return kind
EndFunction

Function Reassert(Actor a) Global
    {§9.2: re-assert the suspension after a load.}
    If a.GetActorValue("WaitingForPlayer") != 1.0
        a.SetActorValue("WaitingForPlayer", 1.0)
    EndIf
    SeverActions_FollowerManager fm = FM()
    If fm != None
        fm.EmptySchedAliasesForFollow(a)
    EndIf
EndFunction

Function Restore(Actor a, Float afPrevWFP) Global
    {§7.3 restore: WFP back (FillSchedAlias re-stamps 2), refill the schedule aliases.}
    If a.GetActorValue("WaitingForPlayer") == 1.0
        If afPrevWFP == -1.0
            a.SetActorValue("WaitingForPlayer", -1.0)
        Else
            a.SetActorValue("WaitingForPlayer", 0.0)
        EndIf
    EndIf
    SeverActions_FollowerManager fm = FM()
    If fm != None
        fm.RefillSchedAliasesAfterStop(a)
    EndIf
EndFunction

String Function AbortReason(Actor a) Global
    {§7.3 abort triggers; "" = keep lending.}
    If a.GetActorValue("WaitingForPlayer") != 1.0 || AnySchedAlias(a)
        Return "sa_retake"
    EndIf
    If StewardVisit(a)
        Return "steward_visit"
    EndIf
    If StorageUtil.GetIntValue(a, "SeverCamp_MusterAlias", -1) >= 0
        Return "war_band"
    EndIf
    If SeverActionsNativeExt.Native_Jailed_IsJailed(a)
        Return "jailed"
    EndIf
    Return ""
EndFunction

Bool Function CatchupEnabled() Global
    Return Present() && SeverActionsNativeExt.Native_IsCellCatchupEnabled()
EndFunction

Function SetCatchup(Bool abOn) Global
    If Present()
        SeverActionsNativeExt.Native_SetCellCatchupEnabled(abOn)
    EndIf
EndFunction
