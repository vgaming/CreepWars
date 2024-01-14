-- << fog_remove | Creep_War_Dev
if rawget(_G, "fog_remove | Creep_War_Dev") then
	-- TODO: remove this code once https://github.com/wesnoth/wesnoth/issues/8157 is fixed
	return
else
	rawset(_G, "fog_remove | Creep_War_Dev", true)
end

local wesnoth = wesnoth
local ipairs = ipairs
local creepwars = creepwars
local T = wml.tag
local is_ai_array = creepwars.is_ai_array

local function lift_fog(x, y)
	wesnoth.wml_actions.lift_fog { x = x, y = y, multiturn = true }
end

for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
	if is_ai_array[unit.side] == true then
		local ability = T.name_only {
			name = "guard",
			description = "Team loses if this unit dies. \n"
				.. "You can heal and unpoison your guard at the Shop."
		}
		wesnoth.units.add_modification(unit, "object", {
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
