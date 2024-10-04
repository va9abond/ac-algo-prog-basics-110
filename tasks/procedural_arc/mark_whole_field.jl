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


function mark_whole_field!(robot::Robot)::Bool
    corner = @NamedTuple{side_v::HorizonSide, side_h::HorizonSide}((Nord, West))
    success, path_into_corner = move_into_corner!(robot, side_v=corner.side_v, side_h=corner.side_h)
    (!success) && (println("failed to reach the corner"), return false)

    direction_limit::HorizonSide = reverse_side(corner.side_v)
    direction::HorizonSide = reverse_side(corner.side_h)

    mark_direction!(robot, direction)
    while (!isborder(robot, direction_limit))
        move!(robot, direction_limit)

        direction = reverse_side(direction)
        mark_direction!(robot, direction)
    end

    success = move_into_corner!(robot, side_v=corner.side_v, side_h=corner.side_h)[1]
    (!success) && (println("failed to reach the corner"), return false)

    success = move!(robot, reverse_path(path_into_corner))[1]
    (!success) && (println("failed to return to the starting position"), return false)

    return true
end
