include("roblib.jl")


mutable struct BorderBypassRobot
    _robot::Robot
end


function HorizonSideRobots.ismarker(robot::BorderBypassRobot)
    return ismarker(robot._robot)
end

function HorizonSideRobots.isborder(robot::BorderBypassRobot, side::HorizonSide)
    return isborder(robot._robot, side)
end

function HorizonSideRobots.putmarker!(robot::BorderBypassRobot)
    return putmarker!(robot._robot)
end


function HorizonSideRobots.move!(robot::BorderBypassRobot, side::HorizonSide)::Bool
    return move_bypass_plane!(robot._robot, side)
end


function HorizonSideRobots.move!(robot::BorderBypassRobot, side::HorizonSide, steps::Int)::Tuple{Bool, Int}
    return move_bypass_plane!(robot._robot, side, steps)
end


# r - start robot position
# R - finish robot position

#          R
#      ----------------
#        | r

#          r
#      ----------------
#       R|
function HorizonSideRobots.move!(robot::BorderBypassRobot, path::Vector{Tuple{HorizonSide, T}})::Tuple{Bool, Vector{Tuple{HorizonSide, T}}} where T <: Integer
    traversed_path::Vector{Tuple{HorizonSide, T}} = []

    for (side, steps) in path
        success, traversed_steps = move!(robot, side, steps)
        push!(traversed_path, (side, traversed_steps))

        (!success) && return (false, traversed_path)
    end

    return (true, path)
end
