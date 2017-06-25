local https = require("socket.http")
local ltn12 = require("ltn12")

local _M = {}

function _M.request(url, data, headers)
    local resp = {}

    local method = "GET"
    if data then
        method = "POST"
    end

    local body, code, headers, status = https.request{
        url=url,
        sink=ltn12.sink.table(resp),
        method=method,
        headers=headers,
        data=data,
    }

    local index = 0
    return function ()
        index = index + 1
        return resp[index]
    end
end

return _M
