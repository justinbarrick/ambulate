local robot = require("robot")

local function left()
    print("Turn left.")
    robot.turnLeft()
    local success = robot.forward()
    robot.turnRight()
    return success
end

local function right()
    print("Turn right.")
    robot.turnRight()
    local success = robot.forward()
    robot.turnLeft()
    return success
end

local function forward()
    print("Forward")
    return robot.forward()
end

local function try_finding_forward(direction, backtrack)
    local steps = 0

    while true do
        local success = direction()
        if not success then
            for i=1,steps do
                backtrack()
            end

            return false
        else
            steps = steps + 1
            
            success = forward()
            if success then
                return steps
            end
        end
    end
end

local function go_forward()
    local successful = forward()

    if successful then
        return true, 0
    end

    local steps = try_finding_forward(left, right)
    if steps then
        return true, steps * -1
    else
        steps = try_finding_forward(right, left)
        if steps then
            return true, steps
        end
    end

    return false
end

local function try(direction, steps)
    for  step=1,steps do
        if not direction() then
            return step - 1
        end
    end

    return steps
end

local function move(x, y)
    local current_x = 0
    local current_y = 0

    while current_x ~= x or current_y ~= y do
        if current_y > y then
            robot.turnAround()
        end

        local success, x_steps = go_forward()
        if not success then
            y_steps = 0
        elseif current_y > y then
            robot.turnAround()
            y_steps = -1
        else
            y_steps = 1
        end

        x_steps = x_steps or 0
        current_y = current_y + y_steps
        current_x = current_x + x_steps

        local x_steps = nil
        if current_x > x then
            x_steps = try(left, current_x - x)
            if x_steps then
                x_steps = x_steps * -1
            end
        elseif current_x < x then
            x_steps = try(right, x - current_x)
        end

        x_steps = x_steps or 0
        current_x = current_x + x_steps

        print("current: (" .. current_x .. "," .. current_y .. "), target: (" .. x .. "," .. y .. "), moved: (" .. x_steps .. "," .. y_steps .. ")")
    end
end

local args = {...}
local x = tonumber(args[1]) or 0
local y = tonumber(args[2]) or 0

print("moving to (" .. x .. "," .. y .. ")")
move(x, y)
