local srlapi = srlapi
local take = {}

function take:getName()
	return reaper.GetTakeName(self)
end

function take:setName(name)
	reaper.GetSetMediaItemTakeInfo_String(self, 'P_NAME', name, true)
	
	return self
end

function take:getItem()
	local item = reaper.GetMediaItemTake_Item(self)
	if item then srlapi.setType(item, 'item') end
	
	return item
end

function take:getTrack()
	local track = reaper.GetMediaItemTake_Track(self)
	if track then srlapi.setType(track, 'track') end
	
	return track
end

function take:isMIDI()
	return reaper.TakeIsMIDI(self)
end

function take:isSelected()
	return self:getItem():getCurrentTake() == self
end

function take:setSelected()
	reaper.SetActiveTake(self)
	
	return self
end

function take:getIndex()
	return reaper.GetMediaItemTakeInfo_Value(self, 'IP_TAKENUMBER') + 1
end

function take:getType()
	return 'item'
end

return take