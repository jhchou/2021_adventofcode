# file = "data/day9_test.txt" # part 1 = 15; part 2 = 1134
file = "data/day9.txt" # part 1 = 456; part 2 = 1047744

function day9(file)
    # https://www.assertnotmagic.com/2019/05/17/julia-read-grid/
    lines = readlines(file) .|> collect .|> x -> parse.(Int, x)
    m = permutedims(hcat(lines...)) # without ..., get 5x1 matrix of Vector, instead of 10x5 matrix of Int

    # create matrix pad_m which is 1 larger in each dimension, padded with 9
    pad_m = fill(9, size(m) .+ 2)
    (x, y) = size(m)
    pad_m[2:(x+1), 2:(y+1)] = m # replace interior of n by m --> m surrounded by 9's

    # compare m with left, right, up, down
    total = fill(0, size(m))
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)] # left, right, up, down
    for (offset_x, offset_y) in directions
        total += (m .< pad_m[ 2+offset_x : (x+1+offset_x), 2+offset_y : (y+1+offset_y) ])
    end

    lowpoints = (total .== 4) # findall(lowpoints) returns vector of indices of lowpoints
    risklevels = m[lowpoints] .+ 1
    part1 = sum(risklevels)

    ##### Part 2 #####
    function search_basin(x, y) # recursively determine basin size
        # needs access to global 'track' matrix
        if track[x, y] == '0' # blocked
            return 0
        end
    
        if track[x, y] == '1' # tried and included
            return 0
        end
    
        track[x, y] = '1' # new continuation of basin
        return 1 + search_basin(x-1, y) + search_basin(x+1, y) + search_basin(x, y-1) + search_basin(x, y+1)
    end
    
    basin_m = pad_m .!= 9 # matrix of Booleans, padded size, where groups of true are basins; need to add 1 to indices
    sizes = Vector{Int}() # vector of basin sizes
    for lowpoint in findall(lowpoints)
        (x0, y0) = (lowpoint[1] + 1, lowpoint[2] + 1) # start point of basin
        global track = fill('.', size(basin_m)) # . untried, 0 blocked, 1 included; global so recursive function can update
        track[.!basin_m] .= '0' # fill in all obstacles
        basinsize = search_basin(x0, y0)
        push!(sizes, basinsize)
     end
     part2 = prod(sort(sizes, rev = true)[1:3]) # product of 3 largest basin sizes

     return(part1, part2)
end


(part1, part2) = day9(file)
println("Part 1: $part1")
println("Part 2: $part2")
