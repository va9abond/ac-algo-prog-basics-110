include("../inc/roblib.jl")


# function moverec_bypass_plane!(robot, side)
#     if (isborder(robot, side))
#         move!(robot, next_side(side))
#
#         move_bypass_plane_rec!(robot, side)
#
#         move!(robot, reverse_side(next_side(side)))
#     else
#         move!(robot, side)
#     end
# end


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


function moverec_bypass_plane!(robot, side)::Nothing
    steps = moverec!(robot, next_side(side)) do
        !isborder(robot, side)
    end
    move!(robot, side)
    moverec!(robot, reverse_side(next_side(side)), steps)

    return nothing
end


function main!(robot, side)
    moverec_bypass_plane!(robot, side)
end
