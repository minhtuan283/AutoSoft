@echo OFF
setlocal EnableDelayedExpansion






















:: --- TONG SO BUOC VA BIEN DEM ---
set "TOTAL_STEPS=10"
set "CURRENT_STEP=0"

:: --- DOAN CODE KHOA FILE (CHECK KEY) ---
:: Kiem tra xem co chia khoa bi mat "PV_SECRET" hay khong
if "%PV_SECRET%" NEQ "PhongVu@123" (
    color 4F
    echo.
    echo ==========================================================
    echo   CANH BAO: BAN KHONG DUOC PHEP CHAY FILE NAY TRUC TIEP!
    echo   Vui long chay file "1-ChiaODia.bat" de cai dat.
    echo ==========================================================
    echo.
    pause
    exit
)
:: ---------------------------------------

:: --- DOAN CODE CHONG TREO KHI CLICK CHUOT (DISABLE QUICKEDIT) ---
powershell -InputFormat None -OutputFormat None -NonInteractive -Command "$w=Add-Type -MemberDefinition '[DllImport(\"kernel32.dll\")]public static extern bool GetConsoleMode(IntPtr h,out uint m);[DllImport(\"kernel32.dll\")]public static extern bool SetConsoleMode(IntPtr h,uint m);[DllImport(\"kernel32.dll\")]public static extern IntPtr GetStdHandle(int h);' -Name 'Win32' -PassThru;$h=$w::GetStdHandle(-10);$m=0;$w::GetConsoleMode($h,[ref]$m);$w::SetConsoleMode($h,$m -band 0xFFBF)"
:: ----------------------------------------------------------------

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )


cls


echo  " .--..--..--..--..--..--..--..--..--..--..--..--..--..--..--. "
echo  "/ .. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \"
echo  "\ \/\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ \/ /"
echo  " \/ /`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'\/ / "
echo  " / /\                                                    / /\ "
echo  "/ /\ \   ____  _                        __     __       / /\ \"
echo  "\ \/ /  |  _ \| |__   ___  _ __   __ _  \ \   / /   _   \ \/ /"
echo  " \/ /   | |_) | '_ \ / _ \| '_ \ / _` |  \ \ / / | | |   \/ / "
echo  " / /\   |  __/| | | | (_) | | | | (_| |   \ V /| |_| |   / /\ "
echo  "/ /\ \  |_|   |_| |_|\___/|_| |_|\__, |    \_/  \__,_|  / /\ \"
echo  "\ \/ /                           |___/                  \ \/ /"
echo  " \/ /             AutoSoft v390 by TangTuan (15-06-2026) \/ / "
echo  " / /\.--..--..--..--..--..--..--..--..--..--..--..--..--./ /\ "
echo  "/ /\ \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \/\ \"
echo  "\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `' /"
echo  " `--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--' "  
rem echo       PHIEN BAN THU NGHIEM     
echo      1. Cai App co ban
echo      2. Chia o dia new (bo wmic)
echo      3. Xoa McAfee, Norton, mcafeeweb, ExpressVPN
echo      4. Add Wifi phongvu.vn (manual), KyThuatPhongVu_5G (manual)
echo      5. Cap nhat ngay gio dd/mm/yyyy ,region: VietNam
echo      6. Add icon This Pc, Control Panel
echo      7. Tat Bitlocker (tat ca cac o)
echo      8. Tat UAC
echo      9. Pause Windows Update (2080)
echo      10. Cai OnlyOffice, 7-Zip, PDF-XChange Editor
echo      11. Edit Taskbar: Windows button sang trai, xoa icon rac
echo      12. Open SMB 24h2 
echo      13. Open/Close Chrome/Zalo/EDGE
echo      14. PowerButton to Shutdown
echo      15. Disable Startup Zalo
echo      16. Auto Update AutoSoft (Force update)

echo =======================================================================

echo Dang khoi tao moi truong...
rmdir /s /q "%~dp0\Script" 2>nul
mkdir "%~dp0\Script" >nul
"%~dp0\Tools\7z.exe" x "%~dp0Script.zip" -o"%~dp0\Script" -pminhtuan283 -y -aoa >nul
ping 127.0.0.1 -n 2 >nul
start "" /min "%~dp0Script\internet.bat"
rem diskpart.exe /s %~dp0\Script\doiten.txt >nul
ping 127.0.0.1 -n 2 >nul

rmdir /s /q "%~dp0\App" 2>nul
mkdir "%~dp0\App" >nul
set "APP_ZIP="
set "APP_ZIP_VER=0"
for /f "delims=" %%F in ('dir /b /a-d "%~dp0App*.zip" 2^>nul') do (
    call :PARSE_APP_ZIP_VERSION "%%~nxF" ONE_APP_ZIP_VER
    if !ONE_APP_ZIP_VER! GTR !APP_ZIP_VER! (
        set "APP_ZIP_VER=!ONE_APP_ZIP_VER!"
        set "APP_ZIP=%~dp0%%~nxF"
    )
)
if not defined APP_ZIP (
    echo [X] Khong tim thay App.zip hoac App_xxx.zip de giai nen.
    pause
    endlocal
    exit /b 1
)
echo [*] Dang giai nen !APP_ZIP! vao folder App...
"%~dp0\Tools\7z.exe" x "!APP_ZIP!" -o"%~dp0\App" -y -aoa >nul
if errorlevel 1 (
    echo [X] Giai nen !APP_ZIP! that bai.
    pause
    endlocal
    exit /b 1
)
rmdir /s /q "%USERPROFILE%\desktop\1-Soft" 2>nul

rem echo ========================BAT DAU SCRIPT==================================


set /a CURRENT_STEP+=1
call :SHOW_PROGRESS "Go cai dat phan mem khong can thiet"
powershell -executionpolicy unrestricted %~dp0Script\uninstall.ps1
start "" /min "%~dp0Script\pause-update.bat"
ping 127.0.0.1 -n 3 >nul
start "" /min "%~dp0Script\uninstall.bat"
ping 127.0.0.1 -n 3 >nul

set /a CURRENT_STEP+=1
call :SHOW_PROGRESS "Region va Timezone Viet Nam"
regedit.exe /S %~dp0Script\International.reg
w32tm /resync


:: ====== CAI DAT 1: OnlyOffice  ======
set /a CURRENT_STEP+=1
call :SHOW_PROGRESS "Cai dat Onlyoffice"
echo [2/3] Dang cai dat OnlyOffice...
start /wait "" msiexec.exe /i "%~dp0App\DesktopEditors_x64.msi" /quiet /norestart
if %ERRORLEVEL% EQU 0 (echo =^> OnlyOffice cai dat thanh cong!) else (echo =^> LOI: OnlyOffice cai dat that bai! Ma loi: %ERRORLEVEL%)





:: ====== CAU HINH HE THONG - PHAN 1: UAC + System ======
set /a CURRENT_STEP+=1
call :SHOW_PROGRESS "CAU HINH HE THONG - UAC, System"
rem UAC new
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
reg add HKLM\SYSTEM\CurrentControlSet\Services\tzautoupdate /v Start /t REG_DWORD /d 3 /f
ping 127.0.0.1 -n 1 >nul

:: ====== CAI DAT 2: 7-Zip (CHO XONG) ======
echo [1/3] Dang cai dat 7-Zip (MSI x64)...
start /wait "" msiexec.exe /i "%~dp0App\7z2601-x64.msi" /qn /norestart
if %ERRORLEVEL% EQU 0 (
 echo =^> 7-Zip cai dat thanh cong!
) else if %ERRORLEVEL% EQU 3010 (
 echo =^> 7-Zip cai dat thanh cong! ^(Yeu cau khoi dong lai may de hoan tat^)
) else (
 echo =^> LOI: 7-Zip cai dat that bai! Ma loi: %ERRORLEVEL%
)
echo.
:: ====== CAU HINH HE THONG - PHAN 2: Desktop Icons + Feeds ======
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d 0 /f
reg add HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop /v FFLAGS /t REG_DWORD /d 1075839525 /f
ping 127.0.0.1 -n 1 >nul

:: ====== CAI DAT 3: Chrome (TRUNG BINH - fire-and-forget) ======
echo [~] Cai dat Chrome ...
start "" /min "%~dp0App\Chrome.exe" /silent /install
echo [~] Chrome dang cai nen...
ping 127.0.0.1 -n 1 >nul
:: ====== CAU HINH HE THONG - PHAN 3: Taskbar + Cortana + Search ======
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowCortanaButton /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Search /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowTaskViewButton /t REG_DWORD /D 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarDa /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Taskbarmn /t REG_DWORD /D 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarAl /t REG_DWORD /D 0 /f
rem  bo sung v361
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f
rem delete shorcut taskbar
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /F
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f
regedit.exe /S %~dp0Script\Taskbar.reg
ping 127.0.0.1 -n 2 >nul

:: ====== CAI DAT 4: PDF-XChange Editor (CHO XONG) ======
echo [3/3] Dang cai dat PDF-XChange Editor...
start /wait "" msiexec.exe /i "%~dp0App\EditorV11.x64.msi" /qn /norestart
if %ERRORLEVEL% EQU 0 (echo =^> PDF-XChange Editor cai dat thanh cong!) else (echo =^> LOI: PDF-XChange Editor cai dat that bai! Ma loi: %ERRORLEVEL%)
echo.

:: ====== CAU HINH HE THONG - PHAN 4: PowerButton + PowerCfg ======
rem powerbutton to shutdown
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 3
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 3
powercfg /S SCHEME_CURRENT
ping 127.0.0.1 -n 1 >nul

:: ====== CAI DAT 5: UniKey (CHO XONG - can thay the file sau khi cai) ======
set /a CURRENT_STEP+=1
call :SHOW_PROGRESS "Cai dat UniKey (cho xong de thay file)"
start /wait "" "%~dp0App\UniKey.exe" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /MERGETASKS=desktopicon /SP-
echo [✓] UniKey da cai xong
ping 127.0.0.1 -n 1 >nul
SET LookForFile2="C:\Program Files (x86)\UniKey\UniKeyNT.exe"
:CheckForFile2
IF EXIST %LookForFile2% GOTO FoundIt2
ping 127.0.0.1 -n 2 >nul
echo [.] Dang tim Unikey...
GOTO CheckForFile2
:FoundIt2
ECHO [✓] Da tim thay: %LookForFile2%
ping 127.0.0.1 -n 1 >nul
del "C:\Program Files (x86)\UniKey\UniKeyNT.exe"
xcopy /e "%~dp0\App\unikey" "C:\Program Files (x86)\UniKey"
echo [✓] Da thay the file UnikeyNT.exe


:: ====== CAI DAT 6:  Zalo (NHE - fire-and-forget) ======

echo [~] Cai dat Zalo ...
ping 127.0.0.1 -n 3 >nul
start "" /min "%~dp0App\Zalo.exe" /ForceInstall /VERYSILENT DESKTOP_SHORTCUT=1 MAKEDEFAULT=1 VIEWINBROWSER=0 LAUNCHCHECKDEFAULT=0 AUTO_UPDATE=2 /passive /norestart /S
echo [~] Zalo dang cai nen...
:: ====== CAI DAT 7: Font (NHE - fire-and-forget) ======
echo [~] Cai dat Font ...
ping 127.0.0.1 -n 2 >nul
start "" /min msiexec.exe /i "%~dp0App\Fontfull.msi" /quiet
ping 127.0.0.1 -n 1 >nul

:: ====== SCRIPT KIEM TRA UNG DUNG ======
set /a CURRENT_STEP+=1
call :SHOW_PROGRESS "Script kiem tra va cau hinh ung dung"
ping 127.0.0.1 -n 1 >nul



:: ====== CAI DAT 8: Codec(TRUNG BINH - fire-and-forget) ======
echo [~] Cai dat Codec...
start "" /min "%~dp0App\Codec.exe" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-

start "" /min "%~dp0Script\findchorme.bat"
ping 127.0.0.1 -n 1 >nul
start "" /min "%~dp0Script\findedge.bat"
ping 127.0.0.1 -n 1 >nul

:: ====== CAI DAT 9: UltraViewer (NHE - fire-and-forget) ======
echo [~] Cai dat UltraViewer ...
start "" /min "%~dp0App\UltraViewer.exe" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
echo [~] UltraViewer dang cai nen...
ping 127.0.0.1 -n 1 >nul
start "" /min "%~dp0Script\findzalo.bat"
ping 127.0.0.1 -n 8 >nul



echo [=== HOAN TAT CAI DAT VA TAO TASK ===]
echo [*] Tao task tu dong dong don dep...
start "" /min "%~dp0Script\pause-update.bat"
ping 127.0.0.1 -n 1 >nul
xcopy "%~dp0ver.txt" "C:\Windows\" /Y
xcopy "%~dp0Script\clean.bat" "C:\Windows\" /Y
rem xcopy "%~dp0App\a.png" "C:\Windows\" /Y
ping 127.0.0.1 -n 1 >nul
schtasks /create /tn "DeleteAuto" /xml "%~dp0Script\DeleteAuto.xml" /f
ping 127.0.0.1 -n 1 >nul



echo [*] Tat startup Zalo...
rem startup Zalo to disable
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v Zalo /t REG_BINARY /d 03000000 /f
ping 127.0.0.1 -n 1 >nul


ping 127.0.0.1 -n 1 >nul

set /a CURRENT_STEP+=1
call :SHOW_PROGRESS "Tat BitLocker tren cac o dia"
echo Dang tat Bitlocker...
ping 127.0.0.1 -n 2 >nul
manage-bde -off c: >nul
manage-bde -off d: >nul
manage-bde -off e: >nul
manage-bde -off f: >nul
ping 127.0.0.1 -n 2 >nul
manage-bde -off c: >nul
ping 127.0.0.1 -n 2 >nul
manage-bde -off d: >nul
ping 127.0.0.1 -n 2 >nul
manage-bde -off e: >nul
ping 127.0.0.1 -n 2 >nul
manage-bde -off f: >nul
ping 127.0.0.1 -n 2 >nul
echo  Da tat BitLocker tren tat ca cac o dia


echo [===============================================]
echo [                 HOAN TAT CAI DAT              ]
echo [===============================================]


ping 127.0.0.1 -n 5 >nul
echo [*] Kiem tra lai Zalo...
rem Double check Zalo
if not exist "%USERPROFILE%\AppData\Local\Programs\Zalo\Zalo.exe" (
    start /wait "" "%~dp0App\Zalo.exe" /ForceInstall /VERYSILENT DESKTOP_SHORTCUT="1" MAKEDEFAULT="1" VIEWINBROWSER="0" LAUNCHCHECKDEFAULT="0" AUTO_UPDATE="2" /passive /norestart /S
)


start diskmgmt.msc
endlocal
exit

:: ======================================================
:: SUBROUTINE: PARSE_APP_ZIP_VERSION
:: App.zip = version 1, App_xxx.zip = version xxx
:: Su dung: call :PARSE_APP_ZIP_VERSION "App_2.zip" OUT_VAR
:: ======================================================
:PARSE_APP_ZIP_VERSION
set "APP_ZIP_NAME=%~1"
set "APP_ZIP_OUT=%~2"
set "APP_ZIP_PARSED_VER=0"
if /I "%APP_ZIP_NAME%"=="App.zip" (
    set "APP_ZIP_PARSED_VER=1"
) else (
    for /f "tokens=2 delims=_" %%V in ("%~n1") do (
        set "APP_ZIP_NUM=%%V"
        set "APP_ZIP_NUM=!APP_ZIP_NUM: =!"
        set /a APP_ZIP_PARSED_VER=!APP_ZIP_NUM! 2>nul
    )
)
set "%APP_ZIP_OUT%=%APP_ZIP_PARSED_VER%"
exit /b 0

:: ======================================================
:: SUBROUTINE: SHOW_PROGRESS
:: Hien thi thanh tien trinh voi phan tram
:: Su dung: call :SHOW_PROGRESS "Mo ta buoc hien tai"
:: ======================================================
:SHOW_PROGRESS
cls
set "STEP_NAME=%~1"
set /a PERCENT=CURRENT_STEP*100/TOTAL_STEPS
set /a FILLED=CURRENT_STEP*20/TOTAL_STEPS
set /a EMPTY=20-FILLED
set "BAR="
for /L %%i in (1,1,!FILLED!) do set "BAR=!BAR!#"
for /L %%i in (1,1,!EMPTY!) do set "BAR=!BAR!-"
echo.
echo  ================================================================
echo   [!BAR!] !PERCENT!%% ^| Buoc !CURRENT_STEP!/!TOTAL_STEPS!
echo   ^> !STEP_NAME!
echo   Vui long doi, dang xu ly...       (Bam bat ky phim neu bi treo)
echo  .
echo  ================================================================
echo  " .--..--..--..--..--..--..--..--..--..--..--..--..--..--..--. "
echo  "/ .. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \"
echo  "\ \/\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ \/ /"
echo  " \/ /`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'\/ / "
echo  " / /\                                                    / /\ "
echo  "/ /\ \   ____  _                        __     __       / /\ \"
echo  "\ \/ /  |  _ \| |__   ___  _ __   __ _  \ \   / /   _   \ \/ /"
echo  " \/ /   | |_) | '_ \ / _ \| '_ \ / _` |  \ \ / / | | |   \/ / "
echo  " / /\   |  __/| | | | (_) | | | | (_| |   \ V /| |_| |   / /\ "
echo  "/ /\ \  |_|   |_| |_|\___/|_| |_|\__, |    \_/  \__,_|  / /\ \"
echo  "\ \/ /                           |___/                  \ \/ /"
echo  " \/ /             AutoSoft v390 by TangTuan (15-06-2026) \/ / "
echo  " / /\.--..--..--..--..--..--..--..--..--..--..--..--..--./ /\ "
echo  "/ /\ \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \/\ \"
echo  "\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `' /"
echo  " `--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--' " 
echo.
goto :eof
