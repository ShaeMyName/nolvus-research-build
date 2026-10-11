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

Function ImportFollower(Actor myActor)     ; :655 (harness B-6d, REVIEW_LOG RV-66)
EndFunction

nwsFollowerVariableScript Property varScript Auto                ; :209 (REVIEW_LOG R32: DismissedFac, animal keywords)

Function ToggleEssential(Actor myActor, Int doDefault)     ; :1991 (essential followers, design §1.1)
EndFunction

Function RecruitFollower(Actor myActor)     ; :349 (harness NFFRecruit, tests_ess.py)
EndFunction

Function ImportAction(Actor myActor, Int myOpt, Int myOpt2)     ; :662 (harness NFFImportND, tests_ess.py)
EndFunction
