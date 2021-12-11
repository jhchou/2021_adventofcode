takestep! = function(pad_m)
    numberflashed = 0
    pad_m .+= 1 # increase energy by 1
    flashed = Set{CartesianIndex}() # what has flashed this step
    while true
        anyflashed = false
        toflash = findall(pad_m .> 9) # all coordinates > 9
        for crd in toflash
            if !(crd in flashed) # already flashed
                # Increment all adjacent by 1
                x0 = crd[1]
                y0 = crd[2]
                for (x,y) in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
                    pad_m[x0 + x, y0 + y] += 1
                end
                anyflashed = true
                numberflashed += 1
                push!(flashed, crd)
            end
        end
        if !anyflashed
            break
        end
    end
    for crd in flashed
        pad_m[crd] = 0
    end
    return(numberflashed)
end


# file = "data/day11_test.txt" # part 1 = ; part 2 = 
# file = "data/day11_test2.txt" # part 1 = ; part 2 = 
file = "data/day11.txt" # part 1 = ; part 2 = 

# results = day10(file)
# println("Part 1: $(results[1])")
# println("Part 2: $(results[2])")

# part1(file)

v = function()
    (x,y) = size(pad_m)
    pad_m[2:x-1, 2:y-1]
end



# Convert file of grid of digits into matrix of Int
# https://www.assertnotmagic.com/2019/05/17/julia-read-grid/
lines = readlines(file) .|> collect .|> x -> parse.(Int, x)
m = permutedims(hcat(lines...)) # without ..., get 5x1 matrix of Vector, instead of 10x5 matrix of Int

# create matrix pad_m which m padded with -Inf; will be 2 larger in each dimension than m
pad_m = fill(-1000, size(m) .+ 2) # or typemin(Int)
(x, y) = size(m)
pad_m[2:(x+1), 2:(y+1)] = m # replace interior of n by m --> m surrounded by -Inf

# Part 1
# totalflashed = 0
# for step in 1:100
#     totalflashed += takestep!(pad_m)
# end
# totalflashed

step = 1
while takestep!(pad_m) != length(m)
    step += 1
end
step
