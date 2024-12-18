using HorizonSideRobots
include("AbstractRobot.jl")
include("GeneralRobot.jl")
include("../roblib.jl")



mutable struct MarkCondRobot{robot_type} <: AbstractRobot
    _cond::Function
    _robot::robot_type
end

getbaserobot(robot::MarkCondRobot) = getbaserobot(robot._robot)


MarkCondRobot(cond::Bool=true) = MarkCondRobot{GRobot}(()->cond, GRobot())
MarkCondRobot(cond::Function) = MarkCondRobot{GRobot}(cond, GRobot())
MarkCondRobot(cond::Bool, robot::robot_type) where robot_type = MarkCondRobot{robot_type}(()->cond, robot)


function HorizonSideRobots.move!(robot::MarkCondRobot, side::HorizonSide)::Bool
    if ( (success = move!(robot._robot, side)) )
        robot._cond() && putmarker!(robot)
    end

    return success
end
