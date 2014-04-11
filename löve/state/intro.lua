local o = {}

o.imgBackground0	= love.graphics.newImage("gfx/love_bg.png")
o.imgBackground0:setWrap("repeat", "repeat")
o.vertBackground0 = {
	{ 0, 0, 0, 0, 255, 255, 255, 63 },
	{ love.window.getWidth(), 0, love.window.getWidth() / o.imgBackground0:getWidth(), 0, 255, 255, 255, 63 },
	{ love.window.getWidth(), love.window.getHeight(), love.window.getWidth() / o.imgBackground0:getWidth(), love.window.getHeight() / o.imgBackground0:getHeight(), 255, 255, 255, 127 },
	{ 0, love.window.getHeight(), 0, love.window.getHeight() / o.imgBackground0:getHeight(), 255, 255, 255, 127 },
}
o.mshBackground0 	= love.graphics.newMesh(o.vertBackground0, o.imgBackground0, "fan")
o.imgBackground1	= love.graphics.newImage("gfx/love_logo.png")
o.imgBackground2	= love.graphics.newImage("gfx/world.png")
o.phase = 1

o.fontTitle = love.graphics.newFont(20)

o.effectTimer = 0
o.chromaticEffect = 0
o.showTimer = 0

o.gui = love.gui.newGui()

o.update = function(dt)
	o.gui.update(dt)

	o.showTimer = o.showTimer + dt
	if (o.phase == 1)then
		if o.gui.isHit() or love.keyboard.isDown("escape") or (o.showTimer > 4) then
			o.showTimer = 0
			o.phase = 2
		end
	elseif o.phase == 2 then
		o.effectTimer = o.effectTimer + dt
		o.chromaticEffect = o.chromaticEffect + dt
		if o.gui.isHit() or love.keyboard.isDown("escape") or(o.showTimer > 4) then
			o.gui.flushMouse()
			love.setgamestate(0)
		end
	end
end

o.quote = "War...war never changes."
o.source = "-Fallout"

o.draw = function()
	if o.phase == 1 then
		o.vertBackground0 = {
			{ 0, 0, -o.showTimer * 0.1, -o.showTimer * 0.2, 255, 255, 255, 63 },
			{ love.window.getWidth(), 0, love.window.getWidth() / o.imgBackground0:getWidth() - o.showTimer * 0.1, -o.showTimer * 0.2, 255, 255, 255, 63 },
			{ love.window.getWidth(), love.window.getHeight(), love.window.getWidth() / o.imgBackground0:getWidth() - o.showTimer * 0.1, love.window.getHeight() / o.imgBackground0:getHeight() - o.showTimer * 0.2, 255, 255, 255, 127 },
			{ 0, love.window.getHeight(), - o.showTimer * 0.1, love.window.getHeight() / o.imgBackground0:getHeight() - o.showTimer * 0.2, 255, 255, 255, 127 },
		}
		o.mshBackground0:setVertices(o.vertBackground0)
		love.graphics.setBlendMode("alpha")
		love.graphics.setColor(131, 192, 240)
		love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), love.window.getHeight())
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(o.mshBackground0)
		love.graphics.setColor(255, 255, 255)
		local sx = love.window.getWidth() * 0.5 - o.imgBackground1:getWidth() * 0.5
		local sy = love.window.getHeight() * 0.5 - o.imgBackground1:getHeight() * 0.5
		love.graphics.draw(o.imgBackground1, sx, sy)
		love.graphics.setFont(o.fontTitle)
		love.graphics.setColor(63, 63, 63)
		love.graphics.printf("Created with:", 0, love.window.getHeight() * 0.5 - o.imgBackground1:getHeight() - 8, love.window.getWidth(), "center")
	elseif o.phase == 2 then
		love.graphics.setColor(63, 63, 63)
		love.graphics.draw(o.imgBackground2, love.window.getWidth() * 0.5 - o.imgBackground2:getWidth() * 0.5)

		love.graphics.setColor(127, 127, 127)
		love.graphics.setFont(o.fontTitle)
		love.graphics.printf(o.quote, love.window.getWidth() * 0.5 - 128, love.window.getHeight() * 0.5 - 16, love.window.getWidth() * 0.5, "left")
		love.graphics.printf(o.source, love.window.getWidth() * 0.5 + 64, love.window.getHeight() * 0.5 + 16, love.window.getWidth() * 0.5, "left")

		if math.random(0, love.timer.getFPS() * 5) == 0 then
			o.chromaticEffect = math.random(0, 5) * 0.1
		end

		if o.chromaticEffect < 1.0 then
			local colorAberration1 = math.sin(love.timer.getTime() * 10.0) * (1.0 - o.chromaticEffect) * 2.0
			local colorAberration2 = math.cos(love.timer.getTime() * 10.0) * (1.0 - o.chromaticEffect) * 2.0

			love.postshader.addEffect("chromatic", colorAberration1, colorAberration2, colorAberration2, -colorAberration1, colorAberration1, -colorAberration2)
		end
	end
end


return o