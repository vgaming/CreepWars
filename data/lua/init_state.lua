-- << init_state.lua

local wesnoth = wesnoth
local ipairs = ipairs
local is_ai_array = creepwars.is_ai_array


-- kill auto-generated AI leaders (not guards)
for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
	if is_ai_array[unit.side] and unit.max_moves > 1 then
		wesnoth.wml_actions.kill {
			id = unit.id,
			fire_event = false,
			animate = false,
		}
	end
end


-- >>
