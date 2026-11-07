local function LoadServaHub()
    
    local CorrectKey = "ScepTsk_Off"
    local KeyFile = "ServaHub_Key.json"
    
    local function IsKeySaved()
        if isfile and readfile and isfile(KeyFile) then
            local success, content = pcall(readfile, KeyFile)
            if success and content then
                local decoded = game:GetService("HttpService"):JSONDecode(content)
                if decoded and decoded.key == CorrectKey then return true end
            end
        end
        return false
    end

    local function SaveKey()
        if writefile then
            local data = game:GetService("HttpService"):JSONEncode({key = CorrectKey})
            pcall(writefile, KeyFile, data)
        end
    end

    if not IsKeySaved() then
        local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
        
        WindUI:AddTheme({
            Name = "Serva Hub", Accent = Color3.fromHex("#9B5CFF"), Background = Color3.fromHex("#07040F"),
            Outline = Color3.fromHex("#7A3CFF"), Text = Color3.fromHex("#F2E9FF"), Placeholder = Color3.fromHex("#8F7AB8"),
            Button = Color3.fromHex("#7A3CFF"), Icon = Color3.fromHex("#C9A6FF"),
        })

        local KeyWindow = WindUI:CreateWindow({
            Title = "Serva Hub • Key System", Icon = "rbxassetid://112491954653394", IconSize = 35,
            Author = "Verification", Background = "rbxassetid://116737345570479", Transparent = true,
            User = { Enabled = false, Anonymous = false },
        })

        pcall(function() KeyWindow:SetBackgroundImageTransparency(0) end)
        pcall(function()
            KeyWindow:EditOpenButton({
                Title = "Serva Hub • Key System", Icon = "rbxassetid://112491954653394",
                CornerRadius = UDim.new(0, 16), StrokeThickness = 2,
                Color = ColorSequence.new(Color3.fromHex("#B57BFF"), Color3.fromHex("#5B2BFF")), Enabled = true, Draggable = true,
            })
        end)

        local KeyTab = KeyWindow:Tab({ Title = "Key", Icon = "key" })
        local KeySection = KeyTab:Section({ Title = "Enter Key", Icon = "lock" })

        local InputKey = ""
        KeySection:Input({ Title = "Key", Placeholder = "Enter your key here...", Callback = function(text) InputKey = text end })
        
        KeySection:Button({ Title = "Get Key", Icon = "external-link", Callback = function()
            if setclipboard then 
                setclipboard("https://t.me/ServaHub") 
                WindUI:Notify({ Title = "Key System", Content = "Link copied: https://t.me/ServaHub", Icon = "check", Duration = 3 }) 
            end
        end })
        
        KeySection:Button({ Title = "Submit Key", Icon = "check", Callback = function()
            if InputKey == CorrectKey then
                SaveKey() 
                KeyWindow:Destroy() 
                task.wait(0.5)
                getgenv().ServaHubKeyVerified = true 
                LoadServaHub()
            else
                WindUI:Notify({ Title = "Error", Content = "Invalid Key!", Icon = "x", Duration = 3 })
            end
        end })
        return
    end

    local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    local RunService = game:GetService("RunService")
    local P = game:GetService("Players")
    local LP = P.LocalPlayer
    local WS = workspace
    local UIS = game:GetService("UserInputService")
    local VirtualUser = game:GetService("VirtualUser")
    local Stats = game:GetService("Stats")
    local RS = game:GetService("ReplicatedStorage")
    local Lighting = game:GetService("Lighting")

    WindUI:AddTheme({
        Name = "Serva Hub", Accent = Color3.fromHex("#9B5CFF"), Background = Color3.fromHex("#07040F"),
        Outline = Color3.fromHex("#7A3CFF"), Text = Color3.fromHex("#F2E9FF"), Placeholder = Color3.fromHex("#8F7AB8"),
        Button = Color3.fromHex("#7A3CFF"), Icon = Color3.fromHex("#C9A6FF"),
    })

    local function gradient(text, startColor, endColor)
        local result = ""
        local length = #text
        for i = 1, length do
            local t = (i - 1) / math.max(length - 1, 1)
            local r = math.floor(startColor.R * 255 + (endColor.R * 255 - startColor.R * 255) * t)
            local g = math.floor(startColor.G * 255 + (endColor.G * 255 - startColor.G * 255) * t)
            local b = math.floor(startColor.B * 255 + (endColor.B * 255 - startColor.B * 255) * t)
            local char = text:sub(i, i)
            result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, char)
        end
        return result
    end

    local windowTitle = gradient("Serva Hub", Color3.fromRGB(201, 166, 255), Color3.fromRGB(122, 60, 255)) .. ' <font color="rgb(155,92,255)">•</font> <font color="rgb(181,123,255)">v1.1</font>'

    local Window = WindUI:CreateWindow({
        Title = windowTitle, Icon = "rbxassetid://112491954653394", IconSize = 35,
        Author = '<font color="rgb(143,122,184)">Kukirin Life</font>', Background = "rbxassetid://116737345570479",
        Transparent = true, User = { Enabled = true, Anonymous = false },
    })

    WindUI:SetTheme("Serva Hub")
    pcall(function() Window:SetBackgroundImageTransparency(0) end)
    pcall(function()
        Window:EditOpenButton({
            Title = "Serva Hub", Icon = "rbxassetid://112491954653394", CornerRadius = UDim.new(0, 16), StrokeThickness = 2,
            Color = ColorSequence.new(Color3.fromHex("#B57BFF"), Color3.fromHex("#5B2BFF")), Enabled = true, Draggable = true,
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
        AutoQuests = false, AutoAchievements = false, AutoDaily = false, AutoDelivery = false,
        AutoBuyRide = false, AutoBuySticker = false, AutoBuyCharm = false, AutoBuyBasic = false,
        MoneyRain = false, AutoWheelie = false, AutoBackflip = false, AntiCrash = false,
        QuestHelpers = true, WheelieAngle = 35, BalanceAngle = 60, SpeedMultiplier = 1, AccelMultiplier = 1,
        RideSpeedBoost = 0, AntiPolice = false,
        PlayerESP = false, RideESP = false, PoliceESP = false, CustomerESP = false,
        ESPNames = false, ESPDistance = false, ESPMaxDistance = 0, 
        ESPPlayerColor = Color3.fromRGB(40, 255, 40),
        ESPRideColor = Color3.fromRGB(160, 255, 160),
        Fullbright = false, WalkSpeed = Defaults.WalkSpeed, JumpPower = Defaults.JumpPower, HipHeight = Defaults.HipHeight,
        InfJump = false, Noclip = false, Fly = false, FlySpeed = 60, FOV = Defaults.FOV,
        UITransparency = 0, AntiAFK = true, HidePlayers = false, FPSCap = 60, AntiLag = false,
        QuickInteract = false, ScreenStretch = 0,
        FlipCount = 6
    }

    local touched, appliers = {}, {}
    local TOUCH_KEYS = { WalkSpeed = true, JumpPower = true, HipHeight = true, FOV = true, FPSCap = true }
    
    local function setSetting(key, value)
        Settings[key] = value
        if TOUCH_KEYS[key] then touched[key] = true end
        local apply = appliers[key]
        if apply then pcall(apply, value) end
    end

    local Remotes = RS:FindFirstChild("Remotes")
    local function remote(name)
        if not Remotes then return nil end
        for _, r in ipairs(Remotes:GetDescendants()) do
            if r.Name == name and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then return r end
        end
    end
    
    local GetQuests, ClaimQuest = remote("GetQuests"), remote("ClaimQuest")
    local ClaimAchievement, ClaimAchievementReward = remote("ClaimAchievement"), remote("ClaimAchievementReward")
    local GetDailyRewards, ClaimDailyReward = remote("GetDailyRewards"), remote("ClaimDailyReward")
    local GetRides, BuyRide = remote("GetRides"), remote("BuyRide")
    local RiderArmEvent, PoliceMode = remote("RiderArmEvent"), remote("PoliceMode")
    local SpawnRide = Remotes and Remotes.Rides and Remotes.Rides:FindFirstChild("SpawnRide")
    local FoodDelivery = Remotes and Remotes:FindFirstChild("FoodDelivery")
    local RainFolder = Remotes and Remotes:FindFirstChild("MoneyRain")
    local OpenCase = Remotes and Remotes.Cases and Remotes.Cases:FindFirstChild("OpenCase")

    local function data(name)
        if not RS:FindFirstChild("Datas") or not RS.Datas:FindFirstChild(name) then return nil end
        local ok, mod = pcall(function() return require(RS.Datas[name]) end)
        return ok and type(mod) == "table" and mod or nil
    end
    local AchievementConfig, RideSpecs = data("AchievementConfig"), data("RideSpecs")

    local function myRide() local r = WS:FindFirstChild("Rides") return r and r:FindFirstChild("Ride_" .. LP.Name) end
    local function myDriveSeat() local r = myRide() return r and r:FindFirstChild("DriveSeat", true) end
    local function seated(seat) local h = getHum() return h and seat and h.SeatPart == seat end

    local function streamAround(pos)
        local done = false
        task.spawn(function() pcall(function() LP:RequestStreamAroundAsync(pos, 5) end) done = true end)
        local started = os.clock()
        while not done and os.clock() - started < 3 do task.wait(0.1) end
    end

    local groundParams = RaycastParams.new()
    groundParams.FilterType = Enum.RaycastFilterType.Exclude
    local function groundBelow(pos, depth)
        local rides = WS:FindFirstChild("Rides")
        local pois = WS:FindFirstChild("POIs")
        groundParams.FilterDescendantsInstances = { rides, LP.Character, pois }
        return WS:Raycast(pos, Vector3.new(0, -(depth or 12), 0), groundParams)
    end

    local function seatHeight(seat)
        local g = groundBelow(seat.Position, 20)
        return g and seat.Position.Y - g.Position.Y or 3
    end

    local function placeRide(seatPos)
        local ride, seat = myRide(), myDriveSeat()
        if not (ride and seat) then return end
        local look = seat.CFrame.LookVector
        local target = CFrame.new(seatPos) * CFrame.Angles(0, math.atan2(-look.X, -look.Z), 0)
        ride:PivotTo(target * (seat.CFrame:Inverse() * ride:GetPivot()))
        for _, d in ipairs(ride:GetDescendants()) do
            if d:IsA("BasePart") then
                d.AssemblyLinearVelocity = Vector3.zero
                d.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end

    local function teleport(pos)
        streamAround(pos)
        local ground = groundBelow(pos + Vector3.new(0, 40, 0), 200)
        if ground then pos = ground.Position end
        local seat = myDriveSeat()
        if seat and seated(seat) then
            placeRide(pos + Vector3.new(0, seatHeight(seat), 0))
            return
        end
        local root = getRoot()
        if not root then return end
        root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    local Session = { startedAt = os.clock(), startCash = tonumber(LP:GetAttribute("Cash")) or 0, quests = 0, achievements = 0, daily = 0, deliveries = 0, deliveryCash = 0, ridesBought = 0, backflips = 0, flipCash = 0, cratesOpened = 0 }
    
    local FARM_SPOT = Vector3.new(1100, 56.4, -1500)
    local farmAnchor, farmRadius = FARM_SPOT, 260

    local function chassis()
        local aci = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("A-Chassis Interface")
        local values = aci and aci:FindFirstChild("Values")
        local drive = aci and aci:FindFirstChild("Drive")
        local input = drive and drive:FindFirstChild("VirtualInput")
        if values and input then return values, input end
    end

    local sent, sentTo = {}, nil
    local function pad(input, keyCode, value)
        if sentTo ~= input then sent, sentTo = {}, input end
        value = math.floor(value * 50 + 0.5) / 50
        if sent[keyCode] == value then return end
        sent[keyCode] = value
        
        local position = Vector3.new(0, 0, value)
        if keyCode == Enum.KeyCode.Thumbstick1 then
            position = Vector3.new(value, 0, 0)
        end

        input:Fire({
            KeyCode = keyCode, 
            UserInputType = Enum.UserInputType.Gamepad1, 
            UserInputState = Enum.UserInputState.Change,
            Position = position,
        })
    end

    local function releaseRide()
        local values, input = chassis()
        if not values then return end
        pad(input, Enum.KeyCode.ButtonR2, 0)
        pad(input, Enum.KeyCode.ButtonL2, 0)
        pad(input, Enum.KeyCode.Thumbstick1, 0)
        pcall(function() if values.Wheelie then values.Wheelie.Value = false end end)
    end

    local bfPhase, bfPhaseAt = "idle", 0
    local bfDebug = "Idle"
    local function setBfPhase(p) bfPhase, bfPhaseAt = p, os.clock() end
    local function phaseTime() return os.clock() - bfPhaseAt end

    local bestScooter = nil
    local flipAccum, flipCashBefore = 0, 0
    local sitTries, recoverCount, noGainCycles = 0, 0, 0
    local forceRespawn = false
    local fly = nil

    local FLIP_GRAVITY   = 60
    local FLIP_VY        = 65
    local FLIP_SPIN_CAP  = 24
    local SPIN_START     = 0.12
    local SPIN_END       = 0.85
    local FLIP_OVERSHOOT = 0.45

    local function getBestOwnedScooter()
        if not GetRides then return "ScooterG2" end
        local ok, rides = pcall(function() return GetRides:InvokeServer() end)
        if ok and type(rides) == "table" then
            local bestName, bestPrice = nil, -1
            for _, r in ipairs(rides) do
                if r.Owned and not r.RobuxOnly and r.Price > bestPrice then
                    bestPrice, bestName = r.Price, r.Name
                end
            end
            return bestName or "ScooterG2"
        end
        return "ScooterG2"
    end

    local function flipTurns()
        return math.clamp(math.floor((Settings.FlipCount or 6) + 0.5), 1, 6)
    end
    local function flipTarget()
        return flipTurns() * 2 * math.pi + FLIP_OVERSHOOT
    end

    local function flatDistToFarm()
        local r = getRoot()
        if not r then return 0 end
        return (Vector3.new(r.Position.X, 0, r.Position.Z) - Vector3.new(farmAnchor.X, 0, farmAnchor.Z)).Magnitude
    end

    local function returnToFarm()
        streamAround(farmAnchor)
        local seat = myDriveSeat()
        if seat and seated(seat) then
            placeRide(farmAnchor + Vector3.new(0, seatHeight(seat), 0))
            return
        end
        local root = getRoot()
        if root then
            root.CFrame = CFrame.new(farmAnchor + Vector3.new(0, 4, 0))
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local function getUp()
        local hum, root = getHum(), getRoot()
        if not (hum and root) then return end
        hum.PlatformStand = false
        hum.Sit = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        local look = root.CFrame.LookVector
        local yaw = math.atan2(-look.X, -look.Z)
        root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0)) * CFrame.Angles(0, yaw, 0)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    local function uprightRide()
        local seat = myDriveSeat()
        if seat then placeRide(seat.Position + Vector3.new(0, 0.5, 0)) end
    end

    local function pullRideToPlayer()
        local ride, seat, root = myRide(), myDriveSeat(), getRoot()
        if not (ride and seat and root) then return end
        if (seat.Position - root.Position).Magnitude > 12 then
            local look = root.CFrame.LookVector
            local flat = Vector3.new(look.X, 0, look.Z)
            if flat.Magnitude < 0.1 then flat = Vector3.new(0, 0, -1) end
            local g = groundBelow(root.Position + Vector3.new(0, 3, 0), 15)
            local base = g and g.Position or (root.Position - Vector3.new(0, 3, 0))
            placeRide(base + flat.Unit * 4 + Vector3.new(0, seatHeight(seat), 0))
        end
    end

    local function respawnRide()
        bestScooter = bestScooter or getBestOwnedScooter()
        if not (SpawnRide and bestScooter) then return end
        local old = myRide()
        for _ = 1, 2 do
            pcall(function() SpawnRide:InvokeServer(bestScooter) end)
            local t0 = os.clock()
            while os.clock() - t0 < 3 do
                local r = myRide()
                if r and myDriveSeat() and (r ~= old or not old) then return end
                task.wait(0.1)
            end
            if myDriveSeat() then return end
        end
    end

    local function trySit(seat, hum)
        getUp()
        task.wait(0.2)
        seat = myDriveSeat() or seat
        if seat.CFrame.UpVector.Y < 0.7 then uprightRide() end
        pullRideToPlayer()
        seat = myDriveSeat() or seat
        local root = getRoot()
        if root then
            root.CFrame = seat.CFrame + Vector3.new(0, 1.5, 0)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        task.wait(0.25)
        pcall(function() seat:Sit(hum) end)
        for _ = 1, 10 do
            if seated(seat) then return true end
            task.wait(0.1)
        end
        return false
    end

    appliers.FlipCount = function()
        if bfPhase ~= "idle" then 
            fly = nil 
            setBfPhase("recover") 
        end
    end

    bind(RunService.Heartbeat:Connect(function()
        if bfPhase ~= "flip" or not fly or fly.done then return end
        local ride, seat = myRide(), myDriveSeat()
        if not (ride and seat and seated(seat)) then return end
        local root = seat.AssemblyRootPart or seat

        local t = os.clock() - fly.t0
        if t >= fly.T then
            ride:PivotTo(fly.pivot0)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            flipAccum = flipTurns() * 2 * math.pi
            fly.done = true
            return
        end

        local h = FLIP_VY * t - 0.5 * FLIP_GRAVITY * t * t
        if h < 0 then h = 0 end

        local spinEnd = fly.T * SPIN_END
        local k = math.clamp((t - SPIN_START) / (spinEnd - SPIN_START), 0, 1)
        local ang = fly.target * k
        if t > spinEnd then
            local back = math.clamp((t - spinEnd) / (fly.T - spinEnd), 0, 1)
            ang = fly.target - FLIP_OVERSHOOT * back
        end
        flipAccum = ang

        local rot = CFrame.fromAxisAngle(fly.axis, ang)
        ride:PivotTo(CFrame.new(fly.base + Vector3.new(0, h, 0)) * rot * CFrame.new(-fly.base) * fly.pivot0)

        root.AssemblyLinearVelocity = Vector3.new(0, FLIP_VY - FLIP_GRAVITY * t, 0)
        root.AssemblyAngularVelocity = fly.axis * (fly.omega * ((t >= SPIN_START and t <= spinEnd) and 1 or 0))
    end))

    task.spawn(function()
        while not Hub.unloaded do
            local active = Settings.AutoBackflip and not Settings.AutoWheelie and not Settings.AutoDelivery
            if active then
                local seat, hum = myDriveSeat(), getHum()
                if not hum then task.wait(1) continue end

                if bfPhase ~= "idle" and bfPhase ~= "recover" and phaseTime() > 10 then
                    fly = nil
                    setBfPhase("recover")
                    continue
                end

                if bfPhase == "idle" then
                    sitTries, recoverCount = 0, 0
                    setBfPhase("equip")

                elseif bfPhase == "equip" then
                    bfDebug = "equip"
                    if flatDistToFarm() > farmRadius then returnToFarm() task.wait(0.5) end
                    if forceRespawn or not myRide() then
                        forceRespawn = false
                        respawnRide()
                    end
                    sitTries = 0
                    setBfPhase("sit")

                elseif bfPhase == "sit" then
                    bfDebug = "sit"
                    local s = myDriveSeat()
                    if s then
                        if trySit(s, hum) then
                            sitTries = 0
                            setBfPhase("prep")
                        else
                            sitTries += 1
                            if sitTries >= 3 then
                                forceRespawn = true
                                setBfPhase("equip")
                            end
                        end
                    else
                        sitTries += 1
                        if sitTries >= 3 then forceRespawn = true setBfPhase("equip") end
                        task.wait(0.5)
                    end

                elseif bfPhase == "recover" then
                    bfDebug = "recover"
                    releaseRide()
                    recoverCount += 1
                    if recoverCount >= 3 or not myDriveSeat() then
                        recoverCount = 0
                        forceRespawn = true
                        setBfPhase("equip")
                    else
                        getUp()
                        if flatDistToFarm() > farmRadius then returnToFarm() else uprightRide() end
                        task.wait(0.3)
                        sitTries = 0
                        setBfPhase("sit")
                    end

                elseif bfPhase == "prep" then
                    if not seated(seat) then setBfPhase("recover") continue end
                    releaseRide()
                    bfDebug = "ready"
                    if flatDistToFarm() > farmRadius then
                        placeRide(farmAnchor + Vector3.new(0, seatHeight(seat), 0))
                    end
                    local pv = seat.AssemblyLinearVelocity
                    local still = Vector3.new(pv.X, 0, pv.Z).Magnitude < 3
                    if phaseTime() > 0.15 and (still or phaseTime() > 1.2) then
                        uprightRide()
                        task.wait(0.05)
                        setBfPhase("jump")
                    end

                elseif bfPhase == "jump" then
                    if not seated(seat) then setBfPhase("recover") continue end
                    local ride = myRide()
                    local target = flipTarget()
                    local T = 2 * FLIP_VY / FLIP_GRAVITY
                    local Tmin = (target / FLIP_SPIN_CAP + SPIN_START) / SPIN_END
                    if T < Tmin then T = Tmin end
                    local omega = target / (T * SPIN_END - SPIN_START)

                    fly = {
                        t0 = os.clock(), T = T, omega = omega, target = target,
                        pivot0 = ride:GetPivot(),
                        base = seat.Position,
                        axis = seat.CFrame.RightVector,
                        done = false,
                    }
                    flipAccum = 0
                    flipCashBefore = tonumber(LP:GetAttribute("Cash")) or 0
                    setBfPhase("flip")

                elseif bfPhase == "flip" then
                    if not seated(seat) then
                        fly = nil
                        setBfPhase("recover")
                        continue
                    end
                    bfDebug = string.format("flip %.1f/%d  t=%.1fs", flipAccum / (2 * math.pi), flipTurns(), phaseTime())
                    if fly and (fly.done or phaseTime() > fly.T + 1.5) then
                        if not fly.done then
                            local ride = myRide()
                            if ride then ride:PivotTo(fly.pivot0) end
                        end
                        fly = nil
                        uprightRide()
                        setBfPhase("settle")
                    elseif not fly then
                        setBfPhase("recover")
                    end

                elseif bfPhase == "settle" then
                    releaseRide()
                    bfDebug = "landing..."
                    if phaseTime() > 0.6 then
                        local cash = tonumber(LP:GetAttribute("Cash")) or 0
                        local gain = cash - flipCashBefore
                        recoverCount = 0
                        if gain > 0 then
                            noGainCycles = 0
                            Session.flipCash += gain
                            Session.backflips += math.max(1, math.floor(flipAccum / (2 * math.pi) + 0.15))
                        else
                            noGainCycles += 1
                        end
                        if noGainCycles >= 4 then
                            noGainCycles = 0
                            forceRespawn = true
                            setBfPhase("equip")
                        elseif seated(seat) then
                            setBfPhase("prep")
                        else
                            setBfPhase("recover")
                        end
                    end
                end
            elseif bfPhase ~= "idle" then
                fly = nil
                setBfPhase("idle")
                bfDebug = "Idle"
                releaseRide()
            end
            task.wait(0.03)
        end
    end)

    local wPhase, wPhaseAt = "idle", 0
    local function setWPhase(p) wPhase, wPhaseAt = p, os.clock() end

    local oneHandByHelper, policeBefore, armToggledAt = false, nil, 0

    local function setOneHand(on)
        local seat = myDriveSeat()
        if not (seat and RiderArmEvent) or os.clock() - armToggledAt < 1.5 then return end
        if (seat:GetAttribute("OneHanderActive") == true) ~= on then
            armToggledAt = os.clock()
            pcall(function() RiderArmEvent:FireServer() end)
        end
    end

    local questsData = {}
    local function questNeeds(id)
        for _, q in ipairs(questsData) do
            if q.Id == id and (q.NextAt or 0) <= os.time() and (q.Progress or 0) < (q.Target or 0) then return true end
        end
        return false
    end

    local function questHelpers()
        local wheelieing = Settings.AutoWheelie and wPhase == "wheelie"
        if Settings.QuestHelpers and wheelieing and questNeeds("OneHandWheelie") then
            oneHandByHelper = true
            setOneHand(true)
        elseif oneHandByHelper then
            local seat = myDriveSeat()
            if seat and seat:GetAttribute("OneHanderActive") == true then setOneHand(false) else oneHandByHelper = false end
        end
        if not PoliceMode then return end
        local mode = LP:GetAttribute("PoliceMode") or "None"
        if Settings.QuestHelpers and wheelieing and questNeeds("HardPoliceTime") then
            if policeBefore == nil then policeBefore = mode end
            if mode ~= "Hard" then pcall(function() PoliceMode:FireServer("Hard") end) end
            return
        end
        local want = Settings.AntiPolice and "None" or policeBefore
        policeBefore = nil
        if want and mode ~= want then pcall(function() PoliceMode:FireServer(want) end) end
    end

    local stuckSince, lastCheckPos, lastWheelieTime
    local function isStuck(seat)
        local wt = tonumber(LP:GetAttribute("WheelieTime")) or 0
        local still = lastCheckPos and (seat.Position - lastCheckPos).Magnitude < 0.5
        local earning = lastWheelieTime and wt > lastWheelieTime
        lastCheckPos, lastWheelieTime = seat.Position, wt
        if still and not earning then
            stuckSince = stuckSince or os.clock()
            return os.clock() - stuckSince > 8
        end
        stuckSince = nil
        return false
    end

    task.spawn(function()
        while not Hub.unloaded do
            local seat, hum = myDriveSeat(), getHum()
            local farming = Settings.AutoWheelie and not Settings.AutoDelivery and not Settings.AutoBackflip
            
            if farming and hum then
                if not seat then
                    if wPhase ~= "spawning" then
                        setWPhase("spawning")
                        respawnRide()
                        task.wait(1)
                    end
                elseif hum.SeatPart ~= seat then
                    setWPhase("idle")
                    local root = getRoot()
                    if root then root.CFrame = seat.CFrame + Vector3.new(0, 1.5, 0) end
                    task.wait(0.4)
                    pcall(function() seat:Sit(hum) end)
                elseif wPhase == "idle" or wPhase == "spawning" then
                    streamAround(farmAnchor)
                    placeRide(farmAnchor + Vector3.new(0, seatHeight(seat), 0))
                    setWPhase("place")
                elseif wPhase ~= "place" and isStuck(seat) then
                    stuckSince = nil
                    setWPhase("idle")
                end
            elseif wPhase ~= "idle" then
                setWPhase("idle")
                releaseRide()
            end
            questHelpers()
            task.wait(0.3)
        end
    end)

    local lastPitch, pitchRate = 0, 0
    bind(RunService.Heartbeat:Connect(function(dt)
        if wPhase == "idle" or wPhase == "spawning" then return end
        local seat = myDriveSeat()
        local values, input = chassis()
        if not (seat and seated(seat) and values) then return end
        local t = os.clock() - wPhaseAt
        if wPhase == "place" then
            pad(input, Enum.KeyCode.ButtonR2, 0)
            if t > 1 then setWPhase("launch") end
            return
        end
        pad(input, Enum.KeyCode.Thumbstick1, 0.25)
        if wPhase == "launch" then
            pcall(function() values.Wheelie.Value = false end)
            pad(input, Enum.KeyCode.ButtonR2, 0.7)
            pad(input, Enum.KeyCode.ButtonL2, 0)
            if t > 1.5 then 
                lastPitch, pitchRate = 0, 0 
                setWPhase("wheelie") 
            end
            return
        end
        pcall(function() if not values.Wheelie.Value then values.Wheelie.Value = true end end)
        local g = groundBelow(seat.Position)
        local pitch = math.deg(math.asin(math.clamp(seat.CFrame.LookVector:Dot(g and g.Normal or Vector3.yAxis), -1, 1)))
        pitchRate = pitchRate * 0.7 + (pitch - lastPitch) / math.max(dt, 1 / 120) * 0.3
        lastPitch = pitch
        local u = math.clamp(0.45 + 0.04 * (Settings.BalanceAngle - pitch) - 0.012 * pitchRate, -1, 1)
        pad(input, Enum.KeyCode.ButtonR2, math.max(u, 0))
        pad(input, Enum.KeyCode.ButtonL2, math.max(-u, 0))
        local centre = Vector3.new(farmAnchor.X, 0, farmAnchor.Z)
        local pos = Vector3.new(seat.Position.X, 0, seat.Position.Z)
        local vel = seat.AssemblyLinearVelocity
        local flatVel = Vector3.new(vel.X, 0, vel.Z)
        if (pos - centre).Magnitude > farmRadius and flatVel.Magnitude > 5 and (pos - centre):Dot(flatVel) > 0 then
            local back = centre - flatVel.Unit * (farmRadius - 20)
            pcall(function() myRide():PivotTo(myRide():GetPivot() + (back - pos)) end)
        end
    end))

    bind(RunService.Heartbeat:Connect(function(dt)
        local seat = myDriveSeat()
        if not (seat and seated(seat)) then return end
        
        local values, input = chassis()
        if not (values and input) then return end
        
        local isAcceleratingKeyboard = UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.Up)
        
        local isAcceleratingMobile = false
        pcall(function()
            if values:FindFirstChild("Throttle") and values.Throttle.Value > 0.1 then
                isAcceleratingMobile = true
            end
            if input:GetAttribute("ButtonR2") == true then
                isAcceleratingMobile = true
            end
            if Settings.AutoWheelie or Settings.AutoBackflip then
                isAcceleratingMobile = true
            end
        end)
        
        local isAccelerating = isAcceleratingKeyboard or isAcceleratingMobile
        local isBraking = UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.Down)
        
        if isAccelerating and not isBraking then
            local root = seat.AssemblyRootPart or seat
            local currentVel = root.AssemblyLinearVelocity
            local flatVel = Vector3.new(currentVel.X, 0, currentVel.Z)
            local currentSpeed = flatVel.Magnitude
            
            if Settings.SpeedMultiplier > 1 then
                local accelForce = (Settings.AccelMultiplier * 15) * dt
                if currentSpeed > 0.5 then
                    root.AssemblyLinearVelocity += flatVel.Unit * accelForce
                end
            end
        end
        
        if Settings.RideSpeedBoost > 0 and isAccelerating and not isBraking then
            local seat2 = myDriveSeat()
            if seat2 and seated(seat2) then
                local look = seat2.CFrame.LookVector
                local flat = Vector3.new(look.X, 0, look.Z)
                if flat.Magnitude > 0.1 then
                    local root2 = seat2.AssemblyRootPart or seat2
                    root2.AssemblyLinearVelocity += flat.Unit * Settings.RideSpeedBoost * dt
                end
            end
        end
    end))

    task.spawn(function()
        while not Hub.unloaded do
            if Settings.AntiPolice and PoliceMode then
                local currentMode = LP:GetAttribute("PoliceMode")
                if currentMode and currentMode ~= "None" then
                    pcall(function() PoliceMode:FireServer("None") end)
                end
            end
            task.wait(1)
        end
    end)

    bind(RunService.Heartbeat:Connect(function()
        if not Settings.AntiCrash then return end
        local root = getRoot()
        local hum = getHum()
        if not (root and hum) then return end

        if root.Position.Y < -50 then
            root.CFrame = CFrame.new(farmAnchor + Vector3.new(0, 10, 0))
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end

        if root.AssemblyLinearVelocity.Magnitude > 500 then
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity.Unit * 100
        end
    end))

    local deliveryState = "idle"
    local deliveryStateAt = 0
    local deliveryStats = { done = 0, cash = 0, startedAt = os.clock() }
    local deliveryLastCash = tonumber(LP:GetAttribute("Cash")) or 0

    local function setDeliveryState(s)
        deliveryState, deliveryStateAt = s, os.clock()
    end
    local function deliveryTime()
        return os.clock() - deliveryStateAt
    end

    local function findDeliveryNPC()
        local npcs = WS:FindFirstChild("NPCs")
        if not npcs then return nil end
        local test = npcs:FindFirstChild("Test")
        if test then
            local prompt = test:FindFirstChild("FoodDeliveryPrompt", true)
            local hrp = test:FindFirstChild("HumanoidRootPart") or test:FindFirstChildWhichIsA("BasePart", true)
            return hrp, test, prompt
        end
        return nil
    end

    local function findDeliveryCustomer()
        local customer = WS:FindFirstChild("DeliveryCustomer")
        if customer then
            local prompt = customer:FindFirstChild("DeliverFoodPrompt", true)
            local hrp = customer:FindFirstChild("HumanoidRootPart") or customer:FindFirstChildWhichIsA("BasePart", true)
            if hrp then return hrp, customer, prompt end
        end
        
        local ok, doorPart = pcall(function()
            local buildings = WS:FindFirstChild("Buildings")
            if buildings then
                local doorModel = buildings:GetChildren()[25]
                if doorModel then
                    return doorModel:GetChildren()[8]
                end
            end
            return nil
        end)
        
        if ok and doorPart then
            local prompt = doorPart:FindFirstChild("DeliverFoodPrompt", true)
            local part = doorPart:FindFirstChild("HumanoidRootPart") or doorPart:FindFirstChildWhichIsA("BasePart", true)
            if part then return part, doorPart, prompt end
        end
        
        return nil
    end

    local function tpToPosition(pos)
        streamAround(pos)
        local seat = myDriveSeat()
        if seat and seated(seat) then
            placeRide(pos + Vector3.new(0, seatHeight(seat), 0))
            return
        end
        local root = getRoot()
        if root then
            root.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local function posOf(partOrModel)
        if not partOrModel then return nil end
        if partOrModel:IsA("BasePart") then return partOrModel.Position end
        if partOrModel:IsA("Model") then
            local p = partOrModel:FindFirstChild("HumanoidRootPart") or partOrModel:FindFirstChildWhichIsA("BasePart", true)
            return p and p.Position
        end
        return nil
    end

    local function clickYesButton()
        local function findYesButton(parent)
            if not parent then return nil end
            for _, guiName in ipairs({"MainUi", "MainGui"}) do
                local mainGui = parent:FindFirstChild(guiName)
                if mainGui then
                    local frame = mainGui:FindFirstChild("FoodDeliveryFrame")
                    local canvas = frame and frame:FindFirstChild("Frame") and frame.Frame:FindFirstChild("CanvasGroup")
                    local yesBtn = canvas and canvas:FindFirstChild("Yes")
                    if yesBtn then return yesBtn end
                end
            end
            return nil
        end

        local yesBtn = findYesButton(LP:FindFirstChild("PlayerGui"))
        if not yesBtn and gethui then
            local ok, hui = pcall(gethui)
            if ok then yesBtn = findYesButton(hui) end
        end
        if not yesBtn then yesBtn = findYesButton(game:GetService("CoreGui")) end

        if yesBtn then
            pcall(function() firesignal(yesBtn.Activated) end)
            pcall(function() firesignal(yesBtn.MouseButton1Click) end)
        end
    end

    task.spawn(function()
        while not Hub.unloaded do
            if not Settings.AutoDelivery then
                if deliveryState ~= "idle" then
                    setDeliveryState("idle")
                    releaseRide()
                end
                task.wait(0.5)
                continue
            end

            if Settings.AutoWheelie or Settings.AutoBackflip then
                task.wait(0.5)
                continue
            end

            local root = getRoot()
            local hum = getHum()
            if not (root and hum) then task.wait(0.5) continue end

            if deliveryState == "idle" then
                setDeliveryState("toNPC")

            elseif deliveryState == "toNPC" then
                local npcPart = findDeliveryNPC()
                if not npcPart then
                    setDeliveryState("toCustomer")
                    task.wait(0.3)
                    continue
                end
                local npcPos = posOf(npcPart)
                if npcPos and (root.Position - npcPos).Magnitude > 7 then
                    tpToPosition(npcPos + Vector3.new(0, 0, 2))
                    task.wait(0.4)
                else
                    setDeliveryState("takeOrder")
                end

            elseif deliveryState == "takeOrder" then
                local npcPart, npcModel, prompt = findDeliveryNPC()
                
                if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    pcall(function() fireproximityprompt(prompt) end)
                end

                task.wait(0.8)
                
                for i = 1, 3 do
                    clickYesButton()
                    task.wait(0.4)
                    if findDeliveryCustomer() then break end
                end
                
                task.wait(1)
                
                if findDeliveryCustomer() then
                    setDeliveryState("toCustomer")
                else
                    if deliveryTime() > 8 then setDeliveryState("toNPC") end
                end

            elseif deliveryState == "toCustomer" then
                local custPart = findDeliveryCustomer()
                if not custPart then
                    if deliveryTime() > 8 then setDeliveryState("giveOrder") end
                    task.wait(0.3)
                    continue
                end
                
                local custPos = posOf(custPart)
                if custPos and (root.Position - custPos).Magnitude > 7 then
                    tpToPosition(custPos + Vector3.new(0, 0, 2))
                    task.wait(0.4)
                else
                    setDeliveryState("giveOrder")
                end

            elseif deliveryState == "giveOrder" then
                if deliveryTime() < 2 then
                    task.wait(0.2)
                    continue
                end

                local custPart, custModel, prompt = findDeliveryCustomer()
                
                if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    pcall(function() fireproximityprompt(prompt) end)
                end

                task.wait(1.5)
                
                local cashNow = tonumber(LP:GetAttribute("Cash")) or 0
                if cashNow > deliveryLastCash then
                    deliveryStats.cash += cashNow - deliveryLastCash
                    deliveryLastCash = cashNow
                    deliveryStats.done += 1
                    Session.deliveries += 1
                    Session.deliveryCash += math.max(0, cashNow - deliveryLastCash)
                    setDeliveryState("wait")
                else
                    if deliveryTime() > 6 then
                        setDeliveryState("toCustomer")
                    end
                end

            elseif deliveryState == "wait" then
                if deliveryTime() > 2 then
                    setDeliveryState("toNPC")
                end
            end

            task.wait(0.25)
        end
    end)

    local ESP_Highlights = {}
    local ESP_Enabled = false

    local function applyHighlight(plr)
        if not ESP_Enabled or plr == LP then return end
        local char = plr.Character
        if not char then return end

        if ESP_Highlights[plr] and ESP_Highlights[plr].Parent then
            ESP_Highlights[plr]:Destroy()
        end

        local hl = Instance.new("Highlight")
        hl.Name = "ServaHub_ESP"
        hl.Adornee = char
        hl.Parent = char
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0

        local role = plr:GetAttribute("TeamID") or (plr.Team and plr.Team.Name) or "Survivor"
        if role == "Killer" then
            hl.FillColor = Color3.fromRGB(255, 40, 40)
            hl.OutlineColor = Color3.fromRGB(255, 40, 40)
        elseif plr:GetAttribute("Downed") == true then
            hl.FillColor = Color3.fromRGB(255, 255, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 0)
        else
            hl.FillColor = Color3.fromRGB(40, 255, 40)
            hl.OutlineColor = Color3.fromRGB(40, 255, 40)
        end

        ESP_Highlights[plr] = hl

        plr.CharacterAdded:Connect(function(newChar)
            task.wait(0.5)
            if ESP_Enabled then applyHighlight(plr) end
        end)
    end

    local function setPlayerESP(state)
        ESP_Enabled = state
        if state then
            for _, v in ipairs(P:GetPlayers()) do
                if v ~= LP then
                    task.spawn(function()
                        local Character = v.Character or v.CharacterAdded:Wait()
                        applyHighlight(v)
                    end)
                end
            end
        else
            for plr, hl in pairs(ESP_Highlights) do
                if hl and hl.Parent then hl:Destroy() end
                ESP_Highlights[plr] = nil
            end
        end
    end

    P.PlayerAdded:Connect(function(plr)
        if ESP_Enabled then
            plr.CharacterAdded:Connect(function()
                task.wait(0.5)
                if ESP_Enabled then applyHighlight(plr) end
            end)
            if plr.Character then applyHighlight(plr) end
        end
    end)

    P.PlayerRemoving:Connect(function(plr)
        if ESP_Highlights[plr] then
            if ESP_Highlights[plr].Parent then ESP_Highlights[plr]:Destroy() end
            ESP_Highlights[plr] = nil
        end
    end)

    local guiParent = game:GetService("CoreGui")
    if gethui then 
        local ok, hui = pcall(gethui) 
        if ok and typeof(hui) == "Instance" then guiParent = hui end 
    end

    local espFolder = Instance.new("Folder")
    espFolder.Name = "ServaHubESP"
    espFolder.Parent = guiParent
    local espTags = {}

    local function espTag(target, adornee)
        local tag = espTags[target]
        if not tag then
            local gui = Instance.new("BillboardGui", espFolder)
            gui.Adornee = adornee 
            gui.AlwaysOnTop = true 
            gui.Size = UDim2.fromOffset(200, 34) 
            gui.StudsOffset = Vector3.new(0, 3, 0)
            
            local label = Instance.new("TextLabel", gui)
            label.Size = UDim2.fromScale(1, 1) 
            label.BackgroundTransparency = 1 
            label.Font = Enum.Font.GothamBold 
            label.TextSize = 13 
            label.TextStrokeTransparency = 0.4
            
            local highlight = Instance.new("Highlight", espFolder)
            highlight.Adornee = target 
            highlight.FillTransparency = 0.75 
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            
            tag = { gui = gui, label = label, highlight = highlight }
            espTags[target] = tag
        end
        tag.seen = true
        return tag
    end

    local function clearEsp(keep)
        for target, tag in pairs(espTags) do
            if not (keep and tag.seen and target.Parent) then
                tag.gui:Destroy() 
                tag.highlight:Destroy() 
                espTags[target] = nil
            end
            tag.seen = false
        end
    end

    local function paintTag(tag, color, name, dist)
        local text = Settings.ESPNames and name or ""
        if Settings.ESPDistance then text = (text == "" and "" or text .. " ") .. string.format("[%dm]", dist // 1) end
        tag.label.Text = text
        tag.label.TextColor3 = color
        tag.highlight.FillColor = color
        tag.highlight.OutlineColor = color
        tag.highlight.Enabled = true 
    end

    task.spawn(function()
        while not Hub.unloaded do
            local root = getRoot()
            if root and (Settings.PlayerESP or Settings.RideESP or Settings.PoliceESP or Settings.CustomerESP) then
                local maxD = Settings.ESPMaxDistance
                
                if Settings.RideESP then
                    local ridesFolder = WS:FindFirstChild("Rides")
                    if ridesFolder then
                        for _, vehicle in ipairs(ridesFolder:GetChildren()) do
                            if vehicle:IsA("Model") and vehicle.Name:match("^Ride_") then
                                local ownerName = vehicle.Name:gsub("^Ride_", "")
                                local part = vehicle:FindFirstChild("#Weight", true) or vehicle:FindFirstChildWhichIsA("BasePart", true)
                                
                                if part then
                                    local dist = (part.Position - root.Position).Magnitude
                                    if maxD == 0 or dist <= maxD then
                                        local template = vehicle:GetAttribute("TemplateName") or "Scooter"
                                        paintTag(espTag(vehicle, part), Settings.ESPRideColor, string.format("%s's %s", ownerName, template), dist)
                                    end
                                end
                            end
                        end
                    end
                end
                
                local function mark(target, adornee, color, name)
                    local dist = (adornee.Position - root.Position).Magnitude
                    if maxD == 0 or dist <= maxD then paintTag(espTag(target, adornee), color, name, dist) end
                end

                if Settings.CustomerESP then
                    local customer = WS:FindFirstChild("DeliveryCustomer")
                    if customer then
                        local hrp = customer:FindFirstChild("HumanoidRootPart")
                        if hrp then mark(customer, hrp, Color3.fromRGB(255, 205, 40), "Delivery customer") end
                    end
                end
                
                if Settings.PoliceESP then
                    local police = WS:FindFirstChild("PoliceNPCs")
                    for _, car in ipairs(police and police:GetChildren() or {}) do
                        local body = car:FindFirstChild("DriveSeat", true) or car:FindFirstChildWhichIsA("BasePart", true)
                        if body then mark(car, body, Color3.fromRGB(70, 140, 255), "Police") end
                    end
                end
                
                clearEsp(true)
            else
                clearEsp(false)
            end
            task.wait(0.3)
        end
    end)

    local noclipSaved = {}
    appliers.Noclip = function(on)
        if on then return end
        for part in pairs(noclipSaved) do 
            if part.Parent then part.CanCollide = true end 
        end
        noclipSaved = {}
    end
    
    appliers.Fly = function(on) 
        if not on then 
            local h = getHum() 
            if h then h.PlatformStand = false end 
        end 
    end
    
    appliers.FOV = function(v) 
        if WS.CurrentCamera then WS.CurrentCamera.FieldOfView = v end 
    end

    bind(RunService.Stepped:Connect(function()
        if not Settings.Noclip then return end
        local c = LP.Character
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then 
                noclipSaved[p] = true 
                p.CanCollide = false 
            end
        end
    end))

    bind(UIS.JumpRequest:Connect(function()
        if not Settings.InfJump then return end
        local h = getHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end))

    local function flyDirection(h)
        local cf = WS.CurrentCamera.CFrame
        local dir = Vector3.zero
        local K = Enum.KeyCode
        if UIS:IsKeyDown(K.W) then dir += cf.LookVector end
        if UIS:IsKeyDown(K.S) then dir -= cf.LookVector end
        if UIS:IsKeyDown(K.D) then dir += cf.RightVector end
        if UIS:IsKeyDown(K.A) then dir -= cf.RightVector end
        if dir.Magnitude == 0 then dir = h.MoveDirection end
        if UIS:IsKeyDown(K.Space) then dir += Vector3.yAxis end
        if UIS:IsKeyDown(K.LeftControl) then dir -= Vector3.yAxis end
        return dir.Magnitude > 0 and dir.Unit or Vector3.zero
    end

    bind(RunService.Heartbeat:Connect(function()
        local h, root = getHum(), getRoot()
        if not (h and root) then return end
        if touched.WalkSpeed then h.WalkSpeed = Settings.WalkSpeed end
        if touched.JumpPower then
            h.UseJumpPower = true
            h.JumpPower = Settings.JumpPower
        end
        if touched.HipHeight then h.HipHeight = Settings.HipHeight end
        if Settings.Fly then
            h.PlatformStand = true
            root.AssemblyLinearVelocity = flyDirection(h) * Settings.FlySpeed
        end
    end))

    bind(RunService.RenderStepped:Connect(function()
        if touched.FOV and WS.CurrentCamera then WS.CurrentCamera.FieldOfView = Settings.FOV end
    end))

    local tpTool
    local function giveTeleportTool()
        if tpTool and tpTool.Parent then return end
        tpTool = Instance.new("Tool")
        tpTool.Name = "Click Teleport" 
        tpTool.RequiresHandle = false 
        tpTool.CanBeDropped = false
        tpTool.Parent = LP:WaitForChild("Backpack")
        tpTool.Activated:Connect(function()
            local root = getRoot()
            if not root then return end
            local hit = LP:GetMouse().Hit
            if hit then root.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0)) * root.CFrame.Rotation end
        end)
    end

    bind(LP.Idled:Connect(function()
        if not Settings.AntiAFK then return end
        pcall(function() 
            VirtualUser:CaptureController() 
            VirtualUser:ClickButton2(Vector2.new()) 
        end)
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
                for _, p in ipairs(P:GetPlayers()) do
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

    local function topSpeed(name) 
        local s = RideSpecs and RideSpecs[name] 
        return s and s.TopSpeed or 0 
    end
    
    task.spawn(function()
        while not Hub.unloaded do
            if Settings.AutoBuyRide and GetRides and BuyRide then
                local ok, rides = pcall(function() return GetRides:InvokeServer() end)
                if ok and type(rides) == "table" then
                    local best, cash, pick = 0, tonumber(LP:GetAttribute("Cash")) or 0, nil
                    for _, r in ipairs(rides) do 
                        if r.Owned then 
                            best = math.max(best, topSpeed(r.Name)) 
                        end 
                    end
                    for _, r in ipairs(rides) do
                        local price = tonumber(r.Price) or 0
                        if not r.Owned and not r.RobuxOnly and not r.Event and price > 0 and price <= cash then
                            local speed = topSpeed(r.Name)
                            if speed > best then
                                best = speed
                                pick = r
                            end
                        end
                    end
                    if pick then
                        local okb, bought = pcall(function() return BuyRide:InvokeServer(pick.Name) end)
                        if okb and bought then 
                            Session.ridesBought += 1 
                            WindUI:Notify({ Title = "Auto Buy", Content = "Bought " .. pick.Name, Icon = "check", Duration = 3 })
                        end
                    end
                end
            end
            task.wait(20)
        end
    end)

    task.spawn(function()
        while not Hub.unloaded do
            if Settings.AutoBuyBasic and OpenCase then
                local cash = tonumber(LP:GetAttribute("Cash")) or 0
                local cratePrice = 100 
                
                if cash >= cratePrice then
                    local ok, result = pcall(function()
                        return OpenCase:InvokeServer("Street", 1)
                    end)
                    if ok and result then
                        Session.cratesOpened += 1
                    end
                end
            end
            task.wait(1) 
        end
    end)

    local function disableCrateAnimation()
        local function killAnim(parent)
            if not parent then return end
            for _, gui in ipairs(parent:GetDescendants()) do
                if gui:IsA("Frame") or gui:IsA("ImageLabel") or gui:IsA("TextLabel") then
                    local name = gui.Name:lower()
                    if name:find("crate") or name:find("case") or name:find("open") or name:find("animation") then
                        gui.Visible = false
                    end
                end
                if gui:IsA("Animation") then
                    gui:Destroy()
                end
            end
        end
        
        killAnim(LP:FindFirstChild("PlayerGui"))
        local coreGui = game:GetService("CoreGui")
        killAnim(coreGui)
        
        LP.PlayerGui.DescendantAdded:Connect(function(d)
            if Settings.AutoBuyBasic then
                task.wait(0.1)
                if d:IsA("Frame") or d:IsA("ImageLabel") or d:IsA("TextLabel") then
                    local name = d.Name:lower()
                    if name:find("crate") or name:find("case") or name:find("open") or name:find("animation") then
                        d.Visible = false
                    end
                end
                if d:IsA("Animation") then d:Destroy() end
            end
        end)
    end
    
    disableCrateAnimation()

    task.spawn(function()
        while not Hub.unloaded do
            if GetQuests and (Settings.AutoQuests or (Settings.AutoWheelie and Settings.QuestHelpers)) then
                local ok, list = pcall(function() return GetQuests:InvokeServer() end)
                if ok and type(list) == "table" then
                    questsData = list
                    for i, q in ipairs(Settings.AutoQuests and ClaimQuest and list or {}) do
                        local ready = (q.NextAt or 0) <= os.time() and (q.Progress or 0) >= (q.Target or math.huge)
                        if ready then
                            local okc, claimed = pcall(function() return ClaimQuest:InvokeServer(i) end)
                            if okc and claimed then 
                                Session.quests += 1 
                                task.wait(0.4) 
                            end
                        end
                    end
                end
            end
            task.wait(5)
        end
    end)

    local function claimAll(claim)
        for _ = 1, 20 do
            local ok, claimed = pcall(claim)
            if not (ok and claimed) then return end
            Session.achievements += 1
            task.wait(0.3)
        end
    end

    task.spawn(function()
        while not Hub.unloaded do
            if Settings.AutoAchievements and ClaimAchievement and AchievementConfig then
                for _, a in ipairs(AchievementConfig.Achievements or {}) do
                    claimAll(function() return ClaimAchievement:InvokeServer(a.Id) end)
                end
                if ClaimAchievementReward then claimAll(function() return ClaimAchievementReward:InvokeServer() end) end
            end
            task.wait(30)
        end
    end)

    task.spawn(function()
        while not Hub.unloaded do
            if Settings.AutoDaily and GetDailyRewards and ClaimDailyReward then
                local ok, d = pcall(function() return GetDailyRewards:InvokeServer() end)
                if ok and type(d) == "table" and (d.NextAt or 0) <= os.time() then
                    local okc, claimed = pcall(function() return ClaimDailyReward:InvokeServer() end)
                    if okc and claimed then Session.daily += 1 end
                end
            end
            task.wait(60)
        end
    end)

    local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
    Window:Divider()
    local MainTab = Window:Tab({ Title = "Main", Icon = "activity" })
    local FarmTab = Window:Tab({ Title = "Farm", Icon = "pickaxe" })
    local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
    local RewardsTab = Window:Tab({ Title = "Rewards", Icon = "gift" })
    local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
    Window:Divider()
    local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

    local Player = game.Players.LocalPlayer
    
    local UserSection = InfoTab:Section({ Title = "User Information", Icon = "user" })
    pcall(function()
        UserSection:Paragraph({
            Title = "Hello, " .. Player.DisplayName,
            Desc = "Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown") .. "\nAccount Age: " .. Player.AccountAge .. " days\nUser ID: " .. Player.UserId,
            Image = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=420&h=420", ImageSize = 80
        })
    end)
    
    local tgSection = InfoTab:Section({ Title = "Telegram Channel", Icon = "link" })

    tgSection:Paragraph({
        Title = "Telegram Channel",
        Desc = "Official Channel\nSubscribers: 43",
        Image = "rbxassetid://112491954653394",
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
        Title = "Release Version 1.1 — November 7, 2026",
        Desc = "• Added Auto Wheelie Farm with Balance Angle slider.\n• Added Auto Flip Farm with Flip Count slider (1–6 flips).\n• Added Auto Delivery system with status tracking.\n• Added Auto Buy Best Scooter, Sticker Pack, Charms Crate, and Basic Crate (Street).\n• Added crate opening animation disabler.\n• Added Auto Claim Achievements, Quests, and Daily Rewards.\n• Added ESP for Players, Rides, Police, and Delivery Customers.\n• Added ESP names and distance display.\n• Added Movement: WalkSpeed, JumpPower, Float Height, Infinite Jump, Noclip, Fly, FOV.\n• Added Teleport Tool.\n• Added Speed and Acceleration Multipliers.\n• Added Anti Police and Anti Crash protection.\n• Added Fullbright and Anti Lag.\n• Added Performance: Hide Players, FPS Cap, Anti Lag.\n• Added Misc: Anti AFK, Quick Interact.\n• Added UI Settings: Transparency, Toggle UI.\n• Added FPS and Ping tags to the top bar.\n• Added Key System with saved key.\n• Added full Changelog to Information tab."
    })
    
    local wheelieSection = MainTab:Section({ Title = "Wheelie", Icon = "bike" })
    wheelieSection:Toggle({ 
        Title = "Auto Wheelie Farm",         
        Value = Settings.AutoWheelie, 
        Callback = function(v) setSetting("AutoWheelie", v) end 
    })
    wheelieSection:Slider({ 
        Title = "Balance Angle", 
        Value = { Min = 0, Max = 90, Default = 60 }, 
        Callback = function(v) setSetting("BalanceAngle", v) end 
    })

    local multSection = MainTab:Section({ Title = "Multipliers", Icon = "zap" })
    
    multSection:Slider({ 
        Title = "Speed Multiplier", 
        Desc = "Hold W to boost speed",
        Value = { Min = 1, Max = 5, Default = 1 }, 
        Callback = function(v) setSetting("SpeedMultiplier", v) end 
    })
    
    multSection:Slider({ 
        Title = "Acceleration Multiplier", 
        Desc = "Hold W for faster acceleration",
        Value = { Min = 1, Max = 5, Default = 1 }, 
        Callback = function(v) setSetting("AccelMultiplier", v) end 
    })

    local protectionSection = MainTab:Section({ Title = "Protection", Icon = "shield" })
    protectionSection:Toggle({ Title = "Anti Police", Value = Settings.AntiPolice, Callback = function(v) setSetting("AntiPolice", v) end })
    protectionSection:Toggle({ Title = "Anti Crash", Value = Settings.AntiCrash, Callback = function(v) setSetting("AntiCrash", v) end })

    local farmAutoSection = FarmTab:Section({ Title = "Auto Farm", Icon = "bot" })
    farmAutoSection:Divider({ Title = "Flip Farm" })
    
    local bfStatusLabel = farmAutoSection:Paragraph({ Title = "Flip Status", Desc = "Idle" })
    local bfStatsLabel = farmAutoSection:Paragraph({ Title = "Flip Stats", Desc = "Flips: 0 | Money: $0" })
    
    farmAutoSection:Slider({
        Title = "Flips per Jump", 
        Desc = "Number of backflip rotations in one jump (1 — 6)",
        Value = { Min = 1, Max = 6, Default = 6 },
        Callback = function(v) setSetting("FlipCount", v) end
    })
    farmAutoSection:Toggle({
        Title = "Auto Flip Farm", 
        Desc = "Automatically performs backflips to earn money",
        Value = Settings.AutoBackflip,
        Callback = function(v) setSetting("AutoBackflip", v) end
    })
    
    farmAutoSection:Divider({ Title = "Delivery" })
    local delStatusLabel = farmAutoSection:Paragraph({ Title = "Delivery Status", Desc = "Idle" })
    local delStatsLabel = farmAutoSection:Paragraph({ Title = "Delivery Stats", Desc = "Deliveries: 0 | Cash: $0" })
    farmAutoSection:Toggle({ 
        Title = "Auto Delivery", 
        Desc = "Automatically takes and delivers food orders",
        Value = Settings.AutoDelivery, 
        Callback = function(v) setSetting("AutoDelivery", v) end 
    })

    local shopSection = ShopTab:Section({ Title = "Auto Buy", Icon = "shopping-bag" })
    shopSection:Toggle({ Title = "Auto Buy Best Scooter", Value = Settings.AutoBuyRide, Callback = function(v) setSetting("AutoBuyRide", v) end })
    shopSection:Toggle({ Title = "Auto Buy Sticker pack", Value = Settings.AutoBuySticker, Callback = function(v) setSetting("AutoBuySticker", v) end })
    shopSection:Toggle({ Title = "Auto Buy Charms crate", Value = Settings.AutoBuyCharm, Callback = function(v) setSetting("AutoBuyCharm", v) end })
    shopSection:Toggle({ Title = "Auto Buy Basic Crate", Value = Settings.AutoBuyBasic, Callback = function(v) setSetting("AutoBuyBasic", v) end })
    
    local claimSection = RewardsTab:Section({ Title = "Auto Collect Rewards", Icon = "award" })
    claimSection:Toggle({ Title = "Auto Claim Achievements", Value = Settings.AutoAchievements, Callback = function(v) setSetting("AutoAchievements", v) end })
    claimSection:Toggle({ Title = "Auto Claim Quests", Value = Settings.AutoQuests, Callback = function(v) setSetting("AutoQuests", v) end })
    claimSection:Toggle({ Title = "Auto Claim Daily Rewards", Value = Settings.AutoDaily, Callback = function(v) setSetting("AutoDaily", v) end })

    local moveSection = PlayerTab:Section({ Title = "Movement", Icon = "move" })
    moveSection:Slider({ Title = "WalkSpeed", Value = { Min = 0, Max = 200, Default = Defaults.WalkSpeed }, Callback = function(v) setSetting("WalkSpeed", v) end })
    moveSection:Slider({ Title = "JumpPower", Value = { Min = 0, Max = 500, Default = Defaults.JumpPower, Rounding = 1 }, Callback = function(v) setSetting("JumpPower", v) end })
    moveSection:Slider({ Title = "Float Height", Value = { Min = 0, Max = 20, Default = Defaults.HipHeight, Rounding = 0.1 }, Callback = function(v) setSetting("HipHeight", v) end })
    moveSection:Toggle({ Title = "Infinite Jump", Value = Settings.InfJump, Callback = function(v) setSetting("InfJump", v) end })
    moveSection:Toggle({ Title = "Noclip", Value = Settings.Noclip, Callback = function(v) setSetting("Noclip", v) end })
    moveSection:Toggle({ Title = "Fly", Value = Settings.Fly, Callback = function(v) setSetting("Fly", v) end })
    moveSection:Slider({ Title = "FOV", Value = { Min = 30, Max = 120, Default = Defaults.FOV }, Callback = function(v) setSetting("FOV", v) end })
    moveSection:Button({ Title = "Give Teleport Tool", Callback = giveTeleportTool })

    local miscSection = SettingsTab:Section({ Title = "Misc", Icon = "shield" })
    miscSection:Toggle({ Title = "Anti AFK", Value = Settings.AntiAFK, Callback = function(v) setSetting("AntiAFK", v) end })
    miscSection:Toggle({ Title = "Quick Interact", Value = Settings.QuickInteract, Callback = function(v) setSetting("QuickInteract", v) end })

    local perfSection = SettingsTab:Section({ Title = "Performance", Icon = "activity" })
    perfSection:Toggle({ Title = "Hide Players", Value = Settings.HidePlayers, Callback = function(v) setSetting("HidePlayers", v) end })
    perfSection:Slider({ Title = "FPS Cap", Value = { Min = 15, Max = 240, Default = 60, Rounding = 5 }, Callback = function(v) setSetting("FPSCap", v) end })
    perfSection:Toggle({ Title = "Anti Lag", Value = Settings.AntiLag, Callback = function(v) setSetting("AntiLag", v) end })

    local uiSection = SettingsTab:Section({ Title = "UI Settings", Icon = "monitor" })
    uiSection:Slider({ Title = "Transparency", Value = { Min = 0, Max = 0.6, Default = 0, Rounding = 0.05 }, Callback = function(v) pcall(function() Window:SetBackgroundImageTransparency(v) end) end })
    uiSection:Button({ Title = "Toggle UI (Hide/Show)", Icon = "eye-off", Callback = function() pcall(function() Window:Close() end) end })

    task.spawn(function()
        while not Hub.unloaded do
            task.wait(1)
            pcall(function()
                if Settings.AutoBackflip then
                    bfStatusLabel:SetDesc(bfDebug or "Idle")
                    bfStatsLabel:SetDesc(string.format("Flips: %d | Money: $%d", Session.backflips, Session.flipCash))
                else
                    bfStatusLabel:SetDesc("Idle")
                end
                if Settings.AutoDelivery then
                    local labels = { idle = "Idle", toNPC = "-> NPC", takeOrder = "Taking order...",
                        toCustomer = "-> Customer", giveOrder = "Delivering...", wait = "Waiting..." }
                    delStatusLabel:SetDesc(labels[deliveryState] or deliveryState)
                    local rate = deliveryStats.done > 0
                        and math.floor(deliveryStats.cash / math.max((os.clock() - deliveryStats.startedAt) / 3600, 0.001))
                        or 0
                    delStatsLabel:SetDesc(string.format("Deliveries: %d | Cash: $%d | Rate: $%d/h",
                        deliveryStats.done, deliveryStats.cash, rate))
                else
                    delStatusLabel:SetDesc("Idle")
                end
            end)
        end
    end)

    local FpsTag, PingTag
    pcall(function()
        FpsTag = Window:Tag({ Title = "FPS: --", Icon = "gauge", Color = Color3.fromHex("#9B6BFF"), Radius = 8, TextSize = 12 })
        PingTag = Window:Tag({ Title = "Ping: --", Icon = "wifi", Color = Color3.fromHex("#9B6BFF"), Radius = 8, TextSize = 12 })
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
                pcall(function()
                    FpsTag:SetTitle("FPS: " .. fps)
                end)
            end
            if PingTag then
                local ping = LP:GetNetworkPing() * 1000
                pcall(function()
                    PingTag:SetTitle("Ping: " .. math.floor(ping + 0.5))
                end)
            end
        end
    end)
end

local ok, err = pcall(LoadServaHub)
if not ok then
    warn("[Serva Hub] Load error: " .. tostring(err))
end
