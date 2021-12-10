openbrackets  = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>', )
closebrackets = Dict(')' => '(', ']' => '[', '}' => '{', '>' => '<')
bracketscore = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137) # for part 1 scoring
completionscore = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4) # for part 2 scoring

function parseline(line)
    # println(line)
    if length(line) == 0
        return(("Valid", 0))
    end
    for (idx, c) in enumerate(line)
        if c ∈ keys(closebrackets)
            if line[idx-1] != closebrackets[c]
                return("Corrupt", bracketscore[c])
            else
                subline = line[1:idx-2] * line[idx+1:end]
                return(parseline(subline))
            end
        end
    end
    return(line, 0) # incomplete
end

day10 = function(file)
    score1 = 0 # score for part 1
    score2 = Vector{Int}() # vector to store completion scores for part 2as we find them

    for line in eachline(file)
        # Part 1
        result = parseline(line)
        score1 += result[2]

        # Part 2
        if result[1] != "Valid" && result[1] != "Corrupt" # incomplete
            completion = [openbrackets[c] for c in result[1]] |> join |> reverse # construct required completion string
            total = 0
            for c in completion
                total *= 5
                total += completionscore[c]
            end
            push!(score2, total)
        end
    end
    return(score1, sort(score2)[length(score2)÷2 + 1]) # middle score for part 2
end

# file = "data/day10_test.txt" # part 1 = 26397; part 2 = 288957
file = "data/day10.txt" # part 1 = 392421; part 2 = 2769449099

results = day10(file)
println("Part 1: $(results[1])")
println("Part 2: $(results[2])")


