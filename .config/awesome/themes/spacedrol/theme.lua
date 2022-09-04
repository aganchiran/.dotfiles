local config_path = require("gears.filesystem").get_configuration_dir()

local original_themes_path = require("gears.filesystem").get_themes_dir()
local themes_path = config_path .. "themes/"
local dpi = require("beautiful.xresources").apply_dpi

local gears = require("gears")
local wibox = require("wibox")

-- {{{ Main
local theme = {}
theme.wallpaper = themes_path .. "spacedrol/spacedrol-background.png"
-- }}}

-- {{{ Styles
theme.font      = "sans 10"

-- {{{ Colors
theme.fg_normal  = "#FFFFFF"
theme.fg_focus   = "#FFFFFF"
theme.fg_urgent  = "#CC9393"
theme.bg_normal  = "#AAAAAA33"
theme.bg_focus   = "#E63946"
theme.bg_urgent  = "#FCF17D"
theme.bg_systray = theme.bg_normal

theme.invisible  = "#00000000"
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = "#282C34"
theme.border_focus  = "#5089B9"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Menubar
theme.menubar_bg_focus      = theme.bg_focus
theme.menubar_bg_inner      = "#262A31"
theme.menubar_inner_height  = 38
theme.menubar_icon_size     = 110
theme.menubar_prompt_label  = "Apps: "

theme.menubar_bg_normal     = theme.invisible
theme.menubar_border_color  = theme.menubar_invisible
theme.menubar_border_width  = 0
theme.menubar_outer_height  = (theme.menubar_icon_size - theme.menubar_inner_height) / 2
theme.menubar_height        = theme.menubar_outer_height + theme.menubar_inner_height
-- }}}

-- {{{ Prompt
theme.prompt_bg = theme.menubar_bg_normal
theme.prompt_fg = theme.menubar_fg_normal
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)
-- }}}

-- {{{ Icons
-- {{{ Taglist
-- theme.taglist_squares_sel   = original_themes_path .. "zenburn/taglist/squarefz.png"
-- theme.taglist_squares_unsel = original_themes_path .. "zenburn/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = themes_path .. "spacedrol/logo/spacedrol-cold-icon.png"
theme.spacedrol_cold_icon    = themes_path .. "spacedrol/logo/spacedrol-cold-icon.png"
theme.spacedrol_hot_icon     = themes_path .. "spacedrol/logo/spacedrol-hot-icon.png"
theme.menu_submenu_icon      = original_themes_path .. "default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = themes_path .. "spacedrol/layouts/tile.png"
theme.layout_tileleft   = themes_path .. "spacedrol/layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "spacedrol/layouts/tilebottom.png"
theme.layout_tiletop    = themes_path .. "spacedrol/layouts/tiletop.png"
theme.layout_fairv      = themes_path .. "spacedrol/layouts/fairv.png"
theme.layout_fairh      = themes_path .. "spacedrol/layouts/fairh.png"
theme.layout_spiral     = themes_path .. "spacedrol/layouts/spiral.png"
theme.layout_dwindle    = themes_path .. "spacedrol/layouts/dwindle.png"
theme.layout_max        = themes_path .. "spacedrol/layouts/max.png"
theme.layout_fullscreen = themes_path .. "spacedrol/layouts/fullscreen.png"
theme.layout_magnifier  = themes_path .. "spacedrol/layouts/magnifier.png"
theme.layout_floating   = themes_path .. "spacedrol/layouts/floating.png"
theme.layout_cornernw   = themes_path .. "spacedrol/layouts/cornernw.png"
theme.layout_cornerne   = themes_path .. "spacedrol/layouts/cornerne.png"
theme.layout_cornersw   = themes_path .. "spacedrol/layouts/cornersw.png"
theme.layout_cornerse   = themes_path .. "spacedrol/layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
-- theme.titlebar_close_button_focus  = original_themes_path .. "zenburn/titlebar/close_focus.png"
-- theme.titlebar_close_button_normal = original_themes_path .. "zenburn/titlebar/close_normal.png"
--
-- theme.titlebar_minimize_button_normal = original_themes_path .. "default/titlebar/minimize_normal.png"
-- theme.titlebar_minimize_button_focus  = original_themes_path .. "default/titlebar/minimize_focus.png"
--
-- theme.titlebar_ontop_button_focus_active  = original_themes_path .. "zenburn/titlebar/ontop_focus_active.png"
-- theme.titlebar_ontop_button_normal_active = original_themes_path .. "zenburn/titlebar/ontop_normal_active.png"
-- theme.titlebar_ontop_button_focus_inactive  = original_themes_path .. "zenburn/titlebar/ontop_focus_inactive.png"
-- theme.titlebar_ontop_button_normal_inactive = original_themes_path .. "zenburn/titlebar/ontop_normal_inactive.png"
--
-- theme.titlebar_sticky_button_focus_active  = original_themes_path .. "zenburn/titlebar/sticky_focus_active.png"
-- theme.titlebar_sticky_button_normal_active = original_themes_path .. "zenburn/titlebar/sticky_normal_active.png"
-- theme.titlebar_sticky_button_focus_inactive  = original_themes_path .. "zenburn/titlebar/sticky_focus_inactive.png"
-- theme.titlebar_sticky_button_normal_inactive = original_themes_path .. "zenburn/titlebar/sticky_normal_inactive.png"
--
-- theme.titlebar_floating_button_focus_active  = original_themes_path .. "zenburn/titlebar/floating_focus_active.png"
-- theme.titlebar_floating_button_normal_active = original_themes_path .. "zenburn/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_inactive  = original_themes_path .. "zenburn/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_inactive = original_themes_path .. "zenburn/titlebar/floating_normal_inactive.png"
--
-- theme.titlebar_maximized_button_focus_active  = original_themes_path .. "zenburn/titlebar/maximized_focus_active.png"
-- theme.titlebar_maximized_button_normal_active = original_themes_path .. "zenburn/titlebar/maximized_normal_active.png"
-- theme.titlebar_maximized_button_focus_inactive  = original_themes_path .. "zenburn/titlebar/maximized_focus_inactive.png"
-- theme.titlebar_maximized_button_normal_inactive = original_themes_path .. "zenburn/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#E63946"
-- }}}

-- {{{ Templates
theme.menubar_item_template = {
    style = {
        shape  = gears.shape.rounded_bar,
    },
    widget_template = {
        widget  = wibox.container.margin,
        top     = 10,
        bottom  = 6,
        right   = 8,
        left    = 8,
        {
            layout = wibox.layout.fixed.vertical,
            {
                widget  = wibox.container.margin,
                right   = 2,
                left    = 2,
                {
                    id     = 'text_role',
                    widget = wibox.widget.textbox,
                },
            },
            {
                id     = 'background_role',
                widget = wibox.container.background,
                {
                    widget  = wibox.container.margin,
                    top     = 4,
                }
            },
        },
    }
}
theme.menubar_layout_template = {
  layout = wibox.layout.stack,
  {
    widget = wibox.container.margin,
    top = theme.menubar_outer_height,
    {
      widget = wibox.container.background,
      bg = theme.menubar_bg_inner,
      {
        widget = wibox.container.margin,
        left = theme.menubar_height + 8,
        forced_width = 1920,
        {
          layout = wibox.layout.fixed.horizontal,
          {
            widget = wibox.container.margin,
            id = 'prompt_container_role',
          },
          {
            widget = wibox.container.margin,
            id = 'results_container_role',
          },
        },
      },
    },
  },
  {
    widget = wibox.container.margin,
    bottom = -theme.menubar_outer_height,
    left   = -theme.menubar_outer_height,
    {
      widget = wibox.widget.imagebox,
      image  = theme.spacedrol_hot_icon,
    },
  },
}
-- }}}


return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
