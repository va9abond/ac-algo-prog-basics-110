include("../inc/MarkCondCoordsRobot.jl")
include("../inc/roblib.jl")


function is_in_square(N, coords::Coords{Int})::Bool
    x = mod(coords.x, 2*N)
    y = mod(coords.y, 2*N)

    return ( (x in 0:N-1) && (y in 0:N-1) ) ||
           ( (x in N:2*N-1) && (y in N:2*N-1) )
end

function main!(N::Int=3)
    robot::Robot = Robot("random_pos_no_borders.sit", animate=true)
    corner = (Sud, West)
    path_into_corner = move_into_corner!(robot, corner)

    # TODO how to make clousure for is_in_square
    cond = N->is_in_square()
    robot_main = MarkCondCoordsRobot(robot, cond)

    move_snake!(
        robot_main;
        side_move=reverse_side(corner[1]),
        side_in_row=reverse_side(corner[2])
    ) do
        false
     end

    move_into_corner!(robot, corner)
    move!(robot, reverse_path(path_into_corner))
end
