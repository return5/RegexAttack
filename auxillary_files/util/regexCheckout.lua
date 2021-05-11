--file which serves to check the regex pattern against the list of strings.
--import the posix regex version of lrex

local Reg = require('regexlib')

local lua_regex   = {}
local posix_regex = {}


local function checkRegex(regex,regex_obj,func)
    return func(regex_obj.str,regex) == regex_obj.match
end

function lua_regex.matchRegex(regex,regex_obj)
    return checkRegex(regex,regex_obj,string.match)
end

function posix_regex.matchRegex(regex,regex_obj)
   return checkRegex(regex,regex_obj,checkMatch)
end

if REGEX_CHOICE == 1 then
    return lua_regex
elseif REGEX_CHOICE == 2 then
    return posix_regex
end

