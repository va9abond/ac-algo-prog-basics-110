using HorizonSideRobots
include("AbstractRobot.jl")
include("../roblib.jl")



mutable struct GRobot <: AbstractRobot
    _robot::Robot
end
getbaserobot(robot::GRobot) = robot._robot

GRobot(isanimated::Bool=true) = GRobot(Robot(animate=isanimated))
GRobot(sit::String, isanimated::Bool=true) = GRobot(Robot(sit, animate=isanimated))


function HorizonSideRobots.move!(robot::GRobot, side::HorizonSide)::Bool
    isborder(robot, side) && return false
    move!(getbaserobot(robot), side) & return true
end
