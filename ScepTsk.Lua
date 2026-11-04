local function LoadServaHub()
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

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

local windowTitle =
    gradient("Serva Hub", Color3.fromRGB(201, 166, 255), Color3.fromRGB(122, 60, 255))
    .. ' <font color="rgb(155,92,255)">•</font> '
    .. '<font color="rgb(181,123,255)">v1.2</font>'

local windowAuthor = '<font color="rgb(143,122,184)">Bear alpha</font>'

local Window = WindUI:CreateWindow({
    Title = windowTitle,
    Icon = "rbxassetid://112491954653394",
    IconSize = 35,
    Author = windowAuthor,
    Background = "rbxassetid://116737345570479",
    Transparent = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() print("clicked to the 'user icon'") end,
    },
})

WindUI:SetTheme("Serva Hub")
Window:SetBackgroundImageTransparency(0)

Window:EditOpenButton({
    Title = "Serva Hub",
    Icon = "rbxassetid://112491954653394",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("#B57BFF"), Color3.fromHex("#5B2BFF")),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local InfoTab = Window:Tab({ Title = "information", Icon = "info" })
local Tab3 = Window:Tab({ Title = "Player", Icon = "user" })
local FarmTab = Window:Tab({ Title = "Farm", Icon = "pickaxe" })
local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local TeleportsTab = Window:Tab({ Title = "Teleports", Icon = "map-pin" })
local Tab4 = Window:Tab({ Title = "Settings", Icon = "settings" })

local Player = game.Players.LocalPlayer
local accountAge = Player.AccountAge .. " days"
local avatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=420&h=420"

local DiscordInvite = "discord.gg/DEm4RE69gj"
local TelegramLink = "https://t.me/ServaHub"
local BTN_COLOR  = Color3.fromHex("#3A1B8F")
local BTN_TEXT   = Color3.fromHex("#E3CCFF")
local BTN_STROKE = Color3.fromHex("#9B5CFF")

local UserSection = InfoTab:Section({ Title = "User Information", Icon = "user" })

UserSection:Paragraph({
    Title = "Hello, " .. Player.DisplayName,
    Desc = "Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown") ..
           "\nAccount Age: " .. accountAge ..
           "\n\n" ..
           "User ID: " .. Player.UserId ..
           "\nStatus: " .. (Player.MembershipType == Enum.MembershipType.Premium and "Premium" or "Normal"),
    Image = avatarImage,
    ImageSize = 80
})

local LinkSection = InfoTab:Section({ Title = "Links", Icon = "link" })

LinkSection:Paragraph({
    Title = '<font color="rgb(201,166,255)">Discord Community • Serva Hub</font>',
    Desc = '<font color="rgb(201,166,255)">Server Info</font>\n<font color="rgb(181,123,255)">Members: 3</font>',
    Image = "rbxassetid://112491954653394",
    ImageSize = 50,
})

LinkSection:Button({
    Title = "Copy Discord Invite",
    Icon = "copy",
    Color = BTN_COLOR,
    Justify = "Center",
    Callback = function()
        if setclipboard then
            setclipboard(DiscordInvite)
            WindUI:Notify({ Title = "Discord", Content = "Successfully Copied!", Icon = "check" })
        end
    end,
})

LinkSection:Paragraph({
    Title = '<font color="rgb(201,166,255)">Telegram Channel • Serva Hub</font>',
    Desc = '<font color="rgb(201,166,255)">Channel Info</font>\n<font color="rgb(181,123,255)">Subscribers: 11</font>',
    Image = "rbxassetid://112491954653394",
    ImageSize = 50,
})

LinkSection:Button({
    Title = "Copy Telegram Link",
    Icon = "copy",
    Color = BTN_COLOR,
    Justify = "Center",
    Callback = function()
        if setclipboard then
            setclipboard(TelegramLink)
            WindUI:Notify({ Title = "Telegram", Content = "Link Successfully Copied!", Icon = "check" })
        end
    end,
})

local ChangelogSection = InfoTab:Section({ Title = "Changelog", Icon = "scroll-text" })

ChangelogSection:Paragraph({
    Title = '<font color="rgb(201,166,255)">Serva Hub v1.2</font>',
    Desc = '<font color="rgb(143,122,184)">• Added Auto Farm Puzzles (Beta)</font>\n' ..
           '<font color="rgb(143,122,184)">• Added Bear ESP (Optimized)</font>\n' ..
           '<font color="rgb(143,122,184)">• Added Survivors ESP</font>\n' ..
           '<font color="rgb(143,122,184)">• Added Candy ESP</font>\n' ..
           '<font color="rgb(143,122,184)">• Added Candy Farm modes: Teleport & Fly</font>\n' ..
           '<font color="rgb(143,122,184)">• Added Player Settings (WalkSpeed, JumpPower, Noclip)</font>\n' ..
           '<font color="rgb(143,122,184)">• Added Player Teleports (Random & Selected)</font>\n' ..
           '<font color="rgb(143,122,184)">• Added World Settings (Fullbright, No Fog, FOV)</font>\n' ..
           '<font color="rgb(143,122,184)">• UI improvements & bug fixes</font>',
    Image = "rbxassetid://112491954653394",
    ImageSize = 40,
})

local PlayerSection = Tab3:Section({ Title = "Player Settings", Icon = "user" })

PlayerSection:Slider({
    Title = "WalkSpeed",
    Value = { Min = 16, Max = 500, Default = 16 },
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end,
})

PlayerSection:Slider({
    Title = "JumpPower",
    Value = { Min = 50, Max = 500, Default = 50 },
    Callback = function(value)
        local Hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if Hum then
            local Power = value
            if Hum.UseJumpPower then
               Hum.JumpPower = Power
            else
               Hum.JumpHeight = (Power ^ 2) / (2 * workspace.Gravity)
            end
        end
    end,
})

local NoclipEnabled = false
local Connect = nil

PlayerSection:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls",
    Icon = "ghost",
    Value = false,
    Callback = function(state)
        NoclipEnabled = state

        if state then
           Connect = RunService.Stepped:Connect(function()
              local char = player.Character or player.CharacterAdded:Wait()
              for _, v in ipairs(char:GetDescendants()) do
                 if v:IsA("BasePart") and v.CanCollide == true then 
                    v.CanCollide = false
                 end
              end
           end)
        else
           if Connect then
              Connect:Disconnect()
              Connect = nil
           end
           local char = player.Character or player.CharacterAdded:Wait()
           for _, v in ipairs(char:GetDescendants()) do
              if v:IsA("BasePart") and v.CanCollide == false then 
                 v.CanCollide = true
              end
           end
        end
    end,
})

local FarmSection = FarmTab:Section({ Title = "Farm Candy", Icon = "candy" })

local CandyFarmMode = "None"
local CandyFlyEnabled = false

FarmSection:Dropdown({
    Title = "Auto Farm Candy",
    Values = {"None", "Teleport", "Fly"},
    Value = "None",
    AllowNone = false,
    Callback = function(option)
        CandyFarmMode = option
        CandyFlyEnabled = (option == "Fly")
    end,
})

local function teleportTo(pos)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(pos)
    end
end

local function teleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if targetHRP then
        teleportTo(targetHRP.Position)
    end
end

task.spawn(function()
    while task.wait(0.1) do
        if CandyFarmMode ~= "None" then
            local map = workspace:FindFirstChild("Map")
            if map then
                local candies = {}
                for _, obj in ipairs(map:GetDescendants()) do
                    local nameLower = obj.Name:lower()
                    if nameLower:find("candy") or nameLower:find("конфета") then
                        if obj:IsA("BasePart") and obj.Parent then
                            table.insert(candies, obj)
                        end
                    end
                end

                if #candies > 0 then
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then continue end

                    local target = candies[1]
                    
                    if CandyFarmMode == "Teleport" then
                        
                        local originalPos = hrp.Position
                        if target and target.Position then
                            teleportTo(target.Position + Vector3.new(0, 3, 0))
                            task.wait(0.5) 
                            if originalPos and originalPos ~= Vector3.new(0,0,0) then
                                teleportTo(originalPos)
                            end
                        end
                    elseif CandyFarmMode == "Fly" then
                        
                        local targetPos = target.Position + Vector3.new(0, 3, 0)
                        
                        
                        while CandyFlyEnabled and hrp and (hrp.Position - targetPos).Magnitude > 3 do
                            local moveDir = (targetPos - hrp.Position).Unit
                            hrp.CFrame = hrp.CFrame + moveDir * 4
                            task.wait()
                        end
                        
                        task.wait(0.3) 
                        
                        
                        local returnPos = hrp.Position + Vector3.new(0, 10, 0)
                        while CandyFlyEnabled and hrp and (hrp.Position - returnPos).Magnitude > 3 do
                            local moveDir = (returnPos - hrp.Position).Unit
                            hrp.CFrame = hrp.CFrame + moveDir * 4
                            task.wait()
                        end
                    end
                end
            end
        end
    end
end)


local PuzzleSection = FarmTab:Section({ Title = "Auto Puzzles", Icon = "zap" })

local AutoSolvePuzzlesEnabled = false

PuzzleSection:Toggle({
    Title = "Auto Farm Puzzles [Beta]",
    Icon = "zap",
    Value = false,
    Callback = function(state)
        AutoSolvePuzzlesEnabled = state
        
        if state then
            task.spawn(function()
                while AutoSolvePuzzlesEnabled do
                    task.wait(2)
                    
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then continue end

                    local map = workspace:FindFirstChild("Map")
                    if not map then continue end

                    
                    for _, puzzle in ipairs(map:GetChildren()) do
                        if not AutoSolvePuzzlesEnabled then break end
                        
                        
                        if (puzzle:IsA("Folder") or puzzle:IsA("Model")) and puzzle.Name ~= "Terrain" then
                            
                            
                            if not puzzle:FindFirstChild("SolvedByESP") then
                                
                                
                                local targetPos = puzzle:GetPivot().Position + Vector3.new(0, 5, -5)
                                hrp.CFrame = CFrame.new(targetPos)
                                task.wait(1)

                                
                                for i = 1, 10 do
                                    if not AutoSolvePuzzlesEnabled then break end
                                    
                                    for _, part in ipairs(puzzle:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            if part.Material == Enum.Material.Neon or part.Color == Color3.fromRGB(0, 255, 0) or part.Color == Color3.fromRGB(255, 0, 0) then
                                                local cd = part:FindFirstChildOfClass("ClickDetector")
                                                if cd then
                                                    fireclickdetector(cd)
                                                else
                                                    hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                                                end
                                                task.wait(0.1)
                                            end
                                        end
                                    end
                                    task.wait(0.3)
                                end
                                
                                
                                local marker = Instance.new("Folder")
                                marker.Name = "SolvedByESP"
                                marker.Parent = puzzle
                                
                                task.wait(1)
                            end
                        end
                    end
                end
            end)
        end
    end,
})


local MainTeleports = TeleportsTab:Section({ Title = "Main Locations", Icon = "map" })

MainTeleports:Button({
    Title = "Teleport to Map (Broken)",
    Icon = "", 
    Color = BTN_COLOR,
    Justify = "Center",
    Callback = function()
    
    end,
})

MainTeleports:Button({
    Title = "Teleport to Lobby",
    Icon = "", 
    Color = BTN_COLOR,
    Justify = "Center",
    Callback = function()
     if game.Players.LocalPlayer.Character and workspace:FindFirstChild("halloween2025") then
         game.Players.LocalPlayer.Character.HumanoidRootPart:PivotTo(workspace.halloween2025.Parts:GetChildren()[41]:GetPivot())
     end
    end,
})

local PlayerTeleports = TeleportsTab:Section({ Title = "Player Teleports", Icon = "users" })

PlayerTeleports:Button({
    Title = "Teleport to Random Player",
    Icon = "",
    Color = BTN_COLOR,
    Justify = "Center",
    Callback = function()
        local playersList = {}
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(playersList, p)
            end
        end
        
        if #playersList > 0 then
            local randomPlayer = playersList[math.random(1, #playersList)]
            teleportToPlayer(randomPlayer)
            WindUI:Notify({ Title = "Teleport", Content = "Teleported to " .. randomPlayer.Name, Icon = "check" })
        else
            WindUI:Notify({ Title = "Teleport", Content = "No other players found!", Icon = "x" })
        end
    end,
})

local selectedPlayer = nil
local playerDropdown = PlayerTeleports:Dropdown({
    Title = "Select Player",
    Values = {},
    Value = nil,
    AllowNone = true,
    Callback = function(option)
        selectedPlayer = option
    end,
})

task.spawn(function()
    while task.wait(2) do
        local playerNames = {}
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                table.insert(playerNames, p.Name)
            end
        end
        pcall(function()
            playerDropdown:Refresh(playerNames)
        end)
    end
end)

PlayerTeleports:Button({
    Title = "Teleport to Selected Player",
    Icon = "",
    Color = BTN_COLOR,
    Justify = "Center",
    Callback = function()
        if selectedPlayer then
            local target = game.Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                teleportToPlayer(target)
                WindUI:Notify({ Title = "Teleport", Content = "Teleported to " .. target.Name, Icon = "check" })
            else
                WindUI:Notify({ Title = "Teleport", Content = "Player not found or dead!", Icon = "x" })
            end
        else
            WindUI:Notify({ Title = "Teleport", Content = "Please select a player first!", Icon = "alert-circle" })
        end
    end,
})

local VisualSection = VisualsTab:Section({ Title = "Visual Settings", Icon = "eye" })
local WorldSection = VisualsTab:Section({ Title = "World Settings", Icon = "globe" })

local Lighting = game:GetService("Lighting")
local originalFogEnd = Lighting.FogEnd

local origBrightness = Lighting.Brightness
local origClockTime = Lighting.ClockTime
local origGlobalShadows = Lighting.GlobalShadows
local origOutdoorAmbient = Lighting.OutdoorAmbient
local origAmbient = Lighting.Ambient

WorldSection:Toggle({
    Title = "Fullbright",
    Icon = "sun",
    Value = false,
    Callback = function(state)
             if state then
            
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        else
            
            Lighting.Brightness = origBrightness
            Lighting.ClockTime = origClockTime
            Lighting.GlobalShadows = origGlobalShadows
            Lighting.OutdoorAmbient = origOutdoorAmbient
            Lighting.Ambient = origAmbient
        end
    end,
})

WorldSection:Toggle({
    Title = "No Fog",
    Icon = "cloud-off",
    Value = false,
    Callback = function(state)
     
    if state then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = originalFogEnd
    end
end,
})

WorldSection:Slider({
    Title = "Camera FOV",
    Value = { Min = 70, Max = 120, Default = 70 },
    Callback = function(value)
        local cam = workspace.CurrentCamera
        if cam then
            cam.FieldOfView = value
        end
    end,
})

local SurvivorsESPEnabled = false
local espConnectionsSurvivors = {}
local activeHighlightsSurvivors = {}

VisualSection:Toggle({
    Title = "Survivors ESP",
    Icon = "user-check",
    Value = false,
    Callback = function(state)
        SurvivorsESPEnabled = state
    
        local Teams = game:GetService("Teams")
        local SurvivorsTeam = Teams:FindFirstChild("Survivors")
        
        local function updateESP()
            if not SurvivorsESPEnabled then return end
            
            for _, v in ipairs(game.Players:GetPlayers()) do 
                if v ~= player and v.Team == SurvivorsTeam and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then 
                    if not activeHighlightsSurvivors[v.Character] then 
                        local hl = Instance.new("Highlight")
                        hl.Parent = v.Character
                        hl.FillColor = Color3.fromRGB(0, 255, 0) -- Зеленый
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.FillTransparency = 0.5
                        activeHighlightsSurvivors[v.Character] = hl
                    end 
                end 
            end
        end
 
        if state then
            table.insert(espConnectionsSurvivors, task.spawn(function()
                while SurvivorsESPEnabled do
                    updateESP()
                    task.wait(0.5)
                end 
            end))
            updateESP()
        else
            for _, conn in ipairs(espConnectionsSurvivors) do
                if type(conn) == "thread" then task.cancel(conn) end
            end
            espConnectionsSurvivors = {}
            
            for char, hl in pairs(activeHighlightsSurvivors) do 
                if hl then hl:Destroy() end 
            end     
            activeHighlightsSurvivors = {}
        end 
    end,
})

local BearESPEnabled = false
local espConnectionsBear = {}
local activeHighlightsBear = {}

VisualSection:Toggle({
    Title = "Bear ESP",
    Icon = "skull",
    Value = false,
    Callback = function(state)
        BearESPEnabled = state
    
        local Teams = game:GetService("Teams")
        local BearTeam = Teams:FindFirstChild("Bear")
        
        local function updateESP()
            if not BearESPEnabled then return end
            
            for char, hl in pairs(activeHighlightsBear) do
                if not char.Parent or not char:FindFirstChild("HumanoidRootPart") or (char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0) then
                    if hl then hl:Destroy() end
                    activeHighlightsBear[char] = nil
                end
            end
            
            for _, v in ipairs(game.Players:GetPlayers()) do 
                if v ~= player and v.Team == BearTeam and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then 
                    local hum = v.Character:FindFirstChild("Humanoid")
                    if hum and hum.Health > 0 then
                        if not activeHighlightsBear[v.Character] then 
                            local hl = Instance.new("Highlight")
                            hl.Parent = v.Character
                            hl.FillColor = Color3.fromRGB(255, 0, 0) -- Красный
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.5
                            activeHighlightsBear[v.Character] = hl
                        end 
                    end
                end 
            end
        end
 
        if state then
            table.insert(espConnectionsBear, task.spawn(function()
                while BearESPEnabled do
                    updateESP()
                    task.wait(0.5)
                end 
            end))
            updateESP()
        else
            for _, conn in ipairs(espConnectionsBear) do
                if type(conn) == "thread" then task.cancel(conn) end
            end
            espConnectionsBear = {}
            
            for char, hl in pairs(activeHighlightsBear) do 
                if hl then hl:Destroy() end 
            end     
            activeHighlightsBear = {}
        end 
    end,
})

local CandyESPEnabled = false
local espConnectionsCandy = {}
local activeHighlightsCandy = {}

VisualSection:Toggle({
    Title = "Candy ESP",
    Icon = "candy",
    Value = false,
    Callback = function(state)
        CandyESPEnabled = state
        
        local function updateESP()
            if not CandyESPEnabled then return end
            
            local map = workspace:FindFirstChild("Map")
            if not map then return end
            
            for candy, hl in pairs(activeHighlightsCandy) do
                if not candy.Parent then
                    if hl then hl:Destroy() end
                    activeHighlightsCandy[candy] = nil
                end
            end
            
            for _, obj in ipairs(map:GetDescendants()) do
                local nameLower = obj.Name:lower()
                if (nameLower:find("candy") or nameLower:find("конфета")) and (obj:IsA("BasePart") or obj:IsA("MeshPart")) then
                    if not activeHighlightsCandy[obj] then
                        local hl = Instance.new("Highlight")
                        hl.Parent = obj
                        hl.FillColor = Color3.fromRGB(255, 255, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 165, 0)
                        hl.FillTransparency = 0.5
                        activeHighlightsCandy[obj] = hl
                    end
                end
            end
        end
 
        if state then
            table.insert(espConnectionsCandy, task.spawn(function()
                while CandyESPEnabled do
                    updateESP()
                    task.wait(0.5)
                end 
            end))
            updateESP()
        else
            for _, conn in ipairs(espConnectionsCandy) do
                if type(conn) == "thread" then task.cancel(conn) end
            end
            espConnectionsCandy = {}
            for candy, hl in pairs(activeHighlightsCandy) do 
                if hl then hl:Destroy() end 
            end     
            activeHighlightsCandy = {}
        end 
    end,
})

local UiSection = Tab4:Section({ Title = "UI Settings", Icon = "monitor" })

UiSection:Slider({
    Title = "Background Transparency",
    Desc = "Adjust background image transparency",
    Value = { Min = 0, Max = 1, Default = 0 },
    Callback = function(value)
        pcall(function()
            Window:SetBackgroundImageTransparency(value)
        end)
    end,
})

UiSection:Button({
    Title = "Toggle UI (Hide/Show)",
    Icon = "eye-off",
    Color = Color3.fromHex("#3A1B8F"),
    Justify = "Center",
    Callback = function()
        Window:Close()
    end,
})

local MiscSection = Tab4:Section({ Title = "Misc Settings", Icon = "shield" })
local AntiAfkEnabled = false

MiscSection:Toggle({
    Title = "Anti AFK",
    Desc = "Keeps you in-game",
    Icon = "clock",
    Value = false,
    Callback = function(state)
        AntiAfkEnabled = state
        getgenv().AntiAFK = state
    end,
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

local LP = game:GetService("Players").LocalPlayer

local function getRoots()
    local roots = {}
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then table.insert(roots, hui) end
    end
    pcall(function() table.insert(roots, game:GetService("CoreGui")) end)
    pcall(function() table.insert(roots, LP:WaitForChild("PlayerGui", 2)) end)
    return roots
end

local function styleButton(text)
    for _, root in ipairs(getRoots()) do
        local ok, list = pcall(function() return root:GetDescendants() end)
        if ok then
            for _, d in ipairs(list) do
                if d:IsA("TextLabel") and d.Text == text then
                    d.TextColor3 = BTN_TEXT
                    local p = d.Parent
                    for _ = 1, 3 do
                        if not p then break end
                        for _, obj in ipairs(p:GetChildren()) do
                            if obj:IsA("ImageLabel") and obj.AbsoluteSize.X < 80 then
                                obj.ImageColor3 = BTN_TEXT
                            elseif obj:IsA("UIStroke") then
                                obj.Color = BTN_STROKE
                            end
                        end
                        p = p.Parent
                    end
                end
            end
        end
    end
end

task.spawn(function()
    for _ = 1, 20 do
        task.wait(0.3)
        styleButton("Copy Discord Invite")
        styleButton("Copy Telegram Link")
        styleButton("Teleport to Spawn")
        styleButton("Teleport to Lobby")
        styleButton("Teleport to Random Player")
        styleButton("Teleport to Selected Player")
    end
end)

local FpsTag = Window:Tag({ Title = "FPS: --", Icon = "gauge", Color = Color3.fromHex("#9B6BFF"), Radius = 8, TextSize = 12 })
local PingTag = Window:Tag({ Title = "Ping: --", Icon = "wifi", Color = Color3.fromHex("#9B6BFF"), Radius = 8, TextSize = 12 })

local Stats = game:GetService("Stats")
if cloneref then Stats = cloneref(Stats) end
local LocalPlayer = game:GetService("Players").LocalPlayer

local function getRenderAverage()
    local manager = Stats:FindFirstChild("FrameRateManager")
    return manager and manager:FindFirstChild("RenderAverage")
end
local function getPerfPing()
    local perf = Stats:FindFirstChild("PerformanceStats")
    return perf and perf:FindFirstChild("Ping")
end
local function getDataPing()
    local network = Stats:FindFirstChild("Network")
    local items = network and network:FindFirstChild("ServerStatsItem")
    return items and items:FindFirstChild("Data Ping")
end

local RenderAverage = getRenderAverage()
local PerfPing = getPerfPing()
local DataPing = getDataPing()

local function readValue(item)
    if not item then return nil end
    local ok, value = pcall(function() return item:GetValue() end)
    if ok and type(value) == "number" and value > 0 then return value end
    return nil
end

local function getPing()
    PerfPing = PerfPing or getPerfPing()
    local ping = readValue(PerfPing)
    if ping then return ping end
    local ok, sec = pcall(function() return LocalPlayer:GetNetworkPing() end)
    if ok and type(sec) == "number" and sec > 0 then return sec * 1000 end
    DataPing = DataPing or getDataPing()
    return readValue(DataPing)
end

local frames, lastTick = 0, os.clock()
local fallbackFps = 0
RunService.RenderStepped:Connect(function()
    frames += 1
    local now = os.clock()
    if now - lastTick >= 1 then
        fallbackFps = frames
        frames = 0
        lastTick = now
    end
end)

local function setTag(tag, text)
    if tag.SetTitle then tag:SetTitle(text) elseif tag.TextLabel then tag.TextLabel.Text = text end
end

task.spawn(function()
    while task.wait(0.5) do
        local fps = fallbackFps
        RenderAverage = RenderAverage or getRenderAverage()
        local ms = readValue(RenderAverage)
        if ms then fps = math.floor(1000 / ms) end
        setTag(FpsTag, "FPS: " .. fps)

        local ping = getPing()
        if ping then
            setTag(PingTag, "Ping: " .. math.floor(ping + 0.5))
        end
    end
end)
end

local ok, err = pcall(LoadServaHub)
if not ok then
    warn("[Serva Hub] Load error: " .. tostring(err))
end
