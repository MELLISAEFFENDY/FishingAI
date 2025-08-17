@echo off
color 0E
title ModuleScript Analyzer - Fish It

echo.
echo  ==========================================
echo   📁 MODULESCRIPT ANALYZER
echo  ==========================================
echo.

echo  [INFO] Initializing ModuleScript Analyzer for Fish It...
timeout /t 2 /nobreak >nul

if exist "module_analyzer.lua" (
    echo  [✓] Module Analyzer script found
) else (
    echo  [X] Module Analyzer script missing!
    echo  [ERROR] Please ensure module_analyzer.lua is in this folder
    pause
    exit /b 1
)

echo.
echo  ==========================================
echo   🎯 AUTOFISHINGCONTROLLER ANALYSIS
echo  ==========================================
echo.
echo  📁 AutoFishingController Details:
echo    • Location: ReplicatedStorage.Controllers.AutoFishingController
echo    • Type: ModuleScript (requires loading)
echo    • Purpose: Auto fishing functionality controller
echo    • Access: require() method needed
echo.
echo  🔍 Expected Methods/Properties:
echo    • StartAutoFishing() - Start auto fishing
echo    • StopAutoFishing() - Stop auto fishing
echo    • ToggleAutoFishing() - Toggle auto fishing state
echo    • IsAutoFishing - Current state property
echo    • SetFishingMode() - Set fishing mode
echo    • GetFishingSettings() - Get current settings
echo.
echo  💡 Analysis Strategy:
echo    1. Scan all ModuleScripts in ReplicatedStorage
echo    2. Load AutoFishingController via require()
echo    3. Analyze all available methods and properties
echo    4. Test method calls with different arguments
echo    5. Monitor results and side effects
echo.

:menu
echo  ==========================================
echo   🚀 Launch Options
echo  ==========================================
echo.
echo  [1] 📁 Launch Module Analyzer (Recommended)
echo  [2] 🎣 Quick AutoFishingController Analysis
echo  [3] 🔍 Scan All Controllers
echo  [4] 📖 AutoFishingController Guide
echo  [5] 🧪 Experimental Mode
echo  [6] 📚 Module Reference
echo  [7] ❌ Exit
echo.

set /p choice="Select option (1-7): "

if "%choice%"=="1" goto launch_analyzer
if "%choice%"=="2" goto quick_autofish
if "%choice%"=="3" goto scan_controllers
if "%choice%"=="4" goto autofish_guide
if "%choice%"=="5" goto experimental_mode
if "%choice%"=="6" goto module_reference
if "%choice%"=="7" goto exit

echo Invalid choice! Please select 1-7.
goto menu

:launch_analyzer
echo.
echo  [INFO] Launching Module Analyzer...
echo  [INFO] Mode: Full analysis
echo  [INFO] Target: All ModuleScripts
echo.
call :launch_script "standard"
goto post_launch

:quick_autofish
echo.
echo  [INFO] Quick AutoFishingController Analysis...
echo  [INFO] Mode: AutoFish focused
echo  [INFO] Auto-loading AutoFishingController
echo.

REM Create AutoFish specific version
echo -- Module Analyzer AutoFish Mode > temp_autofish_analyzer.lua
echo local autoFishMode = true >> temp_autofish_analyzer.lua
echo local targetModule = "AutoFishingController" >> temp_autofish_analyzer.lua
echo. >> temp_autofish_analyzer.lua

REM Append main script
type "module_analyzer.lua" >> temp_autofish_analyzer.lua

echo -- Auto-load AutoFishingController >> temp_autofish_analyzer.lua
echo task.spawn(function() >> temp_autofish_analyzer.lua
echo     task.wait(3) >> temp_autofish_analyzer.lua
echo     loadModule("AutoFishingController") >> temp_autofish_analyzer.lua
echo     updateMethods("AutoFishingController") >> temp_autofish_analyzer.lua
echo end) >> temp_autofish_analyzer.lua

call :launch_script_file "temp_autofish_analyzer.lua"
goto post_launch

:scan_controllers
echo.
echo  [INFO] Scanning All Controllers...
echo  [INFO] Target: Controllers folder
echo  [INFO] Analysis: All controller modules
echo.

REM Create controller scan version
echo -- Module Analyzer Controller Scan > temp_controller_scan.lua
echo local controllerMode = true >> temp_controller_scan.lua
echo local targetControllers = { >> temp_controller_scan.lua
echo     "AutoFishingController", >> temp_controller_scan.lua
echo     "FishingController", >> temp_controller_scan.lua
echo     "BaitShopController", >> temp_controller_scan.lua
echo     "RodShopController" >> temp_controller_scan.lua
echo } >> temp_controller_scan.lua
echo. >> temp_controller_scan.lua

REM Append main script
type "module_analyzer.lua" >> temp_controller_scan.lua

call :launch_script_file "temp_controller_scan.lua"
goto post_launch

:autofish_guide
echo.
echo  ==========================================
echo   📖 AutoFishingController Usage Guide
echo  ==========================================
echo.
echo  🎯 ACCESSING AUTOFISHINGCONTROLLER:
echo.
echo  1. Basic Access:
echo     local AFC = require(ReplicatedStorage.Controllers.AutoFishingController)
echo.
echo  2. Check Available Methods:
echo     for key, value in pairs(AFC) do
echo         print(key, type(value))
echo     end
echo.
echo  3. Common Method Patterns:
echo     • AFC:StartAutoFishing()
echo     • AFC:StopAutoFishing()
echo     • AFC:ToggleAutoFishing()
echo     • AFC.IsEnabled (property)
echo.
echo  🔍 ANALYSIS METHODS:
echo.
echo  Method Discovery:
echo  • Load module via Module Analyzer
echo  • Check all properties and functions
echo  • Test with different arguments
echo  • Monitor game state changes
echo.
echo  Testing Strategy:
echo  1. Start with parameter-less methods
echo  2. Try boolean toggles (true/false)
echo  3. Test with fishing rod IDs
echo  4. Check state properties
echo.
echo  🎣 EXPECTED FUNCTIONALITY:
echo.
echo  AutoFishing Features:
echo  • Automatic rod casting
echo  • Fish detection and reeling
echo  • Bait management
echo  • Fishing location optimization
echo  • Anti-AFK functionality
echo.
echo  Integration Points:
echo  • Works with UpdateAutoFishingState remote
echo  • Connects to FishingController
echo  • Uses ChargeFishingRod remote
echo  • Monitors FishCaught events
echo.
echo  💡 TROUBLESHOOTING:
echo.
echo  Common Issues:
echo  • Module requires fishing rod equipped
echo  • May need specific game state
echo  • Could require permissions/game passes
echo  • Might have cooldowns or limits
echo.
echo  Testing Tips:
echo  • Test in fishing area
echo  • Equip fishing rod first
echo  • Check player inventory
echo  • Monitor remote calls
echo.
pause
goto menu

:experimental_mode
echo.
echo  [INFO] Launching Experimental Mode...
echo  [INFO] Mode: Advanced analysis with hooks
echo  [INFO] Features: Method hooking and monitoring
echo.

REM Create experimental version
echo -- Module Analyzer Experimental Mode > temp_experimental.lua
echo local experimentalMode = true >> temp_experimental.lua
echo local enableHooks = true >> temp_experimental.lua
echo local monitorCalls = true >> temp_experimental.lua
echo. >> temp_experimental.lua

REM Append main script
type "module_analyzer.lua" >> temp_experimental.lua

echo -- Experimental features >> temp_experimental.lua
echo if experimentalMode then >> temp_experimental.lua
echo     print("🧪 Experimental mode enabled") >> temp_experimental.lua
echo     print("📊 Method hooking and call monitoring active") >> temp_experimental.lua
echo end >> temp_experimental.lua

call :launch_script_file "temp_experimental.lua"
goto post_launch

:module_reference
echo.
echo  ==========================================
echo   📚 Fish It ModuleScript Reference
echo  ==========================================
echo.
echo  🎣 FISHING MODULES:
echo.
echo  AutoFishingController:
echo  • Purpose: Main auto fishing logic
echo  • Location: ReplicatedStorage.Controllers
echo  • Key Methods: Start/Stop/Toggle auto fishing
echo.
echo  FishingController:
echo  • Purpose: Core fishing mechanics
echo  • Location: ReplicatedStorage.Controllers
echo  • Key Methods: Cast, reel, bait management
echo.
echo  FishingRodModifiers:
echo  • Purpose: Rod stats and modifiers
echo  • Location: ReplicatedStorage.Shared
echo  • Key Data: Rod power, luck, speed values
echo.
echo  Baits:
echo  • Purpose: Bait types and effects
echo  • Location: ReplicatedStorage
echo  • Key Data: Bait stats, catch modifiers
echo.
echo  🛒 SHOP MODULES:
echo.
echo  RodShopController:
echo  • Purpose: Fishing rod shop logic
echo  • Methods: Purchase, upgrade, equip rods
echo.
echo  BaitShopController:
echo  • Purpose: Bait shop management
echo  • Methods: Buy baits, manage inventory
echo.
echo  CoinProducts ^& ItemProducts:
echo  • Purpose: In-game economy
echo  • Data: Prices, items, transactions
echo.
echo  🎮 GAME SYSTEMS:
echo.
echo  FishWeightChances:
echo  • Purpose: Fish weight probability
echo  • Data: Weight distribution tables
echo.
echo  Products Folder:
echo  • Purpose: All purchasable items
echo  • Modules: Coins, items, special products
echo.
echo  GiftProducts:
echo  • Purpose: Free items and rewards
echo  • Methods: Claim gifts, daily rewards
echo.
echo  🔧 UTILITIES:
echo.
echo  RaycastUtility:
echo  • Purpose: 3D positioning and detection
echo  • Methods: Raycasting for fishing spots
echo.
echo  Network ^& Net:
echo  • Purpose: Client-server communication
echo  • Methods: Remote event handling
echo.
echo  FastCastRedux:
echo  • Purpose: Projectile system (fishing line)
echo  • Methods: Line casting physics
echo.
echo  💡 ANALYSIS TIPS:
echo.
echo  1. Start with Controllers folder
echo  2. Focus on AutoFishingController first
echo  3. Check for Start/Stop/Toggle methods
echo  4. Look for state properties (IsEnabled, etc.)
echo  5. Test methods in fishing areas
echo  6. Monitor remote event calls
echo  7. Check for required arguments
echo  8. Look for callback functions
echo.
pause
goto menu

:launch_script
echo  [INFO] Preparing Module Analyzer script...
echo  [INFO] Mode: %~1
echo.

REM Create launch script
echo -- Module Analyzer Launch > temp_analyzer_launch.lua
echo local launchMode = "%~1" >> temp_analyzer_launch.lua
echo. >> temp_analyzer_launch.lua

REM Append main script
type "module_analyzer.lua" >> temp_analyzer_launch.lua

echo  [INFO] Module Analyzer script ready
echo  [INFO] Copy and paste this command into Roblox executor:
echo.
echo  ==========================================
color 0A
echo  loadstring(readfile("temp_analyzer_launch.lua"))()
color 0E
echo  ==========================================
echo.
goto :eof

:launch_script_file
echo  [INFO] Module Analyzer script ready
echo  [INFO] Copy and paste this command into Roblox executor:
echo.
echo  ==========================================
color 0A
echo  loadstring(readfile("%~1"))()
color 0E
echo  ==========================================
echo.
goto :eof

:post_launch
echo.
echo  ==========================================
echo   📁 Module Analyzer Launched!
echo  ==========================================
echo.
echo  Next Steps:
echo.
echo  1. 🎮 Open your Roblox executor
echo  2. 📋 Copy the loadstring command above
echo  3. ✅ Execute in Fish It game
echo  4. 📁 Click "Scan All Modules" first
echo  5. 🎣 Click "AutoFishingController" button
echo.
echo  🎯 AutoFishingController Analysis:
echo    1. Load AutoFishingController module
echo    2. Check available methods and properties
echo    3. Test StartAutoFishing() method
echo    4. Try ToggleAutoFishing() if available
echo    5. Monitor IsEnabled or similar properties
echo.
echo  📁 Module Analyzer Features:
echo    • Scan all ModuleScripts automatically
echo    • Load and analyze any module
echo    • Execute methods with custom arguments
echo    • View all properties and functions
echo    • Execution history tracking
echo.
echo  🔍 AutoFishing Testing Sequence:
echo    1. Load AutoFishingController
echo    2. Check methods list
echo    3. Try: StartAutoFishing
echo    4. Try: StopAutoFishing
echo    5. Try: ToggleAutoFishing
echo    6. Check state properties
echo.

:monitor
echo.
echo  ==========================================
echo   📊 Module Analysis Monitor
echo  ==========================================
echo.
echo  [%date% %time%] Module Analyzer Active
echo  Status: Ready for ModuleScript analysis
echo.
echo  Current Focus: AutoFishingController
echo  ✓ Scan ModuleScripts
echo  ✓ Load AutoFishingController
echo  ✓ Analyze available methods
echo  ✓ Test auto fishing functions
echo  ✓ Monitor execution results
echo.
echo  Expected AutoFishing Methods:
echo  • StartAutoFishing() - Begin auto fishing
echo  • StopAutoFishing() - End auto fishing
echo  • ToggleAutoFishing() - Toggle state
echo  • IsEnabled - Current state property
echo  • SetMode() - Set fishing mode
echo.
echo  Options:
echo  [1] 🔄 Restart Module Analyzer
echo  [2] 🎣 Focus on AutoFishingController
echo  [3] 🔍 Scan Other Controllers
echo  [4] 🛑 Stop Session
echo  [5] 🏠 Back to Menu
echo.

set /p mon_choice="Select option (1-5): "

if "%mon_choice%"=="1" goto menu
if "%mon_choice%"=="2" goto quick_autofish
if "%mon_choice%"=="3" goto scan_controllers
if "%mon_choice%"=="4" goto stop_session
if "%mon_choice%"=="5" goto menu

echo Invalid choice!
goto monitor

:stop_session
echo.
echo  [INFO] Stopping Module Analyzer session...
echo  [INFO] Close the UI window or press X button
echo.
echo  📊 Analysis Summary:
echo    • Check loaded modules in UI
echo    • Review method execution results
echo    • Note successful AutoFishing calls
echo    • Document discovered methods
echo.
echo  🎣 AutoFishingController Findings:
echo    • Save successful method names
echo    • Document required arguments
echo    • Note any state properties
echo    • Record integration points
echo.
pause
goto menu

:exit
echo.
echo  ==========================================
echo   👋 Thanks for using Module Analyzer!
echo  ==========================================
echo.
echo  [INFO] Cleaning up temporary files...

if exist "temp_analyzer_launch.lua" (
    del "temp_analyzer_launch.lua"
    echo  [✓] Launch file cleaned
)

if exist "temp_autofish_analyzer.lua" (
    del "temp_autofish_analyzer.lua"
    echo  [✓] AutoFish mode file cleaned
)

if exist "temp_controller_scan.lua" (
    del "temp_controller_scan.lua"
    echo  [✓] Controller scan file cleaned
)

if exist "temp_experimental.lua" (
    del "temp_experimental.lua"
    echo  [✓] Experimental mode file cleaned
)

echo  [INFO] Module Analyzer session ended
echo  [INFO] Remember to close the UI before closing Roblox
echo.
echo  📁 ModuleScript Analysis Summary:
echo    • Tool for analyzing ModuleScripts
echo    • Load and execute module methods
echo    • Perfect for AutoFishingController analysis
echo    • Discover hidden functionality
echo.
echo  🎣 AutoFishingController Discovery:
echo    • Use findings to integrate auto fishing
echo    • Test discovered methods in your scripts
echo    • Monitor for game updates and changes
echo.
echo  🚀 Thank you for using Module Analyzer!
echo  Perfect for Fish It game development and research!
echo.
pause
exit /b 0
