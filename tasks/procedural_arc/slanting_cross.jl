include("inc/roblib.jl")


function slanting_cross!(robot::Robot)
    # for (side_v, side_h) in [(Nord, West), (Nord, Ost), (Sud, West), (Sud, Ost)]
    for side_v in [Nord, Sud]
        for side_h in [West, Ost]
            path_in_direction = mark_direction!(robot, side_v, side_h)
            move!(robot, reverse_path(path_in_direction))
        end
    end
end
