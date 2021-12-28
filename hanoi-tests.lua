-- Example unit tests

lu = require('luaunit')
hanoi = require('hanoi')

TestOfAdding = {} -- class

function TestOfAdding:testWithZero()
    lu.assertEquals(0+3, 3, "zero and something")
    lu.assertEquals(2+0, 2, "something and zero")
end

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
        { "just oneapples",
          "        pears"
        }
    )
    lu.assertEquals( hanoi.prefix(two, one),
        { "applesjust one"
        }
    )
    lu.assertEquals( hanoi.prefix(three, three),
        { "xxxxxx",
          "yyyyyy",
          "z  z"
        }
    )
end

os.exit( lu.LuaUnit.run() )
