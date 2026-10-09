"""Generate layer ieb.errandbridge (spec §11.1, §12) from the committed upstream copies, so each override is a
reviewable diff. Output: build/layers/errandbridge/SKSE/Plugins/SkyrimNet/external/ieb.errandbridge/."""
import os

UP = "C:/nolvus-research/build/upstream/"
OUT = "C:/nolvus-research/build/layers/errandbridge/SKSE/Plugins/SkyrimNet/external/ieb.errandbridge/"
IE_TRAVEL = "C:/nolvus-research/repos/IntelEngine-Gerk/SKSE/Plugins/SkyrimNet/external/galanx.intelengine/actions/travel.yaml"

GATE_RULE = """  - conditions:                       # Errand Bridge (spec §12): not while the bridge holds or lends this actor
      - decoratorName: papyrus_util
        arguments: ["GetIntValue", "currentActor", "IEB_Gate", 0]
        comparisonOperator: "=="
        expectedValue: 0
    logicalOperator: "AND"
    required: true
"""


def w(rel, text):
    p = OUT + rel
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "w", encoding="utf-8", newline="\n").write(text)


def read(p):
    return open(p, encoding="utf-8").read().replace("\r\n", "\n")


# manifest
w("manifest.json", """{
  "id": "ieb.errandbridge",
  "type": "bundle",
  "title": "Errand Bridge (private)",
  "tagline": "IntelEngine errands for NFF followers, SA lending, wait/recall routing.",
  "description": "Component A of the Errand Bridge build (spec §11.1, §12). Private; never published.",
  "author": "ieb",
  "version": "1.0.0",
  "min_skyrimnet_version": "0.25.0",
  "nsfw": false,
  "mods": [
    { "required": true, "file": "ErrandBridge.esp", "name": "Errand Bridge" },
    { "required": true, "file": "IntelEngine.esp", "name": "IntelEngine" },
    { "required": true, "file": "nwsFollowerFramework.esp", "name": "Nether's Follower Framework" }
  ]
}
""")

# CancelCurrentTask override -> IEB_Main.CancelOrRecall
w("actions/cancelcurrenttask.yaml", """# Errand Bridge override of IntelEngine's CancelCurrentTask (spec §8.1, §11.1). Same name, so the model sees the
# action IntelEngine's own 0801 prompt names. Routed to the bridge, which passes through to IntelEngine for anyone
# the bridge does not hold.
customCategory: intel_travel
name: CancelCurrentTask
description: >
  Stop or call off the errand you are CURRENTLY on (travelling somewhere, fetching or escorting someone,
  delivering a message, searching), when someone tells you to drop it, stop, wait, hold on, stay or come
  back, or you decide it is not worth doing. If you are {{ player.name }}'s companion away on an errand
  or waiting to rejoin after one, this is also how you answer "wait there" (stayHere 1) or "come back /
  come here" (stayHere 0). Not for following someone when you have no errand.

questEditorId: IEB_MainQuest
scriptName: IEB_Main
executionFunctionName: CancelOrRecall

parameterMapping:
  - type: speaker
    name: akNPC
    description: You (the one on the errand)
  - type: dynamic
    name: stayHere
    description: "1 = stay where you are now; 0 = come back / drop it"

eligibilityRules:
  - conditions:
      - decoratorName: is_in_combat
        arguments: ["currentActor"]
        comparisonOperator: "=="
        expectedValue: false
    logicalOperator: "AND"
    required: true
  - conditions:                       # on an IntelEngine task, or a bridge follower waiting to rejoin
      - decoratorName: papyrus_util
        arguments: ["GetIntValue", "currentActor", "Intel_Slot", -1]
        comparisonOperator: "!="
        expectedValue: -1
      - decoratorName: papyrus_util
        arguments: ["GetIntValue", "currentActor", "IEB_Held", 0]
        comparisonOperator: "=="
        expectedValue: 2
    logicalOperator: "OR"
    required: true

eventString: "{{ actor.name }} called off their errand"
isShortLived: true
enabled: true
defaultPriority: 7
tags: []
""")

# Travel category: no longer claims "stop / wait"
t = read(IE_TRAVEL)
a = "stop a current task, cancel what they're doing"
assert t.count(a) == 1
w("actions/travel.yaml", "# Errand Bridge category override (spec §11.1): the intent no longer claims stop/wait.\n" +
  t.replace(a, "abandon an errand they are currently on"))

# SA copies + one IEB_Gate rule (spec §12)
for y in ["waitforplayerhere", "resumefollowing", "setcompanion", "startfollowing"]:
    src = read(UP + "severactions-4.2.0/actions/%s.yaml" % y)
    i = src.index("eligibilityRules:")
    head = src[:i]
    rest = src[i:]
    # append the rule at the end of the eligibilityRules list: before the next top-level key after it
    lines = rest.split("\n")
    j = 1
    while j < len(lines) and (lines[j].startswith(" ") or lines[j].startswith("-") or lines[j] == ""):
        j += 1
    while j > 1 and lines[j - 1] == "":
        j -= 1
    body = "\n".join(lines[:j]) + "\n" + GATE_RULE + "\n".join(lines[j:])
    w("actions/%s.yaml" % y, "# Errand Bridge override (spec §12): SeverActions 4.2.0 file plus one IEB_Gate rule.\n" + head + body)

# 0802 prompt (spec §11.1 item 2), verbatim
w("prompts/submodules/character_bio/0802_ieb_errand.prompt", """{% if render_mode == "full" or render_mode == "thoughts" or render_mode == "transform" %}
{% if actorUUID and not is_player(actorUUID) %}
{% set iebHeld = papyrus_util("GetIntValue", actorUUID, "IEB_Held", 0) %}
{% if iebHeld == 1 or iebHeld == 2 %}
{% set iebName = decnpc(actorUUID).name %}
{% set iebTarget = papyrus_util("GetStringValue", actorUUID, "IEB_TaskTarget", "") %}
### Where {{ iebName }} Is Right Now
{% if iebHeld == 1 %}
- {{ iebName }} is still a member of {{ player.name }}'s party, but is not at {{ player.name }}'s side right now: {{ iebName }} is away on an errand for {{ player.name }}{% if iebTarget != "" %} (involving {{ iebTarget }}){% endif %} and will rejoin the group afterwards. This is more current than the travel history above.
{% else %}
- {{ iebName }} has finished an errand for {{ player.name }}{% if iebTarget != "" %} (involving {{ iebTarget }}){% endif %} and is waiting here to rejoin the group; {{ player.name }} is not with {{ iebName }} yet. This is more current than the travel history above.
- If {{ player.name }} asks {{ iebName }} to come back now, or to stay put, use CancelCurrentTask (stayHere 0 = come back, 1 = stay).
{% endif %}
{% endif %}
{% endif %}
{% endif %}
""")
print("written:", sorted(os.path.relpath(os.path.join(d, f), OUT) for d, _, fs in os.walk(OUT) for f in fs))
