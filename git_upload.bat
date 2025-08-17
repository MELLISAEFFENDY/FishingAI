@echo off
echo 🚀 FishingAI Repository Upload Script
echo ======================================
echo.

echo 📁 Current directory: %CD%
echo 📊 Uploading to: https://github.com/MELLISAEFFENDY/FishingAI
echo.

REM Check if git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git is not installed. Please install Git first.
    echo 🔗 Download from: https://git-scm.com/download/win
    pause
    exit /b 1
)

echo ✅ Git is installed
echo.

REM Navigate to workspace
cd /d "c:\Users\Administrator\fishit"

echo 🔧 Initializing Git repository...
git init

echo 🔗 Adding remote origin...
git remote add origin https://github.com/MELLISAEFFENDY/FishingAI.git

echo 📝 Adding all files...
git add .

echo 📋 Git status:
git status

echo.
echo 💾 Committing changes...
git commit -m "🎣 Complete FishingAI toolset with floating UI - ✨ Features: Floating UI Remote Tester with 🔧 button, Floating UI Module Analyzer with 📁 button, Optimized AutoFish scripts for Fish It, Complete GitHub deployment system, Comprehensive documentation and guides, Analysis tools for 80 RemoteEvents + 452 game objects - 🎯 Ready for GitHub Raw URL deployment: deploy_remote_tester.lua, deploy_module_analyzer.lua, autofish_fishit_optimized.lua - 📚 Includes complete guides and helper tools"

echo.
echo 🚀 Pushing to GitHub...
echo ⚠️  You may need to enter your GitHub credentials
git push -u origin main

echo.
echo ✅ Upload complete!
echo.
echo 🎯 Your GitHub Raw URLs:
echo Remote Tester: https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_remote_tester.lua
echo Module Analyzer: https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_module_analyzer.lua
echo AutoFish Optimized: https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/autofish_fishit_optimized.lua
echo.
echo 🎮 Test in Roblox with:
echo loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_remote_tester.lua"))()
echo.
pause
