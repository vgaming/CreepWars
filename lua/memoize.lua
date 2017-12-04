-- << memoize.lua

local wesnoth = wesnoth
local split_comma = creepwars_split_comma
local set_concat = creepwars_set_concat


local ai_sides = {}
do
	local var = wesnoth.get_variable("creepwars_ai_sides")
	if var ~= nil then
		for _, v in ipairs(split_comma(var)) do
			ai_sides[tonumber(v)] = true
		end
	else
		for _, side in ipairs(wesnoth.sides) do
			if side.controller == "ai" or side.controller == "network_ai" then
				ai_sides[side.side] = true
			end
		end
		wesnoth.set_variable("creepwars_ai_sides", set_concat(ai_sides, ","))
	end
end
print("AI sides: " .. wesnoth.get_variable("creepwars_ai_sides"))


local team_name_to_team_id = {}
for _, side in ipairs(wesnoth.sides) do
	team_name_to_team_id[side.team_name] = side.side -- we take last side number as team "ID", to persistent it on game reloads
end
local side_to_team = {}
for _, side in ipairs(wesnoth.sides) do
	side_to_team[side.side] = team_name_to_team_id[side.team_name]
end


for _, team_id in pairs(team_name_to_team_id) do
	local score = wesnoth.get_variable("creepwars_creep_score_" .. team_id)
	local gold = wesnoth.get_variable("creepwars_gold_" .. team_id)
	print("loading/creating team " .. team_id .. ", creep score: " .. (score or "nil") .. ", gold: " .. (gold or "nil"))
	if not score then
		wesnoth.set_variable("creepwars_creep_score_" .. team_id, creepwars_score_start)
	end
	if not gold then
		wesnoth.set_variable("creepwars_gold_" .. team_id, 0)
	end
end


local starting_positions = {}
do
	local best_unit_for_side = {}
	for _, u in ipairs(wesnoth.get_units { canrecruit = true }) do
		local previous = best_unit_for_side[u.side]
		if not (previous and #previous.extra_recruit >= #u.extra_recruit) then
			best_unit_for_side[u.side] = u
			-- print("Starting position for side " .. u.side .. " is " .. u.x .. "," .. u.y)
			starting_positions[u.side] = { x = u.x, y = u.y }
		end
	end
	-- UGLY INLINE HACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!:
	starting_positions[4] = { x = 32, y = 10 }
	starting_positions[8] = { x = 4, y = 10 }
	-- UGLY INLINE HACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end


creepwars_memoize_starting_positions = starting_positions
creepwars_memoize_ai_side_set = ai_sides
creepwars_side_to_team = side_to_team

-- >>
