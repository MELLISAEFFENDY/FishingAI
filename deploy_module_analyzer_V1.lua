-- Deploy Module Analyzer with Floating UI
-- GitHub Raw URL: https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/deploy_module_analyzer.lua
-- Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/deploy_module_analyzer.lua"))()
-- Version 3: Made UI Scrollable and fixed layout issues

-- ===================================================================
-- >> KODE BARU: Untuk Merekam Console <<
-- ===================================================================
local original_print = print
local consoleLog = {}

print = function(...)
    -- Buat pesan dari semua argumen yang diberikan ke print()
    local message_parts = {}
    for i = 1, select('#', ...) do
        table.insert(message_parts, tostring(select(i, ...)))
    end
    local message = table.concat(message_parts, "\t")
    
    -- Simpan pesan ke dalam log dengan timestamp
    table.insert(consoleLog, string.format("[%s] %s", os.date("%H:%M:%S"), message))
    
    -- Tetap jalankan fungsi print aslinya agar muncul di console
    return original_print(...)
end
-- ===================================================================

print("📁 Loading ModuleScript Analyzer with Floating UI...")
print("📡 GitHub Deployment System")

-- Check for required services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- Module Analyzer System
local ModuleAnalyzer = {
    foundModules = {},
    loadedModules = {},
    methods = {},
    lastResults = {},
    history = {}
}

-- Notification function
local function Notify(title, message, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration or 3
        })
    end)
    print(string.format("[Module Analyzer] %s: %s", title, message))
end

-- Scan for ModuleScripts
local function scanModuleScripts()
    ModuleAnalyzer.foundModules = {}
    
    print("🔍 Scanning for ModuleScripts...")
    
    if not ReplicatedStorage then 
        print("❌ ReplicatedStorage not found!")
        return 
    end
    
    local function scanContainer(container, path)
        for _, item in pairs(container:GetChildren()) do
            local fullPath = path .. "/" .. item.Name
            
            if item:IsA("ModuleScript") then
                table.insert(ModuleAnalyzer.foundModules, {
                    name = item.Name,
                    path = fullPath,
                    object = item,
                    loaded = false
                })
                print("📁 Found ModuleScript: " .. fullPath)
                
            elseif item:IsA("Folder") then
                pcall(function()
                    scanContainer(item, fullPath)
                end)
            end
        end
    end
    
    scanContainer(ReplicatedStorage, "ReplicatedStorage")
    
    print("📊 ModuleScript scan complete:")
    print("  • Total modules found: " .. #ModuleAnalyzer.foundModules)
    
    Notify("Module Scanner", "Found " .. #ModuleAnalyzer.foundModules .. " ModuleScripts!")
    return ModuleAnalyzer.foundModules
end

-- Load a specific module
local function loadModule(moduleName)
    local targetModule = nil
    local modulePath = ""
    
    for _, m in pairs(ModuleAnalyzer.foundModules) do
        if m.name == moduleName or m.path:find(moduleName) then
            targetModule = m.object
            modulePath = m.path
            break
        end
    end
    
    if not targetModule then
        print("❌ Module '" .. moduleName .. "' not found!")
        Notify("Error", "❌ Module '" .. moduleName .. "' not found!")
        return false, "Module not found"
    end
    
    print("📁 Loading module: " .. modulePath)
    
    local success, result = pcall(function()
        return require(targetModule)
    end)
    
    if success then
        ModuleAnalyzer.loadedModules[moduleName] = result
        print("✅ Module loaded successfully!")
        Notify("Success", "✅ " .. moduleName .. " loaded!")
        
        ModuleAnalyzer.methods[moduleName] = {}
        for key, value in pairs(result) do
            table.insert(ModuleAnalyzer.methods[moduleName], {
                name = key,
                type = type(value),
                value = value
            })
            print("📋 Found: " .. key .. " (" .. type(value) .. ")")
        end
        
        return true, result
    else
        print("❌ Module loading failed!")
        print("💥 Error: " .. tostring(result))
        Notify("Error", "❌ " .. moduleName .. " loading failed!")
        return false, result
    end
end

-- Call a module method
local function callModuleMethod(moduleName, methodName, args)
    if not ModuleAnalyzer.loadedModules[moduleName] then
        print("❌ Module '" .. moduleName .. "' not loaded!")
        Notify("Error", "❌ Module '" .. moduleName .. "' not loaded!")
        return false, "Module not loaded"
    end
    
    local module = ModuleAnalyzer.loadedModules[moduleName]
    local method = module[methodName]
    
    if not method then
        print("❌ Method '" .. methodName .. "' not found!")
        Notify("Error", "❌ Method '" .. methodName .. "' not found!")
        return false, "Method not found"
    end
    
    print("🔧 Calling method: " .. moduleName .. "." .. methodName)
    print("📋 Arguments: " .. tostring(args))
    
    local success, result = pcall(function()
        if type(method) == "function" then
            if args and args ~= "" then
                local parsedArgs = {}
                for arg in string.gmatch(args, "[^,]+") do
                    arg = arg:gsub("^%s*(.-)%s*$", "%1")
                    local num = tonumber(arg)
                    if num then
                        table.insert(parsedArgs, num)
                    elseif arg:lower() == "true" then
                        table.insert(parsedArgs, true)
                    elseif arg:lower() == "false" then
                        table.insert(parsedArgs, false)
                    else
                        table.insert(parsedArgs, arg)
                    end
                end
                return method(unpack(parsedArgs))
            else
                return method()
            end
        else
            return method
        end
    end)
    
    table.insert(ModuleAnalyzer.history, {
        time = os.date("%H:%M:%S"),
        module = moduleName,
        method = methodName,
        args = args or "",
        success = success,
        result = result
    })
    
    if success then
        print("✅ Method executed successfully!")
        print("📤 Result: " .. tostring(result))
        Notify("Success", "✅ " .. methodName .. " executed!")
        return true, result
    else
        print("❌ Method execution failed!")
        print("💥 Error: " .. tostring(result))
        Notify("Error", "❌ " .. methodName .. " failed!")
        return false, result
    end
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModuleAnalyzerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Floating toggle button
local floatingBtn = Instance.new("TextButton")
floatingBtn.Size = UDim2.new(0, 60, 0, 60)
floatingBtn.Position = UDim2.new(0, 20, 0, 180)
floatingBtn.Text = "📁"
floatingBtn.Font = Enum.Font.GothamBold
floatingBtn.TextSize = 24
floatingBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.BorderSizePixel = 0
floatingBtn.ZIndex = 1000
floatingBtn.Parent = screenGui
Instance.new("UICorner", floatingBtn).CornerRadius = UDim.new(0, 30)

-- Floating button shadow
local floatingShadow = Instance.new("Frame")
floatingShadow.Size = UDim2.new(0, 64, 0, 64)
floatingShadow.Position = UDim2.new(0, 18, 0, 182)
floatingShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
floatingShadow.BackgroundTransparency = 0.7
floatingShadow.BorderSizePixel = 0
floatingShadow.ZIndex = 999
floatingShadow.Parent = screenGui
Instance.new("UICorner", floatingShadow).CornerRadius = UDim.new(0, 32)

-- Main panel
local mainPanel = Instance.new("Frame")
mainPanel.Size = UDim2.new(0, 550, 0, 600) -- >> DIUBAH: Tinggi panel dikurangi
mainPanel.Position = UDim2.new(0.5, -275, 0.5, -300) -- >> DIUBAH: Posisi disesuaikan
mainPanel.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false
mainPanel.Parent = screenGui
Instance.new("UICorner", mainPanel).CornerRadius = UDim.new(0, 12)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainPanel
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Text = "📁 ModuleScript Analyzer"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn)

-- >> PERUBAHAN BESAR: Content area diubah menjadi ScrollingFrame <<
local contentArea = Instance.new("ScrollingFrame")
contentArea.Size = UDim2.new(1, -10, 1, -50)
contentArea.Position = UDim2.new(0, 5, 0, 45)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.ScrollBarThickness = 6
contentArea.CanvasSize = UDim2.new(0, 0, 0, 0) -- Akan diatur nanti
contentArea.Parent = mainPanel

-- >> KODE BARU: UIListLayout untuk mengatur semua section secara otomatis <<
local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10) -- Jarak antar section
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentArea

-- Scanner section
local scannerSection = Instance.new("Frame")
scannerSection.Size = UDim2.new(1, 0, 0, 120)
-- scannerSection.Position DIHAPUS, diatur oleh UIListLayout
scannerSection.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
scannerSection.BorderSizePixel = 0
scannerSection.Parent = contentArea
Instance.new("UICorner", scannerSection)

local scanTitle = Instance.new("TextLabel")
scanTitle.Size = UDim2.new(1, -10, 0, 25)
scanTitle.Position = UDim2.new(0, 5, 0, 5)
scanTitle.Text = "📁 Module Scanner"
scanTitle.Font = Enum.Font.GothamBold
scanTitle.TextSize = 14
scanTitle.TextColor3 = Color3.fromRGB(150, 100, 255)
scanTitle.BackgroundTransparency = 1
scanTitle.TextXAlignment = Enum.TextXAlignment.Left
scanTitle.Parent = scannerSection

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0, 200, 0, 35)
scanBtn.Position = UDim2.new(0, 10, 0, 35)
scanBtn.Text = "📁 Scan All Modules"
scanBtn.Font = Enum.Font.GothamBold
scanBtn.TextSize = 12
scanBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Parent = scannerSection
Instance.new("UICorner", scanBtn)

local scanStatus = Instance.new("TextLabel")
scanStatus.Size = UDim2.new(0, 300, 0, 35)
scanStatus.Position = UDim2.new(0, 220, 0, 35)
scanStatus.Text = "Ready to scan..."
scanStatus.Font = Enum.Font.Gotham
scanStatus.TextSize = 11
scanStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
scanStatus.BackgroundTransparency = 1
scanStatus.TextXAlignment = Enum.TextXAlignment.Left
scanStatus.Parent = scannerSection

local saveLogBtn = Instance.new("TextButton")
saveLogBtn.Size = UDim2.new(0, 200, 0, 35)
saveLogBtn.Position = UDim2.new(0, 10, 0, 75)
saveLogBtn.Text = "💾 Save Log to File"
saveLogBtn.Font = Enum.Font.GothamBold
saveLogBtn.TextSize = 12
saveLogBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
saveLogBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveLogBtn.Parent = scannerSection
Instance.new("UICorner", saveLogBtn)

-- Module loader section
local loaderSection = Instance.new("Frame")
loaderSection.Size = UDim2.new(1, 0, 0, 100)
-- loaderSection.Position DIHAPUS
loaderSection.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
loaderSection.BorderSizePixel = 0
loaderSection.Parent = contentArea
Instance.new("UICorner", loaderSection)

local loaderTitle = Instance.new("TextLabel")
loaderTitle.Size = UDim2.new(1, -10, 0, 25)
loaderTitle.Position = UDim2.new(0, 5, 0, 5)
loaderTitle.Text = "📋 Module Loader"
loaderTitle.Font = Enum.Font.GothamBold
loaderTitle.TextSize = 14
loaderTitle.TextColor3 = Color3.fromRGB(150, 100, 255)
loaderTitle.BackgroundTransparency = 1
loaderTitle.TextXAlignment = Enum.TextXAlignment.Left
loaderTitle.Parent = loaderSection

local moduleInput = Instance.new("TextBox")
moduleInput.Size = UDim2.new(1, -240, 0, 25)
moduleInput.Position = UDim2.new(0, 130, 0, 35)
moduleInput.PlaceholderText = "Enter module name (e.g. AutoFishingController)"
moduleInput.Font = Enum.Font.Gotham
moduleInput.TextSize = 10
moduleInput.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
moduleInput.TextColor3 = Color3.fromRGB(255, 255, 255)
moduleInput.BorderSizePixel = 0
moduleInput.Parent = loaderSection
Instance.new("UICorner", moduleInput)

local moduleLabel = Instance.new("TextLabel")
moduleLabel.Size = UDim2.new(0, 120, 0, 25)
moduleLabel.Position = UDim2.new(0, 10, 0, 35)
moduleLabel.Text = "Module Name:"
moduleLabel.Font = Enum.Font.GothamSemibold
moduleLabel.TextSize = 11
moduleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
moduleLabel.BackgroundTransparency = 1
moduleLabel.TextXAlignment = Enum.TextXAlignment.Left
moduleLabel.Parent = loaderSection

local loadBtn = Instance.new("TextButton")
loadBtn.Size = UDim2.new(0, 100, 0, 25)
loadBtn.Position = UDim2.new(1, -105, 0, 35)
loadBtn.Text = "📁 LOAD"
loadBtn.Font = Enum.Font.GothamBold
loadBtn.TextSize = 10
loadBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadBtn.Parent = loaderSection
Instance.new("UICorner", loadBtn)

local autoFishBtn = Instance.new("TextButton")
autoFishBtn.Size = UDim2.new(0, 150, 0, 25)
autoFishBtn.Position = UDim2.new(0, 10, 0, 70)
autoFishBtn.Text = "🎣 AutoFishingController"
autoFishBtn.Font = Enum.Font.GothamSemibold
autoFishBtn.TextSize = 9
autoFishBtn.BackgroundColor3 = Color3.fromRGB(70, 170, 90)
autoFishBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFishBtn.Parent = loaderSection
Instance.new("UICorner", autoFishBtn)

local fishingBtn = Instance.new("TextButton")
fishingBtn.Size = UDim2.new(0, 120, 0, 25)
fishingBtn.Position = UDim2.new(0, 170, 0, 70)
fishingBtn.Text = "🎣 FishingController"
fishingBtn.Font = Enum.Font.GothamSemibold
fishingBtn.TextSize = 9
fishingBtn.BackgroundColor3 = Color3.fromRGB(70, 170, 90)
fishingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fishingBtn.Parent = loaderSection
Instance.new("UICorner", fishingBtn)

local baitsBtn = Instance.new("TextButton")
baitsBtn.Size = UDim2.new(0, 80, 0, 25)
baitsBtn.Position = UDim2.new(0, 300, 0, 70)
baitsBtn.Text = "🎣 Baits"
baitsBtn.Font = Enum.Font.GothamSemibold
baitsBtn.TextSize = 9
baitsBtn.BackgroundColor3 = Color3.fromRGB(70, 170, 90)
baitsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
baitsBtn.Parent = loaderSection
Instance.new("UICorner", baitsBtn)

-- Method executor section
local executorSection = Instance.new("Frame")
executorSection.Size = UDim2.new(1, 0, 0, 120)
-- executorSection.Position DIHAPUS
executorSection.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
executorSection.BorderSizePixel = 0
executorSection.Parent = contentArea
Instance.new("UICorner", executorSection)

local execTitle = Instance.new("TextLabel")
execTitle.Size = UDim2.new(1, -10, 0, 25)
execTitle.Position = UDim2.new(0, 5, 0, 5)
execTitle.Text = "🔧 Method Executor"
execTitle.Font = Enum.Font.GothamBold
execTitle.TextSize = 14
execTitle.TextColor3 = Color3.fromRGB(150, 100, 255)
execTitle.BackgroundTransparency = 1
execTitle.TextXAlignment = Enum.TextXAlignment.Left
execTitle.Parent = executorSection

local methodInput = Instance.new("TextBox")
methodInput.Size = UDim2.new(1, -290, 0, 25)
methodInput.Position = UDim2.new(0, 130, 0, 35)
methodInput.PlaceholderText = "Enter method name"
methodInput.Font = Enum.Font.Gotham
methodInput.TextSize = 10
methodInput.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
methodInput.TextColor3 = Color3.fromRGB(255, 255, 255)
methodInput.BorderSizePixel = 0
methodInput.Parent = executorSection
Instance.new("UICorner", methodInput)

local methodLabel = Instance.new("TextLabel")
methodLabel.Size = UDim2.new(0, 120, 0, 25)
methodLabel.Position = UDim2.new(0, 10, 0, 35)
methodLabel.Text = "Method Name:"
methodLabel.Font = Enum.Font.GothamSemibold
methodLabel.TextSize = 11
methodLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
methodLabel.BackgroundTransparency = 1
methodLabel.TextXAlignment = Enum.TextXAlignment.Left
methodLabel.Parent = executorSection

local argsInput = Instance.new("TextBox")
argsInput.Size = UDim2.new(1, -290, 0, 25)
argsInput.Position = UDim2.new(0, 130, 0, 70)
argsInput.PlaceholderText = "Arguments (e.g. arg1, 123, true)"
argsInput.Font = Enum.Font.Gotham
argsInput.TextSize = 10
argsInput.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
argsInput.TextColor3 = Color3.fromRGB(255, 255, 255)
argsInput.BorderSizePixel = 0
argsInput.Parent = executorSection
Instance.new("UICorner", argsInput)

local argsLabel = Instance.new("TextLabel")
argsLabel.Size = UDim2.new(0, 120, 0, 25)
argsLabel.Position = UDim2.new(0, 10, 0, 70)
argsLabel.Text = "Arguments:"
argsLabel.Font = Enum.Font.GothamSemibold
argsLabel.TextSize = 11
argsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
argsLabel.BackgroundTransparency = 1
argsLabel.TextXAlignment = Enum.TextXAlignment.Left
argsLabel.Parent = executorSection

local executeBtn = Instance.new("TextButton")
executeBtn.Size = UDim2.new(0, 150, 0, 60)
executeBtn.Position = UDim2.new(1, -155, 0, 35)
executeBtn.Text = "🔧 EXECUTE"
executeBtn.Font = Enum.Font.GothamBold
executeBtn.TextSize = 11
executeBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
executeBtn.Parent = executorSection
Instance.new("UICorner", executeBtn)

-- Methods display section
local methodsSection = Instance.new("Frame")
methodsSection.Size = UDim2.new(1, 0, 0, 150)
-- methodsSection.Position DIHAPUS
methodsSection.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
methodsSection.BorderSizePixel = 0
methodsSection.Parent = contentArea
Instance.new("UICorner", methodsSection)

local methodsTitle = Instance.new("TextLabel")
methodsTitle.Size = UDim2.new(1, -10, 0, 25)
methodsTitle.Position = UDim2.new(0, 5, 0, 5)
methodsTitle.Text = "📊 Methods & Properties"
methodsTitle.Font = Enum.Font.GothamBold
methodsTitle.TextSize = 14
methodsTitle.TextColor3 = Color3.fromRGB(150, 100, 255)
methodsTitle.BackgroundTransparency = 1
methodsTitle.TextXAlignment = Enum.TextXAlignment.Left
methodsTitle.Parent = methodsSection

local methodsFrame = Instance.new("ScrollingFrame")
methodsFrame.Size = UDim2.new(1, -20, 1, -40)
methodsFrame.Position = UDim2.new(0, 10, 0, 30)
methodsFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
methodsFrame.BorderSizePixel = 0
methodsFrame.ScrollBarThickness = 8
methodsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
methodsFrame.Parent = methodsSection
Instance.new("UICorner", methodsFrame)

local methodsText = Instance.new("TextLabel")
methodsText.Size = UDim2.new(1, 0, 0, 0) -- Size Y akan diatur otomatis
methodsText.AutomaticSize = Enum.AutomaticSize.Y
methodsText.Text = "No module loaded yet..."
methodsText.Font = Enum.Font.Gotham
methodsText.TextSize = 9
methodsText.TextColor3 = Color3.fromRGB(200, 200, 200)
methodsText.BackgroundTransparency = 1
methodsText.TextXAlignment = Enum.TextXAlignment.Left
methodsText.TextYAlignment = Enum.TextYAlignment.Top
methodsText.TextWrapped = true
methodsText.Parent = methodsFrame

-- History section
local historySection = Instance.new("Frame")
historySection.Size = UDim2.new(1, 0, 0, 100)
-- historySection.Position DIHAPUS
historySection.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
historySection.BorderSizePixel = 0
historySection.Parent = contentArea
Instance.new("UICorner", historySection)

local historyTitle = Instance.new("TextLabel")
historyTitle.Size = UDim2.new(1, -10, 0, 25)
historyTitle.Position = UDim2.new(0, 5, 0, 5)
historyTitle.Text = "📋 Execution History"
historyTitle.Font = Enum.Font.GothamBold
historyTitle.TextSize = 14
historyTitle.TextColor3 = Color3.fromRGB(150, 100, 255)
historyTitle.BackgroundTransparency = 1
historyTitle.TextXAlignment = Enum.TextXAlignment.Left
historyTitle.Parent = historySection

local historyFrame = Instance.new("ScrollingFrame")
historyFrame.Size = UDim2.new(1, -120, 1, -40)
historyFrame.Position = UDim2.new(0, 10, 0, 30)
historyFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
historyFrame.BorderSizePixel = 0
historyFrame.ScrollBarThickness = 8
historyFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
historyFrame.Parent = historySection
Instance.new("UICorner", historyFrame)

local historyLayout = Instance.new("UIListLayout")
historyLayout.Parent = historyFrame
historyLayout.SortOrder = Enum.SortOrder.LayoutOrder
historyLayout.Padding = UDim.new(0, 2)

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0, 100, 0, 60)
saveBtn.Position = UDim2.new(1, -110, 0, 30)
saveBtn.Text = "💾 Save Result"
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 12
saveBtn.BackgroundColor3 = Color3.fromRGB(70, 170, 90)
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Parent = historySection
Instance.new("UICorner", saveBtn)

-- >> KODE BARU: Fungsi untuk update ukuran canvas scroll utama <<
local function updateMainCanvasSize()
    task.wait() -- Tunggu 1 frame agar ukuran konten ter-update
    contentArea.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y)
end

-- Panggil fungsi ini setelah semua UI dibuat
updateMainCanvasSize()

saveBtn.MouseButton1Click:Connect(function()
    local lines = {}
    for _, entry in ipairs(ModuleAnalyzer.history) do
        local status = entry.success and "✅" or "❌"
        local line = string.format("[%s] %s %s.%s → %s", entry.time, status, entry.module, entry.method, tostring(entry.result))
        table.insert(lines, line)
    end
    local resultText = #lines > 0 and table.concat(lines, "\n") or "No executions yet..."
    local success, err = pcall(function()
        writefile("ModuleAnalyzer_Result.txt", resultText)
    end)
    if success then
        Notify("Save Result", "💾 Result saved to ModuleAnalyzer_Result.txt!")
    else
        Notify("Save Result", "❌ Failed to save result! " .. tostring(err))
    end
end)

local function updateMethods(moduleName)
    if not ModuleAnalyzer.methods[moduleName] then
        methodsText.Text = "No methods found for " .. moduleName
        return
    end
    
    local methodLines = {}
    for _, method in pairs(ModuleAnalyzer.methods[moduleName]) do
        local line = string.format("• %s (%s)", method.name, method.type)
        table.insert(methodLines, line)
    end
    
    methodsText.Text = #methodLines > 0 and table.concat(methodLines, "\n") or "No methods found for " .. moduleName
    
    task.wait()
    methodsFrame.CanvasSize = UDim2.new(0, 0, 0, methodsText.AbsoluteSize.Y)
end

local function updateHistory()
    for _, child in ipairs(historyFrame:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UICorner") then
            child:Destroy()
        end
    end

    if #ModuleAnalyzer.history == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 0, 18)
        emptyLabel.Text = "No executions yet..."
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 9
        emptyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.TextXAlignment = Enum.TextXAlignment.Left
        emptyLabel.Parent = historyFrame
    else
        for i = math.max(1, #ModuleAnalyzer.history - 20), #ModuleAnalyzer.history do
            local entry = ModuleAnalyzer.history[i]
            if entry then
                local status = entry.success and "✅" or "❌"
                local line = string.format("[%s] %s.%s → %s", entry.time, entry.module, entry.method, tostring(entry.result))
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 18)
                label.Text = line
                label.Font = Enum.Font.Gotham
                label.TextSize = 9
                label.TextColor3 = entry.success and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(255, 120, 120)
                label.BackgroundTransparency = 1
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = historyFrame
            end
        end
    end
    task.wait()
    historyFrame.CanvasSize = UDim2.new(0, 0, 0, historyLayout.AbsoluteContentSize.Y)
end

-- Button handlers
scanBtn.MouseButton1Click:Connect(function()
    scanBtn.Text = "📁 Scanning..."
    scanBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    scanStatus.Text = "Scanning modules..."
    
    task.spawn(function()
        local modules = scanModuleScripts()
        task.wait(1)
        scanBtn.Text = "📁 Scan All Modules"
        scanBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
        scanStatus.Text = "Found " .. #modules .. " modules"
    end)
end)

saveLogBtn.MouseButton1Click:Connect(function()
    if #consoleLog == 0 then
        Notify("Save Log", "⚠️ Log console masih kosong!", 4)
        return
    end

    local logContent = table.concat(consoleLog, "\n")
    local fileName = "ModuleAnalyzer_ConsoleLog.txt"

    local success, err = pcall(function()
        writefile(fileName, logContent)
    end)

    if success then
        Notify("Save Log", "💾 Log berhasil disimpan ke " .. fileName, 5)
    else
        Notify("Save Log", "❌ Gagal menyimpan log! " .. tostring(err), 5)
    end
end)

loadBtn.MouseButton1Click:Connect(function()
    local moduleName = moduleInput.Text
    if moduleName == "" then
        Notify("Error", "❌ Please enter a module name!")
        return
    end
    
    loadBtn.Text = "📁 LOADING..."
    loadBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    task.spawn(function()
        local success = loadModule(moduleName)
        task.wait(0.5)
        loadBtn.Text = "📁 LOAD"
        loadBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
        if success then
            updateMethods(moduleName)
        end
    end)
end)

executeBtn.MouseButton1Click:Connect(function()
    local moduleName = moduleInput.Text
    local methodName = methodInput.Text
    local args = argsInput.Text
    
    if moduleName == "" or methodName == "" then
        Notify("Error", "❌ Please enter module and method names!")
        return
    end
    
    executeBtn.Text = "🔧 EXECUTING..."
    executeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    task.spawn(function()
        callModuleMethod(moduleName, methodName, args)
        task.wait(0.5)
        executeBtn.Text = "🔧 EXECUTE"
        executeBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
        updateHistory()
    end)
end)

autoFishBtn.MouseButton1Click:Connect(function()
    moduleInput.Text = "AutoFishingController"
    loadModule("AutoFishingController")
    updateMethods("AutoFishingController")
end)

fishingBtn.MouseButton1Click:Connect(function()
    moduleInput.Text = "FishingController"
    loadModule("FishingController")
    updateMethods("FishingController")
end)

baitsBtn.MouseButton1Click:Connect(function()
    moduleInput.Text = "Baits"
    loadModule("Baits")
    updateMethods("Baits")
end)

closeBtn.MouseButton1Click:Connect(function()
    mainPanel.Visible = false
    print("📁 Module Analyzer UI hidden")
end)

local isUIVisible = false
floatingBtn.MouseButton1Click:Connect(function()
    isUIVisible = not isUIVisible
    mainPanel.Visible = isUIVisible
    
    if isUIVisible then
        floatingBtn.BackgroundColor3 = Color3.fromRGB(70, 170, 90)
        print("📁 Module Analyzer UI shown")
        Notify("Module Analyzer", "📁 UI opened!")
        updateMainCanvasSize() -- Update canvas size saat UI dibuka
    else
        floatingBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
        print("📁 Module Analyzer UI hidden")
        Notify("Module Analyzer", "📁 UI hidden!")
    end
end)

local floatingDragging = false
local floatingDragInput, floatingMousePos, floatingFramePos
floatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        floatingDragging = true
        floatingMousePos = input.Position
        floatingFramePos = floatingBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                floatingDragging = false
            end
        end)
    end
end)
floatingBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        floatingDragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == floatingDragInput and floatingDragging then
        local delta = input.Position - floatingMousePos
        local newPos = UDim2.new(floatingFramePos.X.Scale, floatingFramePos.X.Offset + delta.X, floatingFramePos.Y.Scale, floatingFramePos.Y.Offset + delta.Y)
        floatingBtn.Position = newPos
        floatingShadow.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset - 2, newPos.Y.Scale, newPos.Y.Offset + 2)
    end
end)

local dragging = false
local dragInput, mousePos, framePos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainPanel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        mainPanel.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- Initial setup
print("📁 ModuleScript Analyzer loaded!")
Notify("Module Analyzer", "📁 Module Analyzer loaded! Click floating button to open UI.")

task.spawn(function()
    task.wait(2)
    scanModuleScripts()
    if scanStatus then
        scanStatus.Text = "Found " .. #ModuleAnalyzer.foundModules .. " modules"
    end
end)
