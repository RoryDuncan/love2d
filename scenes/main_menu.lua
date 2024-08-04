Signal = require 'lib.hump.signal'

local main_menu = {
    events = Signal.new(),
}
local cursor = 1;
local options = {
    Start = "Start",
    Options = "Options",
    Exit = "Exit",
}
-- poor man's enum
local lookup = {
    options.Start,
    options.Options,
    options.Exit,
}

function main_menu:init()
    main_menu.state = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
        font = love.graphics.newFont(20, "mono", 2),
    }

    love.keyboard.setKeyRepeat(false)
end

function main_menu:enter()
    main_menu.events:register("selection", function(selection)
        if selection == options.Exit then
            Signal.emit("game:quit")
        elseif selection == options.Start then
            Signal.emit("game:start")
        elseif selection == options.Options then
            Signal.emit("game:options")
        end
    end)
end

function main_menu:exit()

end

function main_menu:update(dt)

end

function main_menu:keypressed(key)
    if key == "down" or key == "up" then
        if key == "down" then
            cursor = cursor + 1
        elseif key == "up" then
            cursor = cursor - 1
        end

        if cursor > #lookup then
            cursor = 1;
        elseif cursor < 1 then
            cursor = #lookup
        end

        print("hovering on: " .. lookup[cursor])
    end





    if key == "return" then
        local selection = lookup[cursor]
        main_menu.events:emit("selection", selection)
    end
end

function main_menu:draw()
    love.graphics.setBackgroundColor(1, 0.9, 0.9)
    local index = 1;
    local line_height = 42;
    local offset = 200;


    local cursor_y = offset + (line_height * cursor) - 10
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 10, cursor_y, main_menu.state.width - 20, line_height)

    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(main_menu.state.font)
    for k, label in pairs(lookup) do
        local y = offset + (line_height * index)
        love.graphics.print(label, offset, y)
        index = index + 1
    end
end

return main_menu;
