Scriptname IEB_SALib Hidden
{Errand Bridge: every SeverActions call lives here, presence-guarded (spec §3.1). Global library, not attached; body
 filled in step 3 after BLD-4.}

Bool Function SAPresent() Global
    Return Game.GetModByName("SeverActions.esp") != 255
EndFunction
