# 🎮 Character Movement Guide - Roblox Lua Scripts

## 📋 Overview
Ya, dengan script Lua di Roblox kita bisa melakukan **berbagai macam gerakan character**! Berikut adalah panduan lengkap untuk mengontrol character movement.

---

## 🚀 **1. BASIC MOVEMENTS (Gerakan Dasar)**

### Jump (Lompat)
```lua
-- Method 1: Simple jump
LocalPlayer.Character.Humanoid.Jump = true

-- Method 2: Enhanced jump (lebih reliable)
local humanoid = LocalPlayer.Character.Humanoid
humanoid.Jump = true
task.wait(0.1)
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
```

### Walk/Run (Jalan/Lari)
```lua
-- Walk to specific direction
local humanoid = LocalPlayer.Character.Humanoid
humanoid:Move(Vector3.new(0, 0, 1), true) -- Forward
humanoid.WalkSpeed = 20 -- Set speed

-- Walk to specific position (with pathfinding)
humanoid:MoveTo(Vector3.new(100, 0, 100))
```

### Stop Movement
```lua
local humanoid = LocalPlayer.Character.Humanoid
humanoid:Move(Vector3.new(0, 0, 0), true)
```

---

## 📍 **2. TELEPORTATION (Teleportasi)**

### Basic Teleport
```lua
-- Teleport to position
local rootPart = LocalPlayer.Character.HumanoidRootPart
rootPart.CFrame = CFrame.new(Vector3.new(100, 10, 100))
```

### Advanced Teleport
```lua
-- Teleport with rotation
local position = Vector3.new(100, 10, 100)
local lookDirection = Vector3.new(0, 0, 1)
rootPart.CFrame = CFrame.lookAt(position, position + lookDirection)

-- Teleport forward by distance
local currentPos = rootPart.Position
local forwardDir = rootPart.CFrame.LookVector
local newPos = currentPos + (forwardDir * 10)
rootPart.CFrame = CFrame.new(newPos)
```

---

## ✈️ **3. ADVANCED MOVEMENTS (Gerakan Lanjutan)**

### Flying
```lua
-- Enable fly mode
local rootPart = LocalPlayer.Character.HumanoidRootPart
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
bodyVelocity.Velocity = Vector3.new(0, 0, 0)
bodyVelocity.Parent = rootPart

-- Control flying
bodyVelocity.Velocity = Vector3.new(0, 50, 0) -- Fly up
```

### Noclip (Tembus Dinding)
```lua
-- Enable noclip
for _, part in pairs(LocalPlayer.Character:GetChildren()) do
    if part:IsA("BasePart") then
        part.CanCollide = false
    end
end

-- Disable noclip
for _, part in pairs(LocalPlayer.Character:GetChildren()) do
    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
        part.CanCollide = true
    end
end
```

---

## 🎯 **4. FISHING SPECIFIC MOVEMENTS**

### Anti-AFK Movements
```lua
-- 1. Simple Jump
LocalPlayer.Character.Humanoid.Jump = true

-- 2. Small Steps
local humanoid = LocalPlayer.Character.Humanoid
local rootPart = LocalPlayer.Character.HumanoidRootPart
local direction = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
local targetPos = rootPart.Position + (direction * 2)
humanoid:MoveTo(targetPos)

-- 3. Look Around
local rootPart = LocalPlayer.Character.HumanoidRootPart
local originalCFrame = rootPart.CFrame
rootPart.CFrame = originalCFrame * CFrame.Angles(0, math.rad(45), 0) -- Look left
task.wait(0.5)
rootPart.CFrame = originalCFrame * CFrame.Angles(0, math.rad(-45), 0) -- Look right
task.wait(0.5)
rootPart.CFrame = originalCFrame -- Return to original

-- 4. Micro Movements (sangat natural)
local rootPart = LocalPlayer.Character.HumanoidRootPart
local randomOffset = Vector3.new(
    math.random(-1, 1) * 0.5,
    0,
    math.random(-1, 1) * 0.5
)
rootPart.CFrame = rootPart.CFrame + randomOffset
```

### Auto Walk to Fishing Spots
```lua
local fishingSpots = {
    ["Moosewood"] = Vector3.new(-1463, 131, 213),
    ["Snowcap"] = Vector3.new(2648, 140, 2522),
    ["Mushgrove"] = Vector3.new(2500, 131, -721),
    ["Altar"] = Vector3.new(1306, -806, -105)
}

local function walkToSpot(spotName)
    local targetPos = fishingSpots[spotName]
    if targetPos then
        LocalPlayer.Character.Humanoid:MoveTo(targetPos)
    end
end
```

### Player Avoidance
```lua
local function dodgeNearbyPlayers(radius)
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local theirPos = player.Character.HumanoidRootPart.Position
            local distance = (myPos - theirPos).Magnitude
            
            if distance < radius then
                -- Move away from player
                local awayDirection = (myPos - theirPos).Unit
                local safePos = myPos + (awayDirection * 15)
                LocalPlayer.Character.Humanoid:MoveTo(safePos)
                return true
            end
        end
    end
    return false
end
```

---

## ⌨️ **5. INPUT SIMULATION (Simulasi Input)**

### Simulate Key Press
```lua
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Press and release key
VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
task.wait(0.1)
VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
```

### Simulate WASD Movement
```lua
-- Move forward (W key)
VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
task.wait(1)
VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
```

### Simulate Mouse Movement
```lua
-- Move mouse to position
VirtualInputManager:SendMouseMoveEvent(400, 300, game)

-- Click mouse
VirtualInputManager:SendMouseButtonEvent(400, 300, 0, true, game, 1)
task.wait(0.1)
VirtualInputManager:SendMouseButtonEvent(400, 300, 0, false, game, 1)
```

---

## 🔄 **6. PATTERN MOVEMENTS (Gerakan Pola)**

### Circle Walk
```lua
local function circleWalk(radius, speed, duration)
    local centerPos = LocalPlayer.Character.HumanoidRootPart.Position
    local angle = 0
    local humanoid = LocalPlayer.Character.Humanoid
    
    humanoid.WalkSpeed = speed
    
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
        angle = angle + deltaTime * (speed / radius)
        local x = centerPos.X + math.cos(angle) * radius
        local z = centerPos.Z + math.sin(angle) * radius
        humanoid:MoveTo(Vector3.new(x, centerPos.Y, z))
    end)
    
    task.wait(duration)
    connection:Disconnect()
end
```

### Random Movement
```lua
local function randomMovement(duration)
    local startTime = tick()
    
    while tick() - startTime < duration do
        local randomDirection = Vector3.new(
            math.random(-1, 1),
            0,
            math.random(-1, 1)
        ).Unit
        
        local currentPos = LocalPlayer.Character.HumanoidRootPart.Position
        local targetPos = currentPos + (randomDirection * 10)
        
        LocalPlayer.Character.Humanoid:MoveTo(targetPos)
        task.wait(2)
    end
end
```

### Patrol Movement
```lua
local function patrol(waypoints)
    local currentIndex = 1
    
    while true do
        local targetWaypoint = waypoints[currentIndex]
        LocalPlayer.Character.Humanoid:MoveTo(targetWaypoint)
        LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
        
        currentIndex = currentIndex + 1
        if currentIndex > #waypoints then
            currentIndex = 1 -- Loop back
        end
        
        task.wait(1)
    end
end
```

---

## 🎭 **7. ANIMATION CONTROL**

### Play Custom Animation
```lua
local function playAnimation(animationId)
    local humanoid = LocalPlayer.Character.Humanoid
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animationId
    
    local animTrack = humanoid:LoadAnimation(animation)
    animTrack:Play()
    
    return animTrack
end
```

### Play Emote
```lua
local humanoid = LocalPlayer.Character.Humanoid
humanoid:PlayEmote("wave") -- atau emote lainnya
```

---

## 🛡️ **8. SAFETY & ANTI-DETECTION**

### Natural Looking Movements
```lua
-- Combine multiple small movements
local function naturalAntiAFK()
    local movements = {
        function() -- Micro jump
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(0, 1000, 0)
            bodyVelocity.Velocity = Vector3.new(0, 5, 0)
            bodyVelocity.Parent = rootPart
            task.wait(0.1)
            bodyVelocity:Destroy()
        end,
        
        function() -- Small position shift
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            local offset = Vector3.new(
                math.random(-50, 50) / 100,
                0,
                math.random(-50, 50) / 100
            )
            rootPart.CFrame = rootPart.CFrame + offset
        end,
        
        function() -- Look around slightly
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            local originalCFrame = rootPart.CFrame
            local randomAngle = math.rad(math.random(-10, 10))
            rootPart.CFrame = originalCFrame * CFrame.Angles(0, randomAngle, 0)
            task.wait(0.5)
            rootPart.CFrame = originalCFrame
        end
    }
    
    -- Execute random movement
    local randomMovement = movements[math.random(1, #movements)]
    randomMovement()
end
```

### Emergency Escape
```lua
local function emergencyEscape()
    -- Random teleport
    local rootPart = LocalPlayer.Character.HumanoidRootPart
    local randomPos = Vector3.new(
        math.random(-100, 100),
        10,
        math.random(-100, 100)
    )
    rootPart.CFrame = CFrame.new(rootPart.Position + randomPos)
    
    -- Or reset character as last resort
    -- LocalPlayer.Character.Humanoid.Health = 0
end
```

---

## 📊 **9. BEST PRACTICES**

### ✅ **DO's:**
- ✅ Always check if character exists before moving
- ✅ Use random timing for anti-AFK (1.7-10 minutes)
- ✅ Combine multiple movement types for naturalness
- ✅ Use small, subtle movements
- ✅ Implement error handling with pcall()
- ✅ Monitor for other players and adjust behavior

### ❌ **DON'Ts:**
- ❌ Don't use predictable patterns
- ❌ Don't move too frequently (looks bot-like)
- ❌ Don't use large movements that draw attention
- ❌ Don't forget to validate character exists
- ❌ Don't use same movement repeatedly

---

## 🎮 **10. INTEGRATION EXAMPLES**

### For AntiAFK System
```lua
local AntiAFKMethods = {
    -- Method pool for variety
    methods = {
        function() LocalPlayer.Character.Humanoid.Jump = true end,
        function() 
            local pos = LocalPlayer.Character.HumanoidRootPart.Position
            LocalPlayer.Character.Humanoid:MoveTo(pos + Vector3.new(2, 0, 0))
            task.wait(1)
            LocalPlayer.Character.Humanoid:MoveTo(pos)
        end,
        function()
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            local original = rootPart.CFrame
            rootPart.CFrame = original * CFrame.Angles(0, math.rad(30), 0)
            task.wait(0.5)
            rootPart.CFrame = original
        end
    }
}

local function performRandomAntiAFK()
    local randomMethod = AntiAFKMethods.methods[math.random(1, #AntiAFKMethods.methods)]
    randomMethod()
end
```

---

## 🎯 **Kesimpulan**

**Ya, kita bisa melakukan berbagai gerakan character dengan script Lua:**

1. **Basic Movements**: Jump, walk, run, stop
2. **Teleportation**: Instant position changes
3. **Advanced**: Flying, noclip, smooth movements
4. **Anti-AFK**: Natural-looking idle behaviors
5. **Pattern Movements**: Circles, random, patrol
6. **Input Simulation**: Key press, mouse control
7. **Animation Control**: Custom animations, emotes

**Files yang telah dibuat:**
- 📁 `movement_examples.lua` - General movement functions
- 📁 `fishing_movements.lua` - Fishing-specific movements  
- 📁 `test.lua` - Testing and demo script
- 📁 `MOVEMENT_GUIDE.md` - This documentation

**Ready untuk diintegrasikan ke fishing script! 🎣✨**
