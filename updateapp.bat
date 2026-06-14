@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem ============================================================
rem  updateapp.bat
rem  Muc dich: Kiem tra va update App_xxx.zip cho local + USB.
rem  SOURCE_DOWNLOAD_URL phai la link tai truc tiep toi App_xxx.zip / App.zip
rem  Quy uoc version:
rem    - App.zip = version 1
rem    - App_1.zip = version 1
rem    - App_2.zip, App_3.zip... = version tuong ung
rem ============================================================

set "SOURCE_FILE_NAME=App_2.zip"
set "SOURCE_DOWNLOAD_URL=https://nas264.tangtuanlab.io.vn/fsdownload/BWXoaBsbU/App_2.zip"
set "SOFT_DIR=C:\Windows\Soft"
set "APP_PREFIX=App"
set "TEMP_DIR=%TEMP%\updateapp_%RANDOM%%RANDOM%"
set "TEMP_INFO=%TEMP_DIR%\source_info.txt"
set "TEMP_ZIP=%TEMP_DIR%\download_app.zip"
set "LOCAL_VER=0"
set "SOURCE_VER=0"
set "SOURCE_FILE="
set "SOURCE_ZIP_URL="
set "USB_DIR="
set "FAIL_MSG=Update ko thanh cong, vui long kiem tra lai internet va mo khoa write usb neu co."

if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%" >nul 2>nul
if errorlevel 1 goto update_failed

call :GetHighestAppVersion "%SOFT_DIR%" LOCAL_VER LOCAL_FILE
call :GetSourceInfo
if errorlevel 1 goto update_failed

echo.
echo Local version tai "%SOFT_DIR%": !LOCAL_VER!
echo Source version: !SOURCE_VER! ^(!SOURCE_FILE!^)
echo.

if !LOCAL_VER! GEQ !SOURCE_VER! (
    echo Local App version bang hoac moi hon source. Bo qua update.
    call :Cleanup
    call :PauseBeforeExit
    exit /b 0
)

echo Can update App tu version !LOCAL_VER! len !SOURCE_VER!.
echo.

call :FindUsbWithRetry
if errorlevel 1 (
    call :Cleanup
    call :PauseBeforeExit
    exit /b 1
)

echo.
echo ============================================================
echo  DANG UPDATE APP. VUI LONG KHONG RUT USB TRONG QUA TRINH UPDATE.
echo ============================================================
echo USB folder: "!USB_DIR!"
echo.

call :DownloadSource
if errorlevel 1 goto update_failed

if not exist "%SOFT_DIR%" mkdir "%SOFT_DIR%" >nul 2>nul
if errorlevel 1 goto update_failed

set "NEW_LOCAL=%SOFT_DIR%\!SOURCE_FILE!"
set "NEW_USB=!USB_DIR!!SOURCE_FILE!"

echo Dang copy file moi vao local...
copy /Y "%TEMP_ZIP%" "!NEW_LOCAL!" >nul
if errorlevel 1 goto update_failed
if not exist "!NEW_LOCAL!" goto update_failed

echo Dang copy file moi vao USB...
copy /Y "%TEMP_ZIP%" "!NEW_USB!" >nul
if errorlevel 1 goto update_failed
if not exist "!NEW_USB!" goto update_failed

call :DeleteOldAppZips "%SOFT_DIR%" "!SOURCE_FILE!"
call :DeleteOldAppZips "!USB_DIR!" "!SOURCE_FILE!"

echo.
echo Update App thanh cong: !SOURCE_FILE!
call :Cleanup
call :PauseBeforeExit
exit /b 0

:update_failed
echo.
echo %FAIL_MSG%
call :Cleanup
call :PauseBeforeExit
exit /b 1

rem ============================================================
rem Functions
rem ============================================================

:GetSourceInfo
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "$sourceName='%SOURCE_FILE_NAME%';" ^
  "$downloadUrl='%SOURCE_DOWNLOAD_URL%';" ^
  "function Get-Ver([string]$n){ if($n -match '(?i)^App(?:_(\d+))?\.zip$'){ if($Matches[1]){[int]$Matches[1]}else{1} }else{0} };" ^
  "if([string]::IsNullOrWhiteSpace($sourceName)){ throw 'SOURCE_FILE_NAME dang trong' };" ^
  "if([string]::IsNullOrWhiteSpace($downloadUrl)){ throw 'SOURCE_DOWNLOAD_URL dang trong' };" ^
  "$ver=Get-Ver $sourceName;" ^
  "if($ver -le 0){ throw 'SOURCE_FILE_NAME khong dung format App.zip hoac App_xxx.zip' };" ^
  "Set-Content -LiteralPath '%TEMP_INFO%' -Encoding ASCII -Value @($ver,$sourceName,$downloadUrl);"
if errorlevel 1 exit /b 1

set /a LINE_NO=0
for /f "usebackq delims=" %%L in ("%TEMP_INFO%") do (
    set /a LINE_NO+=1
    if !LINE_NO! EQU 1 set "SOURCE_VER=%%L"
    if !LINE_NO! EQU 2 set "SOURCE_FILE=%%L"
    if !LINE_NO! EQU 3 set "SOURCE_ZIP_URL=%%L"
)
if not defined SOURCE_VER exit /b 1
if not defined SOURCE_FILE exit /b 1
if not defined SOURCE_ZIP_URL exit /b 1
exit /b 0

:DownloadSource
echo Dang tai: !SOURCE_ZIP_URL!
set "OC_SOURCE_ZIP_URL=!SOURCE_ZIP_URL!"
set "OC_TEMP_ZIP=%TEMP_ZIP%"
powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand JABFAHIAcgBvAHIAQQBjAHQAaQBvAG4AUAByAGUAZgBlAHIAZQBuAGMAZQAgAD0AIAAnAFMAdABvAHAAJwAKAFsATgBlAHQALgBTAGUAcgB2AGkAYwBlAFAAbwBpAG4AdABNAGEAbgBhAGcAZQByAF0AOgA6AFMAZQBjAHUAcgBpAHQAeQBQAHIAbwB0AG8AYwBvAGwAIAA9ACAAWwBOAGUAdAAuAFMAZQBjAHUAcgBpAHQAeQBQAHIAbwB0AG8AYwBvAGwAVAB5AHAAZQBdADoAOgBUAGwAcwAxADIACgBbAE4AZQB0AC4AUwBlAHIAdgBpAGMAZQBQAG8AaQBuAHQATQBhAG4AYQBnAGUAcgBdADoAOgBTAGUAcgB2AGUAcgBDAGUAcgB0AGkAZgBpAGMAYQB0AGUAVgBhAGwAaQBkAGEAdABpAG8AbgBDAGEAbABsAGIAYQBjAGsAIAA9ACAAewAgACQAdAByAHUAZQAgAH0ACgAkAHUAcgBsACAAPQAgACQAZQBuAHYAOgBPAEMAXwBTAE8AVQBSAEMARQBfAFoASQBQAF8AVQBSAEwACgAkAG8AdQB0ACAAPQAgACQAZQBuAHYAOgBPAEMAXwBUAEUATQBQAF8AWgBJAFAACgBpAGYAIAAoAFsAcwB0AHIAaQBuAGcAXQA6ADoASQBzAE4AdQBsAGwATwByAFcAaABpAHQAZQBTAHAAYQBjAGUAKAAkAHUAcgBsACkAKQAgAHsAIAB0AGgAcgBvAHcAIAAnAE8AQwBfAFMATwBVAFIAQwBFAF8AWgBJAFAAXwBVAFIATAAgAGkAcwAgAGUAbQBwAHQAeQAnACAAfQAKAGkAZgAgACgAWwBzAHQAcgBpAG4AZwBdADoAOgBJAHMATgB1AGwAbABPAHIAVwBoAGkAdABlAFMAcABhAGMAZQAoACQAbwB1AHQAKQApACAAewAgAHQAaAByAG8AdwAgACcATwBDAF8AVABFAE0AUABfAFoASQBQACAAaQBzACAAZQBtAHAAdAB5ACcAIAB9AAoAJAB1AGEAIAA9ACAAJwBNAG8AegBpAGwAbABhAC8ANQAuADAAIAAoAFcAaQBuAGQAbwB3AHMAIABOAFQAIAAxADAALgAwADsAIABXAGkAbgA2ADQAOwAgAHgANgA0ACkAIABBAHAAcABsAGUAVwBlAGIASwBpAHQALwA1ADMANwAuADMANgAgACgASwBIAFQATQBMACwAIABsAGkAawBlACAARwBlAGMAawBvACkAIABDAGgAcgBvAG0AZQAvADEAMgAwAC4AMAAuADAALgAwACAAUwBhAGYAYQByAGkALwA1ADMANwAuADMANgAnAAoAJABzAGUAcwBzACAAPQAgAE4AZQB3AC0ATwBiAGoAZQBjAHQAIABNAGkAYwByAG8AcwBvAGYAdAAuAFAAbwB3AGUAcgBTAGgAZQBsAGwALgBDAG8AbQBtAGEAbgBkAHMALgBXAGUAYgBSAGUAcQB1AGUAcwB0AFMAZQBzAHMAaQBvAG4ACgBmAHUAbgBjAHQAaQBvAG4AIABUAGUAcwB0AC0AWgBpAHAAKABbAHMAdAByAGkAbgBnAF0AJABwACkAIAB7AAoAIAAgACAAIABpAGYAIAAoAC0AbgBvAHQAIAAoAFQAZQBzAHQALQBQAGEAdABoACAALQBMAGkAdABlAHIAYQBsAFAAYQB0AGgAIAAkAHAAKQApACAAewAgAHIAZQB0AHUAcgBuACAAJABmAGEAbABzAGUAIAB9AAoAIAAgACAAIAAkAGYAIAA9ACAARwBlAHQALQBJAHQAZQBtACAALQBMAGkAdABlAHIAYQBsAFAAYQB0AGgAIAAkAHAACgAgACAAIAAgAGkAZgAgACgAJABmAC4ATABlAG4AZwB0AGgAIAAtAGwAZQAgADAAKQAgAHsAIAByAGUAdAB1AHIAbgAgACQAZgBhAGwAcwBlACAAfQAKACAAIAAgACAAJABmAHMAIAA9ACAAWwBJAE8ALgBGAGkAbABlAF0AOgA6AE8AcABlAG4AUgBlAGEAZAAoACQAcAApAAoAIAAgACAAIAB0AHIAeQAgAHsACgAgACAAIAAgACAAIAAgACAAJABiADEAIAA9ACAAJABmAHMALgBSAGUAYQBkAEIAeQB0AGUAKAApAAoAIAAgACAAIAAgACAAIAAgACQAYgAyACAAPQAgACQAZgBzAC4AUgBlAGEAZABCAHkAdABlACgAKQAKACAAIAAgACAAIAAgACAAIAByAGUAdAB1AHIAbgAgACgAJABiADEAIAAtAGUAcQAgADAAeAA1ADAAIAAtAGEAbgBkACAAJABiADIAIAAtAGUAcQAgADAAeAA0AEIAKQAKACAAIAAgACAAfQAgAGYAaQBuAGEAbABsAHkAIAB7AAoAIAAgACAAIAAgACAAIAAgACQAZgBzAC4AQwBsAG8AcwBlACgAKQAKACAAIAAgACAAfQAKAH0ACgBJAG4AdgBvAGsAZQAtAFcAZQBiAFIAZQBxAHUAZQBzAHQAIAAtAFUAcgBpACAAJAB1AHIAbAAgAC0AVwBlAGIAUwBlAHMAcwBpAG8AbgAgACQAcwBlAHMAcwAgAC0ATwB1AHQARgBpAGwAZQAgACQAbwB1AHQAIAAtAFUAcwBlAEIAYQBzAGkAYwBQAGEAcgBzAGkAbgBnACAALQBUAGkAbQBlAG8AdQB0AFMAZQBjACAAMQA4ADAAMAAgAC0AVQBzAGUAcgBBAGcAZQBuAHQAIAAkAHUAYQAKAGkAZgAgACgALQBuAG8AdAAgACgAVABlAHMAdAAtAFoAaQBwACAAJABvAHUAdAApACkAIAB7AAoAIAAgACAAIAAkAGgAdABtAGwAIAA9ACAAWwBTAHkAcwB0AGUAbQAuAEkATwAuAEYAaQBsAGUAXQA6ADoAUgBlAGEAZABBAGwAbABUAGUAeAB0ACgAJABvAHUAdAApAAoAIAAgACAAIABpAGYAIAAoACQAaAB0AG0AbAAgAC0AbQBhAHQAYwBoACAAJwBjAG8AbgBmAGkAcgBtAD0AKABbAGEALQB6AEEALQBaADAALQA5AF8ALQBdACsAKQAnACkAIAB7AAoAIAAgACAAIAAgACAAIAAgAFcAcgBpAHQAZQAtAEgAbwBzAHQAIAAnAFAAaABhAHQAIABoAGkAZQBuACAAYwBhAG4AaAAgAGIAYQBvACAARwBvAG8AZwBsAGUAIABEAHIAaQB2AGUALgAgAEQAYQBuAGcAIAB0AHIAaQBjAGgAIAB4AHUAYQB0ACAAdABvAGsAZQBuACAAYgB5AHAAYQBzAHMALgAuAC4AJwAKACAAIAAgACAAIAAgACAAIAAkAHQAbwBrAGUAbgAgAD0AIAAkAE0AYQB0AGMAaABlAHMAWwAxAF0ACgAgACAAIAAgACAAIAAgACAAJABuAGUAdwBVAHIAbAAgAD0AIAAkAHUAcgBsACAAKwAgACcAJgBjAG8AbgBmAGkAcgBtAD0AJwAgACsAIABbAHUAcgBpAF0AOgA6AEUAcwBjAGEAcABlAEQAYQB0AGEAUwB0AHIAaQBuAGcAKAAkAHQAbwBrAGUAbgApAAoAIAAgACAAIAAgACAAIAAgAEkAbgB2AG8AawBlAC0AVwBlAGIAUgBlAHEAdQBlAHMAdAAgAC0AVQByAGkAIAAkAG4AZQB3AFUAcgBsACAALQBXAGUAYgBTAGUAcwBzAGkAbwBuACAAJABzAGUAcwBzACAALQBPAHUAdABGAGkAbABlACAAJABvAHUAdAAgAC0AVQBzAGUAQgBhAHMAaQBjAFAAYQByAHMAaQBuAGcAIAAtAFQAaQBtAGUAbwB1AHQAUwBlAGMAIAAxADgAMAAwACAALQBVAHMAZQByAEEAZwBlAG4AdAAgACQAdQBhAAoAIAAgACAAIAB9ACAAZQBsAHMAZQBpAGYAIAAoACQAaAB0AG0AbAAgAC0AbQBhAHQAYwBoACAAJwBuAGEAbQBlAD0AIgBjAG8AbgBmAGkAcgBtACIAIAB2AGEAbAB1AGUAPQAiACgAWwBeACIAXQArACkAIgAnACkAIAB7AAoAIAAgACAAIAAgACAAIAAgAFcAcgBpAHQAZQAtAEgAbwBzAHQAIAAnAFAAaABhAHQAIABoAGkAZQBuACAAYwBhAG4AaAAgAGIAYQBvACAARwBvAG8AZwBsAGUAIABEAHIAaQB2AGUALgAgAEQAYQBuAGcAIAB0AHIAaQBjAGgAIAB4AHUAYQB0ACAAdABvAGsAZQBuACAAYgB5AHAAYQBzAHMALgAuAC4AJwAKACAAIAAgACAAIAAgACAAIAAkAHQAbwBrAGUAbgAgAD0AIAAkAE0AYQB0AGMAaABlAHMAWwAxAF0ACgAgACAAIAAgACAAIAAgACAAJAB1AHUAaQBkACAAPQAgACcAJwAKACAAIAAgACAAIAAgACAAIABpAGYAIAAoACQAaAB0AG0AbAAgAC0AbQBhAHQAYwBoACAAJwBuAGEAbQBlAD0AIgB1AHUAaQBkACIAIAB2AGEAbAB1AGUAPQAiACgAWwBeACIAXQArACkAIgAnACkAIAB7ACAAJAB1AHUAaQBkACAAPQAgACQATQBhAHQAYwBoAGUAcwBbADEAXQAgAH0ACgAgACAAIAAgACAAIAAgACAAJABuAGUAdwBVAHIAbAAgAD0AIAAkAHUAcgBsACAAKwAgACcAJgBjAG8AbgBmAGkAcgBtAD0AJwAgACsAIABbAHUAcgBpAF0AOgA6AEUAcwBjAGEAcABlAEQAYQB0AGEAUwB0AHIAaQBuAGcAKAAkAHQAbwBrAGUAbgApAAoAIAAgACAAIAAgACAAIAAgAGkAZgAgACgAJAB1AHUAaQBkACkAIAB7ACAAJABuAGUAdwBVAHIAbAAgAD0AIAAkAG4AZQB3AFUAcgBsACAAKwAgACcAJgB1AHUAaQBkAD0AJwAgACsAIABbAHUAcgBpAF0AOgA6AEUAcwBjAGEAcABlAEQAYQB0AGEAUwB0AHIAaQBuAGcAKAAkAHUAdQBpAGQAKQAgAH0ACgAgACAAIAAgACAAIAAgACAASQBuAHYAbwBrAGUALQBXAGUAYgBSAGUAcQB1AGUAcwB0ACAALQBVAHIAaQAgACQAbgBlAHcAVQByAGwAIAAtAFcAZQBiAFMAZQBzAHMAaQBvAG4AIAAkAHMAZQBzAHMAIAAtAE8AdQB0AEYAaQBsAGUAIAAkAG8AdQB0ACAALQBVAHMAZQBCAGEAcwBpAGMAUABhAHIAcwBpAG4AZwAgAC0AVABpAG0AZQBvAHUAdABTAGUAYwAgADEAOAAwADAAIAAtAFUAcwBlAHIAQQBnAGUAbgB0ACAAJAB1AGEACgAgACAAIAAgAH0ACgB9AAoAaQBmACAAKAAtAG4AbwB0ACAAKABUAGUAcwB0AC0AWgBpAHAAIAAkAG8AdQB0ACkAKQAgAHsAIAB0AGgAcgBvAHcAIAAnAEYAaQBsAGUAIAB0AGEAaQAgAHYAZQAgAGwAYQAgAEgAVABNAEwAIABoAG8AYQBjACAAawBoAG8AbgBnACAAcABoAGEAaQAgAFoASQBQACAAKABQAEsAKQAuACAATgBBAFMALwBTAGUAcgB2AGUAcgAgAGMAbwAgAHQAaABlACAAZABhAG4AZwAgAGMAaABhAG4AIAB0AHIAdQB5ACAAYwBhAHAAIAB0AHIAdQBjACAAdABpAGUAcAAsACAAbABpAG4AawAgAHMAaABhAHIAZQAgAGMAbwAgAG0AYQB0ACAAawBoAGEAdQAsACAAaABvAGEAYwAgAGMAaAB1AGEAIABwAHUAYgBsAGkAYwAuACcAIAB9AA==
if errorlevel 1 exit /b 1
if not exist "%TEMP_ZIP%" exit /b 1
set "OC_SOURCE_ZIP_URL="
set "OC_TEMP_ZIP="
exit /b 0

:GetHighestAppVersion
set "SCAN_DIR=%~1"
set "OUT_VER=%~2"
set "OUT_FILE=%~3"
set "BEST_VER=0"
set "BEST_FILE="

if exist "%SCAN_DIR%" (
    for /f "delims=" %%F in ('dir /b /a-d "%SCAN_DIR%\App*.zip" 2^>nul') do (
        call :ParseAppVersion "%%~nxF" ONE_VER
        if !ONE_VER! GTR !BEST_VER! (
            set "BEST_VER=!ONE_VER!"
            set "BEST_FILE=%%~nxF"
        )
    )
)
set "%OUT_VER%=%BEST_VER%"
set "%OUT_FILE%=%BEST_FILE%"
exit /b 0

:ParseAppVersion
set "APP_NAME=%~1"
set "OUT_VAR=%~2"
set "PARSED_VER=0"

if /I "%APP_NAME%"=="App.zip" (
    set "PARSED_VER=1"
) else (
    for /f "tokens=2 delims=_" %%V in ("%~n1") do (
        set "NUM=%%V"
        set "NUM=!NUM: =!"
        set /a PARSED_VER=!NUM! 2>nul
    )
)
set "%OUT_VAR%=%PARSED_VER%"
exit /b 0

:FindUsbWithRetry
set /a TRY=1
:usb_retry
set "USB_DIR="
call :FindUsbOnce
if defined USB_DIR exit /b 0

echo.
echo Khong tim thay USB co chua ver.txt va Script.zip cung folder.
if !TRY! GEQ 3 (
    echo Da quet toi da 3 lan. Dung script update.
    exit /b 1
)
set /a TRY+=1
set /p "_=Cam USB vao roi bam Enter de quet lai..."
goto usb_retry

:FindUsbOnce
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        fsutil fsinfo drivetype %%d:\ 2>nul | find /i "Removable" >nul
        if not errorlevel 1 (
            echo USB o vi tri %%d:\
            for /f "delims=" %%a in ('dir /b /s "%%d:\ver.txt" 2^>nul') do (
                if exist "%%~dpaScript.zip" (
                    set "USB_DIR=%%~dpa"
                    echo Da tim thay ver.txt va Script.zip trong thu muc: !USB_DIR!
                    goto usb_found
                )
            )
        )
    )
)
:usb_found
exit /b 0

:DeleteOldAppZips
set "TARGET_DIR=%~1"
set "KEEP_FILE=%~2"
if not exist "%TARGET_DIR%" exit /b 0
for /f "delims=" %%F in ('dir /b /a-d "%TARGET_DIR%\App*.zip" 2^>nul') do (
    if /I not "%%~nxF"=="%KEEP_FILE%" (
        del /f /q "%TARGET_DIR%\%%~nxF" >nul 2>nul
    )
)
exit /b 0

:PauseBeforeExit
echo.
set /p "_=Bam Enter de thoat script update App..."
exit /b 0

:Cleanup
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%" >nul 2>nul
set "TEMP_INFO="
set "TEMP_ZIP="
set "SOURCE_VER="
set "SOURCE_FILE="
set "SOURCE_ZIP_URL="
set "LOCAL_VER="
set "LOCAL_FILE="
set "USB_DIR="
exit /b 0
