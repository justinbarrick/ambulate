local os = require("os")

local _M = {}

function _M.execute(cmd)
    if cmd:find("^oppm ")then
        require("oppm")
    else
        return os.execute(cmd)
    end
end

return _M
