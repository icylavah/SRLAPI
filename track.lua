local srlapi = srlapi
local track = {}

function track:getName()
	return select(2, reaper.GetTrackName(self, ''))
end

function track:setName(name)
	reaper.GetSetMediaTrackInfo_String(self, 'P_NAME', name, true)
	
	return self
end

function track:isSelected()
	return reaper.IsTrackSelected(self)
end

function track:setSelected(selected)
	reaper.SetTrackSelected(self, selected)
	
	return self
end

function track:isVisibleInMixer()
	if self:isMaster() then return reaper.GetMasterTrackVisibility() & 2 ~= 0 end
	return reaper.IsTrackVisible(self, true)
end

function track:setVisibleInMixer(visible)
	if self:isMaster() then
		reaper.SetMasterTrackVisibility((visible and 2 or 0) + (self:isVisibleInTCP() and 1 or 0))
		
		return self
	end
	
	reaper.SetMediaTrackInfo_Value(self, 'B_SHOWINMIXER', visible and 1 or 0)
	
	return self
end

function track:isVisibleInTCP()
	if self:isMaster() then return reaper.GetMasterTrackVisibility() & 1 ~= 0 end
	return reaper.IsTrackVisible(self, false)
end

function track:setVisibleInTCP(visible)
	if self:isMaster() then
		reaper.SetMasterTrackVisibility((self:isVisibleInMixer() and 2 or 0) + (visible and 1 or 0))
		
		return self
	end
	
	reaper.SetMediaTrackInfo_Value(self, 'B_SHOWINTCP', visible and 1 or 0)
	
	return self
end

local fullyVisible = {
	[false] = function(self)
		return self:isVisibleInMixer() or self:isVisibleInTCP()
	end,
	[true] = function(self)
		return self:isVisibleInMixer() and self:isVisibleInTCP()
	end
}
function track:isVisible(fully)
	return fullyVisible[fully or false](self)
end

function track:setVisible(visible)
	self:setVisibleInTCP(visible)
	self:setVisibleInMixer(visible)
	
	return self
end

function track:getColor()
	if reaper.GetMediaTrackInfo_Value(self, 'I_CUSTOMCOLOR') & 0x01000000 == 0 then
		return nil
	end
	local r, g, b = reaper.ColorFromNative(reaper.GetTrackColor(self))
	
	return r / 255, g / 255, b / 255
end

function track:setColor(r, g, b)
	if not r then
		reaper.SetMediaTrackInfo_Value(self, 'I_CUSTOMCOLOR', 0)
		return
	end
	if type(r) == 'table' then r, g, b = r[1], r[2], r[3] end
	
	reaper.SetTrackColor(self, reaper.ColorToNative(
		math.floor(r * 255 + 0.5),
		math.floor(g * 255 + 0.5),
		math.floor(b * 255 + 0.5)
	))
end

function track:delete()
	reaper.DeleteTrack(self)
end

function track:getProject()
	if self:isMaster() then
		for i,project in ipairs(srlapi.getProjects()) do
			if project:getMasterTrack() == self then return project end
		end
	else
		local project
		if self:getItemCount() > 0 then
			project = reaper.GetItemProjectContext(reaper.GetTrackMediaItem(self, 0))
		else
			local mi = reaper.AddMediaItemToTrack(self)
			project = reaper.GetItemProjectContext(mi)
			reaper.DeleteTrackMediaItem(self, mi)
		end
		
		srlapi.setType(project, 'project')
		
		return project
	end
end

function track:getParent()
	if self:isMaster() then return nil end
	
	local parent = reaper.GetParentTrack(self)
	
	if parent then
		srlapi.setType(parent, 'track')
		return parent
	end
	
	return self:getProject():getMasterTrack()
end

function track:getChild(i)
	local k = 1
	local project = self:getProject()
	for j = self:getIndex() + 1, project:getTrackCount() do
		local other = project:getTrack(j)
		if other:getDepth() <= self:getDepth() then return nil end
		if other:getDepth() == self:getDepth() + 1 then
			if k == i then return other end
			k = k + 1
		end
	end
	
	return nil
end

local comp = {
	[false] = function(a, b) return a == b + 1 end,
	[true] = function(a, b) return a >= b + 1 end,
}
function track:getChildCount(recursive)
	if recursive == nil then recursive = false end
	local comp = comp[recursive]
	
	local count = 0
	local project = self:getProject()
	for i = self:getIndex() + 1, project:getTrackCount() do
		if comp(project:getTrack(i):getDepth(), self:getDepth()) then
			count = count + 1
		end
	end
	
	return count
end

function track:getChildren(recursive)
	if recursive == nil then recursive = false end
	local comp = comp[recursive]
	
	local children = {}
	local project = self:getProject()
	for i = self:getIndex() + 1, project:getTrackCount() do
		local other = project:getTrack(i)
		if other:getDepth() <= self:getDepth() then return children end
		if comp(other:getDepth(), self:getDepth()) then
			table.insert(children, other)
		end
	end
	
	return children
end

function track:isMaster()
	return self:getIndex() == -1
end

function track:getDepth()
	if self:isMaster() then return 0 end
	return reaper.GetTrackDepth(self) + 1
end

function track:getIndex()
	return reaper.GetMediaTrackInfo_Value(self, 'IP_TRACKNUMBER')
end

function track:getItemCount()
	return reaper.CountTrackMediaItems(self)
end

function track:getItem(i)
	local item = reaper.GetTrackMediaItem(self, i - 1)
	if item then srlapi.setType(item, 'item') end
	
	return item
end

function track:getItems(i)
	local count = self:getItemCount()
	local items = {}
	for i = 1, count do
		table.insert(items, self:getItem(i))
	end
	
	return items
end

function track:getType()
	return 'track'
end

return track