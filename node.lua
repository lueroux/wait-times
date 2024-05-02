gl.setup(1920, 1080)  -- Swap width and height for the rotated display

local menu, font, font_size, color
local dots = resource.load_image "dots.png"
local range_y1, range_y2  -- Adjusted for vertical display

local function Resource()
    local res, nxt
    local function set(asset)
        nxt = resource.load_image(asset.asset_name)
    end
    local function draw(...)
        if nxt and nxt:state() == "loaded" then
            if res then res:dispose() end
            res, nxt = nxt, nil
        end
        if res then
            return res:draw(...)
        end
    end
    return {
        set = set;
        draw = draw;
    }
end

local background = Resource()

util.json_watch("config.json", function(config)
    background.set(config.background)
    color = config.text_color
    font = resource.load_font(config.font.asset_name)
    font_size = config.font_size
    items = config.items
    range_y1 = config.text_range[1]  -- Adjusted for vertical display
    range_y2 = config.text_range[2]  -- Adjusted for vertical display
end)

function node.render()
    background.draw(0, 0, WIDTH, HEIGHT)
    local x = 50  -- Adjusted for vertical display
    for idx, item in ipairs(items) do
        if item.text == "" then
            x = x + font_size * 0.5  -- Adjusted for vertical display
        elseif item.time == "" then
            font:write(x, range_y1, item.text, font_size * 1.2, color.r, color.g, color.b)  -- Adjusted for vertical display
            x = x + font_size * 1.3  -- Adjusted for vertical display
        else
            local h = font:height(item.text, font_size)  -- Adjusted for vertical display
            font:write(x, range_y1, item.text, font_size, color.r, color.g, color.b, 0.8)  -- Adjusted for vertical display
            local y_start = range_y1 + h + 10  -- Adjusted for vertical display

            local h = font:height(item.time, font_size)  -- Adjusted for vertical display
            font:write(x, range_y2 - h, item.time, font_size, color.r, color.g, color.b, 0.8)  -- Adjusted for vertical display

            local y_end = range_y2 - h - 10  -- Adjusted for vertical display

            local h = y_end - y_start  -- Adjusted for vertical display
            h = h - (h % 20)  -- Adjusted for vertical display
            dots:draw(x + font_size - 25, y_start, x + font_size - 10, y_end, 0.8, 0, 0, 1, 1/1080 * h)  -- Adjusted for vertical display
            x = x + font_size * 1.05  -- Adjusted for vertical display
        end
    end
end
