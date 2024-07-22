local Scene = require("core/scene");

local cursor = 1;
local options = {
    "Start",
    "Options",
    "Exit",
}

local state = {
    width = 0,
    height = 0,
    font = nil,
}

local enter = function()
    love.keyboard.setKeyRepeat(false)
    state = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
        font = love.graphics.newFont(20, "mono", 2),
    }
end

local exit = function()

end

local limiter = 0;

local update = function(dt)
    local isDown = love.keyboard.isDown("down")
    local isUp = love.keyboard.isDown("up")

    if limiter > 0.1 then
        if isDown then
            limiter = 0
            cursor = cursor + 1;
        end

        if isUp then
            limiter = 0
            cursor = cursor - 1;
        end
    end

    limiter = limiter + dt;

    if cursor > #options then
        cursor = 1;
    elseif cursor < 1 then
        cursor = #options
    end
end

local draw = function()
    love.graphics.setBackgroundColor(1, 0.9, 0.9)
    local index = 1;
    local line_height = 42;
    local offset = 200;


    local cursor_y = offset + (line_height * cursor) - 10
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 10, cursor_y, state.width - 20, line_height)

    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(state.font)
    for k, label in pairs(options) do
        local y = offset + (line_height * index)
        love.graphics.print(label, offset, y)
        index = index + 1
    end
end


local menu = Scene.createScene({
    name = "Menu",
    enter = enter,
    exit = exit,
    update = update,
    draw = draw,
})


return menu;
