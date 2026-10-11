Scriptname IEB_PlayerAlias extends ReferenceAlias
{Errand Bridge player alias (spec §16.4). SHELL: final name, no properties (FROZEN: none). Forwards game loads.}

Event OnPlayerLoadGame()
    (GetOwningQuest() as IEB_Main).OnGameLoad()
    IEB_Notice.WatchLateBox()        ; notice N2 (spec §17a): on this alias thread, never in IEB_Main's worker
EndEvent
