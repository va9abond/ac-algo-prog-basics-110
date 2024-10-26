include("../inc/roblib.jl")


function main!()
    robot::Robot = Robot("7-find_door.sit", animate=true)
    putmarker!(robot)

    swing!(()->!isborder(robot, Nord), robot)
end


function main!(robot)
    putmarker!(robot)

    swing!(()->!isborder(robot, Nord), robot)
end

