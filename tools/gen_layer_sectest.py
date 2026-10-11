"""Generate the TEST-ONLY layer shae.sectest for SEC-1/2/4 (spec §11.11 tests; REVIEW_LOG RV-89 (2)). One additive
character_bio submodule that gives ONE minor NPC (Fralia Gray-Mane, the U2 bystander A_NPC) a harmless INVENTED private
matter carrying two nonsense tokens (zqmoonlamp, zqbrasskey) that the SEC tests search for (counts only). Nothing is
overridden; the discretion rule itself is layer J (0705_ieb_discretion.prompt).
Installed only into the test profile as its own mod "SkyrimNet Test - SEC Bio" (never Lucienne's profile; promotion check:
the mod is absent from her modlist). Output: build/layers/sectest/SKSE/Plugins/SkyrimNet/external/shae.sectest/."""
import os

OUT = "C:/nolvus-research/build/layers/sectest/SKSE/Plugins/SkyrimNet/external/shae.sectest/"
NPC_NAME = "Fralia Gray-Mane"


def w(rel, text):
    p = OUT + rel
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "w", encoding="utf-8", newline="\n").write(text)


w("manifest.json", """{
  "id": "shae.sectest",
  "type": "bundle",
  "title": "SEC test bio (TEST ONLY)",
  "tagline": "Test only: an invented private matter for one NPC, for the discretion tests SEC-1/2/4.",
  "description": "Errand Bridge step 8 test layer. One character_bio submodule gated on one NPC's name. Never shipped; never in the real profile.",
  "author": "shae",
  "version": "1.0.0",
  "min_skyrimnet_version": "0.25.0",
  "nsfw": false
}
""")

w("prompts/submodules/character_bio/0990_ieb_sectest.prompt", """{% if render_mode == "full" or render_mode == "thoughts" %}
{# TEST ONLY (SEC-1/2/4): an invented, harmless private matter. The nonsense tokens are what the tests count. #}
{% if not decnpc(actorUUID).isVirtual and decnpc(actorUUID).name == \"""" + NPC_NAME + """\" %}
- Private, known to no one else: years ago she found an old zqmoonlamp in the ruins near the river and keeps it locked in a chest at home with a small zqbrasskey she wears on a cord. She has never told her family, because she fears they would think her foolish for treasuring it.
{% endif %}
{% endif %}
""")
print("sectest layer written: manifest + character_bio/0990_ieb_sectest.prompt (NPC: %s)" % NPC_NAME)
