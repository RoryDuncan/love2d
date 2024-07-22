local Scene = {
    current = nil,
    mounted = nil,
    --- Switch to a different scene. Will exit the current scene before entering the parameter scene.
    ---@param target Scene,
    ---@return table previous The scene that was just exited, or nil
    change = function(self, target)
        if self.current then
            print("Switching scenes")
            if self.current.exit then
                print("Exiting Scene: " .. self.current.name)
                self.current:exit()
            end
        end

        if target.enter then
            print("Entering Scene: " .. target.name)
            target:enter();
        end

        local previous = self.current;
        self.current = target
        return previous
    end,

    --- Set a sub-scene
    ---@param scene Scene, any
    mount = function(self, scene)
        if self.current then
            if scene.enter then
                scene.enter(self.previous)
            end

            self.mounted = scene
        end
    end,

    --- Set a sub-scene
    ---@param scene Scene, any
    unmount = function(self, scene)
        if self.current then
            if scene.exit then
                scene.exit()
            end
            self.mounted = nil
        end
    end,

    update = function(self, dt)
        if self.mounted then
            self.mounted.update(dt)
        elseif self.current then
            self.current.update(dt)
        end
    end,

    draw = function(self)
        if self.mounted then
            self.mounted.draw()
        elseif self.current then
            self.current.draw()
        end
    end,
}

---@class Scene
---@field name string
---@field change function|nil
---@field load function|nil
---@field enter function|nil
---@field exit function|nil
---@field update function
---@field draw function

---@class SceneParam
---@field name string
---@field load function|nil
---@field change function|nil
---@field enter function|nil
---@field exit function|nil
---@field update function|nil
---@field draw function|nil


--- Creates a scene
---@param sceneInit SceneParam|nil
---@return Scene created_scene
function Scene.createScene(sceneInit)
    local paramScene = sceneInit or {}

    local function load() return end;
    local function enter() return end;
    local function exit() return end;
    --- The update fn
    ---@param dt integer the delta
    local function update(dt) return end;
    local function draw() return end;

    local scene = {
        name = paramScene.name,
        --- a fn to be called on love.load. You need to call this yourself.
        load = paramScene.load or load,
        --- The fn called when the scene is entered
        enter = paramScene.enter or enter,
        --- The fn called when the scene is exited
        exit = paramScene.exit or exit,
        update = paramScene.update or update,
        draw = paramScene.draw or draw,
    }

    return scene
end

return Scene
