-- << memoize_sides | Creep_War_Dev
if rawget(_G, "memoize_sides | Creep_War_Dev") then
	-- TODO: remove this code once https://github.com/wesnoth/wesnoth/issues/8157 is fixed
	return
else
	rawset(_G, "memoize_sides | Creep_War_Dev", true)
end

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs

local is_ai_array = {}
for _, side in ipairs(wesnoth.sides) do
	is_ai_array[side.side] = not side.__cfg.allow_player
end

local side_to_team = {}
local team_name_to_id = {}
local team_array = {}
local team_ai_side = {}
for _, side in ipairs(wesnoth.sides) do
	local team_id = team_name_to_id[side.team_name] or #team_array + 1
	team_name_to_id[side.team_name] = team_id
	side_to_team[side.side] = team_id
	if is_ai_array[side.side] then team_ai_side[team_id] = side.side end
	team_array[team_id] = team_array[team_id] or {}
	team_array[team_id][#team_array[team_id] + 1] = side
end


for team_id, _ in ipairs(team_array) do
	wesnoth.set_variable("creepwars_gold_" .. team_id,
		wesnoth.get_variable("creepwars_gold_" .. team_id) or 0)
	wesnoth.set_variable("creepwars_score_" .. team_id,
		wesnoth.get_variable("creepwars_score_" .. team_id) or creepwars.score_start)
	wesnoth.set_variable("creepwars_creepkills_" .. team_id,
		wesnoth.get_variable("creepwars_creepkills_" .. team_id) or 0)
	wesnoth.set_variable("creepwars_leaderkills_" .. team_id,
		wesnoth.get_variable("creepwars_leaderkills_" .. team_id) or 0)
end


creepwars.is_ai_array = is_ai_array
creepwars.side_to_team = side_to_team
creepwars.team_ai_side = team_ai_side
creepwars.team_array = team_array

-- >>
