-- << legacy_leader_variables

local wesnoth = wesnoth

local function setup(side_number, limbo_x, limbo_y, home_x, home_y)
	-- print("setting up leader: ", side_number, limbo_x, limbo_y, home_x, home_y)
	for _, unit in ipairs(wesnoth.get_units { side = side_number, canrecruit = true }) do
		unit.variables["location"] = "limbo"
		unit.variables.limbo_x = limbo_x
		unit.variables.limbo_y = limbo_y
		unit.variables.home_x = home_x
		unit.variables.home_y = home_y
		unit.variables.healed_this_turn = false
		unit.variables.healed_last_turn = false
	end
end

setup(1, 4, 2, 11, 9)
setup(2, 28, 2, 25, 12)
setup(3, 6, 2, 11, 11)
setup(5, 30, 2, 25, 10)
setup(6, 8, 2, 11, 12)
setup(7, 32, 2, 25, 9)


-- >>
