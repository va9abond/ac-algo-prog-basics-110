# TODO wrap "roblib.jl" in module


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


function HorizonSideRobots.move!(robot::Robot, path::Vector{Tuple{HorizonSide, T}})::Tuple{Bool, Vector{Tuple{HorizonSide, T}}} where T <: Integer
    traversed_path::Vector{Tuple{HorizonSide, T}} = []

    for (side, steps) in path
        success, steps_traversed = move!(robot, side, steps)
        push!(traversed_path, (side, steps_traversed))

        (!success) && (return (false, traversed_path))
    end

    return (true, traversed_path)
end




function iscorner(robot)::Bool
    for side_v in [Nord, Sud]
        for side_h in [West, Ost]
            (isborder(robot, side_v) && isborder(robot, side_h)) && (return true)
        end
    end

    return false
end


function which_border(robot)::Tuple{Bool, HorizonSide}
    for side in [Nord, Sud, West, Ost]
        (isborder(robot, side)) && (return (true, side))
    end

    return (false, Nord)
end


function which_borders(robot)::Tuple{Bool, Vector{HorizonSide}}
    border_sides::Vector{HorizonSide} = []
    for side in [Nord, Sud, West, Ost]
        (isborder(robot, side)) && (push!(border_sides, side))
    end

    return (!isempty(border_sides), border_sides)
end

# TODO refactor
function move_into_corner!(robot; side_v::HorizonSide=Nord, side_h::HorizonSide=West)::Tuple{Bool, Vector{Tuple{HorizonSide, Int}}}
    traversed_path::Vector{Tuple{HorizonSide, Int}} = []

    while (!isborder(robot, side_v) || !isborder(robot, side_h))
        for side in [side_v, side_h]
            steps = move!(isborder, robot, side)
            push!(traversed_path, (side, steps))
        end
    end

    # NOTE do not change return type now to save function interface
    return (true, traversed_path)
end


function mark_direction!(robot, side::HorizonSide)::Int
    steps_in_direction::Int = 0

    putmarker!(robot)
    while (!isborder(robot, side))
        move!(robot, side)
        steps_in_direction += 1
        putmarker!(robot)
    end

    return steps_in_direction
end


function mark_direction!(robot, side::HorizonSide, steps::T)::Tuple{Bool, T} where T <: Integer
    traversed_steps::T = 0

    putmarker!(robot)
    while (traversed_steps < steps)
        (isborder(robot, side)) && (return (false, traversed_steps))

        move!(robot, side)
        traversed_steps += 1
        putmarker!(robot)
    end

    return (true, steps)
end


function mark_direction!(robot, side_v::HorizonSide, side_h::HorizonSide)::Vector{Tuple{HorizonSide, Int}}
    traversed_path::Vector{Tuple{HorizonSide, Int}} = []

    putmarker!(robot)
    while (!isborder(robot, side_v) && !isborder(robot, side_h))
        move!(robot, side_v)
        push!(traversed_path, (side_v, 1))

        move!(robot, side_h)
        push!(traversed_path, (side_h, 1))

        putmarker!(robot)
    end

    return traversed_path
end


# mark when parity == 1
# function mark_chess_direction!(robot, side::HorizonSide, ::Val{0})::Int8
# function mark_chess_direction!(robot, side::HorizonSide, ::Val{1})::Int8
function mark_chess_direction!(robot, side::HorizonSide, init_parity::Int8)::Int8
    parity::Int8 = init_parity

    (parity == 1) && (putmarker!(robot))
    while (!isborder(robot, side))
        move!(robot, side)
        parity = (parity+1) % 2
        (parity == 1) && (putmarker!(robot))
    end

    return parity
end


function find_door!(robot, border_side::HorizonSide)::Tuple{HorizonSide, Int}
    flag_door::Bool = false
    (!isborder(robot, border_side)) && (flag_door = true)

    steps_in_direction::Int = 0
    side::HorizonSide = next_side(border_side)
    while (!flag_door)
        move!(robot, side, steps_in_direction)
        (!isborder(robot, border_side)) && (flag_door = true) && (break)
        steps_in_direction += 1
        side = reverse_side(side)
    end

    return (side, Int(ceil(steps_in_direction/2)))
end


# TODO return false if robot occures in the corner
function move_through_border!(robot, side::HorizonSide)
    door_side::HorizonSide, steps_untill_door::Int = find_door!(robot, side)
    move!(robot, side)
    move!(robot, reverse_side(door_side), steps_untill_door)
end


# return false if there isn't a way to bypass a border
function move_through_border!(robot, side::HorizonSide, steps::Int)
    traversed_steps::Int = 0

    while (traversed_steps < steps)
        move_through_border!(robot, side)
        traversed_steps += 1
    end

end
