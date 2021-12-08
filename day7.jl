fuelcost = function(positions, x, staticcost = true)
    dist = positions .- x .|> abs
    if staticcost # Part 1
        return (dist |> sum) # part 1
    else # Part 2
        return ((dist .* (dist .+ 1 ) .÷ 2) |> sum) # part 2: n(n+1) / 2
    end
end

# if cost function might not have a SINGLE local minimum, test over entire dataset:
minimum([fuelcost(positions, i) for i in minimum(positions):maximum(positions)])


lowestcost = function(file; staticcost = true)
    positions = parse.(Int, split(readline(file), ','))
    low = minimum(positions)
    high = maximum(positions)
    while low != high
        lowcost = fuelcost(positions, low, staticcost)
        highcost = fuelcost(positions, high, staticcost)
    
        # edge case failure: if low / high differ by only one, then return the lower cost of the two
        if high - low <= 1
            if lowcost <= highcost
                return(low, lowcost)
            else
                return(high, highcost)
            end
        end

        mid = (low + high) ÷ 2
        if lowcost > highcost
            low = mid
        elseif highcost > lowcost
            high = mid
        else # edge case failure: if symetrically equipotential on either side of minimum
            low += 1
        end
    end
    return(mid, fuelcost(positions, mid))
end

# file = "data/day7_test.txt" # part 1 = 37; part 2 = 168
file = "data/day7.txt" # part 1 = 352331; part 2 = 99266250

lowestcost(file, staticcost = true)[2]
