"""Generate layer I shae.child-safety (TASK_C step 4; spec §11.10.2 P4, DECISIONS TASK_B 5b SitOrLayDown) from the
committed SeverActions 4.2.0 copies in build/upstream/: same-path copies of undress.yaml, unequiparmor.yaml and
sitorlaydown.yaml with one more eligibility rule each.

[CHANGED in build 2026-10-09, Shae: P5 dropped, so no IEB_IsChild tag ever exists] The child rule reads the game's own
child check natively: decorator decnpc on currentActor, resultPath "isChild" == false (the resultPath key: SNDLL:L47530,
L46610-46613; isChild: SNDLL:L41701-41702, L41763). No Papyrus decorator, no tag.
sitorlaydown.yaml also carries the bridge gate IEB_Gate == 0 (spec §12 pattern; DECISIONS SitOrLayDown (a)): one file
per path, so both rules live in this copy and ieb.errandbridge does not ship it.
Output: build/layers/child-safety/SKSE/Plugins/SkyrimNet/external/shae.child-safety/."""
import os

UP = "C:/nolvus-research/build/upstream/severactions-4.2.0/actions/"
OUT = "C:/nolvus-research/build/layers/child-safety/SKSE/Plugins/SkyrimNet/external/shae.child-safety/"

CHILD_RULE = """  - conditions:
      # Child guard P4 (IEB spec 11.10.2): a child speaker is never eligible. The game's own child check, read
      # natively from SkyrimNet's decnpc() (field isChild) through resultPath. Kept as the LAST rule.
      - decoratorName: "decnpc"
        arguments: ["currentActor"]
        resultPath: "isChild"
        comparisonOperator: "=="
        expectedValue: false
    logicalOperator: "AND"
    required: true
"""

GATE_RULE = """  - conditions:
      # Errand Bridge (IEB spec 12): not while the bridge holds, rejoins or lends this actor
      - decoratorName: "papyrus_util"
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


def copy_with(name, extra):
    src = open(UP + name, encoding="utf-8").read().replace("\r\n", "\n")
    assert src.rstrip("\n").endswith("required: true"), name + ": eligibilityRules must be the file's last block"
    head = "# IEB layer I copy of SeverActions 4.2.0 actions/%s; only the rules at the end are added.\n" % name
    w("actions/" + name, head + src.rstrip("\n") + "\n" + extra)


w("manifest.json", """{
  "id": "shae.child-safety",
  "type": "bundle",
  "title": "Child Safety Guards (private)",
  "tagline": "Private: SeverActions Undress, UnequipArmor and SitOrLayDown never offered to a child speaker.",
  "description": "Component I of the Errand Bridge build (spec 11.10.2 P4). Same-path copies of three SeverActions 4.2.0 actions, each with one more eligibility rule on SkyrimNet's native child check; SitOrLayDown also carries the Errand Bridge gate. Private; never published.",
  "author": "shae",
  "version": "1.0.0",
  "min_skyrimnet_version": "0.25.0",
  "nsfw": false,
  "mods": [
    { "required": true, "file": "SeverActions.esp", "name": "SeverActions" }
  ]
}
""")
copy_with("undress.yaml", CHILD_RULE)
copy_with("unequiparmor.yaml", CHILD_RULE)
copy_with("sitorlaydown.yaml", GATE_RULE + CHILD_RULE)
print("layer I written: 3 action copies (child rule on all; IEB_Gate on sitorlaydown)")
