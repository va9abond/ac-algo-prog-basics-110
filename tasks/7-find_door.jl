include("../inc/roblib.jl")


function main!()
    robot::Robot = Robot("7-find_door.sit", animate=true)
    putmarker!(robot)

    move_swing!(()->!isborder(robot, Nord), robot)
end


function main!(robot)
    putmarker!(robot)

    move_swing!(()->!isborder(robot, Nord), robot)
end

