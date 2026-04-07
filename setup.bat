@echo off
setlocal enabledelayedexpansion
REM Check if the script is running with administrator privileges
title Quick Win Setup
net session >nul 2>&1
if !errorLevel! == 0 (
    echo Running with administrator privileges.
) else (
    echo This script must be run as an administrator. Please right-click and select "Run as administrator."
    pause
    exit /b
)
cls
color 02
echo ----------------------------------------------------------------------------------------------------
echo Welcome to Quick Win Setup! This script will help you set up your new Windows installation with ease.
echo -----------------------------------------------------------------------------------------------------
echo For this the skript MUST be run as administrator and you need to have an active internet connection. The skript will install winget if you don't have it, then it will update winget and other stuff, after that you can choose if you want to debloat windows or not, then you can choose which browser you want to install, after that you can choose if you want a preconfig or not, if you choose to have a preconfig you can choose between gaming, work, school and business, if you choose to not have a preconfig you can select the software you want to install manually.
echo For this we WILL make a restore point, but we HIGHLY recommend you to make a backup of your important files before running this skript, just in case something goes wrong.
echo shoutout to @raphi_re for the windows 11 debloat skript(https://github.com/raphire/win11debloat) @Sycnex for the windows 10 Debloat skript (https://github.com/sycnex/windows10debloater) and to @microsoft for winget
echo all other stuff is owned by the respective owners and is used in this skript with their permission.
echo and this skript was made by me
timeout /t 60 /nobreak
cls
title Quick Win Setup - Creating restore point
echo Creating a restore point...
powershell -Command "Checkpoint-Computer -Description 'Quick Win Setup Restore Point' -RestorePointType 'Modify_Settings'"
echo Restore point created successfully.
timeout /t 5 /nobreak >nul
cls
title Quick Win Setup - Checking for winget
REM Check if the system already rebooted
del %AppData%\Microsoft\Windows\Start Menu\Programs\Startup\Setup.bat
if !errorLevel! == 0 (
REM Yes it has
goto Setup
) else (
   REM no it hasn't or a error ocurred
   goto install_winget
)
:install_winget
 where winget >nul 2>&1
 if !errorLevel! == 0(
    echo winget is already installed on this system.
    pause
    timeout /t 5 /nobreak >nul
    goto Setup
 
 ) else (
    title Quick Win Setup - Installing winget
    echo winget is not installed. Installing winget...
    mkdir "C:\Program Files\winget\install" 2>nul
    powershell -Command "Invoke-WebRequest 'https://github.com/microsoft/winget-cli/releases/download/v1.28.190/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -OutFile 'C:\Program Files\winget\install\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'; Add-AppxPackage -Path 'C:\Program Files\winget\install\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'"
   xcopy  "%~dp0setup.bat" %AppData%\Microsoft\Windows\Start Menu\Programs\Startup\Setup.bat /y
   echo winget has been installed and the skript needs to restart the computer to apply the changes.
   shutdown /r /t 60 /c "Restarting to complete winget installation...Please save all things in 60 seconds."
   )
:Setup
REM First we will update winget and other stuff
title Quick Win Setup - Updating system
echo updating
cmd /c winget upgrade --all --accept-source-agreements --accept-package-agreements -h
cmd /c winget install curl wget
echo Done!
:ESU-hack
:ltsc_convert
title Quick Win Setup - LTSC Conversion
echo do you want to convert your Windows to IoT LTSC 2021? (only windows 10) (support till' 2032)
echo you need this. a iso: https://buzzheavier.com/yhggy3l1e5oq
set /p ltsc="Type yes or no: "
if /i "%ltsc%"=="yes" (
    echo Wo liegt deine IoT LTSC 2021 ISO?
    set /p iso_path="Pfad zur ISO (z.B. C:\Users\User\Downloads\iot.iso): "
    
    REM Registry ändern
    title Quick Win Setup - Changing EditionID
    echo Ändere EditionID...
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID /t REG_SZ /d "IoTEnterpriseS" /f
    
    REM ISO mounten
    echo Mounte ISO...
    powershell -Command "Mount-DiskImage -ImagePath '!iso_path!'"
    
    REM Laufwerksbuchstaben der ISO finden
    for /f %%i in ('powershell -Command "(Get-DiskImage -ImagePath '!iso_path!' | Get-Volume).DriveLetter"') do set drive=%%i
    
    REM Setup starten
    echo Starte Upgrade...
    start "" "!drive!:\setup.exe"
) else (
    goto debloat
)
:debloat
echo "Do you want to debloat Windows?"
set /p debloat="Type yes or no: "
if /i "%debloat%"=="yes" (
    REM Check Windows version
    title Quick Win Setup - Debloating Windows
    for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
    if "!VERSION!"=="10.0" (
        echo Debloating Windows 10...
        powershell -Command "iwr -useb https://git.io/debloat | iex"
    ) else (
        echo Debloating Windows 11...
        powershell -Command "& ([scriptblock]::Create((irm 'https://win11debloat.raphi.re')))"
    )
) else if /i "%debloat%"=="no" (
    echo Skipping debloat.
) else (
    echo Invalid choice.
    goto debloat
)
:Browser_select
 title Quick Win Setup - Browser selection
 echo which browser do you want to install?
 echo "1. None (Microsoft edge)"
 echo "2. Opera GX"
 echo "3. Brave"
 echo "4. FireFox"
 echo "5. Chrome"
 set /p browserselect="Type the number corispnding to your browser or select 1. to download a browser manully"
 if "%browserselect%"=="1" (
    echo "You have chosen to not install a browser."
 ) else if "%browserselect%"=="2" (
    echo "You have chosen to install Opera GX."
    title Quick Win Setup - Installing Opera GX
    winget install Opera.OperaGX
 ) else if "%browserselect%"=="3" (
    echo "You have chosen to install Brave."
        title Quick Win Setup - Installing Brave
    winget install BraveSoftware.BraveBrowser
 ) else if "%browserselect%"=="4" (
    title Quick Win Setup - Installing FireFox
    echo "You have chosen to install FireFox."
    winget install Mozilla.Firefox
 ) else if "%browserselect%"=="5" (
    title Quick Win Setup - Installing Chrome
    echo "You have chosen to install Chrome."
    winget install Google.Chrome
 ) else (
    echo "Invalid choice. Please select a valid option."
    goto Browser_select
 )
:preconfig

    title Quick Win Setup - Preconfig selection
    echo "do you want a preconfig"
    set /p preconfig="Type yes or no: "
    if /i "%preconfig%"=="yes" (
        echo "which preconfig do you want?"
        echo "1. Gaming"
        echo "2. Work"
        echo "3. School"
        echo "4. Business"
        set /p preconfig_choice="Type the number of the preconfig you want: "
        if "%preconfig_choice%"=="1" (
            echo "You have chosen the Gaming preconfig."
            REM Install gaming related software using winget
            winget install Valve.Steam Spotify.Spotify EpicGames.EpicGamesLauncher discord.discord
            goto browser_select
        ) else if "%preconfig_choice%"=="2" (
            echo "You have chosen the Work preconfig."
            REM Install work related software using winget
            winget install Microsoft.VisualStudioCode Microsoft.Office Microsoft.Teams
            goto browser_select
        ) else if "%preconfig_choice%"=="3" (
            echo "You have chosen the School preconfig."
            REM Install school related software using winget
            winget install Microsoft.VisualStudioCode Microsoft.Office Microsoft.Teams Zoom.Zoom 
            goto browser_select
        ) else if "%preconfig_choice%"=="4" (
            echo "You have chosen the Business preconfig."
            REM Install business related software using winget
            winget install Microsoft.VisualStudioCode Microsoft.Office Microsoft.Teams SlackTechnologies.Slack
            goto browser_select
        ) else (
            echo "Invalid choice. Please select a valid option."
            goto preconfig
        )
    ) else if /i "%preconfig%"=="no" (
        title Quick Win Setup - Manual software selection
        echo "You have chosen to not install a preconfig.please select the software you want to install manually."
        echo "1. Slack"
        echo "2. Zoom"
        echo "3. Microsoft Teams"
        echo "4. Microsoft Office"
        echo "5. Visual Studio Code"
        echo "6. Spotify"
        echo "7. Steam"
        echo "8. Epic Games Launcher"
        echo "9. Discord"
        echo "10. Powershell 6"
        echo "12. Git"
        set /p software_choice="Type the number of the software you want to install: "
        if "%software_choice%"=="1" (
            echo "You have chosen to install Slack."
            winget install SlackTechnologies.Slack
            goto browser_select
        ) else if "%software_choice%"=="2" (
            echo "You have chosen to install Zoom."
            winget install Zoom.Zoom
            goto browser_select
        ) else if "%software_choice%"=="3" (
            echo "You have chosen to install Microsoft Teams."
            winget install Microsoft.Teams
            goto browser_select
        ) else if "%software_choice%"=="4" (
            echo "You have chosen to install Microsoft Office."
            winget install Microsoft.Office
            goto browser_select
        ) else if "%software_choice%"=="5" (
            echo "You have chosen to install Visual Studio Code."
            winget install Microsoft.VisualStudioCode
            goto browser_select
        ) else if "%software_choice%"=="6" (
            echo "You have chosen to install Spotify."
            winget install Spotify.Spotify
            goto browser_select
        ) else if "%software_choice%"=="7" (
            echo "You have chosen to install Steam."
            winget install Valve.Steam
            goto browser_select
        ) else if "%software_choice%"=="8" (
            echo "You have chosen to install Epic Games Launcher."
            winget install EpicGames.EpicGamesLauncher
            goto browser_select
        ) else if "%software_choice%"=="9" (
            echo "You have chosen to install Discord."
            winget install discord.discord
            goto browser_select
        ) else if "%software_choice%"=="10" (
            echo "You have chosen to not install any software."
            echo "Please select a browser to install or not install."
            goto browser_select
    ) else (
        echo "Invalid choice. Please select a valid option."
        goto preconfig
        )
    )

        