local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local config = wezterm.config_builder()

-- Show the launcher in the very first window when the GUI starts.
wezterm.on("gui-startup", function(cmd)
  local _, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():perform_action(
    act.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS|TABS" }),
    pane
  )
end)

local is_windows = os.getenv("OS") and os.getenv("OS"):lower():find("windows")
local is_macos = wezterm.target_triple:lower():find("darwin") ~= nil

config.color_scheme = "rose-pine-moon"
config.max_fps = 120
config.font = wezterm.font("BerkeleyMono Nerd Font Mono", { weight = "Bold" })
config.initial_cols = 120
config.initial_rows = 40
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_frame = {
  font = wezterm.font("BerkeleyMono Nerd Font Mono", { weight = "Bold" }),
}
config.inactive_pane_hsb = {
  saturation = 0.0,
  brightness = 0.5,
}

-- Spawn a new tab/window, then pop the launcher in the freshly created pane.
local launcher_flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS|TABS"

config.keys = {
  {
    -- Don't pre-spawn a tab: the launcher itself spawns the chosen shell in a
    -- new tab. Pre-spawning would leave an orphan default-shell tab behind.
    key = "t",
    mods = "CMD",
    action = act.ShowLauncherArgs({ flags = launcher_flags }),
  },
  {
    key = "n",
    mods = "CMD",
    action = wezterm.action_callback(function(_window, _pane)
      local _tab, new_pane, new_window = mux.spawn_window({})
      -- The new window's GUI side isn't attached synchronously, so defer
      -- the launcher until gui_window() resolves.
      wezterm.time.call_after(0.2, function()
        local gui = new_window:gui_window()
        if gui then
          gui:perform_action(act.ShowLauncherArgs({ flags = launcher_flags }), new_pane)
        end
      end)
    end),
  },
}

if is_windows then
  config.win32_system_backdrop = "Acrylic"
  config.window_background_opacity = 0.7
  config.window_frame.font_size = 10.0
end

if is_macos then
  config.window_background_opacity = 0.8
  config.macos_window_background_blur = 50
  config.font_size = 15.0
  config.window_frame.font_size = 13.0
end

return config
