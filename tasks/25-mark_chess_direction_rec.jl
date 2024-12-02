include("../inc/roblib.jl")

# -----------
# (i) variant
# -----------
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


# ------------
# (ii) variant
# ------------
function mark_direction_chess!(stop_cond::Function, robot, side::HorizonSide, ::Val{0})
    if (!stop_cond())
        move!(robot, side)

        return mark_direction_chess!(robot, side, Val(1)) do
            stop_cond()
        end
    else
        return nothing
    end
end


function mark_direction_chess!(stop_cond::Function, robot, side::HorizonSide, ::Val{1})
    if (!stop_cond())
        putmarker!(robot)
        move!(robot, side)

        return mark_direction_chess!(robot, side, Val(0)) do
            stop_cond()
        end
    else
        return nothing
    end
end
