# file = "data/day10_test.txt" # part 1 = 26397; part 2 = 
file = "data/day10.txt" # part 1 = 392421; part 2 = 

# for line in eachline(file)
    # parens = square = curly = pointy = 0;
    # for (idx, c) in enumerate(line)
    #     c == '(' && (parens += 1)
    #     c == '[' && (square += 1)
    #     c == '{' && (curly += 1)
    #     c == '<' && (pointy += 1)

    #     if c == ')'
    #         parens -= 1
    #         parens < 0 && (println(")"); break)
    #     end
    #     if c == ']'
    #         square -= 1
    #         square < 0 && (println("]"); break)
    #     end
    #     if c == '}'
    #         curly -= 1
    #         curly < 0 && (println("}"); break)
    #     end
    #     if c == '>'
    #         pointy -= 1
    #         pointy < 0 && (println(">"); break)
    #     end
    # end
# end

openbrackets  = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>', )
closebrackets = Dict(')' => '(', ']' => '[', '}' => '{', '>' => '<')
bracketscore = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)

line = "{([(<{}[<>[]}>{[]{[(<()>"

function parseline(line)
    # println(line)
    if length(line) == 0
        # println("Valid")
        return(0)
    end
    for (idx, c) in enumerate(line)
        if c ∈ keys(closebrackets)
            if line[idx-1] != closebrackets[c]
                # println("Mismatch: $c")
                return(bracketscore[c])
            else
                subline = line[1:idx-2] * line[idx+1:end]
                # println(subline)
                return(parseline(subline))
            end
        end
    end
    # println("Incomplete")
    return(0)
end

part1 = function(file)
    score = 0
    for (idx, line) in enumerate(eachline(file))
        # println("\n$idx $line")
        score += parseline(line)
    end
    return(score)
end

println("Part 1: $(part1(file))")