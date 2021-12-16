
# hex2bytes (https://docs.julialang.org/en/v1/base/numbers/) makes assumptions of lengths
#
# string(n::Integer; base::Integer = 10, pad::Integer = 1)
#   Convert an integer n to a string in the given base, optionally specifying a number of digits to
#   pad to.
# string(5, base = 13, pad = 4)

# parse(Int, "A", base = 16)

hex2bin2string = function(hex, pad = 4)
    # parse string of hex into integer, then integer into padded string representation of binary
    string(parse(Int, hex, base = 16), base = 2, pad = pad)
end

parsedata = function(file)
    hexinput = readline(file)
    bininput = ""
    for c in hexinput
        bininput *= hex2bin2string(c)
    end
    return(bininput)
end

input = parsedata("data/day16.txt")

