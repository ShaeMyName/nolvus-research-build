Scriptname IEB_EssLib Hidden
{Errand Bridge: essential followers (investigation/round10/essential_followers_design.md §1-§9; DECISIONS "Every follower
 essential" + Answers Q1-Q4). Global library, never attached, no properties (frozen-shell rule). IEB_Main.Tick calls
 Sweep every 5 ticks (slot 2, never RankSync's slot 0), at the load reconcile, and right after an SA recruit event.

 Per-actor StorageUtil keys (co-save):
   IEB_Ess        1 applied, 2 confirmed (absent = none). IEB_EssBy 1 base flag / 2 NFF faction / 3 SA alias slot.
   IEB_EssAuth    base flag was authored at first sight (1) or not (0).
   IEB_EssKeep    1 = IntelEngine's restore must keep the base flag true (§3.1 handshake; read by the IE §11 fix).
   IEB_EssOptOut  1 = NFF MCM toggle off, 2 = SA UI off (stamp rule, §8.1). Never re-applied while set.
   IEB_EssSusp    1 = suspended by an active-removal window (§7.2). IEB_EssSAwrote 1 = SA WasEssential written (§8.1).
   IEB_EssFail    1 = gave up (ESS_FAIL / ESS_IMPORT_FAIL) until the actor stops being a candidate.
 Global lists (None): IEB_EssList (every tracked actor; the R22 base-Essential diff excludes IEB_Ess >= 1),
   IEB_EssFailList, IEB_EssReqList. IEB_EssOff = 1 on None switches the feature off (no writes, no reverts).

 Window table (private, built offline like quest_integrity.json; never committed in clear):
   Data/SKSE/Plugins/ErrandBridge/ess_windows.json. int "rows" = N (0..64); formList "w_quest" and "w_base" (actor base;
   any form in "any follower" rows); intList "w_any" (1 = any follower), "w_mode" (0 = stay out: no apply, no
   re-assert; 1 = active removal: suspend bridge-set flags), "w_lo", "w_hi" (open while the quest runs and
   w_lo <= stage < w_hi; w_hi < 0 = open from w_lo for as long as the quest runs). All lists N long.
   Missing or malformed table: the feature pauses (WARN once per load). A valid table with rows = 0 means no windows.}

; ============================================================================ entry points (IEB_Main)

Function OnLoad() Global
    {IEB_Main.Setup: once-per-load warnings re-arm.}
    StorageUtil.UnsetIntValue(None, "IEB_EssTblWarned")
    StorageUtil.UnsetIntValue(None, "IEB_EssTblLogged")
EndFunction

Function Request(Actor a) Global
    {SA "recruit" event (SeverActions_FollowerManager.psc:3495-3502, also :1377). It fires before SA changes any state,
     so this only asks for an early sweep; the sweep does the work (request + tick pattern).}
    If a == None
        Return
    EndIf
    StorageUtil.SetIntValue(a, "IEB_EssReq", 3)                    ; sweeps left to see the actor on a route
    StorageUtil.FormListAdd(None, "IEB_EssReqList", a, False)
    StorageUtil.SetIntValue(None, "IEB_EssReqPending", 1)
EndFunction

Bool Function Pending() Global
    Return StorageUtil.GetIntValue(None, "IEB_EssReqPending", 0) == 1
EndFunction

Function Sweep(Int aiLogLevel) Global
    StorageUtil.SetIntValue(None, "IEB_EssLogLvl", aiLogLevel)
    StorageUtil.UnsetIntValue(None, "IEB_EssReqPending")
    If StorageUtil.GetIntValue(None, "IEB_EssOff", 0) == 1
        Return
    EndIf
    If !LoadWindows()
        Return
    EndIf
    WindowPass()
    MaintainAll()

    ; ---- candidates, deduplicated (§1.0 step 2). src: 1 NFF seat, 2 registry follower, 3 SA roster, 4 SA casual enrolled
    Actor[] cand = new Actor[64]
    Int n = 0
    Actor[] seats = IEB_NFFLib.SeatedActors()
    Int i = 0
    While i < seats.Length
        n = AddCand(cand, n, seats[i])
        i += 1
    EndWhile
    Actor[] pf = PO3_SKSEFunctions.GetPlayerFollowers()          ; never a follower test on its own (quest escorts)
    If pf
        i = 0
        While i < pf.Length
            Actor f = pf[i]
            If f != None
                Int cf = IEB_CFLib.RegistryIndex(f)
                If cf >= 0 && IEB_CFLib.Recruited(f, cf)
                    n = AddCand(cand, n, f)
                EndIf
            EndIf
            i += 1
        EndWhile
    EndIf
    Actor[] roster = IEB_SALib.Roster()
    If roster
        i = 0
        While i < roster.Length
            n = AddCand(cand, n, roster[i])
            i += 1
        EndWhile
    EndIf
    Actor[] casual = IEB_SALib.CasualFollowers()
    If casual
        Faction bond = IEB_RankSync.BondFaction()                 ; Q1: casual follows only for enrolled NPCs
        i = 0
        While i < casual.Length
            Actor c = casual[i]
            If c != None && bond != None && c.GetFactionRank(bond) >= 0
                n = AddCand(cand, n, c)
            EndIf
            i += 1
        EndWhile
    EndIf
    i = 0
    While i < n
        Consider(cand[i], IsCasualOnly(cand[i]))
        i += 1
    EndWhile
    RequestPass(cand, n)
    FailPass(cand, n)
EndFunction

; ============================================================================ candidates

Int Function AddCand(Actor[] cand, Int n, Actor a) Global
    If a == None || n >= cand.Length || a == Game.GetPlayer()
        Return n
    EndIf
    Int i = 0
    While i < n
        If cand[i] == a
            Return n
        EndIf
        i += 1
    EndWhile
    cand[n] = a
    Return n + 1
EndFunction

Bool Function IsCasualOnly(Actor a) Global
    {True when the only route is an SA casual follow (no NFF seat, no SA roster, no recruited registry follower).}
    If IEB_NFFLib.Seated(a) || IEB_SALib.IsSAFollower(a)
        Return False
    EndIf
    Int cf = IEB_CFLib.RegistryIndex(a)
    Return !(cf >= 0 && IEB_CFLib.Recruited(a, cf))
EndFunction

Function Consider(Actor a, Bool abCasualOnly) Global
    {First application for a candidate (§1.1-§1.8). Tracked actors are handled by MaintainAll.}
    If a == None || a.IsDead()
        Return
    EndIf
    If StorageUtil.GetIntValue(a, "IEB_Ess", 0) >= 1 || StorageUtil.GetIntValue(a, "IEB_EssFail", 0) == 1
        Return
    EndIf
    If a.IsChild()
        Skip(a, "child", 1)                                        ; flag untouched (design §9)
        Return
    EndIf
    If a.IsDisabled()
        Skip(a, "disabled", 2)
        Return
    EndIf
    If StorageUtil.GetIntValue(a, "IEB_EssOptOut", 0) > 0
        Skip(a, "optout", 2)
        Return
    EndIf
    If IEHolds(a)
        Skip(a, "ie_hold", 1)                                      ; IE's temporary flag must never read as authored
        Return
    EndIf
    ActorBase b = a.GetActorBase()
    Bool seated = IEB_NFFLib.Seated(a)
    Bool rostered = IEB_SALib.IsSAFollower(a)
    Bool inFac = IEB_NFFLib.InEssFac(a)
    If inFac && b.IsEssential()
        ; NFF already shows it ON (Shae's MCM, or an earlier bridge apply): track as the NFF route, no write
        If !StorageUtil.HasIntValue(a, "IEB_EssAuth")
            StorageUtil.SetIntValue(a, "IEB_EssAuth", 0)
        EndIf
        Track(a, 2, 2, 1)
        Log(1, "ESS_ADOPT actor=" + a.GetDisplayName() + " route=nff")
        Return
    EndIf
    If b.IsEssential()
        ; authored (or set by something other than NFF): no write (§1.1, §1.3). Tracked only for SA's WasEssential (§7.1).
        StorageUtil.SetIntValue(a, "IEB_EssAuth", 1)
        Skip(a, "authored", 1)
        StorageUtil.FormListAdd(None, "IEB_EssList", a, False)
        If rostered && StorageUtil.GetIntValue(a, "IEB_EssSAwrote", 0) == 0
            SAStamp(a)
        EndIf
        Return
    EndIf
    If !StorageUtil.HasIntValue(a, "IEB_EssAuth")
        StorageUtil.SetIntValue(a, "IEB_EssAuth", 0)
    EndIf
    String why = TransientSkip(a)
    If why != ""
        Skip(a, why, 2)
        Return
    EndIf
    Int need = 1
    If seated && IEB_NFFLib.IsImport(a)
        Int gate = ImportGate(a)
        If gate == 0
            Return
        ElseIf gate < 0
            Fail(a, "ESS_IMPORT_FAIL", "gate")
            Return
        EndIf
        need = 2                                                   ; §7.4: confirm on the 2nd re-check pass
    EndIf
    Bool uniq = b.IsUnique() && b == a.GetLeveledActorBase()
    String was = " base_was=" + (b.IsEssential() as Int) + " prot=" + (b.IsProtected() as Int)
    If !uniq
        If rostered && !abCasualOnly
            IEB_SALib.SlotOn(a)
            Track(a, 1, 3, need)
            Log(1, "ESS_APPLY actor=" + a.GetDisplayName() + " route=sa_slot" + was)
        Else
            Skip(a, "shared_base", 1)
        EndIf
        Return
    EndIf
    If seated
        If inFac
            b.SetEssential(True)                                   ; faction kept; never toggle a member (§1.1)
        ElseIf !IEB_NFFLib.EssentialOn(a)
            Skip(a, "nff_unavailable", 1)
            Return
        EndIf
        Track(a, 1, 2, need)
        Log(1, "ESS_APPLY actor=" + a.GetDisplayName() + " route=nff" + was)
        Return
    EndIf
    b.SetEssential(True)
    Track(a, 1, 1, need)
    Log(1, "ESS_APPLY actor=" + a.GetDisplayName() + " route=base" + was)
EndFunction

Int Function ImportGate(Actor a) Global
    {§7.4 bounded wait. 1 = apply now, 0 = not yet, -1 = give up. Detection = NFF seat + nwsFF_ImportFac. The gate holds
     in nwsFF_ImportSetFac (SetImportLight started, ExScript :584) outside menus. SetImportLight runs only for imports
     with NFF's defaults option (nwsFollowerControllerScript.psc:841-843); without it ImportSetFac never appears and
     no reset is pending, so a seat that still lacks it on the 2nd detection pass also passes.}
    Float now = Utility.GetCurrentRealTime()
    Float last = StorageUtil.GetFloatValue(a, "IEB_EssImpAt", -1.0)
    Int k = StorageUtil.GetIntValue(a, "IEB_EssImp", 0)
    If last < 0.0 || now < last || now - last > 30.0
        k = 0                                                      ; stale count from an earlier seat
    EndIf
    k += 1
    StorageUtil.SetIntValue(a, "IEB_EssImp", k)
    StorageUtil.SetFloatValue(a, "IEB_EssImpAt", now)
    If !Utility.IsInMenuMode()
        If IEB_NFFLib.ImportSetDone(a) || k >= 2
            Return 1
        EndIf
    EndIf
    If k >= 3
        Return -1
    EndIf
    Return 0
EndFunction

String Function TransientSkip(Actor a) Global
    {Skips that end on their own (§1.4, §1.1, §5, §1.8).}
    If StorageUtil.HasIntValue(a, "SeverCombat_OriginalRelationship")
        Return "sa_brawl"
    EndIf
    If IEB_NFFLib.Sparring(a)
        Return "sparring"
    EndIf
    If WindowHit(a, -1) >= 0
        Return "window"
    EndIf
    If StoryAliasHeld(a)
        Return "story_alias"
    EndIf
    Return ""
EndFunction

Function RequestPass(Actor[] cand, Int n) Global
    Int i = StorageUtil.FormListCount(None, "IEB_EssReqList") - 1
    While i >= 0
        Actor a = StorageUtil.FormListGet(None, "IEB_EssReqList", i) as Actor
        Int left = 0
        If a != None && !InArr(cand, n, a)
            left = StorageUtil.GetIntValue(a, "IEB_EssReq", 0) - 1
        EndIf
        If left > 0
            StorageUtil.SetIntValue(a, "IEB_EssReq", left)
            StorageUtil.SetIntValue(None, "IEB_EssReqPending", 1)   ; look again on the next tick
        Else
            If a != None
                StorageUtil.UnsetIntValue(a, "IEB_EssReq")
            EndIf
            StorageUtil.FormListRemoveAt(None, "IEB_EssReqList", i)
        EndIf
        i -= 1
    EndWhile
EndFunction

Function FailPass(Actor[] cand, Int n) Global
    {A give-up holds until the actor's next recruit or seat change: cleared once the actor is no longer a candidate.}
    Int i = StorageUtil.FormListCount(None, "IEB_EssFailList") - 1
    While i >= 0
        Actor a = StorageUtil.FormListGet(None, "IEB_EssFailList", i) as Actor
        If a == None || !InArr(cand, n, a)
            If a != None
                StorageUtil.UnsetIntValue(a, "IEB_EssFail")
                StorageUtil.UnsetIntValue(a, "IEB_EssImp")
                StorageUtil.UnsetFloatValue(a, "IEB_EssImpAt")
            EndIf
            StorageUtil.FormListRemoveAt(None, "IEB_EssFailList", i)
        EndIf
        i -= 1
    EndWhile
EndFunction

Bool Function InArr(Actor[] arr, Int n, Actor a) Global
    Int i = 0
    While i < n
        If arr[i] == a
            Return True
        EndIf
        i += 1
    EndWhile
    Return False
EndFunction

; ============================================================================ tracked actors

Function MaintainAll() Global
    Int i = StorageUtil.FormListCount(None, "IEB_EssList") - 1
    While i >= 0
        Actor a = StorageUtil.FormListGet(None, "IEB_EssList", i) as Actor
        If a == None
            StorageUtil.FormListRemoveAt(None, "IEB_EssList", i)
        ElseIf !a.IsDead()
            Maintain(a)
        EndIf
        i -= 1
    EndWhile
EndFunction

Function Maintain(Actor a) Global
    String who = a.GetDisplayName()
    ActorBase b = a.GetActorBase()
    Int ess = StorageUtil.GetIntValue(a, "IEB_Ess", 0)
    Int by = StorageUtil.GetIntValue(a, "IEB_EssBy", 0)
    Int susp = StorageUtil.GetIntValue(a, "IEB_EssSusp", 0)
    Int opt = StorageUtil.GetIntValue(a, "IEB_EssOptOut", 0)
    Bool rostered = IEB_SALib.IsSAFollower(a)
    Bool ieNow = IEHolds(a)
    Bool ieEnded = StorageUtil.GetIntValue(a, "IEB_EssIEHeld", 0) == 1 && !ieNow
    If ieNow
        StorageUtil.SetIntValue(a, "IEB_EssIEHeld", 1)
    Else
        StorageUtil.UnsetIntValue(a, "IEB_EssIEHeld")
    EndIf

    ; §8.1: SA's WasEssential false on an actor we stamped = Shae's SA-UI opt-out (checked before any re-assert)
    If susp == 0 && opt == 0 && rostered && StorageUtil.GetIntValue(a, "IEB_EssSAwrote", 0) == 1 && !IEB_SALib.GetWasEssential(a)
        OptOut(a, 2, "sa_ui")
        Return
    EndIf
    If opt == 1
        If IEB_NFFLib.InEssFac(a)
            StorageUtil.UnsetIntValue(a, "IEB_EssOptOut")          ; Shae switched it on again in NFF's MCM
            StorageUtil.SetIntValue(a, "IEB_EssKeep", 1)
            Log(1, "ESS_OPTIN actor=" + who + " via=nff_mcm")
        EndIf
        Return
    ElseIf opt == 2
        If rostered && !IEB_SALib.EssentialOff(a)
            StorageUtil.UnsetIntValue(a, "IEB_EssOptOut")          ; SA UI back ON; the stamp is rewritten below
            If by == 1 || by == 2
                StorageUtil.SetIntValue(a, "IEB_EssKeep", 1)
            EndIf
            Log(1, "ESS_OPTIN actor=" + who + " via=sa_ui")
        Else
            Return
        EndIf
    EndIf

    If ess == 0
        ; authored, no write: SA stamp only. A lost authored flag makes the actor an ordinary candidate again.
        If !b.IsEssential()
            Log(1, "ESS_LOST actor=" + who + " why=external authored=1")
            StorageUtil.UnsetStringValue(a, "IEB_EssSkip")
            StorageUtil.FormListRemove(None, "IEB_EssList", a, True)
        ElseIf rostered && StorageUtil.GetIntValue(a, "IEB_EssSAwrote", 0) == 0
            SAStamp(a)
        EndIf
        Return
    EndIf
    If susp == 1
        Return                                                     ; no re-assert, no opt-out test (§7.2)
    EndIf
    If ess == 1
        ConfirmStep(a, by, rostered)
        Return
    EndIf

    ; ---- confirmed
    If by == 3
        If !rostered
            Untrack(a)                                             ; SA frees its slot on dismiss; not re-held (§2 a)
            Log(1, "ESS_SLOT_FREED actor=" + who)
        ElseIf StorageUtil.GetIntValue(a, "IEB_EssSAwrote", 0) == 0
            SAStamp(a)
        EndIf
        Return
    EndIf
    If rostered && StorageUtil.GetIntValue(a, "IEB_EssSAwrote", 0) == 0
        SAStamp(a)
    EndIf
    If by == 2 && !IEB_NFFLib.InEssFac(a)
        OptOut(a, 1, "nff_mcm")                                    ; only NFF's toggle removes the faction (§7.3)
        Return
    EndIf
    If b.IsEssential()
        StorageUtil.UnsetIntValue(a, "IEB_EssLost")
        Return
    EndIf
    If ieEnded
        Reassert(a, "ie_restore")
    Else
        Reassert(a, "external")
    EndIf
EndFunction

Function ConfirmStep(Actor a, Int by, Bool rostered) Global
    {§1.8 two-phase: confirm on a sweep at least 5 s after the apply; one re-apply if the flag is gone.}
    If IEB_NFFLib.Sparring(a) || StorageUtil.HasIntValue(a, "SeverCombat_OriginalRelationship") || IEHolds(a)
        Return                                                     ; wait; the pass does not count
    EndIf
    Float now = Utility.GetCurrentRealTime()
    Float at = StorageUtil.GetFloatValue(a, "IEB_EssAt", 0.0)
    If now >= at && now - at < 5.0
        Return
    EndIf
    Int pass = StorageUtil.GetIntValue(a, "IEB_EssPass", 0) + 1
    StorageUtil.SetIntValue(a, "IEB_EssPass", pass)
    Int need = StorageUtil.GetIntValue(a, "IEB_EssPassNeed", 1)
    Bool imp = need >= 2
    If FlagOn(a, by)
        If pass >= need
            StorageUtil.SetIntValue(a, "IEB_Ess", 2)
            If by == 1 || by == 2
                StorageUtil.SetIntValue(a, "IEB_EssKeep", 1)
            EndIf
            StorageUtil.UnsetIntValue(a, "IEB_EssImp")
            StorageUtil.UnsetFloatValue(a, "IEB_EssImpAt")
            Log(1, "ESS_CONFIRM actor=" + a.GetDisplayName() + " by=" + by + " passes=" + pass)
            If rostered && StorageUtil.GetIntValue(a, "IEB_EssSAwrote", 0) == 0
                SAStamp(a)
            EndIf
        EndIf
        Return
    EndIf
    String why = TransientSkip(a)
    If why != ""
        Log(2, "ESS_CONFIRM_WAIT actor=" + a.GetDisplayName() + " why=" + why)
        Return
    EndIf
    If StorageUtil.GetIntValue(a, "IEB_EssRetry", 0) == 0
        StorageUtil.SetIntValue(a, "IEB_EssRetry", 1)
        Reapply(a, by)
        If !imp
            StorageUtil.SetIntValue(a, "IEB_EssPass", 0)           ; another full confirm pass for the re-apply
        EndIf
        StorageUtil.SetFloatValue(a, "IEB_EssAt", now)
        Log(1, "ESS_APPLY actor=" + a.GetDisplayName() + " by=" + by + " retry=1")
        Return
    EndIf
    If pass < need
        Return                                                     ; import: still inside the 2 re-check passes
    EndIf
    If imp
        Fail(a, "ESS_IMPORT_FAIL", "lost")
    Else
        Fail(a, "ESS_FAIL", "lost")
    EndIf
EndFunction

Bool Function FlagOn(Actor a, Int by) Global
    If by == 3
        Return IEB_SALib.InSlot(a)
    ElseIf by == 2
        Return a.GetActorBase().IsEssential() && IEB_NFFLib.InEssFac(a)
    EndIf
    Return a.GetActorBase().IsEssential()
EndFunction

Function Reapply(Actor a, Int by) Global
    If by == 3
        IEB_SALib.SlotOn(a)
    ElseIf by == 2 && !IEB_NFFLib.InEssFac(a)
        IEB_NFFLib.EssentialOn(a)                                  ; import defaults removed the faction (ExScript :623)
    Else
        a.GetActorBase().SetEssential(True)
    EndIf
EndFunction

Function Reassert(Actor a, String asWhy) Global
    {§3.1: confirmed, base flag lost. Re-assert unless a window or the story-alias skip matches; then log and let the
     quest proceed.}
    If a.IsDisabled() || IEHolds(a) || IEB_NFFLib.Sparring(a) || StorageUtil.HasIntValue(a, "SeverCombat_OriginalRelationship")
        Return
    EndIf
    If WindowHit(a, -1) >= 0 || StoryAliasHeld(a)
        If StorageUtil.GetIntValue(a, "IEB_EssLost", 0) == 0
            StorageUtil.SetIntValue(a, "IEB_EssLost", 1)
            Log(1, "ESS_LOST actor=" + a.GetDisplayName() + " why=external")
        EndIf
        Return
    EndIf
    a.GetActorBase().SetEssential(True)
    StorageUtil.SetIntValue(a, "IEB_EssKeep", 1)
    StorageUtil.UnsetIntValue(a, "IEB_EssLost")
    Log(1, "ESS_REASSERT actor=" + a.GetDisplayName() + " why=" + asWhy)
EndFunction

Function OptOut(Actor a, Int aiSrc, String asVia) Global
    StorageUtil.SetIntValue(a, "IEB_EssOptOut", aiSrc)
    StorageUtil.UnsetIntValue(a, "IEB_EssKeep")
    If aiSrc == 2
        StorageUtil.UnsetIntValue(a, "IEB_EssSAwrote")             ; rewritten only after Shae turns SA's toggle on again
    EndIf
    Log(1, "ESS_OPTOUT actor=" + a.GetDisplayName() + " via=" + asVia)
EndFunction

Function SAStamp(Actor a) Global
    {§7.1 + §8.1: SA WasEssential = true, once, stamped.}
    IEB_SALib.SetWasEssential(a)
    StorageUtil.SetIntValue(a, "IEB_EssSAwrote", 1)
    Log(1, "ESS_SA_WASESS actor=" + a.GetDisplayName())
EndFunction

Function Track(Actor a, Int aiEss, Int aiBy, Int aiNeed) Global
    StorageUtil.SetIntValue(a, "IEB_Ess", aiEss)
    StorageUtil.SetIntValue(a, "IEB_EssBy", aiBy)
    StorageUtil.SetFloatValue(a, "IEB_EssAt", Utility.GetCurrentRealTime())
    StorageUtil.SetIntValue(a, "IEB_EssPass", 0)
    StorageUtil.SetIntValue(a, "IEB_EssPassNeed", aiNeed)
    StorageUtil.UnsetIntValue(a, "IEB_EssRetry")
    StorageUtil.UnsetIntValue(a, "IEB_EssLost")
    StorageUtil.UnsetStringValue(a, "IEB_EssSkip")
    If aiBy == 1 || aiBy == 2
        StorageUtil.SetIntValue(a, "IEB_EssKeep", 1)
    EndIf
    StorageUtil.FormListAdd(None, "IEB_EssList", a, False)
EndFunction

Function Untrack(Actor a) Global
    StorageUtil.UnsetIntValue(a, "IEB_Ess")
    StorageUtil.UnsetIntValue(a, "IEB_EssBy")
    StorageUtil.UnsetFloatValue(a, "IEB_EssAt")
    StorageUtil.UnsetIntValue(a, "IEB_EssPass")
    StorageUtil.UnsetIntValue(a, "IEB_EssPassNeed")
    StorageUtil.UnsetIntValue(a, "IEB_EssRetry")
    StorageUtil.UnsetIntValue(a, "IEB_EssKeep")
    StorageUtil.UnsetIntValue(a, "IEB_EssSusp")
    StorageUtil.UnsetIntValue(a, "IEB_EssLost")
    StorageUtil.UnsetIntValue(a, "IEB_EssIEHeld")
    StorageUtil.FormListRemove(None, "IEB_EssList", a, True)
EndFunction

Function Fail(Actor a, String asTag, String asWhy) Global
    Untrack(a)
    StorageUtil.SetIntValue(a, "IEB_EssFail", 1)
    StorageUtil.FormListAdd(None, "IEB_EssFailList", a, False)
    Log(0, "WARN " + asTag + " actor=" + a.GetDisplayName() + " why=" + asWhy)
EndFunction

Function Skip(Actor a, String asWhy, Int aiLevel) Global
    {Logged once per reason change, so a standing skip doesn't repeat every sweep.}
    If StorageUtil.GetStringValue(a, "IEB_EssSkip", "") != asWhy
        StorageUtil.SetStringValue(a, "IEB_EssSkip", asWhy)
        Log(aiLevel, "ESS_SKIP actor=" + a.GetDisplayName() + " why=" + asWhy)
    EndIf
EndFunction

Bool Function IEHolds(Actor a) Global
    {IntelEngine holds a temporary base flag on this actor: rescue victim (Intel_WasEssential, StoryEngine :3745) or
     ambush combat (Intel_CombatStartTime, :3001-3010).}
    Return StorageUtil.HasIntValue(a, "Intel_WasEssential") || StorageUtil.HasFloatValue(a, "Intel_CombatStartTime")
EndFunction

; ============================================================================ windows (§5, §7.2)

String Function WinFile() Global
    Return "../ErrandBridge/ess_windows"
EndFunction

Bool Function LoadWindows() Global
    {Evaluates every row once per sweep into IntList None "IEB_EssWOpen" (-1 closed, else the row's mode).}
    String f = WinFile()
    String bad = ""
    Int rows = -1
    If !JsonUtil.JsonExists(f)
        bad = "missing"
    ElseIf !JsonUtil.IsGood(f)
        bad = "parse"
    Else
        rows = JsonUtil.GetIntValue(f, "rows", -1)
        If rows < 0 || rows > 64
            bad = "rows"
        ElseIf JsonUtil.FormListCount(f, "w_quest") != rows || JsonUtil.FormListCount(f, "w_base") != rows || \
               JsonUtil.IntListCount(f, "w_any") != rows || JsonUtil.IntListCount(f, "w_mode") != rows || \
               JsonUtil.IntListCount(f, "w_lo") != rows || JsonUtil.IntListCount(f, "w_hi") != rows
            bad = "lists"
        EndIf
    EndIf
    StorageUtil.IntListClear(None, "IEB_EssWOpen")
    If bad != ""
        If StorageUtil.GetIntValue(None, "IEB_EssTblWarned", 0) == 0
            StorageUtil.SetIntValue(None, "IEB_EssTblWarned", 1)
            Log(0, "WARN ESS_TABLE bad=" + bad + " (essential followers paused)")
        EndIf
        Return False
    EndIf
    If StorageUtil.GetIntValue(None, "IEB_EssTblLogged", 0) == 0
        StorageUtil.SetIntValue(None, "IEB_EssTblLogged", 1)
        Log(1, "ESS_TABLE rows=" + rows)
    EndIf
    Int i = 0
    While i < rows
        Int open = -1
        Quest q = JsonUtil.FormListGet(f, "w_quest", i) as Quest
        If q != None && q.IsRunning()
            Int st = q.GetStage()
            Int hi = JsonUtil.IntListGet(f, "w_hi", i)
            If st >= JsonUtil.IntListGet(f, "w_lo", i) && (hi < 0 || st < hi)
                open = JsonUtil.IntListGet(f, "w_mode", i)
            EndIf
        EndIf
        StorageUtil.IntListAdd(None, "IEB_EssWOpen", open)
        i += 1
    EndWhile
    Return True
EndFunction

Int Function WindowHit(Actor a, Int aiMode) Global
    {First open row that covers this actor (aiMode -1 = any mode), or -1.}
    Int n = StorageUtil.IntListCount(None, "IEB_EssWOpen")
    If n <= 0
        Return -1
    EndIf
    String f = WinFile()
    Form b = a.GetActorBase()
    Form lb = a.GetLeveledActorBase()
    Int i = 0
    While i < n
        Int open = StorageUtil.IntListGet(None, "IEB_EssWOpen", i)
        If open >= 0 && (aiMode < 0 || open == aiMode)
            If JsonUtil.IntListGet(f, "w_any", i) == 1
                Return i
            EndIf
            Form wb = JsonUtil.FormListGet(f, "w_base", i)
            If wb != None && (wb == b || wb == lb)
                Return i
            EndIf
        EndIf
        i += 1
    EndWhile
    Return -1
EndFunction

Function WindowPass() Global
    {§7.2 active removal: suspend only flags the bridge set (IEB_EssBy 1/2/3) while a mode-1 row covers the actor;
     restore the same way when it closes. Authored flags are never touched.}
    Int i = StorageUtil.FormListCount(None, "IEB_EssList") - 1
    While i >= 0
        Actor a = StorageUtil.FormListGet(None, "IEB_EssList", i) as Actor
        If a != None
            Int by = StorageUtil.GetIntValue(a, "IEB_EssBy", 0)
            Int susp = StorageUtil.GetIntValue(a, "IEB_EssSusp", 0)
            If StorageUtil.GetIntValue(a, "IEB_Ess", 0) >= 1 && by >= 1
                If a.IsDead()
                    If susp == 1
                        StorageUtil.UnsetIntValue(a, "IEB_EssSusp")
                    EndIf
                Else
                    Int row = WindowHit(a, 1)
                    If row >= 0 && susp == 0 && StorageUtil.GetIntValue(a, "IEB_EssOptOut", 0) == 0
                        Suspend(a, by, row)
                    ElseIf row < 0 && susp == 1
                        Resume(a, by)
                    EndIf
                EndIf
            EndIf
        EndIf
        i -= 1
    EndWhile
EndFunction

Function Suspend(Actor a, Int by, Int row) Global
    If by == 3
        IEB_SALib.SlotOff(a)
    Else
        a.GetActorBase().SetEssential(False)                       ; NFF route: faction kept as the suspended intent
    EndIf
    StorageUtil.SetIntValue(a, "IEB_EssSusp", 1)
    StorageUtil.UnsetIntValue(a, "IEB_EssKeep")
    Log(1, "ESS_SUSPEND actor=" + a.GetDisplayName() + " by=" + by + " row=" + row)
EndFunction

Function Resume(Actor a, Int by) Global
    StorageUtil.UnsetIntValue(a, "IEB_EssSusp")
    If by == 2 && !IEB_NFFLib.InEssFac(a)
        OptOut(a, 1, "nff_mcm")                                    ; switched off in NFF's MCM during the window
        Return
    EndIf
    If by == 3
        IEB_SALib.SlotOn(a)
    Else
        a.GetActorBase().SetEssential(True)
        StorageUtil.SetIntValue(a, "IEB_EssKeep", 1)
    EndIf
    Log(1, "ESS_RESUME actor=" + a.GetDisplayName() + " by=" + by)
EndFunction

; ============================================================================ story-alias skip (§1.8)

Bool Function StoryAliasHeld(Actor a) Global
    {The Q guard's tier-1 test, mirrored from the patched IntelEngine_StoryEngine.IEB_QuestReserved (tier 1): in a
     scene, or holding an alias in a running, non-exempt quest that is in quest_integrity.json's story_quests or has an
     open objective. Same file, same lists, so the two agree. Keep in step with that function.}
    If a.GetCurrentScene() != None
        Return True
    EndIf
    String qi = "../ErrandBridge/quest_integrity"
    Int n = a.GetNumReferenceAliases()
    Int i = 0
    While i < n
        ReferenceAlias ra = a.GetNthReferenceAlias(i)
        Quest q = None
        If ra
            q = ra.GetOwningQuest()
        EndIf
        If q && (q.IsRunning() || q.IsStarting()) && !ExemptQuest(q, qi)
            If JsonUtil.FormListHas(qi, "story_quests", q) || HasOpenObjective(q)
                Return True
            EndIf
        EndIf
        i += 1
    EndWhile
    Return False
EndFunction

Bool Function ExemptQuest(Quest q, String qi) Global
    String modName = PO3_SKSEFunctions.GetFormModName(q, false)
    Int n = JsonUtil.StringListCount(qi, "exempt_plugins")
    Int i = 0
    While i < n
        If JsonUtil.StringListGet(qi, "exempt_plugins", i) == modName
            Return True
        EndIf
        i += 1
    EndWhile
    Return False
EndFunction

Bool Function HasOpenObjective(Quest q) Global
    Int[] objs = PO3_SKSEFunctions.GetAllQuestObjectives(q)
    Int i = 0
    While i < objs.Length
        If q.IsObjectiveDisplayed(objs[i]) && !q.IsObjectiveCompleted(objs[i])
            Return True
        EndIf
        i += 1
    EndWhile
    Return False
EndFunction

; ============================================================================ logging

Function Log(Int aiLevel, String asMsg) Global
    If aiLevel > StorageUtil.GetIntValue(None, "IEB_EssLogLvl", 1)
        Return
    EndIf
    Debug.TraceUser("ErrandBridge", asMsg)
    Debug.Trace("[IEB] " + asMsg)
EndFunction
