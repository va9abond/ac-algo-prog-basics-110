# ==========================================================
using Memoize

@memoize function fib_cached(n::Int)::Int
    if n in (1,2)
        return 1
    else
        return fib_cached(n-1) + fib_cached(n-2)
    end
end

# ==========================================================
# Recursion (unoptimized)

function fib_rec_unopt(n::Int)::Int
    n in (1,2) && return 1

    return fib_rec_unopt(n-2) + fib_rec_unopt(n-1)
end

# ==========================================================
# Recursion (optimized)

function fib_rec_opt(n::Int)::Int
end

# ==========================================================
# Recursion (global array)
function fib_glb_arr(n::Int)::Int
end

# ==========================================================
# Recursion (static arr)

function fib_stc_arr(n::Int)::Int
end

# ==========================================================
# Linear

function fib_linear(n::Int)::Int
    prev::Int, pprev::Int = 0, 1
    fib::Int = 1

    for i in 1:n
        fib = pprev + prev

        pprev = prev, prev = fib
    end

    return fib
end
