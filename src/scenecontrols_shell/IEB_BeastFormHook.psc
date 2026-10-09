Scriptname IEB_BeastFormHook extends ReferenceAlias
{SceneControls beast-form hook on the player alias (spec §16.4; TASK_C list B, M7b). SHELL: final name, no
 properties (FROZEN: none). OnRaceSwitchComplete is EMPTY in the shell; its body (one witness event when the player's
 race becomes a beast form) lands later as a body-only change.}

Event OnInit()
    Debug.Trace("[IEB-SC] IEB_BeastFormHook attached (shell skeleton)")
EndEvent

Event OnRaceSwitchComplete()
EndEvent
