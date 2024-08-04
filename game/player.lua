local bump = require "lib.bump"
local theme = require "game.theme";
local world = require "game.world"
local Cooldown = require "game.cooldown"

local player = {
    type = "player",
    game_width = 0,
    game_height = 0,
    x_velocity = 0,
    y_velocity = 0,
    x = 0,
    y = 0,
    width = 24,
    height = 24,
    scale = 0.5,
    polygon = {
        0, 0,
        24, 24,
        -24, 24,
    },

    weapon_attack = nil
}

function player:enter(scene)
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    player.game_width = width;
    player.game_height = height;
    player.weapon_attack = Cooldown(100, function() scene:on_weapon_attack() end)

    player.x = (width + player.width) / 2
    player.y = height - (player.height * 2)

    world:add(player, player.x, player.y, player.width, player.height)
end

function player:exit()

end

function player:reset()

end

function player:update(dt)
    self:handle_movement(dt);
    self:handle_shooting(dt);
end

function player:handle_movement(dt)
    local DRAG_PER_FRAME = 0.015;
    local MAX_SPEED = 16 * 50;
    local BASE_ACCELERATION = 30
    local QUICK_TURN_MODIFER = 2.5;

    local move = {
        left = love.keyboard.isDown("left"),
        right = love.keyboard.isDown("right"),
        up = love.keyboard.isDown("up"),
        down = love.keyboard.isDown("down"),
    }


    -- Apply drag to x axis
    if not move.left and not move.right then
        player.x_velocity = player.x_velocity * (1 - DRAG_PER_FRAME)
        if math.abs(player.x_velocity) < 2 then
            player.x_velocity = 0
        end
    end

    -- Apply drag to y axis
    if not move.up and not move.down then
        player.y_velocity = player.y_velocity * (1 - DRAG_PER_FRAME)
        if math.abs(player.y_velocity) < 2 then
            player.y_velocity = 0
        end
    end

    if move.right then
        local mod = 1
        if (player.x_velocity < 0) then mod = QUICK_TURN_MODIFER end;
        local acceleration = (player.x_velocity + (BASE_ACCELERATION * mod))
        player.x_velocity = acceleration
    end

    if move.left then
        local mod = 1
        if (player.x_velocity > 0) then mod = QUICK_TURN_MODIFER end;
        local acceleration = (player.x_velocity - (BASE_ACCELERATION * mod))
        player.x_velocity = acceleration
    end

    if move.down then
        local mod = 1
        if (player.y_velocity < 0) then mod = QUICK_TURN_MODIFER end;
        local acceleration = (player.y_velocity + (BASE_ACCELERATION * mod))
        player.y_velocity = acceleration
    end

    if move.up then
        local mod = 1
        if (player.y_velocity > 0) then mod = QUICK_TURN_MODIFER end;
        local acceleration = (player.y_velocity - (BASE_ACCELERATION * mod))
        player.y_velocity = acceleration
    end

    local x_speed = math.max(MAX_SPEED * -1, math.min(MAX_SPEED, player.x_velocity));
    local y_speed = math.max(MAX_SPEED * -1, math.min(MAX_SPEED, player.y_velocity));


    player.x = player.x + x_speed * dt;
    player.y = player.y + y_speed * dt;

    world:update(player, player.x, player.y, player.width, player.height)

    self:lock_to_screen();
end

function player:handle_shooting(dt)
    if self.weapon_attack then
        ---@diagnostic disable-next-line: undefined-field
        self.weapon_attack:update(dt)
        local space = love.keyboard.isDown("space")
        if space then
            ---@diagnostic disable-next-line: undefined-field
            self.weapon_attack:trigger()
        end
    end
end

function player:draw()
    local x = self.x;
    local y = self.y;
    local w = self.width;
    local h = self.height;
    local cx = w / 2;
    local cy = h / 2;

    love.graphics.translate(x + cx, y + cy)
    love.graphics.scale(player.scale, player.scale)
    love.graphics.setColor(unpack(theme.ship))
    love.graphics.polygon("fill", player.polygon)
    love.graphics.origin()
    -- love.graphics.rectangle("line", x, y, w, h)
    love.graphics.print(string.format("%.1f", player.weapon_attack.wait_time * 1000), x + 30, y + cy)
end

function player:lock_to_screen()
    local left_bounds = 0;
    local top_bounds = 0;
    local right_bounds = player.game_width - player.width
    local bottom_bounds = player.game_height - player.height

    if (player.x > right_bounds) or (player.x < left_bounds) then
        player.x_velocity = player.x_velocity * 0.1
    elseif player.y > bottom_bounds or player.y < top_bounds then
        player.y_velocity = player.y_velocity * -0.1
    end

    player.x = math.min(right_bounds, math.max(player.x, left_bounds))
    player.y = math.min(bottom_bounds, math.max(player.y, top_bounds))
end

return player
