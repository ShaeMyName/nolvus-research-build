"""Client for SkyrimNet's /harness test-automation API (dashboard web server, test config only: Harness.yaml enabled,
WebServer.yaml 127.0.0.1:8080). U2 route R5 (step8_time_plan.md:70); approved for the step-8 blocks (D1).

Endpoints VERIFIED as strings in the 25.1 DLL (tools/skyrimnet_b25_1_dll_strings.txt:58185-58360, HarnessPage*.cpp):
  GET  status, ui-state, await (kind=event|idle|speech-done, timeout_s, event_type, uuid), tap (SSE), utterances,
       engine-sweep
  POST inject-player-input, inject-event (event_type, payload, originator_uuid, target_uuid; schemas at
       /events?api=schemas), speak (speaker_uuid, target_uuid, kind=npc|scene|player|dbvo|silent|telepathy|thought|
       narration, text or chunks), purge (exclude_uuid, defer), select-topic (npc_uuid, topic or info_form_id, say),
       reset-cooldowns, overrides (pacing_governor=bypass|normal), dismiss-ui (exactly one of button | menu),
       plus the dialogue entry points (handleDialogueAPI).
Body field names come from the DLL's own validation messages; anything not named there is INFERRED and marked so.
Never sends keys; the dashboard needs no token in the test config (Auth access_token empty). Requests and responses
are logged by length and status only, never their text (spoiler / prose rules)."""
import json, re, time, urllib.error, urllib.parse, urllib.request

BASE = "http://127.0.0.1:8080/harness"
HEADERS = {"Content-Type": "application/json", "Origin": "http://127.0.0.1:8080"}   # 'refused: foreign origin' guard


class HarnessError(Exception):
    pass


TRACE = "C:/nolvus-research/test_runs/iface_trace.jsonl"     # u2_interface_report.py reads this (REVIEW_LOG RV-153)
_ENUM_KEYS = ("kind", "timeout_s", "event_type", "pacing_governor", "button", "menu", "say", "defer", "api")   # values kept as is (no text, no ids)


def _shape(v, depth=0):
    """Field NAMES and value types of a response, never text: a bool/number keeps its value, a string only its length (or
    'hex<len>' when it looks like an id), a list its length and its first items' shapes. No prose or event text is stored."""
    if isinstance(v, bool) or isinstance(v, (int, float)):
        return v
    if isinstance(v, str):
        return ("hex%d" % len(v)) if re.fullmatch(r"[0-9A-Fa-fxX{}\-]{6,40}", v) else "str%d" % len(v)
    if v is None:
        return None
    if depth >= 3:
        return type(v).__name__
    if isinstance(v, dict):
        return {str(k): _shape(x, depth + 1) for k, x in list(v.items())[:40]}
    if isinstance(v, list):
        return {"list": len(v), "items": [_shape(x, depth + 1) for x in v[:3]]}
    return type(v).__name__


def _trace(method, api, params, body, status, ms, out, err):
    """One JSON line per /harness call to TRACE: endpoint, parameter and body field names, HTTP status, duration, response shape.
    Never raises (a failed trace must not change a test)."""
    try:
        rec = {"t": round(time.time(), 3), "m": method, "api": api,
               "params": {k: (v if k in _ENUM_KEYS else "set") for k, v in (params or {}).items()},
               "body": {k: (v if k in _ENUM_KEYS else _shape(v)) for k, v in body.items()} if isinstance(body, dict) else None,
               "status": status, "ms": int(ms),
               "resp": _shape(out) if out is not None else None, "err": (err or None) and str(err)[:160]}
        with open(TRACE, "a", encoding="utf-8") as f:
            f.write(json.dumps(rec) + "\n")
    except Exception:
        pass


def _call(method, api, params=None, body=None, timeout=30):
    q = {"api": api}
    q.update({k: v for k, v in (params or {}).items() if v is not None})
    url = BASE + "?" + urllib.parse.urlencode(q)
    data = json.dumps(body).encode("utf-8") if body is not None else None
    req = urllib.request.Request(url, data=data, method=method, headers=HEADERS)
    t0 = time.time()
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            raw = resp.read().decode("utf-8", "replace")
            status = resp.status
    except urllib.error.HTTPError as e:
        raw, status = e.read().decode("utf-8", "replace"), e.code
    except (urllib.error.URLError, OSError) as e:
        _trace(method, api, q, body, None, (time.time() - t0) * 1000, None, "%s: %s" % (type(e).__name__, e))
        raise HarnessError("%s %s: %s" % (method, api, e))
    try:
        out = json.loads(raw) if raw.strip() else {}
    except ValueError:
        out = {"_raw_len": len(raw)}
    _trace(method, api, q, body, status, (time.time() - t0) * 1000, out,
           (out.get("error", "") if isinstance(out, dict) else "") if status >= 400 else None)
    if status >= 400:
        raise HarnessError("%s %s -> HTTP %d (%s)" % (method, api, status, out.get("error", "") if isinstance(out, dict) else ""))
    return out


def get(api, timeout=30, **params):
    return _call("GET", api, params=params, timeout=timeout)


def post(api, body=None, timeout=30, **params):
    return _call("POST", api, params=params, body=body or {}, timeout=timeout)


# ---- read-only
def status():
    return get("status")


def ui_state():
    return get("ui-state")


def utterances():
    return get("utterances")


def await_idle(timeout_s=60):
    return get("await", timeout=timeout_s + 10, kind="idle", timeout_s=timeout_s)


def await_speech_done(uuid, timeout_s=60):
    return get("await", timeout=timeout_s + 10, kind="speech-done", uuid=uuid, timeout_s=timeout_s)


def await_event(event_type, timeout_s=60, uuid=None):
    return get("await", timeout=timeout_s + 10, kind="event", event_type=event_type, uuid=uuid, timeout_s=timeout_s)


# ---- actions
def inject_player_input(text, target_uuid=None):
    """Player speaks a line (as typed in chat). Body field names INFERRED: 'text' (the DLL validates 'text' for the
    speech/narration APIs) and 'target_uuid'."""
    b = {"text": text}
    if target_uuid:
        b["target_uuid"] = target_uuid
    return post("inject-player-input", b)


def speak(speaker_uuid, text, kind="npc", target_uuid=None):
    """Force a line from a speaker (force-response route). Fields VERIFIED by the DLL's messages."""
    b = {"speaker_uuid": speaker_uuid, "text": text, "kind": kind}
    if target_uuid:
        b["target_uuid"] = target_uuid
    return post("speak", b)


def inject_event(event_type, payload, originator_uuid=None, target_uuid=None):
    """A typed event (direct_narration, gamemaster_dialogue, ...); payload per /events?api=schemas."""
    b = {"event_type": event_type, "payload": payload}
    if originator_uuid:
        b["originator_uuid"] = originator_uuid
    if target_uuid:
        b["target_uuid"] = target_uuid
    return post("inject-event", b)


def select_topic(npc_uuid, topic=None, info_form_id=None, say=True):
    b = {"npc_uuid": npc_uuid, "say": say}
    if topic is not None:
        b["topic"] = topic
    if info_form_id is not None:
        b["info_form_id"] = info_form_id
    return post("select-topic", b)


def dismiss_ui(button=None, menu=None):
    if (button is None) == (menu is None):
        raise ValueError("dismiss_ui: exactly one of button or menu")
    return post("dismiss-ui", {"button": button} if button is not None else {"menu": menu})


def reset_cooldowns():
    return post("reset-cooldowns")


def pacing(bypass=True):
    return post("overrides", {"pacing_governor": "bypass" if bypass else "normal"})


def purge(exclude_uuid=None, defer=False):
    b = {"defer": defer}
    if exclude_uuid:
        b["exclude_uuid"] = exclude_uuid
    return post("purge", b)


def probe():
    """Read-only reachability probe (run between game sessions' idle windows, never during a crash_repro idle):
    status + ui-state + utterance count. Returns {name: 'ok <keys>' | 'ERR ...'} with field NAMES only."""
    out = {}
    for name, fn in (("status", status), ("ui-state", ui_state), ("utterances", utterances)):
        try:
            res = fn()
            out[name] = "ok keys=%s" % (sorted(res.keys()) if isinstance(res, dict) else type(res).__name__)
        except HarnessError as e:
            out[name] = "ERR %s" % e
    return out


if __name__ == "__main__":
    for k, v in probe().items():
        print("%-11s %s" % (k, v))
