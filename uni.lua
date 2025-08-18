-- Simple Remote Logger (Client -> Server)
-- Version: 2.0 (Stable)
-- Description: A lightweight and stable remote logger that only logs outgoing client events (C -> S).
-- This version wraps remote methods instead of using __namecall for maximum compatibility.

print("📡 Loading Simple C->S Remote Logger...")

-- ===================================================================
-- UI Creation
-- ===================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleLoggerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainPanel = Instance.new("Frame", screenGui)
mainPanel.Size = UDim2.new(0, 500, 0, 300)
mainPanel.Position = UDim2.new(0.5, -250, 1, -310) -- Start near the bottom
mainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainPanel.BorderSizePixel = 0
Instance.new("UICorner", mainPanel).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame", mainPanel)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(80, 160, 255) -- Blue title bar
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Text = "📡 Simple Remote Logger (Client -> Server)"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1

local logFrame = Instance.new("ScrollingFrame", mainPanel)
logFrame.Size = UDim2.new(1, -10, 1, -35)
logFrame.Position = UDim2.new(0, 5, 0, 30)
logFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
logFrame.BorderSizePixel = 0
logFrame.ScrollBarThickness = 5
Instance.new("UICorner", logFrame).CornerRadius = UDim.new(0, 5)

local logLayout = Instance.new("UIListLayout", logFrame)
logLayout.Padding = UDim.new(0, 3)
logLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ===================================================================
-- Logger Logic
-- ===================================================================
local function formatArguments(...)
    local args = {...}
    local formatted = {}
    for _, v in ipairs(args) do
        local t = typeof(v)
        if t == "string" then
            table.insert(formatted, string.format('"%s"', tostring(v)))
        elseif t == "Instance" then
            table.insert(formatted, string.format('%s:"%s"', v.ClassName, v:GetFullName()))
        else
            table.insert(formatted, tostring(v))
        end
    end
    return table.concat(formatted, ", ")
end

local function addLogEntry(remote, ...)
    local label = Instance.new("TextLabel")
    label.Text = string.format("[%s] (%s) | Args: %s", os.date("%H:%M:%S"), remote:GetFullName(), formatArguments(...))
    label.Font = Enum.Font.Code
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(120, 220, 255) -- Blue color for C->S
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Size = UDim2.new(1, 0, 0, 15)
    label.Parent = logFrame
    
    -- Auto-scroll to bottom
    task.wait()
    logFrame.CanvasPosition = Vector2.new(0, logLayout.AbsoluteContentSize.Y)
end

-- ===================================================================
-- Hooking Logic (Method Wrapping)
-- ===================================================================
local hookedRemotes = {}

local function hookRemote(remote)
    -- Pastikan remote belum di-hook untuk menghindari rekursi ganda
    if hookedRemotes[remote] then return end
    hookedRemotes[remote] = true

    if remote:IsA("RemoteEvent") then
        local originalFireServer = remote.FireServer
        remote.FireServer = function(self, ...)
            addLogEntry(remote, ...)
            return originalFireServer(self, ...)
        end
    elseif remote:IsA("RemoteFunction") then
        local originalInvokeServer = remote.InvokeServer
        remote.InvokeServer = function(self, ...)
            -- Untuk InvokeServer, kita log panggilannya, lalu kembalikan hasilnya
            addLogEntry(remote, ...)
            return originalInvokeServer(self, ...)
        end
    end
end

local function scanAndHookExisting()
    print("📡 Scanning existing remotes for C->S logging...")
    for _, descendant in ipairs(game:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            hookRemote(descendant)
        end
    end
end

-- Hook newly created remotes
game.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
        task.wait() -- Beri waktu agar remote terinisialisasi sepenuhnya
        hookRemote(descendant)
    end
end)

-- ===================================================================
-- Draggable UI
-- ===================================================================
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragInput, mousePos, framePos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainPanel.Position
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
        mainPanel.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- ===================================================================
-- Initialization
-- ===================================================================
scanAndHookExisting()
print("📡 Simple C->S Remote Logger is now active.")
