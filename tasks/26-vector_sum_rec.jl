using Random
using BenchmarkTools


function sumrec(vector::Vector{Int})::Int
    (length(vector) == 1) && return vector[1]
    return vector[1] + sumrec(vector[2:end])
end


# Create and fill vector with random values
vec = Vector{Int}(undef, 10000)
rand!(vec, -1000:1000)
(length(vec) < 15) && println(transpose(vec))

# Call built-in function
# @show @benchmark sum(vec)

# Call my recursive function
# @show @benchmark sumrec(vec)
