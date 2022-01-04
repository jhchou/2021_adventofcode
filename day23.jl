using AStarSearch # https://github.com/PaoloSarti/AStarSearch.jl

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


function day23(input; part2=false)
    # part2 = true # inserts 32103102 at rows 3 and 4
    start = input
    if part2
        start = start[1:15] * "32103102" * start[16:19]
    end
    roomrows = (length(start) - 11) ÷ 4
    goalstate = "99999999999" * "0123"^roomrows # hallway 11x 9's, followed by roomrows repetitions of "0123"

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

    
    "Heuristic function"
    function h(state, goal)
        # optimistic minimum cost of movement, NOT taking into account blockages OR between rows
        # - don't want to include row movement, because can conceivably start in correct position and never move
        cost = 0
        for amphi in '0':'3'
            type = parse(Int, amphi)
            movecost = 10^type
            goalcol = 2*type + 3
            positions = findall(==(amphi), collect(state))
            for idx in positions
                (row, col) = idx2rc[idx]
                cost += (abs(goalcol - col)) * movecost
            end
        end
        return cost
    end
    
    
    "Cost between two states"
    function statecost(state1, state2)
        # indices where two strings of same length differ: findall(==(true), collect(x) .!= collect(y))
        # assume valid move differing at only two swapped characters, one of which must be a '9'
        # assume row changes are always to or from hallway, not from room to room
        # row calculation of cost DO NOT take into account moving up then down, so disallow
        indices = findall(==(true), collect(state1) .!= collect(state2))
        if length(indices) == 0 return 0 end # in case receive the same state, there will be no differences
        (idx1, idx2) = indices[1], indices[2]
        if state1[idx1] == '9'
            (idx1, idx2) = (idx2, idx1) # idx1 will be the starting locations; idx2 -> '9'
        end
        type = parse(Int, state1[idx1])
        (row1, col1) = idx2rc[idx1]
        (row2, col2) = idx2rc[idx2]
        cost = 10^type * (abs(row2 - row1) + abs(col2 - col1))
        return cost
    end
    
    
    "Swap characters at 2 indices"
    function swapidx(state, idx1, idx2)
        x = collect(state)
        x[idx1], x[idx2] = x[idx2], x[idx1]
        return join(x)
    end
    
    
    "Find all valid neighbor states possible by moving from index spot"
    function findneighbors(state, idx)
        # allow only start room to hallway, and hallway to destination room
        neighbors = String[]
        startchar = state[idx]
        if startchar == '9' return neighbors end # empty space, nothing to move
        (row, col) = idx2rc[idx]
        type = parse(Int, startchar)
        goalcol = 2*type + 3
        roomrows = (length(state) - 11) ÷ 4
    
        if row == 1 # in hallway, only allowed to goal column room
            idx1 = min(col, goalcol)
            idx2 = max(col, goalcol)
            colsclear = all(==('9'), [state[i] for i in idx1:idx2 if i != col]) # so it doesn't block itself
    
            if !colsclear return neighbors end # hallway not clear to goal
    
            # Require: 2:(roomrows+1), goalcol are all either '9' or startchar (matching type)
            if !all(c -> c in ['9', startchar], [state[rc2idx[r, goalcol]] for r in 2:(roomrows+1)])
                return neighbors
            end
            # Allow movement into all goal column rooms
            # - ?a bit inefficient, as allowing to move into "top" room, even when lower rooms are empty
            for r in 2:(roomrows+1)
                if state[rc2idx[r, goalcol]] != '9' break end
                push!(neighbors, swapidx(state, idx, rc2idx[r, goalcol]))
            end
    
        
        # NOT in hallway, in one of the rooms
        # MUST allow starting in goal column AND moving out to hallway, in case blocking
        else # row != 1, and col 3,5,7,9
            # check to see if clear to enter hallway
            if row == 2 || (all(==('9'), [state[rc2idx[i, col]] for i in 2:(row-1)]))
                for destcol in [1, 2, 4, 6, 8, 10, 11] # permissible hallway columns
                    if all(==('9'), state[min(col, destcol):max(col, destcol)])
                        push!(neighbors, swapidx(state, idx, rc2idx[1, destcol]))
                    end
                end
            end
        end
        return neighbors
    end
    
    
    "Find all valid neighbor states from a given state"
    function findallneighbors(state)
        neighbors = String[]
        for idx in 1:length(state)
            neighbors = [neighbors; findneighbors(state, idx)]
        end
        return neighbors
    end

    result =  astar(findallneighbors, start, goalstate, heuristic = h, cost = statecost);
    return result
end

# input = "9999999999912130320" # test, part 1 cost = 12521; part 2 cost = 44169
input = "9999999999930223011" # input, cost = 19046; part 2 cost = 47484
# input = "9999999999932012301" # jean

result = day23(input);
println("Part 1: cost = $(result.cost)") # part 1

result = day23(input, part2=true);
# result.status
# result.closedsetsize
# result.opensetsize
# printstate.(result.path, showstring = false);
println("Part 2: cost = $(result.cost)") # part 2
