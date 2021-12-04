struct Board
    filled::Matrix{Bool} # zeros(Bool, 5, 5)
    numbers::Dict{Int, Tuple{Int, Int}} # number --> (row, col) position
end

println("==================================================")

file = "data/day4_test.txt" # ::IOStream
# file = "data/day4.txt" # 

lines = readlines(file)

draws = parse.(Int, split(lines[1], ','))
println("Draw numbers: ", draws)

numboards = (length(lines) - 2) ÷ 6 # integer division
println("Number of boards: ", numboards)

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


println(a.filled)
println(a.numbers)

# f = open(file) #
# while !eof(f)
#     line = readline(f)
#     if isempty(line) # separator, so new board
#         println("New board")
#         println(board)
#         println(typeof(board))
#         # board = []
#     else
#         nextline = parse.(Int, split(line))
#         push!(board, nextline)
#     end
# end
# close(f)
