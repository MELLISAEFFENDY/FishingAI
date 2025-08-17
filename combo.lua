-- Remote Combo Tester: EquipRod, PlayFishingEffect, ChargeFishingRod
-- Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/remote_combo_tester.lua"))()

print("🔗 Remote Combo Tester loaded!")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local function getRemote(name)
    -- Cari di ReplicatedStorage
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v.Name == name and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
            return v
        end
    end
    -- Cari di workspace
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == name and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
            return v
        end
    end
    return nil
end

local function safeGetServerTime()
    local serverTime = nil
    pcall(function()
        serverTime = workspace:GetServerTimeNow()
    end)
    return serverTime or 1
end

-- 1. EquipRod:FireServer(1)
local equipRod = getRemote("EquipRod")
if equipRod then
    equipRod:FireServer(1)
    print("[Combo] EquipRod:FireServer(1)")
else
    print("[Combo] EquipRod not found!")
end
wait(0.2)

-- 2. PlayFishingEffect:FireServer()
local playFishing = getRemote("PlayFishingEffect")
if playFishing then
    playFishing:FireServer()
    print("[Combo] PlayFishingEffect:FireServer()")
else
    print("[Combo] PlayFishingEffect not found!")
end
wait(0.2)

-- 3. ChargeFishingRod:InvokeServer(serverTime)
local chargeRod = getRemote("ChargeFishingRod")
local serverTime = safeGetServerTime()
if chargeRod then
    chargeRod:InvokeServer(serverTime)
    print("[Combo] ChargeFishingRod:InvokeServer(" .. tostring(serverTime) .. ")")
else
    print("[Combo] ChargeFishingRod not found!")
end

print("🔗 Combo remote sequence finished!")
