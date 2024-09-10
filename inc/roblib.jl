# TODO import HorizonSideRobots as HSR
# TODO unify move[_...]! function interface (return path)
# TODO move with predicate

# XXX putmarker! after or before move?

using HorizonSideRobots


function inverse_side(side::HorizonSide)
    return HorizonSide((Int(side)+2)%4)
end


function move_till_border!(robot::Robot, side::HorizonSide)::Integer
    steps_till_border::Integer = 0

    while (!isborder(robot, side))
        HorizonSideRobots.move!(robot, side)
        steps_till_border += 1
    end

    return steps_till_border
end


function HorizonSideRobots.move!(robot::Robot, side::HorizonSide, steps::Integer)::Bool
    while (steps > 0)
        if (!isborder(robot, side))
            HorizonSideRobots.move!(robot, side)
            steps -= 1
        else
            return false
        end
    end

    return true
end


function mark_direction!(robot::Robot, side::HorizonSide)::Integer
    steps_in_direction::Integer = 0

    putmarker!(robot)
    while (!isborder(robot, side))
        move!(robot, side)
        steps_in_direction += 1
        putmarker!(robot)
    end

    return steps_in_direction
end
