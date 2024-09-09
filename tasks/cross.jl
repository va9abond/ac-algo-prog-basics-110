include("../inc/roblib.jl")


function cross!(robot::Robot)
    for side in [Nord,Ost,West,Sud]
        steps_in_side::Integer = mark_line!(robot, side)
        move_steps!(robot, inverse_side(side), steps_in_side)
    end
end
