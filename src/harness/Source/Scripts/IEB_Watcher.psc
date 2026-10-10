Scriptname IEB_Watcher extends Quest
{Errand Bridge test harness: the watcher (spec §15.1, v1 §5.2; invariants §14). TEST PROFILE ONLY.
 Every 3 s real time (while ErrandBridgeTest.esp's IEB_TestWatch == 1) it logs one line per watched actor to the user
 log "ErrandBridgeWatch" and asserts what can be sampled in game: I1, I2, I3, I4 (via IEB_TestCtl.Check), I6 and I10 at
 a story dispatch, I9 every 30 s. I5, I7 and I8 are log checks for the host-side runner.
 Watched: every NFF seat, every IntelEngine agent alias occupant, every actor on the bridge's IEB_HeldList.
 The watcher's own keys use the prefix EBT_ so they never count as IEB_* keys (I2, I4).}

Int _tick
Float _lastRT
Int _fails

; ============================================================================ loop

Event OnInit()
    RegisterForSingleUpdate(3.0)
EndEvent

Event OnUpdate()
    RegisterForSingleUpdate(3.0)             ; booked first
    Float now = Utility.GetCurrentRealTime()
    If now < _lastRT || _tick == 0
        Debug.OpenUserLog("ErrandBridgeWatch")   ; a new game session (real time restarted): reopen the user log
    EndIf
    _lastRT = now
    _tick += 1
    GlobalVariable on = Game.GetFormFromFile(0x801, "ErrandBridgeTest.esp") as GlobalVariable
    If on == None || on.GetValue() < 1.0 || Utility.IsInMenuMode()
        Return
    EndIf
    _fails = 0
    Form[] seen = Watched()
    Int i = 0
    While i < seen.Length
        Actor a = seen[i] as Actor
        If a != None
            W(Line(a))
            DispatchChecks(a)
            Sampled(a)
        EndIf
        i += 1
    EndWhile
    If _tick % 10 == 0
        ChildGuards()
    EndIf
    StorageUtil.SetIntValue(None, "EBT_LastFails", _fails)
EndEvent

Form[] Function Watched()
    Form[] out = new Form[64]
    Int n = 0
    Actor[] seats = IEB_NFFLib.SeatedActors()
    Int i = 0
    While i < seats.Length
        n = AddUnique(out, n, seats[i])
        i += 1
    EndWhile
    ReferenceAlias[] al = IEB_IELib.AgentAliases()
    i = 0
    While i < al.Length
        If al[i] != None
            n = AddUnique(out, n, al[i].GetActorReference())
        EndIf
        i += 1
    EndWhile
    Int h = StorageUtil.FormListCount(None, "IEB_HeldList")
    i = 0
    While i < h
        n = AddUnique(out, n, StorageUtil.FormListGet(None, "IEB_HeldList", i))
        i += 1
    EndWhile
    Return out
EndFunction

Int Function AddUnique(Form[] arr, Int n, Form f)
    If f == None || n >= arr.Length || arr.Find(f) >= 0
        Return n
    EndIf
    arr[n] = f
    Return n + 1
EndFunction

; ============================================================================ the per-actor line (§15.1 + v1 §5.2)

String Function Line(Actor a)
    Actor pl = Game.GetPlayer()
    Cell c = a.GetParentCell()
    String cell = "None"
    If c != None
        cell = Hex(c) + ":" + c.GetName() + ":" + (c.IsInterior() as Int)
    EndIf
    Bool loaded = a.Is3DLoaded()
    String pos = "stale=1"
    If loaded
        pos = (a.GetPositionX() as Int) + "," + (a.GetPositionY() as Int) + "," + (a.GetPositionZ() as Int)
    EndIf
    String dPlayer = "NA"
    If SameSpace(a, pl)
        dPlayer = (a.GetDistance(pl) as Int) as String
    EndIf
    String dDest = "NA"
    Keyword travelKw = Game.GetFormFromFile(0x000D63, "IntelEngine.esp") as Keyword
    If travelKw != None
        ObjectReference dest = a.GetLinkedRef(travelKw)
        If dest != None && loaded && SameSpace(a, dest as Actor)
            dDest = (a.GetDistance(dest) as Int) as String
        ElseIf dest != None
            dDest = "far"
        EndIf
    EndIf
    Package pk = a.GetCurrentPackage()
    String pkg = "None"
    If pk != None
        pkg = Hex(pk) + ":" + PO3_SKSEFunctions.GetFormEditorID(pk)
    EndIf
    Int slot = IEB_IELib.SlotOf(a)
    Int cf = IEB_CFData.IndexOf(a)
    String s = "rt=" + Utility.GetCurrentRealTime() + " gt=" + Utility.GetCurrentGameTime() + " " + a.GetDisplayName() + " " + Hex(a)
    s += " cell=" + cell + " loaded=" + (loaded as Int) + " pos=" + pos + " dPlayer=" + dPlayer + " dDest=" + dDest
    s += " tm=" + (a.IsPlayerTeammate() as Int) + " wfp=" + a.GetActorValue("WaitingForPlayer") + " nffSeat=" + SeatOf(a)
    s += " cff=" + a.GetFactionRank(CFF()) + " pkg=" + pkg + " ovr=" + ActorUtil.CountPackageOverride(a)
    s += " ieSlot=" + slot + " slotCount=" + IEB_IELib.SlotCountOf(a, IEB_IELib.AgentAliases())
    s += " ieTask=" + StorageUtil.GetStringValue(a, "Intel_TaskType", "") + " ieRes=" + StorageUtil.GetStringValue(a, "Intel_Result", "")
    s += " ieWasF=" + StorageUtil.GetIntValue(a, "Intel_WasFollower", 0)
    s += " iebHeld=" + StorageUtil.GetIntValue(a, "IEB_Held", 0) + " iebLent=" + StorageUtil.GetIntValue(a, "IEB_Lent", 0)
    s += " iebGate=" + StorageUtil.GetIntValue(a, "IEB_Gate", 0) + " iebMode=" + StorageUtil.GetIntValue(a, "IEB_Mode", 0)
    s += " iebRecall=" + StorageUtil.GetIntValue(a, "IEB_Recall", 0)
    If IEB_SALib.Present()
        s += " saHome=" + ((SeverActionsNative.Native_GetHome(a) != "") as Int) + " saWork=" + ((SeverActionsNative.Native_GetWorkLoc(a) != None) as Int)
        s += " saPlay=" + ((SeverActionsNative.Native_GetPlayLoc(a) != None) as Int)
        s += " schedIdx=" + SeverActionsNativeExt.Native_GetSchedAliasIndex(a, 0) + "/" + SeverActionsNativeExt.Native_GetSchedAliasIndex(a, 1) + "/" + SeverActionsNativeExt.Native_GetSchedAliasIndex(a, 2)
        s += " guardIdx=" + SeverActionsNativeExt.Native_GetGuardAliasIndex(a) + " jailed=" + (SeverActionsNativeExt.Native_Jailed_IsJailed(a) as Int)
        s += " stewardVisit=" + (IEB_SALib.StewardVisit(a) as Int)
    EndIf
    s += " musterAlias=" + StorageUtil.GetIntValue(a, "SeverCamp_MusterAlias", -1)
    s += " cfEntry=" + cf
    If cf >= 0
        s += " cfRecruited=" + (IEB_CFData.Recruited(cf, a) as Int)
        GlobalVariable gw = IEB_CFData.GWait(cf)
        If gw != None
            s += " cfGWait=" + gw.GetValue()
        EndIf
    EndIf
    s += " combat=" + (a.IsInCombat() as Int) + " dead=" + (a.IsDead() as Int)
    Return s
EndFunction

; ============================================================================ sampled invariants

Function Sampled(Actor a)
    {[CHANGED 2026-10-10, reviewer] I3 only: a violation must still hold on a re-read of every field 1 s later to FAIL;
     otherwise it is logged as I3 TRANSIENT with both readings, and a TRANSIENT on 2 consecutive ticks for the same actor
     also FAILs (a flapping state). The watcher reads keys and actor values non-atomically on its own thread and can
     land between two calls of one bridge step (U1 run 11 B-7: REJOIN_DONE does Follow() then ClearKeys(); that order
     is kept on purpose, it holds IEB_Gate until NFF owns the follower). I1 stays a single-read hard FAIL.}
    ; I1: no actor in two agent aliases
    If IEB_IELib.SlotCountOf(a, IEB_IELib.AgentAliases()) > 1
        Fail("I1", a, "slotCount > 1")
    EndIf
    ; I3: rejoin phase
    If I3Bad(a)
        String first = I3Read(a)
        Utility.Wait(1.0)
        String second = I3Read(a)
        If I3Bad(a)
            Fail("I3", a, "rejoin without teammate on and WFP 1 (" + first + "; 1 s later " + second + ")")
        ElseIf StorageUtil.GetIntValue(a, "EBT_I3TransientTick", -9) == _tick - 1
            Fail("I3", a, "TRANSIENT on 2 consecutive ticks (" + first + "; 1 s later " + second + ")")
        Else
            W("I3 TRANSIENT " + a.GetDisplayName() + " " + Hex(a) + ": " + first + "; 1 s later " + second)
        EndIf
        StorageUtil.SetIntValue(a, "EBT_I3TransientTick", _tick)
    EndIf
EndFunction

Bool Function I3Bad(Actor a)
    Return StorageUtil.GetIntValue(a, "IEB_Held", 0) == 2 && (!a.IsPlayerTeammate() || a.GetActorValue("WaitingForPlayer") != 1.0)
EndFunction

String Function I3Read(Actor a)
    Return "held=" + StorageUtil.GetIntValue(a, "IEB_Held", 0) + " tm=" + (a.IsPlayerTeammate() as Int) + " wfp=" + a.GetActorValue("WaitingForPlayer")
EndFunction

Function DispatchChecks(Actor a)
    {I6 and I10 at the first sighting of an actor in an agent slot on a story / npc_social task (within 3 s of the
     dispatch). A scene the courier enters after dispatch is not held against I10.}
    Int slot = IEB_IELib.SlotOf(a)
    Int was = StorageUtil.GetIntValue(a, "EBT_InSlot", 0)
    If slot < 0
        If was == 1
            StorageUtil.UnsetIntValue(a, "EBT_InSlot")
        EndIf
        Return
    EndIf
    If was == 1
        Return
    EndIf
    StorageUtil.SetIntValue(a, "EBT_InSlot", 1)
    If !IEB_IELib.IsStoryTask(a)
        Return
    EndIf
    String t = StorageUtil.GetStringValue(a, "Intel_TaskType", "")
    If StorageUtil.GetIntValue(a, "EBT_PreGate", 0) == 1 || a.IsPlayerTeammate() || a.GetFactionRank(CFF()) >= 0
        Fail("I6", a, "story dispatch (" + t + ") of a gated, teammate or follower-faction actor")
    Else
        Pass("I6", a)
    EndIf
    IntelEngine_StoryEngine se = IEB_IELib.IEQuest() as IntelEngine_StoryEngine
    If se != None && a.GetCurrentScene() == None && se.IEB_QuestReserved(a, 1)
        Fail("I10", a, "story dispatch of a quest-reserved actor")
    Else
        Pass("I10", a)
    EndIf
EndFunction

Function ChildGuards()
    {I9, sampled every 30 s over loaded NPCs within 4096 u of the player (P5 clauses dropped 2026-10-09).}
    Actor pl = Game.GetPlayer()
    ObjectReference[] refs = PO3_SKSEFunctions.FindAllReferencesOfFormType(pl, 43, 4096.0)
    Int i = 0
    Int kids = 0
    While i < refs.Length
        Actor a = refs[i] as Actor
        If a != None && a.IsChild()
            kids += 1
            If StorageUtil.GetIntValue(a, "SNRom_Sparked", 0) == 1 || StorageUtil.HasIntValue(a, "SNRom_PlayerStance") || StorageUtil.GetIntValue(a, "SNRom_BankedPoints", 0) > 0
                Fail("I9", a, "child with spark, stance or banked points")
            EndIf
            If StorageUtil.GetIntValue(a, "SNRom_Enrolled", 0) == 1
                If StorageUtil.GetIntValue(a, "SNRom_PhysMinTier", -1) != -1 || StorageUtil.GetIntValue(a, "SNRom_SparkDecided", 0) != 1
                    Fail("I9", a, "enrolled child not locked (after the next sweep)")
                EndIf
            EndIf
            If StorageUtil.GetIntValue(a, "IEB_IsScenePartner", 0) == 1
                Fail("I9", a, "child is a scene partner")
            EndIf
        EndIf
        i += 1
    EndWhile
    W("I9 sample: " + kids + " loaded children checked")
EndFunction

Bool Function CheckInvariants(Actor a)
    {On demand (IEB_TestCtl.Check): I1, I2 for a seated, idle follower, I3, I4 for a restored lent NPC. Uses the
     baseline from IEB_TestCtl.Snapshot. Returns true if all pass.}
    Int before = _fails
    Sampled(a)
    Bool seated = IEB_NFFLib.Seated(a)
    Int held = StorageUtil.GetIntValue(a, "IEB_Held", 0)
    Bool onTask = IEB_IELib.SlotOf(a) >= 0
    Bool snap = StorageUtil.GetIntValue(a, "EBT_Snap", 0) == 1
    If seated && held == 0 && !onTask
        ; I2
        If !a.IsPlayerTeammate()
            Fail("I2", a, "teammate off")
        EndIf
        Float want = StorageUtil.GetFloatValue(a, "EBT_ExpectWFP", -99.0)
        If want == -99.0 && snap
            want = StorageUtil.GetFloatValue(a, "EBT_WFP", -99.0)
        EndIf
        If want != -99.0 && a.GetActorValue("WaitingForPlayer") != want
            Fail("I2", a, "WFP " + a.GetActorValue("WaitingForPlayer") + " != expected " + want)
        EndIf
        If snap && SeatOf(a) != StorageUtil.GetIntValue(a, "EBT_Seat", -1)
            Fail("I2", a, "NFF seat changed")
        EndIf
        If a.GetFactionRank(CFF()) != 0
            Fail("I2", a, "CurrentFollowerFaction rank != 0")
        EndIf
        Faction tf = Game.GetFormFromFile(0x000D62, "IntelEngine.esp") as Faction
        If tf != None && a.IsInFaction(tf)
            Fail("I2", a, "still in IntelEngine_TaskFaction")
        EndIf
        If HasIEBKeys(a)
            Fail("I2", a, "IEB_* keys left")
        EndIf
        If snap && ActorUtil.CountPackageOverride(a) != StorageUtil.GetIntValue(a, "EBT_Ovr", 0)
            Fail("I2", a, "package overrides differ from baseline")
        EndIf
    EndIf
    If snap && StorageUtil.GetIntValue(a, "EBT_WasLent", 0) == 1 && held == 0 && StorageUtil.GetIntValue(a, "IEB_Lent", 0) == 0
        ; I4: a lent NPC after restore
        If HasIEBKeys(a)
            Fail("I4", a, "IEB_* keys left")
        EndIf
        If SeverActionsNative.Native_GetHome(a) != StorageUtil.GetStringValue(a, "EBT_Home", "") || \
           SeverActionsNative.Native_GetWorkLoc(a) != StorageUtil.GetFormValue(a, "EBT_Work") || \
           SeverActionsNative.Native_GetPlayLoc(a) != StorageUtil.GetFormValue(a, "EBT_Play")
            Fail("I4", a, "home/work/play changed")
        EndIf
        If StorageUtil.GetIntValue(a, "EBT_HadSched", 0) == 1 && !IEB_SALib.AnySchedAlias(a)
            Fail("I4", a, "no schedule alias after restore (check again after 30 s / 4 min)")
        EndIf
        If ActorUtil.CountPackageOverride(a) != StorageUtil.GetIntValue(a, "EBT_Ovr", 0)
            Fail("I4", a, "package overrides differ from baseline")
        EndIf
    EndIf
    Bool ok = _fails == before
    If ok
        Pass("CHECK", a)
    EndIf
    Return ok
EndFunction

Bool Function HasIEBKeys(Actor a)
    {The keys IEB_Main.ClearKeys removes, plus IEB_HeldList membership.}
    String[] ik = new String[13]
    ik[0] = "IEB_Held"
    ik[1] = "IEB_Lent"
    ik[2] = "IEB_Gate"
    ik[3] = "IEB_Mode"
    ik[4] = "IEB_SA_Kind"
    ik[5] = "IEB_Recall"
    ik[6] = "IEB_Absent"
    ik[7] = "IEB_SeatLost"
    ik[8] = "IEB_Origin"
    ik[9] = "IEB_EndedEvt"
    ik[10] = "IEB_InSlot"
    ik[11] = "IEB_CF"
    ik[12] = "IEB_SkipLogged"
    Int i = 0
    While i < ik.Length
        If StorageUtil.HasIntValue(a, ik[i])
            Return True
        EndIf
        i += 1
    EndWhile
    String[] fk = new String[6]
    fk[0] = "IEB_PreWait"
    fk[1] = "IEB_SA_PrevWFP"
    fk[2] = "IEB_LastPark"
    fk[3] = "IEB_EndedAt"
    fk[4] = "IEB_LastWFP"
    fk[5] = "IEB_CF_PreGlobal"
    i = 0
    While i < fk.Length
        If StorageUtil.HasFloatValue(a, fk[i])
            Return True
        EndIf
        i += 1
    EndWhile
    If StorageUtil.HasStringValue(a, "IEB_TaskType") || StorageUtil.HasStringValue(a, "IEB_TaskTarget")
        Return True
    EndIf
    Return StorageUtil.FormListFind(None, "IEB_HeldList", a) >= 0
EndFunction

; ============================================================================ helpers

Int Function SeatOf(Actor a)
    {NFF seat = DialogueFollower alias index (0, 2-11), or -1.}
    Quest df = Game.GetFormFromFile(0x000750BA, "Skyrim.esm") as Quest
    Int i = 0
    While df != None && i <= 11
        If i != 1
            ReferenceAlias ra = df.GetAlias(i) as ReferenceAlias
            If ra != None && ra.GetActorReference() == a
                Return i
            EndIf
        EndIf
        i += 1
    EndWhile
    Return -1
EndFunction

Faction Function CFF()
    Return Game.GetFormFromFile(0x0005C84E, "Skyrim.esm") as Faction
EndFunction

Bool Function SameSpace(Actor a, Actor b)
    If a == None || b == None
        Return False
    EndIf
    Cell ca = a.GetParentCell()
    Cell cb = b.GetParentCell()
    If ca == None || cb == None
        Return False
    EndIf
    If ca.IsInterior() || cb.IsInterior()
        Return ca == cb
    EndIf
    Return a.GetWorldSpace() == b.GetWorldSpace()
EndFunction

String Function Hex(Form f)
    If f == None
        Return "None"
    EndIf
    Return PO3_SKSEFunctions.IntToString(f.GetFormID(), True)
EndFunction

Function Fail(String asRule, Actor a, String asWhy)
    _fails += 1
    W("ASSERT FAIL " + asRule + " " + a.GetDisplayName() + " " + Hex(a) + ": " + asWhy)
EndFunction

Function Pass(String asRule, Actor a)
    W("ASSERT PASS " + asRule + " " + a.GetDisplayName() + " " + Hex(a))
EndFunction

Function W(String asLine)
    Debug.TraceUser("ErrandBridgeWatch", asLine, 0)
EndFunction
