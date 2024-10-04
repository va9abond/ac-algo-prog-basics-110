include("../inc/roblib.jl")


function mark_infrontof_borders!(robot::Robot)
    mark_direction::HorizonSide = Ost
    steps_in_direction::Integer = 0

    for corner in [(Sud, West), (Sud, Ost), (Nord, Ost), (Nord, West)]
        path_into_corner = move_into_corner!(robot, side_v=corner[1], side_h=corner[2])[2]

        for p in path_into_corner
            if (p[1] == reverse_side(mark_direction))
                steps_in_direction += p[2]
            end
        end

        move!(robot, mark_direction, steps_in_direction)
        putmarker!(robot)
        move!(robot, reverse_side(mark_direction), steps_in_direction)
        mark_direction = next_side(mark_direction)
        steps_in_direction = 0

        move!(robot, reverse_path(path_into_corner))
    end
end


function main()
    robot = Robot("mark_infrontof_borders.sit", animate=true)
    mark_infrontof_borders!(robot)
end
