-- << fog_remove

local wesnoth = wesnoth
local ipairs = ipairs
local creepwars = creepwars
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
local is_ai_array = creepwars.is_ai_array

local function lift_fog(x, y)
	wesnoth.wml_actions.lift_fog { x = x, y = y, multiturn = true }
end

for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
	if is_ai_array[unit.side] == true then
		local ability = T.name_only {
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
			lift_fog(unit.x, unit.y)
		end
	end
end


-- >>
