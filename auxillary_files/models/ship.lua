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
    --draw the ship
    love.graphics.draw(self.img,self.x,self.y)

    --set color to white
    love.graphics.setColor(1,1,1)

    --draw a white rectangle below the ship. center of rectange is lined up with center of ship
    love.graphics.rectangle("fill",self.x + (CONSTANTS.SHIP_WIDTH / 2 - self.prompt_width / 2) - 3,self.y + CONSTANTS.SHIP_HEIGHT + 5,self.prompt_width,CONSTANTS.FONT_HEIGHT)
    
    --set color to black
    love.graphics.setColor(0,0,0)
    --
    --print prompt for ship inside of rectangle
    love.graphics.print(self.regex_obj.prompt, self.x + CONSTANTS.SHIP_WIDTH / 2 - self.prompt_width / 2, self.y + CONSTANTS.SHIP_HEIGHT + 5)

    --return color to default values
    love.graphics.setColor(CONSTANTS.RED,CONSTANTS.GREEN,CONSTANTS.BLUE)

    --draw thruster
    love.graphics.draw(self.thruster,self.x + CONSTANTS.SHIP_WIDTH - 4,self.y + 15)
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
    o.prompt_width = CONSTANTS.FONT:getWidth(o.regex_obj.prompt) + 6
    return o
end

