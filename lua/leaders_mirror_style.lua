-- << leaders_mirror_style

local wesnoth = wesnoth
local creepwars_memoize_ai_side_set = creepwars_memoize_ai_side_set
local creepwars_mirror_style = creepwars_mirror_style
local creepwars_side_to_team = creepwars_side_to_team

local function downgrade()
	for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
		if creepwars_memoize_ai_side_set[unit.side] ~= true then
			local downgrade = wesnoth.unit_types[unit.type].advances_from[1]
			if downgrade then
				wesnoth.transform_unit(unit, downgrade)
				unit.hitpoints = unit.max_hitpoints
			end
		end
	end
end

local function force_mirror()
	-- map team to sides
	local team_sides = {}
	for _, side in ipairs(wesnoth.sides) do
		local has_leaders = #wesnoth.get_units { canrecruit = true, side = side.side } > 0
		local is_human = creepwars_memoize_ai_side_set[side.side] ~= true
		if has_leaders and is_human then
			local team = creepwars_side_to_team[side.side]
			team_sides[team] = team_sides[team] or {}
			local arr = team_sides[team]
			arr[#arr + 1] = side.side
		end
	end

	-- find biggest side array
	local biggest_array = {}
	for _, side in ipairs(wesnoth.sides) do
		local team = creepwars_side_to_team[side.side]
		local side_array = team_sides[team]
		if #side_array > #biggest_array then biggest_array = side_array end
	end
	-- unit array
	local unit_types = {}
	for i, side_number in ipairs(biggest_array) do
		unit_types[i] = wesnoth.get_units { canrecruit = true, side = side_number }[1].type
		assert(unit_types[i] ~= nil, "Side " .. side_number .. " has no leaders")
	end
	-- set the leaders
	for _, side_array in pairs(team_sides) do
		for side_number_in_team, side_number in ipairs(side_array) do
			print("side number: " .. side_number)
			for _, unit in ipairs(wesnoth.get_units { canrecruit = true, side = side_number }) do
				wesnoth.transform_unit(unit, unit_types[side_number_in_team])
			end
		end
	end
end

if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
	print("creepwars_mirror_style is " .. creepwars_mirror_style)
	if creepwars_mirror_style == "random_no_downgrade" then
		-- done
	elseif creepwars_mirror_style == "random" then
		downgrade()
	elseif creepwars_mirror_style == "mirror" then
		force_mirror()
		downgrade()
	else
		error("Unknown leader mirror style: " .. creepwars_mirror_style)
	end
end


-- >>
