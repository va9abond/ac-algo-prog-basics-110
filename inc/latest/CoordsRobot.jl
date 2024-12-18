using HorizonSideRobots
include("AbstractRobot.jl")
include("GeneralRobot.jl")
include("../roblib.jl")



mutable struct Coords{value_type}
    x::value_type
    y::value_type
end

Coords() = Coords(0,0)
Coords(c::NTuple{2, Int}) = Coords{Int}(c[1], c[2])


# ::Coords --> ::NTuple
function unpack(coords::Coords{value_type})::NTuple{2, value_type} where value_type
    return (coords.x, coords.y)
end



mutable struct CoordsRobot{robot_type} <: AbstractRobot
    _robot::robot_type
    _coords::Coords{Int}
end

getbaserobot(robot::CoordsRobot) = getbaserobot(robot._robot)
getcoords(robot::CoordsRobot) = robot._coords


CoordsRobot() = CoordsRobot{GRobot}(GRobot(), Coords())
CoordsRobot(robot::robot_type) where robot_type = CoordsRobot{robot_type}(robot, Coords())
CoordsRobot(x::Int, y::Int) = CoordsRobot{GRobot}(GRobot(), Coords(x,y))
CoordsRobot(robot, x, y) = CoordsRobot(robot, Coords(x,y))
CoordsRobot(robot, coords::NTuple{2, Int}) = CoordsRobot(robot, Coords(c))


function HorizonSideRobots.move!(robot::CoordsRobot, side::HorizonSide)
    if ( (success = move!(robot._robot, side)) )
        side == Nord && (robot._coords.y += 1)
        side == West && (robot._coords.x -= 1)
        side == Sud  && (robot._coords.y -= 1)
        side == Ost  && (robot._coords.x += 1)
    end

    return success
end
