include("../inc/roblib.jl")


function count_borders_in_line!(robot, side_move::HorizonSide, side_border::HorizonSide)::Int
    borders_cnt::Int = 0
    border_flag = false

    if (!border_flag & (border_flag = isborder(robot, side_border)))
        borders_cnt += 1
    end

    while (!isborder(robot, side_move))
        # find start of of the border
        if (!border_flag & (border_flag = isborder(robot, side_border)))
            borders_cnt += 1
        end

        move!(robot, side_move)
    end

    return borders_cnt
end


function count_plain_borders!(robot, corner::NTuple{2, HorizonSide})::Int
    direction_border::HorizonSide = reverse_side(corner[1])
    direction_in_row::HorizonSide = reverse_side(corner[2])

    borders_cnt::Int = 0
    while (!isborder(robot, direction_border))
        borders_cnt += count_borders_in_line!(robot, direction_in_row, direction_border)

        move!(robot, direction_border)
        direction_in_row = reverse_side(direction_in_row)
    end

    return borders_cnt
end


function main!()
    robot::Robot = Robot("plain_borders.sit", animate=true)
    corner = (Nord, Ost)

    path_into_corner = move_into_corner!(robot, corner)

    borders_cnt::Int = count_plain_borders!(robot, corner)

    move_into_corner!(robot, corner)
    move!(robot, reverse_path(path_into_corner))
end


function main!(robot)
    corner = (Nord, Ost)

    path_into_corner = move_into_corner!(robot, corner)

    borders_cnt::Int = count_plain_borders!(robot, corner)

    move_into_corner!(robot, corner)
    move!(robot, reverse_path(path_into_corner))
end
