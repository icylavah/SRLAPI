local srlapi = srlapi
local event = {}

event._quitMessage = 'srlapi is done now baiiii'

function event.quit()
	if srlapi.running then
		srlapi.running = false
		srlapi.window.close()
		error(event._quitMessage)
	end
end

return event