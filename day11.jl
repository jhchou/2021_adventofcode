takestep! = function(grid)
    (xmax, ymax) = size(grid)
    grid .+= 1 # increase energy by 1
    flashed = Set{CartesianIndex}() # to remember what has flashed this step; can only flash once
    while true # repeat until no more new flashes
        anyflashed = false
        toflash = findall(grid .> 9) # all coordinates where > 9
        for crd in toflash
            if !(crd in flashed) # new flash found; add to list; increment adjacent cells
                anyflashed = true
                push!(flashed, crd)
                for xoffset in -1:1, yoffset in -1:1
                    x = crd[1] + xoffset
                    y = crd[2] + yoffset
                    ((xoffset, yoffset) != (0, 0)) && checkbounds(Bool, grid, x, y) && (grid[x, y] += 1)
                end
            end
        end
        !anyflashed && break
    end
    for crd in flashed # reset all flashed cells to 0
        grid[crd] = 0
    end
    return(length(flashed)) # total number flashed this step
end

day11 = function(file)
    # Convert file of grid of digits into matrix of Int: https://www.assertnotmagic.com/2019/05/17/julia-read-grid/
    lines = readlines(file) .|> collect .|> x -> parse.(Int, x)
    grid = permutedims(hcat(lines...)) # without ..., get 5x1 matrix of Vector, instead of 10x5 matrix of Int

    # Part 1: total flashed after 100 steps
    grid1 = copy(grid) # takestep! changes grid, so run on a copy
    totalflashed = 0
    for step in 1:100
        totalflashed += takestep!(grid1)
    end

    # Part 2: number steps until entire grid flashes synchronously
    step = 1
    while takestep!(grid) != length(grid)
        step += 1
    end

    return(totalflashed, step)
end

# file = "data/day11_test.txt" # part 1 = 1656; part 2 = 195
file = "data/day11.txt" # part 1 = 1591; part 2 = 314

results = day11(file)
println("Part 1: $(results[1])")
println("Part 2: $(results[2])")
