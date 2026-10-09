Scriptname IEB_SoakProbe extends Quest
{Errand Bridge test harness: the soak probe (spec §15.4; scoring as revised for the one-week soak). TEST PROFILE ONLY; no
 gameplay effect. Every 30 real seconds, while ErrandBridgeTest.esp's IEB_TestSoakProbe == 1, appends one CSV row to
 Data/SKSE/Plugins/ErrandBridge/soak_probe.csv (MO2: lands in overwrite or the profile's output mod):
   rt, gt, day, lag_ms, paused, su_IEB, su_IEBtask, su_ScenePartner, su_Intel, su_Sever, su_SNRom, su_total,
   held, lent, slots, orphans
 paused = 1 when game time advanced less than half of what 30 real seconds at the current timescale should give, or
 went backwards (load screen, menu, reload): such rows are left out of the lag statistics (SK-1).
 su_IEBtask = the bridge's per-task keys (IEB_Held/Lent/Gate/Mode ints + IEB_TaskT* strings): 0 when nothing is held.}

Float _expectRT
Float _lastRT
Float _lastGT

Float Function Every()
    Return 30.0
EndFunction

String Function CsvPath()
    Return "Data/SKSE/Plugins/ErrandBridge/soak_probe.csv"
EndFunction

Event OnInit()
    _expectRT = Utility.GetCurrentRealTime() + Every()
    _lastGT = Utility.GetCurrentGameTime()
    RegisterForSingleUpdate(Every())
EndEvent

Event OnUpdate()
    RegisterForSingleUpdate(Every())         ; booked first
    Float now = Utility.GetCurrentRealTime()
    Float gt = Utility.GetCurrentGameTime()
    Float lagMs = (now - _expectRT) * 1000.0
    Int paused = 0
    GlobalVariable ts = Game.GetFormFromFile(0x0000003A, "Skyrim.esm") as GlobalVariable     ; TimeScale
    Float expectDays = (now - _lastRT) * 1.0
    If ts != None
        expectDays = (now - _lastRT) * ts.GetValue() / 86400.0
    EndIf
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
        MiscUtil.WriteToFile(CsvPath(), "rt,gt,day,lag_ms,paused,su_IEB,su_IEBtask,su_ScenePartner,su_Intel,su_Sever,su_SNRom,su_total,held,lent,slots,orphans\n", False, False)
    EndIf
    Int total = StorageUtil.debug_GetIntObjectCount() + StorageUtil.debug_GetFloatObjectCount() + StorageUtil.debug_GetStringObjectCount() + \
        StorageUtil.debug_GetFormObjectCount() + StorageUtil.debug_GetIntListObjectCount() + StorageUtil.debug_GetFloatListObjectCount() + \
        StorageUtil.debug_GetStringListObjectCount() + StorageUtil.debug_GetFormListObjectCount()
    Int task = StorageUtil.CountIntValuePrefix("IEB_Held") + StorageUtil.CountIntValuePrefix("IEB_Lent") + \
        StorageUtil.CountIntValuePrefix("IEB_Gate") + StorageUtil.CountIntValuePrefix("IEB_Mode") + StorageUtil.CountStringValuePrefix("IEB_TaskT")
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
    String row = now + "," + gt + "," + (gt as Int) + "," + (lagMs as Int) + "," + paused + "," + StorageUtil.CountAllPrefix("IEB_") + "," + \
        task + "," + partners + "," + StorageUtil.CountAllPrefix("Intel_") + "," + StorageUtil.CountAllPrefix("Sever") + "," + \
        StorageUtil.CountAllPrefix("SNRom_") + "," + total + "," + held + "," + lent + "," + slots + "," + StorageUtil.GetIntValue(None, "EBT_LastFails", 0) + "\n"
    MiscUtil.WriteToFile(CsvPath(), row, True, False)
EndEvent
