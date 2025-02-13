function VERIFY(cond::Bool, msg::String)::Nothing
    (!cond) && println("\033[1;31m", msg, "\033[m")
    return nothing
end


function WARN(msg::String)::Nothing
    println("\033[1;31m", msg, "\033[m")
    return nothing
end
