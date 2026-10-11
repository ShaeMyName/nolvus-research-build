# Drop-in for tts-engines\patches\turbo_slim\play_test_profile.ps1 (same -Unattended / -NoTTS switches) that goes through
# the shared-SKSE swap (swap_launch.py). harness\game.py's LAUNCHER points here after promotion (one-line change; see
# investigation\round10\play_lucienne_8c.md). -Profile defaults to the test profile, like the old script.
param([switch]$Unattended, [switch]$NoTTS, [string]$Profile = "SkyrimNet Test", [switch]$Recover, [switch]$Status)
$py = Join-Path $PSScriptRoot "swap_launch.py"
$a = @("-u", $py, "--profile", $Profile)
if ($Unattended) { $a += "--unattended" }
if ($NoTTS)      { $a += "--no-tts" }
if ($Recover)    { $a += "--recover" }
if ($Status)     { $a += "--status" }
& python @a
exit $LASTEXITCODE
