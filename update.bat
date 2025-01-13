@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

setlocal enabledelayedexpansion

:: Tìm file ver.txt
for %%D in (A B D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%D:\ (
        echo Dang tim trong %%D:\
        for /f "delims=" %%F in ('dir /s /b %%D:\ver.txt 2^>nul') do (
            set "filePath=%%~dpF"
            echo File o "!filePath!"
            goto found
        )
    )
)

echo Khong tim thay ver.txt trong cac o da chi dinh.
goto end

:found
:: Tải về file versiontemp.txt
echo Dang tai file versiontemp.txt...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/minhtuan283/AutoSoft/raw/main/ver.txt' -OutFile '%temp%\versiontemp.txt'"

:: Đọc nội dung của 2 file ver.txt và versiontemp.txt
set /p versionFile=<"!filePath!ver.txt"
set /p versionTemp=<"%temp%\versiontemp.txt"

:: Hiển thị giá trị ver.txt và versiontemp.txt
echo ver.txt: !versionFile!
echo versiontemp.txt: !versionTemp!

:: So sánh ver.txt và versiontemp.txt
if !versionTemp! leq !versionFile! (
    echo Soft da la phien ban moi nhat.
) else (
    echo Da co phien ban moi.
    
    :: Xóa file ver.txt cũ và chép đè versiontemp.txt
    echo Xoa file ver.txt cu va chep de versiontemp.txt vao: !filePath!
    del /f /q "!filePath!ver.txt"
    copy /y "%temp%\versiontemp.txt" "!filePath!ver.txt"

    :: Tải về file Auto-MT.bat và sao chép vào đường dẫn filePath
    echo Dang tai file Auto-MT.bat...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/minhtuan283/AutoSoft/raw/main/Auto-MT.bat' -OutFile '!filePath!Auto-MT.bat'"

    :: Tải về và chép đè Script.zip vào thư mục !filePath!
    echo Dang tai file Script.zip...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/minhtuan283/AutoSoft/releases/download/Script/Script.zip' -OutFile '%temp%\Script.zip'"

    :: Xóa file Script.zip cũ nếu có tại !filePath!
    echo Xoa file Script.zip cu tai !filePath!...
    del /f /q "!filePath!Script.zip"

    :: Sao chép Script.zip vào !filePath!
    echo Sao chep Script.zip vao: !filePath!
    copy /y "%temp%\Script.zip" "!filePath!Script.zip"

    :: Hiển thị thông báo
    echo Da tai va sao chep Auto-MT.bat vao: !filePath!
    echo Da tai va sao chep Script.zip vao: !filePath!
)

:: Xóa các file tạm và biến tạm
del "%temp%\versiontemp.txt"
del "%temp%\Script.zip"
echo Da xoa file tam versiontemp.txt va Script.zip.
endlocal
:end
exit
