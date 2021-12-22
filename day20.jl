using DataStructures # for DefaultDict

parsedata = function(file)
    lines = readlines(file)
    for (idx, line) in enumerate(lines)
        lines[idx] = replace(line, '#'=>'1', '.'=>'0')
    end
    alg = lines[1]
    lines = lines[3:end]

    grid = DefaultDict{Tuple{Int, Int}, Char}('0')
    for (r, line) in enumerate(lines)
        for (c, char) in enumerate(line)
            # println("$r $c $char")
            grid[r, c] = char
        end
    end
    
    return(alg, grid)
end

process_point = function(grid, alg, row, col)
    neigh = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 0), (0, 1), (1, -1), (1, 0), (1, 1)]
    bin = ""
    for (Δr, Δc) in neigh
        bin *= grid[row + Δr, col + Δc]
    end
    return alg[parse(Int, bin, base = 2) + 1] # +1 because 0 is at index 1
end

process_step = function(grid, alg)
    rowidx = [r for (r, c) in keys(grid)]
    colidx = [c for (r, c) in keys(grid)]
    minrow = minimum(rowidx) - 1
    maxrow = maximum(rowidx) + 1
    mincol = minimum(colidx) - 1
    maxcol = maximum(colidx) + 1
    
    grid2 = DefaultDict{Tuple{Int, Int}, Char}('0')
    for r in minrow:maxrow, c in mincol:maxcol
        grid2[r, c] = process_point(grid, alg, r, c)
    end
    return grid2
end


printgrid = function(grid)
    rowidx = [r for (r, c) in keys(grid)]
    colidx = [c for (r, c) in keys(grid)]
    minrow = minimum(rowidx)
    maxrow = maximum(rowidx)
    mincol = minimum(colidx)
    maxcol = maximum(colidx)
    arr = fill('0', (maxrow - minrow + 1,maxcol - mincol + 1))
    rowinc = 1 - minrow
    colinc = 1 - mincol
    for r in minrow:maxrow, c in mincol:maxcol
        arr[r + rowinc, c + colinc] = grid[r, c]
    end
    for y in 1:size(arr)[1]
        # replace(line, '#'=>'1', '.'=>'0')
        println( replace(join(arr[y,:]), '1'=>'#', '0'=>'.') )
    end
end



file = "data/day20_test.txt"
# file = "data/day20.txt"

(alg, grid) = parsedata(file)

for step in 1:2
    grid = process_step(grid, alg)
end
numlit = count(==('1'), values(grid)) # 4955

for step in 1:48
    grid = process_step(grid, alg)
end
numlit = count(==('1'), values(grid)) # 4955


# grid = process_step(grid, alg)
# printgrid(grid)
# numlit = count(==('1'), values(grid)) # 5357

# grid = process_step(grid, alg)
# printgrid(grid)
# numlit = count(==('1'), values(grid)) # 5503, NOT 5573

# # part 2: 19156