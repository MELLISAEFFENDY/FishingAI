@echo off
color 0D
title Remote Event/Function Tester - Fish It

echo.
echo  ==========================================
echo   🔧 REMOTE EVENT/FUNCTION TESTER
echo  ==========================================
echo.

echo  [INFO] Initializing Remote Tester for Fish It...
timeout /t 2 /nobreak >nul

if exist "remote_tester.lua" (
    echo  [✓] Remote Tester script found
) else (
    echo  [X] Remote Tester script missing!
    echo  [ERROR] Please ensure remote_tester.lua is in this folder
    pause
    exit /b 1
)

echo.
echo  ==========================================
echo   🚀 REMOTE TESTER FEATURES
echo  ==========================================
echo.
echo  🔍 Remote Scanner:
echo    • Scan all RemoteEvents and RemoteFunctions
echo    • Automatic detection from ReplicatedStorage
echo    • Categorized results (Events vs Functions)
echo    • Real-time scanning progress
echo.
echo  🚀 Remote Executor:
echo    • Execute any remote with custom arguments
echo    • Support for RemoteEvents and RemoteFunctions
echo    • Argument parsing (numbers, booleans, strings)
echo    • Error handling and success tracking
echo.
echo  ⚡ Quick Actions:
echo    • PlayFishingEffect - Start fishing
echo    • ChargeFishingRod - Charge fishing rod
echo    • SellAllItems - Sell all fish
echo    • CancelFishingInputs - Cancel fishing
echo.
echo  📋 History ^& Results:
echo    • Execution history with timestamps
echo    • Success/failure tracking
echo    • Return value display
echo    • Scrollable results window
echo.

:menu
echo  ==========================================
echo   🚀 Launch Options
echo  ==========================================
echo.
echo  [1] 🔧 Launch Remote Tester (Recommended)
echo  [2] 🔍 Launch with Auto-Scan
echo  [3] 📚 View Remote Commands Reference
echo  [4] 🎯 Launch Fish It Specific Mode
echo  [5] 🐛 Launch Debug Mode
echo  [6] 📖 How to Use Guide
echo  [7] ❌ Exit
echo.

set /p choice="Select option (1-7): "

if "%choice%"=="1" goto launch_tester
if "%choice%"=="2" goto launch_autoscan
if "%choice%"=="3" goto view_reference
if "%choice%"=="4" goto launch_fishit_mode
if "%choice%"=="5" goto launch_debug
if "%choice%"=="6" goto show_guide
if "%choice%"=="7" goto exit

echo Invalid choice! Please select 1-7.
goto menu

:launch_tester
echo.
echo  [INFO] Launching Remote Tester...
echo  [INFO] Mode: Standard
echo  [INFO] Features: All tools enabled
echo.
call :launch_script "standard"
goto post_launch

:launch_autoscan
echo.
echo  [INFO] Launching with Auto-Scan...
echo  [INFO] Mode: Auto-scan enabled
echo  [INFO] Will automatically scan remotes on load
echo.
call :launch_script "autoscan"
goto post_launch

:view_reference
echo.
echo  ==========================================
echo   📚 Remote Commands Reference
echo  ==========================================
echo.
echo  🎣 FISHING REMOTES:
echo.
echo  RemoteEvents (RE/):
echo  • PlayFishingEffect - Start fishing action
echo  • FishCaught - Fish catch notification
echo  • BaitSpawned - Bait deployment
echo  • FishingStopped - Fishing stopped
echo  • FishingCompleted - Fishing completed
echo  • FishingMinigameChanged - Minigame state
echo  • ObtainedNewFishNotification - New fish alert
echo.
echo  RemoteFunctions (RF/):
echo  • ChargeFishingRod - Charge rod (args: power level)
echo  • CancelFishingInputs - Cancel fishing
echo  • RequestFishingMinigameStarted - Start minigame
echo  • UpdateFishingRadar - Update radar
echo  • UpdateAutoFishingState - Auto fishing state
echo.
echo  💰 ECONOMY REMOTES:
echo.
echo  RemoteFunctions (RF/):
echo  • SellItem - Sell specific item (args: item_id)
echo  • SellAllItems - Sell all fish
echo  • PurchaseFishingRod - Buy rod (args: rod_id)
echo  • PurchaseBait - Buy bait (args: bait_id)
echo  • PurchaseGear - Buy gear (args: gear_id)
echo  • PurchaseBoat - Buy boat (args: boat_id)
echo.
echo  🎮 EQUIPMENT REMOTES:
echo.
echo  RemoteEvents (RE/):
echo  • EquipItem - Equip item (args: item_id)
echo  • UnequipItem - Unequip item (args: item_id)
echo  • EquipBait - Equip bait (args: bait_type)
echo  • EquipRodSkin - Equip rod skin (args: skin_id)
echo.
echo  🚤 VEHICLE REMOTES:
echo.
echo  RemoteFunctions (RF/):
echo  • SpawnBoat - Spawn boat (args: boat_type)
echo  • DespawnBoat - Despawn boat
echo.
echo  📖 USAGE EXAMPLES:
echo  • Remote: PlayFishingEffect, Args: (none)
echo  • Remote: ChargeFishingRod, Args: 1
echo  • Remote: SellItem, Args: fish123
echo  • Remote: EquipBait, Args: worm
echo.
pause
goto menu

:launch_fishit_mode
echo.
echo  [INFO] Launching Fish It Specific Mode...
echo  [INFO] Mode: Fish It optimized
echo  [INFO] Pre-loaded with Fish It remote names
echo.

REM Create Fish It specific version
echo -- Remote Tester Fish It Mode > temp_fishit_tester.lua
echo local fishItMode = true >> temp_fishit_tester.lua
echo local preloadedRemotes = { >> temp_fishit_tester.lua
echo     "PlayFishingEffect", "FishCaught", "ChargeFishingRod", >> temp_fishit_tester.lua
echo     "SellAllItems", "CancelFishingInputs", "EquipBait" >> temp_fishit_tester.lua
echo } >> temp_fishit_tester.lua
echo. >> temp_fishit_tester.lua

REM Append main script
type "remote_tester.lua" >> temp_fishit_tester.lua

call :launch_script_file "temp_fishit_tester.lua"
goto post_launch

:launch_debug
echo.
echo  [INFO] Launching Debug Mode...
echo  [INFO] Mode: Full debugging enabled
echo  [INFO] Verbose logging and error details
echo.

REM Create debug version
echo -- Remote Tester Debug Mode > temp_debug_tester.lua
echo local debugMode = true >> temp_debug_tester.lua
echo local verboseLogging = true >> temp_debug_tester.lua
echo. >> temp_debug_tester.lua

REM Append main script
type "remote_tester.lua" >> temp_debug_tester.lua

call :launch_script_file "temp_debug_tester.lua"
goto post_launch

:show_guide
echo.
echo  ==========================================
echo   📖 How to Use Remote Tester
echo  ==========================================
echo.
echo  🔍 STEP 1: Scan Remotes
echo  • Click "Scan All Remotes" button
echo  • Wait for scan to complete
echo  • Check status for total remotes found
echo.
echo  🚀 STEP 2: Execute Remotes
echo  • Enter remote name (with or without RE/RF prefix)
echo  • Add arguments if needed (comma separated)
echo  • Click "RUN REMOTE" button
echo  • Check history for results
echo.
echo  ⚡ STEP 3: Quick Actions
echo  • Use pre-configured buttons for common actions
echo  • PlayFishingEffect - Start fishing
echo  • ChargeFishingRod - Charge rod
echo  • SellAllItems - Sell fish
echo  • CancelFishingInputs - Stop fishing
echo.
echo  📋 STEP 4: Monitor Results
echo  • Check execution history
echo  • Look for ✅ (success) or ❌ (error)
echo  • Review return values
echo  • Use results for debugging
echo.
echo  💡 TIPS:
echo  • Use F5 to quickly scan remotes
echo  • Press Enter to execute commands
echo  • Arguments examples: 1, true, "text", item123
echo  • Check console for detailed logs
echo.
echo  🎯 FISH IT SPECIFIC:
echo  • Most important: PlayFishingEffect
echo  • For charging: ChargeFishingRod with power (1-10)
echo  • For selling: SellAllItems (no args needed)
echo  • For stopping: CancelFishingInputs
echo.
pause
goto menu

:launch_script
echo  [INFO] Preparing Remote Tester script...
echo  [INFO] Mode: %~1
echo.

REM Create launch script
echo -- Remote Tester Launch > temp_tester_launch.lua
echo local launchMode = "%~1" >> temp_tester_launch.lua
echo. >> temp_tester_launch.lua

REM Append main script
type "remote_tester.lua" >> temp_tester_launch.lua

echo -- Configure launch mode >> temp_tester_launch.lua
echo if launchMode == "autoscan" then >> temp_tester_launch.lua
echo     -- Auto-scan will be handled by main script >> temp_tester_launch.lua
echo     print("🔍 Auto-scan mode activated") >> temp_tester_launch.lua
echo end >> temp_tester_launch.lua

echo  [INFO] Remote Tester script ready
echo  [INFO] Copy and paste this command into Roblox executor:
echo.
echo  ==========================================
color 0E
echo  loadstring(readfile("temp_tester_launch.lua"))()
color 0D
echo  ==========================================
echo.
goto :eof

:launch_script_file
echo  [INFO] Remote Tester script ready
echo  [INFO] Copy and paste this command into Roblox executor:
echo.
echo  ==========================================
color 0E
echo  loadstring(readfile("%~1"))()
color 0D
echo  ==========================================
echo.
goto :eof

:post_launch
echo.
echo  ==========================================
echo   🔧 Remote Tester Launched!
echo  ==========================================
echo.
echo  Next Steps:
echo.
echo  1. 🎮 Open your Roblox executor
echo  2. 📋 Copy the loadstring command above
echo  3. ✅ Execute in Fish It game
echo  4. 🔍 Click "Scan All Remotes" first!
echo.
echo  🔧 Remote Tester Controls:
echo    • F5 - Quick scan remotes
echo    • Enter - Execute command
echo    • Click buttons for quick actions
echo.
echo  🎯 Quick Test Sequence:
echo    1. Scan remotes first
echo    2. Try PlayFishingEffect
echo    3. Try ChargeFishingRod with arg: 1
echo    4. Try SellAllItems
echo    5. Check execution history
echo.
echo  📋 What You Can Test:
echo    • All discovered remote events
echo    • Custom arguments and parameters
echo    • Fish It specific remotes
echo    • Return values and responses
echo.

:monitor
echo.
echo  ==========================================
echo   📊 Remote Tester Monitor
echo  ==========================================
echo.
echo  [%date% %time%] Remote Tester Active
echo  Status: Ready for remote testing and debugging
echo.
echo  Available Actions:
echo  ✓ Scan and discover all remotes
echo  ✓ Execute remotes with custom args
echo  ✓ Quick action buttons
echo  ✓ Execution history tracking
echo  ✓ Real-time result monitoring
echo.
echo  Options:
echo  [1] 🔄 Restart Remote Tester
echo  [2] 📚 View Remote Reference
echo  [3] 🎯 Switch to AutoFish Mode
echo  [4] 🛑 Stop Session
echo  [5] 🏠 Back to Menu
echo.

set /p mon_choice="Select option (1-5): "

if "%mon_choice%"=="1" goto menu
if "%mon_choice%"=="2" goto view_reference
if "%mon_choice%"=="3" goto switch_autofish
if "%mon_choice%"=="4" goto stop_session
if "%mon_choice%"=="5" goto menu

echo Invalid choice!
goto monitor

:switch_autofish
echo.
echo  [INFO] Switching to AutoFish mode...
echo  [INFO] Run OptimizedFishIt_Launcher.bat for AutoFish
echo  [INFO] Or use autofish_fishit_optimized.lua directly
echo.
echo  💡 Use Remote Tester to discover new remotes for AutoFish!
echo  📊 Test remotes first, then integrate into AutoFish script
echo.
pause
goto menu

:stop_session
echo.
echo  [INFO] Stopping Remote Tester session...
echo  [INFO] Close the UI window or press X button
echo.
echo  📊 Remote Testing Summary:
echo    • Check execution history in UI
echo    • Note successful remote calls
echo    • Document any new discoveries
echo    • Use findings for AutoFish optimization
echo.
pause
goto menu

:exit
echo.
echo  ==========================================
echo   👋 Thanks for using Remote Tester!
echo  ==========================================
echo.
echo  [INFO] Cleaning up temporary files...

if exist "temp_tester_launch.lua" (
    del "temp_tester_launch.lua"
    echo  [✓] Launch file cleaned
)

if exist "temp_fishit_tester.lua" (
    del "temp_fishit_tester.lua"
    echo  [✓] Fish It mode file cleaned
)

if exist "temp_debug_tester.lua" (
    del "temp_debug_tester.lua"
    echo  [✓] Debug mode file cleaned
)

echo  [INFO] Remote Tester session ended
echo  [INFO] Remember to close the UI before closing Roblox
echo.
echo  🔧 Remote Testing Summary:
echo    • Tool for discovering and testing remotes
echo    • Execute any RemoteEvent or RemoteFunction
echo    • Perfect for AutoFish development
echo    • Debugging and reverse engineering
echo.
echo  🚀 Thank you for using Remote Tester!
echo  Perfect for Fish It game development and testing!
echo.
pause
exit /b 0
