
local naughty = require("naughty")

function get_color(source_color, target_color, t)

    if string.len(source_color) ~= 7 and string.len(source_color) ~= 9 then
        source_color = "#000000FF"
    elseif string.len(source_color) == 7 then
        source_color = source_color .. "FF"
    end

    if string.len(target_color) ~= 7 and string.len(target_color) ~= 9 then
        target_color = "#000000FF"
    elseif string.len(target_color) == 7 then
        target_color = target_color .. "FF"
    end

    local source_r = color_channel_to_decimal(string.sub(source_color, 2, 3))
    local source_g = color_channel_to_decimal(string.sub(source_color, 4, 5))
    local source_b = color_channel_to_decimal(string.sub(source_color, 6, 7))
    local source_a = color_channel_to_decimal(string.sub(source_color, 8, 9))

    local target_r = color_channel_to_decimal(string.sub(target_color, 2, 3))
    local target_g = color_channel_to_decimal(string.sub(target_color, 4, 5))
    local target_b = color_channel_to_decimal(string.sub(target_color, 6, 7))
    local target_a = color_channel_to_decimal(string.sub(target_color, 8, 9))

    local interpolated_r = decimal_to_color_channel((target_r - source_r) * t + source_r)
    local interpolated_g = decimal_to_color_channel((target_g - source_g) * t + source_g)
    local interpolated_b = decimal_to_color_channel((target_b - source_b) * t + source_b)
    local interpolated_a = decimal_to_color_channel((target_a - source_a) * t + source_a)

    return "#" .. interpolated_r .. interpolated_g .. interpolated_b .. interpolated_a
end

function color_channel_to_decimal(input)
    input = string.upper(input)
    local output = 0
    local digits = 2
    if string.len(input) ~= digits then
      return 0
    end


    local values = "0123456789ABCDEF"
    local base = 16

    for i = digits, 1, -1 do
        local number_pos = digits - i
        local character = string.sub(input, i, i)
        local decValue = string.find(values, character) - 1
        output = output + decValue * math.pow(base, number_pos)
    end

    return tostring(output)
end

function decimal_to_color_channel(input)
    input = math.max(math.min(math.floor(input), 255), 0)
    local output = ""
    local digits = 2

    local values = "0123456789ABCDEF"
    local base = 16
    local D = 0

    local pos = 0
    while input > 0 do
        pos=pos+1

        D = math.floor(input % base + 1)
        input = math.floor(input/base)
        output=string.sub(values,D,D)..output
    end


    while pos < digits do
        pos=pos+1
        output = "0" .. output
    end

    return output
end
