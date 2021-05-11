--util class for making read only tables.

function readOnlyTable(t) 
    local proxy = {}
    proxy.len = #t
    setmetatable(proxy,{
        __index    = t,
        __newindex = function(t,k,v)
                    error("attempt to update read only table",2)
                end,
        __metatable = false
        })
    return proxy
end
