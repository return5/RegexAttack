
function love.draw()

end


function love.update(dt)

end



local function initConstants(difficulty)
    local ship_img = love.graphics.newImage('assets/graphics/ships/ship_1')
    
    CONSTANTS = readOnlyTable({
        WIDTH       = ,
        HEIGHT      = ,
        SHIP_LIMIT  = getShipLimit(difficulty),
        SHIP_HEIGHT = ship_imge:getHeight(),
        SHIP_WIDTH  = ship_img:getWidth(),
        DIFFICULTY  = difficulty,
        OFFSET      = 15,
        
        })
end

function love.load()
    SHIPS         = {}
    PLAYER_HEALTH = 100
    CONSTANTS      = {}

end


