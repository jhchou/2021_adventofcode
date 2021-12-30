limit = function(x, val)
    if abs(x) > val
        return val * sign(x)
    else
        return x
    end
end

# file = "data/day22_test1.txt" # part 1 = 39; 
# file = "data/day22_test2.txt" # part 1 = 590784
file = "data/day22.txt" # part 1 = 545118

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

boxes = Set{Box}()
line = readline(file)

m = match(r"(on|off) x=(.+)\.\.(.+),y=(.+)\.\.(.+),z=(.+)\.\.(.+)", line)
type = (m.captures[1] == "on")
num = m.captures[2:7] .|> x -> parse(Int, x)
x = num[1]:num[2]
y = num[3]:num[4]
z = num[5]:num[6]

for line in eachline(file)
    m = match(r"(on|off) x=(.+)\.\.(.+),y=(.+)\.\.(.+),z=(.+)\.\.(.+)", line)
    type = (m.captures[1] == "on")
    num = m.captures[2:7] .|> x -> parse(Int, x)
    if num[5] > num[6]
        println(line)
    end
end

subintervals = function(old::UnitRange, new::UnitRange)
    # vector of UnitRange intervals that are subsets of the old range, that do NOT intersect the new range
    if length(old ∩ new) == 0 # no intersection, so return entire old
        return old
    end

    newmin = minimum(new)
    newmax = maximum(new)
    
    # bounds = vcat([minimum(old), maximum(old)], [newmin-1, newmin, newmin+1, newmax-1, newmax, newmax+1]) # include boundary points for REAMINING boxes from old
    bounds = [newmin-1, newmin, newmin+1, newmax-1, newmax, newmax+1] # include boundary points for REAMINING boxes from old
    bounds = [x for x in sort(unique(bounds)) if x ⊆ old]
    bounds = vcat(minimum(old), bounds, maximum(old))
    
    interval = UnitRange[]
    for i in 1:length(bounds)-1
        rng = bounds[i]:bounds[i+1]
        if length(intersect(rng, new)) == 0
            push!(interval, bounds[i]:bounds[i+1])
        end
    end
    return unique(interval) # unique 
end

subintervals(1:10, 3:3)
subintervals(1:10, 2:9)
subintervals(5:6, 6:10)
subintervals(5:6, 7:10)

collect(Iterators.product(subintervals(1:10, 5:5), subintervals(1:10, 5:5), subintervals(1:10, 5:5)))


collect(Iterators.product(subintervals(1:10, 3:3), subintervals(1:10, 2:9), subintervals(1:10, 2:5)))
