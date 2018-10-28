local function prepend(...) package.path = table.concat({...}, ';', 1, select('#', ...)) .. ';' .. package.path end

local exe = reaper.GetExePath() .. '/%s'

prepend(exe:format '?.lua', exe:format '?/init.lua')
prepend(exe:format 'lua/?.lua', exe:format 'lua/?/init.lua')

local resource = reaper.GetResourcePath() .. '/%s'

prepend(resource:format 'Scripts/?.lua', resource:format 'Scripts/?/init.lua')