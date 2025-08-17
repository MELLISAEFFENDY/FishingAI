# 🎣 AutoFish for Fisch Game - Complete Guide

## 📋 Overview
AutoFish adalah script otomatisasi lengkap untuk game Roblox "Fisch" yang memungkinkan Anda memancing secara otomatis dengan interface yang user-friendly.

---

## 🚀 **Features (Fitur Utama)**

### 🎣 **Automatic Fishing System:**
- ✅ **Auto Cast** - Otomatis melempar kail
- ✅ **Bite Detection** - Deteksi ikan menggigit
- ✅ **Auto Reel** - Otomatis menarik kail
- ✅ **Rod Management** - Auto equip fishing rod
- ✅ **Multiple Methods** - Berbagai metode casting untuk kompatibilitas

### 🗺️ **Fishing Spots (7 Lokasi):**
```
🌊 Moosewood   - Freshwater biome
❄️ Snowcap     - Arctic biome  
🌿 Mushgrove   - Swamp biome
🌊 Roslit      - Ocean biome
🏜️ Sunstone    - Desert biome
💀 Forsaken    - Desolate biome
🌊 Altar       - Deep Ocean biome
```

### 🎮 **Fishing Modes:**
- **Normal** - Balanced speed dan safety (recommended)
- **Fast** - Casting lebih cepat, risiko deteksi lebih tinggi
- **Safe** - Casting lebih lambat, risiko deteksi lebih rendah

### 💰 **Auto-Sell System:**
- ✅ Otomatis jual ikan setiap 50 tangkapan
- ✅ Auto walk ke merchant/shop
- ✅ Auto interact dengan NPC
- ✅ Toggle on/off sesuai kebutuhan

### 🤖 **Anti-AFK System:**
- ✅ **Jump** - Lompat random
- ✅ **Small Movement** - Gerakan kecil keluar masuk
- ✅ **Look Around** - Menoleh kiri-kanan
- ✅ Timer 2 menit interval

### 📊 **Real-time Statistics:**
- ✅ Total catches counter
- ✅ Session time tracking  
- ✅ Fish per hour calculation
- ✅ Current spot display
- ✅ Status monitoring

---

## 🎯 **Cara Penggunaan**

### 1. **Setup Awal:**
```lua
-- Load script
loadstring(readfile("autofish_fisch.lua"))()
```

### 2. **Persiapan:**
- ✅ Pastikan ada fishing rod di inventory
- ✅ Berada di game Fisch
- ✅ Dekat dengan air atau gunakan teleport spot

### 3. **Mulai Fishing:**
1. **Pilih Spot** - Klik button fishing spot untuk teleport
2. **Set Mode** - Pilih Normal/Fast/Safe mode
3. **Enable Settings** - Toggle Auto-Sell dan Anti-AFK
4. **Start** - Klik "Start AutoFish"

### 4. **Monitoring:**
- Lihat statistics real-time
- Monitor status fishing
- Check fish counter

---

## 🖥️ **Interface Guide**

### 📱 **UI Layout:**
```
┌─────────────────────────────────────────┐
│ 🎣 AutoFish - Fisch Game           [✕] │
├─────────────────────────────────────────┤
│ 🎮 AutoFish Controls                    │
│ [🚀 Start] [Mode: Normal ▼]            │
├─────────────────────────────────────────┤
│ 📊 Status & Statistics                  │
│ Status: Ready                           │
│ Total Catches: 0                        │
│ Session Time: 00:00:00                  │
├─────────────────────────────────────────┤
│ 🗺️ Fishing Spots                       │
│ [🎣 Moosewood] [🎣 Snowcap]            │
│ [🎣 Mushgrove] [🎣 Roslit]             │
│ [🎣 Sunstone] [🎣 Forsaken]            │
│ [🎣 Altar]                             │
├─────────────────────────────────────────┤
│ ⚙️ Settings                            │
│ [💰 Auto-Sell: OFF] [🤖 Anti-AFK: ON] │
├─────────────────────────────────────────┤
│ 🚨 Emergency Controls                   │
│ [🛑 STOP] [💀 Reset] [🎣 Equip Rod]    │
└─────────────────────────────────────────┘
```

### 🎮 **Control Buttons:**
- **🚀 Start AutoFish** - Mulai/stop fishing otomatis
- **Mode Dropdown** - Ganti mode fishing
- **🎣 Spot Buttons** - Teleport ke fishing spots
- **💰 Auto-Sell** - Toggle auto-sell on/off
- **🤖 Anti-AFK** - Toggle anti-AFK on/off

### 🚨 **Emergency Controls:**
- **🛑 STOP ALL** - Stop semua aktivitas
- **💀 Reset Char** - Reset character jika stuck
- **🎣 Equip Rod** - Manual equip fishing rod

---

## ⚙️ **Advanced Settings**

### 🎣 **Fishing Logic:**
```lua
-- Casting delays per mode
Normal Mode: 1.5 seconds delay
Fast Mode:   0.5 seconds delay  
Safe Mode:   3.0 seconds delay

-- Timeout settings
Fishing Timeout: 30 seconds
Recast if no bite after timeout
```

### 🤖 **Anti-AFK Timing:**
```lua
-- AFK actions every 2 minutes
Actions: Jump, Small Movement, Look Around
Random selection for natural behavior
```

### 💰 **Auto-Sell Logic:**
```lua
-- Sell every 50 fish caught
Auto walk to nearest merchant
Auto interact and sell all fish
Return to fishing spot
```

---

## 🛡️ **Safety Features**

### 🔒 **Anti-Detection:**
- ✅ Random timing variations
- ✅ Multiple casting methods
- ✅ Natural movement patterns
- ✅ Realistic bite detection delays
- ✅ Anti-AFK system

### 🚨 **Emergency Systems:**
- ✅ Emergency stop button
- ✅ Character reset function
- ✅ Auto rod re-equipping
- ✅ Session monitoring
- ✅ Error handling

### 📊 **Monitoring:**
- ✅ Real-time status updates
- ✅ Catch rate tracking
- ✅ Session time monitoring
- ✅ Spot location tracking

---

## 🔧 **Troubleshooting**

### ❌ **Common Issues:**

#### "No fishing rod found"
**Solution:**
```lua
1. Check inventory for fishing rod
2. Click "Equip Rod" button
3. Buy rod from shop if needed
```

#### "Not catching fish"
**Solution:**
```lua
1. Make sure you're near water
2. Use fishing spot teleport
3. Check rod is equipped
4. Try different fishing mode
```

#### "Character stuck"
**Solution:**
```lua
1. Click "Reset Char" button
2. Use spot teleport to move
3. Restart script if needed
```

#### "Auto-sell not working"
**Solution:**
```lua
1. Make sure merchant is nearby
2. Check if inventory is full
3. Walk closer to merchant manually
```

---

## 📈 **Optimization Tips**

### 🎯 **Best Practices:**
1. **Start Location** - Begin near water or use spot teleport
2. **Mode Selection** - Use Normal mode for best balance
3. **Session Length** - Take breaks every 2-3 hours
4. **Inventory Management** - Enable auto-sell to avoid full inventory
5. **Spot Selection** - Choose spots based on desired fish type

### ⚡ **Performance Tips:**
1. **Close Other Scripts** - Reduce lag and conflicts
2. **Stable Internet** - Avoid disconnections
3. **Monitor Status** - Check periodically for issues
4. **Use Safe Mode** - For longer sessions

---

## 🎣 **Fish Types & Locations**

### 🌊 **Freshwater (Moosewood):**
- Common: Bluegill, Bass, Catfish
- Rare: Rainbow Trout, Pike

### ❄️ **Arctic (Snowcap):**
- Common: Arctic Char, Ice Fish
- Rare: Glacier Fish, Frost Bass

### 🌿 **Swamp (Mushgrove):**
- Common: Swamp Bass, Mud Fish
- Rare: Bog Fish, Mushroom Fish

### 🌊 **Ocean (Roslit):**
- Common: Sea Bass, Mackerel
- Rare: Tuna, Swordfish

### 🏜️ **Desert (Sunstone):**
- Common: Desert Fish, Oasis Bass
- Rare: Golden Fish, Mirage Fish

### 💀 **Desolate (Forsaken):**
- Common: Void Fish, Shadow Bass
- Rare: Cursed Fish, Phantom Fish

### 🌊 **Deep Ocean (Altar):**
- Common: Deep Sea Fish, Abyssal Bass
- Legendary: Kraken, Leviathan

---

## 🎮 **Script Commands**

### 📝 **Manual Controls:**
```lua
-- Manual functions available
AutoFish.enabled = true/false    -- Start/stop fishing
walkToSpot("Moosewood")          -- Walk to specific spot
equipRod()                       -- Equip fishing rod
autoSellFish()                   -- Trigger auto-sell
performAntiAFK()                 -- Manual anti-AFK action
```

### 📊 **Statistics Access:**
```lua
-- Check statistics
print("Total Catches:", Stats.totalCatches)
print("Session Time:", tick() - AutoFish.sessionStartTime)
print("Current Spot:", AutoFish.currentSpot)
```

---

## 🎯 **Kesimpulan**

AutoFish untuk Fisch adalah solusi lengkap untuk automated fishing dengan:

✅ **Ease of Use** - Interface yang mudah digunakan
✅ **Comprehensive** - Semua fitur fishing dalam satu script  
✅ **Safe** - Anti-detection dan emergency controls
✅ **Efficient** - Auto-sell dan spot teleportation
✅ **Monitored** - Real-time statistics dan status

**Perfect untuk grinding fish, completing quests, dan earning money di Fisch game!**

---

*Created by: AutoFish Development Team*
*Version: 1.0*
*Compatible with: Roblox Fisch Game*
*Last Updated: August 2025*
