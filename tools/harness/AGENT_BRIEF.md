# Brief: drafting step-8 U1 test modules (for helper agents, 2026-10-10)

You are drafting Python test functions for the Errand Bridge test harness. Nobody will run them until block U1 starts
(Claude launches the game later). Your job: implement each assigned test faithfully to its spec row, mark every
assumption, and report what game-side helpers are missing. **Do not run anything against the game. Do not launch the
game.** MCP is not up.

## Hard rules (Shae's standing rules; breaking one is worse than leaving a test unimplemented)
- Never ask for, read, display or store API keys.
- `C:\Nolvus` is **read-only** for you. Read sources there freely; write nothing there.
- Write only your own module file(s) named in your task, under `C:\nolvus-research\build\tools\harness\`. Do not edit
  `runner.py`, `block.py`, `game.py`, `blocks_def.py`, any `.psc`, the spec, TASK_C or any other doc.
- Spoilers: never print or copy into code/comments any Gaius knowledge-pack text, quest stage text, journal text,
  dialogue text, or story-quest EditorIDs beyond what a test literally needs as an identifier. Tests report pass/fail,
  FormIDs, stage numbers, counts. Never print `MARAS.log` content (counts only). Never open or quote `*_SPOILERS.md` or
  `LUCIENNE_CANON.md`.
- Child-safety tests (CS-*): test that gates hold; never build anything that would make a child a scene participant.
- Mark every claim VERIFIED (with `file:line`) or INFERRED in code comments where the step depends on it.
- Don't invent function names in mods: grep their sources (`C:\Nolvus\Instances\Nolvus Awakening\MODS\mods\<mod>\Source\Scripts`,
  `C:\nolvus-research\build\src\...`, `C:\nolvus-research\repos\...`, `C:\nolvus-research\build\upstream\...`).

## Framework API (read `runner.py`, `block.py`, `game.py` in this folder)
```python
from block import test
@test("B-1", "B")                       # family; save="T0" default; reload=True if the test leaves the save dirty
def b1(r):                              # r is runner.Run
    r.tool(name, args)                  # any MCP tool -> parsed dict (or {"error":...} / {"text":...})
    r.ctl("StartTask", [formid, "GoToLocation", "WhiterunDrunkenHuntsman", "", ""])   # IEB_TestCtl member function
    u, info = r.uuid(0xE1BA9)           # SkyrimNet UUID (hex str) of a loaded actor via IEB_TestCtl.UUIDOf
    r.tails["papyrus"|"watch"|"skyrimnet"|"sa"]   # game.Tail, marked at test start:
        .read()  -> text since the test started;  .wait(regex, timeout=s) -> match or None;  .mark()
    r.check(cond, "what")               # PASS/FAIL line, counts fails
    r.log("text"); r.inconclusive += 1  # INCONCLUSIVE when a precondition failed (say why)
```
- Console: use `tests_misc.con(r, "000E1BA9.moveto player")`. It turns a leading hex-ref prefix into the MCP tool's
  `target_form_id` (`con_args()`). VERIFIED 2026-10-11 (REVIEW_LOG RV-123): `execute_console_command` runs every command
  against `target_form_id`, which defaults to the PLAYER. A raw `"<hexref>.<cmd>"` prefix is NOT resolved, and
  `prid <ref>` followed by a bare command ALSO runs on the player. Never send a ref command without `target_form_id`.
  Every console or MCP state write must be followed by a read-back assert (RV-123 (3)).
- Quest functions: `r.tool("execute_quest_function", {"quest_editor_id": Q, "script_name": S, "function_name": F,
  "arguments": [...]})`. Actor args: pass hex FormID strings like `"0x000E1BA9"` (VERIFIED for SeverActions
  `SwearCampToPlayer` 2026-10-09); Int args as ints.
- Templates: `r.tool("render_template", {"actor_uuid": u, "content": "{{ is_follower(actorUUID) }}"})["renderedContent"]`.
  Useful decorators (VERIFIED live 2026-10-10): `is_follower`, `is_sever_follower`, `sever_follow_state`,
  `retainer_status`, `is_steward`, `sever_home`, `sever_work_location`, `sever_camp_state`, `is_in_combat`,
  `sever_in_scene`, `papyrus_util("GetIntValue", actorUUID, "IEB_Gate", 0)`, `short_time(gameTime)`.
  `get_nearby_actors` and `get_nearby_npc_list` returned "Unknown internal error" in Whiterun on 2026-10-10: don't rely on them.
- Eligibility: `r.tool("check_action_eligibility", {"action_name": "SitOrLayDown", "actor_uuid": u})` -> `isEligible`.
  SeverActions checks read ineligible for ~2 min after a load (block.py settles first).
- Waiting on game time: `r.ctl("Accelerate", [1000.0])` ... `r.ctl("RestoreTimescale")`, then `r.ctl("AssertTimescale")` and
  check the Papyrus log for `ASSERT PASS TIMESCALE`. **Always restore in a `finally:`.** Accelerate only for game-clock
  timeouts (Shae's D3 rule).
- Bridge log lines: read `C:\nolvus-research\build\src\errandbridge\Source\Scripts\IEB_Main.psc` for exact formats
  (e.g. `[IEB] TAKE actor=...`, `REFUSE reason=...`, `REJOIN_WAIT`, `LEND kind=...`). Watcher lines go to the
  `watch` tail (`IEB_Watcher.psc`, `ASSERT PASS|FAIL <rule> ...`). Controller lines are `[IEB-TEST] ...` in papyrus.
- Burst sampler (B-22): `r.ctl("Burst", [formid, 60.0])`, then run `burst_b22.py` (already written) on the watch log.

## IEB_TestCtl functions available now (`build/src/harness/Source/Scripts/IEB_TestCtl.psc`)
Snapshot, ExpectWFP, StartTask(formId, action, a1, a2, a3) [GoToLocation/FetchPerson/SearchForActor/DeliverMessage/
EscortTarget], Cancel, Recall(formId, stay), UUIDOf, Check(formId) [watcher invariant check], Lend, Restore,
Dispatch(formId, "story"|"social"), Burst, Rejoin, QPFill, QPClear, CFProbe, RecordTimescale, Accelerate,
RestoreTimescale, AssertTimescale, TestCFRefuse. Read the file for exact semantics.

**If a test needs a game-side helper that doesn't exist** (door activate, FastTravel, StartSneaking, DirectNarration,
ExecuteAction, NFF dismiss, SA settle...): write the Python as if `r.ctl("<NewName>", [...])` exists, and put the
exact Papyrus you propose (signature + body, compiling against the APIs you verified) in your final report. Claude
integrates and compiles them. Keep wrappers minimal and test-only.

## T0 cast (save "T0", Whiterun market, 9:11 AM; all Skyrim.esm refs)
| Tag | Who | Ref FormID |
|---|---|---|
| player | "Prisoner" | 0x14 |
| F1 (also E, enrolled companion: INFERRED, confirm in code via log/decorator) | Jenassa | 0x000E1BA9 |
| F2 | Uthgerd | 0x00091918 |
| H (Home Bannered Mare, Work market, Relax Gildergreen) | Brenuin | 0x0002C90F |
| G (Guard, Sworn, protecting Carlotta) | Anoriath | 0x0001A680 |
| protectee | Carlotta Valentia | 0x0001A675 |
| St (Merchant in his shop, steward of Whiterun) | Belethor | 0x0001A672 |
| C (sworn camp, Valtheim Towers) | chief ref 0x0003F7AC, UUID 1715F68F2AEED131 | far away |
| child (Whiterun) | Braith | 0x0001A66B |
Timescale recorded in the save: 20.

## Where the tests are defined
- `C:\nolvus-research\BRIDGE_SPEC_V2.md` §15.3 (lines ~3412-3487) and the sections they cite; §14 invariants I1-I10.
- B-1 … B-20 = v1 tests 1-20: `C:\nolvus-research\BRIDGE_INVESTIGATION.md` §5.5 (line ~847), with the v2 changes in
  spec §15.3's first table.
- TM-1 … TM-13: `C:\nolvus-research\investigation\round3\s10_teammate_flag.md` §4.3.
- Others: follow the spec row's "as written there" pointer.
- Classification and routes per test: `C:\nolvus-research\investigation\round10\step8_time_plan.md` §3 (R1-R7, A/A+w/...).

## Report back (final message)
1. Per test: implemented / partial / not implemented, and why. List INFERRED steps.
2. Proposed IEB_TestCtl wrappers (exact Papyrus), each with the sources you verified it against.
3. Any spec ambiguity or contradiction you found (file:line). Keep it compact.
