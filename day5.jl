# collect(zip((1,2,3),fill(1, 3)))
# 3-element Vector{Tuple{Int64, Int64}}:
#  (1, 1)
#  (2, 1)
#  (3, 1)

parselines = function(file; nodiagonals = true)
    board = Dict{Tuple{Int, Int}, Int}()
    lines = eachline(file)
    for line in lines
        m = match(r"(\d+),(\d+) -> (\d+),(\d+)", line)
        m === nothing && continue
        (x1, y1, x2, y2) = m.captures .|> x -> parse(Int, x)
        len = max(abs(x2 - x1), abs(y2 - y1)) + 1
        dx = sign(x2 - x1)
        dy = sign(y2 - y1)
        if nodiagonals && dx != 0 && dy != 0
            continue
        end
        xrange = dx == 0 ? fill(x1, len) : x1:dx:x2 # not type stable...
        yrange = dy == 0 ? fill(y1, len) : y1:dy:y2 # not type stable...
        for (x,y) in zip(xrange, yrange)
            haskey(board, (x, y)) ? board[(x, y)] += 1 : board[(x, y)] = 1
        end
    end
    return( count(.>(1), values(board)) ) # number of values in dictionary > 1
end

# file = "data/day5_test.txt" # part 1 = 5; part 2 = 12
file = "data/day5.txt" # part 1 = 6710; part 2 = 20121
parselines(file, nodiagonals = false)