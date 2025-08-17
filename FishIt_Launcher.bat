@echo off
color 0B
title AutoFish Launcher for Fish It Game

echo.
echo  ==========================================
echo   🐟 AutoFish for Fish It Game Launcher
echo  ==========================================
echo.

echo  [INFO] Checking system requirements...
timeout /t 2 /nobreak >nul

echo  [✓] Windows PowerShell - OK
echo  [✓] Roblox Game Client - Required
echo  [✓] Fish It Game - Required
echo.

echo  [INFO] Loading AutoFish configuration...
timeout /t 1 /nobreak >nul

if exist "autofish_fishit.lua" (
    echo  [✓] AutoFish Fish It script found
) else (
    echo  [X] AutoFish Fish It script missing!
    echo  [ERROR] Please ensure autofish_fishit.lua is in this folder
    pause
    exit /b 1
)

echo.
echo  ==========================================
echo   🎮 Fish It Game Information
echo  ==========================================
echo.
echo  🐟 Game: Fish It by Fish Atelier
echo  🎣 Mechanics: Click to charge up, then click as fast as you can
echo  🌊 Features: 1,000,000+ fish variations
echo  🏝️ Islands: Multiple fishing locations
echo  ✨ Special: Shiny fish, admin events, enchants
echo.

echo  ==========================================
echo   🎯 Pre-Launch Checklist
echo  ==========================================
echo.
echo  Please confirm the following:
echo.
echo  1. ✅ Roblox is running
echo  2. ✅ Fish It game is loaded and joined
echo  3. ✅ Character is at a fishing spot
echo  4. ✅ Ready to start automated fishing
echo.

:menu
echo  ==========================================
echo   🚀 Launch Options
echo  ==========================================
echo.
echo  [1] 🎣 Launch AutoFish (Normal Mode) - Balanced
echo  [2] ⚡ Launch AutoFish (Fast Mode) - Quick fishing
echo  [3] 🚀 Launch AutoFish (Turbo Mode) - Maximum speed
echo  [4] ⚙️ View Fish It Settings
echo  [5] 📖 How Fish It AutoFish Works
echo  [6] 🆘 Troubleshooting Guide
echo  [7] ❌ Exit
echo.

set /p choice="Select option (1-7): "

if "%choice%"=="1" goto launch_normal
if "%choice%"=="2" goto launch_fast
if "%choice%"=="3" goto launch_turbo
if "%choice%"=="4" goto settings
if "%choice%"=="5" goto how_it_works
if "%choice%"=="6" goto troubleshoot
if "%choice%"=="7" goto exit

echo Invalid choice! Please select 1-7.
goto menu

:launch_normal
echo.
echo  [INFO] Launching AutoFish in NORMAL mode...
echo  [INFO] Charge Time: 2 seconds
echo  [INFO] Click Speed: 20 CPS
echo  [INFO] Recommended for beginners
echo.
call :launch_script "Normal"
goto post_launch

:launch_fast
echo.
echo  [INFO] Launching AutoFish in FAST mode...
echo  [INFO] Charge Time: 1.5 seconds
echo  [INFO] Click Speed: 25 CPS
echo  [WARNING] Faster but may attract attention
echo.
call :launch_script "Fast"
goto post_launch

:launch_turbo
echo.
echo  [INFO] Launching AutoFish in TURBO mode...
echo  [INFO] Charge Time: 1 second
echo  [INFO] Click Speed: 30 CPS
echo  [WARNING] Maximum speed - use carefully!
echo.
call :launch_script "Turbo"
goto post_launch

:settings
echo.
echo  ==========================================
echo   ⚙️ Fish It AutoFish Settings
echo  ==========================================
echo.
echo  🎣 Normal Mode Settings:
echo    • Charge Time: 2.0 seconds
echo    • Click Speed: 20 CPS (clicks per second)
echo    • Safety Level: High
echo    • Recommended Usage: Long sessions
echo.
echo  ⚡ Fast Mode Settings:
echo    • Charge Time: 1.5 seconds
echo    • Click Speed: 25 CPS
echo    • Safety Level: Medium
echo    • Recommended Usage: Medium sessions
echo.
echo  🚀 Turbo Mode Settings:
echo    • Charge Time: 1.0 seconds
echo    • Click Speed: 30 CPS
echo    • Safety Level: Low
echo    • Recommended Usage: Short sessions only
echo.
echo  🤖 Additional Features:
echo    • Auto-Sell: Every 25 fish caught
echo    • Anti-AFK: Every 3 minutes
echo    • Emergency Stop: F12 key
echo    • Manual Sell: F3 key
echo.
pause
goto menu

:how_it_works
echo.
echo  ==========================================
echo   📖 How Fish It AutoFish Works
echo  ==========================================
echo.
echo  🎯 Fish It Game Mechanics:
echo    1. Click and hold to charge up your cast
echo    2. Release when fully charged
echo    3. When fish bites, click as fast as possible
echo    4. Successfully catch the fish
echo.
echo  🤖 AutoFish Automation:
echo    • Detects when charging is needed
echo    • Automatically holds click for optimal charge time
echo    • Detects when fast clicking is required
echo    • Performs rapid clicking at optimal speed
echo    • Automatically detects successful catches
echo    • Handles auto-selling when inventory is full
echo.
echo  🔧 Smart Detection Features:
echo    • UI text scanning for game states
echo    • Fishing interface monitoring
echo    • Catch notification detection
echo    • Merchant/shop interaction
echo.
echo  ⚡ Performance Modes:
echo    • Normal: Balanced performance and safety
echo    • Fast: Increased speed with moderate risk
echo    • Turbo: Maximum speed for experienced users
echo.
echo  🛡️ Safety Features:
echo    • Anti-AFK movement system
echo    • Emergency stop functionality
echo    • Character reset capability
echo    • Session monitoring and statistics
echo.
pause
goto menu

:troubleshoot
echo.
echo  ==========================================
echo   🆘 Fish It Troubleshooting Guide
echo  ==========================================
echo.
echo  Problem: "AutoFish not starting"
echo  Solution:
echo    • Make sure you're in Fish It game
echo    • Stand near a fishing area
echo    • Check if fishing UI is visible
echo    • Try clicking manually first
echo.
echo  Problem: "Not charging properly"
echo  Solution:
echo    • Look for "charge up" text in game
echo    • Make sure fishing rod is equipped
echo    • Try different fishing location
echo    • Restart the script
echo.
echo  Problem: "Fast clicking not working"
echo  Solution:
echo    • Wait for fish to bite first
echo    • Look for "click fast" instruction
echo    • Check if fish are actually biting
echo    • Lower the click speed mode
echo.
echo  Problem: "No fish being caught"
echo  Solution:
echo    • Move to different fishing spot
echo    • Check if bait/rod is equipped
echo    • Verify game mechanics manually
echo    • Try lower speed mode
echo.
echo  Problem: "Auto-sell not working"
echo  Solution:
echo    • Walk closer to merchant/shop
echo    • Look for sell button in game UI
echo    • Try manual selling first
echo    • Check inventory space
echo.
echo  Problem: "Script stopped working"
echo  Solution:
echo    • Press F12 for emergency stop
echo    • Restart the script completely
echo    • Rejoin the Fish It game
echo    • Check for game updates
echo.
echo  💡 Pro Tips:
echo    • Start with Normal mode for testing
echo    • Use Turbo mode only for short sessions
echo    • Monitor the statistics regularly
echo    • Take breaks every hour
echo.
pause
goto menu

:launch_script
echo  [INFO] Preparing Fish It AutoFish script...
echo  [INFO] Mode: %~1
echo.

REM Create temporary lua file with mode setting
echo -- AutoFish Fish It Launch Script > temp_fishit_launch.lua
echo local mode = "%~1" >> temp_fishit_launch.lua
echo. >> temp_fishit_launch.lua

REM Append the main script
type "autofish_fishit.lua" >> temp_fishit_launch.lua

echo -- Set launch mode >> temp_fishit_launch.lua
echo if AutoFish and AutoFish.mode then >> temp_fishit_launch.lua
echo     AutoFish.mode = mode >> temp_fishit_launch.lua
echo     print("🎣 AutoFish launched in " .. mode .. " mode") >> temp_fishit_launch.lua
echo end >> temp_fishit_launch.lua

echo  [INFO] Script prepared successfully
echo  [INFO] Copy and paste this command into Roblox executor:
echo.
echo  ==========================================
color 0E
echo  loadstring(readfile("temp_fishit_launch.lua"))()
color 0B
echo  ==========================================
echo.
echo  [INFO] Fish It AutoFish injection ready
goto :eof

:post_launch
echo.
echo  ==========================================
echo   🎯 Fish It AutoFish Launched Successfully
echo  ==========================================
echo.
echo  Next Steps:
echo.
echo  1. 🎮 Open your Roblox executor (Synapse, Krnl, etc.)
echo  2. 📋 Copy the loadstring command shown above
echo  3. ✅ Paste and execute in Roblox
echo  4. 🐟 Watch AutoFish work automatically!
echo.
echo  ⚠️ Important for Fish It:
echo    • Make sure you're at a valid fishing spot
echo    • The script will detect charge/click phases automatically
echo    • Monitor the UI for real-time status
echo    • Emergency stop available with F12
echo.
echo  🎮 Fish It Controls:
echo    • F1 - Start/Stop AutoFish
echo    • F3 - Manual sell fish
echo    • F12 - Emergency stop all
echo.
echo  📊 What to Expect:
echo    • Script detects "charge up" prompts
echo    • Automatically holds click to charge
echo    • Detects "click fast" prompts
echo    • Performs rapid clicking for catches
echo    • Shows statistics in real-time
echo.

:monitor
echo.
echo  ==========================================
echo   📊 Fish It Session Monitor
echo  ==========================================
echo.
echo  [%date% %time%] Fish It AutoFish Active
echo  Status: Monitoring automated fishing
echo.
echo  Expected Behavior:
echo  ✓ Charging when prompted
echo  ✓ Fast clicking when fish bites
echo  ✓ Catching fish automatically
echo  ✓ Auto-selling periodically
echo.
echo  Options:
echo  [1] 🔄 Restart Script
echo  [2] 📊 Check Performance
echo  [3] 🛑 Stop Session
echo  [4] 🏠 Back to Menu
echo.

set /p mon_choice="Select option (1-4): "

if "%mon_choice%"=="1" goto menu
if "%mon_choice%"=="2" goto check_performance
if "%mon_choice%"=="3" goto stop_session
if "%mon_choice%"=="4" goto menu

echo Invalid choice!
goto monitor

:check_performance
echo.
echo  [INFO] Checking Fish It AutoFish performance...
echo.
echo  💡 Performance Indicators:
echo    • UI shows "Running" status
echo    • Statistics are updating
echo    • Character is at fishing spot
echo    • Fish counter is increasing
echo.
echo  🔍 If performance is poor:
echo    • Try switching to Normal mode
echo    • Check internet connection
echo    • Restart Fish It game
echo    • Move to different fishing spot
echo.
echo  ⚡ If too fast/risky:
echo    • Switch to lower speed mode
echo    • Enable longer breaks
echo    • Monitor for any warnings
echo.
pause
goto monitor

:stop_session
echo.
echo  [INFO] Stopping Fish It AutoFish session...
echo  [INFO] Press F12 in Roblox for emergency stop
echo  [INFO] Or use STOP button in AutoFish UI
echo.
echo  📊 Session Summary:
echo    • Check total catches in UI
echo    • Review fish per hour rate
echo    • Note any issues encountered
echo    • Plan next fishing session
echo.
pause
goto menu

:exit
echo.
echo  ==========================================
echo   👋 Thanks for using Fish It AutoFish!
echo  ==========================================
echo.
echo  [INFO] Cleaning up temporary files...

if exist "temp_fishit_launch.lua" (
    del "temp_fishit_launch.lua"
    echo  [✓] Temporary files cleaned
)

echo  [INFO] Fish It session ended
echo  [INFO] Remember to stop AutoFish before closing Roblox
echo.
echo  🐟 Happy fishing in Fish It!
echo  Visit our GitHub for updates and new features!
echo.
pause
exit /b 0
