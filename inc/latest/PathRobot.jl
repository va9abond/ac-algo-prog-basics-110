using HorizonSideRobots
include("GeneralRobot.jl")
include("../roblib.jl")



mutable struct PathRobot{robot_type} <: AbstractRobot
    _robot::robot_type
    _path::Vector{Tuple{HorizonSide, Int}}
end


getbaserobot(robot::PathRobot) = getbaserobot(robot._robot)
getpath(robot::PathRobot) = robot._path


PathRobot() = PathRobot{GRobot}(GRobot(), [])
PathRobot(robot::robot_type) where robot_type = PathRobot{robot_type}(robot, [])
PathRobot(path::Vector{Tuple{HorizonSide, Int}}) = PathRobot{GRobot}(GRobot(), path)


function HorizonSideRobots.move!(robot::PathRobot, side::HorizonSide)::Bool
    if ( (success = move!(robot._robot, side)) )
        push!(robot._path, (side, 1))
    end

    return success
end


function HorizonSideRobots.move!(robot::PathRobot, side::HorizonSide, steps::Int)::Tuple{Bool, Int}
    traversed_steps::Int = 0
    success::Bool = false

    while (traversed_steps < steps)
        if ( (success = move!(robot._robot, side)) )
            traversed_steps += 1
        else
            break
        end
    end

    push!(robot._path, (side, traversed_steps))

    return (success, traversed_steps)
end
