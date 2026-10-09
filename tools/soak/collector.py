"""Soak host-side collector (spec §15.4; TASK_C step 9, one-week full-stack soak). READS ONLY: nothing under C:/Nolvus or
the user's Documents is written. Every --every seconds (default 120) appends one row to C:/nolvus-research/soak/
collector.csv, and records every daily soak save (SOAK_d*) it sees in saves.csv.

collector.csv: ts, papyrus_session, papyrus_suspended, papyrus_stackdump, papyrus_our_errors, sn_errors, sn_requests,
               sn_db_mb, ie_db_mb, skyrim_ws_mb, skyrim_private_mb, sys_commit_used_mb, sys_commit_limit_mb,
               tts_private_mb, texture_oom
saves.csv:     save, mtime, ess_mb, skse_mb   (one row per SOAK_dNN save, first time it is seen)
requests.csv:  ts, model, count            (cumulative LLM calls per model in the current SkyrimNet.log)

Counts are cumulative within the current log file (one game session); the scorer takes per-session maxima.
Our scripts for Papyrus errors: IEB_*, LUC_*, SNRom_* (patched Relationships), IntelEngine_* (patched).
Usage: collector.py [--every 120] [--once]"""
import csv, glob, json, os, re, subprocess, sys, time

DOCS = os.path.expanduser("~/Documents/My Games/Skyrim Special Edition/")
PAPYRUS = DOCS + "Logs/Script/Papyrus.0.log"
SKSE = DOCS + "SKSE/"
INST = "C:/Nolvus/Instances/Nolvus Awakening/MODS/"
SAVES = INST + "profiles/SkyrimNet Test/saves/"
DB_DIRS = [INST + "overwrite/SKSE/Plugins/", INST + "mods/SkyrimNet Test - Output/SKSE/Plugins/"]
OUT = "C:/nolvus-research/soak/"
OURS = re.compile(r"\b(IEB_|LUC_|SNRom_|IntelEngine_)\w*\.")
REQ = re.compile(r"Creating request payload for model: (\S+)")
# Known stock errors (not ours; verified 2026-10-09 by disassembling IntelEngine 3.5.1's shipped Core.pex: the same
# "cast None to Int[]" before "SlotStates == None"): logged on every load by IntelEngine itself.
STOCK = [("Cannot cast from None to Int[]", "IntelEngine_Core.Maintenance"),
         ("Cannot cast from None to Actor[]", "IntelEngine_Schedule.RestartMonitoring")]


def size_mb(paths):
    return round(sum(os.path.getsize(p) for p in paths if os.path.exists(p)) / 1048576.0, 3)


def newest(pattern_list):
    files = [f for pat in pattern_list for f in glob.glob(pat)]
    return max(files, key=os.path.getmtime) if files else None


def papyrus_counts():
    if not os.path.exists(PAPYRUS):
        return "", 0, 0, 0
    lines = open(PAPYRUS, encoding="utf-8", errors="replace").read().splitlines()
    session = lines[0][:40] if lines else ""
    susp = sum("Suspended stack count is over our warning threshold" in l for l in lines)
    dumps = sum("Stack dump" in l or "Dumping stack" in l for l in lines)
    ours = 0
    for i, l in enumerate(lines):
        if "Error:" in l and "ieb_bld4probe" not in l.lower():
            ctx = " ".join(lines[i:i + 4])
            if any(a in l and b in ctx for a, b in STOCK):
                continue
            if OURS.search(ctx):
                ours += 1
    return session, susp, dumps, ours


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
    session, susp, dumps, ours = papyrus_counts()
    errs, reqs, by_model = skyrimnet_counts()
    sn_db = newest([d + "SkyrimNet/data/SkyrimNet-*.db" for d in DB_DIRS])
    ie_db = newest([d + "IntelEngine/data/IntelEngine-*.db" for d in DB_DIRS])
    ws, priv, used, limit, tts = memory()
    append("collector.csv",
           ["ts", "papyrus_session", "papyrus_suspended", "papyrus_stackdump", "papyrus_our_errors", "sn_errors",
            "sn_requests", "sn_db_mb", "ie_db_mb", "skyrim_ws_mb", "skyrim_private_mb", "sys_commit_used_mb",
            "sys_commit_limit_mb", "tts_private_mb", "texture_oom"],
           [ts, session, susp, dumps, ours, errs, reqs,
            size_mb([sn_db, sn_db + "-wal"]) if sn_db else 0, size_mb([ie_db, ie_db + "-wal"]) if ie_db else 0,
            ws, priv, used, limit, tts, texture_oom()])
    for model, n in by_model.items():
        append("requests.csv", ["ts", "model", "count"], [ts, model, n])
    have = seen_saves()
    for ess in sorted(glob.glob(SAVES + "SOAK_d*.ess")):
        name = os.path.basename(ess)[:-4]
        if name not in have:
            append("saves.csv", ["save", "mtime", "ess_mb", "skse_mb"],
                   [name, time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(os.path.getmtime(ess))),
                    size_mb([ess]), size_mb([ess[:-4] + ".skse"])])
    print("%s sample: suspended=%d ours=%d sn_err=%d req=%d ws=%.0fMB commit=%.0f/%.0fMB" % (ts, susp, ours, errs, reqs, ws, used, limit))


if __name__ == "__main__":
    every = int(sys.argv[sys.argv.index("--every") + 1]) if "--every" in sys.argv else 120
    if "--once" in sys.argv:
        sample()
    else:
        while True:
            sample()
            time.sleep(every)
