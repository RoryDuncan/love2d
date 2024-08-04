local Timer = require "lib.hump.timer"
local enemy = require "game.enemy"


local squadron = {}

function squadron:enter(w, h)
    self.w = w;
    self.h = h;
end

function squadron:create(count, start_delay, spawn_delay, speed, reverse)
    print "creating squadron"
    local right = (squadron.w - 200)
    Timer.after(start_delay, function()
        for i = 1, count do
            local x = ((right / count) * i) + 100
            local y = -10
            local spawn_amount = i * spawn_delay

            if reverse == true then
                spawn_amount = (count - i) * spawn_delay
            end

            Timer.after(spawn_amount, function()
                enemy:new(x, y, speed, 25, 25)
            end)
        end
    end)
end

return squadron
