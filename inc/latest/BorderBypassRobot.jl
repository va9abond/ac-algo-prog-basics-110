using HorizonSideRobots
include("AbstractRobot.jl")
include("../roblib.jl")



mutable struct BorderBypassRobot{robot_type} <: AbstractRobot
    _robot::robot_type
end

getbaserobot(robot::BorderBypassRobot) = getbaserobot(robot._robot)

function HorizonSideRobots.move!(robot::BorderBypassRobot, side::HorizonSide)::Bool
    return move_bypass_plane!(robot._robot, side)
end
