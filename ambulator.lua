local robot = require("robot")

local ambulator = {}

function ambulator.left()
    print("Turn left.")
    robot.turnLeft()
    local success = robot.forward()
    robot.turnRight()
    return success
end

function ambulator.right()
    print("Turn right.")
    robot.turnRight()
    local success = robot.forward()
    robot.turnLeft()
    return success
end

function ambulator.forward()
    print("Forward")
    return robot.forward()
end

function ambulator.try_finding_forward(direction, backtrack)
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
            
            success = ambulator.forward()
            if success then
                return steps
            end
        end
    end
end

function ambulator.go_forward()
    local successful = ambulator.forward()

    if successful then
        return true, 0
    end

    local steps = ambulator.try_finding_forward(ambulator.left, ambulator.right)
    if steps then
        return true, steps * -1
    else
        steps = ambulator.try_finding_forward(ambulator.right, ambulator.left)
        if steps then
            return true, steps
        end
    end

    return false
end

function ambulator.try(direction, steps)
    for  step=1,steps do
        if not direction() then
            return step - 1
        end
    end

    return steps
end

function ambulator.move(x, y)
    local current_x = 0
    local current_y = 0

    while current_x ~= x or current_y ~= y do
        if current_y > y then
            robot.turnAround()
        end

        local success, x_steps = ambulator.go_forward()
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
            x_steps = ambulator.try(left, current_x - x)
            if x_steps then
                x_steps = x_steps * -1
            end
        elseif current_x < x then
            x_steps = ambulator.try(right, x - current_x)
        end

        x_steps = x_steps or 0
        current_x = current_x + x_steps

        print("current: (" .. current_x .. "," .. current_y .. "), target: (" .. x .. "," .. y .. "), moved: (" .. x_steps .. "," .. y_steps .. ")")
    end
end

local args = {...}
if args[1] ~= "ambulator" then
    local x = tonumber(args[1]) or 0
    local y = tonumber(args[2]) or 0

    print("moving to (" .. x .. "," .. y .. ")")
    ambulator.move(x, y)
end

return ambulator
