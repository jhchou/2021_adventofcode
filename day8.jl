file = "data/day8_test.txt" # part 1 = 37; part 2 = 168
# file = "data/day8.txt" # part 1 = 352331; part 2 = 99266250

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


function part2(file)
    lines = readlines(file)
    for line in lines
        str_to_int = Dict{String, Int}()
        int_to_str = Dict{Int64, String}()
        m = match(r"(.*) \| (.*)", line)
        m === nothing && continue
        signals = m.captures[1]
        output = m.captures[2]
        signal = split(signals)

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

        # 5 segment that has '1' Set(int_to_str[1]) is a 2
        for (idx, val) in enumerate(signal)
            if length(val) == 5 && (Set(int_to_str[1]) ⊆ Set(signal[idx]))
                str_to_int[signal[idx]] = 2
                int_to_str[2] = signal[idx]
            end
        end

        # 6 segment that does NOT have '1' is 6
        for (idx, val) in enumerate(signal)
            if length(val) == 6 && !(Set(int_to_str[1]) ⊆ Set(signal[idx]))
                str_to_int[signal[idx]] = 6
                int_to_str[6] = signal[idx]
            end
        end

        
    end
    
end
