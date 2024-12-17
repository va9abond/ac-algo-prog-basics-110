using HorizonSideRobots


mutable struct Coords{value_type}
    x::value_type
    y::value_type
end

# -- tuple(::Tuple/::NTuple) and named-tuple(@NamedTuple) are alternatives
#    for structs (unmutable)
#    coords = (x = 0, y = 0)

# -- to use tuple as mutable struct it should contain references instead
#    objects themselves
#    coords = (x = Ref(0), y = Ref(0))  | typeof(Ref(0)) == Ref{Int}(0)
#    coords.x[] +=1 | x[] is dereferencing of reference x

# outer ctor
Coords() = Coords{Int}(0,0)
Coords(other_coords::NTuple{2, value_type}) where value_type = Coords{value_type}(other_coords[1], other_coords[2])



mutable struct CoordsRobot{robot_type} # <: AbstractRobot
    _robot::robot_type
    _coords::Coords{Int}
end


CoordsRobot(robot::robot_type) where robot_type = CoordsRobot{robot_type}(robot, Coords(0,0))

getbaserobot(robot::Robot) = robot
getbaserobot(robot::CoordsRobot) = getbaserobot(robot._robot)

function HorizonSideRobots.move!(robot::CoordsRobot, side::HorizonSide)
    (side == Nord) && (robot._coords.y += 1)
    (side == West) && (robot._coords.x -= 1)
    (side == Sud)  && (robot._coords.y -= 1)
    (side == Ost)  && (robot._coords.x += 1)

    return move!(robot._robot, side)
end

HorizonSideRobots.putmarker!(robot::CoordsRobot) = putmarker!(robot._robot)
HorizonSideRobots.isborder(robot::CoordsRobot, side::HorizonSide) = isborder(robot._robot, side)
HorizonSideRobots.ismarker(robot::CoordsRobot) = ismarker(robot._robot)
getcoords(robot::CoordsRobot)::Coords{Int} = robot._coords

import Base: convert
convert(::NTuple{2, value_type}, coords::Coords{value_type}) where value_type = (coords.x, coords.y)
