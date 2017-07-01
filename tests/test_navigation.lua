luaunit = require("luaunit")
ambulator = require("ambulator")
robot = require("robot")
sides = require("sides")
component = require("component")
navigation = component.navigation

function testfindWaypoints()
    robot.reset()

    robot.board = {
        {0,0,0,0,0},
        {0,"waypoint1",0,0,0},
        {0,0,0,0,0},
        {0,0,0,"waypoint2",0},
        {0,0,0,0,0},
    }

    robot.current_position = {0,0}

    for direction=1,4 do
        local waypoints = navigation.findWaypoints(10)
        luaunit.assertEquals(#waypoints, 2)
        luaunit.assertEquals(waypoints[1].label, "waypoint1")
        luaunit.assertEquals(waypoints[1].redstone, 0)
        luaunit.assertEquals(waypoints[1].position, {-1,0,-1})

        luaunit.assertEquals(waypoints[2].label, "waypoint2")
        luaunit.assertEquals(waypoints[2].redstone, 0)
        luaunit.assertEquals(waypoints[2].position, {1,0,1})

        robot.turnRight()
    end
end

function testfindWaypointsOffCenter()
    robot.reset()

    robot.board = {
        {0,0,0,0,0},
        {0,"waypoint1",0,0,0},
        {0,0,0,0,0},
        {0,0,0,"waypoint2",0},
        {0,0,0,0,0},
    }

    robot.current_position = {-1,-1}

    for direction=1,4 do
        local waypoints = navigation.findWaypoints(10)
        luaunit.assertEquals(#waypoints, 2)
        luaunit.assertEquals(waypoints[1].label, "waypoint1")
        luaunit.assertEquals(waypoints[1].redstone, 0)
        luaunit.assertEquals(waypoints[1].position, {0,0,-2})

        luaunit.assertEquals(waypoints[2].label, "waypoint2")
        luaunit.assertEquals(waypoints[2].redstone, 0)
        luaunit.assertEquals(waypoints[2].position, {2,0,0})

        robot.turnRight()
    end
end

function testfindWaypointsConversion()
    robot.reset()

    robot.board = {
        {0,0,0,0,0},
        {0,"waypoint1",0,0,0},
        {0,0,"x",0,0},
        {0,0,0,"waypoint2",0},
        {0,0,0,0,0},
    }

    robot.current_position = {0,0}

    local coords = {
        [sides.north] = { {-1,1}, {1,-1} },
        [sides.south] = { {1,-1}, {-1,1} },
        [sides.east] = { {-1,-1}, {1,1} },
        [sides.west] = { {1,1}, {-1,-1} },
    }

    for direction=1,4 do
        local orientation = navigation.getFacing()
        local current = coords[orientation]

        local waypoints = ambulator.find_waypoints()
        luaunit.assertEquals(#waypoints, 2)
        luaunit.assertEquals(waypoints[1].label, "waypoint1")
        luaunit.assertEquals(waypoints[1].redstone, 0)
        luaunit.assertEquals(waypoints[1].position, current[1])

        luaunit.assertEquals(waypoints[2].label, "waypoint2")
        luaunit.assertEquals(waypoints[2].redstone, 0)
        luaunit.assertEquals(waypoints[2].position, current[2])

        robot.turnRight()
    end
end

function testfindWaypointsConversionOffCenter()
    robot.reset()

    robot.board = {
        {0,0,0,0,0},
        {0,"waypoint1",0,0,0},
        {0,0,0,0,0},
        {"x",0,0,"waypoint2",0},
        {0,0,0,0,0},
    }

    robot.current_position = {-2,-1}

    local coords = {
        [sides.north] = { {1,2}, {3,0} },
        [sides.south] = { {-1,-2}, {-3,0} },
        [sides.east] = { {-2,1}, {0,3} },
        [sides.west] = { {2,-1}, {0,-3} },
    }

    for direction=1,4 do
        local orientation = navigation.getFacing()
        local current = coords[orientation]

        local waypoints = ambulator.find_waypoints()
        luaunit.assertEquals(#waypoints, 2)
        luaunit.assertEquals(waypoints[1].label, "waypoint1")
        luaunit.assertEquals(waypoints[1].redstone, 0)
        luaunit.assertEquals(waypoints[1].position, current[1])

        luaunit.assertEquals(waypoints[2].label, "waypoint2")
        luaunit.assertEquals(waypoints[2].redstone, 0)
        luaunit.assertEquals(waypoints[2].position, current[2])

        robot.turnRight()
    end
end

function testGetWaypoint()
    robot.reset()

    robot.board = {
        {0,0,0,0,0},
        {0,"waypoint1",0,0,0},
        {0,0,0,0,0},
        {"x",0,0,"waypoint2",0},
        {0,0,0,0,0},
    }

    robot.current_position = {-2,-1}

    local coords = {
        [sides.north] = {3,0},
        [sides.south] = {-3,0},
        [sides.east] = {0,3},
        [sides.west] = {0,-3},
    }

    for direction=1,4 do
        local orientation = navigation.getFacing()
        local current = coords[orientation]

        local waypoint = ambulator.get_waypoint("waypoint2")
        luaunit.assertEquals(waypoint.position, current)

        robot.turnRight()
    end
end

function testMoveToWaypoint()
    robot.reset()

    robot.board = {
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
        {0,0,0,0,0,1,1,1,1,0,0,0,0,0,0},
        {0,0,"waypoint1",0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,1,1,1,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,1,1,1,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,1,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,1,1,1,1,1,1,1,1,1,1,1,0,0,1},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    }


    robot.current_position = {-5,-7}
    robot.turnAround()

    ambulator.move_to_waypoint("waypoint1")

    luaunit.assertEquals(robot.current_position, {-5,4})
end

function testGetFacingNorth()
    robot.reset()
    luaunit.assertEquals(navigation.getFacing(), sides.north)
end

function testGetFacingSouth()
    robot.reset()
    robot.turnAround()
    luaunit.assertEquals(navigation.getFacing(), sides.south)
end

function testGetFacingWest()
    robot.reset()
    robot.turnLeft()
    luaunit.assertEquals(navigation.getFacing(), sides.west)
end

function testGetFacingEast()
    robot.reset()
    robot.turnRight()
    luaunit.assertEquals(navigation.getFacing(), sides.east)
end

os.exit(luaunit.LuaUnit.run())
