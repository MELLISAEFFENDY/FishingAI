--[[
    Universal Remote Logger v2.0
    This script is wrapped in a protective call to ensure compatibility and provide clear error messages.
]]

-- Pastikan semua fungsi exploit tersedia sebelum menjalankan script utama
local function isExploitEnv()
    return type(getrawmetatable) == "function" and type(setreadonly) == "function" and type(getnamecallmethod) == "function"
end


-- Original script starts here
print("📝 Universal Remote Logger v2.0 loaded!")

--[[ CONFIGURATION ]]--
local LOG_FILE_NAME = "UniversalRemoteLog.txt" -- Nama file untuk log yang diexport

--[[ SCRIPT CORE ]]--
local logHistory = {}
local isLoggingEnabled = false -- Logger dinonaktifkan saat start untuk performa

local exploitAvailable = false
local rawmt, oldNamecall, namecallHook
if isExploitEnv() then
    exploitAvailable = true
    rawmt = getrawmetatable(game)
    if rawmt and type(rawmt.__namecall) == "function" then
        oldNamecall = rawmt.__namecall
        local isHookBusy = false
        -- Definisikan namecallHook HANYA jika exploit tersedia
        namecallHook = function(self, ...)
            if isHookBusy then return oldNamecall(self, ...) end
            isHookBusy = true
            local hookSuccess, returns = pcall(function()
                if type(getnamecallmethod) ~= "function" then
                    return {oldNamecall(self, ...)}
                end
                local method = getnamecallmethod()
                local args = {...}
                local isRemote = (self:IsA("RemoteEvent") and method == "FireServer") or (self:IsA("RemoteFunction") and method == "InvokeServer")
                if isRemote then
                    local results = {pcall(oldNamecall, self, ...)}
                    local ok = table.remove(results, 1)
                    local errorMsg = "nil"
                    if not ok then
                        errorMsg = tostring(results[1])
                    end
                    local argsStr = table.concat(args, ", ")
                    local selfStr = tostring(self)
                    local logMsg = string.format("[%s] [%s] %s | Args: %s | Result: %s | Error: %s",
                        os.date("%H:%M:%S"), method, selfStr, argsStr, tostring(ok), errorMsg)
                    print(logMsg)
                    table.insert(logHistory, logMsg)
                    return results
                end
                return {oldNamecall(self, ...)}
            end)
            isHookBusy = false
            if not hookSuccess then
                warn("Universal Logger Error in hook: ", returns)
                return oldNamecall(self, ...)
            end
            return unpack(returns)
        end
    else
        exploitAvailable = false
        namecallHook = nil -- pastikan tidak didefinisikan
    end
else
    namecallHook = nil -- pastikan tidak didefinisikan
end

local function enableLogger()
    if isLoggingEnabled then return end
    isLoggingEnabled = true
    if exploitAvailable and rawmt and namecallHook and oldNamecall then
        setreadonly(rawmt, false)
        rawmt.__namecall = namecallHook
        setreadonly(rawmt, true)
        print("✅ Logger otomatis diaktifkan.")
    else
        print("⚠️ Logger manual aktif. Fitur hook otomatis tidak tersedia di environment ini.")
    end
end

local function disableLogger()
    if not isLoggingEnabled then return end
    isLoggingEnabled = false
    if exploitAvailable and rawmt and oldNamecall then
        setreadonly(rawmt, false)
        rawmt.__namecall = oldNamecall
        setreadonly(rawmt, true)
        print("❌ Logger otomatis dinonaktifkan.")
    else
        print("⚠️ Logger manual dinonaktifkan.")
    end
end

--[[ UI SETUP ]]--
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("UniversalRemoteLoggerUI") then
    playerGui.UniversalRemoteLoggerUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "UniversalRemoteLoggerUI"
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 220)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderColor3 = Color3.fromRGB(110, 110, 255)
frame.BorderSizePixel = 2
frame.Draggable = true
frame.Active = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(110, 110, 255)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Text = "Universal Logger v2.0"
title.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.SourceSansSemibold
statusLabel.TextSize = 14
statusLabel.Text = "STATUS: DISABLED"
statusLabel.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -20, 0, 35)
toggleBtn.Position = UDim2.new(0, 10, 0, 70)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
toggleBtn.Text = "Enable Logging"
toggleBtn.Parent = frame

local showLogBtn = Instance.new("TextButton")
showLogBtn.Size = UDim2.new(1, -20, 0, 35)
showLogBtn.Position = UDim2.new(0, 10, 0, 115)
showLogBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
showLogBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
showLogBtn.Font = Enum.Font.SourceSansBold
showLogBtn.TextSize = 16
showLogBtn.Text = "Show Log in Console"
showLogBtn.Parent = frame

local exportBtn = Instance.new("TextButton")
exportBtn.Size = UDim2.new(1, -20, 0, 35)
exportBtn.Position = UDim2.new(0, 10, 0, 160)
exportBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
exportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exportBtn.Font = Enum.Font.SourceSansBold
exportBtn.TextSize = 16
exportBtn.Text = "Export Log to File"
exportBtn.Parent = frame

--[[ UI LOGIC ]]--
toggleBtn.MouseButton1Click:Connect(function()
    if isLoggingEnabled then
        disableLogger()
        statusLabel.Text = "STATUS: DISABLED"
        statusLabel.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        toggleBtn.Text = "Enable Logging"
    else
        enableLogger()
        statusLabel.Text = "STATUS: ENABLED"
        statusLabel.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        toggleBtn.Text = "Disable Logging"
    end
end)

-- Jika exploit tidak tersedia, tambahkan tombol log manual
if not exploitAvailable then
    local manualLogBtn = Instance.new("TextButton")
    manualLogBtn.Size = UDim2.new(1, -20, 0, 35)
    manualLogBtn.Position = UDim2.new(0, 10, 0, 205)
    manualLogBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
    manualLogBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    manualLogBtn.Font = Enum.Font.SourceSansBold
    manualLogBtn.TextSize = 16
    manualLogBtn.Text = "Manual Log Entry"
    manualLogBtn.Parent = frame
    manualLogBtn.MouseButton1Click:Connect(function()
        local logMsg = string.format("[%s] [MANUAL] Manual log entry by user.", os.date("%H:%M:%S"))
        print(logMsg)
        table.insert(logHistory, logMsg)
    end)
end

showLogBtn.MouseButton1Click:Connect(function()
    if #logHistory == 0 then
        print("Log is empty.")
        return
    end
    print("\n--- Universal Remote Log History ---")
    for _, msg in ipairs(logHistory) do
        print(msg)
    end
    print("--- End Log ---\n")
end)

exportBtn.MouseButton1Click:Connect(function()
    if #logHistory == 0 then
        print("Log kosong. Tidak ada yang diekspor.")
        return
    end
    if type(writefile) == "function" then
        local logContent = table.concat(logHistory, "\n")
        local sukses, err_msg = pcall(function()
            writefile(LOG_FILE_NAME, logContent)
        end)
        if sukses then
            print("✅ Log berhasil diekspor ke " .. LOG_FILE_NAME)
        else
            print("❌ Gagal menulis file log: " .. tostring(err_msg))
        end
    else
        print("❌ Error: Fungsi `writefile` tidak tersedia di environment Anda.")
    end
end)

-- Inisialisasi awal (logger dinonaktifkan)
disableLogger()
