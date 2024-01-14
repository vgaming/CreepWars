-- << unit_analyze_common | Creep_War_Dev
if rawget(_G, "unit_analyze_common | Creep_War_Dev") then
	-- TODO: remove this code once https://github.com/wesnoth/wesnoth/issues/8157 is fixed
	return
else
	rawset(_G, "unit_analyze_common | Creep_War_Dev", true)
end

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local helper = wesnoth.require("lua/helper.lua")
local split_comma = creepwars.split_comma


local era_array = {}
local era_set = {}

local function init_era()
	for multiplayer_side in helper.child_range(wesnoth.game_config.era, "multiplayer_side") do
		local units = multiplayer_side.recruit or multiplayer_side.leader or ""
		for _, unit in ipairs(split_comma(units)) do
			if era_set[unit] == nil and wesnoth.unit_types[unit] then
				-- print("importing era unit " .. unit)
				era_set[unit] = true
				era_array[#era_array + 1] = unit
			end
		end
	end
end
if not pcall(init_era) then
	local msg = "Failed to load Era " .. wesnoth.game_config.mp_settings.mp_era
	wesnoth.wml_actions.message { caption = "Creep Wars", message = msg }
	wesnoth.message("Creep Wars", msg)
	wesnoth.wml_actions.endlevel { result = "defeat" }
	init_era()
end

local function unit_count_specials(unit)
	local result = {}
	for attack in helper.child_range(wesnoth.unit_types[unit].__cfg, "attack") do
		for specials in helper.child_range(attack, "specials") do
			for _, special in ipairs(specials) do
				local name = special[1]
				result[name] = (result[name] or 0) + 1
			end
		end
	end
	return result
end


local function add_advances(arr, set, filter)
	set = set or creepwars.array_to_set(arr)
	filter = filter or function(_) return true end
	for _, unit in ipairs(arr) do
		for _, adv in ipairs(wesnoth.unit_types[unit].advances_to) do
			if set[adv] == nil and filter(adv) then
				set[adv] = true
				arr[#arr + 1] = adv
			end
		end
	end
end


local function can_be_a_leader(unit_type)
	if creepwars.allow_overpowered then
		return unit_type ~= "Fog Clearer"
			and wesnoth.unit_types[unit_type].level == 1
	else
		local advance_array = { unit_type }
		add_advances(advance_array, nil, nil)
		for _, adv in ipairs(advance_array) do
			if unit_count_specials(adv)["berserk"] ~= nil then
				return false
			end
		end
		return unit_count_specials(unit_type)["plague"] == nil
			and unit_type ~= "Ghost" -- ugly hack until "resistances" is calculated properly
			and wesnoth.unit_types[unit_type].level == 1
	end
end


local era_unit_rand_string = "1.." .. #era_array
local function random_leader()
	while true do
		local candidate = era_array[mathx.random_choice(era_unit_rand_string)]
		if can_be_a_leader(candidate) then
			return candidate
		end
	end
end


local downgrade_map
local function unit_downgrades(unit)
	if downgrade_map == nil then
		downgrade_map = {}
		for _, unit_name in ipairs(era_array) do
			local unit_data = wesnoth.unit_types[unit_name]
			for _, adv in ipairs(unit_data.advances_to) do
				downgrade_map[adv] = downgrade_map[adv] or {}
				local arr = downgrade_map[adv]
				arr[#arr + 1] = unit_name
			end
		end
	end
	return downgrade_map[unit] or {}
end


creepwars.can_be_a_leader = can_be_a_leader
creepwars.random_leader = random_leader
creepwars.unit_downgrades = unit_downgrades


-- >>
