_G.love          = require "love"
Gamestate        = require "lib.hump.gamestate"
Signal           = require "lib.hump.signal"
local bump       = require "lib.bump"
local main_menu  = require "scenes.main_menu"
local game_level = require "scenes.game_level"
local world      = require "game.world"
Timer            = require "lib.hump.timer"

if arg[2] == "debug" then
    if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
        require("lldebugger").start()
    end
end


function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(game_level)

    Signal.register("game:start", function()
        Gamestate.switch(game_level)
    end)

    Signal.register("game:options", function()
        -- todo
    end)

    Signal.register("game:over", function()
        -- todo
        print "Game Over"
    end)

    Signal.register("game:quit", function()
        love.event.quit()
    end)
end

function love.update(dt)
    Timer.update(dt)
end

local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end

function love.keypressed()

end

function love.draw()

end

function love.conf(t)
    t.console = true
end
