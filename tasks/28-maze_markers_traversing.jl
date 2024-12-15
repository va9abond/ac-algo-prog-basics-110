include("../inc/roblib.jl")

function maze_traversing!(robot)::Nothing
    ismarker(robot) && return nothing
    putmarker!(robot)

    for side in [Nord, West, Sud, Ost]
        move!(robot, side)

        maze_traversing!(robot)

        move!(robot, reverse_side(side))
    end

end


function main!()
    robot = Robot("maze_markers_no_escape.sit", animate=true)
    maze_traversing!(robot)
end
