"""U2 INTERFACE REPORT (REVIEW_LOG RV-153 (1), (3)): after a U2SMOKE run, print every GUESSED / INFERRED external interface name the
U2-A tests rely on, with its live result:
    WORKED       the smoke reached it and parsed / used it (evidence line shown)
    FAILED       it answered wrongly, errored, came back empty or the test's parse missed (evidence shown)
    NOT REACHED  no smoke test got as far as using it (the covering test stopped earlier, was not run, or none covers it)
The builder marks an item VERIFIED in the code/docs only when this table says WORKED.

  python u2_interface_report.py                       newest test_runs/U2SMOKE_<stamp>.md (not the setup-only ones)
  python u2_interface_report.py --run test_runs/U2SMOKE_20261012-090000.md
  python u2_interface_report.py --since "2026-10-12 09:00:00" [--block U2]     no summary file (run still going, crashed, HALT): window by time
  python u2_interface_report.py --md out.md           the table as markdown too
  python u2_interface_report.py --inventory-md C:/nolvus-research/investigation/round10/u2_interface_inventory.md
  python u2_interface_report.py --list                the inventory only (no run needed)
  python u2_interface_report.py --selftest            dry run on synthetic results (no game, no files outside a temp dir)

Evidence sources, all counts / names / formats (the harness never writes prose to them):
  - test_runs/<TID>_<stamp>.txt          each test's result lines (Run.save)
  - test_runs/<BLOCK>_<stamp>/raw/*      the archived Papyrus / SkyrimNet / SeverActions logs of the run (game.archive_logs)
  - test_runs/iface_trace.jsonl          one line per /harness HTTP call: endpoint, parameter and body field NAMES, status, ms,
                                         response SHAPE (field names, value types; strings only as lengths). Written by sn_harness.py.
The INVENTORY below is the data; investigation/round10/u2_interface_inventory.md is generated from it (--inventory-md).
Classes: G = guessed (marked INFERRED/guess in the code, or resolved nowhere); S = resolved statically (DLL string table, our own
source, prompt/layer file, Skyrim.esm string) but never seen live; L = already seen live in an earlier run (the smoke re-confirms)."""
import argparse, glob, json, os, re, sys, tempfile, time

OUT = "C:/nolvus-research/test_runs/"
TRACE = OUT + "iface_trace.jsonl"
SMOKE_BLOCK = "U2SMOKE"
SMOKE_TESTS = ["H-2", "DA-1", "DA-3", "SEC-3", "SEC-2", "SEC-4", "WE-1", "X-6", "CS-2", "SC-9", "W-3", "PV-3", "PV-4", "NT-4"]
TEXT_KEYS = ("text", "line", "content", "subtitle", "message")        # tests_u2_len._UTT_TEXT_KEYS

# ------------------------------------------------------------------------------------------------ rule shorthand
def R(rx, *tests):
    """A result-line rule: rx found in the result text of these tests (all tests when none are named)."""
    return {"res": rx, "t": list(tests) or None}

def RAW(kind, rx, pred=None):
    """A raw-log rule: rx found in the archived papyrus / skyrimnet / sa log of the run (optionally a named predicate on the match)."""
    return {"raw": kind, "rx": rx, "pred": pred}

def TR(api, pred="ok", **params):
    """A trace rule: the /harness calls to `api` (filtered by enumerated parameter values) satisfy the named predicate."""
    return {"trace": api, "pred": pred, "params": params}

def ALL(*rules):
    return {"all": list(rules)}

def I(id, cat, name, cls, where, tests, marked, ok=(), bad=(), note=""):
    return dict(id=id, cat=cat, name=name, cls=cls, where=list(where), tests=list(tests), marked=marked, ok=list(ok), bad=list(bad), note=note)

# Common failure signatures that sink any item that relies on the harness API / render route.
HARNESS_DOWN = R(r"^INCONCLUSIVE \S+ SkyrimNet /harness API not reachable")

# ------------------------------------------------------------------------------------------------ the inventory (data)
INVENTORY = [
    # ---- SkyrimNet /harness HTTP (sn_harness.py)
    I("HT-01", "http", "GET /harness?api=status answers (response field names not used)", "S",
      ["sn_harness.py:95", "tests_u2.py:118 harness_ready", "tests_u2.py:178 H-2"], ["H-2"],
      "endpoint VERIFIED as DLL string (sn_harness.py:5-8; skyrimnet_b25_1_dll_strings.txt:58185-58360); response fields unmarked, only 'answers' is used",
      ok=[TR("status"), R(r"^PASS H-2 /harness status answers", "H-2")],
      bad=[TR("status", "all_err"), R(r"^FAIL H-2 /harness status answers", "H-2"), HARNESS_DOWN],
      note="evidence detail lists the response's top-level field names (trace)"),
    I("HT-02", "http", "GET /harness?api=ui-state answers", "S", ["sn_harness.py:99", "tests_u2.py:178"], ["H-2", "NT-4"],
      "endpoint VERIFIED as DLL string; response fields unmarked",
      ok=[TR("ui-state"), R(r"^PASS H-2 /harness ui-state answers", "H-2")],
      bad=[TR("ui-state", "all_err"), R(r"^FAIL H-2 /harness ui-state answers", "H-2")]),
    I("HT-03", "http", "ui-state response names an open message box by the string 'MessageBoxMenu' (str(response) contains it)", "G",
      ["tests_u2_nt.py:122-127 box_open", "tests_u3_m.py:758-768"], ["NT-4"],
      "INFERRED: DLL strings show 'MessageBoxMenu open but the game thread did not respond' and keys menu_open / box, but not the response layout",
      ok=[R(r"^PASS NT-4 \w+: the scheduled task fired without a second box", "NT-4"),
          R(r"^PASS NT-4 a non-scheduled fetch right after still shows its confirmation box", "NT-4")],
      bad=[R(r"^INCONCLUSIVE NT-4 \w+: no scheduling box appeared", "NT-4")],
      note="WORKED only through the chain box seen -> dismissed -> scheduling accepted -> task fired; a miss may also mean the confirm setting did not take (see HT-13 and PL-15)"),
    I("HT-04", "http", "GET /harness?api=utterances answers", "S", ["sn_harness.py:103", "tests_u2.py:178"], ["H-2"],
      "endpoint VERIFIED as DLL string; response layout see HT-05", ok=[TR("utterances"), R(r"^PASS H-2 /harness utterances answers", "H-2")],
      bad=[TR("utterances", "all_err"), R(r"^FAIL H-2 /harness utterances answers", "H-2")]),
    I("HT-05", "http", "utterances response is a list, or a dict holding one list", "G",
      ["tests_u2_len.py:107-116 utt_items", "tests_u2_sc.py:289-298", "tests_u2_len.py:19-20"], ["SEC-2", "SEC-4"],
      "INFERRED (tests_u2_len.py:19-20)", ok=[TR("utterances", "list")],
      bad=[TR("utterances", "no_list")], note="trace shows the response shape (field names / list length), never text"),
    I("HT-06", "http", "each utterance item carries its text under one of text / line / content / subtitle / message", "G",
      ["tests_u2_len.py:65 _UTT_TEXT_KEYS", "tests_u2_len.py:137-147 _utt_split", "tests_u2_len.py:356 logs the field names"], ["SEC-2", "SEC-4"],
      "INFERRED names (tests_u2_len.py:18-19)", ok=[TR("utterances", "text_field"), R(r"^\s+reply: .* spoken=\d+", "SEC-2", "SEC-4")],
      bad=[R(r"^\s+reply: .* spoken=None", "SEC-2", "SEC-4")],
      note="when it FAILED, the item field NAMES are in the SEC result ('utterance fields (names only)') and in the trace; pick the right key there"),
    I("HT-07", "http", "an utterance item carries its speaker's uuid under some string field (used to drop the player's own lines)", "G",
      ["tests_u2_len.py:125-134 npc_items"], ["SEC-2", "SEC-4"], "INFERRED (tests_u2_len.py:126-127: 'the item carries its speaker's uuid under some field'; with no such field all items count)",
      ok=[TR("utterances", "id_field")], bad=[TR("utterances", "no_id_field")],
      note="WORKED = some item field looks like an id (hexNN in the trace); the report cannot prove it equals the speaker's uuid, so compare the field name with the speaker in the dashboard once"),
    I("HT-08", "http", "GET await kind=idle&timeout_s=N returns when the pipeline is idle", "S",
      ["sn_harness.py:107", "tests_u2.py:127-135 force_line", "tests_u2_da.py:37-41 say_to", "tests_u2_len.py:211", "tests_u2_misc.py:89"],
      ["DA-3", "SEC-2", "SEC-4", "CS-2", "PV-3", "PV-4"], "params VERIFIED as DLL strings ('kind must be event, idle, or speech-done', timeout_s); semantics (idle = the reply is stored) unmarked",
      ok=[TR("await", "ok", kind="idle")], bad=[TR("await", "all_err", kind="idle"), TR("await", "timed_out", kind="idle")],
      note="the trace records each call's duration; a call that returns at once while a reply is expected would show as ms near 0 with no DA/CS/SEC result"),
    I("HT-09", "http", "GET await kind=speech-done&uuid=<npc> returns", "S", ["sn_harness.py:111", "tests_u2_len.py:213-216 (HarnessError swallowed)"],
      ["SEC-2", "SEC-4"], "params VERIFIED as DLL strings ('speech-done', 'Missing or invalid uuid'); the test swallows its errors, so only the trace can show a failure",
      ok=[TR("await", "ok", kind="speech-done")], bad=[TR("await", "all_err", kind="speech-done")]),
    I("HT-10", "http", "POST inject-player-input {text, target_uuid}: the player's typed line reaches the NPC and starts a reply", "G",
      ["sn_harness.py:120-127", "tests_u2_da.py:38", "tests_u2_misc.py:88", "tests_u2_len.py:203"], ["DA-3", "CS-2", "SEC-2", "SEC-4"],
      "INFERRED body field names (sn_harness.py:121-122: 'text' and 'target_uuid')",
      ok=[ALL(TR("inject-player-input"), R(r"^PASS DA-3 TriggerDialogueLine fired", "DA-3")),
          ALL(TR("inject-player-input"), R(r"^PASS CS-2 \w+: the child replied", "CS-2")),
          ALL(TR("inject-player-input"), R(r"^\s+reply: events=[1-9]", "SEC-2", "SEC-4"))],
      bad=[TR("inject-player-input", "all_err"), R(r"^INCONCLUSIVE (?:DA-3|CS-2|SEC-2|SEC-4) (?:harness call failed|harness error: HarnessError)"),
           R(r"^INCONCLUSIVE SEC-\d zero replies measured")],
      note="a 200 with the body fields ignored would show as no reply: WORKED needs an HTTP 200 AND a reply after it"),
    I("HT-11", "http", "POST speak {speaker_uuid, text, kind=npc, target_uuid}: a forced line is stored in the speaker's history", "S",
      ["sn_harness.py:129-135", "tests_u2.py:127-135 force_line", "tests_u2_len.py:242-262 calibrate"], ["PV-3", "PV-4", "SEC-2", "SEC-4"],
      "field names VERIFIED by the DLL's validation messages (sn_harness.py:128); that the event is stored in history is unmarked",
      ok=[R(r"^\s+overhead spaces per event \(calibrated\)", "SEC-2", "SEC-4"), R(r"^PASS PV-3 the newcomer's History holds no line", "PV-3"),
          R(r"^PASS PV-4 PV-4: the housecarl's History lacks the line", "PV-4")],
      bad=[R(r"^INCONCLUSIVE \S+ harness speak failed"), R(r"^INCONCLUSIVE SEC-\d calibration (?:failed|line produced)"),
           R(r"^INCONCLUSIVE (?:PV-3|PV-4) (?:PV-4: )?control failed")]),
    I("HT-12", "http", "POST overrides {pacing_governor: bypass | normal}", "S", ["sn_harness.py:166", "tests_u2.py:186", "tests_u2_len.py:300"], ["H-2", "SEC-2", "SEC-4"],
      "field + values VERIFIED as DLL strings", ok=[TR("overrides"), R(r"^PASS H-2 /harness overrides pacing_governor=bypass accepted", "H-2")],
      bad=[TR("overrides", "all_err"), R(r"^FAIL H-2 /harness overrides", "H-2")]),
    I("HT-13", "http", "POST dismiss-ui {button: 0} answers the IntelEngine scheduling box with Allow (button 1 = Deny)", "G",
      ["sn_harness.py:156", "tests_u2_nt.py:149", "tests_u2_nt.py:196"], ["NT-4"],
      "INFERRED (tests_u2_nt.py:111 '0 = Allow', :196 '1 = Deny'); the DLL only says 'button must be a non-negative integer'",
      ok=[ALL(TR("dismiss-ui", "ok", button=0), RAW("papyrus", r"\[IEB-TEST\] ScheduleFetch [^\n]*ok=True"))],
      bad=[TR("dismiss-ui", "all_err"), R(r"^INCONCLUSIVE NT-4 \w+: scheduling not accepted", "NT-4")],
      note="WORKED = the call returned 200 AND IntelEngine then reported the scheduling accepted (ok=True)"),

    # ---- MCP tools
    I("MC-01", "mcp", "render_template {actor_uuid, template_name='dialogue_response', response_target_uuid} returns renderedContent", "L",
      ["tests_misc.py:161-175 render", "tests_u2_len.py:630,719,720,744"], ["SEC-3", "SEC-2", "SEC-4"],
      "seen live in U1 (X-4 20261010-182347 rendered it); re-confirmed here",
      ok=[R(r"^PASS SEC-3 NPC->NPC dialogue_response carries", "SEC-3"), R(r"^PASS SEC-3 \w+ does not carry", "SEC-3")],
      bad=[R(r"^\s+render failed:", "SEC-3"), R(r"^INCONCLUSIVE SEC-3 rule absent from dialogue_response", "SEC-3")]),
    I("MC-02", "mcp", "template names 'player_dialogue' (rendered as the player) and 'npc_thoughts' render", "G",
      ["tests_u2_len.py:721-722", "tests_u2_len.py:728 'template name INFERRED'"], ["SEC-3"],
      "INFERRED names (tests_u2_len.py:708,728); the prompt files exist in skyrimnet.base/prompts/ (player_dialogue.prompt, npc_thoughts.prompt) but a render of them has never been tried",
      ok=[R(r"^PASS SEC-3 player_dialogue does not carry", "SEC-3"), R(r"^PASS SEC-3 npc_thoughts does not carry", "SEC-3")],
      bad=[R(r"^INCONCLUSIVE SEC-3 (?:player_dialogue|npc_thoughts) did not render", "SEC-3"), R(r"^FAIL SEC-3 (?:player_dialogue|npc_thoughts)", "SEC-3")]),
    I("MC-03", "mcp", "'## Discretion' heading is in a rendered dialogue_response (layer shae.discretion 0705) for NPC->player and NPC->NPC", "S",
      ["tests_u2_len.py:622-635 _sec_ready", "tests_u2_len.py:706-731 sec3"], ["SEC-3", "SEC-2", "SEC-4"],
      "heading VERIFIED in the layer file (SkyrimNet - Discretion/.../0705_ieb_discretion.prompt:3); live render never tried",
      ok=[R(r"^PASS SEC-3 NPC->NPC dialogue_response carries '## Discretion'", "SEC-3")],
      bad=[R(r"^INCONCLUSIVE SEC-\d (?:rule absent from dialogue_response|'## Discretion' not in)", "SEC-3", "SEC-2", "SEC-4"),
           R(r"^FAIL SEC-3 NPC->NPC dialogue_response", "SEC-3")]),
    I("MC-04", "mcp", "'internal_thought' appears in a rendered dialogue_response when inline thoughts are on", "G",
      ["tests_u2_len.py:735,745 sec4"], ["SEC-4"],
      "INFERRED marker (tests_u2_len.py:735). The tag is written by skyrimnet.base 0500_response_format.prompt:91 only inside {% if allow_inline_internal_thoughts %}; whether the setting is on is not known",
      ok=[R(r"^PASS SEC-4 spoken line holds no private token", "SEC-4"), R(r"^\s+RECORD private-token hits in thought events", "SEC-4")],
      bad=[R(r"^INCONCLUSIVE SEC-4 inline thoughts do not look enabled", "SEC-4")],
      note="FAILED here means 'marker absent': either the setting is off (switch it, rerun SEC-4 only) or the marker name is wrong; read the 0500 template in the dashboard to tell"),
    I("MC-05", "mcp", "execute_quest_function IEB_SceneQuest / IEB_SceneActions.JoinScene(actor as '0x...' string) reaches IEB_SceneMain", "S",
      ["tests_u2_sc.py:23 SCQ/SCS", "tests_u2_sc.py:39-49 join"], ["SC-9"],
      "quest EDID IEB_SceneQuest VERIFIED (gen_scenecontrols.py:33); script/function VERIFIED (IEB_SceneActions.psc:6-22); first live call",
      ok=[RAW("papyrus", r"\[IEB-SC\] JOIN_(?:ACCEPTED|REFUSED) ")], bad=[RAW("papyrus", r"\[IEB-SC\] JoinScene: alias script missing")]),
    I("MC-06", "mcp", "check_action_eligibility action_name='JoinScene' is false for a child (and not just because the name is unknown)", "G",
      ["tests_u2_sc.py:150"], ["SC-9"],
      "action file VERIFIED (SkyrimNet - Scene Text/.../actions/joinscene.yaml); the child rule's effect on it is unmarked; an unknown name could also read 'not eligible' (vacuous PASS)",
      ok=[R(r"^PASS SC-9 JoinScene not eligible for a child \(False\)", "SC-9")], bad=[R(r"^FAIL SC-9 JoinScene not eligible", "SC-9")],
      note="WORKED does not prove the name is registered; the direct JoinScene refusal (PL-04) is the real child gate. Check once that JoinScene is eligible for an ADULT partner in the dashboard (action list)"),
    I("MC-07", "mcp", "console 'coc WhiterunBanneredMare' reaches the inn interior (cell EditorID)", "S",
      ["tests_u2_wh.py:26 MARE, :79-91 enter", "tests_u2_da.py:61-67"], ["DA-3", "PV-3"],
      "EditorID found as a string in Skyrim.esm; reaching it is self-checked by PLAYERPOS (PV-3) / finding the innkeeper (DA-3)",
      ok=[R(r"^PASS PV-3 ", "PV-3"), R(r"^PASS DA-3 ", "DA-3")], bad=[R(r"^INCONCLUSIVE \S+ coc WhiterunBanneredMare did not reach an interior")]),
    I("MC-08", "mcp", "console 'coc WhiterunBreezehome' reaches Breezehome", "S", ["tests_u2_wh.py:27 HOME, :79-91 enter, :349-356 _home_case"], ["PV-4"],
      "EditorID found as a string in Skyrim.esm; reaching it is self-checked by PLAYERPOS",
      ok=[R(r"^(?:PASS|FAIL) PV-4 ", "PV-4"), R(r"^INCONCLUSIVE PV-4 PV-4: whisper not on in the owned home", "PV-4")],
      bad=[R(r"^INCONCLUSIVE \S+ coc WhiterunBreezehome did not reach an interior")]),
    I("GD-01", "data", "the innkeeper is found by display name 'Hulda' (QScan) in the Bannered Mare by day", "G",
      ["tests_u2_da.py:25-34 find_npc", "tests_u2_da.py:66"], ["DA-3"],
      "unmarked as to the schedule (docstring: 'INCONCLUSIVE if absent'); name exists in Skyrim.esm",
      ok=[R(r"^PASS DA-3 ", "DA-3")], bad=[R(r"^INCONCLUSIVE DA-3 innkeeper not found")]),
    I("GD-02", "data", "Breezehome carries the player-house Location keyword, so whisper turns ON there (rule i) with a housecarl 300 u away", "G",
      ["tests_u2_wh.py:349-356,424 _home_case"], ["PV-4"],
      "INFERRED (tests_u2_wh.py:350-351,424)", ok=[R(r"^PASS PV-4 PV-4: IEB_ScenePrivate = 1", "PV-4")],
      bad=[R(r"^INCONCLUSIVE PV-4 PV-4: whisper not on in the owned home", "PV-4"), R(r"^FAIL PV-4 PV-4: IEB_ScenePrivate", "PV-4")]),

    # ---- SkyrimNet / SeverActions log formats
    I("LG-01", "log", "SkyrimNet.log: \"Registered newly discovered external layer '<id>'\"", "S", ["tests_u2_da.py:54-55"], ["DA-1"],
      "DLL string :49587 (tests_u2_da.py:3-5); the test also passes on the bare layer id",
      ok=[RAW("skyrimnet", r"Registered newly discovered external layer 'shae\.dialogue-actions'"), R(r"^PASS DA-1 SkyrimNet\.log names", "DA-1")],
      bad=[R(r"^FAIL DA-1 SkyrimNet\.log names", "DA-1")], note="a pass by the bare layer id only shows as the second evidence; the exact wording line is the first"),
    I("LG-02", "log", "SkyrimNet.log: '[DialogueActionsLibrary] <n> whitelist and <m> blacklist entr(ies)'", "S", ["tests_u2_da.py:56-60"], ["DA-1"],
      "DLL string :41426", ok=[RAW("skyrimnet", r"\[DialogueActionsLibrary\][^\n]*?\d+ blacklist entr\(ies\)")],
      bad=[R(r"^FAIL DA-1 DialogueActionsLibrary blacklist line", "DA-1")]),
    I("LG-03", "log", "SkyrimNet.log: 'TriggerDialogueLine firing <hex8> for <name>' when a dialogue action fires", "S", ["tests_u2_da.py:43,77-79"], ["DA-3"],
      "DLL string :35904 (QuestDialogueActions: ...); whether the line is written at the test config's log level is unmarked",
      ok=[R(r"^PASS DA-3 TriggerDialogueLine fired", "DA-3"), RAW("skyrimnet", r"TriggerDialogueLine firing [0-9A-F]{8} for ")],
      bad=[R(r"^FAIL DA-3 TriggerDialogueLine fired", "DA-3")]),
    I("LG-04", "log", "SkyrimNet.log: '[TIF-EXEC] fired info <hex8> ...'", "S", ["tests_u2_da.py:43,77-79"], ["DA-3"], "DLL string :38669",
      ok=[R(r"^PASS DA-3 \[TIF-EXEC\] fired info", "DA-3"), RAW("skyrimnet", r"\[TIF-EXEC\] fired info [0-9A-F]{8}")],
      bad=[R(r"^FAIL DA-3 \[TIF-EXEC\] fired info", "DA-3")]),
    I("LG-05", "log", "SkyrimNet.log: 'OnVanillaVoiceStarted' (count recorded, not asserted)", "S", ["tests_u2_da.py:80"], ["DA-3"],
      "DLL string :44627; record only", ok=[RAW("skyrimnet", r"OnVanillaVoiceStarted")],
      bad=[R(r"^\s+vanilla voice starts \(count\): 0", "DA-3")], note="FAILED here only means 'never logged in this run' (no vanilla voice played, or a debug-level line); nothing depends on it"),
    I("LG-06", "log", "SkyrimNet.log: \"Successfully registered schema for event type 'ieb_witness'\"", "S", ["tests_u2.py:326-328"], ["WE-1"],
      "DLL string :45662", ok=[R(r"^PASS WE-1 SkyrimNet: schema registered", "WE-1"), RAW("skyrimnet", r"Successfully registered schema for event type 'ieb_witness'")],
      bad=[R(r"^FAIL WE-1 SkyrimNet: schema registered", "WE-1")]),
    I("LG-07", "log", "SeverActions log mentions 'WaitForPlayerHere' when told 'wait here' (count recorded, not asserted)", "G", ["tests_u2_da.py:150,165"], [],
      "INFERRED name (tests_u2_da.py:150); only DA-8 reads it and DA-8 is not in the smoke", ok=[], bad=[],
      note="NOT REACHED by design: record-only, no assertion hangs on it; DA-8 itself reports the count when it runs in U2-A"),

    # ---- our own Papyrus log formats and TestCtl wrappers (static match against the .psc; first live use)
    I("PL-01", "papyrus", "[IEB-SC] 'WITNESS exposure rc=<n>' on a player undress", "S", ["tests_u2.py:150-166 fire_exposure", "IEB_SceneMain.psc:584,663"], ["WE-1", "CS-2"],
      "format VERIFIED in source; first live use", ok=[R(r"^PASS WE-1 one WITNESS exposure line", "WE-1"), RAW("papyrus", r"\[IEB-SC\] WITNESS exposure rc=-?\d+")],
      bad=[R(r"^FAIL WE-1 one WITNESS exposure line", "WE-1"), R(r"^INCONCLUSIVE CS-2 could not take off", "CS-2")]),
    I("PL-02", "papyrus", "[IEB-SC] 'PRIVATE 0->1' and 'PRIVATE 1->0' flag flips", "S", ["tests_u2_wh.py:403,733", "IEB_SceneMain.psc:373,380"], ["PV-3", "PV-4"],
      "format VERIFIED in source; first live use",
      ok=[ALL(RAW("papyrus", r"\[IEB-SC\] PRIVATE 0->1"), RAW("papyrus", r"\[IEB-SC\] PRIVATE 1->0")), R(r"^PASS PV-3 IEB_ScenePrivate flipped 1 -> 0", "PV-3")],
      bad=[R(r"^INCONCLUSIVE PV-3 the scene never became private", "PV-3"), R(r"^FAIL PV-3 IEB_ScenePrivate flipped", "PV-3"), R(r"^FAIL PV-4 PV-4: IEB_ScenePrivate = 1", "PV-4")]),
    I("PL-03", "papyrus", "[IEB-SC] 'WITNESS scene rc=<n>' at the private->witnessed flip (and the '60 s floor' skip line)", "S",
      ["tests_u2_wh.py:741-742", "IEB_SceneMain.psc:625,651,663"], ["PV-3"], "format VERIFIED in source; first live use",
      ok=[R(r"^PASS PV-3 exactly one ieb_witness \(c\) at the flip", "PV-3"), RAW("papyrus", r"\[IEB-SC\] WITNESS scene rc=-?\d+")],
      bad=[R(r"^FAIL PV-3 exactly one ieb_witness", "PV-3"), R(r"^INCONCLUSIVE PV-3 the 60 s floor swallowed", "PV-3")]),
    I("PL-04", "papyrus", "[IEB-SC] 'JOIN_REFUSED <hex> child' for a child", "S", ["tests_u2_sc.py:151-153", "IEB_SceneMain.psc:419"], ["SC-9"],
      "format VERIFIED in source; first live use", ok=[R(r"^PASS SC-9 direct JoinScene refused: child", "SC-9"), RAW("papyrus", r"\[IEB-SC\] JOIN_REFUSED \S+ child")],
      bad=[R(r"^FAIL SC-9 direct JoinScene refused", "SC-9")]),
    I("PL-05", "papyrus", "TestCtl.SceneOn line '[IEB-TEST] SCENE on partner=' and the StorageUtil read-back IEB_IsScenePartner = 1", "S",
      ["tests_u2_wh.py:117-128", "tests_u2_sc.py:57-67", "IEB_TestCtl.psc:1960"], ["PV-3", "PV-4", "SC-9"], "format VERIFIED in source; first live use",
      ok=[RAW("papyrus", r"\[IEB-TEST\] SCENE on partner=")], bad=[R(r"^INCONCLUSIVE (?:PV-3|PV-4|SC-9) .*SceneOn (?:did not start|wrapper gave no line|read-back)")]),
    I("PL-06", "papyrus", "TestCtl.ConfigProbe line '[IEB-TEST] CONFIGPROBE max=<f> normal=<f> whisper=<f>' (case as written)", "S",
      ["tests_u2_wh.py:44-54 cfg", "tests_u2.py:51-58 radius", "IEB_TestCtl.psc:2070"], ["WE-1", "PV-3", "PV-4"],
      "format VERIFIED in source; the Papyrus string pool can case-fold a literal (runner.py CTL_DONE note), so the exact upper-case spelling is checked in the raw log",
      ok=[RAW("papyrus", r"\[IEB-TEST\] CONFIGPROBE max=-?[\d.]+ normal=-?[\d.]+ whisper=-?[\d.]+")],
      bad=[R(r"^INCONCLUSIVE \S+ ConfigProbe gave no line")]),
    I("PL-07", "papyrus", "SkyrimNetApi.GetConfigFloat('game', 'interaction.maxDistance' / 'normalMaxDistance' / 'whisperMaxDistance') returns the live values (not the sentinels)", "G",
      ["IEB_TestCtl.psc:2070-2080 ConfigProbe", "tests_u2_wh.py:44-54"], ["WE-1", "PV-3", "PV-4"],
      "INFERRED by the spec (tests_u2_wh.py:250 'config name game, dotted path'); config name case-insensitive per REVIEW_LOG R31 (dashboard API); the definitive ConfigProbe check was still pending",
      ok=[RAW("papyrus", r"\[IEB-TEST\] CONFIGPROBE max=(-?[\d.]+) normal=(-?[\d.]+) whisper=(-?[\d.]+)", "cfg_real")],
      bad=[RAW("papyrus", r"\[IEB-TEST\] CONFIGPROBE max=(-?[\d.]+) normal=(-?[\d.]+) whisper=(-?[\d.]+)", "cfg_sentinel"), R(r"^INCONCLUSIVE \S+ config lookup failed")],
      note="expected 1600 / 1600 / 200 (SkyrimNet.yaml interaction:)"),
    I("PL-08", "papyrus", "TestCtl.Whisper line '[IEB-TEST] WHISPERSET want=<n> maxDistance=<f> whisperMax=<f>'", "S", ["tests_u2.py:96-107 set_whisper", "IEB_TestCtl.psc:219"], ["W-3"],
      "format VERIFIED in source; first live use", ok=[RAW("papyrus", r"\[IEB-TEST\] WHISPERSET want=\d maxDistance=-?[\d.]+ whisperMax=-?[\d.]+")],
      bad=[R(r"^INCONCLUSIVE W-3 read-back Whisper", "W-3")]),
    I("PL-09", "papyrus", "SkyrimNetApi.TriggerToggleWhisperMode() switches whisper mode exactly as the hotkey does (maxDistance becomes whisperMaxDistance)", "G",
      ["IEB_TestCtl.psc:219-232", "tests_u2_wh.py:250-251"], ["W-3"], "INFERRED same as the key (tests_u2_wh.py:251)",
      ok=[RAW("papyrus", r"\[IEB-TEST\] WHISPERSET want=1 maxDistance=(-?[\d.]+) whisperMax=(-?[\d.]+)", "whisper_on")],
      bad=[R(r"^INCONCLUSIVE W-3 read-back Whisper\(1\)", "W-3")]),
    I("PL-10", "papyrus", "TestCtl.CountNearNPCs line '[IEB-TEST] NEARNPC n=<n> r=<r>'", "S", ["tests_u2_wh.py:94-105 near", "IEB_TestCtl.psc:272"], ["PV-3", "PV-4"],
      "format VERIFIED in source; first live use", ok=[RAW("papyrus", r"\[IEB-TEST\] NEARNPC n=\d+ r=\d+")], bad=[R(r"^INCONCLUSIVE \S+ CountNearNPCs gave no line")]),
    I("PL-11", "papyrus", "TestCtl.OwnNearestFurniture line '[IEB-TEST] OWNFURN <ref> d=<n> pos=x,y,z'", "S", ["tests_u2_wh.py:108-115 own_room", "IEB_TestCtl.psc:248"], ["PV-3"],
      "format VERIFIED in source; first live use", ok=[RAW("papyrus", r"\[IEB-TEST\] OWNFURN \S+ d=\d+ pos=")], bad=[R(r"^INCONCLUSIVE \S+ no furniture within 500 u to own")]),
    I("PL-12", "papyrus", "owning the nearest furniture (SetActorOwner) stands in for renting a room: whisper turns on (rule ii) and the scene goes private", "G",
      ["tests_u2_wh.py:108 'INFERRED stand-in for renting'", "tests_u2_wh.py:216-243 inn_with_partner"], ["PV-3"],
      "INFERRED (tests_u2_wh.py:109,276)", ok=[RAW("papyrus", r"\[IEB-SC\] WHISPER True"), R(r"^PASS PV-3 ", "PV-3")],
      bad=[R(r"^INCONCLUSIVE PV-3 whisper did not turn on in the 'rented room'", "PV-3")]),
    I("PL-13", "papyrus", "TestCtl.PlayerWhere line '[IEB-TEST] PLAYERPOS cell= ws= x= y= z='", "L", ["tests_u2_wh.py:72-77 where", "IEB_TestCtl.psc:170"], ["PV-3", "PV-4"],
      "seen live in the crash repro / R29 runs", ok=[RAW("papyrus", r"\[IEB-TEST\] PLAYERPOS cell=")], bad=[R(r"^INCONCLUSIVE \S+ no PLAYERPOS")]),
    I("PL-14", "papyrus", "TestCtl.PlaceRel line '[IEB-TEST] PLACE ...' and the CombatProbe dPlayer distance read-back", "S",
      ["tests_u2.py:66-81 place", "IEB_TestCtl.psc:1998", "IEB_TestCtl.psc:2170 CombatProbe (seen live in U1)"], ["WE-1", "X-6", "PV-3", "PV-4", "W-3"],
      "PLACE format VERIFIED in source; first live use", ok=[RAW("papyrus", r"\[IEB-TEST\] PLACE \S+ at \S+ d=")],
      bad=[R(r"^INCONCLUSIVE \S+ read-back PlaceRel")]),
    I("PL-15", "papyrus", "IntelEngine ParseTimeCondition accepts 'in 1 hour' (singular) through TestCtl.ScheduleFetch / ScheduleDelivery; line '[IEB-TEST] ScheduleFetch <n> when=<w> ok=<bool>'", "G",
      ["tests_u2_nt.py:132-134", "IEB_TestCtl.psc:1379-1403"], ["NT-4"],
      "INFERRED (tests_u2_nt.py:111 'time condition format INFERRED'); IntelEngine's own examples list 'in 2 hours' (schedulemeeting.yaml:48)",
      ok=[RAW("papyrus", r"\[IEB-TEST\] Schedule(?:Fetch|Delivery) [^\n]*when=in 1 hour ok=True")],
      bad=[RAW("papyrus", r"\[IEB-TEST\] Schedule(?:Fetch|Delivery) [^\n]*when=in 1 hour ok=False"), R(r"^INCONCLUSIVE NT-4 \w+: scheduling not accepted", "NT-4")]),
    I("PL-16", "papyrus", "IntelEngine patch line 'IEB_SCHED_CONFIRMED skip second box: fetch|deliver' (Core.DebugMsg) and no second box at run time", "S",
      ["tests_u2_nt.py:165-167", "IntelEngine_NPCTasks.psc:368,562"], ["NT-4"], "format VERIFIED in the IE patch source; first live use",
      ok=[R(r"^PASS NT-4 \w+: the scheduled task fired without a second box", "NT-4"), RAW("papyrus", r"IEB_SCHED_CONFIRMED skip second box: (?:fetch|deliver)")],
      bad=[R(r"^FAIL NT-4 \w+: (?:the scheduled task fired|no second confirmation box)", "NT-4")]),
    I("PL-17", "papyrus", "StorageUtil keys IEB_ScenePrivate (player), IEB_IsScenePartner, IEB_SceneMode, IEB_SchedConfirmed read through TestCtl.SUGetInt", "S",
      ["tests_u2_wh.py:138-140 flag", "tests_u2_wh.py:117-128", "tests_u2_nt.py:171-175", "IEB_SceneMain.psc:57,269,274", "IntelEngine_NPCTasks.psc:366"], ["PV-3", "PV-4", "NT-4"],
      "key names VERIFIED in source; SUGetInt seen live in U1 (R55)", ok=[R(r"^\s+su_get \S+ IEB_ScenePrivate = \d+ \(Papyrus\)", "PV-3", "PV-4"), R(r"^PASS PV-3 flag reads 0", "PV-3")],
      bad=[R(r"^\s+su_get \S+ IEB_ScenePrivate = unreadable")]),

    # ---- template decorators, event / slot names used in render() calls
    I("TP-01", "template", "has_line_of_sight(npc.UUID, responseTarget.UUID) in a content render with response_target_uuid", "L", ["tests_u2.py:46-49 los", "tests_misc.py:1757 _attire_probe"],
      ["WE-1", "X-6"], "seen live in U1 X-7 (parsed false/true); re-confirmed here",
      ok=[R(r"^PASS WE-1 A \(300 u, in view\)", "WE-1"), R(r"^\s+equip-type events A", "X-6")],
      bad=[R(r"^INCONCLUSIVE (?:WE-1|X-6) .*(?:without line of sight|line-of-sight setup)")]),
    I("TP-02", "template", "an actor placed at (300, 0, -400) from the player has NO line of sight (terrain blocks it) while the one at (300, 0, 0) has", "G",
      ["tests_u2_misc.py:34-35", "tests_misc.py:1773", "tests_u2.py:7"], ["X-6"], "INFERRED (tests_misc.py:1773 'INFERRED that terrain blocks has_line_of_sight'; self-checked)",
      ok=[R(r"^\s+equip-type events A", "X-6")], bad=[R(r"^INCONCLUSIVE X-6 line-of-sight setup not as wanted", "X-6")]),
    I("TP-03", "template", "history route: get_recent_events(n, [actorUUID]) + format_event(e, 'compact') + contains() + e.type counted in a for-loop", "S",
      ["tests_u2.py:33-43 hist_hits"], ["WE-1", "PV-3", "PV-4", "CS-2"], "usage VERIFIED in our own layer templates (tests_u2.py:5); first live render through render_template",
      ok=[R(r"^PASS WE-1 A \(300 u, in view\): ieb_witness \+1", "WE-1"), R(r"^\s+PV-4: nonce line hits \(counts only\)", "PV-4")],
      bad=[R(r"^\s+render failed:", "WE-1", "PV-3", "PV-4", "CS-2")]),
    I("TP-04", "template", "event type id 'ieb_witness' is what e.type reads for our emitter's event", "S", ["tests_u2.py:339-340"], ["WE-1"],
      "our own schema name (registered, LG-06)", ok=[R(r"^PASS WE-1 A \(300 u, in view\): ieb_witness \+1", "WE-1")],
      bad=[R(r"^FAIL WE-1 A \(300 u, in view\)", "WE-1")]),
    I("TP-05", "template", "event type 'dialogue' on the child's history rises by 2 per injected line (e.type == 'dialogue')", "G",
      ["tests_u2_misc.py:87-92 cs2"], ["CS-2"],
      "type id 'dialogue' is in the DLL event list and used by skyrimnet.base prompts; the '+2 per exchange' count is INFERRED (unmarked)",
      ok=[R(r"^PASS CS-2 \w+: the child replied", "CS-2")], bad=[R(r"^FAIL CS-2 \w+: the child replied", "CS-2")],
      note="a FAIL line shows the before -> after counts; adjust the +2 threshold from them"),
    I("TP-06", "template", "an equip / unequip event has a type id containing 'equip' (contains(e.type, 'equip'))", "G", ["tests_u2_misc.py:55-60 render_equip", "tests_u2_misc.py:47"], ["X-6"],
      "INFERRED name (tests_u2_misc.py:17,47); the DLL event list has no 'equip*' id (it names the schema 'Equipment change')",
      ok=[R(r"^PASS X-6 B \(no line of sight\) gets no equip event", "X-6")], bad=[R(r"^INCONCLUSIVE X-6 no equip-type event reached A", "X-6")]),
    I("TP-07", "template", "get_worn_equipment slot keys 'feet' / 'hands' exist for non-body items", "G", ["tests_u2_misc.py:23-27"], ["X-6"],
      "only 'torso' is VERIFIED live (tests_misc.py:386); 'feet'/'hands' unmarked", ok=[R(r"^\s+equip-type events A", "X-6")],
      bad=[R(r"^INCONCLUSIVE X-6 the player wears nothing on feet or hands", "X-6")],
      note="a miss may also mean the test player wears nothing there: read the slot keys in worn_rows output before changing the names"),
    I("TP-08", "template", "an inline thought is stored as an event whose type contains 'thought'", "G", ["tests_u2_len.py:153-156,514,747-752"], ["SEC-4"],
      "INFERRED (tests_u2_len.py:737); DLL knows npc_thought / npc_thoughts", ok=[R(r"^\s+RECORD private-token hits in thought events", "SEC-4")],
      bad=[R(r"^INCONCLUSIVE SEC-4 no thought event stored", "SEC-4")]),
    I("TP-09", "template", "inja length(), replace(), lower() on strings inside render_template", "G", ["tests_u2_len.py:72-92 marks", "tests_u2_len.py:622-628"], ["SEC-2", "SEC-4"],
      "length() on a STRING and lower() INFERRED (tests_u2_len.py:12-14); replace() is used by SkyrimNet's own prompt (neutral_ve_name.md:108)",
      ok=[R(r"^\s+overhead spaces per event \(calibrated\)", "SEC-2", "SEC-4")],
      bad=[R(r"^INCONCLUSIVE SEC-\d marker render failed", "SEC-2", "SEC-4"), R(r"^\s+render failed:", "SEC-2", "SEC-4")]),
    I("TP-10", "template", "existsIn(e, 'originatingActor'), isValidActor(e.originatingActor), decnpc(...).name, e.gameTime, e.type, {% set %} in one loop", "S",
      ["tests_u2_len.py:72-92 marks"], ["SEC-2", "SEC-4"], "VERIFIED in our own layer templates (tests_u2_len.py:10-12); first live render",
      ok=[R(r"^\s+overhead spaces per event \(calibrated\)", "SEC-2", "SEC-4")],
      bad=[R(r"^INCONCLUSIVE SEC-\d calibration line produced", "SEC-2", "SEC-4"), R(r"^INCONCLUSIVE SEC-\d marker render failed", "SEC-2", "SEC-4")]),
    I("TP-11", "template", "render_subcomponent('character_bio','full') contains the invented SEC tokens zqmoonlamp / zqbrasskey (test layer 'SkyrimNet Test - SEC Bio')", "G",
      ["tests_u2_len.py:47 SEC_KEYS", "tests_u2_len.py:622-635 _sec_ready"], ["SEC-2", "SEC-4"],
      "INFERRED convention (tests_u2_len.py:47,650); render_subcomponent seen live in U1", ok=[R(r"^\s+overhead spaces per event \(calibrated\)", "SEC-2", "SEC-4")],
      bad=[R(r"^INCONCLUSIVE SEC-\d the test bio token", "SEC-2", "SEC-4")]),
    I("TP-12", "template", "render_template('components\\\\actions_list') is the action-list template name", "G", ["tests_u2_nt.py:102"], [],
      "INFERRED (tests_u2_nt.py:102 'template name INFERRED')", ok=[], bad=[],
      note="NOT REACHED by design: only NT-2, which is a GameMaster test (block.GM_TESTS) and takes 3 loads, so no cheap smoke test can run it; leave it to U2-A"),
    I("TP-13", "template", "NT-2: 'NOTICE N1 shown' once per load, action IEB_ReadyProbe never eligible", "G", ["tests_u2_nt.py:74-103"], [],
      "unmarked first live use", ok=[], bad=[], note="NOT REACHED by design: same reason as TP-12"),
]

# ------------------------------------------------------------------------------------------------ run loading
STAMP_RX = re.compile(r"^(?P<tid>.+?)_(?P<setup>setup_)?(?P<stamp>\d{8}-\d{6})\.txt$")


def stamp_to_epoch(s):
    return time.mktime(time.strptime(s, "%Y%m%d-%H%M%S"))


def newest_summary(block):
    cands = [p for p in glob.glob(OUT + "%s_*.md" % block) if "_setup_" not in os.path.basename(p)]
    return max(cands, key=os.path.getmtime) if cands else None


def read(p):
    try:
        return open(p, encoding="utf-8", errors="replace").read()
    except OSError:
        return ""


class Ctx:
    def __init__(self):
        self.results = {}      # tid -> dict(verdict, secs, text, lines)
        self.raw = {"papyrus": "", "skyrimnet": "", "sa": ""}
        self.trace = []
        self.window = (0.0, 9e12)
        self.sources = []


def load_run(summary, since, block, out_dir=OUT):
    ctx = Ctx()
    start, end, tests = 0.0, 9e12, []
    stem = None
    if summary:
        m = re.search(r"^(?P<b>.+?)_(?P<stamp>\d{8}-\d{6})\.md$", os.path.basename(summary))
        block, start, stem = m.group("b"), stamp_to_epoch(m.group("stamp")), os.path.splitext(summary)[0]
        end = os.path.getmtime(summary) + 120
        for line in read(summary).splitlines():
            c = [x.strip() for x in line.strip().strip("|").split("|")]
            if len(c) >= 3 and re.fullmatch(r"[A-Z][A-Za-z0-9]*-[A-Za-z0-9]+", c[0]):
                tests.append((c[0], c[1], c[2]))
        ctx.sources.append("summary %s" % summary)
    elif since:
        start = time.mktime(time.strptime(since, "%Y-%m-%d %H:%M:%S"))
        stem = None
    ctx.window = (start, end)
    wanted = set(SMOKE_TESTS) if block == SMOKE_BLOCK else None
    for p in glob.glob(out_dir + "*.txt"):
        m = STAMP_RX.match(os.path.basename(p))
        if not m or m.group("setup"):
            continue
        tid, t = m.group("tid"), stamp_to_epoch(m.group("stamp"))
        if t < start or t > end or (wanted is not None and tid not in wanted) or tid.endswith("_CONTROL") or tid == "SMOKE":
            continue
        if tid not in ctx.results or t > ctx.results[tid]["t"]:
            text = read(p)
            ctx.results[tid] = dict(t=t, text=text, lines=text.splitlines(), path=p, verdict="", secs="")
    for tid, verdict, secs in tests:
        if tid in ctx.results:
            ctx.results[tid]["verdict"], ctx.results[tid]["secs"] = verdict, secs
    for tid, d in ctx.results.items():
        if not d["verdict"]:
            last = [l for l in d["lines"] if l.startswith("saved ")]
            d["verdict"] = last[-1].split("; ", 1)[-1] if last else "?"
    raw_dir = (stem + "/raw/") if stem and os.path.isdir(stem + "/raw") else None
    live = {"papyrus": os.path.expanduser("~/Documents/My Games/Skyrim Special Edition/Logs/Script/Papyrus.0.log"),
            "skyrimnet": os.path.expanduser("~/Documents/My Games/Skyrim Special Edition/SKSE/SkyrimNet.log"),
            "sa": os.path.expanduser("~/Documents/My Games/Skyrim Special Edition/SKSE/SeverActionsNative.log")}
    if raw_dir:
        for p in sorted(glob.glob(raw_dir + "*")):
            n = os.path.basename(p).lower()
            kind = "papyrus" if "papyrus" in n else "skyrimnet" if "skyrimnet" in n else "sa" if "severactions" in n else None
            if kind:
                ctx.raw[kind] += read(p) + "\n"
        ctx.sources.append("raw logs %s" % raw_dir)
    else:
        for k, p in live.items():
            ctx.raw[k] = read(p)
        ctx.sources.append("live logs (no raw archive for this run yet)")
    if os.path.exists(TRACE if out_dir == OUT else out_dir + "iface_trace.jsonl"):
        for line in read(TRACE if out_dir == OUT else out_dir + "iface_trace.jsonl").splitlines():
            try:
                rec = json.loads(line)
            except ValueError:
                continue
            if start <= rec.get("t", 0) <= end:
                ctx.trace.append(rec)
        ctx.sources.append("trace %d call(s)" % len(ctx.trace))
    return ctx


# ------------------------------------------------------------------------------------------------ evaluation
def _items_of(resp):
    """The list-shaped part of a response shape: {'list': n, 'items': [...]} at the top or one level down."""
    if not isinstance(resp, dict):
        return None
    if "list" in resp and "items" in resp:
        return resp
    for v in resp.values():
        if isinstance(v, dict) and "list" in v and "items" in v:
            return v
    return None


def trace_pred(recs, pred):
    """(hit, detail) of a named predicate over the trace records of one endpoint."""
    okr = [r for r in recs if r.get("status") and 200 <= r["status"] < 300 and not r.get("err")]
    if pred == "ok":
        if not okr:
            return False, ""
        keys = okr[0].get("resp")
        det = "%d ok of %d call(s), median %d ms" % (len(okr), len(recs), sorted(r["ms"] for r in okr)[len(okr) // 2])
        if isinstance(keys, dict):
            det += "; fields %s" % sorted(keys.keys())[:10]
        return True, det
    if pred == "all_err":
        bad = [r for r in recs if r.get("err") or not (r.get("status") and 200 <= r["status"] < 300)]
        return (bool(recs) and len(bad) == len(recs)), "%d of %d call(s) failed, e.g. %s" % (len(bad), len(recs), (bad[0].get("err") or bad[0].get("status")) if bad else "")
    if pred == "timed_out":
        t = [r for r in okr if isinstance(r.get("resp"), dict) and any("timed" in str(k).lower() and v is True for k, v in r["resp"].items())]
        return (bool(t) and len(t) == len(okr)), "%d of %d call(s) reported a timeout" % (len(t), len(okr))
    shapes = [_items_of(r.get("resp")) for r in okr]
    shapes = [s for s in shapes if s]
    if pred == "list":
        return bool(shapes), ("list shape seen: %s" % ("; ".join("%d item(s), fields %s" % (s["list"], sorted((s["items"][0] or {}).keys()) if s["items"] and isinstance(s["items"][0], dict) else "-") for s in shapes[:1])) if shapes else "")
    if pred == "no_list":
        return (bool(okr) and not shapes), "answers had no list: top-level fields %s" % (sorted(okr[0]["resp"].keys()) if okr and isinstance(okr[0].get("resp"), dict) else "?")
    populated = [s for s in shapes if s["list"] > 0 and s["items"] and isinstance(s["items"][0], dict)]
    if pred == "text_field":
        for s in populated:
            for it in s["items"]:
                for k in TEXT_KEYS:
                    if isinstance(it, dict) and str(it.get(k, "")).startswith("str"):
                        return True, "text field '%s'; item fields %s" % (k, sorted(it.keys()))
        return False, ("items present but none has a text field: item fields %s" % sorted(populated[0]["items"][0].keys())) if populated else ""
    if pred in ("id_field", "no_id_field"):
        for s in populated:
            for it in s["items"]:
                ids = [k for k, v in it.items() if k not in TEXT_KEYS and str(v).startswith("hex")]
                if ids:
                    return pred == "id_field", "id-like field(s) %s" % ids
        if populated:
            return pred == "no_id_field", "no id-like field: item fields %s" % sorted(populated[0]["items"][0].keys())
        return False, ""
    return False, ""


def eval_rule(rule, ctx):
    """(hit, evidence) for one rule."""
    if "all" in rule:
        outs = [eval_rule(r, ctx) for r in rule["all"]]
        return all(h for h, _ in outs), " + ".join(e for h, e in outs if h)
    if "res" in rule:
        rx = re.compile(rule["res"], re.M)
        for tid, d in ctx.results.items():
            if rule["t"] and tid not in rule["t"]:
                continue
            m = rx.search(d["text"])
            if m:
                line = d["text"][m.start():].split("\n", 1)[0].strip()
                return True, "%s: %s" % (tid, line[:150])
        return False, ""
    if "raw" in rule:
        rx = re.compile(rule["rx"])
        hits = list(rx.finditer(ctx.raw.get(rule["raw"], "")))
        if rule.get("pred"):
            hits = [m for m in hits if raw_pred(rule["pred"], m)]
        if hits:
            return True, "%s log: %s%s" % (rule["raw"], hits[0].group(0)[:110], " (+%d more)" % (len(hits) - 1) if len(hits) > 1 else "")
        return False, ""
    if "trace" in rule:
        recs = [r for r in ctx.trace if r.get("api") == rule["trace"]
                and all(str((r.get("params") or {}).get(k)) == str(v) or str((r.get("body") or {}).get(k)) == str(v)
                        for k, v in rule["params"].items())]
        if not recs:
            return False, ""
        hit, det = trace_pred(recs, rule["pred"])
        return hit, "trace %s: %s" % (rule["trace"], det)
    return False, ""


def raw_pred(name, m):
    try:
        vals = [float(x) for x in m.groups() if x is not None]
    except ValueError:
        return False
    if name == "cfg_real":
        return len(vals) == 3 and min(vals) > -7000
    if name == "cfg_sentinel":
        return len(vals) == 3 and min(vals) <= -7000
    if name == "whisper_on":
        return len(vals) == 2 and abs(vals[0] - vals[1]) < 0.5
    return True


def judge(item, ctx):
    """(verdict, evidence) for one inventory item."""
    ran = [t for t in item["tests"] if t in ctx.results]
    if not item["tests"]:
        return "NOT REACHED", "no U2SMOKE test covers it. %s" % item["note"]
    bad = next(((True, e) for r in item["bad"] for h, e in [eval_rule(r, ctx)] if h), (False, ""))
    ok = next(((True, e) for r in item["ok"] for h, e in [eval_rule(r, ctx)] if h), (False, ""))
    if bad[0]:
        return "FAILED", bad[1] + ("  [also worked: %s]" % ok[1] if ok[0] else "")
    if ok[0]:
        return "WORKED", ok[1]
    if not ran:
        return "NOT REACHED", "covering test(s) %s did not run" % ", ".join(item["tests"])
    why = []
    for t in ran:
        d = ctx.results[t]
        first = next((l for l in d["lines"] if l.startswith(("INCONCLUSIVE", "FAIL"))), "")
        why.append("%s %s%s" % (t, d["verdict"], (": " + first[:110]) if first else ""))
    return "NOT REACHED", "ran but never got to it: " + "; ".join(why)


# ------------------------------------------------------------------------------------------------ output
def wrap(s, w):
    out, cur = [], ""
    for word in s.split(" "):
        if len(cur) + len(word) + 1 > w and cur:
            out.append(cur)
            cur = word
        else:
            cur = (cur + " " + word).strip()
    return out + [cur]


def report(ctx, md_path=None, out=sys.stdout):
    rows = [(it, *judge(it, ctx)) for it in INVENTORY]
    p = lambda s="": print(s, file=out)
    p("U2 INTERFACE REPORT  (%s)" % "; ".join(ctx.sources))
    p("")
    p("Tests in the window:")
    for t in SMOKE_TESTS:
        d = ctx.results.get(t)
        p("  %-6s %s" % (t, ("%s%s" % (d["verdict"], (" (%ss)" % d["secs"]) if d["secs"] else "")) if d else "not run"))
    p("")
    p("%-6s %-2s %-11s %s" % ("ID", "C", "RESULT", "guessed name  /  evidence"))
    p("-" * 118)
    for it, v, ev in rows:
        p("%-6s %-2s %-11s %s" % (it["id"], it["cls"], v, it["name"]))
        for line in wrap(ev, 104):
            p("%s%s" % (" " * 21, line))
    p("")
    cnt = {}
    for it, v, ev in rows:
        cnt[(it["cls"], v)] = cnt.get((it["cls"], v), 0) + 1
    p("Totals: %d items. %s" % (len(rows), "; ".join("%s: %s" % (v, ", ".join("%s %d" % (c, n) for (c, vv), n in sorted(cnt.items()) if vv == v))
                                                       for v in ("WORKED", "FAILED", "NOT REACHED"))))
    p("Mark VERIFIED (code comment / docs) only the WORKED rows; FAILED rows need a harness fix, NOT REACHED rows a rerun of the named test.")
    if md_path:
        with open(md_path, "w", encoding="utf-8") as f:
            f.write("# U2 interface report\n\n%s\n\n| ID | Class | Result | Guessed name | Evidence |\n|---|---|---|---|---|\n" % "; ".join(ctx.sources))
            for it, v, ev in rows:
                f.write("| %s | %s | %s | %s | %s |\n" % (it["id"], it["cls"], v, it["name"].replace("|", "/"), ev.replace("|", "/")))
    return rows


def rule_text(r):
    if "all" in r:
        return " AND ".join(rule_text(x) for x in r["all"])
    if "res" in r:
        return "result `%s`%s" % (r["res"], (" in " + "/".join(r["t"])) if r["t"] else "")
    if "raw" in r:
        return "%s log `%s`%s" % (r["raw"], r["rx"], (" [%s]" % r["pred"]) if r.get("pred") else "")
    return "trace %s %s%s" % (r["trace"], r["pred"], (" " + json.dumps(r["params"])) if r["params"] else "")


STATIC_NOTES = [
    "The DLL string table (skyrimnet_b25_1_dll_strings.txt) lists the trigger event ids dialogue, dialogue_npc, dialogue_player, npc_thoughts, player_thoughts, activation, "
    "combat, enter_bleedout, book_read, mod_event ... and NO id containing 'equip' (the equip event's schema is titled 'Equipment change', :56845): TP-06 stays a real guess.",
    "The ui-state strings are 'menu_open', 'MessageBoxMenu open but the game thread did not respond' and a log of '<n> menu(s), box=<..>' (:58227-58229), so the response most likely "
    "has menus / box fields; whether str(response) holds the literal 'MessageBoxMenu' while a box is open is HT-03.",
    "dismiss-ui validates 'button must be a non-negative integer' (:58335): an INDEX; which index is Allow is HT-13 (NT-4 reads the scheduling result ok=True afterwards).",
    "Tests that end INCONCLUSIVE by design and so never come back ALL PASS: PV-1, PV-2 ('judgement part left for the reviewer'), SEC-1, SEC-2 (Shae's reading), DA-2, DA-7 (stubs), SC-1, SC-3. "
    "block.early_stop_class does not count them (a by-design-only test with no PASS line is left out of the first-n window; with PASS lines it counts as informative).",
    "SEC-4 needs the inline-thoughts setting on (allow_inline_internal_thoughts in the 0500 template, not set in any config file of the test profile): if it is off the test is "
    "INCONCLUSIVE after its render and TP-08 is the item that stays NOT REACHED; switch the setting and rerun SEC-4 alone (--only SEC-4).",
    "SEC-1/2/4 need the 'SkyrimNet Test - SEC Bio' layer and the Discretion layer rescanned in the running game (Content Library -> Rescan); without it they are INCONCLUSIVE at _sec_ready "
    "and the length/utterance items (HT-05..07, TP-09..11) stay NOT REACHED.",
    "NT-2 is in block.GM_TESTS (a GameMaster-off block refuses to start with it), takes three loads and polls up to 600 s per load: not a smoke test. Its guessed items "
    "(TP-12 template name components/actions_list, TP-13 the N1 notice / IEB_ReadyProbe) are left to U2-A itself.",
    "Time: each reload=True test adds ~170-200 s of reload and settle (U1 PROGRESS lines), so the 14 smoke tests cost roughly 12 reloads x 3 min + about 37 min of test bodies + 9 min of "
    "launch and first load = about 80 min, not 20-30. Dropping W-3, PV-4 and NT-4 (the three most expensive per item) gives roughly 45 min and leaves PL-08, PL-09, GD-02, HT-03, HT-13, PL-15, PL-16 NOT REACHED.",
]


def inventory_md(path):
    by = {}
    for it in INVENTORY:
        by.setdefault(it["cls"], []).append(it)
    cover = {t: [it["id"] for it in INVENTORY if t in it["tests"]] for t in SMOKE_TESTS}
    with open(path, "w", encoding="utf-8") as f:
        f.write("# U2-A interface inventory (REVIEW_LOG RV-153)\n\n")
        f.write("Generated from `build/tools/harness/u2_interface_report.py` (the INVENTORY list is the data; edit it there and rerun "
                "`python u2_interface_report.py --inventory-md <this file>`). Written 2026-10-11 by the builder's helper. "
                "Labels: **G** guessed (marked INFERRED / unresolved), **S** resolved statically (DLL string table, our source, prompt/layer file, Skyrim.esm string) "
                "but never seen live, **L** seen live before. No quest names, stages, plot events or story outcomes.\n\n")
        f.write("Scope: tests_u2.py (H-2, WE-1, WE-4, W-1..3), tests_u2_da.py (DA-1..8), tests_u2_wh.py (PV-1..4, WH-4), tests_u2_sc.py (SC-9), tests_u2_misc.py "
                "(CS-2, X-6), tests_u2_nt.py (NT-1/2/4), tests_u2_len.py (SEC-1..4), the U2 block (`blocks_def.py`) and the U2-A list "
                "(`early_start_plan.md` section 1.3). Counted in the totals: **%d** distinct items, of which **%d G**, **%d S**, **%d L**. "
                "Not used by any U2-A test (so not inventoried): inject-event, select-topic, purge, reset-cooldowns, await kind=event, tap, engine-sweep.\n\n"
                % (len(INVENTORY), len(by.get("G", [])), len(by.get("S", [])), len(by.get("L", []))))
        f.write("## How the smoke covers it\n\n`U2SMOKE` (blocks_def.py) runs: %s.\n\n" % ", ".join(SMOKE_TESTS))
        f.write("| Test | Items it reaches |\n|---|---|\n")
        for t in SMOKE_TESTS:
            f.write("| %s | %s |\n" % (t, ", ".join(cover[t]) or "-"))
        unreached = [it["id"] for it in INVENTORY if not it["tests"]]
        f.write("\nNot reachable by any smoke test: %s (reasons in the table).\n\n" % ", ".join(unreached))
        f.write("## Static findings made while building the inventory\n\n")
        for n in STATIC_NOTES:
            f.write("- %s\n" % n)
        f.write("\n## Inventory\n\n")
        for cat in ("http", "mcp", "data", "log", "papyrus", "template"):
            f.write("### %s\n\n" % {"http": "SkyrimNet /harness HTTP endpoints and response fields (sn_harness.py)", "mcp": "MCP tools, arguments, response fields",
                                    "data": "Game data names", "log": "SkyrimNet / SeverActions log lines matched by regex",
                                    "papyrus": "Our Papyrus log lines, TestCtl wrappers, SkyrimNetApi calls, StorageUtil keys",
                                    "template": "Template decorators, template names, event / slot names used in render() calls"}[cat])
            for it in [x for x in INVENTORY if x["cat"] == cat]:
                f.write("- **%s** [%s] %s\n" % (it["id"], it["cls"], it["name"]))
                f.write("  - where: %s\n" % "; ".join(it["where"]))
                f.write("  - used by: %s\n" % (", ".join(it["tests"]) or "-- (no smoke test)"))
                f.write("  - marked: %s\n" % it["marked"])
                if it["ok"]:
                    f.write("  - WORKED when: %s\n" % " | ".join(rule_text(r) for r in it["ok"]))
                if it["bad"]:
                    f.write("  - FAILED when: %s\n" % " | ".join(rule_text(r) for r in it["bad"]))
                if it["note"]:
                    f.write("  - note: %s\n" % it["note"])
            f.write("\n")
    print("wrote %s (%d items)" % (path, len(INVENTORY)))


# ------------------------------------------------------------------------------------------------ selftest
def selftest():
    """Synthetic run in a temp dir: a few results, a raw log, a trace. Checks the table logic, prints the table."""
    global TRACE
    d = tempfile.mkdtemp(prefix="u2rep_")
    out_dir = d.replace("\\", "/") + "/"
    stamp = time.strftime("%Y%m%d-%H%M%S")
    os.makedirs(out_dir + "U2SMOKE_%s/raw" % stamp)
    open(out_dir + "U2SMOKE_%s.md" % stamp, "w").write("# U2SMOKE\n\n| Test | Verdict | Seconds | Note |\n|---|---|---|---|\n| H-2 | ALL PASS | 3 | |\n| DA-3 | 1 FAIL | 99 | |\n| SEC-3 | INCONCLUSIVE (1) | 5 | |\n")
    open(out_dir + "H-2_%s.txt" % stamp, "w").write("PASS H-2 /harness status answers (ok keys=['status'])\nPASS H-2 /harness ui-state answers (ok keys=[])\n"
                                                    "PASS H-2 /harness utterances answers (ok keys=[])\nPASS H-2 /harness overrides pacing_governor=bypass accepted\n")
    open(out_dir + "DA-3_%s.txt" % stamp, "w").write("PASS DA-3 TriggerDialogueLine fired for the room request\nFAIL DA-3 [TIF-EXEC] fired info\n  vanilla voice starts (count): 0\n")
    open(out_dir + "SEC-3_%s.txt" % stamp, "w").write("INCONCLUSIVE SEC-3 player_dialogue did not render (template name INFERRED)\n")
    open(out_dir + "U2SMOKE_%s/raw/120000_end_Papyrus.0.log" % stamp, "w").write("[IEB-TEST] CONFIGPROBE max=1600.0 normal=1600.0 whisper=200.0 skyrimnet=1600.0\n[IEB-SC] WITNESS exposure rc=2\n")
    open(out_dir + "U2SMOKE_%s/raw/120000_end_SkyrimNet.log" % stamp, "w").write("Registered newly discovered external layer 'shae.dialogue-actions' at top priority\n[DialogueActionsLibrary] 3 whitelist and 12 blacklist entr(ies), 1 instruction(s) active\n")
    t = time.time()
    open(out_dir + "iface_trace.jsonl", "w").write("\n".join(json.dumps(x) for x in [
        {"t": t, "m": "GET", "api": "status", "params": {"api": "status"}, "body": None, "status": 200, "ms": 12, "resp": {"status": "str2"}, "err": None},
        {"t": t, "m": "GET", "api": "utterances", "params": {"api": "utterances"}, "body": None, "status": 200, "ms": 9,
         "resp": {"utterances": {"list": 2, "items": [{"speaker_uuid": "hex16", "text": "str30"}, {"speaker_uuid": "hex16", "text": "str9"}]}}, "err": None},
        {"t": t, "m": "POST", "api": "inject-player-input", "params": {"api": "inject-player-input"}, "body": {"text": "str20", "target_uuid": "str32"}, "status": 200, "ms": 40, "resp": {}, "err": None},
        {"t": t, "m": "GET", "api": "await", "params": {"api": "await", "kind": "idle", "timeout_s": 60}, "body": None, "status": 200, "ms": 4100, "resp": {"idle": True}, "err": None}]) + "\n")
    summary = out_dir + "U2SMOKE_%s.md" % stamp
    os.utime(summary, (t + 5, t + 5))
    ctx = load_run(summary, None, SMOKE_BLOCK, out_dir)
    # trace path of the temp dir
    rows = report(ctx)
    got = {it["id"]: v for it, v, ev in rows}
    exp = {"HT-01": "WORKED", "HT-05": "WORKED", "HT-06": "WORKED", "HT-07": "WORKED", "HT-08": "WORKED", "HT-10": "WORKED", "LG-01": "WORKED", "LG-02": "WORKED",
           "LG-03": "WORKED", "LG-04": "FAILED", "LG-05": "FAILED", "MC-02": "FAILED", "PL-01": "WORKED", "PL-07": "WORKED", "PL-06": "WORKED",
           "TP-12": "NOT REACHED", "PV-3": None}
    bad = [(k, got.get(k), v) for k, v in exp.items() if v is not None and got.get(k) != v]
    print("\nSELFTEST", "OK" if not bad else "MISMATCH %s" % bad)
    return 0 if not bad else 1


def main(argv):
    ap = argparse.ArgumentParser(description="U2 interface report: guessed name -> WORKED / FAILED / NOT REACHED (REVIEW_LOG RV-153)")
    ap.add_argument("--run", help="a test_runs/U2SMOKE_<stamp>.md summary (default: the newest one)")
    ap.add_argument("--since", help='window start "YYYY-MM-DD HH:MM:SS" instead of a summary file (run still going, or HALTed without a summary)')
    ap.add_argument("--block", default=SMOKE_BLOCK, help="block name for --since / the default summary (default U2SMOKE)")
    ap.add_argument("--md", help="also write the table as markdown")
    ap.add_argument("--inventory-md", help="write the inventory document and exit")
    ap.add_argument("--list", action="store_true", help="print the inventory and exit")
    ap.add_argument("--selftest", action="store_true", help="dry run on synthetic results")
    a = ap.parse_args(argv)
    if a.inventory_md:
        inventory_md(a.inventory_md)
        return 0
    if a.list:
        for it in INVENTORY:
            print("%-6s %s %-8s %-40s %s" % (it["id"], it["cls"], it["cat"], ",".join(it["tests"]) or "-", it["name"]))
        c = {}
        for it in INVENTORY:
            c[it["cls"]] = c.get(it["cls"], 0) + 1
        print("%d items: %s" % (len(INVENTORY), ", ".join("%s %d" % kv for kv in sorted(c.items()))))
        return 0
    if a.selftest:
        return selftest()
    summary = a.run or (None if a.since else newest_summary(a.block))
    if not summary and not a.since:
        print("no %s summary in %s; pass --run or --since" % (a.block, OUT))
        return 2
    ctx = load_run(summary, a.since, a.block)
    report(ctx, a.md)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
