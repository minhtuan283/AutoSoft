@echo OFF

SET LookForFile4="%USERPROFILE%\desktop\Zalo.lnk"
:CheckForFile4
IF EXIST %LookForFile4% GOTO FoundIt4
TIMEOUT /T 2 >nul
echo Dang tim Zalo
GOTO CheckForFile4
:FoundIt4
ECHO Found: %LookForFile4%
timeout /t 1
call "%USERPROFILE%\AppData\Local\Programs\Zalo\Zalo.exe"
timeout /t 15
taskkill /im zalo.exe /f
timeout /t 2

SET LookForFile8="%USERPROFILE%\desktop\Zalo.lnk"
:CheckForFile8
IF EXIST %LookForFile8% GOTO FoundIt8
TIMEOUT /T 2 >nul
echo Dang tim Zalo
GOTO CheckForFile8
:FoundIt8
ECHO Found: %LookForFile8%
timeout /t 1
call "%USERPROFILE%\AppData\Local\Programs\Zalo\Zalo.exe"
timeout /t 8
taskkill /im zalo.exe /f
timeout /t 1

exit