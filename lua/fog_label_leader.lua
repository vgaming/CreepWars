--<< fog_label_leader

local wesnoth = wesnoth
local hide_leaders = creepwars.hide_leaders
local mirror_style = creepwars.mirror_style
local creepwars_ai_side_set = creepwars_ai_side_set

if not hide_leaders and mirror_style ~= "mirror" then
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
