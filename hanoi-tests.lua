-- Example unit tests
-- One new branch commit

lu = require('luaunit')
hanoi = require('hanoi')

--------------------------------------------------------------------

TestPuzzle = {} -- class

function TestPuzzle:testInit()
    lu.assertEquals( hanoi.init(3), {{ 1,2,3 }, { 0,0,0 }, { 0,0,0 }} )
    lu.assertEquals( hanoi.init(4), {{ 1,2,3,4 }, { 0,0,0,0 }, { 0,0,0,0 }} )
end

function TestPuzzle:testRodToStrings()
    -- An odd number of spaces for discs (5)
    lu.assertEquals( hanoi.rodToStrings({ 0,0,0,2,3 }),
        { "     "
        , "     "
        , "     "
        , " :=: "
        , " === "
        , "~~~~~"
        }
    )

    -- An even number of spaces for discs (4)
    lu.assertEquals( hanoi.rodToStrings({ 0,0,2,3 }),
        { "     "
        , "     "
        , " :=: "
        , " === "
        , "~~~~~"
        }
    )

    -- A range of numbers
    lu.assertEquals( hanoi.rodToStrings({ 0,1,2,3,5,6 }),
        { "       "
        , "   =   "
        , "  :=:  "
        , "  ===  "
        , " ===== "
        , ":=====:"
        , "~~~~~~~"
        }
    )
end

function TestPuzzle:testDiscToString()
    lu.assertEquals( hanoi.discToString(0,1), " ")
    lu.assertEquals( hanoi.discToString(1,1), "=")

    lu.assertEquals( hanoi.discToString(0,2), "   ")
    lu.assertEquals( hanoi.discToString(1,2), " = ")
    lu.assertEquals( hanoi.discToString(2,2), ":=:")

    lu.assertEquals( hanoi.discToString(0,3), "   ")
    lu.assertEquals( hanoi.discToString(1,3), " = ")
    lu.assertEquals( hanoi.discToString(2,3), ":=:")
    lu.assertEquals( hanoi.discToString(3,3), "===")

    lu.assertEquals( hanoi.discToString(0,4), "     ")
    lu.assertEquals( hanoi.discToString(1,4), "  =  ")
    lu.assertEquals( hanoi.discToString(2,4), " :=: ")
    lu.assertEquals( hanoi.discToString(3,4), " === ")
    lu.assertEquals( hanoi.discToString(4,4), ":===:")
end

function TestPuzzle:testSolve()
    -- Solve the problem for 1 disc
    lu.assertEquals( hanoi.solve(1),
        { {1,3} }
    )

    -- Solve the problem for 2 discs
    lu.assertEquals( hanoi.solve(2),
        { {1,2}
        , {1,3}
        , {2,3}
        }
    )

    -- Solve the problem for 3 discs
    lu.assertEquals( hanoi.solve(3),
        -- Solve 2 discs from 1 to 2
        { {1,3}
        , {1,2}
        , {3,2}
        -- Solve 1 disc from 1 to 3
        , {1,3}
        -- Solve 2 discs from 2 to 3
        , {2,1}
        , {2,3}
        , {1,3}
        }
    )

end

function TestPuzzle:testMove(rods, src, dest)
    lu.assertEquals( hanoi.move( {{0,1,2,3},{0,0,0,4},{0,0,0,0}}, 1, 2 ), {{0,0,2,3},{0,0,1,4},{0,0,0,0}} )
    lu.assertEquals( hanoi.move( {{0,1,2,3},{0,0,0,4},{0,0,0,0}}, 1, 3 ), {{0,0,2,3},{0,0,0,4},{0,0,0,1}} )
    lu.assertEquals( hanoi.move( {{0,1,2,3},{0,0,0,4},{0,0,0,0}}, 2, 3 ), {{0,1,2,3},{0,0,0,0},{0,0,0,4}} )
end

--------------------------------------------------------------------

TestUtils = {} -- class

function TestUtils:testPad()
    lu.assertEquals( hanoi.pad("Hello", 4), "Hello")
    lu.assertEquals( hanoi.pad("Hello", 5), "Hello")
    lu.assertEquals( hanoi.pad("Hello", 6), "Hello ")
    lu.assertEquals( hanoi.pad("Hello", 7), "Hello  ")

    lu.assertEquals( hanoi.pad(nil, 3), "   ")
end

function TestUtils:testPrefix()
    local one = {"just one"}
    local two = {"apples", "pears"}
    local three = {"xxx", "yyy", "z"}

    lu.assertEquals( hanoi.prefix(one, two),
        { "just one apples",
          "         pears"
        }
    )
    lu.assertEquals( hanoi.prefix(two, one),
        { "apples just one"
        }
    )
    lu.assertEquals( hanoi.prefix(three, three),
        { "xxx xxx",
          "yyy yyy",
          "z   z"
        }
    )
end

function TestUtils:testConcat()
    lu.assertEquals( hanoi.concat({4,5}, {6,7}), {4,5,6,7} )
    lu.assertEquals( hanoi.concat({}, {6,7}), {6,7} )
    lu.assertEquals( hanoi.concat({4,5}, {}), {4,5} )
end

os.exit( lu.LuaUnit.run() )
