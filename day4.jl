# file = "data/day4_test.txt" # part 1 = 4512; part 2 = 1924
file = "data/day4.txt" # part 1 = 69579; part 2 = 14877

struct Board
    filled::Matrix{Bool} # zeros(Bool, 5, 5)
    numbers::Dict{Int, Tuple{Int, Int}} # number --> (row, col) position
end

lines = readlines(file)

draws = parse.(Int, split(lines[1], ','))
numboards = (length(lines) - 2) ÷ 6 # integer division

allboards = Board[]
for n = 1 : numboards # for row in 6n-3 : 6n+1 # each row of the n'th board
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
    winningboards = Dict{Int, Int}() # this should be ordered... not a good data structure for this purpose
    for draw in draws
        for n = 1:numboards # should omit boards that have already won from further play
            haskey(winningboards, n) && continue # don't keep playing if the board has already won
            !haskey(allboards[n].numbers, draw) && continue # if the number doesn't exist in the board
            (row, col) = allboards[n].numbers[draw]
            allboards[n].filled[row, col] = true
            b = allboards[n]
            if any( [sum(b.filled, dims = 1) sum(b.filled, dims = 2)' ] .== 5 ) # it's a winner!
                
                # Calculate score
                total = 0
                for (key, value) in b.numbers
                    (r, c) = value
                    if !b.filled[r, c]
                        total += key
                    end
                end
                winningboards[n] = total * draw
                println("Board ", n, " wins: score = ", total * draw)
            end
        end
    end
end

bingo(allboards, draws)