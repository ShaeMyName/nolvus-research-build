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
    {Task copies that survive ClearSlot (spec §4.1).}
    String t = StorageUtil.GetStringValue(a, "Intel_TaskType", "")
    StorageUtil.SetStringValue(a, "IEB_TaskType", t)
    StorageUtil.SetStringValue(a, "IEB_TaskTarget", StorageUtil.GetStringValue(a, "Intel_Target", ""))
    If t == "story" || t == "npc_social"
        StorageUtil.SetIntValue(a, "IEB_Origin", 2)
    Else
        StorageUtil.SetIntValue(a, "IEB_Origin", 1)
    EndIf
EndFunction

Bool Function IsStoryTask(Actor a) Global
    String t = StorageUtil.GetStringValue(a, "Intel_TaskType", "")
    Return t == "story" || t == "npc_social"
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
