include("roblib.jl")


mutable struct Slug
    _robot::Robot
    _path::Vector{Tuple{HorizonSide, Int}}
end


function HorizonSideRobots.ismarker(robot::Slug)
    return ismarker(robot._robot)
end

function HorizonSideRobots.isborder(robot::Slug, side::HorizonSide)
    return isborder(robot._robot, side)
end

function HorizonSideRobots.putmarker!(robot::Slug)
    return putmarker!(robot._robot)
end


function HorizonSideRobots.move!(robot::Slug, side::HorizonSide)
    move!(robot._robot, side)
    push!(robot._path, (side, 1))
end


function HorizonSideRobots.move!(robot::Slug, side::HorizonSide, steps::Int)::Tuple{Bool, Int}
    traversed_steps::Int = 0

    while (traversed_steps < steps)
        (isborder(robot, side)) && (return (false, traversed_steps))
        move!(robot, side)
        traversed_steps += 1
    end

    return (true, steps)
end


function HorizonSideRobots.move!(robot::Slug, path::Vector{Tuple{HorizonSide, Int}})
    traversed_path::Vector{Tuple{HorizonSide, Int}} = []

    for (side, steps) in path
        success, steps_traversed = move!(robot, side, steps)
        push!(traversed_path, (side, steps_traversed))

        (!success) && (return (false, traversed_path))
    end

    return (true, traversed_path)
end
