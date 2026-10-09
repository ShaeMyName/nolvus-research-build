"""Apply IntelEngine patch B (spec §10.1, §10.2, §10.2.1 E1-E7) to build/src/intelengine, one hunk group per call.
Usage: apply_patch_b.py <group>. Every anchor must match exactly once (CRLF kept)."""
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


def append(fname, text):
    p = D + fname
    s = open(p, "rb").read().decode("utf-8")
    if not s.endswith(NL):
        s += NL
    open(p, "wb").write((s + text.replace("\n", NL)).encode("utf-8"))


G = sys.argv[1]

if G == "core-dismiss":   # §10.1 DismissFollowerForTask + IEB_ReleaseSkyrimNetPackages
    edit("IntelEngine_Core.psc", [(
"""    ; Clear ALL package overrides from all sources
    ActorUtil.ClearPackageOverride(npc)
    DebugMsg("Cleared all package overrides for " + npc.GetDisplayName())

    ; Also clear vanilla follower state so the engine doesn't re-apply follow AI
    If npc.IsPlayerTeammate()
        StorageUtil.SetIntValue(npc, "Intel_WasFollower", 1)
        npc.SetPlayerTeammate(false)
        DebugMsg("Dismissed follower: " + npc.GetDisplayName())
    EndIf
EndFunction
""",
"""    ; Clear ALL package overrides from all sources
    RemoveIntelPackages(npc, false)
    IEB_ReleaseSkyrimNetPackages(npc)
    DebugMsg("Removed IntelEngine and SkyrimNet follow packages for " + npc.GetDisplayName())

    ; Patch: mark the follower but KEEP the teammate flag for the whole task. The priority-100
    ; overrides drive the NPC; ClearSlotRestoreFollower's SetPlayerTeammate(true) becomes a no-op.
    ; Global StorageUtil int "IEB_DropTeammate" = 1 restores the stock drop (A/B, rollback).
    If npc.IsPlayerTeammate()
        StorageUtil.SetIntValue(npc, "Intel_WasFollower", 1)
        If StorageUtil.GetIntValue(None, "IEB_DropTeammate", 0) == 1
            npc.SetPlayerTeammate(false)
            DebugMsg("Dismissed follower: " + npc.GetDisplayName())
        Else
            DebugMsg("Kept follower as teammate for task: " + npc.GetDisplayName())
        EndIf
    EndIf
EndFunction
""")])
    append("IntelEngine_Core.psc", """
Function IEB_ReleaseSkyrimNetPackages(Actor npc)
    {Patch: unregister SkyrimNet's own follow/talk packages by name instead of clearing every override.}
    If SkyrimNetApi.HasPackage(npc, "FollowPlayer") == 1
        SkyrimNetApi.UnregisterPackage(npc, "FollowPlayer")
    EndIf
    If SkyrimNetApi.HasPackage(npc, "TalkToPlayer") == 1
        SkyrimNetApi.UnregisterPackage(npc, "TalkToPlayer")
    EndIf
    If SkyrimNetApi.HasPackage(npc, "TalkToNPC") == 1
        SkyrimNetApi.UnregisterPackage(npc, "TalkToNPC")
    EndIf
EndFunction
""")

elif G == "core-removeall":   # §10.1 RemoveAllPackages keeps `evaluate`
    edit("IntelEngine_Core.psc", [(
"""    ; Pass evaluate=false when adding a new package immediately after (prevents brief base-AI gap)
    ActorUtil.ClearPackageOverride(akActor)
    If evaluate
        akActor.EvaluatePackage()
    EndIf
EndFunction
""",
"""    ; Pass evaluate=false when adding a new package immediately after (prevents brief base-AI gap)
    RemoveIntelPackages(akActor, evaluate)
EndFunction
""")])

elif G == "core-events":   # §10.1 IntelEngine_TaskStarted / IntelEngine_TaskEnded
    edit("IntelEngine_Core.psc", [(
"""    DebugMsg("Allocated slot " + slot + " to " + akAgent.GetDisplayName() + " for " + taskType)
EndFunction
""",
"""    DebugMsg("Allocated slot " + slot + " to " + akAgent.GetDisplayName() + " for " + taskType)
    akAgent.SendModEvent("IntelEngine_TaskStarted", taskType, slot as Float)
EndFunction
"""), (
"""            DebugMsg("Clearing slot " + slot + ": " + agent.GetDisplayName())
""",
"""            DebugMsg("Clearing slot " + slot + ": " + agent.GetDisplayName())
            agent.SendModEvent("IntelEngine_TaskEnded", StorageUtil.GetStringValue(agent, "Intel_Result"), slot as Float)
""")])

elif G == "story-busy":   # §10.2: DispatchNPCSocial / DispatchToTarget backstop (E6) + IEB_DispatchBlocked
    edit("IntelEngine_StoryEngine.psc", [(
"""Function DispatchNPCSocial(Actor npc, Actor target, String narration, String storyType)
    {Lightweight dispatch for NPC-to-NPC travel. Uses slots but does NOT touch IsActive/ActiveStoryNPC.}
""",
"""Function DispatchNPCSocial(Actor npc, Actor target, String narration, String storyType)
    {Lightweight dispatch for NPC-to-NPC travel. Uses slots but does NOT touch IsActive/ActiveStoryNPC.}
    If IEB_DispatchBlocked(npc)
        AddRecentStoryEvent(storyType + ": " + BuildInteractionSummary(npc, narration, target))
        Core.DebugMsg("NPC Social: " + npc.GetDisplayName() + " is busy or with the player - off-screen only")
        return
    EndIf
"""), (
"""Function DispatchToTarget(Actor npc, Actor target, String narration, String slotTaskType)
    Actor player = Game.GetPlayer()
""",
"""Function DispatchToTarget(Actor npc, Actor target, String narration, String slotTaskType)
    If IEB_DispatchBlocked(npc)
        Core.DebugMsg("Story DM: " + npc.GetDisplayName() + " is busy or with the player - dispatch refused")
        IntelEngine.MarkLastDispatchFailed("npc is busy or travelling with the player")
        ActiveStoryType = ""
        return
    EndIf
    Actor player = Game.GetPlayer()
""")])
    append("IntelEngine_StoryEngine.psc", """
Bool Function IEB_DispatchBlocked(Actor a)
    {Patch: refuse dispatch of an NPC that already holds a task slot, travels with the player,
     or is held or lent by the Errand Bridge.}
    If a == None
        return false
    EndIf
    If Core.FindSlotByAgent(a) >= 0 || a.IsPlayerTeammate()
        return true
    EndIf
    If StorageUtil.GetIntValue(a, "IEB_Gate", 0) > 0
        return true
    EndIf
    Faction cff = Game.GetFormFromFile(0x0005C84E, "Skyrim.esm") as Faction   ; CurrentFollowerFaction
    return cff != None && a.GetFactionRank(cff) >= 0
EndFunction
""")

elif G == "story-guard":   # §10.2.1 guard functions
    append("IntelEngine_StoryEngine.psc", """
Bool Function IEB_StoryBlocked(Actor a, Int tier)
    return IEB_DispatchBlocked(a) || IEB_QuestReserved(a, tier)
EndFunction

Bool Function IEB_QuestReserved(Actor a, Int tier)
    {Patch: true if a story beat of this tier must not use this actor (quest integrity).}
    If a == None || tier < 1
        return false
    EndIf
    If a.GetCurrentScene() != None
        return true
    EndIf
    String qiFile = IEB_QIFile()
    Int n = a.GetNumReferenceAliases()
    Int i = 0
    While i < n
        ReferenceAlias ra = a.GetNthReferenceAlias(i)
        Quest q = None
        If ra
            q = ra.GetOwningQuest()
        EndIf
        If q && (q.IsRunning() || q.IsStarting()) && !IEB_ExemptQuest(q)
            If JsonUtil.FormListHas(qiFile, "story_quests", q) || IEB_HasOpenObjective(q)
                return true
            EndIf
        EndIf
        i += 1
    EndWhile
    If tier >= 2
        ActorBase b = a.GetActorBase()
        If a.IsEssential() || b.IsEssential() || b.IsProtected()
            return true
        EndIf
        return JsonUtil.FormListHas(qiFile, "reserved_npcs", b)
    EndIf
    return false
EndFunction

String Function IEB_QIFile()
    {Patch: Data/SKSE/Plugins/ErrandBridge/quest_integrity.json (JsonUtil paths are relative to StorageUtilData).}
    return "../ErrandBridge/quest_integrity"
EndFunction

Bool Function IEB_ExemptQuest(Quest q)
    {Patch: the quest's original plugin is in the JSON string list "exempt_plugins" (Papyrus == ignores case).}
    String modName = PO3_SKSEFunctions.GetFormModName(q, false)
    String qiFile = IEB_QIFile()
    Int n = JsonUtil.StringListCount(qiFile, "exempt_plugins")
    Int i = 0
    While i < n
        If JsonUtil.StringListGet(qiFile, "exempt_plugins", i) == modName
            return true
        EndIf
        i += 1
    EndWhile
    return false
EndFunction

Bool Function IEB_HasOpenObjective(Quest q)
    {Patch: any objective that is displayed and not completed.}
    Int[] objs = PO3_SKSEFunctions.GetAllQuestObjectives(q)
    Int i = 0
    While i < objs.Length
        If q.IsObjectiveDisplayed(objs[i]) && !q.IsObjectiveCompleted(objs[i])
            return true
        EndIf
        i += 1
    EndWhile
    return false
EndFunction

Int Function IEB_StoryTier(String storyType)
    {Patch: E1 tier by story type (§10.2.1). message is checked later on the messenger (E3).}
    If storyType == "ambush"
        return 2
    ElseIf storyType == "seek_player" || storyType == "informant" || storyType == "road_encounter" || storyType == "stalker" || storyType == "quest"
        return 1
    EndIf
    return 0
EndFunction
""")

elif G == "story-entries":   # §10.2.1 E1-E5
    edit("IntelEngine_StoryEngine.psc", [
        # E1: after the cooldown check, before the cell re-validation
        ("""        If !ApplyCooldownCheck(npc)
            Core.DebugMsg("Story DM: " + npc.GetDisplayName() + " on cooldown")
            IntelEngine.MarkLastDispatchFailed("on story cooldown")
            return
        EndIf

        ; Re-validate: reject player-targeted types if NPC ended up in the player's cell
""",
         """        If !ApplyCooldownCheck(npc)
            Core.DebugMsg("Story DM: " + npc.GetDisplayName() + " on cooldown")
            IntelEngine.MarkLastDispatchFailed("on story cooldown")
            return
        EndIf
        ; Patch E1 (quest integrity): refuse before any story state is written
        Int ieTier = IEB_StoryTier(storyType)
        If ieTier > 0 && IEB_StoryBlocked(npc, ieTier)
            Core.DebugMsg("Story DM: " + npc.GetDisplayName() + " is committed to a quest - " + storyType + " refused")
            IntelEngine.MarkLastDispatchFailed("npc is committed to a quest")
            return
        EndIf

        ; Re-validate: reject player-targeted types if NPC ended up in the player's cell
"""),
        # E2a: rescue victim, tier 2 (replaces the §10.2 victim hunk)
        ("""        If victimActor.IsPlayerTeammate()
            Core.DebugMsg("Story DM: quest/rescue rejected -- victim '" + victimName + "' is the player's teammate")
            return
        EndIf
""",
         """        If victimActor.IsPlayerTeammate()
            Core.DebugMsg("Story DM: quest/rescue rejected -- victim '" + victimName + "' is the player's teammate")
            return
        EndIf
        ; Patch E2 (quest integrity): victim tier 2
        If IEB_StoryBlocked(victimActor, 2)
            Core.DebugMsg("Story DM: quest/rescue rejected -- victim '" + victimName + "' is committed to a quest")
            IntelEngine.MarkLastDispatchFailed("npc is committed to a quest")
            return
        EndIf
"""),
        # E2b: FindFactionMember result, tier 1
        ("""        Actor factionMember = IntelEngine.FindFactionMember(alliedFaction)
        If factionMember == None
            Core.DebugMsg("Story DM: quest/" + questSubTypeStr + " rejected -- no loaded " + alliedFaction + " member found")
            return
        EndIf
""",
         """        Actor factionMember = IntelEngine.FindFactionMember(alliedFaction)
        If factionMember == None
            Core.DebugMsg("Story DM: quest/" + questSubTypeStr + " rejected -- no loaded " + alliedFaction + " member found")
            return
        EndIf
        ; Patch E2 (quest integrity): faction courier tier 1
        If IEB_StoryBlocked(factionMember, 1)
            Core.DebugMsg("Story DM: quest/" + questSubTypeStr + " rejected -- faction member " + factionMember.GetDisplayName() + " is committed to a quest")
            IntelEngine.MarkLastDispatchFailed("npc is committed to a quest")
            return
        EndIf
"""),
        # E2c: substitute giver, tier 1
        ("""            Actor factionSub = IntelEngine.FindFactionMember(alliedFaction)
            If factionSub == None
                Core.DebugMsg("Story DM: quest/" + questSubTypeStr + " rejected -- no loaded " + alliedFaction + " member found")
                return
            EndIf
""",
         """            Actor factionSub = IntelEngine.FindFactionMember(alliedFaction)
            If factionSub == None
                Core.DebugMsg("Story DM: quest/" + questSubTypeStr + " rejected -- no loaded " + alliedFaction + " member found")
                return
            EndIf
            ; Patch E2 (quest integrity): substitute giver tier 1
            If IEB_StoryBlocked(factionSub, 1)
                Core.DebugMsg("Story DM: quest/" + questSubTypeStr + " rejected -- substitute " + factionSub.GetDisplayName() + " is committed to a quest")
                IntelEngine.MarkLastDispatchFailed("npc is committed to a quest")
                return
            EndIf
"""),
        # E3: messenger (incl. self-delivery), before the message facts
        ("""            Core.DebugMsg("Story message: rejected -- no messenger for " + senderName + " (non-civilian, no self-delivery)")
            return
        EndIf
    EndIf

    String messengerName = messenger.GetDisplayName()
""",
         """            Core.DebugMsg("Story message: rejected -- no messenger for " + senderName + " (non-civilian, no self-delivery)")
            return
        EndIf
    EndIf
    ; Patch E3 (quest integrity): messenger tier 1, before any message facts are written
    If IEB_StoryBlocked(messenger, 1)
        Core.DebugMsg("Story message: rejected -- messenger " + messenger.GetDisplayName() + " is committed to a quest")
        IntelEngine.MarkLastDispatchFailed("npc is committed to a quest")
        return
    EndIf

    String messengerName = messenger.GetDisplayName()
"""),
        # E4: no meeting for a blocked sender (the message is still delivered)
        ("""        If senderForMeeting != None
            String timeCondition = meetTime
""",
         """        ; Patch E4 (quest integrity): no meeting for a sender blocked at tier 1
        If senderForMeeting != None && IEB_StoryBlocked(senderForMeeting, 1)
            Core.DebugMsg("Story message: meeting skipped -- " + senderForMeeting.GetDisplayName() + " is committed to a quest")
        ElseIf senderForMeeting != None
            String timeCondition = meetTime
"""),
        # E5: NPC-social traveller blocked -> existing off-screen branch
        ("""    If npc1Visible && npc2Visible
        ; Both in player cell -- instant interaction
        PerformVisibleInteraction(npc1, npc2, narration, storyType)
    ElseIf (npc1Visible || npc2Visible) && !IsNPCStoryActive && !npc1.IsPlayerTeammate() && !npc2.IsPlayerTeammate()
""",
         """    ; Patch E5 (quest integrity): the off-screen NPC is the one who would travel
    Actor ieTraveller = npc2
    If npc2Visible
        ieTraveller = npc1
    EndIf

    If npc1Visible && npc2Visible
        ; Both in player cell -- instant interaction
        PerformVisibleInteraction(npc1, npc2, narration, storyType)
    ElseIf (npc1Visible || npc2Visible) && !IsNPCStoryActive && !npc1.IsPlayerTeammate() && !npc2.IsPlayerTeammate() && !IEB_StoryBlocked(ieTraveller, 1)
"""),
    ])

elif G == "battle-e7":   # §10.2.1 E7: assassination target tier 2
    edit("IntelEngine_Battle.psc", [(
"""        If assTarget == None
            Core.DebugMsg("Battle: Assassination target not found — aborting")
            assassin.DisableNoWait()
            assassin.Delete()
            ManifestActive = false
            return
        EndIf
""",
"""        If assTarget == None
            Core.DebugMsg("Battle: Assassination target not found — aborting")
            assassin.DisableNoWait()
            assassin.Delete()
            ManifestActive = false
            return
        EndIf
        ; Patch E7 (quest integrity): never target an actor blocked at tier 2; abort like a missing target
        If Core.StoryEngine.IEB_StoryBlocked(assTarget, 2)
            Core.DebugMsg("Battle: assassination target " + leaderName + " is committed to a quest -- aborting")
            assassin.DisableNoWait()
            assassin.Delete()
            ManifestActive = false
            return
        EndIf
""")])
elif G == "selfcheck":   # [added in build, Shae 2026-10-09, list A] loud load-time self-check + Q-9 probe
    edit("IntelEngine_Core.psc", [(
"""    LastMaintenanceRealTime = now
    DebugMsg("IntelEngine Maintenance (firstLoad=" + isFirstLoad + ")")
""",
"""    LastMaintenanceRealTime = now
    DebugMsg("IntelEngine Maintenance (firstLoad=" + isFirstLoad + ")")
    ; Patch: the quest-integrity guard must never fail silently (once per load, after the duplicate guard)
    If StoryEngine
        StoryEngine.IEB_QISelfCheck()
    EndIf
""")])
    append("IntelEngine_StoryEngine.psc", """
Function IEB_QISelfCheck()
    {Patch (list A): the quest-integrity guard must never fail silently. On every load: the JSON exists
     and parses, and each form list resolves to at least 95% of the builder's recorded count.}
    String f = IEB_QIFile()
    String problem = ""
    If !JsonUtil.JsonExists(f)
        problem = "file missing"
    ElseIf !JsonUtil.IsGood(f)
        problem = "parse error " + JsonUtil.GetErrors(f)
    Else
        problem = IEB_QICheckList(f, "story_quests") + IEB_QICheckList(f, "reserved_npcs")
        Int ex = JsonUtil.StringListCount(f, "exempt_plugins")
        If ex == 0 || ex < JsonUtil.GetIntValue(f, "exempt_plugins_count", 1)
            problem += "exempt_plugins " + ex + " of " + JsonUtil.GetIntValue(f, "exempt_plugins_count", 0) + "; "
        EndIf
    EndIf
    If problem == ""
        Debug.Trace("[IEB] quest_integrity OK: story_quests " + JsonUtil.FormListCount(f, "story_quests") + ", reserved_npcs " + JsonUtil.FormListCount(f, "reserved_npcs"))
    Else
        Debug.Trace("[IEB] WARN quest_integrity: " + problem + "quest NPCs are NOT protected from story dispatch", 2)
        Debug.Notification("IEB WARNING: quest-integrity list failed (" + problem + ") Quest NPCs are unprotected.")
    EndIf
    If JsonUtil.GetIntValue(f, "write_probe", 0) == 1
        IEB_QIWriteProbe(f)
    EndIf
EndFunction

String Function IEB_QICheckList(String f, String listKey)
    {Patch: "" if the list resolves to >= 95% of its recorded count, else a short problem text.}
    Int expected = JsonUtil.GetIntValue(f, listKey + "_count", 0)
    Form[] arr = JsonUtil.FormListToArray(f, listKey)
    Int resolved = arr.Length - PapyrusUtil.CountNone(arr)
    Debug.Trace("[IEB] quest_integrity " + listKey + ": resolved " + resolved + " of " + expected + " (entries " + arr.Length + ")")
    If expected <= 0
        return listKey + " has no recorded count; "
    ElseIf resolved == 0 || resolved * 100 < expected * 95
        return listKey + " resolved " + resolved + " of " + expected + "; "
    EndIf
    return ""
EndFunction

Function IEB_QIWriteProbe(String f)
    {Patch, test builds only (write_probe = 1): PapyrusUtil writes known forms itself (test Q-9), so its exact
     form-string spelling can be compared with the builder's; also logs whether each form matches the list.}
    String p = "../ErrandBridge/qi_probe"
    JsonUtil.FormListClear(p, "probe")
    Int n = JsonUtil.StringListCount(f, "probe_plugins")
    Int i = 0
    While i < n
        Form fm = Game.GetFormFromFile(JsonUtil.IntListGet(f, "probe_ids", i), JsonUtil.StringListGet(f, "probe_plugins", i))
        JsonUtil.FormListAdd(p, "probe", fm)
        Debug.Trace("[IEB] quest_integrity probe " + i + ": resolved " + (fm != None) + ", in " + JsonUtil.StringListGet(f, "probe_lists", i) + " " + JsonUtil.FormListHas(f, JsonUtil.StringListGet(f, "probe_lists", i), fm))
        i += 1
    EndWhile
    JsonUtil.Save(p)
    Debug.Trace("[IEB] quest_integrity probe written: " + n + " forms")
EndFunction
""")

elif G == "e7-narrow":   # [CHANGED in build, Shae 2026-10-09] essential/protected leaders get the attempt and survive
    edit("IntelEngine_Battle.psc", [(
"""        ; Patch E7 (quest integrity): never target an actor blocked at tier 2; abort like a missing target
        If Core.StoryEngine.IEB_StoryBlocked(assTarget, 2)
""",
"""        ; Patch E7 (quest integrity): cancel only if busy, committed right now, or able to die and statically
        ; reserved. The attack is ordinary combat, so essential and protected leaders get the attempt and survive.
        If Core.StoryEngine.IEB_AssassinationBlocked(assTarget)
""")])
    append("IntelEngine_StoryEngine.psc", """
Bool Function IEB_AssassinationBlocked(Actor a)
    {Patch E7 (Shae 2026-10-09): IntelEngine's assassination is plain combat (StartCombat; no Kill or flag change),
     so essential and protected targets survive it. Cancel only for busy targets, targets a running questline is
     using now (tier 1), or targets that could die and are in reserved_npcs.}
    If a == None
        return false
    EndIf
    If IEB_DispatchBlocked(a) || IEB_QuestReserved(a, 1)
        return true
    EndIf
    ActorBase b = a.GetActorBase()
    If a.IsEssential() || b.IsEssential() || b.IsProtected()
        return false
    EndIf
    return JsonUtil.FormListHas(IEB_QIFile(), "reserved_npcs", b)
EndFunction
""")

else:
    raise SystemExit("unknown group " + G)
print("applied", G)
