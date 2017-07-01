local robot = require("robot")
local sides = require("sides")
local math = require("math")
local navigation = require("component").navigation

local ambulator = {}

function ambulator.forward(steps)
    print("Forward")

    for step=1,steps do
        if not robot.forward() then
            return step - 1
        end
    end

    return steps
end

function ambulator.left(steps)
    print("Turn left.")
    robot.turnLeft()
    local steps = ambulator.forward(steps)
    robot.turnRight()
    return steps
end

function ambulator.right(steps)
    print("Turn right.")
    robot.turnRight()
    local steps = ambulator.forward(steps)
    robot.turnLeft()
    print(steps)
    return steps
end

function ambulator.backward(steps)
    print("Backward!")
    robot.turnAround()
    local steps = ambulator.forward(steps)
    robot.turnAround()
    return steps
end

function ambulator.try_forward(direction, backtrack)
    -- Search in one direction trying to find a place to go forward.
    -- If it gets blocked, it will go back to where it started with `backtrack`
    local steps = 0

    while true do
        if not robot.detect(sides.forward) and ambulator.forward(1) then
            return steps
        end

        local success = direction(1)
        if success == 0 then
            print("Backtrack!")
            backtrack(steps)
            return false
        else
            steps = steps + 1
        end
    end
end

function ambulator.stuck(invert)
    local cross_steps = ambulator.try_forward(ambulator.left, ambulator.right)
    if cross_steps then
        cross_steps = cross_steps * -1
    end

    if not cross_steps then
        cross_steps = ambulator.try_forward(ambulator.right, ambulator.left)
    end

    if invert then
        cross_steps = cross_steps * -1
    end

    return cross_steps
end

function ambulator.go(num_steps)
    -- Move in the correct direction as many steps as we can up to
    -- the target.
    local y_steps = ambulator.forward(num_steps)

    print(num_steps, y_steps)
    -- If we didn't move at all, try to unstuck ourselves.
    local x_steps = nil
    if num_steps and y_steps == 0 then
        x_steps = ambulator.stuck()
    end

    if x_steps then
        y_steps = y_steps + 1
    end

    return y_steps or 0, x_steps or 0
end

function ambulator.distance(current, target)
    if current > target then
        return current - target
    else
        return target - current
    end
end

function ambulator.go_back(y_distance)
    robot.turnAround()
    local y_steps, x_steps = ambulator.go(y_distance)
    robot.turnAround()

    if y_steps then
        y_steps = y_steps * -1
    end

    if x_steps then
        x_steps = x_steps * -1
    end

    return y_steps, x_steps
end

function ambulator.go_left(x_distance)
    robot.turnLeft()
    local x_steps, y_steps = ambulator.go(x_distance)
    robot.turnRight()

    if x_steps then
        x_steps = x_steps * -1
    end

    return y_steps, x_steps
end

function ambulator.go_right(x_distance)
    robot.turnRight()
    local x_steps, y_steps = ambulator.go(x_distance)
    robot.turnLeft()

    if y_steps then
        y_steps = y_steps * -1
    end

    return y_steps, x_steps
end

function go_y(y, current_y)
    local y_steps = nil
    local x_steps = nil

    local y_distance = ambulator.distance(current_y, y)

    if current_y > y then
        -- we are above target
        print("going back!")
        y_steps, x_steps = ambulator.go_back(y_distance)
    else
        -- we are below target
        print("going forward!")
        y_steps, x_steps = ambulator.go(y_distance)
    end

    return y_steps, x_steps
end

function go_x(x, current_x)
    local y_steps = nil
    local x_steps = nil

    local x_distance = ambulator.distance(current_x, x)

    if current_x > x then
        -- we are right of target
        print("going left!")
        y_steps, x_steps = ambulator.go_left(x_distance)
    else
        -- we are left of target
        print("going right!")
        y_steps, x_steps = ambulator.go_right(x_distance)
    end

    return y_steps, x_steps
end

function ambulator.is_close(current, dest)
    local x_distance = ambulator.distance(current[1], dest[1])
    local y_distance = ambulator.distance(current[2], dest[2])

    return (x_distance == 0 or y_distance == 0) and (x_distance == 1 or y_distance == 1)
end

function ambulator.use_x_or_y(current_x, current_y, x, y)
    -- Return true if the bot should use the Y axis.
    -- Return false if the bot should use the X axis.
    -- Return nil if the bot should do nothing.

    local x_distance = ambulator.distance(current_x, x)
    local y_distance = ambulator.distance(current_y, y)

    if y_distance and y_distance >= x_distance then
        if y_distance == x_distance then
            if true then
                return math.random(2) == 1
            end
        end

        return true
    elseif x_distance and x_distance >= y_distance then
        return false
    end

    return nil
end

function ambulator.move(x, y, close)
    local current_x = 0
    local current_y = 0

    while current_x ~= x or current_y ~= y do
        if close and ambulator.is_close({current_x, current_y}, {x, y}) then
            return
        end

        local x_steps = nil
        local y_steps = nil

        print("current: (" .. current_x .. "," .. current_y .. "), target: (" .. x .. "," .. y .. ")")

        local use = ambulator.use_x_or_y(current_x, current_y, x, y)
        print("use Y?", use)
        if use then
            y_steps, x_steps = go_y(y, current_y)
        elseif use == false then
            y_steps, x_steps = go_x(x, current_x)
        end

        current_x = current_x + (x_steps or 0)
        current_y = current_y + (y_steps or 0)

        if robot.print_board then
            robot.print_board()
        end
    end
end

function ambulator.find_waypoints()
    local waypoints = navigation.findWaypoints(1024)

    for index, waypoint in ipairs(waypoints) do
        local facing = navigation.getFacing()
        local x = waypoint.position[1]
        local y = waypoint.position[3] * -1

        if facing == sides.north then
            waypoint.position = {x,y}
        elseif facing == sides.south then
            waypoint.position = {x*-1,y*-1}
        elseif facing == sides.east then
            waypoint.position = {y*-1,x}
        else
            waypoint.position = {y,x*-1}
        end
    end

    return waypoints
end

function ambulator.get_waypoint(waypoint_name)
    for index, waypoint in ipairs(ambulator.find_waypoints()) do
        if waypoint.label == waypoint_name then
            return waypoint
        end
    end
end

function ambulator.move_to_waypoint(waypoint_name)
    local waypoint = ambulator.get_waypoint(waypoint_name)
    if waypoint then
        return ambulator.move(waypoint.position[1], waypoint.position[2], true)
    end
end

local args = {...}
if args[1] ~= "ambulator" then
    if args[1] == "help" then
        print("Usage: ambulator [args]")
        print("  ambulator list     -- list available waypoints")
        print("  ambulator waypoint -- move to waypoint")
        print("  ambulator x y      -- move to x and y coordinates")
        return 1
    elseif args[1] == "list" then
        for index, waypoint in ipairs(ambulator.find_waypoints()) do
            print(waypoint.label, waypoint.position[1], waypoint.position[2])
        end
        return
    elseif tonumber(args[1]) == nil then
        ambulator.move_to_waypoint(args[1])
    else
        local x = tonumber(args[1]) or 0
        local y = tonumber(args[2]) or 0

        print("moving to (" .. x .. "," .. y .. ")")
        ambulator.move(x, y)
    end
end

return ambulator
