using HorizonSideRobots
include("AbstractRobot.jl")
include("GeneralRobot.jl")
include("../roblib.jl")



mutable struct PrePostActRobot{robot_type} <: AbstractRobot
    _pre_act::Function,
    _post_act::Function,
    _robot::robot_type
end

getbaserobot(robot::PrePostActRobot) = getbaserobot(robot._robot)

function HorizonSideRobots.move!(robot::PrePostActRobot, side::HorizonSide)::Bool
    robot._pre_act()

    if ( (success = move!(robot._robot, side)) )
        robot._post_act()
    end

    return success
end
