luaunit = require("luaunit")
internet = require("internet")

function testInternet()
    local response = ""
    for chunk in internet.request("https://example.com/") do
        response = response .. chunk
    end
    luaunit.assertStrContains(response, "Example Domain")
end

os.exit(luaunit.LuaUnit.run())
