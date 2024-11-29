using Random
using BenchmarkTools

# return sum of all vector entries and current_sum
# function sumrec(vector::Vector{value_type}, current_sum = value_type(0))::value_type where value_type
# TODO init sum with default constructor of value_type
# sum::value_type = missing
# sum::value_type = value_type(0)
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
