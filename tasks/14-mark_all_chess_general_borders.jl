include("../inc/latest/GeneralRobot.jl")
include("../inc/latest/BorderBypassRobot.jl")
include("../inc/latest/CoordsRobot.jl")
include("../inc/latest/MarkCondRobot.jl")
include("../inc/roblib.jl")


function start()
    grobot::GRobot = GRobot("random_pos_plain_borders.sit")

    corner = (Sud, West)
    path_into_corner = move_into_corner!(grobot, corner)

    init_parity::Int = mod( sum( p -> p[2], path_into_corner ), 2 )

    rbt_bypass = BorderBypassRobot(grobot)
    rbt_coords = CoordsRobot(rbt_bypass)
    rbt_markcond = MarkCondRobot(rbt_coords) do
        coords = unpack(getcoords(rbt_coords))
        return mod(coords[1]+coords[2], 2) == init_parity
    end

    move_snake2!(
        rbt_markcond,
        reverse_side(corner[1]), reverse_side(corner[2])
    ) do
        false
     end

    move_into_corner!(grobot, corner)
    move!(grobot, reverse_path(path_into_corner))
end
