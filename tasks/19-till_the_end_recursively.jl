include("../inc/roblib.jl")


function moverec!(stop_cond::Function, robot, side::HorizonSide)::Int
    steps_untill_stop_cond::Int = 0

    if (!stop_cond())
        return move!(robot, side) do
            stop_cond()
        end
        steps_untill_stop_cond += 1
    end

    return steps_untill_stop_cond
end


function main!(robot, side)
    moverec!(robot, side) do
        isborder(robot, side)
    end
end
