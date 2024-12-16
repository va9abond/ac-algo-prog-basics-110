include("27-fibonacci.jl")


function fibonacci_closure_test(fib::Function, seq_len::Int)::Nothing
    for n in 1:seq_len
        print(fib(n), " ")
    end
end
