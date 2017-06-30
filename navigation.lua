local _M = {}

local robot = require("robot")

function _M.findWaypoints(range)
    -- returns a list:
    -- { label = "string", redstone = integer, position = { x, y, z } }

    local waypoints = {}

    for y, row in ipairs(robot.board) do
        for x, cell in ipairs(row) do
            if type(cell) == "string"  and cell ~= "x" then
                
            end
        end
    end
end

return _M
