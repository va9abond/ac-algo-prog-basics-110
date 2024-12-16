using Memoize

@memoize function fibonacci(n::Int)::Int
    if n in (1,2)
        return 1
    else
        return fibonacci(n-1) + fibonacci(n-2)
    end
end


function main(N::Int=20)::Nothing
    for n in 1:N
        print(fibonacci(n)," ")
    end
end
