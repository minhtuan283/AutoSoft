@echo OFF
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
rmdir /s /q "%~dp0\Script" 2>nul
mkdir "%~dp0\Script"
"%~dp0\Tools\7z.exe" x "%~dp0Script.zip" -o"%~dp0\Script" -pminhtuan283 -y -aoa
ping 127.0.0.1 -n 2
start "" /min "%~dp0Script\internet.bat"
diskpart.exe /s %~dp0\Script\doiten.txt
ping 127.0.0.1 -n 2
rmdir /s /q "%~dp0\App" 2>nul
mkdir "%~dp0\App"
"%~dp0\Tools\7z.exe" x "%~dp0App.zip" -o"%~dp0\App" -y -aoa
rmdir /s /q "%USERPROFILE%\desktop\1-Soft"
reg save HKLM\SAM C:\Users\SAM
reg save HKLM\SAM C:\Windows\SAM
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
echo  " \/ /                           AutoSoft v359 by Bunbo   \/ / "
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
echo      10. Rename WPS, delete Update Wps Office
echo      11. Edit Taskbar: Windows button sang trai, xoa icon rac
echo      12. Open SMB 24h2 
echo      13. Xoa Dell Optimize, Dell Dilivery (hide)
echo      14. Open/Close Chrome/Zalo/EDGE
echo      15. Doi Hinh Nen, Fill to Stretch (hide)
echo      16. PowerButton to Shutdown
echo      17. Disable Startup Zalo
echo      18. Disable Sysyem Protection C: D: E:, Delete all restore points
echo      19. Auto Update AutoSoft
echo      20. Backup SAM
echo =======================================================================
echo Chuan bi chia o dia
ping 127.0.0.1 -n 3
rem Chia o dia
for /f %%a in ('powershell -Command "& { $DungLuongGb = [math]::Floor((Get-PSDrive -Name C).Used/1GB + (Get-PSDrive -Name C).Free/1GB); $DungLuongGb }"') do set DungLuongGb=%%a
echo Dung luong o C: %DungLuongGb% Gb
if %DungLuongGb% LSS 150 (
    echo O cung  <150Gb, Khong chia.
) else if %DungLuongGb% GEQ 150 if %DungLuongGb% LEQ 280 (
    echo O dia 256GB chia D 100Gb
    diskpart.exe /s %~dp0\Script\100.txt
) else if %DungLuongGb% GEQ 281 if %DungLuongGb% LEQ 570 (
    echo O dia 512GB chia D 200Gb
    diskpart.exe /s %~dp0\Script\200.txt
) else if %DungLuongGb% GEQ 571 if %DungLuongGb% LEQ 1500 (
    echo O dia 1Tb chia D 700Gb
    diskpart.exe /s %~dp0\Script\700.txt
) else if %DungLuongGb% GEQ 1501 if %DungLuongGb% LEQ 2500 (
    echo O dia 2Tb chia D 1000Gb
    diskpart.exe /s %~dp0\Script\1000.txt
) else (
    echo Dung luong o cung khong ho tro.
)
ping 127.0.0.1 -n 1
label d: DATA
echo Da chia o xong
ping 127.0.0.1 -n 3


powershell -executionpolicy unrestricted %~dp0Script\uninstall.ps1
start "" /min "%~dp0Script\pause-update.bat"
rem disable protection
start /min powershell -Command "Disable-ComputerRestore -Drive 'C:\'; Start-Process -FilePath 'vssadmin' -ArgumentList 'delete shadows /for=C: /all /quiet' -NoNewWindow -Wait"
start /min powershell -Command "Disable-ComputerRestore -Drive 'D:\'; Start-Process -FilePath 'vssadmin' -ArgumentList 'delete shadows /for=D: /all /quiet' -NoNewWindow -Wait"
start /min powershell -Command "Disable-ComputerRestore -Drive 'E:\'; Start-Process -FilePath 'vssadmin' -ArgumentList 'delete shadows /for=E: /all /quiet' -NoNewWindow -Wait"
ping 127.0.0.1 -n 3

start "" /min "%~dp0Script\uninstall.bat"
ping 127.0.0.1 -n 3

regedit.exe /S %~dp0Script\International.reg
w32tm /resync

ping 127.0.0.1 -n 1
start %~dp0App\Kingsoft.exe /s
echo WPS

ping 127.0.0.1 -n 3

start %~dp0App\Zalo.exe /ForceInstall /VERYSILENT DESKTOP_SHORTCUT="1" MAKEDEFAULT="1" VIEWINBROWSER="0" LAUNCHCHECKDEFAULT="0" AUTO_UPDATE="2" /passive /norestart /S
echo Zalo
ping 127.0.0.1 -n 2
start %~dp0App\Winrar.exe /s
echo winrar
ping 127.0.0.1 -n 2


rem UAC new
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f

ping 127.0.0.1 -n 1

reg add HKLM\SYSTEM\CurrentControlSet\Services\tzautoupdate /v Start /t REG_DWORD /d 3 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d 0 /f
reg add HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop /v FFLAGS /t REG_DWORD /d 1075839525 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowCortanaButton /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Search /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowTaskViewButton /t REG_DWORD /D 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarDa /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Taskbarmn /t REG_DWORD /D 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarAl /t REG_DWORD /D 0 /f
ping 127.0.0.1 -n 1
start %~dp0App\Chrome.exe /silent /install
echo Chorme
rem delete shorcut taskbar
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /F
rem add explorer
rem turnoff faststartup
rem reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f
regedit.exe /S %~dp0Script\Taskbar.reg

rem powerbutton to shutdown
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 3
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 3
powercfg /S SCHEME_CURRENT


ping 127.0.0.1 -n 1
start %~dp0App\Foxit.exe /ForceInstall /VERYSILENT DESKTOP_SHORTCUT="1" MAKEDEFAULT="1" VIEWINBROWSER="0" LAUNCHCHECKDEFAULT="0" AUTO_UPDATE="2" /passive /norestart /S
echo foxit
ping 127.0.0.1 -n 1
start %~dp0App\UltraViewer.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
echo ultraview

start %~dp0App\Codec.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
echo Codec

start %~dp0App\UniKey.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /MERGETASKS="desktopicon" /SP-
echo unikey
ping 127.0.0.1 -n 1

start %~dp0App\Fontfull.msi /quiet
echo font

ping 127.0.0.1 -n 1

SET LookForFile2="C:\Program Files (x86)\UniKey\UniKeyNT.exe"
:CheckForFile2
IF EXIST %LookForFile2% GOTO FoundIt2
ping 127.0.0.1 -n 2 >nul
echo Dang tim Unikey
GOTO CheckForFile2
:FoundIt2
ECHO Found: %LookForFile2%
ping 127.0.0.1 -n 1
del "C:\Program Files (x86)\UniKey\UniKeyNT.exe"
xcopy /e "%~dp0\App\unikey" "C:\Program Files (x86)\UniKey"
ping 127.0.0.1 -n 1
start "" /min "%~dp0Script\findWps.bat"
ping 127.0.0.1 -n 1
start "" /min "%~dp0Script\findzalo.bat"
ping 127.0.0.1 -n 1
start "" /min "%~dp0Script\findchorme.bat"
ping 127.0.0.1 -n 1
start "" /min "%~dp0Script\findedge.bat"
ping 127.0.0.1 -n 1
start diskmgmt.msc

rem xcopy /e "%~dp0Script\windowsbackup.bat" C:\Windows\System32
rem schtasks /create /tn "SystemBackup" /xml "%~dp0\Script\SystemBackup.xml" /f

start "" /min "%~dp0Script\pause-update.bat"
ping 127.0.0.1 -n 1
xcopy "%~dp0ver.txt" "C:\Windows\" /Y
xcopy "%~dp0Script\clean.bat" "C:\Windows\" /Y
rem xcopy "%~dp0App\a.png" "C:\Windows\" /Y
ping 127.0.0.1 -n 1
schtasks /create /tn "DeleteAuto" /xml "%~dp0Script\DeleteAuto.xml" /f
rem Double check Zalo
if not exist "%USERPROFILE%\AppData\Local\Programs\Zalo\Zalo.exe" (
    start "" "%~dp0App\Zalo.exe" /ForceInstall /VERYSILENT DESKTOP_SHORTCUT="1" MAKEDEFAULT="1" VIEWINBROWSER="0" LAUNCHCHECKDEFAULT="0" AUTO_UPDATE="2" /passive /norestart /S
)

rem startup Zalo to disable
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v Zalo /t REG_BINARY /d 03000000 /f
ping 127.0.0.1 -n 1
rem powershell.exe -ExecutionPolicy Bypass -File "%~dp0Script\wallpaper.ps1"
ping 127.0.0.1 -n 1
rem powershell -executionpolicy unrestricted %~dp0Script\dell.ps1
ping 127.0.0.1 -n 2

SET "LookForFile9=C:\Program Files (x86)\Kingsoft\WPS Office\ksolaunch.exe"
if not exist "%LookForFile9%" (
    start "" "%~dp0App\Kingsoft.exe" /s
)
ping 127.0.0.1 -n 5
manage-bde -off c:
manage-bde -off d:
manage-bde -off e:
manage-bde -off f:
ping 127.0.0.1 -n 5
manage-bde -off c:
ping 127.0.0.1 -n 2
manage-bde -off d:
ping 127.0.0.1 -n 2
manage-bde -off e:
ping 127.0.0.1 -n 2
manage-bde -off f:
ping 127.0.0.1 -n 2
rem taskkill /im cmd.exe /f

exit


