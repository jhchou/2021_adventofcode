pos = [4, 8] # test: part 1 = 739785; part 2 = 444356092776315
# pos = [4, 1] # input: part 1 = 913560; part 2 = 

die = 1 # current die
playerturn = 1 # current turn
score = [0, 0]

totalrolls = 0 # number of times die rolled
while true
    dietotal = 0
    for i in 1:3
        dietotal += die
        totalrolls += 1
        die += 1
        if die > 100 die -= 100 end
    end

    pos[playerturn] = (pos[playerturn] + dietotal) % 10
    if pos[playerturn] == 0 pos[playerturn] = 10 end
    score[playerturn] += pos[playerturn]

    if score[playerturn] >= 1000
        println("Part 1: $(totalrolls * minimum(score))")
        break
    end

    playerturn += 1
    if playerturn > 2 playerturn = 1 end
end


########## Part 2 ##########

# Find counts of possible sums of 3 die
# sum3 = Iterators.product(1:3, 1:3, 1:3) .|> sum
# sumcounts = Dict{Int, Int}() # key = total of 3 die; value = count of ways to achieve
# for sum in unique(sum3)
#     sumcounts[sum] = count(==(sum), sum3)
# end
# sumcounts
# From a given starting position, find counts of possible ending positions after sum of 3 dies
# - generates tuple with key = starting position
# - value is another Dict with key = ending position and value = # of ways to achieve that ending position
# allposcounts = Dict{Int, Dict{Int, Int}}()
# for pos in 1:10
#     poscounts = Dict{Int, Int}() # key = final position; value = count of ways to achieve
#     for (k,v) in sumcounts
#         pos2 = (pos + k) % 10
#         if pos2 == 0 pos2 = 10 end
#         poscounts[pos2] = v
#     end
#     allposcounts[pos] = poscounts
# end
# allposcounts


using DataStructures # for DefaultDict

# From starting at pos, number of ways to end relative to pos = [0, 0, 0, 1, 3, 6, 7, 6, 3, 1]
# - i.e., never possible to end at pos, pos+1, or pos+2, but 3 ways to end at pos+4, etc.

# Counts of possible dice rolls:
# dicerolls = Dict(3=>1, 4=>3, 5=>6, 6=>7, 7=>6, 8=>3, 9=>1)

applyrolls = function(p)
    dicerolls = Dict(3=>1, 4=>3, 5=>6, 6=>7, 7=>6, 8=>3, 9=>1) # Counts of possible dice rolls:
    p1new = DefaultDict{Tuple{Int, Int}, Int}(1) # will hold updated player 1 multiverse status, after dicerolls
    for (roll, count) in dicerolls
        for ((pos, score), num) in player1
            newpos = (pos + roll) % 10
            if newpos == 0 newpos = 10 end
            newscore = score + newpos
            p1new[newpos, newscore] *= num * count
        end
    end
    for ((pos, score), num) in p1new
        if score >= 21
            println("$num with score $score at position $pos")
            delete!(p1new, (pos, score))
        end
    end
    return(p1new)
end

player1 = DefaultDict{Tuple{Int, Int}, Int}(1) # key = (position, score); value = counts
player1[1, 0] = 1 # start player at position 4 with 0 score; count is 1

player1 = applyrolls(player1); player1

