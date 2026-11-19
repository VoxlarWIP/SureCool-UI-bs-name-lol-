# SCUI

A dark, compact Roblox UI library modeled on the **sportsclub** fishing window: sidebar navigation, sub-tab chips, two-column cards, inline dropdowns, thin sliders with block knobs, and a profile card with your Roblox avatar.

SCUI is **UI only**. It contains no game logic. Every callback is yours to fill in.

- [Features](#features)
- [Install](#install)
- [Quick start](#quick-start)
- [Window options](#window-options)
- [Components](#components)
- [Window API](#window-api)
- [Tabs, sub-tabs and sections](#tabs-sub-tabs-and-sections)
- [Notifications, dialogs and loading](#notifications-dialogs-and-loading)
- [Themes and corner sharpness](#themes-and-corner-sharpness)
- [Icons](#icons)
- [Flags and configs](#flags-and-configs)
- [Keyboard and touch](#keyboard-and-touch)
- [Project layout](#project-layout)
- [Troubleshooting](#troubleshooting)
- [Status](#status)
- [License](#license)

---

## Features

### UI components

| Feature | Notes |
|---|---|
| Search bar | Searches every tab and element. Matches are highlighted and the element flashes when you jump to it. |
| Sidebar collapse | Hide or show navigation completely. |
| Sidebar icons only | Compact navigation mode. |
| Draggable window | Drag from the top bar or the sidebar header. |
| Resizable window | Grip in the bottom-right corner, with min and max limits. |
| Minimize | Collapses into a draggable floating button (built for mobile). |
| UI scale | Adjustable scale, plus automatic shrink-to-fit on small screens. |
| Notification toasts | Info, Success, Warning, Error, with a progress line and click to dismiss. |
| Confirmation dialog | Modal confirm / cancel, with a danger style. |
| Tooltips | Hover on desktop, press and hold on touch. |
| Loading indicators | Window overlay spinner and per-button spinner. |
| Empty states | Tabs, sub-tabs and sections with no content show a friendly placeholder. |

### Customization

- Theme selector (8 built-in themes, add your own)
- Accent color picker
- Background customization (an `rbxassetid` or an icon name from the icon provider)
- Compact mode
- Adjustable corner sharpness

### Navigation

- Active tab indicator
- Animated tab transitions
- Category separators
- Recently used tabs
- Favorite tabs (right-click, or press and hold on touch)
- Keyboard navigation
- Search result highlighting

### Components

Toggle, Slider, Dropdown, Multi Dropdown, Keybind, Color Picker, Input, Button, Divider, Label, Paragraph, Progress Bar, and Tab (sub-tab chips).

---

## Install

Copy `SCUIsource.lua` into your executor's workspace folder and load it:

```lua
local SCUI = loadstring(readfile("SCUIsource.lua"))()
```

Or host it on GitHub and load it from the raw URL:

```lua
local SCUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/SCUI/main/SCUIsource.lua"))()
```

**Requirements**

| Needed for | Functions |
|---|---|
| Loading the library | `loadstring` and `readfile` or `game:HttpGet` |
| Icons | `game:HttpGet` and `loadstring` (icons load a moment after the UI appears) |
| Config save / load | `writefile`, `readfile`, `isfile`, `makefolder`, `listfiles` |
| Hidden UI parent | `gethui` (falls back to `CoreGui`, then `PlayerGui`) |

---

## Quick start

```lua
local SCUI = loadstring(readfile("SCUIsource.lua"))()

local Window = SCUI:CreateWindow({
	Title = "sportsclub",
	Subtitle = "Game Name",
	LogoText = "SC",
	User = { Name = "Lifetime", Info = "Premium  Yes" },
})

local Fishing = Window:AddTab({ Title = "Fishing", Icon = "fish" })
local Page = Fishing:AddSubTab({ Title = "Auto Fish", Icon = "fish" })
local Card = Page:AddSection({ Title = "Auto Fish", Icon = "fish", Side = "Left" })

Card:AddToggle({
	Title = "Enabled",
	Default = true,
	Callback = function(value)
		print("enabled:", value)
	end,
})

Card:AddSlider({
	Title = "Loop Delay",
	Min = 0.1,
	Max = 2.3,
	Increment = 0.05,
	Default = 0.55,
	Callback = function(value)
		print("delay:", value)
	end,
})

Window:BuildSettingsTab()
```

`SCUIExample.lua` is a complete, commented demo that rebuilds the whole reference window and shows every component.

---

## Window options

Pass these to `SCUI:CreateWindow({ ... })`.

| Option | Type | Default | Description |
|---|---|---|---|
| `Title` | string | `"SCUI"` | Bold text in the sidebar header. |
| `Subtitle` | string | `""` | Gray text under the title. |
| `Logo` | string / number | none | Image id for the header logo. |
| `LogoText` | string | `"SC"` | Text logo when no image is set. |
| `Size` | UDim2 | `fromOffset(561, 543)` | Design size (offset units). |
| `MinSize` / `MaxSize` | Vector2 | `440x340` / `1100x900` | Resize limits. |
| `Resizable` | boolean | `true` | Set `false` to hide the resize grip. |
| `Theme` | string | `"Sportsclub"` | Starting theme. |
| `Accent` | Color3 | theme accent | Override the accent color. |
| `Scale` | number | `1` | User UI scale. |
| `AutoScale` | boolean | `true` | Shrink automatically to fit small screens. |
| `ToggleKey` | KeyCode / string | `RightShift` | Show or hide the window. |
| `ActiveIndicator` | boolean | `true` | Accent bar on the active tab. Set `false` for the plainest look. |
| `IconsOnly` | boolean | `false` | Start with the icon-only sidebar. |
| `SidebarCollapsed` | boolean | `false` | Start with the sidebar hidden. |
| `Compact` | boolean | `false` | Start in compact spacing mode. |
| `FloatingButton` | boolean / nil | `nil` | `nil` shows the floating button on touch devices only. |
| `Background` | string / number | none | An asset id or an icon name. |
| `BackgroundTransparency` | number | `0.92` | Background image transparency. |
| `User` | table | none | Bottom-left card. See below. |
| `ConfigFolder` | string | `"SCUI"` | Folder used by config save / load. |
| `IconPack` | string | `"Lucide"` | Default icon pack. |

**User card**

```lua
User = {
	Name = "Lifetime",
	Info = "Premium  Yes",
	-- The picture is your Roblox avatar headshot by default.
	-- Avatar = "rbxassetid://ID"   custom image
	-- Avatar = false               the little yellow emoji face
	-- UserId = 1234                another player's headshot
}
```

---

## Components

Add components to a section: `Section:AddToggle({ ... })`, `Section:AddSlider({ ... })`, and so on.

Every component also accepts these common options:

| Option | Description |
|---|---|
| `Title` | Label text. |
| `Callback` | Function called when the value changes. |
| `Flag` | Name used in `SCUI.Flags` / `SCUI.Options` and in saved configs. |
| `Tooltip` | Text shown on hover (desktop) or press and hold (touch). |
| `Keywords` | Extra words the search should match. |
| `Save` | Set `false` to exclude the component from configs. |

Every component returns an object with `:Get()`, `:Set(value, silent)`, `:OnChanged(fn)`, `:SetVisible(bool)`, `:SetTooltip(text)` and `:Destroy()`. Passing `silent = true` to `:Set` skips the callback.

| Component | Method | Options | Callback receives |
|---|---|---|---|
| Toggle | `AddToggle` | `Default` (boolean) | `boolean` |
| Slider | `AddSlider` | `Min`, `Max`, `Increment`, `Default`, `Suffix` | `number` |
| Dropdown | `AddDropdown` | `Values`, `Default`, `Placeholder`, `Open` | `string` |
| Multi Dropdown | `AddMultiDropdown` | `Values`, `Default` (table), `Placeholder` | `table` of strings |
| Keybind | `AddKeybind` | `Default`, `Mode` (`Press`, `Toggle`, `Hold`), `Changed(key)` | `boolean` (pressed state) |
| Color Picker | `AddColorPicker` | `Default` (Color3) | `Color3` |
| Input | `AddInput` | `Placeholder`, `Default`, `Numeric`, `Min`, `Max`, `Live` | `string` or `number` |
| Button | `AddButton` | `Style` (`Default`, `Accent`, `Danger`), `Confirm` | none |
| Divider | `AddDivider` | `Text` (optional) | none |
| Label | `AddLabel` | `Text`, `RichText` | none |
| Paragraph | `AddParagraph` | `Title`, `Content` | none |
| Progress Bar | `AddProgressBar` | `Min`, `Max`, `Default`, `Suffix`, `ShowValue` | none |
| Empty State | `AddEmptyState` | `Icon`, `Title`, `Content` | none |

Extra methods:

| Component | Method |
|---|---|
| Dropdown / Multi Dropdown | `:SetValues(list)`, `:Open(bool)` |
| Button | `:SetText(text)`, `:SetLoading(bool)` |
| Label | `:SetText(text)` |
| Paragraph | `:SetTitle(text)`, `:SetContent(text)` |
| Progress Bar | `:Set(value)` animates the fill |

**Button with confirmation**

```lua
Section:AddButton({
	Title = "Reset everything",
	Style = "Danger",
	Confirm = { Title = "Reset?", Content = "This cannot be undone." },
	Callback = function()
		print("confirmed")
	end,
})
```

**Dropdown that starts open (like the reference screenshot)**

```lua
Section:AddDropdown({
	Title = "Minigame Speed",
	Values = { "Normal", "Fast", "Instant" },
	Default = "Normal",
	Open = true,
})
```

---

## Window API

| Method | Description |
|---|---|
| `Window:AddTab({ Title, Icon })` | Adds a sidebar tab. |
| `Window:AddSeparator(text?)` | Adds a category separator, with an optional label. Thin lines between tabs are added automatically. |
| `Window:SelectTab(tabOrName)` | Switches tab. |
| `Window:GetTab(name)` | Returns a tab by title. |
| `Window:ToggleFavorite(tabOrName, value?)` | Favorites or unfavorites a tab. |
| `Window:BuildSettingsTab({ Title, Icon, SubTitle })` | Builds a ready-made settings tab (theme, accent, scale, compact, sidebar, menu key, background, config). |
| `Window:SetTheme(name)` | Switches theme. |
| `Window:SetAccent(color3)` | Sets a custom accent. |
| `Window:SetScale(n)` | Sets UI scale (0.5 to 2). |
| `Window:SetCompact(bool)` | Compact spacing. |
| `Window:SetSidebarCollapsed(bool)` | Hides or shows the sidebar. |
| `Window:SetIconsOnly(bool)` | Icon-only sidebar. |
| `Window:SetBackground(imageOrIcon, transparency)` | Sets or clears (`nil`) the background. |
| `Window:SetUser({ Name, Info, Avatar, UserId })` | Updates the profile card. |
| `Window:SetToggleKey(key)` | Changes the show / hide key. |
| `Window:Minimize()` / `Restore()` / `Toggle()` | Window visibility. |
| `Window:FocusSearch()` | Focuses the search bar. |
| `Window:Notify(opts)` | Same as `SCUI:Notify`. |
| `Window:Dialog(opts)` | Confirmation dialog. |
| `Window:Loading(text)` | Overlay spinner. Returns `{ Stop, SetText }`. |
| `Window:SaveConfig(name)` / `LoadConfig(name)` | Returns `ok, err`. |
| `Window:ListConfigs()` | Returns a list of saved config names. |
| `Window:Destroy()` | Removes the window. |
| `SCUI:Unload()` | Removes every window, connection and notification. |

---

## Tabs, sub-tabs and sections

```
Window
 +-- Tab (sidebar item)
      +-- SubTab (chip row under the title, e.g. "Auto Fish")
           +-- Section (card, Side = "Left" or "Right")
                +-- Components
```

```lua
local Tab = Window:AddTab({ Title = "Fishing", Icon = "fish" })
local Sub = Tab:AddSubTab({ Title = "Auto Fish", Icon = "fish" })
local Card = Sub:AddSection({ Title = "Throw / Minigame", Icon = "fish", Side = "Right" })
```

- `Tab:AddSection(opts)` adds to the tab's last sub-tab (it creates one if needed).
- A sub-tab with no sections shows an empty state. Change its text with `Sub:SetEmptyText(title, desc)`.
- A tab with no sub-tabs shows a tab-level empty state. Change it with `Tab:SetEmptyText(title, desc)`.
- A section with no components shows a small "Nothing here yet" hint.
- If you leave out `Side`, sections alternate between left and right.

---

## Notifications, dialogs and loading

```lua
SCUI:Notify({
	Title = "Saved",
	Content = "Config written.",
	Type = "Success",   -- Info, Success, Warning, Error
	Duration = 4,
	-- Icon = "star",
})

Window:Dialog({
	Title = "Reset settings?",
	Content = "This restores every option to its default value.",
	ConfirmText = "Reset",
	CancelText = "Keep",
	Danger = true,
	Callback = function(confirmed)
		print(confirmed)
	end,
})

local loader = Window:Loading("Loading...")
task.delay(1.5, function()
	loader.Stop()
end)
```

---

## Themes and corner sharpness

Built-in themes: `Sportsclub`, `Midnight`, `Amoled`, `Ocean`, `Rose`, `Emerald`, `Violet`, `Light`.

```lua
Window:SetTheme("Ocean")
Window:SetAccent(Color3.fromRGB(255, 80, 120))
```

**Custom theme**

Any key you leave out is copied from `Sportsclub`.

```lua
SCUI:AddTheme("Mine", {
	Background = Color3.fromRGB(8, 8, 10),
	Panel = Color3.fromRGB(14, 14, 16),
	Accent = Color3.fromRGB(255, 160, 40),
})
Window:SetTheme("Mine")
```

Theme keys: `Background`, `Panel`, `PanelHeader`, `Item`, `Input`, `Stroke`, `Line`, `Accent`, `Text`, `SubText`, `Muted`, `Track`, `Knob`, `ToggleOff`, `ToggleKnob`, `Success`, `Warning`, `Danger`.

**Corner sharpness**

Lower numbers give sharper corners and `0` is perfectly square. Set these before `CreateWindow`.

```lua
SCUI.Radius.Window = 4
SCUI.Radius.Card = 3
SCUI.Radius.Input = 3    -- dropdowns, inputs, search box
SCUI.Radius.Button = 3
SCUI.Radius.Item = 3     -- sidebar tabs, user card
SCUI.Radius.Chip = 3
SCUI.Radius.Popup = 4
SCUI.Radius.Knob = 2     -- slider knob
SCUI.Radius.Mini = 2
```

---

## Icons

Icons come from an online icon provider. Use a bare name for the default pack, or `Pack:name` for another one.

```lua
Icon = "fish"               -- Lucide (default)
Icon = "Material:home"
Icon = "Phosphor:fish"
Icon = "Phosphor-Filled:fish"
Icon = "SF:gear"
Icon = "rbxassetid://123"   -- direct asset
```

The provider table is exposed and editable:

```lua
SCUI.IconProvider = {
	DefaultIconPack = "Lucide",
	IconSources = {
		Material = "https://raw.githubusercontent.com/Skinny-yz/NullUI-Assets/main/icons/MaterialIcons.luau",
		Lucide = "https://raw.githubusercontent.com/Skinny-yz/NullUI-Assets/main/icons/LucideIcons.luau",
		Phosphor = "https://raw.githubusercontent.com/Skinny-yz/NullUI-Assets/main/icons/Phosphor.luau",
		["Phosphor-Filled"] = "https://raw.githubusercontent.com/Skinny-yz/NullUI-Assets/main/icons/Phosphor%20Filled.luau",
		SF = "https://raw.githubusercontent.com/Skinny-yz/NullUI-Assets/main/icons/SFSymbols.luau",
	},
}
```

Each pack file must return a table of `name = assetId`. Packs are downloaded once and cached.

---

## Flags and configs

Give a component a `Flag` to read its value or save it in a config:

```lua
Section:AddToggle({ Title = "Auto Sell", Flag = "AutoSell" })

print(SCUI.Flags.AutoSell)              -- current value
SCUI.Options.AutoSell:Set(true)         -- the component object

Window:SaveConfig("default")
Window:LoadConfig("default")
```

Configs are saved as JSON in `ConfigFolder`. They store flagged components, theme, accent, UI scale, compact mode, sidebar state and favorite tabs. `BuildSettingsTab()` adds a UI for saving and loading.

---

## Keyboard and touch

| Input | Action |
|---|---|
| `RightShift` (configurable) | Show or hide the window |
| `Ctrl` / `Cmd` + `K` | Focus search |
| `Up` / `Down` / `Enter` in search | Move through results and open one |
| `Ctrl` / `Cmd` + `B` | Hide or show the sidebar |
| `Esc` | Close dialog, search or quick menu |
| `Up` / `Down` | Previous / next tab (while the pointer is over the window) |
| `Left` / `Right` | Previous / next sub-tab (while the pointer is over the window) |
| Right-click or press and hold a tab | Favorite or unfavorite it |
| Folder button (top right) | Quick menu: hide sidebar, icons only, compact, minimize, search |
| Floating button | Restore a minimized window (drag it to move it) |

---

## Project layout

```
SCUI/
 +-- SCUIsource.lua    the library (no comments)
 +-- SCUIExample.lua   fully commented demo window
 +-- README.md
 +-- LICENSE
```

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Nothing appears | Open the console (F9 in Roblox, or your executor's console) and read the first red error. |
| Icons are missing | Your executor must allow `game:HttpGet` and `loadstring`. Icons appear a moment after the UI. |
| The window is too big | Lower `Scale`, set a smaller `Size`, or leave `AutoScale = true`. |
| Corners look too round | Lower the values in `SCUI.Radius` before creating the window. |
| Profile picture is blank | Headshots load from Roblox servers and can take a moment. Use `Avatar = "rbxassetid://ID"` for a fixed image. |
| Config save / load fails | Your executor needs `writefile`, `readfile`, `isfile`, `makefolder` and `listfiles`. |
| Keybind does not fire | Keybinds ignore keys pressed while typing in a text box. |

---

## Status

SCUI was tested headlessly against a mocked Roblox API (components, search, dialogs, minimize, drag, resize and config) and needs visual tuning in the real engine. If something looks off, open an issue with a screenshot and your console output.

SCUI is a UI library. Using scripts in games may violate a game's rules or Roblox's Terms of Use, and you are responsible for how you use it.

---

## License

MIT. See [LICENSE](LICENSE).
