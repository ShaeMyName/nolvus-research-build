Scriptname IEB_Notice Hidden
{On-screen notices N1-N8 (spec §17a; investigation/round10/notices_research.md). Global library, never attached (the
 IEB_IELib pattern): no record, property or attachment changes, so the freeze rule holds. Switched off together by the
 spare global IEB_Spare01 (ErrandBridge.esp 0x80A): 0 = on (default), 1 = off. Every notice is generic: never a quest
 name, a refusal reason or a story outcome. Each one also logs "[IEB] NOTICE Nx shown|suppressed text=<text>" for NT-1/2/3.}

Bool Function Enabled() Global
    GlobalVariable g = Game.GetFormFromFile(0x80A, "ErrandBridge.esp") as GlobalVariable
    Return g == None || g.GetValueInt() == 0
EndFunction

Function Show(String asId, String asText) Global
    If Enabled()
        Debug.Notification(asText)
        Debug.Trace("[IEB] NOTICE " + asId + " shown text=" + asText)
    Else
        Debug.Trace("[IEB] NOTICE " + asId + " suppressed text=" + asText)
    EndIf
EndFunction

; ---------------------------------------------------------------------------- N3-N7 (IEB_Main worker, non-latent)

Function Refused(String asName) Global
    Show("N3", asName + " can't go right now.")
EndFunction

Function RejoinWait(String asName) Global
    Show("N4", asName + " will rejoin you when you're near.")
EndFunction

Function Rejoined(String asName) Global
    Show("N5", asName + " has rejoined you.")
EndFunction

Function WaitingAtEnd(String asName) Global
    Show("N6", asName + " is waiting where the errand ended.")
EndFunction

Function CalledOff(String asName) Global
    Show("N7", asName + "'s errand was called off.")
EndFunction

; ---------------------------------------------------------------------------- N8 (SeverActions steward visit)

Function StewardVisit(Form akSteward, String asRetainer) Global
    {SA payload: sender = steward, strArg = retainer FormID as signed decimal (SeverActions_Enterprises.psc:896-900).}
    Actor s = akSteward as Actor
    Actor t = Game.GetForm(asRetainer as Int) as Actor
    If s == None
        Return
    EndIf
    String who = "their retainer"
    If t != None
        who = t.GetDisplayName()
    EndIf
    Show("N8", s.GetDisplayName() + " went to look in on " + who + ".")
EndFunction

; ---------------------------------------------------------------------------- N1 (AI actions ready, once per load)

Function OnLoad() Global
    {From IEB_Main.Setup on every load: re-arm N1 and (re)register the never-eligible probe action. SkyrimNet calls its
     eligibility function in the post-load warm-up; the first call for a non-player actor is the "ready" moment.}
    StorageUtil.UnsetIntValue(Game.GetPlayer(), "IEB_AIReadyShown")
    StorageUtil.SetFloatValue(Game.GetPlayer(), "IEB_LoadRealTime", Utility.GetCurrentRealTime())
    Int rc = SkyrimNetApi.RegisterAction("IEB_ReadyProbe", "Internal readiness probe. Never offered.", "IEB_Notice", \
        "Probe_IsEligible", "IEB_Notice", "Probe_Execute", "", "PAPYRUS", 0, "{}")
    Debug.Trace("[IEB] NOTICE probe registered rc=" + rc)
EndFunction

Bool Function Probe_IsEligible(Actor akActor, String contextJson, String paramsJson) Global
    {Always False for every actor (Shae's condition). The first call after a load for a non-player actor shows N1 once.}
    Actor pl = Game.GetPlayer()
    If akActor != None && akActor != pl && StorageUtil.GetIntValue(pl, "IEB_AIReadyShown", 0) == 0
        StorageUtil.SetIntValue(pl, "IEB_AIReadyShown", 1)
        Debug.Trace("[IEB] AI_READY after " + (Utility.GetCurrentRealTime() - StorageUtil.GetFloatValue(pl, "IEB_LoadRealTime", 0.0)) + " s")
        Show("N1", "AI actions ready.")
    EndIf
    Return False
EndFunction

Function Probe_Execute(Actor akActor, String contextJson, String paramsJson) Global
    {Never runs (never eligible); logs if it ever does.}
    Debug.Trace("[IEB] WARN NOTICE probe executed (should be impossible)")
EndFunction

; ---------------------------------------------------------------------------- N2 (Timeline box answered after the timeout)

Function WatchLateBox() Global
    {On the player-alias thread after a load: if a message box was open within ~5 s of the load and closed at >= 118 s,
     SkyrimNet had stopped waiting (120 s) and kept history. Capped at 10 min. Any slow box counts (limitation).}
    Float t0 = Utility.GetCurrentRealTime()
    Bool seen = False
    While Utility.GetCurrentRealTime() - t0 < 5.0 && !seen
        seen = UI.IsMenuOpen("MessageBoxMenu")
        Utility.WaitMenuMode(0.5)
    EndWhile
    If !seen
        Return
    EndIf
    While UI.IsMenuOpen("MessageBoxMenu") && Utility.GetCurrentRealTime() - t0 < 600.0
        Utility.WaitMenuMode(1.0)
    EndWhile
    Float held = Utility.GetCurrentRealTime() - t0
    Debug.Trace("[IEB] NOTICE box closed after " + held + " s")
    If held >= 118.0
        Show("N2", "SkyrimNet stopped waiting for your answer; history kept.")
    EndIf
EndFunction
