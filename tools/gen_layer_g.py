"""Generate layer G shae.scene-text (TASK_C step 4c; spec §11.5-§11.7, §11.13.2-§11.13.4, §11.13.8, §11.10 P3).

Files:
  system_head/0020_format_rules.prompt          same-path override of base 0.25.3: only the spoken-reply branch gains
                                                the scene tier (spoken <= 60 words + asterisk text <= 200 words)
  user_final_instructions/0760_visible_actions  visibility rule (camera-neutral, or private sensations), then the
                                                S-29 scene contract (with Shae's 2026-10-09 "explicit" bullet)
  user_final_instructions/9900_ieb_scene_pov    the third-person line, last text of the dialogue prompt
  character_bio/0335_ieb_intimacy_profile       the NPC's own profile, full mode only
  character_bio/0412_ieb_visible_attire         addressed person wears no body garment (fact, line of sight)
  system_head/0210_ieb_visible_attire           same fact for up to 4 seen bystanders plus the player
  actions/joinscene.yaml, leavescene.yaml       S-29 consent flow; quest script IEB_SceneActions

Scene gate (§11.13.2, P3 as changed 2026-10-09): render_mode "full", scene mode on (player IEB_SceneMode == 1), the
speaker is a scene partner (IEB_IsScenePartner == 1), not decnpc().isChild, not virtual; 0760/9900 also not in combat.
Built with nested ifs that only set a flag (sitting-4 rule: no compound literals with calls).
Output: build/layers/scene-text/SKSE/Plugins/SkyrimNet/external/shae.scene-text/."""
import os

UP = "C:/nolvus-research/build/upstream/skyrimnet-b25.1/prompts/submodules/"
OUT = "C:/nolvus-research/build/layers/scene-text/SKSE/Plugins/SkyrimNet/external/shae.scene-text/"


def w(rel, text):
    p = OUT + rel
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "w", encoding="utf-8", newline="\n").write(text)


def read(p):
    return open(p, encoding="utf-8").read().replace("\r\n", "\n")


def scene_gate(subject):
    """Sets _ieb_scene for the given speaker expression (npc.UUID in system_head / final instructions, actorUUID in
    character_bio, where actorUUID is the speaker in full mode)."""
    return ('{% set _ieb_scene = false %}'
            '{% if papyrus_util("GetIntValue", player.UUID, "IEB_SceneMode", 0) == 1 %}'
            '{% if papyrus_util("GetIntValue", ' + subject + ', "IEB_IsScenePartner", 0) == 1 %}'
            '{% if not decnpc(' + subject + ').isChild and not decnpc(' + subject + ').isVirtual %}'
            '{% set _ieb_scene = true %}{% endif %}{% endif %}{% endif %}')


w("manifest.json", """{
  "id": "shae.scene-text",
  "type": "bundle",
  "title": "Scene Text (private)",
  "tagline": "Private: scene tier, visible actions, scene contract, attire facts, intimacy profile, join/leave.",
  "description": "Component G of the Errand Bridge build (spec 11.5-11.7, 11.13). Adult fiction between consenting adults; children are never scene speakers (P3) and never subjects of attire facts. Needs SceneControls.esp. Private; never published.",
  "author": "shae",
  "version": "1.0.0",
  "min_skyrimnet_version": "0.25.0",
  "nsfw": true,
  "mods": [
    { "required": true, "file": "SceneControls.esp", "name": "SceneControls" }
  ]
}
""")

# ------------------------------------------------------------------ 0020 override (§11.7, §11.13.3)
base = read(UP + "system_head/0020_format_rules.prompt")
old = """{% else %}
1-3 sentences (8-40 words typical). Do NOT write multiple paragraphs. 60 words maximum.
{% endif %}"""
new = """{% else %}
{# shae.scene-text (spec 11.7, 11.13.3): scene tier for a scene partner; everyone else keeps base's rule. #}
{% set _ieb_scene = false %}{% if render_mode == "full" and exists("npc") and existsIn(npc, "UUID") %}""" + scene_gate("npc.UUID").replace('{% set _ieb_scene = false %}', '', 1) + """{% endif %}
{% if _ieb_scene %}
Scene: speak 1-3 sentences, 60 words maximum, as always. Text in asterisks may add up to 200 words, a ceiling and not a target, in up to 3 short paragraphs. Speak first, or keep any opening text in asterisks short.
{% else %}
1-3 sentences (8-40 words typical). Do NOT write multiple paragraphs. 60 words maximum.
{% endif %}
{% endif %}"""
assert base.count(old) == 1
w("prompts/submodules/system_head/0020_format_rules.prompt", base.replace(old, new))

# ------------------------------------------------------------------ 0760 visible actions + scene contract
EXPLICIT = ("- **Explicit when it is sex.** When the scene is sexual, write it out graphically and in full, and make all of "
            "it erotic. Name the body parts plainly, with direct anatomical words. Give the detail: what each body does "
            "and how it responds; the sensations (touch, pressure, heat, wetness, texture, rhythm); the sounds (breath, "
            "voices, skin); the smells and tastes. Never fade to black, skip ahead, summarise, or cut away to afterwards. "
            "No euphemism in the text in asterisks unless it's a choice about how you specifically would say it. Coarse "
            "or blunt words are fine in your spoken lines when they are how you would say it.")
CONTRACT = """## Scene
Scene mode is on. This is adult fiction between consenting adults; explicit sexual content is expected when the scene calls for it. The narration frequency limits above do not apply: write text in asterisks in each reply as the scene needs.

Write as a novelist would, from inside your own body and attention.
- **Answer first.** First answer what {{ target_name }} just said or did: their words, their provocation, their history. Let it land in your own terms before anything physical moves on.
- **Your people and your past.** When {{ target_name }} names your people, titles, history or loyalties, respond to that specifically, in your own terms.
- **Concrete over generic.** Give the particular thing: where a hand lands and what it finds there, the texture, the temperature, the smell. Never "pleasure washed over" or "waves of sensation".
- **Rhythm.** Vary sentence length on purpose. Set short, hard sentences against longer ones that run on. Make the verbs do the work; cut adverbs and stacked adjectives.
- **Your voice, your eye.** Let your own life, trade and preoccupations shape what you notice and the comparisons you reach for. Use them where they fit, not in every reply.
""" + EXPLICIT + """
- **Pacing.** Let each moment land before moving on: one real development per reply. When someone else leads, follow. When you lead, go after what you want. Don't rush to the next stage and don't stall in one.
- **When anyone in the scene declines or defers, accept it at once.** You may tease or state your interest, but physical pursuit of them stops.
- **Length follows what happens.** A small beat gets a short reply; the cap is a ceiling, not a target.
- **Endings.** End each reply on your own action or words, something that hands the moment back to {{ target_name }}. Never end on scenery.
- **No reuse.** Don't repeat a distinctive image, gesture or phrase from your earlier replies in this scene.
- **Stay in character.** Never comment on the writing, the rules, the format or the content; no notes, no disclaimers."""

w("prompts/submodules/user_final_instructions/0760_visible_actions.prompt",
  """{% if render_mode == "full" and is_narration_enabled() and exists("npc") and existsIn(npc, "UUID") and not is_player(npc.UUID) %}
{% if not decnpc(npc.UUID).isVirtual and not decnpc(npc.UUID).isInCombat %}
{# shae.scene-text 0760 (spec 11.5, 11.13.2-11.13.3, 11.13.8): visibility rule, then the scene contract for a scene
   partner. Additive file; adds no witness-side reaction guidance. #}
""" + scene_gate("npc.UUID") + """
{% set _ieb_private = false %}{% if _ieb_scene %}{% if papyrus_util("GetIntValue", player.UUID, "IEB_ScenePrivate", 0) == 1 %}{% set _ieb_private = true %}{% endif %}{% endif %}
{% set target_name = player.name %}{% if exists("responseTarget") and existsIn(responseTarget, "type") %}{% if responseTarget.type == "npc" %}{% set target_name = decnpc(responseTarget.UUID).name %}{% endif %}{% endif %}
## Visible actions
- Write your own visible actions inline in asterisks, third person, present tense.
{% if _ieb_private %}- No one outside this scene can see or hear you now. Text in asterisks may include your own sensations and perceptions: what you feel, smell, taste and hear, and what your body does. It never narrates anyone else's thoughts or feelings.
{% else %}- Describe only what an onlooker could see or hear: movement, contact, posture, expression, sound. No feelings, sensations or judgement words, and nothing about how anyone else feels.
{% endif %}- Only your own actions, including your own contact with someone else. Never write anyone else's words, and never decide what anyone else does, chooses or feels.
{% if _ieb_scene %}

""" + CONTRACT + """
{% endif %}
{% endif %}
{% endif %}
""")

w("prompts/submodules/user_final_instructions/9900_ieb_scene_pov.prompt",
  """{% if render_mode == "full" and is_narration_enabled() and exists("npc") and existsIn(npc, "UUID") and not is_player(npc.UUID) %}
{% if not decnpc(npc.UUID).isInCombat %}
{# shae.scene-text 9900 (spec 11.13.2): the person rule, last text of the dialogue prompt, scene partners only. #}
""" + scene_gate("npc.UUID") + """
{% if _ieb_scene %}
**Text in asterisks is always third person, present tense. Never use I, me or my inside asterisks.**
{% endif %}
{% endif %}
{% endif %}
""")

# ------------------------------------------------------------------ 0335 intimacy profile (§11.13.4)
w("prompts/submodules/character_bio/0335_ieb_intimacy_profile.prompt",
  """{% if render_mode == "full" and actorUUID %}
{# shae.scene-text 0335 (spec 11.13.4): the NPC's own intimacy profile, in that NPC's own full prompt only. Gate: not a
   child, and (scene partner in scene mode, or a romantic Lover or above). Text authored by the private Relationships
   patch (ieb_intimacy_author), mirrored to StorageUtil IEB_IntimacyProfile. #}
{% if not decnpc(actorUUID).isChild and not decnpc(actorUUID).isVirtual %}
""" + scene_gate("actorUUID") + """
{% set _ieb_show = _ieb_scene %}{% if not _ieb_show %}{% if get_faction_rank(actorUUID, "SNRom_Bond") >= 4 %}{% if papyrus_util("GetIntValue", actorUUID, "SNRom_Sparked", 0) == 1 %}{% set _ieb_show = true %}{% endif %}{% endif %}{% endif %}
{% if _ieb_show %}{% set _ieb_prof = papyrus_util("GetStringValue", actorUUID, "IEB_IntimacyProfile", "") %}{% if _ieb_prof != "" %}
## Your intimacy profile
{{ _ieb_prof }}
{% endif %}{% endif %}
{% endif %}
{% endif %}
""")

# ------------------------------------------------------------------ attire facts (§11.6; R3 item 5 §5.1-5.2)
w("prompts/submodules/character_bio/0412_ieb_visible_attire.prompt",
  """{% if render_mode == "dialogue_target" and actorUUID and exists("npc") and existsIn(npc, "UUID") and npc.UUID != actorUUID %}
{# shae.scene-text 0412 (spec 11.6): observable fact only, gated on sight. No reaction, tone or judgement guidance.
   Subject gate only (P3): no fact is ever written about a child. #}
{% if actor_has_keyword(actorUUID, "ActorTypeNPC") and not decnpc(actorUUID).isChild and has_line_of_sight(npc.UUID, actorUUID) %}
{% set _eq = get_worn_equipment(actorUUID) %}{% set _body = _eq.body %}
{% if not _body %}
- Visible attire: {{ decnpc(actorUUID).name }} is not wearing a body garment (no shirt, dress, robe, cuirass or similar); the Worn Equipment list above is everything they have on.
{% endif %}
{% endif %}
{% endif %}
""")

w("prompts/submodules/system_head/0210_ieb_visible_attire.prompt",
  """{% if (render_mode == "full" or render_mode == "thoughts") and exists("npc") and existsIn(npc, "UUID") and npc.UUID != player.UUID %}
{# shae.scene-text 0210 (spec 11.6): facts only, people this speaker can see who wear no body garment. The addressed
   person is covered by 0412. Capped at 4 NPC line-of-sight checks plus the player. Subject gate only (P3). #}
{% set _tid = 0 %}{% if exists("responseTarget") and existsIn(responseTarget, "UUID") %}{% set _tid = responseTarget.UUID %}{% endif %}
{% set _seen = [] %}
{% if player.UUID != _tid %}{% if actor_has_keyword(player.UUID, "ActorTypeNPC") and has_line_of_sight(npc.UUID, player.UUID) %}{% set _p = get_worn_equipment(player.UUID).body %}{% if not _p %}{% set _seen = append(_seen, player.name) %}{% endif %}{% endif %}{% endif %}
{% set _n = 0 %}
{% for p in get_nearby_npc_list(npc.UUID) %}{% if _n < 4 and p.UUID != npc.UUID and p.UUID != _tid %}{% if not decnpc(p.UUID).isDead and not decnpc(p.UUID).isChild and actor_has_keyword(p.UUID, "ActorTypeNPC") %}{% if has_line_of_sight(npc.UUID, p.UUID) %}{% set _n = _n + 1 %}{% set _b = get_worn_equipment(p.UUID).body %}{% if not _b %}{% set _seen = append(_seen, p.name) %}{% endif %}{% endif %}{% endif %}{% endif %}{% endfor %}
{% if length(_seen) > 0 %}
## Visible Attire
In {{ decnpc(npc.UUID).name }}'s view, wearing no body garment (no shirt, dress, robe, cuirass or similar): {{ join(_seen, ", ") }}.
{% endif %}
{% endif %}
""")

# ------------------------------------------------------------------ JoinScene / LeaveScene (§11.13.8)
COMMON_RULES = """  - conditions:
      - decoratorName: "is_in_combat"
        arguments: ["currentActor"]
        comparisonOperator: "=="
        expectedValue: false
    logicalOperator: "AND"
    required: true
  - conditions:
      - decoratorName: "papyrus_util"
        arguments: ["GetIntValue", "player", "IEB_SceneMode", 0]
        comparisonOperator: "=="
        expectedValue: 1
    logicalOperator: "AND"
    required: true
"""
CHILD_RULE = """  - conditions:
      # Child guard (spec 11.10 P2/P4): a child speaker is never eligible. SkyrimNet's native decnpc().isChild.
      - decoratorName: "decnpc"
        arguments: ["currentActor"]
        resultPath: "isChild"
        comparisonOperator: "=="
        expectedValue: false
    logicalOperator: "AND"
    required: true
"""
w("actions/joinscene.yaml", """# shae.scene-text (spec 11.13.8, S-29): a witness joins the scene. The NPC chooses it; the player confirms in a box;
# IEB_SceneMain then runs the existing partners' check (exclusivity >= 88 refuses) before adding them.
name: JoinScene
description: "Use only when {{ player.name }} has invited the speaker into the intimate scene, or the speaker offers to join and {{ player.name }} welcomes it, and the speaker wants to join."
questEditorId: IEB_SceneQuest
scriptName: IEB_SceneActions
executionFunctionName: JoinScene
parameterMapping:
  - type: speaker
    name: akActor
    description: the one joining the scene
useConfirmationWindow: true
enabled: true
eligibilityRules:
""" + COMMON_RULES + """  - conditions:
      - decoratorName: "papyrus_util"
        arguments: ["GetIntValue", "currentActor", "IEB_IsScenePartner", 0]
        comparisonOperator: "=="
        expectedValue: 0
    logicalOperator: "AND"
    required: true
""" + CHILD_RULE)
w("actions/leavescene.yaml", """# shae.scene-text (spec 11.13.8, S-29): any partner may leave at any time, no confirmation (the decline rule's spirit).
name: LeaveScene
description: "Use when the speaker, a partner in the intimate scene, chooses to leave it: they have had enough, they will not share, or they want to stop."
questEditorId: IEB_SceneQuest
scriptName: IEB_SceneActions
executionFunctionName: LeaveScene
parameterMapping:
  - type: speaker
    name: akActor
    description: the partner leaving the scene
enabled: true
eligibilityRules:
  - conditions:
      - decoratorName: "papyrus_util"
        arguments: ["GetIntValue", "currentActor", "IEB_IsScenePartner", 0]
        comparisonOperator: "=="
        expectedValue: 1
    logicalOperator: "AND"
    required: true
""")
print("layer G written")
