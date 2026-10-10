ScriptName nwsFollowerControllerScript Extends Quest conditional
{Compile-only header stub (never shipped) for the Errand Bridge. Members copied verbatim from the decompiled NFF
 source nff/psc/nwsFollowerControllerScript.psc (:9, :91, :544, :584). The full source can't be imported: its MCM
 script needs SkyUI's SKI_ConfigBase, which isn't installed as source.}

Faction Property nwsFF_SparFac Auto
Int Property nwsCombatAware Auto Conditional Hidden          ; :70 (harness TM-5)

Function FollowerWaitHere(Actor myActor, Int notify, Int doPerm)
EndFunction

Function FollowerFollowMe(Actor myActor, Int notify)
EndFunction

Function RemoveFollower(Actor myActor, Int iMessage, Int iSayLine)     ; :430 (harness B-6)
EndFunction

nwsFollowerVariableScript Property varScript Auto                ; :209 (REVIEW_LOG R32: DismissedFac, animal keywords)
