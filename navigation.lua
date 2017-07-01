local _M = {}

local robot = require("robot")
local sides = require("sides")

function _M.findWaypoints(range)
    -- returns a list:
    -- { label = "string", redstone = integer, position = { x, y, z } }

    local waypoints = {}

    for y, row in ipairs(robot.board) do
        for x, cell in ipairs(row) do
            if type(cell) == "string"  and cell ~= "x" then
                table.insert(waypoints, {
                    label=cell, redstone=0, position={x,y}
                })
            end
        end
    end

    local current_x, current_y = robot.coords_on_board(robot.current_position)

    for index, waypoint in ipairs(waypoints) do
        local x = waypoint.position[1] - current_x
        local y = 0
        local z = waypoint.position[2] - current_y
        waypoint.position = {x,y,z}
    end

    return waypoints
end

function _M.getFacing()
    if robot.orientation == robot.sides.NORTH then
        return sides.north
    elseif robot.orientation == robot.sides.SOUTH then
        return sides.south
    elseif robot.orientation == robot.sides.EAST then
        return sides.east
    else
        return sides.west
    end
end

return _M
