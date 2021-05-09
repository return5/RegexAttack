local readOnly = require('/auxillary_files/util/readOnlyTables')



REGEX_OBJECT = {prompt="",str="",match=""}
REGEX_OBJECT.__index = REGEX_OBJECT

local num_ships  = 3
file_table = {}

function makeMatches()
    local rand = math.random
    local file = ""
    
end

local function initFileTable(file_name)
    local t        = {}
    local file     = io.open("assets/regex_prompts/"..file_name,"r")
    local file_str = file:read("*a")
    local add      = table.insert
    for prompt,str,match in file_str:gmatch("([^,\n]+),([^,\n]+),([^,\n]+)\n") do
        add(t,REGEX_OBJECT:new(prompt,str,match))
    end
    file_table = readOnlyTable(t)
end

function initObjects()
    local file = ""
    if DIFFICULTY == "easy" then
        file = "easy.txt"
    elseif DIFFICULTY == "medium" then
        file = "medium.txt"
    elseif DIFFICULTY == "tought" then
        file = "tough.txt"
    end
    initFileTable(file)
end

function REGEX_OBJECT:new(prompt,str,match)
    local o  = setmetatable({},REGEX_OBJECT)
    o.prompt = prompt
    o.str    = str
    o.match  = match
    return readOnlyTable(o)
end

