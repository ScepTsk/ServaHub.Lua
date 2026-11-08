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

librarynew:Init()
