local b = {}

--- Get the x boundaries of the box
---@param box Box
function b.x_bounds(box)
    return box.x, box.x + box.w
end

--- Get the y boundaries of the box
---@param box Box
function b.y_bounds(box)
    return box.y, box.y + box.h
end

---@class Box
---@field x number
---@field y number
---@field h number
---@field w number

--- Check whether a point is within a box
---@param x number
---@param y number
---@param box Box
function b.point_intersection(x, y, box)
    local left, right = b.x_bounds(box)

    local x_outside = x < left or x > right

    local top, bottom = b.y_bounds(box)
    local y_outside = y < top or y > bottom

    return not x_outside and not y_outside
end

--- Check whether a point is outside a box
---@param x number
---@param y number
---@param box Box
function b.point_outersection(x, y, box)
    return not b.point_intersection(x, y, box)
end

--- Check whether a box is within another box
---@param box1 Box
---@param box2 Box
function b.box_intersection(box1, box2)
    local b1_left, b1_right = b.x_bounds(box1)
    local b2_left, b2_right = b.x_bounds(box2)

    local x_inside = b1_left <= b2_left and b1_right <= b2_right

    -- short circuit
    if not x_inside then
        return false
    end

    local b1_top, b1_bottom = b.x_bounds(box1)
    local b2_top, b2_bottom = b.x_bounds(box2)

    local y_inside = b1_top <= b2_top and b1_bottom <= b2_bottom

    return y_inside
end

--- Check whether a box is outside another box
---@param box1 Box
---@param box2 Box
function b.box_outersection(box1, box2)
    return not b.box_intersection(box1, box2)
end

return b
