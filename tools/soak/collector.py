"""Soak host-side collector (spec §15.4; TASK_C step 9, one-week full-stack soak). READS ONLY: nothing under C:/Nolvus or
the user's Documents is written. Every --every seconds (default 120) appends one row to C:/nolvus-research/soak/
collector.csv, and records every daily soak save (SOAK_d*) it sees in saves.csv.

collector.csv: ts, papyrus_session, papyrus_suspended, papyrus_stackdump, papyrus_our_errors, sn_errors, sn_requests,
               sn_db_mb, ie_db_mb, skyrim_ws_mb, skyrim_private_mb, sys_commit_used_mb, sys_commit_limit_mb,
               tts_private_mb, texture_oom, teammate_was_off, dispatch_conflict, assert_fail, loads, ie_k1, ie_k2,
               ie_k3, ie_known_ok (K1 == K2 == loads and K3 == 7 per launch), ie_other (reportable)
saves.csv:     save, mtime, ess_mb, skse_mb   (one row per SOAK_dNN save, first time it is seen)
requests.csv:  ts, model, count            (cumulative LLM calls per model in the current SkyrimNet.log)

Counts are cumulative within the current log file (one game session); the scorer takes per-session maxima.
Our scripts for Papyrus errors: IEB_*, LUC_*, SNRom_* (patched Relationships). IntelEngine errors: the 3 known ones
counted exactly (K1-K3); any other is reportable (ie_other).
Usage: collector.py [--every 120] [--once]"""
import csv, glob, json, os, re, subprocess, sys, time

DOCS = os.path.expanduser("~/Documents/My Games/Skyrim Special Edition/")
PAPYRUS = DOCS + "Logs/Script/Papyrus.0.log"
WATCH = DOCS + "Logs/Script/User/ErrandBridgeWatch.0.log"
SKSE = DOCS + "SKSE/"
INST = "C:/Nolvus/Instances/Nolvus Awakening/MODS/"
SAVES = INST + "profiles/SkyrimNet Test/saves/"
DB_DIRS = [INST + "overwrite/SKSE/Plugins/", INST + "mods/SkyrimNet Test - Output/SKSE/Plugins/"]
OUT = "C:/nolvus-research/soak/"
OURS = re.compile(r"\b(IEB_|LUC_|SNRom_|IntelEngine_)\w*\.")
REQ = re.compile(r"Creating request payload for model: (\S+)")
# IntelEngine's own known errors (Shae, 2026-10-09: exact match, still counted, never silently skipped). Verified
# 2026-10-09: IntelEngine 3.5.1's shipped Core.pex does the same "cast None to Int[]" before "SlotStates == None"; the
# Schedule script is unpatched; K3 = the 7 natives IntelEngine's own (unpatched) native script declares but its DLL
# does not bind, logged once per launch in every Papyrus log on disk (2026-10-09). Expected per game load: K1 = 1,
# K2 = 1; per launch: K3 = 7. A different count, or any other IntelEngine error, is reportable (ie_other).
K3_NATIVES = ["BuildSafetyNetContextJson", "ClaimPendingDirectorParams", "GetLastConversationPartner", "GetSafetyNetNPC",
              "HasScheduleKeywords", "NotifyNewDialogue", "RunSafetyNetCheck"]
K3_LINES = ["error: Native static function %s could find no matching static function on linked type IntelEngine. "
            "Function will not be bound." % n for n in K3_NATIVES]
KNOWN = {
    "K1": ("Error: Cannot cast from None to Int[]",
           r'IntelEngine_Core.Maintenance() - "C:\nolvus-research\build\src\intelengine\Source\Scripts\IntelEngine_Core.psc" Line 210'),
    "K2": ("Error: Cannot cast from None to Actor[]",
           r'IntelEngine_Schedule.RestartMonitoring() - "IntelEngine_Schedule.psc" Line 77'),
}


def size_mb(paths):
    return round(sum(os.path.getsize(p) for p in paths if os.path.exists(p)) / 1048576.0, 3)


def newest(pattern_list):
    files = [f for pat in pattern_list for f in glob.glob(pat)]
    return max(files, key=os.path.getmtime) if files else None


def papyrus_counts():
    """Returns session, suspended, stack dumps, our errors (IEB_/LUC_/SNRom_), known IntelEngine counts {K1,K2,K3},
    other IntelEngine errors."""
    known = {"K1": 0, "K2": 0, "K3": 0}
    if not os.path.exists(PAPYRUS):
        return "", 0, 0, 0, known, 0
    lines = open(PAPYRUS, encoding="utf-8", errors="replace").read().splitlines()
    session = lines[0][:40] if lines else ""
    susp = sum("Suspended stack count is over our warning threshold" in l for l in lines)
    dumps = sum("Stack dump" in l or "Dumping stack" in l for l in lines)
    ours = ie_other = 0
    for i, l in enumerate(lines):
        low = l.lower()
        if "error:" not in low or "ieb_bld4probe" in low:
            continue
        frames = [l]                          # the error line plus its own stack frames only (not unrelated next lines)
        j = i + 1
        while j < len(lines) and j <= i + 6 and (lines[j].startswith("stack:") or lines[j].startswith("	")):
            frames.append(lines[j])
            j += 1
        ctx = " ".join(frames)
        hit = None
        for k, (msg, frame) in KNOWN.items():
            if l.endswith(msg) and i + 2 < len(lines) and lines[i + 2].strip().endswith(frame):
                hit = k
        if hit is None and any(l.endswith(x) for x in K3_LINES):
            hit = "K3"
        if hit:
            known[hit] += 1
        elif re.search(r"\b(IEB_|LUC_|SNRom_)\w*\.", ctx):
            ours += 1
        elif "IntelEngine" in ctx:
            ie_other += 1
    return session, susp, dumps, ours, known, ie_other


def load_count():
    p = SKSE + "SkyrimNet.log"
    if not os.path.exists(p):
        return 0
    return sum("PreLoadGame event received" in l for l in open(p, encoding="utf-8", errors="replace"))


def skyrimnet_counts():
    p = SKSE + "SkyrimNet.log"
    if not os.path.exists(p):
        return 0, 0, {}
    errs, by_model = 0, {}
    for l in open(p, encoding="utf-8", errors="replace"):
        if "] [error] [" in l:
            errs += 1
        m = REQ.search(l)
        if m:
            by_model[m.group(1).rstrip(",")] = by_model.get(m.group(1).rstrip(","), 0) + 1
    return errs, sum(by_model.values()), by_model


def bridge_counts():
    """SK-2: the bridge's own warnings (IEB_Main logs to Papyrus with [IEB]) and the watcher's assertion failures."""
    tw = dc = 0
    if os.path.exists(PAPYRUS):
        for l in open(PAPYRUS, encoding="utf-8", errors="replace"):
            if "[IEB] TEAMMATE_WAS_OFF" in l:
                tw += 1
            elif "[IEB] DISPATCH_CONFLICT" in l:
                dc += 1
    af = 0
    if os.path.exists(WATCH):
        af = sum("ASSERT FAIL" in l for l in open(WATCH, encoding="utf-8", errors="replace"))
    return tw, dc, af


def texture_oom():
    p = SKSE + "EngineFixes.log"
    if not os.path.exists(p):
        return 0
    return sum("texture load failed due to out of memory" in l for l in open(p, encoding="utf-8", errors="replace"))


def memory():
    ps = (
        "$s=Get-Process SkyrimSE -ErrorAction SilentlyContinue | Select-Object -First 1;"
        "$o=Get-CimInstance Win32_OperatingSystem;"
        "$t=Get-CimInstance Win32_Process -Filter \"Name='python.exe'\" | Where-Object { $_.CommandLine -match 'turbo|chatterbox' } | Select-Object -First 1;"
        "$tp=0; if ($t) { $tp=(Get-Process -Id $t.ProcessId).PrivateMemorySize64 };"
        "[pscustomobject]@{ws=($s.WorkingSet64); priv=($s.PrivateMemorySize64);"
        "limit=$o.TotalVirtualMemorySize*1KB; free=$o.FreeVirtualMemory*1KB; tts=$tp} | ConvertTo-Json -Compress")
    try:
        r = subprocess.run(["powershell", "-NoProfile", "-Command", ps], capture_output=True, text=True, timeout=60)
        d = json.loads(r.stdout.strip() or "{}")
    except Exception:
        d = {}
    mb = lambda v: round((v or 0) / 1048576.0, 1)
    limit, free = d.get("limit") or 0, d.get("free") or 0
    return mb(d.get("ws")), mb(d.get("priv")), mb(limit - free), mb(limit), mb(d.get("tts"))


def append(name, header, row):
    os.makedirs(OUT, exist_ok=True)
    p = OUT + name
    new = not os.path.exists(p)
    with open(p, "a", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        if new:
            w.writerow(header)
        w.writerow(row)


def seen_saves():
    p = OUT + "saves.csv"
    if not os.path.exists(p):
        return set()
    return {r["save"] for r in csv.DictReader(open(p, encoding="utf-8"))}


def sample():
    ts = time.strftime("%Y-%m-%d %H:%M:%S")
    session, susp, dumps, ours, known, ie_other = papyrus_counts()
    loads = load_count()
    ie_known_ok = int(known["K1"] == loads and known["K2"] == loads and known["K3"] == len(K3_NATIVES))
    errs, reqs, by_model = skyrimnet_counts()
    sn_db = newest([d + "SkyrimNet/data/SkyrimNet-*.db" for d in DB_DIRS])
    ie_db = newest([d + "IntelEngine/data/IntelEngine-*.db" for d in DB_DIRS])
    ws, priv, used, limit, tts = memory()
    append("collector.csv",
           ["ts", "papyrus_session", "papyrus_suspended", "papyrus_stackdump", "papyrus_our_errors", "sn_errors",
            "sn_requests", "sn_db_mb", "ie_db_mb", "skyrim_ws_mb", "skyrim_private_mb", "sys_commit_used_mb",
            "sys_commit_limit_mb", "tts_private_mb", "texture_oom", "teammate_was_off", "dispatch_conflict",
            "assert_fail", "loads", "ie_k1", "ie_k2", "ie_k3", "ie_known_ok", "ie_other"],
           [ts, session, susp, dumps, ours, errs, reqs,
            size_mb([sn_db, sn_db + "-wal"]) if sn_db else 0, size_mb([ie_db, ie_db + "-wal"]) if ie_db else 0,
            ws, priv, used, limit, tts, texture_oom()] + list(bridge_counts()) +
           [loads, known["K1"], known["K2"], known["K3"], ie_known_ok, ie_other])
    for model, n in by_model.items():
        append("requests.csv", ["ts", "model", "count"], [ts, model, n])
    have = seen_saves()
    for ess in sorted(glob.glob(SAVES + "SOAK_d*.ess")):
        name = os.path.basename(ess)[:-4]
        if name not in have:
            append("saves.csv", ["save", "mtime", "ess_mb", "skse_mb"],
                   [name, time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(os.path.getmtime(ess))),
                    size_mb([ess]), size_mb([ess[:-4] + ".skse"])])
    print("%s sample: suspended=%d ours=%d ie_known=%s/%d loads ok=%d ie_other=%d sn_err=%d req=%d ws=%.0fMB commit=%.0f/%.0fMB"
          % (ts, susp, ours, known, loads, ie_known_ok, ie_other, errs, reqs, ws, used, limit))


if __name__ == "__main__":
    every = int(sys.argv[sys.argv.index("--every") + 1]) if "--every" in sys.argv else 120
    if "--once" in sys.argv:
        sample()
    else:
        while True:
            sample()
            time.sleep(every)
