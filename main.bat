@echo off
title Admin Prompt
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo This Batch File Is Not Running At Correct Previllages.
    echo.
    echo Please Click [YES] To Continue Or [NO] To Exit.
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
    goto Start
:Start
title 7-Zip Installer
::==============================================INIT=============================================================
echo %PROCESSOR_ARCHITECTURE% | find /i "x86" > nul&if %errorlevel%==0 (set arch=32) else (set arch=64)
mkdir Packages
aria2c https://github.com/bfffggh/Packages/blob/main/package-7zip-console-32bit.zip >nul
aria2c https://github.com/bfffggh/Packages/blob/main/package-7zip-console-64bit.zip >nul
aria2c https://github.com/bfffggh/Packages/blob/main/package-7zip-main-32bit.zip >nul
aria2c https://github.com/bfffggh/Packages/blob/main/package-7zip-main-64bit.zip >nul
move *.zip .\packages\
cls
::===========================================INTERFACE===========================================================
echo [_ 7-Zip Installer _]
echo.
echo [1] Install 7-Zip
echo.
echo [2] Install 7-Zip Console Only
echo.
set /p inst="Install: "
if %inst% == 1 (goto normal)
if %inst% == 2 (goto minimal)
rd /s /q Packages
exit

:normal
if not exist C:\Programs\ (mkdir C:\Programs\)
7za.exe x .\Packages\package-7zip-console-%arch%bit.zip -oC:\Programs\7-Zip\ >NUL
7za.exe x .\Packages\package-7zip-main-%arch%bit.zip -oC:\Programs\7-Zip\ >NUL
rd /s /q Packages
cd /d %userprofile%\desktop
mklink 7-Zip "C:\Programs\7-Zip\7zFM.exe"
exit

:minimal
if not exist C:\Programs\ (mkdir C:\Programs\)
7za.exe x .\Packages\package-7zip-console-%arch%bit.zip -oC:\Programs\7-Zip\ >NUL
rd /s /q Packages
exit


