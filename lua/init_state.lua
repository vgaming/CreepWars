-- << init_state.lua

local wesnoth = wesnoth
local ipairs = ipairs
local is_ai_array = creepwars.is_ai_array


-- kill AI leaders at starting positions if there are others (guards)
for _, side in ipairs(wesnoth.sides) do
	local start_loc = wesnoth.get_starting_location(side.side)
	local x, y = start_loc[1], start_loc[2]
	local has_other_leaders = #wesnoth.get_units { side = side.side, canrecruit = true } > 1
	if is_ai_array[side.side] and has_other_leaders then
		wesnoth.wml_actions.kill {
			x = x,
			y = y,
			canrecruit = true,
			side = side.side,
			fire_event = false,
			animate = false,
		}
	end
end


-- >>
