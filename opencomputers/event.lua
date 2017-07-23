local _M = {}

_M.callbacks = {}

function _M.listen(event, callback)
    if _M.callbacks[event] == nil then
        _M.callbacks[event] = {}
    end

    if _M.callbacks[event][callback] then
        return false
    else
        _M.callbacks[event][callback] = true
        return true
    end
end

function _M.ignore(event, callback)
    if _M.callbacks[event] == nil then
        return false
    end

    if _M.callbacks[event][callback] == nil then
        return false
    else
        _M.callbacks[event][callback] = nil
        return true
    end
end

function _M.timer(interval, callback, times)

end

function _M.cancel(timerId)

end

function _M.pull(timeout, name)

end

function _M.pullFiltered(timeout, filter)

end

function _M.pullMultiple()

end

function _M.onError(message)

end

function _M.push(name)

end

return _M
