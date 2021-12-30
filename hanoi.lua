-- First app with Lua: The Towers of P.

local P = {} -- Our package

------- Main puzzle functions --------------------------------------

-- Initialise the three rods with a number of disks
--
function P.init(count)

    rods = { {}, {}, {} }
    for i = 1, count do
        table.insert( rods[1], i )
        table.insert( rods[2], 0 )
        table.insert( rods[3], 0 )
    end

    return rods
end

-- A string for one disc, on a rod of some max size.
--
function P.discToString(size, max)
    local width = max + ((max+1)%2)

    if size == 0 then
        return string.rep(" ", width)
    end

    local ender
    local ender_size

    if size % 2 == 0 then
        ender = ":"
        ender_size = 1
    else
        ender = ""
        ender_size = 0
    end
    local whole_count = size - ender_size
    local side_spaces = (width - whole_count - ender_size - ender_size) / 2

    return string.rep(" ", side_spaces) .. ender .. string.rep("=", whole_count) .. ender .. string.rep(" ", side_spaces)
end

-- One rod, represented as strings.
--
function P.rodToStrings(rod)
    local max = #rod

    local out = {}
    for i = 1, #rod do
        table.insert(out, P.discToString(rod[i], max))
    end

    -- Add the base, which will be the same size as the largest possible disc
    local largest = P.discToString(max, max)
    local base = string.rep("~", string.len(largest))
    table.insert(out, base)

    return out
end

-- Solve the Towers of Hanoi problem for num discs, going from rod src to rod dest.
--
local function solveWith(num, src, dest)
    if num == 1 then
        return { {src, dest} }
    else
        local other = 6 - src - dest

        local part1 = solveWith(num-1, src, other)
        local part2 = { {src,dest} }
        local part3 = solveWith(num-1, other, dest)

        return P.concat( part1, P.concat( part2, part3 ))
    end
end

-- Solve the Towers of Hanoi problem for num discs.
-- Returns a list of moves of the form { src_rod, dest_rod }.
--
function P.solve(num)
    return solveWith(num, 1, 3)
end

-- Given some rods, move the top disc from the src to the dest.
--
function P.move(rods, src, dest)
    -- Size of the disc
    local size

    -- Find and remove the disc
    local src_rod = rods[src]
    for i = 1,#src_rod do
        if src_rod[i] ~= 0 then
            size = src_rod[i]
            src_rod[i] = 0
            break
        end
    end

    -- Find the free slot on the dest rod
    local free_slot
    local dest_rod = rods[dest]
    for i = 1,#dest_rod do
        if dest_rod[i] == 0 then
            free_slot = i
        end
    end

    -- We should have the free slot... but will get nil if something's gone wrong.
    -- Insert the disc
    dest_rod[free_slot] = size

    return rods
end

-- Print all the rods for some move m.
--
local function printRods(m, rods)
    local move = { m }
    local rod1 = P.rodToStrings(rods[1])
    local rod2 = P.rodToStrings(rods[2])
    local rod3 = P.rodToStrings(rods[3])

    local rod23 = P.prefix( rod2, rod3 )
    local rod123 = P.prefix( rod1, rod23 )
    local move_rod123 = P.prefix( move, rod123 )

    for i = 1,#move_rod123 do
        print( move_rod123[i] )
    end
end

-- Print the solution for the Towers of Hanoi of size n.
--
function P.printSolution(n)
    -- Get the moves, as instructions
    local moves = P.solve(n)

    -- Use the moves on some actual rods
    local rods = P.init(n)
    printRods(0, rods)
    print()

    for i = 1,#moves do
        rods = P.move( rods, moves[i][1], moves[i][2] )
        printRods(i, rods)
        print()
    end
end

------- Utility functions ------------------------------------------

-- Prefix a main array of strings with another array of strings, separated by a space.
-- It will prefix and return all and only the main strings, so
-- extra prefixes will be ignored.
--
function P.prefix(pref, main)

    -- Work out how long the prefix strings should be
    local max_prefix = 0
    for i = 1, #pref do
        max_prefix = math.max( max_prefix, string.len(pref[i]) )
    end

    -- Prefix the main strings, with the prefixes
    local out = {}
    for i = 1, #main do
        local prefix_i = P.pad(pref[i], max_prefix)
        table.insert(out, prefix_i .. " " .. main[i])
    end

    return out
end

-- Pad a string with zero or more spaces, so it's at least as long as the given length.
--
function P.pad(str, len) 
    local str = str or ""
    local strlen = string.len(str)

    return str .. string.rep(" ", len - strlen)
end

-- Concatenate two sequences and return a new sequence.
--
function P.concat(a, b)
    local out = {}
    local len_a = #a

    for i = 1, len_a do
        out[i] = a[i]
    end

    for i = 1, #b do
        out[i+len_a] = b[i]
    end

    return out
end

return P
