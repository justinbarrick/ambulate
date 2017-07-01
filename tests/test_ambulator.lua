luaunit = require('luaunit')
robot = require("robot")
ambulator = require("ambulator")
sides = require("sides")
reset = robot.reset

function testDetectNorthBlocked()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,1,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    luaunit.assertEquals(robot.detect(sides.forward), true)
    luaunit.assertEquals(robot.detect(sides.left), false)
    luaunit.assertEquals(robot.detect(sides.right), false)
    luaunit.assertEquals(robot.detect(sides.back), false)
end

function testDetectSouthBlocked()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
        {0,0,1,0,0},
        {0,0,0,0,0},
    }

    luaunit.assertEquals(robot.detect(sides.forward), false)
    luaunit.assertEquals(robot.detect(sides.left), false)
    luaunit.assertEquals(robot.detect(sides.right), false)
    luaunit.assertEquals(robot.detect(sides.back), true)
end

function testDetectWestBlocked()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {0,1,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    luaunit.assertEquals(robot.detect(sides.forward), false)
    luaunit.assertEquals(robot.detect(sides.left), true)
    luaunit.assertEquals(robot.detect(sides.right), false)
    luaunit.assertEquals(robot.detect(sides.back), false)
end

function testDetectEastBlocked()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {0,0,0,1,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    luaunit.assertEquals(robot.detect(sides.forward), false)
    luaunit.assertEquals(robot.detect(sides.left), false)
    luaunit.assertEquals(robot.detect(sides.right), true)
    luaunit.assertEquals(robot.detect(sides.back), false)
end


function testAmbulator()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,1,0,0},
        {0,1,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    ambulator.move(1, 1)
    luaunit.assertEquals(robot.current_position, {1,1})
end

function testTryForwardNorthBlockedLeftReturnsToStart()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,1,1,0,0},
        {1,0,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    local steps = ambulator.try_forward(ambulator.left, ambulator.right)
    luaunit.assertEquals(robot.current_position, {0,0})
    luaunit.assertEquals(robot.orientation, robot.sides.NORTH)
    luaunit.assertEquals(steps, false)
end

function testTryForwardNorthRightBlockedLeftGoesNorth()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,1,1,0,0},
        {1,0,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    local steps = ambulator.try_forward(ambulator.right, ambulator.left)
    luaunit.assertEquals(robot.current_position, {1,1})
    luaunit.assertEquals(robot.orientation, robot.sides.NORTH)
    luaunit.assertEquals(steps, 1)
end

function testTryForwardSouthBlockedRightReturnsToStart()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {1,0,0,0,0},
        {0,1,1,0,0},
        {0,0,0,0,0},
    }

    robot.turnAround()
    local steps = ambulator.try_forward(ambulator.right, ambulator.left)
    luaunit.assertEquals(robot.current_position, {0,0})
    luaunit.assertEquals(robot.orientation, robot.sides.SOUTH)
    luaunit.assertEquals(steps, false)
end

function testTryForwardSouthBlockedRightGoesSouth()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {1,0,0,0,0},
        {0,1,1,0,0},
        {0,0,0,0,0},
    }

    robot.turnAround()
    local steps = ambulator.try_forward(ambulator.left, ambulator.right)
    luaunit.assertEquals(robot.current_position, {1,-1})
    luaunit.assertEquals(robot.orientation, robot.sides.SOUTH)
    luaunit.assertEquals(steps, 1)
end

function testTryForwardWestBlockedSouthReturnsToStart()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {0,1,0,0,0},
        {0,1,0,0,0},
        {0,0,1,0,0},
    }

    robot.turnLeft()
    local steps = ambulator.try_forward(ambulator.left, ambulator.right)
    luaunit.assertEquals(robot.current_position, {0,0})
    luaunit.assertEquals(robot.orientation, robot.sides.WEST)
    luaunit.assertEquals(steps, false)
end

function testTryForwardWestBlockedSouthGoesNorth()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {0,1,0,0,0},
        {0,1,0,0,0},
        {0,0,1,0,0},
    }

    robot.turnLeft()
    local steps = ambulator.try_forward(ambulator.right, ambulator.left)
    luaunit.assertEquals(robot.current_position, {-1,1})
    luaunit.assertEquals(robot.orientation, robot.sides.WEST)
    luaunit.assertEquals(steps, 1)
end

function testTryForwardEastBlockedLeftReturnsToStart()
    reset()

    robot.board = {
        {0,0,1,0,0},
        {0,0,0,1,0},
        {0,0,0,1,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    robot.turnRight()
    local steps = ambulator.try_forward(ambulator.left, ambulator.right)
    luaunit.assertEquals(robot.current_position, {0,0})
    luaunit.assertEquals(robot.orientation, robot.sides.EAST)
    luaunit.assertEquals(steps, false)
end

function testTryForwardEastBlockedLeftGoesSouth()
    reset()

    robot.board = {
        {0,0,1,0,0},
        {0,0,0,1,0},
        {0,0,0,1,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    robot.turnRight()
    local steps = ambulator.try_forward(ambulator.right, ambulator.left)
    luaunit.assertEquals(robot.current_position, {1,-1})
    luaunit.assertEquals(robot.orientation, robot.sides.EAST)
    luaunit.assertEquals(steps, 1)
end

function testStuckForward()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,1,1,0,0},
        {1,0,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    local steps = ambulator.stuck()
    luaunit.assertEquals(robot.current_position, {1,1})
    luaunit.assertEquals(robot.orientation, robot.sides.NORTH)
    luaunit.assertEquals(steps, 1)
end

function testStuckForwardNegative()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,1,1,0},
        {0,0,0,0,1},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    local steps = ambulator.stuck()
    luaunit.assertEquals(robot.current_position, {-1,1})
    luaunit.assertEquals(robot.orientation, robot.sides.NORTH)
    luaunit.assertEquals(steps, -1)
end

function testStuckBackward()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {1,0,0,0,0},
        {0,1,1,0,0},
        {0,0,0,0,0},
    }

    robot.turnAround()
    local steps = ambulator.stuck(true)
    luaunit.assertEquals(robot.current_position, {1,-1})
    luaunit.assertEquals(robot.orientation, robot.sides.SOUTH)
    luaunit.assertEquals(steps, 1)
end

function testStuckBackwardNegative()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,1},
        {0,0,1,1,0},
        {0,0,0,0,0},
    }

    robot.turnAround()
    local steps = ambulator.stuck(true)
    luaunit.assertEquals(robot.current_position, {-1,-1})
    luaunit.assertEquals(robot.orientation, robot.sides.SOUTH)
    luaunit.assertEquals(steps, -1)
end

function testStuckLeft()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,1,0,0,0},
        {0,1,0,0,0},
        {0,1,0,0,0},
        {0,0,1,0,0},
    }

    robot.turnLeft()
    local steps = ambulator.stuck()
    luaunit.assertEquals(robot.current_position, {-1,2})
    luaunit.assertEquals(robot.orientation, robot.sides.WEST)
    luaunit.assertEquals(steps, 2)
end

function testStuckLeftNegative()
    reset()

    robot.board = {
        {0,0,1,0,0},
        {0,1,0,0,0},
        {0,1,0,0,0},
        {0,1,0,0,0},
        {0,0,0,0,0},
    }

    robot.turnLeft()
    local steps = ambulator.stuck()
    luaunit.assertEquals(robot.current_position, {-1,-2})
    luaunit.assertEquals(robot.orientation, robot.sides.WEST)
    luaunit.assertEquals(steps, -2)
end

function testStuckRight()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,1,0},
        {0,0,0,1,0},
        {0,0,0,1,0},
        {0,0,1,0,0},
    }

    robot.turnRight()
    local steps = ambulator.stuck(true)
    luaunit.assertEquals(robot.current_position, {1,2})
    luaunit.assertEquals(robot.orientation, robot.sides.EAST)
    luaunit.assertEquals(steps, 2)
end

function testStuckRightNegative()
    reset()

    robot.board = {
        {0,0,1,0,0},
        {0,0,0,1,0},
        {0,0,0,1,0},
        {0,0,0,1,0},
        {0,0,0,0,0},
    }

    robot.turnRight()
    local steps = ambulator.stuck(true)
    luaunit.assertEquals(robot.current_position, {1,-2})
    luaunit.assertEquals(robot.orientation, robot.sides.EAST)
    luaunit.assertEquals(steps, -2)
end


function testGoForwardBlockedRight()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,1,1,0},
        {0,0,0,0,1},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    local y_steps, x_steps = ambulator.go(1)
    luaunit.assertEquals(robot.current_position, {-1,1})
    luaunit.assertEquals(x_steps, -1)
    luaunit.assertEquals(y_steps, 1)
end

function testGoForwardBlockedLeft()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,1,1,1,0},
        {1,0,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    local y_steps, x_steps = ambulator.go(1)
    luaunit.assertEquals(robot.current_position, {2,1})
    luaunit.assertEquals(x_steps, 2)
    luaunit.assertEquals(y_steps, 1)
end

function testGoBackwardBlockedRight()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,1},
        {0,0,1,1,0},
        {0,0,0,0,0},
    }

    local y_steps, x_steps = ambulator.go_back(1)
    luaunit.assertEquals(robot.current_position, {-1,-1})
    luaunit.assertEquals(x_steps, -1)
    luaunit.assertEquals(y_steps, -1)
end

function testGoBackwardBlockedLeft()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {1,0,0,0,0},
        {0,1,1,1,0},
        {0,0,0,0,0},
    }

    local y_steps, x_steps = ambulator.go_back(1)
    luaunit.assertEquals(robot.current_position, {2,-1})
    luaunit.assertEquals(x_steps, 2)
    luaunit.assertEquals(y_steps, -1)
end

function testGoLeftBlockedForward()
    reset()

    robot.board = {
        {0,0,1,0,0},
        {0,1,0,0,0},
        {0,1,0,0,0},
        {0,1,0,0,0},
        {0,0,0,0,0},
    }

    local y_steps, x_steps = ambulator.go_left(1)
    luaunit.assertEquals(robot.current_position, {-1,-2})
    luaunit.assertEquals(x_steps, -1)
    luaunit.assertEquals(y_steps, -2)
end

function testGoLeftBlockedBackward()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,1,0,0,0},
        {0,1,0,0,0},
        {0,1,0,0,0},
        {0,0,1,0,0},
    }

    local y_steps, x_steps = ambulator.go_left(1)
    luaunit.assertEquals(robot.current_position, {-1,2})
    luaunit.assertEquals(x_steps, -1)
    luaunit.assertEquals(y_steps, 2)
end

function testGoRightBlockedForward()
    reset()

    robot.board = {
        {0,0,1,0,0},
        {0,0,0,1,0},
        {0,0,0,1,0},
        {0,0,0,1,0},
        {0,0,0,0,0},
    }

    local y_steps, x_steps = ambulator.go_right(1)
    luaunit.assertEquals(robot.current_position, {1,-2})
    luaunit.assertEquals(x_steps, 1)
    luaunit.assertEquals(y_steps, -2)
end

function testGoRightBlockedBackward()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,0,1,0},
        {0,0,0,1,0},
        {0,0,0,1,0},
        {0,0,1,0,0},
    }

    local y_steps, x_steps = ambulator.go_right(1)
    luaunit.assertEquals(robot.current_position, {1,2})
    luaunit.assertEquals(x_steps, 1)
    luaunit.assertEquals(y_steps, 2)
end

function testMoveTop()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,1,0,0},
        {0,1,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    ambulator.move(0, 2)
    luaunit.assertEquals(robot.current_position, {0,2})
end

function testMoveAround()
    reset()

    robot.board = {
        {0,0,0,0,0},
        {0,0,1,0,0},
        {0,1,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
    }

    ambulator.move(-1, 1)
    luaunit.assertEquals(robot.current_position, {-1,1})
end

function testMoveForward()
    reset()

    robot.board = {
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
        {0,0,0,0,0,1,1,1,1,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,1,1,1,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    }

    ambulator.move(0, 7)
    luaunit.assertEquals(robot.current_position, {0,7})
end

function testMoveBehind()
    reset()

    robot.board = {
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
        {0,0,0,0,0,1,1,1,1,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,1,1,1,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,1,1,1,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,1,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,0,1},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    }

    ambulator.move(-7, -7)
    luaunit.assertEquals(robot.current_position, {-7,-7})
end

os.exit(luaunit.LuaUnit.run())
