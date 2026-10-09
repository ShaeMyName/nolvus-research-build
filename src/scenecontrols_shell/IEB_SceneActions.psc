Scriptname IEB_SceneActions extends Quest
{SceneControls quest script: the entry point for the JoinScene / LeaveScene SkyrimNet actions (layer G). SkyrimNet calls
 member functions of a script bound to the quest (questEditorId + scriptName), so these two forward to the player-alias
 script IEB_SceneMain, which owns the scene state. FROZEN property list: none.}

Function JoinScene(Actor akActor)
    IEB_SceneMain m = GetAlias(0) as IEB_SceneMain
    If m == None
        Debug.Trace("[IEB-SC] JoinScene: alias script missing")
        Return
    EndIf
    m.JoinScene(akActor)
EndFunction

Function LeaveScene(Actor akActor)
    IEB_SceneMain m = GetAlias(0) as IEB_SceneMain
    If m == None
        Debug.Trace("[IEB-SC] LeaveScene: alias script missing")
        Return
    EndIf
    m.LeaveScene(akActor)
EndFunction
