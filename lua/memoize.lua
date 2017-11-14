-- << memoize.lua

local wesnoth = wesnoth
local creepwars_kills_to_cost = creepwars_kills_to_cost

wesnoth.message("Creep Wars", "Latest changes: 1. Game reload possible! Finally. 2. Add more creep types. 3. Leader is auto-selected at turn start.")
wesnoth.message("Creep Wars", "Addon name is 'Creep War Dev'. Please write feedback & ideas you have.:)")


local ai_sides = {}
for _, side in ipairs(wesnoth.sides) do
	if side.controller == "ai" or side.controller == "network_ai" then
		ai_sides[side.side] = true
	end
end
ai_sides = { [4] = true, [8] = true }


local team_name_to_team_id = {}
for _, side in ipairs(wesnoth.sides) do
	team_name_to_team_id[side.team_name] = side.side -- we take last side number as team "ID", to persistent it on game reloads
end
local side_to_team = {}
for _, side in ipairs(wesnoth.sides) do
	side_to_team[side.side] = team_name_to_team_id[side.team_name]
end


for _, team_id in pairs(team_name_to_team_id) do
	local kills = wesnoth.get_variable("creepwars_kills_" .. team_id)
	local gold = wesnoth.get_variable("creepwars_gold_" .. team_id)
	print("loading/creating team " .. team_id .. ", kills: " .. (kills or "nil") .. ", gold: " .. (gold or "nil"))
	if not kills then
		wesnoth.set_variable("creepwars_kills_" .. team_id, 0)
	end
	if not gold then
		wesnoth.set_variable("creepwars_gold_" .. team_id, 0)
	end
end


local ugly_y_pos
if wesnoth.get_terrain(18, 5) == "Qxua^Xo" then
	ugly_y_pos = 5
else
	ugly_y_pos = 10
end

local display_kills
wesnoth.wml_actions.label { x = 18, y = ugly_y_pos - 1, text = "Creep strength:", color = "255,230,128" }
do
	local label_positions = {}
	label_positions[side_to_team[1]] = {x = 17, y = 5 } -- UGLY inline HACK
	label_positions[side_to_team[2]] = {x = 19, y = 5 } -- UGLY inline HACK

	display_kills = function()
		for team, pos in pairs(label_positions) do
			local kills = wesnoth.get_variable("creepwars_kills_" .. team)
			local cost = creepwars_kills_to_cost(kills)
			wesnoth.wml_actions.label {
				x = pos.x,
				y = ugly_y_pos,
				text = math.ceil(cost * 100) / 100,
				color = "255,230,128"
			}
		end
	end
end
display_kills()


local display_gold
wesnoth.wml_actions.label { x = 18, y = ugly_y_pos, text = "Leader gold:", color = "255,128,128" }
do
	local label_positions = {}
	label_positions[side_to_team[1]] = {x = 17, y = 6 } -- UGLY inline HACK
	label_positions[side_to_team[2]] = {x = 19, y = 6 } -- UGLY inline HACK
	display_gold = function()
		for team, pos in pairs(label_positions) do
			local gold = wesnoth.get_variable("creepwars_gold_" .. team)
			wesnoth.wml_actions.label { x = pos.x, y = ugly_y_pos + 1, text = gold, color = "255,128,128" }
		end
	end
end
display_gold()


local function creep_kill_event(attacker, defender)
	local team = side_to_team[attacker.side]

	do -- kills
		local kills_previous = wesnoth.get_variable("creepwars_kills_" .. team)
		local strength_previous = math.ceil(creepwars_kills_to_cost(kills_previous) * 100) / 100
		local kill_bonus = math.pow(defender.__cfg.cost, 0.6)
		local kills_new = kills_previous + kill_bonus
		local strength_new = math.ceil(creepwars_kills_to_cost(kills_new) * 100) / 100
		local strength_diff = strength_new - strength_previous
		wesnoth.float_label(attacker.x, attacker.y, "<span color='#FFE680'>" .. strength_diff .. "</span>" )
		wesnoth.set_variable("creepwars_kills_" .. team, kills_new)
	end

	do -- gold
		local give_gold
		if defender.canrecruit then
			give_gold = 23
		else
			give_gold = 3
		end

		local give_guard_hitpoints = math.ceil(give_gold / 3)
		for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do -- guard
			if side_to_team[unit.side] == team and unit.max_moves == 0 then
				wesnoth.add_modification(unit, "object", {
					{
						"effect", {
						apply_to = "hitpoints",
						increase_total = give_guard_hitpoints,
						increase = give_guard_hitpoints
					}
					},
				})
			end
		end

		local gold_previous = wesnoth.get_variable("creepwars_gold_" .. team)
		wesnoth.set_variable("creepwars_gold_" .. team, gold_previous + give_gold)
		for _, side in ipairs(wesnoth.sides) do
			if side_to_team[side.side] == team then
				side.gold = side.gold + give_gold
			end
		end
	end

	display_kills()
	display_gold()
end


local starting_positions = {}
do
	local best_unit_for_side = {}
	for _, u in ipairs(wesnoth.get_units { canrecruit = true }) do
		local previous = best_unit_for_side[u.side]
		if not (previous and #previous.extra_recruit >= #u.extra_recruit) then
			best_unit_for_side[u.side] = u
			print("Starting position for side " .. u.side .. " is " .. u.x .. "," .. u.y)
			starting_positions[u.side] = { x = u.x, y = u.y }
		end
	end
	-- UGLY INLINE HACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!:
	starting_positions[4] = {x = 32, y = 10}
	starting_positions[8] = {x = 4, y = 10}
	-- UGLY INLINE HACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end


creepwars_memoize_starting_positions = starting_positions
creepwars_memoize_ai_side_set = ai_sides
creepwars_side_to_team = side_to_team
creepwars_creep_kill_event = creep_kill_event

-- >>
