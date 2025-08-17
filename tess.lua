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
        wait(0.2)

        -- 2. Request Fishing Minigame Started
        if requestFishing then
            requestFishing:InvokeServer()
            print("[AutoFishing] RequestFishingMinigameStarted:InvokeServer()")
        else
            print("[AutoFishing] RF/RequestFishingMinigameStarted not found!")
        end
        wait(0.2)

        -- 3. Charge Fishing Rod
        if chargeRod then
            local serverTime = safeGetServerTime()
            chargeRod:InvokeServer(serverTime)
            print("[AutoFishing] ChargeFishingRod:InvokeServer(" .. tostring(serverTime) .. ")")
        else
            print("[AutoFishing] RF/ChargeFishingRod not found!")
        end
        wait(0.2)

        -- 4. Fishing Completed
        if fishingCompleted then
            fishingCompleted:FireServer()
            print("[AutoFishing] FishingCompleted:FireServer()")
        else
            print("[AutoFishing] RE/FishingCompleted not found!")
        end
        wait(0.5) -- Delay antar fishing, bisa diubah sesuai kebutuhan
    end
end

autoFishLoop()
