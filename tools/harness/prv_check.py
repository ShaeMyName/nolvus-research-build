"""Live render of the 0956 Azura's-shrine priestess gate (Shae 2026-10-10; reviewer plan, no coc). Harness ON, T0.
 1. A harness-only CLONE of the gate keyed to Uthgerd (token TKN_CLONE_UTHGERD) is copied into the Lucienne test layer
    before the launch and DELETED after the game closes; it never enters build/ or install_step7.json.
 2. LUC_Active on (console LUC_ActivateRequest, undone by the next T0 load).
 3. Uthgerd where she stands (expect absent if > 1600 u), then moved next to the player: token only in "full",
    never in dialogue_target / short_inline / interject_inline.
 4. The priestess (ref 0x28AD1, far from Whiterun): her own "full" bio must not carry TKN_PRIVATE_AZURA_PRIESTESS.
Renders go through MCP render_template with actor = player and formid_to_uuid (works for an unloaded actor).
Prints only token presence, distances and names. Usage: prv_check.py (game and MO2 closed)"""
import os, sys, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import game
from runner import Run

LAYER = ("C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/Lucienne - Private (TEST STUB)/SKSE/Plugins/SkyrimNet/"
         "external/shae.lucienne/prompts/submodules/character_bio/")
CLONE = LAYER + "0957_zz_rv_clone_uthgerd.prompt"
F2, PRIESTESS, PLAYER = 0x00091918, 0x00028AD1, 0x14
MODES = ("full", "dialogue_target", "short_inline", "interject_inline")
LOG = []


def say(m):
    line = "%s %s" % (time.strftime("%H:%M:%S"), m)
    print(line, flush=True)
    LOG.append(line)


def clone_text():
    src = open(LAYER + "0956_luc_azura_priestess.prompt", encoding="utf-8").read()
    assert 'decnpc(actorUUID).name == "Aranea Ienith"' in src and "TKN_PRIVATE_AZURA_PRIESTESS" in src
    return ("{# HARNESS-ONLY CLONE of the 0956 gate (reviewer live check); deleted by prv_check.py #}\n"
            + src.replace('"Aranea Ienith"', '"Uthgerd the Unbroken"').replace("TKN_PRIVATE_AZURA_PRIESTESS",
                                                                              "TKN_CLONE_UTHGERD"))


PUUID = [None]


def render(ctl, content):
    if not PUUID[0]:
        PUUID[0] = ctl.uuid(PLAYER)[0]          # Run.uuid returns (uuid, info)
    res = ctl.tool("render_template", {"actor_uuid": PUUID[0], "content": content + "{# %d #}" % time.time_ns()})
    if isinstance(res, dict) and "renderedContent" in res:
        return res["renderedContent"] or ""
    say("RENDER ERROR %s" % str(res.get("error") if isinstance(res, dict) else res)[:160])
    return ""


def check(ctl, fid, token, label, expect_full):
    u = "formid_to_uuid(%d)" % fid
    name = render(ctl, "{{ decnpc(%s).name }}" % u).strip()
    dist = render(ctl, "{{ distance_between(%s, player.UUID) }}" % u).strip()
    if expect_full is None:          # "where she stands": in range or not decides
        try:
            expect_full = 0 < float(dist) <= 1600
        except ValueError:
            expect_full = False
    ok = True
    for mode in MODES:
        out = render(ctl, '{{ render_character_profile("%s", %s) }}' % (mode, u))
        has = token in out
        want = expect_full and mode == "full"
        ok = ok and has == want
        say("%s %s (%s, dist %s) mode=%s token=%s expected=%s %s"
            % (label, name, hex(fid), dist, mode, has, want, "OK" if has == want else "MISMATCH"))
    return ok


def main():
    if game.procs():
        sys.exit("ABORT: game or MO2 running")
    open(CLONE, "w", encoding="utf-8", newline="\n").write(clone_text())
    say("clone installed: %s" % os.path.basename(CLONE))
    res = []
    try:
        game.set_archive("PRV_check_%s" % time.strftime("%Y%m%d-%H%M%S"))
        if not game.harness_mode() and not game.set_harness_mode(True, say):
            raise RuntimeError("harness mode could not be set on (Harness.yaml read-back)")
        if not game.launch(say, voices=False):
            raise RuntimeError("launch failed")
        ctl = Run("PRV_CONTROL")
        if not game.load(ctl, "T0", None):
            raise RuntimeError("T0 load failed")
        act = render(ctl, '{{ papyrus_util("GetIntValue", player.UUID, "LUC_Active", 0) }}').strip()
        if act != "1":
            ctl.tool("execute_console_command", {"command": "set LUC_ActivateRequest to 1"})
            # 23:21 run: LUC_Active was set at 23:20:52 (LUC log) but the render 9 s later still read 0: SkyrimNet
            # caches decorator callbacks. Confirm Papyrus-side first, then re-render until the cache lets it through.
            t = game.Tail(game.LOGS["papyrus"])
            m = t.wait(r"\[LUC\] activate request: [^\r\n]*", 30)
            say("LUC log: %s" % (m.group(0) if m else "no activate-request line in 30 s"))
            for _ in range(12):
                act = render(ctl, '{{ papyrus_util("GetIntValue", player.UUID, "LUC_Active", 0) }}').strip()
                if act == "1":
                    break
                time.sleep(15)
        say("LUC_Active = %s" % act)
        if act == "1":
            res.append(("Uthgerd where she stands", check(ctl, F2, "TKN_CLONE_UTHGERD", "A", None)))
            ctl.ctl("MoveRel", [F2, PLAYER, 150.0, 0.0, 0.0])
            time.sleep(5)
            d = render(ctl, "{{ distance_between(formid_to_uuid(%d), player.UUID) }}" % F2).strip()
            try:
                near = 0 < float(d) <= 600
            except ValueError:
                near = False
            if near:        # RV-123 (3): MoveRel read back before case B depends on it
                res.append(("Uthgerd next to the player", check(ctl, F2, "TKN_CLONE_UTHGERD", "B", True)))
            else:
                say("PRV B INCONCLUSIVE: MoveRel read-back distance %s (want <= 600)" % d)
                res.append(("Uthgerd next to the player", None))
            res.append(("priestess far away", check(ctl, PRIESTESS, "TKN_PRIVATE_AZURA_PRIESTESS", "C", False)))
            pu = "formid_to_uuid(%d)" % PRIESTESS
            say("priestess live: isChild=%s race=%s" % (render(ctl, "{{ decnpc(%s).isChild }}" % pu).strip(),
                                                        render(ctl, "{{ decnpc(%s).race }}" % pu).strip()))
        game.archive_logs("end")
    except Exception as e:
        say("ERROR %s" % e)
    finally:
        game.close(None, timeout=60, force=True)
        for _ in range(30):
            if not game.procs():
                break
            time.sleep(2)
        os.remove(CLONE)
        say("clone removed: %s (exists=%s)" % (os.path.basename(CLONE), os.path.exists(CLONE)))
    for label, ok in res:
        say("PRV %s: %s" % (label, ok))
    open("C:/nolvus-research/test_runs/PRV_check_%s.txt" % time.strftime("%Y%m%d-%H%M%S"), "w", encoding="utf-8").write(
        "\n".join(LOG) + "\n")
    say("PRV DONE")


if __name__ == "__main__":
    main()
