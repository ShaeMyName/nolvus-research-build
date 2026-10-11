Scriptname IEB_IELib Hidden
{Errand Bridge: every IntelEngine access lives here. Global library, never attached. Facts: investigation/round10/
 step3_api_facts.md §C (quest 0xD61; slot n = alias ID n+1; DashboardCancelTask numArg = slot, no linger block).}

Quest Function IEQuest() Global
    Return Game.GetFormFromFile(0x000D61, "IntelEngine.esp") as Quest
EndFunction

ReferenceAlias[] Function AgentAliases() Global
    ReferenceAlias[] arr = new ReferenceAlias[5]
    Quest q = IEQuest()
    If q != None
        Int i = 0
        While i < 5
            arr[i] = q.GetAlias(i + 1) as ReferenceAlias        ; AgentAlias0i is alias ID i+1
            i += 1
        EndWhile
    EndIf
    Return arr
EndFunction

Int Function SlotCountOf(Actor a, ReferenceAlias[] aliases) Global
    Int n = 0
    Int i = 0
    While i < aliases.Length
        If aliases[i] != None && aliases[i].GetActorReference() == a
            n += 1
        EndIf
        i += 1
    EndWhile
    Return n
EndFunction

Int Function SlotOf(Actor a) Global
    {Slot index 0..4 of the first agent alias holding a, or -1.}
    ReferenceAlias[] aliases = AgentAliases()
    Int i = 0
    While i < aliases.Length
        If aliases[i] != None && aliases[i].GetActorReference() == a
            Return i
        EndIf
        i += 1
    EndWhile
    Return -1
EndFunction

Function CopyTask(Actor a) Global
    {Task copies that survive ClearSlot (spec §4.1). Copies only; no bridge decision reads them (REVIEW_LOG R54:
     decisions use DecisionTaskType). Skipped while the slot is torn down, so a teardown blank never overwrites them.}
    String t = StorageUtil.GetStringValue(a, "Intel_TaskType", "")
    If t == ""
        Return
    EndIf
    StorageUtil.SetStringValue(a, "IEB_TaskType", t)
    StorageUtil.SetStringValue(a, "IEB_TaskTarget", StorageUtil.GetStringValue(a, "Intel_Target", ""))
    If IsStoryType(t)
        StorageUtil.SetIntValue(a, "IEB_Origin", 2)
    Else
        StorageUtil.SetIntValue(a, "IEB_Origin", 1)
    EndIf
EndFunction

Bool Function IsStoryTask(Actor a) Global
    {Kept for the harness watcher (IEB_Watcher). Bridge decisions use DecisionTaskType + IsStoryType.}
    String t = StorageUtil.GetStringValue(a, "Intel_TaskType", "")
    Return t == "story" || t == "npc_social"
EndFunction

Bool Function IsStoryType(String t) Global
    Return t == "story" || t == "npc_social"
EndFunction

String Function DecisionTaskType(Actor a) Global
    {REVIEW_LOG R54: the task type read from IntelEngine's own slot state at decision time (Core.SlotTaskTypes[slot]).
     "" = no slot, or the slot is being torn down: Core.ClearSlot unsets Intel_TaskType early but clears the agent
     alias and SlotTaskTypes last, and MarkSlotProcessing (SlotStates = 0) precedes ClearSlot. No decision on "".
     SlotStates 0 is only the teardown/empty value (REVIEW_LOG RV-66): IntelEngine_Core.psc:158 enumerates the states
     (0 = empty/processing, 1 traveling, 2 at_destination, 3 returning, 5 search_wait, 8 at_target); AllocateSlot
     writes 1 (:689); the only other writers of a state are SetSlotState callers, which pass 1, 2, 3, 5 or
     STATE_AT_TARGET (NPCTasks:1374/:1482/:1532/:1909/:2241/:2351/:2368, Travel:638); 0 is written only by ClearSlot
     (:869) and MarkSlotProcessing (:1013). So no live task phase has SlotStates 0.}
    Int slot = SlotOf(a)
    If slot < 0
        Return ""
    EndIf
    String t = StorageUtil.GetStringValue(a, "Intel_TaskType", "")
    If t == ""
        Return ""
    EndIf
    IntelEngine_Core core = IEQuest() as IntelEngine_Core
    If core == None
        Return t
    EndIf
    Int[] states = core.SlotStates
    String[] types = core.SlotTaskTypes
    ; REVIEW_LOG RV-72 (a): `arr == None` fails in the VM ("Cannot cast from None to Int[]"); If !arr is the safe test
    If !states || !types
        Return t
    EndIf
    If slot >= states.Length || slot >= types.Length
        Return t
    EndIf
    If states[slot] == 0
        Return ""
    EndIf
    Return types[slot]
EndFunction

Function MarkRefused(Actor a, String asType, String asWhy) Global
    {REVIEW_LOG R54 backstop: actor + IE task type + time (game real time). Never cleared by ClearKeys or by a
     re-allocation; expires after 30 s (RecentRefusal). IEB_RefusePending = this allocation already refused.}
    StorageUtil.SetStringValue(a, "IEB_RefusedType", asType)
    StorageUtil.SetStringValue(a, "IEB_RefusedWhy", asWhy)
    StorageUtil.SetFloatValue(a, "IEB_RefusedAt", Utility.GetCurrentRealTime())
    MarkPending(a)
EndFunction

Function MarkPending(Actor a) Global
    {This allocation is refused and its cancel is in flight. A backstop refusal calls this alone: the 30 s window
     runs from the first refusal and is never extended by retries.}
    StorageUtil.SetIntValue(a, "IEB_RefusePending", 1)
    StorageUtil.SetFloatValue(a, "IEB_RefusePendingAt", Utility.GetCurrentRealTime())
EndFunction

String Function RecentRefusal(Actor a, String asType) Global
    {The refusal reason if this actor was refused for this IE task type within the last 30 s, else "".}
    If asType == "" || StorageUtil.GetStringValue(a, "IEB_RefusedType", "") != asType
        Return ""
    EndIf
    Float age = Utility.GetCurrentRealTime() - StorageUtil.GetFloatValue(a, "IEB_RefusedAt", -1000.0)
    If age < 0.0 || age > 30.0                      ; < 0: stamped in an earlier game session
        Return ""
    EndIf
    String why = StorageUtil.GetStringValue(a, "IEB_RefusedWhy", "")
    If why == ""
        why = "refused"
    EndIf
    Return why
EndFunction

Bool Function RefusePending(Actor a) Global
    {True while the allocation just refused is still being cancelled (set by MarkRefused, cleared by the next
     IntelEngine_TaskStarted for the actor; honoured for 5 s at most so a lost event can't block a later task).}
    If StorageUtil.GetIntValue(a, "IEB_RefusePending", 0) != 1
        Return False
    EndIf
    Float age = Utility.GetCurrentRealTime() - StorageUtil.GetFloatValue(a, "IEB_RefusePendingAt", -1000.0)
    If age < 0.0 || age > 5.0
        StorageUtil.UnsetIntValue(a, "IEB_RefusePending")
        Return False
    EndIf
    Return True
EndFunction

Function CancelSlotOf(Actor a) Global
    {IntelEngine's own dashboard cancel: ClearSlotRestoreFollower, no player-nearby block (Core:1975-1985).}
    Int slot = SlotOf(a)
    Quest q = IEQuest()
    If slot >= 0 && q != None
        q.SendModEvent("IntelEngine_DashboardCancelTask", "", slot as Float)
    EndIf
EndFunction

Function PassThroughCancel(Actor a) Global
    {Not held: IntelEngine's own CancelCurrentTask semantics, including the 800 u linger rule.}
    IntelEngine_Core core = IEQuest() as IntelEngine_Core
    If core != None
        core.CancelCurrentTask(a)
    EndIf
EndFunction

Function SaveAndSetSkipFollower() Global
    {§9.1 off switch: save IntelEngine's 8 SkipFollower* values, then set all to true.}
    IntelEngine_StoryEngine se = IEQuest() as IntelEngine_StoryEngine
    If se == None
        Return
    EndIf
    StorageUtil.SetIntValue(None, "IEB_PrevSkip_GoToLocation", se.SkipFollowerGoToLocation as Int)
    StorageUtil.SetIntValue(None, "IEB_PrevSkip_DeliverMessage", se.SkipFollowerDeliverMessage as Int)
    StorageUtil.SetIntValue(None, "IEB_PrevSkip_FetchPerson", se.SkipFollowerFetchPerson as Int)
    StorageUtil.SetIntValue(None, "IEB_PrevSkip_EscortTarget", se.SkipFollowerEscortTarget as Int)
    StorageUtil.SetIntValue(None, "IEB_PrevSkip_SearchForActor", se.SkipFollowerSearchForActor as Int)
    StorageUtil.SetIntValue(None, "IEB_PrevSkip_ScheduleFetch", se.SkipFollowerScheduleFetch as Int)
    StorageUtil.SetIntValue(None, "IEB_PrevSkip_ScheduleDelivery", se.SkipFollowerScheduleDelivery as Int)
    StorageUtil.SetIntValue(None, "IEB_PrevSkip_ScheduleMeeting", se.SkipFollowerScheduleMeeting as Int)
    se.SkipFollowerGoToLocation = True
    se.SkipFollowerDeliverMessage = True
    se.SkipFollowerFetchPerson = True
    se.SkipFollowerEscortTarget = True
    se.SkipFollowerSearchForActor = True
    se.SkipFollowerScheduleFetch = True
    se.SkipFollowerScheduleDelivery = True
    se.SkipFollowerScheduleMeeting = True
EndFunction

Function RestoreSkipFollower() Global
    {§9.1 0 -> 1: restore the saved values (default false). Only after a disable saved them.}
    IntelEngine_StoryEngine se = IEQuest() as IntelEngine_StoryEngine
    If se == None || !StorageUtil.HasIntValue(None, "IEB_PrevSkip_GoToLocation")
        Return
    EndIf
    se.SkipFollowerGoToLocation = StorageUtil.GetIntValue(None, "IEB_PrevSkip_GoToLocation", 0) == 1
    se.SkipFollowerDeliverMessage = StorageUtil.GetIntValue(None, "IEB_PrevSkip_DeliverMessage", 0) == 1
    se.SkipFollowerFetchPerson = StorageUtil.GetIntValue(None, "IEB_PrevSkip_FetchPerson", 0) == 1
    se.SkipFollowerEscortTarget = StorageUtil.GetIntValue(None, "IEB_PrevSkip_EscortTarget", 0) == 1
    se.SkipFollowerSearchForActor = StorageUtil.GetIntValue(None, "IEB_PrevSkip_SearchForActor", 0) == 1
    se.SkipFollowerScheduleFetch = StorageUtil.GetIntValue(None, "IEB_PrevSkip_ScheduleFetch", 0) == 1
    se.SkipFollowerScheduleDelivery = StorageUtil.GetIntValue(None, "IEB_PrevSkip_ScheduleDelivery", 0) == 1
    se.SkipFollowerScheduleMeeting = StorageUtil.GetIntValue(None, "IEB_PrevSkip_ScheduleMeeting", 0) == 1
    StorageUtil.UnsetIntValue(None, "IEB_PrevSkip_GoToLocation")
EndFunction
