include("../inc/roblib.jl")


function mark_all!(robot, corner::NTuple{2, HorizonSide})
    # TODO where this check should be? there or before function call
    !iscorner(robot) && (WARN("robot is not in the corner"), return nothing)

    direction_border::HorizonSide = reverse_side(corner[1])
    direction_in_row::HorizonSide = reverse_side(corner[2])

    # snake movement
    mark_direction!(robot, direction_in_row)
    while (!isborder(robot, direction_border))
        move!(robot, direction_border)

        direction_in_row = reverse_side(direction_in_row)
        mark_direction!(robot, direction_in_row)
    end

    return nothing
end


function main!()
    robot::Robot = Robot("random_pos_no_borders.sit", animate=true)

    corner = (Nord, Ost)
    path_into_corner = move_into_corner!(robot, corner)

    mark_all!(robot, corner)

    move_into_corner!(robot, corner)
    move!(robot, reverse_path(path_into_corner))
end
