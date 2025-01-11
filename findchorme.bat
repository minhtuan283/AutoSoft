@echo OFF
SET LookForFile3="C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk"
:CheckForFile3
IF EXIST %LookForFile3% GOTO FoundIt3
TIMEOUT /T 2 >nul
echo Dang tim Chorme
GOTO CheckForFile3
:FoundIt3
ECHO Found: %LookForFile3%
timeout /t 1
start chrome.exe
timeout /t 8
taskkill /im chrome.exe /f
timeout /t 2



SET LookForFile1="C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk"
:CheckForFile1
IF EXIST %LookForFile1% GOTO FoundIt1
TIMEOUT /T 2 >nul
echo Dang tim Chorme
GOTO CheckForFile1
:FoundIt1
ECHO Found: %LookForFile1%
timeout /t 1
start chrome.exe
timeout /t 8
taskkill /im chrome.exe /f
timeout /t 1
exit