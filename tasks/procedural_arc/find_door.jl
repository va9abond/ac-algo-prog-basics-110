include("../inc/roblib.jl")


function main()
    robot::Robot = Robot("find_door.sit", animate=true)
    putmarker!(robot)

    flag_door::Bool = false
    (!isborder(robot, Nord)) && (flag_door = true)

    steps_in_direction::Int = 1
    side::HorizonSide = next_side(Nord)
    while (!flag_door)
        move!(robot, side, steps_in_direction)
        (!isborder(robot, Nord)) && (flag_door = true)
        steps_in_direction += 1
        side = reverse_side(side)
    end

    move!(robot, Nord)
end

