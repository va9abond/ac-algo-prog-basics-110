include("../inc/roblib.jl")


function find_marker_borders!(robot::Robot)
    init_side::HorizonSide = Nord
    flag_marker::Bool = false

    (ismarker(robot)) && (flag_marker = true)
    putmarker!(robot)


    steps_in_direction::Int = 1
    side::HorizonSide = init_side
    while (!flag_marker)
        (side == reverse_side(init_side)) && (steps_in_direction += 1)

        for i in (1:steps_in_direction)
            move_through_borders!(robot, side)
            (ismarker(robot)) && (flag_marker = true) && (break)
        end

        side = next_side(side)
        (side == init_side) && (steps_in_direction += 1)
    end

end


function main()
    robot::Robot = Robot("find_marker_borders.sit", animate=true)
    find_marker_borders!(robot)
end
