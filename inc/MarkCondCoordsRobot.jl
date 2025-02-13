using HorizonSideRobots
include("CoordsRobot.jl")


mutable struct MarkCondCoordsRobot
    _robot::CoordsRobot
    _cond::Function

    function MarkCondCoordsRobot(robot::CoordsRobot, cond::Function)
        return new(CoordsRobot(robot), cond)
    end
end

getbaserobot(robot::Robot) = robot
getbaserobot(robot::MarkCondCoordsRobot) = getbaserobot(robot._robot)

function HorizonSideRobots.move!(robot::MarkCondCoordsRobot, side::HorizonSide)
    robot._cond(getcoords_unpacked(robot._robot)) && putmarker!(robot._robot)
    return move!(robot._robot, side)
end


function HorizonSideRobots.putmarker!(robot::MarkCondCoordsRobot)
    error("MarkCondCoordsRobot: to put marker use putmarker_force!")
end

function putmarker_force!(robot::MarkCondCoordsRobot)
    return putmarker!(robot._robot)
end

HorizonSideRobots.isborder(robot::MarkCondCoordsRobot, side::HorizonSide) = isborder(robot._robot, side)
HorizonSideRobots.ismarker(robot::MarkCondCoordsRobot) = ismarker(robot._robot)
getcoords(robot::MarkCondCoordsRobot)::Coords{Int} = getcoords(robot._robot)
getcoords_unpacked(robot::MarkCondCoordsRobot)::Coords{Int} = getcoords_unpacked(robot._robot)
