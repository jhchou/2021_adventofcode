readnodes = function(file)
    nodes = Dict{String, Array{String}}()
    smallnodes = Set{String}() 
    for line in eachline(file)
        m = match(r"(.*)-(.*)", line)
        m === nothing && continue
        (n1, n2) = m.captures
        # can never revisit start or leave end
        if n1 != "end" && n2 != "start"
            haskey(nodes, n1) ? push!(nodes[n1], n2) : nodes[n1] = [n2] # n1 --> n2
        end
        if n2 != "end" && n1 != "start"
            haskey(nodes, n2) ? push!(nodes[n2], n1) : nodes[n2] = [n1] # n2 --> n1
        end
    end
    smallnodes = Set([node for node in keys(nodes) if all(islowercase, collect(node))])
    return (nodes, smallnodes)
end

day12 = function(file)
    (nodes, smallnodes) = readnodes(file)

    pathsearch = function(newnode::String, visited::Array{String}, canrevisit = false)
        # Needs access to global of nodes and smallnodes, so must place function in same scope where nodes + smallnodes defined
        push!(visited, newnode)
        if newnode == "end"
            # println(join(visited, ','))
            pop!(visited)
            return 1
        end
    
        total = 0
        # smalls = [n for n in visited if n in smallnodes] # vector of smallnodes visited thus far, NOT including nextnode to be tested
        for nextnode in values(nodes[newnode])
            if !(nextnode in smallnodes)
                total += pathsearch(nextnode, visited, canrevisit) # can always continue to non-smallnode
            elseif !(nextnode in visited)
                total += pathsearch(nextnode, visited, canrevisit) # can always continue non-visited smallnode
            # elseif maximum([count(==(i), smalls) for i in unique(smalls)]) < 2 # haven't revisited smallnode yet
            elseif canrevisit
                total += pathsearch(nextnode, visited, false) # no more revisits allowed
            end
        end
        pop!(visited)
        return total
    end
    
    return(pathsearch("start", String[], false), pathsearch("start", String[], true))
end

# file = "data/day12_test.txt" # part 1 = 10; part 2 = 36
# file = "data/day12_test2.txt" # part 1 = 19; part 2 = 103
# file = "data/day12_test3.txt" # part 1 = 226; part 2 = 3509
file = "data/day12.txt" # part 1 = 5157; part 2 = 144309; slightly noticable pause...

results = day12(file)
println("Part 1: $(results[1])")
println("Part 2: $(results[2])")
