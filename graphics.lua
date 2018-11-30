local srlapi = srlapi
local graphics = {}

graphics._lineWidth = 1

function graphics.getPosition()
	return gfx.x, gfx.y
end

function graphics.setPosition(x, y)
	gfx.x, gfx.y = x, y
end

function graphics.getColor()
	return gfx.r, gfx.g, gfx.b, gfx.a
end

function graphics.setColor(r, g, b, a)
	if type(r) == 'table' then r, g, b, a = r[1], r[2], r[3], r[4] end
	gfx.r, gfx.g, gfx.b, gfx.a = r, g, b, a or gfx.a
end

function graphics.getLineWidth()
	return graphics._lineWidth
end

function graphics.setLineWidth(w)
	graphics._lineWidth = w
end

function graphics.rectangle(mode, x, y, w, h)
	if w < 0 then
		x = x + w
		w = -w
	end
	
	if h < 0 then
		y = y + h
		h = -h
	end
	
	gfx.rect(x, y, w, h, mode == 'fill')
end

function graphics.line(x1, y1, x2, y2)
	local w = graphics.getLineWidth()
	
	local offx, offy = x2 - x1, y2 - y1
	local nx, ny = offx, offy
	local nlen = math.sqrt(nx * nx + ny * ny)
	nx, ny = nx / nlen, ny / nlen
	local wnx, wny = -ny, nx
	
	local px1, py1 = x1 + wnx * w / 2, y1 + wny * w / 2
	local px2, py2 = px1 - wnx * w, py1 - wny * w
	local px3, py3 = px2 + offx, py2 + offy
	local px4, py4 = px1 + offx, py1 + offy
	
	gfx.triangle(px1, py1, px2, py2, px3, py3, px4, py4)
end

function graphics.print(text, x, y)
	x = x or 0
	y = y or 0
	
	graphics.setPosition(x, y)
	gfx.drawstr(tostring(text))
end

function graphics.newCanvas(w, h)
	local canvas = setmetatable({
		w = w,
		h = h
	}, srlapi.canvas._mt)
	
	canvas.handle = srlapi.canvas._newHandle(canvas)
	gfx.setimgdim(canvas.handle, w, h)
	
	return canvas
end

function graphics.setCanvas(canvas)
	if not canvas then
		gfx.dest = -1
	else
		gfx.dest = canvas.handle
	end
end

return graphics