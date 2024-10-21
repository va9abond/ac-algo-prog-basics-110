include("../inc/roblib.jl")


function slanting_cross!(robot)::Nothing
    # for (side_v, side_h) in [(Nord, West), (Nord, Ost), (Sud, West), (Sud, Ost)]
    for side_v in [Nord, Sud]
        for side_h in [West, Ost]
            path_in_direction = mark_direction!(robot, side_v, side_h)
            move!(robot, reverse_path(path_in_direction))
        end
    end

    return nothing
end


function main!()
    robot = Robot("random_pos_no_borders.sit", animate=true)
    slanting_cross!(robot)
end


function main!(robot)
    slanting_cross!(robot)
end
