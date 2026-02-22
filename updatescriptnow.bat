@echo off
setlocal EnableDelayedExpansion

:: --- DOAN CODE CHONG TREO KHI CLICK CHUOT (DISABLE QUICKEDIT) ---
powershell -InputFormat None -OutputFormat None -NonInteractive -Command "$w=Add-Type -MemberDefinition '[DllImport(\"kernel32.dll\")]public static extern bool GetConsoleMode(IntPtr h,out uint m);[DllImport(\"kernel32.dll\")]public static extern bool SetConsoleMode(IntPtr h,uint m);[DllImport(\"kernel32.dll\")]public static extern IntPtr GetStdHandle(int h);' -Name 'Win32' -PassThru;$h=$w::GetStdHandle(-10);$m=0;$w::GetConsoleMode($h,[ref]$m);$w::SetConsoleMode($h,$m -band 0xFFBF)"
:: ----------------------------------------------------------------

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

:: ======================================================
:: updatescriptnow.bat - Auto Update AutoSoft tu GitHub
:: Kiem tra phien ban va cap nhat cac file moi nhat
:: ======================================================

set "SOFT_DIR=C:\Windows\Soft"
set "LOCAL_VER_FILE=%SOFT_DIR%\ver.txt"
set "TEMP_VER=%TEMP%\autosoft_remote_ver.txt"

set "GITHUB_RAW=https://raw.githubusercontent.com/minhtuan283/AutoSoft/main"
set "GITHUB_RELEASE=https://github.com/minhtuan283/AutoSoft/releases/download/Script"

:: --- Doc version local ---
set "LOCAL_VER=0"
if exist "%LOCAL_VER_FILE%" (
    set /p LOCAL_VER=<"%LOCAL_VER_FILE%"
)
:: Loai bo khoang trang
for /f "tokens=* delims= " %%a in ("!LOCAL_VER!") do set "LOCAL_VER=%%a"

echo [*] Phien ban hien tai (local): !LOCAL_VER!

:: --- Tai version tu GitHub ---
echo [*] Dang kiem tra phien ban moi tren GitHub...
powershell -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%GITHUB_RAW%/ver.txt', '%TEMP_VER%') } catch { exit 1 }"

if %ERRORLEVEL% NEQ 0 (
    echo [!] Khong the ket noi den GitHub. Bo qua update.
    goto :END
)

if not exist "%TEMP_VER%" (
    echo [!] Khong tai duoc file ver.txt tu GitHub. Bo qua update.
    goto :END
)

:: --- Doc version remote ---
set "REMOTE_VER=0"
set /p REMOTE_VER=<"%TEMP_VER%"
for /f "tokens=* delims= " %%a in ("!REMOTE_VER!") do set "REMOTE_VER=%%a"
del "%TEMP_VER%" 2>nul

echo [*] Phien ban moi nhat (GitHub): !REMOTE_VER!

:: --- So sanh version ---
if !REMOTE_VER! LEQ !LOCAL_VER! (
    echo [OK] Ban da dung phien ban moi nhat. Khong can update.
    goto :END
)

echo.
echo ================================================================
echo   PHAT HIEN PHIEN BAN MOI: v!REMOTE_VER! ^(hien tai: v!LOCAL_VER!^)
echo   Dang cap nhat...
echo ================================================================
echo.

:: --- Tai cac file moi tu GitHub ---
echo [1/4] Dang tai Auto-MT.bat...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%GITHUB_RAW%/Auto-MT.bat', '%SOFT_DIR%\Auto-MT.bat')"
if %ERRORLEVEL% EQU 0 (
    echo       [✓] Auto-MT.bat da cap nhat
) else (
    echo       [X] Loi khi tai Auto-MT.bat
)

echo [2/4] Dang tai Auto-MT2.bat...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%GITHUB_RAW%/Auto-MT2.bat', '%SOFT_DIR%\Auto-MT2.bat')"
if %ERRORLEVEL% EQU 0 (
    echo       [✓] Auto-MT2.bat da cap nhat
) else (
    echo       [X] Loi khi tai Auto-MT2.bat
)

echo [3/4] Dang tai ver.txt...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%GITHUB_RAW%/ver.txt', '%SOFT_DIR%\ver.txt')"
if %ERRORLEVEL% EQU 0 (
    echo       [✓] ver.txt da cap nhat
) else (
    echo       [X] Loi khi tai ver.txt
)

echo [4/4] Dang tai Script.zip (co the mat vai giay)...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%GITHUB_RELEASE%/Script.zip', '%SOFT_DIR%\Script.zip')"
if %ERRORLEVEL% EQU 0 (
    echo       [✓] Script.zip da cap nhat
) else (
    echo       [X] Loi khi tai Script.zip
)

echo.
echo ================================================================
echo   DA CAP NHAT THANH CONG: v!LOCAL_VER! -^> v!REMOTE_VER!
echo ================================================================
echo.

:END
endlocal
exit /b 0
