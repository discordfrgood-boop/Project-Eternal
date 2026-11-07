-- Project Eternal | Script Loader
-- Detects the game you are in. Supported game: its script starts on its own.
-- Any other game: a menu opens so you can pick a script and run it anyway.

local ETERNAL_LOGO = "rbxassetid://119192451708380"
local ETERNAL_LOGO_B64 = "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"

--------------------------------------------------------------------------
-- CATALOG: add one block per game.
-- Loader = the raw link that hosts that game's script
--          (for example a raw.githubusercontent.com link).
--------------------------------------------------------------------------
local CATALOG = {
	{
		Key = "bloxfruits",
		Name = "Blox Fruits",
		Places = { 2753915549, 4442272183, 7449423635 },
		Universe = 994732206,
		Loader = "https://api.xhider.xyz/files/v4/loaders/4bddb1b1ad45cebe21bbb51017a40a5b.lua",
		Listed = true,
		Tone = Color3.fromRGB(90, 169, 255),
	},
	{
		Key = "bloxstrike",
		Name = "BloxStrike",
		Places = { 114234929420007, 108194354348181, 135434213652028, 101836176558619 },
		Universe = 7633926880,
		Loader = "https://api.xhider.xyz/files/v4/loaders/66a1224a97310f5d357e36f486d8bf5b.lua",
		Listed = true,
		Tone = Color3.fromRGB(217, 164, 65),
	},
	{
		Key = "tsb",
		Name = "The Strongest Battlegrounds",
		Places = { 10449761463 },
		Universe = 3808081382,
		Loader = "https://api.xhider.xyz/files/v4/loaders/9404b72ec38c43ed161055d4e7d7a60d.lua",
		Listed = true,
		Tone = Color3.fromRGB(226, 96, 96),
	},
}

local TOGGLE_KEY = Enum.KeyCode.LeftControl

--------------------------------------------------------------------------
-- services / helpers
--------------------------------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

local genv = (getgenv and getgenv()) or _G

local function launch(entry)
	if type(entry.Loader) ~= "string" or entry.Loader == "" then
		return false, "no loader link set for " .. entry.Name
	end
	return pcall(function()
		return loadstring(game:HttpGet(entry.Loader), "@" .. entry.Key)()
	end)
end

local function matchPlace(placeId, universeId)
	for _, entry in ipairs(CATALOG) do
		if entry.Universe and entry.Universe == universeId then
			return entry
		end
	end
	for _, entry in ipairs(CATALOG) do
		for _, id in ipairs(entry.Places) do
			if id == placeId then
				return entry
			end
		end
	end
	return nil
end

--------------------------------------------------------------------------
-- supported game: start its script and stop here
--------------------------------------------------------------------------
local supported = matchPlace(game.PlaceId, game.GameId)
if supported then
	local ok, err = launch(supported)
	if not ok then
		warn("Project Eternal: " .. supported.Name .. " failed to start - " .. tostring(err))
	end
	return
end

--------------------------------------------------------------------------
-- unsupported game: show the menu
--------------------------------------------------------------------------
if genv.ProjectEternalLoader and genv.ProjectEternalLoader.Gui then
	pcall(function()
		genv.ProjectEternalLoader.Gui:Destroy()
	end)
end
genv.ProjectEternalLoader = {}

local C = {
	Bg = Color3.fromRGB(0, 0, 0),
	Panel = Color3.fromRGB(24, 24, 30),
	PanelHover = Color3.fromRGB(40, 40, 50),
	Stroke = Color3.fromRGB(80, 80, 98),
	Text = Color3.fromRGB(250, 250, 253),
	Dim = Color3.fromRGB(165, 165, 182),
	Green = Color3.fromRGB(74, 222, 128),
	Red = Color3.fromRGB(248, 113, 113),
	Amber = Color3.fromRGB(251, 191, 36),
}

local function mk(class, props, parent)
	local inst = Instance.new(class)
	for k, val in pairs(props) do
		inst[k] = val
	end
	if parent then
		inst.Parent = parent
	end
	return inst
end

local function round(inst, radius)
	return mk("UICorner", { CornerRadius = UDim.new(0, radius) }, inst)
end

local function outline(inst, color, thickness, transparency)
	return mk("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, inst)
end

local function tw(inst, props, time, style, dir)
	local t = TweenService:Create(inst, TweenInfo.new(time or 0.15, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	t:Play()
	return t
end

local function label(parent, str, size, font, color, pos, sz, align)
	return mk("TextLabel", {
		Text = str,
		TextSize = size,
		Font = font,
		TextColor3 = color,
		Position = pos,
		Size = sz,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = align or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	}, parent)
end

--------------------------------------------------------------------------
-- logo: embedded PNG (written once, loaded with getcustomasset), with fallbacks
--------------------------------------------------------------------------
local customLogo = nil
local function getCustomLogo()
	if customLogo ~= nil then
		return customLogo or nil
	end
	customLogo = false
	pcall(function()
		local getasset = (typeof(getcustomasset) == "function" and getcustomasset)
			or (typeof(getsynasset) == "function" and getsynasset)
		if type(writefile) ~= "function" or typeof(getasset) ~= "function" then
			return
		end

		local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
		local lookup = {}
		for i = 1, #alphabet do
			lookup[alphabet:byte(i)] = i - 1
		end
		local out = {}
		for i = 1, #ETERNAL_LOGO_B64, 4 do
			local a, b, c, d = ETERNAL_LOGO_B64:byte(i, i + 3)
			local n = lookup[a] * 262144 + lookup[b] * 4096 + (lookup[c] or 0) * 64 + (lookup[d] or 0)
			local x, y, z = n // 65536, n // 256 % 256, n % 256
			if d ~= 61 then
				out[#out + 1] = string.char(x, y, z)
			elseif c ~= 61 then
				out[#out + 1] = string.char(x, y)
			else
				out[#out + 1] = string.char(x)
			end
		end
		local png = table.concat(out)

		local folder = "ProjectEternalAssets"
		if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(folder) then
			makefolder(folder)
		end
		local path = folder .. "/ProjectEternalLogo.png"
		local fresh = type(isfile) == "function" and type(readfile) == "function" and isfile(path) and readfile(path) == png
		if not fresh then
			writefile(path, png)
		end
		local asset = getasset(path)
		if type(asset) == "string" and asset ~= "" then
			customLogo = asset
		end
	end)
	return customLogo or nil
end

local function loadLogo(img)
	local sources = {}
	local custom = getCustomLogo()
	if custom then
		sources[#sources + 1] = custom
	end
	sources[#sources + 1] = ETERNAL_LOGO
	sources[#sources + 1] = "rbxthumb://type=Asset&id=119192451708380&w=420&h=420"

	task.spawn(function()
		for _, source in ipairs(sources) do
			img.Image = source
			local t = 0
			while t < 2 and not img.IsLoaded do
				task.wait(0.1)
				t = t + 0.1
			end
			if img.IsLoaded then
				return
			end
		end

		img.Image = ""
		local mark = Instance.new("TextLabel")
		mark.Text = "PE"
		mark.Font = Enum.Font.GothamBlack
		mark.TextScaled = true
		mark.TextColor3 = Color3.fromRGB(255, 255, 255)
		mark.BackgroundTransparency = 1
		mark.Size = img.Size
		mark.Position = img.Position
		mark.Parent = img.Parent
	end)
	return img
end

--------------------------------------------------------------------------
-- gui
--------------------------------------------------------------------------
local uiParent = nil
pcall(function()
	if gethui then
		uiParent = gethui()
	end
end)
if not uiParent then
	pcall(function()
		uiParent = game:GetService("CoreGui")
	end)
end
if not uiParent then
	uiParent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local gui = mk("ScreenGui", {
	Name = "ProjectEternalLoader",
	ResetOnSpawn = false,
	DisplayOrder = 999,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, uiParent)
genv.ProjectEternalLoader.Gui = gui

local WIN_W, WIN_H = 480, 532

local win = mk("CanvasGroup", {
	Name = "Window",
	Size = UDim2.fromOffset(WIN_W, WIN_H),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = C.Bg,
	BorderSizePixel = 0,
	Active = true,
	GroupTransparency = 1,
}, gui)
round(win, 18)
local uiScale = mk("UIScale", { Scale = 1 }, win)

local winBorder = mk("Frame", {
	Size = UDim2.new(1, -2, 1, -2),
	Position = UDim2.fromOffset(1, 1),
	BackgroundTransparency = 1,
	ZIndex = 50,
}, win)
round(winBorder, 17)
outline(winBorder, C.Stroke, 1, 0)

-- title bar
local titleBar = mk("Frame", {
	Size = UDim2.new(1, 0, 0, 64),
	BackgroundTransparency = 1,
}, win)

local logoTile = mk("Frame", {
	Size = UDim2.fromOffset(46, 46),
	Position = UDim2.fromOffset(14, 9),
	BackgroundColor3 = Color3.fromRGB(10, 10, 12),
	BorderSizePixel = 0,
}, titleBar)
round(logoTile, 12)
outline(logoTile, C.Stroke, 1, 0)
local logoImg = loadLogo(mk("ImageLabel", {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	ScaleType = Enum.ScaleType.Fit,
}, logoTile))
round(logoImg, 12)

label(titleBar, "Project Eternal", 17, Enum.Font.GothamBold, C.Text, UDim2.fromOffset(68, 13), UDim2.new(1, -90, 0, 20))
label(titleBar, "Script Loader", 11, Enum.Font.Gotham, C.Dim, UDim2.fromOffset(68, 33), UDim2.new(1, -90, 0, 14))

mk("Frame", {
	Size = UDim2.new(1, -32, 0, 1),
	Position = UDim2.fromOffset(16, 64),
	BackgroundColor3 = C.Stroke,
	BorderSizePixel = 0,
}, win)

-- notice card
local placeName = "this game"
pcall(function()
	local info = MarketplaceService:GetProductInfo(game.PlaceId)
	if info and info.Name then
		placeName = info.Name
	end
end)

local notice = mk("Frame", {
	Position = UDim2.fromOffset(16, 78),
	Size = UDim2.fromOffset(448, 66),
	BackgroundColor3 = C.Panel,
	BorderSizePixel = 0,
}, win)
round(notice, 12)
outline(notice, C.Stroke, 1, 0)
local noticeDot = mk("Frame", {
	Size = UDim2.fromOffset(8, 8),
	Position = UDim2.fromOffset(16, 14),
	BackgroundColor3 = C.Amber,
	BorderSizePixel = 0,
}, notice)
round(noticeDot, 4)
label(notice, "Unsupported game", 12, Enum.Font.GothamBold, C.Amber, UDim2.fromOffset(32, 8), UDim2.new(1, -48, 0, 20))
local noticeText = label(notice, "No script for " .. placeName .. ". Pick one below to run it anyway.", 11, Enum.Font.Gotham, C.Dim, UDim2.fromOffset(16, 30), UDim2.new(1, -32, 0, 28))
noticeText.TextWrapped = true
noticeText.TextYAlignment = Enum.TextYAlignment.Top

-- script list
label(win, "AVAILABLE SCRIPTS", 10, Enum.Font.GothamMedium, C.Dim, UDim2.fromOffset(18, 156), UDim2.fromOffset(200, 14))

local listFrame = mk("ScrollingFrame", {
	Position = UDim2.fromOffset(16, 176),
	Size = UDim2.fromOffset(448, 286),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = C.Dim,
	CanvasSize = UDim2.fromOffset(0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y,
}, win)
mk("UIGridLayout", {
	CellSize = UDim2.new(0.5, -6, 0, 114),
	CellPadding = UDim2.fromOffset(12, 12),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, listFrame)
mk("UIPadding", { PaddingRight = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4) }, listFrame)

-- toasts
local toasts = mk("Frame", {
	Name = "Toasts",
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -16, 0, 16),
	Size = UDim2.fromOffset(300, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
	ZIndex = 100,
}, gui)
mk("UIListLayout", {
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
}, toasts)

local toastOrder = 0
local function notify(description, tone, duration)
	toastOrder = toastOrder + 1
	local toast = mk("Frame", {
		LayoutOrder = toastOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = C.Panel,
		BorderSizePixel = 0,
		ZIndex = 100,
	}, toasts)
	round(toast, 10)
	outline(toast, tone or C.Stroke, 1, 0)
	mk("UIPadding", {
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 14),
	}, toast)
	mk("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, toast)

	local title = mk("TextLabel", {
		LayoutOrder = 1,
		Text = "Project Eternal",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = tone or C.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 16),
		ZIndex = 100,
	}, toast)
	local body = mk("TextLabel", {
		LayoutOrder = 2,
		Text = description,
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = C.Dim,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 100,
	}, toast)

	task.delay(duration or 6, function()
		if toast.Parent then
			tw(toast, { BackgroundTransparency = 1 }, 0.25)
			tw(title, { TextTransparency = 1 }, 0.25)
			tw(body, { TextTransparency = 1 }, 0.25)
			task.wait(0.3)
			toast:Destroy()
		end
	end)
end

-- running a script (reports back if it fails or hangs)
local function start(entry)
	notify("Starting " .. entry.Name, C.Text, 5)
	task.spawn(function()
		local finished, ok, err = false, nil, nil
		task.spawn(function()
			ok, err = launch(entry)
			finished = true
		end)
		local waited = 0
		while not finished and waited < 6 do
			task.wait(0.25)
			waited = waited + 0.25
		end
		if not finished then
			notify(entry.Name .. " is still loading (stuck waiting for its own game data?)", C.Amber, 10)
		elseif not ok then
			notify(entry.Name .. " failed: " .. tostring(err), C.Red, 10)
		else
			notify(entry.Name .. " started", C.Green, 8)
		end
	end)
end

-- cards
local order = 0
for _, entry in ipairs(CATALOG) do
	if entry.Listed then
		order = order + 1
		local card = mk("Frame", {
			LayoutOrder = order,
			BackgroundColor3 = C.Panel,
			BorderSizePixel = 0,
		}, listFrame)
		round(card, 12)
		outline(card, C.Stroke, 1, 0)

		local icon = mk("ImageLabel", {
			Image = string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", entry.Universe),
			Size = UDim2.fromOffset(40, 40),
			Position = UDim2.fromOffset(12, 12),
			BackgroundColor3 = C.PanelHover,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Crop,
		}, card)
		round(icon, 10)

		local nameLabel = label(card, entry.Name, 13, Enum.Font.GothamBold, C.Text, UDim2.fromOffset(60, 12), UDim2.new(1, -70, 0, 20))
		nameLabel.TextScaled = true
		mk("UITextSizeConstraint", { MaxTextSize = 13, MinTextSize = 8 }, nameLabel)

		local dot = mk("Frame", {
			Size = UDim2.fromOffset(6, 6),
			Position = UDim2.fromOffset(62, 39),
			BackgroundColor3 = entry.Tone,
			BorderSizePixel = 0,
		}, card)
		round(dot, 3)
		label(card, "Place " .. tostring(entry.Places[1]), 10, Enum.Font.Gotham, C.Dim, UDim2.fromOffset(74, 33), UDim2.new(1, -84, 0, 16))

		local run = mk("TextButton", {
			Text = "Run",
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			TextColor3 = Color3.fromRGB(8, 8, 10),
			BackgroundColor3 = entry.Tone,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Size = UDim2.new(1, -24, 0, 32),
			Position = UDim2.new(0, 12, 1, -44),
		}, card)
		round(run, 10)

		run.MouseEnter:Connect(function()
			tw(run, { BackgroundTransparency = 0.15 })
		end)
		run.MouseLeave:Connect(function()
			tw(run, { BackgroundTransparency = 0 })
		end)

		local last = 0
		run.MouseButton1Click:Connect(function()
			if os.clock() - last < 0.5 then
				return
			end
			last = os.clock()
			start(entry)
		end)
	end
end

-- close button
local closeBtn = mk("TextButton", {
	Text = "Close menu",
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	TextColor3 = C.Text,
	BackgroundColor3 = C.Panel,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Size = UDim2.fromOffset(448, 42),
	Position = UDim2.fromOffset(16, 474),
}, win)
round(closeBtn, 12)
outline(closeBtn, C.Stroke, 1, 0)
closeBtn.MouseEnter:Connect(function()
	tw(closeBtn, { BackgroundColor3 = C.PanelHover })
end)
closeBtn.MouseLeave:Connect(function()
	tw(closeBtn, { BackgroundColor3 = C.Panel })
end)
closeBtn.MouseButton1Click:Connect(function()
	pcall(function()
		gui:Destroy()
	end)
	genv.ProjectEternalLoader = nil
end)

-- dragging (mouse + touch)
do
	local dragging, dragStart, startPos = false, nil, nil
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = win.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			local s = uiScale.Scale
			win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X / s, startPos.Y.Scale, startPos.Y.Offset + delta.Y / s)
		end
	end)
end

-- show / hide with the toggle key
local shown = true
UserInputService.InputBegan:Connect(function(input, processed)
	if processed or input.KeyCode ~= TOGGLE_KEY or not gui.Parent then
		return
	end
	shown = not shown
	if shown then
		win.Visible = true
		tw(win, { GroupTransparency = 0 }, 0.2)
	else
		tw(win, { GroupTransparency = 1 }, 0.2)
		task.delay(0.2, function()
			if not shown then
				win.Visible = false
			end
		end)
	end
end)

-- responsive scale (bigger in portrait)
local fitScale = 1
local function refit()
	local cam = workspace.CurrentCamera
	if not cam then
		return
	end
	local vp = cam.ViewportSize
	local portrait = vp.Y > vp.X
	local fillX = portrait and 0.97 or 0.9
	local fillY = portrait and 0.94 or 0.9
	fitScale = math.min(vp.X * fillX / WIN_W, vp.Y * fillY / WIN_H, 1)
	uiScale.Scale = fitScale
end
refit()
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refit)
end

-- intro
uiScale.Scale = fitScale * 0.94
tw(win, { GroupTransparency = 0 }, 0.35)
tw(uiScale, { Scale = fitScale }, 0.5, Enum.EasingStyle.Back)

notify("No script for " .. placeName .. ". Pick one to run it anyway.", C.Amber, 8)
