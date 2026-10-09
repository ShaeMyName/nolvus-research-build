Scriptname IEB_NFFLib Hidden
{Errand Bridge: every NFF call lives here, behind a presence check (spec §3.1). Global library, not attached; body
 filled in step 3 after BLD-4.}

Bool Function NFFPresent() Global
    Return Game.GetModByName("nwsFollowerFramework.esp") != 255
EndFunction
