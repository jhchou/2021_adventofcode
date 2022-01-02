########## Part 1 ##########

pos = [4, 8] # test: part 1 = 739785; part 2 = player 1 444356092776315 and player 2 341960390180808
# pos = [4, 1] # input: part 1 = 913560; part 2 = player 1 95150439448698 and player 2 110271560863819

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

function playturn(player2::Bool, pos, scores, roll, numways)
    # player2 = whether it's player 2's turn
    # pos = positions of player 1 and player 2
    # scores = score thus far for player 1 and player 2
    # roll = the next roll
    # numways = number of ways to have gotten to this situation
    dicerolls = Dict(3=>1, 4=>3, 5=>6, 6=>7, 7=>6, 8=>3, 9=>1) # number of ways to achieve dice rolls
    idx = player2 + 1
    pos[idx] = (pos[idx] + roll) % 10
    if pos[idx] == 0 pos[idx] = 10 end
    scores[idx] += pos[idx]
    if scores[idx] >= 21
        wins[idx] += numways * dicerolls[roll]
        return
    else
        player2 = !player2
        for nextroll in 3:9
            # can NOT pass in original array, because they are mutable
            playturn(player2, copy(pos), copy(scores), nextroll, numways * dicerolls[roll])
        end
    end
end

# pos = [4, 8] # test: part 1 = 739785; part 2 = player 1 444356092776315 and player 2 341960390180808
pos = [4, 1] # input: part 1 = 913560; part 2 = player 1 95150439448698 and player 2 110271560863819

wins = [0, 0] # number of wins for player 1 and player 2
for roll in 3:9
    playturn(false, copy(pos), [0, 0], roll, 1) # can NOT pass in array, because it's mutable
end
maximum(wins)
