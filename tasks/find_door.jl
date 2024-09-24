include("../inc/roblib.jl")


function main()
    robot::Robot = Robot("find_door.sit", animate=true)
    putmarker!(robot)

    flag_door::Bool = false
    (!isborder(robot, Nord)) && (flag_door = true)

    steps_in_direction::Int = 1
    while (!flag_door)
        for side_h in [Ost, West]
            move!(robot, side_h, steps_in_direction)
            (!isborder(robot, Nord)) && (flag_door = true)
            steps_in_direction += 1
        end
    end

    move!(robot, Nord)
end

