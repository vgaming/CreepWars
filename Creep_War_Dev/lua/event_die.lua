-- << event_die | Creep_War_Dev
if rawget(_G, "event_die | Creep_War_Dev") then
	-- TODO: remove this code once https://github.com/wesnoth/wesnoth/issues/8157 is fixed
	return
else
	rawset(_G, "event_die | Creep_War_Dev", true)
end

local wesnoth = wesnoth
local addon = creepwars
local is_ai_array = addon.is_ai_array

local defender = wesnoth.get_unit(wesnoth.get_variable("x1") or 0, wesnoth.get_variable("y1") or 0)
local attacker = wesnoth.get_unit(wesnoth.get_variable("x2") or 0, wesnoth.get_variable("y2") or 0)
if defender == nil then
	local msg = "Warning: cannot find the killed unit. No gold/creep bonus was generated."
	print(msg)
	wesnoth.message("Creep Wars", msg)
elseif not defender.canrecruit and not defender.variables["creepwars_creep"] then
	local msg = "Turn " .. wesnoth.get_variable("turn_number") .. ": " .. defender.type
		.. " died, neither Leader nor Creep. Probably plagued. No gold/creep bonus was generated."
	print(msg)
	-- wesnoth.message("Creep Wars", msg)
else
	print_as_json("killed a unit", defender.canrecruit, is_ai_array[defender.side], addon.alive_teams_count(), attacker, defender)
	if not defender.canrecruit then
		addon.unit_kill_event(attacker, defender)
	elseif not is_ai_array[defender.side] then
		addon.unit_kill_event(attacker, defender)
		creepwars.leader_died_event(defender)
	elseif addon.alive_teams_count() >= 3 then
		addon.unit_kill_event(attacker, defender)
		addon.guard_killed_event(attacker.side, defender.side)
	else
		addon.guard_killed_event(attacker.side, defender.side)
	end
end

-- >>
