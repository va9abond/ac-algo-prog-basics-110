include("../inc/roblib.jl")


function main!()
    robot::Robot = Robot("random_pos_borders.sit", animate=true)

    putmarker!(robot)
    path_into_corner = move_into_corner!(robot, (Sud, West))

    steps_in_direction_sud::Int = sum(
        (p) -> p[2] * Int(p[1] == Sud), path_into_corner
    )
    steps_in_direction_west::Int = sum(
        (p) -> p[2] * Int(p[1] == West), path_into_corner
    )

    move!(robot, Nord, steps_in_direction_sud)
    putmarker!(robot)
    steps_in_direction_sud = move!(()->isborder(robot, Nord), robot, Nord)

    move!(robot, Ost, steps_in_direction_west)
    putmarker!(robot)
    steps_in_direction_west = move!(()->isborder(robot, Ost), robot, Ost)

    move!(robot, Sud, steps_in_direction_sud)
    putmarker!(robot)
    steps_in_direction_sud = move!(()->isborder(robot, Sud), robot, Sud)

    move!(robot, West, steps_in_direction_west)
    putmarker!(robot)
    steps_in_direction_west = move!(()->isborder(robot, West), robot, West)

    move!(robot, reverse_path(path_into_corner))
    return nothing
end


function main!(robot)
    putmarker!(robot)

    for corner in [(Sud, West), (Nord, Ost)]
        path_into_corner = move_into_corner!(robot, corner)

        steps_in_direction_1 = sum(
            (p) -> p[2] * Int(p[1] == corner[1]), path_into_corner
        )
        steps_in_direction_2 = sum(
            (p) -> p[2] * Int(p[1] == corner[2]), path_into_corner
        )


        move_direction = reverse_side(corner[1])

        move!(robot, move_direction, steps_in_direction_1)
        putmarker!(robot)
        steps_in_direction_1 = move!(()->isborder(robot, move_direction), robot, move_direction)


        move_direction = reverse_side(corner[2])

        move!(robot, move_direction, steps_in_direction_2)
        putmarker!(robot)
        steps_in_direction_2 = move!(()->isborder(robot, move_direction), robot, move_direction)

        move_into_corner!(robot, corner)
        move!(robot, reverse_path(path_into_corner))
    end

    return nothing
end
