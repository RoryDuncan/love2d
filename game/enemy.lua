local Signal = require 'lib.hump.signal'
local theme = require 'game.theme'
local world = require "game.world"
local box = require "core.box"

--- @class Enemy
--- @field events table
local enemy = {
    polygon = {
        0, 0,
        20, 0,
        20, 5,
        10, 30,
        0, 5,
    }
}

local pool = {}
local pending_deletions = {}

function enemy:enter()

end

function enemy:destroy(instance)
    if world:hasItem(instance) then
        world:remove(instance)
    end

    for i = 1, #pool do
        if pool[i] == instance then
            table.remove(pool, i)
            break
        end
    end
end

function enemy:new(x, y, speed, w, h)
    local instance = {
        type = "enemy",
        x = x,
        y = y,
        w = w or 20,
        h = h or 20,
        speed = speed or { 0, 1 },
    }

    instance.destroy = function()
        table.insert(pending_deletions, instance)
    end

    print("Adding enemy" .. tostring(#pool))
    table.insert(pool, instance)
    world:add(instance, instance.x, instance.y, instance.w, instance.h)

    return instance
end

local collision_type = function(item, type) return "cross"; end

function enemy:update(dt, collisions)
    local w = love.graphics.getWidth();
    local h = love.graphics.getHeight();

    for i = 1, #pool do
        local instance = pool[i]
        if world:hasItem(instance) then
            local x_speed = instance.speed[1]
            local y_speed = instance.speed[2]

            instance.x = instance.x + x_speed
            instance.y = instance.y + y_speed

            local actualX, actualY, cols, len = world:move(instance, instance.x, instance.y, collision_type)
            if len > 0 then
                collisions:emit("collision", cols, self)
            elseif self:has_left_screen(instance, w, h) then
                instance.destroy()
            end
        end
    end

    if #pending_deletions > 0 then
        print "Removing marked enemies"
        for i, v in ipairs(pending_deletions) do
            enemy:destroy(v)
        end
        pending_deletions = {}
    end
end

function enemy:has_left_screen(instance, w, h)
    local MARGIN = 100
    local is_outside = box.point_outersection(instance.x, instance.y, {
        x = MARGIN * -1,
        y = MARGIN * -1,
        w = w + MARGIN,
        h = h + MARGIN,
    })

    return is_outside
end

function enemy:draw()
    for i = 1, #pool do
        local instance = pool[i]
        love.graphics.setColor(unpack(theme.enemy_1))
        local cx = instance.w / 2
        local cy = instance.h / 2
        love.graphics.push()
        love.graphics.translate(instance.x, instance.y)

        love.graphics.polygon("fill", enemy.polygon)
        love.graphics.pop()
    end
end

return enemy
