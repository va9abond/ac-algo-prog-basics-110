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


function iscorner(robot)::Bool
    for side_v in [Nord, Sud]
        for side_h in [West, Ost]
            isborder(robot, side_v) && isborder(robot, side_h) && return true
        end
    end

    return false
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

    (abs( Int(side1)-Int(side2) ) == 2) && print("mark_direction!(...): $side1, $side2 bad direction"), return traversed_path

    putmarker!(robot)
    while (!isborder(robot, side1) && !isborder(robot, side2))
        move!(robot, side1)
        push!(traversed_path, (side1, 1))

        move!(robot, side1)
        push!(traversed_path, (side2, 1))

        putmarker!(robot)
    end

    return traversed_path
end


# [WARNING]: test is needed
# function mark_chess_direction!(robot, side::HorizonSide, ::Val{0})::Int8
# function mark_chess_direction!(robot, side::HorizonSide, ::Val{1})::Int8
function mark_chess_direction!(robot, side::HorizonSide, parity::Int)::Int
    parity = mod(parity, 2) # expensive? parity is 1 or 0 now

    (parity == 1) && putmarker!(robot)
    parity = 1 - parity
    while (!isborder(robot, side))
        move!(robot, side)
        (parity == 1) && putmarker!(robot)
        parity = 1 - parity
    end

    return parity
end


# swing from side to side increasing the amplitude while not reach the stop_cond*
# return last side and amplitude in that side
# [WARNIGN]: (*) stop_cond may not be reached
# TODO returning value should contain info about reaching stop_cond
function swing!(stop_cond::Function, robot, side::HorizonSide = West)::Tuple{HorizonSide, Int}
    amplitude::Int = 0

    while (!stop_cond())
        amplitude += 1
        side = reverse_side(side)

        success::Bool = move!(robot, side, amplitude)[1]
        !success && print("move_swing!(...): robot met a border on his way and not achieved stop condition"), break
    end

    return (side, Int(ceil(amplitude/2)))
end


# try to bypass plain border
# TODO consider returned value from swing!
function bypass_plane!(robot, side::HorizonSide)::Bool
    gateway_side::HorizonSide, steps_from_gateway::Int = swing!(()->!isborder(robot, side), robot, next_side(side))
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
