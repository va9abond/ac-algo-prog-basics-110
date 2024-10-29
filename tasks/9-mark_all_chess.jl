include("../inc/roblib.jl")


function mark_all_chess!(robot::Robot, corner::NTuple{2, HorizonSide}, init_parity::Int)::Nothing
    !iscorner(robot) && (WARN("robot is not in the corner"), return nothing)

    direction_border::HorizonSide = reverse_side(corner[1])
    direction_in_row::HorizonSide = reverse_side(corner[2])
    parity::Int = init_parity

    parity = mark_chess_direction!(robot, direction_in_row, parity)
    while (!isborder(robot, direction_border))
        move!(robot, direction_border)

        parity = (parity+1) % 2
        direction_in_row = reverse_side(direction_in_row)

        parity = mark_chess_direction!(robot, direction_in_row, parity)
    end

    return nothing
end


function main!()
    robot::Robot = Robot("random_pos_no_borders.sit", animate=true)
    corner = (Nord, Ost)

    path_into_corner = move_into_corner!(robot, corner)

    parity::Int = mod(sum((p) -> p[2], path_into_corner), 2)
    mark_all_chess!(robot, corner, 1-parity)

    move_into_corner!(robot, corner)
    move!(robot, reverse_path(path_into_corner))
end
