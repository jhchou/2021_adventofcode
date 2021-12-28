takestep = function(input)
    grid = copy(input) # don't change the input array
    (rows, cols) = size(grid)

    ci = CartesianIndices(grid)
    ciright = CartesianIndex(0, 1)
    cidown = CartesianIndex(1, 0)
    
    out = copy(grid)
    for idx in ci
        idxright = idx + ciright
        # if idxright > cilast
        if idxright[2] > cols
            idxright -= CartesianIndex(0, cols)
        end
        if grid[idx] == '>' && grid[idxright] == '.'
            out[idx] = '.'
            out[idxright] = '>'
        end
    end
    
    grid = copy(out)
    for idx in ci
        idxdown = idx + cidown
        # if idxdown > cilast # FAILS, because CartesianIndex(10, 1) > CartesianIndex(9,2) is false
        if idxdown[1] > rows
            idxdown -= CartesianIndex(rows, 0)
        end
        if grid[idx] == 'v' && grid[idxdown] == '.'
            out[idx] = '.'
            out[idxdown] = 'v'
        end
    end
    
    return out
end

printgrid = function(grid)
    for row in 1:size(grid)[1]
        println( join(grid[row,:]) )
    end
    println()
end    


# file = "data/day25_test.txt" # part 1 = 58
file = "data/day25.txt" # part 1 = 504; 

# https://discourse.julialang.org/t/converting-a-array-of-strings-to-an-array-of-char/35123/2
# grid = reduce(vcat, readlines(file) .|> collect .|> permutedims)
grid = reduce(vcat, (permutedims(collect(s)) for s in eachline(file))) # reduce allocations?

step = 1
while true
    newgrid = takestep(grid)
    if newgrid == grid break end
    grid = newgrid
    step += 1
    println(step)
    # printgrid(grid)
end

println(step)
printgrid(grid)
