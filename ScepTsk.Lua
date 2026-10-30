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
    .. '<font color="rgb(181,123,255)">v1</font>'

local windowAuthor = '<font color="rgb(143,122,184)">Build A Boat For Treasure</font>'

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

local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local HomeTab = Window:Tab({ Title = "Home", Icon = "house" })
local Tab3 = Window:Tab({ Title = "Player", Icon = "user" })
local FarmTab = Window:Tab({ Title = "Farm", Icon = "pickaxe" })
local Tab4 = Window:Tab({ Title = "Settings", Icon = "settings" })

local Player = game.Players.LocalPlayer
local accountAge = Player.AccountAge .. " days"
local avatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=420&h=420"

local DiscordInvite = "discord.gg/DEm4RE69gj"
local TelegramLink = "https://t.me/ServaHub"
local BTN_COLOR  = Color3.fromHex("#3A1B8F")
local BTN_TEXT   = Color3.fromHex("#E3CCFF")
local BTN_STROKE = Color3.fromHex("#9B5CFF")

local UserSection = InfoTab:Section({ Title = "User Information" })

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

local LinkSection = InfoTab:Section({ Title = "Links" })

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
    Desc = '<font color="rgb(201,166,255)">Channel Info</font>\n<font color="rgb(181,123,255)">Subscribers: 4</font>',
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

local creatorUserId = 1 
pcall(function()
    local success, id = pcall(function()
        return game:GetService("Players"):GetUserIdFromNameAsync("ScepTsk_OFFICIAL")
    end)
    if success and id then
        creatorUserId = id
    end
end)

local CreatorSection = HomeTab:Section({ Title = "Creator Info" })

local creatorNameGradient = gradient("@ScepTsk", Color3.fromRGB(201, 166, 255), Color3.fromRGB(122, 60, 255))

CreatorSection:Paragraph({
    Title = '<font color="rgb(242,233,255)">Script Creator:</font> ' .. creatorNameGradient,
    Desc = '<font color="rgb(143,122,184)">Developer</font>\n\n' ..
           '<font color="rgb(181,123,255)">Thank you for using Serva Hub!</font>\n' ..
           'If you have any questions or suggestions, feel free to contact me\n\n' ..
           '<font color="rgb(181,123,255)">If you found an error in the script, please report it to me!</font>',
    Image = "rbxthumb://type=AvatarHeadShot&id=" .. creatorUserId .. "&w=420&h=420",
    ImageSize = 70,
})

CreatorSection:Button({
    Title = "Copy Creator's Discord",
    Icon = "message-circle",
    Color = Color3.fromHex("#3A1B8F"),
    Justify = "Center",
    Callback = function()
        if setclipboard then
            setclipboard("@ScepTsk")
            WindUI:Notify({ Title = "Creator", Content = "Discord username @ScepTsk copied!", Icon = "check" })
        end
    end,
})

CreatorSection:Button({
    Title = "Copy Creator's Telegram",
    Icon = "send",
    Color = Color3.fromHex("#3A1B8F"),
    Justify = "Center",
    Callback = function()
        if setclipboard then
            setclipboard("t.me/ScepTsk")
            WindUI:Notify({ Title = "Creator", Content = "Telegram link copied!", Icon = "check" })
        end
    end,
})

local SessionSection = HomeTab:Section({ Title = "Session Stats" })
local scriptStartTime = tick()

local SessionParagraph = SessionSection:Paragraph({
    Title = 'Uptime',
    Desc = '<font color="rgb(143,122,184)">Time in Game: 00:00:00</font>\n<font color="rgb(143,122,184)">Script Uptime: 00:00:00</font>',
    Image = "rbxassetid://112491954653394",
    ImageSize = 40,
})

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local joinTime = tick() 
pcall(function()
    if Player.JoinTime then
        joinTime = Player.JoinTime
    end
end)

task.spawn(function()
    while task.wait(1) do
        local timeInGame = formatTime(tick() - joinTime)
        local uptime = formatTime(tick() - scriptStartTime)
        
        local newText = '<font color="rgb(143,122,184)">Time in Game: ' .. timeInGame .. '</font>\n' ..
                        '<font color="rgb(143,122,184)">Script Uptime: ' .. uptime .. '</font>'
        
        pcall(function()
            if SessionParagraph.SetDesc then
                SessionParagraph:SetDesc(newText)
            end
        end)

        pcall(function()
            for _, v in pairs(SessionParagraph:GetDescendants()) do
                if v:IsA("TextLabel") and v.Text:find("Time in Game") then
                    v.Text = newText
                    break
                end
            end
        end)
    end
end)

local PlayerSection = Tab3:Section({ Title = "Player Settings" })

PlayerSection:Paragraph({
    Title = 'No settings yet',
    Desc = 'Functions will be added soon.',
    Image = "rbxassetid://112491954653394",
    ImageSize = 40,
})

local FarmSection = FarmTab:Section({ Title = "Farm Settings" })

FarmSection:Paragraph({
    Title = 'No functions yet',
    Desc = 'Farm scripts will be added here.',
    Image = "rbxassetid://112491954653394",
    ImageSize = 40,
})

local UiSection = Tab4:Section({ Title = "UI Settings" })

UiSection:Slider({
    Title = "Background Transparency",
    Desc = "Adjust background image transparency",
    Value = {
        Min = 0,
        Max = 1,
        Default = 0,
    },
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
        styleButton("Copy Creator's Discord")
        styleButton("Copy Creator's Telegram")
    end
end)

local FpsTag = Window:Tag({ Title = "FPS: --", Icon = "gauge", Color = Color3.fromHex("#9B6BFF"), Radius = 8, TextSize = 12 })
local PingTag = Window:Tag({ Title = "Ping: --", Icon = "wifi", Color = Color3.fromHex("#9B6BFF"), Radius = 8, TextSize = 12 })

local Stats = game:GetService("Stats")
if cloneref then Stats = cloneref(Stats) end
local RunService = game:GetService("RunService")
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
