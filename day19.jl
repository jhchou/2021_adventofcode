generaterotations = function()
    # generate 24 different rotation matrices
    θ = π / 2
    rotx = Int.(round.([1 0 0; 0 cos(θ) -sin(θ); 0 sin(θ) cos(θ)]))
    roty = Int.(round.([cos(θ) 0 sin(θ); 0 1 0; -sin(θ) 0 cos(θ)]))
    rotz = Int.(round.([cos(θ) -sin(θ) 0; sin(θ) cos(θ) 0; 0 0 1]))
    
    addrotations! = function(rotations, m)
        for i in 1:4
            push!(rotations, m)
            m *= rotx
        end
        println("Unique: $(length(unique(rotations)))")
    end

    rotations = Matrix{Int}[]
    for m in [rotx, roty, roty*roty, roty*roty*roty, rotz, rotz*rotz*rotz]
        # rotz*rotz doesn't add new unique ones
        addrotations!(rotations, m)
    end
    return(rotations)
end


rotations = generaterotations()


# file = "data/day19_test.txt" # 79
file = "data/day19.txt" # part 1 = 512; part 2 = 16802

# scanner = Vector{Int64}[]
num = -1
scanner = Dict{Int64, Vector{Vector{Int64}}}()
for line in eachline(file)
    m = match(r"--- scanner (\d+) ---", line)
    if m !== nothing
        # println("$(m.captures[1])")
        num = parse(Int, m.captures[1])
        scanner[num] = Int64[]
    else
        m = match(r".*,.*,.*", line)
        if m !== nothing
            # println(parse.(Int, split(line, ",")))
            push!(scanner[num], parse.(Int, split(line, ",")))
        end
    end
end


bruteforce = function(beacons, i)
    println("Testing $i")
    for rot in rotations
        rotated_set = [rot * v for v in scanner[i]]
        for v_test in rotated_set
            for v_orig in beacons
                offset = v_orig - v_test
                offset_test = [v + offset for v in rotated_set]
                l = length(intersect(beacons, offset_test))
                if l >= 12
                    push!(scanner_pos, offset)
                    return(true, union(beacons, offset_test))
                end
            end
        end
    end
    return(false, beacons)
end

# print("$(length(intersect(scanner[0], s2))) ")
# beacons = bruteforce(beacons, 1)
# beacons = bruteforce(beacons, 3)
# beacons = bruteforce(beacons, 4)
# beacons = bruteforce(beacons, 2)

beacons = Set(scanner[0])
delete!(scanner, 0)

scanner_pos = Vector{Vector{Int64}}()
push!(scanner_pos, [0,0,0])

while length(scanner) != 0
    for k in keys(scanner)
        (changed, newbeacons) = bruteforce(beacons, k)
        if changed
            delete!(scanner, k)
            beacons = newbeacons
        end
    end
end
println(length(beacons))
scanner_pos

using Combinatorics

maxdist = 0
for (i,j) in combinations(scanner_pos, 2)
    dist = sum(abs.(i - j))
    if dist > maxdist
        maxdist = dist
    end
end
println(maxdist)