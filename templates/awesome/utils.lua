local clock = os.clock
local m = {}
function m.sleep(n) -- seconds
	local t0 = clock()
	while clock() - t0 <= n do
	end
end

return m
