using HorizonSideRobots
include("roblib.jl")
include("latest/AbstractRobot.jl")
include("latest/GeneralRobot.jl")
include("latest/MarkCondRobot.jl")

r = GRobot(Robot(15,15, animate=true))
m = MarkCondRobot(r) do
    true
end

function start()
    move_spiral2!(m, Ost) do
        false
    end

    # move_snake2!(r, Nord, Ost) do
    #     false
    # end
end
