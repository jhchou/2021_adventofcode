struct Packet
    version::Int
    typeid::Int
    packetlength::Int
    literal::Int
end

file = "data/day16.txt"

input = join(readline(file) |> collect .|> x -> string(parse(Int, x, base = 16), base = 2, pad = 4))

hex = "8A004A801A8002F478"
hex = "620080001611562C8802118E34"
input = join(hex |> collect .|> x -> string(parse(Int, x, base = 16), base = 2, pad = 4))

input = "110100101111111000101000"
input = "00111000000000000110111101000101001010010001001000000000"
idx = 1


parsepacket = function(input, idx)
    version = parse(Int, input[idx:idx+2], base = 2)
    typeid = parse(Int, input[idx+3:idx+5], base = 2)
    idx += 6
    if typeid == 4
        literal = ""
        while true
            literal *= input[idx+1:idx+4]
            idx += 5
            if input[idx-5] == '0' break end
        end
        literalval = parse(Int, literal, base = 2)
        padlength = (4 - (6 + 5*(length(literal) ÷ 4)) % 4) % 4 # ranges from 0 to 3
        idx += padlength
        # return(version, (6 + 5*(length(literal) ÷ 4)) + padlength)
        return version
    else # typeid != 4 --> operator packet
        lengthtypeid = input[idx]
        idx += 1
        if lengthtypeid == '0'
            # next 15 bits are a number that represents the total length in bits of the sub-packets contained by this packet
            totallength = parse(Int, input[idx:idx+14], base = 2)
            idx += 15
            return version + parsepacket(input[idx:idx+totallength-1], 1)
        else # lengthtypeid == '1'
            # next 11 bits are a number that represents the number of sub-packets immediately contained by this packet
            numsubpackets = parse(Int, input[idx:idx+10], base = 2)
            idx += 11
            for i in 1:numsubpackets
                println(i)
                version += parsepacket(input[idx:end], 1)
            end
            return version
        end
    end
end




# Obtain packet header
m = match(r"^(.{3})(.{3})", input[idx:end])
version = parse(Int, m.captures[1], base = 2)
typeid = parse(Int, m.captures[2], base = 2)

idx += 6 # advance past packet header: version and type ID

# type ID 4 represent a literal value
# - binary number is padded with leading zeroes until its length is a multiple of four bits
# - broken into groups of four bits
# - each group is prefixed by a 1 bit except the last group, which is prefixed by a 0 bit
# - these groups of five bits immediately follow the packet header
if typeid == 4
    # (1.{4})* -- for variable number of initial groups; all together in capture group 1
    # (0.{4})  -- for final group # in capture group 3
    # - there will be unmatched trailing 0's for padding
    # - group 1: entire match, without trailing padding, but without 6 bits of version and typeid
    # - group 2: all initial groups
    # - (discard group 3: last of initial groups)
    # - group 4: final group
    # remainder == initial * final * repeat('0', padlength)

    literal = ""
    while true
        # println(input[idx+1:idx+4])
        literal *= input[idx+1:idx+4]
        idx += 5
        if input[idx-5] == '0' break end
    end
    literalval = parse(Int, literal, base = 2)
    padlength = (4 - (6 + 5*(length(literal) ÷ 4)) % 4) % 4 # ranges from 0 to 3
    idx += padlength
    println(literalval)
else # typeid != 4 --> operator packet
    lengthtypeid = input[idx]
    idx += 1
    if lengthtypeid == '0'
        # next 15 bits are a number that represents the total length in bits of the sub-packets contained by this packet
        totallength = parse(Int, input[idx:idx+14], base = 2)
        println("totallength = $totallength")
        idx += 15
    else # lengthtypeid == '1'
        # next 11 bits are a number that represents the number of sub-packets immediately contained by this packet
        numsubpackets = parse(Int, input[idx:idx+10], base = 2)
        println("numsubpackets = $numsubpackets")
        idx += 11
    end
end
