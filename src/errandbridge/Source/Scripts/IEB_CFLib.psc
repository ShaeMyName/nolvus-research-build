Scriptname IEB_CFLib Hidden
{Errand Bridge: Mode 4 custom-framework followers (spec §6.5). Global library, never attached. The registry data
 (identity, recruited, refuse, park kind) is generated into IEB_CFData from the verified JSON; this script holds the
 term helpers and the take/upkeep/release rules. Never calls NFF on a Mode 4 actor.}

; ============================================================================ registry access

Int Function RegistryIndex(Actor a) Global
    Return IEB_CFData.IndexOf(a)
EndFunction

Bool Function Recruited(Actor a, Int cf) Global
    If cf < 0
        Return False
    EndIf
    Return IEB_CFData.Recruited(cf, a)
EndFunction

String Function RefuseReason(Actor a, Int cf) Global
    If cf < 0
        Return ""
    EndIf
    Return IEB_CFData.RefuseReason(cf, a)
EndFunction

; ============================================================================ park / unpark

Function Park(Actor a, Int cf) Global
    {Take, step 2. wfp+global: the mod's wait global = 1, then WFP = 1. wfp: WFP = 1. none: nothing.}
    String kind = IEB_CFData.ParkKind(cf)
    If kind == "wfp+global"
        GlobalVariable g = IEB_CFData.GWait(cf)
        If g != None
            If !StorageUtil.HasFloatValue(a, "IEB_CF_PreGlobal")
                StorageUtil.SetFloatValue(a, "IEB_CF_PreGlobal", g.GetValue())
            EndIf
            g.SetValue(1.0)
            StorageUtil.SetFloatValue(a, "IEB_CF_LastGlobal", 1.0)
        EndIf
        a.SetActorValue("WaitingForPlayer", 1.0)
    ElseIf kind == "wfp"
        a.SetActorValue("WaitingForPlayer", 1.0)
    EndIf
    If IEB_CFData.Name(cf) == "Inigo"
        StorageUtil.SetIntValue(a, "IEB_CF_LastSummon", FacRank(a, 0x000A0957, "Inigo.esp"))
    EndIf
EndFunction

Function Unpark(Actor a, Int cf, Float afPreWFP) Global
    {Release, otherwise-branch: WFP back to IEB_PreWait and the wait global back to IEB_CF_PreGlobal.}
    String kind = IEB_CFData.ParkKind(cf)
    If kind == "wfp" || kind == "wfp+global"
        a.SetActorValue("WaitingForPlayer", afPreWFP)
    EndIf
    If kind == "wfp+global"
        GlobalVariable g = IEB_CFData.GWait(cf)
        If g != None && StorageUtil.HasFloatValue(a, "IEB_CF_PreGlobal")
            g.SetValue(StorageUtil.GetFloatValue(a, "IEB_CF_PreGlobal", 0.0))
        EndIf
    EndIf
    If IEB_CFData.Name(cf) == "Inigo"
        ; WFP -1 now, 0 at the take, still a teammate -> back to 0
        If a.GetActorValue("WaitingForPlayer") == -1.0 && afPreWFP == 0.0 && a.IsPlayerTeammate()
            a.SetActorValue("WaitingForPlayer", 0.0)
        EndIf
    EndIf
    StorageUtil.UnsetFloatValue(a, "IEB_CF_PreGlobal")
    StorageUtil.UnsetFloatValue(a, "IEB_CF_LastGlobal")
    StorageUtil.UnsetIntValue(a, "IEB_CF_LastSummon")
EndFunction

Int Function ParkUndone(Actor a, Int cf, Float afLastWFP, Float afWFP) Global
    {Upkeep: 0 nothing; 1 the park was undone from outside (recall, follow); 2 told to wait (recall, stay).}
    String who = IEB_CFData.Name(cf)
    If who == "Inigo"
        Int last = StorageUtil.GetIntValue(a, "IEB_CF_LastSummon", 1)
        Int now = FacRank(a, 0x000A0957, "Inigo.esp")
        StorageUtil.SetIntValue(a, "IEB_CF_LastSummon", now)
        If last == 1 && now != 1
            Return 1                                   ; summon rank left 1: player recall
        EndIf
        If afLastWFP == 0.0 && afWFP != 0.0
            Return 2                                   ; WFP left 0: the player told him to wait
        EndIf
        Return 0
    EndIf
    If who == "Serana" && SeranaBool("IsWaiting")
        Return 2                                       ; her own wait topic mid-errand
    EndIf
    String kind = IEB_CFData.ParkKind(cf)
    If (kind == "wfp" || kind == "wfp+global") && afLastWFP == 1.0 && afWFP == 0.0
        Return 1
    EndIf
    If kind == "wfp+global"
        GlobalVariable g = IEB_CFData.GWait(cf)
        If g != None
            Float lastG = StorageUtil.GetFloatValue(a, "IEB_CF_LastGlobal", 1.0)
            Float nowG = g.GetValue()
            StorageUtil.SetFloatValue(a, "IEB_CF_LastGlobal", nowG)
            If lastG == 1.0 && nowG == 0.0
                Return 1
            EndIf
        EndIf
    EndIf
    Return 0
EndFunction

Function ReleaseFixups(Actor a, Int cf) Global
    {Serana: a release after a mid-errand dismissal sets WFP back to 0 (her re-hire path never clears it).}
    If IEB_CFData.Name(cf) == "Serana" && !Recruited(a, cf)
        a.SetActorValue("WaitingForPlayer", 0.0)
    EndIf
EndFunction

; ============================================================================ SA catch-up pause (S-34 b2)

Function CatchupPauseUpdate(Int aiEnabled) Global
    {While any Inigo Mode 4 hold is active and IEB_CFPauseCatchup == 1: SA CellCatchup off. SA pushes its own value
     back on every load, so this is re-applied by the load reconcile. At the last release: restore the saved value.}
    Bool need = aiEnabled == 1 && InigoHoldActive()
    Bool paused = StorageUtil.GetIntValue(None, "IEB_CF_CatchupPaused", 0) == 1
    If need
        If !paused
            StorageUtil.SetIntValue(None, "IEB_CF_CatchupPrev", IEB_SALib.CatchupEnabled() as Int)
            StorageUtil.SetIntValue(None, "IEB_CF_CatchupPaused", 1)
        EndIf
        IEB_SALib.SetCatchup(False)
    ElseIf paused
        IEB_SALib.SetCatchup(StorageUtil.GetIntValue(None, "IEB_CF_CatchupPrev", 1) == 1)
        StorageUtil.UnsetIntValue(None, "IEB_CF_CatchupPaused")
        StorageUtil.UnsetIntValue(None, "IEB_CF_CatchupPrev")
    EndIf
EndFunction

Bool Function InigoHoldActive() Global
    Int n = StorageUtil.FormListCount(None, "IEB_HeldList")
    Int i = 0
    While i < n
        Actor a = StorageUtil.FormListGet(None, "IEB_HeldList", i) as Actor
        If a != None && StorageUtil.GetIntValue(a, "IEB_Mode", 0) == 4 && StorageUtil.GetIntValue(a, "IEB_Held", 0) == 1
            If IEB_CFData.Name(StorageUtil.GetIntValue(a, "IEB_CF", -1)) == "Inigo"
                Return True
            EndIf
        EndIf
        i += 1
    EndWhile
    Return False
EndFunction

; ============================================================================ term helpers (all plugin-guarded)

Bool Function Has(String asPlugin) Global
    Return Game.IsPluginInstalled(asPlugin)
EndFunction

Float Function Glob(Int aiForm, String asPlugin) Global
    If !Has(asPlugin)
        Return -99999.0
    EndIf
    GlobalVariable g = Game.GetFormFromFile(aiForm, asPlugin) as GlobalVariable
    If g == None
        Return -99999.0
    EndIf
    Return g.GetValue()
EndFunction

Bool Function InFac(Actor a, Int aiForm, String asPlugin) Global
    If !Has(asPlugin)
        Return False
    EndIf
    Faction f = Game.GetFormFromFile(aiForm, asPlugin) as Faction
    Return f != None && a.IsInFaction(f)
EndFunction

Int Function FacRank(Actor a, Int aiForm, String asPlugin) Global
    If !Has(asPlugin)
        Return -99
    EndIf
    Faction f = Game.GetFormFromFile(aiForm, asPlugin) as Faction
    If f == None
        Return -99
    EndIf
    Return a.GetFactionRank(f)
EndFunction

Quest Function Q(Int aiForm, String asPlugin) Global
    If !Has(asPlugin)
        Return None
    EndIf
    Return Game.GetFormFromFile(aiForm, asPlugin) as Quest
EndFunction

Bool Function QRun(Int aiForm, String asPlugin) Global
    Quest qq = Q(aiForm, asPlugin)
    Return qq != None && qq.IsRunning()
EndFunction

Bool Function StageIn(Int aiForm, String asPlugin, String asList) Global
    Quest qq = Q(aiForm, asPlugin)
    If qq == None
        Return False
    EndIf
    Return StringUtil.Find(asList, "|" + qq.GetStage() + "|") >= 0
EndFunction

Bool Function StageRange(Int aiForm, String asPlugin, Int aiMin, Int aiMax) Global
    Quest qq = Q(aiForm, asPlugin)
    If qq == None
        Return False
    EndIf
    Int s = qq.GetStage()
    Return s >= aiMin && s <= aiMax
EndFunction

Bool Function StageDone(Int aiForm, String asPlugin, Int aiStage) Global
    Quest qq = Q(aiForm, asPlugin)
    Return qq != None && qq.IsStageDone(aiStage)
EndFunction

Bool Function AliasHolds(Actor a, Int aiQuest, String asPlugin, Int aiAlias) Global
    Quest qq = Q(aiQuest, asPlugin)
    If qq == None
        Return False
    EndIf
    ReferenceAlias ra = qq.GetAlias(aiAlias) as ReferenceAlias
    Return ra != None && ra.GetActorReference() == a
EndFunction

Bool Function AliasFilled(Int aiQuest, String asPlugin, Int aiAlias) Global
    {True when the alias holds any reference (e.g. Inigo's steed alias: he owns a horse).}
    Quest qq = Q(aiQuest, asPlugin)
    If qq == None
        Return False
    EndIf
    ReferenceAlias ra = qq.GetAlias(aiAlias) as ReferenceAlias
    Return ra != None && ra.GetReference() != None
EndFunction

Bool Function InCell(Actor akSubject, Int aiForm, String asPlugin) Global
    If !Has(asPlugin)
        Return False
    EndIf
    Cell c = Game.GetFormFromFile(aiForm, asPlugin) as Cell
    Return c != None && akSubject.GetParentCell() == c
EndFunction

Bool Function InLoc(Actor akSubject, Int aiForm, String asPlugin) Global
    If !Has(asPlugin)
        Return False
    EndIf
    Location l = Game.GetFormFromFile(aiForm, asPlugin) as Location
    Return l != None && akSubject.IsInLocation(l)
EndFunction

Bool Function ScenePlaying(Int aiForm, String asPlugin) Global
    If !Has(asPlugin)
        Return False
    EndIf
    Scene sc = Game.GetFormFromFile(aiForm, asPlugin) as Scene
    Return sc != None && sc.IsPlaying()
EndFunction

DLC1_NPCMentalModelScript Function SeranaCtl() Global
    Return Game.GetFormFromFile(0x00002B6E, "Dawnguard.esm") as DLC1_NPCMentalModelScript
EndFunction

Bool Function SeranaBool(String asProp) Global
    {Serana's controller quest (Dawnguard 0x002B6E) read through the vanilla DLC1_NPCMentalModelScript.}
    DLC1_NPCMentalModelScript c = SeranaCtl()
    If c == None
        Return False
    EndIf
    If asProp == "IsFollowing"
        Return c.IsFollowing
    ElseIf asProp == "IsDismissed"
        Return c.IsDismissed
    ElseIf asProp == "IsWillingToWait"
        Return c.IsWillingToWait
    ElseIf asProp == "LockedIn"
        Return c.LockedIn
    ElseIf asProp == "SimpleFollow"
        Return c.SimpleFollow
    ElseIf asProp == "TurnOffComeWithMe"
        Return c.TurnOffComeWithMe
    ElseIf asProp == "IsWaiting"
        Return c.IsWaiting
    ElseIf asProp == "QuestLineCompleted"
        Return c.QuestLineCompleted
    EndIf
    Debug.Trace("[IEB] SeranaBool: unknown property " + asProp)
    Return False
EndFunction

Bool Function MarasOn() Global
    Return Game.IsPluginInstalled("TT_MARAS.esp")
EndFunction
