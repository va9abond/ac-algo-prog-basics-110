include("../inc/roblib.jl")


function cross!(robot::Robot)
    for side in [Nord,Ost,West,Sud]
        steps_till_border::Integer = move_till_border!(robot, side, putmarker=true)
        move_steps!(robot, inverse_side(side), steps_till_border, putmarker=false)
    end
end
