# Part 1

depth = horizontal = 0
lines = eachline("data/day2.txt")
for line in lines
    m = match(r"(.+) (\d+)", line)
    m === nothing && continue
    (command, numstring) = m.captures
    num = parse(Int, numstring)
    if command == "forward"
        horizontal += num
    elseif command == "down"
        depth += num
    elseif command == "up"
        depth -= num
    else
        println("*** ERROR ***")
    end
end
println(horizontal * depth) # 2102357


# Part 2
# Use pipe to avoid intermediary variable
depth = aim = horizontal = 0
lines = eachline("data/day2.txt")
for line in lines
    m = match(r"(.+) (\d+)", line)
    m === nothing && continue
    (command, num) = m.captures |> captures -> (captures[1], parse(Int, captures[2]))
    if command == "forward"
        horizontal += num
        depth += aim * num # added for part 2
    elseif command == "down"
        aim += num # horizontal for part 1
    elseif command == "up"
        aim -= num # horizontal for part 1 
    else
        println("*** ERROR ***")
    end
end
println(horizontal * depth) # 2101031224


