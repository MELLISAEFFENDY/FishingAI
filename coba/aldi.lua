-- Pro Auto-Fish Script
-- Version: 2.1 (Stable)
-- Description: An efficient auto-fishing script that uses direct remote calls for max power casts and instant minigame skips.
-- Fix: Replaced the complex object finder with direct, hardcoded paths for maximum stability and reliability.

print("🎣 Pro Auto-Fish Script Loaded")

-- ===================================================================
-- Configuration & Variables
-- ===================================================================
local AutoFish = {
    enabled = false,
    status = "Idle",
    loopThread = nil
}

-- Direct references to remotes to avoid path errors
local Remotes = {
    ChargeFishingRod = nil,
    RequestFishingMinigameStarted = nil,
    FishingCompleted = nil,
    EquipRod = nil,
    CancelFishing = nil
}

-- ===================================================================
-- UI Creation
-- ===================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProAutoFishUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 100)
mainFrame.Position = UDim2.new(0, 20, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🎣 Pro Auto-Fish v2.1"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 35)
toggleBtn.Text = "▶ Start Auto-Fish"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120) -- Green
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 5)

local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 70)
statusLabel.Text = "Status: Idle"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.BackgroundTransparency = 1
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ===================================================================
-- Core Logic
-- ===================================================================

local function updateStatus(newStatus)
    AutoFish.status = newStatus
    statusLabel.Text = "Status: " .. newStatus
    print("ProAutoFish:", newStatus)
end

-- The main fishing loop
local function startFishingLoop()
    AutoFish.loopThread = task.spawn(function()
        while AutoFish.enabled do
            local success, err = pcall(function()
                -- 1. Ensure rod is equipped
                updateStatus("Checking rod...")
                local char = game.Players.LocalPlayer.Character
                if not (char and char:FindFirstChild("!!!EQUIPPED_TOOL!!!")) then
                    Remotes.CancelFishing:InvokeServer() -- Reset state on server
                    task.wait(0.2)
                    Remotes.EquipRod:FireServer(1) -- Equip rod in slot 1
                    task.wait(0.5) -- Wait for equip animation
                end

                -- 2. Cast the rod with timestamp
                updateStatus("Casting rod...")
                Remotes.ChargeFishingRod:InvokeServer(workspace:GetServerTimeNow())
                task.wait(0.2)

                -- 3. Request minigame with specific args
                updateStatus("Requesting minigame...")
                Remotes.RequestFishingMinigameStarted:InvokeServer(-1.2379989624023438, 0.9800224985802423)
                task.wait(0.4)

                -- 4. Complete the minigame instantly
                updateStatus("Completing minigame...")
                Remotes.FishingCompleted:FireServer()

                -- 5. Wait before repeating
                updateStatus("Waiting...")
                task.wait(math.random(2, 3))
            end)

            if not success then
                updateStatus("Error! Restarting loop...")
                warn("ProAutoFish Loop Error:", err)
                task.wait(3)
            end
        end
    end)
end

-- ===================================================================
-- UI Interactivity
-- ===================================================================
toggleBtn.MouseButton1Click:Connect(function()
    AutoFish.enabled = not AutoFish.enabled

    if AutoFish.enabled then
        -- >> PERBAIKAN: Initialize remotes using direct, stable paths <<
        if not Remotes.ChargeFishingRod then
            updateStatus("Initializing remotes...")
            local success, result = pcall(function()
                local Rs = game:GetService("ReplicatedStorage")
                local NetFolder = Rs.Packages._Index["sleitnick_net@0.2.0"].net
                
                Remotes.ChargeFishingRod = NetFolder.RF.ChargeFishingRod
                Remotes.RequestFishingMinigameStarted = NetFolder.RF.RequestFishingMinigameStarted
                Remotes.FishingCompleted = NetFolder.RE.FishingCompleted
                Remotes.EquipRod = NetFolder.RE.EquipToolFromHotbar
                Remotes.CancelFishing = NetFolder.RF.CancelFishingInputs
            end)

            if not success then
                updateStatus("Failed to find remotes! Is the game loaded?")
                warn("ProAutoFish Init Error:", result)
                AutoFish.enabled = false
                return
            end
        end

        toggleBtn.Text = "■ Stop Auto-Fish"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80) -- Red
        startFishingLoop()
    else
        if AutoFish.loopThread then
            task.cancel(AutoFish.loopThread)
            AutoFish.loopThread = nil
        end
        updateStatus("Idle")
        toggleBtn.Text = "▶ Start Auto-Fish"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120) -- Green
    end
end)
