"""Generate the festival layer shae.festival (REVIEW_LOG RV-121-dec: festival design APPROVED with every recommendation,
five nights; design investigation/round10/festival_nights.md 3.1-3.3, 4.3 files 3-4). Output, one mod root:
  build/layers/festival/SKSE/Plugins/SkyrimNet/external/shae.festival/
      manifest.json
      prompts/submodules/character_bio/0336_ieb_festival_night.prompt   (the inclination: enrolled NPC, gate open)
      prompts/submodules/character_bio/0340_ieb_festival_custom.prompt  (the custom: every adult, festival DAY)
  build/layers/festival/SKSE/Plugins/ErrandBridge/festival_nights.json   (keys, orcMinTier, abstain; JsonUtil schema)
0340 reads the date natively (get_global_value) so it does not depend on a Papyrus decorator. 0336 reads the festival
context from get_romance (festKey/festPhase/festival, written by the patched SNRom_Decorators.GetRomance with the SAME
rule PhysicalOk uses), so the line and the gate cannot disagree about the date, a scene judged at its start (RV-121-dec
rule 1) or the morning after (rule 2). Both carry the native adult tests (decnpc isChild + "child" race, a missing race
reads as a child). Wording: the approved placeholders (D11); the two RV-121-dec texts (carried-over scene, morning
after) are NEW placeholders for Shae.

  python gen_layer_festival.py                 write the layer
  python gen_layer_festival.py --check DIR     static checks against a patched scripts dir (apply_patch_f festival):
      key sets equal (JSON keys = 0340 = 0336 = SNRom_Decorators.IEB_FestivalName), names equal, the PhysicalOk hunk
      sits after the Applicability and NEVER returns, both prompts carry the adult tests and the switch."""
import json, os, re, sys

ROOT = "C:/nolvus-research/build/layers/festival/"
OUT = ROOT + "SKSE/Plugins/SkyrimNet/external/shae.festival/"
JSON_OUT = ROOT + "SKSE/Plugins/ErrandBridge/festival_nights.json"

# D1: key = GameMonth (0-based) * 100 + GameDay
NIGHTS = [(1, "the New Life Festival"), (116, "Heart's Day"), (516, "the Mid Year Celebration"),
          (727, "Harvest's End"), (1125, "Saturalia")]
ORC_MIN_TIER = 2   # D7


def w(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    open(path, "w", encoding="utf-8", newline="\n").write(text)


def name_chain(var_key, var_name):
    parts = []
    for i, (k, n) in enumerate(NIGHTS):
        parts.append('{%% %s %s == %d %%}{%% set %s = "%s" %%}' % ("if" if i == 0 else "elif", var_key, k, var_name, n))
    return "{%% set %s = \"\" %%}" % var_name + "".join(parts) + "{% endif %}"


ADULT = ('{% set _f_npc = decnpc(actorUUID) %}\n'
         '{% if not _f_npc.isVirtual and not _f_npc.isChild and not contains(lower(default(_f_npc.race, "child")), "child") %}')
SWITCH = 'papyrus_util("GetIntValue", player.UUID, "IEB_FestivalEnabled", 0) == 1'

P0340 = """{% if render_mode == "full" %}
{# shae.festival 0340 (festival_nights.md 3.1; REVIEW_LOG RV-121-dec). The custom, for EVERY adult NPC, on a festival
   DAY (06:00 to 06:00: before 06:00 the date steps back one day, no evening floor). Native reads only (get_global_value,
   papyrus_util), no Papyrus decorator, so it also renders on a decorator cache miss. Adults only: decnpc isChild and
   the native race test (a missing race reads as a child); not the player, not a virtual NPC. Switch
   IEB_FestivalEnabled on the player (default 0 = OFF). GameMonth is 0-based; key = month*100 + day. Same keys as
   festival_nights.json and SNRom_Decorators.IEB_FestivalName (gen_layer_festival.py --check). #}
{% if not is_player(actorUUID) and %SWITCH% %}
%ADULT%
{% set _f_h = get_global_value("GameHour") %}{% set _f_m = get_global_value("GameMonth") %}{% set _f_d = get_global_value("GameDay") %}
{% if _f_h < 6 %}{% set _f_d = _f_d - 1 %}{% endif %}
{% if _f_d < 1 %}{% if _f_m == 0 %}{% set _f_m = 11 %}{% else %}{% set _f_m = _f_m - 1 %}{% endif %}{% set _f_d = 31 %}{% if _f_m == 1 %}{% set _f_d = 28 %}{% elif _f_m == 3 or _f_m == 5 or _f_m == 8 or _f_m == 10 %}{% set _f_d = 30 %}{% endif %}{% endif %}
{% set _f_key = _f_m * 100 + _f_d %}
%NAMES%
{% if _f_name != "" %}

## The Festival

Today is {{ _f_name }}. On a festival night it is an old, accepted custom that people may take a lover for that one night, even someone met that evening. Nobody is shamed for it and nobody is owed it. By custom it binds no one: it is not counted against anyone's partner or promise the next day. Not everyone holds with it. The devout, the reserved and some who are already spoken for disapprove or simply keep out of it. Whether you take part, and what you think of those who do, is yours to decide from who you are.
{% endif %}
{% endif %}
{% endif %}
{% endif %}
"""

P0336 = """{% if render_mode == "full" %}
{# shae.festival 0336 (festival_nights.md 3.2; REVIEW_LOG RV-121-dec). The inclination, for an ENROLLED adult whose
   physical gate the festival rule covers right now. The festival context comes from get_romance (patched
   SNRom_Decorators.GetRomance: festKey, festPhase, festival = the festival minimum tier or -1), computed by the same
   Papyrus rule as romance_physical_ok, so a scene judged at its start does not flip mid-scene (rule 1) and the morning
   after covers only the NPC marked that night (rule 2). Phases: 0 the night, 1 a festival scene still running after
   its night or morning ended, 2 the morning after (06:00-12:00, same NPC). A decorator miss renders nothing: festKey
   and festival default to "none", romanceNA to foreclosed, stance to acknowledged (an acknowledged partner is not a
   fling). Adults only: the native race test as 0330 plus decnpc isChild; not the player, not virtual. #}
{% if not is_player(actorUUID) and is_plugin_loaded("SNRom_Integration.esl") and %SWITCH% %}
%ADULT%
{% if get_faction_rank(actorUUID, "SNRom_Bond") >= 0 %}
{% set _f_rom = get_romance(actorUUID) %}
{% set _f_key = default(_f_rom.festKey, 0) %}
{% if _f_key > 0 and default(_f_rom.festival, -1) >= 0 and default(_f_rom.romanceNA, 1) == 0 and default(_f_rom.stance, 1) != 1 %}
{% if romance_physical_ok(actorUUID) == "true" %}
{% set _f_phase = default(_f_rom.festPhase, -1) %}
%NAMES%
{% if _f_name != "" %}
{% if _f_phase == 0 %}

## Tonight

{% if default(_f_rom.level, 0) >= 1 %}Tonight is {{ _f_name }}, and you know {{ player.name }}. If they want you tonight you are strongly inclined to say yes; the night and the custom are on their side. If you say no, it is for a reason of your own you could name: you do not want them that way, someone you will not hurt, what you believe, or how they treat you or your people. Say it in your own way. Nothing is decided for you.
{% else %}Tonight is {{ _f_name }}, and you have only just met {{ player.name }}. Your nature allows a night like this with a stranger, if they please you and the moment is right. It is a real choice, not an expectation.
{% endif %}
{% elif _f_phase == 1 %}

## Still Tonight, For The Two Of You

The night of {{ _f_name }} has passed, but what began between you and {{ player.name }} during it is still covered by the custom until you part. Whether it goes on is still yours to decide.
{% elif _f_phase == 2 %}

## This Morning

Last night was {{ _f_name }}, and you spent part of it with {{ player.name }}. By custom the night's freedom lasts between the two of you until midday. If they want you again this morning you may say yes; it is your choice, and nothing is expected.
{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}
"""

MANIFEST = """{
  "id": "shae.festival",
  "type": "bundle",
  "title": "Festival Nights (private)",
  "tagline": "Private: five lore festival nights; the custom for every adult and the inclination for an enrolled NPC whose gate is open.",
  "description": "Festival nights (festival_nights.md, REVIEW_LOG RV-121-dec). Two additive character_bio files (0336, 0340). Needs SkyrimNet Relationships with the private patch group 'festival' (get_romance festKey/festPhase/festival) and the settings file SKSE/Plugins/ErrandBridge/festival_nights.json in this mod. Switch IEB_FestivalEnabled on the player, default OFF. Private; never published.",
  "author": "shae",
  "version": "1.0.0",
  "min_skyrimnet_version": "0.25.0",
  "nsfw": false
}
"""


def texts():
    sub = lambda t, names: t.replace("%SWITCH%", SWITCH).replace("%ADULT%", ADULT).replace("%NAMES%", names)
    return (sub(P0336, name_chain("_f_key", "_f_name")), sub(P0340, name_chain("_f_key", "_f_name")))


def settings():
    return {"int": {"orcMinTier": ORC_MIN_TIER}, "intList": {"keys": [k for k, _ in NIGHTS]}, "formList": {"abstain": []}}


def write():
    t36, t40 = texts()
    w(OUT + "manifest.json", MANIFEST)
    w(OUT + "prompts/submodules/character_bio/0336_ieb_festival_night.prompt", t36)
    w(OUT + "prompts/submodules/character_bio/0340_ieb_festival_custom.prompt", t40)
    w(JSON_OUT, json.dumps(settings(), indent=2) + "\n")
    print("festival layer written:", OUT, "+", JSON_OUT)


def keys_names(text):
    return {int(k): n for k, n in re.findall(r'_f_key == (\d+) %\}\{% set _f_name = "([^"]+)"', text)}


def check(scripts):
    errs = []
    want = dict(NIGHTS)
    # 1. key sets: JSON (as written) = 0336 = 0340 = Papyrus IEB_FestivalName
    j = json.load(open(JSON_OUT, encoding="utf-8"))
    if sorted(j["intList"]["keys"]) != sorted(want):
        errs.append("festival_nights.json keys %s != %s" % (j["intList"]["keys"], sorted(want)))
    if j["int"].get("orcMinTier") != ORC_MIN_TIER or j["formList"].get("abstain") is None:
        errs.append("festival_nights.json orcMinTier/abstain shape")
    for fn in ("0336_ieb_festival_night.prompt", "0340_ieb_festival_custom.prompt"):
        t = open(OUT + "prompts/submodules/character_bio/" + fn, encoding="utf-8").read()
        if keys_names(t) != want:
            errs.append("%s: key/name map %s != %s" % (fn, keys_names(t), want))
        # adult tests, switch, full render within the first 5 lines, not the player, not virtual
        if 'render_mode == "full"' not in "\n".join(t.splitlines()[:5]):
            errs.append(fn + ": render_mode guard not in the first 5 lines")
        for need in ("not _f_npc.isChild", 'contains(lower(default(_f_npc.race, "child")), "child")', "not _f_npc.isVirtual",
                     "not is_player(actorUUID)", SWITCH):
            if need not in t:
                errs.append("%s: missing %r" % (fn, need))
        # the adult test must come BEFORE any visible text (every heading sits after it)
        a, h = t.find("not _f_npc.isChild"), t.find("## ")
        if not (0 <= a < h):
            errs.append(fn + ": a heading precedes the adult test")
    t36 = open(OUT + "prompts/submodules/character_bio/0336_ieb_festival_night.prompt", encoding="utf-8").read()
    for need in ('default(_f_rom.romanceNA, 1) == 0', 'default(_f_rom.stance, 1) != 1', 'romance_physical_ok(actorUUID) == "true"',
                 'get_faction_rank(actorUUID, "SNRom_Bond") >= 0', 'default(_f_rom.festival, -1) >= 0'):
        if need not in t36:
            errs.append("0336: missing %r" % need)
    # 2. Papyrus side (patched scripts dir)
    dec = open(os.path.join(scripts, "SNRom_Decorators.psc"), encoding="utf-8").read().replace("\r\n", "\n")
    pap = {int(k): n for k, n in re.findall(r'aiKey == (\d+)\n\s+Return "([^"]+)"', dec)}
    if pap != want:
        errs.append("SNRom_Decorators.IEB_FestivalName %s != %s" % (pap, want))
    m = re.search(r'String Function PhysicalOk\(Actor akActor\) Global(.*?)\nEndFunction', dec, re.S)
    body = m.group(1) if m else ""
    i_app = body.find("SNRom_Decorators.RomanceApplicability(akActor) != 0")
    i_nev = body.find("If minTier < 0")
    i_fest = body.find("IEB_FestivalMinTier(akActor, rank)")
    if not (0 <= i_app < i_nev < i_fest):
        errs.append("PhysicalOk: the festival hunk is not after Applicability and the NEVER test (%d %d %d)" % (i_app, i_nev, i_fest))
    for fn_ in ("IEB_FestivalMinTierAt", "IEB_FestivalOrcHeld", "IEB_FestivalAbstains", "IEB_FestivalContext"):
        if ("Function %s(" % fn_) not in dec:
            errs.append("SNRom_Decorators: %s missing" % fn_)
    mt = re.search(r'Int Function IEB_FestivalMinTierAt\(.*?\nEndFunction', dec, re.S)
    if not mt or "akActor.IsChild()" not in mt.group(0) or "IEB_FestivalOn()" not in mt.group(0):
        errs.append("IEB_FestivalMinTierAt: IsChild / switch test missing")
    br = open(os.path.join(scripts, "SNRom_Bridge.psc"), encoding="utf-8").read().replace("\r\n", "\n")
    mj = re.search(r'Function IEB_FestivalJudge\(Actor akActor\)(.*?)\nEndFunction', br, re.S)
    if not mj:
        errs.append("SNRom_Bridge: IEB_FestivalJudge missing")
    else:
        b = mj.group(1)
        first_write = min([x for x in (b.find("StorageUtil.Set"), b.find("StorageUtil.FormListAdd")) if x >= 0] or [-1])
        if not (0 <= b.find("akActor.IsChild()") < first_write):
            errs.append("IEB_FestivalJudge: the IsChild return is not before the first write")
    for e in errs:
        print("FAIL", e)
    print("festival static check:", "PASS" if not errs else "FAIL (%d)" % len(errs))
    return 1 if errs else 0


if __name__ == "__main__":
    if len(sys.argv) >= 3 and sys.argv[1] == "--check":
        sys.exit(check(sys.argv[2]))
    write()
