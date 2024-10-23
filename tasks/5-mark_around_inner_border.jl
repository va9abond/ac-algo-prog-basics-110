include("../inc/roblib.jl")


# Search inner border from corner (Nord,Ost)
# If inner border exists, function return true and
# robot on the (Nord,Ost) corner of that border
#                    R
#             ...--- +
#                    |
#                   ...
function find_inner_border!(robot)::Bool
    path_into_corner = move_into_corner!(robot, (Nord, Ost))

    direction_border::HorizonSide = Sud
    direction_in_row::HorizonSide = West

    # find inner border
    while (!isborder(robot, direction_border))
        move!(
            () -> isborder(robot, direction_border) || isborder(robot, direction_in_row),
            robot, direction_in_row
        )

        direction_in_row = reverse_side(direction_in_row)
        if (!isborder(robot, direction_border))
            move!(robot, direction_border)
        end
    end

    # there is no any inner border
    #  |     |
    #  |R   R|
    #  + --- +
    if (isborder(robot, West) || isborder(robot, Ost))
        return false
    end

    # inner border has been found, put robot on the (Nord, Ost) corner if it's not
    if (direction_in_row == Ost)
        # R
        # + ------ +     NOW
        # |        |

        move!(() -> !isborder(robot, direction_border), robot, Ost)
        move!(robot, West)

        #          R
        # + ------ +     NOW
        # |        |
    end

    return true
end


function mark_around_border!(robot)::Nothing
    # START: robot stay on the corner(Nord,Ost) of inner border
    direction_border = Sud
    direction_move = West

    # border should always be on "left hand side" of the robot - anticlocwise bypass
    for _ in 0:3
        putmarker!(robot)

        while (isborder(robot, direction_border))
            move!(robot, direction_move)
            putmarker!(robot)
        end

        direction_move = direction_border
        move!(robot, direction_move)

        direction_border = next_side(direction_border)
    end

    return nothing
end


function main!()
    robot::Robot = Robot("inner_border_convex.sit", animate=true)

    corner = (Nord, Ost)
    path_into_corner = move_into_corner!(robot, corner)

    # mark_perimeter!
    side::HorizonSide = reverse_side(corner[2])
    for _ in 0:3
        mark_direction!(robot, side) # mark from corner to corner
        side = next_side(side)
    end

    success = find_inner_border!(robot)
    (!success) && (WARN("there is no inner border"), return)

    mark_around_border!(robot)

    move_into_corner!(robot, corner)
    move!(robot, reverse_path(path_into_corner))
end


function main!(robot)
    corner = (Nord, Ost)
    path_into_corner = move_into_corner!(robot, corner)

    # mark_perimeter!
    side::HorizonSide = reverse_side(corner[2])
    for _ in 0:3
        mark_direction!(robot, side) # mark from corner to corner
        side = next_side(side)
    end

    success = find_inner_border!(robot)
    (!success) && (WARN("there is no inner border"), return nothing)

    mark_around_border!(robot)

    move_into_corner!(robot, corner)
    move!(robot, reverse_path(path_into_corner))
end
