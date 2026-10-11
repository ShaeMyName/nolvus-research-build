@echo off
rem Lucienne's one-click play (BRIDGE_SPEC_V2.md 16.7 step 12: every Lucienne session starts here).
rem Swaps in her copies of the shared SKSE files, launches MO2 on profile "Lucienne" (TTS server + game),
rem waits for SkyrimSE.exe to exit (normal exit, crash or kill), copies the files back. Her files stay live at rest.
rem A refusal is never overridden by launching from MO2's window: fix it with  Play_Lucienne.bat --recover  or  --status.
rem If an earlier run was cut off (console closed mid-session) this warns and runs --recover first (REVIEW_LOG RV-140 (11)).
set "PY=C:\Python314\python.exe"
if not exist "%PY%" (
  echo ERROR: Python was not found at %PY%
  echo Install Python 3.14 there, or edit the PY line at the top of this file.
  pause
  exit /b 9
)
"%PY%" -u "%~dp0swap_launch.py" --profile Lucienne %*
set RC=%ERRORLEVEL%
if not "%RC%"=="0" (echo. & echo Exit code %RC%. See the lines above and C:\nolvus-research\test_runs\swap_logs\ & pause)
exit /b %RC%
