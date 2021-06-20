local buttonHeight = 64
local 
function newButton(text, fn)
    return {
        text = text,
        fn = fn
    }
end

local buttons = {}

local font = nil

function love.load()
    font = love.graphics.newFont(25)
    table.insert(buttons, newButton(
        "Start Game",
        function()
            print("Starting game")
        end))
    table.insert(buttons, newButton(
        "Load Game",
        function()
            print("Loading game")
        end))
    table.insert(buttons, newButton(
        "Settings",
        function()
            print("Settings Menu")
        end))
    table.insert(buttons, newButton(
        "Exit",
        function()
            love.event.quit(0)
        end))    
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50
    score = 0
    timer = 0
    gameFont = love.graphics.newFont(40)

end

function love.update(dt)

end
function love.draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local buttonWidth = ww * (2/6)
    local margin = 16

    local totalHeight = (buttonHeight + margin) * #buttons

    local cursorY = 0
    for i, button in ipairs(buttons) do
        local x = (ww * 0.5) - (buttonWidth * 0.5)

        local y = (wh * 0.5) - (buttonHeight * 0.5) * cursorY
        love.graphics.setColor(0.5, 0.5, 0.9)
        love.graphics.rectangle(
            "fill", x, y, (ww * 0.5) - (buttonWidth * 0.5), (wh * 0.5) - (buttonHeight * 0.5) - (totalHeight * 0.5) + cursorY, buttonWidth, buttonHeight
        )

        love.graphics.setColor(0, 0, 0,1)
        love.graphics.print(button.text, font,x, y )
        cursorY = cursorY + (buttonHeight + margin)
    end
    love.graphics.setColor(1,0,0)
    love.graphics.circle("fill", target.x, target.y, target.radius)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(gameFont)
    love.graphics.print(score, 0, 0)
end

function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget < target.radius then
            score = score + 1
            target.x = math.random(target.radius, love.graphics.getWidth()- target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight()- target.radius)

        end    
    end    
end    
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end    
