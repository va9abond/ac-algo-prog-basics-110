using HorizonSideRobots
include("AbstractRobot.jl")


mutable struct StepsRobot{robot_type} <: AbstractRobot
    _robot::robot_type
    _steps::Int
end
getbaserobot(robot::StepsRobot) = getbaserobot(robot._robot)

StepsRobot(robot::robot_type) where robot_type = StepsRobot{robot_type}(robot, 0)

function HorizonSideRobots.move!(robot::StepsRobot, side)
    robot._steps += 1
    println(robot._steps)
    return move!(robot._robot, side)
end


# r = Robot(animate=true)
# str = StepsRobot(r)
# for i in 1:5
#     move!(str, Nord)
# end
