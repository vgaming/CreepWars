-- << init_state.lua

local wesnoth = wesnoth
local creepwars = creepwars
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

for _, guard in ipairs(creepwars.guards_pos) do
	local unit = {
		side = guard.side,
		type = "Elvish Marshal",
		name = "Guard",
		max_moves = 0,
		max_hitpoints = 60,
		max_experience = 100000,
		random_traits = false,
		canrecruit = true,
		{ "defense", { castle = 50, } },
	}
	wesnoth.put_unit(guard.x, guard.y, unit)
end

for _, side in ipairs(wesnoth.sides) do
	side.recruit = {}
end

-- >>
