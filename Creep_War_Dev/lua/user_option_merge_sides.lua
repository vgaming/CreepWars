-- << creepwars/user_option_merge_sides

local wesnoth = wesnoth
local wml = wml
local addon = creepwars
local ipairs = ipairs

if wesnoth.get_variable("creepwars_merge_sides") then
	for _, sides_array in ipairs(addon.team_array) do
		local human_sides = addon.array_filter(sides_array,
			function(side) return not addon.is_ai_array[side] end)
		local second_human = human_sides[2] or human_sides[1]
		for _, side in ipairs(human_sides) do
			for _, unit in ipairs(wesnoth.get_units { side = side, canrecruit = true }) do
				unit.side = second_human
			end
		end
	end
end

-- >>
