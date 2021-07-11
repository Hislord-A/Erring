createEnemyTImerMax = 0.
createEnemmyTimer = createEnemyTImerMax
enemyImg = nil
enemies = {}

function newButton(text, fn)
    return {
        text = text,
        fn = fn

        now = false
        last = false
    }
end

local buttons = {}

local font = nil


function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end

isAlive = true
score = 0

function love.conf(t)
    t.title = " Dairy Pure"
    t.version = "11.3.0.0"
    t.window.width = 300
    t.window.height = 600
    t.console = false
    t.window.resizable = false
    t.window.borderless = false
    t.window.fullscreen = false
    t.modules.audio = true
end

player1 = {x = 300, y = 810, speed = 150, img = nil}
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax
bulletImg = nil
bullets = {}


function love.load(arg)
    player1 = love.graphics.newImage('assets/aircrafts.png')
    enemyImg = love.graphics.newImage('assets/enemy.png')
    gunSound = love.audio.newSource('assets/gun-sound.wav','static')
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
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    if love.keyboard.isDown('left', 'a') then
        player1.x = player1.y - (player1.speed*dt)
    elseif love.keyboard.isDown('right', 'd') then
        player1.x = player1.y + (player1.speed*dt)
    end

    if love.keyboard.isDown('left', 'a') then
        if player1.x > 0 then 
            player1.x = player1.x -(player1.speed*dt)
        end
    elseif love.keyboard.isDown('right', 'd') then
        if player1.x < (love.graphics.getWidth() - player1.img:getHeight()) then
            player1.x = player1.x + (player1.speed*dt)
        end
    end
    bulletImg = love.graphics.newImage('assets/bullets.png')
    canShootTimer = canShootTimer - (1 * dt)
    if canShootTimer < 0 then
        canShoot = true
    end
    if love.keyboard.isDown('space', 'z', 'c') and canShoot then
        newBullet = {x = player1.x + (player1.img:getWidth()/2), y = player1.y, img = bulletImg}
        table.insert(bullets, newBullet)
        canShoot = false
        canShootTimer - canShootTimerMax
    end
    for i, bullet in ipairs(bullets) do
        bullet.y - bullet.y -(250 * dt)

        if bullet.y < 0 then 
            table.remove(bullets, i)
        end
        createEnemmyTimer = createEnemmyTimer - (1 * dt)
        if createEnemmyTimer < 0 then
            createEnemmyTimer = createEnemyTImerMax
            randomNumber = math.random(10, love.graphics.getWidth() - 10)
            newEnemy = {x = randomNumber, y = -10, img = enemyImg}
            table.insert(enemies, newEnemy)
        end
    end
    for i, enemy in ipairs(enemies) do 
        enemy.y = enemy.y + (200 * dt)

        if enemy.y > 850 then 
            table.remove(enemies, i)
        end
    end

    for i, enemy in ipairs(enemies) do
        for j, bullet in ipairs(bullets) do
            if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
                table.remove(bullets, j)
                table.remove(enemies, i)
                score = score + 1
            end
        end

        if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player1.x, player1.y, player1.img:getWidth(), player1.img:getHeight()) 
	and isAlive then
        table.remove(enemies, i)
        isAlive = false
    end
    if love.keyboard.isDown(' ', 'z', 'c') and canShoot then
        newBullet = {x = player1.x + (player1:img:getWidth()/2), y = player1.y, img = bulletImg}
        table.insert(bullets, newBullet)

        gunSound:play()

        canShoot = false
        canShootTimer = canShootTimerMax
    end
    if love.keyboard.isDown('up', 'w') then
        if player1.y > (love.graphics.getHeight()/2) then
            player1.y = player1.y - (player1.speed * dt)
        end
    elseif love.keyboard.isDown('down', 's') then
        if player1.y < (love.graphics.getHeight() - 55) then
            player1.y = player1 + (player1.speed * dt)
        end
    end



end


function love.draw(dt)
    player1 = love.graphics.draw(player1, player1.x, player1.y)

    for i, bullet in ipairs(bullets) do 
        love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end
    for i, enemy n ipairs(enemies) do
        love.graphics.draw(enemy.img, enemy.x, enemy.y)
    end
    if not isAlive and love.keyboard.isDown('r') then
        bullets = {}
        enemies = {}

        canShootTimer = canShootTimerMax
        createEnemmyTimer = createEnemyTImerMax

        player1.x = 50
        player1.y = 710

        score = 0
        isAlive = true
    end
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Score: " ..tostring(score), 400, 10)

    local ww = love.graphics.getWidth()

    local wh = love.graphics.getHeight()

    local buttonWidth = ww * (2/6)

    local margin = 16

    local totalHeight = (buttonHeight + margin) * #buttons

    local cursorY = 0
    
    for i, button in ipairs(buttons) do
        button.last = button.now
        local x = (ww * 0.5) - (buttonWidth * 0.5)

        local y = (wh * 0.5) - (buttonHeight * 0.5) * cursorY

        local color = {0.5, 0.4, 0.4, 1}

        local mouseX, mouseY = love.mouse.getPosition()
        
        local highlighted = mouseX > x and mouseX < x + buttonWidth and mouseY > y and mouseY < y + buttonHeight
        if highlighted then 
            color = {0.6, 0.6, 0.6, 1}
        end

        button.now = love.mouse.isDown(1)
        if button.now and not button.last and highlighted then button.fn()


        love.graphics.setColor((unpack(color)0.5, 0.5, 0.9)
        love.graphics.rectangle(
            "fill", x, y, (ww * 0.5) - (buttonWidth * 0.5), (wh * 0.5) - (totalHeight * 0.5) + cursorY, buttonWidth, buttonHeight
        )

        love.graphics.setColor(0, 0, 0,1)
        
        local textW = font:getWidth(button.text)
        local textH = font:getHeight(button.text)

        love.graphics.print(button.text, font,(ww * 0.5)* textW * 0.5, y - textH * 0.5)
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

    
