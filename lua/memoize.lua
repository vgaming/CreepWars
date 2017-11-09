-- << memoize.lua

local wesnoth = wesnoth
local creepwars_kills_to_cost = creepwars_kills_to_cost

wesnoth.message("Creep Wars", "Changelog:")
wesnoth.message("Creep Wars", "1. Game reload possible! Finally. Creep score is preserved.")
wesnoth.message("Creep Wars", "2. Leader is auto-selected at turn start. 3. Add visual indication for lvl3+ units. 4. Increase creep strength. 5. Add more creep types.")
wesnoth.message("Creep Wars", "Addon name is 'Creep War Dev'. Please write feedback & ideas you have.:)")

--local isWesnoth13 = wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.0")
--if isWesnoth13 then -- unit.upkeep
--	local all = wesnoth.get_units {}
--	for _, u in ipairs(all) do
--		u.upkeep = 0
--	end
--end


local get_team_id = {}
local ai_sides = {}
for _, side in ipairs(wesnoth.sides) do
	if side.controller == "ai" or side.controller == "network_ai" then
		ai_sides[side.side] = true
	end
	get_team_id[side.team_name] = side.side -- we take last side number as team "ID" to persistent it on game reloads
end


for _, team_id in pairs(get_team_id) do
	local kills = wesnoth.get_variable("creepwars_kills_" .. team_id)
	print("loading/creating team " .. team_id .. ", kills: " .. (kills or "nil"))
	if not kills then
		wesnoth.set_variable("creepwars_kills_" .. team_id, 0)
	end
end


wesnoth.wml_actions.label { x = 18, y = 5, text = "Creep cost:", color = "250,200,0" }
local display_kills
do
	local label_positions = {}
	label_positions[get_team_id[wesnoth.sides[1].team_name]] = {x = 17, y = 6 } -- UGLY inline HACK
	label_positions[get_team_id[wesnoth.sides[2].team_name]] = {x = 19, y = 6 } -- UGLY inline HACK

	display_kills = function()
		for team, pos in pairs(label_positions) do
			local kills = wesnoth.get_variable("creepwars_kills_" .. team)
			local cost = creepwars_kills_to_cost(kills)
			wesnoth.wml_actions.label {
				x = pos.x,
				y = pos.y,
				text = math.floor(cost * 100) / 100,
				color = "250,200,0"
			}
		end
	end
end
display_kills()


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
creepwars_display_kills = display_kills
creepwars_get_team_id = get_team_id

-- >>
