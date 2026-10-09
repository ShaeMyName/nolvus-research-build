"""Generate layer J shae.discretion (TASK_C step 4; spec §11.11, decided design; text from
investigation/round4/item14_secrets_quest_integrity.md §14a.3). One additive file, so it overrides nothing:
prompts/submodules/user_final_instructions/0705_ieb_discretion.prompt (sorts after 0700, before 0740).
[CHANGED in build 2026-10-09] The responseTarget guard uses base's own form (exists("responseTarget") and
existsIn(responseTarget, "UUID"), as in base event_history_*.prompt:4) instead of the draft's `responseTarget.UUID != 0`.
Output: build/layers/discretion/SKSE/Plugins/SkyrimNet/external/shae.discretion/."""
import os

OUT = "C:/nolvus-research/build/layers/discretion/SKSE/Plugins/SkyrimNet/external/shae.discretion/"


def w(rel, text):
    p = OUT + rel
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "w", encoding="utf-8", newline="\n").write(text)


w("manifest.json", """{
  "id": "shae.discretion",
  "type": "bundle",
  "title": "Discretion (private)",
  "tagline": "Private: characters keep their own private matters unless the moment warrants it.",
  "description": "Component J of the Errand Bridge build (spec 11.11). One additive user_final_instructions file, rendered in full mode for non-player speakers only. Private; never published.",
  "author": "shae",
  "version": "1.0.0",
  "min_skyrimnet_version": "0.25.0",
  "nsfw": false
}
""")

w("prompts/submodules/user_final_instructions/0705_ieb_discretion.prompt",
  """{% if render_mode == "full" and not is_player(npc.UUID) %}
{% set _iebRel = 0 %}{% if exists("responseTarget") and existsIn(responseTarget, "UUID") %}{% set _iebRel = get_relationship_rank(npc.UUID, responseTarget.UUID) %}{% endif %}
## Discretion
- Your Character Summary is what people generally know about you. The rest of your profile (background, personality, goals, relationships, memories) may hold private matters: a hidden past, true loyalties, plans, wrongs done, things only you know.
- Keep your own private matters to yourself by default. Do not volunteer them, hint at them for drama, or confess them just because someone asks. Deflect, change the subject or answer evasively, as fits who you are.
- Reveal one only when the moment truly warrants it: trust earned over time{% if _iebRel >= 2 %} (you count this person as a confidant or closer){% endif %}; real pressure you cannot answer (threat, leverage, proof, persuasion); or when events have already brought it into the open (it was raised in this conversation, others already know, or it belongs to a quest topic listed below). Even then, reveal only what the moment needs.
- The same goes for other people's secrets that you know.
- This is NOT about ordinary knowledge. Share places, directions, roads, history, lore, common rumours, your trade and the "Things You Know" section freely, as your character would.
{% if exists("allow_inline_internal_thoughts") and allow_inline_internal_thoughts %}- You may think about a private matter in your internal thought; that does not reveal it.
{% endif %}{% endif %}
""")
print("layer J written: manifest + 0705_ieb_discretion.prompt")
