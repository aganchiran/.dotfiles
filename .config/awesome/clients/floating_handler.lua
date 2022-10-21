
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            floating = true,  -- Make all clients floating
            size_hints_honor = true,
        },
    },

    -- Always tiled clients.
    {
        rule_any = {
            class = {
                "kitty",
                "Emacs",
            },
        },
        properties = { floating = false }
    },

    -- Add titlebars to floating clients
    {
        rule_any = { type = { "floating" } },
        properties = { titlebars_enabled = true, border_width = 0 },
    },

    -- Set Inkscape to always map on the tag named "2" on screen 1.
    {
        rule = { class = "Inkscape"},
        except_any = { type = { "floating", "dialog" } },
        properties = { screen = 1, tag = "2", fullscreen = true }
    },
}
-- }}}

client_groups = {
    ["1"] = {},
    ["2"] = {},
    ["3"] = {},
    ["4"] = {},
    ["5"] = {},
    ["6"] = {},
    ["7"] = {},
    ["8"] = {},
    ["9"] = {},
}


local function printGroups()

    naughty.destroy_all_notifications()

    local keyset={}
    local n=0

    for k,v in pairs(client_groups) do
      n=n+1
      keyset[n]=k
    end
    table.sort(keyset)

    for index = 1, 9, 1 do
        local k = keyset[index]
        naughty.notify{text=tostring(k .. " Tag"), timeout=0}

        for i,j in pairs(client_groups[k]) do
            naughty.notify{text=tostring(i .. " Group -----"), timeout=0}
            for x,y in pairs(j) do
                naughty.notify{text=tostring(x .. " Window ----------"), timeout=0}
            end
        end
    end

end


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if c.type == 'normal' then
        if not client_groups[c.first_tag.name][c.group_window] then
            c.floating = false
            client_groups[c.first_tag.name][c.group_window] = {}
            client_groups[c.first_tag.name][c.group_window][c.window] = "main"
        else
            client_groups[c.first_tag.name][c.group_window][c.window] = "secondary"
        end
    elseif not client_groups[c.first_tag.name][c.group_window] then
        awful.titlebar.hide(c, "top")
        awful.titlebar.hide(c, "bottom")
        awful.titlebar.hide(c, "left")
        awful.titlebar.hide(c, "right")
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    --printGroups() --Uncomment to debug
end)

client.connect_signal("unmanage", function (c)
    if c.type == 'normal' then
        for t = 1, 9, 1 do
            local tag_group = client_groups[tostring(t)]
            if tag_group then
                local window_group = tag_group[c.group_window]
                if window_group then
                    window_group[c.window] = nil

                    local allNil = true
                    for k,v in pairs(window_group) do
                        allNil = false
                    end
                    if allNil then
                        tag_group[c.group_window] = nil
                    end
                end
            end
        end
        --printGroups() --Uncomment to debug
    end
end)
