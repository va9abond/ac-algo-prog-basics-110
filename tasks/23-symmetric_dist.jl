include("../inc/roblib.jl")


function symmetric_dist!(robot, side::HorizonSide)
    # recursion's stop condition
    if (!trymove!(robot, side))
        move_bypass_plane!(robot, side)
        return (0,0)
    end

    # recursive descent
    (steps_before, steps_after) = symmetric_dist!(robot, side)

    # deferred actions
    if (trymove!(robot, side))
        return (steps_before+1, steps_after+1)
    else
        return (steps_before+1, steps_after)
    end
end
