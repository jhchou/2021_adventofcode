
runalu = function(model, file)
    input = "$model"
    digit = 0
    registers = Dict("w" => 0, "x" => 0, "y" => 0, "z" => 0)
    for line in eachline(file)
        m = match(r"(...) (.)\s*(.*)", line)
        cmd = m.captures[1]
        reg = m.captures[2]
        op = m.captures[3]

        if cmd == "inp"
            digit += 1
            registers["w"] = parse(Int, input[digit])
            continue
        end
        
        if op in ["w", "x", "y", "z"]
            num = registers[op]
        else
            num = parse(Int, op)
        end
    
        if cmd == "add"
            registers[reg] += num
        elseif cmd == "mul"
            registers[reg] *= num
        elseif cmd == "div"
            registers[reg] ÷= num
        elseif cmd == "mod"
            registers[reg] %= num
        elseif cmd == "eql"
            registers[reg] = (registers[reg] == num)
        end
    end
    return registers
end



# file = "data/day24_test.txt"
# model = 4
# runalu(model, file)

file = "data/day24.txt"
# for model in 99999999999999:-1:1
# for model in 99999999999999:-1:11111111111111
#     if model % 10000 == 0
#         println("... $model ...")
#     end
#     if runalu(model, file)["z"] == 0
#         println("Result: $model")
#         break
#     end
# end

digit = 0
for line in eachline(file)
    m = match(r"(...) (.)\s*(.*)", line)
    cmd = m.captures[1]
    reg = m.captures[2]
    op = m.captures[3]

    if cmd == "inp"
        digit += 1
        println("$line, digit $digit")
        continue
    end
    
    if cmd == "add"
        println("$reg += $op")
    elseif cmd == "mul"
        println("$reg *= $op")
    elseif cmd == "div"
        println("$reg ÷= $op")
    elseif cmd == "mod"
        println("$reg %= $op")
    elseif cmd == "eql"
        println("$reg == $op")
    end
end
