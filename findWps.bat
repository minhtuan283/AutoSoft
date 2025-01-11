@echo OFF
SET LookForFile1="%USERPROFILE%\desktop\WPS Writer.lnk"
:CheckForFile1
IF EXIST %LookForFile1% GOTO FoundIt1
TIMEOUT /T 2 >nul
echo Dang tim wps writer
GOTO CheckForFile1
:FoundIt1
ECHO Found: %LookForFile1%
timeout /t 2
call "C:\Program Files (x86)\Kingsoft\WPS Office\ksolaunch.exe"
timeout /t 5
taskkill /im wps.exe /f
taskkill /im wpsoffice.exe /f
taskkill /im wpspdf.exe /f
taskkill /im wpscenter.exe /f
del "%USERPROFILE%\desktop\WPS Office.lnk"
del "%USERPROFILE%\desktop\WPS PDF.lnk"
taskkill /IM wpsupdate.exe /F
del "C:\Program Files (x86)\Kingsoft\WPS Office\11.2.0.9052\office6\wpsupdate.exe"

rename "%USERPROFILE%\desktop\WPS Writer.lnk" "WPS Word.lnk"
rename "%USERPROFILE%\desktop\WPS Spreadsheets.lnk" "WPS Excel.lnk"
rename "%USERPROFILE%\desktop\WPS Presentation.lnk" "WPS PowerPoint.lnk"


call "C:\Program Files (x86)\Kingsoft\WPS Office\ksolaunch.exe"
timeout /t 5
taskkill /im wps.exe /f
taskkill /im wpsoffice.exe /f
taskkill /im wpspdf.exe /f
taskkill /im wpscenter.exe /f
call "C:\Program Files (x86)\Kingsoft\WPS Office\ksolaunch.exe"
timeout /t 5
taskkill /im wps.exe /f
taskkill /im wpsoffice.exe /f
taskkill /im wpspdf.exe /f
taskkill /im wpscenter.exe /f

exit