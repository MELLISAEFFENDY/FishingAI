@echo off
echo 🚀 GitHub Web Upload Helper - FishingAI Repository
echo ======================================
echo.
echo Repository: https://github.com/MELLISAEFFENDY/FishingAI
echo Files Location: c:\Users\Administrator\fishit
echo.
echo ======================================
echo 📋 WEB UPLOAD INSTRUCTIONS (RECOMMENDED)
echo ======================================
echo.
echo Step 1: Open GitHub Repository
echo   • Go to: https://github.com/MELLISAEFFENDY/FishingAI
echo   • Click "Add file" button
echo   • Select "Upload files"
echo.
echo Step 2: Upload All Files
echo   • Drag and drop ALL files from this folder
echo   • Or click "choose your files" and select all
echo   • Wait for upload to complete
echo.
echo Step 3: Commit Changes
echo   • Scroll down to commit section
echo   • Title: "Complete FishingAI toolset with floating UI"
echo   • Description: "Added floating UI tools, AutoFish scripts, and comprehensive documentation"
echo   • Click "Commit changes" button
echo.
echo ======================================
echo 🎯 PRIORITY FILES TO UPLOAD FIRST
echo ======================================
echo.
echo Essential files for immediate GitHub Raw URL usage:
echo   ✅ deploy_remote_tester.lua
echo   ✅ deploy_module_analyzer.lua  
echo   ✅ autofish_fishit_optimized.lua
echo   ✅ README.md
echo.
echo ======================================
echo 📁 ALTERNATIVE: GITHUB DESKTOP
echo ======================================
echo.
echo If you prefer GUI tool:
echo 1. Download GitHub Desktop: https://desktop.github.com/
echo 2. Install and login to your GitHub account
echo 3. Clone repository: https://github.com/MELLISAEFFENDY/FishingAI
echo 4. Copy all files to cloned folder
echo 5. Commit and push via GUI
echo.
echo ======================================
echo 🎮 AFTER UPLOAD - TEST URLS
echo ======================================
echo.
echo Remote Tester with Floating UI:
echo loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_remote_tester.lua"))()
echo.
echo Module Analyzer with Floating UI:
echo loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_module_analyzer.lua"))()
echo.
echo Optimized AutoFish:
echo loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/autofish_fishit_optimized.lua"))()
echo.
echo ======================================
echo 🔧 GIT INSTALLATION HELP
echo ======================================
echo.
echo If you want to use Git commands later:
echo 1. Download Git: https://git-scm.com/download/win
echo 2. During installation, select "Add Git to PATH"
echo 3. Restart PowerShell after installation
echo 4. Test with: git --version
echo.
echo ======================================
echo 📂 FILE EXPLORER SHORTCUT
echo ======================================
echo.
echo Opening current folder in File Explorer...
timeout /t 2 /nobreak >nul
explorer .
echo.
echo Now you can:
echo 1. Select all files (Ctrl+A)
echo 2. Copy them (Ctrl+C)  
echo 3. Go to GitHub web interface
echo 4. Upload via drag-and-drop
echo.
echo ======================================
echo 🎯 Quick Actions
echo ======================================
echo.
echo [1] 🌐 Open GitHub Repository in Browser
echo [2] 📁 Open File Explorer (Current Folder)
echo [3] 📋 Show Priority Files List
echo [4] 🔧 Git Installation Guide
echo [5] ❌ Exit
echo.

set /p choice="Select option (1-5): "

if "%choice%"=="1" goto open_github
if "%choice%"=="2" goto open_explorer
if "%choice%"=="3" goto show_files
if "%choice%"=="4" goto git_guide
if "%choice%"=="5" goto exit

echo Invalid choice! Please select 1-5.
pause
goto menu

:open_github
echo.
echo 🌐 Opening GitHub repository in browser...
start https://github.com/MELLISAEFFENDY/FishingAI
echo.
echo ✅ GitHub repository opened!
echo Now click "Add file" → "Upload files"
pause
goto menu

:open_explorer
echo.
echo 📁 Opening File Explorer...
explorer .
echo.
echo ✅ File Explorer opened!
echo Select all files (Ctrl+A) and copy (Ctrl+C) for easy upload
pause
goto menu

:show_files
echo.
echo ======================================
echo 📋 FILES IN CURRENT FOLDER
echo ======================================
echo.
dir /b
echo.
echo Total files ready for GitHub upload!
pause
goto menu

:git_guide
echo.
echo ======================================
echo 🔧 Git Installation Guide
echo ======================================
echo.
echo Current Status: Git not found in PATH
echo.
echo Installation Steps:
echo 1. Download: https://git-scm.com/download/win
echo 2. Run installer as Administrator
echo 3. IMPORTANT: Check "Add Git to PATH" option
echo 4. Complete installation
echo 5. Restart PowerShell/Command Prompt
echo 6. Test: git --version
echo.
echo Alternative Locations to Check:
echo • C:\Program Files\Git\bin\git.exe
echo • C:\Program Files (x86)\Git\bin\git.exe
echo.
echo If Git is installed but not in PATH:
echo • Add Git bin folder to Windows PATH
echo • Or use full path: "C:\Program Files\Git\bin\git.exe" --version
echo.
pause
goto menu

:menu
goto :eof

:exit
echo.
echo ======================================
echo 👋 GitHub Upload Helper
echo ======================================
echo.
echo Summary:
echo ✅ Use web interface for easiest upload
echo ✅ All files are ready in current folder
echo ✅ GitHub repository: https://github.com/MELLISAEFFENDY/FishingAI
echo ✅ Test URLs will work after upload
echo.
echo 🎯 Next Steps:
echo 1. Go to GitHub repository
echo 2. Upload all files via web interface
echo 3. Test the GitHub Raw URLs in Roblox
echo.
echo Happy coding! 🎣
pause
exit /b 0
