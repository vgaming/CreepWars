--<< fog_label_leader

local wesnoth = wesnoth
local creepwars_hide_leaders = creepwars_hide_leaders
local creepwars_mirror_style = creepwars_mirror_style
local creepwars_ai_side_set = creepwars_ai_side_set

if not creepwars_hide_leaders and creepwars_mirror_style ~= "mirror" then
	local is_first_turn = wesnoth.get_variable("turn_number") == 1
	for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
		if not creepwars_ai_side_set[unit.side] then
			local limbo_x = unit.variables.limbo_x
			local limbo_y = unit.variables.limbo_y
			local text = is_first_turn and wesnoth.unit_types[unit.type].name or ""
			wesnoth.wml_actions.label { x = limbo_x, y = limbo_y, text = text }
		end
	end

end

-->>
