# Jenassa preview (private)

A text chat where you play Lucienne and the model plays Jenassa, using the same scene rules, Jenassa bio, intimacy-profile
prompt and OpenRouter routing the test install uses. For judging her voice before the game runs.

## Set up (once)
1. In a terminal run: `setx LUC_PREVIEW_OR_KEY "<your OpenRouter key>"`
2. Close that terminal and open a NEW one (the old one cannot see the key).
3. Double-click `run_preview.bat` (or run it from the new terminal).

If the key is missing the app prints the `setx` line above and stops.

## First run
It writes Jenassa's intimacy profile with one model call and saves it. Later runs reuse that profile.

## Commands
- `/regen` regenerate Jenassa's last reply
- `/undo` drop the last exchange (your line and her reply)
- `/save` write the transcript now (it also saves after every reply)
- `/profile` author the profile again (replaces the saved one; one call)
- `/help` list commands, `/exit` save and quit

## Where files go
Everything is in `C:\Users\sharp\Documents\LucPreview\` and nowhere else:
- `transcripts\transcript_<date-time>.md` your chats
- `profile_jenassa.md` her intimacy profile (edit it by hand if you like; `/profile` replaces it)
- `disposition.json` the inputs the profile is written from (orientation, intimacy, ardor, exclusivity, why, limit).
  Her real values live in the game save, which this tool cannot read, so these are placeholders drawn from her bio.
  Edit them, delete `profile_jenassa.md`, and rerun to rewrite the profile.
- `scene_setup.txt` one line of "where you are" given to her; edit freely
- `last_system_prompt.txt` and `last_profile_prompt.txt` exactly what was sent, for checking

## Settings it uses
Model, sort and provider ignore list come from the test profile's OpenRouter.yaml (default dialogue settings), read without
touching any key line. Quantization is limited to fp8 or better; fp4 is never allowed.

The reviewer may read the files in that folder. The key is never printed, logged or saved by the app.
