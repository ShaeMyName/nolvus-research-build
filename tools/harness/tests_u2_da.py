"""U2 block, part 5: dialogue actions DA (DIALOGUE_OVERLAY/README.md:63-77; spec §15 DA rows). Started 2026-10-11.
House style: tests_u2.py. Log lines are matched in SkyrimNet.log (formats VERIFIED as DLL strings:
'TriggerDialogueLine firing {:08X} for {} ({} beat(s))', '[TIF-EXEC] fired info {:08X} (begin= end=) speaker {:08X}',
"Registered newly discovered external layer '{}' at top priority", '[DialogueActionsLibrary] ... blacklist entr(ies)').
NPCs are found by display name with QScan at the place (no hard-coded refs), INCONCLUSIVE if absent.

Not automated here: DA-2 (needs a test-build sentinel sentence in the layer: none ships yet -> template live sweep),
DA-7 (needs a story beat: forced-state route only, spoiler rules -> INCONCLUSIVE stub), DA-9 (married spouse: T0-M, U3).
Each LLM test costs 1-2 calls (one player line each)."""
import re, time
import game
import sn_harness as SH
from block import test, checkpoint
from fidnorm import fid_norm
from tests_misc import PLAYER, F1, F2, con, ctl_line, inc, who, qscan, iv, near_player
from tests_u2 import uuids, place, bring_back, harness_ready, market

LAYER_ID = "shae.dialogue-actions"


def sn_tail():
    return game.Tail(game.LOGS["skyrimnet"])


def find_npc(r, name, where_coc=None, radius=3000.0):
    """(fid, uuid) of a loaded NPC by display name via QScan; moves the player first if asked."""
    if where_coc:
        con(r, "coc %s" % where_coc)
        time.sleep(12)
    for d in qscan(r, radius):
        if d.get("name", "").strip() == name:
            u, _, _ = who(r, d["fid"])
            return d["fid"], u
    return None, None


def say_to(r, uuid, text, wait=90):
    SH.inject_player_input(text, uuid)
    SH.await_idle(wait)
    time.sleep(3)


FIRE_RX = r"TriggerDialogueLine firing [0-9A-F]{8} for [^\n]*|\[TIF-EXEC\] fired info [0-9A-F]{8}[^\n]*"


@test("DA-1", "DA")
def da1(r):
    """The layer loaded this session (registration line) and the DialogueActionsLibrary blacklist line is present with a
    count. Plugins -> Installed 'winning components/dialogue_action' is a dashboard check (template sweep)."""
    t = sn_tail()
    t.pos = 0
    txt = t.read()
    checkpoint(r)
    r.check(("Registered newly discovered external layer '%s'" % LAYER_ID) in txt or LAYER_ID in txt,
            "SkyrimNet.log names the %s layer this session" % LAYER_ID)
    m = re.findall(r"\[DialogueActionsLibrary\][^\n]*?(\d+) blacklist entr\(ies\)", txt)
    r.check(bool(m), "DialogueActionsLibrary blacklist line present (counts: %s)" % (m[-1] if m else "none"))


@test("DA-3", "DA", reload=True)
def da3(r):
    """At the innkeeper, ask for a room clearly: TriggerDialogueLine firing + [TIF-EXEC] fired info. Whether a vanilla
    voice line plays (VoiceSilencerManager: OnVanillaVoiceStarted) is recorded as a count. 1 LLM call."""
    if not harness_ready(r):
        return
    fid, u = find_npc(r, "Hulda", "WhiterunBanneredMare")
    if not u:
        return inc(r, "innkeeper not found in the inn (QScan by name)")
    con(r, "player.moveto %08X" % fid)
    time.sleep(4)
    if not near_player(r, fid, "player.moveto the speaker"):
        return
    checkpoint(r)
    t = sn_tail()
    say_to(r, u, "I'd like to rent a room for the night, please.")
    txt = t.read()
    fired = re.findall(FIRE_RX, txt)
    r.check(any(x.startswith("TriggerDialogueLine") for x in fired), "TriggerDialogueLine fired for the room request")
    r.check(any(x.startswith("[TIF-EXEC]") for x in fired), "[TIF-EXEC] fired info")
    r.log("  vanilla voice starts (count): %d" % len(re.findall(r"OnVanillaVoiceStarted", txt)))


@test("DA-4", "DA", reload=True)
def da4(r):
    """Clear intent only: 'Maybe later I'll want a room' -> no code fired; 'Yes, I'll take the room' -> fired. 2 LLM calls."""
    if not harness_ready(r):
        return
    fid, u = find_npc(r, "Hulda", "WhiterunBanneredMare")
    if not u:
        return inc(r, "innkeeper not found")
    con(r, "player.moveto %08X" % fid)
    time.sleep(4)
    if not near_player(r, fid, "player.moveto the speaker"):
        return
    checkpoint(r)
    t = sn_tail()
    say_to(r, u, "Maybe later I'll want a room.")
    n1 = len(re.findall(FIRE_RX, t.read()))
    t.mark()
    say_to(r, u, "Yes, I'll take the room.")
    n2 = len(re.findall(FIRE_RX, t.read()))
    r.check(n1 == 0, "'maybe later': no code fired (%d)" % n1)
    r.check(n2 >= 1, "'yes, I'll take the room': fired (%d)" % n2)


@test("DA-5", "DA", reload=True)
def da5(r):
    """Ambiguous: to a merchant who also trains (Arcadia: alchemy vendor and trainer), 'Help me out' -> no code fired.
    'A clarifying question' is the judgement half (reply text not read) -> recorded as fired/not only. 1 LLM call."""
    if not harness_ready(r):
        return
    fid, u = find_npc(r, "Arcadia", "WhiterunArcadiasCauldron")
    if not u:
        return inc(r, "merchant-trainer not found")
    con(r, "player.moveto %08X" % fid)
    time.sleep(4)
    if not near_player(r, fid, "player.moveto the speaker"):
        return
    checkpoint(r)
    t = sn_tail()
    say_to(r, u, "Help me out.")
    n = len(re.findall(FIRE_RX, t.read()))
    r.check(n == 0, "ambiguous request: no code fired (%d)" % n)


@test("DA-6", "DA", reload=True)
def da6(r):
    """Off-list proposal: ask the innkeeper for a service she doesn't offer (forge a sword) -> no code fired. The in-character
    decline / no list read out is the judgement half (S-C). 1 LLM call."""
    if not harness_ready(r):
        return
    fid, u = find_npc(r, "Hulda", "WhiterunBanneredMare")
    if not u:
        return inc(r, "innkeeper not found")
    con(r, "player.moveto %08X" % fid)
    time.sleep(4)
    if not near_player(r, fid, "player.moveto the speaker"):
        return
    checkpoint(r)
    t = sn_tail()
    say_to(r, u, "Could you forge me a steel sword?")
    n = len(re.findall(FIRE_RX, t.read()))
    r.check(n == 0, "off-list proposal: no code fired (%d)" % n)


@test("DA-8", "DA", reload=True)
def da8(r):
    """Follower blacklist (spec race R14): followers A = F1 and B = F2 (both NFF followers at T0, INFERRED); the player
    texts 'Jenassa, wait here' -> NO TriggerDialogueLine for a DialogueFollower line; SeverActions' WaitForPlayerHere runs
    on A (SA log 'WaitForPlayerHere', INFERRED name); B does not stop (B's WaitingForPlayer stays 0 via Probe).
    The 'press E on B and leave' half needs the dialogue menu: replaced by targeting A in text (INFERRED equivalent for
    the race). 1 LLM call."""
    if not market(r):
        return
    if not harness_ready(r):
        return
    au, bu = uuids(r, F1, F2)
    if not (au and bu):
        return inc(r, "followers not loaded")
    con(r, "%08X.moveto player" % F2)
    time.sleep(3)
    if not near_player(r, F2, "F2 moveto player"):
        return
    checkpoint(r)
    t, sa = sn_tail(), game.Tail(game.LOGS["sa"])
    say_to(r, au, "Jenassa, wait here.")
    txt = t.read()
    fired = re.findall(r"TriggerDialogueLine firing [0-9A-F]{8} for [^\n]*", txt)
    r.check(not fired, "no TriggerDialogueLine for a follower line (%d)" % len(fired))
    r.log("  SA WaitForPlayerHere lines (count): %d" % len(re.findall(r"(?i)WaitForPlayerHere", sa.read() + txt)))
    m = ctl_line(r, "Probe", [F2], r"\[IEB-TEST\] probe [^\n]*")
    wfp = re.search(r"wfp=(\S+)", m.group(0)) if m else None
    r.check(bool(wfp) and float(wfp.group(1)) == 0.0, "B keeps following (wfp=%s)" % (wfp.group(1) if wfp else "?"))


@test("DA-2", "DA")
def da2(r):
    """Sentinel sentence in the dialogue_response trace: the layer ships no test sentinel yet -> template live sweep."""
    checkpoint(r)
    inc(r, "no test-build sentinel in shae.dialogue-actions yet (template live sweep item)")


@test("DA-7", "DA")
def da7(r):
    """Consequential quest beat: needs a forced story state (spoiler rules, private record) -> not in U2."""
    checkpoint(r)
    inc(r, "needs a forced-state story beat; deferred to the forced-state route")


# DA-9 is a real test in tests_u3 (on T0-M); no U2 stub, so the ID is registered once.
