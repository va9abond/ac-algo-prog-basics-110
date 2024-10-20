include("../inc/roblib.jl")


function cross!(robot)
    for side in [Nord, Ost, West, Sud]
        steps_in_direction::Int = mark_direction!(robot, side)
        move!(robot, reverse_side(side), steps_in_direction)
    end
end


function main!()
    robot::Robot = Robot("1-cross.sit", animate=true)
    cross!(robot)
end
