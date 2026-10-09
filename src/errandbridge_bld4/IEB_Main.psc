Scriptname IEB_Main extends Quest
{Errand Bridge main quest script (spec §4-§9). SHELL SKELETON (step 3, list A3): final name and FROZEN property list.
 Bodies grow mid-save; anything not listed here is looked up with Game.GetFormFromFile, never a new property.}

; ---- FROZEN property list (spec §16.4 freeze rule). Never add, remove or rename. ----
GlobalVariable Property IEB_Enabled Auto
GlobalVariable Property IEB_PollSeconds Auto
GlobalVariable Property IEB_LogLevel Auto
GlobalVariable Property IEB_ParkRefreshHours Auto
GlobalVariable Property IEB_LogToFile Auto
GlobalVariable Property IEB_RejoinWarpFactor Auto
GlobalVariable Property IEB_LendEnabled Auto
GlobalVariable Property IEB_LendStoryPolicy Auto
GlobalVariable Property IEB_CFEnabled Auto
GlobalVariable Property IEB_CFPauseCatchup Auto
GlobalVariable Property IEB_Spare01 Auto
GlobalVariable Property IEB_Spare02 Auto
Actor Property PlayerRef Auto

Int _ticks

Event OnInit()
    Log("IEB_Main OnInit (shell skeleton)")
    StartTicking()
EndEvent

Function OnGameLoad()
    {Called by IEB_PlayerAlias.OnPlayerLoadGame.}
    Log("IEB_Main game load (shell skeleton): enabled=" + IEB_Enabled.GetValue() + " poll=" + IEB_PollSeconds.GetValue())
    Log("BLD-4: calling a function that exists only in a compile stub; expect one Papyrus error, no crash")
    IEB_BLD4Probe.Missing()
    Log("BLD-4: survived the missing call")
    StartTicking()
EndFunction

Function StartTicking()
    Float poll = IEB_PollSeconds.GetValue()
    If IEB_Enabled.GetValue() < 1.0
        poll = 5.0
    EndIf
    RegisterForSingleUpdate(poll)
EndFunction

Event OnUpdate()
    _ticks += 1
    If _ticks == 1 || _ticks % 60 == 0
        Log("IEB_Main tick " + _ticks + " (shell skeleton)")
    EndIf
    StartTicking()
EndEvent

Function Log(String asMsg)
    Debug.Trace("[IEB] " + asMsg)
EndFunction
