"""Step-8 U1 tests, misc families: D, Q, REL, CS (20-22, 12), RS (1, 4, 6, 8), K, X (1-4, 7, 8). EX-5/EX-6 are NOT
implemented here: they need a MARAS spouse/candidate (save T0-M), see the agent report.

Routes per test: investigation/round10/step8_time_plan.md §3.1-3.5 (R1 = MCP, R3 = render_template, R4 = TestCtl
wrappers). Spec rows: BRIDGE_SPEC_V2.md §15.3 (D, REL, K), §10.2.1 (Q), §11.10.4 (CS), §11.14.6 (RS), §11.6 (X).

Hard rules kept in this file (AGENT_BRIEF.md):
- Results are pass/fail, FormIDs, stage numbers and counts. No quest, journal, dialogue or knowledge text is logged;
  NPC display names read from the Papyrus log are used internally for regex matching only and never written to the
  result file. Story-quest EditorIDs are never named; Favor158 (a Misc job, type 6) is named only inside a console
  command string.
- Child safety: a child is never made a scene partner, never undressed, never sent to an LLM romance/spark/drift
  prompt. CS tests only exercise gates that must refuse. The proposed SUSetInt wrapper refuses the scene and romance
  keys on an IsChild actor.

New IEB_TestCtl members used here (NOT built yet; exact Papyrus is in the agent report): QR, QScan, QAlias, SUSetInt,
SUUnset, RankProbe, SetRank, RankApply, SceneOn, SceneOff, PlaceRel, Spawn, Despawn. Everything else is existing
IEB_TestCtl (StartTask, Recall, UUIDOf, Check, Dispatch, Snapshot) or a direct MCP call on a mod's own quest script.
"""
import json, os, re, time
from block import test, checkpoint, setup_skip
from runner import eligible
from fidnorm import fid_norm, fid_any_rx, fid_hex8, fid_s32   # one FormID normaliser (REVIEW_LOG R48)
import game

# ---------------------------------------------------------------------------- cast (AGENT_BRIEF.md T0 table)
PLAYER = 0x14
F1 = 0x000E1BA9          # Jenassa (also E, enrolled companion)
F2 = 0x00091918          # Uthgerd
H = 0x0002C90F           # Brenuin (male, SA-homed)
G = 0x0001A680           # Anoriath
CARLOTTA = 0x0001A675
ST = 0x0001A672          # Belethor
CHILD = 0x0001A66B       # Braith
CAST = {PLAYER, F1, F2, H, G, CARLOTTA, ST, CHILD}
YSOLDA = 0x0001A69A      # REL-2 recruit. VERIFIED ref of NPC_ Ysolda 0x13BAB in gamedata/Skyrim.esm (scan 2026-10-10)
FRALIA = 0x0001A684      # REL-2 fallback. VERIFIED ref of NPC_ FraliaGrayMane 0x13B9C (same scan)
LISBET = 0x000198EA      # K-2. VERIFIED: NPC_ Lisbet 0x133A5 carries SNAM MarkarthArnleifandSonsFaction 0x6566D
WR_GUARDS = [0x000DD8FF, 0x000DC2BE, 0x000DC2C4, 0x000DC2D7, 0x000DC2D8, 0x000DC2DA, 0x0001B5C2, 0x0001B5BE]
#   K-3: refs of GuardWhiterunCityGeneric / ...SonsGeneric / ...ImperialTemplate (all GuardFactionWhiterun, same scan).
#   INFERRED that at least one is loaded near the market at 09:11.
DOG_BASE = 0x00109487    # WEFollowerDog (CurrentFollowerFaction, not hostile). VERIFIED NPC_ record, same scan
WOLF_DEAD_BASE = 0x000753CE  # EncWolfDead (a corpse: no combat). VERIFIED NPC_ record, same scan
FAVOR_Q = (0x000940D0, "Favor158", 10, 200)
#   Q-2: Misc job (QUST type 6), stages [0,10,15,20,200], objectives [10,15], one unique-actor alias (ALUA 0x1C188).
#   VERIFIED from gamedata/Skyrim.esm (scan 2026-10-10). INFERRED: setstage 10 displays objective 10, setstage 200
#   completes it, and console setstage starts a stopped quest.
DEST_NEAR = "WhiterunDrunkenHuntsman"    # AGENT_BRIEF.md example destination
DEST_FAR = "Rorikstead"                  # INFERRED IntelEngine resolves a town name; a long walk (> 6 real min)

SNROM = ("C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/SkyrimNet Test - Output/SKSE/Plugins/"
         "SkyrimNet Relationships/logs/snrom.log")
#   VERIFIED by listing 2026-10-10 (Relationships AppendLog writes Data/SKSE/Plugins/SkyrimNet Relationships/logs,
#   repos/SkyrimNet-Relationships/native/src/Natives.cpp:198-217; MO2 routes it to the Output mod).
REQLOG = "C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/SkyrimNet Test - Output/SKSE/Plugins/SkyrimNet/logs/openrouter_input.log"

# Spec §2.11: the 23 faction EditorIDs the Gaius packs use that exist nowhere in the active load order (K-1).
MISSING_FACTIONS = [
    "CidhnaMineFaction", "DawnstarBeitildsHouseFaction", "DawnstarBrinaMerilisHouseFaction",
    "DawnstarIronBreakerMineFaction", "DawnstarQuicksilverMineFaction", "DawnstarSilusHouseFaction",
    "EastEmpireCompanyFaction", "FalkreathHallOfTheDeadFaction", "GuardFactionMorthal", "MarkarthSmelterFaction",
    "MarkarthUnderstoneKeepFaction", "MorthalHighmoonHallFaction", "MorthalLumberMillFaction",
    "MorthalMoorsideInnFaction", "MorthalThaumaturgistsHutFaction", "PlayerHouseHjerimFaction",
    "PlayerHouseProudspireFaction", "PlayerHouseVlindrelHallFaction", "RiftenBeggarsRowFaction",
    "WhiterunHallofTheDeadFaction", "WinterholdBirnasOddmentsFaction", "WinterholdJarlsLonghouseFaction",
    "WinterholdShrineOfAzuraFaction"]


# ============================================================================ small helpers

def tail(key):
    path = {"snrom": SNROM, "req": REQLOG}.get(key) or game.LOGS[key]
    return game.Tail(path)


def inc(r, why):
    r.inconclusive += 1
    r.log("INCONCLUSIVE %s %s" % (r.name, why))


def hx(fid):
    return fid_hex8(fid)


def s32(x):
    """Papyrus Int is signed 32-bit: spawned refs (0xFF......) must be passed as negative ints."""
    return fid_s32(x)


_REF_PREFIX = re.compile(r"^\s*(?:0x)?([0-9A-Fa-f]{6,8})\.(.+)$")


def con_args(cmd):
    """REVIEW_LOG RV-123: the MCP execute_console_command runs via Script::CompileAndRun against `target_form_id` (default
    the PLAYER); a "<hexref>.<cmd>" prefix is NOT resolved (VERIFIED 2026-10-11 run 6: every response said target
    0x00000014). So a leading hex-ref prefix becomes target_form_id. "player.<cmd>" is left as is (works)."""
    m = _REF_PREFIX.match(cmd)
    if m:
        return {"command": m.group(2), "target_form_id": "0x%08X" % int(m.group(1), 16)}
    return {"command": cmd}


def con(r, cmd):
    return r.tool("execute_console_command", con_args(cmd))


def retval(res):
    if isinstance(res, dict):
        for k in ("returnValue", "result", "return", "value"):
            if k in res and res[k] is not None and res[k] != "":
                return res[k]
    return None


def qf(r, quest, script, fn, args):
    return r.tool("execute_quest_function", {"quest_editor_id": quest, "script_name": script,
                                             "function_name": fn, "arguments": args})


def rel(r, fn, args):
    """SkyrimNet Relationships, quest SNRom_Quest / script SNRom_Bridge (VERIFIED repos/SkyrimNet-Relationships/tools/
    smoke.ps1:63 calls it this way; actor args as hex FormID strings, smoke.ps1:126)."""
    return qf(r, "SNRom_Quest", "SNRom_Bridge", fn, args)


def se(r, fn, args):
    """IntelEngine's StoryEngine: quest EditorID 'IntelEngine' (0xD61, investigation/round10/step3_api_facts.md:157),
    script IntelEngine_StoryEngine on the same quest (IEB_TestCtl.psc:191 casts IEQuest() to it)."""
    return qf(r, "IntelEngine", "IntelEngine_StoryEngine", fn, args)


def ah(fid):
    """Actor argument for a mod's own quest function: hex FormID string (VERIFIED AGENT_BRIEF.md, SwearCampToPlayer)."""
    return "0x%08X" % (fid & 0xFFFFFFFF)


def who(r, fid):
    """(uuid, display name, isChild) via IEB_TestCtl.UUIDOf (IEB_TestCtl.psc:145-155). Name is for regex use only."""
    t = tail("papyrus")
    res = r.ctl("UUIDOf", [s32(fid)])
    m = t.wait(r"\[IEB-TEST\] UUID (%s) (.+?) = ([0-9A-Fa-f]*) child=(\w+)" % fid_any_rx(fid), timeout=15)
    u = retval(res)
    if m:
        return (str(u) if u else m.group(3)), m.group(2), m.group(4).upper() == "TRUE"
    return (str(u) if u else ""), None, None


def same_uuid(a, b):
    def forms(x):
        x = str(x).strip()
        out = set()
        for base in (16, 10):
            try:
                out.add(int(x[2:] if x.lower().startswith("0x") else x, base))
            except ValueError:
                pass
        return out
    return bool(forms(a) & forms(b))


def render(r, actor_uuid, content=None, target=None, template=None):
    """MCP render_template (params VERIFIED as strings SNDLL:L51467-51474, L54207; 'renderedContent' VERIFIED
    AGENT_BRIEF.md). Returns the rendered text or None. Never logged by callers except tiny fields."""
    a = {"actor_uuid": actor_uuid}
    if content is not None:
        a["content"] = content
    if template:
        a["template_name"] = template
    if target:
        a["response_target_uuid"] = target
    res = r.tool("render_template", a)
    if isinstance(res, dict) and "renderedContent" in res:
        return res["renderedContent"] or ""
    r.log("  render failed: %s" % str(res.get("error") if isinstance(res, dict) else res)[:160])
    return None


def rval(r, uuid, expr, target=None):
    """Render one short expression and return it stripped (or None)."""
    # The nonce comment sits OUTSIDE the expression (inside {{ }} it broke the template: run 19 CS-12 read '') and makes
    # every render text unique, so SkyrimNet never answers from a cached render (R55).
    out = render(r, uuid, "{{ %s }}{# %d #}" % (expr, time.time_ns()), target)
    return None if out is None else out.strip()


def truthy(v):
    return str(v).strip().lower() in ("true", "1", "yes")


_SCHEMA = {}


def tool_props(r, name):
    """Input property names of an MCP tool from tools/list (standard MCP; INFERRED shape result.tools[].inputSchema)."""
    if not _SCHEMA:
        try:
            resp = r.c.request("tools/list", {})
            for t in resp.get("result", {}).get("tools", []):
                _SCHEMA[t.get("name")] = set(((t.get("inputSchema") or {}).get("properties") or {}).keys())
        except Exception as e:      # noqa: BLE001
            r.log("  tools/list failed: %r" % e)
    return _SCHEMA.get(name, set())


def pick(props, *cands):
    for c in cands:
        if c in props:
            return c
    return cands[0]


def first_list(res):
    """The first list of dicts inside an MCP JSON result (shape INFERRED per tool)."""
    if isinstance(res, list):
        return res
    if isinstance(res, dict):
        for k in ("entries", "results", "items", "factions", "knowledge", "data", "records", "list"):
            if isinstance(res.get(k), list):
                return res[k]
        for v in res.values():
            if isinstance(v, list) and (not v or isinstance(v[0], dict)):
                return v
            if isinstance(v, dict):
                inner = first_list(v)
                if inner:
                    return inner
    return []


KV = re.compile(r"(\w+)=(\S*)")


def parse_kv(s):
    head, _, name = s.partition(" name=")
    d = dict(KV.findall(head))
    if name:
        d["name"] = name.strip()
    return d


def iv(d, k, dflt=-99):
    try:
        return int(float(d.get(k, dflt)))
    except (TypeError, ValueError):
        return dflt


def ctl_line(r, fn, args, pattern, timeout=15):
    t = tail("papyrus")
    r.ctl(fn, args)
    return t.wait(pattern, timeout=timeout)


def qr(r, fid):
    """Proposed IEB_TestCtl.QR: one line of guard inputs for one actor (see report)."""
    m = ctl_line(r, "QR", [s32(fid)], r"\[IEB-TEST\] QR (%s) (.*)" % fid_any_rx(fid))
    return parse_kv(m.group(2)) if m else None


def qscan(r, radius=3000.0):
    """Proposed IEB_TestCtl.QScan: every loaded NPC near the player with guard inputs and alias-quest class counts."""
    t = tail("papyrus")
    r.ctl("QScan", [float(radius)])
    if not t.wait(r"\[IEB-TEST\] QSCAN END", timeout=90):
        return []
    out = []
    for m in re.finditer(r"\[IEB-TEST\] QSCAN (\S+) (.*)", t.read()):
        if m.group(1) == "END":
            continue
        d = parse_kv(m.group(2))
        try:
            d["fid"] = fid_norm(m.group(1))
        except ValueError:
            continue
        if d["fid"] is None:
            continue
        out.append(d)
    return out


def rank(r, fid):
    """Proposed IEB_TestCtl.RankProbe: vanilla rank, SNRom_Bond tier, track, stored sync keys, points."""
    m = ctl_line(r, "RankProbe", [s32(fid)], r"\[IEB-TEST\] RANK (%s) (.*)" % fid_any_rx(fid))
    return parse_kv(m.group(2)) if m else None


def su_set(r, fid, key, val):
    return ctl_line(r, "SUSetInt", [s32(fid), key, int(val)], r"\[IEB-TEST\] SU (%s %s set=|REFUSED)"
                    % (fid_any_rx(fid), re.escape(key)))


def su_unset(r, fid, key):
    return ctl_line(r, "SUUnset", [s32(fid), key], r"\[IEB-TEST\] SU %s %s unset" % (fid_any_rx(fid), re.escape(key)))


def take_pat(name):
    return r"(?i)\[IEB\] TAKE actor=%s\b" % re.escape(name)


def errand(r, fid, name, dest, timeout=90):
    """StartTask GoToLocation (IEB_TestCtl.psc:49-87) and wait for the bridge TAKE (IEB_Main.psc:251/278/311)."""
    t = tail("papyrus")
    r.ctl("StartTask", [s32(fid), "GoToLocation", dest, "", ""])
    return t.wait(take_pat(name), timeout=timeout)


def recall(r, fid, name, timeout=120):
    """IEB_TestCtl.Recall stay=0 (IEB_Main.CancelOrRecall), wait for a terminal bridge line."""
    t = tail("papyrus")
    r.ctl("Recall", [s32(fid), 0])
    return t.wait(r"(?i)\[IEB\] (RELEASE\w*|REJOIN_DONE|REJOIN_TO_WAIT) actor=%s\b" % re.escape(name), timeout=timeout)


def watch_all(r, fid, text=None):
    """Watcher lines (IEB_Watcher.Line, IEB_Watcher.psc:85-147) for this actor in the test window, as dicts. The
    actor's FormID follows its name ('0xE1BA9', VERIFIED Papyrus.0.log 2026-10-10); matched in any printed form
    (fidnorm.fid_any_rx), signed or unsigned fid."""
    text = r.tails["watch"].read() if text is None else text
    rx = re.compile(fid_any_rx(fid))
    out = []
    for line in text.splitlines():
        if not line.startswith("rt=") and " rt=" not in line[:40]:
            continue
        if rx.search(line.split(" cell=")[0]):
            out.append(dict(KV.findall(line)))
    return out


def watch_last(r, fid, text=None):
    w = watch_all(r, fid, text)
    return w[-1] if w else None


def worn_rows(r, uuid):
    """(slot, formID, item name, body-area label) per worn item. Fields VERIFIED in base 0410_equipment.prompt:3-29
    (get_worn_equipment, item.formID, item.slot_body_area, get_item_name). Item names are not story text."""
    out = render(r, uuid, "{% for slot, item in get_worn_equipment(actorUUID) %}{{ slot }}|{{ item.formID }}|"
                          "{{ get_item_name(item.formID) }}|{{ item.slot_body_area }}\n{% endfor %}")
    if out is None:
        return None
    rows = []
    for line in out.splitlines():
        p = line.strip().split("|")
        if len(p) >= 4:
            rows.append(tuple(x.strip() for x in p[:4]))
    return rows


def body_flag(r, uuid):
    """1 if the actor wears a body garment, by the same expression 0412/0210 use. RV-58 (2026-10-10): SkyrimNet 25.1
    has no 'body' key; the body garment (slot 32: cuirass, armour, dress, robe) is keyed 'torso' (VERIFIED live:
    Uthgerd's cuirass, Jenassa's armour and Carlotta's dress all under 'torso'; a multi-slot dress is listed under each
    slot it covers, e.g. also 'forearms'). '.body' was always empty, so every NPC read as undressed."""
    out = render(r, uuid, "{%% if get_worn_equipment(actorUUID).torso %%}1{%% else %%}0{%% endif %%}{# %d #}" % time.time_ns())
    v = None if out is None else out.strip()
    return None if v not in ("0", "1") else int(v)


def to_formid(x):
    x = str(x).strip()
    try:
        v = int(x, 16) if x.lower().startswith("0x") or re.search(r"[A-Fa-f]", x) else int(x)
        return fid_norm(v)          # a signed (negative) id from JSON -> unsigned, so "%08X" stays valid
    except ValueError:
        return None


def equip_section(text):
    """Lines of the '### Worn Equipment' list in a rendered bio (heading VERIFIED 0410_equipment.prompt:2/37)."""
    if not text or "### Worn Equipment" not in text:
        return None
    seg = text.split("### Worn Equipment", 1)[1]
    rows = []
    for line in seg.splitlines()[1:]:
        s = line.strip()
        if s.startswith("#"):
            break
        if s.startswith("- "):
            rows.append(s)
    return rows


ATTIRE_MARK = "- Visible attire:"   # line prefix of our own layer file 0412 (shae.scene-text 0412:7), no story text


def snapshot_sync(r, fid):
    """IEB_TestCtl.Snapshot, waiting for its log line (MCP returns before Papyrus runs it; U1 run 14 B-10)."""
    t = game.Tail(game.LOGS["papyrus"])
    r.ctl("Snapshot", [fid])
    if not t.wait(r"\[IEB-TEST\] snapshot .*%s" % fid_any_rx(fid), 20):
        r.log("  WARN snapshot line for %s not seen within 20 s" % hx(fid))

def ensure_child_enrolled(r):
    """CS-20/21/22, RS-4 setup: Braith enrolled in Relationships (platonic; design §11.10 allows it). Enrollment by
    EnrollByHand (RELB EnrollByHand :942-968, EnrollNow :880-929, R6 locks intimacy at once). One LLM call, the child
    prompt ieb_snrom_author_child (R10, RELB:3693-3697). Returns (uuid, name) or (None, None)."""
    u, name, child = who(r, CHILD)
    if not u or not child:
        inc(r, "child (0x%s) not loaded or not IsChild" % hx(CHILD))
        return None, None
    if iv({"v": rval(r, u, 'get_faction_rank(actorUUID, "SNRom_Bond")')}, "v") >= 0:
        return u, name
    checkpoint(r, "child not enrolled in this save: the enrolment (one LLM call) is left to the real test")
    st, sn = tail("snrom"), tail("skyrimnet")
    rel(r, "EnrollByHand", [ah(CHILD)])
    m = st.wait(r"Enrolled by hand: %s\b" % re.escape(name), timeout=60)
    if not m:
        inc(r, "child enrollment line not seen in snrom.log within 60 s")
        return None, None
    r.log("  setup: child 0x%s enrolled by hand" % hx(CHILD))
    # Consumer proof (b) (consumer_proof_list.md): a fresh child enrolment must author with OUR child prompt.
    # Lines and counts only, never the authored text. snrom.log can lag (minutes), hence 300 s, not the list's 120 s.
    d = st.wait(r"Disposition authored for %s\b|Truncated child response for %s\b" % (re.escape(name), re.escape(name)), 300)
    t = sn.read()
    r.check(re.search(r"PromptTemplate='ieb_snrom_author_child'", t) is not None,
            "child enrolment sent PromptTemplate='ieb_snrom_author_child' (SkyrimNet.log)")
    r.check(re.search(r"PromptTemplate='snrom_author_disposition'", t) is None,
            "no adult snrom_author_disposition prompt for the child enrolment")
    r.check(re.search(r"Failed to render template 'ieb_snrom_author_child'", t) is None,
            "ieb_snrom_author_child rendered (no 'Failed to render template')")
    r.check(bool(d) and d.group(0).startswith("Disposition authored"),
            "snrom 'Disposition authored for %s' within 300 s (%s)" % (name, "seen" if d else "not seen"))
    return u, name


def romance(r, uuid, tries=3):
    """get_romance decorator JSON (RELD GetRomance :518-580). Contains authored prose: parsed, never logged.
    R55 (U1 run 18 CS-22): SkyrimNet can answer 'decorator cache miss ... returning empty'; an empty render is retried
    and, if still empty, returns None, which callers treat as INCONCLUSIVE, never as a FAIL."""
    for i in range(tries):
        out = render(r, uuid, "{{ get_romance(actorUUID) }}{# %d #}" % time.time_ns())
        try:
            if out:
                return json.loads(out)
        except ValueError:
            pass
        time.sleep(2)
    return None


def su_get(r, uuid, key, dflt=-99, fid=None):
    """StorageUtil int on the actor. R55: prefer the Papyrus-side SUGetInt wrapper (logs the value it read); else a
    template render made unique by a nonce so no cached render is reused. Every value read is logged."""
    if fid is not None:
        m = ctl_line(r, "SUGetInt", [s32(fid), key, dflt],
                     r"\[IEB-TEST\] SU (?:%s|none) %s get=(\S+)" % (fid_any_rx(fid), re.escape(key)), 10)
        if m:
            try:
                v = int(m.group(1))
                r.log("  su_get %s %s = %d (Papyrus)" % (hx(fid), key, v))
                return v
            except ValueError:
                pass
    v = rval(r, uuid, 'papyrus_util("GetIntValue", actorUUID, "%s", %d)' % (key, dflt))
    try:
        v = int(float(v))
    except (TypeError, ValueError):
        r.log("  su_get %s = unreadable (%r)" % (key, v))
        return None
    r.log("  su_get %s = %d (template)" % (key, v))
    return v


# ---------------------------------------------------------------------------- RV-123 (3) write read-backs
# Every console / MCP state write is read back before the test goes on. Positions: the same reads as
# tests_u2_wh.dist (CombatProbe dPlayer, actors only) and tests_u2_wh.where (PlayerWhere), inlined here so a call
# never imports a test module (an import registers its tests in block.TESTS; selftest's wiring check saw them).


def _dist(r, fid):
    m = ctl_line(r, "CombatProbe", [s32(fid)], r"\[IEB-TEST\] CombatProbe .*? combat=(\d).*? dPlayer=(\d+)", 10)
    return int(m.group(2)) if m else None


def near_player(r, fid, what, maxd=600, tries=3):
    """Read-back for '<ref>.moveto player', 'player.moveto <actor>', PlaceRel/MoveRel onto the player: the actor's
    distance to the player (CombatProbe dPlayer, as tests_u2_wh.dist). True, or INCONCLUSIVE (inc) and False. Logs the
    distance read."""
    d = None
    for i in range(tries):
        d = _dist(r, fid)
        if d is not None and d <= maxd:
            r.log("  read-back %s: %s at %d u from the player" % (what, hx(fid), d))
            return True
        time.sleep(2)
    inc(r, "read-back %s: %s is %s u from the player (want <= %d; RV-123 (3))"
        % (what, hx(fid), "no CombatProbe line" if d is None else d, maxd))
    return False


def player_pos(r):
    """PlayerWhere -> dict(cell, ws, x, y, z) or None (the same read as tests_u2_wh.where)."""
    m = ctl_line(r, "PlayerWhere", [], r"\[IEB-TEST\] PLAYERPOS cell=(\S+) ws=(\S+) x=(-?[\d.]+) y=(-?[\d.]+) z=(-?[\d.]+)", 15)
    if not m:
        return None
    return {"cell": m.group(1), "ws": m.group(2), "x": float(m.group(3)), "y": float(m.group(4)), "z": float(m.group(5))}


def player_moved(r, w0, what, mind=300.0):
    """Read-back for 'player.moveto <non-actor ref>' / 'coc <cell>': the player's cell changed or the position moved
    more than `mind` units from `w0` (player_pos before the write). True, or INCONCLUSIVE (inc) and False."""
    time.sleep(2)
    w1 = player_pos(r)
    if not w0 or not w1:
        inc(r, "read-back %s: no PLAYERPOS before/after (RV-123 (3))" % what)
        return False
    moved = ((w1["x"] - w0["x"]) ** 2 + (w1["y"] - w0["y"]) ** 2) ** 0.5
    if w1["cell"] != w0["cell"] or moved > mind:
        r.log("  read-back %s: cell %s -> %s, moved %d u" % (what, w0["cell"], w1["cell"], moved))
        return True
    inc(r, "read-back %s: player did not move (cell %s, %d u; RV-123 (3))" % (what, w1["cell"], moved))
    return False


def dm(r, payload):
    """Force a Story DM verdict through the DM's own entry point, OnDungeonMasterResponse(response, success)
    (patched StoryEngine :1375), so E1-E7 run exactly as for an LLM verdict. A plain member function: callable over
    MCP (INFERRED). should_act parsed by substring '"should_act": true' (VERIFIED IntelEngine-Native-Gerk
    SKSE/src/Papyrus.cpp:1831-1832); json.dumps writes exactly that. NOT the dashboard Director path (Core
    OnDashboardDispatchStory :2262), which bypasses E1."""
    p = {"should_act": True, "narration": "ieb test"}
    p.update(payload)
    return se(r, "OnDungeonMasterResponse", [json.dumps(p), 1])


def qprop(r, quest, script, prop):
    props = tool_props(r, "get_quest_property_value")
    res = r.tool("get_quest_property_value", {pick(props, "quest_editor_id", "questEditorId"): quest,
                                              pick(props, "script_name", "scriptName"): script,
                                              pick(props, "property_name", "propertyName"): prop})
    return retval(res)


def candidates(scan, **want):
    """Scanned actors outside the cast, adults, not teammates, filtered by exact int fields."""
    out = []
    for d in scan:
        if d["fid"] in CAST or iv(d, "child") != 0 or iv(d, "tm") != 0 or iv(d, "slot") >= 0:
            continue
        if all(iv(d, k) == v for k, v in want.items()):
            out.append(d)
    return out


# ============================================================================ D (spec §15.3; patch B §10.2)

@test("D-1", "D", reload=True)
def d1(r):
    """F1 held: Dispatch(F1, story) -> 'dispatch refused' (StoryEngine :1692-1694), MarkLastDispatchFailed (same
    block, no own log line: INFERRED from the adjacent DebugMsg), no new slot, I1 (watcher)."""
    u, name, _ = who(r, F1)
    if not name:
        return inc(r, "F1 not loaded")
    snapshot_sync(r, F1)
    checkpoint(r)
    if not errand(r, F1, name, DEST_NEAR):
        return inc(r, "no TAKE for F1 within 90 s")
    try:
        before = qr(r, F1)
        t = tail("papyrus")
        r.ctl("Dispatch", [F1, "story"])
        m = t.wait(r"Story DM: %s is busy or with the player - dispatch refused" % re.escape(name), timeout=20)
        r.check(bool(m), "Dispatch(F1, story) refused by patch B ('busy or with the player - dispatch refused')")
        time.sleep(4)
        after = qr(r, F1)
        r.check(before is not None and after is not None and iv(after, "slot") == iv(before, "slot"),
                "no new slot: F1 slot index unchanged (%s -> %s)" % (before and before.get("slot"), after and after.get("slot")))
        r.check(not re.search(r"Allocated slot .* for story", t.read()), "no 'Allocated slot ... for story' after the dispatch")
        w = watch_last(r, F1)
        r.check(w is not None and iv(w, "slotCount", 0) <= 1, "watcher slotCount <= 1 for F1 (I1)")
    finally:
        recall(r, F1, name)


@test("D-2", "D")
def d2(r):
    """F2 idle teammate: Dispatch(F2, social) -> off-screen summary only (StoryEngine :962-965), no slot."""
    u, name, _ = who(r, F2)
    if not name:
        return inc(r, "F2 not loaded")
    q = qr(r, F2)
    if not q or iv(q, "tm") != 1:
        return inc(r, "F2 is not a teammate at test start (tm=%s)" % (q and q.get("tm")))
    checkpoint(r)
    t = tail("papyrus")
    r.ctl("Dispatch", [F2, "social"])
    m = t.wait(r"NPC Social: %s is busy or with the player - off-screen only" % re.escape(name), timeout=20)
    r.check(bool(m), "Dispatch(F2, social) -> off-screen only")
    time.sleep(4)
    q2 = qr(r, F2)
    r.check(q2 is not None and iv(q2, "slot") < 0, "F2 holds no IntelEngine slot afterwards")
    r.check(not re.search(r"Allocated slot .* for npc_social", t.read()), "no 'Allocated slot ... for npc_social'")


# ============================================================================ Q (spec §10.2.1)

@test("Q-1", "Q")
def q1(r):
    """IEB_QuestReserved true for an NPC aliased in a running story quest; false for one aliased only by Dialogue*/WI*.
    Chosen by the QScan wrapper instead of sqv (no text read). Also: t1 agrees with its own inputs for every NPC.
    Core case re-based (REVIEW_LOG R51): the synthetic IEB_TestStoryQuest (ErrandBridgeTest.esp 0x820, type 8; in the
    TEST build's story_quests only, quest_integrity_builder --test-story-quest) filled onto Fralia by QPFill -> reserved;
    cleared by QPClear -> not reserved. Never relies on where real story-aliased NPCs happen to be loaded."""
    def fralia(scan):
        return next((d for d in scan if d["fid"] == fid_norm(FRALIA)), None)

    con(r, "player.moveto %08X" % CARLOTTA)     # market: Fralia's stall is within the 3000-unit scan by day
    time.sleep(8)
    at_market = near_player(r, CARLOTTA, "player.moveto Carlotta (market)")
    before = fralia(qscan(r)) if at_market else None
    if not at_market:
        pass            # INCONCLUSIVE already counted by the read-back; the generic scan below still runs
    elif not before:
        inc(r, "Fralia 0x%s not in QScan range" % hx(FRALIA))
    elif iv(before, "story") > 0 or iv(before, "t1") != 0:
        inc(r, "Fralia already story-aliased or reserved before QPFill (story=%s t1=%s)" % (before.get("story"), before.get("t1")))
    else:
        checkpoint(r)
        try:
            r.ctl("QPFill", [FRALIA])
            time.sleep(2)
            filled = fralia(qscan(r))
            if not filled or iv(filled, "story") < 1:     # RV-123 (3): read back the QPFill write first
                inc(r, "read-back QPFill: Fralia not in the test story quest alias (story=%s)" % (filled and filled.get("story")))
            else:
                r.check(iv(filled, "story") >= 1 and iv(filled, "t1") == 1,
                        "test story quest alias -> IEB_QuestReserved(tier 1) true for Fralia (story=%s t1=%s)"
                        % (filled.get("story"), filled.get("t1")))
        finally:
            r.ctl("QPClear", [])
            time.sleep(2)
        cleared = fralia(qscan(r))
        if not cleared or iv(cleared, "story") != 0:      # RV-123 (3): read back the QPClear write (Q-1 is reload=False)
            inc(r, "read-back QPClear: Fralia still in a story alias (story=%s)" % (cleared and cleared.get("story")))
        else:
            r.check(iv(cleared, "story") == 0 and iv(cleared, "t1") == 0,
                    "after QPClear -> not reserved (story=%s t1=%s)" % (cleared.get("story"), cleared.get("t1")))
    checkpoint(r)       # setup-only: reached here only after a Fralia precondition miss (SETUP FAIL with its reason)
    scan = qscan(r)
    if not scan:
        return inc(r, "QScan returned nothing")
    r.log("  scanned %d NPCs" % len(scan))
    story = [d for d in scan if iv(d, "story") > 0 and d["fid"] != PLAYER]
    dlg = [d for d in scan if iv(d, "dlgwi") > 0 and iv(d, "story") == 0 and iv(d, "open") == 0
           and iv(d, "other") == 0 and iv(d, "favorbq") == 0 and iv(d, "scene") == 0]
    if story:
        d = story[0]
        r.check(iv(d, "t1") == 1, "story-aliased NPC 0x%s: IEB_QuestReserved(tier 1) true" % hx(d["fid"]))
    else:
        inc(r, "no loaded NPC holds an alias in a running story_quests quest")
    if dlg:
        d = dlg[0]
        r.check(iv(d, "t1") == 0, "Dialogue*/WI*-only NPC 0x%s: IEB_QuestReserved(tier 1) false" % hx(d["fid"]))
    else:
        inc(r, "no loaded NPC aliased only by Dialogue*/WI* quests")
    bad = [d for d in scan if iv(d, "t1") != int(iv(d, "story") > 0 or iv(d, "open") > 0 or iv(d, "scene") > 0)]
    r.check(not bad, "t1 == (story alias or open objective or scene) for all %d scanned (%d disagree: %s)"
            % (len(scan), len(bad), ",".join("0x" + hx(d["fid"]) for d in bad[:5])))


@test("Q-2", "Q", reload=True)
def q2(r):
    """Favor/BQ job started by setstage (time plan INFERRED route): the giver is reserved while the objective shows,
    released after completion. Report FormIDs, stage numbers and counts only."""
    qid, edid, start, done = FAVOR_Q

    def qalias():
        t = tail("papyrus")
        r.ctl("QAlias", [qid])
        if not t.wait(r"\[IEB-TEST\] QALIAS \S+ running=", timeout=15):
            return None, []
        time.sleep(1)
        txt = t.read()
        head = re.search(r"\[IEB-TEST\] QALIAS \S+ (running=.*)", txt)
        actors = [fid_norm(m.group(1)) for m in re.finditer(r"\[IEB-TEST\] QALIAS \S+ alias=\d+ actor=((?:0x)?[0-9A-Fa-f]+)", txt)]
        return (parse_kv(head.group(1)) if head else None), actors

    h0, _ = qalias()
    if not h0:
        return inc(r, "QAlias wrapper gave no line for quest 0x%s" % hx(qid))
    if iv(h0, "running") == 1 or iv(h0, "completed") == 1:
        return inc(r, "quest 0x%s already running or completed in T0 (running=%s completed=%s)"
                   % (hx(qid), h0.get("running"), h0.get("completed")))
    checkpoint(r)
    con(r, "setstage %s %d" % (edid, start))
    time.sleep(4)
    h1, actors = qalias()
    actors = [a for a in actors if a != PLAYER]
    if not h1 or iv(h1, "running") != 1 or not actors:
        return inc(r, "quest 0x%s did not start or filled no NPC alias (running=%s, actors=%d)"
                   % (hx(qid), h1 and h1.get("running"), len(actors)))
    shown = [x for x in (h1.get("objShown") or "").split(",") if x]
    r.log("  quest 0x%s stage %s, objectives shown %s, alias actors %s"
          % (hx(qid), h1.get("stage"), shown, ",".join("0x" + hx(a) for a in actors)))
    if not shown:
        return inc(r, "stage %d displayed no objective (fragment INFERRED); the open-objective rule cannot be judged" % start)
    during = {a: qr(r, a) for a in actors}
    held = [a for a, d in during.items() if d and iv(d, "t1") == 1]
    r.check(bool(held), "an alias NPC is reserved (tier 1) while an objective is shown (%d of %d)" % (len(held), len(actors)))
    con(r, "setstage %s %d" % (edid, done))
    time.sleep(4)
    h2, _ = qalias()
    if h2 and iv(h2, "running") == 1 and iv(h2, "completed") != 1:
        con(r, "stopquest %s" % edid)
        time.sleep(2)
        h2, _ = qalias()
    r.log("  after stage %d: running=%s completed=%s" % (done, h2 and h2.get("running"), h2 and h2.get("completed")))
    if not h2 or (iv(h2, "running") == 1 and iv(h2, "completed") != 1):     # RV-123 (3): setstage/stopquest read-back
        return inc(r, "read-back setstage %d / stopquest: quest 0x%s still running, not completed (running=%s completed=%s)"
                   % (done, hx(qid), h2 and h2.get("running"), h2 and h2.get("completed")))
    for a in held:
        d = qr(r, a)
        other = d is not None and (iv(d, "story") > 0 or iv(d, "open") > 0 or iv(d, "scene") > 0)
        if d is None:
            r.check(False, "QR after completion for 0x%s" % hx(a))
        elif other:
            r.log("  NOTE 0x%s still reserved by %s other quest(s); released from this one is judged by the count"
                  % (hx(a), iv(d, "story") + iv(d, "open")))
            r.check(iv(d, "open") < iv(during[a], "open") or iv(d, "story") < iv(during[a], "story"),
                    "0x%s: one fewer reserving alias after completion" % hx(a))
        else:
            r.check(iv(d, "t1") == 0, "0x%s released (tier 1 false) after completion" % hx(a))


def _reserved_target(r, scan):
    c = [d for d in candidates(scan, t1=1, busy=0)]
    return c[0] if c else None


def dm_verdict(t, name, stype, timeout=30):
    """First Story DM verdict line for this NPC (OnDungeonMasterResponse, StoryEngine :1475-1518). Returns
    'e1' (refused at E1), another short reason, or None. Line texts VERIFIED in the patched source."""
    m = t.wait(r"Story DM(?:: (?:%s (?P<v>is committed to a quest - %s refused|is high-status|rejected . hold restriction|"
               r"on cooldown|already in player's cell)|NPC '%s' not found)| \[%s\]: %s)"
               % (re.escape(name), stype, re.escape(name), stype, re.escape(name)), timeout=timeout)
    if not m:
        return None
    v = m.group("v") or ""
    if v.startswith("is committed"):
        return "e1"
    if "[%s]" % stype in m.group(0):
        return "dispatched"
    return (v or "not found").split(" ")[0] + "..."


def partial(r, what):
    """A spec sub-check this module cannot automate: logged, listed in the agent report; not counted as a failure."""
    r.log("PARTIAL %s not automated: %s" % (r.name, what))


@test("Q-3", "Q", reload=True)
def q3(r):
    """DM forced onto a reserved NPC: E1 refuses with MarkLastDispatchFailed('npc is committed to a quest')
    (StoryEngine :1512-1518); the cooldown was stamped first (ApplyCooldownCheck :1507), so a second pick is refused
    'on cooldown' (:1507-1510). The native pools' own skip during the cooldown is not observable here (INFERRED)."""
    d = _reserved_target(r, qscan(r))
    if not d:
        return inc(r, "no reserved, non-teammate adult loaded")
    checkpoint(r)
    name = d.get("name", "")
    t = tail("papyrus")
    dm(r, {"type": "seek_player", "npc": name})
    v = dm_verdict(t, name, "seek_player")
    if v is None:
        return inc(r, "no Story DM verdict line within 30 s for 0x%s" % hx(d["fid"]))
    if v != "e1":
        r.check(v != "dispatched", "reserved NPC 0x%s was not dispatched" % hx(d["fid"]))
        return inc(r, "0x%s rejected before E1 (%s)" % (hx(d["fid"]), v))
    r.check(True, "E1 refused the reserved NPC 0x%s (committed to a quest)" % hx(d["fid"]))
    t2 = tail("papyrus")
    dm(r, {"type": "seek_player", "npc": name})
    r.check(bool(t2.wait(r"Story DM: %s on cooldown" % re.escape(name), timeout=30)),
            "second pick of 0x%s refused 'on cooldown' (cooldown stamped before E1)" % hx(d["fid"]))
    q = qr(r, d["fid"])
    r.check(q is not None and iv(q, "slot") < 0, "no slot for 0x%s" % hx(d["fid"]))


@test("Q-4", "Q", reload=True)
def q4(r):
    """quest/rescue with a reserved/essential victim: rejected by E2 before QuestActive (StoryEngine :3114-3118, before
    :3273); QuestActive false; crime factions intact (victim and giver, before/after)."""
    scan = qscan(r)
    giv = candidates(scan, t1=0, busy=0)
    vic = [d for d in candidates(scan, t2=1, busy=0)]
    if not giv or not vic:
        return inc(r, "need a non-reserved giver and a reserved/essential victim (have %d, %d)" % (len(giv), len(vic)))
    g, v = giv[0], next((x for x in vic if x["fid"] != giv[0]["fid"]), None)
    if v is None:
        return inc(r, "no distinct victim")
    gq0, vq0 = qr(r, g["fid"]), qr(r, v["fid"])
    checkpoint(r)
    t = tail("papyrus")
    dm(r, {"type": "quest", "npc": g.get("name", ""), "questSubType": "rescue", "victimName": v.get("name", ""),
           "questLocation": "Halted Stream Camp", "enemyType": "bandits", "msgContent": "Please help.", "sender": ""})
    m = t.wait(r"(quest/rescue rejected -- victim '.*' is committed to a quest|is committed to a quest - quest refused|"
               r"C\+\+ validation rejected|quest rejected|victim '.*' not found)", timeout=30)
    if not m:
        return inc(r, "no quest verdict line within 30 s")
    if "victim" not in m.group(1) or "committed" not in m.group(1):
        return inc(r, "rejected elsewhere before E2: %s" % m.group(1)[:40])
    r.check(True, "E2 rejected the rescue: victim 0x%s is committed to a quest" % hx(v["fid"]))
    qa = qprop(r, "IntelEngine", "IntelEngine_StoryEngine", "QuestActive")
    r.check(qa is not None and not truthy(qa), "StoryEngine.QuestActive is false (%s)" % qa)
    gq1, vq1 = qr(r, g["fid"]), qr(r, v["fid"])
    r.check(bool(gq0 and gq1 and vq0 and vq1) and gq0.get("crime") == gq1.get("crime") and vq0.get("crime") == vq1.get("crime"),
            "crime factions unchanged (giver %s, victim %s)" % (gq1 and gq1.get("crime"), vq1 and vq1.get("crime")))


@test("Q-5", "Q", reload=True)
def q5(r):
    """road_encounter naming (a) a held follower and (b) a reserved NPC: refused at E1 (StoryEngine :1512-1518),
    which closes the road_encounter hole (no slot, so the §10.2 backstop never saw it)."""
    u, name, _ = who(r, F1)
    if not name:
        return inc(r, "F1 not loaded")
    checkpoint(r)
    if not errand(r, F1, name, DEST_NEAR):
        return inc(r, "no TAKE for F1")
    try:
        t = tail("papyrus")
        dm(r, {"type": "road_encounter", "npc": name, "destination": "Whiterun"})
        v = dm_verdict(t, name, "road_encounter")
        if v is None:
            inc(r, "(a) no verdict line for held F1")
        elif v == "e1":
            r.check(True, "(a) road_encounter naming held F1 refused at E1")
        else:
            r.check(v != "dispatched", "(a) held F1 was not placed as a road encounter")
            inc(r, "(a) F1 rejected before E1 (%s)" % v)
    finally:
        recall(r, F1, name)
    d = _reserved_target(r, qscan(r))
    if not d:
        return inc(r, "(b) no reserved, non-teammate adult loaded")
    t = tail("papyrus")
    dm(r, {"type": "road_encounter", "npc": d.get("name", ""), "destination": "Whiterun"})
    v = dm_verdict(t, d.get("name", ""), "road_encounter")
    if v is None:
        return inc(r, "(b) no verdict line")
    if v != "e1":
        r.check(v != "dispatched", "(b) reserved 0x%s was not placed as a road encounter" % hx(d["fid"]))
        return inc(r, "(b) 0x%s rejected before E1 (%s)" % (hx(d["fid"]), v))
    r.check(True, "(b) road_encounter naming reserved 0x%s refused at E1" % hx(d["fid"]))


@test("Q-6", "Q", reload=True)
def q6(r):
    """Ambush and rescue victim on NON-reserved NPCs: ActorBase.IsEssential unchanged before/after (ambush writes the
    base flag at :2900 then false at the end); record whether Actor.IsEssential shows alias-only essential.
    INFERRED: CleanupStoryDispatch / CleanupQuest (member functions) end the beats; the beats run real combat and
    move the victim, so the test reloads afterwards."""
    scan = qscan(r)
    pool = candidates(scan, t2=0, busy=0, ess=0, baseEss=0, prot=0)
    if len(pool) < 3:
        return inc(r, "need 3 non-reserved, non-essential adults (have %d)" % len(pool))
    amb, giver, vic = pool[0], pool[1], pool[2]
    checkpoint(r)
    # --- ambush
    b0 = qr(r, amb["fid"])
    t = tail("papyrus")
    dm(r, {"type": "ambush", "npc": amb.get("name", "")})
    m = t.wait(r"Story DM \[ambush\]|is committed to a quest - ambush refused|rejecting ambush|C\+\+ validation rejected|"
               r"hold restriction|on cooldown|is high-status", timeout=30)
    if not m or "[ambush]" not in m.group(0):
        inc(r, "ambush not dispatched (%s)" % (m.group(0)[:30] if m else "no line"))
    else:
        seen_ess = seen_base = 0
        end = time.time() + 180
        while time.time() < end:
            d = qr(r, amb["fid"])
            if d:
                seen_ess = max(seen_ess, iv(d, "ess", 0))
                seen_base = max(seen_base, iv(d, "baseEss", 0))
            time.sleep(10)
        se(r, "CleanupStoryDispatch", [])
        con(r, "%s.stopcombat" % hx(amb["fid"]))
        time.sleep(3)
        cp = ctl_line(r, "CombatProbe", [s32(amb["fid"])], r"\[IEB-TEST\] CombatProbe .*? combat=(\d)", 10)
        if not cp or cp.group(1) != "0":      # RV-123 (3): stopcombat read-back (the rescue half follows)
            inc(r, "read-back %s.stopcombat: 0x%s combat=%s" % (hx(amb["fid"]), hx(amb["fid"]), cp.group(1) if cp else "no line"))
        b1 = qr(r, amb["fid"])
        r.log("  ambush 0x%s: during ess=%d baseEss=%d" % (hx(amb["fid"]), seen_ess, seen_base))
        r.check(b0 is not None and b1 is not None and b0.get("baseEss") == b1.get("baseEss"),
                "ambush: ActorBase.IsEssential unchanged (%s -> %s)" % (b0 and b0.get("baseEss"), b1 and b1.get("baseEss")))
    # --- rescue victim
    v0 = qr(r, vic["fid"])
    t = tail("papyrus")
    dm(r, {"type": "quest", "npc": giver.get("name", ""), "questSubType": "rescue", "victimName": vic.get("name", ""),
           "questLocation": "Halted Stream Camp", "enemyType": "bandits", "msgContent": "Please help.", "sender": ""})
    time.sleep(20)
    qa = qprop(r, "IntelEngine", "IntelEngine_StoryEngine", "QuestActive")
    if not truthy(qa):
        return inc(r, "rescue quest did not become active (QuestActive=%s); victim flags not exercised" % qa)
    vd = qr(r, vic["fid"])
    se(r, "CleanupQuest", [])
    time.sleep(5)
    v1 = qr(r, vic["fid"])
    r.log("  victim 0x%s: during ess=%s baseEss=%s" % (hx(vic["fid"]), vd and vd.get("ess"), vd and vd.get("baseEss")))
    r.check(v0 is not None and v1 is not None and v0.get("baseEss") == v1.get("baseEss"),
            "victim: ActorBase.IsEssential unchanged (%s -> %s)" % (v0 and v0.get("baseEss"), v1 and v1.get("baseEss")))


@test("Q-7", "Q", reload=True)
def q7(r):
    """Message with a meeting from a reserved sender: delivered, no meeting (E4, StoryEngine OnMessageArrived
    :2686-2688). The messenger is chosen natively (FindMessengerForSender) and walks to the player."""
    d = _reserved_target(r, qscan(r))
    if not d:
        return inc(r, "no reserved, non-teammate adult loaded as sender")
    checkpoint(r)
    t = tail("papyrus")
    dm(r, {"type": "message", "npc": d.get("name", ""), "sender": d.get("name", ""),
           "msgContent": "Come and see me when you have a moment.", "destination": "The Bannered Mare",
           "meetTime": "evening"})
    m = t.wait(r"Story message: (meeting skipped -- .* is committed to a quest|rejected -- .*)|validation rejected", timeout=8 * 60)
    if not m:
        return inc(r, "no message outcome within 8 min (messenger may still be walking)")
    if not m.group(1) or not m.group(1).startswith("meeting skipped"):
        return inc(r, "message not delivered: %s" % (m.group(0)[:30]))
    r.check(True, "delivered; meeting skipped for reserved sender 0x%s" % hx(d["fid"]))
    r.check(not re.search(r"ScheduleMeeting|meeting scheduled", t.read(), re.I), "no meeting scheduled afterwards")


@test("Q-8", "Q")
def q8(r):
    """Assassination E7 (Battle :1345-1346): counts of staged / cancelled / triggered attempts in this session's
    Papyrus log (whole file, not just this test). Survival and each target's essential state are NOT judged here
    (no FormIDs in those lines); the soak counts more (time plan R7)."""
    p = game.LOGS["papyrus"]
    txt = open(p, "rb").read().decode("utf-8", "replace") if os.path.exists(p) else ""
    staged = len(re.findall(r"Battle: Assassin .* walking toward ", txt))
    cancelled = len(re.findall(r"Battle: assassination target .* is committed to a quest -- aborting", txt))
    triggered = len(re.findall(r"Battle: Assassination attack triggered on ", txt))
    r.log("  assassination attempts this session: staged=%d cancelled=%d triggered=%d" % (staged, cancelled, triggered))
    if staged + cancelled == 0:
        return inc(r, "no assassination attempt in this session (counted again over the soak)")
    r.check(triggered <= staged, "every triggered attack was staged first (%d <= %d)" % (triggered, staged))
    partial(r, "survival and each target's reserved/essential state (log lines carry names, not FormIDs)")
    checkpoint(r)       # read-only log count: setup-only runs it in full


# ============================================================================ REL (spec §15.3; Relationships 2.0.1)

@test("REL-1", "REL", reload=True)
def rel1(r):
    """E (F1) with an owed consent question goes on an errand and returns; the question fires at < 600 u during the
    rejoin phase or after (PumpAskQueue requires distance < 600, RELB:3818-3824); no error; bridge state unaffected.
    Forced owed: SNRom_AskPending = 1 set while F1 is away (an adult). The modal box (OpenPendingBox, RELB:3866-3915)
    would pause the game for the rest of the unattended block, so after the 'raising the question' line F1 is
    disabled for a moment: OpenPendingBox then drops the box ('no longer present', RELB:3884-3889). INFERRED that a
    console disable lands inside the 6 s voice lead (askVoiceSeconds default 6.0, RELB:3769)."""
    u, name, _ = who(r, F1)
    if not name:
        return inc(r, "F1 not loaded")
    if iv({"v": rval(r, u, 'get_faction_rank(actorUUID, "SNRom_Bond")')}, "v") < 0:
        return inc(r, "F1 is not enrolled (E must be enrolled)")
    snapshot_sync(r, F1)
    checkpoint(r)
    if not errand(r, F1, name, DEST_NEAR):
        return inc(r, "no TAKE for F1")
    st = tail("snrom")
    pt = tail("papyrus")
    try:
        end = time.time() + 120
        while time.time() < end:
            w = watch_last(r, F1)
            if w and (w.get("dPlayer") == "NA" or iv(w, "dPlayer", 0) > 700):
                break
            time.sleep(3)
        else:
            return inc(r, "F1 never got 700 u away during the errand")
        su_set(r, F1, "SNRom_AskPending", 1)
        su_unset(r, F1, "SNRom_LastAskAttempt")
        su_unset(r, F1, "SNRom_AskAttempts")
        ask = (su_get(r, u, "SNRom_AskPending", fid=F1), su_get(r, u, "SNRom_LastAskAttempt", fid=F1),
               su_get(r, u, "SNRom_AskAttempts", fid=F1))
        if ask != (1, -99, -99):            # RV-123 (3): read back the forced 'owed' state (-99 = unset)
            return inc(r, "read-back: AskPending/LastAskAttempt/AskAttempts = %s, want (1, unset, unset)" % (ask,))
        if not pt.wait(r"(?i)\[IEB\] (REJOIN_WAIT|RELEASE\w*|REJOIN_DONE) actor=%s\b" % re.escape(name), timeout=10 * 60):
            return inc(r, "errand did not end within 10 min")
        m = st.wait(r"%s is raising the question in her own words" % re.escape(name), timeout=10 * 60)
        if not m:
            return inc(r, "question not raised within 10 min after the errand ended")
        con(r, "%s.disable" % hx(F1))
        w = watch_last(r, F1)
        r.check(True, "owed question fired after the errand (PumpAskQueue gate: < 600 u); last watcher dPlayer=%s"
                % (w and w.get("dPlayer")))
        dropped = st.wait(r"Dropped the question for %s|Question on screen for %s" % (re.escape(name), re.escape(name)), timeout=20)
        con(r, "%s.enable" % hx(F1))
        for _ in range(3):                  # RV-123 (3): enable read-back (Recall and Check below need F1 back)
            time.sleep(2)
            ld = ctl_line(r, "Probe", [s32(F1)], r"\[IEB-TEST\] probe .*%s cell=\S* loaded=(\d)" % fid_any_rx(F1), 10)
            if ld and ld.group(1) == "1":
                break
        else:
            inc(r, "read-back %s.enable: F1 not loaded again (loaded=%s)" % (hx(F1), ld.group(1) if ld else "no probe"))
        if not dropped:                     # RV-123 (3): the disable's effect (the box dropped) read back
            inc(r, "read-back %s.disable: neither 'Dropped the question' nor 'Question on screen' within 20 s" % hx(F1))
        if dropped and "on screen" in dropped.group(0):
            r.log("  BOX ON SCREEN: one key press needed (the game is paused until answered)")
            inc(r, "box opened before the disable landed")
        txt = r.tails["papyrus"].read()
        r.check(not re.search(r"(?i)\[IEB\] ERROR", txt), "no [IEB] ERROR line")
        r.check(not re.search(r" L1 .*%s" % re.escape(name), st.read()), "no Relationships error line for F1")
    finally:
        recall(r, F1, name)
    time.sleep(5)
    c = ctl_line(r, "Check", [F1], r"\[IEB-TEST\] Check .* -> (\w+)")
    r.check(bool(c) and c.group(1).upper() == "TRUE", "bridge invariants hold for F1 afterwards (IEB_TestCtl.Check)")


@test("REL-2", "REL", reload=True)
def rel2(r):
    """A newly recruited (not yet enrolled) follower runs an errand during the 2 h waiting period: enrollment
    completes while away (2 LLM calls logged: disposition authoring + seed read), CurrentFollowerFaction stays 0.
    Recruit through SA's own SetCompanion function (layer ieb.errandbridge setcompanion.yaml -> SeverActions /
    SeverActions_FollowerManager / RegisterFollower, SA FollowerManager.psc:3460). The 2-game-hour wait is real
    (6 min at timescale 20, no acceleration); then CheckPendingEnrollments and SeedNextActor are called directly
    instead of waiting for the housekeeping cadence (INFERRED equivalent: same functions, RELB:6762-6764)."""
    rid = None
    for fid in (YSOLDA, FRALIA):
        u, name, ch = who(r, fid)
        if u and name and not ch and iv({"v": rval(r, u, 'get_faction_rank(actorUUID, "SNRom_Bond")')}, "v") < 0:
            rid = fid
            break
    if rid is None:
        return inc(r, "no loaded, not-enrolled adult recruit candidate")
    qf(r, "SeverActions", "SeverActions_FollowerManager", "RegisterFollower", [ah(rid)])
    time.sleep(5)
    if not truthy(rval(r, u, "is_follower(actorUUID)")):
        return inc(r, "recruit 0x%s is not a follower after RegisterFollower" % hx(rid))
    checkpoint(r)
    st = tail("snrom")
    rel(r, "SweepFollowers", [])
    t_recruit = time.time()
    if not errand(r, rid, name, DEST_FAR):
        return inc(r, "no TAKE for the recruit")
    try:
        time.sleep(max(0, 6.5 * 60 - (time.time() - t_recruit)))
        rel(r, "CheckPendingEnrollments", [])
        m1 = st.wait(r"Disposition authoring requested for %s" % re.escape(name), timeout=90)
        rel(r, "SeedNextActor", [])
        m2 = st.wait(r"Seed assessment sent for %s" % re.escape(name), timeout=90)
        w = watch_last(r, rid)
        away = w is not None and (w.get("dPlayer") == "NA" or iv(w, "dPlayer", 0) > 1500 or w.get("loaded") == "0")
        r.check(bool(m1), "enrollment authored while away: disposition call logged")
        r.check(bool(m2), "seed read call logged")
        if not away:
            inc(r, "recruit was not clearly away at enrollment (dPlayer=%s)" % (w and w.get("dPlayer")))
        cffs = {l.get("cff") for l in watch_all(r, rid) if l.get("cff") is not None}
        r.check(cffs == {"0"}, "CurrentFollowerFaction stayed 0 in every watcher line (%s)" % sorted(cffs))
    finally:
        recall(r, rid, name)


@test("REL-3", "REL")
def rel3(r):
    """Load log: SkyrimNet registered the Relationships layer; snrom.log 'Content layer loaded - RomanceMarkMoment is
    registered' after the last 'Bridge ready'. The 'Registered newly discovered external layer' line is printed only
    on first discovery (VERIFIED absent from today's SkyrimNet.log), so ContentLayerScanner's 'Scanned external layer'
    line (VERIFIED SkyrimNet.log 2026-10-10 :343) is accepted as the equivalent and reported."""
    sn = open(game.LOGS["skyrimnet"], "rb").read().decode("utf-8", "replace") if os.path.exists(game.LOGS["skyrimnet"]) else ""
    newly = "Registered newly discovered external layer 'deadohiosky48.relationships'" in sn
    scanned = "external layer 'deadohiosky48.relationships'" in sn
    r.log("  SkyrimNet.log: newly-discovered line %s; scanned line %s" % (newly, scanned))
    r.check(newly or scanned, "SkyrimNet.log names layer deadohiosky48.relationships at load")
    txt = open(SNROM, "rb").read().decode("utf-8", "replace") if os.path.exists(SNROM) else ""
    # The mod logs the content-layer line just BEFORE "Bridge ready" in each load (snrom.log 2026-10-10 :434-435,
    # Claude review after the shakedown), so look in the last load's block: after the previous "Bridge ready".
    last_ready = txt.rfind("Bridge ready")
    prev_ready = txt.rfind("Bridge ready", 0, last_ready) if last_ready > 0 else -1
    seg = txt[prev_ready + 1:last_ready] if last_ready >= 0 else ""
    r.check("Content layer loaded - RomanceMarkMoment is registered" in seg,
            "snrom.log: content layer loaded in the latest load (before its 'Bridge ready')")
    checkpoint(r)       # read-only log check: setup-only runs it in full


# ============================================================================ CS (spec §11.10.4; gates must HOLD)

@test("CS-20", "CS")
def cs20(r):
    """Enrolled child: force a spark check, raise the consent question, AcceptRomance, offer RomanceBeginSpark ->
    each refused. Calls only the gated entry points; never AssessSpark/OpenAsk directly (those would send a romance
    prompt about a child). Log lines naming IsChild exist only for AcceptRomance (RELB:2004-2006) and ApplySpark
    (RELB:7595-7597); BeginSpark refuses an enrolled actor first (RELB:413-416), CheckRomanceQuestion and
    RequestSparkNow refuse silently (SparkDecided / RomanceOk) - checked by state instead."""
    u, name = ensure_child_enrolled(r)
    if not u:
        return
    # R55: CS-20 asserted refusals only; a stale {"enrolled": false} would have passed its "not sparked" check.
    rom = romance(r, u)
    if rom is None:
        return inc(r, "prompt JSON empty after 3 tries: enrollment and lock not confirmed")
    checkpoint(r)
    r.check(bool(rom.get("enrolled")), "child is enrolled per the prompt JSON (enrolled=%s)" % rom.get("enrolled"))
    r.check(iv(rom, "physMinTier") == -1, "child intimacy locked: prompt JSON physMinTier -1 (got %s)" % iv(rom, "physMinTier"))
    r.check(su_get(r, u, "SNRom_PhysMinTier", fid=CHILD) == -1, "child intimacy locked in the store (-1)")
    st = tail("snrom")
    # 1. spark check: RequestSparkNow (out of turn) and one AssessNextSpark tick
    rel(r, "RequestSparkNow", [ah(CHILD)])
    rel(r, "AssessNextSpark", [])
    time.sleep(5)
    r.check(not re.search(r"(Spark assessment sent for|Asking the spark assessor about) %s\b" % re.escape(name), st.read()),
            "spark check: no spark assessment sent for the child")
    # 1b. an assessor reply in flight: ApplySpark refused (R2)
    t = tail("snrom")
    rel(r, "ApplySpark", [ah(CHILD), "ieb test"])
    r.check(bool(t.wait(r"ApplySpark refused: IsChild", timeout=20)), "ApplySpark refused, log names IsChild")
    # 2. consent question: CheckRomanceQuestion must not mark it owed
    rel(r, "CheckRomanceQuestion", [ah(CHILD)])
    time.sleep(3)
    r.check(su_get(r, u, "SNRom_AskPending", 0) == 0 and not re.search(r"Question owed to %s\b" % re.escape(name), st.read()),
            "consent question not owed (SNRom_AskPending 0, no 'Question owed' line)")
    # 3. AcceptRomance (R3)
    t = tail("snrom")
    rel(r, "AcceptRomance", [ah(CHILD)])
    r.check(bool(t.wait(r"AcceptRomance refused for %s: IsChild" % re.escape(name), timeout=20)),
            "AcceptRomance refused, log names IsChild")
    # 4. RomanceBeginSpark: not offered to the child; a direct BeginSpark does nothing
    e, _ = eligible(r.tool("check_action_eligibility", {"action_name": "RomanceBeginSpark", "actor_uuid": u}))
    r.check(e is False, "RomanceBeginSpark not eligible for the child")
    t = tail("snrom")
    rel(r, "BeginSpark", [ah(CHILD), "ieb test"])
    if not t.wait(r"BeginSpark (on already-enrolled|declined for) %s" % re.escape(name), timeout=15):
        inc(r, "BeginSpark: no 'on already-enrolled / declined' line, the call is not confirmed (RV-123 (3))")
    rom = romance(r, u)
    r.check(rom is not None and iv(rom, "sparked", 0) == 0, "child still not sparked")
    r.check(su_get(r, u, "SNRom_PlayerStance", -99) in (-99, 0), "no player stance on the child")
    r.log("  NOTE spec says 'log lines name IsChild' for all four; only AcceptRomance and ApplySpark log it (see report)")


@test("CS-21", "CS")
def cs21(r):
    """Enrolled child, points past Confidant through the real award path (ApplyDepth, RELB:1547): not held (child is
    'judged platonic', SparkDecided 1, RELB:1937-1939), climbs; bond prompt on the platonic ladder (0330 renders the
    platonic branch iff sparked != 1, 0330_relationships_bond.prompt:104)."""
    u, name = ensure_child_enrolled(r)
    if not u:
        return
    k0 = rank(r, CHILD)
    if not k0:
        return inc(r, "RankProbe gave no line")
    checkpoint(r)
    target = 2100
    st = tail("snrom")
    rel(r, "ApplyDepth", [ah(CHILD), target - iv(k0, "pts", 0), "ieb test", False, "test"])
    time.sleep(4)
    k1 = rank(r, CHILD)
    r.check(k1 is not None and iv(k1, "pts") == target, "points reached %d (%s)" % (target, k1 and k1.get("pts")))
    r.check(not re.search(r"Held .* short of Lover for %s\b" % re.escape(name), st.read()), "no 'Held ... short of Lover' for the child")
    r.check(su_get(r, u, "SNRom_BankedPoints", 0) == 0, "no banked points on the child")
    rom = romance(r, u)
    r.check(rom is not None and iv(rom, "sparked", 0) == 0, "get_romance: sparked 0 (platonic ladder selected)")
    bio = render(r, u, '{{ render_subcomponent("character_bio", "full") }}')
    r.check(bio is not None and "## Your Bond With" in bio, "bond prompt section renders for the child")


@test("CS-22", "CS")
def cs22(r):
    """Console write SNRom_PhysMinTier = 4 on the enrolled child, then a drift and a repair request: the prompt JSON
    shows -1 at once (R8, RELD IEB_PhysMinTierShown :1218-1223); the store is -1 after the next sweep (R7,
    SweepFollowers -> IEB_ChildSweep RELB:559, 8707-8732); no drift for the child (R9, DriftCandidate RELB:7775);
    the repair path re-locks at once (R5, SetCharacterField RELB:7817-7860). The watcher is switched off around the
    deliberate bad write (its I9 sample would assert FAIL and halt the block) and always switched back on.
    ForceDriftReview is NOT used: it bypasses R9 and would send a drift prompt about a child (see report)."""
    u, name = ensure_child_enrolled(r)
    if not u:
        return
    checkpoint(r)
    con(r, "set IEB_TestWatch to 0")
    try:
        if not su_set(r, CHILD, "SNRom_PhysMinTier", 4):
            return inc(r, "SUSetInt wrapper gave no line")
        r.check(su_get(r, u, "SNRom_PhysMinTier", fid=CHILD) == 4, "store holds the bad value 4 (write landed)")
        rom = romance(r, u)
        if rom is None:
            inc(r, "prompt JSON empty (SkyrimNet decorator cache miss) after 3 tries: R8 not judged")
        else:
            r.check(iv(rom, "physMinTier") == -1, "prompt JSON physMinTier -1 at once (got %s)" % iv(rom, "physMinTier"))
        st = tail("snrom")
        rel(r, "AssessNextDrift", [])
        time.sleep(5)
        r.check(not re.search(r"rift.*%s\b|%s\b.*rift" % (re.escape(name), re.escape(name)), st.read()),
                "drift tick: no drift review for the child")
        rel(r, "SweepFollowers", [])
        time.sleep(6)
        r.check(su_get(r, u, "SNRom_PhysMinTier", fid=CHILD) == -1, "store back to -1 after the sweep")
        su_set(r, CHILD, "SNRom_PhysMinTier", 4)
        if su_get(r, u, "SNRom_PhysMinTier", fid=CHILD) != 4:     # RV-123 (3): else the -1 below proves nothing
            return inc(r, "read-back: second SNRom_PhysMinTier = 4 write did not land; R5 repair not judged")
        rel(r, "SetCharacterField", [ah(CHILD), 0, 0])
        time.sleep(3)
        r.check(su_get(r, u, "SNRom_PhysMinTier", fid=CHILD) == -1, "repair request (SetCharacterField intimacy casual) leaves -1")
        r.check(su_get(r, u, "SNRom_SparkDecided", fid=CHILD) == 1, "SNRom_SparkDecided 1")
    finally:
        rel(r, "SweepFollowers", [])
        time.sleep(3)
        if su_get(r, u, "SNRom_PhysMinTier", fid=CHILD) != -1:   # RV-123 (3): CS-22 is reload=False
            inc(r, "read-back cleanup: child SNRom_PhysMinTier not -1 after the final sweep")
        con(r, "set IEB_TestWatch to 1")


@test("CS-12", "CS")
def cs12(r):
    """Prompt preview, child speaker, scene mode on (R3): casual length tier, no scene line from 0760. Scene mode is
    switched on with an ADULT partner (F1) through the proposed SceneOn wrapper (P2: a child is never a partner; the
    wrapper refuses one). The child's own isChild clause is shown by its input value only: setting
    IEB_IsScenePartner on a child is forbidden. Witness events are off for the few seconds the scene is on
    (IEB_WitnessEnabled, SceneControls.esp 0x805; INFERRED FireWitness honours it)."""
    cu, cname, child = who(r, CHILD)
    au, aname, _ = who(r, F1)
    if not cu or not child or not au:
        return inc(r, "child or adult control not loaded")
    con(r, "set IEB_WitnessEnabled to 0")
    try:
        if not ctl_line(r, "SceneOn", [F1], r"\[IEB-TEST\] SCENE on partner="):
            return inc(r, "SceneOn wrapper gave no line")
        if su_get(r, au, "IEB_IsScenePartner", 0, fid=F1) != 1:   # RV-123 (3): the wrapper line only echoes
            return inc(r, "read-back SceneOn: F1 IEB_IsScenePartner is not 1")
        checkpoint(r)
        head_c = render(r, cu, '{{ render_subcomponent("system_head", "full") }}')
        fin_c = render(r, cu, '{{ render_subcomponent("user_final_instructions", "full") }}')
        head_a = render(r, au, '{{ render_subcomponent("system_head", "full") }}')
        fin_a = render(r, au, '{{ render_subcomponent("user_final_instructions", "full") }}')
        if head_c is None or fin_c is None:
            return inc(r, "child render failed")
        r.check("Scene: speak" not in head_c and "(8-40 words typical)" in head_c,
                "child speaker: casual length tier (0020), no scene tier line")
        r.check("Scene mode is on" not in fin_c and "\n## Scene\n" not in "\n" + fin_c + "\n",
                "child speaker: no scene contract from 0760")
        r.check(truthy(rval(r, cu, "decnpc(actorUUID).isChild")), "gate input: decnpc(child).isChild is true")
        sp = su_get(r, cu, "IEB_IsScenePartner", 0, fid=CHILD)
        if sp is None:
            inc(r, "IEB_IsScenePartner on the child unreadable")
        else:
            r.check(sp == 0, "child is not a scene partner (IEB_IsScenePartner=%d)" % sp)
        if head_a is not None and "Scene: speak" in head_a:
            r.check(True, "control: adult partner gets the scene tier (scene mode is live in renders)")
        else:
            inc(r, "control: adult partner did not get the scene tier; the child result is not discriminating")
        if fin_a is None or "Scene mode is on" not in fin_a:
            r.log("  NOTE adult 0760 scene block absent (0760 also needs is_narration_enabled(), 0760:36)")
    finally:
        ctl_line(r, "SceneOff", [], r"\[IEB-TEST\] SCENE off")
        if su_get(r, au, "IEB_IsScenePartner", 0, fid=F1) != 0:   # RV-123 (3): CS-12 is reload=False
            inc(r, "read-back SceneOff: F1 IEB_IsScenePartner still set")
        con(r, "set IEB_WitnessEnabled to 1")


# ============================================================================ RS (spec §11.14.6; IEB_RankSync)

def _set_pts(r, fid, pts):
    k = rank(r, fid)
    if not k:
        return None
    rel(r, "ApplyDepth", [ah(fid), pts - iv(k, "pts", 0), "ieb test", False, "test"])
    time.sleep(3)
    return rank(r, fid)


def _ranksync(text, name):
    return [m.groupdict() for m in re.finditer(
        r"(?i)\[IEB\] RANKSYNC actor=%s(?: from=(?P<f>-?\d+) to=(?P<t>-?\d+))? why=(?P<why>\S+)" % re.escape(name), text)]


@test("RS-1", "RS")
def rs1(r):
    """Enrolled NPC (F2) at Acquaintance, rank 0; points raised to Friend through ApplyDepth (-> SyncBondRank ->
    IEB_RankSync.Apply, RELB:1315-1325) -> 'RANKSYNC ... to=1 why=raise' (IEB_RankSync.psc:154-156).
    The RDO rank >= 1 greeting needs the player to approach and press E: NOT automated."""
    u, name, _ = who(r, F2)
    if not name:
        return inc(r, "F2 not loaded")
    if iv(rank(r, F2) or {}, "tier") < 0:
        return inc(r, "F2 not enrolled")
    k = _set_pts(r, F2, 600)
    ctl_line(r, "SetRank", [F2, 0], r"\[IEB-TEST\] SETRANK")
    k = rank(r, F2)
    if not k or iv(k, "tier") != 1 or iv(k, "r") != 0:
        return inc(r, "setup: want tier 1 rank 0, have tier %s rank %s" % (k and k.get("tier"), k and k.get("r")))
    checkpoint(r)
    t = tail("papyrus")
    rel(r, "ApplyDepth", [ah(F2), 500, "ieb test", False, "test"])
    time.sleep(4)
    hits = _ranksync(t.read(), name)
    r.check(any(h["t"] == "1" and h["why"] == "raise" for h in hits), "RANKSYNC to=1 why=raise logged")
    k2 = rank(r, F2)
    r.check(k2 is not None and iv(k2, "r") == 1 and iv(k2, "tier") == 2, "rank 1 at Friend tier")
    partial(r, "RDO rank>=1 greeting INFO (needs the player to approach and press E: Shae, or harness select-topic)")


@test("RS-4", "RS", reload=True)   # last user of the enrolled child: reload so Braith is not enrolled for later tests (Claude review)
def rs4(r):
    """Enrolled child at Friend tier, sweep: no write. Apply returns on IsChild with NO log line
    (IEB_RankSync.psc:93-95), so the spec's 'why=skip:child' never appears (see report); checked instead: rank
    unchanged, no RANKSYNC line for the child, no stored sync keys (Apply returns before Store)."""
    u, name = ensure_child_enrolled(r)
    if not u:
        return
    k0 = _set_pts(r, CHILD, 1200)
    if not k0 or iv(k0, "tier") != 2:
        return inc(r, "setup: child not at Friend tier (%s)" % (k0 and k0.get("tier")))
    checkpoint(r)
    t = tail("papyrus")
    ctl_line(r, "RankApply", [CHILD], r"\[IEB-TEST\] RANKAPPLY")
    time.sleep(2)
    k1 = rank(r, CHILD)
    r.check(k1 is not None and k1.get("r") == k0.get("r"), "child's vanilla rank unchanged (%s -> %s)" % (k0.get("r"), k1 and k1.get("r")))
    r.check(not _ranksync(t.read(), name), "no RANKSYNC line for the child")
    r.check(k1 is not None and iv(k1, "hasSync") == 0, "no IEB_RankSyncTier stored on the child")
    if any(h["why"] == "skip:child" for h in _ranksync(r.tails["papyrus"].read(), name)):
        r.log("  'why=skip:child' was logged")
    else:
        r.log("  NOTE 'why=skip:child' is not logged by the build (silent skip)")


@test("RS-6", "RS")
def rs6(r):
    """Enrolled Friend at rank 1; clear SNRom_Seeded and re-seed by hand (ReseedActor clears the stamp itself,
    RELB:5648-5679): points after the re-seed stay within the tier they had; no tier rise. One LLM seed read.
    INFERRED: a history-based seed that legitimately exceeds Friend would read as FAIL here (see report)."""
    u, name, _ = who(r, F2)
    if not name:
        return inc(r, "F2 not loaded")
    k = _set_pts(r, F2, 1100)
    ctl_line(r, "SetRank", [F2, 1], r"\[IEB-TEST\] SETRANK")
    ctl_line(r, "RankApply", [F2], r"\[IEB-TEST\] RANKAPPLY")
    k0 = rank(r, F2)
    if not k0 or iv(k0, "tier") != 2 or iv(k0, "r") != 1:
        return inc(r, "setup: want Friend tier, rank 1 (have tier %s rank %s)" % (k0 and k0.get("tier"), k0 and k0.get("r")))
    checkpoint(r)
    st = tail("snrom")
    rel(r, "ReseedActor", [ah(F2)])
    m = st.wait(r"(Seed read for|Seeded) %s|Seed .*%s.*(fail|fallback)" % (re.escape(name), re.escape(name)), timeout=150)
    if not m:
        return inc(r, "no seed result within 150 s")
    time.sleep(3)
    k1 = rank(r, F2)
    r.log("  points %s -> %s, tier %s -> %s" % (k0.get("pts"), k1 and k1.get("pts"), k0.get("tier"), k1 and k1.get("tier")))
    r.check(k1 is not None and iv(k1, "tier") <= iv(k0, "tier"), "no tier rise after the re-seed")


@test("RS-8", "RS", reload=True)
def rs8(r):
    """Lowering, on F2: (a) Confidant -> Friend: 2 -> 1; (b) romantic Lover -> friendship track at tier 4: 4 -> 3;
    (c) NFF-recruited Stranger at rank 3: three sweeps, no change; (e) tier drop to Stranger from rank 1 -> 0, never
    below. Each write 'why=drop' (IEB_RankSync.psc:157-168). (d) MARAS spouse needs T0-M: not run."""
    u, name, _ = who(r, F2)
    if not name:
        return inc(r, "F2 not loaded")
    # (a)
    _set_pts(r, F2, 1600)
    ctl_line(r, "RankApply", [F2], r"\[IEB-TEST\] RANKAPPLY")
    ka = rank(r, F2)
    if ka and iv(ka, "r") == 2 and iv(ka, "tier") == 3:
        checkpoint(r)
        t = tail("papyrus")
        ks = _set_pts(r, F2, 1100)
        hits = _ranksync(t.read(), name)
        k = rank(r, F2)
        if not ks or iv(ks, "pts") != 1100:        # RV-123 (3): the points write read back before judging the drop
            inc(r, "(a) read-back: points not 1100 after ApplyDepth (pts=%s)" % (ks and ks.get("pts")))
        else:
            r.check(any(h["f"] == "2" and h["t"] == "1" and h["why"] == "drop" for h in hits) and k and iv(k, "r") == 1,
                    "(a) Confidant -> Friend: rank 2 -> 1, why=drop")
    else:
        inc(r, "(a) setup: Confidant at rank 2 not reached (tier %s rank %s)" % (ka and ka.get("tier"), ka and ka.get("r")))
        checkpoint(r)   # setup-only: stop on the (a) miss too (SETUP FAIL with its reason)
    # (b) romantic track: sparked + accepted stance (RefreshTrack rule, IEB_RankSync.psc:50-66), adult only
    su_set(r, F2, "SNRom_Sparked", 1)
    su_set(r, F2, "SNRom_PlayerStance", 1)
    _set_pts(r, F2, 2100)
    ctl_line(r, "RankApply", [F2], r"\[IEB-TEST\] RANKAPPLY")
    kb = rank(r, F2)
    if kb and iv(kb, "track") == 1 and iv(kb, "r") == 4:
        t = tail("papyrus")
        su_set(r, F2, "SNRom_Sparked", 0)
        if su_get(r, u, "SNRom_Sparked", fid=F2) != 0:     # RV-123 (3): the un-spark write read back first
            inc(r, "(b) read-back: SNRom_Sparked not 0 after the write")
        else:
            ctl_line(r, "RankApply", [F2], r"\[IEB-TEST\] RANKAPPLY")
            hits = _ranksync(t.read(), name)
            k = rank(r, F2)
            r.check(any(h["f"] == "4" and h["t"] == "3" and h["why"] == "drop" for h in hits) and k and iv(k, "r") == 3,
                    "(b) romantic Lover -> friendship at tier 4: rank 4 -> 3, why=drop")
    else:
        inc(r, "(b) setup: romantic track at rank 4 not reached (track %s rank %s; orientation may foreclose)"
            % (kb and kb.get("track"), kb and kb.get("r")))
    su_unset(r, F2, "SNRom_PlayerStance")
    su_set(r, F2, "SNRom_Sparked", 0)
    # (c) first sync of a Stranger at NFF's recruit rank 3: raise only, then no drop on later sweeps
    _set_pts(r, F2, 100)
    su_unset(r, F2, "IEB_RankSyncTier")
    su_unset(r, F2, "IEB_RankSyncRom")
    ctl_line(r, "SetRank", [F2, 3], r"\[IEB-TEST\] SETRANK")
    kc = rank(r, F2)                                # RV-123 (3): read back every (c) setup write (-99/-1 = unset)
    cs = (su_get(r, u, "SNRom_Sparked", fid=F2), su_get(r, u, "SNRom_PlayerStance", fid=F2))
    if (not kc or iv(kc, "pts") != 100 or iv(kc, "r") != 3 or iv(kc, "hasSync") != 0 or iv(kc, "syncRom") != -1
            or cs[0] != 0 or cs[1] != -99):
        inc(r, "(c) setup read-back: pts=%s r=%s hasSync=%s syncRom=%s sparked/stance=%s, want 100/3/0/-1/(0, unset)"
            % (kc and kc.get("pts"), kc and kc.get("r"), kc and kc.get("hasSync"), kc and kc.get("syncRom"), cs))
    else:
        t = tail("papyrus")
        for _ in range(3):
            ctl_line(r, "RankApply", [F2], r"\[IEB-TEST\] RANKAPPLY")
        k = rank(r, F2)
        r.check(k is not None and iv(k, "r") == 3 and not any(h["why"] == "drop" for h in _ranksync(t.read(), name)),
                "(c) Stranger at rank 3: three sweeps, rank stays 3")
    # (e) Friend at rank 1 -> Stranger: 1 -> 0, never below
    _set_pts(r, F2, 1100)
    ctl_line(r, "SetRank", [F2, 1], r"\[IEB-TEST\] SETRANK")
    ctl_line(r, "RankApply", [F2], r"\[IEB-TEST\] RANKAPPLY")
    ke = rank(r, F2)                                # RV-123 (3): read back the (e) setup
    if not ke or iv(ke, "pts") != 1100 or iv(ke, "r") != 1:
        inc(r, "(e) setup read-back: pts=%s r=%s, want 1100 / 1" % (ke and ke.get("pts"), ke and ke.get("r")))
    else:
        t = tail("papyrus")
        ks = _set_pts(r, F2, 100)
        hits = _ranksync(t.read(), name)
        k = rank(r, F2)
        if not ks or iv(ks, "pts") != 100:
            inc(r, "(e) read-back: points not 100 after ApplyDepth (pts=%s)" % (ks and ks.get("pts")))
        else:
            r.check(any(h["f"] == "1" and h["t"] == "0" and h["why"] == "drop" for h in hits) and k and iv(k, "r") == 0,
                    "(e) Friend -> Stranger: rank 1 -> 0, why=drop, not below 0")
    partial(r, "(d) MARAS spouse whose tier drops stays 4: needs save T0-M")


# ============================================================================ K (spec §15.3, §2.11; counts only)

def _knowledge_entries(r):
    """All world-knowledge entries via MCP list_world_knowledge (SNDLL:L54295). Field names INFERRED: the condition
    field is the one whose key contains 'condition', the key field the one containing 'key'. Content never logged."""
    props = tool_props(r, "list_world_knowledge")
    args = {}
    if "limit" in props:
        args["limit"] = 5000
    res = r.tool("list_world_knowledge", args)
    ents = [e for e in first_list(res) if isinstance(e, dict)]
    return ents


def _field(e, part):
    for k, v in e.items():
        if part in k.lower() and isinstance(v, str):
            return v
    return ""


def _cond_true(r, uuid, cond):
    out = render(r, uuid, "{%% if %s %%}1{%% else %%}0{%% endif %%}" % cond)
    return None if out is None or out.strip() not in ("0", "1") else out.strip() == "1"


@test("K-1", "K")
def k1(r):
    """The 23 missing faction EditorIDs are absent from SkyrimNet's runtime faction list (MCP get_factions,
    SNDLL:L53927), and how is_in_faction reports an unknown EditorID (SkyrimNet.log; VERIFIED format seen
    2026-10-10: 'Entity::GetFactionRank: Faction with editor ID '<X>' not found')."""
    props = tool_props(r, "get_factions")
    lim, off = pick(props, "limit", "max_results"), pick(props, "offset", "skip")
    eds, offset = set(), 0
    for _ in range(40):
        res = r.tool("get_factions", {lim: 500, off: offset})
        rows = first_list(res)
        if not rows:
            break
        for f in rows:
            e = f.get("editorID") or f.get("editorId") or f.get("editor_id") or ""
            if e:
                eds.add(e.lower())
        offset += len(rows)
        if len(rows) < 500:
            break
    if not eds:
        return inc(r, "get_factions returned no rows")
    checkpoint(r)
    present = [x for x in MISSING_FACTIONS if x.lower() in eds]
    r.log("  runtime factions: %d; of the 23, present: %d" % (len(eds), len(present)))
    r.check(not present, "all 23 missing EditorIDs absent (%s)" % ",".join(present))
    u, _, _ = who(r, F1)
    t = tail("skyrimnet")
    v = rval(r, u, 'is_in_faction(actorUUID, "%s")' % MISSING_FACTIONS[0])
    time.sleep(2)
    lines = [l for l in t.read().splitlines() if MISSING_FACTIONS[0] in l]
    r.log("  is_in_faction(unknown) -> %s; SkyrimNet.log lines naming it: %d" % (v, len(lines)))
    r.check(v is not None and not truthy(v), "is_in_faction on an unknown EditorID returns false")
    r.check(any("not found" in l for l in lines), "SkyrimNet.log reports the unknown EditorID ('not found')")


@test("K-2", "K", reload=True)
def k2(r):
    """A Markarth NPC in MarkarthArnleifandSonsFaction (Lisbet): the pack entry whose condition uses the case-
    differing 'MarkarthArnleifAndSonsFaction' (Buildings_In_Markarth, knowledge_key reach.building.arnleif_and_sons,
    1 entry: VERIFIED gaius-import/packs) is eligible. If Lisbet has no UUID while unloaded she is moved to the
    player by console (reload afterwards)."""
    u, _, _ = who(r, LISBET)
    if not u:
        con(r, "%s.moveto player" % hx(LISBET))
        time.sleep(5)
        if not near_player(r, LISBET, "Lisbet moveto player"):
            return
        u, _, _ = who(r, LISBET)
    if not u:
        return inc(r, "no UUID for 0x%s" % hx(LISBET))
    r.check(truthy(rval(r, u, 'is_in_faction(actorUUID, "MarkarthArnleifandSonsFaction")')), "control: game's own spelling true")
    r.check(truthy(rval(r, u, 'is_in_faction(actorUUID, "MarkarthArnleifAndSonsFaction")')), "case-differing EditorID resolves true")
    ents = [e for e in _knowledge_entries(r) if "MarkarthArnleifAndSonsFaction" in _field(e, "condition")]
    if not ents:
        return inc(r, "no knowledge entry with the case-differing condition found in list_world_knowledge")
    checkpoint(r)
    ok = [_cond_true(r, u, _field(e, "condition")) for e in ents]
    r.log("  entries with the case-differing condition: %d; eligible for 0x%s: %d" % (len(ents), hx(LISBET), sum(1 for x in ok if x)))
    r.check(any(ok), "the pack entry is eligible for the faction member")


@test("K-3", "K")
def k3(r):
    """A Whiterun guard: eligible entries > 0 from Dungeons_of_Whiterun_Hold (17 entries, knowledge_key prefix
    'dungeon.whiterun.': VERIFIED gaius-import/packs). Counts only; conditions are evaluated, never printed."""
    gu = None
    for g in WR_GUARDS:
        u, _, _ = who(r, g)
        if u and truthy(rval(r, u, 'is_in_faction(actorUUID, "GuardFactionWhiterun")')):
            gu, gid = u, g
            break
    if not gu:
        con(r, "%s.moveto player" % hx(WR_GUARDS[0]))
        time.sleep(5)
        if not near_player(r, WR_GUARDS[0], "Whiterun guard moveto player"):
            return
        gu, _, _ = who(r, WR_GUARDS[0])
        gid = WR_GUARDS[0]
    if not gu:
        return inc(r, "no Whiterun guard loaded")
    ents = [e for e in _knowledge_entries(r) if _field(e, "key").startswith("dungeon.whiterun.")]
    if not ents:
        return inc(r, "no 'dungeon.whiterun.' entries found in list_world_knowledge (key field INFERRED)")
    checkpoint(r)
    res = [_cond_true(r, gu, _field(e, "condition")) for e in ents]
    n = sum(1 for x in res if x)
    r.log("  guard 0x%s: %d of %d Dungeons_of_Whiterun_Hold entries eligible (%d unevaluated)"
          % (hx(gid), n, len(ents), sum(1 for x in res if x is None)))
    r.check(n > 0, "eligible entries > 0")


# ============================================================================ X (spec §11.6) - renders (R3)

UNDERWEAR = re.compile(r"underwear|smallclothes|panties|loincloth|briefs|\bbra\b", re.I)


def _strip_body(r, fid, uuid):
    rows = worn_rows(r, uuid) or []
    body = [x for x in rows if x[0].lower() == "torso"]
    for b in body:
        f = to_formid(b[1])
        if f:
            con(r, "%s.unequipitem %08X" % (hx(fid), f))
    time.sleep(2)
    if not body:    # RV-58 audit: with the old 'body' key nothing was ever stripped, so every "stripped" check was vacuous
        r.log("  strip: no torso (slot 32) item found on %s; the 'stripped' checks below would be vacuous" % hx(fid))
    return rows, body


def _stripped_or_inc(r, fid, body, label, uuid=None):
    """True if a body garment was actually found and unequipped; else INCONCLUSIVE (never a vacuous PASS).
    RV-123 (3): with `uuid`, the unequip is read back (body_flag 0) before the test goes on."""
    if not body:
        inc(r, "%s: no body garment found to strip (slot 32 / torso)" % label)
        return False
    if uuid is not None and body_flag(r, uuid) != 0:
        inc(r, "%s: read-back %s.unequipitem: 0x%s still wears a body garment" % (label, hx(fid), hx(fid)))
        return False
    return True


@test("X-1", "X", reload=True)
def x1(r):
    """Slot 32 empty, female (F1) and male (H): the equipment list has no body item and no underwear entry.
    The visual half (nude 3BA / HIMBO+TNG body, no underwear layer) needs a screenshot: NOT automated."""
    for fid, label in ((F1, "female"), (H, "male")):
        u, _, _ = who(r, fid)
        if not u:
            inc(r, "%s 0x%s not loaded" % (label, hx(fid)))
            continue
        rows0, body = _strip_body(r, fid, u)
        if not _stripped_or_inc(r, fid, body, label, u):
            continue
        if setup_skip(r):
            continue
        rows1 = worn_rows(r, u)
        if rows1 is None:
            inc(r, "%s: worn-equipment render failed" % label)
            continue
        r.log("  %s 0x%s: %d items before, %d after (body item before: %d)" % (label, hx(fid), len(rows0), len(rows1), len(body)))
        r.check(body_flag(r, u) == 0 and not any(x[0].lower() == "torso" for x in rows1), "%s: no body item after unequip" % label)
        r.check(not any(UNDERWEAR.search(x[2]) for x in rows1), "%s: no underwear entry in the list" % label)
        bio = render(r, u, '{{ render_subcomponent("character_bio", "full") }}')
        sec = equip_section(bio)
        r.check(sec is not None and len(sec) == len(rows1), "%s: 0410 Worn Equipment lists exactly the worn items (%s/%d)"
                % (label, None if sec is None else len(sec), len(rows1)))
    checkpoint(r)
    partial(r, "visual render (nude 3BA / HIMBO+TNG body, no underwear layer): screenshot or Shae's eyes")


@test("X-2", "X", reload=True)
def x2(r):
    """get_worn_equipment for a dressed NPC (F2) vs stripped NPCs (F1 female, H male): 'body' field present when
    dressed; absent/empty when stripped; a cuirass appears once (not once per slot); a stripped male shows no
    slot-52 or extra entry."""
    u2, _, _ = who(r, F2)
    rows = worn_rows(r, u2) if u2 else None
    if not rows:
        return inc(r, "dressed NPC F2: no worn rows")
    checkpoint(r)
    body = [x for x in rows if x[0].lower() == "torso"]
    r.log("  dressed F2: slots %s" % ",".join(sorted(x[0] for x in rows)))
    r.check(bool(body) and body_flag(r, u2) == 1, "dressed: 'torso' (body garment) field present")
    # RV-58: a dressed NPC must get NO attire line (with '.body' every NPC got one)
    fu0, _, _ = who(r, F1)
    if fu0 and u2:
        a0 = _attire_probe(r, fu0, u2)
        if a0 is None:
            inc(r, "attire render failed for the dressed NPC")
        else:
            r.check(not a0["mark"], "dressed NPC: no 0412 attire line")
    if body:
        n = sum(1 for x in rows if x[1] == body[0][1])
        r.check(n == 1, "dressed: body item appears once (%d)" % n)
    for fid, label in ((F1, "female"), (H, "male")):
        u, _, _ = who(r, fid)
        if not u:
            inc(r, "%s not loaded" % label)
            continue
        rows0, _b = _strip_body(r, fid, u)
        if not _stripped_or_inc(r, fid, _b, label, u):
            continue
        rows1 = worn_rows(r, u) or []
        r.log("  stripped %s: slots %s" % (label, ",".join(sorted(x[0] for x in rows1))))
        r.check(body_flag(r, u) == 0, "stripped %s: 'torso' empty" % label)
        new = {x[1] for x in rows1} - {x[1] for x in rows0}
        r.check(not new and not any("52" in x[0] for x in rows1), "stripped %s: no new or slot-52 entry" % label)
        bio = render(r, u, '{{ render_subcomponent("character_bio", "full") }}') or ""
        r.log("  stripped %s: 'Body Slot: Empty' shown: %s" % (label, "Body Slot: Empty" in bio))


def _find_item(r, term):
    props = tool_props(r, "get_items")
    res = r.tool("get_items", {pick(props, "search", "name_contains", "query"): term, pick(props, "limit", "max_results"): 50})
    for it in first_list(res):
        typ = str(it.get("itemType") or it.get("type") or "")
        name = str(it.get("name") or "")
        if "armo" in typ.lower() and term.lower() in name.lower():
            f = to_formid(it.get("formID") or it.get("formId") or "")
            if f:
                return f, name
    return None, None


@test("X-3", "X", reload=True)
def x3(r):
    """dialogue_target render (R3 instead of the trace) of the player, addressed by F1, wearing only boots, a cloak,
    a lantern and a bandolier (slot 32 empty): the Worn Equipment list shows exactly those; slot labels recorded.
    Items are looked up by name with MCP get_items (INFERRED that the load order has a cloak, lantern and bandolier)."""
    pu, _, _ = who(r, PLAYER)
    fu, _, _ = who(r, F1)
    if not pu or not fu:
        return inc(r, "player or F1 UUID missing")
    con(r, "player.unequipall")
    time.sleep(2)
    worn = []
    for term in ("boots", "cloak", "lantern", "bandolier"):
        f, name = _find_item(r, term)
        if not f:
            inc(r, "no armor item named like '%s' in get_items" % term)
            continue
        con(r, "player.additem %08X 1" % f)
        con(r, "player.equipitem %08X" % f)
        worn.append((f, name))
        time.sleep(1)
    if not worn:
        return
    got = {to_formid(x[1]) for x in (worn_rows(r, pu) or [])}     # RV-123 (3): unequipall + equipitem read back
    want = {fid_norm(f) for f, _ in worn}
    if got != want:
        return inc(r, "read-back unequipall/equipitem: player wears %d forms, %d of the %d equipped (extra %d)"
                   % (len(got), len(got & want), len(want), len(got - want)))
    checkpoint(r)
    out = render(r, fu, '{{ render_character_profile("dialogue_target", responseTarget.UUID) }}', target=pu)
    sec = equip_section(out)
    if sec is None:
        return inc(r, "no '### Worn Equipment' in the dialogue_target render")
    labels = [m.group(1) for m in (re.match(r"- \*\*(.+?)\*\*:", s) for s in sec) if m]
    r.log("  %d items equipped; list rows %d; labels %s" % (len(worn), len(sec), labels))
    r.check(len(sec) == len(worn) and all(any(n in s for s in sec) for _, n in worn),
            "Worn Equipment lists exactly the equipped items")
    r.log("  0412 attire line present: %s" % (ATTIRE_MARK in (out or "")))


@test("X-4", "X")
def x4(r):
    """Bystander render (R3, template dialogue_response, F1 speaking to F2): no player equipment item appears."""
    pu, _, _ = who(r, PLAYER)
    fu, _, _ = who(r, F1)
    tu, _, _ = who(r, F2)
    if not (pu and fu and tu):
        return inc(r, "UUIDs missing")
    names = [x[2] for x in (worn_rows(r, pu) or []) if len(x[2]) >= 5]
    if not names:
        return inc(r, "player wears no named item")
    checkpoint(r)
    out = render(r, fu, template="dialogue_response", target=tu)
    if out is None:
        return inc(r, "dialogue_response render failed")
    found = [n for n in names if n in out]
    r.log("  player items %d; found in the NPC-to-NPC prompt: %d" % (len(names), len(found)))
    r.check(not found, "no player equipment in the bystander prompt")


def _attire_probe(r, speaker_uuid, target_uuid):
    out = render(r, speaker_uuid, "{{ has_line_of_sight(npc.UUID, responseTarget.UUID) }}|{{ npc.UUID }}|"
                                  "{{ actor_has_keyword(responseTarget.UUID, \"ActorTypeNPC\") }}|@@|"
                                  '{{ render_character_profile("dialogue_target", responseTarget.UUID) }}', target=target_uuid)
    if out is None or "@@" not in out:
        return None
    head, body = out.split("@@", 1)
    p = head.strip().rstrip("|").split("|")
    return {"los": truthy(p[0]) if p else None, "npc": p[1] if len(p) > 1 else "",
            "npcType": truthy(p[2]) if len(p) > 2 else None, "mark": ATTIRE_MARK in body}


@test("X-7", "X", reload=True)
def x7(r):
    """0412 loads (no first-5-lines rejection) and its line appears only with line of sight; npc is the speaker.
    Target F2 with her body item removed; LOS false by moving F2 3000 u below the player with the proposed PlaceRel
    wrapper (INFERRED that terrain blocks has_line_of_sight; self-checked: if LOS stays true the case is
    INCONCLUSIVE, not FAIL)."""
    sn = open(game.LOGS["skyrimnet"], "rb").read().decode("utf-8", "replace") if os.path.exists(game.LOGS["skyrimnet"]) else ""
    r.check(not re.search(r"character_bio submodule validation failed.*0412", sn), "0412 not rejected at load (first-5-lines rule)")
    fu, _, _ = who(r, F1)
    tu, _, _ = who(r, F2)
    if not (fu and tu):
        return inc(r, "F1 or F2 not loaded")
    _strip_body(r, F2, tu)
    if body_flag(r, tu) != 0:
        return inc(r, "F2 still wears a body item")
    checkpoint(r)
    a = _attire_probe(r, fu, tu)
    if not a:
        return inc(r, "render failed")
    r.check(same_uuid(a["npc"], fu), "npc is the speaker (F1)")
    if a["los"]:
        r.check(a["mark"], "with line of sight: the 0412 attire line appears")
    else:
        inc(r, "F1 has no line of sight to F2 in the market setup")
    ctl_line(r, "PlaceRel", [F2, PLAYER, 0.0, 0.0, -3000.0], r"\[IEB-TEST\] PLACE")
    try:
        time.sleep(1)
        b = _attire_probe(r, fu, tu)
        if not b or b["los"]:
            return inc(r, "LOS-false setup did not give has_line_of_sight false")
        r.check(not b["mark"], "without line of sight: no attire line")
    finally:
        # Reviewer 2026-10-10: F2 under the terrain can fall, take damage, die or trip NFF's warp. Bring her straight
        # back and assert she is alive and near the player; X-7 also reloads T0 afterwards (reload=True). Post-U1:
        # replace the under-terrain placement with a real occluder (F2 inside a closed interior, placed on a marker).
        con(r, "%08X.moveto player" % F2)
        time.sleep(2)
        m = ctl_line(r, "Probe", [F2], r"\[IEB-TEST\] probe .*%s .*dPlayer=(\S+) .*dead=(\d)" % fid_any_rx(F2))
        r.check(bool(m) and m.group(2) == "0", "F2 alive after the under-terrain placement (%s)" % (m.group(0)[-40:] if m else "no probe"))
        r.check(bool(m) and m.group(1) not in ("NA", "") and float(m.group(1)) < 500,
                "F2 back beside the player (dPlayer=%s)" % (m.group(1) if m else "?"))


@test("X-8", "X", reload=True)
def x8(r):
    """Exclusions of 0412: werewolf (player setrace), animals (a dog spawned, a dead wolf spawned), a child. Child: only
    the gate input is checked (a child is never undressed, so the body clause is never true for her). Witness events
    are off while the player is a werewolf (IEB_BeastFormHook would fire one)."""
    fu, _, _ = who(r, F1)
    if not fu:
        return inc(r, "F1 not loaded")
    # child
    cu, _, ch = who(r, CHILD)
    if cu and ch:
        c = _attire_probe(r, fu, cu)
        r.check(c is not None and not c["mark"], "child target: no attire line")
        r.check(truthy(rval(r, cu, "decnpc(actorUUID).isChild")), "child gate input isChild true")
    else:
        inc(r, "child not loaded")
    # animals
    for base, label in ((DOG_BASE, "dog"), (WOLF_DEAD_BASE, "wolf (corpse)")):
        m = ctl_line(r, "Spawn", [base, 250.0], r"\[IEB-TEST\] SPAWN base=\S+ ref=((?:0x)?[0-9A-Fa-f]+)")
        if not m:
            inc(r, "%s spawn failed" % label)
            continue
        ref = fid_norm(m.group(1))
        try:
            time.sleep(2)
            au, _, _ = who(r, ref)
            if not au:
                inc(r, "%s: no UUID" % label)
                continue
            if setup_skip(r):
                continue
            a = _attire_probe(r, fu, au)
            if not a:
                inc(r, "%s: render failed" % label)
                continue
            r.log("  %s: ActorTypeNPC=%s body=%s" % (label, a["npcType"], body_flag(r, au)))
            r.check(not a["npcType"] and not a["mark"], "%s: excluded (no ActorTypeNPC, no attire line)" % label)
        finally:
            ctl_line(r, "DespawnRef", [s32(ref)], r"\[IEB-TEST\] (?i:DESPAWN(?:REF)?) ")
    checkpoint(r)
    # werewolf (player): reload restores the race
    pu, _, _ = who(r, PLAYER)
    con(r, "set IEB_WitnessEnabled to 0")
    try:
        con(r, "player.setrace WerewolfBeastRace")
        time.sleep(6)
        w = _attire_probe(r, fu, pu)
        if not w:
            return inc(r, "werewolf render failed")
        r.log("  werewolf player: ActorTypeNPC=%s" % w["npcType"])
        r.check(not w["mark"], "werewolf player: no attire line")
    finally:
        con(r, "set IEB_WitnessEnabled to 1")
