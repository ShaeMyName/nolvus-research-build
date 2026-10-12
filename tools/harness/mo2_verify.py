"""RV-208 option B, step 3 (Shae 2026-10-12): verify the rebuilt ModOrganizer.ini on the TEST profile only.
Launch (no voices) to the main menu, compare skse64.log's plugin lines with the last good session's copy and the
plugin count with crash #8's PLUGINS list (+ the 5 ESL-flagged .esp it omits), run FormModProbe on the 5 + 0xCF001957,
close, then read the ini and both profiles' list hashes back. Counts and FormIDs only."""
import hashlib, json, os, re, shutil, sys, time
import game
from mcp_client import MCP

OUT = "C:/nolvus-research/test_runs/mo2_verify_%s/" % time.strftime("%Y%m%d-%H%M%S")
SKSE = game.DOCS + "SKSE/"
CRASH8 = SKSE + "crash-2026-10-12-04-56-56.log"
REF = "C:/nolvus-research/backups/mo2_rebuild/skse64_before.log"     # the 00:58 session (crash #8's), copied pre-launch
HASHES = "C:/nolvus-research/backups/mo2_rebuild/profile_hashes_before.json"
PROBE_IDS = [int(x, 16) for x in sys.argv[1:]]                      # FormIDs (hex) to FormModProbe


def log(*a):
    s = " ".join(str(x) for x in a)
    print(s, flush=True)
    open(OUT + "verify.log", "a", encoding="utf-8").write(s + "\n")


def plugin_lines(p):
    """skse64.log 'plugin <path> (...) loaded correctly' style lines, reduced to the DLL file name + status word."""
    out = set()
    for ln in open(p, encoding="utf-8", errors="replace"):
        m = re.search(r"plugin\s+(.+?\.dll)\s*\((.*)", ln, re.I)
        if m:
            out.add((os.path.basename(m.group(1)).lower(), "loaded correctly" in ln.lower()))
    return out


def crash_plugin_count(p):
    n, on = 0, False
    for ln in open(p, encoding="utf-8", errors="replace"):
        if ln.startswith("PLUGINS:"):
            on = True
            continue
        if on:
            if not ln.strip() or not ln.startswith("\t"):
                if n:
                    break
                continue
            n += 1
    return n


def main():
    os.makedirs(OUT, exist_ok=True)
    game.set_archive(os.path.basename(OUT.rstrip("/")))
    ok, why = game.mo2_config_ok()
    log("MO2 ini guard:", ok, why)
    if not ok:
        return 1
    if not game.launch(log, voices=False):
        log("VERIFY FAIL: launch")
        return 1
    time.sleep(30)
    shutil.copy2(SKSE + "skse64.log", OUT + "skse64_after.log")
    before, after = plugin_lines(REF), plugin_lines(OUT + "skse64_after.log")
    log("SKSE plugin lines: before=%d after=%d same=%s" % (len(before), len(after), before == after))
    for d in sorted(before - after):
        log("  only before:", d)
    for d in sorted(after - before):
        log("  only after:", d)
    log("crash #8 PLUGINS entries: %d (+5 ESL-flagged .esp omitted by Crash Logger)" % crash_plugin_count(CRASH8))
    try:
        r = MCP().request("tools/call", {"name": "execute_console_command",
                                          "arguments": {"command": "GetNumLoadedMods"}}, timeout=20)
        log("console GetNumLoadedMods:", json.dumps(r)[:400])
    except Exception as e:
        log("console GetNumLoadedMods failed:", type(e).__name__)
    pap = game.DOCS + "Logs/Script/Papyrus.0.log"
    size = os.path.getsize(pap) if os.path.exists(pap) else 0
    for fid in PROBE_IDS:
        try:
            MCP().request("tools/call", {"name": "execute_quest_function", "arguments": {
                "quest_editor_id": "IEB_TestQuest", "script_name": "IEB_TestCtl", "function_name": "FormModProbe",
                "arguments": [fid if fid < 2 ** 31 else fid - 2 ** 32]}}, timeout=20)
        except Exception as e:
            log("FormModProbe %08X call failed: %s" % (fid, type(e).__name__))
    time.sleep(8)
    if os.path.exists(pap):
        with open(pap, encoding="utf-8", errors="replace") as f:
            f.seek(size)
            for ln in f:
                if "FORMMOD" in ln.upper():
                    log("  " + ln.strip())
    closed = game.close(force=False)
    log("CLOSE:", closed, "running now:", sorted(game.procs()))
    t0 = time.time()
    while game.procs() and time.time() - t0 < 120:
        time.sleep(3)
    ini = open(game.MO2_INI, "rb").read()
    sel = re.search(rb"selected_profile=([^\r\n]*)", ini)
    log("ini after exit: %d bytes, gameName %s, selected_profile=%s, CRLF %d, LF %d" % (
        len(ini), b"gameName=" in ini, sel.group(1).decode(errors="replace") if sel else None,
        ini.count(b"\r\n"), ini.count(b"\n")))
    ref = json.load(open(HASHES))
    prof = "C:/Nolvus/Instances/Nolvus Awakening/MODS/profiles/"
    for k, v in ref.items():
        h = hashlib.sha256(open(prof + k, "rb").read()).hexdigest()
        log("  %s %s" % (k, "unchanged" if h == v[1] else "CHANGED"))
    return 0


if __name__ == "__main__":
    sys.exit(main())
