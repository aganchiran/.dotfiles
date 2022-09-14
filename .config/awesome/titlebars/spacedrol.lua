
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local lgi = require("lgi")
local gdk = lgi.Gdk
local pixbuf_get_from_surface = gdk.pixbuf_get_from_surface
local gtimer = require("gears.timer")
local gtimer_weak_start_new = gtimer.weak_start_new


local visible_titlebar_radius = 10
local visible_titlebar_size = 24
local overlaping_content_size = 12

local sun_xpos = -26
local sun_ypos = 2
local sun_size = 45
local moon_xpos = 5
local moon_ypos = 5
local moon_size = 55
local earth_xpos = -15
local earth_ypos = 50
local earth_size = 90

local function get_top_titlebar_size()
  local top_titlebar_size = math.max((earth_size / 2) + earth_ypos, (moon_size / 2) + moon_ypos, (sun_size / 2) + sun_ypos)
  local top_titlebar_used_space = visible_titlebar_size - overlaping_content_size
  local top_titlebar_available_space_for_shadow = top_titlebar_size - top_titlebar_used_space
  return (top_titlebar_available_space_for_shadow < beautiful.shadow_size) and beautiful.shadow_size + top_titlebar_used_space or top_titlebar_size
end
local function get_bottom_titlebar_size()
  return beautiful.shadow_size
end
local function get_left_titlebar_size()
  local left_titlebar_size = math.max((earth_size / 2) - earth_xpos, (moon_size / 2) - moon_xpos, (sun_size / 2) - sun_xpos)
  return (left_titlebar_size < beautiful.shadow_size) and beautiful.shadow_size or left_titlebar_size
end
local function get_right_titlebar_size()
  return beautiful.shadow_size
end

local function get_empty_space_above_title()
  return get_top_titlebar_size() - visible_titlebar_size - overlaping_content_size
end

local function get_corner_shadow(vpos, hpos, corner_size)

  local cs = corner_size or 0
  local x = (hpos == "left") and corner_size or 0
  local y = (vpos == "top") and corner_size or 0


  return {
    widget = wibox.container.background,
    bg = {
        type = "radial",
        from = { x, y, cs },
        to = { x, y, cs - beautiful.shadow_size },
        stops = { { 0, beautiful.invisible }, { 1, beautiful.shadow_color } },
    },
    {
        widget = wibox.container.margin,
        top  = cs,
        left = cs,
    },
  }
end

local function get_edge_shadow(pos, height, width)

  local x0 = (pos == "right") and beautiful.shadow_size or 0
  local x1 = (pos == "left") and beautiful.shadow_size or 0
  local y0 = (pos == "bottom") and beautiful.shadow_size or 0
  local y1 = (pos == "top") and beautiful.shadow_size or 0

  return {
    widget = wibox.container.background,
    bg = {
        type = "linear",
        from = { x0, y0 },
        to = { x1, y1 },
        stops = { { 0, beautiful.invisible }, { 1, beautiful.shadow_color } },
    },
    {
        widget = wibox.container.margin,
        top    = height or 0,
        left   = width or 0,

    },
  }
end

local function get_top_shadows()
  return {
    widget = wibox.container.margin,
    left = get_left_titlebar_size() - beautiful.shadow_size,
    {
      layout = wibox.layout.fixed.vertical,
      {
        widget = wibox.container.background,
        bg = beautiful.invisible,
        {
          widget = wibox.container.margin,
          top = get_empty_space_above_title() - beautiful.shadow_size,
        },
      },
      {
        layout = wibox.layout.align.horizontal,
        get_corner_shadow("top", "left", beautiful.shadow_size + visible_titlebar_radius),
        {
          layout = wibox.layout.fixed.vertical,
          get_edge_shadow("top", beautiful.shadow_size),
        },
        get_corner_shadow("top", "right", beautiful.shadow_size + visible_titlebar_radius),
      },
      {
        layout = wibox.layout.align.horizontal,
        expand = inside,
        get_edge_shadow("left", overlaping_content_size + visible_titlebar_size - visible_titlebar_radius, beautiful.shadow_size),
        {
          widget = wibox.container.margin,
        },
        get_edge_shadow("right", overlaping_content_size + visible_titlebar_size - visible_titlebar_radius, beautiful.shadow_size),
      },
    },
  }
end

local function get_bottom_shadows()
  return {
    widget = wibox.container.margin,
    left = get_left_titlebar_size() - beautiful.shadow_size,
    {
      layout = wibox.layout.align.horizontal,
      expand = 'inside',
      get_corner_shadow("bottom", "left", beautiful.shadow_size),
      get_edge_shadow("bottom"),
      get_corner_shadow("bottom", "right", beautiful.shadow_size),
    },
  }

end

local function get_left_shadows()
  return {
    widget = wibox.container.margin,
        left = get_left_titlebar_size() - beautiful.shadow_size,
        get_edge_shadow("left"),
    }
end

local function get_right_shadows()
  return get_edge_shadow("right")
end

local function get_sun(c)

  local top_margin  = get_empty_space_above_title() + sun_ypos - (sun_size / 2)
  local left_margin = get_left_titlebar_size() + sun_xpos - (sun_size / 2)

  return {
      widget = wibox.container.margin,
      top    = top_margin,
      left   = left_margin,
      bottom = get_top_titlebar_size() - top_margin - sun_size,
      {
        layout = wibox.layout.stack,
        {
          widget = wibox.widget.imagebox,
          image = beautiful.spacedrol_hot_icon,
        },
        {
          layout = wibox.layout.fixed.horizontal,
          {
            widget = wibox.container.margin,
            top = 5,
            left = 5,
            bottom = 15,
            {
              widget = wibox.container.background,
              --bg = "#ff0000",
              forced_width = 25,
              awful.titlebar.widget.button(
                c,
                "Tile",
                function() end,
                function()
                  if not c.fixed then
                    c.floating = not c.floating
                  end
                end
              ),
            },
          },
        },
      },
  }
end

local function get_moon(c)
  local top_margin  = get_empty_space_above_title() + moon_ypos - (moon_size / 2)
  local left_margin = get_left_titlebar_size() + moon_xpos - (moon_size / 2)

  return {
      widget = wibox.container.margin,
      top    = top_margin,
      left   = left_margin,
      bottom = get_top_titlebar_size() - top_margin - moon_size,
      {
        layout = wibox.layout.stack,
        {
          widget = wibox.widget.imagebox,
          image = beautiful.spacedrol_cold_icon,
        },
        {
          layout = wibox.layout.fixed.horizontal,
          {
            widget = wibox.container.margin,
            margins = 5,
            {
              widget = wibox.container.background,
              --bg = "#00ff00",
              forced_width = 45,
              awful.titlebar.widget.button(
                c,
                "Close",
                function() end,
                function() c:kill() end
              ),
            },
          },
        },
      },
  }
end

local function get_earth(c, titlebar)

  if (titlebar == "top") then
    local top_margin  = get_empty_space_above_title() + earth_ypos - (earth_size / 2)
    local left_margin = get_left_titlebar_size() + earth_xpos - (earth_size / 2)

    return {
      widget = wibox.container.margin,
      top    = top_margin,
      left   = left_margin,
      bottom = get_top_titlebar_size() - top_margin - earth_size,
      {
        layout = wibox.layout.stack,
        {
          widget = wibox.widget.imagebox,
          image = beautiful.spacedrol_earth_icon,
        },
        {
          layout = wibox.layout.fixed.horizontal,
          {
            widget = wibox.container.margin,
            top = 5,
            left = 15,
            {
              widget = wibox.container.background,
              --bg = "#ff00ff",
              forced_width = 26,
              awful.titlebar.widget.button(
                c,
                "Fullscreen",
                function() end,
                function()
                  if not c.fixed then
                    c.fullscreen = not c.fullscreen
                    c:raise()
                  end
                end
              ),
            },
          },
          {
            widget = wibox.container.margin,
            top = 23,
            left = 0,
            {
              widget = wibox.container.background,
              --bg = "#ff00ff",
              forced_width = 20,
              awful.titlebar.widget.button(
                c,
                "Fullscreen",
                function() end,
                function()
                  if not c.fixed then
                    c.fullscreen = not c.fullscreen
                    c:raise()
                  end
                end
              ),
            },
          },
        },
      },
    }
  else
    local top_margin  = get_empty_space_above_title() + earth_ypos - (earth_size / 2) - get_top_titlebar_size()
    local left_margin = get_left_titlebar_size() + earth_xpos - (earth_size / 2)

    return {
      widget = wibox.container.margin,
      top    = top_margin,
      left   = left_margin,
      right  = get_left_titlebar_size() - left_margin - earth_size,
      {
        layout = wibox.layout.stack,
        {
          widget = wibox.widget.imagebox,
          image = beautiful.spacedrol_earth_icon,
        },
        {
          layout = wibox.layout.fixed.vertical,
          {
            widget = wibox.container.margin,
            top = 22,
            left = 5,
            {
              widget = wibox.container.background,
              --bg = "#ff00ff",
              forced_height = 63,
              awful.titlebar.widget.button(
                c,
                "Fullscreen",
                function() end,
                function()
                  if not c.fixed then
                    c.fullscreen = not c.fullscreen
                    c:raise()
                  end
                end
              ),
            },
          },
        },
      },
    }
  end
end

local function get_color(c)
    pb = pixbuf_get_from_surface(gears.surface(c.content), 200, 2, 1, 1)
        bytes = pb:get_pixels()
        return "#" .. bytes:gsub(".", function(c) return ("%02x"):format(c:byte()) end)
end

local function get_title(c, overlap_content_color)

  -- buttons for the titlebar
  local buttons = gears.table.join(
      awful.button({ }, 1, function()
          c:emit_signal("request::activate", "titlebar", {raise = true})
          awful.mouse.client.move(c)
      end),
      awful.button({ }, 3, function()
          c:emit_signal("request::activate", "titlebar", {raise = true})
          awful.mouse.client.resize(c)
      end)
  )

  local empty_space_above_title = {
    widget = wibox.container.margin,
    top = get_empty_space_above_title(),
  }

  local title = {
    widget = wibox.container.margin,
    left = get_left_titlebar_size(),
    right = get_right_titlebar_size(),
    {
        widget = wibox.container.background,
        bg = beautiful.titlebar_bg,
        shape = function(cr, width, height)
            return gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, visible_titlebar_radius)
        end,

        { -- Title
          widget = wibox.container.margin,
          left   = moon_xpos + (moon_size / 2),
          right  = moon_xpos + (moon_size / 2),
          {
            layout  = wibox.layout.flex.horizontal,
            buttons = buttons,
            {
              widget = awful.titlebar.widget.titlewidget(c),
              align  = "center",
            },
          },
        },
    },
  }

  local fake_content_overlap = {
    widget = wibox.container.margin,
    left = get_left_titlebar_size(),
    right = get_right_titlebar_size(),
    {
      widget = wibox.container.background,
      bg = overlap_content_color or beautiful.titlebar_bg,
      {
        widget = wibox.container.margin,
        top = overlaping_content_size,
      },
    },
  }

  return {
      layout  = wibox.layout.align.vertical,
      empty_space_above_title,
      title,
      fake_content_overlap,
  }
end

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)

  local top_tb = awful.titlebar(c, {
      position = 'top',
      bg = beautiful.invisible,
      size = get_top_titlebar_size(),
  })

  local bottom_tb = awful.titlebar(c, {
      position = 'bottom',
      bg = beautiful.invisible,
      size = get_bottom_titlebar_size(),
  })

  local left_tb = awful.titlebar(c, {
      position = 'left',
      bg = beautiful.invisible,
      size = get_left_titlebar_size(),
  })

  local right_tb = awful.titlebar(c, {
      position = 'right',
      bg = beautiful.invisible,
      size = get_right_titlebar_size(),
  })

  top_tb : setup {
      layout = wibox.layout.stack,
      get_sun(c),
      get_earth(c, "top"),
      get_top_shadows(),
      get_title(c),
      get_moon(c),
  }

  bottom_tb : setup(get_bottom_shadows())

  left_tb: setup {
     layout = wibox.layout.stack,
     get_earth(c, "left"),
     get_left_shadows(),
  }

  right_tb : setup(get_right_shadows())

  gtimer_weak_start_new(0.03,
    function()
      local calculated_color = get_color(c)

      top_tb : setup {
        layout = wibox.layout.stack,
        get_sun(c),
        get_earth(c, "top"),
        get_top_shadows(),
        get_title(c, calculated_color),
        get_moon(c),
      }

      c:disconnect_signal("request::activate", c._cb_add_window_decorations)
    end
  )

end)

awful.titlebar.enable_tooltip = false
client.connect_signal("property::floating", function(c)
    if(c.floating) then
        awful.titlebar.show(c, "top")
        awful.titlebar.show(c, "bottom")
        awful.titlebar.show(c, "left")
        awful.titlebar.show(c, "right")
    else
        awful.titlebar.hide(c, "top")
        awful.titlebar.hide(c, "bottom")
        awful.titlebar.hide(c, "left")
        awful.titlebar.hide(c, "right")
    end
end)
