include("../inc/roblib.jl")
include("../inc/ChessPainter.jl")

function maze_traversing!(robot)::Nothing
    ismarker(robot) && return nothing

    for side in [Nord, West, Sud, Ost]
        if (!isborder(robot, side))
            move!(robot, side)

            maze_traversing!(robot)

            move!(robot, reverse_side(side))
        end
    end

end


function main!()
    robot = Robot("maze_no_escape.sit", animate=true)
    rbt_chess_painter = ChessPainter(robot, 1)

    maze_traversing!(rbt_chess_painter)
end
