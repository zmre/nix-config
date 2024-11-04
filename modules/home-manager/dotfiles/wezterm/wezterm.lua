local wezterm = require 'wezterm'

local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux

config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.bold_brightens_ansi_colors = true
--config.color_scheme = 'OneHalfDark'
config.color_scheme = 'OneDark (base16)'
--config.font = wezterm.font('Hasklug Nerd Font Mono')
config.font = wezterm.font("Hasklug Nerd Font Mono", { weight = "Medium", stretch = "Normal", style = "Normal" })
config.term = 'wezterm'
config.window_background_opacity = 0.9
config.font_size = 18.0
config.adjust_window_size_when_changing_font_size = false
config.automatically_reload_config = true
-- config.window_close_confirmation = "NeverPrompt"
config.tab_bar_at_bottom = true
config.scrollback_lines = 10000
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
  font_size = 16
}
config.window_padding = {
  left = 1,
  right = 1,
  top = 0,
  bottom = 0,
}
config.colors = {
  tab_bar = {
    active_tab = {
      -- The color of the background area for the tab
      bg_color = '#202055',
      -- The color of the text for the tab
      fg_color = '#e0e0e0',
    },
    inactive_tab = {
      bg_color = '#303040',
      fg_color = '#bbbbbb'
    }
  }
}
-- Use ctrl-b as leader to be tmux-like (although I think the default there is ctrl-a... hmmm)
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
  -- ctrl-b, [ puts us into a vim-like mode for navigating and selecting and copying out history
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  -- ctrl-b, | splits vertically while - splits horizontally
  {
    key = "-",
    mods = "LEADER",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "|",
    mods = "LEADER",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  -- I have way too many ways to change panes, but the three options are:
  -- ctrl-shift+h/j/k/l
  -- ctrl-b, h/j/k/l
  -- ctrl-b, a to activate the mode for navigating panes with h/j/k/l -- should probably remove this one
  -- ctrl-b, r to activate the mode for resizing the current pane with h/j/k/l
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    key = 'h',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Down',
  },

  -- ctrl-a, followed by 'a' will put us in activate-pane
  -- mode until we press some other key or until 1 second (1000ms)
  -- of time elapses
  {
    key = 'a',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'activate_pane',
      timeout_milliseconds = 1000,
    },
  },
  -- ctrl-a, followed by 'r' will put us in resize-pane
  -- mode until we press some other key or until 1 second (1000ms)
  -- of time elapses
  {
    key = 'r',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'resize_pane',
      timeout_milliseconds = 1000,
      one_shot = false
    },
  },
}
config.key_tables = {
  -- Defines the keys that are active in our resize-pane mode.
  -- Since we're likely to want to make multiple adjustments,
  -- we made the activation one_shot=false. We therefore need
  -- to define a key assignment for getting out of this mode.
  -- 'resize_pane' here corresponds to the name="resize_pane" in
  -- the key assignments above.
  resize_pane = {
    { key = 'LeftArrow',  action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'h',          action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'l',          action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'UpArrow',    action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'k',          action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'DownArrow',  action = act.AdjustPaneSize { 'Down', 1 } },
    { key = 'j',          action = act.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode by pressing escape
    { key = 'Escape',     action = 'PopKeyTable' },
  },

  -- Defines the keys that are active in our activate-pane mode.
  -- 'activate_pane' here corresponds to the name="activate_pane" in
  -- the key assignments above.
  activate_pane = {
    { key = 'LeftArrow',  action = act.ActivatePaneDirection 'Left' },
    { key = 'h',          action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
    { key = 'l',          action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    action = act.ActivatePaneDirection 'Up' },
    { key = 'k',          action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow',  action = act.ActivatePaneDirection 'Down' },
    { key = 'j',          action = act.ActivatePaneDirection 'Down' },
  },
}

config.animation_fps = 165
config.max_fps = 165
local gpus = wezterm.gui.enumerate_gpus()
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'
config.webgpu_preferred_adapter = gpus[1]

wezterm.on('gui-startup', function(cmd)
  local path =
  '/etc/profiles/per-user/pwalsh/bin:/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin'

  local _, main_pane, window = mux.spawn_window(cmd or {})
  local news_tab, news_left_pane, _ = window:spawn_tab({})
  local notes_tab, notes_pane, _ = window:spawn_tab({ cwd = wezterm.home_dir .. "/Notes" })
  local website_tab, website_pane, _ = window:spawn_tab({ cwd = wezterm.home_dir .. "/src/icl/website.worktree" })
  local yazi_tab, yazi_pane, _ = window:spawn_tab { cwd = wezterm.home_dir, set_environment_variables = { PATH = path }, args = { 'yazi', '~' } }
  local news_right_pane = news_left_pane:split({ direction = "Right", size = 0.5, set_environment_variables = { PATH = path }, args = { "hackernews_tui" } })
  notes_tab:set_title('notes')
  news_tab:set_title('news')
  website_tab:set_title('svelte')
  notes_pane:send_text("nvim -c 'norm ,fn'\n")
  news_left_pane:send_text("btop\n")
  main_pane:activate()
end)

return config
