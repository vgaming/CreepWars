-- << event_die.lua

local wesnoth = wesnoth
local creepwars_creep_kill_event = creepwars_creep_kill_event

local defender = wesnoth.get_unit(wesnoth.get_variable("x1"), wesnoth.get_variable("y1"))
local attacker = wesnoth.get_unit(wesnoth.get_variable("x2"), wesnoth.get_variable("y2"))
if attacker then
	creepwars_creep_kill_event(attacker.side, defender)
else
	error("Unit died without attacker! This is bad! Maybe it's the latest guard kill that is untested?")
end

-- >>
