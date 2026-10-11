Scriptname SNRom_PlayerAlias extends ReferenceAlias
{ Re-establishes the bridge on every game load.

  Decorator registrations and ModEvent registrations do NOT survive a
  save/load. Without this the integration silently stops working after the
  first reload - a nasty failure mode, because everything looks fine until
  you notice nothing is scoring.

  Resolves the bridge via GetOwningQuest() rather than a filled property, so
  there is nothing to wire by hand in the Creation Kit and nothing to leave
  unset. }

Event OnInit()
    Rebind(True)
EndEvent

Event OnPlayerLoadGame()
    { FORCED. This event fires exactly once per game load and is the only
      unambiguous "new session" signal available, so it must never be
      debounced away.

      Bootstrap's debounce compares Utility.GetCurrentRealTime() against a
      value that PERSISTS in the save. Load a save at a similar point in the
      launch as last time and the delta lands inside the debounce window, so
      the whole bootstrap is skipped on a brand new session. Observed
      2026-07-29: the spark timer was never armed for an entire play session
      and nothing logged, because RegisterForSingleUpdateGameTime lives inside
      the part that got skipped. Real time cannot distinguish sessions; this
      event can. }
    Rebind(True)
    IEB_AmuletWatch()                          ; Patch rv117: re-arm the amulet watch (or restore if it is off)
    SNRom_Bridge bridge = GetOwningQuest() as SNRom_Bridge
    If bridge != None
        bridge.IEB_RegisterMarriageWatch()     ; Patch c2: vanilla-path engagements
    EndIf
EndEvent

Function Rebind(Bool abForce = False)
    SNRom_Bridge bridge = GetOwningQuest() as SNRom_Bridge
    If bridge == None
        Debug.Trace("[SNRom] Player alias could not resolve SNRom_Bridge on its owning quest.")
        Return
    EndIf
    bridge.Bootstrap(abForce)
EndFunction

; ============================================================================ Patch rv117 (REVIEW_LOG RV-117, 2026-10-11)
; The vanilla Amulet-of-Mara proposal needs the player to WEAR the amulet. While it is worn, SNRom_Bridge.IEB_AmuletSweep
; gates every loaded marriageable actor (on equip, on location change, then every 5 s); taking it off restores the
; never-enrolled. A load re-arms the watch, or restores if the amulet is off.

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
    If akBaseObject == Game.GetFormFromFile(0x000C891B, "Skyrim.esm")
        RegisterForSingleUpdate(0.5)
    EndIf
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
    If akBaseObject == Game.GetFormFromFile(0x000C891B, "Skyrim.esm")
        UnregisterForUpdate()
        SNRom_Bridge bridge = GetOwningQuest() as SNRom_Bridge
        If bridge != None
            bridge.IEB_AmuletRestoreAll()
        EndIf
    EndIf
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    IEB_AmuletWatch()
EndEvent

Event OnUpdate()
    IEB_AmuletWatch()
EndEvent

Function IEB_AmuletWatch()
    SNRom_Bridge bridge = GetOwningQuest() as SNRom_Bridge
    If bridge == None
        Return
    EndIf
    If !SNRom_Bridge.IEB_WearingAmulet()
        If StorageUtil.FormListCount(None, "IEB_PMFRemovedList") > 0
            bridge.IEB_AmuletRestoreAll()
        EndIf
        Return
    EndIf
    bridge.IEB_AmuletSweep()
    RegisterForSingleUpdate(5.0)
EndFunction
