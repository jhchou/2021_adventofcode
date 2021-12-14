using DataStructures # for DefaultDict

parsedata = function(file)
    pairs = DefaultDict{String, Int}(0)
    expand = Dict{String, Tuple{String, String}}()
    for line in eachline(file)
        m = match(r"(.)(.) -> (.)", line)
        if m != nothing
            (x, y, z) = m.captures
            expand[x*y] = (x*z, z*y)
        elseif line != ""
            for i in 1:(length(line) - 1)
                pairs[line[i]*line[i+1]] += 1
            end
        end
    end
    return (pairs, expand)
end

takestep = function(pairs, expand)
    newpairs = DefaultDict{String, Int}(0)
    for (pair, num) in pairs
        for newpair in expand[pair]
            newpairs[newpair] += num
        end
    end
    return newpairs
end

countelements = function(pairs)
    elements = DefaultDict{Char, Int}(0)
    for (pair, num) in pairs # will count each 'interior' element twice, and 'end' elements one less
        elements[pair[1]] += num
        elements[pair[2]] += num
    end
    for (element, num) in elements
        if iseven(num)
            elements[element] = num ÷ 2
        else
            elements[element] = num ÷ 2 + 1
        end
    end
    return elements
end


# file = "data/day14_test.txt" # part 1 = 1588; part 2 = 2188189693529
file = "data/day14.txt" # part 1 = 2967; part 2 = 

(pairs, expand) = parsedata(file)
for i in 1:40
    pairs = takestep(pairs, expand)
end
pairs
sum(values(pairs)) + 1 # number of letters = number of pairs + 1
c = countelements(pairs)
maximum(values(c)) - minimum(values(c))
# results = day12(file)
# println("Part 1: $(results[1])")
# println("Part 2: $(results[2])")