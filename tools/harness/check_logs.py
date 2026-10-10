"""Host-side invariant checks that only the logs can answer (spec §14): I5, I7, I8. Reads only.
  I5  per IntelEngine task ("IntelEngine: Allocated slot S to NAME for TYPE"): exactly one bridge decision for NAME
      (TAKE / LEND / REFUSE / TAKE_SKIP) before NAME's next allocation; for TAKE / LEND exactly one terminal
      (RELEASE*, REJOIN_DONE / REJOIN_CANCELLED / REJOIN_TO_WAIT, LEND_RESTORE*, LEND_ABORT); no DISPATCH_CONFLICT;
      no Papyrus error from IEB_ scripts (BLD-4 probe excluded).
  I7  SkyrimNet: no "character_bio submodule validation failed"; 0 rejected layers at boot; every one of our 8 layers
      registered (or already present) and none moved below a third-party layer by a later order change.
  I8  Narrator (component D) is not built: N/A unless a narrator layer is installed.
Usage: check_logs.py [--since "YYYY-MM-DD HH:MM:SS"]   (Papyrus timestamps are "MM/DD/YYYY - hh:mm:ssAM").
  [CHANGED 2026-10-10] --since compares full date-times, so a block that crosses midnight is filtered correctly; a bare
  "HH:MM:SS" means that time today.
Prints ASSERT PASS|FAIL lines and a summary; exit code 1 on any FAIL."""
import os, re, sys
from datetime import datetime

DOCS = os.path.expanduser("~/Documents/My Games/Skyrim Special Edition/")
PAPYRUS = DOCS + "Logs/Script/Papyrus.0.log"
SNLOG = DOCS + "SKSE/SkyrimNet.log"
OURS = ["ieb.errandbridge", "shae.dialogue-actions", "shae.privacy-overrides", "shae.scene-text", "shae.child-safety",
        "shae.discretion", "shae.marriage", "shae.lucienne"]
DECIDE = ("TAKE", "LEND", "REFUSE", "TAKE_SKIP")
TERMINAL = re.compile(r"^(RELEASE\w*|REJOIN_DONE|REJOIN_CANCELLED|REJOIN_TO_WAIT|LEND_RESTORE\w*|LEND_ABORT)$")
ALLOC = re.compile(r"IntelEngine: Allocated slot (\d+) to (.+?) for (\S+)")
BRIDGE = re.compile(r"\[IEB\] ([A-Za-z_]+) actor=(.+?)(?= [a-zA-Z]+=|$)")   # any case: Papyrus string case-folding (U1 B-14)
fails = 0


def out(ok, rule, msg):
    global fails
    if not ok:
        fails += 1
    print("ASSERT %s %s %s" % ("PASS" if ok else "FAIL", rule, msg))


def i5(lines):
    tasks = []           # dicts: name, type, decision(s), terminals
    open_by_name = {}
    conflicts = errors = 0
    for idx, l in enumerate(lines):
        if "Reverting game..." in l:
            # A load ends the pre-load timeline. A task that already has its terminal is closed: later lines about the
            # same name belong to another timeline (U1 run 18 L-9: LEND_RESTORE before the reload, then the save's own
            # task end restored again after it). A task with no terminal yet stays open, so a terminal logged after the
            # load (a save that held the task open) still counts. (731ea70 cleared every count instead, which made a
            # task finished before a reload to T0 look unfinished: run 18 D-2.)
            for name, t in list(open_by_name.items()):
                if t["term"]:
                    del open_by_name[name]
            continue
        m = ALLOC.search(l)
        if m:
            t = {"name": m.group(2).strip(), "type": m.group(3), "slot": m.group(1), "dec": [], "term": []}
            tasks.append(t)
            open_by_name[t["name"]] = t
            continue
        m = BRIDGE.search(l)
        if m:
            kw, name = m.group(1).upper(), m.group(2).strip()
            if kw == "DISPATCH_CONFLICT":
                conflicts += 1
            t = open_by_name.get(name)
            if t is None:
                continue
            if kw in DECIDE:
                t["dec"].append(kw)
            elif TERMINAL.match(kw):
                t["term"].append(kw)
            continue
        if "error:" in l.lower() and "ieb_bld4probe" not in l.lower():
            frames = " ".join(x for x in lines[idx + 1:idx + 6] if x.startswith("\t"))
            if re.search(r"\bIEB_\w*\.", l + " " + frames):
                errors += 1
    for t in tasks:
        label = "%s slot %s (%s)" % (t["name"], t["slot"], t["type"])
        out(len(t["dec"]) == 1, "I5", "%s decisions=%s" % (label, t["dec"] or "none"))
        if t["dec"][:1] in (["TAKE"], ["LEND"]):
            out(len(t["term"]) == 1, "I5", "%s terminals=%s" % (label, t["term"] or "none (still running?)"))
    out(conflicts == 0, "I5", "DISPATCH_CONFLICT lines=%d" % conflicts)
    out(errors == 0, "I5", "Papyrus errors from IEB_ scripts=%d" % errors)
    return len(tasks)


def i7(sn):
    bad = sum("character_bio submodule validation failed" in l for l in sn)
    out(bad == 0, "I7", "character_bio validation failures=%d" % bad)
    boots = [re.search(r"(\d+) layer\(s\) discovered \((\d+) rejected\)", l) for l in sn if "Boot complete" in l]
    boots = [b for b in boots if b]
    out(bool(boots) and int(boots[-1].group(2)) == 0, "I7", "rejected layers at boot=%s" % (boots[-1].group(2) if boots else "no boot line"))
    text = "\n".join(sn)
    for lid in OURS:
        present = ("'%s'" % lid) in text
        out(present, "I7", "layer %s present in this session's log" % lid)
    moved = [l for l in sn if "priority" in l.lower() and any(x in l for x in OURS) and "moved" in l.lower()]
    out(not moved, "I7", "our layers moved by an order change=%d (check the dashboard if > 0)" % len(moved))


def main():
    since = sys.argv[sys.argv.index("--since") + 1] if "--since" in sys.argv else None
    lines = open(PAPYRUS, encoding="utf-8", errors="replace").read().splitlines() if os.path.exists(PAPYRUS) else []
    if since:
        cut = (datetime.strptime(since, "%Y-%m-%d %H:%M:%S") if "-" in since
               else datetime.combine(datetime.now().date(), datetime.strptime(since, "%H:%M:%S").time()))
        keep, on = [], False
        for l in lines:
            m = re.match(r"\[(\d\d/\d\d/\d{4}) - (\d\d:\d\d:\d\d)(AM|PM)\]", l)
            if m and not on:
                on = datetime.strptime(m.group(1) + " " + m.group(2) + m.group(3), "%m/%d/%Y %I:%M:%S%p") >= cut
            if on:
                keep.append(l)
        lines = keep
    n = i5(lines)
    sn = open(SNLOG, encoding="utf-8", errors="replace").read().splitlines() if os.path.exists(SNLOG) else []
    i7(sn)
    print("I8 N/A: narrator (component D) not built")
    print("SUMMARY tasks=%d fails=%d" % (n, fails))
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
