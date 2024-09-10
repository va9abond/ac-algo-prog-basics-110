include("../inc/roblib.jl")


function cross!(robot::Robot)
    for side in [Nord,Ost,West,Sud]
        steps_in_direct::Integer = mark_direct!(robot, side)
        move!(robot, inverse_side(side), steps_in_direct)
    end
end
