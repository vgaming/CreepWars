-- << first_turn_advantage

local wesnoth = wesnoth
local creepwars = creepwars
local assert = assert
local ipairs = ipairs
local print = print
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}


local function first_turn_advantage_register(side, value)
	assert(wesnoth.current.turn == 1)
	for _, unit in ipairs(wesnoth.get_units { side = side }) do
		local ability = T._ { name = "first turn advantage", description = "+2 movement" }
		wesnoth.add_modification(unit, "object", {
			T.effect { apply_to = "new_ability", T.abilities { ability } },
			duration = "turn",
		})
		wesnoth.add_modification(unit, "object", {
			T.effect { apply_to = "movement", increase = value },
		})
	end

	wesnoth.wml_actions.event {
		name = "side " .. side .. " turn 1",
		T.lua { code = "creepwars.first_turn_advantage_fix_moves()" }
	}
	wesnoth.wml_actions.event {
		name = "side " .. side .. " turn 1 end",
		T.lua { code = "creepwars.first_turn_advantage_remove_object()" }
	}
end


local function first_turn_advantage_fix_moves()
	print("setting moves for side", wesnoth.current.side)
	for _, unit in ipairs(wesnoth.get_units { side = wesnoth.current.side }) do
		unit.moves = unit.max_moves
	end
end


local function first_turn_advantage_remove_object()
	for _, unit in ipairs(wesnoth.get_units { side = wesnoth.current.side }) do
		wesnoth.add_modification(unit, "object", {
			T.effect { apply_to = "movement", increase = -2 },
		})
	end
end


creepwars.first_turn_advantage_register = first_turn_advantage_register
creepwars.first_turn_advantage_fix_moves = first_turn_advantage_fix_moves
creepwars.first_turn_advantage_remove_object = first_turn_advantage_remove_object

-- >>
