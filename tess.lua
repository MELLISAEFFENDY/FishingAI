-- Simple AutoFishing Script (standalone, like old.lua)
-- Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/simple_autofishing.lua"))()


print("🎣 Simple AutoFishing loaded!")

-- UI ON/OFF
local autoFishingEnabled = false

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFishingUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 180, 0, 50)
btn.Position = UDim2.new(0, 10, 0, 15)
btn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
btn.Text = "Auto Fishing: OFF"
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 22
btn.Parent = frame

btn.MouseButton1Click:Connect(function()
    autoFishingEnabled = not autoFishingEnabled
    btn.Text = autoFishingEnabled and "Auto Fishing: ON" or "Auto Fishing: OFF"
    btn.BackgroundColor3 = autoFishingEnabled and Color3.fromRGB(0, 200, 40) or Color3.fromRGB(200, 40, 40)
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



-- Loop auto fishing hanya berjalan jika ON
spawn(function()
    if not net then
        print("[AutoFishing] net package not found!")
        return
    end
    local equipRod = net["RE/EquipToolFromHotbar"]
    local requestFishing = net["RF/RequestFishingMinigameStarted"]
    local chargeRod = net["RF/ChargeFishingRod"]
    local fishingCompleted = net["RE/FishingCompleted"]
    while true do
        if autoFishingEnabled then
            -- 1. Equip Rod
            if equipRod then
                equipRod:FireServer(1)
                print("[AutoFishing] EquipToolFromHotbar:FireServer(1)")
            else
                print("[AutoFishing] RE/EquipToolFromHotbar not found!")
            end
            wait(1)

            -- 2. Request Fishing Minigame Started
            if requestFishing then
                local result = nil
                local ok, err = pcall(function()
                    result = requestFishing:InvokeServer()
                end)
                print("[AutoFishing] RequestFishingMinigameStarted:InvokeServer(), result:", result, "error:", err)
            else
                print("[AutoFishing] RF/RequestFishingMinigameStarted not found!")
            end
            wait(1)

            -- 3. Charge Fishing Rod
            if chargeRod then
                local serverTime = safeGetServerTime()
                print("[AutoFishing] ChargeFishingRod argumen:", serverTime)
                local ok, err = pcall(function()
                    chargeRod:InvokeServer(serverTime)
                end)
                print("[AutoFishing] ChargeFishingRod:InvokeServer() error:", err)
            else
                print("[AutoFishing] RF/ChargeFishingRod not found!")
            end
            wait(1)

            -- 4. Fishing Completed
            if fishingCompleted then
                local ok, err = pcall(function()
                    fishingCompleted:FireServer()
                end)
                print("[AutoFishing] FishingCompleted:FireServer() error:", err)
            else
                print("[AutoFishing] RE/FishingCompleted not found!")
            end
            wait(2)
        else
            wait(0.2)
        end
    end
end)
