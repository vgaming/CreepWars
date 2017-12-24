-- << shop_heal

local wesnoth = wesnoth
local ipairs = ipairs
local math = math
local creepwars = creepwars
local is_ai_array = creepwars.is_ai_array
local side_to_team = creepwars.side_to_team

-- UGLY INLINE HACK!!!!!!!!!!!!!!!!!!!!!!
local team_shop_pos = { { ["8,9"] = true, ["8,11"] = true }, { ["28,9"] = true, ["28,11"] = true } }
local function is_at_shop(side, x,y)
	return team_shop_pos[side_to_team[side]][x .. "," .. y]
end


local function full_heal(unit)
	unit.hitpoints = math.max(unit.hitpoints, unit.max_hitpoints)
	unit.status.poisoned = false
	unit.status.slowed = false
	unit.status.petrified = false
end


local translate = wesnoth.textdomain("wesnoth-Creep_Wars")


local function get_color()
	if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
		return wesnoth.sides[wesnoth.current.side].color
	else
		return 'white'
	end
end


local function moveto_event()
	local x1 = wesnoth.get_variable("x1") or 0
	local y1 = wesnoth.get_variable("y1") or 0
	local unit = wesnoth.get_unit(x1, y1)
	if unit and is_ai_array[wesnoth.current.side] == false then

		local x2 = wesnoth.get_variable("x2") or 0
		local y2 = wesnoth.get_variable("y2") or 0
		if is_at_shop(unit.side, x1, y1) then
			full_heal(unit)
			local text = "<span color='" .. get_color() .. "'>" .. unit.name .. " " .. translate("is at the shop") .. "</span>"
			wesnoth.wml_actions.print { size = 24, duration = 200, text = text }
		end

		if is_at_shop(unit.side, x2, y2) then
			local text = "<span color='" .. get_color() .. "'>" .. unit.name .. " " .. translate("has left the shop") .. "</span>"
			wesnoth.wml_actions.print { size = 24, duration = 100, text = text }
		end

	end
end


local function heal_static()
	local side = wesnoth.current.side
	for _, unit in ipairs(wesnoth.get_units { canrecruit = true, side = side }) do
		if is_ai_array[side] == false and is_at_shop(unit.side, unit.x, unit.y) then
			full_heal(unit)
		end
	end
end


creepwars.moveto_event = moveto_event
creepwars.heal_static = heal_static

-- >>
