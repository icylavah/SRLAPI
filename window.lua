local srlapi = srlapi
local window = {}

function window._updateLastWH()
	window._lastW, window._lastH = gfx.w, gfx.h
end

function window._matchWH()
	return window._lastW == gfx.w and window._lastH == gfx.h
end

function window.create(x, y, w, h, title, docked)
	if type(x) == 'table' then
		x, y, w, h, title, docked = x.x, x.y, x.w, x.h, x.title, x.docked
	end
	
	w = w or 480
	h = h or 480
	title = title or 'untitled'
	
	if not x or not y then
		local _, _, sw, sh = reaper.my_getViewport(0, 0, 0, 0, 0, 0, 0, 0, false)
		x = x or math.floor((sw - w) / 2)
		y = y or math.floor((sh - h) / 2)
	end
	
	gfx.init(title, w, h, docked, x, y)
	
	window._open = true
	window._updateLastWH()
end

function window.close()
	window._open = false
	gfx.quit()
end

function window.isOpen()
	return window._open
end

local function items(t)
	local str = ''
	for i = 1, #t do
		assert(not (type(t[i]) == 'string' and t[i]:match('%|')), 'menu items can not contain a pipe symbol')
		local item = tostring(t[i])
		
		if type(t[i + 1]) == 'table' then
			str = str .. '|>\r' .. item
		elseif type(t[i]) == 'table' then
			str = str .. '|' .. items(t[i])
		elseif t[i] == '' then
			str = str .. '|'
		elseif i == #t then
			str = str .. '|<\r' .. item
		else
			str = str .. '|\r' .. item
		end
	end
	
	return str:sub(2, -1)
end

function window.menu(t, x, y)
	if not window.isOpen() then return nil end
	local mx, my = srlapi.mouse.getPosition()
	if not x then x = mx end
	if not y then y = my end
	
	srlapi.graphics.setPosition(x, y)
	
	gfx.showmenu(items(t))
end

window._open = false

return window