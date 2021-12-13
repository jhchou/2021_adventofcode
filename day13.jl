using DataStructures # for DefaultDict

parsedata = function(file)
    d = DefaultDict{Tuple{Int, Int}, Bool}(false)
    folds = String[]
    for line in eachline(file)
        m = match(r"(\d+),(\d+)", line)
        if m != nothing
            (x, y) = m.captures .|> x -> parse(Int, x)
            d[x,y] = true
        end
        m = match(r"fold along (.)=(\d+)", line)
        if m != nothing
            push!(folds, line)
            # dir = m.captures[1]
            # val = parse(Int, m.captures[2])
        end
    end
    return(d, folds)
end

fold_xy! = function(d, fold)
    m = match(r"fold along (.)=(\d+)", fold)
    m === nothing && return nothing
    dir = m.captures[1]
    val = parse(Int, m.captures[2])
    for (x,y) in keys(d)
        if dir == "y" && y > val
            d[x, 2val - y] = d[x, 2val - y] || d[x, y]
            delete!(d, (x, y))
        elseif dir == "x" && x > val
            d[2val - x, y] = d[2val - x, y] || d[x, y]
            delete!(d, (x, y))
        end
    end
    return(d)
end


# file = "data/day13_test.txt" # part 1 = 17; part 2 = 
file = "data/day13.txt" # part 1 = 802; part 2 = 

(d, folds) = parsedata(file)

for (idx, fold) in enumerate(folds)
    fold_xy!(d, fold)
    if idx == 1
        println("Part 1: $(length(d))")
    end
end

xlist = Int[]
ylist = Int[]
for (x,y) in keys(d)
    push!(xlist, x)
    push!(ylist, y)
end

grid = fill(' ', (maximum(ylist)+1, maximum(xlist)+1))
for (x,y) in keys(d)
    grid[y+1, x+1] = '#'
end

for y in 1:size(grid)[1]
    println(join(grid[y,:]))
end
