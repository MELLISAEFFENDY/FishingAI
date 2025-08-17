-- SIMPLIFIED MODERN AUTOFISH - SMART MODE ONLY
-- Fixed and cleaned version

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Must run on client
if not RunService:IsClient() then
    warn("modern_autofish: must run as LocalScript")
    return
end

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    warn("modern_autofish: LocalPlayer missing")
    return
end

-- Simple notifier
local function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 4})
    end)
    print("[modern_autofish]", title, text)
end

-- Config
local Config = {
    mode = "smart",
    enabled = false
}

-- Remote helper
local function FindNet()
    local ok, net = pcall(function()
        local packages = ReplicatedStorage:FindFirstChild("Packages")
        if not packages then return nil end
        local idx = packages:FindFirstChild("_Index")
        if not idx then return nil end
        local sleit = idx:FindFirstChild("sleitnick_net@0.2.0")
        if not sleit then return nil end
        return sleit:FindFirstChild("net")
    end)
    return ok and net or nil
end

local net = FindNet()
local function ResolveRemote(name)
    if not net then return nil end
    local ok, rem = pcall(function() return net:FindFirstChild(name) end)
    return ok and rem or nil
end

local rodRemote = ResolveRemote("RF/ChargeFishingRod")
local miniGameRemote = ResolveRemote("RF/RequestFishingMinigameStarted")
local finishRemote = ResolveRemote("RE/FishingCompleted")
local equipRemote = ResolveRemote("RE/EquipToolFromHotbar")

local sessionId = 0

local function safeInvoke(remote, ...)
    if not remote then return false, "nil_remote" end
    if remote:IsA("RemoteFunction") then
        return pcall(function(...) return remote:InvokeServer(...) end, ...)
    else
        return pcall(function(...) remote:FireServer(...) return true end, ...)
    end
end

local function GetServerTime()
    local ok, st = pcall(function() return workspace:GetServerTimeNow() end)
    if ok and type(st) == "number" then return st end
    return tick()
end

-- Smart fishing cycle
local function DoSmartCycle()
    -- Phase 1: Equip
    if equipRemote then 
        pcall(function() equipRemote:FireServer(1) end)
        task.wait(0.8 + math.random() * 0.7)
    end
    
    -- Phase 2: Charge rod
    local timestamp = GetServerTime() + math.random() * 0.5
    if rodRemote and rodRemote:IsA("RemoteFunction") then 
        pcall(function() rodRemote:InvokeServer(timestamp) end)
    end
    task.wait(0.1 + math.random() * 0.1)
    
    -- Phase 3: Cast
    local x = -1.238 + (math.random() - 0.5) * 0.1
    local y = 0.969 + (math.random() - 0.5) * 0.1
    if miniGameRemote and miniGameRemote:IsA("RemoteFunction") then 
        pcall(function() miniGameRemote:InvokeServer(x, y) end)
    end
    task.wait(2.0 + math.random() * 2.0)
    
    -- Phase 4: Complete
    if finishRemote then 
        pcall(function() finishRemote:FireServer() end)
    end
    task.wait(1.0 + math.random() * 1.0)
end

local function AutofishRunner(mySession)
    Notify("modern_autofish", "Smart AutoFishing started")
    while Config.enabled and sessionId == mySession do
        local ok, err = pcall(DoSmartCycle)
        if not ok then
            warn("modern_autofish: cycle error:", err)
            task.wait(1)
        end
        
        -- Delay between cycles
        local delay = 0.5 + math.random() * 0.5
        local elapsed = 0
        while elapsed < delay do
            if not Config.enabled or sessionId ~= mySession then break end
            task.wait(0.1)
            elapsed = elapsed + 0.1
        end
    end
    Notify("modern_autofish", "Smart AutoFishing stopped")
end

-- Simple UI
local function CreateUI()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SimpleAutoFishUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 120)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(80, 80, 90)
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Smart AutoFish"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = frame

    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0, 100, 0, 30)
    startBtn.Position = UDim2.new(0, 10, 0, 40)
    startBtn.Text = "START"
    startBtn.Font = Enum.Font.GothamSemibold
    startBtn.TextSize = 14
    startBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.Parent = frame
    
    local startCorner = Instance.new("UICorner")
    startCorner.CornerRadius = UDim.new(0, 6)
    startCorner.Parent = startBtn

    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0, 100, 0, 30)
    stopBtn.Position = UDim2.new(0, 120, 0, 40)
    stopBtn.Text = "STOP"
    stopBtn.Font = Enum.Font.GothamSemibold
    stopBtn.TextSize = 14
    stopBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopBtn.Parent = frame
    
    local stopCorner = Instance.new("UICorner")
    stopCorner.CornerRadius = UDim.new(0, 6)
    stopCorner.Parent = stopBtn

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 20)
    status.Position = UDim2.new(0, 10, 0, 80)
    status.BackgroundTransparency = 1
    status.Text = "Status: Ready"
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = frame

    -- Event handlers
    startBtn.MouseButton1Click:Connect(function()
        if Config.enabled then 
            Notify("AutoFish", "Already running")
            return 
        end
        Config.enabled = true
        sessionId = sessionId + 1
        status.Text = "Status: Running..."
        status.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.spawn(function() AutofishRunner(sessionId) end)
    end)

    stopBtn.MouseButton1Click:Connect(function()
        Config.enabled = false
        sessionId = sessionId + 1
        status.Text = "Status: Stopped"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
    end)

    -- Make draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    Notify("AutoFish", "UI loaded - Ready to start!")
end

-- Initialize
CreateUI()

-- Global API
_G.SimpleAutoFish = {
    Start = function() 
        if not Config.enabled then 
            Config.enabled = true
            sessionId = sessionId + 1
            task.spawn(function() AutofishRunner(sessionId) end)
        end
    end,
    Stop = function() 
        Config.enabled = false
        sessionId = sessionId + 1
    end,
    Config = Config
}

print("simple_autofish loaded successfully")
