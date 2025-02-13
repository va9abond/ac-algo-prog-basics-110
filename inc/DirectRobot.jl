using HorizonSideRobots
include("AbstractDirectRobot.jl")

struct DirectRobot{robot_type} <: AbstractDirectRobot
    _robot::robot_type
    _direction::HorionSide
end

getbaserobot(robot::DirectRobot) = getbaserobot(robot._robot)
getdirection(robot::DirectRobot) = robot._direction
