Scriptname IEB_SceneMain extends ReferenceAlias
{SceneControls player-alias script (spec §11.7-§11.9, §11.10 P2, §11.13.3, §11.13.8). FROZEN property list (spec §16.4):
 the 8 globals, the 2 FormLists, PlayerRef. Everything else is looked up with Game.GetFormFromFile.
 - Scene key: starts a scene with the crosshair target (never a child, P2) or ends it. Auto-off on load, combat, location change.
 - Partners: StorageUtil form list IEB_ScenePartners on the player; IEB_IsScenePartner = 1 on each. JoinScene (with the
   existing partners' say) and LeaveScene arrive through IEB_SceneActions; walk-away removal at 2x radius for 10 s.
 - IEB_ScenePrivate on the player: 1 only while no live NPC outside the partners is within the current awareness radius.
 - ieb_witness events: (a) exposure begins, (b) new area while exposed, (c) intimate scene in public; beast-form transformation
   (M7b, from IEB_BeastFormHook). 60 s global floor.
 - Whisper owner: situation rule with hysteresis, manual-override detection, override key, restore after load.
 One chained RegisterForSingleUpdate loop (never RegisterForUpdate): 2 s while a scene is on, else 5 s; booked first.}

; ---- FROZEN property list (spec §16.4 freeze rule). Never add, remove or rename. ----
GlobalVariable Property IEB_SceneEnabled Auto
GlobalVariable Property IEB_SceneKey Auto
GlobalVariable Property IEB_NarratorKey Auto
GlobalVariable Property IEB_WhisperKey Auto
GlobalVariable Property IEB_WhisperAuto Auto
GlobalVariable Property IEB_WitnessEnabled Auto
GlobalVariable Property IEB_SceneSpare01 Auto
GlobalVariable Property IEB_SceneSpare02 Auto
FormList Property IEB_MinimalBody Auto
FormList Property IEB_Smallclothes Auto
Actor Property PlayerRef Auto

Int _sceneKey
Int _whisperKey
Int _tick
Int _privClear
Int _whisperPending
Int _whisperHold
Bool _whisperRestore
Int _skipManual
Float _lastWitnessRT
Float _lastSceneWitnessRT
Cell _lastCell

; ============================================================================ constants

Int Function MaxPartners()
    Return 3
EndFunction

Float Function WitnessFloor()
    Return 60.0
EndFunction

Float Function SceneWitnessEvery()
    Return 300.0
EndFunction

String Function PartnersKey()
    Return "IEB_ScenePartners"
EndFunction

Bool Function SceneOn()
    Return StorageUtil.GetIntValue(PlayerRef, "IEB_SceneMode", 0) == 1
EndFunction

Bool Function Enabled()
    Return IEB_SceneEnabled.GetValue() >= 1.0
EndFunction

; ============================================================================ start-up

Event OnInit()
    Startup("init")
EndEvent

Event OnPlayerLoadGame()
    Startup("load")
EndEvent

Function Startup(String asWhy)
    RegisterForSingleUpdate(3.0)             ; arm the chain FIRST; the first tick is the 3 s whisper-restore settle (§11.9 a)
    _whisperRestore = True
    _lastWitnessRT = -1000.0
    _lastSceneWitnessRT = -1000.0
    _privClear = 0
    _whisperPending = -1
    _whisperHold = 0
    _lastCell = PlayerRef.GetParentCell()
    EndScene("auto_" + asWhy, False)         ; auto-off on load (§11.7); no notification
    RegisterWitnessSchema()
    SeedLists()
    _sceneKey = -1
    _whisperKey = -1
    SyncKeys()
    Log("startup (" + asWhy + "): enabled=" + Enabled() + " sceneKey=" + _sceneKey + " lists=" + IEB_MinimalBody.GetSize() + "/" + IEB_Smallclothes.GetSize())
EndFunction

Function RegisterWitnessSchema()
    String fields = "[{\"name\":\"subject\",\"type\":0,\"required\":true,\"description\":\"Who is seen\"}," + \
        "{\"name\":\"state\",\"type\":0,\"required\":true,\"description\":\"What can be seen, one fixed phrase\"}," + \
        "{\"name\":\"with\",\"type\":0,\"required\":false,\"description\":\"Who they are with\",\"defaultValue\":\"\"}," + \
        "{\"name\":\"place\",\"type\":0,\"required\":false,\"description\":\"Where\",\"defaultValue\":\"\"}]"
    String formats = "{\"recent_events\":\"**{{subject}}** {{state}}{% if with != \\\"\\\" %} with {{with}}{% endif %} ({{time_desc}})\"," + \
        "\"raw\":\"{{subject}} {{state}}{% if with != \\\"\\\" %} with {{with}}{% endif %}\"," + \
        "\"compact\":\"{{subject}} {{state}}\"," + \
        "\"verbose\":\"{{subject}} {{state}}{% if with != \\\"\\\" %} with {{with}}{% endif %}{% if place != \\\"\\\" %} ({{place}}){% endif %}\"}"
    Int rc = SkyrimNetApi.RegisterEventSchema("ieb_witness", "Witnessed", "Something plainly visible about a person nearby", fields, formats, False, 0, True, False)
    Log("ieb_witness schema registered rc=" + rc)
EndFunction

Function SeedLists()
    {Seed items from R3 item 5 §3 (FormIDs verified in the active load order, 2026-10-09). Adds only what is missing and
     installed, so a later body may extend these lists mid-save. Body (slot 32) underwear -> IEB_MinimalBody;
     smallclothes on slots 52/53/60 -> IEB_Smallclothes.}
    String de = "Apachii_DivineEleganceStore.esm"
    Int[] ids = new Int[30]
    ids[0] = 0x02FFF7
    ids[1] = 0x02FFF9
    ids[2] = 0x02FFFB
    ids[3] = 0x02FFFD
    ids[4] = 0x02FFFF
    ids[5] = 0x030001
    ids[6] = 0x03056A
    ids[7] = 0x03103E
    ids[8] = 0x03103B
    ids[9] = 0x031B19
    ids[10] = 0x031B1B
    ids[11] = 0x031B1D
    ids[12] = 0x031B1F
    ids[13] = 0x031B21
    ids[14] = 0x031B23
    ids[15] = 0x031B25
    ids[16] = 0x031B27
    ids[17] = 0x031B29
    ids[18] = 0x031B2B
    ids[19] = 0x031B2D
    ids[20] = 0x0320A7
    ids[21] = 0x0320A5
    ids[22] = 0x0320B6
    ids[23] = 0x0320B7
    Int i = 0
    While i < 24
        AddSeed(IEB_MinimalBody, ids[i], de)
        i += 1
    EndWhile
    String marika = "[full_inu] Queen Marika's Dress.esp"
    AddSeed(IEB_Smallclothes, 0x801, marika)
    AddSeed(IEB_Smallclothes, 0x83A, marika)
    AddSeed(IEB_Smallclothes, 0x83B, marika)
    AddSeed(IEB_Smallclothes, 0x83F, marika)
    AddSeed(IEB_Smallclothes, 0x842, marika)
    AddSeed(IEB_Smallclothes, 0x843, marika)
    AddSeed(IEB_Smallclothes, 0x816, "DX Druid Armor.esp")
    AddSeed(IEB_Smallclothes, 0xD74, "Collygon - Necrolock.esp")
EndFunction

Function AddSeed(FormList akList, Int aiForm, String asPlugin)
    If !Game.IsPluginInstalled(asPlugin)
        Return
    EndIf
    Form f = Game.GetFormFromFile(aiForm, asPlugin)
    If f != None && !akList.HasForm(f)
        akList.AddForm(f)
    EndIf
EndFunction

; ============================================================================ the one update loop

Event OnUpdate()
    If SceneOn()
        RegisterForSingleUpdate(2.0)         ; booked FIRST: an error later in this tick can't break the chain
    Else
        RegisterForSingleUpdate(5.0)
    EndIf
    _tick += 1
    SyncKeys()
    If _whisperRestore
        _whisperRestore = False
        WhisperRestore()
    EndIf
    If !Enabled()
        If SceneOn()
            EndScene("disabled", True)
        EndIf
        Return
    EndIf
    If Utility.IsInMenuMode()
        Return
    EndIf
    Bool combat = PlayerRef.IsInCombat()
    If SceneOn() && combat
        EndScene("combat", True)
    EndIf
    ExposureCheck()
    Cell c = PlayerRef.GetParentCell()
    If c != _lastCell
        _lastCell = c
        NewAreaWitness()
    EndIf
    If SceneOn()
        SceneUpkeep()
    EndIf
    If !SceneOn() || _tick % 3 == 0          ; whisper about every 5-6 s
        WhisperTick(combat)
    EndIf
EndEvent

; ============================================================================ keys

Function SyncKeys()
    Int s = IEB_SceneKey.GetValueInt()
    Int w = IEB_WhisperKey.GetValueInt()
    If w == s
        w = 0
    EndIf
    If s == _sceneKey && w == _whisperKey
        Return
    EndIf
    UnregisterForAllKeys()
    If s > 0
        RegisterForKey(s)
    EndIf
    If w > 0
        RegisterForKey(w)
    EndIf
    _sceneKey = s
    _whisperKey = w
EndFunction

Event OnKeyUp(Int keyCode, Float holdTime)
    If keyCode <= 0 || UI.IsTextInputEnabled() || Utility.IsInMenuMode() || !Enabled()
        Return
    EndIf
    If keyCode == _sceneKey
        If SceneOn()
            EndScene("key", True)
        Else
            StartScene()
        EndIf
    ElseIf keyCode == _whisperKey
        Int o = (StorageUtil.GetIntValue(PlayerRef, "IEB_WhisperOverride", 0) + 1) % 3
        StorageUtil.SetIntValue(PlayerRef, "IEB_WhisperOverride", o)
        If o == 1
            Debug.Notification("Whisper: forced on")
        ElseIf o == 2
            Debug.Notification("Whisper: forced off")
        Else
            Debug.Notification("Whisper: automatic")
        EndIf
        _whisperHold = 0
        WhisperTick(PlayerRef.IsInCombat())
    EndIf
EndEvent

; ============================================================================ scene (§11.7, §11.13.3, §11.13.8)

Function StartScene()
    Actor t = Game.GetCurrentCrosshairRef() as Actor
    If t == None || t == PlayerRef || t.IsDead() || !t.HasKeyword(ActorTypeNPC())
        Debug.Notification("Scene: no one in sight")
        Return
    EndIf
    If t.IsChild()
        Debug.Notification("Scene: refused")
        Log("SCENE_REFUSED child " + FormHex(t))
        Return
    EndIf
    If PlayerRef.IsInCombat()
        Debug.Notification("Scene: not in combat")
        Return
    EndIf
    StorageUtil.FormListClear(PlayerRef, PartnersKey())
    StorageUtil.SetIntValue(PlayerRef, "IEB_SceneMode", 1)
    AddPartner(t)
    ; at scene start nobody else near = private at once (no hysteresis yet), so (c) never fires to an audience of the
    ; partner alone (§11.13.3); afterwards the usual first-finding / 2-clear-checks rule applies
    If !PlayerRef.IsInCombat() && CountOthers(CurrentRadius()) == 0
        StorageUtil.SetIntValue(PlayerRef, "IEB_ScenePrivate", 1)
        _privClear = 2
    Else
        StorageUtil.SetIntValue(PlayerRef, "IEB_ScenePrivate", 0)
        _privClear = 0
    EndIf
    _lastSceneWitnessRT = -1000.0
    If StorageUtil.GetIntValue(PlayerRef, "IEB_ScenePrivate", 0) == 0
        SceneWitness()                       ; (c) at scene start, unless private
    EndIf
    Debug.Notification("Scene mode on")
    Log("SCENE_ON partner " + FormHex(t))
    RegisterForSingleUpdate(2.0)
EndFunction

Function EndScene(String asWhy, Bool abNotify)
    Bool wasOn = SceneOn()
    Int n = StorageUtil.FormListCount(PlayerRef, PartnersKey())
    Int i = 0
    While i < n
        Form f = StorageUtil.FormListGet(PlayerRef, PartnersKey(), i)
        If f != None
            StorageUtil.UnsetIntValue(f, "IEB_IsScenePartner")
            StorageUtil.UnsetIntValue(f, "IEB_AwayTicks")
        EndIf
        i += 1
    EndWhile
    StorageUtil.FormListClear(PlayerRef, PartnersKey())
    StorageUtil.SetIntValue(PlayerRef, "IEB_SceneMode", 0)
    StorageUtil.SetIntValue(PlayerRef, "IEB_ScenePrivate", 0)
    _privClear = 0
    If wasOn
        If abNotify
            Debug.Notification("Scene mode off")
        EndIf
        Log("SCENE_OFF (" + asWhy + ")")
    EndIf
EndFunction

Function AddPartner(Actor akActor)
    StorageUtil.FormListAdd(PlayerRef, PartnersKey(), akActor, False)
    StorageUtil.SetIntValue(akActor, "IEB_IsScenePartner", 1)
    StorageUtil.UnsetIntValue(akActor, "IEB_AwayTicks")
EndFunction

Function RemovePartner(Actor akActor, String asWhy)
    StorageUtil.FormListRemove(PlayerRef, PartnersKey(), akActor, True)
    StorageUtil.UnsetIntValue(akActor, "IEB_IsScenePartner")
    StorageUtil.UnsetIntValue(akActor, "IEB_AwayTicks")
    Log("PARTNER_LEFT " + FormHex(akActor) + " (" + asWhy + ")")
    If StorageUtil.FormListCount(PlayerRef, PartnersKey()) == 0
        EndScene("last_partner_left", True)
    Else
        _privClear = 0
        PrivacyCheck()
    EndIf
EndFunction

Function SceneUpkeep()
    Float r2 = 2.0 * CurrentRadius()
    Int i = StorageUtil.FormListCount(PlayerRef, PartnersKey()) - 1
    While i >= 0 && SceneOn()
        Actor p = StorageUtil.FormListGet(PlayerRef, PartnersKey(), i) as Actor
        If p == None || p.IsDead() || p.IsDisabled()
            If p != None
                RemovePartner(p, "gone")
            Else
                StorageUtil.FormListRemoveAt(PlayerRef, PartnersKey(), i)
            EndIf
        ElseIf p.GetDistance(PlayerRef) > r2
            Int away = StorageUtil.GetIntValue(p, "IEB_AwayTicks", 0) + 1
            StorageUtil.SetIntValue(p, "IEB_AwayTicks", away)
            If away >= 5                     ; 5 ticks x 2 s = 10 s beyond 2x radius
                RemovePartner(p, "walked_away")
            EndIf
        Else
            StorageUtil.UnsetIntValue(p, "IEB_AwayTicks")
        EndIf
        i -= 1
    EndWhile
    If !SceneOn()
        Return
    EndIf
    PrivacyCheck()
    If StorageUtil.GetIntValue(PlayerRef, "IEB_ScenePrivate", 0) == 0 && Utility.GetCurrentRealTime() - _lastSceneWitnessRT >= SceneWitnessEvery()
        SceneWitness()                       ; (c) at most every 5 real minutes while witnessed
    EndIf
EndFunction

Function PrivacyCheck()
    {§11.13.3: private (1) only while no live, enabled ActorTypeNPC outside the partners is within the CURRENT radius
     and not in combat. Private -> witnessed on the first finding (and (c) fires at once); witnessed -> private after
     2 consecutive clear checks. A missing key reads 0 in templates, so failure means camera-neutral.}
    Int cur = StorageUtil.GetIntValue(PlayerRef, "IEB_ScenePrivate", 0)
    Bool clear = !PlayerRef.IsInCombat() && CountOthers(CurrentRadius()) == 0
    If !clear
        _privClear = 0
        If cur == 1
            StorageUtil.SetIntValue(PlayerRef, "IEB_ScenePrivate", 0)
            Log("PRIVATE 1->0")
            SceneWitness()
        EndIf
    Else
        _privClear += 1
        If cur == 0 && _privClear >= 2
            StorageUtil.SetIntValue(PlayerRef, "IEB_ScenePrivate", 1)
            Log("PRIVATE 0->1")
        EndIf
    EndIf
EndFunction

Int Function CountOthers(Float afRadius)
    {Live, enabled ActorTypeNPC actors within the radius, other than the player and the listed partners.}
    ObjectReference[] refs = PO3_SKSEFunctions.FindAllReferencesOfFormType(PlayerRef, 43, afRadius)
    Int n = 0
    Int i = 0
    Keyword kw = ActorTypeNPC()
    While i < refs.Length
        Actor a = refs[i] as Actor
        If a != None && a != PlayerRef && !a.IsDead() && !a.IsDisabled() && a.HasKeyword(kw)
            If StorageUtil.GetIntValue(a, "IEB_IsScenePartner", 0) != 1
                n += 1
            EndIf
        EndIf
        i += 1
    EndWhile
    Return n
EndFunction

Float Function CurrentRadius()
    Return SkyrimNetApi.GetConfigFloat("game", "interaction.maxDistance", 800.0)
EndFunction

Keyword Function ActorTypeNPC()
    Return Game.GetFormFromFile(0x00013794, "Skyrim.esm") as Keyword
EndFunction

; ---------------------------------------------------------------------------- join / leave (§11.13.8)

Function JoinScene(Actor akActor)
    {Order: child -> scene off -> out of radius -> partner cap -> existing partners' check -> add.}
    If akActor == None
        Return
    EndIf
    If akActor.IsChild()
        Log("JOIN_REFUSED " + FormHex(akActor) + " child")
        Return
    EndIf
    If !SceneOn() || !Enabled()
        Log("JOIN_REFUSED " + FormHex(akActor) + " scene_off")
        Return
    EndIf
    If StorageUtil.GetIntValue(akActor, "IEB_IsScenePartner", 0) == 1
        Return
    EndIf
    If akActor.GetDistance(PlayerRef) > CurrentRadius()
        Log("JOIN_REFUSED " + FormHex(akActor) + " out_of_radius")
        Return
    EndIf
    Int n = StorageUtil.FormListCount(PlayerRef, PartnersKey())
    If n >= MaxPartners()
        Log("JOIN_REFUSED " + FormHex(akActor) + " cap")
        Return
    EndIf
    ; existing partners' say: any partner at or above Relationships' CONSUMING_MIN refuses
    Int minExcl = SNRom_Bridge.CONSUMING_MIN()
    Actor firstObj = None
    Int firstExcl = 0
    Int objectors = 0
    Int i = 0
    While i < n
        Actor p = StorageUtil.FormListGet(PlayerRef, PartnersKey(), i) as Actor
        If p != None && StorageUtil.HasIntValue(p, "SNRom_Exclusivity")
            Int e = StorageUtil.GetIntValue(p, "SNRom_Exclusivity", 0)
            If e >= minExcl
                If firstObj == None
                    firstObj = p
                    firstExcl = e
                EndIf
                If objectors < 2
                    objectors += 1
                EndIf
            EndIf
        EndIf
        i += 1
    EndWhile
    String pname = PlayerRef.GetDisplayName()
    String jname = akActor.GetDisplayName()
    If firstObj != None
        SkyrimNetApi.RegisterPersistentEvent(firstObj.GetDisplayName() + " would not share " + pname + " with " + jname + "; " + jname + " did not join the scene.", firstObj, akActor)
        Int told = 0
        i = 0
        While i < n && told < 2
            Actor p = StorageUtil.FormListGet(PlayerRef, PartnersKey(), i) as Actor
            If p != None && StorageUtil.HasIntValue(p, "SNRom_Exclusivity") && StorageUtil.GetIntValue(p, "SNRom_Exclusivity", 0) >= minExcl
                SkyrimNetApi.DirectNarration("", p, akActor)
                told += 1
            EndIf
            i += 1
        EndWhile
        Log("JOIN_REFUSED " + FormHex(akActor) + " by " + FormHex(firstObj) + " excl=" + firstExcl)
        Return
    EndIf
    String partners = PartnerNames()
    AddPartner(akActor)
    _privClear = 0
    PrivacyCheck()
    SNRom_Bridge b = Game.GetFormFromFile(0x00000D62, "SNRom_Integration.esl") as SNRom_Bridge
    If b != None
        b.IEB_QueueIntimacy(akActor)         ; queues only if due, adult, enrolled, and authoring is switched on
    EndIf
    SkyrimNetApi.RegisterPersistentEvent(jname + " joined " + pname + " and " + partners + " in the scene.", akActor, PlayerRef)
    i = 0
    While i < n
        Actor p = StorageUtil.FormListGet(PlayerRef, PartnersKey(), i) as Actor
        If p != None && p != akActor
            SkyrimNetApi.DirectNarration("", p, akActor)
        EndIf
        i += 1
    EndWhile
    Log("JOIN_ACCEPTED " + FormHex(akActor) + " partners=" + (n + 1))
EndFunction

Function LeaveScene(Actor akActor)
    If akActor == None || StorageUtil.GetIntValue(akActor, "IEB_IsScenePartner", 0) != 1
        Return
    EndIf
    RemovePartner(akActor, "left")
EndFunction

String Function PartnerNames()
    {"A", "A and B", "A, B and C".}
    Int n = StorageUtil.FormListCount(PlayerRef, PartnersKey())
    String s = ""
    Int i = 0
    While i < n
        Actor p = StorageUtil.FormListGet(PlayerRef, PartnersKey(), i) as Actor
        If p != None
            If s == ""
                s = p.GetDisplayName()
            ElseIf i == n - 1
                s = s + " and " + p.GetDisplayName()
            Else
                s = s + ", " + p.GetDisplayName()
            EndIf
        EndIf
        i += 1
    EndWhile
    Return s
EndFunction

; ============================================================================ witness events (§11.8)

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
    RegisterForSingleUpdate(1.0)             ; debounce: the next tick (1 s after the last change) re-checks exposure
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
    RegisterForSingleUpdate(1.0)
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    If SceneOn()
        EndScene("location", True)           ; auto-off (§11.7)
    EndIf
    If StorageUtil.GetStringValue(PlayerRef, "IEB_WhisperSource", "auto") == "manual"
        StorageUtil.SetStringValue(PlayerRef, "IEB_WhisperSource", "auto")   ; manual override lasts until here
        Log("WHISPER manual override ended (location change)")
    EndIf
    _whisperHold = 0
    _lastCell = PlayerRef.GetParentCell()
    NewAreaWitness()
EndEvent

Int Function ExposureState()
    {0 COVERED, 1 MINIMAL, 2 EXPOSED (§11.8 a).}
    Form body = PlayerRef.GetWornForm(0x00000004)
    If body != None
        If IEB_MinimalBody.HasForm(body)
            Return 1
        EndIf
        Return 0
    EndIf
    Form s52 = PlayerRef.GetWornForm(0x00400000)
    Form s53 = PlayerRef.GetWornForm(0x00800000)
    Form s60 = PlayerRef.GetWornForm(0x40000000)
    If (s52 != None && IEB_Smallclothes.HasForm(s52)) || (s53 != None && IEB_Smallclothes.HasForm(s53)) || (s60 != None && IEB_Smallclothes.HasForm(s60))
        Return 1
    EndIf
    Return 2
EndFunction

String Function ExposurePhrase(Int aiState)
    If aiState == 1
        Return "is wearing only smallclothes"
    EndIf
    Return "is wearing no body garment"
EndFunction

Function ExposureCheck()
    If BeastForm(PlayerRef) != ""
        Return                               ; the beast's body is its own cover (R3 item 5 §4 B2)
    EndIf
    Int now = ExposureState()
    Int was = StorageUtil.GetIntValue(PlayerRef, "IEB_ExposureState", 0)
    If now == was
        Return
    EndIf
    StorageUtil.SetIntValue(PlayerRef, "IEB_ExposureState", now)
    If now > 0
        FireWitness(ExposurePhrase(now), "", "exposure")      ; (a) on a transition into MINIMAL or EXPOSED
    EndIf
EndFunction

Function NewAreaWitness()
    {(b) New area while still exposed: once per location (or cell) per game day.}
    Int st = StorageUtil.GetIntValue(PlayerRef, "IEB_ExposureState", 0)
    If st == 0 || BeastForm(PlayerRef) != ""
        Return
    EndIf
    Form place = PlayerRef.GetCurrentLocation()
    If place == None
        place = PlayerRef.GetParentCell()
    EndIf
    If place == None
        Return
    EndIf
    Float today = Utility.GetCurrentGameTime()
    Float last = StorageUtil.GetFloatValue(place, "IEB_WitnessDay", -10.0)
    If today - last < 1.0
        Return
    EndIf
    If FireWitness(ExposurePhrase(st), "", "new_area")
        StorageUtil.SetFloatValue(place, "IEB_WitnessDay", today)
    EndIf
EndFunction

Function SceneWitness()
    {(c) Intimate scene in public; with = every partner.}
    If !SceneOn() || StorageUtil.GetIntValue(PlayerRef, "IEB_ScenePrivate", 0) == 1
        Return
    EndIf
    Actor first = StorageUtil.FormListGet(PlayerRef, PartnersKey(), 0) as Actor
    If FireWitness("is being physically intimate", PartnerNames(), "scene", first)
        _lastSceneWitnessRT = Utility.GetCurrentRealTime()
    EndIf
EndFunction

Function BeastWitness(String asForm)
    {M7b, from IEB_BeastFormHook: one event at the moment of transformation (the GameMaster's timer is not relied on).}
    FireWitness("transforms into a " + asForm + " in plain sight", "", "beast_form")
EndFunction

Bool Function FireWitness(String asState, String asWith, String asWhy, Actor akTarget = None)
    If !Enabled() || IEB_WitnessEnabled.GetValue() < 1.0
        Return False
    EndIf
    Float now = Utility.GetCurrentRealTime()
    If now < _lastWitnessRT
        _lastWitnessRT = -1000.0             ; real time restarted with the game
    EndIf
    If now - _lastWitnessRT < WitnessFloor()
        Log("WITNESS skipped by the 60 s floor (" + asWhy + ")")
        Return False
    EndIf
    String place = ""
    Location loc = PlayerRef.GetCurrentLocation()
    If loc != None
        place = loc.GetName()
    EndIf
    String data = "{\"subject\":\"" + JsonEsc(PlayerRef.GetDisplayName()) + "\",\"state\":\"" + JsonEsc(asState) + \
        "\",\"with\":\"" + JsonEsc(asWith) + "\",\"place\":\"" + JsonEsc(place) + "\"}"
    Int rc = SkyrimNetApi.RegisterEvent("ieb_witness", data, PlayerRef, akTarget)
    _lastWitnessRT = now
    Log("WITNESS " + asWhy + " rc=" + rc)
    Return True
EndFunction

String Function JsonEsc(String s)
    {Escapes backslash and double quote for the event JSON.}
    String out = ""
    Int n = StringUtil.GetLength(s)
    Int i = 0
    While i < n
        String ch = StringUtil.GetNthChar(s, i)
        If ch == "\"" || ch == "\\"
            out += "\\" + ch
        Else
            out += ch
        EndIf
        i += 1
    EndWhile
    Return out
EndFunction

String Function BeastForm(Actor akActor)
    {The player's beast form by race display name, as the creature-filter Form line matches it; "" if none.}
    Race r = akActor.GetRace()
    If r == None
        Return ""
    EndIf
    String n = r.GetName()
    If n == "Werewolf" || n == "Vampire Lord" || n == "Werebear"
        Return n
    EndIf
    Return ""
EndFunction

; ============================================================================ whisper owner (§11.9)

Bool Function WhisperIsOn()
    Float cur = SkyrimNetApi.GetConfigFloat("game", "interaction.maxDistance", -1.0)
    Float w = SkyrimNetApi.GetConfigFloat("game", "interaction.whisperMaxDistance", -2.0)
    Return cur == w
EndFunction

Function SetWhisper(Bool abOn)
    If WhisperIsOn() != abOn
        SkyrimNetApi.TriggerToggleWhisperMode()
        _skipManual = 1                      ; our own toggle: don't read it back as a manual change next tick
    EndIf
    StorageUtil.SetIntValue(PlayerRef, "IEB_WhisperWanted", abOn as Int)
EndFunction

Function WhisperRestore()
    {(a) 3 s after a load (SkyrimNet has reset whisper to off by then): restore a manual override, else run the rule.}
    String src = StorageUtil.GetStringValue(PlayerRef, "IEB_WhisperSource", "auto")
    Bool wanted
    If src == "manual" || StorageUtil.GetIntValue(PlayerRef, "IEB_WhisperOverride", 0) != 0
        wanted = Desired(PlayerRef.IsInCombat(), True)
    Else
        wanted = Desired(PlayerRef.IsInCombat(), False)
    EndIf
    If Enabled() && IEB_WhisperAuto.GetValue() >= 1.0
        SetWhisper(wanted)
    EndIf
    _whisperHold = 0
    _whisperPending = -1
    Log("WHISPER_RESTORE source=" + src + " on=" + WhisperIsOn())
EndFunction

Bool Function Desired(Bool abCombat, Bool abKeepManual)
    Int o = StorageUtil.GetIntValue(PlayerRef, "IEB_WhisperOverride", 0)
    If o == 1
        Return True
    ElseIf o == 2
        Return False
    EndIf
    If abKeepManual
        Return StorageUtil.GetIntValue(PlayerRef, "IEB_WhisperWanted", 0) == 1
    EndIf
    If abCombat
        Return False
    EndIf
    Return PrivatePlace()
EndFunction

Bool Function PrivatePlace()
    {(b): interior cell and any of (i) player house, (ii) rented room, (iii) alone together.}
    Cell c = PlayerRef.GetParentCell()
    If c == None || !c.IsInterior()
        Return False
    EndIf
    Location loc = PlayerRef.GetCurrentLocation()
    Keyword house = Game.GetFormFromFile(0x000FC1A3, "Skyrim.esm") as Keyword
    If loc != None && house != None && loc.HasKeyword(house)
        Return True
    EndIf
    ObjectReference[] furn = PO3_SKSEFunctions.FindAllReferencesOfFormType(PlayerRef, 40, 500.0)
    ActorBase me = PlayerRef.GetActorBase()
    Int i = 0
    While i < furn.Length
        If furn[i] != None && furn[i].GetActorOwner() == me
            Return True
        EndIf
        i += 1
    EndWhile
    Float normal = SkyrimNetApi.GetConfigFloat("game", "interaction.normalMaxDistance", 800.0)
    Return CountOthers(normal) == 0
EndFunction

Function WhisperTick(Bool abCombat)
    If IEB_WhisperAuto.GetValue() < 1.0
        Return
    EndIf
    Bool isOn = WhisperIsOn()
    Int wantedNow = StorageUtil.GetIntValue(PlayerRef, "IEB_WhisperWanted", 0)
    ; manual change detection: the state differs from what we last set, and we did not set it
    If _skipManual > 0
        _skipManual -= 1
    ElseIf StorageUtil.GetIntValue(PlayerRef, "IEB_WhisperOverride", 0) == 0 && (isOn as Int) != wantedNow
        If StorageUtil.GetStringValue(PlayerRef, "IEB_WhisperSource", "auto") != "manual"
            StorageUtil.SetStringValue(PlayerRef, "IEB_WhisperSource", "manual")
            StorageUtil.SetIntValue(PlayerRef, "IEB_WhisperWanted", isOn as Int)
            Log("WHISPER manual override detected (on=" + isOn + ")")
        EndIf
        Return
    EndIf
    If StorageUtil.GetStringValue(PlayerRef, "IEB_WhisperSource", "auto") == "manual" && StorageUtil.GetIntValue(PlayerRef, "IEB_WhisperOverride", 0) == 0
        Return                               ; leave a manual choice alone until the next location change
    EndIf
    Bool want = Desired(abCombat, False)
    If want == isOn
        _whisperPending = -1
        _whisperHold = 0
        Return
    EndIf
    If abCombat || StorageUtil.GetIntValue(PlayerRef, "IEB_WhisperOverride", 0) != 0
        SetWhisper(want)                     ; combat and the explicit override act at once
        Log("WHISPER " + want + " (immediate)")
        Return
    EndIf
    If _whisperPending == (want as Int)
        _whisperHold += 1
    Else
        _whisperPending = want as Int
        _whisperHold = 1
    EndIf
    If _whisperHold >= 2                     ; hysteresis: 2 consecutive checks
        SetWhisper(want)
        Log("WHISPER " + want)
        _whisperHold = 0
        _whisperPending = -1
    EndIf
EndFunction

; ============================================================================ misc

String Function FormHex(Form f)
    If f == None
        Return "None"
    EndIf
    Return PO3_SKSEFunctions.IntToString(f.GetFormID(), True)
EndFunction

Function Log(String asMsg)
    Debug.Trace("[IEB-SC] " + asMsg)
EndFunction
