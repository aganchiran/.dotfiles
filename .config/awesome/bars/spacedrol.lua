local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local menubar = require("menubars.spacedrol")
local beautiful = require("beautiful")
local animations = require("lib.animations")
local naughty = require("naughty")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
                              if client.focus then
                                  client.focus:move_to_tag(t)
                              end
                          end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
                              if client.focus then
                                  client.focus:toggle_tag(t)
                              end
                          end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local function refreshTagStatus(self, c3)
    local isSelected = c3.selected
    local hasSomethingInIt = #c3:clients() > 0

    if isSelected and hasSomethingInIt then
        self.color_timed:set(1)
        self.grow_timed:set(1)

    elseif isSelected then
        self.color_timed:set(0)
        self.grow_timed:set(1)

    elseif hasSomethingInIt then
        self.color_timed:set(2)
        self.grow_timed:set(1)

    else
        self.color_timed:set(0)
        self.grow_timed:set(0)
    end
end

mylauncher = wibox.widget {
    widget = wibox.widget.imagebox,
    image  = beautiful.spacedrol_moon_icon,
}

mylauncher:connect_signal("button::release", function(c) menubar.show() end)


-- Create a textclock widget
mytextclock = wibox.widget.textclock()

awful.screen.connect_for_each_screen(function(s)

    -- Each screen has its own tag table.
    awful.tag({ "", "", "", "", "", "", "", "", "" }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        widget_template = {
            id     = 'custom_margins',
            widget = wibox.container.margin,
            left   = 9,
            right  = 9,
            {
                id     = 'custom_round_bg',
                shape  = gears.shape.circle,
                widget = wibox.container.background,
                shape_border_width = 2,
                forced_width = 5,
                forced_height = 5,
                {
                    id     = 'text_role',
                    align  = 'center',
                    valign = 'center',
                    widget = wibox.widget.textbox,
                },
            },
            create_callback = function(self, c3)
                local round_bg = self:get_children_by_id('custom_round_bg')[1]
                local margins = self:get_children_by_id('custom_margins')[1]
                local size_full = 23
                local size_max = 13
                local size_min = 5

                self.grow_timed = animations:new({
                    duration = 0.2,
                    easing = animations.easing.outQuad,
                    update = function(self, t)
                        local size_current    = (size_max - size_min) * t + size_min
                        local margins_current = (size_full - size_current) / 2

                        round_bg.forced_width  = size_current
                        round_bg.forced_height = size_current
                        margins.margins  = margins_current
                    end
                })

                self.color_timed = animations:new({
                    duration = 0.4,
                    easing = animations.easing.outQuad,
                    update = function(self, t)
                        if t <= 1 then
                            local current_color = get_color(beautiful.bg_secondary, beautiful.bg_focus, t)
                            round_bg.bg = current_color
                            round_bg.shape_border_color = current_color
                        else
                            round_bg.bg = get_color(beautiful.bg_focus, beautiful.bg_focus .. "00", t - 1)
                        end
                    end
                })


                refreshTagStatus(self, c3)
            end,
            update_callback = function(self, c3)
                refreshTagStatus(self, c3)
            end,
        },
        buttons = taglist_buttons,
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
            position = "bottom",
            screen = s ,
            input_passthrough = true,
            height = 38,
            bg = beautiful.invisible,
    })

    s.mywibox.bar_bg_timed = animations:new({
        duration = 0.4,
        easing = animations.easing.outQuad,
        update = function(self, t)
            s.mywibox.bg = get_color(beautiful.invisible, beautiful.bg_normal, t)
        end
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = 'outside',

        { -- Left widgets
            widget = wibox.container.place,
            halign = 'left',
            {
                widget = wibox.container.margin,
                margins = 5,
                mylauncher,
            },
        },
        {
            widget = wibox.container.place,
            {
                widget = wibox.container.background,
                shape  = gears.shape.rounded_bar,
                bg     = beautiful.bg_secondary,
                {
                    widget = wibox.container.margin,
                    right = 8,
                    left = 8,
                    top = 4,
                    bottom = 4,
                    s.mytaglist,
                },
            },
        },
        { -- Right widgets
            widget = wibox.container.place,
            halign = 'right',
            {
                widget = wibox.container.background,
                shape  = gears.shape.rounded_bar,
                bg     = beautiful.bg_secondary,
                forced_height = 30,
                {
                    widget = wibox.container.margin,
                    top = 6,
                    bottom = 6,
                    right = 0,
                    left = 10,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        mytextclock,
                        wibox.widget.systray(),
                        s.mylayoutbox,
                    },
                },
            },
        },
    }
end)

-- Make bar transparent when there is no tiled windows
screen.connect_signal("arrange", function (s)

    local more_than_one_tiled = #s.tiled_clients >= 1
    local wibar = s.mywibox

    if more_than_one_tiled then
        wibar.bar_bg_timed:set(1)
    else
        wibar.bar_bg_timed:set(0)
    end
end)
