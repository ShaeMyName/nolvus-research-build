"""Generate layer K shae.marriage (TASK_C step 4c; spec §11.12.3 M1): same-path override of MARAS 0.11.0
prompts/submodules/guidelines/0501_marriage_chances.prompt (45 lines; installed copy identical to build/upstream/).
  (a) the blanket "Most who understand this view it with respect" line -> facts only (polygamy permitted; MARAS's own
      spouse and fiance lists stay);
  (b) top chance band capped at "is eager to accept" ("regardless of any existing relations" dropped);
  (c) when the player already has a spouse, fiance or acknowledged partner, an exclusivity clause from Relationships'
      SNRom_Exclusivity (native papyrus_util; -1 = not enrolled). "Already has": MARAS's TTM_LoveInterestsCount, or
      Relationships' SNRom_PartnerCount (union with MARAS since the M2 hunk) minus this NPC if it is itself an
      acknowledged partner (sparked and stance accepted = 1).
Output: build/layers/marriage/SKSE/Plugins/SkyrimNet/external/shae.marriage/."""
import os

UP = "C:/nolvus-research/build/upstream/maras-0.11.0/prompts/submodules/guidelines/0501_marriage_chances.prompt"
OUT = "C:/nolvus-research/build/layers/marriage/SKSE/Plugins/SkyrimNet/external/shae.marriage/"


def w(rel, text):
    p = OUT + rel
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "w", encoding="utf-8", newline="\n").write(text)


def sub1(s, old, new):
    assert s.count(old) == 1, (old[:70], s.count(old))
    return s.replace(old, new)


s = open(UP, encoding="utf-8").read().replace("\r\n", "\n")
s = sub1(s, "            {{player.name}} is known to walk a blessed path, one that allows multiple spouses through divine sanction. Most who understand this view it with respect, not judgment.\n",
         "            {# shae.marriage M1 (a): facts only. #}\n            {{player.name}} may have more than one spouse.\n")
s = sub1(s, '                    {% set chanceString = "must accept as though it were fated—unquestioning and unwise, regardless of any existing relations" %}\n',
         '                    {# shae.marriage M1 (b): top band capped. #}\n                    {% set chanceString = "is eager to accept" %}\n')
CLAUSE = """                {# shae.marriage M1 (c): exclusivity, only when the player already has someone. #}
                {% set _ieb_others = papyrus_util("GetIntValue", null, "SNRom_PartnerCount", 0) %}
                {% if papyrus_util("GetIntValue", npc.UUID, "SNRom_Sparked", 0) == 1 %}{% if papyrus_util("GetIntValue", npc.UUID, "SNRom_PlayerStance", 0) == 1 %}{% set _ieb_others = _ieb_others - 1 %}{% endif %}{% endif %}
                {% set _ieb_has = _ieb_others >= 1 %}{% if get_global_value("TTM_LoveInterestsCount") >= 1.0 %}{% set _ieb_has = true %}{% endif %}
                {% if _ieb_has %}
                    {% set _ieb_excl = papyrus_util("GetIntValue", npc.UUID, "SNRom_Exclusivity", -1) %}
                    {% if _ieb_excl < 0 %}
                        {{player.name}} already has a spouse, betrothed or partner. How {{npcName}} feels about sharing a spouse is {{npcName}}'s own; decide from who {{npcName}} is.
                    {% else if _ieb_excl >= 88 %}
                        {{player.name}} already has a spouse, betrothed or partner. {{npcName}} will not join a marriage shared with others, and no argument changes that.
                    {% else if _ieb_excl >= 63 %}
                        {{player.name}} already has a spouse, betrothed or partner. {{npcName}} refuses to share a spouse unless {{npcName}}'s feeling for {{player.name}} has grown strong enough to outweigh it, and even then it is a concession.
                    {% else if _ieb_excl >= 38 %}
                        {{player.name}} already has a spouse, betrothed or partner. {{npcName}} expected to be the only one and hesitates at sharing.
                    {% else %}
                        {{player.name}} already has a spouse, betrothed or partner. Being one of several is no obstacle for {{npcName}}.
                    {% endif %}
                {% endif %}
                If {{player.name}} makes a proposal, {{npcName}} {{chanceString}}.
"""
s = sub1(s, "                If {{player.name}} makes a proposal, {{npcName}} {{chanceString}}.\n", CLAUSE)

w("manifest.json", """{
  "id": "shae.marriage",
  "type": "bundle",
  "title": "Marriage and Exclusivity (private)",
  "tagline": "Private: MARAS proposal guidance with facts only, a capped top band and Relationships exclusivity.",
  "description": "Component K of the Errand Bridge build (spec 11.12.3 M1). Same-path override of MARAS 0.11.0 guidelines/0501_marriage_chances.prompt. Needs MARAS and SkyrimNet Relationships (with the private patch's M2 partner count). Private; never published.",
  "author": "shae",
  "version": "1.0.0",
  "min_skyrimnet_version": "0.25.0",
  "nsfw": false,
  "mods": [
    { "required": true, "file": "TT_MARAS.esp", "name": "MARAS" }
  ]
}
""")
w("prompts/submodules/guidelines/0501_marriage_chances.prompt", s)
print("layer K written")
