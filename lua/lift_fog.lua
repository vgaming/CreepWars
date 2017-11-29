-- << lift_fog

local wesnoth = wesnoth
local creepwars_memoize_ai_side_set = creepwars_memoize_ai_side_set
local creepwars_reveal_leaders = creepwars_reveal_leaders

-- wesnoth-1.12 seems to be a bit buggy, we'll clear fog with multiturn = true AND false.
local function lift_fog(x, y)
	wesnoth.wml_actions.lift_fog { x = x, y = y, multiturn = true }
	wesnoth.wml_actions.lift_fog { x = x, y = y, multiturn = false }
end

local msg_arr = {}
local all_units = wesnoth.get_units {}
table.sort(all_units, function(a, b) return wesnoth.sides[a.side].team_name < wesnoth.sides[b.side].team_name end)
for _, unit in ipairs(all_units) do
	if creepwars_memoize_ai_side_set[unit.side] == true then
		if wesnoth.get_variable("creepwars_lift_fog_guard") ~= false then
			print("Lifting fog around guard " .. unit.type .. " [" .. unit.x .. "," .. unit.y .. "]")
			lift_fog(unit.x, unit.y)
		end
	else
		if wesnoth.get_variable("creepwars_lift_fog_limbo") == true then
			local limbo_x = unit.variables.limbo_x
			local limbo_y = unit.variables.limbo_y
			local home_x = unit.variables.home_x
			local home_y = unit.variables.home_y
			print("Lifting fog around leader limbo " .. unit.type .. " [" .. limbo_x .. "," .. limbo_y .. "]")
			lift_fog(limbo_x, limbo_y)
			print("Lifting fog around leader home " .. unit.type .. " [" .. limbo_x .. "," .. limbo_y .. "]")
			lift_fog(home_x, home_y)
			msg_arr[#msg_arr + 1] = wesnoth.sides[unit.side].team_name .. unit.side .. ": " .. unit.type
		end
	end
end
if creepwars_reveal_leaders == true then
	local msg = table.concat(msg_arr, ", ")
	wesnoth.message("Creep Wars", 'Enemy leaders: ' .. msg)
end


-- >>
