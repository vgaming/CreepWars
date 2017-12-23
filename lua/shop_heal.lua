-- << shop_heal

local wesnoth = wesnoth
local ipairs = ipairs
local math = math
local creepwars = creepwars
local is_ai_array = creepwars.is_ai_array
local side_to_team = creepwars.side_to_team

-- UGLY INLINE HACK!!!!!!!!!!!!!!!!!!!!!!
local team_shop_pos = { { ["8,9"] = true, ["8,11"] = true }, { ["28,9"] = true, ["28,11"] = true } }


local function heal_moveto()
	local x1 = wesnoth.get_variable("x1") or 0
	local y1 = wesnoth.get_variable("y1") or 0
	local unit = wesnoth.get_unit(x1, y1)
	local team = unit and side_to_team[unit.side]
	if unit and is_ai_array[wesnoth.current.side] == false and team_shop_pos[team][x1 .. "," .. y1] then
		unit.hitpoints = math.max(unit.hitpoints, unit.max_hitpoints)
	end
end


local function heal_static()
	local side = wesnoth.current.side
	local team = side_to_team[side]
	for _, unit in ipairs(wesnoth.get_units { canrecruit = true, side = side }) do
		if is_ai_array[side] == false and team_shop_pos[team][unit.x .. "," .. unit.y] then
			unit.hitpoints = math.max(unit.hitpoints, unit.max_hitpoints)
		end
	end
end


creepwars.heal_moveto = heal_moveto
creepwars.heal_static = heal_static

-- >>
