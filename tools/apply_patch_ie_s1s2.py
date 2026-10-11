"""Post-U1 IntelEngine hunks (post_u1_build_plan §1 timer fix F1/F2, §2 slot race) on build/src/intelengine.
Usage: apply_patch_ie_s1s2.py <group>. Every anchor must match exactly once (CRLF kept). Same edit() as apply_patch_b.py.
Groups: f1 | f2 | core-slot | callers | core-expiry | rv68 | rv68b | rv70 | rv72"""
import sys

D = "C:/nolvus-research/build/src/intelengine/Source/Scripts/"
NL = "\r\n"


def edit(fname, pairs):
    p = D + fname
    s = open(p, "rb").read().decode("utf-8")
    for old, new in pairs:
        o, n = old.replace("\n", NL), new.replace("\n", NL)
        c = s.count(o)
        assert c == 1, "%s: anchor found %d times: %r" % (fname, c, old[:90])
        s = s.replace(o, n)
    open(p, "wb").write(s.encode("utf-8"))


G = sys.argv[1]

if G == "f1":
    edit("IntelEngine_StoryEngine.psc", [(
"""Function StopScheduler()
    UnregisterForUpdate()
    UnregisterForUpdateGameTime()
EndFunction
""",
"""Function StopScheduler()
    ; Patch F1 (ie_timer_collision.md): no UnregisterForUpdate/UnregisterForUpdateGameTime. Both timers belong to
    ; the quest form, so they stopped Travel, NPCTasks, Schedule and Battle too. The Story DM is already gated by
    ; IsStoryEngineEnabled, and DispatchToTarget re-registers 3 s right after this call.
EndFunction
""")])
    edit("IntelEngine_Battle.psc", [
("""; Pending battle polling
Bool Property PendingPollActive = false Auto Hidden
""",
"""; Pending battle polling
Bool Property PendingPollActive = false Auto Hidden

; Patch F1 (ie_timer_collision.md): re-entry guard while HandleBattleEnd runs (script variable, not a property).
; Replaces UnregisterForUpdate(), which cleared the shared timer of every script on the quest.
Bool IEB_Ending = false
"""),
("""Event OnUpdate()
    ; Manifestation cleanup check (micro-encounters from political events)
    If ManifestActive
""",
"""Event OnUpdate()
    ; Patch F1: HandleBattleEnd is running (it re-arms the poll itself when done)
    If IEB_Ending
        return
    EndIf
    ; Manifestation cleanup check (micro-encounters from political events)
    If ManifestActive
"""),
("""    ; Stop polling immediately to prevent race with OnUpdate
    UnregisterForUpdate()
""",
"""    ; Stop polling immediately to prevent race with OnUpdate
    ; Patch F1: guard flag instead of UnregisterForUpdate() (that cleared every script's timer on the quest)
    IEB_Ending = true
"""),
("""    ; Deferred cleanup — soldiers stay until player leaves
    DeferredCleanupActive = true
    DeferredCleanupStart = Utility.GetCurrentRealTime()
    RegisterForSingleUpdate(PollInterval)
EndFunction
""",
"""    ; Deferred cleanup — soldiers stay until player leaves
    DeferredCleanupActive = true
    DeferredCleanupStart = Utility.GetCurrentRealTime()
    IEB_Ending = false
    RegisterForSingleUpdate(PollInterval)
EndFunction
"""),
("""    DeferredCleanupActive = false
    DeferredCleanupStart = 0.0
    UnregisterForUpdate()
    UnregisterForUpdateGameTime()
EndFunction
""",
"""    DeferredCleanupActive = false
    DeferredCleanupStart = 0.0
    ; Patch F1: no UnregisterForUpdate/UnregisterForUpdateGameTime (shared by every script on the quest).
    ; OnUpdate is a no-op with nothing active; OnUpdateGameTime is gated by BattleScheduled (false above).
EndFunction
"""),
("""    Float now = Utility.GetCurrentRealTime()
    If BattleStartRealTime > now
        BattleStartRealTime = now
    EndIf
""",
"""    Float now = Utility.GetCurrentRealTime()
    ; Patch F1: a guard saved mid-HandleBattleEnd must not silence Battle.OnUpdate forever
    IEB_Ending = false
    If BattleStartRealTime > now
        BattleStartRealTime = now
    EndIf
"""),
])

elif G == "f2":
    edit("IntelEngine_StoryEngine.psc", [
("""        RegisterForSingleUpdateGameTime(interval)
        ; Real-time backup: ensures tick fires even at low timescales (timescale 2-6).
        RegisterForSingleUpdate(IDLE_POLL_INTERVAL)
        Core.DebugMsg("Story: StartScheduler — game-time mode (interval=" + interval + "h = min of story=" + storyInterval + " npc=" + npcInterval + " politics=" + politicsInterval + ")")
""",
"""        RegisterForSingleUpdateGameTime(interval)
        ; Real-time backup: ensures tick fires even at low timescales (timescale 2-6).
        ; Patch F2 (ie_timer_collision.md): the real-time timer is shared by every script on the quest, so the idle
        ; 30 s must never lengthen Travel/NPCTasks/Battle's 3 s cadence: ask for 3 s while a slot or battle is active.
        Float poll = IDLE_POLL_INTERVAL
        If IEB_NeedsFastTick()
            poll = MONITOR_INTERVAL
        EndIf
        RegisterForSingleUpdate(poll)
        Core.DebugMsg("Story: StartScheduler — game-time mode (interval=" + interval + "h = min of story=" + storyInterval + " npc=" + npcInterval + " politics=" + politicsInterval + ") poll=" + poll)
"""),
("""Function StopScheduler()
""",
"""Bool Function IEB_NeedsFastTick()
    {Patch F2: True while any IntelEngine task slot is active or Battle has anything to poll.}
    If Core == None
        return false
    EndIf
    Int[] states = Core.SlotStates
    If states != None
        Int i = 0
        While i < states.Length
            If states[i] != 0
                return true
            EndIf
            i += 1
        EndWhile
    EndIf
    IntelEngine_Battle b = Core.Battle
    If b != None
        If b.ManifestActive || b.DeferredCleanupActive || b.PendingPollActive
            return true
        EndIf
    EndIf
    return IntelEngine.IsBattleActive()
EndFunction

Function StopScheduler()
"""),
])

elif G == "core-slot":
    edit("IntelEngine_Core.psc", [
("""; Track if databases are loaded
Bool databaseLoaded = false
""",
"""; Track if databases are loaded
Bool databaseLoaded = false

; Patch (slot race, post_u1_build_plan §2): per-slot reservation stamps in real seconds (Utility.GetCurrentRealTime),
; 0.0 = none. Script variables, not properties (nothing ESP-visible). Cleared in Maintenance on every load; a stamp
; in the future (previous session) or older than IEB_RESERVE_EXPIRY is expired. Expiry = max(120 s, 2x the worst
; measured Find->Allocate gap per caller: 3 s, Papyrus logs 2026-10-10) = 120 s.
Float[] IEB_SlotReservedAt
Float IEB_RESERVE_EXPIRY = 120.0
"""),
("""    If StoryEngine
        StoryEngine.IEB_QISelfCheck()
    EndIf
""",
"""    If StoryEngine
        StoryEngine.IEB_QISelfCheck()
    EndIf
    ; Patch (slot race): no reservation survives a load
    IEB_SlotReservedAt = new Float[5]
"""),
("""    Int activeCount = 0
    Int firstFree = -1
    Int i = 0
    While i < MAX_SLOTS
        If SlotStates[i] != 0
            activeCount += 1
        ElseIf firstFree < 0
            firstFree = i
        EndIf
        i += 1
    EndWhile

    If firstFree >= 0 && activeCount < maxAllowed
        Return firstFree
    EndIf
    Return -1
EndFunction
""",
"""    ; Patch (slot race): non-reserving, but a live reservation counts as taken
    Float now = Utility.GetCurrentRealTime()
    Float[] res = IEB_SlotReservedAt
    Int activeCount = 0
    Int firstFree = -1
    Int i = 0
    While i < MAX_SLOTS
        Bool reserved = false
        If res != None
            Float r = res[i]
            reserved = r > 0.0 && r <= now && (now - r) < IEB_RESERVE_EXPIRY
        EndIf
        If SlotStates[i] != 0 || reserved
            activeCount += 1
        ElseIf firstFree < 0
            firstFree = i
        EndIf
        i += 1
    EndWhile

    If firstFree >= 0 && activeCount < maxAllowed
        Return firstFree
    EndIf
    Return -1
EndFunction

Int Function ReserveFreeAgentSlot()
    {Patch (slot race): FindFreeAgentSlot that also reserves the slot it returns. Max tasks, the array and the clock
    are read BEFORE the loop; the loop, the pick and the stamp make no calls, so no other script thread can run in
    between. Callers must TryAllocateSlot (clears the stamp) or ReleaseSlotReservation on every abort.}
    Int maxAllowed = GetMaxConcurrentTasks()
    If maxAllowed > MAX_SLOTS
        maxAllowed = MAX_SLOTS
    ElseIf maxAllowed < 1
        maxAllowed = 1
    EndIf
    If IEB_SlotReservedAt == None
        IEB_SlotReservedAt = new Float[5]
    EndIf
    Float now = Utility.GetCurrentRealTime()
    Int n = MAX_SLOTS
    Int[] states = SlotStates
    Float[] res = IEB_SlotReservedAt
    Float expiry = IEB_RESERVE_EXPIRY

    ; --- no calls from here to the stamp ---
    Int activeCount = 0
    Int firstFree = -1
    Int i = 0
    While i < n
        Float r = res[i]
        If states[i] != 0 || (r > 0.0 && r <= now && (now - r) < expiry)
            activeCount += 1
        ElseIf firstFree < 0
            firstFree = i
        EndIf
        i += 1
    EndWhile
    If firstFree < 0
        Return -1
    EndIf
    res[firstFree] = now
    ; --- stamped ---
    If activeCount >= maxAllowed
        res[firstFree] = 0.0
        Return -1
    EndIf
    DebugMsg("SLOT_RESERVED slot=" + firstFree)
    Return firstFree
EndFunction

Function ReleaseSlotReservation(Int slot)
    {Patch (slot race): drop this slot's reservation (abort paths between ReserveFreeAgentSlot and TryAllocateSlot).}
    If slot >= 0 && slot < MAX_SLOTS && IEB_SlotReservedAt != None
        IEB_SlotReservedAt[slot] = 0.0
    EndIf
EndFunction

Bool Function TryAllocateSlot(Int slot, Actor akAgent, String taskType, String targetName, Int speed)
    {Patch (slot race): AllocateSlot, but refuses (SLOT_REFUSED) when the slot's agent alias already holds a different
    live actor. Clears the slot's reservation either way. AllocateSlot itself is unchanged.}
    If slot < 0 || slot >= MAX_SLOTS || akAgent == None
        ReleaseSlotReservation(slot)
        DebugMsg("SLOT_REFUSED slot=" + slot + " reason=bad_args type=" + taskType)
        Return false
    EndIf
    Actor holder = None
    ReferenceAlias slotAlias = GetAgentAlias(slot)
    If slotAlias
        holder = slotAlias.GetActorReference()
    EndIf
    If holder != None && holder != akAgent && !holder.IsDead()
        ReleaseSlotReservation(slot)
        DebugMsg("SLOT_REFUSED slot=" + slot + " reason=held holder=" + holder.GetDisplayName() + " holderId=" + holder.GetFormID() + " requester=" + akAgent.GetDisplayName() + " requesterId=" + akAgent.GetFormID() + " type=" + taskType)
        Return false
    EndIf
    AllocateSlot(slot, akAgent, taskType, targetName, speed)
    ReleaseSlotReservation(slot)
    Return true
EndFunction
"""),
])

elif G == "callers":
    edit("IntelEngine_Travel.psc", [
("""    ; Find free slot
    Int slot = Core.FindFreeAgentSlot()
    If slot < 0
        Core.DebugMsg("GoToLocation: No free slots")
""",
"""    ; Find free slot (patch: reserved until TryAllocateSlot or a release)
    Int slot = Core.ReserveFreeAgentSlot()
    If slot < 0
        Core.DebugMsg("GoToLocation: No free slots")
"""),
("""    If destMarker == None
        ; Couldn't resolve - describe the situation factually
        Core.SendTaskNarration(akNPC, akNPC.GetDisplayName() + " was asked to travel to '" + destination + "' but a route could not be determined.")
        Return false
    EndIf
""",
"""    If destMarker == None
        Core.ReleaseSlotReservation(slot)
        ; Couldn't resolve - describe the situation factually
        Core.SendTaskNarration(akNPC, akNPC.GetDisplayName() + " was asked to travel to '" + destination + "' but a route could not be determined.")
        Return false
    EndIf
"""),
("""    ; Allocate slot
    Core.AllocateSlot(slot, akNPC, "travel", destination, speed)
""",
"""    ; Allocate slot (patch: refuses if another live actor holds the alias)
    If !Core.TryAllocateSlot(slot, akNPC, "travel", destination, speed)
        Core.SendTaskNarration(akNPC, akNPC.GetDisplayName() + " cannot take on another task right now.")
        Return false
    EndIf
"""),
])
    nt = "IntelEngine_NPCTasks.psc"
    edit(nt, [
("""    ; Find free slot
    Int slot = Core.FindFreeAgentSlot()
    If slot < 0
        Core.SendTaskNarration(akAgent, akAgent.GetDisplayName() + " cannot take on this task right now.")
        Return false
    EndIf

    ; Anti-trespass: unlock target NPC's home door so agent can enter
    Core.UnlockHomeForTask(akAgent, targetNPC)

    ; Destination is always the target actor directly
    ObjectReference destMarker = targetNPC
""",
"""    ; Find free slot (patch: reserved until TryAllocateSlot)
    Int slot = Core.ReserveFreeAgentSlot()
    If slot < 0
        Core.SendTaskNarration(akAgent, akAgent.GetDisplayName() + " cannot take on this task right now.")
        Return false
    EndIf

    ; Anti-trespass: unlock target NPC's home door so agent can enter
    Core.UnlockHomeForTask(akAgent, targetNPC)

    ; Destination is always the target actor directly
    ObjectReference destMarker = targetNPC
"""),
("""    ; Allocate slot (defaults to state 1)
    Core.AllocateSlot(slot, akAgent, "fetch_npc", targetNPC.GetDisplayName(), 1)  ; Jog by default
""",
"""    ; Allocate slot (defaults to state 1) (patch: refuses if another live actor holds the alias)
    If !Core.TryAllocateSlot(slot, akAgent, "fetch_npc", targetNPC.GetDisplayName(), 1)  ; Jog by default
        Core.SendTaskNarration(akAgent, akAgent.GetDisplayName() + " cannot take on this task right now.")
        Return false
    EndIf
"""),
("""    ; Find slot
    Int slot = Core.FindFreeAgentSlot()
""",
"""    ; Find slot (patch: reserved until TryAllocateSlot)
    Int slot = Core.ReserveFreeAgentSlot()
"""),
("""    ; Allocate
    Core.AllocateSlot(slot, akAgent, "deliver_message", targetNPC.GetDisplayName(), 1)
""",
"""    ; Allocate (patch: refuses if another live actor holds the alias)
    If !Core.TryAllocateSlot(slot, akAgent, "deliver_message", targetNPC.GetDisplayName(), 1)
        Core.SendTaskNarration(akAgent, akAgent.GetDisplayName() + " cannot take on this task right now.")
        Return false
    EndIf
"""),
("""    ; Find free slot
    Int slot = Core.FindFreeAgentSlot()
    If slot < 0
        Core.SendTaskNarration(akAgent, akAgent.GetDisplayName() + " cannot take on this task right now.")
        Return false
    EndIf

    ; Anti-trespass: unlock target NPC's home door so agent can enter
    Core.UnlockHomeForTask(akAgent, targetNPC)

    ; Destination is always the target actor directly.
""",
"""    ; Find free slot (patch: reserved until TryAllocateSlot)
    Int slot = Core.ReserveFreeAgentSlot()
    If slot < 0
        Core.SendTaskNarration(akAgent, akAgent.GetDisplayName() + " cannot take on this task right now.")
        Return false
    EndIf

    ; Anti-trespass: unlock target NPC's home door so agent can enter
    Core.UnlockHomeForTask(akAgent, targetNPC)

    ; Destination is always the target actor directly.
"""),
("""    ; Allocate slot
    Core.AllocateSlot(slot, akAgent, "search_for_actor", targetNPC.GetDisplayName(), speed)
""",
"""    ; Allocate slot (patch: refuses if another live actor holds the alias)
    If !Core.TryAllocateSlot(slot, akAgent, "search_for_actor", targetNPC.GetDisplayName(), speed)
        Core.SendTaskNarration(akAgent, akAgent.GetDisplayName() + " cannot take on this task right now.")
        Return false
    EndIf
"""),
("""    ; Find free slot
    Int slot = Core.FindFreeAgentSlot()
    If slot < 0
        Core.SendTaskNarration(akAgent, akAgent.GetDisplayName() + " cannot take on this task right now.")
        Return false
    EndIf

    ; Anti-trespass: unlock destination so both can enter
""",
"""    ; Find free slot (patch: reserved until TryAllocateSlot)
    Int slot = Core.ReserveFreeAgentSlot()
    If slot < 0
        Core.SendTaskNarration(akAgent, akAgent.GetDisplayName() + " cannot take on this task right now.")
        Return false
    EndIf

    ; Anti-trespass: unlock destination so both can enter
"""),
("""    ; Allocate slot
    Core.AllocateSlot(slot, akAgent, "escort_target", targetNPC.GetDisplayName(), 1)
""",
"""    ; Allocate slot (patch: refuses if another live actor holds the alias)
    If !Core.TryAllocateSlot(slot, akAgent, "escort_target", targetNPC.GetDisplayName(), 1)
        Core.SendTaskNarration(akAgent, akAgent.GetDisplayName() + " cannot take on this task right now.")
        Return false
    EndIf
"""),
])
    edit("IntelEngine_StoryEngine.psc", [
("""    Int slot = Core.FindFreeAgentSlot()
    If slot < 0
        ; No free slots -- fall back to off-screen (log already added before visibility branch)
""",
"""    Int slot = Core.ReserveFreeAgentSlot()
    If slot < 0
        ; No free slots -- fall back to off-screen (log already added before visibility branch)
"""),
("""    Core.AllocateSlot(slot, npc, "npc_social", target.GetDisplayName(), 1)
""",
"""    ; Patch (slot race): refused allocation falls back to off-screen, as a missing slot does
    If !Core.TryAllocateSlot(slot, npc, "npc_social", target.GetDisplayName(), 1)
        String refusedSummary = BuildInteractionSummary(npc, narration, target)
        AddRecentStoryEvent(storyType + ": " + refusedSummary)
        Core.DebugMsg("NPC Social: slot refused, off-screen: " + refusedSummary)
        return
    EndIf
"""),
("""    Int slot = Core.FindFreeAgentSlot()
    If slot < 0
        Debug.Trace("[IntelEngine] StoryEngine: No free slots for dispatch")
""",
"""    Int slot = Core.ReserveFreeAgentSlot()
    If slot < 0
        Debug.Trace("[IntelEngine] StoryEngine: No free slots for dispatch")
"""),
("""    Core.AllocateSlot(slot, npc, slotTaskType, targetName, 1)
""",
"""    ; Patch (slot race): refused allocation aborts like a missing slot, and the DM record is marked failed
    If !Core.TryAllocateSlot(slot, npc, slotTaskType, targetName, 1)
        Core.DebugMsg("Story DM: slot " + slot + " refused for " + npc.GetDisplayName() + " - dispatch aborted")
        IntelEngine.MarkLastDispatchFailed("task slot taken by another npc")
        If target != player
            ActiveSecondNPC = None
            AddRecentStoryEvent(ActiveStoryType + ": " + BuildInteractionSummary(npc, narration, target))
        EndIf
        ActiveStoryType = ""
        return
    EndIf
"""),
])
    edit("IntelEngine_Battle.psc", [
("""        ; Find a free slot
        Int slot = Core.FindFreeAgentSlot()
""",
"""        ; Find a free slot (patch: reserved until TryAllocateSlot)
        Int slot = Core.ReserveFreeAgentSlot()
"""),
("""        Core.AllocateSlot(slot, assassin, "assassination", leaderName, 0)
""",
"""        ; Patch (slot race): refused allocation aborts like a missing slot
        If !Core.TryAllocateSlot(slot, assassin, "assassination", leaderName, 0)
            Core.DebugMsg("Battle: assassin task slot refused — aborting")
            assassin.DisableNoWait()
            assassin.Delete()
            ManifestActors[0] = None
            ManifestCount = 0
            ManifestLeaderTarget = None
            ManifestActive = false
            return
        EndIf
"""),
])
elif G == "core-expiry":   # old saves: never depend on the variable initializer
    edit("IntelEngine_Core.psc", [(
"""    ; Patch (slot race): no reservation survives a load
    IEB_SlotReservedAt = new Float[5]
""",
"""    ; Patch (slot race): no reservation survives a load; expiry set here too (a save made before this build
    ; would otherwise carry 0.0, which turns reservations off)
    IEB_SlotReservedAt = new Float[5]
    IEB_RESERVE_EXPIRY = 120.0
""")])
elif G == "rv68":   # RV-68 (2): undo DismissFollowerForTask when TryAllocateSlot refuses
    edit("IntelEngine_Core.psc", [(
"""Int Function ShowTaskConfirmation(Actor npc, String promptText)
    {Legacy wrapper""",
"""Function UndoDismissOnRefusal(Actor npc)
    {Patch (RV-68): TryAllocateSlot refused after DismissFollowerForTask ran. Clears Intel_WasFollower (the Errand Bridge
    Classify reads it) and, in drop mode (IEB_DropTeammate = 1, where the dismiss cleared the teammate flag), restores
    the flag. Skipped when the actor already holds a slot (its Intel_WasFollower belongs to that task). The package
    overrides the dismiss cleared are not restored (the NPC re-evaluates to its normal AI / follow package on its own).
    Door: IntelEngine has no relock counterpart to UnlockHomeForTask (ClearSlot only drops the key, "vanilla handles
    re-locking"), so the unlock is logged and the key dropped.}
    If npc == None
        Return
    EndIf
    If FindSlotByAgent(npc) < 0
        If StorageUtil.GetIntValue(npc, "Intel_WasFollower") != 0
            StorageUtil.UnsetIntValue(npc, "Intel_WasFollower")
            If StorageUtil.GetIntValue(None, "IEB_DropTeammate", 0) == 1
                npc.SetPlayerTeammate(true)
                DebugMsg("SLOT_REFUSED_UNDO: restored teammate flag for " + npc.GetDisplayName())
            EndIf
        EndIf
    EndIf
    Int doorCell = StorageUtil.GetIntValue(npc, "Intel_UnlockedHomeCellId")
    If doorCell != 0
        DebugMsg("DOOR_LEFT_UNLOCKED " + npc.GetDisplayName() + " cell=" + doorCell)
        StorageUtil.UnsetIntValue(npc, "Intel_UnlockedHomeCellId")
    EndIf
    npc.EvaluatePackage()
EndFunction

Int Function ShowTaskConfirmation(Actor npc, String promptText)
    {Legacy wrapper""")])
    edit("IntelEngine_Travel.psc", [(
"""    If !Core.TryAllocateSlot(slot, akNPC, "travel", destination, speed)
""",
"""    If !Core.TryAllocateSlot(slot, akNPC, "travel", destination, speed)
        Core.UndoDismissOnRefusal(akNPC)  ; RV-68
""")])
    edit("IntelEngine_NPCTasks.psc", [
("""    If !Core.TryAllocateSlot(slot, akAgent, "fetch_npc", targetNPC.GetDisplayName(), 1)  ; Jog by default
""",
"""    If !Core.TryAllocateSlot(slot, akAgent, "fetch_npc", targetNPC.GetDisplayName(), 1)  ; Jog by default
        Core.UndoDismissOnRefusal(akAgent)  ; RV-68
"""),
("""    If !Core.TryAllocateSlot(slot, akAgent, "deliver_message", targetNPC.GetDisplayName(), 1)
""",
"""    If !Core.TryAllocateSlot(slot, akAgent, "deliver_message", targetNPC.GetDisplayName(), 1)
        Core.UndoDismissOnRefusal(akAgent)  ; RV-68
"""),
("""    If !Core.TryAllocateSlot(slot, akAgent, "search_for_actor", targetNPC.GetDisplayName(), speed)
""",
"""    If !Core.TryAllocateSlot(slot, akAgent, "search_for_actor", targetNPC.GetDisplayName(), speed)
        Core.UndoDismissOnRefusal(akAgent)  ; RV-68
"""),
("""    If !Core.TryAllocateSlot(slot, akAgent, "escort_target", targetNPC.GetDisplayName(), 1)
""",
"""    If !Core.TryAllocateSlot(slot, akAgent, "escort_target", targetNPC.GetDisplayName(), 1)
        Core.UndoDismissOnRefusal(akAgent)  ; RV-68
"""),
])
elif G == "rv68b":   # RV-68-close (a): a refusal cannot re-apply a SkyrimNet follow package it released; log it
    # Who registered FollowPlayer is unknown here (SeverActions Follow / Ambush / Arrest use different priorities and
    # persistence), so re-registering would guess its owner: the release is marked and logged instead.
    edit("IntelEngine_Core.psc", [
("""    ; Clear ALL package overrides from all sources
    RemoveIntelPackages(npc, false)
    IEB_ReleaseSkyrimNetPackages(npc)
""",
"""    ; Clear ALL package overrides from all sources
    ; Patch (RV-68-close a): remember a released SkyrimNet follow package for the refusal undo
    StorageUtil.SetIntValue(npc, "IEB_SNFollowReleased", SkyrimNetApi.HasPackage(npc, "FollowPlayer"))
    RemoveIntelPackages(npc, false)
    IEB_ReleaseSkyrimNetPackages(npc)
"""),
("""    Int doorCell = StorageUtil.GetIntValue(npc, "Intel_UnlockedHomeCellId")
    If doorCell != 0
        DebugMsg("DOOR_LEFT_UNLOCKED " + npc.GetDisplayName() + " cell=" + doorCell)
""",
"""    If StorageUtil.GetIntValue(npc, "IEB_SNFollowReleased") == 1 && FindSlotByAgent(npc) < 0
        ; no re-follow: the package owner (SeverActions follow/ambush/arrest) and its priority are unknown here
        DebugMsg("FOLLOW_PKG_RELEASED " + npc.GetDisplayName())
        StorageUtil.UnsetIntValue(npc, "IEB_SNFollowReleased")
    EndIf
    Int doorCell = StorageUtil.GetIntValue(npc, "Intel_UnlockedHomeCellId")
    If doorCell != 0
        DebugMsg("DOOR_LEFT_UNLOCKED " + npc.GetDisplayName() + " cell=" + doorCell)
"""),
])
elif G == "rv70":   # REVIEW_LOG RV-70 (c): say which condition makes the poll fast (once per change, no spam)
    edit("IntelEngine_StoryEngine.psc", [
("""Bool Function IEB_NeedsFastTick()
    {Patch F2: True while any IntelEngine task slot is active or Battle has anything to poll.}
    If Core == None
        return false
    EndIf
    Int[] states = Core.SlotStates
    If states != None
        Int i = 0
        While i < states.Length
            If states[i] != 0
                return true
            EndIf
            i += 1
        EndWhile
    EndIf
    IntelEngine_Battle b = Core.Battle
    If b != None
        If b.ManifestActive || b.DeferredCleanupActive || b.PendingPollActive
            return true
        EndIf
    EndIf
    return IntelEngine.IsBattleActive()
EndFunction
""",
"""String IEB_LastFastWhy = ""

Bool Function IEB_NeedsFastTick()
    {Patch F2: True while any IntelEngine task slot is active or Battle has anything to poll.
     REVIEW_LOG RV-70 (c): the reason is logged once each time it changes (IEB_FASTTICK), "idle" when it ends.}
    String why = IEB_FastWhy()
    If why != IEB_LastFastWhy
        IEB_LastFastWhy = why
        Core.DebugMsg("IEB_FASTTICK " + why)
    EndIf
    return why != "idle"
EndFunction

String Function IEB_FastWhy()
    If Core == None
        return "idle"
    EndIf
    Int[] states = Core.SlotStates
    If states != None
        Int i = 0
        While i < states.Length
            If states[i] != 0
                String t = ""
                If Core.SlotTaskTypes != None && i < Core.SlotTaskTypes.Length
                    t = Core.SlotTaskTypes[i]
                EndIf
                return "slot=" + i + " state=" + states[i] + " type=" + t
            EndIf
            i += 1
        EndWhile
    EndIf
    IntelEngine_Battle b = Core.Battle
    If b != None
        If b.ManifestActive || b.DeferredCleanupActive || b.PendingPollActive
            return "battle manifest=" + b.ManifestActive + " cleanup=" + b.DeferredCleanupActive + " pending=" + b.PendingPollActive
        EndIf
    EndIf
    If IntelEngine.IsBattleActive()
        return "battle native"
    EndIf
    return "idle"
EndFunction
"""),
])
elif G == "rv72":   # REVIEW_LOG RV-72 (a) + RV-72-upd (1) + (c): no array-vs-None compares; Intel_TaskType restore on load
    edit("IntelEngine_Core.psc", [
("""    If SlotStates == None
        InitializeSlotArrays()
    ElseIf SlotStates.Length != MAX_SLOTS""",
"""    ; Patch (REVIEW_LOG RV-72 a): `arr == None` fails in the VM ("Cannot cast from None to Int[]"); stock line rewritten
    If !SlotStates
        InitializeSlotArrays()
    ElseIf SlotStates.Length != MAX_SLOTS"""),
("""            RecoverActiveTasks()
            DebugMsg("Task recovery: StorageUtil legacy path")
        EndIf
    EndIf
""",
"""            RecoverActiveTasks()
            DebugMsg("Task recovery: StorageUtil legacy path")
        EndIf
    EndIf
    ; Patch (REVIEW_LOG RV-72-upd 1, RV-72 c): log every active slot's keys as loaded; restore a blank key 5 s later
    If IEB_TaskTypeScan(false) > 0
        RegisterForSingleUpdate(5.0)
    EndIf
"""),
("""ReferenceAlias Function GetAgentAlias(Int slot)
""",
"""Int Function IEB_TaskTypeScan(Bool restore)
    {Patch (REVIEW_LOG RV-72-upd 1): an active slot (SlotStates != 0) whose agent alias holds a live actor must carry
    that actor's Intel_TaskType. ClearSlot unsets the key (:750) before it clears the alias and sets SlotStates 0, so
    a blank key on an active slot means "being torn down", and the bridge makes no decision on it (DecisionTaskType).
    After a load the key was found blank on resumed errands (RV-70 probe): restore it from SlotTaskTypes, but only on
    the 5 s re-check (restore = true), so a teardown saved mid-ClearSlot finishes first (ClearSlot has no waits) and
    "" keeps meaning teardown. restore = false: log only (IEB_LOADKEYS, the RV-72 (c) load-side probe) and return how
    many slots would be restored.}
    Int[] st = SlotStates
    String[] ty = SlotTaskTypes
    If !st || !ty
        DebugMsg("IEB_LOADKEYS no slot arrays")
        Return 0
    EndIf
    Int found = 0
    Int i = 0
    While i < MAX_SLOTS && i < st.Length && i < ty.Length
        If st[i] != 0
            Actor a = None
            ReferenceAlias al = GetAgentAlias(i)
            If al
                a = al.GetActorReference()
            EndIf
            String key = ""
            If a
                key = StorageUtil.GetStringValue(a, "Intel_TaskType", "")
            EndIf
            If !restore
                DebugMsg("IEB_LOADKEYS slot=" + i + " state=" + st[i] + " slotType=" + ty[i] + " actor=" + a + " key=" + key)
            EndIf
            If a && !a.IsDead() && key == "" && ty[i] != ""
                found += 1
                If restore
                    StorageUtil.SetStringValue(a, "Intel_TaskType", ty[i])
                    DebugMsg("TASKTYPE_RESTORED slot=" + i + " type=" + ty[i] + " actor=" + a.GetDisplayName())
                EndIf
            EndIf
        EndIf
        i += 1
    EndWhile
    Return found
EndFunction

Event OnUpdate()
    {Patch (REVIEW_LOG RV-72-upd 1): the 5 s re-check registered by Maintenance. Core had no OnUpdate before this patch;
    single updates are per script, so the other scripts on the quest are unaffected.}
    IEB_TaskTypeScan(true)
EndEvent

Float Function IEB_ReservedAge(Int slot)
    {Patch (REVIEW_LOG RV-72-upd): test read of the slot-race reservation stamp: real-time age in s of the stamp,
    -1 = no stamp, -2 = no stamp array or bad slot.}
    Float[] res = IEB_SlotReservedAt
    If !res || slot < 0 || slot >= res.Length
        Return -2.0
    EndIf
    If res[slot] <= 0.0
        Return -1.0
    EndIf
    Return Utility.GetCurrentRealTime() - res[slot]
EndFunction

ReferenceAlias Function GetAgentAlias(Int slot)
"""),
("""        If res != None
            Float r = res[i]""",
"""        If res && i < res.Length
            Float r = res[i]"""),
("""    If IEB_SlotReservedAt == None
        IEB_SlotReservedAt = new Float[5]
    EndIf""",
"""    If !IEB_SlotReservedAt
        IEB_SlotReservedAt = new Float[5]
    EndIf"""),
("""    If slot >= 0 && slot < MAX_SLOTS && IEB_SlotReservedAt != None""",
"""    If slot >= 0 && slot < MAX_SLOTS && IEB_SlotReservedAt"""),
])
    edit("IntelEngine_StoryEngine.psc", [
("""    Int[] states = Core.SlotStates
    If states != None
        Int i = 0
        While i < states.Length
            If states[i] != 0
                String t = ""
                If Core.SlotTaskTypes != None && i < Core.SlotTaskTypes.Length
                    t = Core.SlotTaskTypes[i]
                EndIf""",
"""    Int[] states = Core.SlotStates
    String[] types = Core.SlotTaskTypes
    ; REVIEW_LOG RV-72 (a): If arr, never arr != None
    If states
        Int i = 0
        While i < states.Length
            If states[i] != 0
                String t = ""
                If types && i < types.Length
                    t = types[i]
                EndIf"""),
])
else:
    sys.exit("unknown group " + G)
print("ok", G)
