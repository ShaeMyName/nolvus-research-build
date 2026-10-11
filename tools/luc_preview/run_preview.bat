@echo off
rem Jenassa preview. Needs the key set once with:  setx LUC_PREVIEW_OR_KEY "<your OpenRouter key>"  (then open a NEW terminal)
chcp 65001 >nul
"C:\Python314\python.exe" -B "%~dp0luc_preview.py"
pause
