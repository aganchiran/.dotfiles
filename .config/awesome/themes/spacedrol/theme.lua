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
theme.font      = "Iosevka Custom bold 10"

-- {{{ Colors
theme.fg_normal     = "#FFFFFF"
theme.fg_focus      = "#FFFFFF"
theme.fg_urgent     = "#CC9393"
theme.bg_normal     = "#262A31"
theme.bg_secondary  = "#AAAAAA33"
theme.bg_focus      = "#E63946"
theme.bg_urgent     = "#FCF17D"
theme.bg_systray    = theme.bg_normal

theme.invisible     = "#00000000"
theme.shadow_color  = "#0F0F0F88"
theme.shadow_size   = 5
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = theme.bg_normal
theme.border_focus  = "#5089B9"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Menubar

theme.menubar_height        = 38
theme.menubar_border_width  = 0
theme.menubar_bg_normal     = theme.bg_normal
theme.menubar_prompt_label  = ""
-- }}}

-- {{{ Titlebar
theme.titlebar_bg           = theme.bg_normal
theme.titlebar_bg_unfocused = "#484D53"
theme.titlebar_fg           = theme.fg_normal
theme.titlebar_fg_unfocused = "#DDDDDD"
-- }}}

-- {{{ Prompt
theme.prompt_bg = theme.invisible
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
-- theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon                   = themes_path .. "spacedrol/logo/droller.png"
theme.awesome_smol_icon              = themes_path .. "spacedrol/logo/droller_small.png"
theme.spacedrol_moon_icon            = themes_path .. "spacedrol/logo/spacedrol-moon-icon.png"
theme.spacedrol_moon_close_icon      = themes_path .. "spacedrol/logo/spacedrol-moon-close-icon.png"
theme.spacedrol_moon_unfocused_icon  = themes_path .. "spacedrol/logo/spacedrol-moon-unfocused-icon.png"
theme.spacedrol_moon_shadow_icon     = themes_path .. "spacedrol/logo/spacedrol-moon-shadow-icon.png"
theme.spacedrol_sun_icon             = themes_path .. "spacedrol/logo/spacedrol-sun-icon.png"
theme.spacedrol_sun_tile_icon        = themes_path .. "spacedrol/logo/spacedrol-sun-tile-icon.png"
theme.spacedrol_sun_unfocused_icon   = themes_path .. "spacedrol/logo/spacedrol-sun-unfocused-icon.png"
theme.spacedrol_earth_icon           = themes_path .. "spacedrol/logo/spacedrol-earth-icon.png"
theme.spacedrol_earth_max_icon       = themes_path .. "spacedrol/logo/spacedrol-earth-max-icon.png"
theme.spacedrol_earth_unfocused_icon = themes_path .. "spacedrol/logo/spacedrol-earth-unfocused-icon.png"
theme.rocket_icon                    = themes_path .. "spacedrol/other_icons/rocket.png"
theme.menu_submenu_icon              = original_themes_path .. "default/submenu.png"
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
  layout = wibox.layout.fixed.horizontal,
  {
    widget = wibox.container.margin,
    left   = 80,
    top    = 4,
    bottom = 4,
    right  = 8,
    {
      widget = wibox.container.background,
      shape  = gears.shape.rounded_bar,
      bg     = theme.bg_secondary,
      {
        widget = wibox.container.margin,
        margins = 4,
        {
          layout = wibox.layout.align.horizontal,
          {
            widget = wibox.container.margin,
            margins = 2,
            {
              widget = wibox.widget.imagebox,
              image  = theme.rocket_icon,
            },
          },
          {
            widget = wibox.container.margin,
            left   = 4,
            right  = 4,
            id     = 'prompt_container_role',
          },
        },
      },
    },
  },
  {
    widget = wibox.container.margin,
    id     = 'results_container_role',
  },
}
-- }}}


return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
