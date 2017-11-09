-- << select_leader.lua

local wesnoth = wesnoth
local creepwars_display_kills = creepwars_display_kills
local creepwars_get_team_id = creepwars_get_team_id

local defender = wesnoth.get_unit(wesnoth.get_variable("x1"), wesnoth.get_variable("y1"))
local attacker = wesnoth.get_unit(wesnoth.get_variable("x2"), wesnoth.get_variable("y2"))
if attacker then
	local team = creepwars_get_team_id[wesnoth.sides[attacker.side].team_name]
	local kills_previous = wesnoth.get_variable("creepwars_kills_" .. team)
	local kills_new = kills_previous + defender.__cfg.cost
	wesnoth.set_variable("creepwars_kills_" .. team, kills_new)
	creepwars_display_kills()
	--print("die event occured " .. attacker.id .. " killed " .. defender.id)
else
	error("Unit died without attacker! This is bad! Maybe it's the latest guard kill that is untested?")
end

-- >>
