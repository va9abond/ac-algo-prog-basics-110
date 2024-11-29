using Random
using BenchmarkTools


function sumrec_x(vector::Vector{value_type})::value_type where value_type
    len = length(vector)
    (len == 1) && return vector[1]

    pivot = div(len, 2)
    return sumrec_x(vector[begin:pivot]) + sumrec_x(vector[pivot+1:end])
end


function sumrec(vector::Vector{value_type}, acc::value_type = 0)::value_type where value_type
    isempty(vector) && return acc
    return sumrec(vector[begin:end-1], acc + vector[end])
end


# Create and fill vector with random values
vec = Vector{Int}(undef, 10000)
rand!(vec, -1000:1000)
(length(vec) < 15) && println(transpose(vec))
println(sum(vec))

@time sum(vec)
@time sumrec(vec)
@time sumrec_x(vec)


# Call built-in function
# @show @benchmark sum(vec)

# Call my recursive function
# @show @benchmark sumrec(vec)
