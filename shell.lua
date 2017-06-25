local os = require("os")

local _M = {}

function _M.execute(cmd)
    return os.execute(cmd)
end

return _M
