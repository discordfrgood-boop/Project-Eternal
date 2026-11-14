-- Project Eternal | Script Loader
-- Detects the game you are in. Supported game: its script starts on its own.
-- Any other game: a menu opens so you can pick a script and run it anyway.
 
local ETERNAL_LOGO = "rbxassetid://119192451708380"
local ETERNAL_LOGO_B64 = "" -- embedded copy removed; logo loads from the asset id above
 
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
		Key = "tsb",
		Name = "The Strongest Battlegrounds",
		Places = { 10449761463 },
		Universe = 3808081382,
		Loader = "https://api.xhider.xyz/files/v4/loaders/9404b72ec38c43ed161055d4e7d7a60d.lua",
		Listed = true,
		Tone = Color3.fromRGB(226, 96, 96),
	},
	{
		Key = "rivals",
		Name = "Rivals",
		Places = { 17625359962 },
		Universe = 6035872082,
		Loader = "https://raw.githubusercontent.com/discordfrgood-boop/Project-Eternal/refs/heads/main/rivals.luau",
		Listed = true,
		Tone = Color3.fromRGB(167, 120, 255),
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
	if #ETERNAL_LOGO_B64 == 0 then
		return nil
	end
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
