# 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946, 17711, ...
# 1  2  3  4  5  6   7   8   9  10  11   12

function fibonacci(n::Int)::Int
    prev::Int, pprev::Int = 0, 1
    fib::Int = 1

    for i in 1:n
        fib = pprev + prev
        # println("n = $i, f($(i-2)) = $pprev, f($(i-1)) = $prev, f($(i)) = $fib")

        pprev = prev
        prev = fib
    end

    return fib
end


function main(N::Int=20)::Nothing
    for n in 1:N
        print(fibonacci(n), " ")
    end
end
