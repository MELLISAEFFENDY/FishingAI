-- Universal Remote Logger Script
-- Merekam semua aktivitas remote (FireServer/InvokeServer) di game, lengkap argumen, waktu, dan hasil eksekusi
-- Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/universal_remote_logger.lua"))()

print("📝 Universal Remote Logger loaded!")

local logHistory = {}
local function logActivity(remoteType, remoteName, args, result, errorMsg)
    local msg = string.format("[%s] [%s] %s | Args: %s | Result: %s | Error: %s", os.date("%H:%M:%S"), remoteType, remoteName, args, tostring(result), tostring(errorMsg))
    print(msg)
    table.insert(logHistory, msg)
end

-- Hook global __namecall untuk logging semua aktivitas remote
local oldNamecall = nil
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local isRemote = (self:IsA("RemoteEvent") and method == "FireServer") or (self:IsA("RemoteFunction") and method == "InvokeServer")
    if isRemote then
        local result, errorMsg, retVal = true, nil, nil
        local ok, ret = pcall(function()
            retVal = oldNamecall(self, unpack(args))
        end)
        if not ok then result, errorMsg = false, ret end
        logActivity(method, tostring(self), table.concat(args, ", "), result, errorMsg)
        return retVal
    end
    return oldNamecall(self, ...)
end)
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Tidak perlu scan/wrap remote lagi, semua sudah di-hook global

-- UI untuk menampilkan log
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalRemoteLoggerUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 140)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui

local logBtn = Instance.new("TextButton")
logBtn.Size = UDim2.new(0, 240, 0, 40)
logBtn.Position = UDim2.new(0, 10, 0, 20)
logBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
logBtn.Text = "Show All Remote Log"
logBtn.TextColor3 = Color3.fromRGB(255,255,255)
logBtn.Font = Enum.Font.SourceSansBold
logBtn.TextSize = 18
logBtn.Parent = frame

logBtn.MouseButton1Click:Connect(function()
    print("\n--- Universal Remote Log History ---")
    for i, v in ipairs(logHistory) do
        print(v)
    end
    print("--- End Log ---\n")
end)

-- Otomatis scan ulang jika ada remote baru
game.DescendantAdded:Connect(function(obj)
    if obj:IsA("RemoteEvent") then
        wrapRemote(obj, "FireServer", obj:GetFullName())
    elseif obj:IsA("RemoteFunction") then
        wrapRemote(obj, "InvokeServer", obj:GetFullName())
    end
end)
