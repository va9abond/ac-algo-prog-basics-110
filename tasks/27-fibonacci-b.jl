# 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946, 17711, ...
# 1  2  3  4  5  6  7   8   9  10  11  12

function fibonacci(n::Int)::Int
    n in (1,2) && return 1

    return fibonacci(n-2) + fibonacci(n-1)
end


function main(N::Int=20)::Nothing
    for n in 1:N
        print(fibonacci(n)," ")
    end
end
