include("../inc/latest/GeneralRobot.jl")
include("../inc/latest/PathRobot.jl")
include("../inc/latest/BagRobot.jl")
include("../inc/roblib.jl")


# mutable struct MaxTempRobot{robot_type} = BagRobot{robot_type, Vector{Tuple{HorizonSide, Int}}}

function maze_traversing!(robot::BagRobot)::Nothing
    for side in [Nord, West, Sud, Ost]
        if (move!(robot, side))
            maze_traversing!(robot)
        end

        move!(robot, reverse_side(side))
    end
end


function start!()
    path_robot = PathRobot(GRobot("maze_no_escape.sit"))
    bag_robot = BagRobot(
              path_robot,
              (temperature(path_robot), Vector{Tuple{HorizonSide, Int}}[])
    )

    maze_traversing!(bag_robot)
    println(bag_robot._robot._path)
end

# path from start pos to pos with max temp
