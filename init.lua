local srlapi = {}

local format = (...) .. '.%s'
local _require = require
local function require(modname)
	local _srlapi = _G.srlapi
	_G.srlapi = srlapi
	local mod = _require(format:format(modname))
	_G.srlapi = _srlapi
	
	return mod
end

srlapi._require = require

local otype = setmetatable({}, {__mode = 'k'})
local cp = reaper.EnumProjects(-1, '')

debug.setmetatable(cp, {__index = function(t, k)
	local type = otype[t]
	if not type then
		return t[k]
	else
		return srlapi[type][k]
	end
end})

function srlapi.setType(object, type)
	otype[object] = type
end

require 'basic'

srlapi.project = require 'project'
srlapi.track = require 'track'
srlapi.item = require 'item'
srlapi.take = require 'take'
srlapi.event = require 'event'
srlapi.window = require 'window'
srlapi.mouse = require 'mouse'
srlapi.keyboard = require 'keyboard'
srlapi.graphics = require 'graphics'
srlapi.timer = require 'timer'
srlapi.canvas = require 'canvas'

require 'path'

return srlapi