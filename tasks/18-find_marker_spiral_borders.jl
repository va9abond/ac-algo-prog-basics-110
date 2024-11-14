include("../inc/BorderBypassRobot.jl")


function main!()
    robot::Robot = Robot("18-find_marker_spiral_borders.sit", animate=true)
    rbt_bypass = BorderBypassRobot(robot)

    move_spiral!(()->ismarker(rbt_bypass), rbt_bypass, Ost)
end


function main!(robot)
    move_spiral!(()->ismarker(robot), robot, Ost)
end
