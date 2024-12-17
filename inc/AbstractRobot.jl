import HorizonSideRobots as HSR

abstract type AbstractRobot end

move!(robot::AbstractRobot, side)    = HSR.move!(getbaserobot(robot), side)
putmarker!(robot::AbstractRobot)     = HSR.putmarker!(getbaserobot(robot))
isborder(robot::AbstractRobot, side) = HSR.isborder(getbaserobot(robot), side)
ismarker(robot::AbstractRobot)       = HSR.ismarker(getbaserobot(robot))
temperature(robot::AbstractRobot)    = HSR.temperature(getbaserobot(robot))

getbaserobot(robot::HSR.Robot) = robot
