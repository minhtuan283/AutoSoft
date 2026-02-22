@echo off
setlocal EnableDelayedExpansion

:: --- DOAN CODE CHONG TREO KHI CLICK CHUOT (DISABLE QUICKEDIT) ---
powershell -InputFormat None -OutputFormat None -NonInteractive -Command "$w=Add-Type -MemberDefinition '[DllImport(\"kernel32.dll\")]public static extern bool GetConsoleMode(IntPtr h,out uint m);[DllImport(\"kernel32.dll\")]public static extern bool SetConsoleMode(IntPtr h,uint m);[DllImport(\"kernel32.dll\")]public static extern IntPtr GetStdHandle(int h);' -Name 'Win32' -PassThru;$h=$w::GetStdHandle(-10);$m=0;$w::GetConsoleMode($h,[ref]$m);$w::SetConsoleMode($h,$m -band 0xFFBF)"
:: ----------------------------------------------------------------

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )



:: ======================================================
:: updatescriptnow.bat - Auto Update AutoSoft tu GitHub
:: Tai file vao TEMP truoc, kiem tra du moi chep de
:: ======================================================

set "SOFT_DIR=C:\Windows\Soft"
set "LOCAL_VER_FILE=%SOFT_DIR%\ver.txt"
set "TEMP_DL=%TEMP%\AutoSoft_Update"

set "GITHUB_RAW=https://raw.githubusercontent.com/minhtuan283/AutoSoft/main"
set "GITHUB_RELEASE=https://github.com/minhtuan283/AutoSoft/releases/download/Script"

:: --- Buoc 1: Doc version local ---
set "LOCAL_VER=0"
if exist "%LOCAL_VER_FILE%" (
    set /p LOCAL_VER=<"%LOCAL_VER_FILE%"
)
for /f "tokens=* delims= " %%a in ("!LOCAL_VER!") do set "LOCAL_VER=%%a"
echo [*] Phien ban hien tai (local): v!LOCAL_VER!

:: --- Buoc 2: Tao thu muc tam va tai ver.txt tu GitHub ---
echo [*] Dang kiem tra phien ban moi tren GitHub...
if exist "%TEMP_DL%" rmdir /s /q "%TEMP_DL%" 2>nul
mkdir "%TEMP_DL%" >nul 2>nul

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; try { (New-Object Net.WebClient).DownloadFile('%GITHUB_RAW%/ver.txt', '%TEMP_DL%\ver.txt') } catch { exit 1 }"
if %ERRORLEVEL% NEQ 0 (
    echo [!] Khong the tai ver.txt tu GitHub. Bo qua update.
    goto :CLEANUP
)

set "REMOTE_VER=0"
set /p REMOTE_VER=<"%TEMP_DL%\ver.txt"
for /f "tokens=* delims= " %%a in ("!REMOTE_VER!") do set "REMOTE_VER=%%a"
echo [*] Phien ban moi nhat (GitHub): v!REMOTE_VER!

:: --- Buoc 3: So sanh version ---
if !REMOTE_VER! LEQ !LOCAL_VER! (
    echo [OK] Ban da dung phien ban moi nhat. Khong can update.
    goto :CLEANUP
)

echo.
echo ================================================================
echo   PHAT HIEN PHIEN BAN MOI: v!REMOTE_VER! ^(hien tai: v!LOCAL_VER!^)
echo   Dang tai ve thu muc tam...
echo ================================================================
echo.

:: --- Buoc 4: Tai tat ca file vao TEMP truoc ---
set "DL_OK=1"

echo [1/4] Dang tai Auto-MT.bat...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%GITHUB_RAW%/Auto-MT.bat', '%TEMP_DL%\Auto-MT.bat')"
if not exist "%TEMP_DL%\Auto-MT.bat" (
    echo       [X] LOI: Khong tai duoc Auto-MT.bat
    set "DL_OK=0"
) else (
    echo       [OK] Auto-MT.bat
)

echo [2/4] Dang tai Auto-MT2.bat...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%GITHUB_RAW%/Auto-MT2.bat', '%TEMP_DL%\Auto-MT2.bat')"
if not exist "%TEMP_DL%\Auto-MT2.bat" (
    echo       [X] LOI: Khong tai duoc Auto-MT2.bat
    set "DL_OK=0"
) else (
    echo       [OK] Auto-MT2.bat
)

echo [3/4] ver.txt da tai san o buoc kiem tra.
echo       [OK] ver.txt

echo [4/4] Dang tai Script.zip (co the mat vai giay)...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%GITHUB_RELEASE%/Script.zip', '%TEMP_DL%\Script.zip')"
if not exist "%TEMP_DL%\Script.zip" (
    echo       [X] LOI: Khong tai duoc Script.zip
    set "DL_OK=0"
) else (
    echo       [OK] Script.zip
)

:: --- Buoc 5: Kiem tra tat ca file da tai day du ---
if !DL_OK! EQU 0 (
    echo.
    echo [!!!] MOT SO FILE TAI LOI. HUY UPDATE DE TRANH HONG DU LIEU.
    echo [!!!] Cac file cu van duoc giu nguyen.
    goto :CLEANUP
)

:: --- Buoc 6: Chep de vao vi tri chinh thuc ---
echo.
echo [*] Tat ca file da tai thanh cong. Dang chep vao %SOFT_DIR%...

copy /y "%TEMP_DL%\Auto-MT.bat" "%SOFT_DIR%\Auto-MT.bat" >nul
copy /y "%TEMP_DL%\Auto-MT2.bat" "%SOFT_DIR%\Auto-MT2.bat" >nul
copy /y "%TEMP_DL%\ver.txt" "%SOFT_DIR%\ver.txt" >nul
copy /y "%TEMP_DL%\Script.zip" "%SOFT_DIR%\Script.zip" >nul

echo.
echo ================================================================
echo   DA CAP NHAT THANH CONG: v!LOCAL_VER! -^> v!REMOTE_VER!
echo ================================================================
echo.

:CLEANUP
if exist "%TEMP_DL%" rmdir /s /q "%TEMP_DL%" 2>nul

:END
endlocal
exit /b 0
