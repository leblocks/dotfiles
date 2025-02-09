-- Pull in the wezterm API
local wezterm = require('wezterm')
local os = require('os')

-- This will hold the configuration.
local config = wezterm.config_builder();

-- general
config.default_prog = { 'pwsh', '-NoLogo', '-NoProfileLoadTime' }
config.audible_bell = 'Disabled'

-- font
config.font_size = 14
config.line_height = 1.1
config.font = wezterm.font('CaskaydiaMono Nerd Font')

-- ui
config.max_fps = 120
config.animation_fps = 120
config.color_scheme = 'Ubuntu'
config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- keys
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }

local act = wezterm.action

config.keys = {
    -- tmux like keybindings
    { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration, },
    { key = '%', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },
    { key = '"', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
    { key = '&', mods = 'LEADER|SHIFT', action = act.CloseCurrentTab { confirm = true }, },
    { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true }, },
    { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
    { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState, },
    { key = 'q', mods = 'LEADER', action = act.PaneSelect { alphabet = '1234567890', }, },
    { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', mods = 'LEADER', action = act.ShowTabNavigator },
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left', },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right', },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up', },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down', },
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    {
        key = ',',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
}

-- activate tab bindings
for i = 1, 9 do
  -- LEADER + number to activate that tab
  table.insert(config.keys, { key = tostring(i), mods = 'LEADER', action = act.ActivateTab(i - 1), })
end

local is_devbox = string.lower(os.getenv('IsDevBox') or '') == 'true'
local devbox_config_path = os.getenv('DEVBOX_WEZTERM_CONFIG') or ''

-- pass config inside and override it
if is_devbox ~= false then
    local status, err = pcall(function() dofile(devbox_config_path) end)
    if not status then
        print('failed to load external configuration from "' .. devbox_config_path .. '" error: ' .. err)
    else
        set_configuraiton_overrides(config)
    end
end

return config

