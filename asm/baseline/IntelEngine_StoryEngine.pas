.info
  .source "C:\nolvus-research\build\upstream\intelengine-3.5.1\Source\Scripts\IntelEngine_StoryEngine.psc"
  .compileTime 1791570831 ;2026-10-09 14:33:51
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
            ; line 932
            assign ::temp0 npc1Visible 
            jmpf ::temp0 _label27
            assign ::temp0 npc2Visible 
          _label27:
            jmpf ::temp0 _label28
            ; line 934
            callmethod PerformVisibleInteraction self ::nonevar npc1 npc2 narration storyType ;4 variable args
            jmp _label29
            ; line 935
          _label28:
            assign ::temp0 npc1Visible 
            jmpt ::temp0 _label30
            assign ::temp0 npc2Visible 
          _label30:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label31
            not ::temp0 ::IsNPCStoryActive_var 
            assign ::temp0 ::temp0 
          _label31:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label32
            callmethod IsPlayerTeammate npc1 ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label32:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label33
            callmethod IsPlayerTeammate npc2 ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label33:
            jmpf ::temp0 _label34
            ; line 937
            jmpf npc2Visible _label35
            ; line 938
            callmethod DispatchNPCSocial self ::nonevar npc1 npc2 narration storyType ;4 variable args
            jmp _label36
            ; line 940
          _label35:
            callmethod DispatchNPCSocial self ::nonevar npc2 npc1 narration storyType ;4 variable args
          _label36:
            jmp _label29
            ; line 944
          _label34:
            callmethod BuildInteractionSummary self ::temp1 npc1 narration npc2 ;3 variable args
            assign summary ::temp1 
            ; line 945
            strcat ::temp1 storyType ": " 
            strcat ::temp1 ::temp1 summary 
            callmethod AddRecentStoryEvent self ::nonevar ::temp1 ;1 variable args
            ; line 946
            strcat ::temp1 "Story: " summary 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
          _label29
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
            .local slot Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local summary String
            .local ::temp2 String
            .local ::nonevar None
            .local ::temp3 objectReference
            .local ::temp4 objectReference
            .local ::temp5 keyword
            .local ::temp6 package
            .local ::temp7 String
            .local ::temp8 Float
          .endLocalTable
          .code
            ; line 956
            callmethod FindFreeAgentSlot ::Core_var ::temp0 ;0 variable args
            assign slot ::temp0 
            ; line 957
            cmp_lt ::temp1 slot 0 
            jmpf ::temp1 _label0
            ; line 959
            callmethod BuildInteractionSummary self ::temp2 npc narration target ;3 variable args
            assign summary ::temp2 
            ; line 960
            strcat ::temp2 storyType ": " 
            strcat ::temp2 ::temp2 summary 
            callmethod AddRecentStoryEvent self ::nonevar ::temp2 ;1 variable args
            ; line 961
            strcat ::temp2 "NPC Social: no free slot, off-screen: " summary 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 962
            return None 
            jmp _label0
            ; line 965
          _label0:
            callmethod GetDisplayName target ::temp2 ;0 variable args
            callmethod AllocateSlot ::Core_var ::nonevar slot npc "npc_social" ::temp2 1 ;5 variable args
            ; line 967
            assign ::NPCSocialTraveler_var npc 
            ; line 968
            assign ::NPCSocialTarget_var target 
            ; line 969
            assign ::NPCSocialNarration_var narration 
            ; line 970
            assign ::NPCSocialType_var storyType 
            ; line 971
            assign ::IsNPCStoryActive_var True 
            ; line 974
            callmethod RemoveAllPackages ::Core_var ::nonevar npc False ;2 variable args
            ; line 975
            cast ::temp3 npc 
            cast ::temp4 target 
            propget IntelEngine_TravelTarget ::Core_var ::temp5 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp3 ::temp4 ::temp5 ;3 variable args
            ; line 976
            propget TravelPackage_Jog ::Core_var ::temp6 
            propget PRIORITY_TRAVEL ::Core_var ::temp0 
            callstatic actorUtil AddPackageOverride ::nonevar npc ::temp6 ::temp0 1 ;4 variable args
            ; line 977
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 978
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 980
            callmethod InitializeStuckTrackingForSlot ::Core_var ::nonevar slot npc ;2 variable args
            ; line 981
            cast ::temp4 target 
            callmethod InitOffScreenTracking ::Core_var ::nonevar slot npc ::temp4 ;3 variable args
            ; line 983
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 "NPC Social: dispatching " ::temp2 
            strcat ::temp2 ::temp2 " to " 
            callmethod GetDisplayName target ::temp7 ;0 variable args
            strcat ::temp7 ::temp2 ::temp7 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            ; line 986
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
            ; line 991
            cast ::temp0 None 
            cmp_eq ::temp1 ::NPCSocialTraveler_var ::temp0 
            jmpf ::temp1 _label0
            ; line 992
            callmethod CleanupNPCSocialDispatch self ::nonevar ;0 variable args
            ; line 993
            return None 
            jmp _label0
            ; line 996
          _label0:
            callmethod IsDead ::NPCSocialTraveler_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            callmethod IsDisabled ::NPCSocialTraveler_var ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 997
            callmethod CleanupNPCSocialDispatch self ::nonevar ;0 variable args
            ; line 998
            return None 
            jmp _label2
            ; line 1000
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
            ; line 1001
            callmethod CleanupNPCSocialDispatch self ::nonevar ;0 variable args
            ; line 1002
            return None 
            jmp _label5
            ; line 1005
          _label5:
            cast ::temp2 ::NPCSocialTarget_var 
            callmethod GetDistance ::NPCSocialTraveler_var ::temp3 ::temp2 ;1 variable args
            assign dist ::temp3 
            ; line 1008
            propget ARRIVAL_DISTANCE ::Core_var ::temp3 
            cmp_lte ::temp1 dist ::temp3 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label6
            cmp_gt ::temp1 dist 0.0 
            assign ::temp1 ::temp1 
          _label6:
            jmpf ::temp1 _label7
            ; line 1009
            callmethod OnNPCSocialArrived self ::nonevar ;0 variable args
            ; line 1010
            return None 
            jmp _label7
            ; line 1013
          _label7:
            callmethod FindSlotByAgent ::Core_var ::temp4 ::NPCSocialTraveler_var ;1 variable args
            assign slot ::temp4 
            ; line 1014
            cmp_lt ::temp1 slot 0 
            jmpf ::temp1 _label8
            ; line 1015
            callmethod CleanupNPCSocialDispatch self ::nonevar ;0 variable args
            ; line 1016
            return None 
            jmp _label8
            ; line 1020
          _label8:
            callmethod Is3DLoaded ::NPCSocialTraveler_var ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label9
            ; line 1021
            cast ::temp2 ::NPCSocialTarget_var 
            callmethod HandleOffScreenTravel ::Core_var ::temp1 slot ::NPCSocialTraveler_var ::temp2 ;3 variable args
            jmpf ::temp1 _label10
            ; line 1022
            propget TELEPORT_OFFSET_EXTERIOR self ::temp3 
            callmethod TeleportNPCSocialAndResume self ::nonevar ::temp3 ;1 variable args
            jmp _label10
            ; line 1024
          _label10:
            return None 
            jmp _label9
            ; line 1028
          _label9:
            propget STUCK_DISTANCE_THRESHOLD ::Core_var ::temp3 
            callstatic intelEngine CheckStuckStatus ::temp4 ::NPCSocialTraveler_var slot ::temp3 ;3 variable args
            assign stuckStatus ::temp4 
            ; line 1029
            cmp_eq ::temp1 stuckStatus 1 
            jmpf ::temp1 _label11
            ; line 1030
            cast ::temp2 ::NPCSocialTarget_var 
            callmethod SoftStuckRecovery ::Core_var ::nonevar ::NPCSocialTraveler_var slot ::temp2 ;3 variable args
            jmp _label12
            ; line 1031
          _label11:
            comp_gte ::temp1 stuckStatus 3 
            jmpf ::temp1 _label12
            ; line 1032
            propget TELEPORT_OFFSET_EXTERIOR self ::temp3 
            callmethod TeleportNPCSocialAndResume self ::nonevar ::temp3 ;1 variable args
            jmp _label12
            ; line 1036
          _label12:
            cast ::temp5 ::NPCSocialTraveler_var 
            callstatic storageUtil GetFloatValue ::temp3 ::temp5 "Intel_TaskStartTime" 0.0 ;3 variable args
            assign taskStart ::temp3 
            ; line 1037
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
            ; line 1038
            callmethod GetDisplayName ::NPCSocialTraveler_var ::temp7 ;0 variable args
            strcat ::temp7 "NPC Social: timeout for " ::temp7 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            ; line 1039
            callmethod TeleportNPCSocialAndResume self ::nonevar 200.0 ;1 variable args
            ; line 1040
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
            ; line 1046
            cast ::temp0 ::NPCSocialTarget_var 
            callstatic intelEngine GetOffsetBehind ::temp1 ::temp0 distance ;2 variable args
            assign offset ::temp1 
            ; line 1047
            cast ::temp0 ::NPCSocialTarget_var 
            array_getlement ::temp2 offset 0 
            array_getlement ::temp3 offset 1 
            callmethod MoveTo ::NPCSocialTraveler_var ::nonevar ::temp0 ::temp2 ::temp3 0.0 False ;5 variable args
            ; line 1048
            callmethod RemoveAllPackages ::Core_var ::nonevar ::NPCSocialTraveler_var False ;2 variable args
            ; line 1049
            cast ::temp0 ::NPCSocialTraveler_var 
            cast ::temp4 ::NPCSocialTarget_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp5 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp0 ::temp4 ::temp5 ;3 variable args
            ; line 1050
            propget TravelPackage_Jog ::Core_var ::temp6 
            propget PRIORITY_TRAVEL ::Core_var ::temp7 
            callstatic actorUtil AddPackageOverride ::nonevar ::NPCSocialTraveler_var ::temp6 ::temp7 1 ;4 variable args
            ; line 1051
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 1052
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
            ; line 1057
            callmethod GetDisplayName ::NPCSocialTraveler_var ::temp0 ;0 variable args
            strcat ::temp0 "NPC Social: " ::temp0 
            strcat ::temp0 ::temp0 " arrived at " 
            callmethod GetDisplayName ::NPCSocialTarget_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp0 ::temp1 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 1058
            callmethod PerformVisibleInteraction self ::nonevar ::NPCSocialTraveler_var ::NPCSocialTarget_var ::NPCSocialNarration_var ::NPCSocialType_var ;4 variable args
            ; line 1059
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
            ; line 1063
            cast ::temp0 None 
            cmp_eq ::temp1 ::NPCSocialTraveler_var ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label0
            ; line 1064
            callmethod FindSlotByAgent ::Core_var ::temp2 ::NPCSocialTraveler_var ;1 variable args
            assign slot ::temp2 
            ; line 1065
            comp_gte ::temp1 slot 0 
            jmpf ::temp1 _label1
            ; line 1066
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label2
            ; line 1068
          _label1:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::NPCSocialTraveler_var False ;2 variable args
          _label2:
            jmp _label0
            ; line 1071
          _label0:
            cast ::temp0 None 
            assign ::NPCSocialTraveler_var ::temp0 
            ; line 1072
            cast ::temp0 None 
            assign ::NPCSocialTarget_var ::temp0 
            ; line 1073
            assign ::NPCSocialNarration_var "" 
            ; line 1074
            assign ::NPCSocialType_var "" 
            ; line 1075
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
            ; line 1080
            cast ::temp0 candidate 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "Intel_ScheduledState" -1 ;3 variable args
            comp_gte ::temp2 ::temp1 0 
            jmpf ::temp2 _label0
            ; line 1081
            return False 
            jmp _label0
            ; line 1084
          _label0:
            cast ::temp0 candidate 
            callstatic storageUtil GetFloatValue ::temp3 ::temp0 "Intel_StoryLastPicked" 0.0 ;3 variable args
            assign lastPicked ::temp3 
            ; line 1085
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            assign currentTime ::temp3 
            ; line 1086
            callmethod GetStoryEngineCooldown ::Core_var ::temp3 ;0 variable args
            fdiv ::temp3 ::temp3 24.0 
            assign cooldownDays ::temp3 
            ; line 1087
            cmp_gt ::temp2 lastPicked 0.0 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label1
            fsub ::temp3 currentTime lastPicked 
            cmp_lt ::temp2 ::temp3 cooldownDays 
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 1088
            callstatic intelEngine NotifyStoryCooldown ::nonevar candidate lastPicked ;2 variable args
            ; line 1090
            cast ::temp0 self 
            cast ::temp4 candidate 
            callstatic storageUtil FormListAdd ::temp1 ::temp0 "Intel_CooldownActors" ::temp4 False ;4 variable args
            ; line 1091
            return False 
            jmp _label2
            ; line 1094
          _label2:
            cast ::temp4 candidate 
            callstatic storageUtil SetFloatValue ::temp3 ::temp4 "Intel_StoryLastPicked" currentTime ;3 variable args
            ; line 1095
            callstatic intelEngine NotifyStoryCooldown ::nonevar candidate currentTime ;2 variable args
            ; line 1097
            cast ::temp4 self 
            cast ::temp0 candidate 
            callstatic storageUtil FormListAdd ::temp1 ::temp4 "Intel_CooldownActors" ::temp0 False ;4 variable args
            ; line 1098
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
            ; line 1103
            cast ::temp0 candidate 
            callstatic storageUtil GetFloatValue ::temp1 ::temp0 "Intel_NPCSocialLastPicked" 0.0 ;3 variable args
            assign lastPicked ::temp1 
            ; line 1104
            cmp_lte ::temp2 lastPicked 0.0 
            jmpf ::temp2 _label0
            ; line 1105
            return True 
            jmp _label0
            ; line 1107
          _label0:
            fdiv ::temp1 ::NPCSocialCooldownHours_var 24.0 
            assign cooldownDays ::temp1 
            ; line 1108
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
            ; line 1113
            callstatic utility GetCurrentGameTime ::temp0 ;0 variable args
            assign now ::temp0 
            ; line 1114
            cast ::temp1 candidate 
            callstatic storageUtil SetFloatValue ::temp0 ::temp1 "Intel_NPCSocialLastPicked" now ;3 variable args
            ; line 1115
            cast ::temp1 self 
            cast ::temp2 candidate 
            callstatic storageUtil FormListHas ::temp3 ::temp1 "Intel_SocialCooldownActors" ::temp2 ;3 variable args
            not ::temp3 ::temp3 
            jmpf ::temp3 _label0
            ; line 1116
            cast ::temp2 self 
            cast ::temp1 candidate 
            callstatic storageUtil FormListAdd ::temp4 ::temp2 "Intel_SocialCooldownActors" ::temp1 True ;4 variable args
            jmp _label0
            ; line 1118
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
            ; line 1123
            callstatic utility GetCurrentGameTime ::temp0 ;0 variable args
            assign currentTime ::temp0 
            ; line 1124
            callmethod GetStoryEngineCooldown ::Core_var ::temp0 ;0 variable args
            fdiv ::temp0 ::temp0 24.0 
            assign cooldownDays ::temp0 
            ; line 1126
            cast ::temp1 self 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "Intel_CooldownActors" ;2 variable args
            assign count ::temp2 
            ; line 1127
            assign warmed 0 
            ; line 1128
            isub ::temp2 count 1 
            assign i ::temp2 
            ; line 1129
          _label6:
            comp_gte ::temp3 i 0 
            jmpf ::temp3 _label0
            ; line 1130
            cast ::temp1 self 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "Intel_CooldownActors" i ;3 variable args
            cast ::temp4 ::temp1 
            assign npc ::temp4 
            ; line 1131
            cast ::temp4 None 
            cmp_eq ::temp3 npc ::temp4 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label1
            ; line 1132
            cast ::temp1 npc 
            callstatic storageUtil GetFloatValue ::temp0 ::temp1 "Intel_StoryLastPicked" 0.0 ;3 variable args
            assign lastPicked ::temp0 
            ; line 1133
            cmp_gt ::temp3 lastPicked 0.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label2
            fsub ::temp0 currentTime lastPicked 
            cmp_lt ::temp3 ::temp0 cooldownDays 
            assign ::temp3 ::temp3 
          _label2:
            jmpf ::temp3 _label3
            ; line 1134
            callstatic intelEngine NotifyStoryCooldown ::nonevar npc lastPicked ;2 variable args
            ; line 1135
            iadd ::temp2 warmed 1 
            assign warmed ::temp2 
            jmp _label4
            ; line 1137
          _label3:
            cast ::temp1 self 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_CooldownActors" i ;3 variable args
          _label4:
            jmp _label5
            ; line 1140
          _label1:
            cast ::temp1 self 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_CooldownActors" i ;3 variable args
            ; line 1142
          _label5:
            isub ::temp2 i 1 
            assign i ::temp2 
            jmp _label6
            ; line 1144
          _label0:
            cmp_gt ::temp3 warmed 0 
            jmpf ::temp3 _label7
            ; line 1145
            cast ::temp5 warmed 
            strcat ::temp5 "Story: warmed C++ cooldown mirror (" ::temp5 
            strcat ::temp5 ::temp5 " NPCs)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            jmp _label7
            ; line 1149
          _label7:
            fdiv ::temp0 ::NPCSocialCooldownHours_var 24.0 
            assign socialCooldownDays ::temp0 
            ; line 1150
            cast ::temp1 self 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "Intel_SocialCooldownActors" ;2 variable args
            assign socialCount ::temp2 
            ; line 1151
            assign socialWarmed 0 
            ; line 1152
            isub ::temp2 socialCount 1 
            assign si ::temp2 
            ; line 1153
          _label14:
            comp_gte ::temp3 si 0 
            jmpf ::temp3 _label8
            ; line 1154
            cast ::temp1 self 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "Intel_SocialCooldownActors" si ;3 variable args
            cast ::temp4 ::temp1 
            assign socialNpc ::temp4 
            ; line 1155
            cast ::temp4 None 
            cmp_eq ::temp3 socialNpc ::temp4 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label9
            ; line 1156
            cast ::temp1 socialNpc 
            callstatic storageUtil GetFloatValue ::temp0 ::temp1 "Intel_NPCSocialLastPicked" 0.0 ;3 variable args
            assign socialLastPicked ::temp0 
            ; line 1157
            cmp_gt ::temp3 socialLastPicked 0.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label10
            fsub ::temp0 currentTime socialLastPicked 
            cmp_lt ::temp3 ::temp0 socialCooldownDays 
            assign ::temp3 ::temp3 
          _label10:
            jmpf ::temp3 _label11
            ; line 1158
            callstatic intelEngine NotifySocialCooldown ::nonevar socialNpc socialLastPicked ::NPCSocialCooldownHours_var ;3 variable args
            ; line 1159
            iadd ::temp2 socialWarmed 1 
            assign socialWarmed ::temp2 
            jmp _label12
            ; line 1161
          _label11:
            cast ::temp1 self 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_SocialCooldownActors" si ;3 variable args
          _label12:
            jmp _label13
            ; line 1164
          _label9:
            cast ::temp1 self 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_SocialCooldownActors" si ;3 variable args
            ; line 1166
          _label13:
            isub ::temp2 si 1 
            assign si ::temp2 
            jmp _label14
            ; line 1168
          _label8:
            cmp_gt ::temp3 socialWarmed 0 
            jmpf ::temp3 _label15
            ; line 1169
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
            ; line 1181
            callstatic utility GetCurrentRealTime ::temp0 ;0 variable args
            assign now ::temp0 
            ; line 1182
            callstatic game GetPlayer ::temp1 ;0 variable args
            assign player ::temp1 
            ; line 1184
            cmp_gt ::temp2 ::FactionAmbushStartTime_var now 
            jmpf ::temp2 _label0
            ; line 1185
            assign ::FactionAmbushStartTime_var now 
            jmp _label0
            ; line 1189
          _label0:
            cast ::temp3 player 
            callstatic storageUtil FormListCount ::temp4 ::temp3 "Intel_StoryLingerActors" ;2 variable args
            assign lingerCount ::temp4 
            ; line 1190
            isub ::temp4 lingerCount 1 
            assign i ::temp4 
            ; line 1191
          _label4:
            comp_gte ::temp2 i 0 
            jmpf ::temp2 _label1
            ; line 1192
            cast ::temp3 player 
            callstatic storageUtil FormListGet ::temp3 ::temp3 "Intel_StoryLingerActors" i ;3 variable args
            cast ::temp1 ::temp3 
            assign npc ::temp1 
            ; line 1193
            cast ::temp1 None 
            cmp_eq ::temp2 npc ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label2
            ; line 1194
            cast ::temp3 npc 
            callstatic storageUtil GetFloatValue ::temp0 ::temp3 "Intel_StoryLingerStart" 0.0 ;3 variable args
            assign t ::temp0 
            ; line 1195
            cmp_gt ::temp2 t now 
            jmpf ::temp2 _label3
            ; line 1196
            cast ::temp3 npc 
            callstatic storageUtil SetFloatValue ::temp0 ::temp3 "Intel_StoryLingerStart" now ;3 variable args
            jmp _label3
          _label3:
            jmp _label2
            ; line 1199
          _label2:
            isub ::temp4 i 1 
            assign i ::temp4 
            jmp _label4
            ; line 1203
          _label1:
            cast ::temp3 player 
            callstatic storageUtil IntListCount ::temp4 ::temp3 "Intel_FakeEncounterNPCs" ;2 variable args
            assign encCount ::temp4 
            ; line 1204
            isub ::temp4 encCount 1 
            assign i ::temp4 
            ; line 1205
          _label8:
            comp_gte ::temp2 i 0 
            jmpf ::temp2 _label5
            ; line 1206
            cast ::temp3 player 
            callstatic storageUtil IntListGet ::temp4 ::temp3 "Intel_FakeEncounterNPCs" i ;3 variable args
            assign formId ::temp4 
            ; line 1207
            callstatic game GetForm ::temp3 formId ;1 variable args
            cast ::temp1 ::temp3 
            assign ::mangled_npc_0 ::temp1 
            ; line 1208
            cast ::temp1 None 
            cmp_eq ::temp2 ::mangled_npc_0 ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label6
            ; line 1209
            cast ::temp3 ::mangled_npc_0 
            callstatic storageUtil GetFloatValue ::temp0 ::temp3 "Intel_FakeEncounterGreetTime" 0.0 ;3 variable args
            assign ::mangled_t_0 ::temp0 
            ; line 1210
            cmp_gt ::temp2 ::mangled_t_0 now 
            jmpf ::temp2 _label7
            ; line 1211
            cast ::temp3 ::mangled_npc_0 
            callstatic storageUtil SetFloatValue ::temp0 ::temp3 "Intel_FakeEncounterGreetTime" now ;3 variable args
            jmp _label7
          _label7:
            jmp _label6
            ; line 1214
          _label6:
            isub ::temp4 i 1 
            assign i ::temp4 
            jmp _label8
            ; line 1218
          _label5:
            cast ::temp1 None 
            cmp_eq ::temp2 ::ActiveStoryNPC_var ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label9
            ; line 1219
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp0 ::temp3 "Intel_SneakStartTime" 0.0 ;3 variable args
            assign sneakStart ::temp0 
            ; line 1220
            cmp_gt ::temp2 sneakStart now 
            jmpf ::temp2 _label10
            ; line 1221
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil SetFloatValue ::temp0 ::temp3 "Intel_SneakStartTime" now ;3 variable args
            jmp _label10
            ; line 1223
          _label10:
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp0 ::temp3 "Intel_CombatStartTime" 0.0 ;3 variable args
            assign combatStart ::temp0 
            ; line 1224
            cmp_gt ::temp2 combatStart now 
            jmpf ::temp2 _label11
            ; line 1225
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
            ; line 1232
            cast ::temp0 self 
            callstatic storageUtil FormListCount ::temp1 ::temp0 "Intel_BioTrackActors" ;2 variable args
            assign count ::temp1 
            ; line 1233
            assign warmed 0 
            ; line 1234
            isub ::temp1 count 1 
            assign i ::temp1 
            ; line 1235
          _label4:
            comp_gte ::temp2 i 0 
            jmpf ::temp2 _label0
            ; line 1236
            cast ::temp0 self 
            callstatic storageUtil FormListGet ::temp0 ::temp0 "Intel_BioTrackActors" i ;3 variable args
            cast ::temp3 ::temp0 
            assign npc ::temp3 
            ; line 1237
            cast ::temp3 None 
            cmp_eq ::temp2 npc ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label1
            ; line 1238
            cast ::temp0 npc 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "Intel_BioLineCount" 0 ;3 variable args
            assign lines ::temp1 
            ; line 1239
            cmp_gt ::temp2 lines 0 
            jmpf ::temp2 _label2
            ; line 1240
            callstatic intelEngine SetAutoBioCount ::nonevar npc lines ;2 variable args
            ; line 1241
            iadd ::temp1 warmed 1 
            assign warmed ::temp1 
            jmp _label2
          _label2:
            jmp _label3
            ; line 1244
          _label1:
            cast ::temp0 self 
            callstatic storageUtil FormListRemoveAt ::temp2 ::temp0 "Intel_BioTrackActors" i ;3 variable args
            ; line 1246
          _label3:
            isub ::temp1 i 1 
            assign i ::temp1 
            jmp _label4
            ; line 1248
          _label0:
            cmp_gt ::temp2 warmed 0 
            jmpf ::temp2 _label5
            ; line 1249
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
            ; line 1256
            callstatic intelEngine GetDMCandidatePoolFormIDs ::temp0 ;0 variable args
            assign formIDs ::temp0 
            ; line 1257
            array_length ::temp1 formIDs 
            cmp_eq ::temp2 ::temp1 0 
            jmpf ::temp2 _label0
            ; line 1258
            return False 
            jmp _label0
            ; line 1261
          _label0:
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            assign currentTime ::temp3 
            ; line 1262
            callmethod GetStoryEngineCooldown ::Core_var ::temp3 ;0 variable args
            fdiv ::temp3 ::temp3 24.0 
            assign cooldownDays ::temp3 
            ; line 1264
            assign warmed 0 
            ; line 1265
            assign i 0 
            ; line 1266
          _label6:
            array_length ::temp1 formIDs 
            cmp_lt ::temp2 i ::temp1 
            jmpf ::temp2 _label1
            ; line 1267
            array_getlement ::temp1 formIDs i 
            callstatic game GetForm ::temp4 ::temp1 ;1 variable args
            cast ::temp5 ::temp4 
            assign npc ::temp5 
            ; line 1268
            cast ::temp5 None 
            cmp_eq ::temp2 npc ::temp5 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label2
            ; line 1269
            cast ::temp4 npc 
            callstatic storageUtil GetFloatValue ::temp3 ::temp4 "Intel_StoryLastPicked" 0.0 ;3 variable args
            assign lastPicked ::temp3 
            ; line 1270
            cmp_gt ::temp2 lastPicked 0.0 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label3
            fsub ::temp3 currentTime lastPicked 
            cmp_lt ::temp2 ::temp3 cooldownDays 
            assign ::temp2 ::temp2 
          _label3:
            jmpf ::temp2 _label4
            ; line 1271
            callstatic intelEngine NotifyStoryCooldown ::nonevar npc lastPicked ;2 variable args
            ; line 1272
            cast ::temp4 self 
            cast ::temp6 npc 
            callstatic storageUtil FormListAdd ::temp1 ::temp4 "Intel_CooldownActors" ::temp6 False ;4 variable args
            ; line 1273
            iadd ::temp1 warmed 1 
            assign warmed ::temp1 
            jmp _label5
            ; line 1276
          _label4:
            cast ::temp6 npc 
            callstatic storageUtil GetIntValue ::temp1 ::temp6 "Intel_ScheduledState" -1 ;3 variable args
            assign schedState ::temp1 
            ; line 1277
            comp_gte ::temp2 schedState 0 
            jmpf ::temp2 _label5
            ; line 1278
            callstatic intelEngine NotifyStoryCooldown ::nonevar npc currentTime ;2 variable args
            ; line 1279
            cast ::temp6 self 
            cast ::temp4 npc 
            callstatic storageUtil FormListAdd ::temp1 ::temp6 "Intel_CooldownActors" ::temp4 False ;4 variable args
            ; line 1280
            iadd ::temp1 warmed 1 
            assign warmed ::temp1 
            jmp _label5
          _label5:
            jmp _label2
            ; line 1284
          _label2:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label6
            ; line 1286
          _label1:
            cmp_gt ::temp2 warmed 0 
            jmpf ::temp2 _label7
            ; line 1287
            cast ::temp7 warmed 
            strcat ::temp7 "Story: pre-warmed " ::temp7 
            strcat ::temp7 ::temp7 " cooldowns from pool candidates" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            jmp _label7
            ; line 1289
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
            ; line 1295
            callstatic intelEngine GetNPCCandidatePoolFormIDs ::temp0 ;0 variable args
            assign formIDs ::temp0 
            ; line 1296
            array_length ::temp1 formIDs 
            cmp_eq ::temp2 ::temp1 0 
            jmpf ::temp2 _label0
            ; line 1297
            return False 
            jmp _label0
            ; line 1300
          _label0:
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            assign currentTime ::temp3 
            ; line 1301
            fdiv ::temp3 ::NPCSocialCooldownHours_var 24.0 
            assign cooldownDays ::temp3 
            ; line 1303
            assign warmed 0 
            ; line 1304
            assign i 0 
            ; line 1305
          _label6:
            array_length ::temp1 formIDs 
            cmp_lt ::temp2 i ::temp1 
            jmpf ::temp2 _label1
            ; line 1306
            array_getlement ::temp1 formIDs i 
            callstatic game GetForm ::temp4 ::temp1 ;1 variable args
            cast ::temp5 ::temp4 
            assign npc ::temp5 
            ; line 1307
            cast ::temp5 None 
            cmp_eq ::temp2 npc ::temp5 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label2
            ; line 1308
            cast ::temp4 npc 
            callstatic storageUtil GetFloatValue ::temp3 ::temp4 "Intel_NPCSocialLastPicked" 0.0 ;3 variable args
            assign lastPicked ::temp3 
            ; line 1309
            cmp_gt ::temp2 lastPicked 0.0 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label3
            fsub ::temp3 currentTime lastPicked 
            cmp_lt ::temp2 ::temp3 cooldownDays 
            assign ::temp2 ::temp2 
          _label3:
            jmpf ::temp2 _label4
            ; line 1310
            callstatic intelEngine NotifySocialCooldown ::nonevar npc lastPicked ::NPCSocialCooldownHours_var ;3 variable args
            ; line 1311
            cast ::temp4 self 
            cast ::temp6 npc 
            callstatic storageUtil FormListHas ::temp2 ::temp4 "Intel_SocialCooldownActors" ::temp6 ;3 variable args
            not ::temp2 ::temp2 
            jmpf ::temp2 _label5
            ; line 1312
            cast ::temp6 self 
            cast ::temp4 npc 
            callstatic storageUtil FormListAdd ::temp1 ::temp6 "Intel_SocialCooldownActors" ::temp4 True ;4 variable args
            jmp _label5
            ; line 1314
          _label5:
            iadd ::temp1 warmed 1 
            assign warmed ::temp1 
            jmp _label4
          _label4:
            jmp _label2
            ; line 1317
          _label2:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label6
            ; line 1319
          _label1:
            cmp_gt ::temp2 warmed 0 
            jmpf ::temp2 _label7
            ; line 1320
            cast ::temp7 warmed 
            strcat ::temp7 "NPC Social: pre-warmed " ::temp7 
            strcat ::temp7 ::temp7 " social cooldowns from pool" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            jmp _label7
            ; line 1322
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
            ; line 1328
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1329
            cast ::temp1 player 
            callstatic storageUtil StringListCount ::temp2 ::temp1 "Intel_RecentStoryEvents" ;2 variable args
            assign count ::temp2 
            ; line 1330
            cmp_eq ::temp3 count 0 
            jmpf ::temp3 _label0
            ; line 1331
            return None 
            jmp _label0
            ; line 1334
          _label0:
            assign csv "" 
            ; line 1335
            assign i 0 
            ; line 1336
          _label3:
            cmp_lt ::temp3 i count 
            jmpf ::temp3 _label1
            ; line 1337
            cmp_gt ::temp3 i 0 
            jmpf ::temp3 _label2
            ; line 1338
            strcat ::temp4 csv "|" 
            assign csv ::temp4 
            jmp _label2
            ; line 1340
          _label2:
            cast ::temp1 player 
            callstatic storageUtil StringListGet ::temp4 ::temp1 "Intel_RecentStoryEvents" i ;3 variable args
            strcat ::temp4 csv ::temp4 
            assign csv ::temp4 
            ; line 1341
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label3
            ; line 1343
          _label1:
            callstatic intelEngine WarmStoryTypeCountsFromCSV ::nonevar csv ;1 variable args
            ; line 1344
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
            ; line 1353
            cast ::temp0 self 
            callstatic skyrimNetApi SendCustomPromptToLLM ::temp1 promptName "intel_story_dm" contextJson ::temp0 "IntelEngine_StoryEngine" callbackName ;6 variable args
            assign result ::temp1 
            ; line 1354
            cmp_lt ::temp2 result 0 
            jmpf ::temp2 _label0
            ; line 1355
            strcat ::temp3 "[IntelEngine] StoryEngine: LLM call failed (" promptName 
            strcat ::temp3 ::temp3 ") code " 
            cast ::temp4 result 
            strcat ::temp4 ::temp3 ::temp4 
            callstatic debug Trace ::nonevar ::temp4 0 ;2 variable args
            ; line 1356
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
            ; line 1365
            callmethod ClearPending self ::nonevar ;0 variable args
            ; line 1367
            cmp_eq ::temp0 success 1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 1368
            callstatic debug Trace ::nonevar "[IntelEngine] StoryEngine: DM LLM response failed" 0 ;2 variable args
            ; line 1369
            return None 
            jmp _label0
            ; line 1372
          _label0:
            callstatic stringUtil GetLength ::temp1 response ;1 variable args
            assign responseLen ::temp1 
            ; line 1373
            cast ::temp2 responseLen 
            strcat ::temp2 "[IntelEngine] StoryEngine: DM response len=" ::temp2 
            strcat ::temp2 ::temp2 " success=" 
            cast ::temp3 success 
            strcat ::temp3 ::temp2 ::temp3 
            callstatic debug Trace ::nonevar ::temp3 0 ;2 variable args
            ; line 1375
            callmethod ParseShouldAct self ::temp0 response ;1 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label1
            ; line 1376
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: rejected (no compelling story)" ;1 variable args
            ; line 1377
            return None 
            jmp _label1
            ; line 1380
          _label1:
            callmethod ExtractJsonField self ::temp3 response "type" ;2 variable args
            assign storyType ::temp3 
            ; line 1381
            callmethod ExtractJsonField self ::temp3 response "npc" ;2 variable args
            assign npcName ::temp3 
            ; line 1382
            callmethod ExtractJsonField self ::temp3 response "narration" ;2 variable args
            assign narration ::temp3 
            ; line 1384
            cmp_eq ::temp0 storyType "" 
            jmpf ::temp0 _label2
            ; line 1385
            cast ::temp3 responseLen 
            strcat ::temp3 "[IntelEngine] StoryEngine: DM response missing type -- response len=" ::temp3 
            callstatic debug Trace ::nonevar ::temp3 0 ;2 variable args
            ; line 1386
            return None 
            jmp _label2
            ; line 1390
          _label2:
            cmp_eq ::temp0 storyType "faction_ambush" 
            jmpf ::temp0 _label3
            ; line 1391
            callstatic intelEngine NotifyStoryTypePicked ::nonevar storyType ;1 variable args
            ; line 1392
            callmethod ExtractJsonField self ::temp3 response "ambushFaction" ;2 variable args
            callstatic intelEngine RecordStoryDispatch ::nonevar storyType ::temp3 narration ;3 variable args
            ; line 1393
            callmethod HandleFactionAmbushDispatch self ::nonevar narration response ;2 variable args
            ; line 1394
            return None 
            jmp _label3
            ; line 1400
          _label3:
            assign isFactionQuest False 
            ; line 1401
            cmp_eq ::temp0 storyType "quest" 
            jmpf ::temp0 _label4
            ; line 1402
            callmethod ExtractJsonField self ::temp3 response "questSubType" ;2 variable args
            assign preSubTypeEarly ::temp3 
            ; line 1403
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
            ; line 1404
            assign isFactionQuest True 
            ; line 1405
            cmp_eq ::temp0 npcName "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label8
            ; line 1406
            strcat ::temp3 "Story DM: faction quest " preSubTypeEarly 
            strcat ::temp3 ::temp3 " sent npc='" 
            strcat ::temp3 ::temp3 npcName 
            strcat ::temp3 ::temp3 "' -- ignoring (system handles NPC selection)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1407
            assign npcName "" 
            jmp _label8
          _label8:
            jmp _label9
            ; line 1409
          _label7:
            cmp_eq ::temp0 npcName "" 
            jmpf ::temp0 _label9
            ; line 1410
            cast ::temp3 responseLen 
            strcat ::temp3 "[IntelEngine] StoryEngine: DM response missing npc -- response len=" ::temp3 
            callstatic debug Trace ::nonevar ::temp3 0 ;2 variable args
            ; line 1411
            return None 
            jmp _label9
          _label9:
            jmp _label10
            ; line 1413
          _label4:
            cmp_eq ::temp0 npcName "" 
            jmpf ::temp0 _label10
            ; line 1414
            cast ::temp3 responseLen 
            strcat ::temp3 "[IntelEngine] StoryEngine: DM response missing npc -- response len=" ::temp3 
            callstatic debug Trace ::nonevar ::temp3 0 ;2 variable args
            ; line 1415
            return None 
            jmp _label10
            ; line 1421
          _label10:
            assign typeWithSub storyType 
            ; line 1422
            cmp_eq ::temp0 storyType "quest" 
            jmpf ::temp0 _label11
            ; line 1423
            callmethod ExtractJsonField self ::temp3 response "questSubType" ;2 variable args
            assign subTypeForTracking ::temp3 
            ; line 1424
            cmp_eq ::temp0 subTypeForTracking "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label12
            ; line 1425
            strcat ::temp3 "quest/" subTypeForTracking 
            assign typeWithSub ::temp3 
            jmp _label12
          _label12:
            jmp _label11
            ; line 1428
          _label11:
            callstatic intelEngine NotifyStoryTypePicked ::nonevar typeWithSub ;1 variable args
            ; line 1432
            callstatic intelEngine RecordStoryDispatch ::nonevar typeWithSub npcName narration ;3 variable args
            ; line 1436
            cast ::temp4 None 
            assign npc ::temp4 
            ; line 1437
            not ::temp0 isFactionQuest 
            jmpf ::temp0 _label13
            ; line 1438
            callstatic intelEngine ResolveStoryCandidate ::temp4 npcName ;1 variable args
            assign npc ::temp4 
            ; line 1439
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
            ; line 1446
            callstatic intelEngine StringToLower ::temp3 npcName ;1 variable args
            assign lowerNpcName ::temp3 
            ; line 1447
            cmp_eq ::temp0 lowerNpcName "courier" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label17
            cmp_eq ::temp0 lowerNpcName "messenger" 
            assign ::temp0 ::temp0 
          _label17:
            jmpf ::temp0 _label18
            ; line 1449
            cast ::temp4 None 
            assign npc ::temp4 
            ; line 1450
            callmethod ExtractJsonField self ::temp3 response "alliedFaction" ;2 variable args
            assign substFaction ::temp3 
            ; line 1451
            cmp_eq ::temp0 substFaction "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label19
            ; line 1452
            callstatic intelEngine FindFactionMember ::temp4 substFaction ;1 variable args
            assign npc ::temp4 
            ; line 1453
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label20
            ; line 1454
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
            ; line 1457
          _label19:
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            jmpf ::temp0 _label21
            ; line 1458
            callmethod ExtractJsonField self ::temp2 response "sender" ;2 variable args
            assign substSender ::temp2 
            ; line 1459
            cmp_eq ::temp0 substSender "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label22
            ; line 1460
            callstatic intelEngine FindNPCByName ::temp4 substSender ;1 variable args
            assign senderActor ::temp4 
            ; line 1461
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
            ; line 1462
            callstatic intelEngine FindMessengerForSender ::temp4 senderActor ;1 variable args
            assign npc ::temp4 
            ; line 1463
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label26
            ; line 1464
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
            ; line 1470
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
            ; line 1471
            strcat ::temp3 "Story DM: NPC '" npcName 
            strcat ::temp3 ::temp3 "' not found or invalid" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1472
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "npc not found / dead / disabled" ;1 variable args
            ; line 1473
            return None 
            jmp _label29
          _label29:
            jmp _label16
          _label16:
            jmp _label13
            ; line 1478
          _label13:
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label30
            ; line 1484
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
            ; line 1485
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 "Story DM: " ::temp3 
            strcat ::temp3 ::temp3 " is high-status — rejected (should use courier mode)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1486
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "high-status NPC cannot physically travel" ;1 variable args
            ; line 1487
            return None 
            jmp _label33
            ; line 1491
          _label33:
            callstatic intelEngine CheckHoldRestriction ::temp0 npc storyType ;2 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label34
            ; line 1492
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 "Story DM: " ::temp3 
            strcat ::temp3 ::temp3 " rejected — hold restriction for " 
            strcat ::temp3 ::temp3 storyType 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1493
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "hold restriction" ;1 variable args
            ; line 1494
            return None 
            jmp _label34
            ; line 1496
          _label34:
            callmethod ApplyCooldownCheck self ::temp0 npc ;1 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label35
            ; line 1497
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 "Story DM: " ::temp3 
            strcat ::temp3 ::temp3 " on cooldown" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1498
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "on story cooldown" ;1 variable args
            ; line 1499
            return None 
            jmp _label35
            ; line 1504
          _label35:
            cmp_eq ::temp0 storyType "seek_player" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label36
            cmp_eq ::temp0 storyType "informant" 
            assign ::temp0 ::temp0 
          _label36:
            jmpf ::temp0 _label37
            ; line 1505
            callmethod GetParentCell npc ::temp5 ;0 variable args
            assign npcCell ::temp5 
            ; line 1506
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod GetParentCell ::temp4 ::temp5 ;0 variable args
            assign playerCell ::temp5 
            ; line 1507
            cast ::temp5 None 
            cmp_eq ::temp0 npcCell ::temp5 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label38
            cast ::temp5 None 
            cmp_eq ::temp0 playerCell ::temp5 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label38:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label39
            cmp_eq ::temp0 npcCell playerCell 
            assign ::temp0 ::temp0 
          _label39:
            jmpf ::temp0 _label40
            ; line 1508
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 "Story DM: " ::temp3 
            strcat ::temp3 ::temp3 " already in player's cell, skipping " 
            strcat ::temp3 ::temp3 storyType 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1509
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "npc already in player's cell" ;1 variable args
            ; line 1510
            return None 
            jmp _label40
          _label40:
            jmp _label37
            ; line 1515
          _label37:
            cmp_eq ::temp0 storyType "stalker" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label41
            cmp_eq ::temp0 storyType "ambush" 
            assign ::temp0 ::temp0 
          _label41:
            jmpf ::temp0 _label42
            ; line 1516
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod GetParentCell ::temp4 ::temp5 ;0 variable args
            assign playerCell2 ::temp5 
            ; line 1517
            cast ::temp5 None 
            cmp_eq ::temp0 playerCell2 ::temp5 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label43
            callmethod IsInterior playerCell2 ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label43:
            jmpf ::temp0 _label44
            ; line 1518
            strcat ::temp3 "Story DM: rejecting " storyType 
            strcat ::temp3 ::temp3 " -- player is in interior" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1519
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "interior cell rejects stalker/ambush" ;1 variable args
            ; line 1520
            return None 
            jmp _label44
          _label44:
            jmp _label42
          _label42:
            jmp _label30
            ; line 1525
          _label30:
            jmpf isFactionQuest _label45
            ; line 1526
            callmethod ExtractJsonField self ::temp3 response "questSubType" ;2 variable args
            strcat ::temp3 "Story DM [quest/faction]: " ::temp3 
            strcat ::temp3 ::temp3 " -- " 
            strcat ::temp3 ::temp3 narration 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label46
            ; line 1528
          _label45:
            strcat ::temp3 "Story DM [" storyType 
            strcat ::temp3 ::temp3 "]: " 
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 ::temp3 ::temp2 
            strcat ::temp2 ::temp2 " -- " 
            strcat ::temp2 ::temp2 narration 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 1533
          _label46:
            callmethod PackToggleBitmask self ::temp1 ;0 variable args
            assign toggles ::temp1 
            ; line 1534
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod PackEnvFlags self ::temp1 ::temp4 ;1 variable args
            assign envFlags ::temp1 
            ; line 1535
            callstatic intelEngine ValidateStoryResponse ::temp2 response toggles envFlags ;3 variable args
            assign validateJson ::temp2 
            ; line 1536
            callstatic intelEngine StoryResponseGetField ::temp2 validateJson "valid" ;2 variable args
            cmp_eq ::temp0 ::temp2 "true" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label47
            ; line 1537
            callstatic intelEngine StoryResponseGetField ::temp2 validateJson "reason" ;2 variable args
            assign validationReason ::temp2 
            ; line 1538
            strcat ::temp2 "Story DM: C++ validation rejected -- " validationReason 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 1539
            strcat ::temp2 "validation: " validationReason 
            callstatic intelEngine MarkLastDispatchFailed ::nonevar ::temp2 ;1 variable args
            ; line 1540
            return None 
            jmp _label47
            ; line 1544
          _label47:
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label48
            callstatic intelEngine IsJarl ::temp0 npc ;1 variable args
            assign ::temp0 ::temp0 
          _label48:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label49
            cmp_eq ::temp0 storyType "message" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label49:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label50
            cmp_eq ::temp0 storyType "quest" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label50:
            jmpf ::temp0 _label51
            ; line 1545
            strcat ::temp2 "Story DM: rejecting " storyType 
            strcat ::temp2 ::temp2 " for Jarl " 
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 ::temp2 ::temp3 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 1548
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "high-status NPC cannot physically travel" ;1 variable args
            ; line 1549
            return None 
            jmp _label51
            ; line 1553
          _label51:
            cmp_eq ::temp0 storyType "quest" 
            jmpf ::temp0 _label52
            ; line 1554
            jmpf ::QuestActive_var _label53
            ; line 1555
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest rejected -- one already active" ;1 variable args
            ; line 1556
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "a quest is already active" ;1 variable args
            ; line 1557
            return None 
            jmp _label53
          _label53:
            jmp _label54
            ; line 1560
          _label52:
            cmp_eq ::temp0 storyType "message" 
            jmpf ::temp0 _label54
            ; line 1561
            callmethod ExtractJsonField self ::temp3 response "msgContent" ;2 variable args
            cmp_eq ::temp0 ::temp3 "" 
            jmpf ::temp0 _label55
            ; line 1562
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: message rejected -- missing msgContent" ;1 variable args
            ; line 1565
            callstatic intelEngine MarkLastDispatchFailed ::nonevar "validation: missing msgContent" ;1 variable args
            ; line 1566
            return None 
            jmp _label55
          _label55:
            jmp _label54
            ; line 1574
          _label54:
            cmp_eq ::temp0 storyType "message" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label56
            cast ::temp4 None 
            cmp_eq ::temp0 npc ::temp4 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label56:
            jmpf ::temp0 _label57
            ; line 1575
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            assign npcDispName ::temp3 
            ; line 1576
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod GetDisplayName ::temp4 ::temp3 ;0 variable args
            assign playerDispName ::temp3 
            ; line 1577
            callstatic intelEngine NPCKnowsPlayer ::temp0 npc ;1 variable args
            jmpf ::temp0 _label58
            ; line 1578
            callstatic game GetPlayer ::temp4 ;0 variable args
            strcat ::temp3 npcDispName " set out to find " 
            strcat ::temp3 ::temp3 playerDispName 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc ::temp4 ::temp3 ;3 variable args
            jmp _label59
            ; line 1580
          _label58:
            callstatic game GetPlayer ::temp4 ;0 variable args
            strcat ::temp3 npcDispName " set out to find someone known as '" 
            strcat ::temp3 ::temp3 playerDispName 
            strcat ::temp3 ::temp3 "' — has never met them before, only heard the name" 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc ::temp4 ::temp3 ;3 variable args
            ; line 1581
            strcat ::temp3 "has never met " playerDispName 
            strcat ::temp3 ::temp3 " personally — approaching a stranger, should introduce themselves and confirm identity" 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp3 ;2 variable args
          _label59:
            jmp _label57
            ; line 1586
          _label57:
            cmp_eq ::temp0 storyType "seek_player" 
            jmpf ::temp0 _label60
            ; line 1587
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod GetDisplayName ::temp4 ::temp3 ;0 variable args
            strcat ::temp3 "set out to find " ::temp3 
            strcat ::temp3 ::temp3 " -- " 
            strcat ::temp3 ::temp3 narration 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp3 ;2 variable args
            ; line 1588
            assign ::ActiveStoryType_var storyType 
            ; line 1589
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod DispatchToTarget self ::nonevar npc ::temp4 narration "story" ;4 variable args
            jmp _label61
            ; line 1591
          _label60:
            cmp_eq ::temp0 storyType "message" 
            jmpf ::temp0 _label62
            ; line 1592
            callmethod HandleMessageDispatch self ::nonevar npc narration response ;3 variable args
            jmp _label61
            ; line 1594
          _label62:
            cmp_eq ::temp0 storyType "ambush" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label63
            cmp_eq ::temp0 storyType "stalker" 
            assign ::temp0 ::temp0 
          _label63:
            jmpf ::temp0 _label64
            ; line 1595
            callmethod HandleAmbushStalkerDispatch self ::nonevar npc narration response storyType ;4 variable args
            jmp _label61
            ; line 1597
          _label64:
            cmp_eq ::temp0 storyType "quest" 
            jmpf ::temp0 _label65
            ; line 1598
            callmethod HandleQuestDispatch self ::nonevar npc narration response ;3 variable args
            jmp _label61
            ; line 1600
          _label65:
            cmp_eq ::temp0 storyType "informant" 
            jmpf ::temp0 _label66
            ; line 1601
            callmethod ExtractJsonField self ::temp3 response "subject" ;2 variable args
            assign subjectName ::temp3 
            ; line 1602
            callmethod ExtractJsonField self ::temp3 response "gossip" ;2 variable args
            assign gossipText ::temp3 
            ; line 1603
            callmethod ExtractJsonField self ::temp3 response "sender" ;2 variable args
            assign gossipSource ::temp3 
            ; line 1604
            cmp_eq ::temp0 subjectName "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label67
            cmp_eq ::temp0 gossipText "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label67:
            jmpf ::temp0 _label68
            ; line 1605
            callstatic intelEngine FindNPCByName ::temp4 subjectName ;1 variable args
            assign subjectNPC ::temp4 
            ; line 1606
            cast ::temp4 None 
            cmp_eq ::temp0 subjectNPC ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label69
            ; line 1607
            callmethod InjectFact ::Core_var ::nonevar subjectNPC gossipText ;2 variable args
            jmp _label69
            ; line 1610
          _label69:
            cmp_eq ::temp0 gossipSource "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label70
            ; line 1611
            strcat ::temp3 "heard from " gossipSource 
            strcat ::temp3 ::temp3 " that " 
            strcat ::temp3 ::temp3 subjectName 
            strcat ::temp3 ::temp3 " " 
            strcat ::temp3 ::temp3 gossipText 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp3 ;2 variable args
            jmp _label71
            ; line 1613
          _label70:
            strcat ::temp3 "witnessed that " subjectName 
            strcat ::temp3 ::temp3 " " 
            strcat ::temp3 ::temp3 gossipText 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp3 ;2 variable args
          _label71:
            jmp _label68
            ; line 1616
          _label68:
            assign ::ActiveStoryType_var "informant" 
            ; line 1617
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod DispatchToTarget self ::nonevar npc ::temp4 narration "story" ;4 variable args
            jmp _label61
            ; line 1619
          _label66:
            cmp_eq ::temp0 storyType "road_encounter" 
            jmpf ::temp0 _label72
            ; line 1620
            callmethod ExtractJsonField self ::temp3 response "destination" ;2 variable args
            assign destination ::temp3 
            ; line 1621
            callmethod InjectFact ::Core_var ::nonevar npc narration ;2 variable args
            ; line 1622
            callmethod PlaceRoadEncounter self ::nonevar npc narration destination ;3 variable args
            jmp _label61
            ; line 1625
          _label72:
            strcat ::temp3 "Story DM: unknown type '" storyType 
            strcat ::temp3 ::temp3 "'" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
          _label61
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
            ; line 1633
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1634
            callmethod GetParentCell player ::temp1 ;0 variable args
            assign playerCell ::temp1 
            ; line 1637
            cast ::temp1 None 
            cmp_eq ::temp2 playerCell ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label0
            ; line 1638
            callmethod GetParentCell originalGossiper ::temp1 ;0 variable args
            cmp_eq ::temp2 ::temp1 playerCell 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label1
            callmethod GetParentCell firstRecipient ::temp1 ;0 variable args
            cmp_eq ::temp2 ::temp1 playerCell 
            assign ::temp2 ::temp2 
          _label1:
            jmpf ::temp2 _label2
            ; line 1639
            return None 
            jmp _label2
          _label2:
            jmp _label0
            ; line 1644
          _label0:
            assign trackKey "Intel_GossipChainTemp" 
            ; line 1645
            cast ::temp3 player 
            callstatic storageUtil IntListClear ::temp4 ::temp3 trackKey ;2 variable args
            ; line 1646
            cast ::temp3 player 
            callmethod GetFormID originalGossiper ::temp4 ;0 variable args
            callstatic storageUtil IntListAdd ::temp4 ::temp3 trackKey ::temp4 True ;4 variable args
            ; line 1647
            cast ::temp3 player 
            callmethod GetFormID firstRecipient ::temp4 ;0 variable args
            callstatic storageUtil IntListAdd ::temp4 ::temp3 trackKey ::temp4 True ;4 variable args
            ; line 1649
            callstatic utility RandomInt ::temp4 1 10 ;2 variable args
            assign spreads ::temp4 
            ; line 1650
            assign currentGiver firstRecipient 
            ; line 1651
            assign s 0 
            ; line 1652
          _label7:
            cmp_lt ::temp2 s spreads 
            jmpf ::temp2 _label3
            ; line 1653
            callstatic intelEngine GetRelatedCandidate ::temp0 currentGiver ;1 variable args
            assign nextRecipient ::temp0 
            ; line 1654
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
            ; line 1655
            callmethod InjectGossip ::Core_var ::nonevar currentGiver nextRecipient gossip ;3 variable args
            ; line 1656
            callmethod GetDisplayName currentGiver ::temp5 ;0 variable args
            strcat ::temp5 "[IntelEngine] StoryEngine [npc_gossip chain]: " ::temp5 
            strcat ::temp5 ::temp5 " -> " 
            callmethod GetDisplayName nextRecipient ::temp6 ;0 variable args
            strcat ::temp6 ::temp5 ::temp6 
            callstatic debug Trace ::nonevar ::temp6 0 ;2 variable args
            ; line 1657
            callmethod GetDisplayName currentGiver ::temp6 ;0 variable args
            strcat ::temp6 "npc_gossip: " ::temp6 
            strcat ::temp6 ::temp6 " told " 
            callmethod GetDisplayName nextRecipient ::temp5 ;0 variable args
            strcat ::temp5 ::temp6 ::temp5 
            strcat ::temp5 ::temp5 ": " 
            strcat ::temp5 ::temp5 gossip 
            callmethod AddRecentStoryEvent self ::nonevar ::temp5 ;1 variable args
            ; line 1658
            cast ::temp3 player 
            callmethod GetFormID nextRecipient ::temp4 ;0 variable args
            callstatic storageUtil IntListAdd ::temp4 ::temp3 trackKey ::temp4 True ;4 variable args
            ; line 1659
            assign currentGiver nextRecipient 
            jmp _label6
            ; line 1661
          _label5:
            cast ::temp3 player 
            callstatic storageUtil IntListClear ::temp4 ::temp3 trackKey ;2 variable args
            ; line 1662
            return None 
            ; line 1664
          _label6:
            iadd ::temp4 s 1 
            assign s ::temp4 
            jmp _label7
            ; line 1666
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
            .local player actor
            .local ::temp0 actor
            .local ::temp1 Bool
            .local exteriorDoor objectReference
            .local ::temp2 objectReference
            .local npcName String
            .local ::temp3 String
            .local playerName String
            .local knockResult String
            .local playerCell cell
            .local ::temp4 cell
            .local ::temp5 Int
            .local ::nonevar None
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
            ; line 1674
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1677
            cmp_eq ::temp1 target player 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            callmethod IsNPCToNPCType self ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label0:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            callstatic intelEngine IsPlayerInOwnHome ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 1678
            callstatic intelEngine GetPlayerHomeExteriorDoor ::temp2 ;0 variable args
            assign exteriorDoor ::temp2 
            ; line 1679
            cast ::temp2 None 
            cmp_eq ::temp1 exteriorDoor ::temp2 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label3
            ; line 1680
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            assign npcName ::temp3 
            ; line 1681
            callmethod GetDisplayName player ::temp3 ;0 variable args
            assign playerName ::temp3 
            ; line 1685
            strcat ::temp3 npcName " is knocking at your door." 
            callstatic skyMessage Show ::temp3 ::temp3 "Let them in" "Send them away" "Ignore" "" "" "" "" "" "" "" False 0.100000001 30.0 ;14 variable args
            assign knockResult ::temp3 
            ; line 1688
            cmp_eq ::temp1 knockResult "Let them in" 
            jmpf ::temp1 _label4
            ; line 1690
            callmethod GetParentCell player ::temp4 ;0 variable args
            assign playerCell ::temp4 
            ; line 1691
            cast ::temp4 None 
            cmp_eq ::temp1 playerCell ::temp4 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label5
            ; line 1692
            callmethod GetFormID playerCell ::temp5 ;0 variable args
            callstatic intelEngine SetHomeDoorAccessForCell ::temp2 ::temp5 True ;2 variable args
            jmp _label5
            ; line 1694
          _label5:
            callmethod MoveTo npc ::nonevar exteriorDoor 0.0 0.0 0.0 False ;5 variable args
            jmp _label6
            ; line 1696
          _label4:
            cmp_eq ::temp1 knockResult "Send them away" 
            jmpf ::temp1 _label7
            ; line 1697
            callmethod MoveTo npc ::nonevar exteriorDoor 0.0 0.0 0.0 False ;5 variable args
            ; line 1698
            strcat ::temp3 "went to visit " playerName 
            strcat ::temp3 ::temp3 " at home but was turned away at the door" 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp3 ;2 variable args
            ; line 1699
            strcat ::temp3 npcName " knocked on " 
            strcat ::temp3 ::temp3 playerName 
            strcat ::temp3 ::temp3 "'s door but was told to go away" 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc player ::temp3 ;3 variable args
            ; line 1700
            assign ::ActiveStoryType_var "" 
            ; line 1701
            return None 
            jmp _label6
            ; line 1703
          _label7:
            callmethod MoveTo npc ::nonevar exteriorDoor 0.0 0.0 0.0 False ;5 variable args
            ; line 1704
            strcat ::temp3 "went to visit " playerName 
            strcat ::temp3 ::temp3 " at home but nobody answered the door" 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp3 ;2 variable args
            ; line 1705
            strcat ::temp3 npcName " knocked on " 
            strcat ::temp3 ::temp3 playerName 
            strcat ::temp3 ::temp3 "'s door but got no answer" 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc player ::temp3 ;3 variable args
            ; line 1706
            assign ::ActiveStoryType_var "" 
            ; line 1707
            return None 
          _label6:
            jmp _label3
          _label3:
            jmp _label2
            ; line 1712
          _label2:
            callmethod FindFreeAgentSlot ::Core_var ::temp5 ;0 variable args
            assign slot ::temp5 
            ; line 1713
            cmp_lt ::temp1 slot 0 
            jmpf ::temp1 _label8
            ; line 1714
            callstatic debug Trace ::nonevar "[IntelEngine] StoryEngine: No free slots for dispatch" 0 ;2 variable args
            ; line 1716
            cmp_eq ::temp1 target player 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label9
            ; line 1717
            strcat ::temp3 ::ActiveStoryType_var ": " 
            callmethod BuildInteractionSummary self ::temp6 npc narration target ;3 variable args
            strcat ::temp6 ::temp3 ::temp6 
            callmethod AddRecentStoryEvent self ::nonevar ::temp6 ;1 variable args
            jmp _label9
            ; line 1720
          _label9:
            assign ::ActiveStoryType_var "" 
            ; line 1721
            return None 
            jmp _label8
            ; line 1725
          _label8:
            callmethod GetDisplayName target ::temp6 ;0 variable args
            assign targetName ::temp6 
            ; line 1726
            cmp_eq ::temp1 target player 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label10
            ; line 1727
            assign ::ActiveSecondNPC_var target 
            jmp _label10
            ; line 1730
          _label10:
            callmethod AllocateSlot ::Core_var ::nonevar slot npc slotTaskType targetName 1 ;5 variable args
            ; line 1732
            assign ::ActiveStoryNPC_var npc 
            ; line 1733
            assign ::ActiveNarration_var narration 
            ; line 1734
            assign ::IsActive_var True 
            ; line 1735
            callstatic utility GetCurrentGameTime ::temp7 ;0 variable args
            callstatic intelEngine MarkSystemPending ::nonevar "storyDM" ::temp7 ;2 variable args
            ; line 1736
            cast ::temp8 npc 
            callstatic storageUtil SetIntValue ::temp5 ::temp8 "Intel_IsStoryDispatch" 1 ;3 variable args
            ; line 1737
            cast ::temp8 npc 
            callstatic storageUtil SetStringValue ::temp6 ::temp8 "Intel_StoryNarration" narration ;3 variable args
            ; line 1739
            callmethod ReapplyTravelPackage self ::nonevar npc ;1 variable args
            ; line 1741
            callmethod InitializeStuckTrackingForSlot ::Core_var ::nonevar slot npc ;2 variable args
            ; line 1742
            cast ::temp2 target 
            callmethod InitOffScreenTracking ::Core_var ::nonevar slot npc ::temp2 ;3 variable args
            ; line 1747
            cmp_eq ::temp1 target player 
            jmpf ::temp1 _label11
            ; line 1748
            assign MAX_STORY_OFFSCREEN_HOURS 0.25 
            ; line 1749
            fdiv ::temp7 MAX_STORY_OFFSCREEN_HOURS 24.0 
            assign maxWait ::temp7 
            ; line 1750
            callstatic utility GetCurrentGameTime ::temp7 ;0 variable args
            assign now ::temp7 
            ; line 1751
            cast ::temp8 npc 
            callstatic storageUtil GetFloatValue ::temp7 ::temp8 "Intel_OffscreenArrival" 0.0 ;3 variable args
            assign estimate ::temp7 
            ; line 1752
            cmp_gt ::temp1 estimate 0.0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label12
            fsub ::temp7 estimate now 
            cmp_gt ::temp1 ::temp7 maxWait 
            assign ::temp1 ::temp1 
          _label12:
            jmpf ::temp1 _label13
            ; line 1753
            fadd ::temp7 now maxWait 
            assign capped ::temp7 
            ; line 1754
            callstatic intelEngine InitOffScreenTravel ::nonevar slot capped npc ;3 variable args
            ; line 1755
            cast ::temp8 npc 
            callstatic storageUtil SetFloatValue ::temp7 ::temp8 "Intel_OffscreenArrival" capped ;3 variable args
            ; line 1756
            callmethod GetDisplayName npc ::temp6 ;0 variable args
            strcat ::temp6 ::temp6 " story off-screen capped to " 
            cast ::temp3 MAX_STORY_OFFSCREEN_HOURS 
            strcat ::temp3 ::temp6 ::temp3 
            strcat ::temp3 ::temp3 "H (was " 
            fsub ::temp7 estimate now 
            fmul ::temp7 ::temp7 24.0 
            cast ::temp6 ::temp7 
            strcat ::temp6 ::temp3 ::temp6 
            strcat ::temp6 ::temp6 "H)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp6 ;1 variable args
            jmp _label13
          _label13:
            jmp _label11
            ; line 1760
          _label11:
            callmethod StopScheduler self ::nonevar ;0 variable args
            ; line 1766
            cast ::temp2 npc 
            cast ::temp9 target 
            cast ::temp10 self 
            callstatic intelEngine ArmProximityArrival ::nonevar slot ::temp2 ::temp9 ::temp10 "IntelEngine_StoryEngine" "OnProximityArrived" ;6 variable args
            ; line 1768
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
            ; line 1776
            not ::temp0 ::IsActive_var 
            jmpf ::temp0 _label0
            ; line 1777
            return None 
            jmp _label0
            ; line 1780
          _label0:
            cast ::temp1 None 
            cmp_eq ::temp0 ::ActiveStoryNPC_var ::temp1 
            jmpf ::temp0 _label1
            ; line 1781
            return None 
            jmp _label1
            ; line 1783
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
            ; line 1792
            cast ::temp0 npc2 
            callmethod SetLookAt npc1 ::nonevar ::temp0 False ;2 variable args
            ; line 1793
            cast ::temp0 npc1 
            callmethod SetLookAt npc2 ::nonevar ::temp0 False ;2 variable args
            ; line 1794
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 1796
            callmethod BuildInteractionSummary self ::temp1 npc1 eventText npc2 ;3 variable args
            assign summary ::temp1 
            ; line 1797
            callmethod SendTaskNarration ::Core_var ::nonevar npc1 summary npc2 ;3 variable args
            ; line 1799
            strcat ::temp1 eventType ": " 
            strcat ::temp1 ::temp1 summary 
            callmethod AddRecentStoryEvent self ::nonevar ::temp1 ;1 variable args
            ; line 1801
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
            ; line 1809
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1810
            callmethod GetParentCell player ::temp1 ;0 variable args
            assign playerCell ::temp1 
            ; line 1813
            cast ::temp1 None 
            cmp_eq ::temp2 playerCell ::temp1 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label0
            callmethod IsInterior playerCell ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
          _label0:
            jmpf ::temp2 _label1
            ; line 1814
            callstatic debug Trace ::nonevar "[IntelEngine] StoryEngine: Skipping road encounter -- player is indoors" 0 ;2 variable args
            ; line 1815
            return None 
            jmp _label1
            ; line 1819
          _label1:
            callstatic utility RandomFloat ::temp3 3000.0 5000.0 ;2 variable args
            assign placeDist ::temp3 
            ; line 1820
            cast ::temp4 player 
            fneg ::temp3 placeDist 
            callstatic intelEngine GetOffsetBehind ::temp5 ::temp4 ::temp3 ;2 variable args
            assign offset ::temp5 
            ; line 1821
            cast ::temp4 player 
            array_getlement ::temp3 offset 0 
            array_getlement ::temp6 offset 1 
            callmethod MoveTo npc ::nonevar ::temp4 ::temp3 ::temp6 0.0 False ;5 variable args
            ; line 1824
            callmethod GetDisplayName npc ::temp7 ;0 variable args
            strcat ::temp7 ::temp7 " " 
            strcat ::temp7 ::temp7 narration 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc npc ::temp7 ;3 variable args
            ; line 1827
            cast ::temp4 None 
            assign destMarker ::temp4 
            ; line 1828
            cmp_eq ::temp2 destination "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label2
            ; line 1829
            callstatic intelEngine ResolveAnyDestination ::temp4 npc destination ;2 variable args
            assign destMarker ::temp4 
            jmp _label2
            ; line 1833
          _label2:
            callmethod RemoveAllPackages ::Core_var ::nonevar npc False ;2 variable args
            ; line 1835
            cast ::temp4 None 
            cmp_eq ::temp2 destMarker ::temp4 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label3
            ; line 1837
            cast ::temp8 npc 
            cast ::temp9 destMarker 
            callstatic storageUtil SetFormValue ::temp9 ::temp8 "Intel_FakeEncounterDest" ::temp9 ;3 variable args
            ; line 1838
            cast ::temp4 npc 
            propget IntelEngine_TravelTarget ::Core_var ::temp10 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp4 destMarker ::temp10 ;3 variable args
            ; line 1839
            propget TravelPackage_Walk ::Core_var ::temp11 
            propget PRIORITY_TRAVEL ::Core_var ::temp12 
            callstatic actorUtil AddPackageOverride ::nonevar npc ::temp11 ::temp12 1 ;4 variable args
            ; line 1840
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 1841
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 1842
            callmethod GetDisplayName npc ::temp7 ;0 variable args
            strcat ::temp7 "Story: road encounter " ::temp7 
            strcat ::temp7 ::temp7 " traveling to " 
            strcat ::temp7 ::temp7 destination 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            jmp _label4
            ; line 1845
          _label3:
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 1846
            callmethod GetDisplayName npc ::temp7 ;0 variable args
            strcat ::temp7 "Story: road encounter " ::temp7 
            strcat ::temp7 ::temp7 " (no destination resolved)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            ; line 1850
          _label4:
            cast ::temp9 npc 
            callstatic storageUtil SetStringValue ::temp7 ::temp9 "Intel_FakeEncounterNarration" narration ;3 variable args
            ; line 1853
            cast ::temp9 npc 
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp6 ::temp9 "Intel_FakeEncounterTime" ::temp6 ;3 variable args
            ; line 1854
            callmethod GetFormID npc ::temp12 ;0 variable args
            assign npcFormId ::temp12 
            ; line 1855
            cast ::temp9 player 
            callstatic storageUtil IntListFind ::temp12 ::temp9 "Intel_FakeEncounterNPCs" npcFormId ;3 variable args
            cmp_lt ::temp2 ::temp12 0 
            jmpf ::temp2 _label5
            ; line 1856
            cast ::temp9 player 
            callstatic storageUtil IntListAdd ::temp12 ::temp9 "Intel_FakeEncounterNPCs" npcFormId True ;4 variable args
            jmp _label5
            ; line 1859
          _label5:
            callmethod GetDisplayName npc ::temp7 ;0 variable args
            strcat ::temp7 "road_encounter: " ::temp7 
            strcat ::temp7 ::temp7 " -- " 
            strcat ::temp7 ::temp7 narration 
            callmethod AddRecentStoryEvent self ::nonevar ::temp7 ;1 variable args
            ; line 1862
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
            ; line 1868
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1869
            cast ::temp1 player 
            callstatic storageUtil IntListCount ::temp2 ::temp1 "Intel_FakeEncounterNPCs" ;2 variable args
            assign count ::temp2 
            ; line 1870
            cmp_eq ::temp3 count 0 
            jmpf ::temp3 _label0
            ; line 1871
            return None 
            jmp _label0
            ; line 1874
          _label0:
            isub ::temp2 count 1 
            assign i ::temp2 
            ; line 1875
          _label22:
            comp_gte ::temp3 i 0 
            jmpf ::temp3 _label1
            ; line 1876
            cast ::temp1 player 
            callstatic storageUtil IntListGet ::temp2 ::temp1 "Intel_FakeEncounterNPCs" i ;3 variable args
            assign formId ::temp2 
            ; line 1877
            callstatic game GetForm ::temp1 formId ;1 variable args
            cast ::temp0 ::temp1 
            assign npc ::temp0 
            ; line 1879
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
            ; line 1881
            cast ::temp1 player 
            callstatic storageUtil IntListRemoveAt ::temp3 ::temp1 "Intel_FakeEncounterNPCs" i ;3 variable args
            ; line 1882
            isub ::temp2 i 1 
            assign i ::temp2 
            jmp _label5
            ; line 1885
          _label4:
            cast ::temp1 npc 
            cast ::temp4 None 
            callstatic storageUtil GetFormValue ::temp4 ::temp1 "Intel_FakeEncounterDest" ::temp4 ;3 variable args
            cast ::temp5 ::temp4 
            assign destMarker ::temp5 
            ; line 1886
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
            ; line 1887
            callmethod GetDistance npc ::temp6 destMarker ;1 variable args
            propget ARRIVAL_DISTANCE ::Core_var ::temp7 
            cmp_lte ::temp3 ::temp6 ::temp7 
            jmpf ::temp3 _label9
            ; line 1888
            callmethod CleanupRoadEncounterTravel self ::nonevar npc ;1 variable args
            jmp _label9
          _label9:
            jmp _label8
            ; line 1893
          _label8:
            cast ::temp4 npc 
            callstatic storageUtil GetIntValue ::temp2 ::temp4 "Intel_FakeEncounterInteracted" 0 ;3 variable args
            assign encounterPhase ::temp2 
            ; line 1894
            cmp_eq ::temp3 encounterPhase 0 
            jmpf ::temp3 _label10
            ; line 1895
            callmethod Is3DLoaded npc ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label11
            callmethod Is3DLoaded player ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label11:
            jmpf ::temp3 _label12
            ; line 1896
            cast ::temp5 player 
            callmethod GetDistance npc ::temp7 ::temp5 ;1 variable args
            assign dist ::temp7 
            ; line 1897
            propget ENCOUNTER_PROXIMITY self ::temp7 
            cmp_lte ::temp3 dist ::temp7 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label13
            cmp_gt ::temp3 dist 0.0 
            assign ::temp3 ::temp3 
          _label13:
            jmpf ::temp3 _label14
            ; line 1898
            callmethod TriggerRoadEncounterGreeting self ::nonevar npc ;1 variable args
            jmp _label14
          _label14:
            jmp _label12
          _label12:
            jmp _label15
            ; line 1901
          _label10:
            cmp_eq ::temp3 encounterPhase 1 
            jmpf ::temp3 _label15
            ; line 1903
            cast ::temp5 player 
            callmethod GetDistance npc ::temp7 ::temp5 ;1 variable args
            assign ::mangled_dist_0 ::temp7 
            ; line 1904
            cast ::temp4 npc 
            callstatic storageUtil GetFloatValue ::temp7 ::temp4 "Intel_FakeEncounterGreetTime" 0.0 ;3 variable args
            assign greetTime ::temp7 
            ; line 1905
            callstatic utility GetCurrentRealTime ::temp7 ;0 variable args
            fsub ::temp7 ::temp7 greetTime 
            assign elapsed ::temp7 
            ; line 1906
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
            ; line 1907
            jmpf shouldResume _label19
            ; line 1909
            propget SandboxNearPlayerPackage ::Core_var ::temp8 
            callstatic actorUtil RemovePackageOverride ::temp3 npc ::temp8 ;2 variable args
            ; line 1910
            cast ::temp4 npc 
            cast ::temp1 None 
            callstatic storageUtil GetFormValue ::temp1 ::temp4 "Intel_FakeEncounterDest" ::temp1 ;3 variable args
            cast ::temp5 ::temp1 
            assign destMarker ::temp5 
            ; line 1911
            cast ::temp5 None 
            cmp_eq ::temp3 destMarker ::temp5 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label20
            ; line 1912
            cast ::temp5 npc 
            propget IntelEngine_TravelTarget ::Core_var ::temp9 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp5 destMarker ::temp9 ;3 variable args
            ; line 1913
            propget TravelPackage_Walk ::Core_var ::temp8 
            propget PRIORITY_TRAVEL ::Core_var ::temp2 
            callstatic actorUtil AddPackageOverride ::nonevar npc ::temp8 ::temp2 1 ;4 variable args
            jmp _label21
            ; line 1915
          _label20:
            cast ::temp5 npc 
            cast ::temp10 None 
            propget IntelEngine_TravelTarget ::Core_var ::temp9 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp5 ::temp10 ::temp9 ;3 variable args
            ; line 1917
          _label21:
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 1918
            cast ::temp1 npc 
            callstatic storageUtil SetIntValue ::temp2 ::temp1 "Intel_FakeEncounterInteracted" 2 ;3 variable args
            ; line 1919
            cast ::temp1 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp1 "Intel_FakeEncounterGreetTime" ;2 variable args
            ; line 1920
            callmethod GetDisplayName npc ::temp11 ;0 variable args
            strcat ::temp11 "Story [encounter]: " ::temp11 
            strcat ::temp11 ::temp11 " resuming travel" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp11 ;1 variable args
            jmp _label19
          _label19:
            jmp _label15
            ; line 1924
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
            ; line 1937
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1938
            cast ::temp1 player 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "Intel_StoryLingerActors" ;2 variable args
            cmp_gt ::temp3 ::temp2 0 
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label0
            ; line 1939
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
            ; line 1943
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1944
            cast ::temp1 player 
            cast ::temp2 npc 
            callstatic storageUtil FormListFind ::temp3 ::temp1 "Intel_StoryLingerActors" ::temp2 ;3 variable args
            cmp_lt ::temp4 ::temp3 0 
            jmpf ::temp4 _label0
            ; line 1945
            cast ::temp2 player 
            cast ::temp1 npc 
            callstatic storageUtil FormListAdd ::temp3 ::temp2 "Intel_StoryLingerActors" ::temp1 True ;4 variable args
            jmp _label0
            ; line 1947
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
            ; line 1953
            callmethod FindSlotByAgent ::Core_var ::temp0 arrivedNPC ;1 variable args
            assign slot ::temp0 
            ; line 1954
            comp_gte ::temp1 slot 0 
            jmpf ::temp1 _label0
            ; line 1955
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label0
            ; line 1957
          _label0:
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 1963
            cast ::temp2 arrivedNPC 
            assign sandboxRef ::temp2 
            ; line 1964
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
            ; line 1965
            assign sandboxRef lingerTarget 
            jmp _label2
            ; line 1967
          _label2:
            cast ::temp2 arrivedNPC 
            propget IntelEngine_TravelTarget ::Core_var ::temp4 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp2 sandboxRef ::temp4 ;3 variable args
            ; line 1968
            propget SandboxNearPlayerPackage ::Core_var ::temp5 
            propget PRIORITY_SANDBOX ::Core_var ::temp0 
            callstatic actorUtil AddPackageOverride ::nonevar arrivedNPC ::temp5 ::temp0 1 ;4 variable args
            ; line 1969
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 1970
            callmethod EvaluatePackage arrivedNPC ::nonevar ;0 variable args
            ; line 1972
            callmethod EnsureBuildingAccess ::Core_var ::nonevar arrivedNPC ;1 variable args
            ; line 1973
            callmethod StartStoryLinger self ::nonevar arrivedNPC ;1 variable args
            ; line 1976
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
            ; line 1983
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1984
            cast ::temp1 player 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "Intel_StoryLingerActors" ;2 variable args
            assign count ::temp2 
            ; line 1985
            cmp_eq ::temp3 count 0 
            jmpf ::temp3 _label0
            ; line 1986
            return None 
            jmp _label0
            ; line 1989
          _label0:
            isub ::temp2 count 1 
            assign i ::temp2 
            ; line 1990
          _label17:
            comp_gte ::temp3 i 0 
            jmpf ::temp3 _label1
            ; line 1991
            cast ::temp1 player 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "Intel_StoryLingerActors" i ;3 variable args
            cast ::temp0 ::temp1 
            assign npc ::temp0 
            ; line 1993
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
            ; line 1996
            cast ::temp0 None 
            cmp_eq ::temp3 npc ::temp0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label5
            ; line 1997
            cast ::temp1 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp1 "Intel_RescueNarration" ;2 variable args
            jmp _label5
            ; line 1999
          _label5:
            cast ::temp1 player 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_StoryLingerActors" i ;3 variable args
            jmp _label6
            ; line 2003
          _label4:
            cast ::temp1 npc 
            callstatic storageUtil GetIntValue ::temp2 ::temp1 "Intel_MeetingLingerApproaching" 0 ;3 variable args
            cmp_eq ::temp3 ::temp2 1 
            jmpf ::temp3 _label7
            ; line 2004
            assign closeEnough False 
            ; line 2005
            callmethod Is3DLoaded npc ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label8
            callmethod Is3DLoaded player ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label8:
            jmpf ::temp3 _label9
            ; line 2006
            cast ::temp4 player 
            callmethod GetDistance npc ::temp5 ::temp4 ;1 variable args
            propget LINGER_APPROACH_DISTANCE ::Core_var ::temp6 
            cmp_lte ::temp3 ::temp5 ::temp6 
            assign closeEnough ::temp3 
            jmp _label10
            ; line 2007
          _label9:
            callmethod GetParentCell npc ::temp7 ;0 variable args
            callmethod GetParentCell player ::temp8 ;0 variable args
            cmp_eq ::temp3 ::temp7 ::temp8 
            jmpf ::temp3 _label10
            ; line 2008
            assign closeEnough True 
            jmp _label10
            ; line 2010
          _label10:
            jmpf closeEnough _label11
            ; line 2012
            propget SandboxNearPlayerPackage ::Core_var ::temp9 
            propget PRIORITY_TRAVEL ::Core_var ::temp2 
            callstatic actorUtil AddPackageOverride ::nonevar npc ::temp9 ::temp2 1 ;4 variable args
            ; line 2013
            propget TravelPackage_Walk ::Core_var ::temp9 
            callstatic actorUtil RemovePackageOverride ::temp3 npc ::temp9 ;2 variable args
            ; line 2014
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 2015
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 2016
            cast ::temp1 npc 
            callstatic storageUtil UnsetIntValue ::temp3 ::temp1 "Intel_MeetingLingerApproaching" ;2 variable args
            ; line 2017
            callmethod GetDisplayName npc ::temp10 ;0 variable args
            strcat ::temp10 "Story [quest/rescue]: " ::temp10 
            strcat ::temp10 ::temp10 " reached player, sandboxing" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            jmp _label11
          _label11:
            jmp _label7
            ; line 2022
          _label7:
            cast ::temp1 npc 
            callstatic storageUtil GetStringValue ::temp10 ::temp1 "Intel_RescueNarration" "" ;3 variable args
            assign pendingNarration ::temp10 
            ; line 2023
            cmp_eq ::temp3 pendingNarration "" 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label12
            ; line 2024
            cast ::temp4 npc 
            cast ::temp11 player 
            callstatic intelEngine GetDistance3D ::temp6 ::temp4 ::temp11 ;2 variable args
            assign dist ::temp6 
            ; line 2025
            cmp_lt ::temp3 dist 400.0 
            jmpf ::temp3 _label13
            ; line 2026
            cast ::temp11 player 
            callmethod SetLookAt npc ::nonevar ::temp11 False ;2 variable args
            ; line 2027
            callmethod SendTaskNarration ::Core_var ::nonevar npc pendingNarration player ;3 variable args
            ; line 2028
            cast ::temp1 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp1 "Intel_RescueNarration" ;2 variable args
            ; line 2029
            callmethod GetDisplayName npc ::temp10 ;0 variable args
            strcat ::temp10 "Story [quest/rescue]: " ::temp10 
            strcat ::temp10 ::temp10 " reached player, narrating" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            jmp _label13
          _label13:
            jmp _label12
            ; line 2034
          _label12:
            cast ::temp1 npc 
            callstatic storageUtil GetFloatValue ::temp6 ::temp1 "Intel_StoryLingerStart" 0.0 ;3 variable args
            assign lingerStart ::temp6 
            ; line 2035
            callstatic utility GetCurrentRealTime ::temp6 ;0 variable args
            fsub ::temp6 ::temp6 lingerStart 
            assign elapsed ::temp6 
            ; line 2036
            cmp_gt ::temp3 lingerStart 0.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label14
            propget LINGER_TIMEOUT_SECONDS self ::temp6 
            cmp_gt ::temp3 elapsed ::temp6 
            assign ::temp3 ::temp3 
          _label14:
            assign timedOut ::temp3 
            ; line 2039
            cmp_gt ::temp3 elapsed 30.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label15
            callmethod ShouldReleaseLinger ::Core_var ::temp3 npc ;1 variable args
            assign ::temp3 ::temp3 
          _label15:
            assign shouldRelease ::temp3 
            ; line 2041
            assign ::temp3 timedOut 
            jmpt ::temp3 _label16
            assign ::temp3 shouldRelease 
          _label16:
            jmpf ::temp3 _label6
            ; line 2043
            cast ::temp1 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp1 "Intel_RescueNarration" ;2 variable args
            ; line 2047
            callmethod ReleaseLinger ::Core_var ::nonevar npc ;1 variable args
            ; line 2048
            cast ::temp1 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp1 "Intel_StoryLingerStart" ;2 variable args
            ; line 2049
            cast ::temp1 player 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_StoryLingerActors" i ;3 variable args
            jmp _label6
            ; line 2052
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
            ; line 2060
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 2061
            cast ::temp1 player 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "Intel_RecentlyRescuedNPCs" ;2 variable args
            assign count ::temp2 
            ; line 2062
            cmp_eq ::temp3 count 0 
            jmpf ::temp3 _label0
            ; line 2063
            return None 
            jmp _label0
            ; line 2066
          _label0:
            isub ::temp2 count 1 
            assign i ::temp2 
            ; line 2067
          _label19:
            comp_gte ::temp3 i 0 
            jmpf ::temp3 _label1
            ; line 2068
            cast ::temp1 player 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "Intel_RecentlyRescuedNPCs" i ;3 variable args
            cast ::temp0 ::temp1 
            assign npc ::temp0 
            ; line 2069
            cast ::temp0 None 
            cmp_eq ::temp3 npc ::temp0 
            assign ::temp3 ::temp3 
            jmpt ::temp3 _label2
            callmethod IsDisabled npc ::temp3 ;0 variable args
            assign ::temp3 ::temp3 
          _label2:
            jmpf ::temp3 _label3
            ; line 2071
            cast ::temp0 None 
            cmp_eq ::temp3 npc ::temp0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label4
            ; line 2072
            cast ::temp1 npc 
            callstatic storageUtil UnsetFormValue ::temp3 ::temp1 "Intel_RescueQuestGiver" ;2 variable args
            ; line 2073
            cast ::temp1 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp1 "Intel_RescuePlayerName" ;2 variable args
            ; line 2074
            cast ::temp1 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp1 "Intel_RescueTime" ;2 variable args
            jmp _label4
            ; line 2076
          _label4:
            cast ::temp1 player 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp1 "Intel_RecentlyRescuedNPCs" i ;3 variable args
            jmp _label5
            ; line 2077
          _label3:
            callmethod IsDead npc ::temp3 ;0 variable args
            jmpf ::temp3 _label6
            ; line 2078
            cast ::temp1 npc 
            cast ::temp4 None 
            callstatic storageUtil GetFormValue ::temp4 ::temp1 "Intel_RescueQuestGiver" ::temp4 ;3 variable args
            cast ::temp0 ::temp4 
            assign rescueGiver ::temp0 
            ; line 2079
            cast ::temp0 None 
            cmp_eq ::temp3 rescueGiver ::temp0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label7
            ; line 2080
            callmethod GetDisplayName npc ::temp5 ;0 variable args
            assign victimName ::temp5 
            ; line 2081
            callmethod GetKiller npc ::temp0 ;0 variable args
            assign killer ::temp0 
            ; line 2083
            cmp_eq ::temp3 killer player 
            jmpf ::temp3 _label8
            ; line 2085
            assign hasWitness False 
            ; line 2086
            cast ::temp6 npc 
            cast ::temp7 None 
            callstatic miscUtil ScanCellNPCs ::temp8 ::temp6 3000.0 ::temp7 True ;4 variable args
            assign nearbyNPCs ::temp8 
            ; line 2087
            assign j 0 
            ; line 2088
          _label13:
            array_length ::temp2 nearbyNPCs 
            cmp_lt ::temp3 j ::temp2 
            jmpf ::temp3 _label9
            ; line 2089
            array_getlement ::temp0 nearbyNPCs j 
            assign witness ::temp0 
            ; line 2090
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
            ; line 2091
            assign hasWitness True 
            ; line 2092
            array_length ::temp2 nearbyNPCs 
            assign j ::temp2 
            jmp _label12
            ; line 2094
          _label12:
            iadd ::temp2 j 1 
            assign j ::temp2 
            jmp _label13
            ; line 2097
          _label9:
            jmpf hasWitness _label14
            ; line 2099
            cast ::temp4 npc 
            callstatic storageUtil GetStringValue ::temp5 ::temp4 "Intel_RescuePlayerName" "the rescuer" ;3 variable args
            assign rPlayerName ::temp5 
            ; line 2100
            strcat ::temp5 "learned that " victimName 
            strcat ::temp5 ::temp5 " was killed by " 
            strcat ::temp5 ::temp5 rPlayerName 
            strcat ::temp5 ::temp5 " shortly after being rescued" 
            callmethod InjectFact ::Core_var ::nonevar rescueGiver ::temp5 ;2 variable args
            jmp _label15
            ; line 2103
          _label14:
            strcat ::temp5 "heard that " victimName 
            strcat ::temp5 ::temp5 " died under suspicious circumstances shortly after being rescued" 
            callmethod InjectFact ::Core_var ::nonevar rescueGiver ::temp5 ;2 variable args
          _label15:
            jmp _label16
            ; line 2105
          _label8:
            cast ::temp0 None 
            cmp_eq ::temp3 killer ::temp0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label17
            ; line 2107
            callmethod GetDisplayName killer ::temp5 ;0 variable args
            assign killerName ::temp5 
            ; line 2108
            strcat ::temp5 "learned that " victimName 
            strcat ::temp5 ::temp5 " was killed by " 
            strcat ::temp5 ::temp5 killerName 
            strcat ::temp5 ::temp5 " shortly after being rescued" 
            callmethod InjectFact ::Core_var ::nonevar rescueGiver ::temp5 ;2 variable args
            jmp _label16
            ; line 2111
          _label17:
            strcat ::temp5 "learned that " victimName 
            strcat ::temp5 ::temp5 " died shortly after being rescued" 
            callmethod InjectFact ::Core_var ::nonevar rescueGiver ::temp5 ;2 variable args
            ; line 2113
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
            ; line 2116
          _label7:
            cast ::temp4 npc 
            callstatic storageUtil UnsetFormValue ::temp3 ::temp4 "Intel_RescueQuestGiver" ;2 variable args
            ; line 2117
            cast ::temp4 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp4 "Intel_RescuePlayerName" ;2 variable args
            ; line 2118
            cast ::temp4 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp4 "Intel_RescueTime" ;2 variable args
            ; line 2119
            cast ::temp4 player 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp4 "Intel_RecentlyRescuedNPCs" i ;3 variable args
            jmp _label5
            ; line 2122
          _label6:
            cast ::temp4 npc 
            callstatic storageUtil GetFloatValue ::temp10 ::temp4 "Intel_RescueTime" 0.0 ;3 variable args
            assign rescueTime ::temp10 
            ; line 2123
            cmp_gt ::temp3 rescueTime 0.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label18
            callstatic utility GetCurrentGameTime ::temp10 ;0 variable args
            fsub ::temp10 ::temp10 rescueTime 
            cmp_gt ::temp3 ::temp10 1.0 
            assign ::temp3 ::temp3 
          _label18:
            jmpf ::temp3 _label5
            ; line 2124
            cast ::temp4 npc 
            callstatic storageUtil UnsetFormValue ::temp3 ::temp4 "Intel_RescueQuestGiver" ;2 variable args
            ; line 2125
            cast ::temp4 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp4 "Intel_RescuePlayerName" ;2 variable args
            ; line 2126
            cast ::temp4 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp4 "Intel_RescueTime" ;2 variable args
            ; line 2127
            cast ::temp4 player 
            callstatic storageUtil FormListRemoveAt ::temp3 ::temp4 "Intel_RecentlyRescuedNPCs" i ;3 variable args
            jmp _label5
            ; line 2130
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
            ; line 2138
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 2139
            cast ::temp1 npc 
            callstatic storageUtil GetStringValue ::temp2 ::temp1 "Intel_FakeEncounterNarration" "" ;3 variable args
            assign narration ::temp2 
            ; line 2142
            propget TravelPackage_Walk ::Core_var ::temp3 
            callstatic actorUtil RemovePackageOverride ::temp4 npc ::temp3 ;2 variable args
            ; line 2143
            cast ::temp5 npc 
            cast ::temp6 player 
            propget IntelEngine_TravelTarget ::Core_var ::temp7 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp5 ::temp6 ::temp7 ;3 variable args
            ; line 2144
            propget SandboxNearPlayerPackage ::Core_var ::temp3 
            propget PRIORITY_SANDBOX ::Core_var ::temp8 
            callstatic actorUtil AddPackageOverride ::nonevar npc ::temp3 ::temp8 1 ;4 variable args
            ; line 2145
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 2148
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 2149
            cast ::temp6 player 
            callmethod SetLookAt npc ::nonevar ::temp6 False ;2 variable args
            ; line 2150
            callmethod SendTaskNarration ::Core_var ::nonevar npc narration player ;3 variable args
            ; line 2153
            cast ::temp1 npc 
            callstatic storageUtil SetIntValue ::temp8 ::temp1 "Intel_FakeEncounterInteracted" 1 ;3 variable args
            ; line 2154
            cast ::temp1 npc 
            callstatic utility GetCurrentRealTime ::temp9 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp9 ::temp1 "Intel_FakeEncounterGreetTime" ::temp9 ;3 variable args
            ; line 2156
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
            ; line 2161
            propget TravelPackage_Walk ::Core_var ::temp0 
            callstatic actorUtil RemovePackageOverride ::temp1 npc ::temp0 ;2 variable args
            ; line 2162
            propget SandboxNearPlayerPackage ::Core_var ::temp0 
            callstatic actorUtil RemovePackageOverride ::temp1 npc ::temp0 ;2 variable args
            ; line 2163
            cast ::temp2 npc 
            cast ::temp3 None 
            propget IntelEngine_TravelTarget ::Core_var ::temp4 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp2 ::temp3 ::temp4 ;3 variable args
            ; line 2164
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
            ; line 2169
            callmethod ClearRoadEncounterTravelState self ::nonevar npc ;1 variable args
            ; line 2170
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 2171
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
            ; line 2177
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 2178
            cast ::temp1 player 
            callstatic storageUtil IntListCount ::temp2 ::temp1 "Intel_FakeEncounterNPCs" ;2 variable args
            assign count ::temp2 
            ; line 2179
            cmp_eq ::temp3 count 0 
            jmpf ::temp3 _label0
            ; line 2180
            return None 
            jmp _label0
            ; line 2182
          _label0:
            callstatic utility GetCurrentGameTime ::temp4 ;0 variable args
            assign currentTime ::temp4 
            ; line 2184
            isub ::temp2 count 1 
            assign i ::temp2 
            ; line 2185
          _label6:
            comp_gte ::temp3 i 0 
            jmpf ::temp3 _label1
            ; line 2186
            cast ::temp1 player 
            callstatic storageUtil IntListGet ::temp2 ::temp1 "Intel_FakeEncounterNPCs" i ;3 variable args
            assign formId ::temp2 
            ; line 2187
            callstatic game GetForm ::temp1 formId ;1 variable args
            cast ::temp0 ::temp1 
            assign npc ::temp0 
            ; line 2188
            cast ::temp0 None 
            cmp_eq ::temp3 npc ::temp0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label2
            ; line 2189
            cast ::temp1 npc 
            callstatic storageUtil GetFloatValue ::temp4 ::temp1 "Intel_FakeEncounterTime" 0.0 ;3 variable args
            assign encounterTime ::temp4 
            ; line 2190
            cmp_gt ::temp3 encounterTime 0.0 
            assign ::temp3 ::temp3 
            jmpf ::temp3 _label3
            fsub ::temp4 currentTime encounterTime 
            cmp_gt ::temp3 ::temp4 1.0 
            assign ::temp3 ::temp3 
          _label3:
            jmpf ::temp3 _label4
            ; line 2192
            callmethod RemoveAllPackages ::Core_var ::nonevar npc False ;2 variable args
            ; line 2193
            callmethod ClearRoadEncounterTravelState self ::nonevar npc ;1 variable args
            ; line 2194
            cast ::temp1 npc 
            callstatic storageUtil UnsetStringValue ::temp3 ::temp1 "Intel_FakeEncounterNarration" ;2 variable args
            ; line 2195
            cast ::temp1 npc 
            callstatic storageUtil UnsetIntValue ::temp3 ::temp1 "Intel_FakeEncounterInteracted" ;2 variable args
            ; line 2196
            cast ::temp1 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp1 "Intel_FakeEncounterGreetTime" ;2 variable args
            ; line 2197
            callmethod MoveToMyEditorLocation npc ::nonevar ;0 variable args
            ; line 2198
            cast ::temp1 npc 
            callstatic storageUtil UnsetFloatValue ::temp3 ::temp1 "Intel_FakeEncounterTime" ;2 variable args
            ; line 2199
            cast ::temp1 player 
            callstatic storageUtil IntListRemoveAt ::temp3 ::temp1 "Intel_FakeEncounterNPCs" i ;3 variable args
            ; line 2200
            callmethod GetDisplayName npc ::temp5 ;0 variable args
            strcat ::temp5 "[IntelEngine] StoryEngine: Returned road encounter NPC " ::temp5 
            callstatic debug Trace ::nonevar ::temp5 0 ;2 variable args
            jmp _label4
          _label4:
            jmp _label5
            ; line 2204
          _label2:
            cast ::temp1 player 
            callstatic storageUtil IntListRemoveAt ::temp3 ::temp1 "Intel_FakeEncounterNPCs" i ;3 variable args
            ; line 2206
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
            ; line 2215
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
            ; line 2216
            cast ::temp0 None 
            cmp_eq ::temp1 ::ActiveStoryNPC_var ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label3
            ; line 2217
            callmethod FindSlotByAgent ::Core_var ::temp2 ::ActiveStoryNPC_var ;1 variable args
            assign deadSlot ::temp2 
            ; line 2218
            comp_gte ::temp1 deadSlot 0 
            jmpf ::temp1 _label4
            ; line 2219
            callmethod ClearSlot ::Core_var ::nonevar deadSlot True False ;3 variable args
            jmp _label4
            ; line 2221
          _label4:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            jmp _label3
            ; line 2223
          _label3:
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 2224
            return None 
            jmp _label2
            ; line 2230
          _label2:
            cmp_eq ::temp1 ::ActiveStoryType_var "" 
            jmpf ::temp1 _label5
            ; line 2231
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story: corrupt state detected (IsActive but no type) for " ::temp3 
            strcat ::temp3 ::temp3 " - cleaning up" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2232
            callmethod FindSlotByAgent ::Core_var ::temp2 ::ActiveStoryNPC_var ;1 variable args
            assign corruptSlot ::temp2 
            ; line 2233
            comp_gte ::temp1 corruptSlot 0 
            jmpf ::temp1 _label6
            ; line 2234
            callmethod ClearSlot ::Core_var ::nonevar corruptSlot True False ;3 variable args
            jmp _label6
            ; line 2236
          _label6:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 2237
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 2238
            return None 
            jmp _label5
            ; line 2243
          _label5:
            callmethod FindSlotByAgent ::Core_var ::temp2 ::ActiveStoryNPC_var ;1 variable args
            assign activeSlot ::temp2 
            ; line 2244
            cmp_lt ::temp1 activeSlot 0 
            jmpf ::temp1 _label7
            ; line 2245
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story: orphaned dispatch detected for " ::temp3 
            strcat ::temp3 ::temp3 " [" 
            strcat ::temp3 ::temp3 ::ActiveStoryType_var 
            strcat ::temp3 ::temp3 "] - cleaning up" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2246
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 2247
            return None 
            jmp _label7
            ; line 2250
          _label7:
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 2253
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush_combat" 
            jmpf ::temp1 _label8
            ; line 2254
            callmethod CheckAmbushCombat self ::nonevar ;0 variable args
            ; line 2255
            return None 
            jmp _label8
            ; line 2259
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
            ; line 2261
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp5 ::temp4 "Intel_SneakStartTime" 0.0 ;3 variable args
            assign sneakStart ::temp5 
            ; line 2262
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
            ; line 2263
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
            ; line 2264
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story: " ::temp3 
            strcat ::temp3 ::temp3 " gave up" 
            callmethod NotifyPlayer ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2265
            callmethod IsSneaking ::ActiveStoryNPC_var ::temp1 ;0 variable args
            jmpf ::temp1 _label15
            ; line 2266
            callmethod StartSneaking ::ActiveStoryNPC_var ::nonevar ;0 variable args
            jmp _label15
            ; line 2268
          _label15:
            cast ::temp8 ::ActiveStoryNPC_var 
            callstatic debug SendAnimationEvent ::nonevar ::temp8 "sneakStop" ;2 variable args
            ; line 2269
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp4 "Intel_SneakStartTime" ;2 variable args
            ; line 2270
            callmethod FindSlotByAgent ::Core_var ::temp2 ::ActiveStoryNPC_var ;1 variable args
            assign slot ::temp2 
            ; line 2271
            comp_gte ::temp1 slot 0 
            jmpf ::temp1 _label16
            ; line 2272
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label16
            ; line 2274
          _label16:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 2275
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 2276
            return None 
            jmp _label14
            ; line 2279
          _label14:
            cast ::temp8 player 
            callmethod GetDistance ::ActiveStoryNPC_var ::temp6 ::temp8 ;1 variable args
            assign sneakDist ::temp6 
            ; line 2280
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil GetIntValue ::temp2 ::temp4 "Intel_SneakPhase" 0 ;3 variable args
            assign sneakPhase ::temp2 
            ; line 2283
            cmp_eq ::temp1 ::ActiveStoryType_var "stalker" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label17
            cmp_eq ::temp1 sneakPhase 0 
            assign ::temp1 ::temp1 
          _label17:
            jmpf ::temp1 _label18
            ; line 2284
            callmethod ReapplyTravelPackage self ::nonevar ::ActiveStoryNPC_var ;1 variable args
            ; line 2285
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil SetIntValue ::temp2 ::temp4 "Intel_SneakPhase" 1 ;3 variable args
            ; line 2286
            assign sneakPhase 1 
            ; line 2287
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story [stalker]: " ::temp3 
            strcat ::temp3 ::temp3 " sneak package applied at " 
            cast ::temp7 sneakDist 
            strcat ::temp7 ::temp3 ::temp7 
            strcat ::temp7 ::temp7 "u" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            jmp _label18
            ; line 2291
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
            ; line 2292
            propget AMBUSH_CONFRONT_DISTANCE self ::temp6 
            cmp_gt ::temp1 sneakDist ::temp6 
            jmpf ::temp1 _label22
            ; line 2293
            callmethod StartSneaking ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 2294
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil SetIntValue ::temp2 ::temp4 "Intel_SneakPhase" 1 ;3 variable args
            ; line 2295
            assign sneakPhase 1 
            ; line 2296
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp7 ;0 variable args
            strcat ::temp7 "Story [ambush]: " ::temp7 
            strcat ::temp7 ::temp7 " entered sneak at " 
            cast ::temp3 sneakDist 
            strcat ::temp3 ::temp7 ::temp3 
            strcat ::temp3 ::temp3 "u" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label23
            ; line 2299
          _label22:
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story [ambush]: " ::temp3 
            strcat ::temp3 ::temp3 " overshot sneak at " 
            cast ::temp7 sneakDist 
            strcat ::temp7 ::temp3 ::temp7 
            strcat ::temp7 ::temp7 "u" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            ; line 2300
            callmethod OnAmbushConfront self ::nonevar ;0 variable args
            ; line 2301
            return None 
          _label23:
            jmp _label21
            ; line 2306
          _label21:
            comp_gte ::temp1 sneakPhase 1 
            jmpf ::temp1 _label24
            ; line 2307
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush" 
            jmpf ::temp1 _label25
            ; line 2309
            propget AMBUSH_CONFRONT_DISTANCE self ::temp6 
            cmp_lte ::temp1 sneakDist ::temp6 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label26
            cmp_gt ::temp1 sneakDist 0.0 
            assign ::temp1 ::temp1 
          _label26:
            jmpf ::temp1 _label27
            ; line 2310
            callmethod OnAmbushConfront self ::nonevar ;0 variable args
            ; line 2311
            return None 
            jmp _label27
            ; line 2313
          _label27:
            callmethod IsDetectedBy ::ActiveStoryNPC_var ::temp1 player ;1 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label28
            cmp_lte ::temp1 sneakDist 400.0 
            assign ::temp1 ::temp1 
          _label28:
            jmpf ::temp1 _label29
            ; line 2314
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp7 ;0 variable args
            strcat ::temp7 "Story [ambush]: " ::temp7 
            strcat ::temp7 ::temp7 " detected while sneaking at " 
            cast ::temp3 sneakDist 
            strcat ::temp3 ::temp7 ::temp3 
            strcat ::temp3 ::temp3 "u - confronting early" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2315
            callmethod OnAmbushConfront self ::nonevar ;0 variable args
            ; line 2316
            return None 
            jmp _label29
          _label29:
            jmp _label30
            ; line 2320
          _label25:
            callmethod IsDetectedBy ::ActiveStoryNPC_var ::temp1 player ;1 variable args
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label31
            cmp_lte ::temp1 sneakDist 400.0 
            assign ::temp1 ::temp1 
          _label31:
            jmpf ::temp1 _label32
            ; line 2321
            callmethod OnStalkerDetected self ::nonevar ;0 variable args
            ; line 2322
            return None 
            jmp _label32
            ; line 2326
          _label32:
            cmp_eq ::temp1 sneakPhase 1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label33
            propget STALKER_KEEP_DISTANCE self ::temp6 
            cmp_lte ::temp1 sneakDist ::temp6 
            assign ::temp1 ::temp1 
          _label33:
            jmpf ::temp1 _label34
            ; line 2327
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 2328
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil SetIntValue ::temp2 ::temp4 "Intel_SneakPhase" 2 ;3 variable args
            ; line 2329
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story [stalker]: " ::temp3 
            strcat ::temp3 ::temp3 " holding at " 
            cast ::temp7 sneakDist 
            strcat ::temp7 ::temp3 ::temp7 
            strcat ::temp7 ::temp7 "u" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            jmp _label34
            ; line 2333
          _label34:
            cmp_eq ::temp1 sneakPhase 2 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label35
            propget STALKER_RESUME_DISTANCE self ::temp6 
            cmp_gt ::temp1 sneakDist ::temp6 
            assign ::temp1 ::temp1 
          _label35:
            jmpf ::temp1 _label30
            ; line 2334
            callmethod ReapplyTravelPackage self ::nonevar ::ActiveStoryNPC_var ;1 variable args
            ; line 2335
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil SetIntValue ::temp2 ::temp4 "Intel_SneakPhase" 1 ;3 variable args
            ; line 2336
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp7 ;0 variable args
            strcat ::temp7 "Story [stalker]: " ::temp7 
            strcat ::temp7 ::temp7 " resuming follow at " 
            cast ::temp3 sneakDist 
            strcat ::temp3 ::temp7 ::temp3 
            strcat ::temp3 ::temp3 "u" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label30
            ; line 2341
          _label30:
            return None 
            jmp _label24
          _label24:
            jmp _label11
            ; line 2347
          _label11:
            cmp_eq ::temp1 ::ActiveStoryType_var "quest_guide" 
            jmpf ::temp1 _label36
            ; line 2349
            return None 
            jmp _label36
            ; line 2353
          _label36:
            assign arrivalTarget player 
            ; line 2354
            callmethod IsNPCToNPCType self ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label37
            cast ::temp0 None 
            cmp_eq ::temp1 ::ActiveSecondNPC_var ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label37:
            jmpf ::temp1 _label38
            ; line 2355
            assign arrivalTarget ::ActiveSecondNPC_var 
            jmp _label38
            ; line 2359
          _label38:
            cmp_eq ::temp1 arrivalTarget player 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label39
            callmethod IsInCombat player ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label39:
            jmpf ::temp1 _label40
            ; line 2360
            return None 
            jmp _label40
            ; line 2364
          _label40:
            cmp_eq ::temp1 arrivalTarget player 
            jmpf ::temp1 _label41
            ; line 2365
            callstatic intelEngine IsPlayerInBlockedLocation ::temp1 ;0 variable args
            jmpf ::temp1 _label42
            ; line 2366
            strcat ::temp3 "Story: cancelling " ::ActiveStoryType_var 
            strcat ::temp3 ::temp3 " for " 
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp7 ;0 variable args
            strcat ::temp7 ::temp3 ::temp7 
            strcat ::temp7 ::temp7 " -- player at blocked location" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            ; line 2367
            callmethod GetDisplayName player ::temp7 ;0 variable args
            strcat ::temp7 "gave up looking for " ::temp7 
            strcat ::temp7 ::temp7 " and turned back" 
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp7 player ;3 variable args
            ; line 2368
            callmethod AbortStoryTravel self ::nonevar "player at blocked location" ;1 variable args
            ; line 2369
            return None 
            jmp _label42
            ; line 2371
          _label42:
            callstatic intelEngine IsPlayerInWhitelistedLocation ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label43
            ; line 2372
            strcat ::temp7 "Story: cancelling " ::ActiveStoryType_var 
            strcat ::temp7 ::temp7 " for " 
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 ::temp7 ::temp3 
            strcat ::temp3 ::temp3 " -- player not at whitelisted location" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2373
            callmethod GetDisplayName player ::temp3 ;0 variable args
            strcat ::temp3 "decided not to seek " ::temp3 
            strcat ::temp3 ::temp3 " at this location" 
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp3 player ;3 variable args
            ; line 2374
            callmethod AbortStoryTravel self ::nonevar "player not at whitelisted location" ;1 variable args
            ; line 2375
            return None 
            jmp _label43
          _label43:
            jmp _label41
            ; line 2381
          _label41:
            cmp_eq ::temp1 arrivalTarget player 
            jmpf ::temp1 _label44
            ; line 2382
            callmethod ShouldAbortForDangerZone self ::temp1 ::ActiveStoryNPC_var player ::ActiveStoryType_var "" ;4 variable args
            jmpf ::temp1 _label45
            ; line 2383
            return None 
            jmp _label45
            ; line 2385
          _label45:
            callmethod ShouldAbortForPlayerHome self ::temp1 ::ActiveStoryNPC_var player ::ActiveStoryType_var "" ;4 variable args
            jmpf ::temp1 _label46
            ; line 2386
            return None 
            jmp _label46
            ; line 2388
          _label46:
            callmethod ShouldAbortForHoldRestriction self ::temp1 ::ActiveStoryNPC_var player ::ActiveStoryType_var "" ;4 variable args
            jmpf ::temp1 _label47
            ; line 2389
            return None 
            jmp _label47
          _label47:
            jmp _label44
            ; line 2394
          _label44:
            cmp_eq ::temp1 arrivalTarget player 
            jmpf ::temp1 _label48
            ; line 2395
            callmethod GetParentCell player ::temp9 ;0 variable args
            assign pCell ::temp9 
            ; line 2396
            cast ::temp9 None 
            cmp_eq ::temp1 pCell ::temp9 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label49
            callmethod IsInterior pCell ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label49:
            jmpf ::temp1 _label50
            ; line 2397
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
            ; line 2398
            strcat ::temp3 "Story: aborting " ::ActiveStoryType_var 
            strcat ::temp3 ::temp3 " for " 
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp7 ;0 variable args
            strcat ::temp7 ::temp3 ::temp7 
            strcat ::temp7 ::temp7 " -- player entered interior" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp7 ;1 variable args
            ; line 2399
            callmethod GetDisplayName player ::temp7 ;0 variable args
            strcat ::temp7 "lost track of " ::temp7 
            strcat ::temp7 ::temp7 " after they went inside and gave up" 
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp7 player ;3 variable args
            ; line 2400
            callmethod AbortStoryTravel self ::nonevar "exterior type in interior" ;1 variable args
            ; line 2401
            return None 
            jmp _label53
          _label53:
            jmp _label50
          _label50:
            jmp _label48
            ; line 2406
          _label48:
            cast ::temp8 arrivalTarget 
            callmethod GetDistance ::ActiveStoryNPC_var ::temp6 ::temp8 ;1 variable args
            assign dist ::temp6 
            ; line 2409
            propget ARRIVAL_DISTANCE ::Core_var ::temp6 
            cmp_lte ::temp1 dist ::temp6 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label54
            cmp_gt ::temp1 dist 0.0 
            assign ::temp1 ::temp1 
          _label54:
            jmpf ::temp1 _label55
            ; line 2410
            callmethod OnStoryNPCArrived self ::nonevar ;0 variable args
            ; line 2411
            return None 
            jmp _label55
            ; line 2416
          _label55:
            callmethod GetParentCell arrivalTarget ::temp9 ;0 variable args
            assign targetCell ::temp9 
            ; line 2417
            callmethod GetParentCell ::ActiveStoryNPC_var ::temp9 ;0 variable args
            assign npcCell2 ::temp9 
            ; line 2418
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
            ; line 2419
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
            ; line 2420
            callmethod OnStoryNPCArrived self ::nonevar ;0 variable args
            ; line 2421
            return None 
            jmp _label61
          _label61:
            jmp _label58
            ; line 2425
          _label58:
            callmethod FindSlotByAgent ::Core_var ::temp2 ::ActiveStoryNPC_var ;1 variable args
            assign ::mangled_slot_0 ::temp2 
            ; line 2426
            cmp_lt ::temp1 ::mangled_slot_0 0 
            jmpf ::temp1 _label62
            ; line 2427
            return None 
            jmp _label62
            ; line 2431
          _label62:
            callmethod Is3DLoaded ::ActiveStoryNPC_var ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label63
            ; line 2433
            cmp_eq ::temp1 arrivalTarget player 
            jmpf ::temp1 _label64
            ; line 2434
            callmethod ShouldAbortForDangerZone self ::temp1 ::ActiveStoryNPC_var player ::ActiveStoryType_var " (off-screen)" ;4 variable args
            jmpf ::temp1 _label65
            ; line 2435
            return None 
            jmp _label65
            ; line 2437
          _label65:
            callmethod ShouldAbortForPlayerHome self ::temp1 ::ActiveStoryNPC_var player ::ActiveStoryType_var " (off-screen)" ;4 variable args
            jmpf ::temp1 _label66
            ; line 2438
            return None 
            jmp _label66
            ; line 2440
          _label66:
            callmethod ShouldAbortForHoldRestriction self ::temp1 ::ActiveStoryNPC_var player ::ActiveStoryType_var " (off-screen)" ;4 variable args
            jmpf ::temp1 _label67
            ; line 2441
            return None 
            jmp _label67
          _label67:
            jmp _label64
            ; line 2445
          _label64:
            cmp_eq ::temp1 arrivalTarget player 
            jmpf ::temp1 _label68
            ; line 2446
            callmethod GetParentCell player ::temp9 ;0 variable args
            assign offPCell ::temp9 
            ; line 2447
            cast ::temp9 None 
            cmp_eq ::temp1 offPCell ::temp9 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label69
            callmethod IsInterior offPCell ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label69:
            jmpf ::temp1 _label70
            ; line 2448
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
            ; line 2449
            strcat ::temp7 "Story: aborting " ::ActiveStoryType_var 
            strcat ::temp7 ::temp7 " for " 
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 ::temp7 ::temp3 
            strcat ::temp3 ::temp3 " -- player entered interior (off-screen)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2450
            callmethod GetDisplayName player ::temp3 ;0 variable args
            strcat ::temp3 "lost track of " ::temp3 
            strcat ::temp3 ::temp3 " after they went inside and gave up" 
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp3 player ;3 variable args
            ; line 2451
            callmethod AbortStoryTravel self ::nonevar "exterior type in interior (off-screen)" ;1 variable args
            ; line 2452
            return None 
            jmp _label73
          _label73:
            jmp _label70
          _label70:
            jmp _label68
            ; line 2457
          _label68:
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            callstatic intelEngine CheckOffScreenProgress ::temp2 ::mangled_slot_0 ::ActiveStoryNPC_var ::temp6 ;3 variable args
            assign offscreenStatus ::temp2 
            ; line 2458
            cmp_eq ::temp1 offscreenStatus 1 
            jmpf ::temp1 _label74
            ; line 2459
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 ::temp3 " off-screen arrival (estimated time elapsed)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 2460
            callmethod ImmersiveTeleportToTarget self ::nonevar ::ActiveStoryNPC_var arrivalTarget ;2 variable args
            ; line 2462
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp4 "Intel_TaskStartTime" ;2 variable args
            jmp _label74
            ; line 2464
          _label74:
            return None 
            jmp _label63
            ; line 2468
          _label63:
            propget STUCK_DISTANCE_THRESHOLD ::Core_var ::temp6 
            callstatic intelEngine CheckStuckStatus ::temp2 ::ActiveStoryNPC_var ::mangled_slot_0 ::temp6 ;3 variable args
            assign stuckStatus ::temp2 
            ; line 2469
            cmp_eq ::temp1 stuckStatus 1 
            jmpf ::temp1 _label75
            ; line 2470
            cast ::temp8 arrivalTarget 
            callmethod SoftStuckRecovery ::Core_var ::nonevar ::ActiveStoryNPC_var ::mangled_slot_0 ::temp8 ;3 variable args
            jmp _label76
            ; line 2471
          _label75:
            comp_gte ::temp1 stuckStatus 3 
            jmpf ::temp1 _label76
            ; line 2472
            jmpf ::AllowStuckTeleport_var _label77
            ; line 2473
            callmethod ImmersiveTeleportToTarget self ::nonevar ::ActiveStoryNPC_var arrivalTarget ;2 variable args
            ; line 2475
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp4 "Intel_TaskStartTime" ;2 variable args
            jmp _label78
            ; line 2477
          _label77:
            callmethod AbortStoryTravel self ::nonevar "stuck, teleport disabled" ;1 variable args
            ; line 2479
          _label78:
            return None 
            jmp _label76
            ; line 2486
          _label76:
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp6 ::temp4 "Intel_TaskStartTime" 0.0 ;3 variable args
            assign taskStart ::temp6 
            ; line 2487
            cmp_gt ::temp1 taskStart 0.0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label79
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            fsub ::temp6 ::temp6 taskStart 
            cmp_gt ::temp1 ::temp6 ::MaxTravelDaysConfig_var 
            assign ::temp1 ::temp1 
          _label79:
            jmpf ::temp1 _label80
            ; line 2488
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "[IntelEngine] StoryEngine: Travel timeout for " ::temp3 
            strcat ::temp3 ::temp3 " — force-arriving" 
            callstatic debug Trace ::nonevar ::temp3 0 ;2 variable args
            ; line 2489
            jmpf ::AllowStuckTeleport_var _label81
            ; line 2490
            callmethod ImmersiveTeleportToTarget self ::nonevar ::ActiveStoryNPC_var arrivalTarget ;2 variable args
            ; line 2491
            callmethod OnStoryNPCArrived self ::nonevar ;0 variable args
            jmp _label82
            ; line 2493
          _label81:
            callmethod AbortStoryTravel self ::nonevar "travel timeout, teleport disabled" ;1 variable args
            ; line 2495
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
            ; line 2504
            callmethod GetParentCell target ::temp0 ;0 variable args
            assign targetCell ::temp0 
            ; line 2506
            cast ::temp0 None 
            cmp_eq ::temp1 targetCell ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            callmethod IsInterior targetCell ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 2507
            propget TELEPORT_OFFSET_INTERIOR self ::temp2 
            callmethod TeleportBehindPlayer ::Core_var ::nonevar npc ::temp2 ;2 variable args
            jmp _label2
            ; line 2509
          _label1:
            cast ::temp3 target 
            propget TELEPORT_OFFSET_EXTERIOR self ::temp2 
            callstatic intelEngine GetOffsetBehind ::temp4 ::temp3 ::temp2 ;2 variable args
            assign offset ::temp4 
            ; line 2510
            cast ::temp3 target 
            array_getlement ::temp2 offset 0 
            array_getlement ::temp5 offset 1 
            callmethod MoveTo npc ::nonevar ::temp3 ::temp2 ::temp5 0.0 False ;5 variable args
            ; line 2513
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
            ; line 2521
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp0 ;0 variable args
            strcat ::temp0 "Story: " ::temp0 
            strcat ::temp0 ::temp0 " arrived! [" 
            strcat ::temp0 ::temp0 ::ActiveStoryType_var 
            strcat ::temp0 ::temp0 "]" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 2524
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush_charge" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush" 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 2525
            callmethod OnAmbushConfront self ::nonevar ;0 variable args
            ; line 2526
            return None 
            jmp _label1
            ; line 2530
          _label1:
            cmp_eq ::temp1 ::ActiveStoryType_var "message" 
            jmpf ::temp1 _label2
            ; line 2531
            callmethod OnMessageArrived self ::nonevar ;0 variable args
            ; line 2532
            return None 
            jmp _label2
            ; line 2536
          _label2:
            cmp_eq ::temp1 ::ActiveStoryType_var "quest" 
            jmpf ::temp1 _label3
            ; line 2537
            callmethod OnQuestNPCArrived self ::nonevar ;0 variable args
            ; line 2538
            return None 
            jmp _label3
            ; line 2541
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
            ; line 2543
            cast ::temp3 ::ActiveSecondNPC_var 
            callmethod SetLookAt ::ActiveStoryNPC_var ::nonevar ::temp3 False ;2 variable args
            ; line 2544
            cast ::temp3 ::ActiveStoryNPC_var 
            callmethod SetLookAt ::ActiveSecondNPC_var ::nonevar ::temp3 False ;2 variable args
            ; line 2545
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 2546
            callmethod BuildInteractionSummary self ::temp0 ::ActiveStoryNPC_var ::ActiveNarration_var ::ActiveSecondNPC_var ;3 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp0 ::ActiveSecondNPC_var ;3 variable args
            jmp _label6
            ; line 2549
          _label5:
            callstatic game GetPlayer ::temp2 ;0 variable args
            cast ::temp3 ::temp2 
            callmethod SetLookAt ::ActiveStoryNPC_var ::nonevar ::temp3 False ;2 variable args
            ; line 2550
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::ActiveNarration_var ::temp2 ;3 variable args
            ; line 2554
          _label6:
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp0 ;0 variable args
            assign npcName ::temp0 
            ; line 2555
            strcat ::temp0 ::ActiveStoryType_var ": " 
            strcat ::temp0 ::temp0 npcName 
            strcat ::temp0 ::temp0 " -- " 
            strcat ::temp0 ::temp0 ::ActiveNarration_var 
            assign eventSummary ::temp0 
            ; line 2556
            callmethod AddRecentStoryEvent self ::nonevar eventSummary ;1 variable args
            ; line 2559
            assign arrivedNPC ::ActiveStoryNPC_var 
            ; line 2560
            assign secondNPC ::ActiveSecondNPC_var 
            ; line 2561
            callmethod IsNPCToNPCType self ::temp1 ;0 variable args
            assign isNpcToNpc ::temp1 
            ; line 2564
            callstatic game GetPlayer ::temp2 ;0 variable args
            cast ::temp3 ::temp2 
            assign lingerTarget ::temp3 
            ; line 2565
            assign ::temp1 isNpcToNpc 
            jmpf ::temp1 _label7
            cast ::temp2 None 
            cmp_eq ::temp1 secondNPC ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label7:
            jmpf ::temp1 _label8
            ; line 2566
            cast ::temp3 secondNPC 
            assign lingerTarget ::temp3 
            jmp _label8
            ; line 2568
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
            ; line 2576
            callmethod ExtractJsonField self ::temp0 response "msgContent" ;2 variable args
            assign msgContent ::temp0 
            ; line 2577
            callmethod ExtractJsonField self ::temp0 response "destination" ;2 variable args
            assign destination ::temp0 
            ; line 2578
            callmethod ExtractJsonField self ::temp0 response "meetTime" ;2 variable args
            assign meetTime ::temp0 
            ; line 2580
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName ::temp1 ::temp0 ;0 variable args
            assign playerName ::temp0 
            ; line 2581
            callmethod GetDisplayName senderNPC ::temp0 ;0 variable args
            assign senderName ::temp0 
            ; line 2584
            callstatic intelEngine FindMessengerForSender ::temp1 senderNPC ;1 variable args
            assign messenger ::temp1 
            ; line 2586
            cast ::temp1 None 
            cmp_eq ::temp2 messenger ::temp1 
            jmpf ::temp2 _label0
            ; line 2588
            callstatic intelEngine IsCivilianClass ::temp2 senderNPC ;1 variable args
            jmpf ::temp2 _label1
            ; line 2589
            assign messenger senderNPC 
            ; line 2590
            strcat ::temp0 "Story message: " senderName 
            strcat ::temp0 ::temp0 " self-delivering (civilian)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            jmp _label2
            ; line 2592
          _label1:
            strcat ::temp0 "Story message: rejected -- no messenger for " senderName 
            strcat ::temp0 ::temp0 " (non-civilian, no self-delivery)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 2593
            return None 
          _label2:
            jmp _label0
            ; line 2597
          _label0:
            callmethod GetDisplayName messenger ::temp0 ;0 variable args
            assign messengerName ::temp0 
            ; line 2600
            cmp_eq ::temp2 messenger senderNPC 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label3
            ; line 2601
            strcat ::temp0 "asked " messengerName 
            strcat ::temp0 ::temp0 " to deliver a message to " 
            strcat ::temp0 ::temp0 playerName 
            strcat ::temp0 ::temp0 ": " 
            strcat ::temp0 ::temp0 msgContent 
            callmethod InjectFact ::Core_var ::nonevar senderNPC ::temp0 ;2 variable args
            ; line 2602
            strcat ::temp0 "was sent by " senderName 
            strcat ::temp0 ::temp0 " to deliver a message to " 
            strcat ::temp0 ::temp0 playerName 
            strcat ::temp0 ::temp0 ": " 
            strcat ::temp0 ::temp0 msgContent 
            callmethod InjectFact ::Core_var ::nonevar messenger ::temp0 ;2 variable args
            ; line 2603
            callstatic game GetPlayer ::temp1 ;0 variable args
            strcat ::temp0 messengerName " set out to deliver a message from " 
            strcat ::temp0 ::temp0 senderName 
            strcat ::temp0 ::temp0 " to " 
            strcat ::temp0 ::temp0 playerName 
            callmethod SendPersistentMemory ::Core_var ::nonevar messenger ::temp1 ::temp0 ;3 variable args
            jmp _label4
            ; line 2605
          _label3:
            strcat ::temp0 "set out to deliver a message to " playerName 
            strcat ::temp0 ::temp0 ": " 
            strcat ::temp0 ::temp0 msgContent 
            callmethod InjectFact ::Core_var ::nonevar senderNPC ::temp0 ;2 variable args
            ; line 2606
            callstatic game GetPlayer ::temp1 ;0 variable args
            strcat ::temp0 senderName " set out to find " 
            strcat ::temp0 ::temp0 playerName 
            callmethod SendPersistentMemory ::Core_var ::nonevar senderNPC ::temp1 ::temp0 ;3 variable args
            ; line 2610
          _label4:
            cast ::temp3 messenger 
            callstatic storageUtil SetStringValue ::temp0 ::temp3 "Intel_MessageSender" senderName ;3 variable args
            ; line 2611
            cast ::temp3 messenger 
            callstatic storageUtil SetStringValue ::temp0 ::temp3 "Intel_MessageContent" msgContent ;3 variable args
            ; line 2612
            cast ::temp3 messenger 
            callstatic storageUtil SetStringValue ::temp0 ::temp3 "Intel_MessageDest" destination ;3 variable args
            ; line 2613
            cast ::temp3 messenger 
            callstatic storageUtil SetStringValue ::temp0 ::temp3 "Intel_MessageTime" meetTime ;3 variable args
            ; line 2615
            assign ::ActiveStoryType_var "message" 
            ; line 2616
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
            ; line 2620
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_MessageSender" "" ;3 variable args
            assign senderName ::temp1 
            ; line 2621
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_MessageContent" "" ;3 variable args
            assign msgContent ::temp1 
            ; line 2622
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_MessageDest" "" ;3 variable args
            assign msgDest ::temp1 
            ; line 2623
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_MessageTime" "" ;3 variable args
            assign meetTime ::temp1 
            ; line 2626
            assign fullNarration "" 
            ; line 2627
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
            ; line 2628
            strcat ::temp1 "delivered a message from " senderName 
            strcat ::temp1 ::temp1 ": " 
            strcat ::temp1 ::temp1 msgContent 
            assign fullNarration ::temp1 
            jmp _label2
            ; line 2630
          _label1:
            assign fullNarration ::ActiveNarration_var 
            ; line 2632
          _label2:
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var fullNarration ::temp3 ;3 variable args
            ; line 2636
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp1 " delivered a message from " 
            strcat ::temp1 ::temp1 senderName 
            strcat ::temp1 ::temp1 ": " 
            strcat ::temp1 ::temp1 msgContent 
            callmethod SendPersistentMemory ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp3 ::temp1 ;3 variable args
            ; line 2641
            cmp_eq ::temp2 msgDest "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label3
            cmp_eq ::temp2 meetTime "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label3:
            jmpf ::temp2 _label4
            ; line 2642
            callstatic intelEngine IsUrgentMessage ::temp2 msgContent ;1 variable args
            jmpf ::temp2 _label5
            ; line 2643
            strcat ::temp1 "Story message: urgency in msgContent conflicts with meetTime '" meetTime 
            strcat ::temp1 ::temp1 "' -- dropping meeting, treating as plain message" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 2644
            assign msgDest "" 
            ; line 2645
            assign meetTime "" 
            jmp _label5
          _label5:
            jmp _label4
            ; line 2650
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
            ; line 2651
            cast ::temp3 None 
            assign senderForMeeting ::temp3 
            ; line 2652
            cmp_eq ::temp2 senderName "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label8
            ; line 2653
            callstatic intelEngine FindNPCByName ::temp3 senderName ;1 variable args
            assign senderForMeeting ::temp3 
            jmp _label8
            ; line 2655
          _label8:
            cast ::temp3 None 
            cmp_eq ::temp2 senderForMeeting ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label9
            ; line 2656
            assign timeCondition meetTime 
            ; line 2657
            cmp_eq ::temp2 timeCondition "" 
            jmpf ::temp2 _label10
            ; line 2658
            assign timeCondition "evening" 
            jmp _label10
            ; line 2660
          _label10:
            callmethod ScheduleMeeting ::Schedule_var ::temp2 senderForMeeting msgDest timeCondition ;3 variable args
            jmp _label9
          _label9:
            jmp _label7
            ; line 2665
          _label7:
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 "message: " ::temp1 
            strcat ::temp1 ::temp1 " -- " 
            strcat ::temp1 ::temp1 fullNarration 
            callmethod AddRecentStoryEvent self ::nonevar ::temp1 ;1 variable args
            ; line 2667
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
            ; line 2675
            callmethod ExtractJsonField self ::temp0 response "sender" ;2 variable args
            assign senderName ::temp0 
            ; line 2676
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName ::temp1 ::temp0 ;0 variable args
            assign playerName ::temp0 
            ; line 2679
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 ::temp0 " " 
            strcat ::temp0 ::temp0 narration 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc npc ::temp0 ;3 variable args
            ; line 2682
            callmethod InjectFact ::Core_var ::nonevar npc narration ;2 variable args
            ; line 2685
            cmp_eq ::temp2 senderName "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label0
            ; line 2686
            callstatic intelEngine FindNPCByName ::temp1 senderName ;1 variable args
            assign senderNPC ::temp1 
            ; line 2687
            cast ::temp1 None 
            cmp_eq ::temp2 senderNPC ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label1
            ; line 2688
            cmp_eq ::temp2 storyType "ambush" 
            jmpf ::temp2 _label2
            ; line 2689
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "sent " ::temp0 
            strcat ::temp0 ::temp0 " to ambush " 
            strcat ::temp0 ::temp0 playerName 
            callmethod InjectFact ::Core_var ::nonevar senderNPC ::temp0 ;2 variable args
            jmp _label3
            ; line 2691
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
            ; line 2697
          _label0:
            cmp_eq ::temp2 storyType "ambush" 
            jmpf ::temp2 _label4
            ; line 2698
            callstatic utility RandomInt ::temp3 0 1 ;2 variable args
            cmp_eq ::temp2 ::temp3 1 
            jmpf ::temp2 _label5
            ; line 2699
            assign storyType "ambush_charge" 
            ; line 2700
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Story [ambush]: " ::temp0 
            strcat ::temp0 ::temp0 " choosing aggressive charge approach" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            jmp _label6
            ; line 2702
          _label5:
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Story [ambush]: " ::temp0 
            strcat ::temp0 ::temp0 " choosing stealthy approach" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
          _label6:
            jmp _label4
            ; line 2706
          _label4:
            assign ::ActiveStoryType_var storyType 
            ; line 2707
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod DispatchToTarget self ::nonevar npc ::temp1 narration "story" ;4 variable args
            ; line 2711
            cmp_eq ::temp2 storyType "stalker" 
            jmpf ::temp2 _label7
            ; line 2712
            cast ::temp4 npc 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "Intel_SneakPhase" 1 ;3 variable args
            ; line 2713
            callmethod ReapplyTravelPackage self ::nonevar npc ;1 variable args
            ; line 2714
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Story [stalker]: " ::temp0 
            strcat ::temp0 ::temp0 " dispatched with stalk package" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            jmp _label8
            ; line 2715
          _label7:
            cmp_eq ::temp2 storyType "ambush" 
            jmpf ::temp2 _label8
            ; line 2716
            cast ::temp4 npc 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "Intel_SneakPhase" 0 ;3 variable args
            ; line 2717
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Story [ambush]: " ::temp0 
            strcat ::temp0 ::temp0 " dispatched (jog → sneak at 2000u)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            jmp _label8
            ; line 2721
          _label8:
            cmp_eq ::temp2 storyType "ambush" 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label9
            cmp_eq ::temp2 storyType "stalker" 
            assign ::temp2 ::temp2 
          _label9:
            jmpf ::temp2 _label10
            ; line 2722
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
            ; line 2728
            callmethod ExtractJsonField self ::temp0 response "ambushFaction" ;2 variable args
            assign factionId ::temp0 
            ; line 2729
            callmethod ExtractJsonField self ::temp0 response "ambushCount" ;2 variable args
            assign countStr ::temp0 
            ; line 2731
            cmp_eq ::temp1 factionId "" 
            jmpf ::temp1 _label0
            ; line 2732
            callmethod DebugMsg ::Core_var ::nonevar "Story [faction_ambush]: missing ambushFaction" ;1 variable args
            ; line 2733
            return None 
            jmp _label0
            ; line 2736
          _label0:
            cast ::temp2 countStr 
            assign count ::temp2 
            ; line 2737
            cmp_lt ::temp1 count 3 
            jmpf ::temp1 _label1
            ; line 2738
            assign count 3 
            jmp _label2
            ; line 2739
          _label1:
            cmp_gt ::temp1 count 7 
            jmpf ::temp1 _label2
            ; line 2740
            assign count 7 
            jmp _label2
            ; line 2744
          _label2:
            callstatic intelEngine IsBattleActive ::temp1 ;0 variable args
            jmpf ::temp1 _label3
            ; line 2745
            callmethod DebugMsg ::Core_var ::nonevar "Story [faction_ambush]: battle active, skipping" ;1 variable args
            ; line 2746
            return None 
            jmp _label3
            ; line 2748
          _label3:
            jmpf ::FactionAmbushActive_var _label4
            ; line 2749
            callmethod DebugMsg ::Core_var ::nonevar "Story [faction_ambush]: previous ambush still active, skipping" ;1 variable args
            ; line 2750
            return None 
            jmp _label4
            ; line 2752
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
            ; line 2753
            callmethod DebugMsg ::Core_var ::nonevar "Story [faction_ambush]: manifestation active, skipping" ;1 variable args
            ; line 2754
            return None 
            jmp _label6
            ; line 2757
          _label6:
            callstatic game GetPlayer ::temp5 ;0 variable args
            assign player ::temp5 
            ; line 2760
            strcat ::temp0 factionId ":" 
            cast ::temp6 count 
            strcat ::temp6 ::temp0 ::temp6 
            cast ::temp7 player 
            callstatic intelEngine SpawnBattleSoldiers ::temp8 ::temp6 ::temp7 ;2 variable args
            assign soldiers ::temp8 
            ; line 2761
            array_length ::temp2 soldiers 
            cmp_eq ::temp1 ::temp2 0 
            jmpf ::temp1 _label7
            ; line 2762
            strcat ::temp6 "Story [faction_ambush]: no soldiers spawned for " factionId 
            callmethod DebugMsg ::Core_var ::nonevar ::temp6 ;1 variable args
            ; line 2763
            return None 
            jmp _label7
            ; line 2768
          _label7:
            array_create ::temp8 7 
            assign ::FactionAmbushActors_var ::temp8 
            ; line 2769
            assign ::FactionAmbushCount_var 0 
            ; line 2770
            callmethod GetAngleZ player ::temp9 ;0 variable args
            assign playerAngle ::temp9 
            ; line 2772
            assign i 0 
            ; line 2773
          _label11:
            array_length ::temp2 soldiers 
            cmp_lt ::temp1 i ::temp2 
            jmpf ::temp1 _label8
            ; line 2774
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
            ; line 2776
            fadd ::temp9 playerAngle 180.0 
            callstatic utility RandomFloat ::temp11 -45.0 45.0 ;2 variable args
            fadd ::temp11 ::temp9 ::temp11 
            assign angle ::temp11 
            ; line 2777
            callstatic utility RandomFloat ::temp11 800.0 1200.0 ;2 variable args
            assign dist ::temp11 
            ; line 2778
            callstatic math sin ::temp11 angle ;1 variable args
            fmul ::temp11 ::temp11 dist 
            assign offsetX ::temp11 
            ; line 2779
            callstatic math cos ::temp11 angle ;1 variable args
            fmul ::temp11 ::temp11 dist 
            assign offsetY ::temp11 
            ; line 2780
            cast ::temp7 player 
            array_getlement ::temp10 soldiers i 
            callmethod MoveTo ::temp10 ::nonevar ::temp7 offsetX offsetY 0.0 True ;5 variable args
            ; line 2781
            array_getlement ::temp10 soldiers i 
            callmethod SetActorValue ::temp10 ::nonevar "Confidence" 4.0 ;2 variable args
            ; line 2782
            array_getlement ::temp10 soldiers i 
            callmethod SetActorValue ::temp10 ::nonevar "Aggression" 1.0 ;2 variable args
            ; line 2783
            array_getlement ::temp10 soldiers i 
            array_setelement ::FactionAmbushActors_var ::FactionAmbushCount_var ::temp10 
            ; line 2784
            iadd ::temp2 ::FactionAmbushCount_var 1 
            assign ::FactionAmbushCount_var ::temp2 
            jmp _label10
            ; line 2786
          _label10:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label11
            ; line 2789
          _label8:
            cmp_eq ::temp1 ::FactionAmbushCount_var 0 
            jmpf ::temp1 _label12
            ; line 2790
            callmethod DebugMsg ::Core_var ::nonevar "Story [faction_ambush]: all soldiers None after spawn" ;1 variable args
            ; line 2791
            return None 
            jmp _label12
            ; line 2794
          _label12:
            callstatic intelEngine GetFactionDisplayName ::temp6 factionId ;1 variable args
            assign factionName ::temp6 
            ; line 2797
            callstatic utility RandomFloat ::temp11 0.0 1.0 ;2 variable args
            fadd ::temp11 1.5 ::temp11 
            callstatic utility Wait ::nonevar ::temp11 ;1 variable args
            ; line 2798
            callstatic debug Notification ::nonevar "Something feels wrong..." ;1 variable args
            ; line 2799
            callstatic utility Wait ::nonevar 1.0 ;1 variable args
            ; line 2800
            callstatic utility RandomInt ::temp2 0 2 ;2 variable args
            assign ambushMsg ::temp2 
            ; line 2801
            cmp_eq ::temp1 ambushMsg 0 
            jmpf ::temp1 _label13
            ; line 2802
            strcat ::temp6 factionName " soldiers emerge from hiding!" 
            callstatic debug Notification ::nonevar ::temp6 ;1 variable args
            jmp _label14
            ; line 2803
          _label13:
            cmp_eq ::temp1 ambushMsg 1 
            jmpf ::temp1 _label15
            ; line 2804
            strcat ::temp6 "Ambush! " factionName 
            strcat ::temp6 ::temp6 " forces surround you!" 
            callstatic debug Notification ::nonevar ::temp6 ;1 variable args
            jmp _label14
            ; line 2806
          _label15:
            strcat ::temp6 factionName " troops close in from behind!" 
            callstatic debug Notification ::nonevar ::temp6 ;1 variable args
            ; line 2810
          _label14:
            assign i 0 
            ; line 2811
          _label18:
            cmp_lt ::temp1 i ::FactionAmbushCount_var 
            jmpf ::temp1 _label16
            ; line 2812
            array_getlement ::temp10 ::FactionAmbushActors_var i 
            cast ::temp5 None 
            cmp_eq ::temp1 ::temp10 ::temp5 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label17
            ; line 2813
            array_getlement ::temp5 ::FactionAmbushActors_var i 
            callmethod StartCombat ::temp5 ::nonevar player ;1 variable args
            ; line 2814
            callstatic utility RandomFloat ::temp11 0.300000012 0.600000024 ;2 variable args
            callstatic utility Wait ::nonevar ::temp11 ;1 variable args
            jmp _label17
            ; line 2816
          _label17:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label18
            ; line 2819
          _label16:
            strcat ::temp6 "faction_ambush: " factionName 
            strcat ::temp6 ::temp6 " (" 
            cast ::temp0 ::FactionAmbushCount_var 
            strcat ::temp0 ::temp6 ::temp0 
            strcat ::temp0 ::temp0 " soldiers) -- " 
            strcat ::temp0 ::temp0 narration 
            callmethod AddRecentStoryEvent self ::nonevar ::temp0 ;1 variable args
            ; line 2821
            assign ::FactionAmbushActive_var True 
            ; line 2822
            callstatic utility GetCurrentRealTime ::temp11 ;0 variable args
            assign ::FactionAmbushStartTime_var ::temp11 
            ; line 2823
            cast ::temp12 player 
            callstatic storageUtil SetStringValue ::temp0 ::temp12 "Intel_FactionAmbushFaction" factionId ;3 variable args
            ; line 2824
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
            ; line 2829
            not ::temp0 ::FactionAmbushActive_var 
            jmpf ::temp0 _label0
            ; line 2830
            return None 
            jmp _label0
            ; line 2833
          _label0:
            callstatic utility GetCurrentRealTime ::temp1 ;0 variable args
            fsub ::temp1 ::temp1 ::FactionAmbushStartTime_var 
            assign elapsed ::temp1 
            ; line 2834
            assign allDead True 
            ; line 2835
            assign deadCount 0 
            ; line 2836
            assign i 0 
            ; line 2837
          _label5:
            cmp_lt ::temp0 i ::FactionAmbushCount_var 
            jmpf ::temp0 _label1
            ; line 2838
            array_getlement ::temp2 ::FactionAmbushActors_var i 
            cast ::temp3 None 
            cmp_eq ::temp0 ::temp2 ::temp3 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 2839
            array_getlement ::temp3 ::FactionAmbushActors_var i 
            callmethod IsDead ::temp3 ::temp0 ;0 variable args
            jmpf ::temp0 _label3
            ; line 2840
            iadd ::temp4 deadCount 1 
            assign deadCount ::temp4 
            jmp _label4
            ; line 2842
          _label3:
            assign allDead False 
          _label4:
            jmp _label2
            ; line 2845
          _label2:
            iadd ::temp4 i 1 
            assign i ::temp4 
            jmp _label5
            ; line 2849
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
            ; line 2850
            propget FACTION_AMBUSH_HARD_TIMEOUT self ::temp1 
            comp_gte ::temp0 elapsed ::temp1 
            assign hardTimeout ::temp0 
            ; line 2851
            assign ::temp0 allDead 
            jmpt ::temp0 _label7
            assign ::temp0 timeoutReady 
          _label7:
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label8
            assign ::temp0 hardTimeout 
          _label8:
            jmpf ::temp0 _label9
            ; line 2855
            callstatic game GetPlayer ::temp3 ;0 variable args
            cast ::temp5 ::temp3 
            callstatic storageUtil GetStringValue ::temp6 ::temp5 "Intel_FactionAmbushFaction" "" ;3 variable args
            assign ambushFactionId ::temp6 
            ; line 2856
            cmp_eq ::temp0 ambushFactionId "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label10
            ; line 2857
            cmp_gt ::temp0 deadCount 0 
            jmpf ::temp0 _label11
            ; line 2859
            imul ::temp4 deadCount -2 
            assign factionPenalty ::temp4 
            ; line 2860
            callstatic intelEngine AdjustPlayerFactionStanding ::temp4 ambushFactionId factionPenalty ;2 variable args
            ; line 2861
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
            ; line 2863
          _label11:
            callstatic game GetPlayer ::temp3 ;0 variable args
            cast ::temp5 ::temp3 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp5 "Intel_FactionAmbushFaction" ;2 variable args
            jmp _label10
            ; line 2866
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
            ; line 2868
            assign i 0 
            ; line 2869
          _label15:
            cmp_lt ::temp0 i ::FactionAmbushCount_var 
            jmpf ::temp0 _label12
            ; line 2870
            array_getlement ::temp3 ::FactionAmbushActors_var i 
            cast ::temp2 None 
            cmp_eq ::temp0 ::temp3 ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label13
            ; line 2871
            array_getlement ::temp2 ::FactionAmbushActors_var i 
            callmethod IsDead ::temp2 ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label14
            ; line 2873
            array_getlement ::temp2 ::FactionAmbushActors_var i 
            callmethod SetActorValue ::temp2 ::nonevar "Aggression" 0.0 ;2 variable args
            ; line 2874
            array_getlement ::temp2 ::FactionAmbushActors_var i 
            callmethod StopCombat ::temp2 ::nonevar ;0 variable args
            jmp _label14
            ; line 2876
          _label14:
            array_getlement ::temp2 ::FactionAmbushActors_var i 
            callmethod DisableNoWait ::temp2 ::nonevar False ;1 variable args
            ; line 2877
            array_getlement ::temp2 ::FactionAmbushActors_var i 
            callmethod Delete ::temp2 ::nonevar ;0 variable args
            ; line 2878
            cast ::temp2 None 
            array_setelement ::FactionAmbushActors_var i ::temp2 
            jmp _label13
            ; line 2880
          _label13:
            iadd ::temp4 i 1 
            assign i ::temp4 
            jmp _label15
            ; line 2882
          _label12:
            assign ::FactionAmbushCount_var 0 
            ; line 2883
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
            ; line 2888
            callmethod IsSneaking ::ActiveStoryNPC_var ::temp0 ;0 variable args
            jmpf ::temp0 _label0
            ; line 2889
            callmethod StartSneaking ::ActiveStoryNPC_var ::nonevar ;0 variable args
            jmp _label0
            ; line 2893
          _label0:
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName ::temp1 ::temp2 ;0 variable args
            strcat ::temp2 "confronted " ::temp2 
            strcat ::temp2 ::temp2 " with weapon drawn, ready to attack" 
            callmethod InjectFact ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp2 ;2 variable args
            ; line 2896
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::ActiveNarration_var ::temp1 ;3 variable args
            ; line 2897
            callstatic utility Wait ::nonevar 1.5 ;1 variable args
            ; line 2900
            callmethod GetActorBase ::ActiveStoryNPC_var ::temp3 ;0 variable args
            callmethod SetEssential ::temp3 ::nonevar True ;1 variable args
            ; line 2903
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Confidence" 4.0 ;2 variable args
            ; line 2904
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod StartCombat ::ActiveStoryNPC_var ::nonevar ::temp1 ;1 variable args
            ; line 2907
            assign ::ActiveStoryType_var "ambush_combat" 
            ; line 2908
            cast ::temp4 ::ActiveStoryNPC_var 
            callstatic utility GetCurrentRealTime ::temp5 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp5 ::temp4 "Intel_CombatStartTime" ::temp5 ;3 variable args
            ; line 2909
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
            ; line 2914
            cmp_eq ::temp0 ::ActiveStoryType_var "ambush_combat" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 ::ActiveStoryNPC_var ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 2915
            return None 
            jmp _label1
            ; line 2919
          _label1:
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp3 ::temp2 "Intel_CombatStartTime" 0.0 ;3 variable args
            assign combatStart ::temp3 
            ; line 2920
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
            ; line 2921
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp5 ;0 variable args
            strcat ::temp5 "Story [ambush_combat]: " ::temp5 
            strcat ::temp5 ::temp5 " combat timed out - forcing end" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            ; line 2922
            callmethod GetActorBase ::ActiveStoryNPC_var ::temp6 ;0 variable args
            callmethod SetEssential ::temp6 ::nonevar False ;1 variable args
            ; line 2923
            callmethod StopCombat ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 2924
            callmethod StopCombatAlarm ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 2925
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Aggression" 0.0 ;2 variable args
            ; line 2926
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Confidence" 2.0 ;2 variable args
            ; line 2927
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp2 "Intel_CombatStartTime" ;2 variable args
            ; line 2928
            assign endedNPC ::ActiveStoryNPC_var 
            ; line 2929
            callstatic game GetPlayer ::temp1 ;0 variable args
            cast ::temp7 ::temp1 
            callmethod FinishArrivalWithLinger self ::nonevar endedNPC ::temp7 ;2 variable args
            ; line 2930
            return None 
            jmp _label4
            ; line 2933
          _label4:
            callmethod IsDead ::ActiveStoryNPC_var ::temp0 ;0 variable args
            jmpf ::temp0 _label5
            ; line 2934
            callmethod GetActorBase ::ActiveStoryNPC_var ::temp6 ;0 variable args
            callmethod SetEssential ::temp6 ::nonevar False ;1 variable args
            ; line 2935
            callmethod FindSlotByAgent ::Core_var ::temp8 ::ActiveStoryNPC_var ;1 variable args
            assign slot ::temp8 
            ; line 2936
            comp_gte ::temp0 slot 0 
            jmpf ::temp0 _label6
            ; line 2937
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label6
            ; line 2939
          _label6:
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 2940
            return None 
            jmp _label5
            ; line 2944
          _label5:
            callmethod IsBleedingOut ::ActiveStoryNPC_var ::temp0 ;0 variable args
            jmpf ::temp0 _label7
            ; line 2945
            callmethod OnAmbushYield self ::nonevar ;0 variable args
            ; line 2946
            return None 
            jmp _label7
            ; line 2949
          _label7:
            callmethod IsInCombat ::ActiveStoryNPC_var ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label8
            ; line 2951
            callmethod GetActorBase ::ActiveStoryNPC_var ::temp6 ;0 variable args
            callmethod SetEssential ::temp6 ::nonevar False ;1 variable args
            ; line 2952
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Aggression" 0.0 ;2 variable args
            ; line 2953
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Confidence" 2.0 ;2 variable args
            ; line 2954
            assign ::mangled_endedNPC_0 ::ActiveStoryNPC_var 
            ; line 2955
            callstatic game GetPlayer ::temp1 ;0 variable args
            cast ::temp7 ::temp1 
            callmethod FinishArrivalWithLinger self ::nonevar ::mangled_endedNPC_0 ::temp7 ;2 variable args
            ; line 2956
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
            ; line 2962
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod GetDisplayName ::temp0 ::temp1 ;0 variable args
            assign playerName ::temp1 
            ; line 2965
            callmethod GetActorBase ::ActiveStoryNPC_var ::temp2 ;0 variable args
            callmethod SetEssential ::temp2 ::nonevar False ;1 variable args
            ; line 2968
            callmethod StopCombat ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 2969
            callmethod StopCombatAlarm ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 2970
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Aggression" 0.0 ;2 variable args
            ; line 2971
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Confidence" 1.0 ;2 variable args
            ; line 2974
            callmethod RestoreActorValue ::ActiveStoryNPC_var ::nonevar "Health" 50.0 ;2 variable args
            ; line 2977
            strcat ::temp1 "was beaten in combat by " playerName 
            strcat ::temp1 ::temp1 " and yielded, begging for mercy" 
            callmethod InjectFact ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp1 ;2 variable args
            ; line 2980
            strcat ::temp1 "dropped to one knee and yielded to " playerName 
            strcat ::temp1 ::temp1 ", exhausted and beaten" 
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp1 ::temp0 ;3 variable args
            ; line 2982
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 "Story [ambush]: " ::temp1 
            strcat ::temp1 ::temp1 " yielded at " 
            callmethod GetActorValuePercentage ::ActiveStoryNPC_var ::temp3 "Health" ;1 variable args
            fmul ::temp3 ::temp3 100.0 
            cast ::temp4 ::temp3 
            strcat ::temp4 ::temp1 ::temp4 
            strcat ::temp4 ::temp4 "% health" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            ; line 2985
            assign yieldedNPC ::ActiveStoryNPC_var 
            ; line 2986
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
            ; line 2992
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod GetDisplayName ::temp0 ::temp1 ;0 variable args
            assign playerName ::temp1 
            ; line 2993
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            assign npcName ::temp1 
            ; line 2996
            callmethod IsSneaking ::ActiveStoryNPC_var ::temp2 ;0 variable args
            jmpf ::temp2 _label0
            ; line 2997
            callmethod StartSneaking ::ActiveStoryNPC_var ::nonevar ;0 variable args
            jmp _label0
            ; line 2999
          _label0:
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic debug SendAnimationEvent ::nonevar ::temp3 "sneakStop" ;2 variable args
            ; line 3002
            strcat ::temp1 "was caught secretly following " playerName 
            callmethod InjectFact ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp1 ;2 variable args
            ; line 3003
            callstatic game GetPlayer ::temp0 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::ActiveNarration_var ::temp0 ;3 variable args
            ; line 3006
            callstatic game GetPlayer ::temp0 ;0 variable args
            strcat ::temp1 npcName " was caught secretly following " 
            strcat ::temp1 ::temp1 playerName 
            callmethod SendPersistentMemory ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp0 ::temp1 ;3 variable args
            ; line 3008
            strcat ::temp1 "stalker: " npcName 
            strcat ::temp1 ::temp1 " -- caught" 
            callmethod AddRecentStoryEvent self ::nonevar ::temp1 ;1 variable args
            ; line 3011
            assign caughtNPC ::ActiveStoryNPC_var 
            ; line 3014
            callstatic game GetPlayer ::temp0 ;0 variable args
            cast ::temp3 ::temp0 
            callmethod FinishArrivalWithLinger self ::nonevar caughtNPC ::temp3 ;2 variable args
            ; line 3016
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
            .local ::temp3 form
            .local ::temp4 Float
            .local factionName String
            .local ::temp5 String
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
            ; line 3024
            jmpf ::QuestActive_var _label0
            ; line 3025
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest rejected -- one already active" ;1 variable args
            ; line 3026
            return None 
            jmp _label0
            ; line 3029
          _label0:
            callmethod ExtractJsonField self ::temp0 response "sender" ;2 variable args
            assign senderName ::temp0 
            ; line 3030
            callmethod ExtractJsonField self ::temp0 response "msgContent" ;2 variable args
            assign msgContent ::temp0 
            ; line 3031
            callmethod ExtractJsonField self ::temp0 response "questLocation" ;2 variable args
            assign questLocationStr ::temp0 
            ; line 3032
            callmethod ExtractJsonField self ::temp0 response "enemyType" ;2 variable args
            assign enemyType ::temp0 
            ; line 3035
            callmethod ExtractJsonField self ::temp0 response "questSubType" ;2 variable args
            assign questSubTypeStr ::temp0 
            ; line 3036
            callmethod ExtractJsonField self ::temp0 response "victimName" ;2 variable args
            assign victimName ::temp0 
            ; line 3037
            callmethod ExtractJsonField self ::temp0 response "itemDesc" ;2 variable args
            assign itemDesc ::temp0 
            ; line 3038
            callmethod ExtractJsonField self ::temp0 response "itemName" ;2 variable args
            assign itemName ::temp0 
            ; line 3039
            callmethod ExtractJsonField self ::temp0 response "alliedFaction" ;2 variable args
            assign alliedFaction ::temp0 
            ; line 3040
            callmethod ExtractJsonField self ::temp0 response "enemyFaction" ;2 variable args
            assign suggestedEnemy ::temp0 
            ; line 3041
            cmp_eq ::temp1 questSubTypeStr "" 
            jmpf ::temp1 _label1
            ; line 3042
            assign questSubTypeStr "combat" 
            jmp _label1
            ; line 3046
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
            ; line 3047
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Story DM: quest rejected -- Jarl " ::temp0 
            strcat ::temp0 ::temp0 " cannot deliver quest personally (needs courier)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3048
            return None 
            jmp _label5
            ; line 3051
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
            ; line 3052
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest missing questLocation or enemyType" ;1 variable args
            ; line 3053
            return None 
            jmp _label8
            ; line 3057
          _label8:
            cast ::temp2 None 
            assign victimActor ::temp2 
            ; line 3058
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
            ; line 3059
            callstatic intelEngine FindNPCByName ::temp2 victimName ;1 variable args
            assign victimActor ::temp2 
            ; line 3060
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
            ; line 3061
            strcat ::temp0 "Story DM: quest/rescue victim '" victimName 
            strcat ::temp0 ::temp0 "' not found or invalid, rejecting" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3062
            return None 
            jmp _label14
            ; line 3065
          _label14:
            cmp_eq ::temp1 victimActor npc 
            jmpf ::temp1 _label15
            ; line 3066
            strcat ::temp0 "Story DM: quest/rescue rejected -- victim '" victimName 
            strcat ::temp0 ::temp0 "' is the courier NPC" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3067
            return None 
            jmp _label15
            ; line 3069
          _label15:
            cmp_eq ::temp1 senderName "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label16
            cmp_eq ::temp1 victimName senderName 
            assign ::temp1 ::temp1 
          _label16:
            jmpf ::temp1 _label17
            ; line 3070
            strcat ::temp0 "Story DM: quest/rescue rejected -- victim '" victimName 
            strcat ::temp0 ::temp0 "' is the quest giver" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3071
            return None 
            jmp _label17
            ; line 3076
          _label17:
            callmethod IsPlayerTeammate victimActor ::temp1 ;0 variable args
            jmpf ::temp1 _label18
            ; line 3077
            strcat ::temp0 "Story DM: quest/rescue rejected -- victim '" victimName 
            strcat ::temp0 ::temp0 "' is the player's teammate" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3078
            return None 
            jmp _label18
            ; line 3081
          _label18:
            callstatic intelEngine IsActorOnStoryCooldown ::temp1 victimActor ;1 variable args
            jmpf ::temp1 _label19
            ; line 3082
            strcat ::temp0 "Story DM: quest/rescue rejected -- victim '" victimName 
            strcat ::temp0 ::temp0 "' is on story cooldown" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3083
            return None 
            jmp _label19
          _label19:
            jmp _label20
            ; line 3085
          _label11:
            cmp_eq ::temp1 questSubTypeStr "rescue" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label21
            cmp_eq ::temp1 questSubTypeStr "faction_rescue" 
            assign ::temp1 ::temp1 
          _label21:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label22
            cmp_eq ::temp1 victimName "" 
            assign ::temp1 ::temp1 
          _label22:
            jmpf ::temp1 _label20
            ; line 3086
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest/rescue rejected -- no victimName" ;1 variable args
            ; line 3087
            return None 
            jmp _label20
            ; line 3091
          _label20:
            cmp_eq ::temp1 questSubTypeStr "find_item" 
            jmpf ::temp1 _label23
            ; line 3092
            cmp_eq ::temp1 itemName "" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label24
            callstatic intelEngine ValidateQuestItem ::temp1 itemName ;1 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label24:
            jmpf ::temp1 _label25
            ; line 3094
            callstatic intelEngine GetRandomQuestItemName ::temp0 500 ;1 variable args
            assign itemName ::temp0 
            ; line 3095
            cmp_eq ::temp1 itemName "" 
            jmpf ::temp1 _label26
            ; line 3096
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest/find_item rejected -- no valid item found" ;1 variable args
            ; line 3097
            return None 
            jmp _label26
            ; line 3099
          _label26:
            strcat ::temp0 "Story DM: quest/find_item -- LLM item not found, using fallback: " itemName 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            jmp _label25
          _label25:
            jmp _label23
            ; line 3104
          _label23:
            cmp_eq ::temp1 alliedFaction "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label27
            cast ::temp2 None 
            cmp_eq ::temp1 npc ::temp2 
            assign ::temp1 ::temp1 
          _label27:
            jmpf ::temp1 _label28
            ; line 3105
            callstatic intelEngine FindFactionMember ::temp2 alliedFaction ;1 variable args
            assign factionMember ::temp2 
            ; line 3106
            cast ::temp2 None 
            cmp_eq ::temp1 factionMember ::temp2 
            jmpf ::temp1 _label29
            ; line 3107
            strcat ::temp0 "Story DM: quest/" questSubTypeStr 
            strcat ::temp0 ::temp0 " rejected -- no loaded " 
            strcat ::temp0 ::temp0 alliedFaction 
            strcat ::temp0 ::temp0 " member found" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3108
            return None 
            jmp _label29
            ; line 3111
          _label29:
            cast ::temp2 None 
            cmp_eq ::temp1 victimActor ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label30
            cmp_eq ::temp1 factionMember victimActor 
            assign ::temp1 ::temp1 
          _label30:
            jmpf ::temp1 _label31
            ; line 3112
            strcat ::temp0 "Story DM: quest/" questSubTypeStr 
            strcat ::temp0 ::temp0 " rejected -- only loaded " 
            strcat ::temp0 ::temp0 alliedFaction 
            strcat ::temp0 ::temp0 " member is the rescue victim" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3113
            return None 
            jmp _label31
            ; line 3115
          _label31:
            assign npc factionMember 
            ; line 3118
            cast ::temp3 npc 
            callmethod GetActorValue npc ::temp4 "Aggression" ;1 variable args
            callstatic storageUtil SetFloatValue ::temp4 ::temp3 "Intel_OrigAggression" ::temp4 ;3 variable args
            ; line 3119
            callmethod SetActorValue npc ::nonevar "Aggression" 0.0 ;2 variable args
            ; line 3122
            callstatic intelEngine GetFactionDisplayName ::temp0 alliedFaction ;1 variable args
            assign factionName ::temp0 
            ; line 3123
            callmethod BuildFactionQuestNarration self ::temp0 factionName questLocationStr ;2 variable args
            assign narration ::temp0 
            ; line 3124
            strcat ::temp0 "Story DM: quest/" questSubTypeStr 
            strcat ::temp0 ::temp0 " -- faction member " 
            callmethod GetDisplayName npc ::temp5 ;0 variable args
            strcat ::temp5 ::temp0 ::temp5 
            strcat ::temp5 ::temp5 " selected for " 
            strcat ::temp5 ::temp5 alliedFaction 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            ; line 3126
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDisplayName ::temp2 ::temp5 ;0 variable args
            assign playerName2 ::temp5 
            ; line 3127
            callstatic intelEngine NPCKnowsPlayer ::temp1 npc ;1 variable args
            jmpf ::temp1 _label32
            ; line 3128
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDisplayName npc ::temp5 ;0 variable args
            strcat ::temp5 ::temp5 " set out to find " 
            strcat ::temp5 ::temp5 playerName2 
            strcat ::temp5 ::temp5 " with urgent orders from " 
            strcat ::temp5 ::temp5 factionName 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc ::temp2 ::temp5 ;3 variable args
            jmp _label33
            ; line 3130
          _label32:
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDisplayName npc ::temp5 ;0 variable args
            strcat ::temp5 ::temp5 " was sent to find a warrior described as '" 
            strcat ::temp5 ::temp5 playerName2 
            strcat ::temp5 ::temp5 "' — never met them personally, only knows them by reputation and description" 
            callmethod SendPersistentMemory ::Core_var ::nonevar npc ::temp2 ::temp5 ;3 variable args
            ; line 3131
            strcat ::temp5 "has never met " playerName2 
            strcat ::temp5 ::temp5 " before — was given a physical description and told to look for them. Should introduce themselves and confirm identity before delivering the message." 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp5 ;2 variable args
          _label33:
            jmp _label28
            ; line 3135
          _label28:
            callstatic intelEngine ResolveAnyDestination ::temp6 npc questLocationStr ;2 variable args
            assign questDest ::temp6 
            ; line 3136
            cast ::temp6 None 
            cmp_eq ::temp1 questDest ::temp6 
            jmpf ::temp1 _label34
            ; line 3137
            strcat ::temp5 "Story DM: quest location '" questLocationStr 
            strcat ::temp5 ::temp5 "' could not be resolved" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            ; line 3138
            return None 
            jmp _label34
            ; line 3140
          _label34:
            callstatic intelEngine IsLocationNonCombative ::temp1 questDest ;1 variable args
            jmpf ::temp1 _label35
            ; line 3141
            strcat ::temp5 "Story DM: quest location '" questLocationStr 
            strcat ::temp5 ::temp5 "' is non-combative (temple/castle/guild) — rejecting" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            ; line 3142
            return None 
            jmp _label35
            ; line 3147
          _label35:
            callmethod FindFreeAgentSlot ::Core_var ::temp7 ;0 variable args
            cmp_lt ::temp1 ::temp7 0 
            jmpf ::temp1 _label36
            ; line 3148
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest rejected -- no free slots" ;1 variable args
            ; line 3149
            return None 
            jmp _label36
            ; line 3153
          _label36:
            assign questGiverActor npc 
            ; line 3154
            cmp_eq ::temp1 senderName "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label37
            ; line 3155
            callstatic intelEngine FindNPCByName ::temp2 senderName ;1 variable args
            assign senderActor ::temp2 
            ; line 3156
            cast ::temp2 None 
            cmp_eq ::temp1 senderActor ::temp2 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label38
            ; line 3157
            assign questGiverActor senderActor 
            jmp _label38
          _label38:
            jmp _label37
            ; line 3164
          _label37:
            cmp_eq ::temp1 alliedFaction "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label39
            cast ::temp2 None 
            cmp_eq ::temp1 questGiverActor ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label39:
            jmpf ::temp1 _label40
            ; line 3165
            callstatic intelEngine GetNPCPoliticalFactionId ::temp5 questGiverActor ;1 variable args
            assign giverFaction ::temp5 
            ; line 3166
            cmp_eq ::temp1 giverFaction alliedFaction 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label41
            ; line 3167
            callstatic intelEngine FindFactionMember ::temp2 alliedFaction ;1 variable args
            assign factionSub ::temp2 
            ; line 3168
            cast ::temp2 None 
            cmp_eq ::temp1 factionSub ::temp2 
            jmpf ::temp1 _label42
            ; line 3169
            strcat ::temp5 "Story DM: quest/" questSubTypeStr 
            strcat ::temp5 ::temp5 " rejected -- no loaded " 
            strcat ::temp5 ::temp5 alliedFaction 
            strcat ::temp5 ::temp5 " member found" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            ; line 3170
            return None 
            jmp _label42
            ; line 3172
          _label42:
            cast ::temp2 None 
            cmp_eq ::temp1 victimActor ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label43
            cmp_eq ::temp1 factionSub victimActor 
            assign ::temp1 ::temp1 
          _label43:
            jmpf ::temp1 _label44
            ; line 3173
            strcat ::temp5 "Story DM: quest/" questSubTypeStr 
            strcat ::temp5 ::temp5 " rejected -- only loaded " 
            strcat ::temp5 ::temp5 alliedFaction 
            strcat ::temp5 ::temp5 " member is the rescue victim" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp5 ;1 variable args
            ; line 3174
            return None 
            jmp _label44
            ; line 3176
          _label44:
            callmethod ApplyCooldownCheck self ::temp1 factionSub ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label45
            ; line 3177
            strcat ::temp5 "Story DM: quest/" questSubTypeStr 
            strcat ::temp5 ::temp5 " rejected -- substitute faction member " 
            callmethod GetDisplayName factionSub ::temp0 ;0 variable args
            strcat ::temp0 ::temp5 ::temp0 
            strcat ::temp0 ::temp0 " on cooldown" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3178
            return None 
            jmp _label45
            ; line 3180
          _label45:
            strcat ::temp0 "Story DM: quest/" questSubTypeStr 
            strcat ::temp0 ::temp0 " -- substituting " 
            callmethod GetDisplayName questGiverActor ::temp5 ;0 variable args
            strcat ::temp5 ::temp0 ::temp5 
            strcat ::temp5 ::temp5 " with faction member " 
            callmethod GetDisplayName factionSub ::temp0 ;0 variable args
            strcat ::temp0 ::temp5 ::temp0 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3181
            assign questGiverActor factionSub 
            ; line 3182
            assign npc factionSub 
            ; line 3183
            callstatic intelEngine GetFactionDisplayName ::temp0 alliedFaction ;1 variable args
            assign factionName2 ::temp0 
            ; line 3184
            callmethod BuildFactionQuestNarration self ::temp0 factionName2 questLocationStr ;2 variable args
            assign narration ::temp0 
            jmp _label41
          _label41:
            jmp _label40
            ; line 3189
          _label40:
            cmp_eq ::temp1 questSubTypeStr "faction_battle" 
            jmpf ::temp1 _label46
            ; line 3190
            propget Battle ::Core_var ::temp8 
            cast ::temp9 None 
            cmp_eq ::temp1 ::temp8 ::temp9 
            jmpf ::temp1 _label47
            ; line 3191
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest/faction_battle rejected -- Battle quest not set (check CK property)" ;1 variable args
            ; line 3192
            return None 
            jmp _label47
            ; line 3194
          _label47:
            callstatic intelEngine ValidateFactionBattleDispatch ::temp0 alliedFaction suggestedEnemy ;2 variable args
            assign validateJson ::temp0 
            ; line 3195
            callstatic intelEngine StoryResponseGetField ::temp0 validateJson "canStart" ;2 variable args
            cmp_eq ::temp1 ::temp0 "true" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label48
            ; line 3196
            callstatic intelEngine StoryResponseGetField ::temp0 validateJson "failReason" ;2 variable args
            strcat ::temp0 "Story DM: quest/faction_battle rejected -- " ::temp0 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3197
            return None 
            jmp _label48
            ; line 3200
          _label48:
            callstatic intelEngine StoryResponseGetField ::temp0 validateJson "enemyFaction" ;2 variable args
            assign ::QuestBattleEnemyFaction_var ::temp0 
            ; line 3201
            strcat ::temp0 "Story DM: faction_battle enemy = " ::QuestBattleEnemyFaction_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3203
            propget Battle ::Core_var ::temp9 
            propget BattleScheduled ::temp9 ::temp1 
            jmpf ::temp1 _label49
            ; line 3204
            callmethod DebugMsg ::Core_var ::nonevar "Story DM: quest/faction_battle rejected -- battle system busy (scheduled)" ;1 variable args
            ; line 3205
            return None 
            jmp _label49
          _label49:
            jmp _label46
            ; line 3210
          _label46:
            cmp_eq ::temp1 questSubTypeStr "faction_battle" 
            jmpf ::temp1 _label50
            ; line 3211
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDisplayName ::temp2 ::temp0 ;0 variable args
            callstatic intelEngine BuildFactionBattleDispatchFact ::temp0 alliedFaction questLocationStr ::temp0 ;3 variable args
            callmethod InjectFact ::Core_var ::nonevar questGiverActor ::temp0 ;2 variable args
            jmp _label51
            ; line 3213
          _label50:
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDisplayName ::temp2 ::temp0 ;0 variable args
            strcat ::temp0 "asked " ::temp0 
            strcat ::temp0 ::temp0 " for help: " 
            strcat ::temp0 ::temp0 msgContent 
            callmethod InjectFact ::Core_var ::nonevar questGiverActor ::temp0 ;2 variable args
            ; line 3217
          _label51:
            cmp_eq ::temp1 questGiverActor npc 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label52
            ; line 3218
            callmethod GetDisplayName questGiverActor ::temp0 ;0 variable args
            strcat ::temp0 "was sent to deliver a plea for help from " ::temp0 
            strcat ::temp0 ::temp0 " about " 
            strcat ::temp0 ::temp0 enemyType 
            strcat ::temp0 ::temp0 " trouble near " 
            strcat ::temp0 ::temp0 questLocationStr 
            callmethod InjectFact ::Core_var ::nonevar npc ::temp0 ;2 variable args
            jmp _label52
            ; line 3222
          _label52:
            assign ::QuestActive_var True 
            ; line 3223
            assign ::QuestGiver_var questGiverActor 
            ; line 3224
            assign ::QuestLocation_var questDest 
            ; line 3225
            assign ::QuestEnemyType_var enemyType 
            ; line 3226
            assign ::QuestLocationName_var questLocationStr 
            ; line 3227
            assign ::QuestEnemiesSpawned_var False 
            ; line 3228
            assign ::QuestGuideActive_var False 
            ; line 3229
            assign ::QuestGuideWaiting_var False 
            ; line 3230
            callstatic utility GetCurrentGameTime ::temp4 ;0 variable args
            assign ::QuestStartTime_var ::temp4 
            ; line 3231
            assign ::QuestSpawnCount_var 0 
            ; line 3236
            assign ::QuestAlliedFaction_var alliedFaction 
            ; line 3241
            cmp_eq ::temp1 alliedFaction "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label53
            ; line 3242
            callstatic intelEngine RemovePlayerCrimeFactions ::nonevar ;0 variable args
            jmp _label53
            ; line 3244
          _label53:
            cmp_eq ::temp1 questSubTypeStr "faction_combat" 
            jmpf ::temp1 _label54
            ; line 3245
            assign questSubTypeStr "combat" 
            jmp _label55
            ; line 3246
          _label54:
            cmp_eq ::temp1 questSubTypeStr "faction_rescue" 
            jmpf ::temp1 _label55
            ; line 3247
            assign questSubTypeStr "rescue" 
            jmp _label55
            ; line 3251
          _label55:
            cmp_eq ::temp1 questSubTypeStr "rescue" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label56
            cast ::temp2 None 
            cmp_eq ::temp1 victimActor ::temp2 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label56:
            jmpf ::temp1 _label57
            ; line 3252
            strcat ::temp0 "was captured by " enemyType 
            strcat ::temp0 ::temp0 " near " 
            strcat ::temp0 ::temp0 questLocationStr 
            strcat ::temp0 ::temp0 " and held against my will" 
            callmethod InjectFact ::Core_var ::nonevar victimActor ::temp0 ;2 variable args
            jmp _label57
            ; line 3256
          _label57:
            assign ::QuestSubType_var questSubTypeStr 
            ; line 3257
            assign ::QuestBriefing_var msgContent 
            ; line 3258
            assign ::QuestVictimNPC_var victimActor 
            ; line 3259
            assign ::QuestVictimName_var victimName 
            ; line 3260
            assign ::QuestItemDesc_var itemDesc 
            ; line 3261
            assign ::QuestItemName_var itemName 
            ; line 3262
            assign ::QuestVictimFreed_var False 
            ; line 3263
            cast ::temp6 None 
            assign ::QuestItemChest_var ::temp6 
            ; line 3266
            cmp_eq ::temp1 questLocationStr "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label58
            ; line 3267
            callstatic intelEngine NotifyQuestLocationUsed ::nonevar questLocationStr ;1 variable args
            jmp _label58
            ; line 3269
          _label58:
            cmp_eq ::temp1 questSubTypeStr "find_item" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label59
            cmp_eq ::temp1 itemName "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label59:
            jmpf ::temp1 _label60
            ; line 3270
            callstatic intelEngine NotifyQuestItemUsed ::nonevar itemName ;1 variable args
            jmp _label60
            ; line 3272
          _label60:
            cmp_eq ::temp1 questSubTypeStr "rescue" 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label61
            cmp_eq ::temp1 victimName "" 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label61:
            jmpf ::temp1 _label62
            ; line 3273
            callstatic intelEngine NotifyRescueVictimUsed ::nonevar victimName ;1 variable args
            jmp _label62
            ; line 3276
          _label62:
            cast ::temp3 npc 
            callstatic storageUtil SetStringValue ::temp0 ::temp3 "Intel_MessageSender" senderName ;3 variable args
            ; line 3277
            cast ::temp3 npc 
            callstatic storageUtil SetStringValue ::temp0 ::temp3 "Intel_MessageContent" msgContent ;3 variable args
            ; line 3278
            cast ::temp3 npc 
            callstatic storageUtil SetStringValue ::temp0 ::temp3 "Intel_QuestLocation" questLocationStr ;3 variable args
            ; line 3282
            callmethod GetDisplayName questGiverActor ::temp0 ;0 variable args
            callstatic intelEngine NotifyQuestActive ::nonevar ::QuestLocationName_var ::QuestSubType_var ::QuestEnemyType_var ::temp0 msgContent victimName itemName alliedFaction ;8 variable args
            ; line 3284
            assign ::ActiveStoryType_var "quest" 
            ; line 3285
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
            ; line 3289
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_MessageSender" "" ;3 variable args
            assign senderName ::temp1 
            ; line 3290
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_MessageContent" "" ;3 variable args
            assign msgContent ::temp1 
            ; line 3291
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil GetStringValue ::temp1 ::temp0 "Intel_QuestLocation" "" ;3 variable args
            assign questLoc ::temp1 
            ; line 3294
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp2 ::temp0 "Intel_MessageSender" ;2 variable args
            ; line 3295
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp2 ::temp0 "Intel_MessageContent" ;2 variable args
            ; line 3296
            cast ::temp0 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp2 ::temp0 "Intel_QuestLocation" ;2 variable args
            ; line 3299
            assign fullNarration "" 
            ; line 3300
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
            ; line 3301
            strcat ::temp1 "delivered word from " senderName 
            strcat ::temp1 ::temp1 ": " 
            strcat ::temp1 ::temp1 msgContent 
            assign fullNarration ::temp1 
            jmp _label2
            ; line 3303
          _label1:
            assign fullNarration ::ActiveNarration_var 
            ; line 3305
          _label2:
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var fullNarration ::temp3 ;3 variable args
            ; line 3307
            cmp_eq ::temp2 senderName "" 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label3
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            cmp_eq ::temp2 senderName ::temp1 
            assign ::temp2 ::temp2 
          _label3:
            assign isDirect ::temp2 
            ; line 3315
            assign ::IsActive_var False 
            ; line 3319
            cast ::temp4 ::ActiveStoryNPC_var 
            cast ::temp5 ::ActiveStoryNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp6 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp4 ::temp5 ::temp6 ;3 variable args
            ; line 3320
            propget SandboxNearPlayerPackage ::Core_var ::temp7 
            propget PRIORITY_TRAVEL ::Core_var ::temp8 
            callstatic actorUtil AddPackageOverride ::nonevar ::ActiveStoryNPC_var ::temp7 ::temp8 1 ;4 variable args
            ; line 3321
            callmethod EvaluatePackage ::ActiveStoryNPC_var ::nonevar ;0 variable args
            ; line 3323
            callstatic utility Wait ::nonevar 8.0 ;1 variable args
            ; line 3324
            callstatic debug Notification ::nonevar "They seem to have more to ask..." ;1 variable args
            ; line 3326
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
            ; line 3327
            cast ::temp3 None 
            cmp_eq ::temp2 ::ActiveStoryNPC_var ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label7
            ; line 3328
            callmethod FindSlotByAgent ::Core_var ::temp8 ::ActiveStoryNPC_var ;1 variable args
            assign questSlot ::temp8 
            ; line 3329
            comp_gte ::temp2 questSlot 0 
            jmpf ::temp2 _label8
            ; line 3330
            callmethod ClearSlot ::Core_var ::nonevar questSlot True False ;3 variable args
            jmp _label8
            ; line 3332
          _label8:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            jmp _label7
            ; line 3334
          _label7:
            callmethod CleanupQuest self ::nonevar ;0 variable args
            ; line 3335
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 3336
            return None 
            jmp _label6
            ; line 3339
          _label6:
            callmethod FindSlotByAgent ::Core_var ::temp8 ::ActiveStoryNPC_var ;1 variable args
            cmp_lt ::temp2 ::temp8 0 
            jmpf ::temp2 _label9
            ; line 3340
            callmethod CleanupQuest self ::nonevar ;0 variable args
            ; line 3341
            callmethod CleanupStoryDispatch self ::nonevar ;0 variable args
            ; line 3342
            return None 
            jmp _label9
            ; line 3345
          _label9:
            propget SandboxNearPlayerPackage ::Core_var ::temp7 
            callstatic actorUtil RemovePackageOverride ::temp2 ::ActiveStoryNPC_var ::temp7 ;2 variable args
            ; line 3347
            assign questPromptText "" 
            ; line 3348
            cmp_eq ::temp2 ::QuestSubType_var "rescue" 
            jmpf ::temp2 _label10
            ; line 3349
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp1 " pleads for help rescuing " 
            strcat ::temp1 ::temp1 ::QuestVictimName_var 
            strcat ::temp1 ::temp1 " near " 
            strcat ::temp1 ::temp1 questLoc 
            strcat ::temp1 ::temp1 "." 
            assign questPromptText ::temp1 
            jmp _label11
            ; line 3350
          _label10:
            cmp_eq ::temp2 ::QuestSubType_var "find_item" 
            jmpf ::temp2 _label12
            ; line 3351
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp1 " tells you about " 
            strcat ::temp1 ::temp1 ::QuestItemDesc_var 
            strcat ::temp1 ::temp1 " near " 
            strcat ::temp1 ::temp1 questLoc 
            strcat ::temp1 ::temp1 "." 
            assign questPromptText ::temp1 
            jmp _label11
            ; line 3352
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
            ; line 3353
            callstatic intelEngine GetFactionDisplayName ::temp1 ::QuestAlliedFaction_var ;1 variable args
            assign allyName ::temp1 
            ; line 3354
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp1 " rallies you to fight alongside the " 
            strcat ::temp1 ::temp1 allyName 
            strcat ::temp1 ::temp1 " near " 
            strcat ::temp1 ::temp1 questLoc 
            strcat ::temp1 ::temp1 "." 
            assign questPromptText ::temp1 
            jmp _label11
            ; line 3355
          _label15:
            cmp_eq ::temp2 ::QuestAlliedFaction_var "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label16
            cmp_eq ::temp2 ::QuestSubType_var "rescue" 
            assign ::temp2 ::temp2 
          _label16:
            jmpf ::temp2 _label17
            ; line 3356
            callstatic intelEngine GetFactionDisplayName ::temp1 ::QuestAlliedFaction_var ;1 variable args
            assign allyName2 ::temp1 
            ; line 3357
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
            ; line 3359
          _label17:
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 ::temp1 " tells you about trouble near " 
            strcat ::temp1 ::temp1 questLoc 
            strcat ::temp1 ::temp1 "." 
            assign questPromptText ::temp1 
            ; line 3362
          _label11:
            assign choice "" 
            ; line 3365
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
            ; line 3366
            jmpf canGuide _label20
            ; line 3367
            callstatic skyMessage Show ::temp1 questPromptText "Lead the way" "I'll go alone" "Not interested" "" "" "" "" "" "" "" False 0.100000001 0.0 ;14 variable args
            assign choice ::temp1 
            jmp _label21
            ; line 3369
          _label20:
            callstatic skyMessage Show ::temp1 questPromptText "I'll check it out" "Not interested" "" "" "" "" "" "" "" "" False 0.100000001 0.0 ;14 variable args
            assign choice ::temp1 
            ; line 3371
            cmp_eq ::temp2 choice "I'll check it out" 
            jmpf ::temp2 _label21
            ; line 3372
            assign choice "I'll go alone" 
            jmp _label21
            ; line 3375
          _label21:
            cmp_eq ::temp2 choice "Lead the way" 
            jmpf ::temp2 _label22
            ; line 3376
            callmethod PrePlaceQuestTargets self ::nonevar ;0 variable args
            ; line 3377
            callmethod PlaceQuestMarker self ::nonevar ;0 variable args
            ; line 3378
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp1 ;0 variable args
            strcat ::temp1 "quest: " ::temp1 
            strcat ::temp1 ::temp1 " guiding to " 
            strcat ::temp1 ::temp1 questLoc 
            callmethod AddRecentStoryEvent self ::nonevar ::temp1 ;1 variable args
            ; line 3379
            callmethod BeginQuestGuide self ::nonevar ::ActiveStoryNPC_var ;1 variable args
            ; line 3380
            return None 
            jmp _label23
            ; line 3381
          _label22:
            cmp_eq ::temp2 choice "Not interested" 
            jmpf ::temp2 _label23
            ; line 3383
            assign refusedNPC ::ActiveStoryNPC_var 
            ; line 3384
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod GetDisplayName ::temp3 ::temp1 ;0 variable args
            strcat ::temp1 "was told that " ::temp1 
            strcat ::temp1 ::temp1 " wasn't interested in helping" 
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar refusedNPC ::temp1 ::temp3 ;3 variable args
            ; line 3386
            cast ::temp3 None 
            cmp_eq ::temp2 ::QuestGiver_var ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label24
            ; line 3387
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod GetDisplayName ::temp3 ::temp1 ;0 variable args
            strcat ::temp1 "learned that " ::temp1 
            strcat ::temp1 ::temp1 " refused to help with the " 
            strcat ::temp1 ::temp1 ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " threat at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp1 ;2 variable args
            jmp _label24
            ; line 3389
          _label24:
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 3390
            callmethod CleanupQuest self ::nonevar ;0 variable args
            ; line 3391
            callstatic game GetPlayer ::temp3 ;0 variable args
            cast ::temp5 ::temp3 
            callmethod FinishArrivalWithLinger self ::nonevar refusedNPC ::temp5 ;2 variable args
            ; line 3392
            return None 
            jmp _label23
            ; line 3395
          _label23:
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod GetDisplayName ::temp3 ::temp1 ;0 variable args
            strcat ::temp1 "was told that " ::temp1 
            strcat ::temp1 ::temp1 " would handle it" 
            callstatic game GetPlayer ::temp3 ;0 variable args
            callmethod SendTaskNarration ::Core_var ::nonevar ::ActiveStoryNPC_var ::temp1 ::temp3 ;3 variable args
            ; line 3396
            strcat ::temp1 "Quest: " msgContent 
            strcat ::temp1 ::temp1 " [" 
            strcat ::temp1 ::temp1 questLoc 
            strcat ::temp1 ::temp1 "]" 
            callmethod NotifyPlayer ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 3399
            callmethod PrePlaceQuestTargets self ::nonevar ;0 variable args
            ; line 3401
            callmethod PlaceQuestMarker self ::nonevar ;0 variable args
            ; line 3402
            strcat ::temp1 "quest: " ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " at " 
            strcat ::temp1 ::temp1 questLoc 
            callmethod AddRecentStoryEvent self ::nonevar ::temp1 ;1 variable args
            ; line 3405
            assign ::ActiveStoryType_var "" 
            ; line 3406
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
            ; line 3415
            assign ::QuestGuideNPC_var guideNPC 
            ; line 3416
            assign ::QuestGuideActive_var True 
            ; line 3417
            assign ::QuestGuideWaiting_var False 
            ; line 3418
            callstatic utility GetCurrentGameTime ::temp0 ;0 variable args
            assign ::QuestGuideStartTime_var ::temp0 
            ; line 3421
            assign ::ActiveStoryType_var "quest_guide" 
            ; line 3422
            assign ::ActiveStoryNPC_var guideNPC 
            ; line 3423
            assign ::IsActive_var True 
            ; line 3424
            callstatic utility GetCurrentGameTime ::temp0 ;0 variable args
            callstatic intelEngine MarkSystemPending ::nonevar "storyDM" ::temp0 ;2 variable args
            ; line 3428
            callmethod DismissFollowerForTask ::Core_var ::nonevar guideNPC ;1 variable args
            ; line 3429
            cast ::temp1 guideNPC 
            propget IntelEngine_TravelTarget ::Core_var ::temp2 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp1 ::QuestLocation_var ::temp2 ;3 variable args
            ; line 3430
            propget TravelPackage_Jog ::Core_var ::temp3 
            propget PRIORITY_TRAVEL ::Core_var ::temp4 
            callstatic actorUtil AddPackageOverride ::nonevar guideNPC ::temp3 ::temp4 1 ;4 variable args
            ; line 3431
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 3432
            callmethod EvaluatePackage guideNPC ::nonevar ;0 variable args
            ; line 3435
            callmethod FindSlotByAgent ::Core_var ::temp4 guideNPC ;1 variable args
            assign slot ::temp4 
            ; line 3436
            comp_gte ::temp5 slot 0 
            jmpf ::temp5 _label0
            ; line 3437
            callmethod InitializeStuckTrackingForSlot ::Core_var ::nonevar slot guideNPC ;2 variable args
            ; line 3438
            callmethod InitOffScreenTracking ::Core_var ::nonevar slot guideNPC ::QuestLocation_var ;3 variable args
            jmp _label0
            ; line 3441
          _label0:
            assign guideDist 0.0 
            ; line 3442
            callmethod Is3DLoaded ::QuestLocation_var ::temp5 ;0 variable args
            assign ::temp5 ::temp5 
            jmpf ::temp5 _label1
            callmethod Is3DLoaded guideNPC ::temp5 ;0 variable args
            assign ::temp5 ::temp5 
          _label1:
            jmpf ::temp5 _label2
            ; line 3443
            callmethod GetDistance guideNPC ::temp0 ::QuestLocation_var ;1 variable args
            assign guideDist ::temp0 
            jmp _label2
            ; line 3445
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
            ; line 3446
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
            ; line 3451
            not ::temp0 ::QuestGuideActive_var 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cast ::temp1 None 
            cmp_eq ::temp0 ::QuestGuideNPC_var ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 3452
            return None 
            jmp _label1
            ; line 3456
          _label1:
            callstatic utility GetCurrentGameTime ::temp2 ;0 variable args
            fsub ::temp2 ::temp2 ::QuestGuideStartTime_var 
            fmul ::temp2 ::temp2 24.0 
            assign guideElapsed ::temp2 
            ; line 3457
            propget QUEST_GUIDE_TIMEOUT_HOURS self ::temp2 
            cmp_gt ::temp0 guideElapsed ::temp2 
            jmpf ::temp0 _label2
            ; line 3458
            cast ::temp3 guideElapsed 
            strcat ::temp3 "Story [quest_guide]: guide timed out after " ::temp3 
            strcat ::temp3 ::temp3 " hours" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 3459
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestGuideNPC_var False ;2 variable args
            ; line 3460
            callmethod FindSlotByAgent ::Core_var ::temp4 ::QuestGuideNPC_var ;1 variable args
            assign slot ::temp4 
            ; line 3461
            comp_gte ::temp0 slot 0 
            jmpf ::temp0 _label3
            ; line 3462
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label3
            ; line 3464
          _label3:
            assign ::QuestGuideActive_var False 
            ; line 3465
            assign ::QuestGuideWaiting_var False 
            ; line 3466
            assign ::ActiveStoryType_var "" 
            ; line 3467
            assign ::IsActive_var False 
            ; line 3468
            callmethod StartStoryLinger self ::nonevar ::QuestGuideNPC_var ;1 variable args
            ; line 3469
            return None 
            jmp _label2
            ; line 3472
          _label2:
            callstatic game GetPlayer ::temp1 ;0 variable args
            assign player ::temp1 
            ; line 3473
            callmethod FindSlotByAgent ::Core_var ::temp4 ::QuestGuideNPC_var ;1 variable args
            assign ::mangled_slot_0 ::temp4 
            ; line 3476
            callmethod Is3DLoaded ::QuestGuideNPC_var ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label4
            ; line 3477
            comp_gte ::temp0 ::mangled_slot_0 0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label5
            callmethod HandleOffScreenTravel ::Core_var ::temp0 ::mangled_slot_0 ::QuestGuideNPC_var ::QuestLocation_var ;3 variable args
            assign ::temp0 ::temp0 
          _label5:
            jmpf ::temp0 _label6
            ; line 3479
            propget TELEPORT_OFFSET_INTERIOR self ::temp2 
            callstatic intelEngine GetOffsetBehind ::temp5 ::QuestLocation_var ::temp2 ;2 variable args
            assign offset ::temp5 
            ; line 3480
            array_getlement ::temp2 offset 0 
            array_getlement ::temp6 offset 1 
            callmethod MoveTo ::QuestGuideNPC_var ::nonevar ::QuestLocation_var ::temp2 ::temp6 0.0 False ;5 variable args
            ; line 3481
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestGuideNPC_var False ;2 variable args
            ; line 3482
            cast ::temp7 ::QuestGuideNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp8 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp7 ::QuestLocation_var ::temp8 ;3 variable args
            ; line 3483
            propget TravelPackage_Jog ::Core_var ::temp9 
            propget PRIORITY_TRAVEL ::Core_var ::temp4 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestGuideNPC_var ::temp9 ::temp4 1 ;4 variable args
            ; line 3484
            callmethod EvaluatePackage ::QuestGuideNPC_var ::nonevar ;0 variable args
            ; line 3485
            strcat ::temp3 "Story [quest_guide]: off-screen arrival near " ::QuestLocationName_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label6
            ; line 3487
          _label6:
            return None 
            jmp _label4
            ; line 3490
          _label4:
            cast ::temp7 player 
            callmethod GetDistance ::QuestGuideNPC_var ::temp6 ::temp7 ;1 variable args
            assign distToPlayer ::temp6 
            ; line 3493
            assign guideArrived False 
            ; line 3494
            callmethod Is3DLoaded ::QuestLocation_var ::temp0 ;0 variable args
            jmpf ::temp0 _label7
            ; line 3495
            callmethod GetDistance ::QuestGuideNPC_var ::temp6 ::QuestLocation_var ;1 variable args
            assign distToDest ::temp6 
            ; line 3496
            propget ARRIVAL_DISTANCE ::Core_var ::temp6 
            cmp_lte ::temp0 distToDest ::temp6 
            jmpf ::temp0 _label8
            ; line 3497
            assign guideArrived True 
            jmp _label8
          _label8:
            jmp _label7
            ; line 3501
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
            ; line 3502
            callmethod GetParentCell ::QuestLocation_var ::temp11 ;0 variable args
            assign questCell ::temp11 
            ; line 3503
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
            ; line 3504
            assign guideArrived True 
            ; line 3505
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest_guide]: same-cell arrival fallback triggered" ;1 variable args
            jmp _label12
          _label12:
            jmp _label10
            ; line 3509
          _label10:
            not ::temp0 guideArrived 
            jmpf ::temp0 _label13
            ; line 3510
            callmethod GetCurrentLocation ::QuestLocation_var ::temp12 ;0 variable args
            assign questLoc ::temp12 
            ; line 3511
            cast ::temp12 None 
            cmp_eq ::temp0 questLoc ::temp12 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label14
            callmethod IsInLocation ::QuestGuideNPC_var ::temp0 questLoc ;1 variable args
            assign ::temp0 ::temp0 
          _label14:
            jmpf ::temp0 _label15
            ; line 3512
            assign guideArrived True 
            ; line 3513
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest_guide]: BGSLocation arrival fallback triggered" ;1 variable args
            jmp _label15
          _label15:
            jmp _label13
            ; line 3516
          _label13:
            jmpf guideArrived _label16
            ; line 3517
            callmethod OnQuestGuideArrived self ::nonevar ;0 variable args
            ; line 3518
            return None 
            jmp _label16
            ; line 3522
          _label16:
            comp_gte ::temp0 ::mangled_slot_0 0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label17
            not ::temp0 ::QuestGuideWaiting_var 
            assign ::temp0 ::temp0 
          _label17:
            jmpf ::temp0 _label18
            ; line 3523
            propget STUCK_DISTANCE_THRESHOLD ::Core_var ::temp6 
            callstatic intelEngine CheckStuckStatus ::temp4 ::QuestGuideNPC_var ::mangled_slot_0 ::temp6 ;3 variable args
            assign stuckStatus ::temp4 
            ; line 3524
            cmp_eq ::temp0 stuckStatus 1 
            jmpf ::temp0 _label19
            ; line 3525
            callmethod SoftStuckRecovery ::Core_var ::nonevar ::QuestGuideNPC_var ::mangled_slot_0 ::QuestLocation_var ;3 variable args
            jmp _label20
            ; line 3526
          _label19:
            comp_gte ::temp0 stuckStatus 3 
            jmpf ::temp0 _label20
            ; line 3528
            propget TELEPORT_OFFSET_INTERIOR self ::temp6 
            callstatic intelEngine GetOffsetBehind ::temp5 ::QuestLocation_var ::temp6 ;2 variable args
            assign ::mangled_offset_0 ::temp5 
            ; line 3529
            array_getlement ::temp6 ::mangled_offset_0 0 
            array_getlement ::temp2 ::mangled_offset_0 1 
            callmethod MoveTo ::QuestGuideNPC_var ::nonevar ::QuestLocation_var ::temp6 ::temp2 0.0 False ;5 variable args
            ; line 3530
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestGuideNPC_var False ;2 variable args
            ; line 3531
            cast ::temp7 ::QuestGuideNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp8 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp7 ::QuestLocation_var ::temp8 ;3 variable args
            ; line 3532
            propget TravelPackage_Jog ::Core_var ::temp9 
            propget PRIORITY_TRAVEL ::Core_var ::temp4 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestGuideNPC_var ::temp9 ::temp4 1 ;4 variable args
            ; line 3533
            callmethod EvaluatePackage ::QuestGuideNPC_var ::nonevar ;0 variable args
            ; line 3534
            strcat ::temp3 "Story [quest_guide]: hard stuck - teleported near " ::QuestLocationName_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label20
          _label20:
            jmp _label18
            ; line 3539
          _label18:
            not ::temp0 ::QuestGuideWaiting_var 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label21
            propget QUEST_GUIDE_WAIT_DIST self ::temp2 
            cmp_gt ::temp0 distToPlayer ::temp2 
            assign ::temp0 ::temp0 
          _label21:
            jmpf ::temp0 _label22
            ; line 3540
            assign ::QuestGuideWaiting_var True 
            ; line 3541
            propget TravelPackage_Jog ::Core_var ::temp9 
            callstatic actorUtil RemovePackageOverride ::temp0 ::QuestGuideNPC_var ::temp9 ;2 variable args
            ; line 3544
            cast ::temp7 ::QuestGuideNPC_var 
            cast ::temp13 ::QuestGuideNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp8 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp7 ::temp13 ::temp8 ;3 variable args
            ; line 3545
            propget SandboxNearPlayerPackage ::Core_var ::temp9 
            propget PRIORITY_SANDBOX ::Core_var ::temp4 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestGuideNPC_var ::temp9 ::temp4 1 ;4 variable args
            ; line 3546
            callmethod EvaluatePackage ::QuestGuideNPC_var ::nonevar ;0 variable args
            ; line 3547
            cast ::temp3 distToPlayer 
            strcat ::temp3 "Story [quest_guide]: waiting for player (dist=" ::temp3 
            strcat ::temp3 ::temp3 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label23
            ; line 3548
          _label22:
            assign ::temp0 ::QuestGuideWaiting_var 
            jmpf ::temp0 _label24
            propget QUEST_GUIDE_RESUME_DIST self ::temp2 
            cmp_lte ::temp0 distToPlayer ::temp2 
            assign ::temp0 ::temp0 
          _label24:
            jmpf ::temp0 _label23
            ; line 3549
            assign ::QuestGuideWaiting_var False 
            ; line 3550
            propget SandboxNearPlayerPackage ::Core_var ::temp9 
            callstatic actorUtil RemovePackageOverride ::temp0 ::QuestGuideNPC_var ::temp9 ;2 variable args
            ; line 3551
            cast ::temp13 ::QuestGuideNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp8 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp13 ::QuestLocation_var ::temp8 ;3 variable args
            ; line 3552
            propget TravelPackage_Jog ::Core_var ::temp9 
            propget PRIORITY_TRAVEL ::Core_var ::temp4 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestGuideNPC_var ::temp9 ::temp4 1 ;4 variable args
            ; line 3553
            callmethod EvaluatePackage ::QuestGuideNPC_var ::nonevar ;0 variable args
            ; line 3554
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
            ; line 3559
            strcat ::temp0 "Story [quest_guide]: arrived at " ::QuestLocationName_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 3568
            assign ::QuestGuideActive_var False 
            ; line 3569
            callmethod FindSlotByAgent ::Core_var ::temp1 ::QuestGuideNPC_var ;1 variable args
            assign slot ::temp1 
            ; line 3570
            comp_gte ::temp2 slot 0 
            jmpf ::temp2 _label0
            ; line 3571
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label0
            ; line 3573
          _label0:
            assign ::ActiveStoryType_var "" 
            ; line 3574
            assign ::IsActive_var False 
            ; line 3577
            cast ::temp3 ::QuestGuideNPC_var 
            cast ::temp4 ::QuestGuideNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp5 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp3 ::temp4 ::temp5 ;3 variable args
            ; line 3578
            propget SandboxNearPlayerPackage ::Core_var ::temp6 
            propget PRIORITY_SANDBOX ::Core_var ::temp1 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestGuideNPC_var ::temp6 ::temp1 1 ;4 variable args
            ; line 3579
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 3580
            callmethod EvaluatePackage ::QuestGuideNPC_var ::nonevar ;0 variable args
            ; line 3583
            callmethod EnsureBuildingAccess ::Core_var ::nonevar ::QuestGuideNPC_var ;1 variable args
            ; line 3584
            callmethod StartStoryLinger self ::nonevar ::QuestGuideNPC_var ;1 variable args
            ; line 3585
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
            ; line 3601
            cmp_eq ::temp0 ::QuestSubType_var "faction_battle" 
            jmpf ::temp0 _label0
            ; line 3602
            return None 
            jmp _label0
            ; line 3605
          _label0:
            callstatic intelEngine GetDungeonBossAnchor ::temp1 ::QuestLocationName_var ;1 variable args
            assign bossAnchor ::temp1 
            ; line 3606
            cast ::temp1 None 
            cmp_eq ::temp0 bossAnchor ::temp1 
            jmpf ::temp0 _label1
            ; line 3607
            strcat ::temp2 "Story [quest/" ::QuestSubType_var 
            strcat ::temp2 ::temp2 "]: no dungeon boss anchor for '" 
            strcat ::temp2 ::temp2 ::QuestLocationName_var 
            strcat ::temp2 ::temp2 "' — using deferred spawn" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 3608
            return None 
            jmp _label1
            ; line 3611
          _label1:
            assign ::QuestBossAnchor_var bossAnchor 
            ; line 3612
            strcat ::temp2 "Story [quest/" ::QuestSubType_var 
            strcat ::temp2 ::temp2 "]: pre-placing at boss anchor in '" 
            strcat ::temp2 ::temp2 ::QuestLocationName_var 
            strcat ::temp2 ::temp2 "'" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 3619
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label2
            cast ::temp3 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp3 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label2:
            jmpf ::temp0 _label3
            ; line 3620
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestVictimNPC_var False ;2 variable args
            ; line 3621
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar bossAnchor 0.0 0.0 0.0 True ;5 variable args
            ; line 3624
            cast ::temp1 ::QuestVictimNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp4 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp1 bossAnchor ::temp4 ;3 variable args
            ; line 3625
            propget SandboxNearPlayerPackage ::Core_var ::temp5 
            propget PRIORITY_TRAVEL ::Core_var ::temp6 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestVictimNPC_var ::temp5 ::temp6 1 ;4 variable args
            ; line 3626
            cast ::temp7 ::QuestVictimNPC_var 
            callmethod IsEssential ::QuestVictimNPC_var ::temp0 ;0 variable args
            cast ::temp6 ::temp0 
            callstatic storageUtil SetIntValue ::temp6 ::temp7 "Intel_WasEssential" ::temp6 ;3 variable args
            ; line 3627
            callmethod GetActorBase ::QuestVictimNPC_var ::temp8 ;0 variable args
            callmethod SetEssential ::temp8 ::nonevar True ;1 variable args
            ; line 3628
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 3633
            callmethod GetActorValue ::QuestVictimNPC_var ::temp9 "Health" ;1 variable args
            fadd ::temp9 ::temp9 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp9 ;2 variable args
            ; line 3634
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 3635
            callstatic utility GetCurrentGameTime ::temp9 ;0 variable args
            callstatic intelEngine NotifyStoryCooldown ::nonevar ::QuestVictimNPC_var ::temp9 ;2 variable args
            ; line 3636
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp2 ;0 variable args
            strcat ::temp2 "Story [quest/rescue]: victim " ::temp2 
            strcat ::temp2 ::temp2 " placed at boss room in bleedout" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            jmp _label3
            ; line 3643
          _label3:
            cmp_eq ::temp0 ::QuestSubType_var "find_item" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label4
            cmp_eq ::temp0 ::QuestItemName_var "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label5
            ; line 3644
            callstatic intelEngine SpawnQuestChest ::temp1 bossAnchor ::QuestItemName_var ;2 variable args
            assign chest ::temp1 
            ; line 3645
            cast ::temp1 None 
            cmp_eq ::temp0 chest ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label6
            ; line 3646
            assign ::QuestItemChest_var chest 
            ; line 3647
            strcat ::temp2 "Story [quest/find_item]: chest with " ::QuestItemName_var 
            strcat ::temp2 ::temp2 " spawned at boss anchor" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            jmp _label6
          _label6:
            jmp _label5
            ; line 3655
          _label5:
            cmp_eq ::temp0 ::QuestSubType_var "combat" 
            jmpf ::temp0 _label7
            ; line 3656
            callstatic intelEngine SpawnQuestBoss ::temp3 bossAnchor ::QuestEnemyType_var ;2 variable args
            assign boss ::temp3 
            ; line 3657
            cast ::temp3 None 
            cmp_eq ::temp0 boss ::temp3 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label8
            ; line 3658
            assign ::QuestBossNPC_var boss 
            ; line 3659
            callstatic game GetPlayer ::temp3 ;0 variable args
            cast ::temp7 ::temp3 
            cast ::temp10 boss 
            callstatic storageUtil FormListAdd ::temp6 ::temp7 "Intel_QuestSpawnedNPCs" ::temp10 True ;4 variable args
            ; line 3660
            iadd ::temp6 ::QuestSpawnCount_var 1 
            assign ::QuestSpawnCount_var ::temp6 
            ; line 3661
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/combat]: boss spawned at boss anchor" ;1 variable args
            jmp _label8
          _label8:
            jmp _label7
            ; line 3668
          _label7:
            assign ::QuestPrePlaced_var True 
            ; line 3669
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
            ; line 3677
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
            ; line 3678
            return None 
            jmp _label2
            ; line 3685
          _label2:
            cmp_eq ::temp0 ::ActiveStoryType_var "quest" 
            jmpf ::temp0 _label3
            ; line 3686
            return None 
            jmp _label3
            ; line 3689
          _label3:
            not ::temp0 ::QuestEnemiesSpawned_var 
            jmpf ::temp0 _label4
            ; line 3694
            assign ::temp0 ::QuestPrePlaced_var 
            jmpf ::temp0 _label5
            cast ::temp1 None 
            cmp_eq ::temp0 ::QuestBossAnchor_var ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label5:
            jmpf ::temp0 _label6
            ; line 3702
            callmethod Is3DLoaded ::QuestBossAnchor_var ::temp0 ;0 variable args
            assign bossLoaded ::temp0 
            ; line 3703
            assign targetNearby False 
            ; line 3704
            not ::temp0 bossLoaded 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label7
            cast ::temp1 None 
            cmp_eq ::temp0 ::QuestLocation_var ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label7:
            jmpf ::temp0 _label8
            ; line 3705
            callstatic game GetPlayer ::temp2 ;0 variable args
            cast ::temp1 ::temp2 
            callstatic intelEngine GetDistance3D ::temp3 ::temp1 ::QuestLocation_var ;2 variable args
            assign questDist ::temp3 
            ; line 3706
            cmp_lt ::temp0 questDist 4000.0 
            assign nearQuestArea ::temp0 
            ; line 3707
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
            ; line 3708
            cast ::temp1 ::QuestVictimNPC_var 
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDistance ::temp2 ::temp3 ::temp1 ;1 variable args
            cmp_lt ::temp0 ::temp3 2000.0 
            assign targetNearby ::temp0 
            jmp _label13
            ; line 3709
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
            ; line 3710
            cast ::temp1 ::QuestBossNPC_var 
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDistance ::temp2 ::temp3 ::temp1 ;1 variable args
            cmp_lt ::temp0 ::temp3 2000.0 
            assign targetNearby ::temp0 
            jmp _label13
          _label13:
            jmp _label8
            ; line 3713
          _label8:
            assign ::temp0 bossLoaded 
            jmpt ::temp0 _label17
            assign ::temp0 targetNearby 
          _label17:
            jmpf ::temp0 _label18
            ; line 3714
            assign ::temp0 targetNearby 
            jmpf ::temp0 _label19
            not ::temp0 bossLoaded 
            assign ::temp0 ::temp0 
          _label19:
            jmpf ::temp0 _label20
            ; line 3715
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: pre-placed target nearby but boss anchor not loaded — safety spawn" ;1 variable args
            jmp _label21
            ; line 3717
          _label20:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: boss room cell loaded — spawning enemies/chest at anchor" ;1 variable args
            ; line 3720
          _label21:
            assign spawnPoint ::QuestBossAnchor_var 
            ; line 3721
            assign ::temp0 targetNearby 
            jmpf ::temp0 _label22
            not ::temp0 bossLoaded 
            assign ::temp0 ::temp0 
          _label22:
            jmpf ::temp0 _label23
            ; line 3722
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label24
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label24:
            jmpf ::temp0 _label25
            ; line 3723
            cast ::temp1 ::QuestVictimNPC_var 
            assign spawnPoint ::temp1 
            jmp _label26
            ; line 3724
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
            ; line 3725
            cast ::temp1 ::QuestBossNPC_var 
            assign spawnPoint ::temp1 
            jmp _label26
          _label26:
            jmp _label23
            ; line 3728
          _label23:
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign player ::temp2 
            ; line 3734
            callstatic intelEngine SpawnQuestEnemies ::temp4 spawnPoint ::QuestEnemyType_var ;2 variable args
            assign enemies ::temp4 
            ; line 3735
            assign i 0 
            ; line 3736
          _label29:
            array_length ::temp5 enemies 
            cmp_lt ::temp0 i ::temp5 
            jmpf ::temp0 _label28
            ; line 3737
            array_getlement ::temp2 enemies i 
            callmethod DisableNoWait ::temp2 ::nonevar False ;1 variable args
            ; line 3738
            callstatic utility RandomFloat ::temp3 -300.0 300.0 ;2 variable args
            callstatic utility RandomFloat ::temp6 -300.0 300.0 ;2 variable args
            array_getlement ::temp2 enemies i 
            callmethod MoveTo ::temp2 ::nonevar spawnPoint ::temp3 ::temp6 0.0 True ;5 variable args
            ; line 3739
            cast ::temp7 player 
            array_getlement ::temp2 enemies i 
            cast ::temp8 ::temp2 
            callstatic storageUtil FormListAdd ::temp5 ::temp7 "Intel_QuestSpawnedNPCs" ::temp8 True ;4 variable args
            ; line 3740
            iadd ::temp5 i 1 
            assign i ::temp5 
            jmp _label29
            ; line 3744
          _label28:
            cast ::temp2 None 
            assign boss ::temp2 
            ; line 3745
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestBossNPC_var ::temp2 
            jmpf ::temp0 _label30
            ; line 3746
            callstatic intelEngine SpawnQuestBoss ::temp2 spawnPoint ::QuestEnemyType_var ;2 variable args
            assign boss ::temp2 
            ; line 3747
            cast ::temp2 None 
            cmp_eq ::temp0 boss ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label31
            ; line 3748
            callmethod DisableNoWait boss ::nonevar False ;1 variable args
            ; line 3749
            callstatic utility RandomFloat ::temp6 -150.0 150.0 ;2 variable args
            callstatic utility RandomFloat ::temp3 -150.0 150.0 ;2 variable args
            callmethod MoveTo boss ::nonevar spawnPoint ::temp6 ::temp3 0.0 True ;5 variable args
            ; line 3750
            assign ::QuestBossNPC_var boss 
            ; line 3751
            cast ::temp8 player 
            cast ::temp7 boss 
            callstatic storageUtil FormListAdd ::temp5 ::temp8 "Intel_QuestSpawnedNPCs" ::temp7 True ;4 variable args
            jmp _label31
          _label31:
            jmp _label30
            ; line 3758
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
            ; line 3759
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 3760
            callmethod GetActorValue ::QuestVictimNPC_var ::temp3 "Health" ;1 variable args
            fadd ::temp3 ::temp3 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp3 ;2 variable args
            ; line 3761
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 3762
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: re-applied bleedout on first 3D load" ;1 variable args
            jmp _label35
            ; line 3769
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
            ; line 3770
            callstatic intelEngine EnsureQuestItemInChest ::temp0 ::QuestItemChest_var ::QuestItemName_var ;2 variable args
            ; line 3771
            strcat ::temp9 "Story [quest/find_item]: ensured '" ::QuestItemName_var 
            strcat ::temp9 ::temp9 "' is in chest on first 3D load" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            jmp _label38
            ; line 3775
          _label38:
            assign i 0 
            ; line 3776
          _label40:
            array_length ::temp5 enemies 
            cmp_lt ::temp0 i ::temp5 
            jmpf ::temp0 _label39
            ; line 3777
            array_getlement ::temp2 enemies i 
            callmethod EnableNoWait ::temp2 ::nonevar False ;1 variable args
            ; line 3778
            iadd ::temp5 i 1 
            assign i ::temp5 
            jmp _label40
            ; line 3780
          _label39:
            cast ::temp2 None 
            cmp_eq ::temp0 boss ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label41
            ; line 3781
            callmethod EnableNoWait boss ::nonevar False ;1 variable args
            jmp _label41
            ; line 3784
          _label41:
            array_length ::temp5 enemies 
            assign ::QuestSpawnCount_var ::temp5 
            ; line 3785
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestBossNPC_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label42
            ; line 3786
            iadd ::temp5 ::QuestSpawnCount_var 1 
            assign ::QuestSpawnCount_var ::temp5 
            jmp _label42
            ; line 3788
          _label42:
            cmp_gt ::temp0 ::QuestSpawnCount_var 0 
            jmpf ::temp0 _label43
            ; line 3789
            assign ::QuestEnemiesSpawned_var True 
            ; line 3790
            strcat ::temp9 "Story [quest/" ::QuestSubType_var 
            strcat ::temp9 ::temp9 "]: spawned " 
            cast ::temp10 ::QuestSpawnCount_var 
            strcat ::temp10 ::temp9 ::temp10 
            strcat ::temp10 ::temp10 " " 
            strcat ::temp10 ::temp10 ::QuestEnemyType_var 
            strcat ::temp10 ::temp10 " at boss room" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            jmp _label44
            ; line 3792
          _label43:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: WARNING - no enemies spawned at boss room, falling back to deferred" ;1 variable args
          _label44:
            jmp _label18
            ; line 3795
          _label18:
            return None 
            jmp _label6
            ; line 3806
          _label6:
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign ::mangled_player_0 ::temp2 
            ; line 3807
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
            ; line 3808
            return None 
            jmp _label47
            ; line 3811
          _label47:
            assign atQuestArea False 
            ; line 3816
            callmethod Is3DLoaded ::QuestLocation_var ::temp0 ;0 variable args
            jmpf ::temp0 _label48
            ; line 3817
            cast ::temp1 ::mangled_player_0 
            callstatic intelEngine GetDistance3D ::temp3 ::temp1 ::QuestLocation_var ;2 variable args
            assign dist ::temp3 
            ; line 3818
            cmp_lt ::temp0 dist 4000.0 
            jmpf ::temp0 _label49
            ; line 3819
            assign atQuestArea True 
            jmp _label49
          _label49:
            jmp _label48
            ; line 3823
          _label48:
            not ::temp0 atQuestArea 
            jmpf ::temp0 _label50
            ; line 3824
            callmethod GetParentCell ::QuestLocation_var ::temp11 ;0 variable args
            assign questCell ::temp11 
            ; line 3825
            callmethod GetParentCell ::mangled_player_0 ::temp11 ;0 variable args
            assign playerCell ::temp11 
            ; line 3826
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
            ; line 3827
            assign atQuestArea True 
            ; line 3828
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: same-cell spawn fallback triggered" ;1 variable args
            jmp _label53
          _label53:
            jmp _label50
            ; line 3836
          _label50:
            not ::temp0 atQuestArea 
            jmpf ::temp0 _label54
            ; line 3837
            callmethod GetCurrentLocation ::QuestLocation_var ::temp12 ;0 variable args
            assign questLoc ::temp12 
            ; line 3838
            cast ::temp12 None 
            cmp_eq ::temp0 questLoc ::temp12 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label55
            callmethod IsInLocation ::mangled_player_0 ::temp0 questLoc ;1 variable args
            assign ::temp0 ::temp0 
          _label55:
            jmpf ::temp0 _label56
            ; line 3840
            cast ::temp1 ::mangled_player_0 
            callstatic intelEngine GetDistance3D ::temp3 ::temp1 ::QuestLocation_var ;2 variable args
            assign locDist ::temp3 
            ; line 3841
            cmp_lt ::temp0 locDist 6000.0 
            jmpf ::temp0 _label57
            ; line 3842
            assign atQuestArea True 
            ; line 3843
            cast ::temp10 locDist 
            strcat ::temp10 "Story [quest]: BGSLocation spawn fallback triggered (dist=" ::temp10 
            strcat ::temp10 ::temp10 ")" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            jmp _label58
            ; line 3845
          _label57:
            cast ::temp10 locDist 
            strcat ::temp10 "Story [quest]: BGSLocation match but too far (" ::temp10 
            strcat ::temp10 ::temp10 " units) — waiting" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
          _label58:
            jmp _label56
          _label56:
            jmp _label54
            ; line 3859
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
            ; line 3864
            callmethod Is3DLoaded ::QuestLocation_var ::temp0 ;0 variable args
            jmpf ::temp0 _label62
            ; line 3865
            assign atQuestArea True 
            ; line 3866
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: deferred interior entry — quest exterior still loaded (player near entrance)" ;1 variable args
            jmp _label63
            ; line 3870
          _label62:
            callmethod GetCurrentLocation ::QuestLocation_var ::temp12 ;0 variable args
            assign ::mangled_questLoc_0 ::temp12 
            ; line 3871
            cast ::temp12 None 
            cmp_eq ::temp0 ::mangled_questLoc_0 ::temp12 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label64
            callmethod IsInLocation ::mangled_player_0 ::temp0 ::mangled_questLoc_0 ;1 variable args
            assign ::temp0 ::temp0 
          _label64:
            jmpf ::temp0 _label65
            ; line 3872
            assign atQuestArea True 
            ; line 3873
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: deferred interior entry — BGSLocation match" ;1 variable args
            jmp _label63
            ; line 3879
          _label65:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: deferred interior but can't verify quest dungeon — waiting for scan" ;1 variable args
          _label63:
            jmp _label61
            ; line 3883
          _label61:
            jmpf atQuestArea _label66
            ; line 3885
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
            ; line 3886
            strcat ::temp10 "Story [quest/faction_battle]: player arrived at " ::QuestLocationName_var 
            strcat ::temp10 ::temp10 " — triggering battle" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            ; line 3888
            assign enemyFaction ::QuestBattleEnemyFaction_var 
            ; line 3889
            cmp_eq ::temp0 enemyFaction "" 
            jmpf ::temp0 _label70
            ; line 3891
            callstatic intelEngine GetFactionWarEnemy ::temp10 ::QuestAlliedFaction_var ;1 variable args
            assign enemyFaction ::temp10 
            jmp _label70
            ; line 3893
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
            ; line 3894
            propget Battle ::Core_var ::temp13 
            assign battle ::temp13 
            ; line 3895
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
            ; line 3899
            assign ::QuestBattleScheduled_var True 
            ; line 3900
            assign ::QuestEnemiesSpawned_var True 
            ; line 3902
            propset QuestAutoJoinFaction battle ::QuestAlliedFaction_var 
            ; line 3903
            propset BattleSpawnAnchor battle ::QuestLocation_var 
            ; line 3904
            callmethod StartBattleImmediate battle ::nonevar ::QuestAlliedFaction_var enemyFaction 0 ;3 variable args
            ; line 3906
            callstatic intelEngine IsBattleActive ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label76
            ; line 3907
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/faction_battle]: StartBattleImmediate failed, failing quest" ;1 variable args
            ; line 3908
            callstatic debug Notification ::nonevar "The forces have already moved on." ;1 variable args
            ; line 3909
            assign ::QuestBattleScheduled_var False 
            ; line 3910
            assign ::QuestEnemiesSpawned_var False 
            ; line 3911
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 3912
            callmethod CleanupQuest self ::nonevar ;0 variable args
            ; line 3913
            return None 
            jmp _label76
            ; line 3915
          _label76:
            strcat ::temp10 "Story [quest/faction_battle]: battle started — " ::QuestAlliedFaction_var 
            strcat ::temp10 ::temp10 " vs " 
            strcat ::temp10 ::temp10 enemyFaction 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            jmp _label77
            ; line 3917
          _label75:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/faction_battle]: battle system busy, granting partial credit" ;1 variable args
            ; line 3918
            callstatic debug Notification ::nonevar "The fighting is already underway elsewhere." ;1 variable args
            ; line 3919
            cmp_eq ::temp0 ::QuestAlliedFaction_var "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label78
            ; line 3920
            propget QUEST_STANDING_REWARD self ::temp5 
            idiv ::temp5 ::temp5 2 
            callstatic intelEngine AdjustPlayerFactionStanding ::temp5 ::QuestAlliedFaction_var ::temp5 ;2 variable args
            jmp _label78
            ; line 3922
          _label78:
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 3923
            callmethod CleanupQuest self ::nonevar ;0 variable args
          _label77:
            jmp _label79
            ; line 3926
          _label72:
            strcat ::temp10 "Story [quest/faction_battle]: no rival found for " ::QuestAlliedFaction_var 
            strcat ::temp10 ::temp10 ", failing quest" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            ; line 3927
            callstatic intelEngine GetFactionDisplayName ::temp10 ::QuestAlliedFaction_var ;1 variable args
            assign allyFailName ::temp10 
            ; line 3928
            cmp_eq ::temp0 allyFailName "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label80
            ; line 3929
            strcat ::temp10 "The " allyFailName 
            strcat ::temp10 ::temp10 " held the field unopposed." 
            callstatic debug Notification ::nonevar ::temp10 ;1 variable args
            jmp _label80
            ; line 3931
          _label80:
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 3932
            callmethod CleanupQuest self ::nonevar ;0 variable args
            ; line 3934
          _label79:
            return None 
            jmp _label69
            ; line 3936
          _label69:
            callmethod IsInInterior ::mangled_player_0 ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label81
            ; line 3940
            not ::temp0 ::QuestDeferredToInterior_var 
            jmpf ::temp0 _label82
            ; line 3941
            callstatic intelEngine HasNearbyDungeonEntrance ::temp0 ::QuestLocation_var ;1 variable args
            jmpf ::temp0 _label83
            ; line 3942
            assign ::QuestDeferredToInterior_var True 
            ; line 3943
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: dungeon entrance found, deferring spawn until player enters" ;1 variable args
            jmp _label84
            ; line 3946
          _label83:
            callmethod SpawnQuestEnemies self ::nonevar ;0 variable args
          _label84:
            jmp _label85
            ; line 3949
          _label82:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: waiting for player to enter dungeon" ;1 variable args
          _label85:
            jmp _label86
            ; line 3956
          _label81:
            callmethod GetParentCell ::mangled_player_0 ::temp11 ;0 variable args
            assign currentCell ::temp11 
            ; line 3957
            cast ::temp11 None 
            cmp_eq ::temp0 ::QuestDungeonLastCell_var ::temp11 
            jmpf ::temp0 _label87
            ; line 3958
            assign ::QuestDungeonLastCell_var currentCell 
            ; line 3959
            assign ::QuestDungeonDepth_var 0 
            jmp _label88
            ; line 3960
          _label87:
            cmp_eq ::temp0 currentCell ::QuestDungeonLastCell_var 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label88
            ; line 3961
            assign ::QuestDungeonLastCell_var currentCell 
            ; line 3962
            iadd ::temp5 ::QuestDungeonDepth_var 1 
            assign ::QuestDungeonDepth_var ::temp5 
            jmp _label88
            ; line 3964
          _label88:
            cast ::temp10 ::QuestDungeonDepth_var 
            strcat ::temp10 "Story [quest]: dungeon depth " ::temp10 
            strcat ::temp10 ::temp10 ", scanning ahead..." 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            ; line 3967
            callstatic intelEngine ScanAheadForAnchor ::temp1 ::mangled_player_0 ;1 variable args
            assign aheadAnchor ::temp1 
            ; line 3968
            cast ::temp1 None 
            cmp_eq ::temp0 aheadAnchor ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label89
            ; line 3970
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: anchor found ahead! Placing victim + enemies" ;1 variable args
            ; line 3971
            assign ::QuestBossAnchor_var aheadAnchor 
            ; line 3976
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label90
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label90:
            jmpf ::temp0 _label91
            ; line 3977
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestVictimNPC_var False ;2 variable args
            ; line 3978
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar aheadAnchor 0.0 0.0 0.0 True ;5 variable args
            ; line 3979
            cast ::temp1 ::QuestVictimNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp14 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp1 aheadAnchor ::temp14 ;3 variable args
            ; line 3980
            propget SandboxNearPlayerPackage ::Core_var ::temp15 
            propget PRIORITY_TRAVEL ::Core_var ::temp5 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestVictimNPC_var ::temp15 ::temp5 1 ;4 variable args
            ; line 3981
            cast ::temp7 ::QuestVictimNPC_var 
            callmethod IsEssential ::QuestVictimNPC_var ::temp0 ;0 variable args
            cast ::temp5 ::temp0 
            callstatic storageUtil SetIntValue ::temp5 ::temp7 "Intel_WasEssential" ::temp5 ;3 variable args
            ; line 3982
            callmethod GetActorBase ::QuestVictimNPC_var ::temp16 ;0 variable args
            callmethod SetEssential ::temp16 ::nonevar True ;1 variable args
            ; line 3983
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 3986
            callmethod GetActorValue ::QuestVictimNPC_var ::temp3 "Health" ;1 variable args
            fadd ::temp3 ::temp3 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp3 ;2 variable args
            ; line 3987
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 3988
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            callstatic intelEngine NotifyStoryCooldown ::nonevar ::QuestVictimNPC_var ::temp3 ;2 variable args
            ; line 3990
            cast ::temp17 None 
            cmp_eq ::temp0 ::QuestTargetAlias_var ::temp17 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label92
            ; line 3991
            cast ::temp1 ::QuestVictimNPC_var 
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::temp1 ;1 variable args
            ; line 3992
            propget QUEST_OBJECTIVE_ID self ::temp5 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp5 False False ;3 variable args
            ; line 3993
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 3994
            propget QUEST_OBJECTIVE_ID self ::temp5 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp5 True False ;3 variable args
            jmp _label92
            ; line 3996
          _label92:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: victim placed at ahead anchor in bleedout" ;1 variable args
            jmp _label91
            ; line 4000
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
            ; line 4001
            callstatic intelEngine SpawnQuestChest ::temp1 aheadAnchor ::QuestItemName_var ;2 variable args
            assign chest ::temp1 
            ; line 4002
            cast ::temp1 None 
            cmp_eq ::temp0 chest ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label96
            ; line 4003
            assign ::QuestItemChest_var chest 
            ; line 4004
            cast ::temp17 None 
            cmp_eq ::temp0 ::QuestTargetAlias_var ::temp17 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label97
            ; line 4005
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::QuestItemChest_var ;1 variable args
            ; line 4006
            propget QUEST_OBJECTIVE_ID self ::temp5 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp5 False False ;3 variable args
            ; line 4007
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 4008
            propget QUEST_OBJECTIVE_ID self ::temp5 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp5 True False ;3 variable args
            jmp _label97
            ; line 4010
          _label97:
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/find_item]: chest placed at ahead anchor" ;1 variable args
            jmp _label96
          _label96:
            jmp _label95
            ; line 4015
          _label95:
            callstatic intelEngine SpawnQuestEnemies ::temp4 aheadAnchor ::QuestEnemyType_var ;2 variable args
            assign ::mangled_enemies_0 ::temp4 
            ; line 4016
            assign idx 0 
            ; line 4017
          _label99:
            array_length ::temp5 ::mangled_enemies_0 
            cmp_lt ::temp0 idx ::temp5 
            jmpf ::temp0 _label98
            ; line 4018
            array_getlement ::temp2 ::mangled_enemies_0 idx 
            callmethod DisableNoWait ::temp2 ::nonevar False ;1 variable args
            ; line 4019
            callstatic utility RandomFloat ::temp3 -300.0 300.0 ;2 variable args
            callstatic utility RandomFloat ::temp6 -300.0 300.0 ;2 variable args
            array_getlement ::temp2 ::mangled_enemies_0 idx 
            callmethod MoveTo ::temp2 ::nonevar aheadAnchor ::temp3 ::temp6 0.0 True ;5 variable args
            ; line 4020
            cast ::temp7 ::mangled_player_0 
            array_getlement ::temp2 ::mangled_enemies_0 idx 
            cast ::temp8 ::temp2 
            callstatic storageUtil FormListAdd ::temp5 ::temp7 "Intel_QuestSpawnedNPCs" ::temp8 True ;4 variable args
            ; line 4021
            iadd ::temp5 idx 1 
            assign idx ::temp5 
            jmp _label99
            ; line 4023
          _label98:
            callstatic intelEngine SpawnQuestBoss ::temp2 aheadAnchor ::QuestEnemyType_var ;2 variable args
            assign ::mangled_boss_0 ::temp2 
            ; line 4024
            cast ::temp2 None 
            cmp_eq ::temp0 ::mangled_boss_0 ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label100
            ; line 4025
            callmethod DisableNoWait ::mangled_boss_0 ::nonevar False ;1 variable args
            ; line 4026
            callstatic utility RandomFloat ::temp6 -150.0 150.0 ;2 variable args
            callstatic utility RandomFloat ::temp3 -150.0 150.0 ;2 variable args
            callmethod MoveTo ::mangled_boss_0 ::nonevar aheadAnchor ::temp6 ::temp3 0.0 True ;5 variable args
            ; line 4027
            assign ::QuestBossNPC_var ::mangled_boss_0 
            ; line 4028
            cast ::temp8 ::mangled_player_0 
            cast ::temp7 ::mangled_boss_0 
            callstatic storageUtil FormListAdd ::temp5 ::temp8 "Intel_QuestSpawnedNPCs" ::temp7 True ;4 variable args
            jmp _label100
            ; line 4031
          _label100:
            assign idx 0 
            ; line 4032
          _label102:
            array_length ::temp5 ::mangled_enemies_0 
            cmp_lt ::temp0 idx ::temp5 
            jmpf ::temp0 _label101
            ; line 4033
            array_getlement ::temp2 ::mangled_enemies_0 idx 
            callmethod EnableNoWait ::temp2 ::nonevar False ;1 variable args
            ; line 4034
            iadd ::temp5 idx 1 
            assign idx ::temp5 
            jmp _label102
            ; line 4036
          _label101:
            cast ::temp2 None 
            cmp_eq ::temp0 ::mangled_boss_0 ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label103
            ; line 4037
            callmethod EnableNoWait ::mangled_boss_0 ::nonevar False ;1 variable args
            jmp _label103
            ; line 4039
          _label103:
            array_length ::temp5 ::mangled_enemies_0 
            assign ::QuestSpawnCount_var ::temp5 
            ; line 4040
            cast ::temp2 None 
            cmp_eq ::temp0 ::mangled_boss_0 ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label104
            ; line 4041
            iadd ::temp5 ::QuestSpawnCount_var 1 
            assign ::QuestSpawnCount_var ::temp5 
            jmp _label104
            ; line 4043
          _label104:
            cmp_gt ::temp0 ::QuestSpawnCount_var 0 
            jmpf ::temp0 _label105
            ; line 4044
            assign ::QuestEnemiesSpawned_var True 
            jmp _label105
            ; line 4046
          _label105:
            assign ::QuestPrePlaced_var True 
            ; line 4047
            strcat ::temp10 "Story [quest/" ::QuestSubType_var 
            strcat ::temp10 ::temp10 "]: placed " 
            cast ::temp9 ::QuestSpawnCount_var 
            strcat ::temp9 ::temp10 ::temp9 
            strcat ::temp9 ::temp9 " enemies at ahead anchor" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            jmp _label86
            ; line 4050
          _label89:
            iadd ::temp5 ::QuestDungeonScanFails_var 1 
            assign ::QuestDungeonScanFails_var ::temp5 
            ; line 4051
            comp_gte ::temp0 ::QuestDungeonDepth_var 3 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label106
            comp_gte ::temp0 ::QuestDungeonScanFails_var 5 
            assign ::temp0 ::temp0 
          _label106:
            jmpf ::temp0 _label86
            ; line 4053
            cast ::temp9 ::QuestDungeonDepth_var 
            strcat ::temp9 "Story [quest]: no anchors found (depth=" ::temp9 
            strcat ::temp9 ::temp9 ", scans=" 
            cast ::temp10 ::QuestDungeonScanFails_var 
            strcat ::temp10 ::temp9 ::temp10 
            strcat ::temp10 ::temp10 ") — using fallback spawn" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            ; line 4054
            callmethod SpawnQuestEnemies self ::nonevar ;0 variable args
            jmp _label86
          _label86:
            jmp _label66
          _label66:
            jmp _label107
            ; line 4061
          _label4:
            jmpf ::QuestBattleScheduled_var _label108
            ; line 4063
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            fsub ::temp3 ::temp3 ::QuestGuideStartTime_var 
            assign battleElapsed ::temp3 
            ; line 4064
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
            ; line 4065
            assign ::QuestSpawnAttempts_var 1 
            ; line 4066
            callstatic debug Notification ::nonevar "You hear the clink of armor ahead." ;1 variable args
            jmp _label111
            ; line 4069
          _label111:
            callstatic intelEngine IsBattleActive ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label112
            cmp_lt ::temp0 ::QuestSpawnAttempts_var 2 
            assign ::temp0 ::temp0 
          _label112:
            jmpf ::temp0 _label113
            ; line 4070
            assign ::QuestSpawnAttempts_var 2 
            ; line 4071
            callstatic debug Notification ::nonevar "Sounds of fighting carry from up ahead." ;1 variable args
            jmp _label113
            ; line 4074
          _label113:
            propget BATTLE_MIN_START_DELAY self ::temp3 
            cmp_lt ::temp0 battleElapsed ::temp3 
            jmpf ::temp0 _label114
            ; line 4075
            return None 
            jmp _label114
            ; line 4077
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
            ; line 4078
            cast ::temp10 ::QuestActive_var 
            strcat ::temp10 "Story [quest/faction_battle]: battle ended, completing quest. QuestActive=" ::temp10 
            strcat ::temp10 ::temp10 " IsActive=" 
            cast ::temp9 ::IsActive_var 
            strcat ::temp9 ::temp10 ::temp9 
            strcat ::temp9 ::temp9 " IsNPCStoryActive=" 
            cast ::temp10 ::IsNPCStoryActive_var 
            strcat ::temp10 ::temp9 ::temp10 
            callmethod DebugMsg ::Core_var ::nonevar ::temp10 ;1 variable args
            ; line 4079
            callmethod OnQuestComplete self ::nonevar ;0 variable args
            ; line 4080
            cast ::temp10 ::QuestActive_var 
            strcat ::temp10 "Story [quest/faction_battle]: OnQuestComplete returned. QuestActive=" ::temp10 
            strcat ::temp10 ::temp10 " IsActive=" 
            cast ::temp9 ::IsActive_var 
            strcat ::temp9 ::temp10 ::temp9 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            jmp _label117
            ; line 4082
          _label117:
            return None 
            jmp _label108
            ; line 4084
          _label108:
            cmp_eq ::temp0 ::QuestSubType_var "find_item" 
            jmpf ::temp0 _label118
            ; line 4086
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
            ; line 4087
            strcat ::temp9 "Story [quest/find_item]: quest item '" ::QuestItemName_var 
            strcat ::temp9 ::temp9 "' retrieved from chest" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            ; line 4088
            callmethod OnQuestComplete self ::nonevar ;0 variable args
            jmp _label121
          _label121:
            jmp _label107
            ; line 4090
          _label118:
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            jmpf ::temp0 _label122
            ; line 4093
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
            ; line 4095
            assign ::temp0 ::QuestPrePlaced_var 
            jmpf ::temp0 _label126
            not ::temp0 ::QuestFurnitureScanned_var 
            assign ::temp0 ::temp0 
          _label126:
            jmpf ::temp0 _label127
            ; line 4096
            assign ::QuestFurnitureScanned_var True 
            ; line 4097
            callstatic intelEngine FindUsablePrisonerFurniture ::temp1 ::QuestVictimNPC_var ;1 variable args
            assign usableFurn ::temp1 
            ; line 4098
            cast ::temp1 None 
            cmp_eq ::temp0 usableFurn ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label128
            ; line 4100
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4101
            callmethod RestoreActorValue ::QuestVictimNPC_var ::nonevar "Health" 500.0 ;2 variable args
            ; line 4102
            callmethod SetRestrained ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4103
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4104
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar usableFurn 0.0 0.0 0.0 True ;5 variable args
            ; line 4105
            cast ::temp1 ::QuestVictimNPC_var 
            callmethod Activate usableFurn ::temp0 ::temp1 False ;2 variable args
            ; line 4106
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 4107
            assign ::QuestVictimInFurniture_var True 
            ; line 4108
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: victim activated usable furniture in boss room" ;1 variable args
            jmp _label129
            ; line 4110
          _label128:
            callstatic intelEngine FindPrisonerFurniture ::temp1 ::QuestVictimNPC_var ;1 variable args
            assign prisonFurn ::temp1 
            ; line 4111
            cast ::temp1 None 
            cmp_eq ::temp0 prisonFurn ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label130
            ; line 4112
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar prisonFurn 0.0 0.0 0.0 True ;5 variable args
            ; line 4113
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: nudged victim to decorative prison prop in boss room" ;1 variable args
            jmp _label130
            ; line 4115
          _label130:
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 4116
            callmethod GetActorValue ::QuestVictimNPC_var ::temp3 "Health" ;1 variable args
            fadd ::temp3 ::temp3 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp3 ;2 variable args
            ; line 4117
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
          _label129:
            jmp _label127
            ; line 4122
          _label127:
            jmpf ::QuestVictimInFurniture_var _label131
            ; line 4123
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar True ;1 variable args
            jmp _label132
            ; line 4125
          _label131:
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 4126
            callmethod GetActorValue ::QuestVictimNPC_var ::temp3 "Health" ;1 variable args
            cmp_gt ::temp0 ::temp3 1.0 
            jmpf ::temp0 _label132
            ; line 4127
            callmethod GetActorValue ::QuestVictimNPC_var ::temp3 "Health" ;1 variable args
            fadd ::temp3 ::temp3 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp3 ;2 variable args
            ; line 4128
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4129
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp9 ;0 variable args
            strcat ::temp9 "Story [quest/rescue]: re-applied bleedout to " ::temp9 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            jmp _label132
          _label132:
            jmp _label125
            ; line 4135
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
            ; line 4136
            strcat ::temp9 "Story [quest/rescue]: victim " ::QuestVictimName_var 
            strcat ::temp9 ::temp9 " died — quest failed" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp9 ;1 variable args
            ; line 4137
            callmethod OnQuestFailed self ::nonevar ;0 variable args
            jmp _label135
            ; line 4138
          _label134:
            callmethod AreAllQuestEnemiesDead self ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label136
            callmethod IsAreaClearOfHostiles self ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label136:
            jmpf ::temp0 _label137
            ; line 4140
            not ::temp0 ::QuestVictimFreed_var 
            jmpf ::temp0 _label138
            ; line 4141
            callmethod FreeQuestVictim self ::nonevar ;0 variable args
            jmp _label138
            ; line 4143
          _label138:
            callmethod OnQuestComplete self ::nonevar ;0 variable args
            jmp _label135
            ; line 4144
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
            ; line 4146
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign ::mangled_player_1 ::temp2 
            ; line 4147
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
            ; line 4148
            callmethod FreeQuestVictim self ::nonevar ;0 variable args
            ; line 4149
            callmethod OnQuestComplete self ::nonevar ;0 variable args
            jmp _label142
          _label142:
            jmp _label135
          _label135:
            jmp _label107
            ; line 4154
          _label122:
            callmethod AreAllQuestEnemiesDead self ::temp0 ;0 variable args
            jmpf ::temp0 _label107
            ; line 4155
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
            ; line 4162
            jmpf ::QuestEnemiesSpawned_var _label0
            ; line 4163
            return None 
            jmp _label0
            ; line 4166
          _label0:
            iadd ::temp0 ::QuestSpawnAttempts_var 1 
            assign ::QuestSpawnAttempts_var ::temp0 
            ; line 4171
            callstatic game GetPlayer ::temp1 ;0 variable args
            assign player ::temp1 
            ; line 4172
            assign victimAnchor ::QuestLocation_var 
            ; line 4173
            assign enemyAnchor ::QuestLocation_var 
            ; line 4174
            callmethod IsInInterior player ::temp2 ;0 variable args
            jmpf ::temp2 _label1
            ; line 4179
            cmp_eq ::temp2 ::QuestSubType_var "rescue" 
            jmpf ::temp2 _label2
            ; line 4181
            callstatic intelEngine FindRescueAnchor ::temp3 player ;1 variable args
            assign rescuePoint ::temp3 
            ; line 4182
            cast ::temp3 None 
            cmp_eq ::temp2 rescuePoint ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label3
            ; line 4183
            assign victimAnchor rescuePoint 
            ; line 4184
            cast ::temp3 player 
            assign enemyAnchor ::temp3 
            ; line 4185
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: victim deep at rescue anchor, enemies near player" ;1 variable args
            jmp _label4
            ; line 4189
          _label3:
            cast ::temp3 player 
            assign victimAnchor ::temp3 
            ; line 4190
            cast ::temp3 player 
            assign enemyAnchor ::temp3 
            ; line 4191
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: no rescue anchor, spawning near player (interior fallback)" ;1 variable args
          _label4:
            jmp _label5
            ; line 4195
          _label2:
            callstatic intelEngine FindDeeperSpawnPoint ::temp3 player ;1 variable args
            assign deeperPoint ::temp3 
            ; line 4196
            cast ::temp3 None 
            cmp_eq ::temp2 deeperPoint ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label6
            ; line 4197
            assign victimAnchor deeperPoint 
            ; line 4198
            assign enemyAnchor deeperPoint 
            ; line 4199
            strcat ::temp4 "Story [quest/" ::QuestSubType_var 
            strcat ::temp4 ::temp4 "]: spawning at dungeon landmark" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            jmp _label5
            ; line 4205
          _label6:
            cast ::temp3 player 
            assign victimAnchor ::temp3 
            ; line 4206
            cast ::temp3 player 
            assign enemyAnchor ::temp3 
            ; line 4207
            strcat ::temp4 "Story [quest/" ::QuestSubType_var 
            strcat ::temp4 ::temp4 "]: no landmarks found, spawning near player (interior fallback)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
          _label5:
            jmp _label1
            ; line 4213
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
            ; line 4215
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestVictimNPC_var False ;2 variable args
            ; line 4216
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar victimAnchor 0.0 0.0 0.0 False ;5 variable args
            ; line 4220
            cast ::temp3 ::QuestVictimNPC_var 
            propget IntelEngine_TravelTarget ::Core_var ::temp5 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp3 victimAnchor ::temp5 ;3 variable args
            ; line 4221
            propget SandboxNearPlayerPackage ::Core_var ::temp6 
            propget PRIORITY_TRAVEL ::Core_var ::temp0 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestVictimNPC_var ::temp6 ::temp0 1 ;4 variable args
            ; line 4223
            cast ::temp7 ::QuestVictimNPC_var 
            callmethod IsEssential ::QuestVictimNPC_var ::temp2 ;0 variable args
            cast ::temp0 ::temp2 
            callstatic storageUtil SetIntValue ::temp0 ::temp7 "Intel_WasEssential" ::temp0 ;3 variable args
            ; line 4224
            callmethod GetActorBase ::QuestVictimNPC_var ::temp8 ;0 variable args
            callmethod SetEssential ::temp8 ::nonevar True ;1 variable args
            ; line 4226
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar True ;1 variable args
            ; line 4227
            callmethod GetActorValue ::QuestVictimNPC_var ::temp9 "Health" ;1 variable args
            fadd ::temp9 ::temp9 100.0 
            callmethod DamageActorValue ::QuestVictimNPC_var ::nonevar "Health" ::temp9 ;2 variable args
            ; line 4228
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4229
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp4 ;0 variable args
            strcat ::temp4 "Story [quest/rescue]: placed victim " ::temp4 
            strcat ::temp4 ::temp4 " in bleedout" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            ; line 4231
            callstatic utility GetCurrentGameTime ::temp9 ;0 variable args
            callstatic intelEngine NotifyStoryCooldown ::nonevar ::QuestVictimNPC_var ::temp9 ;2 variable args
            ; line 4233
            cast ::temp10 None 
            cmp_eq ::temp2 ::QuestTargetAlias_var ::temp10 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label9
            ; line 4234
            cast ::temp3 ::QuestVictimNPC_var 
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::temp3 ;1 variable args
            ; line 4235
            propget QUEST_OBJECTIVE_ID self ::temp0 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp0 False False ;3 variable args
            ; line 4236
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 4237
            propget QUEST_OBJECTIVE_ID self ::temp0 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp0 True False ;3 variable args
            ; line 4238
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: quest marker moved to victim" ;1 variable args
            jmp _label9
          _label9:
            jmp _label8
            ; line 4243
          _label8:
            cmp_eq ::temp2 ::QuestSubType_var "find_item" 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label10
            cmp_eq ::temp2 ::QuestItemName_var "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label10:
            jmpf ::temp2 _label11
            ; line 4244
            callstatic intelEngine SpawnQuestChest ::temp3 victimAnchor ::QuestItemName_var ;2 variable args
            assign chest ::temp3 
            ; line 4245
            cast ::temp3 None 
            cmp_eq ::temp2 chest ::temp3 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label12
            ; line 4246
            assign ::QuestItemChest_var chest 
            ; line 4247
            strcat ::temp4 "Story [quest/find_item]: placed chest with " ::QuestItemName_var 
            strcat ::temp4 ::temp4 " at " 
            strcat ::temp4 ::temp4 ::QuestLocationName_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            ; line 4249
            cast ::temp10 None 
            cmp_eq ::temp2 ::QuestTargetAlias_var ::temp10 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label13
            ; line 4250
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::QuestItemChest_var ;1 variable args
            ; line 4251
            propget QUEST_OBJECTIVE_ID self ::temp0 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp0 False False ;3 variable args
            ; line 4252
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 4253
            propget QUEST_OBJECTIVE_ID self ::temp0 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp0 True False ;3 variable args
            ; line 4254
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/find_item]: quest marker moved to chest" ;1 variable args
            jmp _label13
            ; line 4257
          _label13:
            callstatic intelEngine SpawnQuestBoss ::temp1 ::QuestItemChest_var ::QuestEnemyType_var ;2 variable args
            assign boss ::temp1 
            ; line 4258
            cast ::temp1 None 
            cmp_eq ::temp2 boss ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label14
            ; line 4259
            assign ::QuestBossNPC_var boss 
            ; line 4260
            cast ::temp7 player 
            cast ::temp11 boss 
            callstatic storageUtil FormListAdd ::temp0 ::temp7 "Intel_QuestSpawnedNPCs" ::temp11 True ;4 variable args
            ; line 4261
            iadd ::temp0 ::QuestSpawnCount_var 1 
            assign ::QuestSpawnCount_var ::temp0 
            ; line 4262
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/find_item]: spawned boss near chest" ;1 variable args
            jmp _label14
          _label14:
            jmp _label15
            ; line 4265
          _label12:
            strcat ::temp4 "Story [quest/find_item]: WARNING - chest spawn failed for " ::QuestItemName_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
          _label15:
            jmp _label11
            ; line 4270
          _label11:
            callstatic intelEngine SpawnQuestEnemies ::temp12 enemyAnchor ::QuestEnemyType_var ;2 variable args
            assign spawnedActors ::temp12 
            ; line 4271
            array_length ::temp0 spawnedActors 
            assign regularCount ::temp0 
            ; line 4272
            iadd ::temp0 ::QuestSpawnCount_var regularCount 
            assign ::QuestSpawnCount_var ::temp0 
            ; line 4274
            cmp_gt ::temp2 regularCount 0 
            jmpf ::temp2 _label16
            ; line 4276
            assign i 0 
            ; line 4277
          _label18:
            cmp_lt ::temp2 i regularCount 
            jmpf ::temp2 _label17
            ; line 4278
            array_getlement ::temp1 spawnedActors i 
            callmethod DisableNoWait ::temp1 ::nonevar False ;1 variable args
            ; line 4279
            callstatic utility RandomFloat ::temp9 -300.0 300.0 ;2 variable args
            callstatic utility RandomFloat ::temp13 -300.0 300.0 ;2 variable args
            array_getlement ::temp1 spawnedActors i 
            callmethod MoveTo ::temp1 ::nonevar enemyAnchor ::temp9 ::temp13 0.0 True ;5 variable args
            ; line 4280
            cast ::temp11 player 
            array_getlement ::temp1 spawnedActors i 
            cast ::temp7 ::temp1 
            callstatic storageUtil FormListAdd ::temp0 ::temp11 "Intel_QuestSpawnedNPCs" ::temp7 True ;4 variable args
            ; line 4281
            iadd ::temp0 i 1 
            assign i ::temp0 
            jmp _label18
            ; line 4283
          _label17:
            assign i 0 
            ; line 4284
          _label20:
            cmp_lt ::temp2 i regularCount 
            jmpf ::temp2 _label19
            ; line 4285
            array_getlement ::temp1 spawnedActors i 
            callmethod EnableNoWait ::temp1 ::nonevar False ;1 variable args
            ; line 4286
            iadd ::temp0 i 1 
            assign i ::temp0 
            jmp _label20
            ; line 4290
          _label19:
            cast ::temp1 None 
            cmp_eq ::temp2 ::QuestBossNPC_var ::temp1 
            jmpf ::temp2 _label21
            ; line 4291
            callstatic intelEngine SpawnQuestBoss ::temp1 enemyAnchor ::QuestEnemyType_var ;2 variable args
            assign ::mangled_boss_0 ::temp1 
            ; line 4292
            cast ::temp1 None 
            cmp_eq ::temp2 ::mangled_boss_0 ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label22
            ; line 4293
            callmethod DisableNoWait ::mangled_boss_0 ::nonevar False ;1 variable args
            ; line 4294
            callstatic utility RandomFloat ::temp13 -150.0 150.0 ;2 variable args
            callstatic utility RandomFloat ::temp9 -150.0 150.0 ;2 variable args
            callmethod MoveTo ::mangled_boss_0 ::nonevar enemyAnchor ::temp13 ::temp9 0.0 True ;5 variable args
            ; line 4295
            assign ::QuestBossNPC_var ::mangled_boss_0 
            ; line 4296
            cast ::temp7 player 
            cast ::temp11 ::mangled_boss_0 
            callstatic storageUtil FormListAdd ::temp0 ::temp7 "Intel_QuestSpawnedNPCs" ::temp11 True ;4 variable args
            ; line 4297
            iadd ::temp0 ::QuestSpawnCount_var 1 
            assign ::QuestSpawnCount_var ::temp0 
            ; line 4298
            callmethod EnableNoWait ::mangled_boss_0 ::nonevar False ;1 variable args
            jmp _label22
          _label22:
            jmp _label21
            ; line 4302
          _label21:
            assign ::QuestEnemiesSpawned_var True 
            ; line 4303
            strcat ::temp4 "Story [quest/" ::QuestSubType_var 
            strcat ::temp4 ::temp4 "]: spawned " 
            cast ::temp14 ::QuestSpawnCount_var 
            strcat ::temp14 ::temp4 ::temp14 
            strcat ::temp14 ::temp14 " " 
            strcat ::temp14 ::temp14 ::QuestEnemyType_var 
            strcat ::temp14 ::temp14 " at " 
            strcat ::temp14 ::temp14 ::QuestLocationName_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp14 ;1 variable args
            ; line 4306
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
            ; line 4307
            cast ::temp3 ::QuestBossNPC_var 
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::temp3 ;1 variable args
            ; line 4308
            propget QUEST_OBJECTIVE_ID self ::temp0 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp0 False False ;3 variable args
            ; line 4309
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 4310
            propget QUEST_OBJECTIVE_ID self ::temp0 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp0 True False ;3 variable args
            ; line 4311
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/combat]: quest marker moved to boss" ;1 variable args
            jmp _label25
          _label25:
            jmp _label26
            ; line 4313
          _label16:
            comp_gte ::temp2 ::QuestSpawnAttempts_var 3 
            jmpf ::temp2 _label27
            ; line 4316
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: spawn failed after 3 attempts, granting partial completion" ;1 variable args
            ; line 4317
            callstatic debug Notification ::nonevar "The area is quiet. The threat seems to have moved on." ;1 variable args
            ; line 4318
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
            ; line 4319
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
            ; line 4322
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
            ; line 4323
            propget QUEST_STANDING_REWARD self ::temp0 
            idiv ::temp0 ::temp0 2 
            callstatic intelEngine AdjustPlayerFactionStanding ::temp0 ::QuestAlliedFaction_var ::temp0 ;2 variable args
            ; line 4324
            callstatic intelEngine GetFactionDisplayName ::temp14 ::QuestAlliedFaction_var ;1 variable args
            assign allyName ::temp14 
            ; line 4325
            cmp_eq ::temp2 allyName "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label33
            ; line 4326
            strcat ::temp14 "The " allyName 
            strcat ::temp14 ::temp14 " acknowledge your willingness to help." 
            callstatic debug Notification ::nonevar ::temp14 ;1 variable args
            jmp _label33
          _label33:
            jmp _label32
            ; line 4329
          _label32:
            callmethod RemoveQuestMarker self ::nonevar True ;1 variable args
            ; line 4330
            callmethod CleanupQuest self ::nonevar ;0 variable args
            jmp _label26
            ; line 4332
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
            ; line 4337
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 4338
            cast ::temp1 player 
            callstatic storageUtil FormListCount ::temp2 ::temp1 "Intel_QuestSpawnedNPCs" ;2 variable args
            assign count ::temp2 
            ; line 4339
            cmp_eq ::temp3 count 0 
            jmpf ::temp3 _label0
            ; line 4340
            return False 
            jmp _label0
            ; line 4342
          _label0:
            assign i 0 
            ; line 4343
          _label6:
            cmp_lt ::temp3 i count 
            jmpf ::temp3 _label1
            ; line 4344
            cast ::temp1 player 
            callstatic storageUtil FormListGet ::temp1 ::temp1 "Intel_QuestSpawnedNPCs" i ;3 variable args
            cast ::temp0 ::temp1 
            assign spawned ::temp0 
            ; line 4347
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
            ; line 4348
            return False 
            jmp _label5
            ; line 4350
          _label5:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label6
            ; line 4352
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
            ; line 4358
            cast ::temp0 None 
            cmp_eq ::temp1 ::QuestVictimNPC_var ::temp0 
            jmpf ::temp1 _label0
            ; line 4359
            return True 
            jmp _label0
            ; line 4361
          _label0:
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 4362
            cast ::temp2 ::QuestVictimNPC_var 
            cast ::temp3 None 
            callstatic miscUtil ScanCellNPCs ::temp4 ::temp2 3000.0 ::temp3 True ;4 variable args
            assign nearbyNPCs ::temp4 
            ; line 4363
            assign i 0 
            ; line 4364
          _label5:
            array_length ::temp5 nearbyNPCs 
            cmp_lt ::temp1 i ::temp5 
            jmpf ::temp1 _label1
            ; line 4365
            array_getlement ::temp0 nearbyNPCs i 
            assign npc ::temp0 
            ; line 4366
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
            ; line 4367
            return False 
            jmp _label4
            ; line 4369
          _label4:
            iadd ::temp5 i 1 
            assign i ::temp5 
            jmp _label5
            ; line 4371
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
            ; line 4375
            cast ::temp0 None 
            cmp_eq ::temp1 ::QuestVictimNPC_var ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            assign ::temp1 ::QuestVictimFreed_var 
          _label0:
            jmpf ::temp1 _label1
            ; line 4376
            return None 
            jmp _label1
            ; line 4378
          _label1:
            assign ::QuestVictimFreed_var True 
            ; line 4379
            jmpf ::QuestVictimInFurniture_var _label2
            ; line 4381
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4382
            cast ::temp2 ::QuestVictimNPC_var 
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar ::temp2 0.0 0.0 0.0 True ;5 variable args
            ; line 4383
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4384
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story [quest/rescue]: victim " ::temp3 
            strcat ::temp3 ::temp3 " freed from furniture" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label3
            ; line 4387
          _label2:
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4388
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4389
            callmethod GetDisplayName ::QuestVictimNPC_var ::temp3 ;0 variable args
            strcat ::temp3 "Story [quest/rescue]: victim " ::temp3 
            strcat ::temp3 ::temp3 " freed from bleedout" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 4392
          _label3:
            callmethod RestoreActorValue ::QuestVictimNPC_var ::nonevar "Health" 500.0 ;2 variable args
            ; line 4393
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
            ; line 4398
            not ::temp0 ::QuestActive_var 
            jmpf ::temp0 _label0
            ; line 4399
            return None 
            jmp _label0
            ; line 4401
          _label0:
            assign ::QuestActive_var False 
            ; line 4404
            cmp_eq ::temp0 ::QuestAlliedFaction_var "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label1
            ; line 4405
            callstatic intelEngine RestorePlayerCrimeFactions ::nonevar ;0 variable args
            jmp _label1
            ; line 4408
          _label1:
            strcat ::temp1 "Story [quest/" ::QuestSubType_var 
            strcat ::temp1 ::temp1 "]: Completed at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            strcat ::temp1 ::temp1 "!" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 4410
            callstatic game GetPlayer ::temp2 ;0 variable args
            callmethod GetDisplayName ::temp2 ::temp1 ;0 variable args
            assign playerName ::temp1 
            ; line 4412
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            jmpf ::temp0 _label2
            ; line 4414
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            callmethod IsDead ::QuestVictimNPC_var ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 4415
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/rescue]: victim died before completion could finalize — redirecting to failed" ;1 variable args
            ; line 4416
            callmethod OnQuestFailed self ::nonevar ;0 variable args
            ; line 4417
            return None 
            jmp _label4
            ; line 4419
          _label4:
            callmethod NotifyPlayer ::Core_var ::nonevar "Rescue completed!" ;1 variable args
            ; line 4420
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label5
            ; line 4421
            strcat ::temp1 "learned that " playerName 
            strcat ::temp1 ::temp1 " rescued " 
            strcat ::temp1 ::temp1 ::QuestVictimName_var 
            strcat ::temp1 ::temp1 " from " 
            strcat ::temp1 ::temp1 ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp1 ;2 variable args
            jmp _label5
            ; line 4423
          _label5:
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestVictimNPC_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label6
            ; line 4425
            callstatic intelEngine GetPlayerInteractionCount ::temp3 ::QuestVictimNPC_var ;1 variable args
            assign victimAwareness ::temp3 
            ; line 4426
            cmp_eq ::temp0 victimAwareness 0 
            jmpf ::temp0 _label7
            ; line 4428
            strcat ::temp1 "was rescued from " ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " captivity at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            strcat ::temp1 ::temp1 " by a stranger whose name I didn't know at the time" 
            callmethod InjectFact ::Core_var ::nonevar ::QuestVictimNPC_var ::temp1 ;2 variable args
            ; line 4429
            cast ::temp4 ::QuestVictimNPC_var 
            strcat ::temp1 "was just freed from " ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " captivity by a stranger whose name they don't know" 
            callstatic storageUtil SetStringValue ::temp1 ::temp4 "Intel_RescueNarration" ::temp1 ;3 variable args
            jmp _label8
            ; line 4430
          _label7:
            cmp_eq ::temp0 victimAwareness 1 
            jmpf ::temp0 _label9
            ; line 4432
            strcat ::temp1 "was rescued by " playerName 
            strcat ::temp1 ::temp1 " from " 
            strcat ::temp1 ::temp1 ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " captivity at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            strcat ::temp1 ::temp1 ". I recognized them — I'd seen them around before but we had never actually spoken" 
            callmethod InjectFact ::Core_var ::nonevar ::QuestVictimNPC_var ::temp1 ;2 variable args
            ; line 4433
            cast ::temp4 ::QuestVictimNPC_var 
            strcat ::temp1 "was just freed from " ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " captivity by " 
            strcat ::temp1 ::temp1 playerName 
            strcat ::temp1 ::temp1 ", someone they recognized from around town but had never spoken to before" 
            callstatic storageUtil SetStringValue ::temp1 ::temp4 "Intel_RescueNarration" ::temp1 ;3 variable args
            jmp _label8
            ; line 4436
          _label9:
            strcat ::temp1 "was rescued by " playerName 
            strcat ::temp1 ::temp1 " from " 
            strcat ::temp1 ::temp1 ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " captivity at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestVictimNPC_var ::temp1 ;2 variable args
            ; line 4437
            cast ::temp4 ::QuestVictimNPC_var 
            strcat ::temp1 "was just freed from " ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " captivity by " 
            strcat ::temp1 ::temp1 playerName 
            callstatic storageUtil SetStringValue ::temp1 ::temp4 "Intel_RescueNarration" ::temp1 ;3 variable args
            ; line 4440
          _label8:
            cast ::temp4 ::QuestVictimNPC_var 
            callstatic storageUtil GetIntValue ::temp3 ::temp4 "Intel_WasEssential" -1 ;3 variable args
            assign wasEssential ::temp3 
            ; line 4441
            comp_gte ::temp0 wasEssential 0 
            jmpf ::temp0 _label10
            ; line 4442
            cast ::temp0 wasEssential 
            callmethod GetActorBase ::QuestVictimNPC_var ::temp5 ;0 variable args
            callmethod SetEssential ::temp5 ::nonevar ::temp0 ;1 variable args
            ; line 4443
            cast ::temp4 ::QuestVictimNPC_var 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp4 "Intel_WasEssential" ;2 variable args
            jmp _label10
            ; line 4447
          _label10:
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label11
            ; line 4448
            cast ::temp4 ::QuestVictimNPC_var 
            cast ::temp6 ::QuestGiver_var 
            callstatic storageUtil SetFormValue ::temp6 ::temp4 "Intel_RescueQuestGiver" ::temp6 ;3 variable args
            ; line 4449
            cast ::temp6 ::QuestVictimNPC_var 
            callstatic storageUtil SetStringValue ::temp1 ::temp6 "Intel_RescuePlayerName" playerName ;3 variable args
            ; line 4450
            cast ::temp6 ::QuestVictimNPC_var 
            callstatic utility GetCurrentGameTime ::temp7 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp7 ::temp6 "Intel_RescueTime" ::temp7 ;3 variable args
            ; line 4452
            callstatic game GetPlayer ::temp2 ;0 variable args
            assign trackedPlayer ::temp2 
            ; line 4453
            cast ::temp6 trackedPlayer 
            cast ::temp4 ::QuestVictimNPC_var 
            callstatic storageUtil FormListFind ::temp3 ::temp6 "Intel_RecentlyRescuedNPCs" ::temp4 ;3 variable args
            cmp_lt ::temp0 ::temp3 0 
            jmpf ::temp0 _label12
            ; line 4454
            cast ::temp4 trackedPlayer 
            cast ::temp6 ::QuestVictimNPC_var 
            callstatic storageUtil FormListAdd ::temp3 ::temp4 "Intel_RecentlyRescuedNPCs" ::temp6 True ;4 variable args
            jmp _label12
          _label12:
            jmp _label11
            ; line 4462
          _label11:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestVictimNPC_var False ;2 variable args
            ; line 4463
            cast ::temp8 ::QuestVictimNPC_var 
            callstatic game GetPlayer ::temp2 ;0 variable args
            cast ::temp9 ::temp2 
            propget IntelEngine_TravelTarget ::Core_var ::temp10 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp8 ::temp9 ::temp10 ;3 variable args
            ; line 4464
            propget TravelPackage_Walk ::Core_var ::temp11 
            propget PRIORITY_TRAVEL ::Core_var ::temp3 
            callstatic actorUtil AddPackageOverride ::nonevar ::QuestVictimNPC_var ::temp11 ::temp3 1 ;4 variable args
            ; line 4465
            cast ::temp6 ::QuestVictimNPC_var 
            callstatic storageUtil SetIntValue ::temp3 ::temp6 "Intel_MeetingLingerApproaching" 1 ;3 variable args
            ; line 4466
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 4467
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4468
            callmethod StartStoryLinger self ::nonevar ::QuestVictimNPC_var ;1 variable args
            ; line 4470
            cast ::temp2 None 
            assign ::QuestVictimNPC_var ::temp2 
            jmp _label6
          _label6:
            jmp _label13
            ; line 4472
          _label2:
            cmp_eq ::temp0 ::QuestSubType_var "find_item" 
            jmpf ::temp0 _label14
            ; line 4473
            strcat ::temp1 "You claim the " ::QuestItemDesc_var 
            strcat ::temp1 ::temp1 "." 
            callmethod NotifyPlayer ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 4474
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label15
            ; line 4475
            strcat ::temp1 "learned that " playerName 
            strcat ::temp1 ::temp1 " found " 
            strcat ::temp1 ::temp1 ::QuestItemDesc_var 
            strcat ::temp1 ::temp1 " at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp1 ;2 variable args
            jmp _label15
          _label15:
            jmp _label13
            ; line 4477
          _label14:
            cmp_eq ::temp0 ::QuestSubType_var "faction_battle" 
            jmpf ::temp0 _label16
            ; line 4479
            callstatic intelEngine RecordFactionBattleCompletion ::temp1 ::QuestAlliedFaction_var ::QuestLocationName_var playerName ::QuestBattleEnemyFaction_var ;4 variable args
            assign completionJson ::temp1 
            ; line 4480
            callstatic intelEngine StoryResponseGetField ::temp1 completionJson "notification" ;2 variable args
            assign completionNotif ::temp1 
            ; line 4481
            cmp_eq ::temp0 completionNotif "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label17
            ; line 4482
            callstatic debug Notification ::nonevar completionNotif ;1 variable args
            jmp _label17
            ; line 4485
          _label17:
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label18
            ; line 4486
            callstatic intelEngine StoryResponseGetField ::temp1 completionJson "questGiverFact" ;2 variable args
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp1 ;2 variable args
            jmp _label18
            ; line 4488
          _label18:
            callstatic intelEngine StoryResponseGetField ::temp1 completionJson "leaderFact" ;2 variable args
            assign leaderFact ::temp1 
            ; line 4489
            cmp_eq ::temp0 leaderFact "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label19
            ; line 4490
            callstatic intelEngine GetFactionLeaderActors ::temp12 ::QuestAlliedFaction_var ;1 variable args
            assign leaders ::temp12 
            ; line 4491
            assign li 0 
            ; line 4492
          _label23:
            array_length ::temp3 leaders 
            cmp_lt ::temp0 li ::temp3 
            jmpf ::temp0 _label20
            ; line 4493
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
            ; line 4494
            array_getlement ::temp2 leaders li 
            callmethod InjectFact ::Core_var ::nonevar ::temp2 leaderFact ;2 variable args
            jmp _label22
            ; line 4496
          _label22:
            iadd ::temp3 li 1 
            assign li ::temp3 
            jmp _label23
          _label20:
            jmp _label19
          _label19:
            jmp _label13
            ; line 4501
          _label16:
            callmethod NotifyPlayer ::Core_var ::nonevar "The threat has been dealt with." ;1 variable args
            ; line 4502
            cast ::temp2 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label13
            ; line 4503
            strcat ::temp1 "learned that " playerName 
            strcat ::temp1 ::temp1 " dealt with the " 
            strcat ::temp1 ::temp1 ::QuestEnemyType_var 
            strcat ::temp1 ::temp1 " threat at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp1 ;2 variable args
            jmp _label13
            ; line 4508
          _label13:
            callstatic intelEngine ExtractFactionId ::temp1 ::QuestEnemyType_var ;1 variable args
            assign enemyFactionId ::temp1 
            ; line 4509
            assign enemyFactionDisplayName "" 
            ; line 4510
            cmp_eq ::temp0 enemyFactionId "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label24
            ; line 4511
            callstatic intelEngine GetFactionDisplayName ::temp1 enemyFactionId ;1 variable args
            assign enemyFactionDisplayName ::temp1 
            jmp _label24
            ; line 4515
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
            ; line 4516
            assign guideEnemyDesc ::QuestEnemyType_var 
            ; line 4517
            cmp_eq ::temp0 enemyFactionDisplayName "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label27
            ; line 4518
            strcat ::temp1 enemyFactionDisplayName " soldiers" 
            assign guideEnemyDesc ::temp1 
            jmp _label27
            ; line 4520
          _label27:
            strcat ::temp1 "witnessed " playerName 
            strcat ::temp1 ::temp1 " clear the " 
            strcat ::temp1 ::temp1 guideEnemyDesc 
            strcat ::temp1 ::temp1 " at " 
            strcat ::temp1 ::temp1 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGuideNPC_var ::temp1 ;2 variable args
            jmp _label26
            ; line 4526
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
            ; line 4527
            cmp_eq ::temp0 enemyFactionId "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label30
            ; line 4528
            propget QUEST_STANDING_PENALTY self ::temp3 
            callstatic intelEngine AdjustPlayerFactionStanding ::temp3 enemyFactionId ::temp3 ;2 variable args
            ; line 4529
            strcat ::temp1 "Story [quest/" ::QuestSubType_var 
            strcat ::temp1 ::temp1 "]: Standing " 
            propget QUEST_STANDING_PENALTY self ::temp3 
            cast ::temp13 ::temp3 
            strcat ::temp13 ::temp1 ::temp13 
            strcat ::temp13 ::temp13 " with " 
            strcat ::temp13 ::temp13 enemyFactionId 
            callmethod DebugMsg ::Core_var ::nonevar ::temp13 ;1 variable args
            jmp _label30
            ; line 4531
          _label30:
            propget QUEST_STANDING_REWARD self ::temp3 
            callstatic intelEngine AdjustPlayerFactionStanding ::temp3 ::QuestAlliedFaction_var ::temp3 ;2 variable args
            ; line 4532
            strcat ::temp13 "Story [quest/" ::QuestSubType_var 
            strcat ::temp13 ::temp13 "]: Standing +" 
            propget QUEST_STANDING_REWARD self ::temp3 
            cast ::temp1 ::temp3 
            strcat ::temp1 ::temp13 ::temp1 
            strcat ::temp1 ::temp1 " with " 
            strcat ::temp1 ::temp1 ::QuestAlliedFaction_var 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 4534
            callstatic intelEngine GetFactionDisplayName ::temp1 ::QuestAlliedFaction_var ;1 variable args
            assign allyName ::temp1 
            ; line 4535
            cmp_eq ::temp0 allyName "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label31
            ; line 4536
            callstatic utility RandomInt ::temp3 0 2 ;2 variable args
            assign standingRoll ::temp3 
            ; line 4537
            cmp_eq ::temp0 standingRoll 0 
            jmpf ::temp0 _label32
            ; line 4538
            strcat ::temp1 "Your name carries weight among the " allyName 
            strcat ::temp1 ::temp1 "." 
            callstatic debug Notification ::nonevar ::temp1 ;1 variable args
            jmp _label33
            ; line 4539
          _label32:
            cmp_eq ::temp0 standingRoll 1 
            jmpf ::temp0 _label34
            ; line 4540
            strcat ::temp1 "The " allyName 
            strcat ::temp1 ::temp1 " speak your name with respect." 
            callstatic debug Notification ::nonevar ::temp1 ;1 variable args
            jmp _label33
            ; line 4542
          _label34:
            strcat ::temp1 "Word of your deeds reaches the " allyName 
            strcat ::temp1 ::temp1 "." 
            callstatic debug Notification ::nonevar ::temp1 ;1 variable args
          _label33:
            jmp _label31
          _label31:
            jmp _label29
            ; line 4547
          _label29:
            callmethod RemoveQuestMarker self ::nonevar True ;1 variable args
            ; line 4548
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
            ; line 4552
            strcat ::temp0 "Story [quest/" ::QuestSubType_var 
            strcat ::temp0 ::temp0 "]: Failed at " 
            strcat ::temp0 ::temp0 ::QuestLocationName_var 
            strcat ::temp0 ::temp0 " — victim died" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 4554
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName ::temp1 ::temp0 ;0 variable args
            assign playerName ::temp0 
            ; line 4556
            strcat ::temp0 ::QuestVictimName_var " didn't make it." 
            callmethod NotifyPlayer ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 4557
            cast ::temp1 None 
            cmp_eq ::temp2 ::QuestGiver_var ::temp1 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label0
            ; line 4558
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
            ; line 4561
          _label0:
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 4562
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
            ; line 4568
            not ::temp0 ::QuestActive_var 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cmp_lte ::temp0 ::QuestStartTime_var 0.0 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 4569
            return None 
            jmp _label1
            ; line 4571
          _label1:
            callstatic utility GetCurrentGameTime ::temp1 ;0 variable args
            fsub ::temp1 ::temp1 ::QuestStartTime_var 
            assign elapsed ::temp1 
            ; line 4573
            not ::temp0 ::QuestExpiryWarned_var 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label2
            fmul ::temp1 ::QUEST_EXPIRY_DAYS_var 0.75 
            cmp_gt ::temp0 elapsed ::temp1 
            assign ::temp0 ::temp0 
          _label2:
            jmpf ::temp0 _label3
            ; line 4574
            assign ::QuestExpiryWarned_var True 
            ; line 4575
            callstatic debug Notification ::nonevar "You should hurry — the situation won't hold much longer." ;1 variable args
            jmp _label3
            ; line 4577
          _label3:
            cmp_gt ::temp0 elapsed ::QUEST_EXPIRY_DAYS_var 
            jmpf ::temp0 _label4
            ; line 4578
            strcat ::temp2 "Story [quest/" ::QuestSubType_var 
            strcat ::temp2 ::temp2 "]: Expired after " 
            cast ::temp3 ::QUEST_EXPIRY_DAYS_var 
            strcat ::temp3 ::temp2 ::temp3 
            strcat ::temp3 ::temp3 " days" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            ; line 4579
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod GetDisplayName ::temp4 ::temp3 ;0 variable args
            assign playerName ::temp3 
            ; line 4580
            cmp_eq ::temp0 ::QuestSubType_var "rescue" 
            jmpf ::temp0 _label5
            ; line 4581
            cast ::temp4 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label6
            ; line 4582
            strcat ::temp3 "grew desperate -- " ::QuestVictimName_var 
            strcat ::temp3 ::temp3 " may be lost, " 
            strcat ::temp3 ::temp3 playerName 
            strcat ::temp3 ::temp3 " never came to help" 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp3 ;2 variable args
            jmp _label6
          _label6:
            jmp _label7
            ; line 4585
          _label5:
            cmp_eq ::temp0 ::QuestSubType_var "find_item" 
            jmpf ::temp0 _label8
            ; line 4586
            cast ::temp4 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label9
            ; line 4587
            strcat ::temp3 "gave up hope that " playerName 
            strcat ::temp3 ::temp3 " would find " 
            strcat ::temp3 ::temp3 ::QuestItemDesc_var 
            strcat ::temp3 ::temp3 " at " 
            strcat ::temp3 ::temp3 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp3 ;2 variable args
            jmp _label9
          _label9:
            jmp _label7
            ; line 4589
          _label8:
            cmp_eq ::temp0 ::QuestSubType_var "faction_battle" 
            jmpf ::temp0 _label10
            ; line 4590
            cast ::temp4 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label11
            ; line 4591
            callstatic intelEngine GetFactionDisplayName ::temp3 ::QuestAlliedFaction_var ;1 variable args
            assign allyNameExpiry ::temp3 
            ; line 4592
            strcat ::temp3 "noted that " playerName 
            strcat ::temp3 ::temp3 " never arrived to fight alongside the " 
            strcat ::temp3 ::temp3 allyNameExpiry 
            strcat ::temp3 ::temp3 " at " 
            strcat ::temp3 ::temp3 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp3 ;2 variable args
            jmp _label11
            ; line 4595
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
            ; line 4596
            propget Battle ::Core_var ::temp6 
            callmethod ResetState ::temp6 ::nonevar ;0 variable args
            ; line 4597
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest/faction_battle]: cancelled scheduled battle on expiry" ;1 variable args
            jmp _label15
            ; line 4599
          _label15:
            callstatic debug Notification ::nonevar "Word reaches you: the battle has moved on." ;1 variable args
            jmp _label7
            ; line 4601
          _label10:
            cast ::temp4 None 
            cmp_eq ::temp0 ::QuestGiver_var ::temp4 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label7
            ; line 4602
            strcat ::temp3 "grew disappointed that " playerName 
            strcat ::temp3 ::temp3 " never dealt with the " 
            strcat ::temp3 ::temp3 ::QuestEnemyType_var 
            strcat ::temp3 ::temp3 " threat at " 
            strcat ::temp3 ::temp3 ::QuestLocationName_var 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp3 ;2 variable args
            jmp _label7
            ; line 4605
          _label7:
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 4606
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
            ; line 4612
            callmethod RemoveQuestMarker self ::nonevar False ;1 variable args
            ; line 4614
            strcat ::temp0 "quest/" ::QuestSubType_var 
            strcat ::temp0 ::temp0 ": " 
            strcat ::temp0 ::temp0 ::QuestEnemyType_var 
            strcat ::temp0 ::temp0 " at " 
            strcat ::temp0 ::temp0 ::QuestLocationName_var 
            assign eventText ::temp0 
            ; line 4615
            callstatic game GetPlayer ::temp1 ;0 variable args
            cast ::temp2 ::temp1 
            callstatic storageUtil FormListClear ::temp3 ::temp2 "Intel_QuestSpawnedNPCs" ;2 variable args
            ; line 4620
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
            ; line 4621
            callmethod FindSlotByAgent ::Core_var ::temp3 ::ActiveStoryNPC_var ;1 variable args
            assign courierSlot ::temp3 
            ; line 4622
            comp_gte ::temp4 courierSlot 0 
            jmpf ::temp4 _label3
            ; line 4623
            callmethod ClearSlot ::Core_var ::nonevar courierSlot True False ;3 variable args
            jmp _label3
            ; line 4625
          _label3:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 4629
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp5 ::temp2 "Intel_OrigAggression" -1.0 ;3 variable args
            assign origAggr ::temp5 
            ; line 4630
            comp_gte ::temp4 origAggr 0.0 
            jmpf ::temp4 _label4
            ; line 4631
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Aggression" origAggr ;2 variable args
            ; line 4632
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp4 ::temp2 "Intel_OrigAggression" ;2 variable args
            jmp _label4
            ; line 4634
          _label4:
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetIntValue ::temp4 ::temp2 "Intel_IsStoryDispatch" ;2 variable args
            ; line 4635
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_StoryNarration" ;2 variable args
            ; line 4636
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_MessageSender" ;2 variable args
            ; line 4637
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_MessageContent" ;2 variable args
            ; line 4638
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_QuestLocation" ;2 variable args
            ; line 4639
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetIntValue ::temp4 ::temp2 "Intel_SneakPhase" ;2 variable args
            ; line 4640
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp4 ::temp2 "Intel_SneakStartTime" ;2 variable args
            ; line 4641
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp4 ::temp2 "Intel_CombatStartTime" ;2 variable args
            ; line 4642
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp4 ::temp2 "Intel_OffscreenArrival" ;2 variable args
            ; line 4643
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_MessageDest" ;2 variable args
            ; line 4644
            cast ::temp2 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_MessageTime" ;2 variable args
            ; line 4645
            cast ::temp1 None 
            assign ::ActiveStoryNPC_var ::temp1 
            ; line 4646
            assign ::ActiveNarration_var "" 
            ; line 4647
            assign ::ActiveStoryType_var "" 
            ; line 4648
            assign ::IsActive_var False 
            ; line 4649
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: cleared courier dispatch (quest cancelled)" ;1 variable args
            jmp _label2
            ; line 4652
          _label2:
            cast ::temp1 None 
            cmp_eq ::temp4 ::QuestGuideNPC_var ::temp1 
            not ::temp4 ::temp4 
            jmpf ::temp4 _label5
            ; line 4653
            callmethod FindSlotByAgent ::Core_var ::temp3 ::QuestGuideNPC_var ;1 variable args
            assign slot ::temp3 
            ; line 4654
            comp_gte ::temp4 slot 0 
            jmpf ::temp4 _label6
            ; line 4655
            callmethod ClearSlot ::Core_var ::nonevar slot True False ;3 variable args
            jmp _label6
            ; line 4657
          _label6:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestGuideNPC_var False ;2 variable args
            jmp _label5
            ; line 4661
          _label5:
            cast ::temp1 None 
            cmp_eq ::temp4 ::QuestVictimNPC_var ::temp1 
            not ::temp4 ::temp4 
            jmpf ::temp4 _label7
            ; line 4662
            jmpf ::QuestVictimInFurniture_var _label8
            ; line 4663
            cast ::temp6 ::QuestVictimNPC_var 
            callmethod MoveTo ::QuestVictimNPC_var ::nonevar ::temp6 0.0 0.0 0.0 True ;5 variable args
            jmp _label8
            ; line 4665
          _label8:
            callmethod SetRestrained ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4666
            callmethod SetDontMove ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4667
            callmethod SetNoBleedoutRecovery ::QuestVictimNPC_var ::nonevar False ;1 variable args
            ; line 4668
            callmethod RestoreActorValue ::QuestVictimNPC_var ::nonevar "Health" 500.0 ;2 variable args
            ; line 4669
            cast ::temp2 ::QuestVictimNPC_var 
            callstatic storageUtil UnsetStringValue ::temp4 ::temp2 "Intel_RescueNarration" ;2 variable args
            ; line 4670
            callmethod RemoveAllPackages ::Core_var ::nonevar ::QuestVictimNPC_var False ;2 variable args
            ; line 4672
            cast ::temp2 ::QuestVictimNPC_var 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "Intel_WasEssential" -1 ;3 variable args
            assign wasEssential ::temp3 
            ; line 4673
            comp_gte ::temp4 wasEssential 0 
            jmpf ::temp4 _label9
            ; line 4674
            cast ::temp4 wasEssential 
            callmethod GetActorBase ::QuestVictimNPC_var ::temp7 ;0 variable args
            callmethod SetEssential ::temp7 ::nonevar ::temp4 ;1 variable args
            ; line 4675
            cast ::temp2 ::QuestVictimNPC_var 
            callstatic storageUtil UnsetIntValue ::temp4 ::temp2 "Intel_WasEssential" ;2 variable args
            jmp _label9
            ; line 4678
          _label9:
            not ::temp4 ::QuestVictimFreed_var 
            jmpf ::temp4 _label10
            ; line 4679
            strcat ::temp0 "managed to escape " ::QuestEnemyType_var 
            strcat ::temp0 ::temp0 " captivity at " 
            strcat ::temp0 ::temp0 ::QuestLocationName_var 
            strcat ::temp0 ::temp0 " on my own" 
            callmethod InjectFact ::Core_var ::nonevar ::QuestVictimNPC_var ::temp0 ;2 variable args
            jmp _label10
            ; line 4681
          _label10:
            callmethod MoveToMyEditorLocation ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4683
            callmethod EvaluatePackage ::QuestVictimNPC_var ::nonevar ;0 variable args
            ; line 4684
            cast ::temp1 None 
            assign ::QuestVictimNPC_var ::temp1 
            jmp _label7
            ; line 4688
          _label7:
            cast ::temp6 None 
            cmp_eq ::temp4 ::QuestItemChest_var ::temp6 
            not ::temp4 ::temp4 
            jmpf ::temp4 _label11
            ; line 4689
            callmethod Disable ::QuestItemChest_var ::nonevar False ;1 variable args
            ; line 4690
            callmethod Delete ::QuestItemChest_var ::nonevar ;0 variable args
            ; line 4691
            cast ::temp6 None 
            assign ::QuestItemChest_var ::temp6 
            jmp _label11
            ; line 4695
          _label11:
            cast ::temp6 None 
            cmp_eq ::temp4 ::QuestBattleMarker_var ::temp6 
            not ::temp4 ::temp4 
            jmpf ::temp4 _label12
            ; line 4696
            callmethod Disable ::QuestBattleMarker_var ::nonevar False ;1 variable args
            ; line 4697
            callmethod Delete ::QuestBattleMarker_var ::nonevar ;0 variable args
            ; line 4698
            cast ::temp6 None 
            assign ::QuestBattleMarker_var ::temp6 
            jmp _label12
            ; line 4704
          _label12:
            cmp_eq ::temp4 ::QuestAlliedFaction_var "" 
            not ::temp4 ::temp4 
            jmpf ::temp4 _label13
            ; line 4705
            callstatic intelEngine RestorePlayerCrimeFactions ::nonevar ;0 variable args
            jmp _label13
            ; line 4708
          _label13:
            assign ::QuestActive_var False 
            ; line 4709
            callstatic intelEngine NotifyQuestCleared ::nonevar ;0 variable args
            ; line 4710
            cast ::temp1 None 
            assign ::QuestGiver_var ::temp1 
            ; line 4711
            cast ::temp1 None 
            assign ::QuestGuideNPC_var ::temp1 
            ; line 4712
            assign ::QuestGuideActive_var False 
            ; line 4713
            assign ::QuestGuideWaiting_var False 
            ; line 4714
            assign ::QuestGuideStartTime_var 0.0 
            ; line 4715
            cast ::temp6 None 
            assign ::QuestLocation_var ::temp6 
            ; line 4716
            assign ::QuestDeferredToInterior_var False 
            ; line 4717
            assign ::QuestEnemyType_var "" 
            ; line 4718
            assign ::QuestLocationName_var "" 
            ; line 4719
            assign ::QuestEnemiesSpawned_var False 
            ; line 4720
            assign ::QuestSpawnCount_var 0 
            ; line 4721
            assign ::QuestSpawnAttempts_var 0 
            ; line 4722
            assign ::QuestStartTime_var 0.0 
            ; line 4725
            assign ::QuestSubType_var "" 
            ; line 4726
            assign ::QuestBriefing_var "" 
            ; line 4727
            assign ::QuestVictimName_var "" 
            ; line 4728
            assign ::QuestItemDesc_var "" 
            ; line 4729
            assign ::QuestItemName_var "" 
            ; line 4730
            assign ::QuestAlliedFaction_var "" 
            ; line 4731
            assign ::QuestBattleScheduled_var False 
            ; line 4732
            assign ::QuestVictimFreed_var False 
            ; line 4733
            cast ::temp1 None 
            assign ::QuestBossNPC_var ::temp1 
            ; line 4734
            assign ::QuestPrePlaced_var False 
            ; line 4735
            cast ::temp6 None 
            assign ::QuestBossAnchor_var ::temp6 
            ; line 4736
            assign ::QuestFurnitureScanned_var False 
            ; line 4737
            assign ::QuestVictimInFurniture_var False 
            ; line 4738
            cast ::temp8 None 
            assign ::QuestDungeonLastCell_var ::temp8 
            ; line 4739
            assign ::QuestDungeonDepth_var 0 
            ; line 4740
            assign ::QuestDungeonScanFails_var 0 
            ; line 4741
            assign ::QuestExpiryWarned_var False 
            ; line 4743
            callmethod AddRecentStoryEvent self ::nonevar eventText ;1 variable args
            ; line 4744
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
            ; line 4754
            cast ::temp0 None 
            cmp_eq ::temp1 ::QuestTargetAlias_var ::temp0 
            jmpf ::temp1 _label0
            ; line 4755
            callmethod GetNumAliases self ::temp2 ;0 variable args
            isub ::temp2 ::temp2 1 
            assign i ::temp2 
            ; line 4756
          _label14:
            comp_gte ::temp1 i 1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            cast ::temp0 None 
            cmp_eq ::temp1 ::QuestTargetAlias_var ::temp0 
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 4757
            callmethod GetAlias self ::temp3 i ;1 variable args
            cast ::temp0 ::temp3 
            assign ra ::temp0 
            ; line 4758
            cast ::temp0 None 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            ; line 4759
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
            ; line 4760
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
            ; line 4761
          _label6:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label7
            propget AgentAlias04 ::Core_var ::temp0 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            ; line 4762
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
            ; line 4763
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
            ; line 4764
          _label11:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label12
            propget TargetAlias04 ::Core_var ::temp0 
            cmp_eq ::temp1 ra ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label12:
            jmpf ::temp1 _label13
            ; line 4765
            assign ::QuestTargetAlias_var ra 
            ; line 4766
            cast ::temp4 i 
            strcat ::temp4 "Story [quest]: Recovered QuestTargetAlias at alias index " ::temp4 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            jmp _label13
            ; line 4768
          _label13:
            isub ::temp2 i 1 
            assign i ::temp2 
            jmp _label14
          _label2:
            jmp _label0
            ; line 4771
          _label0:
            cast ::temp0 None 
            cmp_eq ::temp1 ::QuestTargetAlias_var ::temp0 
            jmpf ::temp1 _label15
            ; line 4772
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: WARNING - QuestTargetAlias not found! Check alias setup in CK" ;1 variable args
            ; line 4773
            callmethod NotifyPlayer ::Core_var ::nonevar "Quest marker unavailable (alias not found)" ;1 variable args
            ; line 4774
            return None 
            jmp _label15
            ; line 4776
          _label15:
            cast ::temp5 None 
            cmp_eq ::temp1 ::QuestLocation_var ::temp5 
            jmpf ::temp1 _label16
            ; line 4777
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: WARNING - QuestLocation is None, can't place marker" ;1 variable args
            ; line 4778
            return None 
            jmp _label16
            ; line 4780
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
            ; line 4782
            propget QUEST_OBJECTIVE_ID self ::temp2 
            callmethod SetObjectiveCompleted self ::nonevar ::temp2 False ;2 variable args
            ; line 4783
            propget QUEST_OBJECTIVE_ID self ::temp2 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp2 False False ;3 variable args
            ; line 4786
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
            ; line 4787
            cast ::temp5 ::QuestVictimNPC_var 
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::temp5 ;1 variable args
            ; line 4788
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: marker on victim (pre-placed deep inside)" ;1 variable args
            jmp _label20
            ; line 4789
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
            ; line 4790
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::QuestItemChest_var ;1 variable args
            ; line 4791
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: marker on chest (pre-placed deep inside)" ;1 variable args
            jmp _label20
            ; line 4792
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
            ; line 4793
            cast ::temp5 ::QuestBossNPC_var 
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::temp5 ;1 variable args
            ; line 4794
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: marker on boss (pre-placed deep inside)" ;1 variable args
            jmp _label20
            ; line 4795
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
            ; line 4798
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::QuestLocation_var ;1 variable args
            ; line 4799
            strcat ::temp4 "Story [quest]: temporary marker at " ::QuestLocationName_var 
            strcat ::temp4 ::temp4 " (moves to leader on spawn)" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            jmp _label20
            ; line 4801
          _label28:
            callmethod ForceRefTo ::QuestTargetAlias_var ::nonevar ::QuestLocation_var ;1 variable args
            ; line 4804
          _label20:
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 4805
            callmethod GetReference ::QuestTargetAlias_var ::temp5 ;0 variable args
            assign aliasRef ::temp5 
            ; line 4806
            cast ::temp4 aliasRef 
            strcat ::temp4 "Story [quest]: After ForceRefTo - aliasRef=" ::temp4 
            callmethod DebugMsg ::Core_var ::nonevar ::temp4 ;1 variable args
            ; line 4808
            callmethod SetActive self ::nonevar True ;1 variable args
            ; line 4810
            propget QUEST_OBJECTIVE_ID self ::temp2 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp2 True False ;3 variable args
            ; line 4812
            callmethod SetStage self ::temp1 100 ;1 variable args
            ; line 4813
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
            ; line 4817
            cast ::temp0 None 
            cmp_eq ::temp1 ::QuestTargetAlias_var ::temp0 
            jmpf ::temp1 _label0
            ; line 4818
            return None 
            jmp _label0
            ; line 4820
          _label0:
            jmpf completed _label1
            ; line 4821
            propget QUEST_OBJECTIVE_ID self ::temp2 
            callmethod SetObjectiveCompleted self ::nonevar ::temp2 True ;2 variable args
            ; line 4822
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: Objective completed, quest deactivated" ;1 variable args
            jmp _label2
            ; line 4824
          _label1:
            propget QUEST_OBJECTIVE_ID self ::temp2 
            callmethod SetObjectiveDisplayed self ::nonevar ::temp2 False False ;3 variable args
            ; line 4825
            callmethod DebugMsg ::Core_var ::nonevar "Story [quest]: Objective hidden, quest deactivated" ;1 variable args
            ; line 4827
          _label2:
            callmethod SetActive self ::nonevar False ;1 variable args
            ; line 4828
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
            ; line 4836
            callstatic intelEngine IsPlayerInDangerousLocation ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 4837
            return False 
            jmp _label0
            ; line 4839
          _label0:
            cmp_eq ::temp0 storyType "informant" 
            jmpf ::temp0 _label1
            ; line 4840
            callmethod GetDisplayName npc ::temp1 ;0 variable args
            strcat ::temp1 "Story: aborting informant for " ::temp1 
            strcat ::temp1 ::temp1 " -- danger zone" 
            strcat ::temp1 ::temp1 logSuffix 
            callmethod DebugMsg ::Core_var ::nonevar ::temp1 ;1 variable args
            ; line 4841
            callmethod GetDisplayName player ::temp1 ;0 variable args
            strcat ::temp1 "thought better of chasing " ::temp1 
            strcat ::temp1 ::temp1 " into danger just for gossip and turned back" 
            callmethod SendTaskNarration ::Core_var ::nonevar npc ::temp1 player ;3 variable args
            ; line 4842
            strcat ::temp1 "informant in danger zone" logSuffix 
            callmethod AbortStoryTravel self ::nonevar ::temp1 ;1 variable args
            ; line 4843
            return True 
            jmp _label1
            ; line 4845
          _label1:
            cmp_eq ::temp0 ::DangerZonePolicy_var 3 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label2
            ; line 4846
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
            ; line 4847
            cmp_eq ::temp0 ::DangerZonePolicy_var 1 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label5
            callstatic intelEngine IsCivilianClass ::temp0 npc ;1 variable args
            assign ::temp0 ::temp0 
          _label5:
            assign ::temp0 ::temp0 
          _label4:
            jmpf ::temp0 _label6
            ; line 4848
            strcat ::temp1 "Story: aborting " storyType 
            strcat ::temp1 ::temp1 " for " 
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 ::temp1 ::temp2 
            strcat ::temp2 ::temp2 " -- danger zone policy" 
            strcat ::temp2 ::temp2 logSuffix 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 4849
            callmethod GetDisplayName player ::temp2 ;0 variable args
            strcat ::temp2 "turned back after learning that " ::temp2 
            strcat ::temp2 ::temp2 " had ventured into a dangerous place" 
            callmethod SendTaskNarration ::Core_var ::nonevar npc ::temp2 player ;3 variable args
            ; line 4850
            strcat ::temp2 "danger zone policy" logSuffix 
            callmethod AbortStoryTravel self ::nonevar ::temp2 ;1 variable args
            ; line 4851
            return True 
            jmp _label6
            ; line 4853
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
            ; line 4857
            callstatic intelEngine IsPlayerInOwnHome ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 4858
            return False 
            jmp _label0
            ; line 4860
          _label0:
            cmp_eq ::temp0 ::PlayerHomePolicy_var 3 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label1
            ; line 4861
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
            ; line 4862
            cmp_eq ::temp0 ::PlayerHomePolicy_var 1 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label4
            callstatic intelEngine IsCivilianClass ::temp0 npc ;1 variable args
            assign ::temp0 ::temp0 
          _label4:
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label5
            ; line 4863
            strcat ::temp1 "Story: aborting " storyType 
            strcat ::temp1 ::temp1 " for " 
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 ::temp1 ::temp2 
            strcat ::temp2 ::temp2 " -- player home policy" 
            strcat ::temp2 ::temp2 logSuffix 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 4864
            callmethod GetDisplayName player ::temp2 ;0 variable args
            strcat ::temp2 "decided not to bother " ::temp2 
            strcat ::temp2 ::temp2 " at home and turned back" 
            callmethod SendTaskNarration ::Core_var ::nonevar npc ::temp2 player ;3 variable args
            ; line 4865
            strcat ::temp2 "player home policy" logSuffix 
            callmethod AbortStoryTravel self ::nonevar ::temp2 ;1 variable args
            ; line 4866
            return True 
            jmp _label5
            ; line 4868
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
            ; line 4872
            callstatic intelEngine CheckHoldRestriction ::temp0 npc storyType ;2 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 4873
            strcat ::temp1 "Story: aborting " storyType 
            strcat ::temp1 ::temp1 " for " 
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 ::temp1 ::temp2 
            strcat ::temp2 ::temp2 " -- hold restriction" 
            strcat ::temp2 ::temp2 logSuffix 
            callmethod DebugMsg ::Core_var ::nonevar ::temp2 ;1 variable args
            ; line 4874
            callmethod GetDisplayName player ::temp2 ;0 variable args
            strcat ::temp2 "decided the journey to find " ::temp2 
            strcat ::temp2 ::temp2 " was too far and turned back" 
            callmethod SendTaskNarration ::Core_var ::nonevar npc ::temp2 player ;3 variable args
            ; line 4875
            strcat ::temp2 "hold restriction" logSuffix 
            callmethod AbortStoryTravel self ::nonevar ::temp2 ;1 variable args
            ; line 4876
            return True 
            jmp _label0
            ; line 4878
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
            ; line 4883
            callmethod GetDisplayName ::ActiveStoryNPC_var ::temp0 ;0 variable args
            strcat ::temp0 "Story: " ::temp0 
            strcat ::temp0 ::temp0 " " 
            strcat ::temp0 ::temp0 reason 
            strcat ::temp0 ::temp0 " — aborting" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp0 ;1 variable args
            ; line 4884
            callmethod FindSlotByAgent ::Core_var ::temp1 ::ActiveStoryNPC_var ;1 variable args
            assign abortSlot ::temp1 
            ; line 4885
            comp_gte ::temp2 abortSlot 0 
            jmpf ::temp2 _label0
            ; line 4886
            callmethod ClearSlot ::Core_var ::nonevar abortSlot True False ;3 variable args
            jmp _label0
            ; line 4888
          _label0:
            callmethod RemoveAllPackages ::Core_var ::nonevar ::ActiveStoryNPC_var False ;2 variable args
            ; line 4889
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
            ; line 4894
            cmp_eq ::temp0 ::ActiveStoryType_var "quest" 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            cmp_eq ::temp0 ::ActiveStoryType_var "quest_guide" 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 4895
            jmpf ::QuestActive_var _label2
            ; line 4897
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
            ; line 4898
            strcat ::temp2 "never heard back about the " ::QuestEnemyType_var 
            strcat ::temp2 ::temp2 " threat at " 
            strcat ::temp2 ::temp2 ::QuestLocationName_var 
            strcat ::temp2 ::temp2 " — the request seems to have fallen through" 
            callmethod InjectFact ::Core_var ::nonevar ::QuestGiver_var ::temp2 ;2 variable args
            jmp _label5
            ; line 4900
          _label5:
            callmethod CleanupQuest self ::nonevar ;0 variable args
            jmp _label2
          _label2:
            jmp _label1
            ; line 4904
          _label1:
            cast ::temp1 None 
            cmp_eq ::temp0 ::ActiveStoryNPC_var ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label6
            ; line 4906
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil GetFloatValue ::temp4 ::temp3 "Intel_OrigAggression" -1.0 ;3 variable args
            assign origAggr ::temp4 
            ; line 4907
            comp_gte ::temp0 origAggr 0.0 
            jmpf ::temp0 _label7
            ; line 4908
            callmethod SetActorValue ::ActiveStoryNPC_var ::nonevar "Aggression" origAggr ;2 variable args
            ; line 4909
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp3 "Intel_OrigAggression" ;2 variable args
            jmp _label7
            ; line 4911
          _label7:
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp3 "Intel_IsStoryDispatch" ;2 variable args
            ; line 4912
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp3 "Intel_StoryNarration" ;2 variable args
            ; line 4913
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp3 "Intel_SneakPhase" ;2 variable args
            ; line 4914
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp3 "Intel_SneakStartTime" ;2 variable args
            ; line 4915
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp3 "Intel_CombatStartTime" ;2 variable args
            ; line 4916
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp3 "Intel_OffscreenArrival" ;2 variable args
            ; line 4918
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp3 "Intel_MessageSender" ;2 variable args
            ; line 4919
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp3 "Intel_MessageContent" ;2 variable args
            ; line 4920
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp3 "Intel_MessageDest" ;2 variable args
            ; line 4921
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp3 "Intel_MessageTime" ;2 variable args
            ; line 4922
            cast ::temp3 ::ActiveStoryNPC_var 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp3 "Intel_QuestLocation" ;2 variable args
            jmp _label6
            ; line 4924
          _label6:
            cast ::temp1 None 
            assign ::ActiveStoryNPC_var ::temp1 
            ; line 4925
            cast ::temp1 None 
            assign ::ActiveSecondNPC_var ::temp1 
            ; line 4926
            assign ::ActiveNarration_var "" 
            ; line 4927
            assign ::ActiveStoryType_var "" 
            ; line 4928
            assign ::IsActive_var False 
            ; line 4929
            callstatic intelEngine ClearSystemPending ::nonevar "storyDM" ;1 variable args
            ; line 4930
            callmethod ClearPending self ::nonevar ;0 variable args
            ; line 4939
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
            ; line 4943
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
            ; line 4952
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign target ::temp0 
            ; line 4953
            callmethod IsNPCToNPCType self ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            cast ::temp0 None 
            cmp_eq ::temp1 ::ActiveSecondNPC_var ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 4954
            assign target ::ActiveSecondNPC_var 
            jmp _label1
            ; line 4958
          _label1:
            propget TravelPackage_Jog ::Core_var ::temp2 
            assign travelPkg ::temp2 
            ; line 4959
            cmp_eq ::temp1 ::ActiveStoryType_var "stalker" 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label2
            cmp_eq ::temp1 ::ActiveStoryType_var "ambush" 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 4960
            propget TravelPackage_Stalk ::Core_var ::temp2 
            cast ::temp1 ::temp2 
            jmpf ::temp1 _label4
            ; line 4961
            propget TravelPackage_Stalk ::Core_var ::temp2 
            assign travelPkg ::temp2 
            ; line 4962
            strcat ::temp3 "Story [" ::ActiveStoryType_var 
            strcat ::temp3 ::temp3 "]: using TravelPackage_Stalk" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
            jmp _label5
            ; line 4964
          _label4:
            strcat ::temp3 "Story [" ::ActiveStoryType_var 
            strcat ::temp3 ::temp3 "]: WARNING - TravelPackage_Stalk is None! Fill property on IntelEngine quest in CK" 
            callmethod DebugMsg ::Core_var ::nonevar ::temp3 ;1 variable args
          _label5:
            jmp _label3
            ; line 4968
          _label3:
            callmethod RemoveAllPackages ::Core_var ::nonevar npc False ;2 variable args
            ; line 4969
            cast ::temp4 npc 
            cast ::temp5 target 
            propget IntelEngine_TravelTarget ::Core_var ::temp6 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp4 ::temp5 ::temp6 ;3 variable args
            ; line 4970
            propget PRIORITY_TRAVEL ::Core_var ::temp7 
            callstatic actorUtil AddPackageOverride ::nonevar npc travelPkg ::temp7 1 ;4 variable args
            ; line 4971
            callstatic utility Wait ::nonevar 0.100000001 ;1 variable args
            ; line 4972
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
            ; line 4980
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 4981
            cast ::temp1 player 
            callstatic storageUtil StringListAdd ::temp2 ::temp1 "Intel_RecentStoryEvents" summary True ;4 variable args
            ; line 4982
          _label1:
            cast ::temp1 player 
            callstatic storageUtil StringListCount ::temp2 ::temp1 "Intel_RecentStoryEvents" ;2 variable args
            cmp_gt ::temp3 ::temp2 8 
            jmpf ::temp3 _label0
            ; line 4983
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
            ; line 4989
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 4991
            assign locName "" 
            ; line 4992
            cast ::temp0 None 
            cmp_eq ::temp1 sourceNPC ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label0
            ; line 4993
            callstatic intelEngine GetActorHoldName ::temp2 sourceNPC ;1 variable args
            assign locName ::temp2 
            jmp _label0
            ; line 4995
          _label0:
            cmp_eq ::temp1 locName "" 
            jmpf ::temp1 _label1
            ; line 4996
            callstatic intelEngine GetActorHoldName ::temp2 player ;1 variable args
            assign locName ::temp2 
            jmp _label1
            ; line 5000
          _label1:
            cast ::temp3 player 
            callstatic storageUtil StringListCount ::temp4 ::temp3 "Intel_SocialLog_Type" ;2 variable args
            assign typeCount ::temp4 
            ; line 5001
            cast ::temp3 player 
            callstatic storageUtil StringListCount ::temp4 ::temp3 "Intel_SocialLog_Detail" ;2 variable args
            assign detailCount ::temp4 
            ; line 5002
          _label3:
            cmp_lt ::temp1 detailCount typeCount 
            jmpf ::temp1 _label2
            ; line 5003
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_Detail" "" True ;4 variable args
            ; line 5004
            iadd ::temp4 detailCount 1 
            assign detailCount ::temp4 
            jmp _label3
            ; line 5006
          _label2:
            cmp_gt ::temp1 detailCount typeCount 
            jmpf ::temp1 _label4
            ; line 5007
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_Detail" 0 ;3 variable args
            ; line 5008
            isub ::temp4 detailCount 1 
            assign detailCount ::temp4 
            jmp _label2
            ; line 5010
          _label4:
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_Type" eventType True ;4 variable args
            ; line 5011
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_NPC1" npc1Name True ;4 variable args
            ; line 5012
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_NPC2" npc2Name True ;4 variable args
            ; line 5013
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_Text" narration True ;4 variable args
            ; line 5014
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_Location" locName True ;4 variable args
            ; line 5015
            cast ::temp3 player 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_SocialLog_Detail" detail True ;4 variable args
            ; line 5016
          _label6:
            cast ::temp3 player 
            callstatic storageUtil StringListCount ::temp4 ::temp3 "Intel_SocialLog_Type" ;2 variable args
            cmp_gt ::temp1 ::temp4 5 
            jmpf ::temp1 _label5
            ; line 5017
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_Type" 0 ;3 variable args
            ; line 5018
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_NPC1" 0 ;3 variable args
            ; line 5019
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_NPC2" 0 ;3 variable args
            ; line 5020
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_Text" 0 ;3 variable args
            ; line 5021
            cast ::temp3 player 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_SocialLog_Location" 0 ;3 variable args
            ; line 5022
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
            ; line 5032
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
            ; line 5040
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
            ; line 5044
            callstatic utility RandomInt ::temp0 0 3 ;2 variable args
            assign variant ::temp0 
            ; line 5045
            cmp_eq ::temp1 variant 0 
            jmpf ::temp1 _label0
            ; line 5046
            strcat ::temp2 "brought urgent word from the " factionName 
            strcat ::temp2 ::temp2 " about trouble near " 
            cast ::temp3 ::QuestLocation_var 
            strcat ::temp3 ::temp2 ::temp3 
            return ::temp3 
            jmp _label1
            ; line 5047
          _label0:
            cmp_eq ::temp1 variant 1 
            jmpf ::temp1 _label2
            ; line 5048
            strcat ::temp3 "arrived bearing a warning from the " factionName 
            strcat ::temp3 ::temp3 " concerning " 
            cast ::temp2 ::QuestLocation_var 
            strcat ::temp2 ::temp3 ::temp2 
            return ::temp2 
            jmp _label1
            ; line 5049
          _label2:
            cmp_eq ::temp1 variant 2 
            jmpf ::temp1 _label3
            ; line 5050
            cast ::temp2 ::QuestLocation_var 
            strcat ::temp2 "brought word of trouble brewing at " ::temp2 
            strcat ::temp2 ::temp2 " — the " 
            strcat ::temp2 ::temp2 factionName 
            strcat ::temp2 ::temp2 " need help" 
            return ::temp2 
            jmp _label1
            ; line 5052
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
            ; line 5059
            assign t 0 
            ; line 5060
            jmpf ::TypeSeekPlayerEnabled_var _label0
            ; line 5061
            iadd ::temp0 t 1 
            assign t ::temp0 
            jmp _label0
            ; line 5063
          _label0:
            jmpf ::TypeInformantEnabled_var _label1
            ; line 5064
            iadd ::temp0 t 2 
            assign t ::temp0 
            jmp _label1
            ; line 5066
          _label1:
            jmpf ::TypeRoadEncounterEnabled_var _label2
            ; line 5067
            iadd ::temp0 t 4 
            assign t ::temp0 
            jmp _label2
            ; line 5069
          _label2:
            jmpf ::TypeAmbushEnabled_var _label3
            ; line 5070
            iadd ::temp0 t 8 
            assign t ::temp0 
            jmp _label3
            ; line 5072
          _label3:
            jmpf ::TypeStalkerEnabled_var _label4
            ; line 5073
            iadd ::temp0 t 16 
            assign t ::temp0 
            jmp _label4
            ; line 5075
          _label4:
            jmpf ::TypeMessageEnabled_var _label5
            ; line 5076
            iadd ::temp0 t 32 
            assign t ::temp0 
            jmp _label5
            ; line 5078
          _label5:
            jmpf ::TypeQuestEnabled_var _label6
            ; line 5079
            iadd ::temp0 t 64 
            assign t ::temp0 
            jmp _label6
            ; line 5081
          _label6:
            jmpf ::TypeFactionAmbushEnabled_var _label7
            ; line 5082
            iadd ::temp0 t 128 
            assign t ::temp0 
            jmp _label7
            ; line 5084
          _label7:
            jmpf ::QuestSubTypeCombatEnabled_var _label8
            ; line 5085
            iadd ::temp0 t 256 
            assign t ::temp0 
            jmp _label8
            ; line 5087
          _label8:
            jmpf ::QuestSubTypeRescueEnabled_var _label9
            ; line 5088
            iadd ::temp0 t 512 
            assign t ::temp0 
            jmp _label9
            ; line 5090
          _label9:
            jmpf ::QuestSubTypeFindItemEnabled_var _label10
            ; line 5091
            iadd ::temp0 t 1024 
            assign t ::temp0 
            jmp _label10
            ; line 5093
          _label10:
            jmpf ::QuestSubTypeFactionCombatEnabled_var _label11
            ; line 5094
            iadd ::temp0 t 2048 
            assign t ::temp0 
            jmp _label11
            ; line 5096
          _label11:
            jmpf ::QuestSubTypeFactionRescueEnabled_var _label12
            ; line 5097
            iadd ::temp0 t 4096 
            assign t ::temp0 
            jmp _label12
            ; line 5099
          _label12:
            jmpf ::QuestSubTypeFactionBattleEnabled_var _label13
            ; line 5100
            iadd ::temp0 t 8192 
            assign t ::temp0 
            jmp _label13
            ; line 5102
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
            ; line 5106
            assign f 0 
            ; line 5107
            callmethod GetParentCell player ::temp0 ;0 variable args
            assign pCell ::temp0 
            ; line 5108
            cast ::temp0 None 
            cmp_eq ::temp1 pCell ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            callmethod IsInterior pCell ::temp1 ;0 variable args
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 5109
            iadd ::temp2 f 1 
            assign f ::temp2 
            jmp _label1
            ; line 5111
          _label1:
            callstatic intelEngine IsPlayerInDangerousLocation ::temp1 ;0 variable args
            jmpf ::temp1 _label2
            ; line 5112
            iadd ::temp2 f 2 
            assign f ::temp2 
            jmp _label2
            ; line 5114
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
            ; line 5118
            callstatic intelEngine StoryResponseGetField ::temp0 json fieldName ;2 variable args
            return ::temp0 
          .endCode
        .endFunction ;ExtractJsonField
      .endState
    .endStateTable
  .endObject
.endObjectTable
