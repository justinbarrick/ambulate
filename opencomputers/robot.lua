local math = require("math")
local sides = require("sides")

local _M = {}

_M.sides = {
    NORTH = 0,
    EAST = 1,
    SOUTH = 2,
    WEST = 3,
}

_M.current_position = {0,0}
_M.orientation = _M.sides.NORTH

_M.board = {
    {"waypoint1",0,0,0,0},
    {0,0,1,0,0},
    {0,1,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
}

function _M.reset(x, y, orientation)
    robot.current_position = {x or 0, y or 0}
    robot.orientation = orientation or robot.sides.NORTH
end

function _M.coords_on_board(coordinates)
    local size = math.ceil(#_M.board / 2)
    return coordinates[1] + size, (coordinates[2] * -1) + size
end

function _M.print_board()
    local c_x, c_y = _M.coords_on_board(_M.current_position)

    print("Coordinates: (" .. _M.current_position[1] .. "," .. _M.current_position[2] .. ")", _M.orientation)

    for index1, y in pairs(_M.board) do
        local line = ""
        for index2, x in pairs(y) do
            if index1 == c_y and index2 == c_x then
                x = "x"
            end

            line = line .. " " .. x
        end
        print(line)
    end
end

function _M.is_valid_block(coordinates)
    local x, y = _M.coords_on_board(coordinates)

    if y < 0 or x < 0 then
        return false
    end

    if _M.board[y] == nil or _M.board[y][x] == nil then
        return false
    end

    if _M.board[y][x] == 1 then
        return false
    end

    return true
end

function _M.forward(mock, orientation)
    local new_coordinates = {_M.current_position[1], _M.current_position[2]}
    local orientation = orientation or _M.orientation

    if orientation == _M.sides.NORTH then
        new_coordinates[2] = new_coordinates[2] + 1
    elseif orientation == _M.sides.SOUTH then
        new_coordinates[2] = new_coordinates[2] - 1
    elseif orientation == _M.sides.WEST then
        new_coordinates[1] = new_coordinates[1] - 1
    else
        new_coordinates[1] = new_coordinates[1] + 1
    end

    if _M.is_valid_block(new_coordinates) then
        if not mock then
            _M.current_position = new_coordinates
        end
        return true
    else
        print("Invalid!")
        return false
    end
end

function _M.turnRight()
    _M.orientation = (_M.orientation + 1) % 4
end

function _M.turnLeft()
    _M.orientation = (_M.orientation - 1) % 4
end

function _M.turnAround()
    _M.turnRight()
    _M.turnRight()
end

function _M.detect(side)
    local new_orientation = _M.orientation

    if side == sides.left then
        new_orientation = (new_orientation - 1) % 4
    elseif side == sides.right then
        new_orientation = (new_orientation + 1) % 4
    elseif side == sides.back then
        new_orientation = (new_orientation + 1) % 4
        new_orientation = (new_orientation + 1) % 4
    elseif side == sides.up then
        return true
    elseif side == sides.down then
        return true
    end
        
    return not _M.forward(true, new_orientation)
end

return _M
