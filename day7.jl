# file = "data/day7_test.txt" # part 1 = 37; part 2 = 168
file = "data/day7.txt" # part 1 = 352331; part 2 = 99266250

positions = parse.(Int, split(readline(file), ','))

fuelcost = function(positions, x)
    dist = positions .- x .|> abs

    return (dist |> sum) # part 1
    # return ((dist .* (dist .+ 1 ) .÷ 2) |> sum) # part 2

end

# minimum([fuelcost(positions, i) for i in minimum(positions):maximum(positions)])


lowestcost = function(positions)
    low = minimum(positions)
    high = maximum(positions)
    while low != high
        lowcost = fuelcost(positions, low)
        highcost = fuelcost(positions, high)
    
        # fencepost failure: if low / high differ by only one, then return the lower cost of the two
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
        else
            low += 1
        end
    end
    return(mid, fuelcost(positions, mid))
end

lowestcost(positions)
