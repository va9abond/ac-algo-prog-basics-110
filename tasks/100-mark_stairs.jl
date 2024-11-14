include("../inc/roblib.jl")


function mark_stairs!(robot::Robot)
    corner = (Nord, Ost)
    path_into_corner = move_into_corner!(robot, corner)

    direction_border::HorizonSide = reverse_side(corner[1])
    direction_in_row::HorizonSide = reverse_side(corner[2])

    # TODO reduce robot moves (do not return robot at the line start)
    # mb stop_cond for while loop is move!(robot, direction_border) == false
    stair_width::Int = 1
    putmarker!(robot)
    while (!isborder(robot, direction_border))
        move!(robot, direction_border)

        stair_width = mark_direction!(robot, direction_in_row, stair_width)[2] + 1
        move!(robot, reverse_side(direction_in_row)) do
            isborder(robot, reverse_side(direction_in_row))
        end
    end

    move_into_corner!(robot, corner)
    move!(robot, reverse_path(path_into_corner))
end
