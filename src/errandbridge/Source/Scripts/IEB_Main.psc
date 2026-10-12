Scriptname IEB_Main extends Quest
{Errand Bridge main quest script (spec §4-§9). One serialized worker: every state change happens in OnUpdate,
 guarded by the Working state (R12); handlers only set request keys and ask for a tick.
 FROZEN property list (spec §16.4 freeze rule): never add, remove or rename a property. Anything else is looked up
 with Game.GetFormFromFile.}

; ---- FROZEN property list ----
GlobalVariable Property IEB_Enabled Auto
GlobalVariable Property IEB_PollSeconds Auto
GlobalVariable Property IEB_LogLevel Auto
GlobalVariable Property IEB_ParkRefreshHours Auto
GlobalVariable Property IEB_LogToFile Auto
GlobalVariable Property IEB_RejoinWarpFactor Auto
GlobalVariable Property IEB_LendEnabled Auto
GlobalVariable Property IEB_LendStoryPolicy Auto
GlobalVariable Property IEB_CFEnabled Auto
GlobalVariable Property IEB_CFPauseCatchup Auto
GlobalVariable Property IEB_Spare01 Auto
GlobalVariable Property IEB_Spare02 Auto
Actor Property PlayerRef Auto

; ---- caches (rebuilt after every load; never relied on across saves) ----
ReferenceAlias[] _agents
Int _tick
Bool _endPending          ; RV-227 (3): an IntelEngine_TaskEnded awaits resolution: tick at 0.2 s
Int _reconcileAt          ; tick number at which a load reconcile is due (0 = none)
Bool _reconcileSecond

; ============================================================================ lifecycle

Event OnInit()
    Setup()
    RegisterForSingleUpdate(5.0)
EndEvent

Function OnGameLoad()
    {IEB_PlayerAlias.OnPlayerLoadGame. Settle delay longer than IntelEngine's 2 s maintenance dedupe (R7).}
    Setup()
    ClearRTStamps()
    _reconcileAt = -1
    _reconcileSecond = False
    RegisterForSingleUpdate(5.0)
EndFunction

Function ClearRTStamps()
    {REVIEW_LOG RV-227b (1): Utility.GetCurrentRealTime() restarts at every game launch while StorageUtil keeps these
     stamps in the cosave; drop them at each load for the held actors and every IntelEngine agent (RTStamp() also treats
     any stamp later than now as absent, for actors outside both lists).}
    Int i = StorageUtil.FormListCount(None, "IEB_HeldList") - 1
    While i >= 0
        DropRT(StorageUtil.FormListGet(None, "IEB_HeldList", i) as Actor)
        i -= 1
    EndWhile
    Int s = 0
    While s < _agents.Length
        If _agents[s] != None
            DropRT(_agents[s].GetActorReference())
        EndIf
        s += 1
    EndWhile
EndFunction

Function DropRT(Actor a)
    If a != None
        StorageUtil.UnsetFloatValue(a, "IEB_StartedRT")
        StorageUtil.UnsetFloatValue(a, "IEB_EndedRT")
        StorageUtil.UnsetFloatValue(a, "IEB_IEOverrideAt")
    EndIf
EndFunction

Float Function RTStamp(Actor a, String asKey)
    {A this-session real-time stamp, or -1000 when unset or later than now (a stamp from an earlier launch).}
    Float v = StorageUtil.GetFloatValue(a, asKey, -1000.0)
    If v > Utility.GetCurrentRealTime()
        Return -1000.0
    EndIf
    Return v
EndFunction

Function Setup()
    Debug.OpenUserLog("ErrandBridge")
    _agents = IEB_IELib.AgentAliases()
    RegisterForModEvent("IntelEngine_TaskStarted", "OnIETaskStarted")
    RegisterForModEvent("IntelEngine_TaskEnded", "OnIETaskEnded")
    RegisterForModEvent("maras_status_changed", "OnMarasStatusChanged")
    RegisterForModEvent("SeverActions_FollowerCalledByPlayer", "OnSAFollowerCalled")   ; essential followers §1.0
    RegisterForModEvent("SeverActions_StewardVisitTravel", "OnStewardVisit")           ; notice N8 (spec §17a)
    IEB_Notice.OnLoad()                                                                 ; notice N1 probe, once per load
    IEB_EssLib.OnLoad()
    Log(2, "SETUP agents=" + _agents.Length + " enabled=" + IEB_Enabled.GetValueInt())
    If IEB_NFFLib.NFFPresent()                       ; REVIEW_LOG RV-66: once per load (Setup runs on init and on each load)
        Int src = IEB_NFFLib.DismissedFacSource()
        If src == 1
            Log(1, "NFF_DISMISSED_FAC source=varScript")
        ElseIf src == 2
            Log(0, "WARN NFF_DISMISSED_FAC source=fallback_0x05C84C (controller.varScript.DismissedFac unreadable)")
        Else
            Log(0, "WARN NFF_DISMISSED_FAC source=none (no dismissal faction; the seat check still decides)")
        EndIf
    EndIf
EndFunction

; ============================================================================ event handlers (request + tick only)

Event OnIETaskStarted(String asEventName, String asTaskType, Float afSlot, Form akSender)
    Actor a = akSender as Actor
    If a != None
        StorageUtil.UnsetIntValue(a, "IEB_RefusePending")     ; a new allocation (REVIEW_LOG R54); the 30 s marker stays
        ; RV-227 (1): a TaskStarted supersedes a pending end (IntelEngine's OverrideExistingTask re-tasks the same actor)
        StorageUtil.SetFloatValue(a, "IEB_StartedRT", Utility.GetCurrentRealTime())
        StorageUtil.UnsetIntValue(a, "IEB_EndedEvt")
        StorageUtil.UnsetIntValue(a, "IEB_PkgGoneN")
        StorageUtil.UnsetFloatValue(a, "IEB_IEOverrideAt")       ; the override it marked is complete
    EndIf
    RegisterForSingleUpdate(0.1)
EndEvent

Event OnIETaskEnded(String asEventName, String asResult, Float afSlot, Form akSender)
    Actor a = akSender as Actor
    If a != None
        StorageUtil.SetIntValue(a, "IEB_EndedEvt", 1)
        StorageUtil.SetFloatValue(a, "IEB_EndedRT", Utility.GetCurrentRealTime())
        StorageUtil.SetIntValue(a, "IEB_PkgGoneN", 0)
        _endPending = True
    EndIf
    RegisterForSingleUpdate(0.1)
EndEvent

Event OnStewardVisit(String asEventName, String asStrArg, Float afNumArg, Form akSender)
    {Notice N8 (spec §17a): SA's quiet steward visit departs; sender = steward, strArg = retainer (signed decimal).}
    IEB_Notice.StewardVisit(akSender, asStrArg)
EndEvent

Event OnMarasStatusChanged(String asEventName, String asStatus, Float afStatusEnum, Form akSender)
    {Rank-sync hook 2 (spec §11.14.1). Cheap and stateless, so it runs here rather than in the tick.}
    Actor m = akSender as Actor                      ; consumer proof (d): the event must be seen to arrive
    If m != None
        Log(1, "MARAS_EVT actor=" + m.GetDisplayName() + " status=" + asStatus)
    Else
        Log(1, "MARAS_EVT actor=none status=" + asStatus)
    EndIf
    IEB_RankSync.OnMarasStatus(m)
EndEvent

Event OnSAFollowerCalled(String asEventName, String asVerb, Float afArg, Form akSender)
    {Essential followers (design §1.0 step 1): SA fires "recruit" before it changes any state, so this only requests an
     early sweep (IEB_EssLib.Request); the tick does the work. Other verbs (dismiss, wait, follow) are ignored.}
    If asVerb == "recruit" && (akSender as Actor) != None
        IEB_EssLib.Request(akSender as Actor)
        RegisterForSingleUpdate(1.0)
    EndIf
EndEvent

; ============================================================================ worker

Event OnUpdate()
    GotoState("Working")
    Tick()
    GotoState("")
    ScheduleNext()
EndEvent

State Working
    Event OnUpdate()
        RegisterForSingleUpdate(0.2)    ; a tick is running; try again shortly
    EndEvent
EndState

Function ScheduleNext()
    If IEB_Enabled.GetValueInt() == 1 && _endPending
        RegisterForSingleUpdate(0.2)                        ; RV-227 (3): fast only while an end is pending
    ElseIf IEB_Enabled.GetValueInt() == 1
        RegisterForSingleUpdate(IEB_PollSeconds.GetValue())
    Else
        RegisterForSingleUpdate(5.0)
    EndIf
EndFunction

Function Tick()
    _tick += 1
    If !EnableTransitions()
        Return
    EndIf
    Bool essNow = False
    If _reconcileAt == -1
        Reconcile()
        _reconcileAt = _tick + 15        ; second reconcile at about +15 s
        _reconcileSecond = True
        essNow = True
    ElseIf _reconcileSecond && _tick >= _reconcileAt
        Reconcile()
        _reconcileSecond = False
        essNow = True
    EndIf
    Discover()
    ReleaseScan()
    UpkeepAll()
    If _tick % 5 == 0
        OrphanSweep()
        IEB_RankSync.SweepStep(4)
    EndIf
    ; essential followers (design §1.0 step 2): slot 2 of 5, never RankSync's; also at each load reconcile and
    ; right after an SA recruit request
    If essNow || _tick % 5 == 2 || IEB_EssLib.Pending()
        IEB_EssLib.Sweep(IEB_LogLevel.GetValueInt())
    EndIf
EndFunction

; ============================================================================ §9.1 off switch

Bool Function EnableTransitions()
    {True when the bridge is enabled. Handles the 1 -> 0 and 0 -> 1 transitions once.}
    Int now = IEB_Enabled.GetValueInt()
    Int was = StorageUtil.GetIntValue(None, "IEB_WasEnabled", 1)
    If now == was
        Return now == 1
    EndIf
    StorageUtil.SetIntValue(None, "IEB_WasEnabled", now)
    If now == 0
        Disable()
        Return False
    EndIf
    IEB_IELib.RestoreSkipFollower()
    Log(1, "ENABLE")
    Return True
EndFunction

Function Disable()
    Int i = StorageUtil.FormListCount(None, "IEB_HeldList") - 1
    While i >= 0
        Actor a = StorageUtil.FormListGet(None, "IEB_HeldList", i) as Actor
        If a != None
            If StorageUtil.GetIntValue(a, "IEB_Lent", 0) == 1
                IEB_IELib.CancelSlotOf(a)
                LendRestore(a, "disable")
            ElseIf StorageUtil.GetIntValue(a, "IEB_Held", 0) == 2
                IEB_NFFLib.Follow(a)
                ClearKeys(a)
                Log(1, "REJOIN_DONE actor=" + a.GetDisplayName() + " reason=disable")
            ElseIf StorageUtil.GetIntValue(a, "IEB_Held", 0) == 1
                StorageUtil.SetIntValue(a, "IEB_Recall", 1)
                Release(a, "disable")
            EndIf
        EndIf
        i -= 1
    EndWhile
    IEB_IELib.SaveAndSetSkipFollower()
    Log(1, "DISABLE")
EndFunction

; ============================================================================ §5 step 2: discover

Function Discover()
    Int s = 0
    While s < _agents.Length
        Actor a = None
        If _agents[s] != None
            a = _agents[s].GetActorReference()
        EndIf
        If a != None && !a.IsDead()
            If IEB_IELib.SlotCountOf(a, _agents) > 1
                DispatchConflict(a)                                  ; one actor in two agent aliases
            Else
                IEB_IELib.CopyTask(a)
                StorageUtil.SetIntValue(a, "IEB_SeenTask", 1)
                StorageUtil.SetIntValue(a, "IEB_Absent", 0)
                StorageUtil.SetIntValue(a, "IEB_InSlot", _tick)
                ; RV-227: still in the alias is NOT a re-task while IntelEngine's ClearSlot runs (it sends TaskEnded first and
                ; clears the alias last, seconds later); only a TaskStarted after the TaskEnded is (OnIETaskStarted unsets)
                If RTStamp(a, "IEB_StartedRT") > RTStamp(a, "IEB_EndedRT")
                    StorageUtil.UnsetIntValue(a, "IEB_EndedEvt")
                EndIf
                Int gate = StorageUtil.GetIntValue(a, "IEB_Gate", 0)
                Int held = StorageUtil.GetIntValue(a, "IEB_Held", 0)
                ; REVIEW_LOG R54: every decision reads the task type from IntelEngine's slot state now ("" = no decision)
                String live = IEB_IELib.DecisionTaskType(a)
                If gate == 0
                    If live == ""
                        Log(2, "DEFER actor=" + a.GetDisplayName() + " reason=slot_teardown")
                        DeferNote(a, "slot_teardown")
                    ElseIf IEB_IELib.IsStoryType(live) && IEB_NFFLib.Seated(a)
                        DispatchConflict(a)                          ; patch B missing or stale (§6.4)
                    Else
                        Classify(a)
                    EndIf
                ElseIf held == 2
                    ; REVIEW_LOG RV-70-upd (1): an actor in a slot during the rejoin phase is a re-task whatever its type
                    ; reads. A blank live type (seen after a load, RV-70) falls back to the bridge's own copy
                    ; (IEB_TaskType, CopyTask above) and is logged, instead of the re-task going unseen.
                    If live == ""
                        live = StorageUtil.GetStringValue(a, "IEB_TaskType", "")
                        Log(2, "TYPE_FALLBACK actor=" + a.GetDisplayName() + " phase=rejoin type=" + live)
                    EndIf
                    If IEB_IELib.IsStoryType(live)
                        DispatchConflict(a)                          ; a story beat on a rejoin-phase follower
                    Else
                        ; §8.4: one continuous hold, no re-park (WFP is already 1)
                        StorageUtil.SetIntValue(a, "IEB_Held", 1)
                        Log(1, "TAKE actor=" + a.GetDisplayName() + " reason=retask_from_rejoin")
                    EndIf
                EndIf
            EndIf
        EndIf
        s += 1
    EndWhile
EndFunction

; ============================================================================ §6.1 / §6.5 classify

Function Classify(Actor a)
    String who = a.GetDisplayName()
    ; REVIEW_LOG R54: task type from IntelEngine's slot state at decision time, never from IEB_Origin
    String live = IEB_IELib.DecisionTaskType(a)
    If live == ""
        Return
    EndIf
    If IEB_IELib.RefusePending(a)
        Log(2, "DEFER actor=" + who + " reason=refuse_pending type=" + live)
        DeferNote(a, "refuse_pending")
        Return
    EndIf
    DeferClear(a)
    ; REVIEW_LOG RV-66: the 30 s backstop only ever applies to a story-type task (the refusals it repeats are story
    ; refusals); a travel or other errand after a story refusal must classify normally.
    String prior = ""
    If IEB_IELib.IsStoryType(live)
        prior = IEB_IELib.RecentRefusal(a, live)
    EndIf
    If prior != ""
        IEB_IELib.MarkPending(a)
        IEB_IELib.CancelSlotOf(a)
        Log(1, "REFUSE actor=" + who + " reason=" + prior + " backstop=1 type=" + live)
        IEB_Notice.Refused(who)
        Return
    EndIf
    Int origin = 1
    If IEB_IELib.IsStoryType(live)
        origin = 2
    EndIf
    Bool seated = IEB_NFFLib.Seated(a)
    Int cf = IEB_CFLib.RegistryIndex(a)
    ; 1a: a registry NPC that NFF also seats (imported) - handed to two systems
    If cf >= 0 && seated
        Refuse(a, "double_managed")
        Return
    EndIf
    ; 1: NFF-seated
    If seated
        Park(a)
        Return
    EndIf
    ; 1b: registry NPC still recruited by its own mod -> Mode 4
    If cf >= 0 && IEB_CFLib.Recruited(a, cf)
        If IEB_CFEnabled.GetValueInt() != 1
            Refuse(a, "cf_disabled")
            Return
        EndIf
        String why = IEB_CFLib.RefuseReason(a, cf)
        If why != ""
            Refuse(a, why)
            Return
        EndIf
        TakeMode4(a, cf)
        Return
    EndIf
    ; 2: SA-posted (moved above Intel_WasFollower: gap G5)
    If IEB_SALib.Present() && IEB_SALib.IsPosted(a)
        If IEB_LendEnabled.GetValueInt() != 1
            Refuse(a, "lend_disabled")
            Return
        EndIf
        String reason = IEB_SALib.RefuseReason(a, origin, IEB_LendStoryPolicy.GetValueInt())
        If reason != ""
            Refuse(a, reason)
            Return
        EndIf
        Lend(a)
        Return
    EndIf
    ; 3: was a teammate when IntelEngine took them -> Mode 2
    If StorageUtil.GetIntValue(a, "Intel_WasFollower", 0) == 1
        StorageUtil.SetIntValue(a, "IEB_Held", 1)
        StorageUtil.SetIntValue(a, "IEB_Gate", 1)
        StorageUtil.SetIntValue(a, "IEB_Mode", 2)
        StorageUtil.SetIntValue(a, "IEB_Recall", 0)
        StorageUtil.SetIntValue(a, "IEB_Absent", 0)
        StorageUtil.FormListAdd(None, "IEB_HeldList", a, False)
        Log(1, "TAKE actor=" + who + " mode=2")
        Return
    EndIf
    ; 4: otherwise, once per task
    If StorageUtil.GetIntValue(a, "IEB_SkipLogged", 0) == 0
        StorageUtil.SetIntValue(a, "IEB_SkipLogged", 1)
        Log(2, "TAKE_SKIP actor=" + who + " reason=nonfollower")
    EndIf
EndFunction

; ============================================================================ §6.2 park (Mode 1)

Function Park(Actor a)
    If StorageUtil.GetIntValue(a, "IEB_Gate", 0) == 1
        Return
    EndIf
    Float pre = a.GetActorValue("WaitingForPlayer")
    ; REVIEW_LOG R32: NFF dismissal state at TAKE; G1 counts only a change during the hold
    StorageUtil.SetIntValue(a, "IEB_TakeDismissed", IEB_NFFLib.InDismissedFac(a) as Int)
    If IEB_NFFLib.IsAnimal(a)
        StorageUtil.SetFloatValue(a, "IEB_TakeV04", a.GetActorValue("Variable04"))
    Else
        StorageUtil.UnsetFloatValue(a, "IEB_TakeV04")
    EndIf
    StorageUtil.UnsetIntValue(a, "IEB_NFFDismissed")
    StorageUtil.UnsetFloatValue(a, "IEB_G1PendAt")
    IEB_NFFLib.Wait(a)                                   ; sync variant only (R1)
    StorageUtil.SetIntValue(a, "IEB_Held", 1)
    StorageUtil.SetIntValue(a, "IEB_Gate", 1)
    StorageUtil.SetIntValue(a, "IEB_Mode", 1)
    StorageUtil.SetFloatValue(a, "IEB_PreWait", pre)
    StorageUtil.SetFloatValue(a, "IEB_LastPark", Utility.GetCurrentGameTime())
    StorageUtil.SetIntValue(a, "IEB_Recall", 0)
    StorageUtil.SetIntValue(a, "IEB_Absent", 0)
    StorageUtil.SetFloatValue(a, "IEB_LastWFP", 1.0)
    StorageUtil.FormListAdd(None, "IEB_HeldList", a, False)
    Log(1, "TAKE actor=" + a.GetDisplayName() + " mode=1 prewait=" + pre)
EndFunction

; ============================================================================ §6.3 lend (Mode 3)

Function Lend(Actor a)
    StorageUtil.SetFloatValue(a, "IEB_SA_PrevWFP", a.GetActorValue("WaitingForPlayer"))
    Int kind = IEB_SALib.Suspend(a)
    StorageUtil.SetIntValue(a, "IEB_SA_Kind", kind)
    StorageUtil.SetIntValue(a, "IEB_Lent", 1)
    StorageUtil.SetIntValue(a, "IEB_Gate", 1)
    StorageUtil.SetIntValue(a, "IEB_Mode", 3)
    StorageUtil.SetIntValue(a, "IEB_Absent", 0)
    StorageUtil.FormListAdd(None, "IEB_HeldList", a, False)
    a.EvaluatePackage()
    Log(1, "LEND actor=" + a.GetDisplayName() + " kind=" + kind)
EndFunction

; ============================================================================ §6.5 Mode 4 take

Function TakeMode4(Actor a, Int cf)
    StorageUtil.SetFloatValue(a, "IEB_PreWait", a.GetActorValue("WaitingForPlayer"))
    IEB_CFLib.Park(a, cf)                                 ; saves IEB_CF_PreGlobal itself for wfp+global
    StorageUtil.SetIntValue(a, "IEB_Held", 1)
    StorageUtil.SetIntValue(a, "IEB_Gate", 1)
    StorageUtil.SetIntValue(a, "IEB_Mode", 4)
    StorageUtil.SetIntValue(a, "IEB_CF", cf)
    StorageUtil.SetIntValue(a, "IEB_Recall", 0)
    StorageUtil.SetIntValue(a, "IEB_Absent", 0)
    StorageUtil.SetFloatValue(a, "IEB_LastWFP", a.GetActorValue("WaitingForPlayer"))
    StorageUtil.FormListAdd(None, "IEB_HeldList", a, False)
    a.EvaluatePackage()
    IEB_CFLib.CatchupPauseUpdate(IEB_CFPauseCatchup.GetValueInt())
    Log(1, "TAKE actor=" + a.GetDisplayName() + " mode=4 cf=" + cf)
EndFunction

; ============================================================================ §6.4 refuse and dispatch conflict

Function Refuse(Actor a, String asReason)
    String t = IEB_IELib.DecisionTaskType(a)               ; read before the cancel (REVIEW_LOG R54 backstop key)
    If t == ""
        t = StorageUtil.GetStringValue(a, "IEB_TaskType", "")
    EndIf
    IEB_IELib.MarkRefused(a, t, asReason)
    IEB_IELib.CancelSlotOf(a)
    SkyrimNetApi.RegisterEvent("ieb_errand_refused", a.GetDisplayName() + " could not leave " + RefusalPlace(asReason) + \
        " for that errand.", a, PlayerRef)
    Log(1, "REFUSE actor=" + a.GetDisplayName() + " reason=" + asReason)
    IEB_Notice.Refused(a.GetDisplayName())
EndFunction

String Function RefusalPlace(String asReason)
    If asReason == "war_band"
        Return "the war band"
    ElseIf asReason == "steward_visit" || asReason == "on_duty_story"
        Return "their duties"
    ElseIf asReason == "sa_wait"
        Return "the spot they were told to wait at"
    ElseIf asReason == "sa_busy"
        Return "what they were already doing"
    EndIf
    Return "their post"
EndFunction

Function DispatchConflict(Actor a)
    IEB_IELib.CancelSlotOf(a)
    Utility.Wait(0.5)
    IEB_IELib.CancelSlotOf(a)
    If StorageUtil.GetIntValue(a, "IEB_Lent", 0) == 1
        LendRestore(a, "conflict")
    ElseIf StorageUtil.GetIntValue(a, "IEB_Held", 0) == 1
        Release(a, "conflict")
    EndIf
    Log(1, "DISPATCH_CONFLICT actor=" + a.GetDisplayName())
    IEB_Notice.CalledOff(a.GetDisplayName())
EndFunction

; ============================================================================ §5 step 3: release scan

Function ReleaseScan()
    Int i = StorageUtil.FormListCount(None, "IEB_HeldList") - 1
    Bool anyPending = False
    While i >= 0
        Actor a = StorageUtil.FormListGet(None, "IEB_HeldList", i) as Actor
        If a != None
            Int held = StorageUtil.GetIntValue(a, "IEB_Held", 0)
            Int lent = StorageUtil.GetIntValue(a, "IEB_Lent", 0)
            If held == 1 || lent == 1
                If StorageUtil.GetIntValue(a, "IEB_InSlot", -1) != _tick
                    StorageUtil.AdjustIntValue(a, "IEB_Absent", 1)
                EndIf
                ; RV-227: a pending end resolves when the alias is gone (alias_cleared), or when IntelEngine's package has been
                ; gone for 2 consecutive ticks (0.2 s apart) with no TaskStarted since and no OverrideExistingTask stamp in the
                ; last 15 s (pkg_gone); the 2-absent-ticks path and death stay
                Bool pend = StorageUtil.GetIntValue(a, "IEB_EndedEvt", 0) == 1
                String why = ""
                If pend
                    If IEB_IELib.IEPackage(a)
                        StorageUtil.SetIntValue(a, "IEB_PkgGoneN", 0)
                    Else
                        StorageUtil.AdjustIntValue(a, "IEB_PkgGoneN", 1)
                    EndIf
                    Float ov = RTStamp(a, "IEB_IEOverrideAt")
                    Bool overriding = ov >= 0.0 && ov >= RTStamp(a, "IEB_EndedRT") - 30.0 && Utility.GetCurrentRealTime() - ov < 15.0
                    If StorageUtil.GetIntValue(a, "IEB_InSlot", -1) != _tick
                        why = "alias_cleared"
                    ElseIf StorageUtil.GetIntValue(a, "IEB_PkgGoneN", 0) >= 2 && !overriding
                        why = "pkg_gone"
                    EndIf
                EndIf
                If why == "" && StorageUtil.GetIntValue(a, "IEB_Absent", 0) >= 2
                    why = "absent"
                ElseIf why == "" && a.IsDead()
                    why = "dead"
                EndIf
                If why == "" && pend
                    anyPending = True
                EndIf
                If why != ""
                    If pend
                        Log(1, "END_RESOLVED actor=" + a.GetDisplayName() + " why=" + why + " lagS=" \
                            + (Utility.GetCurrentRealTime() - RTStamp(a, "IEB_EndedRT")))
                    EndIf
                    StorageUtil.UnsetIntValue(a, "IEB_EndedEvt")
                    StorageUtil.UnsetIntValue(a, "IEB_PkgGoneN")
                    If lent == 1
                        LendRestore(a, "task_end")
                    ElseIf StorageUtil.GetIntValue(a, "IEB_Mode", 0) == 4
                        ReleaseMode4(a)
                    Else
                        Release(a, "task_end")
                    EndIf
                EndIf
            EndIf
        Else
            StorageUtil.FormListRemoveAt(None, "IEB_HeldList", i)
        EndIf
        i -= 1
    EndWhile
    _endPending = anyPending
EndFunction

; ============================================================================ §7.1 release (Modes 1 and 2)

Function Release(Actor a, String asWhy)
    If StorageUtil.GetIntValue(a, "IEB_Held", 0) != 1
        Return
    EndIf
    String who = a.GetDisplayName()
    Int mode = StorageUtil.GetIntValue(a, "IEB_Mode", 0)
    If a.IsDead()
        ClearKeys(a)
        Log(1, "RELEASE_DEAD actor=" + who)
        Return
    EndIf
    Bool seated = IEB_NFFLib.Seated(a)
    If mode == 1 && StorageUtil.GetIntValue(a, "IEB_NFFDismissed", 0) == 1
        ; REVIEW_LOG R32: NFF dismissed her mid-errand. No Follow, no Wait, no teammate write, even if NFF still
        ; holds the seat (it clears the alias last, RemoveAction :520): the player's dismissal stands.
        ClearKeys(a)
        Log(1, "RELEASE_DISMISSED actor=" + who + " seated=" + seated)
        Return
    EndIf
    If mode == 1 && !seated
        ClearKeys(a)
        Log(1, "RELEASE_SEATLOST actor=" + who)
        Return
    EndIf
    If mode == 2
        ; G3: restore the teammate flag only if in CurrentFollowerFaction and WFP != -1; else force it off
        If InCFF(a) && a.GetActorValue("WaitingForPlayer") != -1.0
            If !a.IsPlayerTeammate()
                a.SetPlayerTeammate(True, True)
                Log(1, "TEAMMATE_WAS_OFF actor=" + who)
            EndIf
        ElseIf a.IsPlayerTeammate()
            a.SetPlayerTeammate(False)
        EndIf
    ElseIf seated && !a.IsPlayerTeammate()
        a.SetPlayerTeammate(True, True)
        Log(1, "TEAMMATE_WAS_OFF actor=" + who)
    EndIf
    SkyrimNetApi.ReinforcePackages(a)
    StorageUtil.SetFloatValue(a, "IEB_EndedAt", Utility.GetCurrentGameTime())
    If mode == 2
        ClearKeys(a)
        a.EvaluatePackage()
        Log(1, "RELEASE actor=" + who + " mode=2 why=" + asWhy)
        Return
    EndIf
    Int recall = StorageUtil.GetIntValue(a, "IEB_Recall", 0)
    If recall == 2 || (StorageUtil.GetFloatValue(a, "IEB_PreWait", 0.0) > 0.0 && recall != 1)
        IEB_NFFLib.Wait(a)
        ClearKeys(a)
        Log(1, "RELEASE_STAY actor=" + who)
    ElseIf recall == 1 || RejoinTest(a)
        IEB_NFFLib.Follow(a)
        ClearKeys(a)
        Log(1, "RELEASE_FOLLOW actor=" + who)
    Else
        StorageUtil.SetIntValue(a, "IEB_Held", 2)          ; Gate stays 1
        Log(1, "REJOIN_WAIT actor=" + who)
        IEB_Notice.RejoinWait(who)
    EndIf
    a.EvaluatePackage()
EndFunction

Bool Function InCFF(Actor a)
    Faction cff = Game.GetFormFromFile(0x0005C84E, "Skyrim.esm") as Faction
    Return cff != None && a.GetFactionRank(cff) >= 0
EndFunction

; ============================================================================ §7.2 rejoin test

Bool Function RejoinTest(Actor a)
    {U1: unloaded and NFF warp on. U2: loaded, same space, within N and |dZ| <= N/2.}
    If !a.Is3DLoaded()
        Return IEB_NFFLib.AllowWarp()
    EndIf
    If !SameSpace(a, PlayerRef)
        Return False
    EndIf
    Float n = IEB_RejoinWarpFactor.GetValue() * IEB_NFFLib.WarpRange()
    Float dz = a.GetPositionZ() - PlayerRef.GetPositionZ()
    If dz < 0.0
        dz = -dz
    EndIf
    Return a.GetDistance(PlayerRef) <= n && dz <= n / 2.0
EndFunction

Bool Function SameSpace(Actor a, Actor b)
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

; ============================================================================ §7.3 lend restore

Function LendRestore(Actor a, String asWhy)
    If StorageUtil.GetIntValue(a, "IEB_Lent", 0) != 1
        Return
    EndIf
    String who = a.GetDisplayName()
    If IEB_SALib.IsSAFollower(a)
        ClearKeys(a)
        Log(1, "LEND_RESTORE_SKIP actor=" + who + " reason=now_follower")
        Return
    EndIf
    Int kind = StorageUtil.GetIntValue(a, "IEB_SA_Kind", 0)
    IEB_SALib.Restore(a, StorageUtil.GetFloatValue(a, "IEB_SA_PrevWFP", 0.0))
    a.EvaluatePackage()
    ClearKeys(a)
    Log(1, "LEND_RESTORE actor=" + who + " kind=" + kind + " why=" + asWhy)
EndFunction

; ============================================================================ §6.5 Mode 4 release

Function ReleaseMode4(Actor a)
    If StorageUtil.GetIntValue(a, "IEB_Held", 0) != 1
        Return
    EndIf
    String who = a.GetDisplayName()
    Int cf = StorageUtil.GetIntValue(a, "IEB_CF", -1)
    If a.IsDead()
        ClearKeys(a)
        IEB_CFLib.CatchupPauseUpdate(IEB_CFPauseCatchup.GetValueInt())
        Log(1, "RELEASE_DEAD actor=" + who + " mode=4")
        Return
    EndIf
    If StorageUtil.GetIntValue(a, "IEB_Recall", 0) == 2
        ClearKeys(a)
        Log(1, "RELEASE_STAY actor=" + who + " mode=4")
    Else
        IEB_CFLib.Unpark(a, cf, StorageUtil.GetFloatValue(a, "IEB_PreWait", 0.0))
        a.EvaluatePackage()
        ClearKeys(a)
        Log(1, "RELEASE_FOLLOW actor=" + who + " mode=4")
    EndIf
    ; teammate: recruited and off -> on; dismissed -> what the follower's own mod left (after IntelEngine's restore)
    If IEB_CFLib.Recruited(a, cf)
        If !a.IsPlayerTeammate()
            a.SetPlayerTeammate(True, True)
            Log(1, "TEAMMATE_WAS_OFF actor=" + who)
        EndIf
    ElseIf StorageUtil.HasIntValue(a, "IEB_CF_DismissTM")
        a.SetPlayerTeammate(StorageUtil.GetIntValue(a, "IEB_CF_DismissTM", 0) == 1)
        StorageUtil.UnsetIntValue(a, "IEB_CF_DismissTM")
        Log(1, "CF_UNTEAMMATE actor=" + who)
    EndIf
    IEB_CFLib.ReleaseFixups(a, cf)
    IEB_CFLib.CatchupPauseUpdate(IEB_CFPauseCatchup.GetValueInt())
EndFunction

; ============================================================================ §5 steps 4-6: upkeep

Function UpkeepAll()
    Int i = StorageUtil.FormListCount(None, "IEB_HeldList") - 1
    While i >= 0
        Actor a = StorageUtil.FormListGet(None, "IEB_HeldList", i) as Actor
        If a != None
            Int held = StorageUtil.GetIntValue(a, "IEB_Held", 0)
            If StorageUtil.GetIntValue(a, "IEB_Lent", 0) == 1
                LendUpkeep(a)
            ElseIf held == 1 && StorageUtil.GetIntValue(a, "IEB_Mode", 0) == 4
                Mode4Upkeep(a)
            ElseIf held == 1
                HeldUpkeep(a)
            ElseIf held == 2
                RejoinUpkeep(a)
            EndIf
        EndIf
        i -= 1
    EndWhile
EndFunction

Function HeldUpkeep(Actor a)
    Int mode = StorageUtil.GetIntValue(a, "IEB_Mode", 0)
    Float wfp = a.GetActorValue("WaitingForPlayer")
    ; G1: external follow = a 1 -> 0 transition, Modes 1 (and 4, in Mode4Upkeep) only
    If mode == 1
        Float pend = StorageUtil.GetFloatValue(a, "IEB_G1PendAt", -1.0)
        Bool open = StorageUtil.GetIntValue(a, "IEB_Recall", 0) == 0 && StorageUtil.GetIntValue(a, "IEB_NFFDismissed", 0) == 0
        If pend >= 0.0
            ; REVIEW_LOG RV-66: a WFP 1 -> 0 with no faction/V04 signal is decided on the NFF seat, up to 3 s (10 s) later.
            ; A dismissal clears the alias (RemoveAction nwsFollowerControllerScript.psc:523, DismissGuardAction :942,
            ; ExportAction :754); a follow command keeps it.
            ; REVIEW_LOG RV-66-upd: about 20 Papyrus calls lie between NFF's WFP=0 and its alias clear, and Papyrus lag
            ; reached 1.28 s per step on 2026-10-10, so 3 s can be too short under load. In keep mode (IEB_DropTeammate
            ; != 1) a follow command leaves the teammate flag on while a dismissal clears it before WFP=0, so a
            ; cleared flag widens the window to 10 s. Every decision logs the WFP->decision gap (gap=) for the
            ; max(3 s, 3 x p95) calibration in B-6 x10 and the soak.
            Float age = Utility.GetCurrentRealTime() - pend
            Float win = 3.0
            If StorageUtil.GetIntValue(None, "IEB_DropTeammate", 0) != 1 && !a.IsPlayerTeammate()
                win = 10.0
            EndIf
            String gap = " gap=" + ((age * 1000.0) as Int) + "ms win=" + (win as Int) + "s"
            If wfp == 1.0 || !open
                StorageUtil.UnsetFloatValue(a, "IEB_G1PendAt")       ; parked again, or already decided elsewhere
            ElseIf !IEB_NFFLib.Seated(a)
                StorageUtil.UnsetFloatValue(a, "IEB_G1PendAt")
                G1Dismissed(a, "seat_cleared" + gap)
            ElseIf NFFDismissedDuringHold(a)
                StorageUtil.UnsetFloatValue(a, "IEB_G1PendAt")
                G1Dismissed(a, "late_signal" + gap)
            ElseIf age >= win || age < 0.0
                StorageUtil.UnsetFloatValue(a, "IEB_G1PendAt")
                G1Follow(a, "seat_kept" + gap)
            EndIf
        ElseIf StorageUtil.GetFloatValue(a, "IEB_LastWFP", 1.0) == 1.0 && wfp == 0.0 && open
            If NFFDismissedDuringHold(a)
                G1Dismissed(a, "signal gap=0ms")                     ; NFF wrote its dismissal signal before WFP=0
            ElseIf !IEB_NFFLib.Seated(a)
                G1Dismissed(a, "seat_cleared gap=0ms")
            Else
                StorageUtil.SetFloatValue(a, "IEB_G1PendAt", Utility.GetCurrentRealTime())
                Log(2, "G1_DEFER actor=" + a.GetDisplayName() + " reason=no_signal")
            EndIf
        EndIf
        If !IEB_NFFLib.Seated(a)
            StorageUtil.SetIntValue(a, "IEB_SeatLost", 1)
        EndIf
        RefreshParkTimer(a, wfp)
    EndIf
    StorageUtil.SetFloatValue(a, "IEB_LastWFP", wfp)
EndFunction

Function G1Dismissed(Actor a, String asWhy)
    ; REVIEW_LOG R32: NFF's dismissal (RemoveAction sets DismissedFac / animal Variable04=0 before WFP=0; hired guards and
    ; imported followers leave only the cleared seat), not a follow command. Unset Intel_WasFollower BEFORE the cancel
    ; so IE's ClearSlotRestoreFollower skips its SetPlayerTeammate(true); IEB_Recall stays 0 so Release can't Follow her.
    StorageUtil.SetIntValue(a, "IEB_SeatLost", 1)
    StorageUtil.SetIntValue(a, "IEB_NFFDismissed", 1)
    StorageUtil.UnsetIntValue(a, "Intel_WasFollower")
    IEB_IELib.CancelSlotOf(a)
    Log(1, "NFF_DISMISSED actor=" + a.GetDisplayName() + " via=" + asWhy + " seated=" + IEB_NFFLib.Seated(a) + " tm=" + a.IsPlayerTeammate())
EndFunction

Function G1Follow(Actor a, String asWhy)
    StorageUtil.SetIntValue(a, "IEB_Recall", 1)
    IEB_IELib.CancelSlotOf(a)
    Log(1, "CMD_FOLLOW actor=" + a.GetDisplayName() + " via=" + asWhy)
EndFunction

Function DeferNote(Actor a, String asWhy)
    {REVIEW_LOG RV-66: a DEFER that repeats for more than 10 s on one actor is a WARN (once per streak). A streak ends
     after 5 s without a DEFER or at the next decision (DeferClear).}
    Float now = Utility.GetCurrentRealTime()
    Float since = StorageUtil.GetFloatValue(a, "IEB_DeferSince", -1.0)
    Float last = StorageUtil.GetFloatValue(a, "IEB_DeferLast", -1.0)
    StorageUtil.SetFloatValue(a, "IEB_DeferLast", now)
    If since < 0.0 || since > now || last < 0.0 || now - last > 5.0
        StorageUtil.SetFloatValue(a, "IEB_DeferSince", now)
        StorageUtil.UnsetIntValue(a, "IEB_DeferWarned")
    ElseIf now - since > 10.0 && StorageUtil.GetIntValue(a, "IEB_DeferWarned", 0) == 0
        StorageUtil.SetIntValue(a, "IEB_DeferWarned", 1)
        Log(0, "WARN DEFER_STUCK actor=" + a.GetDisplayName() + " reason=" + asWhy + " secs=" + (now - since) as Int)
    EndIf
EndFunction

Function DeferClear(Actor a)
    StorageUtil.UnsetFloatValue(a, "IEB_DeferSince")
    StorageUtil.UnsetFloatValue(a, "IEB_DeferLast")
    StorageUtil.UnsetIntValue(a, "IEB_DeferWarned")
EndFunction

Bool Function NFFDismissedDuringHold(Actor a)
    {REVIEW_LOG R32 + RV-66: a dismissal signal that APPEARED during the hold. A stale DismissedFac does not count:
     ImportAction (nwsFollowerControllerScript.psc:662-720) never touches DismissedFac (the only writers are RecruitAction
     :387 and ExpelFollower :981 remove it; RemoveAction :466 and :1040 add it), so an imported follower can carry it from an earlier dismissal;
     Park records IEB_TakeDismissed = 1 for her, which turns this signal off and leaves the seat check (HeldUpkeep) to
     decide. Holds taken before this build have no IEB_TakeDismissed: read as 0.}
    If StorageUtil.GetIntValue(a, "IEB_TakeDismissed", 0) == 0 && IEB_NFFLib.InDismissedFac(a)
        Return True
    EndIf
    If StorageUtil.HasFloatValue(a, "IEB_TakeV04") && StorageUtil.GetFloatValue(a, "IEB_TakeV04", 0.0) == 1.0 && \
       a.GetActorValue("Variable04") == 0.0
        Return True
    EndIf
    Return False
EndFunction

Function RefreshParkTimer(Actor a, Float wfp)
    {G2: Mode 1 only. NFF's wait timer is refreshed by re-parking (R9).}
    If wfp == 1.0 && Utility.GetCurrentGameTime() - StorageUtil.GetFloatValue(a, "IEB_LastPark", 0.0) > IEB_ParkRefreshHours.GetValue() / 24.0
        IEB_NFFLib.Wait(a)
        StorageUtil.SetFloatValue(a, "IEB_LastPark", Utility.GetCurrentGameTime())
        Log(2, "REPARK actor=" + a.GetDisplayName())
    EndIf
EndFunction

Function RejoinUpkeep(Actor a)
    String who = a.GetDisplayName()
    Float wfp = a.GetActorValue("WaitingForPlayer")
    If a.IsDead()
        ClearKeys(a)
        Log(1, "REJOIN_CANCELLED actor=" + who + " reason=dead")
        Return
    EndIf
    If !IEB_NFFLib.Seated(a)
        ClearKeys(a)
        Log(1, "REJOIN_CANCELLED actor=" + who + " reason=seat_lost")
        Return
    EndIf
    If wfp == 0.0
        ClearKeys(a)
        Log(1, "REJOIN_CANCELLED actor=" + who + " reason=player_follow")
        Return
    EndIf
    If !a.Is3DLoaded() && !IEB_NFFLib.AllowWarp()
        ClearKeys(a)
        Log(1, "REJOIN_TO_WAIT actor=" + who + " reason=unloaded_nowarp")
        IEB_Notice.WaitingAtEnd(who)
        Return
    EndIf
    If RejoinTest(a)
        IEB_NFFLib.Follow(a)
        ClearKeys(a)
        a.EvaluatePackage()
        Log(1, "REJOIN_DONE actor=" + who)
        IEB_Notice.Rejoined(who)
        Return
    EndIf
    RefreshParkTimer(a, wfp)
EndFunction

Function LendUpkeep(Actor a)
    {§7.3 abort triggers: each cancels the slot, then restores.}
    String why = IEB_SALib.AbortReason(a)
    If why != ""
        IEB_IELib.CancelSlotOf(a)
        LendRestore(a, "abort:" + why)
        Log(1, "LEND_ABORT actor=" + a.GetDisplayName() + " reason=" + why)
    EndIf
EndFunction

Function Mode4Upkeep(Actor a)
    String who = a.GetDisplayName()
    Int cf = StorageUtil.GetIntValue(a, "IEB_CF", -1)
    Float wfp = a.GetActorValue("WaitingForPlayer")
    If !IEB_CFLib.Recruited(a, cf)
        StorageUtil.SetIntValue(a, "IEB_CF_DismissTM", a.IsPlayerTeammate() as Int)
        IEB_IELib.CancelSlotOf(a)
        Log(1, "CF_DISMISSED actor=" + who)
        Return
    EndIf
    String midtask = IEB_CFLib.RefuseReason(a, cf)
    If midtask != "" && StorageUtil.GetIntValue(a, "IEB_Recall", 0) == 0
        StorageUtil.SetIntValue(a, "IEB_Recall", 1)
        IEB_IELib.CancelSlotOf(a)
        Log(1, "CF_REFUSE_MIDTASK actor=" + who + " reason=" + midtask)
        Return
    EndIf
    Int outside = IEB_CFLib.ParkUndone(a, cf, StorageUtil.GetFloatValue(a, "IEB_LastWFP", 1.0), wfp)
    If outside != 0 && StorageUtil.GetIntValue(a, "IEB_Recall", 0) == 0
        StorageUtil.SetIntValue(a, "IEB_Recall", outside)     ; 1 = follow (park undone), 2 = stay (Inigo told to wait)
        IEB_IELib.CancelSlotOf(a)
        Log(1, "CMD_FOLLOW actor=" + who + " mode=4 recall=" + outside)
    EndIf
    StorageUtil.SetFloatValue(a, "IEB_LastWFP", wfp)
EndFunction

; ============================================================================ §9.2 reconcile

Function Reconcile()
    Log(2, "RECONCILE")
    Int i = StorageUtil.FormListCount(None, "IEB_HeldList") - 1
    While i >= 0
        Actor a = StorageUtil.FormListGet(None, "IEB_HeldList", i) as Actor
        If a != None
            Bool inAlias = IEB_IELib.SlotCountOf(a, _agents) > 0
            Int held = StorageUtil.GetIntValue(a, "IEB_Held", 0)
            Int mode = StorageUtil.GetIntValue(a, "IEB_Mode", 0)
            If StorageUtil.GetIntValue(a, "IEB_Lent", 0) == 1
                If !inAlias
                    LendRestore(a, "reconcile")
                ElseIf IEB_SALib.AbortReason(a) == "sa_retake"
                    IEB_IELib.CancelSlotOf(a)
                    LendRestore(a, "abort:sa_retake")
                Else
                    IEB_SALib.Reassert(a)
                EndIf
            ElseIf held == 1 && !inAlias
                If mode == 4
                    ReleaseMode4(a)
                Else
                    Release(a, "reconcile")
                EndIf
            ElseIf held == 1 && !a.IsDead()
                If mode == 1 && StorageUtil.GetIntValue(a, "IEB_Recall", 0) == 0 && a.GetActorValue("WaitingForPlayer") != 1.0 && \
                   StorageUtil.GetIntValue(a, "IEB_NFFDismissed", 0) == 0
                    IEB_NFFLib.Wait(a)
                    Log(2, "REPARK actor=" + a.GetDisplayName() + " reason=reconcile")
                ElseIf mode == 4 && StorageUtil.GetIntValue(a, "IEB_Recall", 0) == 0
                    IEB_CFLib.Park(a, StorageUtil.GetIntValue(a, "IEB_CF", -1))
                EndIf
            ElseIf held == 2
                If a.GetActorValue("WaitingForPlayer") != 1.0
                    IEB_NFFLib.Wait(a)
                EndIf
                If !a.IsPlayerTeammate() && IEB_NFFLib.Seated(a)
                    a.SetPlayerTeammate(True, True)
                EndIf
            EndIf
        EndIf
        i -= 1
    EndWhile
    IEB_CFLib.CatchupPauseUpdate(IEB_CFPauseCatchup.GetValueInt())
    IEB_RankSync.SweepStep(4)
EndFunction

; ============================================================================ §9.3 orphan sweep

Function OrphanSweep()
    ; held-list hygiene: Gate 0 -> drop
    Int i = StorageUtil.FormListCount(None, "IEB_HeldList") - 1
    While i >= 0
        Actor a = StorageUtil.FormListGet(None, "IEB_HeldList", i) as Actor
        If a == None || StorageUtil.GetIntValue(a, "IEB_Gate", 0) == 0
            StorageUtil.FormListRemoveAt(None, "IEB_HeldList", i)
        ElseIf StorageUtil.GetIntValue(a, "IEB_Lent", 0) == 1 && IEB_IELib.SlotCountOf(a, _agents) == 0
            LendRestore(a, "orphan")
        EndIf
        i -= 1
    EndWhile
    ; v1 teammate-orphan rule over the NFF seats
    Actor[] seats = IEB_NFFLib.SeatedActors()
    Int s = 0
    While s < seats.Length
        Actor f = seats[s]
        If f != None && !f.IsDead() && !f.IsPlayerTeammate() && StorageUtil.GetIntValue(f, "IEB_Gate", 0) == 0 && \
           StorageUtil.GetIntValue(f, "IEB_SeenTask", 0) == 1 && IEB_IELib.SlotCountOf(f, _agents) == 0 && \
           !IEB_NFFLib.Sparring(f) && !StorageUtil.HasIntValue(f, "SeverBrawl_WasNFF")
            f.SetPlayerTeammate(True, True)
            StorageUtil.UnsetIntValue(f, "IEB_SeenTask")
            Log(1, "ORPHAN_FIX actor=" + f.GetDisplayName())
        EndIf
        s += 1
    EndWhile
EndFunction

; ============================================================================ keys

Function ClearKeys(Actor a)
    StorageUtil.UnsetIntValue(a, "IEB_Held")
    StorageUtil.UnsetIntValue(a, "IEB_Lent")
    StorageUtil.UnsetIntValue(a, "IEB_Gate")
    StorageUtil.UnsetIntValue(a, "IEB_Mode")
    StorageUtil.UnsetFloatValue(a, "IEB_PreWait")
    StorageUtil.UnsetFloatValue(a, "IEB_SA_PrevWFP")
    StorageUtil.UnsetIntValue(a, "IEB_SA_Kind")
    StorageUtil.UnsetFloatValue(a, "IEB_LastPark")
    StorageUtil.UnsetIntValue(a, "IEB_Recall")
    StorageUtil.UnsetIntValue(a, "IEB_Absent")
    StorageUtil.UnsetIntValue(a, "IEB_SeatLost")
    StorageUtil.UnsetStringValue(a, "IEB_TaskType")
    StorageUtil.UnsetStringValue(a, "IEB_TaskTarget")
    StorageUtil.UnsetIntValue(a, "IEB_Origin")
    StorageUtil.UnsetFloatValue(a, "IEB_EndedAt")
    StorageUtil.UnsetIntValue(a, "IEB_EndedEvt")
    StorageUtil.UnsetIntValue(a, "IEB_InSlot")
    StorageUtil.UnsetFloatValue(a, "IEB_LastWFP")
    StorageUtil.UnsetIntValue(a, "IEB_CF")
    StorageUtil.UnsetFloatValue(a, "IEB_CF_PreGlobal")
    StorageUtil.UnsetIntValue(a, "IEB_SkipLogged")
    StorageUtil.UnsetIntValue(a, "IEB_TakeDismissed")
    StorageUtil.UnsetFloatValue(a, "IEB_G1PendAt")
    DeferClear(a)
    StorageUtil.UnsetFloatValue(a, "IEB_TakeV04")
    StorageUtil.UnsetIntValue(a, "IEB_NFFDismissed")
    StorageUtil.FormListRemove(None, "IEB_HeldList", a, True)
EndFunction

; ============================================================================ §8.1 CancelCurrentTask -> CancelOrRecall

Function CancelOrRecall(Actor akNPC, Int stayHere)
    {Bound to the bridge's CancelCurrentTask override (layer ieb.errandbridge). The model picks stayHere.}
    If akNPC == None
        Return
    EndIf
    String who = akNPC.GetDisplayName()
    Int held = StorageUtil.GetIntValue(akNPC, "IEB_Held", 0)
    If held == 0 || IEB_Enabled.GetValueInt() != 1
        If IEB_IELib.SlotCountOf(akNPC, _agents) == 0 && IEB_NFFLib.Seated(akNPC)
            ; race: released between action selection and execution
            If stayHere == 1
                IEB_NFFLib.Wait(akNPC)
            Else
                IEB_NFFLib.Follow(akNPC)
            EndIf
            Log(1, "RECALL_REQ actor=" + who + " race=1 stay=" + stayHere)
            Return
        EndIf
        IEB_IELib.PassThroughCancel(akNPC)
        Log(2, "RECALL_REQ actor=" + who + " passthrough=1")
        Return
    EndIf
    If held == 1
        If stayHere == 1
            StorageUtil.SetIntValue(akNPC, "IEB_Recall", 2)
        Else
            StorageUtil.SetIntValue(akNPC, "IEB_Recall", 1)
        EndIf
        IEB_IELib.CancelSlotOf(akNPC)
        Log(1, "RECALL_REQ actor=" + who + " stay=" + stayHere)
    Else
        ; held == 2: rejoin phase
        If stayHere == 1
            ClearKeys(akNPC)
            Log(1, "REJOIN_TO_WAIT actor=" + who + " reason=told_stay")
            IEB_Notice.WaitingAtEnd(who)
        Else
            IEB_NFFLib.Follow(akNPC)
            ClearKeys(akNPC)
            akNPC.EvaluatePackage()
            Log(1, "REJOIN_DONE actor=" + who + " reason=recalled")
            IEB_Notice.Rejoined(who)
        EndIf
    EndIf
    RegisterForSingleUpdate(0.1)
EndFunction

; ============================================================================ logging

Function Log(Int aiLevel, String asMsg)
    If aiLevel > IEB_LogLevel.GetValueInt()
        Return
    EndIf
    Debug.TraceUser("ErrandBridge", asMsg)
    Debug.Trace("[IEB] " + asMsg)
EndFunction
