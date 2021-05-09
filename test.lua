local models = require('auxillary_files/models/regexObjects')
REGEX_CHOICE = 1
local regex  = require('auxillary_files/util/regexCheckout')

DIFFICULTY = "easy"

initObjects()

local regex_obj = {{regex_obj = file_table[4]}}

local results = regex.matchRegex("%d+h",regex_obj)
if results then
    io.write("results is: ",results,"\n")
end

if results == false then
    io.write("false\n")
end


local r = string.match(regex_obj[1].regex_obj.str,"%d+h")
--io.write("match is: ",r,"\n")


