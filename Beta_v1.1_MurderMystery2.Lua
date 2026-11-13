local function LoadServaHub()
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local WS = workspace
    local UIS = game:GetService("UserInputService")
    local VirtualUser = game:GetService("VirtualUser")
    local Stats = game:GetService("Stats")
    local RS = game:GetService("ReplicatedStorage")
    local Lighting = game:GetService("Lighting")
    local HttpService = game:GetService("HttpService")

    
    local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    pcall(function() WindUI.Notify = function() end end)

    pcall(function()
        game.StarterGui:SetCore('SendNotification', {
            Title = 'Serva Hub',
            Text = 'Please wait a few seconds, the script is loading...',
            Icon = 'rbxassetid://136463464698564',
            Duration = 5,
        })
    end)

    local Window = WindUI:CreateWindow({
        Title = "Serva Hub", 
        Icon = "rbxassetid://136463464698564", 
        IconSize = 35,
        Author = '<font color="rgb(124, 145, 181)">Murder Mystery 2</font>',
        Background = "rbxassetid://102252256446593",
        Transparent = true, 
        User = { Enabled = true, Anonymous = false },
        Theme = "Dark"
    })

    pcall(function()
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
    end)

    pcall(function() Window:SetBackgroundImageTransparency(0.6) end)

    pcall(function()
        Window:EditOpenButton({
            Title = "Serva Hub", Icon = "rbxassetid://136463464698564", CornerRadius = UDim.new(0, 16), StrokeThickness = 2,
            Color = Color3.fromHex("#89CFF0"), Color = ColorSequence.new(Color3.fromHex("#89CFF0"), Color3.fromHex("#2A4B8D")),
            Enabled = true, Draggable = true,
        })
    end)

    local Hub = { conns = {}, unloaded = false }
    _G.CookiesHubKL = Hub

    local function bind(c) table.insert(Hub.conns, c) return c end
    local function getHum() local c = LP.Character return c and c:FindFirstChildOfClass("Humanoid") end
    local function getRoot() local c = LP.Character return c and c:FindFirstChild("HumanoidRootPart") end

    if not LP.Character then pcall(function() LP.CharacterAdded:Wait() end) end
    local h0 = getHum()
    local cam0 = WS.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
    local Defaults = {
        WalkSpeed = h0 and h0.WalkSpeed or 16,
        JumpPower = h0 and h0.JumpPower or 50,
        JumpMode  = h0 and h0.UseJumpPower or true,
        HipHeight = h0 and h0.HipHeight or 2,
        FOV       = cam0 and cam0.FieldOfView or 70,
    }

    local Settings = {
        Fullbright = false,
        UITransparency = 0, AntiAFK = true, HidePlayers = false, FPSCap = 60, AntiLag = false,
        ScreenStretch = false,
    }

    local touched, appliers = {}, {}
    local TOUCH_KEYS = { WalkSpeed = true, JumpPower = true, HipHeight = true, FOV = true, FPSCap = true }

    local function setSetting(key, value)
        Settings[key] = value
        if TOUCH_KEYS[key] then touched[key] = true end
        local apply = appliers[key]
        if apply then pcall(apply, value) end
    end

    local PlayerState = {
        FlyEnabled = false,
        FlySpeed = 50,
        FlyBodyVelocity = nil,
        FlyBodyGyro = nil,
        InfiniteJumpEnabled = false,
        NoclipEnabled = false,
        SpinbotEnabled = false,
        SpinbotSpeed = 3,
        InvisibilityEnabled = false,
        AntiFlingEnabled = false,
        XrayEnabled = false,
        XrayStrength = 0.7,
        WallHopEnabled = false,
        WallHopMode = "Press",
        WallHopAngle = 90,
        WallHopCamFlick = false,
        GravityEnabled = false,
        GravityValue = 196,
        HipHeightEnabled = false,
        HipHeightValue = 2,
        NoclipCamEnabled = false,
        BombJumpEnabled = false,
        AntiCoinEnabled = false,
        AntiAimEnabled = false,
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
                            if originalCollisions[part] == nil then
                                originalCollisions[part] = part.CanCollide 
                            end
                            if part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            if noclipConn then
                noclipConn:Disconnect()
                noclipConn = nil
            end
            for part, canCollide in pairs(originalCollisions) do
                if part and part.Parent then
                    part.CanCollide = canCollide
                end
            end
            table.clear(originalCollisions)
        end
    end

    
    local antiFlingConns = {}
    local safeCFrame = nil

    local function toggleAntiFling(state)
        PlayerState.AntiFlingEnabled = state

        for _, c in ipairs(antiFlingConns) do c:Disconnect() end
        table.clear(antiFlingConns)
        safeCFrame = nil

        if not state then return end

        table.insert(antiFlingConns, RunService.Stepped:Connect(function()
            if not PlayerState.AntiFlingEnabled then return end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
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

            if PlayerState.FlyEnabled then
                safeCFrame = root.CFrame
                return
            end

            local vel = root.AssemblyLinearVelocity
            local horizontal = Vector3.new(vel.X, 0, vel.Z).Magnitude
            local vertical = math.abs(vel.Y)
            local angular = root.AssemblyAngularVelocity.Magnitude

            local hLimit = math.max(120, hum.WalkSpeed * 2 + 50)
            local flung = horizontal > hLimit or vertical > 500 or angular > 45

            if flung then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero

                if safeCFrame then
                    root.CFrame = safeCFrame + Vector3.new(0, 2, 0)
                end

                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                hum.PlatformStand = false

                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BodyAngularVelocity") or part:IsA("BodyVelocity")
                        or part:IsA("BodyGyro") or part:IsA("BodyThrust")
                        or part:IsA("AngularVelocity") or part:IsA("LinearVelocity") then
                        if part.Name ~= "FlyBV" and part.Name ~= "FlyBG" then
                            part:Destroy()
                        end
                    end
                end
            elseif hum.FloorMaterial ~= Enum.Material.Air and horizontal < 60 and angular < 15 then
                safeCFrame = root.CFrame
            end
        end))
    end

    
    local invis = {
        active = false, pending = false,
        humanoid = nil, root = nil, parts = {},
        lastReal = nil, renderReal = nil, ghostPos = nil,
        groundedFlip = false, hbConn = nil,
        rayParams = nil, rayChar = nil,
    }

    local function invisRefreshChar()
        local char = LP.Character
        invis.parts = {}
        if not char then invis.humanoid, invis.root = nil, nil return end
        invis.humanoid = char:FindFirstChildOfClass("Humanoid")
        invis.root = char:FindFirstChild("HumanoidRootPart")
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Transparency == 0 then
                local near = p.Name == "Head" or (p.Parent and p.Parent:IsA("Accessory")) or false
                table.insert(invis.parts, { part = p, near = near })
            end
        end
    end

    local function invisSetLocalTransparency(on)
        for _, item in ipairs(invis.parts) do
            if item.part and item.part.Parent then
                item.part.LocalTransparencyModifier = on and 0.5 or 0
            end
        end
    end

    local function invisFirstPerson()
        local cam = WS.CurrentCamera
        if not cam then return false, nil end
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
        invisUnbind()
        invisSetLocalTransparency(false)

        local root = invis.root
        if root and root.Parent then
            pcall(function() root.CFrame = invis.lastReal or root.CFrame end)
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end)
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
            if not (hum and root and root.Parent) or root.Parent ~= LP.Character or hum.Health <= 0 then
                return
            end

            pcall(function()
                local moving = hum.MoveDirection.Magnitude > 0.01

                if not invis.rayParams then
                    invis.rayParams = RaycastParams.new()
                    invis.rayParams.FilterType = Enum.RaycastFilterType.Exclude
                end
                if invis.rayChar ~= LP.Character then
                    invis.rayChar = LP.Character
                    invis.rayParams.FilterDescendantsInstances = { LP.Character }
                end

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
                    if not invis.ghostPos or (root.Position - invis.ghostPos).Magnitude < 2 then
                        pcall(function() root.CFrame = invis.renderReal end)
                    end
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
                            if item.near then
                                alpha = 1
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
        if state then
            if not startInvisibility() then
                PlayerState.InvisibilityEnabled = false
            end
        end
    end

    -- Infinite Jump
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
            if infJumpConn then
                infJumpConn:Disconnect()
                infJumpConn = nil
            end
        end
    end

    -- Fly
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

        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyBV"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.zero
        bv.Parent = root
        PlayerState.FlyBodyVelocity = bv

        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyBG"
        bg.P = 9000
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = root.CFrame
        bg.Parent = root
        PlayerState.FlyBodyGyro = bg

        flyConn = RunService.RenderStepped:Connect(function()
            if not PlayerState.FlyEnabled or not char or not root or not root.Parent then
                stopFly()
                return
            end
            local cam = WS.CurrentCamera
            local moveVector = hum and hum.MoveDirection or Vector3.zero
            local look = cam.CFrame.LookVector
            
            local speed = PlayerState.FlySpeed
            local moveDir = Vector3.zero
            
            if moveVector.Magnitude > 0 then
                moveDir = (look * moveVector.Z + cam.CFrame.RightVector * moveVector.X).Unit * speed
            elseif UIS:IsKeyDown(Enum.KeyCode.W) then
                moveDir = look * speed
            elseif UIS:IsKeyDown(Enum.KeyCode.S) then
                moveDir = -look * speed
            elseif UIS:IsKeyDown(Enum.KeyCode.A) then
                moveDir = -cam.CFrame.RightVector * speed
            elseif UIS:IsKeyDown(Enum.KeyCode.D) then
                moveDir = cam.CFrame.RightVector * speed
            end
            
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, speed, 0)
            end
            
            bv.Velocity = moveDir
            bg.CFrame = cam.CFrame
        end)
    end

    local function toggleFly(state)
        PlayerState.FlyEnabled = state
        if state then startFly() else stopFly() end
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
            local hum = getHum()
            if hum then hum.AutoRotate = true end
        end
    end

    local xray = {
        original = {},
        queue = {},
        index = 1,
        lastRefresh = 0,
    }
    getgenv().__servaXrayOrig = xray.original

    local function xrayEligible(part)
        if not part:IsA("BasePart") or part:IsA("Terrain") or part.Transparency >= 1 then
            return false
        end
        local model = part:FindFirstAncestorWhichIsA("Model")
        while model do
            if Players:GetPlayerFromCharacter(model) then return false end
            model = model.Parent and model.Parent:FindFirstAncestorWhichIsA("Model") or nil
        end
        return true
    end

    local function xrayOpacity(value)
        return value + (1 - value) * PlayerState.XrayStrength
    end

    local function xrayRefresh()
        for part, transparency in pairs(xray.original) do
            if part.Parent then
                part.Transparency = xrayOpacity(transparency)
            else
                xray.original[part] = nil
            end
        end
    end

    local function xrayRestore()
        for part, transparency in pairs(xray.original) do
            if part.Parent then part.Transparency = transparency end
            xray.original[part] = nil
        end
        xray.queue, xray.index = {}, 1
    end

    local function xrayStart()
        local prev = getgenv().__servaXrayOrig
        if type(prev) == "table" and prev ~= xray.original then
            for part, transparency in pairs(prev) do
                pcall(function() if part.Parent then part.Transparency = transparency end end)
            end
        end
        xray.queue = WS:GetDescendants()
        xray.index = 1
    end

    local function toggleXray(state)
        PlayerState.XrayEnabled = state
        if state then
            xrayStart()
        else
            xrayRestore()
        end
    end
    getgenv().__servaToggleXray = toggleXray

    bind(RunService.Heartbeat:Connect(function()
        if xray.index > #xray.queue then return end
        if not PlayerState.XrayEnabled then
            xray.queue, xray.index = {}, 1
            return
        end

        local processed = 0
        while xray.index <= #xray.queue and processed < 180 do
            local part = xray.queue[xray.index]
            xray.index += 1
            processed += 1
            if part and part.Parent and xray.original[part] == nil and xrayEligible(part) then
                xray.original[part] = part.Transparency
                part.Transparency = xrayOpacity(part.Transparency)
            end
        end
        if xray.index > #xray.queue then
            xray.queue, xray.index = {}, 1
        end
    end))

    bind(WS.DescendantAdded:Connect(function(part)
        if PlayerState.XrayEnabled and part:IsA("BasePart") then
            table.insert(xray.queue, part)
        end
    end))

    local wallhop = {
        on = false, mode = "Press", angle = 90, camFlick = false,
        last = 0, press = 0, edgeAt = -1, edgeAir = false,
        used = -2, held = false, filterT = 0, back = nil, hops = 0,
    }
    getgenv().__servaWallHop = wallhop

    local whRays = RaycastParams.new()
    whRays.FilterType = Enum.RaycastFilterType.Exclude
    pcall(function() whRays.RespectCanCollide = true end)

    local whOverlaps = OverlapParams.new()
    whOverlaps.FilterType = Enum.RaycastFilterType.Exclude
    pcall(function() whOverlaps.RespectCanCollide = true end)
    pcall(function() whOverlaps.MaxParts = 1 end)

    local whDirections = {}
    for i = 0, 7 do
        local ang = i * math.pi / 4
        table.insert(whDirections, Vector3.new(math.sin(ang), 0, -math.cos(ang)))
    end

    local function whFilter(character)
        local now = os.clock()
        if wallhop.fchar == character and now - wallhop.filterT < 1 then return end
        wallhop.fchar, wallhop.filterT = character, now
        local ignored = { character }
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character ~= character then
                table.insert(ignored, plr.Character)
            end
        end
        local platform = WS:FindFirstChild("PulseAirWalk")
        if platform then table.insert(ignored, platform) end
        whRays.FilterDescendantsInstances = ignored
        whOverlaps.FilterDescendantsInstances = ignored
    end

    local function whJumpPower(hum)
        if hum.UseJumpPower then return math.max(hum.JumpPower, 20) end
        return math.sqrt(2 * WS.Gravity * math.max(hum.JumpHeight, 2))
    end

    local function whFindWall(character, hum, root)
        whFilter(character)
        local look = root.CFrame.LookVector
        local horizontal = Vector3.new(look.X, 0, look.Z)
        local rot = CFrame.Angles(0, horizontal.Magnitude > 0.01 and math.atan2(-horizontal.X, -horizontal.Z) or 0, 0)
        local distance = root.Size.X / 2 + 0.85
        local height = hum.RigType == Enum.HumanoidRigType.R6
            and root.Size.Y / 2 + 2
            or hum.HipHeight + root.Size.Y / 2
        local pos, now = root.Position, os.clock()
        if not wallhop.terrAt or now - wallhop.terrAt > 15 then
            wallhop.terrAt = now
            local ok, cells = pcall(function() return WS.Terrain:CountCells() end)
            wallhop.noTerrain = ok and cells == 0
        end
        if wallhop.noTerrain then
            local vertical = math.max(height * 0.6, root.Size.Y * 0.5)
            local ok, nearby = pcall(function()
                return WS:GetPartBoundsInRadius(pos, math.sqrt(distance * distance + vertical * vertical) + 0.25, whOverlaps)
            end)
            if ok and type(nearby) == "table" and #nearby == 0 then return nil end
        end
        local nearest, nearestDir, nearestDist
        local function cast(dir)
            for _, y in ipairs({ -height * 0.6, 0, root.Size.Y * 0.5 }) do
                local hit = WS:Raycast(pos + Vector3.new(0, y, 0), dir * distance, whRays)
                if hit and math.abs(hit.Normal.Y) < 0.4 and (not nearestDist or hit.Distance < nearestDist) then
                    nearest, nearestDir, nearestDist = hit, dir, hit.Distance
                end
            end
        end
        local movement = hum.MoveDirection
        movement = Vector3.new(movement.X, 0, movement.Z)
        if movement.Magnitude > 0.1 then cast(movement.Unit) end
        for _, dir in ipairs(whDirections) do cast(rot:VectorToWorldSpace(dir)) end
        return nearest, nearestDir
    end

    local function whRotateCamera(angle, position)
        local cam = WS.CurrentCamera
        if cam then
            pcall(function()
                cam.CFrame = CFrame.new(position) * CFrame.Angles(0, angle, 0) * CFrame.new(-position) * cam.CFrame
            end)
        end
    end

    local whJumpConn, whSteppedConn

    local function startWallHop()
        if whJumpConn then whJumpConn:Disconnect() whJumpConn = nil end
        if whSteppedConn then whSteppedConn:Disconnect() whSteppedConn = nil end

        whJumpConn = UIS.JumpRequest:Connect(function()
            wallhop.press = os.clock()
        end)

        whSteppedConn = RunService.Stepped:Connect(function()
            local character = LP.Character
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not hum or not root or hum.Health <= 0 then return end

            local now, back = os.clock(), wallhop.back
            if back and now >= back.t then
                wallhop.back = nil
                if back.hrp == root and root.Parent then
                    pcall(function() root.CFrame = CFrame.new(root.Position) * back.rot end)
                end
                if back.cam then whRotateCamera(-back.cam, root.Position) end
                if back.ar then pcall(function() if back.ar.AutoRotate == false then back.ar.AutoRotate = true end end) end
            end

            local airborne = hum.FloorMaterial == Enum.Material.Air
            local pressed = hum.Jump or UIS:IsKeyDown(Enum.KeyCode.Space) or now - wallhop.press < 0.12
            if pressed and not wallhop.held then
                wallhop.edgeAt, wallhop.edgeAir = now, airborne
            end
            wallhop.held = pressed

            if not wallhop.on or wallhop.back or PlayerState.FlyEnabled or not airborne
                or now - wallhop.last < 0.25 then
                return
            end
            local current = hum:GetState()
            if current ~= Enum.HumanoidStateType.Freefall
                and current ~= Enum.HumanoidStateType.Jumping then
                return
            end

            local vertical, power = root.AssemblyLinearVelocity.Y, whJumpPower(hum)
            if wallhop.mode == "Hold" then
                if not pressed or vertical > power * 0.1 then return end
            else
                if not wallhop.edgeAir or wallhop.used == wallhop.edgeAt
                    or now - wallhop.edgeAt > 0.15 or vertical > power * 0.7 then
                    return
                end
            end

            local hit, dir = whFindWall(character, hum, root)
            if not hit then return end

            wallhop.last, wallhop.used = now, wallhop.edgeAt
            local normal = Vector3.new(hit.Normal.X, 0, hit.Normal.Z)
            normal = normal.Magnitude > 0.01 and normal.Unit or -dir
            local look = root.CFrame.LookVector
            look = Vector3.new(look.X, 0, look.Z)
            local sign = look.Magnitude > 0.01 and look:Cross(-normal).Y < 0 and -1 or 1
            local angle = math.rad(wallhop.angle) * sign
            local rot = root.CFrame - root.CFrame.Position
            local autoRotate = hum.AutoRotate and hum or nil
            if autoRotate then pcall(function() hum.AutoRotate = false end) end
            pcall(function()
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, angle, 0) * rot
            end)
            wallhop.back = {
                t = now + 0.05, rot = rot, hrp = root,
                cam = wallhop.camFlick and angle or nil, ar = autoRotate,
            }
            if wallhop.camFlick then whRotateCamera(angle, root.Position) end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
            wallhop.hops = (wallhop.hops or 0) + 1
        end)
    end

    local function stopWallHop()
        wallhop.on = false
        if whJumpConn then whJumpConn:Disconnect() whJumpConn = nil end
        if whSteppedConn then whSteppedConn:Disconnect() whSteppedConn = nil end
        if wallhop.back and wallhop.back.ar then
            pcall(function() wallhop.back.ar.AutoRotate = true end)
        end
        wallhop.back = nil
        local hum = getHum()
        if hum then hum.AutoRotate = true end
    end

    local function toggleWallHop(state)
        PlayerState.WallHopEnabled = state
        wallhop.on = state
        if state then startWallHop() else stopWallHop() end
    end
    getgenv().__servaToggleWallHop = toggleWallHop

    local grav = { on = false, value = 196, applied = false, baseGravity = WS.Gravity }
    getgenv().__servaGravity = grav

    local function applyGravity()
        if grav.on then
            if math.abs(WS.Gravity - grav.value) > 0.01 then
                WS.Gravity = grav.value
            end
            grav.applied = true
            return
        end
        if grav.applied then
            grav.applied = false
            WS.Gravity = grav.baseGravity
        end
    end

    local function toggleGravity(state)
        grav.on = state
        PlayerState.GravityEnabled = state
        if state then
            grav.baseGravity = grav.baseGravity or WS.Gravity
            WS.Gravity = grav.value
            grav.applied = true
        else
            WS.Gravity = grav.baseGravity
            grav.applied = false
        end
    end
    getgenv().__servaToggleGravity = toggleGravity

    local hip = { on = false, value = 2, humanoid = nil, base = nil }
    getgenv().__servaHip = hip

    local function applyHipHeight()
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        if hip.on then
            if hip.humanoid ~= humanoid then
                hip.humanoid, hip.base = humanoid, humanoid.HipHeight
            end
            if math.abs(humanoid.HipHeight - hip.value) > 0.01 then
                humanoid.HipHeight = hip.value
            end
            return
        end
        if hip.humanoid and hip.humanoid == humanoid and hip.base then
            humanoid.HipHeight = hip.base
        end
        hip.humanoid, hip.base = nil, nil
    end

    local function toggleHipHeight(state)
        hip.on = state
        PlayerState.HipHeightEnabled = state
        applyHipHeight()
    end
    getgenv().__servaToggleHip = toggleHipHeight

    local noclipCamState = { on = false, hooked = false, mode = nil }
    local camPreviousMode = nil

    local function findPopper()
        local scripts = LP:FindFirstChild("PlayerScripts")
        local playerModule = scripts and scripts:FindFirstChild("PlayerModule")
        local cameraModule = playerModule and playerModule:FindFirstChild("CameraModule")
        local zoomController = cameraModule and cameraModule:FindFirstChild("ZoomController")
        local popper = zoomController and zoomController:FindFirstChild("Popper")
        if not popper then return nil end
        if type(getgc) == "function" then
            local source = popper:GetFullName()
            for _, callback in ipairs(getgc(false)) do
                if type(callback) ~= "function" or (type(islclosure) == "function" and not islclosure(callback)) then continue end
                local ok, path, arguments = pcall(debug.info, callback, "sa")
                if ok and type(path) == "string" and (path == source or path:sub(-#popper.Name - 1) == "." .. popper.Name) and arguments == 3 then
                    local name = debug.info(callback, "n")
                    if not name or name == "" or string.lower(name) == "popper" then return callback end
                end
            end
        end
        local ok, callback = pcall(require, popper)
        if ok and type(callback) == "function" then return callback end
        return nil
    end

    local function installNoclipCamHook()
        if noclipCamState.hooked then return true end
        if type(hookfunction) ~= "function" then return false end
        local popper = findPopper()
        if not popper then return false end
        local original
        local ok = pcall(function()
            original = hookfunction(popper, function(origin, distance, focus)
                if noclipCamState.on and noclipCamState.mode == "hook" and type(distance) == "number" then
                    return distance
                end
                return original(origin, distance, focus)
            end)
        end)
        if not ok or not original then return false end
        noclipCamState.hooked = true
        return true
    end

    local function setNoclipCamEnabled(enabled)
        noclipCamState.on = not not enabled
        if noclipCamState.on then
            if installNoclipCamHook() then
                noclipCamState.mode = "hook"
                return
            end
            noclipCamState.mode = "invisicam"
            pcall(function()
                if camPreviousMode == nil then camPreviousMode = LP.DevCameraOcclusionMode end
                LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
            end)
            return
        end
        if noclipCamState.mode == "invisicam" and camPreviousMode ~= nil then
            pcall(function() LP.DevCameraOcclusionMode = camPreviousMode end)
            camPreviousMode = nil
        end
        noclipCamState.mode = nil
    end

    local function toggleNoclipCamera(state)
        PlayerState.NoclipCamEnabled = state
        setNoclipCamEnabled(state)
    end

   
    local bombJumpBusy = false
    local bombJumpKey = nil

    local function bombJumpFindBomb()
        local character = LP.Character
        local bomb = character and character:FindFirstChild("FakeBomb")
        if bomb then return bomb end
        local backpack = LP:FindFirstChild("Backpack")
        if not backpack then return nil end
        local toys = backpack:FindFirstChild("Toys")
        return toys and toys:FindFirstChild("FakeBomb") or backpack:FindFirstChild("FakeBomb")
    end

    local function bombJumpEquip()
        local character = LP.Character
        if not character or not character:FindFirstChildOfClass("Humanoid") then return nil end
        local bomb = character:FindFirstChild("FakeBomb") or bombJumpFindBomb()
        if not bomb then return nil end
        pcall(function() bomb.Parent = character end)
        task.wait(0.08)
        bomb = character:FindFirstChild("FakeBomb") or bomb
        pcall(function()
            local handle = bomb:FindFirstChild("Handle")
            local hand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
            if not handle or not hand or hand:FindFirstChild("RightGrip") then return end
            handle.Anchored = false
            local weld = Instance.new("Weld")
            weld.Name, weld.Part0, weld.Part1 = "RightGrip", hand, handle
            weld.C0 = hand.Name == "RightHand" and CFrame.new(0, -0.1, 0) or CFrame.new(0, -1, 0) * CFrame.Angles(-math.pi / 2, 0, 0)
            weld.C1, weld.Parent = bomb.Grip, hand
        end)
        return bomb.Parent == character and bomb or nil
    end

    local function bombJumpJump()
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root or humanoid.Health <= 0 then return end
        local power = humanoid.UseJumpPower == false
            and math.sqrt(2 * (workspace.Gravity or 196.2) * math.max(humanoid.JumpHeight or 7.2, 1))
            or math.max(humanoid.JumpPower or 50, 50)
        local velocity = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = Vector3.new(velocity.X, power, velocity.Z)
        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end

    local function bombJumpThrow(position)
        local bomb = bombJumpEquip()
        local remote = bomb and bomb:FindFirstChild("Remote")
        if not remote then return false end
        pcall(function() remote:FireServer(CFrame.new(position), 50) end)
        return true
    end

    local function bombJumpWatch(character)
        local function watchTool(tool)
            if tool.Name == "FakeBomb" and tool:IsA("Tool") then
                bind(tool.Activated:Connect(function()
                    if PlayerState.BombJumpEnabled then bombJumpJump() end
                end))
            end
        end
        for _, child in ipairs(character:GetChildren()) do watchTool(child) end
        bind(character.ChildAdded:Connect(watchTool))
    end

    local function bombJumpAuto()
        if bombJumpBusy then return end
        bombJumpBusy = true
        task.spawn(function()
            local character = LP.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root then
                bombJumpEquip()
                task.wait(0.1)
                bombJumpJump()
                task.wait(0.12)
                bombJumpThrow(root.Position - Vector3.new(0, 2.5, 0))
                task.wait(0.22)
                bombJumpJump()
            end
            bombJumpBusy = false
        end)
    end

    local function startBombJump()
        if LP.Character then bombJumpWatch(LP.Character) end
        bind(LP.CharacterAdded:Connect(function(character)
            task.wait(0.3)
            bombJumpWatch(character)
        end))
        local key = getgenv().__pulseBindFromName(bombJumpKey or "")
        if key then
            bind(UIS.InputBegan:Connect(function(input)
                if not getgenv().__pulseBindReady() or not getgenv().__pulseBindHit(input, key) then return end
                bombJumpAuto()
            end))
        end
    end

    local function toggleBombJump(state)
        PlayerState.BombJumpEnabled = state
    end

    
    local aaState = {
        on = false, mode = "Desync", dir = "Random",
        applied = false, real = nil,
        threat = nil, threatAt = 0,
        lockAt = 0,
    }
    local shootState = {
        wallbang = false, autoShoot = false,
        flingSheriff = false, timing = "Accurate",
        lastShot = 0, lastFling = 0,
    }

    local function aaGetToolOwner(plr, toolName)
        local c = plr.Character
        return c and c:FindFirstChild(toolName)
    end

    local function aaFindRoles()
        local murderer, sheriff
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                if aaGetToolOwner(plr, "Knife") then murderer = plr end
                if aaGetToolOwner(plr, "Gun") then sheriff = plr end
            end
        end
        return murderer, sheriff
    end

    local function aaFindThreat(position)
        local _, sheriff = aaFindRoles()
        if sheriff and sheriff.Character then
            local root = sheriff.Character:FindFirstChild("HumanoidRootPart")
            if root then return root end
        end
        local nearest, dist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and aaGetToolOwner(plr, "Gun") then
                local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local d = (root.Position - position).Magnitude
                    if d < dist then nearest, dist = root, d end
                end
            end
        end
        return nearest
    end

    local function aaRestoreFake()
        if not aaState.applied then return end
        local root = getRoot()
        if root and root.Parent and aaState.real then
            pcall(function() root.CFrame = aaState.real end)
        end
        aaState.applied = false
    end

    pcall(function() RunService:UnbindFromRenderStep("ServaFakePos") end)
    pcall(function()
        RunService:BindToRenderStep("ServaFakePos", Enum.RenderPriority.First.Value, aaRestoreFake)
    end)

    bind(RunService.Heartbeat:Connect(function()
        if not aaState.on then
            aaRestoreFake()
            return
        end
        local char, hum, root = LP.Character, getHum(), getRoot()
        if not (hum and root and root.Parent) or hum.Health <= 0 then
            aaRestoreFake()
            return
        end
        if PlayerState.FlyEnabled then aaRestoreFake() return end

        local now = os.clock()

        if aaState.mode == "Prediction" then
            aaRestoreFake()
            if now >= aaState.threatAt then
                aaState.threatAt = now + 0.25
                aaState.threat = aaFindThreat(root.Position)
            end
            if not aaState.threat or not aaState.threat.Parent then return end
            local delta = root.Position - aaState.threat.Position
            delta = Vector3.new(delta.X, 0, delta.Z)
            if delta.Magnitude < 0.5 then return end
            local dir = delta.Unit
            local side = Vector3.new(-dir.Z, 0, dir.X)
            local flip = (math.floor(now * 2) % 2 == 0) and 1 or -1
            if aaState.dir == "Sides" then
                hum:Move(side * flip, false)
            else
                hum:Move((dir + side * flip * 0.6).Unit, false)
            end
            return
        end

        if aaState.applied then return end
        aaState.real = root.CFrame
        local offset
        if aaState.dir == "Back" then
            offset = CFrame.new(0, 0, -14)
        elseif aaState.dir == "Sides" then
            offset = (math.floor(now * 4) % 2 == 0) and CFrame.new(12, 0, 0) or CFrame.new(-12, 0, 0)
        else
            local ang = math.random() * math.pi * 2
            offset = CFrame.new(math.sin(ang) * 12, 0, math.cos(ang) * 12)
        end
        pcall(function() root.CFrame = aaState.real * offset end)
        aaState.applied = true
    end))

    local function aaFireShootAt(targetRoot)
        local char = LP.Character
        local gun = char and char:FindFirstChild("Gun")
        if not gun then return false end
        local remote = gun:FindFirstChild("Shoot")
        if not remote then return false end
        local origin = getRoot() and getRoot().Position or targetRoot.Position
        local target = targetRoot.Position + targetRoot.AssemblyLinearVelocity * 0.08
        pcall(function()
            remote:FireServer(CFrame.new(origin), CFrame.new(target))
        end)
        return true
    end

    bind(RunService.Heartbeat:Connect(function()
        local char, hum, root = LP.Character, getHum(), getRoot()
        if not (hum and root and char) or hum.Health <= 0 then return end
        if not (shootState.autoShoot or shootState.flingSheriff) then return end

        local now = os.clock()
        local murderer, sheriff = aaFindRoles()

        if shootState.flingSheriff and sheriff and sheriff.Character then
            local sRoot = sheriff.Character:FindFirstChild("HumanoidRootPart")
            if sRoot and (sRoot.Position - root.Position).Magnitude < 40 and now - (shootState.lastFling or 0) > 0.12 then
                shootState.lastFling = now
                pcall(function()
                    root.CFrame = sRoot.CFrame * CFrame.new(math.random() * 2 - 1, 0.5, math.random() * 2 - 1)
                    root.AssemblyLinearVelocity = Vector3.new(math.random() * 120 - 60, 90, math.random() * 120 - 60)
                    root.AssemblyAngularVelocity = Vector3.new(60, 60, 60)
                end)
            end
        end

        if shootState.autoShoot and murderer and murderer.Character
            and aaGetToolOwner(LP, "Gun") then
            local mRoot = murderer.Character:FindFirstChild("HumanoidRootPart")
            if mRoot then
                local dist = (mRoot.Position - root.Position).Magnitude
                if dist < 80 and now - (shootState.lastShot or 0) > 0.35 then
                    local clear = shootState.wallbang
                    if not clear then
                        local params = RaycastParams.new()
                        params.FilterType = Enum.RaycastFilterType.Exclude
                        params.FilterDescendantsInstances = { LP.Character, murderer.Character }
                        clear = WS:Raycast(root.Position, mRoot.Position - root.Position, params) == nil
                    end
                    if clear then
                        local allowed = true
                        if shootState.timing == "Accurate" then
                            local cam = WS.CurrentCamera
                            local look = cam and cam.CFrame.LookVector or root.CFrame.LookVector
                            local toTarget = (mRoot.Position - cam.CFrame.Position).Unit
                            if (look:Dot(toTarget)) > 0.965 then
                                aaState.lockAt = aaState.lockAt == 0 and now or aaState.lockAt
                                allowed = now - aaState.lockAt > 0.25
                            else
                                aaState.lockAt = 0
                                allowed = false
                            end
                        else
                            aaState.lockAt = 0
                        end
                        if allowed then
                            shootState.lastShot = now
                            aaFireShootAt(mRoot)
                        end
                    end
                end
            end
        end
    end))
    
    local murder = {
        killAura = false, auraRadius = 20,
        killAll = false, killGunPlayers = false,
        aimbot = false, targetMode = "Smart", maxDistance = 250, aimFOV = 360,
        autoThrow = false, minChance = 55, autoRange = 70,
        wallCheck = true, predict = true, lead = 100,
        sticky = true, targetMarker = true,
        tracers = false,
        lastKill = 0, lastThrow = 0,
        target = nil, marker = nil,
    }

    local function murGetKnife()
        local char = LP.Character
        return (char and char:FindFirstChild("Knife")) or (LP.Backpack and LP.Backpack:FindFirstChild("Knife"))
    end

    local function murAlive(plr)
        local c = plr.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        return c and hum and hum.Health > 0 and c:FindFirstChild("HumanoidRootPart")
    end

    local function murHasGun(plr)
        local c = plr.Character
        return c and (c:FindFirstChild("Gun") or (LP.Backpack and LP.Backpack:FindFirstChild("Gun") ~= nil and false)) or false
    end

    
    local function murTouchKill(victimChar)
        local knife = LP.Character and LP.Character:FindFirstChild("Knife")
        local handle = knife and (knife:FindFirstChild("Handle") or knife:IsA("BasePart") and knife)
        if not handle then return false end
        local victimRoot = victimChar:FindFirstChild("HumanoidRootPart") or victimChar:FindFirstChild("Torso") or victimChar:FindFirstChild("UpperTorso")
        if not victimRoot then return false end
        if type(firetouchinterest) == "function" then
            pcall(firetouchinterest, handle, victimRoot, 0)
            task.delay(0.05, function() pcall(firetouchinterest, handle, victimRoot, 1) end)
            return true
        end
        return false
    end

    local function murKillTargets(radius, onlyGun)
        local root = getRoot()
        local knife = LP.Character and LP.Character:FindFirstChild("Knife")
        if not root or not knife then return 0 end
        local killed = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and murAlive(plr) then
                if not onlyGun or murHasGun(plr) then
                    local vRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    if vRoot and (radius >= math.huge or (vRoot.Position - root.Position).Magnitude <= radius) then
                        if murTouchKill(plr.Character) then
                            killed += 1
                        end
                    end
                end
            end
        end
        return killed
    end

    bind(RunService.Heartbeat:Connect(function()
        if not (murder.killAura or murder.killAll or murder.killGunPlayers) then return end
        local now = os.clock()
        if now - murder.lastKill < 0.4 then return end
        if not murGetKnife() then return end
        murder.lastKill = now

        if murder.killAll then
            pcall(murKillTargets, math.huge, murder.killGunPlayers)
        elseif murder.killGunPlayers then
            pcall(murKillTargets, math.huge, true)
        elseif murder.killAura then
            pcall(murKillTargets, murder.auraRadius, false)
        end
    end))

    
    local MUR_KNIFE_SPEED = 96 

    local function murPickTarget(root)
        local best, bestScore = nil, math.huge
        local cam = WS.CurrentCamera
        local camPos = cam and cam.CFrame.Position
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and murAlive(plr) then
                local vRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if vRoot then
                    local dist = (vRoot.Position - root.Position).Magnitude
                    if dist <= murder.maxDistance then
                        local score = dist
                        
                        local isSheriff = aaGetToolOwner(plr, "Gun") ~= nil
                        if murder.targetMode == "Sheriff First" and not isSheriff then score += 500 end
                        if murder.targetMode == "Nearest" then score = dist end
                        if murder.targetMode == "Crosshair" and camPos then
                            local dir = (vRoot.Position - camPos).Unit
                            local look = cam.CFrame.LookVector
                            local ang = math.deg(math.acos(math.clamp(look:Dot(dir), -1, 1)))
                            if ang > murder.aimFOV / 2 then continue end
                            score = ang * 10 + dist * 0.1
                        end
                        if isSheriff then score *= 0.6 end
                        if score < bestScore then best, bestScore = plr, score end
                    end
                end
            end
        end
        return best
    end

    local function murWallClear(from, to, victimChar)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { LP.Character, victimChar }
        return WS:Raycast(from, to - from, params) == nil
    end

    local function murSetMarker(targetChar)
        if not murder.targetMarker then return end
        if murder.marker then
            pcall(function() murder.marker:Destroy() end)
            murder.marker = nil
        end
        if targetChar then
            pcall(function()
                local hl = Instance.new("Highlight")
                hl.Name = "ServaMurderMarker"
                hl.FillColor = Color3.fromRGB(255, 122, 26)
                hl.OutlineColor = Color3.fromRGB(255, 200, 80)
                hl.FillTransparency = 0.85
                hl.Parent = targetChar
                murder.marker = hl
            end)
        end
    end

    local function murThrowTracer(origin, targetPos)
        if not murder.tracers then return end
        pcall(function()
            local dist = (targetPos - origin).Magnitude
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.CanQuery = false
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(255, 122, 26)
            part.Size = Vector3.new(0.1, 0.1, dist)
            part.CFrame = CFrame.lookAt(origin, targetPos) * CFrame.new(0, 0, -dist / 2)
            part.Parent = WS
            game:GetService("Debris"):AddItem(part, 0.35)
        end)
    end

    local function murThrowAt(targetRoot)
        local char = LP.Character
        local knife = char and char:FindFirstChild("Knife")
        if not knife then return false end
        
        local remote = knife:FindFirstChild("Throw") or knife:FindFirstChild("ThrowKnife") or knife:FindFirstChild("Remote")
        if not remote then return false end
        local origin = getRoot() and getRoot().Position
        if not origin then return false end

        local dist = (targetRoot.Position - origin).Magnitude
        
        local flightTime = dist / MUR_KNIFE_SPEED
        local lead = murder.lead / 100
        local aimPos = targetRoot.Position
        if murder.predict then
            aimPos = aimPos + targetRoot.AssemblyLinearVelocity * flightTime * lead
        end

        if murder.wallCheck and not murWallClear(origin, aimPos, targetRoot.Parent) then
            return false
        end

        pcall(function()
            remote:FireServer(CFrame.new(origin), CFrame.new(aimPos))
        end)
        murThrowTracer(origin, aimPos)
        return true
    end

    local function murThrowChance(dist, wallClear)
        
        local chance = 100 - dist * 0.28
        if not wallClear then chance -= 35 end
        return math.clamp(chance, 0, 100)
    end

    bind(RunService.Heartbeat:Connect(function()
        if not (murder.aimbot or murder.autoThrow) then
            if murder.marker then
                pcall(function() murder.marker:Destroy() end)
                murder.marker = nil
            end
            return
        end
        local char, hum, root = LP.Character, getHum(), getRoot()
        if not (char and hum and root) or hum.Health <= 0 then return end
        if not (char:FindFirstChild("Knife")) then return end

        local now = os.clock()

        
        local targetPlr = murder.target
        if murder.sticky and targetPlr and murAlive(targetPlr) then
            local vRoot = targetPlr.Character:FindFirstChild("HumanoidRootPart")
            if not vRoot or (vRoot.Position - root.Position).Magnitude > murder.maxDistance * 1.5 then
                targetPlr = nil
            end
        else
            targetPlr = nil
        end
        if not targetPlr then
            targetPlr = murPickTarget(root)
        end
        murder.target = targetPlr

        if targetPlr and targetPlr.Character then
            murSetMarker(targetPlr.Character)
        else
            murSetMarker(nil)
        end

        if murder.autoThrow and targetPlr and targetPlr.Character and now - murder.lastThrow > 0.6 then
            local vRoot = targetPlr.Character:FindFirstChild("HumanoidRootPart")
            if vRoot then
                local dist = (vRoot.Position - root.Position).Magnitude
                if dist <= murder.autoRange then
                    local clear = murWallClear(root.Position, vRoot.Position, targetPlr.Character)
                    local chance = murThrowChance(dist, clear)
                    if chance >= murder.minChance then
                        murder.lastThrow = now
                        pcall(murThrowAt, vRoot)
                    end
                end
            end
        end
    end))

    
    bind(RunService.Heartbeat:Connect(function()
        if grav.on then applyGravity() end
        if hip.on then applyHipHeight() end
    end))

    bind(LP.CharacterAdded:Connect(function(newChar)
        task.wait(1)
        
        table.clear(originalCollisions)
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        safeCFrame = nil

        if PlayerState.NoclipEnabled then toggleNoclip(true) end
        if PlayerState.InvisibilityEnabled then toggleInvisibility(true) end
        if PlayerState.SpinbotEnabled then toggleSpinbot(true) end
        if PlayerState.FlyEnabled then startFly() end
        if PlayerState.AntiFlingEnabled then toggleAntiFling(true) end
        if PlayerState.HipHeightEnabled then applyHipHeight() end
        aaState.applied = false
        aaState.real = nil
        murder.target = nil
        if murder.marker then pcall(function() murder.marker:Destroy() end) murder.marker = nil end
    end))

    local hiddenParts = {}
    appliers.HidePlayers = function(on)
        if on then return end
        for part in pairs(hiddenParts) do
            if part.Parent then part.LocalTransparencyModifier = 0 end
        end
        hiddenParts = {}
    end

    task.spawn(function()
        while not Hub.unloaded do
            if Settings.HidePlayers then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        for _, d in ipairs(p.Character:GetDescendants()) do
                            if d:IsA("BasePart") or d:IsA("Decal") then
                                hiddenParts[d] = true
                                d.LocalTransparencyModifier = 1
                            end
                        end
                    end
                end
                task.wait(0.5)
            else
                task.wait(1)
            end
        end
    end)

    appliers.FPSCap = function(v)
        if setfpscap then pcall(setfpscap, v) end
        if setfflag then pcall(setfflag, "TaskSchedulerTargetFps", tostring(v)) end
    end

    local LAG_FX = { ParticleEmitter = true, Trail = true, Smoke = true, Fire = true, Sparkles = true, Beam = true }
    local lagFx, lagShadows = {}, nil
    local function killFx(d)
        if LAG_FX[d.ClassName] and d.Enabled then
            lagFx[d] = true
            d.Enabled = false
        end
    end

    appliers.AntiLag = function(on)
        if on then
            if lagShadows == nil then lagShadows = Lighting.GlobalShadows end
            Lighting.GlobalShadows = false
            for _, d in ipairs(WS:GetDescendants()) do killFx(d) end
        else
            if lagShadows ~= nil then
                Lighting.GlobalShadows = lagShadows
                lagShadows = nil
            end
            for d in pairs(lagFx) do
                if d.Parent then d.Enabled = true end
            end
            lagFx = {}
        end
    end

    bind(WS.DescendantAdded:Connect(function(d)
        if Settings.AntiLag then killFx(d) end
    end))

    local fbSaved
    appliers.Fullbright = function(on)
        if on then
            fbSaved = fbSaved or { Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient }
        elseif fbSaved then
            Lighting.Brightness = fbSaved.Brightness
            Lighting.ClockTime = fbSaved.ClockTime
            Lighting.FogEnd = fbSaved.FogEnd
            Lighting.GlobalShadows = fbSaved.GlobalShadows
            Lighting.Ambient = fbSaved.Ambient
            Lighting.OutdoorAmbient = fbSaved.OutdoorAmbient
            fbSaved = nil
        end
    end

    bind(RunService.Heartbeat:Connect(function()
        if not Settings.Fullbright then return end
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1e9
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    end))

    Hub.Port = { cfg = {}, objs = {}, stops = {} }
    do
        local Port = Hub.Port
        local Lighting_ = Lighting
        local TeleportService = game:GetService("TeleportService")
        local SoundService = game:GetService("SoundService")
        local Debris = game:GetService("Debris")
        local HAS_DRAWING = pcall(function() local d = Drawing.new("Line") d:Remove() end)

        local function notify(t, c, i)
            pcall(function() WindUI:Notify({ Title = t, Content = c, Icon = i or "check", Duration = 2.5 }) end)
        end
        local function cleanName(s) return tostring(s or "") end
        local function alive(plr)
            local c = plr and plr.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            return c and hum and hum.Health > 0 and c:FindFirstChild("HumanoidRootPart")
        end
        local function roleOf(plr)
            local c = plr.Character
            local bp = plr:FindFirstChildOfClass("Backpack")
            if (c and c:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife")) then return "Murderer" end
            if (c and c:FindFirstChild("Gun")) or (bp and bp:FindFirstChild("Gun")) then return "Sheriff" end
            return "Innocent"
        end
        local ROLE_COLOR = {
            Murderer = Color3.fromRGB(255, 60, 60),
            Sheriff = Color3.fromRGB(70, 140, 255),
            Innocent = Color3.fromRGB(80, 230, 120),
        }
        local function bodyPart(char, mode)
            if mode == "Head" then return char:FindFirstChild("Head") end
            return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        end
        local function wallClear(fromPos, toPart)
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = { LP.Character, toPart.Parent }
            return WS:Raycast(fromPos, toPart.Position - fromPos, params) == nil
        end
        local function drawNew(kind, props)
            if not HAS_DRAWING then return nil end
            local ok, d = pcall(function() return Drawing.new(kind) end)
            if not ok then return nil end
            for k, v in pairs(props or {}) do pcall(function() d[k] = v end) end
            return d
        end

        
        local A = Port.cfg
        A.aimlock, A.aimActive, A.aimPart = false, true, "Head"
        A.predict, A.silent, A.ignoreWalls = 5, false, false
        A.showFov, A.fov, A.fovColor = true, 150, Color3.fromRGB(137, 207, 240)

        local function predictedPos(part)
            local root = part.Parent:FindFirstChild("HumanoidRootPart")
            local vel = root and root.AssemblyLinearVelocity or Vector3.zero
            if vel.Magnitude > 65 then vel = vel.Unit * 65 end
            local ping = math.clamp(LP:GetNetworkPing(), 0.02, 0.22)
            return part.Position + vel * (ping * 0.9 + A.predict * 10 / 1000)
        end

        
        function Port.pickAimPart()
            local cam = WS.CurrentCamera
            if not cam then return nil end
            local viewport = cam.ViewportSize
            local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
            local iHaveGun = roleOf(LP) == "Sheriff"
            local best, bestScore
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and alive(plr) then
                    local part = bodyPart(plr.Character, A.aimPart)
                    if part then
                        local role = roleOf(plr)
                        local sp, on = cam:WorldToViewportPoint(part.Position)
                        local d2 = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if on and d2 <= A.fov and (A.ignoreWalls or wallClear(cam.CFrame.Position, part)) then
                            local score = d2
                            if iHaveGun and role == "Murderer" then score = score - 10000 end
                            if not bestScore or score < bestScore then best, bestScore = part, score end
                        end
                    end
                end
            end
            return best
        end

        local fovCircle = drawNew("Circle", { Thickness = 1.5, NumSides = 64, Filled = false, Transparency = 1, Visible = false })
        bind(RunService.RenderStepped:Connect(function()
            local cam = WS.CurrentCamera
            if not cam then return end
            if fovCircle then
                local vp = cam.ViewportSize
                fovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
                fovCircle.Radius = A.fov
                fovCircle.Color = A.fovColor
                fovCircle.Visible = A.showFov and (A.aimlock or A.silent)
            end
            if A.aimlock and A.aimActive then
                local part = Port.pickAimPart()
                if part then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, predictedPos(part))
                end
            end
        end))

        
        A.antiKick, A.bulletTracer, A.tracerColor, A.tracerDur = false, false, Color3.fromRGB(255, 55, 75), 0.5
        local function spawnTracer(a, b)
            local part = Instance.new("Part")
            part.Anchored, part.CanCollide, part.CanQuery, part.CanTouch = true, false, false, false
            part.Material = Enum.Material.Neon
            part.Color = A.tracerColor
            local len = (b - a).Magnitude
            part.Size = Vector3.new(0.12, 0.12, math.max(len, 0.1))
            part.CFrame = CFrame.lookAt((a + b) / 2, b)
            part.Parent = WS
            Debris:AddItem(part, A.tracerDur)
        end
        Port.spawnTracer = spawnTracer

        if type(hookmetamethod) == "function" and type(getnamecallmethod) == "function"
            and type(checkcaller) == "function" and type(newcclosure) == "function" then
            local old
            old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" and typeof(self) == "Instance" and self.Name == "Shoot" then
                    local args = table.pack(...)
                    if A.silent and not checkcaller() then
                        local part = Port.pickAimPart()
                        if part then args[2] = CFrame.new(predictedPos(part)) end
                    end
                    if A.bulletTracer and typeof(args[1]) == "CFrame" and typeof(args[2]) == "CFrame" then
                        local a, b = args[1].Position, args[2].Position
                        task.defer(spawnTracer, a, b)
                    end
                    return old(self, table.unpack(args, 1, args.n))
                end
                if A.antiKick and method == "Kick" and self == LP and not checkcaller() then
                    return nil
                end
                return old(self, ...)
            end))
            Port.hookOk = true
        else
            Port.hookOk = false
        end

        function Port.setAutoShoot(on) shootState.autoShoot = not not on end
        function Port.setAutoShootMode(mode) shootState.wallbang = (mode == "Behind Walls") end

        
        local E = { on = false, style = "Filled", color = Color3.fromRGB(255, 0, 0), line = false, name = false, gun = false, coin = false, around = false }
        Port.esp = E
        local espObjs = {}   
        local gunBB, coinBBs = nil, {}

        local function clearPlayerEsp(plr)
            local o = espObjs[plr]
            if not o then return end
            if o.hl then o.hl:Destroy() end
            if o.bb then o.bb:Destroy() end
            if o.line then pcall(function() o.line:Remove() end) end
            if o.arrow then pcall(function() o.arrow:Remove() end) end
            espObjs[plr] = nil
        end
        local function clearAllEsp()
            for plr in pairs(espObjs) do clearPlayerEsp(plr) end
            if gunBB then gunBB:Destroy() gunBB = nil end
            for part, bb in pairs(coinBBs) do bb:Destroy() coinBBs[part] = nil end
        end
        local function makeBB(adornee, text, color)
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.fromOffset(120, 28)
            bb.AlwaysOnTop = true
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.Adornee = adornee
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.fromScale(1, 1)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = color
            lbl.TextStrokeTransparency = 0.3
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 14
            lbl.Parent = bb
            bb.Parent = LP:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")
            return bb, lbl
        end

        local function updateEsp()
            local cam = WS.CurrentCamera
            if not cam then return end
            local vp = cam.ViewportSize
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP then
                    local root = alive(plr)
                    local want = E.on or E.line or E.name or E.around
                    if root and want then
                        local o = espObjs[plr]
                        if not o then o = {} espObjs[plr] = o end
                        local col = (E.on and E.color) or ROLE_COLOR[roleOf(plr)]
                        local roleCol = ROLE_COLOR[roleOf(plr)]
                       
                        if E.on then
                            if not o.hl or o.hl.Adornee ~= plr.Character then
                                if o.hl then o.hl:Destroy() end
                                o.hl = Instance.new("Highlight")
                                o.hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                o.hl.Adornee = plr.Character
                                o.hl.Parent = plr.Character
                            end
                            o.hl.FillColor = roleCol
                            o.hl.OutlineColor = E.color
                            o.hl.FillTransparency = (E.style == "Filled") and 0.5 or 1
                        elseif o.hl then
                            o.hl:Destroy() o.hl = nil
                        end
                        
                        if E.name then
                            local head = plr.Character:FindFirstChild("Head") or root
                            if not o.bb or o.bb.Adornee ~= head then
                                if o.bb then o.bb:Destroy() end
                                o.bb, o.lbl = makeBB(head, "", roleCol)
                            end
                            o.lbl.Text = plr.DisplayName .. " [" .. roleOf(plr) .. "]"
                            o.lbl.TextColor3 = roleCol
                        elseif o.bb then
                            o.bb:Destroy() o.bb = nil
                        end
                        -- Line + 360 стрелки
                        local sp, on = cam:WorldToViewportPoint(root.Position)
                        if E.line and HAS_DRAWING then
                            o.line = o.line or drawNew("Line", { Thickness = 1.5, Transparency = 1 })
                            if o.line then
                                o.line.Color = roleCol
                                o.line.From = Vector2.new(vp.X / 2, vp.Y)
                                o.line.To = Vector2.new(sp.X, sp.Y)
                                o.line.Visible = on and sp.Z > 0
                            end
                        elseif o.line then
                            o.line:Remove() o.line = nil
                        end
                        if E.around and HAS_DRAWING then
                            o.arrow = o.arrow or drawNew("Text", { Size = 16, Center = true, Outline = true, Transparency = 1 })
                            if o.arrow then
                                local offscreen = (not on) or sp.Z <= 0 or sp.X < 0 or sp.X > vp.X or sp.Y < 0 or sp.Y > vp.Y
                                if offscreen then
                                    local rel = cam.CFrame:PointToObjectSpace(root.Position)
                                    local dir = Vector2.new(rel.X, -rel.Z)
                                    if dir.Magnitude < 1e-3 then dir = Vector2.new(0, 1) end
                                    dir = dir.Unit
                                    local c = Vector2.new(vp.X / 2, vp.Y / 2)
                                    local p = c + Vector2.new(dir.X, -dir.Y) * math.min(vp.X, vp.Y) * 0.42
                                    o.arrow.Position = p
                                    o.arrow.Text = "▲ " .. plr.DisplayName
                                    o.arrow.Color = roleCol
                                    o.arrow.Visible = true
                                else
                                    o.arrow.Visible = false
                                end
                            end
                        elseif o.arrow then
                            o.arrow:Remove() o.arrow = nil
                        end
                    else
                        clearPlayerEsp(plr)
                    end
                end
            end
            for plr in pairs(espObjs) do
                if not plr.Parent then clearPlayerEsp(plr) end
            end
            
            local drop = WS:FindFirstChild("GunDrop")
            if E.gun and drop and drop:IsA("BasePart") then
                if not gunBB or gunBB.Adornee ~= drop then
                    if gunBB then gunBB:Destroy() end
                    gunBB = makeBB(drop, "🔫 GUN", Color3.fromRGB(255, 215, 0))
                    gunBB.StudsOffset = Vector3.new(0, 2, 0)
                end
            elseif gunBB then
                gunBB:Destroy() gunBB = nil
            end
        end

        local function updateCoinEsp()
            if not E.coin then
                for part, bb in pairs(coinBBs) do bb:Destroy() coinBBs[part] = nil end
                return
            end
            for part, bb in pairs(coinBBs) do
                if not part.Parent then bb:Destroy() coinBBs[part] = nil end
            end
            for _, map in ipairs(WS:GetChildren()) do
                local cont = map:FindFirstChild("CoinContainer") or map:FindFirstChild("CandyContainer")
                if cont then
                    for _, part in ipairs(cont:GetChildren()) do
                        if part:IsA("BasePart") and not coinBBs[part] then
                            local bb = Instance.new("BillboardGui")
                            bb.Size = UDim2.fromOffset(10, 10)
                            bb.AlwaysOnTop = true
                            bb.Adornee = part
                            local f = Instance.new("Frame")
                            f.Size = UDim2.fromScale(1, 1)
                            f.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                            f.BorderSizePixel = 0
                            local corner = Instance.new("UICorner")
                            corner.CornerRadius = UDim.new(1, 0)
                            corner.Parent = f
                            f.Parent = bb
                            bb.Parent = LP:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")
                            coinBBs[part] = bb
                        end
                    end
                end
            end
        end

        task.spawn(function()
            while not Hub.unloaded do
                if E.on or E.line or E.name or E.around or E.gun then
                    pcall(updateEsp)
                else
                    if next(espObjs) or gunBB then pcall(clearAllEsp) end
                end
                pcall(updateCoinEsp)
                task.wait(0.1)
            end
        end)
        Port.stops.esp = clearAllEsp

        
        local FX = {}
        local origLighting = {
            Brightness = Lighting_.Brightness, ExposureCompensation = Lighting_.ExposureCompensation,
            EnvironmentDiffuseScale = Lighting_.EnvironmentDiffuseScale,
            EnvironmentSpecularScale = Lighting_.EnvironmentSpecularScale,
            GlobalShadows = Lighting_.GlobalShadows, ShadowSoftness = Lighting_.ShadowSoftness,
            FogEnd = Lighting_.FogEnd, FogStart = Lighting_.FogStart, FogColor = Lighting_.FogColor,
        }
        local function fxObj(class, name)
            local o = Lighting_:FindFirstChild(name)
            if not o then o = Instance.new(class) o.Name = name o.Parent = Lighting_ end
            return o
        end
        local PRESETS = {
            ["RTX Reflection"] = { c = 0.12, s = 0.1, tint = Color3.fromRGB(255, 255, 255), bloom = { 0.18, 28, 1.05 }, rays = { 0.045, 0.8 },
                dof = { 0.02, 55, 42, 0.02 }, shadows = 0.12, expo = 0.1, atm = { 0.3, 0.25, 0.15 } },
            ["Realistic"] = { c = 0.09, s = 0.06, tint = Color3.fromRGB(248, 251, 255), bloom = { 0.12, 24, 1.15 }, rays = { 0.035, 0.76 },
                dof = { 0.018, 60, 46, 0.025 }, shadows = 0.18, expo = 0, atm = { 0.25, 0.1, 0.1 } },
            ["Deep"] = { c = 0.2, s = -0.05, tint = Color3.fromRGB(200, 215, 255), bloom = { 0.1, 24, 1.2 }, rays = { 0.02, 0.7 },
                dof = { 0.02, 50, 40, 0.03 }, shadows = 0.1, expo = -0.15, atm = { 0.35, 0.15, 0.2 } },
            ["Cinematic"] = { c = 0.18, s = -0.1, tint = Color3.fromRGB(255, 238, 220), bloom = { 0.2, 30, 1.0 }, rays = { 0.05, 0.8 },
                dof = { 0.04, 45, 35, 0.04 }, shadows = 0.15, expo = 0.05, atm = { 0.3, 0.2, 0.15 } },
            ["Soft"] = { c = -0.05, s = 0.05, tint = Color3.fromRGB(255, 245, 250), bloom = { 0.25, 30, 0.95 }, rays = { 0.03, 0.75 },
                dof = { 0.0, 60, 60, 0.0 }, shadows = 0.4, expo = 0.1, atm = { 0.2, 0.05, 0.05 } },
        }
        function Port.setShader(name)
            for _, n in ipairs({ "ServaCC", "ServaBloom", "ServaRays", "ServaDOF", "ServaAtm" }) do
                local o = Lighting_:FindFirstChild(n)
                if o then o:Destroy() end
            end
            for k, v in pairs(origLighting) do pcall(function() Lighting_[k] = v end) end
            local p = PRESETS[name]
            if not p then return end
            local cc = fxObj("ColorCorrectionEffect", "ServaCC")
            cc.Contrast, cc.Saturation, cc.TintColor = p.c, p.s, p.tint
            local bl = fxObj("BloomEffect", "ServaBloom")
            bl.Intensity, bl.Size, bl.Threshold = p.bloom[1], p.bloom[2], p.bloom[3]
            local sr = fxObj("SunRaysEffect", "ServaRays")
            sr.Intensity, sr.Spread = p.rays[1], p.rays[2]
            local dof = fxObj("DepthOfFieldEffect", "ServaDOF")
            dof.FarIntensity, dof.FocusDistance, dof.InFocusRadius, dof.NearIntensity = p.dof[1], p.dof[2], p.dof[3], p.dof[4]
            local atm = fxObj("Atmosphere", "ServaAtm")
            atm.Density, atm.Offset, atm.Haze = p.atm[1], p.atm[2], p.atm[3]
            Lighting_.EnvironmentDiffuseScale = 1
            Lighting_.EnvironmentSpecularScale = 1
            Lighting_.GlobalShadows = true
            Lighting_.ShadowSoftness = p.shadows
            Lighting_.ExposureCompensation = p.expo
        end

        local SKIES = {
            ["Purple Nebula"] = { "159454299", "159454296", "159454293", "159454286", "159454300", "159454288" },
            ["Dreamy Sunset"] = { "1417494030", "1417494146", "1417494253", "1417494402", "1417494499", "1417494643" },
            ["Redshift"] = { "401664839", "401664862", "401664960", "401664881", "401664901", "401664936" },
        }
        local hiddenSkies, customSky = {}, nil
        function Port.setSky(name)
            if customSky then customSky:Destroy() customSky = nil end
            for _, s in ipairs(hiddenSkies) do if s then s.Parent = Lighting_ end end
            table.clear(hiddenSkies)
            local ids = SKIES[name]
            if not ids then return end
            for _, c in ipairs(Lighting_:GetChildren()) do
                if c:IsA("Sky") then table.insert(hiddenSkies, c) c.Parent = nil end
            end
            local sky = Instance.new("Sky")
            sky.Name = "ServaSky"
            sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt = "rbxassetid://" .. ids[1], "rbxassetid://" .. ids[2], "rbxassetid://" .. ids[3]
            sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = "rbxassetid://" .. ids[4], "rbxassetid://" .. ids[5], "rbxassetid://" .. ids[6]
            sky.CelestialBodiesShown, sky.StarCount = true, 3000
            sky.Parent = Lighting_
            customSky = sky
        end

        
        local W = { snow = false, density = "Medium", fog = false, fogColor = Color3.fromRGB(188, 194, 204), fogDensity = "Medium" }
        Port.weather = W
        local snowPart, snowEmitter
        local SNOW_RATE = { Low = 40, Medium = 110, High = 240 }
        local FOG_END = { Low = 700, Medium = 320, High = 130 }
        function Port.updateWeather()
            if W.snow then
                if not snowPart or not snowPart.Parent then
                    snowPart = Instance.new("Part")
                    snowPart.Anchored, snowPart.CanCollide, snowPart.CanQuery, snowPart.CanTouch = true, false, false, false
                    snowPart.Transparency = 1
                    snowPart.Size = Vector3.new(80, 1, 80)
                    snowPart.Name = "ServaSnow"
                    snowEmitter = Instance.new("ParticleEmitter")
                    snowEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                    snowEmitter.Lifetime = NumberRange.new(6, 8)
                    snowEmitter.Speed = NumberRange.new(10, 16)
                    snowEmitter.EmissionDirection = Enum.NormalId.Bottom
                    snowEmitter.SpreadAngle = Vector2.new(25, 25)
                    snowEmitter.Size = NumberSequence.new(0.25)
                    snowEmitter.Color = ColorSequence.new(Color3.new(1, 1, 1))
                    snowEmitter.LightEmission = 0.4
                    snowEmitter.Parent = snowPart
                    snowPart.Parent = WS
                end
                snowEmitter.Rate = SNOW_RATE[W.density] or 110
            elseif snowPart then
                snowPart:Destroy() snowPart, snowEmitter = nil, nil
            end
            if W.fog then
                Lighting_.FogColor = W.fogColor
                Lighting_.FogStart = 0
                Lighting_.FogEnd = FOG_END[W.fogDensity] or 320
            else
                Lighting_.FogColor, Lighting_.FogStart, Lighting_.FogEnd = origLighting.FogColor, origLighting.FogStart, origLighting.FogEnd
            end
        end
        bind(RunService.RenderStepped:Connect(function()
            local cam = WS.CurrentCamera
            if snowPart and snowPart.Parent and cam then
                snowPart.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, 35, 0))
            end
        end))

        
        local function tpTo(cf)
            local root = getRoot()
            if root and cf then
                root.AssemblyLinearVelocity = Vector3.zero
                root.CFrame = cf
                return true
            end
            return false
        end
        local function playerRoot(plr)
            return plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        end
        function Port.tpRole(role)
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and roleOf(plr) == role and alive(plr) then
                    tpTo(playerRoot(plr).CFrame * CFrame.new(0, 0, 3))
                    return notify("Teleport", "To " .. role .. ": " .. plr.DisplayName)
                end
            end
            notify("Teleport", role .. " not found", "x")
        end
        function Port.tpPlayer(name)
            local plr = Players:FindFirstChild(cleanName(name))
            if plr and alive(plr) then tpTo(playerRoot(plr).CFrame * CFrame.new(0, 0, 3)) else notify("Teleport", "Player unavailable", "x") end
        end
        function Port.playerNames()
            local list = {}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP then table.insert(list, plr.Name) end
            end
            if #list == 0 then list = { "(No other players)" } end
            return list
        end
        function Port.refreshPlayerDrops()
            local list = Port.playerNames()
            for _, d in ipairs({ Port.objs.tpDrop, Port.objs.flingDrop }) do
                if d then pcall(function() d:Refresh(list) end) end
            end
            if Port.objs.flingDrop then pcall(function() Port.objs.flingDrop:Select(list[1]) end) end
            Port.flingTarget = list[1]
        end
        function Port.tpGun()
            local drop = WS:FindFirstChild("GunDrop")
            if drop and drop:IsA("BasePart") then tpTo(drop.CFrame + Vector3.new(0, 3, 0)) else notify("Teleport", "No dropped gun", "x") end
        end
        function Port.tpLobby()
            local lobby = WS:FindFirstChild("Lobby") or WS:FindFirstChild("NormalLobby")
            local spawns = lobby and lobby:FindFirstChild("Spawns")
            local sp = spawns and spawns:GetChildren()[1]
            if sp and sp:IsA("BasePart") then return tpTo(sp.CFrame + Vector3.new(0, 4, 0)) end
            local any = lobby and lobby:FindFirstChildWhichIsA("SpawnLocation", true)
            if any then return tpTo(any.CFrame + Vector3.new(0, 4, 0)) end
            notify("Teleport", "Lobby not found", "x")
        end
        function Port.tpArena()
            local lobby = WS:FindFirstChild("Lobby")
            for _, m in ipairs(WS:GetChildren()) do
                if m ~= lobby and (m:IsA("Model") or m:IsA("Folder")) and (m:FindFirstChild("CoinContainer") or m:FindFirstChild("Spawns")) then
                    local sp = m:FindFirstChild("Spawns")
                    local part = sp and sp:GetChildren()[1] or m:FindFirstChildWhichIsA("BasePart", true)
                    if part then return tpTo(part.CFrame + Vector3.new(0, 4, 0)) end
                end
            end
            notify("Teleport", "No active map", "x")
        end
        function Port.tpSafe()
            if not Port.safePart or not Port.safePart.Parent then
                local p = Instance.new("Part")
                p.Anchored, p.Size, p.Name = true, Vector3.new(60, 2, 60), "ServaSafezone"
                p.Position = Vector3.new(0, 2500, 0)
                p.Parent = WS
                Port.safePart = p
            end
            tpTo(Port.safePart.CFrame + Vector3.new(0, 4, 0))
        end

        
        local F = { on = false, mode = "Teleport (Instant)", pos = "Normal", speed = 28, endRound = false,
            black = false, no3d = false, bag = 0, max = 40, full = false, hop = false, hopThreshold = 4, hopMinutes = 15, webhook = "" }
        Port.farm = F
        local visited = {}

        local function sendWebhook(text)
            if F.webhook == "" or type(request) ~= "function" and type(http_request) ~= "function" and not (syn and syn.request) then return false end
            local req = (syn and syn.request) or http_request or request
            local ok = pcall(function()
                req({ Url = F.webhook, Method = "POST", Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode({ username = "Serva Hub", content = text }) })
            end)
            return ok
        end
        function Port.testWebhook()
            if F.webhook == "" then return notify("Webhook", "Enter URL first", "x") end
            notify("Webhook", sendWebhook("✅ Serva Hub webhook test — " .. LP.Name) and "Sent" or "Failed", "send")
        end

        local function nearestCoin(root)
            local best, bd = nil, math.huge
            for _, map in ipairs(WS:GetChildren()) do
                local cont = map:FindFirstChild("CoinContainer") or map:FindFirstChild("CandyContainer")
                if cont then
                    for _, part in ipairs(cont:GetChildren()) do
                        if part:IsA("BasePart") and part.Parent and not (visited[part] and os.clock() - visited[part] < 2.5) then
                            local d = (part.Position - root.Position).Magnitude
                            if d < bd then best, bd = part, d end
                        end
                    end
                end
            end
            return best
        end

        
        local farmCollide = {}
        local function farmNoclipStep()
            local c = LP.Character
            if not c then return end
            for _, part in ipairs(c:GetDescendants()) do
                if part:IsA("BasePart") then
                    if farmCollide[part] == nil then farmCollide[part] = part.CanCollide end
                    if part.CanCollide then part.CanCollide = false end
                end
            end
            
            local r = c:FindFirstChild("HumanoidRootPart")
            if r then
                r.Anchored = true
                r.AssemblyLinearVelocity = Vector3.zero
            end
        end
        local farmNoclipConn
        function Port.setFarm(on)
            F.on = not not on
            if F.on then
                if not farmNoclipConn then
                    farmNoclipConn = RunService.Stepped:Connect(function()
                        if F.on then pcall(farmNoclipStep) end
                    end)
                    bind(farmNoclipConn)
                end
            else
                if farmNoclipConn then farmNoclipConn:Disconnect() farmNoclipConn = nil end
                local rr = getRoot()
                if rr then rr.Anchored = false end
                if not PlayerState.NoclipEnabled then
                    for part, was in pairs(farmCollide) do
                        if part and part.Parent then part.CanCollide = was end
                    end
                end
                table.clear(farmCollide)
            end
        end

        
        local function moveTo(targetPos, coin)
            local t0 = os.clock()
            local tele = F.mode:find("Teleport") ~= nil
            while F.on and coin.Parent and os.clock() - t0 < 12 do
                local r = getRoot()
                if not r then return false end
                local d = targetPos - r.Position
                local dist = d.Magnitude
                if dist < 2 then return true end
                if tele then
                    local hop = math.clamp(F.speed * 0.5, 6, 14)
                    r.AssemblyLinearVelocity = Vector3.zero
                    r.CFrame = CFrame.new(r.Position + d.Unit * math.min(dist, hop))
                    task.wait(0.12)
                else
                    local dt = RunService.Heartbeat:Wait()
                    r.CFrame = CFrame.new(r.Position + d.Unit * math.min(dist, F.speed * dt))
                    r.AssemblyLinearVelocity = Vector3.zero
                end
            end
            return false
        end

        local function collect(coin)
            local root = getRoot()
            if not root then return end
            local under = F.pos == "Under"
            local targetPos = (coin.CFrame * CFrame.new(0, under and -3.2 or 0, 0)).Position
            if moveTo(targetPos, coin) and type(firetouchinterest) == "function" then
                local r = getRoot()
                if r then
                    pcall(function()
                        firetouchinterest(r, coin, 0)
                        firetouchinterest(r, coin, 1)
                    end)
                end
            end
            visited[coin] = os.clock()
            task.wait(0.25 + math.random() * 0.25) -- пауза между монетами
        end

        task.spawn(function()
            local gameplay
            while not Hub.unloaded and not gameplay do
                local remotes = RS:FindFirstChild("Remotes")
                gameplay = remotes and remotes:FindFirstChild("Gameplay")
                if not gameplay then task.wait(1) end
            end
            local ev = gameplay and gameplay:FindFirstChild("CoinCollected")
            if not ev then return end
            bind(ev.OnClientEvent:Connect(function(currency, a, b)
                if tostring(currency) ~= "Coin" and tostring(currency) ~= "Candy" then return end
                local cur, max = tonumber(a), tonumber(b)
                if cur and max and cur > max then cur, max = max, cur end
                F.bag, F.max = cur or F.bag + 1, max or F.max
                if F.bag >= F.max then
                    F.full = true
                    if F.on then
                        sendWebhook(("🎒 Bag full: %d/%d (%s)"):format(F.bag, F.max, LP.Name))
                        if F.endRound then
                            local hum = getHum()
                            if hum then pcall(function() hum.Health = 0 end) end
                        end
                    end
                end
            end))
        end)
        bind(LP.CharacterAdded:Connect(function()
            F.full, F.bag = false, 0
            table.clear(visited)
        end)) 

        task.spawn(function()
            while not Hub.unloaded do
                task.wait(0.05)
                if F.on and not F.full then
                    local hum, root = getHum(), getRoot()
                    if hum and root and hum.Health > 0 then
                        local coin = nearestCoin(root)
                        if coin then pcall(collect, coin) else task.wait(0.4) end
                    end
                end
            end
        end)

        local blackGui
        function Port.setBlackScreen(on)
            F.black = on
            if on then
                if not blackGui then
                    blackGui = Instance.new("ScreenGui")
                    blackGui.Name, blackGui.IgnoreGuiInset, blackGui.DisplayOrder, blackGui.ResetOnSpawn = "ServaBlack", true, -5, false
                    local f = Instance.new("Frame")
                    f.Size, f.BackgroundColor3, f.BorderSizePixel = UDim2.fromScale(1, 1), Color3.new(0, 0, 0), 0
                    f.Parent = blackGui
                    blackGui.Parent = LP:WaitForChild("PlayerGui")
                end
            elseif blackGui then
                blackGui:Destroy() blackGui = nil
            end
        end
        function Port.set3D(off)
            F.no3d = off
            pcall(function() RunService:Set3dRenderingEnabled(not off) end)
        end

        
        local function hopServer()
            local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100"):format(game.PlaceId)
            local ok, body = pcall(function() return game:HttpGet(url) end)
            if not ok then return notify("Server Hop", "HTTP failed", "x") end
            local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
            if not ok2 or type(data) ~= "table" or not data.data then return end
            local pick
            for _, s in ipairs(data.data) do
                if s.id ~= game.JobId and s.playing and s.playing >= 1 and s.playing <= F.hopThreshold then pick = s break end
            end
            pick = pick or (function()
                for _, s in ipairs(data.data) do if s.id ~= game.JobId then return s end end
            end)()
            if pick then
                notify("Server Hop", "Joining " .. tostring(pick.playing) .. " players", "server")
                pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, pick.id, LP) end)
            end
        end
        Port.hopServer = hopServer
        task.spawn(function()
            local last = os.clock()
            while not Hub.unloaded do
                task.wait(5)
                if F.hop and os.clock() - last >= F.hopMinutes * 60 then
                    last = os.clock()
                    pcall(hopServer)
                end
                if not F.hop then last = os.clock() end
            end
        end)

        
        function Port.getGun()
            local drop = WS:FindFirstChild("GunDrop")
            local root = getRoot()
            if not (drop and drop:IsA("BasePart") and root) then return notify("Get Gun", "No dropped gun", "x") end
            local back = root.CFrame
            root.CFrame = drop.CFrame
            if type(firetouchinterest) == "function" then
                pcall(function() firetouchinterest(root, drop, 0) firetouchinterest(root, drop, 1) end)
            end
            task.wait(0.25)
            local r2 = getRoot()
            if r2 then r2.CFrame = back end
        end
        Port.instantGun = false
        task.spawn(function()
            while not Hub.unloaded do
                task.wait(0.3)
                if Port.instantGun and WS:FindFirstChild("GunDrop") and roleOf(LP) ~= "Murderer" then
                    pcall(Port.getGun)
                    task.wait(1.5)
                end
            end
        end)

        function Port.fling(plr)
            local root, tr = getRoot(), playerRoot(plr)
            if not (root and tr) then return end
            local saved = root.CFrame
            local t0 = os.clock()
            local conn = RunService.Heartbeat:Connect(function()
                local r, t = getRoot(), playerRoot(plr)
                if not (r and t) then return end
                r.CFrame = t.CFrame
                r.AssemblyLinearVelocity = Vector3.new(9e5, 9e5, 9e5)
                r.AssemblyAngularVelocity = Vector3.new(9e5, 9e5, 9e5)
            end)
            while os.clock() - t0 < 1.4 and alive(plr) do task.wait() end
            conn:Disconnect()
            local r = getRoot()
            if r then
                r.AssemblyLinearVelocity, r.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
                r.CFrame = saved
            end
        end
        function Port.flingByName(name)
            local plr = Players:FindFirstChild(cleanName(name))
            if plr then task.spawn(Port.fling, plr) else notify("Fling", "Select a player", "x") end
        end
        function Port.flingAll()
            task.spawn(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and alive(plr) then Port.fling(plr) task.wait(0.2) end
                end
            end)
        end

        
        local CH = { on = false, glyph = "⌖", visibility = "Shiftlock / First Person", size = 30, rgb = false, color = Color3.new(1, 1, 1) }
        Port.crosshair = CH
        local chGui, chLabel
        local GLYPHS = { star = "★", heart = "♥", ["circle-plus"] = "⊕", crosshair = "⌖" }
        function Port.setCrosshair()
            if not CH.on then
                if chGui then chGui:Destroy() chGui, chLabel = nil, nil end
                return
            end
            if not chGui then
                chGui = Instance.new("ScreenGui")
                chGui.Name, chGui.IgnoreGuiInset, chGui.ResetOnSpawn, chGui.DisplayOrder = "ServaCrosshair", true, false, 50
                chLabel = Instance.new("TextLabel")
                chLabel.AnchorPoint, chLabel.Position = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5)
                chLabel.BackgroundTransparency, chLabel.Font = 1, Enum.Font.GothamBold
                chLabel.TextStrokeTransparency = 0.4
                chLabel.Parent = chGui
                chGui.Parent = LP:WaitForChild("PlayerGui")
            end
            chLabel.Text = GLYPHS[CH.glyph] or "⌖"
            chLabel.Size = UDim2.fromOffset(CH.size * 2, CH.size * 2)
            chLabel.TextSize = CH.size
        end
        function Port.setCrosshairStyle(s) CH.glyph = s Port.setCrosshair() end
        bind(RunService.RenderStepped:Connect(function()
            if not (CH.on and chLabel) then return end
            local cam = WS.CurrentCamera
            local firstPerson = cam and (cam.CFrame.Position - cam.Focus.Position).Magnitude < 1.2
            local shiftlock = UIS.MouseBehavior == Enum.MouseBehavior.LockCenter
            chLabel.Visible = CH.visibility == "Always" or firstPerson or shiftlock
            chLabel.TextColor3 = CH.rgb and Color3.fromHSV((os.clock() * 0.25) % 1, 1, 1) or CH.color
        end))

        
        local btnGui
        local buttons = {}
        local function ensureBtnGui()
            if btnGui and btnGui.Parent then return btnGui end
            btnGui = Instance.new("ScreenGui")
            btnGui.Name, btnGui.ResetOnSpawn, btnGui.DisplayOrder = "ServaButtons", false, 40
            btnGui.Parent = LP:WaitForChild("PlayerGui")
            return btnGui
        end
        local BTN_POS = { GetGun = 0, BombJump = 1, XRay = 2, Aimlock = 3, Fly = 4, Noclip = 5, Throw = 6 }
        function Port.setButton(key, text, on, action)
            if buttons[key] then buttons[key]:Destroy() buttons[key] = nil end
            if not on then return end
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(74, 44)
            b.Position = UDim2.new(1, -90, 0.2, (BTN_POS[key] or 0) * 52)
            b.BackgroundColor3 = Color3.fromRGB(11, 19, 43)
            b.TextColor3 = Color3.fromRGB(244, 248, 255)
            b.Font, b.TextSize, b.Text = Enum.Font.GothamBold, 13, text
            local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 10) c.Parent = b
            local s = Instance.new("UIStroke") s.Color = Color3.fromRGB(137, 207, 240) s.Thickness = 1.5 s.Parent = b
            -- drag
            local dragging, moved, startPos, startInput
            b.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging, moved, startPos, startInput = true, false, b.Position, i.Position
                end
            end)
            UIS.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
                    local d = i.Position - startInput
                    if d.Magnitude > 6 then moved = true end
                    if moved then
                        b.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
                    end
                end
            end)
            UIS.InputEnded:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1) then
                    dragging = false
                    if not moved then pcall(action) end
                end
            end)
            b.Parent = ensureBtnGui()
            buttons[key] = b
        end

       
        local emoteList, currentTrack = {}, nil
        Port.emoteSpeed = 1
        function Port.addEmote(text)
            local id = tostring(text or ""):match("%d+")
            if not id then return notify("Emotes", "Invalid ID", "x") end
            local name = "Emote " .. id
            emoteList[name] = "rbxassetid://" .. id
            local names = {}
            for n in pairs(emoteList) do table.insert(names, n) end
            table.sort(names)
            if Port.objs.emoteDrop then pcall(function() Port.objs.emoteDrop:Refresh(names) end) end
            notify("Emotes", "Added " .. name)
        end
        function Port.playEmote(name)
            local id = emoteList[name]
            if not id then return end
            local hum = getHum()
            local animator = hum and (hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 2))
            if not animator then return end
            if currentTrack then currentTrack:Stop() end
            local anim = Instance.new("Animation")
            anim.AnimationId = id
            currentTrack = animator:LoadAnimation(anim)
            currentTrack.Priority = Enum.AnimationPriority.Action4
            currentTrack.Looped = true
            currentTrack:Play()
            currentTrack:AdjustSpeed(Port.emoteSpeed)
        end
        function Port.setEmoteSpeed(v)
            Port.emoteSpeed = v
            if currentTrack then pcall(function() currentTrack:AdjustSpeed(v) end) end
        end
        function Port.syncItems()
            local names, seen = {}, {}
            local function scan(container)
                if not container then return end
                for _, t in ipairs(container:GetChildren()) do
                    if t:IsA("Tool") and not seen[t.Name] then seen[t.Name] = true table.insert(names, t.Name) end
                end
            end
            scan(LP:FindFirstChildOfClass("Backpack"))
            scan(LP.Character)
            if #names == 0 then names = { "(No synced items)" } end
            if Port.objs.itemDrop then
                pcall(function() Port.objs.itemDrop:Refresh(names) end)
                pcall(function() Port.objs.itemDrop:Select(names[1]) end)
            end
            notify("Items", ("Synced %d item(s)"):format(#names))
        end
        function Port.equipItem(name)
            local bp = LP:FindFirstChildOfClass("Backpack")
            local tool = bp and bp:FindFirstChild(cleanName(name))
            local hum = getHum()
            if tool and hum then hum:EquipTool(tool) else notify("Items", "Item not found", "x") end
        end

        
        local R = { id = "", mode = "Server (FE)", volume = 50, loop = false }
        Port.radio = R
        local radioSound
        local function playSongRemote()
            local rem = RS:FindFirstChild("Remotes")
            local inv = rem and rem:FindFirstChild("Inventory")
            return inv and inv:FindFirstChild("PlaySong")
        end
        function Port.playRadio()
            local id = tostring(R.id):match("%d+")
            if not id then return notify("Radio", "Enter a valid audio ID", "x") end
            local remote = playSongRemote()
            if R.mode == "Server (FE)" and LP:GetAttribute("Radio") and remote and remote:IsA("RemoteEvent") then
                remote:FireServer("https://www.roblox.com/asset/?id=" .. id)
                return notify("FE Radio", "Playing via server radio", "radio")
            end
            if R.mode == "Server (FE)" then notify("Radio", "No Radio access — playing locally", "headphones") end
            if not radioSound then
                radioSound = Instance.new("Sound")
                radioSound.Name = "ServaRadio"
                radioSound.Parent = SoundService
            end
            radioSound.SoundId = "rbxassetid://" .. id
            radioSound.Volume = R.volume / 100 * 2
            radioSound.Looped = R.loop
            radioSound:Play()
        end
        function Port.stopRadio()
            if radioSound then radioSound:Stop() radioSound.SoundId = "" end
            local remote = playSongRemote()
            if R.mode == "Server (FE)" and LP:GetAttribute("Radio") and remote and remote:IsA("RemoteEvent") then
                remote:FireServer("")
            end
        end
        function Port.setRadioVolume(v)
            R.volume = v
            if radioSound then radioSound.Volume = v / 100 * 2 end
        end
        function Port.setRadioLoop(v)
            R.loop = v
            if radioSound then radioSound.Looped = v end
        end

        
        function Port.unload()
            pcall(clearAllEsp)
            pcall(Port.setShader, "Default")
            pcall(Port.setSky, "Default")
            W.snow, W.fog = false, false
            pcall(Port.updateWeather)
            pcall(Port.setBlackScreen, false)
            pcall(Port.set3D, false)
            Port.setFarm(false)
            F.hop = false
            CH.on = false
            pcall(Port.setCrosshair)
            for k in pairs(buttons) do pcall(Port.setButton, k, "", false) end
            if fovCircle then pcall(function() fovCircle:Remove() end) end
            if radioSound then radioSound:Destroy() end
            if Port.safePart then Port.safePart:Destroy() end
            A.silent, A.aimlock, A.antiKick, A.bulletTracer = false, false, false, false
            shootState.autoShoot = false
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
        Title = "Version v1.1 [ Beta ]  — November 13, 2026",
        Desc = "+ Look at the functions"
    })

    Window:Divider()

    local CombatTab = Window:Tab({ Title = "Sheriff", Icon = "crosshair" })

    local aimSection = CombatTab:Section({ Title = "Aim", Icon = "target", Opened = true })
    aimSection:Toggle({ Title = "Aimlock", Value = false, Callback = function(v) Hub.Port.cfg.aimlock = not not v end })
    aimSection:Dropdown({ Title = "Aim Target Part", Values = { "Head", "Body" }, Value = "Head", Callback = function(v) Hub.Port.cfg.aimPart = (v == "Head") and "Head" or "Body" end })
    aimSection:Keybind({ Title = "Aimlock Keybind", Value = "Q", Callback = function() Hub.Port.cfg.aimActive = not Hub.Port.cfg.aimActive WindUI:Notify({ Title = "Aimlock", Content = Hub.Port.cfg.aimActive and "Active" or "Paused", Icon = "crosshair", Duration = 1.5 }) end })
    aimSection:Slider({ Title = "Prediction Strength", Value = { Min = 1, Max = 15, Default = 5, Rounding = 1 }, Callback = function(v) Hub.Port.cfg.predict = tonumber(v) or 5 end })
    aimSection:Toggle({ Title = "Silent Aim", Value = false, Callback = function(v) Hub.Port.cfg.silent = not not v if v and not Hub.Port.hookOk then WindUI:Notify({ Title = "Silent Aim", Content = "Executor has no hookmetamethod support", Icon = "x", Duration = 3 }) end end })
    aimSection:Toggle({ Title = "Ignore Walls", Value = false, Callback = function(v) Hub.Port.cfg.ignoreWalls = not not v end })
   aimSection:Toggle({ Title = "Show FOV", Value = true, Callback = function(v) Hub.Port.cfg.showFov = not not v end })
   aimSection:Slider({ Title = "FOV Size", Value = { Min = 50, Max = 400, Default = 150, Rounding = 1 }, Callback = function(v) Hub.Port.cfg.fov = tonumber(v) or 150 end })
   aimSection:Colorpicker({ Title = "FOV Color", Default = Color3.fromRGB(137, 207, 240), Callback = function(v) Hub.Port.cfg.fovColor = v end })
   

    local sheriffSection = CombatTab:Section({ Title = "Auto Shoot", Icon = "shield", Opened = true })
    sheriffSection:Toggle({ Title = "Auto Shoot", Value = false, Callback = function(v) Hub.Port.setAutoShoot(v) end })
    sheriffSection:Dropdown({ Title = "Auto Shoot Mode", Values = { "Normal", "Behind Walls" }, Value = "Normal", Callback = function(v) Hub.Port.setAutoShootMode(v) end })
    sheriffSection:Dropdown({ Title = "Auto Shoot Part", Values = { "Head", "Body" }, Value = "Head", Callback = function(v) end })


local MurdererTab = Window:Tab({ Title = "Murderer", Icon = "swords" })

    local murderSection = MurdererTab:Section({ Title = "Murder", Icon = "crosshair", Opened = true })
    murderSection:Toggle({
        Title = "Kill Aura",
        Value = false,
        Callback = function(v) murder.killAura = not not v end
    })
    murderSection:Slider({
        Title = "Aura Radius",
        Value = { Min = 5, Max = 60, Default = 20, Rounding = 1 },
        Callback = function(v) murder.auraRadius = tonumber(v) or 20 end
    })
    murderSection:Keybind({
        Title = "Kill All Keybind",
        Value = "-",
        Callback = function()
            if murGetKnife() then
                pcall(murKillTargets, math.huge, murder.killGunPlayers)
                WindUI:Notify({ Title = "Kill All", Content = "Attempted kill all players", Icon = "skull", Duration = 2 })
            else
                WindUI:Notify({ Title = "Kill All", Content = "Knife is not equipped", Icon = "x", Duration = 2 })
            end
        end
    })
    murderSection:Toggle({
        Title = "Kill All",
        Value = false,
        Callback = function(v) murder.killAll = not not v end
    })
    murderSection:Toggle({
        Title = "Kill Gun Players",
        Value = false,
        Callback = function(v) murder.killGunPlayers = not not v end
    })

    local knifeThrowSection = MurdererTab:Section({ Title = "Knife Throw", Icon = "zap", Opened = true })
    knifeThrowSection:Toggle({
        Title = "Knife Throw Aimbot",
        Value = false,
        Callback = function(v) murder.aimbot = not not v end
    })
    knifeThrowSection:Dropdown({
        Title = "Target Mode",
        Values = { "Smart", "Crosshair", "Nearest", "Sheriff First" },
        Value = "Smart",
        Callback = function(v) murder.targetMode = v end
    })
    knifeThrowSection:Slider({
        Title = "Max Distance",
        Value = { Min = 20, Max = 500, Default = 250, Rounding = 1 },
        Callback = function(v) murder.maxDistance = tonumber(v) or 250 end
    })
    knifeThrowSection:Slider({
        Title = "Aim FOV",
        Value = { Min = 10, Max = 360, Default = 360, Rounding = 1 },
        Callback = function(v) murder.aimFOV = tonumber(v) or 360 end
    })
    knifeThrowSection:Toggle({
        Title = "Auto Throw",
        Value = false,
        Callback = function(v) murder.autoThrow = not not v end
    })
    knifeThrowSection:Slider({
        Title = "Auto Min Chance %",
        Value = { Min = 10, Max = 100, Default = 55, Rounding = 1 },
        Callback = function(v) murder.minChance = tonumber(v) or 55 end
    })
    knifeThrowSection:Slider({
        Title = "Auto Range",
        Value = { Min = 10, Max = 150, Default = 70, Rounding = 1 },
        Callback = function(v) murder.autoRange = tonumber(v) or 70 end
    })
    knifeThrowSection:Toggle({
        Title = "Wall Check",
        Value = true,
        Callback = function(v) murder.wallCheck = not not v end
    })
    knifeThrowSection:Toggle({
        Title = "Predict Movement",
        Value = true,
        Callback = function(v) murder.predict = not not v end
    })
    knifeThrowSection:Slider({
        Title = "Lead %",
        Value = { Min = 0, Max = 100, Default = 100, Rounding = 1 },
        Callback = function(v) murder.lead = tonumber(v) or 100 end
    })
    knifeThrowSection:Toggle({
        Title = "Sticky Target",
        Value = true,
        Callback = function(v) murder.sticky = not not v end
    })
    knifeThrowSection:Toggle({
        Title = "Target Marker",
        Value = true,
        Callback = function(v) murder.targetMarker = not not v end
    })

    local tracersSection = MurdererTab:Section({ Title = "Knife Tracers", Icon = "spline", Opened = true })
    tracersSection:Toggle({
        Title = "Knife Tracers",
        Value = false,
        Callback = function(v) murder.tracers = not not v end
    })

    local FarmTab = Window:Tab({ Title = "Farm", Icon = "coins" })

    local progSection = FarmTab:Section({ Title = "Progression", Icon = "trending-up", Opened = true })
    progSection:Toggle({ Title = "Auto Prestige", Value = false, Callback = function(v) end })
    progSection:Toggle({ Title = "Auto Claim Rewards", Value = true, Callback = function(v) end })

    local coinFarmSection = FarmTab:Section({ Title = "Coin Farm", Icon = "circle-dollar-sign", Opened = true })
    coinFarmSection:Toggle({ Title = "Coin Farm", Value = false, Callback = function(v) Hub.Port.setFarm(v) end })
    coinFarmSection:Dropdown({ Title = "Farm Mode", Values = { "Teleport (Instant)", "Fly (Smooth)" }, Value = "Teleport (Instant)", Callback = function(v) Hub.Port.farm.mode = v end })
    coinFarmSection:Dropdown({ Title = "Farm Position", Values = { "Normal", "Under" }, Value = "Normal", Callback = function(v) Hub.Port.farm.pos = v end })
    coinFarmSection:Slider({ Title = "Farm Speed", Value = { Min = 10, Max = 60, Default = 28, Rounding = 1 }, Callback = function(v) Hub.Port.farm.speed = tonumber(v) or 28 end })
    coinFarmSection:Toggle({ Title = "Farm XP", Value = false, Callback = function(v) end })
    coinFarmSection:Toggle({ Title = "End Round When Bag Full", Value = false, Callback = function(v) Hub.Port.farm.endRound = not not v end })
    coinFarmSection:Toggle({ Title = "Black Screen", Value = false, Callback = function(v) Hub.Port.setBlackScreen(not not v) end })
    coinFarmSection:Toggle({ Title = "Disable 3D Rendering", Value = false, Callback = function(v) Hub.Port.set3D(not not v) end })

    local serverHopSection = FarmTab:Section({ Title = "Server Hop", Icon = "server", Opened = true })
    serverHopSection:Toggle({ Title = "Server Hop Low Players", Value = false, Callback = function(v) Hub.Port.farm.hop = not not v end })
    serverHopSection:Slider({ Title = "Player Threshold", Value = { Min = 1, Max = 6, Default = 4, Rounding = 1 }, Callback = function(v) Hub.Port.farm.hopThreshold = tonumber(v) or 4 end })
    serverHopSection:Slider({ Title = "Server Hop Timer (min)", Value = { Min = 10, Max = 30, Default = 15, Rounding = 1 }, Callback = function(v) Hub.Port.farm.hopMinutes = tonumber(v) or 15 end })
    serverHopSection:Toggle({ Title = "Anti-Bot Server Hop", Value = false, Callback = function(v) end })

    local webhookSection = FarmTab:Section({ Title = "Webhook", Icon = "webhook", Opened = true })
    webhookSection:Input({ Title = "Discord Webhook URL", Placeholder = "https://discord.com/api/webhooks/...", Callback = function(v) Hub.Port.farm.webhook = tostring(v or "") end })
    webhookSection:Button({ Title = "Test Webhook", Icon = "send", Callback = function() Hub.Port.testWebhook() end })

    local eventBoxSection = FarmTab:Section({ Title = "Event Boxes", Icon = "gift", Opened = true })
    eventBoxSection:Dropdown({ Title = "Box", Values = { "Unavailable" }, Value = "Unavailable", Callback = function(v) end })
    eventBoxSection:Dropdown({ Title = "Currency", Values = { "Coins", "Gems", "Keys" }, Value = "Coins", Callback = function(v) end })
    eventBoxSection:Button({ Title = "Buy Box", Icon = "shopping-cart", Callback = function() end })
    eventBoxSection:Toggle({ Title = "Auto Buy Boxes", Value = false, Callback = function(v) end })

    
    local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye" })

    local espSection = VisualsTab:Section({ Title = "ESP Settings", Icon = "scan-eye", Opened = true })
    espSection:Toggle({ Title = "Player ESP", Value = false, Callback = function(v) Hub.Port.esp.on = not not v end })
    espSection:Dropdown({ Title = "Style ESP", Values = { "Filled", "Outline" }, Value = "Filled", Callback = function(v) Hub.Port.esp.style = v end })
    espSection:Colorpicker({ Title = "Player ESP Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(v) Hub.Port.esp.color = v end })
    espSection:Toggle({ Title = "Tracers ESP", Value = false, Callback = function(v) Hub.Port.esp.line = not not v end })
    espSection:Toggle({ Title = "Nametag ESP", Value = false, Callback = function(v) Hub.Port.esp.name = not not v end })
    espSection:Toggle({ Title = "Gun ESP", Value = false, Callback = function(v) Hub.Port.esp.gun = not not v end })
    espSection:Toggle({ Title = "Coin ESP", Value = false, Callback = function(v) Hub.Port.esp.coin = not not v end })
    espSection:Toggle({ Title = "360 ESP", Value = false, Callback = function(v) Hub.Port.esp.around = not not v end })
    espSection:Toggle({ Title = "Sheriff ESP", Value = false, Callback = function(v) Hub.Port.esp.around = not not v end })
    espSection:Toggle({ Title = "Murderer ESP", Value = false, Callback = function(v) Hub.Port.esp.around = not not v end })
    espSection:Toggle({ Title = "Box ESP", Value = false, Callback = function(v) Hub.Port.esp.around = not not v end })
    

    local tracerSection = VisualsTab:Section({ Title = "Bullet Tracer", Icon = "zap", Opened = true })
    tracerSection:Toggle({ Title = "Bullet Tracer", Value = false, Callback = function(v) Hub.Port.cfg.bulletTracer = not not v end })
    tracerSection:Colorpicker({ Title = "Tracer Color", Default = Color3.fromRGB(255, 55, 75), Callback = function(v) Hub.Port.cfg.tracerColor = v end })
    tracerSection:Slider({ Title = "Tracer Duration", Value = { Min = 0.1, Max = 3, Default = 0.5, Rounding = 0.1 }, Callback = function(v) Hub.Port.cfg.tracerDur = tonumber(v) or 0.5 end })

    local xraySection = VisualsTab:Section({ Title = "X-Ray", Icon = "scan", Opened = true })
    xraySection:Toggle({ Title = "X-Ray (Wall Transparency)", Value = false, Callback = function(v) toggleXray(not not v) end })
    xraySection:Keybind({ Title = "X-Ray Keybind", Value = "V", Callback = function() toggleXray(not PlayerState.XrayEnabled) end })

    local shaderSection = VisualsTab:Section({ Title = "Shaders & Lighting", Icon = "sun", Opened = true })
    shaderSection:Dropdown({
        Title = "Shader Preset",
        Values = { "Default", "RTX Reflection", "Realistic", "Deep", "Cinematic", "Soft" },
        Value = "Default",
        Callback = function(v) Hub.Port.setShader(v) end
    })

    local skySection = VisualsTab:Section({ Title = "Skybox", Icon = "cloud", Opened = true })
    skySection:Dropdown({ Title = "Skybox", Values = { "Default", "Purple Nebula", "Dreamy Sunset", "Redshift" }, Value = "Default", Callback = function(v) Hub.Port.setSky(v) end })

    local weatherSection = VisualsTab:Section({ Title = "Weather", Icon = "cloud-snow", Opened = true })
    weatherSection:Toggle({ Title = "Snow", Value = false, Callback = function(v) Hub.Port.weather.snow = not not v Hub.Port.updateWeather() end })
    weatherSection:Dropdown({ Title = "Snow Density", Values = { "Low", "Medium", "High" }, Value = "Medium", Callback = function(v) Hub.Port.weather.density = v Hub.Port.updateWeather() end })
    weatherSection:Toggle({ Title = "Fog", Value = false, Callback = function(v) Hub.Port.weather.fog = not not v Hub.Port.updateWeather() end })
    weatherSection:Colorpicker({ Title = "Fog Color", Default = Color3.fromRGB(188, 194, 204), Callback = function(v) Hub.Port.weather.fogColor = v Hub.Port.updateWeather() end })
    weatherSection:Dropdown({ Title = "Fog Density", Values = { "Low", "Medium", "High" }, Value = "Medium", Callback = function(v) Hub.Port.weather.fogDensity = v Hub.Port.updateWeather() end })

   
    local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })

    local moveSection = PlayerTab:Section({ Title = "Movement", Icon = "move", Opened = true })
    
    moveSection:Slider({ Title = "WalkSpeed", Value = { Min = 16, Max = 500, Default = 16, Rounding = 1 }, Callback = function(v) 
        local h = getHum()
        if h then h.WalkSpeed = v end
    end })
    
    moveSection:Slider({ Title = "JumpPower", Value = { Min = 50, Max = 500, Default = 50, Rounding = 1 }, Callback = function(v) 
        local h = getHum()
        if h then h.JumpPower = v end
    end })
    
    moveSection:Toggle({ Title = "Infinite Jump", Value = false, Callback = toggleInfJump })
    
    moveSection:Toggle({ Title = "Speed Glitch", Value = false, Callback = function(v) 
        Hub.SpeedGlitchEnabled = v
    end })
    
    moveSection:Slider({ Title = "Speed Glitch Power", Value = { Min = 1, Max = 5, Default = 2, Rounding = 1 }, Callback = function(v) 
        Hub.SpeedGlitchPower = v
    end })

    moveSection:Toggle({ Title = "Bomb Jump", Value = false, Callback = toggleBombJump })
    moveSection:Keybind({ Title = "Bomb Jump Keybind", Value = "B", Callback = function()
        bombJumpAuto()
    end })
    
    moveSection:Toggle({ Title = "Noclip", Value = false, Callback = toggleNoclip })
    moveSection:Keybind({ Title = "Noclip Keybind", Value = "N", Callback = function() 
        toggleNoclip(not PlayerState.NoclipEnabled)
    end })

    Hub.SpeedGlitchEnabled = false
    Hub.SpeedGlitchPower = 2
    bind(RunService.Heartbeat:Connect(function(dt)
        if not Hub.SpeedGlitchEnabled then return end
        local char = LP.Character
        local hum = getHum()
        local root = getRoot()
        if char and hum and root and hum.MoveDirection.Magnitude > 0 and hum.FloorMaterial == Enum.Material.Air then
            root.CFrame = root.CFrame + hum.MoveDirection * Hub.SpeedGlitchPower * 15 * dt
            local vel = root.AssemblyLinearVelocity
            if vel.Y < 0 then
                root.AssemblyLinearVelocity = Vector3.new(vel.X, vel.Y * 0.97, vel.Z)
            end
        end
    end))

    local flySection = PlayerTab:Section({ Title = "Fly", Icon = "plane", Opened = true })
    flySection:Toggle({ Title = "Fly", Value = false, Callback = toggleFly })
    flySection:Slider({ Title = "Fly Speed", Value = { Min = 10, Max = 200, Default = 50, Rounding = 1 }, Callback = function(v) 
        PlayerState.FlySpeed = v
    end })
    flySection:Keybind({ Title = "Fly Keybind", Value = "F", Callback = function() 
        toggleFly(not PlayerState.FlyEnabled)
    end })

    local noclipCamSection = PlayerTab:Section({ Title = "No Clip Camera", Icon = "camera", Opened = true })
    noclipCamSection:Toggle({
        Title = "No Clip Camera",
        Value = false,
        Callback = toggleNoclipCamera
    })

    local antiAimSection = PlayerTab:Section({ Title = "Dodge Settings", Icon = "shield-off", Opened = true })
    antiAimSection:Toggle({
        Title = "Dodge Settings",
        Value = false,
        Callback = function(v)
            aaState.on = not not v
            PlayerState.AntiAimEnabled = not not v
            if not v then aaRestoreFake() end
        end
    })
    antiAimSection:Dropdown({
        Title = "Desyns Type",
        Values = { "Desync", "Prediction" },
        Value = "Desync",
        Callback = function(v)
            aaState.mode = v
            aaRestoreFake()
        end
    })
    antiAimSection:Dropdown({
        Title = "Direction",
        Values = { "Random", "Back", "Sides" },
        Value = "Random",
        Callback = function(v)
            aaState.dir = v
        end
    })
    antiAimSection:Toggle({
        Title = "Wallbang",
        Value = false,
        Callback = function(v) shootState.wallbang = not not v end
    })
    antiAimSection:Toggle({
        Title = "Auto Shoot Murder",
        Value = false,
        Callback = function(v) shootState.autoShoot = not not v end
    })
    antiAimSection:Toggle({
        Title = "Auto Fling Sheriff",
        Value = false,
        Callback = function(v) shootState.flingSheriff = not not v end
    })
    antiAimSection:Dropdown({
        Title = "Shot Timing",
        Values = { "Accurate", "Instant" },
        Value = "Accurate",
        Callback = function(v) shootState.timing = v end
    })
    antiAimSection:Paragraph({
        Title = "Anti-Aim",
        Desc = "Desync moves your server-side body, Prediction strafes away from the Sheriff."
    })

    local antiCoinSection = PlayerTab:Section({ Title = "Anti Coin", Icon = "coins", Opened = true })
    antiCoinSection:Toggle({
        Title = "Anti Coin",
        Value = false,
        Callback = function(v)
            PlayerState.AntiCoinEnabled = not not v
            if not PlayerState.AntiCoinEnabled then
                for part, original in pairs(antiCoinState.coins) do
                    if part.Parent then pcall(function() part.CanTouch = original end) end
                end
                table.clear(antiCoinState.coins)
                for part, original in pairs(antiCoinState.characterParts) do
                    if part.Parent then pcall(function() part.CanTouch = original end) end
                end
                table.clear(antiCoinState.characterParts)
                antiCoinState.strict = false
            else
                pcall(antiCoinScan)
                if antiCoinState.strict then pcall(antiCoinBlockCharacter) end
            end
        end
    })
    antiCoinSection:Paragraph({
        Title = "Anti Coin",
        Desc = "Prevents coins from being collected."
    })

    local gravitySection = PlayerTab:Section({ Title = "Gravity", Icon = "arrow-down", Opened = true })
    gravitySection:Toggle({
        Title = "Gravity",
        Value = false,
        Callback = function(v) toggleGravity(v) end
    })
    gravitySection:Slider({
        Title = "Gravity Value",
        Value = { Min = 5, Max = 400, Default = 196, Rounding = 1 },
        Callback = function(v)
            grav.value = tonumber(v) or 196
            PlayerState.GravityValue = grav.value
            if grav.on then
                WS.Gravity = grav.value
                grav.applied = true
            end
        end
    })

    local hipSection = PlayerTab:Section({ Title = "Hip Height", Icon = "ruler", Opened = true })
    hipSection:Toggle({
        Title = "Hip Height",
        Value = false,
        Callback = function(v) toggleHipHeight(v) end
    })
    hipSection:Slider({
        Title = "Hip Height Value",
        Value = { Min = 0, Max = 30, Default = 2, Rounding = 0.1 },
        Callback = function(v)
            hip.value = tonumber(v) or 2
            PlayerState.HipHeightValue = hip.value
            if hip.on then applyHipHeight() end
        end
    })

    local xrayPlayerSection = PlayerTab:Section({ Title = "X-Ray", Icon = "scan", Opened = true })
    xrayPlayerSection:Toggle({
        Title = "X-Ray (Wall Transparency)",
        Value = false,
        Callback = toggleXray
    })
    xrayPlayerSection:Slider({
        Title = "X-Ray Strength",
        Value = { Min = 10, Max = 100, Default = 70, Rounding = 1 },
        Callback = function(v)
            PlayerState.XrayStrength = v / 100
            if PlayerState.XrayEnabled then xrayRefresh() end
        end
    })
    xrayPlayerSection:Keybind({
        Title = "X-Ray Keybind",
        Value = "V",
        Callback = function()
            toggleXray(not PlayerState.XrayEnabled)
        end
    })

    local wallHopSection = PlayerTab:Section({ Title = "Wall Hop", Icon = "arrow-up-from-line", Opened = true })
    wallHopSection:Toggle({
        Title = "Wall Hop",
        Value = false,
        Callback = toggleWallHop
    })
    wallHopSection:Dropdown({
        Title = "Hop Mode",
        Values = { "Press", "Hold" },
        Value = "Press",
        Callback = function(v)
            if v ~= "Press" and v ~= "Hold" then return end
            PlayerState.WallHopMode = v
            wallhop.mode = v
        end
    })
    wallHopSection:Slider({
        Title = "Flick Angle",
        Value = { Min = 30, Max = 180, Default = 90, Rounding = 1 },
        Callback = function(v)
            PlayerState.WallHopAngle = v
            wallhop.angle = v
        end
    })
    wallHopSection:Toggle({
        Title = "Camera Flick",
        Value = false,
        Callback = function(v)
            PlayerState.WallHopCamFlick = not not v
            wallhop.camFlick = not not v
        end
    })

    local extrasSection = PlayerTab:Section({ Title = "Extras", Icon = "sparkles", Opened = true })
    
    extrasSection:Toggle({ Title = "Spinbot", Value = false, Callback = toggleSpinbot })
    extrasSection:Slider({ Title = "Spin Speed", Value = { Min = 1, Max = 10, Default = 3, Rounding = 1 }, Callback = function(v) 
        PlayerState.SpinbotSpeed = v
    end })
    
    extrasSection:Toggle({ Title = "Invisibility", Value = false, Callback = toggleInvisibility })
    extrasSection:Toggle({ Title = "Anti-Fling", Value = false, Callback = toggleAntiFling })

    local AnimsTab = Window:Tab({ Title = "Anims", Icon = "play" })
    local emotesSection = AnimsTab:Section({ Title = "Emotes", Icon = "smile", Opened = true })
    emotesSection:Button({ Title = "Sync In-Game Emotes", Icon = "download", Callback = function() end })
    emotesSection:Toggle({ Title = "Auto Sync Emotes", Value = false, Callback = function(v) end })
    emotesSection:Dropdown({ Title = "Ready Animation", Values = { "Fake Dead 1", "Fake Dead 2", "Wall Phase (GLITCH)" }, Value = "Fake Dead 1", Callback = function(v) end })
    emotesSection:Button({ Title = "Sync Selected Animation", Icon = "download", Callback = function() end })
    emotesSection:Input({ Title = "Custom Emote ID / URL", Placeholder = "rbxassetid://...", Callback = function(v) Hub.Port.emoteInput = tostring(v or "") end })
    emotesSection:Button({ Title = "Add Custom Emote", Icon = "plus", Callback = function() Hub.Port.addEmote(Hub.Port.emoteInput) end })
    Hub.Port.objs.emoteDrop = emotesSection:Dropdown({ Title = "Play Emote", Values = { "None" }, Value = "None", Callback = function(v) Hub.Port.playEmote(v) end })
    emotesSection:Slider({ Title = "Animation Speed", Value = { Min = 0.1, Max = 3, Default = 1, Rounding = 0.1 }, Callback = function(v) Hub.Port.setEmoteSpeed(tonumber(v) or 1) end })

    local itemsSection = AnimsTab:Section({ Title = "Items", Icon = "package", Opened = true })
    itemsSection:Button({ Title = "Sync In-Game Items", Icon = "download", Callback = function() Hub.Port.syncItems() end })
    itemsSection:Toggle({ Title = "Auto Sync Items", Value = false, Callback = function(v) end })
    Hub.Port.objs.itemDrop = itemsSection:Dropdown({ Title = "Select Item", Values = { "(No synced items)" }, Value = "(No synced items)", Callback = function(v) Hub.Port.itemSel = v end })
    itemsSection:Button({ Title = "Equip Selected Item", Icon = "hand", Callback = function() Hub.Port.equipItem(Hub.Port.itemSel) end })

    local glitchSection = AnimsTab:Section({ Title = "Wall Glitch", Icon = "brick-wall", Opened = true })
    glitchSection:Keybind({ Title = "Wall Glitch Keybind", Value = "G", Callback = function() end })
    glitchSection:Toggle({ Title = "Wall Glitch Button", Value = false, Callback = function(v) end })

    
    local RadioTab = Window:Tab({ Title = "Radio", Icon = "music" })
    RadioTab:Paragraph({ Title = "FE Radio", Desc = "Server (FE) uses MM2's replicated radio.", Image = "radio", ImageSize = 34 })
    local radioPlaySection = RadioTab:Section({ Title = "Player", Icon = "play-circle", Opened = true })
    radioPlaySection:Input({ Title = "Audio ID", Placeholder = "Enter a Roblox audio ID", Callback = function(v) Hub.Port.radio.id = tostring(v or "") end })
    radioPlaySection:Dropdown({ Title = "Radio Mode", Values = { "Server (FE)", "Local" }, Value = "Server (FE)", Callback = function(v) Hub.Port.radio.mode = v end })
    radioPlaySection:Button({ Title = "Play Radio", Icon = "play", Callback = function() Hub.Port.playRadio() end })
    radioPlaySection:Button({ Title = "Stop Radio", Icon = "square", Callback = function() Hub.Port.stopRadio() end })

    local radioSettingsSection = RadioTab:Section({ Title = "Settings", Icon = "settings", Opened = true })
    radioSettingsSection:Slider({ Title = "Local Volume", Value = { Min = 0, Max = 100, Default = 50, Rounding = 1 }, Callback = function(v) Hub.Port.setRadioVolume(tonumber(v) or 50) end })
    radioSettingsSection:Toggle({ Title = "Loop Local Radio", Value = false, Callback = function(v) Hub.Port.setRadioLoop(not not v) end })
    radioSettingsSection:Toggle({ Title = "Mute Other Players' Radios", Value = false, Callback = function(v) end })

   
    local TeleportsTab = Window:Tab({ Title = "Teleports", Icon = "map-pin" })
    local tpPlayersSection = TeleportsTab:Section({ Title = "Players", Icon = "users", Opened = true })
    tpPlayersSection:Button({ Title = "TP to Murderer", Icon = "skull", Callback = function() Hub.Port.tpRole("Murderer") end })
    tpPlayersSection:Button({ Title = "TP to Sheriff", Icon = "shield", Callback = function() Hub.Port.tpRole("Sheriff") end })
    Hub.Port.objs.tpDrop = tpPlayersSection:Dropdown({ Title = "TP to Player", Values = { "(No other players)" }, Value = "(No other players)", Callback = function(v) Hub.Port.tpPlayer(v) end })
    tpPlayersSection:Button({ Title = "Refresh Player List", Icon = "refresh-cw", Callback = function() Hub.Port.refreshPlayerDrops() end })

    local tpLocationsSection = TeleportsTab:Section({ Title = "Locations", Icon = "map", Opened = true })
    tpLocationsSection:Button({ Title = "TP to Gun", Icon = "crosshair", Callback = function() Hub.Port.tpGun() end })
    tpLocationsSection:Button({ Title = "TP to Safezone", Icon = "shield-check", Callback = function() Hub.Port.tpSafe() end })
    tpLocationsSection:Button({ Title = "TP to Lobby", Icon = "home", Callback = function() Hub.Port.tpLobby() end })
    tpLocationsSection:Button({ Title = "TP to Game Arena", Icon = "swords", Callback = function() Hub.Port.tpArena() end })

    local MiscTab = Window:Tab({ Title = "Misc", Icon = "wrench" })
    local crosshairSection = MiscTab:Section({ Title = "Crosshair", Icon = "crosshair", Opened = true })
    crosshairSection:Toggle({ Title = "Custom Crosshair", Value = false, Callback = function(v) Hub.Port.crosshair.on = not not v Hub.Port.setCrosshair() end })
    crosshairSection:Dropdown({ Title = "Crosshair Style", Values = { "star", "heart", "circle-plus", "crosshair" }, Value = "crosshair", Callback = function(v) Hub.Port.setCrosshairStyle(v) end })
    crosshairSection:Dropdown({ Title = "Crosshair Visibility", Values = { "Shiftlock / First Person", "Always" }, Value = "Shiftlock / First Person", Callback = function(v) Hub.Port.crosshair.visibility = v end })
    crosshairSection:Slider({ Title = "Crosshair Size", Value = { Min = 16, Max = 64, Default = 30, Rounding = 1 }, Callback = function(v) Hub.Port.crosshair.size = tonumber(v) or 30 Hub.Port.setCrosshair() end })
    crosshairSection:Toggle({ Title = "RGB Crosshair", Value = false, Callback = function(v) Hub.Port.crosshair.rgb = not not v end })
    crosshairSection:Colorpicker({ Title = "Crosshair Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(v) Hub.Port.crosshair.color = v end })
    crosshairSection:Input({ Title = "Custom Cursor Name", Placeholder = "sparkles (from lucide.dev)", Callback = function(v) end })

    local miscButtonsSection = MiscTab:Section({ Title = "Mobile Buttons", Icon = "layout-grid", Opened = true })
    miscButtonsSection:Toggle({ Title = "Mobile Quick Menu", Value = false, Callback = function(v) end })
    miscButtonsSection:Toggle({ Title = "Get Gun Button", Value = false, Callback = function(v) Hub.Port.setButton("GetGun", "Get Gun", v, Hub.Port.getGun) end })
    miscButtonsSection:Toggle({ Title = "Bomb Jump Button", Value = false, Callback = function(v) Hub.Port.setButton("BombJump", "Bomb", v, function() bombJumpAuto() end) end })
    miscButtonsSection:Toggle({ Title = "XRay Button", Value = false, Callback = function(v) Hub.Port.setButton("XRay", "XRay", v, function() toggleXray(not PlayerState.XrayEnabled) end) end })
    miscButtonsSection:Toggle({ Title = "Aimlock Button", Value = false, Callback = function(v) Hub.Port.setButton("Aimlock", "Aimlock", v, function() Hub.Port.cfg.aimActive = not Hub.Port.cfg.aimActive end) end })
    miscButtonsSection:Toggle({ Title = "Fly Button", Value = false, Callback = function(v) Hub.Port.setButton("Fly", "Fly", v, function() toggleFly(not PlayerState.FlyEnabled) end) end })
    miscButtonsSection:Toggle({ Title = "Noclip Button", Value = false, Callback = function(v) Hub.Port.setButton("Noclip", "Noclip", v, function() toggleNoclip(not PlayerState.NoclipEnabled) end) end })
    miscButtonsSection:Toggle({ Title = "Throw Knife Button", Value = false, Callback = function(v) Hub.Port.setButton("Throw", "Throw", v, function() local t = getRoot() and murPickTarget(getRoot()) local r = t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") if r then murThrowAt(r) end end) end })

    local miscUtilSection = MiscTab:Section({ Title = "Utilities", Icon = "tool", Opened = true })
    miscUtilSection:Keybind({ Title = "Get Gun Keybind", Value = "J", Callback = function() Hub.Port.getGun() end })
    miscUtilSection:Keybind({ Title = "Bomb Jump Keybind", Value = "B", Callback = function()
        bombJumpAuto()
    end })
    miscUtilSection:Toggle({ Title = "Instant Auto Take Gun", Value = false, Callback = function(v) Hub.Port.instantGun = not not v end })
    miscUtilSection:Toggle({ Title = "Anti-Kick", Value = false, Callback = function(v) Hub.Port.cfg.antiKick = not not v end })

    local miscPlayersSection = MiscTab:Section({ Title = "Other Players", Icon = "users", Opened = true })
    Hub.Port.objs.flingDrop = miscPlayersSection:Dropdown({ Title = "Select Player", Values = { "(No other players)" }, Value = "(No other players)", Callback = function(v) Hub.Port.flingTarget = v end })
    miscPlayersSection:Button({ Title = "Fling Selected Player", Icon = "wind", Callback = function() Hub.Port.flingByName(Hub.Port.flingTarget) end })
    miscPlayersSection:Button({ Title = "Fling All Players", Icon = "wind", Callback = function() Hub.Port.flingAll() end })

    Window:Divider()

    local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })
    local miscSection = SettingsTab:Section({ Title = "Misc", Icon = "shield" })
    miscSection:Toggle({ Title = "Anti AFK", Value = Settings.AntiAFK, Callback = function(v) setSetting("AntiAFK", v) end })

    local perfSection = SettingsTab:Section({ Title = "Performance", Icon = "activity" })
    perfSection:Toggle({ Title = "Hide Players", Value = Settings.HidePlayers, Callback = function(v) setSetting("HidePlayers", v) end })
    perfSection:Slider({ Title = "FPS Cap", Value = { Min = 15, Max = 240, Default = 60, Rounding = 5 }, Callback = function(v) setSetting("FPSCap", v) end })
    perfSection:Toggle({ Title = "Anti Lag", Value = Settings.AntiLag, Callback = function(v) setSetting("AntiLag", v) end })

    local uiSection = SettingsTab:Section({ Title = "UI Settings", Icon = "monitor" })
    uiSection:Toggle({
        Title = "Screen Stretch",
        Value = Settings.ScreenStretch,
        Callback = function(v)
            setSetting("ScreenStretch", v)
            if v then
                if getgenv().Resolution then getgenv().Resolution[".gg/scripters"] = 0.65 end
            else
                if getgenv().Resolution then getgenv().Resolution[".gg/scripters"] = 1.0 end
            end
        end
    })
    uiSection:Paragraph({ Title = "Minimum Transparency", Desc = "You can set background image transparency from 0 minimum to 1 maximum" })
    uiSection:Input({
        Title = "Background Transparency",
        Placeholder = "Enter number 0 - 1...",
        Value = "0.6",
        Callback = function(text)
            local num = tonumber(text)
            if num then
                num = math.clamp(num, 0, 1)
                pcall(function() Window:SetBackgroundImageTransparency(num) end)
                pcall(function()
                    for _, v in pairs(Window.Gui:GetDescendants()) do
                        if v:IsA("ImageLabel") and v.Name:lower():find("background") then
                            v.ImageTransparency = num
                        end
                    end
                end)
            end
        end
    })

    local bgDict = {
        ["Default"] = "rbxassetid://102252256446593",
        ["Main"] = "rbxassetid://116737345570479",
        ["Furina"] = "rbxassetid://132218816814577",
    }

    uiSection:Dropdown({
        Title = "Select Background",
        Values = {"Default", "Main", "Furina"},
        Value = "Default",
        Callback = function(opt)
            if bgDict[opt] then
                pcall(function() Window:SetBackgroundImage(bgDict[opt]) end)
            end
        end
    })

    uiSection:Input({
        Title = "Background ID / URL",
        Placeholder = "rbxassetid://1234567890",
        Callback = function(text)
            local val = tostring(text or "")
            if val:match("^rbxassetid://") or val:match("^https?://") or val:match("^%d+$") then
                if val:match("^%d+$") then val = "rbxassetid://" .. val end
                pcall(function() Window:SetBackgroundImage(val) end)
            end
        end
    })

    uiSection:Keybind({
        Title = "Toggle UI Keybind",
        Value = "H",
        Callback = function()
            pcall(function() Window:Toggle() end)
        end
    })

    uiSection:Button({ Title = "Toggle UI (Hide/Show)", Icon = "eye-off", Callback = function()
        pcall(function() Window:Toggle() end)
    end })

    local langSection = SettingsTab:Section({ Title = "Language", Icon = "globe" })
    local CurrentLanguage = "English"
    langSection:Dropdown({
        Title = "Select Language",
        Values = {"English", "Russian"},
        Value = "English",
        Callback = function(option) CurrentLanguage = option end
    })

    langSection:Button({
        Title = "Apply Language",
        Icon = "check",
        Callback = function()
            local t = {
                en = { info = "Information", settings = "Settings", sec_tg = "Telegram Channel", sec_changelog = "Changelog", sec_misc = "Misc", sec_perf = "Performance", sec_ui = "UI Settings", sec_lang = "Language", toast_title = "Success", toast_text = "Language Applied!" },
                ru = { info = "Информация", settings = "Настройки", sec_tg = "Телеграм", sec_changelog = "Обновления", sec_misc = "Разное", sec_perf = "Производительность", sec_ui = "Настройки UI", sec_lang = "Язык / Language", toast_title = "Успешно", toast_text = "Язык применен!" }
            }
            local dict = t[CurrentLanguage == "Russian" and "ru" or "en"]
            pcall(function() InfoTab:SetTitle(dict.info) end)
            pcall(function() SettingsTab:SetTitle(dict.settings) end)
            pcall(function() tgSection:SetTitle(dict.sec_tg) end)
            pcall(function() changelogSection:SetTitle(dict.sec_changelog) end)
            pcall(function() miscSection:SetTitle(dict.sec_misc) end)
            pcall(function() perfSection:SetTitle(dict.sec_perf) end)
            pcall(function() uiSection:SetTitle(dict.sec_ui) end)
            pcall(function() langSection:SetTitle(dict.sec_lang) end)
            WindUI:Notify({ Title = dict.toast_title, Content = dict.toast_text, Icon = "check", Duration = 3 })
        end
    })

    
    local configSection = SettingsTab:Section({ Title = "Configs", Icon = "folder-open" })
    local configManager = Window.ConfigManager
    local configName = "default"
    local selectedConfig = nil
    local autoLoadConfig = false
    local autoLoadName = "None"
    local autoLoadDropdown = nil
    local selectedConfigDropdown = nil

    local function sanitizeName(name)
        local s = tostring(name or ""):match("^%s*(.-)%s*$"):gsub("%.json$", ""):gsub("[^%w_%-]", "_"):gsub("_+", "_"):sub(1, 48)
        if s == "" then s = "default" end
        return s
    end

    local function getConfigList()
        local list = {}
        local seen = {}
        if not configManager or type(configManager.AllConfigs) ~= "function" then return list end
        local ok, res = pcall(function() return configManager:AllConfigs() end)
        if ok and type(res) == "table" then
            for k, v in pairs(res) do
                if type(v) ~= "string" then v = type(k) == "string" and k or nil end
                if v then
                    v = v:match("([^/\\]+)$") or v
                    local clean = sanitizeName(v)
                    if not seen[clean] then seen[clean] = true table.insert(list, clean) end
                end
            end
        end
        table.sort(list)
        return list
    end

    local function saveAutoLoadFile()
        if type(writefile) ~= "function" then return false end
        local path = type(configManager) == "table" and type(configManager.Path) == "string" and configManager.Path or "WindUI/ServaHub/config/"
        if not path:match("[/\\]$") then path = path .. "/" end
        local folder = path:match("^(.*)[/\\][^/\\]+$")
        if folder and type(isfolder) == "function" and not isfolder(folder) and type(makefolder) == "function" then pcall(makefolder, folder) end
        local autoPath = path .. "_autoload.txt"
        return pcall(writefile, autoPath, (autoLoadConfig and "1" or "0") .. "\n" .. (autoLoadConfig and sanitizeName(autoLoadName) or "default"))
    end

    local function loadAutoLoadSetting()
        autoLoadConfig = false
        autoLoadName = "default"
        if type(readfile) ~= "function" or type(isfile) ~= "function" then return end
        local path = type(configManager) == "table" and type(configManager.Path) == "string" and configManager.Path or "WindUI/ServaHub/config/"
        if not path:match("[/\\]$") then path = path .. "/" end
        local autoPath = path .. "_autoload.txt"
        if not isfile(autoPath) then return end
        local ok, txt = pcall(readfile, autoPath)
        if not ok or type(txt) ~= "string" then return end
        local on, name = txt:match("^%s*([01])%s*\r?\n%s*(.-)%s*$")
        if on and name then
            local cleanName = sanitizeName(name)
            if on == "1" and cleanName ~= "None" and cleanName ~= "Disabled" then
                autoLoadConfig = true
                autoLoadName = cleanName
            end
        end
    end

    local function syncAutoLoadDropdown()
        local list = {"None"}
        for _, v in ipairs(getConfigList()) do table.insert(list, v) end
        local currentVal = "None"
        if autoLoadConfig and table.find(list, sanitizeName(autoLoadName)) then currentVal = sanitizeName(autoLoadName)
        elseif autoLoadConfig then autoLoadConfig = false autoLoadName = "default" saveAutoLoadFile() end
        if autoLoadDropdown then
            pcall(function() autoLoadDropdown:Refresh(list) end)
            pcall(function() autoLoadDropdown:Select(currentVal) end)
        end
    end

    local function syncConfigDropdown(selectName)
        local list = getConfigList()
        local target = selectName or selectedConfig
        target = target and sanitizeName(target) or nil
        local isValid = false
        for _, v in ipairs(list) do if v == target then isValid = true break end end
        selectedConfig = isValid and target or list[1]
        if selectedConfigDropdown then
            pcall(function() selectedConfigDropdown:Refresh(list) end)
            pcall(function() selectedConfigDropdown:Select(selectedConfig) end)
        end
    end

    local function getOrCreateConfig(name)
        if not configManager or type(configManager.CreateConfig) ~= "function" then return nil end
        local ok, res = pcall(function() return configManager:CreateConfig(sanitizeName(name)) end)
        return ok and res or nil
    end

    local function saveConfigToDisk(configObj)
        if not configObj then return false, "Config manager is unavailable" end
        local ok, res = pcall(function() return configObj:Save() end)
        if ok and res ~= false then return true end
        if type(writefile) ~= "function" or type(configObj.Path) ~= "string" or type(configManager) ~= "table" or type(configManager.Parser) ~= "table" then
            return false, tostring(res)
        end
        if type(Window.PendingFlags) == "table" and type(configObj.Register) == "function" then
            for k, pendingFlag in pairs(Window.PendingFlags) do pcall(function() configObj:Register(k, pendingFlag) end) end
        end
        local data = { __version = tonumber(configObj.Version) or 1.2, __elements = {}, __autoload = configObj.AutoLoad == true, __custom = type(configObj.CustomData) == "table" and configObj.CustomData or {} }
        for k, element in pairs(configObj.Elements or {}) do
            local parser = type(element) == "table" and configManager.Parser[element.__type] or nil
            if parser and type(parser.Save) == "function" then
                local saveOk, saveRes = pcall(parser.Save, element)
                if saveOk and pcall(HttpService.JSONEncode, HttpService, saveRes) then data.__elements[tostring(k)] = saveRes end
            end
        end
        local encodeOk, encoded = pcall(HttpService.JSONEncode, HttpService, data)
        if not encodeOk then return false, tostring(encoded) end
        local writeOk, writeRes = pcall(writefile, configObj.Path, encoded)
        return writeOk, writeOk and nil or tostring(writeRes)
    end

    local function applyCustomData(configObj)
        if type(configObj) == "table" and type(configObj.CustomData) == "table" then end
    end

    loadAutoLoadSetting()

    configSection:Input({ Title = "Config Name", Value = "default", Placeholder = "default", Callback = function(text) configName = sanitizeName(text) end })

    selectedConfigDropdown = configSection:Dropdown({ Title = "Selected Config", Values = getConfigList(), Value = nil, AllowNone = true, Callback = function(opt) selectedConfig = opt and sanitizeName(opt) or nil end })

    local function refreshAutoLoadUI()
        local list = {"None"}
        for _, v in ipairs(getConfigList()) do table.insert(list, v) end
        local currentVal = autoLoadConfig and sanitizeName(autoLoadName) or "None"
        autoLoadDropdown = configSection:Dropdown({
            Title = "Auto Load Config", Values = list, Value = currentVal, AllowNone = false,
            Callback = function(opt)
                if type(opt) == "table" then opt = opt[1] or next(opt) end
                local s = tostring(opt or "None")
                if s == "None" or s == "Disabled" then autoLoadConfig = false autoLoadName = "default"
                else autoLoadConfig = true autoLoadName = sanitizeName(s) end
                if not saveAutoLoadFile() and autoLoadConfig then autoLoadConfig = false autoLoadName = "default" WindUI:Notify({ Title = "Config Error", Content = "Executor file storage is unavailable", Icon = "x", Duration = 2 }) end
            end
        })
    end

    refreshAutoLoadUI()

    configSection:Button({
        Title = "Save Config", Icon = "save",
        Callback = function()
            local cleanName = sanitizeName(configName)
            local configObj = getOrCreateConfig(cleanName)
            if type(configObj) == "table" then configObj.CustomData = configObj.CustomData or {} end
            local ok, err = saveConfigToDisk(configObj)
            if ok then
                selectedConfig = cleanName
                syncConfigDropdown(cleanName)
                syncAutoLoadDropdown()
                WindUI:Notify({ Title = "Config Saved", Content = cleanName, Icon = "check", Duration = 2 })
            else
                WindUI:Notify({ Title = "Config Error", Content = "Could not save: " .. tostring(err), Icon = "x", Duration = 3 })
            end
        end
    })

    configSection:Button({
        Title = "Load Selected Config", Icon = "upload",
        Callback = function()
            if not selectedConfig then WindUI:Notify({ Title = "Config Error", Content = "No config selected", Icon = "x", Duration = 2 }) return end
            local cleanName = sanitizeName(selectedConfig)
            local configObj = getOrCreateConfig(cleanName)
            local success, result = false, nil
            if configObj then success, result = pcall(function() return configObj:Load() end) end
            if success and result ~= false then applyCustomData(configObj) WindUI:Notify({ Title = "Config Loaded", Content = cleanName, Icon = "check", Duration = 2 })
            else WindUI:Notify({ Title = "Config Error", Content = "Could not load config", Icon = "x", Duration = 2 }) end
        end
    })

    configSection:Button({
        Title = "Delete Selected Config", Icon = "trash-2",
        Callback = function()
            if not selectedConfig then WindUI:Notify({ Title = "Config Error", Content = "No config selected", Icon = "x", Duration = 2 }) return end
            local cleanName = sanitizeName(selectedConfig)
            local configObj = getOrCreateConfig(cleanName)
            local isAutoLoad = autoLoadConfig and sanitizeName(autoLoadName) == cleanName
            local success, result = false, nil
            if configObj then success, result = pcall(function() return configObj:Delete() end) end
            if success and result == true then
                selectedConfig = nil
                syncConfigDropdown(nil)
                if isAutoLoad then autoLoadConfig = false autoLoadName = "default" end
                syncAutoLoadDropdown()
                WindUI:Notify({ Title = "Config Deleted", Content = cleanName, Icon = "trash-2", Duration = 2 })
            else WindUI:Notify({ Title = "Config Error", Content = "Could not delete config", Icon = "x", Duration = 2 }) end
        end
    })

    configSection:Button({
        Title = "Refresh Config List", Icon = "refresh-cw",
        Callback = function() syncConfigDropdown(selectedConfig) syncAutoLoadDropdown() end
    })

    local function applyAutoLoadConfig()
        if not autoLoadConfig then return false end
        local cleanName = sanitizeName(autoLoadName)
        if cleanName == "None" or cleanName == "Disabled" then autoLoadConfig = false autoLoadName = "default" saveAutoLoadFile() syncAutoLoadDropdown() return false end
        local configObj = getOrCreateConfig(cleanName)
        local success, result = false, nil
        if configObj then success, result = pcall(function() return configObj:Load() end) end
        if success and result ~= false then
            applyCustomData(configObj)
            selectedConfig = cleanName
            syncConfigDropdown(cleanName)
            syncAutoLoadDropdown()
            WindUI:Notify({ Title = "Config Auto Loaded", Content = cleanName, Icon = "check", Duration = 2 })
            return true
        end
        autoLoadConfig = false autoLoadName = "default" saveAutoLoadFile() syncAutoLoadDropdown()
        WindUI:Notify({ Title = "Config Error", Content = "Auto-load config not found: " .. cleanName, Icon = "x", Duration = 2 })
        return false
    end

    task.spawn(function()
        RunService.Heartbeat:Wait()
        applyAutoLoadConfig()
    end)

    local Camera = WS.CurrentCamera
    getgenv().Resolution = getgenv().Resolution or {}

    if not Settings.ScreenStretch then getgenv().Resolution[".gg/scripters"] = 1.0
    else getgenv().Resolution[".gg/scripters"] = 0.65 end

    if getgenv().gg_scripters == nil then
        getgenv().gg_scripters = true
        RunService.RenderStepped:Connect(function()
            if Camera and Camera.Parent then
                local current = getgenv().Resolution[".gg/scripters"] or 1.0
                Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, current, 0, 0, 0, 1)
            end
        end)
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

    Hub.unload = function()
        Hub.unloaded = true
        pcall(Hub.Port.unload)
        pcall(xrayRestore)
        pcall(stopWallHop)
        pcall(stopInvisibility)
        pcall(stopFly)
        pcall(function() RunService:UnbindFromRenderStep("ServaFakePos") end)
        pcall(function()
            if aaState.applied and aaState.real then
                local root = getRoot()
                if root and root.Parent then root.CFrame = aaState.real end
                aaState.applied = false
            end
        end)
        pcall(function()
            if murder.marker then murder.marker:Destroy() murder.marker = nil end
        end)
        pcall(function()
            if grav.applied then WS.Gravity = grav.baseGravity end
        end)
        pcall(function()
            local hum = getHum()
            if hum and hip.humanoid == hum and hip.base then
                hum.HipHeight = hip.base
            end
        end)
        pcall(function()
            if noclipCamState.on then
                if noclipCamState.mode == "invisicam" and camPreviousMode ~= nil then
                    LP.DevCameraOcclusionMode = camPreviousMode
                end
                noclipCamState.on = false
                noclipCamState.mode = nil
            end
        end)
        for _, c in ipairs(Hub.conns) do pcall(function() c:Disconnect() end) end
        table.clear(Hub.conns)
    end

    
    local antiCoinState = {
        coins = {},
        characterParts = {},
        strict = false,
    }
    local function antiCoinBlockCoin(part)
        if not part:IsA("BasePart") then return end
        if antiCoinState.coins[part] == nil then antiCoinState.coins[part] = part.CanTouch end
        if part.CanTouch then
            part.CanTouch = false
        end
    end
    local function antiCoinScan()
        for _, map in ipairs(WS:GetChildren()) do
            local container = map:FindFirstChild("CoinContainer")
            if container then
                for _, part in ipairs(container:GetChildren()) do
                    pcall(antiCoinBlockCoin, part)
                end
            end
        end
    end
    local function antiCoinBlockCharacter()
        local character = LP.Character
        if not character then return end
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                if antiCoinState.characterParts[part] == nil then antiCoinState.characterParts[part] = part.CanTouch end
                if part.CanTouch then pcall(function() part.CanTouch = false end) end
            end
        end
    end

    bind(WS.DescendantAdded:Connect(function(part)
        if PlayerState.AntiCoinEnabled and part.Parent and part.Parent.Name == "CoinContainer" then
            pcall(antiCoinBlockCoin, part)
        end
    end))
    bind(LP.CharacterAdded:Connect(function()
        if PlayerState.AntiCoinEnabled and antiCoinState.strict then
            task.wait(0.5)
            pcall(antiCoinBlockCharacter)
        end
    end))
    task.spawn(function()
        while not Hub.unloaded do
            task.wait(0.5)
            if PlayerState.AntiCoinEnabled then
                pcall(antiCoinScan)
                if antiCoinState.strict then pcall(antiCoinBlockCharacter) end
            end
        end
    end)
    task.spawn(function()
        local gameplay
        while not Hub.unloaded and not gameplay do
            local remotes = RS:FindFirstChild("Remotes")
            gameplay = remotes and remotes:FindFirstChild("Gameplay")
            if not gameplay then task.wait(1) end
        end
        local collected = gameplay and gameplay:FindFirstChild("CoinCollected")
        if not collected then return end
        bind(collected.OnClientEvent:Connect(function()
            if not PlayerState.AntiCoinEnabled then return end
            antiCoinState.strict = true
            pcall(antiCoinBlockCharacter)
            pcall(function()
                WindUI:Notify({ Title = "Anti Coin", Content = "Coin leaked, strict mode on", Icon = "x", Duration = 3 })
            end)
        end))
    end)

    bind(Players.PlayerAdded:Connect(function() task.wait(0.5) pcall(Hub.Port.refreshPlayerDrops) end))
    bind(Players.PlayerRemoving:Connect(function() task.wait(0.5) pcall(Hub.Port.refreshPlayerDrops) end))
    task.defer(function() pcall(Hub.Port.refreshPlayerDrops) end)

    startBombJump()

end

LoadServaHub()
