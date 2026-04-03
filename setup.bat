@echo off
setlocal enabledelayedexpansion
REM Check if the script is running with administrator privileges
net session >nul 2>&1
if !errorLevel! == 0 (
    echo Running with administrator privileges.
) else (
    echo This script must be run as an administrator. Please right-click and select "Run as administrator."
    pause
    exit /b
)
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
    echo winget is not installed. Installing winget...
    mkdir "C:\Program Files\winget\install" 2>nul
    powershell -Command "Invoke-WebRequest 'https://github.com/microsoft/winget-cli/releases/download/v1.28.190/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -OutFile 'C:\Program Files\winget\install\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'; Add-AppxPackage -Path 'C:\Program Files\winget\install\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'"
   xcopy  "%~dp0setup.bat" %AppData%\Microsoft\Windows\Start Menu\Programs\Startup\Setup.bat /y
   echo winget has been installed and the skript needs to restart the computer to apply the changes.
   shutdown /r /t 60 /c "Restarting to complete winget installation...Please save all things in 60 seconds."
   )
:Setup
REM First we will update winget and other stuff
echo updating
cmd /c winget upgrade --all --accept-source-agreements --accept-package-agreements -h
cmd /c winget install curl wget
echo Done!
:Browser_select
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
    winget install Opera.OperaGX
 ) else if "%browserselect%"=="3" (
    echo "You have chosen to install Brave."
    winget install BraveSoftware.BraveBrowser
 ) else if "%browserselect%"=="4" (
    echo "You have chosen to install FireFox."
    winget install Mozilla.Firefox
 ) else if "%browserselect%"=="5" (
    echo "You have chosen to install Chrome."
    winget install Google.Chrome
 ) else (
    echo "Invalid choice. Please select a valid option."
    goto Browser_select
 )
:preconfig
    echo "do you want a preconfig"
    set /p preconfig="Type yes or no: "
    if /i "%preconfig%"=="yes" (
        echo "whitch preconfig do you want?
        echo "1. Gaming"
        echo "2. Work"
        echo "3. School"
        echo "4. Business"
        set /p preconfig_choice="Type the number of the preconfig you want: "
        if "%preconfig_choice%"=="1" (
            echo "You have chosen the Gaming preconfig."
            REM Install gaming related software using winget
            winget install steam.steam Spotify.Spotify EpicGames.EpicGamesLauncher discord.discord
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
            goto preconfig_choice
        )
    ) else if /i "%preconfig%"=="no" (
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
        echo "10. None"
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
            winget install steam.steam
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

        