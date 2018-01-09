-- << memoize_sides

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local creepwars_score_start = creepwars_score_start

local is_ai_array = {}
for _, side in ipairs(wesnoth.sides) do
	local is_ai = wesnoth.get_variable("creepwars_is_ai_" .. side.side)
	if is_ai == nil then is_ai = side.controller == "ai" or side.controller == "network_ai" end
	wesnoth.set_variable("creepwars_is_ai_" .. side.side, is_ai)
	is_ai_array[side.side] = is_ai
end

local side_to_team = {}
local team_name_to_id = {}
local team_array = {}
for _, side in ipairs(wesnoth.sides) do
	local team_id = team_name_to_id[side.team_name] or #team_array + 1
	team_name_to_id[side.team_name] = team_id
	side_to_team[side.side] = team_id
	team_array[team_id] = team_array[team_id] or {}
	team_array[team_id][#team_array[team_id] + 1] = side.side
end


for team_id, _ in ipairs(team_array) do
	wesnoth.set_variable("creepwars_gold_" .. team_id,
		wesnoth.get_variable("creepwars_gold_" .. team_id) or 0)
	wesnoth.set_variable("creepwars_score_" .. team_id,
		wesnoth.get_variable("creepwars_score_" .. team_id) or creepwars_score_start)
	wesnoth.set_variable("creepwars_creepkills_" .. team_id,
		wesnoth.get_variable("creepwars_creepkills_" .. team_id) or 0)
	wesnoth.set_variable("creepwars_leaderkills_" .. team_id,
		wesnoth.get_variable("creepwars_leaderkills_" .. team_id) or 0)
end


creepwars.side_to_team = side_to_team
creepwars.team_array = team_array
creepwars.is_ai_array = is_ai_array

-- >>