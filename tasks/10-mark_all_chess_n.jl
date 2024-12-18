include("../inc/latest/GeneralRobot.jl")
include("../inc/latest/MarkCondRobot.jl")
include("../inc/latest/CoordsRobot.jl")
include("../inc/roblib.jl")



function main!(square_size::Int = 2)
    grobot::GRobot = GRobot("random_pos_no_borders.sit")
    # grobot::GRobot = GRobot(Robot(15,15, animate=true))
    corner = (Sud, West)
    path_into_corner = move_into_corner!(grobot, corner)

    rbt_coords = CoordsRobot(grobot)
    rbt_markcond = MarkCondRobot(rbt_coords) do
        coords = unpack(getcoords(rbt_coords))
        n = square_size
        x = mod(coords[1], 2*n)
        y = mod(coords[2], 2*n)

        return ( (x in 0:n-1) && (y in 0:n-1) ) ||
               ( (x in n:2*n-1) && (y in n:2*n-1) )
   end

    move_snake!(
        rbt_markcond;
        side_move=reverse_side(corner[1]),
        side_in_row=reverse_side(corner[2])
    ) do
        false
     end

    move_into_corner!(grobot, corner)
    move!(grobot, reverse_path(path_into_corner))
end
