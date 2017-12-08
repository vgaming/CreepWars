-- << lift_fog

local wesnoth = wesnoth
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
local creepwars_memoize_ai_side_set = creepwars_memoize_ai_side_set
local creepwars_hide_leaders = creepwars_hide_leaders

-- wesnoth-1.12 seems to be a bit buggy, we'll clear fog with multiturn = true AND false.
local function lift_fog(x, y)
	wesnoth.wml_actions.lift_fog { x = x, y = y, multiturn = true }
	wesnoth.wml_actions.lift_fog { x = x, y = y, multiturn = false }
end

for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
	if creepwars_memoize_ai_side_set[unit.side] == true then
		local ability = T.name_only {
			name = "guard",
			description = "All team members lose if this unit dies. \n"
				.. "You can heal and unpoison your guard at the Shop."
		}
		wesnoth.add_modification(unit, "object", {
			T.effect { apply_to = "new_ability", T.abilities { ability } }
		})
		if wesnoth.get_variable("creepwars_lift_fog_guard") ~= false then
			-- print("Lifting fog around guard " .. unit.type .. " [" .. unit.x .. "," .. unit.y .. "]")
			lift_fog(unit.x, unit.y)
		end
	else
		if not creepwars_hide_leaders then
			local limbo_x = unit.variables.limbo_x
			local limbo_y = unit.variables.limbo_y
			-- print("Lifting fog around leader limbo " .. unit.type .. " [" .. limbo_x .. "," .. limbo_y .. "]")
			lift_fog(limbo_x, limbo_y)

			--local home_x = unit.variables.home_x
			--local home_y = unit.variables.home_y
			--print("Lifting fog around leader home " .. unit.type .. " [" .. limbo_x .. "," .. limbo_y .. "]")
			--lift_fog(home_x, home_y)
		end
	end
end


-- >>
