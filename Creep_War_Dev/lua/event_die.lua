-- << event_die.lua

local wesnoth = wesnoth
local creepwars = creepwars
local is_ai_array = creepwars.is_ai_array

local defender = wesnoth.get_unit(wesnoth.get_variable("x1") or 0, wesnoth.get_variable("y1") or 0)
local attacker = wesnoth.get_unit(wesnoth.get_variable("x2") or 0, wesnoth.get_variable("y2") or 0)
if defender == nil then
	local msg = "Warning: cannot find killed unit. No gold/creep bonus was generated."
	print(msg)
	wesnoth.message("Creep Wars", msg)
elseif not defender.canrecruit and not defender.variables["creepwars_creep"] then
	local msg = "Turn " .. wesnoth.get_variable("turn_number") .. ": " .. defender.type
		.. " died, neither Leader nor Creep. Probably plagued. No gold/creep bonus was generated."
	print(msg)
	-- wesnoth.message("Creep Wars", msg)
else
	creepwars.unit_kill_event(attacker, defender)
	if defender.canrecruit and is_ai_array[defender.side] then
		creepwars.guard_killed_event(attacker.side, defender.side)
	elseif defender.canrecruit and not is_ai_array[defender.side] then
		creepwars.leader_died_event(defender)
	end
end

-- >>
