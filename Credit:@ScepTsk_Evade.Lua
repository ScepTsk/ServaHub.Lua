-- Script developed for @ServaHub
-- Join my Telegram channel: t.me/ServaHub

local players = game:GetService("Players")
local coreGui = game:GetService("CoreGui")
local runService = game:GetService("RunService")
local VirtualUser = cloneref(game:GetService("VirtualUser"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local LocalPlayer = players.LocalPlayer

_G.Items = false
_G.Avoid = false
_G.AntiAFK = false
_G.AFKLevel = false
_G.FullBright = false

_G.AFK_HEIGHT = 1000
_G.AFK_SIZE   = 50
_G.AFK_DELAY  = 3

local oldPlatform = workspace:FindFirstChild("LevelFarmPlatform")
if oldPlatform then oldPlatform:Destroy() end

local AFKConnection
local levelPlatform, platformPos, standPos, savedCFrame
local levelFarmId = 0

if coreGui:FindFirstChild("ToraScript") then
    coreGui.ToraScript:Destroy()
end

local librarynew = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local EvadeEventWindow = librarynew:CreateWindow("Serva Hub | Evade")

local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getPlatformSize()
    local s = tonumber(_G.AFK_SIZE) or 50
    s = math.clamp(s, 10, 200)
    return Vector3.new(s, 2, s)
end

local function ensurePlatform()
    if not levelPlatform or not levelPlatform.Parent then
        levelPlatform = Instance.new("Part")
        levelPlatform.Name = "LevelFarmPlatform"
        levelPlatform.Anchored = true
        levelPlatform.CanCollide = true
        levelPlatform.Color = Color3.fromRGB(200, 30, 45)
        levelPlatform.Material = Enum.Material.SmoothPlastic
        levelPlatform.Size = getPlatformSize()
        levelPlatform.Transparency = 0.2
        levelPlatform.Position = platformPos
        levelPlatform.Parent = workspace
    else
        levelPlatform.Size = getPlatformSize()
    end
end

local function destroyPlatform()
    if levelPlatform then
        levelPlatform:Destroy()
        levelPlatform = nil
    end
end

local function goToPlatform()
    ensurePlatform()
    local r = getRoot()
    if r and standPos then
        r.AssemblyLinearVelocity = Vector3.zero
        r.AssemblyAngularVelocity = Vector3.zero
        r.CFrame = CFrame.new(standPos)
    end
end

local function startLevelFarm()
    levelFarmId = levelFarmId + 1
    local myId = levelFarmId

    local height = tonumber(_G.AFK_HEIGHT) or 1000
    local delay = tonumber(_G.AFK_DELAY) or 3
    local root = getRoot()

    if root then
        savedCFrame = root.CFrame
        platformPos = root.Position + Vector3.new(0, height, 0)
    else
        platformPos = Vector3.new(0, height, 0)
    end

    standPos = platformPos + Vector3.new(0, 5, 0)
    local size = getPlatformSize()
    local maxDrift = math.max(size.X, size.Z) / 2 + 10

    pcall(goToPlatform)

    task.spawn(function()
        while _G.AFKLevel and myId == levelFarmId do
            task.wait(delay)
            if _G.AFKLevel and myId == levelFarmId then
                pcall(goToPlatform)
            end
        end
    end)

    task.spawn(function()
        while _G.AFKLevel and myId == levelFarmId do
            runService.Heartbeat:Wait()
            pcall(function()
                local r = getRoot()
                if r and standPos and (r.Position - standPos).Magnitude > maxDrift then
                    goToPlatform()
                end
            end)
        end
    end)
end

local function stopLevelFarm()
    levelFarmId = levelFarmId + 1
    destroyPlatform()

    local r = getRoot()
    if r and savedCFrame then
        r.AssemblyLinearVelocity = Vector3.zero
        r.CFrame = savedCFrame
    end

    platformPos, standPos, savedCFrame = nil, nil, nil
end

LocalPlayer.CharacterAdded:Connect(function()
    if _G.AFKLevel then
        task.wait(0.5)
        pcall(goToPlatform)
    end
end)

local function Items()
    spawn(function()
        _G.Items = true
        while _G.Items do
            wait()
            pcall(function()
                if _G.AFKLevel then return end
                
                local root = getRoot()
                if not root then return end
                
                local effects = workspace:FindFirstChild("Effects")
                local tickets = effects and effects:FindFirstChild("Tickets")
                if not tickets then return end

                local nearest, best = nil, math.huge
                for _, ticket in pairs(tickets:GetChildren()) do
                    local part = ticket:FindFirstChild("HumanoidRootPart")
                    if part then
                        local d = (root.Position - part.Position).Magnitude
                        if d < best then
                            best = d
                            nearest = part
                        end
                    end
                end
                if nearest then root.CFrame = CFrame.new(nearest.Position) end
            end)
        end
    end)
end

EvadeEventWindow:AddToggle({
    text = "Auto Farm Event",
    callback = function(state)
        _G.Items = state
        if state then Items() end
    end,
})

local function Avoid()
    spawn(function()
        _G.Avoid = true
        while _G.Avoid do
            runService.Heartbeat:Wait()
            pcall(function()
                if _G.AFKLevel then return end
                
                local hrp = getRoot()
                if not hrp then return end

                local playersFolder = workspace:FindFirstChild("Players")
                if not playersFolder then return end

                local nearestBot, minDist = nil, 100
                for _, bot in pairs(playersFolder:GetChildren()) do
                    if bot:GetAttribute("AI") == true and bot:FindFirstChild("HumanoidRootPart") then
                        local d = (hrp.Position - bot.HumanoidRootPart.Position).Magnitude
                        if d < minDist then
                            minDist = d
                            nearestBot = bot
                        end
                    end
                end

                if nearestBot and minDist <= 100 then
                    local map = workspace:FindFirstChild("Map")
                    local itemSpawns = map and map:FindFirstChild("ItemSpawns")
                    if itemSpawns then
                        local bestSpawn, bestDist = nil, -1
                        for _, spawn in pairs(itemSpawns:GetChildren()) do
                            if spawn.Name == "ItemSpawn" then
                                local d = (spawn.Position - nearestBot.HumanoidRootPart.Position).Magnitude
                                if d > bestDist then
                                    bestDist = d
                                    bestSpawn = spawn
                                end
                            end
                        end

                        if bestSpawn then
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.CFrame = bestSpawn.CFrame
                        end
                    end
                end
            end)
        end
    end)
end

EvadeEventWindow:AddToggle({
    text = "Anti NextBots",
    callback = function(state)
        _G.Avoid = state
        if state then Avoid() end
    end,
})

EvadeEventWindow:AddToggle({
    text = "Anti AFK",
    callback = function(state)
        _G.AntiAFK = state
        if state then
            if not AFKConnection then
                AFKConnection = LocalPlayer.Idled:Connect(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        else
            if AFKConnection then
                AFKConnection:Disconnect()
                AFKConnection = nil
            end
        end
    end,
})

EvadeEventWindow:AddToggle({
    text = "AFK Farm Level",
    callback = function(state)
        _G.AFKLevel = state
        if state then startLevelFarm() else stopLevelFarm() end
    end,
})

do
    local FbConn
    local OrigLighting

    local function ApplyFullBright()
        Lighting.GlobalShadows = false
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.ClockTime = 12
        Lighting.ExposureCompensation = 0.5
        Lighting.FogColor = Color3.new(1, 1, 1)
        Lighting.FogEnd = 1e10
        Lighting.FogStart = 0
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1
    end

    local function StartFullBright()
        OrigLighting = {}
        for _, prop in ipairs({"GlobalShadows", "Brightness", "Ambient", "OutdoorAmbient", "ColorShift_Bottom", "ColorShift_Top", "ClockTime", "ExposureCompensation", "FogColor", "FogEnd", "FogStart", "EnvironmentDiffuseScale", "EnvironmentSpecularScale"}) do
            OrigLighting[prop] = Lighting[prop]
        end

        ApplyFullBright()

        if not FbConn then
            FbConn = runService.Heartbeat:Connect(function()
                if _G.FullBright then ApplyFullBright() end
            end)
        end
    end

    local function StopFullBright()
        if FbConn then
            FbConn:Disconnect()
            FbConn = nil
        end

        if OrigLighting then
            for prop, val in pairs(OrigLighting) do
                Lighting[prop] = val
            end
            OrigLighting = nil
        end
    end

    EvadeEventWindow:AddToggle({
        text = "FullBright",
        callback = function(state)
            _G.FullBright = state
            if state then StartFullBright() else StopFullBright() end
        end,
    })
end

EvadeEventWindow:AddButton({
    text = "Unlock All Cosmetics",
    callback = function()
        pcall(function()
            local HttpService = game:GetService("HttpService")
            local RS = game:GetService("ReplicatedStorage")

            if getgenv().UnlockAllStop then
                pcall(getgenv().UnlockAllStop)
                getgenv().unlock_all_enabled = true
            end
            if getgenv().unlock_all_enabled == nil then getgenv().unlock_all_enabled = true end
            local instance = {}
            getgenv().UnlockAllInstance = instance
            local function on() return getgenv().unlock_all_enabled == true and getgenv().UnlockAllInstance == instance end

            local Registry = require(RS.Items.Registry)
            local Inv = require(RS.Client.Services.UserData.Inventory)
            local CharacterService = require(RS.Services.Asset.CharacterService)
            local CharRegistry = require(RS.Objects.Game.Character.DataRegistry)
            local Remotes = RS.Shared.UserData.Remotes
            local EquipRemote, SwapRemote, SetSkinRemote = Remotes.Equip, Remotes.SwapSlots, Remotes.SetSkin
            local TaskRemote = RS.Remotes.Character.CharacterTask
            local origSetTerm
            local fakeEmote = nil

            local SAVE_FOLDER, SAVE_FILE = "UnlockAll", "UnlockAll/state.json"
            local COSMETIC_SLOT = {Cosmetic = true, Unusual = true, Character = true, Emote = true, CarryAnimation = true, Nametag = true}

            local cache, allCosmetics = {}, {}
            local function isCosmetic(id)
                local c = cache[id]
                if c ~= nil then return c end
                local ok, cfg = pcall(Registry.GetConfig, id)
                local r = false
                if ok and type(cfg) == "table" then
                    local st = cfg.EquipInfo and cfg.EquipInfo.SlotType
                    r = (st ~= nil and COSMETIC_SLOT[st] == true) or cfg.CosmeticInfo ~= nil or cfg.EmoteInfo ~= nil
                end
                cache[id] = r
                return r
            end
            local function slotTypeOf(id)
                local ok, cfg = pcall(Registry.GetConfig, id)
                return ok and type(cfg) == "table" and cfg.EquipInfo and cfg.EquipInfo.SlotType or nil
            end
            for id = 1, Registry.GetCount() + 2000 do
                if isCosmetic(id) then allCosmetics[#allCosmetics + 1] = id end
            end

            local slotOverlay, skinOverlay = {}, {}
            local slotObs, skinObs, loadoutObs = {}, {}, {}
            local blocked = 0

            local function save()
                pcall(function()
                    if not isfolder(SAVE_FOLDER) then makefolder(SAVE_FOLDER) end
                    local skins = {}
                    for k, v in pairs(skinOverlay) do skins[tostring(k)] = v end
                    writefile(SAVE_FILE, HttpService:JSONEncode({slots = slotOverlay, skins = skins}))
                end)
            end
            pcall(function()
                if isfile(SAVE_FILE) then
                    local d = HttpService:JSONDecode(readfile(SAVE_FILE))
                    for k, v in pairs(d.slots or {}) do slotOverlay[k] = v end
                    for k, v in pairs(d.skins or {}) do skinOverlay[tonumber(k)] = v end
                end
            end)

            local orig = {}
            local function hook(name, fn)
                orig[name] = hookfunction(Inv[name], fn)
            end

            local function effective(slot)
                local o = slotOverlay[slot]
                if o == nil then return orig.GetEquipped(slot) end
                if o == false then return nil end
                return o
            end
            local function effectiveSkin(base)
                local o = skinOverlay[base]
                if o == nil then return orig.GetSkin(base) end
                if o == false then return nil end
                return o
            end
            local refreshLocal
            local function fireAll()
                for _, o in ipairs(slotObs) do pcall(o.push) end
                for _, o in ipairs(skinObs) do pcall(o.push) end
                for _, cb in ipairs(loadoutObs) do pcall(cb) end
                if refreshLocal then pcall(refreshLocal) end
            end

            hook("Owns", function(id)
                if on() and isCosmetic(id) then return true end
                return orig.Owns(id)
            end)
            hook("IsUnlocked", function(id)
                if on() and isCosmetic(id) then return true end
                return orig.IsUnlocked(id)
            end)
            hook("OwnedIds", function()
                local list = orig.OwnedIds()
                if not on() then return list end
                local have = {}
                for _, id in ipairs(list) do have[id] = true end
                for _, id in ipairs(allCosmetics) do if not have[id] then list[#list + 1] = id end end
                table.sort(list)
                return list
            end)
            hook("GetOwnedBySlotType", function(slotType)
                local list = orig.GetOwnedBySlotType(slotType)
                if not on() or not COSMETIC_SLOT[slotType] then return list end
                local have = {}
                for _, id in ipairs(list) do have[id] = true end
                for _, id in ipairs(allCosmetics) do
                    if not have[id] and slotTypeOf(id) == slotType then list[#list + 1] = id end
                end
                return list
            end)
            hook("IsSlotAvailable", function(slot)
                if on() and COSMETIC_SLOT[Inv.GetSlotType(slot)] then return true end
                return orig.IsSlotAvailable(slot)
            end)
            hook("GetEquipped", function(slot)
                if not on() then return orig.GetEquipped(slot) end
                return effective(slot)
            end)
            hook("GetLoadout", function()
                local r = orig.GetLoadout()
                if not on() then return r end
                for slot, v in pairs(slotOverlay) do r[slot] = v or nil end
                return r
            end)
            hook("IsEquipped", function(id)
                if not on() then return orig.IsEquipped(id) end
                for slot in pairs(Inv.GetSlots()) do
                    if effective(slot) == id then return true, slot end
                end
                return false, nil
            end)
            hook("ObserveSlot", function(slot, cb)
                local entry = {push = function() cb(on() and effective(slot) or orig.GetEquipped(slot)) end}
                local disc = orig.ObserveSlot(slot, function() entry.push() end)
                slotObs[#slotObs + 1] = entry
                return function()
                    pcall(disc)
                    local i = table.find(slotObs, entry)
                    if i then table.remove(slotObs, i) end
                end
            end)
            hook("ObserveLoadout", function(cb)
                local disc = orig.ObserveLoadout(cb)
                loadoutObs[#loadoutObs + 1] = cb
                return function()
                    pcall(disc)
                    local i = table.find(loadoutObs, cb)
                    if i then table.remove(loadoutObs, i) end
                end
            end)
            hook("GetSkin", function(base)
                if not on() then return orig.GetSkin(base) end
                return effectiveSkin(base)
            end)
            hook("ObserveSkin", function(base, cb)
                local entry = {push = function() cb(on() and effectiveSkin(base) or orig.GetSkin(base)) end}
                local disc = orig.ObserveSkin(base, function() entry.push() end)
                skinObs[#skinObs + 1] = entry
                return function()
                    pcall(disc)
                    local i = table.find(skinObs, entry)
                    if i then table.remove(skinObs, i) end
                end
            end)

            local function handleEquip(slot, id)
                if type(slot) ~= "string" or not COSMETIC_SLOT[Inv.GetSlotType(slot)] then return false end
                if id == nil then
                    if slotOverlay[slot] ~= nil then slotOverlay[slot] = nil save() fireAll() return true end
                    return false
                end
                local fake = isCosmetic(id) and not orig.Owns(id)
                local locked = not orig.IsSlotAvailable(slot)
                if fake or locked then
                    slotOverlay[slot] = id
                    save() fireAll()
                    return true
                end
                if slotOverlay[slot] ~= nil then slotOverlay[slot] = nil save() fireAll() end
                return false
            end
            local function handleSwap(a, b)
                if slotOverlay[a] == nil and slotOverlay[b] == nil then return false end
                local ea, eb = effective(a), effective(b)
                slotOverlay[a] = eb == nil and false or eb
                slotOverlay[b] = ea == nil and false or ea
                save() fireAll()
                return true
            end
            local function handleSkin(base, skin)
                if skin == nil then
                    if skinOverlay[base] ~= nil then skinOverlay[base] = false save() fireAll() return true end
                    return false
                end
                if isCosmetic(skin) and not orig.Owns(skin) then
                    skinOverlay[base] = skin
                    save() fireAll()
                    return true
                end
                if skinOverlay[base] ~= nil then skinOverlay[base] = nil save() fireAll() end
                return false
            end

            local function setLocalEmote(id)
                local lc = CharacterService:GetLocalCharacter()
                if lc and lc.DataRegistry and origSetTerm then origSetTerm(lc.DataRegistry, "Emote", id) end
            end
            local function handleEmoteTask(kind, id)
                if kind ~= "Emote" then return false end
                if id == nil or id == 0 then
                    if fakeEmote then fakeEmote = nil setLocalEmote(0) return true end
                    return false
                end
                if type(id) == "number" and isCosmetic(id) and not orig.Owns(id) then
                    fakeEmote = id
                    setLocalEmote(id)
                    return true
                end
                return false
            end

            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                if on() and getnamecallmethod() == "FireServer" then
                    local handled = false
                    if self == EquipRemote then handled = handleEquip(...)
                    elseif self == SwapRemote then handled = handleSwap(...)
                    elseif self == SetSkinRemote then handled = handleSkin(...)
                    elseif self == TaskRemote then handled = handleEmoteTask(...) end
                    if handled then blocked += 1 return end
                end
                return oldNamecall(self, ...)
            end))

            local WORN_SLOTS = {"CosmeticSlot_1", "CosmeticSlot_2", "UnusualSlot", "CharacterSlot"}
            local OVERRIDE_TERMS = {"Cosmetics", "Nametag", "Emotes"}
            local IS_OVERRIDDEN = {Cosmetics = true, Nametag = true, Emotes = true}
            local serverVal = setmetatable({}, {__mode = "k"})

            local function hasWornOverlay()
                for _, s in ipairs(WORN_SLOTS) do
                    if slotOverlay[s] ~= nil then return true end
                end
                return false
            end
            local function wornList()
                local list = {}
                for _, s in ipairs(WORN_SLOTS) do
                    local id = effective(s)
                    if id then list[#list + 1] = id end
                end
                return list
            end
            local function hasEmoteOverlay()
                for i = 1, 12 do
                    if slotOverlay["EmoteSlot_" .. i] ~= nil then return true end
                end
                return false
            end
            local function emoteList()
                local list = {}
                for i = 1, 12 do
                    local id = effective("EmoteSlot_" .. i)
                    if id then list[#list + 1] = {i, id} end
                end
                return list
            end
            local function desired(term, serverValue)
                if not on() then return serverValue end
                if term == "Cosmetics" and hasWornOverlay() then return wornList() end
                if term == "Emotes" and hasEmoteOverlay() then return emoteList() end
                if term == "Nametag" and slotOverlay.NametagSlot ~= nil then return effective("NametagSlot") end
                return serverValue
            end
            local function sameValue(a, b)
                if type(a) == "table" and type(b) == "table" then
                    if #a ~= #b then return false end
                    for i = 1, #a do if not sameValue(a[i], b[i]) then return false end end
                    return true
                end
                return a == b
            end

            origSetTerm = hookfunction(CharRegistry.SetTerm, function(self, term, value)
                if term == "Emote" and fakeEmote and value ~= fakeEmote then
                    local p = rawget(self, "Parent")
                    if type(p) == "table" and p.Local then fakeEmote = nil end
                end
                if IS_OVERRIDDEN[term] then
                    local p = rawget(self, "Parent")
                    if type(p) == "table" and p.Local then
                        local sv = serverVal[self]
                        if not sv then sv = {seeded = true} serverVal[self] = sv end
                        sv[term] = value
                        value = desired(term, value)
                    end
                end
                return origSetTerm(self, term, value)
            end)

            refreshLocal = function()
                for _, c in CharacterService:GetCharacters() do
                    local reg = c.Local and c.DataRegistry
                    if reg then
                        local sv = serverVal[reg]
                        if not sv then
                            sv = {seeded = true, Cosmetics = reg.Data.Cosmetics, Nametag = reg.Data.Nametag, Emotes = reg.Data.Emotes}
                            serverVal[reg] = sv
                        end
                        for _, term in ipairs(OVERRIDE_TERMS) do
                            local want = desired(term, sv[term])
                            if not sameValue(want, reg.Data[term]) then
                                origSetTerm(reg, term, want)
                            end
                        end
                    end
                end
            end

            local running = true
            task.spawn(function()
                while running do
                    pcall(refreshLocal)
                    task.wait(0.5)
                end
            end)
            pcall(refreshLocal)

            getgenv().UnlockAllStop = function()
                getgenv().unlock_all_enabled = false
                table.clear(slotOverlay) table.clear(skinOverlay)
                pcall(fireAll)
                if fakeEmote then fakeEmote = nil pcall(setLocalEmote, 0) end
                running = false
                getgenv().UnlockAllStop = nil
            end
            getgenv().UnlockAllDebug = function() return {blocked = blocked, slots = slotOverlay, skins = skinOverlay, cosmetics = #allCosmetics} end
        end)
    end,
})

librarynew:Init()
