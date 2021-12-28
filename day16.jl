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

parse_packet! = function(bits, versions)
    version = pop_bits!(bits, 3)
    type = pop_bits!(bits, 3)
    push!(versions, version)
    if type == 4 # literal value
        len = 0
        num = false
        while true
            len += 5
            v = pop_bits!(bits, 5)
            num = (num << 4) | (v & 15)
            if v < 16 break end
        end
        # padlength = (4 - (6 + len) % 4) % 4
        # pop_bits!(bits, padlength)
        println("Literal $num")
        return(num)
    else
        lengthtypeid = pop_bits!(bits, 1)
        if lengthtypeid == 0
            totallength = pop_bits!(bits, 15)
            println("Total length $totallength")
            repeatuntil = length(bits) - totallength
            while length(bits) > repeatuntil
                parse_packet!(bits, versions)
            end
        elseif lengthtypeid == 1
            numsubpackets = pop_bits!(bits, 11)
            println("Num subpackets $numsubpackets")
            for i = 1:numsubpackets
                parse_packet!(bits, versions)
            end
        else
            # ?!?
        end
    end
end

# hex = "D2FE28"
# hex = "8A004A801A8002F478"
# hex = "620080001611562C8802118E34"
# hex = "38006F45291200"
# hex = "EE00D40C823060"
# bits = parse_to_bits(hex)

bits = parse_to_bits(readline("data/day16.txt")) # part 1 = 981
versions = Vector{Int}()
parse_packet!(bits, versions)
sum(versions)