include("../inc/roblib.jl")


function mark_stairs!(robot::Robot)::Bool
    corner = (Nord, Ost)
    success, path_into_corner = move_into_corner!(robot, side_v=corner[1], side_h=corner[2])
    (!success) && (println("failed to reach the corner"), return false)

    direction_limit::HorizonSide = reverse_side(corner[1])
    direction::HorizonSide = reverse_side(corner[2])

    # TODO reduce robot moves (do not return robot at the line start)
    stair_width::Int = 1
    putmarker!(robot)
    while (!isborder(robot, direction_limit))
        move!(robot, direction_limit)

        stair_width = mark_direction!(robot, direction, stair_width)[2] + 1
        move!(isborder, robot, reverse_side(direction))
    end

    success = move_into_corner!(robot, side_v=corner[1], side_h=corner[2])[1]
    (!success) && (println("failed to reach the corner"), return false)

    success = move!(robot, reverse_path(path_into_corner))[1]
    (!success) && (println("failed to return to the starting position"), return false)

    return true
end
