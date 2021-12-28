parse_to_bits = function(input) # vector of Boolean 0/1
    return join(input |> collect .|> x -> string(parse(Int, x, base = 16), base = 2, pad = 4)) |> collect .|> ==('1')
end

pop_bits! = function(bits, n)
    val = false
    for i in 1:n
        val = (val << 1) | popfirst!(bits)
    end
    return val
end

gt = function(num) return num[1] > num[2] end
lt = function(num) return num[1] < num[2] end
eq = function(num) return num[1] == num[2] end

parse_packet! = function(bits, versions)
    version = pop_bits!(bits, 3)
    type = pop_bits!(bits, 3)
    push!(versions, version)
    if type == 4 # literal value
        num = false
        while true
            v = pop_bits!(bits, 5)
            num = (num << 4) | (v & 15)
            if v < 16 break end
        end
        println("Literal $num")
        return(num)
    else
        num = Int[]
        lengthtypeid = pop_bits!(bits, 1)
        if lengthtypeid == 0
            totallength = pop_bits!(bits, 15)
            println("Total length $totallength")
            repeatuntil = length(bits) - totallength
            while length(bits) > repeatuntil
                push!(num, parse_packet!(bits, versions))
            end
        elseif lengthtypeid == 1
            numsubpackets = pop_bits!(bits, 11)
            println("Num subpackets $numsubpackets")
            for i = 1:numsubpackets
                push!(num, parse_packet!(bits, versions))
            end
        end
        println("Type $type; num $num")
        # type ID: 0 = sum, 1 = product, 2 = minimum, 3 = maximum, 5 = >, 6 = <, 7 = ==
        return (sum, prod, minimum, maximum, x -> NaN, gt, lt, eq)[type + 1](num)
    end
end


# hex = "D2FE28"
# hex = "8A004A801A8002F478"
# hex = "620080001611562C8802118E34"
# hex = "38006F45291200"
# hex = "EE00D40C823060"
# bits = parse_to_bits(hex)

# hex = "C200B40A82" # finds the sum of 1 and 2, resulting in the value 3.
# hex = "04005AC33890" # finds the product of 6 and 9, resulting in the value 54.
# hex = "880086C3E88112" # finds the minimum of 7, 8, and 9, resulting in the value 7.
# hex = "CE00C43D881120" # finds the maximum of 7, 8, and 9, resulting in the value 9.
# hex = "D8005AC2A8F0" # produces 1, because 5 is less than 15.
# hex = "F600BC2D8F" # produces 0, because 5 is not greater than 15.
# hex = "9C005AC2F8F0" # produces 0, because 5 is not equal to 15.
# hex = "9C0141080250320F1802104A08" # produces 1, because 1 + 3 = 2 * 2.
# bits = parse_to_bits(hex);
# versions = Vector{Int}();
# parse_packet!(bits, versions)

bits = parse_to_bits(readline("data/day16.txt")) # part 1 = 981; part 2 = 299227024091
versions = Vector{Int}()
parse_packet!(bits, versions)
sum(versions)