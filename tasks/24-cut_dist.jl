include("../inc/roblib.jl")


function moverec!(stop_cond::Function, robot, side::HorizonSide)::Int
    if (!stop_cond())
        move!(robot, side)

        return moverec!(robot, side) do
            stop_cond()
        end + 1
    else
        return 0
    end
end


function moverec!(robot, side::HorizonSide, steps::Int)::Bool
    if (steps > 0)
        isborder(robot, side) && return false
        move!(robot, side)

        return moverec!(robot, side, steps-1)
    else
        return true
    end
end


function cut_distance!(robot, side::HorizonSide)
    steps = moverec!(robot, side) do
        isborder(robot, side)
    end
    moverec!(robot, reverse_side(side), div(steps,2))
end
