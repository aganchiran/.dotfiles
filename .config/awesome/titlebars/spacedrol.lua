
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local animations = require("lib.animations")

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
  local x_offset = 20
  local y_offset = 20

  local sun_icon = wibox.widget.imagebox()
  sun_icon.image = beautiful.spacedrol_sun_icon
  sun_icon.opacity = 1
  local sun_icon_hover = wibox.widget.imagebox()
  sun_icon_hover.image = beautiful.spacedrol_sun_tile_icon
  sun_icon_hover.opacity = 0

  local hover_timed = animations:new({
      duration = 0.4,
      easing = animations.easing.outQuad,
      update = function(self, t)
        sun_icon:set_opacity(1 - t)
        sun_icon_hover:set_opacity(t)
        sun_icon:emit_signal("widget::redraw_needed")
      end
  })

  local sun_button_hitbox = awful.titlebar.widget.button(
    c,
    "Tile",
    function() end,
    function()
      if not c.fixed then
        hover_timed:set(0)
        c.floating = not c.floating
      end
    end
  )

  local top_margin  = get_empty_space_above_title() + sun_ypos - (sun_size / 2)
  local left_margin = get_left_titlebar_size() + sun_xpos - (sun_size / 2)

  local sun = wibox.container.margin()
  sun.top     = top_margin + y_offset
  sun.left    = left_margin + x_offset
  sun.bottom  = get_top_titlebar_size() - sun.top - sun_size
  sun.opacity = 0

  sun:setup {
    layout = wibox.layout.stack,
    sun_icon,
    sun_icon_hover,
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
          sun_button_hitbox,
        },
      },
    },
  }

  local appear_timed = animations:new({
      pos = 1,
      duration = 0.5,
      easing = animations.easing.outQuad,
      update = function(self, t)
        sun.top = top_margin + y_offset * t
        sun.left = left_margin + x_offset * t
        sun.bottom  = get_top_titlebar_size() - sun.top - sun_size
        sun.opacity = 1 - t
      end
  })

  sun.appear_timed = appear_timed
  sun.hover_timed = hover_timed
  sun.button_hitbox = sun_button_hitbox

  return sun
end

local function get_moon(c)
  local x_offset = 20
  local y_offset = -20

  local moon_icon = wibox.widget.imagebox()
  moon_icon.image = beautiful.spacedrol_moon_icon
  moon_icon.opacity = 1
  local moon_icon_hover = wibox.widget.imagebox()
  moon_icon_hover.image = beautiful.spacedrol_moon_close_icon
  moon_icon_hover.opacity = 0

  local hover_timed = animations:new({
      duration = 0.4,
      easing = animations.easing.outQuad,
      update = function(self, t)
        moon_icon:set_opacity(1 - t)
        moon_icon_hover:set_opacity(t)
        moon_icon:emit_signal("widget::redraw_needed")
      end
  })

  local moon_button_hitbox = awful.titlebar.widget.button(
    c,
    "Close",
    function() end,
    function()
      hover_timed:set(0)
      c:kill()
    end
  )

  local top_margin  = get_empty_space_above_title() + moon_ypos - (moon_size / 2)
  local left_margin = get_left_titlebar_size() + moon_xpos - (moon_size / 2)

  local moon = wibox.container.margin()
  moon.top     = top_margin + y_offset
  moon.left    = left_margin + x_offset
  moon.bottom  = get_top_titlebar_size() - moon.top - moon_size
  moon.opacity = 0

  moon:setup {
    layout = wibox.layout.stack,
    moon_icon,
    moon_icon_hover,
    {
      layout = wibox.layout.fixed.horizontal,
      {
        widget = wibox.container.margin,
        margins = 5,
        {
          widget = wibox.container.background,
          --bg = "#00ff00",
          forced_width = 45,
          moon_button_hitbox,
        },
      },
    },
  }

  local appear_timed = animations:new({
      pos = 1,
      duration = 0.5,
      easing = animations.easing.outQuad,
      update = function(self, t)
        moon.top = top_margin + y_offset * t
        moon.left = left_margin + x_offset * t
        moon.bottom  = get_top_titlebar_size() - moon.top - moon_size
        moon.opacity = 1 - t
      end
  })

  moon.appear_timed = appear_timed
  moon.hover_timed = hover_timed
  moon.button_hitbox = moon_button_hitbox

  return moon
end

local function get_earth(c)
  local x_offset = 30
  local y_offset = 0

  local earth_icon = wibox.widget.imagebox()
  earth_icon.image = beautiful.spacedrol_earth_icon
  earth_icon.opacity = 1
  local earth_icon_hover = wibox.widget.imagebox()
  earth_icon_hover.image = beautiful.spacedrol_earth_max_icon
  earth_icon_hover.opacity = 0

  local hover_timed = animations:new({
      duration = 0.4,
      easing = animations.easing.outQuad,
      update = function(self, t)
        earth_icon:set_opacity(1 - t)
        earth_icon_hover:set_opacity(t)
        earth_icon:emit_signal("widget::redraw_needed")
      end
  })

  local earth_button_hitbox = awful.titlebar.widget.button(
    c,
    "Fullscreen",
    function() end,
    function()
      if not c.fixed then
        hover_timed:set(0)
        c.fullscreen = not c.fullscreen
        c:raise()
      end
    end
  )

  local top_earth_top_margin  = get_empty_space_above_title() + earth_ypos - (earth_size / 2)
  local top_earth_left_margin = get_left_titlebar_size() + earth_xpos - (earth_size / 2)

  local top_earth = wibox.container.margin()
  top_earth.top     = top_earth_top_margin + y_offset
  top_earth.left    = top_earth_left_margin + x_offset
  top_earth.bottom  = get_top_titlebar_size() - top_earth.top - earth_size
  top_earth.opacity = 0

  top_earth:setup {
    layout = wibox.layout.stack,
    earth_icon,
    earth_icon_hover,
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
          earth_button_hitbox,
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
          earth_button_hitbox,
        },
      },
    },
  }

  local left_earth_top_margin  = get_empty_space_above_title() + earth_ypos - (earth_size / 2) - get_top_titlebar_size()
  local left_earth_left_margin = get_left_titlebar_size() + earth_xpos - (earth_size / 2)

  local left_earth = wibox.container.margin()
  left_earth.top     = left_earth_top_margin + y_offset
  left_earth.left    = left_earth_left_margin + x_offset
  left_earth.right   = get_left_titlebar_size() - left_earth.left - earth_size
  left_earth.opacity = 0

  left_earth:setup {
    layout = wibox.layout.stack,
    earth_icon,
    earth_icon_hover,
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
          earth_button_hitbox,
        },
      },
    },
  }

  local appear_timed = animations:new({
      pos = 1,
      duration = 0.5,
      easing = animations.easing.outQuad,
      update = function(self, t)
        top_earth.top     = top_earth_top_margin + y_offset * t
        top_earth.left    = top_earth_left_margin + x_offset * t
        top_earth.bottom  = get_top_titlebar_size() - top_earth.top - earth_size
        top_earth.opacity = 1 - t

        left_earth.top     = left_earth_top_margin + y_offset * t
        left_earth.left    = left_earth_left_margin + x_offset * t
        left_earth.right   = get_left_titlebar_size() - left_earth.left - earth_size
        left_earth.opacity = 1 - t
      end
  })

  return {
    top_earth = top_earth,
    left_earth = left_earth,
    appear_timed = appear_timed,
    hover_timed = hover_timed,
    button_hitbox = earth_button_hitbox,
  }
end

local function get_color(c)
  pb = pixbuf_get_from_surface(gears.surface(c.content), 200, 3, 1, 1)
  bytes = pb:get_pixels()
  return "#" .. bytes:gsub(".", function(c) return ("%02x"):format(c:byte()) end)
end

local function get_title(c)

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

  local title_box = {
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

  local fake_content_overlap = wibox.container.background()
  fake_content_overlap.bg = beautiful.titlebar_bg,
  fake_content_overlap:setup {
    widget = wibox.container.margin,
    top = overlaping_content_size,
  }

  local fake_content_overlap_with_margins = {
    widget = wibox.container.margin,
    left = get_left_titlebar_size(),
    right = get_right_titlebar_size(),
    fake_content_overlap,
  }

  return {
      fake_content_overlap = fake_content_overlap,
      main_bar = {
        layout  = wibox.layout.align.vertical,
        empty_space_above_title,
        title_box,
        fake_content_overlap_with_margins,
      },
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

  local sun = get_sun(c)
  local moon = get_moon(c)
  local earth = get_earth(c)
  local title = get_title(c)

  top_tb : setup {
      layout = wibox.layout.stack,
      sun,
      earth.top_earth,
      get_top_shadows(),
      title.main_bar,
      moon,
  }

  bottom_tb : setup(get_bottom_shadows())

  left_tb: setup {
      layout = wibox.layout.stack,
      earth.left_earth,
      get_left_shadows(),
  }

  right_tb : setup(get_right_shadows())


  earth.appear_timed:set(0)

  gears.timer.start_new(0.3, function()
    sun.appear_timed:set(0)
  end)

  gears.timer.start_new(0.1, function()
    moon.appear_timed:set(0)
  end)

  gears.timer.start_new(0.02, function()
    title.fake_content_overlap.bg = get_color(c)
    title.fake_content_overlap:emit_signal("widget::redraw_needed")
  end)


  sun.button_hitbox:connect_signal("mouse::enter", function()
    sun.hover_timed:set(1)
  end)
  sun.button_hitbox:connect_signal("mouse::leave", function()
    sun.hover_timed:set(0)
  end)

  moon.button_hitbox:connect_signal("mouse::enter", function()
    moon.hover_timed:set(1)
  end)
  moon.button_hitbox:connect_signal("mouse::leave", function()
    moon.hover_timed:set(0)
  end)

  earth.button_hitbox:connect_signal("mouse::enter", function()
    earth.hover_timed:set(1)
  end)
  earth.button_hitbox:connect_signal("mouse::leave", function()
    earth.hover_timed:set(0)
  end)

  c:connect_signal("unmanage", function()
    c.is_closing = true
  end)

end)

awful.titlebar.enable_tooltip = false
client.connect_signal("property::floating", function(c)

    local floating_geo = c.floating_geometry

    if(c.floating) then
        if c.is_opened ~= true then
          floating_geo.width = floating_geo.width + get_left_titlebar_size() + 5
          floating_geo.height = floating_geo.height + get_top_titlebar_size() + 5
        end

        awful.titlebar.show(c, "top")
        awful.titlebar.show(c, "bottom")
        awful.titlebar.show(c, "left")
        awful.titlebar.show(c, "right")

        if not c.fixed then
          floating_geo.width = math.min(floating_geo.width, c.screen.geometry.width - get_left_titlebar_size())
          floating_geo.height = math.min(floating_geo.height, c.screen.geometry.height - get_top_titlebar_size())
          c:geometry(floating_geo)
        end

        if c.is_opened ~= true then
          if #c.screen.all_clients - #c.screen.tiled_clients <= 1 then
            awful.placement.centered(c)
          else
            awful.placement.no_overlap(c)
          end

          c.is_opened = true
        end

    else
        if c.is_closing ~= true then
          awful.titlebar.hide(c, "top")
          awful.titlebar.hide(c, "bottom")
          awful.titlebar.hide(c, "left")
          awful.titlebar.hide(c, "right")
        end
    end
end)
