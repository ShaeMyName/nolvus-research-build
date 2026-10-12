"""REVIEW_LOG RV-213 (Shae 2026-10-12: "Make it so any logging in the future adds a reminder to end it").
One wrapper for every recording (WPR/xperf/logman trace, Procmon, a sampler, a watcher): no start without a size cap and
an auto-stop; each start writes a ledger entry (start, end-by, stop command, owner PID) and a detached watchdog ends it at
the deadline or the cap, whichever comes first. The Stop hook and game.launch / block start read the ledger.

  python rec.py start --name N --cap-mb MB --minutes M [--out FILE] [--owner-pid P] [--stop-cmd "..."] -- CMD ...
      CMD runs detached. Auto-stop = run --stop-cmd if given, then kill CMD's own PID tree (PID + creation time checked,
      never by image name). The cap is checked on --out (required unless the CMD is an ETW controller).
      ETW controllers (wpr -start, xperf -on, logman start|create) return at once while the session keeps running:
      they need --stop-cmd (wpr -stop F / xperf -d F / logman stop S -ets) and are tracked by session, not PID.
      WPR -filemode is refused (no size bound: the disk-full night).
  python rec.py stop ID          end one recording now (its stop command, then its own PID)
  python rec.py list             open entries, overdue marked
  python rec.py check            exit 1 if an entry is overdue, or WPR / a non-system ETW session runs with no open
                                 ETW entry (launch/block guard)
  python rec.py hook-stop        Stop hook: blocks the turn end only on an overdue entry or an unledgered trace (once;
                                 honours stop_hook_active); open in-time entries are a notice
  python rec.py hook-pretool     PreToolUse hook: reminds on raw recording starts (stdin = hook JSON; never blocks)
Exempt: the memory guard mem_sampler.py (PID file test_runs/mem_sampler.pid) is the one permanent watcher; its own log
rotates above 5 MB. Monitor watchers: wrap the tail in `timeout 1800 ...` so it cannot outlive the Monitor.
Ledger: C:/nolvus-research/test_runs/recordings_ledger.json (lock: .lock beside it)."""
import json, os, re, subprocess, sys, time

LEDGER = "C:/nolvus-research/test_runs/recordings_ledger.json"
LOCK = LEDGER + ".lock"
NOWIN = getattr(subprocess, "CREATE_NO_WINDOW", 0)
DETACH = 0x00000008 | 0x00000200          # DETACHED_PROCESS | CREATE_NEW_PROCESS_GROUP
MAX_MINUTES = 24 * 60
ETW_SYSTEM = {"msdtc_trace_session"}      # running before any of ours (2026-10-12 baseline, non-elevated logman view)
RAW_STARTS = [r"\bwpr(\.exe)?\s+-start\b", r"\bxperf(\.exe)?\s+-on\b", r"\blogman(\.exe)?\s+(start|create)\b",
              r"\bprocmon(64)?(\.exe)?\b", r"\btail\b[^|;&]*\s-[A-Za-z]*[Ff]", r"\bGet-Content\b[^|;]*-Wait\b",
              r"\bmem_sampler\.py\b"]


def etw_kind(cmd):
    """'wpr' / 'xperf' / 'logman' when CMD starts an ETW session, else ''."""
    exe = os.path.basename(cmd[0]).lower().replace(".exe", "")
    low = [c.lower() for c in cmd[1:]]
    if exe == "wpr" and "-start" in low:
        return "wpr"
    if exe == "xperf" and "-on" in low:
        return "xperf"
    if exe == "logman" and low and low[0] in ("start", "create"):
        return "logman"
    return ""


def etw_session(cmd, kind):
    """The ETW session name CMD starts (logman start|create NAME; xperf -start NAME, else the kernel logger)."""
    low = [c.lower() for c in cmd]
    if kind == "logman" and len(cmd) > 2:
        return cmd[2]
    if kind == "xperf":
        return cmd[low.index("-start") + 1] if "-start" in low and low.index("-start") + 1 < len(cmd) else "NT Kernel Logger"
    return None


class Locked:
    def __enter__(self):
        t0 = time.time()
        while True:
            try:
                self.fd = os.open(LOCK, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
                return self
            except FileExistsError:
                if time.time() - t0 > 30:          # a crashed holder: take it over
                    try:
                        os.remove(LOCK)
                    except OSError:
                        pass
                    t0 = time.time()
                time.sleep(0.2)

    def __exit__(self, *a):
        os.close(self.fd)
        try:
            os.remove(LOCK)
        except OSError:
            pass


def load():
    try:
        return json.load(open(LEDGER, encoding="utf-8"))
    except (OSError, ValueError):
        return []


def store(entries):
    tmp = LEDGER + ".tmp"
    json.dump(entries, open(tmp, "w", encoding="utf-8"), indent=1)
    os.replace(tmp, LEDGER)


def update(eid=None, add=None, **fields):
    """Locked read-modify-write: append `add`, or set fields on entry eid."""
    with Locked():
        entries = load()
        if add:
            entries.append(add)
        for x in entries:
            if x["id"] == eid:
                x.update(fields)
        store(entries)


def ctime(pid):
    """Process creation time (CIM string) or '' when the PID is not running."""
    if not pid:
        return ""
    try:
        return subprocess.run(["powershell", "-NoProfile", "-Command",
                               "(Get-CimInstance Win32_Process -Filter 'ProcessId=%d').CreationDate.ToString('o')" % pid],
                              capture_output=True, text=True, creationflags=NOWIN, timeout=30).stdout.strip()
    except Exception:
        return ""


def same_proc(e):
    """REVIEW_LOG RV-213-rev (4): the PID is still the process we started (not a reused PID)."""
    c = ctime(e.get("pid"))
    return bool(c) and c == e.get("pid_ctime")


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


def etw_sessions():
    """Running ETW session names outside the system baseline (WPR's own sessions are covered by wpr_recording)."""
    try:
        out = subprocess.run(["logman", "query", "-ets"], capture_output=True, text=True, creationflags=NOWIN,
                             timeout=30).stdout
    except Exception:
        return []
    names = []
    for ln in out.splitlines():
        m = re.match(r"(\S.*?)\s{2,}Trace\s+Running", ln)
        if m and m.group(1).lower() not in ETW_SYSTEM and not m.group(1).upper().startswith("WPR_"):
            names.append(m.group(1))
    return names


def fmt(e):
    left = (e["end_by"] - time.time()) / 60
    return "%s %-18s owner=%s pid=%s cap=%sMB end_by=%s (%s) stop=%s" % (
        e["id"], e["name"], e.get("owner_pid"), e.get("pid") or e.get("etw") or "-", e["cap_mb"],
        time.strftime("%m-%d %H:%M", time.localtime(e["end_by"])),
        "OVERDUE" if overdue(e) else "%.0f min left" % left, e.get("stop_cmd") or "kill own PID")


def end(e, why):
    if e.get("stop_cmd"):
        subprocess.run(e["stop_cmd"], shell=True, capture_output=True, creationflags=NOWIN, timeout=600)
    if e.get("pid") and same_proc(e):
        subprocess.run(["taskkill", "/PID", str(e["pid"]), "/T", "/F"], capture_output=True, creationflags=NOWIN)
    update(e["id"], status="ended", ended=time.time(), ended_why=why)


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
    etw = etw_kind(cmd)
    if etw == "wpr" and any(x.lower() == "-filemode" for x in cmd):
        sys.exit("rec start REFUSED: WPR -filemode has no size bound (the disk-full night); use memory mode")
    if etw and "--stop-cmd" not in o:
        sys.exit("rec start REFUSED: %s starts an ETW session that outlives its PID; give --stop-cmd" % etw)
    if not etw and "--out" not in o:
        sys.exit("rec start REFUSED: --out FILE is required so the size cap can be enforced")
    eid = time.strftime("R%m%d-%H%M%S")
    p = subprocess.Popen(cmd, creationflags=DETACH, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    e = {"id": eid, "name": o["--name"], "cmd": cmd, "out": o.get("--out"), "cap_mb": cap, "start": time.time(),
         "end_by": time.time() + mins * 60, "stop_cmd": o.get("--stop-cmd"), "etw": etw or None,
         "etw_session": etw_session(cmd, etw),
         "pid": None if etw else p.pid, "pid_ctime": "" if etw else ctime(p.pid),
         "owner_pid": int(o.get("--owner-pid", os.getppid())), "status": "open"}
    update(add=e)
    w = subprocess.Popen([sys.executable, os.path.abspath(__file__), "watchdog", eid], creationflags=DETACH,
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    update(eid, watchdog_pid=w.pid)
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
        if e.get("pid") and not same_proc(e):
            update(eid, status="ended", ended=time.time(), ended_why="process exited")
            return
        time.sleep(10)


def unledgered():
    ents = [e for e in load() if is_open(e)]
    bad = []
    if wpr_recording() and not any(e.get("etw") == "wpr" for e in ents):
        bad.append("WPR is recording with no ledger entry (wpr -status)")
    known = {(e.get("etw_session") or "").lower() for e in ents if e.get("etw") in ("xperf", "logman")}
    bad += ["ETW session %r running with no ledger entry (logman query -ets)" % s for s in etw_sessions()
            if s.lower() not in known]     # RV-213-rev-close nit: matched by session name
    return bad


def check():
    return [fmt(e) for e in load() if overdue(e)] + unledgered()


def hook_pretool():
    try:
        h = json.load(sys.stdin)
    except ValueError:
        return
    tool, ti = h.get("tool_name", ""), h.get("tool_input", {}) or {}
    text = " ".join(str(ti.get(k, "")) for k in ("command", "description"))
    if tool == "Monitor" or (any(re.search(p, text, re.I) for p in RAW_STARTS) and "rec.py" not in text):
        msg = ("RV-213 reminder (Shae): this starts a recording/watcher. Start it through build/tools/rec.py (size cap + "
               "auto-stop + ledger) or plan its end now; a Monitor tail goes inside `timeout 1800 ...`.")
        print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse", "additionalContext": msg},
                          "systemMessage": msg}))


def hook_stop():
    try:
        h = json.load(sys.stdin)
    except ValueError:
        h = {}
    ents = [e for e in load() if is_open(e)]
    bad = [fmt(e) for e in ents if overdue(e)] + unledgered()
    if bad and not h.get("stop_hook_active"):
        print(json.dumps({"decision": "block", "reason": "RV-213: recordings need ending before this turn ends:\n"
                          + "\n".join(bad) + "\nEnd them (rec.py stop ID / the stop command) or ledger them."}))
    elif ents or bad:
        print(json.dumps({"systemMessage": "RV-213 open recordings:\n" + "\n".join([fmt(e) for e in ents] + bad)}))


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
