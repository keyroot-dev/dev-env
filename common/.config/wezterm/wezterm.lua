local wezterm = require("wezterm")
local act = wezterm.action

local is_windows = wezterm.target_triple:find("windows") ~= nil

local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night"
config.font = wezterm.font("HackGen Console NF", { weight = "Regular" })
-- DPI やディスプレイスケーリングによって見た目が変わるため OS ごとに調整する
config.font_size = is_windows and 14.0 or 16.0
config.window_background_opacity = 0.95

-- WezTerm デフォルトを無効化して Emacs との競合をなくす
config.disable_default_key_bindings = true

-- Emacs の C-SPC（マーク設定）と衝突しないよう CTRL+SHIFT+Space に変更
config.leader = { key = "Space", mods = "CTRL|SHIFT", timeout_milliseconds = 1500 }

local keys = {
	-- フォントサイズ
	{ key = "+", mods = "SUPER", action = act.IncreaseFontSize },
	{ key = "=", mods = "SUPER", action = act.IncreaseFontSize },
	{ key = "-", mods = "SUPER", action = act.DecreaseFontSize },
	{ key = "0", mods = "SUPER", action = act.ResetFontSize },

	-- ◇/Win+矢印はOSのウィンドウ管理(Mac:Rectangle, Win:OS標準)に委ねる
	{ key = "LeftArrow",  mods = "SUPER", action = act.DisableDefaultAssignment },
	{ key = "RightArrow", mods = "SUPER", action = act.DisableDefaultAssignment },
	{ key = "UpArrow",    mods = "SUPER", action = act.DisableDefaultAssignment },

	-- Emacs の Undo キーを素通しする
	{ key = "_", mods = "CTRL", action = act.SendKey({ key = "_", mods = "CTRL" }) },
	{ key = "/", mods = "CTRL", action = act.SendKey({ key = "/", mods = "CTRL" }) },

	-- タブ操作
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },

	-- ペイン分割・移動
	{ key = "-",  mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h",  mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j",  mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k",  mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l",  mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "H",  mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "J",  mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "K",  mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "L",  mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "x",  mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "v",  mods = "LEADER", action = act.ActivateCopyMode },
}

-- Mac 専用: Cmd キーによる操作
if not is_windows then
	local mac_keys = {
		{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
		{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
		{ key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "w", mods = "SUPER", action = act.CloseCurrentTab({ confirm = false }) },
		{ key = "n", mods = "SUPER", action = act.SpawnWindow },
		{ key = "q", mods = "SUPER", action = act.QuitApplication },
		{ key = "r", mods = "SUPER", action = act.ReloadConfiguration },
		{ key = "m", mods = "SUPER", action = act.Hide },
		{ key = "h", mods = "SUPER", action = act.HideApplication },
		{ key = "k", mods = "SUPER", action = act.ClearScrollback("ScrollbackOnly") },
		{ key = "1", mods = "SUPER", action = act.ActivateTab(0) },
		{ key = "2", mods = "SUPER", action = act.ActivateTab(1) },
		{ key = "3", mods = "SUPER", action = act.ActivateTab(2) },
		{ key = "4", mods = "SUPER", action = act.ActivateTab(3) },
		{ key = "5", mods = "SUPER", action = act.ActivateTab(4) },
		{ key = "[", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(-1) },
		{ key = "]", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(1) },
	}
	for _, k in ipairs(mac_keys) do
		table.insert(keys, k)
	end
end

-- Windows 専用: CTRL+SHIFT によるコピペ
if is_windows then
	local win_keys = {
		{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
		{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
	}
	for _, k in ipairs(win_keys) do
		table.insert(keys, k)
	end
end

config.keys = keys

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection"),
	},
}

config.scrollback_lines = 10000
config.window_close_confirmation = "NeverPrompt"

if is_windows then
	config.default_prog = { "wsl.exe", "--cd", "~" }
end

return config
