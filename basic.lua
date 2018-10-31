local srlapi = srlapi

local msg = reaper.ShowConsoleMsg
function srlapi.print(...)
	local len = select('#', ...)
	if len > 0 then
		local m = tostring(...)
		for i = 2, len do
			m = m .. '\t' .. tostring(select(i, ...))
		end
		
		msg(m)
	end
	msg '\n'
end

function srlapi.write(...)
	local len = select('#', ...)
	assert(len > 0)
	
	local m = tostring(...)
	for i = 2, len do
		m = m .. tostring(select(i, ...))
	end
	msg(m)
end

srlapi.clear = reaper.ClearConsole

function srlapi.error(str)
	reaper.ReaScriptError(str)
end

local os = srlapi._require 'os'
function srlapi.getOS()
	return os
end

local arch = srlapi._require 'arch'
function srlapi.getArch()
	return arch
end

function srlapi.refresh()
	reaper.UpdateTimeline()
	reaper.DockWindowRefresh()
	
	-- dumb hack to refresh tracks
	local project = srlapi.getCurrentProject()
	local i = project:getTrackCount()
	local track = reaper.InsertTrackAtIndex(i, false)
	reaper.DeleteTrack(project:getTrack(i + 1))
end

local loop
local time
function srlapi.run()
	srlapi.running = true
	if srlapi.quit then reaper.atexit(srlapi.quit) end
	if srlapi.load then
		local status, err = pcall(srlapi.load)
	
		if not status and not err:match(srlapi.event._quitMessage) then
			srlapi.error(debug.traceback(err))
		elseif not srlapi.running then
			return
		end
	end
	
	time = srlapi.timer.getTime()
	loop()
end

local queue = {}
local function input()
	if srlapi.resize and not srlapi.window._matchWH() then
		srlapi.resize(gfx.w, gfx.h)
	end
	srlapi.window._updateLastWH()
	
	local char = 1
	while char > 0 do
		char = gfx.getchar()
		if char == -1 then srlapi.window._open = false end
		if char > 0 then table.insert(queue, char) end
	end
	
	if srlapi.wheelmoved and (gfx.mouse_wheel ~= 0 or gfx.mouse_hwheel ~= 0) then
		srlapi.wheelmoved(gfx.mouse_hwheel / -120, gfx.mouse_wheel / -120)
		gfx.mouse_hwheel, gfx.mouse_wheel = 0, 0
	end
	
	if srlapi.mousemoved and not srlapi.mouse._matchPosition() then
		local mx, my = srlapi.mouse.getPosition()
		local lmx, lmy = srlapi.mouse._lastX, srlapi.mouse._lastY
		
		srlapi.mousemoved(mx, my, mx - lmx, my - lmy)
	end
	
	if srlapi.mousepressed or srlapi.mousereleased then
		for i = 1, 3 do
			local cb = srlapi.mouse._callback[srlapi.mouse._lastState[i]][srlapi.mouse.isDown(i)]
			if cb and srlapi[cb] then
				local mx, my = srlapi.mouse.getPosition()
				srlapi[cb](mx, my, i)
			end
		end
	end
	srlapi.mouse._updateLastState()
	
	if srlapi.keypressed then
		for i = 1, #queue do
			local char = queue[i]
			local key = srlapi.keyboard.codeToKey(char)
			if key then
				srlapi.keypressed(key)
				srlapi.keyboard._isDown[char] = true
			end
		end
	end
	
	if srlapi.textinput then
		for i = 1, #queue do
			local char = queue[i]
			local key = srlapi.keyboard.codeToText(char)
			if key then srlapi.textinput(key) end
		end
	end
	
	if srlapi.keyreleased then
		for code,v in pairs(srlapi.keyboard._isDown) do
			if gfx.getchar(code) == 0 then
				srlapi.keyboard._isDown[code] = nil
				srlapi.keyreleased(srlapi.keyboard.codeToKey(code))
			end
		end
	end
	queue = {}
end

local function innerLoop()
	input()
	
	local t = srlapi.timer.getTime()
	if srlapi.update then srlapi.update(t - time) end
	time = t
	
	if srlapi.draw then srlapi.draw() end
	gfx.update()
end

function loop()
	local status, err = pcall(innerLoop)
	
	if not status and not err:match(srlapi.event._quitMessage) then
		srlapi.error(debug.traceback(err))
	elseif srlapi.running then
		reaper.defer(loop)
	end
end

