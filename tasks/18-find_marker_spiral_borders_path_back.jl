include("../inc/BorderBypassRobot.jl")
include("../inc/Slug.jl")


function main!()
    robot::Robot = Robot("18-find_marker_spiral_borders.sit", animate=true)
    rbt_bypass = BorderBypassRobot(robot)
    rbt_slug = Slug(rbt_bypass, [])

    move_spiral!(()->ismarker(rbt_bypass), rbt_slug, Ost)
    move!(rbt_slug, reverse_path(rbt_slug._path))
end


function main!(robot)
    move_spiral!(()->ismarker(robot), robot, Ost)
    move!(robot, reverse_path(robot._path))
end
