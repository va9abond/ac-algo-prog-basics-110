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


function main!(robot, side)
    steps = moverec!(robot, side) do
        isborder(robot, side)
    end

    return steps
end
