function love.run()
    if love.math then
        love.math.setRandomSeed(os.time())
    end
    if love.load then love.load(arg) end

    if love.timer then love.timer.step() end

    local dt = 0

    while true do
        if love.event then
            love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then 
                   if not love.quit or not love.quit() then
                       return a
                    end
                end
                love.handlers[name](a,b,c,d,e,f)
            end
        end

        if love.timer then 
            love.timer.step()
            dt = love.timer.getDelta()
        end

        if love.update then love.update(dt) end

        if love.graphics and love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.gragrics.origin()
            if love.draw then love.draw() end
            love.grahics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end                               
