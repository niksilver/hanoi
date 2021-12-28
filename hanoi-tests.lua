-- Example unit tests

lu = require('luaunit')

TestOfAdding = {} -- class

function TestOfAdding:testWithZero()
    lu.assertEquals(0+3, 3, "zero and something")
    lu.assertEquals(2+0, 2, "something and zero")
end

os.exit( lu.LuaUnit.run() )
