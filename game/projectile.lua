local Signal = require "lib.hump.signal"
local Class = require "lib.hump.signal"
local theme = require "game.theme"
local world = require "game.world"
local box = require "core.box"

local pool = {}
local ProjectilePool = {}
local pending_deletions = {}

local filter = function() return "cross" end

function ProjectilePool:update(dt, collisions)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    for i = 1, #pool do
        local instance = pool[i]
        if world:hasItem(instance) then
            local x_speed = instance.speed[1] * dt
            local y_speed = instance.speed[2] * dt
            instance.x = instance.x + x_speed
            instance.y = instance.y + y_speed
            local actualX, actualY, cols, len = world:move(instance, instance.x, instance.y, filter)
            if len > 0 then
                print("item left screen" .. tostring(instance))
                collisions:emit("collision", cols, instance)
            elseif self:has_left_screen(instance, w, h) then
                print("item left screen" .. tostring(instance))
                instance.destroy()
            end
        end
    end

    if #pending_deletions > 0 then
        print "Removing marked projectiles"
        for i, v in ipairs(pending_deletions) do
            print("attempting to remove " .. tostring(v))
            ProjectilePool:destroy(v)
        end
        pending_deletions = {}
    end
end

function ProjectilePool:draw()
    for i = 1, #pool do
        local instance = pool[i]
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", instance.x, instance.y, instance.w, instance.h)
    end
end

function ProjectilePool:clear()
    pool = {}
end

function ProjectilePool:has_left_screen(instance, w, h)
    local MARGIN = 100
    local is_outside = box.point_outersection(instance.x, instance.y, {
        x = MARGIN * -1,
        y = MARGIN * -1,
        w = w + MARGIN,
        h = h + MARGIN,
    })

    return is_outside
end

function ProjectilePool:destroy(instance)
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

function ProjectilePool:create_projectile(x, y, speed, other_fields)
    print "creating projectile"
    local o = other_fields or {}
    local projectile = {
        type = "projectile",
        x = x,
        y = y,
        speed = speed,
        w = o.w or 2,
        h = o.h or 2,
        color = o.color or { r = 0.5, g = 0.5, b = 0.5, a = 1, }
    }

    projectile.destroy = function()
        print "marking projectile for removal"
        table.insert(pending_deletions, projectile)
    end

    print("Color is " .. string.format("%f1", projectile.color.r))

    world:add(projectile, projectile.x, projectile.y, projectile.w, projectile.h)
    table.insert(pool, projectile)

    return projectile
end

return ProjectilePool
