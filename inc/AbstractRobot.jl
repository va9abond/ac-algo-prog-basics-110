import HorizonSideRobots as hsr


abstract type AbstractRobot end

move!(robot::AbstractRobot, side::HorizonSide) = hsr.move!(getparent(robot), side)
isborder(robot::AbstractRobot, side::HorizonSide) = hsr.isborder(getparent(robot, side))
putmarker!(robot::AbstractRobot) = hsr.putmarker!(getparent(robot, side))
ismarker(robot::AbstractRobot) = hsr.ismarker(getparent(robot))
temperature(robot::AbstractRobot) = hsr.temperature(getparent(robot))
