"""REVIEW_LOG RV-213 (Shae 2026-10-12: "Make it so any logging in the future adds a reminder to end it").
One wrapper for every recording (WPR/xperf/logman trace, Procmon, a sampler, a watcher): no start without a size cap and
an auto-stop; each start writes a ledger entry (start, end-by, stop command, owner PID) and a detached watchdog ends it at
the deadline or the cap, whichever comes first. The Stop hook and game.launch / block start read the ledger.

  python rec.py start --name N --cap-mb MB --minutes M [--out FILE] [--owner-pid P] [--stop-cmd "..."] -- CMD ...
      CMD runs detached. Auto-stop = run --stop-cmd if given (wpr -stop / xperf -d / logman stop), else kill CMD's own PID
      (tree). The cap is checked on --out (required unless the CMD is wpr in memory mode, i.e. without -filemode).
  python rec.py stop ID          end one recording now (its stop command, then its own PID)
  python rec.py list             open entries, overdue marked
  python rec.py check            exit 1 if any entry is overdue or WPR records with no open entry (launch/block guard)
  python rec.py hook-stop        Stop hook: prints open/overdue entries (never blocks the turn)
  python rec.py hook-pretool     PreToolUse hook: reminds on raw recording starts (stdin = hook JSON; never blocks)
Never kills by image name. Ledger: C:/nolvus-research/test_runs/recordings_ledger.json."""
import json, os, re, subprocess, sys, time

LEDGER = "C:/nolvus-research/test_runs/recordings_ledger.json"
NOWIN = getattr(subprocess, "CREATE_NO_WINDOW", 0)
DETACH = 0x00000008 | 0x00000200          # DETACHED_PROCESS | CREATE_NEW_PROCESS_GROUP
MAX_MINUTES = 24 * 60
RAW_STARTS = [r"\bwpr(\.exe)?\s+-start\b", r"\bxperf(\.exe)?\s+-on\b", r"\blogman(\.exe)?\s+(start|create)\b",
              r"\bprocmon(64)?(\.exe)?\b", r"\btail\s+(-\S+\s+)*-F\b", r"\bmem_sampler\.py\b"]


def load():
    try:
        return json.load(open(LEDGER, encoding="utf-8"))
    except (OSError, ValueError):
        return []


def store(entries):
    tmp = LEDGER + ".tmp"
    json.dump(entries, open(tmp, "w", encoding="utf-8"), indent=1)
    os.replace(tmp, LEDGER)


def alive(pid):
    if not pid:
        return False
    out = subprocess.run(["tasklist", "/FI", "PID eq %d" % pid, "/NH"], capture_output=True, text=True,
                         creationflags=NOWIN).stdout
    return str(pid) in out


def is_open(e):
    return e.get("status") == "open"


def overdue(e, now=None):
    return is_open(e) and (now or time.time()) > e["end_by"] + 120


def wpr_recording():
    try:
        out = subprocess.run(["wpr", "-status"], capture_output=True, text=True, creationflags=NOWIN, timeout=30).stdout
    except Exception:
        return False
    return bool(out.strip()) and "not recording" not in out.lower()


def fmt(e):
    left = (e["end_by"] - time.time()) / 60
    return "%s %-18s owner=%s pid=%s cap=%sMB end_by=%s (%s) stop=%s" % (
        e["id"], e["name"], e.get("owner_pid"), e.get("pid"), e["cap_mb"],
        time.strftime("%m-%d %H:%M", time.localtime(e["end_by"])),
        "OVERDUE" if overdue(e) else "%.0f min left" % left, e.get("stop_cmd") or "kill own PID")


def end(e, why):
    if e.get("stop_cmd"):
        subprocess.run(e["stop_cmd"], shell=True, capture_output=True, creationflags=NOWIN, timeout=600)
    if alive(e.get("pid")):
        subprocess.run(["taskkill", "/PID", str(e["pid"]), "/T", "/F"], capture_output=True, creationflags=NOWIN)
    entries = load()
    for x in entries:
        if x["id"] == e["id"]:
            x.update(status="ended", ended=time.time(), ended_why=why)
    store(entries)


def start(a):
    if "--" not in a:
        sys.exit("rec start: give the command after --")
    opts, cmd = a[:a.index("--")], a[a.index("--") + 1:]
    o = {k: opts[i + 1] for i, k in enumerate(opts) if k.startswith("--") and i + 1 < len(opts)}
    if not cmd or "--name" not in o or "--cap-mb" not in o or "--minutes" not in o:
        sys.exit("rec start REFUSED: --name, --cap-mb and --minutes (the auto-stop) are required")
    cap, mins = float(o["--cap-mb"]), float(o["--minutes"])
    if cap <= 0 or not 0 < mins <= MAX_MINUTES:
        sys.exit("rec start REFUSED: cap must be > 0 and minutes in (0, %d]" % MAX_MINUTES)
    is_wpr = os.path.basename(cmd[0]).lower().startswith("wpr")
    if is_wpr and any(x.lower() == "-filemode" for x in cmd):
        sys.exit("rec start REFUSED: WPR -filemode has no size bound (the disk-full night); use memory mode")
    if not is_wpr and "--out" not in o:
        sys.exit("rec start REFUSED: --out FILE is required so the size cap can be enforced")
    if is_wpr and "--stop-cmd" not in o:
        sys.exit("rec start REFUSED: WPR needs --stop-cmd \"wpr -stop <file.etl>\"")
    eid = time.strftime("R%m%d-%H%M%S")
    p = subprocess.Popen(cmd, creationflags=DETACH, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    e = {"id": eid, "name": o["--name"], "cmd": cmd, "out": o.get("--out"), "cap_mb": cap, "start": time.time(),
         "end_by": time.time() + mins * 60, "stop_cmd": o.get("--stop-cmd"), "pid": None if is_wpr else p.pid,
         "owner_pid": int(o.get("--owner-pid", os.getppid())), "status": "open"}
    store(load() + [e])
    w = subprocess.Popen([sys.executable, os.path.abspath(__file__), "watchdog", eid], creationflags=DETACH,
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    entries = load()
    for x in entries:
        if x["id"] == eid:
            x["watchdog_pid"] = w.pid
    store(entries)
    print("rec started", fmt(e))


def watchdog(eid):
    while True:
        e = next((x for x in load() if x["id"] == eid), None)
        if not e or not is_open(e):
            return
        if time.time() >= e["end_by"]:
            return end(e, "deadline")
        if e.get("out") and os.path.exists(e["out"]) and os.path.getsize(e["out"]) >= e["cap_mb"] * 2 ** 20:
            return end(e, "size cap")
        if e.get("pid") and not alive(e["pid"]):
            entries = load()
            for x in entries:
                if x["id"] == eid:
                    x.update(status="ended", ended=time.time(), ended_why="process exited")
            store(entries)
            return
        time.sleep(10)


def check():
    bad = [fmt(e) for e in load() if overdue(e)]
    if wpr_recording() and not any(is_open(e) and os.path.basename(e["cmd"][0]).lower().startswith("wpr") for e in load()):
        bad.append("WPR is recording with no ledger entry (wpr -status)")
    return bad


def hook_pretool():
    try:
        h = json.load(sys.stdin)
    except ValueError:
        return
    tool, ti = h.get("tool_name", ""), h.get("tool_input", {}) or {}
    text = " ".join(str(ti.get(k, "")) for k in ("command", "description"))
    if tool == "Monitor" or (any(re.search(p, text, re.I) for p in RAW_STARTS) and "rec.py" not in text):
        msg = ("RV-213 reminder (Shae): this starts a recording/watcher. Start it through build/tools/rec.py (size cap + "
               "auto-stop + ledger), or register it there and plan its end now.")
        print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse", "additionalContext": msg},
                          "systemMessage": msg}))


def hook_stop():
    ents = [e for e in load() if is_open(e)]
    try:
        unreg = wpr_recording() and not any(os.path.basename(e["cmd"][0]).lower().startswith("wpr") for e in ents)
    except Exception:
        unreg = False
    if ents or unreg:
        lines = [fmt(e) for e in ents] + (["WPR is recording with NO ledger entry"] if unreg else [])
        print(json.dumps({"systemMessage": "RV-213 open recordings (end or confirm each):\n" + "\n".join(lines)}))


if __name__ == "__main__":
    a = sys.argv[1:]
    if not a:
        sys.exit(__doc__)
    if a[0] == "start":
        start(a[1:])
    elif a[0] == "watchdog":
        watchdog(a[1])
    elif a[0] == "stop":
        e = next((x for x in load() if x["id"] == a[1] and is_open(x)), None)
        sys.exit(end(e, "manual") if e else "no open entry %s" % a[1])
    elif a[0] == "list":
        for e in load():
            if is_open(e):
                print(fmt(e))
    elif a[0] == "check":
        bad = check()
        for b in bad:
            print("REC CHECK:", b)
        sys.exit(1 if bad else 0)
    elif a[0] == "hook-pretool":
        hook_pretool()
    elif a[0] == "hook-stop":
        hook_stop()
    else:
        sys.exit(__doc__)
