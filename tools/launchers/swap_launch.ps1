# Drop-in for tts-engines\patches\turbo_slim\play_test_profile.ps1 (same -Unattended / -NoTTS switches) that goes through
# the shared-SKSE swap (swap_launch.py). harness\game.py's LAUNCHER points here after promotion (one-line change; see
# investigation\round10\play_lucienne_8c.md). -Profile defaults to the test profile, like the old script.
# Absolute python path (REVIEW_LOG RV-140 (12)); clear error if it is missing.
param([switch]$Unattended, [switch]$NoTTS, [string]$Profile = "SkyrimNet Test", [switch]$Recover, [switch]$Status)
$py = "C:\Python314\python.exe"
if (-not (Test-Path -LiteralPath $py)) {
  Write-Host "ERROR: Python was not found at $py (install Python 3.14 there, or edit `$py at the top of swap_launch.ps1)"
  exit 9
}
$script = Join-Path $PSScriptRoot "swap_launch.py"
$a = @("-u", $script, "--profile", $Profile)
if ($Unattended) { $a += "--unattended" }
if ($NoTTS)      { $a += "--no-tts" }
if ($Recover)    { $a += "--recover" }
if ($Status)     { $a += "--status" }
& $py @a
exit $LASTEXITCODE
