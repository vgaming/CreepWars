-- << unit_analyze_common

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local pcall = pcall
local helper = wesnoth.require("lua/helper.lua")
local array_filter = creepwars.array_filter
local split_comma = creepwars.split_comma


local creep_array = creepwars.default_era_creeps

local era_array = {}
local era_set = {}
local era_id = wesnoth.game_config.mp_settings.mp_era == "Creep_War_Era_v0.3.5"
	and "era_default"
	or wesnoth.game_config.mp_settings.mp_era
if not pcall(function() return wesnoth.get_era(era_id).id end) then
	-- this cannot happen on wesnoth-1.13,
	-- but does happen on 1.12 for a multiplayer game if the host
	-- has a specific add-on, but observers and/or players do not.
	creepwars.wesnoth_message {
		message = "ERROR: Unknown Era:\n\n" .. wesnoth.game_config.mp_settings.mp_era
			.. "\n\nPlease ask game host to choose another Era (for example, Default)."
			--		.. ",\nor download " .. wesnoth.game_config.mp_settings.mp_era .. " yourself."
			.. "\n\nSorry for the inconvenience.",
		image = "misc/red-x.png"
	}
end
for multiplayer_side in helper.child_range(wesnoth.get_era(era_id), "multiplayer_side") do
	local units = multiplayer_side.recruit or multiplayer_side.leader or ""
	for _, unit in ipairs(split_comma(units)) do
		if era_set[unit] == nil and wesnoth.unit_types[unit] then
			-- print("importing era unit " .. unit)
			era_set[unit] = true
			era_array[#era_array + 1] = unit
		end
	end
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


local function can_be_a_leader(unit_type)
	if creepwars.forbid_berserkers then
		local advance_array = { unit_type }
		creepwars.add_advances(advance_array, nil, nil)
		for _, adv in ipairs(advance_array) do
			if unit_count_specials(adv)["berserk"] ~= nil then
				return false
			end
		end
	end
	return unit_count_specials(unit_type)["plague"] == nil
		and unit_count_specials(unit_type)["berserk"] == nil
		and unit_type ~= "Fog Clearer"
		and wesnoth.unit_types[unit_type].level <= 1
end


local all_leaders_array = array_filter(era_array, can_be_a_leader)


local downgrade_map = {}
for _, unit_name in ipairs(era_array) do
	local unit_data = wesnoth.unit_types[unit_name]
	for _, adv in ipairs(creepwars.split_comma(unit_data.__cfg.advances_to)) do
		downgrade_map[adv] = downgrade_map[adv] or {}
		local arr = downgrade_map[adv]
		arr[#arr + 1] = unit_name
	end
end
local function unit_downgrades(unit)
	return downgrade_map[unit] or {}
end


creepwars.can_be_a_leader = can_be_a_leader
creepwars.creep_array = creep_array
creepwars.all_leaders_array = all_leaders_array
creepwars.unit_downgrades = unit_downgrades


-- >>
