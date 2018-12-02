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