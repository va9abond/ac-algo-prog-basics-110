using HorizonSideRobots
include("GeneralRobot.jl")
include("../roblib.jl")



mutable struct BagRobot{robot_type, value_type} <: AbstractRobot
    _robot::robot_type
    _bag::value_type
end


getbaserobot(robot::BagRobot) = getbaserobot(robot._robot)
getbag(robot::BagRobot) = robot._bag


function HorizonSideRobots.move!(robot::BagRobot, side::HorizonSide)::Bool
    success = move!(robot._robot, side)
    return success
end
