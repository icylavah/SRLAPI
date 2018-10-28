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