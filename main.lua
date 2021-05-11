local Button = require('auxillary_files/models/button')
local Ship   = require('auxillary_files/models/ship')

local function updateShipLocation(dt)
    --for each ship update its location
    for i=#SHIPS,1,-1 do
        SHIPS[i]:update(dt)
    end
end

local function drawBoundaryLine()
    --draw red boundary line
    love.graphics.setLineWidth(5)
    love.graphics.setColor(255,0,0)
    love.graphics.line(15,0,15,CONSTANTS.HEIGHT)
    love.graphics.setColor(CONSTANTS.RED,CONSTANTS.GREEN,CONSTANTS.BLUE)
end

local function drawShips()
    --draw each ship
    for i=#SHIPS,1,-1 do
        SHIPS[i]:draw()
    end
end


local function checkRegexMatch(regex)
    --for each ship check to see if the reegex matches, and if does remove ship.
    for i=#SHIPS,1,-1 do
        if REGEX.matchRegex(regex,SHIPS[i].regex_obj) then
            SHIPS[i]:clear()
            SHIPS[i] = nil
            break
        end
    end
end

--set limit of number of ships based on difficulty
local function setShipLimit()
    if DIFFICULTY == "easy" then
        SHIP_LIMIT =  3
    elseif DIFFICULTY == "medium" then
        SHIP_LIMIT = 4
    elseif DIFFICULTY == "tough" then
        SHIP_LIMIT = 4
    else
        SHIP_LIMIT = 3
    end
end

local function drawRegexSelectionScreen()
    local str      = "Please select the REGEX flavor to use."
    local width    = CONSTANTS.FONT:getWidth(str) 
    local str_x    = CONSTANTS.WIDTH / 2 - width / 2 --place text in middle of screen
    local height   = CONSTANTS.FONT_HEIGHT * 3 -- height to make each button
    local button_x = str_x  + 50 -- x for the left hand side of button
    local lua_y    = CONSTANTS.FONT_HEIGHT * 2  -- y for top side of button
    local posix_y  = CONSTANTS.FONT_HEIGHT * 7
    love.graphics.print(str,str_x,5)
    local lua_bttn   = BUTTON:new(button_x, lua_y,"Lua Patterns",100,height,function() REGEX = 1 end)
    local posix_bttn = BUTTON:new(button_x,posix_y,"POSIX",100,height,function() REGEX = 2 end)
    lua_bttn:draw()
    posix_bttn:draw()
    if love.mouse.isDown(1) and onClick({posix_bttn,lua_bttn}) then
        GET_REGEX = false
        MOUSE_DEBOUNCE = love.timer.getTime()
    end
end

local function drawDifficultySelectionScreen()
    local str         = "Please select Difficulty."
    local width       = CONSTANTS.FONT:getWidth(str) 
    local str_x       = CONSTANTS.WIDTH / 2 - width / 2 --place text in middle of screen
    local height      = CONSTANTS.FONT_HEIGHT * 3 -- height to make each button
    local button_x    = str_x  + 15 -- x for the left hand side of button
    local height      = CONSTANTS.FONT_HEIGHT * 3
    local easy_y      = CONSTANTS.FONT_HEIGHT * 2
    local medium_y    = CONSTANTS.FONT_HEIGHT * 7
    local tough_y     = CONSTANTS.FONT_HEIGHT * 12
    local easy_bttn   = BUTTON:new(button_x, easy_y,"easy",100,height,function() DIFFICULTY = "easy" end)
    local medium_bttn = BUTTON:new(button_x,medium_y,"medium",100,height,function() DIFFICULTY = "medium" end)
    local tough_bttn  = BUTTON:new(button_x,tough_y,"tough",100,height,function() DIFFICULTY = "tough" end)
    love.graphics.print(str,str_x,5)
    easy_bttn:draw()
    medium_bttn:draw()
    tough_bttn:draw()
    if love.mouse.isDown(1) and (love.timer.getTime() - MOUSE_DEBOUNCE) * 1000 > 500 and onClick({easy_bttn,medium_bttn,tough_bttn}) then
        GET_DIFFICULTY = false
        INIT_LEVEL     = true
    end
end

function love.draw()
    if not GET_REGEX and not GET_DIFFICULTY then
        drawBoundaryLine()
        drawShips()
    elseif GET_REGEX then
        drawRegexSelectionScreen()
    elseif GET_DIFFICULTY then
        drawDifficultySelectionScreen()
    end
end

local function makeShips()
    SHIPS      = {}
    local x    = CONSTANTS.WIDTH - CONSTANTS.SHIP_WIDTH 
    local rand = math.random
    for i=0,SHIP_LIMIT - 1,1 do
        SHIPS[#SHIPS + 1] = SHIP:new(x,i * (CONSTANTS.SHIP_HEIGHT + CONSTANTS.OFFSET) + CONSTANTS.OFFSET,rand) 
    end
end

function love.update(dt)
    if INIT_LEVEL then
        setShipLimit()
        initObjects()
        makeShips()
        REGEX = require('auxillary_files/util/regexCheckout')
        INIT_LEVEL = false
    end
    for i=#SHIPS,1,-1 do
        SHIPS[i]:update(dt)
    end
end



--takes text input. used to get player's regex
function love.textinput(t)
    PLAYER_INPUT = PLAYER_INPUT .. t
end

--handle key presses
function love.keypressed(_,scancode)
    --if player presses enter
    if scancode == "return" then
        checkRegexMatch(PLAYER_INPUT)
        PLAYER_INPUT = ""
    --if player hits backspace, delete char. code is copied directly from love2d wiki
    elseif scancode == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(PLAYER_NAME, -1)
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            PLAYER_NAME = string.sub(PLAYER_NAME, 1, byteoffset - 1)
        end
    end
end

local function initConstants()
    --local ship_img = love.graphics.newImage( 'ship_1.png')
    local read_only = require('auxillary_files/util/readOnlyTables') 
    local r,g,b     = love.graphics.getColor()
    local font      = love.graphics.newFont()
    local ship_img  = love.graphics.newImage('assets/graphics/ships/ship_1.png')
    local height    = font:getHeight()
    CONSTANTS       = readOnlyTable({
        WIDTH        = 900,
        HEIGHT       = 500,
        SHIP_HEIGHT  = ship_img:getHeight(),
        SHIP_WIDTH   = ship_img:getWidth(),
        OFFSET       = ship_img:getHeight() / 2,
        SPEED        = 30,
        RED          = r,
        GREEN        = g,
        BLUE         = b,
        FONT         = font,
        FONT_HEIGHT  = height,
        FONT_HALF_H  = height / 2
        })
end

function love.load()
    math.randomseed(os.time())
    SHIPS          = {}
    PLAYER_HEALTH  = 100
    CONSTANTS      = {}
    initConstants()
    love.window.setMode(CONSTANTS.WIDTH,CONSTANTS.HEIGHT + 50)
    GET_REGEX      = true
    GET_DIFFICULTY = true
    REGEX          = ""
    SHIP_LIMIT     = 0
    MOUSE_DEBOUNCE = 0
    INIT_LEVEL     = false
    PLAYER_INPUT   = ''

end

