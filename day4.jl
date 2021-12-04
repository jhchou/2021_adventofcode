struct Board
    filled::Matrix{Bool} # zeros(Bool, 5, 5)
    numbers::Dict{Int, Tuple{Int, Int}} # number --> (row, col) position
end

println("==================================================")

# file = "data/day4_test.txt" # ::IOStream
file = "data/day4.txt" # 

lines = readlines(file)

draws = parse.(Int, split(lines[1], ','))
println("Draw numbers: ", draws)

numboards = (length(lines) - 2) ÷ 6 # integer division
# println("Number of boards: ", numboards)

allboards = Board[]
for n = 1:numboards # for row in 6n-3 : 6n+1 # each row of the n'th board
    numbers = Dict{Int, Tuple{Int, Int}}()
    for row in 1:5 # each row of the n'th board
        rownumbers = parse.(Int, split(lines[row + 6n-4]))
        for col in 1:5
            numbers[rownumbers[col]] = (row, col)
        end
    end
    push!(allboards, Board(zeros(Bool, 5, 5), numbers))
end


bingo = function(allboards, draws)
    numboards = length(allboards)
    for draw in draws
        for n = 1:numboards
            if haskey(allboards[n].numbers, draw)
                (row, col) = allboards[n].numbers[draw]
                allboards[n].filled[row, col] = true
                b = allboards[n]
                if any(sum(b.filled, dims = 1) .== 5) || any(sum(b.filled, dims = 2) .== 5)
                    total = 0
                    for num in keys(b.numbers)
                        (r, c) = b.numbers[num] # should enumerate
                        if !b.filled[r, c]
                            total += num
                        end
                    end
                    return((n, draw, total, total*draw))
                end
            end
        end
    end
end

println("Board ", bingo(allboards, draws), " wins")