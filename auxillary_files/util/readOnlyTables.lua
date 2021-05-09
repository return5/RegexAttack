--util class for making read only tables.

function readOnlyTable(t) 
    local proxy = {}
    setmetatable(proxy,{
        __index    = t,
        __newindex = function(t,k,v)
                    error("attempt to update read only table",2)
                end,
        __len = function() return #t end
        })
    return proxy
end
