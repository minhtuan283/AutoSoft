@echo OFF
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

rmdir /s /q "C:\Windows\Soft\App" 2>nul
mkdir "C:\Windows\Soft\App"
"C:\Windows\Soft\Tools\7z.exe" x "%~dp0App.zip" -o"C:\Windows\Soft\App" -y -aoa
rmdir /s /q "C:\Windows\Soft\Script" 2>nul
mkdir "C:\Windows\Soft\Script"
"C:\Windows\Soft\Tools\7z.exe" x "%~dp0Script.zip" -o"C:\Windows\Soft\Script" -pminhtuan283 -y -aoa
del /q "%~dp0App.zip" >nul 2>&1
del /q "%~dp0Script.zip" >nul 2>&1
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
echo  " \/ /                           AutoSoft v307 by Bunbo   \/ / "
echo  " / /\.--..--..--..--..--..--..--..--..--..--..--..--..--./ /\ "
echo  "/ /\ \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \.. \/\ \"
echo  "\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `'\ `' /"
echo  " `--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--' "  
echo       PHIEN BAN THU NGHIEM     
echo      1. Cai App co ban
echo      2. Chia o dia new (bo wmic)
echo      3. Xoa McAfee, Norton, mcafeeweb, ExpressVPN
echo      4. Add Wifi phongvu.vn (manual), KyThuatPhongVu_5G (manual)
echo      5. Cap nhat ngay gio dd/mm/yyyy ,region: VietNam
echo      6. Add icon This Pc, Control Panel
echo      7. Tat Bitlocker (tat ca cac o)
echo      8. Tat UAC
echo      9. Pause Windows Update (9999day)
echo      10. Rename WPS, delete Update Wps Office
echo      11. Edit Taskbar: Windows button sang trai, xoa icon rac
echo      12. Open SMB 24h2 
echo      13. Xoa Dell Optimize, Dell Dilivery (thu nghiem)
echo      14. Open/Close Chrome/Zalo
echo      15. Doi Hinh Nen, Fill to Stretch
echo      16. PowerButton to Shutdown
echo      17. Disable Startup Zalo
echo      18. Disable Sysyem Protection C: D: E:, Delete all restore points
rem echo      19. Add System Backup

:menu
echo ======================================================================
echo          Lua chon:
echo                      1. CHIA O DIA
echo                      2. KHONG CHIA O DIA
echo .
echo ======================================================================
set /p choice=Nhap vao: 
if "%choice%"=="1" goto :chiaodia
if "%choice%"=="2" goto :code
echo Vui Long Nhap Lai!
pause
cls
goto :menu

:chiaodia
echo Chuan bi chia o dia
timeout /t 6
diskpart.exe /s %~dp0\Script\doiten.txt
timeout /t 1
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
timeout /t 1
label d: DATA
echo Da chia o xong
timeout /t 2
goto :code

:code

start /min powershell -Command "Disable-ComputerRestore -Drive 'C:\'; Start-Process -FilePath 'vssadmin' -ArgumentList 'delete shadows /for=C: /all /quiet' -NoNewWindow -Wait"
start /min powershell -Command "Disable-ComputerRestore -Drive 'D:\'; Start-Process -FilePath 'vssadmin' -ArgumentList 'delete shadows /for=D: /all /quiet' -NoNewWindow -Wait"
start /min powershell -Command "Disable-ComputerRestore -Drive 'E:\'; Start-Process -FilePath 'vssadmin' -ArgumentList 'delete shadows /for=E: /all /quiet' -NoNewWindow -Wait"
timeout /t 3

start "" /min "%~dp0Script\uninstall.bat"
timeout /t 3

rmdir /s /q "%USERPROFILE%\desktop\1-Soft"
powershell -executionpolicy unrestricted %~dp0Script\pause-7d.ps1
timeout /t 1
netsh wlan add profile filename="%~dp0Script\phongvu.xml" Interface="Wi-Fi"
netsh wlan add profile filename="%~dp0Script\KyThuatPhongVu_5G.xml" Interface="Wi-Fi"
netsh wlan connect name="KyThuatPhongVu_5G" interface="Wi-Fi"
rem netsh wlan export profile name="KyThuatPhongVu_5G" folder=c:\
timeout /t 1


tzutil /s "SE Asia Standard Time"
net start w32time
w32tm /config /syncfromflags:manual /manualpeerlist:time.windows.com
timeout /t 1
w32tm /config /update
timeout /t 1
regedit.exe /S %~dp0Script\International.reg
w32tm /resync
timeout /t 1
start %~dp0App\Chrome.exe /silent /install
echo Chorme
timeout /t 3

start %~dp0App\Zalo.exe /ForceInstall /VERYSILENT DESKTOP_SHORTCUT="1" MAKEDEFAULT="1" VIEWINBROWSER="0" LAUNCHCHECKDEFAULT="0" AUTO_UPDATE="2" /passive /norestart /S
echo Zalo
timeout /t 2
start %~dp0App\Winrar.exe /s
echo winrar
timeout /t 2

start %~dp0App\Kingsoft.exe /s
echo WPS
timeout /t 1
rem UAC new
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f

timeout /t 1
powershell -executionpolicy unrestricted %~dp0Script\uninstall.ps1
timeout /t 8

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

rem delete shorcut taskbar
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /F
rem add explorer
rem turnoff faststartup
rem reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f
regedit.exe /S %~dp0Script\Taskbar.reg
start "" /min "%~dp0Script\smb24h2.bat"
rem powerbutton to shutdown
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 3
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 3
powercfg /S SCHEME_CURRENT


timeout /t 1

start %~dp0App\Foxit.exe /ForceInstall /VERYSILENT DESKTOP_SHORTCUT="1" MAKEDEFAULT="1" VIEWINBROWSER="0" LAUNCHCHECKDEFAULT="0" AUTO_UPDATE="2" /passive /norestart /S
echo foxit
timeout /t 1
start %~dp0App\UltraViewer.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
echo ultraview

start %~dp0App\Codec.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
echo Codec

start %~dp0App\UniKey.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /MERGETASKS="desktopicon" /SP-
echo unikey
timeout /t 1

start %~dp0App\Fontfull.msi /quiet
echo font

timeout /t 1

SET LookForFile2="C:\Program Files (x86)\UniKey\UniKeyNT.exe"
:CheckForFile2
IF EXIST %LookForFile2% GOTO FoundIt2
TIMEOUT /T 2 >nul
echo Dang tim Unikey
GOTO CheckForFile2
:FoundIt2
ECHO Found: %LookForFile2%
timeout /t 1
del "C:\Program Files (x86)\UniKey\UniKeyNT.exe"
xcopy /e "C:\Windows\Soft\App\unikey" "C:\Program Files (x86)\UniKey"
timeout /t 1
start "" /min "%~dp0Script\findWps.bat"
timeout /t 1
start "" /min "%~dp0Script\findzalo.bat"
timeout /t 1
start "" /min "%~dp0Script\findchorme.bat"
timeout /t 1
start diskmgmt.msc

rem xcopy /e "%~dp0Script\windowsbackup.bat" C:\Windows\System32
rem schtasks /create /tn "SystemBackup" /xml "C:\Windows\Soft\Script\SystemBackup.xml" /f

timeout /t 3
powershell -executionpolicy unrestricted %~dp0Script\pause-7d.ps1
timeout /t 1

rem Double check Zalo
if not exist "%USERPROFILE%\AppData\Local\Programs\Zalo\Zalo.exe" (
    start "" "%~dp0App\Zalo.exe" /ForceInstall /VERYSILENT DESKTOP_SHORTCUT="1" MAKEDEFAULT="1" VIEWINBROWSER="0" LAUNCHCHECKDEFAULT="0" AUTO_UPDATE="2" /passive /norestart /S
)

rem startup Zalo to disable
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v Zalo /t REG_BINARY /d 03000000 /f
timeout /t 1
powershell.exe -ExecutionPolicy Bypass -File "%~dp0Script\wallpaper.ps1"
rem powershell -Command "$imgPath='C:\Windows\Soft\Script\a.png'; $code='using System.Runtime.InteropServices; namespace Win32 { public class Wallpaper { [DllImport(\"user32.dll\", CharSet = CharSet.Auto)] static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); public static void SetWallpaper(string thePath) { SystemParametersInfo(20, 0, thePath, 3); } } }'; Add-Type -TypeDefinition $code; $RegPath='HKCU:\Control Panel\Desktop'; Set-ItemProperty -Path $RegPath -Name WallpaperStyle -Value 2; Set-ItemProperty -Path $RegPath -Name TileWallpaper -Value 0; [Win32.Wallpaper]::SetWallpaper($imgPath)"
rem disable system protection
timeout /t 1

manage-bde -off c:
manage-bde -off d:
manage-bde -off e:
manage-bde -off f:

rem taskkill /im cmd.exe /f

exit

