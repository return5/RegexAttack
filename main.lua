local Button = require('auxillary_files/models/button')
local Ship   = require('auxillary_files/models/ship')
local utf8   = require("utf8")

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

local function printUserInput()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",CONSTANTS.WIDTH / 2 - 100,CONSTANTS.HEIGHT + 20,CONSTANTS.FONT_WIDTH * 30,CONSTANTS.FONT_HEIGHT * 3)
    love.graphics.setColor(0,0,0)
    love.graphics.print(PLAYER_INPUT,CONSTANTS.WIDTH / 2 - 100, CONSTANTS.HEIGHT + 20 + CONSTANTS.FONT_HEIGHT)
end

local function printScore()
    love.graphics.print("Player's health: "..PLAYER_HEALTH,20,4)
    love.graphics.print("Player's Score: "..PLAYER_SCORE,20,4 + CONSTANTS.FONT_HEIGHT)

end


local function checkRegexMatch(regex)
    --for each ship check to see if the reegex matches, and if does remove ship.
    for i=#SHIPS,1,-1 do
        if REGEX_FLAVOR.matchRegex(regex,SHIPS[i].regex_obj) then
            SHIPS[i]:clear()
            table.remove(SHIPS,i)
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
    local lua_bttn   = BUTTON:new(button_x, lua_y,"Lua Patterns",100,height,function() REGEX_CHOICE = 1 end)
    local posix_bttn = BUTTON:new(button_x,posix_y,"POSIX",100,height,function() REGEX_FLAVOR = 2 end)
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
        INIT_GAME      = true
    end
end

function love.draw()
    if not GET_REGEX and not GET_DIFFICULTY then
        drawBoundaryLine()
        drawShips()
        printScore()
        printUserInput()
    elseif GET_REGEX then
        drawRegexSelectionScreen()
    elseif GET_DIFFICULTY then
        drawDifficultySelectionScreen()
    end
end

local function makeShips()
    io.write("making ships: ", LEVEL,"\n")
    SHIPS      = {}
    local x    = CONSTANTS.WIDTH - CONSTANTS.SHIP_WIDTH 
    local rand = math.random
    for i=0,SHIP_LIMIT - 1,1 do
        SHIPS[#SHIPS + 1] = SHIP:new(x,i * (CONSTANTS.SHIP_HEIGHT + CONSTANTS.OFFSET) + CONSTANTS.OFFSET,rand) 
    end
end

local function initGame()
    setShipLimit()
    initObjects()
    makeShips()
    REGEX_FLAVOR = require('auxillary_files/util/regexCheckout')
    INIT_GAME    = false
end

function love.update(dt)
    if INIT_GAME then
        initGame()
    elseif INIT_LEVEL then
        makeShips()
        INIT_LEVEL = false
    elseif not GET_DIFFICULTY then
        if #SHIPS <= 0 then
            INIT_LEVEL   = LEVEL < 3 and true or false
            GAME_OVER    = not INIT_LEVEL
            PLAYER_SCORE = LEVEL < 3 and PLAYER_SCORE + 100 or PLAYER_SCORE
            LEVEL        = LEVEL + 1
        else
            for i=#SHIPS,1,-1 do
                SHIPS[i]:update(dt) 
                if SHIPS[i].x == 5 then
                    PLAYER_HEALTH = PLAYER_HEALTH - 25
                elseif SHIPS[i].x < 0 then
                    SHIPS[i]:clear()
                    table.remove(SHIPS,i)
                end
            end
        end

        if PLAYER_HEALTH <= 0 then
            GAME_OVER = true
        end
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
        local byteoffset = utf8.offset(PLAYER_INPUT, -1)
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            PLAYER_INPUT = string.sub(PLAYER_INPUT, 1, byteoffset - 1)
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
        HEIGHT       = 450,
        SHIP_HEIGHT  = ship_img:getHeight(),
        SHIP_WIDTH   = ship_img:getWidth(),
        OFFSET       = ship_img:getHeight() / 2,
        SPEED        = 20,
        RED          = r,
        GREEN        = g,
        BLUE         = b,
        FONT         = font,
        FONT_HEIGHT  = height,
        FONT_HALF_H  = height / 2,
        FONT_WIDTH   = font:getWidth(1)
        })
end

function love.load()
    math.randomseed(os.time())  --seed random generator
    SHIPS          = {}         -- array of ships
    PLAYER_HEALTH  = 100        -- player's starting health'
    CONSTANTS      = {}         -- table which will hold constants
    initConstants()             -- initalize constants
    love.window.setMode(CONSTANTS.WIDTH,CONSTANTS.HEIGHT + 100)  -- set size fo window
    GET_REGEX      = true  -- should the game get the regex flavor from the user
    GET_DIFFICULTY = true  -- should the game get the difficulty from the user
    REGEX_FLAVOR   = ""    -- flavor of regex to user 
    SHIP_LIMIT     = 0     -- limit on number of enemy ships
    MOUSE_DEBOUNCE = 0     -- used to control mouse debouncing
    INIT_LEVEL     = false -- shoudl game start a new level
    INIT_GAME      = false -- should game initilize itself
    PLAYER_INPUT   = ''    -- player's input, holds the inputted regex
    GAME_OVER      = false -- is the game over
    LEVEL          = 1     -- current level
    PLAYER_SCORE   = 0     -- player's score
    REGEX_CHOICE   = 0
end

