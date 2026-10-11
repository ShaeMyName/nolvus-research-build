@echo off
rem Lucienne's one-click play (BRIDGE_SPEC_V2.md 16.7 step 12: every Lucienne session starts here).
rem Swaps in her copies of the shared SKSE files, launches MO2 on profile "Lucienne" (TTS server + game),
rem waits for SkyrimSE.exe to exit (normal exit, crash or kill), copies the files back. A refusal is never
rem overridden by launching from MO2's window: fix it with  Play_Lucienne.bat --recover  or  --status.
where python >nul 2>&1 || (echo Python was not found on PATH. & pause & exit /b 9)
python -u "%~dp0swap_launch.py" --profile Lucienne %*
set RC=%ERRORLEVEL%
if not "%RC%"=="0" (echo. & echo Exit code %RC%. See the lines above and C:\nolvus-research\test_runs\swap_logs\ & pause)
exit /b %RC%
