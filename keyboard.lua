local srlapi = srlapi
local keyboard = {}

keyboard._isDown = {}

local key = srlapi._require 'keymap'.key
local inverseKey = {}
for k,v in pairs(key) do inverseKey[v] = k end

local text = srlapi._require 'keymap'.text
local inverseText = {}
for k,v in pairs(text) do inverseText[v] = k end

function keyboard.codeToKey(code)
	if code == 27 and srlapi.keyboard.isDown 'ctrl' then return '[' end
	if code == 42 and not srlapi.keyboard.isDown 'shift' then return '*' end
	if code == 43 and not srlapi.keyboard.isDown 'shift' then return '+' end
	return key[code]
end

function keyboard.keyToCode(key)
	return inverseKey[key]
end

function keyboard.codeToText(code)
	if code == 27 and not srlapi.keyboard.isDown 'ctrl' then return nil end
	return text[code]
end

function keyboard.textToCode(char)
	return inverseTex[char]
end

local special = {
	ctrl = function()
		return gfx.mouse_cap & 4 ~= 0
	end,
	shift = function()
		return gfx.mouse_cap & 8 ~= 0
	end,
	alt = function()
		return gfx.mouse_cap & 16 ~= 0
	end,
	meta = function()
		return gfx.mouse_cap & 32 ~= 0
	end
}
function keyboard.isDown(...)
	local count = select('#', ...)
	for i = 1, count do
		local key = select(i, ...)
		if special[key] then
			if special[key]() then return true end
		elseif keyboard._isDown[keyboard.keyToCode(key)] then
			return true
		end
	end
	
	return false
end

return keyboard