local io = require("io")
local os = require("os")
local _M = {}

function _M.open(path, mode)
    return io.open(path, mode)
end

function _M.remove(path)
    return os.remove(path)
end

return _M
