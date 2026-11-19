local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

local Library = {
	Version = "1.0.0",
	Flags = {},
	Options = {},
	Windows = {},
	Theme = {},
	ThemeName = "Sportsclub",
	CustomAccent = nil,
	Connections = {},
	IconProvider = {
		DefaultIconPack = "Lucide",
		IconSources = {
			Material = "https://raw.githubusercontent.com/Skinny-yz/NullUI-Assets/main/icons/MaterialIcons.luau",
			Lucide = "https://raw.githubusercontent.com/Skinny-yz/NullUI-Assets/main/icons/LucideIcons.luau",
			Phosphor = "https://raw.githubusercontent.com/Skinny-yz/NullUI-Assets/main/icons/Phosphor.luau",
			["Phosphor-Filled"] = "https://raw.githubusercontent.com/Skinny-yz/NullUI-Assets/main/icons/Phosphor%20Filled.luau",
			SF = "https://raw.githubusercontent.com/Skinny-yz/NullUI-Assets/main/icons/SFSymbols.luau",
		},
	},
}

local Theme = Library.Theme
local SIDE_W, ICON_W, ITEM_H = 168, 50, 28
local WHITE, BLACK = Color3.new(1, 1, 1), Color3.new(0, 0, 0)
local RAD = { Window = 4, Card = 3, Item = 3, Input = 3, Button = 3, Chip = 3, Popup = 4, Knob = 2, Mini = 2 }
Library.Radius = RAD

local function rgb(r, g, b)
	return Color3.fromRGB(r, g, b)
end

local function makeTheme(bg, panel, head, item, input, stroke, line, accent, text, sub, muted, track, knob, tOff, tKnob)
	return {
		Background = bg, Panel = panel, PanelHeader = head, Item = item, Input = input,
		Stroke = stroke, Line = line, Accent = accent, Text = text, SubText = sub, Muted = muted,
		Track = track, Knob = knob, ToggleOff = tOff, ToggleKnob = tKnob,
		Success = rgb(52, 199, 89), Warning = rgb(255, 204, 0), Danger = rgb(255, 69, 58),
	}
end

local lightText, lightSub, lightMuted = rgb(242, 242, 245), rgb(190, 190, 196), rgb(142, 142, 148)

Library.ThemeOrder = { "Sportsclub", "Midnight", "Amoled", "Ocean", "Rose", "Emerald", "Violet", "Light" }
Library.Themes = {
	Sportsclub = makeTheme(rgb(10, 10, 12), rgb(15, 15, 17), rgb(22, 22, 25), rgb(22, 22, 25), rgb(18, 18, 20), rgb(38, 38, 42), rgb(24, 24, 27), rgb(10, 132, 255), lightText, lightSub, lightMuted, rgb(28, 28, 31), rgb(60, 60, 64), rgb(44, 44, 48), rgb(118, 118, 124)),
	Midnight = makeTheme(rgb(8, 10, 18), rgb(12, 15, 26), rgb(18, 22, 38), rgb(18, 22, 38), rgb(14, 18, 32), rgb(36, 44, 72), rgb(22, 28, 46), rgb(99, 102, 241), lightText, lightSub, rgb(130, 138, 166), rgb(24, 30, 50), rgb(54, 62, 96), rgb(38, 46, 74), rgb(112, 122, 156)),
	Amoled = makeTheme(rgb(0, 0, 0), rgb(8, 8, 8), rgb(16, 16, 16), rgb(16, 16, 16), rgb(12, 12, 12), rgb(34, 34, 34), rgb(20, 20, 20), rgb(10, 132, 255), lightText, lightSub, lightMuted, rgb(24, 24, 24), rgb(56, 56, 56), rgb(40, 40, 40), rgb(112, 112, 112)),
	Ocean = makeTheme(rgb(7, 14, 20), rgb(10, 20, 29), rgb(15, 29, 41), rgb(15, 29, 41), rgb(12, 24, 34), rgb(30, 54, 72), rgb(18, 34, 46), rgb(0, 200, 220), lightText, lightSub, rgb(128, 152, 166), rgb(20, 38, 52), rgb(50, 78, 98), rgb(34, 56, 72), rgb(110, 138, 154)),
	Rose = makeTheme(rgb(14, 9, 11), rgb(21, 14, 17), rgb(30, 20, 24), rgb(30, 20, 24), rgb(25, 16, 20), rgb(58, 36, 44), rgb(36, 24, 29), rgb(255, 69, 110), lightText, lightSub, rgb(160, 138, 146), rgb(38, 26, 31), rgb(78, 54, 62), rgb(56, 38, 45), rgb(140, 116, 124)),
	Emerald = makeTheme(rgb(8, 13, 11), rgb(12, 20, 17), rgb(18, 29, 24), rgb(18, 29, 24), rgb(14, 24, 20), rgb(34, 56, 46), rgb(22, 36, 30), rgb(46, 204, 113), lightText, lightSub, rgb(132, 156, 144), rgb(22, 38, 31), rgb(52, 82, 68), rgb(36, 58, 48), rgb(112, 140, 126)),
	Violet = makeTheme(rgb(11, 9, 15), rgb(17, 14, 24), rgb(25, 20, 36), rgb(25, 20, 36), rgb(20, 16, 29), rgb(48, 38, 72), rgb(30, 24, 44), rgb(168, 85, 247), lightText, lightSub, rgb(148, 138, 170), rgb(32, 26, 46), rgb(68, 56, 98), rgb(46, 38, 66), rgb(128, 116, 156)),
	Light = makeTheme(rgb(244, 244, 247), rgb(255, 255, 255), rgb(240, 240, 244), rgb(232, 232, 238), rgb(246, 246, 249), rgb(214, 214, 222), rgb(225, 225, 231), rgb(10, 132, 255), rgb(20, 20, 24), rgb(70, 70, 78), rgb(120, 120, 128), rgb(222, 222, 228), rgb(255, 255, 255), rgb(200, 200, 208), rgb(255, 255, 255)),
}

for k, v in pairs(Library.Themes.Sportsclub) do
	Theme[k] = v
end

local themeRefs, themeFns, spinners = {}, {}, {}

local function bind(o, p, k)
	o[p] = Theme[k]
	themeRefs[#themeRefs + 1] = { o, p, k }
end

local function onTheme(fn)
	fn()
	themeFns[#themeFns + 1] = fn
end

local function refreshTheme()
	for i = #themeRefs, 1, -1 do
		local r = themeRefs[i]
		if not r[1]:IsDescendantOf(game) then
			table.remove(themeRefs, i)
		else
			TweenService:Create(r[1], TweenInfo.new(0.25), { [r[2]] = Theme[r[3]] }):Play()
		end
	end
	for _, fn in ipairs(themeFns) do
		pcall(fn)
	end
end

local function tween(o, t, props, style, dir)
	local tw = TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local function apply(o, props, anim)
	if anim then
		tween(o, 0.15, props)
	else
		for k, v in pairs(props) do
			o[k] = v
		end
	end
end

local function new(class, props, _)
	local inst = Instance.new(class)
	local isText = class == "TextLabel" or class == "TextButton" or class == "TextBox"
	if isText then
		inst.BackgroundTransparency = 1
		inst.Font = Enum.Font.GothamMedium
		inst.TextSize = 12
		inst.TextXAlignment = Enum.TextXAlignment.Left
		inst.Text = ""
	end
	if class == "TextButton" or class == "ImageButton" then
		inst.AutoButtonColor = false
	end
	if class == "ImageLabel" or class == "ImageButton" or class == "ScrollingFrame" or class == "CanvasGroup" then
		inst.BackgroundTransparency = 1
	end
	if inst:IsA("GuiObject") then
		inst.BorderSizePixel = 0
	end
	local parent, binds
	props = props or {}
	for k, v in pairs(props) do
		if k == "Parent" then
			parent = v
		elseif k == "Bind" then
			binds = v
		else
			inst[k] = v
		end
	end
	if binds then
		for p, key in pairs(binds) do
			bind(inst, p, key)
		end
	end
	if isText and not props.TextColor3 and not (binds and binds.TextColor3) then
		bind(inst, "TextColor3", "Text")
	end
	if class == "TextBox" and not props.PlaceholderColor3 then
		bind(inst, "PlaceholderColor3", "Muted")
	end
	inst.Parent = parent
	return inst
end

local function corner(o, r)
	return new("UICorner", { CornerRadius = UDim.new(0, r), Parent = o })
end

local function stroke(o, key, th, tr)
	local props = { Thickness = th or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = o }
	if key == false then
		props.Color = Theme.Stroke
	else
		props.Bind = { Color = key or "Stroke" }
	end
	return new("UIStroke", props)
end

local function pad(o, l, t, r, b)
	return new("UIPadding", {
		PaddingLeft = UDim.new(0, l), PaddingTop = UDim.new(0, t or l),
		PaddingRight = UDim.new(0, r or l), PaddingBottom = UDim.new(0, b or t or l), Parent = o,
	})
end

local function vlist(o, gap, ha)
	return new("UIListLayout", { Padding = UDim.new(0, gap or 0), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = ha or Enum.HorizontalAlignment.Left, Parent = o })
end

local function hlist(o, gap, va)
	return new("UIListLayout", { Padding = UDim.new(0, gap or 0), FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = va or Enum.VerticalAlignment.Center, Parent = o })
end

local function fmt(n, dec)
	local s = string.format("%." .. (dec or 3) .. "f", n)
	if string.find(s, "%.") then
		s = string.gsub(s, "0+$", "")
		s = string.gsub(s, "%.$", "")
	end
	return s
end

local function assetUrl(v)
	if type(v) == "number" or (type(v) == "string" and string.match(v, "^%d+$")) then
		return "rbxassetid://" .. tostring(v)
	end
	return v
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function drag(obj, onStart, onMove, onEnd)
	obj.InputBegan:Connect(function(input)
		if not isPress(input) then
			return
		end
		local t = input.UserInputType
		local p = Vector2.new(input.Position.X, input.Position.Y)
		if onStart and onStart(p) == false then
			return
		end
		local sf = obj:FindFirstAncestorWhichIsA("ScrollingFrame")
		local was = sf and sf.ScrollingEnabled
		if sf then
			sf.ScrollingEnabled = false
		end
		local move, stop
		move = UserInputService.InputChanged:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseMovement or (t == Enum.UserInputType.Touch and i.UserInputType == Enum.UserInputType.Touch) then
				onMove(Vector2.new(i.Position.X, i.Position.Y))
			end
		end)
		stop = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				move:Disconnect()
				stop:Disconnect()
				if sf then
					sf.ScrollingEnabled = was
				end
				if onEnd then
					onEnd()
				end
			end
		end)
	end)
end

local iconCache, iconWaiting, iconLoading = {}, {}, {}

local function loadPack(pack)
	if iconCache[pack] or iconLoading[pack] then
		return
	end
	iconLoading[pack] = true
	task.spawn(function()
		local url = Library.IconProvider.IconSources[pack]
		local ok, data = pcall(function()
			local body
			local got = pcall(function()
				body = game:HttpGet(url)
			end)
			if not got or not body then
				body = HttpService:GetAsync(url)
			end
			return (loadstring or load)(body)()
		end)
		iconLoading[pack] = nil
		if ok and type(data) == "table" then
			iconCache[pack] = data
			for _, w in ipairs(iconWaiting[pack] or {}) do
				local id = data[w[2]]
				if id and w[1].Parent then
					w[1].Image = "rbxassetid://" .. tostring(id)
				end
			end
			iconWaiting[pack] = nil
		end
	end)
end

local function setIcon(img, name)
	if not name or name == "" then
		img.Image = ""
		return
	end
	if type(name) == "number" or string.find(name, "^rbxasset") or string.find(name, "^https?:") then
		img.Image = assetUrl(name)
		return
	end
	local pack, key = string.match(name, "^([%w%-]+):(.+)$")
	if not pack or not Library.IconProvider.IconSources[pack] then
		pack, key = Library.IconProvider.DefaultIconPack, name
	end
	local data = iconCache[pack]
	if data then
		local id = data[key]
		if id then
			img.Image = "rbxassetid://" .. tostring(id)
		end
	else
		iconWaiting[pack] = iconWaiting[pack] or {}
		table.insert(iconWaiting[pack], { img, key })
		loadPack(pack)
	end
end

local function icon(parent, name, size, key)
	local img = new("ImageLabel", { Name = "Icon", Size = UDim2.fromOffset(size, size), ScaleType = Enum.ScaleType.Fit, Bind = key ~= false and { ImageColor3 = key or "Muted" } or nil, Parent = parent })
	setIcon(img, name)
	return img
end

local function spinner(parent, size, thick)
	local f = new("Frame", { Name = "Spinner", Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, Parent = parent })
	corner(f, size)
	local st = stroke(f, "Accent", thick or 2)
	local g = new("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6, 0.15),
			NumberSequenceKeypoint.new(0.601, 1), NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = st,
	})
	spinners[#spinners + 1] = g
	return f
end

local function flash(frame)
	local ov = new("Frame", { Name = "Highlight", Position = UDim2.fromOffset(-5, -3), Size = UDim2.new(1, 10, 1, 6), BackgroundTransparency = 0.8, ZIndex = 5, Bind = { BackgroundColor3 = "Accent" }, Parent = frame })
	corner(ov, RAD.Item)
	task.spawn(function()
		for _ = 1, 3 do
			tween(ov, 0.35, { BackgroundTransparency = 0.95 }).Completed:Wait()
			tween(ov, 0.35, { BackgroundTransparency = 0.7 }).Completed:Wait()
		end
		tween(ov, 0.3, { BackgroundTransparency = 1 }).Completed:Wait()
		ov:Destroy()
	end)
end

local tipStamp, tipFollow = 0, false

local function ensureGui()
	if Library.Gui and Library.Gui.Parent then
		return Library.Gui
	end
	local gui = Instance.new("ScreenGui")
	gui.Name = "SCUI_" .. string.sub(HttpService:GenerateGUID(false), 1, 8)
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 999
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(gui)
		end
	end)
	local parent
	if gethui then
		local ok, r = pcall(gethui)
		if ok then
			parent = r
		end
	end
	local ok = pcall(function()
		gui.Parent = parent or CoreGui
	end)
	if not ok or not gui.Parent then
		gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end
	Library.Gui = gui

	Library.ToastHolder = new("Frame", { Name = "Toasts", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -14, 1, -14), Size = UDim2.fromOffset(232, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 50, Parent = gui })
	new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Parent = Library.ToastHolder })

	local tip = new("Frame", { Name = "Tooltip", AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 0), Visible = false, ZIndex = 100, Bind = { BackgroundColor3 = "Panel" }, Parent = gui })
	corner(tip, RAD.Input)
	stroke(tip, "Stroke")
	pad(tip, 7, 5)
	Library.Tip = tip
	Library.TipLabel = new("TextLabel", { AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 0), TextWrapped = true, TextSize = 11, Bind = { TextColor3 = "SubText" }, Parent = tip })
	new("UISizeConstraint", { MaxSize = Vector2.new(220, 1000), Parent = Library.TipLabel })

	table.insert(Library.Connections, RunService.RenderStepped:Connect(function()
		local rot = (os.clock() * 360) % 360
		for i = #spinners, 1, -1 do
			local g = spinners[i]
			if g:IsDescendantOf(game) then
				g.Rotation = rot
			else
				table.remove(spinners, i)
			end
		end
		if tipFollow and tip.Visible then
			local m = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
			local vp = gui.AbsoluteSize
			local s = tip.AbsoluteSize
			tip.Position = UDim2.fromOffset(math.clamp(m.X + 12, 4, math.max(4, vp.X - s.X - 4)), math.clamp(m.Y + 16, 4, math.max(4, vp.Y - s.Y - 4)))
		end
	end))
	return gui
end

local function showTip(text, at, follow)
	if not text or text == "" or not Library.Tip then
		return
	end
	tipStamp += 1
	Library.TipLabel.Text = text
	Library.Tip.Visible = true
	tipFollow = follow
	if at then
		local vp = Library.Gui.AbsoluteSize
		local s = Library.Tip.AbsoluteSize
		Library.Tip.Position = UDim2.fromOffset(math.clamp(at.X, 4, math.max(4, vp.X - s.X - 4)), math.clamp(at.Y + 6, 4, math.max(4, vp.Y - s.Y - 4)))
	end
	return tipStamp
end

local function hideTip()
	tipFollow = false
	if Library.Tip then
		Library.Tip.Visible = false
	end
end

local function attachTip(obj, getText)
	local token = 0
	obj.MouseEnter:Connect(function()
		token += 1
		local t = token
		task.delay(0.45, function()
			if t == token then
				showTip(getText(), nil, true)
			end
		end)
	end)
	obj.MouseLeave:Connect(function()
		token += 1
		hideTip()
	end)
	obj.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		token += 1
		local t = token
		task.delay(0.5, function()
			if t ~= token then
				return
			end
			local text = getText()
			if text then
				local p = obj.AbsolutePosition
				local stamp = showTip(text, Vector2.new(p.X, p.Y + obj.AbsoluteSize.Y), false)
				task.delay(2.5, function()
					if tipStamp == stamp then
						hideTip()
					end
				end)
			end
		end)
	end)
	obj.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			token += 1
		end
	end)
end

local toastList = {}
local toastSeq = 0

function Library:Notify(opts)
	opts = opts or {}
	ensureGui()
	local kind = opts.Type or "Info"
	local colorKey = ({ Info = "Accent", Success = "Success", Warning = "Warning", Error = "Danger" })[kind] or "Accent"
	local iconName = opts.Icon or ({ Info = "info", Success = "circle-check", Warning = "triangle-alert", Error = "circle-x" })[kind]
	local dur = opts.Duration or 4
	toastSeq += 1
	local wrap = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = toastSeq, Parent = Library.ToastHolder })
	local card = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(1, 40, 0, 0), ClipsDescendants = true, Bind = { BackgroundColor3 = "Panel" }, Parent = wrap })
	corner(card, RAD.Popup)
	stroke(card, "Stroke")
	new("Frame", { Name = "Bar", Size = UDim2.new(0, 3, 1, 0), Bind = { BackgroundColor3 = colorKey }, Parent = card })
	local prog = new("Frame", { Name = "Progress", Position = UDim2.new(0, 0, 1, -2), Size = UDim2.new(1, 0, 0, 2), BackgroundTransparency = 0.4, Bind = { BackgroundColor3 = colorKey }, Parent = card })
	local inner = new("Frame", { Name = "Inner", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = card })
	pad(inner, 14, 9, 10, 11)
	vlist(inner, 3)
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, LayoutOrder = 1, Parent = inner })
	local ic = icon(row, iconName, 12, colorKey)
	ic.Position = UDim2.fromOffset(0, 1)
	new("TextLabel", { Position = UDim2.fromOffset(18, 0), Size = UDim2.new(1, -18, 1, 0), Text = opts.Title or kind, Font = Enum.Font.GothamBold, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row })
	if opts.Content and opts.Content ~= "" then
		new("TextLabel", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = opts.Content, TextSize = 11, TextWrapped = true, LayoutOrder = 2, Bind = { TextColor3 = "Muted" }, Parent = inner })
	end
	local dead = false
	local function dismiss()
		if dead then
			return
		end
		dead = true
		tween(card, 0.25, { Position = UDim2.new(1, 40, 0, 0) })
		task.delay(0.27, function()
			wrap:Destroy()
		end)
	end
	table.insert(toastList, dismiss)
	if #toastList > 5 then
		table.remove(toastList, 1)()
	end
	tween(card, 0.3, { Position = UDim2.fromOffset(0, 0) })
	tween(prog, dur, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)
	task.delay(dur, dismiss)
	card.InputBegan:Connect(function(i)
		if isPress(i) then
			dismiss()
		end
	end)
	return { Dismiss = dismiss }
end

function Library:SetTheme(name)
	local src = Library.Themes[name]
	if not src then
		return false
	end
	Library.ThemeName = name
	Library.CustomAccent = nil
	for k, v in pairs(src) do
		Theme[k] = v
	end
	refreshTheme()
	return true
end

function Library:SetAccent(color)
	Library.CustomAccent = color
	Theme.Accent = color
	refreshTheme()
end

function Library:AddTheme(name, tbl)
	local base = {}
	for k, v in pairs(Library.Themes.Sportsclub) do
		base[k] = tbl[k] or v
	end
	Library.Themes[name] = base
	table.insert(Library.ThemeOrder, name)
end

local Window, Tab, SubTab, Section, Element = {}, {}, {}, {}, {}
Window.__index = Window
Tab.__index = Tab
SubTab.__index = SubTab
Section.__index = Section
Element.__index = Element

local KIND_ICON = {
	Tab = "layout-grid", Toggle = "toggle-right", Slider = "sliders-horizontal", Dropdown = "list",
	MultiDropdown = "list-checks", Keybind = "keyboard", ColorPicker = "palette", Input = "text-cursor-input",
	Button = "mouse-pointer-click", ProgressBar = "activity", Label = "type", Paragraph = "align-left",
}

local function emptyState(parent, iconName, title, desc, inline)
	local f = new("Frame", { Name = "EmptyState", BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Parent = parent })
	if inline then
		f.Size = UDim2.new(1, 0, 0, 0)
		pad(f, 0, 10, 0, 10)
	else
		f.AnchorPoint = Vector2.new(0.5, 0.5)
		f.Position = UDim2.fromScale(0.5, 0.5)
		f.Size = UDim2.fromOffset(220, 0)
	end
	vlist(f, 4, Enum.HorizontalAlignment.Center)
	local ic = icon(f, iconName or "inbox", 22, "Muted")
	ic.LayoutOrder = 1
	local t = new("TextLabel", { Size = UDim2.new(1, 0, 0, 15), Text = title or "Nothing here yet", Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Center, LayoutOrder = 2, Bind = { TextColor3 = "SubText" }, Parent = f })
	local d = new("TextLabel", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = desc or "", TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center, LayoutOrder = 3, Bind = { TextColor3 = "Muted" }, Parent = f })
	return f, t, d
end

function Element:Get()
	return self.Value
end

function Element:Init(v)
	if self.Flag then
		Library.Flags[self.Flag] = v
	end
end

function Element:Fire(v)
	if self.Flag then
		Library.Flags[self.Flag] = v
	end
	if self.Callback then
		local ok, err = pcall(self.Callback, v)
		if not ok then
			warn("[SCUI] " .. tostring(err))
		end
	end
	for _, fn in ipairs(self.Listeners) do
		task.spawn(fn, v)
	end
end

function Element:OnChanged(fn)
	table.insert(self.Listeners, fn)
	return self
end

function Element:SetVisible(v)
	self.Frame.Visible = v
end

function Element:SetTooltip(t)
	self.TipText = t
end

function Element:Destroy()
	if self.Dead then
		return
	end
	self.Dead = true
	if self.Cleanup then
		self.Cleanup()
	end
	self.Frame:Destroy()
	local sec = self.Section
	sec.Alive -= 1
	if sec.Alive <= 0 then
		sec.EmptyHint.Visible = true
	end
	if self.Flag then
		Library.Options[self.Flag] = nil
		Library.Flags[self.Flag] = nil
	end
end

local function makeEl(sec, opts, kind, height, noIndex)
	local el = setmetatable({
		Kind = kind, Title = opts.Title or opts.Name or opts.Text or kind, Section = sec, Window = sec.Window,
		Listeners = {}, Callback = opts.Callback, Flag = opts.Flag, SaveFlag = opts.Save ~= false,
		TipText = opts.Tooltip or opts.Description,
	}, Element)
	sec.Count += 1
	sec.Alive += 1
	sec.EmptyHint.Visible = false
	el.Frame = new("Frame", { Name = kind .. "_" .. el.Title, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, height), LayoutOrder = sec.Count, Parent = sec.Body })
	if opts.Flag then
		Library.Options[opts.Flag] = el
	end
	attachTip(el.Frame, function()
		return el.TipText
	end)
	if not noIndex then
		sec.Window:_register(el, opts)
	end
	return el
end

local function keyFrom(v)
	if typeof(v) == "EnumItem" then
		return v
	end
	if type(v) == "string" then
		local ok, k = pcall(function()
			return Enum.KeyCode[v]
		end)
		if ok then
			return k
		end
	end
	return nil
end

local Elements = {}

function Elements.Toggle(sec, opts)
	local el = makeEl(sec, opts, "Toggle", 18)
	local btn = new("TextButton", { Size = UDim2.fromScale(1, 1), Parent = el.Frame })
	local lbl = new("TextLabel", { Size = UDim2.new(1, -30, 1, 0), Text = el.Title, TextTruncate = Enum.TextTruncate.AtEnd, TextColor3 = Theme.Muted, Parent = btn })
	local trk = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromOffset(22, 14), BackgroundColor3 = Theme.ToggleOff, Parent = btn })
	corner(trk, 7)
	local knob = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.fromOffset(10, 10), BackgroundColor3 = Theme.ToggleKnob, Parent = trk })
	corner(knob, 5)
	el.Value = opts.Default == true
	local function paint(anim)
		local on = el.Value
		apply(trk, { BackgroundColor3 = on and Theme.Accent or Theme.ToggleOff }, anim)
		apply(knob, { Position = UDim2.new(0, on and 10 or 2, 0.5, 0), BackgroundColor3 = on and WHITE or Theme.ToggleKnob }, anim)
		apply(lbl, { TextColor3 = on and Theme.Text or Theme.Muted }, anim)
	end
	onTheme(function()
		paint(false)
	end)
	function el:Set(v, silent)
		v = v and true or false
		local changed = v ~= self.Value
		self.Value = v
		paint(true)
		if changed and not silent then
			self:Fire(v)
		end
	end
	btn.MouseButton1Click:Connect(function()
		el:Set(not el.Value)
	end)
	el:Init(el.Value)
	return el
end

function Elements.Slider(sec, opts)
	local el = makeEl(sec, opts, "Slider", 26)
	local f = el.Frame
	local min, max, inc = opts.Min or 0, opts.Max or 100, opts.Increment or opts.Step or 1
	local suffix = opts.Suffix or ""
	new("TextLabel", { Size = UDim2.new(1, -60, 0, 14), Text = el.Title, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f })
	local val = new("TextLabel", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.fromOffset(60, 14), TextXAlignment = Enum.TextXAlignment.Right, Bind = { TextColor3 = "SubText" }, Parent = f })
	local hit = new("Frame", { Position = UDim2.fromOffset(0, 14), Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, Parent = f })
	local bar = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 4), Bind = { BackgroundColor3 = "Track" }, Parent = hit })
	corner(bar, 2)
	local fill = new("Frame", { Size = UDim2.new(0, 0, 1, 0), Bind = { BackgroundColor3 = "Accent" }, Parent = bar })
	corner(fill, 2)
	local knob = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(15, 10), BackgroundColor3 = Theme.Knob, Parent = hit })
	corner(knob, RAD.Knob)
	onTheme(function()
		knob.BackgroundColor3 = Theme.Knob
	end)
	local function snap(v)
		v = math.clamp(v, min, max)
		if inc > 0 then
			v = min + math.floor((v - min) / inc + 0.5) * inc
		end
		return math.clamp(tonumber(fmt(v, 4)), min, max)
	end
	local function render(anim)
		local t = max > min and (el.Value - min) / (max - min) or 0
		local kp = UDim2.new(t, -t * 15, 0.5, 0)
		local fs = UDim2.new(t, 15 * (0.5 - t), 1, 0)
		if anim then
			tween(knob, 0.1, { Position = kp })
			tween(fill, 0.1, { Size = fs })
		else
			knob.Position = kp
			fill.Size = fs
		end
		val.Text = fmt(el.Value, 4) .. suffix
	end
	el.Value = snap(opts.Default or min)
	render(false)
	function el:Set(v, silent)
		v = snap(tonumber(v) or min)
		local changed = v ~= self.Value
		self.Value = v
		render(true)
		if changed and not silent then
			self:Fire(v)
		end
	end
	local function fromX(x)
		local w = hit.AbsoluteSize.X - knob.AbsoluteSize.X
		if w <= 0 then
			return
		end
		local t = math.clamp((x - hit.AbsolutePosition.X - knob.AbsoluteSize.X / 2) / w, 0, 1)
		local v = snap(min + (max - min) * t)
		if v ~= el.Value then
			el.Value = v
			render(false)
			el:Fire(v)
		end
	end
	drag(hit, function(p)
		fromX(p.X)
	end, function(p)
		fromX(p.X)
	end)
	el:Init(el.Value)
	return el
end

function Elements.Dropdown(sec, opts)
	local multi = opts.Multi == true
	local el = makeEl(sec, opts, multi and "MultiDropdown" or "Dropdown", 43)
	local f = el.Frame
	f.ClipsDescendants = true
	local values = opts.Values or opts.Options or {}
	local selected = {}
	local open = false
	local optBtns = {}
	new("TextLabel", { Size = UDim2.new(1, 0, 0, 14), Text = el.Title, Parent = f })
	local box = new("TextButton", { Position = UDim2.fromOffset(0, 19), Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 0, Bind = { BackgroundColor3 = "Input" }, Parent = f })
	corner(box, RAD.Input)
	local bs = stroke(box, false)
	local valueLbl = new("TextLabel", { Position = UDim2.fromOffset(7, 0), Size = UDim2.new(1, -28, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = box })
	local chev = icon(box, "chevron-down", 12, "Muted")
	chev.AnchorPoint = Vector2.new(1, 0.5)
	chev.Position = UDim2.new(1, -8, 0.5, 0)
	local panel = new("ScrollingFrame", { Position = UDim2.fromOffset(0, 49), Size = UDim2.new(1, 0, 0, 0), ScrollBarThickness = 2, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundTransparency = 0, Bind = { BackgroundColor3 = "Input", ScrollBarImageColor3 = "Stroke" }, Parent = f })
	corner(panel, RAD.Input)
	stroke(panel, "Line")
	pad(panel, 0, 8, 0, 8)
	vlist(panel, 0)

	local function getValue()
		if not multi then
			for _, v in ipairs(values) do
				if selected[v] then
					return v
				end
			end
			return nil
		end
		local out = {}
		for _, v in ipairs(values) do
			if selected[v] then
				out[#out + 1] = v
			end
		end
		return out
	end
	local function render()
		for name, b in pairs(optBtns) do
			local on = selected[name] == true
			b.Label.TextColor3 = on and Theme.Accent or Theme.Muted
			if b.Check then
				b.Check.Visible = on
			end
		end
		local v = getValue()
		if multi then
			valueLbl.Text = #v > 0 and table.concat(v, ", ") or (opts.Placeholder or "None")
		else
			valueLbl.Text = v or (opts.Placeholder or "Select...")
		end
		el.Value = v
	end
	local function panelH()
		return math.min(#values, 6) * 16 + 16
	end
	local function setOpen(v, instant)
		open = v
		local h = panelH()
		panel.Size = UDim2.new(1, 0, 0, h)
		local goal = UDim2.new(1, 0, 0, v and (49 + h) or 43)
		if instant then
			f.Size = goal
			bs.Color = v and Theme.Accent or Theme.Stroke
		else
			tween(f, 0.2, { Size = goal })
			tween(bs, 0.15, { Color = v and Theme.Accent or Theme.Stroke })
		end
		setIcon(chev, v and "chevron-up" or "chevron-down")
	end
	local function build()
		for _, b in pairs(optBtns) do
			b.Btn:Destroy()
		end
		optBtns = {}
		for i, v in ipairs(values) do
			local b = new("TextButton", { Name = tostring(v), Size = UDim2.new(1, 0, 0, 16), LayoutOrder = i, Parent = panel })
			local l = new("TextLabel", { Position = UDim2.fromOffset(7, 0), Size = UDim2.new(1, -28, 1, 0), Text = tostring(v), TextColor3 = Theme.Muted, Parent = b })
			local c
			if multi then
				c = icon(b, "check", 11, "Accent")
				c.AnchorPoint = Vector2.new(1, 0.5)
				c.Position = UDim2.new(1, -8, 0.5, 0)
				c.Visible = false
			end
			optBtns[v] = { Btn = b, Label = l, Check = c }
			b.MouseEnter:Connect(function()
				if not selected[v] then
					tween(l, 0.1, { TextColor3 = Theme.Text })
				end
			end)
			b.MouseLeave:Connect(function()
				if not selected[v] then
					tween(l, 0.1, { TextColor3 = Theme.Muted })
				end
			end)
			b.MouseButton1Click:Connect(function()
				if multi then
					selected[v] = not selected[v] or nil
				else
					selected = { [v] = true }
					setOpen(false)
				end
				render()
				el:Fire(getValue())
			end)
		end
	end
	local def = opts.Default
	if multi and type(def) == "table" then
		for _, n in ipairs(def) do
			selected[n] = true
		end
	elseif not multi and def ~= nil then
		selected[def] = true
	end
	build()
	render()
	onTheme(function()
		render()
		bs.Color = open and Theme.Accent or Theme.Stroke
	end)
	box.MouseButton1Click:Connect(function()
		setOpen(not open)
	end)
	function el:Set(v, silent)
		selected = {}
		if multi then
			for _, n in ipairs(type(v) == "table" and v or {}) do
				selected[n] = true
			end
		elseif v ~= nil then
			selected[v] = true
		end
		render()
		if not silent then
			self:Fire(getValue())
		end
	end
	function el:Get()
		return getValue()
	end
	function el:SetValues(list)
		values = list
		for k in pairs(selected) do
			if not table.find(values, k) then
				selected[k] = nil
			end
		end
		build()
		render()
		if open then
			setOpen(true)
		end
	end
	function el:Open(v)
		setOpen(v ~= false)
	end
	if opts.Open then
		setOpen(true, true)
	end
	el:Init(getValue())
	return el
end

function Elements.MultiDropdown(sec, opts)
	opts.Multi = true
	return Elements.Dropdown(sec, opts)
end

function Elements.Keybind(sec, opts)
	local el = makeEl(sec, opts, "Keybind", 20)
	local f = el.Frame
	el.Value = keyFrom(opts.Default)
	local mode = opts.Mode or "Press"
	local listening, active = false, false
	new("TextLabel", { Size = UDim2.new(1, -70, 1, 0), Text = el.Title, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f })
	local btn = new("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center, BackgroundTransparency = 0, Bind = { BackgroundColor3 = "Input", TextColor3 = "SubText" }, Parent = f })
	corner(btn, RAD.Input)
	pad(btn, 8, 0, 8, 0)
	new("UISizeConstraint", { MinSize = Vector2.new(42, 18), Parent = btn })
	local bs = stroke(btn, false)
	local function render()
		btn.Text = listening and "..." or (el.Value and el.Value.Name or "None")
		bs.Color = listening and Theme.Accent or Theme.Stroke
	end
	onTheme(render)
	local function press(state)
		if opts.Callback then
			local ok, err = pcall(opts.Callback, state)
			if not ok then
				warn("[SCUI] " .. tostring(err))
			end
		end
	end
	local function setKey(k, silent)
		el.Value = k
		if el.Flag then
			Library.Flags[el.Flag] = k and k.Name or nil
		end
		render()
		if not silent then
			if opts.Changed then
				pcall(opts.Changed, k)
			end
			for _, fn in ipairs(el.Listeners) do
				task.spawn(fn, k)
			end
		end
	end
	btn.MouseButton1Click:Connect(function()
		listening = true
		render()
	end)
	sec.Window:Connect(UserInputService.InputBegan, function(input, gp)
		if listening then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				listening = false
				if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
					setKey(nil)
				else
					setKey(input.KeyCode)
				end
			end
			return
		end
		if gp or not el.Value or input.KeyCode ~= el.Value then
			return
		end
		if mode == "Toggle" then
			active = not active
			press(active)
		else
			press(true)
		end
	end)
	sec.Window:Connect(UserInputService.InputEnded, function(input)
		if mode == "Hold" and el.Value and input.KeyCode == el.Value then
			press(false)
		end
	end)
	function el:Set(k, silent)
		setKey(keyFrom(k), silent)
	end
	el:Init(el.Value and el.Value.Name)
	return el
end

function Elements.ColorPicker(sec, opts)
	local el = makeEl(sec, opts, "ColorPicker", 20)
	local f = el.Frame
	f.ClipsDescendants = true
	local h, s, v = (opts.Default or rgb(255, 255, 255)):ToHSV()
	local open = false
	local row = new("TextButton", { Size = UDim2.new(1, 0, 0, 20), Parent = f })
	new("TextLabel", { Size = UDim2.new(1, -34, 1, 0), Text = el.Title, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row })
	local sw = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromOffset(24, 14), BackgroundColor3 = WHITE, Parent = row })
	corner(sw, RAD.Mini)
	stroke(sw, "Stroke")
	local panel = new("Frame", { Position = UDim2.fromOffset(0, 26), Size = UDim2.new(1, 0, 0, 114), BackgroundTransparency = 1, Parent = f })
	local sv = new("Frame", { Size = UDim2.new(1, 0, 0, 70), BackgroundColor3 = WHITE, Parent = panel })
	corner(sv, RAD.Mini)
	local whiteL = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, Parent = sv })
	corner(whiteL, RAD.Mini)
	new("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = whiteL })
	local blackL = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK, Parent = sv })
	corner(blackL, RAD.Mini)
	new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0), Parent = blackL })
	local cur = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(9, 9), BackgroundTransparency = 1, ZIndex = 3, Parent = sv })
	corner(cur, 5)
	new("UIStroke", { Color = WHITE, Thickness = 1.5, Parent = cur })
	local hue = new("Frame", { Position = UDim2.fromOffset(0, 76), Size = UDim2.new(1, 0, 0, 10), BackgroundColor3 = WHITE, Parent = panel })
	corner(hue, RAD.Mini)
	local seq = {}
	for i = 0, 6 do
		seq[#seq + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1))
	end
	new("UIGradient", { Color = ColorSequence.new(seq), Parent = hue })
	local hm = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(4, 14), BackgroundColor3 = WHITE, ZIndex = 3, Parent = hue })
	corner(hm, 2)
	stroke(hm, "Background", 1)
	local hexBox = new("Frame", { Position = UDim2.fromOffset(0, 92), Size = UDim2.new(1, 0, 0, 22), Bind = { BackgroundColor3 = "Input" }, Parent = panel })
	corner(hexBox, RAD.Input)
	local hs = stroke(hexBox, false)
	local hex = new("TextBox", { Position = UDim2.fromOffset(7, 0), Size = UDim2.new(1, -14, 1, 0), ClearTextOnFocus = false, Parent = hexBox })
	local function paint(silent)
		local c = Color3.fromHSV(h, s, v)
		sw.BackgroundColor3 = c
		sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		cur.Position = UDim2.fromScale(s, 1 - v)
		hm.Position = UDim2.fromScale(h, 0.5)
		hex.Text = "#" .. c:ToHex()
		el.Value = c
		if not silent then
			el:Fire(c)
		end
	end
	local function setSV(p)
		s = math.clamp((p.X - sv.AbsolutePosition.X) / math.max(1, sv.AbsoluteSize.X), 0, 1)
		v = 1 - math.clamp((p.Y - sv.AbsolutePosition.Y) / math.max(1, sv.AbsoluteSize.Y), 0, 1)
		paint()
	end
	local function setH(p)
		h = math.clamp((p.X - hue.AbsolutePosition.X) / math.max(1, hue.AbsoluteSize.X), 0, 0.999)
		paint()
	end
	drag(sv, setSV, setSV)
	drag(hue, setH, setH)
	hex.Focused:Connect(function()
		tween(hs, 0.15, { Color = Theme.Accent })
	end)
	hex.FocusLost:Connect(function()
		tween(hs, 0.15, { Color = Theme.Stroke })
		local ok, c = pcall(Color3.fromHex, hex.Text)
		if ok and c then
			h, s, v = c:ToHSV()
		end
		paint()
	end)
	row.MouseButton1Click:Connect(function()
		open = not open
		tween(f, 0.2, { Size = UDim2.new(1, 0, 0, open and 140 or 20) })
	end)
	paint(true)
	function el:Set(c, silent)
		h, s, v = c:ToHSV()
		paint(silent)
	end
	el:Init(el.Value)
	return el
end

function Elements.Input(sec, opts)
	local el = makeEl(sec, opts, "Input", 43)
	local f = el.Frame
	new("TextLabel", { Size = UDim2.new(1, 0, 0, 14), Text = el.Title, Parent = f })
	local box = new("Frame", { Position = UDim2.fromOffset(0, 19), Size = UDim2.new(1, 0, 0, 24), Bind = { BackgroundColor3 = "Input" }, Parent = f })
	corner(box, RAD.Input)
	local bs = stroke(box, false)
	local tb = new("TextBox", { Position = UDim2.fromOffset(7, 0), Size = UDim2.new(1, -14, 1, 0), PlaceholderText = opts.Placeholder or "", Text = tostring(opts.Default or ""), ClearTextOnFocus = false, TextTruncate = Enum.TextTruncate.AtEnd, Parent = box })
	el.Value = opts.Numeric and tonumber(tb.Text) or tb.Text
	local function commit()
		local t = tb.Text
		if opts.Numeric then
			local n = tonumber(t)
			if not n then
				tb.Text = tostring(el.Value or "")
				return
			end
			if opts.Min then
				n = math.max(n, opts.Min)
			end
			if opts.Max then
				n = math.min(n, opts.Max)
			end
			tb.Text = tostring(n)
			t = n
		end
		el.Value = t
		el:Fire(t)
	end
	tb.Focused:Connect(function()
		tween(bs, 0.15, { Color = Theme.Accent })
	end)
	tb.FocusLost:Connect(function()
		tween(bs, 0.15, { Color = Theme.Stroke })
		commit()
	end)
	if opts.Live then
		tb:GetPropertyChangedSignal("Text"):Connect(function()
			el.Value = tb.Text
			el:Fire(tb.Text)
		end)
	end
	function el:Set(val, silent)
		tb.Text = tostring(val)
		self.Value = opts.Numeric and tonumber(tb.Text) or tb.Text
		if not silent then
			self:Fire(self.Value)
		end
	end
	el:Init(el.Value)
	return el
end

function Elements.Button(sec, opts)
	local el = makeEl(sec, opts, "Button", 24)
	local style = opts.Style or "Default"
	local btn = new("TextButton", { Size = UDim2.fromScale(1, 1), Text = el.Title, TextXAlignment = Enum.TextXAlignment.Center, BackgroundTransparency = 0, TextColor3 = Theme.Muted, BackgroundColor3 = Theme.Input, Parent = el.Frame })
	corner(btn, RAD.Button)
	local bs = stroke(btn, false)
	local spin = spinner(btn, 14, 2)
	spin.AnchorPoint = Vector2.new(0.5, 0.5)
	spin.Position = UDim2.fromScale(0.5, 0.5)
	spin.Visible = false
	local function paint(hover, anim)
		local bg, fg, st
		if style == "Accent" or style == "Danger" then
			bg = style == "Accent" and Theme.Accent or Theme.Danger
			fg = WHITE
			st = bg
			if hover then
				bg = bg:Lerp(WHITE, 0.12)
			end
		else
			bg = hover and Theme.Item or Theme.Input
			fg = hover and Theme.Text or Theme.Muted
			st = Theme.Stroke
		end
		apply(btn, { BackgroundColor3 = bg, TextColor3 = fg }, anim)
		bs.Color = st
	end
	onTheme(function()
		paint(false, false)
	end)
	btn.MouseEnter:Connect(function()
		paint(true, true)
	end)
	btn.MouseLeave:Connect(function()
		paint(false, true)
	end)
	local function run()
		el:Fire(nil)
	end
	btn.MouseButton1Click:Connect(function()
		if el.Loading then
			return
		end
		if opts.Confirm then
			local c = type(opts.Confirm) == "table" and opts.Confirm or {}
			sec.Window:Dialog({
				Title = c.Title or "Are you sure?", Content = c.Content or "This action will be executed immediately.",
				ConfirmText = c.ConfirmText, CancelText = c.CancelText, Danger = style == "Danger",
				Callback = function(ok)
					if ok then
						run()
					end
				end,
			})
		else
			run()
		end
	end)
	function el:SetText(t)
		self.Title = t
		btn.Text = t
	end
	function el:SetLoading(b)
		self.Loading = b
		spin.Visible = b
		btn.TextTransparency = b and 1 or 0
	end
	return el
end

function Elements.Divider(sec, opts)
	local el = makeEl(sec, opts, "Divider", opts.Text and 14 or 9, true)
	local f = el.Frame
	if opts.Text then
		local t = new("TextLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 14), Text = opts.Text, TextSize = 10, Font = Enum.Font.GothamBold, ZIndex = 2, Bind = { TextColor3 = "Muted" }, Parent = f })
		pad(t, 6, 0, 6, 0)
		new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 1), Bind = { BackgroundColor3 = "Line" }, Parent = f })
		t.BackgroundTransparency = 0
		bind(t, "BackgroundColor3", "Panel")
	else
		new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 1), Bind = { BackgroundColor3 = "Line" }, Parent = f })
	end
	return el
end

function Elements.Label(sec, opts)
	local el = makeEl(sec, opts, "Label", 0)
	el.Frame.AutomaticSize = Enum.AutomaticSize.Y
	local l = new("TextLabel", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = el.Title, TextWrapped = true, TextSize = 11, RichText = opts.RichText == true, Bind = { TextColor3 = "Muted" }, Parent = el.Frame })
	function el:SetText(t)
		self.Title = t
		l.Text = t
	end
	return el
end

function Elements.Paragraph(sec, opts)
	local el = makeEl(sec, opts, "Paragraph", 0)
	local f = el.Frame
	f.AutomaticSize = Enum.AutomaticSize.Y
	vlist(f, 3)
	local t = new("TextLabel", { Size = UDim2.new(1, 0, 0, 15), Text = el.Title, Font = Enum.Font.GothamBold, LayoutOrder = 1, Parent = f })
	local c = new("TextLabel", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = opts.Content or "", TextSize = 11, TextWrapped = true, LayoutOrder = 2, Bind = { TextColor3 = "Muted" }, Parent = f })
	function el:SetTitle(x)
		self.Title = x
		t.Text = x
	end
	function el:SetContent(x)
		c.Text = x
	end
	return el
end

function Elements.ProgressBar(sec, opts)
	local el = makeEl(sec, opts, "ProgressBar", 26)
	local f = el.Frame
	local min, max = opts.Min or 0, opts.Max or 100
	new("TextLabel", { Size = UDim2.new(1, -60, 0, 14), Text = el.Title, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f })
	local val = new("TextLabel", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.fromOffset(60, 14), TextXAlignment = Enum.TextXAlignment.Right, Bind = { TextColor3 = "SubText" }, Parent = f })
	local bar = new("Frame", { Position = UDim2.fromOffset(0, 19), Size = UDim2.new(1, 0, 0, 4), Bind = { BackgroundColor3 = "Track" }, Parent = f })
	corner(bar, 2)
	local fill = new("Frame", { Size = UDim2.new(0, 0, 1, 0), Bind = { BackgroundColor3 = "Accent" }, Parent = bar })
	corner(fill, 2)
	function el:Set(x, silent)
		x = math.clamp(tonumber(x) or min, min, max)
		self.Value = x
		local t = max > min and (x - min) / (max - min) or 0
		tween(fill, 0.25, { Size = UDim2.new(t, 0, 1, 0) })
		if opts.ShowValue == false then
			val.Text = ""
		elseif opts.Suffix then
			val.Text = fmt(x, 2) .. opts.Suffix
		else
			val.Text = fmt(t * 100, 0) .. "%"
		end
		if not silent then
			self:Fire(x)
		end
	end
	el:Set(opts.Default or min, true)
	el:Init(el.Value)
	return el
end

function Elements.EmptyState(sec, opts)
	local el = makeEl(sec, opts, "EmptyState", 0, true)
	el.Frame.AutomaticSize = Enum.AutomaticSize.Y
	emptyState(el.Frame, opts.Icon, opts.Title, opts.Content or opts.Description, true)
	return el
end

for _, n in ipairs({ "Toggle", "Slider", "Dropdown", "MultiDropdown", "Keybind", "ColorPicker", "Input", "Button", "Divider", "Label", "Paragraph", "ProgressBar", "EmptyState" }) do
	Section["Add" .. n] = function(self, opts)
		return Elements[n](self, opts or {})
	end
end

local function esc(s)
	s = string.gsub(s, "&", "&amp;")
	s = string.gsub(s, "<", "&lt;")
	s = string.gsub(s, ">", "&gt;")
	return s
end

local function highlight(text, q)
	if q == "" then
		return esc(text)
	end
	local s, e = string.find(string.lower(text), string.lower(q), 1, true)
	if not s then
		return esc(text)
	end
	return esc(string.sub(text, 1, s - 1)) .. '<font color="#' .. Theme.Accent:ToHex() .. '"><b>' .. esc(string.sub(text, s, e)) .. "</b></font>" .. esc(string.sub(text, e + 1))
end

local function serialize(v)
	if typeof(v) == "Color3" then
		return { __c = v:ToHex() }
	end
	if typeof(v) == "EnumItem" then
		return { __k = v.Name }
	end
	return v
end

local function deserialize(v)
	if type(v) == "table" then
		if v.__c then
			return Color3.fromHex(v.__c)
		end
		if v.__k then
			return keyFrom(v.__k)
		end
	end
	return v
end

local function buildAvatar(parent, custom, userId)
	for _, c in ipairs(parent:GetChildren()) do
		c:Destroy()
	end
	if custom ~= false then
		local base = new("Frame", { Name = "AvatarBase", Size = UDim2.fromScale(1, 1), Bind = { BackgroundColor3 = "Track" }, Parent = parent })
		corner(base, 11)
		local url
		if custom then
			url = assetUrl(custom)
		else
			local lp = Players.LocalPlayer
			local id = userId or (lp and lp.UserId) or 1
			url = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(id) .. "&w=150&h=150"
		end
		local img = new("ImageLabel", { Name = "Picture", Size = UDim2.fromScale(1, 1), Image = url, ScaleType = Enum.ScaleType.Crop, Parent = base })
		corner(img, 11)
		return
	end
	local face = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(255, 205, 38), Parent = parent })
	corner(face, 11)
	for _, x in ipairs({ 3, 11 }) do
		local eye = new("Frame", { Position = UDim2.fromOffset(x, 3), Size = UDim2.fromOffset(7, 9), BackgroundColor3 = WHITE, Parent = face })
		corner(eye, 4)
		local pupil = new("Frame", { Position = UDim2.fromOffset(2, 4), Size = UDim2.fromOffset(3, 4), BackgroundColor3 = BLACK, Parent = eye })
		corner(pupil, 2)
	end
	local beak = new("Frame", { Position = UDim2.fromOffset(6, 13), Size = UDim2.fromOffset(9, 5), BackgroundColor3 = rgb(255, 140, 0), Parent = face })
	corner(beak, 3)
end

function SubTab:_paint(anim)
	if not self.Chip then
		return
	end
	local on = self.Tab.ActiveSub == self
	apply(self.Chip, { BackgroundColor3 = Theme.Item, BackgroundTransparency = on and 0 or 1 }, anim)
	apply(self.ChipText, { TextColor3 = on and Theme.Text or Theme.Muted }, anim)
	if self.ChipIcon then
		apply(self.ChipIcon, { ImageColor3 = on and Theme.Accent or Theme.Muted }, anim)
	end
end

function SubTab:_sync()
	local k = math.max(self.Window.Scale.Scale, 0.01)
	local heights = { 0, 0 }
	for i, col in ipairs({ self.ColL, self.ColR }) do
		local total, n = 0, 0
		for _, c in ipairs(col:GetChildren()) do
			if c:IsA("Frame") then
				total += c.AbsoluteSize.Y / k
				n += 1
			end
		end
		heights[i] = total + math.max(0, n - 1) * self.Gap
	end
	self.ColL.Size = UDim2.new(0.5, -6, 0, heights[1])
	self.ColR.Size = UDim2.new(0.5, -6, 0, heights[2])
	self.Cols.Size = UDim2.new(1, -24, 0, math.max(heights[1], heights[2]))
end

function SubTab:_empty()
	self.Empty.Visible = #self.Sections == 0 and self.Tab.ActiveSub == self
end

function SubTab:SetEmptyText(title, desc)
	self.EmptyTitle.Text = title or self.EmptyTitle.Text
	self.EmptyDesc.Text = desc or self.EmptyDesc.Text
end

function SubTab:_destroy()
	self.Holder:Destroy()
	self.Empty:Destroy()
	if self.Chip then
		self.Chip:Destroy()
	end
	local subs = self.Tab.Subs
	table.remove(subs, table.find(subs, self))
	if self.Tab.ActiveSub == self then
		self.Tab.ActiveSub = nil
	end
end

function SubTab:AddSection(opts)
	opts = opts or {}
	local W = self.Window
	local sec = setmetatable({ Window = W, Sub = self, Tab = self.Tab, Title = opts.Title or "Section", Count = 0, Alive = 0 }, Section)
	local side = opts.Side or ((#self.Sections % 2 == 0) and "Left" or "Right")
	local col = side == "Right" and self.ColR or self.ColL
	local card = new("Frame", { Name = "Section_" .. sec.Title, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ClipsDescendants = true, LayoutOrder = #self.Sections + 1, Bind = { BackgroundColor3 = "Panel" }, Parent = col })
	corner(card, RAD.Card)
	stroke(card, "Line")
	vlist(card, 0)
	card:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		self:_sync()
	end)
	local header = new("Frame", { Name = "Header", Size = UDim2.new(1, 0, 0, 26), LayoutOrder = 0, Bind = { BackgroundColor3 = "PanelHeader" }, Parent = card })
	corner(header, RAD.Card)
	new("Frame", { Name = "Fill", AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, RAD.Card + 1), Bind = { BackgroundColor3 = "PanelHeader" }, Parent = header })
	local tx = 10
	if opts.Icon then
		local ic = icon(header, opts.Icon, 12, "Accent")
		ic.AnchorPoint = Vector2.new(0, 0.5)
		ic.Position = UDim2.new(0, 8, 0.5, 0)
		tx = 28
	end
	sec.TitleLabel = new("TextLabel", { Position = UDim2.fromOffset(tx, 0), Size = UDim2.new(1, -tx - 8, 1, 0), Text = sec.Title, Font = Enum.Font.GothamBold, TextTruncate = Enum.TextTruncate.AtEnd, Parent = header })
	sec.Body = new("Frame", { Name = "Body", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 1, Parent = card })
	local bp = pad(sec.Body, 9, 6, 9, 11)
	local bl = vlist(sec.Body, 6)
	sec.EmptyHint = new("TextLabel", { Name = "EmptyHint", Size = UDim2.new(1, 0, 0, 26), Text = "Nothing here yet", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center, LayoutOrder = 0, Bind = { TextColor3 = "Muted" }, Parent = sec.Body })
	sec.Card = card
	W:_compact(function(on)
		bl.Padding = UDim.new(0, on and 3 or 6)
		bp.PaddingTop = UDim.new(0, on and 4 or 6)
		bp.PaddingBottom = UDim.new(0, on and 7 or 11)
		header.Size = UDim2.new(1, 0, 0, on and 22 or 26)
	end)
	table.insert(self.Sections, sec)
	self:_empty()
	task.defer(function()
		self:_sync()
	end)
	return sec
end

function Section:SetTitle(t)
	self.Title = t
	self.TitleLabel.Text = t
end

function Section:Destroy()
	self.Card:Destroy()
	table.remove(self.Sub.Sections, table.find(self.Sub.Sections, self))
	self.Sub:_empty()
	task.defer(function()
		self.Sub:_sync()
	end)
end

function Tab:_layout()
	local hasBar = false
	for _, s in ipairs(self.Subs) do
		if s.Explicit then
			hasBar = true
		end
	end
	self.Bar.Visible = hasBar
	local top = hasBar and 31 or 0
	for _, s in ipairs(self.Subs) do
		s.Holder.Position = UDim2.fromOffset(0, top)
		s.Holder.Size = UDim2.new(1, 0, 1, -top)
		s.Pad.PaddingTop = UDim.new(0, hasBar and 14 or 6)
	end
end

function Tab:_newSub(title, iconName, explicit)
	local W = self.Window
	local sub = setmetatable({ Window = W, Tab = self, Title = title, Icon = iconName, Sections = {}, Explicit = explicit }, SubTab)
	sub.Holder = new("ScrollingFrame", { Name = "Sub_" .. title, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, ScrollBarImageTransparency = 0.3, ScrollingDirection = Enum.ScrollingDirection.Y, Visible = false, Bind = { ScrollBarImageColor3 = "Stroke" }, Parent = self.Page })
	sub.Pad = pad(sub.Holder, 0, 6, 0, 12)
	sub.Gap = 11
	sub.Cols = new("Frame", { Name = "Columns", Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -24, 0, 0), BackgroundTransparency = 1, Parent = sub.Holder })
	hlist(sub.Cols, 12, Enum.VerticalAlignment.Top)
	sub.ColL = new("Frame", { Name = "Left", Size = UDim2.new(0.5, -6, 0, 0), BackgroundTransparency = 1, LayoutOrder = 1, Parent = sub.Cols })
	sub.ColR = new("Frame", { Name = "Right", Size = UDim2.new(0.5, -6, 0, 0), BackgroundTransparency = 1, LayoutOrder = 2, Parent = sub.Cols })
	local l1, l2 = vlist(sub.ColL, 11), vlist(sub.ColR, 11)
	W:_compact(function(on)
		sub.Gap = on and 6 or 11
		l1.Padding = UDim.new(0, sub.Gap)
		l2.Padding = UDim.new(0, sub.Gap)
		sub:_sync()
	end)
	sub.Empty, sub.EmptyTitle, sub.EmptyDesc = emptyState(self.Page, "inbox", "Nothing here yet", "This section has no content.")
	sub.Empty.Visible = false
	if explicit then
		local chip = new("TextButton", { Name = "Chip_" .. title, Size = UDim2.fromOffset(0, 28), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, LayoutOrder = #self.Subs + 1, Parent = self.Bar })
		corner(chip, RAD.Chip)
		pad(chip, 8, 0, 9, 0)
		hlist(chip, 8)
		sub.Chip = chip
		if iconName then
			sub.ChipIcon = icon(chip, iconName, 12, false)
			sub.ChipIcon.LayoutOrder = 1
		end
		sub.ChipText = new("TextLabel", { Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = title, Font = Enum.Font.GothamBold, TextColor3 = Theme.Muted, LayoutOrder = 2, Parent = chip })
		chip.MouseButton1Click:Connect(function()
			self:SelectSub(sub)
		end)
		onTheme(function()
			sub:_paint(false)
		end)
	end
	table.insert(self.Subs, sub)
	self.Empty.Visible = false
	self:_layout()
	if not self.ActiveSub then
		self:SelectSub(sub)
	end
	return sub
end

function Tab:AddSubTab(opts)
	opts = opts or {}
	local first = self.Subs[1]
	if first and #self.Subs == 1 and not first.Explicit and #first.Sections == 0 then
		first:_destroy()
	end
	return self:_newSub(opts.Title or opts.Name or "Section", opts.Icon, true)
end

function Tab:AddSection(opts)
	local sub = self.Subs[#self.Subs]
	if not sub then
		sub = self:_newSub(self.Title, nil, false)
	end
	return sub:AddSection(opts)
end

function Tab:SelectSub(sub)
	if type(sub) == "string" then
		for _, s in ipairs(self.Subs) do
			if s.Title == sub then
				sub = s
				break
			end
		end
	end
	if type(sub) ~= "table" then
		return
	end
	self.ActiveSub = sub
	for _, s in ipairs(self.Subs) do
		s.Holder.Visible = s == sub
		s:_paint(true)
		s:_empty()
	end
end

function Tab:SetEmptyText(title, desc)
	self.EmptyTitle.Text = title or self.EmptyTitle.Text
	self.EmptyDesc.Text = desc or self.EmptyDesc.Text
end

function Tab:_paint(anim)
	local on = self.Window.Active == self
	apply(self.Item, { BackgroundColor3 = Theme.Item, BackgroundTransparency = on and 0 or 1 }, anim)
	apply(self.Label, { TextColor3 = on and Theme.Text or Theme.Muted }, anim)
	apply(self.IconImg, { ImageColor3 = on and Theme.Accent or Theme.Muted }, anim)
	self.Label.Font = on and Enum.Font.GothamBold or Enum.Font.GothamMedium
	self.Indicator.Visible = on and self.Window.Cfg.ActiveIndicator ~= false
end

local function buildRoot(W)
	local cfg = W.Cfg
	local size = cfg.Size or UDim2.fromOffset(561, 543)
	local root = new("Frame", { Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = size, ClipsDescendants = true, Bind = { BackgroundColor3 = "Background" }, Parent = Library.Gui })
	corner(root, RAD.Window)
	stroke(root, "Line")
	W.Root = root
	W.Scale = new("UIScale", { Parent = root })
	W.Size = Vector2.new(size.X.Offset, size.Y.Offset)
	W.Bg = new("ImageLabel", { Name = "Background", Size = UDim2.fromScale(1, 1), ImageTransparency = 1, ScaleType = Enum.ScaleType.Crop, ZIndex = 0, Parent = root })
	W:ApplyScale()
end

local function buildSidebar(W)
	local cfg = W.Cfg
	local sb = new("Frame", { Name = "Sidebar", Size = UDim2.new(0, SIDE_W, 1, 0), BackgroundTransparency = 1, ClipsDescendants = true, Parent = W.Root })
	W.Sidebar = sb
	new("Frame", { Name = "Divider", AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.new(0, 1, 1, 0), Bind = { BackgroundColor3 = "Line" }, Parent = sb })
	local head = new("Frame", { Name = "Header", Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1, Parent = sb })
	W.SideHead = head
	if cfg.Logo then
		W.Logo = new("ImageLabel", { Image = assetUrl(cfg.Logo), Size = UDim2.fromOffset(24, 21), ScaleType = Enum.ScaleType.Fit, Parent = head })
	else
		W.Logo = new("TextLabel", { Text = cfg.LogoText or "SC", Font = Enum.Font.GothamBlack, TextSize = 17, Size = UDim2.fromOffset(24, 21), Bind = { TextColor3 = "Accent" }, Parent = head })
	end
	W.Logo.Position = UDim2.fromOffset(11, 12)
	W.Title = new("TextLabel", { Position = UDim2.fromOffset(44, 8), Size = UDim2.new(1, -48, 0, 15), Text = cfg.Title or "SCUI", Font = Enum.Font.GothamBold, TextSize = 13, TextTruncate = Enum.TextTruncate.AtEnd, Parent = head })
	W.Subtitle = new("TextLabel", { Position = UDim2.fromOffset(44, 23), Size = UDim2.new(1, -48, 0, 13), Text = cfg.Subtitle or "", TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd, Bind = { TextColor3 = "Muted" }, Parent = head })
	W.SideLine = new("Frame", { Name = "Line", Position = UDim2.fromOffset(10, 52), Size = UDim2.new(1, -24, 0, 1), Bind = { BackgroundColor3 = "Line" }, Parent = sb })
	W.TabList = new("ScrollingFrame", { Name = "Tabs", Position = UDim2.fromOffset(10, 64), Size = UDim2.new(1, -24, 1, -119), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, Parent = sb })
	vlist(W.TabList, 0)
	local u = cfg.User or {}
	local card = new("Frame", { Name = "User", Position = UDim2.new(0, 10, 1, -47), Size = UDim2.new(1, -19, 0, 37), Bind = { BackgroundColor3 = "Input" }, Parent = sb })
	corner(card, RAD.Item)
	W.UserCard = card
	W.Avatar = new("Frame", { Name = "Avatar", Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(21, 21), BackgroundTransparency = 1, Parent = card })
	buildAvatar(W.Avatar, u.Avatar, u.UserId)
	W.UserName = new("TextLabel", { Position = UDim2.fromOffset(39, 5), Size = UDim2.new(1, -44, 0, 14), Text = u.Name or "Lifetime", Font = Enum.Font.GothamBold, TextTruncate = Enum.TextTruncate.AtEnd, Parent = card })
	W.UserInfo = new("TextLabel", { Position = UDim2.fromOffset(39, 19), Size = UDim2.new(1, -44, 0, 13), Text = u.Info or "Premium  Yes", TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd, Bind = { TextColor3 = "Muted" }, Parent = card })
	local function dragWindow(handle)
		local startPos, startCenter
		drag(handle, function(p)
			startPos = p
			startCenter = W.Root.AbsolutePosition + W.Root.AbsoluteSize / 2
		end, function(p)
			local vp = Library.Gui.AbsoluteSize
			local c = startCenter + (p - startPos)
			c = Vector2.new(math.clamp(c.X, 40, vp.X - 40), math.clamp(c.Y, 20, vp.Y - 20))
			W.Root.Position = UDim2.fromScale(c.X / vp.X, c.Y / vp.Y)
		end)
	end
	W.DragHandle = dragWindow
	dragWindow(head)
end

local function buildMain(W)
	local main = new("Frame", { Name = "Main", Position = UDim2.new(0, SIDE_W, 0, 0), Size = UDim2.new(1, -SIDE_W, 1, 0), BackgroundTransparency = 1, ClipsDescendants = true, Parent = W.Root })
	W.Main = main
	local top = new("Frame", { Name = "Topbar", Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 1, Parent = main })
	W.Top = top
	W.DragHandle(top)
	local menu = new("TextButton", { Name = "Menu", Position = UDim2.fromOffset(7, 10), Size = UDim2.fromOffset(24, 24), BackgroundTransparency = 0, Visible = false, Bind = { BackgroundColor3 = "Input" }, Parent = top })
	corner(menu, RAD.Item)
	local mi = icon(menu, "panel-left", 13, "SubText")
	mi.AnchorPoint = Vector2.new(0.5, 0.5)
	mi.Position = UDim2.fromScale(0.5, 0.5)
	menu.MouseButton1Click:Connect(function()
		W:SetSidebarCollapsed(false)
	end)
	W.MenuBtn = menu
	local group = new("Frame", { Name = "Title", Size = UDim2.new(1, -200, 1, 0), BackgroundTransparency = 1, Parent = top })
	W.TitleGroup = group
	local box = new("Frame", { Position = UDim2.fromOffset(7, 10), Size = UDim2.fromOffset(24, 24), Bind = { BackgroundColor3 = "Input" }, Parent = group })
	corner(box, RAD.Item)
	W.TopIcon = icon(box, nil, 14, "Accent")
	W.TopIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	W.TopIcon.Position = UDim2.fromScale(0.5, 0.5)
	W.TopTitle = new("TextLabel", { Position = UDim2.fromOffset(40, 0), Size = UDim2.new(1, -40, 1, 0), Font = Enum.Font.GothamBold, TextSize = 14, TextTruncate = Enum.TextTruncate.AtEnd, Parent = group })
	W.Pages = new("Frame", { Name = "Pages", Position = UDim2.fromOffset(0, 45), Size = UDim2.new(1, 0, 1, -45), BackgroundTransparency = 1, Parent = main })
end

local function buildSearch(W)
	local box = new("Frame", { Name = "Search", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -46, 0, 22), Size = UDim2.fromOffset(142, 27), Bind = { BackgroundColor3 = "Input" }, Parent = W.Top })
	corner(box, RAD.Input)
	local bs = stroke(box, false)
	local si = icon(box, "search", 12, "Muted")
	si.Position = UDim2.new(0, 9, 0.5, -6)
	local tb = new("TextBox", { Position = UDim2.fromOffset(27, 0), Size = UDim2.new(1, -33, 1, 0), PlaceholderText = "Search... (Ctrl + K)", ClearTextOnFocus = false, TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd, Parent = box })
	local pop = new("Frame", { Name = "SearchResults", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 46), Size = UDim2.fromOffset(250, 60), Visible = false, ZIndex = 30, Bind = { BackgroundColor3 = "Panel" }, Parent = W.Main })
	corner(pop, RAD.Popup)
	stroke(pop, "Stroke")
	local list = new("ScrollingFrame", { Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, Bind = { ScrollBarImageColor3 = "Stroke" }, Parent = pop })
	pad(list, 0, 4, 0, 4)
	vlist(list, 2, Enum.HorizontalAlignment.Center)
	local empty, emptyTitle, emptyDesc = emptyState(pop, "search", "No results", "Try a different keyword.")
	empty.Visible = false
	W.Search = { Box = tb, Frame = box, Stroke = bs, Pop = pop, List = list, Empty = empty, EmptyTitle = emptyTitle, EmptyDesc = emptyDesc, Rows = {}, Items = {}, Sel = 1 }
	tb.Focused:Connect(function()
		W:_openSearch()
	end)
	tb:GetPropertyChangedSignal("Text"):Connect(function()
		W:_renderSearch(tb.Text)
	end)
	tb.FocusLost:Connect(function(enter)
		if enter then
			W:_pickSearch()
		end
		task.delay(0.3, function()
			if not tb:IsFocused() then
				W:_closeSearch()
			end
		end)
	end)
	local qb = new("TextButton", { Name = "Quick", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0, 22), Size = UDim2.fromOffset(26, 27), BackgroundTransparency = 0, Bind = { BackgroundColor3 = "Input" }, Parent = W.Top })
	corner(qb, RAD.Input)
	stroke(qb, "Line")
	local qi = icon(qb, "folder-cog", 13, "SubText")
	qi.AnchorPoint = Vector2.new(0.5, 0.5)
	qi.Position = UDim2.fromScale(0.5, 0.5)
	local menu = new("Frame", { Name = "QuickMenu", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 40), Size = UDim2.fromOffset(170, 0), AutomaticSize = Enum.AutomaticSize.Y, Visible = false, ZIndex = 31, Bind = { BackgroundColor3 = "Panel" }, Parent = W.Main })
	corner(menu, RAD.Popup)
	stroke(menu, "Stroke")
	pad(menu, 4)
	vlist(menu, 2)
	local blocker = new("TextButton", { Name = "Blocker", Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 29, Parent = W.Main })
	W.Quick = { Frame = menu, Blocker = blocker, Rows = {} }
	local entries = {
		{ "Hide sidebar", "panel-left-close", function() W:SetSidebarCollapsed(not W.State.Collapsed) end, function() return W.State.Collapsed end },
		{ "Icons only", "layout-grid", function() W:SetIconsOnly(not W.State.IconsOnly) end, function() return W.State.IconsOnly end },
		{ "Compact mode", "rows-3", function() W:SetCompact(not W.State.Compact) end, function() return W.State.Compact end },
		{ "Minimize", "minus", function() W:Minimize() end },
		{ "Search", "search", function() W:FocusSearch() end },
	}
	for i, e in ipairs(entries) do
		local row = new("TextButton", { Size = UDim2.new(1, 0, 0, 24), LayoutOrder = i, ZIndex = 32, Parent = menu })
		corner(row, RAD.Input)
		row.BackgroundColor3 = Theme.Item
		local ri = icon(row, e[2], 12, "SubText")
		ri.AnchorPoint = Vector2.new(0, 0.5)
		ri.Position = UDim2.new(0, 8, 0.5, 0)
		new("TextLabel", { Position = UDim2.fromOffset(28, 0), Size = UDim2.new(1, -50, 1, 0), Text = e[1], Parent = row })
		local dot
		if e[4] then
			dot = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -9, 0.5, 0), Size = UDim2.fromOffset(6, 6), Bind = { BackgroundColor3 = "Accent" }, Parent = row })
			corner(dot, 3)
		end
		row.MouseEnter:Connect(function()
			tween(row, 0.1, { BackgroundTransparency = 0 })
		end)
		row.MouseLeave:Connect(function()
			tween(row, 0.1, { BackgroundTransparency = 1 })
		end)
		row.MouseButton1Click:Connect(function()
			W:_toggleQuick(false)
			e[3]()
		end)
		W.Quick.Rows[i] = function()
			if dot then
				dot.Visible = e[4]()
			end
		end
	end
	qb.MouseButton1Click:Connect(function()
		W:_toggleQuick(not menu.Visible)
	end)
	blocker.MouseButton1Click:Connect(function()
		W:_toggleQuick(false)
	end)
end

local function buildFloat(W)
	local btn = new("TextButton", { Name = "Float", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.08, 0.2), Size = UDim2.fromOffset(40, 40), BackgroundTransparency = 0, Visible = false, ZIndex = 5, Bind = { BackgroundColor3 = "Panel" }, Parent = Library.Gui })
	corner(btn, 20)
	stroke(btn, "Accent", 1.5)
	if W.Cfg.Logo then
		local li = new("ImageLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(22, 22), Image = assetUrl(W.Cfg.Logo), Parent = btn })
		li.ZIndex = 6
	else
		new("TextLabel", { Size = UDim2.fromScale(1, 1), Text = W.Cfg.LogoText or "SC", Font = Enum.Font.GothamBlack, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Center, Bind = { TextColor3 = "Accent" }, Parent = btn })
	end
	W.Float = btn
	local startPos, startCenter, moved = nil, nil, false
	drag(btn, function(p)
		startPos = p
		startCenter = btn.AbsolutePosition + btn.AbsoluteSize / 2
		moved = false
	end, function(p)
		if (p - startPos).Magnitude > 6 then
			moved = true
		end
		if moved then
			local vp = Library.Gui.AbsoluteSize
			local c = startCenter + (p - startPos)
			btn.Position = UDim2.fromScale(math.clamp(c.X / vp.X, 0.02, 0.98), math.clamp(c.Y / vp.Y, 0.03, 0.97))
			W.FloatMoved = true
		end
	end, function()
		if not moved then
			if W.State.Minimized or W.State.Hidden then
				W:Restore()
			else
				W:Minimize()
			end
		end
	end)
end

local function buildGrip(W)
	local grip = new("TextButton", { Name = "Grip", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3), Size = UDim2.fromOffset(16, 16), ZIndex = 8, Parent = W.Root })
	local gi = icon(grip, "move-diagonal-2", 10, "Muted")
	gi.AnchorPoint = Vector2.new(0.5, 0.5)
	gi.Position = UDim2.fromScale(0.5, 0.5)
	gi.ImageTransparency = 0.4
	local start
	drag(grip, function(p)
		if W.Cfg.Resizable == false then
			return false
		end
		start = { p = p, size = W.Root.AbsoluteSize, tl = W.Root.AbsolutePosition }
	end, function(p)
		local s = W.Scale.Scale
		local vp = Library.Gui.AbsoluteSize
		local min = W.Cfg.MinSize or Vector2.new(440, 340)
		local max = W.Cfg.MaxSize or Vector2.new(1100, 900)
		local ns = start.size + (p - start.p)
		local design = Vector2.new(math.clamp(ns.X / s, min.X, math.min(max.X, (vp.X - 8) / s)), math.clamp(ns.Y / s, min.Y, math.min(max.Y, (vp.Y - 8) / s)))
		W.Size = design
		W.Root.Size = UDim2.fromOffset(design.X, design.Y)
		local c = start.tl + design * s / 2
		W.Root.Position = UDim2.fromScale(c.X / vp.X, c.Y / vp.Y)
	end)
	grip.MouseEnter:Connect(function()
		tween(gi, 0.15, { ImageTransparency = 0 })
	end)
	grip.MouseLeave:Connect(function()
		tween(gi, 0.15, { ImageTransparency = 0.4 })
	end)
end

function Window:Connect(signal, fn)
	local c = signal:Connect(fn)
	table.insert(self.Conns, c)
	return c
end

function Window:ApplyScale()
	local vp = Library.Gui.AbsoluteSize
	local fit = 1
	if self.Cfg.AutoScale ~= false and vp.X > 0 and vp.Y > 0 then
		fit = math.max(0.35, math.min(1, (vp.X - 24) / self.Size.X, (vp.Y - 24) / self.Size.Y))
	end
	self.State.Fit = fit
	self.Scale.Scale = self.State.UserScale * fit
end

function Window:SetScale(n)
	self.State.UserScale = math.clamp(n, 0.5, 2)
	self:ApplyScale()
	self:_syncSettings()
end

function Window:_compact(fn)
	table.insert(self.Compactables, fn)
	fn(self.State.Compact)
end

function Window:SetCompact(b)
	self.State.Compact = b
	for _, fn in ipairs(self.Compactables) do
		pcall(fn, b)
	end
	self:_syncSettings()
end

function Window:_syncSettings()
	local R = self.SettingsRefs
	if not R or not R.Ready then
		return
	end
	R.Theme:Set(Library.ThemeName, true)
	R.Accent:Set(Theme.Accent, true)
	R.Compact:Set(self.State.Compact, true)
	R.Collapsed:Set(self.State.Collapsed, true)
	R.IconsOnly:Set(self.State.IconsOnly, true)
	R.Scale:Set(self.State.UserScale, true)
end

function Window:_itemMode(tab)
	local io = self.State.IconsOnly
	tab.Label.Visible = not io
	tab.IconImg.AnchorPoint = io and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5)
	tab.IconImg.Position = io and UDim2.fromScale(0.5, 0.5) or UDim2.new(0, 7, 0.5, 0)
	tab.Star.Visible = tab.Fav == true and not io
end

function Window:_layoutSide(animate)
	local st = self.State
	local io = st.IconsOnly
	local w = st.Collapsed and 0 or (io and ICON_W or SIDE_W)
	st.SideW = w
	local t = animate and 0.22 or 0
	tween(self.Sidebar, t, { Size = UDim2.new(0, w, 1, 0) })
	tween(self.Main, t, { Position = UDim2.fromOffset(w, 0), Size = UDim2.new(1, -w, 1, 0) })
	self.Title.Visible = not io
	self.Subtitle.Visible = not io
	self.Logo.Position = UDim2.fromOffset(io and 13 or 11, 12)
	local m = io and 8 or 10
	local inset = io and 16 or 24
	self.SideLine.Position = UDim2.fromOffset(m, 52)
	self.SideLine.Size = UDim2.new(1, -inset, 0, 1)
	self.TabList.Position = UDim2.fromOffset(m, 64)
	self.TabList.Size = UDim2.new(1, -inset, 1, -119)
	self.UserCard.Position = UDim2.new(0, m, 1, -47)
	self.UserCard.Size = UDim2.new(1, io and -16 or -19, 0, 37)
	self.Avatar.AnchorPoint = io and Vector2.new(0.5, 0.5) or Vector2.new(0, 0)
	self.Avatar.Position = io and UDim2.fromScale(0.5, 0.5) or UDim2.fromOffset(8, 8)
	self.UserName.Visible = not io
	self.UserInfo.Visible = not io
	for _, row in ipairs(self.Rows) do
		if row.Tab then
			self:_itemMode(row.Tab)
		elseif row.Label then
			row.Label.Visible = not io
		end
	end
	local shift = st.Collapsed and 33 or 0
	self.MenuBtn.Visible = st.Collapsed
	self.TitleGroup.Position = UDim2.fromOffset(shift, 0)
	self.TitleGroup.Size = UDim2.new(1, -(200 + shift), 1, 0)
end

function Window:SetSidebarCollapsed(b)
	self.State.Collapsed = b
	self:_layoutSide(true)
	self:_syncSettings()
end

function Window:SetIconsOnly(b)
	self.State.IconsOnly = b
	self:_layoutSide(true)
	self:_syncSettings()
end

function Window:_autoSep()
	local fr = new("Frame", { Name = "Sep", Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, LayoutOrder = #self.Rows + 1, Parent = self.TabList })
	local ln = new("Frame", { Position = UDim2.fromOffset(0, 7), Size = UDim2.new(1, 0, 0, 1), Bind = { BackgroundColor3 = "Line" }, Parent = fr })
	table.insert(self.Rows, { Kind = "sep", Auto = true, Frame = fr, Line = ln })
	self:_compact(function(on)
		fr.Size = UDim2.new(1, 0, 0, on and 9 or 15)
		ln.Position = UDim2.fromOffset(0, on and 4 or 7)
	end)
end

function Window:AddSeparator(text)
	local fr = new("Frame", { Name = "Category", Size = UDim2.new(1, 0, 0, text and 24 or 15), BackgroundTransparency = 1, LayoutOrder = #self.Rows + 1, Parent = self.TabList })
	local lbl
	if text then
		lbl = new("TextLabel", { Position = UDim2.fromOffset(7, 8), Size = UDim2.new(1, -7, 0, 14), Text = string.upper(text), TextSize = 10, Font = Enum.Font.GothamBold, Bind = { TextColor3 = "Muted" }, Parent = fr })
	else
		new("Frame", { Position = UDim2.fromOffset(0, 7), Size = UDim2.new(1, 0, 0, 1), Bind = { BackgroundColor3 = "Line" }, Parent = fr })
	end
	table.insert(self.Rows, { Kind = "cat", Frame = fr, Label = lbl })
	self:_layoutSide(false)
end

function Window:_seps()
	for i, row in ipairs(self.Rows) do
		if row.Auto then
			local a, b = self.Rows[i - 1], self.Rows[i + 1]
			local hide = (a and a.Tab and a.Tab == self.Active) or (b and b.Tab and b.Tab == self.Active)
			row.Line.Visible = not hide
		end
	end
end

function Window:AddTab(opts)
	opts = opts or {}
	local tab = setmetatable({ Window = self, Title = opts.Title or opts.Name or "Tab", Icon = opts.Icon, Subs = {} }, Tab)
	local last = self.Rows[#self.Rows]
	if last and last.Kind == "tab" then
		self:_autoSep()
	end
	local item = new("TextButton", { Name = "Tab_" .. tab.Title, Size = UDim2.new(1, 0, 0, ITEM_H), BackgroundTransparency = 1, BackgroundColor3 = Theme.Item, LayoutOrder = #self.Rows + 1, Parent = self.TabList })
	corner(item, RAD.Item)
	tab.Item = item
	tab.Indicator = new("Frame", { Name = "Indicator", AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(2, 12), Visible = false, Bind = { BackgroundColor3 = "Accent" }, Parent = item })
	corner(tab.Indicator, 1)
	tab.IconImg = icon(item, tab.Icon, 13, false)
	tab.IconImg.ImageColor3 = Theme.Muted
	tab.Label = new("TextLabel", { Position = UDim2.fromOffset(29, 0), Size = UDim2.new(1, -44, 1, 0), Text = tab.Title, TextColor3 = Theme.Muted, TextTruncate = Enum.TextTruncate.AtEnd, Parent = item })
	tab.Star = icon(item, "star", 9, "Warning")
	tab.Star.AnchorPoint = Vector2.new(1, 0.5)
	tab.Star.Position = UDim2.new(1, -7, 0.5, 0)
	tab.Star.Visible = false
	tab.Page = new("CanvasGroup", { Name = "Page_" .. tab.Title, Size = UDim2.fromScale(1, 1), Visible = false, GroupTransparency = 1, Parent = self.Pages })
	tab.Bar = new("ScrollingFrame", { Name = "SubTabs", Position = UDim2.fromOffset(14, 3), Size = UDim2.new(1, -24, 0, 28), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.X, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X, Visible = false, Parent = tab.Page })
	hlist(tab.Bar, 6)
	tab.Empty, tab.EmptyTitle, tab.EmptyDesc = emptyState(tab.Page, "inbox", "Nothing here yet", "This tab has no content.")
	table.insert(self.Tabs, tab)
	table.insert(self.Rows, { Kind = "tab", Tab = tab })
	table.insert(self.Index, { Title = tab.Title, Kind = "Tab", Path = "Navigation", Tab = tab, Frame = item, Tags = string.lower(tab.Title) })
	self:_compact(function(on)
		item.Size = UDim2.new(1, 0, 0, on and 24 or ITEM_H)
	end)
	onTheme(function()
		tab:_paint(false)
	end)
	item.MouseEnter:Connect(function()
		if self.Active ~= tab then
			tween(item, 0.12, { BackgroundTransparency = 0.6 })
		end
	end)
	item.MouseLeave:Connect(function()
		if self.Active ~= tab then
			tween(item, 0.12, { BackgroundTransparency = 1 })
		end
	end)
	item.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)
	item.MouseButton2Click:Connect(function()
		self:ToggleFavorite(tab)
	end)
	local hold = 0
	item.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			hold += 1
			local h = hold
			task.delay(0.6, function()
				if h == hold then
					self:ToggleFavorite(tab)
				end
			end)
		end
	end)
	item.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			hold += 1
		end
	end)
	attachTip(item, function()
		return self.State.IconsOnly and tab.Title or nil
	end)
	self:_itemMode(tab)
	if not self.Active then
		self:SelectTab(tab, true)
	end
	return tab
end

function Window:GetTab(name)
	for _, t in ipairs(self.Tabs) do
		if t.Title == name then
			return t
		end
	end
end

function Window:ToggleFavorite(tab, value)
	tab = type(tab) == "string" and self:GetTab(tab) or tab
	if not tab then
		return
	end
	if value == nil then
		value = not tab.Fav
	end
	tab.Fav = value
	tab.Star.Visible = value and not self.State.IconsOnly
	if value then
		Library:Notify({ Title = "Favorited", Content = tab.Title .. " added to favorites.", Type = "Info", Icon = "star", Duration = 2 })
	end
end

function Window:SelectTab(tab, instant)
	if type(tab) == "string" then
		tab = self:GetTab(tab)
	end
	if type(tab) ~= "table" or tab == self.Active then
		return
	end
	local prev = self.Active
	self.Active = tab
	for _, t in ipairs(self.Tabs) do
		t:_paint(true)
	end
	self:_seps()
	if prev then
		local pp = prev.Page
		tween(pp, 0.12, { GroupTransparency = 1 })
		task.delay(0.13, function()
			if self.Active ~= prev then
				pp.Visible = false
			end
		end)
	end
	local pg = tab.Page
	pg.Visible = true
	if instant then
		pg.GroupTransparency = 0
		pg.Position = UDim2.new()
	else
		pg.GroupTransparency = 1
		pg.Position = UDim2.fromOffset(0, 10)
		tween(pg, 0.24, { GroupTransparency = 0, Position = UDim2.new() })
	end
	for _, s in ipairs(tab.Subs) do
		s:_empty()
	end
	self.TopTitle.Text = tab.Title
	setIcon(self.TopIcon, tab.Icon)
	local r = self.Recent
	local at = table.find(r, tab)
	if at then
		table.remove(r, at)
	end
	table.insert(r, 1, tab)
	if #r > 5 then
		table.remove(r)
	end
end

function Window:_register(el, opts)
	local sec = el.Section
	local sub = sec.Sub
	local tab = sub.Tab
	local entry = {
		Title = el.Title, Kind = el.Kind, Tab = tab, Sub = sub, Frame = el.Frame,
		Path = tab.Title .. "  >  " .. sub.Title .. "  >  " .. sec.Title,
		Tags = string.lower(table.concat({ el.Title, sec.Title, tab.Title, opts.Keywords or "", opts.Tooltip or "" }, " ")),
	}
	el.Entry = entry
	table.insert(self.Index, entry)
end

function Window:Goto(e)
	self:SelectTab(e.Tab)
	if e.Kind == "Tab" or not e.Sub then
		return
	end
	e.Tab:SelectSub(e.Sub)
	task.delay(0.15, function()
		local h = e.Sub.Holder
		if e.Frame.Parent then
			local y = e.Frame.AbsolutePosition.Y - h.AbsolutePosition.Y + h.CanvasPosition.Y
			tween(h, 0.25, { CanvasPosition = Vector2.new(0, math.max(0, y - 20)) })
			flash(e.Frame)
		end
	end)
end

function Window:_openSearch()
	local S = self.Search
	tween(S.Frame, 0.2, { Size = UDim2.fromOffset(164, 27) })
	tween(S.Stroke, 0.15, { Color = Theme.Accent })
	S.Pop.Visible = true
	self:_renderSearch(S.Box.Text)
end

function Window:_closeSearch()
	local S = self.Search
	tween(S.Frame, 0.2, { Size = UDim2.fromOffset(142, 27) })
	tween(S.Stroke, 0.15, { Color = Theme.Stroke })
	S.Pop.Visible = false
end

function Window:FocusSearch()
	if self.State.Hidden or self.State.Minimized then
		self:Restore()
	end
	local tb = self.Search.Box
	tb.Text = ""
	tb:CaptureFocus()
	task.delay(0.03, function()
		if string.lower(tb.Text) == "k" then
			tb.Text = ""
		end
	end)
end

function Window:_paintSearch(scroll)
	local S = self.Search
	for i, r in ipairs(S.Rows) do
		r.Frame.BackgroundTransparency = i == S.Sel and 0 or 1
	end
	local r = S.Rows[S.Sel]
	if scroll and r then
		local y = r.Frame.AbsolutePosition.Y - S.List.AbsolutePosition.Y + S.List.CanvasPosition.Y
		S.List.CanvasPosition = Vector2.new(0, math.max(0, y - 40))
	end
end

function Window:_pickSearch(it)
	local S = self.Search
	it = it or S.Items[S.Sel]
	if not it then
		return
	end
	S.Box.Text = ""
	S.Box:ReleaseFocus()
	self:_closeSearch()
	it.Go()
end

function Window:_renderSearch(q)
	local S = self.Search
	if not S.Pop.Visible then
		return
	end
	for _, r in ipairs(S.Rows) do
		r.Frame:Destroy()
	end
	S.Rows, S.Items = {}, {}
	local items = S.Items
	if q == "" then
		for _, t in ipairs(self.Tabs) do
			if t.Fav then
				items[#items + 1] = { Title = t.Title, Kind = "Tab", Path = "Favorite", Go = function() self:SelectTab(t) end }
			end
		end
		for _, t in ipairs(self.Recent) do
			if not t.Fav and t ~= self.Active then
				items[#items + 1] = { Title = t.Title, Kind = "Tab", Path = "Recent", Go = function() self:SelectTab(t) end }
			end
		end
	else
		local lq = string.lower(q)
		local found = {}
		for _, e in ipairs(self.Index) do
			if e.Frame.Parent then
				local lt = string.lower(e.Title)
				local score
				if lt == lq then
					score = 1
				elseif string.sub(lt, 1, #lq) == lq then
					score = 2
				elseif string.find(lt, lq, 1, true) then
					score = 3
				elseif string.find(e.Tags, lq, 1, true) then
					score = 4
				end
				if score then
					found[#found + 1] = { e = e, score = score }
				end
			end
		end
		table.sort(found, function(a, b)
			if a.score ~= b.score then
				return a.score < b.score
			end
			return a.e.Title < b.e.Title
		end)
		for i = 1, math.min(#found, 12) do
			local e = found[i].e
			items[i] = { Title = e.Title, Kind = e.Kind, Path = e.Path, Go = function() self:Goto(e) end }
		end
	end
	S.Sel = 1
	S.EmptyTitle.Text = q == "" and "Search everything" or "No results"
	S.EmptyDesc.Text = q == "" and "Find settings, tabs and options. Right-click a tab to favorite it." or "Try a different keyword."
	S.Empty.Visible = #items == 0
	S.List.Visible = #items > 0
	S.Pop.Size = UDim2.fromOffset(250, #items == 0 and 96 or math.clamp(#items * 34 + 8, 60, 260))
	for i, it in ipairs(items) do
		local row = new("TextButton", { Name = "Row", Size = UDim2.new(1, -8, 0, 32), LayoutOrder = i, BackgroundTransparency = 1, BackgroundColor3 = Theme.Item, Parent = S.List })
		corner(row, RAD.Input)
		local ic = icon(row, KIND_ICON[it.Kind] or "search", 12, "Muted")
		ic.AnchorPoint = Vector2.new(0, 0.5)
		ic.Position = UDim2.new(0, 8, 0.5, 0)
		new("TextLabel", { Position = UDim2.fromOffset(28, 4), Size = UDim2.new(1, -34, 0, 14), RichText = true, Text = highlight(it.Title, q), Parent = row })
		new("TextLabel", { Position = UDim2.fromOffset(28, 18), Size = UDim2.new(1, -34, 0, 11), Text = it.Path, TextSize = 10, TextTruncate = Enum.TextTruncate.AtEnd, Bind = { TextColor3 = "Muted" }, Parent = row })
		row.MouseEnter:Connect(function()
			S.Sel = i
			self:_paintSearch(false)
		end)
		row.MouseButton1Click:Connect(function()
			self:_pickSearch(it)
		end)
		S.Rows[i] = { Frame = row }
	end
	self:_paintSearch(false)
end

function Window:_toggleQuick(v)
	local Q = self.Quick
	Q.Frame.Visible = v
	Q.Blocker.Visible = v
	if v then
		for _, f in ipairs(Q.Rows) do
			f()
		end
	end
end

function Window:_hideRoot()
	tween(self.Scale, 0.15, { Scale = self.Scale.Scale * 0.92 })
	task.delay(0.16, function()
		if self.State.Hidden or self.State.Minimized then
			self.Root.Visible = false
			self:ApplyScale()
		end
	end)
end

function Window:_showRoot()
	local target = self.State.UserScale * self.State.Fit
	self.Root.Visible = true
	self.Scale.Scale = target * 0.92
	tween(self.Scale, 0.2, { Scale = target })
end

function Window:Minimize()
	local st = self.State
	if st.Minimized then
		return
	end
	st.Minimized = true
	self:_hideRoot()
	local fb = self.Float
	if not self.FloatMoved then
		local p = self.Root.AbsolutePosition
		local vp = Library.Gui.AbsoluteSize
		fb.Position = UDim2.fromScale(math.clamp((p.X + 30) / vp.X, 0.03, 0.97), math.clamp((p.Y + 30) / vp.Y, 0.05, 0.95))
	end
	fb.Visible = true
	fb.Size = UDim2.fromOffset(0, 0)
	tween(fb, 0.3, { Size = UDim2.fromOffset(40, 40) }, Enum.EasingStyle.Back)
end

function Window:Restore()
	local st = self.State
	st.Minimized = false
	st.Hidden = false
	self:_showRoot()
	if not self.AlwaysFloat then
		self.Float.Visible = false
	end
end

function Window:Toggle()
	local st = self.State
	if st.Minimized or st.Hidden then
		self:Restore()
	else
		st.Hidden = true
		self:_hideRoot()
		if self.AlwaysFloat then
			self.Float.Visible = true
		end
	end
end

function Window:Notify(opts)
	return Library:Notify(opts)
end

function Window:Dialog(opts)
	opts = opts or {}
	local overlay = new("TextButton", { Name = "Dialog", Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK, BackgroundTransparency = 1, ZIndex = 60, Parent = self.Root })
	tween(overlay, 0.2, { BackgroundTransparency = 0.45 })
	local card = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(250, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 61, Bind = { BackgroundColor3 = "Panel" }, Parent = overlay })
	corner(card, RAD.Popup)
	stroke(card, "Stroke")
	pad(card, 14)
	vlist(card, 8)
	local sc = new("UIScale", { Scale = 0.92, Parent = card })
	tween(sc, 0.2, { Scale = 1 }, Enum.EasingStyle.Back)
	new("TextLabel", { Size = UDim2.new(1, 0, 0, 16), Text = opts.Title or "Confirm", Font = Enum.Font.GothamBold, TextSize = 13, LayoutOrder = 1, Parent = card })
	if opts.Content and opts.Content ~= "" then
		new("TextLabel", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = opts.Content, TextSize = 11, TextWrapped = true, LayoutOrder = 2, Bind = { TextColor3 = "Muted" }, Parent = card })
	end
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = 3, Parent = card })
	hlist(row, 8)
	local closed = false
	local function close(res)
		if closed then
			return
		end
		closed = true
		local at = table.find(self.Dialogs, close)
		if at then
			table.remove(self.Dialogs, at)
		end
		tween(overlay, 0.15, { BackgroundTransparency = 1 })
		tween(sc, 0.15, { Scale = 0.92 })
		task.delay(0.16, function()
			overlay:Destroy()
		end)
		if opts.Callback then
			pcall(opts.Callback, res)
		end
		if res and opts.OnConfirm then
			pcall(opts.OnConfirm)
		elseif not res and opts.OnCancel then
			pcall(opts.OnCancel)
		end
	end
	table.insert(self.Dialogs, close)
	local cancel = new("TextButton", { Size = UDim2.new(0.5, -4, 1, 0), Text = opts.CancelText or "Cancel", TextXAlignment = Enum.TextXAlignment.Center, BackgroundTransparency = 0, LayoutOrder = 1, Bind = { BackgroundColor3 = "Item", TextColor3 = "SubText" }, Parent = row })
	corner(cancel, RAD.Button)
	local ok = new("TextButton", { Size = UDim2.new(0.5, -4, 1, 0), Text = opts.ConfirmText or "Confirm", TextXAlignment = Enum.TextXAlignment.Center, BackgroundTransparency = 0, LayoutOrder = 2, TextColor3 = WHITE, Bind = { BackgroundColor3 = opts.Danger and "Danger" or "Accent" }, Parent = row })
	corner(ok, RAD.Button)
	cancel.MouseButton1Click:Connect(function()
		close(false)
	end)
	ok.MouseButton1Click:Connect(function()
		close(true)
	end)
	return { Close = close }
end

function Window:Loading(text)
	local ov = new("Frame", { Name = "Loading", Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK, BackgroundTransparency = 1, ZIndex = 70, Active = true, Parent = self.Root })
	tween(ov, 0.2, { BackgroundTransparency = 0.4 })
	local box = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1, Parent = ov })
	vlist(box, 8, Enum.HorizontalAlignment.Center)
	local sp = spinner(box, 26, 3)
	sp.LayoutOrder = 1
	local lbl = new("TextLabel", { Size = UDim2.fromOffset(0, 14), AutomaticSize = Enum.AutomaticSize.X, Text = text or "Loading...", TextXAlignment = Enum.TextXAlignment.Center, LayoutOrder = 2, Bind = { TextColor3 = "SubText" }, Parent = box })
	return {
		Stop = function()
			tween(ov, 0.15, { BackgroundTransparency = 1 })
			task.delay(0.16, function()
				ov:Destroy()
			end)
		end,
		SetText = function(t)
			lbl.Text = t
		end,
	}
end

function Window:SetTheme(name)
	if Library:SetTheme(name) then
		self:_syncSettings()
		return true
	end
	return false
end

function Window:SetAccent(color)
	Library:SetAccent(color)
	self:_syncSettings()
end

function Window:SetBackground(img, transparency)
	local bg = self.Bg
	if not img or img == "" then
		bg.Image = ""
		bg.ImageTransparency = 1
		return
	end
	local direct = type(img) == "number" or string.match(img, "^%d+$") or string.find(img, "^rbxasset") or string.find(img, "^https?:")
	if direct then
		bg.ScaleType = Enum.ScaleType.Crop
		bg.ImageColor3 = WHITE
		bg.Image = assetUrl(img)
	else
		bg.ScaleType = Enum.ScaleType.Tile
		bg.TileSize = UDim2.fromOffset(72, 72)
		bg.ImageColor3 = Theme.Accent
		setIcon(bg, img)
	end
	bg.ImageTransparency = transparency or 0.92
end

function Window:SetUser(info)
	info = info or {}
	if info.Name then
		self.UserName.Text = info.Name
	end
	if info.Info then
		self.UserInfo.Text = info.Info
	end
	if info.Avatar ~= nil or info.UserId then
		buildAvatar(self.Avatar, info.Avatar, info.UserId)
	end
end

function Window:SetToggleKey(k)
	self.ToggleKey = keyFrom(k) or self.ToggleKey
end

function Window:ListConfigs()
	local out = {}
	pcall(function()
		local folder = self.Cfg.ConfigFolder or "SCUI"
		if listfiles and isfolder and isfolder(folder) then
			for _, p in ipairs(listfiles(folder)) do
				local n = string.match(p, "([^/\\]+)%.json$")
				if n then
					out[#out + 1] = n
				end
			end
		end
	end)
	return out
end

function Window:SaveConfig(name)
	name = name or "default"
	local ok, err = pcall(function()
		local folder = self.Cfg.ConfigFolder or "SCUI"
		if makefolder and isfolder and not isfolder(folder) then
			makefolder(folder)
		end
		local st = self.State
		local data = {
			Theme = Library.ThemeName, Accent = Library.CustomAccent and Library.CustomAccent:ToHex() or nil,
			UI = { Scale = st.UserScale, Compact = st.Compact, Collapsed = st.Collapsed, IconsOnly = st.IconsOnly },
			Flags = {}, Favorites = {},
		}
		for flag, el in pairs(Library.Options) do
			if el.SaveFlag then
				local v = el:Get()
				if v ~= nil then
					data.Flags[flag] = serialize(v)
				end
			end
		end
		for _, t in ipairs(self.Tabs) do
			if t.Fav then
				table.insert(data.Favorites, t.Title)
			end
		end
		writefile(folder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
	end)
	return ok, err
end

function Window:LoadConfig(name)
	name = name or "default"
	local ok, err = pcall(function()
		local path = (self.Cfg.ConfigFolder or "SCUI") .. "/" .. name .. ".json"
		if not (isfile and isfile(path)) then
			error("config not found: " .. name)
		end
		local data = HttpService:JSONDecode(readfile(path))
		if data.Theme then
			Library:SetTheme(data.Theme)
		end
		if data.Accent then
			Library:SetAccent(Color3.fromHex(data.Accent))
		end
		for flag, val in pairs(data.Flags or {}) do
			local el = Library.Options[flag]
			if el and el.Set then
				pcall(el.Set, el, deserialize(val))
			end
		end
		for _, t in ipairs(self.Tabs) do
			t.Fav = table.find(data.Favorites or {}, t.Title) ~= nil
			t.Star.Visible = t.Fav and not self.State.IconsOnly
		end
		local ui = data.UI or {}
		if ui.Scale then
			self.State.UserScale = ui.Scale
			self:ApplyScale()
		end
		if ui.Compact ~= nil then
			self:SetCompact(ui.Compact)
		end
		if ui.Collapsed ~= nil then
			self.State.Collapsed = ui.Collapsed
		end
		if ui.IconsOnly ~= nil then
			self.State.IconsOnly = ui.IconsOnly
		end
		self:_layoutSide(true)
		self:_syncSettings()
	end)
	return ok, err
end

function Window:BuildSettingsTab(opts)
	opts = opts or {}
	local tab = self:AddTab({ Title = opts.Title or "Settings", Icon = opts.Icon or "settings" })
	local ui = tab:AddSubTab({ Title = opts.SubTitle or "Interface", Icon = "sliders-horizontal" })
	local R = {}
	self.SettingsRefs = R
	local th = ui:AddSection({ Title = "Theme", Icon = "palette", Side = "Left" })
	R.Theme = th:AddDropdown({ Title = "Theme", Values = Library.ThemeOrder, Default = Library.ThemeName, Tooltip = "Switch the interface theme.", Save = false, Callback = function(v) self:SetTheme(v) end })
	R.Accent = th:AddColorPicker({ Title = "Accent color", Default = Theme.Accent, Tooltip = "Pick a custom accent color.", Save = false, Callback = function(c) self:SetAccent(c) end })
	local win = ui:AddSection({ Title = "Window", Icon = "layout-grid", Side = "Left" })
	R.Scale = win:AddSlider({ Title = "UI scale", Min = 0.6, Max = 1.5, Increment = 0.05, Default = self.State.UserScale, Save = false, Tooltip = "Scale the whole interface.", Callback = function(v) self:SetScale(v) end })
	R.Compact = win:AddToggle({ Title = "Compact mode", Default = self.State.Compact, Save = false, Tooltip = "Tighter spacing everywhere.", Callback = function(v) self:SetCompact(v) end })
	R.Collapsed = win:AddToggle({ Title = "Hide sidebar", Default = self.State.Collapsed, Save = false, Callback = function(v) self:SetSidebarCollapsed(v) end })
	R.IconsOnly = win:AddToggle({ Title = "Sidebar icons only", Default = self.State.IconsOnly, Save = false, Callback = function(v) self:SetIconsOnly(v) end })
	R.Key = win:AddKeybind({ Title = "Menu key", Default = self.ToggleKey, Save = false, Tooltip = "Show or hide the window.", Changed = function(k) if k then self:SetToggleKey(k) end end })
	win:AddButton({ Title = "Minimize to floating button", Callback = function() self:Minimize() end })
	local bgS = ui:AddSection({ Title = "Background", Icon = "palette", Side = "Right" })
	R.BgInput = bgS:AddInput({ Title = "Image or icon", Placeholder = "rbxassetid or icon name", Save = false, Tooltip = "Use an asset id, or an icon name from the icon provider.", Callback = function(t) self:SetBackground(t, 1 - R.Opacity:Get() / 100) end })
	R.Opacity = bgS:AddSlider({ Title = "Opacity", Min = 0, Max = 100, Default = 8, Suffix = "%", Save = false, Callback = function(v) self:SetBackground(R.BgInput:Get(), 1 - v / 100) end })
	bgS:AddButton({ Title = "Clear background", Callback = function() R.BgInput:Set("", true) self:SetBackground(nil) end })
	local cfgS = ui:AddSection({ Title = "Config", Icon = "folder-cog", Side = "Right" })
	R.CfgName = cfgS:AddInput({ Title = "Config name", Default = "default", Save = false })
	R.CfgList = cfgS:AddDropdown({ Title = "Saved configs", Values = self:ListConfigs(), Placeholder = "None found", Save = false, Callback = function(v) if v then R.CfgName:Set(v, true) end end })
	cfgS:AddButton({ Title = "Save config", Style = "Accent", Callback = function()
		local ok, err = self:SaveConfig(R.CfgName:Get())
		R.CfgList:SetValues(self:ListConfigs())
		Library:Notify({ Title = ok and "Config saved" or "Save failed", Content = ok and tostring(R.CfgName:Get()) or tostring(err), Type = ok and "Success" or "Error" })
	end })
	cfgS:AddButton({ Title = "Load config", Callback = function()
		local ok, err = self:LoadConfig(R.CfgName:Get())
		Library:Notify({ Title = ok and "Config loaded" or "Load failed", Content = ok and tostring(R.CfgName:Get()) or tostring(err), Type = ok and "Success" or "Error" })
	end })
	R.Ready = true
	return tab
end

function Window:Destroy()
	for _, c in ipairs(self.Conns) do
		c:Disconnect()
	end
	self.Root:Destroy()
	self.Float:Destroy()
	local at = table.find(Library.Windows, self)
	if at then
		table.remove(Library.Windows, at)
	end
end

local function bindInput(W)
	local st = W.State
	W:Connect(W.Root.MouseEnter, function()
		st.Hover = true
	end)
	W:Connect(W.Root.MouseLeave, function()
		st.Hover = false
	end)
	W:Connect(UserInputService.InputBegan, function(input)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		local k = input.KeyCode
		local typing = UserInputService:GetFocusedTextBox() ~= nil
		local ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftMeta) or UserInputService:IsKeyDown(Enum.KeyCode.RightMeta)
		if k == W.ToggleKey and not typing then
			W:Toggle()
			return
		end
		if st.Hidden or st.Minimized then
			return
		end
		if ctrl and k == Enum.KeyCode.K then
			W:FocusSearch()
			return
		end
		if ctrl and k == Enum.KeyCode.B and not typing then
			W:SetSidebarCollapsed(not st.Collapsed)
			return
		end
		local S = W.Search
		if k == Enum.KeyCode.Escape then
			if #W.Dialogs > 0 then
				W.Dialogs[#W.Dialogs](false)
			elseif S.Box:IsFocused() then
				S.Box:ReleaseFocus()
			elseif W.Quick.Frame.Visible then
				W:_toggleQuick(false)
			end
			return
		end
		if S.Box:IsFocused() then
			local n = #S.Items
			if n > 0 and (k == Enum.KeyCode.Down or k == Enum.KeyCode.Up) then
				S.Sel = ((S.Sel - 1 + (k == Enum.KeyCode.Down and 1 or -1)) % n) + 1
				W:_paintSearch(true)
			end
			return
		end
		if typing or not st.Hover or #W.Tabs == 0 then
			return
		end
		local tabs = W.Tabs
		local i = table.find(tabs, W.Active) or 1
		if k == Enum.KeyCode.Up then
			W:SelectTab(tabs[(i - 2) % #tabs + 1])
		elseif k == Enum.KeyCode.Down then
			W:SelectTab(tabs[i % #tabs + 1])
		elseif (k == Enum.KeyCode.Left or k == Enum.KeyCode.Right) and W.Active then
			local subs = {}
			for _, s in ipairs(W.Active.Subs) do
				if s.Explicit then
					subs[#subs + 1] = s
				end
			end
			if #subs > 1 then
				local j = table.find(subs, W.Active.ActiveSub) or 1
				W.Active:SelectSub(subs[(j - 1 + (k == Enum.KeyCode.Right and 1 or -1)) % #subs + 1])
			end
		end
	end)
end

function Library:CreateWindow(cfg)
	cfg = cfg or {}
	ensureGui()
	if cfg.IconPack then
		Library.IconProvider.DefaultIconPack = cfg.IconPack
	end
	if cfg.Theme then
		Library:SetTheme(cfg.Theme)
	end
	if cfg.Accent then
		Library:SetAccent(cfg.Accent)
	end
	local W = setmetatable({
		Cfg = cfg, Tabs = {}, Rows = {}, Index = {}, Recent = {}, Conns = {}, Compactables = {}, Dialogs = {},
		ToggleKey = keyFrom(cfg.ToggleKey) or Enum.KeyCode.RightShift,
		State = {
			Collapsed = cfg.SidebarCollapsed == true, IconsOnly = cfg.IconsOnly == true, Compact = false,
			Minimized = false, Hidden = false, UserScale = cfg.Scale or 1, Fit = 1, Hover = false, SideW = SIDE_W,
		},
	}, Window)
	buildRoot(W)
	buildSidebar(W)
	buildMain(W)
	buildSearch(W)
	buildFloat(W)
	buildGrip(W)
	bindInput(W)
	if cfg.Background then
		W:SetBackground(cfg.Background, cfg.BackgroundTransparency)
	end
	W:Connect(Library.Gui:GetPropertyChangedSignal("AbsoluteSize"), function()
		W:ApplyScale()
	end)
	W.AlwaysFloat = cfg.FloatingButton == true or (cfg.FloatingButton == nil and UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)
	W.Float.Visible = W.AlwaysFloat
	if cfg.Compact then
		W:SetCompact(true)
	end
	W:_layoutSide(false)
	table.insert(Library.Windows, W)
	return W
end

function Library:Unload()
	for _, w in ipairs(Library.Windows) do
		for _, c in ipairs(w.Conns) do
			c:Disconnect()
		end
	end
	for _, c in ipairs(Library.Connections) do
		c:Disconnect()
	end
	Library.Windows = {}
	if Library.Gui then
		Library.Gui:Destroy()
	end
end

return Library
