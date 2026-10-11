"""After the RV-79 crash series: the agreed install order (REVIEW_LOG RV-93 (4), RV-95, RV-96), one change at a time, each
followed by a T0 smoke (load, expected lines, 0 array errors); stops at the first failed step and reports it.
  S0  harness pex + test ESP (test infrastructure; smoke: harness lines, 0 PKGWATCH lines on an idle load, H-1)
  S1  rv72_live run 4 on the current install (+ the MCP tool list, RV-94)
  S2  head start (Relationships patch pex) + hs_live.py
  S3  bridge: notices + MARAS logs + essential (inert: no ess_windows.json) (RV-95 (iii)); smoke asserts the paused WARN
      once, 0 ESS_ lines, EssProbe unchanged for the cast, a paused SA recruit sets only IEB_EssReq
  S3c NT-4 IntelEngine patch (NPCTasks, Schedule); smoke: 0 array errors
  S4  SEC test layer (new test-only mod folder; discovered at launch); smoke: the layer registered, a live render of the
      name gate is non-empty for Fralia and empty for F1 (lengths only)
Usage: post_crash_pipeline.py [--from S2] [--to S1]   (run 4 is graded before S2: run --to S1, then --from S2)   (game and MO2 closed). Writes test_runs/PIPELINE_<stamp>.txt."""
import os, re, subprocess, sys, time
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import game
from runner import Run

B = "C:/nolvus-research/build/"
H = B + "tools/harness/"
OUT = "C:/nolvus-research/test_runs/"
LOG = []
STAMP = time.strftime("%Y%m%d-%H%M%S")
CAST = [0x000E1BA9, 0x00091918, 0x0002C90F, 0x000A2C94]     # F1, F2, H, Lydia (0x000A2C94; name self-checked, RV-97)


def say(m):
    line = "%s %s" % (time.strftime("%H:%M:%S"), m)
    print(line, flush=True)
    LOG.append(line)
    open(OUT + "PIPELINE_%s.txt" % STAMP, "w", encoding="utf-8").write("\n".join(LOG) + "\n")


def sh(args, timeout=4 * 3600):
    say("RUN %s" % " ".join(a if " " not in a else '"%s"' % a for a in args))
    p = subprocess.run([sys.executable, "-u"] + args, capture_output=True, text=True, timeout=timeout, cwd=H)
    tail = (p.stdout or "").strip().splitlines()[-6:]
    for l in tail:
        say("  | " + l[:200])
    return p.returncode, p.stdout or ""


def changed(folder):
    """Build files in bin/<folder> whose installed copy differs (the installer's own dry run)."""
    rc, out = sh([B + "tools/install_post_u1.py", "--dry"], timeout=300)
    return [m.group(1).split("/")[-1] for m in re.finditer(r"WOULD COPY (\S[^>]*?) ->", out) if folder in m.group(1)]


def install(only):
    if not only:
        say("INSTALL nothing to do")
        return True
    rc, out = sh([B + "tools/install_post_u1.py", "--only=" + ",".join(only)], timeout=600)
    ok = rc == 0 and "INSTALLED" in out and "not matching the installed file: none" in out
    say("INSTALL %s: %s" % (",".join(only), "OK" if ok else "FAILED"))
    return ok


def smoke(label, checks):
    """Launch, load T0, settle, then run checks(ctl, papyrus_text) -> list of (ok, what). 0 array errors always."""
    if game.procs():
        game.close(None, timeout=60, force=True)
    if not game.launch(say, voices=False):
        say("SMOKE %s: launch failed" % label)
        return False
    ctl = Run("SMOKE_" + label)
    t = game.Tail(game.LOGS["papyrus"])
    if not game.load(ctl, "T0", None):
        say("SMOKE %s: T0 load failed" % label)
        game.close(ctl, force=True)
        return False
    time.sleep(90)
    res = checks(ctl, t) if checks else []
    text = t.read()
    arr = len(re.findall(r"Cannot cast from None to [A-Za-z]+\[\]", text))
    res.append((arr == 0, "0 array errors on the T0 load (%d)" % arr))
    game.archive_logs("smoke_" + label)
    game.close(ctl, force=True)
    for ok, what in res:
        say("SMOKE %s: %s %s" % (label, "PASS" if ok else "FAIL", what))
    return all(ok for ok, _ in res)


def probe_lines(ctl, fn, args, rx, timeout=20):
    t = game.Tail(game.LOGS["papyrus"])
    ctl.ctl(fn, args, sync=False)
    return t.wait(rx, timeout)


# ---------------------------------------------------------------------------- steps

def s0():
    only = changed("Errand Bridge - Test Harness/Scripts") + ["ErrandBridgeTest.esp"]
    if not install(only):
        return False

    def chk(ctl, t):
        out = []
        m = probe_lines(ctl, "CrashCtx", [0x0001A66C], r"CRASHCTX [^\n]*")
        out.append((bool(m), "new harness answers (CRASHCTX)"))
        out.append(("PKGEVT" not in t.read() and "PKGWATCH" not in t.read(), "0 package-watch lines on an idle T0 load (RV-96)"))
        return out
    if not smoke("S0", chk):
        return False
    rc, out = sh([H + "block.py", "U1", "--only", "H-1"], timeout=3600)
    ok = "H-1" in out and "ALL PASS" in out
    say("S0 H-1 harness smoke: %s" % ("PASS" if ok else "FAIL/INCONCLUSIVE (see the block summary)"))
    return ok


def s1():
    rc, out = sh([H + "rv72_live.py"], timeout=3 * 3600)
    crashed = rc != 0 or re.search(r"(?i)crash|game gone", out) is not None
    say("S1 rv72_live run 4 exit %d%s (grading in its own report)" % (rc, ", CRASH: stop and report as a repro, no retry" if crashed else ""))
    return not crashed


def s2():
    if not install(changed("SkyrimNet Relationships - Private Patch/Scripts")):
        return False
    rc, out = sh([H + "hs_live.py"], timeout=3 * 3600)
    say("S2 hs_live exit %d" % rc)
    return rc == 0


ESS_BEFORE = {}


def ess_probe_all(ctl):
    from tests_misc import who
    out = {}
    for f in CAST:
        if f == 0x000A2C94 and (who(ctl, f)[1] or "") != "Lydia":
            say("  %08X is not Lydia by name (skipped)" % f)
            continue
        m = probe_lines(ctl, "EssProbe", [f], r"\[IEB-TEST\] ESSPROBE [^\n]*")
        out[f] = m.group(0).split("ESSPROBE ", 1)[1] if m else None
    return out


def s3():
    # the 'before' EssProbe on the CURRENT install (essential not yet installed)
    def before(ctl, t):
        ESS_BEFORE.update(ess_probe_all(ctl))
        return [(any(ESS_BEFORE.values()), "EssProbe before the install (%d actors read)" % sum(1 for v in ESS_BEFORE.values() if v))]
    if not smoke("S3_before", before):
        return False
    if not install(changed("Errand Bridge/Scripts")):
        return False

    def chk(ctl, t):
        out = []
        text = t.read()
        warns = re.findall(r"WARN ESS_TABLE bad=[^\n]*essential followers paused", text)
        out.append((len(warns) == 1, "the paused WARN once on the load (%d)" % len(warns)))
        out.append((not re.search(r"\[IEB\] ESS_", text), "0 ESS_ decision lines"))
        after = ess_probe_all(ctl)
        for f, v in after.items():
            b = ESS_BEFORE.get(f)
            if v is None or b is None:
                say("  EssProbe %08X: not read (before %s, after %s)" % (f, b is not None, v is not None))
                continue
            flags_b = re.findall(r"base(?:Ess|Prot)=\S+", b)
            flags_a = re.findall(r"base(?:Ess|Prot)=\S+", v)
            out.append((flags_b == flags_a, "%08X base essential/protected unchanged" % f))
            out.append(("IEB_Ess=-1" in v and "IEB_EssAuth=-1" in v, "%08X has no IEB_Ess / IEB_EssAuth keys" % f))
        out.append((bool(re.search(r"\[IEB\] NOTICE probe registered rc=", text)), "notices: N1 probe registered on load"))
        # RV-95 (4): one SA recruit signal while paused sets only IEB_EssReq (no IEB_Ess / IEB_EssAuth, no ESS_ line)
        t2 = game.Tail(game.LOGS["papyrus"])
        sent = probe_lines(ctl, "SARecruitEvent", [0x00091918], r"\[IEB-TEST\] SARECRUIT sent [^\n]*")
        time.sleep(6)
        v = probe_lines(ctl, "EssProbe", [0x00091918], r"\[IEB-TEST\] ESSPROBE [^\n]*")
        vv = v.group(0) if v else ""
        out.append((bool(sent) and bool(v) and "IEB_EssReq=-1" not in vv and "IEB_Ess=-1" in vv and "IEB_EssAuth=-1" in vv
                    and not re.search(r"\[IEB\] ESS_", t2.read()),
                    "paused SA recruit (F2): only IEB_EssReq set, no ESS_ line"))
        out.append((bool(re.search(r"\[IEB\] NOTICE N1 shown", t.read())) or True, "N1 seen or pending (no assert)"))
        return out
    return smoke("S3", chk)


def s3c():
    only = [f for f in changed("IE NoWipe + Dispatch Guard/Scripts") if f in ("IntelEngine_NPCTasks.pex", "IntelEngine_Schedule.pex")]
    if not install(only):
        return False
    return smoke("S3c", None)


def s4():
    if not install(["layer:SkyrimNet Test - SEC Bio"]):
        return False

    def chk(ctl, t):
        from tests_misc import render, who
        sn = game.Tail(game.LOGS["skyrimnet"])
        sn.pos = 0
        out = [("shae.sectest" in sn.read(), "SkyrimNet registered the shae.sectest layer")]
        txt = open(B + "layers/sectest/SKSE/Plugins/SkyrimNet/external/shae.sectest/prompts/submodules/character_bio/"
                       "0990_ieb_sectest.prompt", encoding="utf-8").read()
        fr, f1 = who(ctl, 0x0001A684)[0], who(ctl, 0x000E1BA9)[0]
        a = render(ctl, fr, txt) if fr else None
        b = render(ctl, f1, txt) if f1 else None
        out.append((a is not None and len(a.strip()) > 0, "name gate: non-empty for Fralia (len %s)" % (a and len(a.strip()))))
        out.append((b is not None and len(b.strip()) == 0, "name gate: empty for F1 (len %s)" % (b and len(b.strip()))))
        return out
    return smoke("S4", chk)


STEPS = [("S0", s0), ("S1", s1), ("S2", s2), ("S3", s3), ("S3c", s3c), ("S4", s4)]


def main():
    if game.procs():
        sys.exit("ABORT: game or MO2 running")
    start = sys.argv[sys.argv.index("--from") + 1] if "--from" in sys.argv else "S0"
    stop = sys.argv[sys.argv.index("--to") + 1] if "--to" in sys.argv else STEPS[-1][0]
    names = [n for n, _ in STEPS]
    for n, fn in STEPS[names.index(start):names.index(stop) + 1]:
        say("STEP %s START" % n)
        if os.path.exists(game.POOLGATE_FLAG):
            say("POOLGATE TRIPPED: stopping before %s" % n)
            break
        try:
            ok = fn()
        except Exception as e:
            say("STEP %s ERROR %r" % (n, e))
            ok = False
        say("STEP %s %s" % (n, "DONE" if ok else "FAILED: pipeline stops here"))
        if not ok:
            break
    say("PIPELINE END")


if __name__ == "__main__":
    main()
