#!/bin/bash
# Git commands for uploading FishingAI repository

echo "🚀 FishingAI Repository Upload Script"
echo "======================================"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

# Navigate to workspace
cd "c:\Users\Administrator\fishit"

echo "📁 Current directory: $(pwd)"
echo "📊 Files to upload:"
ls -la

echo ""
echo "🔧 Initializing Git repository..."

# Initialize git repository
git init

# Add remote origin
echo "🔗 Adding remote origin..."
git remote add origin https://github.com/MELLISAEFFENDY/FishingAI.git

# Add all files
echo "📝 Adding all files..."
git add .

# Check status
echo "📋 Git status:"
git status

# Commit changes
echo "💾 Committing changes..."
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

# Push to GitHub
echo "🚀 Pushing to GitHub..."
echo "⚠️  You may need to enter your GitHub credentials"
git push -u origin main

echo ""
echo "✅ Upload complete!"
echo ""
echo "🎯 Your GitHub Raw URLs:"
echo "Remote Tester: https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_remote_tester.lua"
echo "Module Analyzer: https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_module_analyzer.lua"
echo "AutoFish Optimized: https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/autofish_fishit_optimized.lua"
echo ""
echo "🎮 Test in Roblox with:"
echo 'loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/FishingAI/main/deploy_remote_tester.lua"))()'
