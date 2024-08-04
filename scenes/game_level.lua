local Signal = require 'lib.hump.signal'
local theme = require 'game.theme'
local enemy = require "game.enemy"
local player = require "game.player"
local projectiles = require "game.projectile"
local squadron = require "game.squadron"
local world = require "game.world";

local collisions = Signal.new()
local game_level = {
    player_health = 10,
    width = 0,
    height = 0,
}

function game_level:init()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()


    game_level.state = {
        width = w,
        height = h,
        font = love.graphics.newFont(20, "mono", 2),
    }

    player:enter(game_level)
    squadron:enter(w, h)
end

function game_level:on_weapon_attack()
    local bullet_width = 4
    local bullet_height = 4
    local cy = player.y + player.height
    projectiles:create_projectile(player.x, cy, { 0, -750 }, {
        w = bullet_width,
        h = bullet_height,
    })
    projectiles:create_projectile(player.x + player.width, cy, { 0, -750 }, {
        w = bullet_width,
        h = bullet_height,
    })
end

function game_level:enter()
    print "Welcome to Raiden"

    squadron:create(5, 0, 0, { 0, 0.5 })
    squadron:create(5, 2.5, 0, { 0, 1 }, true)
    squadron:create(20, 5, 0.5, { 0, 1.5 })
    squadron:create(3, 5, 0.75, { 0, 3 }, true)
    squadron:create(20, 10, 0.5, { 0, 1 })
    squadron:create(50, 15, 0, { 0, 0.5 })


    collisions:register("collision", function(colliders, moved_thing)
        for i = 1, #colliders do
            local instance = colliders[i]
            local collided_thing = instance.other;

            if moved_thing.type == "projectile" then
                if collided_thing.type == "enemy" then
                    print "enemy collided with a projectile"
                    world:remove(collided_thing)
                    if world:hasItem(collided_thing) then
                        projectiles:destroy(collided_thing)
                    end
                    collided_thing.destroy()
                    moved_thing.destroy()
                end
            elseif moved_thing.type == "enemy" then
                if collided_thing.type == "player" then
                    print "enemy collided with player"
                    game_level.player_health = game_level.player_health - 10
                elseif collided_thing.type == "projectile" then
                    print "enemy collided with a projectile"
                end
            end
        end
        -- if collider == player then
        --     print "collided with player"
        --     game_level.player_health = game_level.player_health - 5
        -- else
        --     print "collided with something else"
        -- end
    end)
end

function game_level:exit()
    collisions:clear("collision")
end

function game_level:update(dt)
    player:update(dt)
    projectiles:update(dt, collisions)
    enemy:update(dt, collisions)

    if game_level.player_health <= 0 then
        Signal.emit("game:over")
    end
end

function game_level:draw()
    love.graphics.setBackgroundColor(unpack(theme.background))

    enemy:draw()
    player:draw()
    projectiles:draw()

    love.graphics.print(tostring(game_level.player_health), game_level.state.width - 100, game_level.state.height - 50)
    love.graphics.print(tostring(world:countItems()), game_level.state.width - 100, game_level.state.height - 25)
end

function game_level:keypressed(key)
    print(key)
    if key == "escape" then
        Signal.emit "game:quit"
    end
end

return game_level;
