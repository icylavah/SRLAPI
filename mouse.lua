local srlapi = srlapi
local mouse = {}

local isDown = {
	function()
		return gfx.mouse_cap & 1 ~= 0
	end,
	function()
		return gfx.mouse_cap & 2 ~= 0
	end,
	function()
		return gfx.mouse_cap & 64 ~= 0
	end
}

function mouse._updateLastState()
	mouse._lastState = {
		isDown[1](),
		isDown[2](),
		isDown[3]()
	}
	mouse._lastX, mouse._lastY = mouse.getPosition()
end

function mouse._matchPosition()
	local mx, my = mouse.getPosition()
	return mx == mouse._lastX and my == mouse._lastY
end

mouse._callback = {
	[false] = {
		[true] = 'mousepressed'
	},
	[true] = {
		[false] = 'mousereleased'
	}
}

function mouse.isDown(...)
	local count = select('#', ...)
	for i = 1, count do
		if isDown[select(i, ...)]() then return true end
	end
	
	return false
end

function mouse.getPosition()
	return gfx.screentoclient(reaper.GetMousePosition())
end

function mouse.getX()
	return (mouse.getPosition())
end

function mouse.getY()
	return select(2, mouse.getPosition())
end

mouse._updateLastState()

return mouse