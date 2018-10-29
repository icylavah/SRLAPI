local srlapi = srlapi
local project = {}

function srlapi.getProject(i)
	local project = reaper.EnumProjects(i - 1, '')
	if project then srlapi.setType(project, 'project') end
	
	return project
end

function project:getIndex()
	local i, project = 1
	repeat
		project = srlapi.getProject(i)
		i = i + 1
	until project == self or project == nil
	
	return project and i - 1
end

function srlapi.getCurrentProject(i)
	return srlapi.getProject(0)
end

function srlapi.getProjectCount()
	local i = 0
	while srlapi.getProject(i + 1) do
		i = i + 1
	end
	
	return i
end

function srlapi.getProjects()
	local projects = {}
	local i, project = 1
	repeat
		project = srlapi.getProject(i)
		if project then table.insert(projects, project) end
		i = i + 1
	until project == nil
	
	return projects
end

function project:getName()
	return reaper.GetProjectName(self, '')
end

function project:isSelected()
	return srlapi.getCurrentProject() == self
end

function project:setSelected()
	reaper.SelectProjectInstance(self)
	
	return self
end

function project:isDirty()
	return reaper.IsProjectDirty(self)
end

function project:setDirty()
	reaper.MarkProjectDirty(self)
	
	return self
end

function project:getBPM()
	return (reaper.GetProjectTimeSignature2(self))
end

function project:setBPM(bpm)
	reaper.SetCurrentBPM(self, bpm, true)
	
	return self
end

function project:getTrackCount()
	return reaper.CountTracks(self)
end

function project:getTrack(i)
	local track = reaper.GetTrack(self, i - 1)
	if track then srlapi.setType(track, 'track') end
	
	return track
end

function project:getMasterTrack()
	local track = reaper.GetMasterTrack(self)
	srlapi.setType(track, 'track')
	
	return track
end

function project:getTracks()
	local count = self:getTrackCount()
	local tracks = {}
	for i = 1, count do
		table.insert(tracks, self:getTrack(i))
	end
	
	return tracks
end

function project:isPlaying()
	return reaper.GetPlayStateEx(self) & 1 ~= 0
end

function project:isPaused()
	return reaper.GetPlayStateEx(self) & 2 ~= 0
end

function project:isRecording()
	return reaper.GetPlayStateEx(self) & 4 ~= 0
end

function project:isLooping()
	return reaper.GetSetRepeatEx(self, -1) ~= 0
end

function project:setLooping(looping)
	reaper.GetSetRepeatEx(self, looping and 1 or 0)
	
	return self
end

function project:play()
	if not self:isPlaying() or self:isPaused() then reaper.OnPlayButtonEx(self) end
	
	return self
end

function project:pause()
	if not self:isPaused() then reaper.OnPauseButtonEx(self) end
	
	return self
end

function project:stop()
	reaper.OnStopButtonEx(self)
	
	return self
end

function project:getCursorPosition()
	return reaper.GetCursorPositionEx(self)
end

function project:setCursorPosition(position)
	reaper.SetEditCurPos2(self, position, false, false)
	
	return self
end

function project:doAction(id)
	reaper.Main_OnCommandEx(id, 0, self)
end

function project:getType()
	return 'project'
end

return project