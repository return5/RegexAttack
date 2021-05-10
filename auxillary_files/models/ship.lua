--file which contains methods to create and manipulate ship objects
local regex = require('auxillary_files/models/regexObjects')

SHIP = {x = 0, y = 0, img = "", thruster = "", regex_obj = ""}
SHIP.__index = SHIP


local function makeThruster(rand)
    return love.graphics.newImage('assets/graphics/thrusters/thruster_'..rand(1,4))
end

local function makeShipImage(rand)
    return love.graphics.newImage('assets/graphics/ships/ship_'..rand(1,4))
end

function SHIP:new(x,y,rand)
    local o     = setmetatable({},SHIP)
    o.x         = x
    o.y         = y
    o.regex_obj = makeRegexObject(rand)
    o.thruster  = makeThruster(rand)
    o.img       = makeShipImage(rand)
    return o
end

function makeShipArray(rand)
    local ships = {}
    for i=1,CONSTANS.SHIP_LIMIT,1 do
        ships[#ships + 1] = SHIP:new(CONSTANTS.WIDHT,i + CONSTANTS.SHIP_HEIGHT + CONSTANTS.OFFSET,rand)
    end
    return ships
end

