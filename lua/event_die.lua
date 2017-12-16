-- << event_die.lua

local wesnoth = wesnoth
local creepwars_creep_kill_event = creepwars_creep_kill_event

local defender = wesnoth.get_unit(wesnoth.get_variable("x1"), wesnoth.get_variable("y1"))
local attacker = wesnoth.get_unit(wesnoth.get_variable("x2"), wesnoth.get_variable("y2"))
if defender == nil then
	local msg = "Warning: cannot find killed unit. No gold/creep bonus was generated."
	print(msg)
	wesnoth.message("Creep Wars", msg)
elseif attacker == nil then
	local msg = "Warning: Unit died without attacker. This is unexpected. " ..
		"No creep score or gold bonus will be generated. " ..
		"This is probably because of a conflicting addon/modification. " ..
		"If the host has no modifications, please report the issue."
	print(msg)
	wesnoth.message("Creep Wars", msg)
elseif defender.canrecruit or defender.variables["creepwars_creep"] then
	creepwars_creep_kill_event(attacker, defender)
else
	local msg = "Turn " .. wesnoth.get_variable("turn_number") .. ": " .. defender.type
		.. " died, neither Leader nor Creep. Probably plagued. No gold/creep bonus was generated."
	print(msg)
	wesnoth.message("Creep Wars", msg)
end

-- >>
