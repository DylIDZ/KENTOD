--[[
    Fisch Script - WindUI Version (ROBUST FIX)
    Fixes: Random stopping, Infinite yields, Thread crashing
]]

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- ==========================================
-- 1. SETUP & VARIABLE
-- ==========================================

if getgenv().LoadedFisch then return end
getgenv().LoadedFisch = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local PlayerName = LocalPlayer.Name

getgenv().Ready = false
local savedPosition = nil

-- Default Settings
_G.Settings = {
    Farm = {
        Position = {},
        Mode = "Save Position",
        SelectBoat = "",
        EnableBoat = false,
        Enable = false,
        Cast = { Mode = "Perfect", Enable = true },
        Shake = { Delay = 0.1, Enable = true },
        Reel = { Bar = "Center", Mode = "Fast[Risk]", ReelBarprogress = 0.67, Enable = true },
        Rod = { Admin_Event = "Flimsy Rod", FarmRod = "Flimsy Rod", ScyllaRod = "Flimsy Rod", MossjawRod = "Flimsy Rod" },
    },
    Boss = { SelectBoss = {}, Mode = "With Farm", Enable = false },
    Fish = { SellAll = true },
    Daily_Shop = { SelectItem = {}, Enable = true },
}

-- Load/Save System
getgenv().Load = function()
    if isfile("Hypexz_WindUI_" .. PlayerName .. ".json") then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile("Hypexz_WindUI_" .. PlayerName .. ".json"))
        end)
        if success then
            for i,v in pairs(result) do _G.Settings[i] = v end
        end
    end
end

getgenv().SaveSetting = function()
    local Array = {}
    for i,v in pairs(_G.Settings) do Array[i] = v end
    writefile("Hypexz_WindUI_" .. PlayerName .. ".json", HttpService:JSONEncode(Array))
end
getgenv().Load()

-- Restore Saved Position
if _G.Settings.Farm.Position and _G.Settings.Farm.Position.X then
    local sp = _G.Settings.Farm.Position
    savedPosition = CFrame.new(sp.X, sp.Y, sp.Z) * CFrame.Angles(0, sp.Yaw or 0, 0)
end

-- Anti AFK
LocalPlayer.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- ==========================================
-- 2. HELPER FUNCTIONS
-- ==========================================

function TP(cframe)
    if not cframe then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = cframe
    end
end

local function TeleportMode()
    local Mode = _G.Settings.Farm.Mode
    if Mode == "Trash" then return CFrame.new(-1143.8, 134.6, -1080.5)
    elseif Mode == "Money" then return CFrame.new(-715.6, -864.4, -121.6)
    elseif Mode == "Level" then return CFrame.new(1376.1, -603.6, 2337.5)
    elseif Mode == "Enchant Relic" then return CFrame.new(990.9, -737.9, 1465.7)
    elseif Mode == "Save Position" then return savedPosition
    end
    return savedPosition
end

local function ChangRod(rodName)
    local args = {[1] = rodName}
    ReplicatedStorage.packages.Net["RF/Rod/Equip"]:InvokeServer(unpack(args))
end

local function CheckBoss()
    local SelectedTable = _G.Settings.Boss.SelectBoss
    if type(SelectedTable) ~= "table" then return nil end
    local bossEventNames = {}
    for _, name in pairs(SelectedTable) do bossEventNames[name] = true end

    if workspace:FindFirstChild("zones") and workspace.zones:FindFirstChild("fishing") then
        for _, obj in ipairs(workspace.zones.fishing:GetChildren()) do
            if obj:IsA("Part") and bossEventNames[obj.Name] then
                return obj.Name
            end
        end
    end
    return nil 
end

local function CheckBoss2()
    local bossList = _G.Settings.Boss.SelectBoss
    if type(bossList) ~= "table" then return nil end
    local bossNames = {}
    for _, name in pairs(bossList) do bossNames[name] = true end

    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) and bossNames[obj.Name] then
            return obj.Name
        end
    end
    return nil
end

-- ==========================================
-- 3. UI SETUP (WINDUI)
-- ==========================================

local Window = WindUI:CreateWindow({
    Title = "Hypexz V2 (Stable)",
    Folder = "HypexzV2",
    Icon = "fish-symbol",
    Author = ".ftgs",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
})

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local RodTab = Window:Tab({ Title = "Rod", Icon = "anchor" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map" })
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })

-- === MAIN TAB ===
local StatusSection = MainTab:Section({ Title = "Statistics" })
local TimeParagraph = StatusSection:Paragraph({ Title = "Time Played", Desc = "Calculating..." })
local StatusParagraph = StatusSection:Paragraph({ Title = "Status", Desc = "Idle" })

spawn(function()
    while wait(1) do
        local scripttime = workspace.DistributedGameTime
        local seconds = scripttime%60
        local minutes = math.floor(scripttime/60%60)
        local hours = math.floor(scripttime/3600)
        TimeParagraph:Set({Desc = string.format("%.0fH %.0fM %.0fS", hours ,minutes, seconds)})
        
        local txt = "Idle"
        if _G.Settings.Farm.Enable then txt = "Farming (" .. _G.Settings.Farm.Mode .. ")" end
        StatusParagraph:Set({Desc = txt .. " | Ready: " .. tostring(getgenv().Ready)})
    end
end)

local FarmSection = MainTab:Section({ Title = "Farming" })

FarmSection:Button({
    Title = "Save Current Position",
    Desc = "Required for 'Save Position' mode",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            _G.Settings.Farm.Position = {
                X = char.HumanoidRootPart.CFrame.X,
                Y = char.HumanoidRootPart.CFrame.Y,
                Z = char.HumanoidRootPart.CFrame.Z,
                Yaw = char.HumanoidRootPart.CFrame:ToEulerAnglesYXZ()
            }
            getgenv().SaveSetting()
            savedPosition = char.HumanoidRootPart.CFrame
            WindUI:Notify({ Title = "Saved", Content = "Position Saved!", Icon = "check" })
        end
    end
})

FarmSection:Toggle({
    Title = "Enable Farm",
    Default = _G.Settings.Farm.Enable,
    Callback = function(v) _G.Settings.Farm.Enable = v; getgenv().SaveSetting() end
})

FarmSection:Toggle({
    Title = "Enable Boss Farm",
    Default = _G.Settings.Boss.Enable,
    Callback = function(v) _G.Settings.Boss.Enable = v; getgenv().SaveSetting() end
})

FarmSection:Toggle({
    Title = "Auto Sell [All]",
    Default = _G.Settings.Fish.SellAll,
    Callback = function(v) _G.Settings.Fish.SellAll = v; getgenv().SaveSetting() end
})

local ConfigSection = MainTab:Section({ Title = "Configuration" })

ConfigSection:Dropdown({
    Title = "Farm Mode",
    Values = {"Money","Trash","Level","Enchant Relic","Save Position"},
    Default = _G.Settings.Farm.Mode,
    Callback = function(v) _G.Settings.Farm.Mode = v; getgenv().SaveSetting() end
})

ConfigSection:Dropdown({
    Title = "Cast Mode",
    Values = {"Perfect","Random"},
    Default = _G.Settings.Farm.Cast.Mode,
    Callback = function(v) _G.Settings.Farm.Cast.Mode = v; getgenv().SaveSetting() end
})

ConfigSection:Slider({
    Title = "Shake Delay",
    Min = 0, Max = 1, Default = _G.Settings.Farm.Shake.Delay, Decimals = 2,
    Callback = function(v) _G.Settings.Farm.Shake.Delay = v; getgenv().SaveSetting() end
})

-- Boat
local Myboat = {}
spawn(function()
    pcall(function()
        local stats = workspace.PlayerStats[PlayerName].T[PlayerName].Boats
        for _,v in pairs(stats:GetChildren()) do table.insert(Myboat,v.Name) end
        table.sort(Myboat)
    end)
end)

local BoatDropdown = ConfigSection:Dropdown({
    Title = "Select Boat",
    Values = Myboat,
    Default = _G.Settings.Farm.SelectBoat,
    Callback = function(v) _G.Settings.Farm.SelectBoat = v; getgenv().SaveSetting() end
})

ConfigSection:Button({
    Title = "Refresh Boats",
    Callback = function()
        Myboat = {}
        local stats = workspace.PlayerStats[PlayerName].T[PlayerName].Boats
        for _,v in pairs(stats:GetChildren()) do table.insert(Myboat,v.Name) end
        table.sort(Myboat)
        BoatDropdown:Refresh(Myboat)
    end
})

local ExtraSection = MainTab:Section({ Title = "Extra" })
ExtraSection:Toggle({ Title = "Auto Place Crab Cage", Callback = function(v) startAutoPlace = v end })
ExtraSection:Toggle({ Title = "Auto Collect Crab Cage", Callback = function(v) AutoCollectCrabCage = v end })
ExtraSection:Toggle({ Title = "Auto Buy Crab Cage", Callback = function(v) AutobuyCrabCagevalue = v end })
ExtraSection:Toggle({ Title = "Auto Repair Map", Callback = function(v) AutoRepair = v end })
ExtraSection:Toggle({ Title = "Auto Open Chest", Callback = function(v) AutoOpenChest = v end })

local TogglesSection = MainTab:Section({ Title = "Internal Toggles" })
TogglesSection:Toggle({ Title = "Enable Cast", Default = _G.Settings.Farm.Cast.Enable, Callback = function(v) _G.Settings.Farm.Cast.Enable = v end })
TogglesSection:Toggle({ Title = "Enable Shake", Default = _G.Settings.Farm.Shake.Enable, Callback = function(v) _G.Settings.Farm.Shake.Enable = v end })
TogglesSection:Toggle({ Title = "Enable Reel", Default = _G.Settings.Farm.Reel.Enable, Callback = function(v) _G.Settings.Farm.Reel.Enable = v end })
TogglesSection:Toggle({ Title = "Enable Boat Usage", Default = _G.Settings.Farm.EnableBoat, Callback = function(v) _G.Settings.Farm.EnableBoat = v end })

-- === ROD TAB ===
local RodSection = RodTab:Section({ Title = "Equip Settings" })
local RodNames = {}
local function UpdateRods()
    RodNames = {}
    local path = workspace.PlayerStats[PlayerName].T[PlayerName].Rods
    for _, v in pairs(path:GetChildren()) do table.insert(RodNames, v.Name) end
    table.sort(RodNames)
end
UpdateRods()

local RodMain = RodSection:Dropdown({ Title = "Main Rod", Values = RodNames, Default = _G.Settings.Farm.Rod.FarmRod, Callback = function(v) _G.Settings.Farm.Rod.FarmRod = v; getgenv().SaveSetting() end })
local RodScylla = RodSection:Dropdown({ Title = "Scylla Rod", Values = RodNames, Default = _G.Settings.Farm.Rod.ScyllaRod, Callback = function(v) _G.Settings.Farm.Rod.ScyllaRod = v; getgenv().SaveSetting() end })
local RodMoss = RodSection:Dropdown({ Title = "Mossjaw Rod", Values = RodNames, Default = _G.Settings.Farm.Rod.MossjawRod, Callback = function(v) _G.Settings.Farm.Rod.MossjawRod = v; getgenv().SaveSetting() end })
local RodEvent = RodSection:Dropdown({ Title = "Event Rod", Values = RodNames, Default = _G.Settings.Farm.Rod.Admin_Event, Callback = function(v) _G.Settings.Farm.Rod.Admin_Event = v; getgenv().SaveSetting() end })

RodSection:Button({
    Title = "Refresh Rods",
    Callback = function()
        UpdateRods()
        RodMain:Refresh(RodNames)
        RodScylla:Refresh(RodNames)
        RodMoss:Refresh(RodNames)
        RodEvent:Refresh(RodNames)
    end
})

-- === TELEPORT TAB ===
local TpSection = TeleportTab:Section({ Title = "Locations" })
local tpNames = {}
local tpFolder = workspace:WaitForChild("world"):WaitForChild("spawns"):WaitForChild("TpSpots")
for _, spot in ipairs(tpFolder:GetChildren()) do table.insert(tpNames, spot.Name) end
local extraTPs = {
    {Name = "Carrot Garden", Position = Vector3.new(3744, -1116, -1108)},
    {Name = "Crystal Cove", Position = Vector3.new(1364, -612, 2472)},
    {Name = "Underground Music Venue", Position = Vector3.new(2043, -645, 2471)},
    {Name = "Castaway Cliffs", Position = Vector3.new(655, 179, -1793)},
    {Name = "Luminescent Cavern", Position = Vector3.new(-1016, -337, -4071)},
    {Name = "Crimson Cavern", Position = Vector3.new(-1013, -340, -4891)},
    {Name = "Oscar's Locker", Position = Vector3.new(266, -387, 3407)},
    {Name = "The Boom Ball", Position = Vector3.new(-1296, -900, -3479)},
    {Name = "Lost Jungle", Position = Vector3.new(-2690, 149, -2051)}
}
for _, tp in ipairs(extraTPs) do table.insert(tpNames, tp.Name) end
table.sort(tpNames)

local selectedIsland = tpNames[1]
TpSection:Dropdown({ Title = "Select Location", Values = tpNames, Default = selectedIsland, Callback = function(v) selectedIsland = v end })
TpSection:Button({ Title = "Teleport", Callback = function() 
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local spot = tpFolder:FindFirstChild(selectedIsland)
    if not spot then
        for _, tp in ipairs(extraTPs) do if tp.Name == selectedIsland then spot = {CFrame = CFrame.new(tp.Position)} break end end
    end
    if hrp and spot then TP(spot.CFrame + Vector3.new(0,5,0)) end
end})

local EnchantSection = TeleportTab:Section({ Title = "Enchanting" })
local Encchantlist = { "Abyssal", "Blessed", "Blood Reckoning", "Breezed", "Chaotic", "Chronos", "Clever", "Controlled", "Divine", "Flashline", "Ghastly", "Hasty", "Insight", "Long", "Lucky", "Momentum", "Mutated", "Noir", "Quality", "Resilient", "Scavenger", "Sea King", "Scrapper", "Steady", "Storming", "Swift", "Unbreakable", "Wormhole" }
EnchantSection:Dropdown({ Title = "Select Enchant", Values = Encchantlist, Default = Encchantlist[1], Callback = function(v) SelectedEnc = v end })
EnchantSection:Toggle({ Title = "Start Enchant", Callback = function(v) AutoEnchant = v end })

local ExaltedList = {"Anomalous", "Herculean", "Immortal", "Invincible", "Mystical", "Piercing", "Quantum", "Sea Overlord"}
local SelectedExEnc = ExaltedList[1]
EnchantSection:Dropdown({ Title = "Select Exalted Enchant", Values = ExaltedList, Default = SelectedExEnc, Callback = function(v) SelectedExEnc = v end })
EnchantSection:Toggle({ Title = "Start Exalted Enchant", Callback = function(v) AutoExEnchant = v end })

local ServerSection = TeleportTab:Section({ Title = "Server" })
ServerSection:Button({ Title = "Rejoin Server", Callback = function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer) end })

-- === SHOP TAB ===
local TotemSection = ShopTab:Section({ Title = "Totems" })
local TotemList = {"Aurora", "Sundial", "Windset", "Smokescreen", "Tempest"}
local TotemInfo = { ["Aurora"] = CFrame.new(-1811, -137, -3282), ["Sundial"] = CFrame.new(-1148, 135, -1075), ["Windset"] = CFrame.new(2849, 178, 2702), ["Smokescreen"] = CFrame.new(2789, 140, -625), ["Tempest"] = CFrame.new(35, 133, 1943) }
local SelectedTOtem = TotemList[1]
TotemSection:Dropdown({ Title = "Select Totem", Values = TotemList, Default = SelectedTOtem, Callback = function(v) SelectedTOtem = v end })
TotemSection:Button({ Title = "Teleport To Totem", Callback = function() TP(TotemInfo[SelectedTOtem]) end })

local BaitSection = ShopTab:Section({ Title = "Baits" })
local BaitsList = {"Bait Crate", "Quality Bait Crate", "Tropical Bait Crate", "Coral Geode"}
local BaitInfo = { ["Bait Crate"] = CFrame.new(-1470, 133, 669), ["Quality Bait Crate"] = CFrame.new(-220, 135, 1891), ["Tropical Bait Crate"] = CFrame.new(-923, 131, -1105), ["Coral Geode"] = CFrame.new(-1645, -210, -2855) }
local SelectedBait = BaitsList[1]
local AmountBaitValue = 50

BaitSection:Dropdown({ Title = "Select Bait Crate", Values = BaitsList, Default = SelectedBait, Callback = function(v) SelectedBait = v end })
BaitSection:Input({ Title = "Amount", Default = "50", Numeric = true, Callback = function(v) AmountBaitValue = v end })
BaitSection:Toggle({ Title = "Start Buy Bait", Callback = function(v) pstartbuy = v end })
BaitSection:Toggle({ Title = "Auto Open Bait", Callback = function(v) AutoOpenBait = v end })

local DailyShopSection = ShopTab:Section({ Title = "Daily Shop" })
DailyShopSection:Button({ Title = "Open Black Market UI", Callback = function() game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.BlackMarket.Visible = true end })

local Itemlist = {"Sundial Totem", "Enchant Relic", "Meteor Totem", "Exalted Relic", "Mutation Totem", "Aurora Totem", "Shiny Totem", "Scylla Hunt Totem", "Megalodon Hunt Totem", "Kraken Hunt Totem", "Sparkling Totem", "Lunar Thread", "Moonstone", "Nuke"}
DailyShopSection:Dropdown({ Title = "Select Items to Auto Buy", Values = Itemlist, Multi = true, Default = _G.Settings.Daily_Shop.SelectItem, Callback = function(v) _G.Settings.Daily_Shop.SelectItem = v; getgenv().SaveSetting() end })
DailyShopSection:Toggle({ Title = "Auto Buy Daily Shop", Default = _G.Settings.Daily_Shop.Enable, Callback = function(v) _G.Settings.Daily_Shop.Enable = v; getgenv().SaveSetting() end })

-- ==========================================
-- 4. LOGIC LOOPS (ROBUST & CRASH PROOF)
-- ==========================================

-- Platform
if not workspace:FindFirstChild("Platform") then
    local part = Instance.new("MeshPart")
    part.Name = "Platform" 
    part.Parent = game.Workspace
    part.Anchored = true
    part.Transparency = 0
    part.Size = Vector3.new(10, 0.5, 10)
end

local BOSS_TARGETS = {
    ["Elder Mossjaw"] = { cframe = CFrame.new(-4861.78, -1793.96, -10126.14), threshold = 10 },
    ["MossjawHunt"] = { cframe = CFrame.new(-4861.78, -1793.96, -10126.14), threshold = 10 },
    ["Forsaken Veil - Scylla"] = { cframe = CFrame.new(-2508.34, -11224.48, 6893.28), threshold = 10 },
    ["Megalodon Default"] = { offset = Vector3.new(0, 20, 0), zone = "Megalodon Default", threshold = 10, platformStand = true },
    ["Megalodon Ancient"] = { offset = Vector3.new(0, 20, 0), zone = "Megalodon Ancient", threshold = 10, platformStand = true },
    ["The Kraken Pool"] = { offset = Vector3.new(0, 70, 0), zone = "The Kraken Pool", threshold = 10, platformStand = true },
    ["Ancient Kraken Pool"] = { offset = Vector3.new(0, 70, 0), zone = "Ancient Kraken Pool", threshold = 10, platformStand = true },
    ["Orcas Pool"] = { offset = Vector3.new(0, 90, 0), zone = "Orcas Pool", threshold = 10, platformStand = true },
    ["Ancient Orcas Pool"] = { offset = Vector3.new(0, 90, 0), zone = "Ancient Orcas Pool", threshold = 10, platformStand = true },
    ["FischFright25"] = { offset = Vector3.new(0, 80, 0), zone = "FischFright25", threshold = 10, platformStand = true },
    ["Whales Pool"] = { offset = Vector3.new(0, 80, 0), zone = "Whales Pool", threshold = 10, platformStand = true },
    ["Colossal Blue Dragon"] = { offset = Vector3.new(0, -10, 0), zone = "Colossal Blue Dragon", threshold = 10, platformStand = true },
    ["Colossal Ethereal Dragon"] = { offset = Vector3.new(0, -10, 0), zone = "Colossal Ethereal Dragon", threshold = 10, platformStand = true },
    ["Colossal Ancient Dragon"] = { offset = Vector3.new(0, -10, 0), zone = "Colossal Ancient Dragon", threshold = 10, platformStand = true },
}

local function getBossTargetCFrame(info)
    if info.cframe then return info.cframe end
    if info.zone and workspace.zones.fishing:FindFirstChild(info.zone) then
        return workspace.zones.fishing[info.zone].CFrame * CFrame.new(info.offset or Vector3.zero)
    end
    return nil
end

local function handleBossTarget(targetCFrame)
    TP(targetCFrame)
    getgenv().Ready = true
end

-- [LOOP 1] MOVEMENT & STATE
RunService.Heartbeat:Connect(function()
    if not _G.Settings.Farm.Enable then
        getgenv().Ready = false
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("BodyVelocity1") then
             char.HumanoidRootPart.BodyVelocity1:Destroy()
        end
        return
    end

    local pCharacter = LocalPlayer.Character
    if pCharacter and pCharacter:FindFirstChild("HumanoidRootPart") then
        -- Anti Fall & Noclip
        if not pCharacter.HumanoidRootPart:FindFirstChild("BodyVelocity1") then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "BodyVelocity1"
            bv.Parent = pCharacter.HumanoidRootPart
            bv.MaxForce = Vector3.new(10000, 10000, 10000)
            bv.Velocity = Vector3.new(0, 0, 0)
        end
        for _, v in pairs(pCharacter:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "bobber" then v.CanCollide = false end
        end

        -- Logic Selection
        local BossSpawn = CheckBoss() or CheckBoss2()
        local BossInfo = BossSpawn and BOSS_TARGETS[BossSpawn]
        
        if _G.Settings.Boss.Enable and BossSpawn and BossInfo then
             local targetCFrame = getBossTargetCFrame(BossInfo)
             if targetCFrame then
                 handleBossTarget(targetCFrame)
                 return
             end
        end

        local targetPos = TeleportMode()
        if targetPos then
            TP(targetPos)
            getgenv().Ready = true
        else
            getgenv().Ready = false
        end
    end
end)

-- [LOOP 2] FISHING (ANTI-CRASHED)
task.spawn(function()
    while task.wait() do
        if getgenv().Ready and _G.Settings.Farm.Enable then
            -- Wrap logic in xpcall to prevent thread death from random errors
            xpcall(function()
                local char = LocalPlayer.Character
                if not char then return end

                local ShakeDelay = _G.Settings.Farm.Shake.Delay
                local ROD_MAIN = _G.Settings.Farm.Rod.FarmRod or "Flimsy Rod"
                
                -- Priority Rod Selection
                _G.RodSelect = ROD_MAIN
                local BossSpawn = CheckBoss() or CheckBoss2()
                if _G.Settings.Boss.Enable and BossSpawn then
                    if BossSpawn == "Forsaken Veil - Scylla" then _G.RodSelect = _G.Settings.Farm.Rod.ScyllaRod end
                    if BossSpawn == "Elder Mossjaw" then _G.RodSelect = _G.Settings.Farm.Rod.MossjawRod end
                end

                -- Equip Logic with TIMEOUT (Fixes Infinite Yield)
                if not char:FindFirstChild(_G.RodSelect) then
                    if not LocalPlayer.Backpack:FindFirstChild(_G.RodSelect) then ChangRod(_G.RodSelect) end
                    
                    local timeout = 0
                    repeat 
                        RunService.Heartbeat:Wait()
                        timeout = timeout + 1
                        if timeout > 60 then break end -- Break after ~1s to prevent hanging
                    until LocalPlayer.Backpack:FindFirstChild(_G.RodSelect) or not getgenv().Ready
                    
                    if LocalPlayer.Backpack:FindFirstChild(_G.RodSelect) then
                         char.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(_G.RodSelect))
                    end
                end

                local rodCharacter = char:FindFirstChild(_G.RodSelect)
                if not rodCharacter then return end -- Skip if rod failed to equip
                
                local bobber = rodCharacter:FindFirstChild("bobber")
                local ShakeUi = PlayerGui:FindFirstChild("shakeui")
                local ReelUi = PlayerGui:FindFirstChild("reel")

                -- Cast
                if not bobber and _G.Settings.Farm.Cast.Enable then
                    local castPower = (_G.Settings.Farm.Cast.Mode == "Perfect" and 100) or math.random(75,100)
                    rodCharacter.events.castAsync:InvokeServer(castPower, 1)
                    task.wait(0.5)
                end

                -- Shake
                if ShakeUi and _G.Settings.Farm.Shake.Enable then
                    local safezone = ShakeUi:FindFirstChild("safezone")
                    local button = safezone and safezone:FindFirstChild("button")
                    if button then
                        GuiService.SelectedObject = button
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    end
                    task.wait(ShakeDelay)
                end

                -- Reel
                if ReelUi and _G.Settings.Farm.Reel.Enable then
                    local bar = ReelUi:FindFirstChild("bar")
                    local playerbar = bar and bar:FindFirstChild("playerbar")
                    if playerbar then
                        playerbar:GetPropertyChangedSignal('Position'):Wait()
                        task.wait(0.6) -- Reduced wait slightly for better response
                        ReplicatedStorage.events.reelfinished:FireServer(100, true)
                    end
                end
            end, function(err)
                warn("Fishing Loop Error (Handled):", err)
                task.wait(1) -- Cool down on error
            end)
        else
            task.wait(0.5) -- Idle wait when not ready
        end
    end
end)

-- Auto Sell
spawn(function()
    while task.wait(5) do
        if _G.Settings.Fish.SellAll then
             pcall(function() ReplicatedStorage.events.SellAll:InvokeServer() end)
        end
    end
end)

-- Crab Cage
spawn(function()
    while task.wait(1) do
        if startAutoPlace then
             pcall(function()
                 local char = LocalPlayer.Character
                 if LocalPlayer.Backpack:FindFirstChild("Crab Cage") then
                     char.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild("Crab Cage"))
                 elseif char:FindFirstChild("Crab Cage") then
                     char["Crab Cage"].Deploy:FireServer(char.HumanoidRootPart.CFrame)
                 end
             end)
        end
        if AutoCollectCrabCage then
             for _,v in pairs(workspace.active.crabcages:GetDescendants()) do
                 if v.Name == PlayerName and v:FindFirstChild("Prompt") then
                     fireproximityprompt(v.Prompt)
                 end
             end
        end
    end
end)

-- Auto Buy Crab
spawn(function()
    while task.wait(2) do
        if AutobuyCrabCagevalue then
             pcall(function()
                 TP(CFrame.new(474.875, 150.5, 232.8))
                 for _,v in pairs(workspace.world.interactables["Crab Cage"]:GetChildren()) do
                     if v:FindFirstChild("PromptTemplate") then fireproximityprompt(v.PromptTemplate) end
                 end
                 task.wait(0.2)
                 local gui = LocalPlayer.PlayerGui.over
                 if gui then
                     local box = gui:FindFirstChild("amount", true)
                     if box then box.Text = "50" end
                     local confirm = gui:FindFirstChild("confirm", true)
                     if confirm then firesignal(confirm.MouseButton1Click) end
                 end
             end)
        end
    end
end)

-- Auto Buy Bait
spawn(function()
    while task.wait(1) do
        if pstartbuy then
             pcall(function()
                 TP(BaitInfo[SelectedBait])
                 for _, v in pairs(workspace.world.interactables:GetDescendants()) do
                     if v:IsA('Model') and v.Name == SelectedBait then
                         for _, x in pairs(v:GetDescendants()) do
                             if x:IsA('ProximityPrompt') then fireproximityprompt(x) end
                         end
                     end
                 end
                 task.wait(0.5)
                 local gui = LocalPlayer.PlayerGui.over
                 if gui then
                     local box = gui:FindFirstChild("amount", true)
                     if box then box.Text = tostring(AmountBaitValue) end
                     local confirm = gui:FindFirstChild("confirm", true)
                     if confirm then firesignal(confirm.MouseButton1Click) end
                 end
             end)
        end
    end
end)

-- Auto Open Bait
spawn(function()
    while RunService.Heartbeat:Wait() do
        if AutoOpenBait then
            local char = LocalPlayer.Character
            if LocalPlayer.Backpack:FindFirstChild(SelectedBait) then
                char.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(SelectedBait))
            elseif char:FindFirstChild(SelectedBait) then
                 VirtualUser:CaptureController()
                 VirtualUser:ClickButton1(Vector2.new(851, 158), workspace.Camera.CFrame)
            else
                 AutoOpenBait = false
            end
        end
    end
end)

-- Auto Buy Daily
spawn(function()
    while task.wait(1) do
        if _G.Settings.Daily_Shop.Enable then
            pcall(function()
                local list = LocalPlayer.PlayerGui.hud.safezone.DailyShop.List
                local want = _G.Settings.Daily_Shop.SelectItem
                for _,v in pairs(list:GetDescendants()) do
                    if v.Name == "Label" and v:IsA("TextLabel") then
                         local item = v.Text
                         local found = false
                         for _, w in pairs(want) do if w == item then found = true end end
                         if found and v.Parent:FindFirstChild("SoldOut") and not v.Parent.SoldOut.Visible then
                             ReplicatedStorage.packages.Net["RE/DailyShop/Purchase"]:FireServer(v.Parent.Name)
                         end
                    end
                end
            end)
        end
    end
end)

WindUI:Notify({
    Title = "Hypexz V2",
    Content = "Robust Script Loaded!",
    Icon = "check",
    Duration = 5
})
