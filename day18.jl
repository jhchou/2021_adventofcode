explodeonce = function(num)
    nest_level = 0
    idx = 0
    idxstart = 0
    idxend = 0
    while true
        idx += 1
        if idx > length(num)
            return (num) # nothing to explode
        end
        c = num[idx]
        if c == '['
            nest_level += 1
            if nest_level > 4
                m = match(r"^\[(\d+),(\d+)\]", num[idx:end]) # capture the first 4th nested pair
                num1 = parse(Int, m.captures[1])
                num2 = parse(Int, m.captures[2])
                chars = length(m.match) # length of the match, including brackets + comma

                # https://stackoverflow.com/questions/8742642/what-regex-string-will-find-the-last-rightmost-group-of-digits-in-a-string
                pre = num[1:idx-1]
                m = match(r"^(.*?)(\d+)(\D*)$", pre) # .*? is NON-greedy match
                if m  === nothing
                    prenum = -1
                    prenumidx = -1
                else
                    prenum = m.captures[2] # keep as string, will need length
                    prenumidx = m.offsets[2]
                    pre = pre[1:m.offsets[2] - 1] * string(parse(Int, prenum) + num1) * pre[m.offsets[2]+length(prenum):end]
                end
                post = num[idx+chars:end]
                m = match(r"^(\D*)(\d+)(.*?)$", post)
                if m  === nothing
                    postnum = -1
                    postnumidx = -1
                else
                    postnum = m.captures[2]
                    postnumidx = m.offsets[2]
                    post = post[1:postnumidx-1] * string(parse(Int, postnum) + num2) * post[postnumidx+length(postnum):end]
                end
                return(pre*'0'*post)
            end
        elseif c == ']'
            nest_level -= 1
        end
    end
end

explode = function(num)
    while true
        num2 = explodeonce(num)
        if num != num2
            num = num2
        else
            break
        end
    end
    return num
end

# Explode testing
explode("[[[[[9,8],1],2],3],4]") == "[[[[0,9],2],3],4]"
explode("[7,[6,[5,[4,[3,2]]]]]") == "[7,[6,[5,[7,0]]]]"
explode("[[6,[5,[4,[3,2]]]],1]") == "[[6,[5,[7,0]]],3]"
explode("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]") == "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"
explodeonce("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]") == "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"
explode("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]") == "[[3,[2,[8,0]]],[9,[5,[7,0]]]]"


splitpair = function(num)
    m = match(r"(\d{2,})", num) # left-most 2 or more digits
    if m === nothing
        return num
    end
    idx = m.offset
    n = parse(Int, m.captures[1])
    pre = num[1:idx-1]
    post = num[idx + length(m.captures[1]):end]
    return pre * '[' * string(Int(floor(n/2))) * ',' * string(Int(ceil(n/2))) * ']' * post
end


