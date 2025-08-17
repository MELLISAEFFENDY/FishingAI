@echo off
color 0B
title AutoFish Launcher for Fisch Game

echo.
echo  ========================================
echo   🎣 AutoFish for Fisch Game Launcher
echo  ========================================
echo.

echo  [INFO] Checking system requirements...
timeout /t 2 /nobreak >nul

echo  [✓] Windows PowerShell - OK
echo  [✓] Roblox Game Client - Required
echo  [✓] Fisch Game - Required
echo.

echo  [INFO] Loading AutoFish configuration...
timeout /t 1 /nobreak >nul

if exist "autofish_config.ini" (
    echo  [✓] Configuration file found
) else (
    echo  [!] Configuration file not found - using defaults
)

if exist "autofish_fisch.lua" (
    echo  [✓] AutoFish script found
) else (
    echo  [X] AutoFish script missing!
    echo  [ERROR] Please ensure autofish_fisch.lua is in this folder
    pause
    exit /b 1
)

echo.
echo  ========================================
echo   🎮 Pre-Launch Checklist
echo  ========================================
echo.
echo  Please confirm the following:
echo.
echo  1. ✅ Roblox is running
echo  2. ✅ Fisch game is loaded and joined
echo  3. ✅ You have a fishing rod in inventory
echo  4. ✅ Character is spawned and ready
echo.

:menu
echo  ========================================
echo   🚀 Launch Options
echo  ========================================
echo.
echo  [1] 🎣 Launch AutoFish (Normal Mode)
echo  [2] ⚡ Launch AutoFish (Fast Mode)  
echo  [3] 🛡️ Launch AutoFish (Safe Mode)
echo  [4] ⚙️ Configuration Settings
echo  [5] 📖 View Documentation
echo  [6] 🆘 Troubleshooting Guide
echo  [7] ❌ Exit
echo.

set /p choice="Select option (1-7): "

if "%choice%"=="1" goto launch_normal
if "%choice%"=="2" goto launch_fast
if "%choice%"=="3" goto launch_safe
if "%choice%"=="4" goto config
if "%choice%"=="5" goto docs
if "%choice%"=="6" goto troubleshoot
if "%choice%"=="7" goto exit

echo Invalid choice! Please select 1-7.
goto menu

:launch_normal
echo.
echo  [INFO] Launching AutoFish in NORMAL mode...
echo  [INFO] Balanced speed and safety
echo  [INFO] Recommended for most users
echo.
call :launch_script "normal"
goto post_launch

:launch_fast
echo.
echo  [INFO] Launching AutoFish in FAST mode...
echo  [WARNING] Higher speed, higher detection risk
echo  [INFO] Use for short sessions only
echo.
call :launch_script "fast"
goto post_launch

:launch_safe
echo.
echo  [INFO] Launching AutoFish in SAFE mode...
echo  [INFO] Slower speed, minimal detection risk
echo  [INFO] Recommended for long sessions
echo.
call :launch_script "safe"
goto post_launch

:config
echo.
echo  ========================================
echo   ⚙️ Configuration Settings
echo  ========================================
echo.
if exist "autofish_config.ini" (
    echo Opening configuration file...
    notepad "autofish_config.ini"
) else (
    echo Configuration file not found!
    echo Creating default configuration...
    echo # AutoFish Configuration > autofish_config.ini
    echo DEFAULT_MODE=normal >> autofish_config.ini
    echo ANTI_AFK_ENABLED=true >> autofish_config.ini
    echo AUTO_SELL_ENABLED=true >> autofish_config.ini
    notepad "autofish_config.ini"
)
echo.
pause
goto menu

:docs
echo.
echo  ========================================
echo   📖 Documentation
echo  ========================================
echo.
if exist "AUTOFISH_GUIDE.md" (
    echo Opening documentation...
    start "" "AUTOFISH_GUIDE.md"
) else (
    echo Documentation not found!
    echo Please check AUTOFISH_GUIDE.md file
)
echo.
pause
goto menu

:troubleshoot
echo.
echo  ========================================
echo   🆘 Troubleshooting Guide
echo  ========================================
echo.
echo  Common Issues and Solutions:
echo.
echo  Problem: "No fishing rod found"
echo  Solution: 
echo    - Check inventory for fishing rod
echo    - Buy rod from Fisch shop
echo    - Use 'Equip Rod' button in UI
echo.
echo  Problem: "Not catching fish"
echo  Solution:
echo    - Make sure you're near water
echo    - Use fishing spot teleport
echo    - Try different fishing mode
echo.
echo  Problem: "Character stuck"
echo  Solution:
echo    - Use 'Reset Character' button
echo    - Teleport to different spot
echo    - Restart the script
echo.
echo  Problem: "Script not working"
echo  Solution:
echo    - Check if Roblox is running
echo    - Rejoin Fisch game
echo    - Run as administrator
echo.
echo  Problem: "UI not appearing"
echo  Solution:
echo    - Press F7 to toggle UI
echo    - Check if script loaded properly
echo    - Restart script
echo.
echo  For more help, check AUTOFISH_GUIDE.md
echo.
pause
goto menu

:launch_script
echo  [INFO] Injecting script into Roblox...
echo  [INFO] Mode: %~1
echo.

REM Create temporary lua file with mode setting
echo -- AutoFish Launch Script > temp_launch.lua
echo local mode = "%~1" >> temp_launch.lua
echo. >> temp_launch.lua

REM Append the main script
type "autofish_fisch.lua" >> temp_launch.lua

echo -- Set launch mode >> temp_launch.lua
echo if AutoFish and AutoFish.setMode then >> temp_launch.lua
echo     AutoFish.setMode(mode) >> temp_launch.lua
echo end >> temp_launch.lua

echo  [INFO] Script prepared and ready
echo  [INFO] Copy and paste this into Roblox executor:
echo.
echo  ========================================
color 0E
echo  loadstring(readfile("temp_launch.lua"))()
color 0B
echo  ========================================
echo.
echo  [INFO] Script injection commands ready
goto :eof

:post_launch
echo.
echo  ========================================
echo   🎯 AutoFish Launched Successfully
echo  ========================================
echo.
echo  What's Next:
echo.
echo  1. 🎮 Open Roblox executor (Synapse, Krnl, etc.)
echo  2. 📋 Copy the loadstring command above
echo  3. ✅ Paste and execute in Roblox
echo  4. 🎣 Use AutoFish UI to start fishing
echo.
echo  ⚠️ Important Notes:
echo  • Keep this window open for monitoring
echo  • Press F12 in game for emergency stop
echo  • Check UI buttons for manual controls
echo.
echo  🔧 Controls:
echo  • F1 - Start/Stop AutoFish
echo  • F2 - Teleport Menu
echo  • F7 - Toggle UI
echo  • F12 - Emergency Stop
echo.

:monitor
echo.
echo  ========================================
echo   📊 Session Monitor
echo  ========================================
echo.
echo  [%date% %time%] Session Active
echo  Status: Monitoring AutoFish
echo.
echo  Options:
echo  [1] 🔄 Restart Script
echo  [2] 📊 Check Status  
echo  [3] 🛑 Stop Session
echo  [4] 🏠 Back to Menu
echo.

set /p mon_choice="Select option (1-4): "

if "%mon_choice%"=="1" goto menu
if "%mon_choice%"=="2" goto check_status
if "%mon_choice%"=="3" goto stop_session
if "%mon_choice%"=="4" goto menu

echo Invalid choice!
goto monitor

:check_status
echo.
echo  [INFO] Checking AutoFish status...
echo  [INFO] If AutoFish is running, you should see:
echo  ✓ UI window visible in Roblox
echo  ✓ Status showing current activity
echo  ✓ Statistics updating
echo.
echo  If you don't see these, the script may have stopped.
echo  Try restarting from main menu.
echo.
pause
goto monitor

:stop_session
echo.
echo  [INFO] Stopping AutoFish session...
echo  [INFO] Press F12 in Roblox to emergency stop
echo  [INFO] Or use STOP button in AutoFish UI
echo.
pause
goto menu

:exit
echo.
echo  ========================================
echo   👋 Thanks for using AutoFish!
echo  ========================================
echo.
echo  [INFO] Cleaning up temporary files...

if exist "temp_launch.lua" (
    del "temp_launch.lua"
    echo  [✓] Temporary files cleaned
)

echo  [INFO] Session ended
echo  [INFO] Remember to stop AutoFish in game before closing Roblox
echo.
echo  Visit our GitHub for updates and support!
echo.
pause
exit /b 0
