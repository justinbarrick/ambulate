luaunit = require('luaunit')
robot = require("robot")
ambulator = require("ambulator")

function testAmbulator()
    ambulator.move(1, 1)
    luaunit.assertEquals(robot.current_position, {1,1})
end

os.exit(luaunit.LuaUnit.run())
