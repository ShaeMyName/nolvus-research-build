Scriptname IEB_PlayerAlias extends ReferenceAlias
{Errand Bridge player alias (spec §16.4). SHELL: final name, no properties (FROZEN: none). Forwards game loads.}

Event OnPlayerLoadGame()
    (GetOwningQuest() as IEB_Main).OnGameLoad()
EndEvent
