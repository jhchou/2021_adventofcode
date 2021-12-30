# file = "data/day22_test1.txt" # part 1 = 39; 
# file = "data/day22_test2.txt" # part 1 = 590784
file = "data/day22.txt" # part 1 = 545118

limit = function(x, val)
    if abs(x) > val
        return val * sign(x)
    else
        return x
    end
end

reactor = Dict{Tuple{Int, Int, Int}, Bool}()
for line in eachline(file)
    m = match(r"(on|off) x=(.+)\.\.(.+),y=(.+)\.\.(.+),z=(.+)\.\.(.+)", line)
    type = (m.captures[1] == "on")
    num = m.captures[2:7] .|> x -> parse(Int, x)
    # (x1, x2, y1, y2, z1, z2) = num
    if (abs(num[1]) > 50 && abs(num[2]) > 50) || (abs(num[3]) > 50 && abs(num[4]) > 50) || (abs(num[5]) > 50 && abs(num[6]) > 50)
        continue
    end
    (x1, x2, y1, y2, z1, z2) = [limit(x, 50) for x in num]
    x1 < x2 ? (xmin, xmax) = (x1, x2) : (xmin, xmax) = (x2, x1)
    y1 < y2 ? (ymin, ymax) = (y1, y2) : (ymin, ymax) = (y2, y1)
    z1 < z2 ? (zmin, zmax) = (z1, z2) : (zmin, zmax) = (z2, z1)
    println("$type: $xmin, $xmax, $ymin, $ymax, $zmin, $zmax")
    for x in xmin:xmax, y in ymin:ymax, z in zmin:zmax
        reactor[x,y,z] = type
    end
end
sum(collect(values(reactor)))

######### Part 2 #########

struct Box
    x::UnitRange
    y::UnitRange
    z::UnitRange
end

intersectbox = function(old::Box, new::Box)
    dx = old.x ∩ new.x
    dy = old.y ∩ new.y
    dz = old.z ∩ new.z
    return all(i -> length(i) != 0, [dx, dy, dz])
end

subintervals = function(old::UnitRange, new::UnitRange)
    # vector of UnitRange intervals that are all possible subsets of the old range
    # that CAN intersect the new range (because in multiple dimensions, overlap may not occur in other dims)
    if length(old ∩ new) == 0 # no intersection, so return entire old
        return [old]
    end
    oldmin = minimum(old)
    oldmax = maximum(old)
    newmin = minimum(new) <= oldmin ? oldmin : minimum(new) # bound to old range
    newmax = maximum(new) >= oldmax ? oldmax : maximum(new) # bound to old range

    intervals = UnitRange[]
    if newmin > oldmin # Before new range
        push!(intervals, oldmin:newmin-1)
    end
    push!(intervals, newmin:newmax) # New range
    if newmax < oldmax # After new range
        push!(intervals, newmax+1:oldmax)
    end

    return intervals
end

# subintervals(1:10, 3:4)
# subintervals(1:10, 3:3)
# subintervals(1:10, 2:9)
# subintervals(5:6, 1:5)
# subintervals(5:6, 6:10)
# subintervals(5:6, 7:10)


# oldbox = Box(1:10, 1:10, 1:10)
# newbox = Box(5:5, 5:5, 5:5)


# file = "data/day22_test1.txt" # part 1 = 39; 
# file = "data/day22_test2.txt" # part 1 = 590784
# file = "data/day22_test3.txt" # part 1 = ; part2 = 2758514936282235
file = "data/day22.txt" # part 1 = 545118; part2 = 1227298136842375
boxes = Set{Box}()
for line in eachline(file)
    m = match(r"(on|off) x=(.+)\.\.(.+),y=(.+)\.\.(.+),z=(.+)\.\.(.+)", line)
    type = (m.captures[1] == "on")
    num = m.captures[2:7] .|> x -> parse(Int, x)
    newbox = Box(num[1]:num[2], num[3]:num[4], num[5]:num[6])
    for oldbox in boxes
        if intersectbox(oldbox, newbox)
            delete!(boxes, oldbox) # seems VERY dangerous, modifying what we're interating over; but it works
            for (x,y,z) in Iterators.product(subintervals(oldbox.x, newbox.x), subintervals(oldbox.y, newbox.y), subintervals(oldbox.z, newbox.z))
                if !intersectbox(Box(x, y, z), newbox)
                    push!(boxes, Box(x, y, z)) # also seems like a REALLY bad idea, but it works
                end
            end
        end
    end
    if type
        push!(boxes, newbox)
    end
end


sum = 0
for box in boxes
    sum += length(box.x)*length(box.y)*length(box.z)
end
sum
