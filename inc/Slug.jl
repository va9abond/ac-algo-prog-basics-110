include("roblib.jl")


mutable struct Slug
    _robot
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


function HorizonSideRobots.move!(robot::Slug, side::HorizonSide)::Bool
    success = move!(robot._robot, side)
    success && push!(robot._path, (side, 1))

    return success
end


function HorizonSideRobots.move!(robot::Slug, side::HorizonSide, steps::Int)::Tuple{Bool, Int}
    traversed_steps::Int = 0

    while (traversed_steps < steps)
        success = move!(robot, side)
        (!success) && (return (false, traversed_steps))

        traversed_steps += 1
    end

    return (true, steps)
end


function make_checkpoint(robot::Slug)::Vector{Tuple{HorizonSide, Int}}
    traversed_path = robot._path
    return empty!(robot._path)
end
