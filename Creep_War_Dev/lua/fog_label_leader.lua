-- << fog_label_leader | Creep_War_Dev
if rawget(_G, "fog_label_leader | Creep_War_Dev") then
	-- TODO: remove this code once https://github.com/wesnoth/wesnoth/issues/8157 is fixed
	return
else
	rawset(_G, "fog_label_leader | Creep_War_Dev", true)
end

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local mirror_style = creepwars.mirror_style
local is_ai_array = creepwars.is_ai_array

if creepwars.reveal_leaders and mirror_style ~= "mirror" then
	local is_first_turn = wesnoth.get_variable("turn_number") == 1

	for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
		if not is_ai_array[unit.side] then
			local start_loc = wesnoth.get_starting_location(unit.side)
			local text = is_first_turn and wesnoth.unit_types[unit.type].name or ""
			wesnoth.wml_actions.label { x = start_loc[1], y = start_loc[2], text = text }
		end
	end

end

-->>
