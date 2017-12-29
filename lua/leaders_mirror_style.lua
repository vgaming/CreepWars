-- << leaders_mirror_style

local wesnoth = wesnoth
local creepwars = creepwars
local helper = wesnoth.require "lua/helper.lua"
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
local array_map = creepwars.array_map
local format = creepwars.format
local is_ai_array = creepwars.is_ai_array
local leader_strength = creepwars.leader_strength
local mirror_style = creepwars.mirror_style
local recruitable_array = creepwars.recruitable_array
local split_comma = creepwars.split_comma


local function set_type(unit, type)
	wesnoth.transform_unit(unit, type)
	unit.attacks_left = unit.max_attacks
	unit.hitpoints = unit.max_hitpoints
	unit.moves = unit.max_moves
end


local function downgrade_wesnoth113(max_leader_level)
	for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
		if is_ai_array[unit.side] ~= true then
			local downgrade_array = wesnoth.unit_types[unit.type].advances_from
			if downgrade_array and #downgrade_array > 0 and wesnoth.unit_types[unit.type].level == max_leader_level then
				-- local downgrade = downgrade_array[helper.rand("1.." .. #downgrade_array + 1)]
				local downgrade = downgrade_array[1] -- need the same for true mirror
				set_type(unit, downgrade)
			end
		end
	end
end

local function downgrade_wesnoth112(max_leader_level)
	local downgrade_map = {} -- map unit -> downgrades
	for unit_name, unit_data in pairs(wesnoth.unit_types) do
		for _, adv in ipairs(split_comma(unit_data.__cfg.advances_to)) do
			downgrade_map[adv] = downgrade_map[adv] or {}
			local arr = downgrade_map[adv]
			arr[#arr + 1] = unit_name
		end
	end

	for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
		local downgrade_array = downgrade_map[unit.type]
		if is_ai_array[unit.side] ~= true
			and downgrade_array and #downgrade_array > 0
			and wesnoth.unit_types[unit.type].level == max_leader_level then

			local downgrade = downgrade_array[1] -- need the same for true mirror
			set_type(unit, downgrade)
		end
	end
end


local function downgrade_wesnoth_any()
	if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
		downgrade_wesnoth113(2)
	else
		downgrade_wesnoth112(2)
	end
end


local function set_all_leaders(unit_array_function)
	local team_units = {}
	local team_index = {}
	for _, side in ipairs(wesnoth.sides) do
		local has_leaders = #wesnoth.get_units { canrecruit = true, side = side.side } > 0
		local is_human = is_ai_array[side.side] ~= true
		if has_leaders and is_human then
			team_units[side.team_name] = team_units[side.team_name] or unit_array_function()
			team_index[side.team_name] = team_index[side.team_name] or 1
			local type = team_units[side.team_name][team_index[side.team_name]]
			for _, unit in ipairs(wesnoth.get_units { canrecruit = true, side = side.side }) do
				set_type(unit, type)
			end
			team_index[side.team_name] = team_index[side.team_name] + 1
		end
	end
end


local leader_rand_string = "1.." .. #recruitable_array
local function random_leader() return recruitable_array[helper.rand(leader_rand_string)] end


local function force_mirror()
	local units = {}
	local team
	for _, side in ipairs(wesnoth.sides) do
		local has_leaders = #wesnoth.get_units { canrecruit = true, side = side.side } > 0
		local is_human = is_ai_array[side.side] ~= true
		if has_leaders and is_human then
			if team == nil then team = side.team_name end
			if team == side.team_name then
				units[#units + 1] = wesnoth.get_units { canrecruit = true, side = side.side }[1].type
			end
		end
	end
	if #units < 4 then units[#units + 1] = random_leader() end
	if #units < 4 then units[#units + 1] = random_leader() end
	if #units < 4 then units[#units + 1] = random_leader() end
	set_all_leaders(function() return units end)
end

local function force_same_strength()

	local function rnd_array() return { random_leader(), random_leader(), random_leader(), random_leader() } end

	local function array_cost(arr)
		local result = 0
		for _, u in ipairs(arr) do result = result + leader_strength[u] end
		return result
	end

	local reference = rnd_array()
	local reference_cost = array_cost(reference)

	local function generate_similar()
		local result
		repeat
			result = rnd_array()
			local cost = array_cost(result)
		until cost > 0.90 * reference_cost and cost < 1.10 * reference_cost
		return result
	end

	return set_all_leaders(generate_similar)
end

local function force_same_cost()

	local reference = { random_leader(), random_leader(), random_leader(), random_leader() }

	local function generate_array()
		local result_array = array_map(reference, function(ref_unit)
			local unit
			repeat
				unit = random_leader()
			until wesnoth.unit_types[unit].__cfg.cost == wesnoth.unit_types[ref_unit].__cfg.cost
			return unit
		end)
		return result_array
	end

	return set_all_leaders(generate_array)
end

print("creepwars mirror_style is ", mirror_style)
if mirror_style == "manual_no_downgrade" then
	-- done
elseif mirror_style == "manual" then
	downgrade_wesnoth_any()
elseif mirror_style == "mirror" then
	downgrade_wesnoth_any()
	force_mirror()
elseif mirror_style == "same_cost" then
	force_same_cost()
elseif mirror_style == "same_strength" then
	force_same_strength()
else
	error("Unknown leader mirror style: " .. format(mirror_style))
end


-- >>
