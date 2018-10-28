local gos = reaper.GetOS
local b32, b64 = '32 bit', '64 bit'
local ARCH = {
	Win32 = b32,
	Win64 = b64,
	OSX32 = b32,
	OSX64 = b64
}

arch = ARCH[gos()]

if not arch then
	arch = reaper.ExecProcess('uname -p', 500):match 'x86_64' and b64 or b32
end

return arch