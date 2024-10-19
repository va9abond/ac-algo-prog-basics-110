include("../inc/roblib.jl")


function move_into_corner!(robot::Robot; side_v::HorizonSide=Nord, side_h::HorizonSide=West)::Tuple{Bool, Vector{Tuple{HorizonSide, Integer}}}
    path::Vector{Tuple{HorizonSide, Integer}} = []

    for side in [side_v, side_h]
        steps = move!(isborder, robot, side)
        push!(path, (side, steps))
    end

    (!isborder(robot,side_v) || !isborder(robot,side_h)) && (return (false, path))
    return (true, path)
end


function mark_perimeter!(robot::Robot)::Bool
    corner = @NamedTuple{side_v::HorizonSide, side_h::HorizonSide}((Nord, West))
    success, path_into_corner = move_into_corner!(robot, side_v=corner.side_v, side_h=corner.side_h)
    (!success) && (println("failed to reach the corner"), return false)

    # Int(side_v) + Int(side_h) == [1,3]
    # + ----------- +
    # |1           3|
    # |             |
    # |             |
    # |3           1|
    # + ----------- +
    corner_sum::Integer = (Int(corner.side_v) + Int(corner.side_h)) % 4
    side_start::HorizonSide = Nord # TODO default invalid value
    if (corner_sum == 1)
        side_start = reverse_side(corner.side_v)
    else
        side_start = reverse_side(corner.side_h)
    end

    for i in 0:3
        local side::HorizonSide = HorizonSide((Int(side_start)+i) % 4)
        mark_direction!(robot, side) # mark from corner to corner
    end

    success = move!(robot, reverse_path(path_into_corner))[1]
    (!success) && (println("failed to return to the starting position"), return false)

    return true
end




