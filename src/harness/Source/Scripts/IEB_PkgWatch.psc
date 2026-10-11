Scriptname IEB_PkgWatch extends ReferenceAlias
{B-22 package-event probe (REVIEW_LOG R36-upd (c)): on the optional, package-free alias PkgWatch of IEB_TestPkgQuest
 (ErrandBridgeTest.esp 0x840). TestCtl.PkgWatch forces an actor in; every package start / change / end of that actor is
 logged with the real time, so a test judges which packages ran and in what order (durations only as upper bounds).
 No properties. TEST PROFILE ONLY.}

String Function H(Form f)
    If f == None
        Return "None"
    EndIf
    Return PO3_SKSEFunctions.IntToString(f.GetFormID(), True)
EndFunction

Event OnPackageStart(Package akNewPackage)
    Debug.Trace("[IEB-TEST] PKGEVT start actor=" + H(GetReference()) + " pkg=" + H(akNewPackage) + " rt=" + Utility.GetCurrentRealTime())
EndEvent

Event OnPackageChange(Package akOldPackage)
    Debug.Trace("[IEB-TEST] PKGEVT change actor=" + H(GetReference()) + " old=" + H(akOldPackage) + " rt=" + Utility.GetCurrentRealTime())
EndEvent

Event OnPackageEnd(Package akOldPackage)
    Debug.Trace("[IEB-TEST] PKGEVT end actor=" + H(GetReference()) + " pkg=" + H(akOldPackage) + " rt=" + Utility.GetCurrentRealTime())
EndEvent
