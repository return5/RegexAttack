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

function SHIP:update(dt)
    this.x = this.x + CONSTANTS.SPEED * dt
end

function SHIP:draw()
    local len = this.regex_obj.prompt:len()
    love.graphics.draw(this.img)
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill",this.x - len //2,this.y + CONSTANTS.SHIP_HEIGHT + 5,len,5)
    love.grpahics.setColor(CONSTANTS.COLOR)
    love.graphics.draw(this.regex_obj.prompt, this.x - len //2, this.y + CONSTANTS.SHIP_HEIGHT + 5)
end

function SHIP:clear()
    this.img = nil
    this.thruster = nil
    this.regex_obj = nil
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

