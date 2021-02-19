-- << random_map

local helper = wesnoth.require("lua/helper.lua")

local terrain_base_probabilities = {
	["Gs"] = 2, -- grass
	["Gd"] = 2, -- grass
	["Gg"] = 2, -- grass
	["Wwf"] = 20, -- ford
	["Gs^Fms"] = 2, -- forest
	["Gll^Fp"] = 2, -- forest
	["Mm"] = 1, -- mountain
	["Ai"] = 1, -- ice
	["Hh"] = 2, -- hill
	["Hhd"] = 2, -- dry hill
	["Uu^Uf"] = 2, -- mushrooms
	["Dd^Do"] = 0, -- oasis
	["Ss"] = 1, -- swamp
	["Gs^Vh"] = 0, -- village
}
local terrain_variability_multiplier = 1 -- how variable terrain will be
local terrain_iterator = {}
local terrain_total = 0
local function set_probability(terrain_index, value)
	wesnoth.set_variable("afterlife_terrain_prob_" .. terrain_index, value)
end
local function get_probability(terrain_index)
	return wesnoth.get_variable("afterlife_terrain_prob_" .. terrain_index)
end

for terr, value in pairs(terrain_base_probabilities) do
	-- We will need to sort this later because `pairs` is an unordered (OOS-unsafe) iterator
	terrain_total = terrain_total + value
	terrain_iterator[#terrain_iterator + 1] = terr
end
table.sort(terrain_iterator)
for idx, terr in ipairs(terrain_iterator) do
	if get_probability(idx) == nil then
		local base = terrain_base_probabilities[terr]
		set_probability(idx, base * terrain_variability_multiplier)
	end
end

local function random_terrain()
	local offset = helper.rand("1.." .. terrain_total * terrain_variability_multiplier)
	for idx, terrain in ipairs(terrain_iterator) do
		offset = offset - get_probability(idx)
		if offset <= 0 then
			-- Now that this terrain is chosen, decrease the chosen terr probability by total,
			-- and add a distributed base to all terrains
			set_probability(idx, get_probability(idx) - terrain_total)
			for small_idx, small_terrain in ipairs(terrain_iterator) do
				local base = terrain_base_probabilities[small_terrain]
				set_probability(small_idx, get_probability(small_idx) + base)
			end
			return terrain
		end
	end
	return "Aa^Ecf" -- snow with fire (to see the error)
end

local function is_near_leader(x, y)
	for adj_x, adj_y in helper.adjacent_tiles(x, y) do
		if wesnoth.get_unit { x = adj_x, y = adj_y, canrecruit = true } then
			return true
		end
	end
	return wesnoth.get_unit { x = x, y = y, canrecruit = true } ~= nil
end

local drake = wesnoth.create_unit { type = "Drake Burner" }
for x = 14, 22, 1 do
	for y = 4, 10, 1 do
		local terr = wesnoth.get_terrain(x, y)
		local info = wesnoth.get_terrain_info(terr)
		local move_cost = wesnoth.unit_movement_cost(drake, terr)
		if move_cost < 50 and not info.castle and not is_near_leader(x, y) then
			wesnoth.set_terrain(x, y, random_terrain())
		end
	end
end
wesnoth.wml_actions.redraw {}


-- >>
