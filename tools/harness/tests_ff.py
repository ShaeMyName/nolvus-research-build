"""RV-142: what does NFF's "No Player Damage to Teammates" toggle (+ Precision's bNoPlayerTeammateAttackCollision) actually
block? Question and reading list: investigation/round10/friendly_fire_off.md (sections 1, 3, 4). Written 2026-10-11, NOT yet run.

Mechanism (VERIFIED from the decompiled NFF source nff/psc and the plugin, 2026-10-11; details in IEB_TestCtl.psc above FFPerk):
  MCM option $FF_NoPTDamage (IDOptGame[1]) -> nwsFollowerMCMExScript.psc:828-833: AddPerk(nwsNoTeamDamagePerk) to the player if
  missing, then nwsFollowerControllerScript.nwsNoPlayerDamage = 1 - itself (quest nwsFollowerController 0x434F, Int Property :152).
  The PERK 0x2ECA12 is never removed; its entry points are conditioned on GetVMQuestVariable(0x434F, ::nwsNoPlayerDamage_var)==1.
  So "toggle" = that property. IEB_TestCtl.FFSet(0|1) makes the same two writes; FFProbe reads property + HasPerk back.
  Default after "reset" is 0 (MCMEx :3489-3491); a saved preset loads it from the JSON key No_PlayerTeamDamage (MCM :3078-3084).
  Three entry points (PERK DATA): two on 0x1D with conditions on the three Unrelenting Force spells (13E09, 13F39, 13F3A) and on
  nwsNTMDNoForce, one on 0x23. INFERRED: 0x1D/0x23 are the incoming spell / weapon-damage modifiers (set value 0); which one
  covers arrows, AoE, poison is exactly what this block measures.
Precision: bNoPlayerTeammateAttackCollision is an MCM Helper value; its default is 1 (mod settings.ini:4), Nolvus's override does not set
  it, and a user change would live in <MODS>/overwrite/MCM/Settings/Precision.ini. ff0 reads those files (VERIFIED file read);
  that the game obeys the disk value is INFERRED.

Verdicts per attack type (FF-1 F1, FF-2 F2): the SAME attack is delivered twice at low health, toggle OFF then ON.
  PASS    = OFF took damage (delivery proven) and ON did not (blocked).
  LEAK    = ON took damage too (a FAIL line that starts "LEAK"; health drop in OFF/ON and died/bleedout are in the line).
  INCONCLUSIVE = OFF took no damage either (the attack never reached the follower: nothing is proven), or a precondition failed.
  MANUAL  = not automatable (logged with r.log, not counted).
Health is read with IEB_TestCtl.HealthProbe (current/max/dead/bleedout) before and 5-8 s after, plus again 3 s later (burn / poison
ticks); the lower reading counts. "died?" = dead=1 or bleedout=1 at either read. Between phases FFCalm revives (Actor.Resurrect, if
dead), ends combat and refills health; SetHealthPct then sets 20 % and HealthProbe reads it back (RV-123 (3)). Followers are
never killed on purpose: a kill is a LEAK, and every test here reloads T0 (reload=True). Children are never touched (only F1, F2 and
a spawned deer are targets).

Proxies (label them so in the report):
  enchanted-weapon hit  = TorchBashFireSpell (Skyrim.esm 0xFEAAB, HazardFireDamageFFContact, a Touch fire-damage spell) applied
                          by the player with Actor.DoCombatSpellApply. An ENCH cannot be cast from Papyrus, so this is the same
                          damage kind (fire contact, caster = player), not a real weapon enchant.
  poison                = DA02PoisonCloakDmg (0xF23C8, DamageHealth poison contact) the same way. Not a real poisoned blade.
  arrow                 = Weapon.Fire(player, iron arrow) from a Long Bow (a real projectile with the player as shooter).
  modded spells         = Apocalypse (Apocalypse - Magic of Skyrim.esp) WB_D100_Flamestrike_Spell_PC 0x02E0C0 and
                          WB_X_D000_DoomfireRightHand_Spell_PC 0x140B07 (names from the plugin; whether they are aimed damage
                          spells is INFERRED: an OFF baseline without damage gives INCONCLUSIVE, not PASS).
MANUAL (Shae, S-B sitting): Unrelenting Force into a fall / wall (follower on a ledge: no safe automated placement), real power
attacks if FF-4 cannot trigger them, a real enchanted / poisoned weapon hit, the zero-damage weapon display with Floating Damage.

Known limits: Spell.Cast and Actor.DoCombatSpellApply are the player as caster, but a Papyrus cast skips the cast animation and
magicka cost; a concentration spell (Fire Breath) fires one burst. Both are INFERRED to carry the same caster test as a hand cast.

PROPOSED block def (NOT registered; paste into blocks_def.py when approved). ~75-95 min incl. the block's 4 reloads of T0 and, RV-151, one quick T0 reload after every death / bleedout / failed read-back:
    block("FF", "T0", ["tests_ff"], ["FF-0", "FF-1", "FF-2", "FF-3", "FF-4"], est={"FF": 75},
          harness=True, voices=False, gamemaster=False)
"""
import os, re, time
import game
from block import test, checkpoint, ie_test_settings
from tests_misc import F1, F2, con, ctl_line, inc, s32, iv, parse_kv, hx, near_player
from fidnorm import fid_any_rx

HP_PCT = 20.0            # starting health for every attack on a follower
TOL_MIN = 3.0            # a drop of at most max(TOL_MIN, 2 % of max health) is "no damage" (regen / rounding)
DUMMY_BASE = 0x000CF89D  # EncDeer (Skyrim.esm NPC_, VERIFIED gamedata scan 2026-10-11): neutral, so followers and guards leave it
#                          alone and hitting an animal is no crime. Swap to 0x000C3CA0 (EncBandit01Melee1HKhajiitM) for a hostile one.
SKY = "Skyrim.esm"
APOC = "Apocalypse - Magic of Skyrim.esp"
MODS = "C:/Nolvus/Instances/Nolvus Awakening/MODS"

# kind: cast (CastAt: spell local id + plugin), shout (ShoutAt: shout local id, plugin, word 1-3), arrow (FireArrow)
# dist: units ahead of the player; wait: seconds before the first health read. All FormIDs VERIFIED in gamedata (Skyrim.esm scan
# 2026-10-11) unless noted.
CASES = [
    dict(key="firebolt", label="Firebolt (direct fire)", kind="cast", id=0x00012FD0, plugin=SKY, dist=400.0, wait=4),
    dict(key="fireball", label="Fireball (fire AoE)", kind="cast", id=0x0001C789, plugin=SKY, dist=400.0, wait=5),
    dict(key="firestorm", label="Fire Storm (big fire AoE)", kind="cast", id=0x0007A82B, plugin=SKY, dist=450.0, wait=6),
    dict(key="icestorm", label="Ice Storm (frost AoE)", kind="cast", id=0x00045F9C, plugin=SKY, dist=450.0, wait=6),
    dict(key="mod_flamestrike", label="Apocalypse Flamestrike (modded)", kind="cast", id=0x0002E0C0, plugin=APOC, dist=450.0, wait=6),
    dict(key="mod_doomfire", label="Apocalypse Doomfire (modded)", kind="cast", id=0x00140B07, plugin=APOC, dist=400.0, wait=5),
    dict(key="poison", label="poison effect (proxy: DA02PoisonCloakDmg)", kind="cast", id=0x000F23C8, plugin=SKY, dist=150.0, wait=5),
    dict(key="enchant", label="enchant-type fire contact (proxy: TorchBashFireSpell)", kind="cast", id=0x000FEAAB, plugin=SKY, dist=150.0, wait=5),
    dict(key="firebreath", label="Fire Breath shout (word 3)", kind="shout", id=0x0003F9EA, plugin=SKY, word=3, dist=300.0, wait=5),
    dict(key="force", label="Unrelenting Force shout (word 3)", kind="shout", id=0x00013E07, plugin=SKY, word=3, dist=300.0, wait=5),
    dict(key="arrow", label="arrow (Weapon.Fire, Long Bow + iron arrow)", kind="arrow", dist=300.0, wait=4),
]
COSMETIC_KEYS = ["firebolt", "fireball", "arrow", "firebreath"]

IRON_SWORD = 0x00012EB7          # Skyrim.esm WEAP IronSword (VERIFIED)
IRON_GREATSWORD = 0x0001359D     # Skyrim.esm WEAP IronGreatsword (VERIFIED)
# Candidate Debug.SendAnimationEvent names for a power attack. INFERRED (vanilla graph names; Nolvus runs MCO / Valhalla, which may
# change them). The last one is a plain swing, accepted only as a labelled proxy.
POWER_EVENTS = ["attackPowerStartForward", "attackPowerStartInPlace", "attackPowerStart", "attackStart"]


# ============================================================================ helpers

def _fnum(d, k, dflt=None):
    try:
        return float(d.get(k))
    except (TypeError, ValueError):
        return dflt


def case_by_key(k):
    return next(c for c in CASES if c["key"] == k)


def ff_state(r):
    """FFProbe -> dict(on, perk, unforce) or None (no NFF controller / perk)."""
    m = ctl_line(r, "FFProbe", [], r"(?i)\[IEB-TEST\] FF_STATE (.*)", 12)
    if not m or m.group(1).startswith("refused"):
        return None
    d = parse_kv(m.group(1))
    return d if "on" in d else None


def ff_set(r, on, what=""):
    """FFSet(on) then an independent FFProbe read-back (RV-123 (3)). True when property == on and the player has the perk."""
    ctl_line(r, "FFSet", [on], r"(?i)\[IEB-TEST\] FF_STATE (.*)", 12)
    d = ff_state(r)
    if not d or iv(d, "on") != on or iv(d, "perk") != 1:
        inc(r, "read-back: NFF toggle %s (want on=%d perk=1; got %s)%s" % (what, on, d, ""))
        return False
    return True


def hp(r, fid):
    """HealthProbe -> dict(cur, max, pct, dead, bleed, ess, combat) or None."""
    m = ctl_line(r, "HealthProbe", [s32(fid)], r"(?i)\[IEB-TEST\] FF_HP (%s) (.*)" % fid_any_rx(fid), 12)
    if not m:
        return None
    d = parse_kv(m.group(2))
    return d if "cur" in d else None


HP_TOL_PCT = 5.0         # RV-151 (b): start health must read within +-5 points of the target, or the case is not graded


def at_target(d, pct):
    """True when the HealthProbe dict d is alive, not in bleedout and its pct is within HP_TOL_PCT of pct."""
    got = _fnum(d, "pct") if d else None
    return bool(d) and iv(d, "dead") == 0 and iv(d, "bleed") == 0 and got is not None and abs(got - pct) <= HP_TOL_PCT


def calm_to(r, fid, pct, what, tries=1):
    """FFCalm (revive if dead, end combat, full health) then SetHealthPct(pct), read back with HealthProbe: health within 5 points
    of pct, alive, not bleeding out (waits up to 20 s for a bleedout to end). tries=2 repeats the whole setup once if the read-back
    is off target (RV-151 (b)). Returns the HealthProbe dict or None (inc logged, for the last try only)."""
    d, why = None, ""
    for n in range(tries):
        ctl_line(r, "FFCalm", [s32(fid)], r"(?i)\[IEB-TEST\] FF_CALM ", 15)
        time.sleep(1)
        ctl_line(r, "SetHealthPct", [s32(fid), float(pct)], r"(?i)\[IEB-TEST\] FF_SETHP ", 12)
        d = None
        for _ in range(10):
            d = hp(r, fid)
            if d and iv(d, "dead") == 0 and iv(d, "bleed") == 0:
                break
            time.sleep(2)
        if not d or iv(d, "dead") != 0 or iv(d, "bleed") != 0:
            why = "%s: %s is dead/bleeding out/unreadable after FFCalm (%s)" % (what, hx(fid), d)
        elif not at_target(d, pct):
            why = "read-back %s: health setup did not hold, %s %% of max, wanted %.0f (RV-123 (3))" % (what, _fnum(d, "pct"), pct)
        else:
            return d
        if n + 1 < tries:
            r.log("  %s -> retrying the health setup once" % why)
    inc(r, why)
    return None


def face(r, fid, dist, what):
    """FacePlace read-back: FF_FACE dist within 80 u of the wanted distance and |heading| <= 15 degrees."""
    m = ctl_line(r, "FacePlace", [s32(fid), float(dist)], r"(?i)\[IEB-TEST\] FF_FACE (%s) (.*)" % fid_any_rx(fid), 12)
    d = parse_kv(m.group(2)) if m else {}
    dd, hh = _fnum(d, "dist"), _fnum(d, "heading")
    if dd is None or hh is None or abs(dd - dist) > 80.0 or abs(hh) > 15.0:
        inc(r, "read-back %s: %s placed dist=%s heading=%s, wanted %.0f ahead (RV-123 (3))" % (what, hx(fid), dd, hh, dist))
        return False
    return True


def attack(r, case, fid):
    """Deliver one attack of `case` at `fid` from the player. Returns the controller's log text, or None if it refused."""
    k = case["kind"]
    if k == "cast":
        fn, args, tag = "CastAt", [case["id"], case["plugin"], s32(fid)], "FF_CAST"
    elif k == "shout":
        fn, args, tag = "ShoutAt", [case["id"], case["plugin"], case["word"], s32(fid)], "FF_SHOUT"
    else:
        fn, args, tag = "FireArrow", [s32(fid)], "FF_ARROW"
    m = ctl_line(r, fn, args, r"(?i)\[IEB-TEST\] %s (.*)" % tag, 12)
    if not m or m.group(1).startswith("refused"):
        return None
    return m.group(1)


def tol(d):
    return max(TOL_MIN, 0.02 * (_fnum(d, "max", 0.0) or 0.0))


def toggle_ok(r, want_on, what):
    """RV-151 (a): FFProbe right before an attack, logged. OFF needs the property at 0; ON needs the property at 1 AND the player
    holding nwsNoTeamDamagePerk. Returns dict(on, perk) or None (INCONCLUSIVE "toggle not confirmed" logged)."""
    s = ff_state(r)
    on, perk = (iv(s, "on"), iv(s, "perk")) if s else (None, None)
    r.log("  %s: FF_STATE before the attack on=%s perk=%s" % (what, on, perk))
    if on != want_on or (want_on == 1 and perk != 1):
        inc(r, "%s: toggle not confirmed (wanted on=%d%s; read on=%s perk=%s)" % (what, want_on, " perk=1" if want_on else "", on, perk))
        return None
    return dict(on=on, perk=perk)


def deliver(r, fid, case, what, on=None, target=None):
    """One measured delivery on a target already at its starting health: face, probe, attack, wait, probe, wait, probe.
    on: wanted NFF toggle value, confirmed by FFProbe right before the attack (RV-151 (a)); target: wanted start health in % of max,
    read back right before the attack, one re-setup then INCONCLUSIVE "health setup did not hold" (RV-151 (b)); an attack is never
    delivered, and so never graded, from a start that is not the target. Returns dict(before, drop, died, bleed, note, tog) or None
    (inconclusive logged)."""
    if not face(r, fid, case["dist"], what):
        return None
    tog = None
    for n in range(2 if target is not None else 1):
        if on is not None:
            tog = toggle_ok(r, on, what)
            if tog is None:
                return None
        b = hp(r, fid)
        if not b:
            inc(r, "%s: no health read before the attack" % what)
            return None
        if target is None or at_target(b, target):
            break
        r.log("  %s: start health %s %% of max (dead=%s bleed=%s), wanted %.0f" % (what, b.get("pct"), b.get("dead"), b.get("bleed"), target))
        if n == 0:
            if not calm_to(r, fid, target, what + " re-setup") or not face(r, fid, case["dist"], what):
                return None
    else:
        inc(r, "%s: health setup did not hold (start %s %% of max, wanted %.0f); not graded" % (what, b.get("pct"), target))
        return None
    note = attack(r, case, fid)
    if note is None:
        inc(r, "%s: the controller refused the attack (plugin not loaded? form missing?)" % what)
        return None
    time.sleep(case["wait"])
    a1 = hp(r, fid)
    time.sleep(3)
    a2 = hp(r, fid)
    if not a1 and not a2:
        inc(r, "%s: no health read after the attack" % what)
        return None
    lows = [_fnum(x, "cur") for x in (a1, a2) if x and _fnum(x, "cur") is not None]
    reads = [x for x in (a1, a2) if x]
    died = any(iv(x, "dead") == 1 for x in reads)
    bleed = any(iv(x, "bleed") == 1 for x in reads)
    drop = _fnum(b, "cur", 0.0) - (min(lows) if lows else 0.0)
    return dict(before=_fnum(b, "cur"), drop=drop, died=died, bleed=bleed, tol=tol(b), note=note, tog=tog)


def hurt(x):
    return bool(x) and (x["drop"] > x["tol"] or x["died"] or x["bleed"])


def fmt(x):
    return "drop %.0f of %.0f%s%s" % (x["drop"], x["before"], ", DIED" if x["died"] else "", ", bleedout" if x["bleed"] else "")


def ended_down(x):
    """The follower died or went to bleedout in this delivery: it needs a clean T0 reload before the next case (RV-151 (c))."""
    return bool(x) and (x["died"] or x["bleed"])


def place_near(r, fid, what):
    """The per-follower part of start(): alive, moved to the player, distance read back. True, or INCONCLUSIVE (inc) and False."""
    d = hp(r, fid)
    if not d or iv(d, "dead") != 0:
        inc(r, "%s: %s not loaded or dead (%s)" % (what, hx(fid), d))
        return False
    con(r, "%08X.moveto player" % fid)
    return near_player(r, fid, "%s: %s moveto player" % (what, hx(fid)))


def reload_t0(r, fids, what):
    """RV-151 (c): a clean T0 reload (a revived follower failed placement read-backs and started the next case at full health).
    quick load (no SkyrimNet settle wait: no action is involved), IntelEngine test settings as after every block load, then the
    followers are placed at the player again with read-backs. The caller re-sets the toggle and health, each with its own read-back.
    True when the game is back with every follower placed."""
    r.log("  RELOAD T0 (%s): the follower died / bled out / failed a read-back" % what)
    if not game.load(r, "T0", None, quick=True):
        inc(r, "%s: reload of T0 failed" % what)
        return False
    ie_test_settings(r)
    time.sleep(5)
    return all(place_near(r, f, what) for f in fids)


def precision_state():
    """(value, source) of bNoPlayerTeammateAttackCollision from the first file that sets it: user override in MO2 overwrite, then
    the Nolvus override mod, then the Precision default. VERIFIED file reads; that the live game equals the disk value is INFERRED."""
    files = [(MODS + "/overwrite/MCM/Settings/Precision.ini", "overwrite (user MCM Helper value)"),
             (MODS + "/mods/Precision - Nolvus Settings/MCM/Settings/Precision.ini", "Nolvus Settings override"),
             (MODS + "/mods/Precision - Accurate Melee Collisions/MCM/Config/Precision/settings.ini", "Precision default")]
    rx = re.compile(r"(?im)^\s*bNoPlayerTeammateAttackCollision\s*=\s*(\d+)")
    for path, src in files:
        try:
            if os.path.exists(path):
                m = rx.search(open(path, encoding="utf-8-sig", errors="replace").read())
                if m:
                    return int(m.group(1)), src
        except OSError:
            pass
    return None, "no file sets it"


def restore_toggle(r, orig):
    """End of every test: NFF toggle back to its original value, with the read-back."""
    if orig is None:
        return
    if ff_set(r, orig, "restore to original"):
        r.log("  NFF toggle restored to original on=%d (read back)" % orig)


def start(r, who_fids):
    """Common setup: read the NFF toggle (returns its original value), check the followers are alive, move them to the player.
    Returns the original toggle value or None (inc logged)."""
    s = ff_state(r)
    if not s:
        inc(r, "no FF_STATE line: NFF controller/perk not found, or the new IEB_TestCtl pex is not installed")
        return None
    if iv(s, "perk") != 1:
        r.log("  note: the player did not have nwsNoTeamDamagePerk yet (FFSet adds it, as the MCM click does)")
    r.log("  NFF state at start: on=%s perk=%s unforce=%s (nwsNoPlayerDamage / HasPerk / nwsNTMDNoForce)" % (s.get("on"), s.get("perk"), s.get("unforce")))
    for fid in who_fids:
        d = hp(r, fid)
        if not d or iv(d, "dead") != 0:
            inc(r, "%s: not loaded or dead at the start (%s)" % (hx(fid), d))
            return None
        r.log("  %s start: health %s/%s ess=%s" % (hx(fid), d.get("cur"), d.get("max"), d.get("ess")))
        con(r, "%08X.moveto player" % fid)
        if not near_player(r, fid, "%s moveto player" % hx(fid)):
            return None
    return iv(s, "on")


def spawn_dummy(r, dist=300.0):
    """SpawnDummy -> ref FormID (int) or None. AI disabled; read back through HealthProbe (alive, max health)."""
    m = ctl_line(r, "SpawnDummy", [DUMMY_BASE, float(dist)], r"(?i)\[IEB-TEST\] FF_SPAWN (.*)", 15)
    mm = re.search(r"ref=((?:0x)?[0-9A-Fa-f]+)", m.group(1)) if m else None
    if not mm:
        inc(r, "dummy spawn failed (%s)" % (m and m.group(1)))
        return None
    ref = int(mm.group(1), 16)
    d = hp(r, ref)
    if not d or iv(d, "dead") != 0:
        inc(r, "read-back: spawned dummy %s not alive (%s)" % (hx(ref), d))
        despawn(r, ref)
        return None
    return ref


def despawn(r, ref):
    """DespawnRef + DespawnProbe read-back (gone, or disabled)."""
    ctl_line(r, "DespawnRef", [s32(ref)], r"(?i)\[IEB-TEST\] DESPAWNREF ", 10)
    m = ctl_line(r, "DespawnProbe", [s32(ref)], r"(?i)\[IEB-TEST\] DESPAWN (%s) (.*)" % fid_any_rx(ref), 10)
    gone = bool(m) and (m.group(2).strip().startswith("none") or "dis=1" in m.group(2))
    if not gone:
        r.log("  WARN dummy %s not confirmed gone (%s); the test reloads T0 anyway" % (hx(ref), m and m.group(2)))
    return gone


# ============================================================================ FF-0: the toggle itself

@test("FF-0", "FF", save="T0")
def ff0(r):
    """Mechanism proof, no damage: FFSet writes what the MCM click writes and FFProbe reads it back (property + perk), in both
    directions, then the original value is restored. Also logs the Precision teammate-collision value from disk and the cases that
    are MANUAL. Pass: both flips read back."""
    orig = start(r, [F1, F2])
    if orig is None:
        return
    val, src = precision_state()
    r.log("  Precision bNoPlayerTeammateAttackCollision = %s (%s)" % (val, src))
    r.check(val == 1, "Precision teammate attack collision is ON on disk (%s, %s); INFERRED that the game obeys the disk value" % (val, src))
    checkpoint(r)
    try:
        r.check(ff_set(r, 1 - orig, "flip"), "toggle flipped to %d and read back (property + HasPerk)" % (1 - orig))
        r.check(ff_set(r, orig, "flip back"), "toggle flipped back to %d and read back" % orig)
    finally:
        restore_toggle(r, orig)
    r.log("  MANUAL (Shae, S-B): Unrelenting Force into a fall or wall with a follower on a ledge (no safe automated placement); "
          "a real enchanted-weapon hit and a real poisoned-weapon hit; the zero-damage weapon display with Floating Damage on; "
          "power attacks if FF-4 cannot trigger them")


# ============================================================================ FF-1 / FF-2: paired OFF vs ON per attack type

def paired(r, fid, label):
    orig = start(r, [fid])
    if orig is None:
        return
    checkpoint(r)
    rows = []
    dirty = False       # RV-151 (c): the follower died / bled out / failed a read-back: reload T0 before the next phase
    broken = False      # a reload failed, or setup keeps failing right after a clean reload: stop this follower's run
    fresh_fails = 0
    try:
        for case in CASES:
            what = "%s %s" % (label, case["key"])
            if broken:
                inc(r, "%s: skipped, the follower could not be brought back to a clean state after an earlier case" % what)
                continue
            res = {}
            for on in (0, 1):
                tag = "%s toggle %s" % (what, "ON" if on else "OFF")
                fresh = False
                if dirty:
                    if not reload_t0(r, [fid], tag):
                        broken = True
                        res = None
                        break
                    dirty, fresh = False, True
                if not ff_set(r, on, "%s phase" % what) or not calm_to(r, fid, HP_PCT, tag, tries=2):
                    res = None
                else:
                    res[on] = deliver(r, fid, case, tag, on=on, target=HP_PCT)
                    if res[on] is None:
                        res = None
                    elif ended_down(res[on]):
                        dirty = True
                if res is None:
                    dirty = True
                    fresh_fails = fresh_fails + 1 if fresh else 0
                    broken = fresh_fails >= 2
                    break
                fresh_fails = 0
            if res is None:
                rows.append((case["key"], "INCONCLUSIVE", "see the INCONCLUSIVE line above"))
                continue
            off, on_ = res[0], res[1]
            if not hurt(off):
                inc(r, "%s: no damage even with the toggle OFF (%s): the attack never hurt the follower, nothing proven" % (what, fmt(off)))
                rows.append((case["key"], "INCONCLUSIVE", "OFF: " + fmt(off)))
            elif hurt(on_):
                r.check(False, "LEAK %s: toggle ON still hurt the follower (%s); OFF: %s" % (what, fmt(on_), fmt(off)))
                rows.append((case["key"], "LEAK", "OFF: %s | ON: %s" % (fmt(off), fmt(on_))))
            else:
                r.check(True, "%s blocked by the toggle (OFF: %s | ON: %s; ON confirmed on=%s perk=%s, start health %.0f/%.0f)"
                        % (what, fmt(off), fmt(on_), on_["tog"]["on"], on_["tog"]["perk"], off["before"], on_["before"]))
                rows.append((case["key"], "PASS", "OFF: %s | ON: %s" % (fmt(off), fmt(on_))))
    finally:
        if not dirty:       # a downed follower is not refilled: the block reloads T0 after this test
            calm_to(r, fid, 100.0, "%s final refill" % label)
        restore_toggle(r, orig)
        r.log("  SUMMARY %s (health %.0f %% start; verdicts: PASS = blocked, LEAK = damage with toggle ON)" % (label, HP_PCT))
        for k, v, why in rows:
            r.log("    %-16s %-12s %s" % (k, v, why))


@test("FF-1", "FF", save="T0", reload=True)
def ff1(r):
    """F1 (Jenassa 0x000E1BA9) at 20 % health: every CASES attack with the NFF toggle OFF, then ON. See the module docstring."""
    paired(r, F1, "F1")


@test("FF-2", "FF", save="T0", reload=True)
def ff2(r):
    """F2 (Uthgerd 0x00091918), same as FF-1."""
    paired(r, F2, "F2")


# ============================================================================ FF-3: cosmetic, a non-teammate still takes damage

@test("FF-3", "FF", save="T0", reload=True)
def ff3(r):
    """With the toggle ON, the same attacks on a spawned deer (a non-teammate; AI off, so it neither flees nor fights) still do
    damage: it must be hurt (health drop or dead). The toggle OFF figure on a fresh deer is logged for scale. Pass per attack:
    ON hurts the deer. FAIL = the toggle also nullifies the player's damage on others."""
    orig = start(r, [F1])
    if orig is None:
        return
    checkpoint(r)
    refs = []
    try:
        for key in COSMETIC_KEYS:
            case = case_by_key(key)
            out = {}
            for on in (1, 0):
                if not ff_set(r, on, "cosmetic %s" % key):
                    out = None
                    break
                ref = spawn_dummy(r, case["dist"])
                if ref is None:
                    out = None
                    break
                refs.append(ref)
                out[on] = deliver(r, ref, case, "cosmetic %s toggle %s" % (key, "ON" if on else "OFF"), on=on)
                despawn(r, ref)
                if out[on] is None:
                    out = None
                    break
            if out is None:
                continue
            r.log("  %s: toggle OFF on a deer: %s" % (key, fmt(out[0])))
            r.check(hurt(out[1]), "%s: toggle ON still damages a non-teammate (%s)" % (key, fmt(out[1])))
    finally:
        for ref in refs:
            ctl_line(r, "DespawnRef", [s32(ref)], r"(?i)\[IEB-TEST\] DESPAWNREF ", 5)
        restore_toggle(r, orig)


# ============================================================================ FF-4: melee power attacks (best effort)

def melee_setup(r, wid, label):
    """MeleeSetup (equip + draw) with its read-back. True, or INCONCLUSIVE (inc) and False."""
    m = ctl_line(r, "MeleeSetup", [wid], r"(?i)\[IEB-TEST\] FF_MELEE (?:setup|refused)[^\r\n]*", 20)
    if not m or "equipped=1" not in m.group(0) or "drawn=1" not in m.group(0):
        inc(r, "FF-4 %s: weapon not equipped and drawn (%s)" % (label, m and m.group(0)))
        return False
    return True


@test("FF-4", "FF", save="T0", reload=True)
def ff4(r):
    """Power attacks 1H (Iron Sword) and 2H (Iron Greatsword), best effort. A deer 110 u ahead is the CONTROL: the swing event that
    hurts it is the one used on the follower. No event hurts the deer -> MANUAL (SendAnimationEvent cannot trigger it).
    On F1: 3 swings with the toggle OFF, 3 ON, followers re-placed ahead before each. Verdict: ON hurt = LEAK; OFF hurt, ON not =
    PASS (NFF toggle); neither hurt = PASS-by-Precision (blocked with the toggle OFF too: Precision's no-teammate collision, value
    logged from disk) - weaker evidence, since a follower stepping aside looks the same. The previously worn weapon is not
    restored; the test reloads."""
    orig = start(r, [F1])
    if orig is None:
        return
    val, src = precision_state()
    r.log("  Precision bNoPlayerTeammateAttackCollision = %s (%s)" % (val, src))
    checkpoint(r)
    dirty = False
    try:
        for label, wid in (("1H", IRON_SWORD), ("2H", IRON_GREATSWORD)):
            if dirty:           # F1 went down in the 1H run: clean T0 before the 2H weapon is equipped
                if not reload_t0(r, [F1], "FF-4 %s" % label):
                    break
                dirty = False
            if not melee_setup(r, wid, label):
                continue
            try:
                ev = None
                for e in POWER_EVENTS:
                    ref = spawn_dummy(r, 110.0)
                    if ref is None:
                        break
                    try:
                        if not face(r, ref, 110.0, "control %s %s" % (label, e)):
                            break
                        b = hp(r, ref)
                        ctl_line(r, "MeleeSwing", [e], r"(?i)\[IEB-TEST\] FF_MELEE swing ", 8)
                        time.sleep(3)
                        a = hp(r, ref)
                        if b and (not a or iv(a, "dead") == 1 or _fnum(b, "cur", 0) - _fnum(a, "cur", 0) > tol(b)):
                            ev = e
                            break
                    finally:
                        despawn(r, ref)
                if ev is None:
                    r.log("MANUAL FF-4 %s: no swing event from %s hurt the deer (SendAnimationEvent does not trigger a hit here); "
                          "power attack on a follower is for Shae's S-B sitting" % (label, POWER_EVENTS))
                    continue
                r.log("  FF-4 %s: control hit with event %s%s" % (label, ev, " (a PLAIN swing, proxy for a power attack)" if ev == "attackStart" else ""))
                hit = {}
                for on in (0, 1):
                    hit[on], valid = False, 0
                    for n in range(3):
                        tag = "melee %s toggle %d try %d" % (label, on, n + 1)
                        if dirty:       # RV-151 (c): F1 went down on an earlier swing; reload T0, re-equip, then set up again
                            if not reload_t0(r, [F1], tag) or not melee_setup(r, wid, label):
                                hit = None
                                break
                            dirty = False
                        if not ff_set(r, on, "melee %s" % label):
                            hit = None
                            break
                        if not calm_to(r, F1, HP_PCT, tag, tries=2):
                            hit = None
                            break
                        if not face(r, F1, 110.0, "melee %s toggle %d" % (label, on)):
                            hit = None
                            break
                        if toggle_ok(r, on, tag) is None:       # RV-151 (a): read just before the swing
                            hit = None
                            break
                        b = hp(r, F1)
                        if not at_target(b, HP_PCT):            # RV-151 (b): never graded from a start that is not the target
                            r.log("    %s: start health %s %% of max, wanted %.0f; try not counted" % (tag, b and b.get("pct"), HP_PCT))
                            continue
                        valid += 1
                        ctl_line(r, "MeleeSwing", [ev], r"(?i)\[IEB-TEST\] FF_MELEE swing ", 8)
                        time.sleep(3)
                        a = hp(r, F1)
                        if a and (iv(a, "dead") == 1 or iv(a, "bleed") == 1):
                            dirty = True
                        if b and a and (iv(a, "dead") == 1 or iv(a, "bleed") == 1 or _fnum(b, "cur", 0) - _fnum(a, "cur", 0) > tol(b)):
                            hit[on] = True
                            r.log("    %s toggle %s try %d: HURT %.0f -> %.0f" % (label, "ON" if on else "OFF", n + 1, _fnum(b, "cur", 0), _fnum(a, "cur", 0)))
                            break
                    if hit is not None and not valid:
                        inc(r, "FF-4 %s toggle %s: health setup did not hold on any of 3 tries; not graded" % (label, "ON" if on else "OFF"))
                        hit = None
                    if hit is None:
                        break
                if hit is None:
                    continue
                if hit[1]:
                    r.check(False, "LEAK FF-4 %s power attack: toggle ON still hurt F1 (OFF hurt: %s)" % (label, hit[0]))
                elif hit[0]:
                    r.check(True, "FF-4 %s power attack: hurt F1 with the toggle OFF, not ON (blocked by the NFF toggle)" % label)
                else:
                    r.check(True, "FF-4 %s power attack: no damage even with the toggle OFF (PASS-by-Precision, weaker evidence: a "
                                  "follower stepping aside looks the same; Precision teammate collision = %s on disk)" % (label, val))
            finally:
                ctl_line(r, "MeleeEnd", [wid], r"(?i)\[IEB-TEST\] FF_MELEE (?:end|refused)", 20)
    finally:
        if not dirty:       # a downed follower is not refilled: the block reloads T0 after this test
            calm_to(r, F1, 100.0, "FF-4 final refill")
        restore_toggle(r, orig)
