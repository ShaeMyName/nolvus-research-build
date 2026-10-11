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

Function DashCancel(Int aiFormId)
    {REVIEW_LOG RV-72-upd: cancel exactly as the IntelEngine dashboard does (mod event, slot in numArg -> Core
     OnDashboardCancelTask -> ClearSlotRestoreFollower, no MarkSlotProcessing first = the R54 teardown path).}
    Actor a = A(aiFormId)
    If a == None
        Log("DASHCANCEL none")
        Return
    EndIf
    Int slot = IEB_IELib.SlotOf(a)
    Log("DASHCANCEL " + a.GetDisplayName() + " slot=" + slot)
    If slot >= 0
        SendModEvent("IntelEngine_DashboardCancelTask", "", slot as Float)
    EndIf
EndFunction

Function ReserveProbe()
    {REVIEW_LOG RV-72-upd: does the §2 reservation work on this build? Reserve a slot, read its stamp, check that the
     non-reserving FindFreeAgentSlot skips it, release it, read again. Uses a free slot only; nothing is allocated.}
    IntelEngine_Core core = IEB_IELib.IEQuest() as IntelEngine_Core
    If core == None
        Log("RESERVEPROBE none")
        Return
    EndIf
    Int r = core.ReserveFreeAgentSlot()
    If r < 0
        Log("RESERVEPROBE reserve=-1 (no free slot or max tasks reached)")
        Return
    EndIf
    Float age = core.IEB_ReservedAge(r)
    Int f = core.FindFreeAgentSlot()
    core.ReleaseSlotReservation(r)
    Float after = core.IEB_ReservedAge(r)
    Log("RESERVEPROBE reserved=" + r + " age=" + age + " find=" + f + " skipped=" + (f != r) + " afterRelease=" + after)
EndFunction

Function PlayerWhere()
    {REVIEW_LOG RV-79-upd: the player's cell, worldspace and position (location control for the crash repro).}
    Actor p = Game.GetPlayer()
    Cell c = p.GetParentCell()
    Log("PLAYERPOS cell=" + Watcher().Hex(c) + " ws=" + Watcher().Hex(p.GetWorldSpace()) + " x=" + p.GetPositionX() \
        + " y=" + p.GetPositionY() + " z=" + p.GetPositionZ())
EndFunction

Function CrashCtx(Int aiFormId)
    {REVIEW_LOG RV-82: in-game time (packages are scheduled) plus one actor's current package and 3D state.
     hour = GameHour, days = GameDaysPassed (day of week derived offline).}
    GlobalVariable hr = Game.GetFormFromFile(0x38, "Skyrim.esm") as GlobalVariable
    GlobalVariable dp = Game.GetFormFromFile(0x39, "Skyrim.esm") as GlobalVariable
    Actor a = Game.GetForm(aiFormId) as Actor
    String s = "CRASHCTX hour=" + hr.GetValue() + " days=" + dp.GetValue()
    If a
        s += " actor=" + a.GetDisplayName() + " pkg=" + Watcher().Hex(a.GetCurrentPackage()) + " loaded=" + a.Is3DLoaded() \
            + " cell=" + Watcher().Hex(a.GetParentCell())
    Else
        s += " actor=none"
    EndIf
    Log(s)
EndFunction

Function SetHour(Float afHour, Int aiFormId)
    {REVIEW_LOG RV-82: match R1's in-game hour (same as console set gamehour), then log CrashCtx.}
    (Game.GetFormFromFile(0x38, "Skyrim.esm") as GlobalVariable).SetValue(afHour)
    Utility.Wait(2.0)
    CrashCtx(aiFormId)
EndFunction

Function EquipFromList(Int aiListId, String asPlugin, Int aiIndex)
    {U2 WE-7: give the player the aiIndex-th form of a FormList (e.g. SceneControls IEB_MinimalBody 0x810, seeded at
     runtime from verified Divine Elegance pieces) and equip it. Logs the form, never its name.}
    FormList fl = Game.GetFormFromFile(aiListId, asPlugin) as FormList
    If fl == None || aiIndex >= fl.GetSize()
        Log("EquipFromList: no list or index out of range")
        Return
    EndIf
    Form f = fl.GetAt(aiIndex)
    Actor p = Game.GetPlayer()
    If p.GetItemCount(f) < 1
        p.AddItem(f, 1, True)
    EndIf
    p.EquipItem(f, False, True)
    Utility.Wait(1.0)
    Log("EQUIPLIST " + Watcher().Hex(f) + " size=" + fl.GetSize() + " worn=" + p.IsEquipped(f))
EndFunction

Function Whisper(Int aiOn)
    {U2 W-3 / WH-6: set SkyrimNet's whisper mode like the player's hotkey (TriggerToggleWhisperMode only when it differs).
     IEB_SceneMain reads an outside toggle as a manual override and does not fight it until the next location change.}
    Float cur = SkyrimNetApi.GetConfigFloat("game", "interaction.maxDistance", -1.0)
    Float w = SkyrimNetApi.GetConfigFloat("game", "interaction.whisperMaxDistance", -2.0)
    Bool isOn = cur == w
    If isOn != (aiOn == 1)
        SkyrimNetApi.TriggerToggleWhisperMode()
        Utility.Wait(1.0)
        cur = SkyrimNetApi.GetConfigFloat("game", "interaction.maxDistance", -1.0)
    EndIf
    Log("WHISPERSET want=" + aiOn + " maxDistance=" + cur + " whisperMax=" + w)
EndFunction

Function BodySwap()
    {U2 WE-8: unequip the player's body item and re-equip it within ~0.3 s (outfit swap; the emitter debounces 1 s).}
    Actor p = Game.GetPlayer()
    Form b = p.GetWornForm(0x00000004)
    If b == None
        Log("BODYSWAP none")
        Return
    EndIf
    p.UnequipItem(b, False, True)
    Utility.Wait(0.3)
    p.EquipItem(b, False, True)
    Utility.Wait(0.5)
    Log("BODYSWAP " + Watcher().Hex(b) + " worn=" + p.IsEquipped(b))
EndFunction

Function OwnNearestFurniture(Float afRadius)
    {U2 WH-2/WH-3/PV-1/PV-3: stand-in for renting a room (spec §11.9 rule ii): the nearest furniture ref within afRadius of the
     player becomes owned by the player (SetActorOwner on the player's base). FURN form type 40 as in SitNearest.
     Logs OWNFURN <ref> d=<dist> pos=x,y,z (or OWNFURN none). Undone by the test's reload of the save.}
    Actor pl = Game.GetPlayer()
    ObjectReference[] refs = PO3_SKSEFunctions.FindAllReferencesOfFormType(pl, 40, afRadius)
    ObjectReference best = None
    Float bestD = 1000000.0
    Int i = 0
    While i < refs.Length
        If refs[i] != None && !refs[i].IsDisabled() && pl.GetDistance(refs[i]) < bestD
            best = refs[i]
            bestD = pl.GetDistance(refs[i])
        EndIf
        i += 1
    EndWhile
    If best == None
        Log("OWNFURN none")
        Return
    EndIf
    best.SetActorOwner(pl.GetActorBase())
    Log("OWNFURN " + Watcher().Hex(best) + " d=" + (bestD as Int) + " pos=" + (best.GetPositionX() as Int) + "," + (best.GetPositionY() as Int) + "," + (best.GetPositionZ() as Int))
EndFunction

Function CountNearNPCs(Float afRadius, Int aiExcludeFormId)
    {U2 WH/PV self-checks: the count IEB_SceneMain.CountOthers makes (live, enabled ActorTypeNPC within afRadius, not the player,
     not a scene partner), also excluding aiExcludeFormId (0 = none). Logs NEARNPC n=<count> r=<radius>.}
    Actor pl = Game.GetPlayer()
    ObjectReference[] refs = PO3_SKSEFunctions.FindAllReferencesOfFormType(pl, 43, afRadius)
    Keyword kw = Game.GetFormFromFile(0x00013794, "Skyrim.esm") as Keyword
    Int n = 0
    Int i = 0
    While i < refs.Length
        Actor a = refs[i] as Actor
        If a != None && a != pl && !a.IsDead() && !a.IsDisabled() && a.HasKeyword(kw)
            If StorageUtil.GetIntValue(a, "IEB_IsScenePartner", 0) != 1 && a.GetFormID() != aiExcludeFormId
                n += 1
            EndIf
        EndIf
        i += 1
    EndWhile
    Log("NEARNPC n=" + n + " r=" + (afRadius as Int))
EndFunction

Function PkgWatch(Int aiFormId)
    {B-22 (R36-upd (c)): put the actor in IEB_TestPkgQuest's package-free alias, whose IEB_PkgWatch script logs PKGEVT lines.}
    Actor a = A(aiFormId)
    Quest q = Game.GetFormFromFile(0x840, "ErrandBridgeTest.esp") as Quest
    If a == None || q == None
        Log("PKGWATCH none")
        Return
    EndIf
    (q.GetAlias(0) as ReferenceAlias).ForceRefTo(a)
    Log("PKGWATCH on " + Watcher().Hex(a) + " pkg=" + Watcher().Hex(a.GetCurrentPackage()))
EndFunction

Function PkgUnwatch()
    Quest q = Game.GetFormFromFile(0x840, "ErrandBridgeTest.esp") as Quest
    If q != None
        (q.GetAlias(0) as ReferenceAlias).Clear()
    EndIf
    Log("PKGWATCH off")
EndFunction

; --- T0-M builder (build_t0m.py; investigation/round10/t0m_builder.md). Numbers only, never names.

Int Function MarasFR(Actor a, Int aiFactionId, String asPlugin)
    {Faction rank of a in a plugin's faction: -2 = not a member, -3 = faction missing.}
    Faction f = Game.GetFormFromFile(aiFactionId, asPlugin) as Faction
    If f == None
        Return -3
    EndIf
    Return a.GetFactionRank(f)
EndFunction

Function MarasSet(Int aiFormId, Int aiStatus)
    {T0-M: one MARAS status change through MARAS's own natives (MARAS.psc:13, 54): 0 = RegisterCandidate,
     1..4 = PromoteNPCToStatusByEnum (engaged, married, divorced, jilted). The dialogue fragments make the same native
     call (TTM_DialogueManagerMisc.psc:14-23). Logs T0M_SET <actor> want=<n> ok=<0|1> st=<status enum after>.}
    Actor a = A(aiFormId)
    If a == None
        Log("T0M_SET none " + PO3_SKSEFunctions.IntToString(aiFormId, True))
        Return
    EndIf
    Bool ok = False
    If aiStatus == 0
        ok = MARAS.RegisterCandidate(a)
    Else
        ok = MARAS.PromoteNPCToStatusByEnum(a, aiStatus)
    EndIf
    Log("T0M_SET " + Watcher().Hex(a) + " want=" + aiStatus + " ok=" + (ok as Int) + " st=" + MARAS.GetNpcStatusEnum(a))
EndFunction

Function MarasHouse(Int aiFormId, Int aiLocationId)
    {T0-M: house a spouse in a registered player house. The steps of MARAS's TTM_ServicePlayerHouse.MoveSpouseToHouse
     (TTM_ServicePlayerHouse.psc:107-117) with TTM_ServiceRelationships.GetTrackedNpcHomeMarker (:184-197) inlined, as
     natives + StorageUtil only (no TTM_ script is compiled in). Refuses when the house has no MARAS marker yet.
     Logs T0M_HOUSE <actor> ok=<0|1> house=<location> marker=<ref>.}
    Actor a = A(aiFormId)
    Location home = Game.GetForm(aiLocationId) as Location
    If a == None || home == None
        Log("T0M_HOUSE none " + PO3_SKSEFunctions.IntToString(aiFormId, True))
        Return
    EndIf
    ObjectReference houseMarker = MARAS.GetHouseMarker(home)
    If houseMarker == None
        Log("T0M_HOUSE " + Watcher().Hex(a) + " ok=0 house=None marker=None why=house_not_registered")
        Return
    EndIf
    ObjectReference m = MARAS.GetTrackedNpcHomeMarker(a)
    If m == None
        m = StorageUtil.GetFormValue(a, "HomeMarker") as ObjectReference
        If m == None
            m = a.PlaceAtMe(Game.GetFormFromFile(0x76, "TT_MARAS.esp"), 1, True)
        EndIf
        MARAS.SetTrackedNpcHomeMarker(a, m)
    EndIf
    m.MoveTo(houseMarker)
    StorageUtil.SetFormValue(a, "HomeLocation", home)
    Bool ok = MARAS.RegisterTenantInPlayerHouse(a, home)
    Log("T0M_HOUSE " + Watcher().Hex(a) + " ok=" + (ok as Int) + " house=" + Watcher().Hex(MARAS.GetTenantHouse(a)) + " marker=" + Watcher().Hex(m))
EndFunction

Function MarasProbe(Int aiFormId)
    {T0-M read-back for one actor: MARAS status enum (-1 unregistered), rank to the player, faction ranks (TT_MARAS
     tracked 0x7 and housed 0x6C; Skyrim.esm PlayerMarriedFaction 0xC6472, PlayerFaction 0xDB1, PlayerBedOwnership
     0xF2073, PotentialMarriageFaction 0x19809, MarriageAskedFaction 0xFF7F3, MarriageCourtingFaction 0x7431A,
     CurrentFollowerFaction 0x5C84E), MARAS tenant house, matrimony rings (0xC5809), whether it fills the
     LoveInterest alias of 0x74793, disabled, teammate and cell. Logs one T0M_PROBE line.}
    Actor a = A(aiFormId)
    If a == None
        Log("T0M_PROBE none " + PO3_SKSEFunctions.IntToString(aiFormId, True))
        Return
    EndIf
    Actor pl = Game.GetPlayer()
    Quest mq = Game.GetFormFromFile(0x74793, "Skyrim.esm") as Quest
    Actor li = None
    If mq != None
        ReferenceAlias ra = mq.GetAliasByName("LoveInterest") as ReferenceAlias
        If ra != None
            li = ra.GetActorReference()
        EndIf
    EndIf
    Form ringForm = Game.GetFormFromFile(0xC5809, "Skyrim.esm")
    String s = "T0M_PROBE " + Watcher().Hex(a) + " st=" + MARAS.GetNpcStatusEnum(a) + " r=" + a.GetRelationshipRank(pl)
    s += " trk=" + MarasFR(a, 0x7, "TT_MARAS.esp") + " housed=" + MarasFR(a, 0x6C, "TT_MARAS.esp")
    s += " pmf=" + MarasFR(a, 0xC6472, "Skyrim.esm") + " pf=" + MarasFR(a, 0xDB1, "Skyrim.esm") + " bed=" + MarasFR(a, 0xF2073, "Skyrim.esm")
    s += " pot=" + MarasFR(a, 0x19809, "Skyrim.esm") + " ask=" + MarasFR(a, 0xFF7F3, "Skyrim.esm") + " crt=" + MarasFR(a, 0x7431A, "Skyrim.esm")
    s += " cfol=" + MarasFR(a, 0x5C84E, "Skyrim.esm") + " house=" + Watcher().Hex(MARAS.GetTenantHouse(a)) + " rings=" + a.GetItemCount(ringForm)
    s += " lia=" + ((li == a) as Int) + " dis=" + (a.IsDisabled() as Int) + " tm=" + (a.IsPlayerTeammate() as Int) + " cell=" + Watcher().Hex(a.GetParentCell())
    Log(s)
EndFunction

Function MarasWorld()
    {T0-M read-back for the world: polygamy global (TT_MARAS 0x6), MARAS counts by status, registered player houses and
     Breezehome's (location 0x1F86F) MARAS marker, MARAS's SkipWedding/PlayerHadWedding StorageUtil flags
     (TTM_Data.psc:11-13, 47-48, 67-68), the player's PlayerMarriedFaction rank, 0x74793's stage, the house purchase
     (0xA7B33 WhiterunHouseVar, key 0x93B08, cell 0x165A8 owner faction), 0xA2C9E stages 25/200, housecarl ref
     0xA2C94 disabled, gold, the player's location. Logs one T0M_WORLD line.}
    Actor pl = Game.GetPlayer()
    GlobalVariable poly = Game.GetFormFromFile(0x6, "TT_MARAS.esp") as GlobalVariable
    Quest mq = Game.GetFormFromFile(0x74793, "Skyrim.esm") as Quest
    Quest hp = Game.GetFormFromFile(0xA7B33, "Skyrim.esm") as Quest
    Quest fq = Game.GetFormFromFile(0xA2C9E, "Skyrim.esm") as Quest
    Cell bz = Game.GetFormFromFile(0x165A8, "Skyrim.esm") as Cell
    Location bzl = Game.GetFormFromFile(0x1F86F, "Skyrim.esm") as Location
    Actor hc = Game.GetFormFromFile(0xA2C94, "Skyrim.esm") as Actor
    Faction pmf = Game.GetFormFromFile(0xC6472, "Skyrim.esm") as Faction
    Int polyV = -1
    If poly != None
        polyV = poly.GetValue() as Int
    EndIf
    Int hv = -1
    HousePurchaseScript hps = hp as HousePurchaseScript
    If hps != None
        hv = hps.WhiterunHouseVar
    EndIf
    String s = "T0M_WORLD poly=" + polyV + " nMar=" + MARAS.GetStatusCountByEnum(2) + " nEng=" + MARAS.GetStatusCountByEnum(1)
    s += " nAll=" + MARAS.GetStatusCountByEnum(-1) + " houses=" + MARAS.CountPlayerHouses() + " bzMarker=" + Watcher().Hex(MARAS.GetHouseMarker(bzl))
    s += " skipWed=" + StorageUtil.GetIntValue(None, "SkipWedding", 0) + " hadWed=" + StorageUtil.GetIntValue(None, "PlayerHadWedding", 0)
    s += " plPmf=" + pl.GetFactionRank(pmf) + " mqStage=" + mq.GetCurrentStageID() + " mqRun=" + (mq.IsRunning() as Int)
    s += " hpVar=" + hv + " key=" + pl.GetItemCount(Game.GetFormFromFile(0x93B08, "Skyrim.esm")) + " own=" + Watcher().Hex(bz.GetFactionOwner())
    s += " f25=" + (fq.GetStageDone(25) as Int) + " f200=" + (fq.GetStageDone(200) as Int) + " hcDis=" + (hc.IsDisabled() as Int)
    s += " gold=" + pl.GetGoldAmount() + " loc=" + Watcher().Hex(pl.GetCurrentLocation()) + " cell=" + Watcher().Hex(pl.GetParentCell())
    Log(s)
EndFunction

Function PlayerPlace(Float afX, Float afY, Float afZ)
    {REVIEW_LOG RV-79-upd: put the player at a position in the current (exterior) worldspace, then log it.}
    Game.GetPlayer().SetPosition(afX, afY, afZ)
    Utility.Wait(2.0)
    PlayerWhere()
EndFunction

Function HeadStartOp(Int aiFormId, String asOp, Int aiN)
    {REVIEW_LOG RV-69-dec / RV-77 tests (throwaway test save only): one Relationships action on an actor, then her
     numbers. ops: reset (unenrol + clear the latch, points, bank), unenroll (latch kept), byhand, courtship (M4' entry), beginspark,
     moment (MarkMoment aiN), setpts (aiN, test-only direct write), luc (player LUC_Active = aiN). Numbers only.}
    Actor a = A(aiFormId)
    SNRom_Bridge b = Game.GetFormFromFile(0x00000D62, "SNRom_Integration.esl") as SNRom_Bridge
    If a == None || b == None
        Log("HSOP none")
        Return
    EndIf
    String r = ""
    If asOp == "reset"
        If SNRom_Bridge.IsEnrolled(a)
            b.UnenrollActor(a)
        EndIf
        StorageUtil.UnsetIntValue(a, "IEB_HeadStartUsed")
        StorageUtil.UnsetIntValue(a, "SNRom_BankedPoints")
        b.StorePoints(a, 0)
    ElseIf asOp == "unenroll"
        If SNRom_Bridge.IsEnrolled(a)
            b.UnenrollActor(a)
        EndIf
    ElseIf asOp == "byhand"
        r = b.EnrollByHand(a)
    ElseIf asOp == "courtship"
        r = "" + b.IEB_EnrollOnCourtship(a)
    ElseIf asOp == "beginspark"
        b.BeginSpark(a, "harness head-start test")
    ElseIf asOp == "moment"
        b.MarkMoment(a, aiN, "harness head-start test", "test")
    ElseIf asOp == "setpts"
        b.StorePoints(a, aiN)
    ElseIf asOp == "luc"
        StorageUtil.SetIntValue(Game.GetPlayer(), "LUC_Active", aiN)
    EndIf
    Log("HSOP " + Watcher().Hex(a) + " op=" + asOp + " n=" + aiN + " r=" + r + " enrolled=" + (SNRom_Bridge.IsEnrolled(a) as Int) \
        + " pts=" + SNRom_Bridge.PointsOf(a) + " bank=" + StorageUtil.GetIntValue(a, "SNRom_BankedPoints", 0) \
        + " latch=" + StorageUtil.GetIntValue(a, "IEB_HeadStartUsed", 0) + " luc=" \
        + StorageUtil.GetIntValue(Game.GetPlayer(), "LUC_Active", 0))
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

Function NFFGuardOn(Int aiFormId)
    {B-6b (REVIEW_LOG RV-66): make F an NFF hired guard so RemoveFollower routes to DismissGuardAction
     (nwsFollowerControllerScript.psc:529-530; a real hire adds nwsFF_GuardFaction at :1056). Undone by the T0 reload.}
    Actor a = A(aiFormId)
    nwsFollowerControllerScript c = IEB_NFFLib.Ctl()
    If a == None || c == None || c.varScript == None
        Log("NFFGuardOn: no actor or no NFF controller")
        Return
    EndIf
    a.AddToFaction(c.varScript.nwsFF_GuardFaction)
    Log("NFFGuardOn " + a.GetDisplayName() + " guard=" + a.IsInFaction(c.varScript.nwsFF_GuardFaction) + " seated=" + IEB_NFFLib.Seated(a))
EndFunction

Function NFFStaleFac(Int aiFormId, Int aiOn)
    {B-6c (REVIEW_LOG RV-66): put F in (1) or take F out of (0) the DismissedFac the bridge reads (IEB_NFFLib.DismissedFac),
     the stale state an import can leave (ImportAction never clears it; RecruitAction :387 does).}
    Actor a = A(aiFormId)
    Faction f = IEB_NFFLib.DismissedFac()
    If a == None || f == None
        Log("NFFStaleFac: no actor or no DismissedFac")
        Return
    EndIf
    If aiOn == 1
        a.AddToFaction(f)
    Else
        a.RemoveFromFaction(f)
    EndIf
    Log("NFFStaleFac " + a.GetDisplayName() + " on=" + aiOn + " inFac=" + a.IsInFaction(f) + " source=" + IEB_NFFLib.DismissedFacSource())
EndFunction

Function NFFImport(Int aiFormId)
    {B-6d (REVIEW_LOG RV-66): NFF's own import of F (ImportFollower -> ImportAction(a, 1, 2), :655-659); a later
     RemoveFollower then routes to ExportAction (:527-528).}
    Actor a = A(aiFormId)
    nwsFollowerControllerScript c = IEB_NFFLib.Ctl()
    If a == None || c == None
        Log("NFFImport: no actor or no NFF controller")
        Return
    EndIf
    c.ImportFollower(a)
    Log("NFFImport " + a.GetDisplayName() + " seated=" + IEB_NFFLib.Seated(a))
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

Function ScheduleFetch(Int aiFormId, String asTarget, String asWhen)
    {NT-4: IntelEngine_Schedule.ScheduleFetch(npc, targetName, timeCondition) (Schedule.psc:194).}
    Actor a = A(aiFormId)
    IntelEngine_Core core = IEB_IELib.IEQuest() as IntelEngine_Core
    If a == None || core == None || core.Schedule == None
        Log("ScheduleFetch: no actor or no IE Schedule")
        Return
    EndIf
    Bool ok = core.Schedule.ScheduleFetch(a, asTarget, asWhen)
    Log("ScheduleFetch " + a.GetDisplayName() + " when=" + asWhen + " ok=" + ok)
EndFunction

Function ScheduleDelivery(Int aiFormId, String asTarget, String asMsg, String asWhen)
    {NT-4: IntelEngine_Schedule.ScheduleDelivery(npc, targetName, msgContent, timeCondition) (Schedule.psc:224).}
    Actor a = A(aiFormId)
    IntelEngine_Core core = IEB_IELib.IEQuest() as IntelEngine_Core
    If a == None || core == None || core.Schedule == None
        Log("ScheduleDelivery: no actor or no IE Schedule")
        Return
    EndIf
    Bool ok = core.Schedule.ScheduleDelivery(a, asTarget, asMsg, asWhen)
    Log("ScheduleDelivery " + a.GetDisplayName() + " when=" + asWhen + " ok=" + ok)
EndFunction

Function EssProbe(Int aiFormId)
    {REVIEW_LOG RV-95 (3a+3b smoke): the actor's base essential/protected flags and which IEB_Ess* keys exist (values of
     the int keys; -1 = key absent). Mechanics only.}
    Actor a = A(aiFormId)
    If a == None
        Log("ESSPROBE none")
        Return
    EndIf
    ActorBase b = a.GetActorBase()
    String k = ""
    String[] keys = new String[6]
    keys[0] = "IEB_Ess"
    keys[1] = "IEB_EssAuth"
    keys[2] = "IEB_EssReq"
    keys[3] = "IEB_EssImp"
    keys[4] = "IEB_EssIEHeld"
    keys[5] = "IEB_EssKeep"
    Int i = 0
    While i < keys.Length
        If StorageUtil.HasIntValue(a, keys[i])
            k += " " + keys[i] + "=" + StorageUtil.GetIntValue(a, keys[i])
        Else
            k += " " + keys[i] + "=-1"
        EndIf
        i += 1
    EndWhile
    Log("ESSPROBE " + Watcher().Hex(a) + " baseEss=" + b.IsEssential() + " baseProt=" + b.IsProtected() + k)
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
        Log("SneakRun: no actor")             ; consumer proof (c): no silent return
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

Function HoldIEAlias(Int aiFormId)
    {RV-68 refusal test (IE-R1): put an actor into the first FREE IntelEngine agent alias (SlotStates 0, the slot
     ReserveFreeAgentSlot will pick next), so TryAllocateSlot refuses that slot (SLOT_REFUSED reason=held). Logs the slot.
     Undo with ReleaseIEAlias(slot).}
    Actor a = A(aiFormId)
    IntelEngine_Core core = IEB_IELib.IEQuest() as IntelEngine_Core
    If a == None || core == None
        Log("HoldIEAlias: no actor or no IE Core")
        Return
    EndIf
    Int slot = core.FindFreeAgentSlot()
    ReferenceAlias ra = None
    If slot >= 0
        ra = core.GetAgentAlias(slot)
    EndIf
    If ra == None
        Log("HoldIEAlias: no free slot or no alias")
        Return
    EndIf
    ra.ForceRefTo(a)
    Log("HoldIEAlias slot=" + slot + " holder=" + Watcher().Hex(a))
EndFunction

Function ReleaseIEAlias(Int aiSlot)
    {Clear the alias HoldIEAlias filled (only when the slot is not in use: SlotStates 0).}
    IntelEngine_Core core = IEB_IELib.IEQuest() as IntelEngine_Core
    If core == None || aiSlot < 0 || aiSlot >= 5
        Log("ReleaseIEAlias: no IE Core or bad slot")
        Return
    EndIf
    ReferenceAlias ra = core.GetAgentAlias(aiSlot)
    If ra != None && core.SlotStates[aiSlot] == 0
        ra.Clear()
    EndIf
    Log("ReleaseIEAlias slot=" + aiSlot + " state=" + core.SlotStates[aiSlot])
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

Function SUStrLen(Int aiFormId, String asKey)
    {U2 IP family: the LENGTH of a StorageUtil string on the actor (e.g. the IEB_IntimacyProfile mirror). Never its text.}
    Actor a = A(aiFormId)
    If a == None
        Log("SUSTRLEN none " + asKey + " len=-1")
        Return
    EndIf
    Log("SUSTRLEN " + Watcher().Hex(a) + " " + asKey + " len=" + StringUtil.GetLength(StorageUtil.GetStringValue(a, asKey, "")))
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

Function SaveNamed(String asSave)
    {REVIEW_LOG R29: save through Papyrus (Game.SaveGame), not the MCP console. Log FIRST, the save LAST: a save captures
     the stack, so anything after SaveGame would run again after a load of this save (seen with KillAndSave, run 18
     L-9). Completion is confirmed by the host on the .ess file (game.save), never by a log line.}
    Log("SAVENAMED " + asSave)
    Game.SaveGame(asSave)
EndFunction

Function KillUnattributed(Int aiFormId)
    {B-8 (reviewer): kill a follower without naming the player as killer (a player-attributed murder next to guards is
     a bounty and an arrest). Clears protected/essential on the base first (undone by B-8's reload of T0).}
    Actor a = A(aiFormId)
    If a == None
        Log("KILLUNATTR none")
        Return
    EndIf
    ActorBase b = a.GetActorBase()
    b.SetProtected(False)
    b.SetEssential(False)
    a.Kill(None)
    Utility.Wait(1.0)
    Log("KILLUNATTR " + Watcher().Hex(a) + " dead=" + a.IsDead())
EndFunction

Function CrimeProbe()
    {Player defeat trace (REVIEW_LOG R44): crime gold the player owes Whiterun's crime faction and the current hold's
     faction. FormIDs: CrimeFactionWhiterun 0x000267EA (Skyrim.esm, INFERRED; the line prints what it read).}
    Actor p = Game.GetPlayer()
    Faction wr = Game.GetFormFromFile(0x000267EA, "Skyrim.esm") as Faction
    Int g = -1
    Int gv = -1
    If wr != None
        g = wr.GetCrimeGold()
        gv = wr.GetCrimeGoldViolent()
    EndIf
    Faction cur = p.GetCrimeFaction()
    Int cg = -1
    If cur != None
        cg = cur.GetCrimeGold()
    EndIf
    Log("CRIMEPROBE whiterun=" + g + " violent=" + gv + " curFaction=" + Watcher().Hex(cur) + " curGold=" + cg)
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

Function AutoSaveNow()
    {REVIEW_LOG RV-67-upd2: the autosave route (real play makes many: cell change, sleep, wait, travel). Logs first,
     the request last (as SaveNamed); completion is judged by the host on the file, never on this line.}
    Log("AUTOSAVE requested")
    Game.RequestAutoSave()
EndFunction

Function HeldProbe(Int aiFormId)
    {REVIEW_LOG RV-67-upd2 (5): after loading a mid-errand save, is the errand still there? IE slot index (-1 = none),
     the live task type, and the bridge's own hold state.}
    Actor a = A(aiFormId)
    If a == None
        Log("HELDPROBE none")
        Return
    EndIf
    ; REVIEW_LOG RV-70 (a): the raw parts of DecisionTaskType, to tell which one reads blank
    Int slot = IEB_IELib.SlotOf(a)
    String raw = " ieType=" + StorageUtil.GetStringValue(a, "Intel_TaskType", "")
    IntelEngine_Core core = IEB_IELib.IEQuest() as IntelEngine_Core
    ; REVIEW_LOG RV-72 (a): no array-vs-None compare (fails in the VM); local copies + If arr
    If core != None && slot >= 0
        Int[] st = core.SlotStates
        String[] ty = core.SlotTaskTypes
        If st && ty && slot < st.Length && slot < ty.Length
            raw += " slotState=" + st[slot] + " slotType=" + ty[slot]
        Else
            raw += " slotArrays=none"
        EndIf
    EndIf
    Log("HELDPROBE " + a.GetDisplayName() + " slot=" + slot + " type=" + IEB_IELib.DecisionTaskType(a) + raw \
        + " held=" + StorageUtil.GetIntValue(a, "IEB_Held", 0) + " mode=" + StorageUtil.GetIntValue(a, "IEB_Mode", 0) \
        + " wfp=" + a.GetActorValue("WaitingForPlayer") + " tm=" + a.IsPlayerTeammate())
EndFunction

Function SlotsProbe()
    {REVIEW_LOG RV-70 (c): every IntelEngine slot right now (is T0 clean?). RV-72: also the §2 reservation stamp
     (res = real-time age in s of the stamp via Core.IEB_ReservedAge, -1 = none, "na" = no stamp array) and the agent's Intel_TaskType key.}
    IntelEngine_Core core = IEB_IELib.IEQuest() as IntelEngine_Core
    If core == None
        Log("SLOTSPROBE none")
        Return
    EndIf
    Int[] st = core.SlotStates
    String[] ty = core.SlotTaskTypes
    If !st || !ty
        Log("SLOTSPROBE none")
        Return
    EndIf
    String out = ""
    Int i = 0
    While i < st.Length
        Float age = core.IEB_ReservedAge(i)
        String r = "" + age
        If age <= -2.0
            r = "na"
        ElseIf age < 0.0
            r = "-1"
        EndIf
        String key = "-"
        ReferenceAlias al = core.GetAgentAlias(i)
        If al && al.GetActorReference()
            key = StorageUtil.GetStringValue(al.GetActorReference(), "Intel_TaskType", "")
        EndIf
        String t = ""
        If i < ty.Length
            t = ty[i]
        EndIf
        out += " [" + i + " state=" + st[i] + " type=" + t + " key=" + key + " res=" + r + "]"
        i += 1
    EndWhile
    Log("SLOTSPROBE" + out)
EndFunction

Function MenuProbe()
    {REVIEW_LOG RV-67: which menus are open right before a test save (the Timeline Mismatch box was suspected in R29 c7).
     A paused menu may stop Papyrus entirely: the host then logs "no MENUPROBE line", which is itself the signal.}
    Log("MENUPROBE inMenuMode=" + Utility.IsInMenuMode() + " console=" + UI.IsMenuOpen("Console") + " msgbox="         + UI.IsMenuOpen("MessageBoxMenu") + " dialogue=" + UI.IsMenuOpen("Dialogue Menu") + " journal="         + UI.IsMenuOpen("Journal Menu") + " loading=" + UI.IsMenuOpen("Loading Menu") + " mainmenu="         + UI.IsMenuOpen("Main Menu") + " custom=" + UI.IsMenuOpen("CustomMenu") + " tween=" + UI.IsMenuOpen("TweenMenu"))
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
