-- Pro Auto-Fish Script
-- Version: 1.2
-- Description: An efficient auto-fishing script that uses direct remote calls for max power casts and instant minigame skips.
-- Fix: Completely rewrote the findObject function with a more stable method to prevent all pattern-related errors.

print("🎣 Pro Auto-Fish Script Loaded")

-- ===================================================================
-- Configuration & Variables
-- ===================================================================
local AutoFish = {
    enabled = false,
    status = "Idle"
}

-- Paths to the remotes (based on our findings)
local NET_PATH = "ReplicatedStorage.Packages._Index['sleitnick_net@0.2.0'].net"
local RF_PATH = NET_PATH .. ".RF"
local RE_PATH = NET_PATH .. ".RE"

-- Lazy-load remotes to avoid errors
local Remotes = {
    ChargeFishingRod = nil,
    FishingCompleted = nil,
    BaitSpawned = nil
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
title.Text = "🎣 Pro Auto-Fish"
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

-- >> PERBAIKAN: Fungsi ini ditulis ulang total agar lebih stabil <<
local function findObject(path)
    -- Ubah format ['...'] menjadi format . (contoh: a['b'].c -> a.b.c)
    local cleanPath = path:gsub("%['([^']+)']", ".%1")
    
    local parts = {}
    for part in cleanPath:gmatch("([^.]+)") do
        table.insert(parts, part)
    end
    
    local current = game
    for _, partName in ipairs(parts) do
        current = current:FindFirstChild(partName)
        if not current then
            warn("ProAutoFish: Could not find", partName, "in path", path)
            return nil
        end
    end
    return current
end

local function updateStatus(newStatus)
    AutoFish.status = newStatus
    statusLabel.Text = "Status: " .. newStatus
    print("ProAutoFish:", newStatus)
end

local function startFishingCycle()
    if not AutoFish.enabled then return end

    -- 1. Cast the rod with max power
    updateStatus("Casting rod...")
    local success, err = pcall(function()
        -- Argumen '1' kemungkinan besar adalah kekuatan lemparan (0 sampai 1)
        Remotes.ChargeFishingRod:InvokeServer(1) 
    end)
    
    if not success then
        updateStatus("Error casting rod! Stopping.")
        toggleBtn.MouseButton1Click:Fire() -- Matikan auto
        warn("ProAutoFish Error:", err)
        return
    end

    -- 2. Wait for the fish to bite
    updateStatus("Waiting for a bite...")
    local connection
    connection = Remotes.BaitSpawned.OnClientEvent:Connect(function()
        connection:Disconnect() -- Hanya perlu satu sinyal, lalu disconnect
        
        if not AutoFish.enabled then return end

        -- 3. Skip the minigame instantly
        updateStatus("Fish hooked! Skipping minigame...")
        Remotes.FishingCompleted:FireServer()

        -- 4. Wait a bit before recasting to look more natural
        updateStatus("Waiting to recast...")
        task.wait(math.random(2, 4)) -- Tunggu 2-4 detik
        
        -- 5. Repeat the cycle
        startFishingCycle()
    end)
end

-- ===================================================================
-- UI Interactivity
-- ===================================================================
toggleBtn.MouseButton1Click:Connect(function()
    AutoFish.enabled = not AutoFish.enabled

    if AutoFish.enabled then
        -- Initialize remotes on first start
        if not Remotes.ChargeFishingRod then
            print("ProAutoFish: Initializing remotes...")
            Remotes.ChargeFishingRod = findObject(RF_PATH .. ".ChargeFishingRod")
            Remotes.FishingCompleted = findObject(RE_PATH .. ".FishingCompleted")
            Remotes.BaitSpawned = findObject(RE_PATH .. ".BaitSpawned")
        end

        -- Check if all remotes were found
        if not (Remotes.ChargeFishingRod and Remotes.FishingCompleted and Remotes.BaitSpawned) then
            updateStatus("Failed to find remotes! Cannot start.")
            AutoFish.enabled = false
            return
        end

        toggleBtn.Text = "■ Stop Auto-Fish"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80) -- Red
        startFishingCycle()
    else
        updateStatus("Idle")
        toggleBtn.Text = "▶ Start Auto-Fish"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120) -- Green
    end
end)
