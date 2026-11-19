-- ============================================================================
-- SCUIExample.lua
-- Demo script for SCUIsource.lua (the "sportsclub" fishing window replica).
--
-- Layout of the demo:
--   Fishing   -> exact replica of the reference screenshot
--   Movement  -> sliders, toggles, keybinds, inputs
--   Visuals   -> color pickers, multi dropdown, progress bar
--   Shop      -> empty states + loading indicator
--   Misc      -> labels, paragraphs, dividers, toasts, dialogs, loading
--   Chat      -> tab-level empty state
--   Settings  -> auto-built (theme, accent, scale, compact, background, config)
--
-- NOTE: every callback below only stores values / shows feedback. Plug your own
-- game logic into the marked "YOUR LOGIC HERE" spots.
-- ============================================================================

-- Load the library. Pick ONE of these:
local SCUI = loadstring(game:HttpGet'https://pastefy.app/5GB6TEkY/raw')()

-- Plain table that mirrors every setting. Read from it inside your own loops.
local Config = {
	AutoFish = true,
	Mode = "Legit",
	LoopDelay = 0.55,
	CastPower = 0.5,
	AutoPerfectThrow = false,
	PerfectMode = "Legit",
	PerfectChance = 100,
	MinigameSpeed = "Normal",
	HumanDelayMin = 0.04,
	HumanDelayMax = 0.12,
	AutoSell = false,
}

-- ============================================================================
-- CORNER SHARPNESS (optional)
-- Lower numbers = sharper corners, 0 = perfectly square. These must be set
-- BEFORE the window is created. The defaults already match the screenshot.
-- ============================================================================
-- SCUI.Radius.Window = 4
-- SCUI.Radius.Card = 3
-- SCUI.Radius.Input = 3    -- dropdowns, inputs, search box
-- SCUI.Radius.Button = 3
-- SCUI.Radius.Item = 3     -- sidebar tabs, user card

-- ============================================================================
-- WINDOW
-- ============================================================================
local Window = SCUI:CreateWindow({
	Title = "sportsclub",             -- big text in the sidebar header
	Subtitle = "Game Name",           -- small gray text under the title
	LogoText = "SC",                  -- text logo (use Logo = "rbxassetid://ID" for an image)

	-- The screenshot is huge because it was captured on a high-DPI screen.
	-- This is the same layout scaled down to a sane size (561 x 543).
	Size = UDim2.fromOffset(561, 543),
	MinSize = Vector2.new(440, 340),  -- smallest size when resizing
	MaxSize = Vector2.new(1100, 900), -- biggest size when resizing

	Theme = "Sportsclub",             -- Sportsclub, Midnight, Amoled, Ocean, Rose, Emerald, Violet, Light
	Scale = 1,                        -- UI scale (also adjustable in Settings)
	AutoScale = true,                 -- shrink automatically on small screens / phones
	ToggleKey = Enum.KeyCode.RightShift, -- show / hide the window
	ActiveIndicator = true,           -- little accent bar on the active tab
	IconsOnly = false,                -- start with the compact icon-only sidebar
	Compact = false,                  -- start in compact spacing mode
	FloatingButton = nil,             -- nil = auto (shown on touch devices), true / false to force

	-- Optional background: an asset id or an icon name from the icon provider.
	-- Background = "rbxassetid://0",
	-- BackgroundTransparency = 0.92,

	-- Bottom-left card in the sidebar. The picture is YOUR Roblox avatar headshot by default.
	--   Avatar = "rbxassetid://ID"  -> custom image
	--   Avatar = false              -> the little yellow emoji face from the screenshot
	--   UserId = 1234               -> show another player's headshot
	User = { Name = "Lifetime", Info = "Premium  Yes" },

	ConfigFolder = "SportsClub",      -- folder used by Save / Load config
})


-- ============================================================================
-- SIDEBAR TABS (icons come from the Lucide pack by default)
-- Other packs work too:  Icon = "Material:home"  /  "Phosphor:fish"  /  "SF:gear"
-- ============================================================================
local Fishing  = Window:AddTab({ Title = "Fishing",  Icon = "fish" })
local Movement = Window:AddTab({ Title = "Movement", Icon = "footprints" })
local Visuals  = Window:AddTab({ Title = "Visuals",  Icon = "eye" })
local Shop     = Window:AddTab({ Title = "Shop",     Icon = "coins" })
local Misc     = Window:AddTab({ Title = "Misc",     Icon = "layers" })
local Chat     = Window:AddTab({ Title = "Chat",     Icon = "messages-square" })

-- Thin lines between the tabs are added automatically.
-- Want a labelled category header instead? Uncomment:
-- Window:AddSeparator("Extras")

-- ============================================================================
-- FISHING  (exact replica of the screenshot)
-- ============================================================================

-- A sub-tab is the chip row under the title ("Auto Fish" in the screenshot).
local AutoFishPage = Fishing:AddSubTab({ Title = "Auto Fish", Icon = "fish" })

-- LEFT CARD -------------------------------------------------------------------
local AutoFish = AutoFishPage:AddSection({
	Title = "Auto Fish",
	Icon = "fish",
	Side = "Left", -- "Left" or "Right"
})

AutoFish:AddToggle({
	Title = "Enabled",
	Default = true,
	Flag = "AutoFishEnabled",          -- flags are saved / loaded by the config system
	Tooltip = "Master switch for the auto fish loop.", -- hover (or hold on mobile) to see it
	Callback = function(value)
		Config.AutoFish = value
		-- YOUR LOGIC HERE: start / stop your loop
	end,
})

AutoFish:AddDropdown({
	Title = "Mode",
	Values = { "Legit", "Rage" },
	Default = "Legit",
	Flag = "AutoFishMode",
	Callback = function(value)
		Config.Mode = value
	end,
})

AutoFish:AddSlider({
	Title = "Loop Delay",
	Min = 0.1,
	Max = 2.3,       -- chosen so the knob sits exactly where it does in the screenshot
	Increment = 0.05,
	Default = 0.55,
	Flag = "LoopDelay",
	Callback = function(value)
		Config.LoopDelay = value
	end,
})

AutoFish:AddSlider({
	Title = "Cast Power",
	Min = 0.1,
	Max = 1,
	Increment = 0.1,
	Default = 0.5,
	Flag = "CastPower",
	Callback = function(value)
		Config.CastPower = value
	end,
})

-- RIGHT COLUMN: "Throw / Minigame" -------------------------------------------
local Throw = AutoFishPage:AddSection({
	Title = "Throw / Minigame",
	Icon = "fish",
	Side = "Right",
})

Throw:AddToggle({
	Title = "Auto Perfect Throw",
	Default = false, -- off toggles dim their label, on toggles brighten it
	Flag = "AutoPerfectThrow",
	Callback = function(value)
		Config.AutoPerfectThrow = value
	end,
})

Throw:AddDropdown({
	Title = "Perfect Mode",
	Values = { "Legit", "Perfect" },
	Default = "Legit",
	Flag = "PerfectMode",
	Callback = function(value)
		Config.PerfectMode = value
	end,
})

Throw:AddSlider({
	Title = "Perfect Chance",
	Min = 0,
	Max = 100,
	Increment = 1,
	Default = 100,
	Flag = "PerfectChance",
	Callback = function(value)
		Config.PerfectChance = value
	end,
})

Throw:AddDropdown({
	Title = "Minigame Speed",
	Values = { "Normal", "Fast", "Instant" },
	Default = "Normal",
	Open = true, -- starts expanded like the screenshot; remove this line to start closed
	Flag = "MinigameSpeed",
	Callback = function(value)
		Config.MinigameSpeed = value
	end,
})

Throw:AddSlider({
	Title = "Human Delay Min",
	Min = 0,
	Max = 0.25,
	Increment = 0.01,
	Default = 0.04,
	Flag = "HumanDelayMin",
	Callback = function(value)
		Config.HumanDelayMin = value
	end,
})

Throw:AddSlider({
	Title = "Human Delay Max",
	Min = 0,
	Max = 0.33,
	Increment = 0.01,
	Default = 0.12,
	Flag = "HumanDelayMax",
	Callback = function(value)
		Config.HumanDelayMax = value
	end,
})

-- RIGHT COLUMN: "Sell" --------------------------------------------------------
local Sell = AutoFishPage:AddSection({
	Title = "Sell",
	Icon = "fish",
	Side = "Right",
})

Sell:AddToggle({
	Title = "Auto Sell",
	Default = false,
	Flag = "AutoSell",
	Callback = function(value)
		Config.AutoSell = value
	end,
})

Sell:AddButton({
	Title = "Sell All Now",
	-- Confirm = true shows a confirmation dialog before the callback runs.
	-- You can also pass a table: Confirm = { Title = "...", Content = "..." }
	Callback = function()
		-- YOUR LOGIC HERE: sell everything
		SCUI:Notify({ Title = "Sell", Content = "Sell request sent.", Type = "Success" })
	end,
})

-- ============================================================================
-- MOVEMENT  (sliders, keybinds, inputs)
-- ============================================================================
local Speed = Movement:AddSubTab({ Title = "Speed", Icon = "footprints" })
local Walk = Speed:AddSection({ Title = "Walk", Icon = "footprints", Side = "Left" })

Walk:AddSlider({
	Title = "Walk Speed",
	Min = 16,
	Max = 120,
	Default = 16,
	Suffix = " st/s",   -- text added after the value
	Callback = function(value)
		-- YOUR LOGIC HERE
	end,
})

Walk:AddToggle({
	Title = "Infinite Jump",
	Default = false,
	Callback = function(value) end,
})

Walk:AddKeybind({
	Title = "Toggle Key",
	Default = Enum.KeyCode.F,
	Mode = "Toggle",       -- "Press", "Toggle" or "Hold"
	Tooltip = "Click it, then press a key. Esc or Backspace clears it.",
	Callback = function(state)
		print("keybind state:", state)
	end,
})

local Teleport = Speed:AddSection({ Title = "Teleport", Icon = "move", Side = "Right" })

Teleport:AddInput({
	Title = "Spot name",
	Placeholder = "type something...",
	Callback = function(text)
		print("input:", text)
	end,
})

Teleport:AddInput({
	Title = "Delay (numeric)",
	Default = 1,
	Numeric = true,   -- only accepts numbers
	Min = 0,
	Max = 10,
	Callback = function(n)
		print("numeric input:", n)
	end,
})

Teleport:AddButton({
	Title = "Teleport (with confirmation)",
	Style = "Danger", -- "Default", "Accent" or "Danger"
	Confirm = { Title = "Teleport?", Content = "You will be moved to the selected spot." },
	Callback = function()
		SCUI:Notify({ Title = "Teleport", Content = "Confirmed.", Type = "Info" })
	end,
})

-- ============================================================================
-- VISUALS  (color pickers, multi dropdown, progress bar)
-- ============================================================================
local Overlay = Visuals:AddSubTab({ Title = "Overlay", Icon = "eye" })
local Look = Overlay:AddSection({ Title = "Look", Icon = "palette", Side = "Left" })

Look:AddColorPicker({
	Title = "Highlight color",
	Default = Color3.fromRGB(10, 132, 255),
	Flag = "HighlightColor",
	Callback = function(color)
		-- color is a Color3
	end,
})

Look:AddMultiDropdown({
	Title = "Elements",
	Values = { "Boxes", "Names", "Distance", "Health" },
	Default = { "Boxes", "Names" },
	Flag = "Elements",
	Callback = function(list)
		print("selected:", table.concat(list, ", "))
	end,
})

local Stats = Overlay:AddSection({ Title = "Progress", Icon = "activity", Side = "Right" })
local Bar = Stats:AddProgressBar({ Title = "Session goal", Min = 0, Max = 100, Default = 35 })

Stats:AddButton({
	Title = "Add 10%",
	Callback = function()
		Bar:Set(math.min(100, Bar:Get() + 10))
	end,
})

-- ============================================================================
-- SHOP  (empty states + loading indicator)
-- ============================================================================
-- A sub-tab without sections shows an empty state automatically.
local Items = Shop:AddSubTab({ Title = "Items", Icon = "coins" })
Items:SetEmptyText("No items yet", "Items will appear here once the shop loads.")

local Upgrades = Shop:AddSubTab({ Title = "Upgrades", Icon = "sparkles" })
local UpgradeCard = Upgrades:AddSection({ Title = "Upgrades", Icon = "sparkles", Side = "Left" })

-- A section with no elements shows a small hint, or add a custom empty state:
UpgradeCard:AddEmptyState({ Icon = "inbox", Title = "Nothing to buy", Content = "Come back later." })

UpgradeCard:AddButton({
	Title = "Load shop",
	Callback = function()
		-- Window:Loading() dims the window and shows a spinner until you call Stop().
		local loader = Window:Loading("Loading shop...")
		task.delay(1.5, function()
			loader.Stop()
			SCUI:Notify({ Title = "Shop", Content = "Loaded.", Type = "Success" })
		end)
	end,
})

-- ============================================================================
-- MISC  (display components + toasts + dialogs)
-- ============================================================================
local Components = Misc:AddSubTab({ Title = "Components", Icon = "layers" })
local Display = Components:AddSection({ Title = "Display", Icon = "type", Side = "Left" })

Display:AddLabel({ Text = "A plain label. Great for short status text." })
Display:AddDivider({})
Display:AddDivider({ Text = "PARAGRAPH" })
Display:AddParagraph({
	Title = "About",
	Content = "Paragraphs wrap automatically and are good for longer descriptions.",
})

local Feedback = Components:AddSection({ Title = "Feedback", Icon = "bell", Side = "Right" })

-- Toasts: Type = "Info" | "Success" | "Warning" | "Error"
Feedback:AddButton({
	Title = "Info toast",
	Callback = function()
		SCUI:Notify({ Title = "Heads up", Content = "This is an info toast.", Type = "Info", Duration = 4 })
	end,
})

Feedback:AddButton({
	Title = "Warning toast",
	Callback = function()
		SCUI:Notify({ Title = "Careful", Content = "Something needs attention.", Type = "Warning" })
	end,
})

-- Confirmation dialog, called directly
Feedback:AddButton({
	Title = "Open dialog",
	Style = "Accent",
	Callback = function()
		Window:Dialog({
			Title = "Reset settings?",
			Content = "This restores every option to its default value.",
			ConfirmText = "Reset",
			CancelText = "Keep",
			Danger = true,
			Callback = function(confirmed)
				SCUI:Notify({ Title = confirmed and "Reset" or "Cancelled", Type = confirmed and "Success" or "Info" })
			end,
		})
	end,
})

-- ============================================================================
-- CHAT  (tab with no content -> tab-level empty state)
-- ============================================================================
Chat:SetEmptyText("No messages", "Chat features are coming soon.")

-- ============================================================================
-- SETTINGS  (generated: theme selector, accent picker, UI scale, compact mode,
-- sidebar collapse / icons only, menu key, background, config save / load)
-- ============================================================================
Window:BuildSettingsTab({ Title = "Settings", Icon = "settings" })

-- ============================================================================
-- FINISH
-- ============================================================================
Window:SelectTab("Fishing")

SCUI:Notify({
	Title = "sportsclub",
	Content = "Press Ctrl + K to search. Right-click a tab to favorite it.",
	Type = "Info",
	Duration = 5,
})

-- Handy API reference:
--   Window:SetTheme("Ocean")             Window:SetAccent(Color3.fromRGB(255, 80, 120))
--   Window:SetScale(0.9)                 Window:SetCompact(true)
--   Window:SetSidebarCollapsed(true)     Window:SetIconsOnly(true)
--   Window:Minimize() / Restore()        Window:Toggle()
--   Window:ToggleFavorite("Fishing")     Window:SetBackground("rbxassetid://0", 0.9)
--   Window:SaveConfig("name")            Window:LoadConfig("name")
--   Window:Destroy()                     SCUI:Unload()
