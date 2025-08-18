-- Deploy Remote Tester with Floating UI
-- GitHub Raw URL: https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/deploy_remote_tester.lua
-- Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/deploy_remote_tester.lua"))()
-- Version 2.2: Fixed remote scanning logic

-- ===================================================================
-- >> KODE BARU: Untuk Merekam Console <<
-- ===================================================================
local original_print = print
local consoleLog = {}

print = function(...)
    local message_parts = {}
    for i = 1, select('#', ...) do
        table.insert(message_parts, tostring(select(i, ...)))
    end
    local message = table.concat(message_parts, "\t")
    table.insert(consoleLog, string.format("[%s] %s", os.date("%H:%M:%S"), message))
    return original_print(...)
end
-- ===================================================================

print("🔧 Loading Remote Event/Function Tester with Floating UI...")
print("📡 GitHub Deployment System")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- System
local RemoteTester = {
    foundRemotes = {},
    history = {},
    isScanning = false
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
    print(string.format("[Remote Tester] %s: %s", title, message))
end

-- Scan for remotes
local function scanAllRemotes()
    RemoteTester.isScanning = true
    RemoteTester.foundRemotes = {}
    print("🔍 Scanning for all RemoteEvents and RemoteFunctions...")
    
    local function scanContainer(container, path)
        for _, item in pairs(container:GetChildren()) do
            local fullPath = path .. "/" .. item.Name
            if item:IsA("RemoteEvent") then
                table.insert(RemoteTester.foundRemotes, { name = item.Name, type = "RemoteEvent", path = fullPath, object = item })
                print("📡 Found RemoteEvent: " .. fullPath)
            elseif item:IsA("RemoteFunction") then
                table.insert(RemoteTester.foundRemotes, { name = item.Name, type = "RemoteFunction", path = fullPath, object = item })
                print("🔧 Found RemoteFunction: " .. fullPath)
            -- >> PERBAIKAN: Menambahkan pengecekan untuk ModuleScript <<
            elseif item:IsA("Folder") or item:IsA("ModuleScript") then
                pcall(function() scanContainer(item, fullPath) end)
            end
        end
    end
    
    scanContainer(ReplicatedStorage, "ReplicatedStorage")
    pcall(function() scanContainer(game.Workspace, "Workspace") end)
    
    RemoteTester.isScanning = false
    print("📊 Remote scan complete. Found " .. #RemoteTester.foundRemotes .. " remotes.")
    Notify("Remote Scanner", "Found " .. #RemoteTester.foundRemotes .. " remotes!")
    return RemoteTester.foundRemotes
end

-- Execute remote
local function executeRemote(remoteName, args)
    local remoteInfo = nil
    for _, r in pairs(RemoteTester.foundRemotes) do
        if r.name == remoteName or r.path:find(remoteName) then
            remoteInfo = r
            break
        end
    end
    
    if not remoteInfo then
        Notify("Error", "❌ Remote '" .. remoteName .. "' not found!")
        return false, "Remote not found"
    end
    
    print("🚀 Executing remote: " .. remoteInfo.path)
    print("📋 Arguments: " .. tostring(args))
    
    local parsedArgs = {}
    if args and args ~= "" then
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
    end
    
    local success, result = pcall(function()
        if remoteInfo.type == "RemoteEvent" then
            remoteInfo.object:FireServer(unpack(parsedArgs))
            return "Event fired successfully"
        elseif remoteInfo.type == "RemoteFunction" then
            return remoteInfo.object:InvokeServer(unpack(parsedArgs))
        end
    end)
    
    table.insert(RemoteTester.history, {
        time = os.date("%H:%M:%S"),
        remote = remoteInfo.path,
        args = args or "",
        success = success,
        result = result
    })
    
    if success then
        print("✅ Remote executed successfully! Result: " .. tostring(result))
        Notify("Success", "✅ " .. remoteName .. " executed!")
    else
        print("❌ Remote execution failed! Error: " .. tostring(result))
        Notify("Error", "❌ " .. remoteName .. " failed!")
    end
    return success, result
end

-- Create GUI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "RemoteTesterUI"
screenGui.ResetOnSpawn = false

local floatingBtn = Instance.new("TextButton", screenGui)
floatingBtn.Size = UDim2.new(0, 60, 0, 60)
floatingBtn.Position = UDim2.new(0, 20, 0, 100)
floatingBtn.Text = "🔧"
floatingBtn.Font = Enum.Font.GothamBold
floatingBtn.TextSize = 24
floatingBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 150)
floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.ZIndex = 1000
Instance.new("UICorner", floatingBtn).CornerRadius = UDim.new(0, 30)

local floatingShadow = Instance.new("Frame", screenGui)
floatingShadow.Size = UDim2.new(0, 64, 0, 64)
floatingShadow.Position = UDim2.new(0, 18, 0, 102)
floatingShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
floatingShadow.BackgroundTransparency = 0.7
floatingShadow.ZIndex = 999
Instance.new("UICorner", floatingShadow).CornerRadius = UDim.new(0, 32)

local mainPanel = Instance.new("Frame", screenGui)
mainPanel.Size = UDim2.new(0, 500, 0, 550)
mainPanel.Position = UDim2.new(0.5, -250, 0.5, -275)
mainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainPanel.Visible = false
Instance.new("UICorner", mainPanel).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame", mainPanel)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(200, 50, 150)
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Text = "🔧 Remote Tester"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn)

local contentArea = Instance.new("ScrollingFrame", mainPanel)
contentArea.Size = UDim2.new(1, -10, 1, -50)
contentArea.Position = UDim2.new(0, 5, 0, 45)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.ScrollBarThickness = 6
contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)

local contentLayout = Instance.new("UIListLayout", contentArea)
contentLayout.Padding = UDim.new(0, 10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Scanner section
local scannerSection = Instance.new("Frame", contentArea)
scannerSection.Size = UDim2.new(1, 0, 0, 120)
scannerSection.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", scannerSection)

local scanTitle = Instance.new("TextLabel", scannerSection)
scanTitle.Size = UDim2.new(1, -10, 0, 25)
scanTitle.Position = UDim2.new(0, 5, 0, 5)
scanTitle.Text = "📡 Remote Scanner"
scanTitle.Font = Enum.Font.GothamBold
scanTitle.TextSize = 14
scanTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
scanTitle.BackgroundTransparency = 1
scanTitle.TextXAlignment = Enum.TextXAlignment.Left

local scanBtn = Instance.new("TextButton", scannerSection)
scanBtn.Size = UDim2.new(0, 200, 0, 35)
scanBtn.Position = UDim2.new(0, 10, 0, 35)
scanBtn.Text = "🔍 Scan All Remotes"
scanBtn.Font = Enum.Font.GothamBold
scanBtn.TextSize = 12
scanBtn.BackgroundColor3 = Color3.fromRGB(70, 170, 90)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", scanBtn)

local scanStatus = Instance.new("TextLabel", scannerSection)
scanStatus.Size = UDim2.new(1, -230, 0, 35)
scanStatus.Position = UDim2.new(0, 220, 0, 35)
scanStatus.Text = "Ready to scan..."
scanStatus.Font = Enum.Font.Gotham
scanStatus.TextSize = 11
scanStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
scanStatus.BackgroundTransparency = 1
scanStatus.TextXAlignment = Enum.TextXAlignment.Left

local saveLogBtn = Instance.new("TextButton", scannerSection)
saveLogBtn.Size = UDim2.new(0, 200, 0, 35)
saveLogBtn.Position = UDim2.new(0, 10, 0, 75)
saveLogBtn.Text = "💾 Save Log to File"
saveLogBtn.Font = Enum.Font.GothamBold
saveLogBtn.TextSize = 12
saveLogBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
saveLogBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", saveLogBtn)

-- Executor section
local executorSection = Instance.new("Frame", contentArea)
executorSection.Size = UDim2.new(1, 0, 0, 140)
executorSection.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", executorSection)

local execTitle = Instance.new("TextLabel", executorSection)
execTitle.Size = UDim2.new(1, -10, 0, 25)
execTitle.Position = UDim2.new(0, 5, 0, 5)
execTitle.Text = "🚀 Remote Executor"
execTitle.Font = Enum.Font.GothamBold
execTitle.TextSize = 14
execTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
execTitle.BackgroundTransparency = 1
execTitle.TextXAlignment = Enum.TextXAlignment.Left

local remoteInput = Instance.new("TextBox", executorSection)
remoteInput.Size = UDim2.new(1, -140, 0, 25)
remoteInput.Position = UDim2.new(0, 130, 0, 35)
remoteInput.PlaceholderText = "Enter remote name"
remoteInput.Font = Enum.Font.Gotham
remoteInput.TextSize = 10
remoteInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
remoteInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", remoteInput)

local remoteLabel = Instance.new("TextLabel", executorSection)
remoteLabel.Size = UDim2.new(0, 120, 0, 25)
remoteLabel.Position = UDim2.new(0, 10, 0, 35)
remoteLabel.Text = "Remote Name:"
remoteLabel.Font = Enum.Font.GothamSemibold
remoteLabel.TextSize = 11
remoteLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
remoteLabel.BackgroundTransparency = 1
remoteLabel.TextXAlignment = Enum.TextXAlignment.Left

local argsInput = Instance.new("TextBox", executorSection)
argsInput.Size = UDim2.new(1, -140, 0, 25)
argsInput.Position = UDim2.new(0, 130, 0, 70)
argsInput.PlaceholderText = "arg1, 123, true"
argsInput.Font = Enum.Font.Gotham
argsInput.TextSize = 10
argsInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
argsInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", argsInput)

local argsLabel = Instance.new("TextLabel", executorSection)
argsLabel.Size = UDim2.new(0, 120, 0, 25)
argsLabel.Position = UDim2.new(0, 10, 0, 70)
argsLabel.Text = "Arguments:"
argsLabel.Font = Enum.Font.GothamSemibold
argsLabel.TextSize = 11
argsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
argsLabel.BackgroundTransparency = 1
argsLabel.TextXAlignment = Enum.TextXAlignment.Left

local executeBtn = Instance.new("TextButton", executorSection)
executeBtn.Size = UDim2.new(1, -20, 0, 30)
executeBtn.Position = UDim2.new(0, 10, 0, 105)
executeBtn.Text = "🚀 RUN REMOTE"
executeBtn.Font = Enum.Font.GothamBold
executeBtn.TextSize = 12
executeBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", executeBtn)

-- Quick Actions section
local quickSection = Instance.new("Frame", contentArea)
quickSection.Size = UDim2.new(1, 0, 0, 110)
quickSection.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", quickSection)

local quickTitle = Instance.new("TextLabel", quickSection)
quickTitle.Size = UDim2.new(1, -10, 0, 25)
quickTitle.Position = UDim2.new(0, 5, 0, 5)
quickTitle.Text = "⚡ Quick Actions"
quickTitle.Font = Enum.Font.GothamBold
quickTitle.TextSize = 14
quickTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
quickTitle.BackgroundTransparency = 1
quickTitle.TextXAlignment = Enum.TextXAlignment.Left

local quickLayout = Instance.new("UIGridLayout", quickSection)
quickLayout.CellPadding = UDim2.new(0, 5, 0, 5)
quickLayout.CellSize = UDim2.new(0, 140, 0, 30)
quickLayout.StartCorner = Enum.StartCorner.TopLeft
quickLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createQuickButton(text, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 10
    btn.BackgroundColor3 = Color3.fromRGB(70, 170, 90)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    return btn
end

local fishingBtn = createQuickButton("🎣 PlayFishingEffect", quickSection)
local chargeBtn = createQuickButton("⚡ ChargeFishingRod", quickSection)
local sellBtn = createQuickButton("💰 SellAllItems", quickSection)
local cancelBtn = createQuickButton("❌ CancelFishingInputs", quickSection)
cancelBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)

-- Results section
local resultsSection = Instance.new("Frame", contentArea)
resultsSection.Size = UDim2.new(1, 0, 0, 180)
resultsSection.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", resultsSection)

local resultsTitle = Instance.new("TextLabel", resultsSection)
resultsTitle.Size = UDim2.new(1, -10, 0, 25)
resultsTitle.Position = UDim2.new(0, 5, 0, 5)
resultsTitle.Text = "📋 Execution History"
resultsTitle.Font = Enum.Font.GothamBold
resultsTitle.TextSize = 14
resultsTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
resultsTitle.BackgroundTransparency = 1
resultsTitle.TextXAlignment = Enum.TextXAlignment.Left

local historyFrame = Instance.new("ScrollingFrame", resultsSection)
historyFrame.Size = UDim2.new(1, -120, 1, -40)
historyFrame.Position = UDim2.new(0, 10, 0, 30)
historyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
historyFrame.ScrollBarThickness = 8
historyFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", historyFrame)

local historyLayout = Instance.new("UIListLayout", historyFrame)
historyLayout.Padding = UDim.new(0, 2)

local saveBtn = Instance.new("TextButton", resultsSection)
saveBtn.Size = UDim2.new(0, 100, 1, -40)
saveBtn.Position = UDim2.new(1, -110, 0, 30)
saveBtn.Text = "💾 Save Result"
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 12
saveBtn.BackgroundColor3 = Color3.fromRGB(70, 170, 90)
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", saveBtn)

local function updateMainCanvasSize()
    task.wait()
    contentArea.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y)
end

updateMainCanvasSize()

local function updateHistory()
    for _, child in ipairs(historyFrame:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UICorner") then
            child:Destroy()
        end
    end

    if #RemoteTester.history == 0 then
        local emptyLabel = Instance.new("TextLabel", historyFrame)
        emptyLabel.Size = UDim2.new(1, 0, 0, 18)
        emptyLabel.Text = "No executions yet..."
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 9
        emptyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        emptyLabel.BackgroundTransparency = 1
    else
        for i = #RemoteTester.history, math.max(1, #RemoteTester.history - 20), -1 do
            local entry = RemoteTester.history[i]
            local status = entry.success and "✅" or "❌"
            local line = string.format("[%s] %s %s → %s", entry.time, status, entry.remote, tostring(entry.result))
            local label = Instance.new("TextLabel", historyFrame)
            label.Size = UDim2.new(1, 0, 0, 18)
            label.Text = line
            label.Font = Enum.Font.Gotham
            label.TextSize = 9
            label.TextColor3 = entry.success and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(255, 120, 120)
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left
        end
    end
    task.wait()
    historyFrame.CanvasSize = UDim2.new(0, 0, 0, historyLayout.AbsoluteContentSize.Y)
end

-- Button handlers
scanBtn.MouseButton1Click:Connect(function()
    if RemoteTester.isScanning then return end
    scanBtn.Text = "🔍 Scanning..."
    scanBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    scanStatus.Text = "Scanning remotes..."
    task.spawn(function()
        local remotes = scanAllRemotes()
        task.wait(1)
        scanBtn.Text = "🔍 Scan All Remotes"
        scanBtn.BackgroundColor3 = Color3.fromRGB(70, 170, 90)
        scanStatus.Text = "Found " .. #remotes .. " remotes"
    end)
end)

saveLogBtn.MouseButton1Click:Connect(function()
    if #consoleLog == 0 then
        Notify("Save Log", "⚠️ Log console masih kosong!", 4)
        return
    end
    local logContent = table.concat(consoleLog, "\n")
    local fileName = "RemoteTester_ConsoleLog.txt"
    local success, err = pcall(function() writefile(fileName, logContent) end)
    if success then
        Notify("Save Log", "💾 Log berhasil disimpan ke " .. fileName, 5)
    else
        Notify("Save Log", "❌ Gagal menyimpan log! " .. tostring(err), 5)
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    local lines = {}
    for _, entry in ipairs(RemoteTester.history) do
        local status = entry.success and "✅" or "❌"
        local line = string.format("[%s] %s %s → %s", entry.time, status, entry.remote, tostring(entry.result))
        table.insert(lines, line)
    end
    local resultText = #lines > 0 and table.concat(lines, "\n") or "No executions yet..."
    local success, err = pcall(function() writefile("RemoteTester_Result.txt", resultText) end)
    if success then
        Notify("Save Result", "💾 Result saved to RemoteTester_Result.txt!")
    else
        Notify("Save Result", "❌ Failed to save result! " .. tostring(err))
    end
end)

local function handleExecution()
    local remoteName = remoteInput.Text
    if remoteName == "" then
        Notify("Error", "❌ Please enter a remote name!")
        return
    end
    executeBtn.Text = "🚀 EXECUTING..."
    executeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    task.spawn(function()
        executeRemote(remoteName, argsInput.Text)
        task.wait(0.5)
        executeBtn.Text = "🚀 RUN REMOTE"
        executeBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
        updateHistory()
    end)
end
executeBtn.MouseButton1Click:Connect(handleExecution)

fishingBtn.MouseButton1Click:Connect(function() remoteInput.Text = "PlayFishingEffect"; argsInput.Text = ""; handleExecution() end)
chargeBtn.MouseButton1Click:Connect(function() remoteInput.Text = "ChargeFishingRod"; argsInput.Text = "1"; handleExecution() end)
sellBtn.MouseButton1Click:Connect(function() remoteInput.Text = "SellAllItems"; argsInput.Text = ""; handleExecution() end)
cancelBtn.MouseButton1Click:Connect(function() remoteInput.Text = "CancelFishingInputs"; argsInput.Text = ""; handleExecution() end)

closeBtn.MouseButton1Click:Connect(function() mainPanel.Visible = false end)

local isUIVisible = false
floatingBtn.MouseButton1Click:Connect(function()
    isUIVisible = not isUIVisible
    mainPanel.Visible = isUIVisible
    if isUIVisible then
        floatingBtn.BackgroundColor3 = Color3.fromRGB(70, 170, 90)
        Notify("Remote Tester", "🔧 UI opened!")
        updateMainCanvasSize()
    else
        floatingBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 150)
    end
end)

-- Draggable functionality
local function makeDraggable(trigger, target)
    local dragging = false
    local dragInput, mousePos, framePos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            target.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
            if target == floatingBtn then
                floatingShadow.Position = UDim2.new(target.Position.X.Scale, target.Position.X.Offset - 2, target.Position.Y.Scale, target.Position.Y.Offset + 2)
            end
        end
    end)
end
makeDraggable(titleBar, mainPanel)
makeDraggable(floatingBtn, floatingBtn)

-- Keybind support
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not isUIVisible then return end
    if input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
        if remoteInput:IsFocused() or argsInput:IsFocused() then
            handleExecution()
        end
    end
end)

-- Initial setup
Notify("Remote Tester", "🔧 Remote Tester loaded! Click floating button to open UI.")
task.spawn(function()
    task.wait(2)
    scanAllRemotes()
end)
