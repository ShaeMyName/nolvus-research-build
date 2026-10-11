"""Apply the Relationships private patch (component F; spec §11.4, §11.10.2, §11.12.3, §11.13.4, §11.14.1)
to build/src/relationships, one hunk group per call. Every anchor must match exactly once (CRLF kept)."""
import sys

D = "C:/nolvus-research/build/src/relationships/src/scripts/"
NL = "\r\n"
B, DEC = "SNRom_Bridge.psc", "SNRom_Decorators.psc"


def edit(fname, pairs):
    p = D + fname
    s = open(p, "rb").read().decode("utf-8")
    for old, new in pairs:
        o, n = old.replace("\n", NL), new.replace("\n", NL)
        c = s.count(o)
        assert c == 1, "%s: anchor found %d times: %r" % (fname, c, old[:100])
        s = s.replace(o, n)
    open(p, "wb").write(s.encode("utf-8"))


def append(fname, text):
    p = D + fname
    s = open(p, "rb").read().decode("utf-8")
    if not s.endswith(NL):
        s += NL
    open(p, "wb").write((s + text.replace("\n", NL)).encode("utf-8"))


G = sys.argv[1]

if G == "status":   # §11.4: the 4 status events become private (trigger ieb_snrom_status_private, layer F)
    edit(B, [
        ("""    SkyrimNetApi.RegisterPersistentEvent( \\
        akActor.GetDisplayName() + " and " + Game.GetPlayer().GetDisplayName() + \\
        " have reached an understanding neither has named. " + asReason, akActor, Game.GetPlayer())
""",
         """    ; Patch (IEB §11.4): an internal state, private to this NPC and the player (trigger ieb_snrom_status_private)
    akActor.SendModEvent("IEB_SNRomStatus", \\
        akActor.GetDisplayName() + " and " + Game.GetPlayer().GetDisplayName() + \\
        " have reached an understanding neither has named. " + asReason, 0.0)
"""),
        ("""    If landmark
        SkyrimNetApi.RegisterPersistentEvent(akActor.GetDisplayName() + " and " + \\
            Game.GetPlayer().GetDisplayName() + " have named what they are to each other. " + asWhat, \\
            akActor, Game.GetPlayer())
    EndIf
""",
         """    If landmark
        ; Patch (IEB §11.4): private, see ieb_snrom_status_private
        akActor.SendModEvent("IEB_SNRomStatus", akActor.GetDisplayName() + " and " + \\
            Game.GetPlayer().GetDisplayName() + " have named what they are to each other. " + asWhat, 0.0)
    EndIf
"""),
        ("""    If rupture
        SkyrimNetApi.RegisterPersistentEvent(akActor.GetDisplayName() + " and " + \\
            Game.GetPlayer().GetDisplayName() + " are no longer what they were to each other. " + asWhat, \\
            akActor, Game.GetPlayer())
""",
         """    If rupture
        ; Patch (IEB §11.4): private, see ieb_snrom_status_private
        akActor.SendModEvent("IEB_SNRomStatus", akActor.GetDisplayName() + " and " + \\
            Game.GetPlayer().GetDisplayName() + " are no longer what they were to each other. " + asWhat, 0.0)
"""),
        ("""    SkyrimNetApi.RegisterPersistentEvent(who + " has been changing, in a way " + \\
        Game.GetPlayer().GetDisplayName() + " has had a hand in. " + asPattern, \\
        akActor, Game.GetPlayer())
""",
         """    ; Patch (IEB §11.4): private, see ieb_snrom_status_private
    akActor.SendModEvent("IEB_SNRomStatus", who + " has been changing, in a way " + \\
        Game.GetPlayer().GetDisplayName() + " has had a hand in. " + asPattern, 0.0)
"""),
    ])

elif G == "child":   # §11.10.2 P1: child gates R1-R10
    edit(DEC, [
        # R1
        ("""    If akActor == None
        Return False
    EndIf
    ; THE PLAYER'S OWN CHILD IS NEVER A ROMANTIC PROSPECT.""",
         """    If akActor == None
        Return False
    EndIf
    ; Patch R1 (IEB §11.10.2): a child is never a romantic prospect, before anything else
    If akActor.IsChild()
        Return False
    EndIf
    ; THE PLAYER'S OWN CHILD IS NEVER A ROMANTIC PROSPECT."""),
        # R8
        ("""        ",\\"physMinTier\\":" + StorageUtil.GetIntValue(akActor, "SNRom_PhysMinTier", 4) + \\
""",
         """        ",\\"physMinTier\\":" + IEB_PhysMinTierShown(akActor) + \\
"""),
    ])
    append(DEC, """
Int Function IEB_PhysMinTierShown(Actor akActor) Global
    { Patch R8 (IEB §11.10.2): a child always reads as NEVER (-1), whatever the store holds between sweeps. }
    If akActor != None && akActor.IsChild()
        Return -1
    EndIf
    Return StorageUtil.GetIntValue(akActor, "SNRom_PhysMinTier", 4)
EndFunction
""")
    edit(B, [
        # R2
        ("""      here, because now something actually has happened. }
    StorageUtil.SetIntValue(akActor, "SNRom_Sparked", 1)
""",
         """      here, because now something actually has happened. }
    ; Patch R2 (IEB §11.10.2): covers an assessor reply already in flight
    If akActor == None || akActor.IsChild()
        Diag(LOG_INFO(), "ApplySpark refused: IsChild")
        Return
    EndIf
    StorageUtil.SetIntValue(akActor, "SNRom_Sparked", 1)
"""),
        # R3
        ("""    { The player says yes. Only this opens tier 4+ as a realized romance. }
    SetStance(akActor, STANCE_ACCEPTED(), "accepted")
""",
         """    { The player says yes. Only this opens tier 4+ as a realized romance. }
    ; Patch R3 (IEB §11.10.2): before SetStance
    If akActor != None && akActor.IsChild()
        Diag(LOG_INFO(), "AcceptRomance refused for " + akActor.GetDisplayName() + ": IsChild")
        Return
    EndIf
    SetStance(akActor, STANCE_ACCEPTED(), "accepted")
"""),
        # R4
        ("""      about whether the game records these two as together. }
    If SeedRomanticEvidence(akActor)
""",
         """      about whether the game records these two as together. }
    ; Patch R4 (IEB §11.10.2)
    If akActor == None || akActor.IsChild()
        Return
    EndIf
    If SeedRomanticEvidence(akActor)
"""),
        # R5a ApplyCharacter
        ("""    If intimWord != ""
        StorageUtil.SetIntValue(akActor, "SNRom_PhysMinTier", minTier)
        StorageUtil.SetIntValue(akActor, "SNRom_PhysAttrBypass", bypass)
    EndIf
""",
         """    If intimWord != ""
        StorageUtil.SetIntValue(akActor, "SNRom_PhysMinTier", minTier)
        StorageUtil.SetIntValue(akActor, "SNRom_PhysAttrBypass", bypass)
    EndIf
    IEB_LockChildIntimacy(akActor)   ; Patch R5 (IEB §11.10.2)
"""),
        # R5b SetCharacterField
        ("""        Diag(LOG_INFO(), "REPAIR: " + who + " INTIMACY set to " + word + \\
            " (minTier " + tier + ")")
""",
         """        Diag(LOG_INFO(), "REPAIR: " + who + " INTIMACY set to " + word + \\
            " (minTier " + tier + ")")
        IEB_LockChildIntimacy(akActor)   ; Patch R5 (IEB §11.10.2)
"""),
        # R5c ApplyDrift
        ("""        ; the logs and change nothing in play, which is the worst kind of bug.
        StorageUtil.SetIntValue(akActor, "SNRom_PhysAttrBypass", \\
            SNRom_Decorators.IntimacyToBypass(after))
""",
         """        ; the logs and change nothing in play, which is the worst kind of bug.
        StorageUtil.SetIntValue(akActor, "SNRom_PhysAttrBypass", \\
            SNRom_Decorators.IntimacyToBypass(after))
        IEB_LockChildIntimacy(akActor)   ; Patch R5 (IEB §11.10.2)
"""),
        # R6 EnrollNow
        ("""    StorageUtil.FormListRemove(None, PENDING_LIST(), akActor, True)

    ; ── STAMP BOTH ASSESSOR WATERMARKS AT ENROLLMENT""",
         """    StorageUtil.FormListRemove(None, PENDING_LIST(), akActor, True)
    ; Patch R6 (IEB §11.10.2): a child's intimacy is locked at once and the spark is decided (never)
    If IEB_LockChildIntimacy(akActor)
        StorageUtil.SetIntValue(akActor, "SNRom_SparkDecided", 1)
    EndIf

    ; ── STAMP BOTH ASSESSOR WATERMARKS AT ENROLLMENT"""),
        # R7 sweep (after PurgeNonPersons)
        ("""        i += 1
    EndWhile
    PurgeNonPersons()
""",
         """        i += 1
    EndWhile
    PurgeNonPersons()
    IEB_ChildSweep()   ; Patch R7 (IEB §11.10.2)
"""),
        # R9
        ("""      make this a pattern rather than a reaction. }
    If StorageUtil.GetIntValue(akActor, "SNRom_DispositionAuthored", 0) != 1
        Return False                            ; nothing to drift FROM yet
""",
         """      make this a pattern rather than a reaction. }
    If akActor.IsChild()
        Return False                            ; Patch R9 (IEB §11.10.2)
    EndIf
    If StorageUtil.GetIntValue(akActor, "SNRom_DispositionAuthored", 0) != 1
        Return False                            ; nothing to drift FROM yet
"""),
        # R10 send
        ("""    Int rc = SkyrimNetApi.SendCustomPromptToLLM("snrom_author_disposition", VariantName(), ctx, \\
        Self, "SNRom_Bridge", "OnDispositionAuthored")   ; this script IS the quest
""",
         """    ; Patch R10 (IEB §11.10.2): a child is asked the platonic fields only (layer shae.privacy-overrides)
    String promptFile = "snrom_author_disposition"
    If akActor.IsChild()
        promptFile = "ieb_snrom_author_child"
    EndIf
    Int rc = SkyrimNetApi.SendCustomPromptToLLM(promptFile, VariantName(), ctx, \\
        Self, "SNRom_Bridge", "OnDispositionAuthored")   ; this script IS the quest
"""),
        # R10 reply: the child reply has no EXCLUSIVITY; its completeness marker is WHY
        ("""    If SNRom_Decorators.FieldValue(asResponse, "EXCLUSIVITY:") == ""
        Diag(LOG_ERROR(), "Truncated response for " + asked + \\""",
         """    ; Patch R10 (IEB §11.10.2): a child's reply carries WHY/LIMIT/ADDRESS only. Romantic fields stay
    ; unset (safe defaults) and R5 in ApplyCharacter forces the intimacy lock.
    If who.IsChild()
        If SNRom_Decorators.FieldValue(asResponse, "WHY:") == ""
            Diag(LOG_ERROR(), "Truncated child response for " + asked + " (no WHY:). Discarded.")
            LogDisposition(asked, aiSuccess, asResponse, "truncated-child")
            ApplyArchetype(who)
            Return
        EndIf
    ElseIf SNRom_Decorators.FieldValue(asResponse, "EXCLUSIVITY:") == ""
        Diag(LOG_ERROR(), "Truncated response for " + asked + \\"""),
    ])
    append(B, """
; ===========================================================================
; IEB private patch (component F): child gates R1-R10 (spec §11.10.2)
; ===========================================================================

Bool Function IEB_LockChildIntimacy(Actor akActor)
    { Patch R5: for a child, intimacy is forced to NEVER on every write, whatever was asked. True if locked. }
    If akActor == None || !akActor.IsChild()
        Return False
    EndIf
    StorageUtil.SetIntValue(akActor, "SNRom_PhysMinTier", -1)
    StorageUtil.SetIntValue(akActor, "SNRom_PhysAttrBypass", 0)
    Return True
EndFunction

Function IEB_ChildSweep()
    { Patch R7: every enrolled child, every sweep: re-lock intimacy, spark decided, un-spark if sparked,
      clear stance, banked points and the pending question. Corrects console or third-party writes within
      one sweep. No un-enrolling. }
    Int total = StorageUtil.FormListCount(None, "SNRom_Roster")
    Int fixedCount = 0
    Int i = 0
    While i < total
        Actor a = StorageUtil.FormListGet(None, "SNRom_Roster", i) as Actor
        If a != None && a.IsChild() && IsEnrolled(a)
            IEB_LockChildIntimacy(a)
            StorageUtil.SetIntValue(a, "SNRom_SparkDecided", 1)
            If StorageUtil.GetIntValue(a, "SNRom_Sparked", 0) == 1
                UnsparkActor(a)
                fixedCount += 1
            EndIf
            StorageUtil.UnsetIntValue(a, "SNRom_PlayerStance")
            StorageUtil.UnsetIntValue(a, "SNRom_BankedPoints")
            StorageUtil.UnsetIntValue(a, "SNRom_AskPending")
        EndIf
        i += 1
    EndWhile
    If fixedCount > 0
        Diag(LOG_WARN(), "Child sweep: un-sparked " + fixedCount + " enrolled child(ren); intimacy locked (IsChild)")
    EndIf
EndFunction
""")

elif G == "maras":   # §11.12.3 M2, M3, M4'
    edit(B, [
        # M2 + M4': before the enrolled-only return
        ("""    Actor who = akSender as Actor
    If who == None || !_ready
        Return
    EndIf
    If !IsEnrolled(who)
        Return
    EndIf
    String st = SNRom_Decorators.Upper(SNRom_Decorators.Trim(asStatus))
""",
         """    Actor who = akSender as Actor
    If who == None || !_ready
        Return
    EndIf
    ; Patch M2 (IEB §11.12.3): a new engagement or marriage counts at once
    RefreshPartnerCount()
    ; Patch M4' (IEB §11.12.3): auto-enroll on courtship (candidate / engaged / married)
    String ieSt = SNRom_Decorators.Upper(SNRom_Decorators.Trim(asStatus))
    If ieSt == "CANDIDATE" || ieSt == "ENGAGED" || ieSt == "MARRIED"
        IEB_EnrollOnCourtship(who)
    EndIf
    If !IsEnrolled(who)
        Return
    EndIf
    String st = SNRom_Decorators.Upper(SNRom_Decorators.Trim(asStatus))
"""),
        # M3: top band refuses a shared marriage
        ("""    If st == "ENGAGED"
        Int held = PointsOf(who)
""",
         """    If st == "ENGAGED"
        ; Patch M3 (IEB §11.12.3): exclusivity >= CONSUMING_MIN will not join a marriage shared with others
        If StorageUtil.GetIntValue(who, "SNRom_Exclusivity", 50) >= CONSUMING_MIN() && SNRom_Decorators.OtherPartners(who) > 0
            If MARAS.PromoteNPCToStatus(who, "candidate")
                SkyrimNetApi.RegisterShortLivedEvent("ieb_excl_refusal_" + who.GetFormID(), "ieb_exclusivity_refusal", \\
                    who.GetDisplayName() + " would not join a shared marriage", "", 300000, who, Game.GetPlayer())
                Diag(LOG_INFO(), "Engagement refused for " + who.GetDisplayName() + " - exclusivity " + \\
                    StorageUtil.GetIntValue(who, "SNRom_Exclusivity", 50) + " >= " + CONSUMING_MIN() + \\
                    " with " + SNRom_Decorators.OtherPartners(who) + " other partner(s); back to candidate." + MarasStateLine(who))
            Else
                Diag(LOG_ERROR(), "MARAS refused to demote " + who.GetDisplayName() + \\
                    " after an exclusivity refusal." + MarasStateLine(who))
            EndIf
            Return
        EndIf
        Int held = PointsOf(who)
"""),
        # M2: union with MARAS engaged/married
        ("""        i += 1
    EndWhile
    If StorageUtil.GetIntValue(None, "SNRom_PartnerCount", -1) != n
""",
         """        i += 1
    EndWhile
    ; Patch M2 (IEB §11.12.3): plus MARAS engaged or married actors not already counted above
    If MarasPresent()
        n += IEB_CountMarasPartners("engaged") + IEB_CountMarasPartners("married")
    EndIf
    If StorageUtil.GetIntValue(None, "SNRom_PartnerCount", -1) != n
"""),
        # M4' sweep catch-up (after R7)
        ("""    IEB_ChildSweep()   ; Patch R7 (IEB §11.10.2)
""",
         """    IEB_ChildSweep()   ; Patch R7 (IEB §11.10.2)
    IEB_MarasCatchUp()   ; Patch M4' (IEB §11.12.3)
"""),
    ])
    edit(DEC, [(
"""    Int total = StorageUtil.GetIntValue(None, "SNRom_PartnerCount", 0)
    If SNRom_Decorators.IsSparked(akActor) && \\
       StorageUtil.GetIntValue(akActor, "SNRom_PlayerStance", 0) == 1
        total -= 1
    EndIf
""",
"""    Int total = StorageUtil.GetIntValue(None, "SNRom_PartnerCount", 0)
    If SNRom_Decorators.IsSparked(akActor) && \\
       StorageUtil.GetIntValue(akActor, "SNRom_PlayerStance", 0) == 1
        total -= 1
    ElseIf SNRom_Bridge.MarasPresent()
        ; Patch M2 (IEB §11.12.3): self counted through the MARAS union
        String ms = SNRom_Decorators.Upper(MARAS.GetNpcStatusName(akActor))
        If ms == "ENGAGED" || ms == "MARRIED"
            total -= 1
        EndIf
    EndIf
""")])
    append(B, """
; ===========================================================================
; IEB private patch (component F): MARAS exclusivity M2 / M4' (spec §11.12.3)
; ===========================================================================

Int Function IEB_CountMarasPartners(String asStatus)
    { Patch M2: MARAS actors with this status who are alive and not already counted as an acknowledged
      Relationships partner (sparked + accepted), so the union has no duplicates. }
    Actor[] arr = MARAS.GetNPCsByStatus(asStatus)
    Int n = 0
    Int i = 0
    While i < arr.Length
        Actor a = arr[i]
        If a != None && !a.IsDead()
            If !(SNRom_Decorators.IsSparked(a) && StorageUtil.GetIntValue(a, "SNRom_PlayerStance", 0) == STANCE_ACCEPTED())
                n += 1
            EndIf
        EndIf
        i += 1
    EndWhile
    Return n
EndFunction

Bool Function IEB_EnrollOnCourtship(Actor akActor)
    { Patch M4': the same checks EnrollByHand makes, plus never a child. Idempotent through IsEnrolled. }
    If akActor == None || akActor == Game.GetPlayer() || IsEnrolled(akActor)
        Return False
    EndIf
    If akActor.IsChild() || akActor.IsDead() || akActor.IsCommandedActor() || !IsPerson(akActor)
        Return False
    EndIf
    EnrollNow(akActor, "Enrolled on MARAS courtship:")
    Return True
EndFunction

Function IEB_MarasCatchUp()
    { Patch M4': each sweep enrolls at most 2 MARAS candidates, fiancés or spouses who are missing,
      covering courtships begun before the patch or events lost at load. }
    If !MarasPresent()
        Return
    EndIf
    Int budget = 2
    String[] statuses = new String[3]
    statuses[0] = "married"
    statuses[1] = "engaged"
    statuses[2] = "candidate"
    Int s = 0
    While s < 3 && budget > 0
        Actor[] arr = MARAS.GetNPCsByStatus(statuses[s])
        Int i = 0
        While i < arr.Length && budget > 0
            If IEB_EnrollOnCourtship(arr[i])
                budget -= 1
            EndIf
            i += 1
        EndWhile
        s += 1
    EndWhile
EndFunction
""")

elif G == "ranksync":   # §11.14.1 hook + IEB_RomTrack at every romance-state change
    edit(B, [
        ("""    If _bond != None && IsEnrolled(akActor)
        akActor.SetFactionRank(_bond, TierOf(akActor))
    EndIf
EndFunction
""",
         """    If _bond != None && IsEnrolled(akActor)
        akActor.SetFactionRank(_bond, TierOf(akActor))
    EndIf
    ; Patch (IEB §11.14.1, S-33): track first, then the one-way vanilla rank sync
    IEB_WriteRomTrack(akActor)
    IEB_RankSync.Apply(akActor)
EndFunction
"""),
        # stance (accept / decline / reopen)
        ("""    StorageUtil.SetIntValue(akActor, "SNRom_PlayerStance", aiStance)
    ; Any stance write settles the outstanding question""",
         """    StorageUtil.SetIntValue(akActor, "SNRom_PlayerStance", aiStance)
    IEB_WriteRomTrack(akActor)   ; Patch (IEB §11.14.1)
    ; Any stance write settles the outstanding question"""),
        # unspark
        ("""    StorageUtil.SetFloatValue(akActor, "SNRom_EnrolledAt", Utility.GetCurrentGameTime())
    If was
        Diag(LOG_INFO(), "Un-sparked " + who""",
         """    StorageUtil.SetFloatValue(akActor, "SNRom_EnrolledAt", Utility.GetCurrentGameTime())
    IEB_WriteRomTrack(akActor)   ; Patch (IEB §11.14.1)
    If was
        Diag(LOG_INFO(), "Un-sparked " + who"""),
        # spark (assessor)
        ("""    Ledger(akActor, "spark", "", 25, 1, asMoment)
""",
         """    Ledger(akActor, "spark", "", 25, 1, asMoment)
    IEB_WriteRomTrack(akActor)   ; Patch (IEB §11.14.1)
"""),
        # BeginSpark
        ("""    Ledger(akActor, "enroll", "", 25, 1, asReason)
""",
         """    Ledger(akActor, "enroll", "", 25, 1, asReason)
    IEB_WriteRomTrack(akActor)   ; Patch (IEB §11.14.1)
"""),
        # MARAS status
        ("""    If ieSt == "CANDIDATE" || ieSt == "ENGAGED" || ieSt == "MARRIED"
        IEB_EnrollOnCourtship(who)
    EndIf
""",
         """    If ieSt == "CANDIDATE" || ieSt == "ENGAGED" || ieSt == "MARRIED"
        IEB_EnrollOnCourtship(who)
    EndIf
    IEB_WriteRomTrack(who)   ; Patch (IEB §11.14.1): commitment may have changed
"""),
    ])
    # EndRomance and SeedRomanticFlag (married) also write spark/stance
    p = D + B
    s = open(p, "rb").read().decode("utf-8")
    i = s.index("Function EndRomance(")
    j = s.index("EndFunction", i)
    body = s[i:j]
    assert body.count('    StorageUtil.SetIntValue(akActor, "SNRom_PlayerStance", STANCE_UNANSWERED())\r\n') == 1
    body = body.replace('    StorageUtil.SetIntValue(akActor, "SNRom_PlayerStance", STANCE_UNANSWERED())\r\n',
                        '    StorageUtil.SetIntValue(akActor, "SNRom_PlayerStance", STANCE_UNANSWERED())\r\n'
                        '    IEB_WriteRomTrack(akActor)   ; Patch (IEB §11.14.1)\r\n')
    s = s[:i] + body + s[j:]
    open(p, "wb").write(s.encode("utf-8"))
    edit(B, [(
"""        StorageUtil.SetIntValue(akActor, "SNRom_PlayerStance", STANCE_ACCEPTED())
        If changed
""",
"""        StorageUtil.SetIntValue(akActor, "SNRom_PlayerStance", STANCE_ACCEPTED())
        IEB_WriteRomTrack(akActor)   ; Patch (IEB §11.14.1)
        If changed
"""),
    # ApplyCharacter: orientation may change RomanceApplicability (was a hand edit in 3ffd0b4; folded in r55)
    ("""    IEB_LockChildIntimacy(akActor)   ; Patch R5 (IEB §11.10.2)
    If SNRom_Decorators.FieldValue(asResponse, "ARDOR:") != ""
""",
     """    IEB_LockChildIntimacy(akActor)   ; Patch R5 (IEB §11.10.2)
    IEB_WriteRomTrack(akActor)   ; Patch (IEB §11.14.1): orientation may change RomanceApplicability
    If SNRom_Decorators.FieldValue(asResponse, "ARDOR:") != ""
""")])
    append(B, """
; ===========================================================================
; IEB private patch (component F): rank-sync track (spec §11.14.1)
; ===========================================================================

Function IEB_WriteRomTrack(Actor akActor)
    { Patch: StorageUtil IEB_RomTrack, 1 = romantic, 0 = friendship, by ShownTierName's rule:
      RomanceApplicability == 0 and (sparked with an accepted stance, or CommitmentState >= 2).
      Read by IEB_RankSync.Apply (Errand Bridge). }
    If akActor == None
        Return
    EndIf
    Int t = 0
    If SNRom_Decorators.RomanceApplicability(akActor) == 0
        If (SNRom_Decorators.IsSparked(akActor) && \\
            StorageUtil.GetIntValue(akActor, "SNRom_PlayerStance", 0) == STANCE_ACCEPTED()) || \\
            CommitmentState(akActor) >= 2
            t = 1
        EndIf
    EndIf
    StorageUtil.SetIntValue(akActor, "IEB_RomTrack", t)
EndFunction
""")

elif G == "intimacy":   # §11.13.4 chained, adult-only intimacy-profile authoring
    edit(B, [
        # chain from the adult branch of a successful authoring
        ("""    Diag(LOG_INFO(), "Disposition authored for " + asked)
    LogDisposition(asked, aiSuccess, asResponse, "applied")
EndFunction
""",
         """    Diag(LOG_INFO(), "Disposition authored for " + asked)
    LogDisposition(asked, aiSuccess, asResponse, "applied")
    IEB_QueueIntimacy(who)   ; Patch (IEB §11.13.4): adult, romance-applicable, not NEVER (checked inside)
EndFunction
"""),
        # first spark of an already-enrolled NPC without a profile
        ("""    Ledger(akActor, "spark", "", 25, 1, asMoment)
    IEB_WriteRomTrack(akActor)   ; Patch (IEB §11.14.1)
""",
         """    Ledger(akActor, "spark", "", 25, 1, asMoment)
    IEB_WriteRomTrack(akActor)   ; Patch (IEB §11.14.1)
    IEB_QueueIntimacy(akActor)   ; Patch (IEB §11.13.4): first spark without a profile
"""),
        ("""    Ledger(akActor, "enroll", "", 25, 1, asReason)
    IEB_WriteRomTrack(akActor)   ; Patch (IEB §11.14.1)
""",
         """    Ledger(akActor, "enroll", "", 25, 1, asReason)
    IEB_WriteRomTrack(akActor)   ; Patch (IEB §11.14.1)
    IEB_QueueIntimacy(akActor)   ; Patch (IEB §11.13.4): only if already authored (checked inside)
"""),
        # sweep catch-up, at most 1 per pass
        ("""    IEB_MarasCatchUp()   ; Patch M4' (IEB §11.12.3)
""",
         """    IEB_MarasCatchUp()   ; Patch M4' (IEB §11.12.3)
    IEB_IntimacyCatchUp()   ; Patch (IEB §11.13.4)
"""),
        # load: mirror the durable copy into the render string; a callback never survives a load
        ("""    _ready = True
    ; THE POINTS ARE OURS.""",
         """    _ready = True
    IEB_IntimacyOnLoad()   ; Patch (IEB §11.13.4)
    ; THE POINTS ARE OURS."""),
    ])
    edit(B, [(
"""Actor  _driftActor
""",
"""Actor  _pendingIntimacy   ; Patch (IEB §11.13.4): in-flight intimacy authoring, never shares _pendingActor
Actor  _driftActor
""")])
    append(B, """
; ===========================================================================
; IEB private patch (component F): intimacy profiles (spec §11.13.4)
; Static per NPC; adults only; own queue and in-flight slot. The text is NEVER logged:
; only its length and success. Not pushed to the dashboard.
; ===========================================================================

Bool Function IEB_IntimacyWanted(Actor akActor)
    { An adult, enrolled, already-authored NPC whose romance applies to this player, whose intimacy is not
      NEVER, and who has no profile yet (or is forced). }
    If akActor == None || akActor.IsChild() || akActor.IsDead() || !IsEnrolled(akActor)
        Return False
    EndIf
    If StorageUtil.GetIntValue(akActor, "SNRom_DispositionAuthored", 0) != 1
        Return False
    EndIf
    If SNRom_Decorators.RomanceApplicability(akActor) != 0
        Return False
    EndIf
    If StorageUtil.GetIntValue(akActor, "SNRom_PhysMinTier", 4) < 0
        Return False
    EndIf
    If StorageUtil.GetIntValue(akActor, "IEB_ForceIntimacyAuthor", 0) == 1
        Return True
    EndIf
    Return StoreGetText(akActor, "Intimacy") == ""
EndFunction

Function IEB_QueueIntimacy(Actor akActor)
    If !_ready || !IEB_IntimacyWanted(akActor)
        Return
    EndIf
    StorageUtil.FormListAdd(None, "IEB_IntimacyQueue", akActor, False)
    IEB_PumpIntimacy()
EndFunction

Function IEB_PumpIntimacy()
    { One call in flight at a time. Re-checks IsChild and every condition on dequeue. }
    If _pendingIntimacy != None
        Return
    EndIf
    While StorageUtil.FormListCount(None, "IEB_IntimacyQueue") > 0
        Actor next = StorageUtil.FormListGet(None, "IEB_IntimacyQueue", 0) as Actor
        StorageUtil.FormListRemoveAt(None, "IEB_IntimacyQueue", 0)
        If next != None && !next.IsChild() && IEB_IntimacyWanted(next)
            IEB_SendIntimacy(next)
            Return
        EndIf
    EndWhile
EndFunction

Function IEB_SendIntimacy(Actor akActor)
    Int minTier = StorageUtil.GetIntValue(akActor, "SNRom_PhysMinTier", 4)
    String ctx = "{\\"npc_name\\":\\"" + SNRom_Decorators.JsonEscape(akActor.GetDisplayName()) + "\\"" + \\
        ",\\"npc_formid\\":" + akActor.GetFormID() + \\
        ",\\"disp_orientation\\":\\"" + SNRom_Decorators.OrientationWord(akActor) + "\\"" + \\
        ",\\"disp_intimacy\\":\\"" + SNRom_Decorators.IntimacyWordFromTier(minTier) + "\\"" + \\
        ",\\"disp_ardor\\":\\"" + SNRom_Decorators.ArdorWord(StorageUtil.GetIntValue(akActor, "SNRom_Ardor", 2)) + "\\"" + \\
        ",\\"disp_exclusivity\\":" + StorageUtil.GetIntValue(akActor, "SNRom_Exclusivity", 50) + \\
        ",\\"disp_why\\":\\"" + SNRom_Decorators.JsonEscape(StoreGetText(akActor, "Why")) + "\\"" + \\
        ",\\"disp_limit\\":\\"" + SNRom_Decorators.JsonEscape(StoreGetText(akActor, "Limit")) + "\\"}"
    _pendingIntimacy = akActor
    Int rc = SkyrimNetApi.SendCustomPromptToLLM("ieb_intimacy_author", "ieb_intimacy_author", ctx, \\
        Self, "SNRom_Bridge", "IEB_OnIntimacyAuthored")
    Diag(LOG_INFO(), "Intimacy profile requested for " + akActor.GetDisplayName() + " (rc=" + rc + ")")
    If rc != 1
        _pendingIntimacy = None
    EndIf
EndFunction

Event IEB_OnIntimacyAuthored(String asResponse, Int aiSuccess)
    Actor who = _pendingIntimacy
    _pendingIntimacy = None
    Int len = StringUtil.GetLength(asResponse)
    If who == None
        Return
    EndIf
    If aiSuccess != 1 || len < 200 || who.IsChild()
        Diag(LOG_WARN(), "Intimacy profile for " + who.GetDisplayName() + " not stored (success=" + aiSuccess + ", length " + len + ")")
    Else
        StoreSetText(who, "Intimacy", asResponse)
        StorageUtil.SetStringValue(who, "IEB_IntimacyProfile", asResponse)
        StorageUtil.UnsetIntValue(who, "IEB_ForceIntimacyAuthor")
        Diag(LOG_INFO(), "Intimacy profile stored for " + who.GetDisplayName() + " (length " + len + ")")
    EndIf
    IEB_PumpIntimacy()
EndEvent

Function IEB_IntimacyCatchUp()
    { Sweep catch-up: queue at most 1 enrolled, romance-applicable adult without a profile per pass. }
    If _pendingIntimacy != None || StorageUtil.FormListCount(None, "IEB_IntimacyQueue") > 0
        Return
    EndIf
    Int total = StorageUtil.FormListCount(None, "SNRom_Roster")
    Int i = 0
    While i < total
        Actor a = StorageUtil.FormListGet(None, "SNRom_Roster", i) as Actor
        If a != None && IEB_IntimacyWanted(a)
            IEB_QueueIntimacy(a)
            Return
        EndIf
        i += 1
    EndWhile
EndFunction

Function IEB_IntimacyOnLoad()
    { After every load: a callback never survives a load, so the in-flight slot is cleared, and the
      durable copy is mirrored into the StorageUtil string the 0335 submodule renders. }
    _pendingIntimacy = None
    Int mirrored = 0
    Int total = StorageUtil.FormListCount(None, "SNRom_Roster")
    Int i = 0
    While i < total
        Actor a = StorageUtil.FormListGet(None, "SNRom_Roster", i) as Actor
        If a != None
            If a.IsChild()
                StorageUtil.UnsetStringValue(a, "IEB_IntimacyProfile")
            Else
                String t = StoreGetText(a, "Intimacy")
                If t != ""
                    StorageUtil.SetStringValue(a, "IEB_IntimacyProfile", t)
                    mirrored += 1
                EndIf
            EndIf
        EndIf
        i += 1
    EndWhile
    Diag(LOG_INFO(), "Intimacy profiles mirrored after load: " + mirrored)
EndFunction
""")
elif G == "intimacy-switch":   # [ADDED in build, Shae 2026-10-09] runtime kill switch, default off
    edit(B, [
        ("""Function IEB_QueueIntimacy(Actor akActor)
    If !_ready || !IEB_IntimacyWanted(akActor)
""",
         """Function IEB_QueueIntimacy(Actor akActor)
    If !_ready || !IEB_IntimacyOn() || !IEB_IntimacyWanted(akActor)
"""),
        ("""    If _pendingIntimacy != None
        Return
    EndIf
    While StorageUtil.FormListCount(None, "IEB_IntimacyQueue") > 0
""",
         """    If _pendingIntimacy != None || !IEB_IntimacyOn()
        Return
    EndIf
    While StorageUtil.FormListCount(None, "IEB_IntimacyQueue") > 0
"""),
        ("""    { Sweep catch-up: queue at most 1 enrolled, romance-applicable adult without a profile per pass. }
    If _pendingIntimacy != None || StorageUtil.FormListCount(None, "IEB_IntimacyQueue") > 0
""",
         """    { Sweep catch-up: queue at most 1 enrolled, romance-applicable adult without a profile per pass. }
    If !IEB_IntimacyOn() || _pendingIntimacy != None || StorageUtil.FormListCount(None, "IEB_IntimacyQueue") > 0
"""),
    ])
    append(B, """
Bool Function IEB_IntimacyOn() Global
    { Patch (Shae 2026-10-09): runtime kill switch for intimacy-profile AUTHORING. StorageUtil int
      IEB_IntimacyEnabled on the player, default 0 (off). No script property. The list-A soak runs with it at 0;
      setting it to 1 is a mid-save step after IP-1..IP-7 pass. The load-time mirror of profiles already on disk
      and the rank-sync hook are not affected. }
    Return StorageUtil.GetIntValue(Game.GetPlayer(), "IEB_IntimacyEnabled", 0) == 1
EndFunction
""")

elif G == "child-r55":   # round 10 (investigation/round10/child_lock_failure.md §4), approved 2026-10-10
    edit(B, [
        # (c) R7b: the child sweep also runs when the cell scan is switched off
        ("""    If SkyrimNetApi.GetConfigBool(CFG(), "cellScanEnabled", True) == False
        Return
    EndIf
""",
         """    If SkyrimNetApi.GetConfigBool(CFG(), "cellScanEnabled", True) == False
        IEB_ChildSweep()   ; Patch R7b (IEB r55): the child lock does not depend on the cell scan
        Return
    EndIf
"""),
        # (d) R10a: an enrolled child is never listed in anyone's authoring circle
        ("""        If a != None && a != akExclude && \\
           StorageUtil.GetIntValue(a, "SNRom_DispositionAuthored", 0) == 1
""",
         """        ; Patch R10a (IEB r55, Shae 2026-10-10): a child is never a circle entry
        If a != None && a != akExclude && !a.IsChild() && \\
           StorageUtil.GetIntValue(a, "SNRom_DispositionAuthored", 0) == 1
"""),
        # (a1) SetCharacterField: lock first, then log what is stored
        ("""        Diag(LOG_INFO(), "REPAIR: " + who + " INTIMACY set to " + word + \\
            " (minTier " + tier + ")")
        IEB_LockChildIntimacy(akActor)   ; Patch R5 (IEB §11.10.2)
""",
         """        If IEB_LockChildIntimacy(akActor)   ; Patch R5 (IEB §11.10.2); logged after the lock (r55)
            Diag(LOG_INFO(), "REPAIR: " + who + " INTIMACY locked (IsChild): requested minTier " + tier + \\
                " refused, stored minTier " + StorageUtil.GetIntValue(akActor, "SNRom_PhysMinTier", 4) + \\
                "/bypass " + StorageUtil.GetIntValue(akActor, "SNRom_PhysAttrBypass", 0))
        Else
            Diag(LOG_INFO(), "REPAIR: " + who + " INTIMACY set to " + word + \\
                " (minTier " + tier + ")")
        EndIf
"""),
        # (b) ForceDriftReview: a child is refused, as R9
        ("""    If _driftActor != None
        Diag(LOG_WARN(), "Releasing the drift slot held by " + _driftName + \\
            " to force a review of " + akActor.GetDisplayName())
""",
         """    If akActor.IsChild()   ; Patch R9b (IEB r55): the dev tool obeys R9 too
        Diag(LOG_INFO(), "ForceDriftReview refused for " + akActor.GetDisplayName() + ": IsChild")
        Return
    EndIf
    If _driftActor != None
        Diag(LOG_WARN(), "Releasing the drift slot held by " + _driftName + \\
            " to force a review of " + akActor.GetDisplayName())
"""),
        # (a2) ApplyCharacter: a child's line reports the stored (locked) values, not the parsed default
        ("""    Diag(LOG_INFO(), "Character for " + akActor.GetDisplayName() + \\
        ": " + orientPart + \\
        " intimacy='" + intimWord + "'->minTier" + minTier + "/bypass" + bypass + \\
""",
         """    String intimPart = " intimacy='" + intimWord + "'->minTier" + minTier + "/bypass" + bypass
    If akActor.IsChild()   ; Patch (IEB r55): report the locked store, not the parse
        intimPart = " intimacy=LOCKED(IsChild)->minTier" + \\
            StorageUtil.GetIntValue(akActor, "SNRom_PhysMinTier", 4) + "/bypass" + \\
            StorageUtil.GetIntValue(akActor, "SNRom_PhysAttrBypass", 0)
    EndIf
    Diag(LOG_INFO(), "Character for " + akActor.GetDisplayName() + \\
        ": " + orientPart + \\
        intimPart + \\
"""),
    ])

elif G == "headstart":   # Shae 2026-10-10 (REVIEW_LOG RV-69-dec): priestess head start, options A + B
    edit(B, [
("""    AuthorDisposition(akActor)
EndFunction

String Function EnrollByHand""",
"""    IEB_HeadStartFloor(akActor)   ; Patch (RV-69-dec A): once, Lucienne's game only, adults only
    AuthorDisposition(akActor)
EndFunction

String Function EnrollByHand"""),
("""    Int magnitude = ScaleAward(clamped)
""",
"""    Int magnitude = ScaleAward(clamped)
    magnitude += IEB_HeadStartBonus(akActor, magnitude)   ; Patch (RV-69-dec B): positive only, stops below Lover
"""),
("""    ; CHECK THE RETURN. In 1.x Romantasy rejected points""",
"""    awarded += IEB_HeadStartBonus(akActor, awarded)   ; Patch (RV-69-dec B): after the daily cap, so the cap never undoes it

    ; CHECK THE RETURN. In 1.x Romantasy rejected points"""),
("""    ApplyDepth(akActor, ScaleAward(25), asMoment, False, "spark")
""",
"""    Int sparkPts = ScaleAward(25)
    sparkPts += IEB_HeadStartBonus(akActor, sparkPts)   ; Patch (RV-69-dec B)
    ApplyDepth(akActor, sparkPts, asMoment, False, "spark")
"""),
    ])
    append(B, """
; =============================================================================
; Patch (Shae 2026-10-10, REVIEW_LOG RV-69-dec): Relationships head start for the priestess at Azura's shrine (ref
; 0x00028AD1), Lucienne's game only (LUC_Active, the key the Lucienne layer gates on), adults only.
;  A: once, at enrolment (EnrollNow, every route: by hand, AutoEnroll, M4'), points = max(current, 999). 999 is the
;     top of Acquaintance: below Friend 1000 (CASUAL physical gate), the 1500 out-of-turn spark and Lover 2000.
;     Latched by IEB_HeadStartUsed before the write (UnenrollActor does not clear it), so it is never paid twice.
;     Writes only SNRom_Points (through ApplyDepth, kind "seed"); SeedTarget/SeedAssessed/ReseedActor are untouched
;     and only top up from their own read.
;  B: a positive award (talk, MarkMoment, spark) counts double while she is below Lover. The extra never lifts her
;     to 2000 or into the bank: HoldShortOfLover banks a whole delta that would cross, so the extra stops at
;     UNANSWERED_MAX - points - award, and is 0 once anything is banked. Negative awards, the bank release
;     (AcceptRomance), DeclineRomance and EndRomance never see it. The consent gate (R1-R10/R10a, RankSync,
;     HoldShortOfLover, CheckRomanceQuestion) is unchanged.
; =============================================================================
Bool Function IEB_HeadStartFor(Actor a)
    If a == None || a.IsChild() || a.IsDead()
        Return False
    EndIf
    If a.GetFormID() != 0x00028AD1
        Return False
    EndIf
    Return StorageUtil.GetIntValue(Game.GetPlayer(), "LUC_Active", 0) == 1
EndFunction

Function IEB_HeadStartFloor(Actor a)
    If !IEB_HeadStartFor(a) || StorageUtil.GetIntValue(a, "IEB_HeadStartUsed", 0) != 0
        Return
    EndIf
    StorageUtil.SetIntValue(a, "IEB_HeadStartUsed", 1)
    Int delta = 999 - PointsOf(a)
    If delta > 0
        ApplyDepth(a, delta, "head start", False, "seed")
    EndIf
    Diag(LOG_INFO(), "IEB_HEADSTART floor " + a.GetDisplayName() + " delta=" + delta + " points=" + PointsOf(a))
EndFunction

Int Function IEB_HeadStartBonus(Actor a, Int aiAward)
    If aiAward <= 0 || !IEB_HeadStartFor(a)
        Return 0
    EndIf
    If StorageUtil.GetIntValue(a, "SNRom_BankedPoints", 0) > 0
        Return 0
    EndIf
    Int extra = UNANSWERED_MAX() - PointsOf(a) - aiAward
    If extra <= 0
        Return 0
    EndIf
    If aiAward < extra
        extra = aiAward
    EndIf
    Diag(LOG_INFO(), "IEB_HEADSTART bonus " + a.GetDisplayName() + " award=" + aiAward + " extra=" + extra)
    Return extra
EndFunction
""")

elif G == "headstart-spark":   # REVIEW_LOG RV-77 (1): BeginSpark enrols without EnrollNow
    # The floor goes AFTER the +25 (not right after the roster add): floor first would give 999 + 25 + 25 = 1049 =
    # Friend at enrolment, opening the CASUAL physical gate that the 999 floor exists to stay below. +25 (with the
    # bonus) first, then max(current, 999) = 999.
    edit(B, [
("""    ApplyDepth(akActor, ScaleAward(25), asReason, False, "began")
""",
"""    Int beganPts = ScaleAward(25)
    beganPts += IEB_HeadStartBonus(akActor, beganPts)   ; Patch (RV-69-dec B, RV-77)
    ApplyDepth(akActor, beganPts, asReason, False, "began")
    IEB_HeadStartFloor(akActor)   ; Patch (RV-69-dec A, RV-77): after the +25, so she stays at 999, below Friend
"""),
    ])

else:
    raise SystemExit("unknown group " + G)
print("applied", G)
