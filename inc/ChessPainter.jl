include("roblib.jl")


mutable struct ChessPainter
    _robot::Robot
    _parity::Int8 # putmarker if (_parity == 1)
end


function HorizonSideRobots.ismarker(robot::ChessPainter)
    return ismarker(robot._robot)
end

function HorizonSideRobots.isborder(robot::ChessPainter, side::HorizonSide)
    return isborder(robot._robot, side)
end

function HorizonSideRobots.putmarker!(robot::ChessPainter)
    return putmarker!(robot._robot)
end


function reverse_parity(robot::ChessPainter)
    robot._parity = Int8(1) - robot._parity
end


function HorizonSideRobots.move!(robot::ChessPainter, side::HorizonSide)
    (robot._parity == 1) && (putmarker!(robot))
    move!(robot._robot, side)

    reverse_parity(robot)
end

function HorizonSideRobots.move!(stop_cond::Function, robot::ChessPainter, side::HorizonSide)::Int
    steps_untill_stop_cond::Int = 0

    while (!stop_cond())
        move!(robot, side)
        steps_untill_stop_cond += 1
    end

    return steps_untill_stop_cond
end


# function move_snake!(robot::ChessPainter, direction::HorizonSide)
#     side::HorizonSide = next_side(direction)
#
#     move!(()->isborder(robot, side), robot, side)
#     while (!isborder(robot, direction))
#         move!(robot, direction)
#
#         side = reverse_side(side)
#         move!(()->isborder(robot, side), robot, side)
#     end
#
# end
