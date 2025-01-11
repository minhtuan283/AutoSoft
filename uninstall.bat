@echo off

rem DellOptimizer
rem for /r "C:\Program Files (x86)\InstallShield Installation Information" %%f in (DellOptimizer_MyDell.exe) do (
rem     if exist "%%f" (
rem         echo File found: %%f
rem         start "" "%%f" -modify -runfromtemp -remove
rem         goto :end1
rem     )
rem )
rem :end1

rem WebAdvisor
for /r "C:\Program Files\McAfee\WebAdvisor" %%f in (Uninstaller.exe) do (
    if exist "%%f" (
        echo File found: %%f
        start "" "C:\Program Files\McAfee\WebAdvisor\Uninstaller.exe" -s
        goto :end6
    )
)
:end6

rem start "" "C:\Program Files\McAfee\WebAdvisor\Uninstaller.exe" -s


exit
