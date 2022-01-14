# The following is the semi-brute force (digit by digit) solution for day 24
function run_one_step(z, w, step)
    # given the previous Z, the step number, and the input digit 'w', calculate the resultant next z
    divs = [1, 1, 1, 26, 1, 26, 1, 26, 1, 1, 26, 26, 26, 26]
    a = [13, 12, 11, 0, 15, -13, 10, -9, 11, 13, -14, -3, -2, -14]
    b = [14, 8, 5, 4, 10, 13, 16, 5, 6, 13, 6, 7, 13, 3]
    x = z % 26 + a[step]
    z = z ÷ divs[step]
    x = (x != w)
    z = z * (25x + 1) + (w + b[step]) * x
    return z
end

valid_z = Dict{Int64, Set{Int64}}()
valid_z[14] = Set([0]) # output of step 14 is the goal of z = 0

# For each preceding step, determine all possible Z's that will yield a valid next step Z
for step in 14:-1:2
    println(step)
    valid_z[step-1] = Set{Int64}()
    for z in 1:1000000 # 1,000,000 chosen arbitrarily
        for w in 1:9
            if run_one_step(z, w, step) in valid_z[step]
                push!(valid_z[step-1], z)
            end
        end
    end
end

valid_z

z_last = 0
for step in 1:14
    # for w in 9:-1:1 # find max
    for w in 1:9 # find min
        z = run_one_step(z_last, w, step)
        if z in valid_z[step]
            z_last = z
            print("$w")
            break
        end
    end
end
println()

# max: 93499629698999
# min: 11164118121471



# Display more readable
# file = "data/day24.txt"
# digit = 0
# for line in eachline(file)
#     m = match(r"(...) (.)\s*(.*)", line)
#     cmd = m.captures[1]
#     reg = m.captures[2]
#     op = m.captures[3]
#     if cmd == "inp"
#         digit += 1
#         println("$line, digit $digit")
#         continue
#     end
#     if cmd == "add"
#         println("$reg += $op")
#     elseif cmd == "mul"
#         println("$reg *= $op")
#     elseif cmd == "div"
#         println("$reg ÷= $op")
#     elseif cmd == "mod"
#         println("$reg %= $op")
#     elseif cmd == "eql"
#         println("$reg == $op")
#     end
# end

# function runalusteps(model, file = "data/day24.txt")
#     input = "$model"
#     digit = 0
#     registers = Dict("w" => 0, "x" => 0, "y" => 0, "z" => 0)
#     for line in eachline(file)
#         m = match(r"(...) (.)\s*(.*)", line)
#         cmd = m.captures[1]
#         reg = m.captures[2]
#         op = m.captures[3]
#         if cmd == "inp"
#             digit += 1
#             registers["w"] = parse(Int, input[digit])
#             continue
#         end
#         if op in ["w", "x", "y", "z"]
#             num = registers[op]
#         else
#             num = parse(Int, op)
#         end
#         if cmd == "add"
#             registers[reg] += num
#         elseif cmd == "mul"
#             registers[reg] *= num
#         elseif cmd == "div"
#             registers[reg] ÷= num
#         elseif cmd == "mod"
#             registers[reg] %= num
#         elseif cmd == "eql"
#             registers[reg] = (registers[reg] == num)
#         end
#     end
#     return registers
# end

# runalusteps(11111111111111)["z"]
# runalusteps(99999999999999)["z"]
# runalusteps(12345678912345)["z"]

# function runalu(model)
#     divs = [1, 1, 1, 26, 1, 26, 1, 26, 1, 1, 26, 26, 26, 26]
#     a = [13, 12, 11, 0, 15, -13, 10, -9, 11, 13, -14, -3, -2, -14]
#     b = [14, 8, 5, 4, 10, 13, 16, 5, 6, 13, 6, 7, 13, 3]

#     function splitdigits(model)
#         digits = Int64[]
#         while model > 0
#             push!(digits, model % 10)
#             model ÷= 10
#         end
#         return reverse(digits)
#     end
    
#     w = splitdigits(model)
#     if any(==(0), w) # 0 digit not permitted in input
#         return -1
#     end

#     z = 0
#     for step in 1:14
#         x = z % 26 + a[step]
#         z = z ÷ divs[step] # divs is either 1 or 26
#         x = (x != w[step]) # x will be set to 1 if x != w digit, or else 0
#         z = z * (25x + 1) + (w[step] + b[step]) * x
#     end
#     return z
# end

# runalu(11111111111111)
# runalu(99999999999999)
# runalu(12345678912345)


