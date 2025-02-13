using HorizonSideRobots
include("AbstractRobot.jl")
include("roblib.jl")


@enum Orientation Positive = 0 Negative = 1

reverse(value::Orientation) = Orientation(mod(Int(value)+1), 2)


struct EdgeRobot{orientation::Orientation, robot_type} <: AbstractRobot
    _robot::DirectRobot{robot_type}

    function EdgeRobot{Positeve, robot_type}(robot::robot_type) where robot_type
        # INVARIANT robot should hold on border with left hand and can take
        #           a step in the direction

        drobot = DirectRobot(robot, Nord)

        cnt_turns = 0
        while (!isborder(drobot) && cnt_turns < 4)
            drobot = turn_left(drobot)
            cnt_turns += 1
        end

        if (!isborder(drobot))
            error("EdgeRobot: cannot construct robot - there is no border next to robot")
        end

        cnt_turns = 0
        while (isborder(drobot) && cnt_turns < 4)
            drobot = turn_right(drobot)
            cnt_turns += 1
        end

        if (isborder(drobot))
            error("EdgeRobot: cannot construct robot - robot is surrounded with borders")
        end

        return new(drobot, orientation)
    end

    function EdgeRobot{Negative, robot_type}(robot::robot_type) where robot_type
        # INVARIANT robot should hold on border with right hand and can take
        #           a step in the direction

        drobot = DirectRobot(robot, Nord)

        cnt_turns = 0
        while (!isborder(drobot) && cnt_turns < 4)
            drobot = turn_right(drobot)
            cnt_turns += 1
        end

        if (!isborder(drobot))
            error("EdgeRobot: cannot construct robot - there is no border next to robot")
        end

        cnt_turns = 0
        while (isborder(drobot) && cnt_turns < 4)
            drobot = turn_left(drobot)
            cnt_turns += 1
        end

        if (isborder(drobot))
            error("EdgeRobot: cannot construct robot - robot is surrounded with borders")
        end

        return new(drobot, orientation)
    end
end


PositiveEdgeRobot{robot_type} where robot_type = EdgeRobot{Positive, robot_type}
NegativeEdgeRobot{robot_type} where robot_type = EdgeRobot{Negative, robot_type}
