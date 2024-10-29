include("../inc/roblib.jl")


function main!()
    robot::Robot = Robot("8-find_marker_spiral.sit", animate=true)
    move_spiral!(()->ismarker(robot), robot, Ost)
end


function main!(robot)
    move_spiral!(()->ismarker(robot), robot, Ost)
end
