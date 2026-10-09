Scriptname IEB_BeastFormHook extends ReferenceAlias
{SceneControls beast-form hook on the player alias (spec §16.4; TASK_C M7b; round 10 Part 2.2 fix 3). FROZEN property
 list: none. On the player's race switch into a beast form (Werewolf, Vampire Lord, Werebear; matched on race display
 name like the creature-filter Form line), IEB_SceneMain registers one ieb_witness event, so nearby NPCs get a reason
 to react at the moment of transformation instead of waiting for the GameMaster's timer.}

Event OnInit()
    Debug.Trace("[IEB-SC] IEB_BeastFormHook attached")
EndEvent

Event OnRaceSwitchComplete()
    IEB_SceneMain m = GetOwningQuest().GetAlias(0) as IEB_SceneMain
    Actor p = GetActorReference()
    If m == None || p == None
        Return
    EndIf
    String form = m.BeastForm(p)
    If form != ""
        m.BeastWitness(form)
    EndIf
EndEvent
