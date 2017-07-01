luaunit = require("luaunit")
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
