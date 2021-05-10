
local function updateShipLocation(dt)
    for i=#SHIPS,1,-1 do
        SHIPS[i]:update(dt)
    end
end


local function drawShips()
    love.graphics.setLineWidth(5)
    love.graphics.setColor(255,0,0)
    love.graphics.line(0,0,0,CONSTANTS.HEIGHT)
    love.graphics.setColor(CONSTANTS.COLOR)
    for i=#SHIPS,1,-1 do
        SHIPS[i]:draw()
    end
end

local function checkRegexMatch(regex)
    for i=#SHIPS,1,-1 do
        if REGEX.matchRegex(regex,SHIPS[i].regex_obj) then
            SHIPS[i]:clear()
            SHIPS[i] = nil
            break
        end
    end
end


local function getDifficulty()
    local dificulty = "easy" 
    return dificulty
end


local function getShipLimit(difficulty)
    if difficulty == "easy" then
        return 3
    elseif difficulty == "medium" then
        return 4
    elseif difficulty == "tough" then
        return 4
    end
    return 3
end

function love.draw()
    drawShips()
end


function love.update(dt)
    updateShipLocations(dt)
end


local function makeShips()
    SHIPS      = {}
    local x    = CONSTANTS.WIDTH - CONSTANTS.SHIP_WIDTH 
    local rand = math.random
    for i=1,CONSTANTS.SHIP_LIMIT,1 do
        SHIPS[3SHIPS + 1] = SHIP:new(x,i * CONSTANTS.SHIP_HEIGHT + CONSTANTS.OFFSET,rand) 
    end
end


local function initConstants(difficulty)
    local ship_img = love.graphics.newImage('assets/graphics/ships/ship_1')
    
    CONSTANTS = readOnlyTable({
        WIDTH       = 200,
        HEIGHT      = 100,
        SHIP_LIMIT  = getShipLimit(difficulty),
        SHIP_HEIGHT = ship_imge:getHeight(),
        SHIP_WIDTH  = ship_img:getWidth(),
        DIFFICULTY  = difficulty,
        OFFSET      = 15,
        COLOR       = love.graphics.getColor(),
        })
end

function love.load()
    SHIPS         = {}
    PLAYER_HEALTH = 100
    CONSTANTS     = {}
    initConstants(getDifficulty())
    REGEX         = require('regexCheckout')
end


