using HorizonSideRobots
include("GeneralRobot.jl")
include("CoordsRobot.jl")
include("BorderBypassRobot.jl")
include("MarkCondRobot.jl")
include("PathRobot.jl")

r = GRobot()
# b = BorderBypassRobot(CoordsRobot(r))

# cond(x,y)::Bool = mod(x + y)
# m = MarkCondRobot(b) do
#     coords = unpack(getcoords(b._robot))
#     return mod(coords[1] + coords[2], 2) == 0
# end
# for side in [Nord, Ost, Sud, West]
#     for _ in 1:5
#         move!(m, side)
#     end
# end

p = PathRobot(r)
