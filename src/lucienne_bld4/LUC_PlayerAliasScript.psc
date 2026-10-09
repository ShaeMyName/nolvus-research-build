Scriptname LUC_PlayerAliasScript extends ReferenceAlias
{BLD-4 VARIANT (step 5b sitting only; never shipped). Lucienne.esl player alias (spec §11.15.3-§11.15.8). FROZEN property list (spec §16.4): PlayerRef, LUC_PrayerKey,
 LUC_AmenKey, LUC_PrayerEnabled, LUC_ActivateRequest.
 - Prayer key: opens a prayer (enables Dusk, inner voice, Thought input); while praying, opens another Thought input.
 - Ending: LUC_AmenKey, or a long-press (1 s or more) of the prayer key while LUC_AmenKey is 0. Azura's end-marker and
   Lucienne speaking aloud disable Dusk through triggers, and the poll notices.
 - One update loop: every 2 s while praying (end detection), else every 5 s. Every tick also handles the manual
   LUC_Active request and re-syncs the key registrations.
 - Load reset: no prayer survives a load or a new game.
 Everything Lucienne-specific runs only while StorageUtil LUC_Active == 1 on the player, which is only ever set by
 hand (set LUC_ActivateRequest to 1). Dreams (OnSleepStop) stay empty: list B, M11.}

; ---- FROZEN property list. Never add, remove or rename. ----
Actor Property PlayerRef Auto
GlobalVariable Property LUC_PrayerKey Auto
GlobalVariable Property LUC_AmenKey Auto
GlobalVariable Property LUC_PrayerEnabled Auto
GlobalVariable Property LUC_ActivateRequest Auto

Int _prayKey
Int _amenKey
Int _missTicks

; ============================================================================ constants (functions, not properties)

String Function VEName()
    Return "Dusk"
EndFunction

String Function InnerVoice()
    Return "player_thought_effect"           ; SkyrimNet's shipped recipe (TT-4); an own recipe is a body change later
EndFunction

Float Function LongPress()
    Return 1.0
EndFunction

Bool Function Active()
    Return StorageUtil.GetIntValue(PlayerRef, "LUC_Active", 0) == 1
EndFunction

Bool Function Praying()
    Return StorageUtil.GetIntValue(PlayerRef, "LUC_Praying", 0) == 1
EndFunction

; ============================================================================ start-up and load reset (§11.15.7)

Event OnInit()
    Startup("init")
EndEvent

Event OnPlayerLoadGame()
    Startup("load")
EndEvent

Function Startup(String asWhy)
    StorageUtil.SetStringValue(PlayerRef, "LUC_VEName", VEName())
    Bool wasOpen = Praying()
    ResetPrayer()                            ; never carry an open prayer across a load or a new game; no journal entry
    _prayKey = -1
    _amenKey = -1
    SyncKeys()
    CheckActivateRequest()
    RegisterForSingleUpdate(5.0)
    Log("startup (" + asWhy + "): active=" + Active() + " prayerKey=" + _prayKey + " amenKey=" + _amenKey + " reset_open_prayer=" + wasOpen)
    If asWhy == "load"
        Log("BLD-4: calling a missing stub function")
        IEB_BLD4Probe.Missing()
        Log("BLD-4: survived the missing call")
    EndIf
EndFunction

Function ResetPrayer()
    String uuid = StorageUtil.GetStringValue(PlayerRef, "LUC_DuskUUID", "")
    If uuid != ""
        SkyrimNetApi.ClearVoiceEffectByUUID(uuid)
    EndIf
    SkyrimNetApi.DisableVirtualNPC(VEName())
    StorageUtil.SetIntValue(PlayerRef, "LUC_Praying", 0)
    _missTicks = 0
EndFunction

; ============================================================================ the one update loop

Event OnUpdate()
    CheckActivateRequest()
    SyncKeys()
    If Praying()
        If SkyrimNetApi.GetVirtualNPCUUID(VEName()) == ""
            _missTicks += 1
            If _missTicks >= 2               ; two misses in a row: Dusk was disabled (end-marker or spoken line)
                EndPrayer("closed")
            EndIf
        Else
            _missTicks = 0
        EndIf
    EndIf
    If Praying()
        RegisterForSingleUpdate(2.0)
    Else
        RegisterForSingleUpdate(5.0)
    EndIf
EndEvent

; ============================================================================ manual LUC_Active setter (Shae, 2026-10-09)

Function CheckActivateRequest()
    {One-way and idempotent. The request is consumed (reset to 0) first, so it can be re-triggered and can never fire
     again on a later load. LUC_Active is only ever set here, and only on this request.}
    If LUC_ActivateRequest.GetValue() == 0.0
        Return
    EndIf
    LUC_ActivateRequest.SetValue(0.0)
    If Active()
        Debug.Notification("Lucienne layer already active")
        Log("activate request: already active, request reset")
    Else
        StorageUtil.SetIntValue(PlayerRef, "LUC_Active", 1)
        Debug.Notification("Lucienne layer activated")
        Log("activate request: LUC_Active set to 1, request reset")
    EndIf
EndFunction

; ============================================================================ keys

Function SyncKeys()
    Int p = LUC_PrayerKey.GetValueInt()
    Int a = LUC_AmenKey.GetValueInt()
    If a == p
        a = 0
    EndIf
    If p == _prayKey && a == _amenKey
        Return
    EndIf
    UnregisterForAllKeys()
    If p > 0
        RegisterForKey(p)
    EndIf
    If a > 0
        RegisterForKey(a)
    EndIf
    _prayKey = p
    _amenKey = a
EndFunction

Event OnKeyUp(Int keyCode, Float holdTime)
    If keyCode <= 0 || UI.IsTextInputEnabled()
        Return
    EndIf
    If keyCode == _prayKey
        If Praying()
            If _amenKey <= 0 && holdTime >= LongPress()
                EndPrayer("amen_longpress")
            ElseIf !Utility.IsInMenuMode()
                SkyrimNetApi.TriggerTextThought()      ; continue praying (A0 review: the key never ends it)
            EndIf
        Else
            StartPrayer()
        EndIf
    ElseIf keyCode == _amenKey && Praying()
        EndPrayer("amen_key")
    EndIf
EndEvent

; ============================================================================ prayer (§11.15.3, §11.15.6)

Function StartPrayer()
    If !Active() || LUC_PrayerEnabled.GetValue() < 1.0 || Utility.IsInMenuMode()
        Return
    EndIf
    StorageUtil.SetStringValue(PlayerRef, "LUC_VEName", VEName())
    StorageUtil.SetIntValue(PlayerRef, "LUC_Praying", 1)
    StorageUtil.SetFloatValue(PlayerRef, "LUC_PrayerStart", Utility.GetCurrentGameTime())
    _missTicks = 0
    Int rc = SkyrimNetApi.EnableVirtualNPC(VEName())
    String uuid = SkyrimNetApi.GetVirtualNPCUUID(VEName())
    If uuid != ""
        StorageUtil.SetStringValue(PlayerRef, "LUC_DuskUUID", uuid)
        SkyrimNetApi.SetVoiceEffectByUUID(uuid, InnerVoice())
    EndIf
    SkyrimNetApi.TriggerTextThought()
    RegisterForSingleUpdate(2.0)
    Log("prayer opened (enable rc=" + rc + ", uuid found " + (uuid != "") + ")")
EndFunction

Function EndPrayer(String asReason)
    If !Praying()
        Return
    EndIf
    Float started = StorageUtil.GetFloatValue(PlayerRef, "LUC_PrayerStart", Utility.GetCurrentGameTime())
    Float secs = (Utility.GetCurrentGameTime() - started) * 86400.0
    ResetPrayer()
    (GetOwningQuest() as LUC_Main).PrayerEnded(secs, asReason)
EndFunction

; ============================================================================ shrine flag (§11.15.8) and dreams (v2)

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    If akNewLoc == None || !Active() || StorageUtil.GetIntValue(PlayerRef, "LUC_VisitedAzuraShrine", 0) == 1
        Return
    EndIf
    Location shrine = Game.GetFormFromFile(0x00092497, "Skyrim.esm") as Location
    If shrine != None && (akNewLoc == shrine || akNewLoc.IsChild(shrine))
        StorageUtil.SetIntValue(PlayerRef, "LUC_VisitedAzuraShrine", 1)
        Log("shrine visited")
    EndIf
EndEvent

Event OnSleepStop(Bool abInterrupted)
    ; Azura dreams: list B, M11 (designed with Shae later). Intentionally empty.
EndEvent

Function Log(String asMsg)
    Debug.Trace("[LUC] " + asMsg)
EndFunction
