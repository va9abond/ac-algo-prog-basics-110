include("../inc/roblib.jl")


function HIDE_double_dist!(robot, side::HorizonSide)::Tuple{Int, Int}
    # recursion's stop condition
    !trymove!(robot, side) && return (0,0)

    # recursive descent
    (steps_side, steps_reverse_side) = HIDE_double_dist!(robot, side)

    # deferred actions
    rside = reverse_side(side)
    if (trymove!(robot, rside))
        if (trymove!(robot, rside))
            return (steps_side+1, steps_reverse_side+2)
        else
            return (steps_side+1, steps_reverse_side+1)
        end
    else
        return (steps_side+1, steps_reverse_side)
    end
end


function try_double_dist!(robot, side::HorizonSide)::Bool
    steps_side, steps_reverse_side = HIDE_double_dist!(robot, side)
    (steps_reverse_side - steps_side - steps_side == 0) && return true

    move!(robot, side, steps_reverse_side - steps_side) & return false
end


function main!()
    robot = Robot(animate=true)
    return robot
end

