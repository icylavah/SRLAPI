local srlapi = srlapi
local item = {}

function item:getName()
	return reaper.GetTakeName(reaper.GetActiveTake(self))
end

function item:setName(name)
	reaper.GetSetMediaItemTakeInfo_String(reaper.GetActiveTake(self), 'P_NAME', name, true)
	
	return self
end

function item:isSelected()
	return reaper.IsMediaItemSelected(self)
end

function item:setSelected(selected)
	reaper.SetMediaItemSelected(self, selected)
	
	return self
end

function item:getPosition()
	return reaper.GetMediaItemInfo_Value(self, 'D_POSITION')
end

function item:setPosition(position)
	reaper.SetMediaItemPosition(self, position, true)
	
	return self
end

function item:getLength()
	return reaper.GetMediaItemInfo_Value(self, 'D_LENGTH')
end

function item:setLength(length)
	reaper.SetMediaItemLength(self, length, true)
	
	return self
end

function item:getNotes()
	return select(2, reaper.GetSetMediaItemInfo_String(self, 'P_NOTES', '', false))
end

function item:setNotes(notes)
	reaper.GetSetMediaItemInfo_String(self, 'P_NOTES', notes, true)
	
	return self
end

function item:isMuted()
	return reaper.GetMediaItemInfo_Value(self, 'B_MUTE') ~= 0
end

-- must call srlapi.refresh() afterwards
function item:setMuted(muted)
	reaper.SetMediaItemInfo_Value(self, 'B_MUTE', muted and 1 or 0)
	return self
end

function item:isLooping()
	return reaper.GetMediaItemInfo_Value(self, 'B_LOOPSRC') ~= 0
end

-- must call srlapi.refresh() afterwards
function item:setLooping(looping)
	reaper.SetMediaItemInfo_Value(self, 'B_LOOPSRC', looping and 1 or 0)
	return self
end

function item:isLocked()
	return reaper.GetMediaItemInfo_Value(self, 'C_LOCK') ~= 0
end

-- must call srlapi.refresh() afterwards
function item:setLocked(locked)
	reaper.SetMediaItemInfo_Value(self, 'C_LOCK', locked and 1 or 0)
	return self
end

function item:getVolume()
	return reaper.GetMediaItemInfo_Value(self, 'D_VOL')
end

-- must call srlapi.refresh() afterwards
function item:setVolume(volume)
	reaper.SetMediaItemInfo_Value(self, 'D_VOL', volume)
	return self
end

function item:getPosition()
	return reaper.GetMediaItemInfo_Value(self, 'D_POSITION')
end

function item:setPosition(position)
	reaper.SetMediaItemInfo_Value(self, 'D_POSITION', position)
	return self
end

function item:getLength()
	return reaper.GetMediaItemInfo_Value(self, 'D_LENGTH')
end

function item:setLength(length)
	reaper.SetMediaItemInfo_Value(self, 'D_LENGTH', length)
	return self
end

local CURVE = 'curve'

local CURVE_WIDER = 'curve_wider' -- a curve that is kinda like CURVE but
-- not actually and also bends a bit more ¯\_(ツ)_/¯

local CURVE_WIDEST = 'curve_widest' -- a curve that is kinda like CURVE_WIDER but
-- not actually and also bends a bit more in the outwards direction; REAPER y u do dis

local CURVE_DOUBLE = 'curve_double' -- a curve that bends both ways

local CURVE_DOUBLE_WIDER = 'curve_double_wider' -- kinda like CURVE_DOUBLE but more bendy

local fades = {
	[0] = CURVE_WIDER,
	CURVE_WIDEST,
	CURVE,
	CURVE_WIDER,
	CURVE_WIDER,
	CURVE_DOUBLE,
	CURVE_DOUBLE_WIDER,
	CURVE_WIDEST
}
local fadesInverse = {
	[CURVE] = 2,
	[CURVE_WIDER] = 0,
	[CURVE_WIDEST] = 1,
	[CURVE_DOUBLE] = 5,
	[CURVE_DOUBLE_WIDER] = 6
}

function item:getFadeInType()
	return fades[reaper.GetMediaItemInfo_Value(self, 'C_FADEINSHAPE')]
end

-- must call srlapi.refresh() afterwards
function item:setFadeInType(type)
	reaper.SetMediaItemInfo_Value(self, 'C_FADEINSHAPE', fadesInverse[type])
	return self
end

function item:isCrossfadeIn()
	return reaper.GetMediaItemInfo_Value(self, 'D_FADEINLEN_AUTO') > 0
end

function item:getCrossfadeInLength()
	return reaper.GetMediaItemInfo_Value(self, 'D_FADEINLEN_AUTO')
end

function item:setCrossfadeInLength(length)
	return reaper.SetMediaItemInfo_Value(self, 'D_FADEINLEN_AUTO', length)
end

function item:getFadeInLength()
	return reaper.GetMediaItemInfo_Value(self, 'D_FADEINLEN')
end

-- must call srlapi.refresh() afterwards
function item:setFadeInLength(length)
	return reaper.SetMediaItemInfo_Value(self, 'D_FADEINLEN', length)
end

function item:getFadeInBend()
	return -reaper.GetMediaItemInfo_Value(self, 'D_FADEINDIR')
end

-- must call srlapi.refresh() afterwards
function item:setFadeInBend(bend)
	return reaper.SetMediaItemInfo_Value(self, 'D_FADEINDIR', -bend)
end

function item:getFadeOutType()
	return fades[reaper.GetMediaItemInfo_Value(self, 'C_FADEOUTSHAPE')]
end

-- must call srlapi.refresh() afterwards
function item:setFadeOutType(type)
	reaper.SetMediaItemInfo_Value(self, 'C_FADEOUTSHAPE', fadesInverse[type])
	return self
end

function item:isCrossfadeOut()
	return reaper.GetMediaItemInfo_Value(self, 'D_FADEOUTLEN_AUTO') > 0
end

function item:getCrossfadeOutLength()
	return reaper.GetMediaItemInfo_Value(self, 'D_FADEOUTLEN_AUTO')
end

-- must call srlapi.refresh() afterwards
function item:setCrossfadeOutLength(length)
	return reaper.SetMediaItemInfo_Value(self, 'D_FADEOUTLEN_AUTO', length)
end

function item:getFadeOutLength()
	return reaper.GetMediaItemInfo_Value(self, 'D_FADEOUTLEN')
end

-- must call srlapi.refresh() afterwards
function item:setFadeOutLength(length)
	return reaper.SetMediaItemInfo_Value(self, 'D_FADEOUTLEN', length)
end

function item:getFadeOutBend()
	return reaper.GetMediaItemInfo_Value(self, 'D_FADEOUTDIR')
end

-- must call srlapi.refresh() afterwards
function item:setFadeOutBend(bend)
	return reaper.SetMediaItemInfo_Value(self, 'D_FADEOUTDIR', bend)
end

function item:getSnapOffset()
	return reaper.GetMediaItemInfo_Value(self, 'D_SNAPOFFSET')
end

-- must call srlapi.refresh() afterwards
function item:setSnapOffset(offset)
	reaper.SetMediaItemInfo_Value(self, 'D_SNAPOFFSET', offset)
	return self
end

function item:getGroupID()
	local id = reaper.GetMediaItemInfo_Value(self, 'I_GROUPID')
	if id > 0 then return id end
	return nil
end

-- must call srlapi.refresh() afterwards
function item:setGroupID(id)
	reaper.SetMediaItemInfo_Value(self, 'I_GROUPID', id or 0)
	return self
end

function item:getColor()
	if reaper.GetMediaItemInfo_Value(self, 'I_CUSTOMCOLOR') & 0x01000000 == 0 then
		return nil
	end
	local r, g, b = reaper.ColorFromNative(reaper.GetMediaItemInfo_Value(self, 'I_CUSTOMCOLOR'))
	
	return r / 255, g / 255, b / 255
end

-- must call srlapi.refresh() afterwards
function item:setColor(r, g, b)
	if not r then
		reaper.SetMediaItemInfo_Value(self, 'I_CUSTOMCOLOR', 0)
		return
	end
	if type(r) == 'table' then r, g, b = r[1], r[2], r[3] end
	
	reaper.SetMediaItemInfo_Value(self, 'I_CUSTOMCOLOR', reaper.ColorToNative(
		math.floor(r * 255 + 0.5),
		math.floor(g * 255 + 0.5),
		math.floor(b * 255 + 0.5)
	) | 0x01000000)
end

function item:delete()
	reaper.DeleteTrackMediaItem(self:getTrack(), self)
end

function item:getTrack()
	local track = reaper.GetMediaItem_Track(self)
	if track then srlapi.setType(track, 'track') end
	
	return track
end

function item:getProject()
	local project = reaper.GetItemProjectContext(self)
	if project then srlapi.setType(project, 'project') end
	
	return project
end

function item:getTakeCount()
	return reaper.CountTakes(self)
end

function item:getTake(i)
	local take = reaper.GetTake(self, i - 1)
	if take then srlapi.setType(take, 'take') end
	
	return take
end

function item:getTakes()
	local count = self:getTakeCount()
	local takes = {}
	for i = 1, count do
		table.insert(takes, self:getTake(i))
	end
	
	return takes
end

function item:getCurrentTake()
	local take = reaper.GetActiveTake(self)
	if take then srlapi.setType(take, 'take') end
	
	return take
end

function item:getIndex()
	return reaper.GetMediaItemInfo_Value(self, 'IP_ITEMNUMBER') + 1
end

function item:getType()
	return 'item'
end

return item