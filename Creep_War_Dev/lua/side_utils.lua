-- << creepwars/endlevel_utils

local wesnoth = wesnoth
local addon = creepwars
local ipairs = ipairs
local side_to_team = creepwars.side_to_team
local team_array = creepwars.team_array

local function alive_teams_count()
	local result = 0
	local alive_set = {}
	for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
		local team = wesnoth.sides[unit.side].team_name
		if alive_set[team] == nil then
			result = result + 1
			alive_set[team] = true
		end
	end
	return result
end


local function is_local_human(side)
	return wesnoth.sides[side].controller == "human" and wesnoth.sides[side].is_local ~= false
end

local function am_i_victorious(winner_team)
	for _, side in ipairs(wesnoth.sides) do
		if side.team_name == winner_team and is_local_human(side.side) then
			return true
		end
	end
	for _, side in ipairs(wesnoth.sides) do
		if is_local_human(side.side) then
			return false
		end
	end
	return true
end


local function guard_killed_event(aggressive_side, defeated_side)
	for _, ally_side in ipairs(team_array[side_to_team[defeated_side]]) do
		wesnoth.wml_actions.kill { side = ally_side.side }
	end
	if alive_teams_count() <= 1 then
		local winner_team = wesnoth.sides[aggressive_side].team_name
		wesnoth.wml_actions.endlevel { result = am_i_victorious(winner_team) and "victory" or "defeat" }
	end
end

addon.alive_teams_count = alive_teams_count
addon.guard_killed_event = guard_killed_event

-- >>
