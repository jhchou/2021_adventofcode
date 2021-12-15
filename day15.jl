function dijkstrapath(grid, source, dest, expand = false)
    (maxx, maxy) = size(grid)
    if expand
        maxx *= 5
        maxy *= 5
    end
    # Easy case
    if source == dest return [source], 0 end
    # Initialize variables
    dist = Dict{Tuple{Int, Int}, Float64}() # vertex as key --> initialize at Inf distance
    for x in 1:maxx, y in 1:maxy
        dist[(x, y)] = Inf
    end
    dist[source] = 0

    prev = Dict{Tuple{Int, Int}, Tuple{Int, Int}}()
    for x in 1:maxx, y in 1:maxy
        prev[(x, y)] = (x, y)
    end

    Q = Set(keys(prev))
 
    # Main loop
    while !isempty(Q)
        u = reduce((x, y) -> dist[x] < dist[y] ? x : y, Q)
        pop!(Q, u)
        if dist[u] == Inf || u == dest break end

        neigh = (Tuple{Tuple{Int64, Int64}, Float64})[]
        (x0, y0) = u
        for (Δx, Δy) in [(-1, 0), (1, 0), (0, -1), (0, 1)] # left, right, up, down
            (x, y) = (x0 + Δx, y0 + Δy)
            if x >= 1 && x <= maxx && y >=1 && y <= maxy
                push!(neigh, ((x, y), gridplus(grid, x, y)))
            end
        end

        for (v, cost) in neigh
            alt = dist[u] + cost
            if alt < dist[v]
                dist[v] = alt
                prev[v] = u
            end
        end
    end
 
    # Return path
    rst, cost = Tuple{Int, Int}[], dist[dest]
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


# file = "data/day15_test.txt" # part 1 = 40; part 2 = 315 # 10 x 10
file = "data/day15.txt" # part 1 = 537; part 2 = 2881 # 100 x 100; takes a LONG time to run


# Convert file of grid of digits into matrix of Int: https://www.assertnotmagic.com/2019/05/17/julia-read-grid/
lines = readlines(file) .|> collect .|> x -> parse.(Int, x)
grid = permutedims(hcat(lines...)) # without ..., get 5x1 matrix of Vector, instead of 10x5 matrix of Int
(maxx, maxy) = size(grid)

function gridplus(grid, x, y) # return value at 5x expanded grid at [x,y]
    (maxx, maxy) = size(grid)
    x > maxx*5 || y > maxy*5 && return nothing # out of bounds
    incx = (x-1) ÷ maxx # 0, 1, 2, 3, 4
    incy = (y-1) ÷ maxy # 0, 1, 2, 3, 4
    x0 = x - incx * maxx
    y0 = y - incy * maxy
    val = grid[x0, y0] + incx + incy
    val = val <= 9 ? val : val - 9
    return val
end


path, cost = dijkstrapath(grid, (1,1), (500,500), true)
println("Shortest path from $src to $dst: ", isempty(path) ? "no possible path" : join(path, " → "), " (cost $cost)")


# day15 = function(file)
# end
# day15(file)