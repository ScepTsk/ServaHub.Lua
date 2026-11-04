local function LoadServaHub()
    
    local CorrectKey = "ScepTsk_Off"
    local KeyFile = "ServaHub_Key.json"
    
    local function IsKeySaved()
        if isfile and readfile and isfile(KeyFile) then
            local success, content = pcall(readfile, KeyFile)
            if success and content then
                local decoded = game:GetService("HttpService"):JSONDecode(content)
                if decoded and decoded.key == CorrectKey then
                    return true
                end
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
            Name = "Serva Hub",
            Accent = Color3.fromHex("#9B5CFF"),
            Background = Color3.fromHex("#07040F"),
            Outline = Color3.fromHex("#7A3CFF"),
            Text = Color3.fromHex("#F2E9FF"),
            Placeholder = Color3.fromHex("#8F7AB8"),
            Button = Color3.fromHex("#7A3CFF"),
            Icon = Color3.fromHex("#C9A6FF"),
        })

        local KeyWindow = WindUI:CreateWindow({
            Title = "Serva Hub • Key System",
            Icon = "rbxassetid://112491954653394",
            IconSize = 35,
            Author = "Verification",
            Background = "rbxassetid://116737345570479",
            Transparent = true,
            User = { Enabled = false, Anonymous = false },
        })

        KeyWindow:SetBackgroundImageTransparency(0)
        KeyWindow:EditOpenButton({
            Title = "Serva Hub • Key System",
            Icon = "rbxassetid://112491954653394",
            CornerRadius = UDim.new(0, 16),
            StrokeThickness = 2,
            Color = ColorSequence.new(Color3.fromHex("#B57BFF"), Color3.fromHex("#5B2BFF")),
            Enabled = true,
            Draggable = true,
        })

        local KeyTab = KeyWindow:Tab({ Title = "Key", Icon = "key" })
        local KeySection = KeyTab:Section({ Title = "Enter Key", Icon = "lock" })

        local InputKey = ""
        KeySection:Input({
            Title = "Key",
            Placeholder = "Enter your key here...",
            Callback = function(text)
                InputKey = text
            end
        })

        KeySection:Button({
            Title = "Get Key",
            Icon = "external-link",
            Callback = function()
                if setclipboard then
                    setclipboard("https://t.me/ServaHub")
                    WindUI:Notify({ Title = "Key System", Content = "Ссылка скопирована: https://t.me/ServaHub", Icon = "check", Duration = 3 })
                end
            end
        })

        KeySection:Button({
            Title = "Submit Key",
            Icon = "check",
            Callback = function()
                if InputKey == CorrectKey then
                    SaveKey()
                    KeyWindow:Destroy()
                    task.wait(0.5)
                     
                  getgenv().ServaHubKeyVerified = true
                    LoadServaHub()
                else
                    WindUI:Notify({ Title = "Error", Content = "Invalid Key!", Icon = "x", Duration = 3 })
                end
            end
        })
        return
    end

    local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    local RunService = game:GetService("RunService")
    local P = game:GetService("Players")
    local LP = P.LocalPlayer
    local WS = workspace

    WindUI:AddTheme({
        Name = "Serva Hub",
        Accent = Color3.fromHex("#9B5CFF"),
        Background = Color3.fromHex("#07040F"),
        Outline = Color3.fromHex("#7A3CFF"),
        Text = Color3.fromHex("#F2E9FF"),
        Placeholder = Color3.fromHex("#8F7AB8"),
        Button = Color3.fromHex("#7A3CFF"),
        Icon = Color3.fromHex("#C9A6FF"),
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

    local windowTitle = gradient("Serva Hub", Color3.fromRGB(201, 166, 255), Color3.fromRGB(122, 60, 255))
        .. ' <font color="rgb(155,92,255)">•</font> '
        .. '<font color="rgb(181,123,255)">v1.1</font>'

    local Window = WindUI:CreateWindow({
        Title = windowTitle,
        Icon = "rbxassetid://112491954653394",
        IconSize = 35,
        Author = '<font color="rgb(143,122,184)">Survive the killer</font>',
        Background = "rbxassetid://116737345570479",
        Transparent = true,
        User = { Enabled = true, Anonymous = false },
    })

    WindUI:SetTheme("Serva Hub")
    Window:SetBackgroundImageTransparency(0)
    Window:EditOpenButton({
        Title = "Serva Hub",
        Icon = "rbxassetid://112491954653394",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 2,
        Color = ColorSequence.new(Color3.fromHex("#B57BFF"), Color3.fromHex("#5B2BFF")),
        Enabled = true,
        Draggable = true,
    })
    
    local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
    local VisualTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
    local CombatTab = Window:Tab({ Title = "Combat", Icon = "swords" })
    local FarmTab = Window:Tab({ Title = "Farm", Icon = "pickaxe" })
    local TeleportsTab = Window:Tab({ Title = "Teleports", Icon = "map-pin" })
    local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

    local KillerESP, InnocentESP, DownedESP, ExitESP = false, false, false, false
    local AutoAttack = false
    local AttackCooldown = 0.3
    local KillAssist = false
    local Smoothness = 50
    local AssistMode = "Nearest"
    local TargetQuery = ""
    local Fullbright = false
    local AutoSprint = false
    local KillerAlert = false
    local AlertRange = 50
    local CandyFarmMode = "None"
    local CandyFlyEnabled = false
    local CandyESPEnabled = false
    local CandyBoxsize = 1 

    local Player = game.Players.LocalPlayer
    
    local UserSection = InfoTab:Section({ Title = "User Information", Icon = "user" })
    UserSection:Paragraph({
        Title = "Hello, " .. Player.DisplayName,
        Desc = "Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown") ..
               "\nAccount Age: " .. Player.AccountAge .. " days" ..
               "\nUser ID: " .. Player.UserId,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=420&h=420",
        ImageSize = 80
    })

    local LinkSection = InfoTab:Section({ Title = "Links", Icon = "link" })
    LinkSection:Paragraph({
        Title = "Telegram Channel",
        Desc = "Official Channel\nSubscribers: 30",
        Image = "rbxassetid://112491954653394",
        ImageSize = 50
    })
    LinkSection:Button({
        Title = "Copy Telegram Link", Icon = "copy",
        Callback = function() if setclipboard then setclipboard("https://t.me/ServaHub") end end,
    })

    local ChangelogSection = InfoTab:Section({ Title = "Changelog", Icon = "scroll-text" })
    ChangelogSection:Paragraph({
        Title = '<font color="rgb(201,166,255)">Serva Hub v1.1</font>',
        Desc = '<font color="rgb(143,122,184)">• Added ESP (Killer, Survivors, Downed, Exits)</font>\n' ..
               '<font color="rgb(143,122,184)">• Added Candy Farm (Teleport & Fly modes)</font>\n' ..
               '<font color="rgb(143,122,184)">• Added Candy ESP (Box) with adjustable size</font>\n' ..
               '<font color="rgb(143,122,184)">• Added Kill Assist (Camera, Nearest, Target)</font>\n' ..
               '<font color="rgb(143,122,184)">• Added Utility (Auto Sprint, Killer Alert)</font>\n' ..
               '<font color="rgb(143,122,184)">• Added Teleports (Lobby, Map, Players)</font>\n' ..
               '<font color="rgb(143,122,184)">• Added Fullbright & UI Settings</font>\n' ..
               '<font color="rgb(143,122,184)">• Added Anti AFK</font>',
        Image = "rbxassetid://112491954653394",
        ImageSize = 40,
    })

    local EspSection = VisualTab:Section({ Title = "Player ESP", Icon = "users" })
    EspSection:Toggle({ Title = "Killer ESP", Value = false, Callback = function(v) KillerESP = v end })
    EspSection:Toggle({ Title = "Survivors ESP", Value = false, Callback = function(v) InnocentESP = v end })
    EspSection:Toggle({ Title = "Downed ESP", Value = false, Callback = function(v) DownedESP = v end })
    
    local ObjEspSection = VisualTab:Section({ Title = "Object ESP", Icon = "box" })
    ObjEspSection:Toggle({ Title = "Exit Door ESP", Value = false, Callback = function(v) ExitESP = v end })
    
    ObjEspSection:Toggle({ 
        Title = "Candy ESP (Box)", 
        Value = false, 
        Callback = function(v)
            CandyESPEnabled = v
            if v then
                task.spawn(function()
                    while CandyESPEnabled and Window do
                        for _, obj in ipairs(WS:GetDescendants()) do
                            if obj.Name == "CandyBox" and obj:IsA("BoxHandleAdornment") then
                                local candy = obj.Adornee
                                if not candy or not candy.Parent then obj:Destroy() end
                            end
                        end
                        for _, child in ipairs(WS:GetChildren()) do
                            local ls = child:FindFirstChild("LootSpawns")
                            if ls then
                                for _, obj in ipairs(ls:GetChildren()) do
                                    if (obj:IsA("BasePart") or obj:IsA("MeshPart")) then
                                        if not obj:FindFirstChild("CandyBox") then
                                            local box = Instance.new("BoxHandleAdornment")
                                            box.Name = "CandyBox"
                                            box.Adornee = obj
                                            box.AlwaysOnTop = true
                                            box.ZIndex = 5
                                            box.Size = Vector3.new(CandyBoxsize, CandyBoxsize, CandyBoxsize) 
                                            box.Color3 = Color3.fromRGB(255, 255, 0)
                                            box.Transparency = 0.4
                                            box.Parent = obj
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.3)
                    end
                end)
            else
                for _, child in ipairs(WS:GetChildren()) do
                    local ls = child:FindFirstChild("LootSpawns")
                    if ls then
                        for _, obj in ipairs(ls:GetChildren()) do
                            local box = obj:FindFirstChild("CandyBox")
                            if box then box:Destroy() end
                        end
                    end
                end
            end
        end 
    })
    
    ObjEspSection:Slider({
        Title = "Candy Box Size",
        Value = { Min = 1, Max = 10, Default = 1 },
        Callback = function(value)
            CandyBoxsize = value
            for _, child in ipairs(WS:GetChildren()) do
                local ls = child:FindFirstChild("LootSpawns")
                if ls then
                    for _, obj in ipairs(ls:GetChildren()) do
                        local box = obj:FindFirstChild("CandyBox")
                        if box then box.Size = Vector3.new(CandyBoxsize, CandyBoxsize, CandyBoxsize) end
                    end
                end
            end
        end,
    })

    local WorldSection = VisualTab:Section({ Title = "World Visuals", Icon = "sun" })
    WorldSection:Toggle({
        Title = "FullBright", Value = false,
        Callback = function(v)
            Fullbright = v
            if v then
                game.Lighting.Ambient = Color3.new(1,1,1); game.Lighting.Brightness = 3; game.Lighting.FogEnd = 999999; game.Lighting.GlobalShadows = false
            else
                game.Lighting.Ambient = Color3.new(0,0,0); game.Lighting.Brightness = 1; game.Lighting.FogEnd = 100000; game.Lighting.GlobalShadows = true
            end
        end
    })

    local CombatSection = CombatTab:Section({ Title = "Auto Combat", Icon = "swords" })
    CombatSection:Toggle({ Title = "Auto Attack (Killer)", Value = false, Callback = function(v) AutoAttack = v end })
    CombatSection:Slider({ Title = "Attack Cooldown", Value = { Min = 0.05, Max = 2, Default = 0.3 }, Callback = function(v) AttackCooldown = v end })

    local AssistSection = CombatTab:Section({ Title = "Kill Assist", Icon = "crosshair" })
    AssistSection:Toggle({ Title = "Enable Kill Assist", Value = false, Callback = function(v) KillAssist = v end })
    AssistSection:Slider({ Title = "Smoothness", Value = { Min = 0, Max = 100, Default = 50 }, Callback = function(v) Smoothness = v end })
    AssistSection:Dropdown({
        Title = "Assist Mode",
        Values = { "Camera", "Nearest", "Target" },
        Value = "Nearest", AllowNone = false,
        Callback = function(option) AssistMode = option end,
    })
    AssistSection:Input({
        Title = "Target Name",
        Placeholder = "Type Player Name",
        Callback = function(text) TargetQuery = text end
    })

    local UtilSection = CombatTab:Section({ Title = "Utility", Icon = "wrench" })
    UtilSection:Toggle({ Title = "Auto Sprint", Value = false, Callback = function(v) AutoSprint = v end })
    UtilSection:Toggle({ Title = "Killer Proximity Alert", Value = false, Callback = function(v) KillerAlert = v end })
    UtilSection:Slider({ Title = "Alert Range", Value = { Min = 10, Max = 200, Default = 50 }, Callback = function(v) AlertRange = v end })

    local FarmSection = FarmTab:Section({ Title = "Farm Candy", Icon = "candy" })
    FarmSection:Dropdown({
        Title = "Auto Farm Candy", Values = {"None", "Teleport", "Fly"}, Value = "None", AllowNone = false,
        Callback = function(option)
            CandyFarmMode = option
            CandyFlyEnabled = (option == "Fly")
            if option == "None" then getgenv().CandyBlacklist = {} end
        end,
    })

    local function teleportTo(pos)
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(pos) end
    end

    task.spawn(function()
        if not getgenv().CandyBlacklist then getgenv().CandyBlacklist = {} end
        while Window do
            task.wait(0.15)
            if CandyFarmMode ~= "None" then
                local activeLootSpawns = nil
                for _, child in ipairs(WS:GetChildren()) do
                    local ls = child:FindFirstChild("LootSpawns")
                    if ls then activeLootSpawns = ls break end
                end

                if activeLootSpawns then
                    local char = LP.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local availableCandies = {}
                        for _, obj in ipairs(activeLootSpawns:GetChildren()) do
                            if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and not getgenv().CandyBlacklist[obj] then
                                table.insert(availableCandies, obj)
                            end
                        end
                        if #availableCandies > 0 then
                            table.sort(availableCandies, function(a, b)
                                return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
                            end)
                            local target = availableCandies[1]
                            if CandyFarmMode == "Teleport" then
                                if target and target.Parent then
                                    getgenv().CandyBlacklist[target] = true
                                    teleportTo(target.Position + Vector3.new(0, 3, 0))
                                    task.wait(0.2) 
                                    local prompt = target:FindFirstChildOfClass("ProximityPrompt")
                                    if prompt then prompt:InputHoldBegin() task.wait(0.1) prompt:InputHoldEnd() end
                                    task.wait(0.3) 
                                end
                            elseif CandyFarmMode == "Fly" then
                                if target and target.Parent then
                                    getgenv().CandyBlacklist[target] = true
                                    local targetPos = target.Position + Vector3.new(0, 3, 0)
                                    local timeout = tick() + 3
                                    while CandyFlyEnabled and hrp and target.Parent and (hrp.Position - targetPos).Magnitude > 3 and tick() < timeout do
                                        local moveDir = (targetPos - hrp.Position).Unit
                                        hrp.CFrame = hrp.CFrame + moveDir * 5
                                        task.wait()
                                    end
                                    local prompt = target:FindFirstChildOfClass("ProximityPrompt")
                                    if prompt then prompt:InputHoldBegin() task.wait(0.1) prompt:InputHoldEnd() end
                                    task.wait(0.4)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    local MainTeleports = TeleportsTab:Section({ Title = "Main Locations", Icon = "map" })
    MainTeleports:Button({
        Title = "Teleport to Lobby", Icon = "", Color = Color3.fromHex("#3A1B8F"), Justify = "Center",
        Callback = function()
            if LP.Character and WS:FindFirstChild("_Lobby") then
                LP.Character.HumanoidRootPart:PivotTo(WS._Lobby.Decor.Props:GetChildren()[92].HayBale_Rope:GetPivot())
            end
        end, 
    })
    MainTeleports:Button({
        Title = "Teleport to Map", Icon = "", Color = Color3.fromHex("#3A1B8F"), Justify = "Center",
        Callback = function()
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local mapFolder = nil
            for _, obj in ipairs(WS:GetChildren()) do
                if (obj:IsA("Folder") or obj:IsA("Model")) and obj.Name ~= "_Lobby" and obj.Name ~= "TerrainGraph" then
                    if obj:FindFirstChild("LootSpawns") or obj:FindFirstChild("invisWall") or obj:FindFirstChildOfClass("SpawnLocation") then
                        mapFolder = obj break
                    end
                end
            end
            if mapFolder then
                local spawnPoint = mapFolder:FindFirstChild("SpawnLocation", true)
                if spawnPoint then teleportTo(spawnPoint.Position + Vector3.new(0, 5, 0)) return end
                for _, descendant in ipairs(mapFolder:GetDescendants()) do
                    if descendant:IsA("BasePart") and descendant.Name:lower():find("spawn") then teleportTo(descendant.Position + Vector3.new(0, 5, 0)) return end
                end
                teleportTo(mapFolder:GetPivot().Position + Vector3.new(0, 10, 0))
            else
                local otherPlayers = {}
                for _, p in pairs(P:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then table.insert(otherPlayers, p) end
                end
                if #otherPlayers > 0 then teleportTo(otherPlayers[1].Character.HumanoidRootPart.Position) end
            end
        end, 
    })

    local PlayerTeleports = TeleportsTab:Section({ Title = "Player Teleports", Icon = "users" })
    PlayerTeleports:Button({
        Title = "Teleport to Random Player", Icon = "", Color = Color3.fromHex("#3A1B8F"), Justify = "Center",
        Callback = function()
            local playersList = {}
            for _, p in pairs(P:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then table.insert(playersList, p) end
            end
            if #playersList > 0 then teleportTo(playersList[math.random(1, #playersList)].Character.HumanoidRootPart.Position) end
        end,
    })

    local selectedPlayer = nil
    local playerDropdown = PlayerTeleports:Dropdown({
        Title = "Select Player", Values = {}, Value = nil, AllowNone = true,
        Callback = function(option) selectedPlayer = option end,
    })
    task.spawn(function()
        while Window do
            task.wait(2)
            local playerNames = {}
            for _, p in pairs(P:GetPlayers()) do
                if p ~= LP then table.insert(playerNames, p.Name) end
            end
            pcall(function() playerDropdown:Refresh(playerNames) end)
        end
    end)

    PlayerTeleports:Button({
        Title = "Teleport to Selected Player", Icon = "", Color = Color3.fromHex("#3A1B8F"), Justify = "Center",
        Callback = function()
            if selectedPlayer then
                local target = P:FindFirstChild(selectedPlayer)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    teleportTo(target.Character.HumanoidRootPart.Position)
                end
            end
        end,
    })

    local UiSection = SettingsTab:Section({ Title = "UI Settings", Icon = "monitor" })
    UiSection:Slider({
        Title = "Background Transparency", Value = { Min = 0, Max = 1, Default = 0 },
        Callback = function(value) pcall(function() Window:SetBackgroundImageTransparency(value) end) end,
    })
    UiSection:Button({ Title = "Toggle UI (Hide/Show)", Icon = "eye-off", Callback = function() Window:Close() end })

    local MiscSection = SettingsTab:Section({ Title = "Misc Settings", Icon = "shield" })
    local AntiAfkEnabled = false
    MiscSection:Toggle({
        Title = "Anti AFK", Desc = "Keeps you in-game", Icon = "clock", Value = false,
        Callback = function(state) AntiAfkEnabled = state; getgenv().AntiAFK = state end,
    })

    local ok_clone, VirtualUser = pcall(function() return cloneref(game:GetService("VirtualUser")) end)
    if not ok_clone then VirtualUser = game:GetService("VirtualUser") end
    local ok_plr, Players = pcall(function() return cloneref(game:GetService("Players")) end)
    if not ok_plr then Players = game:GetService("Players") end

    Players.LocalPlayer.Idled:Connect(function()
        if AntiAfkEnabled then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)

    local espCache = {}
    local function getRole(plr) local t = plr:GetAttribute("TeamID") or (plr.Team and plr.Team.Name) return t or "Survivor" end
    local function isDowned(plr) return plr:GetAttribute("Downed") == true end

    local function setupESP(plr)
        if plr == LP or espCache[plr] then return end
        local hl = Instance.new("Highlight", WS)
        hl.Name = "ServaHub_HL"; hl.FillTransparency = 0.5; hl.OutlineTransparency = 0; hl.Adornee = plr.Character
        local bb = Instance.new("BillboardGui", WS)
        bb.Name = "ServaHub_Name"; bb.Size = UDim2.new(0,140,0,20); bb.StudsOffset = Vector3.new(0,3,0); bb.AlwaysOnTop = true; bb.Adornee = plr.Character and plr.Character:FindFirstChild("Head")
        local lbl = Instance.new("TextLabel", bb)
        lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.Text = plr.DisplayName; lbl.TextStrokeTransparency = 0; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 14
        espCache[plr] = {hl=hl, bb=bb, lbl=lbl}
    end

    for _,p in ipairs(P:GetPlayers()) do setupESP(p) end
    P.PlayerAdded:Connect(setupESP)
    P.PlayerRemoving:Connect(function(p) if espCache[p] then pcall(function() espCache[p].hl:Destroy() end) pcall(function() espCache[p].bb:Destroy() end) espCache[p]=nil end end)

    task.spawn(function()
        while Window do
            task.wait(0.15)
            local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            for plr, esp in pairs(espCache) do
                local char = plr.Character
                if not char then esp.hl.Enabled = false; esp.bb.Enabled = false
                else
                    local role = getRole(plr); local downed = isDowned(plr)
                    local c, text
                    if role == "Killer" and KillerESP then
                        c = Color3.fromRGB(255,40,40)
                        local dist = myRoot and math.floor((myRoot.Position-char.HumanoidRootPart.Position).Magnitude) or 0
                        text = "KILLER | "..plr.DisplayName.." ["..dist.."m]"
                    elseif downed and DownedESP then
                        c = Color3.fromRGB(255,255,0)
                        local dist = myRoot and math.floor((myRoot.Position-char.HumanoidRootPart.Position).Magnitude) or 0
                        text = "DOWNED | "..plr.DisplayName.." ["..dist.."m]"
                    elseif role ~= "Killer" and InnocentESP then
                        c = Color3.fromRGB(40,255,40)
                        local dist = myRoot and math.floor((myRoot.Position-char.HumanoidRootPart.Position).Magnitude) or 0
                        text = plr.DisplayName.." ["..dist.."m]"
                    else esp.hl.Enabled = false; esp.bb.Enabled = false; c = nil end
                    
                    if c then
                        esp.hl.Enabled = true; esp.bb.Enabled = true
                        esp.hl.FillColor = c; esp.hl.OutlineColor = c
                        esp.lbl.TextColor3 = c; esp.lbl.Text = text
                        esp.bb.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    end
                end
            end
        end
    end)

    local exitCache = {}
    task.spawn(function()
        while Window do
            task.wait(0.5)
            if ExitESP then
                for _, child in ipairs(WS:GetChildren()) do
                    local exitsFolder = child:FindFirstChild("Exits")
                    if exitsFolder then
                        for _, exitObj in ipairs(exitsFolder:GetChildren()) do
                            local doorWay = exitObj:FindFirstChild("Doorway")
                            local frame = doorWay and doorWay:FindFirstChild("Frame")
                            local door2 = doorWay and doorWay:FindFirstChild("Door2")
                            local exitEffect = exitObj:FindFirstChild("ExitEffect")

                            if doorWay and not exitCache[doorWay] then
                                local hl = Instance.new("Highlight")
                                hl.Parent = doorWay; hl.FillColor = Color3.fromRGB(255, 140, 0); hl.OutlineColor = Color3.fromRGB(255, 255, 255); hl.FillTransparency = 0.5; hl.Adornee = doorWay
                                exitCache[doorWay] = hl
                            end
                            if frame and not exitCache[frame] then
                                local hl = Instance.new("Highlight")
                                hl.Parent = frame; hl.FillColor = Color3.fromRGB(255, 140, 0); hl.OutlineColor = Color3.fromRGB(255, 255, 255); hl.FillTransparency = 0.5; hl.Adornee = frame
                                exitCache[frame] = hl
                            end
                            if door2 and not exitCache[door2] then
                                local hl = Instance.new("Highlight")
                                hl.Parent = door2; hl.FillColor = Color3.fromRGB(255, 140, 0); hl.OutlineColor = Color3.fromRGB(255, 255, 255); hl.FillTransparency = 0.5; hl.Adornee = door2
                                exitCache[door2] = hl
                            end
                            if exitEffect and not exitCache[exitEffect] then
                                local hl = Instance.new("Highlight")
                                hl.Parent = exitEffect; hl.FillColor = Color3.fromRGB(255, 140, 0); hl.OutlineColor = Color3.fromRGB(255, 255, 255); hl.FillTransparency = 0.5; hl.Adornee = exitEffect
                                exitCache[exitEffect] = hl
                            end
                        end
                    end
                end
            else
                for obj, hl in pairs(exitCache) do
                    if hl then hl:Destroy() end
                    exitCache[obj] = nil
                end
            end
        end
    end)

    local function getTarget()
        if AssistMode == "Target" and #TargetQuery > 0 then
            for _, plr in ipairs(P:GetPlayers()) do
                if plr ~= LP and (plr.Name:lower() == TargetQuery:lower() or plr.DisplayName:lower() == TargetQuery:lower()) then return plr end
            end
        end
        local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        local closest, dist = nil, math.huge
        for _, plr in ipairs(P:GetPlayers()) do
            if plr ~= LP and getRole(plr) ~= "Killer" and not isDowned(plr) then
                local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local d = (myRoot.Position - root.Position).Magnitude
                    if d < dist then dist = d; closest = plr end
                end
            end
        end
        return closest
    end

    task.spawn(function()
        local lastAlertTime = 0
        while Window do
            task.wait(0.1)
            if AutoSprint and LP.Character then
                local hum = LP.Character:FindFirstChild("Humanoid")
                if hum and hum.WalkSpeed < 30 then hum.WalkSpeed = 30 end
            end
            if KillerAlert and LP.Character then
                local myRoot = LP.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    local killerNearby = false
                    local nearestDist = math.huge
                    for _, plr in ipairs(P:GetPlayers()) do
                        if plr ~= LP and getRole(plr) == "Killer" then
                            local kRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                            if kRoot then
                                local d = (myRoot.Position - kRoot.Position).Magnitude
                                if d <= AlertRange then
                                    killerNearby = true
                                    if d < nearestDist then nearestDist = d end
                                end
                            end
                        end
                    end
                    if killerNearby and (tick() - lastAlertTime >= 5) then
                        lastAlertTime = tick()
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while Window do
            task.wait(AttackCooldown)
            if AutoAttack or KillAssist then
                local target = getTarget()
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    if KillAssist then
                        local targetPos = target.Character.HumanoidRootPart.Position
                        local cam = workspace.CurrentCamera
                        if Smoothness > 0 then
                            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, targetPos), 1 - (Smoothness/100))
                        else
                            cam.CFrame = CFrame.new(cam.CFrame.Position, targetPos)
                        end
                    end
                    if AutoAttack then end
                end
            end
        end
    end)

    local Stats = game:GetService("Stats")
    if cloneref then Stats = cloneref(Stats) end
    local FpsTag = Window:Tag({ Title = "FPS: --", Icon = "gauge", Color = Color3.fromHex("#9B6BFF"), Radius = 8, TextSize = 12 })
    local PingTag = Window:Tag({ Title = "Ping: --", Icon = "wifi", Color = Color3.fromHex("#9B6BFF"), Radius = 8, TextSize = 12 })
    
    local frames, lastTick = 0, os.clock()
    local fallbackFps = 0
    RunService.RenderStepped:Connect(function()
        frames += 1
        local now = os.clock()
        if now - lastTick >= 1 then fallbackFps = frames; frames = 0; lastTick = now end
    end)

    task.spawn(function()
        while Window do
            task.wait(0.5)
            local fps = fallbackFps
            local manager = Stats:FindFirstChild("FrameRateManager")
            local RenderAverage = manager and manager:FindFirstChild("RenderAverage")
            if RenderAverage then
                local ok, ms = pcall(function() return RenderAverage:GetValue() end)
                if ok and type(ms) == "number" and ms > 0 then fps = math.floor(1000 / ms) end
            end
            if FpsTag.SetTitle then FpsTag:SetTitle("FPS: " .. fps) end
            
            local ping = LP:GetNetworkPing() * 1000
            if PingTag.SetTitle then PingTag:SetTitle("Ping: " .. math.floor(ping + 0.5)) end
        end
    end)
end

local ok, err = pcall(LoadServaHub)
if not ok then
    warn("[Serva Hub] Load error: " .. tostring(err))
end
