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
set "SOURCE_DOWNLOAD_URL=https://softupdate.tangtuanlab.io.vn/App_2.zip?v=999"
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

echo Dang tai file cap nhat...

set "OC_SOURCE_ZIP_URL=!SOURCE_ZIP_URL!"

set "OC_TEMP_ZIP=%TEMP_ZIP%"

set "OC_DOWNLOAD_PS1=%TEMP_DIR%\download_source.ps1"

powershell -NoProfile -ExecutionPolicy Bypass -Command "[IO.File]::WriteAllText($env:OC_DOWNLOAD_PS1,[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('JEVycm9yQWN0aW9uUHJlZmVyZW5jZSA9ICdTdG9wJwpbTmV0LlNlcnZpY2VQb2ludE1hbmFnZXJdOjpTZWN1cml0eVByb3RvY29sID0gW05ldC5TZWN1cml0eVByb3RvY29sVHlwZV06OlRsczEyCltOZXQuU2VydmljZVBvaW50TWFuYWdlcl06OlNlcnZlckNlcnRpZmljYXRlVmFsaWRhdGlvbkNhbGxiYWNrID0geyAkdHJ1ZSB9CltOZXQuU2VydmljZVBvaW50TWFuYWdlcl06OkV4cGVjdDEwMENvbnRpbnVlID0gJGZhbHNlCiR1cmwgPSAkZW52Ok9DX1NPVVJDRV9aSVBfVVJMCiRvdXQgPSAkZW52Ok9DX1RFTVBfWklQCmlmIChbc3RyaW5nXTo6SXNOdWxsT3JXaGl0ZVNwYWNlKCR1cmwpKSB7IHRocm93ICdPQ19TT1VSQ0VfWklQX1VSTCBpcyBlbXB0eScgfQppZiAoW3N0cmluZ106OklzTnVsbE9yV2hpdGVTcGFjZSgkb3V0KSkgeyB0aHJvdyAnT0NfVEVNUF9aSVAgaXMgZW1wdHknIH0KJHVhID0gJ01vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS8xMjAuMC4wLjAgU2FmYXJpLzUzNy4zNicKJHNlc3MgPSBOZXctT2JqZWN0IE1pY3Jvc29mdC5Qb3dlclNoZWxsLkNvbW1hbmRzLldlYlJlcXVlc3RTZXNzaW9uCmZ1bmN0aW9uIFRlc3QtWmlwKFtzdHJpbmddJHApIHsKICAgIGlmICgtbm90IChUZXN0LVBhdGggLUxpdGVyYWxQYXRoICRwKSkgeyByZXR1cm4gJGZhbHNlIH0KICAgICRmID0gR2V0LUl0ZW0gLUxpdGVyYWxQYXRoICRwCiAgICBpZiAoJGYuTGVuZ3RoIC1sZSAwKSB7IHJldHVybiAkZmFsc2UgfQogICAgJGZzID0gW0lPLkZpbGVdOjpPcGVuUmVhZCgkcCkKICAgIHRyeSB7ICRiMSA9ICRmcy5SZWFkQnl0ZSgpOyAkYjIgPSAkZnMuUmVhZEJ5dGUoKTsgcmV0dXJuICgkYjEgLWVxIDB4NTAgLWFuZCAkYjIgLWVxIDB4NEIpIH0KICAgIGZpbmFsbHkgeyAkZnMuQ2xvc2UoKSB9Cn0KZnVuY3Rpb24gRG93bmxvYWQtV2l0aEN1cmwoW3N0cmluZ10kZG93bmxvYWRVcmwsIFtzdHJpbmddJHRhcmdldCkgewogICAgJGN1cmwgPSAoR2V0LUNvbW1hbmQgY3VybC5leGUgLUVycm9yQWN0aW9uIFNpbGVudGx5Q29udGludWUpCiAgICBpZiAoLW5vdCAkY3VybCkgeyB0aHJvdyAnY3VybC5leGUgbm90IGZvdW5kIGZvciBmYWxsYmFjayBkb3dubG9hZCcgfQogICAgV3JpdGUtSG9zdCAnSW52b2tlLVdlYlJlcXVlc3QgbG9pIGhvYWMga2hvbmcgcmEgWklQLiBUaHUgdGFpIGJhbmcgY3VybC5leGUuLi4nCiAgICAkYXJncyA9IEAoJy1MJywnLWsnLCctLWZhaWwnLCctLXJldHJ5JywnMycsJy0tY29ubmVjdC10aW1lb3V0JywnMzAnLCctLW1heC10aW1lJywnMTgwMCcsJy1BJywkdWEsJy1vJywkdGFyZ2V0LCRkb3dubG9hZFVybCkKICAgICYgJGN1cmwuU291cmNlIEBhcmdzCiAgICBpZiAoJExBU1RFWElUQ09ERSAtbmUgMCkgeyB0aHJvdyAoJ2N1cmwuZXhlIGRvd25sb2FkIGZhaWxlZC4gRXhpdENvZGU9JyArICRMQVNURVhJVENPREUpIH0KfQp0cnkgewogICAgSW52b2tlLVdlYlJlcXVlc3QgLVVyaSAkdXJsIC1XZWJTZXNzaW9uICRzZXNzIC1PdXRGaWxlICRvdXQgLVVzZUJhc2ljUGFyc2luZyAtVGltZW91dFNlYyAxODAwIC1Vc2VyQWdlbnQgJHVhIC1IZWFkZXJzIEB7ICdBY2NlcHQnPSdhcHBsaWNhdGlvbi96aXAsYXBwbGljYXRpb24vb2N0ZXQtc3RyZWFtLCovKicgfQp9IGNhdGNoIHsKICAgIFdyaXRlLUhvc3QgKCdJbnZva2UtV2ViUmVxdWVzdCBsb2k6ICcgKyAkXy5FeGNlcHRpb24uTWVzc2FnZSkKICAgIERvd25sb2FkLVdpdGhDdXJsICR1cmwgJG91dAp9CmlmICgtbm90IChUZXN0LVppcCAkb3V0KSkgewogICAgJGh0bWwgPSBbU3lzdGVtLklPLkZpbGVdOjpSZWFkQWxsVGV4dCgkb3V0KQogICAgaWYgKCRodG1sIC1tYXRjaCAnY29uZmlybT0oW2EtekEtWjAtOV8tXSspJykgewogICAgICAgIFdyaXRlLUhvc3QgJ1BoYXQgaGllbiBjYW5oIGJhbyBHb29nbGUgRHJpdmUuIERhbmcgdHJpY2ggeHVhdCB0b2tlbiBieXBhc3MuLi4nCiAgICAgICAgJHRva2VuID0gJE1hdGNoZXNbMV0KICAgICAgICAkbmV3VXJsID0gJHVybCArICcmY29uZmlybT0nICsgW3VyaV06OkVzY2FwZURhdGFTdHJpbmcoJHRva2VuKQogICAgICAgIHRyeSB7IEludm9rZS1XZWJSZXF1ZXN0IC1VcmkgJG5ld1VybCAtV2ViU2Vzc2lvbiAkc2VzcyAtT3V0RmlsZSAkb3V0IC1Vc2VCYXNpY1BhcnNpbmcgLVRpbWVvdXRTZWMgMTgwMCAtVXNlckFnZW50ICR1YSB9IGNhdGNoIHsgRG93bmxvYWQtV2l0aEN1cmwgJG5ld1VybCAkb3V0IH0KICAgIH0gZWxzZWlmICgkaHRtbCAtbWF0Y2ggJ25hbWU9ImNvbmZpcm0iIHZhbHVlPSIoW14iXSspIicpIHsKICAgICAgICBXcml0ZS1Ib3N0ICdQaGF0IGhpZW4gY2FuaCBiYW8gR29vZ2xlIERyaXZlLiBEYW5nIHRyaWNoIHh1YXQgdG9rZW4gYnlwYXNzLi4uJwogICAgICAgICR0b2tlbiA9ICRNYXRjaGVzWzFdCiAgICAgICAgJHV1aWQgPSAnJwogICAgICAgIGlmICgkaHRtbCAtbWF0Y2ggJ25hbWU9InV1aWQiIHZhbHVlPSIoW14iXSspIicpIHsgJHV1aWQgPSAkTWF0Y2hlc1sxXSB9CiAgICAgICAgJG5ld1VybCA9ICR1cmwgKyAnJmNvbmZpcm09JyArIFt1cmldOjpFc2NhcGVEYXRhU3RyaW5nKCR0b2tlbikKICAgICAgICBpZiAoJHV1aWQpIHsgJG5ld1VybCA9ICRuZXdVcmwgKyAnJnV1aWQ9JyArIFt1cmldOjpFc2NhcGVEYXRhU3RyaW5nKCR1dWlkKSB9CiAgICAgICAgdHJ5IHsgSW52b2tlLVdlYlJlcXVlc3QgLVVyaSAkbmV3VXJsIC1XZWJTZXNzaW9uICRzZXNzIC1PdXRGaWxlICRvdXQgLVVzZUJhc2ljUGFyc2luZyAtVGltZW91dFNlYyAxODAwIC1Vc2VyQWdlbnQgJHVhIH0gY2F0Y2ggeyBEb3dubG9hZC1XaXRoQ3VybCAkbmV3VXJsICRvdXQgfQogICAgfQp9CmlmICgtbm90IChUZXN0LVppcCAkb3V0KSkgeyB0aHJvdyAnRmlsZSB0YWkgdmUgbGEgSFRNTCBob2FjIGtob25nIHBoYWkgWklQIChQSykuIE5BUy9TZXJ2ZXIgY28gdGhlIGRhbmcgY2hhbiB0cnV5IGNhcCB0cnVjIHRpZXAsIGxpbmsgc2hhcmUgY28gbWF0IGtoYXUsIGhvYWMgY2h1YSBwdWJsaWMuJyB9')))"

if errorlevel 1 exit /b 1

powershell -NoProfile -ExecutionPolicy Bypass -File "%OC_DOWNLOAD_PS1%"

if errorlevel 1 exit /b 1

if not exist "%TEMP_ZIP%" exit /b 1

set "OC_SOURCE_ZIP_URL="

set "OC_TEMP_ZIP="

set "OC_DOWNLOAD_PS1="

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
