--[[
    ███████╗███████╗██████╗ ██╗   ██╗ █████╗     ██╗  ██╗██╗   ██╗██████╗ 
    ██╔════╝██╔════╝██╔══██╗██║   ██║██╔══██╗    ██║  ██║██║   ██║██╔══██╗
    ███████╗█████╗  ██████╔╝██║   ██║███████║    ███████║██║   ██║██████╔╝
    ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══██║    ██╔══██║██║   ██║██╔══██╗
    ███████║███████╗██║  ██║ ╚████╔╝ ██║  ██║    ██║  ██║╚██████╔╝██████╔╝
    ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    Game: Hide and Seek Extreme
    Version: v1.1 [ Beta ]
    Release: 2026-11-14
    Author: Serva Team <3 
    UI Library: WindUI (Footagesus)
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local WS = workspace
local UIS = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local RS = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local Camera = WS.CurrentCamera

local Window = WindUI:CreateWindow({
    Title = '<font color="#FFFFFF">Serva Hub</font>', 
    Icon = "rbxassetid://136463464698564", 
    IconSize = 40,
    Author = '<font color="rgb(124, 145, 181)">Hide and Seek Extreme</font>',
    Background = "rbxassetid://102252256446593",
    Transparent = true, 
    User = { Enabled = true, Anonymous = false },
    Theme = "Dark"
})

WindUI:AddTheme({
    Name = "ServaHub",
    Accent = Color3.fromHex("#89CFF0"),
    Background = Color3.fromHex("#0B132B"),
    Outline = Color3.fromHex("#1C315E"),
    Text = Color3.fromHex("#F4F8FF"),
    Placeholder = Color3.fromHex("#7C91B5"),
    Button = Color3.fromHex("#2A4B8D"),
    Icon = Color3.fromHex("#B3D9FF"),
})
WindUI:SetTheme("ServaHub")
pcall(function() Window:SetBackgroundImageTransparency(0.6) end)

local function SetFpsCap(val)
    if setfpscap then pcall(setfpscap, val) end
    if settings then
        pcall(function() settings().Rendering.TargetFrameRate = val end)
        pcall(function() settings().RenderSettings.TargetFrameRate = val end)
    end
    if setfflag then 
        pcall(setfflag, "TaskSchedulerTargetFps", tostring(val))
        pcall(setfflag, "DFIntTaskSchedulerTargetFps", tostring(val)) 
    end
end

local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })

local tgSection = InfoTab:Section({ Title = "Telegram Channel", Icon = "link" })
tgSection:Paragraph({
    Title = "Telegram Channel",
    Desc = "Official Channel\nSubscribers: 258",
    Image = "rbxassetid://136463464698564",
    ImageSize = 50
})
tgSection:Button({
    Title = "Copy Telegram Link",
    Icon = "copy",
    Callback = function()
        if setclipboard then
            setclipboard("https://t.me/ServaHub")
            WindUI:Notify({ Title = "Telegram", Content = "Link copied!", Icon = "check", Duration = 3 })
        end
    end
})

local changelogSection = InfoTab:Section({ Title = "Changelog", Icon = "history" })
changelogSection:Paragraph({
    Title = "Version v1.1 — Hide and Seek Extreme",
    Desc = "+ Look at the functions"
})

Window:Divider()

local Hub = { conns = {}, unloaded = false }
local function bind(c) table.insert(Hub.conns, c) return c end
local function getHum() local c = LP.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = LP.Character return c and c:FindFirstChild("HumanoidRootPart") end

local GameData = RS:FindFirstChild("GameData")
local InGameValue = LP:FindFirstChild("PlayerData") and LP.PlayerData:FindFirstChild("InGame")
local ItValue = GameData and GameData:FindFirstChild("It")
local function isIt() if not ItValue then return false end return tostring(ItValue.Value) == LP.Name or tostring(ItValue.Value) == LP.DisplayName end

local PlayerState = {
    FlyEnabled = false, FlySpeed = 50, FlyBodyVelocity = nil, FlyBodyGyro = nil,
    InfiniteJumpEnabled = false, NoclipEnabled = false,
    SpinbotEnabled = false, SpinbotSpeed = 3,
    InvisibilityEnabled = false, AntiFlingEnabled = false,
    WallHopEnabled = false, WallHopMode = "Press", WallHopAngle = 90, WallHopCamFlick = false,
    GravityEnabled = false, GravityValue = 196,
    HipHeightEnabled = false, HipHeightValue = 2,
}

local noclipConn
local originalCollisions = {} 
local function toggleNoclip(state)
    PlayerState.NoclipEnabled = state
    local char = LP.Character
    if not char then return end
    if state then
        table.clear(originalCollisions)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                originalCollisions[part] = part.CanCollide
                part.CanCollide = false
            end
        end
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = RunService.Stepped:Connect(function()
            if not PlayerState.NoclipEnabled then return end
            local c = LP.Character
            if c then
                for _, part in pairs(c:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if originalCollisions[part] == nil then originalCollisions[part] = part.CanCollide end
                        if part.CanCollide then part.CanCollide = false end
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        for part, canCollide in pairs(originalCollisions) do
            if part and part.Parent then part.CanCollide = canCollide end
        end
        table.clear(originalCollisions)
    end
end

local flyConn
local function stopFly()
    PlayerState.FlyEnabled = false
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if PlayerState.FlyBodyVelocity then PlayerState.FlyBodyVelocity:Destroy() PlayerState.FlyBodyVelocity = nil end
    if PlayerState.FlyBodyGyro then PlayerState.FlyBodyGyro:Destroy() PlayerState.FlyBodyGyro = nil end
    local hum = getHum()
    if hum then hum.PlatformStand = false end
end

local function startFly()
    local char = LP.Character
    local root = getRoot()
    if not char or not root then return end
    local hum = getHum()
    if hum then hum.PlatformStand = true end
    local bv = Instance.new("BodyVelocity") bv.Name = "FlyBV" bv.MaxForce = Vector3.new(9e9, 9e9, 9e9) bv.Velocity = Vector3.zero bv.Parent = root
    PlayerState.FlyBodyVelocity = bv
    local bg = Instance.new("BodyGyro") bg.Name = "FlyBG" bg.P = 9000 bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9) bg.CFrame = root.CFrame bg.Parent = root
    PlayerState.FlyBodyGyro = bg
    flyConn = RunService.RenderStepped:Connect(function()
        if not PlayerState.FlyEnabled or not char or not root or not root.Parent then stopFly() return end
        local cam = WS.CurrentCamera
        local moveVector = hum and hum.MoveDirection or Vector3.zero
        local look = cam.CFrame.LookVector
        local speed = PlayerState.FlySpeed
        local moveDir = Vector3.zero
        if moveVector.Magnitude > 0 then moveDir = (look * moveVector.Z + cam.CFrame.RightVector * moveVector.X).Unit * speed
        elseif UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = look * speed
        elseif UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = -look * speed
        elseif UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = -cam.CFrame.RightVector * speed
        elseif UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = cam.CFrame.RightVector * speed end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, speed, 0) end
        bv.Velocity = moveDir
        bg.CFrame = cam.CFrame
    end)
end
local function toggleFly(state) PlayerState.FlyEnabled = state if state then startFly() else stopFly() end end

local infJumpConn
local function toggleInfJump(state)
    PlayerState.InfiniteJumpEnabled = state
    if state then
        if not infJumpConn then
            infJumpConn = UIS.JumpRequest:Connect(function()
                if PlayerState.InfiniteJumpEnabled then
                    local hum = getHum()
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end
            end)
        end
    else
        if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    end
end

local spinConn
local function toggleSpinbot(state)
    PlayerState.SpinbotEnabled = state
    if state then
        if not spinConn then
            spinConn = RunService.Heartbeat:Connect(function(dt)
                local root = getRoot()
                local hum = getHum()
                if root and hum and PlayerState.SpinbotEnabled then
                    hum.AutoRotate = false
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(PlayerState.SpinbotSpeed * 360 * dt), 0)
                end
            end)
        end
    else
        if spinConn then spinConn:Disconnect() spinConn = nil end
        local hum = getHum() if hum then hum.AutoRotate = true end
    end
end

local invis = { active = false, pending = false, humanoid = nil, root = nil, parts = {}, lastReal = nil, renderReal = nil, ghostPos = nil, groundedFlip = false, hbConn = nil, rayParams = nil, rayChar = nil }
local function invisRefreshChar()
    local char = LP.Character invis.parts = {}
    if not char then invis.humanoid, invis.root = nil, nil return end
    invis.humanoid = char:FindFirstChildOfClass("Humanoid") invis.root = char:FindFirstChild("HumanoidRootPart")
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Transparency == 0 then
            local near = p.Name == "Head" or (p.Parent and p.Parent:IsA("Accessory")) or false
            table.insert(invis.parts, { part = p, near = near })
        end
    end
end
local function invisSetLocalTransparency(on)
    for _, item in ipairs(invis.parts) do
        if item.part and item.part.Parent then item.part.LocalTransparencyModifier = on and 0.5 or 0 end
    end
end
local function invisFirstPerson()
    local cam = WS.CurrentCamera if not cam then return false, nil end
    local camPos = cam.CFrame.Position
    if LP.CameraMode == Enum.CameraMode.LockFirstPerson then return true, camPos end
    local head = LP.Character and LP.Character:FindFirstChild("Head")
    return head ~= nil and (head.Position - camPos).Magnitude < 1.5, camPos
end
local function invisUnbind()
    pcall(function() RunService:UnbindFromRenderStep("ServaInvisRestore") end)
    pcall(function() RunService:UnbindFromRenderStep("ServaInvisGhost") end)
end
local function stopInvisibility()
    if not invis.active then return end
    invis.active, invis.pending = false, false
    if invis.hbConn then invis.hbConn:Disconnect() invis.hbConn = nil end
    invisUnbind() invisSetLocalTransparency(false)
    local root = invis.root
    if root and root.Parent then
        pcall(function() root.CFrame = invis.lastReal or root.CFrame end)
        pcall(function() root.AssemblyLinearVelocity = Vector3.zero root.AssemblyAngularVelocity = Vector3.zero end)
    end
end
local function startInvisibility()
    if invis.active then return end
    invisRefreshChar()
    if not invis.humanoid or not invis.root then return false end
    invis.active, invis.pending = true, false
    invisSetLocalTransparency(true)
    invis.hbConn = RunService.Heartbeat:Connect(function()
        if not invis.active then return end
        local hum, root = invis.humanoid, invis.root
        if not (hum and root and root.Parent) or root.Parent ~= LP.Character or hum.Health <= 0 then return end
        pcall(function()
            local moving = hum.MoveDirection.Magnitude > 0.01
            if not invis.rayParams then invis.rayParams = RaycastParams.new() invis.rayParams.FilterType = Enum.RaycastFilterType.Exclude end
            if invis.rayChar ~= LP.Character then invis.rayChar = LP.Character invis.rayParams.FilterDescendantsInstances = { LP.Character } end
            local grounded = WS:Raycast(root.Position, Vector3.new(0, -5, 0), invis.rayParams) ~= nil
            local real, offset = root.CFrame, -200000
            if grounded and not moving then
                invis.groundedFlip = not invis.groundedFlip
                if invis.groundedFlip then offset = -199999.5 end
            end
            invis.renderReal, invis.lastReal = real, real
            root.CFrame = real * CFrame.new(0, offset, 0)
            invis.ghostPos, invis.pending = root.Position, true
        end)
    end)
    pcall(function()
        RunService:BindToRenderStep("ServaInvisRestore", Enum.RenderPriority.Camera.Value - 1, function()
            local root = invis.root
            if invis.pending and root and root.Parent and invis.renderReal then
                if not invis.ghostPos or (root.Position - invis.ghostPos).Magnitude < 2 then pcall(function() root.CFrame = invis.renderReal end) end
                invis.pending = false
            end
        end)
    end)
    pcall(function()
        RunService:BindToRenderStep("ServaInvisGhost", Enum.RenderPriority.Camera.Value + 1, function()
            if not invis.active then return end
            local first, camPos = invisFirstPerson()
            for _, item in ipairs(invis.parts) do
                local part = item.part
                if part and part.Parent then
                    local alpha = 0.5
                    if first then
                        if item.near then alpha = 1
                        else
                            local dist = camPos and (part.Position - camPos).Magnitude or 99
                            if dist < 1.2 then alpha = 1
                            elseif dist < 2.4 then alpha = math.max(0.5, 1 - (dist - 1.2) / 1.2) end
                        end
                    end
                    part.LocalTransparencyModifier = alpha
                end
            end
        end)
    end)
    return true
end
local function toggleInvisibility(state)
    PlayerState.InvisibilityEnabled = state
    stopInvisibility()
    if state then if not startInvisibility() then PlayerState.InvisibilityEnabled = false end end
end

local antiFlingConns = {}
local safeCFrame = nil
local function toggleAntiFling(state)
    PlayerState.AntiFlingEnabled = state
    for _, c in ipairs(antiFlingConns) do c:Disconnect() end
    table.clear(antiFlingConns) safeCFrame = nil
    if not state then return end
    table.insert(antiFlingConns, RunService.Stepped:Connect(function()
        if not PlayerState.AntiFlingEnabled then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end
    end))
    table.insert(antiFlingConns, RunService.Stepped:Connect(function()
        if not PlayerState.AntiFlingEnabled then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not (hum and root) or hum.Health <= 0 then return end
        if PlayerState.FlyEnabled then safeCFrame = root.CFrame return end
        local vel = root.AssemblyLinearVelocity
        local horizontal = Vector3.new(vel.X, 0, vel.Z).Magnitude
        local vertical = math.abs(vel.Y)
        local angular = root.AssemblyAngularVelocity.Magnitude
        local hLimit = math.max(120, hum.WalkSpeed * 2 + 50)
        local flung = horizontal > hLimit or vertical > 500 or angular > 45
        if flung then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            if safeCFrame then root.CFrame = safeCFrame + Vector3.new(0, 2, 0) end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            hum.PlatformStand = false
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BodyAngularVelocity") or part:IsA("BodyVelocity") or part:IsA("BodyGyro") or part:IsA("BodyThrust") or part:IsA("AngularVelocity") or part:IsA("LinearVelocity") then
                    if part.Name ~= "FlyBV" and part.Name ~= "FlyBG" then part:Destroy() end
                end
            end
        elseif hum.FloorMaterial ~= Enum.Material.Air and horizontal < 60 and angular < 15 then safeCFrame = root.CFrame end
    end))
end

local grav = { on = false, value = 196, applied = false, baseGravity = WS.Gravity }
local function applyGravity()
    if grav.on then if math.abs(WS.Gravity - grav.value) > 0.01 then WS.Gravity = grav.value end grav.applied = true return end
    if grav.applied then grav.applied = false WS.Gravity = grav.baseGravity end
end
local function toggleGravity(state)
    grav.on = state PlayerState.GravityEnabled = state
    if state then grav.baseGravity = grav.baseGravity or WS.Gravity WS.Gravity = grav.value grav.applied = true
    else WS.Gravity = grav.baseGravity grav.applied = false end
end

local hip = { on = false, value = 2, humanoid = nil, base = nil }
local function applyHipHeight()
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if hip.on then
        if hip.humanoid ~= humanoid then hip.humanoid, hip.base = humanoid, humanoid.HipHeight end
        if math.abs(humanoid.HipHeight - hip.value) > 0.01 then humanoid.HipHeight = hip.value end
        return
    end
    if hip.humanoid and hip.humanoid == humanoid and hip.base then humanoid.HipHeight = hip.base end
    hip.humanoid, hip.base = nil, nil
end
local function toggleHipHeight(state) hip.on = state PlayerState.HipHeightEnabled = state applyHipHeight() end

local wallhop = { on = false, mode = "Press", angle = 90, camFlick = false, last = 0, press = 0, edgeAt = -1, edgeAir = false, used = -2, held = false, filterT = 0, back = nil, hops = 0 }
local whRays = RaycastParams.new() whRays.FilterType = Enum.RaycastFilterType.Exclude pcall(function() whRays.RespectCanCollide = true end)
local whOverlaps = OverlapParams.new() whOverlaps.FilterType = Enum.RaycastFilterType.Exclude pcall(function() whOverlaps.RespectCanCollide = true end) pcall(function() whOverlaps.MaxParts = 1 end)
local whDirections = {}
for i = 0, 7 do local ang = i * math.pi / 4 table.insert(whDirections, Vector3.new(math.sin(ang), 0, -math.cos(ang))) end

local function whFilter(character)
    local now = os.clock()
    if wallhop.fchar == character and now - wallhop.filterT < 1 then return end
    wallhop.fchar, wallhop.filterT = character, now
    local ignored = { character }
    for _, plr in ipairs(Players:GetPlayers()) do if plr.Character and plr.Character ~= character then table.insert(ignored, plr.Character) end end
    whRays.FilterDescendantsInstances = ignored whOverlaps.FilterDescendantsInstances = ignored
end
local function whJumpPower(hum) if hum.UseJumpPower then return math.max(hum.JumpPower, 20) end return math.sqrt(2 * WS.Gravity * math.max(hum.JumpHeight, 2)) end
local function whFindWall(character, hum, root)
    whFilter(character)
    local look = root.CFrame.LookVector
    local horizontal = Vector3.new(look.X, 0, look.Z)
    local rot = CFrame.Angles(0, horizontal.Magnitude > 0.01 and math.atan2(-horizontal.X, -horizontal.Z) or 0, 0)
    local distance = root.Size.X / 2 + 0.85
    local height = hum.RigType == Enum.HumanoidRigType.R6 and root.Size.Y / 2 + 2 or hum.HipHeight + root.Size.Y / 2
    local pos, now = root.Position, os.clock()
    local nearest, nearestDir, nearestDist
    local function cast(dir)
        for _, y in ipairs({ -height * 0.6, 0, root.Size.Y * 0.5 }) do
            local hit = WS:Raycast(pos + Vector3.new(0, y, 0), dir * distance, whRays)
            if hit and math.abs(hit.Normal.Y) < 0.4 and (not nearestDist or hit.Distance < nearestDist) then nearest, nearestDir, nearestDist = hit, dir, hit.Distance end
        end
    end
    local movement = hum.MoveDirection movement = Vector3.new(movement.X, 0, movement.Z)
    if movement.Magnitude > 0.1 then cast(movement.Unit) end
    for _, dir in ipairs(whDirections) do cast(rot:VectorToWorldSpace(dir)) end
    return nearest, nearestDir
end
local function whRotateCamera(angle, position)
    local cam = WS.CurrentCamera
    if cam then pcall(function() cam.CFrame = CFrame.new(position) * CFrame.Angles(0, angle, 0) * CFrame.new(-position) * cam.CFrame end) end
end
local whJumpConn, whSteppedConn
local function startWallHop()
    if whJumpConn then whJumpConn:Disconnect() whJumpConn = nil end
    if whSteppedConn then whSteppedConn:Disconnect() whSteppedConn = nil end
    whJumpConn = UIS.JumpRequest:Connect(function() wallhop.press = os.clock() end)
    whSteppedConn = RunService.Stepped:Connect(function()
        local character = LP.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        local now, back = os.clock(), wallhop.back
        if back and now >= back.t then
            wallhop.back = nil
            if back.hrp == root and root.Parent then pcall(function() root.CFrame = CFrame.new(root.Position) * back.rot end) end
            if back.cam then whRotateCamera(-back.cam, root.Position) end
            if back.ar then pcall(function() if back.ar.AutoRotate == false then back.ar.AutoRotate = true end end) end
        end
        local airborne = hum.FloorMaterial == Enum.Material.Air
        local pressed = hum.Jump or UIS:IsKeyDown(Enum.KeyCode.Space) or now - wallhop.press < 0.12
        if pressed and not wallhop.held then wallhop.edgeAt, wallhop.edgeAir = now, airborne end
        wallhop.held = pressed
        if not wallhop.on or wallhop.back or PlayerState.FlyEnabled or not airborne or now - wallhop.last < 0.25 then return end
        local current = hum:GetState()
        if current ~= Enum.HumanoidStateType.Freefall and current ~= Enum.HumanoidStateType.Jumping then return end
        local vertical, power = root.AssemblyLinearVelocity.Y, whJumpPower(hum)
        if wallhop.mode == "Hold" then if not pressed or vertical > power * 0.1 then return end
        else if not wallhop.edgeAir or wallhop.used == wallhop.edgeAt or now - wallhop.edgeAt > 0.15 or vertical > power * 0.7 then return end end
        local hit, dir = whFindWall(character, hum, root)
        if not hit then return end
        wallhop.last, wallhop.used = now, wallhop.edgeAt
        local normal = Vector3.new(hit.Normal.X, 0, hit.Normal.Z) normal = normal.Magnitude > 0.01 and normal.Unit or -dir
        local look = root.CFrame.LookVector look = Vector3.new(look.X, 0, look.Z)
        local sign = look.Magnitude > 0.01 and look:Cross(-normal).Y < 0 and -1 or 1
        local angle = math.rad(wallhop.angle) * sign
        local rot = root.CFrame - root.CFrame.Position
        local autoRotate = hum.AutoRotate and hum or nil
        if autoRotate then pcall(function() hum.AutoRotate = false end) end
        pcall(function() root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, angle, 0) * rot end)
        wallhop.back = { t = now + 0.05, rot = rot, hrp = root, cam = wallhop.camFlick and angle or nil, ar = autoRotate }
        if wallhop.camFlick then whRotateCamera(angle, root.Position) end
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
        wallhop.hops = (wallhop.hops or 0) + 1
    end)
end
local function stopWallHop()
    wallhop.on = false
    if whJumpConn then whJumpConn:Disconnect() whJumpConn = nil end
    if whSteppedConn then whSteppedConn:Disconnect() whSteppedConn = nil end
    if wallhop.back and wallhop.back.ar then pcall(function() wallhop.back.ar.AutoRotate = true end) end
    wallhop.back = nil
    local hum = getHum() if hum then hum.AutoRotate = true end
end
local function toggleWallHop(state) PlayerState.WallHopEnabled = state wallhop.on = state if state then startWallHop() else stopWallHop() end end

local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local moveSection = PlayerTab:Section({ Title = "Movement", Icon = "move", Opened = false })
moveSection:Slider({ Title = "WalkSpeed", Value = { Min = 16, Max = 500, Default = 16, Rounding = 1 }, Callback = function(v) local h = getHum() if h then h.WalkSpeed = v end end })
moveSection:Slider({ Title = "JumpPower", Value = { Min = 50, Max = 500, Default = 50, Rounding = 1 }, Callback = function(v) local h = getHum() if h then h.JumpPower = v end end })
moveSection:Toggle({ Title = "Infinite Jump", Value = false, Callback = toggleInfJump })
moveSection:Toggle({ Title = "Fly", Value = false, Callback = toggleFly })
moveSection:Slider({ Title = "Fly Speed", Value = { Min = 10, Max = 200, Default = 50, Rounding = 1 }, Callback = function(v) PlayerState.FlySpeed = v end })
moveSection:Toggle({ Title = "Noclip", Value = false, Callback = toggleNoclip })

local physSection = PlayerTab:Section({ Title = "Extra", Icon = "zap", Opened = false })
physSection:Toggle({ Title = "Spinbot", Value = false, Callback = toggleSpinbot })
physSection:Slider({ Title = "Spin Speed", Value = { Min = 1, Max = 10, Default = 3, Rounding = 1 }, Callback = function(v) PlayerState.SpinbotSpeed = v end })
physSection:Toggle({ Title = "Invisibility", Value = false, Callback = toggleInvisibility })
physSection:Toggle({ Title = "Anti Fling", Value = false, Callback = toggleAntiFling })
physSection:Toggle({ Title = "Gravity", Value = false, Callback = toggleGravity })
physSection:Slider({ Title = "Gravity Value", Value = { Min = 5, Max = 400, Default = 196, Rounding = 1 }, Callback = function(v) grav.value = tonumber(v) or 196 if grav.on then WS.Gravity = grav.value grav.applied = true end end })
physSection:Toggle({ Title = "Hip Height", Value = false, Callback = toggleHipHeight })
physSection:Slider({ Title = "Hip Height Value", Value = { Min = 0, Max = 30, Default = 2, Rounding = 0.1 }, Callback = function(v) hip.value = tonumber(v) or 2 if hip.on then applyHipHeight() end end })

local hopSection = PlayerTab:Section({ Title = "Wall Hop", Icon = "arrow-up-from-line", Opened = false })
hopSection:Toggle({ Title = "Wall Hop", Value = false, Callback = toggleWallHop })
hopSection:Dropdown({ Title = "Hop Mode", Values = { "Press", "Hold" }, Value = "Press", Callback = function(v) if v ~= "Press" and v ~= "Hold" then return end PlayerState.WallHopMode = v wallhop.mode = v end })
hopSection:Slider({ Title = "Flick Angle", Value = { Min = 30, Max = 180, Default = 90, Rounding = 1 }, Callback = function(v) PlayerState.WallHopAngle = v wallhop.angle = v end })
hopSection:Toggle({ Title = "Camera Flick", Value = false, Callback = function(v) PlayerState.WallHopCamFlick = not not v wallhop.camFlick = not not v end })

local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local espSection = VisualsTab:Section({ Title = "ESP Settings", Icon = "scan-eye", Opened = false })

local HAS_DRAWING = pcall(function() local d = Drawing.new("Line") d:Remove() end)
local espEnabled, boxEspEnabled, tracersEspEnabled, skeletonEspEnabled = false, false, false, false
local showNames, showDistance = false, false
local espColors = { normal = Color3.fromRGB(50, 255, 50), it = Color3.fromRGB(255, 50, 50) }
local espTransparency = 0.5
local highlights, nametags, drawings = {}, {}, {}

local function getBoxVertices(camera, hrp)
    local size = Vector3.new(4, 5, 1)
    local cf = hrp.CFrame
    local corners = { cf * CFrame.new(size.X/2, size.Y/2, 0), cf * CFrame.new(-size.X/2, size.Y/2, 0), cf * CFrame.new(-size.X/2, -size.Y/2, 0), cf * CFrame.new(size.X/2, -size.Y/2, 0) }
    local screenPts = {}
    for i, corner in ipairs(corners) do
        local pos, onScreen = camera:WorldToViewportPoint(corner.Position)
        screenPts[i] = { pos = Vector2.new(pos.X, pos.Y), onScreen = onScreen }
    end
    return screenPts
end
local function clearDrawings(plr)
    if drawings[plr] then
        for _, draw in pairs(drawings[plr]) do
            if type(draw) == "table" then for _, line in ipairs(draw) do pcall(function() line:Remove() end) end
            else pcall(function() draw:Remove() end) end
        end
        drawings[plr] = nil
    end
end
local function updateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local char, head, hrp = plr.Character, plr.Character:FindFirstChild("Head"), plr.Character:FindFirstChild("HumanoidRootPart")
            local isSeeker = ItValue and (tostring(ItValue.Value) == plr.Name or tostring(ItValue.Value) == plr.DisplayName)
            local color = isSeeker and espColors.it or espColors.normal
            if espEnabled then
                local hl = highlights[plr]
                if not hl or hl.Adornee ~= char then
                    if hl then hl:Destroy() end
                    hl = Instance.new("Highlight") hl.Adornee = char hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop hl.Parent = char highlights[plr] = hl
                end
                hl.FillColor = color hl.OutlineColor = color hl.FillTransparency = espTransparency
            elseif highlights[plr] then highlights[plr]:Destroy() highlights[plr] = nil end

            if HAS_DRAWING then
                drawings[plr] = drawings[plr] or {}
                local d = drawings[plr]
                if boxEspEnabled and hrp then
                    local pts = getBoxVertices(Camera, hrp)
                    d.box = d.box or { Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line") }
                    for i = 1, 4 do
                        local line = d.box[i]
                        local nextPt = pts[i == 4 and 1 or i + 1]
                        line.From = pts[i].pos line.To = nextPt.pos line.Color = color line.Thickness = 1.5 line.Transparency = 1
                        line.Visible = pts[i].onScreen and nextPt.onScreen
                    end
                elseif d.box then for _, l in ipairs(d.box) do l:Remove() end d.box = nil end

                if skeletonEspEnabled and head and hrp then
                    local rArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
                    local lArm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")
                    local rLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")
                    local lLeg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg")
                    if rArm and lArm and rLeg and lLeg then
                        d.skel = d.skel or { Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line") }
                        local bones = { { hrp.Position, head.Position }, { hrp.Position, rArm.Position }, { hrp.Position, lArm.Position }, { hrp.Position, rLeg.Position }, { hrp.Position, lLeg.Position } }
                        for i, bone in ipairs(bones) do
                            local p1, on1 = Camera:WorldToViewportPoint(bone[1])
                            local p2, on2 = Camera:WorldToViewportPoint(bone[2])
                            local line = d.skel[i]
                            line.From = Vector2.new(p1.X, p1.Y) line.To = Vector2.new(p2.X, p2.Y) line.Color = color line.Thickness = 1.5 line.Transparency = 1
                            line.Visible = on1 and on2
                        end
                    end
                elseif d.skel then for _, l in ipairs(d.skel) do l:Remove() end d.skel = nil end

                if tracersEspEnabled and hrp then
                    local p1, on = Camera:WorldToViewportPoint(hrp.Position)
                    d.tracer = d.tracer or Drawing.new("Line")
                    d.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    d.tracer.To = Vector2.new(p1.X, p1.Y) d.tracer.Color = color d.tracer.Thickness = 1.5 d.tracer.Transparency = 1
                    d.tracer.Visible = on and p1.Z > 0
                elseif d.tracer then d.tracer:Remove() d.tracer = nil end
            end

            if head and (showNames or showDistance) then
                local bb = nametags[plr]
                if not bb or bb.Parent ~= head then
                    if bb then bb:Destroy() end
                    bb = Instance.new("BillboardGui") bb.Size = UDim2.new(0, 200, 0, 50) bb.StudsOffset = Vector3.new(0, 2.5, 0) bb.AlwaysOnTop = true bb.Parent = head
                    local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1, 0, 1, 0) lbl.BackgroundTransparency = 1 lbl.TextStrokeTransparency = 0 lbl.Font = Enum.Font.GothamBold lbl.TextSize = 14 lbl.Parent = bb
                    nametags[plr] = bb
                end
                local lbl = bb:FindFirstChildOfClass("TextLabel")
                local myRoot = getRoot()
                local text = ""
                if showNames then text = plr.Name end
                if showDistance and myRoot and hrp then text = text .. (showNames and " | " or "") .. math.floor((myRoot.Position - hrp.Position).Magnitude) .. "m" end
                lbl.Text = text lbl.TextColor3 = color
            elseif nametags[plr] then nametags[plr]:Destroy() nametags[plr] = nil end
        end
    end
end
local function checkDead()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local char = plr.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                if highlights[plr] then highlights[plr]:Destroy() highlights[plr] = nil end
                if nametags[plr] then nametags[plr]:Destroy() nametags[plr] = nil end
                clearDrawings(plr)
            end
        end
    end
end

espSection:Toggle({ Title = "Player ESP", Value = false, Callback = function(v) espEnabled = v if not v then for plr in pairs(highlights) do if highlights[plr] then highlights[plr]:Destroy() highlights[plr] = nil end end end end })
espSection:Toggle({ Title = "Box ESP", Value = false, Callback = function(v) boxEspEnabled = v if not v then for plr in pairs(drawings) do if drawings[plr] and drawings[plr].box then for _, l in ipairs(drawings[plr].box) do l:Remove() end drawings[plr].box = nil end end end end })
espSection:Toggle({ Title = "Skeleton ESP", Value = false, Callback = function(v) skeletonEspEnabled = v if not v then for plr in pairs(drawings) do if drawings[plr] and drawings[plr].skel then for _, l in ipairs(drawings[plr].skel) do l:Remove() end drawings[plr].skel = nil end end end end })
espSection:Toggle({ Title = "Tracers ESP", Value = false, Callback = function(v) tracersEspEnabled = v if not v then for plr in pairs(drawings) do if drawings[plr] and drawings[plr].tracer then drawings[plr].tracer:Remove() drawings[plr].tracer = nil end end end end })
espSection:Colorpicker({ Title = "Player ESP Color", Default = espColors.normal, Callback = function(v) espColors.normal = v end })
espSection:Colorpicker({ Title = "Seeker ESP Color", Default = espColors.it, Callback = function(v) espColors.it = v end })
espSection:Slider({ Title = "ESP Transparency", Value = { Min = 0, Max = 1, Default = 0.5, Rounding = 0.1 }, Callback = function(v) espTransparency = v end })
espSection:Toggle({ Title = "Show Names", Value = false, Callback = function(v) showNames = v end })
espSection:Toggle({ Title = "Show Distance Meters", Value = false, Callback = function(v) showDistance = v end })

RunService.RenderStepped:Connect(function()
    if espEnabled or boxEspEnabled or tracersEspEnabled or skeletonEspEnabled or showNames or showDistance then updateESP() checkDead() end
end)

local TrollTab = Window:Tab({ Title = "Troll", Icon = "laugh" })
local flingSection = TrollTab:Section({ Title = "Fling", Icon = "wind", Opened = false })
local isFlinging = false

flingSection:Toggle({ Title = "Fling All Players", Value = false, Callback = function(v)
    isFlinging = v
    if v then
        task.spawn(function()
            while isFlinging do
                local myRoot = getRoot()
                if myRoot then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LP and plr.Character then
                            local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                            if targetRoot then
                                myRoot.CFrame = targetRoot.CFrame
                                myRoot.AssemblyLinearVelocity = Vector3.new(9e6, 9e6, 9e6)
                                myRoot.AssemblyAngularVelocity = Vector3.new(9e6, 9e6, 9e6)
                                task.wait(0.1)
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end })

local playerList = {}
local function refreshPlayerList()
    playerList = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then table.insert(playerList, plr.Name) end
    end
    if #playerList == 0 then playerList = {"(No players)"} end
    return playerList
end

local targetDropdown = flingSection:Dropdown({ Title = "Select Player", Values = refreshPlayerList(), Value = "(No players)", Callback = function(v) end })
flingSection:Button({ Title = "Fling Selected Player", Icon = "wind", Callback = function()
    local targetName = targetDropdown.Value
    local targetPlr = Players:FindFirstChild(targetName)
    if targetPlr and targetPlr.Character then
        local myRoot = getRoot()
        local targetRoot = targetPlr.Character:FindFirstChild("HumanoidRootPart")
        if myRoot and targetRoot then
            task.spawn(function()
                local t0 = os.clock()
                while os.clock() - t0 < 1.5 do
                    myRoot.CFrame = targetRoot.CFrame
                    myRoot.AssemblyLinearVelocity = Vector3.new(9e6, 9e6, 9e6)
                    myRoot.AssemblyAngularVelocity = Vector3.new(9e6, 9e6, 9e6)
                    task.wait()
                end
                myRoot.AssemblyLinearVelocity = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end
end })
flingSection:Button({ Title = "Refresh Player List", Icon = "refresh-cw", Callback = function() targetDropdown:Refresh(refreshPlayerList()) end })

local TeleportsTab = Window:Tab({ Title = "Teleports", Icon = "map-pin" })
local tpPlayersSection = TeleportsTab:Section({ Title = "Players", Icon = "users", Opened = false })
local tpPlayerList = {}
local function refreshTpList()
    tpPlayerList = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then table.insert(tpPlayerList, plr.Name) end
    end
    if #tpPlayerList == 0 then tpPlayerList = {"(No players)"} end
    return tpPlayerList
end
local tpDropdown = tpPlayersSection:Dropdown({ Title = "Select Player", Values = refreshTpList(), Value = "(No players)", Callback = function(v) end })
tpPlayersSection:Button({ Title = "Teleport to Player", Icon = "map-pin", Callback = function()
    local targetName = tpDropdown.Value
    local targetPlr = Players:FindFirstChild(targetName)
    if targetPlr and targetPlr.Character then
        local myRoot = getRoot()
        local targetRoot = targetPlr.Character:FindFirstChild("HumanoidRootPart")
        if myRoot and targetRoot then myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 2, 0) end
    end
end })
tpPlayersSection:Button({ Title = "Teleport to Seeker", Icon = "target", Callback = function()
    if ItValue then
        local seeker = Players:FindFirstChild(tostring(ItValue.Value))
        if seeker and seeker.Character then
            local myRoot = getRoot()
            local sRoot = seeker.Character:FindFirstChild("HumanoidRootPart")
            if myRoot and sRoot then myRoot.CFrame = sRoot.CFrame + Vector3.new(0, 3, 0) end
        end
    end
end })
tpPlayersSection:Button({ Title = "Refresh List", Icon = "refresh-cw", Callback = function() tpDropdown:Refresh(refreshTpList()) end })

local FarmTab = Window:Tab({ Title = "Farm", Icon = "pickaxe" })
local farmSection = FarmTab:Section({ Title = "Farm", Icon = "pickaxe", Opened = false })
farmSection:Toggle({ Title = "Auto Collect Coins", Value = false, Callback = function(v)
    if v then
        task.spawn(function()
            while task.wait(0.5) do
                local root = getRoot()
                if root and InGameValue and InGameValue.Value then
                    for _, v2 in pairs(WS:GetDescendants()) do
                        if v2.Name == "Credit" and v2:IsA("BasePart") then root.CFrame = v2.CFrame task.wait(0.05) end
                    end
                end
            end
        end)
    end
end })

local MiscTab = Window:Tab({ Title = "Misc", Icon = "wrench" })
local musicSection = MiscTab:Section({ Title = "Music Local", Icon = "music", Opened = false })
local sound = Instance.new("Sound") sound.Parent = game:GetService("SoundService")
musicSection:Input({ Title = "Audio ID", Placeholder = "Enter audio ID...", Callback = function(v) local id = tostring(v):match("%d+") if id then sound.SoundId = "rbxassetid://" .. id end end })
musicSection:Button({ Title = "Play Music", Icon = "play", Callback = function() sound:Play() end })
musicSection:Button({ Title = "Stop Music", Icon = "square", Callback = function() sound:Stop() end })

Window:Divider()

local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

local miscSettings = SettingsTab:Section({ Title = "Misc", Icon = "shield", Opened = false })
miscSettings:Toggle({ Title = "Anti AFK", Value = true, Callback = function(v)
    if v then
        LP.Idled:Connect(function()
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end })
miscSettings:Toggle({ Title = "Auto Rejoin (On Kick)", Value = false, Callback = function(v)
    if v then
        game:GetService("GuiService").ErrorMessageChanged:Connect(function(msg)
            if msg and msg ~= "" then
                task.wait(1)
                game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
            end
        end)
    end
end })

local perfSection = SettingsTab:Section({ Title = "Performance", Icon = "activity", Opened = false })
perfSection:Slider({ Title = "FPS Cap", Value = { Min = 15, Max = 240, Default = 60, Rounding = 5 }, Callback = function(v) SetFpsCap(v) end })
perfSection:Toggle({ Title = "Hide Players", Value = false, Callback = function(v)
    if v then
        task.spawn(function()
            while task.wait(0.5) do
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        for _, d in ipairs(plr.Character:GetDescendants()) do
                            if d:IsA("BasePart") or d:IsA("Decal") then d.LocalTransparencyModifier = 1 end
                        end
                    end
                end
            end
        end)
    end
end })

local uiSection = SettingsTab:Section({ Title = "UI Settings", Icon = "monitor", Opened = false })
uiSection:Toggle({ Title = "Screen Stretch", Value = false, Callback = function(v) getgenv().Resolution = getgenv().Resolution or {} if v then getgenv().Resolution[".gg/scripters"] = 0.65 else getgenv().Resolution[".gg/scripters"] = 1.0 end end })
uiSection:Input({ Title = "Background Transparency", Placeholder = "0 to 1...", Value = "0.6", Callback = function(text) local num = tonumber(text) if num then num = math.clamp(num, 0, 1) pcall(function() Window:SetBackgroundImageTransparency(num) end) pcall(function() for _, v in pairs(Window.Gui:GetDescendants()) do if v:IsA("ImageLabel") and v.Name:lower():find("background") then v.ImageTransparency = num end end end) end end })
uiSection:Keybind({ Title = "Toggle UI Keybind", Value = "H", Callback = function() pcall(function() Window:Toggle() end) end })
uiSection:Button({ Title = "Toggle UI (Hide/Show)", Icon = "eye-off", Callback = function() pcall(function() Window:Toggle() end) end })

bind(LP.CharacterAdded:Connect(function(newChar)
    task.wait(1) table.clear(originalCollisions) if noclipConn then noclipConn:Disconnect() noclipConn = nil end safeCFrame = nil
    if PlayerState.NoclipEnabled then toggleNoclip(true) end
    if PlayerState.InvisibilityEnabled then toggleInvisibility(true) end
    if PlayerState.SpinbotEnabled then toggleSpinbot(true) end
    if PlayerState.FlyEnabled then startFly() end
    if PlayerState.AntiFlingEnabled then toggleAntiFling(true) end
    if PlayerState.HipHeightEnabled then applyHipHeight() end
end))

task.spawn(function()
    local Camera = WS.CurrentCamera getgenv().Resolution = getgenv().Resolution or {}
    if not getgenv().gg_scripters then
        getgenv().gg_scripters = true
        RunService.RenderStepped:Connect(function()
            if Camera and Camera.Parent then
                local current = getgenv().Resolution[".gg/scripters"] or 1.0
                Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, current, 0, 0, 0, 1)
            end
        end)
    end
end)

Hub.unload = function()
    Hub.unloaded = true isFlinging = false
    pcall(stopWallHop) pcall(stopInvisibility) pcall(stopFly)
    if grav.applied then WS.Gravity = grav.baseGravity end
    for _, c in ipairs(Hub.conns) do pcall(function() c:Disconnect() end) end table.clear(Hub.conns)
end

local FpsTag, PingTag
    pcall(function()
        FpsTag = Window:Tag({ Title = "FPS: --", Icon = "gauge", Color = Color3.fromHex("#89CFF0"), Radius = 8, TextSize = 11 })
        PingTag = Window:Tag({ Title = "Ping: --", Icon = "wifi", Color = Color3.fromHex("#89CFF0"), Radius = 8, TextSize = 11 })
    end)

    pcall(function()
        Window:Tag({ Title = (identifyexecutor and identifyexecutor() or "Unknown"), Icon = "cpu", Color = Color3.fromHex("#89CFF0"), Radius = 8, TextSize = 11 })
    end)

    local frames, lastTick = 0, os.clock()
    local fallbackFps = 0
    bind(RunService.RenderStepped:Connect(function()
        frames += 1
        local now = os.clock()
        if now - lastTick >= 1 then
            fallbackFps = frames
            frames = 0
            lastTick = now
        end
    end))

    task.spawn(function()
        while not Hub.unloaded do
            task.wait(0.5)
            if FpsTag then
                local fps = fallbackFps
                local manager = Stats:FindFirstChild("FrameRateManager")
                local RenderAverage = manager and manager:FindFirstChild("RenderAverage")
                if RenderAverage then
                    local ok, ms = pcall(function() return RenderAverage:GetValue() end)
                    if ok and type(ms) == "number" and ms > 0 then fps = math.floor(1000 / ms) end
                end
                pcall(function() FpsTag:SetTitle("FPS: " .. fps) end)
            end
            if PingTag then
                local ping = LP:GetNetworkPing() * 1000
                pcall(function() PingTag:SetTitle("Ping: " .. math.floor(ping + 0.5)) end)
            end
        end
    end)
