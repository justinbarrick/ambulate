require("socket")
local https = require("ssl.https")
local ltn12 = require("ltn12")

local _M = {}

function _M.request(url, data, headers)
    if url:find("^https://raw.github.*build/oppm.cfg$") then
        local oppm_cfg = io.open("build/oppm.cfg")
        return function ()
            local data = oppm_cfg:read("*a")
            if data ~= "" then
                return data
            else
                return nil
            end
        end
    end

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
