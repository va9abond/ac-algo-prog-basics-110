import HorizonSideRobots as HSR
import HorizonSideRobots: move!, putmarker!, isborder, ismarker, temperature

abstract type AbstractRobot end

move!(robot::AbstractRobot, side::HSR.HorizonSide)     = HSR.move!(getbaserobot(robot), side)
putmarker!(robot::AbstractRobot)                       = HSR.putmarker!(getbaserobot(robot))
isborder(robot::AbstractRobot, side::HSR.HorizonSide)  = HSR.isborder(getbaserobot(robot), side)
ismarker(robot::AbstractRobot)                         = HSR.ismarker(getbaserobot(robot))
temperature(robot::AbstractRobot)                      = HSR.temperature(getbaserobot(robot))

getbaserobot(robot::HSR.Robot) = robot
