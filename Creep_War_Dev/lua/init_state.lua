-- << init_state | Creep_War_Dev
if rawget(_G, "init_state | Creep_War_Dev") then
	-- TODO: remove this code once https://github.com/wesnoth/wesnoth/issues/8157 is fixed
	return
else
	rawset(_G, "init_state | Creep_War_Dev", true)
end

local wesnoth = wesnoth
local addon = creepwars
local ipairs = ipairs
local is_ai_array = addon.is_ai_array
local on_event = wesnoth.require("lua/on_event.lua")


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

for _, guard in ipairs(addon.guards_pos) do
	local unit = {
		side = guard.side,
		type = "Elvish Marshal",
		name = "Guard",
		max_moves = 0,
		max_hitpoints = 60 * creepwars.guard_health_percentage / 100,
		max_experience = 100000,
		random_traits = false,
		canrecruit = true,
		{ "defense", { castle = 50, } },
	}
	wesnoth.put_unit(unit, guard.x, guard.y)
end

for _, side in ipairs(wesnoth.sides) do
	side.recruit = {}
end

on_event("start", function()
	for _, team in ipairs(addon.team_array) do
		local active = addon.array_filter(team, function(s)
			return #wesnoth.get_units { canrecruit = true, side = s.side } > 0
		end)
		for _, side in ipairs(team) do
			side.gold = side.gold * (6 - #active) / 2
		end
	end
end)

-- >>
