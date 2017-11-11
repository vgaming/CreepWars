-- << select_leader.lua

local wesnoth = wesnoth

local side_number = wesnoth.get_variable("side_number")
if wesnoth.sides[side_number].controller == "human" then
	local leader = wesnoth.get_units { side = side_number, canrecruit = true }[1]
	if leader then
		if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.5") then
			wesnoth.select_unit(leader)
		else
			wesnoth.select_hex(leader.x, leader.y)
		end
	end
end

-- >>
