include("../inc/roblib.jl")


function mark_chess_direction!(stop_cond::Function, robot, side::HorizonSide, parity::Int=1)
    if (!stop_cond())
        (parity == 1) && putmarker!(robot)
        move!(robot, side)

        return mark_chess_direction!(robot, side, 1-parity) do
            stop_cond()
        end
    else
        return nothing
    end
end
