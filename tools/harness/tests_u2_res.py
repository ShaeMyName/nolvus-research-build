"""U2 block: RES-1 / RES-2, the IntelEngine destination guard (spec §17b; DECISIONS:425; REVIEW_LOG R42-plan, RV-210).

RES-1 probes the guard with no errand started: IEB_TestCtl.ResolveProbe(actor, phrase) calls IntelEngine's raw resolver
and Core.IEB_GuardedResolve(site=probe) and logs both picks, the holds of both and of the actor, and whether a phrase
that exactly names a Location resolved inside it. The guard's own "IEB RESOLVE ... rule=" line gives the deciding rule.
Kinds:
  L  generic / ambiguous: the guarded pick is in the actor's hold, or refused. Never another hold.
  N  names a place: resolved; if the phrase exactly names a Location, inside it (the "Riverwood" -> Inkwell regression).
  S  no place named ("take a bath"): as L, and a raw pick already in the actor's hold is kept (not refused).
Sets: from Whiterun (F1 at the T0 market), from Riverwood (player + F1), an NPC away from the player (Lod, a Falkreath
resident, probed while the player stays in Whiterun: the guard must use HIS hold, not the player's), wilderness
(cow Tamriel 0 0; INCONCLUSIVE for that set if the cell reads as having a hold).
RES-2: one AI GoToLocation with "the market" via harness input; the travel-site RESOLVE line must be local or a reject.
Place names here are geography only (no story content)."""
import re, time
import game
from block import test, checkpoint
from tests_misc import F1, con, inc, who, player_pos, player_moved

LOD = 0x0003A19F          # Lod, Falkreath blacksmith (Skyrim.esm ACHR, read offline 2026-10-12)
PROBE_RX = (r"\[IEB-TEST\] RESPROBE guarded=(\S+) raw=(\S+) ghold=(\S+) rhold=(\S+) nloc=(\S+) nhold=(\S+) "
            r"inexact=(-?\d+) gdist=(-?\d+)")
RULE_RX = r"IEB RESOLVE site=probe rule=(\S+) target=(\S+) type=(\S+) dest='%s'"

FROM_WHITERUN = [
    ("the marketplace", "L"), ("the market", "L"), ("market", "L"), ("the stables", "L"), ("the inn", "L"),
    ("the meadery", "L"), ("the College", "L"),
    ("Riverwood", "N"), ("Riverwood Trader", "N"), ("Lake Ilinalta", "N"), ("High Hrothgar", "N"),
    ("the College of Winterhold", "N"), ("Black-Briar Meadery", "N"), ("Windhelm", "N"), ("Jorrvaskr", "N"),
    ("the Bannered Mare", "N"), ("Dragonsreach", "N"), ("Belethor's General Goods", "N"), ("Whiterun", "N"),
    ("take a bath", "S"), ("go fishing at the river", "S"), ("swim in the lake", "S"), ("outside", "S"),
]
FROM_RIVERWOOD = [("Dragonsreach", "N"), ("Whiterun", "N"), ("the inn", "L"), ("the market", "L"), ("the river", "S")]
AWAY = [("the inn", "L"), ("the stables", "L"), ("the market", "L"), ("Riverwood", "N")]
WILD = [("the inn", "L"), ("the market", "L"), ("Riverwood", "N")]


def pap():
    return game.Tail(game.LOGS["papyrus"])


def probe(r, actor, phrase):
    """One ResolveProbe: dict of the RESPROBE fields + rule/type from the guard's line, or None."""
    t = pap()
    r.ctl("ResolveProbe", [actor, phrase], sync=False)
    m = t.wait("(?i)" + PROBE_RX, 20)
    if not m:
        return None
    d = dict(zip(("guarded", "raw", "ghold", "rhold", "nloc", "nhold", "inexact", "gdist"), (g.lower() for g in m.groups())))
    # the guard's own line is traced just before RESPROBE (same mark); Papyrus may case-fold log literals
    m2 = re.search(RULE_RX % re.escape(phrase), t.read(), re.I)
    d["rule"] = m2.group(1).lower() if m2 else "?"
    d["type"] = m2.group(3) if m2 else "?"
    return d


def judge(r, where, phrase, kind, d):
    if d is None:
        return inc(r, "%s '%s': no RESPROBE line" % (where, phrase))
    local = d["guarded"] == "none" or (d["ghold"] != "none" and d["ghold"] == d["nhold"])
    r.log("  %s '%s' [%s]: guarded=%s raw=%s ghold=%s rhold=%s nhold=%s inexact=%s rule=%s type=%s dist=%s"
          % (where, phrase, kind, d["guarded"], d["raw"], d["ghold"], d["rhold"], d["nhold"], d["inexact"], d["rule"],
             d["type"], d["gdist"]))
    if kind == "N":
        r.check(d["guarded"] != "none", "%s '%s': a named place resolves" % (where, phrase))
        if d["inexact"] != "-1":
            r.check(d["inexact"] == "1", "%s '%s': resolves inside the place it names" % (where, phrase))
        return
    r.check(local, "%s '%s': local (hold %s) or refused, never another hold (got %s)" % (where, phrase, d["nhold"], d["ghold"]))
    if kind == "S" and d["raw"] != "none" and d["rhold"] == d["nhold"] and d["nhold"] != "none":
        r.check(d["guarded"] != "none", "%s '%s': IntelEngine's local pick is kept" % (where, phrase))


def run_set(r, where, actor, cases):
    for phrase, kind in cases:
        judge(r, where, phrase, kind, probe(r, actor, phrase))


def move(r, cmd):
    w0 = player_pos(r)
    con(r, cmd)
    time.sleep(12)
    return player_moved(r, w0, cmd)


@test("RES-1", "RES", reload=True)
def res1(r):
    """Guard phrase table (module doc). ~45 probes, no LLM calls."""
    fu, _, _ = who(r, F1)
    if not fu:
        return inc(r, "F1 not loaded at the market")
    checkpoint(r, "no LLM calls")
    run_set(r, "whiterun", F1, FROM_WHITERUN)
    # an NPC away from the player: Lod in Falkreath, player still at the Whiterun market
    run_set(r, "away(Lod)", LOD, AWAY)
    if move(r, "coc Riverwood"):
        con(r, "%08X.moveto player" % F1)
        time.sleep(5)
        run_set(r, "riverwood", F1, FROM_RIVERWOOD)
    if move(r, "cow Tamriel 0 0"):
        con(r, "%08X.moveto player" % F1)
        time.sleep(5)
        d = probe(r, F1, "the inn")
        if d is None or d["nhold"] != "none":
            inc(r, "wilderness set: the cell reads as inside a hold (nloc=%s nhold=%s), not wilderness"
                % (d and d["nloc"], d and d["nhold"]))
        else:
            judge(r, "wild", "the inn", "L", d)
            run_set(r, "wild", F1, WILD[1:])


@test("RES-2", "RES", reload=True)
def res2(r):
    """One AI GoToLocation with 'the market' via harness input (1-2 LLM calls). The travel-site RESOLVE line is local
    or a reject; its hold is read back with ResolveProbe on the same phrase."""
    import sn_harness as SH
    fu, _, _ = who(r, F1)
    if not fu:
        return inc(r, "F1 not loaded at the market")
    checkpoint(r, "2 LLM calls")
    t = pap()
    SH.inject_player_input("Go and wait for me at the market.", fu)
    SH.await_idle(90)
    m = t.wait(r"(?i)IEB RESOLVE site=travel rule=(\S+) target=(\S+) type=(\S+) dest='(.*?)'\r?\n", 60)
    if not m:
        return inc(r, "no GoToLocation reached the travel resolver (the AI chose another action)")
    rule, dest = m.group(1).lower(), m.group(4)
    d = probe(r, F1, dest)
    r.log("  AI destination '%s': travel rule=%s target=%s" % (dest, rule, m.group(2)))
    if rule == "reject":
        r.check(True, "travel: refused a non-local pick")
        return
    judge(r, "ai", dest, "L" if rule not in ("named", "named-ie", "phrase") else "N", d)
