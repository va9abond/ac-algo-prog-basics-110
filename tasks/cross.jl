include("../inc/roblib.jl")


function cross!(robot::Robot)
    for side in [Nord,Ost,West,Sud]
        steps_in_direction::Integer = mark_direction!(robot, side)
        move!(robot, inverse_side(side), steps_in_direction)
    end
end
