Scriptname LUC_Main extends Quest
{Lucienne.esl quest script (spec §11.15.9, §11.15.12). FROZEN property list (spec §16.4 freeze rule): PlayerRef and the
 8 globals. Holds the prayer-journal custom-prompt calls and their callbacks (SendCustomPromptToLLM needs the callback
 on the quest's own script). Bodies may change mid-save; new forms come through Game.GetFormFromFile, never properties.}

; ---- FROZEN property list. Never add, remove or rename. ----
GlobalVariable Property LUC_PrayerKey Auto
GlobalVariable Property LUC_AmenKey Auto
GlobalVariable Property LUC_PrayerEnabled Auto
GlobalVariable Property LUC_DigestEvery Auto
GlobalVariable Property LUC_JournalMax Auto
GlobalVariable Property LUC_Spare01 Auto
GlobalVariable Property LUC_Spare02 Auto
GlobalVariable Property LUC_ActivateRequest Auto
Actor Property PlayerRef Auto

Function PrayerEnded(Float afPrayerSeconds, String asReason)
    {Called by LUC_PlayerAliasScript once per prayer that really ended (never on a load reset). Counts it, stamps the
     day, and asks for the journal entry over the prayer window (game seconds; the template compares it with
     gameTimeNumeric - event.gameTime).}
    Int n = StorageUtil.GetIntValue(PlayerRef, "LUC_PrayerCount", 0) + 1
    StorageUtil.SetIntValue(PlayerRef, "LUC_PrayerCount", n)
    StorageUtil.SetFloatValue(PlayerRef, "LUC_LastPrayerDay", Utility.GetCurrentGameTime())
    Int secs = afPrayerSeconds as Int
    If secs < 60
        secs = 60
    EndIf
    String ctx = "{\"prayerSeconds\":" + secs + "}"
    Int rc = SkyrimNetApi.SendCustomPromptToLLM("luc_prayer_summary", "", ctx, Self, "LUC_Main", "OnPrayerSummary")
    Log("prayer " + n + " ended (" + asReason + "), " + secs + " s; summary requested rc=" + rc)
EndFunction

Function OnPrayerSummary(String response, Int success)
    If success != 1 || StringUtil.GetLength(response) < 10
        Log("summary failed (success=" + success + ", length=" + StringUtil.GetLength(response) + ")")
        Return
    EndIf
    StorageUtil.StringListAdd(PlayerRef, "LUC_PrayerJournal", response)
    Int maxN = LUC_JournalMax.GetValueInt()
    If maxN < 1
        maxN = 1
    EndIf
    While StorageUtil.StringListCount(PlayerRef, "LUC_PrayerJournal") > maxN
        StorageUtil.StringListRemoveAt(PlayerRef, "LUC_PrayerJournal", 0)
    EndWhile
    Int count = StorageUtil.StringListCount(PlayerRef, "LUC_PrayerJournal")
    Log("journal entry stored (" + StringUtil.GetLength(response) + " chars, " + count + " kept)")
    Int every = LUC_DigestEvery.GetValueInt()
    Int n = StorageUtil.GetIntValue(PlayerRef, "LUC_PrayerCount", 0)
    If every > 0 && n > 0 && n % every == 0
        Int rc = SkyrimNetApi.SendCustomPromptToLLM("luc_prayer_digest", "", "", Self, "LUC_Main", "OnPrayerDigest")
        Log("digest requested after prayer " + n + " rc=" + rc)
    EndIf
EndFunction

Function OnPrayerDigest(String response, Int success)
    If success != 1 || StringUtil.GetLength(response) < 10
        Log("digest failed (success=" + success + ")")
        Return
    EndIf
    StorageUtil.SetStringValue(PlayerRef, "LUC_PrayerDigest", response)
    Log("digest stored (" + StringUtil.GetLength(response) + " chars)")
EndFunction

Function Log(String asMsg)
    Debug.Trace("[LUC] " + asMsg)
EndFunction
