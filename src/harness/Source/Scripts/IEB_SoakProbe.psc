Scriptname IEB_SoakProbe extends Quest
{Errand Bridge test harness: the soak probe (spec §15.4; scoring as revised for the one-week soak). TEST PROFILE ONLY; no
 gameplay effect. Every 30 real seconds, while ErrandBridgeTest.esp's IEB_TestSoakProbe == 1, appends one CSV row to
 Data/SKSE/Plugins/ErrandBridge/soak_probe.csv (MO2: lands in overwrite or the profile's output mod):
   rt, gt, day, timescale, lag_ms, paused, su_IEB, su_IEBtask, su_IEBroster, roster, exp_old, su_ScenePartner,
   su_Intel, su_Sever, su_SNRom, su_total, held, lent, slots, orphans
 paused = 1 when game time advanced less than half of what 30 real seconds at the current timescale should give, or
 went backwards (load screen, menu, reload): such rows are left out of the lag statistics (SK-1).
 su_IEBtask = the bridge's per-task keys (IEB_Held/Lent/Gate/Mode ints + IEB_TaskT* strings): 0 when nothing is held.
 su_IEBroster = keys kept per enrolled actor by the private Relationships patch and rank sync (IEB_RomTrack*,
 IEB_RankSync*, IEB_SNRomStatus, IEB_GiftUndone, IEB_Intimacy*): bounded by roster (SNRom_Roster size).
 exp_old = SceneControls' exposure places still listed from a previous game day (must be 0).
 timescale = TimeScale now; must equal the play value recorded at step 7 (the soak is never accelerated).}

Float _expectRT
Float _lastRT
Float _lastGT

Float Function Every()
    Return 30.0
EndFunction

String Function CsvPath()
    Return "Data/SKSE/Plugins/ErrandBridge/soak_probe.csv"
EndFunction

Bool Function OnOwnQuest()
    {[2026-10-10] The probe lives on its own quest IEB_TestSoakQuest (0x830). Saves made before that change still carry
     an instance on IEB_TestQuest (0x810), restored from the save; Papyrus keeps one update registration per form, so that
     stale instance must never re-arm, or it overwrites the watcher's 3 s loop with 30 s.}
    Return (Self as Quest) == (Game.GetFormFromFile(0x830, "ErrandBridgeTest.esp") as Quest)
EndFunction

Event OnInit()
    If !OnOwnQuest()
        Return
    EndIf
    _expectRT = Utility.GetCurrentRealTime() + Every()
    _lastGT = Utility.GetCurrentGameTime()
    RegisterForSingleUpdate(Every())
EndEvent

Event OnUpdate()
    If !OnOwnQuest()
        Return                               ; stale instance on IEB_TestQuest: never re-arm
    EndIf
    RegisterForSingleUpdate(Every())         ; booked first
    Float now = Utility.GetCurrentRealTime()
    Float gt = Utility.GetCurrentGameTime()
    Float lagMs = (now - _expectRT) * 1000.0
    Int paused = 0
    GlobalVariable ts = Game.GetFormFromFile(0x0000003A, "Skyrim.esm") as GlobalVariable     ; TimeScale
    Float tsv = 0.0
    If ts != None
        tsv = ts.GetValue()
    EndIf
    Float expectDays = (now - _lastRT) * tsv / 86400.0
    If now < _lastRT || gt < _lastGT || (expectDays > 0.0 && (gt - _lastGT) < 0.5 * expectDays)
        paused = 1
    EndIf
    If now < _lastRT
        lagMs = -1.0                         ; new game session: lag undefined for this row
    EndIf
    _lastRT = now
    _lastGT = gt
    _expectRT = now + Every()
    GlobalVariable on = Game.GetFormFromFile(0x802, "ErrandBridgeTest.esp") as GlobalVariable
    If on == None || on.GetValue() < 1.0
        Return
    EndIf
    If !MiscUtil.FileExists(CsvPath())
        MiscUtil.WriteToFile(CsvPath(), "rt,gt,day,timescale,lag_ms,paused,su_IEB,su_IEBtask,su_IEBroster,roster,exp_old,su_ScenePartner,su_Intel,su_Sever,su_SNRom,su_total,held,lent,slots,orphans\n", False, False)
    EndIf
    Int total = StorageUtil.debug_GetIntObjectCount() + StorageUtil.debug_GetFloatObjectCount() + StorageUtil.debug_GetStringObjectCount() + \
        StorageUtil.debug_GetFormObjectCount() + StorageUtil.debug_GetIntListObjectCount() + StorageUtil.debug_GetFloatListObjectCount() + \
        StorageUtil.debug_GetStringListObjectCount() + StorageUtil.debug_GetFormListObjectCount()
    Int task = StorageUtil.CountIntValuePrefix("IEB_Held") + StorageUtil.CountIntValuePrefix("IEB_Lent") + \
        StorageUtil.CountIntValuePrefix("IEB_Gate") + StorageUtil.CountIntValuePrefix("IEB_Mode") + StorageUtil.CountStringValuePrefix("IEB_TaskT")
    Int rosterKeys = StorageUtil.CountAllPrefix("IEB_RomTrack") + StorageUtil.CountAllPrefix("IEB_RankSync") + \
        StorageUtil.CountAllPrefix("IEB_SNRomStatus") + StorageUtil.CountAllPrefix("IEB_GiftUndone") + StorageUtil.CountAllPrefix("IEB_Intimacy")
    Int roster = StorageUtil.FormListCount(None, "SNRom_Roster")
    Actor pl = Game.GetPlayer()
    Int expOld = 0
    If StorageUtil.GetIntValue(pl, "IEB_WitnessPlaceDay", -1) != (gt as Int)
        expOld = StorageUtil.FormListCount(pl, "IEB_WitnessPlaces")
    EndIf
    Int partners = StorageUtil.CountIntValuePrefix("IEB_IsScenePartner")
    Int held = StorageUtil.FormListCount(None, "IEB_HeldList")
    Int lent = 0
    Int i = 0
    While i < held
        Form f = StorageUtil.FormListGet(None, "IEB_HeldList", i)
        If f != None && StorageUtil.GetIntValue(f, "IEB_Lent", 0) == 1
            lent += 1
        EndIf
        i += 1
    EndWhile
    Int slots = 0
    ReferenceAlias[] al = IEB_IELib.AgentAliases()
    i = 0
    While i < al.Length
        If al[i] != None && al[i].GetActorReference() != None
            slots += 1
        EndIf
        i += 1
    EndWhile
    String row = now + "," + gt + "," + (gt as Int) + "," + tsv + "," + (lagMs as Int) + "," + paused + "," + StorageUtil.CountAllPrefix("IEB_") + "," + \
        task + "," + rosterKeys + "," + roster + "," + expOld + "," + partners + "," + StorageUtil.CountAllPrefix("Intel_") + "," + \
        StorageUtil.CountAllPrefix("Sever") + "," + StorageUtil.CountAllPrefix("SNRom_") + "," + total + "," + held + "," + lent + "," + \
        slots + "," + StorageUtil.GetIntValue(None, "EBT_LastFails", 0) + "\n"
    MiscUtil.WriteToFile(CsvPath(), row, True, False)
EndEvent
