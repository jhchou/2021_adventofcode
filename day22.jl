# using DataStructures # for DefaultDict

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