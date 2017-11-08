-- << select_leader.lua

local wesnoth = wesnoth
local memoize_ai_side_set = creepwars_memoize_ai_side_set

local side_number = wesnoth.get_variable("side_number")
if memoize_ai_side_set[side_number] then
--	local x1 = wesnoth.get_variable("x1")
--	local y1 = wesnoth.get_variable("y1")
--	local x2 = wesnoth.get_variable("x2")
--	local y2 = wesnoth.get_variable("y2")
--	local defender = wesnoth.get_unit(x1, y1)
--	local attacker = wesnoth.get_unit(x2, y2)
--	print("die event occured " .. attacker.id .. " killed " .. defender.id)
	-- AI
else
	-- human
end

-- >>
