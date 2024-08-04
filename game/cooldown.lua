local Class = require "lib.hump.class";


local Cooldown = Class({
    init = function(self, cooldown, effect)
        self.cooldown = (cooldown or 1000) / 1000
        self.on_cooldown = false
        self.effect = effect or nil
        self.wait_time = self.cooldown
        self.has_effect = effect ~= nil
    end,
})

function Cooldown:add_effect(effect)
    self.effect = effect
    self.has_effect = effect ~= nil
end

function Cooldown:update(dt)
    if self.on_cooldown then
        -- count up to the effect rate
        self.wait_time = self.wait_time - dt
        if self.wait_time <= 0 then
            self.on_cooldown = false
            self.wait_time = 0
        end
    end
end

function Cooldown:trigger()
    if not self.on_cooldown and self.has_effect then
        self.effect()
        self.wait_time = self.cooldown
        self.on_cooldown = true
    end
end

return Cooldown
