include("../inc/roblib.jl")


function mark_chess_perimeter!(robot::Robot)::Bool
    corner = (Nord, West)
    success, path_into_corner = move_into_corner!(robot, side_v=corner[1], side_h=corner[2])
    (!success) && (println("failed to reach the corner"), return false)

    corner_sum::Integer = (Int(corner[1]) + Int(corner[2])) % 4
    side_start::HorizonSide = Nord # TODO default invalid value
    if (corner_sum == 1)
        side_start = reverse_side(corner[1])
    else
        side_start = reverse_side(corner[2])
    end

    parity::Int8 = 0
    for i in 0:3
        side::HorizonSide = HorizonSide((Int(side_start)+i) % 4)
        parity = mark_chess_direction!(robot, side, parity) # mark from corner to corner
    end

    success = move!(robot, reverse_path(path_into_corner))[1]
    (!success) && (println("failed to return to the starting position"), return false)

    return true
end
