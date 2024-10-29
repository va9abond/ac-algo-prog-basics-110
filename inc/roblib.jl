# TODO wrap "roblib.jl" in module
include("utils.jl")


using HorizonSideRobots


function reverse_side(side::HorizonSide)::HorizonSide
    return HorizonSide((Int(side)+2)%4)
end


# next side by anticlockwise direction
# ... -> Nord -> West -> Sud -> Ost -> Nord -> ...
function next_side(side::HorizonSide)::HorizonSide
    return HorizonSide((Int(side)+1)%4)
end


function reverse_path(path::Vector{HorizonSide})::Vector{HorizonSide}
    return reverse!(map(p -> reverse_side(p), path))
end


function reverse_path(path::Vector{Tuple{HorizonSide, T}})::Vector{Tuple{HorizonSide, T}} where T <: Integer
    return reverse!(map(p -> (reverse_side(p[1]), p[2]), path))
end


function iscollinear(side1::HorizonSide, side2::HorizonSide)
    return mod(Int(side1), 2) == mod(Int(side2), 2)
end


function HorizonSideRobots.move!(robot, side::HorizonSide, steps::T)::Tuple{Bool, Integer} where T <: Integer
    traversed_steps::T = 0

    while (traversed_steps < steps)
        isborder(robot, side) && return (false, traversed_steps)
        move!(robot, side)
        traversed_steps += 1
    end

    return (true, steps)
end


# move in the direction untill stop_cond
function HorizonSideRobots.move!(stop_cond::Function, robot, side::HorizonSide)::Int
    steps_untill_stop_cond::Int = 0

    while (!stop_cond())
        move!(robot, side)
        steps_untill_stop_cond += 1
    end

    return steps_untill_stop_cond
end


function HorizonSideRobots.move!(robot, path::Vector{HorizonSide})::Tuple{Bool, Vector{HorizonSide}}
    traversed_path::Vector{HorizonSide} = []

    for side in path
        isborder(robot, side) && return (false, traversed_path) # traversed_path != path
        move!(robot, side)
        push!(traversed_path, side)
    end

    return (true, path) # traversed_path == path
end


function HorizonSideRobots.move!(robot, path::Vector{Tuple{HorizonSide, T}})::Tuple{Bool, Vector{Tuple{HorizonSide, T}}} where T <: Integer
    traversed_path::Vector{Tuple{HorizonSide, T}} = []

    for (side, steps) in path
        success, traversed_steps = move!(robot, side, steps)
        push!(traversed_path, (side, traversed_steps))

        (!success) && return (false, traversed_path)
    end

    return (true, path)
end


function borders_around(robot)::Vector{HorizonSide}
    border_sides::Vector{HorizonSide} = []

    for side in [Nord, West, Sud, Ost]
        if (isborder(robot, side))
            push!(border_sides, side)
        end
    end

    return border_sides
end


function iscorner(robot)::Bool
    border_sides::Vector{HorizonSide} = borders_around(robot)

    border_sides_sum = sum(Int, border_sides)
    ( length(border_sides) != 2 ||
      border_sides_sum == 2 ||
      border_sides_sum == 4 ) && return false

    return true
end


function move_into_corner!(robot, corner::Tuple{HorizonSide, HorizonSide})::Vector{Tuple{HorizonSide, Int}}
    traversed_path::Vector{Tuple{HorizonSide, Int}} = []
    side1, side2 = corner[1], corner[2]

    # TODO should i prove corner here or somewhere before move_into_corner!
    (abs( Int(side1)-Int(side2) ) == 2) && (print("move_into_corner!(...): ($side1, $side2) is not a corner\n"), return traversed_path)

    while (!isborder(robot, side1) || !isborder(robot, side2))
        for side in [side1, side2]
            steps = move!(()->isborder(robot, side), robot, side)
            push!(traversed_path, (side, steps))
        end
    end

    return traversed_path
end


function mark_direction!(robot, side::HorizonSide)::Int
    traversed_steps::Int = 0

    putmarker!(robot)
    while (!isborder(robot, side))
        move!(robot, side)
        traversed_steps += 1
        putmarker!(robot)
    end

    return traversed_steps
end


function mark_direction!(robot, side::HorizonSide, steps::T)::Tuple{Bool, T} where T <: Integer
    traversed_steps::T = 0

    putmarker!(robot)
    while (traversed_steps < steps && !isborder(robot, side))
        move!(robot, side)
        traversed_steps += 1
        putmarker!(robot)
    end

    (traversed_steps != steps) && return (false, traversed_steps)

    return (true, steps)
end


# for slanting cross
function mark_direction!(robot, side1::HorizonSide, side2::HorizonSide)::Vector{Tuple{HorizonSide, Int}}
    traversed_path::Vector{Tuple{HorizonSide, Int}} = []

    (abs( Int(side1)-Int(side2) ) == 2) && (WARN("mark_direction!(...): $side1, $side2 bad direction"), return traversed_path)

    # TODO order of side1 and side2 shouldn't play any role
    # we can try 2 ways 1) side1 -> side2; and 2) side2 -> side1
    # and if all of them are imposible than we break the while loop
    putmarker!(robot)
    while (true)
        if (!isborder(robot, side1))
            move!(robot, side1)
            push!(traversed_path, (side1, 1))
        else
            break
        end

        if (!isborder(robot, side2))
            move!(robot, side2)
            push!(traversed_path, (side2, 1))
        else
            break
        end

        putmarker!(robot)
    end

    return traversed_path
end


# [WARNING]: test is needed
# function mark_chess_direction!(robot, side::HorizonSide, ::Val{0})::Int8
# function mark_chess_direction!(robot, side::HorizonSide, ::Val{1})::Int8
function mark_chess_direction!(robot, side::HorizonSide, parity::Int)::Int
    parity = mod(parity, 2) # expensive? parity is 1 or 0 now

    while (!isborder(robot, side))
        (parity == 1) && putmarker!(robot)
        parity = 1 - parity
        move!(robot, side)
    end
    (parity == 1) && putmarker!(robot)

    return parity
end


# swing from side to side increasing the amplitude while not reach the stop_cond*
# return last side and amplitude in that side
function move_swing!(stop_cond::Function, robot, init_side::HorizonSide=West)::Tuple{HorizonSide, Int}
    amplitude::Int = 0 # not perfect var name
    success::Bool = true
    side::HorizonSide = init_side

    # swing from side to side increasing amplitude untill (a door is found) or (border is met)
    while (!stop_cond() && success)
        amplitude += 1
        side = reverse_side(side)

        success = move!(robot, side, amplitude)[1]
    end

    # robot met (a border) but not (a door)
    if (!success)
        side = reverse_side(side)
        move!(robot, side, Int(ceil(amplitude/2))-1)
        amplitude = move!(stop_cond, robot, side)
    end

    # robot met a border again (in other direction) ==>
    # ==> there is no a door
    if (!stop_cond())
        return (reverse_side(init_side), 0) # returned side != init_side
    end

    if (success)
        return (side, Int(ceil(amplitude/2)))
    else
        return (side, amplitude)
    end
end


# try to bypass plain border
# TODO consider returned value from swing!
function bypass_plane!(robot, side::HorizonSide)::Bool
    gateway_side::HorizonSide, steps_from_gateway::Int = move_swing!(()->!isborder(robot, side), robot, next_side(side))
    move!(robot, side) # move robot to the gateway
    success::Bool = move!(robot, reverse_side(gateway_side), steps_from_gateway)[1]

    return success
end


function move_bypass_plane!(robot, side::HorizonSide, steps::Int)::Bool
    traversed_steps::Int = 0

    while (traversed_steps < steps)
        success::Bool = bypass_plane!(robot, side)
        !success && return false

        traversed_steps += 1
    end

    return true
end


function move_spiral!(stop_cond::Function, robot, init_side::HorizonSide=West)
    side::HorizonSide = init_side
    steps_side::Int = 1

    while (!stop_cond())

        for _ in (1:steps_side)
            move!(robot, side)
            (stop_cond()) && break
        end

        side = next_side(side)
        (iscollinear(side, init_side)) && (steps_side += 1)
    end
end
