luaunit = require('luaunit')
robot = require("robot")
ambulator = require("ambulator")

local function reset(x, y, orientation)
    robot.current_position = {x or 0, y or 0}
    robot.orientation = orientation or robot.sides.NORTH
end

function testAmbulator()
    reset()
    ambulator.move(1, 1)
    luaunit.assertEquals(robot.current_position, {1,1})
end

function testMoveAround()
    reset()
    ambulator.move(-1, 1)
    luaunit.assertEquals(robot.current_position, {-1,1})
end

os.exit(luaunit.LuaUnit.run())
