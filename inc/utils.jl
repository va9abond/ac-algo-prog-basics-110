function VERIFY(cond::Bool, msg::String)::Nothing
    (!cond) && print("\033[1;31m", msg, "\033[m", "\n")
    return nothing
end


function WARN(msg::String)::Nothing
    print("\033[1;31m", msg, "\033[m", "\n")
    return nothing
end
