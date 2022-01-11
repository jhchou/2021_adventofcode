# Clunky solution, reading file line by line

# Part 1
lastnum = 99999999
count = 0
f = open("data/day1.txt", "r")
while !eof(f)
    line = readline(f)
    num = parse(Int, line)
    if num > lastnum
        count += 1
    end
    lastnum = num
end
close(f)
count # 1374


# Part 2
# Reading all the lines at once into a vector of Int, then looping

f = open("data/day1.txt", "r")
lines = parse.(Int, readlines(f)) # read entire file as vector of Int
close(f)

len = length(lines)
count = 0
windowsize = 3
for i in 1 : (len - windowsize)
    if sum(lines[i+1 : i+windowsize]) > sum(lines[i : i+windowsize-1])
        count += 1
    end
end
count # 1418



# Simplify reading file into vector of Int, then use sum of booleans on list comprehension
lines = parse.(Int, eachline("data/day1.txt"))
windowsize = 3 # 1 for part 1; 3 for part 2
sum([sum(lines[i+1 : i+windowsize]) > sum(lines[i : i+windowsize-1])] for i in 1 : (length(lines) - windowsize))


# With chaining, diff, and >(0)
lines = parse.(Int, eachline("data/day1.txt"))
windowsize = 3 # 1 for part 1; 3 for part 2
ΣΔ(i) = i |> diff .|> >(0) |> sum |> println
ΣΔ(lines) # Part 1
blocks = [ sum( lines[i : (i+windowsize-1)] ) for i in 1 : (length(lines) - windowsize + 1) ]
ΣΔ(blocks) # Part 2

