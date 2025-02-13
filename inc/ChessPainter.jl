include("roblib.jl")


mutable struct ChessPainter{robot_type}
    _robot::robot_type
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
    reverse_parity(robot)

    return move!(robot._robot, side)
end

# function HorizonSideRobots.move!(stop_cond::Function, robot::ChessPainter, side::HorizonSide)::Int
#     steps_untill_stop_cond::Int = 0
#
#     while (!stop_cond())
#         move!(robot, side)
#         steps_untill_stop_cond += 1
#     end
#
#     return steps_untill_stop_cond
# end

function move_snake_alt!(stop_cond::Function, robot;
        side_move::HorizonSide,
        side_in_row::HorizonSide=next_side(side_move))::Bool

    success::Bool = stop_cond()
    direction_in_row::HorizonSide = side_in_row

    move!(()->stop_cond(), robot, direction_in_row)

    while ( !(success = stop_cond()) && !isborder(robot, side_move) )
        move!(robot, side_move)

        direction_in_row = reverse_side(direction_in_row)

        move!(()->stop_cond(), robot, direction_in_row)
    end

    return success
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
