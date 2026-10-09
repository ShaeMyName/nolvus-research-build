.info
  .source "C:\nolvus-research\build\src\relationships\src\scripts\SNRom_Bridge.psc"
  .compileTime 1791572374 ;2026-10-09 14:59:34
  .user "sharp"
  .computer "EMISSARY"
.endInfo
.userFlagsRef
.endUserFlagsRef
.objectTable
  .object SNRom_Bridge Quest
    .userFlags 0 ;none
    .docString "Relationships: SkyrimNet bonds, owned end to end.

  This script owns the bonds - points, tiers, enrollment, the consent gate -
  and everything SkyrimNet needs to read or move them, plus the disposition
  store the LLM authors into.

  ROMANTASY IS NOT A DEPENDENCY FROM 2.0 (design 8.1, 10). It is read once
  per save, if installed, by the points import (StartPointsImport), and never
  called otherwise: every Romantasy.* call in this file sits behind
  SNRom_RomantasyReadable, which is only ever set from Game.IsPluginInstalled.
  Papyrus cannot tell a missing native from a refusal, so an unguarded call
  would fail silently - grep for "Romantasy\." before adding one."
    .autoState 
    .variableTable
      .variable _attrQuiet Bool
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _bond faction
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _boxActor actor
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _boxId Int
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _boxOpenedAt Float
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _boxPending actor
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _boxVoicedAt Float
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _contentSeen Int
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _dashKinGuard Int
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _dashMaras Bool
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _dashNatives Int
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _dashPlaythrough String
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _dashSever Bool
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _dashStore String
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _dashText Bool
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _driftActor actor
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _driftField Int
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _driftName String
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _driftPendingAt Float
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _importing Bool
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _lastBootstrap Float
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _ledgerBuf String[]
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _ledgerCount Int
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _observers actor[]
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _pendingActor actor
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _pendingIntimacy actor
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _pendingName String
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _ready Bool
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _seedActor actor
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _seedByHand Bool
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _seedName String
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _seedSentAt Float
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _seq Int
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _sparkActor actor
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _sparkName String
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _sparkPendingAt Float
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _talkActor actor
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _talkName String
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable _talkPendingAt Float
        .userFlags 0 ;none
        .initialValue None
      .endVariable
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
        .function LOG_ERROR
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 64
            return 1 
          .endCode
        .endFunction ;LOG_ERROR
        .function LOG_WARN
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 67
            return 2 
          .endCode
        .endFunction ;LOG_WARN
        .function LOG_INFO
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 70
            return 3 
          .endCode
        .endFunction ;LOG_INFO
        .function LOG_DEBUG
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 73
            return 4 
          .endCode
        .endFunction ;LOG_DEBUG
        .function PaceMultiplier
           ; function type 0
          .userFlags 0 ;none
          .docString "The one lever, resolved from the named speed the player picked.

      THREE SPEEDS, NOT FIVE. A first cut deliberately: half, normal, double is
      easy to hold in your head and easy to judge from play. Finer strata are a
      later decision, and only worth making once these three have been felt.

      NAMED SPEEDS, NOT A NUMBER. Players understand "relationships take about
      twice as long"; nobody understands 0.5. The select carries the words and
      this maps them, so the mapping can be retuned without retraining anyone.

      Unknown or empty means Normal. A typo in a config file must not silently
      stop a relationship from moving."
          .return Float
          .paramTable
          .endParamTable
          .localTable
            .local w String
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 90
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigString ::temp0 ::temp0 "bondPace" "Normal" ;3 variable args
            callstatic sNRom_Decorators Trim ::temp0 ::temp0 ;1 variable args
            callstatic sNRom_Decorators Upper ::temp0 ::temp0 ;1 variable args
            assign w ::temp0 
            ; line 91
            cmp_eq ::temp1 w "SLOW" 
            jmpf ::temp1 _label0
            ; line 92
            return 0.5 
            jmp _label1
            ; line 93
          _label0:
            cmp_eq ::temp1 w "FAST" 
            jmpf ::temp1 _label1
            ; line 94
            return 2.0 
            jmp _label1
            ; line 96
          _label1:
            return 1.0 
          .endCode
        .endFunction ;PaceMultiplier
        .function ScaleAward
           ; function type 0
          .userFlags 0 ;none
          .docString "THE ONLY PLACE THE PACE MULTIPLIER IS APPLIED. Points leave this mod
      through ten separate Romantasy calls and seven of them are earnings, so the
      arithmetic lives here once and each site says for itself whether it is an
      earning or a transfer. A wrapper around ModifyPoints was the other option
      and was rejected: it would need telling which kind it was anyway, and two
      near-identical wrappers hide the distinction that actually matters.

      NEVER CALL THIS ON A TRANSFER. HoldShortOfLover banks an award short of
      Lover; AcceptRomance returns the banked amount in full.
      Scale either and points evaporate - claw back 200, hand back 50 - and the
      player watched those points accrue and was promised them back. Seeding is
      excluded too: "Prior history together" describes a relationship that
      existed before this mod was installed, and a slow setting has no business
      retroactively shrinking someone's past.

      THE FLOOR IS THE WHOLE POINT AT THE SLOW END. Points are Ints, so at 0.25x
      a SMALL award of 10 becomes 2 and an award of 1 becomes 0 - the axis stops
      registering entirely and the player learns their behaviour does not matter.
      Any non-zero award stays non-zero and keeps its sign. Better to move the
      needle by one than not at all; that is the entire reason this exists."
          .return Int
          .paramTable
            .param aiPoints Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local mult Float
            .local ::temp1 Float
            .local scaled Int
            .local ::temp2 Int
          .endLocalTable
          .code
            ; line 120
            cmp_eq ::temp0 aiPoints 0 
            jmpf ::temp0 _label0
            ; line 121
            return 0 
            jmp _label0
            ; line 123
          _label0:
            callstatic sNRom_Bridge PaceMultiplier ::temp1 ;0 variable args
            assign mult ::temp1 
            ; line 124
            cmp_eq ::temp0 mult 1.0 
            jmpf ::temp0 _label1
            ; line 125
            return aiPoints 
            jmp _label1
            ; line 127
          _label1:
            cast ::temp1 aiPoints 
            fmul ::temp1 ::temp1 mult 
            cast ::temp2 ::temp1 
            assign scaled ::temp2 
            ; line 128
            cmp_eq ::temp0 scaled 0 
            jmpf ::temp0 _label2
            ; line 129
            cmp_gt ::temp0 aiPoints 0 
            jmpf ::temp0 _label3
            ; line 130
            return 1 
            jmp _label3
            ; line 132
          _label3:
            return -1 
            jmp _label2
            ; line 134
          _label2:
            return scaled 
          .endCode
        .endFunction ;ScaleAward
        .function CFG
           ; function type 0
          .userFlags 0 ;none
          .docString "SkyrimNet namespaces plugin manifests as "Plugin_<plugin name>" - see
      /config?api=list, which shows "Plugin_SeverActions" and
      "Plugin_SkyrimNet Relationships". Reading from "game" silently returns the
      caller's default for every key, so the manifest renders in the dashboard
      and changes nothing."
          .return String
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 142
            return "Plugin_SkyrimNet Relationships" 
          .endCode
        .endFunction ;CFG
        .function LedgerPath
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 146
            return "Data/SKSE/Plugins/SkyrimNet Relationships/logs/ledger.jsonl" 
          .endCode
        .endFunction ;LedgerPath
        .function NL
           ; function type 0
          .userFlags 0 ;none
          .docString "Papyrus string literals support no escape sequences - NL() is a
      literal backslash-n. Build the newline from its char code."
          .return String
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 152
            callstatic stringUtil AsChar ::temp0 10 ;1 variable args
            return ::temp0 
          .endCode
        .endFunction ;NL
        .function DiagPath
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 156
            return "Data/SKSE/Plugins/SkyrimNet Relationships/logs/snrom.log" 
          .endCode
        .endFunction ;DiagPath
        .function OnInit
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 164
            callmethod Bootstrap self ::nonevar False ;1 variable args
          .endCode
        .endFunction ;OnInit
        .function Bootstrap
           ; function type 0
          .userFlags 0 ;none
          .docString "Called from OnInit and from the player alias on every game load.
      Everything here MUST be idempotent - decorator and ModEvent
      registrations do not survive a save/load and must be re-established.

      Debounced: quest OnInit, alias OnInit and OnPlayerLoadGame all fire
      within moments of each other, so this ran four times per load and
      quadrupled every log line for no benefit.

      abForce bypasses the debounce entirely and is passed by
      OnPlayerLoadGame, the one event that unambiguously means "new session".
      The debounce is a REAL-TIME window compared against a value persisted in
      the save, and real time cannot tell sessions apart: load a save at a
      similar point in the launch as last time and the delta falls inside the
      window, skipping bootstrap on a fresh session. That silently cost an
      entire play session's spark timer - RegisterForSingleUpdateGameTime is
      inside the skipped region, and a single-update registration that is
      never made simply never fires. Nothing errored; the feature was just
      absent."
          .return None
          .paramTable
            .param abForce Bool
          .endParamTable
          .localTable
            .local now Float
            .local ::temp0 Float
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 form
            .local ::temp4 Int
            .local ::temp5 String[]
            .local ::nonevar None
            .local ::temp6 faction
            .local ::temp7 String
            .local ::temp8 String
          .endLocalTable
          .code
            ; line 186
            callstatic utility GetCurrentRealTime ::temp0 ;0 variable args
            assign now ::temp0 
            ; line 187
            jmpf abForce _label0
            ; line 188
            assign _lastBootstrap 0.0 
            jmp _label0
            ; line 199
          _label0:
            cmp_gt ::temp1 _lastBootstrap 0.0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            comp_gte ::temp1 now _lastBootstrap 
            assign ::temp1 ::temp1 
          _label1:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            fsub ::temp0 now _lastBootstrap 
            cmp_lt ::temp1 ::temp0 5.0 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 200
            return None 
            jmp _label3
            ; line 202
          _label3:
            assign _lastBootstrap now 
            ; line 209
            cast ::temp2 None 
            ; line 210
            cast ::temp3 None 
            callstatic storageUtil GetIntValue ::temp4 ::temp3 "SNRom_SessionId" 0 ;3 variable args
            iadd ::temp4 ::temp4 1 
            callstatic storageUtil SetIntValue ::temp4 ::temp2 "SNRom_SessionId" ::temp4 ;3 variable args
            ; line 211
            array_create ::temp5 32 
            assign _ledgerBuf ::temp5 
            ; line 212
            assign _ledgerCount 0 
            ; line 220
            callmethod EnsureSaveId self ::nonevar ;0 variable args
            ; line 221
            callstatic sNRom_Bridge WriteStorePointer ::nonevar ;0 variable args
            ; line 223
            callmethod RegisterDecorators self ::nonevar ;0 variable args
            ; line 224
            callmethod RegisterEvents self ::nonevar ;0 variable args
            ; line 229
            assign _dashText False 
            ; line 230
            callmethod ArmDashboard self ::nonevar ;0 variable args
            ; line 235
            callstatic sNRom_Bridge ResolveBondFaction ::temp6 ;0 variable args
            assign _bond ::temp6 
            ; line 236
            cast ::temp6 None 
            cmp_eq ::temp1 _bond ::temp6 
            jmpf ::temp1 _label4
            ; line 237
            assign _ready False 
            ; line 238
            callstatic sNRom_Bridge LOG_ERROR ::temp4 ;0 variable args
            strcat ::temp7 "SNRom_Bond unresolved - SNRom_Integration.esl is missing or older than " "these scripts. Integration inert." 
            callmethod Diag self ::nonevar ::temp4 ::temp7 False ;3 variable args
            ; line 240
            return None 
            jmp _label4
            ; line 243
          _label4:
            assign _ready True 
            ; line 244
            callmethod IEB_IntimacyOnLoad self ::nonevar ;0 variable args
            ; line 254
            assign _importing False 
            ; line 255
            callmethod StartPointsImport self ::nonevar ;0 variable args
            ; line 263
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            callstatic skyrimNetApi GetBuildVersion ::temp7 ;0 variable args
            strcat ::temp7 "SkyrimNet build " ::temp7 
            strcat ::temp7 ::temp7 " (" 
            ; line 264
            callstatic skyrimNetApi GetBuildType ::temp8 ;0 variable args
            strcat ::temp8 ::temp7 ::temp8 
            strcat ::temp8 ::temp8 ")" 
            callmethod Diag self ::nonevar ::temp4 ::temp8 False ;3 variable args
            ; line 268
            assign _contentSeen 0 
            ; line 271
            callmethod CheckContentLoaded self ::nonevar False ;1 variable args
            ; line 317
            callstatic sNRom_Bridge AssessIntervalHours ::temp0 ;0 variable args
            callmethod RegisterForSingleUpdateGameTime self ::nonevar ::temp0 ;1 variable args
            ; line 318
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            ; line 319
            callstatic sNRom_Bridge AssessIntervalHours ::temp0 ;0 variable args
            cast ::temp8 ::temp0 
            strcat ::temp8 "Bridge ready. SNRom_Bond resolved. Assessing every " ::temp8 
            strcat ::temp8 ::temp8 "h, housekeeping every " 
            callstatic sNRom_Bridge SparkIntervalHours ::temp0 ;0 variable args
            cast ::temp7 ::temp0 
            strcat ::temp7 ::temp8 ::temp7 
            strcat ::temp7 ::temp7 "h." 
            callmethod Diag self ::nonevar ::temp4 ::temp7 False ;3 variable args
            ; line 322
            callmethod SweepFollowers self ::nonevar ;0 variable args
          .endCode
        .endFunction ;Bootstrap
        .function ResolveBondFaction
           ; function type 0
          .userFlags 0 ;none
          .docString "SNRom_Bond, from our own ESL by its plugin-local FormID; SKSE handles
      the ESL indirection, as it did for ROM_RomanceLevel for a year."
          .return faction
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 form
            .local ::temp1 faction
          .endLocalTable
          .code
            ; line 328
            callstatic game GetFormFromFile ::temp0 3427 "SNRom_Integration.esl" ;2 variable args
            cast ::temp1 ::temp0 
            return ::temp1 
          .endCode
        .endFunction ;ResolveBondFaction
        .function RomantasyFaction
           ; function type 0
          .userFlags 0 ;none
          .docString "ROM_RomanceLevel, or None when Romantasy is not installed or only a stub
      of its plugin is. Read by the release in MoveToBondFaction, and by
      StartPointsImport as the test that Romantasy is really there; nothing is
      put into it any more."
          .return faction
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 faction
            .local ::temp2 form
          .endLocalTable
          .code
            ; line 336
            callstatic game IsPluginInstalled ::temp0 "CS_Romantasy.esp" ;1 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 337
            cast ::temp1 None 
            return ::temp1 
            jmp _label0
            ; line 339
          _label0:
            callstatic game GetFormFromFile ::temp2 2048 "CS_Romantasy.esp" ;2 variable args
            cast ::temp1 ::temp2 
            return ::temp1 
          .endCode
        .endFunction ;RomantasyFaction
        .function RegisterEvents
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 348
            callmethod UnregisterForModEvent self ::nonevar "Romantasy_OnLevelChanged" ;1 variable args
            ; line 349
            callmethod UnregisterForModEvent self ::nonevar "Romantasy_OnPreference" ;1 variable args
            ; line 352
            callmethod UnregisterForAllKeys self ::nonevar ;0 variable args
            ; line 353
            callmethod RegisterForModEvent self ::nonevar "SNRom_Hotkey" "OnHotkey" ;2 variable args
            ; line 362
            callmethod RegisterForModEvent self ::nonevar "SeverActions_NewTeammateDetected" "OnNewTeammate" ;2 variable args
            ; line 370
            callmethod RegisterForModEvent self ::nonevar "maras_status_changed" "OnMarasStatusChanged" ;2 variable args
            ; line 374
            callmethod RegisterForModEvent self ::nonevar "SNRom_DashboardRefresh" "OnDashboardRefresh" ;2 variable args
            ; line 376
            callmethod RegisterForModEvent self ::nonevar "SNRom_DashboardAction" "OnDashboardAction" ;2 variable args
            ; line 378
            callmethod RegisterForModEvent self ::nonevar "SNRom_ImportPoints" "OnImportPoints" ;2 variable args
            ; line 380
            callmethod RegisterForModEvent self ::nonevar "SNRom_ShowNotice" "OnShowNotice" ;2 variable args
          .endCode
        .endFunction ;RegisterEvents
        .function RegisterDecorators
           ; function type 0
          .userFlags 0 ;none
          .docString "RegisterDecorator returns a status int. Ignoring it was how four silent
      registration failures went unnoticed - log every one."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local c Int
            .local ::temp0 Int
            .local e Int
            .local ::nonevar None
            .local ::temp1 String
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 399
            callstatic skyrimNetApi RegisterDecorator ::temp0 "romance_physical_ok" "SNRom_Decorators" "PhysicalOk" ;3 variable args
            assign c ::temp0 
            ; line 400
            callstatic skyrimNetApi RegisterDecorator ::temp0 "get_romance" "SNRom_Decorators" "GetRomance" ;3 variable args
            assign e ::temp0 
            ; line 401
            callstatic sNRom_Bridge LOG_INFO ::temp0 ;0 variable args
            cast ::temp1 c 
            strcat ::temp1 "RegisterDecorator rc: physical_ok=" ::temp1 
            strcat ::temp1 ::temp1 " get_romance=" 
            cast ::temp2 e 
            strcat ::temp2 ::temp1 ::temp2 
            callmethod Diag self ::nonevar ::temp0 ::temp2 False ;3 variable args
          .endCode
        .endFunction ;RegisterDecorators
        .function BeginSpark
           ; function type 0
          .userFlags 0 ;none
          .docString "RomanceBeginSpark. Enrollment."
          .return None
          .paramTable
            .param akActor actor
            .param asReason String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::nonevar None
            .local ::temp2 Int
            .local ::temp3 String
            .local ::temp4 form
            .local ::temp5 Float
            .local ::temp6 form
            .local ::temp7 String
          .endLocalTable
          .code
            ; line 410
            not ::temp0 _ready 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 akActor ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 411
            return None 
            jmp _label1
            ; line 413
          _label1:
            callstatic sNRom_Bridge IsEnrolled ::temp0 akActor ;1 variable args
            jmpf ::temp0 _label2
            ; line 414
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 "BeginSpark on already-enrolled " ::temp3 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 415
            return None 
            jmp _label2
            ; line 420
          _label2:
            callstatic sNRom_Decorators CanBegin ::temp3 akActor ;1 variable args
            cmp_eq ::temp0 ::temp3 "true" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label3
            ; line 421
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 "BeginSpark declined for " ::temp3 
            strcat ::temp3 ::temp3 " - not receptive, orientation mismatch, or already enrolled." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 422
            return None 
            jmp _label3
            ; line 425
          _label3:
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp2 ::temp4 "SNRom_Enrolled" 1 ;3 variable args
            ; line 426
            callmethod JoinBondFaction self ::nonevar akActor ;1 variable args
            ; line 427
            cast ::temp4 akActor 
            callstatic utility GetCurrentGameTime ::temp5 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp5 ::temp4 "SNRom_EnrolledAt" ::temp5 ;3 variable args
            ; line 432
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp2 ::temp4 "SNRom_Sparked" 1 ;3 variable args
            ; line 436
            cast ::temp4 None 
            cast ::temp6 akActor 
            callstatic storageUtil FormListAdd ::temp2 ::temp4 "SNRom_Roster" ::temp6 False ;4 variable args
            ; line 440
            callstatic sNRom_Bridge ScaleAward ::temp2 25 ;1 variable args
            callmethod ApplyDepth self ::temp2 akActor ::temp2 asReason False "began" ;5 variable args
            ; line 444
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 ::temp3 " and " 
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName ::temp1 ::temp7 ;0 variable args
            strcat ::temp7 ::temp3 ::temp7 
            strcat ::temp7 ::temp7 " have reached an understanding neither has named. " 
            ; line 445
            strcat ::temp7 ::temp7 asReason 
            callmethod SendModEvent akActor ::nonevar "IEB_SNRomStatus" ::temp7 0.0 ;3 variable args
            ; line 447
            callmethod Ledger self ::nonevar akActor "enroll" "" 25 1 asReason ;6 variable args
            ; line 448
            callmethod IEB_WriteRomTrack self ::nonevar akActor ;1 variable args
            ; line 449
            callmethod IEB_QueueIntimacy self ::nonevar akActor ;1 variable args
            ; line 454
            callmethod AuthorDisposition self ::nonevar akActor ;1 variable args
          .endCode
        .endFunction ;BeginSpark
        .function SweepFollowers
           ; function type 0
          .userFlags 0 ;none
          .docString "Detection CANNOT be purely reactive, and believing otherwise cost a
      whole session.

      SeverActions_NewTeammateDetected only fires for actors SeverActions is
      not ALREADY tracking. A long-standing follower it already knows never
      generates an event at all, so we never hear about her: Hermir traveled
      for an entire session, was talked to at length, and was never enrolled.

      What disguised this is that save reverts also revert SeverActions' own
      tracking data, so after each revert everyone briefly looked new and the
      event fired for the whole party. It appeared to work; it was only
      working because the tracking had been thrown away.

      ScanCellNPCs returns Actor[] directly, so unlike ScanCellObjects there
      is no form-type enum to get silently wrong. Radius bounds the cost.
      Anyone further out is picked up the next time they share a cell, and
      the roster is persistent, so it only has to happen once per follower.

      IgnoreDead is passed FALSE, and the dead check moved into the loop below.
      A VR user crashed inside PapyrusUtil on 2026-08-19 in the cell walk this
      call drives: an access violation reading a byte at rdi+0x40 with rdi =
      0xFFFFFF01, which is a stale entry in the cell's object list rather than
      anything we passed - the only arguments crossing this boundary are the
      player and a float. They reported it "after two in-game hours", which is
      exactly SparkIntervalHours, so it was the first OnUpdateGameTime tick
      that happened to land in a heavily patched interior.

      IgnoreDead TRUE makes PapyrusUtil evaluate each actor's dead state during
      that native walk, so it must dereference every entry it finds. FALSE
      skips that, and a.IsDead() below asks the same question through a
      VM-validated handle, where a stale pointer cannot reach us. Whether that
      is sufficient is UNTESTED - none of this reproduces without a VR install -
      so cellScanEnabled is the off switch for anyone it still crashes."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Bool
            .local player actor
            .local ::temp2 actor
            .local near actor[]
            .local ::temp3 objectReference
            .local ::temp4 keyword
            .local ::temp5 actor[]
            .local scanned Int
            .local ::temp6 Int
            .local followers Int
            .local i Int
            .local a actor
            .local ::temp7 form
            .local ::temp8 Float
            .local ::nonevar None
            .local ::temp9 form
            .local ::temp10 String
            .local ::temp11 Int
          .endLocalTable
          .code
            ; line 507
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp1 ::temp0 "cellScanEnabled" True ;3 variable args
            cmp_eq ::temp1 ::temp1 False 
            jmpf ::temp1 _label0
            ; line 508
            return None 
            jmp _label0
            ; line 510
          _label0:
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign player ::temp2 
            ; line 511
            cast ::temp3 player 
            cast ::temp4 None 
            callstatic miscUtil ScanCellNPCs ::temp5 ::temp3 6000.0 ::temp4 False ;4 variable args
            assign near ::temp5 
            ; line 512
            assign scanned 0 
            ; line 513
            cast ::temp1 near 
            jmpf ::temp1 _label1
            ; line 514
            array_length ::temp6 near 
            assign scanned ::temp6 
            jmp _label1
            ; line 516
          _label1:
            assign followers 0 
            ; line 517
            assign i 0 
            ; line 518
          _label9:
            cmp_lt ::temp1 i scanned 
            jmpf ::temp1 _label2
            ; line 519
            array_getlement ::temp2 near i 
            assign a ::temp2 
            ; line 520
            cast ::temp2 None 
            cmp_eq ::temp1 a ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label3
            cmp_eq ::temp1 a player 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label3:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label4
            callmethod IsDead a ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label4:
            jmpf ::temp1 _label5
            ; line 521
            callstatic sNRom_Bridge IsFollowing ::temp1 a ;1 variable args
            jmpf ::temp1 _label6
            ; line 522
            iadd ::temp6 followers 1 
            assign followers ::temp6 
            ; line 534
            cast ::temp7 a 
            callstatic utility GetCurrentGameTime ::temp8 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp8 ::temp7 "SNRom_LastFollowingAt" ::temp8 ;3 variable args
            ; line 535
            callmethod AutoEnroll self ::nonevar a ;1 variable args
            jmp _label7
            ; line 536
          _label6:
            cast ::temp7 a 
            callstatic storageUtil GetFloatValue ::temp8 ::temp7 "SNRom_FirstSeenFollowing" 0.0 ;3 variable args
            cmp_gt ::temp1 ::temp8 0.0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label8
            ; line 537
            cast ::temp7 a 
            callstatic storageUtil GetIntValue ::temp6 ::temp7 "SNRom_Enrolled" 0 ;3 variable args
            cmp_eq ::temp1 ::temp6 0 
            assign ::temp1 ::temp1 
          _label8:
            jmpf ::temp1 _label7
            ; line 551
            cast ::temp7 a 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp7 "SNRom_FirstSeenFollowing" ;2 variable args
            ; line 552
            cast ::temp7 None 
            callstatic sNRom_Bridge PENDING_LIST ::temp0 ;0 variable args
            cast ::temp9 a 
            callstatic storageUtil FormListRemove ::temp6 ::temp7 ::temp0 ::temp9 True ;4 variable args
            ; line 553
            callstatic sNRom_Bridge LOG_INFO ::temp6 ;0 variable args
            callmethod GetDisplayName a ::temp0 ;0 variable args
            strcat ::temp0 ::temp0 " is no longer following before enrollment - waiting period reset" 
            callmethod Diag self ::nonevar ::temp6 ::temp0 False ;3 variable args
            jmp _label7
          _label7:
            jmp _label5
            ; line 556
          _label5:
            iadd ::temp6 i 1 
            assign i ::temp6 
            jmp _label9
            ; line 558
          _label2:
            callmethod PurgeNonPersons self ::nonevar ;0 variable args
            ; line 559
            callmethod IEB_ChildSweep self ::nonevar ;0 variable args
            ; line 560
            callmethod IEB_MarasCatchUp self ::nonevar ;0 variable args
            ; line 561
            callmethod IEB_IntimacyCatchUp self ::nonevar ;0 variable args
            ; line 572
            cast ::temp9 None 
            callstatic storageUtil SetIntValue ::temp6 ::temp9 "SNRom_FollowerCount" followers ;3 variable args
            ; line 573
            callstatic sNRom_Bridge LOG_INFO ::temp6 ;0 variable args
            cast ::temp0 scanned 
            strcat ::temp0 "Follower sweep: " ::temp0 
            strcat ::temp0 ::temp0 " actors in range, " 
            cast ::temp10 followers 
            strcat ::temp10 ::temp0 ::temp10 
            strcat ::temp10 ::temp10 " following, roster now " 
            ; line 574
            cast ::temp9 None 
            callstatic storageUtil FormListCount ::temp11 ::temp9 "SNRom_Roster" ;2 variable args
            cast ::temp0 ::temp11 
            strcat ::temp0 ::temp10 ::temp0 
            callmethod Diag self ::nonevar ::temp6 ::temp0 False ;3 variable args
          .endCode
        .endFunction ;SweepFollowers
        .function PENDING_LIST
           ; function type 0
          .userFlags 0 ;none
          .docString "Everyone serving the enrollment waiting period: noticed following, not
      yet enrolled."
          .return String
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 580
            return "SNRom_PendingEnroll" 
          .endCode
        .endFunction ;PENDING_LIST
        .function CheckPendingEnrollments
           ; function type 0
          .userFlags 0 ;none
          .docString "FINISHES THE WAITING PERIOD WHEREVER THEY ARE. The sweep notices a
      follower near the player; this asks each one waiting, directly, whether
      they are still following - IsFollowing reads flags and factions, which an
      unloaded character has too. So a new follower told to wait in a house
      while the player clears a dungeon is enrolled when the period is up, as
      the author asked (2026-10-01), not on the first sweep that finds them
      nearby again. Not following any more resets the period: "two CONTINUOUS
      hours", as the sweep's own reset has always meant.

      A short list, so a handful of reads a tick. Backwards, because entries
      are removed as it goes."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local i Int
            .local ::temp0 form
            .local ::temp1 String
            .local ::temp2 Int
            .local ::temp3 Bool
            .local a actor
            .local ::temp4 actor
            .local ::temp5 Float
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 595
            cast ::temp0 None 
            callstatic sNRom_Bridge PENDING_LIST ::temp1 ;0 variable args
            callstatic storageUtil FormListCount ::temp2 ::temp0 ::temp1 ;2 variable args
            isub ::temp2 ::temp2 1 
            assign i ::temp2 
            ; line 596
          _label6:
            comp_gte ::temp3 i 0 
            jmpf ::temp3 _label0
            ; line 597
            cast ::temp0 None 
            callstatic sNRom_Bridge PENDING_LIST ::temp1 ;0 variable args
            callstatic storageUtil FormListGet ::temp0 ::temp0 ::temp1 i ;3 variable args
            cast ::temp4 ::temp0 
            assign a ::temp4 
            ; line 598
            cast ::temp4 None 
            cmp_eq ::temp3 a ::temp4 
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label1
            callmethod IsDead a ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label1:
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label2
            callstatic sNRom_Bridge IsEnrolled ::temp3 a ;1 variable args
            assign ::temp3 ::temp3 
          _label2:
            jmpf ::temp3 _label3
            ; line 599
            cast ::temp0 None 
            callstatic sNRom_Bridge PENDING_LIST ::temp1 ;0 variable args
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp0 ::temp1 i ;3 variable args
            jmp _label4
            ; line 600
          _label3:
            callstatic sNRom_Bridge IsFollowing ::temp3 a ;1 variable args
            jmpf ::temp3 _label5
            ; line 601
            cast ::temp0 a 
            callstatic utility GetCurrentGameTime ::temp5 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp5 ::temp0 "SNRom_LastFollowingAt" ::temp5 ;3 variable args
            ; line 602
            callmethod AutoEnroll self ::nonevar a ;1 variable args
            jmp _label4
            ; line 604
          _label5:
            cast ::temp0 None 
            callstatic sNRom_Bridge PENDING_LIST ::temp1 ;0 variable args
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp0 ::temp1 i ;3 variable args
            ; line 605
            cast ::temp0 a 
            callstatic storageUtil GetFloatValue ::temp5 ::temp0 "SNRom_FirstSeenFollowing" 0.0 ;3 variable args
            cmp_gt ::temp3 ::temp5 0.0 
            jmpf ::temp3 _label4
            ; line 606
            cast ::temp0 a 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp0 "SNRom_FirstSeenFollowing" ;2 variable args
            ; line 607
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName a ::temp1 ;0 variable args
            strcat ::temp1 ::temp1 " is no longer following before enrollment - waiting period reset" 
            callmethod Diag self ::nonevar ::temp2 ::temp1 False ;3 variable args
            jmp _label4
            ; line 610
          _label4:
            isub ::temp2 i 1 
            assign i ::temp2 
            jmp _label6
          _label0
          .endCode
        .endFunction ;CheckPendingEnrollments
        .function PurgeNonPersons
           ; function type 0
          .userFlags 0 ;none
          .docString "Self-healing cleanup for creatures already on the roster.

      Written instead of dispatching UnenrollActor on the two horses by hand,
      for two reasons: the game was stopped so nothing could be dispatched, and
      a hand-written list would have missed the House Cat - which was noticed
      separately and is exactly the kind of thing a manual fix forgets.

      Runs on the sweep rather than once at load, so anything that slipped in
      under an older build is removed the first time the player is near it, with
      no migration step and nothing for the player to remember to run.

      Walks BACKWARDS. FormListRemove shifts every later index down by one, so a
      forward loop skips the entry immediately after each removal - and with two
      horses adjacent on the roster that would have left one of them behind."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local i Int
            .local ::temp0 form
            .local ::temp1 Int
            .local ::temp2 Bool
            .local a actor
            .local ::temp3 actor
            .local ::nonevar None
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 629
            cast ::temp0 None 
            callstatic storageUtil FormListCount ::temp1 ::temp0 "SNRom_Roster" ;2 variable args
            isub ::temp1 ::temp1 1 
            assign i ::temp1 
            ; line 630
          _label3:
            comp_gte ::temp2 i 0 
            jmpf ::temp2 _label0
            ; line 631
            cast ::temp0 None 
            callstatic storageUtil FormListGet ::temp0 ::temp0 "SNRom_Roster" i ;3 variable args
            cast ::temp3 ::temp0 
            assign a ::temp3 
            ; line 632
            cast ::temp3 None 
            cmp_eq ::temp2 a ::temp3 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label1
            callmethod IsPerson self ::temp2 a ;1 variable args
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 633
            callstatic sNRom_Bridge LOG_WARN ::temp1 ;0 variable args
            callmethod GetDisplayName a ::temp4 ;0 variable args
            strcat ::temp4 "Removing " ::temp4 
            strcat ::temp4 ::temp4 " from the roster - not a person. " 
            strcat ::temp4 ::temp4 "Enrolled by a build that only asked whether they were following." 
            callmethod Diag self ::nonevar ::temp1 ::temp4 False ;3 variable args
            ; line 635
            callmethod UnenrollActor self ::nonevar a ;1 variable args
            jmp _label2
            ; line 637
          _label2:
            isub ::temp1 i 1 
            assign i ::temp1 
            jmp _label3
          _label0
          .endCode
        .endFunction ;PurgeNonPersons
        .function IsPerson
           ; function type 0
          .userFlags 0 ;none
          .docString "NOT Global, deliberately - unlike IsFollowing. A Global cannot call Diag,
      and the fail-open branch below is worthless without a log line: a filter
      that silently stops filtering looks exactly like the bug it replaced.
      Nothing outside this script needs it, so instance scope costs nothing.

      People only. Horses, cats and anything else on four legs are not romance
      candidates and were never meant to be.

      TWO HORSES AND A HOUSE CAT reached the roster before this existed - with
      recruit rows, LLM-authored dispositions, and a share of the one-assessment
      -per-tick budget. A Haflinger Horse had opinions about Barters, Locks
      Picked and Items Stolen. AutoEnroll filtered dead / commanded / player and
      then asked IsFollowing, and an owned horse passes IsPlayerTeammate, so
      nothing in the chain ever asked whether the candidate was a PERSON.

      ActorTypeNPC is the game's own answer to that question, which is why this
      uses it rather than a race list or a name test. It is also strictly better
      than the ActorBase.IsUnique() guard rejected on 2026-08-02: that would
      have excluded FMR-spawned children, who ARE people, while still letting a
      unique horse through. This does neither.

      FAILS OPEN, and loudly. If the keyword cannot be resolved the answer is
      "yes, a person" rather than blocking every enrollment in the mod - but it
      logs at ERROR, because a silent fail-open here would look exactly like the
      bug it was written to fix."
          .return Bool
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local kw keyword
            .local ::temp2 form
            .local ::temp3 keyword
            .local ::nonevar None
            .local ::temp4 Int
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 667
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 668
            return False 
            jmp _label0
            ; line 670
          _label0:
            callstatic game GetFormFromFile ::temp2 79764 "Skyrim.esm" ;2 variable args
            cast ::temp3 ::temp2 
            assign kw ::temp3 
            ; line 671
            cast ::temp3 None 
            cmp_eq ::temp1 kw ::temp3 
            jmpf ::temp1 _label1
            ; line 672
            callstatic sNRom_Bridge LOG_ERROR ::temp4 ;0 variable args
            strcat ::temp5 "ActorTypeNPC keyword did not resolve from Skyrim.esm - the humans-only " "filter is INERT this session and creatures can be enrolled again." 
            callmethod Diag self ::nonevar ::temp4 ::temp5 False ;3 variable args
            ; line 674
            return True 
            jmp _label1
            ; line 676
          _label1:
            callmethod HasKeyword akActor ::temp1 kw ;1 variable args
            return ::temp1 
          .endCode
        .endFunction ;IsPerson
        .function SeverActionsPresent
           ; function type 0
          .userFlags 0 ;none
          .docString "GLOBAL, and therefore NOT cached in a script variable the way MarasPresent
      is - a Global has no instance state to cache into. IsPluginInstalled is a
      cheap native lookup, so paying it per call is fine and is much better than
      the alternative of making IsFollowing non-Global again.

      Guards SA's native Papyrus surface. Calling a native whose DLL is absent
      does not CTD, but it logs a Papyrus error per call, and IsFollowing runs
      for every actor in every sweep."
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 688
            callstatic game IsPluginInstalled ::temp0 "SeverActions.esp" ;1 variable args
            return ::temp0 
          .endCode
        .endFunction ;SeverActionsPresent
        .function IsFollowing
           ; function type 0
          .userFlags 0 ;none
          .docString "GLOBAL so SNRom_Decorators can reach it too - CanBegin was asking the same
      question with the bare vanilla flag, which is the identical bug. Touches no
      instance state, so Global is safe here. (The "never Global" rule applies to
      DECORATOR entry points, which SkyrimNet dispatches as instance methods;
      this is a plain helper.)

      THREE tests, because one is not enough and two were not either.

      IsPlayerTeammate is the vanilla flag and is what most followers set, but
      follower frameworks do not all use it consistently and it can be cleared
      while someone is still functionally traveling with you. Vanilla's
      CurrentFollowerFaction is the second opinion.

      The third is SeverActions' OWN follower flag, read straight out of
      StorageUtil. Found by reading the 3.9.0 source: SeverActions_FollowerManager
      documents its per-follower keys at :28-35 and defines KEY_IS_FOLLOWER at
      :433. It is an INT (see the UnsetIntValue at :2673), and ints survive a
      reload here where strings do not - so it is durable as well as
      authoritative. Preferred over the SeverActions_ActivelyFollowing FACTION:
      no Game.GetFormFromFile, no ESL indirection, no soft-dependency guard,
      and a missing key simply returns 0 when SeverActions is not installed.

      Written as OR deliberately: a false negative here means an NPC is never
      enrolled and never scored, silently, forever - which is exactly what
      happened to Hermir and then to Svana. A false positive costs one wasted
      enrollment, and the enrollment debounce now absorbs even that.

      THE DASHBOARD DRAWS A COPY OF THIS: Display::Following in
      native/src/Display.cpp, line for line, from facts the DLL reads itself.
      Change one, change both. The gates keep calling this function."
          .return Bool
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local cff faction
            .local ::temp1 form
            .local ::temp2 faction
          .endLocalTable
          .code
            ; line 722
            callmethod IsPlayerTeammate akActor ::temp0 ;0 variable args
            jmpf ::temp0 _label0
            ; line 723
            return True 
            jmp _label0
            ; line 739
          _label0:
            callstatic sNRom_Bridge SeverActionsPresent ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label1
            callstatic severActionsNativeExt Native_GetIsFollower ::temp0 akActor ;1 variable args
            assign ::temp0 ::temp0 
          _label1:
            jmpf ::temp0 _label2
            ; line 740
            return True 
            jmp _label2
            ; line 742
          _label2:
            callstatic game GetFormFromFile ::temp1 378958 "Skyrim.esm" ;2 variable args
            cast ::temp2 ::temp1 
            assign cff ::temp2 
            ; line 743
            cast ::temp2 None 
            cmp_eq ::temp0 cff ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            callmethod IsInFaction akActor ::temp0 cff ;1 variable args
            assign ::temp0 ::temp0 
          _label3:
            return ::temp0 
          .endCode
        .endFunction ;IsFollowing
        .function OBSERVE_RANGE
           ; function type 0
          .userFlags 0 ;none
          .docString "How near the player an enrolled character must be to be observing them:
      the follower sweep's own scan radius, so "near enough to notice
      following" and "near enough to notice anything" are one distance."
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 750
            return 6000.0 
          .endCode
        .endFunction ;OBSERVE_RANGE
        .function Observers
           ; function type 0
          .userFlags 0 ;none
          .docString "FOLLOWING IS NOT A QUALIFIER (design 3.2): everyone enrolled who can
      observe the player - loaded, alive and within OBSERVE_RANGE - follower
      or not. The talk, spark and drift assessors, the attraction reading and
      the marriage check pick from these. Following decides one thing,
      automatic enrollment (SweepFollowers).

      THE ASSESSORS READ EVERYTHING SINCE THEIR LAST LOOK, so a conversation
      with someone you then walk away from is not lost: it is judged the next
      time a tick finds you near them. A spouse at home lives again when you
      visit; a shopkeeper you courted, when you go back.

      ONE NATIVE CALL with the DLL (natives v6), one frame. Without it, or with
      an older one, a roster walk that pays a frame per question per
      character - correct, and slow."
          .return actor[]
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 Float
            .local ::temp2 actor[]
            .local player actor
            .local ::temp3 actor
            .local found actor[]
            .local n Int
            .local ::temp4 form
            .local ::temp5 Int
            .local i Int
            .local a actor
            .local ::temp6 objectReference
            .local ::temp7 Float
          .endLocalTable
          .code
            ; line 768
            comp_gte ::temp0 _dashNatives 6 
            jmpf ::temp0 _label0
            ; line 769
            callstatic sNRom_Bridge OBSERVE_RANGE ::temp1 ;0 variable args
            callstatic sNRom_Native ObserversNear ::temp2 ::temp1 ;1 variable args
            return ::temp2 
            jmp _label0
            ; line 771
          _label0:
            callstatic game GetPlayer ::temp3 ;0 variable args
            assign player ::temp3 
            ; line 772
            cast ::temp3 None 
            callstatic papyrusUtil ActorArray ::temp2 0 ::temp3 ;2 variable args
            assign found ::temp2 
            ; line 773
            cast ::temp4 None 
            callstatic storageUtil FormListCount ::temp5 ::temp4 "SNRom_Roster" ;2 variable args
            assign n ::temp5 
            ; line 774
            assign i 0 
            ; line 775
          _label6:
            cmp_lt ::temp0 i n 
            jmpf ::temp0 _label1
            ; line 776
            cast ::temp4 None 
            callstatic storageUtil FormListGet ::temp4 ::temp4 "SNRom_Roster" i ;3 variable args
            cast ::temp3 ::temp4 
            assign a ::temp3 
            ; line 777
            cast ::temp3 None 
            cmp_eq ::temp0 a ::temp3 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label2
            callmethod Is3DLoaded a ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label2:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            callmethod IsDead a ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label3:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label4
            cast ::temp6 player 
            callmethod GetDistance a ::temp1 ::temp6 ;1 variable args
            callstatic sNRom_Bridge OBSERVE_RANGE ::temp7 ;0 variable args
            cmp_lte ::temp0 ::temp1 ::temp7 
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label5
            ; line 778
            callstatic papyrusUtil PushActor ::temp2 found a ;2 variable args
            assign found ::temp2 
            jmp _label5
            ; line 780
          _label5:
            iadd ::temp5 i 1 
            assign i ::temp5 
            jmp _label6
            ; line 782
          _label1:
            return found 
          .endCode
        .endFunction ;Observers
        .function OnNewTeammate
           ; function type 0
          .userFlags 0 ;none
          .docString "Shape copied from SeverActions_FollowerManager.OnNativeTeammateDetected:
      sender is the Actor, with numArg as a FormID fallback."
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local who actor
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 Int
            .local ::temp3 form
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 788
            cast ::temp0 sender 
            assign who ::temp0 
            ; line 789
            cast ::temp0 None 
            cmp_eq ::temp1 who ::temp0 
            jmpf ::temp1 _label0
            ; line 790
            cast ::temp2 numArg 
            callstatic game GetFormEx ::temp3 ::temp2 ;1 variable args
            cast ::temp0 ::temp3 
            assign who ::temp0 
            jmp _label0
            ; line 792
          _label0:
            callmethod AutoEnroll self ::nonevar who ;1 variable args
          .endCode
        .endFunction ;OnNewTeammate
        .function AutoEnroll
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::temp2 String
            .local ::nonevar None
            .local ::temp3 Int
            .local ::temp4 form
            .local ::temp5 form
            .local now Float
            .local ::temp6 Float
            .local firstSeen Float
            .local ::temp7 String
            .local ::temp8 Float
          .endLocalTable
          .code
            ; line 796
            not ::temp0 _ready 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 akActor ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 797
            return None 
            jmp _label1
            ; line 799
          _label1:
            callstatic sNRom_Bridge CFG ::temp2 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp0 ::temp2 "enrollmentOrganic" True ;3 variable args
            cmp_eq ::temp0 ::temp0 False 
            jmpf ::temp0 _label2
            ; line 800
            return None 
            jmp _label2
            ; line 804
          _label2:
            callmethod IsDead akActor ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label3
            callmethod IsCommandedActor akActor ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label3:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label4
            callstatic game GetPlayer ::temp1 ;0 variable args
            cmp_eq ::temp0 akActor ::temp1 
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label5
            ; line 805
            return None 
            jmp _label5
            ; line 809
          _label5:
            callmethod IsPerson self ::temp0 akActor ;1 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label6
            ; line 810
            callstatic sNRom_Bridge LOG_DEBUG ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            strcat ::temp2 "Not enrolling " ::temp2 
            strcat ::temp2 ::temp2 " - not a person" 
            callmethod Diag self ::nonevar ::temp3 ::temp2 False ;3 variable args
            ; line 811
            return None 
            jmp _label6
            ; line 817
          _label6:
            callstatic sNRom_Bridge IsEnrolled ::temp0 akActor ;1 variable args
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label7
            cast ::temp4 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp4 "SNRom_Enrolled" 0 ;3 variable args
            cmp_eq ::temp0 ::temp3 1 
            assign ::temp0 ::temp0 
          _label7:
            jmpf ::temp0 _label8
            ; line 833
            cast ::temp4 None 
            cast ::temp5 akActor 
            callstatic storageUtil FormListAdd ::temp3 ::temp4 "SNRom_Roster" ::temp5 False ;4 variable args
            ; line 834
            return None 
            jmp _label8
            ; line 863
          _label8:
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            assign now ::temp6 
            ; line 864
            cast ::temp5 akActor 
            callstatic storageUtil GetFloatValue ::temp6 ::temp5 "SNRom_FirstSeenFollowing" 0.0 ;3 variable args
            assign firstSeen ::temp6 
            ; line 865
            cmp_lte ::temp0 firstSeen 0.0 
            jmpf ::temp0 _label9
            ; line 866
            cast ::temp5 akActor 
            callstatic storageUtil SetFloatValue ::temp6 ::temp5 "SNRom_FirstSeenFollowing" now ;3 variable args
            ; line 867
            cast ::temp5 None 
            callstatic sNRom_Bridge PENDING_LIST ::temp2 ;0 variable args
            cast ::temp4 akActor 
            callstatic storageUtil FormListAdd ::temp3 ::temp5 ::temp2 ::temp4 False ;4 variable args
            ; line 868
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            strcat ::temp2 "Noticed " ::temp2 
            strcat ::temp2 ::temp2 " following - enrollment held until they are still here in " 
            ; line 870
            callstatic sNRom_Bridge CFG ::temp7 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp6 ::temp7 "enrollmentDelayHours" 2.0 ;3 variable args
            cast ::temp7 ::temp6 
            strcat ::temp7 ::temp2 ::temp7 
            strcat ::temp7 ::temp7 " game hours" 
            callmethod Diag self ::nonevar ::temp3 ::temp7 False ;3 variable args
            ; line 871
            return None 
            jmp _label9
            ; line 873
          _label9:
            fsub ::temp6 now firstSeen 
            callstatic sNRom_Bridge CFG ::temp7 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp8 ::temp7 "enrollmentDelayHours" 2.0 ;3 variable args
            fdiv ::temp8 ::temp8 24.0 
            cmp_lt ::temp0 ::temp6 ::temp8 
            jmpf ::temp0 _label10
            ; line 874
            return None 
            jmp _label10
            ; line 877
          _label10:
            callmethod EnrollNow self ::nonevar akActor "Auto-enrolled" ;2 variable args
          .endCode
        .endFunction ;AutoEnroll
        .function EnrollNow
           ; function type 0
          .userFlags 0 ;none
          .docString "THE ENROLLMENT ITSELF, for both ways in: AutoEnroll once a follower's
      waiting period is up, and EnrollByHand. asHow opens the log line."
          .return None
          .paramTable
            .param akActor actor
            .param asHow String
          .endParamTable
          .localTable
            .local ::temp0 form
            .local ::temp1 Int
            .local ::nonevar None
            .local ::temp2 Float
            .local ::temp3 String
            .local ::temp4 form
            .local ::temp5 Bool
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 883
            cast ::temp0 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp0 "SNRom_Enrolled" 1 ;3 variable args
            ; line 884
            callmethod JoinBondFaction self ::nonevar akActor ;1 variable args
            ; line 888
            cast ::temp0 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp0 "SNRom_AutoEnrolled" 1 ;3 variable args
            ; line 889
            cast ::temp0 akActor 
            callstatic utility GetCurrentGameTime ::temp2 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp2 ::temp0 "SNRom_EnrolledAt" ::temp2 ;3 variable args
            ; line 890
            cast ::temp0 None 
            callstatic sNRom_Bridge PENDING_LIST ::temp3 ;0 variable args
            cast ::temp4 akActor 
            callstatic storageUtil FormListRemove ::temp1 ::temp0 ::temp3 ::temp4 True ;4 variable args
            ; line 892
            callmethod IEB_LockChildIntimacy self ::temp5 akActor ;1 variable args
            jmpf ::temp5 _label0
            ; line 893
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp4 "SNRom_SparkDecided" 1 ;3 variable args
            jmp _label0
            ; line 915
          _label0:
            cast ::temp4 akActor 
            callstatic utility GetCurrentGameTime ::temp2 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp2 ::temp4 "SNRom_LastTalkCheck" ::temp2 ;3 variable args
            ; line 916
            cast ::temp4 akActor 
            callstatic utility GetCurrentGameTime ::temp2 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp2 ::temp4 "SNRom_LastSparkCheck" ::temp2 ;3 variable args
            ; line 935
            cast ::temp4 None 
            cast ::temp0 akActor 
            callstatic storageUtil FormListAdd ::temp1 ::temp4 "SNRom_Roster" ::temp0 False ;4 variable args
            ; line 937
            callmethod Ledger self ::nonevar akActor "recruit" "" 0 1 "" ;6 variable args
            ; line 938
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            strcat ::temp3 asHow " " 
            callmethod GetDisplayName akActor ::temp6 ;0 variable args
            strcat ::temp6 ::temp3 ::temp6 
            strcat ::temp6 ::temp6 " at Stranger/0" 
            strcat ::temp6 ::temp6 " (platonic until sparked)" 
            callmethod Diag self ::nonevar ::temp1 ::temp6 False ;3 variable args
            ; line 941
            callmethod AuthorDisposition self ::nonevar akActor ;1 variable args
          .endCode
        .endFunction ;EnrollNow
        .function EnrollByHand
           ; function type 0
          .userFlags 0 ;none
          .docString "WP7: THE PLAYER ENROLLS SOMEONE, following or not - the dashboard's
      crosshair target or the enroll hotkey. The only way a non-follower joins
      the roster: never automatic (design 3.2, the author 2026-09-28). No
      waiting period, because the player asked. "" when enrolled; otherwise
      why not, in words for the player."
          .return String
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local who String
            .local ::temp2 String
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 950
            not ::temp0 _ready 
            jmpf ::temp0 _label0
            ; line 951
            return "Relationships has not started this session." 
            jmp _label0
            ; line 953
          _label0:
            cast ::temp1 None 
            cmp_eq ::temp0 akActor ::temp1 
            jmpf ::temp0 _label1
            ; line 954
            return "Point at someone first." 
            jmp _label1
            ; line 956
          _label1:
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            assign who ::temp2 
            ; line 957
            callstatic game GetPlayer ::temp1 ;0 variable args
            cmp_eq ::temp0 akActor ::temp1 
            jmpf ::temp0 _label2
            ; line 958
            return "That is you." 
            jmp _label2
            ; line 960
          _label2:
            callmethod IsDead akActor ::temp0 ;0 variable args
            jmpf ::temp0 _label3
            ; line 961
            strcat ::temp2 who " is dead." 
            return ::temp2 
            jmp _label3
            ; line 963
          _label3:
            callmethod IsCommandedActor akActor ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label4
            callmethod IsPerson self ::temp0 akActor ;1 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label5
            ; line 964
            strcat ::temp2 who " cannot be enrolled - only people can." 
            return ::temp2 
            jmp _label5
            ; line 966
          _label5:
            callstatic sNRom_Bridge IsEnrolled ::temp0 akActor ;1 variable args
            jmpf ::temp0 _label6
            ; line 967
            strcat ::temp2 who " is already enrolled." 
            return ::temp2 
            jmp _label6
            ; line 969
          _label6:
            callmethod EnrollNow self ::nonevar akActor "Enrolled by hand:" ;2 variable args
            ; line 970
            return "" 
          .endCode
        .endFunction ;EnrollByHand
        .function DigitsToInt
           ; function type 0
          .userFlags 0 ;none
          .docString "Pull a signed integer out of whatever the model actually sent.

      Deliberately strict about what it will invent: digits and one leading
      sign, nothing else. A stray brace before the digits gives the number,
      "-20" gives -20, "+35" gives 35, and "a lot" gives 0 - which the caller
      still treats as a damaged payload, because it is."
          .return Int
          .paramTable
            .param asText String
          .endParamTable
          .localTable
            .local n Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local i Int
            .local val Int
            .local neg Bool
            .local seen Bool
            .local c String
            .local ::temp2 String
            .local o Int
            .local ::temp3 Int
          .endLocalTable
          .code
            ; line 1001
            callstatic stringUtil GetLength ::temp0 asText ;1 variable args
            assign n ::temp0 
            ; line 1002
            cmp_eq ::temp1 n 0 
            jmpf ::temp1 _label0
            ; line 1003
            return 0 
            jmp _label0
            ; line 1005
          _label0:
            assign i 0 
            ; line 1006
            assign val 0 
            ; line 1007
            assign neg False 
            ; line 1008
            assign seen False 
            ; line 1009
          _label7:
            cmp_lt ::temp1 i n 
            jmpf ::temp1 _label1
            ; line 1010
            callstatic stringUtil GetNthChar ::temp2 asText i ;2 variable args
            assign c ::temp2 
            ; line 1011
            callstatic stringUtil AsOrd ::temp0 c ;1 variable args
            assign o ::temp0 
            ; line 1012
            comp_gte ::temp1 o 48 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            cmp_lte ::temp1 o 57 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 1013
            imul ::temp0 val 10 
            isub ::temp3 o 48 
            iadd ::temp3 ::temp0 ::temp3 
            assign val ::temp3 
            ; line 1014
            assign seen True 
            jmp _label4
            ; line 1015
          _label3:
            cmp_eq ::temp1 c "-" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label5
            not ::temp1 seen 
            assign ::temp1 ::temp1 
          _label5:
            jmpf ::temp1 _label6
            ; line 1019
            assign neg True 
            jmp _label4
          _label6:
            jmpf seen _label4
            ; line 1022
            assign i n 
            jmp _label4
            ; line 1024
          _label4:
            iadd ::temp3 i 1 
            assign i ::temp3 
            jmp _label7
            ; line 1026
          _label1:
            jmpf neg _label8
            ; line 1027
            ineg ::temp3 val 
            return ::temp3 
            jmp _label8
            ; line 1029
          _label8:
            return val 
          .endCode
        .endFunction ;DigitsToInt
        .function MarkMoment
           ; function type 0
          .userFlags 0 ;none
          .docString "RomanceMarkMoment. The workhorse: an authored beat, in either
      direction, awarded flat through the consent gate."
          .return None
          .paramTable
            .param akActor actor
            .param aiMagnitude Int
            .param asReason String
            .param asActivity String
            .param asMagnitude String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::nonevar None
            .local ::temp2 Int
            .local ::temp3 String
            .local mag Int
            .local ::temp4 String
            .local cap Int
            .local clamped Int
            .local magnitude Int
            .local result Int
            .local moved String
          .endLocalTable
          .code
            ; line 1035
            not ::temp0 _ready 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 akActor ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 1036
            return None 
            jmp _label1
            ; line 1038
          _label1:
            callstatic sNRom_Bridge IsEnrolled ::temp0 akActor ;1 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 1039
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 "MarkMoment on unenrolled " ::temp3 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 1040
            return None 
            jmp _label2
            ; line 1062
          _label2:
            assign mag aiMagnitude 
            ; line 1063
            cmp_eq ::temp0 mag 0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            cmp_eq ::temp0 asMagnitude "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 1064
            callstatic sNRom_Bridge DigitsToInt ::temp2 asMagnitude ;1 variable args
            assign mag ::temp2 
            ; line 1065
            cmp_eq ::temp0 mag 0 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label5
            ; line 1066
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            cast ::temp3 mag 
            strcat ::temp3 "Recovered magnitude " ::temp3 
            strcat ::temp3 ::temp3 " for " 
            ; line 1067
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 " from a damaged parameter ('" 
            strcat ::temp4 ::temp4 asMagnitude 
            strcat ::temp4 ::temp4 "'). The moment was kept." 
            callmethod Diag self ::nonevar ::temp2 ::temp4 False ;3 variable args
            jmp _label5
          _label5:
            jmp _label4
            ; line 1076
          _label4:
            cmp_eq ::temp0 mag 0 
            jmpf ::temp0 _label6
            ; line 1077
            callstatic sNRom_Bridge LOG_ERROR ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "MarkMoment for " ::temp4 
            strcat ::temp4 ::temp4 ": magnitude did not parse. Moment dropped." 
            callmethod Diag self ::nonevar ::temp2 ::temp4 False ;3 variable args
            ; line 1079
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            strcat ::temp4 "  dropped reason was: " asReason 
            callmethod Diag self ::nonevar ::temp2 ::temp4 False ;3 variable args
            ; line 1080
            return None 
            jmp _label6
            ; line 1087
          _label6:
            callstatic sNRom_Bridge CFG ::temp4 ;0 variable args
            callstatic skyrimNetApi GetConfigInt ::temp2 ::temp4 "awardMaxPoints" 75 ;3 variable args
            assign cap ::temp2 
            ; line 1088
            assign clamped mag 
            ; line 1089
            cmp_gt ::temp0 clamped cap 
            jmpf ::temp0 _label7
            ; line 1090
            assign clamped cap 
            jmp _label8
            ; line 1091
          _label7:
            ineg ::temp2 cap 
            cmp_lt ::temp0 clamped ::temp2 
            jmpf ::temp0 _label8
            ; line 1092
            ineg ::temp2 cap 
            assign clamped ::temp2 
            jmp _label8
            ; line 1094
          _label8:
            callstatic sNRom_Bridge ScaleAward ::temp2 clamped ;1 variable args
            assign magnitude ::temp2 
            ; line 1097
            callmethod ApplyDepth self ::temp2 akActor magnitude asReason True "moment" ;5 variable args
            assign result ::temp2 
            ; line 1098
            callstatic sNRom_Bridge DEPTH_WITHHELD ::temp2 ;0 variable args
            cmp_eq ::temp0 result ::temp2 
            jmpf ::temp0 _label9
            ; line 1099
            callmethod Ledger self ::nonevar akActor "withheld" asActivity magnitude 1 asReason ;6 variable args
            ; line 1100
            return None 
            jmp _label9
            ; line 1111
          _label9:
            cmp_lte ::temp0 result 0 
            jmpf ::temp0 _label10
            ; line 1112
            callstatic sNRom_Bridge LOG_ERROR ::temp2 ;0 variable args
            cast ::temp4 magnitude 
            strcat ::temp4 "Could not write " ::temp4 
            strcat ::temp4 ::temp4 " pts for " 
            ; line 1113
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 " - their points could not be brought over from Romantasy " 
            strcat ::temp3 ::temp3 "(see the line above). Award LOST, no ledger row written." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 1115
            return None 
            jmp _label10
            ; line 1125
          _label10:
            assign moved "" 
            ; line 1126
            cmp_eq ::temp0 clamped mag 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label11
            ; line 1127
            cast ::temp3 mag 
            strcat ::temp3 " (model asked " ::temp3 
            strcat ::temp3 ::temp3 ", capped at " 
            cast ::temp4 cap 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ")" 
            assign moved ::temp4 
            jmp _label11
            ; line 1129
          _label11:
            cmp_eq ::temp0 magnitude clamped 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label12
            ; line 1130
            strcat ::temp4 moved " -> " 
            cast ::temp3 magnitude 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 " applied (Bond Pace: " 
            ; line 1131
            callstatic sNRom_Bridge CFG ::temp4 ;0 variable args
            callstatic skyrimNetApi GetConfigString ::temp4 ::temp4 "bondPace" "Normal" ;3 variable args
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ")" 
            assign moved ::temp4 
            jmp _label12
            ; line 1133
          _label12:
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "Moment for " ::temp4 
            strcat ::temp4 ::temp4 ": " 
            ; line 1134
            cast ::temp3 clamped 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 " pts" 
            strcat ::temp3 ::temp3 moved 
            strcat ::temp3 ::temp3 " - " 
            strcat ::temp3 ::temp3 asReason 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 1136
            callmethod Ledger self ::nonevar akActor "moment" asActivity magnitude 1 asReason ;6 variable args
          .endCode
        .endFunction ;MarkMoment
        .function UnsparkActor
           ; function type 0
          .userFlags 0 ;none
          .docString "Return someone to the PLATONIC ladder without touching bond depth.

      Written 2026-08-04 because five NPCs crossed into romance during the
      period when the first-ever spark assessment ran with an UNBOUNDED window
      - watermark 0.0 meant it judged an NPC's entire history at once, diary
      included, and almost always said yes. The tenure gate fixed that going
      forward; it could do nothing about the ones already across, and nothing
      in the mod could undo a spark at all.

      DEPTH IS DELIBERATELY UNTOUCHED. Points and tier are what they earned
      together and none of that is in question - what is being corrected is the
      KIND of bond, not its size. Dropping points here would punish the NPC for
      our scheduling bug and would also be the one direction that is hard to
      justify to the player, who watched those points accumulate.

      THE WATERMARK RESET IS THE POINT, not an extra. Clearing the flag alone
      just lets them re-cross on the very next assessment, judged once more on
      the same accumulated history that crossed them the first time. Stamping
      SNRom_LastSparkCheck to NOW means the next judgment sees only what
      happens from here - which is the question actually worth asking.

      Safe to call on someone who never sparked; it just resets their window."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local who String
            .local ::temp2 String
            .local was Bool
            .local ::temp3 form
            .local ::temp4 Int
            .local ::temp5 Float
            .local ::nonevar None
            .local ::temp6 Int
            .local ::temp7 String
          .endLocalTable
          .code
            ; line 1162
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 1163
            return None 
            jmp _label1
            ; line 1165
          _label1:
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            assign who ::temp2 
            ; line 1166
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp4 ::temp3 "SNRom_Sparked" 0 ;3 variable args
            cmp_eq ::temp1 ::temp4 1 
            assign was ::temp1 
            ; line 1167
            cast ::temp3 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp3 "SNRom_Sparked" ;2 variable args
            ; line 1168
            cast ::temp3 akActor 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp3 "SNRom_SparkedAt" ;2 variable args
            ; line 1171
            cast ::temp3 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp3 "SNRom_SeedRomantic" ;2 variable args
            ; line 1172
            cast ::temp3 akActor 
            callstatic utility GetCurrentGameTime ::temp5 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp5 ::temp3 "SNRom_LastSparkCheck" ::temp5 ;3 variable args
            ; line 1176
            cast ::temp3 akActor 
            callstatic utility GetCurrentGameTime ::temp5 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp5 ::temp3 "SNRom_EnrolledAt" ::temp5 ;3 variable args
            ; line 1177
            callmethod IEB_WriteRomTrack self ::nonevar akActor ;1 variable args
            ; line 1178
            jmpf was _label2
            ; line 1179
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            strcat ::temp2 "Un-sparked " who 
            strcat ::temp2 ::temp2 " - back on the platonic ladder at tier " 
            ; line 1180
            callstatic sNRom_Bridge TierOf ::temp6 akActor ;1 variable args
            cast ::temp7 ::temp6 
            strcat ::temp7 ::temp2 ::temp7 
            strcat ::temp7 ::temp7 " with points intact. Spark window reset to now; " 
            strcat ::temp7 ::temp7 "the tenure gate must be served again before romance can be judged." 
            callmethod Diag self ::nonevar ::temp4 ::temp7 False ;3 variable args
            jmp _label3
            ; line 1183
          _label2:
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            strcat ::temp7 "Spark window reset for " who 
            strcat ::temp7 ::temp7 " (was not sparked)" 
            callmethod Diag self ::nonevar ::temp4 ::temp7 False ;3 variable args
          _label3
          .endCode
        .endFunction ;UnsparkActor
        .function STANCE_DECLINED
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 1209
            return -1 
          .endCode
        .endFunction ;STANCE_DECLINED
        .function STANCE_UNANSWERED
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 1212
            return 0 
          .endCode
        .endFunction ;STANCE_UNANSWERED
        .function STANCE_ACCEPTED
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 1215
            return 1 
          .endCode
        .endFunction ;STANCE_ACCEPTED
        .function DEPTH_WITHHELD
           ; function type 0
          .userFlags 0 ;none
          .docString "What ApplyDepth returns when the consent gate held an earned award
      short of Lover instead of writing it. Written is 1, refused 0."
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 1239
            return -1 
          .endCode
        .endFunction ;DEPTH_WITHHELD
        .function TierForPoints
           ; function type 0
          .userFlags 0 ;none
          .docString "The tier, 0 Stranger to 5 Spouse, from points. Romantasy's own level
      is exactly this plus one (LevelNumberForPoints in its
      RomanceManager.cpp: 500 points a rung), so every "GetLevel - 1" the
      mod used to write is this function now."
          .return Int
          .paramTable
            .param aiPoints Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 1247
            comp_gte ::temp0 aiPoints 2500 
            jmpf ::temp0 _label0
            ; line 1248
            return 5 
            jmp _label1
            ; line 1249
          _label0:
            comp_gte ::temp0 aiPoints 2000 
            jmpf ::temp0 _label2
            ; line 1250
            return 4 
            jmp _label1
            ; line 1251
          _label2:
            comp_gte ::temp0 aiPoints 1500 
            jmpf ::temp0 _label3
            ; line 1252
            return 3 
            jmp _label1
            ; line 1253
          _label3:
            comp_gte ::temp0 aiPoints 1000 
            jmpf ::temp0 _label4
            ; line 1254
            return 2 
            jmp _label1
            ; line 1255
          _label4:
            comp_gte ::temp0 aiPoints 500 
            jmpf ::temp0 _label1
            ; line 1256
            return 1 
            jmp _label1
            ; line 1258
          _label1:
            return 0 
          .endCode
        .endFunction ;TierForPoints
        .function TierName
           ; function type 0
          .userFlags 0 ;none
          .docString "The rung's name, as Romantasy's GetLevelName spelled it for the same
      points (LevelNameForPoints). The platonic track's own names are the
      dashboard's; this is the ladder the prompts and the log have always
      used."
          .return String
          .paramTable
            .param aiTier Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 1266
            comp_gte ::temp0 aiTier 5 
            jmpf ::temp0 _label0
            ; line 1267
            return "Spouse" 
            jmp _label1
            ; line 1268
          _label0:
            cmp_eq ::temp0 aiTier 4 
            jmpf ::temp0 _label2
            ; line 1269
            return "Lover" 
            jmp _label1
            ; line 1270
          _label2:
            cmp_eq ::temp0 aiTier 3 
            jmpf ::temp0 _label3
            ; line 1271
            return "Confidant" 
            jmp _label1
            ; line 1272
          _label3:
            cmp_eq ::temp0 aiTier 2 
            jmpf ::temp0 _label4
            ; line 1273
            return "Friend" 
            jmp _label1
            ; line 1274
          _label4:
            cmp_eq ::temp0 aiTier 1 
            jmpf ::temp0 _label1
            ; line 1275
            return "Acquaintance" 
            jmp _label1
            ; line 1277
          _label1:
            return "Stranger" 
          .endCode
        .endFunction ;TierName
        .function TierOf
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 Int
          .endLocalTable
          .code
            ; line 1281
            callstatic sNRom_Bridge PointsOf ::temp0 akActor ;1 variable args
            callstatic sNRom_Bridge TierForPoints ::temp0 ::temp0 ;1 variable args
            return ::temp0 
          .endCode
        .endFunction ;TierOf
        .function RomantasyReadable
           ; function type 0
          .userFlags 0 ;none
          .docString "Whether Romantasy may be called at all this session: StartPointsImport
      asked Game.IsPluginInstalled, which cannot fail the way a call to a
      missing native does. EVERY Romantasy call in this mod is behind it."
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 form
            .local ::temp1 Int
            .local ::temp2 Bool
          .endLocalTable
          .code
            ; line 1288
            cast ::temp0 None 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_RomantasyReadable" 0 ;3 variable args
            cmp_eq ::temp2 ::temp1 1 
            return ::temp2 
          .endCode
        .endFunction ;RomantasyReadable
        .function RomantasyPoints
           ; function type 0
          .userFlags 0 ;none
          .docString "THE ONE READ OF ROMANTASY'S NUMBER, for the import and for PointsOf's
      read-through before it. 0 when Romantasy is not installed, without
      calling it."
          .return Int
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 Int
          .endLocalTable
          .code
            ; line 1295
            callstatic sNRom_Bridge RomantasyReadable ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 1296
            return 0 
            jmp _label0
            ; line 1298
          _label0:
            callstatic romantasy GetPoints ::temp1 akActor ;1 variable args
            return ::temp1 
          .endCode
        .endFunction ;RomantasyPoints
        .function PointsImported
           ; function type 0
          .userFlags 0 ;none
          .docString ""
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
            ; line 1302
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_PointsImported" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            assign ::temp1 ::temp1 
          _label0:
            return ::temp1 
          .endCode
        .endFunction ;PointsImported
        .function PointsOf
           ; function type 0
          .userFlags 0 ;none
          .docString "A bond's depth. Ours once the actor is imported.

      BEFORE THE IMPORT, ROMANTASY'S NUMBER where it is installed, read
      through and never written here: until then Romantasy holds the only
      copy, and returning 0 would make every gate think a long bond had just
      begun. The one-time import, or the first change (ApplyDepth), brings
      them over. Without Romantasy, 0 - which the import then adopts."
          .return Int
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
            ; line 1313
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 1314
            return 0 
            jmp _label0
            ; line 1316
          _label0:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_PointsImported" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            jmpf ::temp1 _label1
            ; line 1317
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Points" 0 ;3 variable args
            return ::temp3 
            jmp _label1
            ; line 1319
          _label1:
            callstatic sNRom_Bridge RomantasyPoints ::temp3 akActor ;1 variable args
            return ::temp3 
          .endCode
        .endFunction ;PointsOf
        .function StorePoints
           ; function type 0
          .userFlags 0 ;none
          .docString "THE ONLY WRITE TO SNRom_Points. Callers: ApplyDepth and ImportPoints."
          .return None
          .paramTable
            .param akActor actor
            .param aiPoints Int
          .endParamTable
          .localTable
            .local ::temp0 form
            .local ::temp1 Int
          .endLocalTable
          .code
            ; line 1324
            cast ::temp0 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp0 "SNRom_Points" aiPoints ;3 variable args
          .endCode
        .endFunction ;StorePoints
        .function SyncBondRank
           ; function type 0
          .userFlags 0 ;none
          .docString "SNRom_Bond's rank IS the tier, for everything that reads bond state
      without Papyrus. Called after every write of the points, never between
      a write and its stamp (SetFactionRank waits a frame). Only for the
      enrolled: membership is enrollment, and SetFactionRank would add them."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 faction
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 Int
          .endLocalTable
          .code
            ; line 1332
            cast ::temp0 None 
            cmp_eq ::temp1 _bond ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            callstatic sNRom_Bridge IsEnrolled ::temp1 akActor ;1 variable args
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 1333
            callstatic sNRom_Bridge TierOf ::temp2 akActor ;1 variable args
            callmethod SetFactionRank akActor ::nonevar _bond ::temp2 ;2 variable args
            jmp _label1
            ; line 1336
          _label1:
            callmethod IEB_WriteRomTrack self ::nonevar akActor ;1 variable args
            ; line 1337
            callstatic iEB_RankSync Apply ::nonevar akActor ;1 variable args
          .endCode
        .endFunction ;SyncBondRank
        .function AnnounceTier
           ; function type 0
          .userFlags 0 ;none
          .docString "A bond crossed a tier, up or down. The author's rule (2026-10-01,
      design question 4), in two halves:

      ON SCREEN, FOR THE PLAYER, up and down - but never in combat, in an
      OStim or SexLab scene, or while paused. Worded here and handed to the
      DLL, which holds it until the player can see it (native/src/Notices.h)
      and sends it back to OnShowNotice. Without the DLL, shown at once.

      IN THEIR HEAD, FOR THE CHARACTER ALONE: a private thought
      (SkyrimNetApi.GenerateNPCThought), which surfaces in their own later
      prompts. Nobody nearby hears anything - Romantasy's narration trigger
      is gone. ThoughtHint words it, and says nothing for the changes that
      are not a change of heart.

      The tier is named on the track the player is shown (ShownTierName), so
      a feeling nobody has spoken is not announced as one."
          .return None
          .paramTable
            .param akActor actor
            .param aiFrom Int
            .param aiTo Int
            .param asKind String
            .param asReason String
          .endParamTable
          .localTable
            .local name String
            .local ::temp0 String
            .local tier String
            .local text String
            .local ::temp1 Bool
            .local ::nonevar None
            .local hint String
            .local rc Int
            .local ::temp2 Int
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 1357
            callmethod GetDisplayName akActor ::temp0 ;0 variable args
            assign name ::temp0 
            ; line 1358
            callmethod ShownTierName self ::temp0 akActor aiTo ;2 variable args
            assign tier ::temp0 
            ; line 1359
            assign text "" 
            ; line 1360
            cmp_eq ::temp1 asKind "seed" 
            jmpf ::temp1 _label0
            ; line 1361
            strcat ::temp0 "Your history with " name 
            strcat ::temp0 ::temp0 " reads as " 
            strcat ::temp0 ::temp0 tier 
            assign text ::temp0 
            jmp _label1
            ; line 1362
          _label0:
            cmp_gt ::temp1 aiTo aiFrom 
            jmpf ::temp1 _label2
            ; line 1363
            strcat ::temp0 "Your bond with " name 
            strcat ::temp0 ::temp0 " deepened: " 
            strcat ::temp0 ::temp0 tier 
            assign text ::temp0 
            jmp _label1
            ; line 1365
          _label2:
            strcat ::temp0 "Your bond with " name 
            strcat ::temp0 ::temp0 " cooled: " 
            strcat ::temp0 ::temp0 tier 
            assign text ::temp0 
            ; line 1367
          _label1:
            comp_gte ::temp1 _dashNatives 5 
            jmpf ::temp1 _label3
            ; line 1368
            callstatic sNRom_Native Announce ::nonevar text ;1 variable args
            jmp _label4
            ; line 1370
          _label3:
            callstatic debug Notification ::nonevar text ;1 variable args
            ; line 1372
          _label4:
            cmp_gt ::temp1 aiTo aiFrom 
            callmethod ThoughtHint self ::temp0 asKind ::temp1 asReason ;3 variable args
            assign hint ::temp0 
            ; line 1373
            cmp_eq ::temp1 hint "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label5
            ; line 1374
            callstatic skyrimNetApi GenerateNPCThought ::temp2 akActor hint ;2 variable args
            assign rc ::temp2 
            ; line 1375
            cmp_eq ::temp1 rc 0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label6
            ; line 1376
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            strcat ::temp0 "Tier thought for " name 
            strcat ::temp0 ::temp0 " was not generated (rc=" 
            cast ::temp3 rc 
            strcat ::temp3 ::temp0 ::temp3 
            strcat ::temp3 ::temp3 "); the change stands, only the private thought is missing." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 True ;3 variable args
            jmp _label6
          _label6:
            jmp _label5
            ; line 1382
          _label5:
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            cast ::temp3 aiFrom 
            strcat ::temp3 "Tier " ::temp3 
            strcat ::temp3 ::temp3 " -> " 
            cast ::temp0 aiTo 
            strcat ::temp0 ::temp3 ::temp0 
            strcat ::temp0 ::temp0 " for " 
            strcat ::temp0 ::temp0 name 
            strcat ::temp0 ::temp0 " (" 
            strcat ::temp0 ::temp0 asKind 
            strcat ::temp0 ::temp0 "): '" 
            strcat ::temp0 ::temp0 text 
            strcat ::temp0 ::temp0 "'" 
            callmethod Diag self ::nonevar ::temp2 ::temp0 True ;3 variable args
          .endCode
        .endFunction ;AnnounceTier
        .function ShownTierName
           ; function type 0
          .userFlags 0 ;none
          .docString "The tier's name on the track the PLAYER is shown, by the dashboard's
      rule (native/src/Model.cpp, Track): the romantic ladder only for a
      mutual romance or a recorded engagement or marriage; the friendship
      ladder otherwise - including for a feeling nobody has spoken. Reads
      MARAS and the applicability, which wait for frames: only on a tier
      change."
          .return String
          .paramTable
            .param akActor actor
            .param aiTier Int
          .endParamTable
          .localTable
            .local romantic Bool
            .local ::temp0 Int
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 1392
            assign romantic False 
            ; line 1393
            callstatic sNRom_Decorators RomanceApplicability ::temp0 akActor -1 ;2 variable args
            cmp_eq ::temp1 ::temp0 0 
            jmpf ::temp1 _label0
            ; line 1394
            callstatic sNRom_Decorators IsSparked ::temp1 akActor ;1 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            ; line 1395
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp0 ::temp2 "SNRom_PlayerStance" 0 ;3 variable args
            callstatic sNRom_Bridge STANCE_ACCEPTED ::temp3 ;0 variable args
            cmp_eq ::temp1 ::temp0 ::temp3 
            assign ::temp1 ::temp1 
          _label1:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label2
            ; line 1396
            callstatic sNRom_Bridge CommitmentState ::temp3 akActor ;1 variable args
            comp_gte ::temp1 ::temp3 2 
            assign ::temp1 ::temp1 
          _label2:
            assign romantic ::temp1 
            jmp _label0
            ; line 1398
          _label0:
            jmpf romantic _label3
            ; line 1399
            callstatic sNRom_Bridge TierName ::temp4 aiTier ;1 variable args
            return ::temp4 
            jmp _label3
            ; line 1401
          _label3:
            comp_gte ::temp1 aiTier 5 
            jmpf ::temp1 _label4
            ; line 1402
            return "Best Friend" 
            jmp _label5
            ; line 1403
          _label4:
            cmp_eq ::temp1 aiTier 4 
            jmpf ::temp1 _label5
            ; line 1404
            return "Ally" 
            jmp _label5
            ; line 1406
          _label5:
            callstatic sNRom_Bridge TierName ::temp4 aiTier ;1 variable args
            return ::temp4 
          .endCode
        .endFunction ;ShownTierName
        .function ThoughtHint
           ; function type 0
          .userFlags 0 ;none
          .docString "What the character privately notices when their bond crosses a tier, or
      "" for no thought: a seed or an import is a reading, not a change of
      heart; a spark has its own thought (ApplySpark); a marriage is its own
      event. No tier names - those are the player's bookkeeping, not how
      anyone thinks of someone."
          .return String
          .paramTable
            .param asKind String
            .param abUp Bool
            .param asReason String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local player String
            .local ::temp1 actor
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 1415
            cmp_eq ::temp0 asKind "seed" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cmp_eq ::temp0 asKind "import" 
            assign ::temp0 ::temp0 
          _label0:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label1
            cmp_eq ::temp0 asKind "spark" 
            assign ::temp0 ::temp0 
          _label1:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label2
            cmp_eq ::temp0 asKind "married" 
            assign ::temp0 ::temp0 
          _label2:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label3
            ; line 1416
            cmp_eq ::temp0 asKind "ceiling" 
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 1417
            return "" 
            jmp _label4
            ; line 1419
          _label4:
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName ::temp1 ::temp2 ;0 variable args
            assign player ::temp2 
            ; line 1420
            cmp_eq ::temp0 asKind "accepted" 
            jmpf ::temp0 _label5
            ; line 1421
            strcat ::temp2 player " has said yes to what is between you. Let it settle in: you are not only hoping now." 
            return ::temp2 
            jmp _label6
            ; line 1422
          _label5:
            cmp_eq ::temp0 asKind "declined" 
            jmpf ::temp0 _label7
            ; line 1423
            strcat ::temp2 player " has turned you down. It stings, and you hold yourself a little further off than you did." 
            return ::temp2 
            jmp _label6
            ; line 1424
          _label7:
            cmp_eq ::temp0 asKind "ended" 
            jmpf ::temp0 _label8
            ; line 1425
            strcat ::temp2 "It is over between you and " player 
            strcat ::temp2 ::temp2 ". " 
            strcat ::temp2 ::temp2 asReason 
            return ::temp2 
            jmp _label6
            ; line 1426
          _label8:
            cmp_eq ::temp0 asKind "released" 
            jmpf ::temp0 _label6
            ; line 1427
            jmpf abUp _label9
            ; line 1428
            strcat ::temp2 "You realise " player 
            strcat ::temp2 ::temp2 " has come to matter more to you than before." 
            return ::temp2 
            jmp _label9
            ; line 1430
          _label9:
            return "" 
            jmp _label6
            ; line 1432
          _label6:
            jmpf abUp _label10
            ; line 1433
            strcat ::temp2 "You realise " player 
            strcat ::temp2 ::temp2 " has come to matter more to you than before. What brought it home: " 
            strcat ::temp2 ::temp2 asReason 
            return ::temp2 
            jmp _label10
            ; line 1435
          _label10:
            strcat ::temp2 "Something has cooled between you and " player 
            strcat ::temp2 ::temp2 "; you hold them a little further off than you did. " 
            strcat ::temp2 ::temp2 "What did it: " 
            ; line 1436
            strcat ::temp2 ::temp2 asReason 
            return ::temp2 
          .endCode
        .endFunction ;ThoughtHint
        .function OnShowNotice
           ; function type 0
          .userFlags 0 ;none
          .docString "The DLL's go-ahead for a held tier notice (AnnounceTier): the player is
      out of combat, out of a scene and not paused."
          .return None
          .paramTable
            .param asEventName String
            .param asText String
            .param afNumArg Float
            .param akSender form
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1442
            cmp_eq ::temp0 asText "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 1443
            callstatic debug Notification ::nonevar asText ;1 variable args
            jmp _label0
          _label0
          .endCode
        .endFunction ;OnShowNotice
        .function RecordHistory
           ; function type 0
          .userFlags 0 ;none
          .docString "One change to a bond, for the dashboard's history: kept by the DLL in
      the co-save, so it rolls back with the save (native/src/History.h).
      Called by ApplyDepth and ImportPoints only. One native, callable from
      tasklets, so it does not wait a frame. Without the DLL nothing is kept,
      and nothing else depends on it."
          .return None
          .paramTable
            .param akActor actor
            .param asKind String
            .param aiDelta Int
            .param aiTotal Int
            .param asReason String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1453
            comp_gte ::temp0 _dashNatives 5 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 akActor ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 1454
            callstatic sNRom_Native RecordChange ::nonevar akActor asKind aiDelta aiTotal asReason ;5 variable args
            jmp _label1
          _label1
          .endCode
        .endFunction ;RecordHistory
        .function JoinBondFaction
           ; function type 0
          .userFlags 0 ;none
          .docString "Enrollment's mark on the actor itself: into SNRom_Bond, at their tier.
      The caller sets SNRom_Enrolled, which is what the mod reads."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 faction
            .local ::temp1 Bool
            .local ::temp2 actor
            .local ::nonevar None
            .local ::temp3 Int
          .endLocalTable
          .code
            ; line 1461
            cast ::temp0 None 
            cmp_eq ::temp1 _bond ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cast ::temp2 None 
            cmp_eq ::temp1 akActor ::temp2 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 1462
            return None 
            jmp _label1
            ; line 1464
          _label1:
            callmethod AddToFaction akActor ::nonevar _bond ;1 variable args
            ; line 1465
            callstatic sNRom_Bridge TierOf ::temp3 akActor ;1 variable args
            callmethod SetFactionRank akActor ::nonevar _bond ::temp3 ;2 variable args
          .endCode
        .endFunction ;JoinBondFaction
        .function ImportPoints
           ; function type 0
          .userFlags 0 ;none
          .docString "Make one actor's points ours, and stamp them (design 8.4).

      WITH ROMANTASY: copied exactly. Verified before the stamp: ours read
      back, and Romantasy read again, must both equal what was copied. A
      mismatch is an ERROR and leaves them unstamped, still reading
      Romantasy's number, to be tried again.

      WITHOUT IT: adopted at 0, and unseeded, so the next seed reads them
      from their history instead (8.3: "the playthrough is simply un-migrated
      and everyone is seeded from the record"). For someone enrolled in 2.0,
      who never had Romantasy points, that is simply where a bond starts.

      Returns True when they are ours, including already."
          .return Bool
          .paramTable
            .param akActor actor
            .param asWhen String
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 form
            .local ::temp3 Int
            .local ::temp4 String
            .local theirs Int
            .local again Int
            .local ::temp5 String
            .local ours Int
          .endLocalTable
          .code
            ; line 1482
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 1483
            return False 
            jmp _label0
            ; line 1485
          _label0:
            callstatic sNRom_Bridge PointsImported ::temp1 akActor ;1 variable args
            jmpf ::temp1 _label1
            ; line 1486
            return True 
            jmp _label1
            ; line 1488
          _label1:
            callstatic sNRom_Bridge RomantasyReadable ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 1489
            callmethod StorePoints self ::nonevar akActor 0 ;2 variable args
            ; line 1490
            cast ::temp2 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_PointsImported" 1 ;3 variable args
            ; line 1491
            cast ::temp2 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp2 "SNRom_Seeded" ;2 variable args
            ; line 1492
            callmethod SyncBondRank self ::nonevar akActor ;1 variable args
            ; line 1496
            cmp_eq ::temp1 asWhen "in the one-time import" 
            jmpf ::temp1 _label3
            ; line 1497
            callmethod RecordHistory self ::nonevar akActor "import" 0 0 "Started over: Romantasy was not installed" ;5 variable args
            ; line 1498
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 ::temp4 "'s points start from 0 " 
            strcat ::temp4 ::temp4 asWhen 
            strcat ::temp4 ::temp4 " (no Romantasy to bring them from); the next seed reads them from their history." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 True ;3 variable args
            ; line 1500
            callmethod LedgerRow self ::nonevar akActor "import" "" 0 1 "Started from 0 without Romantasy" ;6 variable args
            jmp _label4
            ; line 1502
          _label3:
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 ::temp4 "'s bond starts at 0 pts." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 True ;3 variable args
            ; line 1504
          _label4:
            return True 
            jmp _label2
            ; line 1513
          _label2:
            callstatic sNRom_Bridge RomantasyPoints ::temp3 akActor ;1 variable args
            assign theirs ::temp3 
            ; line 1514
            callstatic sNRom_Bridge RomantasyPoints ::temp3 akActor ;1 variable args
            assign again ::temp3 
            ; line 1515
            callstatic sNRom_Bridge PointsImported ::temp1 akActor ;1 variable args
            jmpf ::temp1 _label5
            ; line 1516
            return True 
            jmp _label5
            ; line 1518
          _label5:
            cmp_eq ::temp1 again theirs 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label6
            ; line 1519
            callstatic sNRom_Bridge LOG_ERROR ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "Import of " ::temp4 
            strcat ::temp4 ::temp4 " did not verify: Romantasy read " 
            ; line 1520
            cast ::temp5 theirs 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 " then " 
            cast ::temp4 again 
            strcat ::temp4 ::temp5 ::temp4 
            strcat ::temp4 ::temp4 " while it was being copied. Left unstamped; tried again next time." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
            ; line 1521
            return False 
            jmp _label6
            ; line 1523
          _label6:
            callmethod StorePoints self ::nonevar akActor theirs ;2 variable args
            ; line 1524
            cast ::temp2 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_PointsImported" 1 ;3 variable args
            ; line 1525
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Points" -1 ;3 variable args
            assign ours ::temp3 
            ; line 1526
            cmp_eq ::temp1 ours theirs 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label7
            ; line 1527
            cast ::temp2 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp2 "SNRom_PointsImported" ;2 variable args
            ; line 1528
            callstatic sNRom_Bridge LOG_ERROR ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "Import of " ::temp4 
            strcat ::temp4 ::temp4 " did not verify: wrote " 
            cast ::temp5 theirs 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 ", read back " 
            ; line 1529
            cast ::temp4 ours 
            strcat ::temp4 ::temp5 ::temp4 
            strcat ::temp4 ::temp4 ". Left unstamped; tried again next time." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
            ; line 1530
            return False 
            jmp _label7
            ; line 1532
          _label7:
            callmethod SyncBondRank self ::nonevar akActor ;1 variable args
            ; line 1535
            cmp_gt ::temp1 theirs 0 
            jmpf ::temp1 _label8
            ; line 1536
            callmethod RecordHistory self ::nonevar akActor "import" theirs theirs "Brought over from Romantasy" ;5 variable args
            jmp _label8
            ; line 1541
          _label8:
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "Brought " ::temp4 
            strcat ::temp4 ::temp4 " over " 
            strcat ::temp4 ::temp4 asWhen 
            strcat ::temp4 ::temp4 ": Romantasy " 
            ; line 1542
            cast ::temp5 theirs 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 " -> ours " 
            cast ::temp4 ours 
            strcat ::temp4 ::temp5 ::temp4 
            strcat ::temp4 ::temp4 " pts." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 True ;3 variable args
            ; line 1543
            callmethod LedgerRow self ::nonevar akActor "import" "" theirs 1 "Brought over from Romantasy" ;6 variable args
            ; line 1544
            return True 
          .endCode
        .endFunction ;ImportPoints
        .function ApplyDepth
           ; function type 0
          .userFlags 0 ;none
          .docString "THE ONE PLACE A BOND'S DEPTH CHANGES (design 9.1). Every award, seed,
      release, setback and clamp comes through here, and nothing else
      writes SNRom_Points.

      THE CONSENT GATE LIVES HERE, FOR EVERY INCREASE (2.0, design 9.2):
      HoldShortOfLover withholds and banks anything that would carry an
      unanswered romance into Lover, and this returns DEPTH_WITHHELD instead
      of writing. In 1.x it guarded earned awards only, with a reactive
      ceiling behind it for the rest - Romantasy's own scoring among them -
      and that ceiling's clawbacks were the splashes and refusals 2.0 set out
      to end. With every write here, one preventive check covers them all.
      The single exception is a marriage ("married"): the proposal and its
      acceptance ARE the answer.

      abShowLevelUp: whether a tier this change crosses is announced - on
      screen when the player can see it, and to the character alone as a
      private thought (AnnounceTier).

      asKind: what happened, in one word ("moment", "talk", "seed"...), for
      the bond's history (RecordHistory): every change that lands, and every
      earned award the gate withholds, is recorded here, so the history can
      never miss one the way the ledger missed seeds and marriages.

      NEVER REFUSED FOR WHERE SOMEONE IS. The one refusal is an actor whose
      Romantasy points could not be verified mid-copy (ImportPoints), because
      writing 0 plus the change would lose what Romantasy holds.

      Returns 1 written, DEPTH_WITHHELD, or 0 refused."
          .return Int
          .paramTable
            .param akActor actor
            .param aiDelta Int
            .param asReason String
            .param abShowLevelUp Bool
            .param asKind String
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 form
            .local ::temp3 Int
            .local was Int
            .local now Int
            .local fromTier Int
            .local toTier Int
          .endLocalTable
          .code
            ; line 1576
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 1577
            return 0 
            jmp _label0
            ; line 1579
          _label0:
            callstatic sNRom_Bridge PointsImported ::temp1 akActor ;1 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            callmethod ImportPoints self ::temp1 akActor "at its first change" ;2 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 1580
            return 0 
            jmp _label2
            ; line 1582
          _label2:
            cmp_eq ::temp1 asKind "married" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label3
            callmethod HoldShortOfLover self ::temp1 akActor aiDelta ;2 variable args
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 1583
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Points" 0 ;3 variable args
            callmethod RecordHistory self ::nonevar akActor "withheld" aiDelta ::temp3 asReason ;5 variable args
            ; line 1584
            callstatic sNRom_Bridge DEPTH_WITHHELD ::temp3 ;0 variable args
            return ::temp3 
            jmp _label4
            ; line 1586
          _label4:
            cmp_eq ::temp1 aiDelta 0 
            jmpf ::temp1 _label5
            ; line 1587
            return 1 
            jmp _label5
            ; line 1590
          _label5:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Points" 0 ;3 variable args
            assign was ::temp3 
            ; line 1591
            iadd ::temp3 was aiDelta 
            assign now ::temp3 
            ; line 1592
            cmp_lt ::temp1 now 0 
            jmpf ::temp1 _label6
            ; line 1593
            assign now 0 
            jmp _label6
            ; line 1595
          _label6:
            callmethod StorePoints self ::nonevar akActor now ;2 variable args
            ; line 1596
            callmethod SyncBondRank self ::nonevar akActor ;1 variable args
            ; line 1597
            cmp_eq ::temp1 now was 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label7
            ; line 1598
            isub ::temp3 now was 
            callmethod RecordHistory self ::nonevar akActor asKind ::temp3 now asReason ;5 variable args
            ; line 1599
            callstatic sNRom_Bridge TierForPoints ::temp3 was ;1 variable args
            assign fromTier ::temp3 
            ; line 1600
            callstatic sNRom_Bridge TierForPoints ::temp3 now ;1 variable args
            assign toTier ::temp3 
            ; line 1601
            assign ::temp1 abShowLevelUp 
            jmpf ::temp1 _label8
            cmp_eq ::temp1 fromTier toTier 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label8:
            jmpf ::temp1 _label9
            ; line 1602
            callmethod AnnounceTier self ::nonevar akActor fromTier toTier asKind asReason ;5 variable args
            jmp _label9
          _label9:
            jmp _label7
            ; line 1605
          _label7:
            return 1 
          .endCode
        .endFunction ;ApplyDepth
        .function StartPointsImport
           ; function type 0
          .userFlags 0 ;none
          .docString "Bootstrap. The two one-time passes a save needs on its way to 2.0, on
      their own stack via a ModEvent, so a large roster never holds up the
      rest of the bootstrap (OnImportPoints). Also records whether Romantasy
      can be read at all this session (RomantasyReadable).

      POINTS ONLY. Romantasy's likes and dislikes are not brought over: they
      name game statistics ("Dungeons Cleared"), routing on them fired once in
      180 awards (design 4.0), and phase 5 re-authors everyone's preferences
      against our own vocabulary. The author decided 2026-09-30 that nothing
      of Romantasy's preferences carries into Relationships."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local readable Bool
            .local ::temp0 faction
            .local ::temp1 faction
            .local ::temp2 Bool
            .local ::temp3 Int
            .local ::temp4 form
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1623
            callstatic sNRom_Bridge RomantasyFaction ::temp0 ;0 variable args
            cast ::temp1 None 
            cmp_eq ::temp2 ::temp0 ::temp1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label0
            callstatic romantasy GetApiVersion ::temp3 ;0 variable args
            cmp_gt ::temp2 ::temp3 0 
            assign ::temp2 ::temp2 
          _label0:
            assign readable ::temp2 
            ; line 1624
            cast ::temp4 None 
            cast ::temp3 readable 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "SNRom_RomantasyReadable" ::temp3 ;3 variable args
            ; line 1625
            cast ::temp4 None 
            callstatic storageUtil GetIntValue ::temp3 ::temp4 "SNRom_Migrated" 0 ;3 variable args
            cmp_eq ::temp2 ::temp3 1 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label1
            ; line 1626
            cast ::temp4 None 
            callstatic storageUtil GetIntValue ::temp3 ::temp4 "SNRom_BondFactionPass" 0 ;3 variable args
            cmp_eq ::temp2 ::temp3 1 
            assign ::temp2 ::temp2 
          _label1:
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label2
            ; line 1627
            cast ::temp4 None 
            callstatic storageUtil GetIntValue ::temp3 ::temp4 "SNRom_AuthoredFlagPass" 0 ;3 variable args
            cmp_eq ::temp2 ::temp3 1 
            assign ::temp2 ::temp2 
          _label2:
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label3
            ; line 1628
            cast ::temp4 None 
            callstatic storageUtil GetIntValue ::temp3 ::temp4 "SNRom_LoverLinePass" 0 ;3 variable args
            cmp_eq ::temp2 ::temp3 1 
            assign ::temp2 ::temp2 
          _label3:
            jmpf ::temp2 _label4
            ; line 1629
            return None 
            jmp _label4
            ; line 1631
          _label4:
            callmethod SendModEvent self ::nonevar "SNRom_ImportPoints" "" 0.0 ;3 variable args
          .endCode
        .endFunction ;StartPointsImport
        .function OnImportPoints
           ; function type 0
          .userFlags 0 ;none
          .docString "The one-time passes, in order: the points import (ImportEveryone), the
      move into SNRom_Bond (MoveToBondFaction), and the repair of the
      authored flag (RepairAuthoredFlags). Each is stamped only when it
      finished, so an interrupted one resumes on the next load."
          .return None
          .paramTable
            .param asEventName String
            .param asStrArg String
            .param afNumArg Float
            .param akSender form
          .endParamTable
          .localTable
            .local ::temp0 form
            .local ::temp1 Int
            .local ::temp2 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1639
            jmpf _importing _label0
            ; line 1640
            return None 
            jmp _label0
            ; line 1642
          _label0:
            assign _importing True 
            ; line 1643
            cast ::temp0 None 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_Migrated" 0 ;3 variable args
            cmp_eq ::temp2 ::temp1 1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label1
            ; line 1644
            callmethod ImportEveryone self ::nonevar ;0 variable args
            jmp _label1
            ; line 1646
          _label1:
            cast ::temp0 None 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_BondFactionPass" 0 ;3 variable args
            cmp_eq ::temp2 ::temp1 1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label2
            ; line 1647
            callmethod MoveToBondFaction self ::nonevar ;0 variable args
            jmp _label2
            ; line 1649
          _label2:
            cast ::temp0 None 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_AuthoredFlagPass" 0 ;3 variable args
            cmp_eq ::temp2 ::temp1 1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label3
            ; line 1650
            callmethod RepairAuthoredFlags self ::nonevar ;0 variable args
            jmp _label3
            ; line 1653
          _label3:
            cast ::temp0 None 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_LoverLinePass" 0 ;3 variable args
            cmp_eq ::temp2 ::temp1 1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label4
            ; line 1654
            cast ::temp0 None 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_Migrated" 0 ;3 variable args
            cmp_eq ::temp2 ::temp1 1 
            assign ::temp2 ::temp2 
          _label4:
            jmpf ::temp2 _label5
            ; line 1655
            callmethod RestoreLoverLine self ::nonevar ;0 variable args
            jmp _label5
            ; line 1657
          _label5:
            assign _importing False 
          .endCode
        .endFunction ;OnImportPoints
        .function ImportEveryone
           ; function type 0
          .userFlags 0 ;none
          .docString "The one-time import itself (design 8.4). Resumable, never repeated:
      whoever is already stamped is skipped, and SNRom_Migrated - written
      only once every roster member is stamped and verified - stops
      it running on any save made afterwards.

      A save made BEFORE the import has no stamp and genuinely has not been
      brought over, so it is, once, from its own numbers. The playthrough's
      store remembers an import happened, which is how its notification says
      "an older save" rather than looking like a repeat.

      WITHOUT ROMANTASY everyone is adopted at 0 and re-read from their
      history as the seed reaches them (ImportPoints). Loud, because the only
      way back is a save from before it, loaded with Romantasy installed."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local readable Bool
            .local ::temp0 Bool
            .local n Int
            .local ::temp1 form
            .local ::temp2 Int
            .local brought Int
            .local already Int
            .local failed Int
            .local skipped Int
            .local i Int
            .local a actor
            .local ::temp3 actor
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 String
            .local store String
            .local before Bool
            .local total Int
          .endLocalTable
          .code
            ; line 1674
            callstatic sNRom_Bridge RomantasyReadable ::temp0 ;0 variable args
            assign readable ::temp0 
            ; line 1675
            cast ::temp1 None 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "SNRom_Roster" ;2 variable args
            assign n ::temp2 
            ; line 1676
            assign brought 0 
            ; line 1677
            assign already 0 
            ; line 1678
            assign failed 0 
            ; line 1679
            assign skipped 0 
            ; line 1680
            assign i 0 
            ; line 1681
          _label5:
            cmp_lt ::temp0 i n 
            jmpf ::temp0 _label0
            ; line 1682
            cast ::temp1 None 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "SNRom_Roster" i ;3 variable args
            cast ::temp3 ::temp1 
            assign a ::temp3 
            ; line 1686
            cast ::temp3 None 
            cmp_eq ::temp0 a ::temp3 
            jmpf ::temp0 _label1
            ; line 1687
            iadd ::temp2 skipped 1 
            assign skipped ::temp2 
            jmp _label2
            ; line 1688
          _label1:
            callstatic sNRom_Bridge PointsImported ::temp0 a ;1 variable args
            jmpf ::temp0 _label3
            ; line 1689
            iadd ::temp2 already 1 
            assign already ::temp2 
            jmp _label2
            ; line 1690
          _label3:
            callmethod ImportPoints self ::temp0 a "in the one-time import" ;2 variable args
            jmpf ::temp0 _label4
            ; line 1691
            iadd ::temp2 brought 1 
            assign brought ::temp2 
            jmp _label2
            ; line 1693
          _label4:
            iadd ::temp2 failed 1 
            assign failed ::temp2 
            ; line 1695
          _label2:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label5
            ; line 1697
          _label0:
            cmp_gt ::temp0 failed 0 
            jmpf ::temp0 _label6
            ; line 1698
            callstatic sNRom_Bridge LOG_ERROR ::temp2 ;0 variable args
            cast ::temp4 failed 
            strcat ::temp4 "Import incomplete: " ::temp4 
            strcat ::temp4 ::temp4 " did not verify and keep reading " 
            strcat ::temp4 ::temp4 "Romantasy's number until the next load tries again. " 
            ; line 1699
            cast ::temp5 brought 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 " brought over." 
            callmethod Diag self ::nonevar ::temp2 ::temp5 False ;3 variable args
            ; line 1700
            return None 
            jmp _label6
            ; line 1702
          _label6:
            cast ::temp1 None 
            callstatic storageUtil SetIntValue ::temp2 ::temp1 "SNRom_Migrated" 1 ;3 variable args
            ; line 1703
            callstatic sNRom_Bridge StoreFile ::temp5 ;0 variable args
            assign store ::temp5 
            ; line 1704
            callstatic jsonUtil GetIntValue ::temp2 store "SNRom_PointsImportedOnce" 0 ;3 variable args
            cmp_eq ::temp0 ::temp2 1 
            assign before ::temp0 
            ; line 1705
            callstatic jsonUtil SetIntValue ::temp2 store "SNRom_PointsImportedOnce" 1 ;3 variable args
            ; line 1706
            callstatic jsonUtil Save ::temp0 store False ;2 variable args
            ; line 1707
            iadd ::temp2 brought already 
            assign total ::temp2 
            ; line 1708
            not ::temp0 readable 
            jmpf ::temp0 _label7
            ; line 1709
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            cast ::temp5 brought 
            strcat ::temp5 "Import done WITHOUT Romantasy: " ::temp5 
            strcat ::temp5 ::temp5 " start from 0 and are re-read " 
            strcat ::temp5 ::temp5 "from their history as the seed reaches them; " 
            ; line 1710
            cast ::temp4 already 
            strcat ::temp4 ::temp5 ::temp4 
            strcat ::temp4 ::temp4 " were already ours, " 
            cast ::temp5 skipped 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 " skipped (no longer in the game). To bring Romantasy's points over instead, load a save " 
            ; line 1711
            strcat ::temp5 ::temp5 "from before this one with Romantasy installed." 
            callmethod Diag self ::nonevar ::temp2 ::temp5 False ;3 variable args
            ; line 1713
            cmp_gt ::temp0 brought 0 
            jmpf ::temp0 _label8
            ; line 1714
            cast ::temp5 brought 
            strcat ::temp5 "Romantasy isn't installed, so " ::temp5 
            strcat ::temp5 ::temp5 " companions start over and are re-read from their history." 
            callmethod Say self ::nonevar ::temp5 ;1 variable args
            jmp _label8
            ; line 1716
          _label8:
            return None 
            jmp _label7
            ; line 1718
          _label7:
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            cast ::temp5 brought 
            strcat ::temp5 "Import done: " ::temp5 
            strcat ::temp5 ::temp5 " brought over, " 
            cast ::temp4 already 
            strcat ::temp4 ::temp5 ::temp4 
            strcat ::temp4 ::temp4 " already ours, " 
            ; line 1719
            cast ::temp5 skipped 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 " skipped (no longer in the game). Nobody brought over is read from Romantasy again; " 
            strcat ::temp5 ::temp5 "anyone enrolled later is brought over at their first change." 
            callmethod Diag self ::nonevar ::temp2 ::temp5 False ;3 variable args
            ; line 1721
            cmp_gt ::temp0 brought 0 
            jmpf ::temp0 _label9
            ; line 1722
            jmpf before _label10
            ; line 1723
            cast ::temp5 total 
            strcat ::temp5 "An older save: brought " ::temp5 
            strcat ::temp5 ::temp5 " companions over from Romantasy, from this save's own points." 
            callmethod Say self ::nonevar ::temp5 ;1 variable args
            jmp _label11
            ; line 1725
          _label10:
            cast ::temp5 total 
            strcat ::temp5 "Brought " ::temp5 
            strcat ::temp5 ::temp5 " companions over from Romantasy." 
            callmethod Say self ::nonevar ::temp5 ;1 variable args
          _label11:
            jmp _label9
          _label9
          .endCode
        .endFunction ;ImportEveryone
        .function RestoreLoverLine
           ; function type 0
          .userFlags 0 ;none
          .docString "ONE-TIME (SNRom_LoverLinePass), for a save from 1.x: puts any
      unanswered romance standing above the Lover line back on it, holding
      the difference for the answer exactly as the gate does.

      1.x pulled such a bond back with a reactive ceiling after Romantasy's own
      scoring carried it over - and Romantasy refused the pull-back for anyone
      not following, hundreds of times for Iddra and Irgnir. So a 1.x save can
      arrive with an unanswered romance at Lover, the one crossing the
      question exists to govern. From 2.0 nothing can carry one over
      (ApplyDepth withholds), so once is enough.

      A declined companion past the line is reopened first, as the gate does,
      so the question comes back to them as it would have."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local n Int
            .local ::temp0 form
            .local ::temp1 Int
            .local restored Int
            .local i Int
            .local ::temp2 Bool
            .local a actor
            .local ::temp3 actor
            .local ::temp4 Int
            .local sparked Bool
            .local over Int
            .local ::temp5 form
            .local ::nonevar None
            .local ::temp6 String
            .local ::temp7 String
          .endLocalTable
          .code
            ; line 1744
            cast ::temp0 None 
            callstatic storageUtil FormListCount ::temp1 ::temp0 "SNRom_Roster" ;2 variable args
            assign n ::temp1 
            ; line 1745
            assign restored 0 
            ; line 1746
            assign i 0 
            ; line 1747
          _label8:
            cmp_lt ::temp2 i n 
            jmpf ::temp2 _label0
            ; line 1748
            cast ::temp0 None 
            callstatic storageUtil FormListGet ::temp0 ::temp0 "SNRom_Roster" i ;3 variable args
            cast ::temp3 ::temp0 
            assign a ::temp3 
            ; line 1749
            cast ::temp3 None 
            cmp_eq ::temp2 a ::temp3 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label1
            callstatic sNRom_Bridge PointsOf ::temp1 a ;1 variable args
            callstatic sNRom_Bridge UNANSWERED_MAX ::temp4 ;0 variable args
            cmp_gt ::temp2 ::temp1 ::temp4 
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 1750
            callmethod ReopenIfClimbedBack self ::temp2 a 0 ;2 variable args
            ; line 1751
            callstatic sNRom_Decorators IsSparked ::temp2 a ;1 variable args
            assign sparked ::temp2 
            ; line 1752
            cast ::temp0 a 
            callstatic storageUtil GetIntValue ::temp4 ::temp0 "SNRom_PlayerStance" 0 ;3 variable args
            callstatic sNRom_Bridge STANCE_UNANSWERED ::temp1 ;0 variable args
            cmp_eq ::temp2 ::temp4 ::temp1 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label3
            ; line 1753
            assign ::temp2 sparked 
            jmpt ::temp2 _label4
            callstatic sNRom_Bridge SparkDecided ::temp2 a ;1 variable args
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label4:
            assign ::temp2 ::temp2 
          _label3:
            jmpf ::temp2 _label5
            ; line 1754
            callstatic sNRom_Bridge PointsOf ::temp1 a ;1 variable args
            callstatic sNRom_Bridge UNANSWERED_MAX ::temp4 ;0 variable args
            isub ::temp4 ::temp1 ::temp4 
            assign over ::temp4 
            ; line 1757
            ineg ::temp4 over 
            callmethod ApplyDepth self ::temp4 a ::temp4 "Held at the Lover line until you answer" False "ceiling" ;5 variable args
            cmp_gt ::temp2 ::temp4 0 
            jmpf ::temp2 _label6
            ; line 1758
            cast ::temp0 a 
            ; line 1759
            cast ::temp5 a 
            callstatic storageUtil GetIntValue ::temp4 ::temp5 "SNRom_BankedPoints" 0 ;3 variable args
            iadd ::temp4 ::temp4 over 
            callstatic storageUtil SetIntValue ::temp4 ::temp0 "SNRom_BankedPoints" ::temp4 ;3 variable args
            ; line 1760
            jmpf sparked _label7
            ; line 1761
            cast ::temp0 a 
            callstatic storageUtil SetIntValue ::temp4 ::temp0 "SNRom_AskPending" 1 ;3 variable args
            jmp _label7
            ; line 1763
          _label7:
            iadd ::temp4 restored 1 
            assign restored ::temp4 
            ; line 1764
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            callmethod GetDisplayName a ::temp6 ;0 variable args
            strcat ::temp6 ::temp6 " stood " 
            cast ::temp7 over 
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 " pts past the Lover line " 
            strcat ::temp7 ::temp7 "unanswered; put back at " 
            ; line 1765
            callstatic sNRom_Bridge UNANSWERED_MAX ::temp1 ;0 variable args
            cast ::temp6 ::temp1 
            strcat ::temp6 ::temp7 ::temp6 
            strcat ::temp6 ::temp6 " and the " 
            cast ::temp7 over 
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 " held for the answer." 
            callmethod Diag self ::nonevar ::temp4 ::temp7 True ;3 variable args
            jmp _label6
          _label6:
            jmp _label5
          _label5:
            jmp _label2
            ; line 1769
          _label2:
            iadd ::temp4 i 1 
            assign i ::temp4 
            jmp _label8
            ; line 1771
          _label0:
            cast ::temp0 None 
            callstatic storageUtil SetIntValue ::temp4 ::temp0 "SNRom_LoverLinePass" 1 ;3 variable args
            ; line 1772
            cmp_gt ::temp2 restored 0 
            jmpf ::temp2 _label9
            ; line 1773
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            cast ::temp7 restored 
            strcat ::temp7 ::temp7 " unanswered romances were past the Lover line from 1.x and are back " 
            strcat ::temp7 ::temp7 "on it, their difference held for the answer." 
            callmethod Diag self ::nonevar ::temp4 ::temp7 False ;3 variable args
            jmp _label9
          _label9
          .endCode
        .endFunction ;RestoreLoverLine
        .function RepairAuthoredFlags
           ; function type 0
          .userFlags 0 ;none
          .docString "ONE-TIME (SNRom_AuthoredFlagPass): marks as authored every companion
      whose character was written but whose SNRom_DispositionAuthored says
      otherwise. Found on the 2.0 dashboard, which drew 12 of 122 as
      "not authored yet" while their characters were plainly there.

      Two 1.x paths left it wrong:
      - the character-only re-author never set the flag, so a companion
        wiped with ClearDisposition during development (flag 0) and then
        re-authored that way kept 0 - ten of the twelve;
      - a failed re-author marked an intact character 2, "archetype" -
        fixed at the source in ApplyArchetype.

      THE FLAG IS NOT COSMETIC: the dashboard, BuildCircle and drift all read
      it, so those companions showed as defaults, were left out of the circle
      a new character is made distinct from, and never drifted.

      Evidence of a written character: any character field stored -
      ClearDisposition unsets every one of them, so one present means a
      character was written after it - or a WHY in the store, the evidence
      AuthorDisposition already trusts. StorageUtil and JsonUtil reads only,
      so the walk does not wait on frames."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local n Int
            .local ::temp0 form
            .local ::temp1 Int
            .local repaired Int
            .local i Int
            .local ::temp2 Bool
            .local a actor
            .local ::temp3 actor
            .local written Bool
            .local ::temp4 String
            .local was Int
            .local ::nonevar None
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 1800
            cast ::temp0 None 
            callstatic storageUtil FormListCount ::temp1 ::temp0 "SNRom_Roster" ;2 variable args
            assign n ::temp1 
            ; line 1801
            assign repaired 0 
            ; line 1802
            assign i 0 
            ; line 1803
          _label8:
            cmp_lt ::temp2 i n 
            jmpf ::temp2 _label0
            ; line 1804
            cast ::temp0 None 
            callstatic storageUtil FormListGet ::temp0 ::temp0 "SNRom_Roster" i ;3 variable args
            cast ::temp3 ::temp0 
            assign a ::temp3 
            ; line 1805
            cast ::temp3 None 
            cmp_eq ::temp2 a ::temp3 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label1
            cast ::temp0 a 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_DispositionAuthored" 0 ;3 variable args
            cmp_eq ::temp2 ::temp1 1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 1806
            cast ::temp0 a 
            callstatic storageUtil HasIntValue ::temp2 ::temp0 "SNRom_PhysMinTier" ;2 variable args
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label3
            ; line 1807
            cast ::temp0 a 
            callstatic storageUtil HasIntValue ::temp2 ::temp0 "SNRom_Ardor" ;2 variable args
            assign ::temp2 ::temp2 
          _label3:
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label4
            ; line 1808
            cast ::temp0 a 
            callstatic storageUtil HasIntValue ::temp2 ::temp0 "SNRom_Exclusivity" ;2 variable args
            assign ::temp2 ::temp2 
          _label4:
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label5
            ; line 1809
            cast ::temp0 a 
            callstatic storageUtil HasIntValue ::temp2 ::temp0 "SNRom_Orientation" ;2 variable args
            assign ::temp2 ::temp2 
          _label5:
            assign written ::temp2 
            ; line 1810
            assign ::temp2 written 
            jmpt ::temp2 _label6
            callstatic sNRom_Bridge StoreGetText ::temp4 a "Why" "" 0 ;4 variable args
            cmp_eq ::temp2 ::temp4 "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label6:
            jmpf ::temp2 _label7
            ; line 1811
            cast ::temp0 a 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_DispositionAuthored" 0 ;3 variable args
            assign was ::temp1 
            ; line 1812
            cast ::temp0 a 
            callstatic storageUtil SetIntValue ::temp1 ::temp0 "SNRom_DispositionAuthored" 1 ;3 variable args
            ; line 1813
            iadd ::temp1 repaired 1 
            assign repaired ::temp1 
            ; line 1814
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            callmethod GetDisplayName a ::temp4 ;0 variable args
            strcat ::temp4 ::temp4 "'s character was written but marked " 
            cast ::temp5 was 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 "; marked authored." 
            callmethod Diag self ::nonevar ::temp1 ::temp5 True ;3 variable args
            jmp _label7
          _label7:
            jmp _label2
            ; line 1818
          _label2:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label8
            ; line 1820
          _label0:
            cast ::temp0 None 
            callstatic storageUtil SetIntValue ::temp1 ::temp0 "SNRom_AuthoredFlagPass" 1 ;3 variable args
            ; line 1821
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            cast ::temp5 repaired 
            strcat ::temp5 "Authored flag repaired for " ::temp5 
            strcat ::temp5 ::temp5 " companions whose characters were " 
            strcat ::temp5 ::temp5 "written but not marked: the dashboard shows them as authored, and they can drift and be " 
            ; line 1822
            strcat ::temp5 ::temp5 "compared against again." 
            callmethod Diag self ::nonevar ::temp1 ::temp5 False ;3 variable args
          .endCode
        .endFunction ;RepairAuthoredFlags
        .function MoveToBondFaction
           ; function type 0
          .userFlags 0 ;none
          .docString "THE CUT'S LAST ACT FOR EACH COMPANION (design 8.1): into SNRom_Bond at
      their tier, and out of ROM_RomanceLevel, the faction 1.x put them in.
      Otherwise a Romantasy left installed keeps scoring them from its own
      economy and splashing its own tier names over a bond it no longer
      holds. That undoes our own enrollment; it writes nothing of Romantasy's.

      ONLY ONCE THEIR POINTS ARE OURS. Romantasy tracks by that faction, and
      nothing says what it does with a record it stops tracking, so anyone
      whose import has not verified keeps it, and the pass is not stamped
      until the next load finishes them.

      Also sets SNRom_Enrolled for the whole roster: that flag is what the
      mod reads for enrollment from 2.0 (IsEnrolled), and companions enrolled
      before it existed never had it. The roster is exactly the enrolled -
      UnenrollActor takes them off it."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local rom faction
            .local ::temp0 faction
            .local n Int
            .local ::temp1 form
            .local ::temp2 Int
            .local moved Int
            .local released Int
            .local waiting Int
            .local i Int
            .local ::temp3 Bool
            .local a actor
            .local ::temp4 actor
            .local ::nonevar None
            .local ::temp5 String
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 1842
            callstatic sNRom_Bridge RomantasyFaction ::temp0 ;0 variable args
            assign rom ::temp0 
            ; line 1843
            cast ::temp1 None 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "SNRom_Roster" ;2 variable args
            assign n ::temp2 
            ; line 1844
            assign moved 0 
            ; line 1845
            assign released 0 
            ; line 1846
            assign waiting 0 
            ; line 1847
            assign i 0 
            ; line 1848
          _label6:
            cmp_lt ::temp3 i n 
            jmpf ::temp3 _label0
            ; line 1849
            cast ::temp1 None 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "SNRom_Roster" i ;3 variable args
            cast ::temp4 ::temp1 
            assign a ::temp4 
            ; line 1850
            cast ::temp4 None 
            cmp_eq ::temp3 a ::temp4 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label1
            ; line 1851
            cast ::temp1 a 
            callstatic storageUtil SetIntValue ::temp2 ::temp1 "SNRom_Enrolled" 1 ;3 variable args
            ; line 1852
            callmethod JoinBondFaction self ::nonevar a ;1 variable args
            ; line 1853
            iadd ::temp2 moved 1 
            assign moved ::temp2 
            ; line 1854
            cast ::temp0 None 
            cmp_eq ::temp3 rom ::temp0 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label2
            callmethod IsInFaction a ::temp3 rom ;1 variable args
            assign ::temp3 ::temp3 
          _label2:
            jmpf ::temp3 _label3
            ; line 1855
            callstatic sNRom_Bridge PointsImported ::temp3 a ;1 variable args
            jmpf ::temp3 _label4
            ; line 1856
            callmethod RemoveFromFaction a ::nonevar rom ;1 variable args
            ; line 1857
            iadd ::temp2 released 1 
            assign released ::temp2 
            jmp _label5
            ; line 1859
          _label4:
            iadd ::temp2 waiting 1 
            assign waiting ::temp2 
          _label5:
            jmp _label3
          _label3:
            jmp _label1
            ; line 1863
          _label1:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label6
            ; line 1865
          _label0:
            cmp_gt ::temp3 waiting 0 
            jmpf ::temp3 _label7
            ; line 1866
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            cast ::temp5 moved 
            strcat ::temp5 "Moved " ::temp5 
            strcat ::temp5 ::temp5 " into SNRom_Bond; " 
            cast ::temp6 waiting 
            strcat ::temp6 ::temp5 ::temp6 
            strcat ::temp6 ::temp6 " stay in Romantasy's faction " 
            strcat ::temp6 ::temp6 "until their points are ours, and the pass runs again on the next load." 
            callmethod Diag self ::nonevar ::temp2 ::temp6 False ;3 variable args
            ; line 1868
            return None 
            jmp _label7
            ; line 1870
          _label7:
            cast ::temp1 None 
            callstatic storageUtil SetIntValue ::temp2 ::temp1 "SNRom_BondFactionPass" 1 ;3 variable args
            ; line 1871
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            cast ::temp6 moved 
            strcat ::temp6 "Moved " ::temp6 
            strcat ::temp6 ::temp6 " companions into SNRom_Bond at their tiers; " 
            cast ::temp5 released 
            strcat ::temp5 ::temp6 ::temp5 
            strcat ::temp5 ::temp5 " released from Romantasy's faction, which no longer tracks them." 
            callmethod Diag self ::nonevar ::temp2 ::temp5 False ;3 variable args
          .endCode
        .endFunction ;MoveToBondFaction
        .function UNANSWERED_MAX
           ; function type 0
          .userFlags 0 ;none
          .docString "The most an UNANSWERED romance may hold: one point below Lover.

      CORRECTED 2026-09-01. This returned 2499 - one below SPOUSE - on the
      reasoning that the gate should bite where marriage becomes eligible. That
      was the wrong rung, and the author, who designed the ladder, restated it:

        1. Stranger to Confidant: natural progression, no gate.
        2. Crossing into LOVER pops the consent question. Yes -> Lover. No ->
           mid-Friend. Undecided -> held below Lover, asked again later.
        3. Lover to Spouse: natural progression, NO GATE. Crossing into Spouse
           is what makes a formal marriage proposal eligible.

      At 2499 an unanswered romance could occupy the whole of Lover, which is the
      one rung the answer is supposed to govern. The question fired at 2000 and
      then nothing stopped her sitting at 2400 unanswered - a realized romance in
      everything except the record of consent.

      AND THERE IS NO CONSENT GATE AT SPOUSE. A formal proposal and its
      acceptance ARE the consent to marry, and that proposal only becomes
      possible at Spouse. Gating Spouse as well asked the same question twice and
      made the second asking ours rather than the marriage system.

      NOTHING CROSSES IT UNANSWERED from 2.0: ApplyDepth withholds any
      increase that would (HoldShortOfLover), and CheckRomanceQuestion reads
      points PLUS the bank, so the question is owed the moment a withheld
      amount would have carried them over."
          .return Int
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Int
          .endLocalTable
          .code
            ; line 1902
            callstatic sNRom_Bridge LOVER_MIN ::temp0 ;0 variable args
            isub ::temp0 ::temp0 1 
            return ::temp0 
          .endCode
        .endFunction ;UNANSWERED_MAX
        .function HoldShortOfLover
           ; function type 0
          .userFlags 0 ;none
          .docString "Should this increase be WITHHELD instead of written? Returns True when
      writing it would carry an unanswered romance from Confidant into Lover.

      FROM 2.0 IT GUARDS EVERY INCREASE, not only earned awards: ApplyDepth
      asks it for each one but a marriage. The 1.x rule below was the
      author's answer to Romantasy scoring on its own, and its reactive
      backstop is gone with Romantasy.

      WITHHELD, NOT WRITTEN-THEN-CORRECTED, and that is the whole point of this
      function. EnforceLoverCeiling has always clawed back after the fact, which
      was invisible while the ceiling sat at 2499 - nothing reached it. Moving the
      ceiling to just under Lover made the correction fire at the crossing for the
      first time and exposed what it costs: Romantasy received 2009, announced
      LOVER, then received -10 and announced Confidant again. The player watched a
      promotion appear and be revoked, and anything reacting to Romantasy's
      tier-change event saw the same false crossing.

      THE AUTHOR'S RULE, and it is deliberately narrow: there is exactly ONE
      moment in normal play where points should not reach Romantasy, and it is
      this one. Everything else - seeding, transfers, ruptures, the Spouse rung -
      writes normally. So this is a targeted check at the earning paths rather
      than a wrapper around every point change, and EnforceLoverCeiling stays
      behind it as a backstop for anything that slips past.

      WHAT HAPPENS TO THE WITHHELD AWARD depends on the answer, and two of the
      three throw it away:
        accepted - granted in full, so the wait costs nothing
        declined  - discarded, because they are dropping to mid-Friend anyway
        deferred  - discarded, and they stay exactly where they are

      Only bites while SPARKED and UNANSWERED, same as the ceiling: a platonic
      bond has no question to answer and must be free to reach Spouse-tier depth."
          .return Bool
          .paramTable
            .param akActor actor
            .param aiDelta Int
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local ::temp4 Int
            .local sparked Bool
            .local held Int
            .local ::temp5 form
            .local ::nonevar None
            .local ::temp6 String
            .local ::temp7 String
          .endLocalTable
          .code
            ; line 1937
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            cmp_lte ::temp1 aiDelta 0 
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 1938
            return False 
            jmp _label2
            ; line 1943
          _label2:
            callmethod ReopenIfClimbedBack self ::temp1 akActor aiDelta ;2 variable args
            ; line 1944
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_PlayerStance" 0 ;3 variable args
            callstatic sNRom_Bridge STANCE_UNANSWERED ::temp4 ;0 variable args
            cmp_eq ::temp1 ::temp3 ::temp4 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label3
            ; line 1945
            return False 
            jmp _label3
            ; line 1963
          _label3:
            callstatic sNRom_Decorators IsSparked ::temp1 akActor ;1 variable args
            assign sparked ::temp1 
            ; line 1964
            not ::temp1 sparked 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label4
            callstatic sNRom_Bridge SparkDecided ::temp1 akActor ;1 variable args
            assign ::temp1 ::temp1 
          _label4:
            jmpf ::temp1 _label5
            ; line 1965
            return False 
            jmp _label5
            ; line 1967
          _label5:
            callstatic sNRom_Bridge PointsOf ::temp4 akActor ;1 variable args
            assign held ::temp4 
            ; line 1968
            iadd ::temp4 held aiDelta 
            callstatic sNRom_Bridge UNANSWERED_MAX ::temp3 ;0 variable args
            cmp_lte ::temp1 ::temp4 ::temp3 
            jmpf ::temp1 _label6
            ; line 1969
            return False 
            jmp _label6
            ; line 1974
          _label6:
            cast ::temp2 akActor 
            ; line 1975
            cast ::temp5 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp5 "SNRom_BankedPoints" 0 ;3 variable args
            iadd ::temp3 ::temp3 aiDelta 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_BankedPoints" ::temp3 ;3 variable args
            ; line 1976
            jmpf sparked _label7
            ; line 1980
            cast ::temp2 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_AskPending" 1 ;3 variable args
            ; line 1981
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            cast ::temp6 aiDelta 
            strcat ::temp6 "Held " ::temp6 
            strcat ::temp6 ::temp6 " pts short of Lover for " 
            ; line 1982
            callmethod GetDisplayName akActor ::temp7 ;0 variable args
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 " - " 
            cast ::temp6 held 
            strcat ::temp6 ::temp7 ::temp6 
            strcat ::temp6 ::temp6 " + " 
            cast ::temp7 aiDelta 
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 " would cross " 
            ; line 1983
            callstatic sNRom_Bridge UNANSWERED_MAX ::temp4 ;0 variable args
            cast ::temp6 ::temp4 
            strcat ::temp6 ::temp7 ::temp6 
            strcat ::temp6 ::temp6 " with the question unanswered. Held, so no tier change - " 
            strcat ::temp6 ::temp6 "granted in full on yes, discarded otherwise." 
            callmethod Diag self ::nonevar ::temp3 ::temp6 False ;3 variable args
            jmp _label8
            ; line 1990
          _label7:
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            cast ::temp6 aiDelta 
            strcat ::temp6 "Held " ::temp6 
            strcat ::temp6 ::temp6 " pts short of Lover for " 
            ; line 1991
            callmethod GetDisplayName akActor ::temp7 ;0 variable args
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 " - " 
            cast ::temp6 held 
            strcat ::temp6 ::temp7 ::temp6 
            strcat ::temp6 ::temp6 " + " 
            cast ::temp7 aiDelta 
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 " would cross " 
            ; line 1992
            callstatic sNRom_Bridge UNANSWERED_MAX ::temp4 ;0 variable args
            cast ::temp6 ::temp4 
            strcat ::temp6 ::temp7 ::temp6 
            strcat ::temp6 ::temp6 " and the spark has not been judged yet. Asking the " 
            strcat ::temp6 ::temp6 "assessor first; held, so no tier change." 
            callmethod Diag self ::nonevar ::temp3 ::temp6 False ;3 variable args
            ; line 1994
            callmethod RequestSparkNow self ::nonevar akActor ;1 variable args
            ; line 1996
          _label8:
            return True 
          .endCode
        .endFunction ;HoldShortOfLover
        .function AcceptRomance
           ; function type 0
          .userFlags 0 ;none
          .docString "The player says yes. Only this opens tier 4+ as a realized romance."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 Int
            .local ::temp3 String
            .local banked Int
            .local ::temp4 form
            .local ::temp5 String
            .local ::temp6 Int
          .endLocalTable
          .code
            ; line 2004
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            callmethod IsChild akActor ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 2005
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 "AcceptRomance refused for " ::temp3 
            strcat ::temp3 ::temp3 ": IsChild" 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 2006
            return None 
            jmp _label1
            ; line 2008
          _label1:
            callstatic sNRom_Bridge STANCE_ACCEPTED ::temp2 ;0 variable args
            callmethod SetStance self ::nonevar akActor ::temp2 "accepted" ;3 variable args
            ; line 2009
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label2
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 2010
            return None 
            jmp _label3
            ; line 2015
          _label3:
            cast ::temp4 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp4 "SNRom_BankedPoints" 0 ;3 variable args
            assign banked ::temp2 
            ; line 2016
            cmp_lte ::temp1 banked 0 
            jmpf ::temp1 _label4
            ; line 2017
            return None 
            jmp _label4
            ; line 2027
          _label4:
            callmethod ApplyDepth self ::temp2 akActor banked "What was held while the question waited" True "accepted" ;5 variable args
            cmp_gt ::temp1 ::temp2 0 
            jmpf ::temp1 _label5
            ; line 2028
            cast ::temp4 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp4 "SNRom_BankedPoints" ;2 variable args
            ; line 2029
            callmethod Ledger self ::nonevar akActor "unbank" "" banked 1 "Released on acceptance" ;6 variable args
            ; line 2030
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            cast ::temp3 banked 
            strcat ::temp3 "Released " ::temp3 
            strcat ::temp3 ::temp3 " banked pts to " 
            callmethod GetDisplayName akActor ::temp5 ;0 variable args
            strcat ::temp5 ::temp3 ::temp5 
            strcat ::temp5 ::temp5 " on acceptance -> " 
            ; line 2031
            callstatic sNRom_Bridge PointsOf ::temp6 akActor ;1 variable args
            cast ::temp3 ::temp6 
            strcat ::temp3 ::temp5 ::temp3 
            strcat ::temp3 ::temp3 " pts, tier " 
            ; line 2032
            callstatic sNRom_Bridge TierOf ::temp6 akActor ;1 variable args
            cast ::temp5 ::temp6 
            strcat ::temp5 ::temp3 ::temp5 
            strcat ::temp5 ::temp5 ". The waiting cost her nothing." 
            callmethod Diag self ::nonevar ::temp2 ::temp5 False ;3 variable args
            jmp _label6
            ; line 2034
          _label5:
            callstatic sNRom_Bridge LOG_ERROR ::temp2 ;0 variable args
            cast ::temp5 banked 
            strcat ::temp5 "Could not release " ::temp5 
            strcat ::temp5 ::temp5 " banked pts to " 
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 ::temp5 ::temp3 
            strcat ::temp3 ::temp3 " - their points are not ours yet. The bank is kept." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
          _label6
          .endCode
        .endFunction ;AcceptRomance
        .function FRIEND_MID
           ; function type 0
          .userFlags 0 ;none
          .docString "Middle of tier 2, "Friend", which spans 1000-1499.

      Where a declined romance lands. From the 2000 crossing that is a 750
      point setback - about nineteen talk awards at the REAL 40 these have been
      scoring - so working back to the question takes real shared road rather
      than an evening. The author's call, and deliberately harsher than the
      Confidant cap an ENDED romance gets: being turned down when you asked is
      not the same as a relationship running its course."
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 2048
            return 1250 
          .endCode
        .endFunction ;FRIEND_MID
        .function DeclineRomance
           ; function type 0
          .userFlags 0 ;none
          .docString "The player says no, kindly or otherwise.

      DOES NOT CLEAR HER FEELINGS. The spark stays, the disposition stays, and
      the question comes back by itself: ReopenIfClimbedBack makes it live
      again when she climbs back to Lover, exactly as the first time (1.8.1).
      A no is an answer for now, not forever - people reconsider.

      IT DOES LOWER THE BOND, and that is a deliberate reversal of the original
      design (2026-08-08). The first version left depth untouched on the
      reasoning that "she still feels what she feels and they are still as
      close as they were". True of the feeling, false of the relationship: a
      follower who is turned down and stays one award short of asking again
      makes the refusal weightless, and the player would be asked again almost
      immediately. Dropping to the middle of Friend puts real distance back and
      gives the climb somewhere to go.

      Rejection is the one place lowering depth is justifiable to the player,
      because they caused it and they watched it happen. Contrast EndRomance,
      which only CAPS at Confidant - that path can fire from an assessment the
      player did not choose."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 Int
            .local ::temp1 Bool
            .local ::temp2 actor
            .local ::temp3 form
            .local who String
            .local ::temp4 String
            .local had Int
            .local drop Int
            .local ::temp5 String
            .local ::temp6 Int
          .endLocalTable
          .code
            ; line 2072
            callstatic sNRom_Bridge STANCE_DECLINED ::temp0 ;0 variable args
            callmethod SetStance self ::nonevar akActor ::temp0 "declined" ;3 variable args
            ; line 2073
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cast ::temp2 None 
            cmp_eq ::temp1 akActor ::temp2 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 2074
            return None 
            jmp _label1
            ; line 2080
          _label1:
            cast ::temp3 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp3 "SNRom_BankedPoints" ;2 variable args
            ; line 2081
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            assign who ::temp4 
            ; line 2082
            callstatic sNRom_Bridge PointsOf ::temp0 akActor ;1 variable args
            assign had ::temp0 
            ; line 2083
            callstatic sNRom_Bridge FRIEND_MID ::temp0 ;0 variable args
            isub ::temp0 ::temp0 had 
            assign drop ::temp0 
            ; line 2084
            comp_gte ::temp1 drop 0 
            jmpf ::temp1 _label2
            ; line 2085
            callstatic sNRom_Bridge LOG_INFO ::temp0 ;0 variable args
            strcat ::temp4 who " was turned down at " 
            cast ::temp5 had 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 " pts - already at or below " 
            ; line 2086
            callstatic sNRom_Bridge FRIEND_MID ::temp6 ;0 variable args
            cast ::temp4 ::temp6 
            strcat ::temp4 ::temp5 ::temp4 
            strcat ::temp4 ::temp4 ", so depth is unchanged." 
            callmethod Diag self ::nonevar ::temp0 ::temp4 False ;3 variable args
            ; line 2087
            return None 
            jmp _label2
            ; line 2089
          _label2:
            callstatic sNRom_Bridge ScaleAward ::temp0 drop ;1 variable args
            callmethod ApplyDepth self ::temp0 akActor ::temp0 "Turned down" True "declined" ;5 variable args
            cmp_gt ::temp1 ::temp0 0 
            jmpf ::temp1 _label3
            ; line 2090
            callmethod Ledger self ::nonevar akActor "declined" "" drop 1 "Turned down" ;6 variable args
            ; line 2091
            callstatic sNRom_Bridge LOG_INFO ::temp0 ;0 variable args
            strcat ::temp4 "Turned down " who 
            strcat ::temp4 ::temp4 ": " 
            cast ::temp5 had 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 " -> " 
            callstatic sNRom_Bridge PointsOf ::temp6 akActor ;1 variable args
            cast ::temp4 ::temp6 
            strcat ::temp4 ::temp5 ::temp4 
            strcat ::temp4 ::temp4 " pts, tier " 
            ; line 2092
            callstatic sNRom_Bridge TierOf ::temp6 akActor ;1 variable args
            cast ::temp5 ::temp6 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 ". She keeps the spark and everything " 
            strcat ::temp5 ::temp5 "she believes; what she loses is the closeness that got her to the question." 
            callmethod Diag self ::nonevar ::temp0 ::temp5 False ;3 variable args
            jmp _label4
            ; line 2095
          _label3:
            callstatic sNRom_Bridge LOG_ERROR ::temp0 ;0 variable args
            strcat ::temp5 "Could not apply the decline setback for " who 
            strcat ::temp5 ::temp5 " - stance is set but depth is unchanged" 
            callmethod Diag self ::nonevar ::temp0 ::temp5 False ;3 variable args
          _label4
          .endCode
        .endFunction ;DeclineRomance
        .function ReopenRomance
           ; function type 0
          .userFlags 0 ;none
          .docString "Back to unanswered, so the question is live again. For the case the author
      described: turning someone down early and coming to feel differently
      after enough shared road."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 Int
          .endLocalTable
          .code
            ; line 2103
            callstatic sNRom_Bridge STANCE_UNANSWERED ::temp0 ;0 variable args
            callmethod SetStance self ::nonevar akActor ::temp0 "reopened" ;3 variable args
            ; line 2107
            callmethod CheckRomanceQuestion self ::nonevar akActor ;1 variable args
          .endCode
        .endFunction ;ReopenRomance
        .function ReopenIfClimbedBack
           ; function type 0
          .userFlags 0 ;none
          .docString "A declined companion who climbs back to Lover is asked again, exactly as
      the first time. Returns True if it reopened them.

      THE AUTHOR'S RULE, 2026-09-28: "After decline, the question should simply
      be raised again once they progress back to the threshold of Lover. No
      reason for it to be different than the first time." Until 1.8.1 nothing
      did: CheckRomanceQuestion arms only an UNANSWERED stance, ReopenRomance
      had no caller anywhere, and HoldShortOfLover and EnforceLoverCeiling both
      stand down for DECLINED - so a declined companion climbed through Lover
      and Spouse depth unasked while 0330 told them never to raise it.

      SO THE STANCE GOES BACK TO UNANSWERED AT THE LINE, and every existing
      mechanism then does what it does the first time: the hold withholds and
      banks, the question is owed, the sweep raises it in their own words, and
      a second no drops them to mid-Friend again. No second code path, and
      nothing that can disagree with the first one.

      THE LINE IS THE SAME ONE both gates already use. HoldShortOfLover fires
      when held + incoming passes UNANSWERED_MAX; CheckRomanceQuestion when
      earned reaches LOVER_MIN, one point higher. Banked is zero for a declined
      companion (DeclineRomance discards it) and counted anyway, so this cannot
      drift from CheckRomanceQuestion if that ever changes.

      An old save already carrying a declined companion ABOVE Lover is reopened
      on its next point change or sweep, clamped like any unanswered romance,
      and asked. That is the first time's behaviour too, applied late."
          .return Bool
          .paramTable
            .param akActor actor
            .param aiIncoming Int
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local ::temp4 Int
            .local earned Int
            .local ::nonevar None
            .local ::temp5 String
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 2137
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 2138
            return False 
            jmp _label1
            ; line 2140
          _label1:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_PlayerStance" 0 ;3 variable args
            callstatic sNRom_Bridge STANCE_DECLINED ::temp4 ;0 variable args
            cmp_eq ::temp1 ::temp3 ::temp4 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 2141
            return False 
            jmp _label2
            ; line 2143
          _label2:
            callstatic sNRom_Decorators IsSparked ::temp1 akActor ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label3
            ; line 2144
            return False 
            jmp _label3
            ; line 2146
          _label3:
            callstatic sNRom_Bridge PointsOf ::temp4 akActor ;1 variable args
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_BankedPoints" 0 ;3 variable args
            iadd ::temp3 ::temp4 ::temp3 
            assign earned ::temp3 
            ; line 2147
            iadd ::temp3 earned aiIncoming 
            callstatic sNRom_Bridge UNANSWERED_MAX ::temp4 ;0 variable args
            cmp_lte ::temp1 ::temp3 ::temp4 
            jmpf ::temp1 _label4
            ; line 2148
            return False 
            jmp _label4
            ; line 2150
          _label4:
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            callmethod GetDisplayName akActor ::temp5 ;0 variable args
            strcat ::temp5 ::temp5 " climbed back to Lover after being turned down (" 
            ; line 2151
            cast ::temp6 earned 
            strcat ::temp6 ::temp5 ::temp6 
            strcat ::temp6 ::temp6 " + " 
            cast ::temp5 aiIncoming 
            strcat ::temp5 ::temp6 ::temp5 
            strcat ::temp5 ::temp5 " pts) - the question is live again, as the first time." 
            callmethod Diag self ::nonevar ::temp4 ::temp5 False ;3 variable args
            ; line 2152
            callstatic sNRom_Bridge STANCE_UNANSWERED ::temp4 ;0 variable args
            callmethod SetStance self ::nonevar akActor ::temp4 "reopened on climbing back" ;3 variable args
            ; line 2153
            return True 
          .endCode
        .endFunction ;ReopenIfClimbedBack
        .function SetStance
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param akActor actor
            .param aiStance Int
            .param asWord String
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 Int
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 2157
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 2158
            return None 
            jmp _label1
            ; line 2160
          _label1:
            cast ::temp2 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_PlayerStance" aiStance ;3 variable args
            ; line 2161
            callmethod IEB_WriteRomTrack self ::nonevar akActor ;1 variable args
            ; line 2166
            cast ::temp2 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp2 "SNRom_AskPending" ;2 variable args
            ; line 2167
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "Player stance toward " ::temp4 
            strcat ::temp4 ::temp4 ": " 
            strcat ::temp4 ::temp4 asWord 
            strcat ::temp4 ::temp4 " (tier " 
            ; line 2168
            callstatic sNRom_Bridge TierOf ::temp5 akActor ;1 variable args
            cast ::temp6 ::temp5 
            strcat ::temp6 ::temp4 ::temp6 
            strcat ::temp6 ::temp6 ", sparked=" 
            ; line 2169
            callstatic sNRom_Decorators IsSparked ::temp1 akActor ;1 variable args
            cast ::temp4 ::temp1 
            strcat ::temp4 ::temp6 ::temp4 
            strcat ::temp4 ::temp4 "). Bond depth unchanged." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
          .endCode
        .endFunction ;SetStance
        .function AskTheQuestion
           ; function type 0
          .userFlags 0 ;none
          .docString "Puts the decision in front of the player and applies their answer.

      STEP 1 OF THE CONSENT LOOP, and deliberately the only part built so far.
      Dispatch it by hand via execute-quest-script-function with questEditorId
      SNRom_Quest, scriptName SNRom_Bridge, functionName AskTheQuestion and one
      hex FormID argument. (The JSON body is not written out here: a literal
      brace inside a Papyrus docstring CLOSES it, and the rest of the comment
      is then parsed as code. That is what "no viable alternative at character
      ':'" means, and it cost a build.)

      What it proves before anything is built on top: that SkyMessage's natives
      link at all, that a box reaches the screen, and that the chosen index
      comes back and moves the stance. Everything else in the loop - crossing
      detection, the trigger that has her raise it in her own voice, the retry
      timer, the decline penalty - hangs off this working.

      BLOCKING here, non-blocking later. AskNow parks this dispatched thread
      until the player answers or 60s passes, which is fine for a hand-fired
      test and wrong for the sweep. When this moves onto the follower sweep it
      switches to Open()/IsAnswered()/Take() so a menu left open cannot hold a
      script thread.

      BODY TEXT IS DIEGETIC ON PURPOSE. SkyrimNet captures message boxes as
      events - iActions' "<name> is asking for a drink..." box is in
      openrouter_input.log with its full button list and has_callback:true, and
      those events are read back by every NPC in scene. So this reads as
      something that happened between two people, not as UI addressed to a
      player. Nothing here mentions tiers, points, or stances."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local who String
            .local ::temp2 String
            .local body String
            .local answer Int
            .local ::temp3 Int
            .local ::nonevar None
            .local ::temp4 form
          .endLocalTable
          .code
            ; line 2201
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 2202
            return None 
            jmp _label1
            ; line 2204
          _label1:
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            assign who ::temp2 
            ; line 2209
            strcat ::temp2 who " has asked where the two of you stand. " 
            strcat ::temp2 ::temp2 "Whatever you answer, you will have answered it plainly." 
            assign body ::temp2 
            ; line 2212
            callstatic sNRom_Choice AskNow ::temp3 body "Tell them you feel the same" "Tell them you do not feel that way" "Say nothing of it for now" 60.0 ;5 variable args
            assign answer ::temp3 
            ; line 2217
            callstatic sNRom_Choice ANSWER_ACCEPT ::temp3 ;0 variable args
            cmp_eq ::temp1 answer ::temp3 
            jmpf ::temp1 _label2
            ; line 2218
            callmethod AcceptRomance self ::nonevar akActor ;1 variable args
            jmp _label3
            ; line 2219
          _label2:
            callstatic sNRom_Choice ANSWER_DECLINE ::temp3 ;0 variable args
            cmp_eq ::temp1 answer ::temp3 
            jmpf ::temp1 _label4
            ; line 2220
            callmethod DeclineRomance self ::nonevar akActor ;1 variable args
            jmp _label3
            ; line 2221
          _label4:
            callstatic sNRom_Choice ANSWER_DEFER ::temp3 ;0 variable args
            cmp_eq ::temp1 answer ::temp3 
            jmpf ::temp1 _label5
            ; line 2230
            cast ::temp4 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp4 "SNRom_BankedPoints" ;2 variable args
            ; line 2231
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp2 "Question deferred for " who 
            strcat ::temp2 ::temp2 " - stance left unanswered, still open." 
            callmethod Diag self ::nonevar ::temp3 ::temp2 False ;3 variable args
            jmp _label3
            ; line 2236
          _label5:
            callstatic sNRom_Bridge LOG_WARN ::temp3 ;0 variable args
            strcat ::temp2 "No answer captured for " who 
            strcat ::temp2 ::temp2 " - the box timed out, or Papyrus MessageBox (Nexus 83578) is not installed. " 
            ; line 2237
            strcat ::temp2 ::temp2 "MARAS bundles it; check SkyrimScripting.MessageBox.dll is in SKSE\\Plugins." 
            callmethod Diag self ::nonevar ::temp3 ::temp2 False ;3 variable args
          _label3
          .endCode
        .endFunction ;AskTheQuestion
        .function ENDED_CAP
           ; function type 0
          .userFlags 0 ;none
          .docString "Confidant. Romantasy's own tier NAMES are what the player sees in its UI,
      and tier 3 is the deepest one that is not called "Lover"."
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 2245
            return 1500 
          .endCode
        .endFunction ;ENDED_CAP
        .function EndRomance
           ; function type 0
          .userFlags 0 ;none
          .docString "Ending a romance, for real this time.

      THE OLD VERSION DID NOT END A ROMANCE. It cleared SNRom_Enrolled and
      subtracted 250, and that was all. Three things wrong with it:

        - It never touched SNRom_Sparked, so the bond prompt kept selecting the
          ROMANTIC ladder and she carried on speaking as a lover. The one thing
          the function is named for did not happen.
        - -250 from Spouse (2500) or Lover (2000) leaves them still Spouse or
          still Lover. Romantasy's own UI would go on calling them that.
        - Clearing SNRom_Enrolled is actively harmful: AutoEnroll treats them as
          new on the next sweep and re-enrols them, writing a duplicate recruit
          row. Enrollment means "we are tracking this bond", which is still true
          after a breakup. It is the ROMANCE that ended, not the relationship.

      CAP, DO NOT ERASE. A divorced couple who traveled together for a year are
      not strangers. Depth is what they earned and it happened; the romantic
      designation is what is being withdrawn. Anyone already below the cap keeps
      exactly what they have - this can only ever lower, never raise.

      RE-STARTABLE BY DESIGN (the author's call). Stance returns to UNANSWERED rather
      than DECLINED, and the spark flag is cleared rather than blocked, so the
      assessor may cross them again after the tenure gate. People reconcile."
          .return None
          .paramTable
            .param akActor actor
            .param asReason String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local who String
            .local ::temp2 String
            .local ::temp3 form
            .local ::temp4 Int
            .local ::nonevar None
            .local ::temp5 Float
            .local had Int
            .local drop Int
            .local ::temp6 String
            .local ::temp7 Int
          .endLocalTable
          .code
            ; line 2272
            not ::temp0 _ready 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 akActor ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 2273
            return None 
            jmp _label1
            ; line 2275
          _label1:
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            assign who ::temp2 
            ; line 2279
            cast ::temp3 akActor 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp3 "SNRom_Sparked" ;2 variable args
            ; line 2280
            cast ::temp3 akActor 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp3 "SNRom_SparkedAt" ;2 variable args
            ; line 2281
            cast ::temp3 akActor 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp3 "SNRom_SeedRomantic" ;2 variable args
            ; line 2282
            cast ::temp3 akActor 
            callstatic sNRom_Bridge STANCE_UNANSWERED ::temp4 ;0 variable args
            callstatic storageUtil SetIntValue ::temp4 ::temp3 "SNRom_PlayerStance" ::temp4 ;3 variable args
            ; line 2283
            callmethod IEB_WriteRomTrack self ::nonevar akActor ;1 variable args
            ; line 2288
            cast ::temp3 akActor 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp3 "SNRom_AskPending" ;2 variable args
            ; line 2289
            cast ::temp3 akActor 
            callstatic utility GetCurrentGameTime ::temp5 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp5 ::temp3 "SNRom_EndedAt" ::temp5 ;3 variable args
            ; line 2292
            cast ::temp3 akActor 
            callstatic utility GetCurrentGameTime ::temp5 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp5 ::temp3 "SNRom_LastSparkCheck" ::temp5 ;3 variable args
            ; line 2293
            cast ::temp3 akActor 
            callstatic utility GetCurrentGameTime ::temp5 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp5 ::temp3 "SNRom_EnrolledAt" ::temp5 ;3 variable args
            ; line 2295
            callstatic sNRom_Bridge PointsOf ::temp4 akActor ;1 variable args
            assign had ::temp4 
            ; line 2296
            callstatic sNRom_Bridge ENDED_CAP ::temp4 ;0 variable args
            isub ::temp4 ::temp4 had 
            assign drop ::temp4 
            ; line 2297
            cmp_lt ::temp0 drop 0 
            jmpf ::temp0 _label2
            ; line 2298
            callstatic sNRom_Bridge ScaleAward ::temp4 drop ;1 variable args
            callmethod ApplyDepth self ::temp4 akActor ::temp4 asReason True "ended" ;5 variable args
            cmp_gt ::temp0 ::temp4 0 
            jmpf ::temp0 _label3
            ; line 2299
            callmethod Ledger self ::nonevar akActor "end" "" drop 1 asReason ;6 variable args
            ; line 2300
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            strcat ::temp2 "Romance ended for " who 
            strcat ::temp2 ::temp2 ": " 
            cast ::temp6 had 
            strcat ::temp6 ::temp2 ::temp6 
            strcat ::temp6 ::temp6 " -> " 
            ; line 2301
            callstatic sNRom_Bridge PointsOf ::temp7 akActor ;1 variable args
            cast ::temp2 ::temp7 
            strcat ::temp2 ::temp6 ::temp2 
            strcat ::temp2 ::temp2 " pts, tier " 
            callstatic sNRom_Bridge TierOf ::temp7 akActor ;1 variable args
            cast ::temp6 ::temp7 
            strcat ::temp6 ::temp2 ::temp6 
            strcat ::temp6 ::temp6 " (" 
            ; line 2302
            callstatic sNRom_Bridge TierOf ::temp7 akActor ;1 variable args
            callstatic sNRom_Bridge TierName ::temp2 ::temp7 ;1 variable args
            strcat ::temp2 ::temp6 ::temp2 
            strcat ::temp2 ::temp2 "). Back on the platonic ladder; " 
            strcat ::temp2 ::temp2 "romance can be judged again after the tenure gate. " 
            ; line 2303
            strcat ::temp2 ::temp2 asReason 
            callmethod Diag self ::nonevar ::temp4 ::temp2 False ;3 variable args
            jmp _label4
            ; line 2305
          _label3:
            callstatic sNRom_Bridge LOG_ERROR ::temp4 ;0 variable args
            strcat ::temp2 "Romance ended for " who 
            strcat ::temp2 ::temp2 " but the " 
            cast ::temp6 drop 
            strcat ::temp6 ::temp2 ::temp6 
            strcat ::temp6 ::temp6 " pt cap could not be written - the ladder reverted, the tier did not." 
            callmethod Diag self ::nonevar ::temp4 ::temp6 False ;3 variable args
          _label4:
            jmp _label5
            ; line 2309
          _label2:
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            strcat ::temp6 "Romance ended for " who 
            strcat ::temp6 ::temp6 " at " 
            cast ::temp2 had 
            strcat ::temp2 ::temp6 ::temp2 
            strcat ::temp2 ::temp2 " pts - already at or below " 
            ; line 2310
            callstatic sNRom_Bridge ENDED_CAP ::temp7 ;0 variable args
            cast ::temp6 ::temp7 
            strcat ::temp6 ::temp2 ::temp6 
            strcat ::temp6 ::temp6 ", so depth is unchanged. Back on the platonic ladder. " 
            strcat ::temp6 ::temp6 asReason 
            callmethod Diag self ::nonevar ::temp4 ::temp6 False ;3 variable args
          _label5
          .endCode
        .endFunction ;EndRomance
        .function IsEnrolled
           ; function type 0
          .userFlags 0 ;none
          .docString "ENROLLMENT, NOT DEPTH: SNRom_Enrolled, set by both ways in (BeginSpark,
      AutoEnroll) and cleared by UnenrollActor, which also takes them off the
      roster. From 2.0 it replaces "Romantasy has a level for them". Their
      depth is PointsOf.

      OR ON THE ROSTER, because the roster is exactly the enrolled and some
      companions were enrolled before the flag existed. MoveToBondFaction sets
      it for them, but on its own stack, while Bootstrap's SweepFollowers runs
      at once - and a flag-only test there would re-enroll an old companion as
      new, restarting their enrollment clock and assessor watermarks.

      StorageUtil reads only, so it answers for someone unloaded and never
      waits a frame; the roster search runs only when the flag is missing."
          .return Bool
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local ::temp4 form
          .endLocalTable
          .code
            ; line 2337
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 2338
            return False 
            jmp _label0
            ; line 2340
          _label0:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Enrolled" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            ; line 2341
            cast ::temp2 None 
            cast ::temp4 akActor 
            callstatic storageUtil FormListFind ::temp3 ::temp2 "SNRom_Roster" ::temp4 ;3 variable args
            comp_gte ::temp1 ::temp3 0 
            assign ::temp1 ::temp1 
          _label1:
            return ::temp1 
          .endCode
        .endFunction ;IsEnrolled
        .function ResolveFromBase
           ; function type 0
          .userFlags 0 ;none
          .docString "The roster member built from this ActorBase. The obvious resolution -
      FindActorByName(base.GetName()) - is WRONG for anyone whose display name
      differs from their base name.

      Nicollette is the case that exposed it (1.x, when Romantasy's events
      carried only the base). Born through Fertility Mode Reloaded, her
      ActorBase is still named "Player's Nord Mage Daughter" while the
      reference displays as "Nicollette". The name lookup found nothing, and
      every passive point she earned was discarded.

      Matching the roster by ActorBase is name-independent and exact, so it
      survives renames, titles, and any mod that builds an actor from a
      generic base. The name lookup stays as a fallback."
          .return actor
          .paramTable
            .param akBase actorBase
          .endParamTable
          .localTable
            .local ::temp0 actorBase
            .local ::temp1 Bool
            .local ::temp2 actor
            .local n Int
            .local ::temp3 form
            .local ::temp4 Int
            .local i Int
            .local a actor
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 2358
            cast ::temp0 None 
            cmp_eq ::temp1 akBase ::temp0 
            jmpf ::temp1 _label0
            ; line 2359
            cast ::temp2 None 
            return ::temp2 
            jmp _label0
            ; line 2361
          _label0:
            cast ::temp3 None 
            callstatic storageUtil FormListCount ::temp4 ::temp3 "SNRom_Roster" ;2 variable args
            assign n ::temp4 
            ; line 2362
            assign i 0 
            ; line 2363
          _label4:
            cmp_lt ::temp1 i n 
            jmpf ::temp1 _label1
            ; line 2364
            cast ::temp3 None 
            callstatic storageUtil FormListGet ::temp3 ::temp3 "SNRom_Roster" i ;3 variable args
            cast ::temp2 ::temp3 
            assign a ::temp2 
            ; line 2365
            cast ::temp2 None 
            cmp_eq ::temp1 a ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            callmethod GetActorBase a ::temp0 ;0 variable args
            cmp_eq ::temp1 ::temp0 akBase 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 2366
            return a 
            jmp _label3
            ; line 2368
          _label3:
            iadd ::temp4 i 1 
            assign i ::temp4 
            jmp _label4
            ; line 2370
          _label1:
            callmethod GetName akBase ::temp5 ;0 variable args
            callstatic skyrimNetApi FindActorByName ::temp2 ::temp5 ;1 variable args
            return ::temp2 
          .endCode
        .endFunction ;ResolveFromBase
        .function OrientationExcludesPlayer
           ; function type 0
          .userFlags 0 ;none
          .docString "Would this orientation rule the player out as a partner?

      Codes are SNRom_Decorators.OrientationToInt's: 0 none, 1 men, 2 women,
      3 any. GetSex is 0 male, 1 female. Deliberately the SAME test RomanceOk
      applies on read, kept as one function so the two can never drift - a
      write-time guard that disagreed with the read-time gate would be worse
      than neither.

      NONE counts as excluding. A married NPC authored "not drawn to anyone
      that way" contradicts the marriage just as squarely as a wrong gender."
          .return Bool
          .paramTable
            .param aiOrient Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local playerSex Int
            .local ::temp1 actor
            .local ::temp2 actorBase
            .local ::temp3 Int
          .endLocalTable
          .code
            ; line 2385
            cmp_eq ::temp0 aiOrient 0 
            jmpf ::temp0 _label0
            ; line 2386
            return True 
            jmp _label0
            ; line 2388
          _label0:
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetActorBase ::temp1 ::temp2 ;0 variable args
            callmethod GetSex ::temp2 ::temp3 ;0 variable args
            assign playerSex ::temp3 
            ; line 2389
            cmp_eq ::temp0 aiOrient 1 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label1
            cmp_eq ::temp0 playerSex 0 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label1:
            jmpf ::temp0 _label2
            ; line 2390
            return True 
            jmp _label3
            ; line 2391
          _label2:
            cmp_eq ::temp0 aiOrient 2 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label4
            cmp_eq ::temp0 playerSex 1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label3
            ; line 2392
            return True 
            jmp _label3
            ; line 2394
          _label3:
            return False 
          .endCode
        .endFunction ;OrientationExcludesPlayer
        .function CONFIDANT_MIN
           ; function type 0
          .userFlags 0 ;none
          .docString "Points at which Romantasy calls someone "Confidant" - tier 3, the rung
      below Lover. 500 per tier, same arithmetic as LOVER_MIN.

      Used as the "deep enough that the spark question is now urgent" line: a
      seed landing here puts someone within one ordinary award of the Lover
      floor, so the assessor is asked immediately rather than in two game days.
      See the seed hook in OnSeedAssessed."
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 2405
            return 1500 
          .endCode
        .endFunction ;CONFIDANT_MIN
        .function LOVER_MIN
           ; function type 0
          .userFlags 0 ;none
          .docString "Points at which Romantasy calls someone "Lover".

      500 per tier, so tier = points / 500 and Lover is tier 4. Read off the
      artifact rather than the documentation: ledger.jsonl has Jordis at
      "tot":2011 with "ta":4, and Sybille at 1689 with "ta":3."
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 2414
            return 2000 
          .endCode
        .endFunction ;LOVER_MIN
        .function CheckRomanceQuestion
           ; function type 0
          .userFlags 0 ;none
          .docString "Flag that the player owes this person an answer.

      LEVEL-TRIGGERED, NOT EDGE-TRIGGERED, and that is the whole design. It
      tests current state instead of watching for the instant of crossing,
      because an edge here is unreliable in three separate ways: an award can
      land while the NPC is unloaded, seeding can drop someone above the line in
      a single step, and the obvious hook was dead: 1.x's Romantasy event
      handler returned on its self-award flag BEFORE its tier-change branch,
      so "crossed a tier" appeared zero times in a log where Jordis sat at
      2011 points. Anything built on an edge would silently never fire.

      Idempotent. The pending flag is what stops it re-asking, so clearing that
      flag is also what makes the question live again after a deferral.

      DOES NOT ask anything by itself. It only records that the question is
      owed; raising it is the sweep's job, so this stays cheap enough to run on
      every point change.

      RomanceOk is checked because asking is worse than staying silent when her
      orientation already rules it out - the bond prompt has prose for that case
      and it is not a question anyone should be posed."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local ::temp4 Int
            .local ::temp5 Float
            .local ::nonevar None
            .local ::temp6 String
            .local ::temp7 Int
            .local ::temp8 String
          .endLocalTable
          .code
            ; line 2439
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 2440
            return None 
            jmp _label1
            ; line 2445
          _label1:
            callmethod ReopenIfClimbedBack self ::temp1 akActor 0 ;2 variable args
            ; line 2446
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_AskPending" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            jmpf ::temp1 _label2
            ; line 2447
            return None 
            jmp _label2
            ; line 2449
          _label2:
            callstatic sNRom_Bridge IsEnrolled ::temp1 akActor ;1 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label3
            callstatic sNRom_Decorators IsSparked ::temp1 akActor ;1 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 2450
            return None 
            jmp _label4
            ; line 2452
          _label4:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_PlayerStance" 0 ;3 variable args
            callstatic sNRom_Bridge STANCE_UNANSWERED ::temp4 ;0 variable args
            cmp_eq ::temp1 ::temp3 ::temp4 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label5
            ; line 2453
            return None 
            jmp _label5
            ; line 2455
          _label5:
            callstatic sNRom_Decorators RomanceOk ::temp1 akActor ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label6
            ; line 2456
            return None 
            jmp _label6
            ; line 2488
          _label6:
            callstatic sNRom_Bridge PointsOf ::temp4 akActor ;1 variable args
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_BankedPoints" 0 ;3 variable args
            iadd ::temp3 ::temp4 ::temp3 
            callstatic sNRom_Bridge LOVER_MIN ::temp4 ;0 variable args
            cmp_lt ::temp1 ::temp3 ::temp4 
            jmpf ::temp1 _label7
            ; line 2489
            return None 
            jmp _label7
            ; line 2492
          _label7:
            cast ::temp2 akActor 
            callstatic storageUtil SetIntValue ::temp4 ::temp2 "SNRom_AskPending" 1 ;3 variable args
            ; line 2495
            cast ::temp2 akActor 
            callstatic storageUtil SetFloatValue ::temp5 ::temp2 "SNRom_LastAskAttempt" 0.0 ;3 variable args
            ; line 2499
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            callmethod GetDisplayName akActor ::temp6 ;0 variable args
            strcat ::temp6 "Question owed to " ::temp6 
            strcat ::temp6 ::temp6 " at " 
            ; line 2500
            callstatic sNRom_Bridge PointsOf ::temp3 akActor ;1 variable args
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp7 ::temp2 "SNRom_BankedPoints" 0 ;3 variable args
            iadd ::temp7 ::temp3 ::temp7 
            cast ::temp8 ::temp7 
            strcat ::temp8 ::temp6 ::temp8 
            strcat ::temp8 ::temp8 " pts earned (" 
            ; line 2501
            callstatic sNRom_Bridge PointsOf ::temp7 akActor ;1 variable args
            cast ::temp6 ::temp7 
            strcat ::temp6 ::temp8 ::temp6 
            strcat ::temp6 ::temp6 " held + " 
            ; line 2502
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp7 ::temp2 "SNRom_BankedPoints" 0 ;3 variable args
            cast ::temp8 ::temp7 
            strcat ::temp8 ::temp6 ::temp8 
            strcat ::temp8 ::temp8 " banked, tier " 
            ; line 2503
            callstatic sNRom_Bridge TierOf ::temp7 akActor ;1 variable args
            cast ::temp6 ::temp7 
            strcat ::temp6 ::temp8 ::temp6 
            strcat ::temp6 ::temp6 ") - sparked, orientation permits, and the player has never answered." 
            callmethod Diag self ::nonevar ::temp4 ::temp6 False ;3 variable args
            ; line 2521
            callmethod PumpAskQueue self ::nonevar ;0 variable args
          .endCode
        .endFunction ;CheckRomanceQuestion
        .function Ledger
           ; function type 0
          .userFlags 0 ;none
          .docString "One JSON object per point change. Buffered - OnPreference fires on every
      matching statistic increment for every enrolled follower, so a native
      write per event is not acceptable in a busy fight."
          .return None
          .paramTable
            .param akActor actor
            .param asChannel String
            .param asActivity String
            .param aiDelta Int
            .param aiCount Int
            .param asReason String
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 form
            .local ::temp1 form
            .local ::temp2 Int
            .local today Float
            .local ::temp3 Float
            .local ::temp4 Bool
          .endLocalTable
          .code
            ; line 2535
            callmethod CheckRomanceQuestion self ::nonevar akActor ;1 variable args
            ; line 2540
            callmethod MaintainProposalGate self ::nonevar akActor ;1 variable args
            ; line 2549
            cast ::temp0 akActor 
            ; line 2550
            cast ::temp1 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp1 "SNRom_EventsSinceDrift" 0 ;3 variable args
            iadd ::temp2 ::temp2 1 
            callstatic storageUtil SetIntValue ::temp2 ::temp0 "SNRom_EventsSinceDrift" ::temp2 ;3 variable args
            ; line 2563
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            assign today ::temp3 
            ; line 2564
            cast ::temp0 akActor 
            callstatic storageUtil GetFloatValue ::temp3 ::temp0 "SNRom_DriftFirstDay" -1.0 ;3 variable args
            cmp_lt ::temp4 ::temp3 0.0 
            jmpf ::temp4 _label0
            ; line 2565
            cast ::temp0 akActor 
            callstatic storageUtil SetFloatValue ::temp3 ::temp0 "SNRom_DriftFirstDay" today ;3 variable args
            jmp _label0
            ; line 2567
          _label0:
            cast ::temp0 akActor 
            callstatic storageUtil SetFloatValue ::temp3 ::temp0 "SNRom_DriftLastDay" today ;3 variable args
            ; line 2569
            callmethod LedgerRow self ::nonevar akActor asChannel asActivity aiDelta aiCount asReason ;6 variable args
          .endCode
        .endFunction ;Ledger
        .function LedgerChannelJson
           ; function type 0
          .userFlags 0 ;none
          .docString "The row's channel field, from literals no other string in the game can
      share. Papyrus keeps one copy of each string whatever its case, so a
      bare "talk" was written as "Talk" in play (2026-10-01). Comparison
      ignores case, so each known channel is matched and written whole."
          .return String
          .paramTable
            .param asChannel String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 String
          .endLocalTable
          .code
            ; line 2577
            cmp_eq ::temp0 asChannel "talk" 
            jmpf ::temp0 _label0
            ; line 2578
            return ",\"ch\":\"talk\"" 
            jmp _label1
            ; line 2579
          _label0:
            cmp_eq ::temp0 asChannel "moment" 
            jmpf ::temp0 _label2
            ; line 2580
            return ",\"ch\":\"moment\"" 
            jmp _label1
            ; line 2581
          _label2:
            cmp_eq ::temp0 asChannel "seed" 
            jmpf ::temp0 _label3
            ; line 2582
            return ",\"ch\":\"seed\"" 
            jmp _label1
            ; line 2583
          _label3:
            cmp_eq ::temp0 asChannel "spark" 
            jmpf ::temp0 _label4
            ; line 2584
            return ",\"ch\":\"spark\"" 
            jmp _label1
            ; line 2585
          _label4:
            cmp_eq ::temp0 asChannel "import" 
            jmpf ::temp0 _label5
            ; line 2586
            return ",\"ch\":\"import\"" 
            jmp _label1
            ; line 2587
          _label5:
            cmp_eq ::temp0 asChannel "recruit" 
            jmpf ::temp0 _label6
            ; line 2588
            return ",\"ch\":\"recruit\"" 
            jmp _label1
            ; line 2589
          _label6:
            cmp_eq ::temp0 asChannel "enroll" 
            jmpf ::temp0 _label7
            ; line 2590
            return ",\"ch\":\"enroll\"" 
            jmp _label1
            ; line 2591
          _label7:
            cmp_eq ::temp0 asChannel "declined" 
            jmpf ::temp0 _label8
            ; line 2592
            return ",\"ch\":\"declined\"" 
            jmp _label1
            ; line 2593
          _label8:
            cmp_eq ::temp0 asChannel "end" 
            jmpf ::temp0 _label9
            ; line 2594
            return ",\"ch\":\"end\"" 
            jmp _label1
            ; line 2595
          _label9:
            cmp_eq ::temp0 asChannel "unbank" 
            jmpf ::temp0 _label10
            ; line 2596
            return ",\"ch\":\"unbank\"" 
            jmp _label1
            ; line 2597
          _label10:
            cmp_eq ::temp0 asChannel "withheld" 
            jmpf ::temp0 _label1
            ; line 2598
            return ",\"ch\":\"withheld\"" 
            jmp _label1
            ; line 2600
          _label1:
            strcat ::temp1 ",\"ch\":\"" asChannel 
            strcat ::temp1 ::temp1 "\"" 
            return ::temp1 
          .endCode
        .endFunction ;LedgerChannelJson
        .function LedgerRow
           ; function type 0
          .userFlags 0 ;none
          .docString "The row alone, without Ledger's reactions (the question, the ceiling,
      the proposal gate, drift's counters). For the one-time import, which
      records where a bond already stood rather than a change to it."
          .return None
          .paramTable
            .param akActor actor
            .param asChannel String
            .param asActivity String
            .param aiDelta Int
            .param aiCount Int
            .param asReason String
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Bool
            .local pts Int
            .local ::temp2 Int
            .local row String
            .local ::temp3 Float
            .local ::temp4 String
            .local ::nonevar None
            .local flushEvery Int
          .endLocalTable
          .code
            ; line 2607
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp1 ::temp0 "logLedgerEnabled" True ;3 variable args
            cmp_eq ::temp1 ::temp1 False 
            jmpf ::temp1 _label0
            ; line 2608
            return None 
            jmp _label0
            ; line 2610
          _label0:
            callstatic sNRom_Bridge PointsOf ::temp2 akActor ;1 variable args
            assign pts ::temp2 
            ; line 2611
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            cast ::temp0 ::temp3 
            strcat ::temp0 "{\"gd\":" ::temp0 
            strcat ::temp0 ::temp0 ",\"npc\":\"" 
            ; line 2612
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            callstatic sNRom_Bridge Escape ::temp4 ::temp4 ;1 variable args
            strcat ::temp4 ::temp0 ::temp4 
            strcat ::temp4 ::temp4 "\"" 
            ; line 2613
            callstatic sNRom_Bridge LedgerChannelJson ::temp0 asChannel ;1 variable args
            strcat ::temp0 ::temp4 ::temp0 
            strcat ::temp0 ::temp0 ",\"act\":\"" 
            ; line 2614
            strcat ::temp0 ::temp0 asActivity 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 ::temp0 ",\"d\":" 
            ; line 2615
            cast ::temp4 aiDelta 
            strcat ::temp4 ::temp0 ::temp4 
            strcat ::temp4 ::temp4 ",\"n\":" 
            cast ::temp0 aiCount 
            strcat ::temp0 ::temp4 ::temp0 
            strcat ::temp0 ::temp0 ",\"tot\":" 
            ; line 2616
            cast ::temp4 pts 
            strcat ::temp4 ::temp0 ::temp4 
            strcat ::temp4 ::temp4 ",\"ta\":" 
            ; line 2617
            callstatic sNRom_Bridge TierForPoints ::temp2 pts ;1 variable args
            cast ::temp0 ::temp2 
            strcat ::temp0 ::temp4 ::temp0 
            strcat ::temp0 ::temp0 ",\"why\":\"" 
            ; line 2618
            callstatic sNRom_Bridge Escape ::temp4 asReason ;1 variable args
            strcat ::temp4 ::temp0 ::temp4 
            strcat ::temp4 ::temp4 "\"}" 
            assign row ::temp4 
            ; line 2620
            array_length ::temp2 _ledgerBuf 
            comp_gte ::temp1 _ledgerCount ::temp2 
            jmpf ::temp1 _label1
            ; line 2621
            callmethod FlushLedger self ::nonevar ;0 variable args
            jmp _label1
            ; line 2623
          _label1:
            array_setelement _ledgerBuf _ledgerCount row 
            ; line 2624
            iadd ::temp2 _ledgerCount 1 
            assign _ledgerCount ::temp2 
            ; line 2631
            cmp_eq ::temp1 asChannel "passive" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 2632
            callmethod FlushLedger self ::nonevar ;0 variable args
            ; line 2633
            return None 
            jmp _label2
            ; line 2636
          _label2:
            callstatic sNRom_Bridge CFG ::temp4 ;0 variable args
            callstatic skyrimNetApi GetConfigInt ::temp2 ::temp4 "logFlushEvery" 25 ;3 variable args
            assign flushEvery ::temp2 
            ; line 2637
            comp_gte ::temp1 _ledgerCount flushEvery 
            jmpf ::temp1 _label3
            ; line 2638
            callmethod FlushLedger self ::nonevar ;0 variable args
            jmp _label3
          _label3
          .endCode
        .endFunction ;LedgerRow
        .function FlushLedger
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local i Int
            .local blob String
            .local ::temp1 String
            .local ::temp2 Int
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 2643
            cmp_lte ::temp0 _ledgerCount 0 
            jmpf ::temp0 _label0
            ; line 2644
            return None 
            jmp _label0
            ; line 2646
          _label0:
            assign i 0 
            ; line 2647
            assign blob "" 
            ; line 2648
          _label2:
            cmp_lt ::temp0 i _ledgerCount 
            jmpf ::temp0 _label1
            ; line 2649
            array_getlement ::temp1 _ledgerBuf i 
            strcat ::temp1 ::temp1 "\n" 
            strcat ::temp1 blob ::temp1 
            assign blob ::temp1 
            ; line 2650
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label2
            ; line 2652
          _label1:
            callstatic sNRom_Bridge LedgerPath ::temp1 ;0 variable args
            callmethod WriteLog self ::nonevar "ledger.jsonl" ::temp1 blob ;3 variable args
            ; line 2653
            assign _ledgerCount 0 
          .endCode
        .endFunction ;FlushLedger
        .function Escape
           ; function type 0
          .userFlags 0 ;none
          .docString "Reason strings are LLM-authored free text and land inside JSON.

      IT DID NOT ESCAPE ANYTHING until 2026-08-08 - it only truncated, while
      its own docstring said what it was for. Any reason containing a quote
      wrote a broken row, and ledger.jsonl is the analysis file, so the damage
      was silent until something tried to parse it. Found when a Sybille row
      carrying `to bear your "storm" within me` threw on ConvertFrom-Json and
      took every row after it down with the parse.

      TRUNCATE FIRST, THEN ESCAPE. The other order can cut a two-character
      escape in half and leave a trailing backslash, which is worse than the
      bug being fixed - the row stays invalid AND the reason is unreadable."
          .return String
          .paramTable
            .param asText String
          .endParamTable
          .localTable
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 2669
            callstatic stringUtil Substring ::temp0 asText 0 300 ;3 variable args
            callstatic sNRom_Decorators JsonEscape ::temp0 ::temp0 ;1 variable args
            return ::temp0 
          .endCode
        .endFunction ;Escape
        .function WriteLog
           ; function type 0
          .userFlags 0 ;none
          .docString "One write to one of the mod's log files: through the DLL (natives v7),
      at once and in order, or through MiscUtil without it - which groups
      lines by call site and delivers them late (see Diag)."
          .return None
          .paramTable
            .param asName String
            .param asPath String
            .param asText String
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 2676
            comp_gte ::temp0 _dashNatives 7 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label0
            callstatic sNRom_Native AppendLog ::temp0 asName asText ;2 variable args
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 2677
            return None 
            jmp _label1
            ; line 2679
          _label1:
            callstatic miscUtil WriteToFile ::temp0 asPath asText True False ;4 variable args
          .endCode
        .endFunction ;WriteLog
        .function Diag
           ; function type 0
          .userFlags 0 ;none
          .docString "Every line carries its own sequence number and game time.

      MiscUtil.WriteToFile does NOT guarantee ordering - entries arrive in
      blocks, grouped by call site rather than chronologically, and recent
      writes can lag behind by minutes. Reading position in the file as
      "when it happened" is wrong, and reading absence as "it did not run" is
      worse. Self-stamping every line is the only way to reconstruct order.

      abQuiet WRITES THE FILE AND SKIPS THE NOTIFICATION MIRROR, for the one
      shape of line the mirror cannot carry: a forensic record of arbitrary
      length, containing authored PROSE.

      Notifications are a single line of fixed width. Skyrim shrinks the font
      to fit and then clips, so a long one arrives unreadable AND pushes the
      short useful ones out of the queue - which is how a player with
      logNotifications on ends up seeing less than one with it off. Reported
      2026-09-05 on the parse-failure notification: "the notification text is
      so long that it shrinks the font to where I can't read it."

      The same goes for a line written once per character by a pass over the
      whole roster (the WP4 import): a hundred toasts drain for minutes and
      bury the one summary worth reading.

      This is the emission-point rule again: the constraint belongs on the line
      that emits, not on a caller who has to remember it. Anything the player
      should actually READ goes through Say, which is one short sentence by
      construction and does not depend on a log setting at all."
          .return None
          .paramTable
            .param aiLevel Int
            .param asText String
            .param abQuiet Bool
          .endParamTable
          .localTable
            .local configured Int
            .local ::temp0 String
            .local ::temp1 Int
            .local ::temp2 Bool
            .local line String
            .local ::temp3 Float
            .local ::temp4 String
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 2710
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigInt ::temp1 ::temp0 "logLevel" 3 ;3 variable args
            assign configured ::temp1 
            ; line 2711
            cmp_gt ::temp2 aiLevel configured 
            jmpf ::temp2 _label0
            ; line 2712
            return None 
            jmp _label0
            ; line 2714
          _label0:
            iadd ::temp1 _seq 1 
            assign _seq ::temp1 
            ; line 2715
            cast ::temp0 _seq 
            strcat ::temp0 "[" ::temp0 
            strcat ::temp0 ::temp0 "] gd=" 
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            cast ::temp4 ::temp3 
            strcat ::temp4 ::temp0 ::temp4 
            strcat ::temp4 ::temp4 " L" 
            cast ::temp0 aiLevel 
            strcat ::temp0 ::temp4 ::temp0 
            strcat ::temp0 ::temp0 " " 
            strcat ::temp0 ::temp0 asText 
            assign line ::temp0 
            ; line 2716
            callstatic sNRom_Bridge DiagPath ::temp0 ;0 variable args
            callstatic sNRom_Bridge NL ::temp4 ;0 variable args
            strcat ::temp4 line ::temp4 
            callmethod WriteLog self ::nonevar "snrom.log" ::temp0 ::temp4 ;3 variable args
            ; line 2717
            not ::temp2 abQuiet 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label1
            callstatic sNRom_Bridge CFG ::temp4 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp2 ::temp4 "logNotifications" False ;3 variable args
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 2718
            strcat ::temp4 "[SNRom] " asText 
            callstatic debug Notification ::nonevar ::temp4 ;1 variable args
            jmp _label2
          _label2
          .endCode
        .endFunction ;Diag
        .function PendingTimeoutSeconds
           ; function type 0
          .userFlags 0 ;none
          .docString "Raised 120 -> 300 on 2026-08-04 so the LLM request timeout can go above
      120s without the watchdog racing it.

      THE TWO NUMBERS ARE COUPLED AND NOTHING ENFORCES IT. If a variant's
      request_timeout exceeds this, the watchdog frees the pending slot while
      the request is still in flight, a second assessment starts, and the late
      response then lands against a slot that no longer belongs to it - a double
      award, or one attributed to the wrong follower. Keep this comfortably
      ABOVE the largest request_timeout in OpenRouter.yaml."
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 2768
            return 300.0 
          .endCode
        .endFunction ;PendingTimeoutSeconds
        .function LegacyStoreFile
           ; function type 0
          .userFlags 0 ;none
          .docString "The one file every install had before playthroughs were separated. Still
      the live store for whichever save claims it - see EnsureSaveId."
          .return String
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 2796
            return "SNRom_Dispositions" 
          .endCode
        .endFunction ;LegacyStoreFile
        .function PlaythroughId
           ; function type 0
          .userFlags 0 ;none
          .docString "Which playthrough this save belongs to, as SkyrimNet knows it.

      THE PROBLEM THIS SOLVES. Everything our store keys on is written by us,
      so it only exists in saves made AFTER we first wrote it - which makes an
      older save of the same playthrough indistinguishable from a different one.
      Two earlier attempts failed on exactly that: a `claimedBy` boolean divorced
      a 205-day playthrough from a 19,780-byte store, and the character name that
      replaced it is not unique across playthroughs.

      Skyrim itself does carry a real per-playthrough id - the second field of a
      save filename, e.g. 3D42EC5C, constant across 390 saves spanning weeks on
      this install and distinct for each of six other characters in the same
      folder. Papyrus cannot read it, and po3's extender does not expose it.

      SKYRIMNET ALREADY SOLVED THIS AND PUBLISHES THE ANSWER. It keeps one
      SQLite database per playthrough (data/SkyrimNet-<id>.db, eleven of them
      here) and exposes the id natively. Being an SKSE plugin it can read the
      save itself, so the value is stable for every save of a playthrough
      including ones made long before this mod was installed - which is the
      property nothing we write can have.

      SkyrimNet is already a hard dependency, so this costs nothing. We are the
      first Papyrus caller of it, so treat an empty return as normal rather than
      as impossible.

      SANITISED, because it becomes a filename. A JsonUtil write to a bad path
      is the silent failure this whole store exists to avoid, and a format change
      upstream must not be able to cause one."
          .return String
          .paramTable
          .endParamTable
          .localTable
            .local raw String
            .local ::temp0 String
            .local n Int
            .local ::temp1 Int
            .local ::temp2 Bool
            .local out String
            .local i Int
            .local c String
            .local o Int
          .endLocalTable
          .code
            ; line 2828
            callstatic skyrimNetApi GetSaveUniqueID ::temp0 ;0 variable args
            assign raw ::temp0 
            ; line 2829
            callstatic stringUtil GetLength ::temp1 raw ;1 variable args
            assign n ::temp1 
            ; line 2830
            cmp_eq ::temp2 n 0 
            jmpf ::temp2 _label0
            ; line 2831
            return "" 
            jmp _label0
            ; line 2833
          _label0:
            assign out "" 
            ; line 2834
            assign i 0 
            ; line 2835
          _label10:
            cmp_lt ::temp2 i n 
            jmpf ::temp2 _label1
            ; line 2836
            callstatic stringUtil GetNthChar ::temp0 raw i ;2 variable args
            assign c ::temp0 
            ; line 2837
            callstatic stringUtil AsOrd ::temp1 c ;1 variable args
            assign o ::temp1 
            ; line 2838
            comp_gte ::temp2 o 48 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label2
            cmp_lte ::temp2 o 57 
            assign ::temp2 ::temp2 
          _label2:
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label3
            comp_gte ::temp2 o 65 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label4
            cmp_lte ::temp2 o 90 
            assign ::temp2 ::temp2 
          _label4:
            assign ::temp2 ::temp2 
          _label3:
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label5
            comp_gte ::temp2 o 97 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label6
            cmp_lte ::temp2 o 122 
            assign ::temp2 ::temp2 
          _label6:
            assign ::temp2 ::temp2 
          _label5:
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label7
            cmp_eq ::temp2 c "-" 
            assign ::temp2 ::temp2 
          _label7:
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label8
            cmp_eq ::temp2 c "_" 
            assign ::temp2 ::temp2 
          _label8:
            jmpf ::temp2 _label9
            ; line 2839
            strcat ::temp0 out c 
            assign out ::temp0 
            jmp _label9
            ; line 2841
          _label9:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label10
            ; line 2843
          _label1:
            return out 
          .endCode
        .endFunction ;PlaythroughId
        .function StoreFile
           ; function type 0
          .userFlags 0 ;none
          .docString "The disposition store FOR THIS PLAYTHROUGH.

      Flat filename, no subfolder. JsonUtil accepts a path here, but whether it
      CREATES a missing directory is undocumented, and a silent write failure is
      the one outcome this whole store exists to avoid.

      WHY THIS IS NOT A CONSTANT. JsonUtil writes one file per INSTALL, not per
      save, and dispositions are keyed on reference FormID - stable for every
      vanilla NPC. So a second playthrough read the FIRST one's authored WHY,
      LIMIT and ADDRESS for everyone, AND the authoring guard then found those
      values and refused to write new ones. The two halves hid each other,
      because a stale disposition looks like a working one.

      SNRom_SaveId is a cached DECISION, not an identity: 1 means this
      playthrough owns the legacy file, 2 means it uses its own. Ints survive a
      reload; strings do not, which is why the id itself is re-read from
      SkyrimNet rather than stored."
          .return String
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 form
            .local ::temp1 Int
            .local ::temp2 Bool
            .local ::temp3 String
            .local id String
          .endLocalTable
          .code
            ; line 2864
            cast ::temp0 None 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_SaveId" 0 ;3 variable args
            cmp_eq ::temp2 ::temp1 1 
            jmpf ::temp2 _label0
            ; line 2865
            callstatic sNRom_Bridge LegacyStoreFile ::temp3 ;0 variable args
            return ::temp3 
            jmp _label0
            ; line 2867
          _label0:
            callstatic sNRom_Bridge PlaythroughId ::temp3 ;0 variable args
            assign id ::temp3 
            ; line 2868
            cmp_eq ::temp2 id "" 
            jmpf ::temp2 _label1
            ; line 2872
            callstatic sNRom_Bridge LegacyStoreFile ::temp3 ;0 variable args
            return ::temp3 
            jmp _label1
            ; line 2874
          _label1:
            callstatic sNRom_Bridge LegacyStoreFile ::temp3 ;0 variable args
            strcat ::temp3 ::temp3 "_" 
            strcat ::temp3 ::temp3 id 
            return ::temp3 
          .endCode
        .endFunction ;StoreFile
        .function EnsureSaveId
           ; function type 0
          .userFlags 0 ;none
          .docString "Decides, once per playthrough, whether this save owns the original
      disposition file or gets its own.

      THE FIRST PLAYTHROUGH TO RUN THIS INHERITS THE EXISTING DATA, deliberately.
      On an install that has only ever had one character - the overwhelming
      majority, and every current user - it is silently correct and nobody loses
      the characters they have authored.

      The claim is recorded INSIDE the legacy file, because the question "who
      owns this" has to be answerable from a save that has never seen our
      co-save state.

      SNRom_SaveId IS A DECISION, AND ONLY 0, 1 AND 2 ARE VALID. 0 undecided,
      1 owns the legacy file, 2 has its own. Any other value is a leftover from
      the short-lived scheme that stored a RANDOM id there, and it must be
      re-decided rather than trusted - under the current reading a stale random
      id silently means "not 1", so a save carrying one would quietly use a
      per-playthrough file it never chose. Measured 2026-09-05: a save holding
      1350563096 from an earlier build skipped the decision entirely and went on
      reading the wrong store with nothing logged."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local decided Int
            .local ::temp0 form
            .local ::temp1 Int
            .local ::temp2 Bool
            .local ::nonevar None
            .local ::temp3 String
            .local id String
            .local owner String
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 2898
            cast ::temp0 None 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_SaveId" 0 ;3 variable args
            assign decided ::temp1 
            ; line 2899
            cmp_eq ::temp2 decided 1 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label0
            cmp_eq ::temp2 decided 2 
            assign ::temp2 ::temp2 
          _label0:
            jmpf ::temp2 _label1
            ; line 2900
            return None 
            jmp _label1
            ; line 2902
          _label1:
            cmp_eq ::temp2 decided 0 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label2
            ; line 2903
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            cast ::temp3 decided 
            strcat ::temp3 "Save id " ::temp3 
            strcat ::temp3 ::temp3 " is from the earlier random-id scheme. " 
            strcat ::temp3 ::temp3 "Re-deciding which disposition store this playthrough owns." 
            callmethod Diag self ::nonevar ::temp1 ::temp3 False ;3 variable args
            jmp _label2
            ; line 2907
          _label2:
            callstatic sNRom_Bridge PlaythroughId ::temp3 ;0 variable args
            assign id ::temp3 
            ; line 2908
            cmp_eq ::temp2 id "" 
            jmpf ::temp2 _label3
            ; line 2911
            callstatic sNRom_Bridge LOG_WARN ::temp1 ;0 variable args
            strcat ::temp3 "SkyrimNet returned no save id, so the disposition store " "cannot be assigned to a playthrough yet. Using the shared file for now." 
            callmethod Diag self ::nonevar ::temp1 ::temp3 False ;3 variable args
            ; line 2913
            return None 
            jmp _label3
            ; line 2916
          _label3:
            callstatic sNRom_Bridge LegacyStoreFile ::temp3 ;0 variable args
            callstatic jsonUtil GetStringValue ::temp3 ::temp3 "claimedById" "" ;3 variable args
            assign owner ::temp3 
            ; line 2932
            cmp_eq ::temp2 owner "" 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label4
            cast ::temp0 None 
            callstatic storageUtil FormListCount ::temp1 ::temp0 "SNRom_Roster" ;2 variable args
            cmp_eq ::temp2 ::temp1 0 
            assign ::temp2 ::temp2 
          _label4:
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label5
            ; line 2933
            callstatic sNRom_Bridge LegacyStoreFile ::temp3 ;0 variable args
            callstatic jsonUtil JsonExists ::temp2 ::temp3 ;1 variable args
            assign ::temp2 ::temp2 
          _label5:
            jmpf ::temp2 _label6
            ; line 2934
            cast ::temp0 None 
            callstatic storageUtil SetIntValue ::temp1 ::temp0 "SNRom_SaveId" 2 ;3 variable args
            ; line 2935
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            strcat ::temp3 "A new playthrough (" id 
            strcat ::temp3 ::temp3 ") found characters in the unclaimed " 
            strcat ::temp3 ::temp3 "disposition store from an earlier one and left them there. This one uses " 
            ; line 2937
            callstatic sNRom_Bridge LegacyStoreFile ::temp4 ;0 variable args
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 "_" 
            strcat ::temp4 ::temp4 id 
            strcat ::temp4 ::temp4 ".json and everyone begins as a stranger." 
            callmethod Diag self ::nonevar ::temp1 ::temp4 False ;3 variable args
            jmp _label7
            ; line 2938
          _label6:
            cmp_eq ::temp2 owner "" 
            jmpf ::temp2 _label8
            ; line 2939
            callstatic sNRom_Bridge LegacyStoreFile ::temp4 ;0 variable args
            callstatic jsonUtil SetStringValue ::temp4 ::temp4 "claimedById" id ;3 variable args
            ; line 2940
            callstatic sNRom_Bridge LegacyStoreFile ::temp4 ;0 variable args
            callstatic jsonUtil Save ::temp2 ::temp4 False ;2 variable args
            ; line 2941
            cast ::temp0 None 
            callstatic storageUtil SetIntValue ::temp1 ::temp0 "SNRom_SaveId" 1 ;3 variable args
            ; line 2942
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            strcat ::temp4 "This playthrough (" id 
            strcat ::temp4 ::temp4 ") now owns the existing disposition " 
            strcat ::temp4 ::temp4 "store. Everyone already authored keeps their character." 
            callmethod Diag self ::nonevar ::temp1 ::temp4 False ;3 variable args
            jmp _label7
            ; line 2944
          _label8:
            cmp_eq ::temp2 owner id 
            jmpf ::temp2 _label9
            ; line 2945
            cast ::temp0 None 
            callstatic storageUtil SetIntValue ::temp1 ::temp0 "SNRom_SaveId" 1 ;3 variable args
            ; line 2946
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            strcat ::temp4 "Rejoined the main disposition store - same playthrough (" id 
            strcat ::temp4 ::temp4 "), just a save made before it was claimed." 
            callmethod Diag self ::nonevar ::temp1 ::temp4 False ;3 variable args
            jmp _label7
            ; line 2949
          _label9:
            cast ::temp0 None 
            callstatic storageUtil SetIntValue ::temp1 ::temp0 "SNRom_SaveId" 2 ;3 variable args
            ; line 2950
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            strcat ::temp4 "A different playthrough (" id 
            strcat ::temp4 ::temp4 "; the main store belongs to " 
            strcat ::temp4 ::temp4 owner 
            ; line 2951
            strcat ::temp4 ::temp4 "). This one uses " 
            callstatic sNRom_Bridge LegacyStoreFile ::temp3 ;0 variable args
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 "_" 
            strcat ::temp3 ::temp3 id 
            strcat ::temp3 ::temp3 ".json and " 
            strcat ::temp3 ::temp3 "everyone begins as a stranger, which is what a new game should mean." 
            callmethod Diag self ::nonevar ::temp1 ::temp3 False ;3 variable args
          _label7
          .endCode
        .endFunction ;EnsureSaveId
        .function StartFreshStore
           ; function type 0
          .userFlags 0 ;none
          .docString "Give THIS playthrough its own disposition store, leaving the legacy one to
      whoever claimed it. Takes no arguments, so it dispatches from the web API.

      Nothing is deleted: the store it leaves is untouched on disk, and
      AdoptLegacyStore returns to it."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 form
            .local ::temp2 Int
            .local ::nonevar None
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 2962
            not ::temp0 _ready 
            jmpf ::temp0 _label0
            ; line 2963
            return None 
            jmp _label0
            ; line 2965
          _label0:
            cast ::temp1 None 
            callstatic storageUtil SetIntValue ::temp2 ::temp1 "SNRom_SaveId" 2 ;3 variable args
            ; line 2966
            callstatic sNRom_Bridge WriteStorePointer ::nonevar ;0 variable args
            ; line 2967
            callmethod DashboardCacheStore self ::nonevar ;0 variable args
            ; line 2968
            jmpf _dashText _label1
            ; line 2969
            callmethod PushAllBondText self ::nonevar ;0 variable args
            jmp _label1
            ; line 2971
          _label1:
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callstatic sNRom_Bridge StoreFile ::temp3 ;0 variable args
            strcat ::temp3 "This playthrough now has its own disposition store: " ::temp3 
            strcat ::temp3 ::temp3 ".json. Nothing was deleted - the previous store is untouched, and " 
            ; line 2972
            strcat ::temp3 ::temp3 "AdoptLegacyStore returns to it." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
          .endCode
        .endFunction ;StartFreshStore
        .function AdoptLegacyStore
           ; function type 0
          .userFlags 0 ;none
          .docString "Reattach THIS playthrough to the main disposition store, taking ownership
      of it. For a save that was separated by an earlier version of this logic.

      Takes no arguments, so it dispatches from the web API. Safe and
      reversible: it moves which file this save READS and deletes nothing."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local id String
            .local ::temp1 String
            .local ::temp2 form
            .local ::temp3 Int
            .local ::nonevar None
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 2982
            not ::temp0 _ready 
            jmpf ::temp0 _label0
            ; line 2983
            return None 
            jmp _label0
            ; line 2985
          _label0:
            callstatic sNRom_Bridge PlaythroughId ::temp1 ;0 variable args
            assign id ::temp1 
            ; line 2986
            cast ::temp2 None 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_SaveId" 1 ;3 variable args
            ; line 2987
            cmp_eq ::temp0 id "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label1
            ; line 2988
            callstatic sNRom_Bridge LegacyStoreFile ::temp1 ;0 variable args
            callstatic jsonUtil SetStringValue ::temp1 ::temp1 "claimedById" id ;3 variable args
            ; line 2989
            callstatic sNRom_Bridge LegacyStoreFile ::temp1 ;0 variable args
            callstatic jsonUtil Save ::temp0 ::temp1 False ;2 variable args
            jmp _label1
            ; line 2991
          _label1:
            callstatic sNRom_Bridge WriteStorePointer ::nonevar ;0 variable args
            ; line 2992
            callmethod DashboardCacheStore self ::nonevar ;0 variable args
            ; line 2993
            jmpf _dashText _label2
            ; line 2994
            callmethod PushAllBondText self ::nonevar ;0 variable args
            jmp _label2
            ; line 2996
          _label2:
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp1 "Adopted the main disposition store, now claimed by playthrough '" id 
            ; line 2997
            strcat ::temp1 ::temp1 "'. Reading " 
            callstatic sNRom_Bridge StoreFile ::temp4 ;0 variable args
            strcat ::temp4 ::temp1 ::temp4 
            strcat ::temp4 ::temp4 ".json - authored characters are visible again." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
          .endCode
        .endFunction ;AdoptLegacyStore
        .function WriteStorePointer
           ; function type 0
          .userFlags 0 ;none
          .docString "Publishes which disposition file is live, for anything reading from
      outside the game - our own log analysis included.

      The store name is derived from a co-save Int, so nothing outside Skyrim
      can work it out. One key, rewritten every bootstrap so it can never go
      stale. This is also why the store is JsonUtil rather than the co-save at
      all: prefer a store you can verify over one you have to trust."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 3009
            callstatic sNRom_Bridge StoreFile ::temp0 ;0 variable args
            callstatic jsonUtil SetStringValue ::temp0 "SNRom_Current" "store" ::temp0 ;3 variable args
            ; line 3010
            callstatic jsonUtil Save ::temp1 "SNRom_Current" False ;2 variable args
          .endCode
        .endFunction ;WriteStorePointer
        .function StoreKey
           ; function type 0
          .userFlags 0 ;none
          .docString "Keyed on the reference FormID, not the name and not the ActorBase.

      Not the name: renamed and mod-spawned followers break it, which is the
      trap that dropped every event for an FMR child whose base name differed
      from her display name.

      Not the ActorBase: leveled generics share one base, so several NPCs would
      collide on a single key and overwrite each other's authored line.

      A dynamic reference FormID (FF...) is not guaranteed stable across load
      order changes. If one shifts, that NPC's stored text is orphaned and reads
      as blank - which is exactly the behavior we have today, so the failure
      mode is no worse than the bug this replaces."
          .return String
          .paramTable
            .param akActor actor
            .param asField String
          .endParamTable
          .localTable
            .local ::temp0 Int
            .local ::temp1 String
          .endLocalTable
          .code
            ; line 3027
            callmethod GetFormID akActor ::temp0 ;0 variable args
            cast ::temp1 ::temp0 
            strcat ::temp1 ::temp1 "." 
            strcat ::temp1 ::temp1 asField 
            return ::temp1 
          .endCode
        .endFunction ;StoreKey
        .function StoreSetText
           ; function type 0
          .userFlags 0 ;none
          .docString "Writes AND saves. JsonUtil holds the file in memory until Save() is
      called, so skipping it means the value survives exactly until the game
      exits - reintroducing the bug in a different disguise."
          .return None
          .paramTable
            .param akActor actor
            .param asField String
            .param asValue String
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 String
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 3034
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 asValue "" 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 3035
            return None 
            jmp _label1
            ; line 3037
          _label1:
            callstatic sNRom_Bridge StoreFile ::temp2 ;0 variable args
            callstatic sNRom_Bridge StoreKey ::temp3 akActor asField ;2 variable args
            callstatic jsonUtil SetStringValue ::temp3 ::temp2 ::temp3 asValue ;3 variable args
            ; line 3038
            callstatic sNRom_Bridge StoreFile ::temp3 ;0 variable args
            callstatic jsonUtil Save ::temp1 ::temp3 False ;2 variable args
          .endCode
        .endFunction ;StoreSetText
        .function StoreGetText
           ; function type 0
          .userFlags 0 ;none
          .docString "Falls back to the old StorageUtil location so NPCs authored before this
      change keep working for the rest of the current session. Their value is
      still lost on the next load - nothing can recover a string the co-save
      never kept - but they degrade to blank rather than breaking.

      asStoreName names the store to read, for the one caller that must not
      ask SkyrimNet which store is live: the dashboard's refresh, which runs
      while the game is paused (OnDashboardRefresh). Empty, as every other
      caller leaves it, means StoreFile().

      aiFormId is akActor's form id when the caller already has it: the
      dashboard's text push, which gets it from SNRom_Native.FormIdOf once per
      actor instead of three GetFormID calls, each of which may wait a frame.
      0, as every other caller leaves it, means StoreKey() asks the actor. The
      key is the same either way."
          .return String
          .paramTable
            .param akActor actor
            .param asField String
            .param asStoreName String
            .param aiFormId Int
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local fromStore String
            .local ::temp2 String
            .local jsonKey String
            .local v String
            .local ::temp3 form
          .endLocalTable
          .code
            ; line 3057
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 3058
            return "" 
            jmp _label0
            ; line 3060
          _label0:
            assign fromStore asStoreName 
            ; line 3061
            cmp_eq ::temp1 fromStore "" 
            jmpf ::temp1 _label1
            ; line 3062
            callstatic sNRom_Bridge StoreFile ::temp2 ;0 variable args
            assign fromStore ::temp2 
            jmp _label1
            ; line 3066
          _label1:
            cmp_eq ::temp1 aiFormId 0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 3067
            cast ::temp2 aiFormId 
            strcat ::temp2 ::temp2 "." 
            strcat ::temp2 ::temp2 asField 
            assign jsonKey ::temp2 
            jmp _label3
            ; line 3069
          _label2:
            callstatic sNRom_Bridge StoreKey ::temp2 akActor asField ;2 variable args
            assign jsonKey ::temp2 
            ; line 3071
          _label3:
            callstatic jsonUtil GetStringValue ::temp2 fromStore jsonKey "" ;3 variable args
            assign v ::temp2 
            ; line 3072
            cmp_eq ::temp1 v "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label4
            ; line 3073
            return v 
            jmp _label4
            ; line 3083
          _label4:
            cmp_eq ::temp1 asField "Why" 
            jmpf ::temp1 _label5
            ; line 3084
            cast ::temp3 akActor 
            callstatic storageUtil GetStringValue ::temp2 ::temp3 "SNRom_DispositionWhy" "" ;3 variable args
            return ::temp2 
            jmp _label5
            ; line 3086
          _label5:
            return "" 
          .endCode
        .endFunction ;StoreGetText
        .function SlotStale
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
            .param afPendingAt Float
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 Float
            .local ::temp2 Float
          .endLocalTable
          .code
            ; line 3090
            cmp_lte ::temp0 afPendingAt 0.0 
            jmpf ::temp0 _label0
            ; line 3091
            return True 
            jmp _label0
            ; line 3093
          _label0:
            callstatic utility GetCurrentRealTime ::temp1 ;0 variable args
            fsub ::temp1 ::temp1 afPendingAt 
            callstatic sNRom_Bridge PendingTimeoutSeconds ::temp2 ;0 variable args
            cmp_gt ::temp0 ::temp1 ::temp2 
            return ::temp0 
          .endCode
        .endFunction ;SlotStale
        .function VariantName
           ; function type 0
          .userFlags 0 ;none
          .docString "SendCustomPromptToLLM's "variant" names a variant configured in
      OpenRouter.yaml.

      THIS FUNCTION MUST NOT BE NAMED LLMVariant - or any other case-variant
      of the "llmVariant" config key. The Papyrus compiler interns strings
      CASE-INSENSITIVELY, first spelling wins, and identifiers enter the table
      before literals. A function named LLMVariant claims the slot, the
      literal "llmVariant" below folds onto it, and the compiled pex asks
      SkyrimNet for "LLMVariant" - which fails the case-sensitive YAML lookup
      and silently returns the default. Proven by pex disassembly 2026-07-27;
      cost a full diagnostic cycle. The same applies to EVERY identifier vs
      EVERY config-key literal in a script: keep key names and identifiers
      spelled apart.

      DO NOT read "LLM returned empty response" as a variant fault. That
      message is what Papyrus receives for BOTH a genuine provider failure and
      the entirely unrelated case of a prompt with no [ system ]/[ user ]
      section markers, which produces an empty messages array and never
      reaches a provider at all. Chasing it through four variants cost most of
      a day; the marker bug was the real one. SkyrimNet.log names the
      difference - "Messages array is empty" - and Papyrus never sees it.

      What matters is the PROVIDER, not the model_name: KoboldCPP-style
      backends ignore the requested model and serve whatever is loaded, so a
      variant's model_name can disagree with reality without any error.

      Pick a variant whose provider runs your strongest instruction-following
      model, with generous max_tokens and structured output OFF - structured
      output forces a JSON schema that fights our labeled-line format.

      Prefer a LOW temperature. Every prompt this variant serves emits labeled
      lines that get parsed, not prose, and creative sampling is how those come
      back malformed. A variant tuned for diary or dialogue writing - warm, long,
      high temperature - is the wrong shape for this work even on a large model.
      Model capability scales up safely; sampling settings do not travel.

      Avoid naming a variant another subsystem owns. This defaulted to
      DiaryGeneration until 2026-08-19, which meant anyone who made their diary
      entries warmer or longer silently retuned every assessment this mod makes,
      with nothing on screen to connect cause to effect. It then briefly defaulted
      to CharacterProfileGeneration, which was the same mistake with a politer
      name - still somebody else's variant.

      The default is snrom_background: the variant this mod DECLARES in its
      manifest. Declaring it is what puts it on the Models page and what carries
      it into model presets, so it is the only name that is guaranteed to still
      exist after a user applies a preset - and the only one whose settings
      nobody else will retune underneath us.

      Deliberately configurable. Variant names, their providers, token limits
      and flags are entirely user-defined, and setups range from OpenRouter to
      several local endpoints on a LAN. There is no value that is right for
      everyone."
          .return String
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 3150
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigString ::temp0 ::temp0 "llmVariant" "snrom_background" ;3 variable args
            return ::temp0 
          .endCode
        .endFunction ;VariantName
        .function ClearDisposition
           ; function type 0
          .userFlags 0 ;none
          .docString "Wipes every authored character field back to unset, so the next
      authoring starts from nothing.

      1.x also removed the Romantasy preference factions here. From 2.0 this
      mod writes no preferences, and leaves Romantasy's data alone (design 10,
      phase 5: "Do not clear another mod's data on the way out")."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local ::nonevar None
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 3160
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 3161
            return None 
            jmp _label0
            ; line 3163
          _label0:
            cast ::temp2 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp2 "SNRom_Orientation" ;2 variable args
            ; line 3164
            cast ::temp2 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp2 "SNRom_OrientationKnown" ;2 variable args
            ; line 3165
            cast ::temp2 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp2 "SNRom_PhysMinTier" ;2 variable args
            ; line 3166
            cast ::temp2 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp2 "SNRom_PhysAttrBypass" ;2 variable args
            ; line 3167
            cast ::temp2 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp2 "SNRom_Ardor" ;2 variable args
            ; line 3168
            cast ::temp2 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp2 "SNRom_Exclusivity" ;2 variable args
            ; line 3169
            cast ::temp2 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_DispositionAuthored" 0 ;3 variable args
            ; line 3170
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "Cleared disposition for " ::temp4 
            strcat ::temp4 ::temp4 " - character fields unset" 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
          .endCode
        .endFunction ;ClearDisposition
        .function BuildCircle
           ; function type 0
          .userFlags 0 ;none
          .docString "The authored ENUM PROFILE of everyone else already traveling with the
      player, so a new disposition is made distinct from the ACTUAL CAST
      rather than from an abstraction.

      IT USED TO PASS THEIR WHY SENTENCES, AND THAT CAUSED THE SAMENESS IT
      EXISTS TO PREVENT. Elisif was handed "Bryling: She finds a profound,
      almost addictive sanctuary in the total surrender of her will and the
      physical dismantling of her composure" and answered "She finds a profound
      sanctuary in the total surrender of Haruk's will and the physical
      dismantling of his composure" - the same sentence with the pronouns
      swapped, which inverts the dynamic and is nonsense for her. The author spotted
      it in play on 2026-08-07.

      This is the oldest rule in snrom-prompt-lessons, broken by our own code:
      never put a valid, well-formed answer where the model is about to answer.
      The instruction beside it literally read "must not read as a variation on
      one of the others" and lost to proximity, as instructions always do here.

      Enums cannot be pasted back as a WHY - different field, wrong shape - and
      they are the BETTER comparison anyway: WHY resisted repetition across ~15
      authorings while every enum clustered, so the enums are where sameness
      actually shows up.

      Scope is what makes this tractable. We are not trying to be distinct
      across every NPC in Skyrim - only across the handful the player actually
      travels with and sees side by side.

      The prompt has always said "two different people must not come out the
      same", but it had no idea who the others were, so it was differentiating
      against nothing. This is the difference between "be varied" and "do not
      be another Kayla".

      Scope is what makes this tractable. We are not trying to be distinct
      across every NPC in Skyrim - only across the handful the player actually
      travels with and sees side by side, which is where sameness is
      perceptible at all. Two companions in the same room must not read alike;
      two strangers in opposite holds may be identical and nobody will ever
      know.

      Capped at five. Beyond that it is prompt weight for a comparison the
      player is not making, and the response cap punishes length."
          .return String
          .paramTable
            .param akExclude actor
          .endParamTable
          .localTable
            .local n Int
            .local ::temp0 form
            .local ::temp1 Int
            .local picked actor[]
            .local ::temp2 actor[]
            .local ranks Float[]
            .local ::temp3 Float[]
            .local shown Int
            .local now Float
            .local ::temp4 Float
            .local i Int
            .local ::temp5 Bool
            .local a actor
            .local ::temp6 actor
            .local rank Float
            .local slot Int
            .local out String
            .local k Int
            .local best actor
            .local ::temp7 String
            .local ::temp8 String
          .endLocalTable
          .code
            ; line 3216
            cast ::temp0 None 
            callstatic storageUtil FormListCount ::temp1 ::temp0 "SNRom_Roster" ;2 variable args
            assign n ::temp1 
            ; line 3217
            array_create ::temp2 5 
            assign picked ::temp2 
            ; line 3218
            array_create ::temp3 5 
            assign ranks ::temp3 
            ; line 3219
            assign shown 0 
            ; line 3220
            callstatic utility GetCurrentGameTime ::temp4 ;0 variable args
            assign now ::temp4 
            ; line 3227
            assign i 0 
            ; line 3228
          _label13:
            cmp_lt ::temp5 i n 
            jmpf ::temp5 _label0
            ; line 3229
            cast ::temp0 None 
            callstatic storageUtil FormListGet ::temp0 ::temp0 "SNRom_Roster" i ;3 variable args
            cast ::temp6 ::temp0 
            assign a ::temp6 
            ; line 3233
            cast ::temp6 None 
            cmp_eq ::temp5 a ::temp6 
            not ::temp5 ::temp5 
            assign ::temp5 ::temp5 
            jmpf ::temp5 _label1
            cmp_eq ::temp5 a akExclude 
            not ::temp5 ::temp5 
            assign ::temp5 ::temp5 
          _label1:
            assign ::temp5 ::temp5 
            jmpf ::temp5 _label2
            ; line 3234
            cast ::temp0 a 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_DispositionAuthored" 0 ;3 variable args
            cmp_eq ::temp5 ::temp1 1 
            assign ::temp5 ::temp5 
          _label2:
            jmpf ::temp5 _label3
            ; line 3243
            cast ::temp0 a 
            callstatic storageUtil GetFloatValue ::temp4 ::temp0 "SNRom_LastFollowingAt" 0.0 ;3 variable args
            assign rank ::temp4 
            ; line 3244
            cmp_gt ::temp5 rank 0.0 
            assign ::temp5 ::temp5 
            jmpf ::temp5 _label4
            fsub ::temp4 now rank 
            cmp_lt ::temp5 ::temp4 1.0 
            assign ::temp5 ::temp5 
          _label4:
            assign ::temp5 ::temp5 
            jmpf ::temp5 _label5
            callstatic sNRom_Bridge IsFollowing ::temp5 a ;1 variable args
            assign ::temp5 ::temp5 
          _label5:
            jmpf ::temp5 _label6
            ; line 3245
            fadd ::temp4 rank 1000000.0 
            assign rank ::temp4 
            jmp _label6
            ; line 3249
          _label6:
            assign slot -1 
            ; line 3250
            cmp_lt ::temp5 shown 5 
            jmpf ::temp5 _label7
            ; line 3251
            assign slot shown 
            ; line 3252
            iadd ::temp1 shown 1 
            assign shown ::temp1 
            jmp _label8
            ; line 3253
          _label7:
            array_getlement ::temp4 ranks 4 
            cmp_gt ::temp5 rank ::temp4 
            jmpf ::temp5 _label8
            ; line 3254
            assign slot 4 
            jmp _label8
            ; line 3256
          _label8:
            comp_gte ::temp5 slot 0 
            jmpf ::temp5 _label9
            ; line 3257
          _label12:
            cmp_gt ::temp5 slot 0 
            assign ::temp5 ::temp5 
            jmpf ::temp5 _label10
            isub ::temp1 slot 1 
            array_getlement ::temp4 ranks ::temp1 
            cmp_gt ::temp5 rank ::temp4 
            assign ::temp5 ::temp5 
          _label10:
            jmpf ::temp5 _label11
            ; line 3258
            isub ::temp1 slot 1 
            array_getlement ::temp6 picked ::temp1 
            array_setelement picked slot ::temp6 
            ; line 3259
            isub ::temp1 slot 1 
            array_getlement ::temp4 ranks ::temp1 
            array_setelement ranks slot ::temp4 
            ; line 3260
            isub ::temp1 slot 1 
            assign slot ::temp1 
            jmp _label12
            ; line 3262
          _label11:
            array_setelement picked slot a 
            ; line 3263
            array_setelement ranks slot rank 
            jmp _label9
          _label9:
            jmp _label3
            ; line 3266
          _label3:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label13
            ; line 3269
          _label0:
            assign out "" 
            ; line 3270
            assign k 0 
            ; line 3271
          _label16:
            cmp_lt ::temp5 k shown 
            jmpf ::temp5 _label14
            ; line 3272
            array_getlement ::temp6 picked k 
            assign best ::temp6 
            ; line 3273
            cmp_eq ::temp5 out "" 
            not ::temp5 ::temp5 
            jmpf ::temp5 _label15
            ; line 3274
            strcat ::temp7 out "   " 
            assign out ::temp7 
            jmp _label15
            ; line 3276
          _label15:
            callmethod GetDisplayName best ::temp7 ;0 variable args
            strcat ::temp7 "- " ::temp7 
            strcat ::temp7 ::temp7 ": " 
            ; line 3278
            cast ::temp0 best 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_PhysMinTier" 4 ;3 variable args
            callstatic sNRom_Decorators IntimacyWordFromTier ::temp8 ::temp1 ;1 variable args
            strcat ::temp8 ::temp7 ::temp8 
            strcat ::temp8 ::temp8 ", " 
            ; line 3280
            cast ::temp0 best 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_Ardor" 2 ;3 variable args
            callstatic sNRom_Decorators ArdorWord ::temp7 ::temp1 ;1 variable args
            strcat ::temp7 ::temp8 ::temp7 
            strcat ::temp7 ::temp7 ", exclusivity " 
            ; line 3281
            cast ::temp0 best 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_Exclusivity" 50 ;3 variable args
            cast ::temp8 ::temp1 
            strcat ::temp8 ::temp7 ::temp8 
            strcat ::temp8 out ::temp8 
            assign out ::temp8 
            ; line 3282
            iadd ::temp1 k 1 
            assign k ::temp1 
            jmp _label16
            ; line 3284
          _label14:
            return out 
          .endCode
        .endFunction ;BuildCircle
        .function UnenrollByName
           ; function type 0
          .userFlags 0 ;none
          .docString "Un-enroll someone who is nowhere near the player.

      WHY THIS EXISTS. UnenrollActor needs an Actor, and the web API can only
      supply one as a FormID or a SkyrimNet UUID. Both are easy to obtain for
      someone standing in front of the player - nearby-actors lists them - and
      genuinely hard to obtain for anyone else. Sibbi Black-Briar is the case
      that forced it: accidentally recruited before the two-hour release window
      existed, sitting in Riften jail, and with no row in the disposition store
      to recover a FormID from because he was authored before WHY was written
      to JsonUtil at all. Nothing available could name him.

      THE ROSTER IS THE ANSWER, and it is better than FindActorByName. It is a
      FormList of the exact Actors we enrolled, held whether or not their 3D is
      loaded, so a name lookup against it reaches anyone we are tracking no
      matter where they are. FindActorByName is the fallback for the one case
      the roster cannot serve - an actor Romantasy knows and we never enrolled -
      and it carries the Nicollette hazard documented on ResolveFromBase, where
      a display name and a base name disagree.

      Matching is on the DISPLAY name, because that is what the player and
      every log line calls them. Papyrus compares strings case-insensitively,
      so the caller does not have to match capitalisation."
          .return None
          .paramTable
            .param asName String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local n Int
            .local ::temp1 form
            .local ::temp2 Int
            .local i Int
            .local a actor
            .local ::temp3 actor
            .local ::temp4 String
            .local ::nonevar None
            .local found actor
          .endLocalTable
          .code
            ; line 3310
            not ::temp0 _ready 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cmp_eq ::temp0 asName "" 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 3311
            return None 
            jmp _label1
            ; line 3313
          _label1:
            cast ::temp1 None 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "SNRom_Roster" ;2 variable args
            assign n ::temp2 
            ; line 3314
            assign i 0 
            ; line 3315
          _label5:
            cmp_lt ::temp0 i n 
            jmpf ::temp0 _label2
            ; line 3316
            cast ::temp1 None 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "SNRom_Roster" i ;3 variable args
            cast ::temp3 ::temp1 
            assign a ::temp3 
            ; line 3317
            cast ::temp3 None 
            cmp_eq ::temp0 a ::temp3 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            callmethod GetDisplayName a ::temp4 ;0 variable args
            cmp_eq ::temp0 ::temp4 asName 
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 3318
            callmethod UnenrollActor self ::nonevar a ;1 variable args
            ; line 3319
            return None 
            jmp _label4
            ; line 3321
          _label4:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label5
            ; line 3324
          _label2:
            callstatic skyrimNetApi FindActorByName ::temp3 asName ;1 variable args
            assign found ::temp3 
            ; line 3325
            cast ::temp3 None 
            cmp_eq ::temp0 found ::temp3 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label6
            ; line 3326
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            strcat ::temp4 "'" asName 
            strcat ::temp4 ::temp4 "' was not on the roster - un-enrolling the " 
            strcat ::temp4 ::temp4 "actor SkyrimNet resolved by that name instead. Verify this was the " 
            ; line 3327
            strcat ::temp4 ::temp4 "person meant; display and base names can disagree." 
            callmethod Diag self ::nonevar ::temp2 ::temp4 False ;3 variable args
            ; line 3329
            callmethod UnenrollActor self ::nonevar found ;1 variable args
            ; line 3330
            return None 
            jmp _label6
            ; line 3332
          _label6:
            callstatic sNRom_Bridge LOG_ERROR ::temp2 ;0 variable args
            strcat ::temp4 "Cannot un-enroll '" asName 
            strcat ::temp4 ::temp4 "' - nobody by that name is on " 
            strcat ::temp4 ::temp4 "the roster and SkyrimNet could not resolve them. Check the spelling against " 
            ; line 3333
            strcat ::temp4 ::temp4 "a log line; the display name is what is matched." 
            callmethod Diag self ::nonevar ::temp2 ::temp4 False ;3 variable args
          .endCode
        .endFunction ;UnenrollByName
        .function UnenrollActor
           ; function type 0
          .userFlags 0 ;none
          .docString "Undo an accidental enrollment. Dispatch via the web API:
        functionName UnenrollActor, arguments ["0x0001B136"]

      NOT A RESET. Their points, character and prose stay stored; what this
      does is stop us ever acting on them again: off the roster, so neither
      assessor can enumerate them and BuildCircle cannot cite them; out of
      SNRom_Bond and SNRom_Enrolled cleared, so nothing reads them as enrolled
      and AutoEnroll treats them as new; and the debounce stamp cleared, so
      re-adding them deliberately still serves the full waiting period rather
      than enrolling instantly on the old stamp."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local who String
            .local ::temp2 String
            .local ::temp3 form
            .local ::temp4 form
            .local ::temp5 Int
            .local ::temp6 faction
            .local ::nonevar None
            .local ::temp7 Int
            .local ::temp8 String
          .endLocalTable
          .code
            ; line 3348
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 3349
            return None 
            jmp _label0
            ; line 3351
          _label0:
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            assign who ::temp2 
            ; line 3352
            cast ::temp3 None 
            cast ::temp4 akActor 
            callstatic storageUtil FormListRemove ::temp5 ::temp3 "SNRom_Roster" ::temp4 True ;4 variable args
            ; line 3353
            cast ::temp4 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp4 "SNRom_Enrolled" ;2 variable args
            ; line 3354
            cast ::temp4 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp4 "SNRom_AutoEnrolled" ;2 variable args
            ; line 3355
            cast ::temp6 None 
            cmp_eq ::temp1 _bond ::temp6 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label1
            ; line 3356
            callmethod RemoveFromFaction akActor ::nonevar _bond ;1 variable args
            jmp _label1
            ; line 3358
          _label1:
            cast ::temp4 akActor 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp4 "SNRom_FirstSeenFollowing" ;2 variable args
            ; line 3359
            cast ::temp4 None 
            callstatic sNRom_Bridge PENDING_LIST ::temp2 ;0 variable args
            cast ::temp3 akActor 
            callstatic storageUtil FormListRemove ::temp5 ::temp4 ::temp2 ::temp3 True ;4 variable args
            ; line 3360
            cast ::temp3 akActor 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp3 "SNRom_LastTalkCheck" ;2 variable args
            ; line 3361
            cast ::temp3 akActor 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp3 "SNRom_LastSparkCheck" ;2 variable args
            ; line 3366
            cast ::temp3 akActor 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp3 "SNRom_LastDriftCheck" ;2 variable args
            ; line 3367
            cast ::temp3 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp3 "SNRom_EventsSinceDrift" ;2 variable args
            ; line 3368
            cast ::temp3 akActor 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp3 "SNRom_DriftFirstDay" ;2 variable args
            ; line 3369
            cast ::temp3 akActor 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp3 "SNRom_DriftLastDay" ;2 variable args
            ; line 3370
            callstatic sNRom_Bridge LOG_INFO ::temp5 ;0 variable args
            strcat ::temp2 "Un-enrolled " who 
            strcat ::temp2 ::temp2 " - off the roster and out of SNRom_Bond, no longer " 
            strcat ::temp2 ::temp2 "assessed. Roster now " 
            ; line 3371
            cast ::temp3 None 
            callstatic storageUtil FormListCount ::temp7 ::temp3 "SNRom_Roster" ;2 variable args
            cast ::temp8 ::temp7 
            strcat ::temp8 ::temp2 ::temp8 
            callmethod Diag self ::nonevar ::temp5 ::temp8 False ;3 variable args
          .endCode
        .endFunction ;UnenrollActor
        .function ReauthorCharacter
           ; function type 0
          .userFlags 0 ;none
          .docString "Re-author the character block - orientation, intimacy, ardor,
      exclusivity, WHY, LIMIT, ADDRESS - from the record.

      Dispatch by hand with execute-quest-script-function, questEditorId
      SNRom_Quest, scriptName SNRom_Bridge, functionName ReauthorCharacter, one
      hex FormID argument.

      THE SAME AS ReauthorDisposition FROM 2.0. In 1.x that one also added
      Romantasy preferences, permanently, and this was the character-only
      path; with no preferences there is only the character. Both names are
      kept because the dashboard and every note on dispatching them use them."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 3386
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 3387
            return None 
            jmp _label0
            ; line 3389
          _label0:
            callmethod ReauthorDisposition self ::nonevar akActor ;1 variable args
          .endCode
        .endFunction ;ReauthorCharacter
        .function ReauthorDisposition
           ; function type 0
          .userFlags 0 ;none
          .docString "Bypasses the once-only guard. Needed for two real cases:

      1. NPCs authored before a schema change. Jordis and Kayla were authored
         when the prompt only produced likes and dislikes, so their
         orientation, intimacy, ardor and exclusivity were never written -
         the two most developed relationships in the save were the only two
         with no authored character.
      2. A player who has pre-seeded facts (a SeverActions custom bio block,
         say) and wants them picked up now rather than never.

      NOT SAFE TO REPEAT CASUALLY: it rewrites the character fields from a
      fresh response, discarding any drift they have accumulated."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 Int
            .local ::temp3 String
            .local ::temp4 form
          .endLocalTable
          .code
            ; line 3406
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 3407
            return None 
            jmp _label0
            ; line 3409
          _label0:
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 "Re-authoring disposition for " ::temp3 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 3426
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp2 ::temp4 "SNRom_ForceAuthor" 1 ;3 variable args
            ; line 3427
            callmethod AuthorDisposition self ::nonevar akActor ;1 variable args
          .endCode
        .endFunction ;ReauthorDisposition
        .function AuthorDisposition
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::temp2 form
            .local ::temp3 Int
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 form
            .local ::temp6 Int
            .local ::temp7 String
            .local b actorBase
            .local ::temp8 actorBase
            .local circleText String
            .local marriedFlag Int
            .local ctx String
            .local ::temp9 race
            .local promptFile String
            .local rc Int
            .local ::temp10 quest
          .endLocalTable
          .code
            ; line 3431
            not ::temp0 _ready 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 akActor ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 3432
            return None 
            jmp _label1
            ; line 3457
          _label1:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_DispositionAuthored" 0 ;3 variable args
            cmp_eq ::temp0 ::temp3 1 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label2
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_ForceAuthor" 0 ;3 variable args
            cmp_eq ::temp0 ::temp3 0 
            assign ::temp0 ::temp0 
          _label2:
            jmpf ::temp0 _label3
            ; line 3458
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "Not authoring " ::temp4 
            strcat ::temp4 ::temp4 " - already LLM-authored. ReauthorDisposition forces a redo." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
            ; line 3459
            return None 
            jmp _label3
            ; line 3496
          _label3:
            callstatic sNRom_Bridge StoreGetText ::temp4 akActor "Why" "" 0 ;4 variable args
            cmp_eq ::temp0 ::temp4 "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label4
            ; line 3497
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_ForceAuthor" 0 ;3 variable args
            cmp_eq ::temp0 ::temp3 0 
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label5
            ; line 3498
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "Not authoring " ::temp4 
            strcat ::temp4 ::temp4 " - the disposition store still holds their WHY, so they were authored before " 
            ; line 3499
            strcat ::temp4 ::temp4 "a save reload rolled the flag back. Repairing the flag instead." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
            ; line 3501
            cast ::temp2 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_DispositionAuthored" 1 ;3 variable args
            ; line 3502
            return None 
            jmp _label5
            ; line 3504
          _label5:
            cast ::temp1 None 
            cmp_eq ::temp0 _pendingActor ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label6
            ; line 3521
            cast ::temp2 None 
            cast ::temp5 akActor 
            callstatic storageUtil FormListAdd ::temp3 ::temp2 "SNRom_AuthorQueue" ::temp5 False ;4 variable args
            ; line 3522
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "Authoring busy; queued " ::temp4 
            strcat ::temp4 ::temp4 " (queue depth " 
            ; line 3523
            cast ::temp5 None 
            callstatic storageUtil FormListCount ::temp6 ::temp5 "SNRom_AuthorQueue" ;2 variable args
            cast ::temp7 ::temp6 
            strcat ::temp7 ::temp4 ::temp7 
            strcat ::temp7 ::temp7 ")" 
            callmethod Diag self ::nonevar ::temp3 ::temp7 False ;3 variable args
            ; line 3524
            return None 
            jmp _label6
            ; line 3529
          _label6:
            cast ::temp5 akActor 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp5 "SNRom_ForceAuthor" ;2 variable args
            ; line 3530
            callstatic sNRom_Bridge CFG ::temp7 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp0 ::temp7 "enrollmentLlmPreferences" True ;3 variable args
            cmp_eq ::temp0 ::temp0 False 
            jmpf ::temp0 _label7
            ; line 3531
            callmethod ApplyArchetype self ::nonevar akActor ;1 variable args
            ; line 3532
            return None 
            jmp _label7
            ; line 3535
          _label7:
            assign _pendingActor akActor 
            ; line 3536
            callmethod GetDisplayName akActor ::temp7 ;0 variable args
            assign _pendingName ::temp7 
            ; line 3598
            callmethod GetActorBase akActor ::temp8 ;0 variable args
            assign b ::temp8 
            ; line 3599
            callmethod BuildCircle self ::temp7 akActor ;1 variable args
            callstatic sNRom_Decorators JsonEscape ::temp7 ::temp7 ;1 variable args
            assign circleText ::temp7 
            ; line 3602
            callstatic stringUtil GetLength ::temp3 circleText ;1 variable args
            cmp_gt ::temp0 ::temp3 600 
            jmpf ::temp0 _label8
            ; line 3603
            callstatic stringUtil Substring ::temp7 circleText 0 600 ;3 variable args
            assign circleText ::temp7 
            ; line 3604
            callstatic sNRom_Bridge LOG_WARN ::temp3 ;0 variable args
            strcat ::temp7 "Circle text truncated to 600 chars for " _pendingName 
            strcat ::temp7 ::temp7 " - it is the only unbounded field in the authoring context, and an over-long " 
            ; line 3605
            strcat ::temp7 ::temp7 "context makes EVERY variable undefined rather than just this one." 
            callmethod Diag self ::nonevar ::temp3 ::temp7 False ;3 variable args
            jmp _label8
            ; line 3672
          _label8:
            assign marriedFlag 0 
            ; line 3673
            callstatic sNRom_Bridge IsMarriedToPlayer ::temp0 akActor ;1 variable args
            jmpf ::temp0 _label9
            ; line 3674
            assign marriedFlag 1 
            jmp _label9
            ; line 3684
          _label9:
            strcat ::temp7 "{\"npc_name\":\"" _pendingName 
            strcat ::temp7 ::temp7 "\"" 
            strcat ::temp7 ::temp7 ",\"npc_formid\":" 
            ; line 3685
            callmethod GetFormID akActor ::temp3 ;0 variable args
            cast ::temp4 ::temp3 
            strcat ::temp4 ::temp7 ::temp4 
            strcat ::temp4 ::temp4 ",\"npc_married\":" 
            ; line 3687
            cast ::temp7 marriedFlag 
            strcat ::temp7 ::temp4 ::temp7 
            callstatic sNRom_Bridge MarasContext ::temp4 akActor ;1 variable args
            strcat ::temp4 ::temp7 ::temp4 
            strcat ::temp4 ::temp4 ",\"circle\":\"" 
            ; line 3688
            strcat ::temp4 ::temp4 circleText 
            strcat ::temp4 ::temp4 "\"" 
            strcat ::temp4 ::temp4 ",\"npc_bio\":\"" 
            ; line 3689
            callmethod GetRace b ::temp9 ;0 variable args
            callmethod GetName ::temp9 ::temp7 ;0 variable args
            strcat ::temp7 ::temp4 ::temp7 
            strcat ::temp7 ::temp7 ", " 
            ; line 3690
            callmethod GetSex b ::temp3 ;0 variable args
            callstatic sNRom_Decorators SexWord ::temp4 ::temp3 ;1 variable args
            strcat ::temp4 ::temp7 ::temp4 
            strcat ::temp4 ::temp4 ", level " 
            callmethod GetLevel akActor ::temp3 ;0 variable args
            cast ::temp7 ::temp3 
            strcat ::temp7 ::temp4 ::temp7 
            strcat ::temp7 ::temp7 ". Known to the Dragonborn.\"}" 
            assign ctx ::temp7 
            ; line 3694
            assign promptFile "snrom_author_disposition" 
            ; line 3695
            callmethod IsChild akActor ::temp0 ;0 variable args
            jmpf ::temp0 _label10
            ; line 3696
            assign promptFile "ieb_snrom_author_child" 
            jmp _label10
            ; line 3698
          _label10:
            callstatic sNRom_Bridge VariantName ::temp7 ;0 variable args
            ; line 3699
            cast ::temp10 self 
            callstatic skyrimNetApi SendCustomPromptToLLM ::temp3 promptFile ::temp7 ctx ::temp10 "SNRom_Bridge" "OnDispositionAuthored" ;6 variable args
            assign rc ::temp3 
            ; line 3700
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp7 "Disposition authoring requested for " _pendingName 
            strcat ::temp7 ::temp7 " variant='" 
            callstatic sNRom_Bridge VariantName ::temp4 ;0 variable args
            strcat ::temp4 ::temp7 ::temp4 
            strcat ::temp4 ::temp4 "' (rc=" 
            cast ::temp7 rc 
            strcat ::temp7 ::temp4 ::temp7 
            strcat ::temp7 ::temp7 ")" 
            callmethod Diag self ::nonevar ::temp3 ::temp7 False ;3 variable args
            ; line 3701
            cmp_eq ::temp0 rc 1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label11
            ; line 3702
            callstatic sNRom_Bridge LOG_ERROR ::temp3 ;0 variable args
            cast ::temp7 rc 
            strcat ::temp7 "SendCustomPromptToLLM failed (rc=" ::temp7 
            strcat ::temp7 ::temp7 ") - falling back to archetype" 
            callmethod Diag self ::nonevar ::temp3 ::temp7 False ;3 variable args
            ; line 3703
            callmethod ApplyArchetype self ::nonevar _pendingActor ;1 variable args
            ; line 3704
            cast ::temp1 None 
            assign _pendingActor ::temp1 
            jmp _label11
          _label11
          .endCode
        .endFunction ;AuthorDisposition
        .function OnUpdate
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 3709
            callmethod PumpAuthoringQueue self ::nonevar ;0 variable args
            ; line 3710
            callmethod OpenPendingBox self ::nonevar ;0 variable args
            ; line 3711
            callmethod CollectAskAnswer self ::nonevar ;0 variable args
          .endCode
        .endFunction ;OnUpdate
        .function VoiceLeadSeconds
           ; function type 0
          .userFlags 0 ;none
          .docString "How long her line gets to land before the box interrupts it.

      DO NOT RENAME THIS TO MATCH ITS CONFIG PATH, and do not spell that path
      anywhere in this comment either. Papyrus interns strings
      case-insensitively AND docstrings are embedded in the .pex, so a function
      name - or a stray mention in documentation - that differs from the config
      literal only by case collides with it in the string table. The identifier
      wins, the literal is stored folded to it, and GetConfigFloat is handed a
      path that does not exist: it returns the default forever and the manifest
      setting silently does nothing.

      Caught here only by grepping the .pex. The source looks perfect and the
      compiler says OK. This is the same failure that made the whole plugin
      config inert once already."
          .return Float
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Float
          .endLocalTable
          .code
            ; line 3769
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp1 ::temp0 "askVoiceSeconds" 6.0 ;3 variable args
            return ::temp1 
          .endCode
        .endFunction ;VoiceLeadSeconds
        .function AskRetryHours
           ; function type 0
          .userFlags 0 ;none
          .docString "Backoff, so an unanswered question does not become nagging.

      First attempt is immediate - CheckRomanceQuestion stamps LastAskAttempt
      to 0.0 precisely so the debt is raised at the first good moment rather
      than after serving an interval nobody has earned.

      After that it widens: a player who deferred once was busy, a player who
      has deferred three times is telling you something."
          .return Float
          .paramTable
            .param aiAttempts Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 3781
            cmp_lte ::temp0 aiAttempts 0 
            jmpf ::temp0 _label0
            ; line 3782
            return 0.0 
            jmp _label1
            ; line 3783
          _label0:
            cmp_eq ::temp0 aiAttempts 1 
            jmpf ::temp0 _label2
            ; line 3784
            return 2.0 
            jmp _label1
            ; line 3785
          _label2:
            cmp_eq ::temp0 aiAttempts 2 
            jmpf ::temp0 _label1
            ; line 3786
            return 6.0 
            jmp _label1
            ; line 3788
          _label1:
            return 24.0 
          .endCode
        .endFunction ;AskRetryHours
        .function PumpAskQueue
           ; function type 0
          .userFlags 0 ;none
          .docString "Raise the outstanding question with ONE person, if conditions allow.

      Conditions are all cheap and local - no LLM call, no allocation - because
      this runs on every sweep whether or not anyone is owed an answer.

      ONE BOX AT A TIME, globally. Two questions on screen at once would be
      unanswerable in any sensible order.

      TWO FLAGS GUARD THAT, NOT ONE. _boxId covers a box already on screen;
      _boxPending covers the window between her being asked to speak and the
      box appearing. Checking only _boxId would let a second follower start
      raising the same question during that gap, and both boxes would then
      queue up behind each other."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local player actor
            .local now Float
            .local ::temp2 Float
            .local n Int
            .local ::temp3 form
            .local ::temp4 Int
            .local i Int
            .local a actor
            .local attempts Int
            .local last Float
            .local waitedH Float
            .local ::temp5 objectReference
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 3805
            not ::temp0 _ready 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cmp_eq ::temp0 _boxId 0 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label0:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label1
            cast ::temp1 None 
            cmp_eq ::temp0 _boxPending ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label1:
            jmpf ::temp0 _label2
            ; line 3806
            return None 
            jmp _label2
            ; line 3808
          _label2:
            callstatic game GetPlayer ::temp1 ;0 variable args
            assign player ::temp1 
            ; line 3809
            cast ::temp1 None 
            cmp_eq ::temp0 player ::temp1 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label3
            callmethod IsInCombat player ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 3810
            return None 
            jmp _label4
            ; line 3812
          _label4:
            callstatic utility GetCurrentGameTime ::temp2 ;0 variable args
            assign now ::temp2 
            ; line 3813
            cast ::temp3 None 
            callstatic storageUtil FormListCount ::temp4 ::temp3 "SNRom_Roster" ;2 variable args
            assign n ::temp4 
            ; line 3814
            assign i 0 
            ; line 3815
          _label14:
            cmp_lt ::temp0 i n 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label5
            cmp_eq ::temp0 _boxId 0 
            assign ::temp0 ::temp0 
          _label5:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label6
            cast ::temp1 None 
            cmp_eq ::temp0 _boxPending ::temp1 
            assign ::temp0 ::temp0 
          _label6:
            jmpf ::temp0 _label7
            ; line 3816
            cast ::temp3 None 
            callstatic storageUtil FormListGet ::temp3 ::temp3 "SNRom_Roster" i ;3 variable args
            cast ::temp1 ::temp3 
            assign a ::temp1 
            ; line 3817
            cast ::temp1 None 
            cmp_eq ::temp0 a ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label8
            cast ::temp3 a 
            callstatic storageUtil GetIntValue ::temp4 ::temp3 "SNRom_AskPending" 0 ;3 variable args
            cmp_eq ::temp0 ::temp4 1 
            assign ::temp0 ::temp0 
          _label8:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label9
            callmethod IsDead a ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label9:
            jmpf ::temp0 _label10
            ; line 3818
            cast ::temp3 a 
            callstatic storageUtil GetIntValue ::temp4 ::temp3 "SNRom_AskAttempts" 0 ;3 variable args
            assign attempts ::temp4 
            ; line 3819
            cast ::temp3 a 
            callstatic storageUtil GetFloatValue ::temp2 ::temp3 "SNRom_LastAskAttempt" 0.0 ;3 variable args
            assign last ::temp2 
            ; line 3821
            fsub ::temp2 now last 
            fmul ::temp2 ::temp2 24.0 
            assign waitedH ::temp2 
            ; line 3824
            callstatic sNRom_Bridge AskRetryHours ::temp2 attempts ;1 variable args
            comp_gte ::temp0 waitedH ::temp2 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label11
            callmethod Is3DLoaded a ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label11:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label12
            cast ::temp5 player 
            callmethod GetDistance a ::temp2 ::temp5 ;1 variable args
            cmp_lt ::temp0 ::temp2 600.0 
            assign ::temp0 ::temp0 
          _label12:
            jmpf ::temp0 _label13
            ; line 3825
            callmethod OpenAsk self ::nonevar a ;1 variable args
            jmp _label13
          _label13:
            jmp _label10
            ; line 3828
          _label10:
            iadd ::temp4 i 1 
            assign i ::temp4 
            jmp _label14
          _label7
          .endCode
        .endFunction ;PumpAskQueue
        .function OpenAsk
           ; function type 0
          .userFlags 0 ;none
          .docString "Have her raise it in her own words. The box follows on a timer.

      This function no longer puts anything on screen. It fires
      SNRom_QuestionRaised, the trigger of the same name voices her asking, and
      OpenPendingBox opens the box once that line has had its moment.

      WHY A MOD EVENT AND NOT THE BOX ITSELF. SkyrimNet does capture message
      boxes into prompt context - iActions' fast-travel box is in
      openrouter_input.log with its full button list and has_callback true - but
      capture is not the same as a trigger-matchable event, and there is no
      message-box event type in WORKFLOW_TRIGGERS.md. A mod event is documented,
      fires exactly when we choose, and carries her identity.

      HER NAME TRAVELS IN str_arg. Sent from the actor, sender_form_id resolves
      to her too, but the existing tier trigger already documents that
      sender_form_id is an ActorBase and awkward to resolve back to a reference.
      str_arg sidesteps that entirely and renders the same either way."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local who String
            .local ::temp0 String
            .local attempts Int
            .local ::temp1 form
            .local ::temp2 Int
            .local ::temp3 Float
            .local ::nonevar None
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 3850
            callmethod GetDisplayName akActor ::temp0 ;0 variable args
            assign who ::temp0 
            ; line 3852
            cast ::temp1 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp1 "SNRom_AskAttempts" 0 ;3 variable args
            iadd ::temp2 ::temp2 1 
            assign attempts ::temp2 
            ; line 3856
            cast ::temp1 akActor 
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp3 ::temp1 "SNRom_LastAskAttempt" ::temp3 ;3 variable args
            ; line 3857
            cast ::temp1 akActor 
            callstatic storageUtil SetIntValue ::temp2 ::temp1 "SNRom_AskAttempts" attempts ;3 variable args
            ; line 3859
            callmethod SendModEvent akActor ::nonevar "SNRom_QuestionRaised" who 0.0 ;3 variable args
            ; line 3861
            assign _boxPending akActor 
            ; line 3862
            callstatic utility GetCurrentRealTime ::temp3 ;0 variable args
            assign _boxVoicedAt ::temp3 
            ; line 3863
            callmethod RegisterForSingleUpdate self ::nonevar 1.0 ;1 variable args
            ; line 3864
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            strcat ::temp0 who " is raising the question in her own words (attempt " 
            cast ::temp4 attempts 
            strcat ::temp4 ::temp0 ::temp4 
            strcat ::temp4 ::temp4 "); the box follows in " 
            ; line 3865
            callstatic sNRom_Bridge VoiceLeadSeconds ::temp3 ;0 variable args
            cast ::temp0 ::temp3 
            strcat ::temp0 ::temp4 ::temp0 
            strcat ::temp0 ::temp0 "s, next retry in " 
            ; line 3866
            callstatic sNRom_Bridge AskRetryHours ::temp3 attempts ;1 variable args
            cast ::temp4 ::temp3 
            strcat ::temp4 ::temp0 ::temp4 
            strcat ::temp4 ::temp4 "h if unanswered" 
            callmethod Diag self ::nonevar ::temp2 ::temp4 False ;3 variable args
          .endCode
        .endFunction ;OpenAsk
        .function OpenPendingBox
           ; function type 0
          .userFlags 0 ;none
          .docString "Puts the question on screen once her line has had its moment.

      DIEGETIC BODY TEXT. SkyrimNet reads message boxes back to every NPC in
      scene, so this reads as something that happened between two people, never
      as UI addressed to a player. Nothing here names a tier, a point or a
      stance.

      SHE HAS TO STILL BE THERE. The gap is only seconds, but a follower can
      die, be dismissed or walk out of range inside it, and a box asking where
      you stand with someone who just left the room is worse than no box. The
      pending slot clears and the retry timer takes it from the top."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 Float
            .local ::temp3 Float
            .local ::nonevar None
            .local akActor actor
            .local who String
            .local ::temp4 String
            .local player actor
            .local ::temp5 objectReference
            .local ::temp6 Int
            .local body String
            .local id Int
          .endLocalTable
          .code
            ; line 3881
            cast ::temp0 None 
            cmp_eq ::temp1 _boxPending ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 _boxId 0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 3882
            return None 
            jmp _label1
            ; line 3884
          _label1:
            callstatic utility GetCurrentRealTime ::temp2 ;0 variable args
            fsub ::temp2 ::temp2 _boxVoicedAt 
            callstatic sNRom_Bridge VoiceLeadSeconds ::temp3 ;0 variable args
            cmp_lt ::temp1 ::temp2 ::temp3 
            jmpf ::temp1 _label2
            ; line 3885
            callmethod RegisterForSingleUpdate self ::nonevar 1.0 ;1 variable args
            ; line 3886
            return None 
            jmp _label2
            ; line 3889
          _label2:
            assign akActor _boxPending 
            ; line 3890
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            assign who ::temp4 
            ; line 3891
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 3892
            callmethod IsDead akActor ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label3
            callmethod Is3DLoaded akActor ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label3:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label4
            cast ::temp0 None 
            cmp_eq ::temp1 player ::temp0 
            assign ::temp1 ::temp1 
          _label4:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label5
            ; line 3893
            cast ::temp5 player 
            callmethod GetDistance akActor ::temp3 ::temp5 ;1 variable args
            comp_gte ::temp1 ::temp3 600.0 
            assign ::temp1 ::temp1 
          _label5:
            jmpf ::temp1 _label6
            ; line 3894
            cast ::temp0 None 
            assign _boxPending ::temp0 
            ; line 3895
            callstatic sNRom_Bridge LOG_INFO ::temp6 ;0 variable args
            strcat ::temp4 "Dropped the question for " who 
            strcat ::temp4 ::temp4 " - they are no longer present. It stays owed and will be raised again." 
            callmethod Diag self ::nonevar ::temp6 ::temp4 False ;3 variable args
            ; line 3897
            return None 
            jmp _label6
            ; line 3904
          _label6:
            strcat ::temp4 who " has asked where the two of you stand. " 
            strcat ::temp4 ::temp4 "Whatever you answer, you will have answered it plainly." 
            assign body ::temp4 
            ; line 3907
            callstatic sNRom_Choice Open ::temp6 body "Tell them you feel the same" "Tell them you do not feel that way" "Say nothing of it for now" ;4 variable args
            assign id ::temp6 
            ; line 3911
            cmp_eq ::temp1 id 0 
            jmpf ::temp1 _label7
            ; line 3912
            cast ::temp0 None 
            assign _boxPending ::temp0 
            ; line 3913
            callstatic sNRom_Bridge LOG_WARN ::temp6 ;0 variable args
            strcat ::temp4 "Could not open the question for " who 
            strcat ::temp4 ::temp4 " - Papyrus MessageBox (Nexus 83578) is missing. MARAS bundles it; " 
            ; line 3914
            strcat ::temp4 ::temp4 "check SkyrimScripting.MessageBox.dll is in SKSE\\Plugins. Retrying on a later sweep." 
            callmethod Diag self ::nonevar ::temp6 ::temp4 False ;3 variable args
            ; line 3916
            return None 
            jmp _label7
            ; line 3918
          _label7:
            cast ::temp0 None 
            assign _boxPending ::temp0 
            ; line 3919
            assign _boxActor akActor 
            ; line 3920
            assign _boxId id 
            ; line 3921
            callstatic utility GetCurrentRealTime ::temp3 ;0 variable args
            assign _boxOpenedAt ::temp3 
            ; line 3922
            callmethod RegisterForSingleUpdate self ::nonevar 2.0 ;1 variable args
            ; line 3923
            callstatic sNRom_Bridge LOG_INFO ::temp6 ;0 variable args
            strcat ::temp4 "Question on screen for " who 
            callmethod Diag self ::nonevar ::temp6 ::temp4 False ;3 variable args
          .endCode
        .endFunction ;OpenPendingBox
        .function CollectAskAnswer
           ; function type 0
          .userFlags 0 ;none
          .docString "Poll the open box and apply whatever the player chose.

      TIMEOUT, because the poll re-registers itself. A player who walks away
      from the box would otherwise leave this ticking for the rest of the
      session. Discarding leaves SNRom_AskPending SET, so the backoff simply
      raises it again later - which is the correct reading of "did not
      answer"."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 Float
            .local ::nonevar None
            .local ::temp2 Int
            .local ::temp3 String
            .local ::temp4 actor
            .local answer Int
            .local who actor
            .local ::temp5 form
          .endLocalTable
          .code
            ; line 3934
            cmp_eq ::temp0 _boxId 0 
            jmpf ::temp0 _label0
            ; line 3935
            return None 
            jmp _label0
            ; line 3937
          _label0:
            callstatic sNRom_Choice IsAnswered ::temp0 _boxId ;1 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label1
            ; line 3938
            callstatic utility GetCurrentRealTime ::temp1 ;0 variable args
            fsub ::temp1 ::temp1 _boxOpenedAt 
            cmp_gt ::temp0 ::temp1 180.0 
            jmpf ::temp0 _label2
            ; line 3939
            callstatic sNRom_Choice Discard ::nonevar _boxId ;1 variable args
            ; line 3940
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName _boxActor ::temp3 ;0 variable args
            strcat ::temp3 "Question for " ::temp3 
            strcat ::temp3 ::temp3 " went unanswered and was withdrawn - it stays owed and will be raised again." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 3942
            assign _boxId 0 
            ; line 3943
            cast ::temp4 None 
            assign _boxActor ::temp4 
            ; line 3944
            return None 
            jmp _label2
            ; line 3946
          _label2:
            callmethod RegisterForSingleUpdate self ::nonevar 2.0 ;1 variable args
            ; line 3947
            return None 
            jmp _label1
            ; line 3950
          _label1:
            callstatic sNRom_Choice Take ::temp2 _boxId ;1 variable args
            assign answer ::temp2 
            ; line 3951
            assign who _boxActor 
            ; line 3952
            assign _boxId 0 
            ; line 3953
            cast ::temp4 None 
            assign _boxActor ::temp4 
            ; line 3954
            cast ::temp4 None 
            cmp_eq ::temp0 who ::temp4 
            jmpf ::temp0 _label3
            ; line 3955
            return None 
            jmp _label3
            ; line 3958
          _label3:
            callstatic sNRom_Choice ANSWER_ACCEPT ::temp2 ;0 variable args
            cmp_eq ::temp0 answer ::temp2 
            jmpf ::temp0 _label4
            ; line 3962
            cast ::temp5 who 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp5 "SNRom_AskAttempts" ;2 variable args
            ; line 3963
            callmethod AcceptRomance self ::nonevar who ;1 variable args
            jmp _label5
            ; line 3964
          _label4:
            callstatic sNRom_Choice ANSWER_DECLINE ::temp2 ;0 variable args
            cmp_eq ::temp0 answer ::temp2 
            jmpf ::temp0 _label6
            ; line 3965
            cast ::temp5 who 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp5 "SNRom_AskAttempts" ;2 variable args
            ; line 3966
            callmethod DeclineRomance self ::nonevar who ;1 variable args
            jmp _label5
            ; line 3967
          _label6:
            callstatic sNRom_Choice ANSWER_DEFER ::temp2 ;0 variable args
            cmp_eq ::temp0 answer ::temp2 
            jmpf ::temp0 _label7
            ; line 3973
            cast ::temp5 who 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp5 "SNRom_BankedPoints" ;2 variable args
            ; line 3974
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName who ::temp3 ;0 variable args
            strcat ::temp3 "Question deferred for " ::temp3 
            strcat ::temp3 ::temp3 " - still owed, raised again after backoff." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            jmp _label5
            ; line 3977
          _label7:
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            callmethod GetDisplayName who ::temp3 ;0 variable args
            strcat ::temp3 "No usable answer for " ::temp3 
            strcat ::temp3 ::temp3 " - still owed." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
          _label5
          .endCode
        .endFunction ;CollectAskAnswer
        .function OCR_ATTRACTION_QUEST
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 4008
            return 94475 
          .endCode
        .endFunction ;OCR_ATTRACTION_QUEST
        .function OCR_ATTRACTIVENESS_BASE
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 4011
            return 94459 
          .endCode
        .endFunction ;OCR_ATTRACTIVENESS_BASE
        .function OCR_PLUGIN
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 4014
            return "OStimCommunityResource.esp" 
          .endCode
        .endFunction ;OCR_PLUGIN
        .function AttractionSource
           ; function type 0
          .userFlags 0 ;none
          .docString "Resolve OCR's attraction calculator, or None with the reason logged once.

      Order matters. The plugin check comes first because "OCR is not installed"
      is the overwhelmingly common answer and must stay cheap and quiet; the
      questionnaire check comes before the cast because it is the one condition
      where CALLING the calculator would do something the player did not ask
      for. See RefreshAttraction's docstring."
          .return oCR_AttractionUtil
          .paramTable
          .endParamTable
          .localTable
            .local qf form
            .local ::temp0 Int
            .local ::temp1 String
            .local ::temp2 form
            .local ::temp3 Bool
            .local ::nonevar None
            .local ::temp4 oCR_AttractionUtil
            .local gv globalVariable
            .local ::temp5 globalVariable
            .local ::temp6 Float
            .local util oCR_AttractionUtil
          .endLocalTable
          .code
            ; line 4041
            callstatic sNRom_Bridge OCR_ATTRACTION_QUEST ::temp0 ;0 variable args
            callstatic sNRom_Bridge OCR_PLUGIN ::temp1 ;0 variable args
            callstatic game GetFormFromFile ::temp2 ::temp0 ::temp1 ;2 variable args
            assign qf ::temp2 
            ; line 4042
            cast ::temp2 None 
            cmp_eq ::temp3 qf ::temp2 
            jmpf ::temp3 _label0
            ; line 4046
            not ::temp3 _attrQuiet 
            jmpf ::temp3 _label1
            ; line 4047
            callstatic sNRom_Bridge LOG_DEBUG ::temp0 ;0 variable args
            callmethod Diag self ::nonevar ::temp0 "Attraction: OStim Community Resource not present - ratio stays 0.0 and the physical gate runs on tier alone" False ;3 variable args
            ; line 4048
            assign _attrQuiet True 
            jmp _label1
            ; line 4050
          _label1:
            cast ::temp4 None 
            return ::temp4 
            jmp _label0
            ; line 4053
          _label0:
            callstatic sNRom_Bridge OCR_ATTRACTIVENESS_BASE ::temp0 ;0 variable args
            callstatic sNRom_Bridge OCR_PLUGIN ::temp1 ;0 variable args
            callstatic game GetFormFromFile ::temp2 ::temp0 ::temp1 ;2 variable args
            cast ::temp5 ::temp2 
            assign gv ::temp5 
            ; line 4054
            cast ::temp5 None 
            cmp_eq ::temp3 gv ::temp5 
            jmpf ::temp3 _label2
            ; line 4055
            not ::temp3 _attrQuiet 
            jmpf ::temp3 _label3
            ; line 4056
            callstatic sNRom_Bridge LOG_WARN ::temp0 ;0 variable args
            callmethod Diag self ::nonevar ::temp0 "Attraction: OCR is loaded but OCR_AttractivenessBase did not resolve - its FormIDs may have moved in an OCR update" False ;3 variable args
            ; line 4057
            assign _attrQuiet True 
            jmp _label3
            ; line 4059
          _label3:
            cast ::temp4 None 
            return ::temp4 
            jmp _label2
            ; line 4061
          _label2:
            callmethod GetValue gv ::temp6 ;0 variable args
            cmp_eq ::temp3 ::temp6 0.0 
            jmpf ::temp3 _label4
            ; line 4063
            not ::temp3 _attrQuiet 
            jmpf ::temp3 _label5
            ; line 4064
            callstatic sNRom_Bridge LOG_INFO ::temp0 ;0 variable args
            strcat ::temp1 "Attraction: OCR's attractiveness questionnaire is unanswered, so there is no baseline to read. " "Answer it through OStim and this starts working on its own - we will not raise that prompt from a background sweep." 
            callmethod Diag self ::nonevar ::temp0 ::temp1 False ;3 variable args
            ; line 4066
            assign _attrQuiet True 
            jmp _label5
            ; line 4068
          _label5:
            cast ::temp4 None 
            return ::temp4 
            jmp _label4
            ; line 4071
          _label4:
            cast ::temp4 qf 
            assign util ::temp4 
            ; line 4072
            cast ::temp4 None 
            cmp_eq ::temp3 util ::temp4 
            jmpf ::temp3 _label6
            ; line 4073
            not ::temp3 _attrQuiet 
            jmpf ::temp3 _label7
            ; line 4074
            callstatic sNRom_Bridge LOG_WARN ::temp0 ;0 variable args
            callmethod Diag self ::nonevar ::temp0 "Attraction: resolved OCR_AttractionUtilQST but its script did not cast - OCR install may be partial" False ;3 variable args
            ; line 4075
            assign _attrQuiet True 
            jmp _label7
            ; line 4077
          _label7:
            cast ::temp4 None 
            return ::temp4 
            jmp _label6
            ; line 4079
          _label6:
            assign _attrQuiet False 
            ; line 4080
            return util 
          .endCode
        .endFunction ;AttractionSource
        .function RefreshAttraction
           ; function type 0
          .userFlags 0 ;none
          .docString "Recompute and store one NPC's attraction ratio. ONE argument, so it is
      dispatchable from the web API for probing; it deliberately re-resolves
      the source and clears the log latch so a manual probe always says why it
      did nothing.

      THIS CALL IS NEITHER FREE NOR PURE, and both facts shape everything else
      in this section.

      Not free: CalculateNPCAttraction runs roughly forty GetActorValue calls,
      ten quest-completion checks and up to thirty GetFactionRank calls, and
      prints ten lines to the console, every time. That is why only ONE actor
      is refreshed per tick and why the interval is a game DAY rather than
      hours - its inputs are player skills, fame and main-quest progress, none
      of which move fast enough to care.

      Not pure: it ADDS THE NPC TO FACTIONS. An OCR social class if they have
      none, and a RANDOMLY CHOSEN "enthusiast" trait if they have none. Both
      are OCR's own bookkeeping and OCR would write exactly the same thing the
      first time it evaluated the NPC itself - we only make it happen sooner -
      but a mod that quietly mutates another mod's data should say so in its
      log and should be switchable off. Hence attractionEnabled.

      THE ONE SIDE EFFECT WE MUST NOT CAUSE: if the player has never answered
      OCR's attractiveness questionnaire, CalculateNPCAttraction SHOWS IT -
      three modal message boxes, raised from a background game-time timer, at
      whatever moment our tick happened to land. Read OCR_AttractivenessBase
      first and refuse to proceed while it is 0. The player answers that
      through OStim, on their own terms; we consume the answer and never
      provoke the question.

      Deliberately calls CalculateNPCAttraction rather than GetAttraction. The
      latter is the same computation plus a write to OCR's OCR_CurrentAttraction
      global, which belongs to whatever scene OStim is running. Reading another
      mod's number is fair; overwriting it from a background sweep is not."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 String
            .local util oCR_AttractionUtil
            .local ::temp3 oCR_AttractionUtil
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 4118
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 4119
            return None 
            jmp _label1
            ; line 4121
          _label1:
            callstatic sNRom_Bridge CFG ::temp2 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp1 ::temp2 "attractionEnabled" True ;3 variable args
            cmp_eq ::temp1 ::temp1 False 
            jmpf ::temp1 _label2
            ; line 4122
            return None 
            jmp _label2
            ; line 4124
          _label2:
            assign _attrQuiet False 
            ; line 4125
            callmethod AttractionSource self ::temp3 ;0 variable args
            assign util ::temp3 
            ; line 4126
            cast ::temp3 None 
            cmp_eq ::temp1 util ::temp3 
            jmpf ::temp1 _label3
            ; line 4127
            return None 
            jmp _label3
            ; line 4129
          _label3:
            callmethod ApplyAttraction self ::nonevar util akActor ;2 variable args
          .endCode
        .endFunction ;RefreshAttraction
        .function ApplyAttraction
           ; function type 0
          .userFlags 0 ;none
          .docString "The reading itself, split out so the scheduled path can resolve the
      source ONCE per tick instead of once per actor."
          .return None
          .paramTable
            .param akSource oCR_AttractionUtil
            .param akActor actor
          .endParamTable
          .localTable
            .local ratio Float
            .local ::temp0 Float
            .local ::temp1 form
            .local bar Float
            .local ::temp2 String
            .local ::nonevar None
            .local ::temp3 Int
            .local ::temp4 String
            .local ::temp5 Bool
          .endLocalTable
          .code
            ; line 4135
            callmethod CalculateNPCAttraction akSource ::temp0 akActor ;1 variable args
            assign ratio ::temp0 
            ; line 4136
            cast ::temp1 akActor 
            callstatic storageUtil SetFloatValue ::temp0 ::temp1 "SNRom_AttractionRatio" ratio ;3 variable args
            ; line 4137
            cast ::temp1 akActor 
            callstatic utility GetCurrentGameTime ::temp0 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp0 ::temp1 "SNRom_LastAttrCheck" ::temp0 ;3 variable args
            ; line 4141
            callstatic sNRom_Bridge CFG ::temp2 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp0 ::temp2 "attractionBypassRatio" 1.5 ;3 variable args
            assign bar ::temp0 
            ; line 4142
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            strcat ::temp2 "Attraction: " ::temp2 
            strcat ::temp2 ::temp2 " ratio=" 
            cast ::temp4 ratio 
            strcat ::temp4 ::temp2 ::temp4 
            strcat ::temp4 ::temp4 " bar=" 
            ; line 4143
            cast ::temp2 bar 
            strcat ::temp2 ::temp4 ::temp2 
            strcat ::temp2 ::temp2 " (" 
            comp_gte ::temp5 ratio bar 
            callstatic sNRom_Bridge AttrVerdict ::temp4 ::temp5 ;1 variable args
            strcat ::temp4 ::temp2 ::temp4 
            strcat ::temp4 ::temp4 "). OCR may have assigned them a social class " 
            strcat ::temp4 ::temp4 "and an enthusiast trait as a side effect of this reading." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
          .endCode
        .endFunction ;ApplyAttraction
        .function AttrVerdict
           ; function type 0
          .userFlags 0 ;none
          .docString "Exists only so the log line above reads as a sentence. Inline string
      literals in a Diag concatenation are fine; a bare "true"/"false" next to
      two floats is not."
          .return String
          .paramTable
            .param abClears Bool
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 4151
            jmpf abClears _label0
            ; line 4152
            return "clears the bypass bar" 
            jmp _label0
            ; line 4154
          _label0:
            return "below the bypass bar" 
          .endCode
        .endFunction ;AttrVerdict
        .function RefreshNextAttraction
           ; function type 0
          .userFlags 0 ;none
          .docString "ONE actor per tick, most overdue wins - the same shape as AssessNextTalk
      and AssessNextSpark, for a harder reason than either.

      Those two are bounded naturally: each holds a pending slot until an LLM
      round trip returns, so at most one is ever in flight. This has no round
      trip and would happily run the whole roster inside a single frame, which
      on a ten-follower party is roughly four hundred GetActorValue calls and a
      hundred faction lookups in one Papyrus slice. That is a visible hitch."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 String
            .local now Float
            .local ::temp2 Float
            .local interval Float
            .local n Int
            .local ::temp3 Int
            .local i Int
            .local pick actor
            .local ::temp4 actor
            .local bestWait Float
            .local a actor
            .local last Float
            .local ::temp5 form
            .local util oCR_AttractionUtil
            .local ::temp6 oCR_AttractionUtil
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 4166
            not ::temp0 _ready 
            jmpf ::temp0 _label0
            ; line 4167
            return None 
            jmp _label0
            ; line 4169
          _label0:
            callstatic sNRom_Bridge CFG ::temp1 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp0 ::temp1 "attractionEnabled" True ;3 variable args
            cmp_eq ::temp0 ::temp0 False 
            jmpf ::temp0 _label1
            ; line 4170
            return None 
            jmp _label1
            ; line 4172
          _label1:
            callstatic utility GetCurrentGameTime ::temp2 ;0 variable args
            assign now ::temp2 
            ; line 4173
            callstatic sNRom_Bridge CFG ::temp1 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp2 ::temp1 "attractionRefreshHours" 24.0 ;3 variable args
            fdiv ::temp2 ::temp2 24.0 
            assign interval ::temp2 
            ; line 4174
            assign n 0 
            ; line 4175
            cast ::temp0 _observers 
            jmpf ::temp0 _label2
            ; line 4176
            array_length ::temp3 _observers 
            assign n ::temp3 
            jmp _label2
            ; line 4178
          _label2:
            assign i 0 
            ; line 4179
            cast ::temp4 None 
            assign pick ::temp4 
            ; line 4180
            assign bestWait -1.0 
            ; line 4181
          _label7:
            cmp_lt ::temp0 i n 
            jmpf ::temp0 _label3
            ; line 4182
            array_getlement ::temp4 _observers i 
            assign a ::temp4 
            ; line 4187
            cast ::temp4 None 
            cmp_eq ::temp0 a ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label4
            ; line 4188
            cast ::temp5 a 
            callstatic storageUtil GetFloatValue ::temp2 ::temp5 "SNRom_LastAttrCheck" 0.0 ;3 variable args
            assign last ::temp2 
            ; line 4189
            fsub ::temp2 now last 
            comp_gte ::temp0 ::temp2 interval 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label5
            fsub ::temp2 now last 
            cmp_gt ::temp0 ::temp2 bestWait 
            assign ::temp0 ::temp0 
          _label5:
            jmpf ::temp0 _label6
            ; line 4190
            fsub ::temp2 now last 
            assign bestWait ::temp2 
            ; line 4191
            assign pick a 
            jmp _label6
          _label6:
            jmp _label4
            ; line 4194
          _label4:
            iadd ::temp3 i 1 
            assign i ::temp3 
            jmp _label7
            ; line 4196
          _label3:
            cast ::temp4 None 
            cmp_eq ::temp0 pick ::temp4 
            jmpf ::temp0 _label8
            ; line 4197
            return None 
            jmp _label8
            ; line 4202
          _label8:
            callmethod AttractionSource self ::temp6 ;0 variable args
            assign util ::temp6 
            ; line 4203
            cast ::temp6 None 
            cmp_eq ::temp0 util ::temp6 
            jmpf ::temp0 _label9
            ; line 4204
            return None 
            jmp _label9
            ; line 4206
          _label9:
            callmethod ApplyAttraction self ::nonevar util pick ;2 variable args
          .endCode
        .endFunction ;RefreshNextAttraction
        .function MarasStateLine
           ; function type 0
          .userFlags 0 ;none
          .docString "What MARAS believes about this person, for the log only.

      Added after an afternoon spent reconstructing one companion's marital
      state from a crash log, an OpenRouter transcript and the MARAS source.
      All of it was one native call away the whole time. Nothing reads this - it
      exists so the next question of this shape is a grep."
          .return String
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local status String
            .local ::temp2 String
            .local ::temp3 Int
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 4250
            callstatic sNRom_Bridge MarasPresent ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 akActor ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 4251
            return "" 
            jmp _label1
            ; line 4253
          _label1:
            assign status "none" 
            ; line 4254
            callstatic mARAS IsNPCStatus ::temp0 akActor "married" ;2 variable args
            jmpf ::temp0 _label2
            ; line 4255
            assign status "married" 
            jmp _label3
            ; line 4256
          _label2:
            callstatic mARAS IsNPCStatus ::temp0 akActor "engaged" ;2 variable args
            jmpf ::temp0 _label4
            ; line 4257
            assign status "engaged" 
            jmp _label3
            ; line 4258
          _label4:
            callstatic mARAS IsNPCStatus ::temp0 akActor "candidate" ;2 variable args
            jmpf ::temp0 _label3
            ; line 4259
            assign status "candidate" 
            jmp _label3
            ; line 4261
          _label3:
            strcat ::temp2 " marasStatus=" status 
            strcat ::temp2 ::temp2 " playerSpouses=" 
            callstatic mARAS GetStatusCount ::temp3 "married" ;1 variable args
            cast ::temp4 ::temp3 
            strcat ::temp4 ::temp2 ::temp4 
            return ::temp4 
          .endCode
        .endFunction ;MarasStateLine
        .function MarasContext
           ; function type 0
          .userFlags 0 ;none
          .docString "The marriage facts, stated rather than inferred, for the three assessors.

      This is the npc_married lesson generalised. Elisif was authored
      ORIENTATION: WOMEN / BASIS: STATED - the one confidence level allowed to
      refuse - because the static bio says nothing about who she married, so the
      model was asked to infer with no evidence and obliged. Papyrus knew all
      along. The same was true of the talk assessor, which had no marriage
      vocabulary at all and paid a LANDMARK award for a wedding that had not
      happened and, with the polygamy quest incomplete, could not happen.

      INTS, NOT STRINGS, for the booleans. A context boolean fed by a String is
      the case-fold trap in another coat, and check.ps1 fails the build over it.

      npc_married sits OUTSIDE the MARAS guard on purpose: IsMarriedToPlayer
      reads the vanilla PlayerMarriedFaction first, so a vanilla marriage is
      still a fact when MARAS is absent.

      WE DO NOT GATE ON ANY OF THIS. Spouse tier is DEPTH, and a shield-sister
      who will never be a lover has to be able to reach it - gating it on a
      marriage system would collapse the two tracks back into one ladder. These
      are facts for the NPC to judge, which is the whole design."
          .return String
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local present Int
            .local married Int
            .local engaged Int
            .local candidate Int
            .local spouses Int
            .local ::temp0 Bool
            .local ::temp1 Int
            .local ::temp2 String
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 4286
            assign present 0 
            ; line 4287
            assign married 0 
            ; line 4288
            assign engaged 0 
            ; line 4289
            assign candidate 0 
            ; line 4290
            assign spouses 0 
            ; line 4291
            callstatic sNRom_Bridge IsMarriedToPlayer ::temp0 akActor ;1 variable args
            jmpf ::temp0 _label0
            ; line 4292
            assign married 1 
            jmp _label0
            ; line 4294
          _label0:
            callstatic sNRom_Bridge MarasPresent ::temp0 ;0 variable args
            jmpf ::temp0 _label1
            ; line 4295
            assign present 1 
            ; line 4296
            callstatic mARAS IsNPCStatus ::temp0 akActor "engaged" ;2 variable args
            jmpf ::temp0 _label2
            ; line 4297
            assign engaged 1 
            jmp _label2
            ; line 4299
          _label2:
            callstatic mARAS IsNPCStatus ::temp0 akActor "candidate" ;2 variable args
            jmpf ::temp0 _label3
            ; line 4300
            assign candidate 1 
            jmp _label3
            ; line 4302
          _label3:
            callstatic mARAS GetStatusCount ::temp1 "married" ;1 variable args
            assign spouses ::temp1 
            jmp _label1
            ; line 4304
          _label1:
            cast ::temp2 present 
            strcat ::temp2 ",\"maras_present\":" ::temp2 
            strcat ::temp2 ::temp2 ",\"npc_married\":" 
            cast ::temp3 married 
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 ",\"npc_engaged\":" 
            cast ::temp2 engaged 
            strcat ::temp2 ::temp3 ::temp2 
            strcat ::temp2 ::temp2 ",\"npc_candidate\":" 
            cast ::temp3 candidate 
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 ",\"player_spouse_count\":" 
            cast ::temp2 spouses 
            strcat ::temp2 ::temp3 ::temp2 
            return ::temp2 
          .endCode
        .endFunction ;MarasContext
        .function MarasPresent
           ; function type 0
          .userFlags 0 ;none
          .docString "GLOBAL and uncached, same reasoning as SeverActionsPresent: a Global has
      no instance state to cache into, and IsPluginInstalled is a cheap native
      lookup. Made Global when IsMarriedToPlayer had to be reachable from
      SNRom_Decorators. The previous version cached into _marasState and logged
      once on absence; the log line is the only thing lost, and it was DEBUG."
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 4313
            callstatic game IsPluginInstalled ::temp0 "TT_MARAS.esp" ;1 variable args
            return ::temp0 
          .endCode
        .endFunction ;MarasPresent
        .function SeedTarget
           ; function type 0
          .userFlags 0 ;none
          .docString "The point total this NPC's ALREADY-LIVED history justifies.

      Three signals, deliberately chosen because their ranges are KNOWN. This
      project has been burned repeatedly by calibrating against a scale nobody
      verified, so anything whose range I could not confirm from source is read
      and LOGGED but not allowed to move the number:

        SeverFollower_Rapport   -100..100  documented at
                                SeverActions_FollowerManager.psc:30
        GetRelationshipRank     -4..4      vanilla, 4 = Lover
        MARAS married/engaged   boolean

        MARAS GetPermanentAffection - range is UNDOCUMENTED and configurable at
        runtime via SetAffectionMinMax, so it contributes NOTHING and is only
        logged. Give it a ratio once a real save shows what values it takes.

      Rapport is the primary signal and replaces the LLM read of her diary that
      the original design called for: it is a persisted number expressing how
      she actually feels, earned in real play, for anyone who has ever traveled
      with the player. Deterministic beats judged, when the deterministic thing
      is measuring the right quantity.

      A tier is exactly 500. Confirmed by ColdSun directly on 2026-08-20, after
      two independent observations had already agreed: Romantasy's own UI on
      2026-08-03, and Kayla's seed landing precisely on tier 1. This was carried
      as an inference for weeks and this docstring outlived the evidence that
      settled it. The ratios below are still expressed against 500 and the caller
      still logs the tier that actually landed rather than trusting the
      arithmetic, which is worth keeping regardless."
          .return Int
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local best Int
            .local rank Int
            .local ::temp0 actor
            .local ::temp1 Int
            .local byRank Int
            .local ::temp2 Bool
            .local rapport Float
            .local ::temp3 Float
            .local byRapport Int
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 4354
            assign best 0 
            ; line 4399
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod GetRelationshipRank akActor ::temp1 ::temp0 ;1 variable args
            assign rank ::temp1 
            ; line 4400
            assign byRank 0 
            ; line 4401
            comp_gte ::temp2 rank 4 
            jmpf ::temp2 _label0
            ; line 4402
            assign byRank 1500 
            jmp _label1
            ; line 4403
          _label0:
            cmp_eq ::temp2 rank 3 
            jmpf ::temp2 _label2
            ; line 4404
            assign byRank 200 
            jmp _label1
            ; line 4405
          _label2:
            cmp_eq ::temp2 rank 2 
            jmpf ::temp2 _label3
            ; line 4406
            assign byRank 160 
            jmp _label1
            ; line 4407
          _label3:
            cmp_eq ::temp2 rank 1 
            jmpf ::temp2 _label4
            ; line 4408
            assign byRank 80 
            jmp _label1
            ; line 4409
          _label4:
            cmp_eq ::temp2 rank 0 
            jmpf ::temp2 _label1
            ; line 4410
            assign byRank 40 
            jmp _label1
            ; line 4412
          _label1:
            cmp_gt ::temp2 byRank best 
            jmpf ::temp2 _label5
            ; line 4413
            assign best byRank 
            jmp _label5
            ; line 4430
          _label5:
            callstatic sNRom_Bridge SeverActionsPresent ::temp2 ;0 variable args
            jmpf ::temp2 _label6
            ; line 4431
            callstatic severActionsNative Native_GetRapport ::temp3 akActor ;1 variable args
            assign rapport ::temp3 
            ; line 4432
            callstatic sNRom_Bridge CFG ::temp4 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp3 ::temp4 "seedPointsPerRapport" 15.0 ;3 variable args
            fmul ::temp3 rapport ::temp3 
            cast ::temp1 ::temp3 
            assign byRapport ::temp1 
            ; line 4433
            cmp_gt ::temp2 byRapport best 
            jmpf ::temp2 _label7
            ; line 4434
            assign best byRapport 
            jmp _label7
          _label7:
            jmp _label6
            ; line 4456
          _label6:
            callstatic sNRom_Bridge IsMarriedToPlayer ::temp2 akActor ;1 variable args
            jmpf ::temp2 _label8
            ; line 4457
            assign best 2500 
            jmp _label9
            ; line 4458
          _label8:
            callstatic sNRom_Bridge MarasPresent ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label10
            callstatic mARAS IsNPCStatus ::temp2 akActor "engaged" ;2 variable args
            assign ::temp2 ::temp2 
          _label10:
            jmpf ::temp2 _label9
            ; line 4459
            cmp_gt ::temp2 2000 best 
            jmpf ::temp2 _label11
            ; line 4460
            assign best 2000 
            jmp _label11
          _label11:
            jmp _label9
            ; line 4464
          _label9:
            return best 
          .endCode
        .endFunction ;SeedTarget
        .function CommitmentState
           ; function type 0
          .userFlags 0 ;none
          .docString "How far this person has formally committed: 0 nothing, 1 candidate,
      2 engaged, 3 married. Ordered on purpose, so a rising number is a real
      step forward and a falling one is a real step back.

      READ, NEVER RECORDED. MARAS already owns this state machine -
      candidate, engaged, married, divorced, jilted - and vanilla owns
      PlayerMarriedFaction. Keeping our own copy would mean two records that
      can disagree, and the one that disagrees is always ours, because a
      marriage or a divorce can happen entirely through their dialogue while
      nothing tells us about it.

      Married is checked FIRST and by IsMarriedToPlayer, which accepts either
      the vanilla faction or MARAS, because a completed marriage outranks any
      earlier rung regardless of which mod recorded it. Without MARAS the
      middle two rungs simply do not exist and this collapses to 0 or 3, which
      is the correct answer for a game that only models the wedding.

      THE DASHBOARD DRAWS A COPY OF THIS: Display::Commitment in
      native/src/Display.cpp, line for line. Change one, change both."
          .return Int
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 4487
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 4488
            return 0 
            jmp _label0
            ; line 4490
          _label0:
            callstatic sNRom_Bridge IsMarriedToPlayer ::temp1 akActor ;1 variable args
            jmpf ::temp1 _label1
            ; line 4491
            return 3 
            jmp _label1
            ; line 4493
          _label1:
            callstatic sNRom_Bridge MarasPresent ::temp1 ;0 variable args
            jmpf ::temp1 _label2
            ; line 4494
            callstatic mARAS IsNPCStatus ::temp1 akActor "engaged" ;2 variable args
            jmpf ::temp1 _label3
            ; line 4495
            return 2 
            jmp _label3
            ; line 4497
          _label3:
            callstatic mARAS IsNPCStatus ::temp1 akActor "candidate" ;2 variable args
            jmpf ::temp1 _label4
            ; line 4498
            return 1 
            jmp _label4
          _label4:
            jmp _label2
            ; line 4501
          _label2:
            return 0 
          .endCode
        .endFunction ;CommitmentState
        .function IsMarriedToPlayer
           ; function type 0
          .userFlags 0 ;none
          .docString "Married, by whichever system the player actually uses. Vanilla and MARAS
      both count and neither is preferred - the question is whether the game
      records a completed marriage, not which mod recorded it.

      GLOBAL so SNRom_Decorators.RomanceOk can reach it. That gate runs on
      authored orientation, and an authored trait must never be able to
      contradict a recorded marriage - see the note there.

      THE DASHBOARD DRAWS A COPY OF THIS: Display::MarriedToPlayer in
      native/src/Display.cpp, line for line. Change one, change both."
          .return Bool
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local married faction
            .local ::temp2 form
            .local ::temp3 faction
          .endLocalTable
          .code
            ; line 4514
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 4515
            return False 
            jmp _label0
            ; line 4517
          _label0:
            callstatic game GetFormFromFile ::temp2 812146 "Skyrim.esm" ;2 variable args
            cast ::temp3 ::temp2 
            assign married ::temp3 
            ; line 4518
            cast ::temp3 None 
            cmp_eq ::temp1 married ::temp3 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            callmethod IsInFaction akActor ::temp1 married ;1 variable args
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 4519
            return True 
            jmp _label2
            ; line 4521
          _label2:
            callstatic sNRom_Bridge MarasPresent ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label3
            callstatic mARAS IsNPCStatus ::temp1 akActor "married" ;2 variable args
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 4522
            return True 
            jmp _label4
            ; line 4524
          _label4:
            return False 
          .endCode
        .endFunction ;IsMarriedToPlayer
        .function SeedRomanticEvidence
           ; function type 0
          .userFlags 0 ;none
          .docString "EXPLICIT DECLARATIONS ONLY. Not points, not tier, not rapport, not
      affection - none of those say two people are together, they say the
      relationship has depth, and depth is exactly what a close platonic
      companion of many years also has.

      NOT RELATIONSHIP RANK 4 EITHER, which this used to accept.

      That was the same conflation the seeding table exists to undo. Vanilla has
      exactly one axis and calls its top of it "Lover", so rank 4 has to carry
      both "we are extremely close" and "we are together" at once. This mod
      splits those deliberately - THE SAPPHIRE CASE IS THE WHOLE POINT: a
      Confidant, or even a Friend, may well go to bed with the player for its
      own sake while wanting none of the commitment that Lover implies. Vanilla
      cannot express that; we can, through the authored INTIMACY axis and the
      attraction bypass, and rank 4 must not quietly overrule it.

      So rank 4 seeds DEPTH (1500, Confidant - see SeedTarget) and says nothing
      here. What counts is an actual ceremony: PlayerMarriedFaction, or MARAS
      reporting married/engaged. Those are declarations; a rank is a summary.

      This gates nothing on its own; it only lets the spark assessor look early.
      Someone at rank 4 who really is in love simply reaches that verdict the
      ordinary way, on evidence, after the tenure gate - which costs two game
      days and is exactly the wait the gate was built to impose."
          .return Bool
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local married faction
            .local ::temp0 form
            .local ::temp1 faction
            .local ::temp2 Bool
          .endLocalTable
          .code
            ; line 4552
            callstatic game GetFormFromFile ::temp0 812146 "Skyrim.esm" ;2 variable args
            cast ::temp1 ::temp0 
            assign married ::temp1 
            ; line 4553
            cast ::temp1 None 
            cmp_eq ::temp2 married ::temp1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label0
            callmethod IsInFaction akActor ::temp2 married ;1 variable args
            assign ::temp2 ::temp2 
          _label0:
            jmpf ::temp2 _label1
            ; line 4554
            return True 
            jmp _label1
            ; line 4556
          _label1:
            callstatic sNRom_Bridge MarasPresent ::temp2 ;0 variable args
            jmpf ::temp2 _label2
            ; line 4557
            callstatic mARAS IsNPCStatus ::temp2 akActor "married" ;2 variable args
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label3
            callstatic mARAS IsNPCStatus ::temp2 akActor "engaged" ;2 variable args
            assign ::temp2 ::temp2 
          _label3:
            jmpf ::temp2 _label4
            ; line 4558
            return True 
            jmp _label4
          _label4:
            jmp _label2
            ; line 4561
          _label2:
            return False 
          .endCode
        .endFunction ;SeedRomanticEvidence
        .function SeedActor
           ; function type 0
          .userFlags 0 ;none
          .docString "Seed ONE follower, once ever. Safe to call repeatedly - it is a no-op
      after it succeeds, and a rejected attempt changes nothing at all.

      RETURNS whether the seed is now SETTLED for this actor, which is not the
      same as "points were awarded": needing none is just as settled as being
      given some. Only a REJECTION is unsettled. SeedNextActor spends its
      one-per-tick budget on that distinction."
          .return Bool
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 String
            .local ::temp3 form
            .local ::temp4 Int
            .local target Int
            .local cap Int
            .local ::nonevar None
            .local ::temp5 String
            .local current Int
            .local delta Int
            .local applied Bool
            .local rapportNow Float
            .local ::temp6 Float
            .local affection Int
            .local ::temp7 Int
          .endLocalTable
          .code
            ; line 4572
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 4573
            return False 
            jmp _label1
            ; line 4575
          _label1:
            callstatic sNRom_Bridge CFG ::temp2 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp1 ::temp2 "seedEnabled" True ;3 variable args
            cmp_eq ::temp1 ::temp1 False 
            jmpf ::temp1 _label2
            ; line 4576
            return False 
            jmp _label2
            ; line 4578
          _label2:
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp4 ::temp3 "SNRom_Seeded" 0 ;3 variable args
            cmp_eq ::temp1 ::temp4 1 
            jmpf ::temp1 _label3
            ; line 4579
            return True 
            jmp _label3
            ; line 4582
          _label3:
            callmethod SeedTarget self ::temp4 akActor ;1 variable args
            assign target ::temp4 
            ; line 4583
            callstatic sNRom_Bridge CFG ::temp2 ;0 variable args
            callstatic skyrimNetApi GetConfigInt ::temp4 ::temp2 "seedMaxPoints" 2000 ;3 variable args
            assign cap ::temp4 
            ; line 4591
            callstatic sNRom_Bridge IsMarriedToPlayer ::temp1 akActor ;1 variable args
            jmpf ::temp1 _label4
            ; line 4592
            assign cap 2500 
            jmp _label4
            ; line 4594
          _label4:
            cmp_gt ::temp1 target cap 
            jmpf ::temp1 _label5
            ; line 4595
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            strcat ::temp2 "Seeding: " ::temp2 
            strcat ::temp2 ::temp2 " computed " 
            cast ::temp5 target 
            strcat ::temp5 ::temp2 ::temp5 
            strcat ::temp5 ::temp5 " but the cap is " 
            ; line 4596
            cast ::temp2 cap 
            strcat ::temp2 ::temp5 ::temp2 
            strcat ::temp2 ::temp2 " - seeding must never hand out the top of the ladder" 
            callmethod Diag self ::nonevar ::temp4 ::temp2 False ;3 variable args
            ; line 4597
            assign target cap 
            jmp _label5
            ; line 4611
          _label5:
            callstatic sNRom_Bridge PointsOf ::temp4 akActor ;1 variable args
            assign current ::temp4 
            ; line 4612
            isub ::temp4 target current 
            assign delta ::temp4 
            ; line 4613
            cmp_lte ::temp1 delta 0 
            jmpf ::temp1 _label6
            ; line 4614
            cast ::temp3 akActor 
            callstatic storageUtil SetIntValue ::temp4 ::temp3 "SNRom_Seeded" 1 ;3 variable args
            ; line 4615
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            strcat ::temp2 "Seeding: " ::temp2 
            strcat ::temp2 ::temp2 " needs none - history justifies " 
            ; line 4616
            cast ::temp5 target 
            strcat ::temp5 ::temp2 ::temp5 
            strcat ::temp5 ::temp5 " and they already have " 
            cast ::temp2 current 
            strcat ::temp2 ::temp5 ::temp2 
            callmethod Diag self ::nonevar ::temp4 ::temp2 False ;3 variable args
            ; line 4617
            callmethod SeedRomanticFlag self ::nonevar akActor ;1 variable args
            ; line 4618
            return True 
            jmp _label6
            ; line 4626
          _label6:
            callmethod ApplyDepth self ::temp4 akActor delta "Prior history together" True "seed" ;5 variable args
            cmp_gt ::temp1 ::temp4 0 
            assign applied ::temp1 
            ; line 4627
            not ::temp1 applied 
            jmpf ::temp1 _label7
            ; line 4630
            callstatic sNRom_Bridge LOG_DEBUG ::temp4 ;0 variable args
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            strcat ::temp2 "Seeding: the seed for " ::temp2 
            strcat ::temp2 ::temp2 " did not land - will retry on the next check." 
            callmethod Diag self ::nonevar ::temp4 ::temp2 False ;3 variable args
            ; line 4632
            return False 
            jmp _label7
            ; line 4635
          _label7:
            cast ::temp3 akActor 
            callstatic storageUtil SetIntValue ::temp4 ::temp3 "SNRom_Seeded" 1 ;3 variable args
            ; line 4636
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            strcat ::temp2 "Seeding: " ::temp2 
            strcat ::temp2 ::temp2 " granted " 
            cast ::temp5 delta 
            strcat ::temp5 ::temp2 ::temp5 
            strcat ::temp5 ::temp5 " pts of prior history, now at " 
            ; line 4637
            cast ::temp2 target 
            strcat ::temp2 ::temp5 ::temp2 
            strcat ::temp2 ::temp2 ". Deliberately not pace-scaled." 
            callmethod Diag self ::nonevar ::temp4 ::temp2 False ;3 variable args
            ; line 4642
            assign rapportNow 0.0 
            ; line 4643
            callstatic sNRom_Bridge SeverActionsPresent ::temp1 ;0 variable args
            jmpf ::temp1 _label8
            ; line 4644
            callstatic severActionsNative Native_GetRapport ::temp6 akActor ;1 variable args
            assign rapportNow ::temp6 
            jmp _label8
            ; line 4646
          _label8:
            cast ::temp3 akActor 
            callstatic storageUtil SetFloatValue ::temp6 ::temp3 "SNRom_SeedRapportAt" rapportNow ;3 variable args
            ; line 4647
            callmethod Ledger self ::nonevar akActor "seed" "" delta 1 "Prior history together" ;6 variable args
            ; line 4653
            assign affection -1 
            ; line 4654
            callstatic sNRom_Bridge MarasPresent ::temp1 ;0 variable args
            jmpf ::temp1 _label9
            ; line 4655
            callstatic mARAS GetPermanentAffection ::temp4 akActor ;1 variable args
            assign affection ::temp4 
            jmp _label9
            ; line 4657
          _label9:
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            strcat ::temp2 "Seeded " ::temp2 
            strcat ::temp2 ::temp2 " +" 
            cast ::temp5 delta 
            strcat ::temp5 ::temp2 ::temp5 
            strcat ::temp5 ::temp5 " -> " 
            ; line 4658
            callstatic sNRom_Bridge PointsOf ::temp7 akActor ;1 variable args
            cast ::temp2 ::temp7 
            strcat ::temp2 ::temp5 ::temp2 
            strcat ::temp2 ::temp2 " pts, tier " 
            callstatic sNRom_Bridge TierOf ::temp7 akActor ;1 variable args
            cast ::temp5 ::temp7 
            strcat ::temp5 ::temp2 ::temp5 
            strcat ::temp5 ::temp5 " (" 
            ; line 4659
            callstatic sNRom_Bridge TierOf ::temp7 akActor ;1 variable args
            callstatic sNRom_Bridge TierName ::temp2 ::temp7 ;1 variable args
            strcat ::temp2 ::temp5 ::temp2 
            strcat ::temp2 ::temp2 "). rapport=" 
            cast ::temp5 rapportNow 
            strcat ::temp5 ::temp2 ::temp5 
            strcat ::temp5 ::temp5 " rank=" 
            ; line 4660
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod GetRelationshipRank akActor ::temp7 ::temp0 ;1 variable args
            cast ::temp2 ::temp7 
            strcat ::temp2 ::temp5 ::temp2 
            strcat ::temp2 ::temp2 " marasAffection=" 
            ; line 4661
            cast ::temp5 affection 
            strcat ::temp5 ::temp2 ::temp5 
            strcat ::temp5 ::temp5 " (logged for calibration only, unused)" 
            callstatic sNRom_Bridge MarasStateLine ::temp2 akActor ;1 variable args
            strcat ::temp2 ::temp5 ::temp2 
            callmethod Diag self ::nonevar ::temp4 ::temp2 False ;3 variable args
            ; line 4663
            callmethod SeedRomanticFlag self ::nonevar akActor ;1 variable args
            ; line 4664
            return True 
          .endCode
        .endFunction ;SeedActor
        .function SeedRomanticFlag
           ; function type 0
          .userFlags 0 ;none
          .docString "Separate from the points seed because it must survive the points seed
      being rejected, capped, or already satisfied - none of which say anything
      about whether the game records these two as together."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local ::nonevar None
            .local ::temp4 String
            .local changed Bool
            .local ::temp5 Int
            .local ::temp6 Float
          .endLocalTable
          .code
            ; line 4672
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            callmethod IsChild akActor ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 4673
            return None 
            jmp _label1
            ; line 4675
          _label1:
            callmethod SeedRomanticEvidence self ::temp1 akActor ;1 variable args
            jmpf ::temp1 _label2
            ; line 4676
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_SeedRomantic" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label3
            ; line 4677
            cast ::temp2 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_SeedRomantic" 1 ;3 variable args
            ; line 4678
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "Seeding: the game already records " ::temp4 
            strcat ::temp4 ::temp4 " and the player as together, so they skip the wait before romance can be judged. " 
            ; line 4679
            strcat ::temp4 ::temp4 "This does NOT set the spark - the assessor still decides." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
            jmp _label3
          _label3:
            jmp _label2
            ; line 4702
          _label2:
            callstatic sNRom_Bridge IsMarriedToPlayer ::temp1 akActor ;1 variable args
            jmpf ::temp1 _label4
            ; line 4703
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Sparked" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label5
            ; line 4704
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_PlayerStance" 0 ;3 variable args
            callstatic sNRom_Bridge STANCE_ACCEPTED ::temp5 ;0 variable args
            cmp_eq ::temp1 ::temp3 ::temp5 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label5:
            assign changed ::temp1 
            ; line 4705
            cast ::temp2 akActor 
            callstatic storageUtil SetIntValue ::temp5 ::temp2 "SNRom_Sparked" 1 ;3 variable args
            ; line 4706
            cast ::temp2 akActor 
            callstatic storageUtil GetFloatValue ::temp6 ::temp2 "SNRom_SparkedAt" 0.0 ;3 variable args
            cmp_lte ::temp1 ::temp6 0.0 
            jmpf ::temp1 _label6
            ; line 4707
            cast ::temp2 akActor 
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp6 ::temp2 "SNRom_SparkedAt" ::temp6 ;3 variable args
            jmp _label6
            ; line 4709
          _label6:
            cast ::temp2 akActor 
            callstatic sNRom_Bridge STANCE_ACCEPTED ::temp5 ;0 variable args
            callstatic storageUtil SetIntValue ::temp5 ::temp2 "SNRom_PlayerStance" ::temp5 ;3 variable args
            ; line 4710
            callmethod IEB_WriteRomTrack self ::nonevar akActor ;1 variable args
            ; line 4711
            jmpf changed _label7
            ; line 4712
            callstatic sNRom_Bridge LOG_INFO ::temp5 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "Seeding: " ::temp4 
            strcat ::temp4 ::temp4 " is MARRIED to the player - " 
            strcat ::temp4 ::temp4 "romantic ladder and player stance set directly from the ceremony, not judged. " 
            ; line 4713
            strcat ::temp4 ::temp4 "No spark assessment needed; there is nothing left to decide." 
            callmethod Diag self ::nonevar ::temp5 ::temp4 False ;3 variable args
            jmp _label7
          _label7:
            jmp _label4
          _label4
          .endCode
        .endFunction ;SeedRomanticFlag
        .function SPOUSE_MIN
           ; function type 0
          .userFlags 0 ;none
          .docString "Points at which Romantasy calls someone "Spouse", and the rung the author's
      ladder makes a formal marriage proposal eligible at.

      Stranger to Confidant is free. Crossing into Lover pops the consent
      question. Lover to Spouse is free. Crossing Spouse is what earns the right
      to be asked - and the proposal and its acceptance ARE the consent to marry,
      which is why there is no second question here."
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 4727
            return 2500 
          .endCode
        .endFunction ;SPOUSE_MIN
        .function IgnoreProposalKeyword
           ; function type 0
          .userFlags 0 ;none
          .docString "MARAS's own exclusion keyword, resolved by editor ID.

      LOGS LOUDLY ON None RATHER THAN RETURNING QUIETLY. MARAS resolves this
      through its own getter (GetIgnoreProposeKeyword), so if they ever rename the
      record our hardcoded string stops matching, Keyword.GetKeyword returns None,
      and a gate that silently stops gating is worse than no gate at all."
          .return keyword
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 keyword
          .endLocalTable
          .code
            ; line 4737
            callstatic keyword GetKeyword ::temp0 "TTM_IgnoreProposal" ;1 variable args
            return ::temp0 
          .endCode
        .endFunction ;IgnoreProposalKeyword
        .function MaintainProposalGate
           ; function type 0
          .userFlags 0 ;none
          .docString "Keep MARAS's proposal exclusion in step with the ladder: present below
      Spouse, absent at or above it.

      THIS IS THE SECONDARY GATE, NOT THE PRIMARY ONE, and that is worth saying
      plainly. MARAS consults the keyword in two places - a CK condition on its
      vanilla dialogue topic, and AcceptProposalIsElgigible for the SkyrimNet
      action. On a SkyrimNet setup NEITHER runs:

        - the vanilla topic is suppressed while TTM_MCM_AllowAIDial is on, which
          is why no proposal option appears in her dialogue at all
        - the action's eligibility is a Papyrus call, and SkyrimNet refuses
          Papyrus calls while the game is paused - which it always is during
          dialogue. Measured 2026-08-31: "CheckActionEligibility: Blocking VM
          call for action ACCEPTMARRIAGEPROPOSAL because game is paused", 40
          times in one session, and the action is then offered ANYWAY. Eligibility
          fails OPEN.

      So this is maintained for the setups where it does bite, and because it
      costs almost nothing. The gate that actually holds is the event handler.

      CHEAP BY CONSTRUCTION. One HasKeyword native, and it only writes when the
      desired state differs from the current one - so the steady state is a single
      read per point change and nothing else."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local kw keyword
            .local ::temp2 keyword
            .local ::temp3 form
            .local ::temp4 Int
            .local ::temp5 Int
            .local ::temp6 form
            .local ::nonevar None
            .local ::temp7 String
            .local shouldBlock Bool
            .local isBlocked Bool
            .local ::temp8 objectReference
            .local ::temp9 String
            .local ::temp10 actorBase
          .endLocalTable
          .code
            ; line 4764
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 4765
            return None 
            jmp _label1
            ; line 4767
          _label1:
            callstatic sNRom_Bridge IgnoreProposalKeyword ::temp2 ;0 variable args
            assign kw ::temp2 
            ; line 4768
            cast ::temp2 None 
            cmp_eq ::temp1 kw ::temp2 
            jmpf ::temp1 _label2
            ; line 4771
            cast ::temp3 None 
            callstatic storageUtil GetIntValue ::temp4 ::temp3 "SNRom_WarnedNoProposalKw" 0 ;3 variable args
            ; line 4772
            cast ::temp3 None 
            callstatic storageUtil GetIntValue ::temp5 ::temp3 "SNRom_SessionId" 0 ;3 variable args
            cmp_eq ::temp1 ::temp4 ::temp5 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label3
            ; line 4773
            cast ::temp3 None 
            ; line 4774
            cast ::temp6 None 
            callstatic storageUtil GetIntValue ::temp5 ::temp6 "SNRom_SessionId" 0 ;3 variable args
            callstatic storageUtil SetIntValue ::temp5 ::temp3 "SNRom_WarnedNoProposalKw" ::temp5 ;3 variable args
            ; line 4775
            callstatic sNRom_Bridge LOG_ERROR ::temp5 ;0 variable args
            strcat ::temp7 "TTM_IgnoreProposal did not resolve, so the marriage " "gate cannot be applied. Either MARAS is absent - in which case this " 
            ; line 4776
            strcat ::temp7 ::temp7 "is harmless - or the keyword has been renamed and the gate is now " 
            ; line 4777
            strcat ::temp7 ::temp7 "silently inert." 
            callmethod Diag self ::nonevar ::temp5 ::temp7 False ;3 variable args
            jmp _label3
            ; line 4780
          _label3:
            return None 
            jmp _label2
            ; line 4782
          _label2:
            callstatic sNRom_Bridge PointsOf ::temp5 akActor ;1 variable args
            callstatic sNRom_Bridge SPOUSE_MIN ::temp4 ;0 variable args
            cmp_lt ::temp1 ::temp5 ::temp4 
            assign shouldBlock ::temp1 
            ; line 4783
            callmethod HasKeyword akActor ::temp1 kw ;1 variable args
            assign isBlocked ::temp1 
            ; line 4784
            cmp_eq ::temp1 shouldBlock isBlocked 
            jmpf ::temp1 _label4
            ; line 4785
            return None 
            jmp _label4
            ; line 4787
          _label4:
            jmpf shouldBlock _label5
            ; line 4788
            cast ::temp8 akActor 
            callstatic pO3_SKSEFunctions AddKeywordToRef ::nonevar ::temp8 kw ;2 variable args
            ; line 4789
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            callmethod GetDisplayName akActor ::temp7 ;0 variable args
            strcat ::temp7 "Marriage gate closed for " ::temp7 
            strcat ::temp7 ::temp7 " - below Spouse at " 
            ; line 4790
            callstatic sNRom_Bridge PointsOf ::temp5 akActor ;1 variable args
            cast ::temp9 ::temp5 
            strcat ::temp9 ::temp7 ::temp9 
            strcat ::temp9 ::temp9 " pts." 
            callmethod Diag self ::nonevar ::temp4 ::temp9 False ;3 variable args
            jmp _label6
            ; line 4792
          _label5:
            cast ::temp8 akActor 
            callstatic pO3_SKSEFunctions RemoveKeywordFromRef ::nonevar ::temp8 kw ;2 variable args
            ; line 4793
            callmethod GetActorBase akActor ::temp10 ;0 variable args
            cast ::temp3 ::temp10 
            callstatic pO3_SKSEFunctions RemoveKeywordOnForm ::nonevar ::temp3 kw ;2 variable args
            ; line 4794
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            callmethod GetDisplayName akActor ::temp9 ;0 variable args
            strcat ::temp9 "Marriage gate OPEN for " ::temp9 
            strcat ::temp9 ::temp9 " - reached Spouse at " 
            ; line 4795
            callstatic sNRom_Bridge PointsOf ::temp5 akActor ;1 variable args
            cast ::temp7 ::temp5 
            strcat ::temp7 ::temp9 ::temp7 
            strcat ::temp7 ::temp7 " pts. A formal " 
            strcat ::temp7 ::temp7 "proposal is now earned." 
            callmethod Diag self ::nonevar ::temp4 ::temp7 False ;3 variable args
          _label6
          .endCode
        .endFunction ;MaintainProposalGate
        .function OnMarasStatusChanged
           ; function type 0
          .userFlags 0 ;none
          .docString "MARAS announced a relationship change. TWO statuses matter, and the second
      one was added later - this docstring said "other statuses are ignored:
      engagement is already read at seed time" while the code below had stopped
      ignoring it, which is the sort of comment that gets believed.

      ENGAGED is the marriage gate, and it is the one that actually holds. See
      the note at the branch for why enforcement has to happen on an event rather
      than through eligibility, and why engagement rather than marriage is the
      intercept.

      MARRIED re-seeds rather than topping up, because ReseedActor clears the
      stamp and re-runs the whole computation, which will now see the marriage and
      land on Spouse. That re-seed is ASYNCHRONOUS since it became a record read,
      so it can be deferred behind a pending one - which is why ReconcileMarriages
      and not this is what guarantees a spouse reaches the Spouse floor.

      A DIVORCE MUST NOT CLAW POINTS BACK - those were earned, and Romantasy owns
      what a break-up costs. Candidate and jilted are genuinely ignored."
          .return None
          .paramTable
            .param asEventName String
            .param asStatus String
            .param afStatusEnum Float
            .param akSender form
          .endParamTable
          .localTable
            .local who actor
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ieSt String
            .local ::temp2 String
            .local st String
            .local ::temp3 form
            .local ::temp4 Int
            .local ::temp5 Int
            .local ::temp6 String
            .local held Int
          .endLocalTable
          .code
            ; line 4819
            cast ::temp0 akSender 
            assign who ::temp0 
            ; line 4820
            cast ::temp0 None 
            cmp_eq ::temp1 who ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 4821
            return None 
            jmp _label1
            ; line 4824
          _label1:
            callmethod RefreshPartnerCount self ::nonevar ;0 variable args
            ; line 4826
            callstatic sNRom_Decorators Trim ::temp2 asStatus ;1 variable args
            callstatic sNRom_Decorators Upper ::temp2 ::temp2 ;1 variable args
            assign ieSt ::temp2 
            ; line 4827
            cmp_eq ::temp1 ieSt "CANDIDATE" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label2
            cmp_eq ::temp1 ieSt "ENGAGED" 
            assign ::temp1 ::temp1 
          _label2:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label3
            cmp_eq ::temp1 ieSt "MARRIED" 
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 4828
            callmethod IEB_EnrollOnCourtship self ::temp1 who ;1 variable args
            jmp _label4
            ; line 4830
          _label4:
            callmethod IEB_WriteRomTrack self ::nonevar who ;1 variable args
            ; line 4831
            callstatic sNRom_Bridge IsEnrolled ::temp1 who ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label5
            ; line 4832
            return None 
            jmp _label5
            ; line 4834
          _label5:
            callstatic sNRom_Decorators Trim ::temp2 asStatus ;1 variable args
            callstatic sNRom_Decorators Upper ::temp2 ::temp2 ;1 variable args
            assign st ::temp2 
            ; line 4851
            cmp_eq ::temp1 st "ENGAGED" 
            jmpf ::temp1 _label6
            ; line 4853
            cast ::temp3 who 
            callstatic storageUtil GetIntValue ::temp4 ::temp3 "SNRom_Exclusivity" 50 ;3 variable args
            callstatic sNRom_Bridge CONSUMING_MIN ::temp5 ;0 variable args
            comp_gte ::temp1 ::temp4 ::temp5 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label7
            callstatic sNRom_Decorators OtherPartners ::temp5 who ;1 variable args
            cmp_gt ::temp1 ::temp5 0 
            assign ::temp1 ::temp1 
          _label7:
            jmpf ::temp1 _label8
            ; line 4854
            callstatic mARAS PromoteNPCToStatus ::temp1 who "candidate" ;2 variable args
            jmpf ::temp1 _label9
            ; line 4855
            callmethod GetFormID who ::temp5 ;0 variable args
            cast ::temp2 ::temp5 
            strcat ::temp2 "ieb_excl_refusal_" ::temp2 
            ; line 4856
            callmethod GetDisplayName who ::temp6 ;0 variable args
            strcat ::temp6 ::temp6 " would not join a shared marriage" 
            callstatic game GetPlayer ::temp0 ;0 variable args
            callstatic skyrimNetApi RegisterShortLivedEvent ::temp5 ::temp2 "ieb_exclusivity_refusal" ::temp6 "" 300000 who ::temp0 ;7 variable args
            ; line 4857
            callstatic sNRom_Bridge LOG_INFO ::temp5 ;0 variable args
            callmethod GetDisplayName who ::temp6 ;0 variable args
            strcat ::temp6 "Engagement refused for " ::temp6 
            strcat ::temp6 ::temp6 " - exclusivity " 
            ; line 4858
            cast ::temp3 who 
            callstatic storageUtil GetIntValue ::temp4 ::temp3 "SNRom_Exclusivity" 50 ;3 variable args
            cast ::temp2 ::temp4 
            strcat ::temp2 ::temp6 ::temp2 
            strcat ::temp2 ::temp2 " >= " 
            callstatic sNRom_Bridge CONSUMING_MIN ::temp4 ;0 variable args
            cast ::temp6 ::temp4 
            strcat ::temp6 ::temp2 ::temp6 
            strcat ::temp6 ::temp6 " with " 
            ; line 4859
            callstatic sNRom_Decorators OtherPartners ::temp4 who ;1 variable args
            cast ::temp2 ::temp4 
            strcat ::temp2 ::temp6 ::temp2 
            strcat ::temp2 ::temp2 " other partner(s); back to candidate." 
            callstatic sNRom_Bridge MarasStateLine ::temp6 who ;1 variable args
            strcat ::temp6 ::temp2 ::temp6 
            callmethod Diag self ::nonevar ::temp5 ::temp6 False ;3 variable args
            jmp _label10
            ; line 4861
          _label9:
            callstatic sNRom_Bridge LOG_ERROR ::temp5 ;0 variable args
            callmethod GetDisplayName who ::temp6 ;0 variable args
            strcat ::temp6 "MARAS refused to demote " ::temp6 
            strcat ::temp6 ::temp6 " after an exclusivity refusal." 
            ; line 4862
            callstatic sNRom_Bridge MarasStateLine ::temp2 who ;1 variable args
            strcat ::temp2 ::temp6 ::temp2 
            callmethod Diag self ::nonevar ::temp5 ::temp2 False ;3 variable args
            ; line 4864
          _label10:
            return None 
            jmp _label8
            ; line 4866
          _label8:
            callstatic sNRom_Bridge PointsOf ::temp5 who ;1 variable args
            assign held ::temp5 
            ; line 4867
            callstatic sNRom_Bridge SPOUSE_MIN ::temp5 ;0 variable args
            cmp_lt ::temp1 held ::temp5 
            jmpf ::temp1 _label11
            ; line 4868
            callstatic mARAS PromoteNPCToStatus ::temp1 who "candidate" ;2 variable args
            jmpf ::temp1 _label12
            ; line 4869
            callstatic sNRom_Bridge LOG_INFO ::temp5 ;0 variable args
            callmethod GetDisplayName who ::temp2 ;0 variable args
            strcat ::temp2 "Engagement reversed for " ::temp2 
            strcat ::temp2 ::temp2 " - they hold " 
            ; line 4870
            cast ::temp6 held 
            strcat ::temp6 ::temp2 ::temp6 
            strcat ::temp6 ::temp6 " pts and Spouse begins at " 
            callstatic sNRom_Bridge SPOUSE_MIN ::temp4 ;0 variable args
            cast ::temp2 ::temp4 
            strcat ::temp2 ::temp6 ::temp2 
            strcat ::temp2 ::temp2 ". A formal proposal is not earned yet, so they are back to candidate. " 
            ; line 4871
            strcat ::temp2 ::temp2 "Nothing else changes and nothing is lost." 
            ; line 4872
            callstatic sNRom_Bridge MarasStateLine ::temp6 who ;1 variable args
            strcat ::temp6 ::temp2 ::temp6 
            callmethod Diag self ::nonevar ::temp5 ::temp6 False ;3 variable args
            jmp _label13
            ; line 4874
          _label12:
            callstatic sNRom_Bridge LOG_ERROR ::temp5 ;0 variable args
            callmethod GetDisplayName who ::temp6 ;0 variable args
            strcat ::temp6 "MARAS refused to demote " ::temp6 
            strcat ::temp6 ::temp6 " from engaged, so the marriage gate has leaked. They hold " 
            ; line 4875
            cast ::temp2 held 
            strcat ::temp2 ::temp6 ::temp2 
            strcat ::temp2 ::temp2 " pts against a Spouse floor of " 
            ; line 4876
            callstatic sNRom_Bridge SPOUSE_MIN ::temp4 ;0 variable args
            cast ::temp6 ::temp4 
            strcat ::temp6 ::temp2 ::temp6 
            strcat ::temp6 ::temp6 "." 
            callstatic sNRom_Bridge MarasStateLine ::temp2 who ;1 variable args
            strcat ::temp2 ::temp6 ::temp2 
            callmethod Diag self ::nonevar ::temp5 ::temp2 False ;3 variable args
            ; line 4878
          _label13:
            return None 
            jmp _label11
            ; line 4880
          _label11:
            callstatic sNRom_Bridge LOG_INFO ::temp5 ;0 variable args
            callmethod GetDisplayName who ::temp2 ;0 variable args
            strcat ::temp2 "Engagement allowed for " ::temp2 
            strcat ::temp2 ::temp2 " - " 
            ; line 4881
            cast ::temp6 held 
            strcat ::temp6 ::temp2 ::temp6 
            strcat ::temp6 ::temp6 " pts is at or past Spouse." 
            callstatic sNRom_Bridge MarasStateLine ::temp2 who ;1 variable args
            strcat ::temp2 ::temp6 ::temp2 
            callmethod Diag self ::nonevar ::temp5 ::temp2 False ;3 variable args
            ; line 4882
            return None 
            jmp _label6
            ; line 4885
          _label6:
            cmp_eq ::temp1 st "MARRIED" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label14
            ; line 4886
            return None 
            jmp _label14
            ; line 4893
          _label14:
            callstatic sNRom_Bridge PointsOf ::temp5 who ;1 variable args
            callstatic sNRom_Bridge SPOUSE_MIN ::temp4 ;0 variable args
            cmp_lt ::temp1 ::temp5 ::temp4 
            jmpf ::temp1 _label15
            ; line 4894
            callstatic sNRom_Bridge LOG_ERROR ::temp4 ;0 variable args
            callmethod GetDisplayName who ::temp2 ;0 variable args
            strcat ::temp2 "MARRIED BELOW SPOUSE: " ::temp2 
            strcat ::temp2 ::temp2 " holds " 
            ; line 4895
            callstatic sNRom_Bridge PointsOf ::temp5 who ;1 variable args
            cast ::temp6 ::temp5 
            strcat ::temp6 ::temp2 ::temp6 
            strcat ::temp6 ::temp6 " pts against a floor of " 
            callstatic sNRom_Bridge SPOUSE_MIN ::temp5 ;0 variable args
            cast ::temp2 ::temp5 
            strcat ::temp2 ::temp6 ::temp2 
            strcat ::temp2 ::temp2 ". The proposal gate was bypassed - most likely accepted during paused " 
            ; line 4896
            strcat ::temp2 ::temp2 "dialogue, where SkyrimNet skips Papyrus eligibility. Not undone: a " 
            ; line 4897
            strcat ::temp2 ::temp2 "recorded marriage is left standing." 
            ; line 4898
            callstatic sNRom_Bridge MarasStateLine ::temp6 who ;1 variable args
            strcat ::temp6 ::temp2 ::temp6 
            callmethod Diag self ::nonevar ::temp4 ::temp6 False ;3 variable args
            jmp _label15
            ; line 4900
          _label15:
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            callmethod GetDisplayName who ::temp6 ;0 variable args
            strcat ::temp6 "MARAS reports " ::temp6 
            strcat ::temp6 ::temp6 " is now married - re-seeding so the Spouse ceiling applies." 
            ; line 4901
            callstatic sNRom_Bridge MarasStateLine ::temp2 who ;1 variable args
            strcat ::temp2 ::temp6 ::temp2 
            callmethod Diag self ::nonevar ::temp4 ::temp2 False ;3 variable args
            ; line 4902
            callmethod ReseedActor self ::nonevar who ;1 variable args
          .endCode
        .endFunction ;OnMarasStatusChanged
        .function RefreshPartnerCount
           ; function type 0
          .userFlags 0 ;none
          .docString "How many people the player has an ACKNOWLEDGED romance with, cached for
      the bio prompt.

      WHY THE BOND PROMPT NEEDS THIS. The exclusivity block describes what
      another partner WOULD cost - "if they take another partner that is not a
      disappointment to absorb, it is the end of what you have". For a player who
      already has two, that is not a hypothetical, it is a description of the
      present, and the character is being told to defend a line that was crossed
      long ago and survived. Observed 2026-09-06 on Iddra: she agreed to bear the
      player's child knowing there were others, then refused to share him on the
      grounds of a rule she had already been living under.

      ACKNOWLEDGED, NOT MERELY DEEP. Sparked AND the player answered yes. A
      companion nobody has said anything to is not a rival, and counting depth
      alone would make every close friend one.

      ON THE HOUSEKEEPING TICK, NOT PER RENDER. GetRomance is called on every bio
      render; walking a 71-entry roster there would be a per-prompt cost for a
      number that changes a handful of times per playthrough."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local n Int
            .local i Int
            .local total Int
            .local ::temp1 form
            .local ::temp2 Int
            .local a actor
            .local ::temp3 actor
            .local ::temp4 Int
            .local ::nonevar None
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 4925
            not ::temp0 _ready 
            jmpf ::temp0 _label0
            ; line 4926
            return None 
            jmp _label0
            ; line 4928
          _label0:
            assign n 0 
            ; line 4929
            assign i 0 
            ; line 4930
            cast ::temp1 None 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "SNRom_Roster" ;2 variable args
            assign total ::temp2 
            ; line 4931
          _label6:
            cmp_lt ::temp0 i total 
            jmpf ::temp0 _label1
            ; line 4932
            cast ::temp1 None 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "SNRom_Roster" i ;3 variable args
            cast ::temp3 ::temp1 
            assign a ::temp3 
            ; line 4933
            cast ::temp3 None 
            cmp_eq ::temp0 a ::temp3 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label2
            callmethod IsDead a ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label2:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            callstatic sNRom_Decorators IsSparked ::temp0 a ;1 variable args
            assign ::temp0 ::temp0 
          _label3:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label4
            ; line 4934
            cast ::temp1 a 
            callstatic storageUtil GetIntValue ::temp2 ::temp1 "SNRom_PlayerStance" 0 ;3 variable args
            callstatic sNRom_Bridge STANCE_ACCEPTED ::temp4 ;0 variable args
            cmp_eq ::temp0 ::temp2 ::temp4 
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label5
            ; line 4935
            iadd ::temp4 n 1 
            assign n ::temp4 
            jmp _label5
            ; line 4937
          _label5:
            iadd ::temp4 i 1 
            assign i ::temp4 
            jmp _label6
            ; line 4940
          _label1:
            callstatic sNRom_Bridge MarasPresent ::temp0 ;0 variable args
            jmpf ::temp0 _label7
            ; line 4941
            callmethod IEB_CountMarasPartners self ::temp4 "engaged" ;1 variable args
            callmethod IEB_CountMarasPartners self ::temp2 "married" ;1 variable args
            iadd ::temp2 ::temp4 ::temp2 
            iadd ::temp2 n ::temp2 
            assign n ::temp2 
            jmp _label7
            ; line 4943
          _label7:
            cast ::temp1 None 
            callstatic storageUtil GetIntValue ::temp2 ::temp1 "SNRom_PartnerCount" -1 ;3 variable args
            cmp_eq ::temp0 ::temp2 n 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label8
            ; line 4944
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            cast ::temp5 n 
            strcat ::temp5 "Acknowledged partners: " ::temp5 
            strcat ::temp5 ::temp5 ". The bond prompt uses this " 
            strcat ::temp5 ::temp5 "so an exclusivity boundary is not described as hypothetical to someone " 
            ; line 4945
            strcat ::temp5 ::temp5 "already living with the answer." 
            callmethod Diag self ::nonevar ::temp2 ::temp5 False ;3 variable args
            jmp _label8
            ; line 4948
          _label8:
            cast ::temp1 None 
            callstatic storageUtil SetIntValue ::temp2 ::temp1 "SNRom_PartnerCount" n ;3 variable args
          .endCode
        .endFunction ;RefreshPartnerCount
        .function EXCL_MIGRATION_VERSION
           ; function type 0
          .userFlags 0 ;none
          .docString "Bump this ONLY to run a NEW migration. Changing it re-runs the sweep on
      every existing save, which is a data mutation - so it is a deliberate act,
      not a version number that tracks the mod's."
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 4955
            return 1 
          .endCode
        .endFunction ;EXCL_MIGRATION_VERSION
        .function CONSUMING_MIN
           ; function type 0
          .userFlags 0 ;none
          .docString "Where the bond prompt's "you cannot share them" band begins. Duplicated
      from the prompt on purpose and flagged here: if that boundary moves, this
      constant and the migration below both have to move with it, and a silent
      divergence would sweep the wrong people."
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 4963
            return 88 
          .endCode
        .endFunction ;CONSUMING_MIN
        .function MigrateLegacyExclusivity
           ; function type 0
          .userFlags 0 ;none
          .docString "ONE-SHOT. Pulls every roster member at CONSUMING down into POSSESSIVE,
      because values written at that extreme predate the scale being anchored and
      are not trustworthy.

      WHY THIS IS NOT COSMETIC, and it is the whole reason it exists. 1.5.0 gives
      the >= 88 band an "and there are already N others" continuation, and that
      text says the relationship ENDS rather than gets negotiated. Correct for
      someone deliberately authored that way. But measured 2026-09-06: 29 roster
      members sat at 88+, 27 of them at exactly 100, and every single one was
      authored before the calibration landed - while the block that would justify
      it, `Attachment: Cannot Share at All`, had never been applied to anybody.
      Shipping the continuation without this sweep would hand 29 relationships a
      script for ending, on the strength of a number nobody chose. That is worse
      than the version it replaces, which stated the condition abstractly and let
      it lie.

      UNCONDITIONAL, AND THAT IS THE HONEST FORM. The tempting version exempts
      anyone carrying the Cannot-Share block - but Papyrus cannot see bio blocks
      at all (`custom_bio_blocks` is a prompt decorator, not a native), and it
      does not need to: re-authoring reads that block correctly now and restores
      100 for anyone who genuinely holds it. So this claims only what it can
      support - "the old scale's extreme is not evidence" - and leaves the actual
      judgment to a re-author.

      75 IS THE TARGET because it is mid-POSSESSIVE, so it cannot be mistaken for
      a boundary value, and because that band's own others-continuation is the
      MOVABLE one - a real refusal that can still be brought round at a cost.
      Verified in play on Jora at 75 on 2026-09-06, which is the arc these
      characters should have been getting all along.

      RUNS FROM HOUSEKEEPING, NOT BOOTSTRAP, so SweepFollowers has already had a
      pass and the roster is settled before anything is rewritten. Once the stamp
      is set the steady cost is one Int read per housekeeping tick.

      EVERY CHANGE IS LOGGED WITH ITS OLD VALUE, quietly. Quietly because 29
      notifications would be a toast storm that buries the one line worth reading
      - and with the old numbers in the log, a character who should have stayed at
      100 is restored with SetCharacterField rather than guessed at."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 form
            .local ::temp1 Int
            .local ::temp2 Int
            .local ::temp3 Bool
            .local moved Int
            .local i Int
            .local n Int
            .local a actor
            .local ::temp4 actor
            .local had Int
            .local ::nonevar None
            .local ::temp5 String
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 5005
            cast ::temp0 None 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_ExclMigration" 0 ;3 variable args
            callstatic sNRom_Bridge EXCL_MIGRATION_VERSION ::temp2 ;0 variable args
            comp_gte ::temp3 ::temp1 ::temp2 
            jmpf ::temp3 _label0
            ; line 5006
            return None 
            jmp _label0
            ; line 5014
          _label0:
            cast ::temp0 None 
            callstatic sNRom_Bridge EXCL_MIGRATION_VERSION ::temp2 ;0 variable args
            callstatic storageUtil SetIntValue ::temp2 ::temp0 "SNRom_ExclMigration" ::temp2 ;3 variable args
            ; line 5015
            assign moved 0 
            ; line 5016
            assign i 0 
            ; line 5017
            cast ::temp0 None 
            callstatic storageUtil FormListCount ::temp2 ::temp0 "SNRom_Roster" ;2 variable args
            assign n ::temp2 
            ; line 5018
          _label4:
            cmp_lt ::temp3 i n 
            jmpf ::temp3 _label1
            ; line 5019
            cast ::temp0 None 
            callstatic storageUtil FormListGet ::temp0 ::temp0 "SNRom_Roster" i ;3 variable args
            cast ::temp4 ::temp0 
            assign a ::temp4 
            ; line 5020
            cast ::temp4 None 
            cmp_eq ::temp3 a ::temp4 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label2
            ; line 5032
            cast ::temp0 a 
            callstatic storageUtil GetIntValue ::temp2 ::temp0 "SNRom_Exclusivity" -1 ;3 variable args
            assign had ::temp2 
            ; line 5033
            callstatic sNRom_Bridge CONSUMING_MIN ::temp2 ;0 variable args
            comp_gte ::temp3 had ::temp2 
            jmpf ::temp3 _label3
            ; line 5034
            cast ::temp0 a 
            callstatic storageUtil SetIntValue ::temp2 ::temp0 "SNRom_Exclusivity" 75 ;3 variable args
            ; line 5035
            iadd ::temp2 moved 1 
            assign moved ::temp2 
            ; line 5036
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            callmethod GetDisplayName a ::temp5 ;0 variable args
            strcat ::temp5 "Recalibrated " ::temp5 
            strcat ::temp5 ::temp5 " exclusivity " 
            ; line 5037
            cast ::temp6 had 
            strcat ::temp6 ::temp5 ::temp6 
            strcat ::temp6 ::temp6 " -> 75. Written under the old " 
            strcat ::temp6 ::temp6 "unanchored scale; re-author to restore " 
            ; line 5038
            cast ::temp5 had 
            strcat ::temp5 ::temp6 ::temp5 
            strcat ::temp5 ::temp5 " if it was genuinely meant." 
            callmethod Diag self ::nonevar ::temp2 ::temp5 True ;3 variable args
            jmp _label3
          _label3:
            jmp _label2
            ; line 5042
          _label2:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label4
            ; line 5044
          _label1:
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callstatic sNRom_Bridge EXCL_MIGRATION_VERSION ::temp1 ;0 variable args
            cast ::temp5 ::temp1 
            strcat ::temp5 "Exclusivity migration " ::temp5 
            strcat ::temp5 ::temp5 " complete: " 
            ; line 5045
            cast ::temp6 moved 
            strcat ::temp6 ::temp5 ::temp6 
            strcat ::temp6 ::temp6 " of " 
            cast ::temp5 n 
            strcat ::temp5 ::temp6 ::temp5 
            strcat ::temp5 ::temp5 " roster members recalibrated." 
            callmethod Diag self ::nonevar ::temp2 ::temp5 False ;3 variable args
            ; line 5046
            cmp_gt ::temp3 moved 0 
            jmpf ::temp3 _label5
            ; line 5047
            cast ::temp5 moved 
            strcat ::temp5 ::temp5 " companions had their limits on sharing you re-read - the old readings were unreliable at the extreme." 
            callmethod Say self ::nonevar ::temp5 ;1 variable args
            jmp _label5
          _label5
          .endCode
        .endFunction ;MigrateLegacyExclusivity
        .function CheckContentLoaded
           ; function type 0
          .userFlags 0 ;none
          .docString "Did SkyrimNet actually load this mod's prompts, triggers and actions?

      THE FAILURE THIS EXISTS FOR IS COMPLETELY SILENT. SkyrimNet Beta 25 stopped
      reading `prompts/`, `config/triggers/` and `config/actions/` and reads a
      plugin library instead - old files are "ignored, not deleted". Install it
      over a mod that only ships the old layout and every line of Papyrus here
      still runs: decorators register, the tick fires, the roster sweeps, the
      hotkeys arm. What is gone is every prompt, so SendCustomPromptToLLM returns
      rc=1 - ACCEPTED, never executed - the callbacks never land, the assessors
      hold their slots until the 90-second timeout, and the bond submodule renders
      nothing at all. Nothing throws. The log looks healthy.

      IsActionRegistered TESTS THE OUTCOME, NOT A PROXY FOR IT, which is why this
      does not sniff the build version. A version test only catches the one cause
      we predicted. Asking whether the action is actually registered catches all
      of them: the wrong layout, a plugin folder rejected because its name does
      not match the manifest id, a single file skipped for a bad extension, a
      manifest that failed validation, a player who deleted something. If the
      answer is no, nothing this mod does will work, whatever the reason.

      ONE ACTION STANDS FOR THE LAYER. RomanceMarkMoment is the workhorse and
      ships in the same folder as the rest; if the layer loaded at all it is
      registered. This is deliberately a coarse test - it answers "is our content
      there", not "is every file there", and the log warns about the latter.

      ASKED AT BOOTSTRAP AND AGAIN ON THE TICK, and only YES latches. The first
      two attempts at this got the cadence wrong in the same direction:
      housekeeping is gated on two GAME HOURS, and even the fast tick needs the
      game unpaused for half a game hour. Both left a player who had just
      installed staring at a log that said nothing at all - which is the silence
      this check exists to end, reproduced faithfully. Measured twice on
      2026-09-11.

      So Bootstrap asks immediately, because the answer is almost always
      available: SKSE plugins load their content long before a quest script
      bootstraps on a game load. The remaining worry was a race against
      SkyrimNet still building its action registry - and the fix for that is not
      to delay the question, it is to not believe a NO. A yes is conclusive and
      latches. A no leaves the state unknown so the next tick asks again, and
      only the tick announces a failure to the player.

      That way the common case reports instantly and the rare race costs one
      extra call, instead of every player paying for a hazard almost none of
      them have.

      PLAYER-FACING, NOT JUST LOGGED. Every other diagnostic here can wait for
      someone to open a file. This one means the mod they installed is doing
      nothing, and they would otherwise play for hours before suspecting it."
          .return None
          .paramTable
            .param abSettled Bool
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 Int
            .local ::temp2 String
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 5100
            cmp_eq ::temp0 _contentSeen 0 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 5101
            return None 
            jmp _label0
            ; line 5103
          _label0:
            callstatic skyrimNetApi IsActionRegistered ::temp0 "RomanceMarkMoment" ;1 variable args
            jmpf ::temp0 _label1
            ; line 5104
            assign _contentSeen 1 
            ; line 5105
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            strcat ::temp2 "Content layer loaded - RomanceMarkMoment is registered. " "SkyrimNet build " 
            ; line 5106
            callstatic skyrimNetApi GetBuildVersion ::temp3 ;0 variable args
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 "." 
            callmethod Diag self ::nonevar ::temp1 ::temp3 False ;3 variable args
            ; line 5107
            return None 
            jmp _label1
            ; line 5109
          _label1:
            not ::temp0 abSettled 
            jmpf ::temp0 _label2
            ; line 5112
            return None 
            jmp _label2
            ; line 5114
          _label2:
            assign _contentSeen 2 
            ; line 5115
            callstatic sNRom_Bridge LOG_ERROR ::temp1 ;0 variable args
            strcat ::temp3 "CONTENT NOT LOADED. SkyrimNet has not registered " "RomanceMarkMoment, so this mod's prompts, triggers and actions are not " 
            ; line 5116
            strcat ::temp3 ::temp3 "reaching it. Everything else will appear to run and nothing will work: " 
            ; line 5117
            strcat ::temp3 ::temp3 "LLM calls are accepted and never answered, and companion bios lose their " 
            ; line 5118
            strcat ::temp3 ::temp3 "relationship section entirely. SkyrimNet build " 
            ; line 5120
            callstatic skyrimNetApi GetBuildVersion ::temp2 ;0 variable args
            strcat ::temp2 ::temp3 ::temp2 
            strcat ::temp2 ::temp2 ". Relationships 2.0 needs SkyrimNet 0.25.0 " 
            strcat ::temp2 ::temp2 "(Beta 25) or newer, which reads it from SkyrimNet's external plugin folder; " 
            ; line 5121
            strcat ::temp2 ::temp2 "older builds cannot see it at all. On 0.25.0 or newer, reinstalling this mod " 
            ; line 5122
            strcat ::temp2 ::temp2 "is the usual fix." 
            callmethod Diag self ::nonevar ::temp1 ::temp2 False ;3 variable args
            ; line 5124
            callmethod Say self ::nonevar "SkyrimNet is not loading Relationships' content - it needs SkyrimNet Beta 25 or newer. See the log." ;1 variable args
          .endCode
        .endFunction ;CheckContentLoaded
        .function SweepLoverCeiling
           ; function type 0
          .userFlags 0 ;none
          .docString "The consent question across the whole roster, not just on whoever
      earned something recently: CheckRomanceQuestion is level-triggered, and
      a romance held short of Lover earns nothing while it waits, so the one
      state the question exists to resolve never reaches Ledger by itself.

      1.x also pulled back here anyone Romantasy's own scoring had carried
      over the line (EnforceLoverCeiling). From 2.0 nothing can carry them
      over - ApplyDepth withholds - so only the question is left."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local i Int
            .local n Int
            .local ::temp0 form
            .local ::temp1 Int
            .local ::temp2 Bool
            .local a actor
            .local ::temp3 actor
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 5136
            assign i 0 
            ; line 5137
            cast ::temp0 None 
            callstatic storageUtil FormListCount ::temp1 ::temp0 "SNRom_Roster" ;2 variable args
            assign n ::temp1 
            ; line 5138
          _label3:
            cmp_lt ::temp2 i n 
            jmpf ::temp2 _label0
            ; line 5139
            cast ::temp0 None 
            callstatic storageUtil FormListGet ::temp0 ::temp0 "SNRom_Roster" i ;3 variable args
            cast ::temp3 ::temp0 
            assign a ::temp3 
            ; line 5140
            cast ::temp3 None 
            cmp_eq ::temp2 a ::temp3 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label1
            callmethod IsDead a ::temp2 ;0 variable args
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 5160
            callmethod CheckRomanceQuestion self ::nonevar a ;1 variable args
            jmp _label2
            ; line 5162
          _label2:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label3
          _label0
          .endCode
        .endFunction ;SweepLoverCeiling
        .function SweepProposalGates
           ; function type 0
          .userFlags 0 ;none
          .docString "Establish the marriage gate across the whole roster, not just on whoever
      happened to earn points recently.

      WHY THIS IS NEEDED. MaintainProposalGate is called from Ledger, which fires
      only on a POINT CHANGE. So the gate was lazily established: measured
      2026-09-01, only one of five tested followers had ever had it evaluated, and
      Camilla Valerius was sitting as a MARAS candidate at 1999 pts with an
      acceptance chance of 0.993 and no keyword on her at all. A gate that exists
      only for whoever recently earned something is not a gate.

      This runs on the housekeeping tick and closes that hole. It also covers the
      case Ledger structurally cannot: a follower who is simply idle, and anyone
      enrolled before this feature existed.

      CHEAP, AND DELIBERATELY SO. MaintainProposalGate reads HasKeyword and
      returns immediately when the state is already correct, so the steady cost is
      one native read per roster entry per housekeeping tick - no writes, no
      GetPoints beyond the one comparison, and nothing at all once every follower
      is settled. The keyword is resolved ONCE here rather than per actor, because
      Keyword.GetKeyword is the only part of this that is not trivially cheap.

      NOT GATED ON FOLLOWING. Unlike ReconcileMarriages, which needs Romantasy to
      accept a point change, this only adds or removes a keyword - so it works for
      anyone on the roster whether or not they are travelling. A spouse waiting at
      home should still not be proposable at 900 points."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 keyword
            .local ::temp2 keyword
            .local i Int
            .local n Int
            .local ::temp3 form
            .local ::temp4 Int
            .local a actor
            .local ::temp5 actor
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 5192
            not ::temp0 _ready 
            jmpf ::temp0 _label0
            ; line 5193
            return None 
            jmp _label0
            ; line 5195
          _label0:
            callstatic sNRom_Bridge IgnoreProposalKeyword ::temp1 ;0 variable args
            cast ::temp2 None 
            cmp_eq ::temp0 ::temp1 ::temp2 
            jmpf ::temp0 _label1
            ; line 5196
            return None 
            jmp _label1
            ; line 5198
          _label1:
            assign i 0 
            ; line 5199
            cast ::temp3 None 
            callstatic storageUtil FormListCount ::temp4 ::temp3 "SNRom_Roster" ;2 variable args
            assign n ::temp4 
            ; line 5200
          _label5:
            cmp_lt ::temp0 i n 
            jmpf ::temp0 _label2
            ; line 5201
            cast ::temp3 None 
            callstatic storageUtil FormListGet ::temp3 ::temp3 "SNRom_Roster" i ;3 variable args
            cast ::temp5 ::temp3 
            assign a ::temp5 
            ; line 5202
            cast ::temp5 None 
            cmp_eq ::temp0 a ::temp5 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            callmethod IsDead a ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 5203
            callmethod MaintainProposalGate self ::nonevar a ;1 variable args
            jmp _label4
            ; line 5205
          _label4:
            iadd ::temp4 i 1 
            assign i ::temp4 
            jmp _label5
          _label2
          .endCode
        .endFunction ;SweepProposalGates
        .function ReconcileMarriages
           ; function type 0
          .userFlags 0 ;none
          .docString "Heal a spouse who was seeded before MARAS could say they were married.
      ONE CHECK PER CHARACTER PER SAVE LOAD.

      THIS IS THE ONE THAT FIXES AN ALREADY-BROKEN SAVE, and the obvious
      alternative does not. Declining to stamp SNRom_Seeded when a marriage is
      missed cannot work: in the race IsMarriedToPlayer returns FALSE at seed
      time, so there is no fact for such a guard to notice. It cannot detect
      what it cannot see. Only a later re-read can.

      WHY NOT IN Bootstrap. MARAS initialises on load exactly as we do, and
      IsNPCStatus reads its native state. Checking at load would race the same
      way the original seed did and reach the same wrong answer. This runs on the
      housekeeping tick, after the sweep has refreshed follower states.

      THE MARKER IS PER ACTOR AND PER SESSION, not one flag for the whole pass.
      A single flag meant a spouse recruited later in the same session waited for
      the next load. Keyed this way, someone who becomes a follower mid-session
      is checked on the next tick instead.

      AND IT IS CHEAP, because the ordering does the work. An actor already
      checked this session costs one StorageUtil Int read and nothing else - no
      faction lookup, no MARAS call, no GetPoints. Only an unchecked FOLLOWER
      pays for those, at most once per load each.

      FROM 2.0, ANYONE NEAR THE PLAYER (Observers), following or not. The
      follower test was Romantasy's: it refused points to anyone not
      following. Ours land, so a spouse waiting at home is checked when the
      player is home."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 String
            .local session Int
            .local ::temp2 form
            .local ::temp3 Int
            .local spouseFloor Int
            .local i Int
            .local n Int
            .local a actor
            .local ::temp4 actor
            .local have Int
            .local ::nonevar None
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 5238
            not ::temp0 _ready 
            jmpf ::temp0 _label0
            ; line 5239
            return None 
            jmp _label0
            ; line 5241
          _label0:
            callstatic sNRom_Bridge CFG ::temp1 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp0 ::temp1 "seedEnabled" True ;3 variable args
            cmp_eq ::temp0 ::temp0 False 
            jmpf ::temp0 _label1
            ; line 5242
            return None 
            jmp _label1
            ; line 5244
          _label1:
            cast ::temp2 None 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_SessionId" 0 ;3 variable args
            assign session ::temp3 
            ; line 5245
            assign spouseFloor 2500 
            ; line 5246
            assign i 0 
            ; line 5247
            assign n 0 
            ; line 5248
            cast ::temp0 _observers 
            jmpf ::temp0 _label2
            ; line 5249
            array_length ::temp3 _observers 
            assign n ::temp3 
            jmp _label2
            ; line 5251
          _label2:
            cmp_lt ::temp0 i n 
            jmpf ::temp0 _label3
            ; line 5252
            array_getlement ::temp4 _observers i 
            assign a ::temp4 
            ; line 5256
            cast ::temp4 None 
            cmp_eq ::temp0 a ::temp4 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label4
            cast ::temp2 a 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_MarriageChecked" -1 ;3 variable args
            cmp_eq ::temp0 ::temp3 session 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label5
            ; line 5257
            cast ::temp2 a 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_MarriageChecked" session ;3 variable args
            ; line 5258
            callstatic sNRom_Bridge IsMarriedToPlayer ::temp0 a ;1 variable args
            jmpf ::temp0 _label6
            ; line 5259
            callstatic sNRom_Bridge PointsOf ::temp3 a ;1 variable args
            assign have ::temp3 
            ; line 5260
            cmp_lt ::temp0 have spouseFloor 
            jmpf ::temp0 _label7
            ; line 5264
            isub ::temp3 spouseFloor have 
            callmethod ApplyDepth self ::temp3 a ::temp3 "Married to you" True "married" ;5 variable args
            cmp_gt ::temp0 ::temp3 0 
            jmpf ::temp0 _label8
            ; line 5265
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName a ::temp1 ;0 variable args
            strcat ::temp1 "Marriage reconcile: " ::temp1 
            strcat ::temp1 ::temp1 " is married but held only " 
            ; line 5266
            cast ::temp5 have 
            strcat ::temp5 ::temp1 ::temp5 
            strcat ::temp5 ::temp5 " pts - raised to " 
            ; line 5267
            cast ::temp1 spouseFloor 
            strcat ::temp1 ::temp5 ::temp1 
            strcat ::temp1 ::temp1 "." 
            callstatic sNRom_Bridge MarasStateLine ::temp5 a ;1 variable args
            strcat ::temp5 ::temp1 ::temp5 
            callmethod Diag self ::nonevar ::temp3 ::temp5 False ;3 variable args
            jmp _label9
            ; line 5270
          _label8:
            cast ::temp2 a 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_MarriageChecked" -1 ;3 variable args
            ; line 5271
            callstatic sNRom_Bridge LOG_WARN ::temp3 ;0 variable args
            ; line 5272
            callmethod GetDisplayName a ::temp5 ;0 variable args
            strcat ::temp5 "Marriage reconcile: the top-up for " ::temp5 
            strcat ::temp5 ::temp5 " did not land. Will retry." 
            callmethod Diag self ::nonevar ::temp3 ::temp5 False ;3 variable args
          _label9:
            jmp _label7
          _label7:
            jmp _label6
          _label6:
            jmp _label5
            ; line 5277
          _label5:
            iadd ::temp3 i 1 
            assign i ::temp3 
            jmp _label2
          _label3
          .endCode
        .endFunction ;ReconcileMarriages
        .function StandingToPoints
           ; function type 0
          .userFlags 0 ;none
          .docString "A tier WORD, not a number, for the same reason ArdorWord exists: a judge
      calibrates far better against "confidant" than against 1750.

      FIVE WORDS, NOT FOUR, AND `DEVOTED` IS WHY. The first version stopped at
      CONFIDANT and mapped it to the ceiling, so every strong read landed on the
      same 1999 - "deep and mutual" and "married in all but name" collapsed into
      one answer. That is the bimodal failure this project has already measured
      twice: EXCLUSIVITY offered only endpoints and came back 22-of-55 at the
      top, and INTIMACY skipped its middle value entirely, 1 in 55. A word doing
      double duty is how a scale loses its middle.

      So the top of the range is split. `CONFIDANT` sits mid-rung and `DEVOTED`
      takes the ceiling, which means the judge has to actually decide whether
      this is a deep bond or a love affair in everything but the saying of it.

      THE CEILING IS UNANSWERED_MAX BY DESIGN. The author asked for the seeding
      ceiling to sit just under the Lover floor, so overwhelming evidence lands
      one conversation away from the consent question rather than through it.
      Seeding must never answer, on the player behalf, a question the player is
      supposed to be asked."
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
            ; line 5313
            callstatic sNRom_Decorators Trim ::temp0 asWord ;1 variable args
            callstatic sNRom_Decorators Upper ::temp0 ::temp0 ;1 variable args
            assign w ::temp0 
            ; line 5314
            cmp_eq ::temp1 w "DEVOTED" 
            jmpf ::temp1 _label0
            ; line 5315
            callstatic sNRom_Bridge UNANSWERED_MAX ::temp2 ;0 variable args
            return ::temp2 
            jmp _label1
            ; line 5316
          _label0:
            cmp_eq ::temp1 w "CONFIDANT" 
            jmpf ::temp1 _label2
            ; line 5317
            return 1650 
            jmp _label1
            ; line 5318
          _label2:
            cmp_eq ::temp1 w "FRIEND" 
            jmpf ::temp1 _label3
            ; line 5319
            return 1250 
            jmp _label1
            ; line 5320
          _label3:
            cmp_eq ::temp1 w "ACQUAINTANCE" 
            jmpf ::temp1 _label4
            ; line 5321
            return 750 
            jmp _label1
            ; line 5322
          _label4:
            cmp_eq ::temp1 w "STRANGER" 
            jmpf ::temp1 _label1
            ; line 5323
            return 200 
            jmp _label1
            ; line 5325
          _label1:
            return 0 
          .endCode
        .endFunction ;StandingToPoints
        .function KnownCap
           ; function type 0
          .userFlags 0 ;none
          .docString "The most a seed may credit for how long two people have known each other.

      THE SEED HAD NO CLOCK. Live play does: talk moves a bond at most
      talkDailyCap (200) a game day, one landmark per talkLandmarkDays. The seed
      read what had happened and never when, so an eventful first day scored as
      a deep bond - Sosia Tremellia, 2026-09-21, seeded 1250 (mid Friend) about
      five game hours after she first followed the player, and Daighre 750 a day
      in. The author's rule: someone met less than a day ago is a stranger
      however much happened, and time known has to be a factor at every stage.

      The prompt computes the span from the oldest OWN memory on record and has
      the judge copy it back; this caps only the READ. The rank/rapport floor is
      never capped (it is the game's own record of history), nor is a marriage.
      Each cap is the top of its tier, so a stronger read still lands higher in
      the band than a weaker one instead of both collapsing to the same floor.

      0 means no time limit: MONTHS_OR_MORE, UNKNOWN, or anything unreadable.
      Unreadable must not mean strict - that would under-seed long-known
      characters whenever a response is malformed. The caller logs it."
          .return Int
          .paramTable
            .param asKnown String
          .endParamTable
          .localTable
            .local k String
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 5348
            callstatic sNRom_Decorators Trim ::temp0 asKnown ;1 variable args
            callstatic sNRom_Decorators Upper ::temp0 ::temp0 ;1 variable args
            assign k ::temp0 
            ; line 5349
            cmp_eq ::temp1 k "NO_RECORD" 
            jmpf ::temp1 _label0
            ; line 5354
            return 200 
            jmp _label1
            ; line 5355
          _label0:
            cmp_eq ::temp1 k "TODAY_OR_YESTERDAY" 
            jmpf ::temp1 _label2
            ; line 5356
            return 499 
            jmp _label1
            ; line 5357
          _label2:
            cmp_eq ::temp1 k "DAYS" 
            jmpf ::temp1 _label3
            ; line 5358
            return 999 
            jmp _label1
            ; line 5359
          _label3:
            cmp_eq ::temp1 k "WEEKS" 
            jmpf ::temp1 _label1
            ; line 5360
            return 1499 
            jmp _label1
            ; line 5362
          _label1:
            return 0 
          .endCode
        .endFunction ;KnownCap
        .function KnownPhrase
           ; function type 0
          .userFlags 0 ;none
          .docString "Why the read was held back, as a clause a player reads in a toast."
          .return String
          .paramTable
            .param asKnown String
          .endParamTable
          .localTable
            .local k String
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 5367
            callstatic sNRom_Decorators Trim ::temp0 asKnown ;1 variable args
            callstatic sNRom_Decorators Upper ::temp0 ::temp0 ;1 variable args
            assign k ::temp0 
            ; line 5368
            cmp_eq ::temp1 k "NO_RECORD" 
            jmpf ::temp1 _label0
            ; line 5369
            return "nothing is recorded between you yet" 
            jmp _label1
            ; line 5370
          _label0:
            cmp_eq ::temp1 k "TODAY_OR_YESTERDAY" 
            jmpf ::temp1 _label2
            ; line 5371
            return "you met today or yesterday" 
            jmp _label1
            ; line 5372
          _label2:
            cmp_eq ::temp1 k "DAYS" 
            jmpf ::temp1 _label3
            ; line 5373
            return "you have known each other a few days" 
            jmp _label1
            ; line 5374
          _label3:
            cmp_eq ::temp1 k "WEEKS" 
            jmpf ::temp1 _label1
            ; line 5375
            return "you have known each other a few weeks" 
            jmp _label1
            ; line 5377
          _label1:
            return "you have not known each other long" 
          .endCode
        .endFunction ;KnownPhrase
        .function AssessSeed
           ; function type 0
          .userFlags 0 ;none
          .docString "Read the record and say where this relationship already stands.

      WHY THIS EXISTS. Measured 2026-09-01 across 63 seeded followers: rapport
      was exactly 5.0 for 57% of them and rank was 3 for 61 of 63, so SeedTarget
      returned about 200 for almost everyone whatever had happened between them.
      Its docstring called rapport "a persisted number expressing how she
      actually feels, earned in real play" - it was not being earned at all.

      The original design wanted an LLM read of the diary and was talked out of
      it on the grounds that deterministic beats judged WHEN THE DETERMINISTIC
      THING MEASURES THE RIGHT QUANTITY. It did not. This is that read restored,
      against a far richer store than existed when it was dropped.

      ONE PENDING AT A TIME, same discipline as the other three assessors."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 Int
            .local ::temp3 String
            .local ::temp4 Float
            .local prior String
            .local ::temp5 String
            .local ctx String
            .local ::temp6 actorBase
            .local ::temp7 race
            .local rc Int
            .local ::temp8 quest
          .endLocalTable
          .code
            ; line 5394
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 5395
            return None 
            jmp _label1
            ; line 5401
          _label1:
            callmethod SeedReadInFlight self ::temp1 ;0 variable args
            jmpf ::temp1 _label2
            ; line 5405
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 "Seed assessment for " ::temp3 
            strcat ::temp3 ::temp3 " skipped - a read for " 
            ; line 5406
            strcat ::temp3 ::temp3 _seedName 
            strcat ::temp3 ::temp3 " is still pending. Ask again." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 5407
            return None 
            jmp _label2
            ; line 5409
          _label2:
            assign _seedActor akActor 
            ; line 5410
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            assign _seedName ::temp3 
            ; line 5411
            callstatic utility GetCurrentRealTime ::temp4 ;0 variable args
            assign _seedSentAt ::temp4 
            ; line 5412
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod GetRelationshipRank akActor ::temp2 ::temp0 ;1 variable args
            cast ::temp3 ::temp2 
            strcat ::temp3 "vanilla relationship rank " ::temp3 
            assign prior ::temp3 
            ; line 5413
            callstatic sNRom_Bridge SeverActionsPresent ::temp1 ;0 variable args
            jmpf ::temp1 _label3
            ; line 5414
            strcat ::temp3 prior ", SeverActions rapport " 
            callstatic severActionsNative Native_GetRapport ::temp4 akActor ;1 variable args
            cast ::temp5 ::temp4 
            strcat ::temp5 ::temp3 ::temp5 
            assign prior ::temp5 
            jmp _label3
            ; line 5416
          _label3:
            strcat ::temp5 "{\"npc_name\":\"" _seedName 
            strcat ::temp5 ::temp5 "\"" 
            strcat ::temp5 ::temp5 ",\"npc_formid\":" 
            ; line 5417
            callmethod GetFormID akActor ::temp2 ;0 variable args
            cast ::temp3 ::temp2 
            strcat ::temp3 ::temp5 ::temp3 
            strcat ::temp3 ::temp3 ",\"npc_bio\":\"" 
            ; line 5418
            callmethod GetActorBase akActor ::temp6 ;0 variable args
            callmethod GetRace ::temp6 ::temp7 ;0 variable args
            callmethod GetName ::temp7 ::temp5 ;0 variable args
            callstatic sNRom_Bridge Escape ::temp5 ::temp5 ;1 variable args
            strcat ::temp5 ::temp3 ::temp5 
            strcat ::temp5 ::temp5 ", known to the Dragonborn\"" 
            strcat ::temp5 ::temp5 ",\"npc_prior\":\"" 
            ; line 5419
            callstatic sNRom_Bridge Escape ::temp3 prior ;1 variable args
            strcat ::temp3 ::temp5 ::temp3 
            strcat ::temp3 ::temp3 "\"" 
            callstatic sNRom_Bridge MarasContext ::temp5 akActor ;1 variable args
            strcat ::temp5 ::temp3 ::temp5 
            strcat ::temp5 ::temp5 "}" 
            assign ctx ::temp5 
            ; line 5420
            callstatic sNRom_Bridge VariantName ::temp5 ;0 variable args
            ; line 5421
            cast ::temp8 self 
            callstatic skyrimNetApi SendCustomPromptToLLM ::temp2 "snrom_seed_assess" ::temp5 ctx ::temp8 "SNRom_Bridge" "OnSeedAssessed" ;6 variable args
            assign rc ::temp2 
            ; line 5422
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            strcat ::temp5 "Seed assessment sent for " _seedName 
            strcat ::temp5 ::temp5 " (rc=" 
            cast ::temp3 rc 
            strcat ::temp3 ::temp5 ::temp3 
            strcat ::temp3 ::temp3 ")" 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 5423
            cmp_eq ::temp1 rc 1 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label4
            ; line 5428
            jmpf _seedByHand _label5
            ; line 5429
            strcat ::temp3 "Could not reach the model to re-read " _seedName 
            strcat ::temp3 ::temp3 "." 
            callmethod Say self ::nonevar ::temp3 ;1 variable args
            ; line 5430
            assign _seedByHand False 
            jmp _label5
            ; line 5432
          _label5:
            cast ::temp0 None 
            assign _seedActor ::temp0 
            jmp _label4
          _label4
          .endCode
        .endFunction ;AssessSeed
        .function SeedReadInFlight
           ; function type 0
          .userFlags 0 ;none
          .docString "Is a seed read already out?

      Checked BEFORE dispatching a hand-requested one, because AssessSeed holds
      a single pending slot and declines a second request with nothing but a log
      line - and a hotkey that silently does nothing reads as a broken hotkey
      rather than as a queue doing its job.

      TIMES THE SLOT OUT, and that is not defensive noise. The slot is released
      by the callback, so a response that never arrives - a dropped LLM call, a
      backend that died mid-request - held it for the rest of the session, and
      SeedNextActor would then never seed anyone again. Nothing surfaced that,
      because the automatic path fails quietly by design. The hotkey would have
      turned it into "still reading the record for Lydia" forever.

      NINETY REAL SECONDS is far longer than a read takes and far shorter than a
      play session. Releasing the slot early costs at worst one duplicate read,
      which is harmless: seeding tops up and cannot pay twice."
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local waited Float
            .local ::temp2 Float
            .local ::nonevar None
            .local ::temp3 Int
            .local ::temp4 String
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 5454
            cast ::temp0 None 
            cmp_eq ::temp1 _seedActor ::temp0 
            jmpf ::temp1 _label0
            ; line 5455
            return False 
            jmp _label0
            ; line 5457
          _label0:
            callstatic utility GetCurrentRealTime ::temp2 ;0 variable args
            fsub ::temp2 ::temp2 _seedSentAt 
            assign waited ::temp2 
            ; line 5461
            cmp_lt ::temp1 waited 0.0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            cmp_gt ::temp1 waited 90.0 
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 5462
            callstatic sNRom_Bridge LOG_WARN ::temp3 ;0 variable args
            strcat ::temp4 "Seed read for " _seedName 
            strcat ::temp4 ::temp4 " never came back (" 
            cast ::temp5 waited 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 "s) - releasing the slot so seeding is not stuck for the session." 
            callmethod Diag self ::nonevar ::temp3 ::temp5 False ;3 variable args
            ; line 5464
            cast ::temp0 None 
            assign _seedActor ::temp0 
            ; line 5465
            assign _seedByHand False 
            ; line 5466
            return False 
            jmp _label2
            ; line 5468
          _label2:
            return True 
          .endCode
        .endFunction ;SeedReadInFlight
        .function OnSeedAssessed
           ; function type 0
          .userFlags 0 ;none
          .docString "SkyrimNet's callback for AssessSeed, named in its dispatch. A thin
      wrapper since WP2: the read itself is SeedAssessed, below, which has many
      exits, and an open dashboard wants the row pushed after whichever one
      runs - a re-read started from the dashboard ends here."
          .return None
          .paramTable
            .param asResponse String
            .param aiSuccess Int
          .endParamTable
          .localTable
            .local who actor
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 5476
            assign who _seedActor 
            ; line 5477
            callmethod SeedAssessed self ::nonevar asResponse aiSuccess ;2 variable args
            ; line 5478
            jmpf _dashText _label0
            ; line 5479
            callmethod PushBond self ::nonevar who 0 ;2 variable args
            jmp _label0
          _label0
          .endCode
        .endFunction ;OnSeedAssessed
        .function SeedAssessed
           ; function type 0
          .userFlags 0 ;none
          .docString "The read comes back as a tier word. Papyrus decides what it is worth.

      TOPS UP, NEVER CLAWS BACK. The author's call, and it is the rule seeding has
      had: if the read lands at or below what they already hold, do nothing.
      Taking points off an established relationship on the strength of one LLM
      call is the one direction that cannot be justified.

      RANK AND RAPPORT SURVIVE AS A FLOOR. SeedTarget still runs and still wins
      where it is higher, so a cautious read cannot lower a Hroki whose rapport
      of 65 already justifies 975. They were only ever meant to be one input
      among several rather than the signal."
          .return None
          .paramTable
            .param asResponse String
            .param aiSuccess Int
          .endParamTable
          .localTable
            .local who actor
            .local asked String
            .local announce Bool
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 Int
            .local ::temp3 String
            .local echoed String
            .local standing String
            .local because String
            .local byRead Int
            .local readRaw Int
            .local known String
            .local married Bool
            .local timeCap Int
            .local shown String
            .local ::temp4 String
            .local byOld Int
            .local target Int
            .local cap Int
            .local held Int
            .local timeNote String
            .local ::temp5 form
            .local seedWhy String
            .local ::temp6 Int
          .endLocalTable
          .code
            ; line 5495
            assign who _seedActor 
            ; line 5496
            assign asked _seedName 
            ; line 5500
            assign announce _seedByHand 
            ; line 5501
            cast ::temp0 None 
            assign _seedActor ::temp0 
            ; line 5502
            assign _seedByHand False 
            ; line 5503
            cast ::temp0 None 
            cmp_eq ::temp1 who ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 aiSuccess 1 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 5508
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            strcat ::temp3 "Seed assessment for " asked 
            strcat ::temp3 ::temp3 " failed or returned " 
            strcat ::temp3 ::temp3 "nothing - falling back to rank and rapport alone." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 5510
            jmpf announce _label2
            ; line 5511
            strcat ::temp3 "The re-read of " asked 
            strcat ::temp3 ::temp3 " came back empty. Fell back to rank and rapport." 
            callmethod Say self ::nonevar ::temp3 ;1 variable args
            jmp _label2
            ; line 5513
          _label2:
            cast ::temp0 None 
            cmp_eq ::temp1 who ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label3
            ; line 5514
            callmethod SeedActor self ::temp1 who ;1 variable args
            jmp _label3
            ; line 5516
          _label3:
            return None 
            jmp _label1
            ; line 5518
          _label1:
            callstatic sNRom_Decorators FieldValue ::temp3 asResponse "NAME:" ;2 variable args
            callstatic sNRom_Decorators NameCore ::temp3 ::temp3 ;1 variable args
            assign echoed ::temp3 
            ; line 5519
            cmp_eq ::temp1 echoed "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label4
            callstatic sNRom_Decorators NameCore ::temp3 asked ;1 variable args
            cmp_eq ::temp1 echoed ::temp3 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label4:
            jmpf ::temp1 _label5
            ; line 5520
            callstatic sNRom_Bridge LOG_ERROR ::temp2 ;0 variable args
            strcat ::temp3 "Seed echo mismatch: asked about " asked 
            strcat ::temp3 ::temp3 ", answered as " 
            strcat ::temp3 ::temp3 echoed 
            ; line 5521
            strcat ::temp3 ::temp3 ". Discarded." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 5522
            jmpf announce _label6
            ; line 5523
            strcat ::temp3 "The answer for " asked 
            strcat ::temp3 ::temp3 " came back about " 
            strcat ::temp3 ::temp3 echoed 
            strcat ::temp3 ::temp3 " - discarded." 
            callmethod Say self ::nonevar ::temp3 ;1 variable args
            jmp _label6
            ; line 5525
          _label6:
            return None 
            jmp _label5
            ; line 5527
          _label5:
            callstatic sNRom_Decorators FieldValue ::temp3 asResponse "STANDING:" ;2 variable args
            assign standing ::temp3 
            ; line 5528
            callstatic sNRom_Decorators FieldValue ::temp3 asResponse "BECAUSE:" ;2 variable args
            assign because ::temp3 
            ; line 5529
            callstatic sNRom_Bridge StandingToPoints ::temp2 standing ;1 variable args
            assign byRead ::temp2 
            ; line 5530
            cmp_eq ::temp1 byRead 0 
            jmpf ::temp1 _label7
            ; line 5531
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            strcat ::temp3 "Seed read for " asked 
            strcat ::temp3 ::temp3 " returned an unreadable standing: '" 
            strcat ::temp3 ::temp3 standing 
            ; line 5532
            strcat ::temp3 ::temp3 "'. Falling back to rank and rapport alone." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            jmp _label7
            ; line 5537
          _label7:
            assign readRaw byRead 
            ; line 5538
            callstatic sNRom_Decorators FieldValue ::temp3 asResponse "KNOWN:" ;2 variable args
            callstatic sNRom_Decorators Trim ::temp3 ::temp3 ;1 variable args
            callstatic sNRom_Decorators Upper ::temp3 ::temp3 ;1 variable args
            assign known ::temp3 
            ; line 5539
            callstatic sNRom_Bridge IsMarriedToPlayer ::temp1 who ;1 variable args
            assign married ::temp1 
            ; line 5540
            assign timeCap 0 
            ; line 5541
            not ::temp1 married 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label8
            callstatic sNRom_Bridge CFG ::temp3 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp1 ::temp3 "seedTimeLimit" True ;3 variable args
            assign ::temp1 ::temp1 
          _label8:
            jmpf ::temp1 _label9
            ; line 5542
            callstatic sNRom_Bridge KnownCap ::temp2 known ;1 variable args
            assign timeCap ::temp2 
            ; line 5543
            cmp_eq ::temp1 timeCap 0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label10
            cmp_eq ::temp1 known "MONTHS_OR_MORE" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label10:
            jmpf ::temp1 _label11
            ; line 5544
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            strcat ::temp3 "Seed read for " asked 
            strcat ::temp3 ::temp3 " carried no usable time known (KNOWN: '" 
            strcat ::temp3 ::temp3 known 
            ; line 5545
            strcat ::temp3 ::temp3 "') - no time limit applied." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            jmp _label11
          _label11:
            jmp _label9
            ; line 5548
          _label9:
            cmp_gt ::temp1 timeCap 0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label12
            cmp_gt ::temp1 byRead timeCap 
            assign ::temp1 ::temp1 
          _label12:
            jmpf ::temp1 _label13
            ; line 5549
            assign byRead timeCap 
            jmp _label13
            ; line 5554
          _label13:
            assign shown standing 
            ; line 5555
            cmp_lt ::temp1 byRead readRaw 
            jmpf ::temp1 _label14
            ; line 5556
            strcat ::temp3 standing ", held back - " 
            callstatic sNRom_Bridge KnownPhrase ::temp4 known ;1 variable args
            strcat ::temp4 ::temp3 ::temp4 
            assign shown ::temp4 
            jmp _label14
            ; line 5558
          _label14:
            callmethod SeedTarget self ::temp2 who ;1 variable args
            assign byOld ::temp2 
            ; line 5559
            assign target byRead 
            ; line 5560
            cmp_gt ::temp1 byOld target 
            jmpf ::temp1 _label15
            ; line 5561
            assign target byOld 
            jmp _label15
            ; line 5563
          _label15:
            callstatic sNRom_Bridge UNANSWERED_MAX ::temp2 ;0 variable args
            assign cap ::temp2 
            ; line 5564
            jmpf married _label16
            ; line 5565
            assign cap 2500 
            jmp _label16
            ; line 5567
          _label16:
            cmp_gt ::temp1 target cap 
            jmpf ::temp1 _label17
            ; line 5568
            assign target cap 
            jmp _label17
            ; line 5570
          _label17:
            callstatic sNRom_Bridge PointsOf ::temp2 who ;1 variable args
            assign held ::temp2 
            ; line 5571
            strcat ::temp4 ", known " known 
            assign timeNote ::temp4 
            ; line 5572
            cmp_lt ::temp1 byRead readRaw 
            jmpf ::temp1 _label18
            ; line 5573
            strcat ::temp4 timeNote " - read " 
            cast ::temp3 readRaw 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 " held to " 
            cast ::temp4 byRead 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 " by time known" 
            assign timeNote ::temp4 
            jmp _label18
            ; line 5575
          _label18:
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            strcat ::temp4 "Seed read for " asked 
            strcat ::temp4 ::temp4 ": " 
            strcat ::temp4 ::temp4 standing 
            strcat ::temp4 ::temp4 " -> " 
            cast ::temp3 byRead 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 " pts" 
            ; line 5576
            strcat ::temp3 ::temp3 timeNote 
            strcat ::temp3 ::temp3 " (rank/rapport floor " 
            cast ::temp4 byOld 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ", cap " 
            cast ::temp3 cap 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 ", holds " 
            cast ::temp4 held 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 "). Because: " 
            ; line 5577
            strcat ::temp4 ::temp4 because 
            callmethod Diag self ::nonevar ::temp2 ::temp4 False ;3 variable args
            ; line 5578
            cmp_lte ::temp1 target held 
            jmpf ::temp1 _label19
            ; line 5579
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            strcat ::temp4 "Seed read for " asked 
            strcat ::temp4 ::temp4 " is at or below what they hold - nothing " 
            strcat ::temp4 ::temp4 "added. Seeding tops up and never claws back." 
            callmethod Diag self ::nonevar ::temp2 ::temp4 False ;3 variable args
            ; line 5584
            jmpf announce _label20
            ; line 5585
            strcat ::temp4 asked " reads as " 
            strcat ::temp4 ::temp4 shown 
            strcat ::temp4 ::temp4 " - already at or above that, so nothing added." 
            callmethod Say self ::nonevar ::temp4 ;1 variable args
            jmp _label20
            ; line 5587
          _label20:
            cast ::temp5 who 
            callstatic storageUtil SetIntValue ::temp2 ::temp5 "SNRom_Seeded" 1 ;3 variable args
            ; line 5588
            callmethod SeedRomanticFlag self ::nonevar who ;1 variable args
            ; line 5589
            return None 
            jmp _label19
            ; line 5603
          _label19:
            assign seedWhy because 
            ; line 5604
            cmp_eq ::temp1 seedWhy "" 
            jmpf ::temp1 _label21
            ; line 5605
            assign seedWhy "Prior history together" 
            jmp _label21
            ; line 5607
          _label21:
            isub ::temp2 target held 
            callmethod ApplyDepth self ::temp2 who ::temp2 seedWhy True "seed" ;5 variable args
            cmp_gt ::temp1 ::temp2 0 
            jmpf ::temp1 _label22
            ; line 5608
            cast ::temp5 who 
            callstatic storageUtil SetIntValue ::temp2 ::temp5 "SNRom_Seeded" 1 ;3 variable args
            ; line 5609
            callmethod SeedRomanticFlag self ::nonevar who ;1 variable args
            ; line 5610
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            strcat ::temp4 "Seeded " asked 
            strcat ::temp4 ::temp4 " from the record: " 
            cast ::temp3 held 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 " -> " 
            ; line 5611
            callstatic sNRom_Bridge PointsOf ::temp6 who ;1 variable args
            cast ::temp4 ::temp6 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 " pts." 
            callstatic sNRom_Bridge MarasStateLine ::temp3 who ;1 variable args
            strcat ::temp3 ::temp4 ::temp3 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 5612
            jmpf announce _label23
            ; line 5613
            strcat ::temp3 asked " reads as " 
            strcat ::temp3 ::temp3 shown 
            strcat ::temp3 ::temp3 "." 
            callmethod Say self ::nonevar ::temp3 ;1 variable args
            jmp _label23
            ; line 5629
          _label23:
            callstatic sNRom_Bridge PointsOf ::temp2 who ;1 variable args
            callstatic sNRom_Bridge CONFIDANT_MIN ::temp6 ;0 variable args
            comp_gte ::temp1 ::temp2 ::temp6 
            jmpf ::temp1 _label24
            ; line 5630
            callmethod RequestSparkNow self ::nonevar who ;1 variable args
            jmp _label24
          _label24:
            jmp _label25
            ; line 5633
          _label22:
            callstatic sNRom_Bridge LOG_WARN ::temp6 ;0 variable args
            strcat ::temp3 "The seed read for " asked 
            strcat ::temp3 ::temp3 " could not be written yet - their " 
            strcat ::temp3 ::temp3 "Romantasy points did not verify while being brought over (see the line above). " 
            ; line 5634
            strcat ::temp3 ::temp3 "It will be reapplied." 
            callmethod Diag self ::nonevar ::temp6 ::temp3 False ;3 variable args
            ; line 5641
            jmpf announce _label25
            ; line 5642
            strcat ::temp3 asked " reads as " 
            strcat ::temp3 ::temp3 standing 
            strcat ::temp3 ::temp3 ", but it could not be written yet. " 
            strcat ::temp3 ::temp3 "It will be retried automatically." 
            callmethod Say self ::nonevar ::temp3 ;1 variable args
            jmp _label25
          _label25
          .endCode
        .endFunction ;SeedAssessed
        .function ReseedActor
           ; function type 0
          .userFlags 0 ;none
          .docString "Clear the once-ever stamp and seed again. ONE argument, so it dispatches
      from the web API.

      Safe by construction rather than by care: SeedActor seeds to a FLOOR, so a
      re-seed can only ever raise someone to what their history justifies. It
      cannot take points away, and it cannot pay twice for the same history -
      whatever they already have is subtracted first.

      Written for the Kayla case. She was seeded on 2026-08-03 by a build whose
      rapport read was against a dead SeverActions key, so her entire target came
      from relationship rank and the rapport half of the estimate was silently
      zero. Anyone seeded by that build deserves the same second look.

      GOES THROUGH THE RECORD READ, not SeedTarget, and that correction is the
      whole point of the function now. This called SeedActor directly, which is
      the rank-and-rapport path - so the one repair a player reaches for after
      fixing someone's bio was the one path that could not see the fix. Rapport
      was 5.0 for 57% of 63 followers and rank was 3 for 61 of them, so a
      re-seed would have recomputed about 200, found it below what they held,
      and reported success having read nothing that was written.

      AssessSeed keeps SeedActor as its own failure fallback, so an endpoint
      that is down still answers something rather than nothing."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local had Int
            .local ::temp2 Int
            .local ::temp3 form
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 5672
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 5673
            return None 
            jmp _label1
            ; line 5675
          _label1:
            callstatic sNRom_Bridge PointsOf ::temp2 akActor ;1 variable args
            assign had ::temp2 
            ; line 5676
            cast ::temp3 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp3 "SNRom_Seeded" ;2 variable args
            ; line 5677
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 "Re-seeding " ::temp4 
            strcat ::temp4 ::temp4 " (currently " 
            cast ::temp5 had 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 " pts) - reading the record again" 
            callmethod Diag self ::nonevar ::temp2 ::temp5 False ;3 variable args
            ; line 5678
            callmethod AssessSeed self ::nonevar akActor ;1 variable args
          .endCode
        .endFunction ;ReseedActor
        .function OnHotkey
           ; function type 0
          .userFlags 0 ;none
          .docString "The DLL's crosshair keys. akSender is whoever was under the crosshair at
      the press, or None."
          .return None
          .paramTable
            .param asEventName String
            .param asKey String
            .param afNumArg Float
            .param akSender form
          .endParamTable
          .localTable
            .local who actor
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 Float
            .local ::temp3 form
            .local ::temp4 Float
            .local ::temp5 String
            .local refused String
          .endLocalTable
          .code
            ; line 5700
            cast ::temp0 akSender 
            assign who ::temp0 
            ; line 5701
            cmp_eq ::temp1 asKey "reread" 
            jmpf ::temp1 _label0
            ; line 5702
            callmethod ReseedUnderCrosshair self ::nonevar who ;1 variable args
            jmp _label1
            ; line 5703
          _label0:
            cmp_eq ::temp1 asKey "reauthor" 
            jmpf ::temp1 _label2
            ; line 5707
            cast ::temp0 None 
            cmp_eq ::temp1 who ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label3
            callstatic utility GetCurrentRealTime ::temp2 ;0 variable args
            cast ::temp3 who 
            callstatic storageUtil GetFloatValue ::temp4 ::temp3 "SNRom_ReauthorKeyAt" -1000.0 ;3 variable args
            fsub ::temp4 ::temp2 ::temp4 
            cmp_lt ::temp1 ::temp4 60.0 
            assign ::temp1 ::temp1 
          _label3:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label4
            ; line 5708
            callstatic utility GetCurrentRealTime ::temp4 ;0 variable args
            cast ::temp3 who 
            callstatic storageUtil GetFloatValue ::temp2 ::temp3 "SNRom_ReauthorKeyAt" -1000.0 ;3 variable args
            comp_gte ::temp1 ::temp4 ::temp2 
            assign ::temp1 ::temp1 
          _label4:
            jmpf ::temp1 _label5
            ; line 5709
            callmethod GetDisplayName who ::temp5 ;0 variable args
            strcat ::temp5 ::temp5 " was re-authored less than a minute ago. Press again later if you mean it." 
            callmethod Say self ::nonevar ::temp5 ;1 variable args
            ; line 5710
            return None 
            jmp _label5
            ; line 5712
          _label5:
            cast ::temp0 None 
            cmp_eq ::temp1 who ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label6
            ; line 5713
            cast ::temp3 who 
            callstatic utility GetCurrentRealTime ::temp2 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp2 ::temp3 "SNRom_ReauthorKeyAt" ::temp2 ;3 variable args
            jmp _label6
            ; line 5715
          _label6:
            callmethod ReauthorUnderCrosshair self ::nonevar who ;1 variable args
            jmp _label1
            ; line 5716
          _label2:
            cmp_eq ::temp1 asKey "enroll" 
            jmpf ::temp1 _label1
            ; line 5717
            callmethod EnrollByHand self ::temp5 who ;1 variable args
            assign refused ::temp5 
            ; line 5718
            cmp_eq ::temp1 refused "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label7
            ; line 5719
            callmethod Say self ::nonevar refused ;1 variable args
            jmp _label8
            ; line 5721
          _label7:
            callmethod GetDisplayName who ::temp5 ;0 variable args
            strcat ::temp5 ::temp5 " is enrolled. Their character is being written." 
            callmethod Say self ::nonevar ::temp5 ;1 variable args
          _label8:
            jmp _label1
          _label1
          .endCode
        .endFunction ;OnHotkey
        .function DashboardDllPresent
           ; function type 0
          .userFlags 0 ;none
          .docString "PAPYRUS CANNOT TEST WHETHER A NATIVE EXISTS. Calling SNRom_Native without
      the DLL logs a Papyrus error and returns 0 or False, which looks exactly
      like a real refusal - so every call is gated on this first.

      Global, uncached, like SeverActionsPresent: it runs once per bootstrap,
      never per actor."
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Int
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 5743
            callstatic sKSE GetPluginVersion ::temp0 "SkyrimNetRelationships" ;1 variable args
            cmp_gt ::temp1 ::temp0 0 
            return ::temp1 
          .endCode
        .endFunction ;DashboardDllPresent
        .function DashboardKeyWanted
           ; function type 0
          .userFlags 0 ;none
          .docString "A VIRTUAL-KEY code, unlike the two keys above: the setting is SkyrimNet's
      hotkey widget, which captures a keypress and stores it as VK, and the DLL
      converts it natively - the job HotkeyCode's note says Papyrus should never
      attempt. 0, the shipped value, is unbound: the author's call, because the
      keys free in vanilla are the ones other mods have already taken."
          .return Int
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Int
          .endLocalTable
          .code
            ; line 5752
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigInt ::temp1 ::temp0 "dashboardHotkey" 0 ;3 variable args
            return ::temp1 
          .endCode
        .endFunction ;DashboardKeyWanted
        .function DeveloperViewWanted
           ; function type 0
          .userFlags 0 ;none
          .docString "The dashboard's developer view (design 7.6): off, the page shows only what
      the player could know."
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 5758
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp1 ::temp0 "dashboardDeveloperView" False ;3 variable args
            return ::temp1 
          .endCode
        .endFunction ;DeveloperViewWanted
        .function DashboardScaleWanted
           ; function type 0
          .userFlags 0 ;none
          .docString "The dashboard's scale as the settings panel names it: Auto, or 75% to
      200%. Handed to the DLL by name; see SNRom_Native.SetDisplaySettings."
          .return String
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 5764
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigString ::temp0 ::temp0 "dashboardScale" "Auto" ;3 variable args
            return ::temp0 
          .endCode
        .endFunction ;DashboardScaleWanted
        .function DashboardTextSizeWanted
           ; function type 0
          .userFlags 0 ;none
          .docString "The dashboard's text size as the settings panel names it: Normal, Large or
      Larger. On top of the scale."
          .return String
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 5770
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigString ::temp0 ::temp0 "dashboardTextSize" "Normal" ;3 variable args
            return ::temp0 
          .endCode
        .endFunction ;DashboardTextSizeWanted
        .function DashboardModifierWanted
           ; function type 0
          .userFlags 0 ;none
          .docString "The dashboard key's modifier as the settings panel names it: None, Left
      Shift, Right Shift, Left Ctrl, Right Ctrl, Left Alt or Right Alt. A select,
      so it arrives as the option's name; DashboardModifierVK turns it into what
      the DLL takes."
          .return String
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 5778
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigString ::temp0 ::temp0 "dashboardHotkeyModifier" "None" ;3 variable args
            return ::temp0 
          .endCode
        .endFunction ;DashboardModifierWanted
        .function DashboardModifierVK
           ; function type 0
          .userFlags 0 ;none
          .docString "A dashboardHotkeyModifier option as the VIRTUAL KEY of that side of the
      keyboard, which is what SNRom_Native.SetDashboardHotkey takes: 0 for None,
      160 to 165 for the six others. The same table as kModifiers in the DLL's
      Hotkey.cpp, which the DLL's settings watcher uses; the two and the
      manifest's options must agree.

      -1 for anything else, which the DLL refuses rather than binding the bare
      key: a key that opens without the modifier the player chose is a guess.
      Papyrus string comparison ignores case, and so does the DLL's."
          .return Int
          .paramTable
            .param asName String
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 5791
            cmp_eq ::temp0 asName "" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cmp_eq ::temp0 asName "None" 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 5792
            return 0 
            jmp _label2
            ; line 5793
          _label1:
            cmp_eq ::temp0 asName "Left Shift" 
            jmpf ::temp0 _label3
            ; line 5794
            return 160 
            jmp _label2
            ; line 5795
          _label3:
            cmp_eq ::temp0 asName "Right Shift" 
            jmpf ::temp0 _label4
            ; line 5796
            return 161 
            jmp _label2
            ; line 5797
          _label4:
            cmp_eq ::temp0 asName "Left Ctrl" 
            jmpf ::temp0 _label5
            ; line 5798
            return 162 
            jmp _label2
            ; line 5799
          _label5:
            cmp_eq ::temp0 asName "Right Ctrl" 
            jmpf ::temp0 _label6
            ; line 5800
            return 163 
            jmp _label2
            ; line 5801
          _label6:
            cmp_eq ::temp0 asName "Left Alt" 
            jmpf ::temp0 _label7
            ; line 5802
            return 164 
            jmp _label2
            ; line 5803
          _label7:
            cmp_eq ::temp0 asName "Right Alt" 
            jmpf ::temp0 _label2
            ; line 5804
            return 165 
            jmp _label2
            ; line 5806
          _label2:
            return -1 
          .endCode
        .endFunction ;DashboardModifierVK
        .function ArmDashboard
           ; function type 0
          .userFlags 0 ;none
          .docString "Hands the dashboard settings to the DLL, once per bootstrap, so they hold
      from the first load even if the DLL cannot read the settings file.

      NOT FROM THE TICK. The DLL watches the file SkyrimNet rewrites whenever
      its panel saves, and applies a change within seconds - see Settings.cpp
      in native/src. Re-arming from OnUpdateGameTime took minutes to notice a
      change, and put more Papyrus on the tick, where the aim is less. The
      re-read and re-author keys are different, because Papyrus registers
      those itself - see OnHotkey."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 Int
            .local ::temp2 String
            .local natives Int
            .local vk Int
            .local modName String
            .local modVK Int
            .local dev Bool
            .local scaleName String
            .local textName String
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 5821
            assign _dashNatives 0 
            ; line 5827
            callstatic sNRom_Bridge DashboardDllPresent ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 5828
            callstatic sNRom_Bridge LOG_ERROR ::temp1 ;0 variable args
            strcat ::temp2 "SkyrimNetRelationships.dll did not load. Relationships 2.0 needs it: " "check that it is installed, with SKSE and Address Library for this game version." 
            callmethod Diag self ::nonevar ::temp1 ::temp2 True ;3 variable args
            ; line 5830
            strcat ::temp2 "SkyrimNetRelationships.dll did not load - no dashboard, hotkeys or bond history. " "Check SKSE and Address Library for this game version." 
            callmethod Say self ::nonevar ::temp2 ;1 variable args
            ; line 5832
            return None 
            jmp _label0
            ; line 5840
          _label0:
            callstatic sNRom_Native Version ::temp1 ;0 variable args
            assign natives ::temp1 
            ; line 5841
            cmp_lt ::temp0 natives 7 
            jmpf ::temp0 _label1
            ; line 5842
            callstatic sNRom_Bridge LOG_ERROR ::temp1 ;0 variable args
            cast ::temp2 natives 
            strcat ::temp2 "SkyrimNetRelationships.dll is older than these scripts (natives v" ::temp2 
            strcat ::temp2 ::temp2 ", these need v7). Install the DLL from the same release." 
            callmethod Diag self ::nonevar ::temp1 ::temp2 True ;3 variable args
            ; line 5844
            callmethod Say self ::nonevar "SkyrimNetRelationships.dll is older than the scripts - install both from the same release." ;1 variable args
            jmp _label1
            ; line 5846
          _label1:
            cmp_lt ::temp0 natives 5 
            jmpf ::temp0 _label2
            ; line 5847
            return None 
            jmp _label2
            ; line 5849
          _label2:
            assign _dashNatives natives 
            ; line 5854
            callmethod DashboardCacheStore self ::nonevar ;0 variable args
            ; line 5855
            callstatic sNRom_Decorators KinGuardOn ::temp0 ;0 variable args
            cast ::temp1 ::temp0 
            assign _dashKinGuard ::temp1 
            ; line 5858
            callstatic sNRom_Bridge MarasPresent ::temp0 ;0 variable args
            assign _dashMaras ::temp0 
            ; line 5859
            callstatic sNRom_Bridge SeverActionsPresent ::temp0 ;0 variable args
            assign _dashSever ::temp0 
            ; line 5860
            callstatic sNRom_Bridge DashboardKeyWanted ::temp1 ;0 variable args
            assign vk ::temp1 
            ; line 5861
            callstatic sNRom_Bridge DashboardModifierWanted ::temp2 ;0 variable args
            assign modName ::temp2 
            ; line 5862
            callstatic sNRom_Bridge DashboardModifierVK ::temp1 modName ;1 variable args
            assign modVK ::temp1 
            ; line 5863
            callstatic sNRom_Bridge DeveloperViewWanted ::temp0 ;0 variable args
            assign dev ::temp0 
            ; line 5864
            callstatic sNRom_Native SetDeveloperView ::nonevar dev ;1 variable args
            ; line 5867
            callstatic sNRom_Bridge DashboardScaleWanted ::temp2 ;0 variable args
            assign scaleName ::temp2 
            ; line 5868
            callstatic sNRom_Bridge DashboardTextSizeWanted ::temp2 ;0 variable args
            assign textName ::temp2 
            ; line 5869
            callstatic sNRom_Native SetDisplaySettings ::temp0 scaleName textName ;2 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label3
            ; line 5870
            callstatic sNRom_Bridge LOG_WARN ::temp1 ;0 variable args
            strcat ::temp2 "Dashboard scale '" scaleName 
            strcat ::temp2 ::temp2 "' or text size '" 
            strcat ::temp2 ::temp2 textName 
            strcat ::temp2 ::temp2 "' is not one of the options; see SkyrimNetRelationships.log." 
            callmethod Diag self ::nonevar ::temp1 ::temp2 False ;3 variable args
            jmp _label3
            ; line 5873
          _label3:
            callstatic sNRom_Native SetDashboardHotkey ::temp0 vk modVK ;2 variable args
            jmpf ::temp0 _label4
            ; line 5874
            cmp_gt ::temp0 vk 0 
            jmpf ::temp0 _label5
            ; line 5875
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            cast ::temp2 vk 
            strcat ::temp2 "Dashboard hotkey armed on virtual key " ::temp2 
            strcat ::temp2 ::temp2 ", modifier " 
            strcat ::temp2 ::temp2 modName 
            strcat ::temp2 ::temp2 " (natives v" 
            ; line 5876
            cast ::temp3 natives 
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 ", developer view " 
            cast ::temp2 dev 
            strcat ::temp2 ::temp3 ::temp2 
            strcat ::temp2 ::temp2 ")." 
            callmethod Diag self ::nonevar ::temp1 ::temp2 False ;3 variable args
            jmp _label6
            ; line 5878
          _label5:
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            strcat ::temp2 "Dashboard hotkey not set (dashboardHotkey = 0) - choose one under " "Dashboard in the settings panel." 
            callmethod Diag self ::nonevar ::temp1 ::temp2 False ;3 variable args
          _label6:
            jmp _label7
            ; line 5881
          _label4:
            cmp_lt ::temp0 modVK 0 
            jmpf ::temp0 _label8
            ; line 5884
            callstatic sNRom_Bridge LOG_WARN ::temp1 ;0 variable args
            strcat ::temp2 "Dashboard hotkey NOT bound: modifier '" modName 
            strcat ::temp2 ::temp2 "' is not one of the " 
            strcat ::temp2 ::temp2 "options. Choose one under Dashboard in the settings panel." 
            callmethod Diag self ::nonevar ::temp1 ::temp2 False ;3 variable args
            ; line 5886
            callmethod Say self ::nonevar "That dashboard modifier can't be used - choose another in the settings." ;1 variable args
            jmp _label7
            ; line 5890
          _label8:
            callstatic sNRom_Bridge LOG_WARN ::temp1 ;0 variable args
            cast ::temp2 vk 
            strcat ::temp2 "Dashboard hotkey NOT bound: virtual key " ::temp2 
            strcat ::temp2 ::temp2 " has no keyboard " 
            strcat ::temp2 ::temp2 "scan code. Choose another key under Dashboard in the settings panel." 
            callmethod Diag self ::nonevar ::temp1 ::temp2 False ;3 variable args
            ; line 5896
            callmethod Say self ::nonevar "That dashboard key can't be used - choose another in the settings." ;1 variable args
          _label7
          .endCode
        .endFunction ;ArmDashboard
        .function DashboardCacheStore
           ; function type 0
          .userFlags 0 ;none
          .docString "The live store and the playthrough id, as the dashboard's refresh reads
      them. Both come from SkyrimNet, which the refresh may not ask (see
      OnDashboardRefresh), so they are read here: at every bootstrap, and by
      StartFreshStore and AdoptLegacyStore, the only things that move the store
      mid-session. EnsureSaveId decides the store once per bootstrap, before
      ArmDashboard runs."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 5907
            callstatic sNRom_Bridge PlaythroughId ::temp0 ;0 variable args
            assign _dashPlaythrough ::temp0 
            ; line 5908
            callstatic sNRom_Bridge StoreFile ::temp0 ;0 variable args
            assign _dashStore ::temp0 
          .endCode
        .endFunction ;DashboardCacheStore
        .function DashboardPoints
           ; function type 0
          .userFlags 0 ;none
          .docString "THE ONE PLACE THE DASHBOARD READS POINTS: [0] points held, [1] the tier
      0-5 (DashboardTier), [2] points banked by the consent gate while the
      question waits.

      OURS FROM 1.9 (WP4): PointsOf is a StorageUtil read, so a refresh no
      longer makes Romantasy's frame-waiting GetPoints call once per bond -
      that call was nearly all of the 2.5-3 s a refresh took. An actor the
      one-time import has not reached yet still reads Romantasy's number
      through PointsOf. It only reads: nothing on the dashboard's path writes
      a point."
          .return Int[]
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local pts Int[]
            .local ::temp0 Int[]
            .local ::temp1 Int
            .local ::temp2 form
          .endLocalTable
          .code
            ; line 5922
            array_create ::temp0 3 
            assign pts ::temp0 
            ; line 5923
            callstatic sNRom_Bridge PointsOf ::temp1 akActor ;1 variable args
            array_setelement pts 0 ::temp1 
            ; line 5924
            array_getlement ::temp1 pts 0 
            callstatic sNRom_Bridge DashboardTier ::temp1 ::temp1 ;1 variable args
            array_setelement pts 1 ::temp1 
            ; line 5925
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_BankedPoints" 0 ;3 variable args
            array_setelement pts 2 ::temp1 
            ; line 5926
            return pts 
          .endCode
        .endFunction ;DashboardPoints
        .function DashboardTier
           ; function type 0
          .userFlags 0 ;none
          .docString "The tier, 0-5, from points on the ladder the snapshot sends (thresholds
      500 apart). Romantasy's own level is exactly this: GetLevel is
      LevelNumberForPoints(points), 1-6, in its RomanceManager.cpp. Worked out
      here instead of asking GetLevel because that native waits a frame, and a
      refresh may not make a per-bond call that waits a frame (design 7.3,
      "Measured in play"). Nobody Romantasy tracks has 0 points, which is tier
      0 either way."
          .return Int
          .paramTable
            .param aiPoints Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 5937
            comp_gte ::temp0 aiPoints 2500 
            jmpf ::temp0 _label0
            ; line 5938
            return 5 
            jmp _label1
            ; line 5939
          _label0:
            comp_gte ::temp0 aiPoints 2000 
            jmpf ::temp0 _label2
            ; line 5940
            return 4 
            jmp _label1
            ; line 5941
          _label2:
            comp_gte ::temp0 aiPoints 1500 
            jmpf ::temp0 _label3
            ; line 5942
            return 3 
            jmp _label1
            ; line 5943
          _label3:
            comp_gte ::temp0 aiPoints 1000 
            jmpf ::temp0 _label4
            ; line 5944
            return 2 
            jmp _label1
            ; line 5945
          _label4:
            comp_gte ::temp0 aiPoints 500 
            jmpf ::temp0 _label1
            ; line 5946
            return 1 
            jmp _label1
            ; line 5948
          _label1:
            return 0 
          .endCode
        .endFunction ;DashboardTier
        .function DashMinutes
           ; function type 0
          .userFlags 0 ;none
          .docString "A game time as whole game minutes, for the dashboard's Int array; -1 for
      never, which is how every one of these keys reads when unset (0.0)."
          .return Int
          .paramTable
            .param afGameTime Float
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 Float
            .local ::temp2 Int
          .endLocalTable
          .code
            ; line 5954
            cmp_lte ::temp0 afGameTime 0.0 
            jmpf ::temp0 _label0
            ; line 5955
            return -1 
            jmp _label0
            ; line 5957
          _label0:
            fmul ::temp1 afGameTime 1440.0 
            cast ::temp2 ::temp1 
            return ::temp2 
          .endCode
        .endFunction ;DashMinutes
        .function DashboardNumbers
           ; function type 0
          .userFlags 0 ;none
          .docString "ONE ACTOR'S NUMBERS, as SNRom_Native.PutBondNumbers takes them.

      THE ORDER IS enum Number IN native/src/Model.h, which cites this function.
      Change one, change both: the DLL refuses an array of the wrong length, and
      a reordering it cannot see would put one value in another's place.

      STORAGEUTIL READS ONLY - points included, since WP4 made them ours
      (PointsOf; until the import reaches someone, their number is still read
      from Romantasy). The first
      version asked the engine, MARAS and SeverActions here too, about twenty
      calls per bond that each waited a frame: 55 seconds for 122 bonds
      (design 7.3, "Measured in play"). Now the DLL reads the engine itself, and
      OnDashboardRefresh fetches MARAS and SeverActions once per refresh.
      Following, commitment and foreclosure are worked out by display copies in
      the DLL (native/src/Display.cpp); the gates keep calling Papyrus.

      NO SKYRIMNET CALL, NO DIAG, NO JSONUTIL: it runs inside
      OnDashboardRefresh, while the dashboard has the game paused."
          .return Int[]
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local n Int[]
            .local ::temp0 Int[]
            .local pts Int[]
            .local ::temp1 Int
            .local ::temp2 form
            .local ::temp3 Float
            .local ::temp4 Bool
          .endLocalTable
          .code
            ; line 5979
            array_create ::temp0 21 
            assign n ::temp0 
            ; line 5980
            callstatic sNRom_Bridge DashboardPoints ::temp0 akActor ;1 variable args
            assign pts ::temp0 
            ; line 5981
            array_getlement ::temp1 pts 0 
            array_setelement n 0 ::temp1 
            ; line 5982
            array_getlement ::temp1 pts 1 
            array_setelement n 1 ::temp1 
            ; line 5983
            array_getlement ::temp1 pts 2 
            array_setelement n 2 ::temp1 
            ; line 5984
            cast ::temp2 akActor 
            callstatic storageUtil GetFloatValue ::temp3 ::temp2 "SNRom_LastFollowingAt" 0.0 ;3 variable args
            callstatic sNRom_Bridge DashMinutes ::temp1 ::temp3 ;1 variable args
            array_setelement n 3 ::temp1 
            ; line 5985
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_AutoEnrolled" 0 ;3 variable args
            array_setelement n 4 ::temp1 
            ; line 5986
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_Enrolled" 0 ;3 variable args
            array_setelement n 5 ::temp1 
            ; line 5987
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_PlayerStance" 0 ;3 variable args
            array_setelement n 6 ::temp1 
            ; line 5988
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_AskPending" 0 ;3 variable args
            array_setelement n 7 ::temp1 
            ; line 5989
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_Sparked" 0 ;3 variable args
            array_setelement n 8 ::temp1 
            ; line 5990
            callstatic sNRom_Bridge SparkDecided ::temp4 akActor ;1 variable args
            cast ::temp1 ::temp4 
            array_setelement n 9 ::temp1 
            ; line 5991
            cast ::temp2 akActor 
            callstatic storageUtil GetFloatValue ::temp3 ::temp2 "SNRom_SparkedAt" 0.0 ;3 variable args
            callstatic sNRom_Bridge DashMinutes ::temp1 ::temp3 ;1 variable args
            array_setelement n 10 ::temp1 
            ; line 5992
            cast ::temp2 akActor 
            callstatic storageUtil GetFloatValue ::temp3 ::temp2 "SNRom_LastSparkCheck" 0.0 ;3 variable args
            callstatic sNRom_Bridge DashMinutes ::temp1 ::temp3 ;1 variable args
            array_setelement n 11 ::temp1 
            ; line 5993
            cast ::temp2 akActor 
            callstatic storageUtil GetFloatValue ::temp3 ::temp2 "SNRom_EndedAt" 0.0 ;3 variable args
            callstatic sNRom_Bridge DashMinutes ::temp1 ::temp3 ;1 variable args
            array_setelement n 12 ::temp1 
            ; line 5994
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_Seeded" 0 ;3 variable args
            array_setelement n 13 ::temp1 
            ; line 5995
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_DispositionAuthored" 0 ;3 variable args
            array_setelement n 14 ::temp1 
            ; line 5996
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_PhysMinTier" 4 ;3 variable args
            callstatic sNRom_Decorators IntimacyRank ::temp1 ::temp1 ;1 variable args
            array_setelement n 15 ::temp1 
            ; line 5997
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_Ardor" 2 ;3 variable args
            array_setelement n 16 ::temp1 
            ; line 5998
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_Exclusivity" 50 ;3 variable args
            array_setelement n 17 ::temp1 
            ; line 5999
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_Orientation" 3 ;3 variable args
            array_setelement n 18 ::temp1 
            ; line 6000
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp2 "SNRom_OrientationKnown" 0 ;3 variable args
            array_setelement n 19 ::temp1 
            ; line 6001
            callstatic sNRom_Decorators IsPlayerKin ::temp4 akActor ;1 variable args
            cast ::temp1 ::temp4 
            array_setelement n 20 ::temp1 
            ; line 6002
            return n 
          .endCode
        .endFunction ;DashboardNumbers
        .function DashboardText
           ; function type 0
          .userFlags 0 ;none
          .docString "ONE ACTOR'S TEXT, as SNRom_Native.PutBondText takes it: [0] WHY, [1] LIMIT,
      [2] ADDRESS. THE ORDER IS enum Text IN native/src/Model.h, which cites
      this function. No name: GetDisplayName waits a frame, and the DLL reads
      the name from the engine itself.

      asStoreName is the store ArmDashboard cached, because StoreFile() asks
      SkyrimNet for the playthrough id and this runs while the game is paused.

      The form id comes from SNRom_Native.FormIdOf, which answers without
      waiting for a frame, rather than akActor.GetFormID(), which StoreKey
      would otherwise call once per field: a full refresh reads 122 bonds.

      NO LIKES OR DISLIKES. Romantasy's name game statistics and do not carry
      into Relationships (the author, 2026-09-30); phase 5's own preferences,
      against our vocabulary, are the ones the dashboard will show."
          .return String[]
          .paramTable
            .param akActor actor
            .param asStoreName String
          .endParamTable
          .localTable
            .local id Int
            .local ::temp0 Int
            .local t String[]
            .local ::temp1 String[]
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 6021
            callstatic sNRom_Native FormIdOf ::temp0 akActor ;1 variable args
            assign id ::temp0 
            ; line 6022
            array_create ::temp1 3 
            assign t ::temp1 
            ; line 6023
            callstatic sNRom_Bridge StoreGetText ::temp2 akActor "Why" asStoreName id ;4 variable args
            array_setelement t 0 ::temp2 
            ; line 6024
            callstatic sNRom_Bridge StoreGetText ::temp2 akActor "Limit" asStoreName id ;4 variable args
            array_setelement t 1 ::temp2 
            ; line 6025
            callstatic sNRom_Bridge StoreGetText ::temp2 akActor "Address" asStoreName id ;4 variable args
            array_setelement t 2 ::temp2 
            ; line 6026
            return t 
          .endCode
        .endFunction ;DashboardText
        .function PushBondText
           ; function type 0
          .userFlags 0 ;none
          .docString "A TEXT WRITER'S PUSH. Once a full refresh has answered this session
      (_dashText), the DLL holds everyone's name, WHY, LIMIT and ADDRESS, and it
      never asks for them again until the next load - every later open refreshes
      only the numbers. So each function that writes that text pushes the actor
      it wrote, here: one native call, as generation 0, which the DLL shows at
      once if the dashboard is open.

      CALLERS CHECK _dashText FIRST, so the only cost when nobody opens the
      dashboard is that Bool (kickoff WP2, e). This checks the version gate as
      well, like every native call site.

      The writers, and the grep that finds them, are listed in the WP2 pull
      request: every StoreSetText of Why, Limit or Address, and the two store
      repairs, which change which store all of it is read from."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::nonevar None
            .local ::temp2 String[]
          .endLocalTable
          .code
            ; line 6044
            comp_gte ::temp0 _dashNatives 3 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 akActor ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 6045
            callstatic sNRom_Bridge DashboardText ::temp2 akActor _dashStore ;2 variable args
            callstatic sNRom_Native PutBondText ::nonevar 0 akActor ::temp2 ;3 variable args
            jmp _label1
          _label1
          .endCode
        .endFunction ;PushBondText
        .function DashboardPutFacts
           ; function type 0
          .userFlags 0 ;none
          .docString "What the DLL's display copies need from other mods, fetched ONCE per
      refresh with their batch calls and handed over in one native
      (SNRom_Native.PutRefreshFacts). Asking per bond was IsNPCStatus three
      times and Native_GetIsFollower once, each waiting a frame.

      - MARAS.GetNPCsByStatus for "married", "engaged" and "candidate". Each is
        exactly the set its IsNPCStatus tests (both read the same set in MARAS's
        NPCRelationshipManager), less forms that are not loaded, which a
        roster member always is.
      - SeverActions' Native_GetActiveFollowerRoster and
        Native_GetDeadTrackedFollowers. Native_GetIsFollower, which IsFollowing
        asks, reads isFollower in SeverActions' store; the active roster is
        that minus the dead (its own docstring), and the other is exactly the
        dead. Together they answer as it does.
      - The kin guard ArmDashboard read."
          .return None
          .paramTable
            .param aiGeneration Int
          .endParamTable
          .localTable
            .local married actor[]
            .local engaged actor[]
            .local candidates actor[]
            .local ::temp0 actor[]
            .local severActive actor[]
            .local severDead actor[]
            .local ::nonevar None
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 6068
            jmpf _dashMaras _label0
            ; line 6069
            callstatic mARAS GetNPCsByStatus ::temp0 "married" ;1 variable args
            assign married ::temp0 
            ; line 6070
            callstatic mARAS GetNPCsByStatus ::temp0 "engaged" ;1 variable args
            assign engaged ::temp0 
            ; line 6071
            callstatic mARAS GetNPCsByStatus ::temp0 "candidate" ;1 variable args
            assign candidates ::temp0 
            jmp _label0
            ; line 6075
          _label0:
            jmpf _dashSever _label1
            ; line 6076
            callstatic severActionsNativeExt Native_GetActiveFollowerRoster ::temp0 ;0 variable args
            assign severActive ::temp0 
            ; line 6077
            callstatic severActionsNativeExt Native_GetDeadTrackedFollowers ::temp0 ;0 variable args
            assign severDead ::temp0 
            jmp _label1
            ; line 6079
          _label1:
            cmp_gt ::temp1 _dashKinGuard 0 
            callstatic sNRom_Native PutRefreshFacts ::nonevar aiGeneration ::temp1 _dashMaras married engaged candidates _dashSever severActive severDead ;9 variable args
          .endCode
        .endFunction ;DashboardPutFacts
        .function PushAllBondText
           ; function type 0
          .userFlags 0 ;none
          .docString "Everyone's text again, and the playthrough: for StartFreshStore and
      AdoptLegacyStore, which switch the store every line is read from. One call
      per roster member, like a full refresh, but only when a player runs one of
      those repairs with the dashboard live."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local count Int
            .local ::temp1 form
            .local ::temp2 Int
            .local i Int
            .local a actor
            .local ::temp3 actor
            .local ::nonevar None
            .local ::temp4 String[]
          .endLocalTable
          .code
            ; line 6088
            cmp_lt ::temp0 _dashNatives 3 
            jmpf ::temp0 _label0
            ; line 6089
            return None 
            jmp _label0
            ; line 6091
          _label0:
            cast ::temp1 None 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "SNRom_Roster" ;2 variable args
            assign count ::temp2 
            ; line 6092
            assign i 0 
            ; line 6093
          _label3:
            cmp_lt ::temp0 i count 
            jmpf ::temp0 _label1
            ; line 6094
            cast ::temp1 None 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "SNRom_Roster" i ;3 variable args
            cast ::temp3 ::temp1 
            assign a ::temp3 
            ; line 6095
            cast ::temp3 None 
            cmp_eq ::temp0 a ::temp3 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 6096
            callstatic sNRom_Bridge DashboardText ::temp4 a _dashStore ;2 variable args
            callstatic sNRom_Native PutBondText ::nonevar 0 a ::temp4 ;3 variable args
            jmp _label2
            ; line 6098
          _label2:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label3
            ; line 6100
          _label1:
            cast ::temp1 None 
            callstatic storageUtil GetIntValue ::temp2 ::temp1 "SNRom_SaveId" 0 ;3 variable args
            callstatic sNRom_Native PutPlaythrough ::nonevar 0 _dashPlaythrough _dashStore ::temp2 ;4 variable args
          .endCode
        .endFunction ;PushAllBondText
        .function PushBond
           ; function type 0
          .userFlags 0 ;none
          .docString "One actor's whole row, numbers and text. For a page action (generation
      -1, answered by ActionDone, which sends the snapshot) and for the LLM
      callbacks a long-running action ends in (generation 0, shown at once if
      the dashboard is open). Not for the refresh, which pushes its own."
          .return None
          .paramTable
            .param akActor actor
            .param aiGeneration Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::nonevar None
            .local ::temp2 Int[]
            .local ::temp3 String[]
          .endLocalTable
          .code
            ; line 6108
            cmp_lt ::temp0 _dashNatives 3 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 akActor ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 6109
            return None 
            jmp _label1
            ; line 6111
          _label1:
            callstatic sNRom_Bridge DashboardNumbers ::temp2 akActor ;1 variable args
            callstatic sNRom_Native PutBondNumbers ::nonevar aiGeneration akActor ::temp2 ;3 variable args
            ; line 6112
            callstatic sNRom_Bridge DashboardText ::temp3 akActor _dashStore ;2 variable args
            callstatic sNRom_Native PutBondText ::nonevar aiGeneration akActor ::temp3 ;3 variable args
          .endCode
        .endFunction ;PushBond
        .function DashboardDeveloperOp
           ; function type 0
          .userFlags 0 ;none
          .docString "The developer tools in ui/relationships/actions.js (developer: true), and
      in the DLL's op table. Each bypasses a gate that is the design, so both
      sides refuse them unless the developer view is on."
          .return Bool
          .paramTable
            .param asOp String
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 6119
            cmp_eq ::temp0 asOp "RequestSparkNow" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cmp_eq ::temp0 asOp "UnsparkActor" 
            assign ::temp0 ::temp0 
          _label0:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label1
            cmp_eq ::temp0 asOp "ForceDriftReview" 
            assign ::temp0 ::temp0 
          _label1:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label2
            ; line 6120
            cmp_eq ::temp0 asOp "CheckDisplay" 
            assign ::temp0 ::temp0 
          _label2:
            return ::temp0 
          .endCode
        .endFunction ;DashboardDeveloperOp
        .function CheckDashboardDisplay
           ; function type 0
          .userFlags 0 ;none
          .docString "DEVELOPER TOOL: "Check the display against the rules". Runs the REAL
      IsFollowing, CommitmentState and RomanceApplicability for every bond and
      hands each answer to the DLL, which works out its display copy of the same
      three (native/src/Display.cpp) at the same moment and logs every
      disagreement to SkyrimNetRelationships.log, with the name, the field and
      both values. Returns the line the page shows.

      WHY IT EXISTS. The dashboard draws following, commitment and foreclosure
      from those copies, because asking Papyrus per bond cost 55 seconds for
      122 bonds (design 7.3, "Measured in play"). The author wants to see in
      play that the copies agree before trusting them; this is that evidence.

      LIKE FOR LIKE. The batch sets are fetched fresh first, as a refresh
      fetches them, and each bond's StorageUtil values are pushed just before
      its answer, so the copy and the rules see the same facts. The kin guard
      is read once and handed to both.

      SLOW ON PURPOSE: it pays the old per-bond cost, about a minute with 120
      bonds. It runs only when asked from the dashboard; nothing runs it
      automatically."
          .return String
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 Int
            .local ::nonevar None
            .local checked Int
            .local disagreements Int
            .local count Int
            .local ::temp2 form
            .local i Int
            .local a actor
            .local ::temp3 actor
            .local ::temp4 Int[]
            .local ::temp5 Int
            .local ::temp6 String
            .local ::temp7 String
          .endLocalTable
          .code
            ; line 6144
            callstatic sNRom_Decorators KinGuardOn ::temp0 ;0 variable args
            cast ::temp1 ::temp0 
            assign _dashKinGuard ::temp1 
            ; line 6145
            callmethod DashboardPutFacts self ::nonevar -1 ;1 variable args
            ; line 6146
            assign checked 0 
            ; line 6147
            assign disagreements 0 
            ; line 6148
            cast ::temp2 None 
            callstatic storageUtil FormListCount ::temp1 ::temp2 "SNRom_Roster" ;2 variable args
            assign count ::temp1 
            ; line 6149
            assign i 0 
            ; line 6150
          _label2:
            cmp_lt ::temp0 i count 
            jmpf ::temp0 _label0
            ; line 6151
            cast ::temp2 None 
            callstatic storageUtil FormListGet ::temp2 ::temp2 "SNRom_Roster" i ;3 variable args
            cast ::temp3 ::temp2 
            assign a ::temp3 
            ; line 6152
            cast ::temp3 None 
            cmp_eq ::temp0 a ::temp3 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label1
            ; line 6153
            callstatic sNRom_Bridge DashboardNumbers ::temp4 a ;1 variable args
            callstatic sNRom_Native PutBondNumbers ::nonevar -1 a ::temp4 ;3 variable args
            ; line 6154
            callstatic sNRom_Bridge IsFollowing ::temp0 a ;1 variable args
            callstatic sNRom_Bridge CommitmentState ::temp1 a ;1 variable args
            ; line 6155
            callstatic sNRom_Decorators RomanceApplicability ::temp5 a _dashKinGuard ;2 variable args
            callstatic sNRom_Native CheckBond ::temp5 a ::temp0 ::temp1 ::temp5 ;4 variable args
            iadd ::temp5 disagreements ::temp5 
            assign disagreements ::temp5 
            ; line 6156
            iadd ::temp5 checked 1 
            assign checked ::temp5 
            jmp _label1
            ; line 6158
          _label1:
            iadd ::temp5 i 1 
            assign i ::temp5 
            jmp _label2
            ; line 6161
          _label0:
            cast ::temp6 checked 
            strcat ::temp6 ::temp6 " bonds checked, " 
            cast ::temp7 disagreements 
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 " disagreements (see SkyrimNetRelationships.log)." 
            return ::temp7 
          .endCode
        .endFunction ;CheckDashboardDisplay
        .function OnDashboardAction
           ; function type 0
          .userFlags 0 ;none
          .docString "A page action, from SkyrimNetRelationships.dll (kickoff WP2, d). The DLL
      has already checked asOp against its own fixed table; this maps it again,
      through this one, to the function actions.js names beside it. The page
      is data and never names a function.

      akSender is the actor, as a form: never a form id in a string. The Int
      arguments come from SNRom_Native.ActionArgs, never parsed from text.

      THE ROW, THEN THE ANSWER. The actor's row is pushed first (generation -1)
      and ActionDone second, because ActionDone is what makes the DLL send the
      page its result and a fresh snapshot.

      LONG-RUNNING ACTIONS SAY "STARTED". The re-read, re-author and preference
      repair finish in an LLM callback; their wrappers push the row when it
      lands (OnSeedAssessed, OnDispositionAuthored), and the DLL tells the page.

      Calls each function as it is. None of them changes the consent gate, and
      none is changed here (brief 2; design 13.4)."
          .return None
          .paramTable
            .param asEventName String
            .param asOp String
            .param afRequestId Float
            .param akSender form
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local requestId Int
            .local ::temp1 Int
            .local who actor
            .local ::temp2 actor
            .local ::nonevar None
            .local forPlaythrough Bool
            .local whoName String
            .local ::temp3 String
            .local answer String
            .local fieldArgs Int[]
            .local ::temp4 Int[]
            .local ::temp5 Int
            .local refused String
            .local driftArgs Int[]
            .local field Int
          .endLocalTable
          .code
            ; line 6184
            cmp_lt ::temp0 _dashNatives 3 
            jmpf ::temp0 _label0
            ; line 6185
            return None 
            jmp _label0
            ; line 6187
          _label0:
            cast ::temp1 afRequestId 
            assign requestId ::temp1 
            ; line 6188
            cast ::temp2 akSender 
            assign who ::temp2 
            ; line 6189
            not ::temp0 _ready 
            jmpf ::temp0 _label1
            ; line 6190
            callstatic sNRom_Native ActionDone ::nonevar requestId False "Relationships has not started, so nothing was done." ;3 variable args
            ; line 6191
            return None 
            jmp _label1
            ; line 6196
          _label1:
            callstatic sNRom_Bridge DashboardDeveloperOp ::temp0 asOp ;1 variable args
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label2
            callstatic sNRom_Bridge DeveloperViewWanted ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label2:
            jmpf ::temp0 _label3
            ; line 6197
            callstatic sNRom_Native ActionDone ::nonevar requestId False "That is a developer tool, and the developer view is off." ;3 variable args
            ; line 6198
            return None 
            jmp _label3
            ; line 6200
          _label3:
            cmp_eq ::temp0 asOp "StartFreshStore" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label4
            cmp_eq ::temp0 asOp "AdoptLegacyStore" 
            assign ::temp0 ::temp0 
          _label4:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label5
            cmp_eq ::temp0 asOp "CheckDisplay" 
            assign ::temp0 ::temp0 
          _label5:
            assign forPlaythrough ::temp0 
            ; line 6201
            not ::temp0 forPlaythrough 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label6
            cast ::temp2 None 
            cmp_eq ::temp0 who ::temp2 
            assign ::temp0 ::temp0 
          _label6:
            jmpf ::temp0 _label7
            ; line 6202
            callstatic sNRom_Native ActionDone ::nonevar requestId False "They could not be found in the game right now." ;3 variable args
            ; line 6203
            return None 
            jmp _label7
            ; line 6205
          _label7:
            assign whoName "" 
            ; line 6206
            cast ::temp2 None 
            cmp_eq ::temp0 who ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label8
            ; line 6207
            callmethod GetDisplayName who ::temp3 ;0 variable args
            assign whoName ::temp3 
            jmp _label8
            ; line 6209
          _label8:
            assign answer "" 
            ; line 6210
            cmp_eq ::temp0 asOp "ReseedActor" 
            jmpf ::temp0 _label9
            ; line 6218
            callmethod SeedReadInFlight self ::temp0 ;0 variable args
            jmpf ::temp0 _label10
            ; line 6219
            strcat ::temp3 "A read for " _seedName 
            strcat ::temp3 ::temp3 " is still out. Try again when it comes back." 
            callstatic sNRom_Native ActionDone ::nonevar requestId False ::temp3 ;3 variable args
            ; line 6221
            return None 
            jmp _label10
            ; line 6223
          _label10:
            callmethod ReseedActor self ::nonevar who ;1 variable args
            ; line 6224
            strcat ::temp3 "Reading " whoName 
            strcat ::temp3 ::temp3 "'s record again. This updates when the answer comes back." 
            assign answer ::temp3 
            jmp _label11
            ; line 6225
          _label9:
            cmp_eq ::temp0 asOp "ReauthorCharacter" 
            jmpf ::temp0 _label12
            ; line 6226
            callmethod ReauthorCharacter self ::nonevar who ;1 variable args
            ; line 6227
            strcat ::temp3 "Writing " whoName 
            strcat ::temp3 ::temp3 "'s character again. This updates when the answer comes back." 
            assign answer ::temp3 
            jmp _label11
            ; line 6228
          _label12:
            cmp_eq ::temp0 asOp "SetCharacterField" 
            jmpf ::temp0 _label13
            ; line 6229
            callstatic sNRom_Native ActionArgs ::temp4 requestId ;1 variable args
            assign fieldArgs ::temp4 
            ; line 6230
            array_length ::temp1 fieldArgs 
            cmp_lt ::temp0 ::temp1 2 
            jmpf ::temp0 _label14
            ; line 6231
            callstatic sNRom_Native ActionDone ::nonevar requestId False "Correct one trait needs a trait and a value." ;3 variable args
            ; line 6232
            return None 
            jmp _label14
            ; line 6234
          _label14:
            array_getlement ::temp1 fieldArgs 0 
            array_getlement ::temp5 fieldArgs 1 
            callmethod SetCharacterField self ::nonevar who ::temp1 ::temp5 ;3 variable args
            ; line 6235
            strcat ::temp3 "Corrected one of " whoName 
            strcat ::temp3 ::temp3 "'s traits." 
            assign answer ::temp3 
            jmp _label11
            ; line 6236
          _label13:
            cmp_eq ::temp0 asOp "EnrollActor" 
            jmpf ::temp0 _label15
            ; line 6237
            callmethod EnrollByHand self ::temp3 who ;1 variable args
            assign refused ::temp3 
            ; line 6238
            cmp_eq ::temp0 refused "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label16
            ; line 6239
            callstatic sNRom_Native ActionDone ::nonevar requestId False refused ;3 variable args
            ; line 6240
            return None 
            jmp _label16
            ; line 6242
          _label16:
            strcat ::temp3 whoName " is enrolled. Their character is being written, and their record read, " 
            strcat ::temp3 ::temp3 "in the next few minutes." 
            assign answer ::temp3 
            jmp _label11
            ; line 6244
          _label15:
            cmp_eq ::temp0 asOp "UnenrollActor" 
            jmpf ::temp0 _label17
            ; line 6245
            callmethod UnenrollActor self ::nonevar who ;1 variable args
            ; line 6246
            callstatic sNRom_Native DropBond ::nonevar who ;1 variable args
            ; line 6247
            strcat ::temp3 whoName " is off the roster and no longer observed." 
            callstatic sNRom_Native ActionDone ::nonevar requestId True ::temp3 ;3 variable args
            ; line 6248
            return None 
            jmp _label11
            ; line 6249
          _label17:
            cmp_eq ::temp0 asOp "StartFreshStore" 
            jmpf ::temp0 _label18
            ; line 6250
            callmethod StartFreshStore self ::nonevar ;0 variable args
            ; line 6251
            assign answer "This playthrough now has its own store. Nothing was deleted." 
            jmp _label11
            ; line 6252
          _label18:
            cmp_eq ::temp0 asOp "AdoptLegacyStore" 
            jmpf ::temp0 _label19
            ; line 6253
            callmethod AdoptLegacyStore self ::nonevar ;0 variable args
            ; line 6254
            assign answer "This playthrough is back on the main store." 
            jmp _label11
            ; line 6255
          _label19:
            cmp_eq ::temp0 asOp "RequestSparkNow" 
            jmpf ::temp0 _label20
            ; line 6256
            callmethod RequestSparkNow self ::nonevar who ;1 variable args
            ; line 6257
            strcat ::temp3 "Asked the spark assessor about " whoName 
            strcat ::temp3 ::temp3 ". It declines on its own if they " 
            strcat ::temp3 ::temp3 "already have a verdict or are not loaded; the next open shows the result." 
            assign answer ::temp3 
            jmp _label11
            ; line 6259
          _label20:
            cmp_eq ::temp0 asOp "UnsparkActor" 
            jmpf ::temp0 _label21
            ; line 6260
            callmethod UnsparkActor self ::nonevar who ;1 variable args
            ; line 6261
            strcat ::temp3 whoName " is back on the platonic ladder, with every point kept." 
            assign answer ::temp3 
            jmp _label11
            ; line 6262
          _label21:
            cmp_eq ::temp0 asOp "ForceDriftReview" 
            jmpf ::temp0 _label22
            ; line 6264
            callstatic sNRom_Native ActionArgs ::temp4 requestId ;1 variable args
            assign driftArgs ::temp4 
            ; line 6265
            assign field -1 
            ; line 6266
            array_length ::temp5 driftArgs 
            cmp_gt ::temp0 ::temp5 0 
            jmpf ::temp0 _label23
            ; line 6267
            array_getlement ::temp5 driftArgs 0 
            assign field ::temp5 
            jmp _label23
            ; line 6269
          _label23:
            callmethod ForceDriftReview self ::nonevar who field ;2 variable args
            ; line 6270
            strcat ::temp3 "Asked for a drift review of " whoName 
            strcat ::temp3 ::temp3 ". The next open shows the result." 
            assign answer ::temp3 
            jmp _label11
            ; line 6271
          _label22:
            cmp_eq ::temp0 asOp "CheckDisplay" 
            jmpf ::temp0 _label24
            ; line 6272
            callmethod CheckDashboardDisplay self ::temp3 ;0 variable args
            assign answer ::temp3 
            jmp _label11
            ; line 6274
          _label24:
            strcat ::temp3 "This version of the scripts has no operation " asOp 
            strcat ::temp3 ::temp3 "." 
            callstatic sNRom_Native ActionDone ::nonevar requestId False ::temp3 ;3 variable args
            ; line 6275
            return None 
            ; line 6277
          _label11:
            cast ::temp2 None 
            cmp_eq ::temp0 who ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label25
            ; line 6278
            callmethod PushBond self ::nonevar who -1 ;2 variable args
            jmp _label25
            ; line 6280
          _label25:
            callstatic sNRom_Native ActionDone ::nonevar requestId True answer ;3 variable args
          .endCode
        .endFunction ;OnDashboardAction
        .function OnDashboardRefresh
           ; function type 0
          .userFlags 0 ;none
          .docString "SkyrimNetRelationships.dll asks for the roster: every time the dashboard
      opens (design 7.3, the WP2 transport). The page is already showing what
      the DLL held; this pushes one call per roster member into its read model,
      then says RefreshDone, and the DLL sends the page the result.

      asScope "full" (the first open after a load) also pushes everyone's text
      and the playthrough; "numbers" pushes only the numbers, which every open
      refreshes. afGeneration numbers this refresh, so the DLL can drop an
      answer to one it has stopped waiting for.

      THREE THINGS IT MUST NOT DO, because the dashboard has the game paused:
      - Utility.Wait, which does not return while the game is paused;
      - write to JsonUtil;
      - call SkyrimNet's API, which SkyrimNet has been seen refusing while the
        game is paused. That rules out Diag too, since every Diag line reads the
        log level from SkyrimNet. The DLL logs the outcome and how long it took.

      "NOT READY" IS AN ANSWER. Said instead of an empty roster, so the page
      can tell the player the mod has not started rather than that nobody is
      on it."
          .return None
          .paramTable
            .param asEventName String
            .param asScope String
            .param afGeneration Float
            .param akSender form
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local generation Int
            .local ::temp1 Int
            .local ::nonevar None
            .local ::temp2 String
            .local withText Bool
            .local fromStore String
            .local pushed Int
            .local count Int
            .local ::temp3 form
            .local i Int
            .local a actor
            .local ::temp4 actor
            .local ::temp5 Int[]
            .local ::temp6 String[]
          .endLocalTable
          .code
            ; line 6306
            cmp_lt ::temp0 _dashNatives 3 
            jmpf ::temp0 _label0
            ; line 6307
            return None 
            jmp _label0
            ; line 6309
          _label0:
            cast ::temp1 afGeneration 
            assign generation ::temp1 
            ; line 6310
            not ::temp0 _ready 
            jmpf ::temp0 _label1
            ; line 6311
            strcat ::temp2 "not ready: Relationships has not started. " "SNRom_Integration.esl is missing or out of date (see snrom.log)." 
            callstatic sNRom_Native RefreshDone ::nonevar generation 0 ::temp2 ;3 variable args
            ; line 6313
            return None 
            jmp _label1
            ; line 6315
          _label1:
            cmp_eq ::temp0 asScope "full" 
            assign withText ::temp0 
            ; line 6316
            assign fromStore _dashStore 
            ; line 6319
            callmethod DashboardPutFacts self ::nonevar generation ;1 variable args
            ; line 6320
            assign pushed 0 
            ; line 6321
            cast ::temp3 None 
            callstatic storageUtil FormListCount ::temp1 ::temp3 "SNRom_Roster" ;2 variable args
            assign count ::temp1 
            ; line 6322
            assign i 0 
            ; line 6323
          _label5:
            cmp_lt ::temp0 i count 
            jmpf ::temp0 _label2
            ; line 6324
            cast ::temp3 None 
            callstatic storageUtil FormListGet ::temp3 ::temp3 "SNRom_Roster" i ;3 variable args
            cast ::temp4 ::temp3 
            assign a ::temp4 
            ; line 6325
            cast ::temp4 None 
            cmp_eq ::temp0 a ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label3
            ; line 6326
            callstatic sNRom_Bridge DashboardNumbers ::temp5 a ;1 variable args
            callstatic sNRom_Native PutBondNumbers ::nonevar generation a ::temp5 ;3 variable args
            ; line 6327
            jmpf withText _label4
            ; line 6328
            callstatic sNRom_Bridge DashboardText ::temp6 a fromStore ;2 variable args
            callstatic sNRom_Native PutBondText ::nonevar generation a ::temp6 ;3 variable args
            jmp _label4
            ; line 6330
          _label4:
            iadd ::temp1 pushed 1 
            assign pushed ::temp1 
            jmp _label3
            ; line 6332
          _label3:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label5
            ; line 6334
          _label2:
            jmpf withText _label6
            ; line 6336
            cast ::temp3 None 
            callstatic storageUtil GetIntValue ::temp1 ::temp3 "SNRom_SaveId" 0 ;3 variable args
            callstatic sNRom_Native PutPlaythrough ::nonevar generation _dashPlaythrough fromStore ::temp1 ;4 variable args
            ; line 6337
            assign _dashText True 
            jmp _label6
            ; line 6339
          _label6:
            callstatic sNRom_Native RefreshDone ::nonevar generation pushed "ok" ;3 variable args
          .endCode
        .endFunction ;OnDashboardRefresh
        .function EnrollmentPendingReason
           ; function type 0
          .userFlags 0 ;none
          .docString "Why this person is not being observed YET, in words that match what the
      player can see. Returns "" when they are fully enrolled and scoreable.

      WHY THIS EXISTS. Both hotkeys said "X is not being observed - only
      followers are" for every unenrolled actor, which is true of the mod and
      false to the player: they are pointing at a companion who is plainly
      following them, so the sentence reads as a bug. Reported 2026-09-07 on
      Irgnir, who was genuinely not enrolled - noticed following at gd 153.45,
      stopped following at gd 163.10 which reset her waiting period, and never
      noticed again in the 44 game days since. The refusal was correct. The
      explanation was not, and there was nothing in it to act on.

      FOUR STATES, NOT ONE, and this is the same mistake this project keeps
      making: a gate that cannot tell "no" from "not yet" tells the player
      neither. Enrolled-and-scoreable; enrolled but invisible to Romantasy until
      a reload; following and serving the waiting period; not noticed at all.
      Every one of them has a different thing for the player to do, and three of
      the four are just waiting.

      ONE HELPER FOR BOTH KEYS so the wording cannot drift apart, and the tenure
      numbers are read live from the same config the gate itself reads - a
      hardcoded "2 hours" here would quietly lie the moment anyone tuned it."
          .return String
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ours Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local ::temp4 String
            .local firstSeen Float
            .local ::temp5 Float
            .local wait Float
            .local left Float
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 6365
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 6366
            return "Point at someone first." 
            jmp _label0
            ; line 6368
          _label0:
            callstatic sNRom_Bridge IsEnrolled ::temp1 akActor ;1 variable args
            jmpf ::temp1 _label1
            ; line 6369
            return "" 
            jmp _label1
            ; line 6371
          _label1:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Enrolled" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            assign ours ::temp1 
            ; line 6372
            jmpf ours _label2
            ; line 6378
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 ::temp4 " was enrolled this session - reload before their standing can be scored." 
            return ::temp4 
            jmp _label2
            ; line 6380
          _label2:
            callstatic sNRom_Bridge IsFollowing ::temp1 akActor ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label3
            ; line 6381
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 ::temp4 " is not enrolled - only followers are enrolled, once they have followed you a while." 
            return ::temp4 
            jmp _label3
            ; line 6383
          _label3:
            cast ::temp2 akActor 
            callstatic storageUtil GetFloatValue ::temp5 ::temp2 "SNRom_FirstSeenFollowing" 0.0 ;3 variable args
            assign firstSeen ::temp5 
            ; line 6384
            callstatic sNRom_Bridge CFG ::temp4 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp5 ::temp4 "enrollmentDelayHours" 2.0 ;3 variable args
            assign wait ::temp5 
            ; line 6385
            cmp_lte ::temp1 firstSeen 0.0 
            jmpf ::temp1 _label4
            ; line 6386
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 ::temp4 " has not been noticed following yet - they are picked up on the next check." 
            return ::temp4 
            jmp _label4
            ; line 6388
          _label4:
            callstatic utility GetCurrentGameTime ::temp5 ;0 variable args
            fsub ::temp5 ::temp5 firstSeen 
            fmul ::temp5 ::temp5 24.0 
            fsub ::temp5 wait ::temp5 
            assign left ::temp5 
            ; line 6389
            cmp_lt ::temp1 left 0.0 
            jmpf ::temp1 _label5
            ; line 6393
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 ::temp4 " is waiting to be enrolled - the next check will settle it." 
            return ::temp4 
            jmp _label5
            ; line 6395
          _label5:
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 ::temp4 " is still new - enrolled once they have been with you " 
            cast ::temp6 wait 
            strcat ::temp6 ::temp4 ::temp6 
            strcat ::temp6 ::temp6 " game hours, about " 
            cast ::temp4 left 
            strcat ::temp4 ::temp6 ::temp4 
            strcat ::temp4 ::temp4 " to go." 
            return ::temp4 
          .endCode
        .endFunction ;EnrollmentPendingReason
        .function Say
           ; function type 0
          .userFlags 0 ;none
          .docString "One player-facing line. Distinct from Diag's optional notification, which
      mirrors the LOG and is off by default: these are answers to a keypress and
      must appear whatever the log settings say."
          .return None
          .paramTable
            .param asText String
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 6402
            strcat ::temp0 "[Relationships] " asText 
            callstatic debug Notification ::nonevar ::temp0 ;1 variable args
          .endCode
        .endFunction ;Say
        .function ReseedUnderCrosshair
           ; function type 0
          .userFlags 0 ;none
          .docString "Point at anyone enrolled, press the key, and their standing is read again from
      the record as it now stands.

      WHY THIS EXISTS. Fixing the material is the advice this mod gives - correct
      the bio, write the missing diary entry, apply a block - and none of it
      moves a standing that was already written down. The re-read was reachable
      only by hand-assembling a POST to SkyrimNet's web API with the actor's
      FormID, which is not a repair a player will perform.

      EVERY REFUSAL BELOW SAYS WHY. A hotkey that declines in silence is
      indistinguishable from one that is not bound, and the player has no log
      open. The asynchronous answer arrives in OnSeedAssessed, which announces
      all four of its outcomes when the request came from here."
          .return None
          .paramTable
            .param akTarget actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local who actor
            .local ::temp1 actor
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 6419
            not ::temp0 _ready 
            jmpf ::temp0 _label0
            ; line 6420
            callmethod Say self ::nonevar "Not ready - Relationships has not started this session." ;1 variable args
            ; line 6421
            return None 
            jmp _label0
            ; line 6423
          _label0:
            assign who akTarget 
            ; line 6424
            cast ::temp1 None 
            cmp_eq ::temp0 who ::temp1 
            jmpf ::temp0 _label1
            ; line 6425
            callmethod Say self ::nonevar "Point at someone first." ;1 variable args
            ; line 6426
            return None 
            jmp _label1
            ; line 6428
          _label1:
            callstatic game GetPlayer ::temp1 ;0 variable args
            cmp_eq ::temp0 who ::temp1 
            jmpf ::temp0 _label2
            ; line 6429
            callmethod Say self ::nonevar "That is you." ;1 variable args
            ; line 6430
            return None 
            jmp _label2
            ; line 6432
          _label2:
            callmethod IsDead who ::temp0 ;0 variable args
            jmpf ::temp0 _label3
            ; line 6433
            callmethod GetDisplayName who ::temp2 ;0 variable args
            strcat ::temp2 ::temp2 " is dead." 
            callmethod Say self ::nonevar ::temp2 ;1 variable args
            ; line 6434
            return None 
            jmp _label3
            ; line 6436
          _label3:
            callstatic sNRom_Bridge IsEnrolled ::temp0 who ;1 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label4
            ; line 6446
            callmethod EnrollmentPendingReason self ::temp2 who ;1 variable args
            callmethod Say self ::nonevar ::temp2 ;1 variable args
            ; line 6447
            return None 
            jmp _label4
            ; line 6449
          _label4:
            callmethod SeedReadInFlight self ::temp0 ;0 variable args
            jmpf ::temp0 _label5
            ; line 6450
            strcat ::temp2 "Still reading the record for " _seedName 
            strcat ::temp2 ::temp2 " - try again in a moment." 
            callmethod Say self ::nonevar ::temp2 ;1 variable args
            ; line 6451
            return None 
            jmp _label5
            ; line 6457
          _label5:
            assign _seedByHand True 
            ; line 6458
            callmethod GetDisplayName who ::temp2 ;0 variable args
            strcat ::temp2 "Re-reading the record for " ::temp2 
            strcat ::temp2 ::temp2 "..." 
            callmethod Say self ::nonevar ::temp2 ;1 variable args
            ; line 6459
            callmethod ReseedActor self ::nonevar who ;1 variable args
          .endCode
        .endFunction ;ReseedUnderCrosshair
        .function ReauthorUnderCrosshair
           ; function type 0
          .userFlags 0 ;none
          .docString "Point at someone, press the OTHER key, and their character is written
      again from scratch - orientation, intimacy, ardor, exclusivity, WHY, LIMIT
      and ADDRESS.

      WHY THIS EXISTS, and it is a different need from the re-read. The re-read
      fixes a STANDING that was scored before the material improved. This fixes
      a CHARACTER that was authored before the material improved - and no amount
      of re-reading touches it, because points and personality are written by
      two different calls. Measured 2026-09-05: 45 of 136 authored characters
      hold exclusivity 100, nearly all of them from before the axis was
      anchored to named bands, and every one of them will keep refusing to share
      the player forever unless something rewrites the number. Reaching that
      repair meant hand-assembling a POST with a hex FormID, which is not
      something a player does.

      ROUTES TO ReauthorCharacter, NOT ReauthorDisposition, and that choice is
      load-bearing rather than incidental. ReauthorDisposition ADDS preferences
      on every run and they cannot be removed across a reload, so a player who
      pressed this a few times on the same companion would inflate what she
      cares about until nothing about her stood out - the tool would degrade
      exactly the characters it was reached for. Character-only re-authoring is
      idempotent in the way that matters: press it twice and you get one
      character, not one character and six new hobbies.

      NO IsFollowing GUARD, unlike ReseedUnderCrosshair, and the difference is
      real rather than an oversight. The re-read must refuse a dismissed
      follower because Romantasy scores active followers only and will reject
      the points write. Authoring writes this mod's own fields plus preference
      factions, and enrollment - not travelling - is what those need. A roster of
      companions waiting at home is the population this exists for, so refusing
      them would refuse the actual case.

      IT LOGS WHAT IT IS ABOUT TO OVERWRITE. There is no undo, and a mistaken
      press with the crosshair a few degrees off would otherwise be silent and
      permanent - the wrong companion quietly rerolled, discovered weeks later
      as "she has not felt like herself". The old values in the log will not
      restore her, but they name what was lost and they can be typed back in by
      hand, which is the difference between a bad afternoon and a lost
      character."
          .return None
          .paramTable
            .param akTarget actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local who actor
            .local ::temp1 actor
            .local ::temp2 String
            .local ::temp3 form
            .local ::temp4 Int
            .local ::temp5 form
            .local minTier Int
            .local orient String
            .local ::temp6 String
            .local ::temp7 Int
            .local oldWhy String
          .endLocalTable
          .code
            ; line 6502
            not ::temp0 _ready 
            jmpf ::temp0 _label0
            ; line 6503
            callmethod Say self ::nonevar "Not ready - Relationships has not started this session." ;1 variable args
            ; line 6504
            return None 
            jmp _label0
            ; line 6506
          _label0:
            assign who akTarget 
            ; line 6507
            cast ::temp1 None 
            cmp_eq ::temp0 who ::temp1 
            jmpf ::temp0 _label1
            ; line 6508
            callmethod Say self ::nonevar "Point at someone first." ;1 variable args
            ; line 6509
            return None 
            jmp _label1
            ; line 6511
          _label1:
            callstatic game GetPlayer ::temp1 ;0 variable args
            cmp_eq ::temp0 who ::temp1 
            jmpf ::temp0 _label2
            ; line 6512
            callmethod Say self ::nonevar "That is you." ;1 variable args
            ; line 6513
            return None 
            jmp _label2
            ; line 6515
          _label2:
            callmethod IsDead who ::temp0 ;0 variable args
            jmpf ::temp0 _label3
            ; line 6516
            callmethod GetDisplayName who ::temp2 ;0 variable args
            strcat ::temp2 ::temp2 " is dead." 
            callmethod Say self ::nonevar ::temp2 ;1 variable args
            ; line 6517
            return None 
            jmp _label3
            ; line 6525
          _label3:
            callstatic sNRom_Bridge IsEnrolled ::temp0 who ;1 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label4
            cast ::temp3 who 
            callstatic storageUtil GetIntValue ::temp4 ::temp3 "SNRom_Enrolled" 0 ;3 variable args
            cmp_eq ::temp0 ::temp4 1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label5
            ; line 6526
            callmethod EnrollmentPendingReason self ::temp2 who ;1 variable args
            callmethod Say self ::nonevar ::temp2 ;1 variable args
            ; line 6527
            return None 
            jmp _label5
            ; line 6534
          _label5:
            cmp_eq ::temp0 _pendingActor who 
            jmpf ::temp0 _label6
            ; line 6535
            callmethod GetDisplayName who ::temp2 ;0 variable args
            strcat ::temp2 "Already re-authoring " ::temp2 
            strcat ::temp2 ::temp2 " - the answer takes a few seconds." 
            callmethod Say self ::nonevar ::temp2 ;1 variable args
            ; line 6536
            return None 
            jmp _label6
            ; line 6538
          _label6:
            cast ::temp3 None 
            cast ::temp5 who 
            callstatic storageUtil FormListFind ::temp4 ::temp3 "SNRom_AuthorQueue" ::temp5 ;3 variable args
            comp_gte ::temp0 ::temp4 0 
            jmpf ::temp0 _label7
            ; line 6539
            callmethod GetDisplayName who ::temp2 ;0 variable args
            strcat ::temp2 ::temp2 " is already queued for re-authoring." 
            callmethod Say self ::nonevar ::temp2 ;1 variable args
            ; line 6540
            return None 
            jmp _label7
            ; line 6549
          _label7:
            callstatic sNRom_Bridge CFG ::temp2 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp0 ::temp2 "enrollmentLlmPreferences" True ;3 variable args
            cmp_eq ::temp0 ::temp0 False 
            jmpf ::temp0 _label8
            ; line 6550
            callmethod Say self ::nonevar "LLM-authored personalities are switched off in the settings - there is nothing to re-author with." ;1 variable args
            ; line 6551
            return None 
            jmp _label8
            ; line 6555
          _label8:
            cast ::temp5 who 
            callstatic storageUtil GetIntValue ::temp4 ::temp5 "SNRom_PhysMinTier" 4 ;3 variable args
            assign minTier ::temp4 
            ; line 6556
            callstatic sNRom_Decorators OrientationWord ::temp2 who ;1 variable args
            assign orient ::temp2 
            ; line 6557
            cmp_eq ::temp0 orient "" 
            jmpf ::temp0 _label9
            ; line 6558
            assign orient "unknown" 
            jmp _label9
            ; line 6563
          _label9:
            callstatic sNRom_Bridge LOG_WARN ::temp4 ;0 variable args
            callmethod GetDisplayName who ::temp2 ;0 variable args
            strcat ::temp2 "Re-authoring " ::temp2 
            strcat ::temp2 ::temp2 " BY HOTKEY. Overwriting" 
            strcat ::temp2 ::temp2 " orientation=" 
            ; line 6564
            strcat ::temp2 ::temp2 orient 
            strcat ::temp2 ::temp2 ", intimacy=" 
            ; line 6565
            callstatic sNRom_Decorators IntimacyWordFromTier ::temp6 minTier ;1 variable args
            strcat ::temp6 ::temp2 ::temp6 
            strcat ::temp6 ::temp6 ", ardor=" 
            ; line 6566
            cast ::temp5 who 
            callstatic storageUtil GetIntValue ::temp7 ::temp5 "SNRom_Ardor" 2 ;3 variable args
            cast ::temp2 ::temp7 
            strcat ::temp2 ::temp6 ::temp2 
            strcat ::temp2 ::temp2 " (" 
            ; line 6567
            cast ::temp5 who 
            callstatic storageUtil GetIntValue ::temp7 ::temp5 "SNRom_Ardor" 2 ;3 variable args
            callstatic sNRom_Decorators ArdorWord ::temp6 ::temp7 ;1 variable args
            strcat ::temp6 ::temp2 ::temp6 
            strcat ::temp6 ::temp6 ")" 
            strcat ::temp6 ::temp6 ", exclusivity=" 
            ; line 6568
            cast ::temp5 who 
            callstatic storageUtil GetIntValue ::temp7 ::temp5 "SNRom_Exclusivity" 50 ;3 variable args
            cast ::temp2 ::temp7 
            strcat ::temp2 ::temp6 ::temp2 
            strcat ::temp2 ::temp2 ". There is no undo." 
            callmethod Diag self ::nonevar ::temp4 ::temp2 True ;3 variable args
            ; line 6573
            callstatic sNRom_Bridge StoreGetText ::temp2 who "Why" "" 0 ;4 variable args
            assign oldWhy ::temp2 
            ; line 6574
            cmp_eq ::temp0 oldWhy "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label10
            ; line 6575
            callstatic sNRom_Bridge LOG_WARN ::temp4 ;0 variable args
            callmethod GetDisplayName who ::temp2 ;0 variable args
            strcat ::temp2 "Discarded WHY for " ::temp2 
            strcat ::temp2 ::temp2 ": " 
            strcat ::temp2 ::temp2 oldWhy 
            callmethod Diag self ::nonevar ::temp4 ::temp2 True ;3 variable args
            jmp _label10
            ; line 6581
          _label10:
            cmp_eq ::temp0 oldWhy "" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label11
            cast ::temp5 who 
            callstatic storageUtil GetIntValue ::temp4 ::temp5 "SNRom_DispositionAuthored" 0 ;3 variable args
            cmp_eq ::temp0 ::temp4 1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label11:
            jmpf ::temp0 _label12
            ; line 6582
            callmethod GetDisplayName who ::temp2 ;0 variable args
            strcat ::temp2 "Authoring " ::temp2 
            strcat ::temp2 ::temp2 " for the first time..." 
            callmethod Say self ::nonevar ::temp2 ;1 variable args
            jmp _label13
            ; line 6584
          _label12:
            callmethod GetDisplayName who ::temp2 ;0 variable args
            strcat ::temp2 "Re-authoring " ::temp2 
            strcat ::temp2 ::temp2 " - old character discarded..." 
            callmethod Say self ::nonevar ::temp2 ;1 variable args
            ; line 6591
          _label13:
            cast ::temp5 who 
            callstatic storageUtil SetIntValue ::temp4 ::temp5 "SNRom_AuthorByHand" 1 ;3 variable args
            ; line 6592
            callmethod ReauthorCharacter self ::nonevar who ;1 variable args
          .endCode
        .endFunction ;ReauthorUnderCrosshair
        .function AnnounceAuthored
           ; function type 0
          .userFlags 0 ;none
          .docString "Tells the player how a HAND-REQUESTED authoring turned out, once, and only
      if they asked for it.

      WITHOUT THIS THE KEY IS HALF A TOOL. The press says "re-authoring..." and
      then nothing ever says whether it landed - so the only way to find out is
      to open the log, which is the exact thing the hotkey exists to avoid. The
      re-read has had this from the start via _seedByHand; this is the same
      contract for the other key.

      CHECK-AND-CLEAR IN ONE PLACE, because OnDispositionAuthored has six early
      exits and anything that has to be remembered at each of them will be
      missed when a seventh is added. There are only two places a request can
      actually settle - ApplyCharacter when a character was written, and
      ApplyArchetype which every failure path already funnels through - so the
      announcement lives at those two and nowhere else.

      Clearing on ANY settle, success or fallback, is what stops a stale marker
      announcing an automatic authoring weeks later as though the player had
      just asked for it."
          .return None
          .paramTable
            .param akActor actor
            .param asText String
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 6615
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_AuthorByHand" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 6616
            return None 
            jmp _label1
            ; line 6618
          _label1:
            cast ::temp2 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp2 "SNRom_AuthorByHand" ;2 variable args
            ; line 6619
            callmethod Say self ::nonevar asText ;1 variable args
          .endCode
        .endFunction ;AnnounceAuthored
        .function SeedNextActor
           ; function type 0
          .userFlags 0 ;none
          .docString "One SETTLED seed per tick, walking the roster in order.

      Two things here are load-bearing and both are the same bug this project
      already fixed once in AssessNextTalk:

      1. Anyone enrolled, following or not, from 2.0: the follower test was
         Romantasy's rule, and the points are ours (design 3.2). The seed reads
         the record, which needs nobody nearby. The cheap seeded test first:
         IsDead waits for a frame.

      2. Do not stop on a rejection, only on a settled seed. Stopping on the
         first ATTEMPT means one permanently un-seedable actor at the front of
         the roster blocks everyone behind them forever, and the roster is in
         permanent first-enrollment order so "the front" never changes. A
         rejection costs a GetPoints and a native call that returns False, so
         walking past it is cheap; starving on it is not.

      No most-overdue ordering, unlike the assessors - this is once-per-NPC
      rather than recurring, so once the roster drains it costs a walk and
      nothing else.

      Backfills the EXISTING roster by design. Every follower enrolled before
      seeding existed is sitting at a tier their history does not match, which
      is the whole problem this was written to fix. The floor semantic in
      SeedActor is what makes that safe on an established save: it can only
      ever raise someone to what their history justifies, never lower anyone,
      and never pay someone who has already earned more."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 String
            .local n Int
            .local ::temp2 form
            .local ::temp3 Int
            .local i Int
            .local a actor
            .local ::temp4 actor
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 6650
            not ::temp0 _ready 
            jmpf ::temp0 _label0
            ; line 6651
            return None 
            jmp _label0
            ; line 6653
          _label0:
            callstatic sNRom_Bridge CFG ::temp1 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp0 ::temp1 "seedEnabled" True ;3 variable args
            cmp_eq ::temp0 ::temp0 False 
            jmpf ::temp0 _label1
            ; line 6654
            return None 
            jmp _label1
            ; line 6656
          _label1:
            cast ::temp2 None 
            callstatic storageUtil FormListCount ::temp3 ::temp2 "SNRom_Roster" ;2 variable args
            assign n ::temp3 
            ; line 6657
            assign i 0 
            ; line 6658
          _label6:
            cmp_lt ::temp0 i n 
            jmpf ::temp0 _label2
            ; line 6659
            cast ::temp2 None 
            callstatic storageUtil FormListGet ::temp2 ::temp2 "SNRom_Roster" i ;3 variable args
            cast ::temp4 ::temp2 
            assign a ::temp4 
            ; line 6660
            cast ::temp4 None 
            cmp_eq ::temp0 a ::temp4 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            cast ::temp2 a 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Seeded" 0 ;3 variable args
            cmp_eq ::temp0 ::temp3 1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label3:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label4
            callmethod IsDead a ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label5
            ; line 6672
            callmethod AssessSeed self ::nonevar a ;1 variable args
            ; line 6673
            return None 
            jmp _label5
            ; line 6675
          _label5:
            iadd ::temp3 i 1 
            assign i ::temp3 
            jmp _label6
          _label2
          .endCode
        .endFunction ;SeedNextActor
        .function AssessIntervalHours
           ; function type 0
          .userFlags 0 ;none
          .docString "How long until the next ASSESSMENT tick. Housekeeping keeps its own,
      slower schedule - see OnUpdateGameTime.

      THE QUEUE WAS THE BOTTLENECK, NOT THE COOLDOWN. Each AssessNext* serves
      exactly one actor and holds a single pending slot until the answer lands,
      so a fixed two-hour tick meant a party of seven waited fourteen game hours
      between assessments each - while talkCooldownHours, the setting that is
      supposed to govern the rate, is 3.0 and never came close to binding.

      Dividing the window by the party size hands the cooldown back its job: the
      roster drains in roughly one window and each follower is then limited by
      their own cooldown, which is what it was written for.

      FLOORED AT HALF AN HOUR. Every tick is an LLM call for anyone eligible, and
      at a default timescale half a game hour is about ninety real seconds - fast
      enough that a large party still drains, slow enough not to hammer a local
      model. A party of eight drains in four hours, just past the cooldown, which
      is the right side of it.

      Count comes from the sweep rather than a fresh walk, so it can be one
      housekeeping period stale. That is fine: dismissing someone should not
      change the tick rate the instant it happens."
          .return Float
          .paramTable
          .endParamTable
          .localTable
            .local followers Int
            .local ::temp0 form
            .local ::temp1 Int
            .local ::temp2 Bool
            .local every Float
            .local ::temp3 Float
          .endLocalTable
          .code
            ; line 6711
            cast ::temp0 None 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_FollowerCount" 1 ;3 variable args
            assign followers ::temp1 
            ; line 6712
            cmp_lt ::temp2 followers 1 
            jmpf ::temp2 _label0
            ; line 6713
            assign followers 1 
            jmp _label0
            ; line 6715
          _label0:
            cast ::temp3 followers 
            fdiv ::temp3 2.0 ::temp3 
            assign every ::temp3 
            ; line 6716
            cmp_lt ::temp2 every 0.5 
            jmpf ::temp2 _label1
            ; line 6717
            assign every 0.5 
            jmp _label2
            ; line 6718
          _label1:
            cmp_gt ::temp2 every 2.0 
            jmpf ::temp2 _label2
            ; line 6719
            assign every 2.0 
            jmp _label2
            ; line 6721
          _label2:
            return every 
          .endCode
        .endFunction ;AssessIntervalHours
        .function SparkIntervalHours
           ; function type 0
          .userFlags 0 ;none
          .docString "THE HOUSEKEEPING WINDOW, despite the name - kept because it is referenced
      in comments and in the 0.9.2 crash notes, and renaming it would orphan
      those. It bounds the sweep, the attraction refresh and seeding.

      It is also the numerator AssessIntervalHours divides by party size, so the
      roster is meant to drain in about one of these."
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 6731
            return 2.0 
          .endCode
        .endFunction ;SparkIntervalHours
        .function OnUpdateGameTime
           ; function type 0
          .userFlags 0 ;none
          .docString "TWO CADENCES, ONE TIMER. Papyrus gives a script one game-time update, so
      the FAST one drives the event and the slow work is gated on elapsed time
      inside it rather than getting a registration of its own.

      WHY NOT SIMPLY TICK EVERYTHING FASTER. SweepFollowers calls
      MiscUtil.ScanCellNPCs, which is the call a VR user crashed inside on a
      heavily patched cell in 0.9.2. Running that scan four times as often to
      make conversation scoring keep up would be paying for the fix with the
      bug. RefreshNextAttraction and SeedNextActor are both once-per-actor work
      with nothing to gain from hurrying.

      The three assessors and the ask queue run every tick. Each assessor serves
      one actor, holds a single pending slot until the answer lands, and obeys
      its own per-actor cooldown - so a faster tick drains the roster without
      assessing anyone more often than their cooldown already allows. That was
      the whole problem: at a fixed two hours a party of seven waited fourteen
      game hours apiece while talkCooldownHours sat at 3.0 and never bound."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 actor[]
            .local now Float
            .local ::temp1 Float
            .local sinceKeep Float
            .local ::temp2 form
            .local ::temp3 Bool
          .endLocalTable
          .code
            ; line 6766
            callmethod CheckContentLoaded self ::nonevar True ;1 variable args
            ; line 6767
            callmethod Observers self ::temp0 ;0 variable args
            assign _observers ::temp0 
            ; line 6768
            callstatic utility GetCurrentGameTime ::temp1 ;0 variable args
            assign now ::temp1 
            ; line 6769
            cast ::temp2 None 
            callstatic storageUtil GetFloatValue ::temp1 ::temp2 "SNRom_LastHousekeep" 0.0 ;3 variable args
            fsub ::temp1 now ::temp1 
            assign sinceKeep ::temp1 
            ; line 6772
            callstatic sNRom_Bridge SparkIntervalHours ::temp1 ;0 variable args
            fdiv ::temp1 ::temp1 24.0 
            comp_gte ::temp3 sinceKeep ::temp1 
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label0
            cmp_lt ::temp3 sinceKeep 0.0 
            assign ::temp3 ::temp3 
          _label0:
            jmpf ::temp3 _label1
            ; line 6773
            cast ::temp2 None 
            callstatic storageUtil SetFloatValue ::temp1 ::temp2 "SNRom_LastHousekeep" now ;3 variable args
            ; line 6777
            callmethod SweepFollowers self ::nonevar ;0 variable args
            ; line 6779
            callmethod CheckPendingEnrollments self ::nonevar ;0 variable args
            ; line 6782
            callmethod RefreshNextAttraction self ::nonevar ;0 variable args
            ; line 6786
            callmethod SeedNextActor self ::nonevar ;0 variable args
            ; line 6792
            callmethod ReconcileMarriages self ::nonevar ;0 variable args
            ; line 6797
            callmethod SweepProposalGates self ::nonevar ;0 variable args
            ; line 6800
            callmethod SweepLoverCeiling self ::nonevar ;0 variable args
            ; line 6804
            callmethod MigrateLegacyExclusivity self ::nonevar ;0 variable args
            ; line 6805
            callmethod RefreshPartnerCount self ::nonevar ;0 variable args
            jmp _label1
            ; line 6813
          _label1:
            callmethod PumpAskQueue self ::nonevar ;0 variable args
            ; line 6814
            callmethod AssessNextTalk self ::nonevar ;0 variable args
            ; line 6815
            callmethod AssessNextSpark self ::nonevar ;0 variable args
            ; line 6821
            callmethod AssessNextDrift self ::nonevar ;0 variable args
            ; line 6825
            callstatic sNRom_Bridge AssessIntervalHours ::temp1 ;0 variable args
            callmethod RegisterForSingleUpdateGameTime self ::nonevar ::temp1 ;1 variable args
          .endCode
        .endFunction ;OnUpdateGameTime
        .function AssessNextTalk
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 String
            .local ::temp2 actor
            .local ::nonevar None
            .local ::temp3 Int
            .local ::temp4 Float
            .local ::temp5 String
            .local now Float
            .local cooldown Float
            .local n Int
            .local i Int
            .local pick actor
            .local pickSince Float
            .local bestWait Float
            .local a actor
            .local last Float
            .local ::temp6 form
          .endLocalTable
          .code
            ; line 6846
            not ::temp0 _ready 
            jmpf ::temp0 _label0
            ; line 6847
            return None 
            jmp _label0
            ; line 6849
          _label0:
            callstatic sNRom_Bridge CFG ::temp1 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp0 ::temp1 "talkEnabled" True ;3 variable args
            cmp_eq ::temp0 ::temp0 False 
            jmpf ::temp0 _label1
            ; line 6850
            return None 
            jmp _label1
            ; line 6852
          _label1:
            cast ::temp2 None 
            cmp_eq ::temp0 _talkActor ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 6853
            callstatic sNRom_Bridge SlotStale ::temp0 _talkPendingAt ;1 variable args
            jmpf ::temp0 _label3
            ; line 6854
            callstatic sNRom_Bridge LOG_WARN ::temp3 ;0 variable args
            strcat ::temp1 "Talk slot held by " _talkName 
            strcat ::temp1 ::temp1 " with no callback for " 
            ; line 6855
            callstatic sNRom_Bridge PendingTimeoutSeconds ::temp4 ;0 variable args
            cast ::temp5 ::temp4 
            strcat ::temp5 ::temp1 ::temp5 
            strcat ::temp5 ::temp5 "s - releasing. Two causes look identical from here: the prompt failed to " 
            ; line 6856
            strcat ::temp5 ::temp5 "render, or the LLM call timed out. SkyrimNet.log tells them apart - a " 
            ; line 6857
            strcat ::temp5 ::temp5 "template error names the file, while Request timeout, Transferred a " 
            ; line 6858
            strcat ::temp5 ::temp5 "partial file or a JSON parse error means the backend, not us." 
            callmethod Diag self ::nonevar ::temp3 ::temp5 False ;3 variable args
            ; line 6860
            cast ::temp2 None 
            assign _talkActor ::temp2 
            jmp _label4
            ; line 6862
          _label3:
            return None 
          _label4:
            jmp _label2
            ; line 6893
          _label2:
            callstatic utility GetCurrentGameTime ::temp4 ;0 variable args
            assign now ::temp4 
            ; line 6894
            callstatic sNRom_Bridge CFG ::temp5 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp4 ::temp5 "talkCooldownHours" 3.0 ;3 variable args
            fdiv ::temp4 ::temp4 24.0 
            assign cooldown ::temp4 
            ; line 6895
            assign n 0 
            ; line 6896
            cast ::temp0 _observers 
            jmpf ::temp0 _label5
            ; line 6897
            array_length ::temp3 _observers 
            assign n ::temp3 
            jmp _label5
            ; line 6899
          _label5:
            assign i 0 
            ; line 6900
            cast ::temp2 None 
            assign pick ::temp2 
            ; line 6901
            assign pickSince 0.0 
            ; line 6902
            assign bestWait -1.0 
            ; line 6903
          _label10:
            cmp_lt ::temp0 i n 
            jmpf ::temp0 _label6
            ; line 6904
            array_getlement ::temp2 _observers i 
            assign a ::temp2 
            ; line 6905
            cast ::temp2 None 
            cmp_eq ::temp0 a ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label7
            callmethod TalkCandidate self ::temp0 a now cooldown ;3 variable args
            assign ::temp0 ::temp0 
          _label7:
            jmpf ::temp0 _label8
            ; line 6906
            cast ::temp6 a 
            callstatic storageUtil GetFloatValue ::temp4 ::temp6 "SNRom_LastTalkCheck" 0.0 ;3 variable args
            assign last ::temp4 
            ; line 6907
            fsub ::temp4 now last 
            cmp_gt ::temp0 ::temp4 bestWait 
            jmpf ::temp0 _label9
            ; line 6908
            fsub ::temp4 now last 
            assign bestWait ::temp4 
            ; line 6909
            assign pick a 
            ; line 6910
            assign pickSince last 
            jmp _label9
          _label9:
            jmp _label8
            ; line 6913
          _label8:
            iadd ::temp3 i 1 
            assign i ::temp3 
            jmp _label10
            ; line 6916
          _label6:
            cast ::temp2 None 
            cmp_eq ::temp0 pick ::temp2 
            jmpf ::temp0 _label11
            ; line 6917
            return None 
            jmp _label11
            ; line 6924
          _label11:
            cast ::temp6 pick 
            callstatic storageUtil SetFloatValue ::temp4 ::temp6 "SNRom_LastTalkCheck" now ;3 variable args
            ; line 6925
            callstatic sNRom_Bridge LOG_DEBUG ::temp3 ;0 variable args
            callmethod GetDisplayName pick ::temp5 ;0 variable args
            strcat ::temp5 "Talk queue: picked " ::temp5 
            strcat ::temp5 ::temp5 " after " 
            ; line 6926
            fmul ::temp4 bestWait 24.0 
            cast ::temp1 ::temp4 
            strcat ::temp1 ::temp5 ::temp1 
            strcat ::temp1 ::temp1 " game hours waiting" 
            callmethod Diag self ::nonevar ::temp3 ::temp1 False ;3 variable args
            ; line 6927
            callmethod AssessTalk self ::nonevar pick pickSince ;2 variable args
          .endCode
        .endFunction ;AssessNextTalk
        .function TalkCandidate
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
            .param akActor actor
            .param afNow Float
            .param afCooldown Float
          .endParamTable
          .localTable
            .local ::temp0 form
            .local ::temp1 Float
            .local ::temp2 Bool
          .endLocalTable
          .code
            ; line 6934
            cast ::temp0 akActor 
            callstatic storageUtil GetFloatValue ::temp1 ::temp0 "SNRom_LastTalkCheck" 0.0 ;3 variable args
            fsub ::temp1 afNow ::temp1 
            comp_gte ::temp2 ::temp1 afCooldown 
            return ::temp2 
          .endCode
        .endFunction ;TalkCandidate
        .function AssessTalk
           ; function type 0
          .userFlags 0 ;none
          .docString "afSince is the game time of the PREVIOUS assessment, in days, or 0.0 for
      "look at everything". Defaulted so the manual API dispatch
      (execute-quest-script-function -> AssessTalk) still takes one argument and
      still gets the full window, which is what you want when testing.

      NOTE FOR MANUAL DISPATCH: this takes TWO arguments from the web API.
      Papyrus default parameter values do NOT apply through
      execute-quest-script-function - the argument count must match the
      signature exactly or the call dies with "Argument count mismatch",
      visible only in SkyrimNet.log while the HTTP response still says 200.
      Pass `["0x0001B136", 0.0]` for a full-history window. An earlier comment
      here claimed the default made one argument sufficient; that was wrong.

      TWO forms go to the prompt, because the two sources measure time
      differently and neither conversion is safe to guess:

        npc_since_sec   - ABSOLUTE game-seconds, for filtering events. Events
                          carry ev.gameTime in seconds; the stock
                          components/event_history.prompt compares it against
                          604800 for "over a week ago", which pins the unit.
                          This assumes ev.gameTime shares an epoch with
                          GetCurrentGameTime(). PLAUSIBLE, NOT VERIFIED - the
                          prompt therefore falls back to the unfiltered window
                          if this filter empties a non-empty list.

        npc_since_hours - RELATIVE hours elapsed, for filtering diary entries.
                          Diary entries expose age_hours, which is relative, so
                          comparing two relative numbers needs no epoch
                          assumption at all. This is the safer of the two and
                          is why the diary filter is not built on entry_date.

      Both are 0.0 when there is no previous assessment, which every consumer
      reads as "no watermark, show everything"."
          .return None
          .paramTable
            .param akActor actor
            .param afSince Float
          .endParamTable
          .localTable
            .local sinceSec Float
            .local sinceHours Float
            .local ::temp0 Bool
            .local ::temp1 Float
            .local ::temp2 String
            .local ctx String
            .local ::temp3 Int
            .local ::temp4 String
            .local ::temp5 form
            .local rc Int
            .local ::temp6 quest
            .local ::nonevar None
            .local ::temp7 actor
          .endLocalTable
          .code
            ; line 6971
            assign sinceSec 0.0 
            ; line 6972
            assign sinceHours 0.0 
            ; line 6973
            cmp_gt ::temp0 afSince 0.0 
            jmpf ::temp0 _label0
            ; line 6974
            fmul ::temp1 afSince 86400.0 
            assign sinceSec ::temp1 
            ; line 6975
            callstatic utility GetCurrentGameTime ::temp1 ;0 variable args
            fsub ::temp1 ::temp1 afSince 
            fmul ::temp1 ::temp1 24.0 
            assign sinceHours ::temp1 
            ; line 6976
            cmp_lt ::temp0 sinceHours 0.0 
            jmpf ::temp0 _label1
            ; line 6977
            assign sinceHours 0.0 
            jmp _label1
          _label1:
            jmp _label0
            ; line 6980
          _label0:
            assign _talkActor akActor 
            ; line 6981
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            assign _talkName ::temp2 
            ; line 6982
            callstatic utility GetCurrentRealTime ::temp1 ;0 variable args
            assign _talkPendingAt ::temp1 
            ; line 6987
            strcat ::temp2 "{\"npc_name\":\"" _talkName 
            strcat ::temp2 ::temp2 "\"" 
            strcat ::temp2 ::temp2 ",\"npc_formid\":" 
            ; line 6988
            callmethod GetFormID akActor ::temp3 ;0 variable args
            cast ::temp4 ::temp3 
            strcat ::temp4 ::temp2 ::temp4 
            strcat ::temp4 ::temp4 ",\"npc_ardor\":\"" 
            ; line 6989
            cast ::temp5 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp5 "SNRom_Ardor" 2 ;3 variable args
            callstatic sNRom_Decorators ArdorWord ::temp2 ::temp3 ;1 variable args
            strcat ::temp2 ::temp4 ::temp2 
            strcat ::temp2 ::temp2 "\"" 
            strcat ::temp2 ::temp2 ",\"npc_why\":\"" 
            ; line 6990
            callstatic sNRom_Bridge StoreGetText ::temp4 akActor "Why" "" 0 ;4 variable args
            callstatic sNRom_Decorators JsonEscape ::temp4 ::temp4 ;1 variable args
            strcat ::temp4 ::temp2 ::temp4 
            strcat ::temp4 ::temp4 "\"" 
            strcat ::temp4 ::temp4 ",\"npc_since_sec\":" 
            ; line 6991
            cast ::temp2 sinceSec 
            strcat ::temp2 ::temp4 ::temp2 
            strcat ::temp2 ::temp2 ",\"npc_since_hours\":" 
            ; line 6992
            cast ::temp4 sinceHours 
            strcat ::temp4 ::temp2 ::temp4 
            callstatic sNRom_Bridge MarasContext ::temp2 akActor ;1 variable args
            strcat ::temp2 ::temp4 ::temp2 
            strcat ::temp2 ::temp2 "}" 
            assign ctx ::temp2 
            ; line 6993
            callstatic sNRom_Bridge VariantName ::temp2 ;0 variable args
            ; line 6994
            cast ::temp6 self 
            callstatic skyrimNetApi SendCustomPromptToLLM ::temp3 "snrom_talk_assess" ::temp2 ctx ::temp6 "SNRom_Bridge" "OnTalkAssessed" ;6 variable args
            assign rc ::temp3 
            ; line 6999
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp2 "Talk assessment sent for " _talkName 
            strcat ::temp2 ::temp2 " (rc=" 
            cast ::temp4 rc 
            strcat ::temp4 ::temp2 ::temp4 
            strcat ::temp4 ::temp4 ")" 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
            ; line 7000
            cmp_eq ::temp0 rc 1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 7001
            cast ::temp7 None 
            assign _talkActor ::temp7 
            jmp _label2
          _label2
          .endCode
        .endFunction ;AssessTalk
        .function OnTalkAssessed
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param asResponse String
            .param aiSuccess Int
          .endParamTable
          .localTable
            .local who actor
            .local asked String
            .local ::temp0 actor
            .local ::temp1 Bool
            .local echoed String
            .local ::temp2 String
            .local ::nonevar None
            .local ::temp3 Int
            .local weightWord String
            .local points Int
            .local what String
            .local newAddress String
            .local oldAddress String
            .local ::temp4 String
            .local landKind String
            .local held Int
            .local ::temp5 Int
          .endLocalTable
          .code
            ; line 7006
            assign who _talkActor 
            ; line 7007
            assign asked _talkName 
            ; line 7008
            cast ::temp0 None 
            assign _talkActor ::temp0 
            ; line 7010
            cast ::temp0 None 
            cmp_eq ::temp1 who ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 aiSuccess 1 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 7011
            return None 
            jmp _label1
            ; line 7013
          _label1:
            callstatic sNRom_Decorators FieldValue ::temp2 asResponse "NAME:" ;2 variable args
            callstatic sNRom_Decorators NameCore ::temp2 ::temp2 ;1 variable args
            assign echoed ::temp2 
            ; line 7014
            cmp_eq ::temp1 echoed "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            callstatic sNRom_Decorators NameCore ::temp2 asked ;1 variable args
            cmp_eq ::temp1 echoed ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 7015
            callstatic sNRom_Bridge LOG_ERROR ::temp3 ;0 variable args
            strcat ::temp2 "Talk echo mismatch: asked about '" asked 
            strcat ::temp2 ::temp2 "', answered as '" 
            strcat ::temp2 ::temp2 echoed 
            strcat ::temp2 ::temp2 "'. Discarded." 
            callmethod Diag self ::nonevar ::temp3 ::temp2 False ;3 variable args
            ; line 7016
            return None 
            jmp _label3
            ; line 7019
          _label3:
            callstatic sNRom_Decorators FieldValue ::temp2 asResponse "WEIGHT:" ;2 variable args
            assign weightWord ::temp2 
            ; line 7020
            callstatic sNRom_Decorators WeightToPoints ::temp3 weightWord ;1 variable args
            assign points ::temp3 
            ; line 7021
            cmp_eq ::temp1 points 0 
            jmpf ::temp1 _label4
            ; line 7025
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp2 "Talk verdict for " asked 
            strcat ::temp2 ::temp2 ": '" 
            strcat ::temp2 ::temp2 weightWord 
            strcat ::temp2 ::temp2 "' - no award" 
            callmethod Diag self ::nonevar ::temp3 ::temp2 False ;3 variable args
            ; line 7026
            return None 
            jmp _label4
            ; line 7031
          _label4:
            callstatic sNRom_Decorators FieldValue ::temp2 asResponse "WHAT:" ;2 variable args
            assign what ::temp2 
            ; line 7032
            cmp_eq ::temp1 what "" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label5
            callstatic sNRom_Decorators Upper ::temp2 what ;1 variable args
            cmp_eq ::temp1 ::temp2 "NONE" 
            assign ::temp1 ::temp1 
          _label5:
            jmpf ::temp1 _label6
            ; line 7033
            callstatic sNRom_Bridge LOG_WARN ::temp3 ;0 variable args
            strcat ::temp2 "Talk award for " asked 
            strcat ::temp2 ::temp2 " named no exchange - discarded" 
            callmethod Diag self ::nonevar ::temp3 ::temp2 False ;3 variable args
            ; line 7034
            return None 
            jmp _label6
            ; line 7049
          _label6:
            callstatic sNRom_Decorators FieldValue ::temp2 asResponse "ADDRESS:" ;2 variable args
            assign newAddress ::temp2 
            ; line 7050
            cmp_eq ::temp1 newAddress "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label7
            callstatic sNRom_Decorators Upper ::temp2 newAddress ;1 variable args
            cmp_eq ::temp1 ::temp2 "NONE" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label7:
            jmpf ::temp1 _label8
            ; line 7051
            callstatic sNRom_Bridge StoreGetText ::temp2 who "Address" "" 0 ;4 variable args
            assign oldAddress ::temp2 
            ; line 7052
            cmp_eq ::temp1 oldAddress newAddress 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label9
            ; line 7053
            callstatic sNRom_Bridge StoreSetText ::nonevar who "Address" newAddress ;3 variable args
            ; line 7055
            jmpf _dashText _label10
            ; line 7056
            callmethod PushBondText self ::nonevar who ;1 variable args
            jmp _label10
            ; line 7058
          _label10:
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp2 asked " now calls " 
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod GetDisplayName ::temp0 ::temp4 ;0 variable args
            strcat ::temp4 ::temp2 ::temp4 
            strcat ::temp4 ::temp4 ": " 
            ; line 7059
            strcat ::temp4 ::temp4 newAddress 
            strcat ::temp2 " (was: " oldAddress 
            strcat ::temp2 ::temp2 ")" 
            strcat ::temp2 ::temp4 ::temp2 
            callmethod Diag self ::nonevar ::temp3 ::temp2 False ;3 variable args
            jmp _label9
          _label9:
            jmp _label8
            ; line 7074
          _label8:
            cmp_gt ::temp1 points 0 
            jmpf ::temp1 _label11
            ; line 7075
            callstatic sNRom_Decorators FieldValue ::temp2 asResponse "DIRECTION:" ;2 variable args
            callstatic sNRom_Decorators Upper ::temp2 ::temp2 ;1 variable args
            cmp_eq ::temp1 ::temp2 "AWAY" 
            jmpf ::temp1 _label12
            ; line 7076
            ineg ::temp3 points 
            assign points ::temp3 
            jmp _label12
          _label12:
            jmp _label11
            ; line 7102
          _label11:
            callstatic sNRom_Decorators FieldValue ::temp2 asResponse "LANDMARK_KIND:" ;2 variable args
            callstatic sNRom_Decorators Trim ::temp2 ::temp2 ;1 variable args
            callstatic sNRom_Decorators Upper ::temp2 ::temp2 ;1 variable args
            assign landKind ::temp2 
            ; line 7103
            callstatic sNRom_Decorators Upper ::temp2 weightWord ;1 variable args
            cmp_eq ::temp1 ::temp2 "LANDMARK" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label13
            cmp_eq ::temp1 landKind "MARRIAGE" 
            assign ::temp1 ::temp1 
          _label13:
            jmpf ::temp1 _label14
            ; line 7104
            callstatic sNRom_Bridge PointsOf ::temp3 who ;1 variable args
            assign held ::temp3 
            ; line 7105
            callstatic sNRom_Bridge LOVER_MIN ::temp3 ;0 variable args
            cmp_lt ::temp1 held ::temp3 
            jmpf ::temp1 _label15
            ; line 7106
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp2 "Talk landmark for " asked 
            strcat ::temp2 ::temp2 " was a commitment to " 
            strcat ::temp2 ::temp2 "marry, and they hold " 
            ; line 7107
            cast ::temp4 held 
            strcat ::temp4 ::temp2 ::temp4 
            strcat ::temp4 ::temp4 " pts - below Lover at " 
            callstatic sNRom_Bridge LOVER_MIN ::temp5 ;0 variable args
            cast ::temp2 ::temp5 
            strcat ::temp2 ::temp4 ::temp2 
            strcat ::temp2 ::temp2 ". Downgraded to MAJOR: the moment counts, but marrying is not a step " 
            ; line 7108
            strcat ::temp2 ::temp2 "you take from here. It pays in full once they are actually lovers." 
            callmethod Diag self ::nonevar ::temp3 ::temp2 False ;3 variable args
            ; line 7110
            assign weightWord "MAJOR" 
            ; line 7111
            callstatic sNRom_Decorators WeightToPoints ::temp3 "MAJOR" ;1 variable args
            assign points ::temp3 
            jmp _label15
          _label15:
            jmp _label14
            ; line 7115
          _label14:
            callmethod ApplyTalkAward self ::nonevar who points weightWord what ;4 variable args
          .endCode
        .endFunction ;OnTalkAssessed
        .function ApplyTalkAward
           ; function type 0
          .userFlags 0 ;none
          .docString "Pacing lives HERE, not in the prompt. The model judges what happened;
      Papyrus decides how fast a relationship is allowed to move."
          .return None
          .paramTable
            .param akActor actor
            .param aiPoints Int
            .param asWeight String
            .param asWhat String
          .endParamTable
          .localTable
            .local points Int
            .local w String
            .local ::temp0 String
            .local rupture Bool
            .local ::temp1 Bool
            .local landmark Bool
            .local defining Bool
            .local now Float
            .local ::temp2 Float
            .local commitState Int
            .local ::temp3 Int
            .local ::temp4 form
            .local ::nonevar None
            .local ::temp5 String
            .local lmCool Float
            .local awarded Int
            .local cap Int
            .local day Int
            .local spent Int
            .local room Int
            .local used Int
            .local result Int
            .local applied Bool
            .local refund Int
            .local ::temp6 form
            .local paceNote String
            .local ::temp7 actor
          .endLocalTable
          .code
            ; line 7121
            assign points aiPoints 
            ; line 7122
            callstatic sNRom_Decorators Trim ::temp0 asWeight ;1 variable args
            callstatic sNRom_Decorators Upper ::temp0 ::temp0 ;1 variable args
            assign w ::temp0 
            ; line 7133
            cmp_eq ::temp1 w "RUPTURE" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 w "LANDMARK" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            cmp_lt ::temp1 points 0 
            assign ::temp1 ::temp1 
          _label1:
            assign ::temp1 ::temp1 
          _label0:
            assign rupture ::temp1 
            ; line 7134
            cmp_eq ::temp1 w "LANDMARK" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            not ::temp1 rupture 
            assign ::temp1 ::temp1 
          _label2:
            assign landmark ::temp1 
            ; line 7135
            assign ::temp1 landmark 
            jmpt ::temp1 _label3
            assign ::temp1 rupture 
          _label3:
            assign defining ::temp1 
            ; line 7136
            callstatic utility GetCurrentGameTime ::temp2 ;0 variable args
            assign now ::temp2 
            ; line 7161
            callstatic sNRom_Bridge CommitmentState ::temp3 akActor ;1 variable args
            assign commitState ::temp3 
            ; line 7162
            assign ::temp1 landmark 
            jmpf ::temp1 _label4
            cmp_gt ::temp1 commitState 0 
            assign ::temp1 ::temp1 
          _label4:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label5
            ; line 7163
            cast ::temp4 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp4 "SNRom_LandmarkState" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 commitState 
            assign ::temp1 ::temp1 
          _label5:
            jmpf ::temp1 _label6
            ; line 7164
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp0 ;0 variable args
            strcat ::temp0 "Landmark for " ::temp0 
            strcat ::temp0 ::temp0 " downgraded - already at commitment state " 
            ; line 7165
            cast ::temp5 commitState 
            strcat ::temp5 ::temp0 ::temp5 
            strcat ::temp5 ::temp5 " and a landmark was already paid for reaching it. Nothing new was decided." 
            callmethod Diag self ::nonevar ::temp3 ::temp5 False ;3 variable args
            ; line 7167
            callstatic sNRom_Decorators WeightToPoints ::temp3 "MAJOR" ;1 variable args
            assign points ::temp3 
            ; line 7168
            assign landmark False 
            ; line 7169
            assign defining False 
            jmp _label6
            ; line 7172
          _label6:
            jmpf defining _label7
            ; line 7176
            callstatic sNRom_Bridge CFG ::temp5 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp2 ::temp5 "talkLandmarkDays" 3.0 ;3 variable args
            assign lmCool ::temp2 
            ; line 7177
            cast ::temp4 akActor 
            callstatic storageUtil GetFloatValue ::temp2 ::temp4 "SNRom_LastLandmark" -999.0 ;3 variable args
            fsub ::temp2 now ::temp2 
            cmp_lt ::temp1 ::temp2 lmCool 
            jmpf ::temp1 _label8
            ; line 7178
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp5 "Defining moment (" w 
            strcat ::temp5 ::temp5 ") for " 
            callmethod GetDisplayName akActor ::temp0 ;0 variable args
            strcat ::temp0 ::temp5 ::temp0 
            strcat ::temp0 ::temp0 " downgraded - one was recorded within the last " 
            ; line 7179
            cast ::temp5 lmCool 
            strcat ::temp5 ::temp0 ::temp5 
            strcat ::temp5 ::temp5 " days" 
            callmethod Diag self ::nonevar ::temp3 ::temp5 False ;3 variable args
            ; line 7184
            jmpf rupture _label9
            ; line 7185
            callstatic sNRom_Decorators WeightToPoints ::temp3 "MAJOR" ;1 variable args
            ineg ::temp3 ::temp3 
            assign points ::temp3 
            jmp _label10
            ; line 7187
          _label9:
            callstatic sNRom_Decorators WeightToPoints ::temp3 "MAJOR" ;1 variable args
            assign points ::temp3 
            ; line 7189
          _label10:
            assign landmark False 
            ; line 7190
            assign rupture False 
            ; line 7191
            assign defining False 
            jmp _label11
            ; line 7193
          _label8:
            cast ::temp4 akActor 
            callstatic storageUtil SetFloatValue ::temp2 ::temp4 "SNRom_LastLandmark" now ;3 variable args
            ; line 7194
            assign ::temp1 landmark 
            jmpf ::temp1 _label12
            cmp_gt ::temp1 commitState 0 
            assign ::temp1 ::temp1 
          _label12:
            jmpf ::temp1 _label11
            ; line 7195
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "SNRom_LandmarkState" commitState ;3 variable args
            jmp _label11
          _label11:
            jmp _label7
            ; line 7217
          _label7:
            callstatic sNRom_Bridge ScaleAward ::temp3 points ;1 variable args
            assign awarded ::temp3 
            ; line 7222
            not ::temp1 defining 
            jmpf ::temp1 _label13
            ; line 7228
            callstatic sNRom_Bridge CFG ::temp5 ;0 variable args
            callstatic skyrimNetApi GetConfigInt ::temp3 ::temp5 "talkDailyCap" 200 ;3 variable args
            callstatic sNRom_Bridge ScaleAward ::temp3 ::temp3 ;1 variable args
            assign cap ::temp3 
            ; line 7229
            cast ::temp3 now 
            assign day ::temp3 
            ; line 7230
            cast ::temp4 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp4 "SNRom_TalkDay" -1 ;3 variable args
            cmp_eq ::temp1 ::temp3 day 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label14
            ; line 7231
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "SNRom_TalkDay" day ;3 variable args
            ; line 7232
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "SNRom_TalkToday" 0 ;3 variable args
            jmp _label14
            ; line 7234
          _label14:
            cast ::temp4 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp4 "SNRom_TalkToday" 0 ;3 variable args
            assign spent ::temp3 
            ; line 7235
            isub ::temp3 cap spent 
            assign room ::temp3 
            ; line 7236
            cmp_lte ::temp1 room 0 
            jmpf ::temp1 _label15
            ; line 7237
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp5 ;0 variable args
            strcat ::temp5 "Daily conversation budget spent for " ::temp5 
            strcat ::temp5 ::temp5 " - award dropped" 
            callmethod Diag self ::nonevar ::temp3 ::temp5 False ;3 variable args
            ; line 7238
            return None 
            jmp _label15
            ; line 7240
          _label15:
            cmp_gt ::temp1 awarded room 
            jmpf ::temp1 _label16
            ; line 7241
            assign awarded room 
            jmp _label17
            ; line 7242
          _label16:
            ineg ::temp3 room 
            cmp_lt ::temp1 awarded ::temp3 
            jmpf ::temp1 _label17
            ; line 7243
            ineg ::temp3 room 
            assign awarded ::temp3 
            jmp _label17
            ; line 7245
          _label17:
            assign used awarded 
            ; line 7246
            cmp_lt ::temp1 used 0 
            jmpf ::temp1 _label18
            ; line 7247
            ineg ::temp3 used 
            assign used ::temp3 
            jmp _label18
            ; line 7249
          _label18:
            cast ::temp4 akActor 
            iadd ::temp3 spent used 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "SNRom_TalkToday" ::temp3 ;3 variable args
            jmp _label13
            ; line 7268
          _label13:
            callmethod ApplyDepth self ::temp3 akActor awarded asWhat True "talk" ;5 variable args
            assign result ::temp3 
            ; line 7269
            callstatic sNRom_Bridge DEPTH_WITHHELD ::temp3 ;0 variable args
            cmp_eq ::temp1 result ::temp3 
            jmpf ::temp1 _label19
            ; line 7270
            callmethod Ledger self ::nonevar akActor "withheld" "" awarded 1 asWhat ;6 variable args
            ; line 7271
            return None 
            jmp _label19
            ; line 7273
          _label19:
            cmp_gt ::temp1 result 0 
            assign applied ::temp1 
            ; line 7274
            not ::temp1 applied 
            jmpf ::temp1 _label20
            ; line 7279
            jmpf defining _label21
            ; line 7280
            cast ::temp4 akActor 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp4 "SNRom_LastLandmark" ;2 variable args
            ; line 7283
            cast ::temp4 akActor 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp4 "SNRom_LandmarkState" ;2 variable args
            jmp _label22
            ; line 7285
          _label21:
            assign refund awarded 
            ; line 7286
            cmp_lt ::temp1 refund 0 
            jmpf ::temp1 _label23
            ; line 7287
            ineg ::temp3 refund 
            assign refund ::temp3 
            jmp _label23
            ; line 7289
          _label23:
            cast ::temp4 akActor 
            ; line 7290
            cast ::temp6 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp6 "SNRom_TalkToday" 0 ;3 variable args
            isub ::temp3 ::temp3 refund 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "SNRom_TalkToday" ::temp3 ;3 variable args
            ; line 7292
          _label22:
            callstatic sNRom_Bridge LOG_ERROR ::temp3 ;0 variable args
            cast ::temp5 awarded 
            strcat ::temp5 "Could not write " ::temp5 
            strcat ::temp5 ::temp5 " pts for " 
            ; line 7293
            callmethod GetDisplayName akActor ::temp0 ;0 variable args
            strcat ::temp0 ::temp5 ::temp0 
            strcat ::temp0 ::temp0 " - their points are not ours yet and could not be " 
            strcat ::temp0 ::temp0 "brought over from Romantasy (see the line above). Award LOST, no ledger row written." 
            callmethod Diag self ::nonevar ::temp3 ::temp0 False ;3 variable args
            ; line 7295
            return None 
            jmp _label20
            ; line 7297
          _label20:
            callmethod Ledger self ::nonevar akActor "talk" "" awarded 1 asWhat ;6 variable args
            ; line 7300
            assign paceNote "" 
            ; line 7301
            cmp_eq ::temp1 awarded points 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label24
            ; line 7302
            cast ::temp0 awarded 
            strcat ::temp0 " -> " ::temp0 
            strcat ::temp0 ::temp0 " applied (Bond Pace: " 
            ; line 7303
            callstatic sNRom_Bridge CFG ::temp5 ;0 variable args
            callstatic skyrimNetApi GetConfigString ::temp5 ::temp5 "bondPace" "Normal" ;3 variable args
            strcat ::temp5 ::temp0 ::temp5 
            strcat ::temp5 ::temp5 ")" 
            assign paceNote ::temp5 
            jmp _label24
            ; line 7305
          _label24:
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName akActor ::temp5 ;0 variable args
            strcat ::temp5 "Talk award for " ::temp5 
            strcat ::temp5 ::temp5 ": " 
            strcat ::temp5 ::temp5 asWeight 
            ; line 7306
            strcat ::temp5 ::temp5 " " 
            cast ::temp0 points 
            strcat ::temp0 ::temp5 ::temp0 
            strcat ::temp0 ::temp0 " pts" 
            strcat ::temp0 ::temp0 paceNote 
            strcat ::temp0 ::temp0 " - " 
            strcat ::temp0 ::temp0 asWhat 
            callmethod Diag self ::nonevar ::temp3 ::temp0 False ;3 variable args
            ; line 7310
            jmpf landmark _label25
            ; line 7312
            callmethod GetDisplayName akActor ::temp0 ;0 variable args
            strcat ::temp0 ::temp0 " and " 
            ; line 7313
            callstatic game GetPlayer ::temp7 ;0 variable args
            callmethod GetDisplayName ::temp7 ::temp5 ;0 variable args
            strcat ::temp5 ::temp0 ::temp5 
            strcat ::temp5 ::temp5 " have named what they are to each other. " 
            strcat ::temp5 ::temp5 asWhat 
            callmethod SendModEvent akActor ::nonevar "IEB_SNRomStatus" ::temp5 0.0 ;3 variable args
            jmp _label25
            ; line 7324
          _label25:
            jmpf rupture _label26
            ; line 7326
            callmethod GetDisplayName akActor ::temp5 ;0 variable args
            strcat ::temp5 ::temp5 " and " 
            ; line 7327
            callstatic game GetPlayer ::temp7 ;0 variable args
            callmethod GetDisplayName ::temp7 ::temp0 ;0 variable args
            strcat ::temp0 ::temp5 ::temp0 
            strcat ::temp0 ::temp0 " are no longer what they were to each other. " 
            strcat ::temp0 ::temp0 asWhat 
            callmethod SendModEvent akActor ::nonevar "IEB_SNRomStatus" ::temp0 0.0 ;3 variable args
            ; line 7328
            callmethod EndRomance self ::nonevar akActor asWhat ;2 variable args
            jmp _label26
          _label26
          .endCode
        .endFunction ;ApplyTalkAward
        .function AssessNextSpark
           ; function type 0
          .userFlags 0 ;none
          .docString "Picks ONE eligible character who can observe the player (Observers) and
      asks whether the bond has crossed. A non-follower can spark (design 3.2,
      question 9).

      One at a time, on a long interval, because this is a once-per-NPC
      transition that rewrites how she speaks for the rest of the game. There
      is no value in asking often and real cost in asking carelessly."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 String
            .local ::temp2 actor
            .local ::nonevar None
            .local ::temp3 Int
            .local ::temp4 Float
            .local ::temp5 String
            .local now Float
            .local cooldown Float
            .local n Int
            .local i Int
            .local pick actor
            .local bestWait Float
            .local a actor
            .local last Float
            .local ::temp6 form
          .endLocalTable
          .code
            ; line 7340
            not ::temp0 _ready 
            jmpf ::temp0 _label0
            ; line 7341
            return None 
            jmp _label0
            ; line 7343
          _label0:
            callstatic sNRom_Bridge CFG ::temp1 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp0 ::temp1 "sparkEnabled" True ;3 variable args
            cmp_eq ::temp0 ::temp0 False 
            jmpf ::temp0 _label1
            ; line 7344
            return None 
            jmp _label1
            ; line 7346
          _label1:
            cast ::temp2 None 
            cmp_eq ::temp0 _sparkActor ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 7347
            callstatic sNRom_Bridge SlotStale ::temp0 _sparkPendingAt ;1 variable args
            jmpf ::temp0 _label3
            ; line 7348
            callstatic sNRom_Bridge LOG_WARN ::temp3 ;0 variable args
            strcat ::temp1 "Spark slot held by " _sparkName 
            strcat ::temp1 ::temp1 " with no callback for " 
            ; line 7349
            callstatic sNRom_Bridge PendingTimeoutSeconds ::temp4 ;0 variable args
            cast ::temp5 ::temp4 
            strcat ::temp5 ::temp1 ::temp5 
            strcat ::temp5 ::temp5 "s - releasing. Two causes look identical from here: the prompt failed to " 
            ; line 7350
            strcat ::temp5 ::temp5 "render, or the LLM call timed out. SkyrimNet.log tells them apart - a " 
            ; line 7351
            strcat ::temp5 ::temp5 "template error names the file, while Request timeout, Transferred a " 
            ; line 7352
            strcat ::temp5 ::temp5 "partial file or a JSON parse error means the backend, not us." 
            callmethod Diag self ::nonevar ::temp3 ::temp5 False ;3 variable args
            ; line 7354
            cast ::temp2 None 
            assign _sparkActor ::temp2 
            jmp _label4
            ; line 7356
          _label3:
            return None 
          _label4:
            jmp _label2
            ; line 7364
          _label2:
            callstatic utility GetCurrentGameTime ::temp4 ;0 variable args
            assign now ::temp4 
            ; line 7365
            callstatic sNRom_Bridge CFG ::temp5 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp4 ::temp5 "sparkCooldownHours" 6.0 ;3 variable args
            fdiv ::temp4 ::temp4 24.0 
            assign cooldown ::temp4 
            ; line 7366
            assign n 0 
            ; line 7367
            cast ::temp0 _observers 
            jmpf ::temp0 _label5
            ; line 7368
            array_length ::temp3 _observers 
            assign n ::temp3 
            jmp _label5
            ; line 7370
          _label5:
            assign i 0 
            ; line 7371
            cast ::temp2 None 
            assign pick ::temp2 
            ; line 7372
            assign bestWait -1.0 
            ; line 7373
          _label10:
            cmp_lt ::temp0 i n 
            jmpf ::temp0 _label6
            ; line 7374
            array_getlement ::temp2 _observers i 
            assign a ::temp2 
            ; line 7375
            cast ::temp2 None 
            cmp_eq ::temp0 a ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label7
            callmethod SparkCandidate self ::temp0 a now cooldown ;3 variable args
            assign ::temp0 ::temp0 
          _label7:
            jmpf ::temp0 _label8
            ; line 7376
            cast ::temp6 a 
            callstatic storageUtil GetFloatValue ::temp4 ::temp6 "SNRom_LastSparkCheck" 0.0 ;3 variable args
            assign last ::temp4 
            ; line 7377
            fsub ::temp4 now last 
            cmp_gt ::temp0 ::temp4 bestWait 
            jmpf ::temp0 _label9
            ; line 7378
            fsub ::temp4 now last 
            assign bestWait ::temp4 
            ; line 7379
            assign pick a 
            jmp _label9
          _label9:
            jmp _label8
            ; line 7382
          _label8:
            iadd ::temp3 i 1 
            assign i ::temp3 
            jmp _label10
            ; line 7385
          _label6:
            cast ::temp2 None 
            cmp_eq ::temp0 pick ::temp2 
            jmpf ::temp0 _label11
            ; line 7386
            return None 
            jmp _label11
            ; line 7388
          _label11:
            cast ::temp6 pick 
            callstatic storageUtil SetFloatValue ::temp4 ::temp6 "SNRom_LastSparkCheck" now ;3 variable args
            ; line 7389
            callstatic sNRom_Bridge LOG_DEBUG ::temp3 ;0 variable args
            callmethod GetDisplayName pick ::temp5 ;0 variable args
            strcat ::temp5 "Spark queue: picked " ::temp5 
            strcat ::temp5 ::temp5 " after " 
            ; line 7390
            fmul ::temp4 bestWait 24.0 
            cast ::temp1 ::temp4 
            strcat ::temp1 ::temp5 ::temp1 
            strcat ::temp1 ::temp1 " game hours waiting" 
            callmethod Diag self ::nonevar ::temp3 ::temp1 False ;3 variable args
            ; line 7391
            callmethod AssessSpark self ::nonevar pick ;1 variable args
          .endCode
        .endFunction ;AssessNextSpark
        .function SparkCandidate
           ; function type 0
          .userFlags 0 ;none
          .docString "Cheap local filters BEFORE spending an LLM call."
          .return Bool
          .paramTable
            .param akActor actor
            .param afNow Float
            .param afCooldown Float
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 form
            .local ::temp2 Int
            .local enrolled Float
            .local ::temp3 Float
            .local ::temp4 String
            .local ::temp5 Float
          .endLocalTable
          .code
            ; line 7396
            callstatic sNRom_Decorators IsSparked ::temp0 akActor ;1 variable args
            jmpf ::temp0 _label0
            ; line 7397
            return False 
            jmp _label0
            ; line 7424
          _label0:
            cast ::temp1 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp1 "SNRom_SeedRomantic" 0 ;3 variable args
            cmp_eq ::temp0 ::temp2 1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label1
            ; line 7425
            cast ::temp1 akActor 
            callstatic storageUtil GetFloatValue ::temp3 ::temp1 "SNRom_EnrolledAt" 0.0 ;3 variable args
            assign enrolled ::temp3 
            ; line 7426
            cmp_lte ::temp0 enrolled 0.0 
            jmpf ::temp0 _label2
            ; line 7431
            cast ::temp1 akActor 
            callstatic storageUtil SetFloatValue ::temp3 ::temp1 "SNRom_EnrolledAt" afNow ;3 variable args
            ; line 7432
            return False 
            jmp _label2
            ; line 7434
          _label2:
            fsub ::temp3 afNow enrolled 
            callstatic sNRom_Bridge CFG ::temp4 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp5 ::temp4 "sparkMinDaysEnrolled" 2.0 ;3 variable args
            cmp_lt ::temp0 ::temp3 ::temp5 
            jmpf ::temp0 _label3
            ; line 7435
            return False 
            jmp _label3
          _label3:
            jmp _label1
            ; line 7438
          _label1:
            callmethod Is3DLoaded akActor ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label4
            ; line 7439
            return False 
            jmp _label4
            ; line 7445
          _label4:
            callstatic sNRom_Decorators RomanceOk ::temp0 akActor ;1 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label5
            ; line 7446
            return False 
            jmp _label5
            ; line 7448
          _label5:
            cast ::temp1 akActor 
            callstatic storageUtil GetFloatValue ::temp5 ::temp1 "SNRom_LastSparkCheck" 0.0 ;3 variable args
            fsub ::temp5 afNow ::temp5 
            comp_gte ::temp0 ::temp5 afCooldown 
            return ::temp0 
          .endCode
        .endFunction ;SparkCandidate
        .function AssessSpark
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Float
            .local ctx String
            .local ::temp2 Int
            .local ::temp3 String
            .local ::temp4 form
            .local rc Int
            .local ::temp5 quest
            .local ::nonevar None
            .local ::temp6 Bool
            .local ::temp7 actor
          .endLocalTable
          .code
            ; line 7452
            assign _sparkActor akActor 
            ; line 7453
            callmethod GetDisplayName akActor ::temp0 ;0 variable args
            assign _sparkName ::temp0 
            ; line 7454
            callstatic utility GetCurrentRealTime ::temp1 ;0 variable args
            assign _sparkPendingAt ::temp1 
            ; line 7461
            strcat ::temp0 "{\"npc_name\":\"" _sparkName 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 ::temp0 ",\"npc_formid\":" 
            ; line 7462
            callmethod GetFormID akActor ::temp2 ;0 variable args
            cast ::temp3 ::temp2 
            strcat ::temp3 ::temp0 ::temp3 
            strcat ::temp3 ::temp3 ",\"npc_ardor\":\"" 
            ; line 7463
            cast ::temp4 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp4 "SNRom_Ardor" 2 ;3 variable args
            callstatic sNRom_Decorators ArdorWord ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ::temp3 ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            callstatic sNRom_Bridge MarasContext ::temp3 akActor ;1 variable args
            strcat ::temp3 ::temp0 ::temp3 
            strcat ::temp3 ::temp3 "}" 
            assign ctx ::temp3 
            ; line 7464
            callstatic sNRom_Bridge VariantName ::temp3 ;0 variable args
            ; line 7465
            cast ::temp5 self 
            callstatic skyrimNetApi SendCustomPromptToLLM ::temp2 "snrom_spark_assess" ::temp3 ctx ::temp5 "SNRom_Bridge" "OnSparkAssessed" ;6 variable args
            assign rc ::temp2 
            ; line 7466
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            strcat ::temp3 "Spark assessment sent for " _sparkName 
            strcat ::temp3 ::temp3 " (rc=" 
            cast ::temp0 rc 
            strcat ::temp0 ::temp3 ::temp0 
            strcat ::temp0 ::temp0 ")" 
            callmethod Diag self ::nonevar ::temp2 ::temp0 False ;3 variable args
            ; line 7467
            cmp_eq ::temp6 rc 1 
            not ::temp6 ::temp6 
            jmpf ::temp6 _label0
            ; line 7468
            cast ::temp7 None 
            assign _sparkActor ::temp7 
            jmp _label0
          _label0
          .endCode
        .endFunction ;AssessSpark
        .function OnSparkAssessed
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param asResponse String
            .param aiSuccess Int
          .endParamTable
          .localTable
            .local who actor
            .local asked String
            .local ::temp0 actor
            .local ::temp1 Bool
            .local echoed String
            .local ::temp2 String
            .local ::nonevar None
            .local ::temp3 Int
            .local verdict String
            .local momentText String
            .local ::temp4 form
            .local held Int
            .local ::temp5 Int
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 7473
            assign who _sparkActor 
            ; line 7474
            assign asked _sparkName 
            ; line 7475
            cast ::temp0 None 
            assign _sparkActor ::temp0 
            ; line 7477
            cast ::temp0 None 
            cmp_eq ::temp1 who ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 aiSuccess 1 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 7478
            return None 
            jmp _label1
            ; line 7484
          _label1:
            callstatic sNRom_Decorators FieldValue ::temp2 asResponse "NAME:" ;2 variable args
            callstatic sNRom_Decorators NameCore ::temp2 ::temp2 ;1 variable args
            assign echoed ::temp2 
            ; line 7485
            cmp_eq ::temp1 echoed "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            callstatic sNRom_Decorators NameCore ::temp2 asked ;1 variable args
            cmp_eq ::temp1 echoed ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 7486
            callstatic sNRom_Bridge LOG_ERROR ::temp3 ;0 variable args
            strcat ::temp2 "Spark echo mismatch: asked about '" asked 
            strcat ::temp2 ::temp2 "', answered as '" 
            strcat ::temp2 ::temp2 echoed 
            strcat ::temp2 ::temp2 "'. Discarded." 
            callmethod Diag self ::nonevar ::temp3 ::temp2 False ;3 variable args
            ; line 7487
            return None 
            jmp _label3
            ; line 7490
          _label3:
            callstatic sNRom_Decorators FieldValue ::temp2 asResponse "CROSSED:" ;2 variable args
            callstatic sNRom_Decorators Upper ::temp2 ::temp2 ;1 variable args
            assign verdict ::temp2 
            ; line 7491
            callstatic sNRom_Decorators FieldValue ::temp2 asResponse "MOMENT:" ;2 variable args
            assign momentText ::temp2 
            ; line 7497
            cmp_eq ::temp1 verdict "YES" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label4
            ; line 7502
            cast ::temp4 who 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "SNRom_SparkDecided" 1 ;3 variable args
            ; line 7503
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp2 "No spark for " asked 
            strcat ::temp2 ::temp2 " (answered '" 
            strcat ::temp2 ::temp2 verdict 
            strcat ::temp2 ::temp2 "')" 
            callmethod Diag self ::nonevar ::temp3 ::temp2 False ;3 variable args
            ; line 7507
            cast ::temp4 who 
            callstatic storageUtil GetIntValue ::temp3 ::temp4 "SNRom_BankedPoints" 0 ;3 variable args
            assign held ::temp3 
            ; line 7508
            cmp_gt ::temp1 held 0 
            jmpf ::temp1 _label5
            ; line 7509
            cast ::temp4 who 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp4 "SNRom_AskPending" ;2 variable args
            ; line 7513
            callmethod ApplyDepth self ::temp3 who held "Held while the bond was still unnamed" True "released" ;5 variable args
            cmp_gt ::temp1 ::temp3 0 
            jmpf ::temp1 _label6
            ; line 7514
            cast ::temp4 who 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp4 "SNRom_BankedPoints" ;2 variable args
            ; line 7515
            callmethod Ledger self ::nonevar who "unbank" "" held 1 "Released - judged platonic" ;6 variable args
            ; line 7516
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            cast ::temp2 held 
            strcat ::temp2 "Released " ::temp2 
            strcat ::temp2 ::temp2 " pts held for " 
            strcat ::temp2 ::temp2 asked 
            strcat ::temp2 ::temp2 " while the spark was undecided - judged platonic, so depth is free. " 
            strcat ::temp2 ::temp2 "Now " 
            callstatic sNRom_Bridge PointsOf ::temp5 who ;1 variable args
            cast ::temp6 ::temp5 
            strcat ::temp6 ::temp2 ::temp6 
            strcat ::temp6 ::temp6 " pts." 
            callmethod Diag self ::nonevar ::temp3 ::temp6 False ;3 variable args
            jmp _label6
          _label6:
            jmp _label5
            ; line 7519
          _label5:
            return None 
            jmp _label4
            ; line 7521
          _label4:
            cmp_eq ::temp1 momentText "" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label7
            callstatic sNRom_Decorators Upper ::temp6 momentText ;1 variable args
            cmp_eq ::temp1 ::temp6 "NONE" 
            assign ::temp1 ::temp1 
          _label7:
            jmpf ::temp1 _label8
            ; line 7522
            callstatic sNRom_Bridge LOG_WARN ::temp3 ;0 variable args
            strcat ::temp6 "Spark claimed for " asked 
            strcat ::temp6 ::temp6 " with no moment named - discarded" 
            callmethod Diag self ::nonevar ::temp3 ::temp6 False ;3 variable args
            ; line 7523
            return None 
            jmp _label8
            ; line 7526
          _label8:
            callmethod ApplySpark self ::nonevar who momentText ;2 variable args
          .endCode
        .endFunction ;OnSparkAssessed
        .function SparkDecided
           ; function type 0
          .userFlags 0 ;none
          .docString "Has the spark assessor ever returned a USABLE verdict for this actor?

      THE THIRD STATE, and its absence is what let Jarl Laila Law-Giver cross
      into Lover unasked on 2026-09-05. Before this there were two observable
      conditions - sparked, and not sparked - and "judged platonic" was
      indistinguishable from "never looked at". HoldShortOfLover keys on the
      difference: a bond JUDGED platonic must climb freely to Spouse-tier depth,
      but one nobody has judged yet has to wait, because the question it would
      be asked has not been put.

      SET ONLY BY A CLEAN VERDICT. An echo mismatch, a truncated response, a
      YES with no moment named - none of those are answers, and marking them
      decided would silence the gate on exactly the actors whose reads are
      failing."
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
            ; line 7544
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 7545
            return False 
            jmp _label0
            ; line 7547
          _label0:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_SparkDecided" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            return ::temp1 
          .endCode
        .endFunction ;SparkDecided
        .function RequestSparkNow
           ; function type 0
          .userFlags 0 ;none
          .docString "Ask the spark assessor about someone OUT OF TURN, bypassing the tenure and
      cooldown gates that the tick applies.

      WHY THE TICK IS NOT ENOUGH. SparkEligible makes an actor wait
      sparkMinDaysEnrolled (2.0) unless SNRom_SeedRomantic is set, and that flag
      is only written for a romance the game RECORDS - a MARAS marriage or
      vanilla rank 4. Laila had neither: a fresh enrollment, a seed read of
      DEVOTED from a diary describing physical intimacy, and 1999 points inside
      0.2 game days. The talk assessor reached her long before the spark
      assessor was allowed to.

      This does NOT set the spark, and that distinction is the same one
      SeedRomanticFlag makes: the assessor still decides, it is simply asked
      sooner. Everything that protects the answer stays - the echo check, the
      required moment, RomanceOk, and the single pending slot.

      Cheap and self-limiting: it declines immediately if a read is already out,
      if they are already sparked, or if a verdict is already on record."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 Int
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 7569
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            not ::temp1 _ready 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 7570
            return None 
            jmp _label1
            ; line 7572
          _label1:
            callstatic sNRom_Decorators IsSparked ::temp1 akActor ;1 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label2
            callstatic sNRom_Bridge SparkDecided ::temp1 akActor ;1 variable args
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 7573
            return None 
            jmp _label3
            ; line 7575
          _label3:
            callmethod Is3DLoaded akActor ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label4
            ; line 7576
            return None 
            jmp _label4
            ; line 7578
          _label4:
            callstatic sNRom_Decorators RomanceOk ::temp1 akActor ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label5
            ; line 7579
            return None 
            jmp _label5
            ; line 7581
          _label5:
            cast ::temp0 None 
            cmp_eq ::temp1 _sparkActor ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label6
            ; line 7584
            callstatic sNRom_Bridge LOG_DEBUG ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 "Spark request for " ::temp3 
            strcat ::temp3 ::temp3 " deferred - a read for " 
            strcat ::temp3 ::temp3 _sparkName 
            strcat ::temp3 ::temp3 " is still out." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 7585
            return None 
            jmp _label6
            ; line 7587
          _label6:
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 "Asking the spark assessor about " ::temp3 
            strcat ::temp3 ::temp3 " out of turn - they are deep enough that the next award could cross Lover." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 7588
            callmethod AssessSpark self ::nonevar akActor ;1 variable args
          .endCode
        .endFunction ;RequestSparkNow
        .function ApplySpark
           ; function type 0
          .userFlags 0 ;none
          .docString "The crossing itself. Everything AutoEnroll deliberately withheld happens
      here, because now something actually has happened."
          .return None
          .paramTable
            .param akActor actor
            .param asMoment String
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 Int
            .local ::temp3 form
            .local ::temp4 Float
            .local ::temp5 String
            .local ::temp6 Int
            .local ::temp7 String
            .local thoughtRc Int
          .endLocalTable
          .code
            ; line 7595
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            callmethod IsChild akActor ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 7596
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod Diag self ::nonevar ::temp2 "ApplySpark refused: IsChild" False ;3 variable args
            ; line 7597
            return None 
            jmp _label1
            ; line 7599
          _label1:
            cast ::temp3 akActor 
            callstatic storageUtil SetIntValue ::temp2 ::temp3 "SNRom_Sparked" 1 ;3 variable args
            ; line 7600
            cast ::temp3 akActor 
            callstatic storageUtil SetIntValue ::temp2 ::temp3 "SNRom_SparkDecided" 1 ;3 variable args
            ; line 7601
            cast ::temp3 akActor 
            callstatic utility GetCurrentGameTime ::temp4 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp4 ::temp3 "SNRom_SparkedAt" ::temp4 ;3 variable args
            ; line 7606
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp3 "SNRom_BankedPoints" 0 ;3 variable args
            cmp_gt ::temp1 ::temp2 0 
            jmpf ::temp1 _label2
            ; line 7607
            cast ::temp3 akActor 
            callstatic storageUtil SetIntValue ::temp2 ::temp3 "SNRom_AskPending" 1 ;3 variable args
            ; line 7608
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp5 ;0 variable args
            strcat ::temp5 "Spark confirmed for " ::temp5 
            strcat ::temp5 ::temp5 " with " 
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp6 ::temp3 "SNRom_BankedPoints" 0 ;3 variable args
            cast ::temp7 ::temp6 
            strcat ::temp7 ::temp5 ::temp7 
            strcat ::temp7 ::temp7 " pts already held - raising the question now." 
            callmethod Diag self ::nonevar ::temp2 ::temp7 False ;3 variable args
            jmp _label2
            ; line 7611
          _label2:
            callstatic sNRom_Bridge ScaleAward ::temp2 25 ;1 variable args
            callmethod ApplyDepth self ::temp2 akActor ::temp2 asMoment False "spark" ;5 variable args
            ; line 7630
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod GetDisplayName ::temp0 ::temp7 ;0 variable args
            strcat ::temp7 "Something has shifted in how you regard " ::temp7 
            strcat ::temp7 ::temp7 ", though you have said nothing of it and do not know whether it is returned. What did it: " 
            strcat ::temp7 ::temp7 asMoment 
            callstatic skyrimNetApi GenerateNPCThought ::temp2 akActor ::temp7 ;2 variable args
            assign thoughtRc ::temp2 
            ; line 7631
            cmp_eq ::temp1 thoughtRc 0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label3
            ; line 7632
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp7 ;0 variable args
            strcat ::temp7 "Spark thought for " ::temp7 
            strcat ::temp7 ::temp7 " was not generated (rc=" 
            cast ::temp5 thoughtRc 
            strcat ::temp5 ::temp7 ::temp5 
            strcat ::temp5 ::temp5 ") - the spark stands; only the private thought is missing." 
            callmethod Diag self ::nonevar ::temp2 ::temp5 True ;3 variable args
            jmp _label3
            ; line 7636
          _label3:
            callmethod Ledger self ::nonevar akActor "spark" "" 25 1 asMoment ;6 variable args
            ; line 7637
            callmethod IEB_WriteRomTrack self ::nonevar akActor ;1 variable args
            ; line 7638
            callmethod IEB_QueueIntimacy self ::nonevar akActor ;1 variable args
            ; line 7639
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp5 ;0 variable args
            strcat ::temp5 "SPARK: " ::temp5 
            strcat ::temp5 ::temp5 " crossed into romance - " 
            strcat ::temp5 ::temp5 asMoment 
            callmethod Diag self ::nonevar ::temp2 ::temp5 False ;3 variable args
          .endCode
        .endFunction ;ApplySpark
        .function DRIFT_INTIMACY
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 7684
            return 0 
          .endCode
        .endFunction ;DRIFT_INTIMACY
        .function DRIFT_ARDOR
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 7688
            return 1 
          .endCode
        .endFunction ;DRIFT_ARDOR
        .function DRIFT_EXCLUSIVITY
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 7692
            return 2 
          .endCode
        .endFunction ;DRIFT_EXCLUSIVITY
        .function DriftFieldName
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
            .param aiField Int
          .endParamTable
          .localTable
            .local ::temp0 Int
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 7696
            callstatic sNRom_Bridge DRIFT_INTIMACY ::temp0 ;0 variable args
            cmp_eq ::temp1 aiField ::temp0 
            jmpf ::temp1 _label0
            ; line 7697
            return "INTIMACY" 
            jmp _label1
            ; line 7698
          _label0:
            callstatic sNRom_Bridge DRIFT_ARDOR ::temp0 ;0 variable args
            cmp_eq ::temp1 aiField ::temp0 
            jmpf ::temp1 _label1
            ; line 7699
            return "ARDOR" 
            jmp _label1
            ; line 7701
          _label1:
            return "EXCLUSIVITY" 
          .endCode
        .endFunction ;DriftFieldName
        .function DriftIsOn
           ; function type 0
          .userFlags 0 ;none
          .docString "Named so it cannot case-fold into its own config path. See the note on
      VoiceLeadSeconds for what that collision costs."
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 7707
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp1 ::temp0 "driftEnabled" True ;3 variable args
            return ::temp1 
          .endCode
        .endFunction ;DriftIsOn
        .function DriftDays
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Float
          .endLocalTable
          .code
            ; line 7711
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp1 ::temp0 "driftMinDays" 7.0 ;3 variable args
            return ::temp1 
          .endCode
        .endFunction ;DriftDays
        .function DriftEvents
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Int
          .endLocalTable
          .code
            ; line 7715
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigInt ::temp1 ::temp0 "driftMinEvents" 6 ;3 variable args
            return ::temp1 
          .endCode
        .endFunction ;DriftEvents
        .function DriftSpanDays
           ; function type 0
          .userFlags 0 ;none
          .docString "Game days that must separate the first and last scoring event before a
      review is worth asking for. 1.0 means "something happened on a later day
      than the first thing", which is the minimum that can constitute a pattern
      at all. Named so it cannot case-fold into its own config path."
          .return Float
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Float
          .endLocalTable
          .code
            ; line 7723
            callstatic sNRom_Bridge CFG ::temp0 ;0 variable args
            callstatic skyrimNetApi GetConfigFloat ::temp1 ::temp0 "driftMinSpanDays" 1.0 ;3 variable args
            return ::temp1 
          .endCode
        .endFunction ;DriftSpanDays
        .function AssessNextDrift
           ; function type 0
          .userFlags 0 ;none
          .docString "Picks ONE follower who has earned a review and asks about ONE field."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::nonevar None
            .local ::temp2 Int
            .local ::temp3 String
            .local ::temp4 Float
            .local ::temp5 String
            .local now Float
            .local n Int
            .local i Int
            .local pick actor
            .local bestWait Float
            .local a actor
            .local last Float
            .local ::temp6 form
          .endLocalTable
          .code
            ; line 7728
            not ::temp0 _ready 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            callstatic sNRom_Bridge DriftIsOn ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 7729
            return None 
            jmp _label1
            ; line 7731
          _label1:
            cast ::temp1 None 
            cmp_eq ::temp0 _driftActor ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 7732
            callstatic sNRom_Bridge SlotStale ::temp0 _driftPendingAt ;1 variable args
            jmpf ::temp0 _label3
            ; line 7733
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            strcat ::temp3 "Drift slot held by " _driftName 
            strcat ::temp3 ::temp3 " with no callback for " 
            ; line 7734
            callstatic sNRom_Bridge PendingTimeoutSeconds ::temp4 ;0 variable args
            cast ::temp5 ::temp4 
            strcat ::temp5 ::temp3 ::temp5 
            strcat ::temp5 ::temp5 "s - releasing. Two causes look identical from here: the prompt failed to " 
            ; line 7735
            strcat ::temp5 ::temp5 "render, or the LLM call timed out. SkyrimNet.log tells them apart - a " 
            ; line 7736
            strcat ::temp5 ::temp5 "template error names the file, while Request timeout, Transferred a " 
            ; line 7737
            strcat ::temp5 ::temp5 "partial file or a JSON parse error means the backend, not us." 
            callmethod Diag self ::nonevar ::temp2 ::temp5 False ;3 variable args
            ; line 7739
            cast ::temp1 None 
            assign _driftActor ::temp1 
            jmp _label4
            ; line 7741
          _label3:
            return None 
          _label4:
            jmp _label2
            ; line 7746
          _label2:
            callstatic utility GetCurrentGameTime ::temp4 ;0 variable args
            assign now ::temp4 
            ; line 7747
            assign n 0 
            ; line 7748
            cast ::temp0 _observers 
            jmpf ::temp0 _label5
            ; line 7749
            array_length ::temp2 _observers 
            assign n ::temp2 
            jmp _label5
            ; line 7751
          _label5:
            assign i 0 
            ; line 7752
            cast ::temp1 None 
            assign pick ::temp1 
            ; line 7753
            assign bestWait -1.0 
            ; line 7754
          _label10:
            cmp_lt ::temp0 i n 
            jmpf ::temp0 _label6
            ; line 7755
            array_getlement ::temp1 _observers i 
            assign a ::temp1 
            ; line 7756
            cast ::temp1 None 
            cmp_eq ::temp0 a ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label7
            callmethod DriftCandidate self ::temp0 a now ;2 variable args
            assign ::temp0 ::temp0 
          _label7:
            jmpf ::temp0 _label8
            ; line 7757
            cast ::temp6 a 
            callstatic storageUtil GetFloatValue ::temp4 ::temp6 "SNRom_LastDriftCheck" 0.0 ;3 variable args
            assign last ::temp4 
            ; line 7758
            fsub ::temp4 now last 
            cmp_gt ::temp0 ::temp4 bestWait 
            jmpf ::temp0 _label9
            ; line 7759
            fsub ::temp4 now last 
            assign bestWait ::temp4 
            ; line 7760
            assign pick a 
            jmp _label9
          _label9:
            jmp _label8
            ; line 7763
          _label8:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label10
            ; line 7766
          _label6:
            cast ::temp1 None 
            cmp_eq ::temp0 pick ::temp1 
            jmpf ::temp0 _label11
            ; line 7767
            return None 
            jmp _label11
            ; line 7769
          _label11:
            callmethod AssessDrift self ::nonevar pick ;1 variable args
          .endCode
        .endFunction ;AssessNextDrift
        .function DriftCandidate
           ; function type 0
          .userFlags 0 ;none
          .docString "Cheap local filters BEFORE spending an LLM call, and the two gates that
      make this a pattern rather than a reaction."
          .return Bool
          .paramTable
            .param akActor actor
            .param afNow Float
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 form
            .local ::temp2 Int
            .local ::temp3 Int
            .local firstDay Float
            .local ::temp4 Float
            .local lastDay Float
            .local ::temp5 Float
            .local last Float
          .endLocalTable
          .code
            ; line 7775
            callmethod IsChild akActor ::temp0 ;0 variable args
            jmpf ::temp0 _label0
            ; line 7776
            return False 
            jmp _label0
            ; line 7778
          _label0:
            cast ::temp1 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp1 "SNRom_DispositionAuthored" 0 ;3 variable args
            cmp_eq ::temp0 ::temp2 1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label1
            ; line 7779
            return False 
            jmp _label1
            ; line 7788
          _label1:
            cast ::temp1 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp1 "SNRom_EventsSinceDrift" 0 ;3 variable args
            callstatic sNRom_Bridge DriftEvents ::temp3 ;0 variable args
            cmp_lt ::temp0 ::temp2 ::temp3 
            jmpf ::temp0 _label2
            ; line 7789
            return False 
            jmp _label2
            ; line 7798
          _label2:
            cast ::temp1 akActor 
            callstatic storageUtil GetFloatValue ::temp4 ::temp1 "SNRom_DriftFirstDay" -1.0 ;3 variable args
            assign firstDay ::temp4 
            ; line 7799
            cast ::temp1 akActor 
            callstatic storageUtil GetFloatValue ::temp4 ::temp1 "SNRom_DriftLastDay" -1.0 ;3 variable args
            assign lastDay ::temp4 
            ; line 7800
            cmp_lt ::temp0 firstDay 0.0 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label3
            fsub ::temp4 lastDay firstDay 
            callstatic sNRom_Bridge DriftSpanDays ::temp5 ;0 variable args
            cmp_lt ::temp0 ::temp4 ::temp5 
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 7801
            return False 
            jmp _label4
            ; line 7809
          _label4:
            cast ::temp1 akActor 
            callstatic storageUtil GetFloatValue ::temp5 ::temp1 "SNRom_LastDriftCheck" 0.0 ;3 variable args
            assign last ::temp5 
            ; line 7810
            cmp_lte ::temp0 last 0.0 
            jmpf ::temp0 _label5
            ; line 7811
            cast ::temp1 akActor 
            callstatic storageUtil SetFloatValue ::temp5 ::temp1 "SNRom_LastDriftCheck" afNow ;3 variable args
            ; line 7812
            return False 
            jmp _label5
            ; line 7814
          _label5:
            fsub ::temp5 afNow last 
            callstatic sNRom_Bridge DriftDays ::temp4 ;0 variable args
            comp_gte ::temp0 ::temp5 ::temp4 
            return ::temp0 
          .endCode
        .endFunction ;DriftCandidate
        .function SetCharacterField
           ; function type 0
          .userFlags 0 ;none
          .docString "DEV TOOL. Writes ONE character field directly, with no LLM involved.

      Dispatch with functionName SetCharacterField and THREE arguments - a hex
      FormID, a field number and a value.

        0 intimacy    - value is a RANK: 0 casual, 1 romantic, 2 guarded, 3 never
        1 ardor       - 0 reserved .. 4 intense
        2 exclusivity - 0 to 100

      WHY IT EXISTS: to REPAIR, not to author. A drift verdict that should not
      have been applied leaves a character field wrong, and until this existed
      the only ways back were a full re-author - which rerolls every field and
      permanently adds preferences - or waiting for a future review to walk it
      back. Both are worse than writing the one number that is wrong.

      Intimacy takes a rank rather than a minimum tier because the stored form
      is not ordered: NEVER is -1, which sorts below CASUAL. IntimacyRank and
      MinTierFromRank exist for exactly this, and the bypass is derived here so
      it cannot drift out of step with the tier."
          .return None
          .paramTable
            .param akActor actor
            .param aiField Int
            .param aiValue Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local who String
            .local ::temp2 String
            .local ::temp3 Int
            .local rank Int
            .local tier Int
            .local word String
            .local ::temp4 form
            .local ::nonevar None
            .local ::temp5 String
            .local a Int
            .local e Int
          .endLocalTable
          .code
            ; line 7837
            not ::temp0 _ready 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 akActor ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 7838
            return None 
            jmp _label1
            ; line 7840
          _label1:
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            assign who ::temp2 
            ; line 7841
            callstatic sNRom_Bridge DRIFT_INTIMACY ::temp3 ;0 variable args
            cmp_eq ::temp0 aiField ::temp3 
            jmpf ::temp0 _label2
            ; line 7842
            assign rank aiValue 
            ; line 7843
            cmp_lt ::temp0 rank 0 
            jmpf ::temp0 _label3
            ; line 7844
            assign rank 0 
            jmp _label4
            ; line 7845
          _label3:
            cmp_gt ::temp0 rank 3 
            jmpf ::temp0 _label4
            ; line 7846
            assign rank 3 
            jmp _label4
            ; line 7848
          _label4:
            callstatic sNRom_Decorators MinTierFromRank ::temp3 rank ;1 variable args
            assign tier ::temp3 
            ; line 7849
            callstatic sNRom_Decorators IntimacyWordFromTier ::temp2 tier ;1 variable args
            assign word ::temp2 
            ; line 7850
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "SNRom_PhysMinTier" tier ;3 variable args
            ; line 7851
            cast ::temp4 akActor 
            ; line 7852
            callstatic sNRom_Decorators IntimacyToBypass ::temp3 word ;1 variable args
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "SNRom_PhysAttrBypass" ::temp3 ;3 variable args
            ; line 7853
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp2 "REPAIR: " who 
            strcat ::temp2 ::temp2 " INTIMACY set to " 
            strcat ::temp2 ::temp2 word 
            strcat ::temp2 ::temp2 " (minTier " 
            ; line 7854
            cast ::temp5 tier 
            strcat ::temp5 ::temp2 ::temp5 
            strcat ::temp5 ::temp5 ")" 
            callmethod Diag self ::nonevar ::temp3 ::temp5 False ;3 variable args
            ; line 7855
            callmethod IEB_LockChildIntimacy self ::temp0 akActor ;1 variable args
            jmp _label5
            ; line 7856
          _label2:
            callstatic sNRom_Bridge DRIFT_ARDOR ::temp3 ;0 variable args
            cmp_eq ::temp0 aiField ::temp3 
            jmpf ::temp0 _label6
            ; line 7857
            assign a aiValue 
            ; line 7858
            cmp_lt ::temp0 a 0 
            jmpf ::temp0 _label7
            ; line 7859
            assign a 0 
            jmp _label8
            ; line 7860
          _label7:
            cmp_gt ::temp0 a 4 
            jmpf ::temp0 _label8
            ; line 7861
            assign a 4 
            jmp _label8
            ; line 7863
          _label8:
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "SNRom_Ardor" a ;3 variable args
            ; line 7864
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp5 "REPAIR: " who 
            strcat ::temp5 ::temp5 " ARDOR set to " 
            ; line 7865
            callstatic sNRom_Decorators ArdorWord ::temp2 a ;1 variable args
            strcat ::temp2 ::temp5 ::temp2 
            callmethod Diag self ::nonevar ::temp3 ::temp2 False ;3 variable args
            jmp _label5
            ; line 7867
          _label6:
            assign e aiValue 
            ; line 7868
            cmp_lt ::temp0 e 0 
            jmpf ::temp0 _label9
            ; line 7869
            assign e 0 
            jmp _label10
            ; line 7870
          _label9:
            cmp_gt ::temp0 e 100 
            jmpf ::temp0 _label10
            ; line 7871
            assign e 100 
            jmp _label10
            ; line 7873
          _label10:
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "SNRom_Exclusivity" e ;3 variable args
            ; line 7874
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp2 "REPAIR: " who 
            strcat ::temp2 ::temp2 " EXCLUSIVITY set to " 
            cast ::temp5 e 
            strcat ::temp5 ::temp2 ::temp5 
            strcat ::temp5 ::temp5 " out of 100" 
            callmethod Diag self ::nonevar ::temp3 ::temp5 False ;3 variable args
          _label5
          .endCode
        .endFunction ;SetCharacterField
        .function ForceDriftReview
           ; function type 0
          .userFlags 0 ;none
          .docString "DEV TOOL. Reviews someone NOW, bypassing both gates.

      Dispatch with functionName ForceDriftReview and TWO arguments - a hex
      FormID and a field number. Papyrus default parameter values do not apply
      through the web API, so the count must match exactly or the call dies with
      an argument-count mismatch visible only in SkyrimNet.log.

        0 intimacy, 1 ardor, 2 exclusivity, anything else keeps the rotation.

      WHY THIS IS A DEV TOOL AND NOT A FEATURE. The two gates ARE the design -
      driftMinDays and driftMinEvents are what make a change a pattern rather
      than a reaction, and a build where they can be skipped in ordinary play is
      a build where personalities move on one good evening again. This exists so
      the drift path can be exercised without waiting a game week for the first
      honest review, and for nothing else.

      It still cannot invent a verdict. Everything downstream is untouched: the
      response must name a pattern spanning more than one occasion, the echo
      check still voids a mismatched name, and ApplyDrift still moves exactly
      one rung. A forced review of someone with a quiet history should come back
      NO, and that is the correct result rather than a failed test."
          .return None
          .paramTable
            .param akActor actor
            .param aiField Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::nonevar None
            .local ::temp2 Int
            .local ::temp3 String
            .local ::temp4 String
            .local ::temp5 form
            .local firstDay Float
            .local ::temp6 Float
            .local lastDay Float
            .local span String
          .endLocalTable
          .code
            ; line 7900
            not ::temp0 _ready 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 akActor ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 7901
            return None 
            jmp _label1
            ; line 7903
          _label1:
            cast ::temp1 None 
            cmp_eq ::temp0 _driftActor ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 7904
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            strcat ::temp3 "Releasing the drift slot held by " _driftName 
            strcat ::temp3 ::temp3 " to force a review of " 
            ; line 7905
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            strcat ::temp4 ::temp3 ::temp4 
            callmethod Diag self ::nonevar ::temp2 ::temp4 False ;3 variable args
            ; line 7906
            cast ::temp1 None 
            assign _driftActor ::temp1 
            jmp _label2
            ; line 7908
          _label2:
            comp_gte ::temp0 aiField 0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            cmp_lte ::temp0 aiField 2 
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 7909
            cast ::temp5 akActor 
            callstatic storageUtil SetIntValue ::temp2 ::temp5 "SNRom_DriftField" aiField ;3 variable args
            jmp _label4
            ; line 7915
          _label4:
            cast ::temp5 akActor 
            callstatic storageUtil GetFloatValue ::temp6 ::temp5 "SNRom_DriftFirstDay" -1.0 ;3 variable args
            assign firstDay ::temp6 
            ; line 7916
            cast ::temp5 akActor 
            callstatic storageUtil GetFloatValue ::temp6 ::temp5 "SNRom_DriftLastDay" -1.0 ;3 variable args
            assign lastDay ::temp6 
            ; line 7917
            assign span "no scoring events recorded since the last review" 
            ; line 7918
            comp_gte ::temp0 firstDay 0.0 
            jmpf ::temp0 _label5
            ; line 7919
            fsub ::temp6 lastDay firstDay 
            cast ::temp4 ::temp6 
            strcat ::temp4 "their events span " ::temp4 
            strcat ::temp4 ::temp4 " game days (needs " 
            ; line 7920
            callstatic sNRom_Bridge DriftSpanDays ::temp6 ;0 variable args
            cast ::temp3 ::temp6 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 ")" 
            assign span ::temp3 
            jmp _label5
            ; line 7922
          _label5:
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 "FORCED drift review for " ::temp3 
            strcat ::temp3 ::temp3 " - both gates bypassed, this is a dev tool. " 
            ; line 7923
            strcat ::temp3 ::temp3 span 
            strcat ::temp3 ::temp3 ". If that is under " 
            strcat ::temp3 ::temp3 "the requirement, the material is one occasion and NO is the only honest " 
            ; line 7924
            strcat ::temp3 ::temp3 "answer - a YES here is manufactured, not a bug in the verdict." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 7926
            callmethod AssessDrift self ::nonevar akActor ;1 variable args
          .endCode
        .endFunction ;ForceDriftReview
        .function AssessDrift
           ; function type 0
          .userFlags 0 ;none
          .docString "Asks the one question, about the one field whose turn it is."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 Float
            .local ::temp2 form
            .local ::temp3 Int
            .local minTier Int
            .local current String
            .local ::temp4 Bool
            .local ctx String
            .local ::temp5 String
            .local rc Int
            .local ::temp6 quest
            .local ::nonevar None
            .local ::temp7 actor
          .endLocalTable
          .code
            ; line 7931
            assign _driftActor akActor 
            ; line 7932
            callmethod GetDisplayName akActor ::temp0 ;0 variable args
            assign _driftName ::temp0 
            ; line 7933
            callstatic utility GetCurrentRealTime ::temp1 ;0 variable args
            assign _driftPendingAt ::temp1 
            ; line 7938
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_DriftField" 0 ;3 variable args
            assign _driftField ::temp3 
            ; line 7939
            cast ::temp2 akActor 
            iadd ::temp3 _driftField 1 
            imod ::temp3 ::temp3 3 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_DriftField" ::temp3 ;3 variable args
            ; line 7941
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_PhysMinTier" 4 ;3 variable args
            assign minTier ::temp3 
            ; line 7942
            assign current "" 
            ; line 7943
            callstatic sNRom_Bridge DRIFT_INTIMACY ::temp3 ;0 variable args
            cmp_eq ::temp4 _driftField ::temp3 
            jmpf ::temp4 _label0
            ; line 7944
            callstatic sNRom_Decorators IntimacyWordFromTier ::temp0 minTier ;1 variable args
            assign current ::temp0 
            jmp _label1
            ; line 7945
          _label0:
            callstatic sNRom_Bridge DRIFT_ARDOR ::temp3 ;0 variable args
            cmp_eq ::temp4 _driftField ::temp3 
            jmpf ::temp4 _label2
            ; line 7946
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Ardor" 2 ;3 variable args
            callstatic sNRom_Decorators ArdorWord ::temp0 ::temp3 ;1 variable args
            assign current ::temp0 
            jmp _label1
            ; line 7948
          _label2:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_Exclusivity" 50 ;3 variable args
            cast ::temp0 ::temp3 
            strcat ::temp0 ::temp0 " out of 100" 
            assign current ::temp0 
            ; line 7956
          _label1:
            callstatic sNRom_Bridge Escape ::temp0 _driftName ;1 variable args
            strcat ::temp0 "{\"npc_name\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 ::temp0 ",\"npc_formid\":" 
            ; line 7957
            callmethod GetFormID akActor ::temp3 ;0 variable args
            cast ::temp5 ::temp3 
            strcat ::temp5 ::temp0 ::temp5 
            strcat ::temp5 ::temp5 ",\"drift_field\":\"" 
            ; line 7958
            callstatic sNRom_Bridge DriftFieldName ::temp0 _driftField ;1 variable args
            strcat ::temp0 ::temp5 ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 ::temp0 ",\"drift_current\":\"" 
            ; line 7959
            callstatic sNRom_Bridge Escape ::temp5 current ;1 variable args
            strcat ::temp5 ::temp0 ::temp5 
            strcat ::temp5 ::temp5 "\"" 
            strcat ::temp5 ::temp5 ",\"drift_days\":" 
            ; line 7960
            callstatic sNRom_Bridge DriftDays ::temp1 ;0 variable args
            cast ::temp0 ::temp1 
            strcat ::temp0 ::temp5 ::temp0 
            strcat ::temp0 ::temp0 ",\"npc_why\":\"" 
            ; line 7961
            callstatic sNRom_Bridge StoreGetText ::temp5 akActor "Why" "" 0 ;4 variable args
            callstatic sNRom_Bridge Escape ::temp5 ::temp5 ;1 variable args
            strcat ::temp5 ::temp0 ::temp5 
            strcat ::temp5 ::temp5 "\"" 
            callstatic sNRom_Bridge MarasContext ::temp0 akActor ;1 variable args
            strcat ::temp0 ::temp5 ::temp0 
            strcat ::temp0 ::temp0 "}" 
            assign ctx ::temp0 
            ; line 7963
            callstatic sNRom_Bridge VariantName ::temp0 ;0 variable args
            ; line 7964
            cast ::temp6 self 
            callstatic skyrimNetApi SendCustomPromptToLLM ::temp3 "snrom_disposition_drift" ::temp0 ctx ::temp6 "SNRom_Bridge" "OnDriftAssessed" ;6 variable args
            assign rc ::temp3 
            ; line 7965
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp0 "Drift review sent for " _driftName 
            strcat ::temp0 ::temp0 " on " 
            ; line 7966
            callstatic sNRom_Bridge DriftFieldName ::temp5 _driftField ;1 variable args
            strcat ::temp5 ::temp0 ::temp5 
            strcat ::temp5 ::temp5 " (currently " 
            strcat ::temp5 ::temp5 current 
            strcat ::temp5 ::temp5 ", rc=" 
            cast ::temp0 rc 
            strcat ::temp0 ::temp5 ::temp0 
            strcat ::temp0 ::temp0 ")" 
            callmethod Diag self ::nonevar ::temp3 ::temp0 False ;3 variable args
            ; line 7967
            cmp_eq ::temp4 rc 1 
            not ::temp4 ::temp4 
            jmpf ::temp4 _label3
            ; line 7968
            cast ::temp7 None 
            assign _driftActor ::temp7 
            jmp _label3
          _label3
          .endCode
        .endFunction ;AssessDrift
        .function OnDriftAssessed
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param asResponse String
            .param aiSuccess Int
          .endParamTable
          .localTable
            .local who actor
            .local asked String
            .local field Int
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Float
            .local ::temp4 Int
            .local echoed String
            .local ::temp5 String
            .local ::nonevar None
            .local verdict String
            .local pattern String
            .local toward String
            .local ::temp6 String
            .local cited Int
          .endLocalTable
          .code
            ; line 7973
            assign who _driftActor 
            ; line 7974
            assign asked _driftName 
            ; line 7975
            assign field _driftField 
            ; line 7976
            cast ::temp0 None 
            assign _driftActor ::temp0 
            ; line 7978
            cast ::temp0 None 
            cmp_eq ::temp1 who ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 aiSuccess 1 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 7979
            return None 
            jmp _label1
            ; line 7986
          _label1:
            cast ::temp2 who 
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp3 ::temp2 "SNRom_LastDriftCheck" ::temp3 ;3 variable args
            ; line 7987
            cast ::temp2 who 
            callstatic storageUtil SetIntValue ::temp4 ::temp2 "SNRom_EventsSinceDrift" 0 ;3 variable args
            ; line 7991
            cast ::temp2 who 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp2 "SNRom_DriftFirstDay" ;2 variable args
            ; line 7992
            cast ::temp2 who 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp2 "SNRom_DriftLastDay" ;2 variable args
            ; line 7994
            callstatic sNRom_Decorators FieldValue ::temp5 asResponse "NAME:" ;2 variable args
            callstatic sNRom_Decorators NameCore ::temp5 ::temp5 ;1 variable args
            assign echoed ::temp5 
            ; line 7995
            cmp_eq ::temp1 echoed "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            callstatic sNRom_Decorators NameCore ::temp5 asked ;1 variable args
            cmp_eq ::temp1 echoed ::temp5 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 7996
            callstatic sNRom_Bridge LOG_ERROR ::temp4 ;0 variable args
            strcat ::temp5 "Drift echo mismatch: asked about '" asked 
            strcat ::temp5 ::temp5 "', answered as '" 
            ; line 7997
            strcat ::temp5 ::temp5 echoed 
            strcat ::temp5 ::temp5 "'. Discarded." 
            callmethod Diag self ::nonevar ::temp4 ::temp5 False ;3 variable args
            ; line 7998
            return None 
            jmp _label3
            ; line 8001
          _label3:
            callstatic sNRom_Decorators FieldValue ::temp5 asResponse "CHANGED:" ;2 variable args
            callstatic sNRom_Decorators Upper ::temp5 ::temp5 ;1 variable args
            assign verdict ::temp5 
            ; line 8002
            callstatic sNRom_Decorators FieldValue ::temp5 asResponse "PATTERN:" ;2 variable args
            assign pattern ::temp5 
            ; line 8003
            callstatic sNRom_Decorators FieldValue ::temp5 asResponse "DIRECTION:" ;2 variable args
            callstatic sNRom_Decorators Upper ::temp5 ::temp5 ;1 variable args
            assign toward ::temp5 
            ; line 8005
            cmp_eq ::temp1 verdict "YES" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label4
            ; line 8006
            callstatic sNRom_Bridge LOG_INFO ::temp4 ;0 variable args
            strcat ::temp5 "No drift for " asked 
            strcat ::temp5 ::temp5 " on " 
            callstatic sNRom_Bridge DriftFieldName ::temp6 field ;1 variable args
            strcat ::temp6 ::temp5 ::temp6 
            strcat ::temp6 ::temp6 " (answered '" 
            ; line 8007
            strcat ::temp6 ::temp6 verdict 
            strcat ::temp6 ::temp6 "') - unchanged is the expected answer" 
            callmethod Diag self ::nonevar ::temp4 ::temp6 False ;3 variable args
            ; line 8008
            return None 
            jmp _label4
            ; line 8013
          _label4:
            cmp_eq ::temp1 pattern "" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label5
            callstatic sNRom_Decorators Upper ::temp6 pattern ;1 variable args
            cmp_eq ::temp1 ::temp6 "NONE" 
            assign ::temp1 ::temp1 
          _label5:
            jmpf ::temp1 _label6
            ; line 8014
            callstatic sNRom_Bridge LOG_WARN ::temp4 ;0 variable args
            strcat ::temp6 "Drift claimed for " asked 
            strcat ::temp6 ::temp6 " with no pattern named - discarded" 
            callmethod Diag self ::nonevar ::temp4 ::temp6 False ;3 variable args
            ; line 8015
            return None 
            jmp _label6
            ; line 8022
          _label6:
            callstatic sNRom_Decorators FieldValue ::temp6 asResponse "OCCASIONS:" ;2 variable args
            callstatic sNRom_Decorators CountOccasions ::temp4 ::temp6 ;1 variable args
            assign cited ::temp4 
            ; line 8023
            cmp_lt ::temp1 cited 2 
            jmpf ::temp1 _label7
            ; line 8024
            callstatic sNRom_Bridge LOG_WARN ::temp4 ;0 variable args
            strcat ::temp6 "Drift for " asked 
            strcat ::temp6 ::temp6 " discarded - a pattern needs moments on at " 
            strcat ::temp6 ::temp6 "least two DIFFERENT DAYS and only " 
            ; line 8025
            cast ::temp5 cited 
            strcat ::temp5 ::temp6 ::temp5 
            strcat ::temp5 ::temp5 " distinct dated occasion(s) were " 
            strcat ::temp5 ::temp5 "cited. Undated citations, and several from one evening, do not count. " 
            ; line 8026
            strcat ::temp5 ::temp5 "Claimed pattern was: " 
            ; line 8027
            strcat ::temp5 ::temp5 pattern 
            callmethod Diag self ::nonevar ::temp4 ::temp5 False ;3 variable args
            ; line 8028
            return None 
            jmp _label7
            ; line 8033
          _label7:
            callstatic sNRom_Decorators PatternIsWatching ::temp1 pattern ;1 variable args
            jmpf ::temp1 _label8
            ; line 8034
            callstatic sNRom_Bridge LOG_WARN ::temp4 ;0 variable args
            strcat ::temp5 "Drift for " asked 
            strcat ::temp5 ::temp5 " discarded - the pattern rests on what " 
            strcat ::temp5 ::temp5 "they WATCHED, which is an account of being present rather than evidence " 
            ; line 8035
            strcat ::temp5 ::temp5 "about the two of them. Pattern was: " 
            ; line 8036
            strcat ::temp5 ::temp5 pattern 
            callmethod Diag self ::nonevar ::temp4 ::temp5 False ;3 variable args
            ; line 8037
            return None 
            jmp _label8
            ; line 8039
          _label8:
            cmp_eq ::temp1 toward "OPEN" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label9
            cmp_eq ::temp1 toward "CLOSED" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label9:
            jmpf ::temp1 _label10
            ; line 8040
            callstatic sNRom_Bridge LOG_WARN ::temp4 ;0 variable args
            strcat ::temp5 "Drift for " asked 
            strcat ::temp5 ::temp5 " gave no usable direction ('" 
            strcat ::temp5 ::temp5 toward 
            ; line 8041
            strcat ::temp5 ::temp5 "') - discarded" 
            callmethod Diag self ::nonevar ::temp4 ::temp5 False ;3 variable args
            ; line 8042
            return None 
            jmp _label10
            ; line 8045
          _label10:
            cmp_eq ::temp1 toward "OPEN" 
            callmethod ApplyDrift self ::nonevar who field ::temp1 pattern ;4 variable args
          .endCode
        .endFunction ;OnDriftAssessed
        .function ApplyDrift
           ; function type 0
          .userFlags 0 ;none
          .docString "Moves ONE field by exactly ONE step, and writes what earned it.

      The step sizes are ours, not the model's - it is asked only which way,
      never how far. That is the same separation the conversational weights
      use, and for the same reason: a model asked for a magnitude will
      eventually give a large one."
          .return None
          .paramTable
            .param akActor actor
            .param aiField Int
            .param abOpen Bool
            .param asPattern String
          .endParamTable
          .localTable
            .local who String
            .local ::temp0 String
            .local before String
            .local after String
            .local ::temp1 Int
            .local ::temp2 Bool
            .local rank Int
            .local ::temp3 form
            .local newTier Int
            .local ardor Int
            .local excl Int
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 actor
          .endLocalTable
          .code
            ; line 8055
            callmethod GetDisplayName akActor ::temp0 ;0 variable args
            assign who ::temp0 
            ; line 8056
            assign before "" 
            ; line 8057
            assign after "" 
            ; line 8059
            callstatic sNRom_Bridge DRIFT_INTIMACY ::temp1 ;0 variable args
            cmp_eq ::temp2 aiField ::temp1 
            jmpf ::temp2 _label0
            ; line 8060
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp3 "SNRom_PhysMinTier" 4 ;3 variable args
            callstatic sNRom_Decorators IntimacyRank ::temp1 ::temp1 ;1 variable args
            assign rank ::temp1 
            ; line 8061
            callstatic sNRom_Decorators MinTierFromRank ::temp1 rank ;1 variable args
            callstatic sNRom_Decorators IntimacyWordFromTier ::temp0 ::temp1 ;1 variable args
            assign before ::temp0 
            ; line 8062
            jmpf abOpen _label1
            ; line 8063
            isub ::temp1 rank 1 
            assign rank ::temp1 
            jmp _label2
            ; line 8065
          _label1:
            iadd ::temp1 rank 1 
            assign rank ::temp1 
            ; line 8067
          _label2:
            cmp_lt ::temp2 rank 0 
            jmpf ::temp2 _label3
            ; line 8068
            assign rank 0 
            jmp _label4
            ; line 8069
          _label3:
            cmp_gt ::temp2 rank 3 
            jmpf ::temp2 _label4
            ; line 8070
            assign rank 3 
            jmp _label4
            ; line 8072
          _label4:
            callstatic sNRom_Decorators MinTierFromRank ::temp1 rank ;1 variable args
            assign newTier ::temp1 
            ; line 8073
            callstatic sNRom_Decorators IntimacyWordFromTier ::temp0 newTier ;1 variable args
            assign after ::temp0 
            ; line 8074
            cast ::temp3 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp3 "SNRom_PhysMinTier" newTier ;3 variable args
            ; line 8079
            cast ::temp3 akActor 
            ; line 8080
            callstatic sNRom_Decorators IntimacyToBypass ::temp1 after ;1 variable args
            callstatic storageUtil SetIntValue ::temp1 ::temp3 "SNRom_PhysAttrBypass" ::temp1 ;3 variable args
            ; line 8081
            callmethod IEB_LockChildIntimacy self ::temp2 akActor ;1 variable args
            jmp _label5
            ; line 8083
          _label0:
            callstatic sNRom_Bridge DRIFT_ARDOR ::temp1 ;0 variable args
            cmp_eq ::temp2 aiField ::temp1 
            jmpf ::temp2 _label6
            ; line 8084
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp3 "SNRom_Ardor" 2 ;3 variable args
            assign ardor ::temp1 
            ; line 8085
            callstatic sNRom_Decorators ArdorWord ::temp0 ardor ;1 variable args
            assign before ::temp0 
            ; line 8086
            jmpf abOpen _label7
            ; line 8087
            iadd ::temp1 ardor 1 
            assign ardor ::temp1 
            jmp _label8
            ; line 8089
          _label7:
            isub ::temp1 ardor 1 
            assign ardor ::temp1 
            ; line 8091
          _label8:
            cmp_lt ::temp2 ardor 0 
            jmpf ::temp2 _label9
            ; line 8092
            assign ardor 0 
            jmp _label10
            ; line 8093
          _label9:
            cmp_gt ::temp2 ardor 4 
            jmpf ::temp2 _label10
            ; line 8094
            assign ardor 4 
            jmp _label10
            ; line 8096
          _label10:
            callstatic sNRom_Decorators ArdorWord ::temp0 ardor ;1 variable args
            assign after ::temp0 
            ; line 8097
            cast ::temp3 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp3 "SNRom_Ardor" ardor ;3 variable args
            jmp _label5
            ; line 8100
          _label6:
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp3 "SNRom_Exclusivity" 50 ;3 variable args
            assign excl ::temp1 
            ; line 8101
            cast ::temp0 excl 
            strcat ::temp0 ::temp0 " out of 100" 
            assign before ::temp0 
            ; line 8115
            jmpf abOpen _label11
            ; line 8116
            isub ::temp1 excl 20 
            assign excl ::temp1 
            jmp _label12
            ; line 8118
          _label11:
            iadd ::temp1 excl 20 
            assign excl ::temp1 
            ; line 8120
          _label12:
            cmp_lt ::temp2 excl 0 
            jmpf ::temp2 _label13
            ; line 8121
            assign excl 0 
            jmp _label14
            ; line 8122
          _label13:
            cmp_gt ::temp2 excl 100 
            jmpf ::temp2 _label14
            ; line 8123
            assign excl 100 
            jmp _label14
            ; line 8125
          _label14:
            cast ::temp0 excl 
            strcat ::temp0 ::temp0 " out of 100" 
            assign after ::temp0 
            ; line 8126
            cast ::temp3 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp3 "SNRom_Exclusivity" excl ;3 variable args
            ; line 8129
          _label5:
            cmp_eq ::temp2 before after 
            jmpf ::temp2 _label15
            ; line 8130
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            strcat ::temp0 "Drift for " who 
            strcat ::temp0 ::temp0 " on " 
            callstatic sNRom_Bridge DriftFieldName ::temp4 aiField ;1 variable args
            strcat ::temp4 ::temp0 ::temp4 
            strcat ::temp4 ::temp4 " was already at the end of its range (" 
            ; line 8131
            strcat ::temp4 ::temp4 before 
            strcat ::temp4 ::temp4 ") - nothing to move" 
            callmethod Diag self ::nonevar ::temp1 ::temp4 False ;3 variable args
            ; line 8132
            return None 
            jmp _label15
            ; line 8135
          _label15:
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            strcat ::temp4 "DRIFT: " who 
            strcat ::temp4 ::temp4 " " 
            callstatic sNRom_Bridge DriftFieldName ::temp0 aiField ;1 variable args
            strcat ::temp0 ::temp4 ::temp0 
            strcat ::temp0 ::temp0 " " 
            strcat ::temp0 ::temp0 before 
            ; line 8136
            strcat ::temp0 ::temp0 " -> " 
            strcat ::temp0 ::temp0 after 
            strcat ::temp0 ::temp0 " - " 
            strcat ::temp0 ::temp0 asPattern 
            callmethod Diag self ::nonevar ::temp1 ::temp0 False ;3 variable args
            ; line 8141
            strcat ::temp0 who " has been changing, in a way " 
            ; line 8142
            callstatic game GetPlayer ::temp5 ;0 variable args
            callmethod GetDisplayName ::temp5 ::temp4 ;0 variable args
            strcat ::temp4 ::temp0 ::temp4 
            strcat ::temp4 ::temp4 " has had a hand in. " 
            strcat ::temp4 ::temp4 asPattern 
            callmethod SendModEvent akActor ::nonevar "IEB_SNRomStatus" ::temp4 0.0 ;3 variable args
          .endCode
        .endFunction ;ApplyDrift
        .function PumpAuthoringQueue
           ; function type 0
          .userFlags 0 ;none
          .docString "Starts the next queued authoring, if any and if nothing is in flight."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local n Int
            .local ::temp2 form
            .local ::temp3 Int
            .local f form
            .local next actor
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 Int
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 8147
            cast ::temp0 None 
            cmp_eq ::temp1 _pendingActor ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label0
            ; line 8148
            return None 
            jmp _label0
            ; line 8150
          _label0:
            cast ::temp2 None 
            callstatic storageUtil FormListCount ::temp3 ::temp2 "SNRom_AuthorQueue" ;2 variable args
            assign n ::temp3 
            ; line 8151
            cmp_lte ::temp1 n 0 
            jmpf ::temp1 _label1
            ; line 8152
            return None 
            jmp _label1
            ; line 8154
          _label1:
            cast ::temp2 None 
            callstatic storageUtil FormListGet ::temp2 ::temp2 "SNRom_AuthorQueue" 0 ;3 variable args
            assign f ::temp2 
            ; line 8155
            cast ::temp2 None 
            callstatic storageUtil FormListRemoveAt ::temp1 ::temp2 "SNRom_AuthorQueue" 0 ;3 variable args
            ; line 8156
            cast ::temp0 f 
            assign next ::temp0 
            ; line 8157
            cast ::temp0 None 
            cmp_eq ::temp1 next ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 8158
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            callmethod GetDisplayName next ::temp4 ;0 variable args
            strcat ::temp4 "Dequeued " ::temp4 
            strcat ::temp4 ::temp4 " for authoring (" 
            isub ::temp5 n 1 
            cast ::temp6 ::temp5 
            strcat ::temp6 ::temp4 ::temp6 
            strcat ::temp6 ::temp6 " left)" 
            callmethod Diag self ::nonevar ::temp3 ::temp6 False ;3 variable args
            ; line 8159
            callmethod AuthorDisposition self ::nonevar next ;1 variable args
            jmp _label3
            ; line 8161
          _label2:
            callmethod RegisterForSingleUpdate self ::nonevar 2.0 ;1 variable args
          _label3
          .endCode
        .endFunction ;PumpAuthoringQueue
        .function OnDispositionAuthored
           ; function type 0
          .userFlags 0 ;none
          .docString "SkyrimNet's callback for AuthorDisposition, named in its dispatch. A
      thin wrapper since WP2, like OnSeedAssessed: DispositionAuthored has six
      early exits, and an open dashboard wants the row - traits as well as the
      prose ApplyProse pushes - after whichever one runs. A re-author or
      preference repair started from the dashboard ends here."
          .return None
          .paramTable
            .param asResponse String
            .param aiSuccess Int
          .endParamTable
          .localTable
            .local who actor
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 8171
            assign who _pendingActor 
            ; line 8172
            callmethod DispositionAuthored self ::nonevar asResponse aiSuccess ;2 variable args
            ; line 8173
            jmpf _dashText _label0
            ; line 8174
            callmethod PushBond self ::nonevar who 0 ;2 variable args
            jmp _label0
          _label0
          .endCode
        .endFunction ;OnDispositionAuthored
        .function DispositionAuthored
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param asResponse String
            .param aiSuccess Int
          .endParamTable
          .localTable
            .local who actor
            .local asked String
            .local ::temp0 actor
            .local ::nonevar None
            .local ::temp1 Bool
            .local ::temp2 Int
            .local ::temp3 String
            .local echoed String
            .local ::temp4 form
          .endLocalTable
          .code
            ; line 8179
            assign who _pendingActor 
            ; line 8180
            assign asked _pendingName 
            ; line 8181
            cast ::temp0 None 
            assign _pendingActor ::temp0 
            ; line 8186
            callmethod RegisterForSingleUpdate self ::nonevar 2.0 ;1 variable args
            ; line 8191
            callmethod LogDisposition self ::nonevar asked aiSuccess asResponse "" ;4 variable args
            ; line 8193
            cast ::temp0 None 
            cmp_eq ::temp1 who ::temp0 
            jmpf ::temp1 _label0
            ; line 8194
            return None 
            jmp _label0
            ; line 8196
          _label0:
            cmp_eq ::temp1 aiSuccess 1 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label1
            ; line 8197
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            strcat ::temp3 "Disposition LLM call failed for " asked 
            strcat ::temp3 ::temp3 " - archetype fallback" 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 8198
            callmethod ApplyArchetype self ::nonevar who ;1 variable args
            ; line 8199
            return None 
            jmp _label1
            ; line 8206
          _label1:
            callstatic sNRom_Decorators FieldValue ::temp3 asResponse "NAME:" ;2 variable args
            callstatic sNRom_Decorators NameCore ::temp3 ::temp3 ;1 variable args
            assign echoed ::temp3 
            ; line 8207
            cmp_eq ::temp1 echoed "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            callstatic sNRom_Decorators NameCore ::temp3 asked ;1 variable args
            cmp_eq ::temp1 echoed ::temp3 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 8208
            callstatic sNRom_Bridge LOG_ERROR ::temp2 ;0 variable args
            strcat ::temp3 "Disposition echo mismatch: asked for '" asked 
            strcat ::temp3 ::temp3 "', model answered as '" 
            strcat ::temp3 ::temp3 echoed 
            strcat ::temp3 ::temp3 "'. Discarded." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 8209
            strcat ::temp3 "echo-mismatch:" echoed 
            callmethod LogDisposition self ::nonevar asked aiSuccess asResponse ::temp3 ;4 variable args
            ; line 8210
            callmethod ApplyArchetype self ::nonevar who ;1 variable args
            ; line 8211
            return None 
            jmp _label3
            ; line 8225
          _label3:
            callmethod IsChild who ::temp1 ;0 variable args
            jmpf ::temp1 _label4
            ; line 8226
            callstatic sNRom_Decorators FieldValue ::temp3 asResponse "WHY:" ;2 variable args
            cmp_eq ::temp1 ::temp3 "" 
            jmpf ::temp1 _label5
            ; line 8227
            callstatic sNRom_Bridge LOG_ERROR ::temp2 ;0 variable args
            strcat ::temp3 "Truncated child response for " asked 
            strcat ::temp3 ::temp3 " (no WHY:). Discarded." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 8228
            callmethod LogDisposition self ::nonevar asked aiSuccess asResponse "truncated-child" ;4 variable args
            ; line 8229
            callmethod ApplyArchetype self ::nonevar who ;1 variable args
            ; line 8230
            return None 
            jmp _label5
          _label5:
            jmp _label6
            ; line 8232
          _label4:
            callstatic sNRom_Decorators FieldValue ::temp3 asResponse "EXCLUSIVITY:" ;2 variable args
            cmp_eq ::temp1 ::temp3 "" 
            jmpf ::temp1 _label6
            ; line 8233
            callstatic sNRom_Bridge LOG_ERROR ::temp2 ;0 variable args
            strcat ::temp3 "Truncated response for " asked 
            strcat ::temp3 ::temp3 " (no EXCLUSIVITY: - died before the character block finished). Discarded." 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 8235
            callmethod LogDisposition self ::nonevar asked aiSuccess asResponse "truncated-early" ;4 variable args
            ; line 8236
            callmethod ApplyArchetype self ::nonevar who ;1 variable args
            ; line 8237
            return None 
            jmp _label6
            ; line 8252
          _label6:
            callmethod ApplyCharacter self ::nonevar who asResponse ;2 variable args
            ; line 8253
            cast ::temp4 who 
            callstatic storageUtil SetIntValue ::temp2 ::temp4 "SNRom_DispositionAuthored" 1 ;3 variable args
            ; line 8261
            callmethod ApplyProse self ::nonevar who asResponse asked ;3 variable args
            ; line 8263
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            strcat ::temp3 "Disposition authored for " asked 
            callmethod Diag self ::nonevar ::temp2 ::temp3 False ;3 variable args
            ; line 8264
            callmethod LogDisposition self ::nonevar asked aiSuccess asResponse "applied" ;4 variable args
            ; line 8265
            callmethod IEB_QueueIntimacy self ::nonevar who ;1 variable args
          .endCode
        .endFunction ;DispositionAuthored
        .function ApplyProse
           ; function type 0
          .userFlags 0 ;none
          .docString "The three free-text fields: WHY, LIMIT and ADDRESS.

      Extracted from OnDispositionAuthored so the character-only path can write
      them without also touching preferences. Shared rather than duplicated: WHY
      is the one field BuildCircle used to read, and a second copy of this logic
      drifting out of step would take circle differentiation down silently.

      ABSENT IS NOT BLANK, for all three. Writing "" erases a good earlier line.
      A truncated response carries no fields at all, and treating that as an
      answer of "nothing" is how a working disposition gets wiped by a failed
      re-author."
          .return None
          .paramTable
            .param akActor actor
            .param asResponse String
            .param asName String
          .endParamTable
          .localTable
            .local whyLine String
            .local ::temp0 String
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 Int
            .local limitLine String
            .local addressLine String
          .endLocalTable
          .code
            ; line 8280
            callstatic sNRom_Decorators FieldValue ::temp0 asResponse "WHY:" ;2 variable args
            assign whyLine ::temp0 
            ; line 8281
            cmp_eq ::temp1 whyLine "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label0
            ; line 8282
            callstatic sNRom_Bridge StoreSetText ::nonevar akActor "Why" whyLine ;3 variable args
            jmp _label1
            ; line 8284
          _label0:
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            strcat ::temp0 "No WHY in response for " asName 
            strcat ::temp0 ::temp0 " - previous line kept" 
            callmethod Diag self ::nonevar ::temp2 ::temp0 False ;3 variable args
            ; line 8299
          _label1:
            callstatic sNRom_Decorators FieldValue ::temp0 asResponse "LIMIT:" ;2 variable args
            assign limitLine ::temp0 
            ; line 8300
            cmp_eq ::temp1 limitLine "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 8301
            callstatic sNRom_Bridge StoreSetText ::nonevar akActor "Limit" limitLine ;3 variable args
            jmp _label3
            ; line 8303
          _label2:
            callstatic sNRom_Bridge LOG_WARN ::temp2 ;0 variable args
            strcat ::temp0 "No LIMIT in response for " asName 
            strcat ::temp0 ::temp0 " - previous line kept" 
            callmethod Diag self ::nonevar ::temp2 ::temp0 False ;3 variable args
            ; line 8336
          _label3:
            callstatic sNRom_Decorators FieldValue ::temp0 asResponse "ADDRESS:" ;2 variable args
            assign addressLine ::temp0 
            ; line 8337
            cmp_eq ::temp1 addressLine "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label4
            ; line 8338
            callstatic sNRom_Bridge StoreSetText ::nonevar akActor "Address" addressLine ;3 variable args
            jmp _label4
            ; line 8343
          _label4:
            jmpf _dashText _label5
            ; line 8344
            callmethod PushBondText self ::nonevar akActor ;1 variable args
            jmp _label5
          _label5
          .endCode
        .endFunction ;ApplyProse
        .function ApplyCharacter
           ; function type 0
          .userFlags 0 ;none
          .docString "Writes the six keys that gate romance and intimacy. Until 2026-07-28 all
      six were read-with-a-default and written by NOTHING, so every NPC in the
      game shared one hardcoded personality and both gates were decorative.

      Written ONLY here, on a successful authored response that has already
      passed the name echo-check - so a response answering as the wrong NPC
      cannot rewrite someone's sexuality.

      Orientation and intimacy are deliberately independent. Sapphire is the
      case that proves it: someone who shuns commitment may never cross into
      Lover, and should still be able to want someone she is attracted to.
      That is CASUAL intimacy with a high bar for love - two separate fields,
      because collapsing them into one romance axis loses her entirely."
          .return None
          .paramTable
            .param akActor actor
            .param asResponse String
          .endParamTable
          .localTable
            .local basisWord String
            .local ::temp0 String
            .local orientWord String
            .local intimWord String
            .local basis Int
            .local ::temp1 Int
            .local orient Int
            .local minTier Int
            .local bypass Int
            .local ardor Int
            .local excl Int
            .local orientStored Bool
            .local ::temp2 Bool
            .local ::nonevar None
            .local ::temp3 String
            .local ::temp4 form
            .local orientPart String
          .endLocalTable
          .code
            ; line 8375
            callstatic sNRom_Decorators FieldValue ::temp0 asResponse "SEXUAL_ORIENTATION_BASIS:" ;2 variable args
            assign basisWord ::temp0 
            ; line 8376
            callstatic sNRom_Decorators FieldValue ::temp0 asResponse "SEXUAL_ORIENTATION:" ;2 variable args
            assign orientWord ::temp0 
            ; line 8377
            callstatic sNRom_Decorators FieldValue ::temp0 asResponse "INTIMACY:" ;2 variable args
            assign intimWord ::temp0 
            ; line 8379
            callstatic sNRom_Decorators OrientationBasisToInt ::temp1 basisWord ;1 variable args
            assign basis ::temp1 
            ; line 8380
            callstatic sNRom_Decorators OrientationToInt ::temp1 orientWord ;1 variable args
            assign orient ::temp1 
            ; line 8381
            callstatic sNRom_Decorators IntimacyToMinTier ::temp1 intimWord ;1 variable args
            assign minTier ::temp1 
            ; line 8382
            callstatic sNRom_Decorators IntimacyToBypass ::temp1 intimWord ;1 variable args
            assign bypass ::temp1 
            ; line 8383
            callstatic sNRom_Decorators FieldValue ::temp0 asResponse "ARDOR:" ;2 variable args
            callstatic sNRom_Decorators ArdorToInt ::temp1 ::temp0 ;1 variable args
            assign ardor ::temp1 
            ; line 8384
            callstatic sNRom_Decorators FieldValue ::temp0 asResponse "EXCLUSIVITY:" ;2 variable args
            callstatic sNRom_Decorators ExclusivityToInt ::temp1 ::temp0 ;1 variable args
            assign excl ::temp1 
            ; line 8418
            assign orientStored False 
            ; line 8419
            cmp_eq ::temp2 orientWord "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label0
            ; line 8420
            callstatic sNRom_Bridge IsMarriedToPlayer ::temp2 akActor ;1 variable args
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label1
            callstatic sNRom_Bridge OrientationExcludesPlayer ::temp2 orient ;1 variable args
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 8421
            callstatic sNRom_Bridge LOG_WARN ::temp1 ;0 variable args
            strcat ::temp0 "Rejected authored orientation '" orientWord 
            strcat ::temp0 ::temp0 "' (basis '" 
            strcat ::temp0 ::temp0 basisWord 
            strcat ::temp0 ::temp0 "') for " 
            ; line 8422
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 ::temp0 ::temp3 
            strcat ::temp3 ::temp3 " - she is married to the player, which the game " 
            strcat ::temp3 ::temp3 "records, so an orientation excluding them cannot be true. Field left as it was; " 
            ; line 8423
            strcat ::temp3 ::temp3 "every other authored field kept." 
            callmethod Diag self ::nonevar ::temp1 ::temp3 False ;3 variable args
            jmp _label3
            ; line 8426
          _label2:
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp4 "SNRom_Orientation" orient ;3 variable args
            ; line 8427
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp4 "SNRom_OrientationKnown" basis ;3 variable args
            ; line 8428
            assign orientStored True 
          _label3:
            jmp _label0
            ; line 8431
          _label0:
            cmp_eq ::temp2 intimWord "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label4
            ; line 8432
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp4 "SNRom_PhysMinTier" minTier ;3 variable args
            ; line 8433
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp4 "SNRom_PhysAttrBypass" bypass ;3 variable args
            jmp _label4
            ; line 8435
          _label4:
            callmethod IEB_LockChildIntimacy self ::temp2 akActor ;1 variable args
            ; line 8436
            callstatic sNRom_Decorators FieldValue ::temp3 asResponse "ARDOR:" ;2 variable args
            cmp_eq ::temp2 ::temp3 "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label5
            ; line 8437
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp4 "SNRom_Ardor" ardor ;3 variable args
            jmp _label5
            ; line 8439
          _label5:
            callstatic sNRom_Decorators FieldValue ::temp3 asResponse "EXCLUSIVITY:" ;2 variable args
            cmp_eq ::temp2 ::temp3 "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label6
            ; line 8440
            cast ::temp4 akActor 
            callstatic storageUtil SetIntValue ::temp1 ::temp4 "SNRom_Exclusivity" excl ;3 variable args
            jmp _label6
            ; line 8450
          _label6:
            strcat ::temp3 "orientation='" orientWord 
            strcat ::temp3 ::temp3 "'->" 
            cast ::temp0 orient 
            strcat ::temp0 ::temp3 ::temp0 
            strcat ::temp0 ::temp0 " basis='" 
            ; line 8451
            strcat ::temp0 ::temp0 basisWord 
            strcat ::temp0 ::temp0 "'->" 
            cast ::temp3 basis 
            strcat ::temp3 ::temp0 ::temp3 
            assign orientPart ::temp3 
            ; line 8452
            cmp_eq ::temp2 orientWord "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label7
            not ::temp2 orientStored 
            assign ::temp2 ::temp2 
          _label7:
            jmpf ::temp2 _label8
            ; line 8453
            strcat ::temp3 "orientation=REJECTED(authored '" orientWord 
            strcat ::temp3 ::temp3 "', married to player) - unchanged" 
            assign orientPart ::temp3 
            jmp _label8
            ; line 8455
          _label8:
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 "Character for " ::temp3 
            strcat ::temp3 ::temp3 ": " 
            ; line 8456
            strcat ::temp3 ::temp3 orientPart 
            strcat ::temp3 ::temp3 " intimacy='" 
            ; line 8457
            strcat ::temp3 ::temp3 intimWord 
            strcat ::temp3 ::temp3 "'->minTier" 
            cast ::temp0 minTier 
            strcat ::temp0 ::temp3 ::temp0 
            strcat ::temp0 ::temp0 "/bypass" 
            cast ::temp3 bypass 
            strcat ::temp3 ::temp0 ::temp3 
            strcat ::temp3 ::temp3 " ardor=" 
            ; line 8458
            cast ::temp0 ardor 
            strcat ::temp0 ::temp3 ::temp0 
            strcat ::temp0 ::temp0 " exclusivity=" 
            cast ::temp3 excl 
            strcat ::temp3 ::temp0 ::temp3 
            callmethod Diag self ::nonevar ::temp1 ::temp3 False ;3 variable args
            ; line 8462
            callmethod EnforceBlockAnswers self ::nonevar akActor ;1 variable args
            ; line 8469
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 ::temp3 " re-authored: exclusivity " 
            ; line 8470
            cast ::temp4 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp4 "SNRom_Exclusivity" 50 ;3 variable args
            cast ::temp0 ::temp1 
            strcat ::temp0 ::temp3 ::temp0 
            strcat ::temp0 ::temp0 ", ardor " 
            ; line 8471
            cast ::temp4 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp4 "SNRom_Ardor" 2 ;3 variable args
            cast ::temp3 ::temp1 
            strcat ::temp3 ::temp0 ::temp3 
            strcat ::temp3 ::temp3 ", " 
            ; line 8472
            cast ::temp4 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp4 "SNRom_PhysMinTier" 4 ;3 variable args
            callstatic sNRom_Decorators IntimacyWordFromTier ::temp0 ::temp1 ;1 variable args
            strcat ::temp0 ::temp3 ::temp0 
            strcat ::temp0 ::temp0 "." 
            callmethod AnnounceAuthored self ::nonevar akActor ::temp0 ;2 variable args
          .endCode
        .endFunction ;ApplyCharacter
        .function EnforceBlockAnswers
           ; function type 0
          .userFlags 0 ;none
          .docString "THE BLOCKS WIN, ENFORCED RATHER THAN ASKED FOR.

      A `Drawn To:`, `Expression:` or `Attachment:` block is a direct answer the
      player applied on purpose, and the authoring prompt has always said so -
      "on its own field it outranks everything". Vivienne Onis, 2026-09-28:
      Drawn To: Both applied, re-authored ATTRACTED_TO_MEN / IMPLIED anyway. The
      two fields whose answer line carried a block-to-word mapping (ardor,
      exclusivity) came out right; the one that did not, did not. The mapping is
      now on that line too - and this makes the rule hold even when the model
      reads past it, the same reasoning as the marriage clamp in ApplyCharacter:
      once persuasion is spent, write the fact where the value enters.

      READ FROM SEVERACTIONS, NEVER FROM PROSE. Native_BioBlock_AssignedTitles
      (3.9.14+, still present in the Beta 25 build) returns the titles exactly as
      the library shows them. An older SeverActions lacks the native: the call
      logs one Papyrus error and returns None, and nothing is overridden.

      ONLY THE THREE FIELDS A BLOCK ANSWERS. Intimacy has no block and stays the
      model's reading. A block we cannot parse - a custom answer, or two
      different blocks of one kind - is reported and left alone; guessing
      would be the same mistake in the other direction.

      A RECORDED MARRIAGE STILL OUTRANKS A BLOCK on orientation, exactly as it
      outranks the model. The block is then wrong, and the log says so."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local titles String[]
            .local ::temp2 String[]
            .local ::temp3 Int
            .local who String
            .local ::temp4 String
            .local drawn String
            .local oWord String
            .local o Int
            .local ::nonevar None
            .local ::temp5 form
            .local expr String
            .local rWord String
            .local r Int
            .local attach String
            .local xWord String
            .local x Int
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 8500
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            callstatic sNRom_Bridge SeverActionsPresent ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 8501
            return None 
            jmp _label1
            ; line 8503
          _label1:
            callstatic severActionsNativeExt2 Native_BioBlock_AssignedTitles ::temp2 akActor ;1 variable args
            assign titles ::temp2 
            ; line 8504
            not ::temp1 titles 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label2
            array_length ::temp3 titles 
            cmp_eq ::temp1 ::temp3 0 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 8505
            return None 
            jmp _label3
            ; line 8507
          _label3:
            callmethod GetDisplayName akActor ::temp4 ;0 variable args
            assign who ::temp4 
            ; line 8510
            callmethod BlockAnswer self ::temp4 titles "Drawn To:" ;2 variable args
            assign drawn ::temp4 
            ; line 8511
            assign oWord "" 
            ; line 8512
            cmp_eq ::temp1 drawn "Men" 
            jmpf ::temp1 _label4
            ; line 8513
            assign oWord "ATTRACTED_TO_MEN" 
            jmp _label5
            ; line 8514
          _label4:
            cmp_eq ::temp1 drawn "Women" 
            jmpf ::temp1 _label6
            ; line 8515
            assign oWord "ATTRACTED_TO_WOMEN" 
            jmp _label5
            ; line 8516
          _label6:
            cmp_eq ::temp1 drawn "Both" 
            jmpf ::temp1 _label7
            ; line 8517
            assign oWord "ATTRACTED_TO_BOTH" 
            jmp _label5
            ; line 8518
          _label7:
            cmp_eq ::temp1 drawn "No One" 
            jmpf ::temp1 _label5
            ; line 8519
            assign oWord "ATTRACTED_TO_NEITHER" 
            jmp _label5
            ; line 8521
          _label5:
            cmp_eq ::temp1 oWord "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label8
            ; line 8522
            callstatic sNRom_Decorators OrientationToInt ::temp3 oWord ;1 variable args
            assign o ::temp3 
            ; line 8523
            callstatic sNRom_Bridge IsMarriedToPlayer ::temp1 akActor ;1 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label9
            callstatic sNRom_Bridge OrientationExcludesPlayer ::temp1 o ;1 variable args
            assign ::temp1 ::temp1 
          _label9:
            jmpf ::temp1 _label10
            ; line 8524
            callstatic sNRom_Bridge LOG_WARN ::temp3 ;0 variable args
            strcat ::temp4 "Block 'Drawn To: " drawn 
            strcat ::temp4 ::temp4 "' NOT applied to " 
            strcat ::temp4 ::temp4 who 
            strcat ::temp4 ::temp4 " - the game records a marriage to the player, which the block contradicts. Fix the block." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
            jmp _label11
            ; line 8526
          _label10:
            cast ::temp5 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp5 "SNRom_Orientation" 3 ;3 variable args
            cmp_eq ::temp1 ::temp3 o 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label12
            ; line 8527
            cast ::temp5 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp5 "SNRom_OrientationKnown" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label12:
            jmpf ::temp1 _label11
            ; line 8528
            cast ::temp5 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp5 "SNRom_Orientation" o ;3 variable args
            ; line 8529
            cast ::temp5 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp5 "SNRom_OrientationKnown" 2 ;3 variable args
            ; line 8530
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp4 "BLOCK OVERRIDE for " who 
            strcat ::temp4 ::temp4 ": orientation -> " 
            strcat ::temp4 ::temp4 oWord 
            strcat ::temp4 ::temp4 " / STATED, from the applied block 'Drawn To: " 
            ; line 8531
            strcat ::temp4 ::temp4 drawn 
            strcat ::temp4 ::temp4 "'." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
            jmp _label11
          _label11:
            jmp _label13
            ; line 8533
          _label8:
            cmp_eq ::temp1 drawn "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label13
            ; line 8534
            callstatic sNRom_Bridge LOG_WARN ::temp3 ;0 variable args
            strcat ::temp4 "Block 'Drawn To: " drawn 
            strcat ::temp4 ::temp4 "' on " 
            strcat ::temp4 ::temp4 who 
            strcat ::temp4 ::temp4 " is not one of the library's answers (or two disagree) - orientation left as authored." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
            jmp _label13
            ; line 8539
          _label13:
            callmethod BlockAnswer self ::temp4 titles "Expression:" ;2 variable args
            assign expr ::temp4 
            ; line 8540
            assign rWord "" 
            ; line 8541
            cmp_eq ::temp1 expr "Reserved and Undemonstrative" 
            jmpf ::temp1 _label14
            ; line 8542
            assign rWord "RESERVED" 
            jmp _label15
            ; line 8543
          _label14:
            cmp_eq ::temp1 expr "Measured, Shows Little" 
            jmpf ::temp1 _label16
            ; line 8544
            assign rWord "MEASURED" 
            jmp _label15
            ; line 8545
          _label16:
            cmp_eq ::temp1 expr "Warm but Not Effusive" 
            jmpf ::temp1 _label17
            ; line 8546
            assign rWord "WARM" 
            jmp _label15
            ; line 8547
          _label17:
            cmp_eq ::temp1 expr "Open About What They Feel" 
            jmpf ::temp1 _label18
            ; line 8548
            assign rWord "OPEN" 
            jmp _label15
            ; line 8549
          _label18:
            cmp_eq ::temp1 expr "Intense and Unmistakable" 
            jmpf ::temp1 _label15
            ; line 8550
            assign rWord "INTENSE" 
            jmp _label15
            ; line 8552
          _label15:
            cmp_eq ::temp1 rWord "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label19
            ; line 8553
            callstatic sNRom_Decorators ArdorToInt ::temp3 rWord ;1 variable args
            assign r ::temp3 
            ; line 8554
            cast ::temp5 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp5 "SNRom_Ardor" 2 ;3 variable args
            cmp_eq ::temp1 ::temp3 r 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label20
            ; line 8555
            cast ::temp5 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp5 "SNRom_Ardor" r ;3 variable args
            ; line 8556
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp4 "BLOCK OVERRIDE for " who 
            strcat ::temp4 ::temp4 ": ardor -> " 
            strcat ::temp4 ::temp4 rWord 
            strcat ::temp4 ::temp4 ", from the applied block 'Expression: " 
            ; line 8557
            strcat ::temp4 ::temp4 expr 
            strcat ::temp4 ::temp4 "'." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
            jmp _label20
          _label20:
            jmp _label21
            ; line 8559
          _label19:
            cmp_eq ::temp1 expr "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label21
            ; line 8560
            callstatic sNRom_Bridge LOG_WARN ::temp3 ;0 variable args
            strcat ::temp4 "Block 'Expression: " expr 
            strcat ::temp4 ::temp4 "' on " 
            strcat ::temp4 ::temp4 who 
            strcat ::temp4 ::temp4 " is not one of the library's answers (or two disagree) - ardor left as authored." 
            callmethod Diag self ::nonevar ::temp3 ::temp4 False ;3 variable args
            jmp _label21
            ; line 8565
          _label21:
            callmethod BlockAnswer self ::temp4 titles "Attachment:" ;2 variable args
            assign attach ::temp4 
            ; line 8566
            assign xWord "" 
            ; line 8567
            cmp_eq ::temp1 attach "Untroubled by Others" 
            jmpf ::temp1 _label22
            ; line 8568
            assign xWord "UNTROUBLED" 
            jmp _label23
            ; line 8569
          _label22:
            cmp_eq ::temp1 attach "Accepts Others Easily" 
            jmpf ::temp1 _label24
            ; line 8570
            assign xWord "ACCEPTING" 
            jmp _label23
            ; line 8571
          _label24:
            cmp_eq ::temp1 attach "Expects the Usual Arrangement" 
            jmpf ::temp1 _label25
            ; line 8572
            assign xWord "CONVENTIONAL" 
            jmp _label23
            ; line 8573
          _label25:
            cmp_eq ::temp1 attach "Needs to Be the Only One" 
            jmpf ::temp1 _label26
            ; line 8574
            assign xWord "POSSESSIVE" 
            jmp _label23
            ; line 8575
          _label26:
            cmp_eq ::temp1 attach "Cannot Share at All" 
            jmpf ::temp1 _label23
            ; line 8576
            assign xWord "CONSUMING" 
            jmp _label23
            ; line 8578
          _label23:
            cmp_eq ::temp1 xWord "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label27
            ; line 8579
            callstatic sNRom_Decorators ExclusivityToInt ::temp3 xWord ;1 variable args
            assign x ::temp3 
            ; line 8580
            cast ::temp5 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp5 "SNRom_Exclusivity" 50 ;3 variable args
            cmp_eq ::temp1 ::temp3 x 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label28
            ; line 8581
            cast ::temp5 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp5 "SNRom_Exclusivity" x ;3 variable args
            ; line 8582
            callstatic sNRom_Bridge LOG_INFO ::temp3 ;0 variable args
            strcat ::temp4 "BLOCK OVERRIDE for " who 
            strcat ::temp4 ::temp4 ": exclusivity -> " 
            strcat ::temp4 ::temp4 xWord 
            strcat ::temp4 ::temp4 " (" 
            cast ::temp6 x 
            strcat ::temp6 ::temp4 ::temp6 
            strcat ::temp6 ::temp6 "), from the applied block 'Attachment: " 
            ; line 8583
            strcat ::temp6 ::temp6 attach 
            strcat ::temp6 ::temp6 "'." 
            callmethod Diag self ::nonevar ::temp3 ::temp6 False ;3 variable args
            jmp _label28
          _label28:
            jmp _label29
            ; line 8585
          _label27:
            cmp_eq ::temp1 attach "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label29
            ; line 8586
            callstatic sNRom_Bridge LOG_WARN ::temp3 ;0 variable args
            strcat ::temp6 "Block 'Attachment: " attach 
            strcat ::temp6 ::temp6 "' on " 
            strcat ::temp6 ::temp6 who 
            strcat ::temp6 ::temp6 " is not one of the library's answers (or two disagree) - exclusivity left as authored." 
            callmethod Diag self ::nonevar ::temp3 ::temp6 False ;3 variable args
            jmp _label29
          _label29
          .endCode
        .endFunction ;EnforceBlockAnswers
        .function BlockAnswer
           ; function type 0
          .userFlags 0 ;none
          .docString "The answer half of the applied block whose title starts with asPrefix -
      "Both" from "Drawn To: Both". "" when none is applied; "?" when two
      DIFFERENT ones are, a contradiction to report rather than resolve by
      picking one. Strips the " (2)" suffix SeverActions' import adds when a
      title already existed. Papyrus == ignores case, so callers match the
      library's wording as written."
          .return String
          .paramTable
            .param akTitles String[]
            .param asPrefix String
          .endParamTable
          .localTable
            .local found String
            .local plen Int
            .local ::temp0 Int
            .local i Int
            .local ::temp1 Bool
            .local t String
            .local ::temp2 String
            .local v String
            .local cut Int
          .endLocalTable
          .code
            ; line 8598
            assign found "" 
            ; line 8599
            callstatic stringUtil GetLength ::temp0 asPrefix ;1 variable args
            assign plen ::temp0 
            ; line 8600
            assign i 0 
            ; line 8601
          _label6:
            array_length ::temp0 akTitles 
            cmp_lt ::temp1 i ::temp0 
            jmpf ::temp1 _label0
            ; line 8602
            array_getlement ::temp2 akTitles i 
            callstatic sNRom_Decorators Trim ::temp2 ::temp2 ;1 variable args
            assign t ::temp2 
            ; line 8603
            callstatic stringUtil Find ::temp0 t asPrefix 0 ;3 variable args
            cmp_eq ::temp1 ::temp0 0 
            jmpf ::temp1 _label1
            ; line 8604
            callstatic stringUtil Substring ::temp2 t plen 0 ;3 variable args
            callstatic sNRom_Decorators Trim ::temp2 ::temp2 ;1 variable args
            assign v ::temp2 
            ; line 8605
            callstatic stringUtil Find ::temp0 v " (" 0 ;3 variable args
            assign cut ::temp0 
            ; line 8606
            cmp_gt ::temp1 cut 0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            callstatic stringUtil GetLength ::temp0 v ;1 variable args
            isub ::temp0 ::temp0 1 
            callstatic stringUtil GetNthChar ::temp2 v ::temp0 ;2 variable args
            cmp_eq ::temp1 ::temp2 ")" 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 8607
            callstatic stringUtil Substring ::temp2 v 0 cut ;3 variable args
            callstatic sNRom_Decorators Trim ::temp2 ::temp2 ;1 variable args
            assign v ::temp2 
            jmp _label3
            ; line 8609
          _label3:
            cmp_eq ::temp1 found "" 
            jmpf ::temp1 _label4
            ; line 8610
            assign found v 
            jmp _label5
            ; line 8611
          _label4:
            cmp_eq ::temp1 found v 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label5
            ; line 8612
            return "?" 
            jmp _label5
          _label5:
            jmp _label1
            ; line 8615
          _label1:
            iadd ::temp0 i 1 
            assign i ::temp0 
            jmp _label6
            ; line 8617
          _label0:
            return found 
          .endCode
        .endFunction ;BlockAnswer
        .function ApplyArchetype
           ; function type 0
          .userFlags 0 ;none
          .docString "The fallback when authoring fails: the character fields keep their
      defaults, and SNRom_DispositionAuthored 2 marks the actor for a real
      authoring at the next chance (AuthorDisposition retries 2).

      1.x wrote two archetype preferences into Romantasy here. From 2.0 there
      is nothing to write - which also fixes what the marker did to someone
      ALREADY authored: a failed re-author set them to 2, "archetype", when
      their authored character was intact. Only someone never authored is
      marked now."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local ::temp1 form
            .local ::temp2 Int
            .local ::temp3 Bool
          .endLocalTable
          .code
            ; line 8638
            callmethod GetDisplayName akActor ::temp0 ;0 variable args
            strcat ::temp0 ::temp0 " could not be re-authored - the read failed. Their character is unchanged; try again." 
            callmethod AnnounceAuthored self ::nonevar akActor ::temp0 ;2 variable args
            ; line 8639
            cast ::temp1 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp1 "SNRom_DispositionAuthored" 0 ;3 variable args
            cmp_eq ::temp3 ::temp2 0 
            jmpf ::temp3 _label0
            ; line 8640
            cast ::temp1 akActor 
            callstatic storageUtil SetIntValue ::temp2 ::temp1 "SNRom_DispositionAuthored" 2 ;3 variable args
            ; line 8641
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp0 ;0 variable args
            strcat ::temp0 "Archetype disposition applied to " ::temp0 
            callmethod Diag self ::nonevar ::temp2 ::temp0 False ;3 variable args
            jmp _label1
            ; line 8643
          _label0:
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            callmethod GetDisplayName akActor ::temp0 ;0 variable args
            strcat ::temp0 "Authoring failed for " ::temp0 
            strcat ::temp0 ::temp0 " - their existing character is kept" 
            callmethod Diag self ::nonevar ::temp2 ::temp0 False ;3 variable args
          _label1
          .endCode
        .endFunction ;ApplyArchetype
        .function LogDisposition
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param asName String
            .param aiSuccess Int
            .param asRaw String
            .param asOutcome String
          .endParamTable
          .localTable
            .local row String
            .local ::temp0 String
            .local ::temp1 Float
            .local ::temp2 String
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 8649
            callstatic sNRom_Bridge Escape ::temp0 asName ;1 variable args
            strcat ::temp0 "{\"npc\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 ::temp0 ",\"gd\":" 
            ; line 8650
            callstatic utility GetCurrentGameTime ::temp1 ;0 variable args
            cast ::temp2 ::temp1 
            strcat ::temp2 ::temp0 ::temp2 
            strcat ::temp2 ::temp2 ",\"success\":" 
            ; line 8651
            cast ::temp0 aiSuccess 
            strcat ::temp0 ::temp2 ::temp0 
            strcat ::temp0 ::temp0 ",\"outcome\":\"" 
            ; line 8652
            strcat ::temp0 ::temp0 asOutcome 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 ::temp0 ",\"raw\":\"" 
            ; line 8653
            callstatic sNRom_Decorators JsonEscape ::temp2 asRaw ;1 variable args
            strcat ::temp2 ::temp0 ::temp2 
            strcat ::temp2 ::temp2 "\"}" 
            assign row ::temp2 
            ; line 8654
            callstatic sNRom_Bridge NL ::temp2 ;0 variable args
            strcat ::temp2 row ::temp2 
            callmethod WriteLog self ::nonevar "dispositions.jsonl" "Data/SKSE/Plugins/SkyrimNet Relationships/logs/dispositions.jsonl" ::temp2 ;3 variable args
          .endCode
        .endFunction ;LogDisposition
        .function TestConfig
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 Int
            .local ::temp1 String
            .local ::temp2 Int
            .local ::temp3 Bool
          .endLocalTable
          .code
            ; line 8677
            callstatic sNRom_Bridge LOG_ERROR ::temp0 ;0 variable args
            callstatic sNRom_Bridge CFG ::temp1 ;0 variable args
            callstatic skyrimNetApi GetConfigString ::temp1 ::temp1 "llmVariant" "SENTINEL" ;3 variable args
            strcat ::temp1 "CFG str  llmVariant='" ::temp1 
            strcat ::temp1 ::temp1 "' (settings.yaml: sever_background)" 
            callmethod Diag self ::nonevar ::temp0 ::temp1 False ;3 variable args
            ; line 8678
            callstatic sNRom_Bridge LOG_ERROR ::temp0 ;0 variable args
            callstatic sNRom_Bridge CFG ::temp1 ;0 variable args
            callstatic skyrimNetApi GetConfigInt ::temp2 ::temp1 "awardMaxPoints" -999 ;3 variable args
            cast ::temp1 ::temp2 
            strcat ::temp1 "CFG int  awardMaxPoints=" ::temp1 
            strcat ::temp1 ::temp1 " (settings.yaml: 75)" 
            callmethod Diag self ::nonevar ::temp0 ::temp1 False ;3 variable args
            ; line 8679
            callstatic sNRom_Bridge LOG_ERROR ::temp0 ;0 variable args
            callstatic sNRom_Bridge CFG ::temp1 ;0 variable args
            callstatic skyrimNetApi GetConfigInt ::temp2 ::temp1 "logFlushEvery" -999 ;3 variable args
            cast ::temp1 ::temp2 
            strcat ::temp1 "CFG int  logFlushEvery=" ::temp1 
            strcat ::temp1 ::temp1 " (settings.yaml: 25)" 
            callmethod Diag self ::nonevar ::temp0 ::temp1 False ;3 variable args
            ; line 8680
            callstatic sNRom_Bridge LOG_ERROR ::temp0 ;0 variable args
            callstatic sNRom_Bridge CFG ::temp1 ;0 variable args
            callstatic skyrimNetApi GetConfigBool ::temp3 ::temp1 "enrollmentOrganic" False ;3 variable args
            cast ::temp1 ::temp3 
            strcat ::temp1 "CFG bool enrollmentOrganic=" ::temp1 
            strcat ::temp1 ::temp1 " (settings.yaml: true)" 
            callmethod Diag self ::nonevar ::temp0 ::temp1 False ;3 variable args
          .endCode
        .endFunction ;TestConfig
        .function IEB_LockChildIntimacy
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch R5: for a child, intimacy is forced to NEVER on every write, whatever was asked. True if locked."
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
            ; line 8698
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            callmethod IsChild akActor ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 8699
            return False 
            jmp _label1
            ; line 8701
          _label1:
            cast ::temp2 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_PhysMinTier" -1 ;3 variable args
            ; line 8702
            cast ::temp2 akActor 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "SNRom_PhysAttrBypass" 0 ;3 variable args
            ; line 8703
            return True 
          .endCode
        .endFunction ;IEB_LockChildIntimacy
        .function IEB_ChildSweep
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch R7: every enrolled child, every sweep: re-lock intimacy, spark decided, un-spark if sparked,
      clear stance, banked points and the pending question. Corrects console or third-party writes within
      one sweep. No un-enrolling."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local total Int
            .local ::temp0 form
            .local ::temp1 Int
            .local fixedCount Int
            .local i Int
            .local ::temp2 Bool
            .local a actor
            .local ::temp3 actor
            .local ::nonevar None
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 8710
            cast ::temp0 None 
            callstatic storageUtil FormListCount ::temp1 ::temp0 "SNRom_Roster" ;2 variable args
            assign total ::temp1 
            ; line 8711
            assign fixedCount 0 
            ; line 8712
            assign i 0 
            ; line 8713
          _label5:
            cmp_lt ::temp2 i total 
            jmpf ::temp2 _label0
            ; line 8714
            cast ::temp0 None 
            callstatic storageUtil FormListGet ::temp0 ::temp0 "SNRom_Roster" i ;3 variable args
            cast ::temp3 ::temp0 
            assign a ::temp3 
            ; line 8715
            cast ::temp3 None 
            cmp_eq ::temp2 a ::temp3 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label1
            callmethod IsChild a ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
          _label1:
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label2
            callstatic sNRom_Bridge IsEnrolled ::temp2 a ;1 variable args
            assign ::temp2 ::temp2 
          _label2:
            jmpf ::temp2 _label3
            ; line 8716
            callmethod IEB_LockChildIntimacy self ::temp2 a ;1 variable args
            ; line 8717
            cast ::temp0 a 
            callstatic storageUtil SetIntValue ::temp1 ::temp0 "SNRom_SparkDecided" 1 ;3 variable args
            ; line 8718
            cast ::temp0 a 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_Sparked" 0 ;3 variable args
            cmp_eq ::temp2 ::temp1 1 
            jmpf ::temp2 _label4
            ; line 8719
            callmethod UnsparkActor self ::nonevar a ;1 variable args
            ; line 8720
            iadd ::temp1 fixedCount 1 
            assign fixedCount ::temp1 
            jmp _label4
            ; line 8722
          _label4:
            cast ::temp0 a 
            callstatic storageUtil UnsetIntValue ::temp2 ::temp0 "SNRom_PlayerStance" ;2 variable args
            ; line 8723
            cast ::temp0 a 
            callstatic storageUtil UnsetIntValue ::temp2 ::temp0 "SNRom_BankedPoints" ;2 variable args
            ; line 8724
            cast ::temp0 a 
            callstatic storageUtil UnsetIntValue ::temp2 ::temp0 "SNRom_AskPending" ;2 variable args
            jmp _label3
            ; line 8726
          _label3:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label5
            ; line 8728
          _label0:
            cmp_gt ::temp2 fixedCount 0 
            jmpf ::temp2 _label6
            ; line 8729
            callstatic sNRom_Bridge LOG_WARN ::temp1 ;0 variable args
            cast ::temp4 fixedCount 
            strcat ::temp4 "Child sweep: un-sparked " ::temp4 
            strcat ::temp4 ::temp4 " enrolled child(ren); intimacy locked (IsChild)" 
            callmethod Diag self ::nonevar ::temp1 ::temp4 False ;3 variable args
            jmp _label6
          _label6
          .endCode
        .endFunction ;IEB_ChildSweep
        .function IEB_CountMarasPartners
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch M2: MARAS actors with this status who are alive and not already counted as an acknowledged
      Relationships partner (sparked + accepted), so the union has no duplicates."
          .return Int
          .paramTable
            .param asStatus String
          .endParamTable
          .localTable
            .local arr actor[]
            .local ::temp0 actor[]
            .local n Int
            .local i Int
            .local ::temp1 Int
            .local ::temp2 Bool
            .local a actor
            .local ::temp3 actor
            .local ::temp4 form
            .local ::temp5 Int
          .endLocalTable
          .code
            ; line 8740
            callstatic mARAS GetNPCsByStatus ::temp0 asStatus ;1 variable args
            assign arr ::temp0 
            ; line 8741
            assign n 0 
            ; line 8742
            assign i 0 
            ; line 8743
          _label5:
            array_length ::temp1 arr 
            cmp_lt ::temp2 i ::temp1 
            jmpf ::temp2 _label0
            ; line 8744
            array_getlement ::temp3 arr i 
            assign a ::temp3 
            ; line 8745
            cast ::temp3 None 
            cmp_eq ::temp2 a ::temp3 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label1
            callmethod IsDead a ::temp2 ;0 variable args
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 8746
            callstatic sNRom_Decorators IsSparked ::temp2 a ;1 variable args
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label3
            cast ::temp4 a 
            callstatic storageUtil GetIntValue ::temp1 ::temp4 "SNRom_PlayerStance" 0 ;3 variable args
            callstatic sNRom_Bridge STANCE_ACCEPTED ::temp5 ;0 variable args
            cmp_eq ::temp2 ::temp1 ::temp5 
            assign ::temp2 ::temp2 
          _label3:
            not ::temp2 ::temp2 
            jmpf ::temp2 _label4
            ; line 8747
            iadd ::temp5 n 1 
            assign n ::temp5 
            jmp _label4
          _label4:
            jmp _label2
            ; line 8750
          _label2:
            iadd ::temp5 i 1 
            assign i ::temp5 
            jmp _label5
            ; line 8752
          _label0:
            return n 
          .endCode
        .endFunction ;IEB_CountMarasPartners
        .function IEB_EnrollOnCourtship
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch M4': the same checks EnrollByHand makes, plus never a child. Idempotent through IsEnrolled."
          .return Bool
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 8757
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            callstatic game GetPlayer ::temp0 ;0 variable args
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
          _label0:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            callstatic sNRom_Bridge IsEnrolled ::temp1 akActor ;1 variable args
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 8758
            return False 
            jmp _label2
            ; line 8760
          _label2:
            callmethod IsChild akActor ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label3
            callmethod IsDead akActor ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label3:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label4
            callmethod IsCommandedActor akActor ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label4:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label5
            callmethod IsPerson self ::temp1 akActor ;1 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label5:
            jmpf ::temp1 _label6
            ; line 8761
            return False 
            jmp _label6
            ; line 8763
          _label6:
            callmethod EnrollNow self ::nonevar akActor "Enrolled on MARAS courtship:" ;2 variable args
            ; line 8764
            return True 
          .endCode
        .endFunction ;IEB_EnrollOnCourtship
        .function IEB_MarasCatchUp
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch M4': each sweep enrolls at most 2 MARAS candidates, fiancés or spouses who are missing,
      covering courtships begun before the patch or events lost at load."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local budget Int
            .local statuses String[]
            .local ::temp1 String[]
            .local s Int
            .local arr actor[]
            .local ::temp2 String
            .local ::temp3 actor[]
            .local i Int
            .local ::temp4 Int
            .local ::temp5 actor
          .endLocalTable
          .code
            ; line 8770
            callstatic sNRom_Bridge MarasPresent ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 8771
            return None 
            jmp _label0
            ; line 8773
          _label0:
            assign budget 2 
            ; line 8774
            array_create ::temp1 3 
            assign statuses ::temp1 
            ; line 8775
            array_setelement statuses 0 "married" 
            ; line 8776
            array_setelement statuses 1 "engaged" 
            ; line 8777
            array_setelement statuses 2 "candidate" 
            ; line 8778
            assign s 0 
            ; line 8779
          _label7:
            cmp_lt ::temp0 s 3 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label1
            cmp_gt ::temp0 budget 0 
            assign ::temp0 ::temp0 
          _label1:
            jmpf ::temp0 _label2
            ; line 8780
            array_getlement ::temp2 statuses s 
            callstatic mARAS GetNPCsByStatus ::temp3 ::temp2 ;1 variable args
            assign arr ::temp3 
            ; line 8781
            assign i 0 
            ; line 8782
          _label6:
            array_length ::temp4 arr 
            cmp_lt ::temp0 i ::temp4 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            cmp_gt ::temp0 budget 0 
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 8783
            array_getlement ::temp5 arr i 
            callmethod IEB_EnrollOnCourtship self ::temp0 ::temp5 ;1 variable args
            jmpf ::temp0 _label5
            ; line 8784
            isub ::temp4 budget 1 
            assign budget ::temp4 
            jmp _label5
            ; line 8786
          _label5:
            iadd ::temp4 i 1 
            assign i ::temp4 
            jmp _label6
            ; line 8788
          _label4:
            iadd ::temp4 s 1 
            assign s ::temp4 
            jmp _label7
          _label2
          .endCode
        .endFunction ;IEB_MarasCatchUp
        .function IEB_WriteRomTrack
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch: StorageUtil IEB_RomTrack, 1 = romantic, 0 = friendship, by ShownTierName's rule:
      RomanceApplicability == 0 and (sparked with an accepted stance, or CommitmentState >= 2).
      Read by IEB_RankSync.Apply (Errand Bridge)."
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local t Int
            .local ::temp2 Int
            .local ::temp3 form
            .local ::temp4 Int
          .endLocalTable
          .code
            ; line 8800
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 8801
            return None 
            jmp _label0
            ; line 8803
          _label0:
            assign t 0 
            ; line 8804
            callstatic sNRom_Decorators RomanceApplicability ::temp2 akActor -1 ;2 variable args
            cmp_eq ::temp1 ::temp2 0 
            jmpf ::temp1 _label1
            ; line 8805
            callstatic sNRom_Decorators IsSparked ::temp1 akActor ;1 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 8806
            cast ::temp3 akActor 
            callstatic storageUtil GetIntValue ::temp2 ::temp3 "SNRom_PlayerStance" 0 ;3 variable args
            callstatic sNRom_Bridge STANCE_ACCEPTED ::temp4 ;0 variable args
            cmp_eq ::temp1 ::temp2 ::temp4 
            assign ::temp1 ::temp1 
          _label2:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label3
            ; line 8807
            callstatic sNRom_Bridge CommitmentState ::temp4 akActor ;1 variable args
            comp_gte ::temp1 ::temp4 2 
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 8808
            assign t 1 
            jmp _label4
          _label4:
            jmp _label1
            ; line 8811
          _label1:
            cast ::temp3 akActor 
            callstatic storageUtil SetIntValue ::temp4 ::temp3 "IEB_RomTrack" t ;3 variable args
          .endCode
        .endFunction ;IEB_WriteRomTrack
        .function IEB_IntimacyWanted
           ; function type 0
          .userFlags 0 ;none
          .docString "An adult, enrolled, already-authored NPC whose romance applies to this player, whose intimacy is not
      NEVER, and who has no profile yet (or is forced)."
          .return Bool
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 8823
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            callmethod IsChild akActor ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label0:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            callmethod IsDead akActor ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label1:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label2
            callstatic sNRom_Bridge IsEnrolled ::temp1 akActor ;1 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 8824
            return False 
            jmp _label3
            ; line 8826
          _label3:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_DispositionAuthored" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label4
            ; line 8827
            return False 
            jmp _label4
            ; line 8829
          _label4:
            callstatic sNRom_Decorators RomanceApplicability ::temp3 akActor -1 ;2 variable args
            cmp_eq ::temp1 ::temp3 0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label5
            ; line 8830
            return False 
            jmp _label5
            ; line 8832
          _label5:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "SNRom_PhysMinTier" 4 ;3 variable args
            cmp_lt ::temp1 ::temp3 0 
            jmpf ::temp1 _label6
            ; line 8833
            return False 
            jmp _label6
            ; line 8835
          _label6:
            cast ::temp2 akActor 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "IEB_ForceIntimacyAuthor" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            jmpf ::temp1 _label7
            ; line 8836
            return True 
            jmp _label7
            ; line 8838
          _label7:
            callstatic sNRom_Bridge StoreGetText ::temp4 akActor "Intimacy" "" 0 ;4 variable args
            cmp_eq ::temp1 ::temp4 "" 
            return ::temp1 
          .endCode
        .endFunction ;IEB_IntimacyWanted
        .function IEB_QueueIntimacy
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 form
            .local ::temp2 form
            .local ::temp3 Int
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 8842
            not ::temp0 _ready 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            callmethod IEB_IntimacyWanted self ::temp0 akActor ;1 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 8843
            return None 
            jmp _label1
            ; line 8845
          _label1:
            cast ::temp1 None 
            cast ::temp2 akActor 
            callstatic storageUtil FormListAdd ::temp3 ::temp1 "IEB_IntimacyQueue" ::temp2 False ;4 variable args
            ; line 8846
            callmethod IEB_PumpIntimacy self ::nonevar ;0 variable args
          .endCode
        .endFunction ;IEB_QueueIntimacy
        .function IEB_PumpIntimacy
           ; function type 0
          .userFlags 0 ;none
          .docString "One call in flight at a time. Re-checks IsChild and every condition on dequeue."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local next actor
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 8851
            cast ::temp0 None 
            cmp_eq ::temp1 _pendingIntimacy ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label0
            ; line 8852
            return None 
            jmp _label0
            ; line 8854
          _label0:
            cast ::temp2 None 
            callstatic storageUtil FormListCount ::temp3 ::temp2 "IEB_IntimacyQueue" ;2 variable args
            cmp_gt ::temp1 ::temp3 0 
            jmpf ::temp1 _label1
            ; line 8855
            cast ::temp2 None 
            callstatic storageUtil FormListGet ::temp2 ::temp2 "IEB_IntimacyQueue" 0 ;3 variable args
            cast ::temp0 ::temp2 
            assign next ::temp0 
            ; line 8856
            cast ::temp2 None 
            callstatic storageUtil FormListRemoveAt ::temp1 ::temp2 "IEB_IntimacyQueue" 0 ;3 variable args
            ; line 8857
            cast ::temp0 None 
            cmp_eq ::temp1 next ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            callmethod IsChild next ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label2:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label3
            callmethod IEB_IntimacyWanted self ::temp1 next ;1 variable args
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 8858
            callmethod IEB_SendIntimacy self ::nonevar next ;1 variable args
            ; line 8859
            return None 
            jmp _label4
          _label4:
            jmp _label0
          _label1
          .endCode
        .endFunction ;IEB_PumpIntimacy
        .function IEB_SendIntimacy
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local minTier Int
            .local ::temp0 form
            .local ::temp1 Int
            .local ctx String
            .local ::temp2 String
            .local ::temp3 String
            .local rc Int
            .local ::temp4 quest
            .local ::nonevar None
            .local ::temp5 Bool
            .local ::temp6 actor
          .endLocalTable
          .code
            ; line 8865
            cast ::temp0 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_PhysMinTier" 4 ;3 variable args
            assign minTier ::temp1 
            ; line 8866
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            callstatic sNRom_Decorators JsonEscape ::temp2 ::temp2 ;1 variable args
            strcat ::temp2 "{\"npc_name\":\"" ::temp2 
            strcat ::temp2 ::temp2 "\"" 
            strcat ::temp2 ::temp2 ",\"npc_formid\":" 
            ; line 8867
            callmethod GetFormID akActor ::temp1 ;0 variable args
            cast ::temp3 ::temp1 
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 ",\"disp_orientation\":\"" 
            ; line 8868
            callstatic sNRom_Decorators OrientationWord ::temp2 akActor ;1 variable args
            strcat ::temp2 ::temp3 ::temp2 
            strcat ::temp2 ::temp2 "\"" 
            strcat ::temp2 ::temp2 ",\"disp_intimacy\":\"" 
            ; line 8869
            callstatic sNRom_Decorators IntimacyWordFromTier ::temp3 minTier ;1 variable args
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 "\"" 
            strcat ::temp3 ::temp3 ",\"disp_ardor\":\"" 
            ; line 8870
            cast ::temp0 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_Ardor" 2 ;3 variable args
            callstatic sNRom_Decorators ArdorWord ::temp2 ::temp1 ;1 variable args
            strcat ::temp2 ::temp3 ::temp2 
            strcat ::temp2 ::temp2 "\"" 
            strcat ::temp2 ::temp2 ",\"disp_exclusivity\":" 
            ; line 8871
            cast ::temp0 akActor 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "SNRom_Exclusivity" 50 ;3 variable args
            cast ::temp3 ::temp1 
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 ",\"disp_why\":\"" 
            ; line 8872
            callstatic sNRom_Bridge StoreGetText ::temp2 akActor "Why" "" 0 ;4 variable args
            callstatic sNRom_Decorators JsonEscape ::temp2 ::temp2 ;1 variable args
            strcat ::temp2 ::temp3 ::temp2 
            strcat ::temp2 ::temp2 "\"" 
            strcat ::temp2 ::temp2 ",\"disp_limit\":\"" 
            ; line 8873
            callstatic sNRom_Bridge StoreGetText ::temp3 akActor "Limit" "" 0 ;4 variable args
            callstatic sNRom_Decorators JsonEscape ::temp3 ::temp3 ;1 variable args
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 "\"}" 
            assign ctx ::temp3 
            ; line 8874
            assign _pendingIntimacy akActor 
            ; line 8876
            cast ::temp4 self 
            callstatic skyrimNetApi SendCustomPromptToLLM ::temp1 "ieb_intimacy_author" "ieb_intimacy_author" ctx ::temp4 "SNRom_Bridge" "IEB_OnIntimacyAuthored" ;6 variable args
            assign rc ::temp1 
            ; line 8877
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            callmethod GetDisplayName akActor ::temp3 ;0 variable args
            strcat ::temp3 "Intimacy profile requested for " ::temp3 
            strcat ::temp3 ::temp3 " (rc=" 
            cast ::temp2 rc 
            strcat ::temp2 ::temp3 ::temp2 
            strcat ::temp2 ::temp2 ")" 
            callmethod Diag self ::nonevar ::temp1 ::temp2 False ;3 variable args
            ; line 8878
            cmp_eq ::temp5 rc 1 
            not ::temp5 ::temp5 
            jmpf ::temp5 _label0
            ; line 8879
            cast ::temp6 None 
            assign _pendingIntimacy ::temp6 
            jmp _label0
          _label0
          .endCode
        .endFunction ;IEB_SendIntimacy
        .function IEB_OnIntimacyAuthored
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param asResponse String
            .param aiSuccess Int
          .endParamTable
          .localTable
            .local who actor
            .local ::temp0 actor
            .local len Int
            .local ::temp1 Int
            .local ::temp2 Bool
            .local ::nonevar None
            .local ::temp3 String
            .local ::temp4 String
            .local ::temp5 form
          .endLocalTable
          .code
            ; line 8884
            assign who _pendingIntimacy 
            ; line 8885
            cast ::temp0 None 
            assign _pendingIntimacy ::temp0 
            ; line 8886
            callstatic stringUtil GetLength ::temp1 asResponse ;1 variable args
            assign len ::temp1 
            ; line 8887
            cast ::temp0 None 
            cmp_eq ::temp2 who ::temp0 
            jmpf ::temp2 _label0
            ; line 8888
            return None 
            jmp _label0
            ; line 8890
          _label0:
            cmp_eq ::temp2 aiSuccess 1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label1
            cmp_lt ::temp2 len 200 
            assign ::temp2 ::temp2 
          _label1:
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label2
            callmethod IsChild who ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
          _label2:
            jmpf ::temp2 _label3
            ; line 8891
            callstatic sNRom_Bridge LOG_WARN ::temp1 ;0 variable args
            callmethod GetDisplayName who ::temp3 ;0 variable args
            strcat ::temp3 "Intimacy profile for " ::temp3 
            strcat ::temp3 ::temp3 " not stored (success=" 
            cast ::temp4 aiSuccess 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ", length " 
            cast ::temp3 len 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 ")" 
            callmethod Diag self ::nonevar ::temp1 ::temp3 False ;3 variable args
            jmp _label4
            ; line 8893
          _label3:
            callstatic sNRom_Bridge StoreSetText ::nonevar who "Intimacy" asResponse ;3 variable args
            ; line 8894
            cast ::temp5 who 
            callstatic storageUtil SetStringValue ::temp3 ::temp5 "IEB_IntimacyProfile" asResponse ;3 variable args
            ; line 8895
            cast ::temp5 who 
            callstatic storageUtil UnsetIntValue ::temp2 ::temp5 "IEB_ForceIntimacyAuthor" ;2 variable args
            ; line 8896
            callstatic sNRom_Bridge LOG_INFO ::temp1 ;0 variable args
            callmethod GetDisplayName who ::temp3 ;0 variable args
            strcat ::temp3 "Intimacy profile stored for " ::temp3 
            strcat ::temp3 ::temp3 " (length " 
            cast ::temp4 len 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ")" 
            callmethod Diag self ::nonevar ::temp1 ::temp4 False ;3 variable args
            ; line 8898
          _label4:
            callmethod IEB_PumpIntimacy self ::nonevar ;0 variable args
          .endCode
        .endFunction ;IEB_OnIntimacyAuthored
        .function IEB_IntimacyCatchUp
           ; function type 0
          .userFlags 0 ;none
          .docString "Sweep catch-up: queue at most 1 enrolled, romance-applicable adult without a profile per pass."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local total Int
            .local i Int
            .local a actor
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 8903
            cast ::temp0 None 
            cmp_eq ::temp1 _pendingIntimacy ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cast ::temp2 None 
            callstatic storageUtil FormListCount ::temp3 ::temp2 "IEB_IntimacyQueue" ;2 variable args
            cmp_gt ::temp1 ::temp3 0 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 8904
            return None 
            jmp _label1
            ; line 8906
          _label1:
            cast ::temp2 None 
            callstatic storageUtil FormListCount ::temp3 ::temp2 "SNRom_Roster" ;2 variable args
            assign total ::temp3 
            ; line 8907
            assign i 0 
            ; line 8908
          _label5:
            cmp_lt ::temp1 i total 
            jmpf ::temp1 _label2
            ; line 8909
            cast ::temp2 None 
            callstatic storageUtil FormListGet ::temp2 ::temp2 "SNRom_Roster" i ;3 variable args
            cast ::temp0 ::temp2 
            assign a ::temp0 
            ; line 8910
            cast ::temp0 None 
            cmp_eq ::temp1 a ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label3
            callmethod IEB_IntimacyWanted self ::temp1 a ;1 variable args
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 8911
            callmethod IEB_QueueIntimacy self ::nonevar a ;1 variable args
            ; line 8912
            return None 
            jmp _label4
            ; line 8914
          _label4:
            iadd ::temp3 i 1 
            assign i ::temp3 
            jmp _label5
          _label2
          .endCode
        .endFunction ;IEB_IntimacyCatchUp
        .function IEB_IntimacyOnLoad
           ; function type 0
          .userFlags 0 ;none
          .docString "After every load: a callback never survives a load, so the in-flight slot is cleared, and the
      durable copy is mirrored into the StorageUtil string the 0335 submodule renders."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local mirrored Int
            .local total Int
            .local ::temp1 form
            .local ::temp2 Int
            .local i Int
            .local ::temp3 Bool
            .local a actor
            .local t String
            .local ::temp4 String
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 8921
            cast ::temp0 None 
            assign _pendingIntimacy ::temp0 
            ; line 8922
            assign mirrored 0 
            ; line 8923
            cast ::temp1 None 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "SNRom_Roster" ;2 variable args
            assign total ::temp2 
            ; line 8924
            assign i 0 
            ; line 8925
          _label4:
            cmp_lt ::temp3 i total 
            jmpf ::temp3 _label0
            ; line 8926
            cast ::temp1 None 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "SNRom_Roster" i ;3 variable args
            cast ::temp0 ::temp1 
            assign a ::temp0 
            ; line 8927
            cast ::temp0 None 
            cmp_eq ::temp3 a ::temp0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label1
            ; line 8928
            callmethod IsChild a ::temp3 ;0 variable args
            jmpf ::temp3 _label2
            ; line 8929
            cast ::temp1 a 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp1 "IEB_IntimacyProfile" ;2 variable args
            jmp _label3
            ; line 8931
          _label2:
            callstatic sNRom_Bridge StoreGetText ::temp4 a "Intimacy" "" 0 ;4 variable args
            assign t ::temp4 
            ; line 8932
            cmp_eq ::temp3 t "" 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label3
            ; line 8933
            cast ::temp1 a 
            callstatic storageUtil SetStringValue ::temp4 ::temp1 "IEB_IntimacyProfile" t ;3 variable args
            ; line 8934
            iadd ::temp2 mirrored 1 
            assign mirrored ::temp2 
            jmp _label3
          _label3:
            jmp _label1
            ; line 8938
          _label1:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label4
            ; line 8940
          _label0:
            callstatic sNRom_Bridge LOG_INFO ::temp2 ;0 variable args
            cast ::temp4 mirrored 
            strcat ::temp4 "Intimacy profiles mirrored after load: " ::temp4 
            callmethod Diag self ::nonevar ::temp2 ::temp4 False ;3 variable args
          .endCode
        .endFunction ;IEB_IntimacyOnLoad
      .endState
    .endStateTable
  .endObject
.endObjectTable
