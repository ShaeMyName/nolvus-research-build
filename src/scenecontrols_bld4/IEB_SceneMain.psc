Scriptname IEB_SceneMain extends ReferenceAlias
{SceneControls player-alias script (spec §11.7-§11.9, §11.13.3, §11.13.8). BLD-4 VARIANT of the shell skeleton (step 5a sitting only; never shipped): final
 name and FROZEN property list. The logic (scene key, witness events, whisper rule, partners) arrives in step 5c as a
 body-only change; anything not listed here is looked up with Game.GetFormFromFile, never a new property.}

; ---- FROZEN property list (spec §16.4 freeze rule). Never add, remove or rename. ----
GlobalVariable Property IEB_SceneEnabled Auto
GlobalVariable Property IEB_SceneKey Auto
GlobalVariable Property IEB_NarratorKey Auto
GlobalVariable Property IEB_WhisperKey Auto
GlobalVariable Property IEB_WhisperAuto Auto
GlobalVariable Property IEB_WitnessEnabled Auto
GlobalVariable Property IEB_SceneSpare01 Auto
GlobalVariable Property IEB_SceneSpare02 Auto
FormList Property IEB_MinimalBody Auto
FormList Property IEB_Smallclothes Auto
Actor Property PlayerRef Auto

Event OnInit()
    Log("IEB_SceneMain OnInit (shell skeleton)")
EndEvent

Event OnPlayerLoadGame()
    Log("IEB_SceneMain game load (shell skeleton): enabled=" + IEB_SceneEnabled.GetValue() + " sceneKey=" + \
        IEB_SceneKey.GetValue() + " lists=" + IEB_MinimalBody.GetSize() + "/" + IEB_Smallclothes.GetSize())
    Log("BLD-4: calling a missing stub function")
    IEB_BLD4Probe.Missing()
    Log("BLD-4: survived the missing call")
EndEvent

Function Log(String asMsg)
    Debug.Trace("[IEB-SC] " + asMsg)
EndFunction
