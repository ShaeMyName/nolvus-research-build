Scriptname IEB_SoakProbe extends Quest
{Errand Bridge test harness: the soak probe (spec §15.4). TEST PROFILE ONLY; no gameplay effect. Every 60 real seconds,
 while ErrandBridgeTest.esp's IEB_TestSoakProbe == 1, appends one CSV row to Data/SKSE/Plugins/ErrandBridge/
 soak_probe.csv (MO2: lands in overwrite or the profile's output mod):
   rt, gt, lag_ms, su_IEB, su_Intel, su_Sever, su_SNRom, su_total, held, lent, slots, orphans}

Float _expectRT
Float _lastRT

String Function CsvPath()
    Return "Data/SKSE/Plugins/ErrandBridge/soak_probe.csv"
EndFunction

Event OnInit()
    _expectRT = Utility.GetCurrentRealTime() + 60.0
    RegisterForSingleUpdate(60.0)
EndEvent

Event OnUpdate()
    RegisterForSingleUpdate(60.0)            ; booked first
    Float now = Utility.GetCurrentRealTime()
    Float lagMs = (now - _expectRT) * 1000.0
    If now < _lastRT
        lagMs = -1.0                         ; new game session: lag undefined for this row
    EndIf
    _lastRT = now
    _expectRT = now + 60.0
    GlobalVariable on = Game.GetFormFromFile(0x802, "ErrandBridgeTest.esp") as GlobalVariable
    If on == None || on.GetValue() < 1.0
        Return
    EndIf
    If !MiscUtil.FileExists(CsvPath())
        MiscUtil.WriteToFile(CsvPath(), "rt,gt,lag_ms,su_IEB,su_Intel,su_Sever,su_SNRom,su_total,held,lent,slots,orphans\n", False, False)
    EndIf
    Int total = StorageUtil.debug_GetIntObjectCount() + StorageUtil.debug_GetFloatObjectCount() + StorageUtil.debug_GetStringObjectCount() + \
        StorageUtil.debug_GetFormObjectCount() + StorageUtil.debug_GetIntListObjectCount() + StorageUtil.debug_GetFloatListObjectCount() + \
        StorageUtil.debug_GetStringListObjectCount() + StorageUtil.debug_GetFormListObjectCount()
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
    String row = now + "," + Utility.GetCurrentGameTime() + "," + (lagMs as Int) + "," + StorageUtil.CountAllPrefix("IEB_") + "," + \
        StorageUtil.CountAllPrefix("Intel_") + "," + StorageUtil.CountAllPrefix("Sever") + "," + StorageUtil.CountAllPrefix("SNRom_") + "," + \
        total + "," + held + "," + lent + "," + slots + "," + StorageUtil.GetIntValue(None, "EBT_LastFails", 0) + "\n"
    MiscUtil.WriteToFile(CsvPath(), row, True, False)
EndEvent
