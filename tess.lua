-- Simple AutoFishing Script (standalone, like old.lua)
-- Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/simple_autofishing.lua"))()

print("🎣 Simple AutoFishing loaded!")

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

local function autoFishLoop()
    if not net then
        print("[AutoFishing] net package not found!")
        return
    end
    local equipRod = net["RE/EquipToolFromHotbar"]
    local requestFishing = net["RF/RequestFishingMinigameStarted"]
    local chargeRod = net["RF/ChargeFishingRod"]
    local fishingCompleted = net["RE/FishingCompleted"]
    while true do
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
            -- Coba kirim argumen kosong, jika error, user bisa lihat
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
        wait(2) -- Delay antar fishing, bisa diubah sesuai kebutuhan
    end
end

autoFishLoop()
