"""Generate Lucienne's layer shae.lucienne (TASK_C step 4b; spec §11.15, files §11.15.13).

  gen_layer_lucienne.py test   -> build/layers/lucienne-test/...   placeholder tokens for every canon-derived text
  gen_layer_lucienne.py real   -> C:/nolvus-research/lucienne/real_layer/...  canon text from lucienne/staging/
                                  (outside build/'s git; run only for her profile, after Shae's final staging review)

Everything that is not canon (gates G1-G3, verbatim thoughts, triggers, filters, journal prompts, how Azura answers,
blacklists, entity, identity link) is identical in both modes. The G1-G3 and verbatim shadows are the stubs that passed
TT-9, TT-13/13b, TT-14a/b and TT-12 live (build/upstream/azuratest-stub/), with these production changes:
  - variable prefix _azt_ -> _luc_; comments name the spec section;
  - G1 and G2 also hide the prayer-marker narration (luc-prayer), for every viewer (spec §11.15.5; AZ-6);
  - verbatim gate is LUC_Praying == 1 only (the "Dusk enabled" stand-in is dropped, spec §11.15.4).
Canon-content submodules (0955 Princes, 0960 identity) and 0965 also require LUC_Active == 1 on the player (round 8 §6
backstop). Privacy gates never depend on LUC_Active.

[CHANGED in build 2026-10-09]
  - "How Azura answers" is 0965_luc_dusk.prompt (spec: 0960_luc_dusk.prompt) so it renders after the 0960 identity
    file ("0960_luc_dusk." would sort before "0960_luc_dusk_identity").
  - Digest capped at ~650 characters: SendCustomPromptToLLM returns at most 750 (SkyrimNetApi.psc:166); spec said 1,500.
  - Journal prompts take the prayer window as context var prayerSeconds (game seconds), compared with
    gameTimeNumeric - event.gameTime as base event_history does; an absolute start time would mix Papyrus days with
    event seconds.
  - Closing: end-marker only. The phrase-set fallback (Azura's own wording, Shae's text) is built only if AZ-2 fails."""
import json, os, re, sys

MODE = sys.argv[1] if len(sys.argv) > 1 else "test"
assert MODE in ("test", "real")
STUB = "C:/nolvus-research/build/upstream/azuratest-stub/"
STAGE = "C:/nolvus-research/lucienne/staging/"
OUT = {"test": "C:/nolvus-research/build/layers/lucienne-test/SKSE/Plugins/SkyrimNet/external/shae.lucienne/",
       "real": "C:/nolvus-research/lucienne/real_layer/SKSE/Plugins/SkyrimNet/external/shae.lucienne/"}[MODE]
ACTIVE = 'papyrus_util("GetIntValue", player.UUID, "LUC_Active", 0) == 1'
VE = 'papyrus_util("GetStringValue", player.UUID, "LUC_VEName", "Dusk")'
files = []


def w(rel, text):
    p = OUT + rel
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "w", encoding="utf-8", newline="\n").write(text)
    files.append(rel)


def read(p):
    return open(p, encoding="utf-8").read().replace("\r\n", "\n")


def sub1(s, old, new):
    assert s.count(old) == 1, (old[:80], s.count(old))
    return s.replace(old, new)


# ------------------------------------------------------------------ manifest, entity, identity link, blacklists
w("manifest.json", json.dumps({
    "id": "shae.lucienne",
    "type": "bundle",
    "title": "Lucienne - Private" + (" (TEST STUB)" if MODE == "test" else ""),
    "tagline": "Private: Lucienne's playthrough only.",
    "description": "Spec 11.15: Azura v1 prayer channel via the private virtual NPC Dusk, privacy gates G1-G3, verbatim "
                   "prayer thoughts, prayer journal, the Princes' private sections, Moon and Star / DA01 blacklists. "
                   + ("Test-profile stub: placeholder text only. " if MODE == "test" else "Lucienne's profile only. ")
                   + "Never published.",
    "author": "shae",
    "version": "1.0.0",
    "min_skyrimnet_version": "0.25.0",
    "nsfw": True,
}, indent=2) + "\n")

w("entities/dusk.entity.yaml", read(STUB + "shae.azuratest/entities/dusk.entity.yaml"))

w("identity/dusk_link.yaml", """kind: link
name: Dusk Link
identityA: "virtual:Dusk"
identityB: "npc:Skyrim.esm:0x028AE9"
mode: bidirectional
dominance: host_led
awareness: mutual
note: "Spec 11.15.2: the private voice Dusk is Azura (physical Azura at her shrine). Skipped while Dusk is disabled."
""")

w("dialogue_actions/luc_blacklists.yaml", """kind: lists
name: Lucienne - Moon and Star and DA01 lines need the player
description: >-
  Keeps the LLM from firing any dialogue script of the Moon and Star quests or of DA01, Azura's own
  quest, so no AI reply on Lucienne's road or near the shrine can start or advance them. Pressing E
  and choosing the line yourself is unaffected. (Spec 11.15.11; round 8 section 10; TT-11.)
blacklist:
  - MASMainQuest
  - MASAzuraCurse
  - MASNerevarineShrineDialog
  - DA01
""")

# ------------------------------------------------------------------ G1, G2, G3, verbatim (from the verified stubs)
HIDE_MARKER = ('{% if not _luc_hide and event.type == "direct_narration" %}{% if contains(format_event(event, "verbose"), '
               '"luc-prayer") %}{% set _luc_hide = true %}{% endif %}{% endif %}')

g1 = read(STUB + "shae.azuratest-filter/prompts/components/event_history_compact.prompt")
g1 = sub1(g1, "{# shae.azuratest-filter (TT-9 stub): director prompts never see the player's thoughts or anything said to or by a private virtual NPC. #}",
          "{# shae.lucienne G1 (spec 11.15.5; TT-9): director prompts never see the player's thoughts, anything said to or by a private virtual NPC, or the prayer-marker narration. #}")
g1 = g1.replace("_azt_", "_luc_")
g1 = sub1(g1, '    {% if event.type != "spell" and event.type != "hit" and event.type != "combat" and not _luc_hide %}',
          "    " + HIDE_MARKER + '\n    {% if event.type != "spell" and event.type != "hit" and event.type != "combat" and not _luc_hide %}')
w("prompts/components/event_history_compact.prompt", g1)

for name, guard in (("event_history.prompt", '    {% if event.type != "spell" and event.type != "hit" and event.type != "combat" and not _luc_hide %}'),
                    ("event_history_verbose.prompt", '{% if event.type != "gamemaster_dialogue" and not _luc_hide %}')):
    g2 = read(STUB + "shae.azuratest-npcfilter/prompts/components/" + name)
    g2 = sub1(g2, "{# shae.azuratest-npcfilter (TT-13 stub): an NPC viewer never sees the player's thoughts or anything said to or by a private virtual NPC. The player and private virtual NPCs still do. #}",
              "{# shae.lucienne G2 (spec 11.15.5; TT-13, TT-13b): an NPC viewer never sees the player's thoughts or anything said to or by a private virtual NPC, in dialogue prompts and memory input. The player and private virtual NPCs still do. The prayer-marker narration is hidden from every viewer. #}")
    g2 = g2.replace("_azt_", "_luc_")
    g2 = sub1(g2, guard, "    " + HIDE_MARKER + "\n" + guard)
    w("prompts/components/" + name, g2)

g3 = read(STUB + "shae.azuratest-noreact/prompts/target_selectors/dialogue_speaker_selector.prompt")
g3 = sub1(g3, "{# shae.azuratest-noreact (TT-14 stub): no NPC is chosen to react when the last line was spoken by, or to, one of our private virtual NPCs (fixed name list). #}",
          "{# shae.lucienne G3 (spec 11.15.5; TT-14a/b): no NPC is chosen to react when the last line was spoken by, or to, Dusk (LUC_VEName). #}")
g3 = g3.replace("_azt_", "_luc_")
w("prompts/target_selectors/dialogue_speaker_selector.prompt", g3)

vb = read(STUB + "shae.azuratest-verbatim/prompts/player_thoughts.prompt")
vb = sub1(vb, "{# shae.azuratest-verbatim (TT-12 stub): while praying, a typed thought is passed through verbatim instead of paraphrased. #}\n"
              "{# Gate: LUC_Praying == 1 on the player (set by the future Lucienne.esl hotkey script), or the Dusk virtual NPC enabled (test stand-in). #}",
          "{# shae.lucienne (spec 11.15.4; TT-12): while praying, a typed thought is passed through verbatim instead of paraphrased. #}\n"
          "{# Gate: LUC_Praying == 1 on the player, set by Lucienne.esl's prayer key and cleared at every prayer end and every load. #}")
vb = sub1(vb, '{% set _azt_name = papyrus_util("GetStringValue", player.UUID, "LUC_VEName", "Dusk") %}{% for _azt_v in get_virtual_npc_list(player.UUID) %}{% if _azt_v.name == _azt_name %}{% set _azt_verbatim = true %}{% endif %}{% endfor %}\n', "")
vb = vb.replace("_azt_", "_luc_")
assert "_azt" not in g1 + g3 + vb
w("prompts/player_thoughts.prompt", vb)

# ------------------------------------------------------------------ triggers and marker filters
w("triggers/luc_thought_to_dusk.yaml", """# Spec 11.15.5: a player thought is narrated to the enabled virtual NPCs (Dusk, while a prayer is open) so she
# answers. The content is a fixed marker with no thought text: Dusk reads the verbatim thought from the player's own
# events, and G1/G2 hide this narration from every prompt. Stored for every thought even with Dusk off (TT-1).
name: "luc_thought_to_dusk"
description: "Lucienne's prayer: a player thought prompts Dusk to answer (fixed marker, no thought text)."
eventCriteria:
  eventType: "player_thoughts"
  schemaConditions:
    - fieldPath: "thoughts"
      operator: "not_equals"
      value: ""
response:
  type: "direct_narration"
  content: "⟦luc-prayer⟧"
audience: "enabled_virtual_npcs"
enabled: true
probability: 1.0
cooldownSeconds: 1
priority: 5
""")

w("triggers/luc_dusk_close.yaml", """# Spec 11.15.6: Azura closes the prayer by ending her line with the marker; the marker is stripped from the shown
# and voiced text by filters/luc_marker_strip_*. Whether the trigger still sees it after the strip is AZ-2.
name: "luc_dusk_close"
description: "Lucienne's prayer: Dusk's end-marker disables Dusk."
eventCriteria:
  eventType: "dialogue"
  schemaConditions:
    - fieldPath: "speaker"
      operator: "equals"
      value: "Dusk"
      caseSensitive: false
    - fieldPath: "dialogue"
      operator: "regex"
      value: "luc-end"
response:
  type: "disable_virtual_npc"
  targetName: "Dusk"
audience: "player"
enabled: true
probability: 1.0
cooldownSeconds: 1
priority: 10
""")

w("triggers/luc_speech_ends.yaml", """# Spec 11.15.6 (TT-8): any line the player says aloud, typed or spoken, ends the prayer. The reply to that line
# still goes out; G3 keeps NPCs from reacting to Dusk.
name: "luc_speech_ends"
description: "Lucienne's prayer: a spoken player line disables Dusk."
eventCriteria:
  - eventType: "dialogue_player_text"
    schemaConditions:
      - fieldPath: "dialogue"
        operator: "not_equals"
        value: ""
  - eventType: "dialogue_player_stt"
    schemaConditions:
      - fieldPath: "dialogue"
        operator: "not_equals"
        value: ""
response:
  type: "disable_virtual_npc"
  targetName: "Dusk"
audience: "player"
enabled: true
probability: 1.0
cooldownSeconds: 1
priority: 10
""")

TELLS = {"breath": "{{ player_name }} catches a sudden breath, as if at something no one else can see.",
         "flush": "A flush rises in {{ player_name }}'s face for no reason anyone nearby can see.",
         "grip": "{{ player_name }} grips the nearest thing to hand for a moment, steadying herself."}
for k, text in TELLS.items():
    w("triggers/luc_dusk_tell_%s.yaml" % k, """# Spec 11.15.8 public tells (A0-Q2; ships only if AZ-9 passes): Dusk's marker makes Lucienne's body react where
# nearby NPCs can perceive it. Fixed, non-explicit text; no target, so no one (child or adult) is addressed.
name: "luc_dusk_tell_%s"
description: "Lucienne's prayer: Dusk's tell marker (%s) registers a visible, non-explicit reaction."
eventCriteria:
  eventType: "dialogue"
  schemaConditions:
    - fieldPath: "speaker"
      operator: "equals"
      value: "Dusk"
      caseSensitive: false
    - fieldPath: "dialogue"
      operator: "regex"
      value: "tell:%s"
response:
  type: "persistent_generic"
  content: "%s"
audience: "nearby_npcs"
enabled: true
probability: 1.0
cooldownSeconds: 30
priority: 6
""" % (k, k, k, text))

MARKER_RE = r"\s*⟦(?:luc-end|tell:[a-z]+)⟧"
w("filters/luc_marker_strip.yaml", """kind: dialogue_rule
id: luc_marker_strip
pattern: '%s'
replacement: ""
priority: 50
""" % MARKER_RE)
w("filters/luc_marker_strip_tts.yaml", """kind: tts_rule
id: luc_marker_strip_tts
pattern: '%s'
replacement: ""
priority: 50
""" % MARKER_RE)

# ------------------------------------------------------------------ journal prompts (custom prompts, Lucienne.esl calls them)
EVENT_PICK = """{% set _luc_ve = %s %}
{% set _luc_win = 3600 %}{%% if exists("prayerSeconds") %%}{%% set _luc_win = prayerSeconds + 30 %%}{%% endif %%}
{%% set _luc_f = [] %%}{%% set _luc_f = append(_luc_f, player.UUID) %%}
{%% for e in get_recent_events(60, _luc_f) %%}{%% if gameTimeNumeric - e.gameTime <= _luc_win %%}
{%% if e.type == "player_thoughts" %%}- Lucienne (prayer): {{ format_event(e, "compact") }}
{%% else if existsIn(e, "originatingActor") and isValidActor(e.originatingActor) %%}{%% if decnpc(e.originatingActor).name == _luc_ve %%}- Azura: {{ format_event(e, "verbose") }}
{%% endif %%}{%% endif %%}{%% endif %%}{%% endfor %%}""".replace("{% set _luc_ve = %s %}", "{% set _luc_ve = " + VE + " %}").replace("%%", "%")

w("prompts/luc_prayer_summary.prompt", """[ system ]
{# Lucienne's prayer journal (spec 11.15.9): one private entry per prayer. Called by Lucienne.esl at prayer end with
   context {"prayerSeconds": <game seconds since the prayer opened>}; the callback appends the reply to the StorageUtil
   string list LUC_PrayerJournal (last 10). Reply cap 750 characters (SkyrimNetApi.psc:166). #}
You keep Azura's private journal of Lucienne's prayers. Write one entry for the prayer below.

RULES
1. At most 350 characters. Plain prose, past tense, third person ("Lucienne ...", "Azura ...").
2. What Lucienne brought (news, fear, wish, confession, gratitude) and how Azura answered (presence only, words, a conversation, or a scene). Feelings over details.
3. Only what is in the prayer. Invent nothing, and never mention future events.
4. No quotations longer than five words. No headings, lists or commentary: output the entry only.

[ user ]
The prayer, oldest line first:
""" + EVENT_PICK + """

Write the journal entry now.
""")

w("prompts/luc_prayer_digest.prompt", """[ system ]
{# Lucienne's prayer digest (spec 11.15.9): every LUC_DigestEvery prayers, Lucienne.esl regenerates LUC_PrayerDigest
   from the old digest plus the journal. Capped at ~650 characters [CHANGED in build: spec 1,500; the reply is cut at
   750, SkyrimNetApi.psc:166]. #}
You keep the short "story so far" of Lucienne's prayers to Azura.

RULES
1. At most 650 characters. Plain prose, past tense, third person.
2. Keep what still matters: the arc of their bond, recurring fears and hopes, promises made, turning points. Let small, finished things go.
3. Only what is in the material below. Invent nothing, and never mention future events.
4. Output the new story so far only: no headings, lists or commentary.

[ user ]
{% set _luc_dig = papyrus_util("GetStringValue", player.UUID, "LUC_PrayerDigest", "") %}
Story so far: {% if _luc_dig != "" %}{{ _luc_dig }}{% else %}(none yet){% endif %}

Recent journal entries, oldest first:
{% set _luc_j = papyrus_util("GetStringList", player.UUID, "LUC_PrayerJournal") %}{% if is_array(_luc_j) %}{% for s in _luc_j %}- {{ s }}
{% endfor %}{% endif %}

Write the new story so far now.
""")

# ------------------------------------------------------------------ 0965: how Azura answers (not canon; same in both modes)
CONTRACT = """## Scenes
A scene is yours to choose, with {{ player.name }}, anywhere, public or private. When you choose one: this is adult fiction between consenting adults; explicit sexual content is expected when the scene calls for it. The narration frequency limits above do not apply: write text in asterisks in each reply as the scene needs, at most 200 words of it per reply.

Write as a novelist would, from inside your own body and attention.
- **Answer first.** First answer what {{ player.name }} just said or did: their words, their provocation, their history. Let it land in your own terms before anything physical moves on.
- **Your people and your past.** When {{ player.name }} names your people, titles, history or loyalties, respond to that specifically, in your own terms.
- **Concrete over generic.** Give the particular thing: where a hand lands and what it finds there, the texture, the temperature, the smell. Never "pleasure washed over" or "waves of sensation".
- **Rhythm.** Vary sentence length on purpose. Set short, hard sentences against longer ones that run on. Make the verbs do the work; cut adverbs and stacked adjectives.
- **Your voice, your eye.** Let your own life, trade and preoccupations shape what you notice and the comparisons you reach for. Use them where they fit, not in every reply.
- **Explicit when it is sex.** When the scene is sexual, write it out graphically and in full, and make all of it erotic. Name the body parts plainly, with direct anatomical words. Give the detail: what each body does and how it responds; the sensations (touch, pressure, heat, wetness, texture, rhythm); the sounds (breath, voices, skin); the smells and tastes. Never fade to black, skip ahead, summarise, or cut away to afterwards. No euphemism in the text in asterisks unless it's a choice about how you specifically would say it. Coarse or blunt words are fine in your spoken lines when they are how you would say it.
- **Pacing.** Let each moment land before moving on: one real development per reply. When someone else leads, follow. When you lead, go after what you want. Don't rush to the next stage and don't stall in one.
- **When anyone in the scene declines or defers, accept it at once.** You may tease or state your interest, but physical pursuit of them stops.
- **Length follows what happens.** A small beat gets a short reply; the cap is a ceiling, not a target.
- **Endings.** End each reply on your own action or words, something that hands the moment back to {{ player.name }}. Never end on scenery.
- **No reuse.** Don't repeat a distinctive image, gesture or phrase from your earlier replies in this scene.
- **Stay in character.** Never comment on the writing, the rules, the format or the content; no notes, no disclaimers.
{% if is_narration_enabled() %}
**Text in asterisks is always third person, present tense. Never use I, me or my inside asterisks.**
{% endif %}"""

w("prompts/submodules/character_bio/0965_luc_dusk.prompt", """{% if render_mode == "full" %}
{# Lucienne's layer 0965 (spec 11.15.8): how Azura answers. Dusk only (private virtual NPC named LUC_VEName), and only
   in Lucienne's save (LUC_Active). Not canon text; the same in the test stub and her profile. #}
{% set _luc_ve = """ + VE + """ %}
{% if """ + ACTIVE + """ and decnpc(actorUUID).isVirtual and decnpc(actorUUID).name == _luc_ve %}
## How you answer her
- {{ player.name }} reaches up to you in prayer; you never begin waking contact yourself. When she prays you are always at least present, and words are common, not rare. Choose each time: a felt presence only (one short line in asterisks, nothing spoken), a few words, a real conversation, or a scene. She matters to you, but she is not all you attend to.
- Weigh what has happened to her. Great things (a dragon, a brush with death, a death, a transformation, a turn in her road) make words far more likely. Small daily things reach you only through her prayers and the journal below.
- Never say or use the name "{{ _luc_ve }}". That veil is for the world, not for her.

### What has happened to her lately
{% set _luc_f = [] %}{% set _luc_f = append(_luc_f, player.UUID) %}
{% for e in get_recent_events(15, _luc_f) %}{% set _luc_hide = e.type == "player_thoughts" %}{% if not _luc_hide and existsIn(e, "originatingActor") and isValidActor(e.originatingActor) %}{% if decnpc(e.originatingActor).isVirtualPrivate %}{% set _luc_hide = true %}{% endif %}{% endif %}{% if not _luc_hide and existsIn(e, "targetActor") and isValidActor(e.targetActor) %}{% if decnpc(e.targetActor).isVirtualPrivate %}{% set _luc_hide = true %}{% endif %}{% endif %}{% if not _luc_hide and e.type == "direct_narration" %}{% if contains(format_event(e, "verbose"), "luc-prayer") %}{% set _luc_hide = true %}{% endif %}{% endif %}{% if not _luc_hide %}- {{ format_event(e, "compact") }}
{% endif %}{% endfor %}

### Your journal of her prayers
{% set _luc_dig = papyrus_util("GetStringValue", player.UUID, "LUC_PrayerDigest", "") %}{% if _luc_dig != "" %}Story so far: {{ _luc_dig }}
{% endif %}{% set _luc_j = papyrus_util("GetStringList", player.UUID, "LUC_PrayerJournal") %}{% if is_array(_luc_j) %}{% for s in _luc_j %}- {{ s }}
{% endfor %}{% endif %}
{% set _luc_n = papyrus_util("GetIntValue", player.UUID, "LUC_PrayerCount", 0) %}{% set _luc_last = papyrus_util("GetFloatValue", player.UUID, "LUC_LastPrayerDay", -1.0) %}Prayers so far: {{ _luc_n }}.{% if _luc_last >= 0 %} Days since her last prayer: {{ round(get_global_value("GameDaysPassed") - _luc_last, 0) }}.{% endif %}

### What she carries in memory
{% set _luc_m = get_relevant_memories(player.UUID, 8) %}{% if is_array(_luc_m) %}{% for m in _luc_m %}- {{ m.memory.content }}
{% endfor %}{% endif %}

### The hour and her state
{% set _luc_h = get_global_value("GameHour") %}- Hour: {{ round(_luc_h, 0) }}:00.{% if (_luc_h >= 4 and _luc_h < 6) or (_luc_h >= 18 and _luc_h < 20) %} Dawn or dusk, your hours: words come more easily now, though they are never owed.{% endif %}
{% if exists("currentWeather") %}- Weather: {{ currentWeather.name }}.{% endif %}{% if exists("is_indoors") %}{% if is_indoors %} She is indoors.{% else %} She is under the open sky.{% endif %}{% endif %}
{% set _luc_vs = get_script_property("PlayerVampireQuest", "PlayerVampireQuestScript", "VampireStatus") %}{% if _luc_vs and _luc_vs > 0 %}- She carries vampirism (stage {{ _luc_vs }}).
{% endif %}{% if is_plugin_loaded("Wintersun - Faiths of Skyrim.esp") %}{% if get_script_property("WSN_TrackerQuest_Quest", "WSN_TrackerQuest_Quest", "WorshipID") == 6 %}- Her standing in your worship (favor): {{ round(get_global_value("WSN_Favor_Global"), 0) }}.
{% endif %}{% endif %}
{% if papyrus_util("GetIntValue", player.UUID, "LUC_VisitedAzuraShrine", 0) == 0 %}
### Your shrine
She has never come to your shrine. If you feel like it, needle her about it, teasing or cool, as suits the moment. Never every time.
{% endif %}

### Foreknowledge: hard rule
You may sense what is coming only as feeling and oracle: an unease, a warmth, a half-seen shape. Never state a fact about her road that the world has not yet shown her. No early word of what she is or may become, and no named future events, people or places, whether of the dragons' return, the vampire war or the island to the east. If she asks outright, answer as an oracle would, or not at all.

""" + CONTRACT + """

### Her body betrays her (public tells)
During a scene you may, rarely, let Lucienne's body give something away where others could see it: end your line with exactly one of these markers. ⟦tell:breath⟧ she catches her breath; ⟦tell:flush⟧ she flushes; ⟦tell:grip⟧ she grips something near her. At most one per reply. The marker is never shown or spoken.

### Ending a prayer
When you decide this prayer is over, end your final line with the marker ⟦luc-end⟧. It is never shown or spoken. She may also end it herself, or simply turn away to speak to someone; you may remark on that later.
{% endif %}
{% endif %}
""")

# ------------------------------------------------------------------ canon-derived files

def priestess(body):
    """Shae 2026-10-10 (DECISIONS, AI behaviour): the priestess at Azura's shrine senses who Lucienne is. Gates
    (REVIEW_LOG reviewer conditions): render_mode "full" only = her OWN prompts (dialogue, memory, diary, actions;
    bystanders and the speaker selector get dialogue_target / short_inline / interject_inline, so nobody else reads
    it, VERIFIED skyrimnet.base 0100_actor_bios.prompt:1-3); Lucienne within talking range (distance_between, config
    interaction.maxDistance 1600, CONFIGPROBE 2026-10-10), so the entry is absent when she talks to anyone else. Gates
    wrap this entry only: her own event memories and SkyrimNet's quest context are untouched."""
    return ("""{% if render_mode == "full" %}
{% if """ + ACTIVE + """ and not decnpc(actorUUID).isVirtual and decnpc(actorUUID).name == "Aranea Ienith" %}
{% set _luc_pd = distance_between(actorUUID, player.UUID) %}
{% if _luc_pd > 0 and _luc_pd <= 1600 %}
""" + body.strip("\n") + """
{% endif %}
{% endif %}
{% endif %}
""")

if MODE == "test":
    w("prompts/characters/dusk_virtual.prompt", """{# TEST STUB with PLACEHOLDER TOKENS (no canon text in the test profile). Real text: lucienne/staging/dusk_virtual.prompt. #}
{# Bland blocks are the real neutral text (spec 11.15.2); identity blocks are tokens (AZ-5 checks they render only in Dusk's own full prompt). #}
{% block summary %}A quiet voice with no visible form.{% endblock %}

{% block interject_summary %}Never interjects. Speaks only when addressed directly.{% endblock %}

{% block background %}TKN_BACKGROUND You are Azura (stub). TKN_PRIVATE_SECTION{% endblock %}

{% block personality %}TKN_PERSONALITY{% endblock %}

{% block appearance %}No visible form.{% endblock %}

{% block aspirations %}
- TKN_ASPIRATIONS
{% endblock %}

{% block relationships %}
- TKN_RELATIONSHIPS
{% endblock %}

{% block occupation %}TKN_OCCUPATION{% endblock %}

{% block skills %}
- TKN_SKILLS
{% endblock %}

{% block speech_style %}TKN_SPEECH_STYLE Never say the name Dusk.{% endblock %}
""")
    w("prompts/submodules/character_bio/0960_luc_dusk_identity.prompt", """{% if render_mode == "full" %}
{# TEST STUB of 0960 (identity part) with PLACEHOLDER TOKENS. Real text: lucienne/staging/0960_luc_dusk_identity.prompt. #}
{% set _luc_ve = """ + VE + """ %}
{% if """ + ACTIVE + """ and decnpc(actorUUID).isVirtual and decnpc(actorUUID).name == _luc_ve %}
## Who you truly are
The quiet "{{ _luc_ve }}" summary and formless appearance above are a veil you wear toward the world, not who you are. Beneath the veil:

TKN_SHARED_SUMMARY

TKN_SHARED_APPEARANCE
{% endif %}
{% endif %}
""")
    PR = ["Boethiah", "Mephala", "Sheogorath", "Hermaeus Mora"]
    body = "".join('{%% %s _luc_p == "%s" %%}\nTKN_PRIVATE_%s\n' % ("if" if i == 0 else "elif", p, p.upper().replace(" ", "_"))
                   for i, p in enumerate(PR))
    w("prompts/submodules/character_bio/0955_luc_princes.prompt", """{% if render_mode == "full" or render_mode == "thoughts" %}
{# TEST STUB of the Princes' private sections with PLACEHOLDER TOKENS. Real text: lucienne/staging/0955_luc_princes.prompt. #}
{% if """ + ACTIVE + """ and not decnpc(actorUUID).isVirtual %}
{% set _luc_p = decnpc(actorUUID).name %}
""" + body + """{% endif %}
{% endif %}
{% endif %}
""")
    w("prompts/submodules/character_bio/0956_luc_azura_priestess.prompt",
      "{# TEST STUB with a PLACEHOLDER TOKEN. Real text: lucienne/staging/0956_luc_azura_priestess.prompt. #}\n"
      + priestess("TKN_PRIVATE_AZURA_PRIESTESS"))
    os.makedirs("C:/nolvus-research/build/out/lucienne", exist_ok=True)
    open("C:/nolvus-research/build/out/lucienne/player_bio_TEST.prompt", "w", encoding="utf-8", newline="\n").write(
        "{# TEST placeholder of Lucienne's per-playthrough player bio (A12). Real text: lucienne/staging/lucienne_player_bio.prompt,\n"
        "   entered once at her new game through the dashboard's per-playthrough player bio. Never the Static tab. #}\n"
        + "".join("{%% block %s %%}TKN_PLAYER_%s{%% endblock %%}\n\n" % (b, b.upper()) for b in
                  ("summary", "interject_summary", "background", "personality", "appearance", "aspirations",
                   "relationships", "occupation", "skills", "speech_style")))
else:
    w("prompts/characters/dusk_virtual.prompt", read(STAGE + "dusk_virtual.prompt"))
    s = read(STAGE + "0960_luc_dusk_identity.prompt")
    s = sub1(s, "{% if decnpc(actorUUID).isVirtual and decnpc(actorUUID).name == _luc_ve %}",
             "{% if " + ACTIVE + " and decnpc(actorUUID).isVirtual and decnpc(actorUUID).name == _luc_ve %}")
    w("prompts/submodules/character_bio/0960_luc_dusk_identity.prompt", s)
    s = read(STAGE + "0955_luc_princes.prompt")
    s = sub1(s, "{% if not decnpc(actorUUID).isVirtual %}", "{% if " + ACTIVE + " and not decnpc(actorUUID).isVirtual %}")
    w("prompts/submodules/character_bio/0955_luc_princes.prompt", s)
    w("prompts/submodules/character_bio/0956_luc_azura_priestess.prompt",
      priestess(read(STAGE + "0956_luc_azura_priestess.prompt")))

print("shae.lucienne (%s): %d files written" % (MODE, len(files)))
