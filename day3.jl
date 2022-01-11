# Avoid reading entire file into memory
# - read first line to find number of bits in each line
# - track total number of lines and sum of bits in each position

# file = "data/day3_test.txt" # 198
file = "data/day3.txt" # 4191876

f = open(file, "r")
numbits = length(readline(f))
close(f)

numlines = 0
numones = zeros(Int, numbits)
lines = eachline(file)
for line in lines
    numlines += 1
    for (i, char) in enumerate(line)
        numones[i] += (char == '1')
    end
end

gamma = epsilon = ""
for n in numones
    n / numlines >= 0.5 ? gamma*="1" : gamma*="0"
    n / numlines >= 0.5 ? epsilon*="0" : epsilon*="1"
end


gammadec = parse(Int, gamma, base = 2)
epsilondec = parse(Int, epsilon, base = 2)
gammadec * epsilondec # 4191876



function bitcounter(lines)
    # take a vector of binary number strings
    # count number of '1' bits in each position
    # return number of lines, number of bits, count of ones, and "stuff"
    numbits = length(lines[1]) # use first line to determine number of bits
    numones = zeros(Int, numbits)
    numlines = 0
    for line in lines
        numlines += 1
        for (i, char) in enumerate(line)
            numones[i] += (char == '1')
        end
    end
    
    gamma = epsilon = ""
    for n in numones
        n / numlines >= 0.5 ? gamma*="1" : gamma*="0"
        n / numlines >= 0.5 ? epsilon*="0" : epsilon*="1"
    end
    
    gammadec = parse(Int, gamma, base = 2)
    epsilondec = parse(Int, epsilon, base = 2)
    return(
        numlines = numlines,
        numbits = numbits,
        numones = numones,
        gamma = gamma,
        epsilon = epsilon,
        prod = gammadec * epsilondec
    )
end

function bitpositionfilter(lines::Vector{String}, bitposition::Int, char::Char)
    # take an array of strings, and return subset where position == char
    # e.g., stringfilter(lines, 2, '1')
    idx = lines .|> x -> x[bitposition] .|> x -> x==char # vector of Booleans
    return lines[idx]
end

function stringfilter(lines::Vector{String}; mostcommon = true)
    # determine oxygen generator and CO2 scrubber ratings
    # - O2 uses mostcommon bit
    # - CO2 uses least common bit
    linesfiltered = copy(lines)
    result = bitcounter(linesfiltered)
    for bitposition in 1:result[:numbits]
        if length(linesfiltered) != 1
            r = bitcounter(linesfiltered)
            if mostcommon
                target = r[:numones][bitposition] / r[:numlines] >= 0.5 ? '1' : '0' # mostcommon
            else
                target = r[:numones][bitposition] / r[:numlines]  < 0.5 ? '1' : '0' # leastcommon
            end
            linesfiltered = bitpositionfilter(linesfiltered, bitposition, target)
        end
    end
    return linesfiltered[1] # return [1] so don't return vector of length 1
end


# file = "data/day3_test.txt" # part 1 = 198; part 2 = 230
file = "data/day3.txt" # part 1 = 4191876; part 2 = 3414905
lines = readlines(file)

# Part 1
println("Part 1: ", bitcounter(lines)[:prod])

# Part 2
o2 = stringfilter(lines)
co2 = stringfilter(lines, mostcommon = false)
println("Part 2: ", parse(Int, o2, base = 2) * parse(Int, co2, base = 2))




# Experimenting -- another person's solution

encode(line) = [x == '1' for x in line] # split string into vector of Booleans
decode(bin) = parse(Int, join(bin .|> x -> x ? '1' : '0'), base = 2) # join vector of Booleams into chars and then Int
function filtrate(input; least_frequent = false)
    pool = Set(encode.(input))
    for i in eachindex(first(pool)) # iterate 1 : number of bits
        digit = reduce(+, pool)[i] >= length(pool) / 2 # Boolean of if total number of 1's in i'th digit >= number of set elements / 2
        digit = least_frequent ? !digit : digit
        for elem in pool
            elem[i] == digit || pop!(pool, elem)
            length(pool) == 1 && return only(pool) # exit when only one element left
        end
    end
end

# file = "data/day3_test.txt" # part 1 = 198; part 2 = 230
file = "data/day3.txt" # part 1 = 4191876; part 2 = 3414905
input = readlines(file)

oxy = filtrate(input);
co2 = filtrate(input, least_frequent = true);
decode(oxy) * decode(co2)

pool = Set(encode.(input))
reduce(+, pool)
