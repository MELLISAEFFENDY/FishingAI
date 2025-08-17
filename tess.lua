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
    local chargeRod = net["RF/ChargeFishingRod"]
    local requestFishing = net["RF/RequestFishingMinigameStarted"]
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
            wait(math.random(10,30)/100) -- delay acak 0.1-0.3 detik

            -- 2. Charge Fishing Rod
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
            wait(math.random(10,30)/100)

            -- 3. Request Fishing Minigame Started (pakai dua angka persis old.lua)
            if requestFishing then
                -- Gunakan angka random agar tidak selalu perfect cast
                local x = math.random(-1200, -1000) / 1000
                local y = math.random(950, 1000) / 1000
                local ok, err = pcall(function()
                    requestFishing:InvokeServer(x, y)
                end)
                print(string.format("[AutoFishing] RequestFishingMinigameStarted:InvokeServer(%f, %f) error: %s", x, y, tostring(err)))
            else
                print("[AutoFishing] RF/RequestFishingMinigameStarted not found!")
            end
            wait(0.4 + math.random(10,30)/100)

            -- 4. Fishing Completed
            if fishingCompleted then
                local ok, err = pcall(function()
                    fishingCompleted:FireServer()
                end)
                print("[AutoFishing] FishingCompleted:FireServer() error:", err)
            else
                print("[AutoFishing] RE/FishingCompleted not found!")
            end
            wait(math.random(20,40)/100)
        else
            wait(0.2)
        end
    end
end)
