@echo off
echo 🔑 GitHub SSH Setup and Upload Helper
echo ======================================
echo.
echo Repository: https://github.com/MELLISAEFFENDY/FishingAI
echo SSH URL: git@github.com:MELLISAEFFENDY/FishingAI.git
echo.

:menu
echo ======================================
echo 🚀 GitHub SSH Upload Options
echo ======================================
echo.
echo [1] 🔑 Setup SSH Key (if not exists)
echo [2] 🔗 Test SSH Connection to GitHub
echo [3] 📤 Upload via SSH (Quick)
echo [4] 🔄 Upload via SSH (Full setup)
echo [5] 📋 Manual SSH Commands
echo [6] 🌐 Alternative: GitHub Desktop
echo [7] 📁 Web Upload Instructions
echo [8] ❌ Exit
echo.

set /p choice="Select option (1-8): "

if "%choice%"=="1" goto setup_ssh
if "%choice%"=="2" goto test_ssh
if "%choice%"=="3" goto upload_quick
if "%choice%"=="4" goto upload_full
if "%choice%"=="5" goto manual_commands
if "%choice%"=="6" goto github_desktop
if "%choice%"=="7" goto web_upload
if "%choice%"=="8" goto exit

echo Invalid choice! Please select 1-8.
goto menu

:setup_ssh
echo.
echo 🔑 SSH Key Setup for GitHub
echo ======================================
echo.
echo 1. Generate SSH Key:
echo    ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
echo.
echo 2. Start SSH Agent:
echo    eval "$(ssh-agent -s)"
echo.
echo 3. Add SSH Key:
echo    ssh-add ~/.ssh/id_rsa
echo.
echo 4. Copy Public Key:
echo    cat ~/.ssh/id_rsa.pub
echo.
echo 5. Add to GitHub:
echo    • Go to GitHub.com → Settings → SSH and GPG keys
echo    • Click "New SSH key"
echo    • Paste your public key
echo    • Click "Add SSH key"
echo.
echo ⚠️  Note: Jalankan command di atas di Git Bash atau PowerShell
echo.
pause
goto menu

:test_ssh
echo.
echo 🔗 Testing SSH Connection to GitHub
echo ======================================
echo.
echo Command to test:
echo ssh -T git@github.com
echo.
echo Expected response:
echo "Hi MELLISAEFFENDY! You've successfully authenticated..."
echo.
echo Jika berhasil, SSH sudah siap untuk upload!
echo.
pause
goto menu

:upload_quick
echo.
echo 📤 Quick SSH Upload (Existing Repository)
echo ======================================
echo.
echo Assuming SSH key already setup and repository exists...
echo.
echo cd /d "c:\Users\Administrator\fishit"
echo git init
echo git remote add origin git@github.com:MELLISAEFFENDY/FishingAI.git
echo git add .
echo git commit -m "🎣 Complete FishingAI toolset with floating UI"
echo git branch -M main
echo git push -u origin main
echo.
echo 🔄 Executing commands...
echo.

cd /d "c:\Users\Administrator\fishit"

REM Check if git is available
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git not found in PATH
    echo 💡 Silakan install Git atau gunakan Git Bash
    echo 🔗 Download: https://git-scm.com/download/win
    pause
    goto menu
)

echo ✅ Git found, proceeding with SSH upload...
echo.

git init
git remote remove origin 2>nul
git remote add origin git@github.com:MELLISAEFFENDY/FishingAI.git
git add .
git commit -m "🎣 Complete FishingAI toolset with floating UI - Features: Floating UI Remote Tester, Module Analyzer, Optimized AutoFish scripts, Complete documentation, Analysis tools for 80 RemoteEvents + 452 game objects"
git branch -M main
git push -u origin main

if %errorlevel% equ 0 (
    echo ✅ Upload berhasil!
    echo 🎯 Repository URL: https://github.com/MELLISAEFFENDY/FishingAI
    echo.
    echo 🎮 Test GitHub Raw URLs:
    echo loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_remote_tester.lua"))()
    echo loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_module_analyzer.lua"))()
) else (
    echo ❌ Upload gagal!
    echo 💡 Coba setup SSH key dulu atau gunakan Web Upload
)

pause
goto menu

:upload_full
echo.
echo 🔄 Full SSH Setup and Upload
echo ======================================
echo.
echo This will do complete setup:
echo 1. Initialize Git repository
echo 2. Setup SSH remote
echo 3. Add all files
echo 4. Commit and push
echo.
echo ⚠️  Pastikan SSH key sudah di-setup di GitHub!
echo.

set /p confirm="Continue? (y/n): "
if /i not "%confirm%"=="y" goto menu

echo.
echo 🔧 Starting full setup...
echo.

cd /d "c:\Users\Administrator\fishit"

REM Remove existing git if any
if exist ".git" (
    echo 🧹 Cleaning existing git repository...
    rmdir /s /q ".git"
)

echo 📁 Initializing new repository...
git init

echo 🔗 Adding SSH remote...
git remote add origin git@github.com:MELLISAEFFENDY/FishingAI.git

echo 📝 Adding all files...
git add .

echo 💾 Creating commit...
git commit -m "🎣 Complete FishingAI toolset with floating UI

✨ Features:
- Floating UI Remote Tester with 🔧 button
- Floating UI Module Analyzer with 📁 button  
- Optimized AutoFish scripts for Fish It
- Complete GitHub deployment system
- Comprehensive documentation and guides
- Analysis tools for 80 RemoteEvents + 452 game objects

🎯 Ready for GitHub Raw URL deployment:
- deploy_remote_tester.lua
- deploy_module_analyzer.lua
- autofish_fishit_optimized.lua

📚 Includes complete guides and helper tools for easy setup and usage."

echo 🌿 Setting main branch...
git branch -M main

echo 🚀 Pushing to GitHub via SSH...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ✅ SUCCESS! Repository uploaded via SSH
    echo 🎯 Repository: https://github.com/MELLISAEFFENDY/FishingAI
    echo.
    echo 🎮 Your GitHub Raw URLs are ready:
    echo.
    echo Remote Tester:
    echo loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_remote_tester.lua"))()
    echo.
    echo Module Analyzer:
    echo loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_module_analyzer.lua"))()
    echo.
    echo AutoFish Optimized:
    echo loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/autofish_fishit_optimized.lua"))()
) else (
    echo.
    echo ❌ Upload failed!
    echo.
    echo 🔑 Possible issues:
    echo   • SSH key not setup in GitHub
    echo   • Repository doesn't exist
    echo   • Permission denied
    echo.
    echo 💡 Solutions:
    echo   1. Setup SSH key first (option 1)
    echo   2. Test SSH connection (option 2)
    echo   3. Use Web Upload instead (option 7)
)

pause
goto menu

:manual_commands
echo.
echo 📋 Manual SSH Commands for Copy-Paste
echo ======================================
echo.
echo 1. Open Git Bash or PowerShell as Administrator
echo.
echo 2. Navigate to folder:
echo cd "c:\Users\Administrator\fishit"
echo.
echo 3. Initialize and setup:
echo git init
echo git remote add origin git@github.com:MELLISAEFFENDY/FishingAI.git
echo.
echo 4. Add and commit:
echo git add .
echo git commit -m "Complete FishingAI toolset with floating UI"
echo.
echo 5. Push to GitHub:
echo git branch -M main
echo git push -u origin main
echo.
echo 🔑 SSH Key Setup (if needed):
echo ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
echo ssh-add ~/.ssh/id_rsa
echo cat ~/.ssh/id_rsa.pub
echo.
echo 🔗 Test SSH:
echo ssh -T git@github.com
echo.
pause
goto menu

:github_desktop
echo.
echo 📱 GitHub Desktop Alternative
echo ======================================
echo.
echo GitHub Desktop adalah GUI yang mudah digunakan:
echo.
echo 1. Download GitHub Desktop:
echo    https://desktop.github.com/
echo.
echo 2. Install dan login dengan akun GitHub
echo.
echo 3. Clone repository:
echo    • File → Clone Repository
echo    • URL: https://github.com/MELLISAEFFENDY/FishingAI
echo    • Local path: pilih folder kosong
echo.
echo 4. Copy files:
echo    • Copy semua file dari c:\Users\Administrator\fishit
echo    • Paste ke folder repository yang di-clone
echo.
echo 5. Commit and Push:
echo    • Buka GitHub Desktop
echo    • Review changes
echo    • Add commit message
echo    • Click "Commit to main"
echo    • Click "Push origin"
echo.
echo ✅ Cara ini paling mudah tanpa command line!
echo.
pause
goto menu

:web_upload
echo.
echo 🌐 Web Upload Instructions (Easiest Method)
echo ======================================
echo.
echo Cara termudah tanpa Git atau SSH:
echo.
echo 1. Buka browser ke:
echo    https://github.com/MELLISAEFFENDY/FishingAI
echo.
echo 2. Click "Add file" → "Upload files"
echo.
echo 3. Drag and drop ALL files dari:
echo    c:\Users\Administrator\fishit
echo.
echo 4. Add commit message:
echo    "Complete FishingAI toolset with floating UI"
echo.
echo 5. Click "Commit changes"
echo.
echo ✅ Selesai! Files akan langsung tersedia di GitHub
echo.
echo 🎯 Setelah upload, test dengan:
echo loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_remote_tester.lua"))()
echo.
echo 💡 Method ini:
echo   ✅ Tidak perlu Git install
echo   ✅ Tidak perlu SSH setup
echo   ✅ Langsung dari browser
echo   ✅ Paling mudah dan aman
echo.
pause
goto menu

:exit
echo.
echo 👋 GitHub SSH Upload Helper
echo ======================================
echo.
echo 🎯 Summary Options:
echo   1. SSH Upload (fastest for developers)
echo   2. GitHub Desktop (GUI friendly)
echo   3. Web Upload (easiest, no setup)
echo.
echo 🔑 SSH Benefits:
echo   • Faster uploads
echo   • No file size limits
echo   • Command line control
echo   • Professional workflow
echo.
echo 🌐 Web Upload Benefits:
echo   • No setup required
echo   • Works anywhere
echo   • Visual interface
echo   • Beginner friendly
echo.
echo 🎮 After any upload method, your tools will be available at:
echo https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/
echo.
echo Happy coding! 🚀
pause
exit /b 0
