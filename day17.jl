
fireprobe = function(vx, vy, goalxmin, goalxmax, goalymin, goalymax)
    ymax = -Inf
    (xpos,ypos) = (0,0)
    reachtarget = false
    while true
        if xpos >= goalxmin && xpos <= goalxmax && ypos >= goalymin && ypos <= goalymax
            reachtarget = true
        end
        if (xpos > goalxmax) || (vx == 0 && ypos < goalymin)
            if !reachtarget
                ymax = -Inf
            end
            return (reachtarget, ymax)
        end
        xpos += vx
        ypos += vy
        if ypos > ymax
            ymax = ypos
        end
        vx -= 1
        if vx < 0 vx = 0 end
        vy -= 1
    end
end

# (vx, vy) = (6, 3)
# (vx, vy) = (9, 0)
# (vx, vy) = (17,-4)
# (vx, vy) = (6, 9)
# fireprobe(vx, vy, goalxmin, goalxmax, goalymin, goalymax)




# input = "target area: x=20..30, y=-10..-5"
input = "target area: x=111..161, y=-154..-101"
m = match(r"x=(.+)\.\.(.+), y=(.+)\.\.(.+)", input)
(goalxmin, goalxmax, goalymin, goalymax) = m.captures .|> x -> parse(Int, x)


# Determine maximum ranges of x velocity: vxmin to vxmax
vxmin = 1
while true # keep incrementing vxmin until able to reach goalxmin before stopping
    x = 0
    for vxstep in range(start = vxmin, stop = 0, step = -1)
        x += vxstep
    end
    if x >= goalxmin break end
    vxmin += 1
end
vxmax = goalxmax + 1

vymin = goalymin - 1 # any more negative and it will undershoot immediately
# not sure how to bound vymax
vymax = 1000

ymax = -Inf
success = Set{Tuple{Int, Int}}()
for vx0 in vxmin:vxmax
    for vy0 in vymin:vymax
        (reachtarget, y) = fireprobe(vx0, vy0, goalxmin, goalxmax, goalymin, goalymax)
        if reachtarget
            push!(success, (vx0, vy0))
            if y > ymax
                ymax = y
                println("$vx0 $vy0 $ymax")
            end
        end
    end
end

println(ymax) # 11781
println(length(success))
