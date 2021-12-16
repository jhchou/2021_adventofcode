file = "data/day16.txt"

# input = [ string(parse(Int, c, base = 16), base = 2, pad = 4) for c in readline(file) ] |> join
input = join(readline(file) |> collect .|> x -> string(parse(Int, x, base = 16), base = 2, pad = 4))

input = "110100101111111000101000"
reg = r"^(.{3})(.{3})(.*)"
m = match(reg, input)
version = parse(Int, m.captures[1], base = 2)
typeid = parse(Int, m.captures[2], base = 2)
remainder = m.captures[3]


println("Version: $version; type ID: $typeid; remainder: $remainder")

# type ID 4 represent a literal value
# - binary number is padded with leading zeroes until its length is a multiple of four bits
# - broken into groups of four bits
# - each group is prefixed by a 1 bit except the last group, which is prefixed by a 0 bit
# - these groups of five bits immediately follow the packet header.

remainder = "1000010111111101111100101000"

if typeid == 4
    # (1.{4})* -- for variable number of initial groups; all together in capture group 1
    # (0.{4})  -- for final group # in capture group 3
    # - there will be unmatched trailing 0's for padding
    # - group 1: entire match, without trailing padding
    # - group 2: all initial groups
    # - (discard group 3: last of initial groups)
    # - group 4: final group
    # remainder == initial * final * repeat('0', padlength)
    m = match(r"^(((1.{4})*)(0.{4}))", remainder)
    padlength = (4 - (length(m.captures[1]) % 4)) % 4 # ranges from 0 to 3
    initial = m.captures[2]
    final = m.captures[4]
end

