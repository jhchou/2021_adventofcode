readnodes = function(file)
    nodes = Dict{String, Array{String}}()
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
    smallnodes = [node for node in keys(nodes) if all(islowercase, collect(node))]
    return (nodes, smallnodes)
end


pathsearch = function(newnode::String, visited::Array{String}, maxvisits = 1) # number of times small nodes can be revisited
    push!(visited, newnode)
    if newnode == "end"
        # println(join(visited, ','))
        return true
    end

    nextnodes = String[]
    for node in values(nodes[newnode])
        # can visit any ONE smallnode up to maxvisits times; but can also visit all other small nodes up to once
        smalls = [n for n in [visited; node] if n in smallnodes] # after adding node to visited, vector of smallnodes
        countsmalls = [count(==(i), smalls) for i in unique(smalls)] # number of each unique smallnode
        nummaxvisits = count(>=(maxvisits), countsmalls) # 
        
        if !(node in smallnodes) || ((nummaxvisits < 2) && (maximum(countsmalls) <= maxvisits))
            push!(nextnodes, node)
        end
    end
    if length(nextnodes) == 0
        return false
    end
    total = 0
    for nextnode in nextnodes
        total += pathsearch(nextnode, copy(visited), maxvisits)
    end
    return total
end


# file = "data/day12_test.txt" # part 1 = 10; part 2 = 36
# file = "data/day12_test2.txt" # part 1 = 19; part 2 = 103
file = "data/day12_test3.txt" # part 1 = 226; part 2 = 3509
# file = "data/day12.txt" # part 1 = 5157; part 2 = 144309; takes a few seconds to run...

(nodes, smallnodes) = readnodes(file)
pathsearch("start", String[], 2)

# results = day12(file)
# println("Part 1: $(results[1])")
# println("Part 2: $(results[2])")
