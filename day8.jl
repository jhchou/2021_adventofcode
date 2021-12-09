# file = "data/day8_test.txt" # part 1 = 26; part 2 = 61229
file = "data/day8.txt" # part 1 = 247; part 2 = 933305

function part1(file)
    # count the number of digits which are identifiable by a unique number of segments
    # e.g., the digitis 1, 4, 7, and 8 uniquely have 2, 4, 3, and 7 segments respectively
    lines = eachline(file)
    total = 0
    for line in lines
        m = match(r"\|(.*)$", line)
        m === nothing && continue
        # split by whitespace into words, find lengths, Boolean for if length is 2,4,3,7, sum
        total += sum(m.captures[1] |> split .|> length .|> x -> x in [2,4,3,7])
    end 
    return(total)
end

println("Part 1 $(part1(file))")

##########################################################################################

function parseline(line)
    # Use set of signals as keys, because order is not constant
    settoint = Dict{Set{Char}, Int}()
    inttoset = Dict{Int, Set{Char}}()

    m = match(r"(.*) \| (.*)", line)
    signal = m.captures[1] |> split .|> Set
    outputs = m.captures[2]
    
    # identify unique length segments
    uniquelength = Dict(2 => 1, 4 => 4, 3 => 7, 7 => 8)
    for (idx, len) in enumerate(length.(signal))
        if haskey(uniquelength, len)
            settoint[signal[idx]] = uniquelength[len]
            inttoset[uniquelength[len]] = signal[idx]
        end
    end

    # identify 3 and 6
    # - 5 segment that has '1' Set(inttoset[1]) is a 3
    # - 6 segment that does NOT have '1' is 6
    for (idx, len) in enumerate(length.(signal))
        if len == 5 && (Set(inttoset[1]) ⊆ Set(signal[idx]))
            settoint[signal[idx]] = 3
            inttoset[3] = signal[idx]
        end
        if len == 6 && !(Set(inttoset[1]) ⊆ Set(signal[idx]))
            settoint[signal[idx]] = 6
            inttoset[6] = signal[idx]
        end
    end

    # identify 9 and 0; identify 5 and 2
    # - unidentified 6 segment that does NOT contain 3 is 9, otherwise 0
    # - unidentified 5 segment that is a subset of 6 is a 5, otherwise 2
    for (idx, val) in enumerate(signal)
        if length(val) == 6 && !haskey(settoint, val) # not already identified
            if Set(inttoset[3]) ⊆ Set(val)
                settoint[val] = 9
                inttoset[9] = val
            else
                settoint[signal[idx]] = 0
                inttoset[0] = val
            end
        end
        if length(val) == 5 && !haskey(settoint, val) # not already identified
            if Set(signal[idx]) ⊆ Set(inttoset[6])
                settoint[val] = 5
                inttoset[5] = val
            else
                settoint[val] = 2
                inttoset[2] = val
            end
        end
    end

    # Parse output into Integer value
    outputvalue = parse(Int, join([string(settoint[output]) for output in (outputs |> split .|> Set)]))
    
    return(settoint, settoint, outputvalue)
end

function part2(file)
    lines = eachline(file)
    total = 0
    for line in lines
        total += parseline(line)[3]
    end
    return(total)
end

println("Part 2 $(part2(file))")


##########################################################################################
#
# Digit assignment logic
#
# (unique number of segments)
# num segments
# 1   2
# 4   4
# 7   3
# 8   7

# ('1' is a subset of these remaining 5 segments)
# 2 : -1
# 3 : +1
# 5 : -1

# ('1' is a subset of these remaining 6 segments)
# 0 : +1
# 6 : -1 ***
# 9 : +1


# ('9' is a subset of these remaining 6 segments)
# 0 : 3 is NOT a subset of 0
# 9 : 3 is a subset of 9


# (Of the remaninging 5 segments...)
# 2 : NOT a subset of 6
# 5 : IS a subset of 6

#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....

#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg




# Others use segment frequency distributions to identify digits

# Nicer set-based solution
# - https://julialang.zulipchat.com/#narrow/stream/307139-advent-of-code-.282021.29/topic/day.208/near/264156687

# function decoder(uniques)
#     to_int = Dict{Set{Char}, Int}()
#     from_int = Dict{Int, Set{Char}}()
#     lengths = length.(uniques)

#     # takes only strings with length len, converts them to sets and filters by filt
#     strX(len, filt) = only(filter(filt, Set.(uniques[lengths .== len])))

#     function push_strX!(value, len, filt)
#         push!(to_int, strX(len, filt) => value)
#         push!(from_int, value => strX(len, filt))
#     end
#     push_strX!(value, len) = push_strX!(value, len, s->true)

#     push_strX!(1, 2)
#     push_strX!(4, 4)
#     push_strX!(7, 3)
#     push_strX!(8, 7)
#     push_strX!(6, 6, s -> from_int[1] ⊈ s)
#     push_strX!(9, 6, s -> from_int[4] ⊆ s)
#     push_strX!(3, 5, s -> from_int[1] ⊆ s)
#     push_strX!(5, 5, s -> s ⊆ from_int[6])
#     push_strX!(2, 5, s -> s ⊈ from_int[9])
#     push_strX!(0, 6, s -> from_int[5] ⊈ s)

#     to_int
# end

# function part_2(input)
#     sum = 0
#     for line in input
#         uniques, digits = split.(split(line, "|"))
#         dec = decoder(uniques)
#         sum += parse(Int, join([ dec[x] for x in Set.(digits)]))
#     end
#     sum
# end
