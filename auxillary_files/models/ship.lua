--file which contains methods to create and manipulate ship objects
local regex = require('auxillary_files/models/regexObjects')

SHIP = {x = 0, y = 0, img = "", thruster = "", regex_obj = "", prompt_width = 0}
SHIP.__index = SHIP

local function makeThruster(rand)
    return love.graphics.newImage('assets/graphics/thrusters/thruster_'..rand(1,4)..".png")
end

local function makeShipImage(rand)
    return love.graphics.newImage('assets/graphics/ships/ship_'..rand(1,4)..".png")
end

function SHIP:update(dt)
    self.x = self.x - CONSTANTS.SPEED * dt
end

function SHIP:draw()
    love.graphics.draw(self.img,self.x,self.y)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",self.x + CONSTANTS.SHIP_WIDTH / 2 - self.prompt_width / 2,self.y + CONSTANTS.SHIP_HEIGHT + 5,self.prompt_width,CONSTANTS.FONT_HEIGHT)
    love.graphics.setColor(0,0,0)
    love.graphics.print(self.regex_obj.prompt, self.x + CONSTANTS.SHIP_WIDTH / 2 - self.prompt_width / 2, self.y + CONSTANTS.SHIP_HEIGHT + 5)
    love.graphics.setColor(CONSTANTS.RED,CONSTANTS.GREEN,CONSTANTS.BLUE)
end

function SHIP:clear()
    self.img = nil
    self.thruster = nil
    self.regex_obj = nil
end

function SHIP:new(x,y,rand)
    local o     = setmetatable({},SHIP)
    o.x         = x
    o.y         = y
    o.regex_obj = getRegexObject(rand)
    o.thruster  = makeThruster(rand)
    o.img       = makeShipImage(rand)
    o.prompt_width = CONSTANTS.FONT:getWidth(o.regex_obj.prompt)
    return o
end

