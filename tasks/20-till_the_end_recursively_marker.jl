include("../inc/roblib.jl")


# other variant -- not nice
# function moverec_return!(stop_cond::Function, robot, side::HorizonSide)::Int
#     steps_till_border = moverec!(robot, side) do
#         isborder(robot, side)
#     end
#
#     putmarker!(robot)
#
#     move!(robot, reverse_side(side), steps_till_border)
# end


function moverec_mark_return!(stop_cond::Function, robot, side::HorizonSide)
    if (!stop_cond())
        move!(robot, side)

        steps = moverec_mark_return!(robot, side) do
            stop_cond()
        end + 1

        move!(robot, reverse_side(side))
        return steps
    else
        putmarker!(robot)
        return 0
    end

end


function main!(robot, side)
    steps = moverec_mark_return!(robot, side) do
        isborder(robot, side)
    end

    return steps
end

