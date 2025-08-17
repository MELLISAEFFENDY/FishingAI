-- AutoFishing Logger Script
-- This script logs all remote activity and actions for monitoring purposes.
-- Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/autofishing_logger.lua"))()

print("📝 AutoFishing Logger loaded!")

local logHistory = {}
local function logActivity(action, ...)
    local args = {...}
    local msg = string.format("[%s] %s | Args: %s", os.date("%H:%M:%S"), action, table.concat(args, ", "))
    print(msg)
    table.insert(logHistory, msg)
end

local autoFishingEnabled = false
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFishingLoggerUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0, 10, 0, 15)
btn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
btn.Text = "Auto Fishing: OFF"
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 22
btn.Parent = frame

local logBtn = Instance.new("TextButton")
logBtn.Size = UDim2.new(0, 200, 0, 30)
logBtn.Position = UDim2.new(0, 10, 0, 70)
logBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
logBtn.Text = "Show Log"
logBtn.TextColor3 = Color3.fromRGB(255,255,255)
logBtn.Font = Enum.Font.SourceSansBold
logBtn.TextSize = 18
logBtn.Parent = frame

btn.MouseButton1Click:Connect(function()
    autoFishingEnabled = not autoFishingEnabled
    btn.Text = autoFishingEnabled and "Auto Fishing: ON" or "Auto Fishing: OFF"
    btn.BackgroundColor3 = autoFishingEnabled and Color3.fromRGB(0, 200, 40) or Color3.fromRGB(200, 40, 40)
    logActivity("Toggle AutoFishing", btn.Text)
end)

logBtn.MouseButton1Click:Connect(function()
    print("\n--- AutoFishing Log History ---")
    for i, v in ipairs(logHistory) do
        print(v)
    end
    print("--- End Log ---\n")
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:FindFirstChild("Packages")
local net = nil
if Packages and Packages:FindFirstChild("_Index") and Packages._Index:FindFirstChild("sleitnick_net@0.2.0") then
    local sleitnick = Packages._Index["sleitnick_net@0.2.0"]
    net = sleitnick:FindFirstChild("net")
end

local function safeGetServerTime()
    local serverTime = nil
    pcall(function()
        serverTime = workspace:GetServerTimeNow()
    end)
    return serverTime or 1
end

spawn(function()
    if not net then
        logActivity("Error", "net package not found!")
        return
    end
    local equipRod = net["RE/EquipToolFromHotbar"]
    local chargeRod = net["RF/ChargeFishingRod"]
    local requestFishing = net["RF/RequestFishingMinigameStarted"]
    local fishingCompleted = net["RE/FishingCompleted"]
    while true do
        if autoFishingEnabled then
            if equipRod then
                equipRod:FireServer(1)
                logActivity("EquipToolFromHotbar:FireServer", 1)
            else
                logActivity("Error", "RE/EquipToolFromHotbar not found!")
            end
            wait(math.random(10,30)/100)

            if chargeRod then
                local serverTime = safeGetServerTime()
                logActivity("ChargeFishingRod argumen", serverTime)
                local ok, err = pcall(function()
                    chargeRod:InvokeServer(serverTime)
                end)
                logActivity("ChargeFishingRod:InvokeServer error", tostring(err))
            else
                logActivity("Error", "RF/ChargeFishingRod not found!")
            end
            wait(math.random(10,30)/100)

            if requestFishing then
                local x = math.random(-1200, -1000) / 1000
                local y = math.random(950, 1000) / 1000
                local ok, err = pcall(function()
                    requestFishing:InvokeServer(x, y)
                end)
                logActivity("RequestFishingMinigameStarted:InvokeServer", x, y, tostring(err))
            else
                logActivity("Error", "RF/RequestFishingMinigameStarted not found!")
            end
            wait(0.4 + math.random(10,30)/100)

            if fishingCompleted then
                local ok, err = pcall(function()
                    fishingCompleted:FireServer()
                end)
                logActivity("FishingCompleted:FireServer error", tostring(err))
            else
                logActivity("Error", "RE/FishingCompleted not found!")
            end
            wait(math.random(20,40)/100)
        else
            wait(0.2)
        end
    end
end)
