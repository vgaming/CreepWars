-- << first_turn_advantage | Creep_War_Dev
if rawget(_G, "first_turn_advantage | Creep_War_Dev") then
	-- TODO: remove this code once https://github.com/wesnoth/wesnoth/issues/8157 is fixed
	return
else
	rawset(_G, "first_turn_advantage | Creep_War_Dev", true)
end

local wesnoth = wesnoth
local creepwars = creepwars
local assert = assert
local ipairs = ipairs
local T = wml.tag

wesnoth.wml_actions.event {
	name = "turn 2",
	T.lua { code = [[ wesnoth.wml_actions.remove_object{object_id="creep_wars_first_turn"} ]] }
}

local function first_turn_advantage_register(side, value)
	wesnoth.wml_actions.event {
		name = "side " .. side .. " turn 1",
		T.lua { code = "creepwars.first_turn_advantage_add_moves(" .. value .. ")" }
	}
	for _, unit in ipairs(wesnoth.get_units { side = side }) do
		local ability = T.dummy {
			name = "first turn advantage",
			description = "+" .. value .. " movement on turn 1"
		}
		wesnoth.units.add_modification(unit, "object", {
			T.effect { apply_to = "new_ability", T.abilities { ability } },
			id = "creep_wars_first_turn",
		})
	end
end


local function first_turn_advantage_add_moves(value)
	assert(wesnoth.current.turn == 1)
	for _, unit in ipairs(wesnoth.get_units { side = wesnoth.current.side }) do
		unit.moves = unit.moves + value
	end
end


creepwars.first_turn_advantage_add_moves = first_turn_advantage_add_moves
creepwars.first_turn_advantage_register = first_turn_advantage_register

-- >>
