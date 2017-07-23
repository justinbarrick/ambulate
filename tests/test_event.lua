luaunit = require("luaunit")
event = require("event")

function testListen()
    function cb(event_name)

    end

    function cb2(event_name)

    end

    ret = event.listen("test", cb)
    luaunit.assertEquals(ret, true)

    ret = event.listen("test", cb)
    luaunit.assertEquals(ret, false)

    ret = event.listen("test", cb2)
    luaunit.assertEquals(ret, true)

    ret = event.listen("lol", cb)
    luaunit.assertEquals(ret, true)
end

function testIgnore()
    function cb(event_name)

    end

    function cb2(event_name)

    end

    -- register cb2
    ret = event.listen("test", cb2)
    luaunit.assertEquals(ret, true)

    -- try to ignore an unregistered callback
    ret = event.ignore("test", cb)
    luaunit.assertEquals(ret, false)

    -- register cb
    ret = event.listen("test", cb)
    luaunit.assertEquals(ret, true)

    -- ignore a registered callback
    ret = event.ignore("test", cb)
    luaunit.assertEquals(ret, true)

    -- callback should already be ignored
    ret = event.ignore("test", cb)
    luaunit.assertEquals(ret, false)

    -- cb2 should also be able to be ignored now
    ret = event.ignore("test", cb2)
    luaunit.assertEquals(ret, true)
end

os.exit(luaunit.LuaUnit.run())
