-- << first_turn_advantage

-- A number of ugly hacks is used here to do a very simple operation:
-- give side +N movement on turn 1.
--
-- When wesnoth-1.12 stops being supported, consider cleaning this file up.
--
-- Maybe this could also work for 1.12, though no big point in doing so:
-- https://wiki.wesnoth.org/DirectActionsWML#.5Bmodify_unit.5D

local wesnoth = wesnoth
local creepwars = creepwars
local assert = assert
local ipairs = ipairs
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}


local function register_1_12(side, value)
	wesnoth.wml_actions.event {
		name = "start",
		T.lua { code = "creepwars.first_turn_advantage_add_object(" .. side .. ", " .. value .. ")" }
	}
	wesnoth.wml_actions.event {
		name = "side " .. side .. " turn 1",
		T.lua { code = "creepwars.first_turn_advantage_fix_moves()" }
	}
	wesnoth.wml_actions.event {
		name = "side " .. side .. " turn 1 end",
		T.lua { code = "creepwars.first_turn_advantage_remove_object(" .. value .. ")" }
	}
end


local function register_1_13(side, value)
	wesnoth.wml_actions.event {
		name = "side " .. side .. " turn 1",
		T.lua { code = "creepwars.first_turn_advantage_add_moves_1_13(" .. value .. ")" }
	}
end


local function first_turn_advantage_register(side, value)
	if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
		register_1_13(side, value)
	else
		register_1_12(side, value)
	end
end


local function first_turn_advantage_add_object(side, value)
	assert(wesnoth.current.turn == 1)
	for _, unit in ipairs(wesnoth.get_units { side = side }) do
		local ability = T.dummy {
			name = "first turn advantage",
			description = "+" .. value .. " movement on turn 1"
		}
		wesnoth.add_modification(unit, "object", {
			T.effect { apply_to = "new_ability", T.abilities { ability } },
			duration = "turn",
		})
		wesnoth.add_modification(unit, "object", {
			T.effect { apply_to = "movement", increase = value },
		})
	end
end


local function first_turn_advantage_fix_moves()
	-- print("setting moves for side", wesnoth.current.side)
	assert(wesnoth.current.turn == 1)
	for _, unit in ipairs(wesnoth.get_units { side = wesnoth.current.side }) do
		unit.moves = unit.max_moves
	end
end


local function first_turn_advantage_add_moves_1_13(value)
	assert(wesnoth.current.turn == 1)
	for _, unit in ipairs(wesnoth.get_units { side = wesnoth.current.side }) do
		unit.moves = unit.moves + value
	end
end


local function first_turn_advantage_remove_object(value)
	assert(wesnoth.current.turn == 1)
	for _, unit in ipairs(wesnoth.get_units { side = wesnoth.current.side }) do
		wesnoth.add_modification(unit, "object", {
			T.effect { apply_to = "movement", increase = -value },
		})
	end
end


creepwars.first_turn_advantage_add_moves_1_13 = first_turn_advantage_add_moves_1_13
creepwars.first_turn_advantage_add_object = first_turn_advantage_add_object
creepwars.first_turn_advantage_fix_moves = first_turn_advantage_fix_moves
creepwars.first_turn_advantage_register = first_turn_advantage_register
creepwars.first_turn_advantage_remove_object = first_turn_advantage_remove_object

-- >>
