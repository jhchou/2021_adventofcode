using AStarSearch # https://github.com/PaoloSarti/AStarSearch.jl

part2 = false # inserts 32103102 at rows 3 and 4

start = "9999999999912130320" # test, part 1 cost = 12521; part 2 cost = 44169
# start = "9999999999930223011" # input, cost = 19046; part 2 cost = ?
# start = "9999999999932012301" # jean


# Rules
# - Amber 1 energy per step; Bronze 10; Copper 100; Desert 1000
# - will never stop on the space immediately outside any room (positions 3,5,7,9 in row 1)
# - will never move into a room unless destination AND no amphipods there not their own destination
# - once stops in hallway, will stay until it can move into its room
#
# Input
#   #############
#   #...........#    --> hallway 11 columns
#   ###D#A#C#C###    --> positions 3, 5, 7, 9 -- off limits unless room valid to enter
#     #D#A#B#B#
#     #########
#
# String encoding: 11 characters of hallways followed by sets of 4 characters for rooms
# - Empty spaces '9'
# - Amphipods: A '0', B '1', C '2', D '3'
#   - energy = 10^type
#   - goal column for room = 2*type + 3
#
# Costs
# - ?for heuristic -- account for only movement in first row?
# - ?start room to hallway above start room: depends on input?
# - hallway above destination to goal room: 3 * (1 + 10 + 100 + 1000) = 3333


if part2
    start = start[1:15] * "32103102" * start[16:19]
end
roomrows = (length(start) - 11) ÷ 4
goalstate = "99999999999" * "0123"^roomrows # hallway 11x 9's, followed by roomrows repetitions of "0123"


# Build conversion dictionaries between idx and (row, col)
idx2rc = Dict{Integer, Tuple{Int64, Int64}}()
rc2idx = Dict{Tuple{Int64, Int64}, Integer}()
for idx in 1:(11 + 4*roomrows)
    if idx <= 11
        (row, col) = (1, idx)
    else
        row = (idx - 4) ÷ 4
        col = 2*((idx - 12) % 4) + 3 # 3,5,7,9
    end
    idx2rc[idx] = (row, col)
    rc2idx[row, col] = idx
    # println("$idx $row $col")
end


"Take state string and display graphic"
function printstate(state; showstring=false)
    roomrows = (length(state) - 11) ÷ 4
    x = replace(state, "9" => ".", "0" => "A", "1" => "B", "2" => "C", "3" => "D")
    if showstring println(state) end
    println("#############")
    println("#$(x[1:11])#")
    println("###$(x[12])#$(x[13])#$(x[14])#$(x[15])###")
    for i in 2:roomrows
        println("  #$(x[i*4 + 8])#$(x[i*4 + 9])#$(x[i*4 + 10])#$(x[i*4 + 11])#")
    end
    println("  #########")
    println()
end


"Heuristic function"
function h(state, goal)
    cost = 0
    for amphi in '0':'3'
        type = parse(Int, amphi)
        movecost = 10^type
        goalcol = 2*type + 3
        positions = findall(==(amphi), collect(state))
        for idx in positions
            (row, col) = idx2rc[idx]
            cost += abs(goalcol - col) * movecost
        end
    end
    return cost
end


"Cost between two states"
function statecost(state1, state2)
    # indices where two strings of same length differ: findall(==(true), collect(x) .!= collect(y))
    # assume valid move differing at only two swapped characters, one of which must be a '9'
    # assume row changes are always to or from hallway, not from room to room
    indices = findall(==(true), collect(state1) .!= collect(state2))
    if length(indices) == 0 return 0 end
    (idx1, idx2) = indices[1], indices[2]
    if state1[idx1] == '9'
        (idx1, idx2) = (idx2, idx1) # idx1 will be the starting locations; idx2 -> '9'
    end
    type = parse(Int, state1[idx1])
    (row1, col1) = idx2rc[idx1]
    (row2, col2) = idx2rc[idx2]
    # row calculation of cost does NOT take into account moving up then down
    cost = 10^type * (abs(row2 - row1) + abs(col2 - col1))
    return cost
end


"Swap characters at 2 indices"
function swapidx(state, idx1, idx2)
    x = collect(state)
    x[idx1], x[idx2] = x[idx2], x[idx1]
    return join(x)
end


"Find all valid neighbor states"
function findneighbors(state)
    # allow only start room to hallway, and hallway to destination room
    neighbors = String[]
    for idx in 1:19
        start = state[idx]
        if start == '9' continue end
        (row, col) = idx2rc[idx]
        type = parse(Int, start)
        goalcol = 2*type + 3
        if row == 1 # in hallway, only allowed to goal
            idx1 = min(col, goalcol)
            idx2 = max(col, goalcol)
            colsclear = all(==('9'), [state[i] for i in idx1:idx2 if i != col]) # so it doesn't block itself

            if !colsclear continue end # hallway not clear to goal
            if state[rc2idx[2, goalcol]] == '9' # top goal room clear
                if state[rc2idx[3, goalcol]] == '9'
                    # bottom goal room clear, so allow move to bottom room
                    push!(neighbors, swapidx(state, idx, rc2idx[3, goalcol]))
                elseif state[rc2idx[3, goalcol]] == start
                    # bottom goal room correct type, so allow move to top room
                    push!(neighbors, swapidx(state, idx, rc2idx[2, goalcol]))
                end
            end
        # the following is WRONG -- if starts in goal col but is blocking, needs to move out and then back in
        else # if col != goalcol # not hallway and not goal, so in starting room
            #   - row 2 or 3, and col 3,5,7,9
            # can move from room to hallway 1,2,4,6,8,10,11
            # can NOT move to hallway 3, 5, 7, 9
            if row == 2 || state[rc2idx[2, col]] == '9' # clear to enter hallway
                for destcol in [1,2,4,6,8,10,11]
                    if all(==('9'), state[min(col, destcol):max(col, destcol)])
                        push!(neighbors, swapidx(state, idx, rc2idx[1, destcol]))
                    end
                end
            end
        end
    end
    return neighbors
end



result = astar(findneighbors, start, goalstate, heuristic = h, cost = statecost)

result.status
result.closedsetsize
result.opensetsize
printstate.(result.path, showstring = false);
result.cost
