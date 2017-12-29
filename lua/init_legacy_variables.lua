-- << legacy_variables.lua

local wesnoth = wesnoth
local is_ai_array = creepwars.is_ai_array
local array_map = creepwars.array_map

local ai_sides = array_map(is_ai_array, function(is_ai, side) return is_ai and side or nil end)
local player_sides = array_map(is_ai_array, function(is_ai, side) return not is_ai and side or nil end)

for side, is_ai in ipairs(is_ai_array) do
	if is_ai then
		wesnoth.wml_actions.kill { side = side, canrecruit = true }
	end
end

wesnoth.set_variable("CWD_PLAYER_SIDES", table.concat(player_sides, ","))
wesnoth.set_variable("CWD_CREEP_SIDES", table.concat(ai_sides, ","))

-- >>
