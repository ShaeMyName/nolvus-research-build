"""Step 8 test runner over SkyrimNet's MCP server ([::1]:8889) and the harness controller (IEB_TestQuest /
IEB_TestCtl). Test profile only. Prints PASS/FAIL lines; results also appended to C:/nolvus-research/test_runs/.

  runner.py smoke            MCP reachable, harness answers, timescale = recorded
  runner.py cs23 [child=0x1A66B] [adult=0x1A675]
        CS-23 (spec §11.10.4; FIRST test of step 8, Shae 2026-10-09; a FAIL stops step 8): a child speaker is never
        eligible for SeverActions' Undress, UnequipArmor or SitOrLayDown (layer I's rule: decnpc resultPath isChild ==
        false), while an adult is not blocked by that rule. Defaults: Braith (child, Skyrim.esm ref 0x01A66B) and
        Carlotta Valentia (adult, ref 0x01A675), both in the Whiterun market by day; both must be loaded.
"""
import json, os, re, sys, time
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from mcp_client import MCP
# The one FormID normaliser (REVIEW_LOG R48): every host-side FormID match goes through these. Re-exported here.
from fidnorm import fid_norm, fid_any_rx, fid_s32, fid_hex8   # noqa: F401

PAPYRUS = os.path.expanduser("~/Documents/My Games/Skyrim Special Edition/Logs/Script/Papyrus.0.log")
OUT = "C:/nolvus-research/test_runs/"
ACTIONS = ["Undress", "UnequipArmor", "SitOrLayDown"]


# A controller's own failure report on its confirmation line (wrapper ran, action did not happen).
CTL_FAILED = re.compile(r"(?i)\[IEB-TEST\] \w+: (?:ModEvent\.Create failed|no door|no ref\b)")


def s32arg(x):
    """Papyrus Int is signed 32-bit: FormIDs of light/high-index plugins (0xFE.., 0x80..-0xFF..) passed as Python ints
    above 0x7FFFFFFF don't bind (U1 run 18 L-6: StartTask(4266236491 = 0xFE499A4B, ...) never ran)."""
    return x - (1 << 32) if isinstance(x, int) and not isinstance(x, bool) and 0x7FFFFFFF < x <= 0xFFFFFFFF else x


class Run:
    def __init__(self, name):
        self.name, self.lines, self.fails, self.inconclusive = name, [], 0, 0
        self.forced = False          # set by block.py for tests on forced-state saves (Shae's rule 3)
        self.setup_only = False      # set by block.py --setup-only: block.checkpoint() then stops the test
        self.t0 = time.time()
        self.c = MCP()

    def log(self, s):
        print(s)
        self.lines.append(s)

    def check(self, ok, what):
        if not ok:
            self.fails += 1
        self.log("%s %s %s" % ("PASS" if ok else "FAIL", self.name, what))

    def tool(self, name, args):
        r = self.c.request("tools/call", {"name": name, "arguments": args})
        if "result" not in r:
            return {"error": r.get("error")}
        txt = "".join(p.get("text", "") for p in r["result"].get("content", []))
        try:
            return json.loads(txt)
        except ValueError:
            return {"text": txt}

    # [CHANGED 2026-10-10, reviewer] ctl() is synchronous by default: MCP's execute_quest_function returns before
    # Papyrus runs the call (U1 run 14 B-10: a baseline Snapshot ran 2 s after the errand started), so each call waits
    # for the function's own "[IEB-TEST] ..." line. Never confirmed -> INCONCLUSIVE (a late baseline could make a leak
    # look like a PASS). Functions that print no line are listed in CTL_UNSYNC and run unsynchronized (log lines are
    # added to them in the post-U1 harness install).
    CTL_DONE = {
        "Accelerate": "TIMESCALE accelerated|ASSERT FAIL TIMESCALE",
        "AddTestOverride": "AddTestOverride",
        "AssertTimescale": "ASSERT\\ FAIL\\ TIMESCALE\\ got|ASSERT\\ PASS\\ TIMESCALE",
        "Burst": "BURST|BURST\\ END|BURST\\ START|Burst:\\ ModEvent\\.Create\\ failed|Burst\\ requested",
        "CFProbe": "CFProbe",
        "CampMuster": "CampMember|CampMuster:\\ chief\\ has\\ no\\ camp|CampMuster:\\ no\\ chief\\ or\\ no\\ Enterprises\\ script|CampMuster\\ camp=",
        "Cancel": "Cancel",
        "Check": "Check",
        "CombatProbe": "CombatProbe|CombatProbe\\ none",
        "Despawn": "Despawn|Despawn\\ none",
        "ConfigProbe": "(?i:CONFIGPROBE) ",
        "MenuProbe": "(?i:MENUPROBE) ",
        "HeldProbe": "HELDPROBE ",
        "SlotsProbe": "SLOTSPROBE",
        "DashCancel": "DASHCANCEL ",
        "ReserveProbe": "RESERVEPROBE ",
        "HeadStartOp": "HSOP ",
        "PlayerWhere": "PLAYERPOS ",
        "PlayerPlace": "PLAYERPOS ",
        "CrashCtx": "CRASHCTX ",
        "EquipFromList": "EQUIPLIST |EquipFromList:",
        "BodySwap": "BODYSWAP ",
        "Whisper": "WHISPERSET ",
        "SUStrLen": "SUSTRLEN ",
        "OwnNearestFurniture": "OWNFURN ",
        "CountNearNPCs": "NEARNPC ",
        "SetHour": "CRASHCTX ",
        "AutoSaveNow": "AUTOSAVE requested",
        "NFFGuardOn": "NFFGuardOn",
        "NFFStaleFac": "NFFStaleFac",
        "NFFImport": "NFFImport",
        "SaveNamed": "(?i:SAVENAMED) ",
        "KillUnattributed": "(?i:KILLUNATTR) ",
        "CrimeProbe": "(?i:CRIMEPROBE) ",
        "SUGetInt": "SU \\S+ \\S+ get=",
        "DespawnRef": "(?i:DESPAWN(?:REF)?) ",   # case_folding_audit.md: the installed pex prints "Despawn "
        "Dispatch": "Dispatch",
        "DoorUse": "DoorUse\\ 0x[0-9A-F]+\\ dest=|DoorUse:\\ ModEvent\\.Create\\ failed|DoorUse:\\ no\\ door",
        "ExpectLend": "ExpectLend",
        "FastTravelTo": "FastTravelTo|FastTravelTo:\\ no\\ ref",
        "FurnState": "FurnState",
        "HoldIEAlias": "HoldIEAlias|HoldIEAlias:",
        "ReleaseIEAlias": "ReleaseIEAlias|ReleaseIEAlias:",
        "KillAndSave": "KillAndSave",
        "Lend": "Lend",
        "MoveRel": "MoveRel|MoveRel:\\ missing\\ ref",
        "NFFCombatAware": "NFFCombatAware:\\ no\\ NFF\\ controller|NFFCombatAware\\ was=",
        "NFFDismiss": "NFFDismiss|NFFDismiss:\\ no\\ actor\\ or\\ no\\ NFF\\ controller",
        "NFFFollow": "NFFFollow",
        "NFFWait": "NFFWait",
        "Narrate": "Narrate",
        "PlaceRel": "PLACE",
        "Probe": "probe",
        "QAlias": "QALIAS|QALIAS\\ none",
        "QPClear": "QPClear",
        "QPFill": "QPFill",
        "QR": "QR",
        "QScan": "QSCAN|QSCAN\\ END\\ n=|QSCAN\\ END\\ n=0\\ \\(no\\ IntelEngine\\)",
        "RankApply": "RANKAPPLY",
        "RankProbe": "RANK",
        "Recall": "Recall",
        "RecordTimescale": "TIMESCALE\\ recorded",
        "Rejoin": "Rejoin",
        "RemoveTestOverride": "RemoveTestOverride",
        "Restore": "Restore",
        "RestoreTimescale": "ASSERT (?:PASS|FAIL) TIMESCALE",
        "SUSetInt": "SU|SU\\ REFUSED\\ child",
        "SUUnset": "SU",
        "SceneOff": "SCENE\\ off",
        "SceneOn": "SCENE\\ on\\ partner=|SCENE\\ refused\\ child",
        "ScheduleMeeting": "ScheduleMeeting|ScheduleMeeting:\\ no\\ actor\\ or\\ no\\ IE\\ Schedule",
        "SetDropTeammate": "DropTeammate\\ was=",
        "SetIEWaitHours": "IEWaitHours\\ prev=",
        "SetRank": "SETRANK",
        "SitNearest": "SitNearest",
        "SkipProbe": "SkipProbe:\\ no\\ StoryEngine|SkipProbe\\ goto=",
        "Snapshot": "snapshot",
        "SneakRun": "SNEAK\\ END|SNEAK\\ START|SNEAK\\ rt=|SneakRun:\\ ModEvent\\.Create\\ failed|SneakRun:\\ no\\ actor",
        "Spawn": "SPAWN\\ base=|SPAWN\\ none",
        "SpawnHostile": "SpawnHostile|SpawnHostile:\\ no\\ base\\ form",
        "Speak": "Speak",
        "StartTask": "IntelEngine\\ quest\\ missing|StartTask|StartTask:\\ ModEvent\\.Create\\ failed|StartTask:\\ invalid\\ or\\ dead\\ actor,\\ or\\ no\\ IE\\ Core|StartTask:\\ unknown\\ action|StartTask\\ dispatched",
        "StepPlayer": "StepPlayer",
        "UUIDOf": "UUID"
    }
    CTL_UNSYNC = ["ExpectWFP", "TestCFRefuse"]

    def ctl(self, fn, args=None, sync=True, timeout=20):
        size = os.path.getsize(PAPYRUS) if os.path.exists(PAPYRUS) else 0
        res = self.tool("execute_quest_function", {"quest_editor_id": "IEB_TestQuest", "script_name": "IEB_TestCtl",
                                                   "function_name": fn, "arguments": [s32arg(x) for x in (args or [])]})
        pat = self.CTL_DONE.get(fn)
        if not sync or pat is None:
            if sync and fn in self.CTL_UNSYNC:
                time.sleep(1.0)     # no completion line yet: give Papyrus a moment (unsynchronized call)
            return res
        # 2026-10-11: Papyrus case-folds log literals to same-named functions ("SLOTSPROBE" logged as "SlotsProbe")
        m = self.logline(r"(?i)\[IEB-TEST\] (?:%s)[^\r\n]*" % pat, size, timeout)
        if not m:
            self.inconclusive += 1
            self.log("INCONCLUSIVE %s: controller call %s(%s) not confirmed in the Papyrus log within %d s"
                     % (self.name, fn, args, timeout))
        elif CTL_FAILED.search(m.group(0)):
            # consumer_proof_list.md: a wrapper's own failure line (e.g. "DoorUse: ModEvent.Create failed", "no door")
            # confirms the call ran, not that it worked
            self.inconclusive += 1
            self.log("INCONCLUSIVE %s: controller call %s(%s) reported failure: %s" % (self.name, fn, args,
                                                                                    m.group(0).strip()))
        return res

    def logline(self, pattern, since_size, timeout=15):
        """Wait for a Papyrus log line matching pattern, written after byte offset since_size."""
        end = time.time() + timeout
        while time.time() < end:
            with open(PAPYRUS, "rb") as f:
                f.seek(since_size)
                m = re.search(pattern, f.read().decode("utf-8", "replace"))
            if m:
                return m
            time.sleep(1)
        return None

    def uuid(self, formid):
        size = os.path.getsize(PAPYRUS)
        # UUIDOf logs nothing for an actor that isn't loaded (until the pex logs "UUID <id> none"), so an unloaded
        # actor is an answer ("" = not loaded), not an unconfirmed call (U1 run 19 K-3: 6 false INCONCLUSIVEs).
        r = self.ctl("UUIDOf", [formid], sync=False)
        for k in ("returnValue", "result", "return"):
            if isinstance(r, dict) and r.get(k):
                return str(r[k]), None
        m = self.logline(r"\[IEB-TEST\] UUID %s (?:(.+?) = ([0-9A-Fa-f]*) child=(\w+)|none)" % fid_any_rx(formid), size, 10)
        if not m or m.group(2) is None:
            return "", None
        return m.group(2), (m.group(1), m.group(3).upper() == "TRUE")

    def save(self):
        os.makedirs(OUT, exist_ok=True)
        p = OUT + "%s_%s%s.txt" % (self.name, "setup_" if self.setup_only else "", time.strftime("%Y%m%d-%H%M%S"))
        open(p, "w", encoding="utf-8").write("\n".join(self.lines) + "\n")
        verdict = "%d FAIL" % self.fails if self.fails else ("INCONCLUSIVE (%d)" % self.inconclusive if self.inconclusive else "ALL PASS")
        self.log("saved %s; %s" % (p, verdict))
        # Per-test timing log (Shae, 2026-10-09): real seconds per run, used to re-estimate the remaining families.
        t = OUT + "timings.csv"
        new = not os.path.exists(t)
        with open(t, "a", encoding="utf-8") as f:
            if new:
                f.write("test,start,end,seconds,verdict\n")
            f.write("%s,%s,%s,%d,%s\n" % (self.name + (" [forced state]" if self.forced else "")
                                          + (" [setup-only]" if self.setup_only else ""), time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(self.t0)),
                                          time.strftime("%Y-%m-%d %H:%M:%S"), time.time() - self.t0, verdict))
        return verdict


def eligible(res):
    """Normalise check_action_eligibility output to (eligible: bool|None, detail: str)."""
    if not isinstance(res, dict):
        return None, str(res)[:300]
    for k in ("eligible", "isEligible", "is_eligible"):
        if k in res:
            return bool(res[k]), json.dumps(res)[:600]
    t = json.dumps(res)
    if re.search(r"not eligible|ineligible|\"false\"", t, re.I):
        return False, t[:600]
    return None, t[:600]


def cs23(args):
    child = fid_norm(next((a.split("=")[1] for a in args if a.startswith("child=")), "0x1A66B"), base=16)
    adult = fid_norm(next((a.split("=")[1] for a in args if a.startswith("adult=")), "0x1A675"), base=16)
    r = Run("CS-23")
    cu, cinfo = r.uuid(child)
    au, ainfo = r.uuid(adult)
    r.check(bool(cu), "child loaded and UUID resolved (%s)" % (cinfo[0] if cinfo else "not loaded"))
    r.check(bool(au), "adult loaded and UUID resolved (%s)" % (ainfo[0] if ainfo else "not loaded"))
    if cinfo:
        r.check(cinfo[1], "child actor reports IsChild() true")
    if ainfo:
        r.check(not ainfo[1], "adult actor reports IsChild() false")
    if not (cu and au):
        r.save()
        return r.fails
    # Settle: right after a load SeverActions' Papyrus-backed checks are not ready yet and EVERY SeverActions action
    # reads ineligible for everyone (seen 2026-10-09, ~2 min after load). Wait up to 5 min for the adult control.
    for _ in range(30):
        if eligible(r.tool("check_action_eligibility", {"action_name": "SitOrLayDown", "actor_uuid": au}))[0] is True:
            break
        time.sleep(10)
    else:
        r.log("INCONCLUSIVE CS-23 settle: the adult control never became eligible within 5 min")
        r.inconclusive += 1
        r.save()
        return r.fails + r.inconclusive
    for act in ACTIONS:
        ce, cd = eligible(r.tool("check_action_eligibility", {"action_name": act, "actor_uuid": cu}))
        r.log("  child %s -> %s" % (act, cd))
        r.check(ce is False, "%s: child NOT eligible" % act)
        ae, ad = eligible(r.tool("check_action_eligibility", {"action_name": act, "actor_uuid": au}))
        r.log("  adult %s -> %s" % (act, ad))
        # Discriminating only if the adult IS eligible (otherwise the child's "not eligible" could come from any rule,
        # or from SkyrimNet blocking Papyrus decorators while the game is paused). Adult not eligible = INCONCLUSIVE.
        if ae is True:
            r.check(True, "%s: adult eligible (the child rule does not block adults)" % act)
        else:
            r.inconclusive += 1
            r.log("INCONCLUSIVE CS-23 %s: adult not eligible (eligible=%s); check the game is unpaused (no console or menu open)" % (act, ae))
    r.save()
    return r.fails + r.inconclusive


def smoke(args):
    r = Run("SMOKE")
    size = os.path.getsize(PAPYRUS)
    res = r.ctl("AssertTimescale")
    r.check(isinstance(res, dict) and "error" not in res, "harness controller answers over MCP")
    m = r.logline(r"ASSERT (PASS|FAIL) TIMESCALE", size)
    r.check(bool(m) and m.group(1) == "PASS", "timescale equals the recorded play value")
    r.save()
    return r.fails


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "smoke"
    sys.exit(1 if {"cs23": cs23, "smoke": smoke}[cmd](sys.argv[2:]) else 0)
