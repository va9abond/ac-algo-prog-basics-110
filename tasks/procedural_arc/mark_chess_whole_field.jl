include("../inc/roblib.jl")


function mark_chess_whole_field!(robot::Robot)::Bool
    corner = (Nord, West)
    success, path_into_corner = move_into_corner!(robot, side_v=corner[1], side_h=corner[2])
    (!success) && (println("failed to reach the corner"), return false)

    direction_limit::HorizonSide = reverse_side(corner[1])
    direction::HorizonSide = reverse_side(corner[2])

    parity::Int8 = 0
    parity = mark_chess_direction!(robot, direction, parity)
    while (!isborder(robot, direction_limit))
        move!(robot, direction_limit)
        parity = (parity+1) % 2

        direction = reverse_side(direction)
        parity = mark_chess_direction!(robot, direction, parity)
    end

    success = move_into_corner!(robot, side_v=corner[1], side_h=corner[2])[1]
    (!success) && (println("failed to reach the corner"), return false)

    success = move!(robot, reverse_path(path_into_corner))[1]
    (!success) && (println("failed to return to the starting position"), return false)

    return true
end

