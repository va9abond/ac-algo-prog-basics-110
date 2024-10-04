# TODO import HorizonSideRobots as HSR
# TODO move with predicate - stop_cond or while_cond
# TODO move with predicate - make_before_move | make_after_move


using HorizonSideRobots


mutable struct rbl_path
    _path::Vector{Tuple{HorizonSide, Int}}
end


function Base.push!(path::rbl_path, direction::Tuple{HorizonSide, Int})
    return push!(path._path, direction)
end


# mutable struct rb_coords
#     coords::@NamedTuple{Int,Int} = (x = Ref(0), y = Ref(0))
# end


function reverse_side(side::HorizonSide)::HorizonSide
    return HorizonSide((Int(side)+2)%4)
end


# next side by anticlockwise direction
# ... -> Nord -> West -> Sud -> Ost -> Nord -> ...
function next_side(side::HorizonSide)::HorizonSide
    return HorizonSide((Int(side)+1)%4)
end


function reverse_path(path::Vector{HorizonSide})::Vector{HorizonSide}
    reversed_sides::Vector{HorizonSide} = []
    foreach(side -> push!(reversed_sides, reverse_side(side)), path)

    return reverse!(reversed_sides)
end


function reverse_path(path::Vector{Tuple{HorizonSide, T}})::Vector{Tuple{HorizonSide, T}} where T <: Integer
    return reverse!(map(p -> (reverse_side(p[1]), p[2]), path))
end


# move to direction side untill stop_cond
function HorizonSideRobots.move!(stop_cond::Function, robot::Robot, side::HorizonSide)::Int
    steps_untill_stop_cond::Int = 0

    while (!stop_cond(robot, side))
        HorizonSideRobots.move!(robot, side)
        steps_untill_stop_cond += 1
    end

    return steps_untill_stop_cond
end


function move_with_act!(stop_cond::Function,
                        robot::Robot, side::HorizonSide;
                        pre_act::Function, post_act::Function)::Vector{HorizonSide}
    traversed_path::Vector{HorizonSide} = []

    while (!stop_cond(robot, side))
        pre_act(robot)
        HorizonSideRobots.move!(robot, side)
        push!(traversed_path, side)
        post_act(robot)
    end

    return traversed_path
end


function HorizonSideRobots.move!(robot::Robot, path::Vector{HorizonSide})::Tuple{Bool, Vector{HorizonSide}}
    traversed_path::Vector{HorizonSide} = []

    for side in path
        (isborder(robot, side)) && (return (false, traversed_path)) # traversed_path != path
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


function HorizonSideRobots.move!(robot::Robot, side::HorizonSide, steps::T)::Tuple{Bool, Integer} where T <: Integer
    traversed_steps::T = 0

    while (traversed_steps < steps)
        (isborder(robot, side)) && (return (false, traversed_steps))
        move!(robot, side)
        traversed_steps += 1
    end

    return (true, steps)
end


function iscorner(robot::Robot)::Bool
    for side_v in [Nord, Sud]
        for side_h in [West, Ost]
            (isborder(robot, side_v) && isborder(robot, side_h)) && (return true)
        end
    end

    return false
end


function which_border(robot::Robot)::Tuple{Bool, HorizonSide}
    for side in [Nord, Sud, West, Ost]
        (isborder(robot, side)) && (return (true, side))
    end

    return (false, Nord)
end


function which_borders(robot::Robot)::Tuple{Bool, Vector{HorizonSide}}
    border_sides::Vector{HorizonSide} = []
    for side in [Nord, Sud, West, Ost]
        (isborder(robot, side)) && (push!(border_sides, side))
    end

    return (!isempty(border_sides), border_sides)
end

# TODO refactor
function move_into_corner!(robot::Robot; side_v::HorizonSide=Nord, side_h::HorizonSide=West)::Tuple{Bool, Vector{Tuple{HorizonSide, Int}}}
    traversed_path::Vector{Tuple{HorizonSide, Int}} = []

    # TODO infinite loop in a trap
    #
    # |  R  |  <-- trap
    # + --- +
    while (!isborder(robot, side_v) || !isborder(robot, side_h))
        for side in [side_v, side_h]
            steps = move!(isborder, robot, side)
            push!(traversed_path, (side, steps))
        end
    end

    # NOTE do not change return type now to save function interface
    return (true, traversed_path)
end


function mark_direction!(robot::Robot, side::HorizonSide)::Int
    steps_in_direction::Int = 0

    putmarker!(robot)
    while (!isborder(robot, side))
        move!(robot, side)
        steps_in_direction += 1
        putmarker!(robot)
    end

    return steps_in_direction
end


function mark_direction!(robot::Robot, side::HorizonSide, steps::T)::Tuple{Bool, T} where T <: Integer
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


function mark_direction!(robot::Robot, side_v::HorizonSide, side_h::HorizonSide)::Vector{Tuple{HorizonSide, Int}}
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
# function mark_chess_direction!(robot::Robot, side::HorizonSide, ::Val{0})::Int8
# function mark_chess_direction!(robot::Robot, side::HorizonSide, ::Val{1})::Int8
function mark_chess_direction!(robot::Robot, side::HorizonSide, init_parity::Int8)::Int8
    parity::Int8 = init_parity

    (parity == 1) && (putmarker!(robot))
    while (!isborder(robot, side))
        move!(robot, side)
        parity = (parity+1) % 2
        (parity == 1) && (putmarker!(robot))
    end

    return parity
end


function find_door!(robot::Robot, border_side::HorizonSide)::Tuple{HorizonSide, Int}
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
function move_through_border!(robot::Robot, side::HorizonSide)
    door_side::HorizonSide, steps_untill_door::Int = find_door!(robot, side)
    move!(robot, side)
    move!(robot, reverse_side(door_side), steps_untill_door)
end


# return false if there isn't a way to bypass a border
function move_through_border!(robot::Robot, side::HorizonSide, steps::Int)
    traversed_steps::Int = 0

    while (traversed_steps < steps)
        move_through_border!(robot, side)
        traversed_steps += 1
    end

end
