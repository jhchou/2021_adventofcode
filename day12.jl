readnodes = function(file)
    nodes = Dict{String, Array{String}}()
    small = Array{String}
    for line in eachline(file)
        m = match(r"(.*)-(.*)", line)
        m === nothing && continue
        (n1, n2) = m.captures
        haskey(nodes, n1) ? push!(nodes[n1], n2) : nodes[n1] = [n2]
        haskey(nodes, n2) ? push!(nodes[n2], n1) : nodes[n2] = [n1]
    end
    smallnodes = [node for node in keys(nodes) if all(char -> char in 'a':'z', collect(node))]
    return (nodes, smallnodes)
end



(nodes, smallnodes) = readnodes(file)

pathsearch = function(newnode::String, visited::Array{String})
    push!(visited, newnode)
    if newnode == "end"
        println(join(visited, ','))
        return true
    end

    nextnodes = [node for node in values(nodes[newnode]) if !((node in visited) && (node in smallnodes))]
    if length(nextnodes) == 0
        return false
    end
    total = 0
    for nextnode in nextnodes
        total += pathsearch(nextnode, copy(visited))
    end
    return total
end


# file = "data/day12_test.txt" # part 1 = 10; part 2 = 
# file = "data/day12_test2.txt" # part 1 = 19; part 2 = 
# file = "data/day12_test3.txt" # part 1 = 226; part 2 = 
file = "data/day12.txt" # part 1 = 5157; part 2 = 

pathsearch("start", String[])

# results = day11(file)
# println("Part 1: $(results[1])")
# println("Part 2: $(results[2])")
