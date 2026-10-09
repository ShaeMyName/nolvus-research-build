.info
  .source "C:\nolvus-research\build\upstream\relationships-2.0.1\src\scripts\SNRom_Decorators.psc"
  .compileTime 1791572374 ;2026-10-09 14:59:34
  .user "sharp"
  .computer "EMISSARY"
.endInfo
.userFlagsRef
  .flag hidden 0 ;0x00000001
.endUserFlagsRef
.objectTable
  .object SNRom_Decorators 
    .userFlags 1 ;hidden 
    .docString "Decorator functions for SkyrimNet.

  DELIBERATELY A STANDALONE HIDDEN SCRIPT, NOT THE QUEST SCRIPT.

  SkyrimNet's documented example registers decorators against a plain script
  containing Global functions:

      SkyrimNetApi.RegisterDecorator("get_npc_mudcrab_status",
                                     "MudcrabMod_Decorators",
                                     "GetMudcrabStatus")
      String Function GetMudcrabStatus(Actor akActor) ...

  Hosting them as Global functions on a Quest-extending script (SNRom_Bridge)
  did not work: RegisterDecorator returned rc=0, but lookups failed with
  "EligibilityChecker: Decorator '<name>' not found". Removing Global instead
  produced "Papyrus: Failed to find function Dec_PhysicalOk in script
  SNRom_Bridge" - registry hit, dispatch miss.

  Rather than keep guessing which axis matters, this matches the documented
  shape exactly: standalone script, Global functions, no quest involvement.

  These read state only. Anything that MUTATES state stays on SNRom_Bridge,
  where the quest context and its cached fields live.

  EVERY FUNCTION RETURNS String - INCLUDING THE BOOLEAN ONES.
  Surveyed all 10 registered decorators across Player Needs, Baka, Playwright,
  iActions and OStimNet: every single one returns String, including Baka's
  IsInBakaAnimation which is semantically a boolean. Bool-returning decorators
  register with rc=0 and then fail at lookup/dispatch. This - not Global, and
  not quest-vs-standalone - was the actual cause."
    .autoState 
    .variableTable
    .endVariableTable
    .propertyTable
    .endPropertyTable
    .stateTable
      .state 
        .function GetState
          .userFlags 0 ;none
          .docString "Function that returns the current state"
          .return String
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            return ::State 
          .endCode
        .endFunction ;GetState
        .function GotoState
          .userFlags 0 ;none
          .docString "Function that switches this object to the specified state"
          .return None
          .paramTable
            .param newState String
          .endParamTable
          .localTable
            .local ::nonevar None
          .endLocalTable
          .code
            callmethod onEndState self ::nonevar ;0 variable args
            assign ::State newState 
            callmethod onBeginState self ::nonevar ;0 variable args
          .endCode
        .endFunction ;GotoState
        .function IsEnrolled
           ; function type 0
          .userFlags 0 ;none
          .docString "Enrollment is SNRom_Enrolled from 2.0 (SNRom_Bridge.IsEnrolled), not
      "Romantasy has a level for them"."
          .return String
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 36
            callstatic sNRom_Bridge IsEnrolled ::temp0 akActor ;1 variable args
            jmpf ::temp0 _label0
            ; line 37
            return "true" 
            jmp _label0
            ; line 39
          _label0:
            return "false" 
          .endCode
        .endFunction ;IsEnrolled
        .function CanBegin
           ; function type 0
          .userFlags 0 ;none
          .docString "Hard gates live here, not in an action description, so the model cannot
      talk its way past receptivity or the attraction floor."
          .return String
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 45
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            callstatic sNRom_Bridge IsEnrolled ::temp1 akActor ;1 variable args
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 46
            return "false" 
            jmp _label1
            ; line 59
          _label1:
            callstatic sNRom_Bridge IsFollowing ::temp1 akActor ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 60
            return "false" 
            jmp _label2
            ; line 65
          _label2:
            callstatic sNRom_Decorators RomanceOk ::temp1 akActor ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label3
            ; line 66
            return "false" 
            jmp _label3
            ; line 68
          _label3:
            return "true" 
          .endCode
        .endFunction ;CanBegin
        .function PhysicalOk
           ; function type 0
          .userFlags 0 ;none
          .docString "s = [minTier, attractionCanBypass, emotionalWeight]. Governs SEXUAL
      intimacy only - affection tracks the emotional bond, or a devout
      character would refuse to be kissed until married."
          .return String
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 Int
            .local minTier Int
            .local ::temp3 form
            .local rank Int
            .local tier Int
            .local banked Int
            .local earned Int
            .local ratio Float
            .local ::temp4 Float
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 75
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 76
            return "false" 
            jmp _label0
            ; line 92
          _label0:
            callstatic sNRom_Decorators RomanceApplicability ::temp2 akActor -1 ;2 variable args
            cmp_eq ::temp1 ::temp2 0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label1
            ; line 93
            return "false" 
            jmp _label1
            ; line 95
          _label1:
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp3 "SNRom_PhysMinTier" 4 ;3 variable args
            assign minTier ::temp2 
            ; line 96
            cmp_lt ::temp1 minTier 0 
            jmpf ::temp1 _label2
            ; line 97
            return "false" 
            jmp _label2
            ; line 125
          _label2:
            callstatic sNRom_Decorators IntimacyRank ::temp2 minTier ;1 variable args
            assign rank ::temp2 
            ; line 126
            comp_gte ::temp1 rank 1 
            jmpf ::temp1 _label3
            ; line 127
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp3 "SNRom_Sparked" 0 ;3 variable args
            cmp_eq ::temp1 ::temp2 1 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label4
            callstatic sNRom_Bridge CommitmentState ::temp2 akActor ;1 variable args
            cmp_lt ::temp1 ::temp2 2 
            assign ::temp1 ::temp1 
          _label4:
            jmpf ::temp1 _label5
            ; line 128
            return "false" 
            jmp _label5
            ; line 130
          _label5:
            cmp_eq ::temp1 rank 1 
            jmpf ::temp1 _label6
            ; line 131
            assign minTier 3 
            jmp _label6
          _label6:
            jmp _label3
            ; line 137
          _label3:
            assign tier -1 
            ; line 138
            callstatic sNRom_Bridge IsEnrolled ::temp1 akActor ;1 variable args
            jmpf ::temp1 _label7
            ; line 139
            callstatic sNRom_Bridge TierOf ::temp2 akActor ;1 variable args
            assign tier ::temp2 
            jmp _label7
            ; line 141
          _label7:
            comp_gte ::temp1 tier minTier 
            jmpf ::temp1 _label8
            ; line 142
            return "true" 
            jmp _label8
            ; line 174
          _label8:
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp3 "SNRom_BankedPoints" 0 ;3 variable args
            assign banked ::temp2 
            ; line 175
            cmp_gt ::temp1 banked 0 
            jmpf ::temp1 _label9
            ; line 176
            callstatic sNRom_Bridge PointsOf ::temp2 akActor ;1 variable args
            iadd ::temp2 ::temp2 banked 
            idiv ::temp2 ::temp2 500 
            assign earned ::temp2 
            ; line 177
            comp_gte ::temp1 earned minTier 
            jmpf ::temp1 _label10
            ; line 178
            return "true" 
            jmp _label10
          _label10:
            jmp _label9
            ; line 181
          _label9:
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp3 "SNRom_PhysAttrBypass" 0 ;3 variable args
            cmp_eq ::temp1 ::temp2 1 
            jmpf ::temp1 _label11
            ; line 193
            cast ::temp3 akActor 
            callstatic storageUtil GetFloatValue ::temp4 ::temp3 "SNRom_AttractionRatio" 0.0 ;3 variable args
            assign ratio ::temp4 
            ; line 194
            cmp_gt ::temp1 ratio 0.0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label12
            callstatic sNRom_Bridge CFG ::temp5 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp4 ::temp5 "attractionBypassRatio" 1.5 ;3 variable args
            comp_gte ::temp1 ratio ::temp4 
            assign ::temp1 ::temp1 
          _label12:
            jmpf ::temp1 _label13
            ; line 195
            return "true" 
            jmp _label13
          _label13:
            jmp _label11
            ; line 198
          _label11:
            return "false" 
          .endCode
        .endFunction ;PhysicalOk
        .function JsonBool
           ; function type 0
          .userFlags 0 ;none
          .docString "Emits an unquoted JSON literal so Inja sees a real boolean - "false" as
      a STRING is truthy, which would put every NPC on the romantic ladder."
          .return String
          .paramTable
            .param abValue Bool
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 204
            jmpf abValue _label0
            ; line 205
            return "true" 
            jmp _label0
            ; line 207
          _label0:
            return "false" 
          .endCode
        .endFunction ;JsonBool
        .function IsSparked
           ; function type 0
          .userFlags 0 ;none
          .docString "Selects which ladder 0330_relationships_bond renders: platonic or romantic.

      ONE explicit flag, no inference. SNRom_Sparked is set by BeginSpark and
      deliberately NOT by AutoEnroll, so the romantic ladder requires that
      something actually happened.

      There WAS a migration here that treated faction membership as evidence
      of a past spark, on the reasoning that before this flag existed the only
      way into ROM_RomanceLevel was a deliberate BeginSpark. Removed
      2026-07-29. Two reasons:

      1. It was false in practice. Every enrolled NPC on the current save got
         there through development testing, not through a spark, and Jordis
         was rendering "something has shifted... sideways glances" over a bond
         with 0 points and no history.
      2. It was a permanent trap. ANY route into that faction - another mod, a
         console command, a future feature - would have read as romance
         forever, with nothing to distinguish it.

      An inference that quietly asserts a romance is worse than a flag that
      occasionally has to be set by hand."
          .return Bool
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
          .endLocalTable
          .code
            ; line 232
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 233
            return False 
            jmp _label0
            ; line 235
          _label0:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Sparked" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            return ::temp1 
          .endCode
        .endFunction ;IsSparked
        .function OrientationBasisToInt
           ; function type 0
          .userFlags 0 ;none
          .docString "Confidence in the orientation value. 0 unknown, 1 inferred, 2 known.

      This exists because of Lynea. She was handed ORIENTATION: WOMEN from a
      twelve-word bio containing no evidence either way, and that invented
      answer immediately hard-blocked a romance the player had spent hours
      building. The bug was not a wrong guess - it was FORCING a guess where
      the honest answer was "nobody has established this yet".

      Unrecognized input means unknown, which is the permissive branch."
          .return Int
          .paramTable
            .param asWord String
          .endParamTable
          .localTable
            .local w String
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 248
            callstatic sNRom_Decorators Trim ::temp0 asWord ;1 variable args
            callstatic sNRom_Decorators Upper ::temp0 ::temp0 ;1 variable args
            assign w ::temp0 
            ; line 249
            cmp_eq ::temp1 w "STATED" 
            jmpf ::temp1 _label0
            ; line 250
            return 2 
            jmp _label1
            ; line 251
          _label0:
            cmp_eq ::temp1 w "IMPLIED" 
            jmpf ::temp1 _label1
            ; line 252
            return 1 
            jmp _label1
            ; line 254
          _label1:
            return 0 
          .endCode
        .endFunction ;OrientationBasisToInt
        .function IsPlayerKin
           ; function type 0
          .userFlags 0 ;none
          .docString "True if SkyrimNet-Kinship records this actor as the player's child.

      SOFT DEPENDENCY BY CONSTRUCTION. Kinship sets `SNKin_Bound` to 1 on the
      CHILD actor when it binds them to its roster
      (`StorageUtil.SetIntValue(akChild, "SNKin_Bound", 1)`), and StorageUtil is
      a shared namespace, so reading it needs no compile-time reference to
      Kinship at all. Without Kinship installed the key is absent, the read
      returns the 0 default, and every gate below behaves exactly as it did
      before this function existed.

      An Int, not a string, so it survives a save reload.

      DELIBERATELY NOT reading Kinship's JSON store or its `ref.<formid>.child`
      mapping. Those are its internals and it is free to change them; the
      per-actor flag is the part another mod can reasonably lean on.

      TWO KEYS, ON PURPOSE, FOR ONE RELEASE.

      `SNKin_IsPlayerChild` (Kinship 1.1.0+) is the correct answer. It is
      written on every path that establishes child identity - INCLUDING the
      paths where `BindChildRef` deliberately refuses to bind, which is the case
      that matters: Fertility Mode reuses one spawned actor across children
      sharing an appearance archetype, and Kinship would rather leave the second
      child unbound than give one NPC two identities. That actor is
      unambiguously the player's child.

      `SNKin_Bound` (Kinship 1.0.0) is the fallback and is WEAKER THAN IT LOOKS.
      It means "bound to Kinship's roster", not "is the player's child", and in
      the refused-binding case above it is never written at all - so a read of
      it alone returns 0 and this guard FAILS OPEN on a real child. Kinship
      found that; the first version of this function shipped with it.

      Kinship's own `kinship_is_child` decorator already compensates by falling
      through to a dynamic-ref plus name lookup, so the prompt-side answer has
      been strictly more correct than this Papyrus-side one. 1.1.0 closes that.

      Drop the `SNKin_Bound` half once Kinship 1.1.0 is a stated requirement.
      Absent Kinship entirely BOTH read 0 and the guard is inert, which is the
      intended soft-dependency behavior and unchanged by any of this."
          .return Bool
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
          .endLocalTable
          .code
            ; line 297
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 298
            return False 
            jmp _label0
            ; line 300
          _label0:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNKin_IsPlayerChild" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            ; line 301
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNKin_Bound" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            assign ::temp1 ::temp1 
          _label1:
            return ::temp1 
          .endCode
        .endFunction ;IsPlayerKin
        .function KinGuardOn
           ; function type 0
          .userFlags 0 ;none
          .docString "Whether the player's own children are barred from the romantic and sexual
      ladders. Named so it cannot case-fold into its own config path - see the
      note on VoiceLeadSeconds in SNRom_Bridge for what that collision costs.

      Default ON. It costs nothing when Kinship is absent, because IsPlayerKin
      reads 0 for everyone."
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 311
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp1 ::temp0 "kinshipBlockRomance" True ;3 variable args
            return ::temp1 
          .endCode
        .endFunction ;KinGuardOn
        .function RomanceApplicability
           ; function type 0
          .userFlags 0 ;none
          .docString "Is the romantic question FORECLOSED for this pair by something outside the
      character's own disposition? 0 applies, 1 kin, 2 minor, 3 orientation.

      WHY THIS IS NOT RomanceOk. They answer different questions and must not be
      collapsed:

        RomanceOk      - can this pair cross into Lover? Includes the character's
                         OWN choice, so an authored "drawn to nobody" refuses.
        Applicability  - was it ever a live question at all? Only structural
                         facts, never a preference.

      The distinction earns its keep in the prompt. A character who wants nobody
      already has text written for her - "this is not something you want, from
      anyone, and that has been true a long time. It is not damage" - and that is
      a better line than any generic not-applicable phrasing. She keeps it. What
      needs the new state is the pair for whom the question never arose: the
      player's child, a minor, someone whose known orientation does not include
      this player.

      DERIVED, NEVER STORED, and that is the whole design. Every input is read at
      call time, so the answer changes the moment the fact does - a child who
      matures stops being a minor, a bio block changed to "drawn to both" stops
      foreclosing on the next disposition review. Persisting this would need
      invalidating, and latched state that nothing invalidates is this mod's most
      repeated bug: the seed stamp, the marriage snapshot, the assessor's pending
      slot. There is no SNRom_ key here on purpose.

      ONE PLACE TO ADD A REASON. Callers ask "is it foreclosed", never "is this a
      child" - the prompt tests the field against 0 and nothing else - so a fourth
      reason is one branch here and zero edits anywhere else. And one in the
      dashboard's copy of this function: Display::Applicability in
      native/src/Display.cpp, line for line, which draws the page. Change one,
      change both.

      AN INT, NOT A REASON STRING. Papyrus interns strings case-insensitively, so
      a "kin" literal can ship as "Kin" depending on what else holds the slot in
      the .pex - the failure documented at length in GetRomance. An Int cannot
      case-fold."
          .return Int
          .paramTable
            .param akActor actor
            .param aiKinGuard Int
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 Int
            .local ::temp3 form
            .local orient Int
            .local playerSex Int
            .local ::temp4 actorBase
          .endLocalTable
          .code
            ; line 353
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 354
            return 0 
            jmp _label0
            ; line 365
          _label0:
            cmp_lt ::temp1 aiKinGuard 0 
            jmpf ::temp1 _label1
            ; line 366
            callstatic sNRom_Decorators KinGuardOn ::temp1 ;0 variable args
            cast ::temp2 ::temp1 
            assign aiKinGuard ::temp2 
            jmp _label1
            ; line 368
          _label1:
            cmp_gt ::temp1 aiKinGuard 0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            callstatic sNRom_Decorators IsPlayerKin ::temp1 akActor ;1 variable args
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 369
            return 1 
            jmp _label3
            ; line 377
          _label3:
            callmethod IsChild akActor ::temp1 ;0 variable args
            jmpf ::temp1 _label4
            ; line 378
            return 2 
            jmp _label4
            ; line 383
          _label4:
            callstatic sNRom_Bridge IsMarriedToPlayer ::temp1 akActor ;1 variable args
            jmpf ::temp1 _label5
            ; line 384
            return 0 
            jmp _label5
            ; line 389
          _label5:
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp3 "SNRom_OrientationKnown" 0 ;3 variable args
            cmp_lt ::temp1 ::temp2 2 
            jmpf ::temp1 _label6
            ; line 390
            return 0 
            jmp _label6
            ; line 393
          _label6:
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp3 "SNRom_Orientation" 3 ;3 variable args
            assign orient ::temp2 
            ; line 394
            cmp_eq ::temp1 orient 0 
            jmpf ::temp1 _label7
            ; line 395
            return 0 
            jmp _label7
            ; line 397
          _label7:
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod GetActorBase ::temp0 ::temp4 ;0 variable args
            callmethod GetSex ::temp4 ::temp2 ;0 variable args
            assign playerSex ::temp2 
            ; line 398
            cmp_eq ::temp1 orient 1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label8
            cmp_eq ::temp1 playerSex 0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label8:
            jmpf ::temp1 _label9
            ; line 399
            return 3 
            jmp _label10
            ; line 400
          _label9:
            cmp_eq ::temp1 orient 2 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label11
            cmp_eq ::temp1 playerSex 1 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label11:
            jmpf ::temp1 _label10
            ; line 401
            return 3 
            jmp _label10
            ; line 403
          _label10:
            return 0 
          .endCode
        .endFunction ;RomanceApplicability
        .function RomanceOk
           ; function type 0
          .userFlags 0 ;none
          .docString "Does this person's orientation permit crossing into Lover with THIS
      player? Gates the top two rungs of the romantic ladder.

      ONLY a KNOWN orientation can refuse. Unknown and merely inferred both
      pass: an inference colors how she behaves, it does not get to delete
      content the player is working toward. A gate that silently removes a
      storyline had better be standing on a fact."
          .return Bool
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local orient Int
            .local playerSex Int
            .local ::temp4 actorBase
          .endLocalTable
          .code
            ; line 414
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 415
            return False 
            jmp _label0
            ; line 421
          _label0:
            callstatic sNRom_Decorators KinGuardOn ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            callstatic sNRom_Decorators IsPlayerKin ::temp1 akActor ;1 variable args
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 422
            return False 
            jmp _label2
            ; line 442
          _label2:
            callstatic sNRom_Bridge IsMarriedToPlayer ::temp1 akActor ;1 variable args
            jmpf ::temp1 _label3
            ; line 443
            return True 
            jmp _label3
            ; line 445
          _label3:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_OrientationKnown" 0 ;3 variable args
            cmp_lt ::temp1 ::temp3 2 
            jmpf ::temp1 _label4
            ; line 446
            return True 
            jmp _label4
            ; line 449
          _label4:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Orientation" 3 ;3 variable args
            assign orient ::temp3 
            ; line 450
            cmp_eq ::temp1 orient 0 
            jmpf ::temp1 _label5
            ; line 451
            return False 
            jmp _label5
            ; line 453
          _label5:
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod GetActorBase ::temp0 ::temp4 ;0 variable args
            callmethod GetSex ::temp4 ::temp3 ;0 variable args
            assign playerSex ::temp3 
            ; line 454
            cmp_eq ::temp1 orient 1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label6
            cmp_eq ::temp1 playerSex 0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label6:
            jmpf ::temp1 _label7
            ; line 455
            return False 
            jmp _label8
            ; line 456
          _label7:
            cmp_eq ::temp1 orient 2 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label9
            cmp_eq ::temp1 playerSex 1 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label9:
            jmpf ::temp1 _label8
            ; line 457
            return False 
            jmp _label8
            ; line 459
          _label8:
            return True 
          .endCode
        .endFunction ;RomanceOk
        .function OrientationWord
           ; function type 0
          .userFlags 0 ;none
          .docString "Human-readable form for the bio block. Deliberately returns "" unless
      the orientation is KNOWN - the block states facts, and an inference is
      not a fact. Silence is what invites the story to discover it."
          .return String
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local o Int
          .endLocalTable
          .code
            ; line 466
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 467
            return "" 
            jmp _label0
            ; line 469
          _label0:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_OrientationKnown" 0 ;3 variable args
            cmp_lt ::temp1 ::temp3 2 
            jmpf ::temp1 _label1
            ; line 470
            return "" 
            jmp _label1
            ; line 472
          _label1:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Orientation" 3 ;3 variable args
            assign o ::temp3 
            ; line 473
            cmp_eq ::temp1 o 1 
            jmpf ::temp1 _label2
            ; line 474
            return "men" 
            jmp _label3
            ; line 475
          _label2:
            cmp_eq ::temp1 o 2 
            jmpf ::temp1 _label4
            ; line 476
            return "women" 
            jmp _label3
            ; line 477
          _label4:
            cmp_eq ::temp1 o 0 
            jmpf ::temp1 _label3
            ; line 478
            return "no one" 
            jmp _label3
            ; line 480
          _label3:
            return "both men and women" 
          .endCode
        .endFunction ;OrientationWord
        .function OtherPartners
           ; function type 0
          .userFlags 0 ;none
          .docString "Acknowledged romances the player has with someone OTHER than this actor.

      MINUS SELF, which is the whole point: a woman who is one of two partners
      has ONE other, not two, and telling her otherwise makes her count herself
      as a rival. The total is cached by RefreshPartnerCount on the housekeeping
      tick; this only subtracts.

      Reads 0 when nothing has been counted yet, which renders as "no others" -
      the same thing the prompt said before this field existed, so a missing
      count changes nothing."
          .return Int
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local total Int
            .local ::temp2 form
            .local ::temp3 Int
          .endLocalTable
          .code
            ; line 494
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 495
            return 0 
            jmp _label0
            ; line 497
          _label0:
            cast ::temp2 None 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_PartnerCount" 0 ;3 variable args
            assign total ::temp3 
            ; line 498
            callstatic sNRom_Decorators IsSparked ::temp1 akActor ;1 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            ; line 499
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_PlayerStance" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 500
            isub ::temp3 total 1 
            assign total ::temp3 
            jmp _label2
            ; line 502
          _label2:
            cmp_lt ::temp1 total 0 
            jmpf ::temp1 _label3
            ; line 503
            return 0 
            jmp _label3
            ; line 505
          _label3:
            return total 
          .endCode
        .endFunction ;OtherPartners
        .function GetRomance
           ; function type 0
          .userFlags 0 ;none
          .docString "Rich state for prompts. Never call inside a get_nearby_npc_list loop -
      mod-added decorators only resolve for the current speaker or target."
          .return String
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local pts Int
            .local ::temp2 Int
            .local tier Int
            .local toNext Int
            .local sparkedFlag Int
            .local romanceOkFlag Int
            .local ::temp3 String
            .local ::temp4 String
            .local ::temp5 form
          .endLocalTable
          .code
            ; line 511
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 512
            return "{\"enrolled\":false}" 
            jmp _label0
            ; line 514
          _label0:
            callstatic sNRom_Bridge IsEnrolled ::temp1 akActor ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label1
            ; line 515
            return "{\"enrolled\":false}" 
            jmp _label1
            ; line 518
          _label1:
            callstatic sNRom_Bridge PointsOf ::temp2 akActor ;1 variable args
            assign pts ::temp2 
            ; line 519
            callstatic sNRom_Bridge TierForPoints ::temp2 pts ;1 variable args
            assign tier ::temp2 
            ; line 520
            iadd ::temp2 tier 1 
            imul ::temp2 ::temp2 500 
            isub ::temp2 ::temp2 pts 
            assign toNext ::temp2 
            ; line 543
            assign sparkedFlag 0 
            ; line 544
            callstatic sNRom_Decorators IsSparked ::temp1 akActor ;1 variable args
            jmpf ::temp1 _label2
            ; line 545
            assign sparkedFlag 1 
            jmp _label2
            ; line 547
          _label2:
            assign romanceOkFlag 0 
            ; line 548
            callstatic sNRom_Decorators RomanceOk ::temp1 akActor ;1 variable args
            jmpf ::temp1 _label3
            ; line 549
            assign romanceOkFlag 1 
            jmp _label3
            ; line 551
          _label3:
            cmp_lt ::temp1 toNext 0 
            jmpf ::temp1 _label4
            ; line 552
            assign toNext 0 
            jmp _label4
            ; line 554
          _label4:
            cast ::temp3 pts 
            strcat ::temp3 "{\"enrolled\":true,\"points\":" ::temp3 
            strcat ::temp3 ::temp3 ",\"level\":" 
            cast ::temp4 tier 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ",\"levelName\":\"" 
            ; line 555
            callstatic sNRom_Bridge TierName ::temp3 tier ;1 variable args
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 "\",\"toNext\":" 
            cast ::temp4 toNext 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ",\"ardor\":" 
            ; line 556
            cast ::temp5 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp5 "SNRom_Ardor" 2 ;3 variable args
            cast ::temp3 ::temp2 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 ",\"exclusivity\":" 
            ; line 557
            cast ::temp5 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp5 "SNRom_Exclusivity" 50 ;3 variable args
            cast ::temp4 ::temp2 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ",\"sparked\":" 
            ; line 558
            cast ::temp3 sparkedFlag 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 ",\"romanceOk\":" 
            ; line 559
            cast ::temp4 romanceOkFlag 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ",\"orientation\":\"" 
            ; line 560
            callstatic sNRom_Decorators OrientationWord ::temp3 akActor ;1 variable args
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 "\"" 
            strcat ::temp3 ::temp3 ",\"orientationKnown\":" 
            ; line 561
            cast ::temp5 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp5 "SNRom_OrientationKnown" 0 ;3 variable args
            cast ::temp4 ::temp2 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ",\"why\":\"" 
            ; line 562
            callstatic sNRom_Bridge StoreGetText ::temp3 akActor "Why" "" 0 ;4 variable args
            callstatic sNRom_Decorators JsonEscape ::temp3 ::temp3 ;1 variable args
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 "\"" 
            strcat ::temp3 ::temp3 ",\"limit\":\"" 
            ; line 563
            callstatic sNRom_Bridge StoreGetText ::temp4 akActor "Limit" "" 0 ;4 variable args
            callstatic sNRom_Decorators JsonEscape ::temp4 ::temp4 ;1 variable args
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 "\"" 
            strcat ::temp4 ::temp4 ",\"address\":\"" 
            ; line 564
            callstatic sNRom_Bridge StoreGetText ::temp3 akActor "Address" "" 0 ;4 variable args
            callstatic sNRom_Decorators JsonEscape ::temp3 ::temp3 ;1 variable args
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 "\"" 
            strcat ::temp3 ::temp3 ",\"romanceNA\":" 
            ; line 565
            callstatic sNRom_Decorators RomanceApplicability ::temp2 akActor -1 ;2 variable args
            cast ::temp4 ::temp2 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ",\"physMinTier\":" 
            ; line 566
            cast ::temp5 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp5 "SNRom_PhysMinTier" 4 ;3 variable args
            cast ::temp3 ::temp2 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 ",\"otherPartners\":" 
            ; line 567
            callstatic sNRom_Decorators OtherPartners ::temp2 akActor ;1 variable args
            cast ::temp4 ::temp2 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ",\"stance\":" 
            ; line 568
            cast ::temp5 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp5 "SNRom_PlayerStance" 0 ;3 variable args
            cast ::temp3 ::temp2 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 "}" 
            return ::temp3 
          .endCode
        .endFunction ;GetRomance
        .function Upper
           ; function type 0
          .userFlags 0 ;none
          .docString "PapyrusUtil's StringUtil has NO ToUpper - only GetLength, GetNthChar,
      Find, Substring, AsOrd, AsChar and Split. Fold manually so label matching
      survives whatever casing the model returns."
          .return String
          .paramTable
            .param asText String
          .endParamTable
          .localTable
            .local out String
            .local i Int
            .local n Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local c String
            .local ::temp2 String
            .local o Int
          .endLocalTable
          .code
            ; line 579
            assign out "" 
            ; line 580
            assign i 0 
            ; line 581
            callstatic stringUtil GetLength ::temp0 asText ;1 variable args
            assign n ::temp0 
            ; line 582
          _label3:
            cmp_lt ::temp1 i n 
            jmpf ::temp1 _label0
            ; line 583
            callstatic stringUtil GetNthChar ::temp2 asText i ;2 variable args
            assign c ::temp2 
            ; line 584
            callstatic stringUtil AsOrd ::temp0 c ;1 variable args
            assign o ::temp0 
            ; line 585
            comp_gte ::temp1 o 97 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            cmp_lte ::temp1 o 122 
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 586
            isub ::temp0 o 32 
            callstatic stringUtil AsChar ::temp2 ::temp0 ;1 variable args
            assign c ::temp2 
            jmp _label2
            ; line 588
          _label2:
            strcat ::temp2 out c 
            assign out ::temp2 
            ; line 589
            iadd ::temp0 i 1 
            assign i ::temp0 
            jmp _label3
            ; line 591
          _label0:
            return out 
          .endCode
        .endFunction ;Upper
        .function NameCore
           ; function type 0
          .userFlags 0 ;none
          .docString "Upper-folds a name and strips every NON-LETTER from BOTH ENDS, for
      comparing a model's echoed NAME: against the NPC we actually asked about.

      Written 2026-08-07. Bryling's assessments were being answered correctly
      and thrown away anyway: the model replied with

          NAME: "Bryling",

      - JSON habit bleeding into a labeled-line format - so the guard compared
      '"BRYLING",' against 'BRYLING', called it a mismatch, and discarded every
      single assessment she generated. The response was RIGHT. The comparison
      was too literal.

      Only the ENDS are trimmed, so internal spaces, hyphens and apostrophes
      survive: "Svana Far-Shield" and "Jarl Elisif the Fair" still compare
      intact, and two genuinely different NPCs still cannot collide. That
      matters - this guard is the only thing stopping a response about a nearby
      NPC from rewriting someone else's disposition permanently, so it must be
      loosened exactly this far and no further.

      Empty in, empty out. Callers treat an empty core as "no echo present"
      rather than as a mismatch."
          .return String
          .paramTable
            .param asName String
          .endParamTable
          .localTable
            .local up String
            .local ::temp0 String
            .local n Int
            .local ::temp1 Int
            .local first Int
            .local ::temp2 Bool
            .local last Int
          .endLocalTable
          .code
            ; line 617
            callstatic sNRom_Decorators Upper ::temp0 asName ;1 variable args
            assign up ::temp0 
            ; line 618
            callstatic stringUtil GetLength ::temp1 up ;1 variable args
            assign n ::temp1 
            ; line 619
            assign first 0 
            ; line 620
          _label2:
            cmp_lt ::temp2 first n 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label0
            callstatic stringUtil GetNthChar ::temp0 up first ;2 variable args
            callstatic stringUtil AsOrd ::temp1 ::temp0 ;1 variable args
            callstatic sNRom_Decorators IsLetterOrd ::temp2 ::temp1 ;1 variable args
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label0:
            jmpf ::temp2 _label1
            ; line 621
            iadd ::temp1 first 1 
            assign first ::temp1 
            jmp _label2
            ; line 623
          _label1:
            isub ::temp1 n 1 
            assign last ::temp1 
            ; line 624
          _label5:
            cmp_gt ::temp2 last first 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label3
            callstatic stringUtil GetNthChar ::temp0 up last ;2 variable args
            callstatic stringUtil AsOrd ::temp1 ::temp0 ;1 variable args
            callstatic sNRom_Decorators IsLetterOrd ::temp2 ::temp1 ;1 variable args
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label3:
            jmpf ::temp2 _label4
            ; line 625
            isub ::temp1 last 1 
            assign last ::temp1 
            jmp _label5
            ; line 627
          _label4:
            cmp_gt ::temp2 first last 
            jmpf ::temp2 _label6
            ; line 628
            return "" 
            jmp _label6
            ; line 630
          _label6:
            isub ::temp1 last first 
            iadd ::temp1 ::temp1 1 
            callstatic stringUtil Substring ::temp0 up first ::temp1 ;3 variable args
            return ::temp0 
          .endCode
        .endFunction ;NameCore
        .function IsLetterOrd
           ; function type 0
          .userFlags 0 ;none
          .docString "A-Z only. NameCore upper-folds before calling this, so lowercase never
      reaches here."
          .return Bool
          .paramTable
            .param aiOrd Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 636
            comp_gte ::temp0 aiOrd 65 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label0
            cmp_lte ::temp0 aiOrd 90 
            assign ::temp0 ::temp0 
          _label0:
            return ::temp0 
          .endCode
        .endFunction ;IsLetterOrd
        .function IntimacyWordFromTier
           ; function type 0
          .userFlags 0 ;none
          .docString "Reverse of IntimacyToMinTier, for showing a companion's authored intimacy
      back to the model in BuildCircle. Kept next to the forward mapper so the
      two are read together; if one gains a value the other must too."
          .return String
          .paramTable
            .param aiMinTier Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 643
            cmp_lt ::temp0 aiMinTier 0 
            jmpf ::temp0 _label0
            ; line 644
            return "NEVER" 
            jmp _label1
            ; line 645
          _label0:
            comp_gte ::temp0 aiMinTier 5 
            jmpf ::temp0 _label2
            ; line 646
            return "GUARDED" 
            jmp _label1
            ; line 647
          _label2:
            cmp_eq ::temp0 aiMinTier 4 
            jmpf ::temp0 _label1
            ; line 648
            return "ROMANTIC" 
            jmp _label1
            ; line 650
          _label1:
            return "CASUAL" 
          .endCode
        .endFunction ;IntimacyWordFromTier
        .function IntimacyRank
           ; function type 0
          .userFlags 0 ;none
          .docString "Intimacy as a LADDER, most open to most closed: 0 casual, 1 romantic,
      2 guarded, 3 never.

      Needed because the stored form is a minimum tier and NEVER is -1, so the
      stored numbers do not sort. Drift has to move exactly one rung at a time
      and cannot do that arithmetic on a value where the most closed answer is
      also the smallest."
          .return Int
          .paramTable
            .param aiMinTier Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 661
            cmp_lt ::temp0 aiMinTier 0 
            jmpf ::temp0 _label0
            ; line 662
            return 3 
            jmp _label1
            ; line 663
          _label0:
            comp_gte ::temp0 aiMinTier 5 
            jmpf ::temp0 _label2
            ; line 664
            return 2 
            jmp _label1
            ; line 665
          _label2:
            cmp_eq ::temp0 aiMinTier 4 
            jmpf ::temp0 _label1
            ; line 666
            return 1 
            jmp _label1
            ; line 668
          _label1:
            return 0 
          .endCode
        .endFunction ;IntimacyRank
        .function MinTierFromRank
           ; function type 0
          .userFlags 0 ;none
          .docString "Inverse of IntimacyRank. Values must match IntimacyToMinTier exactly - if
      one gains a rung the other two must too."
          .return Int
          .paramTable
            .param aiRank Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 674
            comp_gte ::temp0 aiRank 3 
            jmpf ::temp0 _label0
            ; line 675
            return -1 
            jmp _label1
            ; line 676
          _label0:
            cmp_eq ::temp0 aiRank 2 
            jmpf ::temp0 _label2
            ; line 677
            return 5 
            jmp _label1
            ; line 678
          _label2:
            cmp_eq ::temp0 aiRank 1 
            jmpf ::temp0 _label1
            ; line 679
            return 4 
            jmp _label1
            ; line 681
          _label1:
            return 2 
          .endCode
        .endFunction ;MinTierFromRank
        .function ReplaceAll
           ; function type 0
          .userFlags 0 ;none
          .docString "StringUtil has no Replace either."
          .return String
          .paramTable
            .param asText String
            .param asFind String
            .param asWith String
          .endParamTable
          .localTable
            .local out String
            .local rest String
            .local at Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 686
            assign out "" 
            ; line 687
            assign rest asText 
            ; line 688
            callstatic stringUtil Find ::temp0 rest asFind 0 ;3 variable args
            assign at ::temp0 
            ; line 689
          _label1:
            comp_gte ::temp1 at 0 
            jmpf ::temp1 _label0
            ; line 690
            callstatic stringUtil Substring ::temp2 rest 0 at ;3 variable args
            strcat ::temp2 ::temp2 asWith 
            strcat ::temp2 out ::temp2 
            assign out ::temp2 
            ; line 691
            callstatic stringUtil GetLength ::temp0 asFind ;1 variable args
            iadd ::temp0 at ::temp0 
            callstatic stringUtil Substring ::temp2 rest ::temp0 0 ;3 variable args
            assign rest ::temp2 
            ; line 692
            callstatic stringUtil Find ::temp0 rest asFind 0 ;3 variable args
            assign at ::temp0 
            jmp _label1
            ; line 694
          _label0:
            strcat ::temp2 out rest 
            return ::temp2 
          .endCode
        .endFunction ;ReplaceAll
        .function Trim
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
            .param asText String
          .endParamTable
          .localTable
            .local t String
            .local ::temp0 Int
            .local ::temp1 Bool
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 698
            assign t asText 
            ; line 699
          _label2:
            callstatic stringUtil GetLength ::temp0 t ;1 variable args
            cmp_gt ::temp1 ::temp0 0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            callstatic stringUtil GetNthChar ::temp2 t 0 ;2 variable args
            cmp_eq ::temp1 ::temp2 " " 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 700
            callstatic stringUtil Substring ::temp2 t 1 0 ;3 variable args
            assign t ::temp2 
            jmp _label2
            ; line 702
          _label1:
            callstatic stringUtil GetLength ::temp0 t ;1 variable args
            cmp_gt ::temp1 ::temp0 0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label3
            callstatic stringUtil GetLength ::temp0 t ;1 variable args
            isub ::temp0 ::temp0 1 
            callstatic stringUtil GetNthChar ::temp2 t ::temp0 ;2 variable args
            cmp_eq ::temp1 ::temp2 " " 
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 703
            callstatic stringUtil GetLength ::temp0 t ;1 variable args
            isub ::temp0 ::temp0 1 
            callstatic stringUtil Substring ::temp2 t 0 ::temp0 ;3 variable args
            assign t ::temp2 
            jmp _label1
            ; line 705
          _label4:
            return t 
          .endCode
        .endFunction ;Trim
        .function OrientationToInt
           ; function type 0
          .userFlags 0 ;none
          .docString "0 none, 1 men, 2 women, 3 any. Matches SNRom_Decorators.CanBegin.

      TWO VOCABULARIES ACCEPTED, on purpose.

      The prompt now asks for ATTRACTED_TO_MEN / ATTRACTED_TO_WOMEN /
      ATTRACTED_TO_BOTH / ATTRACTED_TO_NEITHER, because the old bare MEN/WOMEN
      answers are the SAME TOKENS as the subject's own gender. Elisif came back
      WOMEN/STATED six times out of six - while married to a male player, with
      a diary full of loving him, and eventually with the prompt explicitly
      saying "this is NOT their own gender". Every other NPC answered ANY. The
      working theory is slot-filling from her unusually long first-person,
      heavily gendered diary, and directional tokens remove the collision.

      The old words stay accepted because a model that ignores the new
      vocabulary and answers WOMEN must still parse as WOMEN. Falling through
      to the default would turn a visible wrong answer into a silent one, and
      the authored word is logged either way, so keeping them costs no signal."
          .return Int
          .paramTable
            .param asWord String
          .endParamTable
          .localTable
            .local w String
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 739
            callstatic sNRom_Decorators Trim ::temp0 asWord ;1 variable args
            callstatic sNRom_Decorators Upper ::temp0 ::temp0 ;1 variable args
            assign w ::temp0 
            ; line 740
            cmp_eq ::temp1 w "ATTRACTED_TO_MEN" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 w "MEN" 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 741
            return 1 
            jmp _label2
            ; line 742
          _label1:
            cmp_eq ::temp1 w "ATTRACTED_TO_WOMEN" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label3
            cmp_eq ::temp1 w "WOMEN" 
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 743
            return 2 
            jmp _label2
            ; line 744
          _label4:
            cmp_eq ::temp1 w "ATTRACTED_TO_BOTH" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label5
            cmp_eq ::temp1 w "ANY" 
            assign ::temp1 ::temp1 
          _label5:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label6
            cmp_eq ::temp1 w "BOTH" 
            assign ::temp1 ::temp1 
          _label6:
            jmpf ::temp1 _label7
            ; line 745
            return 3 
            jmp _label2
            ; line 746
          _label7:
            cmp_eq ::temp1 w "ATTRACTED_TO_NEITHER" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label8
            cmp_eq ::temp1 w "NONE" 
            assign ::temp1 ::temp1 
          _label8:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label9
            cmp_eq ::temp1 w "NEITHER" 
            assign ::temp1 ::temp1 
          _label9:
            jmpf ::temp1 _label2
            ; line 747
            return 0 
            jmp _label2
            ; line 749
          _label2:
            return 3 
          .endCode
        .endFunction ;OrientationToInt
        .function IntimacyToMinTier
           ; function type 0
          .userFlags 0 ;none
          .docString "Feeds SNRom_PhysMinTier. -1 means never, otherwise the tier at which
      sexual intimacy becomes possible at all."
          .return Int
          .paramTable
            .param asWord String
          .endParamTable
          .localTable
            .local w String
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 755
            callstatic sNRom_Decorators Trim ::temp0 asWord ;1 variable args
            callstatic sNRom_Decorators Upper ::temp0 ::temp0 ;1 variable args
            assign w ::temp0 
            ; line 756
            cmp_eq ::temp1 w "NEVER" 
            jmpf ::temp1 _label0
            ; line 757
            return -1 
            jmp _label1
            ; line 758
          _label0:
            cmp_eq ::temp1 w "GUARDED" 
            jmpf ::temp1 _label2
            ; line 759
            return 5 
            jmp _label1
            ; line 760
          _label2:
            cmp_eq ::temp1 w "ROMANTIC" 
            jmpf ::temp1 _label3
            ; line 761
            return 4 
            jmp _label1
            ; line 762
          _label3:
            cmp_eq ::temp1 w "CASUAL" 
            jmpf ::temp1 _label1
            ; line 763
            return 2 
            jmp _label1
            ; line 765
          _label1:
            return 4 
          .endCode
        .endFunction ;IntimacyToMinTier
        .function IntimacyToBypass
           ; function type 0
          .userFlags 0 ;none
          .docString "Feeds SNRom_PhysAttrBypass - THE Sapphire switch. Only CASUAL lets raw
      attraction stand in for tier: someone who keeps everyone at arm's length
      and may never reach Lover can still want someone in their bed."
          .return Int
          .paramTable
            .param asWord String
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 772
            callstatic sNRom_Decorators Trim ::temp0 asWord ;1 variable args
            callstatic sNRom_Decorators Upper ::temp0 ::temp0 ;1 variable args
            cmp_eq ::temp1 ::temp0 "CASUAL" 
            jmpf ::temp1 _label0
            ; line 773
            return 1 
            jmp _label0
            ; line 775
          _label0:
            return 0 
          .endCode
        .endFunction ;IntimacyToBypass
        .function WeightToPoints
           ; function type 0
          .userFlags 0 ;none
          .docString "Conversational weight -> points. A tier is 500, which is the scale every
      number here is set against.

      The MODEL NEVER SEES THESE NUMBERS. It answers with a word describing
      what happened; Papyrus decides what that is worth. That separation is
      deliberate - asked for a number the model inflates (ten NPCs answered
      "3" on a 0-4 scale), and it has no way to know what 40 means against an
      economy it cannot see.

      LANDMARK is 350 - most of a tier - because two people explicitly and
      mutually deciding to be partners is not a small event and scoring it
      like one is the thing that makes these systems feel fake. It is gated
      hard in Papyrus instead: see the landmark cooldown in ApplyTalkAward.

      Unknown words return 0. A garbled answer must move nothing."
          .return Int
          .paramTable
            .param asWord String
          .endParamTable
          .localTable
            .local w String
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 794
            callstatic sNRom_Decorators Trim ::temp0 asWord ;1 variable args
            callstatic sNRom_Decorators Upper ::temp0 ::temp0 ;1 variable args
            assign w ::temp0 
            ; line 795
            cmp_eq ::temp1 w "SMALL" 
            jmpf ::temp1 _label0
            ; line 796
            return 10 
            jmp _label1
            ; line 797
          _label0:
            cmp_eq ::temp1 w "REAL" 
            jmpf ::temp1 _label2
            ; line 798
            return 40 
            jmp _label1
            ; line 799
          _label2:
            cmp_eq ::temp1 w "MAJOR" 
            jmpf ::temp1 _label3
            ; line 800
            return 120 
            jmp _label1
            ; line 801
          _label3:
            cmp_eq ::temp1 w "LANDMARK" 
            jmpf ::temp1 _label4
            ; line 802
            return 350 
            jmp _label1
            ; line 816
          _label4:
            cmp_eq ::temp1 w "SETBACK" 
            jmpf ::temp1 _label5
            ; line 817
            return -40 
            jmp _label1
            ; line 818
          _label5:
            cmp_eq ::temp1 w "RUPTURE" 
            jmpf ::temp1 _label1
            ; line 819
            return -350 
            jmp _label1
            ; line 821
          _label1:
            return 0 
          .endCode
        .endFunction ;WeightToPoints
        .function ArdorToInt
           ; function type 0
          .userFlags 0 ;none
          .docString "How demonstrative she is, 0-4. Authored as a WORD, not a number.

      It was a 0-4 scale and came back 3 for TEN CONSECUTIVE NPCs. An
      unanchored numeric range has no meaning to answer against, so everything
      lands middle-high and the axis measures nothing. Intimacy and
      exclusivity varied over the same ten, so this was the scale's fault
      rather than the model's.

      Words carry their own definition. "Reserved" and "intense" are things a
      person can be recognized as; 1 and 4 are not. The stored value stays an
      int because PhysicalOk and the spark calibration want to compare it."
          .return Int
          .paramTable
            .param asWord String
          .endParamTable
          .localTable
            .local w String
            .local ::temp0 String
            .local ::temp1 Bool
            .local ::temp2 Int
          .endLocalTable
          .code
            ; line 836
            callstatic sNRom_Decorators Trim ::temp0 asWord ;1 variable args
            callstatic sNRom_Decorators Upper ::temp0 ::temp0 ;1 variable args
            assign w ::temp0 
            ; line 837
            cmp_eq ::temp1 w "RESERVED" 
            jmpf ::temp1 _label0
            ; line 838
            return 0 
            jmp _label1
            ; line 839
          _label0:
            cmp_eq ::temp1 w "MEASURED" 
            jmpf ::temp1 _label2
            ; line 840
            return 1 
            jmp _label1
            ; line 841
          _label2:
            cmp_eq ::temp1 w "WARM" 
            jmpf ::temp1 _label3
            ; line 842
            return 2 
            jmp _label1
            ; line 843
          _label3:
            cmp_eq ::temp1 w "OPEN" 
            jmpf ::temp1 _label4
            ; line 844
            return 3 
            jmp _label1
            ; line 845
          _label4:
            cmp_eq ::temp1 w "INTENSE" 
            jmpf ::temp1 _label1
            ; line 846
            return 4 
            jmp _label1
            ; line 849
          _label1:
            callstatic sNRom_Decorators ClampInt ::temp2 asWord 0 4 2 ;4 variable args
            return ::temp2 
          .endCode
        .endFunction ;ArdorToInt
        .function ArdorWord
           ; function type 0
          .userFlags 0 ;none
          .docString "Inverse, for the spark assessment - it calibrates far better against
      "reserved" than against "1"."
          .return String
          .paramTable
            .param aiArdor Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 855
            cmp_lte ::temp0 aiArdor 0 
            jmpf ::temp0 _label0
            ; line 856
            return "reserved and undemonstrative" 
            jmp _label1
            ; line 857
          _label0:
            cmp_eq ::temp0 aiArdor 1 
            jmpf ::temp0 _label2
            ; line 858
            return "measured, showing little" 
            jmp _label1
            ; line 859
          _label2:
            cmp_eq ::temp0 aiArdor 2 
            jmpf ::temp0 _label3
            ; line 860
            return "warm but not effusive" 
            jmp _label1
            ; line 861
          _label3:
            cmp_eq ::temp0 aiArdor 3 
            jmpf ::temp0 _label1
            ; line 862
            return "open about what she feels" 
            jmp _label1
            ; line 864
          _label1:
            return "intense and unmistakable" 
          .endCode
        .endFunction ;ArdorWord
        .function ExclusivityToInt
           ; function type 0
          .userFlags 0 ;none
          .docString "How much they need to be the only one, 0-100. Authored as a WORD.

      SAME FIX AS ArdorToInt, AND FOR THE SAME REASON - this axis was simply
      missed when that one was converted. It stayed "0 (untroubled by others)
      to 100 (cannot share)": two anchors, both endpoints, nothing in between.

      The log settled it. Over the twenty most recent authorings, ARDOR - words
      since the conversion - came back 0,1,2,3,4 with every value represented.
      EXCLUSIVITY came back 100 seventeen times out of twenty. Same NPCs, same
      model, same run, same prompt; the only difference was the scale. Across
      all 102 authorings on record, 45 are exactly 100.

      100 is "cannot share under any circumstance". It is the most extreme
      answer on the axis and it was the modal one, landing on people the same
      response had just called RESERVED - someone who gives almost nothing away
      being simultaneously and maximally possessive. That is not a character,
      it is a scale with no middle.

      Values are seeds, not buckets: drift moves this by 20 a review, so the
      stored int keeps its full 0-100 resolution and only the FIRST answer
      comes from this table.

      TOLERANT IS THE OLD SPELLING OF ACCEPTING, kept because it costs nothing
      and a model that reaches for either must land on the same number.

      THE AXIS MEASURES A DEMAND, NOT AN ATTACHMENT, and the first vocabulary
      blurred that. "POSSESSIVE - needs to be the only one; a rival would wound
      them" reads as a description of how deeply someone loves, so the model
      answered it for anyone deeply in love. Re-authoring three long-established
      followers returned POSSESSIVE three times out of three - and ARDOR, which
      is well spread over twenty other authorings, pinned to INTENSE on the same
      three. Two axes moving together like that means they were being read as one
      question.

      The author's own case settled it: followers who have long known the player
      has other partners, are at peace with it, and intend to have no one else
      themselves. Wholly devoted, entirely undemanding. Under the old wording
      that is POSSESSIVE, which is exactly backwards - so the prompt now asks
      only what they require OF the player, and says outright that their own
      fidelity is not a demand on anybody.

      Digits still parse, for older saves and any model that ignores the
      vocabulary - a visible wrong answer beats a silently defaulted one."
          .return Int
          .paramTable
            .param asWord String
          .endParamTable
          .localTable
            .local w String
            .local ::temp0 String
            .local ::temp1 Bool
            .local ::temp2 Int
          .endLocalTable
          .code
            ; line 911
            callstatic sNRom_Decorators Trim ::temp0 asWord ;1 variable args
            callstatic sNRom_Decorators Upper ::temp0 ::temp0 ;1 variable args
            assign w ::temp0 
            ; line 912
            cmp_eq ::temp1 w "UNTROUBLED" 
            jmpf ::temp1 _label0
            ; line 913
            return 0 
            jmp _label1
            ; line 914
          _label0:
            cmp_eq ::temp1 w "ACCEPTING" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label2
            cmp_eq ::temp1 w "TOLERANT" 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 915
            return 25 
            jmp _label1
            ; line 916
          _label3:
            cmp_eq ::temp1 w "CONVENTIONAL" 
            jmpf ::temp1 _label4
            ; line 917
            return 50 
            jmp _label1
            ; line 918
          _label4:
            cmp_eq ::temp1 w "POSSESSIVE" 
            jmpf ::temp1 _label5
            ; line 919
            return 75 
            jmp _label1
            ; line 920
          _label5:
            cmp_eq ::temp1 w "CONSUMING" 
            jmpf ::temp1 _label1
            ; line 921
            return 100 
            jmp _label1
            ; line 923
          _label1:
            callstatic sNRom_Decorators ClampInt ::temp2 asWord 0 100 50 ;4 variable args
            return ::temp2 
          .endCode
        .endFunction ;ExclusivityToInt
        .function ClampInt
           ; function type 0
          .userFlags 0 ;none
          .docString "Papyrus has no TryParse: a non-numeric string casts to 0, which is a
      LEGAL value for both ardor and exclusivity and so cannot be distinguished
      from a real answer. Verify the text is digits before trusting it."
          .return Int
          .paramTable
            .param asText String
            .param aiLow Int
            .param aiHigh Int
            .param aiFallback Int
          .endParamTable
          .localTable
            .local t String
            .local ::temp0 String
            .local n Int
            .local ::temp1 Int
            .local ::temp2 Bool
            .local i Int
            .local o Int
            .local v Int
          .endLocalTable
          .code
            ; line 930
            callstatic sNRom_Decorators Trim ::temp0 asText ;1 variable args
            assign t ::temp0 
            ; line 931
            callstatic stringUtil GetLength ::temp1 t ;1 variable args
            assign n ::temp1 
            ; line 932
            cmp_eq ::temp2 n 0 
            jmpf ::temp2 _label0
            ; line 933
            return aiFallback 
            jmp _label0
            ; line 935
          _label0:
            assign i 0 
            ; line 936
          _label4:
            cmp_lt ::temp2 i n 
            jmpf ::temp2 _label1
            ; line 937
            callstatic stringUtil GetNthChar ::temp0 t i ;2 variable args
            callstatic stringUtil AsOrd ::temp1 ::temp0 ;1 variable args
            assign o ::temp1 
            ; line 938
            cmp_lt ::temp2 o 48 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label2
            cmp_gt ::temp2 o 57 
            assign ::temp2 ::temp2 
          _label2:
            jmpf ::temp2 _label3
            ; line 939
            return aiFallback 
            jmp _label3
            ; line 941
          _label3:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label4
            ; line 943
          _label1:
            cast ::temp1 t 
            assign v ::temp1 
            ; line 944
            cmp_lt ::temp2 v aiLow 
            jmpf ::temp2 _label5
            ; line 945
            return aiLow 
            jmp _label6
            ; line 946
          _label5:
            cmp_gt ::temp2 v aiHigh 
            jmpf ::temp2 _label6
            ; line 947
            return aiHigh 
            jmp _label6
            ; line 949
          _label6:
            return v 
          .endCode
        .endFunction ;ClampInt
        .function SexWord
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
            .param aiSex Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 953
            cmp_eq ::temp0 aiSex 1 
            jmpf ::temp0 _label0
            ; line 954
            return "female" 
            jmp _label0
            ; line 956
          _label0:
            return "male" 
          .endCode
        .endFunction ;SexWord
        .function FieldValue
           ; function type 0
          .userFlags 0 ;none
          .docString "Pulls "KEY: value" out of a labeled-line response. Labeled lines are
      used instead of JSON because Papyrus parses them trivially and small
      models produce them far more reliably than nested structures."
          .return String
          .paramTable
            .param asResponse String
            .param asKey String
          .endParamTable
          .localTable
            .local at Int
            .local ::temp0 Int
            .local skip Int
            .local ::temp1 Bool
            .local bare String
            .local ::temp2 String
            .local alt String
            .local start Int
            .local rest String
            .local nl Int
          .endLocalTable
          .code
            ; line 963
            callstatic stringUtil Find ::temp0 asResponse asKey 0 ;3 variable args
            assign at ::temp0 
            ; line 964
            callstatic stringUtil GetLength ::temp0 asKey ;1 variable args
            assign skip ::temp0 
            ; line 965
            cmp_lt ::temp1 at 0 
            jmpf ::temp1 _label0
            ; line 974
            callstatic stringUtil GetLength ::temp0 asKey ;1 variable args
            isub ::temp0 ::temp0 1 
            callstatic stringUtil Substring ::temp2 asKey 0 ::temp0 ;3 variable args
            assign bare ::temp2 
            ; line 975
            strcat ::temp2 bare "':" 
            assign alt ::temp2 
            ; line 976
            callstatic stringUtil Find ::temp0 asResponse alt 0 ;3 variable args
            assign at ::temp0 
            ; line 977
            callstatic stringUtil GetLength ::temp0 alt ;1 variable args
            assign skip ::temp0 
            ; line 978
            cmp_lt ::temp1 at 0 
            jmpf ::temp1 _label1
            ; line 979
            strcat ::temp2 bare "\":" 
            assign alt ::temp2 
            ; line 980
            callstatic stringUtil Find ::temp0 asResponse alt 0 ;3 variable args
            assign at ::temp0 
            ; line 981
            callstatic stringUtil GetLength ::temp0 alt ;1 variable args
            assign skip ::temp0 
            jmp _label1
          _label1:
            jmp _label0
            ; line 984
          _label0:
            cmp_lt ::temp1 at 0 
            jmpf ::temp1 _label2
            ; line 985
            return "" 
            jmp _label2
            ; line 987
          _label2:
            iadd ::temp0 at skip 
            assign start ::temp0 
            ; line 988
            callstatic stringUtil Substring ::temp2 asResponse start 0 ;3 variable args
            assign rest ::temp2 
            ; line 989
            callstatic stringUtil Find ::temp0 rest "\n" 0 ;3 variable args
            assign nl ::temp0 
            ; line 990
            cmp_lt ::temp1 nl 0 
            jmpf ::temp1 _label3
            ; line 991
            callstatic stringUtil AsChar ::temp2 10 ;1 variable args
            callstatic stringUtil Find ::temp0 rest ::temp2 0 ;3 variable args
            assign nl ::temp0 
            jmp _label3
            ; line 993
          _label3:
            comp_gte ::temp1 nl 0 
            jmpf ::temp1 _label4
            ; line 994
            callstatic stringUtil Substring ::temp2 rest 0 nl ;3 variable args
            assign rest ::temp2 
            jmp _label4
            ; line 996
          _label4:
            callstatic sNRom_Decorators Unquote ::temp2 rest ;1 variable args
            return ::temp2 
          .endCode
        .endFunction ;FieldValue
        .function DayOfStamp
           ; function type 0
          .userFlags 0 ;none
          .docString "The DAY part of a bracketed timestamp, or "" if there is no stamp.

      Timestamps render as "[11:27 PM, Middas, 14th of Morning Star, 4E 202]".
      The clock time is deliberately DISCARDED and only the day kept, because
      the whole point is to tell separate days apart: two citations from the
      same evening carry different clock times and must not count as two
      occasions.

      Everything from the first comma to the closing bracket is the day. That
      keeps the weekday, the date and the year together, so "14th of Morning
      Star" and "15th of Morning Star" differ while "11:27 PM" and "11:53 PM"
      on the same date collapse to one."
          .return String
          .paramTable
            .param asEntry String
          .endParamTable
          .localTable
            .local open Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local close Int
            .local stamp String
            .local ::temp2 Int
            .local ::temp3 String
            .local comma Int
          .endLocalTable
          .code
            ; line 1012
            callstatic stringUtil Find ::temp0 asEntry "[" 0 ;3 variable args
            assign open ::temp0 
            ; line 1013
            cmp_lt ::temp1 open 0 
            jmpf ::temp1 _label0
            ; line 1014
            return "" 
            jmp _label0
            ; line 1016
          _label0:
            callstatic stringUtil Find ::temp0 asEntry "]" 0 ;3 variable args
            assign close ::temp0 
            ; line 1017
            cmp_lte ::temp1 close open 
            jmpf ::temp1 _label1
            ; line 1018
            return "" 
            jmp _label1
            ; line 1020
          _label1:
            iadd ::temp0 open 1 
            isub ::temp2 close open 
            isub ::temp2 ::temp2 1 
            callstatic stringUtil Substring ::temp3 asEntry ::temp0 ::temp2 ;3 variable args
            assign stamp ::temp3 
            ; line 1021
            callstatic stringUtil Find ::temp2 stamp "," 0 ;3 variable args
            assign comma ::temp2 
            ; line 1022
            cmp_lt ::temp1 comma 0 
            jmpf ::temp1 _label2
            ; line 1023
            callstatic sNRom_Decorators Trim ::temp3 stamp ;1 variable args
            callstatic sNRom_Decorators Upper ::temp3 ::temp3 ;1 variable args
            return ::temp3 
            jmp _label2
            ; line 1026
          _label2:
            iadd ::temp2 comma 1 
            callstatic stringUtil Substring ::temp3 stamp ::temp2 0 ;3 variable args
            callstatic sNRom_Decorators Trim ::temp3 ::temp3 ;1 variable args
            callstatic sNRom_Decorators Upper ::temp3 ::temp3 ;1 variable args
            return ::temp3 
          .endCode
        .endFunction ;DayOfStamp
        .function CountOccasions
           ; function type 0
          .userFlags 0 ;none
          .docString "How many DISTINCT DAYS a drift verdict actually cited.

      A COUNT OF ENTRIES WAS NOT ENOUGH. The first version counted
      bar-separated fragments, and the very first verdict under it returned
      three - all describing one evening, none carrying a date, none naming a
      separate moment. Counting separators only ever measures whether the model
      can type a bar.

      What makes an occasion distinct is WHEN it happened, so that is what gets
      counted: entries without a copied timestamp are ignored entirely, and
      entries sharing a day count once. A single night subdivided into three
      vivid phrasings now scores 1 and is discarded, which is the whole point.

      THE STRUCTURAL FIX, and it exists because two rounds of prose tightening
      did nothing. Across three subjects the assessor answered from SALIENCE
      rather than from pattern: vivid material nearby produced YES, thin
      material produced NO, and neither had anything to do with whether a
      behavior had recurred. Sybille's verdict was a paraphrase of a talk award
      that had fired seconds earlier, on a different axis entirely.

      Returns a COUNT rather than a Bool so the caller can log how many were
      cited; "cited 1" and "cited none" are different failures and the log
      should be able to say which.

      Capped at eight days tracked. Nothing needs more than two to pass, the
      array is a fixed size because Papyrus has no set, and a model listing
      nine dated citations has already answered the question."
          .return Int
          .paramTable
            .param asText String
          .endParamTable
          .localTable
            .local t String
            .local ::temp0 String
            .local ::temp1 Bool
            .local days String[]
            .local ::temp2 String[]
            .local found Int
            .local rest String
            .local at Int
            .local ::temp3 Int
            .local entry String
            .local day String
            .local seen Bool
            .local i Int
          .endLocalTable
          .code
            ; line 1057
            callstatic sNRom_Decorators Trim ::temp0 asText ;1 variable args
            assign t ::temp0 
            ; line 1058
            cmp_eq ::temp1 t "" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            callstatic sNRom_Decorators Upper ::temp0 t ;1 variable args
            cmp_eq ::temp1 ::temp0 "NONE" 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 1059
            return 0 
            jmp _label1
            ; line 1061
          _label1:
            callstatic utility CreateStringArray ::temp2 8 "" ;2 variable args
            assign days ::temp2 
            ; line 1062
            assign found 0 
            ; line 1063
            strcat ::temp0 t "|" 
            assign rest ::temp0 
            ; line 1064
            callstatic stringUtil Find ::temp3 rest "|" 0 ;3 variable args
            assign at ::temp3 
            ; line 1065
          _label9:
            comp_gte ::temp1 at 0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            cmp_lt ::temp1 found 8 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 1066
            callstatic stringUtil Substring ::temp0 rest 0 at ;3 variable args
            callstatic sNRom_Decorators Trim ::temp0 ::temp0 ;1 variable args
            assign entry ::temp0 
            ; line 1067
            callstatic sNRom_Decorators DayOfStamp ::temp0 entry ;1 variable args
            assign day ::temp0 
            ; line 1068
            cmp_eq ::temp1 day "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label4
            ; line 1069
            assign seen False 
            ; line 1070
            assign i 0 
            ; line 1071
          _label7:
            cmp_lt ::temp1 i found 
            jmpf ::temp1 _label5
            ; line 1072
            array_getlement ::temp0 days i 
            cmp_eq ::temp1 ::temp0 day 
            jmpf ::temp1 _label6
            ; line 1073
            assign seen True 
            jmp _label6
            ; line 1075
          _label6:
            iadd ::temp3 i 1 
            assign i ::temp3 
            jmp _label7
            ; line 1077
          _label5:
            not ::temp1 seen 
            jmpf ::temp1 _label8
            ; line 1078
            array_setelement days found day 
            ; line 1079
            iadd ::temp3 found 1 
            assign found ::temp3 
            jmp _label8
          _label8:
            jmp _label4
            ; line 1082
          _label4:
            iadd ::temp3 at 1 
            callstatic stringUtil Substring ::temp0 rest ::temp3 0 ;3 variable args
            assign rest ::temp0 
            ; line 1083
            callstatic stringUtil Find ::temp3 rest "|" 0 ;3 variable args
            assign at ::temp3 
            jmp _label9
            ; line 1085
          _label3:
            return found 
          .endCode
        .endFunction ;CountOccasions
        .function PatternIsWatching
           ; function type 0
          .userFlags 0 ;none
          .docString "True if a drift PATTERN rests on what the NPC merely WATCHED.

      PAPYRUS, NOT PROSE - and this one was earned. The drift prompt excluded
      witnessed events from the start. After the first live review cited them
      anyway, the exclusion was restated with emphasis, given its own section
      saying a characterisation is not a pattern, and armed with two explicit
      pre-write tests. The very next run on the same NPC produced the same
      answer and used the word "witness" in it.

      That is the fourth time this project has tightened a threshold in wording
      and had the model reason straight past it. The tenure gate went into
      Papyrus for exactly this reason; so does this.

      FAILS SAFE. A match discards the verdict, and a discarded verdict means no
      change - which is already the expected answer, so a false positive costs
      nothing but a review that will come round again. That asymmetry is why a
      blunt word list is acceptable here and would not be if it gated an award.

      Deliberately NOT matching "others" on its own. "He has repeatedly chosen
      her over others" is a pattern ABOUT the two of them and must survive.
      Every needle below describes the NPC in the role of onlooker."
          .return Bool
          .paramTable
            .param asPattern String
          .endParamTable
          .localTable
            .local p String
            .local ::temp0 String
            .local ::temp1 Int
            .local ::temp2 Bool
          .endLocalTable
          .code
            ; line 1110
            callstatic sNRom_Decorators Upper ::temp0 asPattern ;1 variable args
            assign p ::temp0 
            ; line 1111
            callstatic stringUtil Find ::temp1 p "WITNESS" 0 ;3 variable args
            comp_gte ::temp2 ::temp1 0 
            jmpf ::temp2 _label0
            ; line 1112
            return True 
            jmp _label1
            ; line 1113
          _label0:
            callstatic stringUtil Find ::temp1 p "OBSERV" 0 ;3 variable args
            comp_gte ::temp2 ::temp1 0 
            jmpf ::temp2 _label2
            ; line 1114
            return True 
            jmp _label1
            ; line 1115
          _label2:
            callstatic stringUtil Find ::temp1 p "WATCH" 0 ;3 variable args
            comp_gte ::temp2 ::temp1 0 
            jmpf ::temp2 _label3
            ; line 1116
            return True 
            jmp _label1
            ; line 1117
          _label3:
            callstatic stringUtil Find ::temp1 p "BYSTANDER" 0 ;3 variable args
            comp_gte ::temp2 ::temp1 0 
            jmpf ::temp2 _label4
            ; line 1118
            return True 
            jmp _label1
            ; line 1119
          _label4:
            callstatic stringUtil Find ::temp1 p "ONLOOKER" 0 ;3 variable args
            comp_gte ::temp2 ::temp1 0 
            jmpf ::temp2 _label5
            ; line 1120
            return True 
            jmp _label1
            ; line 1121
          _label5:
            callstatic stringUtil Find ::temp1 p "OVERHEARD" 0 ;3 variable args
            comp_gte ::temp2 ::temp1 0 
            jmpf ::temp2 _label6
            ; line 1122
            return True 
            jmp _label1
            ; line 1123
          _label6:
            callstatic stringUtil Find ::temp1 p "SPECTAT" 0 ;3 variable args
            comp_gte ::temp2 ::temp1 0 
            jmpf ::temp2 _label7
            ; line 1124
            return True 
            jmp _label1
            ; line 1125
          _label7:
            callstatic stringUtil Find ::temp1 p "INTIMACY OF OTHERS" 0 ;3 variable args
            comp_gte ::temp2 ::temp1 0 
            jmpf ::temp2 _label1
            ; line 1126
            return True 
            jmp _label1
            ; line 1128
          _label1:
            return False 
          .endCode
        .endFunction ;PatternIsWatching
        .function Unquote
           ; function type 0
          .userFlags 0 ;none
          .docString "Strips JSON punctuation a drifting model wraps around a VALUE.

      The quoted-KEY tolerance above was only half the problem. A model that
      slips into JSON writes both sides of the pair, and a weight arriving as
      LANDMARK wrapped in quotes with a trailing comma matches no weight, no
      orientation and no intimacy word - so a correct answer scores nothing and
      the log line reads as though the model simply declined.

      Abelone lost a genuine 350-point defining moment to exactly this on
      2026-08-09, and it looked like the landmark cooldown had fired. It had
      not - the downgrade line was absent. 3 of 126 verdicts in that save came
      back this way: rare, silent, and worth a few Finds to catch.

      SAFE ON PROSE. WHY and LIMIT are sentences; removing a MATCHED pair of
      wrapping quotes, or one trailing comma, cannot change their meaning.
      Internal quotation is untouched because only the first and last
      characters are ever considered."
          .return String
          .paramTable
            .param asValue String
          .endParamTable
          .localTable
            .local v String
            .local ::temp0 String
            .local n Int
            .local ::temp1 Int
            .local ::temp2 Bool
            .local f String
            .local l String
          .endLocalTable
          .code
            ; line 1149
            callstatic sNRom_Decorators Trim ::temp0 asValue ;1 variable args
            assign v ::temp0 
            ; line 1150
            callstatic stringUtil GetLength ::temp1 v ;1 variable args
            assign n ::temp1 
            ; line 1151
            cmp_eq ::temp2 n 0 
            jmpf ::temp2 _label0
            ; line 1152
            return v 
            jmp _label0
            ; line 1154
          _label0:
            isub ::temp1 n 1 
            callstatic stringUtil GetNthChar ::temp0 v ::temp1 ;2 variable args
            cmp_eq ::temp2 ::temp0 "," 
            jmpf ::temp2 _label1
            ; line 1155
            isub ::temp1 n 1 
            callstatic stringUtil Substring ::temp0 v 0 ::temp1 ;3 variable args
            callstatic sNRom_Decorators Trim ::temp0 ::temp0 ;1 variable args
            assign v ::temp0 
            ; line 1156
            callstatic stringUtil GetLength ::temp1 v ;1 variable args
            assign n ::temp1 
            jmp _label1
            ; line 1158
          _label1:
            comp_gte ::temp2 n 2 
            jmpf ::temp2 _label2
            ; line 1159
            callstatic stringUtil GetNthChar ::temp0 v 0 ;2 variable args
            assign f ::temp0 
            ; line 1160
            isub ::temp1 n 1 
            callstatic stringUtil GetNthChar ::temp0 v ::temp1 ;2 variable args
            assign l ::temp0 
            ; line 1161
            cmp_eq ::temp2 f "\"" 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label3
            cmp_eq ::temp2 l "\"" 
            assign ::temp2 ::temp2 
          _label3:
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label4
            cmp_eq ::temp2 f "'" 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label5
            cmp_eq ::temp2 l "'" 
            assign ::temp2 ::temp2 
          _label5:
            assign ::temp2 ::temp2 
          _label4:
            jmpf ::temp2 _label6
            ; line 1162
            isub ::temp1 n 2 
            callstatic stringUtil Substring ::temp0 v 1 ::temp1 ;3 variable args
            callstatic sNRom_Decorators Trim ::temp0 ::temp0 ;1 variable args
            assign v ::temp0 
            jmp _label6
          _label6:
            jmp _label2
            ; line 1165
          _label2:
            return v 
          .endCode
        .endFunction ;Unquote
        .function JsonEscape
           ; function type 0
          .userFlags 0 ;none
          .docString "Raw LLM output goes into a JSON log line verbatim, and into the authoring
      CONTEXT object - quotes, newlines, backslashes or control characters in
      it would corrupt either."
          .return String
          .paramTable
            .param asText String
          .endParamTable
          .localTable
            .local s String
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 1198
            assign s asText 
            ; line 1199
            callstatic sNRom_Decorators ReplaceAll ::temp0 s "\\" "" ;3 variable args
            assign s ::temp0 
            ; line 1200
            callstatic sNRom_Decorators ReplaceAll ::temp0 s "\"" "'" ;3 variable args
            assign s ::temp0 
            ; line 1201
            callstatic stringUtil AsChar ::temp0 9 ;1 variable args
            callstatic sNRom_Decorators ReplaceAll ::temp0 s ::temp0 " " ;3 variable args
            assign s ::temp0 
            ; line 1202
            callstatic stringUtil AsChar ::temp0 10 ;1 variable args
            callstatic sNRom_Decorators ReplaceAll ::temp0 s ::temp0 " " ;3 variable args
            assign s ::temp0 
            ; line 1203
            callstatic stringUtil AsChar ::temp0 13 ;1 variable args
            callstatic sNRom_Decorators ReplaceAll ::temp0 s ::temp0 " " ;3 variable args
            assign s ::temp0 
            ; line 1204
            return s 
          .endCode
        .endFunction ;JsonEscape
      .endState
    .endStateTable
  .endObject
.endObjectTable
