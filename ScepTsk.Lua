local function LoadServaHub()
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

local InfoTab = Window:Tab({ Title = "Telegram", Icon = "info" })
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
end 


local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local MainFont = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local FontBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local Atlas = "rbxassetid://122605056588923"
local Glow = "rbxassetid://8992230677"
local Logo = "rbxassetid://112491954653394"
local CloseIcon = "rbxassetid://110786993356448"

local InviteCode = "DEm4RE69gj"
local copyLink
local DiscordApi = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"
local ReqFunc = (syn and syn.request) or (http and http.request) or http_request or request

local IntroSize = 80
local LoadingTime = 3
local SquareTime = 3
local FinalW, FinalH = 500, 290


local C = {
	bg = Color3.fromRGB(12, 7, 24),
	input = Color3.fromRGB(22, 12, 44),
	card = Color3.fromRGB(26, 15, 52),
	stroke = Color3.fromRGB(88, 48, 170),
	btn2 = Color3.fromRGB(58, 27, 143),
	btn2Hover = Color3.fromRGB(90, 50, 190),
	text = Color3.fromRGB(242, 233, 255),
	muted = Color3.fromRGB(143, 122, 184),
	accent = Color3.fromRGB(155, 92, 255),
	dark = Color3.fromRGB(255, 255, 255),
	warn = Color3.fromRGB(240, 170, 60),
	online = Color3.fromRGB(67, 181, 129),
	discord = Color3.fromRGB(88, 101, 242),
	telegram = Color3.fromRGB(0, 136, 204),
}

local function make(class, props, parent)
	local i = Instance.new(class)
	for k, v in pairs(props) do i[k] = v end
	i.Parent = parent
	return i
end

local function frame(parent, x, y, w, h, color, tr)
	return make("Frame", {
		Position = UDim2.new(0, x, 0, y),
		Size = UDim2.new(0, w, 0, h),
		BackgroundColor3 = color or C.bg,
		BackgroundTransparency = tr or 1,
		BorderSizePixel = 0,
	}, parent)
end

local function txt(parent, str, x, y, w, h, sz, col, align)
	return make("TextLabel", {
		Position = UDim2.new(0, x, 0, y),
		Size = UDim2.new(0, w, 0, h),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = str,
		TextSize = sz,
		TextColor3 = col,
		TextXAlignment = align or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		FontFace = MainFont,
	}, parent)
end

local function round(parent, r, sc)
	make("UICorner", { CornerRadius = UDim.new(0, r) }, parent)
	if sc then
		make("UIStroke", { Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual, Color = sc }, parent)
	end
end

local function decor(parent, w, h, x, y, tr, rot)
	local img = make("ImageLabel", {
		Size = UDim2.new(0, w, 0, h),
		Position = UDim2.new(0, x, 0, y),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = Glow,
		ImageColor3 = Color3.fromRGB(122, 60, 255),
		ImageTransparency = tr,
		ScaleType = Enum.ScaleType.Stretch,
	}, parent)
	make("UIGradient", {
		Rotation = rot,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(181, 123, 255)),
			ColorSequenceKeypoint.new(1, C.accent),
		}),
	}, img)
	return img
end

local function centered(parent, w, h)
	return make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, w, 0, h),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, parent)
end

local function tw(inst, t, props, style, dir)
	local x = TweenService:Create(inst, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
	x:Play()
	return x
end

local function prep(container)
	local items = {}
	local function add(i)
		if i:IsA("GuiObject") then
			items[#items + 1] = { i, "BackgroundTransparency", i.BackgroundTransparency }
			if i:IsA("TextLabel") or i:IsA("TextButton") or i:IsA("TextBox") then
				items[#items + 1] = { i, "TextTransparency", i.TextTransparency }
			elseif i:IsA("ImageLabel") or i:IsA("ImageButton") then
				items[#items + 1] = { i, "ImageTransparency", i.ImageTransparency }
			end
		elseif i:IsA("UIStroke") then
			items[#items + 1] = { i, "Transparency", i.Transparency }
		end
	end
	add(container)
	for _, d in ipairs(container:GetDescendants()) do add(d) end
	return items
end

local function fade(items, alpha, time)
	for _, it in ipairs(items) do
		local inst, prop, orig = it[1], it[2], it[3]
		local target = 1 - (1 - orig) * alpha
		if time and time > 0 then
			tw(inst, time, { [prop] = target })
		else
			inst[prop] = target
		end
	end
end

local function FetchDiscordData()
	local ok, res = pcall(function()
		if not ReqFunc then error("no request func") end
		local r = ReqFunc({
			Url = DiscordApi,
			Method = "GET",
			Headers = { ["User-Agent"] = "RobloxBot/1.0", ["Accept"] = "application/json" },
		})
		if r and r.Body and #r.Body > 2 then
			return HttpService:JSONDecode(r.Body)
		end
	end)
	return ok, res
end

local function LoadServerIcon(guildId, iconHash, iconImg, iconBg, fallbackTxt)
	if not guildId or not iconHash or iconHash == "" then return end
	task.spawn(function()
		local url = "https://cdn.discordapp.com/icons/" .. tostring(guildId) .. "/" .. iconHash .. ".png?size=128"
		local fname = "servahub_dc_" .. tostring(guildId) .. ".png"
		local ok = pcall(function()
			if not ReqFunc then error("no req") end
			local r = ReqFunc({ Url = url, Method = "GET", Headers = { ["User-Agent"] = "Mozilla/5.0", ["Accept"] = "image/png" } })
			if not r or not r.Body or #r.Body < 100 then error("bad") end
			writefile(fname, r.Body)
			local asset = getcustomasset(fname)
			iconImg.Image = asset
			iconBg.BackgroundTransparency = 1
			if fallbackTxt then fallbackTxt.Visible = false end
		end)
		if not ok then
			iconBg.BackgroundTransparency = 0
			iconImg.Image = ""
			if fallbackTxt then fallbackTxt.Visible = true end
		end
	end)
end


local ready = false
local popupOpen = false
local closing = false

local root = Instance.new("ScreenGui")
root.Name = "Serva Hub | Key System"
root.Enabled = true
root.DisplayOrder = 999
root.IgnoreGuiInset = true
root.ResetOnSpawn = false
root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
root.ClipToDeviceSafeArea = true
root.Parent = PlayerGui

local main = make("Frame", {
	Size = UDim2.new(0, IntroSize, 0, IntroSize),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
}, root)

main:SetAttribute("Locked", false)

local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil
local holdToken = 0
local holdActive = false

main.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
	dragging = true
	dragStart = input.Position
	startPos = main.Position
	holdActive = true
	holdToken = holdToken + 1
	local token = holdToken
	task.delay(2, function()
		if holdActive and token == holdToken then
			main:SetAttribute("Locked", not main:GetAttribute("Locked"))
			holdActive = false
		end
	end)
	input.Changed:Connect(function()
		if input.UserInputState == Enum.UserInputState.End then
			dragging = false
			holdActive = false
		end
	end)
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging and not main:GetAttribute("Locked") then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local shadow = make("ImageLabel", {
	Size = UDim2.new(1, 50, 1, 50),
	Position = UDim2.new(0, -25, 0, -25),
	BackgroundTransparency = 1,
	Image = "rbxassetid://6014261993",
	ImageColor3 = Color3.fromRGB(0, 0, 0),
	ImageTransparency = 1,
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(49, 49, 450, 450),
}, main)

local canvas = make("Frame", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundColor3 = C.bg,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, main)
make("UICorner", { CornerRadius = UDim.new(0, 12) }, canvas)

local borderStroke = make("UIStroke", {
	Thickness = 1,
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	Color = C.accent,
	Transparency = 1,
}, canvas)

local decorGroup = make("CanvasGroup", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	GroupTransparency = 1,
}, canvas)
make("UICorner", { CornerRadius = UDim.new(0, 12) }, decorGroup)

local bgFrame = centered(decorGroup, FinalW, FinalH)
decor(bgFrame, 380, 140, 230, 266, 0.86, 270)
decor(bgFrame, 100, 46, -8, 252, 0.75, 90)
decor(bgFrame, 400, 184, 450, 8, 0.92, 90)
decor(bgFrame, 70, 138, 5, -5, 0.78, 90)

local intro = centered(canvas, FinalW, FinalH)

local introLogo = make("ImageLabel", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 58, 0, 58),
	BackgroundTransparency = 1,
	Image = Logo,
	ImageColor3 = Color3.fromRGB(255, 255, 255),
	ImageTransparency = 1,
	ScaleType = Enum.ScaleType.Fit,
}, intro)

local spinnerHolder = make("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 40),
	Size = UDim2.new(0, 36, 0, 36),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
}, intro)

local ringTrack = make("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 24, 0, 24),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
}, spinnerHolder)
make("UICorner", { CornerRadius = UDim.new(1, 0) }, ringTrack)
make("UIStroke", { Thickness = 2.5, Color = C.muted, Transparency = 0.75 }, ringTrack)

local spinner = make("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 24, 0, 24),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
}, spinnerHolder)
make("UICorner", { CornerRadius = UDim.new(1, 0) }, spinner)
local spinnerStroke = make("UIStroke", { Thickness = 2.5, Color = C.accent }, spinner)
make("UIGradient", {
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.35, 0),
		NumberSequenceKeypoint.new(0.7, 1),
		NumberSequenceKeypoint.new(1, 1),
	}),
}, spinnerStroke)

local spin = TweenService:Create(spinner, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), { Rotation = 360 })

local content = centered(canvas, FinalW, FinalH)
content.Visible = false

local left = frame(content, 0, 0, 295, FinalH)

make("ImageLabel", {
	Position = UDim2.new(0, 22, 0, 18),
	Size = UDim2.new(0, 36, 0, 36),
	BackgroundTransparency = 1,
	Image = Logo,
	ImageColor3 = Color3.fromRGB(255, 255, 255),
	ScaleType = Enum.ScaleType.Fit,
}, left)
txt(left, "Serva Hub | Official", 66, 18, 200, 22, 20, C.text)
txt(left, "Key system", 66, 40, 200, 14, 12, C.muted)
txt(left, "License key", 22, 76, 251, 14, 11, C.text)

local inputBox = frame(left, 22, 94, 251, 36, C.input, 0)
round(inputBox, 8, C.stroke)
make("ImageLabel", {
	Position = UDim2.new(0, 12, 0.5, 0),
	AnchorPoint = Vector2.new(0, 0.5),
	Size = UDim2.fromOffset(14, 14),
	BackgroundTransparency = 1,
	Image = "rbxassetid://96510194465420",
	ImageColor3 = C.muted,
}, inputBox)

local keyBox = make("TextBox", {
	Position = UDim2.new(0, 38, 0, 0),
	Size = UDim2.new(1, -48, 1, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Text = "",
	TextSize = 13,
	TextColor3 = C.text,
	TextXAlignment = Enum.TextXAlignment.Left,
	PlaceholderText = "Paste your key here",
	PlaceholderColor3 = C.muted,
	ClearTextOnFocus = false,
	MultiLine = false,
	FontFace = MainFont,
}, inputBox)

local submit = make("TextButton", {
	Position = UDim2.new(0, 22, 0, 140),
	Size = UDim2.new(0, 118, 0, 34),
	BackgroundColor3 = C.accent,
	BackgroundTransparency = 0.12,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Text = "Submit",
	TextSize = 13,
	TextColor3 = C.dark,
	FontFace = MainFont,
}, left)
round(submit, 8, C.accent)
submit.UIStroke.Transparency = 0.4
make("UIPadding", { PaddingLeft = UDim.new(0, 26) }, submit)
make("ImageLabel", {
	Position = UDim2.new(0, -14, 0.5, 0),
	AnchorPoint = Vector2.new(0, 0.5),
	Size = UDim2.fromOffset(14, 14),
	BackgroundTransparency = 1,
	Image = "rbxassetid://127751956873796",
	ImageColor3 = C.dark,
}, submit)
submit.MouseEnter:Connect(function() tw(submit, 0.15, { BackgroundTransparency = 0 }) end)
submit.MouseLeave:Connect(function() tw(submit, 0.15, { BackgroundTransparency = 0.12 }) end)

local getKey = make("TextButton", {
	Position = UDim2.new(0, 148, 0, 140),
	Size = UDim2.new(0, 125, 0, 34),
	BackgroundColor3 = C.btn2,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Text = "Get a key",
	TextSize = 13,
	TextColor3 = C.text,
	FontFace = MainFont,
}, left)
round(getKey, 8, nil)
make("UIPadding", { PaddingLeft = UDim.new(0, 26) }, getKey)
make("ImageLabel", {
	Position = UDim2.new(0, -14, 0.5, 0),
	AnchorPoint = Vector2.new(0, 0.5),
	Size = UDim2.fromOffset(14, 14),
	BackgroundTransparency = 1,
	Image = "rbxassetid://129331830773832",
	ImageColor3 = C.text,
}, getKey)
getKey.MouseEnter:Connect(function() tw(getKey, 0.15, { BackgroundColor3 = C.btn2Hover }) end)
getKey.MouseLeave:Connect(function() tw(getKey, 0.15, { BackgroundColor3 = C.btn2 }) end)

local avatar = make("ImageLabel", {
	Position = UDim2.new(0, 22, 0, 210),
	Size = UDim2.new(0, 32, 0, 32),
	BackgroundColor3 = C.input,
	BorderSizePixel = 0,
	Image = player and ("rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150") or "",
	ScaleType = Enum.ScaleType.Crop,
}, left)
round(avatar, 16, C.stroke)
txt(left, "Welcome", 62, 211, 210, 14, 11, C.muted)
local welcomeName = txt(left, ((player and player.DisplayName) or "User") .. "!", 62, 226, 210, 16, 14, C.text)
welcomeName.FontFace = FontBold
welcomeName.TextTruncate = Enum.TextTruncate.AtEnd

frame(content, 295, 18, 1, FinalH - 36, C.stroke, 0)

local rightWrapper = frame(content, 296, 0, 204, FinalH)

local rightScroll = make("ScrollingFrame", {
	Position = UDim2.new(0, 0, 0, 46),
	Size = UDim2.new(1, 0, 1, -46),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 2,
	ScrollBarImageColor3 = C.stroke,
	ScrollBarImageTransparency = 0,
	CanvasSize = UDim2.new(0, 0, 0, 480),
	ScrollingDirection = Enum.ScrollingDirection.Y,
	ElasticBehavior = Enum.ElasticBehavior.Never,
	VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
	ClipsDescendants = true,
}, rightWrapper)

local right = rightScroll

txt(right, "Detected game", 16, 8, 172, 14, 11, C.muted)

local gameCard = frame(right, 16, 26, 172, 52, C.card, 0)
round(gameCard, 8, C.stroke)

local gameImg = make("ImageLabel", {
	Position = UDim2.new(0, 9, 0, 9),
	Size = UDim2.new(0, 34, 0, 34),
	BackgroundColor3 = C.input,
	BorderSizePixel = 0,
	Image = "rbxassetid://74584987850498",
	ScaleType = Enum.ScaleType.Stretch,
}, gameCard)
round(gameImg, 7, C.stroke)

local gameName = txt(gameCard, "Loading...", 52, 10, 112, 14, 12, C.text)
gameName.TextTruncate = Enum.TextTruncate.AtEnd
local gameStatus = txt(gameCard, "Checking...", 52, 27, 112, 13, 11, C.muted)

txt(right, "Executor", 16, 90, 60, 14, 11, C.muted)
local executorLabel = txt(right, "Detecting...", 76, 90, 112, 14, 11, C.text, Enum.TextXAlignment.Right)
executorLabel.TextTruncate = Enum.TextTruncate.AtEnd

txt(right, "Status", 16, 108, 60, 14, 11, C.muted)
local statusValue = txt(right, "Key required", 76, 108, 112, 14, 11, C.warn, Enum.TextXAlignment.Right)

frame(right, 16, 128, 172, 1, C.stroke, 0)


local dcCard = frame(right, 16, 136, 172, 90, C.card, 0)
round(dcCard, 8, C.stroke)

local dcIconBg = make("Frame", {
	Position = UDim2.new(0, 10, 0, 8),
	Size = UDim2.fromOffset(40, 40),
	BackgroundColor3 = C.discord,
	BorderSizePixel = 0,
}, dcCard)
round(dcIconBg, 10, Color3.fromRGB(60, 70, 180))

local dcIconImg = make("ImageLabel", {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Image = "",
	ScaleType = Enum.ScaleType.Fit,
}, dcIconBg)
round(dcIconImg, 10, Color3.fromRGB(0, 0, 0))

local dcFallback = make("TextLabel", {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Text = "SH",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 14,
	FontFace = FontBold,
	TextXAlignment = Enum.TextXAlignment.Center,
}, dcIconBg)

local dcServerName = txt(dcCard, "Loading...", 58, 8, 110, 15, 12, C.text)
dcServerName.FontFace = FontBold
dcServerName.TextTruncate = Enum.TextTruncate.AtEnd

local dcMemberDot = make("Frame", {
	Position = UDim2.new(0, 58, 0, 28),
	Size = UDim2.fromOffset(6, 6),
	BackgroundColor3 = C.muted,
	BorderSizePixel = 0,
}, dcCard)
make("UICorner", { CornerRadius = UDim.new(1, 0) }, dcMemberDot)
local dcMemberLabel = txt(dcCard, "-- members", 68, 22, 100, 14, 10, C.muted)

local dcOnlineDot = make("Frame", {
	Position = UDim2.new(0, 58, 0, 44),
	Size = UDim2.fromOffset(6, 6),
	BackgroundColor3 = C.online,
	BorderSizePixel = 0,
}, dcCard)
make("UICorner", { CornerRadius = UDim.new(1, 0) }, dcOnlineDot)
local dcOnlineLabel = txt(dcCard, "-- online", 68, 38, 100, 14, 10, C.muted)

local dcJoinBtn = make("TextButton", {
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0, 30, 0, 60),
	Size = UDim2.fromOffset(40, 22),
	BackgroundColor3 = C.accent,
	BackgroundTransparency = 0.12,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Text = "Join",
	TextSize = 10,
	TextColor3 = C.dark,
	FontFace = FontBold,
}, dcCard)
round(dcJoinBtn, 5, C.accent)
dcJoinBtn.UIStroke.Transparency = 0.4
dcJoinBtn.MouseEnter:Connect(function() tw(dcJoinBtn, 0.12, { BackgroundTransparency = 0 }) end)
dcJoinBtn.MouseLeave:Connect(function() tw(dcJoinBtn, 0.12, { BackgroundTransparency = 0.12 }) end)
dcJoinBtn.MouseButton1Click:Connect(function()
	pcall(function() setclipboard("https://discord.gg/" .. InviteCode) end)
end)


local tgCard = frame(right, 16, 234, 172, 90, C.card, 0)
round(tgCard, 8, C.stroke)

local tgIconBg = make("Frame", {
	Position = UDim2.new(0, 10, 0, 8),
	Size = UDim2.fromOffset(40, 40),
	BackgroundColor3 = C.telegram,
	BorderSizePixel = 0,
}, tgCard)
round(tgIconBg, 10, Color3.fromRGB(0, 100, 160))

local tgIconImg = make("ImageLabel", {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Image = Logo,
	ScaleType = Enum.ScaleType.Fit,
}, tgIconBg)
round(tgIconImg, 10, Color3.fromRGB(0, 0, 0))

local tgServerName = txt(tgCard, "Serva Hub", 58, 8, 110, 15, 12, C.text)
tgServerName.FontFace = FontBold
tgServerName.TextTruncate = Enum.TextTruncate.AtEnd

local tgMemberDot = make("Frame", {
	Position = UDim2.new(0, 58, 0, 28),
	Size = UDim2.fromOffset(6, 6),
	BackgroundColor3 = C.telegram,
	BorderSizePixel = 0,
}, tgCard)
make("UICorner", { CornerRadius = UDim.new(1, 0) }, tgMemberDot)
txt(tgCard, "Official Channel", 68, 22, 100, 14, 10, C.muted)

local tgOnlineDot = make("Frame", {
	Position = UDim2.new(0, 58, 0, 44),
	Size = UDim2.fromOffset(6, 6),
	BackgroundColor3 = C.online,
	BorderSizePixel = 0,
}, tgCard)
make("UICorner", { CornerRadius = UDim.new(1, 0) }, tgOnlineDot)
txt(tgCard, "Active now", 68, 38, 100, 14, 10, C.muted)

local tgJoinBtn = make("TextButton", {
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0, 30, 0, 60),
	Size = UDim2.fromOffset(40, 22),
	BackgroundColor3 = C.telegram,
	BackgroundTransparency = 0.12,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Text = "Join",
	TextSize = 10,
	TextColor3 = C.dark,
	FontFace = FontBold,
}, tgCard)
round(tgJoinBtn, 5, C.telegram)
tgJoinBtn.UIStroke.Transparency = 0.4
tgJoinBtn.MouseEnter:Connect(function() tw(tgJoinBtn, 0.12, { BackgroundTransparency = 0 }) end)
tgJoinBtn.MouseLeave:Connect(function() tw(tgJoinBtn, 0.12, { BackgroundTransparency = 0.12 }) end)
tgJoinBtn.MouseButton1Click:Connect(function()
	pcall(function() setclipboard("https://t.me/ServaHub") end)
end)

frame(right, 16, 332, 172, 1, C.stroke, 0)

local closeBtn = make("TextButton", {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -10, 0, 10),
	Size = UDim2.new(0, 26, 0, 26),
	BackgroundColor3 = C.card,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Text = "",
	ZIndex = 5,
}, content)
make("UICorner", { CornerRadius = UDim.new(0, 7) }, closeBtn)

local closeIcon = make("ImageLabel", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 12, 0, 12),
	BackgroundTransparency = 1,
	Image = CloseIcon,
	ImageColor3 = C.muted,
	ZIndex = 6,
}, closeBtn)

local MinW, MinH, MaxW, MaxH = 340, 200, 760, 500
local resizeHandle = make("TextButton", {
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, 0, 1, 0),
	Size = UDim2.new(0, 18, 0, 18),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Text = "",
	ZIndex = 15,
}, content)

local DragR = false
local DRM = Vector2.new()
local DRS = Vector2.new()

resizeHandle.MouseButton1Down:Connect(function()
	if not ready or closing then return end
	DragR = true
	DRM = UserInputService:GetMouseLocation()
	local a = main.AbsoluteSize
	DRS = Vector2.new(a.X, a.Y)
end)
UserInputService.InputChanged:Connect(function(input)
	if not DragR then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
	local ms = UserInputService:GetMouseLocation()
	local d = ms - DRM
	main.Size = UDim2.new(0, math.clamp(DRS.X + d.X, MinW, MaxW), 0, math.clamp(DRS.Y + d.Y, MinH, MaxH))
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then DragR = false end
end)


local popup = make("Frame", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 10,
	Visible = false,
}, canvas)

local dim = make("TextButton", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 0.4,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Text = "",
}, popup)
make("UICorner", { CornerRadius = UDim.new(0, 12) }, dim)

local popupCard = make("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 270, 0, 132),
	BackgroundColor3 = C.card,
	BorderSizePixel = 0,
}, popup)
round(popupCard, 12, C.stroke)

local pbadge = frame(popupCard, 22, 20, 32, 32, C.input, 0)
round(pbadge, 16, C.stroke)
make("ImageLabel", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 12, 0, 12),
	BackgroundTransparency = 1,
	Image = CloseIcon,
	ImageColor3 = C.accent,
}, pbadge)

local popupTitle = txt(popupCard, "Close Key System?", 66, 19, 182, 16, 14, C.text)
popupTitle.FontFace = FontBold
local popupDesc = txt(popupCard, "Are you sure you want to close the Key System?", 66, 38, 182, 30, 12, C.muted)
popupDesc.TextWrapped = true
popupDesc.TextYAlignment = Enum.TextYAlignment.Top

local function popupButton(label, x, primary)
	local b = make("TextButton", {
		Position = UDim2.new(0, x, 0, 86),
		Size = UDim2.new(0, 109, 0, 32),
		BackgroundColor3 = primary and C.accent or C.btn2,
		BackgroundTransparency = primary and 0.12 or 0,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = label,
		TextSize = 13,
		TextColor3 = primary and C.dark or C.text,
		FontFace = MainFont,
	}, popupCard)
	round(b, 8, primary and C.accent or C.stroke)
	if primary then b.UIStroke.Transparency = 0.4 end
	return b
end

local cancelBtn = popupButton("Cancel", 22, false)
local confirmBtn = popupButton("Close", 139, true)

cancelBtn.MouseEnter:Connect(function() if closing or not popupOpen then return end tw(cancelBtn, 0.15, { BackgroundColor3 = C.btn2Hover }) end)
cancelBtn.MouseLeave:Connect(function() if closing or not popupOpen then return end tw(cancelBtn, 0.15, { BackgroundColor3 = C.btn2 }) end)
confirmBtn.MouseEnter:Connect(function() if closing or not popupOpen then return end tw(confirmBtn, 0.15, { BackgroundTransparency = 0 }) end)
confirmBtn.MouseLeave:Connect(function() if closing or not popupOpen then return end tw(confirmBtn, 0.15, { BackgroundTransparency = 0.12 }) end)

local spinnerItems = prep(spinnerHolder)
local contentItems = prep(content)
local popupItems = prep(popup)
fade(spinnerItems, 0)
fade(contentItems, 0)
fade(popupItems, 0)

local function detectExecutor()
	local ok, name = pcall(function()
		if identifyexecutor then return identifyexecutor()
		elseif getexecutorname then return getexecutorname() end
	end)
	return (ok and name and tostring(name) ~= "" and tostring(name)) or "Unknown"
end
executorLabel.Text = detectExecutor()

task.spawn(function()
	local ok, info = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
	end)
	gameName.Text = (ok and info and info.Name) or "Unknown game"
	if game.GameId ~= 0 then
		gameImg.Image = "rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150"
	end
	
	local SupportedGames = {
	[537413528] = true 
    }	
	if SupportedGames[game.PlaceId] then
		gameStatus.Text = "Supported"
		gameStatus.TextColor3 = C.online
	else
		gameStatus.Text = "Not in list"
		gameStatus.TextColor3 = C.muted
	end
end)

local function fmtNum(n)
	return n >= 1000 and string.format("%.1fk", n / 1000) or tostring(n)
end

local iconLoaded = false
local function refreshDiscord()
	local ok, data = FetchDiscordData()
	if ok and data and data.guild then
		local g = data.guild
		dcServerName.Text = g.name or "Unknown"
		dcFallback.Text = string.upper(string.sub(g.name or "SH", 1, 2))
		dcMemberLabel.Text = fmtNum(data.approximate_member_count or 0) .. " members"
		dcOnlineLabel.Text = fmtNum(data.approximate_presence_count or 0) .. " online"
		dcOnlineDot.BackgroundColor3 = C.online
		if not iconLoaded then
			iconLoaded = true
			LoadServerIcon(g.id, g.icon, dcIconImg, dcIconBg, dcFallback)
		end
	else
		dcServerName.Text = "Serva Hub"
		dcMemberLabel.Text = "-- members"
		dcOnlineLabel.Text = "-- online"
		dcOnlineDot.BackgroundColor3 = Color3.fromRGB(240, 71, 71)
	end
end

task.spawn(function()
	refreshDiscord()
	while task.wait(60) do
		refreshDiscord()
	end
end)


local NotifW, NotifH = 270, 58
local MaxNotifs = 4

local KindColors = {
	info = C.accent,
	success = C.online,
	warn = C.warn,
	error = Color3.fromRGB(240, 80, 80),
}

local AtlasIcons = {
	key = { Atlas, 975, 50 },
	submit = { Atlas, 200, 100 },
	link = { Atlas, 450, 500 },
	discord = { Atlas, 325, 775 },
	close = { CloseIcon },
}

local notifHolder = make("Frame", {
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -16, 1, -8),
	Size = UDim2.new(0, NotifW, 1, -16),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 20,
}, root)
make("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
}, notifHolder)

local notifCount = 0
local activeNotifs = {}

local function notify(title, message, kind, iconKey, duration)
	kind = kind or "info"
	duration = duration or 3.5
	local color = KindColors[kind] or C.accent
	local spec = AtlasIcons[iconKey] or (kind == "error" and AtlasIcons.close or AtlasIcons.key)

	notifCount += 1
	local wrapper = make("Frame", {
		LayoutOrder = notifCount,
		Size = UDim2.new(0, NotifW, 0, NotifH + 8),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, notifHolder)

	local toast = make("TextButton", {
		Position = UDim2.new(0, 40, 0, 0),
		Size = UDim2.new(0, NotifW, 0, NotifH),
		BackgroundColor3 = C.card,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
	}, wrapper)
	round(toast, 10, C.stroke)

	local nb = frame(toast, 14, 12, 30, 30, C.input, 0)
	round(nb, 15, C.stroke)
	if spec[2] then
		make("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 16, 0, 16),
			BackgroundTransparency = 1,
			Image = spec[1],
			ImageColor3 = color,
			ImageRectOffset = Vector2.new(spec[2], spec[3]),
			ImageRectSize = Vector2.new(24, 24),
		}, nb)
	else
		make("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 12, 0, 12),
			BackgroundTransparency = 1,
			Image = spec[1],
			ImageColor3 = color,
		}, nb)
	end

	local tl = txt(toast, title, 54, 9, 200, 16, 12, C.text)
	tl.FontFace = FontBold
	tl.TextTruncate = Enum.TextTruncate.AtEnd
	local ml = txt(toast, message, 54, 26, 200, 16, 11, C.muted)
	ml.TextTruncate = Enum.TextTruncate.AtEnd

	local track = frame(toast, 14, NotifH - 6, NotifW - 28, 2, C.stroke, 0)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, track)
	local bar = frame(track, 0, 0, NotifW - 28, 2, color, 0)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, bar)

	local items = prep(toast)
	fade(items, 0)

	local handle = {}
	local dismissed = false
	function handle.dismiss()
		if dismissed then return end
		dismissed = true
		local idx = table.find(activeNotifs, handle)
		if idx then table.remove(activeNotifs, idx) end
		fade(items, 0, 0.25)
		tw(toast, 0.3, { Position = UDim2.new(0, 40, 0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		task.delay(0.28, function()
			tw(wrapper, 0.2, { Size = UDim2.new(0, NotifW, 0, 0) })
			task.delay(0.22, function() wrapper:Destroy() end)
		end)
	end

	toast.MouseButton1Click:Connect(handle.dismiss)
	fade(items, 1, 0.3)
	tw(toast, 0.45, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Quint)
	tw(bar, duration, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)
	task.delay(duration, handle.dismiss)

	table.insert(activeNotifs, handle)
	while #activeNotifs > MaxNotifs do activeNotifs[1].dismiss() end
	return handle
end

local function showPopup()
	if not ready or popupOpen or closing then return end
	popupOpen = true
	popup.Visible = true
	popupCard.Position = UDim2.new(0.5, 0, 0.5, 8)
	tw(closeIcon, 0.15, { ImageColor3 = C.muted })
	tw(closeBtn, 0.15, { BackgroundTransparency = 1 })
	fade(popupItems, 1, 0.22)
	tw(popupCard, 0.35, { Position = UDim2.new(0.5, 0, 0.5, 0) }, Enum.EasingStyle.Quint)
end

local function hidePopup()
	if not popupOpen or closing then return end
	popupOpen = false
	fade(popupItems, 0, 0.18)
	task.delay(0.2, function()
		if not popupOpen then popup.Visible = false end
	end)
end

local function closeGui()
	if closing then return end
	closing = true
	ready = false
	popupOpen = false
	for i = #activeNotifs, 1, -1 do activeNotifs[i].dismiss() end
	tw(closeIcon, 0.15, { ImageColor3 = C.muted })
	tw(closeBtn, 0.15, { BackgroundTransparency = 1 })
	fade(popupItems, 0, 0.15)
	fade(contentItems, 0, 0.2)
	task.wait(0.2)
	popup.Visible = false
	content.Visible = false
	introLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
	tw(introLogo, 0.4, { ImageTransparency = 0 })
	tw(borderStroke, 0.5, { Transparency = 0.55 })
	tw(main, 0.65, { Size = UDim2.new(0, IntroSize, 0, IntroSize) }, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
	task.wait(0.7)
	tw(canvas, 0.35, { BackgroundTransparency = 1 })
	tw(decorGroup, 0.35, { GroupTransparency = 1 })
	tw(introLogo, 0.35, { ImageTransparency = 1 })
	tw(borderStroke, 0.35, { Transparency = 1 })
	tw(shadow, 0.35, { ImageTransparency = 1 })
	task.wait(0.4)
	root:Destroy()
end

closeBtn.MouseEnter:Connect(function()
	if closing or popupOpen or not ready then return end
	tw(closeIcon, 0.15, { ImageColor3 = C.text })
	tw(closeBtn, 0.15, { BackgroundTransparency = 0 })
end)
closeBtn.MouseLeave:Connect(function()
	if closing or popupOpen or not ready then return end
	tw(closeIcon, 0.15, { ImageColor3 = C.muted })
	tw(closeBtn, 0.15, { BackgroundTransparency = 1 })
end)

closeBtn.MouseButton1Click:Connect(showPopup)
cancelBtn.MouseButton1Click:Connect(hidePopup)
confirmBtn.MouseButton1Click:Connect(function() task.spawn(closeGui) end)

local Links = {
	getKey = "https://t.me/ServaHub",
	discord = "https://discord.gg/DEm4RE69gj",
}

copyLink = function(url, label, iconKey)
	if not ready or closing then return end
	local fn = setclipboard or toclipboard
	local ok = fn and pcall(fn, url)
	if ok then
		notify(label .. " copied", "The link is in your clipboard.", "success", iconKey)
	else
		notify("Couldn't copy", url, "warn", iconKey, 5)
	end
end

getKey.MouseButton1Click:Connect(function() copyLink(Links.getKey, "Key link", "link") end)


local ValidKeys = {
	["ScepTsk_Official"] = true,
}
local function validateKey(key) return ValidKeys[key] == true end

local function onKeyValid(key)
	statusValue.Text = "Key valid"
	statusValue.TextColor3 = C.online

	task.spawn(function()
		task.wait(0.4)
		task.spawn(closeGui)
		local ok, err = pcall(LoadServaHub)
		if not ok then warn("[Serva Hub] Load error: " .. tostring(err)) end
	end)
end

local checkingKey = false
submit.MouseButton1Click:Connect(function()
	if not ready or closing or checkingKey then return end
	local key = keyBox.Text:match("^%s*(.-)%s*$")
	if key == "" then
		notify("Empty key", "Paste your key in the box first.", "warn", "key")
		return
	end
	checkingKey = true
	local loading = notify("Checking key", "Please wait a moment...", "info", "submit", 30)
	task.wait(0.6)
	local ok, valid = pcall(validateKey, key)
	loading.dismiss()
	checkingKey = false
	if not ok then
		notify("Something went wrong", "Couldn't check your key. Try again.", "error")
	elseif valid then
		notify("Key accepted", "Your key is valid.", "success", "key")
		pcall(onKeyValid, key)
	else
		notify("Invalid key", "That key isn't valid. Get a new one.", "error")
	end
end)

local function snapPixel()
	local abs = root.AbsoluteSize
	main.Position = UDim2.new(0, math.floor(abs.X / 2), 0, math.floor(abs.Y / 2))
end
snapPixel()
root:GetPropertyChangedSignal("AbsoluteSize"):Connect(snapPixel)


task.spawn(function()
	main.Size = UDim2.new(0, IntroSize - 20, 0, IntroSize - 20)
	tw(main, 0.6, { Size = UDim2.new(0, IntroSize, 0, IntroSize) }, Enum.EasingStyle.Quint)
	tw(canvas, 0.5, { BackgroundTransparency = 0 })
	tw(decorGroup, 0.5, { GroupTransparency = 0 })
	tw(introLogo, 0.5, { ImageTransparency = 0 })
	tw(borderStroke, 0.5, { Transparency = 0.55 })
	tw(shadow, 0.5, { ImageTransparency = 0.6 })
	task.wait(SquareTime)
	tw(borderStroke, 0.7, { Transparency = 1 })
	tw(main, 0.85, { Size = UDim2.new(0, FinalW, 0, FinalH) }, Enum.EasingStyle.Quint)
	tw(introLogo, 0.7, { Position = UDim2.new(0.5, 0, 0.5, -20) }, Enum.EasingStyle.Quint)
	task.wait(0.35)
	spin:Play()
	fade(spinnerItems, 1, 0.4)
	task.wait(LoadingTime)
	fade(spinnerItems, 0, 0.3)
	tw(introLogo, 0.3, { ImageTransparency = 1 })
	task.wait(0.2)
	content.Visible = true
	fade(contentItems, 1, 0.45)
	task.wait(0.3)
	spin:Cancel()
	ready = true
end)
