--[[
    Universal Remote Spy & Logger
    Version: 1.2
    Description: Automatically hooks into all RemoteEvents and RemoteFunctions to log their communications.
    Features:
    - Logs Client -> Server (FireServer, InvokeServer).
    - Logs Server -> Client (FireClient, FireAllClients) with a toggle.
    - By default, only logs client-side actions to reduce spam.
    - Handles remotes created after the script runs.
    - Floating, draggable UI with a scrollable log view.
    - Options to clear the log and save it to a file.
    - Added pcall to __namecall hook for stability and to prevent crashes.
]]

print("🔭 Loading Universal Remote Spy...")

-- Services
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local MAX_LOG_ENTRIES = 200 -- To prevent performance issues

-- Logger System
local RemoteSpy = {
    logEntries = {},
    ui = {},
    logServerEvents = false -- Defaultnya OFF, hanya log aksi client
}

-- ===================================================================
-- UI Creation
-- ===================================================================
local function createUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RemoteSpyUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")
    RemoteSpy.ui.screenGui = screenGui

    -- Floating Toggle Button
    local toggleBtn = Instance.new("TextButton", screenGui)
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
    toggleBtn.Text = "📡"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 24
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.ZIndex = 999
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 25)
    RemoteSpy.ui.toggleBtn = toggleBtn

    -- Main Panel
    local mainPanel = Instance.new("Frame", screenGui)
    mainPanel.Size = UDim2.new(0, 600, 0, 400)
    mainPanel.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainPanel.BorderSizePixel = 0
    mainPanel.Visible = false
    Instance.new("UICorner", mainPanel).CornerRadius = UDim.new(0, 8)
    RemoteSpy.ui.mainPanel = mainPanel

    -- Title Bar
    local titleBar = Instance.new("Frame", mainPanel)
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

    local titleText = Instance.new("TextLabel", titleBar)
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.Text = "📡 Universal Remote Spy"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 16
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.BackgroundTransparency = 1
    titleText.TextXAlignment = Enum.TextXAlignment.Left

    -- Log Area
    local logFrame = Instance.new("ScrollingFrame", mainPanel)
    logFrame.Size = UDim2.new(1, -20, 1, -85)
    logFrame.Position = UDim2.new(0, 10, 0, 40)
    logFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    logFrame.BorderSizePixel = 0
    logFrame.ScrollBarThickness = 6
    Instance.new("UICorner", logFrame).CornerRadius = UDim.new(0, 5)
    RemoteSpy.ui.logFrame = logFrame

    local logLayout = Instance.new("UIListLayout", logFrame)
    logLayout.Padding = UDim.new(0, 3)
    logLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RemoteSpy.ui.logLayout = logLayout

    -- Button Area
    local buttonFrame = Instance.new("Frame", mainPanel)
    buttonFrame.Size = UDim2.new(1, -20, 0, 35)
    buttonFrame.Position = UDim2.new(0, 10, 1, -40)
    buttonFrame.BackgroundTransparency = 1
    
    local buttonLayout = Instance.new("UIListLayout", buttonFrame)
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    buttonLayout.Padding = UDim.new(0, 10)

    local clearBtn = Instance.new("TextButton", buttonFrame)
    clearBtn.Size = UDim2.new(0.3, 0, 1, 0)
    clearBtn.Text = "🗑️ Clear Log"
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.TextSize = 14
    clearBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 50)
    clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 5)
    RemoteSpy.ui.clearBtn = clearBtn
    
    local serverLogToggleBtn = Instance.new("TextButton", buttonFrame)
    serverLogToggleBtn.Size = UDim2.new(0.3, 0, 1, 0)
    serverLogToggleBtn.Text = "S->C Log: OFF"
    serverLogToggleBtn.Font = Enum.Font.GothamBold
    serverLogToggleBtn.TextSize = 14
    serverLogToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 80, 80) -- Merah (OFF)
    serverLogToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", serverLogToggleBtn).CornerRadius = UDim.new(0, 5)
    RemoteSpy.ui.serverLogToggleBtn = serverLogToggleBtn

    local saveBtn = Instance.new("TextButton", buttonFrame)
    saveBtn.Size = UDim2.new(0.3, 0, 1, 0)
    saveBtn.Text = "💾 Save to File"
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.TextSize = 14
    saveBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
    saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 5)
    RemoteSpy.ui.saveBtn = saveBtn
end

-- ===================================================================
-- Logger & UI Logic
-- ===================================================================
local function formatArguments(...)
    local args = {...}
    local formatted = {}
    for i, v in ipairs(args) do
        local t = typeof(v)
        if t == "string" then
            table.insert(formatted, string.format('"%s"', tostring(v)))
        elseif t == "Instance" then
            table.insert(formatted, string.format('%s:"%s"', v.ClassName, v:GetFullName()))
        elseif t == "table" then
            table.insert(formatted, "<table>")
        else
            table.insert(formatted, tostring(v))
        end
    end
    return table.concat(formatted, ", ")
end

local function addLogEntry(direction, remote, ...)
    local entry = {
        direction = direction,
        path = remote:GetFullName(),
        args = formatArguments(...)
    }
    table.insert(RemoteSpy.logEntries, 1, entry)

    if #RemoteSpy.logEntries > MAX_LOG_ENTRIES then
        table.remove(RemoteSpy.logEntries, MAX_LOG_ENTRIES + 1)
    end

    if not RemoteSpy.ui.mainPanel or not RemoteSpy.ui.mainPanel.Visible then return end

    local label = Instance.new("TextLabel")
    label.Text = string.format("[%s] %s (%s) | Args: %s", os.date("%H:%M:%S"), entry.direction, entry.path, entry.args)
    label.Font = Enum.Font.Code
    label.TextSize = 12
    label.TextColor3 = entry.direction == "C -> S" and Color3.fromRGB(120, 220, 255) or Color3.fromRGB(255, 200, 120)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Size = UDim2.new(1, 0, 0, 15)
    label.LayoutOrder = -#RemoteSpy.logEntries
    label.Parent = RemoteSpy.ui.logFrame

    local children = RemoteSpy.ui.logFrame:GetChildren()
    if #children > MAX_LOG_ENTRIES + 1 then
        for i = MAX_LOG_ENTRIES + 2, #children do
            if children[i]:IsA("TextLabel") then
                children[i]:Destroy()
            end
        end
    end
end

-- ===================================================================
-- Hooking Logic (__namecall & .OnClientEvent)
-- ===================================================================
local oldNamecall
local function hookRemote(remote)
    if remote:IsA("RemoteEvent") then
        remote.OnClientEvent:Connect(function(...)
            if RemoteSpy.logServerEvents then
                addLogEntry("S -> C", remote, ...)
            end
        end)
    end
end

local function setupHooks()
    local mt = getrawmetatable(game)
    oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if (method == "FireServer" and self:IsA("RemoteEvent")) or (method == "InvokeServer" and self:IsA("RemoteFunction")) then
            addLogEntry("C -> S", self, ...)
        end
        
        -- >> PERBAIKAN: Menggunakan pcall untuk mencegah crash <<
        local success, result = pcall(function()
            return oldNamecall(self, ...)
        end)
        
        if not success then
            -- Optional: print error if you want to debug, but it might spam the console
            -- print("RemoteSpy __namecall error:", tostring(result))
        end
        
        return result
    end)
    
    setreadonly(mt, true)

    for _, descendant in ipairs(game:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            hookRemote(descendant)
        end
    end

    game.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            task.wait()
            hookRemote(descendant)
        end
    end)
end

-- ===================================================================
-- UI Interactivity
-- ===================================================================
local function setupInteractivity()
    local ui = RemoteSpy.ui

    ui.toggleBtn.MouseButton1Click:Connect(function()
        ui.mainPanel.Visible = not ui.mainPanel.Visible
    end)

    ui.clearBtn.MouseButton1Click:Connect(function()
        RemoteSpy.logEntries = {}
        for _, v in ipairs(ui.logFrame:GetChildren()) do
            if v:IsA("TextLabel") then
                v:Destroy()
            end
        end
    end)

    local function updateServerLogToggleBtn()
        if RemoteSpy.logServerEvents then
            ui.serverLogToggleBtn.Text = "S->C Log: ON"
            ui.serverLogToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120) -- Hijau
        else
            ui.serverLogToggleBtn.Text = "S->C Log: OFF"
            ui.serverLogToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 80, 80) -- Merah
        end
    end
    
    ui.serverLogToggleBtn.MouseButton1Click:Connect(function()
        RemoteSpy.logServerEvents = not RemoteSpy.logServerEvents
        updateServerLogToggleBtn()
    end)

    ui.saveBtn.MouseButton1Click:Connect(function()
        if not writefile then
            print("Spy: writefile is not available in this executor.")
            return
        end
        
        local content = {}
        for i = #RemoteSpy.logEntries, 1, -1 do
            local entry = RemoteSpy.logEntries[i]
            table.insert(content, string.format("[%s] %s (%s) | Args: %s", os.date("%H:%M:%S"), entry.direction, entry.path, entry.args))
        end
        
        local fileName = "RemoteSpy_Log_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".txt"
        writefile(fileName, table.concat(content, "\n"))
        print("Spy: Log saved to " .. fileName)
    end)

    local dragging = false
    local dragInput, mousePos, framePos
    local titleBar = ui.mainPanel:FindFirstChild("Frame")

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = ui.mainPanel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            ui.mainPanel.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- ===================================================================
-- Initialization
-- ===================================================================
createUI()
setupInteractivity()
setupHooks()

print("🔭 Universal Remote Spy is now active.")
StarterGui:SetCore("SendNotification", {
    Title = "Remote Spy",
    Text = "Spy is now active. S->C logging is OFF by default.",
    Duration = 5
})
