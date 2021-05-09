--file which serves to check the regex pattern against the list of strings.
local lrex = require('rex_posix')

local lua_regex   = {}
local posix_regex = {}


local function checkRegex(regex,objects,func)
    for i=1,#objects,1 do
        if func(objects[i].str,regex) == objects[i].match then
            return i
        end
    end
    return false
end


function lua_regex.matchRegex(regex,objects)
    return checkRegex(regex,objects,string.match)
end


function posix_regex.matchRegex(regex,objects)
    return checkRegex(regex,objects,lrex.match)
end

if REGEX_CHOICE == 1 then
    return lua_regex
elseif REGEX_CHOICE == 2 then
    return posix_regex
end

