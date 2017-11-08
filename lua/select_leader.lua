-- << select_leader.lua

local wesnoth = wesnoth
local memoize_ai_side_set = creepwars_memoize_ai_side_set

local side_number = wesnoth.get_variable("side_number")
if not memoize_ai_side_set[side_number] then
	local leader = wesnoth.get_units { side = side_number, canrecruit = true }[1]
	if leader then
		wesnoth.select_hex(leader.x, leader.y)
	end
end

-- >>
