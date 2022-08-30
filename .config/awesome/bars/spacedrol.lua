local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

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
        self:get_children_by_id('custom_round_bg')[1].bg = beautiful.bg_focus
        self:get_children_by_id('custom_round_bg')[1].forced_width = 13
        self:get_children_by_id('custom_round_bg')[1].forced_height = 13
        self:get_children_by_id('custom_margins')[1].left = 5
        self:get_children_by_id('custom_margins')[1].right = 5
        self:get_children_by_id('custom_round_bg')[1].shape_border_width = 0

    elseif isSelected then
        self:get_children_by_id('custom_round_bg')[1].bg = beautiful.bg_normal
        self:get_children_by_id('custom_round_bg')[1].forced_width = 13
        self:get_children_by_id('custom_round_bg')[1].forced_height = 13
        self:get_children_by_id('custom_margins')[1].left = 5
        self:get_children_by_id('custom_margins')[1].right = 5
        self:get_children_by_id('custom_round_bg')[1].shape_border_width = 0

    elseif hasSomethingInIt then
        self:get_children_by_id('custom_round_bg')[1].bg = beautiful.invisible
        self:get_children_by_id('custom_round_bg')[1].forced_width = 13
        self:get_children_by_id('custom_round_bg')[1].forced_width = 13
        self:get_children_by_id('custom_margins')[1].left = 5
        self:get_children_by_id('custom_margins')[1].right = 5
        self:get_children_by_id('custom_round_bg')[1].shape_border_width = 2

    else
        self:get_children_by_id('custom_round_bg')[1].bg = beautiful.bg_normal
        self:get_children_by_id('custom_round_bg')[1].forced_width = 5
        self:get_children_by_id('custom_round_bg')[1].forced_height = 5
        self:get_children_by_id('custom_margins')[1].left = 9
        self:get_children_by_id('custom_margins')[1].right = 9
        self:get_children_by_id('custom_round_bg')[1].shape_border_width = 0

    end
end

-- Launcher widget
mylauncher = awful.widget.launcher({
        image = beautiful.awesome_icon,
        menu = mymainmenu,
})

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
            left   = 5,
            right  = 5,
            {
                id     = 'custom_round_bg',
                shape  = gears.shape.circle,
                widget = wibox.container.background,
                shape_border_color = beautiful.bg_focus,
                {
                    id     = 'text_role',
                    align  = 'center',
                    valign = 'center',
                    widget = wibox.widget.textbox,
                },
            },
            create_callback = function(self, c3)
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
            -- shape = gears.shape.rounded_bar,
            -- width = 1000,
            input_passthrough = true,
            height = 38,
            bg = beautiful.invisible
    })

    -- Create padding of the windows
    -- s.padding = {
    --     top = 4,
    --     left = 4,
    --     right = 4,
    --     bottom = 8,
    -- }

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
                bg     = beautiful.bg_normal,
                {
                    widget = wibox.container.margin,
                    margins = 8,
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
                bg     = beautiful.bg_normal,
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
