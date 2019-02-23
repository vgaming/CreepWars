-- << shop_heal

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local math = math
local table = table
local wml = wml
local is_ai_array = creepwars.is_ai_array
local side_to_team = creepwars.side_to_team
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}

local team_shop_set = {}
for team_index, team_arr in ipairs(creepwars.shop_coordinates) do
	local set = {}
	local cumulative_x_coords = {}
	local cumulative_y_coords = {}
	for _, xy in ipairs(team_arr) do
		wesnoth.wml_actions.item {
			x = xy[1],
			y = xy[2],
			image = "terrain/castle/encampment/tent.png"
		}
		wesnoth.wml_actions.label {
			x = xy[1],
			y = xy[2],
			team_name = creepwars.team_array[team_index][1].team_name,
			text = "Shop"
		}
		wesnoth.wml_actions.event {
			name = "turn 2",
			T.label {
				x = xy[1],
				y = xy[2],
				text = "",
				team_name = creepwars.team_array[team_index][1].team_name,
			}
		}
		cumulative_x_coords[#cumulative_x_coords + 1] = xy[1]
		cumulative_y_coords[#cumulative_y_coords + 1] = xy[2]
		set[xy[1] .. "," .. xy[2]] = true
	end

	for side_number, _ in ipairs(wesnoth.sides) do
		if creepwars.side_to_team[side_number] == team_index then
			local start_loc = wesnoth.get_starting_location(side_number)
				cumulative_x_coords[#cumulative_x_coords + 1] = start_loc[1]
				cumulative_y_coords[#cumulative_y_coords + 1] = start_loc[2]
		end
	end

	wesnoth.wml_actions.modify_ai {
		side = creepwars.team_ai_side[team_index],
		action = "add",
		path = "aspect[avoid].facet",
		T.facet {
			engine = "cpp",
			name = "standard_aspect",
			T.value {
				x = table.concat(cumulative_x_coords, ","),
				y = table.concat(cumulative_y_coords, ",")
			}
		}
	}
	team_shop_set[#team_shop_set + 1] = set
end

local function is_at_shop(side, x, y)
	return team_shop_set[side_to_team[side]][x .. "," .. y]
end

local unit_at_shop = function()
	local unit = wesnoth.get_unit(wml.variables.x1, wml.variables.y1)
	return unit
		and unit.canrecruit
		and unit.side == wesnoth.current.side
		and team_shop_set[side_to_team[unit.side]][unit.x .. "," .. unit.y]
end


local function full_heal(unit)
	unit.hitpoints = math.max(unit.hitpoints, unit.max_hitpoints)
	unit.status.poisoned = false
	unit.status.slowed = false
	unit.status.petrified = false
end


local function moveto_event()
	local x1 = wesnoth.get_variable("x1") or 0
	local y1 = wesnoth.get_variable("y1") or 0
	local unit = wesnoth.get_unit(x1, y1)
	if unit and is_ai_array[wesnoth.current.side] == false then
		if is_at_shop(unit.side, x1, y1) then
			full_heal(unit)
			creepwars.show_shop_menu()
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

creepwars_unit_at_shop = unit_at_shop

-- >>
