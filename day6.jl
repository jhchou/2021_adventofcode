# file = "data/day6_test.txt" # 3,4,3,1,2; part 1 = 5934; part 2 = 26984457539
file = "data/day6.txt" # part 1 = 362666; part 2 = 1640526601595

fish = function(numdays, file)
    population = zeros(Int, 9) # index 1 = number of fish at timer ZERO
    fishlist = parse.(Int, split(readline(file), ','))
    for fish in fishlist
        population[fish + 1] += 1 # timer n goes to position n + 1
    end
    
    for day in 1:numdays
        numtimer0 = popfirst!(population) # remove fish at timer 0
        push!(population, numtimer0) # add new fish at 8
        population[7] += numtimer0 # reset fish to 6
    end
    return(sum(population))
end

println(fish(80, file))  # Part 1
println(fish(256, file)) # Part 2


# Look into:
using OffsetArrays
x = OffsetVector(zeros(Int, 9), 0:8)
x[0] = 1
x

