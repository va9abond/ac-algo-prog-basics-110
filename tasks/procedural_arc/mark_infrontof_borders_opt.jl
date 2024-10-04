include("../inc/roblib.jl")


# *WARNING* UNDONE
# *WARNING* UNDONE
function mark_infrontof_borders_opt!(robot::Robot)
    for corner in [(Sud, West), (Nord, Ost)]
        path_into_corner = move_into_corner!(robot, side_v=corner[1], side_h=corner[2])[2]

        steps_to_side_v::Int = 0
        steps_to_side_h::Int = 0
        for step in path_into_corner
            steps_to_side_v += step[2] * (step[1] == corner[1])
            steps_to_side_h += step[2] * (step[1] == corner[2])
        end

        for side in corner
            steps = steps_to_side_v*(side==corner[1]) + steps_to_side_h*(side==corner[2])
            move!(robot, side, steps)
            putmarker!(robot)
            move!(robot, reverse_side(side), steps)
        end

        move!(robot, reverse_path(path_into_corner))
    end
end


function main()
    robot = Robot("mark_infrontof_borders.sit", animate=true)
    mark_infrontof_borders_opt!(robot)
end
