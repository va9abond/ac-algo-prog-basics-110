using HorizonSideRobots
include("AbstractRobot.jl")
include("roblib.jl")


abstract type AbstractDirectRobot <: AbstractRobot end

move!(robot::AbstractDirectRobot) = HorizonSideRobots.move!(getbaserobot(robot), getdirection(robot))
isborder(robot::AbstractDirectRobot) = HorizonSideRobots.isborder(getbaserobot(robot), getdirection(robot))

function turn_left(robot::robot_type)::robot_type where robot_type <: AbstractDirectRobot
    return robot_type(getbaserobot(robot), next_side(getdirection(robot)))
end

function turn_right(robot::robot_type)::robot_type where robot_type <: AbstractDirectRobot
    return robot_type(getbaserobot(robot), prev_side(getdirection(robot)))
end

function reverse(robot::robot_type)::robot_type where robot_type <: AbstractDirectRobot
    return robot_type(getbaserobot(robot), reverse_side(getdirection(robot)))
end
