local readOnly = require('/auxillary_files/util/readOnlyTables')



REGEX_OBJECT = {prompt="",str="",match=""}
REGEX_OBJECT.__index = REGEX_OBJECT

local file_table = {}

function initFileTable()
    local t        = {}
    local file     = io.open("assets/regex_prompts/prompts.txt","r")
    local file_str = file:read("*a")
    local add      = table.insert
    for prompt,str,match in file_str:gmatch("([^,\n]+),([^,\n]+),([^,\n]+)\n") do
        add(t,REGEX_OBJECT:new(prompt,str,match))
    end
    file_table = readOnlyTable(t)
end

function getRegexObject(rand) 
    return file_table[rand(1,file_table.len)]
end

function REGEX_OBJECT:new(prompt,str,match)
    local o  = setmetatable({},REGEX_OBJECT)
    o.prompt = prompt
    o.str    = str
    o.match  = match
    return readOnlyTable(o)
end

