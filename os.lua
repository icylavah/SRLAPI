local gos = reaper.GetOS
local win, mac, lin = 'Windows', 'Mac', 'Linux'
local OS = {
	Win32 = win,
	Win64 = win,
	OSX32 = mac,
	OSX64 = mac
}

local os = OS[gos()]

if not os then
	os = reaper.ExecProcess('uname -o', 500):match(lin) and lin
end

return os or gos()