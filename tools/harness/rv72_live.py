"""REVIEW_LOG RV-72 / RV-72-upd / RV-74 live proof (harness ON, unattended, one launch, loads in-session).
 1. T0: SlotsProbe (T0 slot-clean: every state 0, res -1), ReserveProbe (§2 reservation works: stamp age >= 0,
    FindFreeAgentSlot skips the reserved slot, stamp gone after release), IEB_FASTTICK lines.
 2. T0: errand (Jenassa -> Dragonsreach); TAKE; while travelling HeldProbe + SlotsProbe; HeldProbe right before
    SaveNamed IEB_RV72_mid (RV-72 (c) save side).
 3. Teardown-at-save (RV-74 (3)): DashCancel, SaveNamed IEB_RV72_td at once; then 30 s of bridge lines.
 4. Load IEB_RV72_mid: IEB_LOADKEYS / TASKTYPE_RESTORED, HeldProbe at once and after 10 s (DecisionTaskType must be
    the task type), arrival, HeldProbe, waiting-phase NFFDismiss -> NFF_DISMISSED + a RELEASE line.
 5. Load IEB_RV72_mid: dashboard cancel while travelling; 30 s: no TAKE/LEND/REFUSE/CMD_FOLLOW/DEFER for her; slots
    clean afterwards.
 6. Load IEB_RV72_td: IEB_LOADKEYS fac=False or no active slot for her; no TASKTYPE_RESTORED for her; slots clean.
Every session: count of "Cannot cast from None" / non-array Papyrus errors whose stack names IntelEngine_ or IEB_.
POOL session start/end lines from the sampler are copied into the result. Usage: rv72_live.py (game and MO2 closed)"""
import os, re, sys, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import block, game
from runner import Run

OUT = "C:/nolvus-research/test_runs/"
F1 = 0x000E1BA9
LOG, VERDICT = [], []
DECISION = r"\[IEB\] (TAKE|LEND|REFUSE|CMD_FOLLOW|DEFER)\w* actor=Jenassa[^\r\n]*"
ERR = re.compile(r"(Cannot cast from None|non-array|Cannot access an element of a None array)[^\r\n]*((?:\r?\n[^\r\n]*){0,4})")


def say(m):
    line = "%s %s" % (time.strftime("%H:%M:%S"), m)
    print(line, flush=True)
    LOG.append(line)


def verdict(name, ok, detail=""):
    VERDICT.append("%s %s %s" % (name, "PASS" if ok else ("INCONCLUSIVE" if ok is None else "FAIL"), detail))
    say("VERDICT " + VERDICT[-1])


def errors(text):
    n = sum(1 for m in ERR.finditer(text) if re.search(r"IntelEngine_|IEB_", m.group(0)))
    return n


def probe(ctl, fn, args, pat, label, timeout=20):
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl(fn, args, sync=False)
    # 2026-10-11 00:08: Papyrus case-folds a log literal to a same-named function ("SLOTSPROBE" -> "SlotsProbe")
    m = t.wait(r"(?i)\[IEB-TEST\] %s[^\r\n]*" % pat, timeout)
    say("%s: %s" % (label, m.group(0) if m else "no %s line" % pat))
    return m.group(0) if m else ""


def lines(text, pat):
    return [l.strip()[:220] for l in text.splitlines() if re.search(pat, l)]


def load(ctl, save):
    pap = game.Tail(game.LOGS["papyrus"])
    ok = game.load(ctl, save, None)
    say("LOAD %s: %s" % (save, "OK" if ok else "FAILED"))
    return pap, ok


def held_type(line):
    m = re.search(r" type=(\S*)", line)
    return m.group(1) if m else None


def start_errand(ctl):
    if not block.ie_test_settings(ctl):          # RV-123 (3): SkipProbe read-back
        say("errand: IE test settings NOT VERIFIED")
        return False
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl("StartTask", [F1, "GoToLocation", "Dragonsreach", "1", "1"])
    take = t.wait(r"(?i)\[IEB\] TAKE actor=Jenassa", 30)
    say("errand: %s" % ("TAKE seen" if take else "NO TAKE"))
    return bool(take)


def watch_decisions(sec):
    t = game.Tail(game.LOGS["papyrus"])
    time.sleep(sec)
    text = t.read()
    dec = lines(text, DECISION)
    for l in lines(text, r"\[IEB\] [A-Z_]+ actor=Jenassa"):
        say("  bridge: " + l)
    return dec, text


def main():
    if game.procs():
        sys.exit("ABORT: game or MO2 running")
    run_id = "RV72_live_%s" % time.strftime("%Y%m%d-%H%M%S")
    game.set_archive(run_id)
    t_start = time.strftime("%Y-%m-%d %H:%M:%S")
    errs = {}
    try:
        if not game.harness_mode() and not game.set_harness_mode(True, say):
            raise RuntimeError("harness mode could not be set on (Harness.yaml read-back)")
        if not game.launch(say, voices=False):
            raise RuntimeError("launch refused or failed")
        ctl = Run("RV72_CONTROL")
        # REVIEW_LOG RV-94: Flash-vs-Pro step 1, the MCP tool list (names only), read in setup (not an idle window)
        try:
            res = ctl.c.request("tools/list", {}, timeout=30)
            names = sorted(t.get("name", "?") for t in (res.get("result", res).get("tools", []) if isinstance(res, dict) else []))
            open("C:/nolvus-research/test_runs/mcp_tools_%s.txt" % time.strftime("%Y%m%d-%H%M%S"), "w",
                 encoding="utf-8").write("\n".join(names) + "\n")
            say("MCP TOOL LIST read at %s: %d tools" % (time.strftime("%H:%M:%S"), len(names)))
        except Exception as e:
            say("MCP TOOL LIST read failed: %r" % (e,))
        # 1. T0
        pap, ok = load(ctl, "T0")
        if not ok:
            raise RuntimeError("T0 load failed")
        s = probe(ctl, "SlotsProbe", [], "SLOTSPROBE", "T0 slots")
        verdict("T0_slot_clean", bool(s) and not re.search(r"state=[1-9]", s), s[-160:])
        r = probe(ctl, "ReserveProbe", [], "RESERVEPROBE", "reservation")
        m = re.search(r"age=(-?[\d.]+) find=(-?\d+) skipped=(\w+) afterRelease=(-?[\d.]+)", r)
        verdict("S2_reservation", bool(m) and float(m.group(1)) >= 0 and m.group(3).lower() == "true"
                and float(m.group(4)) == -1.0, r[-120:])
        for l in lines(pap.read(), "IEB_FASTTICK"):
            say("T0 " + l)
        # 2. errand, save mid-errand
        if not start_errand(ctl):
            raise RuntimeError("no TAKE on T0 (case invalid)")
        time.sleep(15)
        probe(ctl, "SlotsProbe", [], "SLOTSPROBE", "travelling slots")
        h = probe(ctl, "HeldProbe", [F1], "HELDPROBE", "before save (RV-72 c, save side)")
        verdict("type_before_save", (held_type(h) or "").lower() == "travel", h[-200:])
        saved_mid = game.save(ctl, "IEB_RV72_mid")
        verdict("save_mid", saved_mid)
        # 3. teardown at save
        # 00:09 run: waiting for the DASHCANCEL line (~1 s) + the save call let ClearSlot finish before the save; send
        # both back to back so the save lands inside the teardown (IEB_LOADKEYS on the td load then shows fac=False)
        ctl.ctl("DashCancel", [F1], sync=False)
        saved_td = game.save(ctl, "IEB_RV72_td")
        verdict("save_td", saved_td)
        dec, _ = watch_decisions(30)
        verdict("td_no_decision", not dec, "; ".join(dec))
        probe(ctl, "SlotsProbe", [], "SLOTSPROBE", "after teardown")
        errs["session T0"] = errors(pap.read())
        # 4. load the mid-errand save
        if saved_mid:
            pap, ok = load(ctl, "IEB_RV72_mid")
            if ok:
                h0 = probe(ctl, "HeldProbe", [F1], "HELDPROBE", "mid right after load")
                time.sleep(10)
                h1 = probe(ctl, "HeldProbe", [F1], "HELDPROBE", "mid +10 s")
                text = pap.read()
                for l in lines(text, r"IEB_LOADKEYS|TASKTYPE_RESTORED|TYPE_FALLBACK"):
                    say("  " + l)
                verdict("type_after_load", (held_type(h1) or "").lower() == "travel",
                        "at load: %s; +10 s: %s" % (held_type(h0), held_type(h1)))
                if not block.ie_test_settings(ctl):      # RV-123 (3): SkipProbe read-back
                    verdict("ie_settings_after_load", None, "IE test settings not verified")
                t = game.Tail(game.LOGS["papyrus"])
                if "Jenassa arrived at" in text or t.wait(r"IntelEngine: Jenassa arrived at[^\r\n]*", 600):
                    time.sleep(5)
                    probe(ctl, "HeldProbe", [F1], "HELDPROBE", "mid after arrival")
                    t2 = game.Tail(game.LOGS["papyrus"])
                    ctl.ctl("NFFDismiss", [F1], sync=False)
                    d = t2.wait(r"\[IEB\] NFF_DISMISSED actor=Jenassa[^\r\n]*", 30)
                    rel = t2.wait(r"\[IEB\] (RELEASE\w*|DEFER\w*|CMD_FOLLOW)[^\r\n]*Jenassa[^\r\n]*", 90)
                    verdict("waiting_dismissal_after_load", bool(d) and bool(rel) and "RELEASE" in rel.group(0),
                            "%s | %s" % (d.group(0) if d else "no NFF_DISMISSED", rel.group(0) if rel else "nothing in 90 s"))
                else:
                    verdict("waiting_dismissal_after_load", None, "no arrival in 600 s")
                errs["session mid#1"] = errors(pap.read())
            # 5. dashboard cancel mid-errand after a load
            pap, ok = load(ctl, "IEB_RV72_mid")
            if ok:
                if not block.ie_test_settings(ctl):      # RV-123 (3): SkipProbe read-back
                    verdict("ie_settings_after_load", None, "IE test settings not verified")
                time.sleep(15)
                h = probe(ctl, "HeldProbe", [F1], "HELDPROBE", "mid#2 before cancel")
                if " slot=-1" in h:
                    verdict("dashcancel_no_decision", None, "no slot before the cancel (arrived/ended during settle)")
                else:
                    probe(ctl, "DashCancel", [F1], "DASHCANCEL", "dashboard cancel mid-errand")
                    dec, _ = watch_decisions(30)
                    verdict("dashcancel_no_decision", not dec, "; ".join(dec))
                s = probe(ctl, "SlotsProbe", [], "SLOTSPROBE", "after dashboard cancel")
                verdict("dashcancel_slots_clean", bool(s) and not re.search(r"state=[1-9]", s), s[-160:])
                errs["session mid#2"] = errors(pap.read())
        # 6. load the teardown save
        if saved_td:
            pap, ok = load(ctl, "IEB_RV72_td")
            if ok:
                time.sleep(15)
                text = pap.read()
                keys = lines(text, r"IEB_LOADKEYS|TASKTYPE_RESTORED")
                for l in keys:
                    say("  " + l)
                jen_restored = any("TASKTYPE_RESTORED" in l and "Jenassa" in l for l in keys)
                s = probe(ctl, "SlotsProbe", [], "SLOTSPROBE", "td after load")
                # REVIEW_LOG RV-76 (2): only counts if the slot was still active in the save (a LOADKEYS line for her);
                # zero lines = the teardown finished before the save = vacuous
                jen_keys = [l for l in keys if "IEB_LOADKEYS" in l and "000E1BA9" in l.upper()]
                if not jen_keys:
                    verdict("td_load_no_restore", None, "no IEB_LOADKEYS for her: teardown finished before the save")
                else:
                    verdict("td_load_no_restore", not jen_restored and all("fac=FALSE" in l.upper() for l in jen_keys),
                            "; ".join(jen_keys))
                verdict("td_load_slots_clean", bool(s) and not re.search(r"state=[1-9]", s), s[-160:])
                errs["session td"] = errors(text + pap.read())
        game.archive_logs("end")
    except Exception as e:
        say("ERROR %s" % e)
        verdict("run", False, str(e))
    finally:
        game.close(None, timeout=60, force=True)
    for k, v in errs.items():
        say("array errors %s (overlapping tails, indicative): %d" % (k, v))
    # REVIEW_LOG RV-76 (5): the total comes from the archived session logs (no double count across tails)
    lf = game.log_findings()
    say("log findings: %s" % lf)
    verdict("array_errors_zero", lf.get("array_errors") == 0 if lf.get("sessions") else None,
            "total %s" % lf.get("array_errors"))
    verdict("no_blank_key_on_load", lf.get("blank_key_loadkeys") == 0 if lf.get("sessions") else None,
            "blank-key LOADKEYS %s, TASKTYPE_RESTORED %s" % (lf.get("blank_key_loadkeys"), lf.get("tasktype_restored")))
    if os.path.exists(game.POOLGATE_FLAG):
        say("POOLGATE TRIPPED: " + open(game.POOLGATE_FLAG).read().strip())
    try:
        for l in open(OUT + "mem_sampler.log", encoding="utf-8"):
            if l[:19] >= t_start and ("POOL" in l or "POOLGATE" in l):
                say("  sampler: " + l.strip())
    except OSError:
        pass
    say("SUMMARY " + " | ".join(VERDICT))
    open(OUT + run_id + ".txt", "w", encoding="utf-8").write("\n".join(LOG) + "\n")
    say("RV72 DONE")


if __name__ == "__main__":
    main()
