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

-- https://stackoverflow.com/a/6081639
local function serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", skipnewlines and 0 or depth)

	if name then
		local v = "[" .. string.format("%q", name) .. "]"
		if depth == 0 then v = "_G" .. v end
		tmp = tmp .. v .. " = "
	end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

		for k, v in pairs(val) do
			if type(k) ~= 'string' then k = '[' .. k .. ']' end
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end

local function getScriptID()
	local _, _, _, cmdID, _, _, _ = reaper.get_action_context()
	return cmdID .. ''
end

local cache = {}
cache._G = cache

function project:setCookie(key, value)
	assert(type(key) == 'string')
	
	cache[key] = nil
	
	if value ~= nil then
		value = serializeTable(value, key, true)
		value = value .. '_'
	end
	
	reaper.SetProjExtState(self, getScriptID(), key, value or "")
end

function project:getCookie(key)
	assert(type(key) == 'string')
	
	if cache[key] then return cache[key] end
	
	local v = select(2, reaper.GetProjExtState(self, getScriptID(), key))
	if not v or v == "" then return nil end
	load(v:sub(1, -2), 'cookie', 'bt', cache)()
	
	return cache[key]
end

function project:doAction(id)
	reaper.Main_OnCommandEx(id, 0, self)
end

function project:getType()
	return 'project'
end

return project