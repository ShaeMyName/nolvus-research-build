.info
  .source "C:\nolvus-research\build\src\intelengine\Source\Scripts\IntelEngine_Core.psc"
  .compileTime 1791570830 ;2026-10-09 14:33:50
  .user "sharp"
  .computer "EMISSARY"
.endInfo
.userFlagsRef
  .flag hidden 0 ;0x00000001
.endUserFlagsRef
.objectTable
  .object IntelEngine_Core Quest
    .userFlags 0 ;none
    .docString "IntelEngine Core System

    Intelligent NPC Task Execution for SkyrimNet

    This script handles:
    - Initialization and database loading
    - Decorator registration with SkyrimNet
    - Alias slot management for concurrent tasks
    - Common utility functions

    Required CK Setup:
    - Create 5 AgentAliases (AgentAlias00-04) for task executors
    - Create 5 TargetAliases (TargetAlias00-04) for fetch targets
    - Attach travel/escort packages to aliases
    - Fill all properties in C"
    .autoState 
    .variableTable
      .variable ::AgentAlias00_var referenceAlias
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::AgentAlias01_var referenceAlias
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::AgentAlias02_var referenceAlias
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::AgentAlias03_var referenceAlias
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::AgentAlias04_var referenceAlias
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::Battle_var intelEngine_Battle
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::IntelEngine_AgentLink_var keyword
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::IntelEngine_DebugMode_var globalVariable
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::IntelEngine_DefaultWaitHours_var globalVariable
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::IntelEngine_EscortTarget_var keyword
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::IntelEngine_MaxConcurrentTasks_var globalVariable
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::IntelEngine_TaskFaction_var faction
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::IntelEngine_TravelTarget_var keyword
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::IntelEngine_WaitLocation_var keyword
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::LINGER_RELEASE_DISTANCE_var Float
        .userFlags 1 ;hidden 
        .initialValue 800.0
      .endVariable
      .variable ::MeetingGracePeriod_var Float
        .userFlags 0 ;none
        .initialValue 0.5
      .endVariable
      .variable ::NPCTasks_var intelEngine_NPCTasks
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::Politics_var intelEngine_Politics
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::SandboxNearPlayerPackage_var package
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::SandboxPackage_var package
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::Schedule_var intelEngine_Schedule
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::SlotDeadlines_var Float[]
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::SlotSpeeds_var Int[]
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::SlotStates_var Int[]
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::SlotTargetNames_var String[]
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::SlotTaskTypes_var String[]
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::StoryEngine_var intelEngine_StoryEngine
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::TargetAlias00_var referenceAlias
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::TargetAlias01_var referenceAlias
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::TargetAlias02_var referenceAlias
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::TargetAlias03_var referenceAlias
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::TargetAlias04_var referenceAlias
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::TravelPackage_Jog_var package
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::TravelPackage_Run_var package
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::TravelPackage_Stalk_var package
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::TravelPackage_Walk_var package
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable ::Travel_var intelEngine_Travel
        .userFlags 0 ;none
        .initialValue None
      .endVariable
      .variable LastMaintenanceRealTime Float
        .userFlags 0 ;none
        .initialValue 0.0
      .endVariable
      .variable databaseLoaded Bool
        .userFlags 0 ;none
        .initialValue False
      .endVariable
    .endVariableTable
    .propertyTable
      .property ARRIVAL_DISTANCE Float
        .userFlags 0 ;none
        .docString "Distance to consider NPC "arrived" at destination"
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
            ; line 112
            return 300.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property AgentAlias00 referenceAlias auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::AgentAlias00_var
      .endProperty
      .property AgentAlias01 referenceAlias auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::AgentAlias01_var
      .endProperty
      .property AgentAlias02 referenceAlias auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::AgentAlias02_var
      .endProperty
      .property AgentAlias03 referenceAlias auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::AgentAlias03_var
      .endProperty
      .property AgentAlias04 referenceAlias auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::AgentAlias04_var
      .endProperty
      .property Battle intelEngine_Battle auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::Battle_var
      .endProperty
      .property DEPARTURE_CHECK_CYCLES Int
        .userFlags 0 ;none
        .docString "Update cycles before checking if NPC actually departed (~15s at 3s interval)"
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
            ; line 130
            return 5 
          .endCode
        .endFunction ;get
      .endProperty
      .property IntelEngine_AgentLink keyword auto
        .userFlags 0 ;none
        .docString "Keyword for linking target to agent (so target follows agent)"
        .autovar ::IntelEngine_AgentLink_var
      .endProperty
      .property IntelEngine_DebugMode globalVariable auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::IntelEngine_DebugMode_var
      .endProperty
      .property IntelEngine_DefaultWaitHours globalVariable auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::IntelEngine_DefaultWaitHours_var
      .endProperty
      .property IntelEngine_EscortTarget keyword auto
        .userFlags 0 ;none
        .docString "Keyword for linking agent to escort target (NPC being brought back)"
        .autovar ::IntelEngine_EscortTarget_var
      .endProperty
      .property IntelEngine_MaxConcurrentTasks globalVariable auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::IntelEngine_MaxConcurrentTasks_var
      .endProperty
      .property IntelEngine_TaskFaction faction auto
        .userFlags 0 ;none
        .docString "Faction for tracking NPCs on active tasks"
        .autovar ::IntelEngine_TaskFaction_var
      .endProperty
      .property IntelEngine_TravelTarget keyword auto
        .userFlags 0 ;none
        .docString "Keyword for linking agent to travel destination"
        .autovar ::IntelEngine_TravelTarget_var
      .endProperty
      .property IntelEngine_WaitLocation keyword auto
        .userFlags 0 ;none
        .docString "Keyword for linking to wait/meeting location"
        .autovar ::IntelEngine_WaitLocation_var
      .endProperty
      .property LINGER_APPROACH_DISTANCE Float
        .userFlags 0 ;none
        .docString "NPC switches from approach (TravelPackage_Walk) to sandbox when within this distance of player"
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
            ; line 124
            return 100.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property LINGER_FAR_TICKS_LIMIT Int
        .userFlags 0 ;none
        .docString "Consecutive far checks before a lingering NPC is released"
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
            ; line 127
            return 3 
          .endCode
        .endFunction ;get
      .endProperty
      .property LINGER_RELEASE_DISTANCE Float auto
        .userFlags 1 ;hidden 
        .docString "Distance (game units) the player must walk away before a lingering NPC loses interest.
Configurable via MCM. Shared between Travel, NPCTasks, and StoryEngine linger systems."
        .autovar ::LINGER_RELEASE_DISTANCE_var
      .endProperty
      .property MAX_SLOTS Int
        .userFlags 0 ;none
        .docString "Maximum concurrent tasks. Must match number of aliases."
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
            ; line 100
            return 5 
          .endCode
        .endFunction ;get
      .endProperty
      .property MeetingGracePeriod Float auto
        .userFlags 0 ;none
        .docString "Grace period for meeting arrival tolerance (in game hours).
Default 0.5 hours (30 minutes). Configurable via MCM.
Handles timescale variations from Dynamic Time Scaling mods."
        .autovar ::MeetingGracePeriod_var
      .endProperty
      .property NPCTasks intelEngine_NPCTasks auto
        .userFlags 0 ;none
        .docString "Reference to NPC tasks script for monitoring restart on game load"
        .autovar ::NPCTasks_var
      .endProperty
      .property PRIORITY_SANDBOX Int
        .userFlags 0 ;none
        .docString "Package priority for sandbox at destination"
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
            ; line 106
            return 90 
          .endCode
        .endFunction ;get
      .endProperty
      .property PRIORITY_TRAVEL Int
        .userFlags 0 ;none
        .docString "Package priority for active travel"
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
            ; line 103
            return 100 
          .endCode
        .endFunction ;get
      .endProperty
      .property Politics intelEngine_Politics auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::Politics_var
      .endProperty
      .property STATE_AT_TARGET Int
        .userFlags 0 ;none
        .docString "NPC has arrived at target and is interacting"
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
            ; line 109
            return 8 
          .endCode
        .endFunction ;get
      .endProperty
      .property STUCK_DISTANCE_THRESHOLD Float
        .userFlags 0 ;none
        .docString "If NPC moved less than this between stuck checks, might be stuck.
Passed to C++ StuckDetector.CheckStuckStatus as threshold parameter."
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
            ; line 120
            return 50.0 
          .endCode
        .endFunction ;get
      .endProperty
      .property SandboxNearPlayerPackage package auto
        .userFlags 0 ;none
        .docString "Tight 200-unit sandbox near linked ref — for meeting linger"
        .autovar ::SandboxNearPlayerPackage_var
      .endProperty
      .property SandboxPackage package auto
        .userFlags 0 ;none
        .docString "Sandbox package - idle at destination"
        .autovar ::SandboxPackage_var
      .endProperty
      .property Schedule intelEngine_Schedule auto
        .userFlags 0 ;none
        .docString "Reference to schedule script for monitoring restart on game load"
        .autovar ::Schedule_var
      .endProperty
      .property SlotDeadlines Float[] auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::SlotDeadlines_var
      .endProperty
      .property SlotSpeeds Int[] auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::SlotSpeeds_var
      .endProperty
      .property SlotStates Int[] auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::SlotStates_var
      .endProperty
      .property SlotTargetNames String[] auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::SlotTargetNames_var
      .endProperty
      .property SlotTaskTypes String[] auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::SlotTaskTypes_var
      .endProperty
      .property StoryEngine intelEngine_StoryEngine auto
        .userFlags 0 ;none
        .docString "Reference to story engine script for monitoring restart on game load"
        .autovar ::StoryEngine_var
      .endProperty
      .property TargetAlias00 referenceAlias auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::TargetAlias00_var
      .endProperty
      .property TargetAlias01 referenceAlias auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::TargetAlias01_var
      .endProperty
      .property TargetAlias02 referenceAlias auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::TargetAlias02_var
      .endProperty
      .property TargetAlias03 referenceAlias auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::TargetAlias03_var
      .endProperty
      .property TargetAlias04 referenceAlias auto
        .userFlags 0 ;none
        .docString ""
        .autovar ::TargetAlias04_var
      .endProperty
      .property Travel intelEngine_Travel auto
        .userFlags 0 ;none
        .docString "Reference to travel script for monitoring restart on game load"
        .autovar ::Travel_var
      .endProperty
      .property TravelPackage_Jog package auto
        .userFlags 0 ;none
        .docString "Travel package - jogging speed"
        .autovar ::TravelPackage_Jog_var
      .endProperty
      .property TravelPackage_Run package auto
        .userFlags 0 ;none
        .docString "Travel package - running speed"
        .autovar ::TravelPackage_Run_var
      .endProperty
      .property TravelPackage_Stalk package auto
        .userFlags 0 ;none
        .docString "Travel package - walk speed with Always Sneak flag, 800-unit arrive radius, for stalkers"
        .autovar ::TravelPackage_Stalk_var
      .endProperty
      .property TravelPackage_Walk package auto
        .userFlags 0 ;none
        .docString "Travel package - walking speed"
        .autovar ::TravelPackage_Walk_var
      .endProperty
      .property UPDATE_INTERVAL Float
        .userFlags 0 ;none
        .docString "Seconds between status checks"
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
            ; line 115
            return 3.0 
          .endCode
        .endFunction ;get
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
            ; line 179
            callmethod DebugMsg self ::nonevar "IntelEngine Quest OnInit" ;1 variable args
          .endCode
        .endFunction ;OnInit
        .function Maintenance
           ; function type 0
          .userFlags 0 ;none
          .docString "Called by PlayerAlias on every game load AND by C++ bootstrap.
        Guard: skip if already ran within 2 real seconds (both paths fire on load).
        isFirstLoad = true when mod is first installed (OnInit on alias)
        isFirstLoad = false on subsequent loads (OnPlayerLoadGame on alias"
          .return None
          .paramTable
            .param isFirstLoad Bool
          .endParamTable
          .localTable
            .local ::nonevar None
            .local now Float
            .local ::temp0 Float
            .local ::temp1 Bool
            .local ::temp2 String
            .local cleared Int
            .local ::temp3 Int
            .local player actor
            .local ::temp4 actor
            .local ::temp5 form
            .local ::temp6 Int[]
            .local ::temp7 Int
            .local q quest
            .local ::temp8 quest
            .local ::temp9 intelEngine_Travel
            .local ::temp10 intelEngine_NPCTasks
            .local ::temp11 intelEngine_Schedule
            .local ::temp12 intelEngine_StoryEngine
            .local ::temp13 intelEngine_Politics
            .local ::temp14 intelEngine_Battle
          .endLocalTable
          .code
            ; line 192
            callmethod RegisterDashboardEvents self ::nonevar ;0 variable args
            ; line 194
            callstatic utility GetCurrentRealTime ::temp0 ;0 variable args
            assign now ::temp0 
            ; line 199
            cmp_lt ::temp1 now LastMaintenanceRealTime 
            jmpf ::temp1 _label0
            ; line 200
            assign LastMaintenanceRealTime 0.0 
            jmp _label0
            ; line 202
          _label0:
            not ::temp1 isFirstLoad 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label1
            fsub ::temp0 now LastMaintenanceRealTime 
            cmp_lt ::temp1 ::temp0 2.0 
            assign ::temp1 ::temp1 
          _label1:
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            cmp_gt ::temp1 LastMaintenanceRealTime 0.0 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 203
            callmethod DebugMsg self ::nonevar "IntelEngine Maintenance skipped (duplicate call within 2s)" ;1 variable args
            ; line 204
            return None 
            jmp _label3
            ; line 206
          _label3:
            assign LastMaintenanceRealTime now 
            ; line 207
            cast ::temp2 isFirstLoad 
            strcat ::temp2 "IntelEngine Maintenance (firstLoad=" ::temp2 
            strcat ::temp2 ::temp2 ")" 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            ; line 209
            cast ::temp1 ::StoryEngine_var 
            jmpf ::temp1 _label4
            ; line 210
            callmethod IEB_QISelfCheck ::StoryEngine_var ::nonevar ;0 variable args
            jmp _label4
            ; line 216
          _label4:
            jmpf isFirstLoad _label5
            ; line 217
            callstatic storageUtil ClearAllPrefix ::temp3 "Intel_" ;1 variable args
            assign cleared ::temp3 
            ; line 218
            cast ::temp2 cleared 
            strcat ::temp2 "Cleared " ::temp2 
            strcat ::temp2 ::temp2 " stale StorageUtil keys" 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            ; line 221
            callstatic game GetPlayer ::temp4 ;0 variable args
            assign player ::temp4 
            ; line 222
            cast ::temp5 player 
            callstatic storageUtil SetIntValue ::temp3 ::temp5 "Intel_TaskConfirmPrompt" 1 ;3 variable args
            ; line 223
            cast ::temp5 player 
            callstatic storageUtil SetIntValue ::temp3 ::temp5 "Intel_DeliveryReportBack" 1 ;3 variable args
            ; line 224
            cast ::temp5 player 
            callstatic storageUtil SetFloatValue ::temp0 ::temp5 "Intel_MeetingTimeoutHours" 5.0 ;3 variable args
            jmp _label5
            ; line 228
          _label5:
            cast ::temp6 None 
            cmp_eq ::temp1 ::SlotStates_var ::temp6 
            jmpf ::temp1 _label6
            ; line 229
            callmethod InitializeSlotArrays self ::nonevar ;0 variable args
            jmp _label7
            ; line 230
          _label6:
            array_length ::temp3 ::SlotStates_var 
            propget MAX_SLOTS self ::temp7 
            cmp_eq ::temp1 ::temp3 ::temp7 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label7
            ; line 231
            callmethod InitializeSlotArrays self ::nonevar ;0 variable args
            jmp _label7
            ; line 234
          _label7:
            callmethod LoadDatabases self ::nonevar ;0 variable args
            ; line 237
            not ::temp1 isFirstLoad 
            jmpf ::temp1 _label8
            ; line 238
            callstatic intelEngine HasCoSaveTaskData ::temp1 ;0 variable args
            jmpf ::temp1 _label9
            ; line 244
            callstatic intelEngine SyncArraysFromSlotTracker ::nonevar ;0 variable args
            ; line 245
            callmethod DebugMsg self ::nonevar "Task recovery: co-save path (no StorageUtil)" ;1 variable args
            jmp _label10
            ; line 249
          _label9:
            callmethod RecoverActiveTasks self ::nonevar ;0 variable args
            ; line 250
            callmethod DebugMsg self ::nonevar "Task recovery: StorageUtil legacy path" ;1 variable args
          _label10:
            jmp _label8
            ; line 257
          _label8:
            cast ::temp8 self 
            assign q ::temp8 
            ; line 258
            not ::temp1 ::Travel_var 
            jmpf ::temp1 _label11
            ; line 259
            cast ::temp9 q 
            assign ::Travel_var ::temp9 
            ; line 260
            cast ::temp1 ::Travel_var 
            jmpf ::temp1 _label12
            ; line 261
            callmethod DebugMsg self ::nonevar "WARNING: Travel property was None, recovered via cast" ;1 variable args
            jmp _label12
          _label12:
            jmp _label11
            ; line 264
          _label11:
            not ::temp1 ::NPCTasks_var 
            jmpf ::temp1 _label13
            ; line 265
            cast ::temp10 q 
            assign ::NPCTasks_var ::temp10 
            ; line 266
            cast ::temp1 ::NPCTasks_var 
            jmpf ::temp1 _label14
            ; line 267
            callmethod DebugMsg self ::nonevar "WARNING: NPCTasks property was None, recovered via cast" ;1 variable args
            jmp _label14
          _label14:
            jmp _label13
            ; line 270
          _label13:
            not ::temp1 ::Schedule_var 
            jmpf ::temp1 _label15
            ; line 271
            cast ::temp11 q 
            assign ::Schedule_var ::temp11 
            ; line 272
            cast ::temp1 ::Schedule_var 
            jmpf ::temp1 _label16
            ; line 273
            callmethod DebugMsg self ::nonevar "WARNING: Schedule property was None, recovered via cast" ;1 variable args
            jmp _label16
          _label16:
            jmp _label15
            ; line 276
          _label15:
            not ::temp1 ::StoryEngine_var 
            jmpf ::temp1 _label17
            ; line 277
            cast ::temp12 q 
            assign ::StoryEngine_var ::temp12 
            ; line 278
            cast ::temp1 ::StoryEngine_var 
            jmpf ::temp1 _label18
            ; line 279
            callmethod DebugMsg self ::nonevar "WARNING: StoryEngine property was None, recovered via cast" ;1 variable args
            jmp _label18
          _label18:
            jmp _label17
            ; line 282
          _label17:
            not ::temp1 ::Politics_var 
            jmpf ::temp1 _label19
            ; line 283
            cast ::temp13 q 
            assign ::Politics_var ::temp13 
            ; line 284
            cast ::temp1 ::Politics_var 
            jmpf ::temp1 _label20
            ; line 285
            callmethod DebugMsg self ::nonevar "WARNING: Politics property was None, recovered via cast" ;1 variable args
            jmp _label20
          _label20:
            jmp _label19
            ; line 288
          _label19:
            not ::temp1 ::Battle_var 
            jmpf ::temp1 _label21
            ; line 289
            cast ::temp14 q 
            assign ::Battle_var ::temp14 
            ; line 290
            cast ::temp1 ::Battle_var 
            jmpf ::temp1 _label22
            ; line 291
            callmethod DebugMsg self ::nonevar "WARNING: Battle property was None, recovered via cast" ;1 variable args
            jmp _label23
            ; line 293
          _label22:
            callmethod DebugMsg self ::nonevar "ERROR: Battle cast FAILED - IntelEngine_Battle script not found on quest" ;1 variable args
          _label23:
            jmp _label21
            ; line 300
          _label21:
            cast ::temp1 ::Travel_var 
            jmpf ::temp1 _label24
            ; line 301
            callmethod RestartMonitoring ::Travel_var ::nonevar ;0 variable args
            jmp _label24
            ; line 303
          _label24:
            cast ::temp1 ::NPCTasks_var 
            jmpf ::temp1 _label25
            ; line 304
            callmethod RestartMonitoring ::NPCTasks_var ::nonevar ;0 variable args
            jmp _label25
            ; line 306
          _label25:
            cast ::temp1 ::Schedule_var 
            jmpf ::temp1 _label26
            ; line 307
            callmethod RestartMonitoring ::Schedule_var ::nonevar ;0 variable args
            jmp _label26
            ; line 309
          _label26:
            cast ::temp1 ::StoryEngine_var 
            jmpf ::temp1 _label27
            ; line 310
            callmethod RestartMonitoring ::StoryEngine_var ::nonevar ;0 variable args
            ; line 311
            callmethod StartScheduler ::StoryEngine_var ::nonevar ;0 variable args
            jmp _label27
            ; line 313
          _label27:
            cast ::temp1 ::Politics_var 
            jmpf ::temp1 _label28
            ; line 314
            callmethod Maintenance ::Politics_var ::nonevar ;0 variable args
            jmp _label28
            ; line 316
          _label28:
            cast ::temp1 ::Battle_var 
            jmpf ::temp1 _label29
            ; line 317
            callmethod OnGameReload ::Battle_var ::nonevar ;0 variable args
            jmp _label29
            ; line 321
          _label29:
            not ::temp1 isFirstLoad 
            jmpf ::temp1 _label30
            ; line 322
            callmethod CleanExpiredFactsGlobal self ::nonevar ;0 variable args
            jmp _label30
            ; line 326
          _label30:
            callmethod RegisterDashboardEvents self ::nonevar ;0 variable args
          .endCode
        .endFunction ;Maintenance
        .function InitializeSlotArrays
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Int[]
            .local ::temp1 String[]
            .local ::temp2 Float[]
            .local i Int
            .local ::temp3 Int
            .local ::temp4 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 330
            array_create ::temp0 5 
            assign ::SlotStates_var ::temp0 
            ; line 331
            array_create ::temp1 5 
            assign ::SlotTaskTypes_var ::temp1 
            ; line 332
            array_create ::temp1 5 
            assign ::SlotTargetNames_var ::temp1 
            ; line 333
            array_create ::temp2 5 
            assign ::SlotDeadlines_var ::temp2 
            ; line 334
            array_create ::temp0 5 
            assign ::SlotSpeeds_var ::temp0 
            ; line 336
            assign i 0 
            ; line 337
          _label1:
            propget MAX_SLOTS self ::temp3 
            cmp_lt ::temp4 i ::temp3 
            jmpf ::temp4 _label0
            ; line 338
            array_setelement ::SlotStates_var i 0 
            ; line 339
            array_setelement ::SlotTaskTypes_var i "" 
            ; line 340
            array_setelement ::SlotTargetNames_var i "" 
            ; line 341
            array_setelement ::SlotDeadlines_var i 0.0 
            ; line 342
            array_setelement ::SlotSpeeds_var i 0 
            ; line 343
            iadd ::temp3 i 1 
            assign i ::temp3 
            jmp _label1
            ; line 346
          _label0:
            callmethod DebugMsg self ::nonevar "Slot arrays initialized" ;1 variable args
          .endCode
        .endFunction ;InitializeSlotArrays
        .function LoadDatabases
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local stats String
            .local ::temp1 String
          .endLocalTable
          .code
            ; line 357
            assign ::temp0 databaseLoaded 
            jmpf ::temp0 _label0
            callstatic intelEngine IsIndexLoaded ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 358
            return None 
            jmp _label1
            ; line 361
          _label1:
            callmethod DebugMsg self ::nonevar "Verifying indexes..." ;1 variable args
            ; line 363
            callstatic intelEngine IsIndexLoaded ::temp0 ;0 variable args
            jmpf ::temp0 _label2
            ; line 364
            assign databaseLoaded True 
            ; line 365
            callstatic intelEngine GetIndexStats ::temp1 ;0 variable args
            assign stats ::temp1 
            ; line 366
            strcat ::temp1 "Indexes loaded: " stats 
            callmethod DebugMsg self ::nonevar ::temp1 ;1 variable args
            jmp _label3
            ; line 368
          _label2:
            callmethod DebugMsg self ::nonevar "WARNING: Indexes not yet loaded - DLL may not be installed" ;1 variable args
          _label3
          .endCode
        .endFunction ;LoadDatabases
        .function SaveTaskToHistory
           ; function type 0
          .userFlags 0 ;none
          .docString "Saves a completed task to the NPC's rolling history (max 10 entries).
        Called from ClearSlot before task data is wiped"
          .return None
          .paramTable
            .param akAgent actor
            .param taskType String
            .param target String
            .param result String
            .param msgContent String
            .param meetLocation String
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 String
            .local desc String
            .local ::temp3 form
            .local ::temp4 Int
            .local ::temp5 Float
            .local currentTime Float
            .local histArr String[]
            .local ::temp6 String[]
            .local histTimes Float[]
            .local ::temp7 Float[]
            .local rendered String
            .local player actor
            .local npcFormId Int
          .endLocalTable
          .code
            ; line 380
            cast ::temp0 None 
            cmp_eq ::temp1 akAgent ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 taskType "" 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 381
            return None 
            jmp _label1
            ; line 385
          _label1:
            cmp_eq ::temp1 result "cancelled" 
            jmpf ::temp1 _label2
            ; line 386
            callmethod GetDisplayName akAgent ::temp2 ;0 variable args
            strcat ::temp2 ::temp2 " task cancelled — skipping history" 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            ; line 387
            return None 
            jmp _label2
            ; line 391
          _label2:
            callstatic intelEngine BuildTaskHistoryDesc ::temp2 taskType target result msgContent meetLocation ;5 variable args
            assign desc ::temp2 
            ; line 394
            cast ::temp3 akAgent 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_TaskHistory" desc True ;4 variable args
            ; line 395
            cast ::temp3 akAgent 
            callstatic utility GetCurrentGameTime ::temp5 ;0 variable args
            callstatic storageUtil FloatListAdd ::temp4 ::temp3 "Intel_TaskHistoryTime" ::temp5 True ;4 variable args
            ; line 398
          _label4:
            cast ::temp3 akAgent 
            callstatic storageUtil StringListCount ::temp4 ::temp3 "Intel_TaskHistory" ;2 variable args
            cmp_gt ::temp1 ::temp4 10 
            jmpf ::temp1 _label3
            ; line 399
            cast ::temp3 akAgent 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_TaskHistory" 0 ;3 variable args
            ; line 400
            cast ::temp3 akAgent 
            callstatic storageUtil FloatListRemoveAt ::temp1 ::temp3 "Intel_TaskHistoryTime" 0 ;3 variable args
            jmp _label4
            ; line 404
          _label3:
            callstatic utility GetCurrentGameTime ::temp5 ;0 variable args
            assign currentTime ::temp5 
            ; line 405
            cast ::temp3 akAgent 
            callstatic storageUtil StringListToArray ::temp6 ::temp3 "Intel_TaskHistory" ;2 variable args
            assign histArr ::temp6 
            ; line 406
            cast ::temp3 akAgent 
            callstatic storageUtil FloatListToArray ::temp7 ::temp3 "Intel_TaskHistoryTime" ;2 variable args
            assign histTimes ::temp7 
            ; line 407
            callstatic intelEngine RenderTaskHistorySection ::temp2 histArr histTimes currentTime ;3 variable args
            assign rendered ::temp2 
            ; line 408
            cast ::temp3 akAgent 
            callstatic storageUtil SetStringValue ::temp2 ::temp3 "Intel_TaskHistoryRendered" rendered ;3 variable args
            ; line 411
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 412
            callmethod GetFormID akAgent ::temp4 ;0 variable args
            assign npcFormId ::temp4 
            ; line 413
            cast ::temp3 player 
            callstatic storageUtil IntListFind ::temp4 ::temp3 "Intel_InteractedNPCs" npcFormId ;3 variable args
            cmp_lt ::temp1 ::temp4 0 
            jmpf ::temp1 _label5
            ; line 414
            cast ::temp3 player 
            callstatic storageUtil IntListAdd ::temp4 ::temp3 "Intel_InteractedNPCs" npcFormId True ;4 variable args
            jmp _label5
            ; line 417
          _label5:
            callmethod GetDisplayName akAgent ::temp2 ;0 variable args
            strcat ::temp2 ::temp2 " task history saved: " 
            strcat ::temp2 ::temp2 desc 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
          .endCode
        .endFunction ;SaveTaskToHistory
        .function StoreReceivedMessage
           ; function type 0
          .userFlags 0 ;none
          .docString "Stores a message on the recipient NPC so they remember receiving it.
        Called by IntelEngine_NPCTasks when a message is delivered"
          .return None
          .paramTable
            .param akRecipient actor
            .param akSender actor
            .param msgContent String
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local senderName String
            .local ::temp2 String
            .local ::temp3 form
            .local ::temp4 Float
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 428
            cast ::temp0 None 
            cmp_eq ::temp1 akRecipient ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 msgContent "" 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 429
            return None 
            jmp _label1
            ; line 432
          _label1:
            assign senderName "someone" 
            ; line 433
            cast ::temp1 akSender 
            jmpf ::temp1 _label2
            ; line 434
            callmethod GetDisplayName akSender ::temp2 ;0 variable args
            assign senderName ::temp2 
            jmp _label2
            ; line 437
          _label2:
            cast ::temp3 akRecipient 
            callstatic storageUtil SetStringValue ::temp2 ::temp3 "Intel_ReceivedMessage" msgContent ;3 variable args
            ; line 438
            cast ::temp3 akRecipient 
            callstatic storageUtil SetStringValue ::temp2 ::temp3 "Intel_MessageSender" senderName ;3 variable args
            ; line 439
            cast ::temp3 akRecipient 
            callstatic utility GetCurrentGameTime ::temp4 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp4 ::temp3 "Intel_MessageTime" ::temp4 ;3 variable args
            ; line 441
            callmethod GetDisplayName akRecipient ::temp2 ;0 variable args
            strcat ::temp2 ::temp2 " received message from " 
            strcat ::temp2 ::temp2 senderName 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
          .endCode
        .endFunction ;StoreReceivedMessage
        .function StoreMeetingOutcome
           ; function type 0
          .userFlags 0 ;none
          .docString "Stores meeting outcome on the NPC for prompt display.
        Called by Travel after meeting completes or times out.
        Outcomes: "success", "player_late", "player_slightly_late", "player_no_show"
          .return None
          .paramTable
            .param akNPC actor
            .param outcome String
            .param dest String
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 String
            .local ::temp4 Float
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 453
            cast ::temp0 None 
            cmp_eq ::temp1 akNPC ::temp0 
            jmpf ::temp1 _label0
            ; line 454
            return None 
            jmp _label0
            ; line 457
          _label0:
            cast ::temp2 akNPC 
            callstatic storageUtil SetStringValue ::temp3 ::temp2 "Intel_MeetingOutcome" outcome ;3 variable args
            ; line 458
            cast ::temp2 akNPC 
            callstatic storageUtil SetStringValue ::temp3 ::temp2 "Intel_MeetingOutcomeDest" dest ;3 variable args
            ; line 459
            cast ::temp2 akNPC 
            callstatic utility GetCurrentGameTime ::temp4 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp4 ::temp2 "Intel_MeetingOutcomeTime" ::temp4 ;3 variable args
            ; line 461
            callmethod GetDisplayName akNPC ::temp3 ;0 variable args
            strcat ::temp3 ::temp3 " meeting outcome: " 
            strcat ::temp3 ::temp3 outcome 
            strcat ::temp3 ::temp3 " at " 
            strcat ::temp3 ::temp3 dest 
            callmethod DebugMsg self ::nonevar ::temp3 ;1 variable args
          .endCode
        .endFunction ;StoreMeetingOutcome
        .function ClearMeetingOutcome
           ; function type 0
          .userFlags 0 ;none
          .docString "Clears meeting outcome from an NPC.
        Call when the outcome has been acknowledged or is no longer relevant"
          .return None
          .paramTable
            .param akNPC actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
          .endLocalTable
          .code
            ; line 468
            cast ::temp0 None 
            cmp_eq ::temp1 akNPC ::temp0 
            jmpf ::temp1 _label0
            ; line 469
            return None 
            jmp _label0
            ; line 472
          _label0:
            cast ::temp2 akNPC 
            callstatic storageUtil UnsetStringValue ::temp1 ::temp2 "Intel_MeetingOutcome" ;2 variable args
            ; line 473
            cast ::temp2 akNPC 
            callstatic storageUtil UnsetStringValue ::temp1 ::temp2 "Intel_MeetingOutcomeDest" ;2 variable args
            ; line 474
            cast ::temp2 akNPC 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp2 "Intel_MeetingOutcomeTime" ;2 variable args
            ; line 475
            cast ::temp2 akNPC 
            callstatic storageUtil UnsetFloatValue ::temp1 ::temp2 "Intel_MeetingLateHours" ;2 variable args
          .endCode
        .endFunction ;ClearMeetingOutcome
        .function GetAgentAlias
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return referenceAlias
          .paramTable
            .param slot Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 referenceAlias
          .endLocalTable
          .code
            ; line 483
            cmp_eq ::temp0 slot 0 
            jmpf ::temp0 _label0
            ; line 484
            return ::AgentAlias00_var 
            jmp _label1
            ; line 485
          _label0:
            cmp_eq ::temp0 slot 1 
            jmpf ::temp0 _label2
            ; line 486
            return ::AgentAlias01_var 
            jmp _label1
            ; line 487
          _label2:
            cmp_eq ::temp0 slot 2 
            jmpf ::temp0 _label3
            ; line 488
            return ::AgentAlias02_var 
            jmp _label1
            ; line 489
          _label3:
            cmp_eq ::temp0 slot 3 
            jmpf ::temp0 _label4
            ; line 490
            return ::AgentAlias03_var 
            jmp _label1
            ; line 491
          _label4:
            cmp_eq ::temp0 slot 4 
            jmpf ::temp0 _label1
            ; line 492
            return ::AgentAlias04_var 
            jmp _label1
            ; line 494
          _label1:
            cast ::temp1 None 
            return ::temp1 
          .endCode
        .endFunction ;GetAgentAlias
        .function GetTargetAlias
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return referenceAlias
          .paramTable
            .param slot Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 referenceAlias
          .endLocalTable
          .code
            ; line 498
            cmp_eq ::temp0 slot 0 
            jmpf ::temp0 _label0
            ; line 499
            return ::TargetAlias00_var 
            jmp _label1
            ; line 500
          _label0:
            cmp_eq ::temp0 slot 1 
            jmpf ::temp0 _label2
            ; line 501
            return ::TargetAlias01_var 
            jmp _label1
            ; line 502
          _label2:
            cmp_eq ::temp0 slot 2 
            jmpf ::temp0 _label3
            ; line 503
            return ::TargetAlias02_var 
            jmp _label1
            ; line 504
          _label3:
            cmp_eq ::temp0 slot 3 
            jmpf ::temp0 _label4
            ; line 505
            return ::TargetAlias03_var 
            jmp _label1
            ; line 506
          _label4:
            cmp_eq ::temp0 slot 4 
            jmpf ::temp0 _label1
            ; line 507
            return ::TargetAlias04_var 
            jmp _label1
            ; line 509
          _label1:
            cast ::temp1 None 
            return ::temp1 
          .endCode
        .endFunction ;GetTargetAlias
        .function FindFreeAgentSlot
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
            .local maxAllowed Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local activeCount Int
            .local firstFree Int
            .local i Int
          .endLocalTable
          .code
            ; line 514
            callmethod GetMaxConcurrentTasks self ::temp0 ;0 variable args
            assign maxAllowed ::temp0 
            ; line 515
            propget MAX_SLOTS self ::temp0 
            cmp_gt ::temp1 maxAllowed ::temp0 
            jmpf ::temp1 _label0
            ; line 516
            propget MAX_SLOTS self ::temp0 
            assign maxAllowed ::temp0 
            jmp _label1
            ; line 517
          _label0:
            cmp_lt ::temp1 maxAllowed 1 
            jmpf ::temp1 _label1
            ; line 518
            assign maxAllowed 1 
            jmp _label1
            ; line 521
          _label1:
            assign activeCount 0 
            ; line 522
            assign firstFree -1 
            ; line 523
            assign i 0 
            ; line 524
          _label5:
            propget MAX_SLOTS self ::temp0 
            cmp_lt ::temp1 i ::temp0 
            jmpf ::temp1 _label2
            ; line 525
            array_getlement ::temp0 ::SlotStates_var i 
            cmp_eq ::temp1 ::temp0 0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label3
            ; line 526
            iadd ::temp0 activeCount 1 
            assign activeCount ::temp0 
            jmp _label4
            ; line 527
          _label3:
            cmp_lt ::temp1 firstFree 0 
            jmpf ::temp1 _label4
            ; line 528
            assign firstFree i 
            jmp _label4
            ; line 530
          _label4:
            iadd ::temp0 i 1 
            assign i ::temp0 
            jmp _label5
            ; line 533
          _label2:
            comp_gte ::temp1 firstFree 0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label6
            cmp_lt ::temp1 activeCount maxAllowed 
            assign ::temp1 ::temp1 
          _label6:
            jmpf ::temp1 _label7
            ; line 534
            return firstFree 
            jmp _label7
            ; line 536
          _label7:
            return -1 
          .endCode
        .endFunction ;FindFreeAgentSlot
        .function FindSlotByAgent
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
            .param akAgent actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local i Int
            .local ::temp2 Int
            .local slotAlias referenceAlias
            .local ::temp3 referenceAlias
          .endLocalTable
          .code
            ; line 540
            cast ::temp0 None 
            cmp_eq ::temp1 akAgent ::temp0 
            jmpf ::temp1 _label0
            ; line 541
            return -1 
            jmp _label0
            ; line 544
          _label0:
            assign i 0 
            ; line 545
          _label5:
            propget MAX_SLOTS self ::temp2 
            cmp_lt ::temp1 i ::temp2 
            jmpf ::temp1 _label1
            ; line 546
            array_getlement ::temp2 ::SlotStates_var i 
            cmp_eq ::temp1 ::temp2 0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 547
            callmethod GetAgentAlias self ::temp3 i ;1 variable args
            assign slotAlias ::temp3 
            ; line 548
            cast ::temp1 slotAlias 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label3
            callmethod GetActorReference slotAlias ::temp0 ;0 variable args
            cmp_eq ::temp1 ::temp0 akAgent 
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 549
            return i 
            jmp _label4
          _label4:
            jmp _label2
            ; line 552
          _label2:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label5
            ; line 554
          _label1:
            return -1 
          .endCode
        .endFunction ;FindSlotByAgent
        .function FindSlotByActor
           ; function type 0
          .userFlags 0 ;none
          .docString "Find slot where akActor is either the agent OR the target. Returns -1 if not found."
          .return Int
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local i Int
            .local ::temp2 Int
            .local agentAlias referenceAlias
            .local ::temp3 referenceAlias
            .local targetAlias referenceAlias
          .endLocalTable
          .code
            ; line 559
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            jmpf ::temp1 _label0
            ; line 560
            return -1 
            jmp _label0
            ; line 563
          _label0:
            assign i 0 
            ; line 564
          _label7:
            propget MAX_SLOTS self ::temp2 
            cmp_lt ::temp1 i ::temp2 
            jmpf ::temp1 _label1
            ; line 565
            array_getlement ::temp2 ::SlotStates_var i 
            cmp_eq ::temp1 ::temp2 0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 566
            callmethod GetAgentAlias self ::temp3 i ;1 variable args
            assign agentAlias ::temp3 
            ; line 567
            cast ::temp1 agentAlias 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label3
            callmethod GetActorReference agentAlias ::temp0 ;0 variable args
            cmp_eq ::temp1 ::temp0 akActor 
            assign ::temp1 ::temp1 
          _label3:
            jmpf ::temp1 _label4
            ; line 568
            return i 
            jmp _label4
            ; line 570
          _label4:
            callmethod GetTargetAlias self ::temp3 i ;1 variable args
            assign targetAlias ::temp3 
            ; line 571
            cast ::temp1 targetAlias 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label5
            callmethod GetActorReference targetAlias ::temp0 ;0 variable args
            cmp_eq ::temp1 ::temp0 akActor 
            assign ::temp1 ::temp1 
          _label5:
            jmpf ::temp1 _label6
            ; line 572
            return i 
            jmp _label6
          _label6:
            jmp _label2
            ; line 575
          _label2:
            iadd ::temp2 i 1 
            assign i ::temp2 
            jmp _label7
            ; line 577
          _label1:
            return -1 
          .endCode
        .endFunction ;FindSlotByActor
        .function AllocateSlot
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param slot Int
            .param akAgent actor
            .param taskType String
            .param targetName String
            .param speed Int
          .endParamTable
          .localTable
            .local slotAlias referenceAlias
            .local ::temp0 referenceAlias
            .local ::nonevar None
            .local ::temp1 objectReference
            .local ::temp2 form
            .local ::temp3 String
            .local ::temp4 Int
            .local ::temp5 String
            .local ::temp6 Float
          .endLocalTable
          .code
            ; line 582
            callmethod GetAgentAlias self ::temp0 slot ;1 variable args
            assign slotAlias ::temp0 
            ; line 583
            cast ::temp1 akAgent 
            callmethod ForceRefTo slotAlias ::nonevar ::temp1 ;1 variable args
            ; line 586
            callmethod AddToFaction akAgent ::nonevar ::IntelEngine_TaskFaction_var ;1 variable args
            ; line 589
            array_setelement ::SlotStates_var slot 1 
            ; line 590
            array_setelement ::SlotTaskTypes_var slot taskType 
            ; line 591
            array_setelement ::SlotTargetNames_var slot targetName 
            ; line 592
            array_setelement ::SlotSpeeds_var slot speed 
            ; line 593
            array_setelement ::SlotDeadlines_var slot 0.0 
            ; line 596
            cast ::temp2 akAgent 
            callstatic storageUtil SetStringValue ::temp3 ::temp2 "Intel_TaskType" taskType ;3 variable args
            ; line 597
            cast ::temp2 akAgent 
            callstatic storageUtil SetStringValue ::temp3 ::temp2 "Intel_Target" targetName ;3 variable args
            ; line 598
            cast ::temp2 akAgent 
            callstatic storageUtil SetIntValue ::temp4 ::temp2 "Intel_Slot" slot ;3 variable args
            ; line 599
            cast ::temp2 akAgent 
            callstatic storageUtil SetIntValue ::temp4 ::temp2 "Intel_State" 1 ;3 variable args
            ; line 600
            cast ::temp2 akAgent 
            callstatic storageUtil SetIntValue ::temp4 ::temp2 "Intel_Speed" speed ;3 variable args
            ; line 603
            callstatic intelEngine UpdateSlotState ::nonevar slot akAgent 1 taskType targetName ;5 variable args
            ; line 604
            callstatic intelEngine SetSlotSpeed ::nonevar slot speed ;2 variable args
            ; line 606
            cast ::temp3 slot 
            strcat ::temp3 "Allocated slot " ::temp3 
            strcat ::temp3 ::temp3 " to " 
            callmethod GetDisplayName akAgent ::temp5 ;0 variable args
            strcat ::temp5 ::temp3 ::temp5 
            strcat ::temp5 ::temp5 " for " 
            strcat ::temp5 ::temp5 taskType 
            callmethod DebugMsg self ::nonevar ::temp5 ;1 variable args
            ; line 607
            cast ::temp6 slot 
            callmethod SendModEvent akAgent ::nonevar "IntelEngine_TaskStarted" taskType ::temp6 ;3 variable args
          .endCode
        .endFunction ;AllocateSlot
        .function ClearSlot
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param slot Int
            .param restoreNPC Bool
            .param intelPackagesOnly Bool
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 Int
            .local agentAlias referenceAlias
            .local ::temp2 referenceAlias
            .local targetAlias referenceAlias
            .local agent actor
            .local ::temp3 actor
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 String
            .local ::temp6 form
            .local ::temp7 Float
            .local histType String
            .local histTarget String
            .local histResult String
            .local histMessage String
            .local histMeetLoc String
            .local hasFutureSchedule Bool
            .local origAggr Float
            .local target actor
          .endLocalTable
          .code
            ; line 611
            cmp_lt ::temp0 slot 0 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            propget MAX_SLOTS self ::temp1 
            comp_gte ::temp0 slot ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 612
            return None 
            jmp _label1
            ; line 615
          _label1:
            callmethod GetAgentAlias self ::temp2 slot ;1 variable args
            assign agentAlias ::temp2 
            ; line 616
            callmethod GetTargetAlias self ::temp2 slot ;1 variable args
            assign targetAlias ::temp2 
            ; line 619
            cast ::temp0 agentAlias 
            jmpf ::temp0 _label2
            ; line 620
            callmethod GetActorReference agentAlias ::temp3 ;0 variable args
            assign agent ::temp3 
            ; line 621
            cast ::temp0 agent 
            jmpf ::temp0 _label3
            ; line 622
            cast ::temp4 slot 
            strcat ::temp4 "Clearing slot " ::temp4 
            strcat ::temp4 ::temp4 ": " 
            callmethod GetDisplayName agent ::temp5 ;0 variable args
            strcat ::temp5 ::temp4 ::temp5 
            callmethod DebugMsg self ::nonevar ::temp5 ;1 variable args
            ; line 623
            cast ::temp6 agent 
            callstatic storageUtil GetStringValue ::temp5 ::temp6 "Intel_Result" "" ;3 variable args
            cast ::temp7 slot 
            callmethod SendModEvent agent ::nonevar "IntelEngine_TaskEnded" ::temp5 ::temp7 ;3 variable args
            ; line 626
            array_getlement ::temp5 ::SlotTaskTypes_var slot 
            assign histType ::temp5 
            ; line 627
            array_getlement ::temp5 ::SlotTargetNames_var slot 
            assign histTarget ::temp5 
            ; line 628
            cast ::temp6 agent 
            callstatic storageUtil GetStringValue ::temp5 ::temp6 "Intel_Result" "" ;3 variable args
            assign histResult ::temp5 
            ; line 629
            cast ::temp6 agent 
            callstatic storageUtil GetStringValue ::temp5 ::temp6 "Intel_Message" "" ;3 variable args
            assign histMessage ::temp5 
            ; line 630
            cast ::temp6 agent 
            callstatic storageUtil GetStringValue ::temp5 ::temp6 "Intel_DeliveryMeetLocation" "" ;3 variable args
            assign histMeetLoc ::temp5 
            ; line 631
            cmp_eq ::temp0 histType "" 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label4
            ; line 632
            callmethod SaveTaskToHistory self ::nonevar agent histType histTarget histResult histMessage histMeetLoc ;6 variable args
            jmp _label4
            ; line 637
          _label4:
            jmpf intelPackagesOnly _label5
            ; line 638
            callmethod RemoveIntelPackages self ::nonevar agent True ;2 variable args
            jmp _label6
            ; line 640
          _label5:
            callmethod RemoveAllPackages self ::nonevar agent True ;2 variable args
            ; line 644
          _label6:
            callmethod ClearLinkedRefs self ::nonevar agent ;1 variable args
            ; line 647
            callmethod RemoveFromFaction agent ::nonevar ::IntelEngine_TaskFaction_var ;1 variable args
            ; line 650
            cast ::temp6 agent 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp6 "Intel_TaskType" ;2 variable args
            ; line 651
            cast ::temp6 agent 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp6 "Intel_Target" ;2 variable args
            ; line 652
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_Slot" ;2 variable args
            ; line 653
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_State" ;2 variable args
            ; line 654
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_Speed" ;2 variable args
            ; line 655
            cast ::temp6 agent 
            callstatic storageUtil UnsetFormValue ::temp0 ::temp6 "Intel_TargetNPC" ;2 variable args
            ; line 656
            cast ::temp6 agent 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp6 "Intel_Message" ;2 variable args
            ; line 657
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_ScheduledTime" ;2 variable args
            ; line 660
            cast ::temp6 agent 
            callstatic storageUtil UnsetFormValue ::temp0 ::temp6 "Intel_DestMarker" ;2 variable args
            ; line 661
            cast ::temp6 agent 
            callstatic storageUtil UnsetFormValue ::temp0 ::temp6 "Intel_ReturnMarker" ;2 variable args
            ; line 662
            cast ::temp6 agent 
            callstatic storageUtil UnsetFormValue ::temp0 ::temp6 "Intel_CurrentWaypoint" ;2 variable args
            ; line 663
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_TaskStartTime" ;2 variable args
            ; line 664
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_TravelArrivalTime" ;2 variable args
            ; line 665
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_WaitHours" ;2 variable args
            ; line 666
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_WaitForPlayer" ;2 variable args
            ; line 667
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_Deadline" ;2 variable args
            ; line 668
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_WasFollower" ;2 variable args
            ; line 671
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_InteractCyclesRemaining" ;2 variable args
            ; line 672
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_ShouldFail" ;2 variable args
            ; line 673
            cast ::temp6 agent 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp6 "Intel_FailReason" ;2 variable args
            ; line 674
            cast ::temp6 agent 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp6 "Intel_Result" ;2 variable args
            ; line 675
            cast ::temp6 agent 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp6 "Intel_EscortDestName" ;2 variable args
            ; line 676
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_EscortShouldWait" ;2 variable args
            ; line 677
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_TargetWaitCycles" ;2 variable args
            ; line 678
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_TargetLastDist" ;2 variable args
            ; line 679
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_ReturnCycles" ;2 variable args
            ; line 682
            cast ::temp6 agent 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp6 "Intel_DeliveryMeetLocation" ;2 variable args
            ; line 683
            cast ::temp6 agent 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp6 "Intel_DeliveryMeetTime" ;2 variable args
            ; line 686
            cast ::temp3 None 
            callstatic intelEngine ResetDepartureSlot ::nonevar slot ::temp3 ;2 variable args
            ; line 687
            callstatic intelEngine ResetOffScreenSlot ::nonevar slot ;1 variable args
            ; line 688
            callstatic intelEngine DisarmProximityArrival ::nonevar slot ;1 variable args
            ; line 689
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_OffscreenArrival" ;2 variable args
            ; line 692
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_IsScheduledMeeting" ;2 variable args
            ; line 696
            assign hasFutureSchedule False 
            ; line 697
            cast ::temp0 ::Schedule_var 
            jmpf ::temp0 _label7
            ; line 698
            callmethod HasFutureScheduleForAgent ::Schedule_var ::temp0 agent ;1 variable args
            assign hasFutureSchedule ::temp0 
            ; line 699
            not ::temp0 hasFutureSchedule 
            jmpf ::temp0 _label8
            ; line 700
            callmethod ClearScheduleSlotByAgent ::Schedule_var ::nonevar agent ;1 variable args
            jmp _label8
          _label8:
            jmp _label7
            ; line 703
          _label7:
            not ::temp0 hasFutureSchedule 
            jmpf ::temp0 _label9
            ; line 704
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_ScheduledState" ;2 variable args
            ; line 705
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_ScheduledDepartureHours" ;2 variable args
            jmp _label9
            ; line 710
          _label9:
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_MeetingTime" ;2 variable args
            ; line 711
            cast ::temp6 agent 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp6 "Intel_MeetingDest" ;2 variable args
            ; line 712
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_MeetingNpcArrivalTime" ;2 variable args
            ; line 713
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_MeetingLingering" ;2 variable args
            ; line 714
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_MeetingLingerApproaching" ;2 variable args
            ; line 715
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_MeetingLingerDeadline" ;2 variable args
            ; line 716
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_MeetingApproaching" ;2 variable args
            ; line 717
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_LingerFarTicks" ;2 variable args
            ; line 718
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_ApproachStartX" ;2 variable args
            ; line 719
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_ApproachStartY" ;2 variable args
            ; line 720
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_ApproachTick" ;2 variable args
            ; line 721
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_ApproachStuckNarrated" ;2 variable args
            ; line 722
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_TaskStuckNarrated" ;2 variable args
            ; line 723
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_SelfMotivatedLogged" ;2 variable args
            ; line 726
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_TravelLingering" ;2 variable args
            ; line 727
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_StayAtDest" ;2 variable args
            ; line 730
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_OffScreenCycles" ;2 variable args
            ; line 731
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_OffScreenLastDist" ;2 variable args
            ; line 734
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_UnlockedHomeCellId" ;2 variable args
            ; line 737
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_TaskCooldown" ;2 variable args
            ; line 740
            cast ::temp6 agent 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_IsStoryDispatch" ;2 variable args
            ; line 741
            cast ::temp6 agent 
            callstatic storageUtil UnsetStringValue ::temp0 ::temp6 "Intel_StoryNarration" ;2 variable args
            ; line 744
            cast ::temp6 agent 
            callstatic storageUtil GetFloatValue ::temp7 ::temp6 "Intel_OrigAggression" -1.0 ;3 variable args
            assign origAggr ::temp7 
            ; line 745
            comp_gte ::temp0 origAggr 0.0 
            jmpf ::temp0 _label10
            ; line 746
            callmethod SetActorValue agent ::nonevar "Aggression" origAggr ;2 variable args
            ; line 747
            cast ::temp6 agent 
            callstatic storageUtil UnsetFloatValue ::temp0 ::temp6 "Intel_OrigAggression" ;2 variable args
            jmp _label10
            ; line 751
          _label10:
            callmethod EvaluatePackage agent ::nonevar ;0 variable args
            jmp _label3
            ; line 753
          _label3:
            callmethod Clear agentAlias ::nonevar ;0 variable args
            jmp _label2
            ; line 757
          _label2:
            cast ::temp0 targetAlias 
            jmpf ::temp0 _label11
            ; line 758
            callmethod GetActorReference targetAlias ::temp3 ;0 variable args
            assign target ::temp3 
            ; line 759
            cast ::temp0 target 
            jmpf ::temp0 _label12
            ; line 760
            callmethod RemoveIntelPackages self ::nonevar target True ;2 variable args
            ; line 761
            callmethod ClearLinkedRefs self ::nonevar target ;1 variable args
            ; line 762
            cast ::temp6 target 
            callstatic storageUtil UnsetIntValue ::temp0 ::temp6 "Intel_WasAccompanying" ;2 variable args
            ; line 763
            callmethod EvaluatePackage target ::nonevar ;0 variable args
            jmp _label12
            ; line 765
          _label12:
            callmethod Clear targetAlias ::nonevar ;0 variable args
            jmp _label11
            ; line 769
          _label11:
            array_setelement ::SlotStates_var slot 0 
            ; line 770
            array_setelement ::SlotTaskTypes_var slot "" 
            ; line 771
            array_setelement ::SlotTargetNames_var slot "" 
            ; line 772
            array_setelement ::SlotDeadlines_var slot 0.0 
            ; line 773
            array_setelement ::SlotSpeeds_var slot 0 
            ; line 776
            callstatic intelEngine ClearSlotState ::nonevar slot ;1 variable args
          .endCode
        .endFunction ;ClearSlot
        .function CancelCurrentTask
           ; function type 0
          .userFlags 0 ;none
          .docString "Cancel the NPC's current task entirely. Called by CancelCurrentTask action.
    Blocked while the player is within LINGER_RELEASE_DISTANCE — the linger
    system handles task cleanup when the player walks away."
          .return Bool
          .paramTable
            .param akNPC actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local slot Int
            .local ::temp2 Int
            .local ::nonevar None
            .local ::temp3 String
            .local ::temp4 form
          .endLocalTable
          .code
            ; line 787
            cast ::temp0 None 
            cmp_eq ::temp1 akNPC ::temp0 
            jmpf ::temp1 _label0
            ; line 788
            return False 
            jmp _label0
            ; line 790
          _label0:
            callmethod FindSlotByAgent self ::temp2 akNPC ;1 variable args
            assign slot ::temp2 
            ; line 791
            cmp_lt ::temp1 slot 0 
            jmpf ::temp1 _label1
            ; line 792
            return False 
            jmp _label1
            ; line 797
          _label1:
            callmethod ShouldReleaseLinger self ::temp1 akNPC ;1 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 798
            callmethod GetDisplayName akNPC ::temp3 ;0 variable args
            strcat ::temp3 ::temp3 " cancel blocked: player nearby" 
            callmethod DebugMsg self ::nonevar ::temp3 ;1 variable args
            ; line 799
            return False 
            jmp _label2
            ; line 802
          _label2:
            cast ::temp4 akNPC 
            callstatic storageUtil SetStringValue ::temp3 ::temp4 "Intel_Result" "cancelled" ;3 variable args
            ; line 803
            callmethod ClearSlotRestoreFollower self ::nonevar slot akNPC ;2 variable args
            ; line 804
            return True 
          .endCode
        .endFunction ;CancelCurrentTask
        .function ChangeTaskSpeed
           ; function type 0
          .userFlags 0 ;none
          .docString "Change travel speed mid-task. Called by ChangeSpeed action."
          .return Bool
          .paramTable
            .param akNPC actor
            .param newSpeed Int
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local slot Int
            .local ::temp2 Int
            .local taskState Int
            .local oldSpeed Int
            .local oldPkg package
            .local ::temp3 package
            .local newPkg package
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 809
            cast ::temp0 None 
            cmp_eq ::temp1 akNPC ::temp0 
            jmpf ::temp1 _label0
            ; line 810
            return False 
            jmp _label0
            ; line 812
          _label0:
            callmethod FindSlotByAgent self ::temp2 akNPC ;1 variable args
            assign slot ::temp2 
            ; line 813
            cmp_lt ::temp1 slot 0 
            jmpf ::temp1 _label1
            ; line 814
            return False 
            jmp _label1
            ; line 817
          _label1:
            array_getlement ::temp2 ::SlotStates_var slot 
            assign taskState ::temp2 
            ; line 818
            cmp_eq ::temp1 taskState 1 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            cmp_eq ::temp1 taskState 3 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 819
            return False 
            jmp _label3
            ; line 822
          _label3:
            cmp_lt ::temp1 newSpeed 0 
            jmpf ::temp1 _label4
            ; line 823
            assign newSpeed 0 
            jmp _label5
            ; line 824
          _label4:
            cmp_gt ::temp1 newSpeed 2 
            jmpf ::temp1 _label5
            ; line 825
            assign newSpeed 2 
            jmp _label5
            ; line 827
          _label5:
            array_getlement ::temp2 ::SlotSpeeds_var slot 
            assign oldSpeed ::temp2 
            ; line 828
            cmp_eq ::temp1 oldSpeed newSpeed 
            jmpf ::temp1 _label6
            ; line 829
            return True 
            jmp _label6
            ; line 832
          _label6:
            callmethod GetTravelPackage self ::temp3 oldSpeed ;1 variable args
            assign oldPkg ::temp3 
            ; line 833
            callmethod GetTravelPackage self ::temp3 newSpeed ;1 variable args
            assign newPkg ::temp3 
            ; line 834
            callstatic actorUtil RemovePackageOverride ::temp1 akNPC oldPkg ;2 variable args
            ; line 835
            propget PRIORITY_TRAVEL self ::temp2 
            callstatic actorUtil AddPackageOverride ::nonevar akNPC newPkg ::temp2 1 ;4 variable args
            ; line 836
            callmethod EvaluatePackage akNPC ::nonevar ;0 variable args
            ; line 837
            callmethod SetSlotSpeed self ::nonevar slot akNPC newSpeed ;3 variable args
            ; line 838
            callmethod GetDisplayName akNPC ::temp4 ;0 variable args
            strcat ::temp4 ::temp4 " speed changed: " 
            cast ::temp5 oldSpeed 
            strcat ::temp5 ::temp4 ::temp5 
            strcat ::temp5 ::temp5 " -> " 
            cast ::temp4 newSpeed 
            strcat ::temp4 ::temp5 ::temp4 
            callmethod DebugMsg self ::nonevar ::temp4 ;1 variable args
            ; line 839
            return True 
          .endCode
        .endFunction ;ChangeTaskSpeed
        .function SetSlotState
           ; function type 0
          .userFlags 0 ;none
          .docString "Update task state — writes both array, StorageUtil, and C++ SlotTracker."
          .return None
          .paramTable
            .param slot Int
            .param akAgent actor
            .param newState Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 Int
            .local ::temp2 actor
            .local ::temp3 form
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 String
          .endLocalTable
          .code
            ; line 852
            cmp_lt ::temp0 slot 0 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            propget MAX_SLOTS self ::temp1 
            comp_gte ::temp0 slot ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 853
            return None 
            jmp _label1
            ; line 855
          _label1:
            array_setelement ::SlotStates_var slot newState 
            ; line 856
            cast ::temp2 None 
            cmp_eq ::temp0 akAgent ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 857
            cast ::temp3 akAgent 
            callstatic storageUtil SetIntValue ::temp1 ::temp3 "Intel_State" newState ;3 variable args
            jmp _label2
            ; line 861
          _label2:
            array_getlement ::temp4 ::SlotTaskTypes_var slot 
            array_getlement ::temp5 ::SlotTargetNames_var slot 
            callstatic intelEngine UpdateSlotState ::nonevar slot akAgent newState ::temp4 ::temp5 ;5 variable args
          .endCode
        .endFunction ;SetSlotState
        .function SetSlotSpeed
           ; function type 0
          .userFlags 0 ;none
          .docString "Update travel speed — writes array, StorageUtil, and C++ SlotTracker."
          .return None
          .paramTable
            .param slot Int
            .param akAgent actor
            .param newSpeed Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 Int
            .local ::nonevar None
            .local ::temp2 actor
            .local ::temp3 form
          .endLocalTable
          .code
            ; line 866
            cmp_lt ::temp0 slot 0 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            propget MAX_SLOTS self ::temp1 
            comp_gte ::temp0 slot ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 867
            return None 
            jmp _label1
            ; line 869
          _label1:
            array_setelement ::SlotSpeeds_var slot newSpeed 
            ; line 870
            callstatic intelEngine SetSlotSpeed ::nonevar slot newSpeed ;2 variable args
            ; line 871
            cast ::temp2 None 
            cmp_eq ::temp0 akAgent ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 872
            cast ::temp3 akAgent 
            callstatic storageUtil SetIntValue ::temp1 ::temp3 "Intel_Speed" newSpeed ;3 variable args
            jmp _label2
          _label2
          .endCode
        .endFunction ;SetSlotSpeed
        .function SetSlotDeadline
           ; function type 0
          .userFlags 0 ;none
          .docString "Update wait deadline — persisted via C++ co-save + StorageUtil legacy."
          .return None
          .paramTable
            .param slot Int
            .param deadline Float
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 Int
            .local ::nonevar None
            .local agentAlias referenceAlias
            .local ::temp2 referenceAlias
            .local agent actor
            .local ::temp3 actor
            .local ::temp4 form
            .local ::temp5 Float
          .endLocalTable
          .code
            ; line 878
            cmp_lt ::temp0 slot 0 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            propget MAX_SLOTS self ::temp1 
            comp_gte ::temp0 slot ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 879
            return None 
            jmp _label1
            ; line 881
          _label1:
            array_setelement ::SlotDeadlines_var slot deadline 
            ; line 882
            callstatic intelEngine SetSlotDeadline ::nonevar slot deadline ;2 variable args
            ; line 884
            callmethod GetAgentAlias self ::temp2 slot ;1 variable args
            assign agentAlias ::temp2 
            ; line 885
            cast ::temp0 agentAlias 
            jmpf ::temp0 _label2
            ; line 886
            callmethod GetActorReference agentAlias ::temp3 ;0 variable args
            assign agent ::temp3 
            ; line 887
            cast ::temp0 agent 
            jmpf ::temp0 _label3
            ; line 888
            cast ::temp4 agent 
            callstatic storageUtil SetFloatValue ::temp5 ::temp4 "Intel_Deadline" deadline ;3 variable args
            jmp _label3
          _label3:
            jmp _label2
          _label2
          .endCode
        .endFunction ;SetSlotDeadline
        .function ClearSlotRestoreFollower
           ; function type 0
          .userFlags 0 ;none
          .docString "Clear a task slot and restore follower status if the agent was a follower.
    Reads Intel_WasFollower BEFORE ClearSlot wipes it, then restores teammate.
    For followers: only removes IntelEngine packages, preserving NFF/SkyrimNet
    follow packages so the NPC resumes following without needing a re-kick."
          .return None
          .paramTable
            .param slot Int
            .param akAgent actor
          .endParamTable
          .localTable
            .local wasFollower Bool
            .local ::temp0 form
            .local ::temp1 Int
            .local ::temp2 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 898
            cast ::temp0 akAgent 
            callstatic storageUtil GetIntValue ::temp1 ::temp0 "Intel_WasFollower" 0 ;3 variable args
            cast ::temp2 ::temp1 
            assign wasFollower ::temp2 
            ; line 899
            callmethod ClearSlot self ::nonevar slot True wasFollower ;3 variable args
            ; line 900
            jmpf wasFollower _label0
            ; line 901
            callmethod SetPlayerTeammate akAgent ::nonevar True True ;2 variable args
            ; line 902
            callmethod EvaluatePackage akAgent ::nonevar ;0 variable args
            jmp _label0
          _label0
          .endCode
        .endFunction ;ClearSlotRestoreFollower
        .function MarkSlotProcessing
           ; function type 0
          .userFlags 0 ;none
          .docString "Mark slot as being processed — prevents re-entry from monitoring loops.
    Unlike direct SlotStates[slot]=0, this also updates StorageUtil to prevent
    stale state surviving a save/load between here and ClearSlot."
          .return None
          .paramTable
            .param slot Int
            .param akAgent actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 Int
            .local ::temp2 actor
            .local ::temp3 form
          .endLocalTable
          .code
            ; line 910
            cmp_lt ::temp0 slot 0 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            propget MAX_SLOTS self ::temp1 
            comp_gte ::temp0 slot ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 911
            return None 
            jmp _label1
            ; line 913
          _label1:
            array_setelement ::SlotStates_var slot 0 
            ; line 914
            cast ::temp2 None 
            cmp_eq ::temp0 akAgent ::temp2 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 915
            cast ::temp3 akAgent 
            callstatic storageUtil SetIntValue ::temp1 ::temp3 "Intel_State" 0 ;3 variable args
            jmp _label2
          _label2
          .endCode
        .endFunction ;MarkSlotProcessing
        .function ShouldReleaseLinger
           ; function type 0
          .userFlags 0 ;none
          .docString "Single source of truth: should a lingering NPC be released?
    Returns true when the player is far enough away (or NPC unloaded)."
          .return Bool
          .paramTable
            .param npc actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local player actor
            .local ::temp1 actor
            .local dist Float
            .local ::temp2 objectReference
            .local ::temp3 Float
            .local ::temp4 cell
            .local ::temp5 cell
          .endLocalTable
          .code
            ; line 928
            callmethod Is3DLoaded npc ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 929
            return True 
            jmp _label0
            ; line 932
          _label0:
            callstatic game GetPlayer ::temp1 ;0 variable args
            assign player ::temp1 
            ; line 933
            callmethod Is3DLoaded player ::temp0 ;0 variable args
            jmpf ::temp0 _label1
            ; line 934
            cast ::temp2 player 
            callmethod GetDistance npc ::temp3 ::temp2 ;1 variable args
            assign dist ::temp3 
            ; line 935
            cmp_gt ::temp0 dist 0.0 
            jmpf ::temp0 _label2
            ; line 936
            cmp_gt ::temp0 dist ::LINGER_RELEASE_DISTANCE_var 
            return ::temp0 
            jmp _label3
            ; line 939
          _label2:
            callmethod GetParentCell npc ::temp4 ;0 variable args
            callmethod GetParentCell player ::temp5 ;0 variable args
            cmp_eq ::temp0 ::temp4 ::temp5 
            not ::temp0 ::temp0 
            return ::temp0 
          _label3:
            jmp _label1
            ; line 943
          _label1:
            callmethod GetParentCell npc ::temp5 ;0 variable args
            callmethod GetParentCell player ::temp4 ;0 variable args
            cmp_eq ::temp0 ::temp5 ::temp4 
            not ::temp0 ::temp0 
            return ::temp0 
          .endCode
        .endFunction ;ShouldReleaseLinger
        .function ReleaseLinger
           ; function type 0
          .userFlags 0 ;none
          .docString "Remove sandbox override and send NPC back where they belong.
    NPCs with schedule AI (eat, sleep, patrol) are trusted to handle themselves.
    NPCs with only sandbox AI or no AI get a walk-home fallback so they don't
    stand frozen at the linger location forever.
    Shared by Travel, StoryEngine, and NPCTasks."
          .return None
          .paramTable
            .param npc actor
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local ::temp1 Int
            .local ::temp2 String
            .local ::temp3 Bool
            .local ::temp4 objectReference
            .local ::temp5 objectReference
            .local destRef objectReference
            .local ::temp6 form
          .endLocalTable
          .code
            ; line 952
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Linger release START: " ::temp0 
            strcat ::temp0 ::temp0 " [formID=" 
            callmethod GetFormID npc ::temp1 ;0 variable args
            cast ::temp2 ::temp1 
            strcat ::temp2 ::temp0 ::temp2 
            strcat ::temp2 ::temp2 ", 3Dloaded=" 
            callmethod Is3DLoaded npc ::temp3 ;0 variable args
            cast ::temp0 ::temp3 
            strcat ::temp0 ::temp2 ::temp0 
            strcat ::temp0 ::temp0 ", isTeammate=" 
            callmethod IsPlayerTeammate npc ::temp3 ;0 variable args
            cast ::temp2 ::temp3 
            strcat ::temp2 ::temp0 ::temp2 
            strcat ::temp2 ::temp2 "]" 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            ; line 953
            callstatic actorUtil RemovePackageOverride ::temp3 npc ::SandboxNearPlayerPackage_var ;2 variable args
            ; line 954
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 "Linger release: removed sandbox from " ::temp2 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            ; line 959
            callmethod IsPlayerTeammate npc ::temp3 ;0 variable args
            jmpf ::temp3 _label0
            ; line 960
            cast ::temp4 npc 
            cast ::temp5 None 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp4 ::temp5 ::IntelEngine_TravelTarget_var ;3 variable args
            ; line 961
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 "Linger release: " ::temp2 
            strcat ::temp2 ::temp2 " is teammate -> cleared linked ref" 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            jmp _label1
            ; line 962
          _label0:
            callstatic intelEngine HasNonSandboxAI ::temp3 npc ;1 variable args
            jmpf ::temp3 _label2
            ; line 963
            cast ::temp5 npc 
            cast ::temp4 None 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp5 ::temp4 ::IntelEngine_TravelTarget_var ;3 variable args
            ; line 964
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 "Linger release: " ::temp2 
            strcat ::temp2 ::temp2 " has schedule AI -> relying on base packages" 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            jmp _label1
            ; line 968
          _label2:
            callstatic intelEngine ResolveAnyDestination ::temp4 npc "home" ;2 variable args
            assign destRef ::temp4 
            ; line 969
            cast ::temp4 None 
            cmp_eq ::temp3 destRef ::temp4 
            jmpf ::temp3 _label3
            ; line 970
            callstatic intelEngine GetEditorLocationRef ::temp4 npc ;1 variable args
            assign destRef ::temp4 
            jmp _label3
            ; line 972
          _label3:
            cast ::temp4 None 
            cmp_eq ::temp3 destRef ::temp4 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label4
            ; line 973
            callmethod Is3DLoaded npc ::temp3 ;0 variable args
            not ::temp3 ::temp3 
            jmpf ::temp3 _label5
            ; line 975
            callmethod MoveTo npc ::nonevar destRef 0.0 0.0 0.0 True ;5 variable args
            ; line 976
            cast ::temp4 npc 
            cast ::temp5 None 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp4 ::temp5 ::IntelEngine_TravelTarget_var ;3 variable args
            ; line 977
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 "Linger release: " ::temp2 
            strcat ::temp2 ::temp2 " sandbox-only AI, not loaded -> teleported home" 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            jmp _label6
            ; line 980
          _label5:
            cast ::temp5 npc 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp5 destRef ::IntelEngine_TravelTarget_var ;3 variable args
            ; line 981
            propget PRIORITY_TRAVEL self ::temp1 
            callstatic actorUtil AddPackageOverride ::nonevar npc ::TravelPackage_Walk_var ::temp1 1 ;4 variable args
            ; line 982
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 "Linger release: " ::temp2 
            strcat ::temp2 ::temp2 " sandbox-only AI, 3D loaded -> walking home" 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
          _label6:
            jmp _label1
            ; line 985
          _label4:
            cast ::temp5 npc 
            cast ::temp4 None 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp5 ::temp4 ::IntelEngine_TravelTarget_var ;3 variable args
            ; line 986
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 "Linger release: " ::temp2 
            strcat ::temp2 ::temp2 " sandbox-only AI, no home/editor location -> sandbox in place" 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            ; line 989
          _label1:
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 990
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 "Linger release DONE: " ::temp2 
            strcat ::temp2 ::temp2 " EvaluatePackage called" 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            ; line 991
            cast ::temp6 npc 
            callstatic storageUtil UnsetIntValue ::temp3 ::temp6 "Intel_LingerFarTicks" ;2 variable args
            ; line 993
            cast ::temp6 npc 
            callstatic storageUtil UnsetIntValue ::temp3 ::temp6 "Intel_UnlockedHomeCellId" ;2 variable args
          .endCode
        .endFunction ;ReleaseLinger
        .function GetNPCTaskType
           ; function type 0
          .userFlags 0 ;none
          .docString "Returns the current task type for an NPC, or "" if not on a task."
          .return String
          .paramTable
            .param npc actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 form
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 1002
            not ::temp0 npc 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            callmethod IsInFaction npc ::temp0 ::IntelEngine_TaskFaction_var ;1 variable args
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 1003
            return "" 
            jmp _label1
            ; line 1005
          _label1:
            cast ::temp1 npc 
            callstatic storageUtil GetStringValue ::temp2 ::temp1 "Intel_TaskType" "" ;3 variable args
            return ::temp2 
          .endCode
        .endFunction ;GetNPCTaskType
        .function IsDuplicateTask
           ; function type 0
          .userFlags 0 ;none
          .docString "Returns true if NPC is already doing the exact same task. Caller should return false."
          .return Bool
          .paramTable
            .param npc actor
            .param taskType String
            .param target String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local currentTask String
            .local ::temp1 form
            .local ::temp2 String
            .local currentTarget String
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1010
            callmethod IsInFaction npc ::temp0 ::IntelEngine_TaskFaction_var ;1 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 1011
            return False 
            jmp _label0
            ; line 1013
          _label0:
            cast ::temp1 npc 
            callstatic storageUtil GetStringValue ::temp2 ::temp1 "Intel_TaskType" "" ;3 variable args
            assign currentTask ::temp2 
            ; line 1014
            cast ::temp1 npc 
            callstatic storageUtil GetStringValue ::temp2 ::temp1 "Intel_Target" "" ;3 variable args
            assign currentTarget ::temp2 
            ; line 1015
            cmp_eq ::temp0 currentTask taskType 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label1
            cmp_eq ::temp0 currentTarget target 
            assign ::temp0 ::temp0 
          _label1:
            jmpf ::temp0 _label2
            ; line 1016
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 "Duplicate task ignored: " ::temp2 
            strcat ::temp2 ::temp2 " already on " 
            strcat ::temp2 ::temp2 taskType 
            strcat ::temp2 ::temp2 " → " 
            strcat ::temp2 ::temp2 target 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            ; line 1017
            return True 
            jmp _label2
            ; line 1019
          _label2:
            return False 
          .endCode
        .endFunction ;IsDuplicateTask
        .function OverrideExistingTask
           ; function type 0
          .userFlags 0 ;none
          .docString "If NPC is already on a task, clear it to make room for the new one."
          .return None
          .paramTable
            .param npc actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local existingSlot Int
            .local ::temp1 Int
            .local ::nonevar None
            .local ::temp2 String
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 1024
            callmethod IsInFaction npc ::temp0 ::IntelEngine_TaskFaction_var ;1 variable args
            jmpf ::temp0 _label0
            ; line 1025
            callmethod FindSlotByAgent self ::temp1 npc ;1 variable args
            assign existingSlot ::temp1 
            ; line 1026
            comp_gte ::temp0 existingSlot 0 
            jmpf ::temp0 _label1
            ; line 1027
            callmethod GetDisplayName npc ::temp2 ;0 variable args
            strcat ::temp2 ::temp2 " overriding active task in slot " 
            cast ::temp3 existingSlot 
            strcat ::temp3 ::temp2 ::temp3 
            callmethod DebugMsg self ::nonevar ::temp3 ;1 variable args
            ; line 1028
            callmethod ClearSlot self ::nonevar existingSlot True False ;3 variable args
            jmp _label1
          _label1:
            jmp _label0
          _label0
          .endCode
        .endFunction ;OverrideExistingTask
        .function DismissFollowerForTask
           ; function type 0
          .userFlags 0 ;none
          .docString "Prepare NPC for a new IntelEngine task by clearing ALL package overrides.

    Uses ActorUtil.ClearPackageOverride to remove overrides from ALL sources —
    IntelEngine, SkyrimNet (companion follow, TalkToPlayer), and any other mod.
    IntelEngine's task functions (GoToLocation, FetchNPC, etc.) immediately apply
    their own packages after this call, so the NPC is never left without overrides.

    Why blanket clear instead of removing specific packages:
    SkyrimNet's companion follow system uses its own package overrides that are
    invisible to IntelEngine. SetPlayerTeammate(false) only clears the vanilla
    follower flag — SkyrimNet's follow package stays active and overrides the
    travel package, causing the NPC to follow the player instead of traveling.
    Diagnosed via Ingrid's Western Watchtower trip where she followed the player
    for 1.5 hours instead of walking to the destination, with no stuck detection
    (she was moving, just not toward the destination).

    Note: EvaluatePackage is NOT called here — callers apply their own packages
    first, then evaluate. This prevents a brief gap where the NPC has no overrides
    and reverts to default AI."
          .return None
          .paramTable
            .param npc actor
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
          .endLocalTable
          .code
            ; line 1055
            callmethod RemoveIntelPackages self ::nonevar npc False ;2 variable args
            ; line 1056
            callmethod IEB_ReleaseSkyrimNetPackages self ::nonevar npc ;1 variable args
            ; line 1057
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Removed IntelEngine and SkyrimNet follow packages for " ::temp0 
            callmethod DebugMsg self ::nonevar ::temp0 ;1 variable args
            ; line 1062
            callmethod IsPlayerTeammate npc ::temp1 ;0 variable args
            jmpf ::temp1 _label0
            ; line 1063
            cast ::temp2 npc 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "Intel_WasFollower" 1 ;3 variable args
            ; line 1064
            cast ::temp2 None 
            callstatic storageUtil GetIntValue ::temp3 ::temp2 "IEB_DropTeammate" 0 ;3 variable args
            cmp_eq ::temp1 ::temp3 1 
            jmpf ::temp1 _label1
            ; line 1065
            callmethod SetPlayerTeammate npc ::nonevar False True ;2 variable args
            ; line 1066
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Dismissed follower: " ::temp0 
            callmethod DebugMsg self ::nonevar ::temp0 ;1 variable args
            jmp _label2
            ; line 1068
          _label1:
            callmethod GetDisplayName npc ::temp0 ;0 variable args
            strcat ::temp0 "Kept follower as teammate for task: " ::temp0 
            callmethod DebugMsg self ::nonevar ::temp0 ;1 variable args
          _label2:
            jmp _label0
          _label0
          .endCode
        .endFunction ;DismissFollowerForTask
        .function ShowTaskConfirmation
           ; function type 0
          .userFlags 0 ;none
          .docString "Legacy wrapper — calls per-action version with empty action (uses old global toggle)."
          .return Int
          .paramTable
            .param npc actor
            .param promptText String
          .endParamTable
          .localTable
            .local ::temp0 Int
          .endLocalTable
          .code
            ; line 1075
            callmethod ShowTaskConfirmationForAction self ::temp0 npc promptText "" ;3 variable args
            return ::temp0 
          .endCode
        .endFunction ;ShowTaskConfirmation
        .function ShowTaskConfirmationForAction
           ; function type 0
          .userFlags 0 ;none
          .docString "Per-action confirmation prompt. Returns: 0=allow, 1=deny (narrate), 2=deny silent.
    Mode per action: 0=disabled, 1=followers only, 2=everyone."
          .return Int
          .paramTable
            .param npc actor
            .param promptText String
            .param actionName String
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 intelEngine_StoryEngine
            .local skipFollower Bool
            .local ::nonevar None
            .local ::temp2 String
            .local ::temp3 String
            .local mode Int
            .local ::temp4 Int
            .local ::temp5 actor
            .local ::temp6 form
            .local result String
          .endLocalTable
          .code
            ; line 1083
            callmethod IsPlayerTeammate npc ::temp0 ;0 variable args
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label0
            cmp_eq ::temp0 actionName "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label0:
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label1
            cast ::temp1 None 
            cmp_eq ::temp0 ::StoryEngine_var ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label1:
            jmpf ::temp0 _label2
            ; line 1084
            assign skipFollower False 
            ; line 1085
            cmp_eq ::temp0 actionName "GoToLocation" 
            jmpf ::temp0 _label3
            ; line 1086
            propget SkipFollowerGoToLocation ::StoryEngine_var ::temp0 
            assign skipFollower ::temp0 
            jmp _label4
            ; line 1087
          _label3:
            cmp_eq ::temp0 actionName "DeliverMessage" 
            jmpf ::temp0 _label5
            ; line 1088
            propget SkipFollowerDeliverMessage ::StoryEngine_var ::temp0 
            assign skipFollower ::temp0 
            jmp _label4
            ; line 1089
          _label5:
            cmp_eq ::temp0 actionName "FetchPerson" 
            jmpf ::temp0 _label6
            ; line 1090
            propget SkipFollowerFetchPerson ::StoryEngine_var ::temp0 
            assign skipFollower ::temp0 
            jmp _label4
            ; line 1091
          _label6:
            cmp_eq ::temp0 actionName "EscortTarget" 
            jmpf ::temp0 _label7
            ; line 1092
            propget SkipFollowerEscortTarget ::StoryEngine_var ::temp0 
            assign skipFollower ::temp0 
            jmp _label4
            ; line 1093
          _label7:
            cmp_eq ::temp0 actionName "SearchForActor" 
            jmpf ::temp0 _label8
            ; line 1094
            propget SkipFollowerSearchForActor ::StoryEngine_var ::temp0 
            assign skipFollower ::temp0 
            jmp _label4
            ; line 1095
          _label8:
            cmp_eq ::temp0 actionName "ScheduleFetch" 
            jmpf ::temp0 _label9
            ; line 1096
            propget SkipFollowerScheduleFetch ::StoryEngine_var ::temp0 
            assign skipFollower ::temp0 
            jmp _label4
            ; line 1097
          _label9:
            cmp_eq ::temp0 actionName "ScheduleDelivery" 
            jmpf ::temp0 _label10
            ; line 1098
            propget SkipFollowerScheduleDelivery ::StoryEngine_var ::temp0 
            assign skipFollower ::temp0 
            jmp _label4
            ; line 1099
          _label10:
            cmp_eq ::temp0 actionName "ScheduleMeeting" 
            jmpf ::temp0 _label4
            ; line 1100
            propget SkipFollowerScheduleMeeting ::StoryEngine_var ::temp0 
            assign skipFollower ::temp0 
            jmp _label4
            ; line 1102
          _label4:
            jmpf skipFollower _label11
            ; line 1103
            strcat ::temp2 "Skipping " actionName 
            strcat ::temp2 ::temp2 " for follower " 
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 ::temp2 ::temp3 
            callmethod DebugMsg self ::nonevar ::temp3 ;1 variable args
            ; line 1104
            return 2 
            jmp _label11
          _label11:
            jmp _label2
            ; line 1108
          _label2:
            assign mode 0 
            ; line 1109
            cmp_eq ::temp0 actionName "" 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label12
            cast ::temp1 None 
            cmp_eq ::temp0 ::StoryEngine_var ::temp1 
            not ::temp0 ::temp0 
            assign ::temp0 ::temp0 
          _label12:
            jmpf ::temp0 _label13
            ; line 1110
            cmp_eq ::temp0 actionName "GoToLocation" 
            jmpf ::temp0 _label14
            ; line 1111
            propget ConfirmGoToLocation ::StoryEngine_var ::temp4 
            assign mode ::temp4 
            jmp _label15
            ; line 1112
          _label14:
            cmp_eq ::temp0 actionName "DeliverMessage" 
            jmpf ::temp0 _label16
            ; line 1113
            propget ConfirmDeliverMessage ::StoryEngine_var ::temp4 
            assign mode ::temp4 
            jmp _label15
            ; line 1114
          _label16:
            cmp_eq ::temp0 actionName "FetchPerson" 
            jmpf ::temp0 _label17
            ; line 1115
            propget ConfirmFetchPerson ::StoryEngine_var ::temp4 
            assign mode ::temp4 
            jmp _label15
            ; line 1116
          _label17:
            cmp_eq ::temp0 actionName "EscortTarget" 
            jmpf ::temp0 _label18
            ; line 1117
            propget ConfirmEscortTarget ::StoryEngine_var ::temp4 
            assign mode ::temp4 
            jmp _label15
            ; line 1118
          _label18:
            cmp_eq ::temp0 actionName "SearchForActor" 
            jmpf ::temp0 _label19
            ; line 1119
            propget ConfirmSearchForActor ::StoryEngine_var ::temp4 
            assign mode ::temp4 
            jmp _label15
            ; line 1120
          _label19:
            cmp_eq ::temp0 actionName "ScheduleFetch" 
            jmpf ::temp0 _label20
            ; line 1121
            propget ConfirmScheduleFetch ::StoryEngine_var ::temp4 
            assign mode ::temp4 
            jmp _label15
            ; line 1122
          _label20:
            cmp_eq ::temp0 actionName "ScheduleDelivery" 
            jmpf ::temp0 _label21
            ; line 1123
            propget ConfirmScheduleDelivery ::StoryEngine_var ::temp4 
            assign mode ::temp4 
            jmp _label15
            ; line 1124
          _label21:
            cmp_eq ::temp0 actionName "ScheduleMeeting" 
            jmpf ::temp0 _label15
            ; line 1125
            propget ConfirmScheduleMeeting ::StoryEngine_var ::temp4 
            assign mode ::temp4 
            jmp _label15
          _label15:
            jmp _label22
            ; line 1129
          _label13:
            callstatic game GetPlayer ::temp5 ;0 variable args
            cast ::temp6 ::temp5 
            callstatic storageUtil GetIntValue ::temp4 ::temp6 "Intel_TaskConfirmPrompt" 0 ;3 variable args
            assign mode ::temp4 
            ; line 1130
            cmp_eq ::temp0 mode 1 
            jmpf ::temp0 _label22
            ; line 1131
            assign mode 2 
            jmp _label22
            ; line 1135
          _label22:
            cmp_eq ::temp0 mode 0 
            jmpf ::temp0 _label23
            ; line 1136
            return 0 
            jmp _label23
            ; line 1139
          _label23:
            cmp_eq ::temp0 mode 1 
            jmpf ::temp0 _label24
            ; line 1141
            callmethod IsPlayerTeammate npc ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label25
            ; line 1142
            return 0 
            jmp _label25
          _label25:
            jmp _label24
            ; line 1147
          _label24:
            callstatic skyMessage Show ::temp3 promptText "Allow" "Deny" "Deny (Silent)" "" "" "" "" "" "" "" False 0.100000001 0.0 ;14 variable args
            assign result ::temp3 
            ; line 1148
            cmp_eq ::temp0 result "Deny" 
            jmpf ::temp0 _label26
            ; line 1149
            return 1 
            jmp _label27
            ; line 1150
          _label26:
            cmp_eq ::temp0 result "Allow" 
            jmpf ::temp0 _label27
            ; line 1151
            return 0 
            jmp _label27
            ; line 1153
          _label27:
            return 2 
          .endCode
        .endFunction ;ShowTaskConfirmationForAction
        .function DetermineLatenessOutcome
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
            .param actualGameTime Float
            .param deadlineGameTime Float
          .endParamTable
          .localTable
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 1158
            callstatic intelEngine DetermineLatenessOutcome ::temp0 deadlineGameTime actualGameTime ::MeetingGracePeriod_var ;3 variable args
            return ::temp0 
          .endCode
        .endFunction ;DetermineLatenessOutcome
        .function InitializeStuckTrackingForSlot
           ; function type 0
          .userFlags 0 ;none
          .docString "Reset C++ StuckDetector and record task start time."
          .return None
          .paramTable
            .param slot Int
            .param npc actor
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 form
            .local ::temp1 Float
          .endLocalTable
          .code
            ; line 1163
            callstatic intelEngine ResetStuckSlot ::nonevar slot npc ;2 variable args
            ; line 1164
            cast ::temp0 npc 
            callstatic utility GetCurrentGameTime ::temp1 ;0 variable args
            callstatic storageUtil SetFloatValue ::temp1 ::temp0 "Intel_TaskStartTime" ::temp1 ;3 variable args
          .endCode
        .endFunction ;InitializeStuckTrackingForSlot
        .function InitializeDepartureTracking
           ; function type 0
          .userFlags 0 ;none
          .docString "Reset departure tracking for a slot via C++ DepartureDetector.
    Stores NPC's current XY position as baseline. All position math
    and tick counting happens in native code — no StorageUtil overhead."
          .return None
          .paramTable
            .param slot Int
            .param npc actor
          .endParamTable
          .localTable
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1171
            callstatic intelEngine ResetDepartureSlot ::nonevar slot npc ;2 variable args
          .endCode
        .endFunction ;InitializeDepartureTracking
        .function InitOffScreenTracking
           ; function type 0
          .userFlags 0 ;none
          .docString "Calculate estimated arrival time from distance and initialize C++ tracker.
    Shared by Travel, NPCTasks, and any future task that involves traveling.
    Uses CalculateDeadlineFromDistance for consistent speed estimation."
          .return None
          .paramTable
            .param slot Int
            .param npc actor
            .param dest objectReference
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 objectReference
            .local estimatedArrival Float
            .local ::temp3 Float
            .local ::nonevar None
            .local ::temp4 form
            .local ::temp5 String
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 1178
            cast ::temp0 None 
            cmp_eq ::temp1 npc ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cast ::temp2 None 
            cmp_eq ::temp1 dest ::temp2 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 1179
            return None 
            jmp _label1
            ; line 1181
          _label1:
            cast ::temp2 npc 
            callstatic intelEngine CalculateDeadlineFromDistance ::temp3 ::temp2 dest False 0.5 18.0 ;5 variable args
            assign estimatedArrival ::temp3 
            ; line 1182
            callstatic intelEngine InitOffScreenTravel ::nonevar slot estimatedArrival npc ;3 variable args
            ; line 1183
            callstatic intelEngine SetSlotOffscreenArrival ::nonevar slot estimatedArrival ;2 variable args
            ; line 1184
            cast ::temp4 npc 
            callstatic storageUtil SetFloatValue ::temp3 ::temp4 "Intel_OffscreenArrival" estimatedArrival ;3 variable args
            ; line 1185
            callmethod GetDisplayName npc ::temp5 ;0 variable args
            strcat ::temp5 ::temp5 " off-screen tracking: est. arrival in " 
            callstatic utility GetCurrentGameTime ::temp3 ;0 variable args
            fsub ::temp3 estimatedArrival ::temp3 
            fmul ::temp3 ::temp3 24.0 
            cast ::temp6 ::temp3 
            strcat ::temp6 ::temp5 ::temp6 
            strcat ::temp6 ::temp6 "h" 
            callmethod DebugMsg self ::nonevar ::temp6 ;1 variable args
          .endCode
        .endFunction ;InitOffScreenTracking
        .function UnlockHomeForTask
           ; function type 0
          .userFlags 0 ;none
          .docString "Anti-trespass: unlock target NPC's home door so agent can enter.
    Stores cell ID on agent for re-locking in ClearSlot.
    Shared by FetchNPC, DeliverMessage, SearchForActor — all have an Actor target.
    Travel uses SetHomeDoorAccessForCell directly (has cell ID from ResolveAnyDestination)."
          .return None
          .paramTable
            .param akAgent actor
            .param targetNPC actor
          .endParamTable
          .localTable
            .local homeDoor objectReference
            .local ::temp0 objectReference
            .local ::temp1 Bool
            .local homeCellId Int
            .local ::temp2 Int
            .local ::temp3 form
            .local ::nonevar None
            .local ::temp4 String
          .endLocalTable
          .code
            ; line 1193
            callstatic intelEngine SetHomeDoorAccess ::temp0 targetNPC True ;2 variable args
            assign homeDoor ::temp0 
            ; line 1194
            cast ::temp0 None 
            cmp_eq ::temp1 homeDoor ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label0
            ; line 1195
            callstatic intelEngine GetLastResolvedHomeCellId ::temp2 ;0 variable args
            assign homeCellId ::temp2 
            ; line 1196
            cmp_eq ::temp1 homeCellId 0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label1
            ; line 1197
            cast ::temp3 akAgent 
            callstatic storageUtil SetIntValue ::temp2 ::temp3 "Intel_UnlockedHomeCellId" homeCellId ;3 variable args
            jmp _label1
            ; line 1199
          _label1:
            callmethod GetDisplayName targetNPC ::temp4 ;0 variable args
            strcat ::temp4 "Unlocked " ::temp4 
            strcat ::temp4 ::temp4 "'s home door for task" 
            callmethod DebugMsg self ::nonevar ::temp4 ;1 variable args
            jmp _label0
          _label0
          .endCode
        .endFunction ;UnlockHomeForTask
        .function EnsureBuildingAccess
           ; function type 0
          .userFlags 0 ;none
          .docString "Single source of truth: if NPC is inside an interior cell, unlock the door
    and remove trespass so the player can enter. Called at all arrival points
    (Travel, StoryEngine, NPC Social). ClearSlot re-locks via Intel_UnlockedHomeCellId."
          .return None
          .paramTable
            .param npc actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local npcCell cell
            .local ::temp2 cell
            .local cellId Int
            .local ::temp3 Int
            .local existingCellId Int
            .local ::temp4 form
            .local ::temp5 objectReference
            .local ::nonevar None
            .local ::temp6 String
            .local ::temp7 String
          .endLocalTable
          .code
            ; line 1207
            cast ::temp0 None 
            cmp_eq ::temp1 npc ::temp0 
            jmpf ::temp1 _label0
            ; line 1208
            return None 
            jmp _label0
            ; line 1210
          _label0:
            callmethod GetParentCell npc ::temp2 ;0 variable args
            assign npcCell ::temp2 
            ; line 1211
            cast ::temp2 None 
            cmp_eq ::temp1 npcCell ::temp2 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            callmethod IsInterior npcCell ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 1212
            return None 
            jmp _label2
            ; line 1214
          _label2:
            callmethod GetFormID npcCell ::temp3 ;0 variable args
            assign cellId ::temp3 
            ; line 1215
            cmp_eq ::temp1 cellId 0 
            jmpf ::temp1 _label3
            ; line 1216
            return None 
            jmp _label3
            ; line 1219
          _label3:
            cast ::temp4 npc 
            callstatic storageUtil GetIntValue ::temp3 ::temp4 "Intel_UnlockedHomeCellId" 0 ;3 variable args
            assign existingCellId ::temp3 
            ; line 1220
            cmp_eq ::temp1 existingCellId cellId 
            jmpf ::temp1 _label4
            ; line 1221
            return None 
            jmp _label4
            ; line 1225
          _label4:
            callstatic intelEngine SetHomeDoorAccessForCell ::temp5 cellId True ;2 variable args
            ; line 1226
            cast ::temp4 npc 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "Intel_UnlockedHomeCellId" cellId ;3 variable args
            ; line 1227
            cast ::temp6 cellId 
            strcat ::temp6 "Building access: unlocked cell " ::temp6 
            strcat ::temp6 ::temp6 " for " 
            callmethod GetDisplayName npc ::temp7 ;0 variable args
            strcat ::temp7 ::temp6 ::temp7 
            callmethod DebugMsg self ::nonevar ::temp7 ;1 variable args
          .endCode
        .endFunction ;EnsureBuildingAccess
        .function HandleOffScreenTravel
           ; function type 0
          .userFlags 0 ;none
          .docString "Check if off-screen NPC should be teleported to destination.
    Returns true if teleported (caller should handle arrival).
    Returns false if still in transit (do nothing)."
          .return Bool
          .paramTable
            .param slot Int
            .param npc actor
            .param dest objectReference
          .endParamTable
          .localTable
            .local status Int
            .local ::temp0 Float
            .local ::temp1 Int
            .local ::temp2 Bool
            .local ::nonevar None
            .local ::temp3 String
          .endLocalTable
          .code
            ; line 1234
            callstatic utility GetCurrentGameTime ::temp0 ;0 variable args
            callstatic intelEngine CheckOffScreenProgress ::temp1 slot npc ::temp0 ;3 variable args
            assign status ::temp1 
            ; line 1235
            cmp_eq ::temp2 status 1 
            jmpf ::temp2 _label0
            ; line 1236
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 ::temp3 " off-screen arrival (estimated time elapsed)" 
            callmethod DebugMsg self ::nonevar ::temp3 ;1 variable args
            ; line 1237
            callmethod MoveTo npc ::nonevar dest 0.0 0.0 0.0 True ;5 variable args
            ; line 1238
            callstatic utility Wait ::nonevar 0.300000012 ;1 variable args
            ; line 1239
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 1240
            return True 
            jmp _label0
            ; line 1242
          _label0:
            return False 
          .endCode
        .endFunction ;HandleOffScreenTravel
        .function SoftStuckRecovery
           ; function type 0
          .userFlags 0 ;none
          .docString "Soft stuck recovery: random displacement + re-apply travel + pathfinding nudge.
    Shared by Travel and NPCTasks stuck handlers."
          .return None
          .paramTable
            .param npc actor
            .param slot Int
            .param dest objectReference
          .endParamTable
          .localTable
            .local nudge Float
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 objectReference
            .local ::temp2 Float
            .local ::temp3 Float
            .local speed Int
            .local ::temp4 Int
            .local travelPkg package
            .local ::temp5 package
          .endLocalTable
          .code
            ; line 1248
            assign nudge 100.0 
            ; line 1249
            callmethod Is3DLoaded npc ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 1250
            assign nudge 200.0 
            jmp _label0
            ; line 1252
          _label0:
            cast ::temp1 npc 
            fneg ::temp2 nudge 
            callstatic utility RandomFloat ::temp2 ::temp2 nudge ;2 variable args
            fneg ::temp3 nudge 
            callstatic utility RandomFloat ::temp3 ::temp3 nudge ;2 variable args
            callmethod MoveTo npc ::nonevar ::temp1 ::temp2 ::temp3 50.0 False ;5 variable args
            ; line 1254
            array_getlement ::temp4 ::SlotSpeeds_var slot 
            assign speed ::temp4 
            ; line 1255
            callmethod GetTravelPackage self ::temp5 speed ;1 variable args
            assign travelPkg ::temp5 
            ; line 1256
            cast ::temp0 travelPkg 
            jmpf ::temp0 _label1
            ; line 1257
            propget PRIORITY_TRAVEL self ::temp4 
            callstatic actorUtil AddPackageOverride ::nonevar npc travelPkg ::temp4 1 ;4 variable args
            jmp _label1
            ; line 1259
          _label1:
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 1261
            cast ::temp1 None 
            cmp_eq ::temp0 dest ::temp1 
            not ::temp0 ::temp0 
            jmpf ::temp0 _label2
            ; line 1262
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 1263
            callmethod PathToReference npc ::temp0 dest 1.0 ;2 variable args
            ; line 1264
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            jmp _label2
          _label2
          .endCode
        .endFunction ;SoftStuckRecovery
        .function RemoveAllPackages
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param akActor actor
            .param evaluate Bool
          .endParamTable
          .localTable
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1274
            callmethod RemoveIntelPackages self ::nonevar akActor evaluate ;2 variable args
          .endCode
        .endFunction ;RemoveAllPackages
        .function RemoveIntelPackages
           ; function type 0
          .userFlags 0 ;none
          .docString "Remove only IntelEngine package overrides, preserving packages from other
    mods (SkyrimNet FollowPlayer, SeverAction, etc.). Use this for target NPCs
    that IntelEngine doesn't fully own via a task slot.
    Pass evaluate=false when adding a new package immediately after."
          .return None
          .paramTable
            .param akActor actor
            .param evaluate Bool
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1282
            callstatic actorUtil RemovePackageOverride ::temp0 akActor ::TravelPackage_Walk_var ;2 variable args
            ; line 1283
            callstatic actorUtil RemovePackageOverride ::temp0 akActor ::TravelPackage_Jog_var ;2 variable args
            ; line 1284
            callstatic actorUtil RemovePackageOverride ::temp0 akActor ::TravelPackage_Run_var ;2 variable args
            ; line 1285
            cast ::temp0 ::TravelPackage_Stalk_var 
            jmpf ::temp0 _label0
            ; line 1286
            callstatic actorUtil RemovePackageOverride ::temp0 akActor ::TravelPackage_Stalk_var ;2 variable args
            jmp _label0
            ; line 1288
          _label0:
            cast ::temp0 ::SandboxPackage_var 
            jmpf ::temp0 _label1
            ; line 1289
            callstatic actorUtil RemovePackageOverride ::temp0 akActor ::SandboxPackage_var ;2 variable args
            jmp _label1
            ; line 1291
          _label1:
            cast ::temp0 ::SandboxNearPlayerPackage_var 
            jmpf ::temp0 _label2
            ; line 1292
            callstatic actorUtil RemovePackageOverride ::temp0 akActor ::SandboxNearPlayerPackage_var ;2 variable args
            jmp _label2
            ; line 1294
          _label2:
            jmpf evaluate _label3
            ; line 1295
            callmethod EvaluatePackage akActor ::nonevar ;0 variable args
            jmp _label3
          _label3
          .endCode
        .endFunction ;RemoveIntelPackages
        .function ClearLinkedRefs
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
            .local ::temp1 objectReference
            .local ::temp2 objectReference
          .endLocalTable
          .code
            ; line 1300
            cast ::temp0 ::IntelEngine_TravelTarget_var 
            jmpf ::temp0 _label0
            ; line 1301
            cast ::temp1 akActor 
            cast ::temp2 None 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp1 ::temp2 ::IntelEngine_TravelTarget_var ;3 variable args
            jmp _label0
            ; line 1303
          _label0:
            cast ::temp0 ::IntelEngine_EscortTarget_var 
            jmpf ::temp0 _label1
            ; line 1304
            cast ::temp2 akActor 
            cast ::temp1 None 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp2 ::temp1 ::IntelEngine_EscortTarget_var ;3 variable args
            jmp _label1
            ; line 1306
          _label1:
            cast ::temp0 ::IntelEngine_AgentLink_var 
            jmpf ::temp0 _label2
            ; line 1307
            cast ::temp1 akActor 
            cast ::temp2 None 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp1 ::temp2 ::IntelEngine_AgentLink_var ;3 variable args
            jmp _label2
            ; line 1309
          _label2:
            cast ::temp0 ::IntelEngine_WaitLocation_var 
            jmpf ::temp0 _label3
            ; line 1310
            cast ::temp2 akActor 
            cast ::temp1 None 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp2 ::temp1 ::IntelEngine_WaitLocation_var ;3 variable args
            jmp _label3
          _label3
          .endCode
        .endFunction ;ClearLinkedRefs
        .function TeleportBehindPlayer
           ; function type 0
          .userFlags 0 ;none
          .docString "Teleport an NPC behind the player's camera so they don't pop into view.
    Used by stuck recovery fallbacks in Travel and NPCTasks.
    Distance can be reduced on retry if the NPC lands behind a wall."
          .return None
          .paramTable
            .param npc actor
            .param distance Float
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local offset Float[]
            .local ::temp1 objectReference
            .local ::temp2 Float[]
            .local ::nonevar None
            .local ::temp3 Float
            .local ::temp4 Float
            .local ::temp5 String
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 1318
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1319
            cast ::temp1 player 
            callstatic intelEngine GetOffsetBehind ::temp2 ::temp1 distance ;2 variable args
            assign offset ::temp2 
            ; line 1320
            cast ::temp1 player 
            array_getlement ::temp3 offset 0 
            array_getlement ::temp4 offset 1 
            callmethod MoveTo npc ::nonevar ::temp1 ::temp3 ::temp4 0.0 False ;5 variable args
            ; line 1321
            callmethod GetDisplayName npc ::temp5 ;0 variable args
            strcat ::temp5 ::temp5 " teleported behind player at " 
            cast ::temp6 distance 
            strcat ::temp6 ::temp5 ::temp6 
            strcat ::temp6 ::temp6 " units" 
            callmethod DebugMsg self ::nonevar ::temp6 ;1 variable args
          .endCode
        .endFunction ;TeleportBehindPlayer
        .function CheckDepartureProgress
           ; function type 0
          .userFlags 0 ;none
          .docString "Check if an NPC has departed from their starting position.
    Position tracking and tick counting done in C++ DepartureDetector.
    Returns: 0=too early, 1=departed, 2=soft recovery applied, 3=escalate."
          .return Int
          .paramTable
            .param slot Int
            .param agent actor
            .param threshold Float
          .endParamTable
          .localTable
            .local status Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 String
            .local dest objectReference
            .local ::temp3 form
            .local ::temp4 form
            .local ::temp5 objectReference
          .endLocalTable
          .code
            ; line 1339
            callstatic intelEngine CheckDepartureStatus ::temp0 agent slot threshold ;3 variable args
            assign status ::temp0 
            ; line 1341
            cmp_eq ::temp1 status 2 
            jmpf ::temp1 _label0
            ; line 1343
            callmethod GetDisplayName agent ::temp2 ;0 variable args
            strcat ::temp2 ::temp2 " hasn't departed — nudging package evaluation" 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            ; line 1344
            callmethod EvaluatePackage agent ::nonevar ;0 variable args
            ; line 1346
            cast ::temp3 agent 
            cast ::temp4 None 
            callstatic storageUtil GetFormValue ::temp4 ::temp3 "Intel_DestMarker" ::temp4 ;3 variable args
            cast ::temp5 ::temp4 
            assign dest ::temp5 
            ; line 1347
            cast ::temp5 None 
            cmp_eq ::temp1 dest ::temp5 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label1
            ; line 1348
            callmethod PathToReference agent ::temp1 dest 1.0 ;2 variable args
            ; line 1349
            callmethod EvaluatePackage agent ::nonevar ;0 variable args
            jmp _label1
          _label1:
            jmp _label0
            ; line 1353
          _label0:
            return status 
          .endCode
        .endFunction ;CheckDepartureProgress
        .function RecoverActiveTasks
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local i Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local slotAlias referenceAlias
            .local ::temp2 referenceAlias
            .local agent actor
            .local ::temp3 actor
            .local taskType String
            .local ::temp4 form
            .local ::temp5 String
            .local savedState Int
            .local target String
            .local speed Int
            .local savedDeadline Float
            .local ::temp6 Float
            .local ::temp7 Float
            .local offscreenArrival Float
          .endLocalTable
          .code
            ; line 1361
            callmethod DebugMsg self ::nonevar "Recovering active tasks..." ;1 variable args
            ; line 1363
            assign i 0 
            ; line 1364
          _label10:
            propget MAX_SLOTS self ::temp0 
            cmp_lt ::temp1 i ::temp0 
            jmpf ::temp1 _label0
            ; line 1365
            callmethod GetAgentAlias self ::temp2 i ;1 variable args
            assign slotAlias ::temp2 
            ; line 1366
            cast ::temp1 slotAlias 
            jmpf ::temp1 _label1
            ; line 1367
            callmethod GetActorReference slotAlias ::temp3 ;0 variable args
            assign agent ::temp3 
            ; line 1368
            cast ::temp1 agent 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label2
            callmethod IsDead agent ::temp1 ;0 variable args
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
          _label2:
            jmpf ::temp1 _label3
            ; line 1370
            cast ::temp4 agent 
            callstatic storageUtil GetStringValue ::temp5 ::temp4 "Intel_TaskType" "" ;3 variable args
            assign taskType ::temp5 
            ; line 1371
            cmp_eq ::temp1 taskType "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label4
            ; line 1372
            cast ::temp4 agent 
            callstatic storageUtil GetIntValue ::temp0 ::temp4 "Intel_State" 0 ;3 variable args
            assign savedState ::temp0 
            ; line 1373
            cast ::temp4 agent 
            callstatic storageUtil GetStringValue ::temp5 ::temp4 "Intel_Target" "" ;3 variable args
            assign target ::temp5 
            ; line 1374
            cast ::temp4 agent 
            callstatic storageUtil GetIntValue ::temp0 ::temp4 "Intel_Speed" 0 ;3 variable args
            assign speed ::temp0 
            ; line 1376
            array_setelement ::SlotStates_var i savedState 
            ; line 1377
            array_setelement ::SlotTaskTypes_var i taskType 
            ; line 1378
            array_setelement ::SlotTargetNames_var i target 
            ; line 1379
            array_setelement ::SlotSpeeds_var i speed 
            ; line 1383
            cast ::temp4 agent 
            callstatic storageUtil GetFloatValue ::temp6 ::temp4 "Intel_Deadline" 0.0 ;3 variable args
            assign savedDeadline ::temp6 
            ; line 1384
            cmp_gt ::temp1 savedDeadline 0.0 
            jmpf ::temp1 _label5
            ; line 1385
            array_setelement ::SlotDeadlines_var i savedDeadline 
            jmp _label6
            ; line 1388
          _label5:
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            fdiv ::temp7 6.0 24.0 
            fadd ::temp7 ::temp6 ::temp7 
            array_setelement ::SlotDeadlines_var i ::temp7 
            ; line 1389
            cast ::temp5 i 
            strcat ::temp5 "No saved deadline for slot " ::temp5 
            strcat ::temp5 ::temp5 " — set fallback 6h from now" 
            callmethod DebugMsg self ::nonevar ::temp5 ;1 variable args
            ; line 1393
          _label6:
            cast ::temp4 agent 
            callstatic storageUtil GetFloatValue ::temp7 ::temp4 "Intel_OffscreenArrival" 0.0 ;3 variable args
            assign offscreenArrival ::temp7 
            ; line 1394
            cmp_gt ::temp1 offscreenArrival 0.0 
            jmpf ::temp1 _label7
            ; line 1395
            callstatic intelEngine InitOffScreenTravel ::nonevar i offscreenArrival agent ;3 variable args
            jmp _label7
            ; line 1398
          _label7:
            cast ::temp5 i 
            strcat ::temp5 "Recovered task in slot " ::temp5 
            strcat ::temp5 ::temp5 ": " 
            strcat ::temp5 ::temp5 taskType 
            strcat ::temp5 ::temp5 " → " 
            strcat ::temp5 ::temp5 target 
            callmethod DebugMsg self ::nonevar ::temp5 ;1 variable args
            jmp _label8
            ; line 1401
          _label4:
            callmethod ClearSlot self ::nonevar i True False ;3 variable args
          _label8:
            jmp _label9
            ; line 1405
          _label3:
            callmethod ClearSlot self ::nonevar i True False ;3 variable args
          _label9:
            jmp _label1
            ; line 1408
          _label1:
            iadd ::temp0 i 1 
            assign i ::temp0 
            jmp _label10
            ; line 1415
          _label0:
            callmethod SyncSlotTrackerFromArrays self ::nonevar ;0 variable args
          .endCode
        .endFunction ;RecoverActiveTasks
        .function SyncSlotTrackerFromArrays
           ; function type 0
          .userFlags 0 ;none
          .docString "Push current Papyrus slot state to C++ SlotTracker per-slot.
    Called after RecoverActiveTasks (legacy StorageUtil path) to re-sync on game load."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local i Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local slotAlias referenceAlias
            .local ::temp2 referenceAlias
            .local agent actor
            .local ::temp3 actor
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 String
            .local ::temp6 Float
          .endLocalTable
          .code
            ; line 1421
            assign i 0 
            ; line 1422
          _label5:
            propget MAX_SLOTS self ::temp0 
            cmp_lt ::temp1 i ::temp0 
            jmpf ::temp1 _label0
            ; line 1423
            array_getlement ::temp0 ::SlotStates_var i 
            cmp_eq ::temp1 ::temp0 0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label1
            ; line 1424
            callmethod GetAgentAlias self ::temp2 i ;1 variable args
            assign slotAlias ::temp2 
            ; line 1425
            cast ::temp1 slotAlias 
            jmpf ::temp1 _label2
            ; line 1426
            callmethod GetActorReference slotAlias ::temp3 ;0 variable args
            assign agent ::temp3 
            ; line 1427
            cast ::temp1 agent 
            jmpf ::temp1 _label3
            ; line 1428
            array_getlement ::temp0 ::SlotStates_var i 
            array_getlement ::temp4 ::SlotTaskTypes_var i 
            array_getlement ::temp5 ::SlotTargetNames_var i 
            callstatic intelEngine UpdateSlotState ::nonevar i agent ::temp0 ::temp4 ::temp5 ;5 variable args
            ; line 1429
            array_getlement ::temp0 ::SlotSpeeds_var i 
            callstatic intelEngine SetSlotSpeed ::nonevar i ::temp0 ;2 variable args
            ; line 1430
            array_getlement ::temp6 ::SlotDeadlines_var i 
            callstatic intelEngine SetSlotDeadline ::nonevar i ::temp6 ;2 variable args
            jmp _label3
          _label3:
            jmp _label2
          _label2:
            jmp _label4
            ; line 1434
          _label1:
            callstatic intelEngine ClearSlotState ::nonevar i ;1 variable args
            ; line 1436
          _label4:
            iadd ::temp0 i 1 
            assign i ::temp0 
            jmp _label5
            ; line 1438
          _label0:
            callmethod DebugMsg self ::nonevar "C++ SlotTracker synced from Papyrus arrays" ;1 variable args
          .endCode
        .endFunction ;SyncSlotTrackerFromArrays
        .function GetTravelPackage
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return package
          .paramTable
            .param speed Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 1450
            cmp_eq ::temp0 speed 2 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label0
            cast ::temp0 ::TravelPackage_Run_var 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 1451
            return ::TravelPackage_Run_var 
            jmp _label2
            ; line 1452
          _label1:
            cmp_eq ::temp0 speed 1 
            assign ::temp0 ::temp0 
            jmpf ::temp0 _label3
            cast ::temp0 ::TravelPackage_Jog_var 
            assign ::temp0 ::temp0 
          _label3:
            jmpf ::temp0 _label4
            ; line 1453
            return ::TravelPackage_Jog_var 
            jmp _label2
            ; line 1454
          _label4:
            cast ::temp0 ::TravelPackage_Walk_var 
            jmpf ::temp0 _label2
            ; line 1455
            return ::TravelPackage_Walk_var 
            jmp _label2
            ; line 1457
          _label2:
            return ::TravelPackage_Walk_var 
          .endCode
        .endFunction ;GetTravelPackage
        .function SendTaskNarration
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param akActor actor
            .param msgText String
            .param akTarget actor
          .endParamTable
          .localTable
            .local ::temp0 Int
          .endLocalTable
          .code
            ; line 1467
            callstatic skyrimNetApi DirectNarration ::temp0 msgText akActor akTarget ;3 variable args
          .endCode
        .endFunction ;SendTaskNarration
        .function SendPersistentMemory
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param akOriginator actor
            .param akTarget actor
            .param msgText String
          .endParamTable
          .localTable
            .local ::temp0 Int
          .endLocalTable
          .code
            ; line 1474
            callstatic skyrimNetApi RegisterPersistentEvent ::temp0 msgText akOriginator akTarget ;3 variable args
          .endCode
        .endFunction ;SendPersistentMemory
        .function SendTransientEvent
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param akOriginator actor
            .param akTarget actor
            .param msgText String
          .endParamTable
          .localTable
            .local ::temp0 Int
          .endLocalTable
          .code
            ; line 1481
            callstatic skyrimNetApi RegisterEvent ::temp0 "intel_task_event" msgText akOriginator akTarget ;4 variable args
          .endCode
        .endFunction ;SendTransientEvent
        .function InjectFact
           ; function type 0
          .userFlags 0 ;none
          .docString "Inject a narrative fact into an NPC's bio context. Pure FIFO: oldest
    facts are evicted when the cap is reached, no time-based expiry.
    factText: Past-tense verb phrase WITHOUT subject prefix,
    e.g., "got into a brawl with Uthgerd near the market""
          .return None
          .paramTable
            .param akNPC actor
            .param factText String
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local currentTime Float
            .local ::temp2 Float
            .local count Int
            .local ::temp3 form
            .local ::temp4 Int
            .local factsArr String[]
            .local ::temp5 String[]
            .local timesArr Float[]
            .local ::temp6 Float[]
            .local rendered String
            .local ::temp7 String
            .local player actor
            .local formId Int
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1496
            cast ::temp0 None 
            cmp_eq ::temp1 akNPC ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cmp_eq ::temp1 factText "" 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 1497
            return None 
            jmp _label1
            ; line 1500
          _label1:
            callstatic utility GetCurrentGameTime ::temp2 ;0 variable args
            assign currentTime ::temp2 
            ; line 1503
            cast ::temp3 akNPC 
            callstatic storageUtil StringListCount ::temp4 ::temp3 "Intel_Facts" ;2 variable args
            assign count ::temp4 
            ; line 1504
          _label3:
            comp_gte ::temp1 count 10 
            jmpf ::temp1 _label2
            ; line 1505
            cast ::temp3 akNPC 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp3 "Intel_Facts" 0 ;3 variable args
            ; line 1506
            cast ::temp3 akNPC 
            callstatic storageUtil FloatListRemoveAt ::temp1 ::temp3 "Intel_FactTimes" 0 ;3 variable args
            ; line 1507
            isub ::temp4 count 1 
            assign count ::temp4 
            jmp _label3
            ; line 1510
          _label2:
            cast ::temp3 akNPC 
            callstatic storageUtil StringListAdd ::temp4 ::temp3 "Intel_Facts" factText True ;4 variable args
            ; line 1511
            cast ::temp3 akNPC 
            callstatic storageUtil FloatListAdd ::temp4 ::temp3 "Intel_FactTimes" currentTime True ;4 variable args
            ; line 1516
            cast ::temp3 akNPC 
            callstatic storageUtil StringListToArray ::temp5 ::temp3 "Intel_Facts" ;2 variable args
            assign factsArr ::temp5 
            ; line 1517
            cast ::temp3 akNPC 
            callstatic storageUtil FloatListToArray ::temp6 ::temp3 "Intel_FactTimes" ;2 variable args
            assign timesArr ::temp6 
            ; line 1518
            callstatic intelEngine RenderFactsSection ::temp7 factsArr timesArr currentTime ;3 variable args
            assign rendered ::temp7 
            ; line 1519
            cast ::temp3 akNPC 
            callstatic storageUtil SetStringValue ::temp7 ::temp3 "Intel_FactsRendered" rendered ;3 variable args
            ; line 1522
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1523
            callmethod GetFormID akNPC ::temp4 ;0 variable args
            assign formId ::temp4 
            ; line 1524
            cast ::temp3 player 
            callstatic storageUtil IntListFind ::temp4 ::temp3 "Intel_FactNPCs" formId ;3 variable args
            cmp_lt ::temp1 ::temp4 0 
            jmpf ::temp1 _label4
            ; line 1525
            cast ::temp3 player 
            callstatic storageUtil IntListAdd ::temp4 ::temp3 "Intel_FactNPCs" formId True ;4 variable args
            jmp _label4
            ; line 1528
          _label4:
            callmethod GetDisplayName akNPC ::temp7 ;0 variable args
            strcat ::temp7 "Fact injected into " ::temp7 
            strcat ::temp7 ::temp7 ": " 
            strcat ::temp7 ::temp7 factText 
            callmethod DebugMsg self ::nonevar ::temp7 ;1 variable args
          .endCode
        .endFunction ;InjectFact
        .function InjectGossip
           ; function type 0
          .userFlags 0 ;none
          .docString "Inject a gossip rumor between two NPCs.
    gossipText: Past-tense verb phrase, e.g., "heard that the Jarl is raising taxes"
    Both NPCs track who told/received the gossip (5-entry rolling cap).
    Renders in "Rumors I've Heard" bio section, separate from personal facts."
          .return None
          .paramTable
            .param akGiver actor
            .param akReceiver actor
            .param gossipText String
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local currentTime Float
            .local ::temp2 Float
            .local giverName String
            .local ::temp3 String
            .local receiverName String
            .local heardCount Int
            .local ::temp4 form
            .local ::temp5 Int
            .local toldCount Int
            .local heardTexts String[]
            .local ::temp6 String[]
            .local heardFrom String[]
            .local heardTimes Float[]
            .local ::temp7 Float[]
            .local heardRendered String
            .local recvToldTexts String[]
            .local recvToldTo String[]
            .local recvToldTimes Float[]
            .local recvToldRendered String
            .local giverToldTexts String[]
            .local giverToldTo String[]
            .local giverToldTimes Float[]
            .local giverToldRendered String
            .local giverHeardTexts String[]
            .local giverHeardFrom String[]
            .local giverHeardTimes Float[]
            .local giverHeardRendered String
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1542
            cast ::temp0 None 
            cmp_eq ::temp1 akGiver ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cast ::temp0 None 
            cmp_eq ::temp1 akReceiver ::temp0 
            assign ::temp1 ::temp1 
          _label0:
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label1
            cmp_eq ::temp1 gossipText "" 
            assign ::temp1 ::temp1 
          _label1:
            jmpf ::temp1 _label2
            ; line 1543
            return None 
            jmp _label2
            ; line 1546
          _label2:
            callstatic utility GetCurrentGameTime ::temp2 ;0 variable args
            assign currentTime ::temp2 
            ; line 1547
            callmethod GetDisplayName akGiver ::temp3 ;0 variable args
            assign giverName ::temp3 
            ; line 1548
            callmethod GetDisplayName akReceiver ::temp3 ;0 variable args
            assign receiverName ::temp3 
            ; line 1551
            cast ::temp4 akReceiver 
            callstatic storageUtil StringListCount ::temp5 ::temp4 "Intel_GossipHeard" ;2 variable args
            assign heardCount ::temp5 
            ; line 1552
          _label4:
            comp_gte ::temp1 heardCount 5 
            jmpf ::temp1 _label3
            ; line 1553
            cast ::temp4 akReceiver 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp4 "Intel_GossipHeard" 0 ;3 variable args
            ; line 1554
            cast ::temp4 akReceiver 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp4 "Intel_GossipHeardFrom" 0 ;3 variable args
            ; line 1555
            cast ::temp4 akReceiver 
            callstatic storageUtil FloatListRemoveAt ::temp1 ::temp4 "Intel_GossipHeardTimes" 0 ;3 variable args
            ; line 1556
            isub ::temp5 heardCount 1 
            assign heardCount ::temp5 
            jmp _label4
            ; line 1558
          _label3:
            cast ::temp4 akReceiver 
            callstatic storageUtil StringListAdd ::temp5 ::temp4 "Intel_GossipHeard" gossipText True ;4 variable args
            ; line 1559
            cast ::temp4 akReceiver 
            callstatic storageUtil StringListAdd ::temp5 ::temp4 "Intel_GossipHeardFrom" giverName True ;4 variable args
            ; line 1560
            cast ::temp4 akReceiver 
            callstatic storageUtil FloatListAdd ::temp5 ::temp4 "Intel_GossipHeardTimes" currentTime True ;4 variable args
            ; line 1563
            cast ::temp4 akGiver 
            callstatic storageUtil StringListCount ::temp5 ::temp4 "Intel_GossipTold" ;2 variable args
            assign toldCount ::temp5 
            ; line 1564
          _label6:
            comp_gte ::temp1 toldCount 5 
            jmpf ::temp1 _label5
            ; line 1565
            cast ::temp4 akGiver 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp4 "Intel_GossipTold" 0 ;3 variable args
            ; line 1566
            cast ::temp4 akGiver 
            callstatic storageUtil StringListRemoveAt ::temp1 ::temp4 "Intel_GossipToldTo" 0 ;3 variable args
            ; line 1567
            cast ::temp4 akGiver 
            callstatic storageUtil FloatListRemoveAt ::temp1 ::temp4 "Intel_GossipToldTimes" 0 ;3 variable args
            ; line 1568
            isub ::temp5 toldCount 1 
            assign toldCount ::temp5 
            jmp _label6
            ; line 1570
          _label5:
            cast ::temp4 akGiver 
            callstatic storageUtil StringListAdd ::temp5 ::temp4 "Intel_GossipTold" gossipText True ;4 variable args
            ; line 1571
            cast ::temp4 akGiver 
            callstatic storageUtil StringListAdd ::temp5 ::temp4 "Intel_GossipToldTo" receiverName True ;4 variable args
            ; line 1572
            cast ::temp4 akGiver 
            callstatic storageUtil FloatListAdd ::temp5 ::temp4 "Intel_GossipToldTimes" currentTime True ;4 variable args
            ; line 1576
            cast ::temp4 akReceiver 
            callstatic storageUtil StringListToArray ::temp6 ::temp4 "Intel_GossipHeard" ;2 variable args
            assign heardTexts ::temp6 
            ; line 1577
            cast ::temp4 akReceiver 
            callstatic storageUtil StringListToArray ::temp6 ::temp4 "Intel_GossipHeardFrom" ;2 variable args
            assign heardFrom ::temp6 
            ; line 1578
            cast ::temp4 akReceiver 
            callstatic storageUtil FloatListToArray ::temp7 ::temp4 "Intel_GossipHeardTimes" ;2 variable args
            assign heardTimes ::temp7 
            ; line 1579
            callstatic intelEngine RenderGossipHeardSection ::temp3 heardTexts heardFrom heardTimes currentTime ;4 variable args
            assign heardRendered ::temp3 
            ; line 1581
            cast ::temp4 akReceiver 
            callstatic storageUtil StringListToArray ::temp6 ::temp4 "Intel_GossipTold" ;2 variable args
            assign recvToldTexts ::temp6 
            ; line 1582
            cast ::temp4 akReceiver 
            callstatic storageUtil StringListToArray ::temp6 ::temp4 "Intel_GossipToldTo" ;2 variable args
            assign recvToldTo ::temp6 
            ; line 1583
            cast ::temp4 akReceiver 
            callstatic storageUtil FloatListToArray ::temp7 ::temp4 "Intel_GossipToldTimes" ;2 variable args
            assign recvToldTimes ::temp7 
            ; line 1584
            callstatic intelEngine RenderGossipToldSection ::temp3 recvToldTexts recvToldTo recvToldTimes currentTime ;4 variable args
            assign recvToldRendered ::temp3 
            ; line 1585
            cast ::temp4 akReceiver 
            strcat ::temp3 heardRendered recvToldRendered 
            callstatic storageUtil SetStringValue ::temp3 ::temp4 "Intel_GossipRendered" ::temp3 ;3 variable args
            ; line 1588
            cast ::temp4 akGiver 
            callstatic storageUtil StringListToArray ::temp6 ::temp4 "Intel_GossipTold" ;2 variable args
            assign giverToldTexts ::temp6 
            ; line 1589
            cast ::temp4 akGiver 
            callstatic storageUtil StringListToArray ::temp6 ::temp4 "Intel_GossipToldTo" ;2 variable args
            assign giverToldTo ::temp6 
            ; line 1590
            cast ::temp4 akGiver 
            callstatic storageUtil FloatListToArray ::temp7 ::temp4 "Intel_GossipToldTimes" ;2 variable args
            assign giverToldTimes ::temp7 
            ; line 1591
            callstatic intelEngine RenderGossipToldSection ::temp3 giverToldTexts giverToldTo giverToldTimes currentTime ;4 variable args
            assign giverToldRendered ::temp3 
            ; line 1593
            cast ::temp4 akGiver 
            callstatic storageUtil StringListToArray ::temp6 ::temp4 "Intel_GossipHeard" ;2 variable args
            assign giverHeardTexts ::temp6 
            ; line 1594
            cast ::temp4 akGiver 
            callstatic storageUtil StringListToArray ::temp6 ::temp4 "Intel_GossipHeardFrom" ;2 variable args
            assign giverHeardFrom ::temp6 
            ; line 1595
            cast ::temp4 akGiver 
            callstatic storageUtil FloatListToArray ::temp7 ::temp4 "Intel_GossipHeardTimes" ;2 variable args
            assign giverHeardTimes ::temp7 
            ; line 1596
            callstatic intelEngine RenderGossipHeardSection ::temp3 giverHeardTexts giverHeardFrom giverHeardTimes currentTime ;4 variable args
            assign giverHeardRendered ::temp3 
            ; line 1597
            cast ::temp4 akGiver 
            strcat ::temp3 giverHeardRendered giverToldRendered 
            callstatic storageUtil SetStringValue ::temp3 ::temp4 "Intel_GossipRendered" ::temp3 ;3 variable args
            ; line 1599
            strcat ::temp3 "Gossip: " giverName 
            strcat ::temp3 ::temp3 " told " 
            strcat ::temp3 ::temp3 receiverName 
            strcat ::temp3 ::temp3 ": " 
            strcat ::temp3 ::temp3 gossipText 
            callmethod DebugMsg self ::nonevar ::temp3 ;1 variable args
          .endCode
        .endFunction ;InjectGossip
        .function CleanExpiredFacts
           ; function type 0
          .userFlags 0 ;none
          .docString "Legacy cleanup: remove Intel_FactExpiry lists from old saves.
    Fact system is now pure FIFO with no time-based expiry."
          .return None
          .paramTable
            .param akNPC actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 form
            .local ::temp3 Int
            .local player actor
            .local formId Int
            .local idx Int
          .endLocalTable
          .code
            ; line 1605
            cast ::temp0 None 
            cmp_eq ::temp1 akNPC ::temp0 
            jmpf ::temp1 _label0
            ; line 1606
            return None 
            jmp _label0
            ; line 1609
          _label0:
            cast ::temp2 akNPC 
            callstatic storageUtil FloatListClear ::temp3 ::temp2 "Intel_FactExpiry" ;2 variable args
            ; line 1612
            cast ::temp2 akNPC 
            callstatic storageUtil StringListCount ::temp3 ::temp2 "Intel_Facts" ;2 variable args
            cmp_eq ::temp1 ::temp3 0 
            jmpf ::temp1 _label1
            ; line 1613
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1614
            callmethod GetFormID akNPC ::temp3 ;0 variable args
            assign formId ::temp3 
            ; line 1615
            cast ::temp2 player 
            callstatic storageUtil IntListFind ::temp3 ::temp2 "Intel_FactNPCs" formId ;3 variable args
            assign idx ::temp3 
            ; line 1616
            comp_gte ::temp1 idx 0 
            jmpf ::temp1 _label2
            ; line 1617
            cast ::temp2 player 
            callstatic storageUtil IntListRemoveAt ::temp1 ::temp2 "Intel_FactNPCs" idx ;3 variable args
            jmp _label2
          _label2:
            jmp _label1
          _label1
          .endCode
        .endFunction ;CleanExpiredFacts
        .function CleanExpiredFactsGlobal
           ; function type 0
          .userFlags 0 ;none
          .docString "Sweep all NPCs with facts and remove expired entries.
    Called from Maintenance() on every game load."
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local count Int
            .local ::temp1 form
            .local ::temp2 Int
            .local i Int
            .local ::temp3 Bool
            .local formId Int
            .local npc actor
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1625
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1626
            cast ::temp1 player 
            callstatic storageUtil IntListCount ::temp2 ::temp1 "Intel_FactNPCs" ;2 variable args
            assign count ::temp2 
            ; line 1627
            isub ::temp2 count 1 
            assign i ::temp2 
            ; line 1628
          _label3:
            comp_gte ::temp3 i 0 
            jmpf ::temp3 _label0
            ; line 1629
            cast ::temp1 player 
            callstatic storageUtil IntListGet ::temp2 ::temp1 "Intel_FactNPCs" i ;3 variable args
            assign formId ::temp2 
            ; line 1630
            callstatic game GetForm ::temp1 formId ;1 variable args
            cast ::temp0 ::temp1 
            assign npc ::temp0 
            ; line 1631
            cast ::temp0 None 
            cmp_eq ::temp3 npc ::temp0 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label1
            ; line 1632
            callmethod CleanExpiredFacts self ::nonevar npc ;1 variable args
            jmp _label2
            ; line 1635
          _label1:
            cast ::temp1 player 
            callstatic storageUtil IntListRemoveAt ::temp3 ::temp1 "Intel_FactNPCs" i ;3 variable args
            ; line 1637
          _label2:
            isub ::temp2 i 1 
            assign i ::temp2 
            jmp _label3
          _label0
          .endCode
        .endFunction ;CleanExpiredFactsGlobal
        .function NotifyPlayer
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param msgText String
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 1642
            callstatic debug Notification ::nonevar msgText ;1 variable args
            ; line 1643
            strcat ::temp0 "IntelEngine: " msgText 
            callstatic debug Trace ::nonevar ::temp0 0 ;2 variable args
          .endCode
        .endFunction ;NotifyPlayer
        .function GetSettingBool
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
            .param settingKey String
            .param defaultVal Bool
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local ::temp1 form
            .local ::temp2 Bool
            .local ::temp3 Int
          .endLocalTable
          .code
            ; line 1655
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1656
            cast ::temp1 player 
            callstatic storageUtil HasIntValue ::temp2 ::temp1 settingKey ;2 variable args
            jmpf ::temp2 _label0
            ; line 1657
            cast ::temp1 player 
            callstatic storageUtil GetIntValue ::temp3 ::temp1 settingKey 0 ;3 variable args
            cmp_gt ::temp2 ::temp3 0 
            return ::temp2 
            jmp _label0
            ; line 1659
          _label0:
            return defaultVal 
          .endCode
        .endFunction ;GetSettingBool
        .function SetSettingBool
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param settingKey String
            .param val Bool
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local ::temp1 form
            .local ::temp2 Int
          .endLocalTable
          .code
            ; line 1663
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1664
            jmpf val _label0
            ; line 1665
            cast ::temp1 player 
            callstatic storageUtil SetIntValue ::temp2 ::temp1 settingKey 1 ;3 variable args
            jmp _label1
            ; line 1667
          _label0:
            cast ::temp1 player 
            callstatic storageUtil SetIntValue ::temp2 ::temp1 settingKey 0 ;3 variable args
          _label1
          .endCode
        .endFunction ;SetSettingBool
        .function GetSettingFloat
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
            .param settingKey String
            .param defaultVal Float
          .endParamTable
          .localTable
            .local player actor
            .local ::temp0 actor
            .local ::temp1 form
            .local ::temp2 Bool
            .local ::temp3 Float
          .endLocalTable
          .code
            ; line 1672
            callstatic game GetPlayer ::temp0 ;0 variable args
            assign player ::temp0 
            ; line 1673
            cast ::temp1 player 
            callstatic storageUtil HasFloatValue ::temp2 ::temp1 settingKey ;2 variable args
            jmpf ::temp2 _label0
            ; line 1674
            cast ::temp1 player 
            callstatic storageUtil GetFloatValue ::temp3 ::temp1 settingKey 0.0 ;3 variable args
            return ::temp3 
            jmp _label0
            ; line 1676
          _label0:
            return defaultVal 
          .endCode
        .endFunction ;GetSettingFloat
        .function SetSettingFloat
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param settingKey String
            .param val Float
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 form
            .local ::temp2 Float
          .endLocalTable
          .code
            ; line 1680
            callstatic game GetPlayer ::temp0 ;0 variable args
            cast ::temp1 ::temp0 
            callstatic storageUtil SetFloatValue ::temp2 ::temp1 settingKey val ;3 variable args
          .endCode
        .endFunction ;SetSettingFloat
        .function IsDebugMode
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 1685
            callmethod GetSettingBool self ::temp0 "Intel_MCM_DebugMode" False ;2 variable args
            return ::temp0 
          .endCode
        .endFunction ;IsDebugMode
        .function GetMaxConcurrentTasks
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Int
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Float
            .local ::temp1 Int
          .endLocalTable
          .code
            ; line 1689
            callmethod GetSettingFloat self ::temp0 "Intel_MCM_MaxTasks" 5.0 ;2 variable args
            cast ::temp1 ::temp0 
            return ::temp1 
          .endCode
        .endFunction ;GetMaxConcurrentTasks
        .function GetDefaultWaitHours
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Float
          .endLocalTable
          .code
            ; line 1693
            callmethod GetSettingFloat self ::temp0 "Intel_MCM_DefaultWaitHours" 48.0 ;2 variable args
            return ::temp0 
          .endCode
        .endFunction ;GetDefaultWaitHours
        .function IsStoryEngineEnabled
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Bool
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 1697
            callmethod GetSettingBool self ::temp0 "Intel_MCM_StoryEnabled" True ;2 variable args
            return ::temp0 
          .endCode
        .endFunction ;IsStoryEngineEnabled
        .function GetStoryEngineInterval
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Float
          .endLocalTable
          .code
            ; line 1701
            callmethod GetSettingFloat self ::temp0 "Intel_MCM_StoryInterval" 3.0 ;2 variable args
            return ::temp0 
          .endCode
        .endFunction ;GetStoryEngineInterval
        .function GetStoryEngineCooldown
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return Float
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Float
          .endLocalTable
          .code
            ; line 1705
            callmethod GetSettingFloat self ::temp0 "Intel_MCM_StoryCooldown" 24.0 ;2 variable args
            return ::temp0 
          .endCode
        .endFunction ;GetStoryEngineCooldown
        .function SetStoryEnabled
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param val Bool
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 Bool
            .local ::temp1 globalVariable
          .endLocalTable
          .code
            ; line 1712
            callmethod SetSettingBool self ::nonevar "Intel_MCM_StoryEnabled" val ;2 variable args
            ; line 1713
            cast ::temp0 ::StoryEngine_var 
            jmpf ::temp0 _label0
            ; line 1714
            jmpf val _label1
            ; line 1715
            propget IntelEngine_StoryEngineEnabled ::StoryEngine_var ::temp1 
            callmethod SetValue ::temp1 ::nonevar 1.0 ;1 variable args
            ; line 1716
            callmethod StartScheduler ::StoryEngine_var ::nonevar ;0 variable args
            jmp _label2
            ; line 1718
          _label1:
            propget IntelEngine_StoryEngineEnabled ::StoryEngine_var ::temp1 
            callmethod SetValue ::temp1 ::nonevar 0.0 ;1 variable args
            ; line 1719
            callmethod StopScheduler ::StoryEngine_var ::nonevar ;0 variable args
          _label2:
            jmp _label0
          _label0
          .endCode
        .endFunction ;SetStoryEnabled
        .function SetStoryInterval
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param val Float
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 Bool
            .local ::temp1 globalVariable
          .endLocalTable
          .code
            ; line 1725
            callmethod SetSettingFloat self ::nonevar "Intel_MCM_StoryInterval" val ;2 variable args
            ; line 1726
            cast ::temp0 ::StoryEngine_var 
            jmpf ::temp0 _label0
            ; line 1727
            propget IntelEngine_StoryEngineInterval ::StoryEngine_var ::temp1 
            callmethod SetValue ::temp1 ::nonevar val ;1 variable args
            ; line 1728
            callmethod StartScheduler ::StoryEngine_var ::nonevar ;0 variable args
            jmp _label0
          _label0
          .endCode
        .endFunction ;SetStoryInterval
        .function SetStoryCooldown
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param val Float
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 Bool
            .local ::temp1 globalVariable
          .endLocalTable
          .code
            ; line 1733
            callmethod SetSettingFloat self ::nonevar "Intel_MCM_StoryCooldown" val ;2 variable args
            ; line 1734
            cast ::temp0 ::StoryEngine_var 
            jmpf ::temp0 _label0
            ; line 1735
            propget IntelEngine_StoryEngineCooldown ::StoryEngine_var ::temp1 
            callmethod SetValue ::temp1 ::nonevar val ;1 variable args
            jmp _label0
          _label0
          .endCode
        .endFunction ;SetStoryCooldown
        .function SetMaxTasks
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param val Int
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 Float
          .endLocalTable
          .code
            ; line 1740
            cast ::temp0 val 
            callmethod SetSettingFloat self ::nonevar "Intel_MCM_MaxTasks" ::temp0 ;2 variable args
            ; line 1741
            cast ::temp0 val 
            callmethod SetValue ::IntelEngine_MaxConcurrentTasks_var ::nonevar ::temp0 ;1 variable args
          .endCode
        .endFunction ;SetMaxTasks
        .function SetReleaseDistance
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param val Float
          .endParamTable
          .localTable
            .local ::temp0 Bool
          .endLocalTable
          .code
            ; line 1747
            cmp_lt ::temp0 val 400.0 
            jmpf ::temp0 _label0
            ; line 1748
            assign val 400.0 
            jmp _label0
            ; line 1750
          _label0:
            assign ::LINGER_RELEASE_DISTANCE_var val 
          .endCode
        .endFunction ;SetReleaseDistance
        .function SetDangerZonePolicy
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param val Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1754
            cast ::temp0 ::StoryEngine_var 
            jmpf ::temp0 _label0
            ; line 1755
            propset DangerZonePolicy ::StoryEngine_var val 
            jmp _label0
            ; line 1757
          _label0:
            callstatic intelEngine SetDangerZonePolicy ::nonevar val ;1 variable args
          .endCode
        .endFunction ;SetDangerZonePolicy
        .function SetPlayerHomePolicy
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param val Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1761
            cast ::temp0 ::StoryEngine_var 
            jmpf ::temp0 _label0
            ; line 1762
            propset PlayerHomePolicy ::StoryEngine_var val 
            jmp _label0
            ; line 1764
          _label0:
            callstatic intelEngine SetPlayerHomePolicy ::nonevar val ;1 variable args
          .endCode
        .endFunction ;SetPlayerHomePolicy
        .function SetHoldRestrictionPolicy
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param storyType String
            .param val Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1768
            cast ::temp0 ::StoryEngine_var 
            jmpf ::temp0 _label0
            ; line 1769
            cmp_eq ::temp0 storyType "seek_player" 
            jmpf ::temp0 _label1
            ; line 1770
            propset HoldPolicySeekPlayer ::StoryEngine_var val 
            jmp _label2
            ; line 1771
          _label1:
            cmp_eq ::temp0 storyType "informant" 
            jmpf ::temp0 _label3
            ; line 1772
            propset HoldPolicyInformant ::StoryEngine_var val 
            jmp _label2
            ; line 1773
          _label3:
            cmp_eq ::temp0 storyType "road_encounter" 
            jmpf ::temp0 _label4
            ; line 1774
            propset HoldPolicyRoadEncounter ::StoryEngine_var val 
            jmp _label2
            ; line 1775
          _label4:
            cmp_eq ::temp0 storyType "ambush" 
            jmpf ::temp0 _label5
            ; line 1776
            propset HoldPolicyAmbush ::StoryEngine_var val 
            jmp _label2
            ; line 1777
          _label5:
            cmp_eq ::temp0 storyType "stalker" 
            jmpf ::temp0 _label6
            ; line 1778
            propset HoldPolicyStalker ::StoryEngine_var val 
            jmp _label2
            ; line 1779
          _label6:
            cmp_eq ::temp0 storyType "message" 
            jmpf ::temp0 _label7
            ; line 1780
            propset HoldPolicyMessage ::StoryEngine_var val 
            jmp _label2
            ; line 1781
          _label7:
            cmp_eq ::temp0 storyType "quest" 
            jmpf ::temp0 _label2
            ; line 1782
            propset HoldPolicyQuest ::StoryEngine_var val 
            jmp _label2
          _label2:
            jmp _label0
            ; line 1785
          _label0:
            callstatic intelEngine SetHoldRestrictionPolicy ::nonevar storyType val ;2 variable args
          .endCode
        .endFunction ;SetHoldRestrictionPolicy
        .function DebugMsg
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param msg String
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 1793
            strcat ::temp0 "IntelEngine: " msg 
            callstatic debug Trace ::nonevar ::temp0 0 ;2 variable args
            ; line 1794
            callmethod IsDebugMode self ::temp1 ;0 variable args
            jmpf ::temp1 _label0
            ; line 1795
            strcat ::temp0 "Intel: " msg 
            callstatic debug Notification ::nonevar ::temp0 ;1 variable args
            jmp _label0
          _label0
          .endCode
        .endFunction ;DebugMsg
        .function GetSlotStatus
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
            .param slot Int
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local ::temp1 Int
            .local slotAlias referenceAlias
            .local ::temp2 referenceAlias
            .local agent actor
            .local ::temp3 actor
            .local agentName String
            .local ::temp4 String
            .local taskType String
            .local target String
            .local taskState Int
            .local cellName String
            .local agentCell cell
            .local ::temp5 cell
            .local desc String
          .endLocalTable
          .code
            ; line 1804
            cmp_lt ::temp0 slot 0 
            assign ::temp0 ::temp0 
            jmpt ::temp0 _label0
            propget MAX_SLOTS self ::temp1 
            comp_gte ::temp0 slot ::temp1 
            assign ::temp0 ::temp0 
          _label0:
            jmpf ::temp0 _label1
            ; line 1805
            return "Invalid" 
            jmp _label1
            ; line 1808
          _label1:
            array_getlement ::temp1 ::SlotStates_var slot 
            cmp_eq ::temp0 ::temp1 0 
            jmpf ::temp0 _label2
            ; line 1809
            return "Empty" 
            jmp _label2
            ; line 1812
          _label2:
            callmethod GetAgentAlias self ::temp2 slot ;1 variable args
            assign slotAlias ::temp2 
            ; line 1813
            cast ::temp0 slotAlias 
            jmpf ::temp0 _label3
            ; line 1814
            callmethod GetActorReference slotAlias ::temp3 ;0 variable args
            assign agent ::temp3 
            ; line 1815
            cast ::temp0 agent 
            jmpf ::temp0 _label4
            ; line 1816
            callmethod GetDisplayName agent ::temp4 ;0 variable args
            assign agentName ::temp4 
            ; line 1817
            array_getlement ::temp4 ::SlotTaskTypes_var slot 
            assign taskType ::temp4 
            ; line 1818
            array_getlement ::temp4 ::SlotTargetNames_var slot 
            assign target ::temp4 
            ; line 1819
            array_getlement ::temp1 ::SlotStates_var slot 
            assign taskState ::temp1 
            ; line 1822
            assign cellName "" 
            ; line 1823
            callmethod IsInCombat agent ::temp0 ;0 variable args
            jmpf ::temp0 _label5
            ; line 1824
            assign cellName "[IN COMBAT]" 
            jmp _label6
            ; line 1826
          _label5:
            callmethod GetParentCell agent ::temp5 ;0 variable args
            assign agentCell ::temp5 
            ; line 1827
            cast ::temp0 agentCell 
            jmpf ::temp0 _label6
            ; line 1828
            callmethod GetName agentCell ::temp4 ;0 variable args
            assign cellName ::temp4 
            jmp _label6
            ; line 1831
          _label6:
            callstatic intelEngine GetSlotStatusNative ::temp4 taskType taskState target cellName ;4 variable args
            assign desc ::temp4 
            ; line 1832
            strcat ::temp4 agentName ": " 
            strcat ::temp4 ::temp4 desc 
            return ::temp4 
            jmp _label4
          _label4:
            jmp _label3
            ; line 1836
          _label3:
            return "Unknown" 
          .endCode
        .endFunction ;GetSlotStatus
        .function TryWaypointNavigation
           ; function type 0
          .userFlags 0 ;none
          .docString "Attempt waypoint redirect for on-screen stuck NPC.
    Finds nearest BGSLocation worldLocMarker toward dest and redirects
    the travel package. If NPC was already targeting this waypoint and
    is still stuck, teleports to it instead (known-good navmesh position).
    Returns true if handled (caller should return)."
          .return Bool
          .paramTable
            .param slot Int
            .param npc actor
            .param dest objectReference
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local waypoint objectReference
            .local ::temp1 objectReference
            .local currentWP objectReference
            .local ::temp2 form
            .local ::temp3 form
            .local ::nonevar None
            .local ::temp4 String
            .local speed Int
            .local ::temp5 Int
            .local travelPkg package
            .local ::temp6 package
          .endLocalTable
          .code
            ; line 1845
            callmethod Is3DLoaded npc ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 1846
            return False 
            jmp _label0
            ; line 1849
          _label0:
            callstatic intelEngine FindNearestWaypointToward ::temp1 npc dest 5000.0 ;3 variable args
            assign waypoint ::temp1 
            ; line 1850
            cast ::temp1 None 
            cmp_eq ::temp0 waypoint ::temp1 
            jmpf ::temp0 _label1
            ; line 1851
            return False 
            jmp _label1
            ; line 1854
          _label1:
            cast ::temp2 npc 
            cast ::temp3 None 
            callstatic storageUtil GetFormValue ::temp3 ::temp2 "Intel_CurrentWaypoint" ::temp3 ;3 variable args
            ; line 1855
            cast ::temp1 ::temp3 
            assign currentWP ::temp1 
            ; line 1857
            cmp_eq ::temp0 currentWP waypoint 
            jmpf ::temp0 _label2
            ; line 1860
            callmethod GetDisplayName npc ::temp4 ;0 variable args
            strcat ::temp4 ::temp4 " stuck at waypoint — teleporting to it" 
            callmethod DebugMsg self ::nonevar ::temp4 ;1 variable args
            ; line 1861
            callmethod MoveTo npc ::nonevar waypoint 0.0 0.0 50.0 True ;5 variable args
            ; line 1862
            cast ::temp3 npc 
            callstatic storageUtil UnsetFormValue ::temp0 ::temp3 "Intel_CurrentWaypoint" ;2 variable args
            ; line 1863
            cast ::temp1 npc 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp1 dest ::IntelEngine_TravelTarget_var ;3 variable args
            ; line 1864
            callstatic intelEngine ResetStuckSlot ::nonevar slot npc ;2 variable args
            jmp _label3
            ; line 1867
          _label2:
            callmethod GetDisplayName npc ::temp4 ;0 variable args
            strcat ::temp4 ::temp4 " redirecting to nearby location marker" 
            callmethod DebugMsg self ::nonevar ::temp4 ;1 variable args
            ; line 1868
            cast ::temp1 npc 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp1 waypoint ::IntelEngine_TravelTarget_var ;3 variable args
            ; line 1869
            cast ::temp3 npc 
            cast ::temp2 waypoint 
            callstatic storageUtil SetFormValue ::temp2 ::temp3 "Intel_CurrentWaypoint" ::temp2 ;3 variable args
            ; line 1870
            callstatic intelEngine ResetStuckSlot ::nonevar slot npc ;2 variable args
            ; line 1873
          _label3:
            array_getlement ::temp5 ::SlotSpeeds_var slot 
            assign speed ::temp5 
            ; line 1874
            callmethod GetTravelPackage self ::temp6 speed ;1 variable args
            assign travelPkg ::temp6 
            ; line 1875
            cast ::temp0 travelPkg 
            jmpf ::temp0 _label4
            ; line 1876
            propget PRIORITY_TRAVEL self ::temp5 
            callstatic actorUtil AddPackageOverride ::nonevar npc travelPkg ::temp5 1 ;4 variable args
            jmp _label4
            ; line 1878
          _label4:
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 1879
            callmethod GetDisplayName npc ::temp4 ;0 variable args
            strcat ::temp4 ::temp4 " finding alternate route" 
            callmethod NotifyPlayer self ::nonevar ::temp4 ;1 variable args
            ; line 1880
            return True 
          .endCode
        .endFunction ;TryWaypointNavigation
        .function CheckWaypointArrival
           ; function type 0
          .userFlags 0 ;none
          .docString "Check if NPC reached their intermediate waypoint. If so, restore real
    destination and resume normal travel. Called at top of monitoring loops.
    Returns true if waypoint was reached (caller should skip normal checks)."
          .return Bool
          .paramTable
            .param slot Int
            .param npc actor
            .param dest objectReference
          .endParamTable
          .localTable
            .local currentWaypoint objectReference
            .local ::temp0 form
            .local ::temp1 form
            .local ::temp2 objectReference
            .local ::temp3 Bool
            .local ::temp4 Float
            .local ::temp5 Float
            .local ::nonevar None
            .local ::temp6 String
          .endLocalTable
          .code
            ; line 1887
            cast ::temp0 npc 
            cast ::temp1 None 
            callstatic storageUtil GetFormValue ::temp1 ::temp0 "Intel_CurrentWaypoint" ::temp1 ;3 variable args
            ; line 1888
            cast ::temp2 ::temp1 
            assign currentWaypoint ::temp2 
            ; line 1889
            cast ::temp2 None 
            cmp_eq ::temp3 currentWaypoint ::temp2 
            jmpf ::temp3 _label0
            ; line 1890
            return False 
            jmp _label0
            ; line 1893
          _label0:
            callmethod GetDistance npc ::temp4 currentWaypoint ;1 variable args
            propget ARRIVAL_DISTANCE self ::temp5 
            cmp_lt ::temp3 ::temp4 ::temp5 
            jmpf ::temp3 _label1
            ; line 1894
            callmethod GetDisplayName npc ::temp6 ;0 variable args
            strcat ::temp6 ::temp6 " reached waypoint, resuming to dest" 
            callmethod DebugMsg self ::nonevar ::temp6 ;1 variable args
            ; line 1895
            cast ::temp2 npc 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp2 dest ::IntelEngine_TravelTarget_var ;3 variable args
            ; line 1896
            cast ::temp1 npc 
            callstatic storageUtil UnsetFormValue ::temp3 ::temp1 "Intel_CurrentWaypoint" ;2 variable args
            ; line 1897
            callstatic intelEngine ResetStuckSlot ::nonevar slot npc ;2 variable args
            ; line 1898
            callmethod EvaluatePackage npc ::nonevar ;0 variable args
            ; line 1899
            return True 
            jmp _label1
            ; line 1902
          _label1:
            return False 
          .endCode
        .endFunction ;CheckWaypointArrival
        .function ForceResetAllSlots
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar None
            .local i Int
            .local ::temp0 Int
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 1906
            callmethod DebugMsg self ::nonevar "Force resetting all slots" ;1 variable args
            ; line 1907
            callmethod NotifyPlayer self ::nonevar "IntelEngine: Resetting all tasks..." ;1 variable args
            ; line 1909
            assign i 0 
            ; line 1910
          _label1:
            propget MAX_SLOTS self ::temp0 
            cmp_lt ::temp1 i ::temp0 
            jmpf ::temp1 _label0
            ; line 1911
            callmethod ClearSlot self ::nonevar i True False ;3 variable args
            ; line 1912
            iadd ::temp0 i 1 
            assign i ::temp0 
            jmp _label1
            ; line 1915
          _label0:
            callmethod NotifyPlayer self ::nonevar "IntelEngine: All tasks reset" ;1 variable args
          .endCode
        .endFunction ;ForceResetAllSlots
        .function RegisterDashboardEvents
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
            ; line 1923
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_DashboardOpened" "OnDashboardOpened" ;2 variable args
            ; line 1924
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_DashboardRefresh" "OnDashboardRefresh" ;2 variable args
            ; line 1925
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_DashboardCancelTask" "OnDashboardCancelTask" ;2 variable args
            ; line 1926
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_DashboardCancelQuest" "OnDashboardCancelQuest" ;2 variable args
            ; line 1927
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_DashboardCancelSchedule" "OnDashboardCancelSchedule" ;2 variable args
            ; line 1928
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_DashboardToggleStory" "OnDashboardToggleStory" ;2 variable args
            ; line 1929
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_DashboardSetting" "OnDashboardSetting" ;2 variable args
            ; line 1930
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_DashboardRemovePackages" "OnDashboardRemovePackages" ;2 variable args
            ; line 1931
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_DashboardDispatchStory" "OnDashboardDispatchStory" ;2 variable args
            ; line 1932
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_DashboardDispatchNpcSocial" "OnDashboardDispatchNpcSocial" ;2 variable args
            ; line 1933
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_DashboardDispatchPolitics" "OnDashboardDispatchPolitics" ;2 variable args
            ; line 1934
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_DashboardExecuteAction" "OnDashboardExecuteAction" ;2 variable args
            ; line 1935
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_AutoBioUpdate" "OnAutoBioUpdate" ;2 variable args
            ; line 1936
            callmethod RegisterForModEvent self ::nonevar "IntelEngine_SaveBioCount" "OnSaveBioCount" ;2 variable args
            ; line 1937
            callmethod DebugMsg self ::nonevar "Dashboard ModEvent listeners registered" ;1 variable args
          .endCode
        .endFunction ;RegisterDashboardEvents
        .function OnSaveBioCount
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local npc actor
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 intelEngine_StoryEngine
            .local count Int
            .local ::temp3 Int
            .local ::temp4 form
            .local ::temp5 form
          .endLocalTable
          .code
            ; line 1942
            cast ::temp0 sender 
            assign npc ::temp0 
            ; line 1943
            cast ::temp0 None 
            cmp_eq ::temp1 npc ::temp0 
            assign ::temp1 ::temp1 
            jmpt ::temp1 _label0
            cast ::temp2 None 
            cmp_eq ::temp1 ::StoryEngine_var ::temp2 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 1944
            return None 
            jmp _label1
            ; line 1946
          _label1:
            cast ::temp3 strArg 
            assign count ::temp3 
            ; line 1947
            cast ::temp4 npc 
            callstatic storageUtil SetIntValue ::temp3 ::temp4 "Intel_BioLineCount" count ;3 variable args
            ; line 1948
            cast ::temp4 ::StoryEngine_var 
            cast ::temp5 npc 
            callstatic storageUtil FormListHas ::temp1 ::temp4 "Intel_BioTrackActors" ::temp5 ;3 variable args
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 1949
            cast ::temp5 ::StoryEngine_var 
            cast ::temp4 npc 
            callstatic storageUtil FormListAdd ::temp3 ::temp5 "Intel_BioTrackActors" ::temp4 True ;4 variable args
            jmp _label2
          _label2
          .endCode
        .endFunction ;OnSaveBioCount
        .function OnAutoBioUpdate
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local npc actor
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 form
            .local ::temp3 Int
            .local ::temp4 String
            .local result String
          .endLocalTable
          .code
            ; line 1955
            cast ::temp0 sender 
            assign npc ::temp0 
            ; line 1956
            cast ::temp0 None 
            cmp_eq ::temp1 npc ::temp0 
            jmpf ::temp1 _label0
            ; line 1957
            callmethod DebugMsg self ::nonevar "Auto Bio Update: sender is not a valid actor" ;1 variable args
            ; line 1958
            return None 
            jmp _label0
            ; line 1961
          _label0:
            cast ::temp2 npc 
            callstatic storageUtil SetIntValue ::temp3 ::temp2 "Intel_BioLineCount" 0 ;3 variable args
            ; line 1962
            callmethod GetDisplayName npc ::temp4 ;0 variable args
            strcat ::temp4 "Auto Bio Update: " ::temp4 
            callmethod DebugMsg self ::nonevar ::temp4 ;1 variable args
            ; line 1963
            callstatic skyrimNetApi UpdateActorDynamicBio ::temp4 npc ;1 variable args
            assign result ::temp4 
            ; line 1964
            cmp_eq ::temp1 result "" 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label1
            ; line 1965
            callmethod GetDisplayName npc ::temp4 ;0 variable args
            strcat ::temp4 "Auto Bio Update: " ::temp4 
            strcat ::temp4 ::temp4 " — " 
            strcat ::temp4 ::temp4 result 
            callmethod DebugMsg self ::nonevar ::temp4 ;1 variable args
            jmp _label2
            ; line 1967
          _label1:
            callmethod GetDisplayName npc ::temp4 ;0 variable args
            strcat ::temp4 "Auto Bio Update: " ::temp4 
            strcat ::temp4 ::temp4 " — failed or no changes" 
            callmethod DebugMsg self ::nonevar ::temp4 ;1 variable args
          _label2
          .endCode
        .endFunction ;OnAutoBioUpdate
        .function OnDashboardOpened
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1972
            callmethod PushDashboardState self ::nonevar ;0 variable args
          .endCode
        .endFunction ;OnDashboardOpened
        .function OnDashboardRefresh
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1976
            callmethod PushDashboardState self ::nonevar ;0 variable args
          .endCode
        .endFunction ;OnDashboardRefresh
        .function OnDashboardCancelTask
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local slot Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local agent actor
            .local ::temp2 referenceAlias
            .local ::temp3 actor
            .local ::nonevar None
            .local ::temp4 String
            .local ::temp5 String
            .local ::temp6 form
          .endLocalTable
          .code
            ; line 1980
            cast ::temp0 numArg 
            assign slot ::temp0 
            ; line 1981
            comp_gte ::temp1 slot 0 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            propget MAX_SLOTS self ::temp0 
            cmp_lt ::temp1 slot ::temp0 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 1982
            callmethod GetAgentAlias self ::temp2 slot ;1 variable args
            callmethod GetActorReference ::temp2 ::temp3 ;0 variable args
            assign agent ::temp3 
            ; line 1983
            cast ::temp3 None 
            cmp_eq ::temp1 agent ::temp3 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label2
            ; line 1984
            cast ::temp4 slot 
            strcat ::temp4 "Dashboard: Cancelling task in slot " ::temp4 
            strcat ::temp4 ::temp4 " for " 
            callmethod GetDisplayName agent ::temp5 ;0 variable args
            strcat ::temp5 ::temp4 ::temp5 
            callmethod DebugMsg self ::nonevar ::temp5 ;1 variable args
            ; line 1985
            cast ::temp6 agent 
            callstatic storageUtil SetStringValue ::temp5 ::temp6 "Intel_Result" "cancelled" ;3 variable args
            ; line 1986
            callmethod ClearSlotRestoreFollower self ::nonevar slot agent ;2 variable args
            ; line 1987
            callmethod PushDashboardState self ::nonevar ;0 variable args
            jmp _label2
          _label2:
            jmp _label1
          _label1
          .endCode
        .endFunction ;OnDashboardCancelTask
        .function OnDashboardCancelQuest
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local ::temp0 intelEngine_StoryEngine
            .local ::temp1 Bool
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 1993
            cast ::temp0 None 
            cmp_eq ::temp1 ::StoryEngine_var ::temp0 
            not ::temp1 ::temp1 
            assign ::temp1 ::temp1 
            jmpf ::temp1 _label0
            propget QuestActive ::StoryEngine_var ::temp1 
            assign ::temp1 ::temp1 
          _label0:
            jmpf ::temp1 _label1
            ; line 1994
            callmethod DebugMsg self ::nonevar "Dashboard: Cancelling active quest" ;1 variable args
            ; line 1995
            callmethod CleanupQuest ::StoryEngine_var ::nonevar ;0 variable args
            ; line 1996
            callmethod CleanupStoryDispatch ::StoryEngine_var ::nonevar ;0 variable args
            ; line 1997
            callmethod PushDashboardState self ::nonevar ;0 variable args
            jmp _label1
          _label1
          .endCode
        .endFunction ;OnDashboardCancelQuest
        .function OnDashboardRemovePackages
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local formId Int
            .local ::temp0 Int
            .local npc actor
            .local ::temp1 form
            .local ::temp2 actor
            .local ::temp3 Bool
            .local ::nonevar None
            .local ::temp4 String
            .local slot Int
            .local ::temp5 objectReference
            .local ::temp6 objectReference
          .endLocalTable
          .code
            ; line 2002
            cast ::temp0 numArg 
            assign formId ::temp0 
            ; line 2003
            callstatic game GetForm ::temp1 formId ;1 variable args
            cast ::temp2 ::temp1 
            assign npc ::temp2 
            ; line 2004
            cast ::temp2 None 
            cmp_eq ::temp3 npc ::temp2 
            not ::temp3 ::temp3 
            jmpf ::temp3 _label0
            ; line 2005
            callmethod GetDisplayName npc ::temp4 ;0 variable args
            strcat ::temp4 "Dashboard: Removing packages from " ::temp4 
            callmethod DebugMsg self ::nonevar ::temp4 ;1 variable args
            ; line 2007
            callmethod FindSlotByAgent self ::temp0 npc ;1 variable args
            assign slot ::temp0 
            ; line 2008
            comp_gte ::temp3 slot 0 
            jmpf ::temp3 _label1
            ; line 2009
            callmethod ClearSlot self ::nonevar slot True False ;3 variable args
            jmp _label2
            ; line 2011
          _label1:
            callmethod RemoveIntelPackages self ::nonevar npc True ;2 variable args
            ; line 2014
          _label2:
            propget ActiveStoryNPC ::StoryEngine_var ::temp2 
            cmp_eq ::temp3 ::temp2 npc 
            jmpf ::temp3 _label3
            ; line 2015
            callmethod CleanupStoryDispatch ::StoryEngine_var ::nonevar ;0 variable args
            jmp _label3
            ; line 2017
          _label3:
            propget NPCSocialTraveler ::StoryEngine_var ::temp2 
            cmp_eq ::temp3 ::temp2 npc 
            jmpf ::temp3 _label4
            ; line 2018
            callmethod CleanupNPCSocialDispatch ::StoryEngine_var ::nonevar ;0 variable args
            jmp _label4
            ; line 2021
          _label4:
            cast ::temp5 npc 
            cast ::temp6 None 
            callstatic pO3_SKSEFunctions SetLinkedRef ::nonevar ::temp5 ::temp6 ::IntelEngine_TravelTarget_var ;3 variable args
            ; line 2023
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 2024
            callmethod PushDashboardState self ::nonevar ;0 variable args
            jmp _label0
          _label0
          .endCode
        .endFunction ;OnDashboardRemovePackages
        .function OnDashboardCancelSchedule
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local slot Int
            .local ::temp0 Int
            .local ::temp1 Bool
            .local ::nonevar None
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 2029
            cast ::temp0 numArg 
            assign slot ::temp0 
            ; line 2030
            cast ::temp1 ::Schedule_var 
            jmpf ::temp1 _label0
            ; line 2031
            callmethod ClearScheduleSlot ::Schedule_var ::nonevar slot ;1 variable args
            ; line 2032
            cast ::temp2 slot 
            strcat ::temp2 "Dashboard: Cancelled scheduled task in slot " ::temp2 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            ; line 2033
            callmethod PushDashboardState self ::nonevar ;0 variable args
            jmp _label0
          _label0
          .endCode
        .endFunction ;OnDashboardCancelSchedule
        .function OnDashboardToggleStory
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local enabled Bool
            .local ::nonevar None
            .local ::temp1 String
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 2038
            not ::temp0 ::StoryEngine_var 
            jmpf ::temp0 _label0
            ; line 2039
            return None 
            jmp _label0
            ; line 2041
          _label0:
            cmp_gt ::temp0 numArg 0.5 
            assign enabled ::temp0 
            ; line 2042
            strcat ::temp1 "Dashboard: Toggle story type " strArg 
            strcat ::temp1 ::temp1 " = " 
            cast ::temp2 enabled 
            strcat ::temp2 ::temp1 ::temp2 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            ; line 2043
            cmp_eq ::temp0 strArg "seek_player" 
            jmpf ::temp0 _label1
            ; line 2044
            propset TypeSeekPlayerEnabled ::StoryEngine_var enabled 
            jmp _label2
            ; line 2045
          _label1:
            cmp_eq ::temp0 strArg "informant" 
            jmpf ::temp0 _label3
            ; line 2046
            propset TypeInformantEnabled ::StoryEngine_var enabled 
            jmp _label2
            ; line 2047
          _label3:
            cmp_eq ::temp0 strArg "road_encounter" 
            jmpf ::temp0 _label4
            ; line 2048
            propset TypeRoadEncounterEnabled ::StoryEngine_var enabled 
            jmp _label2
            ; line 2049
          _label4:
            cmp_eq ::temp0 strArg "ambush" 
            jmpf ::temp0 _label5
            ; line 2050
            propset TypeAmbushEnabled ::StoryEngine_var enabled 
            jmp _label2
            ; line 2051
          _label5:
            cmp_eq ::temp0 strArg "faction_ambush" 
            jmpf ::temp0 _label6
            ; line 2052
            propset TypeFactionAmbushEnabled ::StoryEngine_var enabled 
            jmp _label2
            ; line 2053
          _label6:
            cmp_eq ::temp0 strArg "stalker" 
            jmpf ::temp0 _label7
            ; line 2054
            propset TypeStalkerEnabled ::StoryEngine_var enabled 
            jmp _label2
            ; line 2055
          _label7:
            cmp_eq ::temp0 strArg "message" 
            jmpf ::temp0 _label8
            ; line 2056
            propset TypeMessageEnabled ::StoryEngine_var enabled 
            jmp _label2
            ; line 2057
          _label8:
            cmp_eq ::temp0 strArg "quest" 
            jmpf ::temp0 _label9
            ; line 2058
            propset TypeQuestEnabled ::StoryEngine_var enabled 
            jmp _label2
            ; line 2059
          _label9:
            cmp_eq ::temp0 strArg "npc_interaction" 
            jmpf ::temp0 _label10
            ; line 2060
            propset TypeNPCInteractionEnabled ::StoryEngine_var enabled 
            jmp _label2
            ; line 2061
          _label10:
            cmp_eq ::temp0 strArg "npc_gossip" 
            jmpf ::temp0 _label2
            ; line 2062
            propset TypeNPCGossipEnabled ::StoryEngine_var enabled 
            jmp _label2
            ; line 2064
          _label2:
            callmethod PushDashboardState self ::nonevar ;0 variable args
          .endCode
        .endFunction ;OnDashboardToggleStory
        .function OnDashboardSetting
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local ::temp1 String
            .local ::temp2 Bool
            .local ::temp3 Int
            .local ::temp4 actor
            .local ::temp5 form
            .local ::temp6 Float
          .endLocalTable
          .code
            ; line 2068
            strcat ::temp0 "Dashboard: Setting " strArg 
            strcat ::temp0 ::temp0 " = " 
            cast ::temp1 numArg 
            strcat ::temp1 ::temp0 ::temp1 
            callmethod DebugMsg self ::nonevar ::temp1 ;1 variable args
            ; line 2071
            cmp_eq ::temp2 strArg "debugMode" 
            jmpf ::temp2 _label0
            ; line 2072
            cmp_gt ::temp2 numArg 0.5 
            callmethod SetSettingBool self ::nonevar "Intel_MCM_DebugMode" ::temp2 ;2 variable args
            jmp _label1
            ; line 2073
          _label0:
            cmp_eq ::temp2 strArg "storyEnabled" 
            jmpf ::temp2 _label2
            ; line 2074
            cmp_gt ::temp2 numArg 0.5 
            callmethod SetStoryEnabled self ::nonevar ::temp2 ;1 variable args
            jmp _label1
            ; line 2075
          _label2:
            cmp_eq ::temp2 strArg "storyInterval" 
            jmpf ::temp2 _label3
            ; line 2076
            callmethod SetStoryInterval self ::nonevar numArg ;1 variable args
            jmp _label1
            ; line 2077
          _label3:
            cmp_eq ::temp2 strArg "storyCooldown" 
            jmpf ::temp2 _label4
            ; line 2078
            callmethod SetStoryCooldown self ::nonevar numArg ;1 variable args
            jmp _label1
            ; line 2079
          _label4:
            cmp_eq ::temp2 strArg "maxTasks" 
            jmpf ::temp2 _label5
            ; line 2080
            cast ::temp3 numArg 
            callmethod SetMaxTasks self ::nonevar ::temp3 ;1 variable args
            jmp _label1
            ; line 2081
          _label5:
            cmp_eq ::temp2 strArg "releaseDistance" 
            jmpf ::temp2 _label6
            ; line 2082
            callmethod SetReleaseDistance self ::nonevar numArg ;1 variable args
            jmp _label1
            ; line 2083
          _label6:
            cmp_eq ::temp2 strArg "longAbsenceDays" 
            jmpf ::temp2 _label7
            ; line 2084
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label8
            ; line 2085
            propset LongAbsenceDaysConfig ::StoryEngine_var numArg 
            jmp _label8
          _label8:
            jmp _label1
            ; line 2087
          _label7:
            cmp_eq ::temp2 strArg "maxTravelDays" 
            jmpf ::temp2 _label9
            ; line 2088
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label10
            ; line 2089
            propset MaxTravelDaysConfig ::StoryEngine_var numArg 
            jmp _label10
          _label10:
            jmp _label1
            ; line 2091
          _label9:
            cmp_eq ::temp2 strArg "allowStuckTeleport" 
            jmpf ::temp2 _label11
            ; line 2092
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label12
            ; line 2093
            cmp_gt ::temp2 numArg 0.5 
            propset AllowStuckTeleport ::StoryEngine_var ::temp2 
            jmp _label12
          _label12:
            jmp _label1
            ; line 2095
          _label11:
            cmp_eq ::temp2 strArg "dangerZonePolicy" 
            jmpf ::temp2 _label13
            ; line 2096
            cast ::temp3 numArg 
            callmethod SetDangerZonePolicy self ::nonevar ::temp3 ;1 variable args
            jmp _label1
            ; line 2097
          _label13:
            cmp_eq ::temp2 strArg "playerHomePolicy" 
            jmpf ::temp2 _label14
            ; line 2098
            cast ::temp3 numArg 
            callmethod SetPlayerHomePolicy self ::nonevar ::temp3 ;1 variable args
            jmp _label1
            ; line 2099
          _label14:
            cmp_eq ::temp2 strArg "holdPolicySeekPlayer" 
            jmpf ::temp2 _label15
            ; line 2100
            cast ::temp3 numArg 
            callmethod SetHoldRestrictionPolicy self ::nonevar "seek_player" ::temp3 ;2 variable args
            jmp _label1
            ; line 2101
          _label15:
            cmp_eq ::temp2 strArg "holdPolicyInformant" 
            jmpf ::temp2 _label16
            ; line 2102
            cast ::temp3 numArg 
            callmethod SetHoldRestrictionPolicy self ::nonevar "informant" ::temp3 ;2 variable args
            jmp _label1
            ; line 2103
          _label16:
            cmp_eq ::temp2 strArg "holdPolicyRoadEncounter" 
            jmpf ::temp2 _label17
            ; line 2104
            cast ::temp3 numArg 
            callmethod SetHoldRestrictionPolicy self ::nonevar "road_encounter" ::temp3 ;2 variable args
            jmp _label1
            ; line 2105
          _label17:
            cmp_eq ::temp2 strArg "holdPolicyAmbush" 
            jmpf ::temp2 _label18
            ; line 2106
            cast ::temp3 numArg 
            callmethod SetHoldRestrictionPolicy self ::nonevar "ambush" ::temp3 ;2 variable args
            jmp _label1
            ; line 2107
          _label18:
            cmp_eq ::temp2 strArg "holdPolicyStalker" 
            jmpf ::temp2 _label19
            ; line 2108
            cast ::temp3 numArg 
            callmethod SetHoldRestrictionPolicy self ::nonevar "stalker" ::temp3 ;2 variable args
            jmp _label1
            ; line 2109
          _label19:
            cmp_eq ::temp2 strArg "holdPolicyMessage" 
            jmpf ::temp2 _label20
            ; line 2110
            cast ::temp3 numArg 
            callmethod SetHoldRestrictionPolicy self ::nonevar "message" ::temp3 ;2 variable args
            jmp _label1
            ; line 2111
          _label20:
            cmp_eq ::temp2 strArg "holdPolicyQuest" 
            jmpf ::temp2 _label21
            ; line 2112
            cast ::temp3 numArg 
            callmethod SetHoldRestrictionPolicy self ::nonevar "quest" ::temp3 ;2 variable args
            jmp _label1
            ; line 2113
          _label21:
            cmp_eq ::temp2 strArg "npc_interaction" 
            jmpf ::temp2 _label22
            ; line 2114
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label23
            ; line 2115
            cmp_gt ::temp2 numArg 0.5 
            propset TypeNPCInteractionEnabled ::StoryEngine_var ::temp2 
            jmp _label23
          _label23:
            jmp _label1
            ; line 2117
          _label22:
            cmp_eq ::temp2 strArg "npc_gossip" 
            jmpf ::temp2 _label24
            ; line 2118
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label25
            ; line 2119
            cmp_gt ::temp2 numArg 0.5 
            propset TypeNPCGossipEnabled ::StoryEngine_var ::temp2 
            jmp _label25
          _label25:
            jmp _label1
            ; line 2121
          _label24:
            cmp_eq ::temp2 strArg "npcTickEnabled" 
            jmpf ::temp2 _label26
            ; line 2122
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label27
            ; line 2123
            cmp_gt ::temp2 numArg 0.5 
            propset NPCTickEnabled ::StoryEngine_var ::temp2 
            jmp _label27
          _label27:
            jmp _label1
            ; line 2125
          _label26:
            cmp_eq ::temp2 strArg "npcTickInterval" 
            jmpf ::temp2 _label28
            ; line 2126
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label29
            ; line 2127
            propset NPCTickIntervalHours ::StoryEngine_var numArg 
            jmp _label29
          _label29:
            jmp _label1
            ; line 2129
          _label28:
            cmp_eq ::temp2 strArg "npcSocialCooldown" 
            jmpf ::temp2 _label30
            ; line 2130
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label31
            ; line 2131
            propset NPCSocialCooldownHours ::StoryEngine_var numArg 
            jmp _label31
          _label31:
            jmp _label1
            ; line 2133
          _label30:
            cmp_eq ::temp2 strArg "reportBack" 
            jmpf ::temp2 _label32
            ; line 2134
            callstatic game GetPlayer ::temp4 ;0 variable args
            cast ::temp5 ::temp4 
            cast ::temp3 numArg 
            callstatic storageUtil SetIntValue ::temp3 ::temp5 "Intel_DeliveryReportBack" ::temp3 ;3 variable args
            jmp _label1
            ; line 2135
          _label32:
            cmp_eq ::temp2 strArg "questCombat" 
            jmpf ::temp2 _label33
            ; line 2136
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label34
            ; line 2137
            cmp_gt ::temp2 numArg 0.5 
            propset QuestSubTypeCombatEnabled ::StoryEngine_var ::temp2 
            jmp _label34
          _label34:
            jmp _label1
            ; line 2139
          _label33:
            cmp_eq ::temp2 strArg "questRescue" 
            jmpf ::temp2 _label35
            ; line 2140
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label36
            ; line 2141
            cmp_gt ::temp2 numArg 0.5 
            propset QuestSubTypeRescueEnabled ::StoryEngine_var ::temp2 
            jmp _label36
          _label36:
            jmp _label1
            ; line 2143
          _label35:
            cmp_eq ::temp2 strArg "questFindItem" 
            jmpf ::temp2 _label37
            ; line 2144
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label38
            ; line 2145
            cmp_gt ::temp2 numArg 0.5 
            propset QuestSubTypeFindItemEnabled ::StoryEngine_var ::temp2 
            jmp _label38
          _label38:
            jmp _label1
            ; line 2147
          _label37:
            cmp_eq ::temp2 strArg "questFactionCombat" 
            jmpf ::temp2 _label39
            ; line 2148
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label40
            ; line 2149
            cmp_gt ::temp2 numArg 0.5 
            propset QuestSubTypeFactionCombatEnabled ::StoryEngine_var ::temp2 
            jmp _label40
          _label40:
            jmp _label1
            ; line 2151
          _label39:
            cmp_eq ::temp2 strArg "questFactionRescue" 
            jmpf ::temp2 _label41
            ; line 2152
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label42
            ; line 2153
            cmp_gt ::temp2 numArg 0.5 
            propset QuestSubTypeFactionRescueEnabled ::StoryEngine_var ::temp2 
            jmp _label42
          _label42:
            jmp _label1
            ; line 2155
          _label41:
            cmp_eq ::temp2 strArg "questFactionBattle" 
            jmpf ::temp2 _label43
            ; line 2156
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label44
            ; line 2157
            cmp_gt ::temp2 numArg 0.5 
            propset QuestSubTypeFactionBattleEnabled ::StoryEngine_var ::temp2 
            jmp _label44
          _label44:
            jmp _label1
            ; line 2159
          _label43:
            cmp_eq ::temp2 strArg "taskConfirmPrompt" 
            jmpf ::temp2 _label45
            ; line 2160
            callstatic game GetPlayer ::temp4 ;0 variable args
            cast ::temp5 ::temp4 
            cast ::temp3 numArg 
            callstatic storageUtil SetIntValue ::temp3 ::temp5 "Intel_TaskConfirmPrompt" ::temp3 ;3 variable args
            jmp _label1
            ; line 2161
          _label45:
            cmp_eq ::temp2 strArg "confirmGoToLocation" 
            jmpf ::temp2 _label46
            ; line 2162
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label47
            ; line 2163
            cast ::temp3 numArg 
            propset ConfirmGoToLocation ::StoryEngine_var ::temp3 
            jmp _label47
          _label47:
            jmp _label1
            ; line 2165
          _label46:
            cmp_eq ::temp2 strArg "confirmDeliverMessage" 
            jmpf ::temp2 _label48
            ; line 2166
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label49
            ; line 2167
            cast ::temp3 numArg 
            propset ConfirmDeliverMessage ::StoryEngine_var ::temp3 
            jmp _label49
          _label49:
            jmp _label1
            ; line 2169
          _label48:
            cmp_eq ::temp2 strArg "confirmFetchPerson" 
            jmpf ::temp2 _label50
            ; line 2170
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label51
            ; line 2171
            cast ::temp3 numArg 
            propset ConfirmFetchPerson ::StoryEngine_var ::temp3 
            jmp _label51
          _label51:
            jmp _label1
            ; line 2173
          _label50:
            cmp_eq ::temp2 strArg "confirmEscortTarget" 
            jmpf ::temp2 _label52
            ; line 2174
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label53
            ; line 2175
            cast ::temp3 numArg 
            propset ConfirmEscortTarget ::StoryEngine_var ::temp3 
            jmp _label53
          _label53:
            jmp _label1
            ; line 2177
          _label52:
            cmp_eq ::temp2 strArg "confirmSearchForActor" 
            jmpf ::temp2 _label54
            ; line 2178
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label55
            ; line 2179
            cast ::temp3 numArg 
            propset ConfirmSearchForActor ::StoryEngine_var ::temp3 
            jmp _label55
          _label55:
            jmp _label1
            ; line 2181
          _label54:
            cmp_eq ::temp2 strArg "confirmScheduleMeeting" 
            jmpf ::temp2 _label56
            ; line 2182
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label57
            ; line 2183
            cast ::temp3 numArg 
            propset ConfirmScheduleMeeting ::StoryEngine_var ::temp3 
            jmp _label57
          _label57:
            jmp _label1
            ; line 2185
          _label56:
            cmp_eq ::temp2 strArg "confirmScheduleFetch" 
            jmpf ::temp2 _label58
            ; line 2186
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label59
            ; line 2187
            cast ::temp3 numArg 
            propset ConfirmScheduleFetch ::StoryEngine_var ::temp3 
            jmp _label59
          _label59:
            jmp _label1
            ; line 2189
          _label58:
            cmp_eq ::temp2 strArg "confirmScheduleDelivery" 
            jmpf ::temp2 _label60
            ; line 2190
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label61
            ; line 2191
            cast ::temp3 numArg 
            propset ConfirmScheduleDelivery ::StoryEngine_var ::temp3 
            jmp _label61
          _label61:
            jmp _label1
            ; line 2193
          _label60:
            cmp_eq ::temp2 strArg "skipFollowerGoToLocation" 
            jmpf ::temp2 _label62
            ; line 2194
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label63
            ; line 2195
            cmp_gt ::temp2 numArg 0.5 
            propset SkipFollowerGoToLocation ::StoryEngine_var ::temp2 
            jmp _label63
          _label63:
            jmp _label1
            ; line 2197
          _label62:
            cmp_eq ::temp2 strArg "skipFollowerDeliverMessage" 
            jmpf ::temp2 _label64
            ; line 2198
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label65
            ; line 2199
            cmp_gt ::temp2 numArg 0.5 
            propset SkipFollowerDeliverMessage ::StoryEngine_var ::temp2 
            jmp _label65
          _label65:
            jmp _label1
            ; line 2201
          _label64:
            cmp_eq ::temp2 strArg "skipFollowerFetchPerson" 
            jmpf ::temp2 _label66
            ; line 2202
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label67
            ; line 2203
            cmp_gt ::temp2 numArg 0.5 
            propset SkipFollowerFetchPerson ::StoryEngine_var ::temp2 
            jmp _label67
          _label67:
            jmp _label1
            ; line 2205
          _label66:
            cmp_eq ::temp2 strArg "skipFollowerEscortTarget" 
            jmpf ::temp2 _label68
            ; line 2206
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label69
            ; line 2207
            cmp_gt ::temp2 numArg 0.5 
            propset SkipFollowerEscortTarget ::StoryEngine_var ::temp2 
            jmp _label69
          _label69:
            jmp _label1
            ; line 2209
          _label68:
            cmp_eq ::temp2 strArg "skipFollowerSearchForActor" 
            jmpf ::temp2 _label70
            ; line 2210
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label71
            ; line 2211
            cmp_gt ::temp2 numArg 0.5 
            propset SkipFollowerSearchForActor ::StoryEngine_var ::temp2 
            jmp _label71
          _label71:
            jmp _label1
            ; line 2213
          _label70:
            cmp_eq ::temp2 strArg "skipFollowerScheduleFetch" 
            jmpf ::temp2 _label72
            ; line 2214
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label73
            ; line 2215
            cmp_gt ::temp2 numArg 0.5 
            propset SkipFollowerScheduleFetch ::StoryEngine_var ::temp2 
            jmp _label73
          _label73:
            jmp _label1
            ; line 2217
          _label72:
            cmp_eq ::temp2 strArg "skipFollowerScheduleDelivery" 
            jmpf ::temp2 _label74
            ; line 2218
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label75
            ; line 2219
            cmp_gt ::temp2 numArg 0.5 
            propset SkipFollowerScheduleDelivery ::StoryEngine_var ::temp2 
            jmp _label75
          _label75:
            jmp _label1
            ; line 2221
          _label74:
            cmp_eq ::temp2 strArg "skipFollowerScheduleMeeting" 
            jmpf ::temp2 _label76
            ; line 2222
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label77
            ; line 2223
            cmp_gt ::temp2 numArg 0.5 
            propset SkipFollowerScheduleMeeting ::StoryEngine_var ::temp2 
            jmp _label77
          _label77:
            jmp _label1
            ; line 2225
          _label76:
            cmp_eq ::temp2 strArg "autoBioEnabled" 
            jmpf ::temp2 _label78
            ; line 2226
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label79
            ; line 2227
            cmp_gt ::temp2 numArg 0.5 
            propset AutoBioEnabled ::StoryEngine_var ::temp2 
            ; line 2228
            cmp_gt ::temp2 numArg 0.5 
            callstatic intelEngine SetAutoBioEnabled ::nonevar ::temp2 ;1 variable args
            jmp _label79
          _label79:
            jmp _label1
            ; line 2230
          _label78:
            cmp_eq ::temp2 strArg "autoBioThreshold" 
            jmpf ::temp2 _label80
            ; line 2231
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label81
            ; line 2232
            cast ::temp3 numArg 
            propset AutoBioThreshold ::StoryEngine_var ::temp3 
            ; line 2233
            cast ::temp3 numArg 
            callstatic intelEngine SetAutoBioThreshold ::nonevar ::temp3 ;1 variable args
            jmp _label81
          _label81:
            jmp _label1
            ; line 2235
          _label80:
            cmp_eq ::temp2 strArg "defaultWaitHours" 
            jmpf ::temp2 _label82
            ; line 2236
            callmethod SetSettingFloat self ::nonevar "Intel_MCM_DefaultWaitHours" numArg ;2 variable args
            jmp _label1
            ; line 2237
          _label82:
            cmp_eq ::temp2 strArg "meetingTimeoutHours" 
            jmpf ::temp2 _label83
            ; line 2238
            callstatic game GetPlayer ::temp4 ;0 variable args
            cast ::temp5 ::temp4 
            callstatic storageUtil SetFloatValue ::temp6 ::temp5 "Intel_MeetingTimeoutHours" numArg ;3 variable args
            jmp _label1
            ; line 2239
          _label83:
            cmp_eq ::temp2 strArg "meetingGracePeriod" 
            jmpf ::temp2 _label84
            ; line 2240
            assign ::MeetingGracePeriod_var numArg 
            jmp _label1
            ; line 2241
          _label84:
            cmp_eq ::temp2 strArg "questTimeoutDays" 
            jmpf ::temp2 _label85
            ; line 2242
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label86
            ; line 2243
            propset QUEST_EXPIRY_DAYS ::StoryEngine_var numArg 
            jmp _label86
          _label86:
            jmp _label1
            ; line 2245
          _label85:
            cmp_eq ::temp2 strArg "questAllowVictimDeath" 
            jmpf ::temp2 _label1
            ; line 2246
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label87
            ; line 2247
            cmp_gt ::temp2 numArg 0.5 
            propset QuestAllowVictimDeath ::StoryEngine_var ::temp2 
            jmp _label87
          _label87:
            jmp _label1
          _label1
          .endCode
        .endFunction ;OnDashboardSetting
        .function OnDashboardDispatchStory
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local storyType String
            .local ::temp0 String
            .local npcName String
            .local narration String
            .local response String
            .local npc actor
            .local ::temp1 actor
            .local ::temp2 Bool
            .local ::nonevar None
            .local ::temp3 String
            .local ::temp4 actor
            .local fSubject String
            .local fGossip String
            .local subjectNPC actor
            .local fSender String
          .endLocalTable
          .code
            ; line 2258
            callstatic intelEngine StoryResponseGetField ::temp0 strArg "storyType" ;2 variable args
            assign storyType ::temp0 
            ; line 2259
            callstatic intelEngine StoryResponseGetField ::temp0 strArg "npcName" ;2 variable args
            assign npcName ::temp0 
            ; line 2260
            callstatic intelEngine StoryResponseGetField ::temp0 strArg "narration" ;2 variable args
            assign narration ::temp0 
            ; line 2261
            callstatic intelEngine StoryResponseGetField ::temp0 strArg "response" ;2 variable args
            assign response ::temp0 
            ; line 2263
            callstatic intelEngine ResolveStoryCandidate ::temp1 npcName ;1 variable args
            assign npc ::temp1 
            ; line 2264
            not ::temp2 npc 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label0
            callmethod IsDead npc ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
          _label0:
            jmpf ::temp2 _label1
            ; line 2265
            strcat ::temp0 "Director: Could not find NPC '" npcName 
            strcat ::temp0 ::temp0 "' for story dispatch" 
            callmethod DebugMsg self ::nonevar ::temp0 ;1 variable args
            ; line 2266
            return None 
            jmp _label1
            ; line 2268
          _label1:
            cmp_eq ::temp2 narration "" 
            jmpf ::temp2 _label2
            ; line 2269
            callmethod DebugMsg self ::nonevar "Director: Empty narration, aborting" ;1 variable args
            ; line 2270
            return None 
            jmp _label2
            ; line 2272
          _label2:
            not ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label3
            ; line 2273
            callmethod DebugMsg self ::nonevar "Director: StoryEngine not available" ;1 variable args
            ; line 2274
            return None 
            jmp _label3
            ; line 2277
          _label3:
            strcat ::temp0 "Director: Dispatching " storyType 
            strcat ::temp0 ::temp0 " with " 
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 ::temp0 ::temp3 
            strcat ::temp3 ::temp3 " - " 
            strcat ::temp3 ::temp3 narration 
            callmethod DebugMsg self ::nonevar ::temp3 ;1 variable args
            ; line 2280
            cmp_eq ::temp2 storyType "message" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label4
            ; line 2281
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName npc ::temp3 ;0 variable args
            strcat ::temp3 ::temp3 " set out to find " 
            callstatic game GetPlayer ::temp4 ;0 variable args
            callmethod GetDisplayName ::temp4 ::temp0 ;0 variable args
            strcat ::temp0 ::temp3 ::temp0 
            callmethod SendPersistentMemory self ::nonevar npc ::temp1 ::temp0 ;3 variable args
            jmp _label4
            ; line 2286
          _label4:
            cmp_eq ::temp2 storyType "seek_player" 
            jmpf ::temp2 _label5
            ; line 2287
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod GetDisplayName ::temp1 ::temp0 ;0 variable args
            strcat ::temp0 "set out to find " ::temp0 
            strcat ::temp0 ::temp0 " -- " 
            strcat ::temp0 ::temp0 narration 
            callmethod InjectFact self ::nonevar npc ::temp0 ;2 variable args
            ; line 2288
            propset ActiveStoryType ::StoryEngine_var storyType 
            ; line 2289
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod DispatchToTarget ::StoryEngine_var ::nonevar npc ::temp1 narration "story" ;4 variable args
            jmp _label6
            ; line 2291
          _label5:
            cmp_eq ::temp2 storyType "informant" 
            jmpf ::temp2 _label7
            ; line 2292
            callmethod ExtractJsonField ::StoryEngine_var ::temp0 response "subject" ;2 variable args
            assign fSubject ::temp0 
            ; line 2293
            callmethod ExtractJsonField ::StoryEngine_var ::temp0 response "gossip" ;2 variable args
            assign fGossip ::temp0 
            ; line 2294
            cmp_eq ::temp2 fSubject "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label8
            cmp_eq ::temp2 fGossip "" 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label8:
            jmpf ::temp2 _label9
            ; line 2295
            callstatic intelEngine FindNPCByName ::temp1 fSubject ;1 variable args
            assign subjectNPC ::temp1 
            ; line 2296
            cast ::temp2 subjectNPC 
            jmpf ::temp2 _label10
            ; line 2297
            callmethod InjectFact self ::nonevar subjectNPC fGossip ;2 variable args
            jmp _label10
            ; line 2299
          _label10:
            callmethod ExtractJsonField ::StoryEngine_var ::temp0 response "sender" ;2 variable args
            assign fSender ::temp0 
            ; line 2300
            cmp_eq ::temp2 fSender "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label11
            ; line 2301
            strcat ::temp0 "heard from " fSender 
            strcat ::temp0 ::temp0 " that " 
            strcat ::temp0 ::temp0 fSubject 
            strcat ::temp0 ::temp0 " " 
            strcat ::temp0 ::temp0 fGossip 
            callmethod InjectFact self ::nonevar npc ::temp0 ;2 variable args
            jmp _label12
            ; line 2303
          _label11:
            strcat ::temp0 "witnessed that " fSubject 
            strcat ::temp0 ::temp0 " " 
            strcat ::temp0 ::temp0 fGossip 
            callmethod InjectFact self ::nonevar npc ::temp0 ;2 variable args
          _label12:
            jmp _label9
            ; line 2306
          _label9:
            propset ActiveStoryType ::StoryEngine_var "informant" 
            ; line 2307
            callstatic game GetPlayer ::temp1 ;0 variable args
            callmethod DispatchToTarget ::StoryEngine_var ::nonevar npc ::temp1 narration "story" ;4 variable args
            jmp _label6
            ; line 2309
          _label7:
            cmp_eq ::temp2 storyType "ambush" 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label13
            cmp_eq ::temp2 storyType "stalker" 
            assign ::temp2 ::temp2 
          _label13:
            jmpf ::temp2 _label14
            ; line 2310
            callmethod HandleAmbushStalkerDispatch ::StoryEngine_var ::nonevar npc narration response storyType ;4 variable args
            jmp _label6
            ; line 2312
          _label14:
            cmp_eq ::temp2 storyType "quest" 
            jmpf ::temp2 _label15
            ; line 2313
            callmethod HandleQuestDispatch ::StoryEngine_var ::nonevar npc narration response ;3 variable args
            jmp _label6
            ; line 2315
          _label15:
            cmp_eq ::temp2 storyType "message" 
            jmpf ::temp2 _label16
            ; line 2316
            callmethod HandleMessageDispatch ::StoryEngine_var ::nonevar npc narration response ;3 variable args
            jmp _label6
            ; line 2318
          _label16:
            cmp_eq ::temp2 storyType "road_encounter" 
            jmpf ::temp2 _label17
            ; line 2319
            callmethod InjectFact self ::nonevar npc narration ;2 variable args
            ; line 2320
            callmethod ExtractJsonField ::StoryEngine_var ::temp0 response "destination" ;2 variable args
            callmethod PlaceRoadEncounter ::StoryEngine_var ::nonevar npc narration ::temp0 ;3 variable args
            jmp _label6
            ; line 2323
          _label17:
            strcat ::temp0 "Director: unknown story type '" storyType 
            strcat ::temp0 ::temp0 "'" 
            callmethod DebugMsg self ::nonevar ::temp0 ;1 variable args
            ; line 2326
          _label6:
            callmethod PushDashboardState self ::nonevar ;0 variable args
          .endCode
        .endFunction ;OnDashboardDispatchStory
        .function OnDashboardDispatchNpcSocial
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local socialType String
            .local ::temp0 String
            .local npc1Name String
            .local npc2Name String
            .local narration String
            .local response String
            .local npc1 actor
            .local ::temp1 actor
            .local npc2 actor
            .local ::temp2 Bool
            .local ::nonevar None
            .local fact1 String
            .local fact2 String
            .local gossip String
            .local dist Float
            .local ::temp3 objectReference
            .local ::temp4 Float
          .endLocalTable
          .code
            ; line 2336
            callstatic intelEngine StoryResponseGetField ::temp0 strArg "socialType" ;2 variable args
            assign socialType ::temp0 
            ; line 2337
            callstatic intelEngine StoryResponseGetField ::temp0 strArg "npc1Name" ;2 variable args
            assign npc1Name ::temp0 
            ; line 2338
            callstatic intelEngine StoryResponseGetField ::temp0 strArg "npc2Name" ;2 variable args
            assign npc2Name ::temp0 
            ; line 2339
            callstatic intelEngine StoryResponseGetField ::temp0 strArg "narration" ;2 variable args
            assign narration ::temp0 
            ; line 2340
            callstatic intelEngine StoryResponseGetField ::temp0 strArg "response" ;2 variable args
            assign response ::temp0 
            ; line 2342
            callstatic intelEngine FindNPCByName ::temp1 npc1Name ;1 variable args
            assign npc1 ::temp1 
            ; line 2343
            callstatic intelEngine FindNPCByName ::temp1 npc2Name ;1 variable args
            assign npc2 ::temp1 
            ; line 2344
            not ::temp2 npc1 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label0
            callmethod IsDead npc1 ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
          _label0:
            jmpf ::temp2 _label1
            ; line 2345
            strcat ::temp0 "Director: Could not find NPC 1 '" npc1Name 
            strcat ::temp0 ::temp0 "' for social dispatch" 
            callmethod DebugMsg self ::nonevar ::temp0 ;1 variable args
            ; line 2346
            return None 
            jmp _label1
            ; line 2348
          _label1:
            not ::temp2 npc2 
            assign ::temp2 ::temp2 
            jmpt ::temp2 _label2
            callmethod IsDead npc2 ::temp2 ;0 variable args
            assign ::temp2 ::temp2 
          _label2:
            jmpf ::temp2 _label3
            ; line 2349
            strcat ::temp0 "Director: Could not find NPC 2 '" npc2Name 
            strcat ::temp0 ::temp0 "' for social dispatch" 
            callmethod DebugMsg self ::nonevar ::temp0 ;1 variable args
            ; line 2350
            return None 
            jmp _label3
            ; line 2353
          _label3:
            strcat ::temp0 "Director: NPC Social " socialType 
            strcat ::temp0 ::temp0 " — " 
            strcat ::temp0 ::temp0 npc1Name 
            strcat ::temp0 ::temp0 " -> " 
            strcat ::temp0 ::temp0 npc2Name 
            strcat ::temp0 ::temp0 ": " 
            strcat ::temp0 ::temp0 narration 
            callmethod DebugMsg self ::nonevar ::temp0 ;1 variable args
            ; line 2355
            cmp_eq ::temp2 socialType "npc_interaction" 
            jmpf ::temp2 _label4
            ; line 2356
            callmethod ExtractJsonField ::StoryEngine_var ::temp0 response "fact1" ;2 variable args
            assign fact1 ::temp0 
            ; line 2357
            callmethod ExtractJsonField ::StoryEngine_var ::temp0 response "fact2" ;2 variable args
            assign fact2 ::temp0 
            ; line 2358
            cmp_eq ::temp2 fact1 "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label5
            ; line 2359
            callmethod InjectFact self ::nonevar npc1 fact1 ;2 variable args
            jmp _label5
            ; line 2361
          _label5:
            cmp_eq ::temp2 fact2 "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label6
            ; line 2362
            callmethod InjectFact self ::nonevar npc2 fact2 ;2 variable args
            jmp _label6
            ; line 2364
          _label6:
            callmethod AddNPCSocialLog ::StoryEngine_var ::nonevar "npc_interaction" npc1Name npc2Name narration npc1 "" ;6 variable args
            ; line 2365
            strcat ::temp0 "npc_interaction: " npc1Name 
            strcat ::temp0 ::temp0 " and " 
            strcat ::temp0 ::temp0 npc2Name 
            strcat ::temp0 ::temp0 " — " 
            strcat ::temp0 ::temp0 narration 
            callmethod AddRecentStoryEvent ::StoryEngine_var ::nonevar ::temp0 ;1 variable args
            jmp _label7
            ; line 2367
          _label4:
            cmp_eq ::temp2 socialType "npc_gossip" 
            jmpf ::temp2 _label7
            ; line 2368
            callmethod ExtractJsonField ::StoryEngine_var ::temp0 response "gossip" ;2 variable args
            assign gossip ::temp0 
            ; line 2369
            cmp_eq ::temp2 gossip "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label8
            ; line 2370
            strcat ::temp0 "told " npc2Name 
            strcat ::temp0 ::temp0 " that someone " 
            strcat ::temp0 ::temp0 gossip 
            callmethod InjectFact self ::nonevar npc1 ::temp0 ;2 variable args
            ; line 2371
            strcat ::temp0 "heard from " npc1Name 
            strcat ::temp0 ::temp0 " that someone " 
            strcat ::temp0 ::temp0 gossip 
            callmethod InjectFact self ::nonevar npc2 ::temp0 ;2 variable args
            jmp _label8
            ; line 2373
          _label8:
            callmethod AddNPCSocialLog ::StoryEngine_var ::nonevar "npc_gossip" npc1Name npc2Name narration npc1 "" ;6 variable args
            ; line 2374
            strcat ::temp0 "npc_gossip: " npc1Name 
            strcat ::temp0 ::temp0 " told " 
            strcat ::temp0 ::temp0 npc2Name 
            strcat ::temp0 ::temp0 " — " 
            strcat ::temp0 ::temp0 narration 
            callmethod AddRecentStoryEvent ::StoryEngine_var ::nonevar ::temp0 ;1 variable args
            jmp _label7
            ; line 2378
          _label7:
            cast ::temp3 npc2 
            callmethod GetDistance npc1 ::temp4 ::temp3 ;1 variable args
            assign dist ::temp4 
            ; line 2379
            cmp_lt ::temp2 dist 5000.0 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label9
            cmp_gt ::temp2 dist 200.0 
            assign ::temp2 ::temp2 
          _label9:
            jmpf ::temp2 _label10
            ; line 2380
            callmethod DispatchNPCSocial ::StoryEngine_var ::nonevar npc1 npc2 narration socialType ;4 variable args
            jmp _label11
            ; line 2382
          _label10:
            callmethod DebugMsg self ::nonevar "Director: NPCs too far apart or already close — applied off-screen" ;1 variable args
            ; line 2385
          _label11:
            callmethod PushDashboardState self ::nonevar ;0 variable args
          .endCode
        .endFunction ;OnDashboardDispatchNpcSocial
        .function OnDashboardDispatchPolitics
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local ::nonevar None
            .local ::temp0 String
            .local ::temp1 Int
            .local ::temp2 String
            .local ::temp3 Bool
          .endLocalTable
          .code
            ; line 2394
            strcat ::temp0 "Director: Political event received — eventName=" eventName 
            strcat ::temp0 ::temp0 " strArg length=" 
            callstatic stringUtil GetLength ::temp1 strArg ;1 variable args
            cast ::temp2 ::temp1 
            strcat ::temp2 ::temp0 ::temp2 
            callmethod DebugMsg self ::nonevar ::temp2 ;1 variable args
            ; line 2395
            cast ::temp3 ::Politics_var 
            jmpf ::temp3 _label0
            ; line 2396
            callmethod DebugMsg self ::nonevar "Director: Forwarding to Politics.OnPoliticalDMResponse" ;1 variable args
            ; line 2398
            callstatic intelEngine ResetManifestationCooldown ::nonevar ;0 variable args
            ; line 2399
            callmethod OnPoliticalDMResponse ::Politics_var ::nonevar strArg 1 ;2 variable args
            ; line 2400
            callmethod DebugMsg self ::nonevar "Director: Politics.OnPoliticalDMResponse returned" ;1 variable args
            jmp _label1
            ; line 2402
          _label0:
            callmethod DebugMsg self ::nonevar "Director: Politics script not available (property is None)" ;1 variable args
            ; line 2404
          _label1:
            callmethod PushDashboardState self ::nonevar ;0 variable args
          .endCode
        .endFunction ;OnDashboardDispatchPolitics
        .function OnDashboardExecuteAction
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
            .param eventName String
            .param strArg String
            .param numArg Float
            .param sender form
          .endParamTable
          .localTable
            .local actionName String
            .local ::temp0 String
            .local npc actor
            .local ::temp1 Int
            .local ::temp2 form
            .local ::temp3 actor
            .local ::temp4 Bool
            .local ::nonevar None
            .local ::temp5 String
            .local destination String
            .local speed Int
            .local waitFP Int
            .local targetName String
            .local failReason String
            .local ::mangled_targetName_0 String
            .local ::mangled_speed_0 Int
            .local ::mangled_targetName_1 String
            .local msgContent String
            .local meetLoc String
            .local meetTime String
            .local ::mangled_targetName_2 String
            .local ::mangled_destination_0 String
            .local shouldWait Int
            .local newSpeed Int
            .local ::mangled_destination_1 String
            .local timeCond String
            .local ::mangled_targetName_3 String
            .local ::mangled_timeCond_0 String
            .local ::mangled_targetName_4 String
            .local ::mangled_msgContent_0 String
            .local ::mangled_timeCond_1 String
            .local ::mangled_meetLoc_0 String
            .local ::mangled_meetTime_0 String
          .endLocalTable
          .code
            ; line 2412
            callstatic intelEngine StoryResponseGetField ::temp0 strArg "actionName" ;2 variable args
            assign actionName ::temp0 
            ; line 2413
            cast ::temp1 numArg 
            callstatic game GetForm ::temp2 ::temp1 ;1 variable args
            cast ::temp3 ::temp2 
            assign npc ::temp3 
            ; line 2415
            not ::temp4 npc 
            assign ::temp4 ::temp4 
            jmpt ::temp4 _label0
            callmethod IsDead npc ::temp4 ;0 variable args
            assign ::temp4 ::temp4 
          _label0:
            jmpf ::temp4 _label1
            ; line 2416
            callmethod DebugMsg self ::nonevar "Director: Invalid or dead NPC for action execution" ;1 variable args
            ; line 2417
            return None 
            jmp _label1
            ; line 2420
          _label1:
            strcat ::temp0 "Director: Executing " actionName 
            strcat ::temp0 ::temp0 " on " 
            callmethod GetDisplayName npc ::temp5 ;0 variable args
            strcat ::temp5 ::temp0 ::temp5 
            callmethod DebugMsg self ::nonevar ::temp5 ;1 variable args
            ; line 2422
            cmp_eq ::temp4 actionName "GoToLocation" 
            jmpf ::temp4 _label2
            ; line 2423
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "destination" ;2 variable args
            assign destination ::temp5 
            ; line 2424
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "speed" ;2 variable args
            cast ::temp1 ::temp5 
            assign speed ::temp1 
            ; line 2425
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "waitForPlayer" ;2 variable args
            cast ::temp1 ::temp5 
            assign waitFP ::temp1 
            ; line 2426
            callmethod GoToLocation ::Travel_var ::temp4 npc destination speed waitFP False ;5 variable args
            jmp _label3
            ; line 2428
          _label2:
            cmp_eq ::temp4 actionName "FetchPerson" 
            jmpf ::temp4 _label4
            ; line 2429
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "targetName" ;2 variable args
            assign targetName ::temp5 
            ; line 2430
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "failReason" ;2 variable args
            assign failReason ::temp5 
            ; line 2431
            cmp_eq ::temp4 failReason "" 
            jmpf ::temp4 _label5
            ; line 2432
            assign failReason "none" 
            jmp _label5
            ; line 2434
          _label5:
            callmethod FetchNPC ::NPCTasks_var ::temp4 npc targetName failReason ;3 variable args
            jmp _label3
            ; line 2436
          _label4:
            cmp_eq ::temp4 actionName "SearchForActor" 
            jmpf ::temp4 _label6
            ; line 2437
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "targetName" ;2 variable args
            assign ::mangled_targetName_0 ::temp5 
            ; line 2438
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "speed" ;2 variable args
            cast ::temp1 ::temp5 
            assign ::mangled_speed_0 ::temp1 
            ; line 2439
            callmethod SearchForActor ::NPCTasks_var ::temp4 npc ::mangled_targetName_0 ::mangled_speed_0 ;3 variable args
            jmp _label3
            ; line 2441
          _label6:
            cmp_eq ::temp4 actionName "DeliverMessage" 
            jmpf ::temp4 _label7
            ; line 2442
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "targetName" ;2 variable args
            assign ::mangled_targetName_1 ::temp5 
            ; line 2443
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "msgContent" ;2 variable args
            assign msgContent ::temp5 
            ; line 2444
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "meetLocation" ;2 variable args
            assign meetLoc ::temp5 
            ; line 2445
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "meetTime" ;2 variable args
            assign meetTime ::temp5 
            ; line 2446
            cmp_eq ::temp4 meetLoc "" 
            jmpf ::temp4 _label8
            ; line 2447
            assign meetLoc "none" 
            jmp _label8
            ; line 2449
          _label8:
            cmp_eq ::temp4 meetTime "" 
            jmpf ::temp4 _label9
            ; line 2450
            assign meetTime "none" 
            jmp _label9
            ; line 2452
          _label9:
            callmethod DeliverMessage ::NPCTasks_var ::temp4 npc ::mangled_targetName_1 msgContent meetLoc meetTime ;5 variable args
            jmp _label3
            ; line 2454
          _label7:
            cmp_eq ::temp4 actionName "EscortTarget" 
            jmpf ::temp4 _label10
            ; line 2455
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "targetName" ;2 variable args
            assign ::mangled_targetName_2 ::temp5 
            ; line 2456
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "destination" ;2 variable args
            assign ::mangled_destination_0 ::temp5 
            ; line 2457
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "shouldWait" ;2 variable args
            cast ::temp1 ::temp5 
            assign shouldWait ::temp1 
            ; line 2458
            cmp_eq ::temp4 ::mangled_destination_0 "" 
            jmpf ::temp4 _label11
            ; line 2459
            assign ::mangled_destination_0 "home" 
            jmp _label11
            ; line 2461
          _label11:
            callmethod EscortTarget ::NPCTasks_var ::temp4 npc ::mangled_targetName_2 ::mangled_destination_0 shouldWait ;4 variable args
            jmp _label3
            ; line 2463
          _label10:
            cmp_eq ::temp4 actionName "CancelCurrentTask" 
            jmpf ::temp4 _label12
            ; line 2464
            callmethod CancelCurrentTask self ::temp4 npc ;1 variable args
            jmp _label3
            ; line 2466
          _label12:
            cmp_eq ::temp4 actionName "ChangeSpeed" 
            jmpf ::temp4 _label13
            ; line 2467
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "newSpeed" ;2 variable args
            cast ::temp1 ::temp5 
            assign newSpeed ::temp1 
            ; line 2468
            callmethod ChangeTaskSpeed self ::temp4 npc newSpeed ;2 variable args
            jmp _label3
            ; line 2470
          _label13:
            cmp_eq ::temp4 actionName "ScheduleMeeting" 
            jmpf ::temp4 _label14
            ; line 2471
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "destination" ;2 variable args
            assign ::mangled_destination_1 ::temp5 
            ; line 2472
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "timeCondition" ;2 variable args
            assign timeCond ::temp5 
            ; line 2473
            callmethod ScheduleMeeting ::Schedule_var ::temp4 npc ::mangled_destination_1 timeCond ;3 variable args
            jmp _label3
            ; line 2475
          _label14:
            cmp_eq ::temp4 actionName "ScheduleFetch" 
            jmpf ::temp4 _label15
            ; line 2476
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "targetName" ;2 variable args
            assign ::mangled_targetName_3 ::temp5 
            ; line 2477
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "timeCondition" ;2 variable args
            assign ::mangled_timeCond_0 ::temp5 
            ; line 2478
            callmethod ScheduleFetch ::Schedule_var ::temp4 npc ::mangled_targetName_3 ::mangled_timeCond_0 ;3 variable args
            jmp _label3
            ; line 2480
          _label15:
            cmp_eq ::temp4 actionName "ScheduleDelivery" 
            jmpf ::temp4 _label16
            ; line 2481
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "targetName" ;2 variable args
            assign ::mangled_targetName_4 ::temp5 
            ; line 2482
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "msgContent" ;2 variable args
            assign ::mangled_msgContent_0 ::temp5 
            ; line 2483
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "timeCondition" ;2 variable args
            assign ::mangled_timeCond_1 ::temp5 
            ; line 2484
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "meetLocation" ;2 variable args
            assign ::mangled_meetLoc_0 ::temp5 
            ; line 2485
            callstatic intelEngine StoryResponseGetField ::temp5 strArg "meetTime" ;2 variable args
            assign ::mangled_meetTime_0 ::temp5 
            ; line 2486
            cmp_eq ::temp4 ::mangled_meetLoc_0 "" 
            jmpf ::temp4 _label17
            ; line 2487
            assign ::mangled_meetLoc_0 "none" 
            jmp _label17
            ; line 2489
          _label17:
            cmp_eq ::temp4 ::mangled_meetTime_0 "" 
            jmpf ::temp4 _label18
            ; line 2490
            assign ::mangled_meetTime_0 "none" 
            jmp _label18
            ; line 2492
          _label18:
            callmethod ScheduleDelivery ::Schedule_var ::temp4 npc ::mangled_targetName_4 ::mangled_msgContent_0 ::mangled_timeCond_1 ::mangled_meetLoc_0 ::mangled_meetTime_0 ;6 variable args
            jmp _label3
            ; line 2495
          _label16:
            strcat ::temp5 "Director: Unknown action " actionName 
            callmethod DebugMsg self ::nonevar ::temp5 ;1 variable args
            ; line 2498
          _label3:
            callstatic utility Wait ::nonevar 0.5 ;1 variable args
            ; line 2499
            callmethod PushDashboardState self ::nonevar ;0 variable args
          .endCode
        .endFunction ;OnDashboardExecuteAction
        .function PushDashboardState
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return None
          .paramTable
          .endParamTable
          .localTable
            .local ::temp0 Bool
            .local json String
            .local ::temp1 String
            .local ::nonevar None
          .endLocalTable
          .code
            ; line 2503
            callstatic intelEngine IsDashboardOpen ::temp0 ;0 variable args
            not ::temp0 ::temp0 
            jmpf ::temp0 _label0
            ; line 2504
            return None 
            jmp _label0
            ; line 2507
          _label0:
            callmethod BuildDashboardStateJson self ::temp1 ;0 variable args
            assign json ::temp1 
            ; line 2508
            callstatic intelEngine PushDashboardFullState ::nonevar json ;1 variable args
          .endCode
        .endFunction ;PushDashboardState
        .function BuildDashboardStateJson
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
          .endParamTable
          .localTable
            .local json String
            .local ::temp0 String
            .local i Int
            .local ::temp1 Int
            .local ::temp2 Bool
            .local agent actor
            .local ::temp3 referenceAlias
            .local ::temp4 actor
            .local first Bool
            .local schedAgent String
            .local storyInterval Float
            .local ::temp5 Float
            .local nextCheck Float
            .local intervalDays Float
            .local ::temp6 Float
            .local logPlayer actor
            .local logCount Int
            .local ::temp7 form
            .local li Int
            .local logFirst Bool
            .local pkgFormIDs Int[]
            .local ::temp8 Int[]
          .endLocalTable
          .code
            ; line 2514
            assign json "{" 
            ; line 2517
            strcat ::temp0 json "\"tasks\":[" 
            assign json ::temp0 
            ; line 2518
            assign i 0 
            ; line 2519
          _label5:
            propget MAX_SLOTS self ::temp1 
            cmp_lt ::temp2 i ::temp1 
            jmpf ::temp2 _label0
            ; line 2520
            cmp_gt ::temp2 i 0 
            jmpf ::temp2 _label1
            ; line 2521
            strcat ::temp0 json "," 
            assign json ::temp0 
            jmp _label1
            ; line 2523
          _label1:
            strcat ::temp0 json "{" 
            assign json ::temp0 
            ; line 2524
            cast ::temp0 i 
            strcat ::temp0 "\"index\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2525
            array_getlement ::temp1 ::SlotStates_var i 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"state\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2526
            array_getlement ::temp0 ::SlotTaskTypes_var i 
            strcat ::temp0 ",\"taskType\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2527
            array_getlement ::temp0 ::SlotTargetNames_var i 
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"targetName\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2529
            callmethod GetAgentAlias self ::temp3 i ;1 variable args
            callmethod GetActorReference ::temp3 ::temp4 ;0 variable args
            assign agent ::temp4 
            ; line 2530
            cast ::temp4 None 
            cmp_eq ::temp2 agent ::temp4 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label2
            array_getlement ::temp1 ::SlotStates_var i 
            cmp_eq ::temp2 ::temp1 0 
            not ::temp2 ::temp2 
            assign ::temp2 ::temp2 
          _label2:
            jmpf ::temp2 _label3
            ; line 2531
            callmethod GetDisplayName agent ::temp0 ;0 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"agentName\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2532
            callmethod GetFormID agent ::temp1 ;0 variable args
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"agentFormId\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            jmp _label4
            ; line 2534
          _label3:
            strcat ::temp0 json ",\"agentName\":\"\",\"agentFormId\":0" 
            assign json ::temp0 
            ; line 2536
          _label4:
            strcat ::temp0 json ",\"cooldownRemaining\":0" 
            assign json ::temp0 
            ; line 2537
            array_getlement ::temp1 ::SlotSpeeds_var i 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"speed\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2538
            strcat ::temp0 json "}" 
            assign json ::temp0 
            ; line 2539
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label5
            ; line 2541
          _label0:
            strcat ::temp0 json "]" 
            assign json ::temp0 
            ; line 2544
            strcat ::temp0 json ",\"scheduled\":[" 
            assign json ::temp0 
            ; line 2545
            cast ::temp2 ::Schedule_var 
            jmpf ::temp2 _label6
            ; line 2546
            assign i 0 
            ; line 2547
            assign first True 
            ; line 2548
          _label10:
            propget MAX_SCHEDULED ::Schedule_var ::temp1 
            cmp_lt ::temp2 i ::temp1 
            jmpf ::temp2 _label7
            ; line 2549
            callmethod GetScheduleAgentName ::Schedule_var ::temp0 i ;1 variable args
            assign schedAgent ::temp0 
            ; line 2550
            cmp_eq ::temp2 schedAgent "" 
            not ::temp2 ::temp2 
            jmpf ::temp2 _label8
            ; line 2551
            not ::temp2 first 
            jmpf ::temp2 _label9
            ; line 2552
            strcat ::temp0 json "," 
            assign json ::temp0 
            jmp _label9
            ; line 2554
          _label9:
            assign first False 
            ; line 2555
            strcat ::temp0 json "{" 
            assign json ::temp0 
            ; line 2556
            callmethod EscapeJson self ::temp0 schedAgent ;1 variable args
            strcat ::temp0 "\"agent\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2557
            callmethod GetScheduleDestination ::Schedule_var ::temp0 i ;1 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"destination\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2558
            callmethod GetScheduleTaskType ::Schedule_var ::temp0 i ;1 variable args
            strcat ::temp0 ",\"taskType\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2559
            callmethod GetScheduleTargetName ::Schedule_var ::temp0 i ;1 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"targetName\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2560
            callmethod GetScheduleDisplay ::Schedule_var ::temp0 i ;1 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"timeDesc\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2561
            callmethod GetScheduleStatus ::Schedule_var ::temp0 i ;1 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"schedStatus\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2562
            callmethod GetScheduleSlotState ::Schedule_var ::temp1 i ;1 variable args
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"schedState\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2563
            strcat ::temp0 json "}" 
            assign json ::temp0 
            jmp _label8
            ; line 2565
          _label8:
            iadd ::temp1 i 1 
            assign i ::temp1 
            jmp _label10
          _label7:
            jmp _label6
            ; line 2568
          _label6:
            strcat ::temp0 json "]" 
            assign json ::temp0 
            ; line 2571
            strcat ::temp0 json ",\"story\":{" 
            assign json ::temp0 
            ; line 2572
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label11
            ; line 2573
            callmethod IsStoryEngineEnabled self ::temp2 ;0 variable args
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 "\"enabled\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2574
            propget IsActive ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"isActive\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2575
            propget ActiveStoryNPC ::StoryEngine_var ::temp4 
            callmethod GetActorName self ::temp0 ::temp4 ;1 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"activeNPC\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2576
            propget ActiveStoryType ::StoryEngine_var ::temp0 
            strcat ::temp0 ",\"activeType\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2577
            propget ActiveNarration ::StoryEngine_var ::temp0 
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"activeNarration\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2578
            callmethod GetStoryEngineInterval self ::temp5 ;0 variable args
            assign storyInterval ::temp5 
            ; line 2579
            cast ::temp0 storyInterval 
            strcat ::temp0 ",\"interval\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2580
            callmethod GetStoryEngineCooldown self ::temp5 ;0 variable args
            cast ::temp0 ::temp5 
            strcat ::temp0 ",\"cooldown\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2582
            assign nextCheck 0.0 
            ; line 2583
            propget LastStoryTickTime ::StoryEngine_var ::temp5 
            cmp_gt ::temp2 ::temp5 0.0 
            jmpf ::temp2 _label12
            ; line 2584
            fdiv ::temp5 storyInterval 24.0 
            assign intervalDays ::temp5 
            ; line 2585
            propget LastStoryTickTime ::StoryEngine_var ::temp5 
            fadd ::temp5 ::temp5 intervalDays 
            callstatic utility GetCurrentGameTime ::temp6 ;0 variable args
            fsub ::temp6 ::temp5 ::temp6 
            fmul ::temp6 ::temp6 24.0 
            assign nextCheck ::temp6 
            ; line 2586
            cmp_lt ::temp2 nextCheck 0.0 
            jmpf ::temp2 _label13
            ; line 2587
            assign nextCheck 0.0 
            jmp _label13
          _label13:
            jmp _label12
            ; line 2590
          _label12:
            cast ::temp0 nextCheck 
            strcat ::temp0 ",\"nextCheckIn\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2593
            strcat ::temp0 json ",\"types\":{" 
            assign json ::temp0 
            ; line 2594
            propget TypeSeekPlayerEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 "\"seek_player\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2595
            propget TypeInformantEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"informant\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2596
            propget TypeRoadEncounterEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"road_encounter\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2597
            propget TypeAmbushEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"ambush\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2598
            propget TypeFactionAmbushEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"faction_ambush\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2599
            propget TypeStalkerEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"stalker\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2600
            propget TypeMessageEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"message\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2601
            propget TypeQuestEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"quest\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2602
            propget TypeNPCInteractionEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"npc_interaction\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2603
            propget TypeNPCGossipEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"npc_gossip\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2604
            strcat ::temp0 json "}" 
            assign json ::temp0 
            jmp _label14
            ; line 2606
          _label11:
            strcat ::temp0 json "\"enabled\":false,\"isActive\":false,\"activeNPC\":\"\",\"activeType\":\"\"" 
            assign json ::temp0 
            ; line 2607
            strcat ::temp0 json ",\"interval\":3,\"cooldown\":24,\"types\":{}" 
            assign json ::temp0 
            ; line 2609
          _label14:
            strcat ::temp0 json "}" 
            assign json ::temp0 
            ; line 2612
            strcat ::temp0 json ",\"quest\":{" 
            assign json ::temp0 
            ; line 2613
            cast ::temp2 ::StoryEngine_var 
            assign ::temp2 ::temp2 
            jmpf ::temp2 _label15
            propget QuestActive ::StoryEngine_var ::temp2 
            assign ::temp2 ::temp2 
          _label15:
            jmpf ::temp2 _label16
            ; line 2614
            strcat ::temp0 json "\"active\":true" 
            assign json ::temp0 
            ; line 2615
            propget QuestGiver ::StoryEngine_var ::temp4 
            callmethod GetActorName self ::temp0 ::temp4 ;1 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"giver\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2616
            propget QuestLocationName ::StoryEngine_var ::temp0 
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"location\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2617
            propget QuestSubType ::StoryEngine_var ::temp0 
            strcat ::temp0 ",\"subType\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2618
            propget QuestEnemyType ::StoryEngine_var ::temp0 
            strcat ::temp0 ",\"enemyType\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2619
            propget QuestEnemiesSpawned ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"enemiesSpawned\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2620
            propget QuestVictimName ::StoryEngine_var ::temp0 
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"victimName\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2621
            propget QuestVictimFreed ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"victimFreed\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2622
            propget QuestItemName ::StoryEngine_var ::temp0 
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"itemName\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2623
            propget QuestGuideActive ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"guideActive\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            jmp _label17
            ; line 2625
          _label16:
            strcat ::temp0 json "\"active\":false" 
            assign json ::temp0 
            ; line 2627
          _label17:
            strcat ::temp0 json "}" 
            assign json ::temp0 
            ; line 2630
            strcat ::temp0 json ",\"social\":{" 
            assign json ::temp0 
            ; line 2631
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label18
            ; line 2632
            propget NPCTickEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 "\"enabled\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2633
            propget IsNPCStoryActive ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"isActive\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2634
            propget NPCSocialTraveler ::StoryEngine_var ::temp4 
            callmethod GetActorName self ::temp0 ::temp4 ;1 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"traveler\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2635
            propget NPCSocialTarget ::StoryEngine_var ::temp4 
            callmethod GetActorName self ::temp0 ::temp4 ;1 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"target\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2636
            propget NPCSocialType ::StoryEngine_var ::temp0 
            strcat ::temp0 ",\"type\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2637
            propget NPCSocialNarration ::StoryEngine_var ::temp0 
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"narration\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            jmp _label19
            ; line 2639
          _label18:
            strcat ::temp0 json "\"enabled\":false,\"isActive\":false,\"traveler\":\"\",\"target\":\"\",\"type\":\"\"" 
            assign json ::temp0 
            ; line 2641
          _label19:
            strcat ::temp0 json "}" 
            assign json ::temp0 
            ; line 2644
            callstatic game GetPlayer ::temp4 ;0 variable args
            assign logPlayer ::temp4 
            ; line 2645
            cast ::temp7 logPlayer 
            callstatic storageUtil StringListCount ::temp1 ::temp7 "Intel_SocialLog_Type" ;2 variable args
            assign logCount ::temp1 
            ; line 2646
            strcat ::temp0 json ",\"npcSocialLog\":[" 
            assign json ::temp0 
            ; line 2648
            isub ::temp1 logCount 1 
            assign li ::temp1 
            ; line 2649
            assign logFirst True 
            ; line 2650
          _label22:
            comp_gte ::temp2 li 0 
            jmpf ::temp2 _label20
            ; line 2651
            not ::temp2 logFirst 
            jmpf ::temp2 _label21
            ; line 2652
            strcat ::temp0 json "," 
            assign json ::temp0 
            jmp _label21
            ; line 2654
          _label21:
            assign logFirst False 
            ; line 2655
            strcat ::temp0 json "{" 
            assign json ::temp0 
            ; line 2656
            cast ::temp7 logPlayer 
            callstatic storageUtil StringListGet ::temp0 ::temp7 "Intel_SocialLog_Type" li ;3 variable args
            strcat ::temp0 "\"type\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2657
            cast ::temp7 logPlayer 
            callstatic storageUtil StringListGet ::temp0 ::temp7 "Intel_SocialLog_NPC1" li ;3 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"npc1\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2658
            cast ::temp7 logPlayer 
            callstatic storageUtil StringListGet ::temp0 ::temp7 "Intel_SocialLog_NPC2" li ;3 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"npc2\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2659
            cast ::temp7 logPlayer 
            callstatic storageUtil StringListGet ::temp0 ::temp7 "Intel_SocialLog_Text" li ;3 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"text\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2660
            cast ::temp7 logPlayer 
            callstatic storageUtil StringListGet ::temp0 ::temp7 "Intel_SocialLog_Location" li ;3 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"location\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2661
            cast ::temp7 logPlayer 
            callstatic storageUtil StringListGet ::temp0 ::temp7 "Intel_SocialLog_Detail" li ;3 variable args
            callmethod EscapeJson self ::temp0 ::temp0 ;1 variable args
            strcat ::temp0 ",\"detail\":\"" ::temp0 
            strcat ::temp0 ::temp0 "\"" 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2662
            strcat ::temp0 json "}" 
            assign json ::temp0 
            ; line 2663
            isub ::temp1 li 1 
            assign li ::temp1 
            jmp _label22
            ; line 2665
          _label20:
            strcat ::temp0 json "]" 
            assign json ::temp0 
            ; line 2668
            array_create ::temp8 6 
            assign pkgFormIDs ::temp8 
            ; line 2669
            callmethod GetFormID ::TravelPackage_Walk_var ::temp1 ;0 variable args
            array_setelement pkgFormIDs 0 ::temp1 
            ; line 2670
            callmethod GetFormID ::TravelPackage_Jog_var ::temp1 ;0 variable args
            array_setelement pkgFormIDs 1 ::temp1 
            ; line 2671
            callmethod GetFormID ::TravelPackage_Run_var ::temp1 ;0 variable args
            array_setelement pkgFormIDs 2 ::temp1 
            ; line 2672
            cast ::temp2 ::TravelPackage_Stalk_var 
            jmpf ::temp2 _label23
            ; line 2673
            callmethod GetFormID ::TravelPackage_Stalk_var ::temp1 ;0 variable args
            array_setelement pkgFormIDs 3 ::temp1 
            jmp _label23
            ; line 2675
          _label23:
            cast ::temp2 ::SandboxPackage_var 
            jmpf ::temp2 _label24
            ; line 2676
            callmethod GetFormID ::SandboxPackage_var ::temp1 ;0 variable args
            array_setelement pkgFormIDs 4 ::temp1 
            jmp _label24
            ; line 2678
          _label24:
            cast ::temp2 ::SandboxNearPlayerPackage_var 
            jmpf ::temp2 _label25
            ; line 2679
            callmethod GetFormID ::SandboxNearPlayerPackage_var ::temp1 ;0 variable args
            array_setelement pkgFormIDs 5 ::temp1 
            jmp _label25
            ; line 2681
          _label25:
            callstatic intelEngine ScanActorsWithPackages ::temp0 pkgFormIDs ;1 variable args
            strcat ::temp0 ",\"packages\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2684
            callstatic intelEngine IsPoliticsEnabled ::temp2 ;0 variable args
            jmpf ::temp2 _label26
            ; line 2685
            callstatic intelEngine BuildPoliticalDashboardJson ::temp0 ;0 variable args
            strcat ::temp0 ",\"politics\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            jmp _label26
            ; line 2690
          _label26:
            strcat ::temp0 json ",\"config\":{" 
            assign json ::temp0 
            ; line 2691
            callmethod IsDebugMode self ::temp2 ;0 variable args
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 "\"debugMode\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2692
            callmethod IsStoryEngineEnabled self ::temp2 ;0 variable args
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"storyEnabled\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2693
            callmethod GetStoryEngineInterval self ::temp6 ;0 variable args
            cast ::temp0 ::temp6 
            strcat ::temp0 ",\"storyInterval\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2694
            callmethod GetStoryEngineCooldown self ::temp6 ;0 variable args
            cast ::temp0 ::temp6 
            strcat ::temp0 ",\"storyCooldown\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2695
            callmethod GetMaxConcurrentTasks self ::temp1 ;0 variable args
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"maxTasks\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2696
            cast ::temp0 ::LINGER_RELEASE_DISTANCE_var 
            strcat ::temp0 ",\"releaseDistance\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2697
            callstatic game GetPlayer ::temp4 ;0 variable args
            cast ::temp7 ::temp4 
            callstatic storageUtil GetIntValue ::temp1 ::temp7 "Intel_DeliveryReportBack" 0 ;3 variable args
            cmp_gt ::temp2 ::temp1 0 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"reportBack\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2698
            callstatic game GetPlayer ::temp4 ;0 variable args
            cast ::temp7 ::temp4 
            callstatic storageUtil GetIntValue ::temp1 ::temp7 "Intel_TaskConfirmPrompt" 0 ;3 variable args
            cmp_gt ::temp2 ::temp1 0 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"taskConfirmPrompt\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2699
            callmethod GetDefaultWaitHours self ::temp6 ;0 variable args
            cast ::temp0 ::temp6 
            strcat ::temp0 ",\"defaultWaitHours\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2700
            callstatic game GetPlayer ::temp4 ;0 variable args
            cast ::temp7 ::temp4 
            callstatic storageUtil GetFloatValue ::temp6 ::temp7 "Intel_MeetingTimeoutHours" 5.0 ;3 variable args
            cast ::temp0 ::temp6 
            strcat ::temp0 ",\"meetingTimeoutHours\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2701
            cast ::temp0 ::MeetingGracePeriod_var 
            strcat ::temp0 ",\"meetingGracePeriod\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2703
            cast ::temp2 ::StoryEngine_var 
            jmpf ::temp2 _label27
            ; line 2704
            propget LongAbsenceDaysConfig ::StoryEngine_var ::temp6 
            cast ::temp0 ::temp6 
            strcat ::temp0 ",\"longAbsenceDays\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2705
            propget MaxTravelDaysConfig ::StoryEngine_var ::temp6 
            cast ::temp0 ::temp6 
            strcat ::temp0 ",\"maxTravelDays\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2706
            propget AllowStuckTeleport ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"allowStuckTeleport\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2707
            propget DangerZonePolicy ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"dangerZonePolicy\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2708
            propget PlayerHomePolicy ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"playerHomePolicy\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2709
            propget HoldPolicySeekPlayer ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"holdPolicySeekPlayer\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2710
            propget HoldPolicyInformant ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"holdPolicyInformant\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2711
            propget HoldPolicyRoadEncounter ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"holdPolicyRoadEncounter\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2712
            propget HoldPolicyAmbush ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"holdPolicyAmbush\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2713
            propget HoldPolicyStalker ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"holdPolicyStalker\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2714
            propget HoldPolicyMessage ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"holdPolicyMessage\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2715
            propget HoldPolicyQuest ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"holdPolicyQuest\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2716
            propget ConfirmGoToLocation ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"confirmGoToLocation\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2717
            propget ConfirmDeliverMessage ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"confirmDeliverMessage\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2718
            propget ConfirmFetchPerson ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"confirmFetchPerson\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2719
            propget ConfirmEscortTarget ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"confirmEscortTarget\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2720
            propget ConfirmSearchForActor ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"confirmSearchForActor\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2721
            propget ConfirmScheduleMeeting ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"confirmScheduleMeeting\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2722
            propget ConfirmScheduleFetch ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"confirmScheduleFetch\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2723
            propget ConfirmScheduleDelivery ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"confirmScheduleDelivery\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2724
            propget SkipFollowerGoToLocation ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"skipFollowerGoToLocation\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2725
            propget SkipFollowerDeliverMessage ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"skipFollowerDeliverMessage\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2726
            propget SkipFollowerFetchPerson ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"skipFollowerFetchPerson\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2727
            propget SkipFollowerEscortTarget ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"skipFollowerEscortTarget\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2728
            propget SkipFollowerSearchForActor ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"skipFollowerSearchForActor\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2729
            propget SkipFollowerScheduleFetch ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"skipFollowerScheduleFetch\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2730
            propget SkipFollowerScheduleDelivery ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"skipFollowerScheduleDelivery\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2731
            propget SkipFollowerScheduleMeeting ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"skipFollowerScheduleMeeting\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2732
            propget AutoBioEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"autoBioEnabled\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2733
            propget AutoBioThreshold ::StoryEngine_var ::temp1 
            cast ::temp0 ::temp1 
            strcat ::temp0 ",\"autoBioThreshold\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2734
            propget NPCTickEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"npcTickEnabled\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2735
            propget NPCTickIntervalHours ::StoryEngine_var ::temp6 
            cast ::temp0 ::temp6 
            strcat ::temp0 ",\"npcTickInterval\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2736
            propget NPCSocialCooldownHours ::StoryEngine_var ::temp6 
            cast ::temp0 ::temp6 
            strcat ::temp0 ",\"npcSocialCooldown\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2737
            propget QuestSubTypeCombatEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"questCombat\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2738
            propget QuestSubTypeRescueEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"questRescue\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2739
            propget QuestSubTypeFindItemEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"questFindItem\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2740
            propget QuestSubTypeFactionCombatEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"questFactionCombat\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2741
            propget QuestSubTypeFactionRescueEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"questFactionRescue\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2742
            propget QuestSubTypeFactionBattleEnabled ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"questFactionBattle\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2743
            propget QUEST_EXPIRY_DAYS ::StoryEngine_var ::temp6 
            cast ::temp0 ::temp6 
            strcat ::temp0 ",\"questTimeoutDays\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            ; line 2744
            propget QuestAllowVictimDeath ::StoryEngine_var ::temp2 
            callmethod BoolToJson self ::temp0 ::temp2 ;1 variable args
            strcat ::temp0 ",\"questAllowVictimDeath\":" ::temp0 
            strcat ::temp0 json ::temp0 
            assign json ::temp0 
            jmp _label28
            ; line 2746
          _label27:
            strcat ::temp0 json ",\"longAbsenceDays\":3,\"maxTravelDays\":1,\"allowStuckTeleport\":true" 
            assign json ::temp0 
            ; line 2747
            strcat ::temp0 json ",\"dangerZonePolicy\":1,\"playerHomePolicy\":0" 
            assign json ::temp0 
            ; line 2748
            strcat ::temp0 json ",\"holdPolicySeekPlayer\":1,\"holdPolicyInformant\":1,\"holdPolicyRoadEncounter\":1" 
            assign json ::temp0 
            ; line 2749
            strcat ::temp0 json ",\"holdPolicyAmbush\":1,\"holdPolicyStalker\":1,\"holdPolicyMessage\":1,\"holdPolicyQuest\":1" 
            assign json ::temp0 
            ; line 2750
            strcat ::temp0 json ",\"confirmGoToLocation\":1,\"confirmDeliverMessage\":1,\"confirmFetchPerson\":1,\"confirmEscortTarget\":1" 
            assign json ::temp0 
            ; line 2751
            strcat ::temp0 json ",\"confirmSearchForActor\":1,\"confirmScheduleMeeting\":1,\"confirmScheduleFetch\":1,\"confirmScheduleDelivery\":1" 
            assign json ::temp0 
            ; line 2752
            strcat ::temp0 json ",\"skipFollowerGoToLocation\":false,\"skipFollowerDeliverMessage\":false,\"skipFollowerFetchPerson\":false,\"skipFollowerEscortTarget\":false" 
            assign json ::temp0 
            ; line 2753
            strcat ::temp0 json ",\"skipFollowerSearchForActor\":false,\"skipFollowerScheduleFetch\":false,\"skipFollowerScheduleDelivery\":false,\"skipFollowerScheduleMeeting\":false" 
            assign json ::temp0 
            ; line 2754
            strcat ::temp0 json ",\"autoBioEnabled\":false,\"autoBioThreshold\":20" 
            assign json ::temp0 
            ; line 2755
            strcat ::temp0 json ",\"npcTickEnabled\":true,\"npcTickInterval\":1.5,\"npcSocialCooldown\":24" 
            assign json ::temp0 
            ; line 2756
            strcat ::temp0 json ",\"questCombat\":true,\"questRescue\":true,\"questFindItem\":true,\"questFactionCombat\":true,\"questFactionRescue\":true,\"questFactionBattle\":true" 
            assign json ::temp0 
            ; line 2757
            strcat ::temp0 json ",\"questTimeoutDays\":7,\"questAllowVictimDeath\":false" 
            assign json ::temp0 
            ; line 2759
          _label28:
            strcat ::temp0 json "}" 
            assign json ::temp0 
            ; line 2761
            strcat ::temp0 json "}" 
            assign json ::temp0 
            ; line 2762
            return json 
          .endCode
        .endFunction ;BuildDashboardStateJson
        .function EscapeJson
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
            .param text String
          .endParamTable
          .localTable
            .local ::temp0 String
          .endLocalTable
          .code
            ; line 2767
            callstatic intelEngine StringEscapeJson ::temp0 text ;1 variable args
            return ::temp0 
          .endCode
        .endFunction ;EscapeJson
        .function BoolToJson
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
            .param val Bool
          .endParamTable
          .localTable
          .endLocalTable
          .code
            ; line 2771
            jmpf val _label0
            ; line 2772
            return "true" 
            jmp _label0
            ; line 2774
          _label0:
            return "false" 
          .endCode
        .endFunction ;BoolToJson
        .function GetActorName
           ; function type 0
          .userFlags 0 ;none
          .docString ""
          .return String
          .paramTable
            .param akActor actor
          .endParamTable
          .localTable
            .local ::temp0 actor
            .local ::temp1 Bool
            .local ::temp2 String
          .endLocalTable
          .code
            ; line 2778
            cast ::temp0 None 
            cmp_eq ::temp1 akActor ::temp0 
            not ::temp1 ::temp1 
            jmpf ::temp1 _label0
            ; line 2779
            callmethod GetDisplayName akActor ::temp2 ;0 variable args
            return ::temp2 
            jmp _label0
            ; line 2781
          _label0:
            return "" 
          .endCode
        .endFunction ;GetActorName
        .function IEB_ReleaseSkyrimNetPackages
           ; function type 0
          .userFlags 0 ;none
          .docString "Patch: unregister SkyrimNet's own follow/talk packages by name instead of clearing every override."
          .return None
          .paramTable
            .param npc actor
          .endParamTable
          .localTable
            .local ::temp0 Int
            .local ::temp1 Bool
          .endLocalTable
          .code
            ; line 2789
            callstatic skyrimNetApi HasPackage ::temp0 npc "FollowPlayer" ;2 variable args
            cmp_eq ::temp1 ::temp0 1 
            jmpf ::temp1 _label0
            ; line 2790
            callstatic skyrimNetApi UnregisterPackage ::temp0 npc "FollowPlayer" ;2 variable args
            jmp _label0
            ; line 2792
          _label0:
            callstatic skyrimNetApi HasPackage ::temp0 npc "TalkToPlayer" ;2 variable args
            cmp_eq ::temp1 ::temp0 1 
            jmpf ::temp1 _label1
            ; line 2793
            callstatic skyrimNetApi UnregisterPackage ::temp0 npc "TalkToPlayer" ;2 variable args
            jmp _label1
            ; line 2795
          _label1:
            callstatic skyrimNetApi HasPackage ::temp0 npc "TalkToNPC" ;2 variable args
            cmp_eq ::temp1 ::temp0 1 
            jmpf ::temp1 _label2
            ; line 2796
            callstatic skyrimNetApi UnregisterPackage ::temp0 npc "TalkToNPC" ;2 variable args
            jmp _label2
          _label2
          .endCode
        .endFunction ;IEB_ReleaseSkyrimNetPackages
      .endState
    .endStateTable
  .endObject
.endObjectTable
