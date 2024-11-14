include("../inc/BorderBypassRobot.jl")


function slanting_cross!(robot)::Nothing
    for side_v in [Nord, Sud]
        for side_h in [West, Ost]
            path_in_direction = mark_direction!(robot, side_v, side_h)
            move!(robot, reverse_path(path_in_direction))
        end
    end

    return nothing
end


# for slanting cross
function mark_direction!(robot::BorderBypassRobot, side1::HorizonSide, side2::HorizonSide)::Vector{Tuple{HorizonSide, Int}}
    traversed_path::Vector{Tuple{HorizonSide, Int}} = []

    (abs( Int(side1)-Int(side2) ) == 2) && (WARN("mark_direction!(...): $side1, $side2 bad direction"), return traversed_path)

    # TODO order of side1 and side2 shouldn't play any role
    # we can try 2 ways 1) side1 -> side2; and 2) side2 -> side1
    # and if all of them are imposible than we break the while loop
    putmarker!(robot)
    while (true)
        if (move!(robot, side1))
            push!(traversed_path, (side1, 1))
        else
            break
        end

        if (move!(robot, side2))
            push!(traversed_path, (side2, 1))
        else
            break
        end

        putmarker!(robot)
    end

    return traversed_path
end


function main!()
    robot::Robot = Robot("random_pos_plain_borders.sit", animate=true)
    rbt_bypass = BorderBypassRobot(robot)

    slanting_cross!(rbt_bypass)
end
