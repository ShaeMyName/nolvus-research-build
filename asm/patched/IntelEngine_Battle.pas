.info
  .source "C:\nolvus-research\build\src\intelengine\Source\Scripts\IntelEngine_Battle.psc"
  .compileTime 1791570832 ;2026-10-09 14:33:52
  .user "sharp"
  .computer "EMISSARY"
.endInfo
.userFlagsRef
  .flag hidden 0 ;0x00000001
.endUserFlagsRef
.objectTable
  .object IntelEngine_Battle Quest
    .userFlags 0 ;none
    .docString ""
    .autoState 
    .variableTable
      .variable ::ActiveBattleId_var Int
        .userFlags 1 ;hidden 
        .initialValue -1
      .endVariable
      .variable ::ActualBattleStartTime_var Float
        .userFlags 1 ;hidden 
        .initialValue 0.0
      .endVariable
      .variable ::AutoJoinStandingThreshold_var Int
        .userFlags 1 ;hidden 
        .initialValue 20
      .endVariable
      .variable ::BattleFactionA_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::BattleFactionB_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::BattleHardTimeout_var Float
        .userFlags 1 ;hidden 
        .initialValue 1800.0
      .endVariable
      .variable ::BattleLeaderWasEssential_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::BattleLeader_var actor
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::BattleLocationName_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::BattleScheduled_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::BattleSpawnAnchor_var objectReference
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::BattleSpawnDistance_var Float
        .userFlags 1 ;hidden 
        .initialValue 600.0
      .endVariable
      .variable ::BattleSpawned_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::BattleStartRealTime_var Float
        .userFlags 1 ;hidden 
        .initialValue 0.0
      .endVariable
      .variable ::BattleWarId_var Int
        .userFlags 1 ;hidden 
        .initialValue 0
      .endVariable
      .variable ::CenterMarker_var objectReference
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::CenterSpawnDistance_var Float
        .userFlags 1 ;hidden 
        .initialValue 500.0
      .endVariable
      .variable ::Core_var intelEngine_Core
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::CurrentWave_var Int
        .userFlags 1 ;hidden 
        .initialValue 0
      .endVariable
      .variable ::DefeatAllyBonus_var Int
        .userFlags 1 ;hidden 
        .initialValue 5
      .endVariable
      .variable ::DefeatEnemyPenalty_var Int
        .userFlags 1 ;hidden 
        .initialValue -5
      .endVariable
      .variable ::DeferredCleanupActive_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::DeferredCleanupStart_var Float
        .userFlags 1 ;hidden 
        .initialValue 0.0
      .endVariable
      .variable ::Intel_BattleSideA_var faction
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::Intel_BattleSideB_var faction
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::KillStandingPenaltyPerSoldier_var Int
        .userFlags 1 ;hidden 
        .initialValue -2
      .endVariable
      .variable ::ManifestActive_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::ManifestActors_var actor[]
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::ManifestAssassinAttacked_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::ManifestCleanupDelay_var Float
        .userFlags 1 ;hidden 
        .initialValue 90.0
      .endVariable
      .variable ::ManifestCount_var Int
        .userFlags 1 ;hidden 
        .initialValue 0
      .endVariable
      .variable ::ManifestLeaderTarget_var actor
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::ManifestStartTime_var Float
        .userFlags 1 ;hidden 
        .initialValue 0.0
      .endVariable
      .variable ::MaxSoldiersPerSide_var Int
        .userFlags 1 ;hidden 
        .initialValue 22
      .endVariable
      .variable ::MidBattleCasualtyRate_var Float
        .userFlags 1 ;hidden 
        .initialValue 2.0
      .endVariable
      .variable ::MidBattleMinSoldiers_var Int
        .userFlags 1 ;hidden 
        .initialValue 3
      .endVariable
      .variable ::MidBattleMoraleCap_var Int
        .userFlags 1 ;hidden 
        .initialValue 60
      .endVariable
      .variable ::MidBattleMoraleRate_var Float
        .userFlags 1 ;hidden 
        .initialValue 5.0
      .endVariable
      .variable ::PendingPollActive_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::PlayerBattleSide_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::PollInterval_var Float
        .userFlags 1 ;hidden 
        .initialValue 3.0
      .endVariable
      .variable ::QuestAutoJoinFaction_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::RallyMarkerA_var objectReference
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::RallyMarkerB_var objectReference
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::ScheduledBattleTime_var Float
        .userFlags 1 ;hidden 
        .initialValue 0.0
      .endVariable
      .variable ::SpawnDistance_var Int
        .userFlags 1 ;hidden 
        .initialValue 150
      .endVariable
      .variable ::SpectatorPenaltyThreshold_var Int
        .userFlags 1 ;hidden 
        .initialValue 10
      .endVariable
      .variable ::SpectatorPenalty_var Int
        .userFlags 1 ;hidden 
        .initialValue -5
      .endVariable
      .variable ::VictoryAllyBonus_var Int
        .userFlags 1 ;hidden 
        .initialValue 15
      .endVariable
      .variable ::VictoryEnemyPenalty_var Int
        .userFlags 1 ;hidden 
        .initialValue -10
      .endVariable
    .endVariableTable
    .propertyTable
      .property ActiveBattleId Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ActiveBattleId_var
      .endProperty
      .property ActualBattleStartTime Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ActualBattleStartTime_var
      .endProperty
      .property AutoJoinStandingThreshold Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::AutoJoinStandingThreshold_var
      .endProperty
      .property BattleFactionA String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BattleFactionA_var
      .endProperty
      .property BattleFactionB String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BattleFactionB_var
      .endProperty
      .property BattleHardTimeout Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BattleHardTimeout_var
      .endProperty
      .property BattleLeader actor auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BattleLeader_var
      .endProperty
      .property BattleLeaderWasEssential Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BattleLeaderWasEssential_var
      .endProperty
      .property BattleLocationName String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BattleLocationName_var
      .endProperty
      .property BattleScheduled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BattleScheduled_var
      .endProperty
      .property BattleSpawnAnchor objectReference auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BattleSpawnAnchor_var
      .endProperty
      .property BattleSpawnDistance Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BattleSpawnDistance_var
      .endProperty
      .property BattleSpawned Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BattleSpawned_var
      .endProperty
      .property BattleStartRealTime Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BattleStartRealTime_var
      .endProperty
      .property BattleWarId Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BattleWarId_var
      .endProperty
      .property CenterMarker objectReference auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::CenterMarker_var
      .endProperty
      .property CenterSpawnDistance Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::CenterSpawnDistance_var
      .endProperty
      .property Core intelEngine_Core auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::Core_var
      .endProperty
      .property CurrentWave Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::CurrentWave_var
      .endProperty
      .property DefeatAllyBonus Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::DefeatAllyBonus_var
      .endProperty
      .property DefeatEnemyPenalty Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::DefeatEnemyPenalty_var
      .endProperty
      .property DeferredCleanupActive Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::DeferredCleanupActive_var
      .endProperty
      .property DeferredCleanupStart Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::DeferredCleanupStart_var
      .endProperty
      .property Intel_BattleSideA faction auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::Intel_BattleSideA_var
      .endProperty
      .property Intel_BattleSideB faction auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::Intel_BattleSideB_var
      .endProperty
      .property KillStandingPenaltyPerSoldier Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::KillStandingPenaltyPerSoldier_var
      .endProperty
      .property ManifestActive Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ManifestActive_var
      .endProperty
      .property ManifestActors actor[] auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ManifestActors_var
      .endProperty
      .property ManifestAssassinAttacked Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ManifestAssassinAttacked_var
      .endProperty
      .property ManifestCleanupDelay Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ManifestCleanupDelay_var
      .endProperty
      .property ManifestCount Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ManifestCount_var
      .endProperty
      .property ManifestLeaderTarget actor auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ManifestLeaderTarget_var
      .endProperty
      .property ManifestStartTime Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ManifestStartTime_var
      .endProperty
      .property MaxSoldiersPerSide Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::MaxSoldiersPerSide_var
      .endProperty
      .property MidBattleCasualtyRate Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::MidBattleCasualtyRate_var
      .endProperty
      .property MidBattleMinSoldiers Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::MidBattleMinSoldiers_var
      .endProperty
      .property MidBattleMoraleCap Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::MidBattleMoraleCap_var
      .endProperty
      .property MidBattleMoraleRate Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::MidBattleMoraleRate_var
      .endProperty
      .property PendingPollActive Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::PendingPollActive_var
      .endProperty
      .property PlayerBattleSide String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::PlayerBattleSide_var
      .endProperty
      .property PollInterval Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::PollInterval_var
      .endProperty
      .property QuestAutoJoinFaction String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestAutoJoinFaction_var
      .endProperty
      .property RallyMarkerA objectReference auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::RallyMarkerA_var
      .endProperty
      .property RallyMarkerB objectReference auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::RallyMarkerB_var
      .endProperty
      .property ScheduledBattleTime Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ScheduledBattleTime_var
      .endProperty
      .property SpawnDistance Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::SpawnDistance_var
      .endProperty
      .property SpectatorPenalty Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::SpectatorPenalty_var
      .endProperty
      .property SpectatorPenaltyThreshold Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::SpectatorPenaltyThreshold_var
      .endProperty
      .property VictoryAllyBonus Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::VictoryAllyBonus_var
      .endProperty
      .property VictoryEnemyPenalty Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::VictoryEnemyPenalty_var
      .endProperty
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
        .function ScheduleBattle
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param factionA String
            .param factionB String
            .param warId Int
            .param gameTime Float
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local hoursUntilBattle Float
            .local ::temp1 Float
            .local ::temp2 String
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 105
            assign ::temp0 ::BattleScheduled_var 
            jmpt ::temp0 _label0
            callstatic intelEngine IsBattleActive ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 106
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Cannot schedule — already scheduled or active" ;1 variable args
            ; line 107
            return None 
            jmp _label1
            ; line 110
          _label1:
            assign ::BattleFactionA_var factionA 
            ; line 111
            assign ::BattleFactionB_var factionB 
            ; line 112
            assign ::BattleWarId_var warId 
            ; line 113
            assign ::ScheduledBattleTime_var gameTime 
            ; line 114
            assign ::BattleScheduled_var True 
            ; line 115
            assign ::BattleSpawned_var False 
            ; line 118
            callstatic utility GetCurrentGameTime ::temp1 ;0 variable args
            fsub ::temp1 gameTime ::temp1 
            fmul ::temp1 ::temp1 24.0 
            assign hoursUntilBattle ::temp1 
            ; line 119
            cmp_lt ::temp0 hoursUntilBattle 0.100000001 
            jmpf ::temp0 _label2
            ; line 120
            assign hoursUntilBattle 0.100000001 
            jmp _label2
            ; line 122
          _label2:
            callmethod RegisterForSingleUpdateGameTime self ::nonevar hoursUntilBattle ;1 variable args
            ; line 124
            strcat ::temp2 "Battle: Scheduled " factionA 
            strcat ::temp2 ::temp2 " vs " 
            strcat ::temp2 ::temp2 factionB 
            strcat ::temp2 ::temp2 " in " 
            cast ::temp3 hoursUntilBattle 
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 "h" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
          .endCode
        .endFunction ;ScheduleBattle
        .function StartPendingBattlePoll
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
            ; line 132
            jmpf ::PendingPollActive_var _label0
            ; line 134
            return None 
            jmp _label0
            ; line 137
          _label0:
            assign ::PendingPollActive_var True 
            ; line 138
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
            ; line 139
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Started pending battle proximity polling" ;1 variable args
          .endCode
        .endFunction ;StartPendingBattlePoll
        .function HandlePendingBattleTriggered
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param pendingId Int
          .endParamTable
          .localTable
            .local infoJson String
            .local ::temp0 String
            .local ::nonevar None
            .local ::temp1 Int
            .local ::temp2 Bool
            .local factionA String
            .local factionB String
            .local locName String
            .local player actor
            .local ::temp3 actor
            .local locRef objectReference
            .local ::temp4 objectReference
            .local playerAngle Float
            .local ::temp5 Float
            .local spawnDist Float
            .local xmarkerBase form
            .local ::temp6 form
            .local marker objectReference
            .local anchorX Float
            .local ::temp7 Float
            .local anchorY Float
          .endLocalTable
          .code
            ; line 145
            callstatic intelEngine GetPendingBattleInfo ::temp0 pendingId ;1 variable args
            assign infoJson ::temp0 
            ; line 146
            callstatic intelEngine RemovePendingBattle ::nonevar pendingId ;1 variable args
            ; line 147
            callstatic intelEngine GetPendingBattleCount ::temp1 ;0 variable args
            cmp_gt ::temp2 ::temp1 0 
            assign ::PendingPollActive_var ::temp2 
            ; line 149
            cmp_eq ::temp2 infoJson "{}" 
            jmpf ::temp2 _label0
            ; line 150
            cast ::temp0 pendingId 
            strcat ::temp0 "Battle: Pending battle " ::temp0 
            strcat ::temp0 ::temp0 " info not found — already expired?" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 151
            return None 
            jmp _label0
            ; line 155
          _label0:
            callstatic intelEngine StoryResponseGetField ::temp0 infoJson "faction_a" ;2 variable args
            assign factionA ::temp0 
            ; line 156
            callstatic intelEngine StoryResponseGetField ::temp0 infoJson "faction_b" ;2 variable args
            assign factionB ::temp0 
            ; line 157
            callstatic intelEngine StoryResponseGetField ::temp0 infoJson "location" ;2 variable args
            assign locName ::temp0 
            ; line 159
            cmp_eq ::temp2 factionA "" 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label1
            cmp_eq ::temp2 factionB "" 
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 160
            cast ::temp0 pendingId 
            strcat ::temp0 "Battle: Pending battle " ::temp0 
            strcat ::temp0 ::temp0 " has empty factions — aborting" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 161
            return None 
            jmp _label2
            ; line 167
          _label2:
            callstatic intelEngine GetActiveWarId ::temp1 factionA factionB ;2 variable args
            assign ::BattleWarId_var ::temp1 
            ; line 172
            callstatic game GetPlayer ::temp3 ;0 variable args
            assign player ::temp3 
            ; line 173
            callstatic intelEngine ResolveAnyDestination ::temp4 player locName ;2 variable args
            assign locRef ::temp4 
            ; line 174
            cast ::temp4 None 
            cmp_eq ::temp2 locRef ::temp4 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label3
            ; line 175
            assign ::BattleSpawnAnchor_var locRef 
            jmp _label4
            ; line 178
          _label3:
            callmethod GetAngleZ player ::temp5 ;0 variable args
            assign playerAngle ::temp5 
            ; line 179
            assign spawnDist 1500.0 
            ; line 180
            callstatic game GetFormFromFile ::temp6 59 "Skyrim.esm" ;2 variable args
            assign xmarkerBase ::temp6 
            ; line 181
            cast ::temp2 xmarkerBase 
            jmpf ::temp2 _label5
            ; line 182
            callmethod PlaceAtMe player ::temp4 xmarkerBase 1 False False ;4 variable args
            assign marker ::temp4 
            ; line 183
            callmethod GetPositionX player ::temp5 ;0 variable args
            callstatic math sin ::temp7 playerAngle ;1 variable args
            fmul ::temp7 ::temp7 spawnDist 
            fadd ::temp7 ::temp5 ::temp7 
            assign anchorX ::temp7 
            ; line 184
            callmethod GetPositionY player ::temp7 ;0 variable args
            callstatic math cos ::temp5 playerAngle ;1 variable args
            fmul ::temp5 ::temp5 spawnDist 
            fadd ::temp5 ::temp7 ::temp5 
            assign anchorY ::temp5 
            ; line 185
            callmethod GetPositionZ player ::temp5 ;0 variable args
            callmethod SetPosition marker ::nonevar anchorX anchorY ::temp5 ;3 variable args
            ; line 186
            assign ::BattleSpawnAnchor_var marker 
            jmp _label4
            ; line 188
          _label5:
            cast ::temp4 player 
            assign ::BattleSpawnAnchor_var ::temp4 
            ; line 192
          _label4:
            callmethod StartBattleImmediate self ::nonevar factionA factionB ::BattleWarId_var ;3 variable args
            ; line 194
            cast ::temp0 pendingId 
            strcat ::temp0 "Battle: Pending battle " ::temp0 
            strcat ::temp0 ::temp0 " triggered at " 
            strcat ::temp0 ::temp0 locName 
            strcat ::temp0 ::temp0 " — " 
            ; line 195
            strcat ::temp0 ::temp0 factionA 
            strcat ::temp0 ::temp0 " vs " 
            strcat ::temp0 ::temp0 factionB 
            strcat ::temp0 ::temp0 " (unified spawn path)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
          .endCode
        .endFunction ;HandlePendingBattleTriggered
        .function OnUpdateGameTime
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local now Float
            .local ::temp1 Float
            .local ::nonevar None
            .local hoursLeft Float
          .endLocalTable
          .code
            ; line 203
            not ::temp0 ::BattleScheduled_var 
            jmpf ::temp0 _label0
            ; line 204
            return None 
            jmp _label0
            ; line 207
          _label0:
            callstatic utility GetCurrentGameTime ::temp1 ;0 variable args
            assign now ::temp1 
            ; line 208
            comp_gte ::temp0 now ::ScheduledBattleTime_var 
            jmpf ::temp0 _label1
            ; line 209
            callmethod StartBattleSequence self ::nonevar ;0 variable args
            jmp _label2
            ; line 212
          _label1:
            fsub ::temp1 ::ScheduledBattleTime_var now 
            fmul ::temp1 ::temp1 24.0 
            assign hoursLeft ::temp1 
            ; line 213
            callmethod RegisterForSingleUpdateGameTime self ::nonevar hoursLeft ;1 variable args
          _label2
          .endCode
        .endFunction ;OnUpdateGameTime
        .function OnUpdate
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local elapsed Float
            .local ::temp0 Float
            .local combatOver Bool
            .local ::temp1 Bool
            .local ::temp2 actor
            .local hardAssassin actor
            .local ::nonevar None
            .local distToLeader Float
            .local ::temp3 objectReference
            .local ::temp4 String
            .local hardSlot Int
            .local ::temp5 Int
            .local hardTarget String
            .local ::temp6 String[]
            .local ::mangled_elapsed_0 Float
            .local forceAll Bool
            .local player actor
            .local remaining Int
            .local ::temp7 Float
            .local ::temp8 Float
            .local ::temp9 Float
            .local hadPendingPolls Bool
            .local triggeredId Int
            .local expiredResult String
            .local victorId String
            .local locName String
            .local victorName String
            .local ::temp10 intelEngine_StoryEngine
            .local ::temp11 intelEngine_StoryEngine
            .local battleAge Float
            .local timeoutMsg Int
            .local stateJson String
          .endLocalTable
          .code
            ; line 219
            jmpf ::ManifestActive_var _label0
            ; line 220
            callstatic utility GetCurrentRealTime ::temp0 ;0 variable args
            fsub ::temp0 ::temp0 ::ManifestStartTime_var 
            assign elapsed ::temp0 
            ; line 221
            callmethod IsAnyManifestActorInCombat self ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign combatOver ::temp1 
            ; line 224
            cast ::temp2 None 
            cmp_eq ::temp1 ::ManifestLeaderTarget_var ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            not ::temp1 ::ManifestAssassinAttacked_var 
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 225
            array_getlement ::temp2 ::ManifestActors_var 0 
            assign hardAssassin ::temp2 
            ; line 228
            cast ::temp2 None 
            cmp_eq ::temp1 hardAssassin ::temp2 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label3
            callmethod IsDead hardAssassin ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 229
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Assassin killed during tailing — assassination prevented" ;1 variable args
            ; line 230
            callstatic debug Notification ::nonevar "The assassination attempt was foiled!" ;1 variable args
            ; line 231
            callmethod CleanupManifestation self ::nonevar ;0 variable args
            ; line 232
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
            ; line 233
            return None 
            jmp _label4
            ; line 237
          _label4:
            comp_gte ::temp1 elapsed ::ManifestCleanupDelay_var 
            jmpf ::temp1 _label5
            ; line 238
            cast ::temp2 None 
            cmp_eq ::temp1 ::ManifestLeaderTarget_var ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label6
            callmethod IsDead ::ManifestLeaderTarget_var ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label6:
            jmpf ::temp1 _label7
            ; line 239
            cast ::temp3 ::ManifestLeaderTarget_var 
            callmethod GetDistance hardAssassin ::temp0 ::temp3 ;1 variable args
            assign distToLeader ::temp0 
            ; line 240
            cmp_lt ::temp1 distToLeader 3000.0 
            jmpf ::temp1 _label8
            ; line 241
            cast ::temp4 distToLeader 
            strcat ::temp4 "Battle: Assassination hard timeout — force-attacking (dist=" ::temp4 
            strcat ::temp4 ::temp4 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            ; line 242
            cast ::temp3 ::ManifestLeaderTarget_var 
            callmethod MoveTo hardAssassin ::nonevar ::temp3 0.0 0.0 0.0 True ;5 variable args
            ; line 243
            callmethod FindSlotByAgent ::Core_var ::temp5 hardAssassin ;1 variable args
            assign hardSlot ::temp5 
            ; line 244
            callmethod GetDisplayName ::ManifestLeaderTarget_var ::temp4 ;0 variable args
            assign hardTarget ::temp4 
            ; line 245
            comp_gte ::temp1 hardSlot 0 
            jmpf ::temp1 _label9
            ; line 246
            propget SlotTargetNames ::Core_var ::temp6 
            array_getlement ::temp4 ::temp6 hardSlot 
            assign hardTarget ::temp4 
            jmp _label9
            ; line 248
          _label9:
            callmethod HandleAssassinArrival self ::nonevar hardAssassin hardTarget ;2 variable args
            jmp _label10
            ; line 250
          _label8:
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Assassination hard timeout — leader too far, aborting" ;1 variable args
            ; line 251
            callmethod CleanupManifestation self ::nonevar ;0 variable args
          _label10:
            jmp _label11
            ; line 254
          _label7:
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Assassination hard timeout — cleaning up" ;1 variable args
            ; line 255
            callmethod CleanupManifestation self ::nonevar ;0 variable args
          _label11:
            jmp _label12
            ; line 258
          _label5:
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
            ; line 259
            return None 
          _label12:
            jmp _label2
            ; line 264
          _label2:
            assign ::temp1 combatOver 
            jmpf ::temp1 _label13
            comp_gte ::temp1 elapsed 15.0 
            assign ::temp1 ::temp1 
          _label13:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label14
            comp_gte ::temp1 elapsed ::ManifestCleanupDelay_var 
            assign ::temp1 ::temp1 
          _label14:
            jmpf ::temp1 _label15
            ; line 265
            callmethod CleanupManifestation self ::nonevar ;0 variable args
            jmp _label16
            ; line 267
          _label15:
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
            ; line 268
            return None 
          _label16:
            jmp _label0
            ; line 275
          _label0:
            jmpf ::DeferredCleanupActive_var _label17
            ; line 276
            callstatic utility GetCurrentRealTime ::temp0 ;0 variable args
            fsub ::temp0 ::temp0 ::DeferredCleanupStart_var 
            assign ::mangled_elapsed_0 ::temp0 
            ; line 277
            comp_gte ::temp1 ::mangled_elapsed_0 180.0 
            assign forceAll ::temp1 
            ; line 278
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign player ::temp2 
            ; line 281
            callmethod GetPositionX player ::temp0 ;0 variable args
            ; line 282
            callmethod GetPositionY player ::temp7 ;0 variable args
            callmethod GetPositionZ player ::temp8 ;0 variable args
            callmethod GetAngleZ player ::temp9 ;0 variable args
            callstatic intelEngine CleanupBattleSoldiers ::temp5 ::temp0 ::temp7 ::temp8 ::temp9 forceAll ;5 variable args
            assign remaining ::temp5 
            ; line 284
            cmp_eq ::temp1 remaining 0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label18
            assign ::temp1 forceAll 
          _label18:
            jmpf ::temp1 _label19
            ; line 285
            assign ::temp1 forceAll 
            jmpf ::temp1 _label20
            cmp_gt ::temp1 remaining 0 
            assign ::temp1 ::temp1 
          _label20:
            jmpf ::temp1 _label21
            ; line 286
            cast ::temp4 remaining 
            strcat ::temp4 "Battle: Hard timeout cleanup — " ::temp4 
            strcat ::temp4 ::temp4 " actors remaining" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            jmp _label21
            ; line 289
          _label21:
            callmethod RemovePlayerFromBattle self ::nonevar ;0 variable args
            ; line 290
            callmethod CleanupMarkers self ::nonevar ;0 variable args
            ; line 291
            assign ::DeferredCleanupActive_var False 
            ; line 292
            assign ::temp1 ::PendingPollActive_var 
            jmpf ::temp1 _label22
            callstatic intelEngine GetPendingBattleCount ::temp5 ;0 variable args
            cmp_gt ::temp1 ::temp5 0 
            assign ::temp1 ::temp1 
          _label22:
            assign hadPendingPolls ::temp1 
            ; line 293
            callmethod ResetState self ::nonevar ;0 variable args
            ; line 294
            jmpf hadPendingPolls _label23
            ; line 295
            assign ::PendingPollActive_var True 
            ; line 296
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
            ; line 297
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Resumed pending battle polling after cleanup" ;1 variable args
            jmp _label23
            ; line 299
          _label23:
            return None 
            jmp _label19
          _label19:
            jmp _label17
            ; line 306
          _label17:
            assign ::temp1 ::PendingPollActive_var 
            jmpf ::temp1 _label24
            callstatic intelEngine IsBattleActive ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label24:
            jmpf ::temp1 _label25
            ; line 307
            callstatic intelEngine PollPendingBattles ::temp5 ;0 variable args
            assign triggeredId ::temp5 
            ; line 308
            comp_gte ::temp1 triggeredId 0 
            jmpf ::temp1 _label26
            ; line 310
            callmethod HandlePendingBattleTriggered self ::nonevar triggeredId ;1 variable args
            ; line 313
            callstatic intelEngine IsBattleActive ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label27
            callstatic intelEngine GetPendingBattleCount ::temp5 ;0 variable args
            cmp_gt ::temp1 ::temp5 0 
            assign ::temp1 ::temp1 
          _label27:
            jmpf ::temp1 _label28
            ; line 314
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
            jmp _label28
            ; line 316
          _label28:
            return None 
            jmp _label26
            ; line 320
          _label26:
            callstatic intelEngine GetLastExpiredBattleResult ::temp4 ;0 variable args
            assign expiredResult ::temp4 
            ; line 321
            cmp_eq ::temp1 expiredResult "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label29
            ; line 322
            callstatic intelEngine StoryResponseGetField ::temp4 expiredResult "victor" ;2 variable args
            assign victorId ::temp4 
            ; line 323
            callstatic intelEngine StoryResponseGetField ::temp4 expiredResult "location" ;2 variable args
            assign locName ::temp4 
            ; line 324
            cmp_eq ::temp1 victorId "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label30
            ; line 325
            callstatic intelEngine GetFactionDisplayName ::temp4 victorId ;1 variable args
            assign victorName ::temp4 
            ; line 326
            strcat ::temp4 "Word reaches you: " victorName 
            strcat ::temp4 ::temp4 " forces prevailed at " 
            strcat ::temp4 ::temp4 locName 
            strcat ::temp4 ::temp4 "." 
            callstatic debug Notification ::nonevar ::temp4 ;1 variable args
            jmp _label31
            ; line 328
          _label30:
            strcat ::temp4 "Word reaches you: neither side held the field at " locName 
            strcat ::temp4 ::temp4 "." 
            callstatic debug Notification ::nonevar ::temp4 ;1 variable args
          _label31:
            jmp _label29
            ; line 333
          _label29:
            callstatic intelEngine GetPendingBattleCount ::temp5 ;0 variable args
            cmp_lte ::temp1 ::temp5 0 
            jmpf ::temp1 _label32
            ; line 334
            assign ::PendingPollActive_var False 
            ; line 335
            callmethod DebugMsg ::Core_var ::nonevar "Battle: No pending battles remain — stopping proximity poll" ;1 variable args
            ; line 336
            return None 
            jmp _label32
            ; line 339
          _label32:
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
            ; line 340
            return None 
            jmp _label25
            ; line 344
          _label25:
            callstatic intelEngine IsBattleActive ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label33
            ; line 347
            jmpf ::BattleSpawned_var _label34
            ; line 348
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Poll detected battle ended — cleaning up Papyrus state" ;1 variable args
            ; line 349
            assign ::BattleSpawned_var False 
            ; line 353
            propget StoryEngine ::Core_var ::temp10 
            cast ::temp11 None 
            cmp_eq ::temp1 ::temp10 ::temp11 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label35
            ; line 354
            propget StoryEngine ::Core_var ::temp11 
            callmethod CheckQuestProximity ::temp11 ::nonevar ;0 variable args
            jmp _label35
            ; line 356
          _label35:
            assign ::DeferredCleanupActive_var True 
            ; line 357
            callstatic utility GetCurrentRealTime ::temp9 ;0 variable args
            assign ::DeferredCleanupStart_var ::temp9 
            ; line 358
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
            jmp _label34
            ; line 360
          _label34:
            return None 
            jmp _label33
            ; line 364
          _label33:
            not ::temp1 ::BattleSpawned_var 
            jmpf ::temp1 _label36
            ; line 365
            callmethod IsPlayerInExterior self ::temp1 ;0 variable args
            jmpf ::temp1 _label37
            ; line 366
            callmethod SpawnMidBattle self ::nonevar ;0 variable args
            jmp _label38
            ; line 369
          _label37:
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
            ; line 370
            return None 
          _label38:
            jmp _label36
            ; line 376
          _label36:
            cmp_gt ::temp1 ::BattleStartRealTime_var 0.0 
            jmpf ::temp1 _label39
            ; line 377
            callstatic utility GetCurrentRealTime ::temp9 ;0 variable args
            fsub ::temp9 ::temp9 ::BattleStartRealTime_var 
            assign battleAge ::temp9 
            ; line 378
            cmp_gt ::temp1 battleAge ::BattleHardTimeout_var 
            jmpf ::temp1 _label40
            ; line 379
            cast ::temp4 battleAge 
            strcat ::temp4 "Battle: HARD TIMEOUT (" ::temp4 
            strcat ::temp4 ::temp4 "s) — force-ending battle" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            ; line 380
            callstatic utility RandomInt ::temp5 0 2 ;2 variable args
            assign timeoutMsg ::temp5 
            ; line 381
            cmp_eq ::temp1 timeoutMsg 0 
            jmpf ::temp1 _label41
            ; line 382
            callstatic debug Notification ::nonevar "Both sides withdraw, exhausted." ;1 variable args
            jmp _label42
            ; line 383
          _label41:
            cmp_eq ::temp1 timeoutMsg 1 
            jmpf ::temp1 _label43
            ; line 384
            callstatic debug Notification ::nonevar "The surviving soldiers disengage." ;1 variable args
            jmp _label42
            ; line 386
          _label43:
            callstatic debug Notification ::nonevar "The fighting dies down. Neither side holds the field." ;1 variable args
            ; line 388
          _label42:
            callmethod RemovePlayerFromBattle self ::nonevar ;0 variable args
            ; line 389
            callmethod CleanupBattle self ::nonevar ;0 variable args
            ; line 390
            return None 
            jmp _label40
          _label40:
            jmp _label39
            ; line 398
          _label39:
            callstatic intelEngine ClearAllHoldBounties ::nonevar ;0 variable args
            ; line 401
            callstatic intelEngine PollBattleState ::temp4 ;0 variable args
            assign stateJson ::temp4 
            ; line 402
            cmp_eq ::temp1 stateJson "{}" 
            jmpf ::temp1 _label44
            ; line 404
            callmethod CleanupBattle self ::nonevar ;0 variable args
            ; line 405
            return None 
            jmp _label44
            ; line 408
          _label44:
            callmethod HandlePollResult self ::nonevar stateJson ;1 variable args
            ; line 409
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
          .endCode
        .endFunction ;OnUpdate
        .function StartBattleImmediate
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param factionA String
            .param factionB String
            .param warId Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 String
          .endLocalTable
          .code
            ; line 419
            callstatic intelEngine IsBattleActive ::temp0 ;0 variable args
            jmpf ::temp0 _label0
            ; line 420
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Cannot start immediate — already active" ;1 variable args
            ; line 421
            return None 
            jmp _label0
            ; line 423
          _label0:
            assign ::BattleFactionA_var factionA 
            ; line 424
            assign ::BattleFactionB_var factionB 
            ; line 425
            assign ::BattleWarId_var warId 
            ; line 426
            assign ::BattleScheduled_var False 
            ; line 427
            assign ::BattleSpawned_var False 
            ; line 428
            strcat ::temp1 "Battle: Starting immediate — " factionA 
            strcat ::temp1 ::temp1 " vs " 
            strcat ::temp1 ::temp1 factionB 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 429
            callmethod StartBattleSequence self ::nonevar ;0 variable args
          .endCode
        .endFunction ;StartBattleImmediate
        .function StartBattleSequence
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local locName String
            .local ::temp1 String
            .local ::temp2 Bool
            .local ::temp3 Float
            .local ::temp4 Int
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 433
            assign ::BattleScheduled_var False 
            ; line 436
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 437
            callstatic intelEngine GetActorParentLocationName ::temp1 player ;1 variable args
            assign locName ::temp1 
            ; line 438
            cmp_eq ::temp2 locName "" 
            jmpf ::temp2 _label0
            ; line 439
            assign locName "the wilderness" 
            jmp _label0
            ; line 441
          _label0:
            assign ::BattleLocationName_var locName 
            ; line 444
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            assign ::ActualBattleStartTime_var ::temp3 
            ; line 445
            callstatic utility GetCurrentRealTime ::temp3 ;0 variable args
            assign ::BattleStartRealTime_var ::temp3 
            ; line 446
            callstatic intelEngine StartBattle ::temp4 ::BattleFactionA_var ::BattleFactionB_var ::BattleLocationName_var ::BattleWarId_var ;4 variable args
            assign ::ActiveBattleId_var ::temp4 
            ; line 447
            cmp_lt ::temp2 ::ActiveBattleId_var 0 
            jmpf ::temp2 _label1
            ; line 448
            callmethod DebugMsg ::Core_var ::nonevar "Battle: C++ StartBattle failed (another battle active?)" ;1 variable args
            ; line 449
            callmethod ResetState self ::nonevar ;0 variable args
            ; line 450
            return None 
            jmp _label1
            ; line 453
          _label1:
            assign ::CurrentWave_var 0 
            ; line 456
            callmethod SetEnemy ::Intel_BattleSideA_var ::nonevar ::Intel_BattleSideB_var False False ;3 variable args
            ; line 458
            callmethod IsPlayerInExterior self ::temp2 ;0 variable args
            jmpf ::temp2 _label2
            ; line 460
            callmethod SpawnFullBattle self ::nonevar ;0 variable args
            jmp _label3
            ; line 464
          _label2:
            strcat ::temp1 "Battle: Started off-screen at " ::BattleLocationName_var 
            strcat ::temp1 ::temp1 ", waiting for player" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 465
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
          _label3
          .endCode
        .endFunction ;StartBattleSequence
        .function SpawnFullBattle
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local player actor
            .local ::temp1 actor
            .local spawnAnchor objectReference
            .local ::temp2 objectReference
            .local ::temp3 Bool
            .local resultJson String
            .local ::temp4 Float
            .local success Bool
            .local err String
            .local sideASpawned Int
            .local ::temp5 Int
            .local sideBSpawned Int
            .local paired Int
            .local playerJoined Bool
            .local joinFaction String
            .local notification String
            .local ::temp6 String
            .local leaderFormId Int
            .local leader actor
            .local ::temp7 form
            .local ::temp8 intelEngine_StoryEngine
            .local ::temp9 intelEngine_StoryEngine
            .local targetAlias referenceAlias
            .local ::temp10 referenceAlias
            .local aliasCount Int
            .local ai Int
            .local ra referenceAlias
            .local ::temp11 alias
          .endLocalTable
          .code
            ; line 474
            strcat ::temp0 "Battle: Spawning full battle — " ::BattleFactionA_var 
            strcat ::temp0 ::temp0 " vs " 
            strcat ::temp0 ::temp0 ::BattleFactionB_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 475
            assign ::BattleSpawned_var True 
            ; line 478
            callstatic intelEngine ClearAllHoldBounties ::nonevar ;0 variable args
            ; line 483
            callstatic game GetPlayer ::temp1 ;0 variable args
            assign player ::temp1 
            ; line 484
            assign spawnAnchor ::BattleSpawnAnchor_var 
            ; line 485
            cast ::temp2 None 
            cmp_eq ::temp3 spawnAnchor ::temp2 
            jmpf ::temp3 _label0
            ; line 486
            cast ::temp2 player 
            assign spawnAnchor ::temp2 
            jmp _label0
            ; line 489
          _label0:
            callmethod GetAngleZ player ::temp4 ;0 variable args
            callstatic intelEngine ExecuteFullBattleSpawn ::temp0 ::QuestAutoJoinFaction_var player ::temp4 spawnAnchor ;4 variable args
            assign resultJson ::temp0 
            ; line 490
            assign ::QuestAutoJoinFaction_var "" 
            ; line 492
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "success" ;2 variable args
            cmp_eq ::temp3 ::temp0 "true" 
            assign success ::temp3 
            ; line 493
            not ::temp3 success 
            jmpf ::temp3 _label1
            ; line 494
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "error" ;2 variable args
            assign err ::temp0 
            ; line 495
            strcat ::temp0 "Battle: ExecuteFullBattleSpawn FAILED: " err 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 496
            callmethod CleanupBattle self ::nonevar ;0 variable args
            ; line 497
            return None 
            jmp _label1
            ; line 500
          _label1:
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "sideACount" ;2 variable args
            cast ::temp5 ::temp0 
            assign sideASpawned ::temp5 
            ; line 501
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "sideBCount" ;2 variable args
            cast ::temp5 ::temp0 
            assign sideBSpawned ::temp5 
            ; line 502
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "paired" ;2 variable args
            cast ::temp5 ::temp0 
            assign paired ::temp5 
            ; line 503
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "playerJoined" ;2 variable args
            cmp_eq ::temp3 ::temp0 "true" 
            assign playerJoined ::temp3 
            ; line 504
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "joinFaction" ;2 variable args
            assign joinFaction ::temp0 
            ; line 505
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "notification" ;2 variable args
            assign notification ::temp0 
            ; line 512
            jmpf playerJoined _label2
            ; line 513
            assign ::PlayerBattleSide_var joinFaction 
            ; line 514
            strcat ::temp0 "Battle: Player joined " joinFaction 
            strcat ::temp0 ::temp0 " — teammates set by C++ (" 
            cast ::temp6 sideASpawned 
            strcat ::temp6 ::temp0 ::temp6 
            strcat ::temp6 ::temp6 " vs " 
            cast ::temp0 sideBSpawned 
            strcat ::temp0 ::temp6 ::temp0 
            strcat ::temp0 ::temp0 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            jmp _label3
            ; line 516
          _label2:
            strcat ::temp0 "Battle: Player did NOT auto-join (playerJoined=false, joinFaction=" joinFaction 
            strcat ::temp0 ::temp0 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 520
          _label3:
            callstatic intelEngine GetJsonArrayInt ::temp5 resultJson "leaderFormId" 0 ;3 variable args
            assign leaderFormId ::temp5 
            ; line 521
            cmp_eq ::temp3 leaderFormId 0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label4
            ; line 522
            callstatic game GetForm ::temp7 leaderFormId ;1 variable args
            cast ::temp1 ::temp7 
            assign leader ::temp1 
            ; line 523
            cast ::temp3 leader 
            jmpf ::temp3 _label5
            ; line 524
            assign ::BattleLeader_var leader 
            ; line 525
            callmethod IsEssential leader ::temp3 ;0 variable args
            assign ::BattleLeaderWasEssential_var ::temp3 
            ; line 527
            propget StoryEngine ::Core_var ::temp8 
            cast ::temp9 None 
            cmp_eq ::temp3 ::temp8 ::temp9 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label6
            ; line 528
            propget StoryEngine ::Core_var ::temp9 
            propget QuestTargetAlias ::temp9 ::temp10 
            assign targetAlias ::temp10 
            ; line 531
            cast ::temp10 None 
            cmp_eq ::temp3 targetAlias ::temp10 
            jmpf ::temp3 _label7
            ; line 532
            propget StoryEngine ::Core_var ::temp9 
            callmethod GetNumAliases ::temp9 ::temp5 ;0 variable args
            assign aliasCount ::temp5 
            ; line 533
            isub ::temp5 aliasCount 1 
            assign ai ::temp5 
            ; line 534
          _label21:
            comp_gte ::temp3 ai 1 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label8
            cast ::temp10 None 
            cmp_eq ::temp3 targetAlias ::temp10 
            assign ::temp3 ::temp3 
          _label8:
            jmpf ::temp3 _label9
            ; line 535
            propget StoryEngine ::Core_var ::temp9 
            callmethod GetAlias ::temp9 ::temp11 ai ;1 variable args
            cast ::temp10 ::temp11 
            assign ra ::temp10 
            ; line 536
            cast ::temp10 None 
            cmp_eq ::temp3 ra ::temp10 
            not ::temp3 ::temp3 
            ; line 537
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label10
            propget AgentAlias00 ::Core_var ::temp10 
            cmp_eq ::temp3 ra ::temp10 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
          _label10:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label11
            propget AgentAlias01 ::Core_var ::temp10 
            cmp_eq ::temp3 ra ::temp10 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
            ; line 538
          _label11:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label12
            propget AgentAlias02 ::Core_var ::temp10 
            cmp_eq ::temp3 ra ::temp10 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
          _label12:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label13
            propget AgentAlias03 ::Core_var ::temp10 
            cmp_eq ::temp3 ra ::temp10 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
            ; line 539
          _label13:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label14
            propget AgentAlias04 ::Core_var ::temp10 
            cmp_eq ::temp3 ra ::temp10 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
            ; line 540
          _label14:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label15
            propget TargetAlias00 ::Core_var ::temp10 
            cmp_eq ::temp3 ra ::temp10 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
          _label15:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label16
            propget TargetAlias01 ::Core_var ::temp10 
            cmp_eq ::temp3 ra ::temp10 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
            ; line 541
          _label16:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label17
            propget TargetAlias02 ::Core_var ::temp10 
            cmp_eq ::temp3 ra ::temp10 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
          _label17:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label18
            propget TargetAlias03 ::Core_var ::temp10 
            cmp_eq ::temp3 ra ::temp10 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
            ; line 542
          _label18:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label19
            propget TargetAlias04 ::Core_var ::temp10 
            cmp_eq ::temp3 ra ::temp10 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
          _label19:
            jmpf ::temp3 _label20
            ; line 543
            assign targetAlias ra 
            ; line 544
            propget StoryEngine ::Core_var ::temp9 
            propset QuestTargetAlias ::temp9 targetAlias 
            ; line 545
            callmethod DebugMsg ::Core_var ::nonevar "Battle: recovered QuestTargetAlias from alias scan" ;1 variable args
            jmp _label20
            ; line 547
          _label20:
            isub ::temp5 ai 1 
            assign ai ::temp5 
            jmp _label21
          _label9:
            jmp _label7
            ; line 550
          _label7:
            cast ::temp10 None 
            cmp_eq ::temp3 targetAlias ::temp10 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label22
            ; line 551
            cast ::temp2 leader 
            callmethod ForceRefTo targetAlias ::nonevar ::temp2 ;1 variable args
            ; line 552
            propget StoryEngine ::Core_var ::temp9 
            propget QUEST_OBJECTIVE_ID ::temp9 ::temp5 
            propget StoryEngine ::Core_var ::temp9 
            callmethod SetObjectiveDisplayed ::temp9 ::nonevar ::temp5 False False ;3 variable args
            ; line 553
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 554
            propget StoryEngine ::Core_var ::temp9 
            propget QUEST_OBJECTIVE_ID ::temp9 ::temp5 
            propget StoryEngine ::Core_var ::temp9 
            callmethod SetObjectiveDisplayed ::temp9 ::nonevar ::temp5 True False ;3 variable args
            ; line 555
            callmethod GetDisplayName leader ::temp0 ;0 variable args
            strcat ::temp0 "Battle: Quest marker moved to leader — " ::temp0 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            jmp _label23
            ; line 557
          _label22:
            callmethod DebugMsg ::Core_var ::nonevar "Battle: WARNING — QuestTargetAlias is None, cannot place marker on leader" ;1 variable args
          _label23:
            jmp _label6
          _label6:
            jmp _label5
          _label5:
            jmp _label4
            ; line 564
          _label4:
            assign ::temp3 playerJoined 
            jmpf ::temp3 _label24
            cmp_eq ::temp3 notification "" 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
          _label24:
            jmpf ::temp3 _label25
            ; line 565
            callstatic debug Notification ::nonevar notification ;1 variable args
            jmp _label25
            ; line 568
          _label25:
            assign ::CurrentWave_var 1 
            ; line 569
            callstatic intelEngine AdvanceBattleWave ::nonevar ;0 variable args
            ; line 571
            cast ::temp0 sideASpawned 
            strcat ::temp0 "Battle: C++ spawned " ::temp0 
            strcat ::temp0 ::temp0 " vs " 
            cast ::temp6 sideBSpawned 
            strcat ::temp6 ::temp0 ::temp6 
            strcat ::temp6 ::temp6 ", " 
            cast ::temp0 paired 
            strcat ::temp0 ::temp6 ::temp0 
            strcat ::temp0 ::temp0 " combat pairs" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 574
            callmethod ForceInitialEngagement self ::nonevar ;0 variable args
            ; line 576
            callmethod ShowBattleStartNotification self ::nonevar ::BattleLocationName_var ;1 variable args
            ; line 579
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
          .endCode
        .endFunction ;SpawnFullBattle
        .function SpawnMidBattle
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local now Float
            .local ::temp0 Float
            .local elapsedDays Float
            .local ::temp1 Bool
            .local elapsedMinutes Float
            .local casualtiesPerSide Int
            .local ::temp2 Int
            .local moraleLoss Int
            .local nameA String
            .local ::temp3 String
            .local nameB String
            .local arrivalVar Int
            .local soldiersPerSide Int
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 589
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Player arrived — spawning mid-battle" ;1 variable args
            ; line 590
            assign ::BattleSpawned_var True 
            ; line 593
            callstatic utility GetCurrentGameTime ::temp0 ;0 variable args
            assign now ::temp0 
            ; line 594
            fsub ::temp0 now ::ActualBattleStartTime_var 
            assign elapsedDays ::temp0 
            ; line 595
            cmp_lt ::temp1 elapsedDays 0.0 
            jmpf ::temp1 _label0
            ; line 596
            assign elapsedDays 0.0 
            jmp _label0
            ; line 598
          _label0:
            fmul ::temp0 elapsedDays 24.0 
            fmul ::temp0 ::temp0 60.0 
            assign elapsedMinutes ::temp0 
            ; line 601
            callmethod CalculateAndPlaceMarkers self ::nonevar ;0 variable args
            ; line 604
            fdiv ::temp0 elapsedMinutes ::MidBattleCasualtyRate_var 
            cast ::temp2 ::temp0 
            assign casualtiesPerSide ::temp2 
            ; line 605
            cmp_lt ::temp1 casualtiesPerSide 0 
            jmpf ::temp1 _label1
            ; line 606
            assign casualtiesPerSide 0 
            jmp _label1
            ; line 610
          _label1:
            fmul ::temp0 elapsedMinutes ::MidBattleMoraleRate_var 
            cast ::temp2 ::temp0 
            assign moraleLoss ::temp2 
            ; line 611
            cmp_gt ::temp1 moraleLoss ::MidBattleMoraleCap_var 
            jmpf ::temp1 _label2
            ; line 612
            assign moraleLoss ::MidBattleMoraleCap_var 
            jmp _label2
            ; line 616
          _label2:
            callstatic intelEngine GetFactionDisplayName ::temp3 ::BattleFactionA_var ;1 variable args
            assign nameA ::temp3 
            ; line 617
            callstatic intelEngine GetFactionDisplayName ::temp3 ::BattleFactionB_var ;1 variable args
            assign nameB ::temp3 
            ; line 618
            callstatic utility RandomInt ::temp2 0 2 ;2 variable args
            assign arrivalVar ::temp2 
            ; line 619
            cmp_eq ::temp1 arrivalVar 0 
            jmpf ::temp1 _label3
            ; line 620
            strcat ::temp3 "A battle rages between " nameA 
            strcat ::temp3 ::temp3 " and " 
            strcat ::temp3 ::temp3 nameB 
            strcat ::temp3 ::temp3 " forces." 
            callstatic debug Notification ::nonevar ::temp3 ;1 variable args
            jmp _label4
            ; line 621
          _label3:
            cmp_eq ::temp1 arrivalVar 1 
            jmpf ::temp1 _label5
            ; line 622
            strcat ::temp3 "You arrive to find " nameA 
            strcat ::temp3 ::temp3 " and " 
            strcat ::temp3 ::temp3 nameB 
            strcat ::temp3 ::temp3 " forces locked in combat." 
            callstatic debug Notification ::nonevar ::temp3 ;1 variable args
            jmp _label4
            ; line 624
          _label5:
            strcat ::temp3 "Sounds of battle carry across the field — " nameA 
            strcat ::temp3 ::temp3 " and " 
            strcat ::temp3 ::temp3 nameB 
            strcat ::temp3 ::temp3 " clash ahead." 
            callstatic debug Notification ::nonevar ::temp3 ;1 variable args
            ; line 628
          _label4:
            callmethod GetWaveSoldierCount self ::temp2 1 ;1 variable args
            isub ::temp2 ::temp2 casualtiesPerSide 
            assign soldiersPerSide ::temp2 
            ; line 629
            cmp_lt ::temp1 soldiersPerSide ::MidBattleMinSoldiers_var 
            jmpf ::temp1 _label6
            ; line 630
            assign soldiersPerSide ::MidBattleMinSoldiers_var 
            jmp _label6
            ; line 634
          _label6:
            callmethod SpawnSoldiersAtMarker self ::nonevar ::BattleFactionA_var ::CenterMarker_var soldiersPerSide True ;4 variable args
            ; line 635
            callmethod SpawnSoldiersAtMarker self ::nonevar ::BattleFactionB_var ::CenterMarker_var soldiersPerSide False ;4 variable args
            ; line 638
            callmethod ForceInitialEngagement self ::nonevar ;0 variable args
            ; line 641
            ineg ::temp2 moraleLoss 
            callstatic intelEngine AdjustBattleMorale ::nonevar ::BattleFactionA_var ::temp2 ;2 variable args
            ; line 642
            ineg ::temp2 moraleLoss 
            callstatic intelEngine AdjustBattleMorale ::nonevar ::BattleFactionB_var ::temp2 ;2 variable args
            ; line 647
            assign ::CurrentWave_var 2 
            ; line 648
            callstatic intelEngine AdvanceBattleWave ::nonevar ;0 variable args
            ; line 649
            callstatic intelEngine AdvanceBattleWave ::nonevar ;0 variable args
            ; line 652
            callmethod EvaluatePlayerJoin self ::nonevar ;0 variable args
            ; line 654
            cast ::temp3 soldiersPerSide 
            strcat ::temp3 "Battle: Mid-battle spawn — " ::temp3 
            strcat ::temp3 ::temp3 " per side, " 
            cast ::temp4 moraleLoss 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 " morale lost" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
          .endCode
        .endFunction ;SpawnMidBattle
        .function CalculateMarkersAtLocation
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param centerX Float
            .param centerY Float
            .param centerZ Float
          .endParamTable
          .localTable
            .local axisAngle Float
            .local ::temp0 Float
            .local rallyAX Float
            .local ::temp1 Float
            .local rallyAY Float
            .local rallyBX Float
            .local rallyBY Float
            .local xmarkerBase form
            .local ::temp2 form
            .local ::temp3 Bool
            .local ::nonevar None
            .local player actor
            .local ::temp4 actor
            .local ::temp5 objectReference
            .local ::temp6 String
            .local ::temp7 String
          .endLocalTable
          .code
            ; line 666
            callstatic utility RandomFloat ::temp0 0.0 360.0 ;2 variable args
            assign axisAngle ::temp0 
            ; line 668
            callstatic math sin ::temp0 axisAngle ;1 variable args
            cast ::temp1 ::SpawnDistance_var 
            fmul ::temp1 ::temp0 ::temp1 
            fadd ::temp1 centerX ::temp1 
            assign rallyAX ::temp1 
            ; line 669
            callstatic math cos ::temp1 axisAngle ;1 variable args
            cast ::temp0 ::SpawnDistance_var 
            fmul ::temp0 ::temp1 ::temp0 
            fadd ::temp0 centerY ::temp0 
            assign rallyAY ::temp0 
            ; line 670
            callstatic math sin ::temp0 axisAngle ;1 variable args
            cast ::temp1 ::SpawnDistance_var 
            fmul ::temp1 ::temp0 ::temp1 
            fsub ::temp1 centerX ::temp1 
            assign rallyBX ::temp1 
            ; line 671
            callstatic math cos ::temp1 axisAngle ;1 variable args
            cast ::temp0 ::SpawnDistance_var 
            fmul ::temp0 ::temp1 ::temp0 
            fsub ::temp0 centerY ::temp0 
            assign rallyBY ::temp0 
            ; line 674
            callstatic game GetFormFromFile ::temp2 59 "Skyrim.esm" ;2 variable args
            assign xmarkerBase ::temp2 
            ; line 675
            not ::temp3 xmarkerBase 
            jmpf ::temp3 _label0
            ; line 676
            callmethod DebugMsg ::Core_var ::nonevar "Battle: FATAL — XMarker base not found, aborting spawn" ;1 variable args
            ; line 677
            return None 
            jmp _label0
            ; line 680
          _label0:
            callstatic game GetPlayer ::temp4 ;0 variable args
            assign player ::temp4 
            ; line 681
            callmethod PlaceAtMe player ::temp5 xmarkerBase 1 False False ;4 variable args
            assign ::CenterMarker_var ::temp5 
            ; line 682
            callmethod SetPosition ::CenterMarker_var ::nonevar centerX centerY centerZ ;3 variable args
            ; line 684
            callmethod PlaceAtMe player ::temp5 xmarkerBase 1 False False ;4 variable args
            assign ::RallyMarkerA_var ::temp5 
            ; line 685
            callmethod SetPosition ::RallyMarkerA_var ::nonevar rallyAX rallyAY centerZ ;3 variable args
            ; line 687
            callmethod PlaceAtMe player ::temp5 xmarkerBase 1 False False ;4 variable args
            assign ::RallyMarkerB_var ::temp5 
            ; line 688
            callmethod SetPosition ::RallyMarkerB_var ::nonevar rallyBX rallyBY centerZ ;3 variable args
            ; line 690
            cast ::temp6 centerX 
            strcat ::temp6 "Battle: Markers placed — center (" ::temp6 
            strcat ::temp6 ::temp6 ", " 
            cast ::temp7 centerY 
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 "), rally A (" 
            ; line 691
            cast ::temp6 rallyAX 
            strcat ::temp6 ::temp7 ::temp6 
            strcat ::temp6 ::temp6 ", " 
            cast ::temp7 rallyAY 
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 "), rally B (" 
            cast ::temp6 rallyBX 
            strcat ::temp6 ::temp7 ::temp6 
            strcat ::temp6 ::temp6 ", " 
            cast ::temp7 rallyBY 
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
          .endCode
        .endFunction ;CalculateMarkersAtLocation
        .function PlaceMarkersTowardBattle
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param battleX Float
            .param battleY Float
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local playerX Float
            .local ::temp1 Float
            .local playerY Float
            .local playerZ Float
            .local dx Float
            .local dy Float
            .local dist Float
            .local ::temp2 Float
            .local centerX Float
            .local centerY Float
            .local ::temp3 Bool
            .local dirX Float
            .local dirY Float
            .local playerAngle Float
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 699
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 700
            callmethod GetPositionX player ::temp1 ;0 variable args
            assign playerX ::temp1 
            ; line 701
            callmethod GetPositionY player ::temp1 ;0 variable args
            assign playerY ::temp1 
            ; line 702
            callmethod GetPositionZ player ::temp1 ;0 variable args
            assign playerZ ::temp1 
            ; line 705
            fsub ::temp1 battleX playerX 
            assign dx ::temp1 
            ; line 706
            fsub ::temp1 battleY playerY 
            assign dy ::temp1 
            ; line 707
            fmul ::temp1 dx dx 
            fmul ::temp2 dy dy 
            fadd ::temp2 ::temp1 ::temp2 
            callstatic math sqrt ::temp2 ::temp2 ;1 variable args
            assign dist ::temp2 
            ; line 711
            cmp_gt ::temp3 dist 1.0 
            jmpf ::temp3 _label0
            ; line 713
            fdiv ::temp2 dx dist 
            assign dirX ::temp2 
            ; line 714
            fdiv ::temp2 dy dist 
            assign dirY ::temp2 
            ; line 715
            fmul ::temp2 dirX ::BattleSpawnDistance_var 
            fadd ::temp2 playerX ::temp2 
            assign centerX ::temp2 
            ; line 716
            fmul ::temp2 dirY ::BattleSpawnDistance_var 
            fadd ::temp2 playerY ::temp2 
            assign centerY ::temp2 
            jmp _label1
            ; line 719
          _label0:
            callmethod GetAngleZ player ::temp2 ;0 variable args
            assign playerAngle ::temp2 
            ; line 720
            callstatic math sin ::temp2 playerAngle ;1 variable args
            fmul ::temp2 ::temp2 ::BattleSpawnDistance_var 
            fadd ::temp2 playerX ::temp2 
            assign centerX ::temp2 
            ; line 721
            callstatic math cos ::temp2 playerAngle ;1 variable args
            fmul ::temp2 ::temp2 ::BattleSpawnDistance_var 
            fadd ::temp2 playerY ::temp2 
            assign centerY ::temp2 
            ; line 724
          _label1:
            callmethod CalculateMarkersAtLocation self ::nonevar centerX centerY playerZ ;3 variable args
          .endCode
        .endFunction ;PlaceMarkersTowardBattle
        .function CalculateAndPlaceMarkers
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local playerX Float
            .local ::temp1 Float
            .local playerY Float
            .local playerZ Float
            .local playerAngle Float
            .local centerX Float
            .local centerY Float
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 729
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 730
            callmethod GetPositionX player ::temp1 ;0 variable args
            assign playerX ::temp1 
            ; line 731
            callmethod GetPositionY player ::temp1 ;0 variable args
            assign playerY ::temp1 
            ; line 732
            callmethod GetPositionZ player ::temp1 ;0 variable args
            assign playerZ ::temp1 
            ; line 733
            callmethod GetAngleZ player ::temp1 ;0 variable args
            assign playerAngle ::temp1 
            ; line 735
            callstatic math sin ::temp1 playerAngle ;1 variable args
            fmul ::temp1 ::temp1 ::CenterSpawnDistance_var 
            fadd ::temp1 playerX ::temp1 
            assign centerX ::temp1 
            ; line 736
            callstatic math cos ::temp1 playerAngle ;1 variable args
            fmul ::temp1 ::temp1 ::CenterSpawnDistance_var 
            fadd ::temp1 playerY ::temp1 
            assign centerY ::temp1 
            ; line 738
            callmethod CalculateMarkersAtLocation self ::nonevar centerX centerY playerZ ;3 variable args
          .endCode
        .endFunction ;CalculateAndPlaceMarkers
        .function SpawnWave
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param waveNum Int
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local count Int
            .local ::temp1 Int
            .local ::nonevar None
            .local ::temp2 String
            .local ::temp3 String
            .local ::temp4 Bool
            .local waveType String
            .local anchor objectReference
            .local ::temp5 objectReference
            .local resultJson String
            .local success Bool
            .local sideASpawned Int
            .local sideBSpawned Int
            .local playerSide String
            .local ::temp6 Float
          .endLocalTable
          .code
            ; line 747
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 748
            callmethod GetWaveSoldierCount self ::temp1 waveNum ;1 variable args
            assign count ::temp1 
            ; line 750
            cast ::temp2 waveNum 
            strcat ::temp2 "Battle: Spawning wave " ::temp2 
            strcat ::temp2 ::temp2 " — " 
            cast ::temp3 count 
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 " soldiers per side (C++)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 753
            cmp_gt ::temp4 waveNum 1 
            jmpf ::temp4 _label0
            ; line 754
            cast ::temp3 waveNum 
            strcat ::temp3 "wave" ::temp3 
            assign waveType ::temp3 
            ; line 755
            callstatic intelEngine GetBattleNotification ::temp3 waveType "" "" False ;4 variable args
            callstatic debug Notification ::nonevar ::temp3 ;1 variable args
            jmp _label0
            ; line 760
          _label0:
            assign anchor ::BattleSpawnAnchor_var 
            ; line 761
            cast ::temp5 None 
            cmp_eq ::temp4 anchor ::temp5 
            jmpf ::temp4 _label1
            ; line 762
            assign anchor ::CenterMarker_var 
            jmp _label1
            ; line 764
          _label1:
            callstatic intelEngine SpawnReinforcements ::temp3 count player anchor ;3 variable args
            assign resultJson ::temp3 
            ; line 765
            callstatic intelEngine StoryResponseGetField ::temp3 resultJson "success" ;2 variable args
            cmp_eq ::temp4 ::temp3 "true" 
            assign success ::temp4 
            ; line 767
            not ::temp4 success 
            jmpf ::temp4 _label2
            ; line 768
            callstatic intelEngine StoryResponseGetField ::temp3 resultJson "error" ;2 variable args
            strcat ::temp3 "Battle: SpawnReinforcements FAILED: " ::temp3 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 769
            assign ::CurrentWave_var waveNum 
            ; line 770
            callstatic intelEngine AdvanceBattleWave ::nonevar ;0 variable args
            ; line 771
            return None 
            jmp _label2
            ; line 774
          _label2:
            callstatic intelEngine StoryResponseGetField ::temp3 resultJson "sideACount" ;2 variable args
            cast ::temp1 ::temp3 
            assign sideASpawned ::temp1 
            ; line 775
            callstatic intelEngine StoryResponseGetField ::temp3 resultJson "sideBCount" ;2 variable args
            cast ::temp1 ::temp3 
            assign sideBSpawned ::temp1 
            ; line 776
            callstatic intelEngine StoryResponseGetField ::temp3 resultJson "playerSide" ;2 variable args
            assign playerSide ::temp3 
            ; line 780
            cast ::temp3 waveNum 
            strcat ::temp3 "Battle: Wave " ::temp3 
            strcat ::temp3 ::temp3 " — " 
            cast ::temp2 sideASpawned 
            strcat ::temp2 ::temp3 ::temp2 
            strcat ::temp2 ::temp2 " vs " 
            cast ::temp3 sideBSpawned 
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 " (teammates set by C++)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 782
            assign ::CurrentWave_var waveNum 
            ; line 783
            callstatic intelEngine AdvanceBattleWave ::nonevar ;0 variable args
            ; line 786
            cmp_eq ::temp4 waveNum 1 
            jmpf ::temp4 _label3
            ; line 787
            callstatic utility RandomFloat ::temp6 0.0 1.5 ;2 variable args
            fadd ::temp6 1.5 ::temp6 
            callstatic utility Wait ::nonevar ::temp6 ;1 variable args
            ; line 788
            callstatic intelEngine GetBattleNotification ::temp3 "wave1" "" "" False ;4 variable args
            callstatic debug Notification ::nonevar ::temp3 ;1 variable args
            jmp _label3
          _label3
          .endCode
        .endFunction ;SpawnWave
        .function GetWaveSoldierCount
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
            .param waveNum Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 795
            cmp_eq ::temp0 waveNum 1 
            jmpf ::temp0 _label0
            ; line 796
            return 6 
            jmp _label1
            ; line 797
          _label0:
            cmp_eq ::temp0 waveNum 2 
            jmpf ::temp0 _label2
            ; line 798
            return 5 
            jmp _label1
            ; line 799
          _label2:
            cmp_eq ::temp0 waveNum 3 
            jmpf ::temp0 _label3
            ; line 800
            return 4 
            jmp _label1
            ; line 801
          _label3:
            cmp_eq ::temp0 waveNum 4 
            jmpf ::temp0 _label4
            ; line 802
            return 4 
            jmp _label1
            ; line 803
          _label4:
            cmp_eq ::temp0 waveNum 5 
            jmpf ::temp0 _label1
            ; line 804
            return 3 
            jmp _label1
            ; line 806
          _label1:
            return 3 
          .endCode
        .endFunction ;GetWaveSoldierCount
        .function SpawnSoldiersAtMarker
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param factionId String
            .param marker objectReference
            .param count Int
            .param isSideA Bool
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local sideKey String
            .local sideJson String
            .local ::temp1 String
            .local currentCount Int
            .local ::temp2 Int
            .local battleFaction faction
            .local soldiers actor[]
            .local ::temp3 String
            .local ::temp4 actor[]
            .local i Int
            .local soldier actor
            .local ::temp5 actor
            .local offsetX Float
            .local ::temp6 Float
            .local offsetY Float
          .endLocalTable
          .code
            ; line 810
            not ::temp0 marker 
            jmpf ::temp0 _label0
            ; line 811
            callmethod DebugMsg ::Core_var ::nonevar "Battle: SpawnSoldiersAtMarker — marker is None!" ;1 variable args
            ; line 812
            return None 
            jmp _label0
            ; line 816
          _label0:
            assign sideKey "A" 
            ; line 817
            not ::temp0 isSideA 
            jmpf ::temp0 _label1
            ; line 818
            assign sideKey "B" 
            jmp _label1
            ; line 820
          _label1:
            callstatic intelEngine GetBattleSoldierFormIds ::temp1 sideKey ;1 variable args
            assign sideJson ::temp1 
            ; line 821
            callstatic intelEngine StoryResponseGetField ::temp1 sideJson "count" ;2 variable args
            cast ::temp2 ::temp1 
            assign currentCount ::temp2 
            ; line 822
            iadd ::temp2 currentCount count 
            cmp_gt ::temp0 ::temp2 ::MaxSoldiersPerSide_var 
            jmpf ::temp0 _label2
            ; line 823
            isub ::temp2 ::MaxSoldiersPerSide_var currentCount 
            assign count ::temp2 
            jmp _label2
            ; line 825
          _label2:
            cmp_lte ::temp0 count 0 
            jmpf ::temp0 _label3
            ; line 826
            return None 
            jmp _label3
            ; line 829
          _label3:
            assign battleFaction ::Intel_BattleSideA_var 
            ; line 830
            not ::temp0 isSideA 
            jmpf ::temp0 _label4
            ; line 831
            assign battleFaction ::Intel_BattleSideB_var 
            jmp _label4
            ; line 835
          _label4:
            strcat ::temp1 factionId ":" 
            cast ::temp3 count 
            strcat ::temp3 ::temp1 ::temp3 
            callstatic intelEngine SpawnBattleSoldiers ::temp4 ::temp3 marker ;2 variable args
            assign soldiers ::temp4 
            ; line 837
            assign i 0 
            ; line 838
          _label10:
            array_length ::temp2 soldiers 
            cmp_lt ::temp0 i ::temp2 
            jmpf ::temp0 _label5
            ; line 839
            array_getlement ::temp5 soldiers i 
            assign soldier ::temp5 
            ; line 840
            cast ::temp0 soldier 
            jmpf ::temp0 _label6
            ; line 843
            callstatic utility RandomFloat ::temp6 -150.0 150.0 ;2 variable args
            assign offsetX ::temp6 
            ; line 844
            callstatic utility RandomFloat ::temp6 -150.0 150.0 ;2 variable args
            assign offsetY ::temp6 
            ; line 845
            callmethod MoveTo soldier ::nonevar marker offsetX offsetY 0.0 True ;5 variable args
            ; line 851
            callmethod AddToFaction soldier ::nonevar battleFaction ;1 variable args
            ; line 852
            callmethod SetActorValue soldier ::nonevar "Aggression" 1.0 ;2 variable args
            ; line 853
            callmethod SetActorValue soldier ::nonevar "Confidence" 4.0 ;2 variable args
            ; line 857
            callstatic intelEngine RegisterBattleActor ::temp0 soldier factionId 0 ;3 variable args
            ; line 866
            cast ::temp0 ::CenterMarker_var 
            jmpf ::temp0 _label7
            ; line 867
            callmethod PathToReference soldier ::temp0 ::CenterMarker_var 0.0 ;2 variable args
            jmp _label7
            ; line 871
          _label7:
            cmp_gt ::temp0 i 0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label8
            imod ::temp2 i 2 
            cmp_eq ::temp0 ::temp2 0 
            assign ::temp0 ::temp0 
          _label8:
            jmpf ::temp0 _label9
            ; line 872
            callstatic utility RandomFloat ::temp6 0.0 0.150000006 ;2 variable args
            fadd ::temp6 0.150000006 ::temp6 
            callstatic utility Wait ::nonevar ::temp6 ;1 variable args
            jmp _label9
          _label9:
            jmp _label6
            ; line 875
          _label6:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label10
            ; line 878
          _label5:
            array_length ::temp2 soldiers 
            cast ::temp3 ::temp2 
            strcat ::temp3 "Battle: Spawned " ::temp3 
            strcat ::temp3 ::temp3 "/" 
            cast ::temp1 count 
            strcat ::temp1 ::temp3 ::temp1 
            strcat ::temp1 ::temp1 " soldiers for " 
            strcat ::temp1 ::temp1 factionId 
            strcat ::temp1 ::temp1 " at rally marker" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
          .endCode
        .endFunction ;SpawnSoldiersAtMarker
        .function EvaluatePlayerJoin
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local resultJson String
            .local ::temp0 String
            .local shouldJoin Bool
            .local ::temp1 Bool
            .local ::nonevar None
            .local joinFaction String
            .local displayName String
            .local isQuestJoin Bool
          .endLocalTable
          .code
            ; line 887
            callstatic intelEngine EvaluatePlayerJoinBattle ::temp0 ::QuestAutoJoinFaction_var ;1 variable args
            assign resultJson ::temp0 
            ; line 888
            assign ::QuestAutoJoinFaction_var "" 
            ; line 890
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "shouldJoin" ;2 variable args
            cmp_eq ::temp1 ::temp0 "true" 
            assign shouldJoin ::temp1 
            ; line 891
            not ::temp1 shouldJoin 
            jmpf ::temp1 _label0
            ; line 892
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Player is a spectator" ;1 variable args
            ; line 893
            return None 
            jmp _label0
            ; line 896
          _label0:
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "joinFaction" ;2 variable args
            assign joinFaction ::temp0 
            ; line 897
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "displayName" ;2 variable args
            assign displayName ::temp0 
            ; line 898
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "isQuestJoin" ;2 variable args
            cmp_eq ::temp1 ::temp0 "true" 
            assign isQuestJoin ::temp1 
            ; line 900
            jmpf isQuestJoin _label1
            ; line 901
            strcat ::temp0 "You join the " displayName 
            strcat ::temp0 ::temp0 " on the field." 
            callstatic debug Notification ::nonevar ::temp0 ;1 variable args
            ; line 902
            callstatic utility Wait ::nonevar 1.0 ;1 variable args
            jmp _label2
            ; line 904
          _label1:
            strcat ::temp0 "The " displayName 
            strcat ::temp0 ::temp0 " soldiers recognize you as an ally." 
            callstatic debug Notification ::nonevar ::temp0 ;1 variable args
            ; line 905
            callstatic utility Wait ::nonevar 2.0 ;1 variable args
            ; line 908
          _label2:
            callmethod JoinBattleSide self ::nonevar joinFaction ;1 variable args
          .endCode
        .endFunction ;EvaluatePlayerJoin
        .function JoinBattleSide
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param factionId String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 String
            .local success Bool
            .local player actor
            .local ::temp2 actor
            .local side String
            .local displayName String
          .endLocalTable
          .code
            ; line 915
            cmp_eq ::temp0 ::PlayerBattleSide_var factionId 
            jmpf ::temp0 _label0
            ; line 916
            return None 
            jmp _label0
            ; line 920
          _label0:
            cmp_eq ::temp0 ::PlayerBattleSide_var "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label1
            ; line 921
            strcat ::temp1 "Battle: Cannot switch sides mid-battle (already on " ::PlayerBattleSide_var 
            strcat ::temp1 ::temp1 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 922
            return None 
            jmp _label1
            ; line 926
          _label1:
            callstatic intelEngine SetPlayerBattleSide ::temp0 factionId ;1 variable args
            assign success ::temp0 
            ; line 927
            not ::temp0 success 
            jmpf ::temp0 _label2
            ; line 928
            strcat ::temp1 "Battle: JoinBattleSide failed for " factionId 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 929
            return None 
            jmp _label2
            ; line 932
          _label2:
            assign ::PlayerBattleSide_var factionId 
            ; line 936
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign player ::temp2 
            ; line 937
            callstatic intelEngine GetFactionBattleSide ::temp1 factionId ;1 variable args
            assign side ::temp1 
            ; line 938
            cmp_eq ::temp0 side "A" 
            jmpf ::temp0 _label3
            ; line 939
            callmethod AddToFaction player ::nonevar ::Intel_BattleSideA_var ;1 variable args
            jmp _label4
            ; line 941
          _label3:
            callmethod AddToFaction player ::nonevar ::Intel_BattleSideB_var ;1 variable args
            ; line 947
          _label4:
            callstatic intelEngine SetBattleSoldiersAsTeammates ::nonevar side ;1 variable args
            ; line 949
            callstatic intelEngine GetFactionDisplayName ::temp1 factionId ;1 variable args
            assign displayName ::temp1 
            ; line 950
            strcat ::temp1 "You fight alongside the " displayName 
            strcat ::temp1 ::temp1 "." 
            callstatic debug Notification ::nonevar ::temp1 ;1 variable args
            ; line 951
            strcat ::temp1 "Battle: Player joined " factionId 
            strcat ::temp1 ::temp1 " (morale boosted)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
          .endCode
        .endFunction ;JoinBattleSide
        .function RemovePlayerFromBattle
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local player actor
            .local ::temp1 actor
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 958
            cmp_eq ::temp0 ::PlayerBattleSide_var "" 
            jmpf ::temp0 _label0
            ; line 959
            return None 
            jmp _label0
            ; line 962
          _label0:
            callstatic game GetPlayer ::temp1 ;0 variable args
            assign player ::temp1 
            ; line 963
            callmethod RemoveFromFaction player ::nonevar ::Intel_BattleSideA_var ;1 variable args
            ; line 964
            callmethod RemoveFromFaction player ::nonevar ::Intel_BattleSideB_var ;1 variable args
            ; line 967
            callstatic intelEngine SetPlayerBattleSide ::temp0 "" ;1 variable args
            ; line 969
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Player removed from battle factions" ;1 variable args
            ; line 970
            assign ::PlayerBattleSide_var "" 
          .endCode
        .endFunction ;RemovePlayerFromBattle
        .function ForceInitialEngagement
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local jsonA String
            .local ::temp0 String
            .local jsonB String
            .local countA Int
            .local ::temp1 Int
            .local countB Int
            .local engageCount Int
            .local ::temp2 Bool
            .local paired Int
            .local i Int
            .local formIdA Int
            .local formIdB Int
            .local soldierA actor
            .local ::temp3 form
            .local ::temp4 actor
            .local soldierB actor
            .local ::nonevar None
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 979
            callstatic intelEngine GetBattleSoldierFormIds ::temp0 "A" ;1 variable args
            assign jsonA ::temp0 
            ; line 980
            callstatic intelEngine GetBattleSoldierFormIds ::temp0 "B" ;1 variable args
            assign jsonB ::temp0 
            ; line 981
            callstatic intelEngine StoryResponseGetField ::temp0 jsonA "count" ;2 variable args
            cast ::temp1 ::temp0 
            assign countA ::temp1 
            ; line 982
            callstatic intelEngine StoryResponseGetField ::temp0 jsonB "count" ;2 variable args
            cast ::temp1 ::temp0 
            assign countB ::temp1 
            ; line 984
            assign engageCount countA 
            ; line 985
            cmp_lt ::temp2 countB engageCount 
            jmpf ::temp2 _label0
            ; line 986
            assign engageCount countB 
            jmp _label0
            ; line 989
          _label0:
            assign paired 0 
            ; line 990
            assign i 0 
            ; line 991
          _label6:
            cmp_lt ::temp2 i engageCount 
            jmpf ::temp2 _label1
            ; line 992
            callstatic intelEngine GetJsonArrayInt ::temp1 jsonA "formIds" i ;3 variable args
            assign formIdA ::temp1 
            ; line 993
            callstatic intelEngine GetJsonArrayInt ::temp1 jsonB "formIds" i ;3 variable args
            assign formIdB ::temp1 
            ; line 994
            callstatic game GetForm ::temp3 formIdA ;1 variable args
            cast ::temp4 ::temp3 
            assign soldierA ::temp4 
            ; line 995
            callstatic game GetForm ::temp3 formIdB ;1 variable args
            cast ::temp4 ::temp3 
            assign soldierB ::temp4 
            ; line 996
            cast ::temp2 soldierA 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label2
            cast ::temp2 soldierB 
            assign ::temp2 ::temp2 
          _label2:
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label3
            callmethod IsDead soldierA ::temp2 ;0 variable args
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label3:
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label4
            callmethod IsDead soldierB ::temp2 ;0 variable args
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label4:
            jmpf ::temp2 _label5
            ; line 997
            callmethod StartCombat soldierA ::nonevar soldierB ;1 variable args
            ; line 998
            callmethod StartCombat soldierB ::nonevar soldierA ;1 variable args
            ; line 999
            iadd ::temp1 paired 1 
            assign paired ::temp1 
            jmp _label5
            ; line 1001
          _label5:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label6
            ; line 1003
          _label1:
            cast ::temp0 paired 
            strcat ::temp0 "Battle: Kick-started " ::temp0 
            strcat ::temp0 ::temp0 "/" 
            cast ::temp5 engageCount 
            strcat ::temp5 ::temp0 ::temp5 
            strcat ::temp5 ::temp5 " combat pairs, " 
            cast ::temp0 countA 
            strcat ::temp0 ::temp5 ::temp0 
            strcat ::temp0 ::temp0 " vs " 
            cast ::temp5 countB 
            strcat ::temp5 ::temp0 ::temp5 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
          .endCode
        .endFunction ;ForceInitialEngagement
        .function PostBattleSoldierMoment
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param playerFaction String
            .param victorName String
            .param playerWon Bool
          .endParamTable
          .localTable
            .local side String
            .local ::temp0 Bool
            .local json String
            .local ::temp1 String
            .local count Int
            .local ::temp2 Int
            .local survivor actor
            .local ::temp3 actor
            .local i Int
            .local formId Int
            .local soldier actor
            .local ::temp4 form
            .local noSurvivorType String
            .local ::nonevar None
            .local player actor
            .local ::temp5 objectReference
            .local waitTime Float
            .local ::temp6 Float
            .local dialogueType String
          .endLocalTable
          .code
            ; line 1022
            assign side "A" 
            ; line 1023
            cmp_eq ::temp0 playerFaction ::BattleFactionA_var 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 1024
            assign side "B" 
            jmp _label0
            ; line 1026
          _label0:
            callstatic intelEngine GetBattleSoldierFormIds ::temp1 side ;1 variable args
            assign json ::temp1 
            ; line 1027
            callstatic intelEngine StoryResponseGetField ::temp1 json "count" ;2 variable args
            cast ::temp2 ::temp1 
            assign count ::temp2 
            ; line 1028
            cast ::temp3 None 
            assign survivor ::temp3 
            ; line 1029
            assign i 0 
            ; line 1030
          _label5:
            cmp_lt ::temp0 i count 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label1
            not ::temp0 survivor 
            assign ::temp0 ::temp0 
          _label1:
            jmpf ::temp0 _label2
            ; line 1031
            callstatic intelEngine GetJsonArrayInt ::temp2 json "formIds" i ;3 variable args
            assign formId ::temp2 
            ; line 1032
            callstatic game GetForm ::temp4 formId ;1 variable args
            cast ::temp3 ::temp4 
            assign soldier ::temp3 
            ; line 1033
            cast ::temp0 soldier 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            callmethod IsDead soldier ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 1034
            assign survivor soldier 
            jmp _label4
            ; line 1036
          _label4:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label5
            ; line 1038
          _label2:
            not ::temp0 survivor 
            jmpf ::temp0 _label6
            ; line 1040
            assign noSurvivorType "no_survivor_win" 
            ; line 1041
            not ::temp0 playerWon 
            jmpf ::temp0 _label7
            ; line 1042
            assign noSurvivorType "no_survivor_loss" 
            jmp _label7
            ; line 1044
          _label7:
            callstatic intelEngine GetBattleNotification ::temp1 noSurvivorType "" "" False ;4 variable args
            callstatic debug Notification ::nonevar ::temp1 ;1 variable args
            ; line 1045
            return None 
            jmp _label6
            ; line 1048
          _label6:
            callstatic game GetPlayer ::temp3 ;0 variable args
            assign player ::temp3 
            ; line 1049
            callmethod SetActorValue survivor ::nonevar "SpeedMult" 70.0 ;2 variable args
            ; line 1050
            cast ::temp5 player 
            callmethod PathToReference survivor ::temp0 ::temp5 1.0 ;2 variable args
            ; line 1051
            assign waitTime 0.0 
            ; line 1052
          _label10:
            cmp_lt ::temp0 waitTime 8.0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label8
            cast ::temp5 player 
            callmethod GetDistance survivor ::temp6 ::temp5 ;1 variable args
            cmp_gt ::temp0 ::temp6 200.0 
            assign ::temp0 ::temp0 
          _label8:
            jmpf ::temp0 _label9
            ; line 1053
            callstatic utility Wait ::nonevar 1.0 ;1 variable args
            ; line 1054
            fadd ::temp6 waitTime 1.0 
            assign waitTime ::temp6 
            jmp _label10
            ; line 1057
          _label9:
            assign dialogueType "soldier_victory" 
            ; line 1058
            not ::temp0 playerWon 
            jmpf ::temp0 _label11
            ; line 1059
            assign dialogueType "soldier_defeat" 
            jmp _label11
            ; line 1061
          _label11:
            callstatic intelEngine GetBattleNotification ::temp1 dialogueType "" victorName playerWon ;4 variable args
            strcat ::temp1 "\"" ::temp1 
            strcat ::temp1 ::temp1 "\"" 
            callstatic debug Notification ::nonevar ::temp1 ;1 variable args
            ; line 1062
            callmethod SetActorValue survivor ::nonevar "SpeedMult" 100.0 ;2 variable args
            ; line 1063
            callmethod GetDisplayName survivor ::temp1 ;0 variable args
            strcat ::temp1 "Battle: Post-battle soldier moment — " ::temp1 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
          .endCode
        .endFunction ;PostBattleSoldierMoment
        .function HandlePollResult
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param stateJson String
          .endParamTable
          .localTable
            .local battleOver Bool
            .local ::temp0 String
            .local ::temp1 Bool
            .local result String
            .local victor String
            .local shouldSpawnA Bool
            .local shouldSpawnB Bool
            .local cppWave Int
            .local ::temp2 Int
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1072
            callstatic intelEngine StoryResponseGetField ::temp0 stateJson "battle_over" ;2 variable args
            cmp_eq ::temp1 ::temp0 "true" 
            assign battleOver ::temp1 
            ; line 1073
            callstatic intelEngine StoryResponseGetField ::temp0 stateJson "result" ;2 variable args
            assign result ::temp0 
            ; line 1074
            callstatic intelEngine StoryResponseGetField ::temp0 stateJson "victor" ;2 variable args
            assign victor ::temp0 
            ; line 1077
            not ::temp1 battleOver 
            jmpf ::temp1 _label0
            ; line 1078
            callstatic intelEngine StoryResponseGetField ::temp0 stateJson "should_spawn_wave_a" ;2 variable args
            cmp_eq ::temp1 ::temp0 "true" 
            assign shouldSpawnA ::temp1 
            ; line 1079
            callstatic intelEngine StoryResponseGetField ::temp0 stateJson "should_spawn_wave_b" ;2 variable args
            cmp_eq ::temp1 ::temp0 "true" 
            assign shouldSpawnB ::temp1 
            ; line 1081
            callstatic intelEngine GetBattleCurrentWave ::temp2 ;0 variable args
            assign cppWave ::temp2 
            ; line 1082
            assign ::temp1 shouldSpawnA 
            jmpt ::temp1 _label1
            assign ::temp1 shouldSpawnB 
          _label1:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            cmp_lt ::temp1 cppWave 5 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 1083
            iadd ::temp2 cppWave 1 
            callmethod SpawnWave self ::nonevar ::temp2 ;1 variable args
            jmp _label3
          _label3:
            jmp _label0
            ; line 1088
          _label0:
            jmpf battleOver _label4
            ; line 1089
            callmethod HandleBattleEnd self ::nonevar result victor stateJson ;3 variable args
            jmp _label4
          _label4
          .endCode
        .endFunction ;HandlePollResult
        .function HandleBattleEnd
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param result String
            .param victor String
            .param stateJson String
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local lossesA Int
            .local ::temp1 Int
            .local lossesB Int
            .local resultJson String
            .local ::temp2 Float
            .local playerSideWas String
            .local playerWon Bool
            .local ::temp3 Bool
            .local notification String
            .local spectatorNotif String
            .local witnessFact String
            .local player actor
            .local ::temp4 actor
            .local witnesses actor[]
            .local ::temp5 objectReference
            .local ::temp6 actor[]
            .local i Int
            .local ::temp7 actor
            .local victorName String
          .endLocalTable
          .code
            ; line 1098
            strcat ::temp0 "Battle: Ended — result=" result 
            strcat ::temp0 ::temp0 ", victor=" 
            strcat ::temp0 ::temp0 victor 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 1101
            callmethod UnregisterForUpdate self ::nonevar ;0 variable args
            ; line 1104
            callstatic intelEngine CountDeadBattleSoldiers ::temp1 "A" ;1 variable args
            assign lossesA ::temp1 
            ; line 1105
            callstatic intelEngine CountDeadBattleSoldiers ::temp1 "B" ;1 variable args
            assign lossesB ::temp1 
            ; line 1110
            callstatic utility GetCurrentGameTime ::temp2 ;0 variable args
            callstatic intelEngine FinalizeBattle ::temp0 ::ActiveBattleId_var result victor lossesA lossesB ::BattleLocationName_var ::temp2 ;7 variable args
            assign resultJson ::temp0 
            ; line 1117
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "playerSideWas" ;2 variable args
            assign playerSideWas ::temp0 
            ; line 1118
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "playerWon" ;2 variable args
            cmp_eq ::temp3 ::temp0 "true" 
            assign playerWon ::temp3 
            ; line 1119
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "notification" ;2 variable args
            assign notification ::temp0 
            ; line 1120
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "spectatorNotification" ;2 variable args
            assign spectatorNotif ::temp0 
            ; line 1121
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "witnessFact" ;2 variable args
            assign witnessFact ::temp0 
            ; line 1124
            cmp_eq ::temp3 witnessFact "" 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label0
            ; line 1125
            callstatic game GetPlayer ::temp4 ;0 variable args
            assign player ::temp4 
            ; line 1126
            cast ::temp5 player 
            callstatic intelEngine GetNearbyWitnessNPCs ::temp6 ::temp5 5000.0 ;2 variable args
            assign witnesses ::temp6 
            ; line 1127
            assign i 0 
            ; line 1128
          _label3:
            array_length ::temp1 witnesses 
            cmp_lt ::temp3 i ::temp1 
            jmpf ::temp3 _label1
            ; line 1129
            array_getlement ::temp4 witnesses i 
            cast ::temp7 None 
            cmp_eq ::temp3 ::temp4 ::temp7 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label2
            ; line 1130
            array_getlement ::temp7 witnesses i 
            callmethod InjectFact ::Core_var ::nonevar ::temp7 witnessFact ;2 variable args
            jmp _label2
            ; line 1132
          _label2:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label3
          _label1:
            jmp _label0
            ; line 1137
          _label0:
            callstatic utility RandomFloat ::temp2 0.0 1.5 ;2 variable args
            fadd ::temp2 2.0 ::temp2 
            callstatic utility Wait ::nonevar ::temp2 ;1 variable args
            ; line 1140
            cmp_eq ::temp3 notification "" 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label4
            ; line 1141
            callstatic debug Notification ::nonevar notification ;1 variable args
            jmp _label4
            ; line 1143
          _label4:
            cmp_eq ::temp3 spectatorNotif "" 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label5
            ; line 1144
            callstatic utility Wait ::nonevar 1.5 ;1 variable args
            ; line 1145
            callstatic debug Notification ::nonevar spectatorNotif ;1 variable args
            jmp _label5
            ; line 1149
          _label5:
            cmp_eq ::temp3 playerSideWas "" 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label6
            ; line 1150
            callstatic intelEngine StoryResponseGetField ::temp0 resultJson "victorName" ;2 variable args
            assign victorName ::temp0 
            ; line 1151
            callmethod PostBattleSoldierMoment self ::nonevar playerSideWas victorName playerWon ;3 variable args
            jmp _label6
            ; line 1155
          _label6:
            assign ::DeferredCleanupActive_var True 
            ; line 1156
            callstatic utility GetCurrentRealTime ::temp2 ;0 variable args
            assign ::DeferredCleanupStart_var ::temp2 
            ; line 1157
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
          .endCode
        .endFunction ;HandleBattleEnd
        .function CleanupAllActors
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
            ; line 1172
            callstatic intelEngine ForceCleanupAllSoldiers ::nonevar ;0 variable args
          .endCode
        .endFunction ;CleanupAllActors
        .function CleanupMarkers
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 objectReference
          .endLocalTable
          .code
            ; line 1178
            cast ::temp0 ::CenterMarker_var 
            jmpf ::temp0 _label0
            ; line 1179
            callmethod DisableNoWait ::CenterMarker_var ::nonevar False ;1 variable args
            ; line 1180
            callmethod Delete ::CenterMarker_var ::nonevar ;0 variable args
            ; line 1181
            cast ::temp1 None 
            assign ::CenterMarker_var ::temp1 
            jmp _label0
            ; line 1183
          _label0:
            cast ::temp0 ::RallyMarkerA_var 
            jmpf ::temp0 _label1
            ; line 1184
            callmethod DisableNoWait ::RallyMarkerA_var ::nonevar False ;1 variable args
            ; line 1185
            callmethod Delete ::RallyMarkerA_var ::nonevar ;0 variable args
            ; line 1186
            cast ::temp1 None 
            assign ::RallyMarkerA_var ::temp1 
            jmp _label1
            ; line 1188
          _label1:
            cast ::temp0 ::RallyMarkerB_var 
            jmpf ::temp0 _label2
            ; line 1189
            callmethod DisableNoWait ::RallyMarkerB_var ::nonevar False ;1 variable args
            ; line 1190
            callmethod Delete ::RallyMarkerB_var ::nonevar ;0 variable args
            ; line 1191
            cast ::temp1 None 
            assign ::RallyMarkerB_var ::temp1 
            jmp _label2
          _label2
          .endCode
        .endFunction ;CleanupMarkers
        .function ResetState
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 objectReference
            .local ::temp1 actor
            .local ::temp2 Bool
          .endLocalTable
          .code
            ; line 1197
            callstatic intelEngine ResetBattleState ::nonevar ;0 variable args
            ; line 1199
            assign ::BattleFactionA_var "" 
            ; line 1200
            assign ::BattleFactionB_var "" 
            ; line 1201
            assign ::BattleWarId_var 0 
            ; line 1202
            assign ::ScheduledBattleTime_var 0.0 
            ; line 1203
            assign ::BattleScheduled_var False 
            ; line 1204
            assign ::BattleSpawned_var False 
            ; line 1205
            assign ::ActiveBattleId_var -1 
            ; line 1206
            assign ::BattleLocationName_var "" 
            ; line 1207
            cast ::temp0 None 
            assign ::BattleSpawnAnchor_var ::temp0 
            ; line 1208
            assign ::CurrentWave_var 0 
            ; line 1209
            assign ::ActualBattleStartTime_var 0.0 
            ; line 1210
            assign ::BattleStartRealTime_var 0.0 
            ; line 1211
            assign ::PlayerBattleSide_var "" 
            ; line 1212
            assign ::QuestAutoJoinFaction_var "" 
            ; line 1214
            cast ::temp1 None 
            cmp_eq ::temp2 ::BattleLeader_var ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label0
            ; line 1215
            callmethod SetActorValue ::BattleLeader_var ::nonevar "SpeedMult" 100.0 ;2 variable args
            ; line 1216
            not ::temp2 ::BattleLeaderWasEssential_var 
            jmpf ::temp2 _label1
            ; line 1217
            callstatic intelEngine SetActorProtected ::nonevar ::BattleLeader_var False ;2 variable args
            jmp _label1
            ; line 1219
          _label1:
            cast ::temp1 None 
            assign ::BattleLeader_var ::temp1 
            ; line 1220
            assign ::BattleLeaderWasEssential_var False 
            jmp _label0
            ; line 1222
          _label0:
            assign ::DeferredCleanupActive_var False 
            ; line 1223
            assign ::DeferredCleanupStart_var 0.0 
            ; line 1224
            callmethod UnregisterForUpdate self ::nonevar ;0 variable args
            ; line 1225
            callmethod UnregisterForUpdateGameTime self ::nonevar ;0 variable args
          .endCode
        .endFunction ;ResetState
        .function ManifestEvent
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param manifestJson String
          .endParamTable
          .localTable
            .local stuckTime Float
            .local ::temp0 Float
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 String
            .local ::temp3 intelEngine_Core
            .local ::temp4 intelEngine_StoryEngine
            .local ::temp5 intelEngine_StoryEngine
            .local manifestEventType String
            .local eventType String
            .local attackerFaction String
            .local targetFaction String
            .local spawnCount Int
            .local ::temp6 Int
            .local spawnDefenders Bool
            .local defenderCount Int
            .local player actor
            .local ::temp7 actor
            .local ::temp8 actor[]
            .local playerAngle Float
            .local spawnFaction String
            .local i Int
            .local attackCap Int
            .local attackers actor[]
            .local ::temp9 String
            .local ::temp10 objectReference
            .local angle Float
            .local ::temp11 Float
            .local dist Float
            .local offsetX Float
            .local offsetY Float
            .local ::mangled_offsetX_0 Float
            .local ::mangled_offsetY_0 Float
            .local assassin actor
            .local assTarget actor
            .local leaderName String
            .local slot Int
            .local ::mangled_angle_0 Float
            .local ::mangled_offsetX_1 Float
            .local ::mangled_offsetY_1 Float
            .local ::temp12 form
            .local ::temp13 form
            .local ::temp14 objectReference
            .local ::temp15 keyword
            .local ::temp16 package
            .local defStart Int
            .local defCap Int
            .local defenders actor[]
            .local ::mangled_angle_1 Float
            .local ::mangled_dist_0 Float
            .local ::mangled_offsetX_2 Float
            .local ::mangled_offsetY_2 Float
            .local ::temp17 actor
            .local k Int
            .local nameA String
            .local nameB String
          .endLocalTable
          .code
            ; line 1235
            jmpf ::ManifestActive_var _label0
            ; line 1236
            callstatic utility GetCurrentRealTime ::temp0 ;0 variable args
            fsub ::temp0 ::temp0 ::ManifestStartTime_var 
            assign stuckTime ::temp0 
            ; line 1237
            cmp_gt ::temp1 stuckTime 120.0 
            jmpf ::temp1 _label1
            ; line 1238
            cast ::temp2 stuckTime 
            strcat ::temp2 "Battle: ManifestActive stuck for " ::temp2 
            strcat ::temp2 ::temp2 "s — force-clearing" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 1239
            callmethod CleanupManifestation self ::nonevar ;0 variable args
            jmp _label2
            ; line 1241
          _label1:
            cast ::temp2 stuckTime 
            strcat ::temp2 "Battle: Cannot manifest — manifestation already active (" ::temp2 
            strcat ::temp2 ::temp2 "s)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 1242
            return None 
          _label2:
            jmp _label0
            ; line 1245
          _label0:
            callstatic intelEngine IsBattleActive ::temp1 ;0 variable args
            jmpf ::temp1 _label3
            ; line 1246
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Cannot manifest — battle active" ;1 variable args
            ; line 1247
            return None 
            jmp _label3
            ; line 1249
          _label3:
            cast ::temp3 None 
            cmp_eq ::temp1 ::Core_var ::temp3 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label4
            propget StoryEngine ::Core_var ::temp4 
            cast ::temp5 None 
            cmp_eq ::temp1 ::temp4 ::temp5 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label4:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label5
            propget StoryEngine ::Core_var ::temp5 
            propget FactionAmbushActive ::temp5 ::temp1 
            assign ::temp1 ::temp1 
          _label5:
            jmpf ::temp1 _label6
            ; line 1250
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Cannot manifest — faction ambush already active" ;1 variable args
            ; line 1251
            return None 
            jmp _label6
            ; line 1256
          _label6:
            callstatic intelEngine StoryResponseGetField ::temp2 manifestJson "event_type" ;2 variable args
            assign manifestEventType ::temp2 
            ; line 1257
            callmethod IsPlayerInExterior self ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label7
            cmp_eq ::temp1 manifestEventType "assassination_attempt" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label7:
            jmpf ::temp1 _label8
            ; line 1258
            strcat ::temp2 "Battle: Cannot manifest — player is indoors (" manifestEventType 
            strcat ::temp2 ::temp2 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 1259
            return None 
            jmp _label8
            ; line 1263
          _label8:
            callstatic intelEngine StoryResponseGetField ::temp2 manifestJson "event_type" ;2 variable args
            assign eventType ::temp2 
            ; line 1264
            callstatic intelEngine StoryResponseGetField ::temp2 manifestJson "attacker_faction" ;2 variable args
            assign attackerFaction ::temp2 
            ; line 1265
            callstatic intelEngine StoryResponseGetField ::temp2 manifestJson "target_faction" ;2 variable args
            assign targetFaction ::temp2 
            ; line 1266
            callstatic intelEngine StoryResponseGetField ::temp2 manifestJson "spawn_count" ;2 variable args
            cast ::temp6 ::temp2 
            assign spawnCount ::temp6 
            ; line 1267
            callstatic intelEngine StoryResponseGetField ::temp2 manifestJson "spawn_defenders" ;2 variable args
            cmp_eq ::temp1 ::temp2 "true" 
            assign spawnDefenders ::temp1 
            ; line 1268
            callstatic intelEngine StoryResponseGetField ::temp2 manifestJson "defender_count" ;2 variable args
            cast ::temp6 ::temp2 
            assign defenderCount ::temp6 
            ; line 1270
            cmp_eq ::temp1 attackerFaction "" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label9
            cmp_lte ::temp1 spawnCount 0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label10
            cmp_eq ::temp1 eventType "assassination_attempt" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label10:
            assign ::temp1 ::temp1 
          _label9:
            jmpf ::temp1 _label11
            ; line 1271
            return None 
            jmp _label11
            ; line 1274
          _label11:
            callstatic game GetPlayer ::temp7 ;0 variable args
            assign player ::temp7 
            ; line 1275
            array_create ::temp8 12 
            assign ::ManifestActors_var ::temp8 
            ; line 1276
            assign ::ManifestCount_var 0 
            ; line 1279
            callmethod GetAngleZ player ::temp0 ;0 variable args
            assign playerAngle ::temp0 
            ; line 1282
            assign spawnFaction attackerFaction 
            ; line 1284
            assign i 0 
            ; line 1287
            cmp_eq ::temp1 eventType "assassination_attempt" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label12
            ; line 1289
            isub ::temp6 12 ::ManifestCount_var 
            assign attackCap ::temp6 
            ; line 1290
            cmp_lt ::temp1 spawnCount attackCap 
            jmpf ::temp1 _label13
            ; line 1291
            assign attackCap spawnCount 
            jmp _label13
            ; line 1293
          _label13:
            strcat ::temp2 spawnFaction ":" 
            cast ::temp9 attackCap 
            strcat ::temp9 ::temp2 ::temp9 
            cast ::temp10 player 
            callstatic intelEngine SpawnBattleSoldiers ::temp8 ::temp9 ::temp10 ;2 variable args
            assign attackers ::temp8 
            ; line 1295
            assign i 0 
            ; line 1296
          _label18:
            array_length ::temp6 attackers 
            cmp_lt ::temp1 i ::temp6 
            jmpf ::temp1 _label14
            ; line 1297
            array_getlement ::temp7 attackers i 
            cast ::temp1 ::temp7 
            jmpf ::temp1 _label15
            ; line 1298
            callmethod IsPlayerInExterior self ::temp1 ;0 variable args
            jmpf ::temp1 _label16
            ; line 1299
            fadd ::temp0 playerAngle 180.0 
            callstatic utility RandomFloat ::temp11 -60.0 60.0 ;2 variable args
            fadd ::temp11 ::temp0 ::temp11 
            assign angle ::temp11 
            ; line 1300
            callstatic utility RandomFloat ::temp11 1500.0 2500.0 ;2 variable args
            assign dist ::temp11 
            ; line 1301
            callstatic math sin ::temp11 angle ;1 variable args
            fmul ::temp11 ::temp11 dist 
            assign offsetX ::temp11 
            ; line 1302
            callstatic math cos ::temp11 angle ;1 variable args
            fmul ::temp11 ::temp11 dist 
            assign offsetY ::temp11 
            ; line 1303
            cast ::temp10 player 
            array_getlement ::temp7 attackers i 
            callmethod MoveTo ::temp7 ::nonevar ::temp10 offsetX offsetY 0.0 True ;5 variable args
            jmp _label17
            ; line 1305
          _label16:
            callstatic utility RandomFloat ::temp11 -200.0 200.0 ;2 variable args
            assign ::mangled_offsetX_0 ::temp11 
            ; line 1306
            callstatic utility RandomFloat ::temp11 -200.0 200.0 ;2 variable args
            assign ::mangled_offsetY_0 ::temp11 
            ; line 1307
            cast ::temp10 player 
            array_getlement ::temp7 attackers i 
            callmethod MoveTo ::temp7 ::nonevar ::temp10 ::mangled_offsetX_0 ::mangled_offsetY_0 0.0 True ;5 variable args
            ; line 1310
          _label17:
            array_getlement ::temp7 attackers i 
            callmethod AddToFaction ::temp7 ::nonevar ::Intel_BattleSideB_var ;1 variable args
            ; line 1311
            array_getlement ::temp7 attackers i 
            array_setelement ::ManifestActors_var ::ManifestCount_var ::temp7 
            ; line 1312
            iadd ::temp6 ::ManifestCount_var 1 
            assign ::ManifestCount_var ::temp6 
            jmp _label15
            ; line 1314
          _label15:
            iadd ::temp6 i 1 
            assign i ::temp6 
            jmp _label18
            ; line 1317
          _label14:
            cmp_eq ::temp1 ::ManifestCount_var 0 
            jmpf ::temp1 _label19
            ; line 1318
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Manifest failed — no attackers spawned" ;1 variable args
            ; line 1319
            return None 
            jmp _label19
          _label19:
            jmp _label12
            ; line 1324
          _label12:
            cmp_eq ::temp1 eventType "assassination_attempt" 
            jmpf ::temp1 _label20
            ; line 1327
            callstatic intelEngine ExecuteAssassination ::temp7 targetFaction attackerFaction ;2 variable args
            assign assassin ::temp7 
            ; line 1328
            cast ::temp7 None 
            cmp_eq ::temp1 assassin ::temp7 
            jmpf ::temp1 _label21
            ; line 1329
            callmethod DebugMsg ::Core_var ::nonevar "Battle: ExecuteAssassination failed — no assassin returned" ;1 variable args
            ; line 1330
            assign ::ManifestActive_var False 
            ; line 1331
            return None 
            jmp _label21
            ; line 1334
          _label21:
            callstatic intelEngine GetAssassinationTarget ::temp7 ;0 variable args
            assign assTarget ::temp7 
            ; line 1335
            callstatic intelEngine GetAssassinationLeaderName ::temp9 ;0 variable args
            assign leaderName ::temp9 
            ; line 1336
            cast ::temp7 None 
            cmp_eq ::temp1 assTarget ::temp7 
            jmpf ::temp1 _label22
            ; line 1337
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Assassination target not found — aborting" ;1 variable args
            ; line 1338
            callmethod DisableNoWait assassin ::nonevar False ;1 variable args
            ; line 1339
            callmethod Delete assassin ::nonevar ;0 variable args
            ; line 1340
            assign ::ManifestActive_var False 
            ; line 1341
            return None 
            jmp _label22
            ; line 1344
          _label22:
            propget StoryEngine ::Core_var ::temp5 
            callmethod IEB_StoryBlocked ::temp5 ::temp1 assTarget 2 ;2 variable args
            jmpf ::temp1 _label23
            ; line 1345
            strcat ::temp9 "Battle: assassination target " leaderName 
            strcat ::temp9 ::temp9 " is committed to a quest -- aborting" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            ; line 1346
            callmethod DisableNoWait assassin ::nonevar False ;1 variable args
            ; line 1347
            callmethod Delete assassin ::nonevar ;0 variable args
            ; line 1348
            assign ::ManifestActive_var False 
            ; line 1349
            return None 
            jmp _label23
            ; line 1352
          _label23:
            assign ::ManifestLeaderTarget_var assTarget 
            ; line 1355
            callmethod FindFreeAgentSlot ::Core_var ::temp6 ;0 variable args
            assign slot ::temp6 
            ; line 1356
            cmp_lt ::temp1 slot 0 
            jmpf ::temp1 _label24
            ; line 1357
            callmethod DebugMsg ::Core_var ::nonevar "Battle: No free task slot for assassin — aborting" ;1 variable args
            ; line 1358
            callmethod DisableNoWait assassin ::nonevar False ;1 variable args
            ; line 1359
            callmethod Delete assassin ::nonevar ;0 variable args
            ; line 1360
            assign ::ManifestActive_var False 
            ; line 1361
            return None 
            jmp _label24
            ; line 1365
          _label24:
            array_setelement ::ManifestActors_var 0 assassin 
            ; line 1366
            assign ::ManifestCount_var 1 
            ; line 1369
            callmethod IsPlayerInExterior self ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label25
            cast ::temp10 assTarget 
            callmethod GetDistance assassin ::temp11 ::temp10 ;1 variable args
            cmp_lt ::temp1 ::temp11 100.0 
            assign ::temp1 ::temp1 
          _label25:
            jmpf ::temp1 _label26
            ; line 1370
            callmethod GetAngleZ assTarget ::temp11 ;0 variable args
            fadd ::temp11 ::temp11 180.0 
            callstatic utility RandomFloat ::temp0 -30.0 30.0 ;2 variable args
            fadd ::temp0 ::temp11 ::temp0 
            assign ::mangled_angle_0 ::temp0 
            ; line 1371
            callstatic math sin ::temp0 ::mangled_angle_0 ;1 variable args
            fmul ::temp0 ::temp0 500.0 
            assign ::mangled_offsetX_1 ::temp0 
            ; line 1372
            callstatic math cos ::temp0 ::mangled_angle_0 ;1 variable args
            fmul ::temp0 ::temp0 500.0 
            assign ::mangled_offsetY_1 ::temp0 
            ; line 1373
            cast ::temp10 assTarget 
            callmethod MoveTo assassin ::nonevar ::temp10 ::mangled_offsetX_1 ::mangled_offsetY_1 0.0 True ;5 variable args
            jmp _label26
            ; line 1377
          _label26:
            callmethod AllocateSlot ::Core_var ::nonevar slot assassin "assassination" leaderName 0 ;5 variable args
            ; line 1381
            cast ::temp12 assassin 
            cast ::temp10 assTarget 
            cast ::temp13 ::temp10 
            callstatic storageUtil SetFormValue ::temp13 ::temp12 "Intel_DestMarker" ::temp13 ;3 variable args
            ; line 1382
            cast ::temp10 assassin 
            cast ::temp14 assTarget 
            propget IntelEngine_TravelTarget ::Core_var ::temp15 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp10 ::temp14 ::temp15 ;3 variable args
            ; line 1383
            propget TravelPackage_Walk ::Core_var ::temp16 
            propget PRIORITY_TRAVEL ::Core_var ::temp6 
            callstatic actorUtil AddPackageOverride ::nonevar assassin ::temp16 ::temp6 1 ;4 variable args
            ; line 1384
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 1385
            callmethod EvaluatePackage assassin ::nonevar ;0 variable args
            ; line 1387
            callmethod GetDisplayName assassin ::temp9 ;0 variable args
            strcat ::temp9 "Battle: Assassin " ::temp9 
            strcat ::temp9 ::temp9 " walking toward " 
            strcat ::temp9 ::temp9 leaderName 
            strcat ::temp9 ::temp9 " (slot " 
            cast ::temp2 slot 
            strcat ::temp2 ::temp9 ::temp2 
            strcat ::temp2 ::temp2 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            jmp _label27
            ; line 1390
          _label20:
            assign ::temp1 spawnDefenders 
            jmpf ::temp1 _label28
            cmp_gt ::temp1 defenderCount 0 
            assign ::temp1 ::temp1 
          _label28:
            jmpf ::temp1 _label27
            ; line 1392
            assign defStart ::ManifestCount_var 
            ; line 1393
            isub ::temp6 12 ::ManifestCount_var 
            assign defCap ::temp6 
            ; line 1394
            cmp_lt ::temp1 defenderCount defCap 
            jmpf ::temp1 _label29
            ; line 1395
            assign defCap defenderCount 
            jmp _label29
            ; line 1397
          _label29:
            strcat ::temp2 targetFaction ":" 
            cast ::temp9 defCap 
            strcat ::temp9 ::temp2 ::temp9 
            cast ::temp14 player 
            callstatic intelEngine SpawnBattleSoldiers ::temp8 ::temp9 ::temp14 ;2 variable args
            assign defenders ::temp8 
            ; line 1399
            assign i 0 
            ; line 1400
          _label32:
            array_length ::temp6 defenders 
            cmp_lt ::temp1 i ::temp6 
            jmpf ::temp1 _label30
            ; line 1401
            array_getlement ::temp7 defenders i 
            cast ::temp1 ::temp7 
            jmpf ::temp1 _label31
            ; line 1403
            callstatic utility RandomFloat ::temp0 -45.0 45.0 ;2 variable args
            fadd ::temp0 playerAngle ::temp0 
            assign ::mangled_angle_1 ::temp0 
            ; line 1404
            callstatic utility RandomFloat ::temp0 800.0 1200.0 ;2 variable args
            assign ::mangled_dist_0 ::temp0 
            ; line 1405
            callstatic math sin ::temp0 ::mangled_angle_1 ;1 variable args
            fmul ::temp0 ::temp0 ::mangled_dist_0 
            assign ::mangled_offsetX_2 ::temp0 
            ; line 1406
            callstatic math cos ::temp0 ::mangled_angle_1 ;1 variable args
            fmul ::temp0 ::temp0 ::mangled_dist_0 
            assign ::mangled_offsetY_2 ::temp0 
            ; line 1407
            cast ::temp14 player 
            array_getlement ::temp7 defenders i 
            callmethod MoveTo ::temp7 ::nonevar ::temp14 ::mangled_offsetX_2 ::mangled_offsetY_2 0.0 True ;5 variable args
            ; line 1408
            array_getlement ::temp7 defenders i 
            callmethod AddToFaction ::temp7 ::nonevar ::Intel_BattleSideB_var ;1 variable args
            ; line 1409
            array_getlement ::temp7 defenders i 
            array_setelement ::ManifestActors_var ::ManifestCount_var ::temp7 
            ; line 1410
            iadd ::temp6 ::ManifestCount_var 1 
            assign ::ManifestCount_var ::temp6 
            jmp _label31
            ; line 1412
          _label31:
            iadd ::temp6 i 1 
            assign i ::temp6 
            jmp _label32
            ; line 1416
          _label30:
            cmp_gt ::temp1 ::ManifestCount_var defStart 
            jmpf ::temp1 _label33
            ; line 1418
            assign i 0 
            ; line 1419
          _label39:
            cmp_lt ::temp1 i defStart 
            jmpf ::temp1 _label34
            ; line 1420
            array_getlement ::temp7 ::ManifestActors_var i 
            cast ::temp17 None 
            cmp_eq ::temp1 ::temp7 ::temp17 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label35
            ; line 1421
            assign k defStart 
            ; line 1422
          _label38:
            cmp_lt ::temp1 k ::ManifestCount_var 
            jmpf ::temp1 _label36
            ; line 1423
            array_getlement ::temp17 ::ManifestActors_var k 
            cast ::temp7 None 
            cmp_eq ::temp1 ::temp17 ::temp7 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label37
            ; line 1424
            array_getlement ::temp7 ::ManifestActors_var k 
            array_getlement ::temp17 ::ManifestActors_var i 
            callmethod StartCombat ::temp17 ::nonevar ::temp7 ;1 variable args
            jmp _label37
            ; line 1426
          _label37:
            iadd ::temp6 k 1 
            assign k ::temp6 
            jmp _label38
          _label36:
            jmp _label35
            ; line 1429
          _label35:
            iadd ::temp6 i 1 
            assign i ::temp6 
            jmp _label39
            ; line 1431
          _label34:
            callstatic intelEngine ConfirmManifestationCooldown ::nonevar ;0 variable args
            ; line 1432
            strcat ::temp9 "Battle: Manifest " eventType 
            strcat ::temp9 ::temp9 " — " 
            cast ::temp2 defStart 
            strcat ::temp2 ::temp9 ::temp2 
            strcat ::temp2 ::temp2 " vs " 
            isub ::temp6 ::ManifestCount_var defStart 
            cast ::temp9 ::temp6 
            strcat ::temp9 ::temp2 ::temp9 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            jmp _label40
            ; line 1435
          _label33:
            strcat ::temp9 "Battle: Manifest " eventType 
            strcat ::temp9 ::temp9 " — no defenders spawned, aborting" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            ; line 1436
            assign i 0 
            ; line 1437
          _label43:
            cmp_lt ::temp1 i ::ManifestCount_var 
            jmpf ::temp1 _label41
            ; line 1438
            array_getlement ::temp7 ::ManifestActors_var i 
            cast ::temp17 None 
            cmp_eq ::temp1 ::temp7 ::temp17 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label42
            ; line 1439
            array_getlement ::temp17 ::ManifestActors_var i 
            callmethod DisableNoWait ::temp17 ::nonevar False ;1 variable args
            ; line 1440
            array_getlement ::temp17 ::ManifestActors_var i 
            callmethod Delete ::temp17 ::nonevar ;0 variable args
            ; line 1441
            cast ::temp17 None 
            array_setelement ::ManifestActors_var i ::temp17 
            jmp _label42
            ; line 1443
          _label42:
            iadd ::temp6 i 1 
            assign i ::temp6 
            jmp _label43
            ; line 1445
          _label41:
            assign ::ManifestCount_var 0 
            ; line 1446
            assign ::ManifestActive_var False 
            ; line 1447
            return None 
          _label40:
            jmp _label27
            ; line 1452
          _label27:
            callstatic intelEngine GetFactionDisplayName ::temp9 attackerFaction ;1 variable args
            assign nameA ::temp9 
            ; line 1453
            callstatic intelEngine GetFactionDisplayName ::temp9 targetFaction ;1 variable args
            assign nameB ::temp9 
            ; line 1454
            cmp_eq ::temp1 eventType "brawl" 
            jmpf ::temp1 _label44
            ; line 1455
            strcat ::temp9 "A brawl erupts between " nameA 
            strcat ::temp9 ::temp9 " and " 
            strcat ::temp9 ::temp9 nameB 
            strcat ::temp9 ::temp9 "!" 
            callstatic debug Notification ::nonevar ::temp9 ;1 variable args
            jmp _label45
            ; line 1456
          _label44:
            cmp_eq ::temp1 eventType "border_skirmish" 
            jmpf ::temp1 _label45
            ; line 1457
            strcat ::temp9 nameA " skirmishers clash with " 
            strcat ::temp9 ::temp9 nameB 
            strcat ::temp9 ::temp9 " forces!" 
            callstatic debug Notification ::nonevar ::temp9 ;1 variable args
            jmp _label45
            ; line 1460
          _label45:
            assign ::ManifestActive_var True 
            ; line 1461
            callstatic utility GetCurrentRealTime ::temp0 ;0 variable args
            assign ::ManifestStartTime_var ::temp0 
            ; line 1462
            callmethod RegisterForSingleUpdate self ::nonevar ::PollInterval_var ;1 variable args
          .endCode
        .endFunction ;ManifestEvent
        .function HandleAssassinArrival
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param assassin actor
            .param targetName String
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local player actor
            .local ::temp1 actor
            .local target actor
            .local ::temp2 Bool
            .local nearbyNPCs actor[]
            .local ::temp3 objectReference
            .local ::temp4 actor[]
            .local witness actor
            .local ni Int
            .local ::temp5 Int
            .local ::temp6 actor
            .local ::temp7 Float
            .local infiltrationFact String
            .local witnesses actor[]
            .local wi Int
            .local eventWitness actor
          .endLocalTable
          .code
            ; line 1469
            jmpf ::ManifestAssassinAttacked_var _label0
            ; line 1470
            return None 
            jmp _label0
            ; line 1472
          _label0:
            assign ::ManifestAssassinAttacked_var True 
            ; line 1474
            callmethod GetDisplayName assassin ::temp0 ;0 variable args
            strcat ::temp0 "Battle: Assassin " ::temp0 
            strcat ::temp0 ::temp0 " reached " 
            strcat ::temp0 ::temp0 targetName 
            strcat ::temp0 ::temp0 " — beginning buildup" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 1476
            callstatic game GetPlayer ::temp1 ;0 variable args
            assign player ::temp1 
            ; line 1477
            assign target ::ManifestLeaderTarget_var 
            ; line 1480
            cast ::temp1 None 
            cmp_eq ::temp2 target ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label1
            ; line 1481
            cast ::temp3 player 
            callstatic intelEngine GetNearbyWitnessNPCs ::temp4 ::temp3 2000.0 ;2 variable args
            assign nearbyNPCs ::temp4 
            ; line 1482
            cast ::temp1 None 
            assign witness ::temp1 
            ; line 1483
            assign ni 0 
            ; line 1484
          _label7:
            array_length ::temp5 nearbyNPCs 
            cmp_lt ::temp2 ni ::temp5 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label2
            cast ::temp1 None 
            cmp_eq ::temp2 witness ::temp1 
            assign ::temp2 ::temp2 
          _label2:
            jmpf ::temp2 _label3
            ; line 1485
            array_getlement ::temp1 nearbyNPCs ni 
            cast ::temp6 None 
            cmp_eq ::temp2 ::temp1 ::temp6 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label4
            array_getlement ::temp6 nearbyNPCs ni 
            cmp_eq ::temp2 ::temp6 target 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label4:
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label5
            array_getlement ::temp6 nearbyNPCs ni 
            cmp_eq ::temp2 ::temp6 assassin 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label5:
            jmpf ::temp2 _label6
            ; line 1486
            array_getlement ::temp6 nearbyNPCs ni 
            assign witness ::temp6 
            jmp _label6
            ; line 1488
          _label6:
            iadd ::temp5 ni 1 
            assign ni ::temp5 
            jmp _label7
            ; line 1490
          _label3:
            cast ::temp6 None 
            cmp_eq ::temp2 witness ::temp6 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label8
            ; line 1491
            strcat ::temp0 "spotted a suspicious stranger lingering near " targetName 
            strcat ::temp0 ::temp0 " and grew uneasy" 
            callstatic skyrimNetApi DirectNarration ::temp5 ::temp0 witness player ;3 variable args
            jmp _label8
          _label8:
            jmp _label1
            ; line 1496
          _label1:
            callstatic utility RandomFloat ::temp7 5.0 8.0 ;2 variable args
            callstatic utility Wait ::nonevar ::temp7 ;1 variable args
            ; line 1499
            callmethod IsDead assassin ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label9
            cast ::temp6 None 
            cmp_eq ::temp2 target ::temp6 
            assign ::temp2 ::temp2 
          _label9:
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label10
            callmethod IsDead target ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
          _label10:
            jmpf ::temp2 _label11
            ; line 1500
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Assassination aborted — assassin or target dead" ;1 variable args
            ; line 1501
            callmethod CleanupManifestation self ::nonevar ;0 variable args
            ; line 1502
            return None 
            jmp _label11
            ; line 1506
          _label11:
            callstatic intelEngine TriggerAssassinationAttack ::nonevar ;0 variable args
            ; line 1507
            callmethod StartCombat assassin ::nonevar target ;1 variable args
            ; line 1510
            strcat ::temp0 "witnessed an assassination attempt on " targetName 
            assign infiltrationFact ::temp0 
            ; line 1511
            cast ::temp3 player 
            callstatic intelEngine GetNearbyWitnessNPCs ::temp4 ::temp3 3000.0 ;2 variable args
            assign witnesses ::temp4 
            ; line 1512
            assign wi 0 
            ; line 1513
          _label14:
            array_length ::temp5 witnesses 
            cmp_lt ::temp2 wi ::temp5 
            jmpf ::temp2 _label12
            ; line 1514
            array_getlement ::temp6 witnesses wi 
            cast ::temp1 None 
            cmp_eq ::temp2 ::temp6 ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label13
            ; line 1515
            array_getlement ::temp1 witnesses wi 
            callmethod InjectFact ::Core_var ::nonevar ::temp1 infiltrationFact ;2 variable args
            jmp _label13
            ; line 1517
          _label13:
            iadd ::temp5 wi 1 
            assign wi ::temp5 
            jmp _label14
            ; line 1519
          _label12:
            assign eventWitness player 
            ; line 1520
            array_length ::temp5 witnesses 
            cmp_gt ::temp2 ::temp5 0 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label15
            array_getlement ::temp1 witnesses 0 
            cast ::temp6 None 
            cmp_eq ::temp2 ::temp1 ::temp6 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label15:
            jmpf ::temp2 _label16
            ; line 1521
            array_getlement ::temp6 witnesses 0 
            assign eventWitness ::temp6 
            jmp _label16
            ; line 1523
          _label16:
            callstatic skyrimNetApi RegisterEvent ::temp5 "political_assassination" infiltrationFact target eventWitness ;4 variable args
            ; line 1526
            callstatic utility GetCurrentRealTime ::temp7 ;0 variable args
            assign ::ManifestStartTime_var ::temp7 
            ; line 1527
            strcat ::temp0 "Assassin strikes at " targetName 
            strcat ::temp0 ::temp0 "!" 
            callstatic debug Notification ::nonevar ::temp0 ;1 variable args
            ; line 1528
            callstatic intelEngine ConfirmManifestationCooldown ::nonevar ;0 variable args
            ; line 1529
            strcat ::temp0 "Battle: Assassination attack triggered on " targetName 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
          .endCode
        .endFunction ;HandleAssassinArrival
        .function CleanupManifestation
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local ::temp1 actor
            .local ::temp2 Bool
            .local ::temp3 actor
            .local assSlot Int
            .local ::temp4 Int
            .local i Int
          .endLocalTable
          .code
            ; line 1533
            cast ::temp0 ::ManifestCount_var 
            strcat ::temp0 "Battle: Cleaning up manifestation (" ::temp0 
            strcat ::temp0 ::temp0 " actors)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 1536
            cast ::temp1 None 
            cmp_eq ::temp2 ::ManifestLeaderTarget_var ::temp1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label0
            array_getlement ::temp1 ::ManifestActors_var 0 
            cast ::temp3 None 
            cmp_eq ::temp2 ::temp1 ::temp3 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label0:
            jmpf ::temp2 _label1
            ; line 1537
            array_getlement ::temp3 ::ManifestActors_var 0 
            callmethod FindSlotByAgent ::Core_var ::temp4 ::temp3 ;1 variable args
            assign assSlot ::temp4 
            ; line 1538
            comp_gte ::temp2 assSlot 0 
            jmpf ::temp2 _label2
            ; line 1539
            callmethod ClearSlot ::Core_var ::nonevar assSlot False False ;3 variable args
            jmp _label2
          _label2:
            jmp _label1
            ; line 1543
          _label1:
            assign i 0 
            ; line 1544
          _label7:
            cmp_lt ::temp2 i ::ManifestCount_var 
            jmpf ::temp2 _label3
            ; line 1545
            array_getlement ::temp3 ::ManifestActors_var i 
            cast ::temp1 None 
            cmp_eq ::temp2 ::temp3 ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label4
            ; line 1546
            array_getlement ::temp1 ::ManifestActors_var i 
            callmethod IsDead ::temp1 ::temp2 ;0 variable args
            jmpf ::temp2 _label5
            ; line 1547
            array_getlement ::temp1 ::ManifestActors_var i 
            callmethod DisableNoWait ::temp1 ::nonevar False ;1 variable args
            ; line 1548
            array_getlement ::temp1 ::ManifestActors_var i 
            callmethod Delete ::temp1 ::nonevar ;0 variable args
            jmp _label6
            ; line 1551
          _label5:
            array_getlement ::temp1 ::ManifestActors_var i 
            callmethod RemoveFromFaction ::temp1 ::nonevar ::Intel_BattleSideA_var ;1 variable args
            ; line 1552
            array_getlement ::temp1 ::ManifestActors_var i 
            callmethod RemoveFromFaction ::temp1 ::nonevar ::Intel_BattleSideB_var ;1 variable args
            ; line 1554
          _label6:
            cast ::temp1 None 
            array_setelement ::ManifestActors_var i ::temp1 
            jmp _label4
            ; line 1556
          _label4:
            iadd ::temp4 i 1 
            assign i ::temp4 
            jmp _label7
            ; line 1558
          _label3:
            assign ::ManifestCount_var 0 
            ; line 1559
            assign ::ManifestActive_var False 
            ; line 1560
            assign ::ManifestAssassinAttacked_var False 
            ; line 1561
            cast ::temp1 None 
            assign ::ManifestLeaderTarget_var ::temp1 
          .endCode
        .endFunction ;CleanupManifestation
        .function IsAnyManifestActorInCombat
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local i Int
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::temp2 actor
            .local ::temp3 Int
          .endLocalTable
          .code
            ; line 1565
            assign i 0 
            ; line 1566
          _label4:
            cmp_lt ::temp0 i ::ManifestCount_var 
            jmpf ::temp0 _label0
            ; line 1567
            array_getlement ::temp1 ::ManifestActors_var i 
            cast ::temp2 None 
            cmp_eq ::temp0 ::temp1 ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label1
            array_getlement ::temp2 ::ManifestActors_var i 
            callmethod IsDead ::temp2 ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label1:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label2
            array_getlement ::temp2 ::ManifestActors_var i 
            callmethod IsInCombat ::temp2 ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label2:
            jmpf ::temp0 _label3
            ; line 1568
            return True 
            jmp _label3
            ; line 1570
          _label3:
            iadd ::temp3 i 1 
            assign i ::temp3 
            jmp _label4
            ; line 1572
          _label0:
            return False 
          .endCode
        .endFunction ;IsAnyManifestActorInCombat
        .function IsPlayerInExterior
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local playerCell cell
            .local ::temp1 cell
            .local ::temp2 Bool
          .endLocalTable
          .code
            ; line 1583
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1584
            callmethod GetParentCell player ::temp1 ;0 variable args
            assign playerCell ::temp1 
            ; line 1585
            not ::temp2 playerCell 
            jmpf ::temp2 _label0
            ; line 1586
            return False 
            jmp _label0
            ; line 1588
          _label0:
            callmethod IsInterior playerCell ::temp2 ;0 variable args
            not ::temp2 ::temp2 
            return ::temp2 
          .endCode
        .endFunction ;IsPlayerInExterior
        .function ShowBattleStartNotification
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param locationName String
          .endParamTable
          .localTable
            .local startMsg Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 1592
            callstatic utility RandomInt ::temp0 0 2 ;2 variable args
            assign startMsg ::temp0 
            ; line 1593
            cmp_eq ::temp1 startMsg 0 
            jmpf ::temp1 _label0
            ; line 1594
            strcat ::temp2 "Soldiers clash near " locationName 
            strcat ::temp2 ::temp2 "." 
            callstatic debug Notification ::nonevar ::temp2 ;1 variable args
            jmp _label1
            ; line 1595
          _label0:
            cmp_eq ::temp1 startMsg 1 
            jmpf ::temp1 _label2
            ; line 1596
            strcat ::temp2 "A skirmish breaks out at " locationName 
            strcat ::temp2 ::temp2 "." 
            callstatic debug Notification ::nonevar ::temp2 ;1 variable args
            jmp _label1
            ; line 1598
          _label2:
            strcat ::temp2 "Armed men trade blows near " locationName 
            strcat ::temp2 ::temp2 "." 
            callstatic debug Notification ::nonevar ::temp2 ;1 variable args
          _label1
          .endCode
        .endFunction ;ShowBattleStartNotification
        .function CleanupBattle
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
            ; line 1604
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Unexpected end — cleaning up" ;1 variable args
            ; line 1605
            callmethod RemovePlayerFromBattle self ::nonevar ;0 variable args
            ; line 1606
            callmethod CleanupAllActors self ::nonevar ;0 variable args
            ; line 1607
            callmethod CleanupMarkers self ::nonevar ;0 variable args
            ; line 1608
            callmethod ResetState self ::nonevar ;0 variable args
          .endCode
        .endFunction ;CleanupBattle
        .function OnGameReload
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local now Float
            .local ::temp0 Float
            .local ::temp1 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1621
            callstatic utility GetCurrentRealTime ::temp0 ;0 variable args
            assign now ::temp0 
            ; line 1622
            cmp_gt ::temp1 ::BattleStartRealTime_var now 
            jmpf ::temp1 _label0
            ; line 1623
            assign ::BattleStartRealTime_var now 
            jmp _label0
            ; line 1625
          _label0:
            cmp_gt ::temp1 ::DeferredCleanupStart_var now 
            jmpf ::temp1 _label1
            ; line 1626
            assign ::DeferredCleanupStart_var now 
            jmp _label1
            ; line 1628
          _label1:
            cmp_gt ::temp1 ::ManifestStartTime_var now 
            jmpf ::temp1 _label2
            ; line 1629
            assign ::ManifestStartTime_var now 
            jmp _label2
            ; line 1633
          _label2:
            jmpf ::ManifestActive_var _label3
            ; line 1634
            callmethod CleanupManifestation self ::nonevar ;0 variable args
            jmp _label3
            ; line 1640
          _label3:
            assign ::temp1 ::BattleSpawned_var 
            jmpt ::temp1 _label4
            assign ::temp1 ::BattleScheduled_var 
          _label4:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label5
            comp_gte ::temp1 ::ActiveBattleId_var 0 
            assign ::temp1 ::temp1 
          _label5:
            jmpf ::temp1 _label6
            ; line 1641
            callmethod DebugMsg ::Core_var ::nonevar "Battle: Game reloaded during active battle — cleaning up" ;1 variable args
            ; line 1643
            callstatic intelEngine EndBattle ::nonevar ::ActiveBattleId_var "reload" "" ;3 variable args
            ; line 1644
            callmethod RemovePlayerFromBattle self ::nonevar ;0 variable args
            ; line 1645
            callmethod CleanupAllActors self ::nonevar ;0 variable args
            ; line 1646
            callmethod CleanupMarkers self ::nonevar ;0 variable args
            ; line 1647
            callmethod ResetState self ::nonevar ;0 variable args
            jmp _label6
            ; line 1651
          _label6:
            callstatic intelEngine ClearPendingBattles ::nonevar ;0 variable args
            ; line 1652
            assign ::PendingPollActive_var False 
          .endCode
        .endFunction ;OnGameReload
      .endState
    .endStateTable
  .endObject
.endObjectTable
