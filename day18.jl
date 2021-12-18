explode = function(num)
    nest_level = 0
    idx = 0
    idxstart = 0
    idxend = 0
    while true
        idx += 1
        if idx > length(num)
            return (0, 0)
        end
        c = num[idx]
        if c == '['
            nest_level += 1
            if nest_level > 4
                # https://stackoverflow.com/questions/8742642/what-regex-string-will-find-the-last-rightmost-group-of-digits-in-a-string
                m = match(r"^(.*?)(\d+)(\D*)$", num[1:idx-1])
                if m  == nothing
                    prenum = -1
                else
                    prenum = parse(Int, m.captures[2]) # need indices, m.offsets[2] is location of first digit
                end
                m = match(r"^(\D*)(\d+)(.*?)$", num[idx+5:end])
                if m  == nothing
                    postnum = -1
                else
                    postnum = parse(Int, m.captures[2]) # need indices
                end
                return(idx, idx+4, num[idx:idx+4], parse(Int, num[idx+1]), parse(Int, num[idx+3]), prenum, postnum)
            end
        elseif c == ']'
            nest_level -= 1
        end
    end
end

# Explode
explode("[[[[[9,8],1],2],3],4]") # becomes [[[[0,9],2],3],4]
explode("[7,[6,[5,[4,[3,2]]]]]") # becomes [7,[6,[5,[7,0]]]]
explode("[[6,[5,[4,[3,2]]]],1]") # becomes [[6,[5,[7,0]]],3]
explode("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]") # becomes [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]
explode("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]") # becomes [[3,[2,[8,0]]],[9,[5,[7,0]]]]

