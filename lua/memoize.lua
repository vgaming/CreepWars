-- << memoize.lua  wesnoth preprocessor escape characters
local wesnoth = wesnoth
local isWesnoth13 = wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.0")

wesnoth.message("Development Creep Wars", "Changelog: 1. Add more creep types 2. Increase creep strength.")
wesnoth.message("Development Creep Wars", "Please write feedback and any ideas you have.")

--local human_side_set = {}
--do
--	local str = ""
--	for _, side in ipairs(wesnoth.get_sides({ controller = "human" })) do
--		if str ~= "" then
--			str = str .. ","
--		end
--		str = str .. side.side
--		human_side_set[side.side] = true
--	end
--	wesnoth.set_variable("creepwars_human_sides", str)
--end


local ai_side_set = {}
do
	for _, side in pairs(wesnoth.sides) do
		if side.controller == "ai" or side.controller == "network_ai" then
			ai_side_set[side.side] = true
		end
	end
end


local starting_positions = {}
do
	local best_unit_for_side = {}
	for _, v in ipairs(wesnoth.get_units { canrecruit = true }) do
		local previous = best_unit_for_side[v.side]
		if not (previous and previous.__cfg.level >= v.__cfg.level and previous.__cfg.cost >= v.__cfg.cost) then
			best_unit_for_side[v.side] = v
			print("Starting position for side " .. v.side .. " is " .. v.x .. "," .. v.y)
			starting_positions[v.side] = { x = v.x, y = v.y }
		end
	end
	-- UGLY INLINE HACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!:
	starting_positions[4] = {x = 32, y = 10}
	starting_positions[8] = {x = 4, y = 10}
	-- UGLY INLINE HACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end


if isWesnoth13 then -- unit.upkeep
	local all = wesnoth.get_units {}
	for _, u in ipairs(all) do
		u.upkeep = 0
	end
end

creepwars_memoize_starting_positions = starting_positions
creepwars_memoize_ai_side_set = ai_side_set

-- >>
