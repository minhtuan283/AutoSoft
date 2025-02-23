@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || ( echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

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

    :: Xóa Auto-MT.bat và Auto-MT2.bat cũ
    echo Xoa Auto-MT.bat va Auto-MT2.bat cu tai !filePath!...
    del /f /q "!filePath!Auto-MT.bat"
    del /f /q "!filePath!Auto-MT2.bat"

    :: Tải về file Auto-MT.bat và Auto-MT2.bat mới
    echo Dang tai file Auto-MT.bat va Auto-MT2.bat...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/minhtuan283/AutoSoft/raw/main/Auto-MT.bat' -OutFile '%temp%\Auto-MT.bat'"
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/minhtuan283/AutoSoft/raw/main/Auto-MT2.bat' -OutFile '%temp%\Auto-MT2.bat'"

    :: Sao chép Auto-MT.bat và Auto-MT2.bat mới vào filePath
    echo Sao chep Auto-MT.bat va Auto-MT2.bat vao: !filePath!
    copy /y "%temp%\Auto-MT.bat" "!filePath!Auto-MT.bat"
    copy /y "%temp%\Auto-MT2.bat" "!filePath!Auto-MT2.bat"

    :: Tải về file Script.zip và sao chép vào đường dẫn filePath
    echo Dang tai file Script.zip...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/minhtuan283/AutoSoft/releases/download/Script/Script.zip' -OutFile '%temp%\Script.zip'"

    :: Xóa file Script.zip cũ nếu có tại !filePath!
    echo Xoa file Script.zip cu tai !filePath!...
    del /f /q "!filePath!Script.zip"

    :: Sao chép Script.zip vào !filePath!
    echo Sao chep Script.zip vao: !filePath!
    copy /y "%temp%\Script.zip" "!filePath!Script.zip"

    :: Tìm file Run.bat và lưu thư mục chứa file vào biến filePath2
    for %%D in (A B D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
        if exist %%D:\ (
            for /f "delims=" %%b in ('dir /b /s "%%D:\Run.bat" 2^>nul') do (
                set "filePath2=%%~dpb"
                goto runbat_found
            )
        )
    )

    :runbat_found
    :: Xóa file Run.bat cũ tại !filePath2!
    echo Xoa Run.bat cu tai !filePath2!...
    del /f /q "!filePath2!Run.bat"

    :: Tải về file 1-ChiaODia.bat và 2-KoChiaODia.bat vào %temp%
    echo Dang tai file 1-ChiaODia.bat va 2-KoChiaODia.bat...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/minhtuan283/AutoSoft/raw/main/1-ChiaODia.bat' -OutFile '%temp%\1-ChiaODia.bat'"
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/minhtuan283/AutoSoft/raw/main/2-KoChiaODia.bat' -OutFile '%temp%\2-KoChiaODia.bat'"

    :: Sao chép 1-ChiaODia.bat và 2-KoChiaODia.bat vào !filePath2!
    echo Sao chep 1-ChiaODia.bat va 2-KoChiaODia.bat vao: !filePath2!
    copy /y "%temp%\1-ChiaODia.bat" "!filePath2!1-ChiaODia.bat"
    copy /y "%temp%\2-KoChiaODia.bat" "!filePath2!2-KoChiaODia.bat"

    :: Hiển thị thông báo
    echo Da tai va sao chep Auto-MT.bat, Auto-MT2.bat, Script.zip vao: !filePath!
    echo Da tai va sao chep 1-ChiaODia.bat, 2-KoChiaODia.bat vao: !filePath2!
)

:: Xóa các file tạm và biến tạm
del "%temp%\versiontemp.txt"
del "%temp%\Script.zip"
del "%temp%\Auto-MT.bat"
del "%temp%\Auto-MT2.bat"
del "%temp%\1-ChiaODia.bat"
del "%temp%\2-KoChiaODia.bat"
echo Da xoa file tam versiontemp.txt, Script.zip, Auto-MT.bat, Auto-MT2.bat, 1-ChiaODia.bat, 2-KoChiaODia.bat.
endlocal
:end
exit
