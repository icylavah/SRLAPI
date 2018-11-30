local srlapi = srlapi
local canvas = {}

canvas._mt = {__index = canvas}
canvas._handles = setmetatable({}, {__mode = 'v'})

local offset = 0
function canvas._newHandle(c, gc)
	offset = offset + 1
	if gc then collectgarbage() end
	
	for i = 0, 1023 do
		local index = (i + offset) % 1024
		if not canvas._handles[index] then
			canvas._handles[index] = c
			return index
		end
	end
	
	if not gc then
		return canvas._newHandle(c, true)
	else
		offset = offset + 1
	end
	
	return nil
end

function canvas:getWidth()
	return (self:getDimensions())
end

function canvas:setWidth(w)
	return gfx.setimgdim(canvas.handle, w, self:getHeight())
end

function canvas:getHeight()
	return select(2, self:getDimensions())
end

function canvas:setHeight(h)
	return gfx.setimgdim(canvas.handle, self:getWidth(), h)
end

function canvas:getDimensions()
	return gfx.getimgdim(self:getHandle())
end

function canvas:setDimensions(w, h)
	return gfx.setimgdim(canvas.handle, w, h)
end

function canvas:getHandle()
	return self.handle
end

return canvas