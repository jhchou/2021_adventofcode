# file = "data/day9_test.txt" # part 1 = 15; part 2 = 
file = "data/day9.txt" # part 1 = ; part 2 = 

function part1(file)
    # https://www.assertnotmagic.com/2019/05/17/julia-read-grid/
    lines = readlines(file) .|> collect .|> x -> parse.(Int, x)
    m = permutedims(hcat(lines...)) # without ..., get 5x1 matrix of Vector, instead of 10x5 matrix of Int

    pad_m = fill(9, size(m) .+ 2) # create matrix 1 larger in each dimension, filled with 9
    (x, y) = size(m)
    pad_m[2:(x+1), 2:(y+1)] = m # replace interior of n by m --> m surrounded by 9's

    total = fill(false, size(m))
    for (idx, (offset_x, offset_y)) in enumerate([(-1, 0), (1, 0), (0, -1), (0, 1)])
        total += (m .< pad_m[ 2+offset_x : (x+1+offset_x), 2+offset_y : (y+1+offset_y) ])
    end

    lowpoints = (total .== 4)
    risklevels = m[lowpoints] .+ 1
    return(sum(risklevels))
end

println("Part 1 $(part1(file))")
