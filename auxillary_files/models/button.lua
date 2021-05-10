local Readonly = require('auxillary_files/util/readOnlyTables') 

BUTTON = {x = 0, y = 0, text = "", height = 0, width = 0 }
BUTTON.__index = BUTTON

function BUTTON:draw()
    love.graphics.setColor(.01,.2,.5)
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
    love.graphics.setColor(CONSTANTS.RED,CONSTANTS.GREEN,CONSTANTS.BLUE)
    love.graphics.print(self.text,self.x + (self.width / 2) - (CONSTANTS.FONT:getWidth(self.text) / 2),self.y + (self.height / 2) - CONSTANTS.FONT_HALF_H)
end


function onClick(buttons)
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    for i=#buttons,1,-1 do
        if x >= buttons[i].x and x <= buttons[i].x + buttons[i].width then
            if y >= buttons[i].y and y <= buttons[i].y + buttons[i].height then
                buttons[i]:onClick()
                return i
            end
        end
    end
    return false
end

function BUTTON:new(x,y,text,width,height,onclick)
    local o   = setmetatable({},BUTTON)
    o.x       = x
    o.y       = y
    o.text    = text
    o.width   = width
    o.height  = height
    o.onClick = onclick
    return o
end

