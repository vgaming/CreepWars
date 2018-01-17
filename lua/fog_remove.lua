-- << fog_remove

local wesnoth = wesnoth
local ipairs = ipairs
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
local is_ai_array = creepwars.is_ai_array

-- wesnoth-1.12 seems to be a bit buggy, we'll clear fog with multiturn = true AND false.
local function lift_fog(x, y)
	wesnoth.wml_actions.lift_fog { x = x, y = y, multiturn = true }
	wesnoth.wml_actions.lift_fog { x = x, y = y, multiturn = false }
end

for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
	if is_ai_array[unit.side] == true then
		local ability = T.name_only {
			id = "creepwars_guard",
			name = "guard",
			description = "All team members lose if this unit dies. \n"
				.. "You can heal and unpoison your guard at the Shop."
		}
		wesnoth.add_modification(unit, "object", {
			T.effect { apply_to = "new_ability", T.abilities { ability } }
		})
		if wesnoth.get_variable("creepwars_lift_fog_guard") ~= false then
			lift_fog(unit.x, unit.y)
		end
	else
		if creepwars.reveal_leaders then
			local start_loc = wesnoth.get_starting_location(unit.side)
			lift_fog(start_loc[1], start_loc[2])
		end
	end
end


-- >>
