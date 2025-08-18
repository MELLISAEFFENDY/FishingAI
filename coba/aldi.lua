-- // FISH IT! PREMIUM SCRIPT W/ FULL UI + CLICKABLE FEATURES
-- // Made for aldii🐟💰
-- // UI Library has been rebuilt and embedded for a fresh look and includes a toggle button.
-- // Fixed an issue where the UI would not appear if "Remotes" folder was not found.

-- // START OF EMBEDDED UI LIBRARY
local OrionLib = (function()
    local OrionLib = {}
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishIt_UI"
    ScreenGui.Parent = game.CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- Floating Toggle Button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = ScreenGui
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(1, -65, 1, -65)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Text = "🐟"
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextSize = 24
    ToggleButton.Draggable = true
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = ToggleButton
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(80, 80, 255)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = ToggleButton

    local WindowFrame
    local TabsContainer
    local ContentContainer
    local activeTabButton = nil

    local function makeDraggable(object)
        local dragging = false
        local dragInput, dragStart, startPos
        object.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = object.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        object.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    local delta = input.Position - dragStart
                    object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end
        end)
    end

    function OrionLib:MakeWindow(data)
        WindowFrame = Instance.new("Frame")
        WindowFrame.Name = data.Name or "Window"
        WindowFrame.Parent = ScreenGui
        WindowFrame.Size = UDim2.new(0, 550, 0, 350)
        WindowFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
        WindowFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        WindowFrame.BorderSizePixel = 0
        WindowFrame.Visible = true
        makeDraggable(WindowFrame)
        Instance.new("UICorner", WindowFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", WindowFrame).Color = Color3.fromRGB(80, 80, 255)

        local Header = Instance.new("Frame")
        Header.Name = "Header"
        Header.Parent = WindowFrame
        Header.Size = UDim2.new(1, 0, 0, 40)
        Header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        local HeaderCorner = Instance.new("UICorner", Header)
        HeaderCorner.CornerRadius = UDim.new(0, 8)
        local HeaderListLayout = Instance.new("UIListLayout", Header)
        HeaderListLayout.FillDirection = Enum.FillDirection.Horizontal
        HeaderListLayout.Padding = UDim.new(0, 10)
        HeaderListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

        local Title = Instance.new("TextLabel", Header)
        Title.Name = "Title"
        Title.Size = UDim2.new(0, 200, 1, 0)
        Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Title.BackgroundTransparency = 1
        Title.Font = Enum.Font.SourceSansBold
        Title.Text = data.Name
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 18
        Title.TextXAlignment = Enum.TextXAlignment.Left

        TabsContainer = Instance.new("Frame")
        TabsContainer.Name = "TabsContainer"
        TabsContainer.Parent = WindowFrame
        TabsContainer.Size = UDim2.new(0, 120, 1, -40)
        TabsContainer.Position = UDim2.new(0, 0, 0, 40)
        TabsContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabsContainer.BorderSizePixel = 0
        local TabsLayout = Instance.new("UIListLayout", TabsContainer)
        TabsLayout.Padding = UDim.new(0, 5)
        TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder

        ContentContainer = Instance.new("Frame")
        ContentContainer.Name = "ContentContainer"
        ContentContainer.Parent = WindowFrame
        ContentContainer.Size = UDim2.new(1, -120, 1, -40)
        ContentContainer.Position = UDim2.new(0, 120, 0, 40)
        ContentContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        ContentContainer.BorderSizePixel = 0

        ToggleButton.MouseButton1Click:Connect(function()
            WindowFrame.Visible = not WindowFrame.Visible
        end)

        local Window = {}
        function Window:MakeTab(tabData)
            local ContentFrame = Instance.new("ScrollingFrame")
            ContentFrame.Name = tabData.Name
            ContentFrame.Parent = ContentContainer
            ContentFrame.Size = UDim2.new(1, 0, 1, 0)
            ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            ContentFrame.BorderSizePixel = 0
            ContentFrame.Visible = false
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            ContentFrame.ScrollBarThickness = 4
            local ContentLayout = Instance.new("UIListLayout", ContentFrame)
            ContentLayout.Padding = UDim.new(0, 10)
            ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            local ContentPadding = Instance.new("UIPadding", ContentFrame)
            ContentPadding.PaddingTop = UDim.new(0, 10)
            ContentPadding.PaddingLeft = UDim.new(0, 10)
            ContentPadding.PaddingRight = UDim.new(0, 10)

            local TabButton = Instance.new("TextButton")
            TabButton.Name = tabData.Name
            TabButton.Parent = TabsContainer
            TabButton.Size = UDim2.new(1, 0, 0, 30)
            TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TabButton.Font = Enum.Font.SourceSansSemibold
            TabButton.Text = " " .. tabData.Name
            TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            TabButton.TextSize = 16
            TabButton.TextXAlignment = Enum.TextXAlignment.Left
            TabButton.AutoButtonColor = false

            TabButton.MouseButton1Click:Connect(function()
                for _, child in ipairs(ContentContainer:GetChildren()) do
                    child.Visible = false
                end
                for _, btn in ipairs(TabsContainer:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                end
                ContentFrame.Visible = true
                TabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
                TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                activeTabButton = TabButton
            end)

            if not activeTabButton then
                TabButton.MouseButton1Click:Invoke()
            end

            local Tab = {}
            local function updateCanvasSize()
                task.wait()
                ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + ContentPadding.PaddingTop.Offset)
            end

            function Tab:AddToggle(toggleData)
                local ToggleFrame = Instance.new("Frame", ContentFrame)
                ToggleFrame.Size = UDim2.new(1, 0, 0, 25)
                ToggleFrame.BackgroundTransparency = 1
                local Layout = Instance.new("UIListLayout", ToggleFrame)
                Layout.FillDirection = Enum.FillDirection.Horizontal
                Layout.VerticalAlignment = Enum.VerticalAlignment.Center

                local Label = Instance.new("TextLabel", ToggleFrame)
                Label.Size = UDim2.new(0.8, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Font = Enum.Font.SourceSans
                Label.TextColor3 = Color3.fromRGB(220, 220, 220)
                Label.Text = toggleData.Name
                Label.TextSize = 16
                Label.TextXAlignment = Enum.TextXAlignment.Left

                local Checkbox = Instance.new("TextButton", ToggleFrame)
                Checkbox.Size = UDim2.new(0, 20, 0, 20)
                Checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Checkbox.Text = ""
                Instance.new("UICorner", Checkbox).CornerRadius = UDim.new(0, 4)
                Instance.new("UIStroke", Checkbox).Color = Color3.fromRGB(100, 100, 100)
                local Checkmark = Instance.new("Frame", Checkbox)
                Checkmark.Size = UDim2.new(0.7, 0, 0.7, 0)
                Checkmark.Position = UDim2.new(0.15, 0, 0.15, 0)
                Checkmark.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
                Instance.new("UICorner", Checkmark).CornerRadius = UDim.new(0, 2)
                
                local state = toggleData.Default or false
                Checkmark.Visible = state
                
                Checkbox.MouseButton1Click:Connect(function()
                    state = not state
                    Checkmark.Visible = state
                    if toggleData.Callback then toggleData.Callback(state) end
                end)
                updateCanvasSize()
            end
            
            function Tab:AddButton(buttonData)
                 local Button = Instance.new("TextButton", ContentFrame)
                 Button.Size = UDim2.new(1, 0, 0, 30)
                 Button.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
                 Button.Font = Enum.Font.SourceSansBold
                 Button.Text = buttonData.Name
                 Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                 Button.TextSize = 16
                 Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)
                 Button.MouseButton1Click:Connect(function()
                     if buttonData.Callback then buttonData.Callback() end
                 end)
                 updateCanvasSize()
            end

            function Tab:AddSlider(sliderData)
                -- Placeholder for slider functionality
            end
            function Tab:AddLabel(labelData)
                local Label = Instance.new("TextLabel", ContentFrame)
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Font = Enum.Font.SourceSansBold
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.Text = labelData
                Label.TextSize = 18
                Label.TextXAlignment = Enum.TextXAlignment.Left
                updateCanvasSize()
            end
            function Tab:AddParagraph(title, content)
                local Para = Instance.new("TextLabel", ContentFrame)
                Para.Size = UDim2.new(1, 0, 0, 40)
                Para.BackgroundTransparency = 1
                Para.Font = Enum.Font.SourceSans
                Para.TextColor3 = Color3.fromRGB(200, 200, 200)
                Para.Text = title .. ": " .. content
                Para.TextSize = 14
                Para.TextWrapped = true
                Para.TextXAlignment = Enum.TextXAlignment.Left
                updateCanvasSize()
            end
            return Tab
        end
        return Window
    end

    function OrionLib:Init()
        -- Initialization logic if needed
    end

    return OrionLib
end)()
-- // END OF EMBEDDED UI LIBRARY


local Window = OrionLib:MakeWindow({Name = "Fish It! Premium Suite", HidePremium = false, SaveConfig = true, ConfigFolder = "FishItUI"})

-- Flags
getgenv().Settings = {
    AutoFish = false,
    AutoSell = false,
    KeepMutation = true,
    KeepSecret = true,
    BoostReelSpeed = true,
    AntiAfk = true,
    LogDrops = true,
    WalkSpeed = 16,
    InfiniteJump = false,
    FloatEnabled = false
}

-- Logger
local dropLog = {}
local function logFish(fishName)
    if getgenv().Settings.LogDrops then
        table.insert(dropLog, os.date("[%H:%M:%S] ") .. fishName)
        print("[LOG] Dapet: " .. fishName)
    end
end

-- Anti-AFK
if getgenv().Settings.AntiAfk then
    pcall(function()
        for _,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do v:Disable() end
    end)
end

-- Fishing System
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local remotes = ReplicatedStorage:FindFirstChild("Remotes")

if not remotes then
    warn("[Fish It!]: Folder 'Remotes' tidak ditemukan. Fitur memancing/menjual tidak akan berfungsi.")
end

local function autoSellFish()
    if not remotes then return end
    for _, fish in pairs(player.Backpack:GetChildren()) do
        if fish:IsA("Tool") and fish:FindFirstChild("FishRarity") then
            local isMutation = fish:FindFirstChild("Mutation")
            local isSecret = fish:FindFirstChild("Secret")

            if isMutation or isSecret then
                if getgenv().Settings.LogDrops then
                    logFish(fish.Name .. (isMutation and " [Mutation]" or "") .. (isSecret and " [Secret]" or ""))
                end
            end

            if getgenv().Settings.AutoSell and not (getgenv().Settings.KeepMutation and isMutation) and not (getgenv().Settings.KeepSecret and isSecret) then
                remotes.Sell:InvokeServer(fish)
            end
        end
    end
end

-- Main Fishing Loop
local function startFishing()
    if not remotes then return end
    while task.wait() and getgenv().Settings.AutoFish do
        pcall(function()
            remotes.Cast:FireServer()
            wait(getgenv().Settings.BoostReelSpeed and 0.4 or 0.6)
            remotes.Reel:FireServer()
            wait(1.2)
            autoSellFish()
        end)
    end
end

-- Teleport System
local teleportLocations = {
    ["Spawn Island"] = Vector3.new(100, 10, -50),
    ["Lost Isle"] = Vector3.new(4032, -150, -872),
    ["Snowcap Island"] = Vector3.new(2000, 20, -1500),
    ["Volcanic Isle"] = Vector3.new(3500, 50, -2200),
    ["Jungle Isle"] = Vector3.new(2800, 15, -600)
}

local function teleportTo(locationName)
    local coords = teleportLocations[locationName]
    if coords and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character:PivotTo(CFrame.new(coords))
    end
end

-- Movement Enhancements
local function setupMovement()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = getgenv().Settings.WalkSpeed
    end

    if getgenv().Settings.FloatEnabled then
        if workspace:FindFirstChild("FloatPart") then workspace.FloatPart:Destroy() end
        local float = Instance.new("Part", workspace)
        float.Name = "FloatPart"
        float.Size = Vector3.new(10,1,10)
        float.Anchored = true
        float.CanCollide = true
        float.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0,3.5,0)
        float.Transparency = 1
    else
        if workspace:FindFirstChild("FloatPart") then workspace.FloatPart:Destroy() end
    end

    if getgenv().Settings.InfiniteJump and not getgenv().JumpHooked then
        getgenv().JumpHooked = true
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end
end

-- Teleport to Players
local function teleportToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and player.Character then
        player.Character:PivotTo(targetPlayer.Character.HumanoidRootPart.CFrame)
    end
end

local function bringPlayerHere(targetPlayer)
    if targetPlayer and targetPlayer.Character and player.Character then
        targetPlayer.Character:PivotTo(player.Character.HumanoidRootPart.CFrame)
    end
end

-- UI Tabs
local MainTab = Window:MakeTab({Name = "Auto Farm"})

MainTab:AddToggle({Name = "Auto Fish", Default = false, Callback = function(v)
    getgenv().Settings.AutoFish = v
    if v then task.spawn(startFishing) end
end})

MainTab:AddToggle({Name = "Auto Sell", Default = true, Callback = function(v)
    getgenv().Settings.AutoSell = v
end})

MainTab:AddToggle({Name = "Keep Mutation", Default = true, Callback = function(v)
    getgenv().Settings.KeepMutation = v
end})

MainTab:AddToggle({Name = "Keep Secret", Default = true, Callback = function(v)
    getgenv().Settings.KeepSecret = v
end})

MainTab:AddToggle({Name = "Boost Reel Speed", Default = true, Callback = function(v)
    getgenv().Settings.BoostReelSpeed = v
end})

MainTab:AddToggle({Name = "Log Rare Drops", Default = true, Callback = function(v)
    getgenv().Settings.LogDrops = v
end})

-- Movement Tab
local MovementTab = Window:MakeTab({Name = "Movement"})

MovementTab:AddToggle({Name = "Infinite Jump", Default = false, Callback = function(v)
    getgenv().Settings.InfiniteJump = v
    setupMovement()
end})

MovementTab:AddToggle({Name = "Enable Float", Default = false, Callback = function(v)
    getgenv().Settings.FloatEnabled = v
    setupMovement()
end})

-- Teleport Menu
local TeleportTab = Window:MakeTab({Name = "Teleport"})

for name, _ in pairs(teleportLocations) do
    TeleportTab:AddButton({Name = name, Callback = function()
        teleportTo(name)
    end})
end

TeleportTab:AddButton({Name = "Rod Shop", Callback = function()
    if player.Character then player.Character:PivotTo(CFrame.new(150, 10, -100)) end
end})

TeleportTab:AddButton({Name = "Bait Shop", Callback = function()
    if player.Character then player.Character:PivotTo(CFrame.new(160, 10, -110)) end
end})

TeleportTab:AddButton({Name = "Spawn All Boats", Callback = function()
    if not remotes then return end
    for _, remote in pairs(remotes:GetChildren()) do
        if remote:IsA("RemoteEvent") and remote.Name:lower():match("boat") then
            remote:FireServer()
        end
    end
end})

TeleportTab:AddLabel("Teleport to Player:")
for _, p in pairs(Players:GetPlayers()) do
    if p ~= player then
        TeleportTab:AddButton({Name = "To: " .. p.Name, Callback = function()
            teleportToPlayer(p)
        end})
        TeleportTab:AddButton({Name = "Bring: " .. p.Name, Callback = function()
            bringPlayerHere(p)
        end})
    end
end

-- Credits Tab
local CreditsTab = Window:MakeTab({Name = "Credits"})
CreditsTab:AddParagraph("Script by", "ChatGPT for Aldi ✨")

-- Init
OrionLib:Init()
setupMovement()
