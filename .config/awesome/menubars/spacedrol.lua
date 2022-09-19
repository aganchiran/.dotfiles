
local menubar = require("my_menubar")
local rubato = require("lib.rubato")
local wibox = require("wibox")
local awful = require("awful")
local theme = require("beautiful")

local spacedrol_icon_box = wibox {
    visible = false,
    ontop = true,
    height = 100,
    width = 100,
}

local spacedrol_icon = wibox.widget {
    widget = wibox.widget.imagebox,
    forced_height = 28,
    forced_width = 28,
}

spacedrol_icon:connect_signal("button::press", function(c) menubar.hide() end)

spacedrol_icon_box:setup {
    layout = wibox.container.place,
    valigh = 'center',
    haligh = 'center',
    spacedrol_icon,
}

awful.placement.bottom_left(spacedrol_icon_box, { margins = {bottom = -31, left = -31}, parent = awful.screen.focused()})

menubar_shown = false
menubar_body_timed = rubato.timed {
    intro = 0.2,
    duration = 0.4,
    easing = rubato.quadratic,
    subscribed = function(pos)
        icon_ratio = 0.3
        menubar_ratio = 0.8
        menubar_width = math.min(math.max((pos - (1 - menubar_ratio)) / menubar_ratio * 1920, 1), 1920)
        icon_size = math.min(math.max((pos / icon_ratio) * 72, 1) + 28, 100)

        if menubar.get_instance() ~= nil then
            if pos <= 0 and menubar_body_timed.target == 0 then
                menubar.get_instance().wibox.visible = false
                spacedrol_icon_box.visible = false
                menubar.get_instance().query = nil
                menubar_shown = false
            end

            menubar.get_instance().wibox.width = menubar_width
            spacedrol_icon.forced_width = icon_size
            spacedrol_icon.forced_height = icon_size
        end
    end
}

local function theme_icon()
  spacedrol_icon.image = theme.spacedrol_moon_icon
  spacedrol_icon_box.bg = theme.invisible
end

local original_menubar_show = menubar.show
function menubar.show()

  if (menubar_shown) then
    menubar.get_instance().wibox.visible = false
    spacedrol_icon_box.visible = false
    menubar.get_instance().query = nil
    menubar_shown = false
  end

  if not instance then
    theme_icon()
  end

  original_menubar_show()

  menubar_body_timed.target = 1
  spacedrol_icon_box.visible = true
  menubar_shown = true
end

function menubar.hide()
  menubar_body_timed.target = 0
end

return setmetatable(menubar, {})
