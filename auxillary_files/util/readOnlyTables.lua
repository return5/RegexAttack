--util class for making read only tables.

function readOnlyTable(t) 
    return setmetatable({},{
        __index    = t,
        __newindex = function(t,k,v)
                    error("attempt to update read only table",2)
                end,
        __metatable = false
        })
end
