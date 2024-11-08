include("../inc/ChessPainter.jl")


function main!()
    robot::Robot = Robot("13-random_pos_no_borders.sit", animate=true)
    corner = (Sud, Ost)

    path_into_corner = move_into_corner!(robot, corner)

    init_parity::Int = mod(sum((p) -> p[2], path_into_corner), 2)
    rbt_chess_painter = ChessPainter(robot, 1-init_parity)

    # move_snake!(
    #     ()->iscorner(robot, reverse_corner(corner)),
    #     rbt_chess_painter;
    #     side_move=reverse_side(corner[1]),
    #     side_in_row=reverse_side(corner[2])
    # )

    move_snake!(
        rbt_chess_painter;
        side_move=reverse_side(corner[1]),
        side_in_row=reverse_side(corner[2])
    ) do
        iscorner(robot, reverse_corner(corner))
     end

    move_into_corner!(robot, corner)
    move!(robot, reverse_path(path_into_corner))
end


function main!(robot)
    corner = (Nord, Ost)

    path_into_corner = move_into_corner!(robot, corner)

    init_parity::Int = mod(sum((p) -> p[2], path_into_corner), 2)
    rbt_chess_painter = ChessPainter(robot, 1-init_parity)

    # move_snake!(
    #     ()->iscorner(robot, reverse_corner(corner)),
    #     rbt_chess_painter;
    #     side_move=reverse_side(corner[1]),
    #     side_in_row=reverse_side(corner[2])
    # )

    move_snake!(
        rbt_chess_painter;
        side_move=reverse_side(corner[1]),
        side_in_row=reverse_side(corner[2])
    ) do
        iscorner(robot, reverse_corner(corner))
     end

    move_into_corner!(robot, corner)
    move!(robot, reverse_path(path_into_corner))
end
