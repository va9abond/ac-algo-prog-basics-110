include("../inc/roblib.jl")


function mark_perimeter!(robot)
    # determining which corner the robot is in
    corner = []
    for side in [Nord, Ost]
        border_side = isborder(robot, side) ? side : reverse_side(side)
        push!(corner, border_side)
    end

    # Int(corner[1]) + Int(corner[2]) == [1,3]
    # + ------ +
    # |1      3|
    # |        |
    # |3      1|
    # + ------ +
    corner_sum::Int = mod((Int(corner[1]) + Int(corner[2])), 4)
    move_side::HorizonSide = West
    if (corner_sum == 1)
        move_side = reverse_side(corner[1])
    else
        move_side = reverse_side(corner[2])
    end

    for _ in 0:3
        mark_direction!(robot, move_side)
        move_side = next_side(move_side)
    end

    return nothing
end


function main!()
    robot = Robot("random_pos_no_borders.sit", animate=true)

    path_into_corner = move_into_corner!(robot, (Nord, Ost))
    mark_perimeter!(robot)
    move!(robot, reverse_path(path_into_corner))
end
