.info
  .source "C:\nolvus-research\build\src\intelengine\Source\Scripts\IntelEngine_StoryEngine.psc"
  .compileTime 1791572583 ;2026-10-09 15:03:03
  .user "sharp"
  .computer "EMISSARY"
.endInfo
.userFlagsRef
  .flag hidden 0 ;0x00000001
.endUserFlagsRef
.objectTable
  .object IntelEngine_StoryEngine Quest
    .userFlags 0 ;none
    .docString ""
    .autoState 
    .variableTable
      .variable ::ActiveNarration_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::ActiveSecondNPC_var actor
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::ActiveStoryNPC_var actor
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::ActiveStoryType_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::AllowStuckTeleport_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::AutoBioEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::AutoBioThreshold_var Int
        .userFlags 1 ;hidden 
        .initialValue 20
      .endVariable
      .variable ::BlockAllInDanger_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::BlockCiviliansInDanger_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::ConfirmDeliverMessage_var Int
        .userFlags 1 ;hidden 
        .initialValue 1
      .endVariable
      .variable ::ConfirmEscortTarget_var Int
        .userFlags 1 ;hidden 
        .initialValue 1
      .endVariable
      .variable ::ConfirmFetchPerson_var Int
        .userFlags 1 ;hidden 
        .initialValue 1
      .endVariable
      .variable ::ConfirmGoToLocation_var Int
        .userFlags 1 ;hidden 
        .initialValue 1
      .endVariable
      .variable ::ConfirmScheduleDelivery_var Int
        .userFlags 1 ;hidden 
        .initialValue 1
      .endVariable
      .variable ::ConfirmScheduleFetch_var Int
        .userFlags 1 ;hidden 
        .initialValue 1
      .endVariable
      .variable ::ConfirmScheduleMeeting_var Int
        .userFlags 1 ;hidden 
        .initialValue 2
      .endVariable
      .variable ::ConfirmSearchForActor_var Int
        .userFlags 1 ;hidden 
        .initialValue 1
      .endVariable
      .variable ::Core_var intelEngine_Core
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::DangerZonePolicy_var Int
        .userFlags 1 ;hidden 
        .initialValue 1
      .endVariable
      .variable ::ExcludedTypesConfig_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::FactionAmbushActive_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::FactionAmbushActors_var actor[]
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::FactionAmbushCount_var Int
        .userFlags 1 ;hidden 
        .initialValue 0
      .endVariable
      .variable ::FactionAmbushStartTime_var Float
        .userFlags 1 ;hidden 
        .initialValue 0.0
      .endVariable
      .variable ::HoldPolicyAmbush_var Int
        .userFlags 1 ;hidden 
        .initialValue 1
      .endVariable
      .variable ::HoldPolicyInformant_var Int
        .userFlags 1 ;hidden 
        .initialValue 6
      .endVariable
      .variable ::HoldPolicyMessage_var Int
        .userFlags 1 ;hidden 
        .initialValue 2
      .endVariable
      .variable ::HoldPolicyQuest_var Int
        .userFlags 1 ;hidden 
        .initialValue 0
      .endVariable
      .variable ::HoldPolicyRoadEncounter_var Int
        .userFlags 1 ;hidden 
        .initialValue 0
      .endVariable
      .variable ::HoldPolicySeekPlayer_var Int
        .userFlags 1 ;hidden 
        .initialValue 1
      .endVariable
      .variable ::HoldPolicyStalker_var Int
        .userFlags 1 ;hidden 
        .initialValue 1
      .endVariable
      .variable ::IntelEngine_StoryEngineCooldown_var globalVariable
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::IntelEngine_StoryEngineEnabled_var globalVariable
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::IntelEngine_StoryEngineInterval_var globalVariable
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::IsActive_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::IsNPCStoryActive_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::LastIdlePollTickTime_var Float
        .userFlags 1 ;hidden 
        .initialValue 0.0
      .endVariable
      .variable ::LastNPCTickTime_var Float
        .userFlags 1 ;hidden 
        .initialValue 0.0
      .endVariable
      .variable ::LastStoryTickTime_var Float
        .userFlags 1 ;hidden 
        .initialValue 0.0
      .endVariable
      .variable ::LongAbsenceDaysConfig_var Float
        .userFlags 1 ;hidden 
        .initialValue 3.0
      .endVariable
      .variable ::MaxTravelDaysConfig_var Float
        .userFlags 1 ;hidden 
        .initialValue 1.0
      .endVariable
      .variable ::NPCSocialCooldownHours_var Float
        .userFlags 1 ;hidden 
        .initialValue 24.0
      .endVariable
      .variable ::NPCSocialNarration_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::NPCSocialTarget_var actor
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::NPCSocialTraveler_var actor
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::NPCSocialType_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::NPCTickEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::NPCTickIntervalHours_var Float
        .userFlags 1 ;hidden 
        .initialValue 1.5
      .endVariable
      .variable ::NPCTickPending_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::PendingStoryType_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::PlayerHomePolicy_var Int
        .userFlags 1 ;hidden 
        .initialValue 0
      .endVariable
      .variable ::QUEST_EXPIRY_DAYS_var Float
        .userFlags 1 ;hidden 
        .initialValue 1.0
      .endVariable
      .variable ::QuestActive_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::QuestAlliedFaction_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::QuestAllowVictimDeath_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::QuestBattleEnemyFaction_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::QuestBattleMarker_var objectReference
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::QuestBattleScheduled_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::QuestBossAnchor_var objectReference
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::QuestBossNPC_var actor
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::QuestBriefing_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::QuestDeferredToInterior_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::QuestDungeonDepth_var Int
        .userFlags 1 ;hidden 
        .initialValue 0
      .endVariable
      .variable ::QuestDungeonLastCell_var cell
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::QuestDungeonScanFails_var Int
        .userFlags 1 ;hidden 
        .initialValue 0
      .endVariable
      .variable ::QuestEnemiesSpawned_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::QuestEnemyType_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::QuestExpiryWarned_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::QuestFurnitureScanned_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::QuestGiver_var actor
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::QuestGuideActive_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::QuestGuideNPC_var actor
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::QuestGuideStartTime_var Float
        .userFlags 1 ;hidden 
        .initialValue 0.0
      .endVariable
      .variable ::QuestGuideWaiting_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::QuestItemChest_var objectReference
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::QuestItemDesc_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::QuestItemName_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::QuestLocationName_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::QuestLocation_var objectReference
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::QuestPrePlaced_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::QuestSpawnAttempts_var Int
        .userFlags 1 ;hidden 
        .initialValue 0
      .endVariable
      .variable ::QuestSpawnCount_var Int
        .userFlags 1 ;hidden 
        .initialValue 0
      .endVariable
      .variable ::QuestStartTime_var Float
        .userFlags 1 ;hidden 
        .initialValue 0.0
      .endVariable
      .variable ::QuestSubTypeCombatEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::QuestSubTypeFactionBattleEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::QuestSubTypeFactionCombatEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::QuestSubTypeFactionRescueEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::QuestSubTypeFindItemEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::QuestSubTypeRescueEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::QuestSubType_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::QuestTargetAlias_var referenceAlias
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::QuestVictimFreed_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::QuestVictimInFurniture_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::QuestVictimNPC_var actor
        .userFlags 1 ;hidden 
        .initialValue None
      .endVariable
      .variable ::QuestVictimName_var String
        .userFlags 1 ;hidden 
        .initialValue ""
      .endVariable
      .variable ::Schedule_var intelEngine_Schedule
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::SkipFollowerDeliverMessage_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::SkipFollowerEscortTarget_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::SkipFollowerFetchPerson_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::SkipFollowerGoToLocation_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::SkipFollowerScheduleDelivery_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::SkipFollowerScheduleFetch_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::SkipFollowerScheduleMeeting_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::SkipFollowerSearchForActor_var Bool
        .userFlags 1 ;hidden 
        .initialValue False
      .endVariable
      .variable ::TypeAmbushEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::TypeFactionAmbushEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::TypeInformantEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::TypeMessageEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::TypeNPCGossipEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::TypeNPCInteractionEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::TypeQuestEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::TypeRoadEncounterEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::TypeSeekPlayerEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
      .variable ::TypeStalkerEnabled_var Bool
        .userFlags 1 ;hidden 
        .initialValue True
      .endVariable
    .endVariableTable
    .propertyTable
      .property AMBUSH_CONFRONT_DISTANCE Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 40
            return 500.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property AMBUSH_STANDING_PENALTY Int
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 182
            return -3 
          .endCode
        .endFunction ;get
      .endProperty
      .property ActiveNarration String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ActiveNarration_var
      .endProperty
      .property ActiveSecondNPC actor auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ActiveSecondNPC_var
      .endProperty
      .property ActiveStoryNPC actor auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ActiveStoryNPC_var
      .endProperty
      .property ActiveStoryType String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ActiveStoryType_var
      .endProperty
      .property AllowStuckTeleport Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::AllowStuckTeleport_var
      .endProperty
      .property AutoBioEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::AutoBioEnabled_var
      .endProperty
      .property AutoBioThreshold Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::AutoBioThreshold_var
      .endProperty
      .property BATTLE_BUILDUP_NOTIFY_MAX Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 177
            return 0.029999999 
          .endCode
        .endFunction ;get
      .endProperty
      .property BATTLE_BUILDUP_NOTIFY_MIN Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 176
            return 0.01 
          .endCode
        .endFunction ;get
      .endProperty
      .property BATTLE_DELAY_MIN_DAYS Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 174
            return 0.015 
          .endCode
        .endFunction ;get
      .endProperty
      .property BATTLE_DELAY_VARIANCE_DAYS Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 175
            return 0.015 
          .endCode
        .endFunction ;get
      .endProperty
      .property BATTLE_MARKER_OFFSET_UNITS Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 179
            return 3000.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property BATTLE_MIN_START_DELAY Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 178
            return 0.039999999 
          .endCode
        .endFunction ;get
      .endProperty
      .property BlockAllInDanger Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BlockAllInDanger_var
      .endProperty
      .property BlockCiviliansInDanger Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::BlockCiviliansInDanger_var
      .endProperty
      .property ConfirmDeliverMessage Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ConfirmDeliverMessage_var
      .endProperty
      .property ConfirmEscortTarget Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ConfirmEscortTarget_var
      .endProperty
      .property ConfirmFetchPerson Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ConfirmFetchPerson_var
      .endProperty
      .property ConfirmGoToLocation Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ConfirmGoToLocation_var
      .endProperty
      .property ConfirmScheduleDelivery Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ConfirmScheduleDelivery_var
      .endProperty
      .property ConfirmScheduleFetch Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ConfirmScheduleFetch_var
      .endProperty
      .property ConfirmScheduleMeeting Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ConfirmScheduleMeeting_var
      .endProperty
      .property ConfirmSearchForActor Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ConfirmSearchForActor_var
      .endProperty
      .property Core intelEngine_Core auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::Core_var
      .endProperty
      .property DangerZonePolicy Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::DangerZonePolicy_var
      .endProperty
      .property ENCOUNTER_PROXIMITY Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 38
            return 300.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property ENCOUNTER_RESUME_DISTANCE Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 141
            return 1500.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property ExcludedTypesConfig String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::ExcludedTypesConfig_var
      .endProperty
      .property FACTION_AMBUSH_CLEANUP_TIMEOUT Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 170
            return 120.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property FACTION_AMBUSH_HARD_TIMEOUT Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 171
            return 360.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property FactionAmbushActive Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::FactionAmbushActive_var
      .endProperty
      .property FactionAmbushActors actor[] auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::FactionAmbushActors_var
      .endProperty
      .property FactionAmbushCount Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::FactionAmbushCount_var
      .endProperty
      .property FactionAmbushStartTime Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::FactionAmbushStartTime_var
      .endProperty
      .property HoldPolicyAmbush Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::HoldPolicyAmbush_var
      .endProperty
      .property HoldPolicyInformant Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::HoldPolicyInformant_var
      .endProperty
      .property HoldPolicyMessage Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::HoldPolicyMessage_var
      .endProperty
      .property HoldPolicyQuest Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::HoldPolicyQuest_var
      .endProperty
      .property HoldPolicyRoadEncounter Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::HoldPolicyRoadEncounter_var
      .endProperty
      .property HoldPolicySeekPlayer Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::HoldPolicySeekPlayer_var
      .endProperty
      .property HoldPolicyStalker Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::HoldPolicyStalker_var
      .endProperty
      .property IDLE_POLL_INTERVAL Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 37
            return 30.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property IntelEngine_StoryEngineCooldown globalVariable auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::IntelEngine_StoryEngineCooldown_var
      .endProperty
      .property IntelEngine_StoryEngineEnabled globalVariable auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::IntelEngine_StoryEngineEnabled_var
      .endProperty
      .property IntelEngine_StoryEngineInterval globalVariable auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::IntelEngine_StoryEngineInterval_var
      .endProperty
      .property IsActive Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::IsActive_var
      .endProperty
      .property IsNPCStoryActive Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::IsNPCStoryActive_var
      .endProperty
      .property LINGER_TIMEOUT_SECONDS Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 140
            return 300.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property LastIdlePollTickTime Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::LastIdlePollTickTime_var
      .endProperty
      .property LastNPCTickTime Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::LastNPCTickTime_var
      .endProperty
      .property LastStoryTickTime Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::LastStoryTickTime_var
      .endProperty
      .property LongAbsenceDaysConfig Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::LongAbsenceDaysConfig_var
      .endProperty
      .property MONITOR_INTERVAL Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 36
            return 3.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property MaxTravelDaysConfig Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::MaxTravelDaysConfig_var
      .endProperty
      .property NPCSocialCooldownHours Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::NPCSocialCooldownHours_var
      .endProperty
      .property NPCSocialNarration String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::NPCSocialNarration_var
      .endProperty
      .property NPCSocialTarget actor auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::NPCSocialTarget_var
      .endProperty
      .property NPCSocialTraveler actor auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::NPCSocialTraveler_var
      .endProperty
      .property NPCSocialType String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::NPCSocialType_var
      .endProperty
      .property NPCTickEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::NPCTickEnabled_var
      .endProperty
      .property NPCTickIntervalHours Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::NPCTickIntervalHours_var
      .endProperty
      .property NPCTickPending Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::NPCTickPending_var
      .endProperty
      .property PendingStoryType String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::PendingStoryType_var
      .endProperty
      .property PlayerHomePolicy Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::PlayerHomePolicy_var
      .endProperty
      .property QUEST_EXPIRY_DAYS Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QUEST_EXPIRY_DAYS_var
      .endProperty
      .property QUEST_GUIDE_RESUME_DIST Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 138
            return 800.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property QUEST_GUIDE_TIMEOUT_HOURS Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 139
            return 5.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property QUEST_GUIDE_WAIT_DIST Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 137
            return 2000.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property QUEST_OBJECTIVE_ID Int
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 202
            return 0 
          .endCode
        .endFunction ;get
      .endProperty
      .property QUEST_STANDING_PENALTY Int
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 181
            return -5 
          .endCode
        .endFunction ;get
      .endProperty
      .property QUEST_STANDING_REWARD Int
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 180
            return 5 
          .endCode
        .endFunction ;get
      .endProperty
      .property QuestActive Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestActive_var
      .endProperty
      .property QuestAlliedFaction String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestAlliedFaction_var
      .endProperty
      .property QuestAllowVictimDeath Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestAllowVictimDeath_var
      .endProperty
      .property QuestBattleEnemyFaction String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestBattleEnemyFaction_var
      .endProperty
      .property QuestBattleMarker objectReference auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestBattleMarker_var
      .endProperty
      .property QuestBattleScheduled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestBattleScheduled_var
      .endProperty
      .property QuestBossAnchor objectReference auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestBossAnchor_var
      .endProperty
      .property QuestBossNPC actor auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestBossNPC_var
      .endProperty
      .property QuestBriefing String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestBriefing_var
      .endProperty
      .property QuestDeferredToInterior Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestDeferredToInterior_var
      .endProperty
      .property QuestDungeonDepth Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestDungeonDepth_var
      .endProperty
      .property QuestDungeonLastCell cell auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestDungeonLastCell_var
      .endProperty
      .property QuestDungeonScanFails Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestDungeonScanFails_var
      .endProperty
      .property QuestEnemiesSpawned Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestEnemiesSpawned_var
      .endProperty
      .property QuestEnemyType String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestEnemyType_var
      .endProperty
      .property QuestExpiryWarned Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestExpiryWarned_var
      .endProperty
      .property QuestFurnitureScanned Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestFurnitureScanned_var
      .endProperty
      .property QuestGiver actor auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestGiver_var
      .endProperty
      .property QuestGuideActive Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestGuideActive_var
      .endProperty
      .property QuestGuideNPC actor auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestGuideNPC_var
      .endProperty
      .property QuestGuideStartTime Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestGuideStartTime_var
      .endProperty
      .property QuestGuideWaiting Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestGuideWaiting_var
      .endProperty
      .property QuestItemChest objectReference auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestItemChest_var
      .endProperty
      .property QuestItemDesc String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestItemDesc_var
      .endProperty
      .property QuestItemName String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestItemName_var
      .endProperty
      .property QuestLocation objectReference auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestLocation_var
      .endProperty
      .property QuestLocationName String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestLocationName_var
      .endProperty
      .property QuestPrePlaced Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestPrePlaced_var
      .endProperty
      .property QuestSpawnAttempts Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestSpawnAttempts_var
      .endProperty
      .property QuestSpawnCount Int auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestSpawnCount_var
      .endProperty
      .property QuestStartTime Float auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestStartTime_var
      .endProperty
      .property QuestSubType String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestSubType_var
      .endProperty
      .property QuestSubTypeCombatEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestSubTypeCombatEnabled_var
      .endProperty
      .property QuestSubTypeFactionBattleEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestSubTypeFactionBattleEnabled_var
      .endProperty
      .property QuestSubTypeFactionCombatEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestSubTypeFactionCombatEnabled_var
      .endProperty
      .property QuestSubTypeFactionRescueEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestSubTypeFactionRescueEnabled_var
      .endProperty
      .property QuestSubTypeFindItemEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestSubTypeFindItemEnabled_var
      .endProperty
      .property QuestSubTypeRescueEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestSubTypeRescueEnabled_var
      .endProperty
      .property QuestTargetAlias referenceAlias auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::QuestTargetAlias_var
      .endProperty
      .property QuestVictimFreed Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestVictimFreed_var
      .endProperty
      .property QuestVictimInFurniture Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestVictimInFurniture_var
      .endProperty
      .property QuestVictimNPC actor auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestVictimNPC_var
      .endProperty
      .property QuestVictimName String auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::QuestVictimName_var
      .endProperty
      .property SNEAK_APPROACH_DISTANCE Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 39
            return 2000.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property SNEAK_TIMEOUT_SECONDS Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 43
            return 300.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property STALKER_KEEP_DISTANCE Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 41
            return 800.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property STALKER_RESUME_DISTANCE Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 42
            return 1000.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property Schedule intelEngine_Schedule auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::Schedule_var
      .endProperty
      .property SkipFollowerDeliverMessage Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::SkipFollowerDeliverMessage_var
      .endProperty
      .property SkipFollowerEscortTarget Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::SkipFollowerEscortTarget_var
      .endProperty
      .property SkipFollowerFetchPerson Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::SkipFollowerFetchPerson_var
      .endProperty
      .property SkipFollowerGoToLocation Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::SkipFollowerGoToLocation_var
      .endProperty
      .property SkipFollowerScheduleDelivery Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::SkipFollowerScheduleDelivery_var
      .endProperty
      .property SkipFollowerScheduleFetch Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::SkipFollowerScheduleFetch_var
      .endProperty
      .property SkipFollowerScheduleMeeting Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::SkipFollowerScheduleMeeting_var
      .endProperty
      .property SkipFollowerSearchForActor Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::SkipFollowerSearchForActor_var
      .endProperty
      .property TELEPORT_OFFSET_EXTERIOR Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 143
            return 3500.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property TELEPORT_OFFSET_INTERIOR Float
        .userFlags 0 ;none
        .docString ""
        .function get
           ; function type 1
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 142
            return 500.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property TypeAmbushEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::TypeAmbushEnabled_var
      .endProperty
      .property TypeFactionAmbushEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::TypeFactionAmbushEnabled_var
      .endProperty
      .property TypeInformantEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::TypeInformantEnabled_var
      .endProperty
      .property TypeMessageEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::TypeMessageEnabled_var
      .endProperty
      .property TypeNPCGossipEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::TypeNPCGossipEnabled_var
      .endProperty
      .property TypeNPCInteractionEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::TypeNPCInteractionEnabled_var
      .endProperty
      .property TypeQuestEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::TypeQuestEnabled_var
      .endProperty
      .property TypeRoadEncounterEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::TypeRoadEncounterEnabled_var
      .endProperty
      .property TypeSeekPlayerEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::TypeSeekPlayerEnabled_var
      .endProperty
      .property TypeStalkerEnabled Bool auto
        .userFlags 1 ;hidden 
        .docString ""
        .autovar ::TypeStalkerEnabled_var
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
        .function StartScheduler
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::temp2 form
            .local ::nonevar None
            .local ::temp3 Float
            .local ::temp4 String
            .local ::temp5 String
            .local storyInterval Float
            .local ::temp6 intelEngine_Core
            .local npcInterval Float
            .local politicsInterval Float
            .local ::temp7 Int
            .local interval Float
          .endLocalTable
          .code
            ; line 214
            not ::temp0 ::FactionAmbushActive_var 
            jmpf ::temp0 _label0
            ; line 215
            callstatic game GetPlayer ::temp1 ;0 variable args
            cast ::temp2 ::temp1 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp2 "Intel_FactionAmbushFaction" ;2 variable args
            jmp _label0
            ; line 217
          _label0:
            assign ::temp0 ::IsActive_var 
            jmpt ::temp0 _label1
            assign ::temp0 ::IsNPCStoryActive_var 
          _label1:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label2
            callmethod HasLingerNPCs self ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label2:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label3
            assign ::temp0 ::QuestActive_var 
          _label3:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label4
            assign ::temp0 ::FactionAmbushActive_var 
          _label4:
            jmpf ::temp0 _label5
            ; line 218
            propget MONITOR_INTERVAL self ::temp3 
            callmethod RegisterForSingleUpdate self ::nonevar ::temp3 ;1 variable args
            ; line 219
            cast ::temp4 ::IsActive_var 
            strcat ::temp4 "Story: StartScheduler — real-time mode (active=" ::temp4 
            strcat ::temp4 ::temp4 " npcStory=" 
            cast ::temp5 ::IsNPCStoryActive_var 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 " quest=" 
            cast ::temp4 ::QuestActive_var 
            strcat ::temp4 ::temp5 ::temp4 
            strcat ::temp4 ::temp4 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            jmp _label6
            ; line 225
          _label5:
            assign storyInterval 3.0 
            ; line 226
            cast ::temp6 None 
            cmp_eq ::temp0 ::Core_var ::temp6 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label7
            ; line 227
            callmethod GetStoryEngineInterval ::Core_var ::temp3 ;0 variable args
            assign storyInterval ::temp3 
            jmp _label7
            ; line 229
          _label7:
            assign npcInterval ::NPCTickIntervalHours_var 
            ; line 230
            callstatic intelEngine GetPoliticsTickInterval ::temp7 ;0 variable args
            cast ::temp3 ::temp7 
            assign politicsInterval ::temp3 
            ; line 231
            cmp_lte ::temp0 politicsInterval 0.0 
            jmpf ::temp0 _label8
            ; line 232
            assign politicsInterval 6.0 
            jmp _label8
            ; line 235
          _label8:
            assign interval storyInterval 
            ; line 236
            cmp_gt ::temp0 npcInterval 0.0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label9
            cmp_lt ::temp0 npcInterval interval 
            assign ::temp0 ::temp0 
          _label9:
            jmpf ::temp0 _label10
            ; line 237
            assign interval npcInterval 
            jmp _label10
            ; line 239
          _label10:
            cmp_gt ::temp0 politicsInterval 0.0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label11
            cmp_lt ::temp0 politicsInterval interval 
            assign ::temp0 ::temp0 
          _label11:
            jmpf ::temp0 _label12
            ; line 240
            assign interval politicsInterval 
            jmp _label12
            ; line 243
          _label12:
            callmethod RegisterForSingleUpdateGameTime self ::nonevar interval ;1 variable args
            ; line 245
            propget IDLE_POLL_INTERVAL self ::temp3 
            callmethod RegisterForSingleUpdate self ::nonevar ::temp3 ;1 variable args
            ; line 246
            cast ::temp4 interval 
            strcat ::temp4 "Story: StartScheduler — game-time mode (interval=" ::temp4 
            strcat ::temp4 ::temp4 "h = min of story=" 
            cast ::temp5 storyInterval 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 " npc=" 
            cast ::temp4 npcInterval 
            strcat ::temp4 ::temp5 ::temp4 
            strcat ::temp4 ::temp4 " politics=" 
            cast ::temp5 politicsInterval 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
          _label6
          .endCode
        .endFunction ;StartScheduler
        .function StopScheduler
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
            ; line 251
            callmethod UnregisterForUpdate self ::nonevar ;0 variable args
            ; line 252
            callmethod UnregisterForUpdateGameTime self ::nonevar ;0 variable args
          .endCode
        .endFunction ;StopScheduler
        .function SyncHoldRestrictionPolicies
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
            ; line 256
            callstatic intelEngine SetHoldRestrictionPolicy ::nonevar "seek_player" ::HoldPolicySeekPlayer_var ;2 variable args
            ; line 257
            callstatic intelEngine SetHoldRestrictionPolicy ::nonevar "informant" ::HoldPolicyInformant_var ;2 variable args
            ; line 258
            callstatic intelEngine SetHoldRestrictionPolicy ::nonevar "road_encounter" ::HoldPolicyRoadEncounter_var ;2 variable args
            ; line 259
            callstatic intelEngine SetHoldRestrictionPolicy ::nonevar "ambush" ::HoldPolicyAmbush_var ;2 variable args
            ; line 260
            callstatic intelEngine SetHoldRestrictionPolicy ::nonevar "stalker" ::HoldPolicyStalker_var ;2 variable args
            ; line 261
            callstatic intelEngine SetHoldRestrictionPolicy ::nonevar "message" ::HoldPolicyMessage_var ;2 variable args
            ; line 262
            callstatic intelEngine SetHoldRestrictionPolicy ::nonevar "quest" ::HoldPolicyQuest_var ;2 variable args
          .endCode
        .endFunction ;SyncHoldRestrictionPolicies
        .function RestartMonitoring
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 intelEngine_Core
            .local ::temp1 Bool
            .local q quest
            .local ::temp2 quest
            .local ::nonevar None
            .local ::temp3 Float
            .local giverName String
            .local ::temp4 actor
            .local ::temp5 String
            .local origAggr Float
            .local ::temp6 form
            .local ::temp7 objectReference
            .local ::temp8 keyword
            .local ::temp9 package
            .local ::temp10 Int
            .local deadSlot2 Int
            .local ::temp11 actorBase
            .local slot Int
            .local ::temp12 String
            .local storySlot Int
            .local ::temp13 intelEngine_Battle
            .local ::temp14 intelEngine_Battle
            .local allyName String
            .local player actor
            .local legacyCount Int
            .local li Int
            .local fid Int
            .local lingerNPC actor
            .local lingerCount Int
            .local li2 Int
            .local lingerNPC2 actor
            .local encounterCount Int
            .local ei Int
            .local efid Int
            .local encounterNPC actor
          .endLocalTable
          .code
            ; line 267
            cast ::temp0 None 
            cmp_eq ::temp1 ::Core_var ::temp0 
            jmpf ::temp1 _label0
            ; line 268
            cast ::temp2 self 
            assign q ::temp2 
            ; line 269
            cast ::temp0 q 
            assign ::Core_var ::temp0 
            ; line 270
            cast ::temp0 None 
            cmp_eq ::temp1 ::Core_var ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label1
            ; line 271
            callstatic debug Trace ::nonevar "[IntelEngine] StoryEngine: recovered Core property via cast" 0 ;2 variable args
            jmp _label1
          _label1:
            jmp _label0
            ; line 274
          _label0:
            callmethod ClearPending self ::nonevar ;0 variable args
            ; line 275
            assign ::NPCTickPending_var False 
            ; line 278
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            assign ::LastStoryTickTime_var ::temp3 
            ; line 281
            cmp_eq ::temp1 ::NPCTickIntervalHours_var 0.0 
            jmpf ::temp1 _label2
            ; line 282
            assign ::NPCTickEnabled_var True 
            ; line 283
            assign ::NPCTickIntervalHours_var 1.5 
            ; line 284
            callmethod DebugMsg ::Core_var ::nonevar "Story: NPC Social properties initialized (save migration)" ;1 variable args
            jmp _label2
            ; line 288
          _label2:
            callmethod WarmCooldownMirror self ::nonevar ;0 variable args
            ; line 289
            callmethod WarmStoryTypeCounts self ::nonevar ;0 variable args
            ; line 292
            callmethod ClearStaleRealTimeTimers self ::nonevar ;0 variable args
            ; line 294
            callmethod SyncHoldRestrictionPolicies self ::nonevar ;0 variable args
            ; line 297
            assign ::temp1 ::QuestActive_var 
            jmpf ::temp1 _label3
            cmp_eq ::temp1 ::QuestLocationName_var "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 298
            assign giverName "" 
            ; line 299
            cast ::temp4 None 
            cmp_eq ::temp1 ::QuestGiver_var ::temp4 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label5
            ; line 300
            callmethod GetDisplayName ::QuestGiver_var ::temp5 ;0 variable args
            assign giverName ::temp5 
            jmp _label5
            ; line 302
          _label5:
            callstatic intelEngine NotifyQuestActive ::nonevar ::QuestLocationName_var ::QuestSubType_var ::QuestEnemyType_var giverName ::QuestBriefing_var ::QuestVictimName_var ::QuestItemName_var ::QuestAlliedFaction_var ;8 variable args
            ; line 304
            callmethod DebugMsg ::Core_var ::nonevar "Story: re-pushed quest state to C++ decorator" ;1 variable args
            jmp _label4
            ; line 308
          _label4:
            callstatic intelEngine SetAutoBioEnabled ::nonevar ::AutoBioEnabled_var ;1 variable args
            ; line 309
            callstatic intelEngine SetAutoBioThreshold ::nonevar ::AutoBioThreshold_var ;1 variable args
            ; line 310
            callmethod WarmBioLineCounts self ::nonevar ;0 variable args
            ; line 313
            cast ::temp4 None 
            cmp_eq ::temp1 ::ActiveStoryNPC_var ::temp4 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label6
            ; line 314
            cast ::temp6 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp3 ::temp6 "Intel_OrigAggression" -1.0 ;3 variable args
            assign origAggr ::temp3 
            ; line 315
            comp_gte ::temp1 origAggr 0.0 
            jmpf ::temp1 _label7
            ; line 316
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Aggression" origAggr ;2 variable args
            ; line 317
            cast ::temp6 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp6 "Intel_OrigAggression" ;2 variable args
            ; line 318
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp5 ;0 variable args
            strcat ::temp5 "Story: restored orphaned aggression on " ::temp5 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            jmp _label7
          _label7:
            jmp _label6
            ; line 323
          _label6:
            jmpf ::IsNPCStoryActive_var _label8
            ; line 324
            callmethod DebugMsg ::Core_var ::nonevar "Story: abandoning NPC Social dispatch on load" ;1 variable args
            ; line 325
            callmethod CleanupNPCSocialDispatch self ::nonevar ;0 variable args
            jmp _label8
            ; line 329
          _label8:
            assign ::temp1 ::QuestGuideActive_var 
            jmpf ::temp1 _label9
            cast ::temp4 None 
            cmp_eq ::temp1 ::QuestGuideNPC_var ::temp4 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label9:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label10
            cast ::temp7 None 
            cmp_eq ::temp1 ::QuestLocation_var ::temp7 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label10:
            jmpf ::temp1 _label11
            ; line 330
            callmethod IsDead ::QuestGuideNPC_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label12
            callmethod IsDisabled ::QuestGuideNPC_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label12:
            jmpf ::temp1 _label13
            ; line 331
            assign ::QuestGuideActive_var False 
            ; line 332
            assign ::QuestGuideWaiting_var False 
            ; line 333
            assign ::ActiveStoryType_var "" 
            ; line 334
            assign ::IsActive_var False 
            ; line 335
            callmethod DebugMsg ::Core_var ::nonevar "Story: quest guide died/disabled on load, abandoning guide" ;1 variable args
            jmp _label14
            ; line 337
          _label13:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestGuideNPC_var False ;2 variable args
            ; line 338
            cast ::temp7 ::QuestGuideNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp8 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp7 ::QuestLocation_var ::temp8 ;3 variable args
            ; line 339
            propget TravelPackage_Jog ::Core_var ::temp9 
            propget PRIORITY_TRAVEL ::Core_var ::temp10 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestGuideNPC_var ::temp9 ::temp10 1 ;4 variable args
            ; line 340
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 341
            callmethod EvaluatePackage ::QuestGuideNPC_var ::nonevar ;0 variable args
            ; line 342
            callmethod GetDisplayName ::QuestGuideNPC_var ::temp5 ;0 variable args
            strcat ::temp5 "Story: recovered quest guide jog for " ::temp5 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
          _label14:
            jmp _label15
            ; line 344
          _label11:
            assign ::temp1 ::IsActive_var 
            jmpf ::temp1 _label16
            cast ::temp4 None 
            cmp_eq ::temp1 ::ActiveStoryNPC_var ::temp4 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label16:
            jmpf ::temp1 _label15
            ; line 345
            callmethod IsDead ::ActiveStoryNPC_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label17
            callmethod IsDisabled ::ActiveStoryNPC_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label17:
            jmpf ::temp1 _label18
            ; line 346
            callmethod FindSlotByAgent ::Core_var ::temp10 ::ActiveStoryNPC_var ;1 variable args
            assign deadSlot2 ::temp10 
            ; line 347
            comp_gte ::temp1 deadSlot2 0 
            jmpf ::temp1 _label19
            ; line 348
            callmethod ClearSlot ::Core_var ::nonevar deadSlot2 True False ;3 variable args
            jmp _label19
            ; line 350
          _label19:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 351
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            jmp _label20
            ; line 352
          _label18:
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label21
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush_charge" 
            assign ::temp1 ::temp1 
          _label21:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label22
            cmp_eq ::temp1 ::ActiveStoryType_var "stalker" 
            assign ::temp1 ::temp1 
          _label22:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label23
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush_combat" 
            assign ::temp1 ::temp1 
          _label23:
            jmpf ::temp1 _label24
            ; line 355
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush_combat" 
            jmpf ::temp1 _label25
            ; line 357
            callmethod GetActorBase ::ActiveStoryNPC_var ::temp11 ;0 variable args
            callmethod SetEssential ::temp11 ::nonevar False ;1 variable args
            ; line 358
            callmethod StopCombat ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 359
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Aggression" 0.0 ;2 variable args
            ; line 360
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Confidence" 2.0 ;2 variable args
            jmp _label26
            ; line 361
          _label25:
            cmp_eq ::temp1 ::ActiveStoryType_var "stalker" 
            jmpf ::temp1 _label26
            jmp _label26
            ; line 364
          _label26:
            strcat ::temp5 "Story: abandoning " ::ActiveStoryType_var 
            strcat ::temp5 ::temp5 " on load (sneak/combat/flee state lost)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            ; line 365
            callmethod FindSlotByAgent ::Core_var ::temp10 ::ActiveStoryNPC_var ;1 variable args
            assign slot ::temp10 
            ; line 366
            comp_gte ::temp1 slot 0 
            jmpf ::temp1 _label27
            ; line 367
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label27
            ; line 369
          _label27:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 370
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            jmp _label20
            ; line 375
          _label24:
            strcat ::temp5 "Story: abandoning " ::ActiveStoryType_var 
            strcat ::temp5 ::temp5 " for " 
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp12 ;0 variable args
            strcat ::temp12 ::temp5 ::temp12 
            strcat ::temp12 ::temp12 " on load" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp12 ;1 variable args
            ; line 376
            callmethod FindSlotByAgent ::Core_var ::temp10 ::ActiveStoryNPC_var ;1 variable args
            assign storySlot ::temp10 
            ; line 377
            comp_gte ::temp1 storySlot 0 
            jmpf ::temp1 _label28
            ; line 378
            callmethod ClearSlot ::Core_var ::nonevar storySlot True False ;3 variable args
            jmp _label28
            ; line 380
          _label28:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 381
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
          _label20:
            jmp _label15
            ; line 386
          _label15:
            assign ::temp1 ::QuestActive_var 
            jmpf ::temp1 _label29
            cmp_eq ::temp1 ::QuestSubType_var "rescue" 
            assign ::temp1 ::temp1 
          _label29:
            jmpf ::temp1 _label30
            ; line 387
            cast ::temp4 None 
            cmp_eq ::temp1 ::QuestVictimNPC_var ::temp4 
            jmpf ::temp1 _label31
            ; line 388
            callmethod DebugMsg ::Core_var ::nonevar "Story: quest/rescue victim lost on load, expiring quest" ;1 variable args
            ; line 389
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 390
            callmethod CleanupQuest self ::nonevar ;0 variable args
            jmp _label32
            ; line 391
          _label31:
            not ::temp1 ::QuestVictimFreed_var 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label33
            assign ::temp1 ::QuestEnemiesSpawned_var 
          _label33:
            jmpf ::temp1 _label32
            ; line 393
            jmpf ::QuestVictimInFurniture_var _label34
            ; line 395
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 396
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp12 ;0 variable args
            strcat ::temp12 "Story: re-applied furniture DontMove on load for " ::temp12 
            callmethod DebugMsg ::Core_var ::nonevar ::temp12 ;1 variable args
            jmp _label35
            ; line 400
          _label34:
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 401
            callmethod GetActorValue ::QuestVictimNPC_var ::temp3 "Health" ;1 variable args
            fadd ::temp3 ::temp3 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp3 ;2 variable args
            ; line 402
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 403
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp12 ;0 variable args
            strcat ::temp12 "Story: re-applied victim bleedout on load for " ::temp12 
            callmethod DebugMsg ::Core_var ::nonevar ::temp12 ;1 variable args
          _label35:
            jmp _label32
          _label32:
            jmp _label30
            ; line 410
          _label30:
            assign ::temp1 ::QuestActive_var 
            jmpf ::temp1 _label36
            assign ::temp1 ::QuestBattleScheduled_var 
          _label36:
            jmpf ::temp1 _label37
            ; line 411
            propget Battle ::Core_var ::temp13 
            cast ::temp14 None 
            cmp_eq ::temp1 ::temp13 ::temp14 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label38
            propget Battle ::Core_var ::temp14 
            propget BattleScheduled ::temp14 ::temp1 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label39
            callstatic intelEngine IsBattleActive ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label39:
            assign ::temp1 ::temp1 
          _label38:
            jmpf ::temp1 _label40
            ; line 412
            callmethod DebugMsg ::Core_var ::nonevar "Story: faction_battle quest — battle schedule lost on load, granting partial credit" ;1 variable args
            ; line 413
            callstatic debug Notification ::nonevar "The fighting has ended before you arrived." ;1 variable args
            ; line 415
            cmp_eq ::temp1 ::QuestAlliedFaction_var "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label41
            ; line 416
            propget QUEST_STANDING_REWARD self ::temp10 
            idiv ::temp10 ::temp10 2 
            callstatic intelEngine AdjustPlayerFactionStanding ::temp10 ::QuestAlliedFaction_var ::temp10 ;2 variable args
            ; line 417
            callstatic intelEngine GetFactionDisplayName ::temp12 ::QuestAlliedFaction_var ;1 variable args
            assign allyName ::temp12 
            ; line 418
            cmp_eq ::temp1 allyName "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label42
            ; line 419
            strcat ::temp12 "The " allyName 
            strcat ::temp12 ::temp12 " acknowledge your intent to fight." 
            callstatic debug Notification ::nonevar ::temp12 ;1 variable args
            jmp _label42
          _label42:
            jmp _label41
            ; line 422
          _label41:
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 423
            callmethod CleanupQuest self ::nonevar ;0 variable args
            jmp _label40
          _label40:
            jmp _label37
            ; line 430
          _label37:
            callstatic game GetPlayer ::temp4 ;0 variable args
            assign player ::temp4 
            ; line 433
            cast ::temp6 player 
            callstatic storageUtil IntListCount ::temp10 ::temp6 "Intel_StoryLingerNPCs" ;2 variable args
            assign legacyCount ::temp10 
            ; line 434
            cmp_gt ::temp1 legacyCount 0 
            jmpf ::temp1 _label43
            ; line 435
            cast ::temp12 legacyCount 
            strcat ::temp12 "Story: releasing " ::temp12 
            strcat ::temp12 ::temp12 " legacy linger NPCs on load" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp12 ;1 variable args
            ; line 436
            assign li 0 
            ; line 437
          _label46:
            cmp_lt ::temp1 li legacyCount 
            jmpf ::temp1 _label44
            ; line 438
            cast ::temp6 player 
            callstatic storageUtil IntListGet ::temp10 ::temp6 "Intel_StoryLingerNPCs" li ;3 variable args
            assign fid ::temp10 
            ; line 439
            callstatic game GetForm ::temp6 fid ;1 variable args
            cast ::temp4 ::temp6 
            assign lingerNPC ::temp4 
            ; line 440
            cast ::temp4 None 
            cmp_eq ::temp1 lingerNPC ::temp4 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label45
            ; line 441
            callmethod ReleaseLinger ::Core_var ::nonevar lingerNPC ;1 variable args
            ; line 442
            cast ::temp6 lingerNPC 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp6 "Intel_StoryLingerStart" ;2 variable args
            jmp _label45
            ; line 444
          _label45:
            iadd ::temp10 li 1 
            assign li ::temp10 
            jmp _label46
          _label44:
            jmp _label43
            ; line 447
          _label43:
            cast ::temp6 player 
            callstatic storageUtil IntListClear ::temp10 ::temp6 "Intel_StoryLingerNPCs" ;2 variable args
            ; line 450
            cast ::temp6 player 
            callstatic storageUtil FormListCount ::temp10 ::temp6 "Intel_StoryLingerActors" ;2 variable args
            assign lingerCount ::temp10 
            ; line 451
            cmp_gt ::temp1 lingerCount 0 
            jmpf ::temp1 _label47
            ; line 452
            cast ::temp12 lingerCount 
            strcat ::temp12 "Story: releasing " ::temp12 
            strcat ::temp12 ::temp12 " orphaned linger NPCs on load" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp12 ;1 variable args
            ; line 453
            assign li2 0 
            ; line 454
          _label50:
            cmp_lt ::temp1 li2 lingerCount 
            jmpf ::temp1 _label48
            ; line 455
            cast ::temp6 player 
            callstatic storageUtil FormListGet ::temp6 ::temp6 "Intel_StoryLingerActors" li2 ;3 variable args
            cast ::temp4 ::temp6 
            assign lingerNPC2 ::temp4 
            ; line 456
            cast ::temp4 None 
            cmp_eq ::temp1 lingerNPC2 ::temp4 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label49
            ; line 457
            callmethod ReleaseLinger ::Core_var ::nonevar lingerNPC2 ;1 variable args
            ; line 458
            cast ::temp6 lingerNPC2 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp6 "Intel_StoryLingerStart" ;2 variable args
            jmp _label49
            ; line 460
          _label49:
            iadd ::temp10 li2 1 
            assign li2 ::temp10 
            jmp _label50
          _label48:
            jmp _label47
            ; line 463
          _label47:
            cast ::temp6 player 
            callstatic storageUtil FormListClear ::temp10 ::temp6 "Intel_StoryLingerActors" ;2 variable args
            ; line 468
            cast ::temp6 player 
            callstatic storageUtil IntListCount ::temp10 ::temp6 "Intel_FakeEncounterNPCs" ;2 variable args
            assign encounterCount ::temp10 
            ; line 469
            cmp_gt ::temp1 encounterCount 0 
            jmpf ::temp1 _label51
            ; line 470
            cast ::temp12 encounterCount 
            strcat ::temp12 "Story: releasing " ::temp12 
            strcat ::temp12 ::temp12 " orphaned road encounter NPCs on load" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp12 ;1 variable args
            ; line 471
            assign ei 0 
            ; line 472
          _label54:
            cmp_lt ::temp1 ei encounterCount 
            jmpf ::temp1 _label52
            ; line 473
            cast ::temp6 player 
            callstatic storageUtil IntListGet ::temp10 ::temp6 "Intel_FakeEncounterNPCs" ei ;3 variable args
            assign efid ::temp10 
            ; line 474
            callstatic game GetForm ::temp6 efid ;1 variable args
            cast ::temp4 ::temp6 
            assign encounterNPC ::temp4 
            ; line 475
            cast ::temp4 None 
            cmp_eq ::temp1 encounterNPC ::temp4 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label53
            ; line 476
            callmethod ClearRoadEncounterTravelState self ::nonevar encounterNPC ;1 variable args
            ; line 477
            cast ::temp6 encounterNPC 
            callstatic storageUtil UnsetStringValue ::temp1 ::temp6 "Intel_FakeEncounterNarration" ;2 variable args
            ; line 478
            cast ::temp6 encounterNPC 
            callstatic storageUtil UnsetIntValue ::temp1 ::temp6 "Intel_FakeEncounterInteracted" ;2 variable args
            ; line 479
            cast ::temp6 encounterNPC 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp6 "Intel_FakeEncounterGreetTime" ;2 variable args
            ; line 480
            cast ::temp6 encounterNPC 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp6 "Intel_FakeEncounterTime" ;2 variable args
            ; line 481
            callmethod MoveToMyEditorLocation encounterNPC ::nonevar ;0 variable args
            jmp _label53
            ; line 483
          _label53:
            iadd ::temp10 ei 1 
            assign ei ::temp10 
            jmp _label54
            ; line 485
          _label52:
            cast ::temp6 player 
            callstatic storageUtil IntListClear ::temp10 ::temp6 "Intel_FakeEncounterNPCs" ;2 variable args
            jmp _label51
            ; line 488
          _label51:
            callmethod StartScheduler self ::nonevar ;0 variable args
          .endCode
        .endFunction ;RestartMonitoring
        .function OnUpdateGameTime
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 Float
            .local ::temp1 String
            .local ::temp2 Bool
          .endLocalTable
          .code
            ; line 493
            callstatic utility GetCurrentGameTime ::temp0 ;0 variable args
            cast ::temp1 ::temp0 
            strcat ::temp1 "Story: OnUpdateGameTime fired (gameTime=" ::temp1 
            strcat ::temp1 ::temp1 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 496
            callmethod StartScheduler self ::nonevar ;0 variable args
            ; line 499
            callmethod CheckStoryLingerCleanup self ::nonevar ;0 variable args
            ; line 501
            callmethod CheckRescuedNPCDeaths self ::nonevar ;0 variable args
            ; line 503
            callmethod HasLingerNPCs self ::temp2 ;0 variable args
            jmpf ::temp2 _label0
            ; line 504
            propget MONITOR_INTERVAL self ::temp0 
            callmethod RegisterForSingleUpdate self ::nonevar ::temp0 ;1 variable args
            jmp _label0
            ; line 509
          _label0:
            callmethod TickScheduler self ::nonevar ;0 variable args
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
            .local needsRealTime Bool
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 Float
            .local now Float
            .local storyInterval Float
            .local ::temp2 intelEngine_Core
            .local npcInterval Float
            .local politicsInterval Float
            .local ::temp3 Int
            .local minInterval Float
            .local intervalDays Float
            .local sinceLastTick Float
            .local ::temp4 String
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 516
            assign ::temp0 ::IsActive_var 
            jmpt ::temp0 _label0
            assign ::temp0 ::IsNPCStoryActive_var 
          _label0:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label1
            callmethod HasLingerNPCs self ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label1:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label2
            assign ::temp0 ::QuestActive_var 
          _label2:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label3
            assign ::temp0 ::FactionAmbushActive_var 
          _label3:
            assign needsRealTime ::temp0 
            ; line 517
            jmpf needsRealTime _label4
            ; line 518
            propget MONITOR_INTERVAL self ::temp1 
            callmethod RegisterForSingleUpdate self ::nonevar ::temp1 ;1 variable args
            jmp _label4
            ; line 521
          _label4:
            callmethod CheckRoadEncounterProximity self ::nonevar ;0 variable args
            ; line 522
            callmethod CheckStoryLingerCleanup self ::nonevar ;0 variable args
            ; line 523
            callmethod CheckFactionAmbushCleanup self ::nonevar ;0 variable args
            ; line 527
            jmpf ::QuestActive_var _label5
            ; line 528
            jmpf ::QuestGuideActive_var _label6
            ; line 529
            callmethod CheckQuestGuide self ::nonevar ;0 variable args
            jmp _label6
            ; line 531
          _label6:
            callmethod CheckQuestProximity self ::nonevar ;0 variable args
            ; line 532
            callmethod CheckQuestExpiry self ::nonevar ;0 variable args
            jmp _label5
            ; line 536
          _label5:
            jmpf ::IsActive_var _label7
            ; line 537
            callmethod CheckStoryNPCArrival self ::nonevar ;0 variable args
            jmp _label7
            ; line 539
          _label7:
            jmpf ::IsNPCStoryActive_var _label8
            ; line 540
            callmethod CheckNPCSocialArrival self ::nonevar ;0 variable args
            jmp _label8
            ; line 545
          _label8:
            not ::temp0 needsRealTime 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label9
            assign ::temp0 ::IsActive_var 
            jmpt ::temp0 _label10
            assign ::temp0 ::IsNPCStoryActive_var 
          _label10:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label11
            callmethod HasLingerNPCs self ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label11:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label12
            assign ::temp0 ::QuestActive_var 
          _label12:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label13
            assign ::temp0 ::FactionAmbushActive_var 
          _label13:
            assign ::temp0 ::temp0 
          _label9:
            jmpf ::temp0 _label14
            ; line 546
            propget MONITOR_INTERVAL self ::temp1 
            callmethod RegisterForSingleUpdate self ::nonevar ::temp1 ;1 variable args
            jmp _label15
            ; line 547
          _label14:
            not ::temp0 needsRealTime 
            jmpf ::temp0 _label15
            ; line 548
            callmethod StartScheduler self ::nonevar ;0 variable args
            jmp _label15
            ; line 554
          _label15:
            callstatic utility GetCurrentGameTime ::temp1 ;0 variable args
            assign now ::temp1 
            ; line 555
            assign storyInterval 3.0 
            ; line 556
            cast ::temp2 None 
            cmp_eq ::temp0 ::Core_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label16
            ; line 557
            callmethod GetStoryEngineInterval ::Core_var ::temp1 ;0 variable args
            assign storyInterval ::temp1 
            jmp _label16
            ; line 559
          _label16:
            assign npcInterval ::NPCTickIntervalHours_var 
            ; line 560
            callstatic intelEngine GetPoliticsTickInterval ::temp3 ;0 variable args
            cast ::temp1 ::temp3 
            assign politicsInterval ::temp1 
            ; line 561
            cmp_lte ::temp0 politicsInterval 0.0 
            jmpf ::temp0 _label17
            ; line 562
            assign politicsInterval 6.0 
            jmp _label17
            ; line 564
          _label17:
            assign minInterval storyInterval 
            ; line 565
            cmp_gt ::temp0 npcInterval 0.0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label18
            cmp_lt ::temp0 npcInterval minInterval 
            assign ::temp0 ::temp0 
          _label18:
            jmpf ::temp0 _label19
            ; line 566
            assign minInterval npcInterval 
            jmp _label19
            ; line 568
          _label19:
            cmp_gt ::temp0 politicsInterval 0.0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label20
            cmp_lt ::temp0 politicsInterval minInterval 
            assign ::temp0 ::temp0 
          _label20:
            jmpf ::temp0 _label21
            ; line 569
            assign minInterval politicsInterval 
            jmp _label21
            ; line 571
          _label21:
            fdiv ::temp1 minInterval 24.0 
            assign intervalDays ::temp1 
            ; line 572
            fsub ::temp1 now ::LastIdlePollTickTime_var 
            assign sinceLastTick ::temp1 
            ; line 573
            comp_gte ::temp0 sinceLastTick intervalDays 
            jmpf ::temp0 _label22
            ; line 574
            fmul ::temp1 sinceLastTick 24.0 
            cast ::temp4 ::temp1 
            strcat ::temp4 "Story: OnUpdate idle-poll — triggering TickScheduler (elapsed=" ::temp4 
            strcat ::temp4 ::temp4 "h, threshold=" 
            cast ::temp5 minInterval 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 "h)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            ; line 575
            assign ::LastIdlePollTickTime_var now 
            ; line 576
            callmethod TickScheduler self ::nonevar ;0 variable args
            jmp _label22
            ; line 582
          _label22:
            assign ::temp0 needsRealTime 
            jmpf ::temp0 _label23
            not ::temp0 ::IsActive_var 
            assign ::temp0 ::temp0 
          _label23:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label24
            not ::temp0 ::IsNPCStoryActive_var 
            assign ::temp0 ::temp0 
          _label24:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label25
            callmethod HasLingerNPCs self ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label25:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label26
            not ::temp0 ::QuestActive_var 
            assign ::temp0 ::temp0 
          _label26:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label27
            not ::temp0 ::FactionAmbushActive_var 
            assign ::temp0 ::temp0 
          _label27:
            jmpf ::temp0 _label28
            ; line 583
            callmethod DebugMsg ::Core_var ::nonevar "Story: OnUpdate — transitioning real-time to game-time (all flags cleared). Calling StartScheduler." ;1 variable args
            ; line 584
            callmethod StartScheduler self ::nonevar ;0 variable args
            ; line 585
            callmethod DebugMsg ::Core_var ::nonevar "Story: OnUpdate — StartScheduler returned after transition" ;1 variable args
            jmp _label28
          _label28
          .endCode
        .endFunction ;OnUpdate
        .function TickScheduler
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 intelEngine_Core
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 String
            .local ::temp3 String
            .local ::temp4 intelEngine_Politics
            .local ::temp5 intelEngine_Politics
            .local storyInterval Float
            .local ::temp6 Float
            .local storyElapsed Float
            .local player actor
            .local ::temp7 actor
            .local gossipCount Int
            .local ::temp8 form
            .local ::temp9 Int
            .local gossipLines String
            .local gi Int
            .local gossipShown Int
            .local gNpc1 String
            .local gNpc2 String
            .local gText String
            .local gLoc String
            .local excludeList String
            .local ::temp10 quest
          .endLocalTable
          .code
            ; line 594
            cast ::temp0 None 
            cmp_eq ::temp1 ::Core_var ::temp0 
            jmpf ::temp1 _label0
            ; line 595
            callstatic debug Trace ::nonevar "[IntelEngine] TickScheduler: Core is None — aborting" 0 ;2 variable args
            ; line 596
            return None 
            jmp _label0
            ; line 598
          _label0:
            cast ::temp2 ::IsActive_var 
            strcat ::temp2 "Story: TickScheduler — running (IsActive=" ::temp2 
            strcat ::temp2 ::temp2 ", storyEnabled=" 
            callmethod IsStoryEngineEnabled ::Core_var ::temp1 ;0 variable args
            cast ::temp3 ::temp1 
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 601
            cmp_eq ::temp1 ::DangerZonePolicy_var 0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            assign ::temp1 ::BlockCiviliansInDanger_var 
            jmpt ::temp1 _label2
            assign ::temp1 ::BlockAllInDanger_var 
          _label2:
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label3
            ; line 602
            jmpf ::BlockAllInDanger_var _label4
            ; line 603
            assign ::DangerZonePolicy_var 3 
            jmp _label5
          _label4:
            jmpf ::BlockCiviliansInDanger_var _label5
            ; line 605
            assign ::DangerZonePolicy_var 1 
            jmp _label5
            ; line 607
          _label5:
            cast ::temp3 ::DangerZonePolicy_var 
            strcat ::temp3 "Story: migrated danger zone policy to " ::temp3 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label3
            ; line 611
          _label3:
            callstatic intelEngine SetDangerZonePolicy ::nonevar ::DangerZonePolicy_var ;1 variable args
            ; line 612
            callstatic intelEngine SetPlayerHomePolicy ::nonevar ::PlayerHomePolicy_var ;1 variable args
            ; line 614
            callmethod SyncHoldRestrictionPolicies self ::nonevar ;0 variable args
            ; line 617
            callmethod TickNPCInteractions self ::nonevar ;0 variable args
            ; line 624
            cast ::temp0 None 
            cmp_eq ::temp1 ::Core_var ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label6
            propget Politics ::Core_var ::temp4 
            cast ::temp5 None 
            cmp_eq ::temp1 ::temp4 ::temp5 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label6:
            jmpf ::temp1 _label7
            ; line 625
            propget Politics ::Core_var ::temp5 
            callmethod TickNow ::temp5 ::nonevar ;0 variable args
            jmp _label7
            ; line 629
          _label7:
            callmethod CleanupStrandedEncounters self ::nonevar ;0 variable args
            ; line 632
            callmethod CheckRescuedNPCDeaths self ::nonevar ;0 variable args
            ; line 636
            assign storyInterval 3.0 
            ; line 637
            cast ::temp0 None 
            cmp_eq ::temp1 ::Core_var ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label8
            ; line 638
            callmethod GetStoryEngineInterval ::Core_var ::temp6 ;0 variable args
            assign storyInterval ::temp6 
            jmp _label8
            ; line 640
          _label8:
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            fsub ::temp6 ::temp6 ::LastStoryTickTime_var 
            fmul ::temp6 ::temp6 24.0 
            assign storyElapsed ::temp6 
            ; line 641
            cmp_lt ::temp1 storyElapsed storyInterval 
            jmpf ::temp1 _label9
            ; line 642
            return None 
            jmp _label9
            ; line 646
          _label9:
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            assign ::LastStoryTickTime_var ::temp6 
            ; line 647
            cast ::temp3 storyElapsed 
            strcat ::temp3 "Story: TickScheduler — story interval reached (" ::temp3 
            strcat ::temp3 ::temp3 "h >= " 
            cast ::temp2 storyInterval 
            strcat ::temp2 ::temp3 ::temp2 
            strcat ::temp2 ::temp2 "h)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 650
            callmethod IsStoryEngineEnabled ::Core_var ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label10
            ; line 651
            callmethod DebugMsg ::Core_var ::nonevar "Story: TickScheduler — story engine disabled, skipping DM call" ;1 variable args
            ; line 652
            return None 
            jmp _label10
            ; line 655
          _label10:
            jmpf ::IsActive_var _label11
            ; line 658
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            callstatic intelEngine ShouldResetPending ::temp1 "storyDM" 6.0 ::temp6 ;3 variable args
            jmpf ::temp1 _label12
            ; line 659
            callmethod DebugMsg ::Core_var ::nonevar "Story: watchdog reset IsActive (stuck or stale)" ;1 variable args
            ; line 660
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 663
            return None 
            jmp _label12
          _label12:
            jmp _label11
            ; line 667
          _label11:
            not ::temp1 ::IsActive_var 
            jmpf ::temp1 _label13
            ; line 668
            callstatic game GetPlayer ::temp7 ;0 variable args
            assign player ::temp7 
            ; line 669
            callmethod IsInCombat player ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label14
            ; line 671
            cast ::temp8 player 
            callstatic storageUtil StringListCount ::temp9 ::temp8 "Intel_SocialLog_Type" ;2 variable args
            assign gossipCount ::temp9 
            ; line 672
            cmp_gt ::temp1 gossipCount 0 
            jmpf ::temp1 _label15
            ; line 673
            assign gossipLines "" 
            ; line 674
            isub ::temp9 gossipCount 1 
            assign gi ::temp9 
            ; line 675
            assign gossipShown 0 
            ; line 676
          _label20:
            comp_gte ::temp1 gi 0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label16
            cmp_lt ::temp1 gossipShown 5 
            assign ::temp1 ::temp1 
          _label16:
            jmpf ::temp1 _label17
            ; line 677
            cast ::temp8 player 
            callstatic storageUtil StringListGet ::temp2 ::temp8 "Intel_SocialLog_NPC1" gi ;3 variable args
            assign gNpc1 ::temp2 
            ; line 678
            cast ::temp8 player 
            callstatic storageUtil StringListGet ::temp2 ::temp8 "Intel_SocialLog_NPC2" gi ;3 variable args
            assign gNpc2 ::temp2 
            ; line 679
            cast ::temp8 player 
            callstatic storageUtil StringListGet ::temp2 ::temp8 "Intel_SocialLog_Text" gi ;3 variable args
            assign gText ::temp2 
            ; line 680
            cast ::temp8 player 
            callstatic storageUtil StringListGet ::temp2 ::temp8 "Intel_SocialLog_Location" gi ;3 variable args
            assign gLoc ::temp2 
            ; line 681
            cmp_eq ::temp1 gLoc "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label18
            ; line 682
            strcat ::temp2 "- [" gLoc 
            strcat ::temp2 ::temp2 "] " 
            strcat ::temp2 ::temp2 gNpc1 
            strcat ::temp2 ::temp2 " told " 
            strcat ::temp2 ::temp2 gNpc2 
            strcat ::temp2 ::temp2 ": " 
            strcat ::temp2 ::temp2 gText 
            strcat ::temp2 ::temp2 "\n" 
            strcat ::temp2 gossipLines ::temp2 
            assign gossipLines ::temp2 
            jmp _label19
            ; line 684
          _label18:
            strcat ::temp2 "- " gNpc1 
            strcat ::temp2 ::temp2 " told " 
            strcat ::temp2 ::temp2 gNpc2 
            strcat ::temp2 ::temp2 ": " 
            strcat ::temp2 ::temp2 gText 
            strcat ::temp2 ::temp2 "\n" 
            strcat ::temp2 gossipLines ::temp2 
            assign gossipLines ::temp2 
            ; line 686
          _label19:
            iadd ::temp9 gossipShown 1 
            assign gossipShown ::temp9 
            ; line 687
            isub ::temp9 gi 1 
            assign gi ::temp9 
            jmp _label20
            ; line 689
          _label17:
            callstatic intelEngine SetRecentGossipContext ::nonevar gossipLines ;1 variable args
            jmp _label21
            ; line 691
          _label15:
            callstatic intelEngine SetRecentGossipContext ::nonevar "" ;1 variable args
            ; line 697
          _label21:
            assign ::PendingStoryType_var "dm_analysis" 
            ; line 698
            callmethod BuildExcludeList self ::temp2 player ;1 variable args
            assign excludeList ::temp2 
            ; line 700
            cast ::temp10 self 
            callstatic intelEngine BeginAsyncStoryDMTick ::nonevar 7 ::LongAbsenceDaysConfig_var excludeList ::temp10 "IntelEngine_StoryEngine" "OnStoryDMContextReady" ;6 variable args
            jmp _label14
          _label14:
            jmp _label13
          _label13
          .endCode
        .endFunction ;TickScheduler
        .function OnStoryDMContextReady
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param contextJson String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 706
            cmp_eq ::temp0 contextJson "" 
            jmpf ::temp0 _label0
            ; line 707
            callmethod ClearPending self ::nonevar ;0 variable args
            ; line 708
            return None 
            jmp _label0
            ; line 710
          _label0:
            callmethod SendStoryLLMRequest self ::nonevar "intel_story_dm" "OnDungeonMasterResponse" contextJson ;3 variable args
          .endCode
        .endFunction ;OnStoryDMContextReady
        .function IsNPCToNPCType
           ; function type 0
          .userFlags 0 ;none
          .docString "Returns true if current active story type targets another NPC (not the player)."
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 715
            cmp_eq ::temp0 ::ActiveStoryType_var "npc_interaction" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cmp_eq ::temp0 ::ActiveStoryType_var "npc_gossip" 
            assign ::temp0 ::temp0 
          _label0:
            return ::temp0 
          .endCode
        .endFunction ;IsNPCToNPCType
        .function BuildExcludeList
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
            .param player actor
          .endParamTable
          .localTable
            .local toggles Int
            .local ::temp0 Int
            .local envFlags Int
            .local pCell cell
            .local ::temp1 cell
            .local ::temp2 Bool
            .local result String
            .local ::temp3 String
            .local ::nonevar None
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 723
            assign toggles 0 
            ; line 724
            jmpf ::TypeSeekPlayerEnabled_var _label0
            ; line 725
            iadd ::temp0 toggles 1 
            assign toggles ::temp0 
            jmp _label0
            ; line 727
          _label0:
            jmpf ::TypeInformantEnabled_var _label1
            ; line 728
            iadd ::temp0 toggles 2 
            assign toggles ::temp0 
            jmp _label1
            ; line 730
          _label1:
            jmpf ::TypeRoadEncounterEnabled_var _label2
            ; line 731
            iadd ::temp0 toggles 4 
            assign toggles ::temp0 
            jmp _label2
            ; line 733
          _label2:
            jmpf ::TypeAmbushEnabled_var _label3
            ; line 734
            iadd ::temp0 toggles 8 
            assign toggles ::temp0 
            jmp _label3
            ; line 736
          _label3:
            jmpf ::TypeStalkerEnabled_var _label4
            ; line 737
            iadd ::temp0 toggles 16 
            assign toggles ::temp0 
            jmp _label4
            ; line 739
          _label4:
            jmpf ::TypeMessageEnabled_var _label5
            ; line 740
            iadd ::temp0 toggles 32 
            assign toggles ::temp0 
            jmp _label5
            ; line 742
          _label5:
            jmpf ::TypeQuestEnabled_var _label6
            ; line 743
            iadd ::temp0 toggles 64 
            assign toggles ::temp0 
            jmp _label6
            ; line 745
          _label6:
            jmpf ::TypeFactionAmbushEnabled_var _label7
            ; line 746
            iadd ::temp0 toggles 128 
            assign toggles ::temp0 
            jmp _label7
            ; line 748
          _label7:
            jmpf ::QuestSubTypeCombatEnabled_var _label8
            ; line 749
            iadd ::temp0 toggles 256 
            assign toggles ::temp0 
            jmp _label8
            ; line 751
          _label8:
            jmpf ::QuestSubTypeRescueEnabled_var _label9
            ; line 752
            iadd ::temp0 toggles 512 
            assign toggles ::temp0 
            jmp _label9
            ; line 754
          _label9:
            jmpf ::QuestSubTypeFindItemEnabled_var _label10
            ; line 755
            iadd ::temp0 toggles 1024 
            assign toggles ::temp0 
            jmp _label10
            ; line 757
          _label10:
            jmpf ::QuestSubTypeFactionCombatEnabled_var _label11
            ; line 758
            iadd ::temp0 toggles 2048 
            assign toggles ::temp0 
            jmp _label11
            ; line 760
          _label11:
            jmpf ::QuestSubTypeFactionRescueEnabled_var _label12
            ; line 761
            iadd ::temp0 toggles 4096 
            assign toggles ::temp0 
            jmp _label12
            ; line 763
          _label12:
            jmpf ::QuestSubTypeFactionBattleEnabled_var _label13
            ; line 764
            iadd ::temp0 toggles 8192 
            assign toggles ::temp0 
            jmp _label13
            ; line 768
          _label13:
            assign envFlags 0 
            ; line 769
            callmethod GetParentCell player ::temp1 ;0 variable args
            assign pCell ::temp1 
            ; line 770
            cast ::temp1 None 
            cmp_eq ::temp2 pCell ::temp1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label14
            callmethod IsInterior pCell ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
          _label14:
            jmpf ::temp2 _label15
            ; line 771
            iadd ::temp0 envFlags 1 
            assign envFlags ::temp0 
            jmp _label15
            ; line 773
          _label15:
            callstatic intelEngine IsPlayerInDangerousLocation ::temp2 ;0 variable args
            jmpf ::temp2 _label16
            ; line 774
            iadd ::temp0 envFlags 2 
            assign envFlags ::temp0 
            jmp _label16
            ; line 778
          _label16:
            callstatic intelEngine BuildExcludeList ::temp3 toggles envFlags ;2 variable args
            assign result ::temp3 
            ; line 779
            strcat ::temp3 "BuildExcludeList: [" result 
            strcat ::temp3 ::temp3 "] (ambush=" 
            cast ::temp4 ::TypeAmbushEnabled_var 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 " message=" 
            cast ::temp3 ::TypeMessageEnabled_var 
            strcat ::temp3 ::temp4 ::temp3 
            strcat ::temp3 ::temp3 " quest=" 
            cast ::temp4 ::TypeQuestEnabled_var 
            strcat ::temp4 ::temp3 ::temp4 
            strcat ::temp4 ::temp4 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            ; line 780
            return result 
          .endCode
        .endFunction ;BuildExcludeList
        .function TickNPCInteractions
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local currentTime Float
            .local ::temp1 Float
            .local ::nonevar None
            .local intervalDays Float
            .local ::temp2 quest
          .endLocalTable
          .code
            ; line 788
            not ::temp0 ::NPCTickEnabled_var 
            jmpf ::temp0 _label0
            ; line 789
            return None 
            jmp _label0
            ; line 791
          _label0:
            not ::temp0 ::TypeNPCInteractionEnabled_var 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label1
            not ::temp0 ::TypeNPCGossipEnabled_var 
            assign ::temp0 ::temp0 
          _label1:
            jmpf ::temp0 _label2
            ; line 792
            return None 
            jmp _label2
            ; line 794
          _label2:
            callstatic utility GetCurrentGameTime ::temp1 ;0 variable args
            assign currentTime ::temp1 
            ; line 796
            jmpf ::NPCTickPending_var _label3
            ; line 797
            callstatic intelEngine ShouldResetPending ::temp0 "npcInteraction" 1.0 currentTime ;3 variable args
            jmpf ::temp0 _label4
            ; line 798
            callmethod DebugMsg ::Core_var ::nonevar "NPC DM: watchdog reset NPCTickPending (stuck or stale)" ;1 variable args
            ; line 799
            assign ::NPCTickPending_var False 
            jmp _label5
            ; line 801
          _label4:
            return None 
          _label5:
            jmp _label3
            ; line 805
          _label3:
            fdiv ::temp1 ::NPCTickIntervalHours_var 24.0 
            assign intervalDays ::temp1 
            ; line 806
            cmp_gt ::temp0 ::LastNPCTickTime_var 0.0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label6
            fsub ::temp1 currentTime ::LastNPCTickTime_var 
            cmp_lt ::temp0 ::temp1 intervalDays 
            assign ::temp0 ::temp0 
          _label6:
            jmpf ::temp0 _label7
            ; line 807
            return None 
            jmp _label7
            ; line 810
          _label7:
            assign ::LastNPCTickTime_var currentTime 
            ; line 811
            assign ::NPCTickPending_var True 
            ; line 812
            callstatic intelEngine MarkSystemPending ::nonevar "npcInteraction" currentTime ;2 variable args
            ; line 817
            cast ::temp2 self 
            callstatic intelEngine BeginAsyncNPCDMTick ::nonevar 4 ::temp2 "IntelEngine_StoryEngine" "OnNPCDMContextReady" ;4 variable args
          .endCode
        .endFunction ;TickNPCInteractions
        .function OnNPCDMContextReady
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param contextJson String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local result Int
            .local ::temp1 quest
            .local ::temp2 Int
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 821
            cmp_eq ::temp0 contextJson "" 
            jmpf ::temp0 _label0
            ; line 822
            assign ::NPCTickPending_var False 
            ; line 823
            callstatic intelEngine ClearSystemPending ::nonevar "npcInteraction" ;1 variable args
            ; line 824
            return None 
            jmp _label0
            ; line 830
          _label0:
            cast ::temp1 self 
            callstatic skyrimNetApi SendCustomPromptToLLM ::temp2 "intel_story_npc_dm" "intel_story_dm" contextJson ::temp1 "IntelEngine_StoryEngine" "OnNPCInteractionResponse" ;6 variable args
            assign result ::temp2 
            ; line 831
            cmp_lt ::temp0 result 0 
            jmpf ::temp0 _label1
            ; line 832
            cast ::temp3 result 
            strcat ::temp3 "[IntelEngine] StoryEngine: NPC DM LLM call failed code " ::temp3 
            callstatic debug Trace ::nonevar ::temp3 0 ;2 variable args
            ; line 833
            assign ::NPCTickPending_var False 
            ; line 834
            callstatic intelEngine ClearSystemPending ::nonevar "npcInteraction" ;1 variable args
            jmp _label1
          _label1
          .endCode
        .endFunction ;OnNPCDMContextReady
        .function OnNPCInteractionResponse
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param response String
            .param success Int
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 Bool
            .local storyType String
            .local ::temp1 String
            .local npc1Name String
            .local npc2Name String
            .local narration String
            .local npc1 actor
            .local ::temp2 actor
            .local npc2 actor
            .local ::temp3 String
            .local dashboardText String
            .local logDetail String
            .local fact1 String
            .local fact2 String
            .local gossipContent String
            .local player actor
            .local playerCell cell
            .local ::temp4 cell
            .local npc1Visible Bool
            .local npc2Visible Bool
            .local ieTraveller actor
            .local summary String
          .endLocalTable
          .code
            ; line 839
            assign ::NPCTickPending_var False 
            ; line 840
            callstatic intelEngine ClearSystemPending ::nonevar "npcInteraction" ;1 variable args
            ; line 842
            cmp_eq ::temp0 success 1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 843
            callstatic debug Trace ::nonevar "[IntelEngine] StoryEngine: NPC DM LLM response failed" 0 ;2 variable args
            ; line 844
            return None 
            jmp _label0
            ; line 847
          _label0:
            callmethod ParseShouldAct self ::temp0 response ;1 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label1
            ; line 848
            callmethod DebugMsg ::Core_var ::nonevar "NPC DM: rejected (no compelling interaction)" ;1 variable args
            ; line 849
            return None 
            jmp _label1
            ; line 852
          _label1:
            callmethod ExtractJsonField self ::temp1 response "type" ;2 variable args
            assign storyType ::temp1 
            ; line 853
            callmethod ExtractJsonField self ::temp1 response "npc" ;2 variable args
            assign npc1Name ::temp1 
            ; line 854
            callmethod ExtractJsonField self ::temp1 response "npc2" ;2 variable args
            assign npc2Name ::temp1 
            ; line 855
            callmethod ExtractJsonField self ::temp1 response "narration" ;2 variable args
            assign narration ::temp1 
            ; line 857
            cmp_eq ::temp0 storyType "" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label2
            cmp_eq ::temp0 npc1Name "" 
            assign ::temp0 ::temp0 
          _label2:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label3
            cmp_eq ::temp0 npc2Name "" 
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 858
            return None 
            jmp _label4
            ; line 862
          _label4:
            cmp_eq ::temp0 storyType "npc_interaction" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label5
            not ::temp0 ::TypeNPCInteractionEnabled_var 
            assign ::temp0 ::temp0 
          _label5:
            jmpf ::temp0 _label6
            ; line 863
            callmethod DebugMsg ::Core_var ::nonevar "NPC DM: npc_interaction disabled via MCM toggle" ;1 variable args
            ; line 864
            return None 
            jmp _label6
            ; line 866
          _label6:
            cmp_eq ::temp0 storyType "npc_gossip" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label7
            not ::temp0 ::TypeNPCGossipEnabled_var 
            assign ::temp0 ::temp0 
          _label7:
            jmpf ::temp0 _label8
            ; line 867
            callmethod DebugMsg ::Core_var ::nonevar "NPC DM: npc_gossip disabled via MCM toggle" ;1 variable args
            ; line 868
            return None 
            jmp _label8
            ; line 871
          _label8:
            callstatic intelEngine NotifyStoryTypePicked ::nonevar storyType ;1 variable args
            ; line 873
            callstatic intelEngine ResolveStoryCandidate ::temp2 npc1Name ;1 variable args
            assign npc1 ::temp2 
            ; line 874
            callstatic intelEngine ResolveStoryCandidate ::temp2 npc2Name ;1 variable args
            assign npc2 ::temp2 
            ; line 875
            cast ::temp2 None 
            cmp_eq ::temp0 npc1 ::temp2 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label9
            callmethod IsDead npc1 ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label9:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label10
            callmethod IsDisabled npc1 ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label10:
            jmpf ::temp0 _label11
            ; line 876
            return None 
            jmp _label11
            ; line 878
          _label11:
            cast ::temp2 None 
            cmp_eq ::temp0 npc2 ::temp2 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label12
            callmethod IsDead npc2 ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label12:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label13
            callmethod IsDisabled npc2 ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label13:
            jmpf ::temp0 _label14
            ; line 879
            return None 
            jmp _label14
            ; line 883
          _label14:
            callmethod CheckNPCSocialCooldown self ::temp0 npc1 ;1 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label15
            callmethod CheckNPCSocialCooldown self ::temp0 npc2 ;1 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label15:
            jmpf ::temp0 _label16
            ; line 884
            callmethod GetDisplayName npc1 ::temp1 ;0 variable args
            strcat ::temp1 "NPC DM: " ::temp1 
            strcat ::temp1 ::temp1 " or " 
            callmethod GetDisplayName npc2 ::temp3 ;0 variable args
            strcat ::temp3 ::temp1 ::temp3 
            strcat ::temp3 ::temp3 " on social cooldown" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 885
            return None 
            jmp _label16
            ; line 888
          _label16:
            callmethod SetNPCSocialCooldown self ::nonevar npc1 ;1 variable args
            ; line 889
            callmethod SetNPCSocialCooldown self ::nonevar npc2 ;1 variable args
            ; line 891
            callmethod SendPersistentMemory ::Core_var ::nonevar npc1 npc2 narration ;3 variable args
            ; line 892
            strcat ::temp3 "NPC DM [" storyType 
            strcat ::temp3 ::temp3 "]: " 
            callmethod GetDisplayName npc1 ::temp1 ;0 variable args
            strcat ::temp1 ::temp3 ::temp1 
            strcat ::temp1 ::temp1 " + " 
            callmethod GetDisplayName npc2 ::temp3 ;0 variable args
            strcat ::temp3 ::temp1 ::temp3 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 895
            assign dashboardText narration 
            ; line 896
            assign logDetail "" 
            ; line 897
            cmp_eq ::temp0 storyType "npc_interaction" 
            jmpf ::temp0 _label17
            ; line 898
            callmethod ExtractJsonField self ::temp3 response "fact1" ;2 variable args
            assign fact1 ::temp3 
            ; line 899
            callmethod ExtractJsonField self ::temp3 response "fact2" ;2 variable args
            assign fact2 ::temp3 
            ; line 900
            cmp_eq ::temp0 fact1 "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label18
            ; line 901
            callmethod InjectFact ::Core_var ::nonevar npc1 fact1 ;2 variable args
            jmp _label18
            ; line 903
          _label18:
            cmp_eq ::temp0 fact2 "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label19
            ; line 904
            callmethod InjectFact ::Core_var ::nonevar npc2 fact2 ;2 variable args
            jmp _label19
            ; line 906
          _label19:
            cmp_eq ::temp0 fact1 "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label20
            ; line 907
            callmethod GetDisplayName npc1 ::temp3 ;0 variable args
            strcat ::temp3 ::temp3 ": " 
            strcat ::temp3 ::temp3 fact1 
            assign logDetail ::temp3 
            jmp _label20
            ; line 909
          _label20:
            cmp_eq ::temp0 fact2 "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label21
            ; line 910
            cmp_eq ::temp0 logDetail "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label22
            ; line 911
            strcat ::temp3 logDetail " | " 
            assign logDetail ::temp3 
            jmp _label22
            ; line 913
          _label22:
            callmethod GetDisplayName npc2 ::temp3 ;0 variable args
            strcat ::temp3 ::temp3 ": " 
            strcat ::temp3 ::temp3 fact2 
            strcat ::temp3 logDetail ::temp3 
            assign logDetail ::temp3 
            jmp _label21
          _label21:
            jmp _label23
            ; line 915
          _label17:
            cmp_eq ::temp0 storyType "npc_gossip" 
            jmpf ::temp0 _label23
            ; line 916
            callmethod ExtractJsonField self ::temp3 response "gossip" ;2 variable args
            assign gossipContent ::temp3 
            ; line 917
            cmp_eq ::temp0 gossipContent "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label24
            ; line 918
            callmethod InjectGossip ::Core_var ::nonevar npc1 npc2 gossipContent ;3 variable args
            ; line 919
            strcat ::temp3 "Gossip: " gossipContent 
            assign logDetail ::temp3 
            ; line 920
            assign dashboardText gossipContent 
            jmp _label24
            ; line 922
          _label24:
            callmethod SpreadGossipOffScreen self ::nonevar npc1 npc2 gossipContent ;3 variable args
            jmp _label23
            ; line 924
          _label23:
            callmethod GetDisplayName npc1 ::temp3 ;0 variable args
            callmethod GetDisplayName npc2 ::temp1 ;0 variable args
            callmethod AddNPCSocialLog self ::nonevar storyType ::temp3 ::temp1 dashboardText npc1 logDetail ;6 variable args
            ; line 927
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign player ::temp2 
            ; line 928
            callmethod GetParentCell player ::temp4 ;0 variable args
            assign playerCell ::temp4 
            ; line 929
            cast ::temp4 None 
            cmp_eq ::temp0 playerCell ::temp4 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label25
            callmethod GetParentCell npc1 ::temp4 ;0 variable args
            cmp_eq ::temp0 ::temp4 playerCell 
            assign ::temp0 ::temp0 
          _label25:
            assign npc1Visible ::temp0 
            ; line 930
            cast ::temp4 None 
            cmp_eq ::temp0 playerCell ::temp4 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label26
            callmethod GetParentCell npc2 ::temp4 ;0 variable args
            cmp_eq ::temp0 ::temp4 playerCell 
            assign ::temp0 ::temp0 
          _label26:
            assign npc2Visible ::temp0 
            ; line 933
            assign ieTraveller npc2 
            ; line 934
            jmpf npc2Visible _label27
            ; line 935
            assign ieTraveller npc1 
            jmp _label27
            ; line 938
          _label27:
            assign ::temp0 npc1Visible 
            jmpf ::temp0 _label28
            assign ::temp0 npc2Visible 
          _label28:
            jmpf ::temp0 _label29
            ; line 940
            callmethod PerformVisibleInteraction self ::nonevar npc1 npc2 narration storyType ;4 variable args
            jmp _label30
            ; line 941
          _label29:
            assign ::temp0 npc1Visible 
            jmpt ::temp0 _label31
            assign ::temp0 npc2Visible 
          _label31:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label32
            not ::temp0 ::IsNPCStoryActive_var 
            assign ::temp0 ::temp0 
          _label32:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label33
            callmethod IsPlayerTeammate npc1 ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label33:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label34
            callmethod IsPlayerTeammate npc2 ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label34:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label35
            callmethod IEB_StoryBlocked self ::temp0 ieTraveller 1 ;2 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label35:
            jmpf ::temp0 _label36
            ; line 943
            jmpf npc2Visible _label37
            ; line 944
            callmethod DispatchNPCSocial self ::nonevar npc1 npc2 narration storyType ;4 variable args
            jmp _label38
            ; line 946
          _label37:
            callmethod DispatchNPCSocial self ::nonevar npc2 npc1 narration storyType ;4 variable args
          _label38:
            jmp _label30
            ; line 950
          _label36:
            callmethod BuildInteractionSummary self ::temp1 npc1 narration npc2 ;3 variable args
            assign summary ::temp1 
            ; line 951
            strcat ::temp1 storyType ": " 
            strcat ::temp1 ::temp1 summary 
            callmethod AddRecentStoryEvent self ::nonevar ::temp1 ;1 variable args
            ; line 952
            strcat ::temp1 "Story: " summary 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
          _label30
          .endCode
        .endFunction ;OnNPCInteractionResponse
        .function DispatchNPCSocial
           ; function type 0
          .userFlags 0 ;none
          .docString "Lightweight dispatch for NPC-to-NPC travel. Uses slots but does NOT touch IsActive/ActiveStoryNPC."
          .return None
          .paramTable
            .param npc actor
            .param target actor
            .param narration String
            .param storyType String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 String
            .local ::temp2 String
            .local slot Int
            .local ::temp3 Int
            .local summary String
            .local ::temp4 objectReference
            .local ::temp5 objectReference
            .local ::temp6 keyword
            .local ::temp7 package
            .local ::temp8 Float
          .endLocalTable
          .code
            ; line 962
            callmethod IEB_DispatchBlocked self ::temp0 npc ;1 variable args
            jmpf ::temp0 _label0
            ; line 963
            strcat ::temp1 storyType ": " 
            callmethod BuildInteractionSummary self ::temp2 npc narration target ;3 variable args
            strcat ::temp2 ::temp1 ::temp2 
            callmethod AddRecentStoryEvent self ::nonevar ::temp2 ;1 variable args
            ; line 964
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 "NPC Social: " ::temp2 
            strcat ::temp2 ::temp2 " is busy or with the player - off-screen only" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 965
            return None 
            jmp _label0
            ; line 967
          _label0:
            callmethod FindFreeAgentSlot ::Core_var ::temp3 ;0 variable args
            assign slot ::temp3 
            ; line 968
            cmp_lt ::temp0 slot 0 
            jmpf ::temp0 _label1
            ; line 970
            callmethod BuildInteractionSummary self ::temp2 npc narration target ;3 variable args
            assign summary ::temp2 
            ; line 971
            strcat ::temp2 storyType ": " 
            strcat ::temp2 ::temp2 summary 
            callmethod AddRecentStoryEvent self ::nonevar ::temp2 ;1 variable args
            ; line 972
            strcat ::temp2 "NPC Social: no free slot, off-screen: " summary 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 973
            return None 
            jmp _label1
            ; line 976
          _label1:
            callmethod GetDisplayName target ::temp2 ;0 variable args
            callmethod AllocateSlot ::Core_var ::nonevar slot npc "npc_social" ::temp2 1 ;5 variable args
            ; line 978
            assign ::NPCSocialTraveler_var npc 
            ; line 979
            assign ::NPCSocialTarget_var target 
            ; line 980
            assign ::NPCSocialNarration_var narration 
            ; line 981
            assign ::NPCSocialType_var storyType 
            ; line 982
            assign ::IsNPCStoryActive_var True 
            ; line 985
            callmethod RemoveAllPackages ::Core_var ::nonevar npc False ;2 variable args
            ; line 986
            cast ::temp4 npc 
            cast ::temp5 target 
            propget IntelEngine_TravelTarget ::Core_var ::temp6 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp4 ::temp5 ::temp6 ;3 variable args
            ; line 987
            propget TravelPackage_Jog ::Core_var ::temp7 
            propget PRIORITY_TRAVEL ::Core_var ::temp3 
            callstatic actorUtil AddPackageOverride ::nonevar npc ::temp7 ::temp3 1 ;4 variable args
            ; line 988
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 989
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 991
            callmethod InitializeStuckTrackingForSlot ::Core_var ::nonevar slot npc ;2 variable args
            ; line 992
            cast ::temp5 target 
            callmethod InitOffScreenTracking ::Core_var ::nonevar slot npc ::temp5 ;3 variable args
            ; line 994
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 "NPC Social: dispatching " ::temp2 
            strcat ::temp2 ::temp2 " to " 
            callmethod GetDisplayName target ::temp1 ;0 variable args
            strcat ::temp1 ::temp2 ::temp1 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 997
            propget MONITOR_INTERVAL self ::temp8 
            callmethod RegisterForSingleUpdate self ::nonevar ::temp8 ;1 variable args
          .endCode
        .endFunction ;DispatchNPCSocial
        .function CheckNPCSocialArrival
           ; function type 0
          .userFlags 0 ;none
          .docString "Monitor NPC Social dispatch arrival. Independent of player-centric story state."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local dist Float
            .local ::temp2 objectReference
            .local ::temp3 Float
            .local slot Int
            .local ::temp4 Int
            .local stuckStatus Int
            .local taskStart Float
            .local ::temp5 form
            .local ::temp6 Float
            .local ::temp7 String
          .endLocalTable
          .code
            ; line 1002
            cast ::temp0 None 
            cmp_eq ::temp1 ::NPCSocialTraveler_var ::temp0 
            jmpf ::temp1 _label0
            ; line 1003
            callmethod CleanupNPCSocialDispatch self ::nonevar ;0 variable args
            ; line 1004
            return None 
            jmp _label0
            ; line 1007
          _label0:
            callmethod IsDead ::NPCSocialTraveler_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            callmethod IsDisabled ::NPCSocialTraveler_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 1008
            callmethod CleanupNPCSocialDispatch self ::nonevar ;0 variable args
            ; line 1009
            return None 
            jmp _label2
            ; line 1011
          _label2:
            cast ::temp0 None 
            cmp_eq ::temp1 ::NPCSocialTarget_var ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label3
            callmethod IsDead ::NPCSocialTarget_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label3:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label4
            callmethod IsDisabled ::NPCSocialTarget_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label4:
            jmpf ::temp1 _label5
            ; line 1012
            callmethod CleanupNPCSocialDispatch self ::nonevar ;0 variable args
            ; line 1013
            return None 
            jmp _label5
            ; line 1016
          _label5:
            cast ::temp2 ::NPCSocialTarget_var 
            callmethod GetDistance ::NPCSocialTraveler_var ::temp3 ::temp2 ;1 variable args
            assign dist ::temp3 
            ; line 1019
            propget ARRIVAL_DISTANCE ::Core_var ::temp3 
            cmp_lte ::temp1 dist ::temp3 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label6
            cmp_gt ::temp1 dist 0.0 
            assign ::temp1 ::temp1 
          _label6:
            jmpf ::temp1 _label7
            ; line 1020
            callmethod OnNPCSocialArrived self ::nonevar ;0 variable args
            ; line 1021
            return None 
            jmp _label7
            ; line 1024
          _label7:
            callmethod FindSlotByAgent ::Core_var ::temp4 ::NPCSocialTraveler_var ;1 variable args
            assign slot ::temp4 
            ; line 1025
            cmp_lt ::temp1 slot 0 
            jmpf ::temp1 _label8
            ; line 1026
            callmethod CleanupNPCSocialDispatch self ::nonevar ;0 variable args
            ; line 1027
            return None 
            jmp _label8
            ; line 1031
          _label8:
            callmethod Is3DLoaded ::NPCSocialTraveler_var ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label9
            ; line 1032
            cast ::temp2 ::NPCSocialTarget_var 
            callmethod HandleOffScreenTravel ::Core_var ::temp1 slot ::NPCSocialTraveler_var ::temp2 ;3 variable args
            jmpf ::temp1 _label10
            ; line 1033
            propget TELEPORT_OFFSET_EXTERIOR self ::temp3 
            callmethod TeleportNPCSocialAndResume self ::nonevar ::temp3 ;1 variable args
            jmp _label10
            ; line 1035
          _label10:
            return None 
            jmp _label9
            ; line 1039
          _label9:
            propget STUCK_DISTANCE_THRESHOLD ::Core_var ::temp3 
            callstatic intelEngine CheckStuckStatus ::temp4 ::NPCSocialTraveler_var slot ::temp3 ;3 variable args
            assign stuckStatus ::temp4 
            ; line 1040
            cmp_eq ::temp1 stuckStatus 1 
            jmpf ::temp1 _label11
            ; line 1041
            cast ::temp2 ::NPCSocialTarget_var 
            callmethod SoftStuckRecovery ::Core_var ::nonevar ::NPCSocialTraveler_var slot ::temp2 ;3 variable args
            jmp _label12
            ; line 1042
          _label11:
            comp_gte ::temp1 stuckStatus 3 
            jmpf ::temp1 _label12
            ; line 1043
            propget TELEPORT_OFFSET_EXTERIOR self ::temp3 
            callmethod TeleportNPCSocialAndResume self ::nonevar ::temp3 ;1 variable args
            jmp _label12
            ; line 1047
          _label12:
            cast ::temp5 ::NPCSocialTraveler_var 
            callstatic storageUtil GetFloatValue ::temp3 ::temp5 "Intel_TaskStartTime" 0.0 ;3 variable args
            assign taskStart ::temp3 
            ; line 1048
            cmp_gt ::temp1 taskStart 0.0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label13
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            fsub ::temp3 ::temp3 taskStart 
            fdiv ::temp6 4.0 24.0 
            cmp_gt ::temp1 ::temp3 ::temp6 
            assign ::temp1 ::temp1 
          _label13:
            jmpf ::temp1 _label14
            ; line 1049
            callmethod GetDisplayName ::NPCSocialTraveler_var ::temp7 ;0 variable args
            strcat ::temp7 "NPC Social: timeout for " ::temp7 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            ; line 1050
            callmethod TeleportNPCSocialAndResume self ::nonevar 200.0 ;1 variable args
            ; line 1051
            callmethod OnNPCSocialArrived self ::nonevar ;0 variable args
            jmp _label14
          _label14
          .endCode
        .endFunction ;CheckNPCSocialArrival
        .function TeleportNPCSocialAndResume
           ; function type 0
          .userFlags 0 ;none
          .docString "Teleport NPC Social traveler near target and reapply travel package."
          .return None
          .paramTable
            .param distance Float
          .endParamTable
          .localTable
            .local offset Float[]
            .local ::temp0 objectReference
            .local ::temp1 Float[]
            .local ::nonevar None
            .local ::temp2 Float
            .local ::temp3 Float
            .local ::temp4 objectReference
            .local ::temp5 keyword
            .local ::temp6 package
            .local ::temp7 Int
          .endLocalTable
          .code
            ; line 1057
            cast ::temp0 ::NPCSocialTarget_var 
            callstatic intelEngine GetOffsetBehind ::temp1 ::temp0 distance ;2 variable args
            assign offset ::temp1 
            ; line 1058
            cast ::temp0 ::NPCSocialTarget_var 
            array_getlement ::temp2 offset 0 
            array_getlement ::temp3 offset 1 
            callmethod MoveTo ::NPCSocialTraveler_var ::nonevar ::temp0 ::temp2 ::temp3 0.0 False ;5 variable args
            ; line 1059
            callmethod RemoveAllPackages ::Core_var ::nonevar ::NPCSocialTraveler_var False ;2 variable args
            ; line 1060
            cast ::temp0 ::NPCSocialTraveler_var 
            cast ::temp4 ::NPCSocialTarget_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp5 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp0 ::temp4 ::temp5 ;3 variable args
            ; line 1061
            propget TravelPackage_Jog ::Core_var ::temp6 
            propget PRIORITY_TRAVEL ::Core_var ::temp7 
            callstatic actorUtil AddPackageOverride ::nonevar ::NPCSocialTraveler_var ::temp6 ::temp7 1 ;4 variable args
            ; line 1062
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 1063
            callmethod EvaluatePackage ::NPCSocialTraveler_var ::nonevar ;0 variable args
          .endCode
        .endFunction ;TeleportNPCSocialAndResume
        .function OnNPCSocialArrived
           ; function type 0
          .userFlags 0 ;none
          .docString "NPC Social traveler arrived at target. Perform visible interaction and clean up."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local ::temp1 String
          .endLocalTable
          .code
            ; line 1068
            callmethod GetDisplayName ::NPCSocialTraveler_var ::temp0 ;0 variable args
            strcat ::temp0 "NPC Social: " ::temp0 
            strcat ::temp0 ::temp0 " arrived at " 
            callmethod GetDisplayName ::NPCSocialTarget_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp0 ::temp1 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 1069
            callmethod PerformVisibleInteraction self ::nonevar ::NPCSocialTraveler_var ::NPCSocialTarget_var ::NPCSocialNarration_var ::NPCSocialType_var ;4 variable args
            ; line 1070
            callmethod CleanupNPCSocialDispatch self ::nonevar ;0 variable args
          .endCode
        .endFunction ;OnNPCSocialArrived
        .function CleanupNPCSocialDispatch
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local slot Int
            .local ::temp2 Int
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1074
            cast ::temp0 None 
            cmp_eq ::temp1 ::NPCSocialTraveler_var ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label0
            ; line 1075
            callmethod FindSlotByAgent ::Core_var ::temp2 ::NPCSocialTraveler_var ;1 variable args
            assign slot ::temp2 
            ; line 1076
            comp_gte ::temp1 slot 0 
            jmpf ::temp1 _label1
            ; line 1077
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label2
            ; line 1079
          _label1:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::NPCSocialTraveler_var False ;2 variable args
          _label2:
            jmp _label0
            ; line 1082
          _label0:
            cast ::temp0 None 
            assign ::NPCSocialTraveler_var ::temp0 
            ; line 1083
            cast ::temp0 None 
            assign ::NPCSocialTarget_var ::temp0 
            ; line 1084
            assign ::NPCSocialNarration_var "" 
            ; line 1085
            assign ::NPCSocialType_var "" 
            ; line 1086
            assign ::IsNPCStoryActive_var False 
          .endCode
        .endFunction ;CleanupNPCSocialDispatch
        .function ApplyCooldownCheck
           ; function type 0
          .userFlags 0 ;none
          .docString "Check STORY cooldown + scheduled state. Sets Intel_StoryLastPicked on success. Returns true if passed."
          .return Bool
          .paramTable
            .param candidate actor
          .endParamTable
          .localTable
            .local ::temp0 form
            .local ::temp1 Int
            .local ::temp2 Bool
            .local lastPicked Float
            .local ::temp3 Float
            .local currentTime Float
            .local cooldownDays Float
            .local ::nonevar None
            .local ::temp4 form
          .endLocalTable
          .code
            ; line 1091
            cast ::temp0 candidate 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "Intel_ScheduledState" -1 ;3 variable args
            comp_gte ::temp2 ::temp1 0 
            jmpf ::temp2 _label0
            ; line 1092
            return False 
            jmp _label0
            ; line 1095
          _label0:
            cast ::temp0 candidate 
            callstatic storageUtil GetFloatValue ::temp3 ::temp0 "Intel_StoryLastPicked" 0.0 ;3 variable args
            assign lastPicked ::temp3 
            ; line 1096
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            assign currentTime ::temp3 
            ; line 1097
            callmethod GetStoryEngineCooldown ::Core_var ::temp3 ;0 variable args
            fdiv ::temp3 ::temp3 24.0 
            assign cooldownDays ::temp3 
            ; line 1098
            cmp_gt ::temp2 lastPicked 0.0 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label1
            fsub ::temp3 currentTime lastPicked 
            cmp_lt ::temp2 ::temp3 cooldownDays 
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 1099
            callstatic intelEngine NotifyStoryCooldown ::nonevar candidate lastPicked ;2 variable args
            ; line 1101
            cast ::temp0 self 
            cast ::temp4 candidate 
            callstatic storageUtil FormListAdd ::temp1 ::temp0 "Intel_CooldownActors" ::temp4 False ;4 variable args
            ; line 1102
            return False 
            jmp _label2
            ; line 1105
          _label2:
            cast ::temp4 candidate 
            callstatic storageUtil SetFloatValue ::temp3 ::temp4 "Intel_StoryLastPicked" currentTime ;3 variable args
            ; line 1106
            callstatic intelEngine NotifyStoryCooldown ::nonevar candidate currentTime ;2 variable args
            ; line 1108
            cast ::temp4 self 
            cast ::temp0 candidate 
            callstatic storageUtil FormListAdd ::temp1 ::temp4 "Intel_CooldownActors" ::temp0 False ;4 variable args
            ; line 1109
            return True 
          .endCode
        .endFunction ;ApplyCooldownCheck
        .function CheckNPCSocialCooldown
           ; function type 0
          .userFlags 0 ;none
          .docString "Check if NPC is off social cooldown. Does NOT write timestamp — use SetNPCSocialCooldown after both pass."
          .return Bool
          .paramTable
            .param candidate actor
          .endParamTable
          .localTable
            .local lastPicked Float
            .local ::temp0 form
            .local ::temp1 Float
            .local ::temp2 Bool
            .local cooldownDays Float
          .endLocalTable
          .code
            ; line 1114
            cast ::temp0 candidate 
            callstatic storageUtil GetFloatValue ::temp1 ::temp0 "Intel_NPCSocialLastPicked" 0.0 ;3 variable args
            assign lastPicked ::temp1 
            ; line 1115
            cmp_lte ::temp2 lastPicked 0.0 
            jmpf ::temp2 _label0
            ; line 1116
            return True 
            jmp _label0
            ; line 1118
          _label0:
            fdiv ::temp1 ::NPCSocialCooldownHours_var 24.0 
            assign cooldownDays ::temp1 
            ; line 1119
            callstatic utility GetCurrentGameTime ::temp1 ;0 variable args
            fsub ::temp1 ::temp1 lastPicked 
            comp_gte ::temp2 ::temp1 cooldownDays 
            return ::temp2 
          .endCode
        .endFunction ;CheckNPCSocialCooldown
        .function SetNPCSocialCooldown
           ; function type 0
          .userFlags 0 ;none
          .docString "Stamp the NPC's social cooldown. Call only after both NPCs pass CheckNPCSocialCooldown."
          .return None
          .paramTable
            .param candidate actor
          .endParamTable
          .localTable
            .local now Float
            .local ::temp0 Float
            .local ::temp1 form
            .local ::temp2 form
            .local ::temp3 Bool
            .local ::temp4 Int
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1124
            callstatic utility GetCurrentGameTime ::temp0 ;0 variable args
            assign now ::temp0 
            ; line 1125
            cast ::temp1 candidate 
            callstatic storageUtil SetFloatValue ::temp0 ::temp1 "Intel_NPCSocialLastPicked" now ;3 variable args
            ; line 1126
            cast ::temp1 self 
            cast ::temp2 candidate 
            callstatic storageUtil FormListHas ::temp3 ::temp1 "Intel_SocialCooldownActors" ::temp2 ;3 variable args
            not ::temp3 ::temp3 
            jmpf ::temp3 _label0
            ; line 1127
            cast ::temp2 self 
            cast ::temp1 candidate 
            callstatic storageUtil FormListAdd ::temp4 ::temp2 "Intel_SocialCooldownActors" ::temp1 True ;4 variable args
            jmp _label0
            ; line 1129
          _label0:
            callstatic intelEngine NotifySocialCooldown ::nonevar candidate now ::NPCSocialCooldownHours_var ;3 variable args
          .endCode
        .endFunction ;SetNPCSocialCooldown
        .function WarmCooldownMirror
           ; function type 0
          .userFlags 0 ;none
          .docString "Populate C++ cooldown mirror from StorageUtil on game load. Prevents wasted LLM turns."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local currentTime Float
            .local ::temp0 Float
            .local cooldownDays Float
            .local count Int
            .local ::temp1 form
            .local ::temp2 Int
            .local warmed Int
            .local i Int
            .local ::temp3 Bool
            .local npc actor
            .local ::temp4 actor
            .local lastPicked Float
            .local ::nonevar None
            .local ::temp5 String
            .local socialCooldownDays Float
            .local socialCount Int
            .local socialWarmed Int
            .local si Int
            .local socialNpc actor
            .local socialLastPicked Float
          .endLocalTable
          .code
            ; line 1134
            callstatic utility GetCurrentGameTime ::temp0 ;0 variable args
            assign currentTime ::temp0 
            ; line 1135
            callmethod GetStoryEngineCooldown ::Core_var ::temp0 ;0 variable args
            fdiv ::temp0 ::temp0 24.0 
            assign cooldownDays ::temp0 
            ; line 1137
            cast ::temp1 self 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "Intel_CooldownActors" ;2 variable args
            assign count ::temp2 
            ; line 1138
            assign warmed 0 
            ; line 1139
            isub ::temp2 count 1 
            assign i ::temp2 
            ; line 1140
          _label6:
            comp_gte ::temp3 i 0 
            jmpf ::temp3 _label0
            ; line 1141
            cast ::temp1 self 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "Intel_CooldownActors" i ;3 variable args
            cast ::temp4 ::temp1 
            assign npc ::temp4 
            ; line 1142
            cast ::temp4 None 
            cmp_eq ::temp3 npc ::temp4 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label1
            ; line 1143
            cast ::temp1 npc 
            callstatic storageUtil GetFloatValue ::temp0 ::temp1 "Intel_StoryLastPicked" 0.0 ;3 variable args
            assign lastPicked ::temp0 
            ; line 1144
            cmp_gt ::temp3 lastPicked 0.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label2
            fsub ::temp0 currentTime lastPicked 
            cmp_lt ::temp3 ::temp0 cooldownDays 
            assign ::temp3 ::temp3 
          _label2:
            jmpf ::temp3 _label3
            ; line 1145
            callstatic intelEngine NotifyStoryCooldown ::nonevar npc lastPicked ;2 variable args
            ; line 1146
            iadd ::temp2 warmed 1 
            assign warmed ::temp2 
            jmp _label4
            ; line 1148
          _label3:
            cast ::temp1 self 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_CooldownActors" i ;3 variable args
          _label4:
            jmp _label5
            ; line 1151
          _label1:
            cast ::temp1 self 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_CooldownActors" i ;3 variable args
            ; line 1153
          _label5:
            isub ::temp2 i 1 
            assign i ::temp2 
            jmp _label6
            ; line 1155
          _label0:
            cmp_gt ::temp3 warmed 0 
            jmpf ::temp3 _label7
            ; line 1156
            cast ::temp5 warmed 
            strcat ::temp5 "Story: warmed C++ cooldown mirror (" ::temp5 
            strcat ::temp5 ::temp5 " NPCs)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            jmp _label7
            ; line 1160
          _label7:
            fdiv ::temp0 ::NPCSocialCooldownHours_var 24.0 
            assign socialCooldownDays ::temp0 
            ; line 1161
            cast ::temp1 self 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "Intel_SocialCooldownActors" ;2 variable args
            assign socialCount ::temp2 
            ; line 1162
            assign socialWarmed 0 
            ; line 1163
            isub ::temp2 socialCount 1 
            assign si ::temp2 
            ; line 1164
          _label14:
            comp_gte ::temp3 si 0 
            jmpf ::temp3 _label8
            ; line 1165
            cast ::temp1 self 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "Intel_SocialCooldownActors" si ;3 variable args
            cast ::temp4 ::temp1 
            assign socialNpc ::temp4 
            ; line 1166
            cast ::temp4 None 
            cmp_eq ::temp3 socialNpc ::temp4 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label9
            ; line 1167
            cast ::temp1 socialNpc 
            callstatic storageUtil GetFloatValue ::temp0 ::temp1 "Intel_NPCSocialLastPicked" 0.0 ;3 variable args
            assign socialLastPicked ::temp0 
            ; line 1168
            cmp_gt ::temp3 socialLastPicked 0.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label10
            fsub ::temp0 currentTime socialLastPicked 
            cmp_lt ::temp3 ::temp0 socialCooldownDays 
            assign ::temp3 ::temp3 
          _label10:
            jmpf ::temp3 _label11
            ; line 1169
            callstatic intelEngine NotifySocialCooldown ::nonevar socialNpc socialLastPicked ::NPCSocialCooldownHours_var ;3 variable args
            ; line 1170
            iadd ::temp2 socialWarmed 1 
            assign socialWarmed ::temp2 
            jmp _label12
            ; line 1172
          _label11:
            cast ::temp1 self 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_SocialCooldownActors" si ;3 variable args
          _label12:
            jmp _label13
            ; line 1175
          _label9:
            cast ::temp1 self 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_SocialCooldownActors" si ;3 variable args
            ; line 1177
          _label13:
            isub ::temp2 si 1 
            assign si ::temp2 
            jmp _label14
            ; line 1179
          _label8:
            cmp_gt ::temp3 socialWarmed 0 
            jmpf ::temp3 _label15
            ; line 1180
            cast ::temp5 socialWarmed 
            strcat ::temp5 "Story: warmed C++ social cooldown mirror (" ::temp5 
            strcat ::temp5 ::temp5 " NPCs)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            jmp _label15
          _label15
          .endCode
        .endFunction ;WarmCooldownMirror
        .function ClearStaleRealTimeTimers
           ; function type 0
          .userFlags 0 ;none
          .docString "Reset real-time timer stamps whose saved values exceed current real time.
     Utility.GetCurrentRealTime() resets each Skyrim launch, but StorageUtil
     floats and save-persistent properties don't — so a saved value from a
     prior session is always larger than `now` and makes `now - saved` negative,
     which means `elapsed > TIMEOUT_SECONDS` watchdogs never fire and NPCs get
     stuck in linger/greet/sneak/combat states. Snap stale stamps forward to
     `now` so the countdown restarts from load."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local now Float
            .local ::temp0 Float
            .local player actor
            .local ::temp1 actor
            .local ::temp2 Bool
            .local lingerCount Int
            .local ::temp3 form
            .local ::temp4 Int
            .local i Int
            .local npc actor
            .local t Float
            .local encCount Int
            .local formId Int
            .local ::mangled_npc_0 actor
            .local ::mangled_t_0 Float
            .local sneakStart Float
            .local combatStart Float
          .endLocalTable
          .code
            ; line 1192
            callstatic utility GetCurrentRealTime ::temp0 ;0 variable args
            assign now ::temp0 
            ; line 1193
            callstatic game GetPlayer ::temp1 ;0 variable args
            assign player ::temp1 
            ; line 1195
            cmp_gt ::temp2 ::FactionAmbushStartTime_var now 
            jmpf ::temp2 _label0
            ; line 1196
            assign ::FactionAmbushStartTime_var now 
            jmp _label0
            ; line 1200
          _label0:
            cast ::temp3 player 
            callstatic storageUtil FormListCount ::temp4 ::temp3 "Intel_StoryLingerActors" ;2 variable args
            assign lingerCount ::temp4 
            ; line 1201
            isub ::temp4 lingerCount 1 
            assign i ::temp4 
            ; line 1202
          _label4:
            comp_gte ::temp2 i 0 
            jmpf ::temp2 _label1
            ; line 1203
            cast ::temp3 player 
            callstatic storageUtil FormListGet ::temp3 ::temp3 "Intel_StoryLingerActors" i ;3 variable args
            cast ::temp1 ::temp3 
            assign npc ::temp1 
            ; line 1204
            cast ::temp1 None 
            cmp_eq ::temp2 npc ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label2
            ; line 1205
            cast ::temp3 npc 
            callstatic storageUtil GetFloatValue ::temp0 ::temp3 "Intel_StoryLingerStart" 0.0 ;3 variable args
            assign t ::temp0 
            ; line 1206
            cmp_gt ::temp2 t now 
            jmpf ::temp2 _label3
            ; line 1207
            cast ::temp3 npc 
            callstatic storageUtil SetFloatValue ::temp0 ::temp3 "Intel_StoryLingerStart" now ;3 variable args
            jmp _label3
          _label3:
            jmp _label2
            ; line 1210
          _label2:
            isub ::temp4 i 1 
            assign i ::temp4 
            jmp _label4
            ; line 1214
          _label1:
            cast ::temp3 player 
            callstatic storageUtil IntListCount ::temp4 ::temp3 "Intel_FakeEncounterNPCs" ;2 variable args
            assign encCount ::temp4 
            ; line 1215
            isub ::temp4 encCount 1 
            assign i ::temp4 
            ; line 1216
          _label8:
            comp_gte ::temp2 i 0 
            jmpf ::temp2 _label5
            ; line 1217
            cast ::temp3 player 
            callstatic storageUtil IntListGet ::temp4 ::temp3 "Intel_FakeEncounterNPCs" i ;3 variable args
            assign formId ::temp4 
            ; line 1218
            callstatic game GetForm ::temp3 formId ;1 variable args
            cast ::temp1 ::temp3 
            assign ::mangled_npc_0 ::temp1 
            ; line 1219
            cast ::temp1 None 
            cmp_eq ::temp2 ::mangled_npc_0 ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label6
            ; line 1220
            cast ::temp3 ::mangled_npc_0 
            callstatic storageUtil GetFloatValue ::temp0 ::temp3 "Intel_FakeEncounterGreetTime" 0.0 ;3 variable args
            assign ::mangled_t_0 ::temp0 
            ; line 1221
            cmp_gt ::temp2 ::mangled_t_0 now 
            jmpf ::temp2 _label7
            ; line 1222
            cast ::temp3 ::mangled_npc_0 
            callstatic storageUtil SetFloatValue ::temp0 ::temp3 "Intel_FakeEncounterGreetTime" now ;3 variable args
            jmp _label7
          _label7:
            jmp _label6
            ; line 1225
          _label6:
            isub ::temp4 i 1 
            assign i ::temp4 
            jmp _label8
            ; line 1229
          _label5:
            cast ::temp1 None 
            cmp_eq ::temp2 ::ActiveStoryNPC_var ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label9
            ; line 1230
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp0 ::temp3 "Intel_SneakStartTime" 0.0 ;3 variable args
            assign sneakStart ::temp0 
            ; line 1231
            cmp_gt ::temp2 sneakStart now 
            jmpf ::temp2 _label10
            ; line 1232
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil SetFloatValue ::temp0 ::temp3 "Intel_SneakStartTime" now ;3 variable args
            jmp _label10
            ; line 1234
          _label10:
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp0 ::temp3 "Intel_CombatStartTime" 0.0 ;3 variable args
            assign combatStart ::temp0 
            ; line 1235
            cmp_gt ::temp2 combatStart now 
            jmpf ::temp2 _label11
            ; line 1236
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil SetFloatValue ::temp0 ::temp3 "Intel_CombatStartTime" now ;3 variable args
            jmp _label11
          _label11:
            jmp _label9
          _label9
          .endCode
        .endFunction ;ClearStaleRealTimeTimers
        .function WarmBioLineCounts
           ; function type 0
          .userFlags 0 ;none
          .docString "Restore per-NPC dialogue line counts from StorageUtil into C++ DialogueTracker."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local count Int
            .local ::temp0 form
            .local ::temp1 Int
            .local warmed Int
            .local i Int
            .local ::temp2 Bool
            .local npc actor
            .local ::temp3 actor
            .local lines Int
            .local ::nonevar None
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 1243
            cast ::temp0 self 
            callstatic storageUtil FormListCount ::temp1 ::temp0 "Intel_BioTrackActors" ;2 variable args
            assign count ::temp1 
            ; line 1244
            assign warmed 0 
            ; line 1245
            isub ::temp1 count 1 
            assign i ::temp1 
            ; line 1246
          _label4:
            comp_gte ::temp2 i 0 
            jmpf ::temp2 _label0
            ; line 1247
            cast ::temp0 self 
            callstatic storageUtil FormListGet ::temp0 ::temp0 "Intel_BioTrackActors" i ;3 variable args
            cast ::temp3 ::temp0 
            assign npc ::temp3 
            ; line 1248
            cast ::temp3 None 
            cmp_eq ::temp2 npc ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label1
            ; line 1249
            cast ::temp0 npc 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "Intel_BioLineCount" 0 ;3 variable args
            assign lines ::temp1 
            ; line 1250
            cmp_gt ::temp2 lines 0 
            jmpf ::temp2 _label2
            ; line 1251
            callstatic intelEngine SetAutoBioCount ::nonevar npc lines ;2 variable args
            ; line 1252
            iadd ::temp1 warmed 1 
            assign warmed ::temp1 
            jmp _label2
          _label2:
            jmp _label3
            ; line 1255
          _label1:
            cast ::temp0 self 
            callstatic storageUtil FormListRemoveAt ::temp2 ::temp0 "Intel_BioTrackActors" i ;3 variable args
            ; line 1257
          _label3:
            isub ::temp1 i 1 
            assign i ::temp1 
            jmp _label4
            ; line 1259
          _label0:
            cmp_gt ::temp2 warmed 0 
            jmpf ::temp2 _label5
            ; line 1260
            cast ::temp4 warmed 
            strcat ::temp4 "Story: warmed bio line counts (" ::temp4 
            strcat ::temp4 ::temp4 " NPCs)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            jmp _label5
          _label5
          .endCode
        .endFunction ;WarmBioLineCounts
        .function WarmCooldownsForPool
           ; function type 0
          .userFlags 0 ;none
          .docString "Check StorageUtil cooldowns for all DM candidate pool NPCs and warm C++ mirror.
    Returns true if any candidates were on cooldown (caller should rebuild context)."
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local formIDs Int[]
            .local ::temp0 Int[]
            .local ::temp1 Int
            .local ::temp2 Bool
            .local currentTime Float
            .local ::temp3 Float
            .local cooldownDays Float
            .local warmed Int
            .local i Int
            .local npc actor
            .local ::temp4 form
            .local ::temp5 actor
            .local lastPicked Float
            .local ::nonevar None
            .local ::temp6 form
            .local schedState Int
            .local ::temp7 String
          .endLocalTable
          .code
            ; line 1267
            callstatic intelEngine GetDMCandidatePoolFormIDs ::temp0 ;0 variable args
            assign formIDs ::temp0 
            ; line 1268
            array_length ::temp1 formIDs 
            cmp_eq ::temp2 ::temp1 0 
            jmpf ::temp2 _label0
            ; line 1269
            return False 
            jmp _label0
            ; line 1272
          _label0:
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            assign currentTime ::temp3 
            ; line 1273
            callmethod GetStoryEngineCooldown ::Core_var ::temp3 ;0 variable args
            fdiv ::temp3 ::temp3 24.0 
            assign cooldownDays ::temp3 
            ; line 1275
            assign warmed 0 
            ; line 1276
            assign i 0 
            ; line 1277
          _label6:
            array_length ::temp1 formIDs 
            cmp_lt ::temp2 i ::temp1 
            jmpf ::temp2 _label1
            ; line 1278
            array_getlement ::temp1 formIDs i 
            callstatic game GetForm ::temp4 ::temp1 ;1 variable args
            cast ::temp5 ::temp4 
            assign npc ::temp5 
            ; line 1279
            cast ::temp5 None 
            cmp_eq ::temp2 npc ::temp5 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label2
            ; line 1280
            cast ::temp4 npc 
            callstatic storageUtil GetFloatValue ::temp3 ::temp4 "Intel_StoryLastPicked" 0.0 ;3 variable args
            assign lastPicked ::temp3 
            ; line 1281
            cmp_gt ::temp2 lastPicked 0.0 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label3
            fsub ::temp3 currentTime lastPicked 
            cmp_lt ::temp2 ::temp3 cooldownDays 
            assign ::temp2 ::temp2 
          _label3:
            jmpf ::temp2 _label4
            ; line 1282
            callstatic intelEngine NotifyStoryCooldown ::nonevar npc lastPicked ;2 variable args
            ; line 1283
            cast ::temp4 self 
            cast ::temp6 npc 
            callstatic storageUtil FormListAdd ::temp1 ::temp4 "Intel_CooldownActors" ::temp6 False ;4 variable args
            ; line 1284
            iadd ::temp1 warmed 1 
            assign warmed ::temp1 
            jmp _label5
            ; line 1287
          _label4:
            cast ::temp6 npc 
            callstatic storageUtil GetIntValue ::temp1 ::temp6 "Intel_ScheduledState" -1 ;3 variable args
            assign schedState ::temp1 
            ; line 1288
            comp_gte ::temp2 schedState 0 
            jmpf ::temp2 _label5
            ; line 1289
            callstatic intelEngine NotifyStoryCooldown ::nonevar npc currentTime ;2 variable args
            ; line 1290
            cast ::temp6 self 
            cast ::temp4 npc 
            callstatic storageUtil FormListAdd ::temp1 ::temp6 "Intel_CooldownActors" ::temp4 False ;4 variable args
            ; line 1291
            iadd ::temp1 warmed 1 
            assign warmed ::temp1 
            jmp _label5
          _label5:
            jmp _label2
            ; line 1295
          _label2:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label6
            ; line 1297
          _label1:
            cmp_gt ::temp2 warmed 0 
            jmpf ::temp2 _label7
            ; line 1298
            cast ::temp7 warmed 
            strcat ::temp7 "Story: pre-warmed " ::temp7 
            strcat ::temp7 ::temp7 " cooldowns from pool candidates" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            jmp _label7
            ; line 1300
          _label7:
            cmp_gt ::temp2 warmed 0 
            return ::temp2 
          .endCode
        .endFunction ;WarmCooldownsForPool
        .function WarmSocialCooldownsForPool
           ; function type 0
          .userFlags 0 ;none
          .docString "Check NPC interaction pool candidates against StorageUtil social cooldowns.
     Returns true if any were on cooldown (caller should rebuild pool)."
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local formIDs Int[]
            .local ::temp0 Int[]
            .local ::temp1 Int
            .local ::temp2 Bool
            .local currentTime Float
            .local ::temp3 Float
            .local cooldownDays Float
            .local warmed Int
            .local i Int
            .local npc actor
            .local ::temp4 form
            .local ::temp5 actor
            .local lastPicked Float
            .local ::nonevar None
            .local ::temp6 form
            .local ::temp7 String
          .endLocalTable
          .code
            ; line 1306
            callstatic intelEngine GetNPCCandidatePoolFormIDs ::temp0 ;0 variable args
            assign formIDs ::temp0 
            ; line 1307
            array_length ::temp1 formIDs 
            cmp_eq ::temp2 ::temp1 0 
            jmpf ::temp2 _label0
            ; line 1308
            return False 
            jmp _label0
            ; line 1311
          _label0:
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            assign currentTime ::temp3 
            ; line 1312
            fdiv ::temp3 ::NPCSocialCooldownHours_var 24.0 
            assign cooldownDays ::temp3 
            ; line 1314
            assign warmed 0 
            ; line 1315
            assign i 0 
            ; line 1316
          _label6:
            array_length ::temp1 formIDs 
            cmp_lt ::temp2 i ::temp1 
            jmpf ::temp2 _label1
            ; line 1317
            array_getlement ::temp1 formIDs i 
            callstatic game GetForm ::temp4 ::temp1 ;1 variable args
            cast ::temp5 ::temp4 
            assign npc ::temp5 
            ; line 1318
            cast ::temp5 None 
            cmp_eq ::temp2 npc ::temp5 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label2
            ; line 1319
            cast ::temp4 npc 
            callstatic storageUtil GetFloatValue ::temp3 ::temp4 "Intel_NPCSocialLastPicked" 0.0 ;3 variable args
            assign lastPicked ::temp3 
            ; line 1320
            cmp_gt ::temp2 lastPicked 0.0 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label3
            fsub ::temp3 currentTime lastPicked 
            cmp_lt ::temp2 ::temp3 cooldownDays 
            assign ::temp2 ::temp2 
          _label3:
            jmpf ::temp2 _label4
            ; line 1321
            callstatic intelEngine NotifySocialCooldown ::nonevar npc lastPicked ::NPCSocialCooldownHours_var ;3 variable args
            ; line 1322
            cast ::temp4 self 
            cast ::temp6 npc 
            callstatic storageUtil FormListHas ::temp2 ::temp4 "Intel_SocialCooldownActors" ::temp6 ;3 variable args
            not ::temp2 ::temp2 
            jmpf ::temp2 _label5
            ; line 1323
            cast ::temp6 self 
            cast ::temp4 npc 
            callstatic storageUtil FormListAdd ::temp1 ::temp6 "Intel_SocialCooldownActors" ::temp4 True ;4 variable args
            jmp _label5
            ; line 1325
          _label5:
            iadd ::temp1 warmed 1 
            assign warmed ::temp1 
            jmp _label4
          _label4:
            jmp _label2
            ; line 1328
          _label2:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label6
            ; line 1330
          _label1:
            cmp_gt ::temp2 warmed 0 
            jmpf ::temp2 _label7
            ; line 1331
            cast ::temp7 warmed 
            strcat ::temp7 "NPC Social: pre-warmed " ::temp7 
            strcat ::temp7 ::temp7 " social cooldowns from pool" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            jmp _label7
            ; line 1333
          _label7:
            cmp_gt ::temp2 warmed 0 
            return ::temp2 
          .endCode
        .endFunction ;WarmSocialCooldownsForPool
        .function WarmStoryTypeCounts
           ; function type 0
          .userFlags 0 ;none
          .docString "Parse type prefixes from Intel_RecentStoryEvents and warm C++ type counts.
    Passes the full string list to C++ for parsing (no string ops in Papyrus)."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local count Int
            .local ::temp1 form
            .local ::temp2 Int
            .local ::temp3 Bool
            .local csv String
            .local i Int
            .local ::temp4 String
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1339
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1340
            cast ::temp1 player 
            callstatic storageUtil StringListCount ::temp2 ::temp1 "Intel_RecentStoryEvents" ;2 variable args
            assign count ::temp2 
            ; line 1341
            cmp_eq ::temp3 count 0 
            jmpf ::temp3 _label0
            ; line 1342
            return None 
            jmp _label0
            ; line 1345
          _label0:
            assign csv "" 
            ; line 1346
            assign i 0 
            ; line 1347
          _label3:
            cmp_lt ::temp3 i count 
            jmpf ::temp3 _label1
            ; line 1348
            cmp_gt ::temp3 i 0 
            jmpf ::temp3 _label2
            ; line 1349
            strcat ::temp4 csv "|" 
            assign csv ::temp4 
            jmp _label2
            ; line 1351
          _label2:
            cast ::temp1 player 
            callstatic storageUtil StringListGet ::temp4 ::temp1 "Intel_RecentStoryEvents" i ;3 variable args
            strcat ::temp4 csv ::temp4 
            assign csv ::temp4 
            ; line 1352
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label3
            ; line 1354
          _label1:
            callstatic intelEngine WarmStoryTypeCountsFromCSV ::nonevar csv ;1 variable args
            ; line 1355
            cast ::temp4 count 
            strcat ::temp4 "Story: warmed type counts from " ::temp4 
            strcat ::temp4 ::temp4 " recent events (C++)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
          .endCode
        .endFunction ;WarmStoryTypeCounts
        .function SendStoryLLMRequest
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param promptName String
            .param callbackName String
            .param contextJson String
          .endParamTable
          .localTable
            .local result Int
            .local ::temp0 quest
            .local ::temp1 Int
            .local ::temp2 Bool
            .local ::nonevar None
            .local ::temp3 String
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 1364
            cast ::temp0 self 
            callstatic skyrimNetApi SendCustomPromptToLLM ::temp1 promptName "intel_story_dm" contextJson ::temp0 "IntelEngine_StoryEngine" callbackName ;6 variable args
            assign result ::temp1 
            ; line 1365
            cmp_lt ::temp2 result 0 
            jmpf ::temp2 _label0
            ; line 1366
            strcat ::temp3 "[IntelEngine] StoryEngine: LLM call failed (" promptName 
            strcat ::temp3 ::temp3 ") code " 
            cast ::temp4 result 
            strcat ::temp4 ::temp3 ::temp4 
            callstatic debug Trace ::nonevar ::temp4 0 ;2 variable args
            ; line 1367
            callmethod ClearPending self ::nonevar ;0 variable args
            jmp _label0
          _label0
          .endCode
        .endFunction ;SendStoryLLMRequest
        .function OnDungeonMasterResponse
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param response String
            .param success Int
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 Bool
            .local responseLen Int
            .local ::temp1 Int
            .local ::temp2 String
            .local ::temp3 String
            .local storyType String
            .local npcName String
            .local narration String
            .local isFactionQuest Bool
            .local preSubTypeEarly String
            .local typeWithSub String
            .local subTypeForTracking String
            .local npc actor
            .local ::temp4 actor
            .local lowerNpcName String
            .local substFaction String
            .local substSender String
            .local senderActor actor
            .local ieTier Int
            .local npcCell cell
            .local ::temp5 cell
            .local playerCell cell
            .local playerCell2 cell
            .local toggles Int
            .local envFlags Int
            .local validateJson String
            .local validationReason String
            .local npcDispName String
            .local playerDispName String
            .local subjectName String
            .local gossipText String
            .local gossipSource String
            .local subjectNPC actor
            .local destination String
          .endLocalTable
          .code
            ; line 1376
            callmethod ClearPending self ::nonevar ;0 variable args
            ; line 1378
            cmp_eq ::temp0 success 1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 1379
            callstatic debug Trace ::nonevar "[IntelEngine] StoryEngine: DM LLM response failed" 0 ;2 variable args
            ; line 1380
            return None 
            jmp _label0
            ; line 1383
          _label0:
            callstatic stringUtil GetLength ::temp1 response ;1 variable args
            assign responseLen ::temp1 
            ; line 1384
            cast ::temp2 responseLen 
            strcat ::temp2 "[IntelEngine] StoryEngine: DM response len=" ::temp2 
            strcat ::temp2 ::temp2 " success=" 
            cast ::temp3 success 
            strcat ::temp3 ::temp2 ::temp3 
            callstatic debug Trace ::nonevar ::temp3 0 ;2 variable args
            ; line 1386
            callmethod ParseShouldAct self ::temp0 response ;1 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label1
            ; line 1387
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: rejected (no compelling story)" ;1 variable args
            ; line 1388
            return None 
            jmp _label1
            ; line 1391
          _label1:
            callmethod ExtractJsonField self ::temp3 response "type" ;2 variable args
            assign storyType ::temp3 
            ; line 1392
            callmethod ExtractJsonField self ::temp3 response "npc" ;2 variable args
            assign npcName ::temp3 
            ; line 1393
            callmethod ExtractJsonField self ::temp3 response "narration" ;2 variable args
            assign narration ::temp3 
            ; line 1395
            cmp_eq ::temp0 storyType "" 
            jmpf ::temp0 _label2
            ; line 1396
            cast ::temp3 responseLen 
            strcat ::temp3 "[IntelEngine] StoryEngine: DM response missing type -- response len=" ::temp3 
            callstatic debug Trace ::nonevar ::temp3 0 ;2 variable args
            ; line 1397
            return None 
            jmp _label2
            ; line 1401
          _label2:
            cmp_eq ::temp0 storyType "faction_ambush" 
            jmpf ::temp0 _label3
            ; line 1402
            callstatic intelEngine NotifyStoryTypePicked ::nonevar storyType ;1 variable args
            ; line 1403
            callmethod ExtractJsonField self ::temp3 response "ambushFaction" ;2 variable args
            callstatic intelEngine RecordStoryDispatch ::nonevar storyType ::temp3 narration ;3 variable args
            ; line 1404
            callmethod HandleFactionAmbushDispatch self ::nonevar narration response ;2 variable args
            ; line 1405
            return None 
            jmp _label3
            ; line 1411
          _label3:
            assign isFactionQuest False 
            ; line 1412
            cmp_eq ::temp0 storyType "quest" 
            jmpf ::temp0 _label4
            ; line 1413
            callmethod ExtractJsonField self ::temp3 response "questSubType" ;2 variable args
            assign preSubTypeEarly ::temp3 
            ; line 1414
            cmp_eq ::temp0 preSubTypeEarly "faction_combat" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label5
            cmp_eq ::temp0 preSubTypeEarly "faction_rescue" 
            assign ::temp0 ::temp0 
          _label5:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label6
            cmp_eq ::temp0 preSubTypeEarly "faction_battle" 
            assign ::temp0 ::temp0 
          _label6:
            jmpf ::temp0 _label7
            ; line 1415
            assign isFactionQuest True 
            ; line 1416
            cmp_eq ::temp0 npcName "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label8
            ; line 1417
            strcat ::temp3 "Story DM: faction quest " preSubTypeEarly 
            strcat ::temp3 ::temp3 " sent npc='" 
            strcat ::temp3 ::temp3 npcName 
            strcat ::temp3 ::temp3 "' -- ignoring (system handles NPC selection)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1418
            assign npcName "" 
            jmp _label8
          _label8:
            jmp _label9
            ; line 1420
          _label7:
            cmp_eq ::temp0 npcName "" 
            jmpf ::temp0 _label9
            ; line 1421
            cast ::temp3 responseLen 
            strcat ::temp3 "[IntelEngine] StoryEngine: DM response missing npc -- response len=" ::temp3 
            callstatic debug Trace ::nonevar ::temp3 0 ;2 variable args
            ; line 1422
            return None 
            jmp _label9
          _label9:
            jmp _label10
            ; line 1424
          _label4:
            cmp_eq ::temp0 npcName "" 
            jmpf ::temp0 _label10
            ; line 1425
            cast ::temp3 responseLen 
            strcat ::temp3 "[IntelEngine] StoryEngine: DM response missing npc -- response len=" ::temp3 
            callstatic debug Trace ::nonevar ::temp3 0 ;2 variable args
            ; line 1426
            return None 
            jmp _label10
            ; line 1432
          _label10:
            assign typeWithSub storyType 
            ; line 1433
            cmp_eq ::temp0 storyType "quest" 
            jmpf ::temp0 _label11
            ; line 1434
            callmethod ExtractJsonField self ::temp3 response "questSubType" ;2 variable args
            assign subTypeForTracking ::temp3 
            ; line 1435
            cmp_eq ::temp0 subTypeForTracking "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label12
            ; line 1436
            strcat ::temp3 "quest/" subTypeForTracking 
            assign typeWithSub ::temp3 
            jmp _label12
          _label12:
            jmp _label11
            ; line 1439
          _label11:
            callstatic intelEngine NotifyStoryTypePicked ::nonevar typeWithSub ;1 variable args
            ; line 1443
            callstatic intelEngine RecordStoryDispatch ::nonevar typeWithSub npcName narration ;3 variable args
            ; line 1447
            cast ::temp4 None 
            assign npc ::temp4 
            ; line 1448
            not ::temp0 isFactionQuest 
            jmpf ::temp0 _label13
            ; line 1449
            callstatic intelEngine ResolveStoryCandidate ::temp4 npcName ;1 variable args
            assign npc ::temp4 
            ; line 1450
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label14
            callmethod IsDead npc ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label14:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label15
            callmethod IsDisabled npc ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label15:
            jmpf ::temp0 _label16
            ; line 1457
            callstatic intelEngine StringToLower ::temp3 npcName ;1 variable args
            assign lowerNpcName ::temp3 
            ; line 1458
            cmp_eq ::temp0 lowerNpcName "courier" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label17
            cmp_eq ::temp0 lowerNpcName "messenger" 
            assign ::temp0 ::temp0 
          _label17:
            jmpf ::temp0 _label18
            ; line 1460
            cast ::temp4 None 
            assign npc ::temp4 
            ; line 1461
            callmethod ExtractJsonField self ::temp3 response "alliedFaction" ;2 variable args
            assign substFaction ::temp3 
            ; line 1462
            cmp_eq ::temp0 substFaction "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label19
            ; line 1463
            callstatic intelEngine FindFactionMember ::temp4 substFaction ;1 variable args
            assign npc ::temp4 
            ; line 1464
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label20
            ; line 1465
            strcat ::temp3 "Story DM: substituting disabled '" npcName 
            strcat ::temp3 ::temp3 "' with " 
            strcat ::temp3 ::temp3 substFaction 
            strcat ::temp3 ::temp3 " member " 
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 ::temp3 ::temp2 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            jmp _label20
          _label20:
            jmp _label19
            ; line 1468
          _label19:
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            jmpf ::temp0 _label21
            ; line 1469
            callmethod ExtractJsonField self ::temp2 response "sender" ;2 variable args
            assign substSender ::temp2 
            ; line 1470
            cmp_eq ::temp0 substSender "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label22
            ; line 1471
            callstatic intelEngine FindNPCByName ::temp4 substSender ;1 variable args
            assign senderActor ::temp4 
            ; line 1472
            cast ::temp4 None 
            cmp_eq ::temp0 senderActor ::temp4 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label23
            callmethod IsDead senderActor ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label23:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label24
            callmethod IsDisabled senderActor ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label24:
            jmpf ::temp0 _label25
            ; line 1473
            callstatic intelEngine FindMessengerForSender ::temp4 senderActor ;1 variable args
            assign npc ::temp4 
            ; line 1474
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label26
            ; line 1475
            strcat ::temp2 "Story DM: substituting disabled '" npcName 
            strcat ::temp2 ::temp2 "' with " 
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 " (messenger near " 
            strcat ::temp3 ::temp3 substSender 
            strcat ::temp3 ::temp3 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label26
          _label26:
            jmp _label25
          _label25:
            jmp _label22
          _label22:
            jmp _label21
          _label21:
            jmp _label18
            ; line 1481
          _label18:
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label27
            callmethod IsDead npc ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label27:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label28
            callmethod IsDisabled npc ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label28:
            jmpf ::temp0 _label29
            ; line 1482
            strcat ::temp3 "Story DM: NPC '" npcName 
            strcat ::temp3 ::temp3 "' not found or invalid" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1483
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "npc not found / dead / disabled" ;1 variable args
            ; line 1484
            return None 
            jmp _label29
          _label29:
            jmp _label16
          _label16:
            jmp _label13
            ; line 1489
          _label13:
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label30
            ; line 1495
            callstatic intelEngine IsHighStatusNPC ::temp0 npc ;1 variable args
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label31
            cmp_eq ::temp0 storyType "message" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label31:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label32
            cmp_eq ::temp0 storyType "quest" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label32:
            jmpf ::temp0 _label33
            ; line 1496
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 "Story DM: " ::temp3 
            strcat ::temp3 ::temp3 " is high-status — rejected (should use courier mode)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1497
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "high-status NPC cannot physically travel" ;1 variable args
            ; line 1498
            return None 
            jmp _label33
            ; line 1502
          _label33:
            callstatic intelEngine CheckHoldRestriction ::temp0 npc storyType ;2 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label34
            ; line 1503
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 "Story DM: " ::temp3 
            strcat ::temp3 ::temp3 " rejected — hold restriction for " 
            strcat ::temp3 ::temp3 storyType 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1504
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "hold restriction" ;1 variable args
            ; line 1505
            return None 
            jmp _label34
            ; line 1507
          _label34:
            callmethod ApplyCooldownCheck self ::temp0 npc ;1 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label35
            ; line 1508
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 "Story DM: " ::temp3 
            strcat ::temp3 ::temp3 " on cooldown" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1509
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "on story cooldown" ;1 variable args
            ; line 1510
            return None 
            jmp _label35
            ; line 1513
          _label35:
            callmethod IEB_StoryTier self ::temp1 storyType ;1 variable args
            assign ieTier ::temp1 
            ; line 1514
            cmp_gt ::temp0 ieTier 0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label36
            callmethod IEB_StoryBlocked self ::temp0 npc ieTier ;2 variable args
            assign ::temp0 ::temp0 
          _label36:
            jmpf ::temp0 _label37
            ; line 1515
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 "Story DM: " ::temp3 
            strcat ::temp3 ::temp3 " is committed to a quest - " 
            strcat ::temp3 ::temp3 storyType 
            strcat ::temp3 ::temp3 " refused" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1516
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "npc is committed to a quest" ;1 variable args
            ; line 1517
            return None 
            jmp _label37
            ; line 1522
          _label37:
            cmp_eq ::temp0 storyType "seek_player" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label38
            cmp_eq ::temp0 storyType "informant" 
            assign ::temp0 ::temp0 
          _label38:
            jmpf ::temp0 _label39
            ; line 1523
            callmethod GetParentCell npc ::temp5 ;0 variable args
            assign npcCell ::temp5 
            ; line 1524
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod GetParentCell ::temp4 ::temp5 ;0 variable args
            assign playerCell ::temp5 
            ; line 1525
            cast ::temp5 None 
            cmp_eq ::temp0 npcCell ::temp5 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label40
            cast ::temp5 None 
            cmp_eq ::temp0 playerCell ::temp5 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label40:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label41
            cmp_eq ::temp0 npcCell playerCell 
            assign ::temp0 ::temp0 
          _label41:
            jmpf ::temp0 _label42
            ; line 1526
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 "Story DM: " ::temp3 
            strcat ::temp3 ::temp3 " already in player's cell, skipping " 
            strcat ::temp3 ::temp3 storyType 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1527
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "npc already in player's cell" ;1 variable args
            ; line 1528
            return None 
            jmp _label42
          _label42:
            jmp _label39
            ; line 1533
          _label39:
            cmp_eq ::temp0 storyType "stalker" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label43
            cmp_eq ::temp0 storyType "ambush" 
            assign ::temp0 ::temp0 
          _label43:
            jmpf ::temp0 _label44
            ; line 1534
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod GetParentCell ::temp4 ::temp5 ;0 variable args
            assign playerCell2 ::temp5 
            ; line 1535
            cast ::temp5 None 
            cmp_eq ::temp0 playerCell2 ::temp5 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label45
            callmethod IsInterior playerCell2 ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label45:
            jmpf ::temp0 _label46
            ; line 1536
            strcat ::temp3 "Story DM: rejecting " storyType 
            strcat ::temp3 ::temp3 " -- player is in interior" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1537
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "interior cell rejects stalker/ambush" ;1 variable args
            ; line 1538
            return None 
            jmp _label46
          _label46:
            jmp _label44
          _label44:
            jmp _label30
            ; line 1543
          _label30:
            jmpf isFactionQuest _label47
            ; line 1544
            callmethod ExtractJsonField self ::temp3 response "questSubType" ;2 variable args
            strcat ::temp3 "Story DM [quest/faction]: " ::temp3 
            strcat ::temp3 ::temp3 " -- " 
            strcat ::temp3 ::temp3 narration 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label48
            ; line 1546
          _label47:
            strcat ::temp3 "Story DM [" storyType 
            strcat ::temp3 ::temp3 "]: " 
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 ::temp3 ::temp2 
            strcat ::temp2 ::temp2 " -- " 
            strcat ::temp2 ::temp2 narration 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 1551
          _label48:
            callmethod PackToggleBitmask self ::temp1 ;0 variable args
            assign toggles ::temp1 
            ; line 1552
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod PackEnvFlags self ::temp1 ::temp4 ;1 variable args
            assign envFlags ::temp1 
            ; line 1553
            callstatic intelEngine ValidateStoryResponse ::temp2 response toggles envFlags ;3 variable args
            assign validateJson ::temp2 
            ; line 1554
            callstatic intelEngine StoryResponseGetField ::temp2 validateJson "valid" ;2 variable args
            cmp_eq ::temp0 ::temp2 "true" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label49
            ; line 1555
            callstatic intelEngine StoryResponseGetField ::temp2 validateJson "reason" ;2 variable args
            assign validationReason ::temp2 
            ; line 1556
            strcat ::temp2 "Story DM: C++ validation rejected -- " validationReason 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 1557
            strcat ::temp2 "validation: " validationReason 
            callstatic intelEngine MarkLastDispatchFailed ::nonevar ::temp2 ;1 variable args
            ; line 1558
            return None 
            jmp _label49
            ; line 1562
          _label49:
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label50
            callstatic intelEngine IsJarl ::temp0 npc ;1 variable args
            assign ::temp0 ::temp0 
          _label50:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label51
            cmp_eq ::temp0 storyType "message" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label51:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label52
            cmp_eq ::temp0 storyType "quest" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label52:
            jmpf ::temp0 _label53
            ; line 1563
            strcat ::temp2 "Story DM: rejecting " storyType 
            strcat ::temp2 ::temp2 " for Jarl " 
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 ::temp2 ::temp3 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1566
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "high-status NPC cannot physically travel" ;1 variable args
            ; line 1567
            return None 
            jmp _label53
            ; line 1571
          _label53:
            cmp_eq ::temp0 storyType "quest" 
            jmpf ::temp0 _label54
            ; line 1572
            jmpf ::QuestActive_var _label55
            ; line 1573
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest rejected -- one already active" ;1 variable args
            ; line 1574
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "a quest is already active" ;1 variable args
            ; line 1575
            return None 
            jmp _label55
          _label55:
            jmp _label56
            ; line 1578
          _label54:
            cmp_eq ::temp0 storyType "message" 
            jmpf ::temp0 _label56
            ; line 1579
            callmethod ExtractJsonField self ::temp3 response "msgContent" ;2 variable args
            cmp_eq ::temp0 ::temp3 "" 
            jmpf ::temp0 _label57
            ; line 1580
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: message rejected -- missing msgContent" ;1 variable args
            ; line 1583
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "validation: missing msgContent" ;1 variable args
            ; line 1584
            return None 
            jmp _label57
          _label57:
            jmp _label56
            ; line 1592
          _label56:
            cmp_eq ::temp0 storyType "message" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label58
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label58:
            jmpf ::temp0 _label59
            ; line 1593
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            assign npcDispName ::temp3 
            ; line 1594
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod GetDisplayName ::temp4 ::temp3 ;0 variable args
            assign playerDispName ::temp3 
            ; line 1595
            callstatic intelEngine NPCKnowsPlayer ::temp0 npc ;1 variable args
            jmpf ::temp0 _label60
            ; line 1596
            callstatic game GetPlayer ::temp4 ;0 variable args
            strcat ::temp3 npcDispName " set out to find " 
            strcat ::temp3 ::temp3 playerDispName 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc ::temp4 ::temp3 ;3 variable args
            jmp _label61
            ; line 1598
          _label60:
            callstatic game GetPlayer ::temp4 ;0 variable args
            strcat ::temp3 npcDispName " set out to find someone known as '" 
            strcat ::temp3 ::temp3 playerDispName 
            strcat ::temp3 ::temp3 "' — has never met them before, only heard the name" 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc ::temp4 ::temp3 ;3 variable args
            ; line 1599
            strcat ::temp3 "has never met " playerDispName 
            strcat ::temp3 ::temp3 " personally — approaching a stranger, should introduce themselves and confirm identity" 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp3 ;2 variable args
          _label61:
            jmp _label59
            ; line 1604
          _label59:
            cmp_eq ::temp0 storyType "seek_player" 
            jmpf ::temp0 _label62
            ; line 1605
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod GetDisplayName ::temp4 ::temp3 ;0 variable args
            strcat ::temp3 "set out to find " ::temp3 
            strcat ::temp3 ::temp3 " -- " 
            strcat ::temp3 ::temp3 narration 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp3 ;2 variable args
            ; line 1606
            assign ::ActiveStoryType_var storyType 
            ; line 1607
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod DispatchToTarget self ::nonevar npc ::temp4 narration "story" ;4 variable args
            jmp _label63
            ; line 1609
          _label62:
            cmp_eq ::temp0 storyType "message" 
            jmpf ::temp0 _label64
            ; line 1610
            callmethod HandleMessageDispatch self ::nonevar npc narration response ;3 variable args
            jmp _label63
            ; line 1612
          _label64:
            cmp_eq ::temp0 storyType "ambush" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label65
            cmp_eq ::temp0 storyType "stalker" 
            assign ::temp0 ::temp0 
          _label65:
            jmpf ::temp0 _label66
            ; line 1613
            callmethod HandleAmbushStalkerDispatch self ::nonevar npc narration response storyType ;4 variable args
            jmp _label63
            ; line 1615
          _label66:
            cmp_eq ::temp0 storyType "quest" 
            jmpf ::temp0 _label67
            ; line 1616
            callmethod HandleQuestDispatch self ::nonevar npc narration response ;3 variable args
            jmp _label63
            ; line 1618
          _label67:
            cmp_eq ::temp0 storyType "informant" 
            jmpf ::temp0 _label68
            ; line 1619
            callmethod ExtractJsonField self ::temp3 response "subject" ;2 variable args
            assign subjectName ::temp3 
            ; line 1620
            callmethod ExtractJsonField self ::temp3 response "gossip" ;2 variable args
            assign gossipText ::temp3 
            ; line 1621
            callmethod ExtractJsonField self ::temp3 response "sender" ;2 variable args
            assign gossipSource ::temp3 
            ; line 1622
            cmp_eq ::temp0 subjectName "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label69
            cmp_eq ::temp0 gossipText "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label69:
            jmpf ::temp0 _label70
            ; line 1623
            callstatic intelEngine FindNPCByName ::temp4 subjectName ;1 variable args
            assign subjectNPC ::temp4 
            ; line 1624
            cast ::temp4 None 
            cmp_eq ::temp0 subjectNPC ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label71
            ; line 1625
            callmethod InjectFact ::Core_var ::nonevar subjectNPC gossipText ;2 variable args
            jmp _label71
            ; line 1628
          _label71:
            cmp_eq ::temp0 gossipSource "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label72
            ; line 1629
            strcat ::temp3 "heard from " gossipSource 
            strcat ::temp3 ::temp3 " that " 
            strcat ::temp3 ::temp3 subjectName 
            strcat ::temp3 ::temp3 " " 
            strcat ::temp3 ::temp3 gossipText 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp3 ;2 variable args
            jmp _label73
            ; line 1631
          _label72:
            strcat ::temp3 "witnessed that " subjectName 
            strcat ::temp3 ::temp3 " " 
            strcat ::temp3 ::temp3 gossipText 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp3 ;2 variable args
          _label73:
            jmp _label70
            ; line 1634
          _label70:
            assign ::ActiveStoryType_var "informant" 
            ; line 1635
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod DispatchToTarget self ::nonevar npc ::temp4 narration "story" ;4 variable args
            jmp _label63
            ; line 1637
          _label68:
            cmp_eq ::temp0 storyType "road_encounter" 
            jmpf ::temp0 _label74
            ; line 1638
            callmethod ExtractJsonField self ::temp3 response "destination" ;2 variable args
            assign destination ::temp3 
            ; line 1639
            callmethod InjectFact ::Core_var ::nonevar npc narration ;2 variable args
            ; line 1640
            callmethod PlaceRoadEncounter self ::nonevar npc narration destination ;3 variable args
            jmp _label63
            ; line 1643
          _label74:
            strcat ::temp3 "Story DM: unknown type '" storyType 
            strcat ::temp3 ::temp3 "'" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
          _label63
          .endCode
        .endFunction ;OnDungeonMasterResponse
        .function SpreadGossipOffScreen
           ; function type 0
          .userFlags 0 ;none
          .docString "When both NPCs are off-screen, the rumor chains through up to 10 additional NPCs.
    Each new recipient heard it from the PREVIOUS person in the chain, not the original source.
    A tells B (primary), B tells C, C tells D, etc."
          .return None
          .paramTable
            .param originalGossiper actor
            .param firstRecipient actor
            .param gossip String
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local playerCell cell
            .local ::temp1 cell
            .local ::temp2 Bool
            .local trackKey String
            .local ::temp3 form
            .local ::temp4 Int
            .local spreads Int
            .local currentGiver actor
            .local s Int
            .local nextRecipient actor
            .local ::nonevar None
            .local ::temp5 String
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 1651
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1652
            callmethod GetParentCell player ::temp1 ;0 variable args
            assign playerCell ::temp1 
            ; line 1655
            cast ::temp1 None 
            cmp_eq ::temp2 playerCell ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label0
            ; line 1656
            callmethod GetParentCell originalGossiper ::temp1 ;0 variable args
            cmp_eq ::temp2 ::temp1 playerCell 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label1
            callmethod GetParentCell firstRecipient ::temp1 ;0 variable args
            cmp_eq ::temp2 ::temp1 playerCell 
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 1657
            return None 
            jmp _label2
          _label2:
            jmp _label0
            ; line 1662
          _label0:
            assign trackKey "Intel_GossipChainTemp" 
            ; line 1663
            cast ::temp3 player 
            callstatic storageUtil IntListClear ::temp4 ::temp3 trackKey ;2 variable args
            ; line 1664
            cast ::temp3 player 
            callmethod GetFormID originalGossiper ::temp4 ;0 variable args
            callstatic storageUtil IntListAdd ::temp4 ::temp3 trackKey ::temp4 True ;4 variable args
            ; line 1665
            cast ::temp3 player 
            callmethod GetFormID firstRecipient ::temp4 ;0 variable args
            callstatic storageUtil IntListAdd ::temp4 ::temp3 trackKey ::temp4 True ;4 variable args
            ; line 1667
            callstatic utility RandomInt ::temp4 1 10 ;2 variable args
            assign spreads ::temp4 
            ; line 1668
            assign currentGiver firstRecipient 
            ; line 1669
            assign s 0 
            ; line 1670
          _label7:
            cmp_lt ::temp2 s spreads 
            jmpf ::temp2 _label3
            ; line 1671
            callstatic intelEngine GetRelatedCandidate ::temp0 currentGiver ;1 variable args
            assign nextRecipient ::temp0 
            ; line 1672
            cast ::temp0 None 
            cmp_eq ::temp2 nextRecipient ::temp0 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label4
            cast ::temp3 player 
            callmethod GetFormID nextRecipient ::temp4 ;0 variable args
            callstatic storageUtil IntListFind ::temp4 ::temp3 trackKey ::temp4 ;3 variable args
            cmp_lt ::temp2 ::temp4 0 
            assign ::temp2 ::temp2 
          _label4:
            jmpf ::temp2 _label5
            ; line 1673
            callmethod InjectGossip ::Core_var ::nonevar currentGiver nextRecipient gossip ;3 variable args
            ; line 1674
            callmethod GetDisplayName currentGiver ::temp5 ;0 variable args
            strcat ::temp5 "[IntelEngine] StoryEngine [npc_gossip chain]: " ::temp5 
            strcat ::temp5 ::temp5 " -> " 
            callmethod GetDisplayName nextRecipient ::temp6 ;0 variable args
            strcat ::temp6 ::temp5 ::temp6 
            callstatic debug Trace ::nonevar ::temp6 0 ;2 variable args
            ; line 1675
            callmethod GetDisplayName currentGiver ::temp6 ;0 variable args
            strcat ::temp6 "npc_gossip: " ::temp6 
            strcat ::temp6 ::temp6 " told " 
            callmethod GetDisplayName nextRecipient ::temp5 ;0 variable args
            strcat ::temp5 ::temp6 ::temp5 
            strcat ::temp5 ::temp5 ": " 
            strcat ::temp5 ::temp5 gossip 
            callmethod AddRecentStoryEvent self ::nonevar ::temp5 ;1 variable args
            ; line 1676
            cast ::temp3 player 
            callmethod GetFormID nextRecipient ::temp4 ;0 variable args
            callstatic storageUtil IntListAdd ::temp4 ::temp3 trackKey ::temp4 True ;4 variable args
            ; line 1677
            assign currentGiver nextRecipient 
            jmp _label6
            ; line 1679
          _label5:
            cast ::temp3 player 
            callstatic storageUtil IntListClear ::temp4 ::temp3 trackKey ;2 variable args
            ; line 1680
            return None 
            ; line 1682
          _label6:
            iadd ::temp4 s 1 
            assign s ::temp4 
            jmp _label7
            ; line 1684
          _label3:
            cast ::temp3 player 
            callstatic storageUtil IntListClear ::temp4 ::temp3 trackKey ;2 variable args
          .endCode
        .endFunction ;SpreadGossipOffScreen
        .function DispatchToTarget
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param npc actor
            .param target actor
            .param narration String
            .param slotTaskType String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 String
            .local player actor
            .local ::temp2 actor
            .local exteriorDoor objectReference
            .local ::temp3 objectReference
            .local npcName String
            .local playerName String
            .local knockResult String
            .local playerCell cell
            .local ::temp4 cell
            .local ::temp5 Int
            .local slot Int
            .local ::temp6 String
            .local targetName String
            .local ::temp7 Float
            .local ::temp8 form
            .local MAX_STORY_OFFSCREEN_HOURS Float
            .local maxWait Float
            .local now Float
            .local estimate Float
            .local capped Float
            .local ::temp9 objectReference
            .local ::temp10 quest
          .endLocalTable
          .code
            ; line 1692
            callmethod IEB_DispatchBlocked self ::temp0 npc ;1 variable args
            jmpf ::temp0 _label0
            ; line 1693
            callmethod GetDisplayName npc ::temp1 ;0 variable args
            strcat ::temp1 "Story DM: " ::temp1 
            strcat ::temp1 ::temp1 " is busy or with the player - dispatch refused" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 1694
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "npc is busy or travelling with the player" ;1 variable args
            ; line 1695
            assign ::ActiveStoryType_var "" 
            ; line 1696
            return None 
            jmp _label0
            ; line 1698
          _label0:
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign player ::temp2 
            ; line 1701
            cmp_eq ::temp0 target player 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label1
            callmethod IsNPCToNPCType self ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label1:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label2
            callstatic intelEngine IsPlayerInOwnHome ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label2:
            jmpf ::temp0 _label3
            ; line 1702
            callstatic intelEngine GetPlayerHomeExteriorDoor ::temp3 ;0 variable args
            assign exteriorDoor ::temp3 
            ; line 1703
            cast ::temp3 None 
            cmp_eq ::temp0 exteriorDoor ::temp3 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label4
            ; line 1704
            callmethod GetDisplayName npc ::temp1 ;0 variable args
            assign npcName ::temp1 
            ; line 1705
            callmethod GetDisplayName player ::temp1 ;0 variable args
            assign playerName ::temp1 
            ; line 1709
            strcat ::temp1 npcName " is knocking at your door." 
            callstatic skyMessage Show ::temp1 ::temp1 "Let them in" "Send them away" "Ignore" "" "" "" "" "" "" "" False 0.100000001 30.0 ;14 variable args
            assign knockResult ::temp1 
            ; line 1712
            cmp_eq ::temp0 knockResult "Let them in" 
            jmpf ::temp0 _label5
            ; line 1714
            callmethod GetParentCell player ::temp4 ;0 variable args
            assign playerCell ::temp4 
            ; line 1715
            cast ::temp4 None 
            cmp_eq ::temp0 playerCell ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label6
            ; line 1716
            callmethod GetFormID playerCell ::temp5 ;0 variable args
            callstatic intelEngine SetHomeDoorAccessForCell ::temp3 ::temp5 True ;2 variable args
            jmp _label6
            ; line 1718
          _label6:
            callmethod MoveTo npc ::nonevar exteriorDoor 0.0 0.0 0.0 False ;5 variable args
            jmp _label7
            ; line 1720
          _label5:
            cmp_eq ::temp0 knockResult "Send them away" 
            jmpf ::temp0 _label8
            ; line 1721
            callmethod MoveTo npc ::nonevar exteriorDoor 0.0 0.0 0.0 False ;5 variable args
            ; line 1722
            strcat ::temp1 "went to visit " playerName 
            strcat ::temp1 ::temp1 " at home but was turned away at the door" 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp1 ;2 variable args
            ; line 1723
            strcat ::temp1 npcName " knocked on " 
            strcat ::temp1 ::temp1 playerName 
            strcat ::temp1 ::temp1 "'s door but was told to go away" 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc player ::temp1 ;3 variable args
            ; line 1724
            assign ::ActiveStoryType_var "" 
            ; line 1725
            return None 
            jmp _label7
            ; line 1727
          _label8:
            callmethod MoveTo npc ::nonevar exteriorDoor 0.0 0.0 0.0 False ;5 variable args
            ; line 1728
            strcat ::temp1 "went to visit " playerName 
            strcat ::temp1 ::temp1 " at home but nobody answered the door" 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp1 ;2 variable args
            ; line 1729
            strcat ::temp1 npcName " knocked on " 
            strcat ::temp1 ::temp1 playerName 
            strcat ::temp1 ::temp1 "'s door but got no answer" 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc player ::temp1 ;3 variable args
            ; line 1730
            assign ::ActiveStoryType_var "" 
            ; line 1731
            return None 
          _label7:
            jmp _label4
          _label4:
            jmp _label3
            ; line 1736
          _label3:
            callmethod FindFreeAgentSlot ::Core_var ::temp5 ;0 variable args
            assign slot ::temp5 
            ; line 1737
            cmp_lt ::temp0 slot 0 
            jmpf ::temp0 _label9
            ; line 1738
            callstatic debug Trace ::nonevar "[IntelEngine] StoryEngine: No free slots for dispatch" 0 ;2 variable args
            ; line 1740
            cmp_eq ::temp0 target player 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label10
            ; line 1741
            strcat ::temp1 ::ActiveStoryType_var ": " 
            callmethod BuildInteractionSummary self ::temp6 npc narration target ;3 variable args
            strcat ::temp6 ::temp1 ::temp6 
            callmethod AddRecentStoryEvent self ::nonevar ::temp6 ;1 variable args
            jmp _label10
            ; line 1744
          _label10:
            assign ::ActiveStoryType_var "" 
            ; line 1745
            return None 
            jmp _label9
            ; line 1749
          _label9:
            callmethod GetDisplayName target ::temp6 ;0 variable args
            assign targetName ::temp6 
            ; line 1750
            cmp_eq ::temp0 target player 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label11
            ; line 1751
            assign ::ActiveSecondNPC_var target 
            jmp _label11
            ; line 1754
          _label11:
            callmethod AllocateSlot ::Core_var ::nonevar slot npc slotTaskType targetName 1 ;5 variable args
            ; line 1756
            assign ::ActiveStoryNPC_var npc 
            ; line 1757
            assign ::ActiveNarration_var narration 
            ; line 1758
            assign ::IsActive_var True 
            ; line 1759
            callstatic utility GetCurrentGameTime ::temp7 ;0 variable args
            callstatic intelEngine MarkSystemPending ::nonevar "storyDM" ::temp7 ;2 variable args
            ; line 1760
            cast ::temp8 npc 
            callstatic storageUtil SetIntValue ::temp5 ::temp8 "Intel_IsStoryDispatch" 1 ;3 variable args
            ; line 1761
            cast ::temp8 npc 
            callstatic storageUtil SetStringValue ::temp6 ::temp8 "Intel_StoryNarration" narration ;3 variable args
            ; line 1763
            callmethod ReapplyTravelPackage self ::nonevar npc ;1 variable args
            ; line 1765
            callmethod InitializeStuckTrackingForSlot ::Core_var ::nonevar slot npc ;2 variable args
            ; line 1766
            cast ::temp3 target 
            callmethod InitOffScreenTracking ::Core_var ::nonevar slot npc ::temp3 ;3 variable args
            ; line 1771
            cmp_eq ::temp0 target player 
            jmpf ::temp0 _label12
            ; line 1772
            assign MAX_STORY_OFFSCREEN_HOURS 0.25 
            ; line 1773
            fdiv ::temp7 MAX_STORY_OFFSCREEN_HOURS 24.0 
            assign maxWait ::temp7 
            ; line 1774
            callstatic utility GetCurrentGameTime ::temp7 ;0 variable args
            assign now ::temp7 
            ; line 1775
            cast ::temp8 npc 
            callstatic storageUtil GetFloatValue ::temp7 ::temp8 "Intel_OffscreenArrival" 0.0 ;3 variable args
            assign estimate ::temp7 
            ; line 1776
            cmp_gt ::temp0 estimate 0.0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label13
            fsub ::temp7 estimate now 
            cmp_gt ::temp0 ::temp7 maxWait 
            assign ::temp0 ::temp0 
          _label13:
            jmpf ::temp0 _label14
            ; line 1777
            fadd ::temp7 now maxWait 
            assign capped ::temp7 
            ; line 1778
            callstatic intelEngine InitOffScreenTravel ::nonevar slot capped npc ;3 variable args
            ; line 1779
            cast ::temp8 npc 
            callstatic storageUtil SetFloatValue ::temp7 ::temp8 "Intel_OffscreenArrival" capped ;3 variable args
            ; line 1780
            callmethod GetDisplayName npc ::temp6 ;0 variable args
            strcat ::temp6 ::temp6 " story off-screen capped to " 
            cast ::temp1 MAX_STORY_OFFSCREEN_HOURS 
            strcat ::temp1 ::temp6 ::temp1 
            strcat ::temp1 ::temp1 "H (was " 
            fsub ::temp7 estimate now 
            fmul ::temp7 ::temp7 24.0 
            cast ::temp6 ::temp7 
            strcat ::temp6 ::temp1 ::temp6 
            strcat ::temp6 ::temp6 "H)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp6 ;1 variable args
            jmp _label14
          _label14:
            jmp _label12
            ; line 1784
          _label12:
            callmethod StopScheduler self ::nonevar ;0 variable args
            ; line 1790
            cast ::temp3 npc 
            cast ::temp9 target 
            cast ::temp10 self 
            callstatic intelEngine ArmProximityArrival ::nonevar slot ::temp3 ::temp9 ::temp10 "IntelEngine_StoryEngine" "OnProximityArrived" ;6 variable args
            ; line 1792
            propget MONITOR_INTERVAL self ::temp7 
            callmethod RegisterForSingleUpdate self ::nonevar ::temp7 ;1 variable args
          .endCode
        .endFunction ;DispatchToTarget
        .function OnProximityArrived
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param slotStr String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1800
            not ::temp0 ::IsActive_var 
            jmpf ::temp0 _label0
            ; line 1801
            return None 
            jmp _label0
            ; line 1804
          _label0:
            cast ::temp1 None 
            cmp_eq ::temp0 ::ActiveStoryNPC_var ::temp1 
            jmpf ::temp0 _label1
            ; line 1805
            return None 
            jmp _label1
            ; line 1807
          _label1:
            callmethod CheckStoryNPCArrival self ::nonevar ;0 variable args
          .endCode
        .endFunction ;OnProximityArrived
        .function PerformVisibleInteraction
           ; function type 0
          .userFlags 0 ;none
          .docString "Both NPCs in player cell -- instant visible interaction, no travel needed."
          .return None
          .paramTable
            .param npc1 actor
            .param npc2 actor
            .param eventText String
            .param eventType String
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 objectReference
            .local summary String
            .local ::temp1 String
          .endLocalTable
          .code
            ; line 1816
            cast ::temp0 npc2 
            callmethod SetLookAt npc1 ::nonevar ::temp0 False ;2 variable args
            ; line 1817
            cast ::temp0 npc1 
            callmethod SetLookAt npc2 ::nonevar ::temp0 False ;2 variable args
            ; line 1818
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 1820
            callmethod BuildInteractionSummary self ::temp1 npc1 eventText npc2 ;3 variable args
            assign summary ::temp1 
            ; line 1821
            callmethod SendTaskNarration ::Core_var ::nonevar npc1 summary npc2 ;3 variable args
            ; line 1823
            strcat ::temp1 eventType ": " 
            strcat ::temp1 ::temp1 summary 
            callmethod AddRecentStoryEvent self ::nonevar ::temp1 ;1 variable args
            ; line 1825
            strcat ::temp1 "[IntelEngine] StoryEngine: Visible " eventType 
            strcat ::temp1 ::temp1 " performed" 
            callstatic debug Trace ::nonevar ::temp1 0 ;2 variable args
          .endCode
        .endFunction ;PerformVisibleInteraction
        .function PlaceRoadEncounter
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param npc actor
            .param narration String
            .param destination String
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local playerCell cell
            .local ::temp1 cell
            .local ::temp2 Bool
            .local ::nonevar None
            .local placeDist Float
            .local ::temp3 Float
            .local offset Float[]
            .local ::temp4 objectReference
            .local ::temp5 Float[]
            .local ::temp6 Float
            .local ::temp7 String
            .local destMarker objectReference
            .local ::temp8 form
            .local ::temp9 form
            .local ::temp10 keyword
            .local ::temp11 package
            .local ::temp12 Int
            .local npcFormId Int
          .endLocalTable
          .code
            ; line 1833
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1834
            callmethod GetParentCell player ::temp1 ;0 variable args
            assign playerCell ::temp1 
            ; line 1837
            cast ::temp1 None 
            cmp_eq ::temp2 playerCell ::temp1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label0
            callmethod IsInterior playerCell ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
          _label0:
            jmpf ::temp2 _label1
            ; line 1838
            callstatic debug Trace ::nonevar "[IntelEngine] StoryEngine: Skipping road encounter -- player is indoors" 0 ;2 variable args
            ; line 1839
            return None 
            jmp _label1
            ; line 1843
          _label1:
            callstatic utility RandomFloat ::temp3 3000.0 5000.0 ;2 variable args
            assign placeDist ::temp3 
            ; line 1844
            cast ::temp4 player 
            fneg ::temp3 placeDist 
            callstatic intelEngine GetOffsetBehind ::temp5 ::temp4 ::temp3 ;2 variable args
            assign offset ::temp5 
            ; line 1845
            cast ::temp4 player 
            array_getlement ::temp3 offset 0 
            array_getlement ::temp6 offset 1 
            callmethod MoveTo npc ::nonevar ::temp4 ::temp3 ::temp6 0.0 False ;5 variable args
            ; line 1848
            callmethod GetDisplayName npc ::temp7 ;0 variable args
            strcat ::temp7 ::temp7 " " 
            strcat ::temp7 ::temp7 narration 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc npc ::temp7 ;3 variable args
            ; line 1851
            cast ::temp4 None 
            assign destMarker ::temp4 
            ; line 1852
            cmp_eq ::temp2 destination "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label2
            ; line 1853
            callstatic intelEngine ResolveAnyDestination ::temp4 npc destination ;2 variable args
            assign destMarker ::temp4 
            jmp _label2
            ; line 1857
          _label2:
            callmethod RemoveAllPackages ::Core_var ::nonevar npc False ;2 variable args
            ; line 1859
            cast ::temp4 None 
            cmp_eq ::temp2 destMarker ::temp4 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label3
            ; line 1861
            cast ::temp8 npc 
            cast ::temp9 destMarker 
            callstatic storageUtil SetFormValue ::temp9 ::temp8 "Intel_FakeEncounterDest" ::temp9 ;3 variable args
            ; line 1862
            cast ::temp4 npc 
            propget IntelEngine_TravelTarget ::Core_var ::temp10 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp4 destMarker ::temp10 ;3 variable args
            ; line 1863
            propget TravelPackage_Walk ::Core_var ::temp11 
            propget PRIORITY_TRAVEL ::Core_var ::temp12 
            callstatic actorUtil AddPackageOverride ::nonevar npc ::temp11 ::temp12 1 ;4 variable args
            ; line 1864
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 1865
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 1866
            callmethod GetDisplayName npc ::temp7 ;0 variable args
            strcat ::temp7 "Story: road encounter " ::temp7 
            strcat ::temp7 ::temp7 " traveling to " 
            strcat ::temp7 ::temp7 destination 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            jmp _label4
            ; line 1869
          _label3:
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 1870
            callmethod GetDisplayName npc ::temp7 ;0 variable args
            strcat ::temp7 "Story: road encounter " ::temp7 
            strcat ::temp7 ::temp7 " (no destination resolved)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            ; line 1874
          _label4:
            cast ::temp9 npc 
            callstatic storageUtil SetStringValue ::temp7 ::temp9 "Intel_FakeEncounterNarration" narration ;3 variable args
            ; line 1877
            cast ::temp9 npc 
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp6 ::temp9 "Intel_FakeEncounterTime" ::temp6 ;3 variable args
            ; line 1878
            callmethod GetFormID npc ::temp12 ;0 variable args
            assign npcFormId ::temp12 
            ; line 1879
            cast ::temp9 player 
            callstatic storageUtil IntListFind ::temp12 ::temp9 "Intel_FakeEncounterNPCs" npcFormId ;3 variable args
            cmp_lt ::temp2 ::temp12 0 
            jmpf ::temp2 _label5
            ; line 1880
            cast ::temp9 player 
            callstatic storageUtil IntListAdd ::temp12 ::temp9 "Intel_FakeEncounterNPCs" npcFormId True ;4 variable args
            jmp _label5
            ; line 1883
          _label5:
            callmethod GetDisplayName npc ::temp7 ;0 variable args
            strcat ::temp7 "road_encounter: " ::temp7 
            strcat ::temp7 ::temp7 " -- " 
            strcat ::temp7 ::temp7 narration 
            callmethod AddRecentStoryEvent self ::nonevar ::temp7 ;1 variable args
            ; line 1886
            propget MONITOR_INTERVAL self ::temp6 
            callmethod RegisterForSingleUpdate self ::nonevar ::temp6 ;1 variable args
          .endCode
        .endFunction ;PlaceRoadEncounter
        .function CheckRoadEncounterProximity
           ; function type 0
          .userFlags 0 ;none
          .docString "Checks all active road encounter NPCs for proximity to the player.
    Called every MONITOR_INTERVAL from OnUpdate regardless of IsActive state."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local count Int
            .local ::temp1 form
            .local ::temp2 Int
            .local ::temp3 Bool
            .local i Int
            .local formId Int
            .local npc actor
            .local destMarker objectReference
            .local ::temp4 form
            .local ::temp5 objectReference
            .local ::temp6 Float
            .local ::temp7 Float
            .local ::nonevar None
            .local encounterPhase Int
            .local dist Float
            .local ::mangled_dist_0 Float
            .local greetTime Float
            .local elapsed Float
            .local shouldResume Bool
            .local ::temp8 package
            .local ::temp9 keyword
            .local ::temp10 objectReference
            .local ::temp11 String
          .endLocalTable
          .code
            ; line 1892
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1893
            cast ::temp1 player 
            callstatic storageUtil IntListCount ::temp2 ::temp1 "Intel_FakeEncounterNPCs" ;2 variable args
            assign count ::temp2 
            ; line 1894
            cmp_eq ::temp3 count 0 
            jmpf ::temp3 _label0
            ; line 1895
            return None 
            jmp _label0
            ; line 1898
          _label0:
            isub ::temp2 count 1 
            assign i ::temp2 
            ; line 1899
          _label22:
            comp_gte ::temp3 i 0 
            jmpf ::temp3 _label1
            ; line 1900
            cast ::temp1 player 
            callstatic storageUtil IntListGet ::temp2 ::temp1 "Intel_FakeEncounterNPCs" i ;3 variable args
            assign formId ::temp2 
            ; line 1901
            callstatic game GetForm ::temp1 formId ;1 variable args
            cast ::temp0 ::temp1 
            assign npc ::temp0 
            ; line 1903
            cast ::temp0 None 
            cmp_eq ::temp3 npc ::temp0 
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label2
            callmethod IsDead npc ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label2:
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label3
            callmethod IsDisabled npc ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label3:
            jmpf ::temp3 _label4
            ; line 1905
            cast ::temp1 player 
            callstatic storageUtil IntListRemoveAt ::temp3 ::temp1 "Intel_FakeEncounterNPCs" i ;3 variable args
            ; line 1906
            isub ::temp2 i 1 
            assign i ::temp2 
            jmp _label5
            ; line 1909
          _label4:
            cast ::temp1 npc 
            cast ::temp4 None 
            callstatic storageUtil GetFormValue ::temp4 ::temp1 "Intel_FakeEncounterDest" ::temp4 ;3 variable args
            cast ::temp5 ::temp4 
            assign destMarker ::temp5 
            ; line 1910
            cast ::temp5 None 
            cmp_eq ::temp3 destMarker ::temp5 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label6
            callmethod Is3DLoaded npc ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label6:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label7
            callmethod Is3DLoaded destMarker ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label7:
            jmpf ::temp3 _label8
            ; line 1911
            callmethod GetDistance npc ::temp6 destMarker ;1 variable args
            propget ARRIVAL_DISTANCE ::Core_var ::temp7 
            cmp_lte ::temp3 ::temp6 ::temp7 
            jmpf ::temp3 _label9
            ; line 1912
            callmethod CleanupRoadEncounterTravel self ::nonevar npc ;1 variable args
            jmp _label9
          _label9:
            jmp _label8
            ; line 1917
          _label8:
            cast ::temp4 npc 
            callstatic storageUtil GetIntValue ::temp2 ::temp4 "Intel_FakeEncounterInteracted" 0 ;3 variable args
            assign encounterPhase ::temp2 
            ; line 1918
            cmp_eq ::temp3 encounterPhase 0 
            jmpf ::temp3 _label10
            ; line 1919
            callmethod Is3DLoaded npc ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label11
            callmethod Is3DLoaded player ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label11:
            jmpf ::temp3 _label12
            ; line 1920
            cast ::temp5 player 
            callmethod GetDistance npc ::temp7 ::temp5 ;1 variable args
            assign dist ::temp7 
            ; line 1921
            propget ENCOUNTER_PROXIMITY self ::temp7 
            cmp_lte ::temp3 dist ::temp7 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label13
            cmp_gt ::temp3 dist 0.0 
            assign ::temp3 ::temp3 
          _label13:
            jmpf ::temp3 _label14
            ; line 1922
            callmethod TriggerRoadEncounterGreeting self ::nonevar npc ;1 variable args
            jmp _label14
          _label14:
            jmp _label12
          _label12:
            jmp _label15
            ; line 1925
          _label10:
            cmp_eq ::temp3 encounterPhase 1 
            jmpf ::temp3 _label15
            ; line 1927
            cast ::temp5 player 
            callmethod GetDistance npc ::temp7 ::temp5 ;1 variable args
            assign ::mangled_dist_0 ::temp7 
            ; line 1928
            cast ::temp4 npc 
            callstatic storageUtil GetFloatValue ::temp7 ::temp4 "Intel_FakeEncounterGreetTime" 0.0 ;3 variable args
            assign greetTime ::temp7 
            ; line 1929
            callstatic utility GetCurrentRealTime ::temp7 ;0 variable args
            fsub ::temp7 ::temp7 greetTime 
            assign elapsed ::temp7 
            ; line 1930
            propget ENCOUNTER_RESUME_DISTANCE self ::temp7 
            cmp_gt ::temp3 ::mangled_dist_0 ::temp7 
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label16
            cmp_gt ::temp3 greetTime 0.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label17
            propget LINGER_TIMEOUT_SECONDS self ::temp7 
            cmp_gt ::temp3 elapsed ::temp7 
            assign ::temp3 ::temp3 
          _label17:
            assign ::temp3 ::temp3 
          _label16:
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label18
            callmethod Is3DLoaded npc ::temp3 ;0 variable args
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
          _label18:
            assign shouldResume ::temp3 
            ; line 1931
            jmpf shouldResume _label19
            ; line 1933
            propget SandboxNearPlayerPackage ::Core_var ::temp8 
            callstatic actorUtil RemovePackageOverride ::temp3 npc ::temp8 ;2 variable args
            ; line 1934
            cast ::temp4 npc 
            cast ::temp1 None 
            callstatic storageUtil GetFormValue ::temp1 ::temp4 "Intel_FakeEncounterDest" ::temp1 ;3 variable args
            cast ::temp5 ::temp1 
            assign destMarker ::temp5 
            ; line 1935
            cast ::temp5 None 
            cmp_eq ::temp3 destMarker ::temp5 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label20
            ; line 1936
            cast ::temp5 npc 
            propget IntelEngine_TravelTarget ::Core_var ::temp9 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp5 destMarker ::temp9 ;3 variable args
            ; line 1937
            propget TravelPackage_Walk ::Core_var ::temp8 
            propget PRIORITY_TRAVEL ::Core_var ::temp2 
            callstatic actorUtil AddPackageOverride ::nonevar npc ::temp8 ::temp2 1 ;4 variable args
            jmp _label21
            ; line 1939
          _label20:
            cast ::temp5 npc 
            cast ::temp10 None 
            propget IntelEngine_TravelTarget ::Core_var ::temp9 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp5 ::temp10 ::temp9 ;3 variable args
            ; line 1941
          _label21:
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 1942
            cast ::temp1 npc 
            callstatic storageUtil SetIntValue ::temp2 ::temp1 "Intel_FakeEncounterInteracted" 2 ;3 variable args
            ; line 1943
            cast ::temp1 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp1 "Intel_FakeEncounterGreetTime" ;2 variable args
            ; line 1944
            callmethod GetDisplayName npc ::temp11 ;0 variable args
            strcat ::temp11 "Story [encounter]: " ::temp11 
            strcat ::temp11 ::temp11 " resuming travel" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp11 ;1 variable args
            jmp _label19
          _label19:
            jmp _label15
            ; line 1948
          _label15:
            isub ::temp2 i 1 
            assign i ::temp2 
          _label5:
            jmp _label22
          _label1
          .endCode
        .endFunction ;CheckRoadEncounterProximity
        .function HasLingerNPCs
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local ::temp1 form
            .local ::temp2 Int
            .local ::temp3 Bool
          .endLocalTable
          .code
            ; line 1961
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1962
            cast ::temp1 player 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "Intel_StoryLingerActors" ;2 variable args
            cmp_gt ::temp3 ::temp2 0 
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label0
            ; line 1963
            cast ::temp1 player 
            callstatic storageUtil IntListCount ::temp2 ::temp1 "Intel_FakeEncounterNPCs" ;2 variable args
            cmp_gt ::temp3 ::temp2 0 
            assign ::temp3 ::temp3 
          _label0:
            return ::temp3 
          .endCode
        .endFunction ;HasLingerNPCs
        .function StartStoryLinger
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param npc actor
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local ::temp1 form
            .local ::temp2 form
            .local ::temp3 Int
            .local ::temp4 Bool
            .local ::temp5 Float
          .endLocalTable
          .code
            ; line 1967
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1968
            cast ::temp1 player 
            cast ::temp2 npc 
            callstatic storageUtil FormListFind ::temp3 ::temp1 "Intel_StoryLingerActors" ::temp2 ;3 variable args
            cmp_lt ::temp4 ::temp3 0 
            jmpf ::temp4 _label0
            ; line 1969
            cast ::temp2 player 
            cast ::temp1 npc 
            callstatic storageUtil FormListAdd ::temp3 ::temp2 "Intel_StoryLingerActors" ::temp1 True ;4 variable args
            jmp _label0
            ; line 1971
          _label0:
            cast ::temp1 npc 
            callstatic utility GetCurrentRealTime ::temp5 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp5 ::temp1 "Intel_StoryLingerStart" ::temp5 ;3 variable args
          .endCode
        .endFunction ;StartStoryLinger
        .function FinishArrivalWithLinger
           ; function type 0
          .userFlags 0 ;none
          .docString "Shared arrival pattern: clear slot, cleanup dispatch, sandbox near target, start linger tracking.
     Caller MUST save arrivedNPC from ActiveStoryNPC BEFORE calling (CleanupStoryDispatch clears it)."
          .return None
          .paramTable
            .param arrivedNPC actor
            .param lingerTarget objectReference
          .endParamTable
          .localTable
            .local slot Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local ::nonevar None
            .local sandboxRef objectReference
            .local ::temp2 objectReference
            .local ::temp3 actor
            .local ::temp4 keyword
            .local ::temp5 package
            .local ::temp6 Float
          .endLocalTable
          .code
            ; line 1977
            callmethod FindSlotByAgent ::Core_var ::temp0 arrivedNPC ;1 variable args
            assign slot ::temp0 
            ; line 1978
            comp_gte ::temp1 slot 0 
            jmpf ::temp1 _label0
            ; line 1979
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label0
            ; line 1981
          _label0:
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 1987
            cast ::temp2 arrivedNPC 
            assign sandboxRef ::temp2 
            ; line 1988
            cast ::temp2 None 
            cmp_eq ::temp1 lingerTarget ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            callstatic game GetPlayer ::temp3 ;0 variable args
            cast ::temp2 ::temp3 
            cmp_eq ::temp1 lingerTarget ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 1989
            assign sandboxRef lingerTarget 
            jmp _label2
            ; line 1991
          _label2:
            cast ::temp2 arrivedNPC 
            propget IntelEngine_TravelTarget ::Core_var ::temp4 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp2 sandboxRef ::temp4 ;3 variable args
            ; line 1992
            propget SandboxNearPlayerPackage ::Core_var ::temp5 
            propget PRIORITY_SANDBOX ::Core_var ::temp0 
            callstatic actorUtil AddPackageOverride ::nonevar arrivedNPC ::temp5 ::temp0 1 ;4 variable args
            ; line 1993
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 1994
            callmethod EvaluatePackage arrivedNPC ::nonevar ;0 variable args
            ; line 1996
            callmethod EnsureBuildingAccess ::Core_var ::nonevar arrivedNPC ;1 variable args
            ; line 1997
            callmethod StartStoryLinger self ::nonevar arrivedNPC ;1 variable args
            ; line 2000
            propget MONITOR_INTERVAL self ::temp6 
            callmethod RegisterForSingleUpdate self ::nonevar ::temp6 ;1 variable args
          .endCode
        .endFunction ;FinishArrivalWithLinger
        .function CheckStoryLingerCleanup
           ; function type 0
          .userFlags 0 ;none
          .docString "Remove sandbox from story NPCs when player walks away or timeout.
    Uses Core.ShouldReleaseLinger — single source of truth for release decision.
    Stores Actor refs directly via FormList — no FormID round-trip."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local count Int
            .local ::temp1 form
            .local ::temp2 Int
            .local ::temp3 Bool
            .local i Int
            .local npc actor
            .local closeEnough Bool
            .local ::temp4 objectReference
            .local ::temp5 Float
            .local ::temp6 Float
            .local ::temp7 cell
            .local ::temp8 cell
            .local ::nonevar None
            .local ::temp9 package
            .local ::temp10 String
            .local pendingNarration String
            .local dist Float
            .local ::temp11 objectReference
            .local lingerStart Float
            .local elapsed Float
            .local timedOut Bool
            .local shouldRelease Bool
          .endLocalTable
          .code
            ; line 2007
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 2008
            cast ::temp1 player 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "Intel_StoryLingerActors" ;2 variable args
            assign count ::temp2 
            ; line 2009
            cmp_eq ::temp3 count 0 
            jmpf ::temp3 _label0
            ; line 2010
            return None 
            jmp _label0
            ; line 2013
          _label0:
            isub ::temp2 count 1 
            assign i ::temp2 
            ; line 2014
          _label17:
            comp_gte ::temp3 i 0 
            jmpf ::temp3 _label1
            ; line 2015
            cast ::temp1 player 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "Intel_StoryLingerActors" i ;3 variable args
            cast ::temp0 ::temp1 
            assign npc ::temp0 
            ; line 2017
            cast ::temp0 None 
            cmp_eq ::temp3 npc ::temp0 
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label2
            callmethod IsDead npc ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label2:
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label3
            callmethod IsDisabled npc ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label3:
            jmpf ::temp3 _label4
            ; line 2020
            cast ::temp0 None 
            cmp_eq ::temp3 npc ::temp0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label5
            ; line 2021
            cast ::temp1 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp1 "Intel_RescueNarration" ;2 variable args
            jmp _label5
            ; line 2023
          _label5:
            cast ::temp1 player 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_StoryLingerActors" i ;3 variable args
            jmp _label6
            ; line 2027
          _label4:
            cast ::temp1 npc 
            callstatic storageUtil GetIntValue ::temp2 ::temp1 "Intel_MeetingLingerApproaching" 0 ;3 variable args
            cmp_eq ::temp3 ::temp2 1 
            jmpf ::temp3 _label7
            ; line 2028
            assign closeEnough False 
            ; line 2029
            callmethod Is3DLoaded npc ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label8
            callmethod Is3DLoaded player ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label8:
            jmpf ::temp3 _label9
            ; line 2030
            cast ::temp4 player 
            callmethod GetDistance npc ::temp5 ::temp4 ;1 variable args
            propget LINGER_APPROACH_DISTANCE ::Core_var ::temp6 
            cmp_lte ::temp3 ::temp5 ::temp6 
            assign closeEnough ::temp3 
            jmp _label10
            ; line 2031
          _label9:
            callmethod GetParentCell npc ::temp7 ;0 variable args
            callmethod GetParentCell player ::temp8 ;0 variable args
            cmp_eq ::temp3 ::temp7 ::temp8 
            jmpf ::temp3 _label10
            ; line 2032
            assign closeEnough True 
            jmp _label10
            ; line 2034
          _label10:
            jmpf closeEnough _label11
            ; line 2036
            propget SandboxNearPlayerPackage ::Core_var ::temp9 
            propget PRIORITY_TRAVEL ::Core_var ::temp2 
            callstatic actorUtil AddPackageOverride ::nonevar npc ::temp9 ::temp2 1 ;4 variable args
            ; line 2037
            propget TravelPackage_Walk ::Core_var ::temp9 
            callstatic actorUtil RemovePackageOverride ::temp3 npc ::temp9 ;2 variable args
            ; line 2038
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 2039
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 2040
            cast ::temp1 npc 
            callstatic storageUtil UnsetIntValue ::temp3 ::temp1 "Intel_MeetingLingerApproaching" ;2 variable args
            ; line 2041
            callmethod GetDisplayName npc ::temp10 ;0 variable args
            strcat ::temp10 "Story [quest/rescue]: " ::temp10 
            strcat ::temp10 ::temp10 " reached player, sandboxing" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            jmp _label11
          _label11:
            jmp _label7
            ; line 2046
          _label7:
            cast ::temp1 npc 
            callstatic storageUtil GetStringValue ::temp10 ::temp1 "Intel_RescueNarration" "" ;3 variable args
            assign pendingNarration ::temp10 
            ; line 2047
            cmp_eq ::temp3 pendingNarration "" 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label12
            ; line 2048
            cast ::temp4 npc 
            cast ::temp11 player 
            callstatic intelEngine GetDistance3D ::temp6 ::temp4 ::temp11 ;2 variable args
            assign dist ::temp6 
            ; line 2049
            cmp_lt ::temp3 dist 400.0 
            jmpf ::temp3 _label13
            ; line 2050
            cast ::temp11 player 
            callmethod SetLookAt npc ::nonevar ::temp11 False ;2 variable args
            ; line 2051
            callmethod SendTaskNarration ::Core_var ::nonevar npc pendingNarration player ;3 variable args
            ; line 2052
            cast ::temp1 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp1 "Intel_RescueNarration" ;2 variable args
            ; line 2053
            callmethod GetDisplayName npc ::temp10 ;0 variable args
            strcat ::temp10 "Story [quest/rescue]: " ::temp10 
            strcat ::temp10 ::temp10 " reached player, narrating" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            jmp _label13
          _label13:
            jmp _label12
            ; line 2058
          _label12:
            cast ::temp1 npc 
            callstatic storageUtil GetFloatValue ::temp6 ::temp1 "Intel_StoryLingerStart" 0.0 ;3 variable args
            assign lingerStart ::temp6 
            ; line 2059
            callstatic utility GetCurrentRealTime ::temp6 ;0 variable args
            fsub ::temp6 ::temp6 lingerStart 
            assign elapsed ::temp6 
            ; line 2060
            cmp_gt ::temp3 lingerStart 0.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label14
            propget LINGER_TIMEOUT_SECONDS self ::temp6 
            cmp_gt ::temp3 elapsed ::temp6 
            assign ::temp3 ::temp3 
          _label14:
            assign timedOut ::temp3 
            ; line 2063
            cmp_gt ::temp3 elapsed 30.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label15
            callmethod ShouldReleaseLinger ::Core_var ::temp3 npc ;1 variable args
            assign ::temp3 ::temp3 
          _label15:
            assign shouldRelease ::temp3 
            ; line 2065
            assign ::temp3 timedOut 
            jmpt ::temp3 _label16
            assign ::temp3 shouldRelease 
          _label16:
            jmpf ::temp3 _label6
            ; line 2067
            cast ::temp1 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp1 "Intel_RescueNarration" ;2 variable args
            ; line 2071
            callmethod ReleaseLinger ::Core_var ::nonevar npc ;1 variable args
            ; line 2072
            cast ::temp1 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp1 "Intel_StoryLingerStart" ;2 variable args
            ; line 2073
            cast ::temp1 player 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_StoryLingerActors" i ;3 variable args
            jmp _label6
            ; line 2076
          _label6:
            isub ::temp2 i 1 
            assign i ::temp2 
            jmp _label17
          _label1
          .endCode
        .endFunction ;CheckStoryLingerCleanup
        .function CheckRescuedNPCDeaths
           ; function type 0
          .userFlags 0 ;none
          .docString "Monitor recently rescued NPCs for death — persists beyond linger release.
    Uses GetKiller() for attribution and nearby friendly NPCs for witness detection.
    If player killed with no witnesses: suspect language. With witnesses or other killer: factual."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local count Int
            .local ::temp1 form
            .local ::temp2 Int
            .local ::temp3 Bool
            .local i Int
            .local npc actor
            .local rescueGiver actor
            .local ::temp4 form
            .local victimName String
            .local ::temp5 String
            .local killer actor
            .local hasWitness Bool
            .local nearbyNPCs actor[]
            .local ::temp6 objectReference
            .local ::temp7 keyword
            .local ::temp8 actor[]
            .local j Int
            .local witness actor
            .local rPlayerName String
            .local ::nonevar None
            .local killerName String
            .local ::temp9 String
            .local rescueTime Float
            .local ::temp10 Float
          .endLocalTable
          .code
            ; line 2084
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 2085
            cast ::temp1 player 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "Intel_RecentlyRescuedNPCs" ;2 variable args
            assign count ::temp2 
            ; line 2086
            cmp_eq ::temp3 count 0 
            jmpf ::temp3 _label0
            ; line 2087
            return None 
            jmp _label0
            ; line 2090
          _label0:
            isub ::temp2 count 1 
            assign i ::temp2 
            ; line 2091
          _label19:
            comp_gte ::temp3 i 0 
            jmpf ::temp3 _label1
            ; line 2092
            cast ::temp1 player 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "Intel_RecentlyRescuedNPCs" i ;3 variable args
            cast ::temp0 ::temp1 
            assign npc ::temp0 
            ; line 2093
            cast ::temp0 None 
            cmp_eq ::temp3 npc ::temp0 
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label2
            callmethod IsDisabled npc ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label2:
            jmpf ::temp3 _label3
            ; line 2095
            cast ::temp0 None 
            cmp_eq ::temp3 npc ::temp0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label4
            ; line 2096
            cast ::temp1 npc 
            callstatic storageUtil UnsetFormValue ::temp3 ::temp1 "Intel_RescueQuestGiver" ;2 variable args
            ; line 2097
            cast ::temp1 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp1 "Intel_RescuePlayerName" ;2 variable args
            ; line 2098
            cast ::temp1 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp1 "Intel_RescueTime" ;2 variable args
            jmp _label4
            ; line 2100
          _label4:
            cast ::temp1 player 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_RecentlyRescuedNPCs" i ;3 variable args
            jmp _label5
            ; line 2101
          _label3:
            callmethod IsDead npc ::temp3 ;0 variable args
            jmpf ::temp3 _label6
            ; line 2102
            cast ::temp1 npc 
            cast ::temp4 None 
            callstatic storageUtil GetFormValue ::temp4 ::temp1 "Intel_RescueQuestGiver" ::temp4 ;3 variable args
            cast ::temp0 ::temp4 
            assign rescueGiver ::temp0 
            ; line 2103
            cast ::temp0 None 
            cmp_eq ::temp3 rescueGiver ::temp0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label7
            ; line 2104
            callmethod GetDisplayName npc ::temp5 ;0 variable args
            assign victimName ::temp5 
            ; line 2105
            callmethod GetKiller npc ::temp0 ;0 variable args
            assign killer ::temp0 
            ; line 2107
            cmp_eq ::temp3 killer player 
            jmpf ::temp3 _label8
            ; line 2109
            assign hasWitness False 
            ; line 2110
            cast ::temp6 npc 
            cast ::temp7 None 
            callstatic miscUtil ScanCellNPCs ::temp8 ::temp6 3000.0 ::temp7 True ;4 variable args
            assign nearbyNPCs ::temp8 
            ; line 2111
            assign j 0 
            ; line 2112
          _label13:
            array_length ::temp2 nearbyNPCs 
            cmp_lt ::temp3 j ::temp2 
            jmpf ::temp3 _label9
            ; line 2113
            array_getlement ::temp0 nearbyNPCs j 
            assign witness ::temp0 
            ; line 2114
            cmp_eq ::temp3 witness player 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label10
            cmp_eq ::temp3 witness npc 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
          _label10:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label11
            callmethod IsHostileToActor witness ::temp3 player ;1 variable args
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
          _label11:
            jmpf ::temp3 _label12
            ; line 2115
            assign hasWitness True 
            ; line 2116
            array_length ::temp2 nearbyNPCs 
            assign j ::temp2 
            jmp _label12
            ; line 2118
          _label12:
            iadd ::temp2 j 1 
            assign j ::temp2 
            jmp _label13
            ; line 2121
          _label9:
            jmpf hasWitness _label14
            ; line 2123
            cast ::temp4 npc 
            callstatic storageUtil GetStringValue ::temp5 ::temp4 "Intel_RescuePlayerName" "the rescuer" ;3 variable args
            assign rPlayerName ::temp5 
            ; line 2124
            strcat ::temp5 "learned that " victimName 
            strcat ::temp5 ::temp5 " was killed by " 
            strcat ::temp5 ::temp5 rPlayerName 
            strcat ::temp5 ::temp5 " shortly after being rescued" 
            callmethod InjectFact ::Core_var ::nonevar rescueGiver ::temp5 ;2 variable args
            jmp _label15
            ; line 2127
          _label14:
            strcat ::temp5 "heard that " victimName 
            strcat ::temp5 ::temp5 " died under suspicious circumstances shortly after being rescued" 
            callmethod InjectFact ::Core_var ::nonevar rescueGiver ::temp5 ;2 variable args
          _label15:
            jmp _label16
            ; line 2129
          _label8:
            cast ::temp0 None 
            cmp_eq ::temp3 killer ::temp0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label17
            ; line 2131
            callmethod GetDisplayName killer ::temp5 ;0 variable args
            assign killerName ::temp5 
            ; line 2132
            strcat ::temp5 "learned that " victimName 
            strcat ::temp5 ::temp5 " was killed by " 
            strcat ::temp5 ::temp5 killerName 
            strcat ::temp5 ::temp5 " shortly after being rescued" 
            callmethod InjectFact ::Core_var ::nonevar rescueGiver ::temp5 ;2 variable args
            jmp _label16
            ; line 2135
          _label17:
            strcat ::temp5 "learned that " victimName 
            strcat ::temp5 ::temp5 " died shortly after being rescued" 
            callmethod InjectFact ::Core_var ::nonevar rescueGiver ::temp5 ;2 variable args
            ; line 2137
          _label16:
            strcat ::temp5 "Story [quest/rescue]: " victimName 
            strcat ::temp5 ::temp5 " killed post-rescue (killer=" 
            cast ::temp9 killer 
            strcat ::temp9 ::temp5 ::temp9 
            strcat ::temp9 ::temp9 ") — fact injected to " 
            callmethod GetDisplayName rescueGiver ::temp5 ;0 variable args
            strcat ::temp5 ::temp9 ::temp5 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            jmp _label7
            ; line 2140
          _label7:
            cast ::temp4 npc 
            callstatic storageUtil UnsetFormValue ::temp3 ::temp4 "Intel_RescueQuestGiver" ;2 variable args
            ; line 2141
            cast ::temp4 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp4 "Intel_RescuePlayerName" ;2 variable args
            ; line 2142
            cast ::temp4 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp4 "Intel_RescueTime" ;2 variable args
            ; line 2143
            cast ::temp4 player 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp4 "Intel_RecentlyRescuedNPCs" i ;3 variable args
            jmp _label5
            ; line 2146
          _label6:
            cast ::temp4 npc 
            callstatic storageUtil GetFloatValue ::temp10 ::temp4 "Intel_RescueTime" 0.0 ;3 variable args
            assign rescueTime ::temp10 
            ; line 2147
            cmp_gt ::temp3 rescueTime 0.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label18
            callstatic utility GetCurrentGameTime ::temp10 ;0 variable args
            fsub ::temp10 ::temp10 rescueTime 
            cmp_gt ::temp3 ::temp10 1.0 
            assign ::temp3 ::temp3 
          _label18:
            jmpf ::temp3 _label5
            ; line 2148
            cast ::temp4 npc 
            callstatic storageUtil UnsetFormValue ::temp3 ::temp4 "Intel_RescueQuestGiver" ;2 variable args
            ; line 2149
            cast ::temp4 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp4 "Intel_RescuePlayerName" ;2 variable args
            ; line 2150
            cast ::temp4 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp4 "Intel_RescueTime" ;2 variable args
            ; line 2151
            cast ::temp4 player 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp4 "Intel_RecentlyRescuedNPCs" i ;3 variable args
            jmp _label5
            ; line 2154
          _label5:
            isub ::temp2 i 1 
            assign i ::temp2 
            jmp _label19
          _label1
          .endCode
        .endFunction ;CheckRescuedNPCDeaths
        .function TriggerRoadEncounterGreeting
           ; function type 0
          .userFlags 0 ;none
          .docString "NPC noticed the player nearby -- greet and linger. Sandbox near player until
    player walks away (>1500u) or max linger time (5 min real) exceeded.
    Destination restored by CheckRoadEncounterProximity."
          .return None
          .paramTable
            .param npc actor
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local narration String
            .local ::temp1 form
            .local ::temp2 String
            .local ::temp3 package
            .local ::temp4 Bool
            .local ::nonevar None
            .local ::temp5 objectReference
            .local ::temp6 objectReference
            .local ::temp7 keyword
            .local ::temp8 Int
            .local ::temp9 Float
          .endLocalTable
          .code
            ; line 2162
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 2163
            cast ::temp1 npc 
            callstatic storageUtil GetStringValue ::temp2 ::temp1 "Intel_FakeEncounterNarration" "" ;3 variable args
            assign narration ::temp2 
            ; line 2166
            propget TravelPackage_Walk ::Core_var ::temp3 
            callstatic actorUtil RemovePackageOverride ::temp4 npc ::temp3 ;2 variable args
            ; line 2167
            cast ::temp5 npc 
            cast ::temp6 player 
            propget IntelEngine_TravelTarget ::Core_var ::temp7 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp5 ::temp6 ::temp7 ;3 variable args
            ; line 2168
            propget SandboxNearPlayerPackage ::Core_var ::temp3 
            propget PRIORITY_SANDBOX ::Core_var ::temp8 
            callstatic actorUtil AddPackageOverride ::nonevar npc ::temp3 ::temp8 1 ;4 variable args
            ; line 2169
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 2172
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 2173
            cast ::temp6 player 
            callmethod SetLookAt npc ::nonevar ::temp6 False ;2 variable args
            ; line 2174
            callmethod SendTaskNarration ::Core_var ::nonevar npc narration player ;3 variable args
            ; line 2177
            cast ::temp1 npc 
            callstatic storageUtil SetIntValue ::temp8 ::temp1 "Intel_FakeEncounterInteracted" 1 ;3 variable args
            ; line 2178
            cast ::temp1 npc 
            callstatic utility GetCurrentRealTime ::temp9 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp9 ::temp1 "Intel_FakeEncounterGreetTime" ::temp9 ;3 variable args
            ; line 2180
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 "Story [encounter]: " ::temp2 
            strcat ::temp2 ::temp2 " lingering near player" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
          .endCode
        .endFunction ;TriggerRoadEncounterGreeting
        .function ClearRoadEncounterTravelState
           ; function type 0
          .userFlags 0 ;none
          .docString "Shared cleanup: remove all encounter packages, linked ref, and destination marker."
          .return None
          .paramTable
            .param npc actor
          .endParamTable
          .localTable
            .local ::temp0 package
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 objectReference
            .local ::temp3 objectReference
            .local ::temp4 keyword
            .local ::temp5 form
          .endLocalTable
          .code
            ; line 2185
            propget TravelPackage_Walk ::Core_var ::temp0 
            callstatic actorUtil RemovePackageOverride ::temp1 npc ::temp0 ;2 variable args
            ; line 2186
            propget SandboxNearPlayerPackage ::Core_var ::temp0 
            callstatic actorUtil RemovePackageOverride ::temp1 npc ::temp0 ;2 variable args
            ; line 2187
            cast ::temp2 npc 
            cast ::temp3 None 
            propget IntelEngine_TravelTarget ::Core_var ::temp4 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp2 ::temp3 ::temp4 ;3 variable args
            ; line 2188
            cast ::temp5 npc 
            callstatic storageUtil UnsetFormValue ::temp1 ::temp5 "Intel_FakeEncounterDest" ;2 variable args
          .endCode
        .endFunction ;ClearRoadEncounterTravelState
        .function CleanupRoadEncounterTravel
           ; function type 0
          .userFlags 0 ;none
          .docString "NPC reached their destination -- remove travel overrides, let them sandbox."
          .return None
          .paramTable
            .param npc actor
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 2193
            callmethod ClearRoadEncounterTravelState self ::nonevar npc ;1 variable args
            ; line 2194
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 2195
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Story: " ::temp0 
            strcat ::temp0 ::temp0 " reached destination" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
          .endCode
        .endFunction ;CleanupRoadEncounterTravel
        .function CleanupStrandedEncounters
           ; function type 0
          .userFlags 0 ;none
          .docString "Safety net: return road encounter NPCs to editor location after >1 game day."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local count Int
            .local ::temp1 form
            .local ::temp2 Int
            .local ::temp3 Bool
            .local currentTime Float
            .local ::temp4 Float
            .local i Int
            .local formId Int
            .local npc actor
            .local encounterTime Float
            .local ::nonevar None
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 2201
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 2202
            cast ::temp1 player 
            callstatic storageUtil IntListCount ::temp2 ::temp1 "Intel_FakeEncounterNPCs" ;2 variable args
            assign count ::temp2 
            ; line 2203
            cmp_eq ::temp3 count 0 
            jmpf ::temp3 _label0
            ; line 2204
            return None 
            jmp _label0
            ; line 2206
          _label0:
            callstatic utility GetCurrentGameTime ::temp4 ;0 variable args
            assign currentTime ::temp4 
            ; line 2208
            isub ::temp2 count 1 
            assign i ::temp2 
            ; line 2209
          _label6:
            comp_gte ::temp3 i 0 
            jmpf ::temp3 _label1
            ; line 2210
            cast ::temp1 player 
            callstatic storageUtil IntListGet ::temp2 ::temp1 "Intel_FakeEncounterNPCs" i ;3 variable args
            assign formId ::temp2 
            ; line 2211
            callstatic game GetForm ::temp1 formId ;1 variable args
            cast ::temp0 ::temp1 
            assign npc ::temp0 
            ; line 2212
            cast ::temp0 None 
            cmp_eq ::temp3 npc ::temp0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label2
            ; line 2213
            cast ::temp1 npc 
            callstatic storageUtil GetFloatValue ::temp4 ::temp1 "Intel_FakeEncounterTime" 0.0 ;3 variable args
            assign encounterTime ::temp4 
            ; line 2214
            cmp_gt ::temp3 encounterTime 0.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label3
            fsub ::temp4 currentTime encounterTime 
            cmp_gt ::temp3 ::temp4 1.0 
            assign ::temp3 ::temp3 
          _label3:
            jmpf ::temp3 _label4
            ; line 2216
            callmethod RemoveAllPackages ::Core_var ::nonevar npc False ;2 variable args
            ; line 2217
            callmethod ClearRoadEncounterTravelState self ::nonevar npc ;1 variable args
            ; line 2218
            cast ::temp1 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp1 "Intel_FakeEncounterNarration" ;2 variable args
            ; line 2219
            cast ::temp1 npc 
            callstatic storageUtil UnsetIntValue ::temp3 ::temp1 "Intel_FakeEncounterInteracted" ;2 variable args
            ; line 2220
            cast ::temp1 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp1 "Intel_FakeEncounterGreetTime" ;2 variable args
            ; line 2221
            callmethod MoveToMyEditorLocation npc ::nonevar ;0 variable args
            ; line 2222
            cast ::temp1 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp1 "Intel_FakeEncounterTime" ;2 variable args
            ; line 2223
            cast ::temp1 player 
            callstatic storageUtil IntListRemoveAt ::temp3 ::temp1 "Intel_FakeEncounterNPCs" i ;3 variable args
            ; line 2224
            callmethod GetDisplayName npc ::temp5 ;0 variable args
            strcat ::temp5 "[IntelEngine] StoryEngine: Returned road encounter NPC " ::temp5 
            callstatic debug Trace ::nonevar ::temp5 0 ;2 variable args
            jmp _label4
          _label4:
            jmp _label5
            ; line 2228
          _label2:
            cast ::temp1 player 
            callstatic storageUtil IntListRemoveAt ::temp3 ::temp1 "Intel_FakeEncounterNPCs" i ;3 variable args
            ; line 2230
          _label5:
            isub ::temp2 i 1 
            assign i ::temp2 
            jmp _label6
          _label1
          .endCode
        .endFunction ;CleanupStrandedEncounters
        .function CheckStoryNPCArrival
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local deadSlot Int
            .local ::temp2 Int
            .local ::nonevar None
            .local ::temp3 String
            .local corruptSlot Int
            .local activeSlot Int
            .local player actor
            .local sneakStart Float
            .local ::temp4 form
            .local ::temp5 Float
            .local ::temp6 Float
            .local ::temp7 String
            .local ::temp8 objectReference
            .local slot Int
            .local sneakDist Float
            .local sneakPhase Int
            .local arrivalTarget actor
            .local pCell cell
            .local ::temp9 cell
            .local dist Float
            .local targetCell cell
            .local npcCell2 cell
            .local ::mangled_slot_0 Int
            .local offPCell cell
            .local offscreenStatus Int
            .local stuckStatus Int
            .local taskStart Float
          .endLocalTable
          .code
            ; line 2239
            cast ::temp0 None 
            cmp_eq ::temp1 ::ActiveStoryNPC_var ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            callmethod IsDead ::ActiveStoryNPC_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label0:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            callmethod IsDisabled ::ActiveStoryNPC_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 2240
            cast ::temp0 None 
            cmp_eq ::temp1 ::ActiveStoryNPC_var ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label3
            ; line 2241
            callmethod FindSlotByAgent ::Core_var ::temp2 ::ActiveStoryNPC_var ;1 variable args
            assign deadSlot ::temp2 
            ; line 2242
            comp_gte ::temp1 deadSlot 0 
            jmpf ::temp1 _label4
            ; line 2243
            callmethod ClearSlot ::Core_var ::nonevar deadSlot True False ;3 variable args
            jmp _label4
            ; line 2245
          _label4:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            jmp _label3
            ; line 2247
          _label3:
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 2248
            return None 
            jmp _label2
            ; line 2254
          _label2:
            cmp_eq ::temp1 ::ActiveStoryType_var "" 
            jmpf ::temp1 _label5
            ; line 2255
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story: corrupt state detected (IsActive but no type) for " ::temp3 
            strcat ::temp3 ::temp3 " - cleaning up" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2256
            callmethod FindSlotByAgent ::Core_var ::temp2 ::ActiveStoryNPC_var ;1 variable args
            assign corruptSlot ::temp2 
            ; line 2257
            comp_gte ::temp1 corruptSlot 0 
            jmpf ::temp1 _label6
            ; line 2258
            callmethod ClearSlot ::Core_var ::nonevar corruptSlot True False ;3 variable args
            jmp _label6
            ; line 2260
          _label6:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 2261
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 2262
            return None 
            jmp _label5
            ; line 2267
          _label5:
            callmethod FindSlotByAgent ::Core_var ::temp2 ::ActiveStoryNPC_var ;1 variable args
            assign activeSlot ::temp2 
            ; line 2268
            cmp_lt ::temp1 activeSlot 0 
            jmpf ::temp1 _label7
            ; line 2269
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story: orphaned dispatch detected for " ::temp3 
            strcat ::temp3 ::temp3 " [" 
            strcat ::temp3 ::temp3 ::ActiveStoryType_var 
            strcat ::temp3 ::temp3 "] - cleaning up" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2270
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 2271
            return None 
            jmp _label7
            ; line 2274
          _label7:
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 2277
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush_combat" 
            jmpf ::temp1 _label8
            ; line 2278
            callmethod CheckAmbushCombat self ::nonevar ;0 variable args
            ; line 2279
            return None 
            jmp _label8
            ; line 2283
          _label8:
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label9
            cmp_eq ::temp1 ::ActiveStoryType_var "stalker" 
            assign ::temp1 ::temp1 
          _label9:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label10
            callmethod Is3DLoaded ::ActiveStoryNPC_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label10:
            jmpf ::temp1 _label11
            ; line 2285
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp5 ::temp4 "Intel_SneakStartTime" 0.0 ;3 variable args
            assign sneakStart ::temp5 
            ; line 2286
            cmp_gt ::temp1 sneakStart 0.0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label12
            callstatic utility GetCurrentRealTime ::temp5 ;0 variable args
            fsub ::temp5 ::temp5 sneakStart 
            propget SNEAK_TIMEOUT_SECONDS self ::temp6 
            cmp_gt ::temp1 ::temp5 ::temp6 
            assign ::temp1 ::temp1 
          _label12:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label13
            callmethod ShouldReleaseLinger ::Core_var ::temp1 ::ActiveStoryNPC_var ;1 variable args
            assign ::temp1 ::temp1 
          _label13:
            jmpf ::temp1 _label14
            ; line 2287
            strcat ::temp3 "Story [" ::ActiveStoryType_var 
            strcat ::temp3 ::temp3 "]: " 
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp7 ;0 variable args
            strcat ::temp7 ::temp3 ::temp7 
            strcat ::temp7 ::temp7 " timed out after " 
            propget SNEAK_TIMEOUT_SECONDS self ::temp6 
            cast ::temp2 ::temp6 
            cast ::temp3 ::temp2 
            strcat ::temp3 ::temp7 ::temp3 
            strcat ::temp3 ::temp3 "s - abandoning" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2288
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story: " ::temp3 
            strcat ::temp3 ::temp3 " gave up" 
            callmethod NotifyPlayer ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2289
            callmethod IsSneaking ::ActiveStoryNPC_var ::temp1 ;0 variable args
            jmpf ::temp1 _label15
            ; line 2290
            callmethod StartSneaking ::ActiveStoryNPC_var ::nonevar ;0 variable args
            jmp _label15
            ; line 2292
          _label15:
            cast ::temp8 ::ActiveStoryNPC_var 
            callstatic debug SendAnimationEvent ::nonevar ::temp8 "sneakStop" ;2 variable args
            ; line 2293
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp4 "Intel_SneakStartTime" ;2 variable args
            ; line 2294
            callmethod FindSlotByAgent ::Core_var ::temp2 ::ActiveStoryNPC_var ;1 variable args
            assign slot ::temp2 
            ; line 2295
            comp_gte ::temp1 slot 0 
            jmpf ::temp1 _label16
            ; line 2296
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label16
            ; line 2298
          _label16:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 2299
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 2300
            return None 
            jmp _label14
            ; line 2303
          _label14:
            cast ::temp8 player 
            callmethod GetDistance ::ActiveStoryNPC_var ::temp6 ::temp8 ;1 variable args
            assign sneakDist ::temp6 
            ; line 2304
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil GetIntValue ::temp2 ::temp4 "Intel_SneakPhase" 0 ;3 variable args
            assign sneakPhase ::temp2 
            ; line 2307
            cmp_eq ::temp1 ::ActiveStoryType_var "stalker" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label17
            cmp_eq ::temp1 sneakPhase 0 
            assign ::temp1 ::temp1 
          _label17:
            jmpf ::temp1 _label18
            ; line 2308
            callmethod ReapplyTravelPackage self ::nonevar ::ActiveStoryNPC_var ;1 variable args
            ; line 2309
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil SetIntValue ::temp2 ::temp4 "Intel_SneakPhase" 1 ;3 variable args
            ; line 2310
            assign sneakPhase 1 
            ; line 2311
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story [stalker]: " ::temp3 
            strcat ::temp3 ::temp3 " sneak package applied at " 
            cast ::temp7 sneakDist 
            strcat ::temp7 ::temp3 ::temp7 
            strcat ::temp7 ::temp7 "u" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            jmp _label18
            ; line 2315
          _label18:
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label19
            cmp_eq ::temp1 sneakPhase 0 
            assign ::temp1 ::temp1 
          _label19:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label20
            propget SNEAK_APPROACH_DISTANCE self ::temp6 
            cmp_lte ::temp1 sneakDist ::temp6 
            assign ::temp1 ::temp1 
          _label20:
            jmpf ::temp1 _label21
            ; line 2316
            propget AMBUSH_CONFRONT_DISTANCE self ::temp6 
            cmp_gt ::temp1 sneakDist ::temp6 
            jmpf ::temp1 _label22
            ; line 2317
            callmethod StartSneaking ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 2318
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil SetIntValue ::temp2 ::temp4 "Intel_SneakPhase" 1 ;3 variable args
            ; line 2319
            assign sneakPhase 1 
            ; line 2320
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp7 ;0 variable args
            strcat ::temp7 "Story [ambush]: " ::temp7 
            strcat ::temp7 ::temp7 " entered sneak at " 
            cast ::temp3 sneakDist 
            strcat ::temp3 ::temp7 ::temp3 
            strcat ::temp3 ::temp3 "u" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label23
            ; line 2323
          _label22:
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story [ambush]: " ::temp3 
            strcat ::temp3 ::temp3 " overshot sneak at " 
            cast ::temp7 sneakDist 
            strcat ::temp7 ::temp3 ::temp7 
            strcat ::temp7 ::temp7 "u" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            ; line 2324
            callmethod OnAmbushConfront self ::nonevar ;0 variable args
            ; line 2325
            return None 
          _label23:
            jmp _label21
            ; line 2330
          _label21:
            comp_gte ::temp1 sneakPhase 1 
            jmpf ::temp1 _label24
            ; line 2331
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush" 
            jmpf ::temp1 _label25
            ; line 2333
            propget AMBUSH_CONFRONT_DISTANCE self ::temp6 
            cmp_lte ::temp1 sneakDist ::temp6 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label26
            cmp_gt ::temp1 sneakDist 0.0 
            assign ::temp1 ::temp1 
          _label26:
            jmpf ::temp1 _label27
            ; line 2334
            callmethod OnAmbushConfront self ::nonevar ;0 variable args
            ; line 2335
            return None 
            jmp _label27
            ; line 2337
          _label27:
            callmethod IsDetectedBy ::ActiveStoryNPC_var ::temp1 player ;1 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label28
            cmp_lte ::temp1 sneakDist 400.0 
            assign ::temp1 ::temp1 
          _label28:
            jmpf ::temp1 _label29
            ; line 2338
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp7 ;0 variable args
            strcat ::temp7 "Story [ambush]: " ::temp7 
            strcat ::temp7 ::temp7 " detected while sneaking at " 
            cast ::temp3 sneakDist 
            strcat ::temp3 ::temp7 ::temp3 
            strcat ::temp3 ::temp3 "u - confronting early" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2339
            callmethod OnAmbushConfront self ::nonevar ;0 variable args
            ; line 2340
            return None 
            jmp _label29
          _label29:
            jmp _label30
            ; line 2344
          _label25:
            callmethod IsDetectedBy ::ActiveStoryNPC_var ::temp1 player ;1 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label31
            cmp_lte ::temp1 sneakDist 400.0 
            assign ::temp1 ::temp1 
          _label31:
            jmpf ::temp1 _label32
            ; line 2345
            callmethod OnStalkerDetected self ::nonevar ;0 variable args
            ; line 2346
            return None 
            jmp _label32
            ; line 2350
          _label32:
            cmp_eq ::temp1 sneakPhase 1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label33
            propget STALKER_KEEP_DISTANCE self ::temp6 
            cmp_lte ::temp1 sneakDist ::temp6 
            assign ::temp1 ::temp1 
          _label33:
            jmpf ::temp1 _label34
            ; line 2351
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 2352
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil SetIntValue ::temp2 ::temp4 "Intel_SneakPhase" 2 ;3 variable args
            ; line 2353
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story [stalker]: " ::temp3 
            strcat ::temp3 ::temp3 " holding at " 
            cast ::temp7 sneakDist 
            strcat ::temp7 ::temp3 ::temp7 
            strcat ::temp7 ::temp7 "u" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            jmp _label34
            ; line 2357
          _label34:
            cmp_eq ::temp1 sneakPhase 2 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label35
            propget STALKER_RESUME_DISTANCE self ::temp6 
            cmp_gt ::temp1 sneakDist ::temp6 
            assign ::temp1 ::temp1 
          _label35:
            jmpf ::temp1 _label30
            ; line 2358
            callmethod ReapplyTravelPackage self ::nonevar ::ActiveStoryNPC_var ;1 variable args
            ; line 2359
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil SetIntValue ::temp2 ::temp4 "Intel_SneakPhase" 1 ;3 variable args
            ; line 2360
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp7 ;0 variable args
            strcat ::temp7 "Story [stalker]: " ::temp7 
            strcat ::temp7 ::temp7 " resuming follow at " 
            cast ::temp3 sneakDist 
            strcat ::temp3 ::temp7 ::temp3 
            strcat ::temp3 ::temp3 "u" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label30
            ; line 2365
          _label30:
            return None 
            jmp _label24
          _label24:
            jmp _label11
            ; line 2371
          _label11:
            cmp_eq ::temp1 ::ActiveStoryType_var "quest_guide" 
            jmpf ::temp1 _label36
            ; line 2373
            return None 
            jmp _label36
            ; line 2377
          _label36:
            assign arrivalTarget player 
            ; line 2378
            callmethod IsNPCToNPCType self ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label37
            cast ::temp0 None 
            cmp_eq ::temp1 ::ActiveSecondNPC_var ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label37:
            jmpf ::temp1 _label38
            ; line 2379
            assign arrivalTarget ::ActiveSecondNPC_var 
            jmp _label38
            ; line 2383
          _label38:
            cmp_eq ::temp1 arrivalTarget player 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label39
            callmethod IsInCombat player ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label39:
            jmpf ::temp1 _label40
            ; line 2384
            return None 
            jmp _label40
            ; line 2388
          _label40:
            cmp_eq ::temp1 arrivalTarget player 
            jmpf ::temp1 _label41
            ; line 2389
            callstatic intelEngine IsPlayerInBlockedLocation ::temp1 ;0 variable args
            jmpf ::temp1 _label42
            ; line 2390
            strcat ::temp3 "Story: cancelling " ::ActiveStoryType_var 
            strcat ::temp3 ::temp3 " for " 
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp7 ;0 variable args
            strcat ::temp7 ::temp3 ::temp7 
            strcat ::temp7 ::temp7 " -- player at blocked location" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            ; line 2391
            callmethod GetDisplayName player ::temp7 ;0 variable args
            strcat ::temp7 "gave up looking for " ::temp7 
            strcat ::temp7 ::temp7 " and turned back" 
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp7 player ;3 variable args
            ; line 2392
            callmethod AbortStoryTravel self ::nonevar "player at blocked location" ;1 variable args
            ; line 2393
            return None 
            jmp _label42
            ; line 2395
          _label42:
            callstatic intelEngine IsPlayerInWhitelistedLocation ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label43
            ; line 2396
            strcat ::temp7 "Story: cancelling " ::ActiveStoryType_var 
            strcat ::temp7 ::temp7 " for " 
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 ::temp7 ::temp3 
            strcat ::temp3 ::temp3 " -- player not at whitelisted location" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2397
            callmethod GetDisplayName player ::temp3 ;0 variable args
            strcat ::temp3 "decided not to seek " ::temp3 
            strcat ::temp3 ::temp3 " at this location" 
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp3 player ;3 variable args
            ; line 2398
            callmethod AbortStoryTravel self ::nonevar "player not at whitelisted location" ;1 variable args
            ; line 2399
            return None 
            jmp _label43
          _label43:
            jmp _label41
            ; line 2405
          _label41:
            cmp_eq ::temp1 arrivalTarget player 
            jmpf ::temp1 _label44
            ; line 2406
            callmethod ShouldAbortForDangerZone self ::temp1 ::ActiveStoryNPC_var player ::ActiveStoryType_var "" ;4 variable args
            jmpf ::temp1 _label45
            ; line 2407
            return None 
            jmp _label45
            ; line 2409
          _label45:
            callmethod ShouldAbortForPlayerHome self ::temp1 ::ActiveStoryNPC_var player ::ActiveStoryType_var "" ;4 variable args
            jmpf ::temp1 _label46
            ; line 2410
            return None 
            jmp _label46
            ; line 2412
          _label46:
            callmethod ShouldAbortForHoldRestriction self ::temp1 ::ActiveStoryNPC_var player ::ActiveStoryType_var "" ;4 variable args
            jmpf ::temp1 _label47
            ; line 2413
            return None 
            jmp _label47
          _label47:
            jmp _label44
            ; line 2418
          _label44:
            cmp_eq ::temp1 arrivalTarget player 
            jmpf ::temp1 _label48
            ; line 2419
            callmethod GetParentCell player ::temp9 ;0 variable args
            assign pCell ::temp9 
            ; line 2420
            cast ::temp9 None 
            cmp_eq ::temp1 pCell ::temp9 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label49
            callmethod IsInterior pCell ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label49:
            jmpf ::temp1 _label50
            ; line 2421
            cmp_eq ::temp1 ::ActiveStoryType_var "road_encounter" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label51
            cmp_eq ::temp1 ::ActiveStoryType_var "stalker" 
            assign ::temp1 ::temp1 
          _label51:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label52
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush" 
            assign ::temp1 ::temp1 
          _label52:
            jmpf ::temp1 _label53
            ; line 2422
            strcat ::temp3 "Story: aborting " ::ActiveStoryType_var 
            strcat ::temp3 ::temp3 " for " 
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp7 ;0 variable args
            strcat ::temp7 ::temp3 ::temp7 
            strcat ::temp7 ::temp7 " -- player entered interior" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            ; line 2423
            callmethod GetDisplayName player ::temp7 ;0 variable args
            strcat ::temp7 "lost track of " ::temp7 
            strcat ::temp7 ::temp7 " after they went inside and gave up" 
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp7 player ;3 variable args
            ; line 2424
            callmethod AbortStoryTravel self ::nonevar "exterior type in interior" ;1 variable args
            ; line 2425
            return None 
            jmp _label53
          _label53:
            jmp _label50
          _label50:
            jmp _label48
            ; line 2430
          _label48:
            cast ::temp8 arrivalTarget 
            callmethod GetDistance ::ActiveStoryNPC_var ::temp6 ::temp8 ;1 variable args
            assign dist ::temp6 
            ; line 2433
            propget ARRIVAL_DISTANCE ::Core_var ::temp6 
            cmp_lte ::temp1 dist ::temp6 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label54
            cmp_gt ::temp1 dist 0.0 
            assign ::temp1 ::temp1 
          _label54:
            jmpf ::temp1 _label55
            ; line 2434
            callmethod OnStoryNPCArrived self ::nonevar ;0 variable args
            ; line 2435
            return None 
            jmp _label55
            ; line 2440
          _label55:
            callmethod GetParentCell arrivalTarget ::temp9 ;0 variable args
            assign targetCell ::temp9 
            ; line 2441
            callmethod GetParentCell ::ActiveStoryNPC_var ::temp9 ;0 variable args
            assign npcCell2 ::temp9 
            ; line 2442
            cast ::temp9 None 
            cmp_eq ::temp1 npcCell2 ::temp9 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label56
            cast ::temp9 None 
            cmp_eq ::temp1 targetCell ::temp9 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label56:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label57
            cmp_eq ::temp1 npcCell2 targetCell 
            assign ::temp1 ::temp1 
          _label57:
            jmpf ::temp1 _label58
            ; line 2443
            callmethod IsInterior targetCell ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label59
            propget ARRIVAL_DISTANCE ::Core_var ::temp6 
            cmp_lte ::temp1 dist ::temp6 
            assign ::temp1 ::temp1 
          _label59:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label60
            cmp_gt ::temp1 dist 0.0 
            assign ::temp1 ::temp1 
          _label60:
            jmpf ::temp1 _label61
            ; line 2444
            callmethod OnStoryNPCArrived self ::nonevar ;0 variable args
            ; line 2445
            return None 
            jmp _label61
          _label61:
            jmp _label58
            ; line 2449
          _label58:
            callmethod FindSlotByAgent ::Core_var ::temp2 ::ActiveStoryNPC_var ;1 variable args
            assign ::mangled_slot_0 ::temp2 
            ; line 2450
            cmp_lt ::temp1 ::mangled_slot_0 0 
            jmpf ::temp1 _label62
            ; line 2451
            return None 
            jmp _label62
            ; line 2455
          _label62:
            callmethod Is3DLoaded ::ActiveStoryNPC_var ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label63
            ; line 2457
            cmp_eq ::temp1 arrivalTarget player 
            jmpf ::temp1 _label64
            ; line 2458
            callmethod ShouldAbortForDangerZone self ::temp1 ::ActiveStoryNPC_var player ::ActiveStoryType_var " (off-screen)" ;4 variable args
            jmpf ::temp1 _label65
            ; line 2459
            return None 
            jmp _label65
            ; line 2461
          _label65:
            callmethod ShouldAbortForPlayerHome self ::temp1 ::ActiveStoryNPC_var player ::ActiveStoryType_var " (off-screen)" ;4 variable args
            jmpf ::temp1 _label66
            ; line 2462
            return None 
            jmp _label66
            ; line 2464
          _label66:
            callmethod ShouldAbortForHoldRestriction self ::temp1 ::ActiveStoryNPC_var player ::ActiveStoryType_var " (off-screen)" ;4 variable args
            jmpf ::temp1 _label67
            ; line 2465
            return None 
            jmp _label67
          _label67:
            jmp _label64
            ; line 2469
          _label64:
            cmp_eq ::temp1 arrivalTarget player 
            jmpf ::temp1 _label68
            ; line 2470
            callmethod GetParentCell player ::temp9 ;0 variable args
            assign offPCell ::temp9 
            ; line 2471
            cast ::temp9 None 
            cmp_eq ::temp1 offPCell ::temp9 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label69
            callmethod IsInterior offPCell ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label69:
            jmpf ::temp1 _label70
            ; line 2472
            cmp_eq ::temp1 ::ActiveStoryType_var "road_encounter" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label71
            cmp_eq ::temp1 ::ActiveStoryType_var "stalker" 
            assign ::temp1 ::temp1 
          _label71:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label72
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush" 
            assign ::temp1 ::temp1 
          _label72:
            jmpf ::temp1 _label73
            ; line 2473
            strcat ::temp7 "Story: aborting " ::ActiveStoryType_var 
            strcat ::temp7 ::temp7 " for " 
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 ::temp7 ::temp3 
            strcat ::temp3 ::temp3 " -- player entered interior (off-screen)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2474
            callmethod GetDisplayName player ::temp3 ;0 variable args
            strcat ::temp3 "lost track of " ::temp3 
            strcat ::temp3 ::temp3 " after they went inside and gave up" 
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp3 player ;3 variable args
            ; line 2475
            callmethod AbortStoryTravel self ::nonevar "exterior type in interior (off-screen)" ;1 variable args
            ; line 2476
            return None 
            jmp _label73
          _label73:
            jmp _label70
          _label70:
            jmp _label68
            ; line 2481
          _label68:
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            callstatic intelEngine CheckOffScreenProgress ::temp2 ::mangled_slot_0 ::ActiveStoryNPC_var ::temp6 ;3 variable args
            assign offscreenStatus ::temp2 
            ; line 2482
            cmp_eq ::temp1 offscreenStatus 1 
            jmpf ::temp1 _label74
            ; line 2483
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 ::temp3 " off-screen arrival (estimated time elapsed)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2484
            callmethod ImmersiveTeleportToTarget self ::nonevar ::ActiveStoryNPC_var arrivalTarget ;2 variable args
            ; line 2486
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp4 "Intel_TaskStartTime" ;2 variable args
            jmp _label74
            ; line 2488
          _label74:
            return None 
            jmp _label63
            ; line 2492
          _label63:
            propget STUCK_DISTANCE_THRESHOLD ::Core_var ::temp6 
            callstatic intelEngine CheckStuckStatus ::temp2 ::ActiveStoryNPC_var ::mangled_slot_0 ::temp6 ;3 variable args
            assign stuckStatus ::temp2 
            ; line 2493
            cmp_eq ::temp1 stuckStatus 1 
            jmpf ::temp1 _label75
            ; line 2494
            cast ::temp8 arrivalTarget 
            callmethod SoftStuckRecovery ::Core_var ::nonevar ::ActiveStoryNPC_var ::mangled_slot_0 ::temp8 ;3 variable args
            jmp _label76
            ; line 2495
          _label75:
            comp_gte ::temp1 stuckStatus 3 
            jmpf ::temp1 _label76
            ; line 2496
            jmpf ::AllowStuckTeleport_var _label77
            ; line 2497
            callmethod ImmersiveTeleportToTarget self ::nonevar ::ActiveStoryNPC_var arrivalTarget ;2 variable args
            ; line 2499
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp4 "Intel_TaskStartTime" ;2 variable args
            jmp _label78
            ; line 2501
          _label77:
            callmethod AbortStoryTravel self ::nonevar "stuck, teleport disabled" ;1 variable args
            ; line 2503
          _label78:
            return None 
            jmp _label76
            ; line 2510
          _label76:
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp6 ::temp4 "Intel_TaskStartTime" 0.0 ;3 variable args
            assign taskStart ::temp6 
            ; line 2511
            cmp_gt ::temp1 taskStart 0.0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label79
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            fsub ::temp6 ::temp6 taskStart 
            cmp_gt ::temp1 ::temp6 ::MaxTravelDaysConfig_var 
            assign ::temp1 ::temp1 
          _label79:
            jmpf ::temp1 _label80
            ; line 2512
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "[IntelEngine] StoryEngine: Travel timeout for " ::temp3 
            strcat ::temp3 ::temp3 " — force-arriving" 
            callstatic debug Trace ::nonevar ::temp3 0 ;2 variable args
            ; line 2513
            jmpf ::AllowStuckTeleport_var _label81
            ; line 2514
            callmethod ImmersiveTeleportToTarget self ::nonevar ::ActiveStoryNPC_var arrivalTarget ;2 variable args
            ; line 2515
            callmethod OnStoryNPCArrived self ::nonevar ;0 variable args
            jmp _label82
            ; line 2517
          _label81:
            callmethod AbortStoryTravel self ::nonevar "travel timeout, teleport disabled" ;1 variable args
            ; line 2519
          _label82:
            return None 
            jmp _label80
          _label80
          .endCode
        .endFunction ;CheckStoryNPCArrival
        .function ImmersiveTeleportToTarget
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param npc actor
            .param target actor
          .endParamTable
          .localTable
            .local targetCell cell
            .local ::temp0 cell
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 Float
            .local offset Float[]
            .local ::temp3 objectReference
            .local ::temp4 Float[]
            .local ::temp5 Float
          .endLocalTable
          .code
            ; line 2528
            callmethod GetParentCell target ::temp0 ;0 variable args
            assign targetCell ::temp0 
            ; line 2530
            cast ::temp0 None 
            cmp_eq ::temp1 targetCell ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            callmethod IsInterior targetCell ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 2531
            propget TELEPORT_OFFSET_INTERIOR self ::temp2 
            callmethod TeleportBehindPlayer ::Core_var ::nonevar npc ::temp2 ;2 variable args
            jmp _label2
            ; line 2533
          _label1:
            cast ::temp3 target 
            propget TELEPORT_OFFSET_EXTERIOR self ::temp2 
            callstatic intelEngine GetOffsetBehind ::temp4 ::temp3 ::temp2 ;2 variable args
            assign offset ::temp4 
            ; line 2534
            cast ::temp3 target 
            array_getlement ::temp2 offset 0 
            array_getlement ::temp5 offset 1 
            callmethod MoveTo npc ::nonevar ::temp3 ::temp2 ::temp5 0.0 False ;5 variable args
            ; line 2537
          _label2:
            callmethod ReapplyTravelPackage self ::nonevar npc ;1 variable args
          .endCode
        .endFunction ;ImmersiveTeleportToTarget
        .function OnStoryNPCArrived
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local ::temp1 Bool
            .local ::temp2 actor
            .local ::temp3 objectReference
            .local npcName String
            .local eventSummary String
            .local arrivedNPC actor
            .local secondNPC actor
            .local isNpcToNpc Bool
            .local lingerTarget objectReference
          .endLocalTable
          .code
            ; line 2545
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp0 ;0 variable args
            strcat ::temp0 "Story: " ::temp0 
            strcat ::temp0 ::temp0 " arrived! [" 
            strcat ::temp0 ::temp0 ::ActiveStoryType_var 
            strcat ::temp0 ::temp0 "]" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 2548
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush_charge" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush" 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 2549
            callmethod OnAmbushConfront self ::nonevar ;0 variable args
            ; line 2550
            return None 
            jmp _label1
            ; line 2554
          _label1:
            cmp_eq ::temp1 ::ActiveStoryType_var "message" 
            jmpf ::temp1 _label2
            ; line 2555
            callmethod OnMessageArrived self ::nonevar ;0 variable args
            ; line 2556
            return None 
            jmp _label2
            ; line 2560
          _label2:
            cmp_eq ::temp1 ::ActiveStoryType_var "quest" 
            jmpf ::temp1 _label3
            ; line 2561
            callmethod OnQuestNPCArrived self ::nonevar ;0 variable args
            ; line 2562
            return None 
            jmp _label3
            ; line 2565
          _label3:
            callmethod IsNPCToNPCType self ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label4
            cast ::temp2 None 
            cmp_eq ::temp1 ::ActiveSecondNPC_var ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label4:
            jmpf ::temp1 _label5
            ; line 2567
            cast ::temp3 ::ActiveSecondNPC_var 
            callmethod SetLookAt ::ActiveStoryNPC_var ::nonevar ::temp3 False ;2 variable args
            ; line 2568
            cast ::temp3 ::ActiveStoryNPC_var 
            callmethod SetLookAt ::ActiveSecondNPC_var ::nonevar ::temp3 False ;2 variable args
            ; line 2569
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 2570
            callmethod BuildInteractionSummary self ::temp0 ::ActiveStoryNPC_var ::ActiveNarration_var ::ActiveSecondNPC_var ;3 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp0 ::ActiveSecondNPC_var ;3 variable args
            jmp _label6
            ; line 2573
          _label5:
            callstatic game GetPlayer ::temp2 ;0 variable args
            cast ::temp3 ::temp2 
            callmethod SetLookAt ::ActiveStoryNPC_var ::nonevar ::temp3 False ;2 variable args
            ; line 2574
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::ActiveNarration_var ::temp2 ;3 variable args
            ; line 2578
          _label6:
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp0 ;0 variable args
            assign npcName ::temp0 
            ; line 2579
            strcat ::temp0 ::ActiveStoryType_var ": " 
            strcat ::temp0 ::temp0 npcName 
            strcat ::temp0 ::temp0 " -- " 
            strcat ::temp0 ::temp0 ::ActiveNarration_var 
            assign eventSummary ::temp0 
            ; line 2580
            callmethod AddRecentStoryEvent self ::nonevar eventSummary ;1 variable args
            ; line 2583
            assign arrivedNPC ::ActiveStoryNPC_var 
            ; line 2584
            assign secondNPC ::ActiveSecondNPC_var 
            ; line 2585
            callmethod IsNPCToNPCType self ::temp1 ;0 variable args
            assign isNpcToNpc ::temp1 
            ; line 2588
            callstatic game GetPlayer ::temp2 ;0 variable args
            cast ::temp3 ::temp2 
            assign lingerTarget ::temp3 
            ; line 2589
            assign ::temp1 isNpcToNpc 
            jmpf ::temp1 _label7
            cast ::temp2 None 
            cmp_eq ::temp1 secondNPC ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label7:
            jmpf ::temp1 _label8
            ; line 2590
            cast ::temp3 secondNPC 
            assign lingerTarget ::temp3 
            jmp _label8
            ; line 2592
          _label8:
            callmethod FinishArrivalWithLinger self ::nonevar arrivedNPC lingerTarget ;2 variable args
          .endCode
        .endFunction ;OnStoryNPCArrived
        .function HandleMessageDispatch
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param senderNPC actor
            .param narration String
            .param response String
          .endParamTable
          .localTable
            .local msgContent String
            .local ::temp0 String
            .local destination String
            .local meetTime String
            .local playerName String
            .local ::temp1 actor
            .local senderName String
            .local messenger actor
            .local ::temp2 Bool
            .local ::nonevar None
            .local messengerName String
            .local ::temp3 form
          .endLocalTable
          .code
            ; line 2600
            callmethod ExtractJsonField self ::temp0 response "msgContent" ;2 variable args
            assign msgContent ::temp0 
            ; line 2601
            callmethod ExtractJsonField self ::temp0 response "destination" ;2 variable args
            assign destination ::temp0 
            ; line 2602
            callmethod ExtractJsonField self ::temp0 response "meetTime" ;2 variable args
            assign meetTime ::temp0 
            ; line 2604
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName ::temp1 ::temp0 ;0 variable args
            assign playerName ::temp0 
            ; line 2605
            callmethod GetDisplayName senderNPC ::temp0 ;0 variable args
            assign senderName ::temp0 
            ; line 2608
            callstatic intelEngine FindMessengerForSender ::temp1 senderNPC ;1 variable args
            assign messenger ::temp1 
            ; line 2610
            cast ::temp1 None 
            cmp_eq ::temp2 messenger ::temp1 
            jmpf ::temp2 _label0
            ; line 2612
            callstatic intelEngine IsCivilianClass ::temp2 senderNPC ;1 variable args
            jmpf ::temp2 _label1
            ; line 2613
            assign messenger senderNPC 
            ; line 2614
            strcat ::temp0 "Story message: " senderName 
            strcat ::temp0 ::temp0 " self-delivering (civilian)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            jmp _label2
            ; line 2616
          _label1:
            strcat ::temp0 "Story message: rejected -- no messenger for " senderName 
            strcat ::temp0 ::temp0 " (non-civilian, no self-delivery)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 2617
            return None 
          _label2:
            jmp _label0
            ; line 2621
          _label0:
            callmethod IEB_StoryBlocked self ::temp2 messenger 1 ;2 variable args
            jmpf ::temp2 _label3
            ; line 2622
            callmethod GetDisplayName messenger ::temp0 ;0 variable args
            strcat ::temp0 "Story message: rejected -- messenger " ::temp0 
            strcat ::temp0 ::temp0 " is committed to a quest" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 2623
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "npc is committed to a quest" ;1 variable args
            ; line 2624
            return None 
            jmp _label3
            ; line 2627
          _label3:
            callmethod GetDisplayName messenger ::temp0 ;0 variable args
            assign messengerName ::temp0 
            ; line 2630
            cmp_eq ::temp2 messenger senderNPC 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label4
            ; line 2631
            strcat ::temp0 "asked " messengerName 
            strcat ::temp0 ::temp0 " to deliver a message to " 
            strcat ::temp0 ::temp0 playerName 
            strcat ::temp0 ::temp0 ": " 
            strcat ::temp0 ::temp0 msgContent 
            callmethod InjectFact ::Core_var ::nonevar senderNPC ::temp0 ;2 variable args
            ; line 2632
            strcat ::temp0 "was sent by " senderName 
            strcat ::temp0 ::temp0 " to deliver a message to " 
            strcat ::temp0 ::temp0 playerName 
            strcat ::temp0 ::temp0 ": " 
            strcat ::temp0 ::temp0 msgContent 
            callmethod InjectFact ::Core_var ::nonevar messenger ::temp0 ;2 variable args
            ; line 2633
            callstatic game GetPlayer ::temp1 ;0 variable args
            strcat ::temp0 messengerName " set out to deliver a message from " 
            strcat ::temp0 ::temp0 senderName 
            strcat ::temp0 ::temp0 " to " 
            strcat ::temp0 ::temp0 playerName 
            callmethod SendPersistentMemory ::Core_var ::nonevar messenger ::temp1 ::temp0 ;3 variable args
            jmp _label5
            ; line 2635
          _label4:
            strcat ::temp0 "set out to deliver a message to " playerName 
            strcat ::temp0 ::temp0 ": " 
            strcat ::temp0 ::temp0 msgContent 
            callmethod InjectFact ::Core_var ::nonevar senderNPC ::temp0 ;2 variable args
            ; line 2636
            callstatic game GetPlayer ::temp1 ;0 variable args
            strcat ::temp0 senderName " set out to find " 
            strcat ::temp0 ::temp0 playerName 
            callmethod SendPersistentMemory ::Core_var ::nonevar senderNPC ::temp1 ::temp0 ;3 variable args
            ; line 2640
          _label5:
            cast ::temp3 messenger 
            callstatic storageUtil SetStringValue ::temp0 ::temp3 "Intel_MessageSender" senderName ;3 variable args
            ; line 2641
            cast ::temp3 messenger 
            callstatic storageUtil SetStringValue ::temp0 ::temp3 "Intel_MessageContent" msgContent ;3 variable args
            ; line 2642
            cast ::temp3 messenger 
            callstatic storageUtil SetStringValue ::temp0 ::temp3 "Intel_MessageDest" destination ;3 variable args
            ; line 2643
            cast ::temp3 messenger 
            callstatic storageUtil SetStringValue ::temp0 ::temp3 "Intel_MessageTime" meetTime ;3 variable args
            ; line 2645
            assign ::ActiveStoryType_var "message" 
            ; line 2646
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod DispatchToTarget self ::nonevar messenger ::temp1 narration "story" ;4 variable args
          .endCode
        .endFunction ;HandleMessageDispatch
        .function OnMessageArrived
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local senderName String
            .local ::temp0 form
            .local ::temp1 String
            .local msgContent String
            .local msgDest String
            .local meetTime String
            .local fullNarration String
            .local ::temp2 Bool
            .local ::nonevar None
            .local ::temp3 actor
            .local ::temp4 intelEngine_Schedule
            .local senderForMeeting actor
            .local timeCondition String
            .local ::temp5 objectReference
          .endLocalTable
          .code
            ; line 2650
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_MessageSender" "" ;3 variable args
            assign senderName ::temp1 
            ; line 2651
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_MessageContent" "" ;3 variable args
            assign msgContent ::temp1 
            ; line 2652
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_MessageDest" "" ;3 variable args
            assign msgDest ::temp1 
            ; line 2653
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_MessageTime" "" ;3 variable args
            assign meetTime ::temp1 
            ; line 2656
            assign fullNarration "" 
            ; line 2657
            cmp_eq ::temp2 senderName "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label0
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            cmp_eq ::temp2 senderName ::temp1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label0:
            jmpf ::temp2 _label1
            ; line 2658
            strcat ::temp1 "delivered a message from " senderName 
            strcat ::temp1 ::temp1 ": " 
            strcat ::temp1 ::temp1 msgContent 
            assign fullNarration ::temp1 
            jmp _label2
            ; line 2660
          _label1:
            assign fullNarration ::ActiveNarration_var 
            ; line 2662
          _label2:
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var fullNarration ::temp3 ;3 variable args
            ; line 2666
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp1 " delivered a message from " 
            strcat ::temp1 ::temp1 senderName 
            strcat ::temp1 ::temp1 ": " 
            strcat ::temp1 ::temp1 msgContent 
            callmethod SendPersistentMemory ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp3 ::temp1 ;3 variable args
            ; line 2671
            cmp_eq ::temp2 msgDest "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label3
            cmp_eq ::temp2 meetTime "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label3:
            jmpf ::temp2 _label4
            ; line 2672
            callstatic intelEngine IsUrgentMessage ::temp2 msgContent ;1 variable args
            jmpf ::temp2 _label5
            ; line 2673
            strcat ::temp1 "Story message: urgency in msgContent conflicts with meetTime '" meetTime 
            strcat ::temp1 ::temp1 "' -- dropping meeting, treating as plain message" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 2674
            assign msgDest "" 
            ; line 2675
            assign meetTime "" 
            jmp _label5
          _label5:
            jmp _label4
            ; line 2680
          _label4:
            cmp_eq ::temp2 msgDest "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label6
            cast ::temp4 None 
            cmp_eq ::temp2 ::Schedule_var ::temp4 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label6:
            jmpf ::temp2 _label7
            ; line 2681
            cast ::temp3 None 
            assign senderForMeeting ::temp3 
            ; line 2682
            cmp_eq ::temp2 senderName "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label8
            ; line 2683
            callstatic intelEngine FindNPCByName ::temp3 senderName ;1 variable args
            assign senderForMeeting ::temp3 
            jmp _label8
            ; line 2686
          _label8:
            cast ::temp3 None 
            cmp_eq ::temp2 senderForMeeting ::temp3 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label9
            callmethod IEB_StoryBlocked self ::temp2 senderForMeeting 1 ;2 variable args
            assign ::temp2 ::temp2 
          _label9:
            jmpf ::temp2 _label10
            ; line 2687
            callmethod GetDisplayName senderForMeeting ::temp1 ;0 variable args
            strcat ::temp1 "Story message: meeting skipped -- " ::temp1 
            strcat ::temp1 ::temp1 " is committed to a quest" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            jmp _label11
            ; line 2688
          _label10:
            cast ::temp3 None 
            cmp_eq ::temp2 senderForMeeting ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label11
            ; line 2689
            assign timeCondition meetTime 
            ; line 2690
            cmp_eq ::temp2 timeCondition "" 
            jmpf ::temp2 _label12
            ; line 2691
            assign timeCondition "evening" 
            jmp _label12
            ; line 2693
          _label12:
            callmethod ScheduleMeeting ::Schedule_var ::temp2 senderForMeeting msgDest timeCondition ;3 variable args
            jmp _label11
          _label11:
            jmp _label7
            ; line 2698
          _label7:
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 "message: " ::temp1 
            strcat ::temp1 ::temp1 " -- " 
            strcat ::temp1 ::temp1 fullNarration 
            callmethod AddRecentStoryEvent self ::nonevar ::temp1 ;1 variable args
            ; line 2700
            callstatic game GetPlayer ::temp3 ;0 variable args
            cast ::temp5 ::temp3 
            callmethod FinishArrivalWithLinger self ::nonevar ::ActiveStoryNPC_var ::temp5 ;2 variable args
          .endCode
        .endFunction ;OnMessageArrived
        .function HandleAmbushStalkerDispatch
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param npc actor
            .param narration String
            .param response String
            .param storyType String
          .endParamTable
          .localTable
            .local senderName String
            .local ::temp0 String
            .local playerName String
            .local ::temp1 actor
            .local ::nonevar None
            .local ::temp2 Bool
            .local senderNPC actor
            .local ::temp3 Int
            .local ::temp4 form
            .local ::temp5 Float
          .endLocalTable
          .code
            ; line 2708
            callmethod ExtractJsonField self ::temp0 response "sender" ;2 variable args
            assign senderName ::temp0 
            ; line 2709
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName ::temp1 ::temp0 ;0 variable args
            assign playerName ::temp0 
            ; line 2712
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 ::temp0 " " 
            strcat ::temp0 ::temp0 narration 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc npc ::temp0 ;3 variable args
            ; line 2715
            callmethod InjectFact ::Core_var ::nonevar npc narration ;2 variable args
            ; line 2718
            cmp_eq ::temp2 senderName "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label0
            ; line 2719
            callstatic intelEngine FindNPCByName ::temp1 senderName ;1 variable args
            assign senderNPC ::temp1 
            ; line 2720
            cast ::temp1 None 
            cmp_eq ::temp2 senderNPC ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label1
            ; line 2721
            cmp_eq ::temp2 storyType "ambush" 
            jmpf ::temp2 _label2
            ; line 2722
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "sent " ::temp0 
            strcat ::temp0 ::temp0 " to ambush " 
            strcat ::temp0 ::temp0 playerName 
            callmethod InjectFact ::Core_var ::nonevar senderNPC ::temp0 ;2 variable args
            jmp _label3
            ; line 2724
          _label2:
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "encouraged " ::temp0 
            strcat ::temp0 ::temp0 " to follow " 
            strcat ::temp0 ::temp0 playerName 
            callmethod InjectFact ::Core_var ::nonevar senderNPC ::temp0 ;2 variable args
          _label3:
            jmp _label1
          _label1:
            jmp _label0
            ; line 2730
          _label0:
            cmp_eq ::temp2 storyType "ambush" 
            jmpf ::temp2 _label4
            ; line 2731
            callstatic utility RandomInt ::temp3 0 1 ;2 variable args
            cmp_eq ::temp2 ::temp3 1 
            jmpf ::temp2 _label5
            ; line 2732
            assign storyType "ambush_charge" 
            ; line 2733
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Story [ambush]: " ::temp0 
            strcat ::temp0 ::temp0 " choosing aggressive charge approach" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            jmp _label6
            ; line 2735
          _label5:
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Story [ambush]: " ::temp0 
            strcat ::temp0 ::temp0 " choosing stealthy approach" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
          _label6:
            jmp _label4
            ; line 2739
          _label4:
            assign ::ActiveStoryType_var storyType 
            ; line 2740
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod DispatchToTarget self ::nonevar npc ::temp1 narration "story" ;4 variable args
            ; line 2744
            cmp_eq ::temp2 storyType "stalker" 
            jmpf ::temp2 _label7
            ; line 2745
            cast ::temp4 npc 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "Intel_SneakPhase" 1 ;3 variable args
            ; line 2746
            callmethod ReapplyTravelPackage self ::nonevar npc ;1 variable args
            ; line 2747
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Story [stalker]: " ::temp0 
            strcat ::temp0 ::temp0 " dispatched with stalk package" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            jmp _label8
            ; line 2748
          _label7:
            cmp_eq ::temp2 storyType "ambush" 
            jmpf ::temp2 _label8
            ; line 2749
            cast ::temp4 npc 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "Intel_SneakPhase" 0 ;3 variable args
            ; line 2750
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Story [ambush]: " ::temp0 
            strcat ::temp0 ::temp0 " dispatched (jog → sneak at 2000u)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            jmp _label8
            ; line 2754
          _label8:
            cmp_eq ::temp2 storyType "ambush" 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label9
            cmp_eq ::temp2 storyType "stalker" 
            assign ::temp2 ::temp2 
          _label9:
            jmpf ::temp2 _label10
            ; line 2755
            cast ::temp4 npc 
            callstatic utility GetCurrentRealTime ::temp5 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp5 ::temp4 "Intel_SneakStartTime" ::temp5 ;3 variable args
            jmp _label10
          _label10
          .endCode
        .endFunction ;HandleAmbushStalkerDispatch
        .function HandleFactionAmbushDispatch
           ; function type 0
          .userFlags 0 ;none
          .docString "Faction group ambush — spawn 3-7 hostile soldiers from a faction near the player."
          .return None
          .paramTable
            .param narration String
            .param response String
          .endParamTable
          .localTable
            .local factionId String
            .local ::temp0 String
            .local countStr String
            .local ::temp1 Bool
            .local ::nonevar None
            .local count Int
            .local ::temp2 Int
            .local ::temp3 intelEngine_Battle
            .local ::temp4 intelEngine_Battle
            .local player actor
            .local ::temp5 actor
            .local soldiers actor[]
            .local ::temp6 String
            .local ::temp7 objectReference
            .local ::temp8 actor[]
            .local playerAngle Float
            .local ::temp9 Float
            .local i Int
            .local ::temp10 actor
            .local angle Float
            .local ::temp11 Float
            .local dist Float
            .local offsetX Float
            .local offsetY Float
            .local factionName String
            .local ambushMsg Int
            .local ::temp12 form
          .endLocalTable
          .code
            ; line 2761
            callmethod ExtractJsonField self ::temp0 response "ambushFaction" ;2 variable args
            assign factionId ::temp0 
            ; line 2762
            callmethod ExtractJsonField self ::temp0 response "ambushCount" ;2 variable args
            assign countStr ::temp0 
            ; line 2764
            cmp_eq ::temp1 factionId "" 
            jmpf ::temp1 _label0
            ; line 2765
            callmethod DebugMsg ::Core_var ::nonevar "Story [faction_ambush]: missing ambushFaction" ;1 variable args
            ; line 2766
            return None 
            jmp _label0
            ; line 2769
          _label0:
            cast ::temp2 countStr 
            assign count ::temp2 
            ; line 2770
            cmp_lt ::temp1 count 3 
            jmpf ::temp1 _label1
            ; line 2771
            assign count 3 
            jmp _label2
            ; line 2772
          _label1:
            cmp_gt ::temp1 count 7 
            jmpf ::temp1 _label2
            ; line 2773
            assign count 7 
            jmp _label2
            ; line 2777
          _label2:
            callstatic intelEngine IsBattleActive ::temp1 ;0 variable args
            jmpf ::temp1 _label3
            ; line 2778
            callmethod DebugMsg ::Core_var ::nonevar "Story [faction_ambush]: battle active, skipping" ;1 variable args
            ; line 2779
            return None 
            jmp _label3
            ; line 2781
          _label3:
            jmpf ::FactionAmbushActive_var _label4
            ; line 2782
            callmethod DebugMsg ::Core_var ::nonevar "Story [faction_ambush]: previous ambush still active, skipping" ;1 variable args
            ; line 2783
            return None 
            jmp _label4
            ; line 2785
          _label4:
            propget Battle ::Core_var ::temp3 
            cast ::temp4 None 
            cmp_eq ::temp1 ::temp3 ::temp4 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label5
            propget Battle ::Core_var ::temp4 
            propget ManifestActive ::temp4 ::temp1 
            assign ::temp1 ::temp1 
          _label5:
            jmpf ::temp1 _label6
            ; line 2786
            callmethod DebugMsg ::Core_var ::nonevar "Story [faction_ambush]: manifestation active, skipping" ;1 variable args
            ; line 2787
            return None 
            jmp _label6
            ; line 2790
          _label6:
            callstatic game GetPlayer ::temp5 ;0 variable args
            assign player ::temp5 
            ; line 2793
            strcat ::temp0 factionId ":" 
            cast ::temp6 count 
            strcat ::temp6 ::temp0 ::temp6 
            cast ::temp7 player 
            callstatic intelEngine SpawnBattleSoldiers ::temp8 ::temp6 ::temp7 ;2 variable args
            assign soldiers ::temp8 
            ; line 2794
            array_length ::temp2 soldiers 
            cmp_eq ::temp1 ::temp2 0 
            jmpf ::temp1 _label7
            ; line 2795
            strcat ::temp6 "Story [faction_ambush]: no soldiers spawned for " factionId 
            callmethod DebugMsg ::Core_var ::nonevar ::temp6 ;1 variable args
            ; line 2796
            return None 
            jmp _label7
            ; line 2801
          _label7:
            array_create ::temp8 7 
            assign ::FactionAmbushActors_var ::temp8 
            ; line 2802
            assign ::FactionAmbushCount_var 0 
            ; line 2803
            callmethod GetAngleZ player ::temp9 ;0 variable args
            assign playerAngle ::temp9 
            ; line 2805
            assign i 0 
            ; line 2806
          _label11:
            array_length ::temp2 soldiers 
            cmp_lt ::temp1 i ::temp2 
            jmpf ::temp1 _label8
            ; line 2807
            array_getlement ::temp5 soldiers i 
            cast ::temp10 None 
            cmp_eq ::temp1 ::temp5 ::temp10 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label9
            cmp_lt ::temp1 ::FactionAmbushCount_var 7 
            assign ::temp1 ::temp1 
          _label9:
            jmpf ::temp1 _label10
            ; line 2809
            fadd ::temp9 playerAngle 180.0 
            callstatic utility RandomFloat ::temp11 -45.0 45.0 ;2 variable args
            fadd ::temp11 ::temp9 ::temp11 
            assign angle ::temp11 
            ; line 2810
            callstatic utility RandomFloat ::temp11 800.0 1200.0 ;2 variable args
            assign dist ::temp11 
            ; line 2811
            callstatic math sin ::temp11 angle ;1 variable args
            fmul ::temp11 ::temp11 dist 
            assign offsetX ::temp11 
            ; line 2812
            callstatic math cos ::temp11 angle ;1 variable args
            fmul ::temp11 ::temp11 dist 
            assign offsetY ::temp11 
            ; line 2813
            cast ::temp7 player 
            array_getlement ::temp10 soldiers i 
            callmethod MoveTo ::temp10 ::nonevar ::temp7 offsetX offsetY 0.0 True ;5 variable args
            ; line 2814
            array_getlement ::temp10 soldiers i 
            callmethod SetActorValue ::temp10 ::nonevar "Confidence" 4.0 ;2 variable args
            ; line 2815
            array_getlement ::temp10 soldiers i 
            callmethod SetActorValue ::temp10 ::nonevar "Aggression" 1.0 ;2 variable args
            ; line 2816
            array_getlement ::temp10 soldiers i 
            array_setelement ::FactionAmbushActors_var ::FactionAmbushCount_var ::temp10 
            ; line 2817
            iadd ::temp2 ::FactionAmbushCount_var 1 
            assign ::FactionAmbushCount_var ::temp2 
            jmp _label10
            ; line 2819
          _label10:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label11
            ; line 2822
          _label8:
            cmp_eq ::temp1 ::FactionAmbushCount_var 0 
            jmpf ::temp1 _label12
            ; line 2823
            callmethod DebugMsg ::Core_var ::nonevar "Story [faction_ambush]: all soldiers None after spawn" ;1 variable args
            ; line 2824
            return None 
            jmp _label12
            ; line 2827
          _label12:
            callstatic intelEngine GetFactionDisplayName ::temp6 factionId ;1 variable args
            assign factionName ::temp6 
            ; line 2830
            callstatic utility RandomFloat ::temp11 0.0 1.0 ;2 variable args
            fadd ::temp11 1.5 ::temp11 
            callstatic utility Wait ::nonevar ::temp11 ;1 variable args
            ; line 2831
            callstatic debug Notification ::nonevar "Something feels wrong..." ;1 variable args
            ; line 2832
            callstatic utility Wait ::nonevar 1.0 ;1 variable args
            ; line 2833
            callstatic utility RandomInt ::temp2 0 2 ;2 variable args
            assign ambushMsg ::temp2 
            ; line 2834
            cmp_eq ::temp1 ambushMsg 0 
            jmpf ::temp1 _label13
            ; line 2835
            strcat ::temp6 factionName " soldiers emerge from hiding!" 
            callstatic debug Notification ::nonevar ::temp6 ;1 variable args
            jmp _label14
            ; line 2836
          _label13:
            cmp_eq ::temp1 ambushMsg 1 
            jmpf ::temp1 _label15
            ; line 2837
            strcat ::temp6 "Ambush! " factionName 
            strcat ::temp6 ::temp6 " forces surround you!" 
            callstatic debug Notification ::nonevar ::temp6 ;1 variable args
            jmp _label14
            ; line 2839
          _label15:
            strcat ::temp6 factionName " troops close in from behind!" 
            callstatic debug Notification ::nonevar ::temp6 ;1 variable args
            ; line 2843
          _label14:
            assign i 0 
            ; line 2844
          _label18:
            cmp_lt ::temp1 i ::FactionAmbushCount_var 
            jmpf ::temp1 _label16
            ; line 2845
            array_getlement ::temp10 ::FactionAmbushActors_var i 
            cast ::temp5 None 
            cmp_eq ::temp1 ::temp10 ::temp5 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label17
            ; line 2846
            array_getlement ::temp5 ::FactionAmbushActors_var i 
            callmethod StartCombat ::temp5 ::nonevar player ;1 variable args
            ; line 2847
            callstatic utility RandomFloat ::temp11 0.300000012 0.600000024 ;2 variable args
            callstatic utility Wait ::nonevar ::temp11 ;1 variable args
            jmp _label17
            ; line 2849
          _label17:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label18
            ; line 2852
          _label16:
            strcat ::temp6 "faction_ambush: " factionName 
            strcat ::temp6 ::temp6 " (" 
            cast ::temp0 ::FactionAmbushCount_var 
            strcat ::temp0 ::temp6 ::temp0 
            strcat ::temp0 ::temp0 " soldiers) -- " 
            strcat ::temp0 ::temp0 narration 
            callmethod AddRecentStoryEvent self ::nonevar ::temp0 ;1 variable args
            ; line 2854
            assign ::FactionAmbushActive_var True 
            ; line 2855
            callstatic utility GetCurrentRealTime ::temp11 ;0 variable args
            assign ::FactionAmbushStartTime_var ::temp11 
            ; line 2856
            cast ::temp12 player 
            callstatic storageUtil SetStringValue ::temp0 ::temp12 "Intel_FactionAmbushFaction" factionId ;3 variable args
            ; line 2857
            cast ::temp0 ::FactionAmbushCount_var 
            strcat ::temp0 "Story [faction_ambush]: " ::temp0 
            strcat ::temp0 ::temp0 " " 
            strcat ::temp0 ::temp0 factionName 
            strcat ::temp0 ::temp0 " soldiers spawned" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
          .endCode
        .endFunction ;HandleFactionAmbushDispatch
        .function CheckFactionAmbushCleanup
           ; function type 0
          .userFlags 0 ;none
          .docString "Monitor faction ambush actors — cleanup when all dead or timeout elapsed."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local elapsed Float
            .local ::temp1 Float
            .local allDead Bool
            .local deadCount Int
            .local i Int
            .local ::temp2 actor
            .local ::temp3 actor
            .local ::temp4 Int
            .local timeoutReady Bool
            .local hardTimeout Bool
            .local ambushFactionId String
            .local ::temp5 form
            .local ::temp6 String
            .local factionPenalty Int
            .local ::nonevar None
            .local ::temp7 String
          .endLocalTable
          .code
            ; line 2862
            not ::temp0 ::FactionAmbushActive_var 
            jmpf ::temp0 _label0
            ; line 2863
            return None 
            jmp _label0
            ; line 2866
          _label0:
            callstatic utility GetCurrentRealTime ::temp1 ;0 variable args
            fsub ::temp1 ::temp1 ::FactionAmbushStartTime_var 
            assign elapsed ::temp1 
            ; line 2867
            assign allDead True 
            ; line 2868
            assign deadCount 0 
            ; line 2869
            assign i 0 
            ; line 2870
          _label5:
            cmp_lt ::temp0 i ::FactionAmbushCount_var 
            jmpf ::temp0 _label1
            ; line 2871
            array_getlement ::temp2 ::FactionAmbushActors_var i 
            cast ::temp3 None 
            cmp_eq ::temp0 ::temp2 ::temp3 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 2872
            array_getlement ::temp3 ::FactionAmbushActors_var i 
            callmethod IsDead ::temp3 ::temp0 ;0 variable args
            jmpf ::temp0 _label3
            ; line 2873
            iadd ::temp4 deadCount 1 
            assign deadCount ::temp4 
            jmp _label4
            ; line 2875
          _label3:
            assign allDead False 
          _label4:
            jmp _label2
            ; line 2878
          _label2:
            iadd ::temp4 i 1 
            assign i ::temp4 
            jmp _label5
            ; line 2882
          _label1:
            propget FACTION_AMBUSH_CLEANUP_TIMEOUT self ::temp1 
            comp_gte ::temp0 elapsed ::temp1 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label6
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod IsInCombat ::temp3 ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label6:
            assign timeoutReady ::temp0 
            ; line 2883
            propget FACTION_AMBUSH_HARD_TIMEOUT self ::temp1 
            comp_gte ::temp0 elapsed ::temp1 
            assign hardTimeout ::temp0 
            ; line 2884
            assign ::temp0 allDead 
            jmpt ::temp0 _label7
            assign ::temp0 timeoutReady 
          _label7:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label8
            assign ::temp0 hardTimeout 
          _label8:
            jmpf ::temp0 _label9
            ; line 2888
            callstatic game GetPlayer ::temp3 ;0 variable args
            cast ::temp5 ::temp3 
            callstatic storageUtil GetStringValue ::temp6 ::temp5 "Intel_FactionAmbushFaction" "" ;3 variable args
            assign ambushFactionId ::temp6 
            ; line 2889
            cmp_eq ::temp0 ambushFactionId "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label10
            ; line 2890
            cmp_gt ::temp0 deadCount 0 
            jmpf ::temp0 _label11
            ; line 2892
            imul ::temp4 deadCount -2 
            assign factionPenalty ::temp4 
            ; line 2893
            callstatic intelEngine AdjustPlayerFactionStanding ::temp4 ambushFactionId factionPenalty ;2 variable args
            ; line 2894
            strcat ::temp6 "Story [faction_ambush]: " ambushFactionId 
            strcat ::temp6 ::temp6 " standing " 
            cast ::temp7 factionPenalty 
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 " (killed " 
            cast ::temp6 deadCount 
            strcat ::temp6 ::temp7 ::temp6 
            strcat ::temp6 ::temp6 " soldiers)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp6 ;1 variable args
            jmp _label11
            ; line 2896
          _label11:
            callstatic game GetPlayer ::temp3 ;0 variable args
            cast ::temp5 ::temp3 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp5 "Intel_FactionAmbushFaction" ;2 variable args
            jmp _label10
            ; line 2899
          _label10:
            cast ::temp6 ::FactionAmbushCount_var 
            strcat ::temp6 "Story [faction_ambush]: cleanup (" ::temp6 
            strcat ::temp6 ::temp6 " actors, allDead=" 
            cast ::temp7 allDead 
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 ", elapsed=" 
            cast ::temp4 elapsed 
            cast ::temp6 ::temp4 
            strcat ::temp6 ::temp7 ::temp6 
            strcat ::temp6 ::temp6 "s)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp6 ;1 variable args
            ; line 2901
            assign i 0 
            ; line 2902
          _label15:
            cmp_lt ::temp0 i ::FactionAmbushCount_var 
            jmpf ::temp0 _label12
            ; line 2903
            array_getlement ::temp3 ::FactionAmbushActors_var i 
            cast ::temp2 None 
            cmp_eq ::temp0 ::temp3 ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label13
            ; line 2904
            array_getlement ::temp2 ::FactionAmbushActors_var i 
            callmethod IsDead ::temp2 ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label14
            ; line 2906
            array_getlement ::temp2 ::FactionAmbushActors_var i 
            callmethod SetActorValue ::temp2 ::nonevar "Aggression" 0.0 ;2 variable args
            ; line 2907
            array_getlement ::temp2 ::FactionAmbushActors_var i 
            callmethod StopCombat ::temp2 ::nonevar ;0 variable args
            jmp _label14
            ; line 2909
          _label14:
            array_getlement ::temp2 ::FactionAmbushActors_var i 
            callmethod DisableNoWait ::temp2 ::nonevar False ;1 variable args
            ; line 2910
            array_getlement ::temp2 ::FactionAmbushActors_var i 
            callmethod Delete ::temp2 ::nonevar ;0 variable args
            ; line 2911
            cast ::temp2 None 
            array_setelement ::FactionAmbushActors_var i ::temp2 
            jmp _label13
            ; line 2913
          _label13:
            iadd ::temp4 i 1 
            assign i ::temp4 
            jmp _label15
            ; line 2915
          _label12:
            assign ::FactionAmbushCount_var 0 
            ; line 2916
            assign ::FactionAmbushActive_var False 
            jmp _label9
          _label9
          .endCode
        .endFunction ;CheckFactionAmbushCleanup
        .function OnAmbushConfront
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 actor
            .local ::temp2 String
            .local ::temp3 actorBase
            .local ::temp4 form
            .local ::temp5 Float
          .endLocalTable
          .code
            ; line 2921
            callmethod IsSneaking ::ActiveStoryNPC_var ::temp0 ;0 variable args
            jmpf ::temp0 _label0
            ; line 2922
            callmethod StartSneaking ::ActiveStoryNPC_var ::nonevar ;0 variable args
            jmp _label0
            ; line 2926
          _label0:
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName ::temp1 ::temp2 ;0 variable args
            strcat ::temp2 "confronted " ::temp2 
            strcat ::temp2 ::temp2 " with weapon drawn, ready to attack" 
            callmethod InjectFact ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp2 ;2 variable args
            ; line 2929
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::ActiveNarration_var ::temp1 ;3 variable args
            ; line 2930
            callstatic utility Wait ::nonevar 1.5 ;1 variable args
            ; line 2933
            callmethod GetActorBase ::ActiveStoryNPC_var ::temp3 ;0 variable args
            callmethod SetEssential ::temp3 ::nonevar True ;1 variable args
            ; line 2936
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Confidence" 4.0 ;2 variable args
            ; line 2937
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod StartCombat ::ActiveStoryNPC_var ::nonevar ::temp1 ;1 variable args
            ; line 2940
            assign ::ActiveStoryType_var "ambush_combat" 
            ; line 2941
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic utility GetCurrentRealTime ::temp5 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp5 ::temp4 "Intel_CombatStartTime" ::temp5 ;3 variable args
            ; line 2942
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp2 ;0 variable args
            strcat ::temp2 "ambush: " ::temp2 
            strcat ::temp2 ::temp2 " -- " 
            strcat ::temp2 ::temp2 ::ActiveNarration_var 
            callmethod AddRecentStoryEvent self ::nonevar ::temp2 ;1 variable args
          .endCode
        .endFunction ;OnAmbushConfront
        .function CheckAmbushCombat
           ; function type 0
          .userFlags 0 ;none
          .docString "Monitor ambush combat: yield when NPC health drops below threshold."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local combatStart Float
            .local ::temp2 form
            .local ::temp3 Float
            .local ::temp4 Float
            .local ::nonevar None
            .local ::temp5 String
            .local ::temp6 actorBase
            .local endedNPC actor
            .local ::temp7 objectReference
            .local slot Int
            .local ::temp8 Int
            .local ::mangled_endedNPC_0 actor
          .endLocalTable
          .code
            ; line 2947
            cmp_eq ::temp0 ::ActiveStoryType_var "ambush_combat" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 ::ActiveStoryNPC_var ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 2948
            return None 
            jmp _label1
            ; line 2952
          _label1:
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp3 ::temp2 "Intel_CombatStartTime" 0.0 ;3 variable args
            assign combatStart ::temp3 
            ; line 2953
            cmp_gt ::temp0 combatStart 0.0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label2
            callstatic utility GetCurrentRealTime ::temp3 ;0 variable args
            fsub ::temp3 ::temp3 combatStart 
            propget SNEAK_TIMEOUT_SECONDS self ::temp4 
            cmp_gt ::temp0 ::temp3 ::temp4 
            assign ::temp0 ::temp0 
          _label2:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            callmethod ShouldReleaseLinger ::Core_var ::temp0 ::ActiveStoryNPC_var ;1 variable args
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 2954
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp5 ;0 variable args
            strcat ::temp5 "Story [ambush_combat]: " ::temp5 
            strcat ::temp5 ::temp5 " combat timed out - forcing end" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            ; line 2955
            callmethod GetActorBase ::ActiveStoryNPC_var ::temp6 ;0 variable args
            callmethod SetEssential ::temp6 ::nonevar False ;1 variable args
            ; line 2956
            callmethod StopCombat ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 2957
            callmethod StopCombatAlarm ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 2958
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Aggression" 0.0 ;2 variable args
            ; line 2959
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Confidence" 2.0 ;2 variable args
            ; line 2960
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp2 "Intel_CombatStartTime" ;2 variable args
            ; line 2961
            assign endedNPC ::ActiveStoryNPC_var 
            ; line 2962
            callstatic game GetPlayer ::temp1 ;0 variable args
            cast ::temp7 ::temp1 
            callmethod FinishArrivalWithLinger self ::nonevar endedNPC ::temp7 ;2 variable args
            ; line 2963
            return None 
            jmp _label4
            ; line 2966
          _label4:
            callmethod IsDead ::ActiveStoryNPC_var ::temp0 ;0 variable args
            jmpf ::temp0 _label5
            ; line 2967
            callmethod GetActorBase ::ActiveStoryNPC_var ::temp6 ;0 variable args
            callmethod SetEssential ::temp6 ::nonevar False ;1 variable args
            ; line 2968
            callmethod FindSlotByAgent ::Core_var ::temp8 ::ActiveStoryNPC_var ;1 variable args
            assign slot ::temp8 
            ; line 2969
            comp_gte ::temp0 slot 0 
            jmpf ::temp0 _label6
            ; line 2970
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label6
            ; line 2972
          _label6:
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 2973
            return None 
            jmp _label5
            ; line 2977
          _label5:
            callmethod IsBleedingOut ::ActiveStoryNPC_var ::temp0 ;0 variable args
            jmpf ::temp0 _label7
            ; line 2978
            callmethod OnAmbushYield self ::nonevar ;0 variable args
            ; line 2979
            return None 
            jmp _label7
            ; line 2982
          _label7:
            callmethod IsInCombat ::ActiveStoryNPC_var ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label8
            ; line 2984
            callmethod GetActorBase ::ActiveStoryNPC_var ::temp6 ;0 variable args
            callmethod SetEssential ::temp6 ::nonevar False ;1 variable args
            ; line 2985
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Aggression" 0.0 ;2 variable args
            ; line 2986
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Confidence" 2.0 ;2 variable args
            ; line 2987
            assign ::mangled_endedNPC_0 ::ActiveStoryNPC_var 
            ; line 2988
            callstatic game GetPlayer ::temp1 ;0 variable args
            cast ::temp7 ::temp1 
            callmethod FinishArrivalWithLinger self ::nonevar ::mangled_endedNPC_0 ::temp7 ;2 variable args
            ; line 2989
            return None 
            jmp _label8
          _label8
          .endCode
        .endFunction ;CheckAmbushCombat
        .function OnAmbushYield
           ; function type 0
          .userFlags 0 ;none
          .docString "Ambusher is beaten down and yields -- stops combat, linger for dialogue."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local playerName String
            .local ::temp0 actor
            .local ::temp1 String
            .local ::nonevar None
            .local ::temp2 actorBase
            .local ::temp3 Float
            .local ::temp4 String
            .local yieldedNPC actor
            .local ::temp5 objectReference
          .endLocalTable
          .code
            ; line 2995
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod GetDisplayName ::temp0 ::temp1 ;0 variable args
            assign playerName ::temp1 
            ; line 2998
            callmethod GetActorBase ::ActiveStoryNPC_var ::temp2 ;0 variable args
            callmethod SetEssential ::temp2 ::nonevar False ;1 variable args
            ; line 3001
            callmethod StopCombat ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 3002
            callmethod StopCombatAlarm ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 3003
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Aggression" 0.0 ;2 variable args
            ; line 3004
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Confidence" 1.0 ;2 variable args
            ; line 3007
            callmethod RestoreActorValue ::ActiveStoryNPC_var ::nonevar "Health" 50.0 ;2 variable args
            ; line 3010
            strcat ::temp1 "was beaten in combat by " playerName 
            strcat ::temp1 ::temp1 " and yielded, begging for mercy" 
            callmethod InjectFact ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp1 ;2 variable args
            ; line 3013
            strcat ::temp1 "dropped to one knee and yielded to " playerName 
            strcat ::temp1 ::temp1 ", exhausted and beaten" 
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp1 ::temp0 ;3 variable args
            ; line 3015
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 "Story [ambush]: " ::temp1 
            strcat ::temp1 ::temp1 " yielded at " 
            callmethod GetActorValuePercentage ::ActiveStoryNPC_var ::temp3 "Health" ;1 variable args
            fmul ::temp3 ::temp3 100.0 
            cast ::temp4 ::temp3 
            strcat ::temp4 ::temp1 ::temp4 
            strcat ::temp4 ::temp4 "% health" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            ; line 3018
            assign yieldedNPC ::ActiveStoryNPC_var 
            ; line 3019
            callstatic game GetPlayer ::temp0 ;0 variable args
            cast ::temp5 ::temp0 
            callmethod FinishArrivalWithLinger self ::nonevar yieldedNPC ::temp5 ;2 variable args
          .endCode
        .endFunction ;OnAmbushYield
        .function OnStalkerDetected
           ; function type 0
          .userFlags 0 ;none
          .docString "Stalker detected by player: stop sneaking, narrate caught, linger for dialogue.
    No flee phase — TranslateTo ignores navmesh and breaks immersion."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local playerName String
            .local ::temp0 actor
            .local ::temp1 String
            .local npcName String
            .local ::temp2 Bool
            .local ::nonevar None
            .local ::temp3 objectReference
            .local caughtNPC actor
          .endLocalTable
          .code
            ; line 3025
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod GetDisplayName ::temp0 ::temp1 ;0 variable args
            assign playerName ::temp1 
            ; line 3026
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            assign npcName ::temp1 
            ; line 3029
            callmethod IsSneaking ::ActiveStoryNPC_var ::temp2 ;0 variable args
            jmpf ::temp2 _label0
            ; line 3030
            callmethod StartSneaking ::ActiveStoryNPC_var ::nonevar ;0 variable args
            jmp _label0
            ; line 3032
          _label0:
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic debug SendAnimationEvent ::nonevar ::temp3 "sneakStop" ;2 variable args
            ; line 3035
            strcat ::temp1 "was caught secretly following " playerName 
            callmethod InjectFact ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp1 ;2 variable args
            ; line 3036
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::ActiveNarration_var ::temp0 ;3 variable args
            ; line 3039
            callstatic game GetPlayer ::temp0 ;0 variable args
            strcat ::temp1 npcName " was caught secretly following " 
            strcat ::temp1 ::temp1 playerName 
            callmethod SendPersistentMemory ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp0 ::temp1 ;3 variable args
            ; line 3041
            strcat ::temp1 "stalker: " npcName 
            strcat ::temp1 ::temp1 " -- caught" 
            callmethod AddRecentStoryEvent self ::nonevar ::temp1 ;1 variable args
            ; line 3044
            assign caughtNPC ::ActiveStoryNPC_var 
            ; line 3047
            callstatic game GetPlayer ::temp0 ;0 variable args
            cast ::temp3 ::temp0 
            callmethod FinishArrivalWithLinger self ::nonevar caughtNPC ::temp3 ;2 variable args
            ; line 3049
            strcat ::temp1 "Story [stalker]: " npcName 
            strcat ::temp1 ::temp1 " caught - lingering for confrontation" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
          .endCode
        .endFunction ;OnStalkerDetected
        .function HandleQuestDispatch
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param npc actor
            .param narration String
            .param response String
          .endParamTable
          .localTable
            .local ::nonevar None
            .local senderName String
            .local ::temp0 String
            .local msgContent String
            .local questLocationStr String
            .local enemyType String
            .local questSubTypeStr String
            .local victimName String
            .local itemDesc String
            .local itemName String
            .local alliedFaction String
            .local suggestedEnemy String
            .local ::temp1 Bool
            .local ::temp2 actor
            .local victimActor actor
            .local factionMember actor
            .local ::temp3 String
            .local ::temp4 form
            .local ::temp5 Float
            .local factionName String
            .local playerName2 String
            .local questDest objectReference
            .local ::temp6 objectReference
            .local ::temp7 Int
            .local questGiverActor actor
            .local senderActor actor
            .local giverFaction String
            .local factionSub actor
            .local factionName2 String
            .local ::temp8 intelEngine_Battle
            .local ::temp9 intelEngine_Battle
            .local validateJson String
          .endLocalTable
          .code
            ; line 3057
            jmpf ::QuestActive_var _label0
            ; line 3058
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest rejected -- one already active" ;1 variable args
            ; line 3059
            return None 
            jmp _label0
            ; line 3062
          _label0:
            callmethod ExtractJsonField self ::temp0 response "sender" ;2 variable args
            assign senderName ::temp0 
            ; line 3063
            callmethod ExtractJsonField self ::temp0 response "msgContent" ;2 variable args
            assign msgContent ::temp0 
            ; line 3064
            callmethod ExtractJsonField self ::temp0 response "questLocation" ;2 variable args
            assign questLocationStr ::temp0 
            ; line 3065
            callmethod ExtractJsonField self ::temp0 response "enemyType" ;2 variable args
            assign enemyType ::temp0 
            ; line 3068
            callmethod ExtractJsonField self ::temp0 response "questSubType" ;2 variable args
            assign questSubTypeStr ::temp0 
            ; line 3069
            callmethod ExtractJsonField self ::temp0 response "victimName" ;2 variable args
            assign victimName ::temp0 
            ; line 3070
            callmethod ExtractJsonField self ::temp0 response "itemDesc" ;2 variable args
            assign itemDesc ::temp0 
            ; line 3071
            callmethod ExtractJsonField self ::temp0 response "itemName" ;2 variable args
            assign itemName ::temp0 
            ; line 3072
            callmethod ExtractJsonField self ::temp0 response "alliedFaction" ;2 variable args
            assign alliedFaction ::temp0 
            ; line 3073
            callmethod ExtractJsonField self ::temp0 response "enemyFaction" ;2 variable args
            assign suggestedEnemy ::temp0 
            ; line 3074
            cmp_eq ::temp1 questSubTypeStr "" 
            jmpf ::temp1 _label1
            ; line 3075
            assign questSubTypeStr "combat" 
            jmp _label1
            ; line 3079
          _label1:
            cast ::temp2 None 
            cmp_eq ::temp1 npc ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            callstatic intelEngine IsJarl ::temp1 npc ;1 variable args
            assign ::temp1 ::temp1 
          _label2:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label3
            cmp_eq ::temp1 senderName "" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label4
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            cmp_eq ::temp1 senderName ::temp0 
            assign ::temp1 ::temp1 
          _label4:
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label5
            ; line 3080
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Story DM: quest rejected -- Jarl " ::temp0 
            strcat ::temp0 ::temp0 " cannot deliver quest personally (needs courier)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3081
            return None 
            jmp _label5
            ; line 3084
          _label5:
            cmp_eq ::temp1 questLocationStr "" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label6
            cmp_eq ::temp1 enemyType "" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label7
            cmp_eq ::temp1 questSubTypeStr "faction_battle" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label7:
            assign ::temp1 ::temp1 
          _label6:
            jmpf ::temp1 _label8
            ; line 3085
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest missing questLocation or enemyType" ;1 variable args
            ; line 3086
            return None 
            jmp _label8
            ; line 3090
          _label8:
            cast ::temp2 None 
            assign victimActor ::temp2 
            ; line 3091
            cmp_eq ::temp1 questSubTypeStr "rescue" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label9
            cmp_eq ::temp1 questSubTypeStr "faction_rescue" 
            assign ::temp1 ::temp1 
          _label9:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label10
            cmp_eq ::temp1 victimName "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label10:
            jmpf ::temp1 _label11
            ; line 3092
            callstatic intelEngine FindNPCByName ::temp2 victimName ;1 variable args
            assign victimActor ::temp2 
            ; line 3093
            cast ::temp2 None 
            cmp_eq ::temp1 victimActor ::temp2 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label12
            callmethod IsDead victimActor ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label12:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label13
            callmethod IsDisabled victimActor ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label13:
            jmpf ::temp1 _label14
            ; line 3094
            strcat ::temp0 "Story DM: quest/rescue victim '" victimName 
            strcat ::temp0 ::temp0 "' not found or invalid, rejecting" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3095
            return None 
            jmp _label14
            ; line 3098
          _label14:
            cmp_eq ::temp1 victimActor npc 
            jmpf ::temp1 _label15
            ; line 3099
            strcat ::temp0 "Story DM: quest/rescue rejected -- victim '" victimName 
            strcat ::temp0 ::temp0 "' is the courier NPC" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3100
            return None 
            jmp _label15
            ; line 3102
          _label15:
            cmp_eq ::temp1 senderName "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label16
            cmp_eq ::temp1 victimName senderName 
            assign ::temp1 ::temp1 
          _label16:
            jmpf ::temp1 _label17
            ; line 3103
            strcat ::temp0 "Story DM: quest/rescue rejected -- victim '" victimName 
            strcat ::temp0 ::temp0 "' is the quest giver" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3104
            return None 
            jmp _label17
            ; line 3109
          _label17:
            callmethod IsPlayerTeammate victimActor ::temp1 ;0 variable args
            jmpf ::temp1 _label18
            ; line 3110
            strcat ::temp0 "Story DM: quest/rescue rejected -- victim '" victimName 
            strcat ::temp0 ::temp0 "' is the player's teammate" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3111
            return None 
            jmp _label18
            ; line 3114
          _label18:
            callmethod IEB_StoryBlocked self ::temp1 victimActor 2 ;2 variable args
            jmpf ::temp1 _label19
            ; line 3115
            strcat ::temp0 "Story DM: quest/rescue rejected -- victim '" victimName 
            strcat ::temp0 ::temp0 "' is committed to a quest" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3116
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "npc is committed to a quest" ;1 variable args
            ; line 3117
            return None 
            jmp _label19
            ; line 3120
          _label19:
            callstatic intelEngine IsActorOnStoryCooldown ::temp1 victimActor ;1 variable args
            jmpf ::temp1 _label20
            ; line 3121
            strcat ::temp0 "Story DM: quest/rescue rejected -- victim '" victimName 
            strcat ::temp0 ::temp0 "' is on story cooldown" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3122
            return None 
            jmp _label20
          _label20:
            jmp _label21
            ; line 3124
          _label11:
            cmp_eq ::temp1 questSubTypeStr "rescue" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label22
            cmp_eq ::temp1 questSubTypeStr "faction_rescue" 
            assign ::temp1 ::temp1 
          _label22:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label23
            cmp_eq ::temp1 victimName "" 
            assign ::temp1 ::temp1 
          _label23:
            jmpf ::temp1 _label21
            ; line 3125
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest/rescue rejected -- no victimName" ;1 variable args
            ; line 3126
            return None 
            jmp _label21
            ; line 3130
          _label21:
            cmp_eq ::temp1 questSubTypeStr "find_item" 
            jmpf ::temp1 _label24
            ; line 3131
            cmp_eq ::temp1 itemName "" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label25
            callstatic intelEngine ValidateQuestItem ::temp1 itemName ;1 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label25:
            jmpf ::temp1 _label26
            ; line 3133
            callstatic intelEngine GetRandomQuestItemName ::temp0 500 ;1 variable args
            assign itemName ::temp0 
            ; line 3134
            cmp_eq ::temp1 itemName "" 
            jmpf ::temp1 _label27
            ; line 3135
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest/find_item rejected -- no valid item found" ;1 variable args
            ; line 3136
            return None 
            jmp _label27
            ; line 3138
          _label27:
            strcat ::temp0 "Story DM: quest/find_item -- LLM item not found, using fallback: " itemName 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            jmp _label26
          _label26:
            jmp _label24
            ; line 3143
          _label24:
            cmp_eq ::temp1 alliedFaction "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label28
            cast ::temp2 None 
            cmp_eq ::temp1 npc ::temp2 
            assign ::temp1 ::temp1 
          _label28:
            jmpf ::temp1 _label29
            ; line 3144
            callstatic intelEngine FindFactionMember ::temp2 alliedFaction ;1 variable args
            assign factionMember ::temp2 
            ; line 3145
            cast ::temp2 None 
            cmp_eq ::temp1 factionMember ::temp2 
            jmpf ::temp1 _label30
            ; line 3146
            strcat ::temp0 "Story DM: quest/" questSubTypeStr 
            strcat ::temp0 ::temp0 " rejected -- no loaded " 
            strcat ::temp0 ::temp0 alliedFaction 
            strcat ::temp0 ::temp0 " member found" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3147
            return None 
            jmp _label30
            ; line 3150
          _label30:
            callmethod IEB_StoryBlocked self ::temp1 factionMember 1 ;2 variable args
            jmpf ::temp1 _label31
            ; line 3151
            strcat ::temp0 "Story DM: quest/" questSubTypeStr 
            strcat ::temp0 ::temp0 " rejected -- faction member " 
            callmethod GetDisplayName factionMember ::temp3 ;0 variable args
            strcat ::temp3 ::temp0 ::temp3 
            strcat ::temp3 ::temp3 " is committed to a quest" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 3152
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "npc is committed to a quest" ;1 variable args
            ; line 3153
            return None 
            jmp _label31
            ; line 3156
          _label31:
            cast ::temp2 None 
            cmp_eq ::temp1 victimActor ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label32
            cmp_eq ::temp1 factionMember victimActor 
            assign ::temp1 ::temp1 
          _label32:
            jmpf ::temp1 _label33
            ; line 3157
            strcat ::temp3 "Story DM: quest/" questSubTypeStr 
            strcat ::temp3 ::temp3 " rejected -- only loaded " 
            strcat ::temp3 ::temp3 alliedFaction 
            strcat ::temp3 ::temp3 " member is the rescue victim" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 3158
            return None 
            jmp _label33
            ; line 3160
          _label33:
            assign npc factionMember 
            ; line 3163
            cast ::temp4 npc 
            callmethod GetActorValue npc ::temp5 "Aggression" ;1 variable args
            callstatic storageUtil SetFloatValue ::temp5 ::temp4 "Intel_OrigAggression" ::temp5 ;3 variable args
            ; line 3164
            callmethod SetActorValue npc ::nonevar "Aggression" 0.0 ;2 variable args
            ; line 3167
            callstatic intelEngine GetFactionDisplayName ::temp3 alliedFaction ;1 variable args
            assign factionName ::temp3 
            ; line 3168
            callmethod BuildFactionQuestNarration self ::temp3 factionName questLocationStr ;2 variable args
            assign narration ::temp3 
            ; line 3169
            strcat ::temp3 "Story DM: quest/" questSubTypeStr 
            strcat ::temp3 ::temp3 " -- faction member " 
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 ::temp3 ::temp0 
            strcat ::temp0 ::temp0 " selected for " 
            strcat ::temp0 ::temp0 alliedFaction 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3171
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDisplayName ::temp2 ::temp0 ;0 variable args
            assign playerName2 ::temp0 
            ; line 3172
            callstatic intelEngine NPCKnowsPlayer ::temp1 npc ;1 variable args
            jmpf ::temp1 _label34
            ; line 3173
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 ::temp0 " set out to find " 
            strcat ::temp0 ::temp0 playerName2 
            strcat ::temp0 ::temp0 " with urgent orders from " 
            strcat ::temp0 ::temp0 factionName 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc ::temp2 ::temp0 ;3 variable args
            jmp _label35
            ; line 3175
          _label34:
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 ::temp0 " was sent to find a warrior described as '" 
            strcat ::temp0 ::temp0 playerName2 
            strcat ::temp0 ::temp0 "' — never met them personally, only knows them by reputation and description" 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc ::temp2 ::temp0 ;3 variable args
            ; line 3176
            strcat ::temp0 "has never met " playerName2 
            strcat ::temp0 ::temp0 " before — was given a physical description and told to look for them. Should introduce themselves and confirm identity before delivering the message." 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp0 ;2 variable args
          _label35:
            jmp _label29
            ; line 3180
          _label29:
            callstatic intelEngine ResolveAnyDestination ::temp6 npc questLocationStr ;2 variable args
            assign questDest ::temp6 
            ; line 3181
            cast ::temp6 None 
            cmp_eq ::temp1 questDest ::temp6 
            jmpf ::temp1 _label36
            ; line 3182
            strcat ::temp0 "Story DM: quest location '" questLocationStr 
            strcat ::temp0 ::temp0 "' could not be resolved" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3183
            return None 
            jmp _label36
            ; line 3185
          _label36:
            callstatic intelEngine IsLocationNonCombative ::temp1 questDest ;1 variable args
            jmpf ::temp1 _label37
            ; line 3186
            strcat ::temp0 "Story DM: quest location '" questLocationStr 
            strcat ::temp0 ::temp0 "' is non-combative (temple/castle/guild) — rejecting" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3187
            return None 
            jmp _label37
            ; line 3192
          _label37:
            callmethod FindFreeAgentSlot ::Core_var ::temp7 ;0 variable args
            cmp_lt ::temp1 ::temp7 0 
            jmpf ::temp1 _label38
            ; line 3193
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest rejected -- no free slots" ;1 variable args
            ; line 3194
            return None 
            jmp _label38
            ; line 3198
          _label38:
            assign questGiverActor npc 
            ; line 3199
            cmp_eq ::temp1 senderName "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label39
            ; line 3200
            callstatic intelEngine FindNPCByName ::temp2 senderName ;1 variable args
            assign senderActor ::temp2 
            ; line 3201
            cast ::temp2 None 
            cmp_eq ::temp1 senderActor ::temp2 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label40
            ; line 3202
            assign questGiverActor senderActor 
            jmp _label40
          _label40:
            jmp _label39
            ; line 3209
          _label39:
            cmp_eq ::temp1 alliedFaction "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label41
            cast ::temp2 None 
            cmp_eq ::temp1 questGiverActor ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label41:
            jmpf ::temp1 _label42
            ; line 3210
            callstatic intelEngine GetNPCPoliticalFactionId ::temp0 questGiverActor ;1 variable args
            assign giverFaction ::temp0 
            ; line 3211
            cmp_eq ::temp1 giverFaction alliedFaction 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label43
            ; line 3212
            callstatic intelEngine FindFactionMember ::temp2 alliedFaction ;1 variable args
            assign factionSub ::temp2 
            ; line 3213
            cast ::temp2 None 
            cmp_eq ::temp1 factionSub ::temp2 
            jmpf ::temp1 _label44
            ; line 3214
            strcat ::temp0 "Story DM: quest/" questSubTypeStr 
            strcat ::temp0 ::temp0 " rejected -- no loaded " 
            strcat ::temp0 ::temp0 alliedFaction 
            strcat ::temp0 ::temp0 " member found" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3215
            return None 
            jmp _label44
            ; line 3218
          _label44:
            callmethod IEB_StoryBlocked self ::temp1 factionSub 1 ;2 variable args
            jmpf ::temp1 _label45
            ; line 3219
            strcat ::temp0 "Story DM: quest/" questSubTypeStr 
            strcat ::temp0 ::temp0 " rejected -- substitute " 
            callmethod GetDisplayName factionSub ::temp3 ;0 variable args
            strcat ::temp3 ::temp0 ::temp3 
            strcat ::temp3 ::temp3 " is committed to a quest" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 3220
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "npc is committed to a quest" ;1 variable args
            ; line 3221
            return None 
            jmp _label45
            ; line 3223
          _label45:
            cast ::temp2 None 
            cmp_eq ::temp1 victimActor ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label46
            cmp_eq ::temp1 factionSub victimActor 
            assign ::temp1 ::temp1 
          _label46:
            jmpf ::temp1 _label47
            ; line 3224
            strcat ::temp3 "Story DM: quest/" questSubTypeStr 
            strcat ::temp3 ::temp3 " rejected -- only loaded " 
            strcat ::temp3 ::temp3 alliedFaction 
            strcat ::temp3 ::temp3 " member is the rescue victim" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 3225
            return None 
            jmp _label47
            ; line 3227
          _label47:
            callmethod ApplyCooldownCheck self ::temp1 factionSub ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label48
            ; line 3228
            strcat ::temp3 "Story DM: quest/" questSubTypeStr 
            strcat ::temp3 ::temp3 " rejected -- substitute faction member " 
            callmethod GetDisplayName factionSub ::temp0 ;0 variable args
            strcat ::temp0 ::temp3 ::temp0 
            strcat ::temp0 ::temp0 " on cooldown" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3229
            return None 
            jmp _label48
            ; line 3231
          _label48:
            strcat ::temp0 "Story DM: quest/" questSubTypeStr 
            strcat ::temp0 ::temp0 " -- substituting " 
            callmethod GetDisplayName questGiverActor ::temp3 ;0 variable args
            strcat ::temp3 ::temp0 ::temp3 
            strcat ::temp3 ::temp3 " with faction member " 
            callmethod GetDisplayName factionSub ::temp0 ;0 variable args
            strcat ::temp0 ::temp3 ::temp0 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3232
            assign questGiverActor factionSub 
            ; line 3233
            assign npc factionSub 
            ; line 3234
            callstatic intelEngine GetFactionDisplayName ::temp0 alliedFaction ;1 variable args
            assign factionName2 ::temp0 
            ; line 3235
            callmethod BuildFactionQuestNarration self ::temp0 factionName2 questLocationStr ;2 variable args
            assign narration ::temp0 
            jmp _label43
          _label43:
            jmp _label42
            ; line 3240
          _label42:
            cmp_eq ::temp1 questSubTypeStr "faction_battle" 
            jmpf ::temp1 _label49
            ; line 3241
            propget Battle ::Core_var ::temp8 
            cast ::temp9 None 
            cmp_eq ::temp1 ::temp8 ::temp9 
            jmpf ::temp1 _label50
            ; line 3242
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest/faction_battle rejected -- Battle quest not set (check CK property)" ;1 variable args
            ; line 3243
            return None 
            jmp _label50
            ; line 3245
          _label50:
            callstatic intelEngine ValidateFactionBattleDispatch ::temp0 alliedFaction suggestedEnemy ;2 variable args
            assign validateJson ::temp0 
            ; line 3246
            callstatic intelEngine StoryResponseGetField ::temp0 validateJson "canStart" ;2 variable args
            cmp_eq ::temp1 ::temp0 "true" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label51
            ; line 3247
            callstatic intelEngine StoryResponseGetField ::temp0 validateJson "failReason" ;2 variable args
            strcat ::temp0 "Story DM: quest/faction_battle rejected -- " ::temp0 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3248
            return None 
            jmp _label51
            ; line 3251
          _label51:
            callstatic intelEngine StoryResponseGetField ::temp0 validateJson "enemyFaction" ;2 variable args
            assign ::QuestBattleEnemyFaction_var ::temp0 
            ; line 3252
            strcat ::temp0 "Story DM: faction_battle enemy = " ::QuestBattleEnemyFaction_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3254
            propget Battle ::Core_var ::temp9 
            propget BattleScheduled ::temp9 ::temp1 
            jmpf ::temp1 _label52
            ; line 3255
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest/faction_battle rejected -- battle system busy (scheduled)" ;1 variable args
            ; line 3256
            return None 
            jmp _label52
          _label52:
            jmp _label49
            ; line 3261
          _label49:
            cmp_eq ::temp1 questSubTypeStr "faction_battle" 
            jmpf ::temp1 _label53
            ; line 3262
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDisplayName ::temp2 ::temp0 ;0 variable args
            callstatic intelEngine BuildFactionBattleDispatchFact ::temp0 alliedFaction questLocationStr ::temp0 ;3 variable args
            callmethod InjectFact ::Core_var ::nonevar questGiverActor ::temp0 ;2 variable args
            jmp _label54
            ; line 3264
          _label53:
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDisplayName ::temp2 ::temp0 ;0 variable args
            strcat ::temp0 "asked " ::temp0 
            strcat ::temp0 ::temp0 " for help: " 
            strcat ::temp0 ::temp0 msgContent 
            callmethod InjectFact ::Core_var ::nonevar questGiverActor ::temp0 ;2 variable args
            ; line 3268
          _label54:
            cmp_eq ::temp1 questGiverActor npc 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label55
            ; line 3269
            callmethod GetDisplayName questGiverActor ::temp0 ;0 variable args
            strcat ::temp0 "was sent to deliver a plea for help from " ::temp0 
            strcat ::temp0 ::temp0 " about " 
            strcat ::temp0 ::temp0 enemyType 
            strcat ::temp0 ::temp0 " trouble near " 
            strcat ::temp0 ::temp0 questLocationStr 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp0 ;2 variable args
            jmp _label55
            ; line 3273
          _label55:
            assign ::QuestActive_var True 
            ; line 3274
            assign ::QuestGiver_var questGiverActor 
            ; line 3275
            assign ::QuestLocation_var questDest 
            ; line 3276
            assign ::QuestEnemyType_var enemyType 
            ; line 3277
            assign ::QuestLocationName_var questLocationStr 
            ; line 3278
            assign ::QuestEnemiesSpawned_var False 
            ; line 3279
            assign ::QuestGuideActive_var False 
            ; line 3280
            assign ::QuestGuideWaiting_var False 
            ; line 3281
            callstatic utility GetCurrentGameTime ::temp5 ;0 variable args
            assign ::QuestStartTime_var ::temp5 
            ; line 3282
            assign ::QuestSpawnCount_var 0 
            ; line 3287
            assign ::QuestAlliedFaction_var alliedFaction 
            ; line 3292
            cmp_eq ::temp1 alliedFaction "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label56
            ; line 3293
            callstatic intelEngine RemovePlayerCrimeFactions ::nonevar ;0 variable args
            jmp _label56
            ; line 3295
          _label56:
            cmp_eq ::temp1 questSubTypeStr "faction_combat" 
            jmpf ::temp1 _label57
            ; line 3296
            assign questSubTypeStr "combat" 
            jmp _label58
            ; line 3297
          _label57:
            cmp_eq ::temp1 questSubTypeStr "faction_rescue" 
            jmpf ::temp1 _label58
            ; line 3298
            assign questSubTypeStr "rescue" 
            jmp _label58
            ; line 3302
          _label58:
            cmp_eq ::temp1 questSubTypeStr "rescue" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label59
            cast ::temp2 None 
            cmp_eq ::temp1 victimActor ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label59:
            jmpf ::temp1 _label60
            ; line 3303
            strcat ::temp0 "was captured by " enemyType 
            strcat ::temp0 ::temp0 " near " 
            strcat ::temp0 ::temp0 questLocationStr 
            strcat ::temp0 ::temp0 " and held against my will" 
            callmethod InjectFact ::Core_var ::nonevar victimActor ::temp0 ;2 variable args
            jmp _label60
            ; line 3307
          _label60:
            assign ::QuestSubType_var questSubTypeStr 
            ; line 3308
            assign ::QuestBriefing_var msgContent 
            ; line 3309
            assign ::QuestVictimNPC_var victimActor 
            ; line 3310
            assign ::QuestVictimName_var victimName 
            ; line 3311
            assign ::QuestItemDesc_var itemDesc 
            ; line 3312
            assign ::QuestItemName_var itemName 
            ; line 3313
            assign ::QuestVictimFreed_var False 
            ; line 3314
            cast ::temp6 None 
            assign ::QuestItemChest_var ::temp6 
            ; line 3317
            cmp_eq ::temp1 questLocationStr "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label61
            ; line 3318
            callstatic intelEngine NotifyQuestLocationUsed ::nonevar questLocationStr ;1 variable args
            jmp _label61
            ; line 3320
          _label61:
            cmp_eq ::temp1 questSubTypeStr "find_item" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label62
            cmp_eq ::temp1 itemName "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label62:
            jmpf ::temp1 _label63
            ; line 3321
            callstatic intelEngine NotifyQuestItemUsed ::nonevar itemName ;1 variable args
            jmp _label63
            ; line 3323
          _label63:
            cmp_eq ::temp1 questSubTypeStr "rescue" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label64
            cmp_eq ::temp1 victimName "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label64:
            jmpf ::temp1 _label65
            ; line 3324
            callstatic intelEngine NotifyRescueVictimUsed ::nonevar victimName ;1 variable args
            jmp _label65
            ; line 3327
          _label65:
            cast ::temp4 npc 
            callstatic storageUtil SetStringValue ::temp0 ::temp4 "Intel_MessageSender" senderName ;3 variable args
            ; line 3328
            cast ::temp4 npc 
            callstatic storageUtil SetStringValue ::temp0 ::temp4 "Intel_MessageContent" msgContent ;3 variable args
            ; line 3329
            cast ::temp4 npc 
            callstatic storageUtil SetStringValue ::temp0 ::temp4 "Intel_QuestLocation" questLocationStr ;3 variable args
            ; line 3333
            callmethod GetDisplayName questGiverActor ::temp0 ;0 variable args
            callstatic intelEngine NotifyQuestActive ::nonevar ::QuestLocationName_var ::QuestSubType_var ::QuestEnemyType_var ::temp0 msgContent victimName itemName alliedFaction ;8 variable args
            ; line 3335
            assign ::ActiveStoryType_var "quest" 
            ; line 3336
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod DispatchToTarget self ::nonevar npc ::temp2 narration "story" ;4 variable args
          .endCode
        .endFunction ;HandleQuestDispatch
        .function OnQuestNPCArrived
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local senderName String
            .local ::temp0 form
            .local ::temp1 String
            .local msgContent String
            .local questLoc String
            .local ::temp2 Bool
            .local fullNarration String
            .local ::nonevar None
            .local ::temp3 actor
            .local isDirect Bool
            .local ::temp4 objectReference
            .local ::temp5 objectReference
            .local ::temp6 keyword
            .local ::temp7 package
            .local ::temp8 Int
            .local questSlot Int
            .local questPromptText String
            .local allyName String
            .local allyName2 String
            .local choice String
            .local canGuide Bool
            .local refusedNPC actor
          .endLocalTable
          .code
            ; line 3340
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_MessageSender" "" ;3 variable args
            assign senderName ::temp1 
            ; line 3341
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_MessageContent" "" ;3 variable args
            assign msgContent ::temp1 
            ; line 3342
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_QuestLocation" "" ;3 variable args
            assign questLoc ::temp1 
            ; line 3345
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp2 ::temp0 "Intel_MessageSender" ;2 variable args
            ; line 3346
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp2 ::temp0 "Intel_MessageContent" ;2 variable args
            ; line 3347
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp2 ::temp0 "Intel_QuestLocation" ;2 variable args
            ; line 3350
            assign fullNarration "" 
            ; line 3351
            cmp_eq ::temp2 senderName "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label0
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            cmp_eq ::temp2 senderName ::temp1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label0:
            jmpf ::temp2 _label1
            ; line 3352
            strcat ::temp1 "delivered word from " senderName 
            strcat ::temp1 ::temp1 ": " 
            strcat ::temp1 ::temp1 msgContent 
            assign fullNarration ::temp1 
            jmp _label2
            ; line 3354
          _label1:
            assign fullNarration ::ActiveNarration_var 
            ; line 3356
          _label2:
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var fullNarration ::temp3 ;3 variable args
            ; line 3358
            cmp_eq ::temp2 senderName "" 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label3
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            cmp_eq ::temp2 senderName ::temp1 
            assign ::temp2 ::temp2 
          _label3:
            assign isDirect ::temp2 
            ; line 3366
            assign ::IsActive_var False 
            ; line 3370
            cast ::temp4 ::ActiveStoryNPC_var 
            cast ::temp5 ::ActiveStoryNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp6 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp4 ::temp5 ::temp6 ;3 variable args
            ; line 3371
            propget SandboxNearPlayerPackage ::Core_var ::temp7 
            propget PRIORITY_TRAVEL ::Core_var ::temp8 
            callstatic actorUtil AddPackageOverride ::nonevar ::ActiveStoryNPC_var ::temp7 ::temp8 1 ;4 variable args
            ; line 3372
            callmethod EvaluatePackage ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 3374
            callstatic utility Wait ::nonevar 8.0 ;1 variable args
            ; line 3375
            callstatic debug Notification ::nonevar "They seem to have more to ask..." ;1 variable args
            ; line 3377
            cast ::temp3 None 
            cmp_eq ::temp2 ::ActiveStoryNPC_var ::temp3 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label4
            callmethod IsDead ::ActiveStoryNPC_var ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
          _label4:
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label5
            callmethod IsInCombat ::ActiveStoryNPC_var ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
          _label5:
            jmpf ::temp2 _label6
            ; line 3378
            cast ::temp3 None 
            cmp_eq ::temp2 ::ActiveStoryNPC_var ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label7
            ; line 3379
            callmethod FindSlotByAgent ::Core_var ::temp8 ::ActiveStoryNPC_var ;1 variable args
            assign questSlot ::temp8 
            ; line 3380
            comp_gte ::temp2 questSlot 0 
            jmpf ::temp2 _label8
            ; line 3381
            callmethod ClearSlot ::Core_var ::nonevar questSlot True False ;3 variable args
            jmp _label8
            ; line 3383
          _label8:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            jmp _label7
            ; line 3385
          _label7:
            callmethod CleanupQuest self ::nonevar ;0 variable args
            ; line 3386
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 3387
            return None 
            jmp _label6
            ; line 3390
          _label6:
            callmethod FindSlotByAgent ::Core_var ::temp8 ::ActiveStoryNPC_var ;1 variable args
            cmp_lt ::temp2 ::temp8 0 
            jmpf ::temp2 _label9
            ; line 3391
            callmethod CleanupQuest self ::nonevar ;0 variable args
            ; line 3392
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 3393
            return None 
            jmp _label9
            ; line 3396
          _label9:
            propget SandboxNearPlayerPackage ::Core_var ::temp7 
            callstatic actorUtil RemovePackageOverride ::temp2 ::ActiveStoryNPC_var ::temp7 ;2 variable args
            ; line 3398
            assign questPromptText "" 
            ; line 3399
            cmp_eq ::temp2 ::QuestSubType_var "rescue" 
            jmpf ::temp2 _label10
            ; line 3400
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp1 " pleads for help rescuing " 
            strcat ::temp1 ::temp1 ::QuestVictimName_var 
            strcat ::temp1 ::temp1 " near " 
            strcat ::temp1 ::temp1 questLoc 
            strcat ::temp1 ::temp1 "." 
            assign questPromptText ::temp1 
            jmp _label11
            ; line 3401
          _label10:
            cmp_eq ::temp2 ::QuestSubType_var "find_item" 
            jmpf ::temp2 _label12
            ; line 3402
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp1 " tells you about " 
            strcat ::temp1 ::temp1 ::QuestItemDesc_var 
            strcat ::temp1 ::temp1 " near " 
            strcat ::temp1 ::temp1 questLoc 
            strcat ::temp1 ::temp1 "." 
            assign questPromptText ::temp1 
            jmp _label11
            ; line 3403
          _label12:
            cmp_eq ::temp2 ::QuestSubType_var "faction_battle" 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label13
            cmp_eq ::temp2 ::QuestAlliedFaction_var "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label14
            cmp_eq ::temp2 ::QuestSubType_var "combat" 
            assign ::temp2 ::temp2 
          _label14:
            assign ::temp2 ::temp2 
          _label13:
            jmpf ::temp2 _label15
            ; line 3404
            callstatic intelEngine GetFactionDisplayName ::temp1 ::QuestAlliedFaction_var ;1 variable args
            assign allyName ::temp1 
            ; line 3405
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp1 " rallies you to fight alongside the " 
            strcat ::temp1 ::temp1 allyName 
            strcat ::temp1 ::temp1 " near " 
            strcat ::temp1 ::temp1 questLoc 
            strcat ::temp1 ::temp1 "." 
            assign questPromptText ::temp1 
            jmp _label11
            ; line 3406
          _label15:
            cmp_eq ::temp2 ::QuestAlliedFaction_var "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label16
            cmp_eq ::temp2 ::QuestSubType_var "rescue" 
            assign ::temp2 ::temp2 
          _label16:
            jmpf ::temp2 _label17
            ; line 3407
            callstatic intelEngine GetFactionDisplayName ::temp1 ::QuestAlliedFaction_var ;1 variable args
            assign allyName2 ::temp1 
            ; line 3408
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp1 " urges you to rescue " 
            strcat ::temp1 ::temp1 ::QuestVictimName_var 
            strcat ::temp1 ::temp1 " for the " 
            strcat ::temp1 ::temp1 allyName2 
            strcat ::temp1 ::temp1 " near " 
            strcat ::temp1 ::temp1 questLoc 
            strcat ::temp1 ::temp1 "." 
            assign questPromptText ::temp1 
            jmp _label11
            ; line 3410
          _label17:
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp1 " tells you about trouble near " 
            strcat ::temp1 ::temp1 questLoc 
            strcat ::temp1 ::temp1 "." 
            assign questPromptText ::temp1 
            ; line 3413
          _label11:
            assign choice "" 
            ; line 3416
            assign ::temp2 isDirect 
            jmpf ::temp2 _label18
            callmethod IsPlayerTeammate ::ActiveStoryNPC_var ::temp2 ;0 variable args
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label18:
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label19
            cmp_eq ::temp2 ::QuestAlliedFaction_var "" 
            assign ::temp2 ::temp2 
          _label19:
            assign canGuide ::temp2 
            ; line 3417
            jmpf canGuide _label20
            ; line 3418
            callstatic skyMessage Show ::temp1 questPromptText "Lead the way" "I'll go alone" "Not interested" "" "" "" "" "" "" "" False 0.100000001 0.0 ;14 variable args
            assign choice ::temp1 
            jmp _label21
            ; line 3420
          _label20:
            callstatic skyMessage Show ::temp1 questPromptText "I'll check it out" "Not interested" "" "" "" "" "" "" "" "" False 0.100000001 0.0 ;14 variable args
            assign choice ::temp1 
            ; line 3422
            cmp_eq ::temp2 choice "I'll check it out" 
            jmpf ::temp2 _label21
            ; line 3423
            assign choice "I'll go alone" 
            jmp _label21
            ; line 3426
          _label21:
            cmp_eq ::temp2 choice "Lead the way" 
            jmpf ::temp2 _label22
            ; line 3427
            callmethod PrePlaceQuestTargets self ::nonevar ;0 variable args
            ; line 3428
            callmethod PlaceQuestMarker self ::nonevar ;0 variable args
            ; line 3429
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 "quest: " ::temp1 
            strcat ::temp1 ::temp1 " guiding to " 
            strcat ::temp1 ::temp1 questLoc 
            callmethod AddRecentStoryEvent self ::nonevar ::temp1 ;1 variable args
            ; line 3430
            callmethod BeginQuestGuide self ::nonevar ::ActiveStoryNPC_var ;1 variable args
            ; line 3431
            return None 
            jmp _label23
            ; line 3432
          _label22:
            cmp_eq ::temp2 choice "Not interested" 
            jmpf ::temp2 _label23
            ; line 3434
            assign refusedNPC ::ActiveStoryNPC_var 
            ; line 3435
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod GetDisplayName ::temp3 ::temp1 ;0 variable args
            strcat ::temp1 "was told that " ::temp1 
            strcat ::temp1 ::temp1 " wasn't interested in helping" 
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar refusedNPC ::temp1 ::temp3 ;3 variable args
            ; line 3437
            cast ::temp3 None 
            cmp_eq ::temp2 ::QuestGiver_var ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label24
            ; line 3438
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod GetDisplayName ::temp3 ::temp1 ;0 variable args
            strcat ::temp1 "learned that " ::temp1 
            strcat ::temp1 ::temp1 " refused to help with the " 
            strcat ::temp1 ::temp1 ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " threat at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp1 ;2 variable args
            jmp _label24
            ; line 3440
          _label24:
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 3441
            callmethod CleanupQuest self ::nonevar ;0 variable args
            ; line 3442
            callstatic game GetPlayer ::temp3 ;0 variable args
            cast ::temp5 ::temp3 
            callmethod FinishArrivalWithLinger self ::nonevar refusedNPC ::temp5 ;2 variable args
            ; line 3443
            return None 
            jmp _label23
            ; line 3446
          _label23:
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod GetDisplayName ::temp3 ::temp1 ;0 variable args
            strcat ::temp1 "was told that " ::temp1 
            strcat ::temp1 ::temp1 " would handle it" 
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp1 ::temp3 ;3 variable args
            ; line 3447
            strcat ::temp1 "Quest: " msgContent 
            strcat ::temp1 ::temp1 " [" 
            strcat ::temp1 ::temp1 questLoc 
            strcat ::temp1 ::temp1 "]" 
            callmethod NotifyPlayer ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 3450
            callmethod PrePlaceQuestTargets self ::nonevar ;0 variable args
            ; line 3452
            callmethod PlaceQuestMarker self ::nonevar ;0 variable args
            ; line 3453
            strcat ::temp1 "quest: " ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " at " 
            strcat ::temp1 ::temp1 questLoc 
            callmethod AddRecentStoryEvent self ::nonevar ::temp1 ;1 variable args
            ; line 3456
            assign ::ActiveStoryType_var "" 
            ; line 3457
            callstatic game GetPlayer ::temp3 ;0 variable args
            cast ::temp5 ::temp3 
            callmethod FinishArrivalWithLinger self ::nonevar ::ActiveStoryNPC_var ::temp5 ;2 variable args
          .endCode
        .endFunction ;OnQuestNPCArrived
        .function BeginQuestGuide
           ; function type 0
          .userFlags 0 ;none
          .docString "NPC jogs WITH the player to the quest location."
          .return None
          .paramTable
            .param guideNPC actor
          .endParamTable
          .localTable
            .local ::temp0 Float
            .local ::nonevar None
            .local ::temp1 objectReference
            .local ::temp2 keyword
            .local ::temp3 package
            .local ::temp4 Int
            .local slot Int
            .local ::temp5 Bool
            .local guideDist Float
            .local ::temp6 String
            .local ::temp7 String
          .endLocalTable
          .code
            ; line 3466
            assign ::QuestGuideNPC_var guideNPC 
            ; line 3467
            assign ::QuestGuideActive_var True 
            ; line 3468
            assign ::QuestGuideWaiting_var False 
            ; line 3469
            callstatic utility GetCurrentGameTime ::temp0 ;0 variable args
            assign ::QuestGuideStartTime_var ::temp0 
            ; line 3472
            assign ::ActiveStoryType_var "quest_guide" 
            ; line 3473
            assign ::ActiveStoryNPC_var guideNPC 
            ; line 3474
            assign ::IsActive_var True 
            ; line 3475
            callstatic utility GetCurrentGameTime ::temp0 ;0 variable args
            callstatic intelEngine MarkSystemPending ::nonevar "storyDM" ::temp0 ;2 variable args
            ; line 3479
            callmethod DismissFollowerForTask ::Core_var ::nonevar guideNPC ;1 variable args
            ; line 3480
            cast ::temp1 guideNPC 
            propget IntelEngine_TravelTarget ::Core_var ::temp2 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp1 ::QuestLocation_var ::temp2 ;3 variable args
            ; line 3481
            propget TravelPackage_Jog ::Core_var ::temp3 
            propget PRIORITY_TRAVEL ::Core_var ::temp4 
            callstatic actorUtil AddPackageOverride ::nonevar guideNPC ::temp3 ::temp4 1 ;4 variable args
            ; line 3482
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 3483
            callmethod EvaluatePackage guideNPC ::nonevar ;0 variable args
            ; line 3486
            callmethod FindSlotByAgent ::Core_var ::temp4 guideNPC ;1 variable args
            assign slot ::temp4 
            ; line 3487
            comp_gte ::temp5 slot 0 
            jmpf ::temp5 _label0
            ; line 3488
            callmethod InitializeStuckTrackingForSlot ::Core_var ::nonevar slot guideNPC ;2 variable args
            ; line 3489
            callmethod InitOffScreenTracking ::Core_var ::nonevar slot guideNPC ::QuestLocation_var ;3 variable args
            jmp _label0
            ; line 3492
          _label0:
            assign guideDist 0.0 
            ; line 3493
            callmethod Is3DLoaded ::QuestLocation_var ::temp5 ;0 variable args
            assign ::temp5 ::temp5 
            jmpf ::temp5 _label1
            callmethod Is3DLoaded guideNPC ::temp5 ;0 variable args
            assign ::temp5 ::temp5 
          _label1:
            jmpf ::temp5 _label2
            ; line 3494
            callmethod GetDistance guideNPC ::temp0 ::QuestLocation_var ;1 variable args
            assign guideDist ::temp0 
            jmp _label2
            ; line 3496
          _label2:
            callmethod GetDisplayName guideNPC ::temp6 ;0 variable args
            strcat ::temp6 "Story [quest_guide]: " ::temp6 
            strcat ::temp6 ::temp6 " guiding player to " 
            strcat ::temp6 ::temp6 ::QuestLocationName_var 
            strcat ::temp6 ::temp6 " (dist=" 
            cast ::temp7 guideDist 
            strcat ::temp7 ::temp6 ::temp7 
            strcat ::temp7 ::temp7 ", loaded=" 
            callmethod Is3DLoaded ::QuestLocation_var ::temp5 ;0 variable args
            cast ::temp6 ::temp5 
            strcat ::temp6 ::temp7 ::temp6 
            strcat ::temp6 ::temp6 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp6 ;1 variable args
            ; line 3497
            propget MONITOR_INTERVAL self ::temp0 
            callmethod RegisterForSingleUpdate self ::nonevar ::temp0 ;1 variable args
          .endCode
        .endFunction ;BeginQuestGuide
        .function CheckQuestGuide
           ; function type 0
          .userFlags 0 ;none
          .docString "Monitor guide NPC: wait if player falls behind, resume when close, trigger spawn on arrival."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local guideElapsed Float
            .local ::temp2 Float
            .local ::nonevar None
            .local ::temp3 String
            .local slot Int
            .local ::temp4 Int
            .local player actor
            .local ::mangled_slot_0 Int
            .local offset Float[]
            .local ::temp5 Float[]
            .local ::temp6 Float
            .local ::temp7 objectReference
            .local ::temp8 keyword
            .local ::temp9 package
            .local distToPlayer Float
            .local guideArrived Bool
            .local distToDest Float
            .local ::temp10 cell
            .local ::temp11 cell
            .local questCell cell
            .local questLoc location
            .local ::temp12 location
            .local stuckStatus Int
            .local ::mangled_offset_0 Float[]
            .local ::temp13 objectReference
          .endLocalTable
          .code
            ; line 3502
            not ::temp0 ::QuestGuideActive_var 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 ::QuestGuideNPC_var ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 3503
            return None 
            jmp _label1
            ; line 3507
          _label1:
            callstatic utility GetCurrentGameTime ::temp2 ;0 variable args
            fsub ::temp2 ::temp2 ::QuestGuideStartTime_var 
            fmul ::temp2 ::temp2 24.0 
            assign guideElapsed ::temp2 
            ; line 3508
            propget QUEST_GUIDE_TIMEOUT_HOURS self ::temp2 
            cmp_gt ::temp0 guideElapsed ::temp2 
            jmpf ::temp0 _label2
            ; line 3509
            cast ::temp3 guideElapsed 
            strcat ::temp3 "Story [quest_guide]: guide timed out after " ::temp3 
            strcat ::temp3 ::temp3 " hours" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 3510
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestGuideNPC_var False ;2 variable args
            ; line 3511
            callmethod FindSlotByAgent ::Core_var ::temp4 ::QuestGuideNPC_var ;1 variable args
            assign slot ::temp4 
            ; line 3512
            comp_gte ::temp0 slot 0 
            jmpf ::temp0 _label3
            ; line 3513
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label3
            ; line 3515
          _label3:
            assign ::QuestGuideActive_var False 
            ; line 3516
            assign ::QuestGuideWaiting_var False 
            ; line 3517
            assign ::ActiveStoryType_var "" 
            ; line 3518
            assign ::IsActive_var False 
            ; line 3519
            callmethod StartStoryLinger self ::nonevar ::QuestGuideNPC_var ;1 variable args
            ; line 3520
            return None 
            jmp _label2
            ; line 3523
          _label2:
            callstatic game GetPlayer ::temp1 ;0 variable args
            assign player ::temp1 
            ; line 3524
            callmethod FindSlotByAgent ::Core_var ::temp4 ::QuestGuideNPC_var ;1 variable args
            assign ::mangled_slot_0 ::temp4 
            ; line 3527
            callmethod Is3DLoaded ::QuestGuideNPC_var ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label4
            ; line 3528
            comp_gte ::temp0 ::mangled_slot_0 0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label5
            callmethod HandleOffScreenTravel ::Core_var ::temp0 ::mangled_slot_0 ::QuestGuideNPC_var ::QuestLocation_var ;3 variable args
            assign ::temp0 ::temp0 
          _label5:
            jmpf ::temp0 _label6
            ; line 3530
            propget TELEPORT_OFFSET_INTERIOR self ::temp2 
            callstatic intelEngine GetOffsetBehind ::temp5 ::QuestLocation_var ::temp2 ;2 variable args
            assign offset ::temp5 
            ; line 3531
            array_getlement ::temp2 offset 0 
            array_getlement ::temp6 offset 1 
            callmethod MoveTo ::QuestGuideNPC_var ::nonevar ::QuestLocation_var ::temp2 ::temp6 0.0 False ;5 variable args
            ; line 3532
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestGuideNPC_var False ;2 variable args
            ; line 3533
            cast ::temp7 ::QuestGuideNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp8 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp7 ::QuestLocation_var ::temp8 ;3 variable args
            ; line 3534
            propget TravelPackage_Jog ::Core_var ::temp9 
            propget PRIORITY_TRAVEL ::Core_var ::temp4 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestGuideNPC_var ::temp9 ::temp4 1 ;4 variable args
            ; line 3535
            callmethod EvaluatePackage ::QuestGuideNPC_var ::nonevar ;0 variable args
            ; line 3536
            strcat ::temp3 "Story [quest_guide]: off-screen arrival near " ::QuestLocationName_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label6
            ; line 3538
          _label6:
            return None 
            jmp _label4
            ; line 3541
          _label4:
            cast ::temp7 player 
            callmethod GetDistance ::QuestGuideNPC_var ::temp6 ::temp7 ;1 variable args
            assign distToPlayer ::temp6 
            ; line 3544
            assign guideArrived False 
            ; line 3545
            callmethod Is3DLoaded ::QuestLocation_var ::temp0 ;0 variable args
            jmpf ::temp0 _label7
            ; line 3546
            callmethod GetDistance ::QuestGuideNPC_var ::temp6 ::QuestLocation_var ;1 variable args
            assign distToDest ::temp6 
            ; line 3547
            propget ARRIVAL_DISTANCE ::Core_var ::temp6 
            cmp_lte ::temp0 distToDest ::temp6 
            jmpf ::temp0 _label8
            ; line 3548
            assign guideArrived True 
            jmp _label8
          _label8:
            jmp _label7
            ; line 3552
          _label7:
            not ::temp0 guideArrived 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label9
            callmethod GetParentCell ::QuestGuideNPC_var ::temp10 ;0 variable args
            cast ::temp11 None 
            cmp_eq ::temp0 ::temp10 ::temp11 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label9:
            jmpf ::temp0 _label10
            ; line 3553
            callmethod GetParentCell ::QuestLocation_var ::temp11 ;0 variable args
            assign questCell ::temp11 
            ; line 3554
            cast ::temp11 None 
            cmp_eq ::temp0 questCell ::temp11 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label11
            callmethod GetParentCell ::QuestGuideNPC_var ::temp11 ;0 variable args
            cmp_eq ::temp0 ::temp11 questCell 
            assign ::temp0 ::temp0 
          _label11:
            jmpf ::temp0 _label12
            ; line 3555
            assign guideArrived True 
            ; line 3556
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest_guide]: same-cell arrival fallback triggered" ;1 variable args
            jmp _label12
          _label12:
            jmp _label10
            ; line 3560
          _label10:
            not ::temp0 guideArrived 
            jmpf ::temp0 _label13
            ; line 3561
            callmethod GetCurrentLocation ::QuestLocation_var ::temp12 ;0 variable args
            assign questLoc ::temp12 
            ; line 3562
            cast ::temp12 None 
            cmp_eq ::temp0 questLoc ::temp12 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label14
            callmethod IsInLocation ::QuestGuideNPC_var ::temp0 questLoc ;1 variable args
            assign ::temp0 ::temp0 
          _label14:
            jmpf ::temp0 _label15
            ; line 3563
            assign guideArrived True 
            ; line 3564
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest_guide]: BGSLocation arrival fallback triggered" ;1 variable args
            jmp _label15
          _label15:
            jmp _label13
            ; line 3567
          _label13:
            jmpf guideArrived _label16
            ; line 3568
            callmethod OnQuestGuideArrived self ::nonevar ;0 variable args
            ; line 3569
            return None 
            jmp _label16
            ; line 3573
          _label16:
            comp_gte ::temp0 ::mangled_slot_0 0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label17
            not ::temp0 ::QuestGuideWaiting_var 
            assign ::temp0 ::temp0 
          _label17:
            jmpf ::temp0 _label18
            ; line 3574
            propget STUCK_DISTANCE_THRESHOLD ::Core_var ::temp6 
            callstatic intelEngine CheckStuckStatus ::temp4 ::QuestGuideNPC_var ::mangled_slot_0 ::temp6 ;3 variable args
            assign stuckStatus ::temp4 
            ; line 3575
            cmp_eq ::temp0 stuckStatus 1 
            jmpf ::temp0 _label19
            ; line 3576
            callmethod SoftStuckRecovery ::Core_var ::nonevar ::QuestGuideNPC_var ::mangled_slot_0 ::QuestLocation_var ;3 variable args
            jmp _label20
            ; line 3577
          _label19:
            comp_gte ::temp0 stuckStatus 3 
            jmpf ::temp0 _label20
            ; line 3579
            propget TELEPORT_OFFSET_INTERIOR self ::temp6 
            callstatic intelEngine GetOffsetBehind ::temp5 ::QuestLocation_var ::temp6 ;2 variable args
            assign ::mangled_offset_0 ::temp5 
            ; line 3580
            array_getlement ::temp6 ::mangled_offset_0 0 
            array_getlement ::temp2 ::mangled_offset_0 1 
            callmethod MoveTo ::QuestGuideNPC_var ::nonevar ::QuestLocation_var ::temp6 ::temp2 0.0 False ;5 variable args
            ; line 3581
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestGuideNPC_var False ;2 variable args
            ; line 3582
            cast ::temp7 ::QuestGuideNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp8 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp7 ::QuestLocation_var ::temp8 ;3 variable args
            ; line 3583
            propget TravelPackage_Jog ::Core_var ::temp9 
            propget PRIORITY_TRAVEL ::Core_var ::temp4 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestGuideNPC_var ::temp9 ::temp4 1 ;4 variable args
            ; line 3584
            callmethod EvaluatePackage ::QuestGuideNPC_var ::nonevar ;0 variable args
            ; line 3585
            strcat ::temp3 "Story [quest_guide]: hard stuck - teleported near " ::QuestLocationName_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label20
          _label20:
            jmp _label18
            ; line 3590
          _label18:
            not ::temp0 ::QuestGuideWaiting_var 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label21
            propget QUEST_GUIDE_WAIT_DIST self ::temp2 
            cmp_gt ::temp0 distToPlayer ::temp2 
            assign ::temp0 ::temp0 
          _label21:
            jmpf ::temp0 _label22
            ; line 3591
            assign ::QuestGuideWaiting_var True 
            ; line 3592
            propget TravelPackage_Jog ::Core_var ::temp9 
            callstatic actorUtil RemovePackageOverride ::temp0 ::QuestGuideNPC_var ::temp9 ;2 variable args
            ; line 3595
            cast ::temp7 ::QuestGuideNPC_var 
            cast ::temp13 ::QuestGuideNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp8 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp7 ::temp13 ::temp8 ;3 variable args
            ; line 3596
            propget SandboxNearPlayerPackage ::Core_var ::temp9 
            propget PRIORITY_SANDBOX ::Core_var ::temp4 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestGuideNPC_var ::temp9 ::temp4 1 ;4 variable args
            ; line 3597
            callmethod EvaluatePackage ::QuestGuideNPC_var ::nonevar ;0 variable args
            ; line 3598
            cast ::temp3 distToPlayer 
            strcat ::temp3 "Story [quest_guide]: waiting for player (dist=" ::temp3 
            strcat ::temp3 ::temp3 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label23
            ; line 3599
          _label22:
            assign ::temp0 ::QuestGuideWaiting_var 
            jmpf ::temp0 _label24
            propget QUEST_GUIDE_RESUME_DIST self ::temp2 
            cmp_lte ::temp0 distToPlayer ::temp2 
            assign ::temp0 ::temp0 
          _label24:
            jmpf ::temp0 _label23
            ; line 3600
            assign ::QuestGuideWaiting_var False 
            ; line 3601
            propget SandboxNearPlayerPackage ::Core_var ::temp9 
            callstatic actorUtil RemovePackageOverride ::temp0 ::QuestGuideNPC_var ::temp9 ;2 variable args
            ; line 3602
            cast ::temp13 ::QuestGuideNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp8 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp13 ::QuestLocation_var ::temp8 ;3 variable args
            ; line 3603
            propget TravelPackage_Jog ::Core_var ::temp9 
            propget PRIORITY_TRAVEL ::Core_var ::temp4 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestGuideNPC_var ::temp9 ::temp4 1 ;4 variable args
            ; line 3604
            callmethod EvaluatePackage ::QuestGuideNPC_var ::nonevar ;0 variable args
            ; line 3605
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest_guide]: player caught up, resuming" ;1 variable args
            jmp _label23
          _label23
          .endCode
        .endFunction ;CheckQuestGuide
        .function OnQuestGuideArrived
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local slot Int
            .local ::temp1 Int
            .local ::temp2 Bool
            .local ::temp3 objectReference
            .local ::temp4 objectReference
            .local ::temp5 keyword
            .local ::temp6 package
            .local ::temp7 Float
          .endLocalTable
          .code
            ; line 3610
            strcat ::temp0 "Story [quest_guide]: arrived at " ::QuestLocationName_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3619
            assign ::QuestGuideActive_var False 
            ; line 3620
            callmethod FindSlotByAgent ::Core_var ::temp1 ::QuestGuideNPC_var ;1 variable args
            assign slot ::temp1 
            ; line 3621
            comp_gte ::temp2 slot 0 
            jmpf ::temp2 _label0
            ; line 3622
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label0
            ; line 3624
          _label0:
            assign ::ActiveStoryType_var "" 
            ; line 3625
            assign ::IsActive_var False 
            ; line 3628
            cast ::temp3 ::QuestGuideNPC_var 
            cast ::temp4 ::QuestGuideNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp5 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp3 ::temp4 ::temp5 ;3 variable args
            ; line 3629
            propget SandboxNearPlayerPackage ::Core_var ::temp6 
            propget PRIORITY_SANDBOX ::Core_var ::temp1 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestGuideNPC_var ::temp6 ::temp1 1 ;4 variable args
            ; line 3630
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 3631
            callmethod EvaluatePackage ::QuestGuideNPC_var ::nonevar ;0 variable args
            ; line 3634
            callmethod EnsureBuildingAccess ::Core_var ::nonevar ::QuestGuideNPC_var ;1 variable args
            ; line 3635
            callmethod StartStoryLinger self ::nonevar ::QuestGuideNPC_var ;1 variable args
            ; line 3636
            propget MONITOR_INTERVAL self ::temp7 
            callmethod RegisterForSingleUpdate self ::nonevar ::temp7 ;1 variable args
          .endCode
        .endFunction ;OnQuestGuideArrived
        .function PrePlaceQuestTargets
           ; function type 0
          .userFlags 0 ;none
          .docString "Pre-place victim/chest/boss at dungeon boss room when DungeonIndex has data.
     Called at quest acceptance (both "I'll go alone" and "Lead the way" paths).
     Regular enemies are deferred to cell load (need loaded cell for AI init)."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local bossAnchor objectReference
            .local ::temp1 objectReference
            .local ::nonevar None
            .local ::temp2 String
            .local ::temp3 actor
            .local ::temp4 keyword
            .local ::temp5 package
            .local ::temp6 Int
            .local ::temp7 form
            .local ::temp8 actorBase
            .local ::temp9 Float
            .local chest objectReference
            .local boss actor
            .local ::temp10 form
          .endLocalTable
          .code
            ; line 3652
            cmp_eq ::temp0 ::QuestSubType_var "faction_battle" 
            jmpf ::temp0 _label0
            ; line 3653
            return None 
            jmp _label0
            ; line 3656
          _label0:
            callstatic intelEngine GetDungeonBossAnchor ::temp1 ::QuestLocationName_var ;1 variable args
            assign bossAnchor ::temp1 
            ; line 3657
            cast ::temp1 None 
            cmp_eq ::temp0 bossAnchor ::temp1 
            jmpf ::temp0 _label1
            ; line 3658
            strcat ::temp2 "Story [quest/" ::QuestSubType_var 
            strcat ::temp2 ::temp2 "]: no dungeon boss anchor for '" 
            strcat ::temp2 ::temp2 ::QuestLocationName_var 
            strcat ::temp2 ::temp2 "' — using deferred spawn" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 3659
            return None 
            jmp _label1
            ; line 3662
          _label1:
            assign ::QuestBossAnchor_var bossAnchor 
            ; line 3663
            strcat ::temp2 "Story [quest/" ::QuestSubType_var 
            strcat ::temp2 ::temp2 "]: pre-placing at boss anchor in '" 
            strcat ::temp2 ::temp2 ::QuestLocationName_var 
            strcat ::temp2 ::temp2 "'" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 3670
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label2
            cast ::temp3 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp3 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label2:
            jmpf ::temp0 _label3
            ; line 3671
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestVictimNPC_var False ;2 variable args
            ; line 3672
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar bossAnchor 0.0 0.0 0.0 True ;5 variable args
            ; line 3675
            cast ::temp1 ::QuestVictimNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp4 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp1 bossAnchor ::temp4 ;3 variable args
            ; line 3676
            propget SandboxNearPlayerPackage ::Core_var ::temp5 
            propget PRIORITY_TRAVEL ::Core_var ::temp6 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestVictimNPC_var ::temp5 ::temp6 1 ;4 variable args
            ; line 3677
            cast ::temp7 ::QuestVictimNPC_var 
            callmethod IsEssential ::QuestVictimNPC_var ::temp0 ;0 variable args
            cast ::temp6 ::temp0 
            callstatic storageUtil SetIntValue ::temp6 ::temp7 "Intel_WasEssential" ::temp6 ;3 variable args
            ; line 3678
            callmethod GetActorBase ::QuestVictimNPC_var ::temp8 ;0 variable args
            callmethod SetEssential ::temp8 ::nonevar True ;1 variable args
            ; line 3679
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 3684
            callmethod GetActorValue ::QuestVictimNPC_var ::temp9 "Health" ;1 variable args
            fadd ::temp9 ::temp9 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp9 ;2 variable args
            ; line 3685
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 3686
            callstatic utility GetCurrentGameTime ::temp9 ;0 variable args
            callstatic intelEngine NotifyStoryCooldown ::nonevar ::QuestVictimNPC_var ::temp9 ;2 variable args
            ; line 3687
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp2 ;0 variable args
            strcat ::temp2 "Story [quest/rescue]: victim " ::temp2 
            strcat ::temp2 ::temp2 " placed at boss room in bleedout" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            jmp _label3
            ; line 3694
          _label3:
            cmp_eq ::temp0 ::QuestSubType_var "find_item" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label4
            cmp_eq ::temp0 ::QuestItemName_var "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label5
            ; line 3695
            callstatic intelEngine SpawnQuestChest ::temp1 bossAnchor ::QuestItemName_var ;2 variable args
            assign chest ::temp1 
            ; line 3696
            cast ::temp1 None 
            cmp_eq ::temp0 chest ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label6
            ; line 3697
            assign ::QuestItemChest_var chest 
            ; line 3698
            strcat ::temp2 "Story [quest/find_item]: chest with " ::QuestItemName_var 
            strcat ::temp2 ::temp2 " spawned at boss anchor" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            jmp _label6
          _label6:
            jmp _label5
            ; line 3706
          _label5:
            cmp_eq ::temp0 ::QuestSubType_var "combat" 
            jmpf ::temp0 _label7
            ; line 3707
            callstatic intelEngine SpawnQuestBoss ::temp3 bossAnchor ::QuestEnemyType_var ;2 variable args
            assign boss ::temp3 
            ; line 3708
            cast ::temp3 None 
            cmp_eq ::temp0 boss ::temp3 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label8
            ; line 3709
            assign ::QuestBossNPC_var boss 
            ; line 3710
            callstatic game GetPlayer ::temp3 ;0 variable args
            cast ::temp7 ::temp3 
            cast ::temp10 boss 
            callstatic storageUtil FormListAdd ::temp6 ::temp7 "Intel_QuestSpawnedNPCs" ::temp10 True ;4 variable args
            ; line 3711
            iadd ::temp6 ::QuestSpawnCount_var 1 
            assign ::QuestSpawnCount_var ::temp6 
            ; line 3712
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/combat]: boss spawned at boss anchor" ;1 variable args
            jmp _label8
          _label8:
            jmp _label7
            ; line 3719
          _label7:
            assign ::QuestPrePlaced_var True 
            ; line 3720
            strcat ::temp2 "Story [quest/" ::QuestSubType_var 
            strcat ::temp2 ::temp2 "]: pre-placed target at boss anchor in '" 
            strcat ::temp2 ::temp2 ::QuestLocationName_var 
            strcat ::temp2 ::temp2 "', enemies deferred to cell load" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
          .endCode
        .endFunction ;PrePlaceQuestTargets
        .function CheckQuestProximity
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 objectReference
            .local bossLoaded Bool
            .local targetNearby Bool
            .local questDist Float
            .local ::temp2 actor
            .local ::temp3 Float
            .local nearQuestArea Bool
            .local ::nonevar None
            .local spawnPoint objectReference
            .local player actor
            .local enemies actor[]
            .local ::temp4 actor[]
            .local i Int
            .local ::temp5 Int
            .local ::temp6 Float
            .local ::temp7 form
            .local ::temp8 form
            .local boss actor
            .local ::temp9 String
            .local ::temp10 String
            .local ::mangled_player_0 actor
            .local atQuestArea Bool
            .local dist Float
            .local questCell cell
            .local ::temp11 cell
            .local playerCell cell
            .local questLoc location
            .local ::temp12 location
            .local locDist Float
            .local ::mangled_questLoc_0 location
            .local enemyFaction String
            .local battle intelEngine_Battle
            .local ::temp13 intelEngine_Battle
            .local allyFailName String
            .local currentCell cell
            .local aheadAnchor objectReference
            .local ::temp14 keyword
            .local ::temp15 package
            .local ::temp16 actorBase
            .local ::temp17 referenceAlias
            .local chest objectReference
            .local ::mangled_enemies_0 actor[]
            .local idx Int
            .local ::mangled_boss_0 actor
            .local battleElapsed Float
            .local ::temp18 intelEngine_Battle
            .local usableFurn objectReference
            .local prisonFurn objectReference
            .local ::mangled_player_1 actor
          .endLocalTable
          .code
            ; line 3728
            not ::temp0 ::QuestActive_var 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 ::QuestLocation_var ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label1
            assign ::temp0 ::QuestGuideActive_var 
          _label1:
            jmpf ::temp0 _label2
            ; line 3729
            return None 
            jmp _label2
            ; line 3736
          _label2:
            cmp_eq ::temp0 ::ActiveStoryType_var "quest" 
            jmpf ::temp0 _label3
            ; line 3737
            return None 
            jmp _label3
            ; line 3740
          _label3:
            not ::temp0 ::QuestEnemiesSpawned_var 
            jmpf ::temp0 _label4
            ; line 3745
            assign ::temp0 ::QuestPrePlaced_var 
            jmpf ::temp0 _label5
            cast ::temp1 None 
            cmp_eq ::temp0 ::QuestBossAnchor_var ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label5:
            jmpf ::temp0 _label6
            ; line 3753
            callmethod Is3DLoaded ::QuestBossAnchor_var ::temp0 ;0 variable args
            assign bossLoaded ::temp0 
            ; line 3754
            assign targetNearby False 
            ; line 3755
            not ::temp0 bossLoaded 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label7
            cast ::temp1 None 
            cmp_eq ::temp0 ::QuestLocation_var ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label7:
            jmpf ::temp0 _label8
            ; line 3756
            callstatic game GetPlayer ::temp2 ;0 variable args
            cast ::temp1 ::temp2 
            callstatic intelEngine GetDistance3D ::temp3 ::temp1 ::QuestLocation_var ;2 variable args
            assign questDist ::temp3 
            ; line 3757
            cmp_lt ::temp0 questDist 4000.0 
            assign nearQuestArea ::temp0 
            ; line 3758
            assign ::temp0 nearQuestArea 
            jmpf ::temp0 _label9
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            assign ::temp0 ::temp0 
          _label9:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label10
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label10:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label11
            callmethod Is3DLoaded ::QuestVictimNPC_var ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label11:
            jmpf ::temp0 _label12
            ; line 3759
            cast ::temp1 ::QuestVictimNPC_var 
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDistance ::temp2 ::temp3 ::temp1 ;1 variable args
            cmp_lt ::temp0 ::temp3 2000.0 
            assign targetNearby ::temp0 
            jmp _label13
            ; line 3760
          _label12:
            assign ::temp0 nearQuestArea 
            jmpf ::temp0 _label14
            cmp_eq ::temp0 ::QuestSubType_var "combat" 
            assign ::temp0 ::temp0 
          _label14:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label15
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestBossNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label15:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label16
            callmethod Is3DLoaded ::QuestBossNPC_var ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label16:
            jmpf ::temp0 _label13
            ; line 3761
            cast ::temp1 ::QuestBossNPC_var 
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDistance ::temp2 ::temp3 ::temp1 ;1 variable args
            cmp_lt ::temp0 ::temp3 2000.0 
            assign targetNearby ::temp0 
            jmp _label13
          _label13:
            jmp _label8
            ; line 3764
          _label8:
            assign ::temp0 bossLoaded 
            jmpt ::temp0 _label17
            assign ::temp0 targetNearby 
          _label17:
            jmpf ::temp0 _label18
            ; line 3765
            assign ::temp0 targetNearby 
            jmpf ::temp0 _label19
            not ::temp0 bossLoaded 
            assign ::temp0 ::temp0 
          _label19:
            jmpf ::temp0 _label20
            ; line 3766
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: pre-placed target nearby but boss anchor not loaded — safety spawn" ;1 variable args
            jmp _label21
            ; line 3768
          _label20:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: boss room cell loaded — spawning enemies/chest at anchor" ;1 variable args
            ; line 3771
          _label21:
            assign spawnPoint ::QuestBossAnchor_var 
            ; line 3772
            assign ::temp0 targetNearby 
            jmpf ::temp0 _label22
            not ::temp0 bossLoaded 
            assign ::temp0 ::temp0 
          _label22:
            jmpf ::temp0 _label23
            ; line 3773
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label24
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label24:
            jmpf ::temp0 _label25
            ; line 3774
            cast ::temp1 ::QuestVictimNPC_var 
            assign spawnPoint ::temp1 
            jmp _label26
            ; line 3775
          _label25:
            cmp_eq ::temp0 ::QuestSubType_var "combat" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label27
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestBossNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label27:
            jmpf ::temp0 _label26
            ; line 3776
            cast ::temp1 ::QuestBossNPC_var 
            assign spawnPoint ::temp1 
            jmp _label26
          _label26:
            jmp _label23
            ; line 3779
          _label23:
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign player ::temp2 
            ; line 3785
            callstatic intelEngine SpawnQuestEnemies ::temp4 spawnPoint ::QuestEnemyType_var ;2 variable args
            assign enemies ::temp4 
            ; line 3786
            assign i 0 
            ; line 3787
          _label29:
            array_length ::temp5 enemies 
            cmp_lt ::temp0 i ::temp5 
            jmpf ::temp0 _label28
            ; line 3788
            array_getlement ::temp2 enemies i 
            callmethod DisableNoWait ::temp2 ::nonevar False ;1 variable args
            ; line 3789
            callstatic utility RandomFloat ::temp3 -300.0 300.0 ;2 variable args
            callstatic utility RandomFloat ::temp6 -300.0 300.0 ;2 variable args
            array_getlement ::temp2 enemies i 
            callmethod MoveTo ::temp2 ::nonevar spawnPoint ::temp3 ::temp6 0.0 True ;5 variable args
            ; line 3790
            cast ::temp7 player 
            array_getlement ::temp2 enemies i 
            cast ::temp8 ::temp2 
            callstatic storageUtil FormListAdd ::temp5 ::temp7 "Intel_QuestSpawnedNPCs" ::temp8 True ;4 variable args
            ; line 3791
            iadd ::temp5 i 1 
            assign i ::temp5 
            jmp _label29
            ; line 3795
          _label28:
            cast ::temp2 None 
            assign boss ::temp2 
            ; line 3796
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestBossNPC_var ::temp2 
            jmpf ::temp0 _label30
            ; line 3797
            callstatic intelEngine SpawnQuestBoss ::temp2 spawnPoint ::QuestEnemyType_var ;2 variable args
            assign boss ::temp2 
            ; line 3798
            cast ::temp2 None 
            cmp_eq ::temp0 boss ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label31
            ; line 3799
            callmethod DisableNoWait boss ::nonevar False ;1 variable args
            ; line 3800
            callstatic utility RandomFloat ::temp6 -150.0 150.0 ;2 variable args
            callstatic utility RandomFloat ::temp3 -150.0 150.0 ;2 variable args
            callmethod MoveTo boss ::nonevar spawnPoint ::temp6 ::temp3 0.0 True ;5 variable args
            ; line 3801
            assign ::QuestBossNPC_var boss 
            ; line 3802
            cast ::temp8 player 
            cast ::temp7 boss 
            callstatic storageUtil FormListAdd ::temp5 ::temp8 "Intel_QuestSpawnedNPCs" ::temp7 True ;4 variable args
            jmp _label31
          _label31:
            jmp _label30
            ; line 3809
          _label30:
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label32
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label32:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label33
            not ::temp0 ::QuestVictimFreed_var 
            assign ::temp0 ::temp0 
          _label33:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label34
            not ::temp0 ::QuestVictimInFurniture_var 
            assign ::temp0 ::temp0 
          _label34:
            jmpf ::temp0 _label35
            ; line 3810
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 3811
            callmethod GetActorValue ::QuestVictimNPC_var ::temp3 "Health" ;1 variable args
            fadd ::temp3 ::temp3 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp3 ;2 variable args
            ; line 3812
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 3813
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: re-applied bleedout on first 3D load" ;1 variable args
            jmp _label35
            ; line 3820
          _label35:
            cmp_eq ::temp0 ::QuestSubType_var "find_item" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label36
            cast ::temp1 None 
            cmp_eq ::temp0 ::QuestItemChest_var ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label36:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label37
            cmp_eq ::temp0 ::QuestItemName_var "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label37:
            jmpf ::temp0 _label38
            ; line 3821
            callstatic intelEngine EnsureQuestItemInChest ::temp0 ::QuestItemChest_var ::QuestItemName_var ;2 variable args
            ; line 3822
            strcat ::temp9 "Story [quest/find_item]: ensured '" ::QuestItemName_var 
            strcat ::temp9 ::temp9 "' is in chest on first 3D load" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            jmp _label38
            ; line 3826
          _label38:
            assign i 0 
            ; line 3827
          _label40:
            array_length ::temp5 enemies 
            cmp_lt ::temp0 i ::temp5 
            jmpf ::temp0 _label39
            ; line 3828
            array_getlement ::temp2 enemies i 
            callmethod EnableNoWait ::temp2 ::nonevar False ;1 variable args
            ; line 3829
            iadd ::temp5 i 1 
            assign i ::temp5 
            jmp _label40
            ; line 3831
          _label39:
            cast ::temp2 None 
            cmp_eq ::temp0 boss ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label41
            ; line 3832
            callmethod EnableNoWait boss ::nonevar False ;1 variable args
            jmp _label41
            ; line 3835
          _label41:
            array_length ::temp5 enemies 
            assign ::QuestSpawnCount_var ::temp5 
            ; line 3836
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestBossNPC_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label42
            ; line 3837
            iadd ::temp5 ::QuestSpawnCount_var 1 
            assign ::QuestSpawnCount_var ::temp5 
            jmp _label42
            ; line 3839
          _label42:
            cmp_gt ::temp0 ::QuestSpawnCount_var 0 
            jmpf ::temp0 _label43
            ; line 3840
            assign ::QuestEnemiesSpawned_var True 
            ; line 3841
            strcat ::temp9 "Story [quest/" ::QuestSubType_var 
            strcat ::temp9 ::temp9 "]: spawned " 
            cast ::temp10 ::QuestSpawnCount_var 
            strcat ::temp10 ::temp9 ::temp10 
            strcat ::temp10 ::temp10 " " 
            strcat ::temp10 ::temp10 ::QuestEnemyType_var 
            strcat ::temp10 ::temp10 " at boss room" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            jmp _label44
            ; line 3843
          _label43:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: WARNING - no enemies spawned at boss room, falling back to deferred" ;1 variable args
          _label44:
            jmp _label18
            ; line 3846
          _label18:
            return None 
            jmp _label6
            ; line 3857
          _label6:
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign ::mangled_player_0 ::temp2 
            ; line 3858
            callmethod IsInInterior ::mangled_player_0 ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label45
            callstatic intelEngine IsPlayerInDangerousLocation ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label45:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label46
            not ::temp0 ::QuestDeferredToInterior_var 
            assign ::temp0 ::temp0 
          _label46:
            jmpf ::temp0 _label47
            ; line 3859
            return None 
            jmp _label47
            ; line 3862
          _label47:
            assign atQuestArea False 
            ; line 3867
            callmethod Is3DLoaded ::QuestLocation_var ::temp0 ;0 variable args
            jmpf ::temp0 _label48
            ; line 3868
            cast ::temp1 ::mangled_player_0 
            callstatic intelEngine GetDistance3D ::temp3 ::temp1 ::QuestLocation_var ;2 variable args
            assign dist ::temp3 
            ; line 3869
            cmp_lt ::temp0 dist 4000.0 
            jmpf ::temp0 _label49
            ; line 3870
            assign atQuestArea True 
            jmp _label49
          _label49:
            jmp _label48
            ; line 3874
          _label48:
            not ::temp0 atQuestArea 
            jmpf ::temp0 _label50
            ; line 3875
            callmethod GetParentCell ::QuestLocation_var ::temp11 ;0 variable args
            assign questCell ::temp11 
            ; line 3876
            callmethod GetParentCell ::mangled_player_0 ::temp11 ;0 variable args
            assign playerCell ::temp11 
            ; line 3877
            cast ::temp11 None 
            cmp_eq ::temp0 questCell ::temp11 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label51
            cast ::temp11 None 
            cmp_eq ::temp0 playerCell ::temp11 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label51:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label52
            cmp_eq ::temp0 questCell playerCell 
            assign ::temp0 ::temp0 
          _label52:
            jmpf ::temp0 _label53
            ; line 3878
            assign atQuestArea True 
            ; line 3879
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: same-cell spawn fallback triggered" ;1 variable args
            jmp _label53
          _label53:
            jmp _label50
            ; line 3887
          _label50:
            not ::temp0 atQuestArea 
            jmpf ::temp0 _label54
            ; line 3888
            callmethod GetCurrentLocation ::QuestLocation_var ::temp12 ;0 variable args
            assign questLoc ::temp12 
            ; line 3889
            cast ::temp12 None 
            cmp_eq ::temp0 questLoc ::temp12 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label55
            callmethod IsInLocation ::mangled_player_0 ::temp0 questLoc ;1 variable args
            assign ::temp0 ::temp0 
          _label55:
            jmpf ::temp0 _label56
            ; line 3891
            cast ::temp1 ::mangled_player_0 
            callstatic intelEngine GetDistance3D ::temp3 ::temp1 ::QuestLocation_var ;2 variable args
            assign locDist ::temp3 
            ; line 3892
            cmp_lt ::temp0 locDist 6000.0 
            jmpf ::temp0 _label57
            ; line 3893
            assign atQuestArea True 
            ; line 3894
            cast ::temp10 locDist 
            strcat ::temp10 "Story [quest]: BGSLocation spawn fallback triggered (dist=" ::temp10 
            strcat ::temp10 ::temp10 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            jmp _label58
            ; line 3896
          _label57:
            cast ::temp10 locDist 
            strcat ::temp10 "Story [quest]: BGSLocation match but too far (" ::temp10 
            strcat ::temp10 ::temp10 " units) — waiting" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
          _label58:
            jmp _label56
          _label56:
            jmp _label54
            ; line 3910
          _label54:
            not ::temp0 atQuestArea 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label59
            assign ::temp0 ::QuestDeferredToInterior_var 
          _label59:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label60
            callmethod IsInInterior ::mangled_player_0 ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label60:
            jmpf ::temp0 _label61
            ; line 3915
            callmethod Is3DLoaded ::QuestLocation_var ::temp0 ;0 variable args
            jmpf ::temp0 _label62
            ; line 3916
            assign atQuestArea True 
            ; line 3917
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: deferred interior entry — quest exterior still loaded (player near entrance)" ;1 variable args
            jmp _label63
            ; line 3921
          _label62:
            callmethod GetCurrentLocation ::QuestLocation_var ::temp12 ;0 variable args
            assign ::mangled_questLoc_0 ::temp12 
            ; line 3922
            cast ::temp12 None 
            cmp_eq ::temp0 ::mangled_questLoc_0 ::temp12 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label64
            callmethod IsInLocation ::mangled_player_0 ::temp0 ::mangled_questLoc_0 ;1 variable args
            assign ::temp0 ::temp0 
          _label64:
            jmpf ::temp0 _label65
            ; line 3923
            assign atQuestArea True 
            ; line 3924
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: deferred interior entry — BGSLocation match" ;1 variable args
            jmp _label63
            ; line 3930
          _label65:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: deferred interior but can't verify quest dungeon — waiting for scan" ;1 variable args
          _label63:
            jmp _label61
            ; line 3934
          _label61:
            jmpf atQuestArea _label66
            ; line 3936
            cmp_eq ::temp0 ::QuestSubType_var "faction_battle" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label67
            cmp_eq ::temp0 ::QuestAlliedFaction_var "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label67:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label68
            not ::temp0 ::QuestBattleScheduled_var 
            assign ::temp0 ::temp0 
          _label68:
            jmpf ::temp0 _label69
            ; line 3937
            strcat ::temp10 "Story [quest/faction_battle]: player arrived at " ::QuestLocationName_var 
            strcat ::temp10 ::temp10 " — triggering battle" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            ; line 3939
            assign enemyFaction ::QuestBattleEnemyFaction_var 
            ; line 3940
            cmp_eq ::temp0 enemyFaction "" 
            jmpf ::temp0 _label70
            ; line 3942
            callstatic intelEngine GetFactionWarEnemy ::temp10 ::QuestAlliedFaction_var ;1 variable args
            assign enemyFaction ::temp10 
            jmp _label70
            ; line 3944
          _label70:
            cmp_eq ::temp0 enemyFaction "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label71
            cmp_eq ::temp0 enemyFaction ::QuestAlliedFaction_var 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label71:
            jmpf ::temp0 _label72
            ; line 3945
            propget Battle ::Core_var ::temp13 
            assign battle ::temp13 
            ; line 3946
            cast ::temp13 None 
            cmp_eq ::temp0 battle ::temp13 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label73
            callstatic intelEngine IsBattleActive ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label73:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label74
            propget BattleScheduled battle ::temp0 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label74:
            jmpf ::temp0 _label75
            ; line 3950
            assign ::QuestBattleScheduled_var True 
            ; line 3951
            assign ::QuestEnemiesSpawned_var True 
            ; line 3953
            propset QuestAutoJoinFaction battle ::QuestAlliedFaction_var 
            ; line 3954
            propset BattleSpawnAnchor battle ::QuestLocation_var 
            ; line 3955
            callmethod StartBattleImmediate battle ::nonevar ::QuestAlliedFaction_var enemyFaction 0 ;3 variable args
            ; line 3957
            callstatic intelEngine IsBattleActive ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label76
            ; line 3958
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/faction_battle]: StartBattleImmediate failed, failing quest" ;1 variable args
            ; line 3959
            callstatic debug Notification ::nonevar "The forces have already moved on." ;1 variable args
            ; line 3960
            assign ::QuestBattleScheduled_var False 
            ; line 3961
            assign ::QuestEnemiesSpawned_var False 
            ; line 3962
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 3963
            callmethod CleanupQuest self ::nonevar ;0 variable args
            ; line 3964
            return None 
            jmp _label76
            ; line 3966
          _label76:
            strcat ::temp10 "Story [quest/faction_battle]: battle started — " ::QuestAlliedFaction_var 
            strcat ::temp10 ::temp10 " vs " 
            strcat ::temp10 ::temp10 enemyFaction 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            jmp _label77
            ; line 3968
          _label75:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/faction_battle]: battle system busy, granting partial credit" ;1 variable args
            ; line 3969
            callstatic debug Notification ::nonevar "The fighting is already underway elsewhere." ;1 variable args
            ; line 3970
            cmp_eq ::temp0 ::QuestAlliedFaction_var "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label78
            ; line 3971
            propget QUEST_STANDING_REWARD self ::temp5 
            idiv ::temp5 ::temp5 2 
            callstatic intelEngine AdjustPlayerFactionStanding ::temp5 ::QuestAlliedFaction_var ::temp5 ;2 variable args
            jmp _label78
            ; line 3973
          _label78:
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 3974
            callmethod CleanupQuest self ::nonevar ;0 variable args
          _label77:
            jmp _label79
            ; line 3977
          _label72:
            strcat ::temp10 "Story [quest/faction_battle]: no rival found for " ::QuestAlliedFaction_var 
            strcat ::temp10 ::temp10 ", failing quest" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            ; line 3978
            callstatic intelEngine GetFactionDisplayName ::temp10 ::QuestAlliedFaction_var ;1 variable args
            assign allyFailName ::temp10 
            ; line 3979
            cmp_eq ::temp0 allyFailName "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label80
            ; line 3980
            strcat ::temp10 "The " allyFailName 
            strcat ::temp10 ::temp10 " held the field unopposed." 
            callstatic debug Notification ::nonevar ::temp10 ;1 variable args
            jmp _label80
            ; line 3982
          _label80:
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 3983
            callmethod CleanupQuest self ::nonevar ;0 variable args
            ; line 3985
          _label79:
            return None 
            jmp _label69
            ; line 3987
          _label69:
            callmethod IsInInterior ::mangled_player_0 ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label81
            ; line 3991
            not ::temp0 ::QuestDeferredToInterior_var 
            jmpf ::temp0 _label82
            ; line 3992
            callstatic intelEngine HasNearbyDungeonEntrance ::temp0 ::QuestLocation_var ;1 variable args
            jmpf ::temp0 _label83
            ; line 3993
            assign ::QuestDeferredToInterior_var True 
            ; line 3994
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: dungeon entrance found, deferring spawn until player enters" ;1 variable args
            jmp _label84
            ; line 3997
          _label83:
            callmethod SpawnQuestEnemies self ::nonevar ;0 variable args
          _label84:
            jmp _label85
            ; line 4000
          _label82:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: waiting for player to enter dungeon" ;1 variable args
          _label85:
            jmp _label86
            ; line 4007
          _label81:
            callmethod GetParentCell ::mangled_player_0 ::temp11 ;0 variable args
            assign currentCell ::temp11 
            ; line 4008
            cast ::temp11 None 
            cmp_eq ::temp0 ::QuestDungeonLastCell_var ::temp11 
            jmpf ::temp0 _label87
            ; line 4009
            assign ::QuestDungeonLastCell_var currentCell 
            ; line 4010
            assign ::QuestDungeonDepth_var 0 
            jmp _label88
            ; line 4011
          _label87:
            cmp_eq ::temp0 currentCell ::QuestDungeonLastCell_var 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label88
            ; line 4012
            assign ::QuestDungeonLastCell_var currentCell 
            ; line 4013
            iadd ::temp5 ::QuestDungeonDepth_var 1 
            assign ::QuestDungeonDepth_var ::temp5 
            jmp _label88
            ; line 4015
          _label88:
            cast ::temp10 ::QuestDungeonDepth_var 
            strcat ::temp10 "Story [quest]: dungeon depth " ::temp10 
            strcat ::temp10 ::temp10 ", scanning ahead..." 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            ; line 4018
            callstatic intelEngine ScanAheadForAnchor ::temp1 ::mangled_player_0 ;1 variable args
            assign aheadAnchor ::temp1 
            ; line 4019
            cast ::temp1 None 
            cmp_eq ::temp0 aheadAnchor ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label89
            ; line 4021
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: anchor found ahead! Placing victim + enemies" ;1 variable args
            ; line 4022
            assign ::QuestBossAnchor_var aheadAnchor 
            ; line 4027
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label90
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label90:
            jmpf ::temp0 _label91
            ; line 4028
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestVictimNPC_var False ;2 variable args
            ; line 4029
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar aheadAnchor 0.0 0.0 0.0 True ;5 variable args
            ; line 4030
            cast ::temp1 ::QuestVictimNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp14 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp1 aheadAnchor ::temp14 ;3 variable args
            ; line 4031
            propget SandboxNearPlayerPackage ::Core_var ::temp15 
            propget PRIORITY_TRAVEL ::Core_var ::temp5 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestVictimNPC_var ::temp15 ::temp5 1 ;4 variable args
            ; line 4032
            cast ::temp7 ::QuestVictimNPC_var 
            callmethod IsEssential ::QuestVictimNPC_var ::temp0 ;0 variable args
            cast ::temp5 ::temp0 
            callstatic storageUtil SetIntValue ::temp5 ::temp7 "Intel_WasEssential" ::temp5 ;3 variable args
            ; line 4033
            callmethod GetActorBase ::QuestVictimNPC_var ::temp16 ;0 variable args
            callmethod SetEssential ::temp16 ::nonevar True ;1 variable args
            ; line 4034
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 4037
            callmethod GetActorValue ::QuestVictimNPC_var ::temp3 "Health" ;1 variable args
            fadd ::temp3 ::temp3 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp3 ;2 variable args
            ; line 4038
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4039
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            callstatic intelEngine NotifyStoryCooldown ::nonevar ::QuestVictimNPC_var ::temp3 ;2 variable args
            ; line 4041
            cast ::temp17 None 
            cmp_eq ::temp0 ::QuestTargetAlias_var ::temp17 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label92
            ; line 4042
            cast ::temp1 ::QuestVictimNPC_var 
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::temp1 ;1 variable args
            ; line 4043
            propget QUEST_OBJECTIVE_ID self ::temp5 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp5 False False ;3 variable args
            ; line 4044
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 4045
            propget QUEST_OBJECTIVE_ID self ::temp5 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp5 True False ;3 variable args
            jmp _label92
            ; line 4047
          _label92:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: victim placed at ahead anchor in bleedout" ;1 variable args
            jmp _label91
            ; line 4051
          _label91:
            cmp_eq ::temp0 ::QuestSubType_var "find_item" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label93
            cmp_eq ::temp0 ::QuestItemName_var "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label93:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label94
            cast ::temp1 None 
            cmp_eq ::temp0 ::QuestItemChest_var ::temp1 
            assign ::temp0 ::temp0 
          _label94:
            jmpf ::temp0 _label95
            ; line 4052
            callstatic intelEngine SpawnQuestChest ::temp1 aheadAnchor ::QuestItemName_var ;2 variable args
            assign chest ::temp1 
            ; line 4053
            cast ::temp1 None 
            cmp_eq ::temp0 chest ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label96
            ; line 4054
            assign ::QuestItemChest_var chest 
            ; line 4055
            cast ::temp17 None 
            cmp_eq ::temp0 ::QuestTargetAlias_var ::temp17 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label97
            ; line 4056
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::QuestItemChest_var ;1 variable args
            ; line 4057
            propget QUEST_OBJECTIVE_ID self ::temp5 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp5 False False ;3 variable args
            ; line 4058
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 4059
            propget QUEST_OBJECTIVE_ID self ::temp5 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp5 True False ;3 variable args
            jmp _label97
            ; line 4061
          _label97:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/find_item]: chest placed at ahead anchor" ;1 variable args
            jmp _label96
          _label96:
            jmp _label95
            ; line 4066
          _label95:
            callstatic intelEngine SpawnQuestEnemies ::temp4 aheadAnchor ::QuestEnemyType_var ;2 variable args
            assign ::mangled_enemies_0 ::temp4 
            ; line 4067
            assign idx 0 
            ; line 4068
          _label99:
            array_length ::temp5 ::mangled_enemies_0 
            cmp_lt ::temp0 idx ::temp5 
            jmpf ::temp0 _label98
            ; line 4069
            array_getlement ::temp2 ::mangled_enemies_0 idx 
            callmethod DisableNoWait ::temp2 ::nonevar False ;1 variable args
            ; line 4070
            callstatic utility RandomFloat ::temp3 -300.0 300.0 ;2 variable args
            callstatic utility RandomFloat ::temp6 -300.0 300.0 ;2 variable args
            array_getlement ::temp2 ::mangled_enemies_0 idx 
            callmethod MoveTo ::temp2 ::nonevar aheadAnchor ::temp3 ::temp6 0.0 True ;5 variable args
            ; line 4071
            cast ::temp7 ::mangled_player_0 
            array_getlement ::temp2 ::mangled_enemies_0 idx 
            cast ::temp8 ::temp2 
            callstatic storageUtil FormListAdd ::temp5 ::temp7 "Intel_QuestSpawnedNPCs" ::temp8 True ;4 variable args
            ; line 4072
            iadd ::temp5 idx 1 
            assign idx ::temp5 
            jmp _label99
            ; line 4074
          _label98:
            callstatic intelEngine SpawnQuestBoss ::temp2 aheadAnchor ::QuestEnemyType_var ;2 variable args
            assign ::mangled_boss_0 ::temp2 
            ; line 4075
            cast ::temp2 None 
            cmp_eq ::temp0 ::mangled_boss_0 ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label100
            ; line 4076
            callmethod DisableNoWait ::mangled_boss_0 ::nonevar False ;1 variable args
            ; line 4077
            callstatic utility RandomFloat ::temp6 -150.0 150.0 ;2 variable args
            callstatic utility RandomFloat ::temp3 -150.0 150.0 ;2 variable args
            callmethod MoveTo ::mangled_boss_0 ::nonevar aheadAnchor ::temp6 ::temp3 0.0 True ;5 variable args
            ; line 4078
            assign ::QuestBossNPC_var ::mangled_boss_0 
            ; line 4079
            cast ::temp8 ::mangled_player_0 
            cast ::temp7 ::mangled_boss_0 
            callstatic storageUtil FormListAdd ::temp5 ::temp8 "Intel_QuestSpawnedNPCs" ::temp7 True ;4 variable args
            jmp _label100
            ; line 4082
          _label100:
            assign idx 0 
            ; line 4083
          _label102:
            array_length ::temp5 ::mangled_enemies_0 
            cmp_lt ::temp0 idx ::temp5 
            jmpf ::temp0 _label101
            ; line 4084
            array_getlement ::temp2 ::mangled_enemies_0 idx 
            callmethod EnableNoWait ::temp2 ::nonevar False ;1 variable args
            ; line 4085
            iadd ::temp5 idx 1 
            assign idx ::temp5 
            jmp _label102
            ; line 4087
          _label101:
            cast ::temp2 None 
            cmp_eq ::temp0 ::mangled_boss_0 ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label103
            ; line 4088
            callmethod EnableNoWait ::mangled_boss_0 ::nonevar False ;1 variable args
            jmp _label103
            ; line 4090
          _label103:
            array_length ::temp5 ::mangled_enemies_0 
            assign ::QuestSpawnCount_var ::temp5 
            ; line 4091
            cast ::temp2 None 
            cmp_eq ::temp0 ::mangled_boss_0 ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label104
            ; line 4092
            iadd ::temp5 ::QuestSpawnCount_var 1 
            assign ::QuestSpawnCount_var ::temp5 
            jmp _label104
            ; line 4094
          _label104:
            cmp_gt ::temp0 ::QuestSpawnCount_var 0 
            jmpf ::temp0 _label105
            ; line 4095
            assign ::QuestEnemiesSpawned_var True 
            jmp _label105
            ; line 4097
          _label105:
            assign ::QuestPrePlaced_var True 
            ; line 4098
            strcat ::temp10 "Story [quest/" ::QuestSubType_var 
            strcat ::temp10 ::temp10 "]: placed " 
            cast ::temp9 ::QuestSpawnCount_var 
            strcat ::temp9 ::temp10 ::temp9 
            strcat ::temp9 ::temp9 " enemies at ahead anchor" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            jmp _label86
            ; line 4101
          _label89:
            iadd ::temp5 ::QuestDungeonScanFails_var 1 
            assign ::QuestDungeonScanFails_var ::temp5 
            ; line 4102
            comp_gte ::temp0 ::QuestDungeonDepth_var 3 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label106
            comp_gte ::temp0 ::QuestDungeonScanFails_var 5 
            assign ::temp0 ::temp0 
          _label106:
            jmpf ::temp0 _label86
            ; line 4104
            cast ::temp9 ::QuestDungeonDepth_var 
            strcat ::temp9 "Story [quest]: no anchors found (depth=" ::temp9 
            strcat ::temp9 ::temp9 ", scans=" 
            cast ::temp10 ::QuestDungeonScanFails_var 
            strcat ::temp10 ::temp9 ::temp10 
            strcat ::temp10 ::temp10 ") — using fallback spawn" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            ; line 4105
            callmethod SpawnQuestEnemies self ::nonevar ;0 variable args
            jmp _label86
          _label86:
            jmp _label66
          _label66:
            jmp _label107
            ; line 4112
          _label4:
            jmpf ::QuestBattleScheduled_var _label108
            ; line 4114
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            fsub ::temp3 ::temp3 ::QuestGuideStartTime_var 
            assign battleElapsed ::temp3 
            ; line 4115
            propget BATTLE_BUILDUP_NOTIFY_MIN self ::temp3 
            cmp_gt ::temp0 battleElapsed ::temp3 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label109
            propget BATTLE_BUILDUP_NOTIFY_MAX self ::temp3 
            cmp_lt ::temp0 battleElapsed ::temp3 
            assign ::temp0 ::temp0 
          _label109:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label110
            cmp_eq ::temp0 ::QuestSpawnAttempts_var 0 
            assign ::temp0 ::temp0 
          _label110:
            jmpf ::temp0 _label111
            ; line 4116
            assign ::QuestSpawnAttempts_var 1 
            ; line 4117
            callstatic debug Notification ::nonevar "You hear the clink of armor ahead." ;1 variable args
            jmp _label111
            ; line 4120
          _label111:
            callstatic intelEngine IsBattleActive ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label112
            cmp_lt ::temp0 ::QuestSpawnAttempts_var 2 
            assign ::temp0 ::temp0 
          _label112:
            jmpf ::temp0 _label113
            ; line 4121
            assign ::QuestSpawnAttempts_var 2 
            ; line 4122
            callstatic debug Notification ::nonevar "Sounds of fighting carry from up ahead." ;1 variable args
            jmp _label113
            ; line 4125
          _label113:
            propget BATTLE_MIN_START_DELAY self ::temp3 
            cmp_lt ::temp0 battleElapsed ::temp3 
            jmpf ::temp0 _label114
            ; line 4126
            return None 
            jmp _label114
            ; line 4128
          _label114:
            callstatic intelEngine IsBattleActive ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label115
            propget Battle ::Core_var ::temp13 
            cast ::temp18 None 
            cmp_eq ::temp0 ::temp13 ::temp18 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label116
            propget Battle ::Core_var ::temp18 
            propget BattleScheduled ::temp18 ::temp0 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label116:
            assign ::temp0 ::temp0 
          _label115:
            jmpf ::temp0 _label117
            ; line 4129
            cast ::temp10 ::QuestActive_var 
            strcat ::temp10 "Story [quest/faction_battle]: battle ended, completing quest. QuestActive=" ::temp10 
            strcat ::temp10 ::temp10 " IsActive=" 
            cast ::temp9 ::IsActive_var 
            strcat ::temp9 ::temp10 ::temp9 
            strcat ::temp9 ::temp9 " IsNPCStoryActive=" 
            cast ::temp10 ::IsNPCStoryActive_var 
            strcat ::temp10 ::temp9 ::temp10 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            ; line 4130
            callmethod OnQuestComplete self ::nonevar ;0 variable args
            ; line 4131
            cast ::temp10 ::QuestActive_var 
            strcat ::temp10 "Story [quest/faction_battle]: OnQuestComplete returned. QuestActive=" ::temp10 
            strcat ::temp10 ::temp10 " IsActive=" 
            cast ::temp9 ::IsActive_var 
            strcat ::temp9 ::temp10 ::temp9 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            jmp _label117
            ; line 4133
          _label117:
            return None 
            jmp _label108
            ; line 4135
          _label108:
            cmp_eq ::temp0 ::QuestSubType_var "find_item" 
            jmpf ::temp0 _label118
            ; line 4137
            cast ::temp1 None 
            cmp_eq ::temp0 ::QuestItemChest_var ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label119
            cmp_eq ::temp0 ::QuestItemName_var "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label119:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label120
            callstatic intelEngine IsQuestItemInChest ::temp0 ::QuestItemChest_var ::QuestItemName_var ;2 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label120:
            jmpf ::temp0 _label121
            ; line 4138
            strcat ::temp9 "Story [quest/find_item]: quest item '" ::QuestItemName_var 
            strcat ::temp9 ::temp9 "' retrieved from chest" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            ; line 4139
            callmethod OnQuestComplete self ::nonevar ;0 variable args
            jmp _label121
          _label121:
            jmp _label107
            ; line 4141
          _label118:
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            jmpf ::temp0 _label122
            ; line 4144
            not ::temp0 ::QuestVictimFreed_var 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label123
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label123:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label124
            callmethod Is3DLoaded ::QuestVictimNPC_var ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label124:
            jmpf ::temp0 _label125
            ; line 4146
            assign ::temp0 ::QuestPrePlaced_var 
            jmpf ::temp0 _label126
            not ::temp0 ::QuestFurnitureScanned_var 
            assign ::temp0 ::temp0 
          _label126:
            jmpf ::temp0 _label127
            ; line 4147
            assign ::QuestFurnitureScanned_var True 
            ; line 4148
            callstatic intelEngine FindUsablePrisonerFurniture ::temp1 ::QuestVictimNPC_var ;1 variable args
            assign usableFurn ::temp1 
            ; line 4149
            cast ::temp1 None 
            cmp_eq ::temp0 usableFurn ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label128
            ; line 4151
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4152
            callmethod RestoreActorValue ::QuestVictimNPC_var ::nonevar "Health" 500.0 ;2 variable args
            ; line 4153
            callmethod SetRestrained ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4154
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4155
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar usableFurn 0.0 0.0 0.0 True ;5 variable args
            ; line 4156
            cast ::temp1 ::QuestVictimNPC_var 
            callmethod Activate usableFurn ::temp0 ::temp1 False ;2 variable args
            ; line 4157
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 4158
            assign ::QuestVictimInFurniture_var True 
            ; line 4159
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: victim activated usable furniture in boss room" ;1 variable args
            jmp _label129
            ; line 4161
          _label128:
            callstatic intelEngine FindPrisonerFurniture ::temp1 ::QuestVictimNPC_var ;1 variable args
            assign prisonFurn ::temp1 
            ; line 4162
            cast ::temp1 None 
            cmp_eq ::temp0 prisonFurn ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label130
            ; line 4163
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar prisonFurn 0.0 0.0 0.0 True ;5 variable args
            ; line 4164
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: nudged victim to decorative prison prop in boss room" ;1 variable args
            jmp _label130
            ; line 4166
          _label130:
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 4167
            callmethod GetActorValue ::QuestVictimNPC_var ::temp3 "Health" ;1 variable args
            fadd ::temp3 ::temp3 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp3 ;2 variable args
            ; line 4168
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
          _label129:
            jmp _label127
            ; line 4173
          _label127:
            jmpf ::QuestVictimInFurniture_var _label131
            ; line 4174
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar True ;1 variable args
            jmp _label132
            ; line 4176
          _label131:
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 4177
            callmethod GetActorValue ::QuestVictimNPC_var ::temp3 "Health" ;1 variable args
            cmp_gt ::temp0 ::temp3 1.0 
            jmpf ::temp0 _label132
            ; line 4178
            callmethod GetActorValue ::QuestVictimNPC_var ::temp3 "Health" ;1 variable args
            fadd ::temp3 ::temp3 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp3 ;2 variable args
            ; line 4179
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4180
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp9 ;0 variable args
            strcat ::temp9 "Story [quest/rescue]: re-applied bleedout to " ::temp9 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            jmp _label132
          _label132:
            jmp _label125
            ; line 4186
          _label125:
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label133
            callmethod IsDead ::QuestVictimNPC_var ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label133:
            jmpf ::temp0 _label134
            ; line 4187
            strcat ::temp9 "Story [quest/rescue]: victim " ::QuestVictimName_var 
            strcat ::temp9 ::temp9 " died — quest failed" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            ; line 4188
            callmethod OnQuestFailed self ::nonevar ;0 variable args
            jmp _label135
            ; line 4189
          _label134:
            callmethod AreAllQuestEnemiesDead self ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label136
            callmethod IsAreaClearOfHostiles self ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label136:
            jmpf ::temp0 _label137
            ; line 4191
            not ::temp0 ::QuestVictimFreed_var 
            jmpf ::temp0 _label138
            ; line 4192
            callmethod FreeQuestVictim self ::nonevar ;0 variable args
            jmp _label138
            ; line 4194
          _label138:
            callmethod OnQuestComplete self ::nonevar ;0 variable args
            jmp _label135
            ; line 4195
          _label137:
            not ::temp0 ::QuestVictimFreed_var 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label139
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label139:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label140
            callmethod Is3DLoaded ::QuestVictimNPC_var ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label140:
            jmpf ::temp0 _label135
            ; line 4197
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign ::mangled_player_1 ::temp2 
            ; line 4198
            callmethod IsInCombat ::mangled_player_1 ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label141
            cast ::temp1 ::QuestVictimNPC_var 
            callmethod GetDistance ::mangled_player_1 ::temp3 ::temp1 ;1 variable args
            cmp_lt ::temp0 ::temp3 200.0 
            assign ::temp0 ::temp0 
          _label141:
            jmpf ::temp0 _label142
            ; line 4199
            callmethod FreeQuestVictim self ::nonevar ;0 variable args
            ; line 4200
            callmethod OnQuestComplete self ::nonevar ;0 variable args
            jmp _label142
          _label142:
            jmp _label135
          _label135:
            jmp _label107
            ; line 4205
          _label122:
            callmethod AreAllQuestEnemiesDead self ::temp0 ;0 variable args
            jmpf ::temp0 _label107
            ; line 4206
            callmethod OnQuestComplete self ::nonevar ;0 variable args
            jmp _label107
          _label107
          .endCode
        .endFunction ;CheckQuestProximity
        .function SpawnQuestEnemies
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Int
            .local player actor
            .local ::temp1 actor
            .local victimAnchor objectReference
            .local enemyAnchor objectReference
            .local ::temp2 Bool
            .local rescuePoint objectReference
            .local ::temp3 objectReference
            .local ::nonevar None
            .local deeperPoint objectReference
            .local ::temp4 String
            .local ::temp5 keyword
            .local ::temp6 package
            .local ::temp7 form
            .local ::temp8 actorBase
            .local ::temp9 Float
            .local ::temp10 referenceAlias
            .local chest objectReference
            .local boss actor
            .local ::temp11 form
            .local spawnedActors actor[]
            .local ::temp12 actor[]
            .local regularCount Int
            .local i Int
            .local ::temp13 Float
            .local ::mangled_boss_0 actor
            .local ::temp14 String
            .local allyName String
          .endLocalTable
          .code
            ; line 4213
            jmpf ::QuestEnemiesSpawned_var _label0
            ; line 4214
            return None 
            jmp _label0
            ; line 4217
          _label0:
            iadd ::temp0 ::QuestSpawnAttempts_var 1 
            assign ::QuestSpawnAttempts_var ::temp0 
            ; line 4222
            callstatic game GetPlayer ::temp1 ;0 variable args
            assign player ::temp1 
            ; line 4223
            assign victimAnchor ::QuestLocation_var 
            ; line 4224
            assign enemyAnchor ::QuestLocation_var 
            ; line 4225
            callmethod IsInInterior player ::temp2 ;0 variable args
            jmpf ::temp2 _label1
            ; line 4230
            cmp_eq ::temp2 ::QuestSubType_var "rescue" 
            jmpf ::temp2 _label2
            ; line 4232
            callstatic intelEngine FindRescueAnchor ::temp3 player ;1 variable args
            assign rescuePoint ::temp3 
            ; line 4233
            cast ::temp3 None 
            cmp_eq ::temp2 rescuePoint ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label3
            ; line 4234
            assign victimAnchor rescuePoint 
            ; line 4235
            cast ::temp3 player 
            assign enemyAnchor ::temp3 
            ; line 4236
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: victim deep at rescue anchor, enemies near player" ;1 variable args
            jmp _label4
            ; line 4240
          _label3:
            cast ::temp3 player 
            assign victimAnchor ::temp3 
            ; line 4241
            cast ::temp3 player 
            assign enemyAnchor ::temp3 
            ; line 4242
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: no rescue anchor, spawning near player (interior fallback)" ;1 variable args
          _label4:
            jmp _label5
            ; line 4246
          _label2:
            callstatic intelEngine FindDeeperSpawnPoint ::temp3 player ;1 variable args
            assign deeperPoint ::temp3 
            ; line 4247
            cast ::temp3 None 
            cmp_eq ::temp2 deeperPoint ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label6
            ; line 4248
            assign victimAnchor deeperPoint 
            ; line 4249
            assign enemyAnchor deeperPoint 
            ; line 4250
            strcat ::temp4 "Story [quest/" ::QuestSubType_var 
            strcat ::temp4 ::temp4 "]: spawning at dungeon landmark" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            jmp _label5
            ; line 4256
          _label6:
            cast ::temp3 player 
            assign victimAnchor ::temp3 
            ; line 4257
            cast ::temp3 player 
            assign enemyAnchor ::temp3 
            ; line 4258
            strcat ::temp4 "Story [quest/" ::QuestSubType_var 
            strcat ::temp4 ::temp4 "]: no landmarks found, spawning near player (interior fallback)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
          _label5:
            jmp _label1
            ; line 4264
          _label1:
            cmp_eq ::temp2 ::QuestSubType_var "rescue" 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label7
            cast ::temp1 None 
            cmp_eq ::temp2 ::QuestVictimNPC_var ::temp1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label7:
            jmpf ::temp2 _label8
            ; line 4266
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestVictimNPC_var False ;2 variable args
            ; line 4267
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar victimAnchor 0.0 0.0 0.0 False ;5 variable args
            ; line 4271
            cast ::temp3 ::QuestVictimNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp5 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp3 victimAnchor ::temp5 ;3 variable args
            ; line 4272
            propget SandboxNearPlayerPackage ::Core_var ::temp6 
            propget PRIORITY_TRAVEL ::Core_var ::temp0 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestVictimNPC_var ::temp6 ::temp0 1 ;4 variable args
            ; line 4274
            cast ::temp7 ::QuestVictimNPC_var 
            callmethod IsEssential ::QuestVictimNPC_var ::temp2 ;0 variable args
            cast ::temp0 ::temp2 
            callstatic storageUtil SetIntValue ::temp0 ::temp7 "Intel_WasEssential" ::temp0 ;3 variable args
            ; line 4275
            callmethod GetActorBase ::QuestVictimNPC_var ::temp8 ;0 variable args
            callmethod SetEssential ::temp8 ::nonevar True ;1 variable args
            ; line 4277
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 4278
            callmethod GetActorValue ::QuestVictimNPC_var ::temp9 "Health" ;1 variable args
            fadd ::temp9 ::temp9 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp9 ;2 variable args
            ; line 4279
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4280
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp4 ;0 variable args
            strcat ::temp4 "Story [quest/rescue]: placed victim " ::temp4 
            strcat ::temp4 ::temp4 " in bleedout" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            ; line 4282
            callstatic utility GetCurrentGameTime ::temp9 ;0 variable args
            callstatic intelEngine NotifyStoryCooldown ::nonevar ::QuestVictimNPC_var ::temp9 ;2 variable args
            ; line 4284
            cast ::temp10 None 
            cmp_eq ::temp2 ::QuestTargetAlias_var ::temp10 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label9
            ; line 4285
            cast ::temp3 ::QuestVictimNPC_var 
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::temp3 ;1 variable args
            ; line 4286
            propget QUEST_OBJECTIVE_ID self ::temp0 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp0 False False ;3 variable args
            ; line 4287
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 4288
            propget QUEST_OBJECTIVE_ID self ::temp0 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp0 True False ;3 variable args
            ; line 4289
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: quest marker moved to victim" ;1 variable args
            jmp _label9
          _label9:
            jmp _label8
            ; line 4294
          _label8:
            cmp_eq ::temp2 ::QuestSubType_var "find_item" 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label10
            cmp_eq ::temp2 ::QuestItemName_var "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label10:
            jmpf ::temp2 _label11
            ; line 4295
            callstatic intelEngine SpawnQuestChest ::temp3 victimAnchor ::QuestItemName_var ;2 variable args
            assign chest ::temp3 
            ; line 4296
            cast ::temp3 None 
            cmp_eq ::temp2 chest ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label12
            ; line 4297
            assign ::QuestItemChest_var chest 
            ; line 4298
            strcat ::temp4 "Story [quest/find_item]: placed chest with " ::QuestItemName_var 
            strcat ::temp4 ::temp4 " at " 
            strcat ::temp4 ::temp4 ::QuestLocationName_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            ; line 4300
            cast ::temp10 None 
            cmp_eq ::temp2 ::QuestTargetAlias_var ::temp10 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label13
            ; line 4301
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::QuestItemChest_var ;1 variable args
            ; line 4302
            propget QUEST_OBJECTIVE_ID self ::temp0 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp0 False False ;3 variable args
            ; line 4303
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 4304
            propget QUEST_OBJECTIVE_ID self ::temp0 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp0 True False ;3 variable args
            ; line 4305
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/find_item]: quest marker moved to chest" ;1 variable args
            jmp _label13
            ; line 4308
          _label13:
            callstatic intelEngine SpawnQuestBoss ::temp1 ::QuestItemChest_var ::QuestEnemyType_var ;2 variable args
            assign boss ::temp1 
            ; line 4309
            cast ::temp1 None 
            cmp_eq ::temp2 boss ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label14
            ; line 4310
            assign ::QuestBossNPC_var boss 
            ; line 4311
            cast ::temp7 player 
            cast ::temp11 boss 
            callstatic storageUtil FormListAdd ::temp0 ::temp7 "Intel_QuestSpawnedNPCs" ::temp11 True ;4 variable args
            ; line 4312
            iadd ::temp0 ::QuestSpawnCount_var 1 
            assign ::QuestSpawnCount_var ::temp0 
            ; line 4313
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/find_item]: spawned boss near chest" ;1 variable args
            jmp _label14
          _label14:
            jmp _label15
            ; line 4316
          _label12:
            strcat ::temp4 "Story [quest/find_item]: WARNING - chest spawn failed for " ::QuestItemName_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
          _label15:
            jmp _label11
            ; line 4321
          _label11:
            callstatic intelEngine SpawnQuestEnemies ::temp12 enemyAnchor ::QuestEnemyType_var ;2 variable args
            assign spawnedActors ::temp12 
            ; line 4322
            array_length ::temp0 spawnedActors 
            assign regularCount ::temp0 
            ; line 4323
            iadd ::temp0 ::QuestSpawnCount_var regularCount 
            assign ::QuestSpawnCount_var ::temp0 
            ; line 4325
            cmp_gt ::temp2 regularCount 0 
            jmpf ::temp2 _label16
            ; line 4327
            assign i 0 
            ; line 4328
          _label18:
            cmp_lt ::temp2 i regularCount 
            jmpf ::temp2 _label17
            ; line 4329
            array_getlement ::temp1 spawnedActors i 
            callmethod DisableNoWait ::temp1 ::nonevar False ;1 variable args
            ; line 4330
            callstatic utility RandomFloat ::temp9 -300.0 300.0 ;2 variable args
            callstatic utility RandomFloat ::temp13 -300.0 300.0 ;2 variable args
            array_getlement ::temp1 spawnedActors i 
            callmethod MoveTo ::temp1 ::nonevar enemyAnchor ::temp9 ::temp13 0.0 True ;5 variable args
            ; line 4331
            cast ::temp11 player 
            array_getlement ::temp1 spawnedActors i 
            cast ::temp7 ::temp1 
            callstatic storageUtil FormListAdd ::temp0 ::temp11 "Intel_QuestSpawnedNPCs" ::temp7 True ;4 variable args
            ; line 4332
            iadd ::temp0 i 1 
            assign i ::temp0 
            jmp _label18
            ; line 4334
          _label17:
            assign i 0 
            ; line 4335
          _label20:
            cmp_lt ::temp2 i regularCount 
            jmpf ::temp2 _label19
            ; line 4336
            array_getlement ::temp1 spawnedActors i 
            callmethod EnableNoWait ::temp1 ::nonevar False ;1 variable args
            ; line 4337
            iadd ::temp0 i 1 
            assign i ::temp0 
            jmp _label20
            ; line 4341
          _label19:
            cast ::temp1 None 
            cmp_eq ::temp2 ::QuestBossNPC_var ::temp1 
            jmpf ::temp2 _label21
            ; line 4342
            callstatic intelEngine SpawnQuestBoss ::temp1 enemyAnchor ::QuestEnemyType_var ;2 variable args
            assign ::mangled_boss_0 ::temp1 
            ; line 4343
            cast ::temp1 None 
            cmp_eq ::temp2 ::mangled_boss_0 ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label22
            ; line 4344
            callmethod DisableNoWait ::mangled_boss_0 ::nonevar False ;1 variable args
            ; line 4345
            callstatic utility RandomFloat ::temp13 -150.0 150.0 ;2 variable args
            callstatic utility RandomFloat ::temp9 -150.0 150.0 ;2 variable args
            callmethod MoveTo ::mangled_boss_0 ::nonevar enemyAnchor ::temp13 ::temp9 0.0 True ;5 variable args
            ; line 4346
            assign ::QuestBossNPC_var ::mangled_boss_0 
            ; line 4347
            cast ::temp7 player 
            cast ::temp11 ::mangled_boss_0 
            callstatic storageUtil FormListAdd ::temp0 ::temp7 "Intel_QuestSpawnedNPCs" ::temp11 True ;4 variable args
            ; line 4348
            iadd ::temp0 ::QuestSpawnCount_var 1 
            assign ::QuestSpawnCount_var ::temp0 
            ; line 4349
            callmethod EnableNoWait ::mangled_boss_0 ::nonevar False ;1 variable args
            jmp _label22
          _label22:
            jmp _label21
            ; line 4353
          _label21:
            assign ::QuestEnemiesSpawned_var True 
            ; line 4354
            strcat ::temp4 "Story [quest/" ::QuestSubType_var 
            strcat ::temp4 ::temp4 "]: spawned " 
            cast ::temp14 ::QuestSpawnCount_var 
            strcat ::temp14 ::temp4 ::temp14 
            strcat ::temp14 ::temp14 " " 
            strcat ::temp14 ::temp14 ::QuestEnemyType_var 
            strcat ::temp14 ::temp14 " at " 
            strcat ::temp14 ::temp14 ::QuestLocationName_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp14 ;1 variable args
            ; line 4357
            cmp_eq ::temp2 ::QuestSubType_var "combat" 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label23
            cast ::temp1 None 
            cmp_eq ::temp2 ::QuestBossNPC_var ::temp1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label23:
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label24
            cast ::temp10 None 
            cmp_eq ::temp2 ::QuestTargetAlias_var ::temp10 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label24:
            jmpf ::temp2 _label25
            ; line 4358
            cast ::temp3 ::QuestBossNPC_var 
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::temp3 ;1 variable args
            ; line 4359
            propget QUEST_OBJECTIVE_ID self ::temp0 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp0 False False ;3 variable args
            ; line 4360
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 4361
            propget QUEST_OBJECTIVE_ID self ::temp0 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp0 True False ;3 variable args
            ; line 4362
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/combat]: quest marker moved to boss" ;1 variable args
            jmp _label25
          _label25:
            jmp _label26
            ; line 4364
          _label16:
            comp_gte ::temp2 ::QuestSpawnAttempts_var 3 
            jmpf ::temp2 _label27
            ; line 4367
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: spawn failed after 3 attempts, granting partial completion" ;1 variable args
            ; line 4368
            callstatic debug Notification ::nonevar "The area is quiet. The threat seems to have moved on." ;1 variable args
            ; line 4369
            cast ::temp1 None 
            cmp_eq ::temp2 ::QuestGiver_var ::temp1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label28
            cmp_eq ::temp2 ::QuestEnemyType_var "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label28:
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label29
            cmp_eq ::temp2 ::QuestLocationName_var "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label29:
            jmpf ::temp2 _label30
            ; line 4370
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName ::temp1 ::temp14 ;0 variable args
            strcat ::temp14 "learned that " ::temp14 
            strcat ::temp14 ::temp14 " traveled to " 
            strcat ::temp14 ::temp14 ::QuestLocationName_var 
            strcat ::temp14 ::temp14 " but the " 
            strcat ::temp14 ::temp14 ::QuestEnemyType_var 
            strcat ::temp14 ::temp14 " threat had already dispersed" 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp14 ;2 variable args
            jmp _label30
            ; line 4373
          _label30:
            cmp_eq ::temp2 ::QuestAlliedFaction_var "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label31
            cmp_eq ::temp2 ::QuestSubType_var "faction_battle" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label31:
            jmpf ::temp2 _label32
            ; line 4374
            propget QUEST_STANDING_REWARD self ::temp0 
            idiv ::temp0 ::temp0 2 
            callstatic intelEngine AdjustPlayerFactionStanding ::temp0 ::QuestAlliedFaction_var ::temp0 ;2 variable args
            ; line 4375
            callstatic intelEngine GetFactionDisplayName ::temp14 ::QuestAlliedFaction_var ;1 variable args
            assign allyName ::temp14 
            ; line 4376
            cmp_eq ::temp2 allyName "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label33
            ; line 4377
            strcat ::temp14 "The " allyName 
            strcat ::temp14 ::temp14 " acknowledge your willingness to help." 
            callstatic debug Notification ::nonevar ::temp14 ;1 variable args
            jmp _label33
          _label33:
            jmp _label32
            ; line 4380
          _label32:
            callmethod RemoveQuestMarker self ::nonevar True ;1 variable args
            ; line 4381
            callmethod CleanupQuest self ::nonevar ;0 variable args
            jmp _label26
            ; line 4383
          _label27:
            strcat ::temp14 "Story [quest]: Failed to spawn " ::QuestEnemyType_var 
            strcat ::temp14 ::temp14 " (attempt " 
            cast ::temp4 ::QuestSpawnAttempts_var 
            strcat ::temp4 ::temp14 ::temp4 
            strcat ::temp4 ::temp4 "/3)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
          _label26
          .endCode
        .endFunction ;SpawnQuestEnemies
        .function AreAllQuestEnemiesDead
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local count Int
            .local ::temp1 form
            .local ::temp2 Int
            .local ::temp3 Bool
            .local i Int
            .local spawned actor
          .endLocalTable
          .code
            ; line 4388
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 4389
            cast ::temp1 player 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "Intel_QuestSpawnedNPCs" ;2 variable args
            assign count ::temp2 
            ; line 4390
            cmp_eq ::temp3 count 0 
            jmpf ::temp3 _label0
            ; line 4391
            return False 
            jmp _label0
            ; line 4393
          _label0:
            assign i 0 
            ; line 4394
          _label6:
            cmp_lt ::temp3 i count 
            jmpf ::temp3 _label1
            ; line 4395
            cast ::temp1 player 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "Intel_QuestSpawnedNPCs" i ;3 variable args
            cast ::temp0 ::temp1 
            assign spawned ::temp0 
            ; line 4398
            cast ::temp0 None 
            cmp_eq ::temp3 spawned ::temp0 
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label2
            callmethod IsDead spawned ::temp3 ;0 variable args
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
          _label2:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label3
            callmethod IsDeleted spawned ::temp3 ;0 variable args
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
          _label3:
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label4
            callmethod IsDisabled spawned ::temp3 ;0 variable args
            not ::temp3 ::temp3 
            assign ::temp3 ::temp3 
          _label4:
            jmpf ::temp3 _label5
            ; line 4399
            return False 
            jmp _label5
            ; line 4401
          _label5:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label6
            ; line 4403
          _label1:
            return True 
          .endCode
        .endFunction ;AreAllQuestEnemiesDead
        .function IsAreaClearOfHostiles
           ; function type 0
          .userFlags 0 ;none
          .docString "Returns false if any living hostile NPC is near the rescue victim.
    Uses MiscUtil.ScanCellNPCs to scan ALL nearby actors, not just quest-spawned."
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local player actor
            .local nearbyNPCs actor[]
            .local ::temp2 objectReference
            .local ::temp3 keyword
            .local ::temp4 actor[]
            .local i Int
            .local ::temp5 Int
            .local npc actor
          .endLocalTable
          .code
            ; line 4409
            cast ::temp0 None 
            cmp_eq ::temp1 ::QuestVictimNPC_var ::temp0 
            jmpf ::temp1 _label0
            ; line 4410
            return True 
            jmp _label0
            ; line 4412
          _label0:
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 4413
            cast ::temp2 ::QuestVictimNPC_var 
            cast ::temp3 None 
            callstatic miscUtil ScanCellNPCs ::temp4 ::temp2 3000.0 ::temp3 True ;4 variable args
            assign nearbyNPCs ::temp4 
            ; line 4414
            assign i 0 
            ; line 4415
          _label5:
            array_length ::temp5 nearbyNPCs 
            cmp_lt ::temp1 i ::temp5 
            jmpf ::temp1 _label1
            ; line 4416
            array_getlement ::temp0 nearbyNPCs i 
            assign npc ::temp0 
            ; line 4417
            cmp_eq ::temp1 npc player 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            cmp_eq ::temp1 npc ::QuestVictimNPC_var 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label2:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label3
            callmethod IsHostileToActor npc ::temp1 player ;1 variable args
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 4418
            return False 
            jmp _label4
            ; line 4420
          _label4:
            iadd ::temp5 i 1 
            assign i ::temp5 
            jmp _label5
            ; line 4422
          _label1:
            return True 
          .endCode
        .endFunction ;IsAreaClearOfHostiles
        .function FreeQuestVictim
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 objectReference
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 4426
            cast ::temp0 None 
            cmp_eq ::temp1 ::QuestVictimNPC_var ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            assign ::temp1 ::QuestVictimFreed_var 
          _label0:
            jmpf ::temp1 _label1
            ; line 4427
            return None 
            jmp _label1
            ; line 4429
          _label1:
            assign ::QuestVictimFreed_var True 
            ; line 4430
            jmpf ::QuestVictimInFurniture_var _label2
            ; line 4432
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4433
            cast ::temp2 ::QuestVictimNPC_var 
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar ::temp2 0.0 0.0 0.0 True ;5 variable args
            ; line 4434
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4435
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story [quest/rescue]: victim " ::temp3 
            strcat ::temp3 ::temp3 " freed from furniture" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label3
            ; line 4438
          _label2:
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4439
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4440
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story [quest/rescue]: victim " ::temp3 
            strcat ::temp3 ::temp3 " freed from bleedout" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 4443
          _label3:
            callmethod RestoreActorValue ::QuestVictimNPC_var ::nonevar "Health" 500.0 ;2 variable args
            ; line 4444
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp3 ;0 variable args
            strcat ::temp3 ::temp3 " has been freed!" 
            callmethod NotifyPlayer ::Core_var ::nonevar ::temp3 ;1 variable args
          .endCode
        .endFunction ;FreeQuestVictim
        .function OnQuestComplete
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 String
            .local playerName String
            .local ::temp2 actor
            .local victimAwareness Int
            .local ::temp3 Int
            .local ::temp4 form
            .local wasEssential Int
            .local ::temp5 actorBase
            .local ::temp6 form
            .local ::temp7 Float
            .local trackedPlayer actor
            .local ::temp8 objectReference
            .local ::temp9 objectReference
            .local ::temp10 keyword
            .local ::temp11 package
            .local completionJson String
            .local completionNotif String
            .local leaderFact String
            .local leaders actor[]
            .local ::temp12 actor[]
            .local li Int
            .local enemyFactionId String
            .local enemyFactionDisplayName String
            .local guideEnemyDesc String
            .local ::temp13 String
            .local allyName String
            .local standingRoll Int
          .endLocalTable
          .code
            ; line 4449
            not ::temp0 ::QuestActive_var 
            jmpf ::temp0 _label0
            ; line 4450
            return None 
            jmp _label0
            ; line 4452
          _label0:
            assign ::QuestActive_var False 
            ; line 4455
            cmp_eq ::temp0 ::QuestAlliedFaction_var "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label1
            ; line 4456
            callstatic intelEngine RestorePlayerCrimeFactions ::nonevar ;0 variable args
            jmp _label1
            ; line 4459
          _label1:
            strcat ::temp1 "Story [quest/" ::QuestSubType_var 
            strcat ::temp1 ::temp1 "]: Completed at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            strcat ::temp1 ::temp1 "!" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 4461
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDisplayName ::temp2 ::temp1 ;0 variable args
            assign playerName ::temp1 
            ; line 4463
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            jmpf ::temp0 _label2
            ; line 4465
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            callmethod IsDead ::QuestVictimNPC_var ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 4466
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: victim died before completion could finalize — redirecting to failed" ;1 variable args
            ; line 4467
            callmethod OnQuestFailed self ::nonevar ;0 variable args
            ; line 4468
            return None 
            jmp _label4
            ; line 4470
          _label4:
            callmethod NotifyPlayer ::Core_var ::nonevar "Rescue completed!" ;1 variable args
            ; line 4471
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label5
            ; line 4472
            strcat ::temp1 "learned that " playerName 
            strcat ::temp1 ::temp1 " rescued " 
            strcat ::temp1 ::temp1 ::QuestVictimName_var 
            strcat ::temp1 ::temp1 " from " 
            strcat ::temp1 ::temp1 ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp1 ;2 variable args
            jmp _label5
            ; line 4474
          _label5:
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label6
            ; line 4476
            callstatic intelEngine GetPlayerInteractionCount ::temp3 ::QuestVictimNPC_var ;1 variable args
            assign victimAwareness ::temp3 
            ; line 4477
            cmp_eq ::temp0 victimAwareness 0 
            jmpf ::temp0 _label7
            ; line 4479
            strcat ::temp1 "was rescued from " ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " captivity at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            strcat ::temp1 ::temp1 " by a stranger whose name I didn't know at the time" 
            callmethod InjectFact ::Core_var ::nonevar ::QuestVictimNPC_var ::temp1 ;2 variable args
            ; line 4480
            cast ::temp4 ::QuestVictimNPC_var 
            strcat ::temp1 "was just freed from " ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " captivity by a stranger whose name they don't know" 
            callstatic storageUtil SetStringValue ::temp1 ::temp4 "Intel_RescueNarration" ::temp1 ;3 variable args
            jmp _label8
            ; line 4481
          _label7:
            cmp_eq ::temp0 victimAwareness 1 
            jmpf ::temp0 _label9
            ; line 4483
            strcat ::temp1 "was rescued by " playerName 
            strcat ::temp1 ::temp1 " from " 
            strcat ::temp1 ::temp1 ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " captivity at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            strcat ::temp1 ::temp1 ". I recognized them — I'd seen them around before but we had never actually spoken" 
            callmethod InjectFact ::Core_var ::nonevar ::QuestVictimNPC_var ::temp1 ;2 variable args
            ; line 4484
            cast ::temp4 ::QuestVictimNPC_var 
            strcat ::temp1 "was just freed from " ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " captivity by " 
            strcat ::temp1 ::temp1 playerName 
            strcat ::temp1 ::temp1 ", someone they recognized from around town but had never spoken to before" 
            callstatic storageUtil SetStringValue ::temp1 ::temp4 "Intel_RescueNarration" ::temp1 ;3 variable args
            jmp _label8
            ; line 4487
          _label9:
            strcat ::temp1 "was rescued by " playerName 
            strcat ::temp1 ::temp1 " from " 
            strcat ::temp1 ::temp1 ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " captivity at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestVictimNPC_var ::temp1 ;2 variable args
            ; line 4488
            cast ::temp4 ::QuestVictimNPC_var 
            strcat ::temp1 "was just freed from " ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " captivity by " 
            strcat ::temp1 ::temp1 playerName 
            callstatic storageUtil SetStringValue ::temp1 ::temp4 "Intel_RescueNarration" ::temp1 ;3 variable args
            ; line 4491
          _label8:
            cast ::temp4 ::QuestVictimNPC_var 
            callstatic storageUtil GetIntValue ::temp3 ::temp4 "Intel_WasEssential" -1 ;3 variable args
            assign wasEssential ::temp3 
            ; line 4492
            comp_gte ::temp0 wasEssential 0 
            jmpf ::temp0 _label10
            ; line 4493
            cast ::temp0 wasEssential 
            callmethod GetActorBase ::QuestVictimNPC_var ::temp5 ;0 variable args
            callmethod SetEssential ::temp5 ::nonevar ::temp0 ;1 variable args
            ; line 4494
            cast ::temp4 ::QuestVictimNPC_var 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp4 "Intel_WasEssential" ;2 variable args
            jmp _label10
            ; line 4498
          _label10:
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label11
            ; line 4499
            cast ::temp4 ::QuestVictimNPC_var 
            cast ::temp6 ::QuestGiver_var 
            callstatic storageUtil SetFormValue ::temp6 ::temp4 "Intel_RescueQuestGiver" ::temp6 ;3 variable args
            ; line 4500
            cast ::temp6 ::QuestVictimNPC_var 
            callstatic storageUtil SetStringValue ::temp1 ::temp6 "Intel_RescuePlayerName" playerName ;3 variable args
            ; line 4501
            cast ::temp6 ::QuestVictimNPC_var 
            callstatic utility GetCurrentGameTime ::temp7 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp7 ::temp6 "Intel_RescueTime" ::temp7 ;3 variable args
            ; line 4503
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign trackedPlayer ::temp2 
            ; line 4504
            cast ::temp6 trackedPlayer 
            cast ::temp4 ::QuestVictimNPC_var 
            callstatic storageUtil FormListFind ::temp3 ::temp6 "Intel_RecentlyRescuedNPCs" ::temp4 ;3 variable args
            cmp_lt ::temp0 ::temp3 0 
            jmpf ::temp0 _label12
            ; line 4505
            cast ::temp4 trackedPlayer 
            cast ::temp6 ::QuestVictimNPC_var 
            callstatic storageUtil FormListAdd ::temp3 ::temp4 "Intel_RecentlyRescuedNPCs" ::temp6 True ;4 variable args
            jmp _label12
          _label12:
            jmp _label11
            ; line 4513
          _label11:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestVictimNPC_var False ;2 variable args
            ; line 4514
            cast ::temp8 ::QuestVictimNPC_var 
            callstatic game GetPlayer ::temp2 ;0 variable args
            cast ::temp9 ::temp2 
            propget IntelEngine_TravelTarget ::Core_var ::temp10 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp8 ::temp9 ::temp10 ;3 variable args
            ; line 4515
            propget TravelPackage_Walk ::Core_var ::temp11 
            propget PRIORITY_TRAVEL ::Core_var ::temp3 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestVictimNPC_var ::temp11 ::temp3 1 ;4 variable args
            ; line 4516
            cast ::temp6 ::QuestVictimNPC_var 
            callstatic storageUtil SetIntValue ::temp3 ::temp6 "Intel_MeetingLingerApproaching" 1 ;3 variable args
            ; line 4517
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 4518
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4519
            callmethod StartStoryLinger self ::nonevar ::QuestVictimNPC_var ;1 variable args
            ; line 4521
            cast ::temp2 None 
            assign ::QuestVictimNPC_var ::temp2 
            jmp _label6
          _label6:
            jmp _label13
            ; line 4523
          _label2:
            cmp_eq ::temp0 ::QuestSubType_var "find_item" 
            jmpf ::temp0 _label14
            ; line 4524
            strcat ::temp1 "You claim the " ::QuestItemDesc_var 
            strcat ::temp1 ::temp1 "." 
            callmethod NotifyPlayer ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 4525
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label15
            ; line 4526
            strcat ::temp1 "learned that " playerName 
            strcat ::temp1 ::temp1 " found " 
            strcat ::temp1 ::temp1 ::QuestItemDesc_var 
            strcat ::temp1 ::temp1 " at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp1 ;2 variable args
            jmp _label15
          _label15:
            jmp _label13
            ; line 4528
          _label14:
            cmp_eq ::temp0 ::QuestSubType_var "faction_battle" 
            jmpf ::temp0 _label16
            ; line 4530
            callstatic intelEngine RecordFactionBattleCompletion ::temp1 ::QuestAlliedFaction_var ::QuestLocationName_var playerName ::QuestBattleEnemyFaction_var ;4 variable args
            assign completionJson ::temp1 
            ; line 4531
            callstatic intelEngine StoryResponseGetField ::temp1 completionJson "notification" ;2 variable args
            assign completionNotif ::temp1 
            ; line 4532
            cmp_eq ::temp0 completionNotif "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label17
            ; line 4533
            callstatic debug Notification ::nonevar completionNotif ;1 variable args
            jmp _label17
            ; line 4536
          _label17:
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label18
            ; line 4537
            callstatic intelEngine StoryResponseGetField ::temp1 completionJson "questGiverFact" ;2 variable args
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp1 ;2 variable args
            jmp _label18
            ; line 4539
          _label18:
            callstatic intelEngine StoryResponseGetField ::temp1 completionJson "leaderFact" ;2 variable args
            assign leaderFact ::temp1 
            ; line 4540
            cmp_eq ::temp0 leaderFact "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label19
            ; line 4541
            callstatic intelEngine GetFactionLeaderActors ::temp12 ::QuestAlliedFaction_var ;1 variable args
            assign leaders ::temp12 
            ; line 4542
            assign li 0 
            ; line 4543
          _label23:
            array_length ::temp3 leaders 
            cmp_lt ::temp0 li ::temp3 
            jmpf ::temp0 _label20
            ; line 4544
            array_getlement ::temp2 leaders li 
            cast ::temp0 ::temp2 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label21
            array_getlement ::temp2 leaders li 
            cmp_eq ::temp0 ::temp2 ::QuestGiver_var 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label21:
            jmpf ::temp0 _label22
            ; line 4545
            array_getlement ::temp2 leaders li 
            callmethod InjectFact ::Core_var ::nonevar ::temp2 leaderFact ;2 variable args
            jmp _label22
            ; line 4547
          _label22:
            iadd ::temp3 li 1 
            assign li ::temp3 
            jmp _label23
          _label20:
            jmp _label19
          _label19:
            jmp _label13
            ; line 4552
          _label16:
            callmethod NotifyPlayer ::Core_var ::nonevar "The threat has been dealt with." ;1 variable args
            ; line 4553
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label13
            ; line 4554
            strcat ::temp1 "learned that " playerName 
            strcat ::temp1 ::temp1 " dealt with the " 
            strcat ::temp1 ::temp1 ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " threat at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp1 ;2 variable args
            jmp _label13
            ; line 4559
          _label13:
            callstatic intelEngine ExtractFactionId ::temp1 ::QuestEnemyType_var ;1 variable args
            assign enemyFactionId ::temp1 
            ; line 4560
            assign enemyFactionDisplayName "" 
            ; line 4561
            cmp_eq ::temp0 enemyFactionId "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label24
            ; line 4562
            callstatic intelEngine GetFactionDisplayName ::temp1 enemyFactionId ;1 variable args
            assign enemyFactionDisplayName ::temp1 
            jmp _label24
            ; line 4566
          _label24:
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestGuideNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label25
            cmp_eq ::temp0 ::QuestGuideNPC_var ::QuestGiver_var 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label25:
            jmpf ::temp0 _label26
            ; line 4567
            assign guideEnemyDesc ::QuestEnemyType_var 
            ; line 4568
            cmp_eq ::temp0 enemyFactionDisplayName "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label27
            ; line 4569
            strcat ::temp1 enemyFactionDisplayName " soldiers" 
            assign guideEnemyDesc ::temp1 
            jmp _label27
            ; line 4571
          _label27:
            strcat ::temp1 "witnessed " playerName 
            strcat ::temp1 ::temp1 " clear the " 
            strcat ::temp1 ::temp1 guideEnemyDesc 
            strcat ::temp1 ::temp1 " at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGuideNPC_var ::temp1 ;2 variable args
            jmp _label26
            ; line 4577
          _label26:
            cmp_eq ::temp0 ::QuestAlliedFaction_var "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label28
            cmp_eq ::temp0 ::QuestSubType_var "faction_battle" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label28:
            jmpf ::temp0 _label29
            ; line 4578
            cmp_eq ::temp0 enemyFactionId "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label30
            ; line 4579
            propget QUEST_STANDING_PENALTY self ::temp3 
            callstatic intelEngine AdjustPlayerFactionStanding ::temp3 enemyFactionId ::temp3 ;2 variable args
            ; line 4580
            strcat ::temp1 "Story [quest/" ::QuestSubType_var 
            strcat ::temp1 ::temp1 "]: Standing " 
            propget QUEST_STANDING_PENALTY self ::temp3 
            cast ::temp13 ::temp3 
            strcat ::temp13 ::temp1 ::temp13 
            strcat ::temp13 ::temp13 " with " 
            strcat ::temp13 ::temp13 enemyFactionId 
            callmethod DebugMsg ::Core_var ::nonevar ::temp13 ;1 variable args
            jmp _label30
            ; line 4582
          _label30:
            propget QUEST_STANDING_REWARD self ::temp3 
            callstatic intelEngine AdjustPlayerFactionStanding ::temp3 ::QuestAlliedFaction_var ::temp3 ;2 variable args
            ; line 4583
            strcat ::temp13 "Story [quest/" ::QuestSubType_var 
            strcat ::temp13 ::temp13 "]: Standing +" 
            propget QUEST_STANDING_REWARD self ::temp3 
            cast ::temp1 ::temp3 
            strcat ::temp1 ::temp13 ::temp1 
            strcat ::temp1 ::temp1 " with " 
            strcat ::temp1 ::temp1 ::QuestAlliedFaction_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 4585
            callstatic intelEngine GetFactionDisplayName ::temp1 ::QuestAlliedFaction_var ;1 variable args
            assign allyName ::temp1 
            ; line 4586
            cmp_eq ::temp0 allyName "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label31
            ; line 4587
            callstatic utility RandomInt ::temp3 0 2 ;2 variable args
            assign standingRoll ::temp3 
            ; line 4588
            cmp_eq ::temp0 standingRoll 0 
            jmpf ::temp0 _label32
            ; line 4589
            strcat ::temp1 "Your name carries weight among the " allyName 
            strcat ::temp1 ::temp1 "." 
            callstatic debug Notification ::nonevar ::temp1 ;1 variable args
            jmp _label33
            ; line 4590
          _label32:
            cmp_eq ::temp0 standingRoll 1 
            jmpf ::temp0 _label34
            ; line 4591
            strcat ::temp1 "The " allyName 
            strcat ::temp1 ::temp1 " speak your name with respect." 
            callstatic debug Notification ::nonevar ::temp1 ;1 variable args
            jmp _label33
            ; line 4593
          _label34:
            strcat ::temp1 "Word of your deeds reaches the " allyName 
            strcat ::temp1 ::temp1 "." 
            callstatic debug Notification ::nonevar ::temp1 ;1 variable args
          _label33:
            jmp _label31
          _label31:
            jmp _label29
            ; line 4598
          _label29:
            callmethod RemoveQuestMarker self ::nonevar True ;1 variable args
            ; line 4599
            callmethod CleanupQuest self ::nonevar ;0 variable args
          .endCode
        .endFunction ;OnQuestComplete
        .function OnQuestFailed
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local playerName String
            .local ::temp1 actor
            .local ::temp2 Bool
          .endLocalTable
          .code
            ; line 4603
            strcat ::temp0 "Story [quest/" ::QuestSubType_var 
            strcat ::temp0 ::temp0 "]: Failed at " 
            strcat ::temp0 ::temp0 ::QuestLocationName_var 
            strcat ::temp0 ::temp0 " — victim died" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 4605
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName ::temp1 ::temp0 ;0 variable args
            assign playerName ::temp0 
            ; line 4607
            strcat ::temp0 ::QuestVictimName_var " didn't make it." 
            callmethod NotifyPlayer ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 4608
            cast ::temp1 None 
            cmp_eq ::temp2 ::QuestGiver_var ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label0
            ; line 4609
            strcat ::temp0 "learned that " ::QuestVictimName_var 
            strcat ::temp0 ::temp0 " was killed by " 
            strcat ::temp0 ::temp0 ::QuestEnemyType_var 
            strcat ::temp0 ::temp0 " at " 
            strcat ::temp0 ::temp0 ::QuestLocationName_var 
            strcat ::temp0 ::temp0 " despite " 
            strcat ::temp0 ::temp0 playerName 
            strcat ::temp0 ::temp0 "'s efforts" 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp0 ;2 variable args
            jmp _label0
            ; line 4612
          _label0:
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 4613
            callmethod CleanupQuest self ::nonevar ;0 variable args
          .endCode
        .endFunction ;OnQuestFailed
        .function CheckQuestExpiry
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local elapsed Float
            .local ::temp1 Float
            .local ::nonevar None
            .local ::temp2 String
            .local ::temp3 String
            .local playerName String
            .local ::temp4 actor
            .local allyNameExpiry String
            .local ::temp5 intelEngine_Battle
            .local ::temp6 intelEngine_Battle
          .endLocalTable
          .code
            ; line 4619
            not ::temp0 ::QuestActive_var 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cmp_lte ::temp0 ::QuestStartTime_var 0.0 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 4620
            return None 
            jmp _label1
            ; line 4622
          _label1:
            callstatic utility GetCurrentGameTime ::temp1 ;0 variable args
            fsub ::temp1 ::temp1 ::QuestStartTime_var 
            assign elapsed ::temp1 
            ; line 4624
            not ::temp0 ::QuestExpiryWarned_var 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label2
            fmul ::temp1 ::QUEST_EXPIRY_DAYS_var 0.75 
            cmp_gt ::temp0 elapsed ::temp1 
            assign ::temp0 ::temp0 
          _label2:
            jmpf ::temp0 _label3
            ; line 4625
            assign ::QuestExpiryWarned_var True 
            ; line 4626
            callstatic debug Notification ::nonevar "You should hurry — the situation won't hold much longer." ;1 variable args
            jmp _label3
            ; line 4628
          _label3:
            cmp_gt ::temp0 elapsed ::QUEST_EXPIRY_DAYS_var 
            jmpf ::temp0 _label4
            ; line 4629
            strcat ::temp2 "Story [quest/" ::QuestSubType_var 
            strcat ::temp2 ::temp2 "]: Expired after " 
            cast ::temp3 ::QUEST_EXPIRY_DAYS_var 
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 " days" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 4630
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod GetDisplayName ::temp4 ::temp3 ;0 variable args
            assign playerName ::temp3 
            ; line 4631
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            jmpf ::temp0 _label5
            ; line 4632
            cast ::temp4 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label6
            ; line 4633
            strcat ::temp3 "grew desperate -- " ::QuestVictimName_var 
            strcat ::temp3 ::temp3 " may be lost, " 
            strcat ::temp3 ::temp3 playerName 
            strcat ::temp3 ::temp3 " never came to help" 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp3 ;2 variable args
            jmp _label6
          _label6:
            jmp _label7
            ; line 4636
          _label5:
            cmp_eq ::temp0 ::QuestSubType_var "find_item" 
            jmpf ::temp0 _label8
            ; line 4637
            cast ::temp4 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label9
            ; line 4638
            strcat ::temp3 "gave up hope that " playerName 
            strcat ::temp3 ::temp3 " would find " 
            strcat ::temp3 ::temp3 ::QuestItemDesc_var 
            strcat ::temp3 ::temp3 " at " 
            strcat ::temp3 ::temp3 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp3 ;2 variable args
            jmp _label9
          _label9:
            jmp _label7
            ; line 4640
          _label8:
            cmp_eq ::temp0 ::QuestSubType_var "faction_battle" 
            jmpf ::temp0 _label10
            ; line 4641
            cast ::temp4 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label11
            ; line 4642
            callstatic intelEngine GetFactionDisplayName ::temp3 ::QuestAlliedFaction_var ;1 variable args
            assign allyNameExpiry ::temp3 
            ; line 4643
            strcat ::temp3 "noted that " playerName 
            strcat ::temp3 ::temp3 " never arrived to fight alongside the " 
            strcat ::temp3 ::temp3 allyNameExpiry 
            strcat ::temp3 ::temp3 " at " 
            strcat ::temp3 ::temp3 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp3 ;2 variable args
            jmp _label11
            ; line 4646
          _label11:
            assign ::temp0 ::QuestBattleScheduled_var 
            jmpf ::temp0 _label12
            propget Battle ::Core_var ::temp5 
            cast ::temp6 None 
            cmp_eq ::temp0 ::temp5 ::temp6 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label12:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label13
            propget Battle ::Core_var ::temp6 
            propget BattleScheduled ::temp6 ::temp0 
            assign ::temp0 ::temp0 
          _label13:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label14
            callstatic intelEngine IsBattleActive ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label14:
            jmpf ::temp0 _label15
            ; line 4647
            propget Battle ::Core_var ::temp6 
            callmethod ResetState ::temp6 ::nonevar ;0 variable args
            ; line 4648
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/faction_battle]: cancelled scheduled battle on expiry" ;1 variable args
            jmp _label15
            ; line 4650
          _label15:
            callstatic debug Notification ::nonevar "Word reaches you: the battle has moved on." ;1 variable args
            jmp _label7
            ; line 4652
          _label10:
            cast ::temp4 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label7
            ; line 4653
            strcat ::temp3 "grew disappointed that " playerName 
            strcat ::temp3 ::temp3 " never dealt with the " 
            strcat ::temp3 ::temp3 ::QuestEnemyType_var 
            strcat ::temp3 ::temp3 " threat at " 
            strcat ::temp3 ::temp3 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp3 ;2 variable args
            jmp _label7
            ; line 4656
          _label7:
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 4657
            callmethod CleanupQuest self ::nonevar ;0 variable args
            jmp _label4
          _label4
          .endCode
        .endFunction ;CheckQuestExpiry
        .function CleanupQuest
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local eventText String
            .local ::temp0 String
            .local ::temp1 actor
            .local ::temp2 form
            .local ::temp3 Int
            .local ::temp4 Bool
            .local courierSlot Int
            .local origAggr Float
            .local ::temp5 Float
            .local slot Int
            .local ::temp6 objectReference
            .local wasEssential Int
            .local ::temp7 actorBase
            .local ::temp8 cell
            .local ::temp9 String
          .endLocalTable
          .code
            ; line 4663
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 4665
            strcat ::temp0 "quest/" ::QuestSubType_var 
            strcat ::temp0 ::temp0 ": " 
            strcat ::temp0 ::temp0 ::QuestEnemyType_var 
            strcat ::temp0 ::temp0 " at " 
            strcat ::temp0 ::temp0 ::QuestLocationName_var 
            assign eventText ::temp0 
            ; line 4666
            callstatic game GetPlayer ::temp1 ;0 variable args
            cast ::temp2 ::temp1 
            callstatic storageUtil FormListClear ::temp3 ::temp2 "Intel_QuestSpawnedNPCs" ;2 variable args
            ; line 4671
            assign ::temp4 ::IsActive_var 
            jmpf ::temp4 _label0
            cast ::temp1 None 
            cmp_eq ::temp4 ::ActiveStoryNPC_var ::temp1 
            not ::temp4 ::temp4 
            assign ::temp4 ::temp4 
          _label0:
            assign ::temp4 ::temp4 
            jmpf ::temp4 _label1
            cmp_eq ::temp4 ::ActiveStoryType_var "quest" 
            assign ::temp4 ::temp4 
          _label1:
            jmpf ::temp4 _label2
            ; line 4672
            callmethod FindSlotByAgent ::Core_var ::temp3 ::ActiveStoryNPC_var ;1 variable args
            assign courierSlot ::temp3 
            ; line 4673
            comp_gte ::temp4 courierSlot 0 
            jmpf ::temp4 _label3
            ; line 4674
            callmethod ClearSlot ::Core_var ::nonevar courierSlot True False ;3 variable args
            jmp _label3
            ; line 4676
          _label3:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 4680
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp5 ::temp2 "Intel_OrigAggression" -1.0 ;3 variable args
            assign origAggr ::temp5 
            ; line 4681
            comp_gte ::temp4 origAggr 0.0 
            jmpf ::temp4 _label4
            ; line 4682
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Aggression" origAggr ;2 variable args
            ; line 4683
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp4 ::temp2 "Intel_OrigAggression" ;2 variable args
            jmp _label4
            ; line 4685
          _label4:
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetIntValue ::temp4 ::temp2 "Intel_IsStoryDispatch" ;2 variable args
            ; line 4686
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_StoryNarration" ;2 variable args
            ; line 4687
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_MessageSender" ;2 variable args
            ; line 4688
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_MessageContent" ;2 variable args
            ; line 4689
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_QuestLocation" ;2 variable args
            ; line 4690
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetIntValue ::temp4 ::temp2 "Intel_SneakPhase" ;2 variable args
            ; line 4691
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp4 ::temp2 "Intel_SneakStartTime" ;2 variable args
            ; line 4692
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp4 ::temp2 "Intel_CombatStartTime" ;2 variable args
            ; line 4693
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp4 ::temp2 "Intel_OffscreenArrival" ;2 variable args
            ; line 4694
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_MessageDest" ;2 variable args
            ; line 4695
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_MessageTime" ;2 variable args
            ; line 4696
            cast ::temp1 None 
            assign ::ActiveStoryNPC_var ::temp1 
            ; line 4697
            assign ::ActiveNarration_var "" 
            ; line 4698
            assign ::ActiveStoryType_var "" 
            ; line 4699
            assign ::IsActive_var False 
            ; line 4700
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: cleared courier dispatch (quest cancelled)" ;1 variable args
            jmp _label2
            ; line 4703
          _label2:
            cast ::temp1 None 
            cmp_eq ::temp4 ::QuestGuideNPC_var ::temp1 
            not ::temp4 ::temp4 
            jmpf ::temp4 _label5
            ; line 4704
            callmethod FindSlotByAgent ::Core_var ::temp3 ::QuestGuideNPC_var ;1 variable args
            assign slot ::temp3 
            ; line 4705
            comp_gte ::temp4 slot 0 
            jmpf ::temp4 _label6
            ; line 4706
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label6
            ; line 4708
          _label6:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestGuideNPC_var False ;2 variable args
            jmp _label5
            ; line 4712
          _label5:
            cast ::temp1 None 
            cmp_eq ::temp4 ::QuestVictimNPC_var ::temp1 
            not ::temp4 ::temp4 
            jmpf ::temp4 _label7
            ; line 4713
            jmpf ::QuestVictimInFurniture_var _label8
            ; line 4714
            cast ::temp6 ::QuestVictimNPC_var 
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar ::temp6 0.0 0.0 0.0 True ;5 variable args
            jmp _label8
            ; line 4716
          _label8:
            callmethod SetRestrained ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4717
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4718
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4719
            callmethod RestoreActorValue ::QuestVictimNPC_var ::nonevar "Health" 500.0 ;2 variable args
            ; line 4720
            cast ::temp2 ::QuestVictimNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_RescueNarration" ;2 variable args
            ; line 4721
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestVictimNPC_var False ;2 variable args
            ; line 4723
            cast ::temp2 ::QuestVictimNPC_var 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "Intel_WasEssential" -1 ;3 variable args
            assign wasEssential ::temp3 
            ; line 4724
            comp_gte ::temp4 wasEssential 0 
            jmpf ::temp4 _label9
            ; line 4725
            cast ::temp4 wasEssential 
            callmethod GetActorBase ::QuestVictimNPC_var ::temp7 ;0 variable args
            callmethod SetEssential ::temp7 ::nonevar ::temp4 ;1 variable args
            ; line 4726
            cast ::temp2 ::QuestVictimNPC_var 
            callstatic storageUtil UnsetIntValue ::temp4 ::temp2 "Intel_WasEssential" ;2 variable args
            jmp _label9
            ; line 4729
          _label9:
            not ::temp4 ::QuestVictimFreed_var 
            jmpf ::temp4 _label10
            ; line 4730
            strcat ::temp0 "managed to escape " ::QuestEnemyType_var 
            strcat ::temp0 ::temp0 " captivity at " 
            strcat ::temp0 ::temp0 ::QuestLocationName_var 
            strcat ::temp0 ::temp0 " on my own" 
            callmethod InjectFact ::Core_var ::nonevar ::QuestVictimNPC_var ::temp0 ;2 variable args
            jmp _label10
            ; line 4732
          _label10:
            callmethod MoveToMyEditorLocation ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4734
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4735
            cast ::temp1 None 
            assign ::QuestVictimNPC_var ::temp1 
            jmp _label7
            ; line 4739
          _label7:
            cast ::temp6 None 
            cmp_eq ::temp4 ::QuestItemChest_var ::temp6 
            not ::temp4 ::temp4 
            jmpf ::temp4 _label11
            ; line 4740
            callmethod Disable ::QuestItemChest_var ::nonevar False ;1 variable args
            ; line 4741
            callmethod Delete ::QuestItemChest_var ::nonevar ;0 variable args
            ; line 4742
            cast ::temp6 None 
            assign ::QuestItemChest_var ::temp6 
            jmp _label11
            ; line 4746
          _label11:
            cast ::temp6 None 
            cmp_eq ::temp4 ::QuestBattleMarker_var ::temp6 
            not ::temp4 ::temp4 
            jmpf ::temp4 _label12
            ; line 4747
            callmethod Disable ::QuestBattleMarker_var ::nonevar False ;1 variable args
            ; line 4748
            callmethod Delete ::QuestBattleMarker_var ::nonevar ;0 variable args
            ; line 4749
            cast ::temp6 None 
            assign ::QuestBattleMarker_var ::temp6 
            jmp _label12
            ; line 4755
          _label12:
            cmp_eq ::temp4 ::QuestAlliedFaction_var "" 
            not ::temp4 ::temp4 
            jmpf ::temp4 _label13
            ; line 4756
            callstatic intelEngine RestorePlayerCrimeFactions ::nonevar ;0 variable args
            jmp _label13
            ; line 4759
          _label13:
            assign ::QuestActive_var False 
            ; line 4760
            callstatic intelEngine NotifyQuestCleared ::nonevar ;0 variable args
            ; line 4761
            cast ::temp1 None 
            assign ::QuestGiver_var ::temp1 
            ; line 4762
            cast ::temp1 None 
            assign ::QuestGuideNPC_var ::temp1 
            ; line 4763
            assign ::QuestGuideActive_var False 
            ; line 4764
            assign ::QuestGuideWaiting_var False 
            ; line 4765
            assign ::QuestGuideStartTime_var 0.0 
            ; line 4766
            cast ::temp6 None 
            assign ::QuestLocation_var ::temp6 
            ; line 4767
            assign ::QuestDeferredToInterior_var False 
            ; line 4768
            assign ::QuestEnemyType_var "" 
            ; line 4769
            assign ::QuestLocationName_var "" 
            ; line 4770
            assign ::QuestEnemiesSpawned_var False 
            ; line 4771
            assign ::QuestSpawnCount_var 0 
            ; line 4772
            assign ::QuestSpawnAttempts_var 0 
            ; line 4773
            assign ::QuestStartTime_var 0.0 
            ; line 4776
            assign ::QuestSubType_var "" 
            ; line 4777
            assign ::QuestBriefing_var "" 
            ; line 4778
            assign ::QuestVictimName_var "" 
            ; line 4779
            assign ::QuestItemDesc_var "" 
            ; line 4780
            assign ::QuestItemName_var "" 
            ; line 4781
            assign ::QuestAlliedFaction_var "" 
            ; line 4782
            assign ::QuestBattleScheduled_var False 
            ; line 4783
            assign ::QuestVictimFreed_var False 
            ; line 4784
            cast ::temp1 None 
            assign ::QuestBossNPC_var ::temp1 
            ; line 4785
            assign ::QuestPrePlaced_var False 
            ; line 4786
            cast ::temp6 None 
            assign ::QuestBossAnchor_var ::temp6 
            ; line 4787
            assign ::QuestFurnitureScanned_var False 
            ; line 4788
            assign ::QuestVictimInFurniture_var False 
            ; line 4789
            cast ::temp8 None 
            assign ::QuestDungeonLastCell_var ::temp8 
            ; line 4790
            assign ::QuestDungeonDepth_var 0 
            ; line 4791
            assign ::QuestDungeonScanFails_var 0 
            ; line 4792
            assign ::QuestExpiryWarned_var False 
            ; line 4794
            callmethod AddRecentStoryEvent self ::nonevar eventText ;1 variable args
            ; line 4795
            cast ::temp0 ::QuestActive_var 
            strcat ::temp0 "Story [quest]: CleanupQuest done — QuestActive=" ::temp0 
            strcat ::temp0 ::temp0 " IsActive=" 
            cast ::temp9 ::IsActive_var 
            strcat ::temp9 ::temp0 ::temp9 
            strcat ::temp9 ::temp9 " IsNPCStoryActive=" 
            cast ::temp0 ::IsNPCStoryActive_var 
            strcat ::temp0 ::temp9 ::temp0 
            strcat ::temp0 ::temp0 " HasLingerNPCs=" 
            callmethod HasLingerNPCs self ::temp4 ;0 variable args
            cast ::temp9 ::temp4 
            strcat ::temp9 ::temp0 ::temp9 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
          .endCode
        .endFunction ;CleanupQuest
        .function PlaceQuestMarker
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 referenceAlias
            .local ::temp1 Bool
            .local i Int
            .local ::temp2 Int
            .local ra referenceAlias
            .local ::temp3 alias
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 objectReference
            .local ::temp6 String
            .local ::temp7 actor
            .local aliasRef objectReference
          .endLocalTable
          .code
            ; line 4805
            cast ::temp0 None 
            cmp_eq ::temp1 ::QuestTargetAlias_var ::temp0 
            jmpf ::temp1 _label0
            ; line 4806
            callmethod GetNumAliases self ::temp2 ;0 variable args
            isub ::temp2 ::temp2 1 
            assign i ::temp2 
            ; line 4807
          _label14:
            comp_gte ::temp1 i 1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            cast ::temp0 None 
            cmp_eq ::temp1 ::QuestTargetAlias_var ::temp0 
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 4808
            callmethod GetAlias self ::temp3 i ;1 variable args
            cast ::temp0 ::temp3 
            assign ra ::temp0 
            ; line 4809
            cast ::temp0 None 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            ; line 4810
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label3
            propget AgentAlias00 ::Core_var ::temp0 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label3:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label4
            propget AgentAlias01 ::Core_var ::temp0 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            ; line 4811
          _label4:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label5
            propget AgentAlias02 ::Core_var ::temp0 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label5:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label6
            propget AgentAlias03 ::Core_var ::temp0 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            ; line 4812
          _label6:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label7
            propget AgentAlias04 ::Core_var ::temp0 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            ; line 4813
          _label7:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label8
            propget TargetAlias00 ::Core_var ::temp0 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label8:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label9
            propget TargetAlias01 ::Core_var ::temp0 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            ; line 4814
          _label9:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label10
            propget TargetAlias02 ::Core_var ::temp0 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label10:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label11
            propget TargetAlias03 ::Core_var ::temp0 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            ; line 4815
          _label11:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label12
            propget TargetAlias04 ::Core_var ::temp0 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label12:
            jmpf ::temp1 _label13
            ; line 4816
            assign ::QuestTargetAlias_var ra 
            ; line 4817
            cast ::temp4 i 
            strcat ::temp4 "Story [quest]: Recovered QuestTargetAlias at alias index " ::temp4 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            jmp _label13
            ; line 4819
          _label13:
            isub ::temp2 i 1 
            assign i ::temp2 
            jmp _label14
          _label2:
            jmp _label0
            ; line 4822
          _label0:
            cast ::temp0 None 
            cmp_eq ::temp1 ::QuestTargetAlias_var ::temp0 
            jmpf ::temp1 _label15
            ; line 4823
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: WARNING - QuestTargetAlias not found! Check alias setup in CK" ;1 variable args
            ; line 4824
            callmethod NotifyPlayer ::Core_var ::nonevar "Quest marker unavailable (alias not found)" ;1 variable args
            ; line 4825
            return None 
            jmp _label15
            ; line 4827
          _label15:
            cast ::temp5 None 
            cmp_eq ::temp1 ::QuestLocation_var ::temp5 
            jmpf ::temp1 _label16
            ; line 4828
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: WARNING - QuestLocation is None, can't place marker" ;1 variable args
            ; line 4829
            return None 
            jmp _label16
            ; line 4831
          _label16:
            cast ::temp4 ::QuestTargetAlias_var 
            strcat ::temp4 "Story [quest]: PlaceQuestMarker - alias=" ::temp4 
            strcat ::temp4 ::temp4 ", location=" 
            cast ::temp6 ::QuestLocation_var 
            strcat ::temp6 ::temp4 ::temp6 
            strcat ::temp6 ::temp6 " (" 
            strcat ::temp6 ::temp6 ::QuestLocationName_var 
            strcat ::temp6 ::temp6 "), prePlaced=" 
            cast ::temp4 ::QuestPrePlaced_var 
            strcat ::temp4 ::temp6 ::temp4 
            strcat ::temp4 ::temp4 ", questRunning=" 
            callmethod IsRunning self ::temp1 ;0 variable args
            cast ::temp6 ::temp1 
            strcat ::temp6 ::temp4 ::temp6 
            strcat ::temp6 ::temp6 ", questActive=" 
            callmethod IsActive self ::temp1 ;0 variable args
            cast ::temp4 ::temp1 
            strcat ::temp4 ::temp6 ::temp4 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            ; line 4833
            propget QUEST_OBJECTIVE_ID self ::temp2 
            callmethod SetObjectiveCompleted self ::nonevar ::temp2 False ;2 variable args
            ; line 4834
            propget QUEST_OBJECTIVE_ID self ::temp2 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp2 False False ;3 variable args
            ; line 4837
            assign ::temp1 ::QuestPrePlaced_var 
            jmpf ::temp1 _label17
            cmp_eq ::temp1 ::QuestSubType_var "rescue" 
            assign ::temp1 ::temp1 
          _label17:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label18
            cast ::temp7 None 
            cmp_eq ::temp1 ::QuestVictimNPC_var ::temp7 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label18:
            jmpf ::temp1 _label19
            ; line 4838
            cast ::temp5 ::QuestVictimNPC_var 
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::temp5 ;1 variable args
            ; line 4839
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: marker on victim (pre-placed deep inside)" ;1 variable args
            jmp _label20
            ; line 4840
          _label19:
            assign ::temp1 ::QuestPrePlaced_var 
            jmpf ::temp1 _label21
            cmp_eq ::temp1 ::QuestSubType_var "find_item" 
            assign ::temp1 ::temp1 
          _label21:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label22
            cast ::temp5 None 
            cmp_eq ::temp1 ::QuestItemChest_var ::temp5 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label22:
            jmpf ::temp1 _label23
            ; line 4841
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::QuestItemChest_var ;1 variable args
            ; line 4842
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: marker on chest (pre-placed deep inside)" ;1 variable args
            jmp _label20
            ; line 4843
          _label23:
            assign ::temp1 ::QuestPrePlaced_var 
            jmpf ::temp1 _label24
            cmp_eq ::temp1 ::QuestSubType_var "combat" 
            assign ::temp1 ::temp1 
          _label24:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label25
            cast ::temp7 None 
            cmp_eq ::temp1 ::QuestBossNPC_var ::temp7 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label25:
            jmpf ::temp1 _label26
            ; line 4844
            cast ::temp5 ::QuestBossNPC_var 
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::temp5 ;1 variable args
            ; line 4845
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: marker on boss (pre-placed deep inside)" ;1 variable args
            jmp _label20
            ; line 4846
          _label26:
            cmp_eq ::temp1 ::QuestSubType_var "faction_battle" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label27
            cast ::temp5 None 
            cmp_eq ::temp1 ::QuestLocation_var ::temp5 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label27:
            jmpf ::temp1 _label28
            ; line 4849
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::QuestLocation_var ;1 variable args
            ; line 4850
            strcat ::temp4 "Story [quest]: temporary marker at " ::QuestLocationName_var 
            strcat ::temp4 ::temp4 " (moves to leader on spawn)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            jmp _label20
            ; line 4852
          _label28:
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::QuestLocation_var ;1 variable args
            ; line 4855
          _label20:
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 4856
            callmethod GetReference ::QuestTargetAlias_var ::temp5 ;0 variable args
            assign aliasRef ::temp5 
            ; line 4857
            cast ::temp4 aliasRef 
            strcat ::temp4 "Story [quest]: After ForceRefTo - aliasRef=" ::temp4 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            ; line 4859
            callmethod SetActive self ::nonevar True ;1 variable args
            ; line 4861
            propget QUEST_OBJECTIVE_ID self ::temp2 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp2 True False ;3 variable args
            ; line 4863
            callmethod SetStage self ::temp1 100 ;1 variable args
            ; line 4864
            strcat ::temp4 "Story [quest]: Marker placed for " ::QuestLocationName_var 
            strcat ::temp4 ::temp4 ", questActive=" 
            callmethod IsActive self ::temp1 ;0 variable args
            cast ::temp6 ::temp1 
            strcat ::temp6 ::temp4 ::temp6 
            strcat ::temp6 ::temp6 ", objDisplayed=" 
            propget QUEST_OBJECTIVE_ID self ::temp2 
            callmethod IsObjectiveDisplayed self ::temp1 ::temp2 ;1 variable args
            cast ::temp4 ::temp1 
            strcat ::temp4 ::temp6 ::temp4 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
          .endCode
        .endFunction ;PlaceQuestMarker
        .function RemoveQuestMarker
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param completed Bool
          .endParamTable
          .localTable
            .local ::temp0 referenceAlias
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 Int
          .endLocalTable
          .code
            ; line 4868
            cast ::temp0 None 
            cmp_eq ::temp1 ::QuestTargetAlias_var ::temp0 
            jmpf ::temp1 _label0
            ; line 4869
            return None 
            jmp _label0
            ; line 4871
          _label0:
            jmpf completed _label1
            ; line 4872
            propget QUEST_OBJECTIVE_ID self ::temp2 
            callmethod SetObjectiveCompleted self ::nonevar ::temp2 True ;2 variable args
            ; line 4873
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: Objective completed, quest deactivated" ;1 variable args
            jmp _label2
            ; line 4875
          _label1:
            propget QUEST_OBJECTIVE_ID self ::temp2 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp2 False False ;3 variable args
            ; line 4876
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: Objective hidden, quest deactivated" ;1 variable args
            ; line 4878
          _label2:
            callmethod SetActive self ::nonevar False ;1 variable args
            ; line 4879
            callmethod Clear ::QuestTargetAlias_var ::nonevar ;0 variable args
          .endCode
        .endFunction ;RemoveQuestMarker
        .function ShouldAbortForDangerZone
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
            .param npc actor
            .param player actor
            .param storyType String
            .param logSuffix String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 String
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 4887
            callstatic intelEngine IsPlayerInDangerousLocation ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 4888
            return False 
            jmp _label0
            ; line 4890
          _label0:
            cmp_eq ::temp0 storyType "informant" 
            jmpf ::temp0 _label1
            ; line 4891
            callmethod GetDisplayName npc ::temp1 ;0 variable args
            strcat ::temp1 "Story: aborting informant for " ::temp1 
            strcat ::temp1 ::temp1 " -- danger zone" 
            strcat ::temp1 ::temp1 logSuffix 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 4892
            callmethod GetDisplayName player ::temp1 ;0 variable args
            strcat ::temp1 "thought better of chasing " ::temp1 
            strcat ::temp1 ::temp1 " into danger just for gossip and turned back" 
            callmethod SendTaskNarration ::Core_var ::nonevar npc ::temp1 player ;3 variable args
            ; line 4893
            strcat ::temp1 "informant in danger zone" logSuffix 
            callmethod AbortStoryTravel self ::nonevar ::temp1 ;1 variable args
            ; line 4894
            return True 
            jmp _label1
            ; line 4896
          _label1:
            cmp_eq ::temp0 ::DangerZonePolicy_var 3 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label2
            ; line 4897
            cmp_eq ::temp0 ::DangerZonePolicy_var 2 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            callstatic intelEngine IsPotentialFollower ::temp0 npc ;1 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label3:
            assign ::temp0 ::temp0 
          _label2:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label4
            ; line 4898
            cmp_eq ::temp0 ::DangerZonePolicy_var 1 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label5
            callstatic intelEngine IsCivilianClass ::temp0 npc ;1 variable args
            assign ::temp0 ::temp0 
          _label5:
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label6
            ; line 4899
            strcat ::temp1 "Story: aborting " storyType 
            strcat ::temp1 ::temp1 " for " 
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 ::temp1 ::temp2 
            strcat ::temp2 ::temp2 " -- danger zone policy" 
            strcat ::temp2 ::temp2 logSuffix 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 4900
            callmethod GetDisplayName player ::temp2 ;0 variable args
            strcat ::temp2 "turned back after learning that " ::temp2 
            strcat ::temp2 ::temp2 " had ventured into a dangerous place" 
            callmethod SendTaskNarration ::Core_var ::nonevar npc ::temp2 player ;3 variable args
            ; line 4901
            strcat ::temp2 "danger zone policy" logSuffix 
            callmethod AbortStoryTravel self ::nonevar ::temp2 ;1 variable args
            ; line 4902
            return True 
            jmp _label6
            ; line 4904
          _label6:
            return False 
          .endCode
        .endFunction ;ShouldAbortForDangerZone
        .function ShouldAbortForPlayerHome
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
            .param npc actor
            .param player actor
            .param storyType String
            .param logSuffix String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 String
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 4908
            callstatic intelEngine IsPlayerInOwnHome ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 4909
            return False 
            jmp _label0
            ; line 4911
          _label0:
            cmp_eq ::temp0 ::PlayerHomePolicy_var 3 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label1
            ; line 4912
            cmp_eq ::temp0 ::PlayerHomePolicy_var 2 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label2
            callstatic intelEngine IsPotentialFollower ::temp0 npc ;1 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label2:
            assign ::temp0 ::temp0 
          _label1:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label3
            ; line 4913
            cmp_eq ::temp0 ::PlayerHomePolicy_var 1 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label4
            callstatic intelEngine IsCivilianClass ::temp0 npc ;1 variable args
            assign ::temp0 ::temp0 
          _label4:
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label5
            ; line 4914
            strcat ::temp1 "Story: aborting " storyType 
            strcat ::temp1 ::temp1 " for " 
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 ::temp1 ::temp2 
            strcat ::temp2 ::temp2 " -- player home policy" 
            strcat ::temp2 ::temp2 logSuffix 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 4915
            callmethod GetDisplayName player ::temp2 ;0 variable args
            strcat ::temp2 "decided not to bother " ::temp2 
            strcat ::temp2 ::temp2 " at home and turned back" 
            callmethod SendTaskNarration ::Core_var ::nonevar npc ::temp2 player ;3 variable args
            ; line 4916
            strcat ::temp2 "player home policy" logSuffix 
            callmethod AbortStoryTravel self ::nonevar ::temp2 ;1 variable args
            ; line 4917
            return True 
            jmp _label5
            ; line 4919
          _label5:
            return False 
          .endCode
        .endFunction ;ShouldAbortForPlayerHome
        .function ShouldAbortForHoldRestriction
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
            .param npc actor
            .param player actor
            .param storyType String
            .param logSuffix String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 String
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 4923
            callstatic intelEngine CheckHoldRestriction ::temp0 npc storyType ;2 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 4924
            strcat ::temp1 "Story: aborting " storyType 
            strcat ::temp1 ::temp1 " for " 
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 ::temp1 ::temp2 
            strcat ::temp2 ::temp2 " -- hold restriction" 
            strcat ::temp2 ::temp2 logSuffix 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 4925
            callmethod GetDisplayName player ::temp2 ;0 variable args
            strcat ::temp2 "decided the journey to find " ::temp2 
            strcat ::temp2 ::temp2 " was too far and turned back" 
            callmethod SendTaskNarration ::Core_var ::nonevar npc ::temp2 player ;3 variable args
            ; line 4926
            strcat ::temp2 "hold restriction" logSuffix 
            callmethod AbortStoryTravel self ::nonevar ::temp2 ;1 variable args
            ; line 4927
            return True 
            jmp _label0
            ; line 4929
          _label0:
            return False 
          .endCode
        .endFunction ;ShouldAbortForHoldRestriction
        .function AbortStoryTravel
           ; function type 0
          .userFlags 0 ;none
          .docString "Abort active story travel: clear slot, remove packages, full cleanup."
          .return None
          .paramTable
            .param reason String
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local abortSlot Int
            .local ::temp1 Int
            .local ::temp2 Bool
          .endLocalTable
          .code
            ; line 4934
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp0 ;0 variable args
            strcat ::temp0 "Story: " ::temp0 
            strcat ::temp0 ::temp0 " " 
            strcat ::temp0 ::temp0 reason 
            strcat ::temp0 ::temp0 " — aborting" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 4935
            callmethod FindSlotByAgent ::Core_var ::temp1 ::ActiveStoryNPC_var ;1 variable args
            assign abortSlot ::temp1 
            ; line 4936
            comp_gte ::temp2 abortSlot 0 
            jmpf ::temp2 _label0
            ; line 4937
            callmethod ClearSlot ::Core_var ::nonevar abortSlot True False ;3 variable args
            jmp _label0
            ; line 4939
          _label0:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 4940
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
          .endCode
        .endFunction ;AbortStoryTravel
        .function CleanupStoryDispatch
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 actor
            .local ::nonevar None
            .local ::temp2 String
            .local origAggr Float
            .local ::temp3 form
            .local ::temp4 Float
          .endLocalTable
          .code
            ; line 4945
            cmp_eq ::temp0 ::ActiveStoryType_var "quest" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cmp_eq ::temp0 ::ActiveStoryType_var "quest_guide" 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 4946
            jmpf ::QuestActive_var _label2
            ; line 4948
            cast ::temp1 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            cmp_eq ::temp0 ::QuestEnemyType_var "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label3:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label4
            cmp_eq ::temp0 ::QuestLocationName_var "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label5
            ; line 4949
            strcat ::temp2 "never heard back about the " ::QuestEnemyType_var 
            strcat ::temp2 ::temp2 " threat at " 
            strcat ::temp2 ::temp2 ::QuestLocationName_var 
            strcat ::temp2 ::temp2 " — the request seems to have fallen through" 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp2 ;2 variable args
            jmp _label5
            ; line 4951
          _label5:
            callmethod CleanupQuest self ::nonevar ;0 variable args
            jmp _label2
          _label2:
            jmp _label1
            ; line 4955
          _label1:
            cast ::temp1 None 
            cmp_eq ::temp0 ::ActiveStoryNPC_var ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label6
            ; line 4957
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp4 ::temp3 "Intel_OrigAggression" -1.0 ;3 variable args
            assign origAggr ::temp4 
            ; line 4958
            comp_gte ::temp0 origAggr 0.0 
            jmpf ::temp0 _label7
            ; line 4959
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Aggression" origAggr ;2 variable args
            ; line 4960
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp3 "Intel_OrigAggression" ;2 variable args
            jmp _label7
            ; line 4962
          _label7:
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp3 "Intel_IsStoryDispatch" ;2 variable args
            ; line 4963
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp3 "Intel_StoryNarration" ;2 variable args
            ; line 4964
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp3 "Intel_SneakPhase" ;2 variable args
            ; line 4965
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp3 "Intel_SneakStartTime" ;2 variable args
            ; line 4966
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp3 "Intel_CombatStartTime" ;2 variable args
            ; line 4967
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp3 "Intel_OffscreenArrival" ;2 variable args
            ; line 4969
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp3 "Intel_MessageSender" ;2 variable args
            ; line 4970
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp3 "Intel_MessageContent" ;2 variable args
            ; line 4971
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp3 "Intel_MessageDest" ;2 variable args
            ; line 4972
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp3 "Intel_MessageTime" ;2 variable args
            ; line 4973
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp3 "Intel_QuestLocation" ;2 variable args
            jmp _label6
            ; line 4975
          _label6:
            cast ::temp1 None 
            assign ::ActiveStoryNPC_var ::temp1 
            ; line 4976
            cast ::temp1 None 
            assign ::ActiveSecondNPC_var ::temp1 
            ; line 4977
            assign ::ActiveNarration_var "" 
            ; line 4978
            assign ::ActiveStoryType_var "" 
            ; line 4979
            assign ::IsActive_var False 
            ; line 4980
            callstatic intelEngine ClearSystemPending ::nonevar "storyDM" ;1 variable args
            ; line 4981
            callmethod ClearPending self ::nonevar ;0 variable args
            ; line 4990
            callmethod StartScheduler self ::nonevar ;0 variable args
          .endCode
        .endFunction ;CleanupStoryDispatch
        .function ClearPending
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 4994
            assign ::PendingStoryType_var "" 
          .endCode
        .endFunction ;ClearPending
        .function ReapplyTravelPackage
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param npc actor
          .endParamTable
          .localTable
            .local target actor
            .local ::temp0 actor
            .local ::temp1 Bool
            .local travelPkg package
            .local ::temp2 package
            .local ::nonevar None
            .local ::temp3 String
            .local ::temp4 objectReference
            .local ::temp5 objectReference
            .local ::temp6 keyword
            .local ::temp7 Int
          .endLocalTable
          .code
            ; line 5003
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign target ::temp0 
            ; line 5004
            callmethod IsNPCToNPCType self ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            cast ::temp0 None 
            cmp_eq ::temp1 ::ActiveSecondNPC_var ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 5005
            assign target ::ActiveSecondNPC_var 
            jmp _label1
            ; line 5009
          _label1:
            propget TravelPackage_Jog ::Core_var ::temp2 
            assign travelPkg ::temp2 
            ; line 5010
            cmp_eq ::temp1 ::ActiveStoryType_var "stalker" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label2
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush" 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 5011
            propget TravelPackage_Stalk ::Core_var ::temp2 
            cast ::temp1 ::temp2 
            jmpf ::temp1 _label4
            ; line 5012
            propget TravelPackage_Stalk ::Core_var ::temp2 
            assign travelPkg ::temp2 
            ; line 5013
            strcat ::temp3 "Story [" ::ActiveStoryType_var 
            strcat ::temp3 ::temp3 "]: using TravelPackage_Stalk" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label5
            ; line 5015
          _label4:
            strcat ::temp3 "Story [" ::ActiveStoryType_var 
            strcat ::temp3 ::temp3 "]: WARNING - TravelPackage_Stalk is None! Fill property on IntelEngine quest in CK" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
          _label5:
            jmp _label3
            ; line 5019
          _label3:
            callmethod RemoveAllPackages ::Core_var ::nonevar npc False ;2 variable args
            ; line 5020
            cast ::temp4 npc 
            cast ::temp5 target 
            propget IntelEngine_TravelTarget ::Core_var ::temp6 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp4 ::temp5 ::temp6 ;3 variable args
            ; line 5021
            propget PRIORITY_TRAVEL ::Core_var ::temp7 
            callstatic actorUtil AddPackageOverride ::nonevar npc travelPkg ::temp7 1 ;4 variable args
            ; line 5022
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 5023
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
          .endCode
        .endFunction ;ReapplyTravelPackage
        .function AddRecentStoryEvent
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param summary String
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local ::temp1 form
            .local ::temp2 Int
            .local ::temp3 Bool
          .endLocalTable
          .code
            ; line 5031
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 5032
            cast ::temp1 player 
            callstatic storageUtil StringListAdd ::temp2 ::temp1 "Intel_RecentStoryEvents" summary True ;4 variable args
            ; line 5033
          _label1:
            cast ::temp1 player 
            callstatic storageUtil StringListCount ::temp2 ::temp1 "Intel_RecentStoryEvents" ;2 variable args
            cmp_gt ::temp3 ::temp2 8 
            jmpf ::temp3 _label0
            ; line 5034
            cast ::temp1 player 
            callstatic storageUtil StringListRemoveAt ::temp3 ::temp1 "Intel_RecentStoryEvents" 0 ;3 variable args
            jmp _label1
          _label0
          .endCode
        .endFunction ;AddRecentStoryEvent
        .function AddNPCSocialLog
           ; function type 0
          .userFlags 0 ;none
          .docString "Store structured NPC social interaction for dashboard display. Parallel StringLists, last 5."
          .return None
          .paramTable
            .param eventType String
            .param npc1Name String
            .param npc2Name String
            .param narration String
            .param sourceNPC actor
            .param detail String
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local locName String
            .local ::temp1 Bool
            .local ::temp2 String
            .local typeCount Int
            .local ::temp3 form
            .local ::temp4 Int
            .local detailCount Int
          .endLocalTable
          .code
            ; line 5040
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 5042
            assign locName "" 
            ; line 5043
            cast ::temp0 None 
            cmp_eq ::temp1 sourceNPC ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label0
            ; line 5044
            callstatic intelEngine GetActorHoldName ::temp2 sourceNPC ;1 variable args
            assign locName ::temp2 
            jmp _label0
            ; line 5046
          _label0:
            cmp_eq ::temp1 locName "" 
            jmpf ::temp1 _label1
            ; line 5047
            callstatic intelEngine GetActorHoldName ::temp2 player ;1 variable args
            assign locName ::temp2 
            jmp _label1
            ; line 5051
          _label1:
            cast ::temp3 player 
            callstatic storageUtil StringListCount ::temp4 ::temp3 "Intel_SocialLog_Type" ;2 variable args
            assign typeCount ::temp4 
            ; line 5052
            cast ::temp3 player 
            callstatic storageUtil StringListCount ::temp4 ::temp3 "Intel_SocialLog_Detail" ;2 variable args
            assign detailCount ::temp4 
            ; line 5053
          _label3:
            cmp_lt ::temp1 detailCount typeCount 
            jmpf ::temp1 _label2
            ; line 5054
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_Detail" "" True ;4 variable args
            ; line 5055
            iadd ::temp4 detailCount 1 
            assign detailCount ::temp4 
            jmp _label3
            ; line 5057
          _label2:
            cmp_gt ::temp1 detailCount typeCount 
            jmpf ::temp1 _label4
            ; line 5058
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_Detail" 0 ;3 variable args
            ; line 5059
            isub ::temp4 detailCount 1 
            assign detailCount ::temp4 
            jmp _label2
            ; line 5061
          _label4:
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_Type" eventType True ;4 variable args
            ; line 5062
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_NPC1" npc1Name True ;4 variable args
            ; line 5063
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_NPC2" npc2Name True ;4 variable args
            ; line 5064
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_Text" narration True ;4 variable args
            ; line 5065
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_Location" locName True ;4 variable args
            ; line 5066
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_Detail" detail True ;4 variable args
            ; line 5067
          _label6:
            cast ::temp3 player 
            callstatic storageUtil StringListCount ::temp4 ::temp3 "Intel_SocialLog_Type" ;2 variable args
            cmp_gt ::temp1 ::temp4 5 
            jmpf ::temp1 _label5
            ; line 5068
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_Type" 0 ;3 variable args
            ; line 5069
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_NPC1" 0 ;3 variable args
            ; line 5070
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_NPC2" 0 ;3 variable args
            ; line 5071
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_Text" 0 ;3 variable args
            ; line 5072
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_Location" 0 ;3 variable args
            ; line 5073
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_Detail" 0 ;3 variable args
            jmp _label6
          _label5
          .endCode
        .endFunction ;AddNPCSocialLog
        .function BuildInteractionSummary
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
            .param npc1 actor
            .param eventText String
            .param npc2 actor
          .endParamTable
          .localTable
            .local ::temp0 String
            .local ::temp1 String
          .endLocalTable
          .code
            ; line 5083
            callmethod GetDisplayName npc1 ::temp0 ;0 variable args
            strcat ::temp0 ::temp0 " " 
            strcat ::temp0 ::temp0 eventText 
            strcat ::temp0 ::temp0 " with " 
            callmethod GetDisplayName npc2 ::temp1 ;0 variable args
            strcat ::temp1 ::temp0 ::temp1 
            return ::temp1 
          .endCode
        .endFunction ;BuildInteractionSummary
        .function ParseShouldAct
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
            .param response String
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 5091
            callstatic intelEngine StoryResponseShouldAct ::temp0 response ;1 variable args
            return ::temp0 
          .endCode
        .endFunction ;ParseShouldAct
        .function BuildFactionQuestNarration
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
            .param factionName String
            .param questLocation String
          .endParamTable
          .localTable
            .local variant Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local ::temp2 String
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 5095
            callstatic utility RandomInt ::temp0 0 3 ;2 variable args
            assign variant ::temp0 
            ; line 5096
            cmp_eq ::temp1 variant 0 
            jmpf ::temp1 _label0
            ; line 5097
            strcat ::temp2 "brought urgent word from the " factionName 
            strcat ::temp2 ::temp2 " about trouble near " 
            cast ::temp3 ::QuestLocation_var 
            strcat ::temp3 ::temp2 ::temp3 
            return ::temp3 
            jmp _label1
            ; line 5098
          _label0:
            cmp_eq ::temp1 variant 1 
            jmpf ::temp1 _label2
            ; line 5099
            strcat ::temp3 "arrived bearing a warning from the " factionName 
            strcat ::temp3 ::temp3 " concerning " 
            cast ::temp2 ::QuestLocation_var 
            strcat ::temp2 ::temp3 ::temp2 
            return ::temp2 
            jmp _label1
            ; line 5100
          _label2:
            cmp_eq ::temp1 variant 2 
            jmpf ::temp1 _label3
            ; line 5101
            cast ::temp2 ::QuestLocation_var 
            strcat ::temp2 "brought word of trouble brewing at " ::temp2 
            strcat ::temp2 ::temp2 " — the " 
            strcat ::temp2 ::temp2 factionName 
            strcat ::temp2 ::temp2 " need help" 
            return ::temp2 
            jmp _label1
            ; line 5103
          _label3:
            strcat ::temp2 "rushed over with grim news from the " factionName 
            strcat ::temp2 ::temp2 " about " 
            cast ::temp3 ::QuestLocation_var 
            strcat ::temp3 ::temp2 ::temp3 
            return ::temp3 
          _label1
          .endCode
        .endFunction ;BuildFactionQuestNarration
        .function PackToggleBitmask
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
            .local t Int
            .local ::temp0 Int
          .endLocalTable
          .code
            ; line 5110
            assign t 0 
            ; line 5111
            jmpf ::TypeSeekPlayerEnabled_var _label0
            ; line 5112
            iadd ::temp0 t 1 
            assign t ::temp0 
            jmp _label0
            ; line 5114
          _label0:
            jmpf ::TypeInformantEnabled_var _label1
            ; line 5115
            iadd ::temp0 t 2 
            assign t ::temp0 
            jmp _label1
            ; line 5117
          _label1:
            jmpf ::TypeRoadEncounterEnabled_var _label2
            ; line 5118
            iadd ::temp0 t 4 
            assign t ::temp0 
            jmp _label2
            ; line 5120
          _label2:
            jmpf ::TypeAmbushEnabled_var _label3
            ; line 5121
            iadd ::temp0 t 8 
            assign t ::temp0 
            jmp _label3
            ; line 5123
          _label3:
            jmpf ::TypeStalkerEnabled_var _label4
            ; line 5124
            iadd ::temp0 t 16 
            assign t ::temp0 
            jmp _label4
            ; line 5126
          _label4:
            jmpf ::TypeMessageEnabled_var _label5
            ; line 5127
            iadd ::temp0 t 32 
            assign t ::temp0 
            jmp _label5
            ; line 5129
          _label5:
            jmpf ::TypeQuestEnabled_var _label6
            ; line 5130
            iadd ::temp0 t 64 
            assign t ::temp0 
            jmp _label6
            ; line 5132
          _label6:
            jmpf ::TypeFactionAmbushEnabled_var _label7
            ; line 5133
            iadd ::temp0 t 128 
            assign t ::temp0 
            jmp _label7
            ; line 5135
          _label7:
            jmpf ::QuestSubTypeCombatEnabled_var _label8
            ; line 5136
            iadd ::temp0 t 256 
            assign t ::temp0 
            jmp _label8
            ; line 5138
          _label8:
            jmpf ::QuestSubTypeRescueEnabled_var _label9
            ; line 5139
            iadd ::temp0 t 512 
            assign t ::temp0 
            jmp _label9
            ; line 5141
          _label9:
            jmpf ::QuestSubTypeFindItemEnabled_var _label10
            ; line 5142
            iadd ::temp0 t 1024 
            assign t ::temp0 
            jmp _label10
            ; line 5144
          _label10:
            jmpf ::QuestSubTypeFactionCombatEnabled_var _label11
            ; line 5145
            iadd ::temp0 t 2048 
            assign t ::temp0 
            jmp _label11
            ; line 5147
          _label11:
            jmpf ::QuestSubTypeFactionRescueEnabled_var _label12
            ; line 5148
            iadd ::temp0 t 4096 
            assign t ::temp0 
            jmp _label12
            ; line 5150
          _label12:
            jmpf ::QuestSubTypeFactionBattleEnabled_var _label13
            ; line 5151
            iadd ::temp0 t 8192 
            assign t ::temp0 
            jmp _label13
            ; line 5153
          _label13:
            return t 
          .endCode
        .endFunction ;PackToggleBitmask
        .function PackEnvFlags
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
            .param player actor
          .endParamTable
          .localTable
            .local f Int
            .local pCell cell
            .local ::temp0 cell
            .local ::temp1 Bool
            .local ::temp2 Int
          .endLocalTable
          .code
            ; line 5157
            assign f 0 
            ; line 5158
            callmethod GetParentCell player ::temp0 ;0 variable args
            assign pCell ::temp0 
            ; line 5159
            cast ::temp0 None 
            cmp_eq ::temp1 pCell ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            callmethod IsInterior pCell ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 5160
            iadd ::temp2 f 1 
            assign f ::temp2 
            jmp _label1
            ; line 5162
          _label1:
            callstatic intelEngine IsPlayerInDangerousLocation ::temp1 ;0 variable args
            jmpf ::temp1 _label2
            ; line 5163
            iadd ::temp2 f 2 
            assign f ::temp2 
            jmp _label2
            ; line 5165
          _label2:
            return f 
          .endCode
        .endFunction ;PackEnvFlags
        .function ExtractJsonField
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
            .param json String
            .param fieldName String
          .endParamTable
          .localTable
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 5169
            callstatic intelEngine StoryResponseGetField ::temp0 json fieldName ;2 variable args
            return ::temp0 
          .endCode
        .endFunction ;ExtractJsonField
        .function IEB_DispatchBlocked
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch: refuse dispatch of an NPC that already holds a task slot, travels with the player,
     or is held or lent by the Errand Bridge."
          .return Bool
          .paramTable
            .param a actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 Int
            .local ::temp3 form
            .local cff faction
            .local ::temp4 faction
          .endLocalTable
          .code
            ; line 5175
            cast ::temp0 None 
            cmp_eq ::temp1 a ::temp0 
            jmpf ::temp1 _label0
            ; line 5176
            return False 
            jmp _label0
            ; line 5178
          _label0:
            callmethod FindSlotByAgent ::Core_var ::temp2 a ;1 variable args
            comp_gte ::temp1 ::temp2 0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            callmethod IsPlayerTeammate a ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 5179
            return True 
            jmp _label2
            ; line 5181
          _label2:
            cast ::temp3 a 
            callstatic storageUtil GetIntValue ::temp2 ::temp3 "IEB_Gate" 0 ;3 variable args
            cmp_gt ::temp1 ::temp2 0 
            jmpf ::temp1 _label3
            ; line 5182
            return True 
            jmp _label3
            ; line 5184
          _label3:
            callstatic game GetFormFromFile ::temp3 378958 "Skyrim.esm" ;2 variable args
            cast ::temp4 ::temp3 
            assign cff ::temp4 
            ; line 5185
            cast ::temp4 None 
            cmp_eq ::temp1 cff ::temp4 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label4
            callmethod GetFactionRank a ::temp2 cff ;1 variable args
            comp_gte ::temp1 ::temp2 0 
            assign ::temp1 ::temp1 
          _label4:
            return ::temp1 
          .endCode
        .endFunction ;IEB_DispatchBlocked
        .function IEB_StoryBlocked
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
            .param a actor
            .param tier Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 5189
            callmethod IEB_DispatchBlocked self ::temp0 a ;1 variable args
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            callmethod IEB_QuestReserved self ::temp0 a tier ;2 variable args
            assign ::temp0 ::temp0 
          _label0:
            return ::temp0 
          .endCode
        .endFunction ;IEB_StoryBlocked
        .function IEB_QuestReserved
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch: true if a story beat of this tier must not use this actor (quest integrity)."
          .return Bool
          .paramTable
            .param a actor
            .param tier Int
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 scene
            .local ::temp3 scene
            .local qiFile String
            .local ::temp4 String
            .local n Int
            .local ::temp5 Int
            .local i Int
            .local ra referenceAlias
            .local ::temp6 referenceAlias
            .local q quest
            .local ::temp7 quest
            .local ::temp8 form
            .local b actorBase
            .local ::temp9 actorBase
          .endLocalTable
          .code
            ; line 5194
            cast ::temp0 None 
            cmp_eq ::temp1 a ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_lt ::temp1 tier 1 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 5195
            return False 
            jmp _label1
            ; line 5197
          _label1:
            callmethod GetCurrentScene a ::temp2 ;0 variable args
            cast ::temp3 None 
            cmp_eq ::temp1 ::temp2 ::temp3 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 5198
            return True 
            jmp _label2
            ; line 5200
          _label2:
            callmethod IEB_QIFile self ::temp4 ;0 variable args
            assign qiFile ::temp4 
            ; line 5201
            callmethod GetNumReferenceAliases a ::temp5 ;0 variable args
            assign n ::temp5 
            ; line 5202
            assign i 0 
            ; line 5203
          _label11:
            cmp_lt ::temp1 i n 
            jmpf ::temp1 _label3
            ; line 5204
            callmethod GetNthReferenceAlias a ::temp6 i ;1 variable args
            assign ra ::temp6 
            ; line 5205
            cast ::temp7 None 
            assign q ::temp7 
            ; line 5206
            cast ::temp1 ra 
            jmpf ::temp1 _label4
            ; line 5207
            callmethod GetOwningQuest ra ::temp7 ;0 variable args
            assign q ::temp7 
            jmp _label4
            ; line 5209
          _label4:
            cast ::temp1 q 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label5
            callmethod IsRunning q ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label6
            callmethod IsStarting q ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label6:
            assign ::temp1 ::temp1 
          _label5:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label7
            callmethod IEB_ExemptQuest self ::temp1 q ;1 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label7:
            jmpf ::temp1 _label8
            ; line 5210
            cast ::temp8 q 
            callstatic jsonUtil FormListHas ::temp1 qiFile "story_quests" ::temp8 ;3 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label9
            callmethod IEB_HasOpenObjective self ::temp1 q ;1 variable args
            assign ::temp1 ::temp1 
          _label9:
            jmpf ::temp1 _label10
            ; line 5211
            return True 
            jmp _label10
          _label10:
            jmp _label8
            ; line 5214
          _label8:
            iadd ::temp5 i 1 
            assign i ::temp5 
            jmp _label11
            ; line 5216
          _label3:
            comp_gte ::temp1 tier 2 
            jmpf ::temp1 _label12
            ; line 5217
            callmethod GetActorBase a ::temp9 ;0 variable args
            assign b ::temp9 
            ; line 5218
            callmethod IsEssential a ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label13
            callmethod IsEssential b ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label13:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label14
            callmethod IsProtected b ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label14:
            jmpf ::temp1 _label15
            ; line 5219
            return True 
            jmp _label15
            ; line 5221
          _label15:
            cast ::temp8 b 
            callstatic jsonUtil FormListHas ::temp1 qiFile "reserved_npcs" ::temp8 ;3 variable args
            return ::temp1 
            jmp _label12
            ; line 5223
          _label12:
            return False 
          .endCode
        .endFunction ;IEB_QuestReserved
        .function IEB_QIFile
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch: Data/SKSE/Plugins/ErrandBridge/quest_integrity.json (JsonUtil paths are relative to StorageUtilData)."
          .return String
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 5228
            return "../ErrandBridge/quest_integrity" 
          .endCode
        .endFunction ;IEB_QIFile
        .function IEB_ExemptQuest
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch: the quest's original plugin is in the JSON string list "exempt_plugins" (Papyrus == ignores case)."
          .return Bool
          .paramTable
            .param q quest
          .endParamTable
          .localTable
            .local modName String
            .local ::temp0 form
            .local ::temp1 String
            .local qiFile String
            .local n Int
            .local ::temp2 Int
            .local i Int
            .local ::temp3 Bool
          .endLocalTable
          .code
            ; line 5233
            cast ::temp0 q 
            callstatic pO3_SKSEFunctions GetFormModName ::temp1 ::temp0 False ;2 variable args
            assign modName ::temp1 
            ; line 5234
            callmethod IEB_QIFile self ::temp1 ;0 variable args
            assign qiFile ::temp1 
            ; line 5235
            callstatic jsonUtil StringListCount ::temp2 qiFile "exempt_plugins" ;2 variable args
            assign n ::temp2 
            ; line 5236
            assign i 0 
            ; line 5237
          _label2:
            cmp_lt ::temp3 i n 
            jmpf ::temp3 _label0
            ; line 5238
            callstatic jsonUtil StringListGet ::temp1 qiFile "exempt_plugins" i ;3 variable args
            cmp_eq ::temp3 ::temp1 modName 
            jmpf ::temp3 _label1
            ; line 5239
            return True 
            jmp _label1
            ; line 5241
          _label1:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label2
            ; line 5243
          _label0:
            return False 
          .endCode
        .endFunction ;IEB_ExemptQuest
        .function IEB_HasOpenObjective
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch: any objective that is displayed and not completed."
          .return Bool
          .paramTable
            .param q quest
          .endParamTable
          .localTable
            .local objs Int[]
            .local ::temp0 Int[]
            .local i Int
            .local ::temp1 Int
            .local ::temp2 Bool
          .endLocalTable
          .code
            ; line 5248
            callstatic pO3_SKSEFunctions GetAllQuestObjectives ::temp0 q ;1 variable args
            assign objs ::temp0 
            ; line 5249
            assign i 0 
            ; line 5250
          _label3:
            array_length ::temp1 objs 
            cmp_lt ::temp2 i ::temp1 
            jmpf ::temp2 _label0
            ; line 5251
            array_getlement ::temp1 objs i 
            callmethod IsObjectiveDisplayed q ::temp2 ::temp1 ;1 variable args
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label1
            array_getlement ::temp1 objs i 
            callmethod IsObjectiveCompleted q ::temp2 ::temp1 ;1 variable args
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 5252
            return True 
            jmp _label2
            ; line 5254
          _label2:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label3
            ; line 5256
          _label0:
            return False 
          .endCode
        .endFunction ;IEB_HasOpenObjective
        .function IEB_StoryTier
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch: E1 tier by story type (§10.2.1). message is checked later on the messenger (E3)."
          .return Int
          .paramTable
            .param storyType String
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 5261
            cmp_eq ::temp0 storyType "ambush" 
            jmpf ::temp0 _label0
            ; line 5262
            return 2 
            jmp _label1
            ; line 5263
          _label0:
            cmp_eq ::temp0 storyType "seek_player" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label2
            cmp_eq ::temp0 storyType "informant" 
            assign ::temp0 ::temp0 
          _label2:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label3
            cmp_eq ::temp0 storyType "road_encounter" 
            assign ::temp0 ::temp0 
          _label3:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label4
            cmp_eq ::temp0 storyType "stalker" 
            assign ::temp0 ::temp0 
          _label4:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label5
            cmp_eq ::temp0 storyType "quest" 
            assign ::temp0 ::temp0 
          _label5:
            jmpf ::temp0 _label1
            ; line 5264
            return 1 
            jmp _label1
            ; line 5266
          _label1:
            return 0 
          .endCode
        .endFunction ;IEB_StoryTier
        .function IEB_QISelfCheck
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch (list A): the quest-integrity guard must never fail silently. On every load: the JSON exists
     and parses, and each form list resolves to at least 95% of the builder's recorded count."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local f String
            .local ::temp0 String
            .local problem String
            .local ::temp1 Bool
            .local ::temp2 String
            .local ex Int
            .local ::temp3 Int
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 5272
            callmethod IEB_QIFile self ::temp0 ;0 variable args
            assign f ::temp0 
            ; line 5273
            assign problem "" 
            ; line 5274
            callstatic jsonUtil JsonExists ::temp1 f ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label0
            ; line 5275
            assign problem "file missing" 
            jmp _label1
            ; line 5276
          _label0:
            callstatic jsonUtil IsGood ::temp1 f ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 5277
            callstatic jsonUtil GetErrors ::temp0 f ;1 variable args
            strcat ::temp0 "parse error " ::temp0 
            assign problem ::temp0 
            jmp _label1
            ; line 5279
          _label2:
            callmethod IEB_QICheckList self ::temp0 f "story_quests" ;2 variable args
            callmethod IEB_QICheckList self ::temp2 f "reserved_npcs" ;2 variable args
            strcat ::temp2 ::temp0 ::temp2 
            assign problem ::temp2 
            ; line 5280
            callstatic jsonUtil StringListCount ::temp3 f "exempt_plugins" ;2 variable args
            assign ex ::temp3 
            ; line 5281
            cmp_eq ::temp1 ex 0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label3
            callstatic jsonUtil GetIntValue ::temp3 f "exempt_plugins_count" 1 ;3 variable args
            cmp_lt ::temp1 ex ::temp3 
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label1
            ; line 5282
            cast ::temp2 ex 
            strcat ::temp2 "exempt_plugins " ::temp2 
            strcat ::temp2 ::temp2 " of " 
            callstatic jsonUtil GetIntValue ::temp3 f "exempt_plugins_count" 0 ;3 variable args
            cast ::temp0 ::temp3 
            strcat ::temp0 ::temp2 ::temp0 
            strcat ::temp0 ::temp0 "; " 
            strcat ::temp0 problem ::temp0 
            assign problem ::temp0 
            jmp _label1
            ; line 5285
          _label1:
            cmp_eq ::temp1 problem "" 
            jmpf ::temp1 _label4
            ; line 5286
            callstatic jsonUtil FormListCount ::temp3 f "story_quests" ;2 variable args
            cast ::temp0 ::temp3 
            strcat ::temp0 "[IEB] quest_integrity OK: story_quests " ::temp0 
            strcat ::temp0 ::temp0 ", reserved_npcs " 
            callstatic jsonUtil FormListCount ::temp3 f "reserved_npcs" ;2 variable args
            cast ::temp2 ::temp3 
            strcat ::temp2 ::temp0 ::temp2 
            callstatic debug Trace ::nonevar ::temp2 0 ;2 variable args
            jmp _label5
            ; line 5288
          _label4:
            strcat ::temp2 "[IEB] WARN quest_integrity: " problem 
            strcat ::temp2 ::temp2 "quest NPCs are NOT protected from story dispatch" 
            callstatic debug Trace ::nonevar ::temp2 2 ;2 variable args
            ; line 5289
            strcat ::temp2 "IEB WARNING: quest-integrity list failed (" problem 
            strcat ::temp2 ::temp2 ") Quest NPCs are unprotected." 
            callstatic debug Notification ::nonevar ::temp2 ;1 variable args
            ; line 5291
          _label5:
            callstatic jsonUtil GetIntValue ::temp3 f "write_probe" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            jmpf ::temp1 _label6
            ; line 5292
            callmethod IEB_QIWriteProbe self ::nonevar f ;1 variable args
            jmp _label6
          _label6
          .endCode
        .endFunction ;IEB_QISelfCheck
        .function IEB_QICheckList
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch: "" if the list resolves to >= 95% of its recorded count, else a short problem text."
          .return String
          .paramTable
            .param f String
            .param listKey String
          .endParamTable
          .localTable
            .local expected Int
            .local ::temp0 String
            .local ::temp1 Int
            .local arr form[]
            .local ::temp2 form[]
            .local resolved Int
            .local ::temp3 Int
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 Bool
          .endLocalTable
          .code
            ; line 5298
            strcat ::temp0 listKey "_count" 
            callstatic jsonUtil GetIntValue ::temp1 f ::temp0 0 ;3 variable args
            assign expected ::temp1 
            ; line 5299
            callstatic jsonUtil FormListToArray ::temp2 f listKey ;2 variable args
            assign arr ::temp2 
            ; line 5300
            array_length ::temp1 arr 
            callstatic papyrusUtil CountNone ::temp3 arr ;1 variable args
            isub ::temp3 ::temp1 ::temp3 
            assign resolved ::temp3 
            ; line 5301
            strcat ::temp0 "[IEB] quest_integrity " listKey 
            strcat ::temp0 ::temp0 ": resolved " 
            cast ::temp4 resolved 
            strcat ::temp4 ::temp0 ::temp4 
            strcat ::temp4 ::temp4 " of " 
            cast ::temp0 expected 
            strcat ::temp0 ::temp4 ::temp0 
            strcat ::temp0 ::temp0 " (entries " 
            array_length ::temp3 arr 
            cast ::temp4 ::temp3 
            strcat ::temp4 ::temp0 ::temp4 
            strcat ::temp4 ::temp4 ")" 
            callstatic debug Trace ::nonevar ::temp4 0 ;2 variable args
            ; line 5302
            cmp_lte ::temp5 expected 0 
            jmpf ::temp5 _label0
            ; line 5303
            strcat ::temp4 listKey " has no recorded count; " 
            return ::temp4 
            jmp _label1
            ; line 5304
          _label0:
            cmp_eq ::temp5 resolved 0 
            assign ::temp5 ::temp5 
            jmpt ::temp5 _label2
            imul ::temp3 resolved 100 
            imul ::temp1 expected 95 
            cmp_lt ::temp5 ::temp3 ::temp1 
            assign ::temp5 ::temp5 
          _label2:
            jmpf ::temp5 _label1
            ; line 5305
            strcat ::temp4 listKey " resolved " 
            cast ::temp0 resolved 
            strcat ::temp0 ::temp4 ::temp0 
            strcat ::temp0 ::temp0 " of " 
            cast ::temp4 expected 
            strcat ::temp4 ::temp0 ::temp4 
            strcat ::temp4 ::temp4 "; " 
            return ::temp4 
            jmp _label1
            ; line 5307
          _label1:
            return "" 
          .endCode
        .endFunction ;IEB_QICheckList
        .function IEB_QIWriteProbe
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch, test builds only (write_probe = 1): PapyrusUtil writes known forms itself (test Q-9), so its exact
     form-string spelling can be compared with the builder's; also logs whether each form matches the list."
          .return None
          .paramTable
            .param f String
          .endParamTable
          .localTable
            .local p String
            .local ::temp0 Int
            .local n Int
            .local i Int
            .local ::temp1 Bool
            .local fm form
            .local ::temp2 String
            .local ::temp3 form
            .local ::nonevar None
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 5313
            assign p "../ErrandBridge/qi_probe" 
            ; line 5314
            callstatic jsonUtil FormListClear ::temp0 p "probe" ;2 variable args
            ; line 5315
            callstatic jsonUtil StringListCount ::temp0 f "probe_plugins" ;2 variable args
            assign n ::temp0 
            ; line 5316
            assign i 0 
            ; line 5317
          _label1:
            cmp_lt ::temp1 i n 
            jmpf ::temp1 _label0
            ; line 5318
            callstatic jsonUtil IntListGet ::temp0 f "probe_ids" i ;3 variable args
            callstatic jsonUtil StringListGet ::temp2 f "probe_plugins" i ;3 variable args
            callstatic game GetFormFromFile ::temp3 ::temp0 ::temp2 ;2 variable args
            assign fm ::temp3 
            ; line 5319
            callstatic jsonUtil FormListAdd ::temp0 p "probe" fm True ;4 variable args
            ; line 5320
            cast ::temp2 i 
            strcat ::temp2 "[IEB] quest_integrity probe " ::temp2 
            strcat ::temp2 ::temp2 ": resolved " 
            cast ::temp3 None 
            cmp_eq ::temp1 fm ::temp3 
            not ::temp1 ::temp1 
            cast ::temp4 ::temp1 
            strcat ::temp4 ::temp2 ::temp4 
            strcat ::temp4 ::temp4 ", in " 
            callstatic jsonUtil StringListGet ::temp2 f "probe_lists" i ;3 variable args
            strcat ::temp2 ::temp4 ::temp2 
            strcat ::temp2 ::temp2 " " 
            callstatic jsonUtil StringListGet ::temp4 f "probe_lists" i ;3 variable args
            callstatic jsonUtil FormListHas ::temp1 f ::temp4 fm ;3 variable args
            cast ::temp4 ::temp1 
            strcat ::temp4 ::temp2 ::temp4 
            callstatic debug Trace ::nonevar ::temp4 0 ;2 variable args
            ; line 5321
            iadd ::temp0 i 1 
            assign i ::temp0 
            jmp _label1
            ; line 5323
          _label0:
            callstatic jsonUtil Save ::temp1 p False ;2 variable args
            ; line 5324
            cast ::temp4 n 
            strcat ::temp4 "[IEB] quest_integrity probe written: " ::temp4 
            strcat ::temp4 ::temp4 " forms" 
            callstatic debug Trace ::nonevar ::temp4 0 ;2 variable args
          .endCode
        .endFunction ;IEB_QIWriteProbe
        .function IEB_AssassinationBlocked
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch E7 (Shae 2026-10-09): IntelEngine's assassination is plain combat (StartCombat; no Kill or flag change),
     so essential and protected targets survive it. Cancel only for busy targets, targets a running questline is
     using now (tier 1), or targets that could die and are in reserved_npcs."
          .return Bool
          .paramTable
            .param a actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local b actorBase
            .local ::temp2 actorBase
            .local ::temp3 String
            .local ::temp4 form
          .endLocalTable
          .code
            ; line 5331
            cast ::temp0 None 
            cmp_eq ::temp1 a ::temp0 
            jmpf ::temp1 _label0
            ; line 5332
            return False 
            jmp _label0
            ; line 5334
          _label0:
            callmethod IEB_DispatchBlocked self ::temp1 a ;1 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            callmethod IEB_QuestReserved self ::temp1 a 1 ;2 variable args
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 5335
            return True 
            jmp _label2
            ; line 5337
          _label2:
            callmethod GetActorBase a ::temp2 ;0 variable args
            assign b ::temp2 
            ; line 5338
            callmethod IsEssential a ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label3
            callmethod IsEssential b ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label3:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label4
            callmethod IsProtected b ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label4:
            jmpf ::temp1 _label5
            ; line 5339
            return False 
            jmp _label5
            ; line 5341
          _label5:
            callmethod IEB_QIFile self ::temp3 ;0 variable args
            cast ::temp4 b 
            callstatic jsonUtil FormListHas ::temp1 ::temp3 "reserved_npcs" ::temp4 ;3 variable args
            return ::temp1 
          .endCode
        .endFunction ;IEB_AssassinationBlocked
      .endState
    .endStateTable
  .endObject
.endObjectTable
