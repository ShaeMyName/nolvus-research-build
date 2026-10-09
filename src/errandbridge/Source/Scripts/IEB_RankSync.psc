Scriptname IEB_RankSync Hidden
{Errand Bridge: one-way vanilla relationship-rank sync (spec §11.14.1, S-33). Global library, never attached.
 LIST A: this script must exist from Lucienne's first load, because the patched Relationships SyncBondRank calls
 Apply on every tier write.

 Reads: the Relationships tier (rank in faction SNRom_Bond), the track (StorageUtil IEB_RomTrack, written by the
 Relationships patch and refreshed here by RefreshTrack) and the MARAS status. Writes ONLY
 akActor.SetRelationshipRank(player, n). Never raises a negative rank (one exception: the spouse gift undo).}

; ---------------------------------------------------------------------------- presence

Bool Function RelPresent() Global
    Return Game.IsPluginInstalled("SNRom_Integration.esl")
EndFunction

Bool Function MarasPresent() Global
    Return Game.IsPluginInstalled("TT_MARAS.esp")
EndFunction

Faction Function BondFaction() Global
    {SNRom_Bond, through Relationships' own resolver (plugin-local FormID in SNRom_Integration.esl).}
    If !RelPresent()
        Return None
    EndIf
    Return SNRom_Bridge.ResolveBondFaction()
EndFunction

String Function MarasStatus(Actor akActor) Global
    {Lower-case MARAS status name, or "" without MARAS.}
    If !MarasPresent()
        Return ""
    EndIf
    String s = MARAS.GetNpcStatusName(akActor)
    If s == "Married" || s == "MARRIED"
        Return "married"
    ElseIf s == "Engaged" || s == "ENGAGED"
        Return "engaged"
    ElseIf s == "Jilted" || s == "JILTED"
        Return "jilted"
    ElseIf s == "Divorced" || s == "DIVORCED"
        Return "divorced"
    ElseIf s == "Candidate" || s == "CANDIDATE"
        Return "candidate"
    EndIf
    Return s
EndFunction

; ---------------------------------------------------------------------------- track

Function RefreshTrack(Actor akActor) Global
    {Recompute IEB_RomTrack by the Relationships rule (ShownTierName, RELB:1370-1391): RomanceApplicability == 0
     and (sparked with an accepted stance, or CommitmentState >= 2). Run by the load reconcile and every sweep pass
     before Apply (Shae 2026-10-09): catches a vanilla marriage with no MARAS event and the kin-guard toggle.}
    If akActor == None || !RelPresent()
        Return
    EndIf
    Int t = 0
    If SNRom_Decorators.RomanceApplicability(akActor) == 0
        If (SNRom_Decorators.IsSparked(akActor) && \
            StorageUtil.GetIntValue(akActor, "SNRom_PlayerStance", 0) == SNRom_Bridge.STANCE_ACCEPTED()) || \
            SNRom_Bridge.CommitmentState(akActor) >= 2
            t = 1
        EndIf
    EndIf
    StorageUtil.SetIntValue(akActor, "IEB_RomTrack", t)
EndFunction

; ---------------------------------------------------------------------------- targets

Int Function TierTarget(Int aiTier, Int aiRom) Global
    If aiTier <= 1
        Return 0
    ElseIf aiTier == 2
        Return 1
    ElseIf aiTier == 3
        Return 2
    ElseIf aiRom == 1
        Return 4
    EndIf
    Return 3
EndFunction

; ---------------------------------------------------------------------------- the sync

Function Apply(Actor akActor) Global
    {One actor. Rules 1-5 of spec §11.14.1.}
    Actor player = Game.GetPlayer()
    If akActor == None || akActor == player
        Return
    EndIf
    String who = akActor.GetDisplayName()
    ; Skips: direct Papyrus checks on the live actor, never a scanned condition index (erratum, 2026-10-08).
    If akActor.IsChild()
        Return
    EndIf
    If akActor.IsDead()
        Return
    EndIf
    If akActor.IsInCombat()
        Return
    EndIf
    If StorageUtil.HasIntValue(akActor, "SeverCombat_OriginalRelationship")
        Log("RANKSYNC actor=" + who + " why=skip:sa_brawl")
        Return
    EndIf

    String ms = MarasStatus(akActor)
    If ms == "jilted" || ms == "divorced"
        Return                                  ; no write at all
    EndIf

    Faction bond = BondFaction()
    Int tier = -1
    If bond != None
        tier = akActor.GetFactionRank(bond)     ; < 0: not a member, i.e. not enrolled
    EndIf
    Bool enrolled = tier >= 0
    If !enrolled && ms != "married" && ms != "engaged"
        Return
    EndIf

    Int rom = StorageUtil.GetIntValue(akActor, "IEB_RomTrack", 0)
    Int target = -1
    If enrolled
        target = TierTarget(tier, rom)
    EndIf
    If ms == "married" && target < 4
        target = 4
    ElseIf ms == "engaged" && target < 3
        target = 3
    EndIf

    Int r = akActor.GetRelationshipRank(player)
    Bool first = !StorageUtil.HasIntValue(akActor, "IEB_RankSyncTier")
    Int prevTier = StorageUtil.GetIntValue(akActor, "IEB_RankSyncTier", -1)
    Int prevRom = StorageUtil.GetIntValue(akActor, "IEB_RankSyncRom", 0)

    ; Spouse gift undo: once per NPC (RDO's penalty fires once; its counter stops at 5).
    If ms == "married" && StorageUtil.GetIntValue(akActor, "IEB_GiftUndone", 0) == 0
        Faction gift = Game.GetFormFromFile(0xED7778, "Relationship Dialogue Overhaul.esp") as Faction
        If gift != None && akActor.GetFactionRank(gift) >= 5
            StorageUtil.SetIntValue(akActor, "IEB_GiftUndone", 1)
            If r == -1
                akActor.SetRelationshipRank(player, 4)
                Log("RANKSYNC actor=" + who + " from=-1 to=4 why=gift_undo")
                Store(akActor, tier, rom)
                Return
            EndIf
        EndIf
    EndIf

    If r < 0
        Log("RANKSYNC actor=" + who + " from=" + r + " to=" + r + " why=skip:negative")
    ElseIf r < target
        akActor.SetRelationshipRank(player, target)
        Log("RANKSYNC actor=" + who + " from=" + r + " to=" + target + " why=raise")
    ElseIf r > target && !first
        Bool dropped = (enrolled && prevTier > tier) || (prevRom == 1 && rom == 0)
        If dropped
            Int lowered = target
            If lowered < 0
                lowered = 0
            EndIf
            If lowered != r
                akActor.SetRelationshipRank(player, lowered)
                Log("RANKSYNC actor=" + who + " from=" + r + " to=" + lowered + " why=drop")
            EndIf
        EndIf
    EndIf
    Store(akActor, tier, rom)
EndFunction

Function Store(Actor akActor, Int aiTier, Int aiRom) Global
    StorageUtil.SetIntValue(akActor, "IEB_RankSyncTier", aiTier)
    StorageUtil.SetIntValue(akActor, "IEB_RankSyncRom", aiRom)
EndFunction

; ---------------------------------------------------------------------------- load reconcile and sweep (spec §9.3 cadence)

Function SweepStep(Int aiMax = 4) Global
    {At most aiMax actors per pass, round-robin over the Relationships roster plus MARAS married/engaged.
     Each: RefreshTrack, then Apply.}
    Int nRoster = 0
    If RelPresent()
        nRoster = StorageUtil.FormListCount(None, "SNRom_Roster")
    EndIf
    Actor[] married
    Actor[] engaged
    If MarasPresent()
        married = MARAS.GetNPCsByStatus("married")
        engaged = MARAS.GetNPCsByStatus("engaged")
    EndIf
    Int total = nRoster + married.Length + engaged.Length
    If total <= 0
        Return
    EndIf
    Int cursor = StorageUtil.GetIntValue(None, "IEB_RankSyncCursor", 0)
    Int done = 0
    While done < aiMax && done < total
        Int i = cursor % total
        Actor a = None
        If i < nRoster
            a = StorageUtil.FormListGet(None, "SNRom_Roster", i) as Actor
        ElseIf i < nRoster + married.Length
            a = married[i - nRoster]
        Else
            a = engaged[i - nRoster - married.Length]
        EndIf
        If a != None
            RefreshTrack(a)
            Apply(a)
        EndIf
        cursor += 1
        done += 1
    EndWhile
    StorageUtil.SetIntValue(None, "IEB_RankSyncCursor", cursor % total)
EndFunction

Function OnMarasStatus(Actor akActor) Global
    {Bridge hook 2: maras_status_changed -> refresh the track, then sync this actor.}
    If akActor != None
        RefreshTrack(akActor)
        Apply(akActor)
    EndIf
EndFunction

Function Log(String asMsg) Global
    Debug.Trace("[IEB] " + asMsg)
EndFunction
