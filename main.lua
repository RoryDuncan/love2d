_G.love     = require("love")
local Scene = require("core/scene")
local menu  = require("scenes/menu")

function love.load()
    Scene:change(menu)
end

function love.update(dt)
    Scene:update(dt);
end

function love.keypressed()

end

function love.draw()
    Scene:draw()
end

function love.conf(t)
    t.console = true
end
