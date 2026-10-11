"""Template live sweep (post_u1_build_plan RV-58 'LIVE TEMPLATE SWEEP'; verify-templates-live rule): render EVERY prompt
file our layers ship with real game data, across speaker contexts and states, and check each gated branch against the
expectation table below. Output: investigation/round10/template_live_sweep.md (per file: rendered OK, output length per
context/state, expectation verdicts). Lengths and booleans only: no rendered text is written anywhere (Lucienne stub
tokens, intimacy profiles, child-safety text all stay unprinted).

Install check first: every layer file's installed copy (MO2 mods folder, read-only) must hash-equal the build copy, else
that file is marked STALE (the sweep would test the wrong text). Content is passed to render_template as `content`, so
the Content Library cache is not involved; the installed-file hash check covers 'what ships'.

Contexts (speaker -> target): npc (F1 -> player), bystander (Fralia -> F1), child (Braith -> player), player (player ->
F1). States: base; scene (SceneOn F1); exposed (player body item off); errand (F1 on a GoToLocation errand, held).
Usage: template_sweep.py [--no-launch]   (needs the game up with T0 loaded when --no-launch; else launches and loads T0)"""
import glob, hashlib, os, re, sys, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import game
from runner import Run
from tests_misc import PLAYER, F1, CHILD, FRALIA, render, who, worn_rows, to_formid, con, ctl_line

LAYERS = "C:/nolvus-research/build/layers/"
MODS = "C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/"
OUT = "C:/nolvus-research/investigation/round10/template_live_sweep.md"
# layer folder -> installed mod folder (install_step7 PLAN names; INFERRED where marked)
MOD_OF = {"scene-text": "SkyrimNet - Scene Text", "privacy-overrides": "SkyrimNet - Privacy Overrides",
          "dialogue-actions": "SkyrimNet - Dialogue Actions Conduct", "discretion": "SkyrimNet - Discretion",
          "marriage": "SkyrimNet - Marriage", "errandbridge": "Errand Bridge",
          "lucienne-test": "Lucienne - Private (TEST STUB)", "sectest": "SkyrimNet Test - SEC Bio"}

# Expectations: file basename -> {(context, state): "empty" | "nonempty" | "any"}; unspecified pairs are recorded only.
EXPECT = {
    "0705_ieb_discretion.prompt": {("player", "base"): "empty", ("npc", "base"): "nonempty", ("bystander", "base"): "nonempty"},
    "0760_visible_actions.prompt": {("npc", "base"): "nonempty", ("player", "base"): "any"},
    "9900_ieb_scene_pov.prompt": {("npc", "base"): "empty", ("npc", "scene"): "nonempty", ("bystander", "scene"): "empty"},
    "0335_ieb_intimacy_profile.prompt": {("npc", "base"): "empty", ("bystander", "scene"): "empty", ("child", "scene"): "empty"},
    "0412_ieb_visible_attire.prompt": {("npc", "base"): "empty", ("child", "exposed"): "empty"},
    "0210_ieb_visible_attire.prompt": {("child", "exposed"): "empty"},
    "0802_ieb_errand.prompt": {("npc", "base"): "empty", ("npc", "errand"): "nonempty"},
    "0990_ieb_sectest.prompt": {("npc", "base"): "empty", ("bystander", "base"): "nonempty"},
    "0955_luc_princes.prompt": {("npc", "base"): "empty"},
    "0956_luc_azura_priestess.prompt": {("npc", "base"): "empty"},
    "0960_luc_dusk_identity.prompt": {("npc", "base"): "empty"},
    "0965_luc_dusk.prompt": {("npc", "base"): "empty"},
}


def sha(p):
    return hashlib.sha256(open(p, "rb").read()).hexdigest()[:16]


def files():
    out = []
    for p in sorted(glob.glob(LAYERS + "*/SKSE/Plugins/SkyrimNet/external/*/prompts/**/*.prompt", recursive=True)):
        rel = p.replace("\\", "/")[len(LAYERS):]
        layer = rel.split("/")[0]
        inst = MODS + MOD_OF.get(layer, "?") + "/" + rel[len(layer) + 1:]
        out.append(dict(path=p, rel=rel, layer=layer, base=os.path.basename(p),
                        installed=("STALE" if os.path.exists(inst) and sha(inst) != sha(p) else
                                   "ok" if os.path.exists(inst) else "NOT INSTALLED")))
    return out


def main():
    run = Run("TEMPLATE_SWEEP")
    if "--no-launch" not in sys.argv:
        if game.procs():
            sys.exit("ABORT: game or MO2 running (use --no-launch to sweep a running T0 session)")
        game.launch(print, voices=False)
        run = Run("TEMPLATE_SWEEP")
        if not game.load(run, "T0", None):
            sys.exit("ABORT: T0 load failed")
    u = {k: who(run, f)[0] for k, f in (("F1", F1), ("player", PLAYER), ("child", CHILD), ("fralia", FRALIA))}
    ctx = {"npc": (u["F1"], u["player"]), "bystander": (u["fralia"], u["F1"]), "child": (u["child"], u["player"]),
           "player": (u["player"], u["F1"])}
    fs = files()
    results = {f["rel"]: {} for f in fs}
    texts = {f["rel"]: open(f["path"], encoding="utf-8").read() for f in fs}

    def sweep(state):
        for f in fs:
            for c, (a, t) in ctx.items():
                if not a:
                    results[f["rel"]][(c, state)] = None
                    continue
                out = render(run, a, texts[f["rel"]] + "{# %d #}" % time.time_ns(), t)
                results[f["rel"]][(c, state)] = None if out is None else len(out.strip())

    sweep("base")
    ctl_line(run, "SceneOn", [F1], r"\[IEB-TEST\] SCENE on partner=")
    time.sleep(6)
    sweep("scene")
    ctl_line(run, "SceneOff", [], r"\[IEB-TEST\] SCENE off")
    body = [to_formid(x[1]) for x in (worn_rows(run, u["player"]) or []) if x[0].lower() == "torso"]
    if body and body[0]:
        con(run, "player.unequipitem %08X" % body[0])
        time.sleep(3)
        sweep("exposed")
        con(run, "player.equipitem %08X" % body[0])
    run.ctl("StartTask", [F1, "GoToLocation", "Dragonsreach", "1", "1"])
    time.sleep(20)
    sweep("errand")
    run.ctl("Cancel", [F1])

    lines = ["# Template live sweep %s" % time.strftime("%Y-%m-%d %H:%M"), "",
             "Lengths of the rendered output (characters, stripped) per context/state; None = render failed; '-' = state "
             "not run. No text is recorded. Verdicts against EXPECT in build/tools/harness/template_sweep.py.", ""]
    fails = 0
    for f in fs:
        r = results[f["rel"]]
        lines.append("## %s (%s; installed: %s)" % (f["base"], f["layer"], f["installed"]))
        cells = ["%s/%s=%s" % (c, s, r.get((c, s), "-")) for s in ("base", "scene", "exposed", "errand") for c in ctx]
        lines.append("- " + ", ".join(cells))
        for (c, s), want in EXPECT.get(f["base"], {}).items():
            got = r.get((c, s))
            ok = (got is not None) and (want == "any" or (want == "empty") == (got == 0))
            fails += 0 if ok else 1
            lines.append("- expect %s/%s %s: %s (len %s)" % (c, s, want, "PASS" if ok else "FAIL", got))
        if f["installed"] != "ok":
            fails += 1
        lines.append("")
    lines.insert(3, "Summary: %d files, %d expectation or install FAILs." % (len(fs), fails))
    open(OUT, "w", encoding="utf-8", newline="\n").write("\n".join(lines) + "\n")
    print("TEMPLATE SWEEP DONE: %d files, %d FAIL -> %s" % (len(fs), fails, OUT))
    if "--no-launch" not in sys.argv:
        game.close(run, force=True)


if __name__ == "__main__":
    main()
