struct Digraph{T <: Real,U}
    edges::Dict{Tuple{U,U},T}
    verts::Set{U}
end
 
function Digraph(edges::Vector{Tuple{U,U,T}}) where {T <: Real,U}
    vnames = Set{U}(v for edge in edges for v in edge[1:2])
    adjmat = Dict((edge[1], edge[2]) => edge[3] for edge in edges)
    return Digraph(adjmat, vnames)
end
 
vertices(g::Digraph) = g.verts
edges(g::Digraph)    = g.edges
 
neighbours(g::Digraph, v) = Set((b, c) for ((a, b), c) in edges(g) if a == v)
 
function dijkstrapath(g::Digraph{T,U}, source::U, dest::U) where {T, U}
    @assert source ∈ vertices(g) "$source is not a vertex in the graph"
 
    # Easy case
    if source == dest return [source], 0 end
    # Initialize variables
    dist = Dict(v => Inf for v in vertices(g))
    prev = Dict(v => v   for v in vertices(g))
    dist[source] = 0
    Q = copy(vertices(g))
    neigh = Dict(v => neighbours(g, v) for v in vertices(g))
 
    # Main loop
    while !isempty(Q)
        u = reduce((x, y) -> dist[x] < dist[y] ? x : y, Q)
        pop!(Q, u)
        if dist[u] == Inf || u == dest break end
        for (v, cost) in neigh[u]
            alt = dist[u] + cost
            if alt < dist[v]
                dist[v] = alt
                prev[v] = u
            end
        end
    end
 
    # Return path
    rst, cost = U[], dist[dest]
    if prev[dest] == dest
        return rst, cost
    else
        while dest != source
            pushfirst!(rst, dest)
            dest = prev[dest]
        end
        pushfirst!(rst, dest)
        return rst, cost
    end
end

file = "data/day15_test.txt" # part 1 = 40; part 2 = x # 10 x 10
# file = "data/day15.txt" # part 1 = 537; part 2 = # 100 x 100


# Convert file of grid of digits into matrix of Int: https://www.assertnotmagic.com/2019/05/17/julia-read-grid/
lines = readlines(file) .|> collect .|> x -> parse.(Int, x)
grid = permutedims(hcat(lines...)) # without ..., get 5x1 matrix of Vector, instead of 10x5 matrix of Int
(maxx, maxy) = size(grid)

graph = Vector{Tuple{String, String, Int}}()

for x0 in 1:maxx, y0 in 1:maxy # traverse grid as DESTINATIONS
    for (Δx, Δy) in [(-1, 0), (1, 0), (0, -1), (0, 1)] # left, right, up, down
        (x, y) = (x0 + Δx, y0 + Δy)
        if checkbounds(Bool, grid, x, y)
            push!(graph, ("$x,$y", "$x0,$y0", grid[x0, y0]))
        end
    end
end

g = Digraph(graph)
src, dst = "1,1", "100,100"
path, cost = dijkstrapath(g, src, dst)
println("Shortest path from $src to $dst: ", isempty(path) ? "no possible path" : join(path, " → "), " (cost $cost)")


# day15 = function(file)
# end
# day15(file)