@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
powershell -Command "Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\LanmanWorkstation\\Parameters' -Name 'RequireSecuritySignature' -Value 1"
powershell -Command "Set-SmbClientConfiguration -RequireSecuritySignature $false -Force"
powershell -Command "Set-SmbClientConfiguration -EnableInsecureGuestLogons $true -Force"


powershell -Command "$s=(Get-CimInstance Win32_BIOS).SerialNumber; $n=(Get-CimInstance Win32_ComputerSystem).Name; $m=(Get-CimInstance Win32_ComputerSystem).Model; $f=(Get-CimInstance Win32_ComputerSystem).Manufacturer; $d=$(Get-Date -Format 'yyyy-MM-dd'); $t=$(Get-Date -Format 'HH-mm'); $tf=\"$env:TEMP\tam.txt\"; \"$s`_$n`_$m`_$f`_$d`_$t\" | Out-File $tf; net use '\\ktv\ktv' /persistent:no; if ($?) { $tf2='\\ktv\ktv\serial\log\series_' + $d + '_' + $t + '.txt'; Copy-Item $tf $tf2; if (Test-Path '\\ktv\ktv\serial\seri.txt') { Add-Content '\\ktv\ktv\serial\seri.txt' (Get-Content $tf) } else { Copy-Item $tf '\\ktv\ktv\serial\seri.txt' }; Remove-Item $tf }"
netsh wlan disconnect interface="Wi-Fi"
rem netsh wlan delete profile name="phongvu.vn"
netsh wlan set profileparameter name="phongvu.vn" connectionmode=manual
netsh wlan set profileparameter name="KyThuatPhongVu_5G" connectionmode=manual
echo Hoàn tất.

exit