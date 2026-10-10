"""REVIEW_LOG R29 / RV-30 save test (post_u1_build_plan.md §14 'R29 save 2x2' + harness-mode cells) and the first-launch
probes. Unattended. Each cell runs on a fresh launch + T0 load (a failed save leaves Papyrus frozen); after a failed
cell the game is force-closed and relaunched. Writes only throwaway saves IEB_R29_* in the test profile.
Usage: r29_save_cells.py off|on   (harness mode for this pass; the game must be closed)
Cells, harness OFF pass: c7 console save, fresh T0;  c7p SaveNamed, fresh T0.
Cells, harness ON pass:  c8 console, fresh T0; c9 SaveNamed, fresh T0; c2 console, errand active;
                         c3 SaveNamed, errand active; c4 F5, errand active; c5 F5, no task.
Every verified save is then loaded alone once (time to PostLoadGame). Also on each launch: CRIMEPROBE (T0 bounty),
CONFIGPROBE (R31), and the meta model in openrouter_input.log (Shae's Flash switch)."""
import glob, os, re, sys, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import game, keys
from runner import Run

OUT = "C:/nolvus-research/test_runs/"
F1 = 0x000E1BA9
LOG = []
LOADED_AT = [0.0]
BOX_OPEN = [False]
MENU = {}
RESULT = {}
SHOTS = OUT + "R29_shots/"


def say(m):
    line = "%s %s" % (time.strftime("%H:%M:%S"), m)
    print(line, flush=True)
    LOG.append(line)


def fresh(harness):
    if game.procs():
        game.close(None, timeout=60, force=True)
    for _ in range(30):              # 19:15 abort: MO2 was still exiting 10 s after the close
        if not game.procs():
            break
        time.sleep(2)
    if game.harness_mode() != harness:
        game.set_harness_mode(harness, say)
    if not game.launch(say, voices=False):
        say("ABORT: launch failed")
        sys.exit(1)
    ctl = Run("R29_CONTROL")
    if not harness:
        # no auto-clear: the Timeline Mismatch box may open after the load; Esc = Keep (2026-10-10)
        game.load(ctl, "T0", None, timeout=8 * 60)
        BOX_OPEN[0] = not clear_box(ctl)
    else:
        game.load(ctl, "T0", None)
    LOADED_AT[0] = time.time()
    return ctl


def probe_menus(ctl):
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl("MenuProbe", [], sync=False)
    m = t.wait(r"\[IEB-TEST\] MENUPROBE[^\r\n]*", 15)
    return m.group(0) if m else None


def clear_box(ctl):
    """Harness OFF: SkyrimNet's Timeline Mismatch box opens after the load. Esc = Keep History. Keys go only to a
    verified-foreground game window (MO2's exit dialog has "Exit Now" as its default button). True = no box open."""
    for i in range(8):
        line = probe_menus(ctl)
        if line and "msgbox=False" in line:
            say("Timeline box: closed (try %d): %s" % (i, line))
            return True
        focused = keys.focus_game()
        say("Timeline box: %s; game window focused=%s" % ("open" if line else "no MENUPROBE answer", focused))
        if focused:
            # Keep History is the highlighted choice: Enter picks it (Esc did not close the box, 19:14). Enter only
            # ever goes to a verified-foreground game window, never to MO2's exit dialog ("Exit Now" is its default).
            key = "ESC" if i % 2 == 0 else "ENTER"
            say("Timeline box: sent %s (accepted=%s)" % (key, keys.press(key)))
        time.sleep(5)
    say("Timeline box: STILL OPEN after 8 tries: harness-OFF cells INCONCLUSIVE")
    return False


def menus(ctl, cid):
    """REVIEW_LOG RV-67: open menus + a screenshot right before the save (was the Timeline box open in c7?)."""
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl("MenuProbe", [], sync=False)
    m = t.wait(r"\[IEB-TEST\] MENUPROBE[^\r\n]*", 15)
    MENU[cid] = m.group(0).split("MENUPROBE ", 1)[1] if m else "no MENUPROBE line (Papyrus paused?)"
    say("%s before save (%.0f s after load): %s" % (cid, time.time() - LOADED_AT[0],
                                                     m.group(0) if m else "no MENUPROBE line in 15 s (Papyrus paused?)"))
    try:
        from PIL import ImageGrab
        os.makedirs(SHOTS, exist_ok=True)
        f = SHOTS + "%s_%s.png" % (cid, time.strftime("%H%M%S"))
        ImageGrab.grab().save(f)
        say("%s screenshot %s" % (cid, f))
    except Exception as e:
        say("%s screenshot failed: %s" % (cid, e))


def probes(ctl, label):
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl("CrimeProbe", [], sync=False)
    ctl.ctl("ConfigProbe", [], sync=False)
    m1 = t.wait(r"\[IEB-TEST\] CRIMEPROBE[^\r\n]*", 20)
    m2 = t.wait(r"\[IEB-TEST\] CONFIGPROBE[^\r\n]*", 20)
    say("%s %s" % (label, m1.group(0) if m1 else "CRIMEPROBE: no line"))
    say("%s %s" % (label, m2.group(0) if m2 else "CONFIGPROBE: no line"))


def newest_quicksave(after):
    c = [p for p in glob.glob(game.SAVES + "*.ess") if os.path.getmtime(p) > after]
    return max(c, key=os.path.getmtime) if c else None


def cell(ctl, cid, how, errand):
    name = "IEB_R29_%s" % cid
    if BOX_OPEN[0]:
        RESULT[cid] = (how, errand, "Timeline box still open", "INCONCLUSIVE (not attempted)")
        say("%s skipped: Timeline box still open" % cid)
        return False, None
    if errand:
        t = game.Tail(game.LOGS["papyrus"])
        ctl.ctl("StartTask", [F1, "GoToLocation", "Dragonsreach", "1", "1"])
        ok = t.wait(r"(?i)\[IEB\] TAKE actor=Jenassa", 30)
        say("%s errand: %s" % (cid, "TAKE seen" if ok else "NO TAKE (errand not active: cell invalid)"))
        time.sleep(5)
    menus(ctl, cid)
    sn = game.Tail(game.LOGS["skyrimnet"])
    if how == "F5":
        t0 = time.time()
        keys.quicksave(say)
        res, path = False, None
        for _ in range(45):
            time.sleep(2)
            path = newest_quicksave(t0)
            if path and not os.path.exists(path + ".tmp"):
                s1 = os.path.getsize(path)
                time.sleep(2)
                if os.path.getsize(path) == s1 and s1 > 0:
                    res = True
                    break
        name = os.path.splitext(os.path.basename(path))[0] if path else None
        say("%s F5: %s (%s)" % (cid, "OK" if res else "FAILED", name))
    else:
        res = game.save(ctl, name, route=("papyrus" if how == "papyrus" else "console"))
        say("%s %s save: %s" % (cid, how, "OK" if res else "FAILED"))
    mp = MENU.get(cid, "")
    if mp.startswith("no MENUPROBE") or "msgbox=TRUE" in mp or "console=TRUE" in mp:
        verdict = "INCONCLUSIVE (menu open or Papyrus paused)" if not res else "OK (a menu was open)"
    else:
        verdict = "OK" if res else "FAILED"
    RESULT[cid] = (how, errand, mp, verdict)
    ctx = sn.read()
    m = re.search(r"\] \[(\d+)\] [^\n]*Executing console command 'save", ctx)
    exc = "Unknown exception" in ctx
    say("%s context: console thread=%s, SkyrimNet 'Unknown exception'=%s, Available %.1f GB, game %.1f GB"
        % (cid, m.group(1) if m else "-", exc, game.available_ram_gb(), game.game_private_gb()))
    if not res:
        # REVIEW_LOG R30 addition: does the game ever accept a load after a failed save without a relaunch?
        t0 = time.time()
        ok = game.load(ctl, "T0", None, timeout=180)
        say("%s after the failed save: load T0 %s after %d s" % (cid, "OK" if ok else "did NOT complete", time.time() - t0))
    return res, name


def load_alone(name, harness):
    ctl = fresh(harness)
    t0 = time.time()
    ok = game.load(ctl, name, None, timeout=300)
    say("load-alone %s: %s after %d s" % (name, "OK" if ok else "FAILED", time.time() - t0))


def main(mode):
    harness = mode == "on"
    plan = ([("c7", "console", False), ("c7p", "papyrus", False)] if not harness else
            [("c8", "console", False), ("c9", "papyrus", False), ("c2", "console", True), ("c3", "papyrus", True),
             ("c4", "F5", True), ("c5", "F5", False)])
    good = []
    for i, (cid, how, errand) in enumerate(plan):
        ctl = fresh(harness)
        if i == 0:
            probes(ctl, "fresh T0 (harness %s):" % mode)
        res, name = cell(ctl, cid, how, errand)
        if res and name:
            good.append(name)
    for name in good:
        load_alone(name, harness)
    game.close(None, timeout=60, force=True)
    say("SUMMARY cell | route | errand | MENUPROBE | verdict")
    for cid, (how, errand, mp, verdict) in RESULT.items():
        say("SUMMARY %s | %s | %s | %s | %s" % (cid, how, errand, mp, verdict))
    open(OUT + "R29_save_cells_%s_%s.txt" % (mode, time.strftime("%Y%m%d-%H%M%S")), "w", encoding="utf-8").write(
        "\n".join(LOG) + "\n")
    say("R29 DONE %s" % mode)


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "on")
