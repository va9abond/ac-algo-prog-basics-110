include("../inc/roblib.jl")


# Search inner border from corner(Nord,West)
# If true, robot stop on the corner of that inner border
function find_inner_border!(robot::Robot)::Bool
    success, path_into_corner = move_into_corner!(robot, side_v=Nord, side_h=West)
    (!success) && (println("failed to reach the corner"), return false)

    direction_limit = reverse_side(Nord)
    direction_move = reverse_side(West)

    while (!isborder(robot, direction_limit))

        while (!isborder(robot, direction_move))
            move!(robot, direction_move)
            (isborder(robot, direction_limit)) && (return true)
        end

        move!(robot, direction_limit)
        (iscorner(robot)) && break
        direction_move = reverse_side(direction_move)
    end

    return false
end


function mark_around_border!(robot::Robot)::Bool
    # START: robot stay on the corner of inner border
    direction_limit = which_border(robot)[2]
    direction_move = Nord
    for side in [West, Ost]
        move!(robot, side)
        (isborder(robot, direction_limit)) && (direction_move = side)
        move!(robot, reverse_side(side))
    end

    for _ in 1:4
        putmarker!(robot)

        while (isborder(robot, direction_limit))
            move!(robot, direction_move)
            putmarker!(robot)
        end

        direction_move = direction_limit
        move!(robot, direction_move)
        direction_limit = which_border(robot)[2]
    end

    return true
end


function main()
    robot::Robot = Robot("mark_around_inner_border.sit", animate=true)

    corner = (Nord, West)
    success, path_into_corner = move_into_corner!(robot, side_v=corner[1], side_h=corner[2])
    (!success) && (println("failed to reach the corner"), return false)

    # mark_perimeter!
    side::HorizonSide = Sud
    for _ in 0:3
        mark_direction!(robot, side) # mark from corner to corner
        side = next_side(side)
    end

    success = find_inner_border!(robot)
    (!success) && (println("there is no inner border"), return false)

    mark_around_border!(robot)

    success = move_into_corner!(robot, side_v=corner[1], side_h=corner[2])[1]
    (!success) && (println("failed to reach the corner"), return false)

    success = move!(robot, reverse_path(path_into_corner))[1]
    (!success) && (println("failed to return to the starting position"), return false)
end
