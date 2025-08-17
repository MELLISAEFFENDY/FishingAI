@echo off
color 0B
title Fish It Tools - GitHub Deployment Helper

echo.
echo  ==========================================
echo   🌐 FISH IT TOOLS - GITHUB DEPLOYMENT
echo  ==========================================
echo.

echo  [INFO] GitHub Raw URL Deployment Helper
timeout /t 1 /nobreak >nul

echo.
echo  📁 Files Ready for GitHub Deployment:
echo.

if exist "deploy_remote_tester.lua" (
    echo  ✓ deploy_remote_tester.lua - Ready
) else (
    echo  ✗ deploy_remote_tester.lua - Missing
)

if exist "deploy_module_analyzer.lua" (
    echo  ✓ deploy_module_analyzer.lua - Ready
) else (
    echo  ✗ deploy_module_analyzer.lua - Missing
)

if exist "GitHub_Deployment_Guide.md" (
    echo  ✓ GitHub_Deployment_Guide.md - Ready
) else (
    echo  ✗ GitHub_Deployment_Guide.md - Missing
)

echo.
echo  ==========================================
echo   🚀 GitHub Deployment Commands
echo  ==========================================
echo.

:menu
echo  [1] 🔧 Generate Remote Tester URL
echo  [2] 📁 Generate Module Analyzer URL
echo  [3] 🌐 Setup GitHub Repository Guide
echo  [4] 📋 Copy Commands Template
echo  [5] 🧪 Test Local Deployment
echo  [6] 📚 View Documentation
echo  [7] ❌ Exit
echo.

set /p choice="Select option (1-7): "

if "%choice%"=="1" goto remote_url
if "%choice%"=="2" goto module_url
if "%choice%"=="3" goto github_guide
if "%choice%"=="4" goto copy_template
if "%choice%"=="5" goto test_local
if "%choice%"=="6" goto view_docs
if "%choice%"=="7" goto exit

echo Invalid choice! Please select 1-7.
goto menu

:remote_url
echo.
echo  ==========================================
echo   🔧 Remote Tester GitHub URL Generator
echo  ==========================================
echo.

set /p username="Enter your GitHub Username: "
set /p repo="Enter your Repository Name: "

echo.
echo  📋 Generated URL for Remote Tester:
echo.
color 0A
echo  https://raw.githubusercontent.com/%username%/%repo%/main/deploy_remote_tester.lua
color 0B
echo.
echo  📋 Roblox Command:
echo.
color 0E
echo  loadstring(game:HttpGet("https://raw.githubusercontent.com/%username%/%repo%/main/deploy_remote_tester.lua"))()
color 0B
echo.
echo  📋 Copy the command above and paste into your Roblox executor
echo.

echo  💡 Quick Setup Steps:
echo  1. Upload deploy_remote_tester.lua to your GitHub repo
echo  2. Make sure repository is PUBLIC
echo  3. Copy the loadstring command above
echo  4. Paste into Roblox executor in Fish It game
echo  5. Look for purple 🔧 floating button on left side
echo.

pause
goto menu

:module_url
echo.
echo  ==========================================
echo   📁 Module Analyzer GitHub URL Generator
echo  ==========================================
echo.

set /p username="Enter your GitHub Username: "
set /p repo="Enter your Repository Name: "

echo.
echo  📋 Generated URL for Module Analyzer:
echo.
color 0A
echo  https://raw.githubusercontent.com/%username%/%repo%/main/deploy_module_analyzer.lua
color 0B
echo.
echo  📋 Roblox Command:
echo.
color 0E
echo  loadstring(game:HttpGet("https://raw.githubusercontent.com/%username%/%repo%/main/deploy_module_analyzer.lua"))()
color 0B
echo.
echo  📋 Copy the command above and paste into your Roblox executor
echo.

echo  💡 Quick Setup Steps:
echo  1. Upload deploy_module_analyzer.lua to your GitHub repo
echo  2. Make sure repository is PUBLIC
echo  3. Copy the loadstring command above
echo  4. Paste into Roblox executor in Fish It game
echo  5. Look for purple 📁 floating button on left side
echo.

echo  🎯 AutoFishingController Analysis:
echo  1. Click 📁 floating button to open UI
echo  2. Click "🎣 AutoFishingController" quick button
echo  3. Wait for module loading and analysis
echo  4. Check methods list for auto fishing functions
echo.

pause
goto menu

:github_guide
echo.
echo  ==========================================
echo   🌐 GitHub Repository Setup Guide
echo  ==========================================
echo.

echo  📁 Step 1 - Create Repository:
echo  1. Go to github.com and login
echo  2. Click "New repository" button
echo  3. Name: fish-it-tools (or your choice)
echo  4. Set as PUBLIC repository
echo  5. Initialize with README.md
echo  6. Click "Create repository"
echo.

echo  📤 Step 2 - Upload Files:
echo  Required files to upload:
echo  • deploy_remote_tester.lua
echo  • deploy_module_analyzer.lua
echo  • GitHub_Deployment_Guide.md (optional)
echo.

echo  🌐 Step 3 - Get Raw URLs:
echo  1. Click on uploaded file in GitHub
echo  2. Click "Raw" button
echo  3. Copy the URL from browser address bar
echo  4. URL format: https://raw.githubusercontent.com/USERNAME/REPO/main/FILENAME
echo.

echo  🎮 Step 4 - Use in Roblox:
echo  1. Copy raw URL
echo  2. Create loadstring command:
echo     loadstring(game:HttpGet("YOUR_RAW_URL"))()
echo  3. Paste into Roblox executor
echo  4. Execute in Fish It game
echo.

echo  🔍 Step 5 - Verify Deployment:
echo  • Look for floating buttons (🔧 and 📁)
echo  • Test UI functionality
echo  • Check console for error messages
echo  • Verify all features working
echo.

pause
goto menu

:copy_template
echo.
echo  ==========================================
echo   📋 Commands Template Generator
echo  ==========================================
echo.

set /p username="Enter your GitHub Username: "
set /p repo="Enter your Repository Name: "

echo.
echo  📋 Complete Commands Template:
echo.

REM Create template file
echo -- Fish It Tools GitHub Deployment > github_commands_template.txt
echo -- Generated on %date% %time% >> github_commands_template.txt
echo. >> github_commands_template.txt
echo -- Remote Event/Function Tester >> github_commands_template.txt
echo loadstring(game:HttpGet("https://raw.githubusercontent.com/%username%/%repo%/main/deploy_remote_tester.lua"))() >> github_commands_template.txt
echo. >> github_commands_template.txt
echo -- ModuleScript Analyzer >> github_commands_template.txt
echo loadstring(game:HttpGet("https://raw.githubusercontent.com/%username%/%repo%/main/deploy_module_analyzer.lua"))() >> github_commands_template.txt
echo. >> github_commands_template.txt
echo -- Load Both Tools >> github_commands_template.txt
echo loadstring(game:HttpGet("https://raw.githubusercontent.com/%username%/%repo%/main/deploy_remote_tester.lua"))() >> github_commands_template.txt
echo wait(1) >> github_commands_template.txt
echo loadstring(game:HttpGet("https://raw.githubusercontent.com/%username%/%repo%/main/deploy_module_analyzer.lua"))() >> github_commands_template.txt

echo  ✓ Template saved to: github_commands_template.txt
echo.

echo  📋 Individual Commands:
echo.
echo  🔧 Remote Tester:
color 0A
echo  loadstring(game:HttpGet("https://raw.githubusercontent.com/%username%/%repo%/main/deploy_remote_tester.lua"))()
color 0B
echo.
echo  📁 Module Analyzer:
color 0A
echo  loadstring(game:HttpGet("https://raw.githubusercontent.com/%username%/%repo%/main/deploy_module_analyzer.lua"))()
color 0B
echo.
echo  🚀 Both Tools:
color 0E
echo  loadstring(game:HttpGet("https://raw.githubusercontent.com/%username%/%repo%/main/deploy_remote_tester.lua"))()
echo  wait(1)
echo  loadstring(game:HttpGet("https://raw.githubusercontent.com/%username%/%repo%/main/deploy_module_analyzer.lua"))()
color 0B
echo.

echo  💡 Usage Instructions:
echo  1. Open Fish It game in Roblox
echo  2. Open your Roblox executor
echo  3. Copy and paste any command above
echo  4. Execute the command
echo  5. Look for floating buttons on left side
echo     • 🔧 Purple button = Remote Tester
echo     • 📁 Purple button = Module Analyzer
echo  6. Click buttons to show/hide UIs
echo.

pause
goto menu

:test_local
echo.
echo  ==========================================
echo   🧪 Local Deployment Testing
echo  ==========================================
echo.

echo  [INFO] Testing local deployment files...
echo.

if exist "deploy_remote_tester.lua" (
    echo  ✓ deploy_remote_tester.lua exists
    
    REM Check file size
    for %%A in (deploy_remote_tester.lua) do (
        echo    Size: %%~zA bytes
    )
    
    REM Create test command
    echo -- Local Test Remote Tester > test_remote_tester.lua
    echo loadstring(readfile("deploy_remote_tester.lua"))() >> test_remote_tester.lua
    echo  ✓ Test command created: test_remote_tester.lua
) else (
    echo  ✗ deploy_remote_tester.lua missing!
)

echo.

if exist "deploy_module_analyzer.lua" (
    echo  ✓ deploy_module_analyzer.lua exists
    
    REM Check file size
    for %%A in (deploy_module_analyzer.lua) do (
        echo    Size: %%~zA bytes
    )
    
    REM Create test command
    echo -- Local Test Module Analyzer > test_module_analyzer.lua
    echo loadstring(readfile("deploy_module_analyzer.lua"))() >> test_module_analyzer.lua
    echo  ✓ Test command created: test_module_analyzer.lua
) else (
    echo  ✗ deploy_module_analyzer.lua missing!
)

echo.
echo  🧪 Local Test Commands:
echo.
echo  Remote Tester Test:
color 0E
echo  loadstring(readfile("deploy_remote_tester.lua"))()
color 0B
echo.
echo  Module Analyzer Test:
color 0E
echo  loadstring(readfile("deploy_module_analyzer.lua"))()
color 0B
echo.

echo  💡 Local Testing Steps:
echo  1. Make sure files are in executor folder
echo  2. Copy test commands above
echo  3. Paste into Roblox executor
echo  4. Test in Fish It game
echo  5. Verify floating buttons appear
echo  6. Test all UI functionality
echo.

echo  ✅ If local tests work, GitHub deployment should work too!
echo.

pause
goto menu

:view_docs
echo.
echo  ==========================================
echo   📚 Documentation Viewer
echo  ==========================================
echo.

if exist "GitHub_Deployment_Guide.md" (
    echo  📖 Opening GitHub Deployment Guide...
    start notepad "GitHub_Deployment_Guide.md"
) else (
    echo  ❌ GitHub_Deployment_Guide.md not found!
)

echo.
echo  📚 Available Documentation:
echo.

if exist "GitHub_Deployment_Guide.md" (
    echo  ✓ GitHub_Deployment_Guide.md - Main deployment guide
) else (
    echo  ✗ GitHub_Deployment_Guide.md - Missing
)

if exist "remote_tester.lua" (
    echo  ✓ remote_tester.lua - Original Remote Tester source
) else (
    echo  ✗ remote_tester.lua - Missing
)

if exist "module_analyzer.lua" (
    echo  ✓ module_analyzer.lua - Original Module Analyzer source
) else (
    echo  ✗ module_analyzer.lua - Missing
)

if exist "data1.txt" (
    echo  ✓ data1.txt - Fish It game data
) else (
    echo  ✗ data1.txt - Missing
)

if exist "data2.txt" (
    echo  ✓ data2.txt - Fish It analysis data
) else (
    echo  ✗ data2.txt - Missing
)

echo.
echo  💡 Documentation Contents:
echo  • Complete GitHub setup guide
echo  • URL generation templates
echo  • Usage instructions
echo  • Troubleshooting tips
echo  • AutoFishingController analysis guide
echo  • Best practices for deployment
echo.

pause
goto menu

:exit
echo.
echo  ==========================================
echo   👋 GitHub Deployment Helper
echo  ==========================================
echo.

echo  📁 Deployment Files Ready:
if exist "deploy_remote_tester.lua" echo  ✓ deploy_remote_tester.lua
if exist "deploy_module_analyzer.lua" echo  ✓ deploy_module_analyzer.lua
if exist "GitHub_Deployment_Guide.md" echo  ✓ GitHub_Deployment_Guide.md

echo.
echo  🚀 Next Steps:
echo  1. Create GitHub repository (public)
echo  2. Upload deployment files
echo  3. Get raw URLs from GitHub
echo  4. Use loadstring commands in Roblox
echo  5. Enjoy floating UI tools in Fish It!
echo.

echo  💡 Quick Reference:
echo  • 🔧 Remote Tester = Purple wrench floating button
echo  • 📁 Module Analyzer = Purple folder floating button
echo  • Both tools have draggable floating UIs
echo  • AutoFishingController analysis ready
echo.

echo  🌐 URL Template:
echo  https://raw.githubusercontent.com/USERNAME/REPO/main/FILENAME
echo.

echo  📋 Command Template:
echo  loadstring(game:HttpGet("YOUR_RAW_URL"))()
echo.

echo  🎣 Happy fishing and tool development!
echo.

pause
exit /b 0
