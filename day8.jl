# file = "data/day8_test.txt" # part 1 = ; part 2 = 61229
file = "data/day8.txt" # part 1 = ; part 2 = 

# unique segments: 1 -> 2; 4 -> 4; 7 -> 3; 8 -> 7
function part1(file)
    lines = readlines(file)
    total = 0
    for line in lines
        m = match(r"\|(.*)$", line)
        m === nothing && continue
        total += sum(m.captures[1] |> split .|> length .|> x -> x in [2,4,3,7])
    end 
    return(total)
end
part1(file)


function parse_line(line)
    str_to_int = Dict{String, Int}()
    int_to_str = Dict{Int, String}()
    m = match(r"(.*) \| (.*)", line)
    # m === nothing && continue
    signals = m.captures[1]
    outputs = m.captures[2]
    
    # signal = split(signals)
    signal = signals |> split .|> collect .|> sort .|> join

    # unique length segments: 1 -> 2; 4 -> 4; 7 -> 3; 8 -> 7
    for (idx, val) in enumerate(signal)
        if length(signal[idx]) == 2
            str_to_int[signal[idx]] = 1
            int_to_str[1] = signal[idx]
        elseif length(signal[idx]) == 4
            str_to_int[signal[idx]] = 4
            int_to_str[4] = signal[idx]
        elseif length(signal[idx]) == 3
            str_to_int[signal[idx]] = 7
            int_to_str[7] = signal[idx]
        elseif length(signal[idx]) == 7
            str_to_int[signal[idx]] = 8
            int_to_str[8] = signal[idx]
        end
    end

    # 5 segment that has '1' Set(int_to_str[1]) is a 3
    for (idx, val) in enumerate(signal)
        if length(val) == 5 && (Set(int_to_str[1]) ⊆ Set(signal[idx]))
            str_to_int[signal[idx]] = 3
            int_to_str[3] = signal[idx]
        end
    end

    # 6 segment that does NOT have '1' is 6
    for (idx, val) in enumerate(signal)
        if length(val) == 6 && !(Set(int_to_str[1]) ⊆ Set(signal[idx]))
            str_to_int[signal[idx]] = 6
            int_to_str[6] = signal[idx]
        end
    end

    # UNIDENTIFIED 6 segment that does NOT has 3 is 9, otherwise 0
    for (idx, val) in enumerate(signal)
        if length(val) == 6 && !haskey(str_to_int, val)
            if Set(int_to_str[3]) ⊆ Set(signal[idx])
                str_to_int[signal[idx]] = 9
                int_to_str[9] = signal[idx]
            else
                str_to_int[signal[idx]] = 0
                int_to_str[0] = signal[idx]
            end
        end
    end

    # UNIDENTIFIED 5 segment that is a subset of 6 is a 5, otherwise 2
    for (idx, val) in enumerate(signal)
        if length(val) == 5 && !haskey(str_to_int, val)
            if Set(signal[idx]) ⊆ Set(int_to_str[6])
                str_to_int[signal[idx]] = 5
                int_to_str[5] = signal[idx]
            else
                str_to_int[signal[idx]] = 2
                int_to_str[2] = signal[idx]
            end
        end
    end

    # Parse outputs
    x = [string(str_to_int[output]) for output in (outputs |> split .|> collect .|> sort .|> join)]
    
    return(int_to_str, str_to_int, parse(Int, join(x)))
end

function part_2(file)
    lines = readlines(file)
    total = 0
    for line in lines
        total += parse_line(line)[3]
    end
    return(total)
end

part_2(file)