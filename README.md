# build/ (TASK_C, local only, never pushed)

`upstream/`: unmodified sources at the pins (TASK_C phase 0, 2026-10-09). Installed copies were used where the mod ships them; IntelEngine's .psc come from `repos/IntelEngine-Gerk` @ `5b69e41` (the release ships no sources; its .pex = the repo's .pex, byte-identical).
`shipped/`: the shipped .pex of every script TASK_C patches, with `SHA256SUMS`.

| File | Source | Installed vs pinned repo |
|---|---|---|
| `intelengine-3.5.1/Source/Scripts/IntelEngine_Core.psc` | repo@pin | n/a (repo only) |
| `intelengine-3.5.1/Source/Scripts/IntelEngine_StoryEngine.psc` | repo@pin | n/a (repo only) |
| `intelengine-3.5.1/Source/Scripts/IntelEngine_Battle.psc` | repo@pin | n/a (repo only) |
| `intelengine-3.5.1/actions/cancelcurrenttask.yaml` | installed | eol-only |
| `relationships-2.0.1/src/scripts/SNRom_Bridge.psc` | installed | exact |
| `relationships-2.0.1/src/scripts/SNRom_Decorators.psc` | installed | exact |
| `relationships-2.0.1/prompts/snrom_author_disposition.prompt` | installed | exact (repo path `SKSE/Plugins/SkyrimNet/prompts/`) |
| `skyrimnet-b25.1/prompts/submodules/system_head/0020_format_rules.prompt` | installed | exact |
| `skyrimnet-b25.1/prompts/components/dialogue_action.prompt` | installed | exact |
| `skyrimnet-b25.1/prompts/submodules/user_final_instructions/0750_embedded_actions.prompt` | installed | exact |
| `severactions-4.2.0/prompts/submodules/user_final_instructions/0750_embedded_actions.prompt` | installed | exact |
| `maras-0.11.0/prompts/submodules/guidelines/0501_marriage_chances.prompt` | installed | exact |
| `maras-0.11.0/SKSE/Plugins/PackageOverrides.ini` | installed | exact |
| `severactions-4.2.0/actions/undress.yaml` | installed | exact |
| `severactions-4.2.0/actions/unequiparmor.yaml` | installed | exact |
| `severactions-4.2.0/actions/waitforplayerhere.yaml` | installed | exact |
| `severactions-4.2.0/actions/resumefollowing.yaml` | installed | exact |
| `severactions-4.2.0/actions/setcompanion.yaml` | installed | exact |
| `severactions-4.2.0/actions/startfollowing.yaml` | installed | exact |

Pins: IntelEngine 3.5.1 `5b69e41`, Relationships 2.0.1 `08619f3`, SeverActions 4.2.0 `702a124`, SkyrimNet Beta 25.1 `0cef7ee`, MARAS 0.11.0 `0b25bed`.
`eol-only` = same bytes after CRLF to LF (release zip vs git checkout).
