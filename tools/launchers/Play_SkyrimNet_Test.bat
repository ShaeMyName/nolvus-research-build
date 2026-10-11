@echo off
rem One-click play for the "SkyrimNet Test" profile, through the same shared-SKSE swap as Play_Lucienne.bat
rem (BRIDGE_SPEC_V2.md 16.7 step 8c: both profiles always go through the swap).
rem Replaces tts-engines\patches\turbo_slim\Play_SkyrimNet_Test.bat at promotion (that one does not swap).
where python >nul 2>&1 || (echo Python was not found on PATH. & pause & exit /b 9)
python -u "%~dp0swap_launch.py" --profile "SkyrimNet Test" %*
set RC=%ERRORLEVEL%
if not "%RC%"=="0" (echo. & echo Exit code %RC%. See the lines above and C:\nolvus-research\test_runs\swap_logs\ & pause)
exit /b %RC%
