# Jenassa preview (private)

A text chat where you play Lucienne and the model plays Jenassa, using the same scene rules, Jenassa bio, disposition and
intimacy-profile prompts, bond text, memory and event-history templates, and OpenRouter routing the test install uses.

## Set up (once)
1. In a terminal run: `setx LUC_PREVIEW_OR_KEY "<your OpenRouter key>"`
2. Close that terminal and open a NEW one (the old one cannot see the key).
3. Double-click `run_preview.bat` (or run it from the new terminal).

If the key is missing the app prints the `setx` line above and stops.

## First run (3 model calls)
1. Rolls Jenassa's disposition with the Relationships mod's real `snrom_author_disposition` prompt (orientation, intimacy,
   ardor, exclusivity, why, limit), parsed with the game's own field rules. Saved to `disposition.json`.
2. Writes her intimacy profile from it (the game's `ieb_intimacy_author` prompt). Saved to `profile_jenassa.md`.
Later runs reuse both. If you edit `disposition.json` the app keeps your version and never re-rolls it.

## Commands
- `/regen` regenerate Jenassa's last reply; `/undo` drop the last exchange; `/save` write the transcript now (also automatic)
- `/scene` write a fresh scenario (one call) into `scene_setup.txt` and start a new chat
- `/disposition` re-roll the disposition (an edited file is backed up first); then `/profile` rewrites the profile from it
- `/profile` re-author the profile from the current disposition; `/help`; `/exit` save and quit

## Where files go
Everything is in `C:\Users\sharp\Documents\LucPreview\` and nowhere else:
- `transcripts\` your chats; `profile_jenassa.md`; `disposition.json` (+ `.sha256` used to tell if you edited it)
- `scene_setup.txt` the scenario: place, time, weather, bond tier, memories, recent events. Edit freely. No quest content.
- `last_system_prompt.txt`, `last_profile_prompt.txt`, `last_disposition_prompt.txt` exactly what was sent

## What is real and what is faked
Real templates: scene rules, response format, bond section (Lover tier), memories, event history (turned into the first chat
messages), both authoring prompts. Built by the app from the templates' own headings and sentences (the game builds the
scene-context block natively): the scene-context block, whose section order and headings come from
components/context/scene_context_full.prompt and scene_context.prompt, and whose event lines use the DLL's event format; the
Health/Energy/Physical Activity lines of the character profiles. Faked or left out: inventory, worn equipment, quests, the
companion-feelings, combat and behaviour parts of the companion section, and the circle of other followers (empty, so no
Traveling Party block). Relationship points are not shown to her, as in the game.

Model, sort and provider ignore list come from the test profile's OpenRouter.yaml (default dialogue settings). Quantization is
limited to fp8 or better; fp4 is never allowed. The reviewer may read the files in the folder. The key is never printed, logged
or saved.
