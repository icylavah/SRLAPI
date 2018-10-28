local srlapi = srlapi
local timer = {}

function timer.getTime()
	return reaper.time_precise()
end

function timer.sleep(time)
	local t = timer.getTime()
	while timer.getTime() - t < time do end
end

return timer